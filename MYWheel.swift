//
//  MYWheel.swift
//  Lc
//
//  Created by Luciano Calderano on 10/11/16.
//  Copyright © 2016 it.kanitoKanito. All rights reserved.
//

import UIKit

class MYWheel: UIView {
    var imageBack = UIImageView()
    let activityIndicatorView = UIActivityIndicatorView()
    init(_ start: Bool = false) {
        super.init(frame: UIScreen.main.bounds)
        self.initialize()
        if start {
            self.start()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize () {
        self.backgroundColor = UIColor.init(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.1) //UIColor.clearColor()
        let activityIndicatorContainer: UIView = UIView()
        activityIndicatorContainer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicatorContainer.center = self.center
        activityIndicatorContainer.backgroundColor = UIColor.darkGray
        activityIndicatorContainer.alpha = 0.9
        activityIndicatorContainer.clipsToBounds = true
        activityIndicatorContainer.layer.cornerRadius = 10
        
        activityIndicatorView.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        activityIndicatorView.center = CGPoint(x: activityIndicatorContainer.frame.size.width / 2, y: activityIndicatorContainer.frame.size.height / 2)
        
        activityIndicatorContainer.addSubview(activityIndicatorView)
        
        self.addSubview(activityIndicatorContainer)
    }
    
    func stop () {
        self.activityIndicatorView.stopAnimating()
        self.isHidden = true
        self.removeFromSuperview()
    }
    
    func start(_ uiView: UIView = UIApplication.shared.keyWindow!) -> Void {
        self.frame = uiView.bounds
        self.center = uiView.center
        uiView.addSubview(self)
        if WheelConfig.backWheelImage != nil {
            self.imageBack.image = WheelConfig.backWheelImage
            self.imageBack.contentMode = UIViewContentMode.scaleAspectFit
            self.imageBack.alpha = 0.1
            self.addSubview(self.imageBack)
            self.imageBack.frame = self.bounds
            self.imageBack.sendSubview(toBack: self)
        }
        activityIndicatorView.startAnimating()
    }

//    func start() -> Void {
//        let window = UIApplication.shared.keyWindow
//        self.startInView(window!)
//    }
}
