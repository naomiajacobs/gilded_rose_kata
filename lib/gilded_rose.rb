class Updater
  def initialize(item)
    @item = item
  end

  def update_item
    update_quality
    update_sell_in
  end

  def update_quality
    if quality_direction == :decrease
      @item.quality = [0, @item.quality - quality_change].max
    else
      @item.quality = [50, @item.quality + quality_change].min
    end
  end

  def quality_change
    @item.sell_in > 0 ? 1 : 2
  end

  def quality_direction
    :decrease
  end

  def update_sell_in
    @item.sell_in -= 1
  end
end

class SulfurasUpdater < Updater
  def update_item

  end
end

class BrieUpdater < Updater
  def quality_change
    @item.sell_in <= 0 ? 2 : 1
  end

  def quality_direction
    :increase
  end
end

class BackStagePassUpdater < Updater
  def initialize(item)
    super
    @sell_in = @item.sell_in
  end

  def update_quality
    if @sell_in <= 0
      @item.quality = 0
    else
      super
    end
  end

  def quality_change
    if @sell_in < 6
      3
    elsif @sell_in < 11
      2
    else
      1
    end
  end

  def quality_direction
    :increase
  end
end

class ConjuredUpdater < Updater
  def quality_change
    super * 2
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
