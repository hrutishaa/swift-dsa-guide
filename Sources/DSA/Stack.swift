/// A last-in, first-out collection (Chapter 6).
///
/// Backed by an array, so `push`, `pop`, and `peek` are all O(1) amortized.
public struct Stack<Element> {
    private var storage: [Element] = []

    public init() {}

    public init<S: Sequence>(_ elements: S) where S.Element == Element {
        storage = Array(elements)
    }

    public var isEmpty: Bool { storage.isEmpty }
    public var count: Int { storage.count }

    /// The element that `pop()` would return next, without removing it.
    public var peek: Element? { storage.last }

    public mutating func push(_ element: Element) {
        storage.append(element)
    }

    @discardableResult
    public mutating func pop() -> Element? {
        storage.popLast()
    }
}

extension Stack {
    /// Returns true when every bracket in `text` is closed in the right order.
    /// A classic stack interview problem: "([]{})" is balanced, "(]" is not.
    public static func isBalanced(_ text: String) -> Bool {
        let pairs: [Character: Character] = [")": "(", "]": "[", "}": "{"]
        var stack = Stack<Character>()
        for char in text {
            if pairs.values.contains(char) {
                stack.push(char)
            } else if let opener = pairs[char] {
                guard stack.pop() == opener else { return false }
            }
        }
        return stack.isEmpty
    }
}
