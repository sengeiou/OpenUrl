//
//  LTSearchProductController.swift
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
//  Created by LonTe on 2019/8/26.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit
import CRRefresh

class LTSearchProductController: LTViewController {
    var placeholder: String!
    var searchBG: UIView?
    var search: UITextField?
    var collect: UICollectionView?
    var viewModel: LTSearchProductViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addCustomNavBar()
        addListView()
        configListView()
        addHeader()
        addFooter()
        loadData()
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
        
        let back = UIButton(type: .custom)
        back.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        back.contentHorizontalAlignment = .left
        back.setImage(#imageLiteral(resourceName: "blackBack"), for: .normal)
        searchBG?.addSubview(back)
        
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
        
        search?.snp.makeConstraints({
            $0.right.equalToSuperview().inset(11)
            $0.left.equalTo(back.snp.right)
            if #available(iOS 11.0, *) {
                $0.top.bottom.equalToSuperview().inset(5)
            } else {
                $0.top.equalToSuperview().inset(25)
                $0.bottom.equalToSuperview().inset(5)
            }
        })
        
        back.snp.makeConstraints {
            $0.top.bottom.equalTo(search!)
            $0.left.equalToSuperview().inset(11)
            $0.width.equalTo(back.snp.height).multipliedBy(0.8)
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
    
    func addListView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let width = (KEYSCREEN_W-30)/2
        layout.itemSize = CGSize(width: width, height: width+60)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collect = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collect?.delegate = self
        collect?.dataSource = self
        collect?.alwaysBounceVertical = true
        view.addSubview(collect!)
        collect?.backgroundColor = LTTheme.keyViewBG
        collect?.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(searchBG!.snp.bottom)
        }
    }
    
    func configListView() {
        collect?.register(LTHotItemCell.self, forCellWithReuseIdentifier: String(describing: LTHotItemCell.self))
    }
    
    func loadData() {
        viewModel = LTSearchProductViewModel(completion: { [weak self] (result) in
            guard let `self` = self else { return }
            self.collect?.reloadData()
            DispatchQueue.main.asyncAfter(wallDeadline: .now()+0.25, execute: {
                self.collect?.cr.endHeaderRefresh()
                self.collect?.cr.endLoadingMore()
                if self.viewModel.loaded {
                    self.collect?.cr.noticeNoMoreData()
                }
            })
        })
        viewModel.searchKey = placeholder
        viewModel.firstPage()
    }
    
    func addHeader() {
        collect?.cr.addHeadRefresh(animator: SlackLoadingAnimator(), handler: { [weak self] in
            guard let `self` = self else { return }
            self.collect?.cr.resetNoMore()
            self.viewModel.firstPage()
        })
    }
    
    func addFooter() {
        collect?.cr.addFootRefresh(animator: LTCustomFooter(), handler: { [weak self] in
            guard let `self` = self else { return }
            self.viewModel.nextPage()
        })
    }
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
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

extension LTSearchProductController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LTHotItemCell.self), for: indexPath)
        if let icell = cell as? LTHotItemCell {
            icell.model = viewModel.products?[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = LTProductDetailsController()
        vc.productModel = viewModel.products![indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LTSearchProductController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        navigationController?.popViewController(animated: false)
        return false
    }
}
