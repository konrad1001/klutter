//
//  KlutterEngine.swift
//  KlutterIOS
//
//  Created by Konrad Painta on 29/12/2025.
//

import Foundation
import Observation

@available(iOS 17.0, *)
@Observable class KlutterEngine {
    var appData: AppData? = nil
    
    func run() {
        loadDartApp()
    }
    
    private func loadDartApp() {
        self.appData = AppData(data: [
            RenderObject(x: 50, y: 350, height: 200, width: 200, r: 0.9, g: 0.5, b: 0.5, a: 1.0),
            RenderObject(x: 100, y: 900, height: 300, width: 400, r: 0.9, g: 0.9, b: 0.5, a: 1.0),
            RenderObject(x: 400, y: 2000, height: 300, width: 300, r: 0.4, g: 0.5, b: 0.9, a: 1.0),
        ])
    }
}
