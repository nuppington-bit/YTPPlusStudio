
function love.load()
    Graphics = require("gfx")
    Enums = require("enums")
    Data = require("data")
    Canvas = love.graphics.newCanvas(Enums.Width,Enums.Height)
    Canvas:setFilter("nearest", "nearest")
    Main = {
        ActiveScreen = Enums.Menu,
        NextScreen = Enums.Menu,
        Fade = Enums.FadeNone,
        ScreenWait = 0,
        W = 0,
        X = 0,
        Y = 0,
    }
    love.window.setMode( Enums.Width*Data.Scaling, Enums.Height*Data.Scaling, Enums.WindowFlags )
    love.mouse.setCursor( Graphics.Cursor )
end
function love.draw()
    love.graphics.setCanvas(Canvas) --This sets the draw target to the canvas
    love.graphics.clear()
    love.graphics.setBackgroundColor(0.25,0.25,0.25) --#404040
    --tiled background
    love.graphics.setColor(0.4,0.4,0.4)
    love.graphics.draw(Graphics.Tiles, Graphics.TiledQuad, Main.X - Enums.BackgroundSize, Main.Y - Enums.BackgroundSize)
    love.graphics.draw(Graphics.Tiles, Graphics.TiledQuad, Main.X + Enums.BackgroundSize, Main.Y + Enums.BackgroundSize)
    love.graphics.draw(Graphics.Tiles, Graphics.TiledQuad, Main.X + Enums.BackgroundSize, Main.Y - Enums.BackgroundSize)
    love.graphics.draw(Graphics.Tiles, Graphics.TiledQuad, Main.X - Enums.BackgroundSize, Main.Y + Enums.BackgroundSize)
    --end bg
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("fill",2,2,Enums.Width-4,17) --title bar
    --border
    love.graphics.setColor(0.5,0.5,0.5)
    love.graphics.rectangle("fill",0,0,2,Enums.Height)
    love.graphics.rectangle("fill",Enums.Width-2,0,2,Enums.Height)
    love.graphics.rectangle("fill",1,0,Enums.Width-2,2)
    love.graphics.rectangle("fill",1,Enums.Height-2,Enums.Width-2,2)
    --end border
    if Main.ActiveScreen ~= Enums.Menu then
        --header
        love.graphics.setColor(1,1,1) --#FFFFFF
        love.graphics.setFont(Graphics.Munro.Regular)
        love.graphics.printf(Enums.ScreenNames[Main.ActiveScreen], 0, 6-3, Enums.Width, "center")
        --back button
        love.graphics.setColor(0.5,0.5,0.5)
        love.graphics.rectangle("fill",2,2,17,17)
        love.graphics.setColor(1,1,1)
        love.graphics.draw(Graphics.Back,2,2)
        --end back button
        --draw screen types
    else --menu
        --header
        love.graphics.setColor(1,1,1) --#FFFFFF
        love.graphics.draw(Graphics.Icon,129,4)
        love.graphics.setFont(Graphics.Munro.Regular)
        love.graphics.print("ytp+ studio",146,6-3)
        --buttons
        love.graphics.print("generate\n\nplugins\n\noptions\n\nquit",22,89-3)
    end
    --fading
    love.graphics.setColor(1,1,1,Main.ScreenWait)
    love.graphics.rectangle("fill",0,0,Enums.Width,Enums.Height)
    love.graphics.setCanvas() --This sets the target back to the screen
    love.graphics.setColor(1,1,1) --#FFFFFF
    love.graphics.draw(Canvas, 0, 0, 0, Data.Scaling, Data.Scaling)
end
function love.update()
    --fading
    if Main.Fade == Enums.FadeOut and Main.ScreenWait < 1 then
        Main.ScreenWait = Main.ScreenWait + 0.1
    elseif Main.Fade == Enums.FadeOut then
        Main.Fade = Enums.FadeIn
        Main.ActiveScreen  = Main.NextScreen
    end
    if Main.Fade == Enums.FadeIn and Main.ScreenWait > 0 then
        Main.ScreenWait = Main.ScreenWait - 0.1
    elseif Main.Fade == Enums.FadeIn then
        Main.ScreenWait = 0
        Main.Fade = Enums.FadeNone
    end
    -- scrolling bg
    Main.W = Main.W + 1
    if Main.W == 3 then
        Main.X = Main.X + 1
        Main.Y = Main.Y + 1
        Main.W = 0
    end
    if Main.X >= Enums.BackgroundSize then Main.X = 0 end
    if Main.Y >= Enums.BackgroundSize then Main.Y = 0 end
end
function love.mousepressed( x, y, button, istouch, presses )
    x = x/Data.Scaling
    y = y/Data.Scaling
    if Main.ActiveScreen == Enums.Menu then
        if x >= 22 and y >= 89 and x < 58 and y < 98 then --generate
            Main.NextScreen = Enums.Generate
            Main.Fade = Enums.FadeOut
        end
    elseif x >= 2 and y >= 2 and x < 19 and y < 19 then --back button
        Main.NextScreen = Enums.Menu
        Main.Fade = Enums.FadeOut
    end
end