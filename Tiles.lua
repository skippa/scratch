Tiles = Class{}

local anim8 = require 'anim8'

--array for tiles from the tileSheet
tiles = {}

--array for map 
map = {}

local SKYTILE = 16
local GROUNDTILE = 2
local EARTHTILE = 18
local FLOATLEFT = 49
local FLOATMIDDLE = 50
local FLOATRIGHT = 51


function Tiles:init(tileSheet, tileWidth, tileHeight)
    mapHeight = VIRTUAL_HEIGHT / tileHeight
    mapWidth = VIRTUAL_WIDTH / tileWidth * 3

    mapHeightPixels = mapHeight * tileHeight
    mapWidthPixels = mapWidth * tileWidth

    self.tileSheet = tileSheet   
    self.tileHeight = tileHeight
    self.tileWidth = tileWidth

    tileGrid = anim8.newGrid(tileWidth, tileHeight, tileSheet:getWidth(), tileSheet:getHeight(), 0, 0, 0)

    i = 1
    for y = 1, tileSheet:getHeight() / tileHeight do
        for x = 1, tileSheet:getWidth() / tileWidth do
            tiles[i] = anim8.newAnimation(tileGrid(x, y), 1)
            i = i+1
        end
    end
    
    tileBatch = love.graphics.newSpriteBatch(tileSheet, mapHeight * mapWidth)

    r, sx, sy, ox, oy, kx, ky = 0
    
    --fill screen with sky tiles
    for m = 1, mapWidth * mapHeight, 1 do
        map[m] = SKYTILE
    end


    for m = mapWidth * 12 + 1, mapWidth * 13, 1 do
        map[m] = GROUNDTILE
    end 
    
    for m = mapWidth * 13 + 1, mapWidth * 14, 1 do
        map[m] = EARTHTILE
    end

    --random platforms
    platformX = math.random(1, mapWidth - 3)
    platformY = mapHeight - 8
    platformPos = (platformY * mapWidth) + platformX

    map[platformPos] = FLOATLEFT
    map[platformPos+1] = FLOATMIDDLE
    map[platformPos+2] = FLOATRIGHT
    
    m = 1

    --add map to spritebatch
    for y = 1, mapHeight, 1 do
        for x = 1, mapWidth, 1 do
            tileBatch:add(tiles[map[m]]:getFrameInfo(x * tileWidth, y * tileHeight, r, sx, sy, ox, oy, kx, ky))
            m = m + 1
        end
    end

end

function Tiles:tileAt(x, y)

end


function Tiles:render()
    love.graphics.draw(tileBatch, 0, 0)
end


