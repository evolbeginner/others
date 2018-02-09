#! /bin/env ruby

require "getoptlong"


######################################################
infile = nil
sep = "\t"

values = Array.new


######################################################
opts = GetoptLong.new(
  ['-i', GetoptLong::REQUIRED_ARGUMENT],
  ['--sep', GetoptLong::REQUIRED_ARGUMENT],
)

opts.each do |opt, value|
  case opt
    when '-i'
      infile = value
    when '--sep'
      sep = value
  end
end


######################################################
File.open(infile, 'r').each_line do |line|
  line.chomp!
  line_arr = line.split(sep)
  values << line_arr.values_at(1,0)
end


values.each do |a|
  puts a.join(sep)
end


