require 'middleclass'

Rectangle = class('Rectangle')

function Rectangle:initialize(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
end

function Rectangle:contains(x, y)
    return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
end

function Rectangle:getConstrainedEndpoint(x, y, angle)
    assert(self:contains(x, y), "Rectangle does not contain point.")

    --[[
    cases:
        0
        90
        180
        270
        every other in between?
    ]]--

    if (angle == 0) then -- east
        return self.x + self.width, y
    elseif (angle == math.pi / 2) then -- south
        return x, self.y + self.height
    elseif (angle == math.pi) then -- west
        return self.x, y
    elseif (angle == math.pi + math.pi / 2) then -- north
        return x, self.y
    end
end