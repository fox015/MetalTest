//
//  Vertex.swift
//  MetalTest
//
//  Created by Rob Gilbert on 12/11/2015.
//  Copyright © 2015 Ninety Four. All rights reserved.
//

struct Vertex {
	var x, y, z: Float
	var r, g, b, a: Float
	
	func floatBuffer() -> [Float] {
		return [x, y, z, r, g, b, a]
	}
	
}
