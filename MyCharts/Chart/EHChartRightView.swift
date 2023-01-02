//
//  EHChartRightView.swift
//  MyCharts
//
//  Created by huangkunpeng on 2023/1/1.
//

import Foundation
import UIKit
import SnapKit

class EHChartRightView:UIView {

    lazy var gradientLayer: CAGradientLayer = {
        let temp = CAGradientLayer()
        temp.colors = [UIColor.white.cgColor, UIColor(white:1.0, alpha:1.0).cgColor]
        temp.frame = CGRect.init(x: 0, y: 0, width: 17, height: kChartViewH + kPointSize)
        temp.startPoint = CGPoint.init(x: 0, y: 0.5)
        temp.endPoint = CGPoint.init(x: 1, y: 0.5)
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

    func loadSubviews() {
        self.layer.addSublayer(self.gradientLayer)
        let dataArr:[String] = ["100", "90", "80", "70", "60"]
        for (i,item) in dataArr.enumerated() {
            let itemView:ZHChartRightItemView = ZHChartRightItemView()
            itemView.rightLabel.text = item
            self.addSubview(itemView)
            itemView.snp.makeConstraints { make in
                make.leading.equalTo(0)
                make.top.equalTo( 11.0 + (21.0 + 40.0) * CGFloat(i))
                make.height.equalTo(21.0)
            }
        }
       
    }

    // MARK: - Getter

    // `gradientLayer` has moved as a getter.
}


class ZHChartRightItemView : UIView {
    
    
    lazy var leftLabel: UILabel = {
        let temp:UILabel = UILabel()
        temp.text = "-"
        temp.font = UIFont.systemFont(ofSize: 15)
        temp.textColor = UIColor.lightGray
        temp.textAlignment = .right
        return temp
    }()
    
    lazy var rightLabel: UILabel = {
        let temp = UILabel()
        temp.font = UIFont.systemFont(ofSize: 15)
        temp.textColor = UIColor.lightGray
        temp.textAlignment = .right
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.leftLabel)
        self.addSubview(self.rightLabel)
        
        self.leftLabel.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0)
        }
        self.rightLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftLabel.snp.trailing)
            make.centerY.equalTo(self.leftLabel)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

  

    override func layoutSubviews() {
        super.layoutSubviews()
//        self.leftLabel.frame = CGRect.init(x: 0, y: 0, width: kLeftLabelW, height: self.bounds.size.height)
//        self.rightLabel.frame = CGRect.init(x: kLeftLabelW, y: 0, width: kLeftLabelW, height: self.bounds.size.height)
    }

    // `leftLabel` has moved as a getter.

    // `rightLabel` has moved as a getter.
}


