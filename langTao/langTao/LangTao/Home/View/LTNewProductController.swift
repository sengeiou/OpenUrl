//
//  LTNewProductController.swift
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
//  Created by LonTe on 2019/8/21.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

class LTNewProductController: LTViewController {
    let viewModel = LTNewProductModel()
    var collect: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        addListView()
        configListView()
        addHeader()
        loadData()
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

    func loadData() {
        viewModel.productCreatetime { [weak self] (resutl) in
            guard let `self` = self else { return }
            self.collect?.cr.endHeaderRefresh()
            self.collect?.reloadData()
        }
    }
    
    func addHeader() {
        collect?.cr.addHeadRefresh(animator: SlackLoadingAnimator(), handler: { [weak self] in
            guard let `self` = self else { return }
            self.loadData()
        })
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

extension LTNewProductController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.newModels?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LTHotItemCell.self), for: indexPath)
        if let icell = cell as? LTHotItemCell {
            icell.model = viewModel.newModels?[indexPath.item]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = LTProductDetailsController()
        vc.productModel = viewModel.newModels![indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
}
