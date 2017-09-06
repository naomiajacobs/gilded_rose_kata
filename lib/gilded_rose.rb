require "delegate"

module BuildItem
  def for(item)
    case item.name
      when "Sulfuras, Hand of Ragnaros" then LegendaryItem.new(item)
      when "Aged Brie" then AgedItem.new(item)
      when "Backstage passes to a TAFKAL80ETC concert" then ConcertTickets.new(item)
      when "Conjured Mana Cake" then ConjuredItem.new(item)
      else NormalItem.new(item)
    end
  end
  module_function :for
end

class BaseItem < SimpleDelegator
  def update
    update_quality
    update_sell_in
    update_quality if self.sell_in < 0
  end

  private

  def update_quality
    raise NotImplementedError
  end

  def update_sell_in
    raise NotImplementedError
  end

  def noop; end

  def decrement_sell_in
    self.sell_in -= 1
  end

  def decrement_quality
    self.quality -= 1 if self.quality > 0
  end

  def increment_quality
    self.quality += 1 if self.quality < 50
  end
end

class NormalItem < BaseItem
  private

  alias_method :update_quality, :decrement_quality
  alias_method :update_sell_in, :decrement_sell_in
end

class LegendaryItem < NormalItem
  private

  alias_method :update_quality, :noop
  alias_method :update_sell_in, :noop
end

class AgedItem < NormalItem
  private

  alias_method :update_quality, :increment_quality
  alias_method :update_sell_in, :decrement_sell_in
end

class ConcertTickets < NormalItem
  private

  def update_quality
    if self.sell_in < 0
      self.quality = 0
    else
      increment_quality
      increment_quality if self.sell_in < 11
      increment_quality if self.sell_in < 6
    end
  end
end

class ConjuredItem < NormalItem
  private

  def update_quality
    decrement_quality
    decrement_quality
  end
end

def update_quality(items)
  items.collect { |item| BuildItem.for(item).update }
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
