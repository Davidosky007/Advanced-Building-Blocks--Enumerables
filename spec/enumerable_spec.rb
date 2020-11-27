require '../main'

describe Enumerable do
  let(:new_array) { [] }
  let(:num_arr) { [1, 2, 3, 4, 5, 6, 7, 8] }
  let(:new_hash) { { 'v': 1, 'w': 2, 'x': 3, 'y': 4, 'z': 5 } }
  let(:new_range) { (1..9) }
  let(:str_arr) { %w[d a v i d o s k y] }
  let(:new_str) { %(Hello) }

  describe '#my_each' do
    it 'returns the the same result the each method would when called on the num_arr' do
      test_arr = []
      num_arr.my_each { |i| test_arr << i * 2 }
      expect(test_arr).to eql([2, 4, 6, 8, 10, 12, 14, 16])
    end

    it 'returns the same result the each method would when called on the str_arr' do
      test_arr = []
      str_arr.my_each { |i| test_arr << i }
      expect(test_arr).to eql(%w[d a v i d o s k y])
    end

    it 'returns the same result the each method would when called on new_range' do
      test_arr = []
      new_range.my_each { |i| test_arr << i * 2 }
      expect(test_arr).to eql([2, 4, 6, 8, 10, 12, 14, 16, 18])
    end

    it 'returns the same result the each method would when called on new_hash' do
      test_arr = []
      new_hash.my_each { |key, value| test_arr << "#{key}: #{value}" }
      expect(test_arr).to eql(['v: 1', 'w: 2', 'x: 3', 'y: 4', 'z: 5'])
    end

    it 'returns the same result the each method would get when called on new_str without a block' do
      expect { new_str.my_each }.to raise_error(NoMethodError)
    end

    it 'returns the same result the each method would when called on num_arr without a block' do
      expect(num_arr.my_each).to be_a(Enumerator)
    end
  end

  describe '#my_each_with_index' do
    it 'executes the block for each element and the index of the array its called on' do
      test_hash = []
      new_hash.my_each_with_index { |item, index| test_hash << "#{index}: #{item}" }
      expect(test_hash).to eql(['0: [:v, 1]', '1: [:w, 2]', '2: [:x, 3]', '3: [:y, 4]', '4: [:z, 5]'])
    end

    it 'executes the block for each elements of the new_range' do
      test_arr = []
      new_range.my_each_with_index { |item, index| test_arr << (item + index) }
      expect(test_arr).to eql([1, 3, 5, 7, 9, 11, 13, 15, 17])
    end

    it 'returns the same result the each_with_index method would when called on str_arr' do
      test_arr = []
      str_arr.my_each_with_index { |item, index| test_arr << "#{index}: #{item}" }
      expect(test_arr).to eql(['0: d', '1: a', '2: v', '3: i', '4: d', '5: o', '6: s', '7: k', '8: y'])
    end

    it 'returns the same result the each_with_index method would when called on str_arr' do
      test_arr = []
      num_arr.my_each_with_index { |item, index| test_arr << "#{index}: #{item}" }
      expect(test_arr).to eql(['0: 1', '1: 2', '2: 3', '3: 4', '4: 5', '5: 6', '6: 7', '7: 8'])
    end

    it 'returns the same result as each_with_index method to string without a block' do
      expect(str_arr.my_each_with_index).to be_a(Enumerator)
    end

    it 'returns the same result as each_with_index method to num_arr without block' do
      expect(num_arr.my_each_with_index).to be_a(Enumerator)
    end
  end

  describe '#my_select' do
    it 'returns elements of the array that meets the condition in a given block' do
      test_arr = []
      num_arr.my_select { |item| test_arr << item.even? }
      expect(test_arr).to eql([false, true, false, true, false, true, false, true])
    end

    it 'returns Enumerator if a block is given' do
      expect(num_arr.my_select).to be_a(Enumerator)
    end
  end

  describe '#my_all?' do
    it 'returns true if condition in block is true for all the elements in the array' do
      result = num_arr.my_any?(&:even?)
      expect(result).to eql(true)
    end

    it 'returns the same result as all? method to str_array' do
      result = str_arr.my_all? { |item| item.is_a?(String) }
      expect(result).to eql(true)
    end

    it 'returns the same result as all? method to range' do
      result = new_range.my_all?(&:even?)
      expect(result).to eql(false)
    end

    it 'returns the same result as all? method to hash' do
      result = new_hash.my_each { |_key, value| value < 3 }
      expect(result).to eql([[:v, 1], [:w, 2], [:x, 3], [:y, 4], [:z, 5]])
    end

    it 'returns true if the array is empty' do
      expect([].my_all?).to eql(true)
    end
    it 'returns the same result as all? method to empty_array without block' do
      expect(new_array.my_all?).to eql(true)
    end

    describe 'when no parameter and no block given' do
      it 'returns false if any one of the element is not nil/false in array' do
        expect([nil, false, true].my_any?).to eql(false)
      end

      it 'returns false if any all of the element is nil/false in array' do
        expect([nil, false, nil].my_any?).to eql(false)
      end
    end

    describe '#my_any' do
      it 'returns the same result as any? method to num_array' do
        result = num_arr.my_any?(&:even?)
        expect(result).to eql(true)
      end

      it 'returns the same result as any? method to str_array' do
        result = str_arr.my_any? { |item| item.is_a?(String) }
        expect(result).to eql(true)
      end

      it 'returns the same result as any? method to range' do
        result = new_range.my_any?(&:even?)
        expect(result).to eql(true)
      end

      it 'returns the same result as any? method to hash' do
        result = new_hash.my_any? { |_key, value| value < 3 }
        expect(result).to eql(true)
      end

      it 'returns the same result as any? method to empty_array without block' do
        expect(new_array.my_any?).to eql(false)
      end
    end

    describe '#my_none?' do
      it 'returns the same result as none? method to num_array' do
        result = num_arr.my_none?(&:even?)
        expect(result).to eql(false)
      end

      it 'returns the same result as none? method to str_array' do
        result = str_arr.my_none? { |item| item.is_a?(String) }
        expect(result).to eql(false)
      end

      it 'returns the same result as none? method to range' do
        result = new_range.my_none?(&:even?)
        expect(result).to eql(false)
      end

      it 'returns the same result as none? method to hash' do
        result = new_hash.my_none? { |_key, value| value < 3 }
        expect(result).to eql(false)
      end

      it 'returns the same result as none? method to string without block' do
        expect { new_str.my_none? }.to raise_error(NoMethodError)
      end

      it 'returns the same result as none? method to empty_array without block' do
        expect(new_array.my_none?).to eql(true)
      end
    end
  end

  describe '#my_count' do
    it 'returns the same result as count method to num_array without block' do
      result = num_arr.my_count
      expect(result).to eql(8)
    end

    it 'returns the same result as count method to str_array without block' do
      result = str_arr.my_count
      expect(result).to eql(9)
    end

    it 'returns the same result as count method to range without block' do
      result = new_range.my_count
      expect(result).to eql(9)
    end

    it 'returns the same result as count method to hash without block' do
      result = new_hash.my_count
      expect(result).to eql(5)
    end

    it 'returns the same result as count method to num_array with block' do
      result = num_arr.my_count(&:even?)
      expect(result).to eql(4)
    end

    it 'returns the same result as count method to str_array with block' do
      result = str_arr.my_count { |item| item.is_a?(String) }
      expect(result).to eql(9)
    end

    it 'returns the same result as count method to str_array with item' do
      result = str_arr.my_count('d')
      expect(result).to eql(2)
    end

    it 'returns the same result as count method to range with item' do
      result = new_range.my_count(3)
      expect(result).to eql(1)
    end
  end

  describe '#my_map' do
    it 'returns the same result as map method to num_array' do
      result = num_arr.my_map { |i| i * 2 }
      expect(result).to eql [2, 4, 6, 8, 10, 12, 14, 16]
    end

    it 'returns the same result as map method to str_array' do
      result = str_arr.my_map { |item| item }
      expect(result).to eql(%w[d a v i d o s k y])
    end

    it 'returns the same result as map method to hash' do
      result = new_hash.my_map { |key, value| "#{key} is #{value}" }
      expect(result).to eql(['v is 1', 'w is 2', 'x is 3', 'y is 4', 'z is 5'])
    end

    it 'returns the same result as map method to range' do
      result = new_range.my_map { |i| i * 2 }
      expect(result).to eql [2, 4, 6, 8, 10, 12, 14, 16, 18]
    end

    it 'returns the same result as map method to num_array without block' do
      expect(num_arr.my_map).to be_a(Enumerator)
    end

    it 'returns the same result as map method to string without block' do
      expect { new_str.my_map }.to raise_error(NoMethodError)
    end
  end

  describe '#my_inject' do
    it 'returns the same result as inject method to range with (initial, symbol)' do
      result = new_range.my_inject(3, :*)
      expect(result).to eql(1_088_640)
    end

    it 'returns the same result as inject method to range with (symbol)' do
      result = new_range.my_inject(:*)
      expect(result).to eql(362_880)
    end

    it 'returns the same result as inject method to range with (initial) with block' do
      result = new_range.my_inject(5) { |accum, i| accum * i }
      expect(result).to eql(1_814_400)
    end

    it 'returns the same result as inject method to range with block' do
      result = new_range.my_inject { |accum, i| accum * i }
      expect(result).to eql(362_880)
    end

    it 'returns the same result as inject method to str_array with block' do
      result = str_arr.my_inject { |accum, word| accum.size > word.size ? accum : word }
      expect(result).to eql('y')
    end

    it 'returns the same result as inject method to string without block and item' do
      expect { new_str.my_inject }.to raise_error(NoMethodError)
    end
  end

  describe '#multiply_els' do
    it 'returns the result from my_inject correctly when given num_array' do
      expect(multiply_els(num_arr)).to eql(40_320)
    end
  end
end
