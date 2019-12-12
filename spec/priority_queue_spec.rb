require 'spec_helper'

RSpec.describe Priorityq::PriorityQueue do
  let(:items) { [[100, 'first'], [50, 'second'], [10, 'third']] }
  let(:pq) { described_class.new }

  def fill_queue(queue, items)
    items.each { |pri, elem| queue.push pri, elem }
  end

  describe Priorityq::PriorityQueue::Element do
    subject { described_class.new 100, 'test' }

    it { is_expected.to be_kind_of Comparable }
  end

  describe '#empty?' do
    subject { pq.empty? }

    context 'when the queue is empty' do
      it { is_expected.to be_truthy }
    end

    context 'when the queue is not empty' do
      before { pq.push 100, 'test' }

      it { is_expected.to be_falsey }
    end
  end

  describe '#peek' do
    subject { pq.peek }

    context 'when the queue is empty' do
      it { is_expected.to be_nil }
    end

    context 'when the queue is not empty' do
      before { fill_queue pq, items }

      it 'returns the value with the top priority' do
        is_expected.to eq 'first'
      end

      it 'does not remove the value with the top priority' do
        is_expected.to eq 'first'
        expect(pq.pop).to eq 'first'
      end
    end
  end

  describe '#peek_element' do
    subject { pq.peek_element }

    context 'when the queue is empty' do
      it { is_expected.to be_nil }
    end

    context 'when the queue is not empty' do
      before { fill_queue pq, items }

      it 'returns the element with the top priority' do
        is_expected.to eq Priorityq::PriorityQueue::Element.new(100, 'first')
      end

      it 'does not remove the element with the top priority' do
        top = Priorityq::PriorityQueue::Element.new(100, 'first')
        is_expected.to eq top
        expect(pq.pop_element).to eq top
      end
    end
  end

  describe '#pop' do
    subject { pq.pop }

    context 'when the queue is empty' do
      it { is_expected.to be_nil }
    end

    context 'when the queue is not empty' do
      before { fill_queue pq, items }

      it 'returns the value with the top priority' do
        is_expected.to eq 'first'
      end

      it 'removes the value with the top priority' do
        pq.pop_element
        is_expected.to eq 'second'
      end
    end
  end

  describe '#pop_element' do
    subject { pq.pop_element }

    context 'when the queue is empty' do
      it { is_expected.to be_nil }
    end

    context 'when the queue is not empty' do
      before { fill_queue pq, items }

      it 'returns the element with the top priority' do
        is_expected.to eq Priorityq::PriorityQueue::Element.new(100, 'first')
      end

      it 'removes the element with the top priority' do
        pq.pop_element
        is_expected.to eq Priorityq::PriorityQueue::Element.new(50, 'second')
      end
    end
  end

  describe '#push' do
    before { fill_queue pq, items }

    context 'when adding a top priority item' do
      it 'adds the item to the top of the queue' do
        pq.push 110, 'top'
        expect(pq.peek).to eq 'top'
      end
    end

    context 'when adding a second priority item' do
      it 'adds the item after the top of the queue' do
        pq.push 90, 'not first'
        pq.pop
        expect(pq.pop).to eq 'not first'
      end
    end

    context 'when adding a last priority item' do
      it 'adds the item to the bottom of the queue' do
        pq.push 1, 'dead last'
        last = nil
        while (item = pq.pop)
          last = item
        end
        expect(last).to eq 'dead last'
      end
    end
  end
end
