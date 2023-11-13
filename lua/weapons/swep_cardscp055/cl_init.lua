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

include('shared.lua')

SWEP.PrintName = "Authorization Card SCP-055"
SWEP.Author = "MrMarrant"
SWEP.Purpose = "It has rounded corners"
SWEP.DrawCrosshair = false
SWEP.Base = "weapon_base"
SWEP.AutoSwitchTo = false

local cardCode = Material( "card_scp055/card_code.png" )
local passwordEdit = string.upper( SCP_055_CONFIG.SecurityPassword )

function SWEP:DrawHUD()
    local ply = self:GetOwner()
    if (ply.scp055_cardCode) then
        surface.SetMaterial( cardCode )
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawTexturedRect( SCP_055_CONFIG.ScrW *0.27, SCP_055_CONFIG.ScrH * 0.3, SCP_055_CONFIG.ScrW * 0.5, SCP_055_CONFIG.ScrH * 0.5 )

        surface.SetFont( "SCP055_Password" )
        surface.SetTextColor( 0, 0, 0 )

        local x = 0
        for i = 1, #passwordEdit do
            surface.SetTextPos( SCP_055_CONFIG.ScrW *0.364 + x, SCP_055_CONFIG.ScrH * 0.54 ) 
            surface.DrawText( passwordEdit[i] )
            x = x + 114.5
        end
    end
end