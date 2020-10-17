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
potionCount = 0
playerVitality = 20

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
    coins = Items(love.graphics.newImage('coin.png'), 16, 16, 0.2, 7)
    chickens = Items(love.graphics.newImage('chicken.png'), 16, 16, 0.3, 5)
    cheese = Items(love.graphics.newImage('cheese.png'), 16, 16, 0.3, 4)
    hud = HUD()
    
    for i = 1, 3, 1 do
        bluePotion:add("potion" .. tostring(i), "potion", (VIRTUAL_WIDTH / 2) + (i * 20), VIRTUAL_HEIGHT / 2)
    end
    
    for i = 1, 3, 1 do  
       coins:add("coin" .. tostring(i), "coin", (VIRTUAL_WIDTH / 2) + (i * 32), VIRTUAL_HEIGHT - (16 * 5))
    end

    chickens:add("chicken", "chicken", 20, VIRTUAL_HEIGHT - (16 * 3))
    cheese:add("cheese", "cheese", 50, VIRTUAL_HEIGHT - (16 * 3))
    
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
    coins:update(dt)
    bluePotion:update(dt)
    chickens:update(dt)
    cheese:update(dt)
    player:update(dt)
    keyTimer = keyTimer + dt

end


function love.draw()
    push:start()
    love.graphics.push()    

    love.graphics.translate(camX, camY)
    -- draw background 
    mapTiles:render()
    coins:render()
    bluePotion:render() 
    chickens:render()
    cheese:render()
    player:render()
    hud:render() 
    
    push:finish()
end
