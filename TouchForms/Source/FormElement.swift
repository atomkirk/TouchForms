//
//  FormElement.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/22/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

/**
Do not create direct instances of this class. It is meant to be subclassed.
*/
public class FormElement: FormCellDelegate, Equatable {
    
    
    public typealias FormCellConfigurationBlock = (FormCell) -> Void


    // MARK: - Initialization

    public init() {

    }

    deinit {
        delegate = nil
    }


    // MARK: - Subclassing

    /**
    Override this method to populate the UI elements of the cell with the information from
    this element.
    */
    public func populateCell() {
        cell?.setNeedsLayout()
        cell?.setNeedsDisplay()
    }

    /**
    Return true if all requirements are met for the form to properly display and use this 
    element. For example, the image picker element can't be added on a device with no cameras 
    and no photo library.
    */
    public func canAddElement() -> Bool {
        return true
    }

    /**
    Return YES if the element has a value that can be edited.
    */
    public func isEditable() -> Bool {
        return false
    }

    /**
    If your custom element can be edited, override this method to add whatever behavior
    you need to start editing your element. For example, a text input element will make
    the text field first responder.
    */
    public func beginEditing() {

    }


    // MARK: - Managing Interaction

    /**
    Controls whether any actionable UIViews are enabled in this form element.
    */
    public var enabled = true {
        didSet {
            updateCell()
        }
    }


    // MARK: - Customizing Appearance

    /**
    Using this value, the form controller will try to fit as many elements on the same line as possible. If you never
    want more than one element per line, set this to the width of the container.
    */
    public var minimumWidth: CGFloat?
    var actualWidth: CGFloat = 0

    /**
    Set how much space there is around the outside of the cell.
    */
    public var margins = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)


    // MARK: - Configuring the Cell

    /**
    The cell used to display this form element. This is `nil` until the collection view that displays the form creates it.
    */
    public internal(set) var cell: FormCell? {
        didSet {
            if let cell = self.cell {
                cell.delegate = self
                updateCell()
                cellConfigurationBlock?(cell)
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
    The evaluated reuse identifier for the element's cell.
    */
    public var cellReuseIdentifier: String {
        return prototypeCellIdentifier ?? cellXib ?? NSStringFromClass(cellClass).stripModule()
    }
    
    /**
    If you are desiging your cells right in storyboards as prototype cells, you can give them identifiers and
    set those identifiers on the element here so it knows what cell to use from the storyboard list of prototype cells.
    */
    public var prototypeCellIdentifier: String?

    /**
    The class of the cell to be used to display this form element. By default, this is the same name as this class with 'Cell' replacing 'Element'.
    */
    private var _cellClass: AnyClass?
    public var cellClass: AnyClass {
        get {
            return _cellClass ?? defaultCellClass
        }
        set {
            _cellClass = newValue
        }
    }

    /**
    The name of the xib file that should be loaded as the cell's UINib.
    */
    public var cellXib: String?


    // MARK: - Binding to a Model

    /**
    The key path to the property on the forms model that this element should be bound to.
    */
    public var modelKeyPath: String?

    /**
    This calls the delegate (the form) to get the current model value for this element's key path.
    */
    public func currentModelValue() -> AnyObject? {
        return self.dataSource?.modelValueForFormElement(self)
    }

    /**
    Add a value transformer that takes the value at `modelKeyPath` and transforms it to what the element cell expects. You can also
    provide a reverse transform that will transform the cell value back to type of value the model expects.
    */
    public var valueTransformer: NSValueTransformer?

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
    */
    public func updateCell() {
        if let cell = cell {
            self.populateCell()
            if isModelKeyPathValid() {
                if let modelValue: AnyObject = transformedModelValue(),
                    let keyPath = cell.valueKeyPath {
                        cell.setValue(modelValue, forKeyPath: keyPath)
                        cell.modelValueDidChange()
                }
            }
        }
    }


    // MARK: - Validating Input

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
        let value: AnyObject? = currentModelValue()
        if let keyPath = modelKeyPath {
            for validator in validators {
                if let error = validator.errorFromValidatingValue(value) {
                    validationErrors.append(error)
                }
            }
        }
        return validationErrors
    }


    // MARK: - Acting as the Cell's Delegate

    /**
    Override this when you need to respond to the user interacting with this element's cell.
    */
    public func formCell(cell: FormCell, userDidPerformInteraction interaction: FormCellUserInteraction, view: UIView) {

    }

    /**
    Override this when you want to respond to the cell changing value. Always call `super`.
    */
    public func formCell(cell: FormCell, valueDidChange value: AnyObject) {
        delegate?.formElement(self, valueDidChange: value)
    }


    // MARK: - Internal

    /**
    When creating custom form elements, you this will be set up for you and you can use the delegate methods to instruct
    the form view controller to do a variety of things for you.
    */
    var delegate: FormElementDelegate?

    /**
    When creating custom form elements, you can use this to get information about the form's model.
    */
    var dataSource: FormElementDataSource?

    /**
    This element and all its child elements sorted top down.
    */
    var elementGroup: [FormElement] {
        return childElementsAbove + [self] + childElementsBelow
    }

    func addChildElement(childElement: ChildFormElement) {
        if childElement.position == .Above {
            childElementsAbove.append(childElement)
        }
        else {
            childElementsBelow.append(childElement)
        }
    }

    func removeChildElement(childElement: ChildFormElement) {
        if let index = find(childElementsAbove, childElement) {
            childElementsAbove.removeAtIndex(index)
        }
        if let index = find(childElementsBelow, childElement) {
            childElementsBelow.removeAtIndex(index)
        }
    }

    /**
    Returns YES if the `modelKeyPath` is valid for use setting and getting values on 
    the model. An attempt to do so with an invalid `modelKeyPath` will result in 
    an exception, so always use this to check first.
    */
    func isModelKeyPathValid() -> Bool {
        if let keyPath = modelKeyPath where !keyPath.hasPrefix("x-") {
            return true
        }
        return false
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

protocol FormElementDataSource {
    func modelValueForFormElement(element: FormElement) -> AnyObject?
}

protocol FormElementDelegate {
    func formElement(element: FormElement, valueDidChange value: AnyObject?)
    func formElement(element: FormElement, didRequestPresentationOfViewController controller: UIViewController, animated: Bool, completion: FormBasicBlock?)
    func formElement(element: FormElement, didRequestPresentationOfActionSheet actionSheet: UIActionSheet)
    func formElement(element: FormElement, didRequestPresentationOfChildView childView: UIView)
    func formElement(element: FormElement, didRequestDismissalOfChildView childView: UIView)
    func formElement(element: FormElement, didRequestPushOfViewController controller: UIViewController)
}
