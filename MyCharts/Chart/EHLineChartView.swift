//
//  EHLineChartView.swift
//  MyCharts
//
//  Created by huangkunpeng on 2023/1/1.
//

import Foundation
import UIKit
class EHLineChartView : UIView {
    
    ///X轴
    var xLineLayer:CAShapeLayer?
    ///折线
    var lineLayer:CAShapeLayer?
    
    var dataModels = [EHLineChartModel]() {
        didSet{
            self.makeDraw()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.zPosition = -1.0
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func _setupUI(){
        
    }
    
    fileprivate func _layoutUI(){
        
    }
    
    fileprivate func _bind(){
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
    }
    
    func makeDraw() {
   
        let moveStartY:CGFloat = self.bounds.height

        let aPath:UIBezierPath = UIBezierPath()//填充镀层
        let aPathLine:UIBezierPath = UIBezierPath()//线

        var ignoreZeroPoint:Bool = true
        for (i,model) in dataModels.enumerated(){
            let yPoint:CGFloat = model.yPoint
            if ignoreZeroPoint && yPoint == kInvaildYPoint { //忽略前面为0的点
                continue
            }
            let xPoint:CGFloat = kLineChartMoveStartX + CGFloat(i) * kLineChartMoveW
            if ignoreZeroPoint {
                //设置开始的坐标点
                //            startI = i;
                
                aPath.move(to: CGPoint.init(x: xPoint, y: moveStartY)) //镀层要从 x 轴开始画，再添加第一个点坐标
                aPath.addLine(to: CGPoint.init(x: xPoint, y: yPoint))
                
                aPathLine.move(to: CGPoint.init(x: xPoint, y: yPoint))
                ignoreZeroPoint = false //开始画点，不再忽略为0的点
            } else {
                aPath.addLine(to: CGPoint.init(x: xPoint, y: yPoint))
                aPathLine.addLine(to: CGPoint.init(x: xPoint, y: yPoint))
            }
         }

        //收边
        let lineW:CGFloat = kLineChartMoveStartX + CGFloat(dataModels.count - 1) * kLineChartMoveW
        aPath.addLine(to: CGPoint.init(x: lineW, y: moveStartY))
        aPath.close()

        self.addGradientLayerWithPath(aPath)
        self.addLineLayerWithPath(aPathLine)
        self.addXLineLayer()
    }
    
    ///X轴
    func addXLineLayer() {
        let lineW:CGFloat = kLineChartMoveStartX + CGFloat(dataModels.count - 1) * kLineChartMoveW
        //x 轴
        let xLinePath:UIBezierPath = UIBezierPath()
        xLinePath.move(to: CGPoint.init(x: kLineChartMoveStartX - kLineChartMoveW / 2.0, y: kChartViewH))
        xLinePath.addLine(to: CGPoint.init(x: kLineChartMoveStartX + lineW, y: kChartViewH))

        let xLineLayer:CAShapeLayer = CAShapeLayer()
        xLineLayer.strokeColor = UIColor.lightGray.cgColor
        xLineLayer.lineWidth = 0.5
        xLineLayer.path = xLinePath.cgPath
        xLineLayer.zPosition = -2
        self.layer.addSublayer(xLineLayer)
        self.xLineLayer = xLineLayer
    }

    ///折线
    func addLineLayerWithPath(_ path:UIBezierPath) {
        let shapelayerLine:CAShapeLayer = CAShapeLayer()
        //设置边框颜色，就是上边画的，线的颜色
        shapelayerLine.strokeColor = UIColor.orange.cgColor
        //设置填充颜色 如果不需要[UIColor clearColor]
        shapelayerLine.fillColor = UIColor.clear.cgColor
        //就是这句话在关联彼此（UIBezierPath和CAShapeLayer）：
        shapelayerLine.path = path.cgPath
        self.layer.addSublayer(shapelayerLine)
        self.lineLayer = shapelayerLine
    }

    func addGradientLayerWithPath(_ path:UIBezierPath) {
        //获取总共的长度
        let lineW:CGFloat = kLineChartMoveStartX + CGFloat(dataModels.count - 1) * kLineChartMoveW

        let shapelayer:CAShapeLayer = CAShapeLayer()
        //设置边框颜色，就是上边画的，线的颜色
        shapelayer.strokeColor = UIColor.orange.cgColor
        //设置填充颜色
        shapelayer.fillColor = UIColor.orange.cgColor
        //就是这句话在关联彼此（UIBezierPath和CAShapeLayer）：
        shapelayer.path = path.cgPath

        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.orange.withAlphaComponent(0.4).cgColor ,UIColor.orange.withAlphaComponent(0).cgColor]
        //    gradientLayer.locations = @[@0.f, @0.5f];
        gradientLayer.startPoint = CGPoint.init(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 0.5, y: 1.0)
        gradientLayer.shadowPath = path.cgPath
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: lineW, height: kChartViewH)
        gradientLayer.mask = shapelayer
        self.layer.addSublayer(gradientLayer)
    }

  

}
