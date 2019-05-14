//
//  ViewController.swift
//  PanGestureProject
//
//  Created by zhifu360 on 2019/5/10.
//  Copyright © 2019 ZZJ. All rights reserved.
//

import UIKit

class ProjectViewController: BaseViewController {

    lazy var projectView: ProjectView = {
        let projectView = ProjectView(frame: CGRect(x: 0, y: 0, width: ScreenSize.width, height: ContentHeight))
        return projectView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPage()
    }

    func setPage() {
        title = "演示"
        view.addSubview(projectView)
    }
    
}

