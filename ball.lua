require 'middleclass'

Ball = class('Ball')

local stripe = love.graphics.newImage('ball.png')
local sprite = love.graphics.newImage('balls.png')

function Ball:initialize(radius, number, striped)
    self.body = love.physics.newBody(world, 0, 0, 1)
    self.shape = love.physics.newCircleShape(self.body, 0, 0, radius)
    self.striped = striped
    self.lastX = -1
    self.lastY = -1
    self.quad = love.graphics.newQuad(0, number * 20 - 20, 20, 20, 20, 180)

    self.body:setLinearDamping(1)
    self.shape:setFriction(.01)
    self.shape:setRestitution(.85)
    self.shape:setData(self)
    self.shape:setCategory(1)
    self.shape:setMask(2)
end

function Ball:update(dt)
    self.lastX = self.body:getX()
    self.lastY = self.body:getY()
end

function Ball:draw()
    local x, y, radius = self.body:getX(), self.body:getY(), self.shape:getRadius()

    love.graphics.setColor(255, 255, 255)
    love.graphics.drawq(sprite, self.quad, x, y, 0, 1, 1, radius, radius)

    if (self.striped) then
        love.graphics.draw(stripe, x, y, 0, 1, 1, radius / 2, radius / 2)
    end
end

function Ball:getBody()
    return self.body
end

function Ball:isMoving()
    return self.body:getX() ~= self.lastX or self.body:getY() ~= self.lastY
end