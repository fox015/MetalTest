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
	var vertexCount: Int
	var vertexBuffer: MTLBuffer
	var uniformBuffer: MTLBuffer?
	var device: MTLDevice
	
	var positionX: Float = 0.0
	var positionY: Float = 0.0
	var positionZ: Float = 0.0
 
	var rotationX: Float = 0.0
	var rotationY: Float = 0.0
	var rotationZ: Float = 0.0
	var scale: Float = 1.0
	
	var time: CFTimeInterval = 0.0
	
	init(name: String, vertices: Array<Vertex>, device: MTLDevice) {
		var vertexData = Array<Float>()
		for vertex in vertices {
			vertexData += vertex.floatBuffer()
		}
		
		let dataSize = vertexData.count * sizeofValue(vertexData[0])
		vertexBuffer = device.newBufferWithBytes(vertexData, length: dataSize, options: [])
		
		self.name = name
		self.device = device
		vertexCount = vertices.count
	}
	
	func render(commandQueue: MTLCommandQueue,
				pipelineState: MTLRenderPipelineState,
				drawable: CAMetalDrawable,
				parentModelViewMatrix: Matrix4,
				projectionMatrix: Matrix4, clearColor: MTLClearColor?) {
		let renderPassDescriptor = MTLRenderPassDescriptor()
		renderPassDescriptor.colorAttachments[0].texture = drawable.texture
		renderPassDescriptor.colorAttachments[0].loadAction = .Clear
		renderPassDescriptor.colorAttachments[0].clearColor = clearColor!
		renderPassDescriptor.colorAttachments[0].storeAction = .Store
		
		let commandBuffer = commandQueue.commandBuffer()
		
		let renderEncoder = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDescriptor)
					renderEncoder.setCullMode(MTLCullMode.Front)
		renderEncoder.setRenderPipelineState(pipelineState)
		renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, atIndex: 0)
		
		let nodeModelMatrix = modelMatrix()
		nodeModelMatrix.multiplyLeft(parentModelViewMatrix)
					
		uniformBuffer = device.newBufferWithLength(sizeof(Float) * Matrix4.numberOfElements() * 2, options: [])
		let bufferPointer = uniformBuffer?.contents()
		memcpy(bufferPointer!, nodeModelMatrix.raw(), sizeof(Float) *  Matrix4.numberOfElements())
		memcpy(bufferPointer! + sizeof(Float) * Matrix4.numberOfElements(), projectionMatrix.raw(), sizeof(Float) * Matrix4.numberOfElements())
		renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, atIndex: 1)
		
		renderEncoder.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: vertexCount, instanceCount: vertexCount / 3)
		renderEncoder.endEncoding()
		
		commandBuffer.presentDrawable(drawable)
		commandBuffer.commit()
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