import XCTest
@testable import DSA

final class StackAndQueueTests: XCTestCase {
    func testStackIsLastInFirstOut() {
        var stack = Stack([1, 2, 3])
        XCTAssertEqual(stack.peek, 3)
        XCTAssertEqual(stack.pop(), 3)
        XCTAssertEqual(stack.pop(), 2)
        stack.push(9)
        XCTAssertEqual(stack.pop(), 9)
        XCTAssertEqual(stack.pop(), 1)
        XCTAssertNil(stack.pop())
        XCTAssertTrue(stack.isEmpty)
    }

    func testBalancedBrackets() {
        XCTAssertTrue(Stack<Character>.isBalanced("([]{})"))
        XCTAssertTrue(Stack<Character>.isBalanced("func f() { return [1, 2] }"))
        XCTAssertFalse(Stack<Character>.isBalanced("(]"))
        XCTAssertFalse(Stack<Character>.isBalanced("(("))
        XCTAssertFalse(Stack<Character>.isBalanced("())"))
    }

    func testQueueIsFirstInFirstOut() {
        var queue = Queue<String>()
        queue.enqueue("a")
        queue.enqueue("b")
        XCTAssertEqual(queue.front, "a")
        XCTAssertEqual(queue.dequeue(), "a")
        queue.enqueue("c")
        XCTAssertEqual(queue.count, 2)
        XCTAssertEqual(queue.front, "b")
        XCTAssertEqual(queue.dequeue(), "b")
        XCTAssertEqual(queue.dequeue(), "c")
        XCTAssertNil(queue.dequeue())
    }
}

final class LinkedListTests: XCTestCase {
    func testPushAppendAndPop() {
        var list = LinkedList([2, 3])
        list.push(1)
        list.append(4)
        XCTAssertEqual(Array(list), [1, 2, 3, 4])
        XCTAssertEqual(list.count, 4)
        XCTAssertEqual(list.popFirst(), 1)
        XCTAssertEqual(list.first, 2)
        XCTAssertEqual(list.last, 4)
    }

    func testReverse() {
        var list = LinkedList(1...5)
        list.reverse()
        XCTAssertEqual(Array(list), [5, 4, 3, 2, 1])
        list.append(0)
        XCTAssertEqual(list.last, 0)
    }

    func testValueSemantics() {
        let original = LinkedList([1, 2, 3])
        var copy = original
        copy.append(4)
        copy.reverse()
        XCTAssertEqual(Array(original), [1, 2, 3])
        XCTAssertEqual(Array(copy), [4, 3, 2, 1])
    }
}

final class HeapTests: XCTestCase {
    func testMinHeapPopsInAscendingOrder() {
        var heap = Heap([5, 3, 8, 1, 9, 2], areSorted: <)
        var output: [Int] = []
        while let value = heap.pop() { output.append(value) }
        XCTAssertEqual(output, [1, 2, 3, 5, 8, 9])
    }

    func testMaxHeapInsert() {
        var heap = Heap<Int>.maxHeap()
        [4, 10, 7, 1].forEach { heap.insert($0) }
        XCTAssertEqual(heap.peek, 10)
        XCTAssertEqual(heap.pop(), 10)
        XCTAssertEqual(heap.pop(), 7)
        XCTAssertEqual(heap.count, 2)
    }
}

final class AlgorithmTests: XCTestCase {
    func testBinarySearch() {
        let sorted = [1, 3, 5, 7, 9, 11]
        XCTAssertEqual(Algorithms.binarySearch(sorted, for: 7), 3)
        XCTAssertEqual(Algorithms.binarySearch(sorted, for: 1), 0)
        XCTAssertEqual(Algorithms.binarySearch(sorted, for: 11), 5)
        XCTAssertNil(Algorithms.binarySearch(sorted, for: 4))
        XCTAssertNil(Algorithms.binarySearch([Int](), for: 1))
    }

    func testSortsMatchStandardLibrary() {
        var generator = SystemRandomNumberGenerator()
        for size in [0, 1, 2, 10, 101] {
            let values = (0..<size).map { _ in Int.random(in: -50...50, using: &generator) }
            XCTAssertEqual(Algorithms.mergeSort(values), values.sorted())
            var quick = values
            Algorithms.quickSort(&quick)
            XCTAssertEqual(quick, values.sorted())
        }
    }

    func testKSmallest() {
        XCTAssertEqual(Algorithms.kSmallest([9, 4, 7, 1, 8, 2], k: 3), [1, 2, 4])
        XCTAssertEqual(Algorithms.kSmallest([3, 1], k: 5), [1, 3])
        XCTAssertEqual(Algorithms.kSmallest([3, 1], k: 0), [])
    }
}

final class GraphTests: XCTestCase {
    private func sampleGraph() -> Graph<String> {
        var graph = Graph<String>()
        graph.addEdge(from: "A", to: "B")
        graph.addEdge(from: "A", to: "C")
        graph.addEdge(from: "B", to: "D")
        graph.addEdge(from: "C", to: "D")
        graph.addEdge(from: "D", to: "E")
        graph.addVertex("Z")
        return graph
    }

    func testBreadthFirst() {
        XCTAssertEqual(sampleGraph().breadthFirst(from: "A"), ["A", "B", "C", "D", "E"])
    }

    func testDepthFirst() {
        XCTAssertEqual(sampleGraph().depthFirst(from: "A"), ["A", "B", "D", "C", "E"])
    }

    func testShortestPath() {
        let graph = sampleGraph()
        XCTAssertEqual(graph.shortestPath(from: "A", to: "E"), ["A", "B", "D", "E"])
        XCTAssertEqual(graph.shortestPath(from: "A", to: "A"), ["A"])
        XCTAssertNil(graph.shortestPath(from: "A", to: "Z"))
    }

    func testDijkstraPrefersCheaperLongerRoute() {
        var graph = Graph<String>(directed: true)
        graph.addEdge(from: "S", to: "A", weight: 10)
        graph.addEdge(from: "S", to: "B", weight: 1)
        graph.addEdge(from: "B", to: "C", weight: 2)
        graph.addEdge(from: "C", to: "A", weight: 3)
        let distances = graph.dijkstra(from: "S")
        XCTAssertEqual(distances["A"], 6)
        XCTAssertEqual(distances["C"], 3)
        XCTAssertNil(distances["missing"])
    }
}
