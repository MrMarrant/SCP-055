-- SCP-055, A representation of a paranormal object on a fictional series on the game Garry's Mod.
-- Copyright (C) 2023  MrMarrant aka BIBI.

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

local AddAlpha = 0.1
local DrawAlpha = 0.2
local Delay = 0.05
local tab = {
    [ "$pp_colour_addr" ] = 0,
    [ "$pp_colour_addg" ] = 0,
    [ "$pp_colour_addb" ] = 0,
    [ "$pp_colour_brightness" ] = 0,
    [ "$pp_colour_contrast" ] = 1,
    [ "$pp_colour_colour" ] = 1,
    [ "$pp_colour_mulr" ] = 0,
    [ "$pp_colour_mulg" ] = 0,
    [ "$pp_colour_mulb" ] = 0
}

function scp_055.ProximityEffect(ent)
    local ply = LocalPlayer()
    local maxRange = SCP_055_CONFIG.ClientRadiusEffect

    if (ply:GetPos():Distance(ent:GetPos()) > maxRange or not ply:Alive() or ply.SCP055_CloseEffect) then return end
    ply.SCP055_CloseEffect = ply:StartLoopingSound(Sound("scp_055/it_is_not_far.wav"))

    hook.Add("Think", "Think.SCP055_ProximityEffect".. ply:EntIndex(), function()
        if (not IsValid(ply)) then return end
        if (not IsValid(ent)) then
            scp_055.RemoveProximityEffect(ply)
            return
        end

        if (ply:GetPos():Distance(ent:GetPos()) > maxRange or not ply:Alive()) then
            scp_055.RemoveProximityEffect(ply)
            return
        end
    end)
end

function scp_055.RemoveProximityEffect(ply)
    ply:StopLoopingSound(ply.SCP055_CloseEffect)
    ply.SCP055_CloseEffect = nil
    hook.Remove("Think", "Think.SCP055_ProximityEffect".. ply:EntIndex())
end

function scp_055.SetBriefcaseEffect(ent)
    local ply = LocalPlayer()
    local maxRange = SCP_055_CONFIG.ClientRadiusEffect

    if (ply:GetPos():Distance(ent:GetPos()) > maxRange or not ply:Alive()) then return end

    local distanceLeft = maxRange - ply:GetPos():Distance(ent:GetPos())
    tab[ "$pp_colour_contrast" ] = 1 - 0.99 * (distanceLeft / maxRange)

    DrawColorModify( tab )
    cam.Start3D()
        render.SetStencilEnable( true )
        render.SetStencilWriteMask( 1 )
        render.SetStencilTestMask( 1 )
        render.SetStencilReferenceValue( 1 )
        render.SetStencilFailOperation( STENCIL_KEEP )
        render.SetStencilZFailOperation( STENCIL_KEEP )

        render.SetStencilCompareFunction( STENCIL_ALWAYS )
        render.SetStencilPassOperation( STENCIL_REPLACE )

        ent:DrawModel()

        render.SetStencilEnable( false )
    cam.End3D()

    DrawMotionBlur( AddAlpha, DrawAlpha, Delay )
end

function scp_055.OpenPanelPassword()
    local ply = LocalPlayer()

    local frame = vgui.Create("DFrame")
    frame:SetSize(SCP_055_CONFIG.ScrW * 0.5, SCP_055_CONFIG.ScrH * 0.5)
    frame:SetPos(SCP_055_CONFIG.ScrW * 0.27, SCP_055_CONFIG.ScrH * 0.488)
    frame:SetTitle("")
    frame:SetDraggable(false)
    frame:ShowCloseButton(false)
    frame:MakePopup()
    function frame:Paint(width, height)
        draw.RoundedBoxEx(0, 0, 0, width, height, Color(0, 0, 0, 0), false , false, true, true)
    end

    local WidthParent, HeightParent = frame:GetSize()

    ply.SCP055_PanelPassword = vgui.Create("DHTML", frame)
    ply.SCP055_PanelPassword:SetSize(WidthParent, HeightParent)
    ply.SCP055_PanelPassword:SetHTML(SCP_055_CONFIG.PanelPassword)
    ply.SCP055_PanelPassword:SetAllowLua( true )
    ply.SCP055_PanelPassword:RequestFocus()
end

function scp_055.ClosePanelPassword()
    local ply = LocalPlayer()
    if (ply.SCP055_PanelPassword) then
        ply.SCP055_PanelPassword:GetParent():Remove()
        ply.SCP055_PanelPassword = nil
    end
end

function scp_055.CheckPassword(password)
    local ply = LocalPlayer()
    if (SCP_055_CONFIG.SecurityPassword == password) then
        scp_055.ClosePanelPassword()
        net.Start(SCP_055_CONFIG.OpenBriefcase)
        net.SendToServer()
        scp_055.SoundToServer("scp_055/open_briefcase.mp3")
    else
        ply:EmitSound(Sound("scp_055/error.mp3"))
        -- TODO : Afficher un message d'erreur ?
    end
