require 'byebug'

class PolyTreeNode

  attr_reader :value, :parent, :children

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def parent=(parent)
    old_parent = self.parent

    old_parent.children.delete(self) unless old_parent.nil?

    @parent = parent
    parent.children.push(self) unless parent.nil?
  end

  def add_child(new_node)
    new_node.parent = self
  end

  def remove_child(child)
    raise "Not my kid" unless children.include?(child)
    child.parent = nil
    children.delete(child)
  end

  def dfs(target)
    return self if value == target

    children.each do |child|
      child_search = child.dfs(target)
      return child_search unless child_search.nil?
    end

    nil
  end

  def inspect
    "#<PolyTreeNode Value = #{value}>"
  end

  def bfs(target)

    test_arr = [self]

    test_arr.each do |node|
      return node if node.value == target
      test_arr.concat(node.children)
    end

    nil
  end

end
