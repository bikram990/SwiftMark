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

public class UnorderedList: Renderer {
    public var regex: RegEx = "(?:(\\+|-|\\*)\\h*(?:.+)\\n?)+"
    public var templates: [String] = ["$0"]
    public var type: String = "list"
    public var disallowedTags: [String] = ["header"]
    public var renderer: MarkdownRenderer = Markdown()
    
    public required init() {
        renderer.disallowedTags = disallowedTags
    }
    
    public func tokenize(_ strings: [String])throws -> Token {
        let regexp = try NSRegularExpression(pattern: "^(\\+|-|\\*)\\s*", options: .anchorsMatchLines)
        let value: [Token] = try strings[0].split(separator: "\n").map({
            let listItem = regexp.stringByReplacingMatches(in: String(describing: $0), options: [], range: NSMakeRange(0, $0.utf8.count), withTemplate: "")
            return try UnorderedListItemToken(value: self.renderer.tokenize(listItem))
        })
        return UnorderedListToken(value: value)
    }
    
    public func parse(_ token: Token)throws -> Node {
        guard case let TokenValue.array(tokens) = token.value else {
            throw UnorderedListRenderingError.tokenParse
        }
        let nodes = try tokens.map({ (token)throws -> Node in
            guard case let TokenValue.array(subTokens) = token.value else {
                throw UnorderedListRenderingError.tokenParse
            }
            return UnorderedListItemNode(value: try self.renderer.parse(subTokens))
        })
        return UnorderedListNode(value: nodes)
    }
    
    public func render(_ node: Node)throws -> String {
        guard case let NodeValue.array(nodes) = node.value else {
            throw UnorderedListRenderingError.nodeRender
        }
        let listItems = try nodes.map({ node in
            return try self.renderListItem(node as! UnorderedListItemNode)
        })
        return "<ul>\(listItems.joined(separator: "\n"))</ul>"
    }
    
    // MARK: - Private Methods
    private func renderListItem(_ item: UnorderedListItemNode)throws -> String {
        guard case let NodeValue.array(nodes) = item.value else {
            throw UnorderedListRenderingError.nodeRender
        }
        let text = try self.renderer.render(nodes)
        return "<li>\(text)</li>"
    }
}

public class UnorderedListToken: Token {
    public var renderer: Renderer.Type = UnorderedList.self
    public var value: TokenValue
    
    public init(value: [Token]) {
        self.value = .array(value)
    }
}

public class UnorderedListNode: Node {
    public var renderer: Renderer.Type = UnorderedList.self
    public var value: NodeValue
    
    public init(value: [Node]) {
        self.value = .array(value)
    }
}

public enum UnorderedListRenderingError: Error {
    case tokenParse
    case nodeRender
}

// MARK: - Unordered List Items
fileprivate class UnorderedListItemToken: Token {
    fileprivate var renderer: Renderer.Type = UnorderedList.self
    fileprivate var value: TokenValue
    
    fileprivate init(value: [Token]) {
        self.value = .array(value)
    }
}

fileprivate class UnorderedListItemNode: Node {
    fileprivate var renderer: Renderer.Type = UnorderedList.self
    fileprivate var value: NodeValue
    
    fileprivate init(value: [Node]) {
        self.value = .array(value)
    }
}

