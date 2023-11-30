local function PostEffect(ply, gamePanel)
    gamePanel.IsEnd = true
    timer.Remove("Falling.SCP055_Key_MovePlayer" .. ply:EntIndex())
    timer.Simple(10, function()
        if (not IsValid(gamePanel) or not IsValid(ply)) then return end
        hook.Add("PostDrawHUD", "PostDrawHUD.SCP055_GameEventLastWord_" .. ply:EntIndex(), function()
            surface.SetDrawColor( 0, 0, 0)
            surface.DrawRect(0, 0, SCP_055_CONFIG.ScrW, SCP_055_CONFIG.ScrH)
            draw.DrawText( scp_055.GetTranslation("ohsothatis"), "SCP055_LastWord", SCP_055_CONFIG.ScrW * 0.5, SCP_055_CONFIG.ScrH * 0.5, Color(255, 255, 255, 199), TEXT_ALIGN_CENTER )
        end)
        gamePanel:GetParent():Remove()
        timer.Simple(4, function()
            if (not IsValid(ply)) then return end
            hook.Remove("PostDrawHUD", "PostDrawHUD.SCP055_GameEventLastWord_".. ply:EntIndex())
            ply:EmitSound( Sound( "scp_055/end_effect.mp3" ))
            net.Start(SCP_055_CONFIG.EndGameEvent)
            net.SendToServer()
        end)
    end)
end

-- Fonction pour créer un mur
local function RemoveMap(ply, isEndGame)
    if (isEndGame) then
        PostEffect(ply, ply.SCP055_player1:GetParent())
        return
    end
    for _, wall in ipairs(ply.SCP055_walls) do
        wall:Remove()
    end
    for _, wall in ipairs(ply.SCP055_ennemies) do
        wall:Remove()
    end
    ply.SCP055_walls = nil
    ply.SCP055_ennemies = nil
    ply.SCP055_player1:Remove()
end

local function FallPlayer(ply, gamePanel)
    timer.Remove("OnKeyCodePressed.SCP055_Key_MovePlayer" .. ply:EntIndex())
    timer.Create("Falling.SCP055_Key_MovePlayer" .. ply:EntIndex(), ply.SCP055_delay, 0, function()
        if (not IsValid(gamePanel)) then return end
        scp_055.SetPixelPlayerMove(ply, 0, 1)
    end)
end

-- Fonction pour créer un mur
local function CreateWall(gamePanel, x, y, width, height, color, walls, nextMap)
    local wall = vgui.Create("EditablePanel", gamePanel)
    local alpha = color.a
    wall:SetSize(width, height)
    wall:SetPos(x, y)
    local speedDecay = SCP_055_CONFIG.SpeedDecayGameEvent
    function wall:Paint(width, height)
        if (gamePanel.IsEnd) then alpha = math.Clamp(alpha - speedDecay, 0, 100) end
        color.a = alpha
        draw.RoundedBoxEx(0, 0, 0, width, height, color, false, false, true, true)
    end
    wall.nextMap = nextMap or nil

    table.insert(walls, wall)
end

function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 )
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

-- Fonction pour créer un mur en forme de cercle
local function CreateCircularWall(gamePanel, x, y, radius, r, g, b, walls, nextMap)
    local wall = vgui.Create("DPanel", gamePanel)
    wall:SetSize(radius * 2, radius * 2)
    wall:SetPos(x, y)

    wall.x, wall.y = x, y
    wall.nextMap = nextMap or nil
    local alpha = 255
    local speedDecay = SCP_055_CONFIG.SpeedDecayGameEvent
    function wall:Paint(width, height)
        if (gamePanel.IsEnd) then alpha = math.Clamp(alpha - speedDecay, 0, 100) end
        draw.NoTexture()
        surface.SetDrawColor( r, g, b, alpha)
        draw.NoTexture()
        draw.Circle( width / 2, height / 2, 200, math.sin( CurTime() ) * 10 + 30 )
    end

    table.insert(walls, wall)
end

