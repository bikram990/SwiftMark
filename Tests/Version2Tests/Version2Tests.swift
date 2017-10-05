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
    
    func testEscape() {
        let md = """
        \\### Header Two with Hash

        \\# Hello World!
        This is just text for know
        \\- Caleb Kleveter
        """
        
        let html = """
        ### Header Two with Hash

        # Hello World!
        This is just text for know
        - Caleb Kleveter
        """
        
        XCTAssertEqual(try markdown.render(md), html)
    }
    
    func testHeaderOne() {
        let md = """
        \\# Hello World!
        # Header 1

        Header Goes Here
        ===
        
        # Hashes ### HASHES ## everywhere ##

        # Header Again #
        """
        
        let html = """
        # Hello World!
        <h1>Header 1</h1>

        <h1>Header Goes Here</h1>

        <h1>Hashes ### HASHES ## everywhere</h1>

        <h1>Header Again</h1>
        """
        
        XCTAssertEqual(try markdown.render(md), html)
    }
    
    func testHeaderTwo() {
        let md = """
        \\#\\# Hello World!
        ## Header 2

        ## Broken # header

        Header Goes Here
        ---

        ## \\# Header Hash with Two
        """
        
        let html = """
        ## Hello World!
        <h2>Header 2</h2>

        <h2>Broken # header</h2>

        <h2>Header Goes Here</h2>

        <h2># Header Hash with Two</h2>
        """
        
        XCTAssertEqual(try markdown.render(md), html)
    }
    
    func testHeaderThree() {
        let md = """
        \\#\\#\\# Hello World!
        ### Header 3

        ### Broken # header

        ### \\# Header Hash with Two
        \\### No Header ##
        """
        
        let html = """
        ### Hello World!
        <h3>Header 3</h3>

        <h3>Broken # header</h3>

        <h3># Header Hash with Two</h3>
        ### No Header ##
        """
        
        XCTAssertEqual(try markdown.render(md), html)
    }
    
    func testHeaderFour() {
        let md = """
        \\#\\#\\#\\# Hello World!
        #### Header 4

        #### Broken ## header
        #### Not. ^ mistake. #####

        #### \\# Header Hash with Two
        \\#### No Header ##
        """
        
        let html = """
        #### Hello World!
        <h4>Header 4</h4>

        <h4>Broken ## header</h4>
        <h4>Not. ^ mistake.</h4>

        <h4># Header Hash with Two</h4>
        #### No Header ##
        """
        
        XCTAssertEqual(try markdown.render(md), html)
    }
    
    func testHeaderFive() {
        let md = """
        \\#\\#\\#\\#\\# Hello World!
        ##### Header 5

        ##### Broken ## header
        ##### Not. ^ mistake. ######

        ##### \\# Header Hash with Two
        \\##### No Header ##
        """
        
        let html = """
        ##### Hello World!
        <h5>Header 5</h5>

        <h5>Broken ## header</h5>
        <h5>Not. ^ mistake.</h5>

        <h5># Header Hash with Two</h5>
        ##### No Header ##
        """
        
        XCTAssertEqual(try markdown.render(md), html)
    }
    
    func testHeaderSix() {
        let md = """
        \\#\\#\\#\\#\\#\\# Hello World!
        ###### Header 6

        ###### Broken ## header
        ###### Not. ^ mistake. #######

        ###### \\# Header Hash with Two
        \\###### No Header ##
        """
        
        let html = """
        ###### Hello World!
        <h6>Header 6</h6>

        <h6>Broken ## header</h6>
        <h6>Not. ^ mistake.</h6>

        <h6># Header Hash with Two</h6>
        ###### No Header ##
        """
        
        XCTAssertEqual(try markdown.render(md), html)
    }
    
    func testBold() {
        let md = """
        **This is bold text *here***
        __ Underscores _also_ work for this__
        **You can also use both __
        """
        
        let html = """
        <strong>This is bold text <em>here</em></strong>
        <strong> Underscores <em>also</em> work for this</strong>
        <strong>You can also use both </strong>
        """
        
        XCTAssertEqual(try markdown.render(md), html)
    }
    
    func testItalic() {
        let md = """
        *This is bold text **here***
        _ Underscores __also__ work for this_
        *You can also use both _
        """
        
        let html = """
        <em>This is bold text <strong>here</strong></em>
        <em> Underscores <strong>also</strong> work for this</em>
        <em>You can also use both </em>
        """
        
        XCTAssertEqual(try markdown.render(md), html)
    }
    
    func testLink() {
        let md = """
        [Hello Stranger](https://swift.sandbox.bluemix.net/#/repl)
        [**Styled** Links are *Usefull_](https://swift.sandbox.bluemix.net/#/repl)
        """
        
        let html = """
        <a href="https://swift.sandbox.bluemix.net/#/repl">Hello Stranger</a>
        <a href="https://swift.sandbox.bluemix.net/#/repl"><strong>Styled</strong> Links are <em>Usefull</em></a>
        """
        
        XCTAssertEqual(try markdown.render(md), html)
    }
    
    static var allTests : [(String, (Version2Tests) -> () throws -> Void)] {
        return [
            ("testText", testText),
            ("testEscape", testEscape),
            ("testHeaderOne", testHeaderOne),
            ("testHeaderTwo", testHeaderTwo),
            ("testHeaderThree", testHeaderThree),
            ("testHeaderFour", testHeaderFour),
            ("testHeaderFive", testHeaderFive),
            ("testHeaderSix", testHeaderSix),
            ("testBold", testBold)
        ]
    }
}
