//
//  SlideView.swift
//  PanGestureProject
//
//  Created by zhifu360 on 2019/5/10.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit

@objc protocol SlideViewDelegate: NSObjectProtocol {
    @objc optional
    func slideValueChanged(value: CGFloat)
    func selectWith(image: UIImage)
}

class SlideView: UIView {

    ///预留的高度
    let ReservedHeight: CGFloat = 50
    
    ///原始的origin
    var containerOrigin: CGPoint!
    
    ///展开按钮
    var expandBtn: UIButton!
    
    ///遮罩view
    lazy var blurView: UIView = {
        let blurView = UIView(frame: ScreenSize)
        blurView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        blurView.isHidden = true
        return blurView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: self.ReservedHeight, width: self.bounds.size.width, height: self.bounds.size.height - self.ReservedHeight), style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.rowHeight = 44
        tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: BaseTableReuseIdentifier)
        return tableView
    }()
    
    ///数据源
    let dataArray = ["1","2","3","4","5","6"]
    
    weak var delegate: SlideViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        //添加UIPanGestureRecognizer手势
        addPanGes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {
        frame = CGRect(x: 0, y: ScreenSize.height - ReservedHeight, width: ScreenSize.width, height: ScreenSize.height*3/4)
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        if let window = UIApplication.shared.delegate?.window {
            window?.addSubview(blurView)
            window?.addSubview(self)
        }
        
        //添加一个按钮
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: ReservedHeight)
        button.setTitle("向上拖", for: .normal)
        button.setTitleColor(.white, for: .normal)
        addSubview(button)
        expandBtn = button
        
        addSubview(tableView)
    }
    
    func addPanGes() {
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        addGestureRecognizer(panGes)
    }
    
    @objc func panAction(_ panGes: UIPanGestureRecognizer) {
        /*
         translationInView : 手指在视图上移动的位置（x,y）向下和向右为正，向上和向左为负。
         locationInView ： 手指在视图上的位置（x,y）就是手指在视图本身坐标系的位置。
         velocityInView： 手指在视图上移动的速度（x,y）, 正负也是代表方向，值得一提的是在绝对值上|x| > |y| 水平移动， |y|>|x| 竖直移动。
         */
        
        let point = panGes.translation(in: self)
        
        if panGes.state == .began {
            //原始的origin
            containerOrigin = frame.origin
            blurView.isHidden = false
        }
        
        if panGes.state == .changed {
            //手势移动过程中，在边界处做判断
            var tmpFrame = frame
            tmpFrame.origin.y = containerOrigin.y + point.y
            
            //上边界
            if tmpFrame.origin.y < ScreenSize.height/4 {
                tmpFrame.origin.y = ScreenSize.height/4
            }
            
            //下边界
            if tmpFrame.origin.y > ScreenSize.height - self.ReservedHeight {
                tmpFrame.origin.y = ScreenSize.height - self.ReservedHeight
            }
            
            frame = tmpFrame
        }
        
        if panGes.state == .ended {
            //手势滑动结束，有向上趋势则直接滑动至上边界；有向下趋势则直接滑动到下边界
            if panGes.velocity(in: self).y < 0 {
                //向上
                UIView.animate(withDuration: 0.3, animations: {
                    var tmpFrame = self.frame
                    tmpFrame.origin.y = ScreenSize.height/4
                    self.frame = tmpFrame
                }) { (finish) in
                    self.expandBtn.setTitle("向下拖", for: .normal)
                }
            } else {
                //向下
                resetViews()
            }
        }
        
    }
    
    @objc func resetViews() {
        UIView.animate(withDuration: 0.3, animations: {
            var tmpFrame = self.frame
            tmpFrame.origin.y = ScreenSize.height - self.ReservedHeight
            self.frame = tmpFrame
        }) { (finish) in
            self.expandBtn.setTitle("向上拖", for: .normal)
            self.blurView.isHidden = true
        }
    }
    
}

extension SlideView: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: BaseTableReuseIdentifier, for: indexPath)
        cell.backgroundColor = .clear
        cell.imageView?.image = UIImage(named: "\(dataArray[indexPath.row]).jpg")
        cell.imageView?.contentMode = .scaleAspectFit
        cell.textLabel?.text = "第\(dataArray[indexPath.row])张图片"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = .white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        resetViews()
        
        let selectImage = UIImage(named: "\(dataArray[indexPath.row]).jpg")
        if delegate != nil {
            delegate?.selectWith(image: selectImage!)
        }
        
    }
    
}
