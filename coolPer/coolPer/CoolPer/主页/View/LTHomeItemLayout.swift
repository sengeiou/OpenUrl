//
//  LTHomeItemLayout.swift
//  coolPer
//
//  Created by LonTe on 2019/7/10.
//  Copyright © 2019 LangTe. All rights reserved.
//

import UIKit
import YYFast

let itemHeight: CGFloat = (KEYSCREEN_W-50)/4

class LTHomeItemLayout: UICollectionViewFlowLayout {
    override var collectionViewContentSize: CGSize {
        var height: CGFloat = 0
        for item in itemSource {
            if item.frame.maxY > height {
                height = item.frame.maxY
            }
        }
        var size = CGSize(width: collect.frame.width, height: height+10)
        if UIDevice.current.isX() {
            size.height = size.height+34
            collectionView?.scrollIndicatorInsets.bottom = 34
        }
        return size
    }
    
    var collect: LTCollectionView!
    var itemSource: [ItemSouce]!
    var x: CGFloat = 0
    var y: CGFloat = 0
    
    override func prepare() {
        super.prepare()
        
        guard let collectViews = collectionView as? LTCollectionView else {
            return
        }
        guard let source = collectViews.itemSource else {
            return
        }
        
        collect = collectViews
        itemSource = source
        x = collect.itemSpace
        y = collect.topInset+collect.itemSpace
        
        for (index, _) in itemSource.enumerated() {
            confWithItemFrame(index: index)
        }
    }
    
    private func confWithItemFrame(index: Int) {
        let item = itemSource[index]
        if item.title == "微聊" {
            x = collect.itemSpace
            y = y+collect.itemSpace+itemHeight
            itemSource[index].frame = CGRect(x: x, y: y, width: item.itemWidth, height: item.itemHeight)
            x = x+collect.itemSpace+item.itemWidth
            return
        }
        
        if x+item.itemWidth > collect.frame.width {
            x = collect.itemSpace
            y = y+collect.itemSpace+itemHeight
        }
        itemSource[index].frame = CGRect(x: x, y: y, width: item.itemWidth, height: item.itemHeight)
        x = x+collect.itemSpace+item.itemWidth
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        for (index, _) in itemSource.enumerated() {
            if let attribute = layoutAttributesForItem(at: IndexPath(item: index, section: 0)) {
                attributes.append(attribute)
            }
        }
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attribute.frame = itemSource[indexPath.item].frame
        return attribute
    }
}