local function CreateEnnemy(gamePanel, ply, x, y, velocity, ennemies, index)
    local ennemy = vgui.Create("EditablePanel", gamePanel)
    ennemy:SetSize(30, 30)
    ennemy:SetPos(x, y)
    ennemy.IsEnnemy = true
    function ennemy:Paint(width, height)
        draw.RoundedBoxEx(0, 0, 0, width -10, height -10, Color(255, 0, 0), false, false, true, true)
        surface.SetDrawColor( 255, 255, 255)
        draw.NoTexture()
    end

    local player1 = ply.SCP055_player1

    timer.Create("Movement_Ennemy_" .. ply:EntIndex() .. index, 0.08, 0, function()
        if (not IsValid(ennemy) or not IsValid(ply) or not IsValid(gamePanel)) then
            timer.Remove("Movement_Ennemy_" .. ply:EntIndex() .. index)
            return 
        end

        local xEnnemy, yEnnemy = ennemy:GetPos()
        local xPlayer, yPlayer = player1:GetPos()

        if (timer.Exists("OnKeyCodePressed.SCP055_Key_MovePlayer" .. ply:EntIndex())) then
            local xDirection = math.Clamp(xPlayer - xEnnemy, -1, 1)
            local yDirection = math.Clamp(yPlayer - yEnnemy, -1, 1)
            local xNewPos = xEnnemy + xDirection * velocity
            local yNewPos = yEnnemy + yDirection * velocity

            ennemy:SetPos(xNewPos, yNewPos)
            ennemy.x, ennemy.y = xNewPos, yNewPos
        end
        if (xPlayer < xEnnemy + ennemy:GetWide() and xPlayer + player1:GetWide() > xEnnemy) and 
        (yPlayer < yEnnemy + ennemy:GetTall() and yPlayer + player1:GetTall() > yEnnemy) then
            scp_055.NextMap(ply, gamePanel, 0)
        end
    end)

    table.insert(ennemies, ennemy)
end

local function CreatePlayer(gamePanel, ply, x, y, color)
    ply.SCP055_player1 = vgui.Create("EditablePanel", gamePanel)
    ply.SCP055_player1:SetSize(20, 20)
    ply.SCP055_player1:SetPos(x, y)
    local alpha = 255
    local speedDecay = SCP_055_CONFIG.SpeedDecayGameEvent
    function ply.SCP055_player1:Paint(width, height)
        if (gamePanel.IsEnd) then alpha = math.Clamp(alpha - speedDecay, 0, 100) end
        color.a = alpha
        draw.RoundedBoxEx(0, 0, 0, width, height, color, false, false, true, true)
        draw.RoundedBoxEx(2, width * 0.5, height * 0.5, width * 0.1, height * 0.1, Color(255, 255, 255), true, true, true,
            true)
    end
    ply.SCP055_walls = {}
    ply.SCP055_ennemies = {}
    ply.SCP055_delay = SCP_055_CONFIG.MapList[gamePanel.indexMap].delay
    ply.SCP055_speed = SCP_055_CONFIG.MapList[gamePanel.indexMap].speed
    if timer.Exists("OnKeyCodePressed.SCP055_Key_MovePlayer" .. ply:EntIndex()) then
        timer.Adjust("OnKeyCodePressed.SCP055_Key_MovePlayer" .. ply:EntIndex(), ply.SCP055_delay, nil, nil)
    end
end

