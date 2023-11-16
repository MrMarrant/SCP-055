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

function scp_055.Drop(ply, name)
	if (!IsValid(ply)) then return end

	local LookForward = ply:EyeAngles():Forward()
	local LookUp = ply:EyeAngles():Up()
	local ent = ents.Create( name )
	local DistanceToPos = 50
	local PosObject = ply:GetShootPos() + LookForward * DistanceToPos + LookUp
    PosObject.z = ply:GetPos().z

	ent:SetPos( PosObject )
	ent:SetAngles( ply:EyeAngles() )
	ent:Spawn()
	ent:Activate()

	return ent
end