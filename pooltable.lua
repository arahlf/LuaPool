require 'middleclass'
require 'pocket'

PoolTable = class('PoolTable')

function PoolTable:initialize(x, y, width, height, thickness)
    self.width = width
    self.height = height
    self.thickness = thickness
    self.body = love.physics.newBody(world, x, y)
    self.walls = {}
    self.pockets = {}

    self:addWall(x, y, width, thickness)
    self:addWall(x, y + height, width, thickness)
    self:addWall(x, y + thickness, thickness, height - thickness)
    self:addWall(x + width - thickness, y + thickness, thickness, height - thickness)

    self:addPocket(x + thickness, y + thickness)
    self:addPocket(x + width / 2, y + thickness)
    self:addPocket(x + width - thickness, y + thickness)
    self:addPocket(x + thickness, y + height)
    self:addPocket(x + width / 2, y + height)
    self:addPocket(x + width - thickness, y + height)
end

function PoolTable:addWall(x, y, width, height)
    local wall = {}

    wall.body = love.physics.newBody(world, x, y)
    wall.shape = love.physics.newRectangleShape(wall.body, width / 2, height / 2, width, height)
    wall.shape:setFriction(.05)

    table.insert(self.walls, wall)
end

function PoolTable:addPocket(x, y, radius)
    table.insert(self.pockets, Pocket(x, y, radius))
end

function PoolTable:draw()
    -- draw the felt background
    love.graphics.setColor(4, 172, 140)
    love.graphics.rectangle("fill", self.body:getX(), self.body:getY(), self.width, self.height)

    -- draw the walls
    love.graphics.setColor(139, 67, 8)
    for index, wall in ipairs(self.walls) do
        love.graphics.polygon("fill", wall.shape:getPoints())
    end

    -- draw the pockets
    for index, pocket in ipairs(self.pockets) do
        pocket:draw()
    end
end