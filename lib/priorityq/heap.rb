module Priorityq
  class Heap
    class MinHeap < Heap
      def in_order?(first_index, second_index)
        heap[first_index] <= heap[second_index]
      end
    end

    def self.max
      new
    end

    def self.min
      MinHeap.new
    end

    def initialize
      @heap = [0]
    end

    def empty?
      heap.size == 1
    end

    def peek
      return nil if empty?

      heap[1]
    end

    def pop
      return nil if empty?

      exchange 1, top
      value = heap.pop
      bubble_down 1
      value
    end

    def push(value)
      heap.push value
      bubble_up top
    end

    private

    attr_reader :heap

    def bubble_down(index)
      largest = largest_child_index(index)
      return if largest.nil? || in_order?(index, largest)

      exchange index, largest
      bubble_down largest
    end

    def bubble_up(index)
      return if index == 1

      pi = parent_index(index)

      return if in_order?(pi, index)

      exchange index, pi
      bubble_up pi
    end

    def exchange(first_index, second_index)
      first_value = heap[first_index]
      second_value = heap[second_index]
      heap[first_index] = second_value
      heap[second_index] = first_value
    end

    def in_order?(first_index, second_index)
      heap[first_index] >= heap[second_index]
    end

    def largest_child_index(index)
      max = top
      left = 2 * index
      return if left > max

      right = left + 1
      return left if right > max || in_order?(left, right)

      right
    end

    def parent_index(child_index)
      (child_index / 2).floor
    end

    def top
      heap.size - 1
    end
  end
end
