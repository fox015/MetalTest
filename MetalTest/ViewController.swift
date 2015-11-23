//
//  ViewController.swift
//  MetalTest
//
//  Created by Rob Gilbert on 9/11/2015.
//  Copyright © 2015 Ninety Four. All rights reserved.
//

import UIKit
import Metal
import QuartzCore

class ViewController: UIViewController {
	
	// MARK: Properties
	
	var metalLayer: CAMetalLayer! = nil
	var drawable: CAMetalDrawable! = nil
	var timer: CADisplayLink! = nil
	
	var device: MTLDevice! = nil
	var pipelineState: MTLRenderPipelineState! = nil
	var commandQueue: MTLCommandQueue! = nil
	
	var objectToDraw: Node!
	let clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
	var projectionMatrix: Matrix4!
	
	var lastFrameTimestamp: CFTimeInterval = 0.0
	
	// From Node.
	var vertexBuffer: MTLBuffer?
	var uniformBuffer: MTLBuffer?

	override func viewDidLoad() {
		super.viewDidLoad()

		device = MTLCreateSystemDefaultDevice()
		
		metalLayer = CAMetalLayer()
		metalLayer.device = device
		metalLayer.pixelFormat = .BGRA8Unorm
		metalLayer.framebufferOnly = true
		metalLayer.frame = view.layer.frame
		view.layer.addSublayer(metalLayer)
		
		// Set up projection matrix.
		projectionMatrix = Matrix4.makePerspectiveViewAngle(
			Matrix4.degreesToRad(85.0),
			aspectRatio: Float(view.bounds.size.width / view.bounds.size.height),
			nearZ: 0.01, farZ: 100.0)
		
		// Init object
		var vertexData = Array<Float>()
		for vertex in objectToDraw.vertices {
			vertexData += vertex.floatBuffer()
		}
		
		let dataSize = vertexData.count * sizeofValue(vertexData[0])
		vertexBuffer = device.newBufferWithBytes(vertexData, length: dataSize, options: [])
		
		// Init library and program.
		let defaultLibrary = device.newDefaultLibrary()
		let vertexProgram = defaultLibrary!.newFunctionWithName("basic_vertex")
		let fragmentProgram = defaultLibrary!.newFunctionWithName("basic_fragment")
		
		// Create programmable pipeline.
		let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
		pipelineStateDescriptor.vertexFunction = vertexProgram
		pipelineStateDescriptor.fragmentFunction = fragmentProgram
		pipelineStateDescriptor.colorAttachments[0].pixelFormat = .BGRA8Unorm
		
		pipelineState = try? device.newRenderPipelineStateWithDescriptor(
			pipelineStateDescriptor)
		if pipelineState == nil {
			print("Failed to create pipeline state, error")
		}
		
		commandQueue = device.newCommandQueue()
		drawable = metalLayer.nextDrawable()
		
		// Set up render loop.
		timer = CADisplayLink(target: self, selector: Selector("newFrame:"))
		timer.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func render() {
		let drawable = metalLayer.nextDrawable()
		
		let worldModelMatrix = Matrix4()
		worldModelMatrix.translate(0.0, y: 0.0, z: -7.0)
		worldModelMatrix.rotateAroundX(Matrix4.degreesToRad(25), y: 0.0, z: 0.0)
		
		render(commandQueue, pipelineState: pipelineState,
			drawable: drawable!,parentModelViewMatrix: worldModelMatrix,
			projectionMatrix: projectionMatrix, clearColor: clearColor)
	}
	
	func newFrame(displayLink: CADisplayLink) {
		if lastFrameTimestamp == 0.0 {
			lastFrameTimestamp = displayLink.timestamp
		}
		
		let elapsed: CFTimeInterval = displayLink.timestamp - lastFrameTimestamp
		lastFrameTimestamp = displayLink.timestamp
		
		gameloop(elapsed)
	}

	/// Game loop.
	///
	/// - parameter timeSinceLastUpdate: the elapsed time since game state was
	///   last updated.
	func gameloop(timeSinceLastUpdate: CFTimeInterval) {
		objectToDraw.updateWithDelta(timeSinceLastUpdate)
		
		autoreleasepool {
			self.render()
		}
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
			
			let nodeModelMatrix = objectToDraw.modelMatrix()
			nodeModelMatrix.multiplyLeft(parentModelViewMatrix)
			
			uniformBuffer = device.newBufferWithLength(sizeof(Float) * Matrix4.numberOfElements() * 2, options: [])
			let bufferPointer = uniformBuffer?.contents()
			memcpy(bufferPointer!, nodeModelMatrix.raw(), sizeof(Float) *  Matrix4.numberOfElements())
			memcpy(bufferPointer! + sizeof(Float) * Matrix4.numberOfElements(), projectionMatrix.raw(), sizeof(Float) * Matrix4.numberOfElements())
			renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, atIndex: 1)
			
			renderEncoder.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: objectToDraw.vertices.count, instanceCount: objectToDraw.vertices.count / 3)
			renderEncoder.endEncoding()
			
			commandBuffer.presentDrawable(drawable)
			commandBuffer.commit()
	}

}

