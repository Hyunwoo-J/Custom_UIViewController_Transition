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
  private let selectedCellImageViewSnapshot: UIView
  private let cellImageViewRect: CGRect
  
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
    
    transitionContext.completeTransition(true) // 호출됨으로 화면 전환이 완료됨을 알 수 있다.
  }
}

enum PresentationType {
  case present
  case dismiss
  
  var isPResenting: Bool {
    return self == .present
  }
}
