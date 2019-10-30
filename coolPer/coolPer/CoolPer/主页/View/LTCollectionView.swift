//
//  LTCollectionView.swift
//  coolPer
//
//  Created by LonTe on 2019/7/10.
//  Copyright © 2019 LangTe. All rights reserved.
//

import UIKit
import YYFast

class LTCollectionView: UICollectionView {
    var itemSource: [ItemSouce]?
    var itemSpace: CGFloat = 0
    var topInset: CGFloat = 0
    var block: ((Int)->())?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = UIColor.clear
        delegate = self
        dataSource = self
        register(LTHomeItem.self, forCellWithReuseIdentifier: String(describing: LTHomeItem.self))
        alwaysBounceVertical = true
    }
    
    func clickHomeItem(_ callBack:@escaping ((Int)->())) {
        block = callBack
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension LTCollectionView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemSource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LTHomeItem.self), for: indexPath)
        if let cells = cell as? LTHomeItem, let titleLabel = cells.titleLabel, let imageView = cells.imageView, let source = itemSource?[indexPath.item] {
            cell.backgroundColor = source.bgColor
            titleLabel.text = source.title
            imageView.image = source.image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        block?(indexPath.item)
    }
}
