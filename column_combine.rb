#! /bin/env ruby


require 'getoptlong'


###########################################################
def read_input(input, index, final, final2input, fields)
  File.open(input,'r').each_line do |line|
    line.rstrip!
    line_arr = line.split("\t")
    if ! fields.empty?
      line = fields.map{|i|line_arr[i-1]}.join("\t")
    end
    final[index].push(line)
    final2input[index] = File.basename(input)
  end
end


###########################################################
inputs = Array.new
indir = nil
fields = Array.new
final = Hash.new{|h,k|h[k]=[]}
final2input = Hash.new
isOutputTitle = false
de_overlap_target_field = nil
de_overlap_fields = Array.new
suffix = nil


###########################################################
opts = GetoptLong.new(
  ['-i', GetoptLong::REQUIRED_ARGUMENT],
  ['--indir', GetoptLong::REQUIRED_ARGUMENT],
  ['-f', GetoptLong::REQUIRED_ARGUMENT],
  ['--title', GetoptLong::NO_ARGUMENT],
  ['--de_overlap', GetoptLong::REQUIRED_ARGUMENT],
  ['--suffix', GetoptLong::REQUIRED_ARGUMENT],
)

opts.each do |opt,value|
  case opt
    when '-i'
      value.split(",").each do |i|
        inputs.push i
      end
    when '--indir'
      indir = value
    when '-f'
      value.split(",").each do |i|
        fields << i.to_i
      end
    when '--title'
      isOutputTitle = true
    when '--de_overlap'
      de_overlap_target_field = value.split('-')[0].to_i
      de_overlap_fields = value.split('-')[1].split(',').map{|i|i.to_i}
    when '--suffix'
      suffix = value
  end
end


###########################################################
if not indir.nil?
  Dir.foreach(indir).each do |file|
    next if file =~ /^\./
    next if file !~ /\.#{suffix}$/ if not suffix.nil?
    inputs << File.join(indir, file)
  end
end


inputs.each_with_index do |input, index|
  read_input(input,index,final,final2input,fields)
end

max = final.values.map{|x|x.size}.max

puts final.keys.map{|i|final2input[i]}.join("\t") if isOutputTitle
0.upto(max-1) do |i|
  tmp_list = Array.new
  final.each_pair do |k,v|
    if final[k].size >= i+1
      tmp_list.push v[i]
    else
      tmp_list.push ''
    end
  end
  puts tmp_list.join("\t")
end


