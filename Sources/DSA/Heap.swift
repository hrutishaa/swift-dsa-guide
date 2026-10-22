/// A binary heap stored in an array (Chapter 10).
///
/// `areSorted(a, b)` returns true when `a` should come out before `b`,
/// so `Heap(areSorted: <)` is a min-heap and `Heap(areSorted: >)` is a max-heap.
public struct Heap<Element> {
    private var elements: [Element] = []
    private let areSorted: (Element, Element) -> Bool

    public init(areSorted: @escaping (Element, Element) -> Bool) {
        self.areSorted = areSorted
    }

    public init<S: Sequence>(_ values: S, areSorted: @escaping (Element, Element) -> Bool)
    where S.Element == Element {
        self.areSorted = areSorted
        elements = Array(values)
        // Heapify bottom-up in O(n).
        for index in stride(from: elements.count / 2 - 1, through: 0, by: -1) {
            siftDown(from: index)
        }
    }

    public var isEmpty: Bool { elements.isEmpty }
    public var count: Int { elements.count }
    public var peek: Element? { elements.first }

    /// O(log n)
    public mutating func insert(_ element: Element) {
        elements.append(element)
        siftUp(from: elements.count - 1)
    }

    /// O(log n)
    @discardableResult
    public mutating func pop() -> Element? {
        guard !elements.isEmpty else { return nil }
        elements.swapAt(0, elements.count - 1)
        let top = elements.removeLast()
        if !elements.isEmpty { siftDown(from: 0) }
        return top
    }

    private mutating func siftUp(from index: Int) {
        var child = index
        while child > 0 {
            let parent = (child - 1) / 2
            guard areSorted(elements[child], elements[parent]) else { return }
            elements.swapAt(child, parent)
            child = parent
        }
    }

    private mutating func siftDown(from index: Int) {
        var parent = index
        while true {
            let left = 2 * parent + 1
            let right = left + 1
            var candidate = parent
            if left < elements.count, areSorted(elements[left], elements[candidate]) {
                candidate = left
            }
            if right < elements.count, areSorted(elements[right], elements[candidate]) {
                candidate = right
            }
            if candidate == parent { return }
            elements.swapAt(parent, candidate)
            parent = candidate
        }
    }
}

extension Heap where Element: Comparable {
    public static func minHeap() -> Heap { Heap(areSorted: <) }
    public static func maxHeap() -> Heap { Heap(areSorted: >) }
}
