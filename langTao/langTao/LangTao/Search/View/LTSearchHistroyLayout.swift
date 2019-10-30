//
//  LTSearchHistroyLayout.swift
//  langTao
//
//  Created by LonTe on 2019/8/1.
//  Copyright © 2019 LonTe. All rights reserved.
//

import UIKit

@objc protocol SearchViewFlowDelegateLayout: UICollectionViewDelegateFlowLayout {
    func collectionView(itemTitleAt indexPath: IndexPath) -> String
}

class LTSearchHistroyLayout: UICollectionViewFlowLayout {
    var titleFont = UIFont.systemFont(ofSize: 15)
    private var hearderDic = [Int : CGRect]()
    private var itemDic = [IndexPath : CGRect]()
    private var sumHeight: CGFloat = 0
    private var sumWidth: CGFloat = 0
    private var yIndex = [CGFloat]()

    override func prepare() {
        super.prepare()
        
        guard let collect = collectionView else { return }
        hearderDic.removeAll()
        itemDic.removeAll()
        yIndex.removeAll()
        sumHeight = 0
        
        let sectionCount = collect.numberOfSections
        for section in 0..<sectionCount {
            let itemCount = collect.numberOfItems(inSection: section)
            for item in 0..<itemCount {
                if item == 0 {
                    let headerSize = (collect.delegate as? SearchViewFlowDelegateLayout)?.collectionView?(collect, layout: self, referenceSizeForHeaderInSection: section)
                    let size = headerSize ?? headerReferenceSize
                    headerInSection(section, width: size.width, height: size.height)
                }
                let title = (collect.delegate as? SearchViewFlowDelegateLayout)?.collectionView(itemTitleAt: IndexPath(item: item, section: section))
                if let showText = title {
                    let tSize = NSString(string: showText).boundingRect(with: .zero, options: [.usesLineFragmentOrigin], attributes: [.font : titleFont], context: nil).size
                    itemInIndexPath(IndexPath(item: item, section: section), width: tSize.width, height: tSize.height)
                    continue
                }
                let iItemSize = (collect.delegate as? SearchViewFlowDelegateLayout)?.collectionView?(collect, layout: self, sizeForItemAt: IndexPath(item: item, section: section))
                let itemS = iItemSize ?? itemSize
                itemInIndexPath(IndexPath(item: item, section: section), width: itemS.width, height: itemS.height)
            }
        }
        
        averageItemWidth()
    }
    
    private func headerInSection(_ section: Int, width: CGFloat, height: CGFloat) {
        hearderDic[section] = CGRect(x: 0, y: sumHeight, width: width, height: height)
        sumHeight += height
    }
    
    private func itemInIndexPath(_ indexPath: IndexPath, width: CGFloat, height: CGFloat) {
        let iWidth = width+40
        let iHeight = height+20

        if indexPath.item == 0 {
            sumWidth = 15
            sumHeight += iHeight
        }
        
        if sumWidth+iWidth <= collectionView!.frame.width-15 {
            itemDic[indexPath] = CGRect(x: sumWidth, y: sumHeight-iHeight, width: iWidth, height: iHeight)
            sumWidth += (iWidth+10)
        } else {
            if sumWidth == 15 {
                itemDic[indexPath] = CGRect(x: sumWidth, y: sumHeight-iHeight, width: collectionView!.frame.width-30, height: iHeight)
                sumHeight += (iHeight+10)
            } else {
                sumHeight += (iHeight+10)
                sumWidth = 15
                if iWidth <= collectionView!.frame.width-30 {
                    itemDic[indexPath] = CGRect(x: sumWidth, y: sumHeight-iHeight, width: iWidth, height: iHeight)
                    sumWidth += (iWidth+10)
                } else {
                    itemDic[indexPath] = CGRect(x: sumWidth, y: sumHeight-iHeight, width: collectionView!.frame.width-30, height: iHeight)
                    sumWidth += (iWidth+10)
                }
            }
        }
        if !yIndex.contains(sumHeight-iHeight) {
            yIndex.append(sumHeight-iHeight)
        }
    }
    
    private func averageItemWidth() {
        for y in yIndex {
            let eqArr = itemDic.filter { $0.value.origin.y == y }
            guard let indexPath = eqArr.keys.sorted().last else { continue }
            guard let maxX = eqArr[indexPath]?.maxX else { continue }
            let averageWidth = (collectionView!.frame.width-15-maxX)/CGFloat(eqArr.count)
            var start: CGFloat = 15
            for indexPath in eqArr.keys.sorted() {
                guard let _ = itemDic[indexPath] else { continue }
                itemDic[indexPath]!.origin.x = start
                itemDic[indexPath]!.size.width += averageWidth
                start += (itemDic[indexPath]!.size.width+10)
            }
        }
    }
    
    private func indexPathsOfItemsInRect(in rect: CGRect) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for (indexPath, itemRect) in itemDic {
            if itemRect.intersects(rect) {
                indexPaths.append(indexPath)
            }
        }
        return indexPaths
    }
    
    func indexPathsOfHeadersInRect(in rect: CGRect) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for (section, itemRect) in hearderDic {
            if itemRect.intersects(rect) {
                indexPaths.append(IndexPath(item: 0, section: section))
            }
        }
        return indexPaths
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        attributes.frame = hearderDic[indexPath.section] ?? .zero
        return attributes
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        let indexPaths = indexPathsOfItemsInRect(in: rect)
        for indexPath in indexPaths {
            if let attribute = layoutAttributesForItem(at: indexPath) {
                attributes.append(attribute)
            }
        }
        let headerIndexs = indexPathsOfHeadersInRect(in: rect)
        for indexPath in headerIndexs {
            if let attribute = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath) {
                attributes.append(attribute)
            }
        }
        return attributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = itemDic[indexPath] ?? .zero
        return attributes
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.frame.width, height: sumHeight+10)
    }
}
