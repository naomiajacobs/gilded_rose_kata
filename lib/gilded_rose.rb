class Updater
  def initialize(item)
    @item = item
  end

  def update_item
    update_quality
    update_sell_in
  end

  def update_quality
    return if @item.quality == 0
    decrease_by = @item.sell_in > 0 ? 1 : 2
    @item.quality -= decrease_by
  end

  def update_sell_in
    @item.sell_in -= 1
  end
end

class SulfurasUpdater < Updater
  def update_quality

  end

  def update_sell_in

  end
end

class BrieUpdater < Updater
  def update_quality
    increase_by = @item.sell_in <= 0 ? 2 : 1
    @item.quality = [50, @item.quality + increase_by].min
  end
end

class BackStagePassUpdater < Updater
  def update_quality
    sell_in = @item.sell_in

    return @item.quality = 0 if sell_in <= 0

    if sell_in < 6
      increase_by = 3
    elsif sell_in < 11
      increase_by = 2
    else
      increase_by = 1
    end

    @item.quality = [50, @item.quality + increase_by].min
  end
end

class ConjuredUpdater < Updater
  def update_quality
    return if @item.quality == 0
    decrease_by = @item.sell_in > 0 ? 2 : 4
    @item.quality -= decrease_by
  end
end

def update_quality(items)
  items.each do |item|
    updater_class = case item.name
      when "Sulfuras, Hand of Ragnaros"
        SulfurasUpdater
      when "Aged Brie"
        BrieUpdater
      when "Backstage passes to a TAFKAL80ETC concert"
        BackStagePassUpdater
      when 'Conjured Mana Cake'
        ConjuredUpdater
      else
        Updater
    end

    updater_class.new(item).update_item
  end
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
