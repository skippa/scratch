-- virtual resolution handling library local push = require 'push'
local push = require 'push'

local bump = require 'bump'

require 'class'

anim8 = require 'anim8'

require 'Animate'

require 'Tiles'

require 'Items'

require 'HUD'

-- physical screen dimensions
local WINDOW_WIDTH, WINDOW_HEIGHT = love.window.getDesktopDimensions()

-- virtual resolution dimensions
VIRTUAL_WIDTH = 320
VIRTUAL_HEIGHT = 240


local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60
local BACKGROUND_LOOPING_POINT = 413
local GROUND_Y = 30
local isJumping = false

camX = 0
camY = 0

lastKey, keyTimer = 0, 0

coinCount = 0
playerVitality = 10


playerFilter = function(item, other)
    if     other.isCoin       then return 'cross'
    elseif other.isGround     then return 'slide'
    else return 'slide'
    end
end

function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.keyboard.setKeyRepeat(false)
    -- app window title
    love.window.setTitle('Scratchpad')
    
    love.graphics.setFont(love.graphics.newFont('font.ttf', 16))
   
    love.graphics.setColor(1, 1, 1, 1)
    
    math.randomseed(os.time())

   -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = true,
        resizable = false
    })

    world = bump.newWorld(64)

    mapTiles = Tiles(love.graphics.newImage('genTileset.png'), 16, 16)
    
    player = Animate(love.graphics.newImage('spritesheet.png'), 37, 52, 0.1)

    
    bluePotion = Items:new(love.graphics.newImage('blue-potion.png'), 18, 22, 0.3, 6)
    --bluePotion2 = Items:new(love.graphics.newImage('blue-potion.png'), 18, 22, 0.3, 6)
    --diamond = Items:new(love.graphics.newImage('blue-gem.png'), 16, 16, 0.3, 8)
    coins = Items(love.graphics.newImage('coin.png'), 16, 16, 0.1, 7)
    
    hud = HUD()
    
    for i = 1, 5, 1 do
    --    bluePotion:add("potion" .. tostring(i), (VIRTUAL_WIDTH / 2) + (i * 16), VIRTUAL_HEIGHT / 2)
    end
    
    for i = 1, 20, 1 do  
     --   coins:add("coin" .. tostring(i), (VIRTUAL_WIDTH / 2) + (i * 32), VIRTUAL_HEIGHT - (16 * 5))
    end


    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    lastKey = key
    lastKeyTime = keyTimer
    keyTimer = 0
    
    if key == 'space' and not isJumping then
        player.dy = -10
        isJumping = true 
    else
        isJumping = false
    end


    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)
    --bluePotion2:update(dt)
    coins:update(dt)
    --diamond:update(dt)
    bluePotion:update(dt)
    player:update(dt)
    keyTimer = keyTimer + dt

end


function love.draw()
    push:start()
    love.graphics.push()    

    love.graphics.translate(camX, camY)
    --render background and tiles
    --love.graphics.clear(0, 0, 0)
    mapTiles:render()


    coins:render(VIRTUAL_WIDTH - 100, VIRTUAL_HEIGHT - 100)
    --coins:render()
    bluePotion:render(VIRTUAL_WIDTH / 2, VIRTUAL_HEIGHT / 2) 
    --bluePotion2:render(VIRTUAL_WIDTH - 50, VIRTUAL_HEIGHT - 50)
    --diamond:render(VIRTUAL_WIDTH - 150, VIRTUAL_HEIGHT - 150)
    player:render()
    hud:render() 
    --love.graphics.pop()
    
    push:finish()
end
