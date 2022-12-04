local love = require "love"
require "globals"

local Text = require "../components.Text"
local Zombie = require "../objects.Zombie"
local Button = require "components.Button"


function Game(sfx)
    return{
        level = 1,
        weapon = 1,
        zombie_kills = 0,
        state = {
            menu = true,
            paused = false,
            running = false,
            ended = false,
        },
        screen_text = {},
        game_over_showing = false ,  

        changeGameState = function(self,state)
            self.state.menu = state == "menu"
            self.state.paused= state == "paused"
            self.state.running = state == "running"
            self.state.ended = state == "ended"

            if self.state.ended then
                self:gameOver()
            end
        end,

        gameOver = function(self)
            love.graphics.setBackgroundColor(1,0,0)
            self.screen_text = {
                Text(
                    "GAME OVER",
                    0,
                    love.graphics.getHeight()*0.4,
                    "h1",
                    true,
                    true,
                    love.graphics.getWidth(),
                    "center"
                )           
            }

            self.game_over_showing = true
        end,

        draw = function(self,faded)
            local opacity = 1

            if faded then
                opacity = 0.5
            end

            for index, text in pairs(self.screen_text) do
                if self.game_over_showing then
                    self.game_over_showing = text:draw(self.screen_text,index)

                    if not self.game_over_showing then
                        self:changeGameState("menu")
                    end

                else
                    text:draw(self.screen_text,index)
                end
            end

            Text(
                "Kills: ".. self.zombie_kills,
                -20,
                10,
                "h4",
                false,
                false,
                love.graphics.getWidth(),
                "center",
                faded and opacity or 0.6
            ):draw()



            if faded then
                Text(
                    "PAUSED",
                    0,
                    love.graphics.getHeight() * 0.4,
                    "h1",
                    false,
                    false,
                    love.graphics.getWidth(),
                    "center"
                ):draw()
            end
        end,
        increasing_Weapon = function(self)
                self.screen_text = {
                    Text(
                        "Press 'u' to upgrade your weapon!",
                        0,
                        love.graphics.getHeight() *0.45,
                        "h3",
                        false,
                        true,
                        love.graphics.getWidth(),
                        "center",
                        0.5,
                        2
                    )
                }
        end,
        increasing_Level = function(self, player) 
            
            if player.lifes <= 0 then
                self:changeGameState("ended")
            else
                self:changeGameState("running")
            end

        
        self.screen_text = {
                    Text(
                        "Level "..self.level,
                        0,
                        love.graphics.getHeight() *0.25,
                        "h1",
                        true,
                        true,
                        love.graphics.getWidth(),
                        "center"
                    )
                }

                sfx:playFX("level")
            end,
            

            

            
                
            
            

        inputZombies = function(self,player)

            if player.lifes <= 0 then
                self:changeGameState("ended")
            else
                self:changeGameState("running")
            end
            
            zombies = {}

            -- definning the number of enemies
            local num_zombies = 50

            
            -- how the number of zombies increases through levels
            for i = 1, num_zombies + self.level *10 do
           
                local zombie_x
                local zombie_y
                local radius = 50
                local  dice = math.random(1,4)

                if dice == 1 then
                    zombie_x = math.random(0, love.graphics.getWidth())
                    zombie_y = - radius 
                elseif dice == 2 then
                    zombie_x = - radius 
                    zombie_y = math.random(0, love.graphics.getHeight())
                elseif dice == 3 then
                    zombie_x = math.random(0, love.graphics.getWidth())
                    zombie_y = love.graphics.getHeight() + (radius )
                else
                    zombie_x = love.graphics.getWidth() + (radius )
                    zombie_y = math.random(0, love.graphics.getHeight())
                end

                
                    table.insert(zombies,1,Zombie(zombie_x,zombie_y,self.level))
            end
        end,   


    }
end
return Game