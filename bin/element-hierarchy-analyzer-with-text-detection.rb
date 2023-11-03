#!/usr/bin/env ruby

require 'nokogiri'

#ELEMENTS_OF_INTEREST = %w(abstract accesstermwithrole address addressline archdesc archref bibliography bibref c change chronitem chronlist container controlaccess creation dao daodesc daogrp daoloc date defitem did dimensions dsc ead eadheader eadid editionstmt event eventgrp extent extptr extref filedesc formattednotewithhead head index indexentry item langmaterial langusage legalstatus list note notestmt num origination p physdesc physfacet physloc profiledesc publicationstmt repository revisiondesc title titleproper titlestmt unitdate unittitle)

# This technique borrowed from: https://www.viget.com/articles/parsing-big-xml-files-with-nokogiri/
class Parser < Nokogiri::XML::SAX::Document
  def initialize(filename, element_of_interest)
    @filename = filename
    @eoi = element_of_interest
    @in_eoi = 0
  end
  def start_element(name, attrs = [])
    if name == @eoi
      @in_eoi = @in_eoi + 1
    end
    if @in_eoi > 0 
      printf("<#{name}>")
    end
  end

  def characters(string)
    # Any characters between the start and end element expected as a string
    printf 'TEXT' if @in_eoi > 0 && string.strip != ""
  end

  def end_element(name)
    if name == @eoi
      @in_eoi = @in_eoi - 1
      puts("</#{name}>,#{@filename}") if @in_eoi == 0
    else
      printf("</#{name}>") if @in_eoi > 0
    end
  end
end


if ARGV.length != 2
  puts "ERROR: incorrect number of arguments"
  puts "usage: #{$0} <filepath> <element of interest>"
  puts " e.g.: #{$0} fixtures/mc_104.xml bioghist"
  exit 1
end

filepath = ARGV[0]
eoi      = ARGV[1]

parser = Parser.new(filepath, eoi)
Nokogiri::XML::SAX::Parser.new(parser).parse(File.open(filepath))
