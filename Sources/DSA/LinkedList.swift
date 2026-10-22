/// A singly linked list with value semantics (Chapter 5).
public struct LinkedList<Value> {
    final class Node {
        var value: Value
        var next: Node?
        init(_ value: Value, next: Node? = nil) {
            self.value = value
            self.next = next
        }
    }

    private var head: Node?
    private var tail: Node?
    public private(set) var count = 0

    public init() {}

    public init<S: Sequence>(_ values: S) where S.Element == Value {
        for value in values { append(value) }
    }

    public var isEmpty: Bool { head == nil }
    public var first: Value? { head?.value }
    public var last: Value? { tail?.value }

    /// O(1): add to the front.
    public mutating func push(_ value: Value) {
        copyNodesIfShared()
        head = Node(value, next: head)
        if tail == nil { tail = head }
        count += 1
    }

    /// O(1): add to the back, thanks to the tail pointer.
    public mutating func append(_ value: Value) {
        copyNodesIfShared()
        let node = Node(value)
        if let tail = tail {
            tail.next = node
        } else {
            head = node
        }
        tail = node
        count += 1
    }

    /// O(1): remove from the front.
    @discardableResult
    public mutating func popFirst() -> Value? {
        copyNodesIfShared()
        guard let node = head else { return nil }
        head = node.next
        if head == nil { tail = nil }
        count -= 1
        return node.value
    }

    /// O(n): reverse the links in place, the classic pointer exercise.
    public mutating func reverse() {
        copyNodesIfShared()
        var previous: Node? = nil
        var current = head
        tail = head
        while let node = current {
            current = node.next
            node.next = previous
            previous = node
        }
        head = previous
    }

    /// Copy-on-write: nodes are classes, so copy them before mutating a
    /// list that shares its nodes with another variable.
    private mutating func copyNodesIfShared() {
        // Check uniqueness before binding a local reference, which would
        // otherwise bump the reference count and force a copy every time.
        guard !isKnownUniquelyReferenced(&head), let head = head else { return }
        let newHead = Node(head.value)
        var newTail = newHead
        var source = head.next
        while let node = source {
            let copy = Node(node.value)
            newTail.next = copy
            newTail = copy
            source = node.next
        }
        self.head = newHead
        self.tail = newTail
    }
}

extension LinkedList: Sequence {
    public struct Iterator: IteratorProtocol {
        fileprivate var current: Node?
        public mutating func next() -> Value? {
            defer { current = current?.next }
            return current?.value
        }
    }

    public func makeIterator() -> Iterator { Iterator(current: head) }
}
