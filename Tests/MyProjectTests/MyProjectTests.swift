import XCTest
@testable import MyProject

final class MyProjectTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(MyProject().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
