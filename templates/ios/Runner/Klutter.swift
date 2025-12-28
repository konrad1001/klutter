//
//  Klutter.swift
//  Runner
//
//  Created by Konrad Painta on 28/12/2025.
//

import Foundation
import SwiftUI
internal import Combine

struct DartApp: Codable {
    let backgroundColour: String
    
    func getBackgroundColour() -> Color {
        // Parse hex color
        let hex = backgroundColour.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var rgb: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&rgb)
        
        let r = Double((rgb & 0xFF0000) >> 16) / 255.0
        let g = Double((rgb & 0x00FF00) >> 8) / 255.0
        let b = Double(rgb & 0x0000FF) / 255.0
        
        return Color(red: r, green: g, blue: b)
    }
}

class KlutterEngine: ObservableObject {
    @Published var app: DartApp?
    @Published var isLoading = true
    @Published var error: String?
    
    func run() {
        // This mirrors FlutterEngine.run(withEntrypoint: "main")
        loadDartApp()
    }
    
    private func loadDartApp() {
        // Load JSON from bundle
        guard let url = Bundle.main.url(forResource: "app", withExtension: "json") else {
            error = "Could not find app.json in bundle"
            isLoading = false
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            app = try decoder.decode(DartApp.self, from: data)
            isLoading = false
            print("✓ Mini Flutter Engine: Successfully loaded Dart app")
        } catch {
            self.error = "Failed to load app: \(error.localizedDescription)"
            isLoading = false
        }
    }
}


struct KlutterView: View {
    @StateObject private var engine = KlutterEngine()
    
    var body: some View {
        Group {
            if engine.isLoading {
                ProgressView("Loading Dart Runtime...")
            } else if let error = engine.error {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                }
            } else if let app = engine.app {
                app.getBackgroundColour()
                    .ignoresSafeArea()
                    .overlay(
                        VStack {
                            Text("Hello {{PROJECT_NAME}}!")
                            Text("Loaded App.json")
                        }
                    )
            }
        }
        .onAppear {
            engine.run()
        }
    }
}
