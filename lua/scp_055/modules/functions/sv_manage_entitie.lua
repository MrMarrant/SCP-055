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

--[[
    * Function used for drop the entitie if it is equip by a player.
    * @Player ply The player who will drop the entity.
    * @string weapon The weapon name to check.
    * @string entity The entity name to create.
--]]
function scp_055.DropEntitie(ply, weapon, entity)
    if (!IsValid(ply)) then return end

    if (ply:HasWeapon(weapon)) then

        local ent = ents.Create( entity )
        ent:SetPos( ply:GetShootPos() + ply:GetAimVector() * 20 )
        ent:SetAngles( ply:EyeAngles() + Angle(0, 48, 0))
        ent:Spawn()
        ent:Activate()
    end
end