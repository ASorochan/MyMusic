//
//  AlbumSongsCollectionViewLayout.swift
//  MyMusic
//
//  Created by Anatoly on 16.01.17.
//  Copyright © 2017 Anatoly Sorochan. All rights reserved.
//

import UIKit

class AlbumSongsCollectionViewLayout: UICollectionViewFlowLayout {

    
    var maximumStretchHeight: CGFloat = 0
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        let offset = collectionView!.contentOffset
        
        if offset.y < 0 {
            let deltaY = fabs(offset.y)
            for attributes in layoutAttributes! {
                
                if let elementKind = attributes.representedElementKind {
                    if elementKind == UICollectionElementKindSectionHeader {
                        var frame = attributes.frame
                        
                        frame.size.height = max(0, headerReferenceSize.height + deltaY)
                        frame.origin.y = frame.minY - deltaY
                        attributes.frame = frame
                    }
                }
                
            }
        }
        
        return layoutAttributes
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    
}
