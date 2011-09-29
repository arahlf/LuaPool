require 'ball'
require 'color'

math.randomseed(os.time());
math.random() math.random() math.random()

world = love.physics.newWorld(0, 0, love.graphics.getWidth(), love.graphics.getHeight())
balls = {}
walls = {}
ballsMoving = false

local radius = 10
local ballColors = {
    { 244, 251, 40 },
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

local eightBall = Ball(radius, Color(0, 0, 0), false)
table.insert(balls, 5, eightBall)


function love.load()
    local tableX = 0
    local tableY = 0
    local tableWidth = 600
    local tableHeight = 200
    local tableThickness = 10

    -- build the walls
    addWall(tableX, tableY, tableWidth, tableThickness)
    addWall(tableX, tableY + tableHeight, tableWidth, tableThickness)
    addWall(tableX, tableY + tableThickness, tableThickness, tableHeight - tableThickness)
    addWall(tableX + tableWidth - tableThickness, tableY + tableThickness, tableThickness, tableHeight - tableThickness)

    
    local x = tableX + 400
    local y = tableY + 100
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
    cue:getBody():setPosition(10, 10)

    table.insert(balls, cue)

    love.graphics.setBackgroundColor(193, 187, 249)
    love.graphics.setLineWidth(3)

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

    -- draw the walls
    love.graphics.setColor(160, 101, 31)

    for index, wall in ipairs(walls) do
        love.graphics.polygon("fill", wall.shape:getPoints())
    end
    love.graphics.setColor(4, 172, 140)
    love.graphics.rectangle("fill", 10, 10, 580, 190)

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
    if (not moving and key == ' ') then
        local x1, y1, x2, y2 = cue:getBody():getX(), cue:getBody():getY(), love.mouse.getX(), love.mouse.getY()
        local angle = math.atan2(y2-y1, x2-x1)
        local distance = math.sqrt(math.pow(x2-x1, 2) + math.pow(y2-y1, 2))
        local factor = math.min(distance / 5, 75);

        cue:getBody():applyImpulse(math.cos(angle) * factor, math.sin(angle) * factor)
    elseif (key == 'w' and love.keyboard.isDown('lctrl')) then
        love.event.push('q') -- quit the game
    end
end

function addWall(x, y, width, height)
    local wall = {}

    wall.body = love.physics.newBody(world, x, y)
    wall.shape = love.physics.newRectangleShape(wall.body, width / 2, height / 2, width, height)
    wall.shape:setFriction(.05)

    table.insert(walls, wall)
end