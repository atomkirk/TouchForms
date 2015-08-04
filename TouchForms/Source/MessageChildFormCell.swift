//
//  MessageChildFormCell.swift
//  TouchForms
//
//  Created by Adam Kirk on 7/25/15.
//  Copyright (c) 2015 Adam Kirk. All rights reserved.
//

import Foundation

private let red = UIColor(red: 215.0/255.0, green: 0, blue: 0, alpha: 1)
private let green = UIColor(red: 0, green: 215.0/255.0, blue: 0, alpha: 1)

class MessageChildFormCell: FormCell {

    var type: ChildFormElementType = .Loading

    @IBOutlet weak var messageLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        switch type {
        case .Error:
            messageLabel.textColor = red
        case .ValidationError:
            messageLabel.textColor = red
        case .Success:
            messageLabel.textColor = green
        default:
            messageLabel.textColor = UIColor.blackColor()
        }
    }

    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        if type == .Error {
            let point1 = CGPointMake(20, (self.frame.size.height / 2.0) - 5)
            let point2 = CGPointMake(30, (self.frame.size.height / 2.0) + 5)
            let point3 = CGPointMake(20, (self.frame.size.height / 2.0) + 5)
            let point4 = CGPointMake(30, (self.frame.size.height / 2.0) - 5)
            let path = UIBezierPath()
            path.moveToPoint(point1)
            path.addLineToPoint(point2)
            path.moveToPoint(point3)
            path.addLineToPoint(point4)
            red.setStroke()
            path.stroke();
        }
        else if type == .ValidationError {
            let point1 = CGPointMake(25, self.frame.size.height / 2.0)
            let point2 = CGPointMake(20, point1.y)
            let point3 = CGPointMake(point2.x, 0)
            let path = UIBezierPath()
            path.moveToPoint(point1)
            path.addLineToPoint(point2)
            path.addLineToPoint(point3)
            red.setStroke()
            path.stroke()
        }
        else if type == .Success {
            let point1 = CGPointMake(22, (self.frame.size.height / 2.0))
            let point2 = CGPointMake(point1.x + 4, point1.y + 5)
            let point3 = CGPointMake(point2.x + 4, point2.y - 12)
            let path = UIBezierPath()
            path.moveToPoint(point1)
            path.addLineToPoint(point2)
            path.addLineToPoint(point3)
            green.setStroke()
            path.stroke()
        }
    }

}