require_relative 'menu'
require_relative 'sms'
require 'twilio-ruby'
require 'date'
class Takeaway
  # This class allows you to view and order dishes

  attr_reader :items, :dishes, :total_order, :menu, :one_hour_ahead, :sms

  def initialize(menu = Menu.new)
    @menu = menu
    @dishes = menu.dishes
    @total_order = []
  end

  def add(item, quantity=1)
    self.total_order += [dishes.select {|k, v| k == item}] * quantity
  end

  def view_dishes
    dishes
  end

  def total_order_cost
    total_order.flat_map(&:values).inject(:+)
  end

  def place_order(cost)
    fail_message = "Order total is £#{total_order_cost}. You expected £#{cost}."
    message = "Thank you! Your order costs £#{total_order_cost} and will be delivered before #{one_hour_ahead.strftime "%H:%M"}"
    fail fail_message if cost != total_order_cost
    @sms = SMS.new
    sms.send_sms(message)
    message
  end

  def one_hour_ahead
    DateTime.now + (1/24.0)
  end

  private
  attr_writer :dishes, :total_order


end
