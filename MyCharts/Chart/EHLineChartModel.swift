import Foundation
import UIKit

class EHLineChartModel {
    ///日期
    var date:String = ""
    /// 分数
    var score:String = ""
    ///计算所得的 y 坐标
    var yPoint:CGFloat = .zero
    
    
    func setupYPoint(){
        let score:CGFloat = (self.score as NSString).doubleValue
        var point:CGFloat = kItemTopMargin + kItemHeight / 2
        
        /**
         高度计算，100-60分，按比例计算，小于 60 分时，小于 60 的区域按比例计算
         */
        var height:CGFloat = 4 * (kItemHeight + kItemSpace); // 60 - 100 的总高度
        if (score >= 60 && score < 100) {
            height = (100 - score) / 40 * height // 按比例下降高度
            point += height
        } else if (score < 60) {
            // 小于 60 分，最后一段按比例计算 Y 值
            var tempH:CGFloat = kItemHeight / 2 + kItemSpace
            tempH = (60 - score) / 60 * tempH
            point += tempH + height
        }
        
        self.yPoint = point;
    }
    
    class func testDataArray() -> [EHLineChartModel]{
        var dateArr = [String]()
        var scoreArr = [String]()
        let count:Int = 365*10
        //获取1到100之间的随机整数
        for i in 0..<count {
            dateArr.append("\(i)")
            scoreArr.append("\(arc4random()%100+1)")
        }
        var arr = [EHLineChartModel]()
        for i in 0..<dateArr.count {
            let model = EHLineChartModel()
            model.score = scoreArr[i]
            model.date = dateArr[i]
            model.setupYPoint()
            arr.append(model)
        }
        return arr
        
    }

}
