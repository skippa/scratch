Animate = Class{}

local anim8 = require 'anim8'

local WALK_SPEED = 40
local RUN_SPEED = 80

local spriteState = "walk"

function Animate:init(spriteSheet, frameX, frameY, duration)
    --initialise position and velocity
    self.x = VIRTUAL_WIDTH / 2
    self.y = VIRTUAL_HEIGHT - frameY - 62 
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
        if self.dir == 1 then
            self.dir = -1
        end

        if spriteState == "run" or (lastKey == "right" and keyTimer < 0.1) then
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
        
        if love.keyboard.isDown('space') then
            self.dx = -RUN_SPEED * 1.5
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

    spriteActions[spriteState]:update(dt)
end


function Animate:render()
    spriteActions[spriteState]:draw(self.spriteSheet, self.x, self.y, 0, self.dir, 1, 18)
end

