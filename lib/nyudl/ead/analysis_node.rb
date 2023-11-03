require 'nokogiri'
require 'set'

module NYUDL
  module EAD
    class AnalysisNode
      attr_reader :name
      attr_accessor :depth
      class << self
        def header_string
          "name;needs_array?;max_depth;attributes;children"
        end

        def header_string_with_child_sequences
          "name;needs_array?;max_depth;attributes;children;child_sequences"
        end

        ##
        # Compresses an array of string elements
        # if consecutive elements are the same, they are converted
        # into the string "<element>+", e.g.,
        # ["c", "c", "c"] --> ["c+"]

        def compress_string_array(array, name = 'not set')
          return [] if array.empty?

          previous_element = ""
          multiple = false
          result = []
          suffix = ""

          array.each_with_index do |element, i|
            if i == 0
              previous_element = element
              next
            end

            if element == previous_element
              multiple = true
            else
              if multiple
                suffix = "+"
              else
                # not a run, so do not add "+"
                suffix = ""
              end
              result << previous_element + suffix
              # set up for the next loop
              multiple = false
              previous_element = element
            end
          end

          # last element
          if multiple
            suffix = "+"
          else
            # not a run, so do not add "+"
            suffix = ""
          end
          result << "#{previous_element}#{suffix}"
          # debug print...
          # $stderr.puts("name: #{name};result: #{result};array: #{array}") unless array == result
          result
        end
      end

      def initialize(name = '')
        @name  = name
        @depth = 0
        @needs_array = false
        @attributes  = Set.new
        @children    = Set.new
        @child_sequences = Set.new
      end

      def add_attributes(names)
        @attributes.merge names
      end

      def add_children(names)
        @children.merge names
      end

      def add_child_sequence(sequence)
        @child_sequences.add sequence
      end

      def merge_child_sequences(sequences)
        @child_sequences.merge sequences
      end

      def attributes
        @attributes.to_a.sort
      end

      def children
        @children.to_a.sort
      end

      def child_sequences
        @child_sequences.to_a.sort
      end

      def to_s
        "#{@name};#{needs_array?};#{depth};#{attributes.collect {|a| a.to_s}};#{children.collect {|c| c.to_s}}"
      end

      def with_sequences_to_s
        "#{@name};#{needs_array?};#{depth};#{attributes.collect {|a| a.to_s}};#{children.collect {|c| c.to_s}};#{child_sequences.collect {|cs| cs.to_s}}"
      end

      def increment_depth
        @depth += 1
      end

      def needs_array!
        @needs_array = true
      end

      def needs_array?
        @needs_array
      end

      # merge "other" AnalysisNode into this one
      # with special consideration of @depth and @needs_array
      def merge(other)
        # assert that AnalysisNodes have the same name
        raise ArgumentError.new "AnalysisNode names do not match." if other.name != name

        # merge attributes
        add_attributes(other.attributes)

        # merge children
        add_children(other.children)

        # merge child_sequences
        merge_child_sequences(other.child_sequences)

        # if the other AnalysisNode needs an array, then make sure
        # this one does, too
        needs_array! if other.needs_array?

        # if the other depth is greater than this one,
        # set this one to the higher number
        if other.depth > depth
          @depth = other.depth
        end
      end
    end
  end
end
