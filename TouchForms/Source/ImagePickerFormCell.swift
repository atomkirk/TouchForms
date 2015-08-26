//
//  TextFieldFormCell.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit

public class ImagePickerFormCell: FormCell {

    public var placeholderImage: UIImage?

    @IBOutlet public weak var formLabel: UILabel?

    @IBOutlet public weak var formImageView: UIImageView?

    @IBOutlet weak var formButton: UIButton?

    public override var valueKeyPath: String {
        return "formImageView.image"
    }

    public override func modelValueDidChange() {
        if formImageView?.image == nil {
            formImageView?.image = placeholderImage
        }
    }

    // MARK: - Actions

    @IBAction func cellWasTapped(sender: UIButton) {
        delegate?.formCell(self, userDidPerformInteraction: .Tap, view: sender)
    }

}
