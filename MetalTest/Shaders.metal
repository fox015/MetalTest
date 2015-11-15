//
//  Shaders.metal
//  MetalTest
//
//  Created by Rob Gilbert on 10/11/2015.
//  Copyright © 2015 Ninety Four. All rights reserved.
//

#include <metal_stdlib>

using namespace metal;

struct VertexIn
{
	packed_float3 position;
	packed_float4 color;
};

struct VertexOut
{
	float4 position[[position]];
	float4 color;
};

struct Uniforms
{
	float4x4 modelMatrix;
	float4x4 projectionMatrix;
};

vertex VertexOut basic_vertex(const device VertexIn *vertex_array[[buffer(0)]],
							  const device Uniforms &uniforms[[buffer(1)]],
							  unsigned int vid[[vertex_id]])
{
	float4x4 modelViewMatrix = uniforms.modelMatrix;
	float4x4 projectionMatrix = uniforms.projectionMatrix;
	
	VertexIn vIn = vertex_array[vid];
	
	VertexOut vOut;
	vOut.position = projectionMatrix * modelViewMatrix * float4(vIn.position, 1);
	vOut.color = vIn.color;
	
	return vOut;
}

fragment half4 basic_fragment(VertexOut interpolated[[stage_in]])
{
	return half4(interpolated.color[0],
				 interpolated.color[1],
				 interpolated.color[2],
				 interpolated.color[3]);
}