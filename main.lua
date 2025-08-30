WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require 'push'
require 'paddle'
require 'ball'

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    larg_font = love.graphics.newFont('Monocraft.ttf', 32)
    small_font = love.graphics.newFont('Monocraft.ttf', 8)
    
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
            ball.x = VIRTUAL_WIDTH / 2 - 2
            ball.y = VIRTUAL_HEIGHT / 2 - 2

        else
            gameState = "play"
            -- initialize ball moving in random direction
            ball.dx = math.random(2) == 1 and -100 or 100
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
        ball:update(dt)
    end
    

end

function love.draw()
    push:start()
    love.graphics.clear(40/255, 45/255, 52/255, 1)
    love.graphics.setFont(larg_font)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT/2 - 80)
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT/2 - 80)
    love.graphics.setFont(small_font)
    love.graphics.printf("press enter to start", 0, 20, VIRTUAL_WIDTH, 'center')

    --paddle1
    player1:draw(10, VIRTUAL_HEIGHT / 2 - 10)
    
    -- paddle2
    player2:draw(VIRTUAL_WIDTH - 15, VIRTUAL_HEIGHT / 2 - 10)

    --ball
    ball:draw()
    
    push:finish()
end
