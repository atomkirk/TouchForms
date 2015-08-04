//
//  MessageChildFormElement.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/23/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

class MessageChildFormElement: ChildFormElement, Equatable, Hashable {

    let message: String

    init(message: String, type: ChildFormElementType, parentElement: FormElement) {
        self.message = message
        super.init(parentElement: parentElement, type: type, position: .Below)
    }

    override var cellClass: AnyClass {
        get {
            if type == .Loading {
                return LoadingChildFormCell.self
            }
            return super.cellClass
        }
        set {
            super.cellClass = newValue
        }
    }

    override func populateCell() {
        if let cell = cell as? MessageChildFormCell {
            cell.type = type
            cell.messageLabel.text = message
        }
    }

    // MARK: - Hashable

    var hashValue: Int {
        return message.hashValue
    }

}

// MARK: - Equatable
func ==(lhs: MessageChildFormElement, rhs: MessageChildFormElement) -> Bool {
    return lhs.dynamicType === rhs.dynamicType &&
            lhs.parentElement == rhs.parentElement &&
            lhs.type == rhs.type &&
            lhs.message == rhs.message
}
