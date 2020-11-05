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

def given_my_all(value)

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
end




end