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
	local PosObject = (ply:IsPlayer() and ply:GetShootPos() or ply:GetPos()) + LookForward * DistanceToPos + LookUp
    PosObject.z = ply:GetPos().z

	ent:SetPos( PosObject )
	ent:SetAngles( ply:EyeAngles() )
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
	ply:SetCustomCollisionCheck( true )
	ply.SCP055_AffectBySCP005 = true
	ply:SetRenderMode(RENDERMODE_TRANSALPHA)
	ply:SetColor( Color(0, 0, 0, 0))

	scp_055.RemoveWeapons(ply)
	scp_055.SetToTheSky(ply)
	scp_055.CreateNPCReplace(ply)
	scp_055.SetToTheDark(ply)

	-- TODO : On fais le choix de l'effet ici ?
end

function scp_055.RemoveWeapons(ply)
	ply.SCP055_Weapons = ply:GetWeapons()
	ply.SCP055_Ammos = ply:GetAmmo()

	ply:StripWeapons()
	ply:RemoveAllAmmo()
end

function scp_055.SetToTheDark(ply)
	net.Start(SCP_055_CONFIG.SetToTheDark)
	net.Send(ply)
end

function scp_055.CreateNPCReplace(ply)
    local NPC = ents.Create( "npc_citizen" )

    if not IsValid(NPC) then return end

    NPC:SetPos( ply:GetPos() )
    NPC:SetAngles( ply:GetAngles() )
    NPC:SetModel( ply:GetModel() )
	NPC:Give( "swep_scp055" )
    NPC:Spawn()

	ply.SCP055_NPCReplace = NPC
end

function scp_055.SetToTheSky(ply)
	ply:SetMoveType(MOVETYPE_NOCLIP)
	ply:Freeze(true)
	ply:SetEyeAngles(Angle(-180, 0, 0))

	-- TODO : Son de la montée
    hook.Add("Think", "Think.SCP055_SetToTheSky".. ply:EntIndex(), function()
		ply:SetPos(ply:GetPos() + SCP_055_CONFIG.AscentVelocity)
    end)

	timer.Simple(SCP_055_CONFIG.AscentTime, function()
		if (not IsValid(ply)) then return end
		if (not ply.SCP055_AffectBySCP005) then return end

		hook.Remove("Think", "Think.SCP055_SetToTheSky".. ply:EntIndex())
		ply:SetMoveType(MOVETYPE_NONE)
		ply:SetEyeAngles(Angle(0, 0, 0))
	end)
end

function scp_055.SetViewModel(VMAnim, anim)
	VMAnim:SendViewModelMatchingSequence( VMAnim:LookupSequence( anim ) )
end

function scp_055.RemoveTheDark(ply)
	if (ply.SCP055_AffectBySCP005) then
		ply:SetMoveType(MOVETYPE_WALK)
		ply:Freeze(false)
		ply:SetColor( Color(255, 255, 255, 255))
		ply:SetRenderMode(0)
		hook.Remove("Think", "Think.SCP055_SetToTheSky".. ply:EntIndex())

		net.Start(SCP_055_CONFIG.RemoveTheDark)
		net.Send(ply)

		scp_055.KillNPC(ply)

		ply.SCP055_AffectBySCP005 = nil
	end
end

function scp_055.KillNPC(ply)
	if (not ply.SCP055_NPCReplace) then return end

	local NPCWeapon = ply.SCP055_NPCReplace:GetWeapon( "swep_scp055" )
	if (IsValid(NPCWeapon)) then
		scp_055.Drop(NPCWeapon, "scp_055")
		NPCWeapon:Remove() 
	end
	ply.SCP055_NPCReplace:TakeDamage( 999999, game.GetWorld(), game.GetWorld() )
	ply.SCP055_NPCReplace = nil
end

net.Receive(SCP_055_CONFIG.OpenBriefcase, function(len, ply)
	scp_055.OpenBriefcase(ply)
end)

net.Receive(SCP_055_CONFIG.UnCheckBriefcase, function(len, ply)
	local SCP055 = ply:GetWeapon("swep_scp055")
	if (not IsValid(SCP055)) then return end

	scp_055.UnCheckBriefcase(ply, SCP055)
end)