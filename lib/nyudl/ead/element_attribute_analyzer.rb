require 'nokogiri'
require 'set'

module NYUDL
  module EAD
    class ElementAttributeAnalyzer < Nokogiri::XML::SAX::Document
      attr_reader :attribute_values, :errors
      
      def initialize(options)
        @eoi = options[:element_of_interest]
        @aoi = options[:attribute_of_interest]
        @filename = options[:filename]
        @attribute_values = Set.new()
        @errors = []
      end
  
      def start_element(name, attrs = [])
        attrs = attrs.to_h
        if name == @eoi
          value = attrs[@aoi]
          if value.nil?
            @errors << "#{name}@#{@aoi} value is nil in file: #{@filename}"
          else
            @attribute_values.add(value)
          end
        end
      end

      def characters(string)
        # Any characters between the start and end element expected as a string
      end

      def end_element(name)
      end
    end
  end
end

