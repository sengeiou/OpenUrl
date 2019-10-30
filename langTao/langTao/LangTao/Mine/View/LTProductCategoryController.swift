//
//  LTProductCategoryController.swift
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
//  Created by LonTe on 2019/8/30.
//  Copyright © 2019 LonTe. All rights reserved.
//


import UIKit

class LTProductCategoryController: LTViewController {
    let viewModel = LTMeViewModel()

    var table: UITableView!

    private var block: ((LTSortModels.SortModel)->())!
    init(completed: @escaping (LTSortModels.SortModel)->()) {
        super.init(nibName: nil, bundle: nil)
        block = completed
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ProductCategory".localString
        // Do any additional setup after loading the view.
        addList()
        loadData()
        
    }
 
    func loadData() {
        viewModel.allSort { [weak self] (result) in
            guard let `self` = self else { return }
            if case .success = result {
                self.table.reloadData()
            }
        }
    }
    
    func addList() {
        table = UITableView(frame: .zero, style: .plain)
        table.backgroundColor = UIColor.white
        table.separatorInset.left = KEYSCREEN_W
        table.rowHeight = 44
        table.delegate = self
        table.dataSource = self
        view.addSubview(table)
        table.contentInset.bottom = 30

        table.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
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

extension LTProductCategoryController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sorts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.backgroundColor = tableView.backgroundColor
        cell.separatorInset.left = 16
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.text = viewModel.sorts?[indexPath.row].sort
        if let isSelect = viewModel.sorts?[indexPath.row].isSelect, isSelect {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let model = viewModel.sorts?[indexPath.row] {        
            block(model)
            navigationController?.popViewController(animated: true)
        }
    }
}
