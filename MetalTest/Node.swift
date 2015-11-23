//
//  Node.swift
//  MetalTest
//
//  Created by Rob Gilbert on 12/11/2015.
//  Copyright © 2015 Ninety Four. All rights reserved.
//

import Foundation
import Metal
import QuartzCore

class Node {
	
	let name: String
	
	var positionX: Float = 0.0
	var positionY: Float = 0.0
	var positionZ: Float = 0.0
 
	var rotationX: Float = 0.0
	var rotationY: Float = 0.0
	var rotationZ: Float = 0.0
	var scale: Float = 1.0
	
	var time: CFTimeInterval = 0.0
	
	let vertices: Array<Vertex>!
	
	init(name: String, vertices: Array<Vertex>) {
		self.name = name
		self.vertices = vertices
	}
	
	func modelMatrix() -> Matrix4 {
		let matrix = Matrix4()
		
		matrix.translate(positionX, y: positionY, z: positionZ)
		matrix.rotateAroundX(rotationX, y: rotationY, z: rotationZ)
		matrix.scale(scale, y: scale, z: scale)
		
		return matrix
	}
	
	func updateWithDelta(delta: CFTimeInterval) {
		time += delta
	}
	
}