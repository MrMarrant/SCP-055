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

SWEP.PrintName = "SCP-055"
SWEP.Author = "MrMarrant"
SWEP.Purpose = "It isn't round"
SWEP.DrawCrosshair = false
SWEP.Base = "weapon_base"
SWEP.AutoSwitchTo = false


local panelPassword = Material( "card_scp055/panel_password.png" )

function SWEP:DrawHUD()
    if (self:GetIsCheck()) then
        surface.SetMaterial( panelPassword )
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawTexturedRect( SCP_055_CONFIG.ScrW *0.27, SCP_055_CONFIG.ScrH * 0.3, SCP_055_CONFIG.ScrW * 0.5, SCP_055_CONFIG.ScrH * 0.5 )
    end
end

function SWEP:OnRemove()
    local ply = self:GetOwner()
    if (IsValid(ply.SCP055_PanelPassword)) then
        ply.SCP055_PanelPassword:Remove()
        ply.SCP055_PanelPassword = nil
    end
end