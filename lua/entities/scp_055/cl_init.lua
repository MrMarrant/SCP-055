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

include("shared.lua")

function ENT:Draw()
    self:DrawModel() 
end

-- TODO : Mettre un son qui boucle  quand un joueur est proche de l'entité.
function ENT:Initialize()
    hook.Add("HUDPaint", "HUDPaint.SCP055_BriefcaseEffect".. self:EntIndex(), function()
        scp_055.SetBriefcaseEffect(self)
    end)
end

function ENT:OnRemove()
    hook.Remove("HUDPaint", "HUDPaint.SCP055_BriefcaseEffect".. self:EntIndex())
end