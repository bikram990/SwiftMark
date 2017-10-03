//The MIT License (MIT)
//
//Copyright (c) 2017 Caleb Kleveter
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

/// A Markdown to HTML renderer.
public protocol MarkdownRenderer {
    
    /// Lexes a String to the corosponding Tokens.
    ///
    /// - Parameter string: The String to tokenize.
    /// - Returns: The Tokens that represent the String passed in.
    func tokenize(_ string: String)throws -> [Token]
    
    /// Parses an array of Tokens to an AST (made up of Nodes).
    ///
    /// - Parameter tokens: The Tokens to parse.
    /// - Returns: An AST with the data from the Tokens passed in.
    func parse(_ tokens: [Token]) -> [Node]
    
    /// Renders an AST into HTML.
    ///
    /// - Parameter nodes: The AST (made of an array of Nodes) to render.
    /// - Returns: The HTML with the data conatined in the AST.
    func render(_ nodes: [Node]) -> String
    
    /// Renders a block of Markdown to HTML.
    ///
    /// - Parameter string: The Markdown to render.
    /// - Returns: HTML that is the equivalent of the Markdown passed in.
    func render(_ string: String)throws -> String
}
