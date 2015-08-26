//
//  TextFieldFormCell.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit

public class TextViewFormCell: FormCell, UITextViewDelegate {

    @IBOutlet public weak var formTextView: UITextView?

    public override func awakeFromNib() {
        super.awakeFromNib()
        formTextView?.delegate = self
    }

    // MARK: - FormCell

    public override var valueKeyPath: String? {
        return "formTextView.text"
    }

    public override var textInput: UIView? {
        return formTextView
    }


    // MARK: - UITextViewDelegate

    public func textViewDidChange(textView: UITextView) {
        delegate?.formCell(self, valueDidChange: textView.text)
    }

}
