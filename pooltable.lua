require 'middleclass'

PoolTable = class('PoolTable')

local tableImage = love.graphics.newImage('table.png')
local width = tableImage:getWidth()
local height = tableImage:getHeight()

function PoolTable:initialize(world, cue, balls)
    self.world = world
    self.cue = cue
    self.balls = balls
    self.body = love.physics.newBody(world)
    self.madeBalls = {}
    self.pockets = {}
    self.cushions = {}
    self.placingCue = false

    local me = self
    world:setCallbacks(function(...)
        me:onCollision(...)
    end)

    -- counterclockwise starting from bottom left
    self:addCushion(53, 359, 61, 351, 332, 351, 334, 359)
    self:addCushion(369, 359, 370, 351, 641, 351, 650, 359)
    self:addCushion(675, 333, 667, 326, 667, 60, 675, 52)
    self:addCushion(370, 35, 369, 27, 650, 27, 642, 35)
    self:addCushion(61, 35, 53, 27, 334, 27, 333, 35)
    self:addCushion(27, 334, 27, 52, 35, 60, 35, 326)

    -- counterclockwise starting from bottom left
    self:addPocket(27, 335, 52, 359, 43, 367, 19, 344)
    self:addPocket(335, 360, 368, 360, 368, 372, 335, 372)
    self:addPocket(651, 359, 675, 334, 681, 342, 658, 368)
    self:addPocket(675, 51, 651, 27, 659, 20, 683, 42)
    self:addPocket(335, 26, 335, 16, 368, 26, 368, 16)
    self:addPocket(27, 51, 21, 43, 44, 20, 51, 26)
end

function PoolTable:getWidth()
    return width
end

function PoolTable:getHeight()
    return height
end

function PoolTable:getX()
    return self.body:getX()
end

function PoolTable:getY()
    return self.body:getY()
end

function PoolTable:setPosition(x, y)
    self.body:setPosition(x, y)
end

function PoolTable:update()
    if (self.placingCue) then
        local x, y, radius = love.mouse.getX(), love.mouse.getY(), self.cue:getRadius()

        x = math.max(x, 60 + self:getX() + radius)
        x = math.min(x, 191 + self:getX() - radius)
        y = math.max(y, 36 + self:getY() + radius)
        y = math.min(y, 350 + self:getY() - radius)

        self.cue:setPosition(x, y)
    end

    self.cue:update(dt)
    for index, ball in ipairs(self.balls) do
        ball:update(dt)
    end
end

function PoolTable:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(tableImage, self:getX(), self:getY())

    if (debugging) then
        for index, cushion in ipairs(self.cushions) do
            love.graphics.polygon("fill", cushion:getPoints())
        end

        for index, pocket in ipairs(self.pockets) do
            love.graphics.polygon("fill", pocket:getPoints())
        end
    end

    -- draw the balls
    self.cue:draw()
    for index, ball in ipairs(self.balls) do
        ball:draw()
    end
end

function PoolTable:addPocket(...)
    local pocket = love.physics.newPolygonShape(self.body, ...)
    pocket:setSensor("foo")
    pocket:setData("pocket")
    pocket:setMask(2)

    table.insert(self.pockets, pocket)
end

function PoolTable:addCushion(...)
    local cushion = love.physics.newPolygonShape(self.body, ...)
    cushion:setFriction(.05)

    table.insert(self.cushions, cushion)
end

function PoolTable:beginPlacingCue()
    self.placingCue = true
end

function PoolTable:placeCue()
    self.placingCue = false
end

function PoolTable:isPlacingCue()
    return self.placingCue
end

function PoolTable:areBallsMoving()
    local moving = false

    for index, ball in ipairs(self.balls) do
        if (ball:isMoving()) then
            moving = true
        end
    end

    return false -- TODO
end

function PoolTable:rack()
    self:randomizeBalls()

    local radius = self.balls[1]:getRadius()
    local x = self:getX() + 510 - radius * 2
    local y = self:getY() + height / 2
    local count = 0

    -- position the balls
    for i=1, 5 do
        local height = radius * 2 * i
        local currentY = y - height / 2

        for j=1, i do
            count = count + 1

            self.balls[count]:show()
            self.balls[count]:setPosition(x + radius*i*2 - (i * 2), currentY + radius)
            currentY = currentY + radius * 2
        end
    end
end

function PoolTable:moveCue(x, y)
    x = x or self:getX() + 100
    y = y or self:getY() + height / 2

    self.cue:stopMoving()
    self.cue:setPosition(x, y)
end

function PoolTable:onCollision(a, b, contact)
    local ball, pocket

    if (a == "pocket" and instanceOf(Ball, b)) then
        ball, pocket = b, a
    elseif (instanceOf(Ball, a) and a == "pocket") then
        ball, pocket = a, b
    end

    if (ball ~= nil and pocket ~= nil) then
        if (ball == cue) then
            poolTable:moveCue()
        else
            ball:hide()
        end
    end
end

function PoolTable:randomizeBalls()
    local tempBalls = {}
    local eightBall

    -- randomly sort the balls
    while (#self.balls > 0) do
        local index = math.random(1, #self.balls)
        local ball = self.balls[index]

        if (ball:getNumber() == 8) then
            eightBall = ball
        else
            table.insert(tempBalls, ball)
        end

        table.remove(self.balls, index)
    end
    table.insert(tempBalls, 5, eightBall)

    self.balls = tempBalls
end