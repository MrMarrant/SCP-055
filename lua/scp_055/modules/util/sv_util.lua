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
	local ent = scp_055.CreateEnt(name)
	local DistanceToPos = 50
	local PosObject = (ply:IsPlayer() and ply:GetShootPos() or ply:GetPos()) + LookForward * DistanceToPos + LookUp
    PosObject.z = ply:GetPos().z

	ent:SetPos( PosObject )
	ent:SetAngles( ply:EyeAngles() )

	return ent
end

function scp_055.CreateEnt(name)
	local ent = ents.Create( name )
	ent:Spawn()
	ent:Activate()

	return ent
end

function scp_055.OpenPanelPassword(ply)
	net.Start(SCP_055_CONFIG.OpenPanelPassword)
	net.Send(ply)
end

function scp_055.UnCheckBriefcase(ply, SCP055)
	local VMAnim = ply:GetViewModel()
	scp_055.SetViewModel(VMAnim, "uncheck")
	SCP055:SetIsCheck(false)
end

function scp_055.OpenBriefcase(ply)
	local SCP055 = ply:GetWeapon("swep_scp055")

	if (not IsValid(SCP055)) then return end

	scp_055.UnCheckBriefcase(ply, SCP055)
	SCP055:SetIsOpen(true)
end

function scp_055.StartSCP055Effect(ply)
	scp_055.RemoveWeapons(ply)

	timer.Simple(0.1, function() --? Strip weapon make 0.1s for remove all weapons.
		ply.SCP055_AffectBySCP005 = true
		ply.SCP055_01 = true
		ply:SetRenderMode(RENDERMODE_TRANSALPHA)
		ply:SetColor( Color(0, 0, 0, 0))
		ply.SCP055_OriginPos = ply:GetPos()

		scp_055.CreateNPCReplace(ply)
		ply:SetEyeAngles(Angle(-180, 0, 0))
		scp_055.MovePlayerToAPos(ply, ply.SCP055_NPCReplace:GetPos() + SCP_055_CONFIG.AscentDirection, 50, 0)
		scp_055.SetToTheDark(ply)
		timer.Simple(SCP_055_CONFIG.AscentTime, function()
			if (not scp_055.IsValid(ply)) then return end

			hook.Remove("Think", "Think.SCP055_MovePlayerToAPos_".. ply:EntIndex())
			ply:SetEyeAngles(Angle(0, 0, 0))
			ply:Freeze(true)
			scp_055.StartEvent(ply)
		end)
	end)
end

function scp_055.RemoveWeapons(ply)
	ply.SCP055_Weapons = {}
	for key, value in ipairs(ply:GetWeapons()) do
		table.insert(ply.SCP055_Weapons, value:GetClass())
	end
	ply.SCP055_Ammos = ply:GetAmmo()

	ply:StripWeapons()
	ply:RemoveAllAmmo()
end

function scp_055.UnFreezeDelay(ply, delay)
	timer.Simple(delay, function ()
		if (not IsValid(ply)) then return end
		ply:Freeze(false)
	end)
end

function scp_055.IsValid(ply)
	if (not IsValid(ply)) then return false end
	if (not ply.SCP055_AffectBySCP005) then return false end
	return true
end

function scp_055.SpawnRagdoll(ply, model, pos, angle, remove)
	if (not scp_055.IsValid(ply)) then return end
	if(IsValid(ply:GetRagdollEntity())) then ply:GetRagdollEntity():Remove() end

	local ragdoll = ents.Create("prop_ragdoll")
    ragdoll:SetModel(model)
	ragdoll:SetAngles( angle )
    ragdoll:SetPos(pos)
    ragdoll:Spawn()
    ragdoll:SetOwner(ply)
	if ply:GetNumBodyGroups() then
        for i = 0, ply:GetNumBodyGroups() - 1 do
            ragdoll:SetBodygroup(i, ply:GetBodygroup(i))
        end
    end

	if (remove) then
		timer.Simple(30, function()
			if (not IsValid(ragdoll)) then return end
			ragdoll:Remove()
		end)
	end

	return ragdoll
end

function scp_055.FreezeRagDoll(ragdoll, target)
	local Bones = ragdoll:GetPhysicsObjectCount()
	for i = 0, Bones - 1 do
		local phys = ragdoll:GetPhysicsObjectNum(i)
		local b = ragdoll:TranslatePhysBoneToBone(i)
		local pos, ang = target:GetBonePosition(b)
		phys:EnableMotion(false)
		phys:SetPos(pos)
		phys:SetAngles(ang)
		phys:Wake()
	end
end

function scp_055.BlurEffect(ply, duration)
	net.Start(SCP_055_CONFIG.BlurEffect)
		net.WriteFloat(duration)
	net.Send(ply)
end

net.Receive(SCP_055_CONFIG.OpenBriefcase, function(len, ply)
	scp_055.OpenBriefcase(ply)
end)

net.Receive(SCP_055_CONFIG.UnCheckBriefcase, function(len, ply)
	local SCP055 = ply:GetWeapon("swep_scp055")
	if (not IsValid(SCP055)) then return end

	scp_055.UnCheckBriefcase(ply, SCP055)
end)