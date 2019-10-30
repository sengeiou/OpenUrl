//
//  LTProductManagerController.swift
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
//  Created by LonTe on 2019/9/5.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

class LTProductManagerController: LTViewController {
    var detailModel: LTDetailModel.DetailModel?
    var collect: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Product management".localString
        // Do any additional setup after loading the view.
        addListView()
        configListView()
        
        if let list = detailModel?.productList {
            if list.count == 0 {
                addNoDataView(inView: collect!)
            }
        } else {
            addNoDataView(inView: collect!)
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
            $0.edges.equalToSuperview()
        }
    }
    
    func configListView() {
        collect?.register(LTHotItemCell.self, forCellWithReuseIdentifier: String(describing: LTHotItemCell.self))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
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

extension LTProductManagerController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailModel?.productList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LTHotItemCell.self), for: indexPath)
        if let icell = cell as? LTHotItemCell {
            icell.model = detailModel?.productList?[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = detailModel!.productList![indexPath.item]
        if model.state == 2 {
            let vc = LTUploadProductController()
            vc.contorllerType = .modify
            vc.enterpriseModel = detailModel?.enterprise
            vc.productModel = model
            vc.productDidChang { [weak self] (type, m) in
                guard let `self` = self else { return }
                switch type {
                case .modif:
                    let models = self.detailModel!.productList!.map({ (model) -> LTHomeModel.ProductModel in
                        var new = model
                        if model.id == m.id {
                            new.state = 1
                        }
                        return new
                    })
                    self.detailModel?.productList = models
                case .delete:
                    let models = self.detailModel!.productList!.filter({ (model) -> Bool in
                        return model.id != m.id
                    })
                    self.detailModel?.productList = models
                }
                collectionView.reloadData()
            }
            navigationController?.pushViewController(vc, animated: true)
        } else {
            LTHUD.show(text: "This product is under review, please wait a moment...".localString)
        }
    }
}
