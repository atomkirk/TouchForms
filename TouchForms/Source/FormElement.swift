//
//  FormElement.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/22/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

public typealias FormCellConfigurationBlock = (FormCell) -> Void

public protocol FormElementDataSource {
    func modelValueForFormElement(element: FormElement) -> AnyObject?
}

public protocol FormElementDelegate {
    func formElement(element: FormElement, valueDidChange value: AnyObject)
    func formElementNeedsLayout(element: FormElement)
    func formElement(element: FormElement, didRequestPresentationOfViewController controller: UIViewController, animated: Bool, completion: FormBasicBlock?)
    func formElement(element: FormElement, didRequestPresentationOfChildView childView: UIView)
    func formElement(element: FormElement, didRequestDismissalOfChildView childView: UIView)
    func formElementDidRequestResignationOfFirstResponder(element: FormElement)
    func formElement(element: FormElement, didRequestPushOfViewController controller: UIViewController)
}

/**
Do not create direct instances of this class. It is meant to be subclassed.
*/
public class FormElement: Equatable {

    /**
    When creating custom form elements, you this will be set up for you and you can use the delegate methods to instruct
    the form view controller to do a variety of things for you.
    */
    public var delegate: FormElementDelegate?

    /**
    When creating custom form elements, you can use this to get information about the form's model.
    */
    public var dataSource: FormElementDataSource?

    /**
    The key path to the property on the forms model that this element should be bound to.
    */
    public var modelKeyPath: String?

    /**
    The cell ued to display this form element. This is `nil` until the collection view that displays the form creates it.
    */
    public var cell: FormCell? {
        didSet {
            if let cell = self.cell {
                cellConfigurationBlock?(cell)
            }
        }
    }

    /**
    Controls whether any actionable UIViews are enabled in this form element.
    */
    public var enabled = true {
        didSet {
            cell?.populateWithElement(self)
        }
    }

    /**
    The class of the cell to be used to display this form element. By default, this is the same name as this class with Cell replacing Element.
    */
    private var _cellClass: AnyClass?
    var cellClass: AnyClass {
        get {
            return _cellClass ?? defaultCellClass
        }
        set {
            _cellClass = newValue
        }
    }

    /**
    Add a value transformer that takes the value at `modelKeyPath` and transforms it to what the element cell expects. You can also
    provide a reverse transform that will transform the cell value back to type of value the model expects.
    */
    public var valueTransformer: NSValueTransformer?

    /**
    Is asked of the element to make sure this element can be added for this form/device/orientation/whatever.
    For example, the image picker element can't be added on a device with no cameras and no library.
    */
    public func canAddElement() -> Bool {
        return true
    }

    /**
    This calls the delegate (the form) to get the current model value for this element's key path.
    */
    public func currentModelValue() -> AnyObject? {
        return self.dataSource?.modelValueForFormElement(self)
    }

    /**
    Calls the delegate (the form) to get the current model value and applies the value transform on it to get the display value.
    */
    public func transformedModelValue() -> AnyObject? {
        var value: AnyObject? = currentModelValue()

        // transform value if needed
        if let valueTransformer = valueTransformer {
            value = valueTransformer.transformedValue(value)
        }

        return value
    }

    /**
    If any data on this element has changed, call this method to update the cell so it's displayed to the user.

    NOTE: If you subclass a cell and provide a custom xib, the theme of the element will not be applied to the cell.
    Otherwise, there would be a danger of global defaults overriding customizations you've made to your views in your
    custom xib. If you would like to restore this behavior. you can override this method in your custom element subclass
    companion to the custom cell subclass and call `[self.cell applyTheme:[self evaluatedTheme]];` after calling super.
    */
    public func updateCell() {
        if let cell = cell {
            cell.populateWithElement(self)
            if isModelKeyPathValid() {
                if let modelValue: AnyObject = transformedModelValue(),
                    let keyPath = cell.valueKeyPath {
                        cell.setValue(modelValue, forKeyPath: keyPath)
                        cell.didChangeValueAtKeyPath()
                }
            }
        }
    }

    /**
    Called after the cell of this element has been created and assinged to the element, giving you a chance to fully customize
    the look of the cell that will visually represent this element.
    */
    public func configureCellBlock(block: FormCellConfigurationBlock) {
        self.cellConfigurationBlock = block
    }

    /**
    Returns YES if this is the type of form element that accepts text input.
    */
    public func isTextInput() -> Bool {
        return false
    }

    /**
    Returns YES if the element has a value that can be edited.
    */
    public func isEditable() -> Bool {
        return false
    }

    /**
    Make a text input first responder, or "tap" selection style input, or just dismiss the keyboard for inputs such as toggles.
    */
    public func beginEditing() {

    }

    /**
    Returns YES if the `modelKeyPath` is valid for use setting and getting values on the model. An attempt to do so with an invalid
    `modelKeyPath` will result in an exception, so always use this to check first.
    */
    public func isModelKeyPathValid() -> Bool {
        if let keyPath = modelKeyPath where !keyPath.hasPrefix("x-") {
            return true
        }
        return false
    }

    /**
    Add a validation for this element so that when `validationErrors` is called, the validation will be run against the value of
    the form element and generate an error if a validation fails.
    */
    public func addFormValidator(validator: FormValidatorType) {
        validators.append(validator)
    }

    /**
    Will return either an empty array or an array of NSError objects that contain `localizedDescription`s of the failure reason.
    */
    public func validationErrors() -> [NSError] {
        var validationErrors = [NSError]()
        if let keyPath = modelKeyPath,
            let value: AnyObject = currentModelValue() {
                for validator in validators {
                    if let error = validator.errorFromValidatingValue(value) {
                        validationErrors.append(error)
                    }
                }
        }
        return validationErrors
    }


    // MARK: - Internal

    /**
    This element and all its child elements sorted top down.
    */
    var elementGroup: [FormElement] {
        return childElementsAbove + [self] + childElementsBelow
    }

    func addChildElement(childElement: FormChildElement) {
        if childElement.position == .Above {
            childElementsAbove.append(childElement)
        }
        else {
            childElementsBelow.append(childElement)
        }
    }

    func removeChildElement(childElement: FormChildElement) {
        if let index = find(childElementsAbove, childElement) {
            childElementsAbove.removeAtIndex(index)
        }
        if let index = find(childElementsBelow, childElement) {
            childElementsBelow.removeAtIndex(index)
        }
    }


    // MARK: - Private

    private var validators = [FormValidatorType]()

    private var cellConfigurationBlock: FormCellConfigurationBlock?

    private var childElementsAbove = [FormElement]()

    private var childElementsBelow = [FormElement]()

    private var defaultCellClass: AnyClass {
        let className = NSStringFromClass(self.dynamicType)
        let cellClassName = className.stringByReplacingOccurrencesOfString("Element", withString: "Cell")
        return NSClassFromString(cellClassName)
    }

}

public func ==(lhs: FormElement, rhs: FormElement) -> Bool {
    return lhs === rhs
}
