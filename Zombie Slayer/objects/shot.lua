local love = require "love"

function Shot (x,y,angle)
    local SHOT_SPEED = 500
    --[[local explodingEnum = {
        not_exploding = 0,
        exploding = 1,
        done_exploding = 2
    }]]
     local VANI_DUR = 0.2
     --local angle =  math.atan((mouse_y - player.y), (mouse_x- player.x))
     
    return {
        
        x = x,
        y = y,
        x_vel = SHOT_SPEED * (mouse_x - player.x)*0.1 / love.timer.getFPS(),
        y_vel = SHOT_SPEED * (mouse_y - player.y)*0.1 / love.timer.getFPS(),
        distance = 0,
        vanishing = 0,
        vanishing_time = 0,
        
        draw = function(self,faded)
            local opacity = 1

            if faded then
                opacity = 0.2
            end

            if self.vanishing < 1 then
                love.graphics.setColor(1,1,1)

                love.graphics.setPointSize(3)
                
    
                love.graphics.points(self.x,self.y)

            else
                love.graphics.setColor(1,0,0,opacity)
                love.graphics.circle("fill",self.x,self.y,10*1.5)

                love.graphics.setColor(1,1,0,opacity)
                love.graphics.circle("fill",self.x,self.y,10)

                
            end

           
        end,

        move = function (self)
            

            self.x = self.x + self.x_vel *0.1
            self.y = self.y + self.y_vel *0.1


            if self.vanishing_time > 0 then
                self.vanishing = 1
            end

            --[[
            if self.x <0 then
                self.x = love.graphics.getWidth() 
            elseif self.x   > love.graphics.getWidth() then
                self.x = 0  
            end

            if self.y<0 then
                self.y = love.graphics.getHeight()  
            elseif self.y   >love.graphics.getHeight() then
                self.y = 0  
            end]]

            self.distance = self.distance + math.sqrt((self.x_vel^2) + (self.y_vel^2) )
        end,

        vanish = function (self)
            self.vanishing_time = math.ceil(VANI_DUR * (love.timer.getFPS()/100))

            if self.vanishing_time > VANI_DUR then
                self.vanishing  = 2
            end
                
        end
    }
end
return Shot