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

function scp_055.SetBriefcaseEffect(ent)
    local ply = LocalPlayer()
    local maxRange = SCP_055_CONFIG.RadiusEffect

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
        -- TODO : Jouer un son d'ouverture de la mallette
    else
        -- TODO : Jouer un son d'erreur de la mallette
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
function scp_055.DisPlayGIF(ply, material, alpha)
    alpha = alpha or 1
    local width, height = SCP_055_CONFIG.ScrW + 100, SCP_055_CONFIG.ScrH + 100 --? Cant disabled overflow-y, dont know why again so i hide it in a more stupid way.
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
                '<img id="gif-scp035" src="'..material..'" width="'..width..'" height="'..height..'">'..
            '</div>'..
        '</div>'
        )
    return StaticNoise
end

-- TODO : Son de confusion / Etat de choc
function scp_055.BlurEffect(ply, duration)
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