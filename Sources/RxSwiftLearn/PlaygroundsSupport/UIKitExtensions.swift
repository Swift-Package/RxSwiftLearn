//
//  UIKitExtensions.swift
//  RxSwiftLearn
//
//  Created by 杨俊艺 on 2025/12/17.
//

import UIKit

public extension UILabel {
	class func make(_ title: String) -> UILabel {
		let label = UILabel()
		label.text = title
		label.numberOfLines = 0
		label.lineBreakMode = .byWordWrapping
		return label
	}
	
	class func makeTitle(_ title: String) -> UILabel {
		let label = make(title)
		label.font = UIFont.boldSystemFont(ofSize: UIFont.systemFontSize * 2.0)
		label.textAlignment = .center
		return label
	}
}

public extension UIStackView {
	class func makeVertical(_ views: [UIView]) -> UIStackView {
		let stack = UIStackView(arrangedSubviews: views)
		stack.translatesAutoresizingMaskIntoConstraints = false
		stack.distribution = .fill
		stack.axis = .vertical
		stack.spacing = 15
		return stack
	}
	
	func insert(_ view: UIView, at index: Int) {
		insertArrangedSubview(view, at: index)
	}
	
	func keep(atMost: Int) {
		while arrangedSubviews.count > atMost {
			let view = arrangedSubviews.last!
			removeArrangedSubview(view)
			view.removeFromSuperview()
		}
	}
}
