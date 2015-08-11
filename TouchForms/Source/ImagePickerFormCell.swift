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

    @IBOutlet weak var label: UILabel?

    @IBOutlet weak var button: UIButton?

    @IBOutlet weak var imageView: UIImageView?

    public override var valueKeyPath: String {
        return "imageView.image"
    }

    public override func modelValueDidChange() {
        if imageView?.image == nil {
            imageView?.image = placeholderImage
        }
    }

    // MARK: - Actions

    @IBAction func cellWasTapped(sender: UIButton) {
        delegate?.formCell(self, userDidPerformInteraction: .Tap, view: sender)
    }

}
