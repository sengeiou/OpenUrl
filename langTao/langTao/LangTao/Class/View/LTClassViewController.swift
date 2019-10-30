//
//  LTClassViewController.swift
//  langTao
//
//  Created by LonTe on 2019/7/26.
//  Copyright © 2019 LonTe. All rights reserved.
//

import UIKit

class LTClassViewController: LTViewController {
    var viewModel = LTSortViewModel()
    var searchBG: UIView?
    var search: UITextField?
    var classTable: UITableView?
    var classCollect: UICollectionView?
    var selectIndex: IndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Class".localString
        // Do any additional setup after loading the view.
        addCustomNavBar()
        addFirstClassList()
        addSecondClassList()
        loadData()
        NotificationCenter.default.addObserver(self, selector: #selector(updataSearchKey), name: NSNotification.Name(rawValue: SEARCHKEY), object: nil)
    }
    
    @objc func updataSearchKey() {
        search?.placeholder = UserDefaults.standard.string(forKey: SEARCHKEY)
    }
    
    func loadData() {
        viewModel.getSort { [weak self] (result) in
            guard let `self` = self else { return }
            if case .success = result {
                self.classTable?.reloadData()
                if self.viewModel.sorts!.count > 0 {                
                    self.sortSearchByClass(name: self.viewModel.sorts![self.selectIndex.row].name)
                }
            }
        }
    }
    
    func sortSearchByClass(name: String) {
        viewModel.sortSearchByClass(className: name) { [weak self] (result) in
            guard let `self` = self else { return }
            if case .success = result {            
                if let model = self.viewModel.products, model.count > 0 {
                    self.removeNoDataView(formView: self.classCollect!)
                } else {
                    self.addNoDataView(inView: self.classCollect!)
                }
                self.classCollect?.reloadData()
            }
        }
    }
    
    override func reloadLocalString() {
        title = "Class".localString
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
        
        search = UITextField()
        search?.borderStyle = .none
        search?.font = UIFont.systemFont(ofSize: 13)
        search?.backgroundColor = RGB(239, 239, 241)
        searchBG?.addSubview(search!)
        search?.layer.cornerRadius = 5
        search?.leftViewMode = .always
        search?.returnKeyType = .search
        search?.delegate = self
        search?.placeholder = UserDefaults.standard.string(forKey: SEARCHKEY)

        search?.snp.makeConstraints({
            $0.left.right.equalToSuperview().inset(11)
            if #available(iOS 11.0, *) {
                $0.top.bottom.equalToSuperview().inset(5)
            } else {
                $0.top.equalToSuperview().inset(25)
                $0.bottom.equalToSuperview().inset(5)
            }
        })
        
        let leftImage = UIImageView(image: #imageLiteral(resourceName: "search"))
        leftImage.contentMode = .scaleAspectFit
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 42, height: 42))
        leftView.addSubview(leftImage)
        leftImage.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 7, left: 10, bottom: 5, right: 10))
        }
        search?.leftView = leftView
        
        let line = UILabel()
        line.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        searchBG?.addSubview(line)
        
        line.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }
    
    func addFirstClassList() {
        classTable = UITableView(frame: .zero, style: .plain)
        classTable?.separatorStyle = .none
        classTable?.backgroundColor = view.backgroundColor
        classTable?.estimatedRowHeight = 0
        classTable?.estimatedSectionHeaderHeight = 0
        classTable?.estimatedSectionFooterHeight = 0
        classTable?.rowHeight = 49
        classTable?.delegate = self
        classTable?.dataSource = self
        view.addSubview(classTable!)
        classTable?.register(LTFirstClassCell.self, forCellReuseIdentifier: String(describing: LTFirstClassCell.self))
        
        classTable?.snp.makeConstraints {
            $0.left.bottom.equalToSuperview()
            $0.top.equalTo(searchBG!.snp.bottom)
            $0.width.equalTo(KEYSCREEN_W/4)
        }
    }
    
    func addSecondClassList() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        let width = (KEYSCREEN_W/4*3-15*4-1)/3
        layout.itemSize = CGSize(width: width, height: width+33)
        
        classCollect = UICollectionView(frame: .zero, collectionViewLayout: layout)
        classCollect?.backgroundColor = UIColor.white
        classCollect?.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        classCollect?.delegate = self
        classCollect?.dataSource = self
        classCollect?.alwaysBounceVertical = true
        view.addSubview(classCollect!)
        
        classCollect?.register(LTSecondCell.self, forCellWithReuseIdentifier: String(describing: LTSecondCell.self))
        
        classCollect?.snp.makeConstraints({
            $0.bottom.right.equalToSuperview()
            $0.top.equalTo(searchBG!.snp.bottom)
            $0.left.equalTo(classTable!.snp.right)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    deinit {
        #if DEBUG
        print("\(self)销毁了~~~")
        #endif
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: SEARCHKEY), object: nil)
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

extension LTClassViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LTSecondCell.self), for: indexPath)
        if let aCell = cell as? LTSecondCell {
            aCell.model = viewModel.products?[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = LTProductDetailsController()
        vc.productModel = viewModel.products![indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LTClassViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sorts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LTFirstClassCell.self), for: indexPath)
        if let icell = cell as? LTFirstClassCell {
            icell.model = viewModel.sorts?[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = viewModel.sorts?[indexPath.row] else { return }
        if model.isSelect {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
            return
        }
        viewModel.sorts![selectIndex.row].isSelect = false
        viewModel.sorts![indexPath.row].isSelect = true
        if let cell = tableView.cellForRow(at: selectIndex) as? LTFirstClassCell {
            cell.model = viewModel.sorts?[selectIndex.row]
        }
        if let cell = tableView.cellForRow(at: indexPath) as? LTFirstClassCell {
            cell.model = viewModel.sorts?[indexPath.row]
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        }
        selectIndex.row = indexPath.row
        sortSearchByClass(name: viewModel.sorts![indexPath.row].name)
    }
}

extension LTClassViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let searchVC = LTSearchViewController()
        searchVC.placeholder = search?.placeholder
        navigationController?.pushViewController(searchVC, animated: false)
        return false
    }
}

