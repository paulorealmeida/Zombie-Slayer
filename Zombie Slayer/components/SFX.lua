local love = require "love"

function SFX()

        local bgm = love.audio.newSource("/sound/bgm.mp3", "stream")
        bgm:setVolume(0.1)
        bgm:setLooping(true)

        local effects = {
            player_death = love.audio.newSource("/sound/player_dead.wav", "static"),
            shot = love.audio.newSource("/sound/gunshot.mp3", "static"),
            select = love.audio.newSource("/sound/option_select.wav", "static"),
            level = love.audio.newSource("/sound/level.wav", "static"),
            submachine = love.audio.newSource("/sound/submachine.wav", "static")

        }


    return {

        fx_played = false,

        setFXPlayed = function(self,has_played)
            self.fx_played = has_played
        end,

        playBGM = function(self)
            if not bgm:isPlaying() then
                bgm:play()
            end
        end,

        stopFX = function(self,effect)
            if effects[effect]:isPlaying() then
                effects[effect]:stop()
            end     
         end,

        playFX = function(self,effect,mode)
            if mode == "single" then
                if not self.fx_played then
                    self:setFXPlayed(true)

                    if not effects[effect]:isPlaying() then
                        effects[effect]:play()
                    end
                end
            elseif mode == "slow" then
                if not effects[effect]:isPlaying() then
                    effects[effect]:play()
                end
            else
                self:stopFX(effect)
                
                effects[effect]:play()
            end
    
         end



    }

end

return SFX