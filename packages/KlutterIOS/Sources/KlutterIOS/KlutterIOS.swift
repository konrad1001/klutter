import SwiftUI
import MetalKit

#if !os(macOS)
@available(iOS 17.0, *)
public struct KlutterMetalView: View {
    @State var engine = KlutterEngine()
    
    public init() {
        engine.run()
    }
    
    @ViewBuilder
    public var body: some View {
        
        if let data = engine.appData {
            UIMetalView( data: data)
                .ignoresSafeArea()
        }
            
    }
}

@available(iOS 17.0, *)
struct UIMetalView: UIViewRepresentable {
    let device = MTLCreateSystemDefaultDevice()
    let data: AppData
    

    func makeUIView(context: Context) -> MTKView {
        let view = MTKView()
        view.device = context.coordinator.renderer.device
        view.delegate = context.coordinator
        view.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return view
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
        //
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(data: data)
    }

    typealias UIViewType = MTKView
}

#endif
