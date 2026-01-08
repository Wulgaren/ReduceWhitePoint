import AppKit
import CoreGraphics

class WhitePointManager: ObservableObject {
    static let shared = WhitePointManager()
    
    @Published var isEnabled: Bool = false
    @Published var intensity: Double = 25.0
    
    private var originalWhitePoint: CGPoint?
    private var displayID: CGDirectDisplayID = CGMainDisplayID()
    
    private init() {
        // Load saved settings
        isEnabled = UserDefaults.standard.bool(forKey: "whitePointEnabled")
        intensity = UserDefaults.standard.double(forKey: "whitePointIntensity")
        
        if intensity == 0 {
            intensity = 25.0 // Default to 25%
        }
        
        if isEnabled {
            applyWhitePointReduction()
        }
    }
    
    func setEnabled(_ enabled: Bool) {
        isEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: "whitePointEnabled")
        
        if enabled {
            applyWhitePointReduction()
        } else {
            restoreWhitePoint()
        }
    }
    
    func setIntensity(_ newIntensity: Double) {
        intensity = newIntensity
        UserDefaults.standard.set(newIntensity, forKey: "whitePointIntensity")
        
        if isEnabled {
            applyWhitePointReduction()
        }
    }
    
    private func applyWhitePointReduction() {
        // Get the main display
        displayID = CGMainDisplayID()
        
        // Calculate white point adjustment
        // Intensity: 0% = no change, 100% = maximum reduction
        // iOS Reduce White Point uses a curve that affects bright colors more
        let reductionFactor = intensity / 100.0
        
        // Apply white point reduction using gamma adjustment
        // Since macOS doesn't expose direct white point control like iOS,
        // we use a gamma curve that reduces bright values more than dark values
        var redTable: [CGGammaValue] = Array(repeating: 0, count: 256)
        var greenTable: [CGGammaValue] = Array(repeating: 0, count: 256)
        var blueTable: [CGGammaValue] = Array(repeating: 0, count: 256)
        
        // Create a curve similar to iOS Reduce White Point
        // This curve reduces bright colors more than dark colors while preserving color relationships
        for i in 0..<256 {
            let normalized = Double(i) / 255.0
            
            // Use a power curve that reduces bright values while preserving color balance
            // This formula affects all RGB channels identically, preserving hue and saturation
            // Higher gamma = darker output (reduces white point)
            // The curve is more aggressive on brighter values but maintains color relationships
            let gamma = 1.0 + (reductionFactor * 0.8) // Range: 1.0 (no change) to 1.8 (max reduction)
            let adjusted = pow(normalized, gamma)
            
            // Ensure we don't go below 0 or above 1
            let clamped = max(0.0, min(1.0, adjusted))
            
            redTable[i] = CGGammaValue(clamped)
            greenTable[i] = CGGammaValue(clamped)
            blueTable[i] = CGGammaValue(clamped)
        }
        
        // Apply gamma tables to display
        // Note: CGSetDisplayTransferByTable may require accessibility permissions
        _ = CGSetDisplayTransferByTable(displayID, 256, &redTable, &greenTable, &blueTable)
    }
    
    private func restoreWhitePoint() {
        // Reset to linear gamma (1.0)
        var redTable: [CGGammaValue] = Array(repeating: 0, count: 256)
        var greenTable: [CGGammaValue] = Array(repeating: 0, count: 256)
        var blueTable: [CGGammaValue] = Array(repeating: 0, count: 256)
        
        for i in 0..<256 {
            let normalized = Double(i) / 255.0
            redTable[i] = CGGammaValue(normalized)
            greenTable[i] = CGGammaValue(normalized)
            blueTable[i] = CGGammaValue(normalized)
        }
        
        CGSetDisplayTransferByTable(displayID, 256, &redTable, &greenTable, &blueTable)
    }
    
    deinit {
        if isEnabled {
            restoreWhitePoint()
        }
    }
}
