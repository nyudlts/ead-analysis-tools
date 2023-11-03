#!/usr/bin/env ruby

require 'nokogiri'

#ELEMENTS_OF_INTEREST = %w(abstract accesstermwithrole address addressline archdesc archref bibliography bibref c change chronitem chronlist container controlaccess creation dao daodesc daogrp daoloc date defitem did dimensions dsc ead eadheader eadid editionstmt event eventgrp extent extptr extref filedesc formattednotewithhead head index indexentry item langmaterial langusage legalstatus list note notestmt num origination p physdesc physfacet physloc profiledesc publicationstmt repository revisiondesc title titleproper titlestmt unitdate unittitle)

ELEMENTS_OF_INTEREST = %w(c)


# class Parser < Nokogiri::XML::SAX::Document
#   def initialize
#     @in_eoi = 0
#   end
#   def start_element(name, attrs = [])
#     if ELEMENTS_OF_INTEREST.include?(name)
#       @in_eoi = @in_eoi + 1
#     end
#     if @in_eoi > 0 
#       printf("<#{name}>")
#     end
#   end

#   def characters(string)
#     # Any characters between the start and end element expected as a string
#   end

#   def end_element(name)
#     if ELEMENTS_OF_INTEREST.include?(name)
#       @in_eoi = @in_eoi - 1
#       puts("</#{name}>") if @in_eoi == 0
#     else
#       printf("</#{name}>") if @in_eoi > 0
#     end
#   end
# end


# Nokogiri::XML::SAX::Parser.new(Parser.new).parse(File.open(ARGV[0]))

class Parser < Nokogiri::XML::SAX::Document
  attr_reader :nesting_level_max
  
  def initialize
    @nesting_level = 0
    @nesting_level_max = 0
  end
  def start_element(name, attrs = [])
    if ELEMENTS_OF_INTEREST.include?(name)
#      printf("<#{name}:#{@nesting_level}>")
      @nesting_level = @nesting_level + 1
      @nesting_level_max = @nesting_level if @nesting_level > @nesting_level_max
    end
  end

  def characters(string)
    # Any characters between the start and end element expected as a string
  end

  def end_element(name)
    if ELEMENTS_OF_INTEREST.include?(name)
      @nesting_level = @nesting_level - 1
      # if @nesting_level == 0
      #   puts("</#{name}:#{@nesting_level}>") 
      # else
      #   printf("</#{name}:#{@nesting_level}>") 
      # end
    end
  end
end


parser = Parser.new
Nokogiri::XML::SAX::Parser.new(parser).parse(File.open(ARGV[0]))
puts "#{parser.nesting_level_max},#{ARGV[0]}"
