Items = class()

local anim8 = require 'anim8'

items = {}


function Items:init(itemSheet, itemFrameX, itemFrameY, itemDuration)
    self.itemSheet = itemSheet
    self.itemFrameX = itemFrameX
    self.itemFrameY = itemFrameY
    --create grid
    coinGrid = anim8.newGrid(itemFrameX, itemFrameY, itemSheet:getWidth(), itemSheet:getHeight())
    --create animation frames from grid
    coin = anim8.newAnimation(coinGrid('1-7', 1), itemDuration)
end


function Items:add(itemName, itemX, itemY)
    table.insert(items, {
        name = itemName,
        x = itemX,
        y = itemY, 
        sprite = coin 
    })

    world:add(itemName, itemX, itemY, self.itemFrameX, self.itemFrameY)
end


function Items:remove(itemName)

end


function Items:update(dt)
    items[1].sprite:update(dt)
end


function Items:render()
    for k, v in ipairs(items) do
        thisItem = v.sprite
        thisItem:resume()
        thisItem:draw(self.itemSheet, v.x, v.y, 0, 1, 1, 18)
    end

end
