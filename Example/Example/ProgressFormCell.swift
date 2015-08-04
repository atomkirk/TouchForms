//
//  ProgressFormCell.swift
//  Example
//
//  Created by Adam Kirk on 7/30/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit
import TouchForms

class ProgressFormCell: FormCell {

    @IBOutlet weak var progressView: UIProgressView!

    override var valueKeyPath: String? {
        return "progressView.progress"
    }

}