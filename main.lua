require 'pooltable'
require 'ball'

math.randomseed(os.time());
math.random() math.random() math.random()

debugging = false
guides = false

-- TODO cue ball power streak

local world = love.physics.newWorld(0, 0, love.graphics.getWidth(), love.graphics.getHeight())


local radius = 10

function love.load()
    -- create the balls
    cue = Ball(world, radius, nil, false)

    balls = {}

    for i=1, 15 do
        table.insert(balls, Ball(world, radius, i, i >= 8))
    end

    poolTable = PoolTable(world, cue, balls)
    local tableWidth = poolTable:getWidth()
    local tableHeight = poolTable:getHeight()
    local tableThickness = 25
    local tableX = (love.graphics.getWidth() - tableWidth) / 2
    local tableY = (love.graphics.getHeight() - tableHeight) / 2

    poolTable:setPosition(math.floor(tableX), math.floor(tableY)) -- non-integer pixel measurements display blurry :(

    love.graphics.setBackgroundColor(71, 101, 71)
    love.graphics.setCaption('LuaPool')

    poolTable:rack()
    poolTable:moveCue()
    poolTable:beginPlacingCue()
end

function love.update(dt)
    world:update(dt)
    poolTable:update(dt)
end

function love.draw()
    local width = love.graphics.getWidth()
    local height = love.graphics.getHeight()

    poolTable:draw()

    if (not poolTable:areBallsMoving() and not poolTable:isPlacingCue()) then
        love.graphics.setColor(255, 255, 255)
        local x1, y1, x2, y2 = cue:getX(), cue:getY(), love.mouse.getX(), love.mouse.getY()
        local angle = math.atan2(y2-y1, x2-x1)

        local left = angle - math.pi / 2
        local right = angle + math.pi / 2
        local distance = math.sqrt(math.pow(x2-x1, 2) + math.pow(y2-y1, 2))

        local lStart, lEnd = x1 + math.cos(left) * 10, y1 + math.sin(left) * 10
        local lStart2, lEnd2 = lStart + math.cos(angle) * distance, lEnd + math.sin(angle) * distance

        local rStart, rEnd = x1 + math.cos(right) * 10, y1 + math.sin(right) * 10
        local rStart2, rEnd2 = rStart + math.cos(angle) * distance, rEnd + math.sin(angle) * distance

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

    if (key == 'esc') then
        poolTable:rack()
        poolTable:moveCue()
    end
end

function love.mousepressed(x, y, button)
    if (button == 'l') then
        if (poolTable:isPlacingCue()) then
            poolTable:placeCue()
        elseif (not poolTable:areBallsMoving()) then
            local x1, y1, x2, y2 = cue:getX(), cue:getY(), love.mouse.getX(), love.mouse.getY()
            local angle = math.atan2(y2-y1, x2-x1)
            local distance = math.sqrt(math.pow(x2-x1, 2) + math.pow(y2-y1, 2))
            local factor = math.min(distance / 5, 75);

            cue:hit(math.cos(angle) * factor, math.sin(angle) * factor)
        end
    end
end