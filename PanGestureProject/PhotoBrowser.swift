//
//  PhotoBrowser.swift
//  PanGestureProject
//
//  Created by zhifu360 on 2019/5/13.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit

class PhotoBrowser: NSObject {

    static let sharedBrowser = PhotoBrowser()
    
    ///最大缩放倍数
    var MaxScale: CGFloat = 5
    
    ///最小缩放倍数
    var MinScale: CGFloat = 1
    
    ///创建UIScrollView
    var scrollView: UIScrollView!
    
    ///创建UIImageView
    var imgView: UIImageView!
    
    func showWith(image: UIImage) {
        
        //创建UIScrollView
        let scrollView = UIScrollView(frame: ScreenSize)
        scrollView.backgroundColor = .black
        scrollView.delegate = PhotoBrowser.sharedBrowser
        scrollView.minimumZoomScale = MinScale
        scrollView.maximumZoomScale = MaxScale
        if let window = UIApplication.shared.delegate?.window {
            window?.addSubview(scrollView)
            self.scrollView = scrollView
        }
        
        //添加点击手势
        let singleTapGes = UITapGestureRecognizer(target: self, action: #selector(singleTap(_:)))
        scrollView.addGestureRecognizer(singleTapGes)
        
        let doubleTapGes = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
        doubleTapGes.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(doubleTapGes)
        singleTapGes.require(toFail: doubleTapGes)
        
        //创建UIImageView
        let imgView = UIImageView(image: image)
        scrollView.addSubview(imgView)
        self.imgView = imgView
        layoutImgView(image: image)
        
    }
    
    ///按图片比例是配imgView的frame
    func layoutImgView(image: UIImage) {
        
        var imageFrame = CGRect.zero
        if image.size.width > scrollView.bounds.size.width || image.size.height > scrollView.bounds.size.height {
            //图片尺寸超出屏幕尺寸
            
            //计算图片宽高比
            let imageRatio = image.size.width / image.size.height
            //计算屏幕宽高比
            let photoRatio = scrollView.bounds.size.width / scrollView.bounds.size.height
            
            if imageRatio > photoRatio {
                imageFrame.size = CGSize(width: scrollView.bounds.size.width, height: scrollView.bounds.size.width/image.size.width*image.size.height)
                imageFrame.origin.x = 0
                imageFrame.origin.y = (scrollView.bounds.size.height - imageFrame.size.height) / 2
            } else {
                imageFrame.size = CGSize(width: scrollView.bounds.size.height/image.size.height*image.size.width, height: scrollView.bounds.size.height)
                imageFrame.origin.x = (scrollView.bounds.size.width - imageFrame.size.width) / 2
                imageFrame.origin.y = 0
            }
            
        } else {
            //设置居中
            imageFrame.size = image.size
            imageFrame.origin.x = (scrollView.bounds.size.width - image.size.width) / 2
            imageFrame.origin.y = (scrollView.bounds.size.height - image.size.height) / 2
        }
        
        imgView.frame = imageFrame
    }
    
    @objc func singleTap(_ tapGes: UITapGestureRecognizer) {
        
        scrollView.removeFromSuperview()
        
    }
    
    @objc func doubleTap(_ tapGes: UITapGestureRecognizer) {
        if scrollView.zoomScale > MinScale {
            scrollView.setZoomScale(MinScale, animated: true)
        } else {
            let touchPoint = tapGes.location(in: imgView)
            let newZoomScale = MaxScale
            let xsize = self.scrollView.frame.size.width / newZoomScale
            let ysize = self.scrollView.frame.size.height / newZoomScale
            scrollView.zoom(to: CGRect(x: touchPoint.x - xsize/2, y: touchPoint.y - ysize/2, width: xsize, height: ysize), animated: true)
        }
        
    }
}

extension PhotoBrowser: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        //把当前缩放比例设进zoomScale，以便下次缩放时是在现有的比例的基础上
        scrollView.setZoomScale(scale, animated: false)
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offSetX = scrollView.bounds.size.width > scrollView.contentSize.width ? (scrollView.bounds.size.width - scrollView.contentSize.width)*0.5 : 0
        let offSetY = scrollView.bounds.size.height > scrollView.contentSize.height ? (scrollView.bounds.size.height - scrollView.contentSize.height)*0.5 : 0
        imgView.center = CGPoint(x: scrollView.contentSize.width*0.5+offSetX, y: scrollView.contentSize.height*0.5+offSetY)
    }
    
}
