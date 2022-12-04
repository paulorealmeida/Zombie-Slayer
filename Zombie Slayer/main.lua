---@diagnostic disable: lowercase-global
local love = require "love"

require "globals"
require "objects.background"

local Player = require "objects.Player"
local Game = require "states.Game"
local Menu = require "states.Menu"
local SFX = require "components.SFX"

--temporizador
--timer = 0

local resetComplete = false

math.randomseed(os.time())

function reset()

    sfx = SFX()
    player = Player(1,sfx)
    game = Game(sfx)
    menu = Menu(game,player,sfx)
end





function love.load()
    love.mouse.setVisible(false)
    Background:load()
    mouse_x, mouse_y = 0,0

    --zombie sprite
    zombie_model = {
        image = love.graphics.newImage("sprites/zombiewalk.png"),
        height =51, -- propriedades de imagem -4300 x 519
        width = 430, -- propriedades de imagem
        quad_width = 43, -- dividir width pelo número de frames
        quad_height = 51,
    }
    zombie_animation= {
        direction = "right",
        frame = 1,
        max_frames=10, -- número de frames
        timer = 0.1
    }
    --player sprite
    player_model = {
        image = love.graphics.newImage("sprites/playerwalk.png"),
        height =64, -- propriedades de imagem -9340 x 641
        width = 930, -- propriedades de imagem
        quad_width = 93, -- dividir width pelo número de frames
        quad_height = 64,
    }
    player_animation= {
        direction = "right",
        frame = 1,
        max_frames=10, -- número de frames
        timer = 0.1
    }
    

    reset()
    sfx:playBGM()

end

function love.keypressed(key)

    if key == "space" or key == "down" or key == "kp5" then
        player:Shoot()
    end
    if key == "u" and game.zombie_kills >= 500 then
        game.weapon = 4
    elseif key == "u"  and game.zombie_kills >= 200 then
        game.weapon = 3
    elseif key =="u" and game.zombie_kills >= 75 then
        game.weapon = 2
    end

    
    
        


    if game.state.running then
        if key =="escape" then
            game:changeGameState("paused")
        end
    
    elseif game.state.paused then
            if key =="escape" then
                game:changeGameState("running")
            end
     end
end

function love.mousepressed(x,y,button,istouch,presses)
    if button == 1 then
        if game.state.running then
            player:Shoot()
        else
            clickedMouse = true
        end
    end
end


function love.update(dt)

    
    if game.state.running then
        player:movePlayer(dt)
    
        if game.zombie_kills >= 75 and game.weapon == 1 then
            game:increasing_Weapon()
        elseif game.zombie_kills >=200 and (game.weapon == 2  or game.weapon ==1) then
            game:increasing_Weapon()
        elseif game.zombie_kills >= 500 and (game.weapon == 3 or game.weapon <4) then
            game:increasing_Weapon()
        end




        
        

        if game.weapon == 4 then
            if love.keyboard.isDown("space") then
                player:Shoot()
            end
        end


        for i = 1, #zombies do
            if not player.dead then
                zombies[i]:move(player.x,player.y)
            end
        end

        

        for zomb_index, zombie in pairs(zombies) do
            if not player.dead then
                if calculateDistance(player.x,player.y ,zombie.x  ,zombie.y ) < zombie.radius then
                    player:death()
                end
            else
                player.vanishing_time = player.vanishing_time -1

                if player.vanishing_time == 0 then

                    if player.lifes -1 <= 0 then
                        game:changeGameState("ended")
                        return
                    end

                    player = Player(player.lifes -1, sfx)
                end
            end
        

            for _, shot in pairs(player.shots) do
                if calculateDistance(shot.x,shot.y,zombie.x,zombie.y ) < zombie.radius then
                    shot:vanish()
                    zombie:destroy(zombies,zomb_index,game)
                
                end
            end

            if zombie_dead then
                if player.lifes -1 <= 0 then
                    if player.vanishing_time == 0 then
                        zombie_dead = false
                        zombie:destroy(zombies,zomb_index,game)
                    end
                else
                    zombie_dead = false
                    zombie:destroy(zombies,zomb_index,game)
                end
            end



            zombie:move(player.x,player.y,dt)
        end

        if COUNT > 0 then
            if COUNT % 2 == 0 then
                        game.level = game.level +1
                        game:increasing_Level(player)
                        COUNT = COUNT +1
            end
        end
        
        if #zombies <1 then
            game:inputZombies(player)
            if game.level <=15 then
                COUNT = COUNT +1
            else
                COUNT = COUNT +0.5
            end
        end

        

       

    elseif game.state.menu then
        menu:run(clickedMouse)
        clickedMouse = false

        if not resetComplete then
            reset()

            resetComplete = true
        end

    elseif game.state.ended then
        resetComplete = false
    end
    
    
    
    mouse_x,mouse_y = love.mouse.getPosition()

end





function love.draw()
    if game.state.running or game.state.paused then
        Background:draw()
        player:draw(game.state.paused)
        

        love.graphics.setColor(1,1,1)
        --love.graphics.print("Time: ".. math.ceil(timer),10,30)

        

        for _, zombie in pairs(zombies) do
            zombie:draw(game.state.paused)
        end

        game:draw(game.state.paused)

    elseif game.state.menu then
        love.graphics.setBackgroundColor(1,0,0)
        menu:draw()
        

    elseif game.state.ended then
        game:draw()
    end

    love.graphics.setColor(1,1,1,1)

    if not game.state.running then
        love.graphics.circle("fill",mouse_x,mouse_y,10) 
    else
        
        love.graphics.circle("line",mouse_x,mouse_y,10)
    end

    
    love.graphics.print("FPS: ".. love.timer.getFPS(),10,10)
end