module Test
def given_my_each(arr)

case arr

when array
  arr = self if instance_of?(Array)

when range
  arr = to_a if instance_of?(Range)
when Hash
    arr = flatten if instance_of?(Hash)
end
end

def given_my_all(args = nil)

  case value
  when args == nil
    my_each { |v| return false if v.nil? || v == false }
  when args != nil && (args.is_a? Class)
   my_each { |v| return false if v.class != args }
  when !args.nil? && args.instance_of?(Regexp)
 my_each { |v| return false unless args.match(v) }
  else
     my_each { |v| return false if v != args }

  end 
  true
end

def given_my_any(args = nil)
  case value
  when args == nil
     my_each { |v| return true if v.nil? || v == true }
  when !arg.nil? && (arg.is_a? Class)
     my_each { |v| return true if v.instance_of?(arg) }
  when !arg.nil? && arg.instance_of?(Regexp)
     my_each { |v| return true if arg.match(v) }
  else
     my_each { |v| return true if v == arg }
  end
false
end

def given_my_none(arg = nil)
case value
when !block_given? && arg.nil?
   my_each { |i| return true if i }
      return false
when !block_given? && !arg.nil?
  arg.instance_of?(Regexp)
        my_each { |i| return false if arg.match(i) }
        return true
    my_each { |i| return false if i == arg }
      return true
      arg.is_a?(Class)
        my_each { |i| return false if i.instance_of?(arg) }
        return true
     my_any? { |i| return false if yield(i) }
    true
end
end

 def self.my_given_for_inject(arr, arg)
    if arg.size == 2
      result = arg[0]
      symbol = arg[1]
    elsif arg.size == 1
      symbol = arg[0]
    end
    arr.size.times { |index| result = result ? result.send(symbol, arr[index]) : arr[index] }
    result
  end



end