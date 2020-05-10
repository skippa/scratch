
-- virtual resolution handling library
push = require 'push'

Class = require 'class'

local anim8 = require 'anim8'

require 'Animate'

require 'Tiles'



-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 320
VIRTUAL_HEIGHT = 240


local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60
local BACKGROUND_LOOPING_POINT = 413
local GROUND_Y = 30

camX = 0
camY = 0

lastKey, keyTimer = 0, 0

function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.keyboard.setKeyRepeat(false)
    -- app window title
    love.window.setTitle('Scratchpad')
    
    love.graphics.setFont(love.graphics.newFont('font.ttf', 8))
   
    love.graphics.setColor(1, 1, 1, 1)
    
    math.randomseed(os.time())

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = true,
        resizable = false
    })


    player = Animate(love.graphics.newImage('spritesheet.png'), 37, 52, 0.1)
    
    tileSheet = love.graphics.newImage('sonic-tiles.png')
    
    tileGrid = anim8.newGrid(256, 256, tileSheet:getWidth(), tileSheet:getHeight(), 0, 0, 5)
    
    tile1 = anim8.newAnimation(tileGrid(1, 4), 1)

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    lastKey = key
    lastKeyTime = keyTimer
    keyTimer = 0
    
    if key == 'space' then
        player.dy = -10
    
    end


    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    player:update(dt)
    keyTimer = keyTimer + dt
    
    love.keyboard.keysPressed = {}
end


function love.draw()
    push:start()
    
    
    love.graphics.translate(camX, camY)
    love.graphics.clear(0.14, 0, 0.71)
    tile1:draw(tileSheet, 0, -16)
    tile1:draw(tileSheet, 256, -16)

    love.graphics.printf(tostring(keyTimer), VIRTUAL_WIDTH/2, 200, 100)
    love.graphics.printf(tostring(lastKeyTime), VIRTUAL_WIDTH/2, 208, 100)
    love.graphics.printf(lastKey, VIRTUAL_WIDTH/2, 216, 100)
    


    player:render()
    

    push:finish()
end
