//
//  LineIndicatorView.swift
//  SwiftLineIndicatorView
//
//  Created by BY H on 2024/6/3.
//

import UIKit

public class LineIndicatorView: UIView {
    /// maxLineCount show greater then 0
    /// if value is 0, then hidden
    public var maxLineCount: Int = 0
    
    /// this value must less then maxLineCount
    public var curProgressRate: Double = 0 {
        didSet {
            refreshCurProgressRate()
        }
    }
    
    /// each line width, default is 0
    public var eachLineWidth: CGFloat = 0
    
    /// each line spacing, default is 5
    public var spacing: CGFloat
    
    /// the color when normal style
    public var normalColor: UIColor = UIColor.lightGray
    
    /// the color for already done style
    public var processingColor: UIColor = UIColor.black
    
    /// the sub line's cornerRadius
    public var subLineCornerRadius: CGFloat
    
    /// is need show the line when only has one step
    public var isShowWhenOnly1Line: Bool = true
    
    private var subLines = [UIView]()
    
    public init(maxLineCount: Int,
                eachLineWidth: CGFloat = 0,
                spacing: CGFloat = 8,
                subLineCornerRadius: CGFloat = 0,
                isShowWhenOnly1Line: Bool = true) {
        self.maxLineCount = maxLineCount
        self.spacing = spacing
        self.subLineCornerRadius = subLineCornerRadius
        super.init(frame: CGRect.zero)
        self.eachLineWidth = eachLineWidth
        self.isShowWhenOnly1Line = isShowWhenOnly1Line
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        if maxLineCount <= 0 {
            #if DEBUG
            debugPrint("maxLineCount show greater then 0!")
            #endif
            self.isHidden = true
        }
        
        if isShowWhenOnly1Line == false && maxLineCount == 1 {
            self.isHidden = true
            return
        }
        
        var preLine: UIView?
        var tmpConstraints = [NSLayoutConstraint]()
        translatesAutoresizingMaskIntoConstraints = false
        
        for i in 0..<maxLineCount {
            
            let line = UIView()
            line.layer.cornerRadius = subLineCornerRadius
            line.backgroundColor = normalColor
            line.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(line)
            subLines.append(line)
            
            let lineToSuperViewTop = NSLayoutConstraint(item: line,
                       attribute: .top,
                       relatedBy: .equal,
                       toItem: self,
                       attribute: .top,
                       multiplier: 1,
                       constant: 0)

            let lineToSuperViewBottom = NSLayoutConstraint(item: line,
                          attribute: .bottom,
                          relatedBy: .equal,
                          toItem: self,
                          attribute: .bottom,
                          multiplier: 1,
                          constant: 0)
            
            tmpConstraints.append(lineToSuperViewTop)
            tmpConstraints.append(lineToSuperViewBottom)
            
            if let preLine = preLine {
                // layout other line
                let lineToLeading = NSLayoutConstraint(item: line,
                                                             attribute: .leading,
                                                             relatedBy: .equal,
                                                             toItem: preLine,
                                                             attribute: .trailing,
                                                             multiplier: 1,
                                                             constant: spacing)
                
                let lineWidth = NSLayoutConstraint(item: line,
                                                   attribute: .width,
                                                   relatedBy: .equal,
                                                   toItem: preLine,
                                                   attribute: .width,
                                                   multiplier: 1,
                                                   constant: 0)
                tmpConstraints.append(lineToLeading)
                tmpConstraints.append(lineWidth)
            } else {
                // layout first line
                let lineToSuperViewLeading = NSLayoutConstraint(item: line,
                                                             attribute: .leading,
                                                             relatedBy: .equal,
                                                             toItem: self,
                                                             attribute: .leading,
                                                             multiplier: 1,
                                                             constant: 0)
                
                if eachLineWidth > 0 {
                    let lineWidth = NSLayoutConstraint(item: line,
                                                       attribute: .width,
                                                       relatedBy: .equal,
                                                       toItem: nil,
                                                       attribute: .width,
                                                       multiplier: 1,
                                                       constant: eachLineWidth)
                    tmpConstraints.append(lineWidth)
                }
                tmpConstraints.append(lineToSuperViewLeading)
            }
            
            if i == (maxLineCount-1) {
                // layout last line
                let lineToSuperViewRrailing = NSLayoutConstraint(item: line,
                                                              attribute: .trailing,
                                                              relatedBy: .equal,
                                                              toItem: self,
                                                              attribute: .trailing,
                                                              multiplier: 1,
                                                              constant: 0)
                tmpConstraints.append(lineToSuperViewRrailing)
            }
            
            preLine = line
        }
        
        // free
        preLine = nil
        addConstraints(tmpConstraints)
        layoutIfNeeded()
    }
    
    private func refreshCurProgressRate() {
        let maxDoubleToInt = Int(ceil(curProgressRate))
        if maxDoubleToInt > maxLineCount {
            #if DEBUG
            fatalError("curProgressRate should less then maxLineCount!!!")
            #endif
        }
        
        let rateIntValue = Int(floor(curProgressRate))
        subLines.enumerated().forEach { i, subLine in
            if i <= (rateIntValue-1) {
                subLine.backgroundColor = processingColor
            }
            if (i+1) == maxDoubleToInt {
                let value = curProgressRate - Double(i)
                addCoverViewTo(subLine, coverValue: value)
            }
        }
    }
    
    private func addCoverViewTo(_ view: UIView,
                                coverValue: Double) {
        let coverView = UIView()
        coverView.layer.cornerRadius = subLineCornerRadius
        coverView.backgroundColor = processingColor
        coverView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(coverView)
        
        let coverViewTop = NSLayoutConstraint(item: coverView,
                   attribute: .top,
                   relatedBy: .equal,
                   toItem: view,
                   attribute: .top,
                   multiplier: 1,
                   constant: 0)

        let coverViewBottom = NSLayoutConstraint(item: coverView,
                      attribute: .bottom,
                      relatedBy: .equal,
                      toItem: view,
                      attribute: .bottom,
                      multiplier: 1,
                      constant: 0)
        
        let coverViewLeading = NSLayoutConstraint(item: coverView,
                                                     attribute: .leading,
                                                     relatedBy: .equal,
                                                     toItem: view,
                                                     attribute: .leading,
                                                     multiplier: 1,
                                                     constant: 0)
        
        let coverViewWidth = NSLayoutConstraint(item: coverView,
                                               attribute: .width,
                                               relatedBy: .equal,
                                               toItem: view,
                                               attribute: .width,
                                               multiplier: coverValue,
                                               constant: 0)
        
        view.addConstraints([coverViewTop, coverViewBottom, coverViewLeading, coverViewWidth])
        view.layoutIfNeeded()
    }
}
