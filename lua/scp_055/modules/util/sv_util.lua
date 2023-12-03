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

function scp_055.CheckBriefcase(ply, SCP055)
	SCP055:SetIsCheck(true)
	scp_055.OpenPanelPassword(ply)
end

function scp_055.UnCheckBriefcase(ply, SCP055)
	local VMAnim = ply:GetViewModel()
	scp_055.SetViewModel(VMAnim, "uncheck")
	SCP055:SetIsCheck(false)
	ply:EmitSound(Sound("scp_055/uncheck_briefcase.mp3"))
end

function scp_055.OpenBriefcase(ply)
	local SCP055 = ply:GetWeapon("swep_scp055")

	if (not IsValid(SCP055)) then return end

	scp_055.UnCheckBriefcase(ply, SCP055)
	SCP055:SetIsOpen(true)
	ply.SCP055_IsOpenBC = true
end

function scp_055.StartSCP055Effect(ply)
	if(not IsValid(ply) or not ply:Alive()) then return end
	scp_055.RemoveWeapons(ply)

	timer.Simple(0.1, function() --? Strip weapon make 0.1s for remove all weapons.
		ply.SCP055_AffectBySCP005 = true
		ply.SCP055_01 = true
		ply:SetRenderMode(RENDERMODE_TRANSALPHA)
		ply:SetColor( Color(0, 0, 0, 0))
		ply.SCP055_OriginPos = ply:GetPos()

		scp_055.CreateNPCReplace(ply)
		ply:SetEyeAngles(Angle(-180, 0, 0))
		ply:Freeze(true)
		scp_055.MovePlayerToAPos(ply, ply:GetPos() + SCP_055_CONFIG.AscentDirection, 30, 0, false)
		scp_055.SetToTheDark(ply)
		timer.Simple(SCP_055_CONFIG.AscentTime + 2, function()
			if (not scp_055.IsValid(ply)) then return end

			hook.Remove("Think", "Think.SCP055_MovePlayerToAPos_".. ply:EntIndex())
			ply:Freeze(false)
			ply:SetMoveType(MOVETYPE_NONE)
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
	ply:SetSuppressPickupNotices( true )
	ply:Give("swep_nocursor")
	ply:SetSuppressPickupNotices( false )
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

function scp_055.RemoveHook(ply, eventName, identifier)
	net.Start(SCP_055_CONFIG.RemoveHook)
		net.WriteString(eventName)
		net.WriteString(identifier)
	net.Send(ply)
end


function scp_055.NewPosCircle(angle, rayon, centre)
	local newPos = Vector(0, 0, 0)
	newPos.x = centre.x + rayon * math.cos(math.rad(angle))
	newPos.y = centre.y + rayon * math.sin(math.rad(angle))
	newPos.z = centre.z

	return newPos
end

--[[
    * Function used for drop the entitie if it is equip by a player.
    * @Player ply The player who will drop the entity.
    * @string weapon The weapon name to check.
    * @string entity The entity name to create.
--]]
function scp_055.DropEntitie(ply, weapon, entity)
    if (!IsValid(ply)) then return end
    if (not ply:HasWeapon(weapon)) then return end

    local ent = scp_055.Drop(ply, entity)
    if (IsValid(ent) and entity == "scp_055") then
		ent:SetIsOpen(ply.SCP055_IsOpenBC)
	end
end

--[[
    * Return true if the player has the security card or if is not needed
    * @Player ply The player who will drop the entity.
--]]
function scp_055.HasSecurityCard(ply)
    return (ply:HasWeapon("swep_cardscp055") or (not SCP_055_CONFIG.NeedCard:GetBool() and not ply:HasWeapon("swep_cardscp055")))
end

/* 
* 
* @string name
* @number value
*/
function scp_055.SetConvarClientSide(name, value, ply)
    if (type( value ) == "boolean") then value = value and 1 or 0 end
    net.Start(SCP_055_CONFIG.SetConvarClientSide)
        net.WriteString(name)
        net.WriteUInt(value, 14)
    if (ply) then
        net.Send(ply)
    else
        net.Broadcast()
    end
end

-- Set Convar Int for the client side
net.Receive(SCP_055_CONFIG.SetConvarInt, function ( len, ply )
    if (ply:IsSuperAdmin() or game.SinglePlayer()) then
        local name = net.ReadString()
        local value = net.ReadUInt(14)
        SCP_055_CONFIG[name]:SetInt(value)

        scp_055.SetConvarClientSide('Client'..name, value) --? The value clientside start with Client
    end
end)

-- Set Convar Bool for the client side
net.Receive(SCP_055_CONFIG.SetConvarBool, function ( len, ply )
    if (ply:IsSuperAdmin() or game.SinglePlayer()) then
        local name = net.ReadString()
        local value = net.ReadBool()
        SCP_055_CONFIG[name]:SetBool(value)

        scp_055.SetConvarClientSide('Client'..name, value) --? The value clientside start with Client
    end
end)

net.Receive(SCP_055_CONFIG.OpenBriefcase, function(len, ply)
	scp_055.OpenBriefcase(ply)
end)

net.Receive(SCP_055_CONFIG.UnCheckBriefcase, function(len, ply)
	local SCP055 = ply:GetWeapon("swep_scp055")
	if (not IsValid(SCP055)) then return end

	scp_055.UnCheckBriefcase(ply, SCP055)
end)

net.Receive(SCP_055_CONFIG.SoundToServer, function(len, ply)
	local SCP055 = ply:GetWeapon("swep_scp055")
	if (not IsValid(SCP055)) then return end
	local sound = net.ReadString()

	ply:EmitSound(Sound(sound))
end)