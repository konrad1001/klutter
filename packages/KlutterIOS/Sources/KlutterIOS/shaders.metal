//
//  shaders.metal
//  KlutterIOS
//
//  Created by Konrad Painta on 29/12/2025.
//

#include <metal_stdlib>
using namespace metal;


struct Vertex {
    float4 position [[position]];
    float4 color;
};

vertex Vertex vertexShader(constant float *vertices [[buffer(0)]],
                           uint vid [[vertex_id]]) {
    Vertex out;
    uint index = vid * 7;
    out.position = float4(vertices[index], vertices[index + 1], vertices[index + 2], 1.0);
    out.color = float4(vertices[index + 3], vertices[index + 4], vertices[index + 5], vertices[index + 6]);
    return out;
}

fragment float4 fragmentShader(Vertex in [[stage_in]]) {
    return in.color;
}
