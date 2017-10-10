//
//  ActionsSheetViewController.swift
//  Wedding
//
//  Created by Shane Qi on 5/26/17.
//  Copyright © 2017 Wedding.com. All rights reserved.
//

import UIKit

final class ActionsSheetViewController: UIViewController {
	
	@IBOutlet var tableView: UITableView!
	var transitionView: UIView? { return presentationController?.containerView }
	var backgroundOverlay = UIView()
	
	var sheetTitle: String?
	var cancelText: String?
	var actions: [Action] = []
	
	struct Action {
		var image: UIImage?
		var text: String
		var type: ActionType
		var handler: ((Action) -> Void)?
	}
	
	enum ActionType {
		case `default`, destructive
	}
	
	static func getInstance(sheetTitle: String?, cancelText: String?, actions: [Action]) -> ActionsSheetViewController {
		let viewController = (UIStoryboard.init(name: "ActionsSheet", bundle: Bundle.init(for: self)).instantiateInitialViewController() as? ActionsSheetViewController)!
		viewController.sheetTitle = sheetTitle
		viewController.cancelText = cancelText
		viewController.actions = actions.reversed()
		return viewController
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let transitionView = self.transitionView {
			transitionView.addSubview(backgroundOverlay)
			backgroundOverlay.frame = CGRect(origin: .zero, size: transitionView.frame.size)
			backgroundOverlay.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.4)
			backgroundOverlay.alpha = 0
			UIView.animate(withDuration: 0.25) { [unowned self] in
				self.backgroundOverlay.alpha = 1
			}
		}
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.transform = CGAffineTransform(rotationAngle: .pi)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		UIView.animate(withDuration: 0.25) { [unowned self] in
			self.backgroundOverlay.alpha = 0
		}
	}
	
	@IBAction func didTapBackground() {
		guard cancelText != nil else { return }
		dismiss(animated: true, completion: nil)
	}
	
	fileprivate enum CellType {
		case title
		case cancel
		case action(Int)
		case header
	}
	
	fileprivate func cellType(at indexPath: IndexPath) -> CellType {
		if cancelText != nil && indexPath.section == 0 {
			return .cancel
		} else if indexPath.row == actions.count {
			return title == nil ? .header : .title
		} else if indexPath.row > actions.count {
			return .header
		} else {
			return .action(indexPath.row)
		}
	}

}

extension ActionsSheetViewController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return cancelText != nil ? 2 : 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch cellType(at: IndexPath(row: 0, section: section)) {
		case .cancel:
			return 1
		default:
			return actions.count + (sheetTitle != nil ? 1 : 0) + 1
		}
	}
	
	var separatorCellIdentifier: String { return "ActionsSheetSeparatorCell" }
	var marginCellIdentifier: String { return "ActionsSheetMarginCell" }
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		var cell: UITableViewCell
		switch cellType(at: indexPath) {
		case .title:
			let thisCell = (tableView.dequeueReusableCell(withIdentifier: ActionsSheetTitleCell.identifier, for: indexPath)
				as? ActionsSheetTitleCell)!
			thisCell.titleLabel.text = sheetTitle
			cell = thisCell
		case .cancel:
			let thisCell = (tableView.dequeueReusableCell(withIdentifier: ActionsSheetCancelCell.identifier, for: indexPath)
				as? ActionsSheetCancelCell)!
			thisCell.titleLabel.text = cancelText
			cell = thisCell
		case .action(let index):
			let action = actions[index]
			if case .destructive = action.type {
				let thisCell = (tableView.dequeueReusableCell(withIdentifier: ActionsSheetDestructiveCell.identifier, for: indexPath)
					as? ActionsSheetDestructiveCell)!
				thisCell.iconImageView.image = action.image
				thisCell.titleLabel.text = action.text
				cell = thisCell
			} else {
				let thisCell = (tableView.dequeueReusableCell(withIdentifier: ActionsSheetDefaultCell.identifier, for: indexPath)
					as? ActionsSheetDefaultCell)!
				thisCell.iconImageView.image = action.image
				thisCell.titleLabel.text = action.text
				cell = thisCell
			}
		case .header:
			return tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
		}
		cell.transform = CGAffineTransform(rotationAngle: .pi)
		return cell
	}

}

extension ActionsSheetViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		switch cellType(at: indexPath) {
		case .title:
			return
		case .cancel:
			DispatchQueue.main.async { [unowned self] in
				self.dismiss(animated: true, completion: nil)
			}
		case .action(let index):
			DispatchQueue.main.async { [unowned self] in
				self.dismiss(animated: true) {
					let action = self.actions[index]
					action.handler?(action)
				}
			}
		case .header:
			return
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		switch cellType(at: indexPath) {
		case .title:
			return 30
		case .header:
			return 5
		default:
			return 60
		}
	}

}

extension ActionsSheetViewController: UIGestureRecognizerDelegate {
	
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		var view = touch.view
		while view?.superview != nil {
			if view?.superview is UITableViewCell { return false }
			view = view?.superview
		}
		return true
	}

}
