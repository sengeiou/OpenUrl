//
//  LTFactoryController.swift
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
import CRRefresh
import JXSegmentedView

class LTFactoryController: LTViewController {
    let viewModel = LTFactoryViewModel()
    let detailViewModel = LTDetailViewModel()
    var nav: UINavigationController?

    var table: UITableView?
    var sortId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addListView()
        configListView()
        addHeader()
        loadData(sortId)
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
            $0.edges.equalToSuperview()
        }
    }
    
    func configListView() {
        table?.register(LTFactoryCell.self, forCellReuseIdentifier: String(describing: LTFactoryCell.self))
    }
    
    func loadData(_ sort: String?) {
        guard let sortString = sort else { return }
        viewModel.enterpriseSort(sort: sortString) { [weak self] (result) in
            guard let `self` = self else { return }
            self.table?.cr.endHeaderRefresh()
            if let models = self.viewModel.numFactorys, models.count > 0 {
                self.removeNoDataView(formView: self.table!)
            } else {
                self.addNoDataView(inView: self.table!)
            }
            self.table?.reloadData()
        }
    }
    
    func addHeader() {
        table?.cr.addHeadRefresh(animator: SlackLoadingAnimator(), handler: { [weak self] in
            guard let `self` = self else { return }
            self.loadData(self.sortId)
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

extension LTFactoryController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numFactorys?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LTFactoryCell.self), for: indexPath)
        if let iCell = cell as? LTFactoryCell {
            iCell.numModel = viewModel.numFactorys?[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.numFactorys![indexPath.row]
        detailViewModel.enterpriseById(id: model.eid) { [weak self] (result) in
            if case .success = result {
                guard let `self` = self else { return }
                let vc = LTFactroyDetailController()
                vc.detailModel = self.detailViewModel.detailModel
                if let navigation = self.navigationController {
                    navigation.pushViewController(vc, animated: true)
                } else if let navigation = self.nav {
                    navigation.pushViewController(vc, animated: true)
                }
            }
        }
    }
}

extension LTFactoryController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
