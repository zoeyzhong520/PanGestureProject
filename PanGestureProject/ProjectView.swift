//
//  ProjectView.swift
//  PanGestureProject
//
//  Created by zhifu360 on 2019/5/10.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit

class ProjectView: UIView {

    //初始化滑动视图
    let slideView = SlideView()
    
    lazy var backImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "1.jpg"))
        image.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.width)
        image.contentMode = UIView.ContentMode.scaleAspectFill
        image.clipsToBounds = true
        image.isUserInteractionEnabled = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        addSubview(backImage)
        slideView.delegate = self
        
        //添加点击手势
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
    }
    
    @objc func tap(_ tapGes: UITapGestureRecognizer) {
        PhotoBrowser.sharedBrowser.showWith(image: backImage.image!)
    }
    
}

extension ProjectView: SlideViewDelegate {
    
    func selectWith(image: UIImage) {
        //修改图片
        backImage.image = image
    }
    
}
