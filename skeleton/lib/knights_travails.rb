require_relative '00_tree_node.rb'
require 'byebug'

class KnightPathFinder
  MOVE_DIMENSIONS = [[-2, -1],
                    [-2, 1],
                    [-1, -2],
                    [-1, 2],
                    [1, 2],
                    [2, -1],
                    [1, -2],
                    [2, 1]]

  attr_reader :position, :moves, :visited_positions, :root

  def initialize(position= [0,0])
    @position = position
    @visited_positions = [position]
    @root = PolyTreeNode.new(position)
    @move_tree = build_move_tree
    @start_pos = @root.value
  end

  def self.valid_moves(pos)
    moves = []

    MOVE_DIMENSIONS.each do |move_constant|
      x, y = pos[0], pos[1]
      x2, y2 = move_constant[0], move_constant[1]
      new_x = x + x2
      new_y = y + y2

      if new_x.between?(0, 7) && new_y.between?(0, 7)
        moves << [new_x, new_y]
      end
    end

    moves
  end

  def new_move_positions(pos)
    moves = self.class.valid_moves(pos)
    possible_moves = []

    moves.each do |move|
      unless visited_positions.include?(move)
        possible_moves << move
      end
    end
    @visited_positions.concat(possible_moves)
    possible_moves
  end

  def build_move_tree
    nodes = [@root]

    nodes.each do |node|
      new_var = new_move_positions(node.value)

      new_var.each do |pos|
        new_node = PolyTreeNode.new(pos)

        node.add_child(new_node)
        nodes << new_node
      end
    end
  end

  def find_path(end_pos)
    @end_node = @root.dfs(end_pos)
    trace_path_back
  end

  def trace_path_back
    pathway = [@end_node]

    until pathway.first.value == @start_pos
      pathway.unshift(pathway.first.parent)
    end

    pathway.map!{|node| node.value}
  end

end
