//
//  UIViewControllerExtension.swift
//  ArtSpaceDos
//
//  Created by Levi Davis on 3/9/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit

extension UIViewController {
    func showActivityIndicator(shouldShow: Bool) {
        
        if shouldShow {
            let indicatorView = UIView()
            indicatorView.tag = 1
            indicatorView.frame = self.view.frame
            
            indicatorView.backgroundColor = .white
            indicatorView.alpha = 0.0
            
            
            
            let indicator = UIActivityIndicatorView(style: .large)
            indicator.center = self.view.center
            
            
            self.view.addSubview(indicatorView)
            indicatorView.addSubview(indicator)
            indicator.startAnimating()
            UIView.animate(withDuration: 2.0) {
                indicatorView.alpha = 0.7
            }
        } else {
            view.subviews.forEach {subview in
                if subview.tag == 1 {
                    subview.removeFromSuperview()
                }
            }
        }
        
      
        
    }
}
