import XCTest
@testable import ScreenDataUI

final class ScreenDataUITests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SDColor(color: .init(red: 0, green: 255, blue: 0, alpha: 255)).color.green, 255)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
