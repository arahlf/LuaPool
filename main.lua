require 'ball'
require 'color'
require 'pooltable'

math.randomseed(os.time());
math.random() math.random() math.random()

function getDistance(circle1, circle2)
    -- hack...
    local radius1, radius2 = circle1.shape:getRadius(), circle2.shape:getRadius()
    local x1, y1, x2, y2 = circle1:getBody():getX(),
                           circle1:getBody():getY(),
                           circle2:getBody():getX(),
                           circle2:getBody():getY()
    --print(x1 .. ', ' .. y1 .. ' - ' .. x2 .. ', ' .. y2)
    return math.sqrt(math.pow(x2-x1, 2), math.pow(y2-y1, 2))
end

function onAdd(a, b, contact)
    local ball, pocket

    if (instanceOf(Pocket, a) and instanceOf(Ball, b)) then
        pocket, ball = a, b
    elseif (instanceOf(Ball, a) and instanceOf(Pocket, b)) then
        pocket, ball = b, a
    end

    if (ball and pocket) then
        local distance = getDistance(ball, pocket)

        if (distance <= 10) then
            ball:getBody():setPosition(pocket:getBody():getPosition())
        end
    end
end

world = love.physics.newWorld(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
world:setCallbacks(onAdd, onAdd, onRemove)



balls = {}
walls = {}
ballsMoving = false

local radius = 10
local ballColors = {
    { 225, 230, 40 },
    { 62, 76, 203 },
    { 242, 38, 19 },
    { 119, 0, 174 },
    { 235, 133, 0 },
    { 49, 198, 45 },
    { 150, 79, 22 }
}

-- create the balls
for i=1, 7 do
    local color = Color(ballColors[i][1], ballColors[i][2], ballColors[i][3])
    table.insert(balls, Ball(radius, color, true))
    table.insert(balls, Ball(radius, color, false))
end

local eightBall = Ball(radius, Color(0, 0, 0), true)
table.insert(balls, 5, eightBall)

local tableWidth = 620
local tableHeight = 220
local tableThickness = 25
local tableX = (love.graphics.getWidth() - tableWidth) / 2
local tableY = (love.graphics.getHeight() - tableHeight) / 2

local poolTable = PoolTable(tableX, tableY, tableWidth, tableHeight, tableThickness)


function love.load()
    local x = tableX + tableWidth - 200
    local y = tableY + tableHeight / 2 + radius / 2
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
    
    cue = Ball(radius, Color(255, 255, 255), false)
    cue:getBody():setPosition(tableX + 100, tableY + tableHeight / 2 + radius / 2)

    table.insert(balls, cue)

    love.graphics.setBackgroundColor(206, 206, 206)
    love.graphics.setLineWidth(3)
    love.graphics.setCaption('LuaPool')

    --love.graphics.setBlendMode("multiplicative")
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
        love.graphics.line(cue:getBody():getX(), cue:getBody():getY(), love.mouse.getX(), love.mouse.getY())
    end
end

function love.keypressed(key)
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