-- MAPS
local function MainMap(gamePanel, ply)
    local width = gamePanel:GetWide()
    local height = gamePanel:GetTall()

    CreatePlayer(gamePanel, ply, width * 0.05, height * 0.2, Color(43, 255, 0))

    local colorWall = Color(255, 255, 255)
    CreateWall(gamePanel, width * 0.02, height * 0.1, width * 0.4, 30, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.02, height * 0.9, width * 0.459, 30, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.02, height * 0.1, 20, height * 0.8, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.02, height * 0.3, width * 0.1, height * 0.6, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.1, height * 0.12, 20, height * 0.08, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.1, height * 0.25, 20, height * 0.08, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.15, height * 0.3, width * 0.07, height * 0.1, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.25, height * 0.3, width * 0.03, height * 0.1, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.28, height * 0.1, width * 0.2, height * 0.3, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.28, height * 0.3, width * 0.05, height * 0.5, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.14, height * 0.5, width * 0.15, 30, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.14, height * 0.5, 30, height * 0.35, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.24, height * 0.57, 30, height * 0.34, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.3, height * 0.773, width * 0.14, 30, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.458, height * 0.45, 40, height * 0.45, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.35, height * 0.68, width * 0.12, 30, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.3, height * 0.6, width * 0.13, 30, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.35, height * 0.45, width * 0.12, height * 0.08, colorWall, ply.SCP055_walls)

    CreateWall(gamePanel, width * 0.46, height * 0.56, width * 0.7, 30, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.46, height * 0.26, width * 0.7, 30, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.985, height * 0.28, 30, height * 0.1, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.985, height * 0.48, 30, height * 0.1, colorWall, ply.SCP055_walls)

    CreateWall(gamePanel, width * 0.95, height * 0.37, 40, height * 0.2, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.95, height * 0.28, 40, 40, colorWall, ply.SCP055_walls)

    CreateWall(gamePanel, width * 0.9, height * 0.33, 40, height * 0.2, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.88, height * 0.28, width * 0.06, height * 0.05, colorWall, ply.SCP055_walls)

    CreateWall(gamePanel, width * 0.82, height * 0.37, 40, height * 0.2, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.82, height * 0.28, 40, 40, colorWall, ply.SCP055_walls)

    CreateWall(gamePanel, width * 0.77, height * 0.53, 60, 40, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.77, height * 0.37, 40, height * 0.2, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.7597, height * 0.34, 60, 40, colorWall, ply.SCP055_walls)

    CreateWall(gamePanel, width * 0.71, height * 0.28, 40, height * 0.2, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.66, height * 0.28, 40, height * 0.2, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.66, height * 0.36, width * 0.07, 40, colorWall, ply.SCP055_walls)

    CreateWall(gamePanel, width * 0.61, height * 0.28, width * 0.02, 40, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.61, height * 0.4, width * 0.02, 40, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.61, height * 0.53, width * 0.02, 40, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.63, height * 0.28, 30, height * 0.2, colorWall, ply.SCP055_walls)

    CreateWall(gamePanel, width * 0.58, height * 0.32, 20, height * 0.26, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.55, height * 0.32, width * 0.01, height * 0.2, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.55, height * 0.32, width * 0.03, height * 0.02, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.55, height * 0.38, width * 0.03, height * 0.02, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.55, height * 0.39, width * 0.02, height * 0.02, colorWall, ply.SCP055_walls)

    CreateWall(gamePanel, width * 0.5, height * 0.28, width * 0.03, 40, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.5, height * 0.4, width * 0.03, 40, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.5, height * 0.53, width * 0.03, 40, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.515, height * 0.28, 30, height * 0.2, colorWall, ply.SCP055_walls)

    CreateWall(gamePanel, width * 0.995, height * 0.38, 10, height * 0.1, Color(0, 0, 0), ply.SCP055_walls, true)

    CreateEnnemy(gamePanel, ply, width * 0.01, height * 0.1, 10, ply.SCP055_ennemies, 1)
    CreateEnnemy(gamePanel, ply, width * 0.9, height * 0.9, 10, ply.SCP055_ennemies, 2)
    CreateEnnemy(gamePanel, ply, width * 0.6, height * 0.8, 10, ply.SCP055_ennemies, 3)
    CreateEnnemy(gamePanel, ply, width * 0.35, height * 0.5, 10, ply.SCP055_ennemies, 4)
    CreateEnnemy(gamePanel, ply, width * 0.3, height * 0.5, 10, ply.SCP055_ennemies, 5)
end

