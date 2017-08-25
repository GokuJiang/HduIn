//
//  WaterflowLayout.swift
//  HduIn
//
//  Created by Kevin on 2016/12/15.
//  Copyright © 2016年 姜永铭. All rights reserved.
//

import UIKit

//MARK: --- 常量
/** 列数 */
private let columnCount: Int = 0
/** 行边距 */
private let columnRowMargin: CGFloat = 0
/** 列边距 */
private let columnMargin: CGFloat = 0
/** item的edgeInsets */
private let itemEdgeInsets: UIEdgeInsets = {
    return UIEdgeInsetsMake(0, 0, 0, 0)
}()


//MARK: --- 代理
@objc protocol WaterFlowLayoutDelegate: NSObjectProtocol
{
    
    @objc optional func numberOfColumsForWaterLayout(_ waterFlowLayout: WaterFlowLayout) -> Int
    @objc optional func rowMarginForWaterLayout(_ waterFlowLayout: WaterFlowLayout) -> CGFloat
    @objc optional func columnMarginForWaterLayout(_ waterFlowLayout: WaterFlowLayout) -> CGFloat
    @objc optional func numberOfCellInSectionForWaterLayout(_ waterFlowLayout: WaterFlowLayout) -> Int

}

class WaterFlowLayout: UICollectionViewLayout {
    
    weak var delegate: WaterFlowLayoutDelegate?
    
    //MARK: --- 代理 基本外部数据处理
    
    /**
     列数
     *
     */
    
    func numberOfColumns() -> Int {
        
        let i = delegate?.numberOfColumsForWaterLayout?(self)
        
        guard (i != nil) else
        {
            return columnCount
        }
        return i!
    }
    /**
     行间距
     *
     */
    
    func rowMargin() -> CGFloat {
        let i = delegate?.rowMarginForWaterLayout?(self)
        guard (i != nil) else
        {
            return columnRowMargin
        }
        return i!
        
    }
    /**
     列间距
     *
     */
    
    func column2Margin() -> CGFloat {
        let i = delegate?.columnMarginForWaterLayout?(self)
        guard (i != nil) else
        {
            return columnMargin
        }
        return i!
        
    }
    //MARK: --- 懒加载
    /** 存放所有的item的UICollectionViewLayoutAttributes数组 */
    lazy var attrsArray: [UICollectionViewLayoutAttributes] = {
        return Array()
    }()
    /** 存放每一列的最大高度的数组 */
    lazy var columnMaxYArray: [CGFloat] = {
        
        var array = [CGFloat]()
        
        let  numberOfColumns = self.numberOfColumns()
        for i in 0..<numberOfColumns
        {
            array.append(0)
        }
        
        return array
    }()
    
    
    //MARK: --- 内部控制方法
    /** 初始化 */
    override func prepare() {
        super.prepare()
        
        attrsArray.removeAll()
        
        
        //确定item个数
        let itemCount = collectionView!.numberOfItems(inSection: 0)
        
        for i in 0..<itemCount{
            //拿到item所在的indexPath
            let indexPath = IndexPath(row: i, section: 0)
            
            guard let attrs = layoutAttributesForItem(at: indexPath) else {return}
            attrsArray.append(attrs)
        }
    }
    /** 返回对应rect的item的布局 */
    /** 继承UICollectionViewLayout的子类，该方法会频繁调用 */
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return attrsArray
    }
    /** 返回collectionview滚动范围 */
    override var collectionViewContentSize: CGSize
    {
        let h = attrsArray.last!.frame.maxY + rowMargin()
        return CGSize(width: 0, height: h)
    }
    
    /** 返回对应位置的item布局 */
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        //创建UICollectionViewLayoutAttributes对象
        let attrs = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        //记录高度最小的列高
        var minY = columnMaxYArray[0]
        //记录高度最小的列
        var destinationColumn = 0
        for index in 1..<columnMaxYArray.count
        {
            let instance = columnMaxYArray[index]
            if instance < minY
            {
                minY = instance
                destinationColumn = index
            }
        }
        
        let  numberOfColumns = self.numberOfColumns()
        
        var w: CGFloat = (collectionView!.frame.size.width - itemEdgeInsets.left - itemEdgeInsets.right - (CGFloat(numberOfColumns) - 1) * column2Margin()) / CGFloat(numberOfColumns)
        
        
        var h: CGFloat = 200 + CGFloat(arc4random_uniform(100))
        //item 布局
        var x: CGFloat = column2Margin() + CGFloat(destinationColumn) * (w + column2Margin())
        var y: CGFloat = minY + rowMargin()
        
        if (delegate?.numberOfCellInSectionForWaterLayout?(self) == 4 ) {
            switch indexPath.row%4 {
            case 0:
                w = 174
                h = 214
                x = 0
                y = (SCREEN_HEIGHT / 2 ) * CGFloat((indexPath.row / 4) as Int)
                break
            case 1:
                w =  SCREEN_WIDTH - 174
                h = 141
                x = 174
                y = (SCREEN_HEIGHT / 2 ) * CGFloat((indexPath.row / 4) as Int)
                break
            case 2:
                w =  SCREEN_WIDTH - 174
                h = SCREEN_HEIGHT / 2 - 141
                x = 174
                y = 141 + (SCREEN_HEIGHT / 2 ) * CGFloat((indexPath.row / 4 ) as Int)
                break
            case 3:
                w = 174
                h = SCREEN_HEIGHT / 2  - 214
                x = 0
                y = 214 + (SCREEN_HEIGHT / 2 ) * CGFloat((indexPath.row / 4 ) as Int)
                break
            default:
                break
            }

        }
        
        if (delegate?.numberOfCellInSectionForWaterLayout?(self) == 5 ) {
            switch indexPath.row%5 {
            case 0:
                w = 174
                h = 224
                x = 0
                y = (SCREEN_HEIGHT * 0.55 ) * CGFloat((indexPath.row / 5) as Int)
                break
            case 1:
                w =  SCREEN_WIDTH - 174
                h = 100
                x = 174
                y = (SCREEN_HEIGHT * 0.55 ) * CGFloat((indexPath.row / 5) as Int)
                break
            case 2:
                w = SCREEN_WIDTH - 174
                h = 191
                x = 174
                y = 100 + (SCREEN_HEIGHT * 0.55 ) * CGFloat((indexPath.row / 5 ) as Int)
                break
            case 3:
                w = 174
                h = SCREEN_HEIGHT * 0.55  - 224
                x = 0
                y = 224 + (SCREEN_HEIGHT * 0.55 ) * CGFloat((indexPath.row / 5 ) as Int)

                break
            case 4:
                w = SCREEN_WIDTH - 174
                h = SCREEN_HEIGHT * 0.55  - 100 - 191
                x = 174
                y = 100 + 191 + (SCREEN_HEIGHT * 0.55 ) * CGFloat((indexPath.row / 5 ) as Int)
                break
            default:
                break
            }
            
        }

        
        attrs.frame = CGRect(x: x, y: y, width: w, height: h)
        
        columnMaxYArray[destinationColumn] = attrs.frame.maxY
        
        return attrs
        
    }
    
}



