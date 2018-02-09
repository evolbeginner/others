#! ruby

require 'getoptlong'


######################################################################
list_file = nil
num_of_elements = nil

def read_list(list_file)
  a=Array.new
  File.open(list_file,'r').each_line do |line|
    line.chomp!
    a.push line
  end
  return(a)
end

def rand_split(array, num_of_elements=2)
  list = []
  l = Array.new(array).shuffle
  list << (l.pop num_of_elements )  while l.count > 0 
  return(list)
end


######################################################################
opts = GetoptLong.new(
  ['--list', '--list_file', GetoptLong::REQUIRED_ARGUMENT],
  ['--num_of_elements', GetoptLong::REQUIRED_ARGUMENT],
)

opts.each do |opt, value|
  case opt
    when '--list', '--list_file'
      list_file=value
    when '--num_of_elements'
      num_of_elements=value.to_i
  end 
end


######################################################################
list = read_list(list_file)

rand_split(list,num_of_elements).each do |array|
  p array
  sleep 1
end


