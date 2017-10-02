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

/// An implimented Markdown to HTML renderer.
open class Markdown: MarkdownRenderer {
    
    /// The renderers used to convert the Markdown to HTML.
    private var renderers: [Renderer.Type] = []
    
    /// Makes a renderer available to an instance of `Markdown` when rendering Markdown.
    ///
    /// - Parameter renderer: The renderer to expose to `Markdown`.
    public func addRenderer(_ renderer: Renderer.Type) {
        renderers.append(renderer)
    }
    
    /// Exposes multiple renderers to an intance to `Markdown`.
    ///
    /// - Parameter renderers: The renderers to expose.
    public func addRenderers(_ renderers: [Renderer.Type]) {
        self.renderers.append(contentsOf: renderers)
    }
    
    /// Lexes a String to an array of Tokens.
    ///
    /// - Parameter string: The String to tokenize.
    /// - Returns: The Tokens containing the data for the HTML
    public func tokenize(_ string: String)throws -> [Token] {
        var tokens: [Token] = []
        var input: String = string
        
        while input.count > 0 {
            var matched = false
            
            for rendererType in self.renderers {
                let renderer = rendererType.init(renderer: self)
                
                if let match = try input.match(regex: renderer.regex, with: renderer.templates) {
                    let token = renderer.tokenize(match.0.joined(separator: "::"))
                    tokens.append(token)
                    
                    input = input.substring(from: input.characters.index(input.startIndex, offsetBy: match.1.characters.count))
                    matched = true
                    break
                }
            }
            
            if !matched {
                let index = input.characters.index(input.startIndex, offsetBy: 1)
                tokens.append(TextToken(value: input.substring(to: index)))
                input = input.substring(from: index)
            }
        }
        
        return tokens
    }
    
    /// Parses an array of Tokens into an AST (made up of Nodes).
    ///
    /// - Parameter tokens: The Tokens to parse.
    /// - Returns: An AST containing the data held in the Tokens passed in.
    public func parse(_ tokens: [Token]) -> [Node] {
        return tokens.map { token in token.renderer.init(renderer: self).parse(token) }
    }
    
    /// Renders HTML from an AST (array of Nodes).
    ///
    /// - Parameter nodes: The Nodes to render.
    /// - Returns: The HTML with the data from the Nodes passed in.
    public func render(_ nodes: [Node]) -> String {
        return nodes.map({ node in node.renderer.init(renderer: self).render(node) }).joined()
    }
    
    /// Renders a block of Markdown to HTML.
    ///
    /// - Parameter string: The Markdown to render.
    /// - Returns: The HTML equivalent of the Markdown passed in.
    public func render(_ string: String)throws -> String {
        self.addRenderers([
                Text.self
            ])
        
        let tokens = try tokenize(string)
        let nodes = parse(tokens)
        return render(nodes)
    }
}
