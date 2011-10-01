require 'middleclass'

Pocket = class('Pocket')

local image = love.graphics.newImage('pocket.png')

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
    love.graphics.draw(image, self.body:getX(), self.body:getY(), 0, 1, 1, self.shape:getRadius(), self.shape:getRadius())
end