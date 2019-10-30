//
//  LTSearchViewController.swift
//  langTao
//
//  Created by LonTe on 2019/7/31.
//  Copyright © 2019 LonTe. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import JXSegmentedView

class LTSearchViewController: LTViewController {
    var searchBG: UIView?
    var search: UITextField?
    var searchKeys: [String]?
    var searchHistroyList: UICollectionView?
    var placeholder: String? {
        didSet {
            search?.placeholder = self.placeholder
        }
    }
    var segmentedView: JXSegmentedView!
    var segmentedDataSource: JXSegmentedTitleDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addCustomNavBar()
        configSegmentedView()
        addSearchHistroy()
        loadHistroyData()
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
        segmentedView.indicators = [indicator]
        
        //4、配置JXSegmentedView的属性
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        segmentedView.delegate = self
        view.addSubview(segmentedView)
        
        segmentedDataSource.titles = ["Product".localString, "Supplier".localString]
        segmentedDataSource.reloadData(selectedIndex: 0)
        
        segmentedView.defaultSelectedIndex = 0
        segmentedView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let topHeight: CGFloat = UIDevice.current.isX() ? 88 : 64
        segmentedView.frame = CGRect(x: 0, y: topHeight, width: view.bounds.size.width, height: 50)
    }
    
    func addCustomNavBar() {
        let topView = UIView()
        topView.backgroundColor = UIColor.white
        view.addSubview(topView)
        
        topView.snp.makeConstraints({
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(view.snp.topMargin)
        })
        
        searchBG = UIView()
        searchBG?.backgroundColor = UIColor.white
        view.addSubview(searchBG!)
        
        searchBG?.snp.makeConstraints({
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.snp.topMargin)
            if #available(iOS 11.0, *) {
                $0.height.equalTo(44)
            } else {
                $0.height.equalTo(64)
            }
        })
        
        let cancel = UIButton(type: .custom)
        cancel.setTitle("Cancel".localString, for: .normal)
        cancel.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        cancel.setTitleColor(UIColor.black, for: .normal)
        cancel.titleLabel?.sizeToFit()
        cancel.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        searchBG?.addSubview(cancel)
        
        search = UITextField()
        search?.borderStyle = .none
        search?.font = UIFont.systemFont(ofSize: 13)
        search?.backgroundColor = RGB(239, 239, 241)
        searchBG?.addSubview(search!)
        search?.layer.cornerRadius = 5
        search?.leftViewMode = .always
        search?.returnKeyType = .search
        search?.delegate = self
        search?.placeholder = placeholder
        search?.clearButtonMode = .whileEditing
        
        search?.snp.makeConstraints({
            $0.left.equalToSuperview().inset(11)
            $0.right.equalTo(cancel.snp.left).offset(-8)
            if #available(iOS 11.0, *) {
                $0.top.bottom.equalToSuperview().inset(5)
            } else {
                $0.top.equalToSuperview().inset(25)
                $0.bottom.equalToSuperview().inset(5)
            }
        })
        
        cancel.snp.makeConstraints {
            $0.top.bottom.equalTo(search!)
            $0.right.equalToSuperview().inset(11)
            $0.width.equalTo(cancel.titleLabel!.frame.width+10)
        }
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: search!.frame.height))
        search?.leftView = leftView
        
        let line = UILabel()
        line.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        searchBG?.addSubview(line)
        
        line.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    func addSearchHistroy() {
        searchHistroyList = UICollectionView(frame: .zero, collectionViewLayout: LTSearchHistroyLayout())
        searchHistroyList?.backgroundColor = view.backgroundColor
        searchHistroyList?.alwaysBounceVertical = true
        searchHistroyList?.delegate = self
        searchHistroyList?.dataSource = self
        view.addSubview(searchHistroyList!)
        
        searchHistroyList?.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(searchBG!.snp.bottom).offset(50)
        }
        
        searchHistroyList?.register(LTSearchCelll.self, forCellWithReuseIdentifier: String(describing: LTSearchCelll.self))
        searchHistroyList?.register(LTSearchReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: LTSearchReusableView.self))
        searchHistroyList?.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: String(describing: UICollectionReusableView.self))
    }
    
    func currentSaveKey() -> String {
        var searchSaveKey = ""
        switch segmentedView.selectedIndex {
        case 0:
            searchSaveKey = SEARCHPRODUCTHISTROYKEY
        case 1:
            searchSaveKey = SEARCHFACTORYHISTROYKEY
        default:
            break
        }
        return searchSaveKey
    }
    
    func loadHistroyData() {
        searchKeys = UserDefaults.standard.array(forKey: currentSaveKey()) as? [String]
    }
    
    @objc func cancelAction() {
        navigationController?.popViewController(animated: false)
    }
    
    func saveHistroyData(text: String) {
        guard let _ = searchKeys else {
            searchKeys = [text]
            searchHistroyList?.reloadData()
            UserDefaults.standard.setValue(searchKeys, forKey: currentSaveKey())
            UserDefaults.standard.synchronize()
            return
        }
        if searchKeys!.contains(text) {
            searchKeys = searchKeys!.filter { $0 != text }
        }
        searchKeys!.insert(text, at: 0)
        searchKeys = Array(searchKeys!.prefix(15))
        searchHistroyList?.reloadData()
        UserDefaults.standard.setValue(searchKeys, forKey: currentSaveKey())
        UserDefaults.standard.synchronize()
    }
    
    func searchModel(text: String) {
        view.endEditing(true)
        switch segmentedView.selectedIndex {
        case 0:
            let searchProduct = LTSearchProductController()
            searchProduct.placeholder = text
            navigationController?.pushViewController(searchProduct, animated: false)
        case 1:
            let searchFactory = LTSearchFactoryController()
            searchFactory.placeholder = text
            navigationController?.pushViewController(searchFactory, animated: false)
        default:
            break
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        search?.becomeFirstResponder()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        search?.resignFirstResponder()
        IQKeyboardManager.shared.enableAutoToolbar = true
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension LTSearchViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        loadHistroyData()
        searchHistroyList?.reloadData()
    }
}

