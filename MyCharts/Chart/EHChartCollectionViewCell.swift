//
//  EHChartCollectionViewCell.swift
//  MyCharts
//
//  Created by huangkunpeng on 2023/1/1.
//

import Foundation
import UIKit

class EHChartCollectionViewCell:UICollectionViewCell {

    private var index:Int = 0
    private var yPoint:CGFloat = 0
    private var dashLineLayer:CAShapeLayer!
    
    fileprivate lazy var label: UILabel = {
        let temp = UILabel()
        temp.font = UIFont.systemFont(ofSize: 12)
        temp.textColor = UIColor.lightGray
        temp.textAlignment = .center
        return temp
    }()
   
    fileprivate lazy var pointLayer: CAShapeLayer = {
        let temp = CAShapeLayer()
        temp.lineWidth = 1.0
        temp.fillColor = UIColor.orange.cgColor
        temp.strokeColor = UIColor.white.cgColor
        
        let path:UIBezierPath = UIBezierPath.init(arcCenter: CGPoint.init(x: kPointSize/2, y: kPointSize/2), radius: kPointSize / 2.0, startAngle: 0, endAngle: Double.pi * 2, clockwise: true)
        temp.path = path.cgPath
        return temp
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setupUI()
        _layoutUI()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Public

    func reloadWithDate(date:String, yPoint y:CGFloat, atIndex index:Int) {
        self.index = index
        self.yPoint = y
        self.label.text = date
        self.setNeedsLayout()
    }

    // MARK: - Load Subviews

    override func layoutSubviews() {
        super.layoutSubviews()

        self.pointLayer.isHidden = (self.yPoint == kInvaildYPoint)
//        self.label.frame = CGRect.init(x: 0.0, y: self.bounds.size.height - kLineChartBottomMargin + 10.0, width: self.bounds.size.width, height: 17.0)

        if self.pointLayer.isHidden {
            return
        }
        CATransaction.begin()
        //禁用隐式动画
        CATransaction.setDisableActions(true)
        self.pointLayer.frame = CGRect.init(x: self.bounds.size.width / 2 - kPointSize / 2, y: yPoint - kPointSize / 2, width: kPointSize, height: kPointSize)
        CATransaction.commit()
    }
    
    fileprivate func _setupUI(){
        self.contentView.addSubview(self.label)
        self.addDashLineLayerToView(self.contentView)
        self.contentView.layer.addSublayer(self.pointLayer)
    }
    
    fileprivate func _layoutUI(){
        self.label.snp.makeConstraints { make in
            make.bottom.equalTo(0)
            make.height.equalTo(17)
            make.centerX.equalTo(self)
        }
    }
    
    fileprivate func _bind(){
        
    }
        


    // MARK: - Helper

    func addDashLineLayerToView(_ view:UIView) {
        if (self.dashLineLayer != nil) {
            self.dashLineLayer.removeFromSuperlayer()
        }
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        
        shapeLayer.bounds = CGRect.init(x: 0, y: 0, width: kLineChartMoveW, height: kChartViewH)
        
        shapeLayer.position = CGPoint.init(x: kLineChartMoveW / 2.0, y: kChartViewH / 2.0)
        shapeLayer.fillColor = UIColor.clear.cgColor
        //设置虚线颜色
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        //设置虚线宽度
        shapeLayer.lineWidth = 0.5
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        //设置虚线的线宽及间距
        shapeLayer.lineDashPattern = [2,2]
        //创建虚线绘制路径
        let path:CGMutablePath = CGMutablePath()
   
        
        
        //设置虚线绘制路径起点
        path.move(to: CGPoint.init(x:  kLineChartMoveW / 2.0, y: 0))
        //设置虚线绘制路径终点
        path.addLine(to: CGPoint.init(x:  kLineChartMoveW / 2.0, y: kChartViewH))
        //设置虚线绘制路径
        shapeLayer.path = path

        self.dashLineLayer = shapeLayer
        //添加虚线，这里用 insert，是因为把虚线放在最底层
        view.layer.insertSublayer(self.dashLineLayer, at: 0)
    }

}

