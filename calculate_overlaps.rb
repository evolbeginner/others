#! /bin/env ruby

require 'getoptlong'

regexp_for_gene=nil
list1=Array.new
list2=Array.new
list_ele=Hash.new{|h,k|h[k]={}}
sep1, sep2 = "\t", "\t"
field1, field2 = 1, 1
is_report = true
is_content = false
content_indexes = nil
show_item = nil
out_sep = "\n"


#######################################################################
def read_lists(lists=[], fields=[1,1], seps=["\t","\t"], regexp_for_gene=nil)
  list_ele = Hash.new{|h,k|h[k]=Hash.new()}
  all_contents = Hash.new{|h,k|h[k]=Hash.new{|h,k|h[k]=[]}}
  raise "lists cannot be empty" if lists.empty?
  lists.each_with_index do |list,index|
    list.each do |list_file|
      fh = list_file != '-' ? File.open(list_file,'r') : STDIN
      fh.each_line do |line|
        line.chomp!
        ele=line.split(seps[index])[fields[index]-1]
        (ele=$1 if line=~/(#{regexp_for_gene})/) if ! regexp_for_gene.nil?
        list_ele[index][ele]=1
        all_contents[index][ele] << line
      end
      fh.close
    end
  end
  return ([list_ele, all_contents])
end


#######################################################################
opts = GetoptLong.new(
  ['--i1', '--list1', GetoptLong::REQUIRED_ARGUMENT],
  ['--i2', '--list2', GetoptLong::REQUIRED_ARGUMENT],
  ['--sep', GetoptLong::REQUIRED_ARGUMENT],
  ['--sep1', GetoptLong::REQUIRED_ARGUMENT],
  ['--sep2', GetoptLong::REQUIRED_ARGUMENT],
  ['--f1', GetoptLong::REQUIRED_ARGUMENT],
  ['--f2', GetoptLong::REQUIRED_ARGUMENT],
  ['--regexp_for_gene', GetoptLong::REQUIRED_ARGUMENT],
  ['--show', GetoptLong::REQUIRED_ARGUMENT],
  ['--no_report', GetoptLong::NO_ARGUMENT],
  ['--content', '--all_content', GetoptLong::REQUIRED_ARGUMENT],
  ['--out_sep', GetoptLong::REQUIRED_ARGUMENT],
)

opts.each do |opt,value|
  case opt
    when '--i1', '--list1'
      list1.push value
    when '--i2', '--list2'
      list2.push value
    when "--sep"
      sep1, sep2 = value, value
    when '--sep1'
      sep1=value
    when '--sep2'
      sep2=value
    when '--f1'
      field1=value.to_i
    when '--f2'
      field2=value.to_i
    when '--regexp_for_gene'
      regexp_for_gene=value
    when '--show'
      show_item = value
    when '--no_report'
      is_report = false
    when '--content', '--all_content'
      is_content = true
      content_indexes = value.split(',').map{|i|i.to_i-1}
    when '--out_sep'
      out_sep = value
  end
end


#######################################################################
list_ele, all_contents = read_lists([list1,list2], [field1, field2], [sep1,sep2], regexp_for_gene)

eles_shared_by_0_and_1 = list_ele[0].keys & list_ele[1].keys

if is_report
  list_ele.each_with_index do |ele,index|
    a=[index, eles_shared_by_0_and_1.size, list_ele[index].keys.size].map{ |i| i.to_s }
    out=a.join("\t")
    print out, "\t", a[1].to_f/a[2].to_f, "\n"
  end
  puts
end

if show_item
  if show_item == "1"
    out_list = list_ele[0].keys - eles_shared_by_0_and_1
  elsif show_item == "2"
    out_list = list_ele[1].keys - eles_shared_by_0_and_1
  elsif show_item == "12" or show_item == "overlap" or show_item == "intersect"
    out_list = eles_shared_by_0_and_1
  elsif show_item == "all" or show_item == "union"
    out_list = [list_ele[0].keys, list_ele[1].keys].flatten.uniq
  elsif show_item =~ /comple/i
    out_list = (list_ele1).join(out_sep)
    puts
    puts (list_ele2).join(out_sep)
    exit
  end

  if not is_content
    puts out_list.join(out_sep)
  else
    out_list.each do |i|
      puts content_indexes.map{|j|all_contents[j][i]}.join(out_sep)
    end    
    #puts out_list.map{|i|all_contents[content_index][i]}.join(out_sep)
  end
end


