#!/usr/bin/env ruby

require 'nokogiri'

#ELEMENTS_OF_INTEREST = %w(abstract accesstermwithrole address addressline archdesc archref bibliography bibref c change chronitem chronlist container controlaccess creation dao daodesc daogrp daoloc date defitem did dimensions dsc ead eadheader eadid editionstmt event eventgrp extent extptr extref filedesc formattednotewithhead head index indexentry item langmaterial langusage legalstatus list note notestmt num origination p physdesc physfacet physloc profiledesc publicationstmt repository revisiondesc title titleproper titlestmt unitdate unittitle)

class Parser < Nokogiri::XML::SAX::Document
  attr_reader :nesting_level_max
  
  def initialize(element_of_interest)
    @eoi = element_of_interest
    @nesting_level = 0
    @nesting_level_max = 0
  end
  
  def start_element(name, attrs = [])
    if name == @eoi
      @nesting_level = @nesting_level + 1
      @nesting_level_max = @nesting_level if @nesting_level > @nesting_level_max
    end
  end

  def characters(string)
    # Any characters between the start and end element expected as a string
  end

  def end_element(name)
    if name == @eoi
      @nesting_level = @nesting_level - 1
    end
  end
end

filepath = ARGV[0]
eoi      = ARGV[1]

parser = Parser.new(eoi)
Nokogiri::XML::SAX::Parser.new(parser).parse(File.open(ARGV[0]))
puts "#{parser.nesting_level_max},#{ARGV[0]}"
