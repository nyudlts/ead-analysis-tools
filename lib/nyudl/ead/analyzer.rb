require 'nokogiri'
require 'set'

module NYUDL
  module EAD
    class Analyzer
      class << self
        def recurse(element, hash)
          name = element.name

          # if there isn't an already a node with this element name,
          # then create one AND ADD IT TO THE HASH BEFORE RECURSING,
          # otherwise objects will continue to be created during the
          # recursion.

          analysis_node = hash[name]
          if analysis_node.nil?
            analysis_node = NYUDL::EAD::AnalysisNode.new(name)
            hash[name] = analysis_node
          end

          analysis_node.add_attributes(element.attributes.keys)
          child_names = element.children.collect {|c| c.name}
          analysis_node.add_children(child_names.uniq)
          analysis_node.add_child_sequence(NYUDL::EAD::AnalysisNode.compress_string_array(child_names, name).join('_'))
          update_nesting_level(element, analysis_node)
          analysis_node.needs_array!    if has_matching_sibling?(element)

          element.children.each {|c| recurse(c, hash)}
        end

        def update_nesting_level(element, analysis_node)
          nesting_level = find_nesting_level(element)
          if nesting_level > analysis_node.depth
            analysis_node.depth = nesting_level
          end
        end

        def find_nesting_level(element)
          name = element.name
          nesting_level = 0
          while element.parent.name == name
            nesting_level += 1
            element = element.parent
          end
          nesting_level
        end

        def has_matching_sibling?(element)
          sibling = element.next_element
          until sibling.nil?
            return true if sibling.name == element.name
            sibling = sibling.next_element
          end
          return false
        end

        def run(element)
          hash = {}
          recurse(element, hash)
          hash
        end
      end
    end
  end
end
