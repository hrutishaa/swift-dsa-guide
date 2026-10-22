/// Sorting and searching algorithms (Chapter 8).
public enum Algorithms {
    /// Binary search on a sorted array. O(log n).
    /// Returns the index of `target`, or nil if it is not present.
    public static func binarySearch<T: Comparable>(_ array: [T], for target: T) -> Int? {
        var low = 0
        var high = array.count - 1
        while low <= high {
            let mid = low + (high - low) / 2
            if array[mid] == target {
                return mid
            } else if array[mid] < target {
                low = mid + 1
            } else {
                high = mid - 1
            }
        }
        return nil
    }

    /// Merge sort. O(n log n) time, O(n) extra space, and stable.
    public static func mergeSort<T: Comparable>(_ array: [T]) -> [T] {
        guard array.count > 1 else { return array }
        let mid = array.count / 2
        let left = mergeSort(Array(array[..<mid]))
        let right = mergeSort(Array(array[mid...]))

        var merged: [T] = []
        merged.reserveCapacity(array.count)
        var i = 0, j = 0
        while i < left.count && j < right.count {
            if right[j] < left[i] {
                merged.append(right[j]); j += 1
            } else {
                merged.append(left[i]); i += 1
            }
        }
        merged.append(contentsOf: left[i...])
        merged.append(contentsOf: right[j...])
        return merged
    }

    /// In-place quicksort with Lomuto partitioning. O(n log n) on average.
    public static func quickSort<T: Comparable>(_ array: inout [T]) {
        quickSort(&array, low: 0, high: array.count - 1)
    }

    private static func quickSort<T: Comparable>(_ array: inout [T], low: Int, high: Int) {
        guard low < high else { return }
        // Middle element as pivot avoids the O(n^2) case on sorted input.
        array.swapAt((low + high) / 2, high)
        let pivot = array[high]
        var boundary = low
        for index in low..<high where array[index] < pivot {
            array.swapAt(index, boundary)
            boundary += 1
        }
        array.swapAt(boundary, high)
        quickSort(&array, low: low, high: boundary - 1)
        quickSort(&array, low: boundary + 1, high: high)
    }

    /// Returns the k smallest values using a max-heap of size k. O(n log k).
    public static func kSmallest<T: Comparable>(_ values: [T], k: Int) -> [T] {
        guard k > 0 else { return [] }
        var heap = Heap<T>.maxHeap()
        for value in values {
            heap.insert(value)
            if heap.count > k { heap.pop() }
        }
        var result: [T] = []
        while let value = heap.pop() { result.append(value) }
        return result.reversed()
    }
}
