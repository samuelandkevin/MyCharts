//
//  EHChartView.swift
//  MyCharts
//
//  Created by huangkunpeng on 2023/1/1.
//

import Foundation
import UIKit

class EHChartConfig {
    
    ///右Y轴最大宽度
    var maxWidth_rightYAxis:CGFloat = 56
    ///chart的总高度
    var h_chartView:CGFloat = kChartViewH + 27
    ///x轴高度
    var h_xAxis:CGFloat = 27
    ///圆点的宽度
    var w_Point:CGFloat = 8
    ///x轴间距
    var w_xAxisItem:CGFloat = 42
}


class EHChartView : UIView {
    var selectedIndex:((Int) ->Void)?
    var dataModels = [EHLineChartModel]() {
        didSet{
            self.layoutIfNeeded()

            self.chartView.dataModels = dataModels
            self.collectionView.reloadData()
            print("self.chartView ====\(self.chartView.bounds)")
            if  dataModels.count > 0{
                
                let count:Int = self.collectionView.numberOfItems(inSection: 0)
                let indexPath:IndexPath = IndexPath.init(item: count - 1, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .right, animated: false)
            
                // reload 之后马上执行，cell 还没有布局完成，所以延迟 0.1s
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1){ [weak self] in
                    guard let weakSelf = self else { return }
                    weakSelf.collectionView(weakSelf.collectionView, didSelectItemAt: indexPath)// 初始选择最后一条
                }
                self.collectionView.sendSubviewToBack(self.chartView)
            }
        }
    }
    
    /// collectionView
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(EHChartCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(EHChartCollectionViewCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    /// 流水布局
    fileprivate lazy var flowLayout : UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing      = 0
        flowLayout.minimumInteritemSpacing = 0
        let itemWidth:CGFloat = config.w_xAxisItem
        let itemHight:CGFloat = config.h_chartView
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHight)
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left:  0, bottom: 0, right: 0)
        return flowLayout
        
    }()

    fileprivate lazy var chartView: EHLineChartView = {
        let temp = EHLineChartView()
        return temp
    }()

  
    fileprivate lazy var rightView: EHChartRightView = {
        let temp = EHChartRightView()
        return temp
    }()
    
    fileprivate lazy var calloutView: EHLineChartCalloutView = {
        let temp = EHLineChartCalloutView()
        return temp
    }()
 
    var config:EHChartConfig!
    required init(config:EHChartConfig){
        self.config = config
        super.init(frame: .zero)
        _setupUI()
        _layoutUI()
        
    }

    fileprivate func _setupUI(){
        self.backgroundColor = UIColor.white
        self.addSubview(self.collectionView)
        self.collectionView.addSubview(self.chartView)
        self.addSubview(self.rightView)
    }
    
    fileprivate func _layoutUI(){
        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.top.equalTo(0)
            make.trailing.equalTo(rightView.snp.leading)
            make.bottom.equalTo(0)
            make.height.equalTo(config.h_chartView)
        }
        chartView.snp.makeConstraints { make in
            make.leading.equalTo(0)
            make.top.equalTo(0)
            make.trailing.equalTo(rightView.snp.leading)
            make.bottom.equalTo(self).offset(-config.h_xAxis)
        }
        rightView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.width.equalTo(config.maxWidth_rightYAxis)
            make.trailing.equalTo(0)
        }
    }
    
    fileprivate func _bind(){
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Load Subviews
    override func layoutSubviews() {
        super.layoutSubviews()

    }

    
    // MARK: - Action

    func handleTapIndex(_ index:Int) {
        selectedIndex?(index)
    }

    deinit{
        print("ChartView is deinit")
    }
}

extension EHChartView:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    // MARK: UICollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataModels.count
    }


    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(EHChartCollectionViewCell.classForCoder()), for: indexPath) as! EHChartCollectionViewCell
        let model = dataModels[indexPath.item]
        cell.reloadWithDate(date: model.date, yPoint: model.yPoint, atIndex: indexPath.item)
        return cell
    }
    

  

    // MARK: - UICollectionView Delegate


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)  {
        if indexPath.item >= self.dataModels.count {
            return
        }
        let model:EHLineChartModel = dataModels[indexPath.item]
        if model.yPoint == kInvaildYPoint {
            return
        }
        
        let showString:String! = model.date + " \(model.score)分"

        guard let cell:UICollectionViewCell = collectionView.cellForItem(at: indexPath) else {
            return
        }

        var point:CGPoint = CGPoint.init(x: config.w_xAxisItem / 2.0, y: model.yPoint)
        point = cell.convert(point, to: self)

        self.calloutView.removeFromSuperview()
        self.calloutView.reloadWithTitle(showString)
        
        self.calloutView.center =  CGPoint.init(x: point.x, y: self.calloutView.center.y)
        var frame:CGRect = self.calloutView.frame
        frame.origin.y = point.y - 3.0 - config.w_Point / 2.0 - frame.size.height // 3为偏移量
        self.calloutView.frame = frame
        self.addSubview(self.calloutView)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.calloutView.superview != nil {
            self.calloutView.removeFromSuperview()
        }
    }

}


