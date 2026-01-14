//
//  Renderer.swift
//  KlutterIOS
//
//  Created by Konrad Painta on 29/12/2025.
//
import MetalKit

@available(iOS 17.0, *)
extension UIMetalView {
    class Coordinator: NSObject, MTKViewDelegate {
        let renderer: Renderer
        
        let data: AppData
        
        init(data: AppData) {
            guard let renderer = Renderer(withData: data.data) else {
                fatalError("Failed to initialise Renderer")
            }
            
            self.renderer = renderer
            self.data = data
           
            super.init()
        }
        
        // Called on resize
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
            renderer.viewSizeDidUpdate(newSize: size)
        }
        
        // Called every frame
        func draw(in view: MTKView) {
            guard let drawable = view.currentDrawable,
                  let renderPassDescriptor = view.currentRenderPassDescriptor else {
                return
            }
            
            renderer.draw(renderPassDescriptor: renderPassDescriptor, drawable: drawable)
        }
    }
}
