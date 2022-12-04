require "globals"
local shot = require "objects/shot"
local love = require "love"


function Player(lifes,sfx)
    local VANI_DUR = 3
    local SIZE = 50
    local SHOT_DISTANCE = 0.6

    return{
        x = love.graphics.getWidth()/2,
        y = love.graphics.getHeight()/2,
        radius = SIZE/2,
        dead = false,
        shots = {},
        lifes = lifes or 1,
        vanishing_time = 0,
        quads = {},
        width = player_model.quad_width,
        height = player_model.quad_height,

        -- função para disparar
        Shoot = function(self)
            if game.weapon ==1 then
                 table.insert(self.shots,shot(
                    self.x +self.width/2 -20,
                    self.y      
             ))
        
            elseif game.weapon == 2 then 
                table.insert(self.shots,shot(
                    self.x+self.width/2 -20,
                self.y
            ))
                table.insert(self.shots,shot(
                    self.x +self.width/2 -40,
                    self.y +20 ))  

            elseif game.weapon == 3 or game.weapon == 4 then
                
                table.insert(self.shots,shot(
                    self.x +self.width/2 -20,
                    self.y ))  

                table.insert(self.shots,shot(
                    self.x+self.width/2 -40,
                self.y +20
            ))
                table.insert(self.shots,shot(
                    self.x +self.width/2 -60,
                    self.y -20 ))  


            
                
            end
            if game.weapon >= 1 and game.weapon <4 then
                sfx:playFX("shot")
            else
                sfx:playFX("submachine")
            end
                
    
        end,

        -- função para o tiro desaparecer
        DestroyShot = function(self,index)
            table.remove(self.shots,index)
        end,


        draw = function(self,faded)

            --sprite stuff
            for i = 1, player_animation.max_frames do
                self.quads[i] = love.graphics.newQuad(player_model.quad_width * (i-1),0,player_model.quad_width,player_model.quad_height,player_model.width,player_model.height)
            end 

            --draw player
            if player_animation.direction == "right" then
                love.graphics.draw(player_model.image,self.quads[player_animation.frame],self.x -40,self.y -30) 
            else
                love.graphics.draw(player_model.image,self.quads[player_animation.frame],self.x -50,self.y -30,0,-1,1,player_model.quad_width,0)
            end

            --hitbox
            if show_debugging then
                love.graphics.setColor(1,0,0)

                love.graphics.rectangle("fill",self.x ,self.y ,2,2)

                love.graphics.circle("line",self.x ,self.y,self.radius)

            end
            -- drawing shots
            for _, shot in pairs(self.shots) do
                shot:draw(faded)
            end
        end,


        -- movements
        movePlayer = function(self)
            local run = 1

            self.dead = self.vanishing_time >0

            if not self.dead then
                if love.keyboard.isDown("lshift") then
                    run = 1.5
                else
                    run = 1
                end
                if love.keyboard.isDown("a") or love.keyboard.isDown("left") or love.keyboard.isDown("kp4") then
                    self.x = self.x - 10 * run
    
                    player_animation.direction = "left"
                end
                if love.keyboard.isDown("d") or love.keyboard.isDown("right") or love.keyboard.isDown("kp6") then
                    self.x = self.x + 10 * run
                    player_animation.direction = "right"
                end
                if love.keyboard.isDown("w") or love.keyboard.isDown("up") or love.keyboard.isDown("kp8") then
                    self.y = self.y - 10 * run
                end
                if love.keyboard.isDown("s") or love.keyboard.isDown("down") or love.keyboard.isDown("kp2") then
                    self.y = self.y + 10 * run
                end
            end


            -- border 
            if self.x + self.width <0 then
                self.x = love.graphics.getWidth() +self.width

            elseif self.x - self.width > love.graphics.getWidth() then
                self.x = 0 - self.width
            end
            if self.y + self.height <0 then
                self.y = love.graphics.getHeight() +self.height
            
            elseif self.y - self.height >love.graphics.getHeight() then
                self.y = 0 - self.height
            end
        
            -- shot stuff
            for index,shot in pairs(self.shots) do
                    
                if (shot.distance > SHOT_DISTANCE* 12.5 * love.graphics.getWidth()) and (shot.vanishing == 0) then
                    shot:vanish()
                end

                if shot.vanishing == 0 then
                    shot:move()
            
                elseif shot.vanishing == 2 then
                    self.DestroyShot(self,index)
                end
            end

            -- sprite stuff
                player_animation.timer = player_animation.timer + love.timer.getDelta() *0.5
        
                if player_animation.timer > 0.2 then
                    player_animation.timer = 0.1
        
                    player_animation.frame = player_animation.frame + 1
        
        
                    if player_animation.frame > player_animation.max_frames then
                        player_animation.frame = 1
                    end
                end
        end,

        death = function(self)
            self.vanishing_time = math.ceil(VANI_DUR *love.timer.getFPS())
            sfx:playFX("player_death")
        end
    }
end

return Player