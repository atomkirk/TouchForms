//
//  TextFieldFormElement.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import UIKit

private enum SelectionOptions: String {
    case TakePhoto         = "Take Photo"
    case ChooseFromLibrary = "Choose From Library"
    case Cancel            = "Cancel"
    case RemovePhoto       = "Remove Photo"
}

class ImagePickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {

    var element: ImagePickerFormElement

    init(element: ImagePickerFormElement) {
        self.element = element
    }

    // MARK: - Image Picker Controller Delegate

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerPickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage ?? info[UIImagePickerControllerOriginalImage] as? UIImage {
            element.updateCell()
            element.delegate?.formElement(element, valueDidChange: image)
            picker.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    // MARK: - Action Sheet Delegate

    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        let buttonTitle = actionSheet.buttonTitleAtIndex(buttonIndex)
        if let selection = SelectionOptions(rawValue: buttonTitle) {
            switch selection {
            case .TakePhoto:
                element.imagePickerController.sourceType = .Camera
            case .ChooseFromLibrary:
                element.imagePickerController.sourceType = .PhotoLibrary
            case .RemovePhoto:
                element.updateCell()
                element.delegate?.formElement(element, valueDidChange: nil)
            case .Cancel:
                return
            }

            element.delegate?.formElement(element, didRequestPresentationOfViewController: element.imagePickerController, animated: true, completion: nil)
        }
    }

}


public class ImagePickerFormElement: FormElement {

    public let label: String

    public var placeholderImage: UIImage?

    var imagePickerDelegate: ImagePickerDelegate?

    public lazy var imagePickerController: UIImagePickerController = {
        [unowned self] in
        let picker = UIImagePickerController()
        picker.modalPresentationStyle = .CurrentContext
        picker.delegate = self.imagePickerDelegate
        picker.allowsEditing = true
        return picker
    }()

    public init(label: String) {
        self.label = label
        super.init()
        self.imagePickerDelegate = ImagePickerDelegate(element: self)
    }

    // MARK: - Form Element

    public override func populateCell() {
        if let cell = cell as? ImagePickerFormCell {
            cell.label?.text = label
            cell.button?.enabled = enabled
            cell.placeholderImage = placeholderImage
        }
        super.populateCell()
    }

    public override func canAddElement() -> Bool {
        return UIImagePickerController.isSourceTypeAvailable(.Camera) ||
                UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary)
    }

    public override func isEditable() -> Bool {
        return true
    }

    public override func beginEditing() {
        showActionSheet()
    }

    // MARK: - Cell Delegate

    public override func formCell(cell: FormCell, userDidPerformInteraction interaction: FormCellUserInteraction, view: UIView) {
        showActionSheet()
    }

    // MARK: - Private

    private func showActionSheet() {
        let actionSheet = UIActionSheet(title: nil, delegate: imagePickerDelegate!, cancelButtonTitle: nil, destructiveButtonTitle: nil)
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            actionSheet.addButtonWithTitle(SelectionOptions.TakePhoto.rawValue)
        }
        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            actionSheet.addButtonWithTitle(SelectionOptions.ChooseFromLibrary.rawValue)
        }
        if let cell = cell as? ImagePickerFormCell, let image = cell.imageView?.image {
            actionSheet.destructiveButtonIndex = actionSheet.addButtonWithTitle(SelectionOptions.RemovePhoto.rawValue)
        }
        actionSheet.cancelButtonIndex = actionSheet.addButtonWithTitle(SelectionOptions.Cancel.rawValue)
        delegate?.formElement(self, didRequestPresentationOfActionSheet: actionSheet)
    }

}
