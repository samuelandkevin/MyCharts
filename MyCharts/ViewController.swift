//
//  ViewController.swift
//  MyCharts
//
//  Created by huangkunpeng on 2023/1/1.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let button = UIButton()
        button.backgroundColor = .orange
        button.setTitle("push me", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(onPush), for: .touchUpInside)
        self.view.addSubview(button)
        button.frame = CGRect.init(x: self.view.bounds.midX-50, y: self.view.bounds.midY, width: 100, height: 44)
    }
    
    
    @objc func onPush(){
        self.navigationController?.pushViewController(ChartsViewController(), animated: true)
    }

}

class ChartsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .gray
        let config = EHChartConfig()
        let chartView = EHChartView(config: config)
        self.view.addSubview(chartView)
        chartView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(0)
            make.top.equalTo(120)
            make.height.equalTo(kChartViewH)
        }
        chartView.dataModels = EHLineChartModel.testDataArray()
        
    }

}
