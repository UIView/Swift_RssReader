//
//  BarButtonItemExtension.swift
//  RssReader
//
//  Created by Yahui Duan on 16/8/17.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    struct BarCustomStyle {
        var imgRect = CGRectZero
        var textFont : UIFont = UIFont.systemFontOfSize(17.0)
        var textAlignment = NSTextAlignment.Left
        var textColor = UIColor.blackColor()
        var attributedText: NSAttributedString?
        var numberOfLines: Int = 2
    }
    
    func setCustomBackBarItem(image : UIImage , title : String , style : BarCustomStyle) -> UIButton {
        
        let itemImageView = UIImageView.init(frame: style.imgRect)
        itemImageView.image = image
        
        let titleX = itemImageView.frame.size.width + itemImageView.frame.origin.x + 5
        
        let titleLabel = UILabel.init(frame: CGRect.init(x: titleX, y: 2, width: 40, height: 40))
        titleLabel.text = title
        titleLabel.font = style.textFont
        titleLabel.textAlignment = style.textAlignment
        titleLabel.textColor = style.textColor
        titleLabel.attributedText = style.attributedText
        titleLabel.numberOfLines = style.numberOfLines
        
        let titleWidth = titleLabel.frame.size.width + titleLabel.frame.origin.x + 20
        
        let cutomView = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: titleWidth, height: 44))
        cutomView.addSubview(titleLabel)
        return cutomView
    }
    
    
}