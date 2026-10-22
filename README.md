# Data Structures & Algorithms in Swift

![Swift 5.7+](https://img.shields.io/badge/Swift-5.7%2B-orange)
![Platforms](https://img.shields.io/badge/platforms-macOS%20%7C%20Linux-lightgrey)

A from-scratch study guide with a 12-week plan, plus a tested Swift package that implements the core data structures and algorithms from the guide.

- **Guide:** [`DSA-in-Swift-Guide.pdf`](DSA-in-Swift-Guide.pdf), 13 chapters with plain-English explanations, diagrams, and practice problems.
- **Code:** [`Sources/DSA`](Sources/DSA), generic implementations with no dependencies.
- **Tests:** [`Tests/DSATests`](Tests/DSATests), 15 XCTest cases covering every structure and algorithm.

## What's implemented

| Chapter | Type / function | Highlights |
| --- | --- | --- |
| 5. Linked Lists | `LinkedList` | O(1) push, append, and pop; in-place reversal; copy-on-write value semantics; `Sequence` conformance |
| 6. Stacks & Queues | `Stack`, `Queue` | Array-backed stack, two-array queue with O(1) amortized dequeue, balanced-brackets checker |
| 8. Sorting & Searching | `Algorithms` | Binary search, stable merge sort, in-place quicksort, k-smallest with a heap |
| 10. Heaps & Priority Queues | `Heap` | Min- or max-heap from any ordering, O(n) heapify, O(log n) insert and pop |
| 11. Graphs | `Graph` | Directed or undirected adjacency list, BFS, DFS, fewest-edges path, Dijkstra |

## Quick start

```bash
git clone https://github.com/hrutishaa/swift-dsa-guide.git
cd swift-dsa-guide
swift test
```

Use it from your own package:

```swift
.package(url: "https://github.com/hrutishaa/swift-dsa-guide.git", branch: "main")
```

```swift
import DSA

var graph = Graph<String>(directed: true)
graph.addEdge(from: "S", to: "A", weight: 10)
graph.addEdge(from: "S", to: "B", weight: 1)
graph.addEdge(from: "B", to: "A", weight: 2)
graph.dijkstra(from: "S")["A"]   // 3.0

var tasks = Heap<Int>.minHeap()
[5, 1, 4].forEach { tasks.insert($0) }
tasks.pop()                      // 1

Stack<Character>.isBalanced("{[()]}")   // true
```

## 12-week plan

Work through one chapter a week: read it in the guide, type the implementation yourself, solve the practice problems, then compare against the code and tests here. The full schedule is in Chapter 13 of the PDF.
