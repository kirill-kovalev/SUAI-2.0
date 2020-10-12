//
//  GradientLabel.swift
//  rasp.guap
//
//  Created by Кирилл on 09.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

@IBDesignable
class GradientLabel: UILabel {
    // MARK: - Colors to create gradient from
    @IBInspectable open var gradientFrom: UIColor?
    @IBInspectable open var gradientTo: UIColor?
	@IBInspectable open var angle: CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        // begin new image context to let the superclass draw the text in (so we can use it as a mask)
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        do {
            // get your image context
            guard let ctx = UIGraphicsGetCurrentContext() else { super.draw(rect); return }
            // flip context
            ctx.scaleBy(x: 1, y: -1)
            ctx.translateBy(x: 0, y: -bounds.size.height)
            // get the superclass to draw text
            super.draw(rect)
        }
        // get image and end context
        guard let img = UIGraphicsGetImageFromCurrentImageContext(), img.cgImage != nil else { return }
        UIGraphicsEndImageContext()
        // get drawRect context
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        // clip context to image
        ctx.clip(to: bounds, mask: img.cgImage!)
        // define your colors and locations
		//guard let gradientFrom = gradientFrom, let gradientTo = gradientTo else {return}
		let colors: [CGColor] = [(gradientFrom ?? self.textColor).cgColor, (gradientTo  ?? self.textColor).cgColor]
        let locs: [CGFloat] = [0.0, 1.0]
        // create your gradient
        guard let grad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: locs) else { return }
        // draw gradient
		let (start, end) = calculatePoints(for: self.angle)
		let size = self.bounds.size
		let startPoint = CGPoint(x: size.width*start.x, y: size.height*start.y)
		let endPoint = CGPoint(x: size.width*end.x, y: size.height*end.y)
		ctx.drawLinearGradient(grad, start: startPoint, end: endPoint, options: [CGGradientDrawingOptions.drawsBeforeStartLocation, .drawsAfterEndLocation])
    }
	
	private func calculatePoints(for angle: CGFloat) -> (CGPoint, CGPoint) {
        var ang = (-angle).truncatingRemainder(dividingBy: 360)

        if ang < 0 { ang = 360 + ang }

        let n: CGFloat = 0.5

        switch ang {
        case 0...45, 315...360:
            let a = CGPoint(x: 0, y: n * tanx(ang) + n)
            let b = CGPoint(x: 1, y: n * tanx(-ang) + n)
            return (a, b)

        case 45...135:
			let a = CGPoint(x: n * tanx(ang - 90) + n, y: 1)
            let b = CGPoint(x: n * tanx(-ang - 90) + n, y: 0)
            return (a, b)

        case 135...225:
            let a = CGPoint(x: 1, y: n * tanx(-ang) + n)
            let b = CGPoint(x: 0, y: n * tanx(ang) + n)
            return (a, b)

        case 225...315:
            let a = CGPoint(x: n * tanx(-ang - 90) + n, y: 0)
            let b = CGPoint(x: n * tanx(ang - 90) + n, y: 1)
            return (a, b)

        default:
            let a = CGPoint(x: 0, y: n)
            let b = CGPoint(x: 1, y: n)
            return (a, b)

        }
    }

    /// Private function to aid with the math when calculating the gradient angle
    private func tanx(_ 𝜽: CGFloat) -> CGFloat {
        return tan(𝜽 * CGFloat.pi / 180)
    }
}
