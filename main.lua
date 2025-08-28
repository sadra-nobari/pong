WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require 'push'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    larg_font = love.graphics.newFont('Monocraft.ttf', 32)
    small_font = love.graphics.newFont('Monocraft.ttf', 8)
    
    player1Score = 0
    player2Score = 0

    player1Y = VIRTUAL_HEIGHT / 2 - 10
    player2Y = VIRTUAL_HEIGHT / 2 - 10

    paddleSpeed = 200

    math.randomseed(os.time())

    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 - 2
    ballDX = math.random(2) == 1 and -100 or 100
    ballDY = math.random(-50, 50)


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
            player1Y = VIRTUAL_HEIGHT / 2 - 10
            player2Y = VIRTUAL_HEIGHT / 2 - 10

            -- reset ball position
            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 - 2

        else
            gameState = "play"
            -- initialize ball moving in random direction
            ballDX = math.random(2) == 1 and -100 or 100
            ballDY = math.random(-50, 50)
        end
    end
end

function love.update(dt)

    if love.keyboard.isDown('w') then
        player1Y = math.max(0, player1Y + -paddleSpeed * dt )
    elseif love.keyboard.isDown('s') then
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + paddleSpeed * dt )
    end

    if love.keyboard.isDown('up') then
        player2Y = math.max(0, player2Y + -paddleSpeed * dt)
    elseif love.keyboard.isDown('down') then
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + paddleSpeed * dt)
    end

    if gameState == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end

end

function love.draw()
    push:start()
    love.graphics.clear(40/255, 45/255, 52/255, 1)
    love.graphics.setFont(larg_font)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT/2 - 80)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT/2 - 80)

    --paddle1
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)

    --paddle2
    love.graphics.rectangle('fill', VIRTUAL_WIDTH - 15, player2Y, 5, 20)

    --ball
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)


    push:finish()
end