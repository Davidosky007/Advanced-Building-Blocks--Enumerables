# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

require_relative 'test'

module Enumerable
  def my_each
    arr = *self
    return enum_for(:my_each) unless block_given?

    counter = 0
    while counter < arr.length
      yield(arr[counter])
      counter += 1
    end
    arr
  end

  def my_each_with_index
    arr = *self
    return enum_for(:my_each) unless block_given?

    counter = 0
    while counter < arr.length
      yield(arr[counter], counter)
      counter += 1
    end
    arr
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    new_arr = []
    my_each { |value| new_arr << value if yield(value) }
    new_arr
  end

  def my_all?(args = nil)
    value = *self
    return Test.given_my_all(value, args[0]) unless args.nil?

    if block_given?
      value.my_each { |item| return false unless yield(item) }
    else
      value.my_each { |item| return false unless item }
    end
    true
  end

  def my_any?(args = nil)
    value = *self
    return Test.given_my_any(value, args[0]) unless args.nil?

    if block_given?
      value.my_each { |item| return true if yield(item) }
    end
    false
  end

  def my_count(numbers = nil, &block)
    array = instance_of?(Array) ? self : to_a
    return array.length unless block_given? || numbers
    return array.my_select { |value| value == numbers }.length if numbers

    array.my_select(&block).length
  end

  def my_map(proc = nil)
    return to_enum unless block_given? || proc

    new_arr = []
    if proc
      my_each { |value| new_arr << proc.call(value) }
    else
      my_each { |value| new_arr << yield(value) }
    end
    new_arr
  end

  def my_none?(arg = nil)
    value = *self
    return Test.given_my_none(value, arg[0]) unless arg.nil?

    if block_given?
      value.my_each { |item| return false if yield(item) }

    end
    true
  end

  def my_inject(num = nil, sym = nil)
    raise LocalJumpError, 'no block given' unless block_given? || num.size.positive?

    if block_given?
      accumulator = num
      my_each do |item|
        accumulator = accumulator.nil? ? item : yield(accumulator, item)
      end
      accumulator
    elsif !num.nil? && (num.is_a?(Symbol) || num.is_a?(String))
      accumulator = nil
      my_each do |item|
        accumulator = accumulator.nil? ? item : accumulator.send(num, item)
      end
      accumulator
    elsif !sym.nil? && (sym.is_a?(Symbol) || sym.is_a?(String))
      accumulator = num
      my_each do |item|
        accumulator = accumulator.nil? ? item : accumulator.send(sym, item)
      end
      accumulator
    end
  end
end

# rubocop: enable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
def multiply_els(arr)
  arr.my_inject { |memo, vals| memo * vals }
end

# TEST AREA
puts 'my_each_with_index'
qq = [7, 8, 3, 1, 4, 8]
qq.my_each_with_index do |_bv, ii|
  p ii
end
puts 'my_each'
arry = [9, 2, 0, 3]
arry.my_each { |n| p n }
puts 'my_each_with_index'
hash = { 'v1' => 'Uche', 'v2' => 'Anya' }
hash.my_each_with_index { |u, _i| p u }
puts 'my_select'
p [3, 5, 2, 1, 5, 6, 7].my_select do |n|
  n > 5
end
puts 'my_each'
x = [1, 2, 3, 4, 5, 7]
x.my_each do |i|
  if i.even?
    p "this is the even numbers #{i}"
  else
    p "this is the odd numbers #{i}"
  end
end
puts 'select'
x = { 'v' => 'my name', 'g' => 'okoro dev' }
x.my_each_with_index do |_i, u|
  p u
end
puts 'my_all'
p [1, 2, 3, 4].my_all? do |n|
  n < 5
end
puts 'my_any'
p [2, 3, 4, 5, 6].my_any? do |n|
  n < 5
end
puts 'my_count'
p [2, 3, 56, 6, 3, 2, 9, 1, 2, 3, 3, 5].my_count(3)
puts 'my_map'
p([2, 5, 7, 4, 2].my_map { |i| i + 8 })
puts 'my_none'
p [2, 3, 4, 5, 6].my_none? do |n|
  n > 10
end
puts 'my_inject Array'
p [5, 5, 7, 8].my_inject(1) { |result, item| result * item }

p [2, 3, 4, 5].my_inject(1) { |result, item| result + item**2 }

puts 'multiply_els'
p multiply_els([2, 4, 5])
