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

public class Link: Renderer {
    public var regex: RegEx = "\\[(.+)\\]\\((.+)\\)"
    public var templates: [String] = ["$1", "$2"]
    public var type: String = "link"
    public var disallowedTags: [String] = ["header", "quote", "hr"]
    public var renderer: MarkdownRenderer = Markdown()
    
    public required init() {
        renderer.disallowedTags = disallowedTags
    }
    
    public func tokenize(_ strings: [String])throws -> Token {
        let text = try renderer.tokenize(strings[0])
        let url = Text().tokenize([strings[1]])
        let value = text + [url]
        return LinkToken(value: value)
    }
    
    public func parse(_ token: Token)throws -> Node {
        guard case let TokenValue.array(tokens) = token.value else {
            throw LinkRenderingError.tokenParse
        }
        let nodes = try self.renderer.parse(tokens)
        return LinkNode(value: nodes)
    }
    
    public func render(_ node: Node)throws -> String {
        guard case var NodeValue.array(nodes) = node.value else {
            throw LinkRenderingError.nodeRender
        }

        let url = try self.renderer.render([nodes.removeLast()])
        let text = try self.renderer.render(nodes)
        return "<a href=\"\(url)\">\(text)</a>"
    }
    
    
}

public class LinkToken: Token {
    public var renderer: Renderer.Type = Link.self
    public var value: TokenValue
    
    public init(value: [Token]) {
        self.value = .array(value)
    }
}

public class LinkNode: Node {
    public var renderer: Renderer.Type = Link.self
    public var value: NodeValue
    
    public init(value: [Node]) {
        self.value = .array(value)
    }
}

public enum LinkRenderingError: Error {
    case tokenParse
    case nodeRender
}
