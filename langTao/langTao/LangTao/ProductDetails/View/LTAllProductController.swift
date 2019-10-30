//
//  LTAllProductController.swift
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
//  Created by LonTe on 2019/8/28.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

class LTAllProductController: LTViewController {
    var productList: [LTHomeModel.ProductModel]!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "All products".localString
        // Do any additional setup after loading the view.
        
        addProductList()
    }
    
    func addProductList() {
        let width = (KEYSCREEN_W-30)/2
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: width+60)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectView.backgroundColor = view.backgroundColor
        collectView.delegate = self
        collectView.dataSource = self
        view.addSubview(collectView)
        collectView.register(LTHotItemCell.self, forCellWithReuseIdentifier: String(describing: LTHotItemCell.self))
        
        collectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
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

extension LTAllProductController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LTHotItemCell.self), for: indexPath)
        if let icell = cell as? LTHotItemCell {
            icell.model = productList[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = LTProductDetailsController()
        vc.productModel = productList[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
}
