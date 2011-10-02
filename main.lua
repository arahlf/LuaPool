require 'ball'
require 'pooltable'

math.randomseed(os.time());
math.random() math.random() math.random()

debugging = false
guides = false

-- TODO cue ball power streak

function getDistance(circle1, circle2)
    -- hack...
    local radius1, radius2 = circle1.shape:getRadius(), circle2.shape:getRadius()
    local x1, y1, x2, y2 = circle1:getBody():getX(),
                           circle1:getBody():getY(),
                           circle2:getBody():getX(),
                           circle2:getBody():getY()
    
    return math.sqrt(math.pow(x2-x1, 2), math.pow(y2-y1, 2))
end

function onAdd(a, b, contact)
    if (a == 'foo' or b == 'foo') then
        print("hollaaaaa")
    end
end

world = love.physics.newWorld(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
world:setCallbacks(onAdd, onAdd, onRemove)



balls = {}
walls = {}
ballsMoving = false

local radius = 10

-- create the balls
for i=1, 7 do
    table.insert(balls, Ball(radius, i, true))
    table.insert(balls, Ball(radius, i, false))
end

local eightBall = Ball(radius, 8, true)
table.insert(balls, 5, eightBall)

local poolTable = PoolTable()
local tableWidth = poolTable:getWidth()
local tableHeight = poolTable:getHeight()
local tableThickness = 25
local tableX = (love.graphics.getWidth() - tableWidth) / 2
local tableY = (love.graphics.getHeight() - tableHeight) / 2

poolTable:setPosition(math.floor(tableX), math.floor(tableY)) -- non-integer pixel measurements display blurry :(


function love.load()

    local x = tableX + 510 - radius * 2
    local y = tableY + tableHeight / 2
    local count = 0

    -- position the balls
    for i=1, 5 do
        local height = radius * 2 * i
        local currentY = y - height / 2

        for j=1, i do
            count = count + 1

            balls[count]:getBody():setPosition(x + radius*i*2 - (i * 2), currentY + radius)
            currentY = currentY + radius * 2
        end
    end
    
    cue = Ball(radius, 9, false) -- kinda hacky
    cue:getBody():setPosition(tableX + 100, tableY + 100)

    table.insert(balls, cue)

    love.graphics.setBackgroundColor(71, 101, 71)
    love.graphics.setCaption('LuaPool')
end

function love.update(dt)
    world:update(dt)

    local anyMoving = false

    for index, ball in ipairs(balls) do
        if (ball:isMoving()) then
            anyMoving = true
        end

        ball:update(dt)
    end

    moving = anyMoving
end

function love.draw()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    poolTable:draw()


    -- draw the balls
    for index, ball in ipairs(balls) do
        ball:draw()
    end

    if (not moving) then
        love.graphics.setColor(255, 0, 0)
        local x1, y1, x2, y2 = cue:getBody():getX(), cue:getBody():getY(), love.mouse.getX(), love.mouse.getY()
        local angle = math.atan2(y2-y1, x2-x1)

        local left = angle - math.pi / 2
        local right = angle + math.pi / 2
        local distance = math.sqrt(math.pow(x2-x1, 2) + math.pow(y2-y1, 2))

        local lStart, lEnd = x1 + math.cos(left) * 10, y1 + math.sin(left) * 10
        local lStart2, lEnd2 = lStart + math.cos(angle) * distance, lEnd + math.sin(angle) * distance

        local rStart, rEnd = x1 + math.cos(right) * 10, y1 + math.sin(right) * 10
        local rStart2, rEnd2 = rStart + math.cos(angle) * distance, rEnd + math.sin(angle) * distance

        love.graphics.setLineWidth(3)
        love.graphics.line(x1, y1, x2, y2)

        if (guides) then
            love.graphics.setLineWidth(1)
            love.graphics.line(lStart, lEnd, lStart2, lEnd2)
            love.graphics.line(rStart, rEnd, rStart2, rEnd2)
        end
    end
end

function love.keypressed(key)
    if (key == ' ') then
        guides = not guides
    end

    if (key == 'w' and love.keyboard.isDown('lctrl')) then
        love.event.push('q') -- quit the game
    end
end

function love.mousepressed(x, y, button)
    if (not moving and button == 'l') then
        local x1, y1, x2, y2 = cue:getBody():getX(), cue:getBody():getY(), love.mouse.getX(), love.mouse.getY()
        local angle = math.atan2(y2-y1, x2-x1)
        local distance = math.sqrt(math.pow(x2-x1, 2) + math.pow(y2-y1, 2))
        local factor = math.min(distance / 5, 75);

        cue:getBody():applyImpulse(math.cos(angle) * factor, math.sin(angle) * factor)
    end
end