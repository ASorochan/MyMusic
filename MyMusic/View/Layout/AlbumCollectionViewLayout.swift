//
//  AlbumCollectionViewLayout.swift
//  MyMusic
//
//  Created by Anatoly on 16.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

import UIKit

protocol AlbumCollectionViewLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, heightForItemAtIndexPath indexPath: IndexPath) -> CGFloat
    
}

class AlbumCollectionViewLayout: UICollectionViewLayout {

    
    
    var delegate: AlbumCollectionViewLayoutDelegate?
    var numberOfColumns = 1
    
    private var cache: [UICollectionViewLayoutAttributes] = []
    
    private var contentHeight: CGFloat = 0
    private var width: CGFloat {
        return collectionView!.bounds.width
    }
    
    
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: width, height: contentHeight)
    }
    
    
    override func prepare() {
        if cache.isEmpty {
            let columnWidth = width / CGFloat(numberOfColumns)
            var xOffsets : [CGFloat] = []
            for column in 0..<numberOfColumns {
                xOffsets.append(CGFloat(column) * columnWidth)
            }
            var yOffsets = [CGFloat](repeating: 0, count:numberOfColumns)
            var column = 0
            for item in 0..<collectionView!.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                let heigth = delegate!.collectionView(collectionView: collectionView!, heightForItemAtIndexPath: indexPath)
                let frame = CGRect(x: xOffsets[column], y: yOffsets[column], width: columnWidth, height: heigth)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                cache.append(attributes)
                contentHeight = max(contentHeight, frame.maxY)
                yOffsets[column] = yOffsets[column] + heigth
                column = column >= (numberOfColumns - 1) ? 0 : column + 1
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes : [UICollectionViewLayoutAttributes] = []
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        
        return layoutAttributes
    }

}
