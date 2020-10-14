Items = class()

function Items:init(itemSheet, itemFrameX, itemFrameY, itemDuration, itemFrames)
    self.itemSheet = itemSheet
    self.itemFrameX = itemFrameX
    self.itemFrameY = itemFrameY
    self.items = {}
    --create grid
    self.itemGrid = anim8.newGrid(itemFrameX, itemFrameY, itemSheet:getWidth(), itemSheet:getHeight())
    --create animation frames from grid
    itemAnimation = anim8.newAnimation(self.itemGrid('1-' .. tostring(itemFrames), 1), itemDuration)
end


function Items:add(itemName, itemX, itemY)
    table.insert(self.items, {
        name = itemName,
        x = itemX,
        y = itemY, 
        sprite = itemAnimation,
        isCoin = true
    })

    world:add(self.items[#self.items], itemX, itemY, self.itemFrameX, self.itemFrameY)
end


function Items:remove(item)
    for i=1, #items do
        if self.items[i] == item then
            world:remove(item)
            table.remove(self.items, i)
        end
    end
end


function Items:update(dt)
   itemAnimation:update(dt)
   if #self.items > 0 then 
        self.items[#self.items].sprite:update(dt)
   end
end


function Items:render(x, y)
    --for k, v in ipairs(self.items) do
    --    thisItem = v.sprite
    --    thisItem:resume()
    --    thisItem:draw(self.itemSheet, v.x, v.y, 0, 1, 1)
    --end
    itemAnimation:draw(self.itemSheet, x, y, 0, 1, 1)    
end
