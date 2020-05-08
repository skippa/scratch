Animation = Class{}

function Animation:init(image, width, height, duration)
    self.spriteSheet = image
     
    actions = {
        walk = {
            quads{},
        },
    }
   
    
    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(actions.walk.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end
 
    self.duration = duration or 1
    self.currentTime = 0
    
    self.x = VIRTUAL_WIDTH / 2
    self.y = VIRTUAL_HEIGHT - image:getHeight()
    self.dx = -50
end

function Animation:update(dt)
    self.currentTime = self.currentTime + dt
    if self.currentTime >= self.duration then
        self.currentTime = self.currentTime - self.duration
    end

    self.x = self.x - self.dx * dt
end

function Animation:render()
    local spriteNum = math.floor(self.currentTime / self.duration * #actions.walk.quads) + 1
    love.graphics.draw(self.spriteSheet, actions.walk.quads[spriteNum], self.x, self.y, 0, -1, 1)
end