extension LTSearchViewController: SearchViewFlowDelegateLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchKeys?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LTSearchCelll.self), for: indexPath)
        if let iCell = cell as? LTSearchCelll {
            iCell.label?.text = searchKeys?[indexPath.item]
            if let layout = collectionView.collectionViewLayout as? LTSearchHistroyLayout {
                iCell.label?.font = layout.titleFont
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let text = searchKeys?[indexPath.item] {
            search?.text = text
            searchKeys = searchKeys!.filter { $0 != text }
            searchKeys!.insert(text, at: 0)
            searchKeys = Array(searchKeys!.prefix(15))
            searchHistroyList?.reloadData()
            UserDefaults.standard.setValue(searchKeys, forKey: currentSaveKey())
            UserDefaults.standard.synchronize()
            
            searchModel(text: text)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: LTSearchReusableView.self), for: indexPath)
            if let iHeader = header as? LTSearchReusableView {
                iHeader.clearAction { [weak self] in
                    guard let `self` = self else { return }
                    self.searchKeys?.removeAll()
                    collectionView.reloadData()
                    UserDefaults.standard.removeObject(forKey: self.currentSaveKey())
                    UserDefaults.standard.synchronize()
                }
            }
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: UICollectionReusableView.self), for: indexPath)
            return footer
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: KEYSCREEN_W, height: 44)
    }
    
    func collectionView(itemTitleAt indexPath: IndexPath) -> String {
        return searchKeys?[indexPath.item] ?? ""
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == searchHistroyList {
            search?.resignFirstResponder()
        }
    }
}

extension LTSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == search {
            if let text = textField.text, text.count > 0 {
                saveHistroyData(text: text)
                searchModel(text: text)
            } else if let text = textField.placeholder, text.count > 0 {
                saveHistroyData(text: text)
                searchModel(text: text)
            }
        }
        return false
    }
}
