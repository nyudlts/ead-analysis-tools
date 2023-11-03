#!/usr/bin/env ruby

# For each element in an XML file, this script outputs the union of
# the element attributes and element children found for every instance
# of the element.

require_relative '../lib/nyudl/ead'

if ARGV.length != 1
  $stderr.puts "ERROR: incorrect argument count"
  $stderr.puts "usage: #{$0} <path to file>"
  $stderr.puts " e.g.: #{$0} test/fixtures/mc_104.xml"
  exit 1
end

file = ARGV.shift

unless File.file?(file)
  $stderr.puts "ERROR: file '#{file}' does not exist"
  exit 1
end

doc  = Nokogiri::XML(File.open(file)) {|conf| conf.noblanks }
hash = NYUDL::EAD::Analyzer.run(doc.root)

puts NYUDL::EAD::AnalysisNode.header_string
hash.keys.sort.each {|k| puts hash[k].to_s}

