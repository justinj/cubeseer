require "minitest/autorun"
require "minitest/mock"

module CubeSeer
  class CubeFilter
    attr_accessor :cube

    def initialize
      @filters = []
    end

    def query(q)
      result = cube.query(q)
      @filters.each do |filter|
        result = filter.call(result)
      end
      result
    end
    alias_method :"[]", :query

    def show(args)
      if args.has_key? :only
        add_filter_for(args[:only], true)
      elsif args.has_key? :except
        add_filter_for(args[:except], false)
      end
    end

    private

    def add_filter_for(piece_type, inclusive)
      add_filter do |result|
        case piece_type
        when :edges
          filter(result, inclusive) { |r, c, s| edge_piece?(r, c, s) }
        when :corners
          filter(result, inclusive) { |r, c, s| corner_piece?(r, c, s) }
        when :centers
          filter(result, inclusive) { |r, c, s| center_piece?(r, c, s) }
        end
      end
    end

    def filter(result, inclusive, &blk)
      if inclusive
        filter_on(result) { |*args| blk.call(*args) }
      else
        filter_on(result) { |*args| !blk.call(*args) }
      end
    end

    def filter_on(result)
      new_result = []
      result.each_with_index do |row, r|
        new_row = []
        row.each_with_index do |sticker, c|
          if yield(r, c, result)
            new_row << sticker
          else
            new_row << :X
          end
        end
        new_result << new_row
      end
      new_result
    end

    def edge_piece?(row, column, result)
      !corner_piece?(row, column, result) &&
      !center_piece?(row, column, result)
    end

    def corner_piece?(row, column, result)
      (row == 0 || row == result[0].count - 1) &&
      (column == 0 || column == result[0].count - 1)
    end

    def center_piece?(row, column, result)
      (1...result[0].count-1).cover?(row) &&
      (1...result[0].count-1).cover?(column)
    end

    def add_filter(&blk)
      @filters << blk
    end
  end
end
