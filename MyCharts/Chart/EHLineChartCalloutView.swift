//
//  EHLineChartCalloutView.swift
//  MyCharts
//
//  Created by huangkunpeng on 2023/1/1.
//

import Foundation
import UIKit


class EHLineChartCalloutView : UIView {
    let kArrowX:CGFloat = 5;
    lazy var titleLabel: UILabel = {
        let temp:UILabel = UILabel()
        temp.backgroundColor = UIColor.orange
        temp.font = UIFont.systemFont(ofSize: 14)
        temp.textColor = UIColor.white
        temp.textAlignment = .center
        return temp
    }()
 
    fileprivate lazy var traiLayer: CAShapeLayer = {
        let temp = CAShapeLayer()
        temp.frame = CGRect.init(x: self.bounds.midX - kArrowX, y: 20, width: kArrowX * 2, height: 6)
        let path:UIBezierPath = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint.init(x: 2 * kArrowX, y: 0))
        path.addLine(to: CGPoint.init(x: kArrowX, y: 6.0))
        path.addLine(to: CGPoint.zero)
        path.close()
        temp.path = path.cgPath
        temp.fillColor = UIColor.orange.cgColor
        return temp
    }()
    
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.loadSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Load Subviews

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.titleLabel.frame = CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: 21)

        CATransaction.begin()
        //禁用隐式动画
        CATransaction.setDisableActions(true)
        //隐式动画
        self.traiLayer.frame = CGRect.init(x: self.bounds.midX - kArrowX, y: 20, width: kArrowX * 2, height: 6)
        //提交事务
        CATransaction.commit()
    }

    func loadSubviews() {
        self.addSubview(self.titleLabel)
        self.layer.addSublayer(self.traiLayer)

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.26
    }

    // MARK: - Public

    func reloadWithTitle(_ title:String) {
        self.titleLabel.text = title
        var size:CGSize = self.titleLabel.sizeThatFits(CGSize.init(width: 150.0, height: 21))
        if size.width < 90.0 {
            size.width = 90.0
        }
        self.bounds = CGRect.init(x: 0, y: 0, width: size.width + 6.0 * 2, height: 26)

        self.setNeedsLayout()
    }

    // MARK: - Setter、Getter
    // MARK: setter


    // MARK: getter

    // `titleLabel` has moved as a getter.

    // `traiLayer` has moved as a getter.
}
