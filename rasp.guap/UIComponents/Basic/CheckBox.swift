//
//  CheckBox.swift
//  rasp.guap
//
//  Created by Кирилл on 07.08.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

@IBDesignable
open class CheckBox: UIControl {
    @IBInspectable
    var borderWidth: CGFloat = 1.75
    
    var checkmarkSize: CGFloat = 0.5
    
    @IBInspectable
    var uncheckedBorderColor: UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    
    @IBInspectable
    var checkedBorderColor: UIColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
    
    @IBInspectable
    var checkmarkColor: UIColor = #colorLiteral(red: 0, green: 0.3285208941, blue: 0.5748849511, alpha: 1)
    
    var checkboxBackgroundColor: UIColor! = .white
    var checkboxCheckedBackgroundColor: UIColor! = .white
    
    //Used to increase the touchable are for the component
    var increasedTouchRadius: CGFloat = 10
    
    //By default it is true
    var useHapticFeedback: Bool = true
    
    @IBInspectable
    var isChecked: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    //UIImpactFeedbackGenerator object to wake up the device engine to provide feed backs
    private var feedbackGenerator: UIImpactFeedbackGenerator?
    
    // MARK: Intialisers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        self.backgroundColor = .clear
        
    }
    
    //Define the above UIImpactFeedbackGenerator object, and prepare the engine to be ready to provide feedback.
    //To store the energy and as per the best practices, we create and make it ready on touches begin.
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.feedbackGenerator = UIImpactFeedbackGenerator.init(style: .light)
        self.feedbackGenerator?.prepare()
    }
    
    //On touches ended,
    //change the selected state of the component, and changing *isChecked* property, draw methos will be called
    //So components appearance will be changed accordingly
    //Hence the state change occures here, we also sent notification for value changed event for this component.
    //After usage of feedback generator object, we make it nill.
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        super.touchesEnded(touches, with: event)
        
        self.isChecked = !isChecked
        self.sendActions(for: .valueChanged)
        if useHapticFeedback {
            self.feedbackGenerator?.impactOccurred()
            self.feedbackGenerator = nil
        }
    }
    
    open override func draw(_ rect: CGRect) {
        //Draw the outlined component
        let newRect = rect.insetBy(dx: borderWidth / 2, dy: borderWidth / 2)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setStrokeColor(self.isChecked ? checkedBorderColor.cgColor : uncheckedBorderColor.cgColor)
        context.setFillColor(self.isChecked ? checkboxCheckedBackgroundColor.cgColor : checkboxBackgroundColor.cgColor)
        context.setLineWidth(borderWidth)
        
        let shapePath: UIBezierPath! = UIBezierPath(roundedRect: newRect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 2, height: 2))
        
        context.addPath(shapePath.cgPath)
        context.strokePath()
        context.fillPath()
        
        //When it is selected, depends on the style
        //By using helper methods, draw the inner part of the component UI.
        if isChecked {
            self.drawCheckMark(frame: newRect)
        }
        
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.setNeedsDisplay()
    }
    
    open override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setNeedsDisplay()
    }
    
    //we override the following method,
    //To increase the hit frame for this component
    //Usaully check boxes are small in our app's UI, so we need more touchable area for its interaction
    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let relativeFrame = self.bounds
        let hitTestEdgeInsets = UIEdgeInsets(top: -increasedTouchRadius, left: -increasedTouchRadius, bottom: -increasedTouchRadius, right: -increasedTouchRadius)
        let hitFrame = relativeFrame.inset(by: hitTestEdgeInsets)
        return hitFrame.contains(point)
    }
    
    //Draws tick inside the component
    func drawCheckMark(frame: CGRect) {
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: frame.minX + 0.26000 * frame.width, y: frame.minY + 0.50000 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.42000 * frame.width, y: frame.minY + 0.62000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.38000 * frame.width, y: frame.minY + 0.60000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.42000 * frame.width, y: frame.minY + 0.62000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.70000 * frame.width, y: frame.minY + 0.24000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.78000 * frame.width, y: frame.minY + 0.30000 * frame.height))
        bezierPath.addLine(to: CGPoint(x: frame.minX + 0.44000 * frame.width, y: frame.minY + 0.76000 * frame.height))
        bezierPath.addCurve(to: CGPoint(x: frame.minX + 0.20000 * frame.width, y: frame.minY + 0.58000 * frame.height), controlPoint1: CGPoint(x: frame.minX + 0.44000 * frame.width, y: frame.minY + 0.76000 * frame.height), controlPoint2: CGPoint(x: frame.minX + 0.26000 * frame.width, y: frame.minY + 0.62000 * frame.height))
        checkmarkColor.setFill()
        bezierPath.fill()
    }
    
}
