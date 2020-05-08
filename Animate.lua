Animate = Class{}

local anim8 = require 'anim8'

local SPEED = 40

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
    run = anim8.newAnimation(grid('1-7', 1), duration)
    walk = anim8.newAnimation(grid('1-7', 2), duration)
    
end


function Animate:update(dt)
    
    if love.keyboard.isDown('right') then
        self.dx = SPEED 
        if self.dir == 1 then
            self.dir = -1
        end
        camX = camX + dt * -self.dx 
        walk:resume()
    elseif love.keyboard.isDown('left') then
        self.dx = -SPEED
        if self.dir == -1 then
           self.dir = 1
        end
        camX = camX + dt * -self.dx 
        walk:resume()
    else
        walk:pause()
        self.dx = 0
    end
    

    self.dt = dt
    self.x = self.x + self.dx * dt

    walk:update(dt)
end


function Animate:render()
    walk:draw(self.spriteSheet, self.x, self.y, 0, self.dir, 1, 18)
end

