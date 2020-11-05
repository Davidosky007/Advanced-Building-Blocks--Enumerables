# rubocop: disable Metrics/ModuleLength
# rubocop: disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    arr = self if instance_of?(Array)
    arr = to_a if instance_of?(Range)
    arr = flatten if instance_of?(Hash)

    counter = 0
    while counter < arr.length
      yield(arr[counter])
      counter += 1
    end
    arr
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    arr = self if instance_of?(Array)
    arr = to_a if instance_of?(Range)
    arr = flatten if instance_of?(Hash)
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
    if block_given?
      my_each { |value| return false if yield(value) == false }
      return true
    elsif args.nil?
      my_each { |v| return false if v.nil? || v == false }
    elsif !args.nil? && (args.is_a? Class)
      my_each { |v| return false if v.class != args }
    elsif !args.nil? && args.instance_of?(Regexp)
      my_each { |v| return false unless args.match(v) }
    else
      my_each { |v| return false if v != args }
    end
    true
  end

  def my_any?(arg = nil)
    if block_given?
      my_each { |value| return true if yield(value) }
      false
    elsif arg.nil?
      my_each { |v| return true if v.nil? || v == true }
    elsif !arg.nil? && (arg.is_a? Class)
      my_each { |v| return true if v.instance_of?(arg) }
    elsif !arg.nil? && arg.instance_of?(Regexp)
      my_each { |v| return true if arg.match(v) }
    else
      my_each { |v| return true if v == arg }
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
    if !block_given? && arg.nil?
      my_each { |i| return true if i }
      return false
    end

    if !block_given? && !arg.nil?

      if arg.is_a?(Class)
        my_each { |i| return false if i.instance_of?(arg) }
        return true
      end

      if arg.instance_of?(Regexp)
        my_each { |i| return false if arg.match(i) }
        return true
      end

      my_each { |i| return false if i == arg }
      return true
    end

    my_any? { |i| return false if yield(i) }
    true
  end

  def my_inject(num = nil, sym = nil)
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


# rubocop: enable Metrics/ModuleLength
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
arry.my_each { |n, _u| p n }
puts 'my_each'
hash = { 'v1' => 'Uche', 'v2' => 'Anya' }
hash.my_each { |u, _i| p u }
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
x.my_each do |i, _u|
  p i
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
puts 'my_inject'
p [2, 3, 4, 5].my_inject do |result, item|
  result + item
end
p [2, 3, 4, 5].my_inject(0) { |result, item| result + item**2 }
puts 'multiply_els'
p multiply_els([2, 4, 5])