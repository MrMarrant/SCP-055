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

function scp_055.StartEvent(ply)
    local eventCount = 1
    local choice = math.random(1, eventCount)

    if (choice == 1) then
        scp_055.SkullEvent(ply)
		scp_055.UnFreezeDelay(ply, 10)
    end
end

function scp_055.SkullEvent(ply)
    net.Start(SCP_055_CONFIG.SkullEvent)
    net.Send(ply)
end


function scp_055.SetToTheDark(ply)
	net.Start(SCP_055_CONFIG.SetToTheDark)
	net.Send(ply)
end

-- TODO : Faire bouger le NPC ?
function scp_055.CreateNPCReplace(ply)
    local NPC = player.CreateNextBot( "SCP-055-01" )
	local model = ply:GetModel()
	local pos = ply:GetPos()
	local angle = ply:GetAngles()

	if not IsValid(NPC) then
		NPC = scp_055.SpawnRagdoll(ply, model, pos, angle)
		scp_055.FreezeRagDoll(NPC, ply)
		for i = 0, ply:GetBoneCount() do
			NPC:ManipulateBoneScale(i, ply:GetManipulateBoneScale(i))
			NPC:ManipulateBoneAngles(i, ply:GetManipulateBoneAngles(i))
			NPC:ManipulateBonePosition(i, ply:GetManipulateBonePosition(i))
		end
	else
		NPC:SetPos( pos )
		NPC:SetAngles( angle )
		NPC:SetModel( model )
		NPC:SetSkin( ply:GetSkin() )
		NPC:SetBodyGroups( ply:GetBodyGroups() )
		NPC:Give( "swep_scp055" )
		NPC:SelectWeapon( "swep_scp055" )
		NPC.SCP055_IsBot = true
		NPC.SCP055_Owner = ply
	end

	ply.SCP055_NPCReplace = NPC
end

function scp_055.SetViewModel(VMAnim, anim)
	VMAnim:SendViewModelMatchingSequence( VMAnim:LookupSequence( anim ) )
end

function scp_055.RemoveTheDark(ply)
	if (ply.SCP055_AffectBySCP005) then
		scp_055.EndSCP055Effect(ply)
		hook.Remove("Think", "Think.SCP055_YouSeeIt_".. ply:EntIndex())
		hook.Remove("Think", "Think.SCP055_ForwardPlayer_".. ply:EntIndex())
		hook.Remove("Think", "Think.SCP055_MovePlayerToAPos_".. ply:EntIndex())

		scp_055.KillBot(ply.SCP055_NPCReplace)
	end
end

function scp_055.EndSCP055Effect(ply)
	ply:SetMoveType(MOVETYPE_WALK)
	ply:Freeze(false)
	ply:SetColor( Color(255, 255, 255, 255))
	ply:SetRenderMode(1)

	if (ply:Alive()) then
		ply.SCP055_NPCReplace:Kick()
		ply.SCP055_NPCReplace = nil
		for key, value in ipairs(ply.SCP055_Weapons) do
			local weapon = ply:Give(value)
		end
		for key, value in ipairs(ply.SCP055_Ammos) do
			ply:SetAmmo(value, key)
		end
		ply:SelectWeapon( "swep_scp055" )
	end

	net.Start(SCP_055_CONFIG.RemoveTheDark)
	net.Send(ply)

	ply.SCP055_Ammos = nil
	ply.SCP055_Weapons = nil
	ply.SCP055_AffectBySCP005 = nil
	ply.SCP055_OriginPos = nil
end

function scp_055.KillBot(bot)
	if (not IsValid(bot)) then return end

	bot.SCP055_Owner.SCP055_NPCReplace = nil

	if (bot.SCP055_IsBot) then
		if (bot:Alive()) then
			local NPCWeapon = bot:GetWeapon( "swep_scp055" )
			if (IsValid(NPCWeapon)) then
				scp_055.Drop(bot, "scp_055")
				NPCWeapon:Remove() 
			end
		end

		bot:Kick()
	else
		local ent = scp_055.CreateEnt("scp_055")
		ent:SetPos( bot:GetPos() )
		bot:Remove()
	end
end

function scp_055.BlueScreen(ply, keyText, font, delay)
	net.Start(SCP_055_CONFIG.BlueScreen)
		net.WriteString(keyText)
		net.WriteString(font)
		net.WriteUInt(delay, 4)
	net.Send(ply)
end

function scp_055.ForwardPlayer(ply, endStep, step)
	local currentStep = 0
	hook.Add("Think", "Think.SCP055_ForwardPlayer_".. ply:EntIndex(), function()
		if (not scp_055.IsValid(ply)) then return end

		currentStep = currentStep + step
		ply:SetPos(ply:GetPos() + Vector(currentStep, 0, 0))
		if(currentStep >= endStep) then
			hook.Remove("Think", "Think.SCP055_ForwardPlayer_".. ply:EntIndex())
			local text = SCP_055_CONFIG.SkullEventText[ math.random( #SCP_055_CONFIG.SkullEventText ) ]
			scp_055.BlueScreen(ply, text, "SCP055_BlueScreen_2", 3)
			local pos = IsValid(ply.SCP055_NPCReplace) and ply.SCP055_NPCReplace:GetPos() or ply.SCP055_OriginPos
			scp_055.MovePlayerToAPos(ply, pos, 100, 100, true)
		end
	end)
end

function scp_055.MovePlayerToAPos(ply, targetPos, velocity, endDistance, endEffect)
    if not IsValid(ply) or not targetPos then return end

	ply:SetMoveType(MOVETYPE_NOCLIP)

	hook.Add("Think", "Think.SCP055_MovePlayerToAPos_".. ply:EntIndex(), function()
		local direction = (targetPos - ply:GetPos()):GetNormalized()
		local nouvellePos = ply:GetPos() + direction * velocity

		ply:SetPos(nouvellePos)
		if (ply:GetPos():Distance(targetPos) <= endDistance) then
			hook.Remove("Think", "Think.SCP055_MovePlayerToAPos_".. ply:EntIndex()) 
			if (endEffect) then scp_055.EndSCP055Effect(ply) end
		end
	end)
end

net.Receive(SCP_055_CONFIG.ItSeeIt, function(len, ply)
	local angle = ply:EyeAngles()
	angle.pitch = 0
	local velocityAngle = 0.5 * (angle.yaw > 0 and 1 or -1)
	local yawToSet = angle.yaw > 0 and 180 or -180

	hook.Add( "Think", "Think.SCP055_YouSeeIt_".. ply:EntIndex(), function()
		if (not scp_055.IsValid(ply)) then return end

		angle.yaw = math.Clamp(angle.yaw + velocityAngle, -180, 180)
		ply:SetEyeAngles(angle)
	end)
	timer.Simple(6, function()
		if (not scp_055.IsValid(ply)) then return end
		hook.Remove("Think", "Think.SCP055_YouSeeIt_".. ply:EntIndex())
		scp_055.ForwardPlayer(ply, 300, 0.5)
	end)
end)

hook.Add( "StartCommand", "StartCommand.SCP055_ManageBot", function( bot, cmd )
	if ( not bot:IsBot() or not bot:Alive() or not bot.SCP055_IsBot ) then return end

		-- Clear any default movement or actions
		cmd:ClearMovement() 
		cmd:ClearButtons()
end)