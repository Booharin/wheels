//
//  String+Size.swift
//  Guard
//
//  Created by Alexandr Bukharin on 22.09.2020.
//  Copyright © 2020 ds. All rights reserved.
//
import UIKit

extension String {
	func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
		let constraintRect = CGSize(width: width,
									height: .greatestFiniteMagnitude)
		let boundingBox = self.boundingRect(with: constraintRect,
											options: .usesLineFragmentOrigin,
											attributes: [.font: font],
											context: nil)
		return ceil(boundingBox.height)
	}
	
	func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
		let constraintRect = CGSize(width: .greatestFiniteMagnitude,
									height: height)
		let boundingBox = self.boundingRect(with: constraintRect,
											options: .usesLineFragmentOrigin,
											attributes: [.font: font],
											context: nil)
		return ceil(boundingBox.width)
	}
}
