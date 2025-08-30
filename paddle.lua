Class = require "class"

Paddle = Class{}

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243


function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
end

function Paddle:update(dt)

    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt )
    elseif self.dy > 0 then
        self.y = math.min(VIRTUAL_HEIGHT - 20, self.y + self.dy * dt )
    end

    


    -- if love.keyboard.isDown('up') then
    --     player2Y = math.max(0, player2Y + -paddleSpeed * dt)
    -- elseif love.keyboard.isDown('down') then
    --     player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + paddleSpeed * dt)
    -- end

end

function Paddle:draw(x, y)
    love.graphics.rectangle('fill', x, self.y, 5, 20)
end
