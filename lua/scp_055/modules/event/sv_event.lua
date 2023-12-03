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
    local choice = math.random(1, SCP_055_CONFIG.EventCount)

    if (choice == 1) then
        scp_055.ItEvent(ply)
    end

	if (choice == 2) then
        scp_055.TalkEvent(ply)
    end

	if (choice == 3) then
        scp_055.GameEvent(ply)
    end
end

function scp_055.ItEvent(ply)
	ply:SetEyeAngles(Angle(0, 0, 0))
	timer.Simple(0.1, function()
		if (not scp_055.IsValid(ply)) then return end
		ply:Freeze(true)
	end)
	timer.Simple(10, function()
		if (not scp_055.IsValid(ply)) then return end
		ply:Freeze(false)
	end)
    net.Start(SCP_055_CONFIG.ItEvent)
    net.Send(ply)
end

function scp_055.GameEvent(ply)
    net.Start(SCP_055_CONFIG.GameEvent)
    net.Send(ply)
end


function scp_055.SetToTheDark(ply)
	net.Start(SCP_055_CONFIG.SetToTheDark)
	net.Send(ply)
end

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
		NPC.IsMoving = false
		NPC.IsPause = false
		NPC.NextPause = 0
		NPC.DurationMove = 0
		NPC.SpeedMove = math.random(80, 200)
	end

	ply.SCP055_NPCReplace = NPC
	NPC:EmitSound( Sound( "scp_055/close_briefcase.mp3" ))
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
		hook.Remove("Think", "Think.SCP055_ChaosChaos_".. ply:EntIndex())
		timer.Remove("SCP055_Timer_TalkEvent_".. ply:EntIndex())
		timer.Remove("HookRemove_SCP055_ChaosChaos_".. ply:EntIndex())

		scp_055.KillBot(ply.SCP055_NPCReplace)
		ply.SCP055_IsOpenBC = nil
	end
end

function scp_055.EndSCP055Effect(ply, isBlur)
	ply:SetMoveType(MOVETYPE_WALK)
	ply:Freeze(false)
	ply:SetColor( Color(255, 255, 255, 255))
	ply:SetRenderMode(1)

	if (ply:Alive()) then
		local bot = ply.SCP055_NPCReplace
		if (IsValid(bot)) then
			if (bot:IsPlayer()) then bot:Kick()
			else bot:Remove() end
		end
		ply.SCP055_NPCReplace = nil
		ply:SetSuppressPickupNotices( true )
		for key, value in ipairs(ply.SCP055_Weapons) do
			local weapon = ply:Give(value)
		end

		for key, value in ipairs(ply.SCP055_Ammos) do
			ply:SetAmmo(value, key)
		end
		ply:SelectWeapon( "swep_scp055" )
		ply:SetSuppressPickupNotices( false )
	end

	net.Start(SCP_055_CONFIG.RemoveTheDark)
	net.Send(ply)

	ply:StripWeapon("swep_nocursor")
	ply.SCP055_Ammos = nil
	ply.SCP055_Weapons = nil
	ply.SCP055_AffectBySCP005 = nil
	ply.SCP055_OriginPos = nil

	if (isBlur) then scp_055.BlurEffect(ply, 5.0) end
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

function scp_055.BlueScreen(ply, keyText, font, duration, multH, delay, sfx)
	net.Start(SCP_055_CONFIG.BlueScreen)
		net.WriteString(keyText)
		net.WriteString(font)
		net.WriteUInt(duration, 4)
		net.WriteFloat(multH)
		net.WriteUInt(delay, 5)
		net.WriteString(sfx)
	net.Send(ply)
end

function scp_055.BlueScreens(ply, keyText, font, duration, multH, delay, sfx)
	net.Start(SCP_055_CONFIG.BlueScreens)
		net.WriteTable(keyText)
		net.WriteString(font)
		net.WriteUInt(duration, 4)
		net.WriteFloat(multH)
		net.WriteUInt(delay, 5)
		net.WriteString(sfx)
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
			local text = SCP_055_CONFIG.ItEventText[ math.random( #SCP_055_CONFIG.ItEventText ) ]
			scp_055.BlueScreen(ply, text, "SCP055_BlueScreen_2", 3, 0.35, 0, "scp_055/it_event_end.mp3")
			local pos = IsValid(ply.SCP055_NPCReplace) and ply.SCP055_NPCReplace or ply.SCP055_OriginPos
			scp_055.MovePlayerToAPos(ply, pos, 100, 50, true)
		end
	end)
end

function scp_055.MovePlayerToAPos(ply, targetPos, velocity, endDistance, endEffect)
    if not IsValid(ply) or not targetPos then return end

	ply:SetMoveType(MOVETYPE_NOCLIP)
	local isEnt = IsEntity(targetPos)
	local pos = targetPos

	hook.Add("Think", "Think.SCP055_MovePlayerToAPos_".. ply:EntIndex(), function()
		if (isEnt) then pos = targetPos:GetPos() end
		local direction = (pos - ply:GetPos()):GetNormalized()
		local nouvellePos = ply:GetPos() + direction * velocity

		ply:SetPos(nouvellePos)
		if (ply:GetPos():Distance(pos) <= endDistance) then
			hook.Remove("Think", "Think.SCP055_MovePlayerToAPos_".. ply:EntIndex()) 
			if (endEffect) then scp_055.EndSCP055Effect(ply, true) end
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

net.Receive(SCP_055_CONFIG.EndGameEvent, function(len, ply)
	if (not scp_055.IsValid(ply)) then return end

	local pos = IsValid(ply.SCP055_NPCReplace) and ply.SCP055_NPCReplace or ply.SCP055_OriginPos
	scp_055.MovePlayerToAPos(ply, pos, 50, 50, true)
end)

hook.Add( "StartCommand", "StartCommand.SCP055_ManageBot", function( bot, cmd )
	if ( bot:IsBot() and bot:Alive() and bot.SCP055_IsBot ) then
		local CurrentTime = CurTime()
		cmd:RemoveKey( IN_DUCK ) --? We don't want the bot to crouch
		if not bot.IsMoving and not bot.IsPause then
			bot.IsMoving = true
            bot.DurationMove = CurrentTime + math.random(SCP_055_CONFIG.MinBotMove, SCP_055_CONFIG.MinBotMove * 2)
			bot.SpeedMove = math.random(80, 200)
			local Direction = Vector(math.Rand(-1, 1), math.Rand(-1, 1), 0):GetNormalized()
			cmd:ClearMovement() 
			cmd:ClearButtons()
			cmd:SetViewAngles( ( Direction ):GetNormalized():Angle() )
			bot:SetEyeAngles( ( Direction ):GetNormalized():Angle() )
		end
		if (CurrentTime > bot.DurationMove and not bot.IsPause) then
			bot.IsMoving = false
			bot.IsPause = true
			bot.NextPause = CurrentTime + math.random(SCP_055_CONFIG.MinBotPause, SCP_055_CONFIG.MinBotPause * 2)
			cmd:SetForwardMove( 0 )
		end
		if (bot.IsMoving) then
			cmd:SetForwardMove( bot.SpeedMove )
		end
		if (bot.IsPause) then
			if (CurrentTime > bot.NextPause) then bot.IsPause = false end
		end
	end
end)