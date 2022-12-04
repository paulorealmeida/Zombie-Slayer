require "globals"
local love = require "love"

function Zombie(x,y,level)
    debugging = debugging or false
    local size = 50
    


    return{
        level = level or 1,
        x = x,
        y = y,
        radius = math.ceil(size/2),
        quads = {},


        
        
        

        draw = function(self,faded)
            local opacity = 1

            if faded then
                opacity = 0.2
            end 
             
            
            love.graphics.setColor(186/255,189/255,182/255,opacity)

            --sprite stuff
            for i = 1, zombie_animation.max_frames do
                self.quads[i] = love.graphics.newQuad(zombie_model.quad_width * (i-1),0,zombie_model.quad_width,zombie_model.quad_height,zombie_model.width,zombie_model.height)
            end 
            
            -- draw zombies
            if player.x - self.x >0 then  
                love.graphics.draw(zombie_model.image,self.quads[zombie_animation.frame],self.x -20,self.y -25) 
            else
                love.graphics.draw(zombie_model.image,self.quads[zombie_animation.frame],self.x -20,self.y -25,0,-1,1,zombie_model.quad_width,0)
            end

            -- understanding hitbox
            if show_debugging then
                love.graphics.setColor(1,0,0)
                love.graphics.circle("line",self.x  ,self.y ,self.radius)
            end
        end,

        -- zombie movement
        move = function(self,player_x,player_y)
            if player_x -self.x > 0 then
                self.x = self.x + self.level *0.15
            elseif player_x - self.x < 0 then
                self.x = self.x - self.level *0.15   
            end
            if player_y  - self.y > 0 then
                self.y = self.y + self.level *0.15
            elseif player_y - self.y < 0 then
                self.y = self.y - self.level  *0.15   
            end

            -- sprite stuff
            zombie_animation.timer = zombie_animation.timer +love.timer.getDelta() *0.01 * game.level 

            if zombie_animation.timer > 0.2 then
                zombie_animation.timer = 0.1

                zombie_animation.frame = zombie_animation.frame + 1

                

                if zombie_animation.frame > zombie_animation.max_frames then
                    zombie_animation.frame = 1
                end
            end        
    end,

        destroy = function(self,zombie_tbl,index,game)

            --cout zombie kills
            game.zombie_kills = game.zombie_kills +1
            table.remove(zombie_tbl,index)

        end
    }
end

return Zombie