end

function scp_055.UnCheckBriefcase()
    scp_055.ClosePanelPassword()
    net.Start(SCP_055_CONFIG.UnCheckBriefcase)
    net.SendToServer()
end

/* 
* Display a gif on the screen of the player, it find the screen with an url.
* @Player ply
* @string material
* @number alpha
*/
function scp_055.DisPlayGIF(ply, material, alpha, duration, x, y)
    alpha = alpha or 1
    x = x or 100
    y = y or 100
    local width, height = SCP_055_CONFIG.ScrW + x, SCP_055_CONFIG.ScrH + y --? Cant disabled overflow-y, dont know why again so i hide it in a more stupid way.
    StaticNoise = vgui.Create("DHTML")
    StaticNoise:SetPos(-10, -10) --? No idea why, but the element dont pos exactly to (0,0), so i've to do stupid shit like this.
    StaticNoise:SetSize(width, height)
    StaticNoise:SetZPos( 10 )
    StaticNoise:SetHTML(
        '<style>'..
            '#container {overflow: hidden;}'..
            'img {opacity: '..alpha..';}'..
        '</style>'..

        '<div id="portrait">'..
            '<div id="container">'..
                '<img id="gif-scp055" src="'..material..'" width="'..width..'" height="'..height..'">'..
            '</div>'..
        '</div>'
        )
    if (duration) then
        timer.Create("SCP055_RemoveDisPlayGIF_".. ply:EntIndex(), duration, 1, function ()
            if (not IsValid(StaticNoise)) then return end
            StaticNoise:Remove()
        end)
    end

    return StaticNoise
end

function scp_055.BlurEffect(ply, duration)
    if (not IsValid(ply)) then return end
    hook.Add("HUDPaint", "HUDPaint.SCP055_BlurEffect_".. ply:EntIndex(), function()
        local addA = 0.1
        local dA = 0.8
        local d = 0.05
		DrawMotionBlur( addA, dA, d )
    end)

    timer.Simple(duration, function()
        if (not IsValid(ply)) then return end
        hook.Remove("HUDPaint", "HUDPaint.SCP055_BlurEffect_".. ply:EntIndex())
    end)
end

