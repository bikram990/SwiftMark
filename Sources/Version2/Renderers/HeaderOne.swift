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

public class HeaderOne: Renderer {
    public var regex: RegEx = "(\\#\\s?([^\\#\\n]+)\\#*|(.+)\\n\\=+)"
    public var templates: [String] = ["$2", "$3"]
    public var renderer: MarkdownRenderer
    
    public required init(renderer: MarkdownRenderer) {
        self.renderer = renderer
    }
    
    public func tokenize(_ strings: [String])throws -> Token {
        let internalTokens = try renderer.tokenize(strings[0])
        return HeaderOneToken(value: internalTokens)
    }
    
    public func parse(_ token: Token) -> Node {
        guard case let TokenValue.array(tokens) = token.value else {
            fatalError("[SwiftMark] - Getting token value from HeaderOneToken")
        }
        let internalNodes = self.renderer.parse(tokens)
        return HeaderOneNode(value: internalNodes)
    }
    
    public func render(_ node: Node) -> String {
        guard case let NodeValue.array(nodes) = node.value else {
            fatalError("[SwiftMark] - Getting token value from HeaderOnNode")
        }
        let internalHTML = self.renderer.render(nodes)
        return "<h1>\(internalHTML)</h1>"
    }
    
    
}

public class HeaderOneToken: Token {
    public var renderer: Renderer.Type = HeaderOne.self
    public var value: TokenValue
    
    init(value: [Token]) {
        self.value = .array(value)
    }
}

public class HeaderOneNode: Node {
    public var renderer: Renderer.Type = HeaderOne.self
    public var value: NodeValue
    
    init(value: [Node]) {
        self.value = .array(value)
    }
}
