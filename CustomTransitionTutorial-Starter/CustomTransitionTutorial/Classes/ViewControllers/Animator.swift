//
//  Animator.swift
//  CustomTransitionTutorial
//
//  Created by Tung on 27.11.19.
//  Copyright © 2019 Tung. All rights reserved.
//

import UIKit

/// Presentation or dismissal animation 담당
final class Animator
: NSObject,
  UIViewControllerAnimatedTransitioning {
  
  static let duration: TimeInterval = 1.25
  
  private let type: PresentationType
  private let firstViewController: FirstViewController
  private let secondViewController: SecondViewController
  private var selectedCellImageViewSnapshot: UIView
  private let cellImageViewRect: CGRect
  
  private let cellLabelRect: CGRect
  
  /// 실패 가능한 이니셜라이져를 사용함으로써 실패했을 경우, 기본 애니메이션을 사용한다.
  init?(
    type: PresentationType,
    firstViewController: FirstViewController,
    secondViewController: SecondViewController,
    selectedCellImageViewSnapshot: UIView
  ) {
    // return nil -> 기본 애니메이션 실행
    
    self.type = type
    self.firstViewController = firstViewController
    self.secondViewController = secondViewController
    self.selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
    
    guard let window = firstViewController.view.window ?? secondViewController.view.window,
          let selectedCell = firstViewController.selectedCell else { return nil }
    
    self.cellImageViewRect = selectedCell.locationImageView.convert(selectedCell.locationImageView.bounds, to: window)
    
    self.cellLabelRect = selectedCell.locationLabel.convert(selectedCell.locationLabel.bounds, to: window)
  }
  
  func transitionDuration(
    using transitionContext: UIViewControllerContextTransitioning?
  ) -> TimeInterval {
    return Self.duration
  }
  
  /// 모든 화면 전환 논리와 애니메이션 구현
  func animateTransition(
    using transitionContext: UIViewControllerContextTransitioning
  ) {
    let containerView = transitionContext.containerView // firstVC와 secondVC 사이에 애니메이션을 보여주는 뷰
    
    guard let toView = secondViewController.view else {
      transitionContext.completeTransition(false) // 실패 시 화면 전환이 일어나지 않는다.
      return
    }
    
    containerView.addSubview(toView)
    
    guard let selectedCell = firstViewController.selectedCell,
          let window = firstViewController.view.window ?? secondViewController.view.window,
          let cellImageSnapshot = selectedCell.locationImageView.snapshotView(afterScreenUpdates: true),
          let controllerImageSnapshot = secondViewController.locationImageView.snapshotView(afterScreenUpdates: true),
          let cellLabelSnapshot = selectedCell.locationLabel.snapshotView(afterScreenUpdates: true),
          let closeButtonSnapshot = secondViewController.closeButton.snapshotView(afterScreenUpdates: true)
    else {
      transitionContext.completeTransition(true)
      return
    }
    
    let isPresenting = type.isPresenting
    
    let backgroundView: UIView
    let fadeView = UIView(frame: containerView.bounds)
    fadeView.backgroundColor = secondViewController.view.backgroundColor
    
    if isPresenting {
      selectedCellImageViewSnapshot = cellImageSnapshot
      
      backgroundView = UIView(frame: containerView.bounds)
      backgroundView.addSubview(fadeView)
      fadeView.alpha = 0
    } else {
      backgroundView = firstViewController.view.snapshotView(afterScreenUpdates: true) ?? fadeView
      backgroundView.addSubview(fadeView)
    }
    
    toView.alpha = 0
    
    // 애니메이션화될 2개의 스냅샷 추가
    [backgroundView,
     selectedCellImageViewSnapshot,
     controllerImageSnapshot,
     cellLabelSnapshot,
     closeButtonSnapshot
    ].forEach { containerView.addSubview($0) } // 나중에 더 많은 뷰가 추가될 예정
    
    let controllerImageViewRect = secondViewController.locationImageView.convert(secondViewController.locationImageView.bounds, to: window)
    
    let controllerLabelRect = secondViewController.locationLabel.convert(secondViewController.locationLabel.bounds, to: window)
    
    let closeButtonRect = secondViewController.closeButton.convert(secondViewController.closeButton.bounds, to: window)
    
    [selectedCellImageViewSnapshot, controllerImageSnapshot].forEach {
      $0.frame = isPresenting ? cellImageViewRect : controllerImageViewRect
    }
    
    controllerImageSnapshot.alpha = isPresenting ? 0 : 1
    
    selectedCellImageViewSnapshot.alpha = isPresenting ? 1 : 0
    
    cellLabelSnapshot.frame = isPresenting ? cellLabelRect : controllerLabelRect
    
    closeButtonSnapshot.frame = closeButtonRect
    closeButtonSnapshot.alpha = isPresenting ? 0 : 1
    
    UIView.animateKeyframes(withDuration: Self.duration, delay: 0, options: .calculationModeCubic, animations: {
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
        self.selectedCellImageViewSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect
        controllerImageSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect
        
        // fade 애니메이션을 위해 fade view의 alpha 값 변경
        fadeView.alpha = isPresenting ? 1 : 0
        
        cellLabelSnapshot.frame = isPresenting ? controllerLabelRect : self.cellLabelRect // 빼면 레이블 애니메이션이 들어가지 않는다.
        
        [controllerImageSnapshot, self.selectedCellImageViewSnapshot].forEach {
          $0.layer.cornerRadius = isPresenting ? 0 : 12
        }
      }
      
      UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6) {
        self.selectedCellImageViewSnapshot.alpha = isPresenting ? 0 : 1
        controllerImageSnapshot.alpha = isPresenting ? 1: 0
      }
      
      UIView.addKeyframe(withRelativeStartTime: isPresenting ? 0.7 : 0, relativeDuration: 0.3) {
        closeButtonSnapshot.alpha = isPresenting ? 1 : 0
      }
    }, completion: { _ in
      
      self.selectedCellImageViewSnapshot.removeFromSuperview()
      controllerImageSnapshot.removeFromSuperview()
      backgroundView.removeFromSuperview()
      cellLabelSnapshot.removeFromSuperview()
      closeButtonSnapshot.removeFromSuperview()
      
      toView.alpha = 1
      
      transitionContext.completeTransition(true)
    })
  }
}

enum PresentationType {
  case present
  case dismiss
  
  var isPresenting: Bool {
    return self == .present
  }
}
