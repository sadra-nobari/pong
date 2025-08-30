Class = require 'class'

Ball = Class{}

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243


function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dx = 0
    self.dy = 0
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:collides(paddle)
    -- detecting the horizan
    if self.x > paddle.x + paddle.width or self.x + self.width < paddle.x then
        return false
    end

    if self.y + self.height < paddle.y or self.y > paddle.y + paddle.height then
        return false
    end

    return true
end

function Ball:draw()
    love.graphics.rectangle('fill', self.x, self.y, 4, 4)
end

function Ball:reset()
    self.y = VIRTUAL_HEIGHT / 2 -2
    self.x = VIRTUAL_WIDTH /2 -2
end
