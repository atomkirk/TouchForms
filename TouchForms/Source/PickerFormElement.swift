//
//  TextFieldFormElement.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit

class PickerFormElementDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate  {

    let element: PickerFormElement

    init(element: PickerFormElement) {
        self.element = element
    }

    // MARK: - Picker View Data Source

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return element.values.count
    }

    // MARK: - Picker View Delegate

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var value = element.values[row]
        if let valueTransformer = element.valueTransformer,
            let transformedValue = valueTransformer.transformedValue(value) as? String {
                value = transformedValue
        }
        return value
    }

    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let value = element.values[row]
        element.delegate?.formElement(element, valueDidChange: value)
        if element.closesOnSelect {
            element.closePicker()
        }
    }

}

public class PickerFormElement: FormElement {

    /**
    The label that appears as the title of what the user is picking. On the left of the element is the title and on the
    right is the current value they've chosen.
    */
    public var label: String

    /**
    Closes the picker as soon as the value changes. `YES` by default.
    */
    public var closesOnSelect = true

    /**
    `true` if the picker has currently been toggled visible in the form.
    */
    public var visible = false

    /**
    The possible values to choose from.
    */
    public var values: [String] {
        didSet {
            pickerView.reloadAllComponents()
        }
    }

    var pickerElementDelegate: PickerFormElementDelegate?

    let pickerView: UIPickerView

    public init(label: String, values: [String]) {
        self.label = label
        self.values = values
        self.pickerView = UIPickerView()
        super.init()
        self.pickerElementDelegate = PickerFormElementDelegate(element: self)
        self.pickerView.dataSource = self.pickerElementDelegate
        self.pickerView.delegate = self.pickerElementDelegate
        self.pickerView.backgroundColor = UIColor.whiteColor()
    }

    /**
    Open the actual picker below this element.
    */
    public func openPicker() {
        delegate?.formElement(self, didRequestPresentationOfChildView: pickerView)
    }

    /**
    If the picker is open, close it.
    */
    public func closePicker() {
        delegate?.formElement(self, didRequestDismissalOfChildView: pickerView)
    }

    // MARK: - FormElement

    public override func populateCell() {
        if let cell = cell as? PickerFormCell {
            cell.formLabel?.text = label
            cell.formButton?.enabled = enabled
        }
        super.populateCell()
    }

    public override func isEditable() -> Bool {
        return true
    }

    // MARK: - Cell Delegate

    public override func formCell(cell: FormCell, userDidPerformInteraction interaction: FormCellUserInteraction, view: UIView) {
        if let value = currentModelValue() as? String,
            let index = values.indexOf(value) {
                pickerView.selectRow(index, inComponent: 0, animated: true)
        }
        if !visible {
            visible = true
            delegate?.formElement(self, didRequestPresentationOfChildView: pickerView)
        }
        else {
            visible = false
            delegate?.formElement(self, didRequestDismissalOfChildView: pickerView)
        }
    }

}
