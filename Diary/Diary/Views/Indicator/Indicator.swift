//
//  Indicator.swift
//  Diary
//
//  Created by futami on 2019/12/15.
//  Copyright © 2019 futami. All rights reserved.
//

import NVActivityIndicatorView

class Indicator {
    private var activityIndicatorView: NVActivityIndicatorView!
    
    func indicatorSetup(_ viewController: UIViewController) {
        self.activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40),
                                                             type: NVActivityIndicatorType.ballGridPulse,
                                                             color: .gray,
                                                             padding: 0)
        self.activityIndicatorView.center = viewController.view.center
        viewController.view.addSubview(self.activityIndicatorView)
    }
    
    func start() {
        self.activityIndicatorView.startAnimating()
    }
    
    func stop() {
        self.activityIndicatorView.stopAnimating()
    }
}
