//
//  Cube.swift
//  MetalTest
//
//  Created by Rob Gilbert on 12/11/2015.
//  Copyright © 2015 Ninety Four. All rights reserved.
//

import Metal

class Cube: Node {
	
	init() {
		let A = Vertex(x: -1.0, y:   1.0, z:   1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
		let B = Vertex(x: -1.0, y:  -1.0, z:   1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
		let C = Vertex(x:  1.0, y:  -1.0, z:   1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
		let D = Vertex(x:  1.0, y:   1.0, z:   1.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0)
		
		let Q = Vertex(x: -1.0, y:   1.0, z:  -1.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0)
		let R = Vertex(x:  1.0, y:   1.0, z:  -1.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0)
		let S = Vertex(x: -1.0, y:  -1.0, z:  -1.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0)
		let T = Vertex(x:  1.0, y:  -1.0, z:  -1.0, r:  0.1, g:  0.6, b:  0.4, a:  1.0)
		
		let verticesArray: Array<Vertex> = [
			A,B,C ,A,C,D,   // Front
			R,T,S ,Q,R,S,   // Back
			
			Q,S,B ,Q,B,A,   // Left
			D,C,T ,D,T,R,   // Right
			
			Q,A,D ,Q,D,R,   // Top
			B,S,T ,B,T,C    // Bottom
		]
		
		super.init(name: "Cube", vertices: verticesArray)
	}
	
	override func updateWithDelta(delta: CFTimeInterval) {
		super.updateWithDelta(delta)
		
		let secsPerMove: Float = 6.0
		rotationY = sinf(Float(time) * 2.0 * Float(M_PI) / secsPerMove)
		rotationX = sinf(Float(time) * 2.0 * Float(M_PI) / secsPerMove)
	}
	
}
