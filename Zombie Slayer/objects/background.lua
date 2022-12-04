Background = {}
local love = require "love"

function Background:load()
    self.universe = love.graphics.newImage("sprites/grass.png")


end

function Background:update(dt)
    

end

function Background:draw()
    love.graphics.draw(self.universe,0,0)

end