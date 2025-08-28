WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720


function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        resizable = false,
        vsync = true,
        fullscreen = false
    })
end

function love.draw()
    love.graphics.printf("This is Pong!", 0, WINDOW_HEIGHT/2, WINDOW_WIDTH, "center")
end