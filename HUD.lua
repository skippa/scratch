HUD = class()

function HUD:init()
    coinHUD = anim8.newAnimation(coins.itemGrid(1, 1), 1)
    potionHUD = anim8.newAnimation(bluePotion.itemGrid(1, 1), 1)
   
    self.spriteSheet = love.graphics.newImage('life.png')
    
    lifeGrid = anim8.newGrid(15, 16, self.spriteSheet:getWidth(), self.spriteSheet:getHeight(), 0, 0, 1)

    lifeGauge = {
        anim8.newAnimation(lifeGrid(1, 1), 1),
        anim8.newAnimation(lifeGrid(2, 1), 1),
        anim8.newAnimation(lifeGrid(3, 1), 1),
        anim8.newAnimation(lifeGrid(4, 1), 1),
        anim8.newAnimation(lifeGrid(5, 1), 1)
    }
end


function HUD:update()
    
end


function HUD:render()
    love.graphics.pop()
    coinHUD:draw(coins.itemSheet, VIRTUAL_WIDTH - 22, 4, 0, 1, 1, 18)
    love.graphics.printf((tostring(coinCount)), VIRTUAL_WIDTH - 22, 5, 100)
    
    potionHUD:draw(bluePotion.itemSheet, VIRTUAL_WIDTH - 64, 1, 0, 1, 1, 18)
    love.graphics.printf((tostring(potionCount)), VIRTUAL_WIDTH - 64, 5, 100)


    for i = 1, 5, 1 do
        lifeGauge[5]:draw(self.spriteSheet, 1 + (i * 16) - 16, 2, 0, 1, 1)
    end
end

