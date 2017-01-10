require 'singleton'
require 'forwardable'

class ItemProxy
  extend Forwardable

  def initialize(item)
    @item = item
  end

  def_delegators :@item, :name, :quality, :quality=, :sell_in, :sell_in=

  def expires?
    name != 'Sulfuras, Hand of Ragnaros'
  end
end

class ItemUpdater
  include Singleton

  def get_proxy(item)
    ItemProxy.new(item)
  end
end

class QualityUpdater < ItemUpdater
  def update(item, amount)
    proxy_item = get_proxy(item)
    proxy_item.quality += amount
  end
end

class ExpiryUpdater < ItemUpdater
  def update(item)
    proxy_item = get_proxy(item)
    proxy_item.sell_in -= 1 if proxy_item.expires?
  end
end

def update_quality(items)
  items.each do |item|
    if item.name != 'Aged Brie' && item.name != 'Backstage passes to a TAFKAL80ETC concert'
      if item.quality > 0
        if item.name != 'Sulfuras, Hand of Ragnaros'
          QualityUpdater.instance.update(item, -1)
        end
      end
    else
      if item.quality < 50
        QualityUpdater.instance.update(item, 1)
        if item.name == 'Backstage passes to a TAFKAL80ETC concert'
          if item.sell_in < 11
            if item.quality < 50
              QualityUpdater.instance.update(item, 1)
            end
          end
          if item.sell_in < 6
            if item.quality < 50
              QualityUpdater.instance.update(item, 1)
            end
          end
        end
      end
    end

    ExpiryUpdater.instance.update(item)

    if item.sell_in < 0
      if item.name != "Aged Brie"
        if item.name != 'Backstage passes to a TAFKAL80ETC concert'
          if item.quality > 0
            if item.name != 'Sulfuras, Hand of Ragnaros'
              QualityUpdater.instance.update(item, -1)
            end
          end
        else
          QualityUpdater.instance.update(item, -item.quality)
        end
      else
        if item.quality < 50
          QualityUpdater.instance.update(item, 1)
        end
      end
    end
  end
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
