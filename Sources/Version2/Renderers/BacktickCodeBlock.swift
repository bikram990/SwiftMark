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

public class BacktickCodeBlock: Renderer {
    public var regex: RegEx = "```((.|\\n)*)```"
    public var templates: [String] = ["$1"]
    public var type: String = "raw"
    public var disallowedTags: [String] = []
    public var renderer: MarkdownRenderer = Markdown()
    
    public required init() {
        renderer.disallowedTags = disallowedTags
    }
    
    public func tokenize(_ strings: [String]) -> Token {
        return BacktickCodeBlockToken(value: strings[0])
    }
    
    public func parse(_ token: Token)throws -> Node {
        guard case let TokenValue.string(value) = token.value else {
            throw BacktickCodeBlockRenderingError.tokenParse
        }
        return BacktickCodeBlockNode(value: value)
    }
    
    public func render(_ node: Node)throws -> String {
        guard case let NodeValue.string(value) = node.value else {
            throw BacktickCodeBlockRenderingError.nodeRender
        }
        return value
    }
    
    
}

public class BacktickCodeBlockToken: Token {
    public var renderer: Renderer.Type = BacktickCodeBlock.self
    public var value: TokenValue
    
    public init(value: String) {
        self.value = TokenValue.string(value)
    }
}

public class BacktickCodeBlockNode: Node {
    public var renderer: Renderer.Type = BacktickCodeBlock.self
    public var value: NodeValue
    
    public init(value: String) {
        self.value = NodeValue.string(value)
    }
}

public enum BacktickCodeBlockRenderingError: Error {
    case tokenParse
    case nodeRender
}
