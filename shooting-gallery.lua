function love.load()
    target = {}
        target.x = 100
        target.y = 100
        target.radius = 50
    game = {}
        game.score = 0
        game.timerMax = 15
        game.timer = 0  -- current time in round
        game.scoreFont = love.graphics.newFont(40) -- sets default font and size
        game.scoreIncrement = 10 -- amount score increases on successful target hit
        game.state = 0 -- 0 = main menu/game over. 1 = game loop running.
    sprites = {}
        sprites.target = love.graphics.newImage('sprites/target.png')
        sprites.background = love.graphics.newImage('sprites/sky.png')
        sprites.crosshairs = love.graphics.newImage('sprites/crosshairs.png')
        crosshairsWidth = 40 -- pixel width of png
        crosshairsHeight = 40
    love.mouse.setVisible(false)
end

-- the main game loop.
function love.update(dt)
    if game.timer >= dt then
        game.timer = game.timer - dt
    else
        game.timer = 0
        game.state = 0
    end
end

-- draws screen every frame. Anything here displayed on-screen.
function love.draw()
    -- draw background
    love.graphics.draw(sprites.background, 0, 0)
    
    -- draw player's score and time left in round
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(game.scoreFont)
    love.graphics.print("Score:  " .. game.score, 5, 5)   
    love.graphics.print("Time Left:  " .. math.ceil(game.timer), 300, 5)

    -- main starter menu
    if game.state == 0 then
        love.graphics.printf("Click anywhere to start!", 0, 250,love.graphics.getWidth(),"center")
    end

    -- draw target
    if game.state == 1 then
        love.graphics.draw(sprites.target, target.x - target.radius, target.y - target.radius)
    end

    -- draw crosshairs
    love.graphics.draw(sprites.crosshairs, love.mouse.getX() - (crosshairsWidth/2) , love.mouse.getY() - (crosshairsHeight/2))
end

function love.mousepressed( x, y, button, istouch, presses )
    if button == 1 and game.state == 1 then
        local mouseToTarget = distanceBetween(x, y, target.x, target.y)
        if mouseToTarget <= target.radius then
            game.score = game.score + game.scoreIncrement
            target.x = math.random(target.radius, love.graphics.getWidth() - target.radius)
            target.y = math.random(target.radius, love.graphics.getHeight() - target.radius)
        end
    elseif button == 1 and game.state == 0 then
        -- reset or start game. reset score and timer.
        game.state = 1
        game.timer = game.timerMax
        game.score = 0
    end
end

-- given x, y for 2 game objects, determines distance between them
function distanceBetween(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end
