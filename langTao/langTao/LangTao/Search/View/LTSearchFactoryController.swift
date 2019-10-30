//
//  LTSearchFactoryController.swift
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

class LTSearchFactoryController: LTViewController {
    var placeholder: String!
    var searchBG: UIView?
    var search: UITextField?
    var table: UITableView?
    var viewModel: LTSearchFactoryViewModel!
    let detailViewModel = LTDetailViewModel()

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
        table = UITableView(frame: .zero, style: .plain)
        table?.separatorInset.left = KEYSCREEN_W
        table?.estimatedRowHeight = 0
        table?.estimatedSectionHeaderHeight = 0
        table?.estimatedSectionFooterHeight = 0
        table?.delegate = self
        table?.dataSource = self
        table?.rowHeight = 75
        view.addSubview(table!)
        table?.backgroundColor = LTTheme.keyViewBG
        table?.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(searchBG!.snp.bottom)
        }
    }
    
    func configListView() {
        table?.register(LTFactoryCell.self, forCellReuseIdentifier: String(describing: LTFactoryCell.self))
    }
    
    func loadData() {
        viewModel = LTSearchFactoryViewModel(completion: { [weak self] (result) in
            guard let `self` = self else { return }
            self.table?.reloadData()
            DispatchQueue.main.asyncAfter(wallDeadline: .now()+0.25, execute: {
                self.table?.cr.endHeaderRefresh()
                self.table?.cr.endLoadingMore()
                if self.viewModel.loaded {
                    self.table?.cr.noticeNoMoreData()
                }
            })
        })
        viewModel.searchKey = placeholder
        viewModel.firstPage()
    }
    
    func addHeader() {
        table?.cr.addHeadRefresh(animator: SlackLoadingAnimator(), handler: { [weak self] in
            guard let `self` = self else { return }
            self.table?.cr.resetNoMore()
            self.viewModel.firstPage()
        })
    }
    
    func addFooter() {
        table?.cr.addFootRefresh(animator: LTCustomFooter(), handler: { [weak self] in
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

extension LTSearchFactoryController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.factorys?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LTFactoryCell.self), for: indexPath)
        if let iCell = cell as? LTFactoryCell {
            iCell.isNum = false
            iCell.factoryModel = viewModel.factorys?[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.factorys![indexPath.row]
        detailViewModel.enterpriseById(id: model.id) { [weak self] (result) in
            if case .success = result {
                guard let `self` = self else { return }
                let vc = LTFactroyDetailController()
                vc.detailModel = self.detailViewModel.detailModel
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

extension LTSearchFactoryController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        navigationController?.popViewController(animated: false)
        return false
    }
}
