
show_debugging = false
zombie_dead = false

COUNT = 1
function calculateDistance(x1,y1,x2,y2)
    local dist_x = (x2-x1)^2
    local dist_y = (y2-y1)^2

    return math.sqrt(dist_x + dist_y)

end