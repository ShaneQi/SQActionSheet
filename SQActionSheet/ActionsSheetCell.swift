//
//  ActionsSheetCell.swift
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
