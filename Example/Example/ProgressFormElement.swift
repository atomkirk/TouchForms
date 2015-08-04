//
//  ProgressFormElement.swift
//  Example
//
//  Created by Adam Kirk on 7/30/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit
import TouchForms

class ProgressFormElement: FormElement {

    var progress = Float(0) {
        didSet {
            updateCell()
        }
    }

    override func populateCell() {
        if let cell = cell as? ProgressFormCell {
            cell.progressView.progress = progress
        }
    }

}

