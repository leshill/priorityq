module Priorityq
  class PriorityQueue
    class Element
      include Comparable

      attr_reader :priority, :value

      def initialize(priority, value)
        @priority = priority
        @value = value
      end

      def <=>(other)
        priority <=> other.priority
      end
    end

    def initialize
      @heap = Priorityq::Heap.max
    end

    def empty?
      heap.empty?
    end

    def peek
      peek_element&.value
    end

    def peek_element
      heap.peek
    end

    def pop
      pop_element&.value
    end

    def pop_element
      heap.pop
    end

    def push(priority, value)
      heap.push Element.new(priority, value)
    end

    private

    attr_reader :heap
  end
end
