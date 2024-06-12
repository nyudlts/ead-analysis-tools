#!/usr/bin/env ruby

# For each dao element in an XML file, this script outputs the set of
# role attribute values across all daos.
# e.g.,
# <dao xlink:actuate="onLoad"
#   xlink:href="https://aeon.library.nyu.edu/Logon?Action=10&amp;Form=31&amp;Value=http://dlib.nyu.edu/findingaids/ead/fales/mss_601.xml&amp;view=xml"
#   xlink:role="electronic-records-service"
#   xlink:show="new"
#   xlink:title="General Information on VoCA Talks Series"
#   xlink:type="simple"
#>

require 'set'
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


grand_master_set = Set.new()
global_status = 0
global_errors = []

File.foreach(paths_file) do | file |
  file.chomp!
  unless File.file?(file)
    $stderr.puts "ERROR: file '#{file}' does not exist"
    global_status = 1
    next
  end

  $stderr.puts "processing #{file}"
  file_handle = File.open(file)
  options = {
    element_of_interest: 'field',
    attribute_of_interest: 'name',
    filename: file
  }
               
  parser = NYUDL::EAD::ElementAttributeAnalyzer.new(options)
  Nokogiri::XML::SAX::Parser.new(parser).parse(file_handle)
  grand_master_set.merge(parser.attribute_values)

  unless parser.errors.length == 0
    global_status = 1 
    global_errors << "file: #{file} has #{parser.errors.length} error(s)"
    global_errors << parser.errors
  end
end  

puts "ROLES:"
puts grand_master_set.sort

puts ""
puts "ERRORS:"
global_errors.each {|e| puts e}

exit global_status
