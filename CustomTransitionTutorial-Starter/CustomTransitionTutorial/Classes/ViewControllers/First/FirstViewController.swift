//
//  FirstViewController.swift
//  CustomTransitionDemo
//
//  Created by Tung on 12.10.19.
//  Copyright © 2019 Tung. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
  
  /// 선택된(탭) 셀
  var selectedCell: CollectionViewCell?
  
  /// 선택된 셀의 이미지 뷰 스냅샷
  /// 스냅샷: 뷰의 현재 렌더링된 뷰
  var selectedCellImageViewSnapshot: UIView?
  
  @IBOutlet private var collectionView: UICollectionView!
  
  var animator: Animator?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    let layout = UICollectionViewFlowLayout()
    layout.minimumLineSpacing = Constants.cellSpacing
    layout.minimumInteritemSpacing = Constants.cellSpacing
    
    collectionView.setCollectionViewLayout(layout, animated: false)
  }
  
  func presentSecondViewController(with data: CellData) {
    let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
    
    secondViewController.transitioningDelegate = self
    secondViewController.modalPresentationStyle = .fullScreen
    secondViewController.data = data
    present(secondViewController, animated: true)
  }
}

extension FirstViewController {
  
  enum Constants {
    
    static let cellSpacing: CGFloat = 8
  }
}
