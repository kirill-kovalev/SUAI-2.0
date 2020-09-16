//
//  VectorClass.swift
//  rasp.guap
//
//  Created by Кирилл on 16.09.2020.
//  Copyright © 2020 Kovalev K.A. All rights reserved.
//

import UIKit

struct Vector{
	var x:CGFloat
	var y:CGFloat
	var z:CGFloat
	var length:CGFloat{
		return (x*x+y*y+x*z).squareRoot()
	}
	var angles:AngleSet{
		let toX = acos(self.x/self.length)
		let toY = acos(self.y/self.length)
		let toZ = acos(self.z/self.length)
		return AngleSet(toX: toX.isNaN ? 0 : toX,
						toY: toY.isNaN ? 0 : toY,
						toZ: toZ.isNaN ? 0 : toZ)
	}
	static func - (left:Vector,right:Vector)->Vector{
		return Vector(x: left.x-right.x, y: left.y-right.y, z: left.z-right.z)
	}
	static func + (left:Vector,right:Vector)->Vector{
		return Vector(x: left.x+right.x, y: left.y+right.y, z: left.z+right.z)
	}
}
struct AngleSet{
	var toX:CGFloat
	var toY:CGFloat
	var toZ:CGFloat
	
	var convertedToDegrees:AngleSet{
		return AngleSet(toX: self.toX.rtd,
						toY: self.toY.rtd,
						toZ: self.toZ.rtd)
	}
	var convertedToRadians:AngleSet{
		return AngleSet(toX: self.toX.dtr,
						toY: self.toY.dtr,
						toZ: self.toZ.dtr)
	}
	
	static func - (left:AngleSet,right:AngleSet)->AngleSet{
		return AngleSet(toX: left.toX-right.toX, toY: left.toY-right.toY, toZ: left.toZ-right.toZ)
	}
	static func + (left:AngleSet,right:AngleSet)->AngleSet{
		return AngleSet(toX: left.toX+right.toX, toY: left.toY+right.toY, toZ: left.toZ+right.toZ)
	}
	
}
fileprivate extension FloatingPoint {
    var dtr: Self { self * .pi / 180 }
    var rtd: Self { self * 180 / .pi }
}

