//
//  ArticleListTableViewCell.swift
//  RssReader
//
//  Created by Yahui Duan on 16/8/12.
//  Copyright © 2016年 Yahui.Duan. All rights reserved.
//

import UIKit

class ArticleListTableViewCell: UITableViewCell {

    @IBOutlet weak var pTitleLabel: UILabel!
    @IBOutlet weak var pAuthorLabel: UILabel!
    @IBOutlet weak var pTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setArticleData(item: MWFeedItem) {
        self.pTitleLabel.text = item.title
        self.pAuthorLabel.text = item.author
        let formart = NSDateFormatter()
        formart.dateFormat = "yyyy-MM-dd HH:mm"
        if item.date == nil {
            item.date = NSDate()
        }
        self.pTimeLabel.text = formart.stringFromDate(item.date)
    }
}
