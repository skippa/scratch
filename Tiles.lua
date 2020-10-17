Tiles = class()

--local anim8 = require 'anim8'


--array for tiles from the tileSheet
tiles = {}

--array for map 
map = {}
-- {type = SKYTILE, isGround = bool} 
platforms = {}

local SKYTILE = 15
local GROUNDTILE = 2
local EARTHTILE = 18
local FLOATLEFT = 49
local FLOATMIDDLE = 50
local FLOATRIGHT = 51


function Tiles:init(tileSheet, tileWidth, tileHeight)
    mapHeight = 15
    mapWidth = 100 

    self.mapHeightPixels = mapHeight * tileHeight
    self.mapWidthPixels = mapWidth * tileWidth

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
    for m = 0, mapWidth * mapHeight, 1 do
        map[m] = SKYTILE
    end

    groundHeight = mapHeight - 2

    for m = mapWidth * groundHeight + 1, mapWidth * (groundHeight + 1), 1 do
        map[m] = GROUNDTILE 
    end 
    
    for m = mapWidth * (groundHeight + 1) + 1, mapWidth * (groundHeight + 2), 1 do
        map[m] = EARTHTILE
    end
    

    --random platform
    for i = 1, 10, 1 do
        platformX = math.random(1, mapWidth - 3)
        platformY = mapHeight - 7
        platformPos = (platformY * mapWidth) + platformX
    
        map[platformPos] = FLOATLEFT
        map[platformPos+1] = FLOATMIDDLE
        map[platformPos+2] = FLOATRIGHT
    

        platformX = platformX + 4
        platformY = platformY - 5
        platformPos = (platformY * mapWidth) + platformX
        
        map[platformPos] = FLOATLEFT
        map[platformPos+1] = FLOATMIDDLE
        map[platformPos+2] = FLOATRIGHT
    end

    --higher platform


    --add map to spritebatch
    m = 1
    for y = 1, mapHeight, 1 do
        for x = 1, mapWidth, 1 do
            tileBatch:add(tiles[map[m]]:getFrameInfo((x-1) * tileWidth, (y-1) * tileHeight, r, sx, sy, ox, oy, kx, ky))
            if map[m] ~= SKYTILE then
                world:add("tile" .. m, (x) * tileWidth, (y-1) * tileHeight, tileHeight, tileWidth)
            end
            m = m + 1
        end
    end
end

function Tiles:getCurrentTile(x, y)
    thisTileY = math.floor(y / self.tileHeight) * mapWidth
    thisTileX = math.floor(x / self.tileWidth)

    thisTile = thisTileX + thisTileY

    return thisTile

end

function Tiles:getTileXY(thisTile)
    y = math.floor(thisTile / mapWidth) * self.tileHeight
    x = (thisTile - ((math.floor(thisTile / mapWidth) * mapWidth) - 1)) * self.tileWidth
    return x, y
end

function Tiles:isonGround(x, y)
    thisTileY = math.floor((y + player.frameY) / self.tileHeight) * mapWidth
    thisTileX = math.floor(x / self.tileWidth)

    thisTile = thisTileX + thisTileY

    thisTileType = map[thisTile]

    --thisTile = map[720]

    if thisTileType == FLOATLEFT or thisTileType == FLOATMIDDLE or thisTileType == FLOATRIGHT or thisTileType == GROUNDTILE then 
        maxY = (thisTile / mapWidth * self.tileHeight) - player.frameY
        return true
    else
        return false
    end
end

function Tiles:render()
    love.graphics.draw(tileBatch, 0, 0)
end
