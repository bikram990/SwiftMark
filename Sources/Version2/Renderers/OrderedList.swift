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

import Foundation

public class OrderedList: Renderer {
    public var regex: RegEx = "(?:\\d+\\.\\h*(?:.+)\\n?)+"
    public var templates: [String] = ["$0"]
    public var type: String = "list"
    public var disallowedTags: [String] = ["header"]
    public var renderer: MarkdownRenderer = Markdown()
    
    public required init() {
        renderer.disallowedTags = disallowedTags
    }
    
    public func tokenize(_ strings: [String])throws -> Token {
        let regexp = try NSRegularExpression(pattern: "^\\d+\\.\\s*", options: .anchorsMatchLines)
        let value: [Token] = try strings[0].split(separator: "\n").map({
            let listItem = regexp.stringByReplacingMatches(in: String(describing: $0), range: NSMakeRange(0, $0.utf8.count), withTemplate: "")
            return try OrderedListItemToken(value: self.renderer.tokenize(listItem))
        })
        return OrderedListToken(value: value)
    }
    
    public func parse(_ token: Token)throws -> Node {
        guard case let TokenValue.array(tokens) = token.value else {
            throw OrderedListRenderingError.tokenParse
        }
        let nodes = try tokens.map({ (token)throws -> Node in
            guard case let TokenValue.array(subTokens) = token.value else {
                throw OrderedListRenderingError.tokenParse
            }
            return OrderedListItemNode(value: try self.renderer.parse(subTokens))
        })
        return OrderedListNode(value: nodes)
    }
    
    public func render(_ node: Node)throws -> String {
        guard case let NodeValue.array(nodes) = node.value else {
            throw OrderedListRenderingError.nodeRender
        }
        let listItems = try nodes.map({ node in
            return try self.renderListItem(node as! OrderedListItemNode)
        })
        return "<ol>\(listItems.joined(separator: "\n"))</ol>"
    }
    
    // MARK: - Private Methods
    private func renderListItem(_ item: OrderedListItemNode)throws -> String {
        guard case let NodeValue.array(nodes) = item.value else {
            throw OrderedListRenderingError.nodeRender
        }
        let text = try self.renderer.render(nodes)
        return "<li>\(text)</li>"
    }
}

public class OrderedListToken: Token {
    public var renderer: Renderer.Type = OrderedList.self
    public var value: TokenValue
    
    public init(value: [Token]) {
        self.value = .array(value)
    }
}

public class OrderedListNode: Node {
    public var renderer: Renderer.Type = OrderedList.self
    public var value: NodeValue
    
    public init(value: [Node]) {
        self.value = .array(value)
    }
}

public enum OrderedListRenderingError: Error {
    case tokenParse
    case nodeRender
}

// MARK: - Ordered List Items
fileprivate class OrderedListItemToken: Token {
    fileprivate var renderer: Renderer.Type = OrderedList.self
    fileprivate var value: TokenValue
    
    fileprivate init(value: [Token]) {
        self.value = .array(value)
    }
}

fileprivate class OrderedListItemNode: Node {
    fileprivate var renderer: Renderer.Type = OrderedList.self
    fileprivate var value: NodeValue
    
    fileprivate init(value: [Node]) {
        self.value = .array(value)
    }
}
