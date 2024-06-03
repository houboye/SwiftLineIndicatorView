//
//  ViewController.swift
//  SwiftLineIndicatorView
//
//  Created by BY H on 2024/6/3.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let line1 = LineIndicatorView(maxLineCount: 4, subLineCornerRadius: 2)
        line1.curProgressRate = 2.2
        
        view.addSubview(line1)
        
        let line1Cx = NSLayoutConstraint(item: line1, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let line1Cy = NSLayoutConstraint(item: line1, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        let line1Ch = NSLayoutConstraint(item: line1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 4)
        let line1L = NSLayoutConstraint(item: line1, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 48)
        let line1T = NSLayoutConstraint(item: line1, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -48)
        
        self.view.addConstraints([line1Cx, line1Cy, line1Ch, line1L, line1T])
    }


}

