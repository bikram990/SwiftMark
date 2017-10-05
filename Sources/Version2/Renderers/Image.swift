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

public class Image: Renderer {
    public var regex: RegEx = "!\\[([^\\]]+)\\]\\(([^\\)]+)\\)"
    public var templates: [String] = ["$1", "$2"]
    public var type: String = "image"
    public var disallowedTags: [String] = []
    public var renderer: MarkdownRenderer = Markdown()
    
    public required init() {}
    
    public func tokenize(_ strings: [String])throws -> Token {
        let text = Text().tokenize([strings[0]])
        let url = Text().tokenize([strings[1]])
        let value = [text, url]
        return ImageToken(value: value)
    }
    
    public func parse(_ token: Token)throws -> Node {
        guard case let TokenValue.array(tokens) = token.value else {
            throw ImageRenderingError.tokenParse
        }
        let nodes = try self.renderer.parse(tokens)
        return ImageNode(value: nodes)
    }
    
    public func render(_ node: Node)throws -> String {
        guard case var NodeValue.array(nodes) = node.value else {
            throw ImageRenderingError.nodeRender
        }
        
        let url = try self.renderer.render([nodes.removeLast()])
        let text = try self.renderer.render(nodes)
        return "<img src=\"\(url)\" alt=\"\(text)\"/>"
    }
    
    
}

public class ImageToken: Token {
    public var renderer: Renderer.Type = Image.self
    public var value: TokenValue
    
    public init(value: [Token]) {
        self.value = .array(value)
    }
}

public class ImageNode: Node {
    public var renderer: Renderer.Type = Image.self
    public var value: NodeValue
    
    public init(value: [Node]) {
        self.value = .array(value)
    }
}

public enum ImageRenderingError: Error {
    case tokenParse
    case nodeRender
}
