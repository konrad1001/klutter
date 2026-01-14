//
//  Renderer.swift
//  KlutterIOS
//
//  Created by Konrad Painta on 29/12/2025.
//

import Foundation
import MetalKit

class Renderer {
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let pipelineState: MTLRenderPipelineState
    
    var vertexBuffer: MTLBuffer?
    
    var viewSize: CGSize = CGSize.zero
    
    let data: [RenderObject]
    
    init?(withData data: [RenderObject]) {
        guard let device = MTLCreateSystemDefaultDevice(),
                  let commandQueue = device.makeCommandQueue() else {
                return nil
            }
                    
        self.device = device
        self.commandQueue = commandQueue
        self.data = data
        
        guard let library = device.makeDefaultLibrary(),
              let vertexFunction = library.makeFunction(name: "vertexShader"),
              let fragmentFunction = library.makeFunction(name: "fragmentShader") else {
            return nil
        }
        
        // Create pipeline state
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        guard let pipelineState = try? device.makeRenderPipelineState(descriptor: pipelineDescriptor) else {
            return nil
        }
        self.pipelineState = pipelineState

    }
    
    func _setVertexBuffer(vertices: [Float]) -> MTLBuffer? {
        if let buffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<Float>.stride) {
            return buffer
        }
        return nil
    }
    
    func viewSizeDidUpdate(newSize: CGSize) {
        self.viewSize = newSize
        let vertices = data.flatMap { object in
            return object.toVertices(viewWidth: newSize.width, viewHeight: newSize.height)
        }
        self.vertexBuffer = _setVertexBuffer(vertices: vertices)
    }
    
    func draw(renderPassDescriptor: MTLRenderPassDescriptor, drawable: CAMetalDrawable) {
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
                return
              }
        
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        // Draw the triangle
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: self.data.count * 6)
        
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

extension RenderObject {
    // Return as 4 triangles
    func toVertices(viewWidth: CGFloat, viewHeight: CGFloat) -> [Float] {
        let left = (self.x / Float(viewWidth)) * 2.0 - 1.0
        let right = ((self.x + self.width) / Float(viewWidth)) * 2.0 - 1.0
                
        // Note: In NDC, +Y is up, but in pixels +Y is usually down
        // So we flip the Y coordinate
        let top = 1.0 - (self.y / Float(viewHeight)) * 2.0
        let bottom = 1.0 - ((self.y + self.height) / Float(viewHeight)) * 2.0
        let (r, g, b, a) = (self.r, self.g, self.b, self.a)
                
        return [
            left, top, 0, r, g, b, a,
            left, bottom, 0, r, g, b, a,
            right, top, 0, r, g, b, a,
            right, top, 0, r, g, b, a,
            left, bottom, 0, r, g, b, a,
            right, bottom, 0, r, g, b, a
            
        ]
    }
}
