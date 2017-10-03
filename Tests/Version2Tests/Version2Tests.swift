import XCTest
@testable import Version2

class Version2Tests: XCTestCase {
    let markdown = Markdown()
    
    func testText() {
        let md = """
        Hello World!
        This is just text for know
        """
        
        let html = """
        Hello World!
        This is just text for know
        """
        
        XCTAssertEqual(try markdown.render(md), html)
    }
    
    static var allTests : [(String, (Version2Tests) -> () throws -> Void)] {
        return [
            ("testText", testText)
        ]
    }
}
