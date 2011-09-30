require 'middleclass'

Pocket = class('Pocket')

function Pocket:initialize(x, y)
    self.body = love.physics.newBody(world, x, y)
    self.shape = love.physics.newCircleShape(self.body, 0, 0, 15)
    self.shape:setSensor(true)
    self.shape:setData(self)
end

function Pocket:getBody()
    return self.body
end

function Pocket:draw()
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", self.body:getX(), self.body:getY(), self.shape:getRadius(), 50)
end