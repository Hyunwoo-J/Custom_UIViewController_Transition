//
//  FirstViewController+TransitioningDelegate.swift
//  CustomTransitionTutorial
//
//  Created by Tung on 27.11.19.
//  Copyright © 2019 Tung. All rights reserved.
//

import UIKit

extension FirstViewController: UIViewControllerTransitioningDelegate {
  
  func animationController(
    forPresented presented: UIViewController,
    presenting: UIViewController, source: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    return nil
  }
  
  func animationController(
    forDismissed dismissed: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    return nil
  }
}
