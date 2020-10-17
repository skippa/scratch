Animate = class()

local WALK_SPEED = 40
local RUN_SPEED = 240
local GRAVITY = 30
local JUMP_POWER = 20

local spriteState = "idle"
local keyThreshold = 0.3 --time between double keypresses

function Animate:init(spriteSheet, frameX, frameY, duration)
    --initialise position and velocity
    self.x = VIRTUAL_WIDTH / 2
    self.y = VIRTUAL_HEIGHT - frameY - 64
    self.frameY = frameY
    self.dx = 0
    self.dy = 0
    self.dir = 1
    self.spriteSheet = spriteSheet
    self.spriteState = 'idle'
    --create spritesheet grid
    runGrid = anim8.newGrid(frameX, frameY, spriteSheet:getWidth(), spriteSheet:getHeight())
    walkGrid = anim8.newGrid(frameX, frameY, spriteSheet:getWidth(), spriteSheet:getHeight())
    idleGrid = anim8.newGrid(frameX, frameY, spriteSheet:getWidth(), spriteSheet:getHeight())

    --create animations from frames on grid 
    spriteActions = {
        run = anim8.newAnimation(runGrid('1-7', 1), duration);
        walk = anim8.newAnimation(walkGrid('1-7', 2), duration);
        idle = anim8.newAnimation(idleGrid('1-6', 3), duration);

    }

    world:add("player", self.x-15, self.y, frameX-15, frameY)
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
        spriteState = "idle"
        spriteActions[spriteState]:resume()
        self.dx = 0
    end
   

    self.dt = dt
    self.x = self.x + self.dx * dt
    
    self.dy = self.dy + GRAVITY * dt
    self.y = self.y + self.dy

    spriteActions[spriteState]:update(dt)
end


function Animate:render()
    actualX, actualY, cols, len = world:move("player", self.x, self.y, playerFilter)
    self.x = actualX
    self.y = actualY
    --love.graphics.push()
    if len > 0 then 
        for i=1, len do 
            local other = cols[i].other
            --local thisItem = cols[i].sprite
         --   love.graphics.printf(("Collision with %s."):format(other.name), VIRTUAL_WIDTH/2, 210 + (i * 16), 100)
            if other.itemType == "coin" then
                coinCount = coinCount + 1
                coins:remove(other) 
            elseif other.itemType == "potion" then
                potionCount = potionCount + 1
                bluePotion:remove(other)
            end
        end
    end 
    --love.graphics.pop() 
    spriteActions[spriteState]:draw(self.spriteSheet, self.x, self.y, 0, self.dir, 1, 18)
    
end