function scp_055.Subtitles(ply, subtitles, duration)
    local subtitleIndex = 1
    local curSubtile = subtitles[subtitleIndex]
    local curText = scp_055.GetTranslation(curSubtile.key)
    local pause = curSubtile.pause or 0
    local fadeInTime = 1
    local fadeOutTime = 1
    local displayTime = 5
    local subtitleAlpha = 255
    local color = curSubtile.color
    local TimePause = CurTime()
    local TimePauseStop = TimePause + pause
    local x = SCP_055_CONFIG.ScrW / 2
    local y = SCP_055_CONFIG.ScrH - 100

    hook.Add("PostDrawHUD", "PostDrawHUD.SCP055_Subtitles_".. ply:EntIndex(), function()
        if subtitleIndex > #subtitles then
            subtitleAlpha = Lerp(FrameTime() / fadeOutTime, subtitleAlpha, 0)
        else
            if (#curText < 150) then
                draw.SimpleText(curText, "DermaLarge", x, y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            else
                local firstPart, secondPart = scp_055.DivideString(curText, 150)
                draw.SimpleText(firstPart, "DermaLarge", x, y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                draw.SimpleText(secondPart, "DermaLarge", x, y + 50, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end

            TimePause = TimePause + FrameTime()

            if TimePause >= TimePauseStop then
                subtitleIndex = subtitleIndex + 1
                if subtitleIndex <= #subtitles then
                    curSubtile = subtitles[subtitleIndex]
                    color = curSubtile.color
                    curText = scp_055.GetTranslation(curSubtile.key)
                    pause = curSubtile.pause or 0
                    TimePauseStop = TimePause + pause
                end
            end
        end
    end)

    timer.Create("HookRemove_SCP055_Subtitles_".. ply:EntIndex(), duration, 1, function()
        if (not IsValid(ply)) then return end
        hook.Remove("PostDrawHUD", "PostDrawHUD.SCP055_Subtitles_".. ply:EntIndex())
    end)
end

function scp_055.DivideString(str, divider)
    local indexDivider = string.find(string.sub(str, 1, divider), "%s[^%s]*$") or divider
    local firstPart = string.sub(str, 1, indexDivider)
    local secondPart = string.sub(str, indexDivider + 1)

    return firstPart, secondPart
end

function scp_055.SoundToServer(string)
    net.Start(SCP_055_CONFIG.SoundToServer)
        net.WriteString(string)
    net.SendToServer()
end

function scp_055.SetConvarInt(name, value, ply)
    if (ply:IsSuperAdmin() or game.SinglePlayer()) then --? Just for avoid to spam net message, we check server side to.
        net.Start(SCP_055_CONFIG.SetConvarInt)
            net.WriteString(name)
            net.WriteUInt(value, 14)
        net.SendToServer()
    end
end


function scp_055.SetConvarBool(name, value, ply)
    if (ply:IsSuperAdmin() or game.SinglePlayer()) then --? Just for avoid to spam net message, we check server side to.
        net.Start(SCP_055_CONFIG.SetConvarBool)
            net.WriteString(name)
            net.WriteBool(value)
        net.SendToServer()
    end
end

hook.Add("PopulateToolMenu", "PopulateToolMenu.SCP055_MenuConfig", function()
    spawnmenu.AddToolMenuOption("Utilities", "SCP-055", "SCP055_MenuConfig", "Settings", "", "", function(panel)
        local ply = LocalPlayer()
        local SCP055_NeedCard = vgui.Create("DCheckBoxLabel")
        SCP055_NeedCard:SetPos( 5, 5 )
        SCP055_NeedCard:SetText("")
        SCP055_NeedCard:SizeToContents()
        SCP055_NeedCard:SetValue( SCP_055_CONFIG.ClientNeedCard )
        SCP055_NeedCard.OnChange = function(CheckBox, val)
            scp_055.SetConvarBool("NeedCard", val, ply)
        end
        SCP055_NeedCard.Paint = function(CheckBox, w, h)
            draw.DrawText( scp_055.GetTranslation("needcard_description"), "DermaDefaultBold", w*0.05, h * 0.2, Color(0, 153, 255), TEXT_ALIGN_LEFT )
        end

        local SCP055_CanUseOncePerLife = vgui.Create("DCheckBoxLabel")
        SCP055_CanUseOncePerLife:SetPos( 5, 5 )
        SCP055_CanUseOncePerLife:SetText("")
        SCP055_CanUseOncePerLife:SizeToContents()
        SCP055_CanUseOncePerLife:SetValue( SCP_055_CONFIG.ClientCanUseOncePerLife )
        SCP055_CanUseOncePerLife.OnChange = function(CheckBox, val)
            scp_055.SetConvarBool("CanUseOncePerLife", val, ply)
        end
        SCP055_CanUseOncePerLife.Paint = function(CheckBox, w, h)
            draw.DrawText( scp_055.GetTranslation("useonceperlife_description"), "DermaDefaultBold", w*0.05, h * 0.2, Color(0, 153, 255), TEXT_ALIGN_LEFT )
        end

        local SCP055_RadiusEffect = vgui.Create("DNumSlider")
        SCP055_RadiusEffect:SetPos( 5, 5 )
        SCP055_RadiusEffect:SetSize( 100, 20 )
        SCP055_RadiusEffect:SetMinMax( 0, 9999 )
        SCP055_RadiusEffect:SetDecimals( 0 )
        SCP055_RadiusEffect:SetValue( SCP_055_CONFIG.ClientRadiusEffect )
        SCP055_RadiusEffect.OnValueChanged = function(NumSlider, val)
            scp_055.SetConvarInt("RadiusEffect", val, ply)
        end

        local SCP055_MaxDurationGameEvent = vgui.Create("DNumSlider")
        SCP055_MaxDurationGameEvent:SetPos( 5, 5 )
        SCP055_MaxDurationGameEvent:SetSize( 100, 20 )
        SCP055_MaxDurationGameEvent:SetMinMax( 1, 9999 )
        SCP055_MaxDurationGameEvent:SetDecimals( 0 )
        SCP055_MaxDurationGameEvent:SetValue( SCP_055_CONFIG.ClientMaxDurationGameEvent )
        SCP055_MaxDurationGameEvent.OnValueChanged = function(NumSlider, val)
            scp_055.SetConvarInt("MaxDurationGameEvent", val, ply)
        end

        panel:Clear()
        panel:ControlHelp(scp_055.GetTranslation("warningsettings"))
        panel:AddItem(SCP055_NeedCard)
        panel:AddItem(SCP055_CanUseOncePerLife)
        panel:Help( scp_055.GetTranslation("radiuseffect_description") )
        panel:AddItem(SCP055_RadiusEffect)
        panel:Help( scp_055.GetTranslation("maxdurationgameevent_description") )
        panel:AddItem(SCP055_MaxDurationGameEvent)
    end)
end)

net.Receive(SCP_055_CONFIG.SetConvarClientSide, function ()
    local name = net.ReadString()
    local value = net.ReadUInt(14)
    SCP_055_CONFIG[name] = value
end)

net.Receive(SCP_055_CONFIG.OpenPanelPassword, function()
    local ply = LocalPlayer()
    if (ply.SCP055_PanelPassword) then return end

    scp_055.OpenPanelPassword()
end)

net.Receive(SCP_055_CONFIG.BlurEffect, function()
    local ply = LocalPlayer()
    local duration = net.ReadFloat()

    scp_055.BlurEffect(ply, duration)
end)


net.Receive(SCP_055_CONFIG.RemoveHook, function()
    local eventName = net.ReadString()
    local identifier = net.ReadString()

    hook.Remove(eventName, identifier)
end)