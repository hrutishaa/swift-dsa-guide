/// A first-in, first-out collection (Chapter 6).
///
/// Uses two arrays so `dequeue` is O(1) amortized instead of the O(n)
/// you would get from `Array.removeFirst()`.
public struct Queue<Element> {
    private var inbox: [Element] = []
    private var outbox: [Element] = []

    public init() {}

    public var isEmpty: Bool { inbox.isEmpty && outbox.isEmpty }
    public var count: Int { inbox.count + outbox.count }

    /// The element that `dequeue()` would return next.
    public var front: Element? { outbox.last ?? inbox.first }

    public mutating func enqueue(_ element: Element) {
        inbox.append(element)
    }

    @discardableResult
    public mutating func dequeue() -> Element? {
        if outbox.isEmpty {
            outbox = inbox.reversed()
            inbox.removeAll()
        }
        return outbox.popLast()
    }
}
