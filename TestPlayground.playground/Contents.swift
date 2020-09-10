import UIKit
import SUAI_API

print(01)
PocketAPI.shared.setToken("ba222b76bafd64a3650e09f7514a2b1f7c672629d3a42dea2aa614b3a27de256dad08779f00159a548a44")

func calculatePoints(for angle: CGFloat) -> (CGPoint,CGPoint){


	var ang = (-angle).truncatingRemainder(dividingBy: 360)

	if ang < 0 { ang = 360 + ang }

	let n: CGFloat = 0.5

	switch ang {

	case 0...45, 315...360:
		let a = CGPoint(x: 0, y: n * tanx(ang) + n)
		let b = CGPoint(x: 1, y: n * tanx(-ang) + n)
		return (a,b)

	case 45...135:
		let a = CGPoint(x: n * tanx(ang - 90) + n, y: 1)
		let b = CGPoint(x: n * tanx(-ang - 90) + n, y: 0)
		return (a,b)

	case 135...225:
		let a = CGPoint(x: 1, y: n * tanx(-ang) + n)
		let b = CGPoint(x: 0, y: n * tanx(ang) + n)
		return (a,b)

	case 225...315:
		let a = CGPoint(x: n * tanx(-ang - 90) + n, y: 0)
		let b = CGPoint(x: n * tanx(ang - 90) + n, y: 1)
		return (a,b)

	default:
		let a = CGPoint(x: 0, y: n)
		let b = CGPoint(x: 1, y: n)
		return (a,b)

	}
}

/// Private function to aid with the math when calculating the gradient angle
private func tanx(_ 𝜽: CGFloat) -> CGFloat {
	return tan(𝜽 * CGFloat.pi / 180)
}

print(calculatePoints(for: 0))