local function SmileMap(gamePanel, ply)
    local width = gamePanel:GetWide()
    local height = gamePanel:GetTall()

    CreatePlayer(gamePanel, ply, 20, height * 0.5, Color(43, 255, 0))

    local colorWall = Color(255, 255, 255)
    local colorSmile = Color(15, 15, 15, 155)
    CreateWall(gamePanel, 0, height * 0.4, width, 20, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, 0, height * 0.6, width, 20, colorWall, ply.SCP055_walls)

    CreateWall(gamePanel, width * 0.3, height * 0.05, 20, 200, colorSmile, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.7, height * 0.05, 20, 200, colorSmile, ply.SCP055_walls)

    CreateWall(gamePanel, width * 0.2, height * 0.795, width * 0.02, 40, colorSmile, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.21, height * 0.8315, 40, 20, colorSmile, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.22, height * 0.85, width * 0.58, 20, colorSmile, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.8, height * 0.795, width * 0.02, 40, colorSmile, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.79, height * 0.8315, 40, 20, colorSmile, ply.SCP055_walls)

    CreateWall(gamePanel, width * 0.96, height * 0.42, 100, 180, Color(0, 0, 0), ply.SCP055_walls, true)
end

local function TunelMap(gamePanel, ply)
    local width = gamePanel:GetWide()
    local height = gamePanel:GetTall()

    CreatePlayer(gamePanel, ply, 20, height * 0.5, Color(43, 255, 0))

    local colorWall = Color(255, 255, 255)
    CreateWall(gamePanel, 0, height * 0.4, width, 20, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, 0, height * 0.6, width, 20, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, 0, height * 0.6, width, 20, colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, width * 0.96, height * 0.42, 100, 180, Color(0, 0, 0), ply.SCP055_walls, true)

    CreateEnnemy(gamePanel, ply, width * -0.05, height * 0.45, 20, ply.SCP055_ennemies, 1)
    CreateEnnemy(gamePanel, ply, width * -0.05, height * 0.48, 20, ply.SCP055_ennemies, 2)
    CreateEnnemy(gamePanel, ply, width * -0.05, height * 0.5, 20, ply.SCP055_ennemies, 3)
    CreateEnnemy(gamePanel, ply, width * -0.05, height * 0.52, 20, ply.SCP055_ennemies, 4)
    CreateEnnemy(gamePanel, ply, width * -0.05, height * 0.55, 20, ply.SCP055_ennemies, 5)
end

local function FiveSevenNineMap(gamePanel, ply)
    local width = gamePanel:GetWide()
    local height = gamePanel:GetTall()

    CreatePlayer(gamePanel, ply, 20, height * 0.5, Color(43, 255, 0))
    CreateCircularWall(gamePanel, width * 0.7, height * 0.3, width * 0.11, 255, 255, 255, ply.SCP055_walls, true)

    CreateEnnemy(gamePanel, ply, width * -0.05, height * 0.1, 20, ply.SCP055_ennemies, 1)
    CreateEnnemy(gamePanel, ply, width * -0.05, height * 0.2, 20, ply.SCP055_ennemies, 2)
    CreateEnnemy(gamePanel, ply, width * -0.05, height * 0.3, 20, ply.SCP055_ennemies, 3)
    CreateEnnemy(gamePanel, ply, width * -0.05, height * 0.4, 20, ply.SCP055_ennemies, 4)
    CreateEnnemy(gamePanel, ply, width * -0.05, height * 0.5, 20, ply.SCP055_ennemies, 5)
    CreateEnnemy(gamePanel, ply, width * -0.05, height * 0.6, 20, ply.SCP055_ennemies, 6)
    CreateEnnemy(gamePanel, ply, width * -0.05, height * 0.7, 20, ply.SCP055_ennemies, 7)
    CreateEnnemy(gamePanel, ply, width * -0.05, height * 0.8, 20, ply.SCP055_ennemies, 8)
    CreateEnnemy(gamePanel, ply, width * -0.05, height * 0.9, 20, ply.SCP055_ennemies, 9)

    CreateEnnemy(gamePanel, ply, width * 1, height * 1.1, 20, ply.SCP055_ennemies, 10)
    CreateEnnemy(gamePanel, ply, width * 2, height * 1.1, 20, ply.SCP055_ennemies, 11)
    CreateEnnemy(gamePanel, ply, width * 3, height * 1.1, 20, ply.SCP055_ennemies, 12)
    CreateEnnemy(gamePanel, ply, width * 4, height * 1.1, 20, ply.SCP055_ennemies, 13)
    CreateEnnemy(gamePanel, ply, width * 5, height * 1.1, 20, ply.SCP055_ennemies, 14)
    CreateEnnemy(gamePanel, ply, width * 6, height * 1.1, 20, ply.SCP055_ennemies, 15)
    CreateEnnemy(gamePanel, ply, width * 7, height * 1.1, 20, ply.SCP055_ennemies, 16)
    CreateEnnemy(gamePanel, ply, width * 8, height * 1.1, 20, ply.SCP055_ennemies, 17)
    CreateEnnemy(gamePanel, ply, width * 9, height * 1.1, 20, ply.SCP055_ennemies, 18)

    CreateEnnemy(gamePanel, ply, width * 0.1, height * -0.1, 20, ply.SCP055_ennemies, 19)
    CreateEnnemy(gamePanel, ply, width * 0.2, height * -0.1, 20, ply.SCP055_ennemies, 20)
    CreateEnnemy(gamePanel, ply, width * 0.3, height * -0.1, 20, ply.SCP055_ennemies, 21)
    CreateEnnemy(gamePanel, ply, width * 0.4, height * -0.1, 20, ply.SCP055_ennemies, 22)
    CreateEnnemy(gamePanel, ply, width * 0.5, height * -0.1, 20, ply.SCP055_ennemies, 23)
    CreateEnnemy(gamePanel, ply, width * 0.6, height * -0.1, 20, ply.SCP055_ennemies, 24)
    CreateEnnemy(gamePanel, ply, width * 0.7, height * -0.1, 20, ply.SCP055_ennemies, 25)
    CreateEnnemy(gamePanel, ply, width * 0.8, height * -0.1, 20, ply.SCP055_ennemies, 26)
    CreateEnnemy(gamePanel, ply, width * 0.9, height * -0.1, 20, ply.SCP055_ennemies, 27)
