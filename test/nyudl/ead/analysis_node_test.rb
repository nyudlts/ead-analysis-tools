require_relative '../../test_helper'

class NYUDL::EAD::AnalysisNodeTest < Minitest::Test

  def test_empty_name
    expected = ''
    sut = NYUDL::EAD::AnalysisNode.new()
    actual = sut.name
    assert_equal(expected, actual, "expected: '#{expected}' actual: '#{actual}'")
  end


  def test_populated_name
    expected = 'foo'
    sut = NYUDL::EAD::AnalysisNode.new('foo')
    actual = sut.name
    assert_equal(expected, actual, "expected: '#{expected}' actual: '#{actual}'")
  end


  def test_attributes_methods
    expected = ["a1", "a2", "a3"]
    sut = NYUDL::EAD::AnalysisNode.new('foo')
    sut.add_attributes(%w(a1 a3 a2))
    actual = sut.attributes
    assert_equal(expected, actual, "expected: '#{expected}' actual: '#{actual}'")
  end


  def test_children_methods
    expected = ["c1", "c2", "c3"]
    sut = NYUDL::EAD::AnalysisNode.new('foo')
    sut.add_children(%w(c1 c3 c2))
    actual = sut.children
    assert_equal(expected, actual, "expected: '#{expected}' actual: '#{actual}'")
  end

  def test_child_sequences_methods
    expected = ["c1_c2_c3", "d1_d3_d2"]
    sut = NYUDL::EAD::AnalysisNode.new('foo')
    sut.add_child_sequence(%w(c1 c2 c3).join('_'))
    sut.add_child_sequence(%w(d1 d3 d2).join('_'))
    actual = sut.child_sequences
    assert_equal(expected, actual, "expected: '#{expected}' actual: '#{actual}'")
  end

  def test_to_s
    expected = 'foo;false;0;["a1", "a2", "a3"];["c1", "c2", "c3"]'
    sut = NYUDL::EAD::AnalysisNode.new('foo')
    sut.add_attributes(%w(a1 a3 a2))
    sut.add_children(%w(c3 c1 c2))
    actual = sut.to_s
    assert_equal(expected, actual, "expected: '#{expected}' actual: '#{actual}'")
  end


  def test_increment_depth
    expected = 3
    sut = NYUDL::EAD::AnalysisNode.new('foo')

    sut.increment_depth
    sut.increment_depth
    sut.increment_depth

    actual = sut.depth
    assert_equal(expected, actual, "expected: '#{expected}' actual: '#{actual}'")
  end


  def test_assign_depth
    sut = NYUDL::EAD::AnalysisNode.new('foo')

    expected = 0
    actual   = sut.depth
    assert_equal(expected, actual, "expected: '#{expected}' actual: '#{actual}'")

    sut.depth = 12

    expected  = 12
    actual    = sut.depth
    assert_equal(expected, actual, "expected: '#{expected}' actual: '#{actual}'")
  end


  def test_needs_array_methods
    expected = false
    sut = NYUDL::EAD::AnalysisNode.new('foo')

    actual = sut.needs_array?
    assert_equal(expected, actual, "expected: '#{expected}' actual: '#{actual}'")

    # set value to true
    sut.needs_array!

    expected = true
    actual = sut.needs_array?
    assert_equal(expected, actual, "expected: '#{expected}' actual: '#{actual}'")
  end


  def test_merge_with_two_different_names
    sut   = NYUDL::EAD::AnalysisNode.new('foo')
    other = NYUDL::EAD::AnalysisNode.new('bar')

    assert_raises(ArgumentError) { sut.merge(other) }
  end


  def test_merge_effect_other_needs_array
    sut   = NYUDL::EAD::AnalysisNode.new('foo')
    other = NYUDL::EAD::AnalysisNode.new('foo')
    other.needs_array!

    # assert preconditions
    assert_equal(false, sut.needs_array?)
    assert_equal(true,  other.needs_array?)

    sut.merge(other)

    # assert postconditions
    assert_equal(true, sut.needs_array?)
    assert_equal(true, other.needs_array?)
  end


  def test_merge_effect_self_needs_array
    sut   = NYUDL::EAD::AnalysisNode.new('foo')
    other = NYUDL::EAD::AnalysisNode.new('foo')
    sut.needs_array!

    # assert preconditions
    assert_equal(true,  sut.needs_array?)
    assert_equal(false, other.needs_array?)

    sut.merge(other)

    # assert postconditions
    # (the merge should have had no effect on #needs_array?)
    assert_equal(true,  sut.needs_array?)
    assert_equal(false, other.needs_array?)
  end


  def test_merge_effect_neither_needs_array
    sut   = NYUDL::EAD::AnalysisNode.new('foo')
    other = NYUDL::EAD::AnalysisNode.new('foo')

    # assert preconditions
    assert_equal(false, sut.needs_array?)
    assert_equal(false, other.needs_array?)

    sut.merge(other)

    # assert postconditions
    assert_equal(false, sut.needs_array?)
    assert_equal(false, other.needs_array?)
  end


  def test_merge_effect_on_depth_other_is_greater
    sut   = NYUDL::EAD::AnalysisNode.new('foo')
    other = NYUDL::EAD::AnalysisNode.new('foo')
    (1..10).each { other.increment_depth }

    # assert preconditions
    assert_equal( 0, sut.depth)
    assert_equal(10, other.depth)

    sut.merge(other)

    # assert postconditions
    assert_equal(10, sut.depth)
    assert_equal(10, other.depth)
  end


  def test_merge_effect_on_depth_self_is_greater
    sut   = NYUDL::EAD::AnalysisNode.new('foo')
    other = NYUDL::EAD::AnalysisNode.new('foo')

    (1..20).each { sut.increment_depth   }
    (1..10).each { other.increment_depth }

    # assert preconditions
    assert_equal(20, sut.depth)
    assert_equal(10, other.depth)

    sut.merge(other)

    # assert postconditions
    assert_equal(20, sut.depth)
    assert_equal(10, other.depth)
  end


  def test_merge_effect_attributes
    sut   = NYUDL::EAD::AnalysisNode.new('foo')
    other = NYUDL::EAD::AnalysisNode.new('foo')

    sut.add_attributes(%w(sa1 sa3 sa2))
    other.add_attributes(%w(oa111 oa100 oa200))

    # assert preconditions
    assert_equal(["sa1", "sa2", "sa3"], sut.attributes)
    assert_equal(["oa100", "oa111", "oa200"], other.attributes)

    sut.merge(other)

    # assert postconditions
    assert_equal(["oa100", "oa111", "oa200", "sa1", "sa2", "sa3"], sut.attributes)
    assert_equal(["oa100", "oa111", "oa200"], other.attributes)
  end


  def test_merge_effect_attributes_other_empty
    sut   = NYUDL::EAD::AnalysisNode.new('foo')
    other = NYUDL::EAD::AnalysisNode.new('foo')

    sut.add_attributes(%w(sa1 sa3 sa2))

    # assert preconditions
    assert_equal(["sa1", "sa2", "sa3"], sut.attributes)
    assert_equal([], other.attributes)

    sut.merge(other)

    # assert postconditions
    # (the merge should have had no effect on the attributes)
    assert_equal(["sa1", "sa2", "sa3"], sut.attributes)
    assert_equal([], other.attributes)
  end


  def test_merge_effect_children
    sut   = NYUDL::EAD::AnalysisNode.new('foo')
    other = NYUDL::EAD::AnalysisNode.new('foo')

    sut.add_children(%w(sc1 sc3 sc2))
    other.add_children(%w(oc111 oc100 oc200))

    # assert preconditions
    assert_equal(["sc1", "sc2", "sc3"], sut.children)
    assert_equal(["oc100", "oc111", "oc200"], other.children)

    sut.merge(other)

    # assert postconditions
    assert_equal(["oc100", "oc111", "oc200", "sc1", "sc2", "sc3"], sut.children)
    assert_equal(["oc100", "oc111", "oc200"], other.children)
  end


  def test_merge_effect_children_other_empty
    sut   = NYUDL::EAD::AnalysisNode.new('foo')
    other = NYUDL::EAD::AnalysisNode.new('foo')

    sut.add_children(%w(sc1 sc3 sc2))

    # assert preconditions
    assert_equal(["sc1", "sc2", "sc3"], sut.children)
    assert_equal([], other.children)

    sut.merge(other)

    # assert postconditions
    # (the merge should have had no effect on the children)
    assert_equal(["sc1", "sc2", "sc3"], sut.children)
    assert_equal([], other.children)
  end

  def test_compress_string_array
    expected = ["head", "c+", "list", "listitem+", "end"]
    input = %w(head c c c c c c c list listitem listitem listitem end)
    actual = NYUDL::EAD::AnalysisNode.compress_string_array(input)
    assert_equal(expected, actual, "expected: '#{expected}' actual: '#{actual}'")
  end

  def test_compress_string_array_one_element
    expected = ["head"]
    input = %w(head)
    actual = NYUDL::EAD::AnalysisNode.compress_string_array(input)
    assert_equal(expected, actual, "expected: '#{expected}' actual: '#{actual}'")
  end

  def test_compress_string_array_end_on_repeater
    expected = ["head", "c+"]
    input = %w(head c c c c c c c)
    actual = NYUDL::EAD::AnalysisNode.compress_string_array(input)
    assert_equal(expected, actual, "expected: '#{expected}' actual: '#{actual}'")
  end

  def test_compress_string_array_begin_on_repeater
    expected = ["c+", "end"]
    input = %w(c c c c c c c end)
    actual = NYUDL::EAD::AnalysisNode.compress_string_array(input)
    assert_equal(expected, actual, "expected: '#{expected}' actual: '#{actual}'")
  end

end
