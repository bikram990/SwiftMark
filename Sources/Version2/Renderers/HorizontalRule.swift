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

public class HorizontalRule: Renderer {
    public var regex: RegEx = "[^\\s]+"
    public var templates: [String] = []
    public var type: String = "style"
    public var disallowedTags: [String] = []
    public var renderer: MarkdownRenderer = Markdown()
    
    public required init() {
        renderer.disallowedTags = disallowedTags
    }
    
    public func tokenize(_ strings: [String]) -> Token {
        return HorizontalRuleToken()
    }
    
    public func parse(_ token: Token)throws -> Node {
        guard case TokenValue.null = token.value else {
            throw HorizontalRuleRenderingError.tokenParse
        }
        return HorizontalRuleNode()
    }
    
    public func render(_ node: Node)throws -> String {
        guard case NodeValue.null = node.value else {
            throw HorizontalRuleRenderingError.nodeRender
        }
        return "<hr/>"
    }
    
    
}

public class HorizontalRuleToken: Token {
    public var renderer: Renderer.Type = HorizontalRule.self
    public var value: TokenValue = .null
}

public class HorizontalRuleNode: Node {
    public var renderer: Renderer.Type = HorizontalRule.self
    public var value: NodeValue = .null
}

public enum HorizontalRuleRenderingError: Error {
    case tokenParse
    case nodeRender
}