end

local function FallMap(gamePanel, ply)
    ply.SCP055_Unkey = true
    local colorWall = Color(255, 255, 255)
    CreatePlayer(gamePanel, ply, gamePanel:GetWide() * 0.5, gamePanel:GetTall() * 0.01, Color(43, 255, 0))

    CreateWall(gamePanel, gamePanel:GetWide() * 0.1, 0, gamePanel:GetWide() * 0.02, gamePanel:GetTall(), colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, gamePanel:GetWide() * 0.9, 0, gamePanel:GetWide() * 0.02, gamePanel:GetTall(), colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, gamePanel:GetWide() * 0.12, gamePanel:GetTall() *0.98, gamePanel:GetWide() * 0.78, gamePanel:GetTall() * 0.02, Color(0, 0, 0), ply.SCP055_walls, true)
    FallPlayer(ply, gamePanel)
end

local function WhyMap(gamePanel, ply)
    ply.SCP055_Unkey = true
    local colorWall = Color(255, 255, 255)
    CreatePlayer(gamePanel, ply, gamePanel:GetWide() * 0.5, gamePanel:GetTall() * 0.01, Color(43, 255, 0))

    CreateWall(gamePanel, gamePanel:GetWide() * 0.1, 0, gamePanel:GetWide() * 0.02, gamePanel:GetTall(), colorWall, ply.SCP055_walls)
    CreateWall(gamePanel, gamePanel:GetWide() * 0.9, 0, gamePanel:GetWide() * 0.02, gamePanel:GetTall(), colorWall, ply.SCP055_walls)
    CreateCircularWall(gamePanel, gamePanel:GetWide() * 0.4, gamePanel:GetTall() * 0.55, gamePanel:GetWide() * 0.11, 255, 0, 0, ply.SCP055_walls, true)
    FallPlayer(ply, gamePanel)
end

