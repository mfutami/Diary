//
//  Splash.swift
//  Diary
//
//  Created by futami on 2019/11/18.
//  Copyright © 2019年 futami. All rights reserved.
//

import UIKit

class Splash: UIViewController {
    private let secondLayer = CAShapeLayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        let frame = view.frame
        let path = UIBezierPath()
        // Double.pi → 円周率
        /**
         - parameter - withCenter: 円の中心点
         - radius: 円の半径指定
         - startAngle: 弧の開始角度を指定
         - endAngle: 弧の終了角度を指定
         - clockwise: 方向
         */
        path.addArc(withCenter: CGPoint(x: frame.midX, y: frame.midY),
                    radius: frame.width / 2.0 - 20.0,
                    startAngle: CGFloat(-Double.pi / 2),
                    endAngle: CGFloat(Double.pi + Double.pi / 2),
                    clockwise: true)
        secondLayer.path = path.cgPath
        secondLayer.strokeColor = UIColor.black.cgColor
        secondLayer.fillColor = UIColor.clear.cgColor
        secondLayer.speed = 0.0
        view.layer.addSublayer(secondLayer)
        
        
        // 円を描くアニメーション
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 60.0
        secondLayer.add(animation, forKey: "strokeCircle")
    }
}
