//
//  FormController.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/22/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit

let TextFieldFormCellDidHitReturnKeyNotification = "TextFieldFormCellDidHitReturnKeyNotification"

public typealias FormBasicBlock = () -> Void

public enum FormElementRelativePosition {
    case Above
    case Below
}

/**
This view controller can be used to manage a collection view, using it to display a form with a wealth of features. You simply
create one of these form view controllers and configure it by adding form elements to it. You can also subclass it, making it
compatible with storyboards. Drag a Collection View Controller onto your storyboard and assign your subclass to it. When it is
instantiated, your implementation of `configureForm` will be called where you can add form elements.
*/
public class FormController: UICollectionViewController, UICollectionViewDelegateFlowLayout, FormElementDataSource, FormElementDelegate {

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private var elements = [FormElement]()

    private var isAlreadyAppeared = false

    private var outstandingValidationErrorCount = 0

    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if !isAlreadyAppeared {
            isAlreadyAppeared = true
            collectionView?.alwaysBounceVertical = true
            if view.backgroundColor == nil {
                view.backgroundColor = UIColor.groupTableViewBackgroundColor()
            }
            if let collectionView = collectionView,
                let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//                    flowLayout.estimatedItemSize = CGSizeMake(collectionView.bounds.size.width, 100)
//                    flowLayout.itemSize = CGSize(width: collectionView.bounds.size.width, height: 100)
                    flowLayout.minimumLineSpacing = 0
                    flowLayout.minimumInteritemSpacing = 0
            }
            configureForm()
            registerElementCellsForReuse()
            setupKeyboardNotifications()
            if let title = navigationItem.title where count(title) == 0 {
                navigationItem.title = self.title
            }
        }
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        removeAllModelObservers()
    }


    // MARK: - Public

    /**
    Sets the width of the form so no matter how big the container, the form will stay a certain width. Setting it to 0 will use the
    width of the container. If the value is bigger than the width of the container, the value of the container will be used.
    */
    public var fixedWidth: CGFloat?

    /**
    Set the model for this form. As you add form elements, you will associated those elements with key paths on the model and they will
    be linked bi-directionally. The form element will always display the current value of the model and the model will always be
    updated as the form element is updated by the user.
    */
    public var model: AnyObject? {
        didSet {
            removeAllModelObservers()
            for element in elements {
                if let modelKeyPath = element.modelKeyPath
                where elementHasValidKeyPath(element) {
                    model?.addObserver(self, forKeyPath: modelKeyPath, options: nil, context: nil)
                }
                element.updateCell()
            }
        }
    }

    /**
    The delegate for the form controller that lets you know of interesting events.
    */
    public weak var formDelegate: FormControllerDelegate?

    public weak var formModelDelegate: FormControllerModelDelegate?

    public weak var formElementsDelegate: FormControllerElementsDelegate?

    /**
    If set to NO, all editable, tapable, actionable elements in the from will be disabled.
    */
    public var enabled = false {
        didSet {
            for element in elements {
                element.enabled = enabled
            }
        }
    }

    /**
    If your method of choice is to subclass `MYSFormCollectionView`, override this method in your subclass to configure your form.
    */
    public func configureForm() {
        // overriden by subclasses
    }

    /**
    Create subclasses of `MYSFormElement` and use this method to add them to the form. Elements will be displayed in the order they were
    added with this method.
    */
    public func addFormElement(element: FormElement) {
        addFormElement(element, atIndex: nil)
    }

    /**
    Allows you to add an element at a specific index;
    */
    public func addFormElement(element: FormElement, atIndex index: Int?) {
        if !element.canAddElement() {
            return
        }

        element.dataSource = self
        element.delegate = self

        if let index = index {
            elements.insert(element, atIndex: index)
        }
        else {
            elements.append(element)
        }

        registerCellClassForReuse(element.cellClass)
        element.testcell = collectionView?.dequeueReusableCellWithReuseIdentifier(stringFromClassWithoutModule(element.cellClass), forIndexPath: NSIndexPath(forItem: 0, inSection: elements.count - 1)) as? FormCell
        element.updateCell()

        if let modelKeyPath = element.modelKeyPath
            where elementHasValidKeyPath(element) {
                model?.addObserver(self, forKeyPath: modelKeyPath, options: nil, context: nil)
        }
        collectionView?.reloadData()
    }

    /**
    Runs all the validations on the model and adds validation errors by the elements that failed their validations.
    Returns YES if there were no errors and NO if there were validation errors.
    */
    public func validate() -> Bool {
        if collectionView?.window == nil {
            return true
        }

        // validate and add any needed form elements
        var valid = true
        var errorElementsToShow = [MessageChildFormElement]()
        for element in elements {
            let validationErrors = element.validationErrors()
            if validationErrors.count > 0 {
                valid = false
                for error in validationErrors {
                    let errorFormElement = MessageChildFormElement(message: error.localizedDescription, type: .ValidationError, parentElement: element)
                    errorElementsToShow.append(errorFormElement)
                }
            }
        }
        outstandingValidationErrorCount = errorElementsToShow.count

        //remove all existing error elements
        hideChildrenOfElements(elements, type: .ValidationError) {
            self.showChildElements(errorElementsToShow, position: .Below, duration: 0)
        }

        return true
    }

    /**
    Whatever text input in the form has first responder status will be asked to resign it.
    */
    public func attemptToDismissKeyboard() {
        currentFirstResponder()?.resignFirstResponder()
    }

    /**
    All visible text inputs in the form. Ordered from top to bottom.
    */
    public func visibleTextInputs() -> [UIView] {
        var visibleTextInputs = [UIView]()
        for element in elements {
            if let textInput = element.cell?.textInput where textInput.window != nil {
                visibleTextInputs.append(textInput)
            }
        }
        return visibleTextInputs
    }

    /**
    A loading spinner with `message` will be displayed above the element specified. If nil is passed in for the element, the loading message
    will be displayed above the topmost element of the form.
    */
    public func showLoadingMessage(message: String, aboveElement element: FormElement, completion: FormBasicBlock? = nil) {
        if collectionView?.window == nil {
            return
        }
        let loadingElement = MessageChildFormElement(message: message, type: .Loading, parentElement: element)
        showChildElements([loadingElement], position: .Above, duration: 0, completion: completion)
    }

    /**
    If an element is passed in, the loading messages above it will be dismissed. If nil is passed in, all loading messages will be dismissed.
    */
    public func hideLoadingAboveElement(element: FormElement, completion: FormBasicBlock? = nil) {
        if collectionView?.window == nil {
            return
        }
        hideChildrenOfElements([element], type: .Loading, completion: completion)
    }

    /**
    Displays an error message above `element` for the specified duration. `element` cannot be nil.
    */
    public func showErrorMessage(message: String, belowElement element: FormElement, duration: NSTimeInterval, completion: FormBasicBlock? = nil) {
        if collectionView?.window == nil {
            return
        }
        let errorlement = MessageChildFormElement(message: message, type: .Error, parentElement: element)
        showChildElements([errorlement], position: .Below, duration: duration, completion: completion)
    }

    /**
    For manually hiding an error message if you didn't provide a duration when showing it, or you want to hide it early.
    */
    public func hideErrorMessageBelowElement(element: FormElement, completion: FormBasicBlock? = nil) {
        if collectionView?.window == nil {
            return
        }
        hideChildrenOfElements([element], type: .Error, completion: completion)
    }

    /**
    Displays a success message below a form element.
    */
    public func showSuccessMessage(message: String, belowElement element: FormElement, duration: NSTimeInterval, completion: FormBasicBlock? = nil) {
        if collectionView?.window == nil {
            return
        }
        let errorlement = MessageChildFormElement(message: message, type: .Success, parentElement: element)
        showChildElements([errorlement], position: .Below, duration: duration, completion: completion)
    }

    /**
    For manually hiding a success message if you didn't provide a duration when showing it, or you want to hide it early.
    */
    public func hideSuccessMessageBelowElement(element: FormElement, completion: FormBasicBlock? = nil) {
        if collectionView?.window == nil {
            return
        }
        hideChildrenOfElements([element], type: .Success, completion: completion)
    }

    /**
    Show an arbitrary view below an element in the form.
    */
    public func showView(view: UIView, relativeTo element: FormElement, position: FormElementRelativePosition, completion: FormBasicBlock? = nil) {
        let viewChildElement = ViewChildFormElement(view: view, parentElement: element)
        showChildElements([viewChildElement], position: position, duration: 0, completion: completion)
    }

    /**
    Hide all arbitrary views that have been shown by a form element.
    */
    public func hideViewRelativeToElement(element: FormElement, completion: FormBasicBlock? = nil) {
        hideChildrenOfElements([element], type: .View, completion: completion)
    }


    // MARK: - DATASOURCE collection view

    public override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.elements.count
    }

    public override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let element = elements[section]
        return element.elementGroup.count
    }

    public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let elementGroup = elements[indexPath.section].elementGroup
        let element = elementGroup[indexPath.row]
        let cell = element.testcell!//collectionView.dequeueReusableCellWithReuseIdentifier(stringFromClassWithoutModule(element.cellClass), forIndexPath: indexPath) as! FormCell
        cell.contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        cell.contentView.addConstraint(NSLayoutConstraint(item: cell.contentView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: view.bounds.size.width))
        element.cell = cell
        return cell
    }


    // MARK: - DELEGATE collection view

    public override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section < elements.count,
            let cell = cell as? FormCell {
                let element = elements[indexPath.section]
                formElementsDelegate?.formController(self, willRemoveElement: element, cell: cell)
        }
    }


    // MARK: - DELEGATE flow layout

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let elementGroup = elements[indexPath.section].elementGroup
        let element = elementGroup[indexPath.item]
        if let cell = element.testcell {
            cell.layoutIfNeeded()
            return CGSize(width: collectionView.bounds.size.width, height: cell.bounds.size.height)
        }
        else {
            return CGSize(width: collectionView.bounds.size.width, height: 44)
        }
    }

    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
    }


    // MARK: - DATASOURCE form element

    public func modelValueForFormElement(element: FormElement) -> AnyObject? {
        if elementHasValidKeyPath(element) {
            if let model: AnyObject = model, modelKeyPath = element.modelKeyPath {
                return model.valueForKeyPath(modelKeyPath)
            }
        }
        return nil
    }


    // MARK: - DELEGATE form element

    public func formElement(element: FormElement, valueDidChange value: AnyObject?) {

        var transformedValue: AnyObject? = value

        // tranform the value if needed
        if let valueTransformer = element.valueTransformer {
            transformedValue = element.valueTransformer?.reverseTransformedValue(value)
        }

        if let transformedValue: AnyObject = transformedValue {
            if self.elementHasValidKeyPath(element) {
                if let modelKeyPath = element.modelKeyPath {
                    model?.setValue(transformedValue, forKeyPath: modelKeyPath)
                }
                formModelDelegate?.formController(self, didUpdateModelWithValue: transformedValue, element: element)
            }
            else {
                formModelDelegate?.formController(self, failedToUpdateModelWithValue: transformedValue, element: element)
            }
        }
    }

    public func formElementNeedsLayout(element: FormElement) {
        if let ip = indexPathOfElement(element) {
            collectionView?.reloadItemsAtIndexPaths([ip])
        }
    }

    public func formElement(element: FormElement, didRequestPresentationOfViewController controller: UIViewController, animated: Bool, completion: FormBasicBlock? = nil) {
        presentViewController(controller, animated: animated, completion: completion)
    }

    public func formElement(element: FormElement, didRequestPresentationOfActionSheet actionSheet: UIActionSheet) {
        actionSheet.showInView(view)
    }

    public func formElement(element: FormElement, didRequestPresentationOfChildView childView: UIView) {
        let viewChildElement = ViewChildFormElement(view: childView, parentElement: element)
        showChildElements([viewChildElement], position: .Below, duration: 0, completion: nil)
    }

    public func formElement(element: FormElement, didRequestDismissalOfChildView childView: UIView) {
        hideChildrenOfElements([element], type: .View, completion: nil)
    }

    public func formElement(element: FormElement, didRequestPushOfViewController controller: UIViewController) {
        navigationController?.pushViewController(controller, animated: true)
    }


    // MARK: - KVO (the model changed)

    public override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        for element in elements {
            if element.modelKeyPath == keyPath {
                if let textInput = element.cell?.textInput where textInput.isFirstResponder() {
                    return
                }
                if let ip = indexPathOfElement(element) {
                    if ip.section < collectionView?.numberOfSections() {
                        collectionView?.reloadItemsAtIndexPaths([ip])
                    }
                }
            }
        }
    }


    // MARK: - Notifications

    func keyboardWillShowNotification(note: NSNotification) {
        if let endFrame = note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let animationDuration = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber,
            let curve = note.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber,
            var insets = collectionView?.contentInset,
            var offset = collectionView?.contentOffset,
            let collectionView = collectionView {
                insets.bottom = endFrame.CGRectValue().size.height
                offset.y += insets.bottom
                UIView.animateWithDuration(animationDuration.doubleValue, delay: 0, options: UIViewAnimationOptions(curve.unsignedLongValue >> 16), animations: { () -> Void in
                    collectionView.contentInset = insets
                }, completion: nil)
        }
    }

    func keyboardWillHideNotification(note: NSNotification) {
        if let animationDuration = note.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber,
            let curve = note.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber,
            var insets = collectionView?.contentInset,
            let collectionView = collectionView {
                insets.bottom = 0
                UIView.animateWithDuration(animationDuration.doubleValue, delay: 0, options: UIViewAnimationOptions(curve.unsignedLongValue >> 16), animations: { () -> Void in
                    collectionView.contentInset = insets
                }, completion: nil)
        }
    }

    func textFieldDidBeginEditingNotification(note: NSNotification) {
        if let textField = note.object as? UITextField,
            let element = elementContainingView(textField) {
                if let nextElement = elementAfter(element) {
                    textField.returnKeyType = .Next
                }
                else {
                    textField.returnKeyType = .Done
                }
        }
    }

    func textFieldDidEndEditingNotification(note: NSNotification) {
        if let textField = note.object as? UITextField {
            if contains(visibleTextInputs(), textField) {
                if outstandingValidationErrorCount > 0 {
                    validate()
                }
            }
        }
    }

    func textFieldDidHitReturnKeyNotification(note: NSNotification) {
        if let cell = note.object as? FormCell,
            let textField = cell.textInput,
            let element = elementContainingView(textField) {
                if let nextElement = elementAfter(element) {
                    attemptToDismissKeyboard()
                    nextElement.beginEditing()
                }
                else {
                    formDelegate?.formControllerDidSubmit(self)
                }
        }
    }


    // MARK: - Private

    // MARK: (showing/hiding child elements)

    private func showChildElements(childElements: [ChildFormElement], position: FormElementRelativePosition, duration: NSTimeInterval, completion: FormBasicBlock? = nil) {
        if collectionView?.window == nil {
            return
        }

        var indexPathsToInsert = [NSIndexPath]()

        var visibleChildElements = [ChildFormElement]()
        for childElement in childElements {
            let visibleChildElements = childElementsOfParentElement(childElement.parentElement, type: childElement.type)
            if contains(visibleChildElements, childElement) {
                continue
            }

            let section = find(elements, childElement.parentElement)!

            childElement.position = position
            childElement.dataSource = self
            childElement.delegate = self

            childElement.parentElement.addChildElement(childElement)
            if let newIndex = find(childElement.parentElement.elementGroup, childElement) {
                let ip = NSIndexPath(forItem: newIndex, inSection: section)
                indexPathsToInsert.append(ip)
            }
        }

        if indexPathsToInsert.count > 0 {
            collectionView?.performBatchUpdates({ () -> Void in
                self.collectionView?.insertItemsAtIndexPaths(indexPathsToInsert)
            }, completion: { (finished) -> Void in
                completion?()
            })
        }
        else {
            completion?()
        }
    }

    private func hideChildrenOfElements(elements: [FormElement], type: ChildFormElementType, completion: FormBasicBlock? = nil) {
        if collectionView?.window == nil {
            return
        }

        var childElements = [ChildFormElement]()
        for element in elements {
            childElements += childElementsOfParentElement(element, type: type)
        }

        var indexPathsToRemove = [NSIndexPath]()
        for childElement in childElements {
            if let cell = childElement.cell,
                let ip = collectionView?.indexPathForCell(cell) {
                    childElement.parentElement.removeChildElement(childElement)
                    indexPathsToRemove.append(ip)
            }
        }

        if indexPathsToRemove.count > 0 {
            collectionView?.performBatchUpdates({
                collectionView?.deleteItemsAtIndexPaths(indexPathsToRemove)
            }, completion: { (finished) in
                completion?()
            })
        }
        else {
            completion?()
        }
    }

    private func childElementsOfParentElement(element: FormElement, type: ChildFormElementType) -> [ChildFormElement] {
        let filtered = element.elementGroup.filter { el in
            if let childElement = el as? ChildFormElement {
                return childElement.type == type
            }
            return false
        }
        if let elements = filtered as? [ChildFormElement] {
            return elements
        }
        else {
            return []
        }
    }


    // MARK: (keyboard)

    private func setupKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShowNotification:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHideNotification:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidBeginEditingNotification:", name: UITextFieldTextDidBeginEditingNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidEndEditingNotification:", name: UITextFieldTextDidEndEditingNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "textFieldDidHitReturnKeyNotification:", name: TextFieldFormCellDidHitReturnKeyNotification, object: nil)
    }


    // MARK: (KVO helpers)

    func removeAllModelObservers() {
        if let model: AnyObject = model {
            for element in elements {
                if let keyPath = element.modelKeyPath where elementHasValidKeyPath(element) {
                    model.removeObserver(self, forKeyPath: keyPath)
                }
            }
        }
    }

    func elementHasValidKeyPath(element: FormElement) -> Bool {
        let hasModel = model != nil
        let isValid = element.isModelKeyPathValid()
        return hasModel && isValid
    }

    // MARK: (text input)

    func elementAfter(anElement: FormElement) -> FormElement? {
        var returnNext = false
        for element in elements {
            if !element.isEditable() || element is ChildFormElement {
                continue
            }
            if returnNext {
                return element
            }
            if element == anElement {
                returnNext = true
            }
        }
        return nil
    }

    func elementContainingView(view: UIView) -> FormElement? {
        for element in elements {
            if let cell = element.cell where view.isDescendantOfView(cell) {
                return element
            }
        }
        return nil
    }

    func currentFirstResponder() -> UIView? {
        let textInputs = visibleTextInputs()
        for textInput in textInputs {
            if textInput.isFirstResponder() {
                return textInput
            }
        }
        return nil
    }

    private func registerCellClassForReuse(cellClass: AnyClass, xib: String? = nil) {
        let nib: UINib
        let classString = stringFromClassWithoutModule(cellClass)
        if let xib = xib {
            let bundle = NSBundle(forClass: self.dynamicType)
            nib = UINib(nibName: xib, bundle: bundle)
        }
        else {
            let bundle = NSBundle(forClass: cellClass)
            nib = UINib(nibName: classString, bundle: bundle)
        }
        collectionView?.registerNib(nib, forCellWithReuseIdentifier: classString)
    }

    private func registerElementCellsForReuse() {
//        for element in elements {
//            registerCellClassForReuse(element.cellClass, xib: element.cellXib)
//        }

        // register metadata cells
        registerCellClassForReuse(MessageChildFormCell.self)

        // register view child cell
        collectionView?.registerClass(ViewChildFormCell.self, forCellWithReuseIdentifier: stringFromClassWithoutModule(ViewChildFormCell.self))
    }


    // MARK: (helpers)

    private func indexPathOfElement(element: FormElement) -> NSIndexPath? {
        if let section = find(elements, element),
            let item = find(element.elementGroup, element) {
                return NSIndexPath(forItem: item, inSection: section)
        }
        return nil
    }

    private func stringFromClassWithoutModule(aClass: AnyClass) -> String {
        let classString = NSStringFromClass(aClass)
        if let index = find(classString, ".") {
            return classString.substringFromIndex(index.successor())
        }
        return classString
    }

}


