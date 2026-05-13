import XCTest
import SwiftUI
@testable import GlassKit

final class ThemeTests: XCTestCase {
    
    func testDefaultThemeResolution() {
        let theme = DefaultTheme()
        
        // Test semantic color mapping
        XCTAssertEqual(theme.colors.accentPrimary, Color.blue)
        
        // Test spacing tokens
        XCTAssertEqual(theme.spacing.m, 12)
    }
    
    func testGlassMaterialOpacity() {
        XCTAssertEqual(GlassMaterialLevel.ultraThin.opacity, 0.1)
        XCTAssertEqual(GlassMaterialLevel.ultraThick.opacity, 0.7)
    }
}
