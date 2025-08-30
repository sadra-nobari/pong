WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require 'push'
require 'paddle'
require 'ball'

function love.load()
    love.window.setTitle("Pong")
    love.graphics.setDefaultFilter('nearest', 'nearest')

    larg_font = love.graphics.newFont('Monocraft.ttf', 32)
    small_font = love.graphics.newFont('Monocraft.ttf', 8)
    tiny_font = love.graphics.newFont('Monocraft.ttf', 6)

    sounds = {
        ["paddle"] = love.audio.newSource('sounds/paddle.wav', 'static'),
        ["wall"] = love.audio.newSource('sounds/wall.wav', 'static'),
        ["lose"] = love.audio.newSource('sounds/losing.wav', 'static')

    }
    player1Score = 0
    player2Score = 0

    -- player1Y = VIRTUAL_HEIGHT / 2 - 10
    -- player2Y = VIRTUAL_HEIGHT / 2 - 10
    player1 = Paddle(10, VIRTUAL_HEIGHT / 2 - 10, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT / 2 -10, 5, 20)


    paddleSpeed = 200

    math.randomseed(os.time())

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4 )
    -- ballX = VIRTUAL_WIDTH / 2 - 2
    -- ballY = VIRTUAL_HEIGHT / 2 - 2
    ball.dx = math.random(2) == 1 and -100 or 100
    ball.dy = math.random(-50, 50)


    love.window.setTitle('Pong')
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = false,
        vsync = true,
        fullscreen = false
    })
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        highdpi = true,
        canvas = true
    })

    gameState = 'start'
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end


    if key == "enter" or key == "return" then
        if gameState == "play" then

            gameState = "start"

            -- reset paddles position
            player1.y = VIRTUAL_HEIGHT / 2 - 10
            player2.y = VIRTUAL_HEIGHT / 2 - 10

            -- reset ball position
            ball:reset()

        elseif gameState == "serve" then
            gameState = "play"
        
        elseif gameState == "end" then
            gameState = "start"
            ball.dx = math.random(2) == 1 and -200 or 200
            ball.dy = math.random(-50, 50)
            player1.y = VIRTUAL_HEIGHT / 2 - 10
            player2.y = VIRTUAL_HEIGHT / 2 - 10
            player1Score = 0
            player2Score = 0


        else
            gameState = "play"
            -- initialize ball moving in random direction
            ball.dx = math.random(2) == 1 and -200 or 200
            ball.dy = math.random(-50, 50)
        end
    end
end

function love.update(dt)

    -- for player 1
    if love.keyboard.isDown('w') then
        player1.dy = -paddleSpeed
        player1:update(dt)
    elseif love.keyboard.isDown('s') then
        player1.dy = paddleSpeed
        player1:update(dt)
    end
    
    -- for player 2

    if love.keyboard.isDown('up') then
        player2.dy = -paddleSpeed
        player2:update(dt)
    elseif love.keyboard.isDown('down') then
        player2.dy = paddleSpeed
        player2:update(dt)
    end
    
    -- for ball
    if gameState == 'play' then
        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = ball.x + 5
            ball.dy = math.random(-100, 100)
            sounds['paddle']:play()
        end
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = ball.x - 5
            ball.dy = math.random(-100, 100)
            sounds['paddle']:play()

        end

        if ball.y <= 0 or ball.y >= VIRTUAL_HEIGHT - ball.height then
            ball.dy = -ball.dy
            sounds['wall']:play()

        end

        if ball.x <= 0 then
            servePlayer = 2
            player2Score = player2Score + 1
            gameState = "serve"
            ball:reset()
            sounds['lose']:play()

        elseif ball.x + 4 >= VIRTUAL_WIDTH then
            servePlayer = 1
            player1Score = player1Score + 1
            gameState = "serve"
            ball:reset()
            sounds['lose']:play()

        end


        if player1Score == 2 then
            winner = 1
            gameState = "end"
            ball:reset()
        elseif player2Score == 2 then
            winner = 2
            gameState = "end"
            ball:reset()
        end
        ball:update(dt)
    end
    
    displayFPS()

end

function love.draw()
    push:start()
    love.graphics.clear(40/255, 45/255, 52/255, 1)
    love.graphics.setFont(larg_font)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT/2 - 80)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT/2 - 80)
    
    --paddle1
    player1:draw(10, VIRTUAL_HEIGHT / 2 - 10)
    
    -- paddle2
    player2:draw(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT / 2 - 10)

    --ball
    ball:draw()
    
    if gameState == "start" then 
        love.graphics.setFont(small_font)
        love.graphics.printf("press enter to start", 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == "serve" then
        love.graphics.setFont(small_font)
        love.graphics.printf("player"..tostring(servePlayer).." has to serve the ball", 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == "end" then
        love.graphics.setFont(small_font)
        love.graphics.printf("player "..tostring(winner).." won", 0, 20, VIRTUAL_WIDTH, 'center')

    else
        
    end
        

    displayFPS()
    push:finish()
end


function displayFPS()
    love.graphics.setFont(tiny_font)
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(1, 1, 1, 1)

end