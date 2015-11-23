//
//  Shape.swift
//  MetalTest
//
//  Created by Rob Gilbert on 16/11/2015.
//  Copyright © 2015 Ninety Four. All rights reserved.
//

class Shape {
	
	// MARK: Properties.
	let name: String
	let type: ShapeType
	
	init(name: String, type: ShapeType) {
		self.name = name
		self.type = type
	}
	
}

enum ShapeType {
	case Triangle
	case Cube
}