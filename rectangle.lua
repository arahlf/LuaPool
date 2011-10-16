require 'middleclass'

Rectangle = class('Rectangle')

function Rectangle:initialize(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
end

function Rectangle:setPosition(x, y)
    self.x = x
    self.y = y
end

function Rectangle:contains(x, y)
    return x >= self.x and x <= self.x + self.width and y >= self.y and y <= self.y + self.height
end

function Rectangle:getConstrainedEndpoint(x, y, angle)
    local knownSide

    if (angle > 0) then
        knownSide = self.y + self.height - y
    else
        knownSide = self.y - y
    end

    local missingSide = knownSide / math.tan(angle)


    local xDest = x + missingSide
    local yDest = angle > 0 and self.y + self.height or self.y


    if (x + missingSide > self.x + self.width) then
        knownSide = self.x + self.width - x
        missingSide = math.tan(angle) * knownSide

        xDest = self.x + self.width
        yDest = y + missingSide
    elseif (x + missingSide < self.x) then
        knownSide = x - self.x
        missingSide = math.tan(angle) * knownSide

        xDest = self.x
        yDest = y - missingSide
    end

    return xDest, yDest
end