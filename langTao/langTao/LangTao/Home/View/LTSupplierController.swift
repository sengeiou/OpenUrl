//
//  LTSupplierController.swift
//  langTao
//
//  **********************************************
//  *     _    _        _ˍ_ˍ_        _    _      *
//  *    | |  | |      |__   |      \ \  / /     *
//  *    | |__| |        /  /        \ \/ /      *
//  *    |  __  |       /  /          \  /       *
//  *    | |  | |      /  /__       __/ /        *
//  *    |_|  |_|      |_ˍ_ˍ_|     |_ˍ_/         *
//  *                                            *
//  **********************************************
//
//  Created by LonTe on 2019/8/22.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit
import JXSegmentedView

class LTSupplierController: LTViewController {
    let viewModel = LTFactoryViewModel()
    var segmentedDataSource: JXSegmentedTitleDataSource!
    var segmentedView: JXSegmentedView!
    var listContainerView: JXSegmentedListContainerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configSegmentedView()
        loadData()
    }
    
    func configSegmentedView() {
        //1、初始化JXSegmentedView
        segmentedView = JXSegmentedView()
        segmentedView.backgroundColor = UIColor.white
        
        //2、配置数据源
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedDataSource = JXSegmentedTitleDataSource()
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedDataSource.titleSelectedColor = LTTheme.select
        segmentedDataSource.titleNormalColor = UIColor.gray
        segmentedDataSource.reloadData(selectedIndex: 0)
        segmentedView.dataSource = segmentedDataSource
        
        //3、配置指示器
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorColor = LTTheme.select
        indicator.scrollAnimationDuration = 0
        segmentedView.indicators = [indicator]
        
        //4、配置JXSegmentedView的属性
        segmentedView.delegate = self
        view.addSubview(segmentedView)
        
        //5、初始化JXSegmentedListContainerView
        listContainerView = JXSegmentedListContainerView(dataSource: self)
        listContainerView.didAppearPercent = 0.9
        view.addSubview(listContainerView)
        
        //6、将listContainerView.scrollView和segmentedView.contentScrollView进行关联
        segmentedView.contentScrollView = listContainerView.scrollView
        if let gestures = navigationController?.view.gestureRecognizers {
            gestures.forEach { (gesture) in
                if gesture is UIScreenEdgePanGestureRecognizer {
                    segmentedView.contentScrollView!.panGestureRecognizer.require(toFail: gesture)
                }
            }
        }
    }
    
    func loadData() {
        viewModel.sortParentId(parentId: "1164463503285817344") { [weak self] (result) in
            guard let `self` = self else { return }
            var titles = [String]()
            if let sorts = self.viewModel.sorts {
                self.viewModel.sorts = sorts.filter({ (model) -> Bool in
                    return model.sort != "烟油"
                })
                self.viewModel.sorts!.forEach { titles.append($0.sort) }
            }
            //一定要统一segmentedDataSource、segmentedView、listContainerView的defaultSelectedIndex
            self.segmentedDataSource.titles = titles
            //reloadData(selectedIndex:)一定要调用
            self.segmentedDataSource.reloadData(selectedIndex: 0)
            
            self.segmentedView.defaultSelectedIndex = 0
            self.segmentedView.reloadData()
            
            self.listContainerView.defaultSelectedIndex = 0
            self.listContainerView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        segmentedView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 50)
        listContainerView.frame = CGRect(x: 0, y: 50, width: view.bounds.size.width, height: view.bounds.size.height - 50)
    }
}

extension LTSupplierController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        //传递didClickSelectedItemAt事件给listContainerView，必须调用！！！
        listContainerView.didClickSelectedItem(at: index)
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, scrollingFrom leftIndex: Int, to rightIndex: Int, percent: CGFloat) {
        //传递scrollingFrom事件给listContainerView，必须调用！！！
        listContainerView.segmentedViewScrolling(from: leftIndex, to: rightIndex, percent: percent, selectedIndex: segmentedView.selectedIndex)
    }
}

extension LTSupplierController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return segmentedDataSource.dataSource.count
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        let vc = LTFactoryController()
        vc.sortId = viewModel.sorts![index].id
        vc.nav = navigationController
        return vc
    }
}

