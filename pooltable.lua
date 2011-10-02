require 'middleclass'

PoolTable = class('PoolTable')

local tableImage = love.graphics.newImage('table.png')
local width = tableImage:getWidth()
local height = tableImage:getHeight()

function PoolTable:initialize()
    self.width = width
    self.height = height
    self.thickness = thickness
    self.body = love.physics.newBody(world)
    self.pockets = {}
    self.cushions = {}

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

function PoolTable:setPosition(x, y)
    self.body:setPosition(x, y)
end

function PoolTable:draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(tableImage, self.body:getX(), self.body:getY())

    if (debugging) then
        for index, cushion in ipairs(self.cushions) do
            love.graphics.polygon("fill", cushion:getPoints())
        end

        for index, pocket in ipairs(self.pockets) do
            love.graphics.polygon("fill", pocket:getPoints())
        end
    end
end

function PoolTable:addPocket(...)
    local pocket = love.physics.newPolygonShape(self.body, ...)
    pocket:setSensor(true)
    pocket:setData('foo')

    table.insert(self.pockets, pocket)
end

function PoolTable:addCushion(...)
    local cushion = love.physics.newPolygonShape(self.body, ...)
    cushion:setFriction(.05)

    table.insert(self.cushions, cushion)
end