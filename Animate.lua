Animate = Class{}

local anim8 = require 'anim8'

local WALK_SPEED = 40
local RUN_SPEED = 120
local GRAVITY = 30
local JUMP_POWER = 20

local spriteState = "walk"
local keyThreshold = 0.3 --time between double keypresses

function Animate:init(spriteSheet, frameX, frameY, duration)
    --initialise position and velocity
    self.x = VIRTUAL_WIDTH / 2
    self.y = VIRTUAL_HEIGHT - frameY - 32
    self.frameY = frameY
    self.dx = 0
    self.dy = 0
    self.dir = 1
    self.spriteSheet = spriteSheet
    self.spriteState = 'idle'
    --create spritesheet grid
    grid = anim8.newGrid(frameX, frameY, spriteSheet:getWidth(), spriteSheet:getHeight())

    --create animations from frames on grid 
    spriteActions = {
        run = anim8.newAnimation(grid('1-7', 1), duration);
        walk = anim8.newAnimation(grid('1-7', 2), duration);
    }

end


function Animate:update(dt)
    
    if love.keyboard.isDown('right') then
        if self.dir == 1 then --if not going right, swap direction
            self.dir = -1
        end

        if spriteState == "run" or (lastKey == "right" and lastKeyTime < keyThreshold) then
            --go into run state if 'right' key pressed twice in succession (< keyThreshold)
            self.dx = RUN_SPEED
            spriteState = "run"    
        else
            self.dx = WALK_SPEED
            spriteState = "walk"
        end
        
        camX = camX + dt * -self.dx 
        spriteActions[spriteState]:resume()
    
    elseif love.keyboard.isDown('left') then
        if self.dir == -1 then
           self.dir = 1
        end
        if spriteState == "run" or (lastKey == "left" and lastKeyTime < keyThreshold) then
            self.dx = -RUN_SPEED
            spriteState = "run"    
        else
            self.dx = -WALK_SPEED
            spriteState = "walk"
        end

        camX = camX + dt * -self.dx 
        spriteActions[spriteState]:resume()
    else
        spriteState = "walk"
        spriteActions[spriteState]:pause()
        self.dx = 0
    end
   

    self.dt = dt
    self.x = self.x + self.dx * dt
    
    thisTile = mapTiles:getCurrentTile(player.x, player.y)
    thisTileX, thisTileY = mapTiles:getTileXY(thisTile) 

    if mapTiles:isonGround(player.x, player.y)  then
        self.y = math.min(self.y + self.dy, thisTileY)
        dy = 0
    else
        self.dy = self.dy + GRAVITY * dt
        self.y = self.y + self.dy
    end

    spriteActions[spriteState]:update(dt)
end


function Animate:render()
    spriteActions[spriteState]:draw(self.spriteSheet, self.x, self.y, 0, self.dir, 1, 18)
    
end

