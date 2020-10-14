HUD = class()

function HUD:init()
    --coinHUD = anim8.newAnimation(coins.itemGrid(1, 1), 1)
    --load other item spritesheets
end


function HUD:update()
    
end


function HUD:render()
    love.graphics.pop()
    --coinHUD:draw(coins.itemSheet, VIRTUAL_WIDTH - 22, 4, 0, 1, 1, 18)
    love.graphics.printf((tostring(coinCount)), VIRTUAL_WIDTH - 22, 5, 100)
    --coinframe, coinx, coiny = coins.items[1].sprite:getFrameInfo()
    --love.graphics.printf((bluePotion.items[1].name), VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT - 30, 100)
    --coins.items[1].sprite:draw(coins.itemSheet, 100, 100, 0, 1, 1)
end

