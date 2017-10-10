//
//  ActionsSheetCancelCell.swift
//  Wedding
//
//  Created by Shane Qi on 5/27/17.
//  Copyright © 2017 Wedding.com. All rights reserved.
//

import UIKit

class ActionsSheetCell: UITableViewCell {
    
    override var isHighlighted: Bool { didSet {
        backgroundColor = isHighlighted ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) : #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }}
    
    @IBOutlet var titleLabel: UILabel!
    
}

class ActionsSheetCancelCell: ActionsSheetCell, Identifiable {

}

class ActionsSheetDefaultCell: ActionsSheetCell, Identifiable {
    
    @IBOutlet var iconImageView: UIImageView!
    
}

class ActionsSheetDestructiveCell: ActionsSheetCell, Identifiable {
    
    @IBOutlet var iconImageView: UIImageView!
    
}

class ActionsSheetTitleCell: ActionsSheetCell, Identifiable {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        selectionStyle = .none
    }
    
}
