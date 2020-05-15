Tiles = Class{}

local anim8 = require 'anim8'

function Tiles:init(tileSheet, tileX, tileY)
    mapHeight = VIRTUAL_HEIGHT / 16
    mapWidth = VIRTUAL_WIDTH / 16 * 3

    self.tileSheet = tileSheet   

    tileGrid = anim8.newGrid(tileX, tileY, tileSheet:getWidth(), tileSheet:getHeight(), 0, 0, 5)

    tileGround = anim8.newAnimation(tileGrid(2, 1), 1)

    tileBatch = love.graphics.newSpriteBatch(tileSheet, mapHeight * mapWidth)

    r, sx, sy, ox, oy, kx, ky = 0

     
    tileBatch:add(tileGround:getFrameInfo(200, 1, r, sx, sy, ox, oy, kx, ky))

end


function Tiles:render()
    love.graphics.draw(tileBatch, 0, 0)
end


