/// An adjacency-list graph with BFS, DFS, and Dijkstra (Chapter 11).
public struct Graph<Vertex: Hashable> {
    public struct Edge {
        public let to: Vertex
        public let weight: Double
    }

    private(set) var adjacency: [Vertex: [Edge]] = [:]
    public let isDirected: Bool

    public init(directed: Bool = false) {
        isDirected = directed
    }

    public var vertices: [Vertex] { Array(adjacency.keys) }

    public mutating func addVertex(_ vertex: Vertex) {
        if adjacency[vertex] == nil { adjacency[vertex] = [] }
    }

    public mutating func addEdge(from source: Vertex, to destination: Vertex, weight: Double = 1) {
        addVertex(source)
        addVertex(destination)
        adjacency[source, default: []].append(Edge(to: destination, weight: weight))
        if !isDirected {
            adjacency[destination, default: []].append(Edge(to: source, weight: weight))
        }
    }

    public func neighbors(of vertex: Vertex) -> [Vertex] {
        adjacency[vertex, default: []].map(\.to)
    }

    /// Breadth-first order from `start`. Visits closest vertices first.
    public func breadthFirst(from start: Vertex) -> [Vertex] {
        guard adjacency[start] != nil else { return [] }
        var visited: Set<Vertex> = [start]
        var order: [Vertex] = []
        var queue = Queue<Vertex>()
        queue.enqueue(start)
        while let vertex = queue.dequeue() {
            order.append(vertex)
            for next in neighbors(of: vertex) where !visited.contains(next) {
                visited.insert(next)
                queue.enqueue(next)
            }
        }
        return order
    }

    /// Depth-first order from `start`, using an explicit stack.
    public func depthFirst(from start: Vertex) -> [Vertex] {
        guard adjacency[start] != nil else { return [] }
        var visited: Set<Vertex> = []
        var order: [Vertex] = []
        var stack = Stack<Vertex>()
        stack.push(start)
        while let vertex = stack.pop() {
            guard !visited.contains(vertex) else { continue }
            visited.insert(vertex)
            order.append(vertex)
            // Push in reverse so neighbors are visited in insertion order.
            for next in neighbors(of: vertex).reversed() where !visited.contains(next) {
                stack.push(next)
            }
        }
        return order
    }

    /// Fewest-edges path from `start` to `goal`, or nil if unreachable.
    public func shortestPath(from start: Vertex, to goal: Vertex) -> [Vertex]? {
        guard adjacency[start] != nil, adjacency[goal] != nil else { return nil }
        var cameFrom: [Vertex: Vertex] = [:]
        var visited: Set<Vertex> = [start]
        var queue = Queue<Vertex>()
        queue.enqueue(start)
        while let vertex = queue.dequeue() {
            if vertex == goal { return path(to: goal, from: start, cameFrom: cameFrom) }
            for next in neighbors(of: vertex) where !visited.contains(next) {
                visited.insert(next)
                cameFrom[next] = vertex
                queue.enqueue(next)
            }
        }
        return nil
    }

    /// Dijkstra's algorithm: cheapest distance from `start` to every reachable
    /// vertex. Weights must be non-negative. O((V + E) log V) with a heap.
    public func dijkstra(from start: Vertex) -> [Vertex: Double] {
        guard adjacency[start] != nil else { return [:] }
        var distances: [Vertex: Double] = [start: 0]
        var heap = Heap<(vertex: Vertex, distance: Double)>(areSorted: { $0.distance < $1.distance })
        heap.insert((start, 0))
        while let (vertex, distance) = heap.pop() {
            // Skip stale heap entries left behind by a later, cheaper update.
            if distance > distances[vertex, default: .infinity] { continue }
            for edge in adjacency[vertex, default: []] {
                let candidate = distance + edge.weight
                if candidate < distances[edge.to, default: .infinity] {
                    distances[edge.to] = candidate
                    heap.insert((edge.to, candidate))
                }
            }
        }
        return distances
    }

    private func path(to goal: Vertex, from start: Vertex, cameFrom: [Vertex: Vertex]) -> [Vertex] {
        var path = [goal]
        var current = goal
        while current != start, let previous = cameFrom[current] {
            path.append(previous)
            current = previous
        }
        return path.reversed()
    }
}
