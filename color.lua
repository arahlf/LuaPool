require 'middleclass'

Color = class('Color')

function Color:initialize(r, g, b)
    self.r = r
    self.g = g
    self.b = b
end

function Color:set()
    love.graphics.setColor(self.r, self.g, self.b)
end
