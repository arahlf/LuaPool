require 'middleclass'
require 'color'

Ball = class('Ball')

function Ball:initialize(radius, color, striped)
    self.body = love.physics.newBody(world, 0, 0, 1)
    self.shape = love.physics.newCircleShape(self.body, 0, 0, radius)
    self.color = color
    self.striped = striped
    self.lastX = -1
    self.lastY = -1

    self.body:setLinearDamping(1)
    self.shape:setFriction(.01)
    self.shape:setRestitution(.85)
    self.shape:setData(self)
end

function Ball:update(dt)
    self.lastX = self.body:getX()
    self.lastY = self.body:getY()
end

function Ball:draw()
    local x, y, radius = self.body:getX(), self.body:getY(), self.shape:getRadius()

    self.color:set()
    love.graphics.circle("fill", x, y, radius, 50)

    love.graphics.setColor(255, 255, 255)
    if (self.striped) then
        love.graphics.circle("fill", x, y, radius / 2, 50)
    end
end

function Ball:getBody()
    return self.body
end

function Ball:isMoving()
    return self.body:getX() ~= self.lastX or self.body:getY() ~= self.lastY
end