import t
import XCTest
@testable import ScreenDataUI

final class ScreenDataUITests: XCTestCase {
    func testExample() {
        XCTAssert(
            t.suite(named: "Basic Color Test") {
                try t.expect {
                    try t.assert(
                        SDColor(
                            color: .init(
                                red: 0,
                                green: 1,
                                blue: 0,
                                alpha: 1
                            )
                        )
                        .color.green,
                        isEqualTo: 1
                    )
                }
            }
        )
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
