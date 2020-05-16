Tiles = Class{}

local anim8 = require 'anim8'

--all tiles from the tileSheet
tiles = {}

--all tiles mapped out
map = {}

local GROUNDTILE = 2
local EARTHTITLE = 18
local FLOATLEFT = 49
local FLOATMIDDLE = 50
local FLOATRIGHT = 51



function Tiles:init(tileSheet, tileX, tileY)
    mapHeight = VIRTUAL_HEIGHT / 16
    mapWidth = VIRTUAL_WIDTH / 16 * 3

    self.tileSheet = tileSheet   
    self.tileY = tileY
    self.tileX = tileX

    tileGrid = anim8.newGrid(tileX, tileY, tileSheet:getWidth(), tileSheet:getHeight(), 0, 0, 0)

    tileGround = anim8.newAnimation(tileGrid(2, 1), 1)
    tileEarth = anim8.newAnimation(tileGrid(2, 2), 1)

    i = 1
    for y = 1, tileSheet:getHeight() / tileY do
        for x = 1, tileSheet:getWidth() / tileX do
            tiles[i] = anim8.newAnimation(tileGrid(x, y), 1)
            i = i+1
        end
    end
    
    tileBatch = love.graphics.newSpriteBatch(tileSheet, mapHeight * mapWidth)

    r, sx, sy, ox, oy, kx, ky = 0

    --create ground
    for x = 0, mapWidth * tileX, tileX do
        tileBatch:add(tiles[2]:getFrameInfo(x, VIRTUAL_HEIGHT - (2 * tileY), r, sx, sy, ox, oy, kx, ky))
        
    end

    for x = 0, mapWidth * tileX, tileX do
        tileBatch:add(tiles[18]:getFrameInfo(x, VIRTUAL_HEIGHT - tileY, r, sx, sy, ox, oy, kx, ky))
    end

     
    tileBatch:add(tiles[FLOATLEFT]:getFrameInfo(tileX * 5, ((VIRTUAL_HEIGHT / tileY) - 7) * tileY, r, sx, sy, ox, oy, kx, ky))
    tileBatch:add(tiles[FLOATMIDDLE]:getFrameInfo(tileX * 6, ((VIRTUAL_HEIGHT / tileY) - 7) * tileY, r, sx, sy, ox, oy, kx, ky))
    tileBatch:add(tiles[FLOATRIGHT]:getFrameInfo(tileX * 7, ((VIRTUAL_HEIGHT / tileY) - 7) * tileY, r, sx, sy, ox, oy, kx, ky))

end

function Tiles:tileAt(x, y)

end


function Tiles:render()
    love.graphics.draw(tileBatch, 0, 0)
end