-- Fonction pour créer un mur
function scp_055.NextMap(ply, gamePanel, increment)
    gamePanel.indexMap = gamePanel.indexMap + increment
    local isEndGame = gamePanel.indexMap > #SCP_055_CONFIG.MapList and true or false
    if (gamePanel.indexMap > 0) then
        RemoveMap(ply, isEndGame)
    end
    if (not isEndGame) then
        ply.SCP055_Unkey = nil
        local map = SCP_055_CONFIG.MapList[gamePanel.indexMap].map
        if (map == "tunnel") then
            TunelMap(gamePanel, ply)
        end
        if (map == "smile") then
            SmileMap(gamePanel, ply)
        end
        if (map == "main") then
            MainMap(gamePanel, ply)
        end
        if (map == "579") then
            FiveSevenNineMap(gamePanel, ply)
        end
        if (map == "why") then
            WhyMap(gamePanel, ply)
        end
        if (map == "fall") then
            FallMap(gamePanel, ply)
        end
    end
end

local function CheckCollison(ply, player1, walls, newX, newY)
    local gamePanel = player1:GetParent()
    if (newX < 0 or newY < 0 or newX > gamePanel:GetWide() or newY > gamePanel:GetTall()) then
        return true
    end
    -- Vérification des collisions avec les murs
    for _, wall in ipairs(walls) do
        if newX < wall.x + wall:GetWide() and newX + player1:GetWide() > wall.x and newY < wall.y + wall:GetTall() and
            newY + player1:GetTall() > wall.y then
            if (wall.nextMap) then
                scp_055.NextMap(ply, gamePanel, 1)
            end
            return true -- Collision, ne pas déplacer le joueur
        end
    end

    return false
end

function scp_055.SetPixelPlayerMove(ply, x, y)
    local player1 = ply.SCP055_player1
    if (not IsValid(player1)) then
        timer.Remove("OnKeyCodePressed.SCP055_Key_MovePlayer" .. ply:EntIndex())
        return
    end
    local walls = ply.SCP055_walls
    local newX, newY = player1.x + (x * ply.SCP055_speed), player1.y + (y * ply.SCP055_speed)
    local IsColide = CheckCollison(ply, player1, walls, newX, newY)
    if (not IsColide) then
        player1:SetPos(newX, newY)
        player1.x, player1.y = newX, newY
    end
end

-- Fonction de déplacement du joueur
local function MovePlayer(x, y)
    local ply = LocalPlayer()
    scp_055.SetPixelPlayerMove(ply, x, y)
    timer.Create("OnKeyCodePressed.SCP055_Key_MovePlayer" .. ply:EntIndex(), ply.SCP055_delay, 0, function()
        scp_055.SetPixelPlayerMove(ply, x, y)
    end)
end

function scp_055.GameEvent()
    local ply = LocalPlayer()
    hook.Remove("HUDPaint", "HUDPaint.SCP055_SetToTheDark".. ply:EntIndex())
    local frame = vgui.Create("DFrame")
    frame:SetSize(SCP_055_CONFIG.ScrW, SCP_055_CONFIG.ScrH)
    frame:SetTitle( "" )
    frame:Center()
    frame:MakePopup()
    frame:SetDraggable( false )
    frame:ShowCloseButton( false )

    function frame:OnKeyCodePressed(keyCode)
        local ply = LocalPlayer()
        if (ply.SCP055_Unkey) then return end
        local x, y = 0, 0
        if keyCode == KEY_UP then
            x, y = 0, -1
        elseif keyCode == KEY_DOWN then
            x, y = 0, 1
        elseif keyCode == KEY_LEFT then
            x, y = -1, 0
        elseif keyCode == KEY_RIGHT then
            x, y = 1, 0
        end
        ply.ActualKey = keyCode
        MovePlayer(x, y)
    end

    function frame:OnKeyCodeReleased(keyCode)
        local ply = LocalPlayer()
        if (ply.ActualKey == keyCode) then
            timer.Remove("OnKeyCodePressed.SCP055_Key_MovePlayer" .. ply:EntIndex())
        end
    end

    ply.SCP0555_FrameGameEvent = frame

    -- Création du panneau de jeu
    local gamePanel = vgui.Create("DPanel", frame)
    gamePanel:SetSize(frame:GetWide(), frame:GetTall())
    gamePanel:Center()
    gamePanel:SetBackgroundColor(Color(0, 0, 0))
    gamePanel.indexMap = 0

    scp_055.NextMap(ply, gamePanel, 1)
end

net.Receive(SCP_055_CONFIG.GameEvent, function()
    scp_055.GameEvent()
end)