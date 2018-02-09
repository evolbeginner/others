#! /bin/env ruby

require 'getoptlong'


########################################################
input = nil
output = nil
in_sep = "\t"
out_sep = "\t"
value_hash = Hash.new{|h,k|h[k]={}}
#biggest_line_size = 0
num_of_lines = nil


########################################################
opts = GetoptLong.new(
  ['-i', GetoptLong::REQUIRED_ARGUMENT],
  ['-o', GetoptLong::REQUIRED_ARGUMENT],
  ['--sep', GetoptLong::REQUIRED_ARGUMENT],
  ['--in_sep', GetoptLong::REQUIRED_ARGUMENT],
  ['--out_sep', GetoptLong::REQUIRED_ARGUMENT],
)

opts.each do |opt, value|
  case opt
    when '-i'
      input = value
    when '-o'
      output = value
    when '--sep'
      in_sep = value
      out_sep = value
    when '--in_sep'
      in_sep = value
    when '--out_sep'
      out_sep = value
  end
end


if input == "-"
  in_fh = STDIN
else
  in_fh = File.open(input, 'r')
end

########################################################
in_fh.each_line do |line|
  line.chomp!
  biggest_size = line.split.size
  line.split(in_sep).each_with_index do |ele, index|
    value_hash[index][$.-1] = ele
    '''
    if biggest_line_size < line.split(in_sep).size
      biggest_line_size = line.split(in_sep).size
    end
    '''
    num_of_lines = $.
  end
end


if output.nil?
  out_fh = STDOUT
else
  out_fh = File.open(output, 'w')
end
value_hash.each_pair do |k,v|
  0.upto(num_of_lines-1) do |i|
    v[i]=nil if not v.include?(i)
  end
  out_fh.puts v.keys.sort.map{|i|v[i]}.join(out_sep)
end


out_fh.close if not output.nil?


