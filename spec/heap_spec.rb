require 'spec_helper'

RSpec.describe Priorityq::Heap do
  let(:heap) { described_class.new }

  def check_max_order(heap, initial_max, expected_count)
    old_value = initial_max
    count = 0
    while (value = heap.pop)
      expect(value).to be <= old_value
      old_value = value
      count += 1
    end

    expect(count).to eq expected_count
  end

  def check_min_order(heap, initial_min, expected_count)
    old_value = initial_min
    count = 0
    while (value = heap.pop)
      expect(value).to be >= old_value
      old_value = value
      count += 1
    end

    expect(count).to eq expected_count
  end

  def fill_heap(heap, values)
    values.each { |value| heap.push value }
  end

  def heap_to_a(heap)
    [].tap do |results|
      while (value = heap.pop)
        results.push value
      end
    end
  end

  it 'exposes a push operation' do
    expect(heap).to respond_to :push
  end

  it 'exposes a pop operation' do
    expect(heap).to respond_to :pop
  end

  it 'exposes an empty? operation' do
    expect(heap).to respond_to :empty?
  end

  shared_examples_for 'a max heap' do
    context 'empty heap' do
      it 'returns nil if the heap is empty' do
        expect(heap.pop).to be_nil
      end
    end

    context 'heap with single value' do
      let(:value) { 42 }

      it 'returns the value if the heap has one value' do
        fill_heap heap, [value]

        expect(heap.pop).to eq value
        expect(heap.pop).to be_nil
      end
    end

    context 'heap with two values' do
      let(:max) { 100 }
      let(:min) { -100 }

      it 'pushed in order (max first), returns them in order (max first)' do
        fill_heap heap, [max, min]

        expect(heap.pop).to eq max
        expect(heap.pop).to eq min
        expect(heap.pop).to be_nil
      end

      it 'pushed out of order (min first), returns them in order (max first)' do
        fill_heap heap, [min, max]

        expect(heap.pop).to eq max
        expect(heap.pop).to eq min
        expect(heap.pop).to be_nil
      end
    end

    context 'heap with 10 integer values' do
      let(:max_first) { values.reverse }
      let(:min_first) { values }
      let(:values) { (1..10).to_a }

      it 'pushed in order (max first), returns them in order (max first)' do
        fill_heap heap, max_first

        expect(heap_to_a(heap)).to eq max_first
      end

      it 'pushed in reverse order (min first), ' \
        'returns them in order (max first)' do
        fill_heap heap, min_first

        expect(heap_to_a(heap)).to eq max_first
      end

      it 'pushed in random order, returns them in order (max first)' do
        fill_heap heap, values.shuffle

        expect(heap_to_a(heap)).to eq max_first
      end
    end

    it 'works with a large set of integer values' do
      fill_heap(heap, (1..10_000).map { rand(0..100_000) })

      check_max_order heap, 100_001, 10_000
    end

    it 'works with other comparables' do
      fill_heap(heap, (1..100).map { rand(1000..10_000).to_s })

      check_max_order heap, '9999', 100
    end
  end

  describe '.new' do
    it_behaves_like 'a max heap'
  end

  describe '.max' do
    let(:heap) { described_class.max }

    it_behaves_like 'a max heap'
  end

  describe '.min' do
    let(:heap) { described_class.min }

    context 'empty heap' do
      it 'returns nil if the heap is empty' do
        expect(heap.pop).to be_nil
      end
    end

    context 'heap with single value' do
      let(:value) { 42 }

      it 'returns the value if the heap has one value' do
        fill_heap heap, [value]

        expect(heap.pop).to eq value
        expect(heap.pop).to be_nil
      end
    end

    context 'heap with two values' do
      let(:max) { 100 }
      let(:min) { -100 }

      it 'pushed in order (min first), returns them in order (min first)' do
        fill_heap heap, [min, max]

        expect(heap.pop).to eq min
        expect(heap.pop).to eq max
        expect(heap.pop).to be_nil
      end

      it 'pushed out of order (max first), returns them in order (min first)' do
        fill_heap heap, [max, min]

        expect(heap.pop).to eq min
        expect(heap.pop).to eq max
        expect(heap.pop).to be_nil
      end
    end

    context 'heap with 10 integer values' do
      let(:max_first) { values.reverse }
      let(:min_first) { values }
      let(:values) { (1..10).to_a }

      it 'pushed in order (min first), returns them in order (min first)' do
        fill_heap heap, min_first

        expect(heap_to_a(heap)).to eq min_first
      end

      it 'pushed in reverse order (max first), ' \
         'returns them in order (min first)' do
        fill_heap heap, max_first

        expect(heap_to_a(heap)).to eq min_first
      end

      it 'pushed in random order, returns them in order (min first)' do
        fill_heap heap, values.shuffle

        expect(heap_to_a(heap)).to eq min_first
      end
    end

    it 'works with a large set of integer values' do
      fill_heap(heap, (1..10_000).map { rand(0..100_000) })

      check_min_order heap, -1, 10_000
    end

    it 'works with other comparables' do
      fill_heap(heap, (1..100).map { rand(1000..10_000).to_s })

      check_min_order heap, '0000', 100
    end
  end

  describe '#empty?' do
    subject { heap.empty? }

    context 'when the heap is empty' do
      it { is_expected.to be_truthy }
    end

    context 'when the heap has values' do
      before { heap.push 42 }

      it { is_expected.to be_falsey }
    end
  end
end
