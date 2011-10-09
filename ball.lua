require 'middleclass'

Ball = class('Ball')

local stripe = love.graphics.newImage('ball.png')
local sprite = love.graphics.newImage('balls.png')

function Ball:initialize(world, radius, number, striped)
    self.number = number
    self.striped = striped
    self.body = love.physics.newBody(world, 0, 0, 1)
    self.shape = love.physics.newCircleShape(self.body, 0, 0, radius)
    self.lastX = -1
    self.lastY = -1
    self.hidden = false

    local tile = number
    
    if (tile == nil) then
        tile = 9
    elseif (tile > 8) then
        tile = tile - 8
    end

    self.quad = love.graphics.newQuad(0, tile * 20 - 20, 20, 20, 20, 180)

    self.body:setBullet(true)
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
    if (not self.hidden) then
        local x, y, radius = self.body:getX(), self.body:getY(), self.shape:getRadius()
        local lx, ly = self.body:getLinearVelocity()
        local angle = math.atan2(ly, lx)

        love.graphics.setColor(255, 255, 255)
        love.graphics.drawq(sprite, self.quad, x, y, angle, 1, 1, radius, radius)

        if (self.striped) then
            -- love.graphics.draw(stripe, x, y, 0, 1, 1, radius / 2, radius / 2)
        end
    end
end

function Ball:setPosition(x, y)
    self.body:setPosition(x, y)
end

function Ball:getX()
    return self.body:getX()
end

function Ball:getY()
    return self.body:getY()
end

function Ball:getRadius()
    return self.shape:getRadius()
end

function Ball:hit(factorX, factorY)
    self.body:applyImpulse(factorX, factorY)
end

function Ball:isMoving()
    return self.body:getX() ~= self.lastX or self.body:getY() ~= self.lastY
end

function Ball:stopMoving()
    self.body:setLinearVelocity(0, 0)
end

function Ball:getNumber()
    return self.number
end

function Ball:hide()
    self.hidden = true
    self.shape:setCategory(2)
end

function Ball:show()
    self.hidden = false
    self.shape:setCategory(1)
end