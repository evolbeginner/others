#! /bin/env ruby

require "getoptlong"

#####################################################
infile = nil
percent = 0.05
field = 1
is_top = false
is_bottom = false

values = Array.new


#####################################################
opts = GetoptLong.new(
  ["-i", GetoptLong::REQUIRED_ARGUMENT],
  ["--top", GetoptLong::REQUIRED_ARGUMENT],
  ["--bottom", GetoptLong::REQUIRED_ARGUMENT],
  ["-f", "--field", GetoptLong::REQUIRED_ARGUMENT],
)


#####################################################
opts.each do |opt, value|
  case opt
    when "-i"
      infile = value
    when "--top"
      percent = value.to_f/100
      is_top = true
    when '--bottom'
      percent = value.to_f/100
      is_bottom = false
    when "-f", "--field"
      field = value.to_i
  end
end


#####################################################
File.open(infile, "r").each_line do |line|
  line.chomp!
  value = (line.split("\t"))[field-1]
  next if value !~ /\d/
  values << value.to_f
end

if is_top
  values.sort!.reverse!
else
  values.sort!
end
#p values

index = (values.size * percent).to_i
p values[index]


