# frozen_string_literal: true

require 'require_all'
require_rel 'items'

class Solution
  AVAILABLE_ITEMS = %w[Milk Bread Banana Apple].freeze

  def initialize
    puts 'Please enter all the items purchased separated by a comma.'
    items = gets.chomp.split(',').map { |item| item.strip.capitalize }
    @items = items.select { |item| AVAILABLE_ITEMS.include? item }
  end

  def print
    console_print_header
    console_print_items
  end

  private

  def console_print(list)
    printf "%-10s %-10s %-5s\n" % list
  end

  def console_print_header
    console_print %w[Item Quantity Price]
    puts '--------------------------'
  end

  def console_print_items
    @items.uniq.each do |item|
      product = Object.const_get(item).new
      quantity = @items.count(item)
      cost =  product.calculate_cost quantity
      console_print [item, quantity, cost]
    end
  end
end

Solution.new.print
