#!/usr/bin/env ruby

# For each element in an XML file, this script outputs the union of
# the element attributes and element children found for every instance
# of the element.

require_relative '../lib/nyudl/ead'

if ARGV.length != 1
  $stderr.puts "ERROR: incorrect argument count"
  $stderr.puts "usage: #{$0} <path to file containing paths of EADs to include in analysis>"
  $stderr.puts " e.g.: #{$0} file-list.txt"
  exit 1
end

paths_file = ARGV.shift

unless File.file?(paths_file)
  $stderr.puts "ERROR: file '#{paths_file}' does not exist"
  exit 1
end


grand_master_hash = {}
global_status = 0

File.foreach(paths_file) do | file |
  file.chomp!
  unless File.file?(file)
    $stderr.puts "ERROR: file '#{file}' does not exist"
    global_status = 1
    next
  end

  $stderr.puts "processing #{file}"
  doc  = Nokogiri::XML(File.open(file)) {|conf| conf.noblanks }
  hash = NYUDL::EAD::Analyzer.run(doc.root)

  hash.keys.each do |k|
    if grand_master_hash[k].nil?
      grand_master_hash[k] = hash[k]
    else
      grand_master_hash[k].merge(hash[k])
    end
  end
end  

puts NYUDL::EAD::AnalysisNode.header_string_with_child_sequences
grand_master_hash.keys.sort.each { |k| puts grand_master_hash[k].with_sequences_to_s }

exit global_status