/**
 Allows you to be informed of interesting events that happen with the form.
 */
public protocol FormControllerDelegate: class {
    /**
    On every text input before the last, the return key on the iOS keyboard will be "Next", moving them to the next text input field.
    On the last text input field, the return key will be a "Done" button and when pressed, this delegate method will be called, indicating
    the user is done filling out the form. You can call `validate` in this method to make sure all forms are filled out correctly and if
    `validate` returns YES, proceed with processing the model the form populated.
    */
    func formControllerDidSubmit(controller: FormController)
}

public protocol FormControllerModelDelegate: class {
    /**
    When the user interacts with the form and changes a value that is successfully updated on the form's model.
    */
    func formController(controller: FormController, didUpdateModelWithValue value: AnyObject, element: FormElement)

    /**
    When a change is made and it can't be associated with a model's property (because no `modelKeyPath` was given, or the `modelKeyPath
    was prefixed with "x-" or no model is associated with the form) this method is called to give you a chance to deal with the value change manually. This is
    useful if you can't associate a model's property with a form element easily and a lot of special case work has to be done to
    get the changed value into a form the model is designed for. This is also useful if you are not using a model with your form, meaning
    the form has no model.
    */
    func formController(controller: FormController, failedToUpdateModelWithValue value: AnyObject, element: FormElement)
}

public protocol FormControllerElementsDelegate: class {
    /**
    Called when the collection view is about to remove (for reuse) an element and the element's cell.
    */
    func formController(controller: FormController, willRemoveElement element: FormElement, cell: FormCell)
}
