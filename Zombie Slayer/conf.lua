local love = require "love"

function love.conf(app)
    app.window.width = 1200 --16:9
    app.window.height = 720
    app.window.title = "Zombie Slayer"
end