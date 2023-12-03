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

local RoadSigns = {}
local AddAlpha = 0.1
local DrawAlpha = 0.2
local Delay = 0.05
local tab = {
    [ "$pp_colour_addr" ] = 0,
    [ "$pp_colour_addg" ] = 0,
    [ "$pp_colour_addb" ] = 0,
    [ "$pp_colour_brightness" ] = 0,
    [ "$pp_colour_contrast" ] = 0,
    [ "$pp_colour_colour" ] = 0,
    [ "$pp_colour_mulr" ] = 0,
    [ "$pp_colour_mulg" ] = 0,
    [ "$pp_colour_mulb" ] = 0
}

local ItPosition = Vector(-100, 0, 65)
local It = ClientsideModel( "models/eye_it/eye_it.mdl" )

It:SetModelScale(40)
It:SetAngles( Angle(0, 90, 0) )
It:SetNoDraw( true )

for var = 1, 6 do
    local ClModel = ClientsideModel( "models/road_sign/road_sign.mdl" )
    ClModel:SetModelScale(20)
    ClModel:SetNoDraw( true )
    table.insert(RoadSigns, ClModel)
end

function scp_055.ItEvent()
    local ply = LocalPlayer()
    ply.SCP055_DelayIt = 0
    timer.Create("SCP055_DelayIt_".. ply:EntIndex(), 3, 4, function()
        if(not IsValid(ply)) then return end

        scp_055.SpawnRoadSign(ply)
        ply.SCP055_DelayIt = ply.SCP055_DelayIt + 2
        if (ply.SCP055_DelayIt <= 6) then ply:EmitSound(Sound("scp_055/spot_on.mp3")) end
        if (ply.SCP055_DelayIt == 2) then timer.Adjust( "SCP055_DelayIt_".. ply:EntIndex(), 2 ) end
        if (ply.SCP055_DelayIt == 8) then 
            hook.Add( "Think", "Think.SCP055_ItSeeIt_".. ply:EntIndex(), function() scp_055.ItSeeIt(ply) end)
        end
    end)
end

function scp_055.SpawnRoadSign(ply)
    local angle = Angle(0, 180, 0)
    local posPlayer = ply:GetPos()

    hook.Remove("HUDPaint", "HUDPaint.SCP055_SetToTheDark".. ply:EntIndex())

    hook.Add( "RenderScreenspaceEffects", "RenderScreenspaceEffects.SCP055_ItEvent_".. ply:EntIndex(), function()
        if (not IsValid(ply)) then return end

        DrawColorModify( tab )
        DrawSobel( 0.1 )
        cam.Start3D()
            render.SetStencilEnable( true )
            render.SetStencilWriteMask( 1 )
            render.SetStencilTestMask( 1 )
            render.SetStencilReferenceValue( 1 )
            render.SetStencilFailOperation( STENCIL_KEEP )
            render.SetStencilZFailOperation( STENCIL_KEEP )
            local distanceEdit = Vector(200, -200, 50)
            for key, value in ipairs(RoadSigns) do
                if (key <= ply.SCP055_DelayIt) then
                    value:SetPos( posPlayer + distanceEdit )
                    value:SetAngles( angle )
                    value:DrawModel()

                    distanceEdit.y = distanceEdit.y * -1
                    angle.yaw = angle.yaw == 180 and 0 or 180
                    if (key % 2 == 0) then distanceEdit.x = distanceEdit.x + 400 end
                end
            end
            if(ply.SCP055_DelayIt >= 8) then 
                It:SetPos( posPlayer + ItPosition )
                It:DrawModel()
            end
            render.SetStencilEnable( false )
        cam.End3D()
    end )
end

function scp_055.ItSeeIt(ply)
    local angle = ply:GetAngles()
    if ((angle.yaw <= -80 and angle.yaw >= -180) or (angle.yaw >= 80 and angle.yaw <= 180)) then
        hook.Remove("Think", "Think.SCP055_ItSeeIt_".. ply:EntIndex())
        net.Start(SCP_055_CONFIG.ItSeeIt)
        net.SendToServer()
        ply:EmitSound( Sound("scp_055/it.mp3") )
    end
end

function scp_055.SetToTheDark()
	local countTime = 0
	local startTime = CurTime()
	local ply = LocalPlayer()
    local maxTime = SCP_055_CONFIG.AscentTime
	local tab = {
        [ "$pp_colour_addr" ] = 0,
        [ "$pp_colour_addg" ] = 0,
        [ "$pp_colour_addb" ] = 0,
        [ "$pp_colour_brightness" ] = 0,
        [ "$pp_colour_contrast" ] = 1,
        [ "$pp_colour_colour" ] = 1,
        [ "$pp_colour_mulr" ] = 0,
        [ "$pp_colour_mulg" ] = 0,
        [ "$pp_colour_mulb" ] = 0
    }

	hook.Add("HUDPaint", "HUDPaint.SCP055_SetToTheDark".. ply:EntIndex(), function()
		if(not IsValid(ply)) then return end

		countTime = math.Clamp( CurTime() - startTime, 0, maxTime )

		tab[ "$pp_colour_contrast" ] = 1 - 1 * (countTime / maxTime)
	
		DrawColorModify( tab )
		cam.Start3D()
			render.SetStencilEnable( true )
			render.SetStencilWriteMask( 1 )
			render.SetStencilTestMask( 1 )
			render.SetStencilReferenceValue( 1 )
			render.SetStencilFailOperation( STENCIL_KEEP )
			render.SetStencilZFailOperation( STENCIL_KEEP )
	
			render.SetStencilCompareFunction( STENCIL_ALWAYS )
			render.SetStencilPassOperation( STENCIL_REPLACE )
	
			render.SetStencilEnable( false )
		cam.End3D()
	
		DrawMotionBlur( AddAlpha, DrawAlpha, Delay )
    end)
    ply:EmitSound( Sound("scp_055/begin.mp3") )	
end

function scp_055.RemoveTheDark()
    local ply = LocalPlayer()

    hook.Remove("HUDPaint", "HUDPaint.SCP055_SetToTheDark".. ply:EntIndex())
    hook.Remove("RenderScreenspaceEffects", "RenderScreenspaceEffects.SCP055_ItEvent_".. ply:EntIndex())
    hook.Remove("RenderScreenspaceEffects", "RenderScreenspaceEffects.SCP055_BlurryVision_".. ply:EntIndex())
    hook.Remove("RenderScreenspaceEffects", "RenderScreenspaceEffects.SCP055_TalkEvent_".. ply:EntIndex())
    hook.Remove("HUDPaint", "HUDPaint.SCP055_BlueScreen_".. ply:EntIndex())
    hook.Remove("PostDrawHUD", "PostDrawHUD.SCP055_Subtitles_".. ply:EntIndex())
    hook.Remove("PostDrawHUD", "PostDrawHUD.SCP055_GameEventLastWord_".. ply:EntIndex())
    hook.Remove("Think", "Think.SCP055_ProximityEffect".. ply:EntIndex())
    if (ply.SCP055_staticNoise) then ply.SCP055_staticNoise:Remove() end
    timer.Remove("SCP055_DelayBlueScreen_".. ply:EntIndex())
    timer.Remove("HookRemove_SCP055_Subtitles_".. ply:EntIndex())
    timer.Remove("HookRemove_SCP055_TalkEvent_".. ply:EntIndex())
    timer.Remove("SCP055_TalkEvent_CreateSubtiles".. ply:EntIndex())
    timer.Remove("SCP055_PsychoEffect_".. ply:EntIndex())
    timer.Remove("SCP055_DelayIt_".. ply:EntIndex())
    timer.Remove("Falling.SCP055_Key_MovePlayer".. ply:EntIndex())
    timer.Remove("SCP055_SetAlphaGamePanel_".. ply:EntIndex())
    hook.Remove("Think", "Think.SCP055_ItSeeIt_".. ply:EntIndex())
    ply:StopSound( "scp_055/talk_event_begin.mp3" )
    ply:StopSound( "scp_055/talk_event_end.mp3" )
    ply:StopSound( "scp_055/it_event_end.mp3" )
    ply:StopSound( "scp_055/end_effect.mp3" )
    ply:StopSound( "scp_055/text_event.mp3" )
    ply:StopSound( "scp_055/begin.mp3" )
    ply:StopSound( "scp_055/end.wav" )
    ply:StopSound( "scp_055/it.mp3" )
    if (IsValid(ply.SCP0555_FrameGameEvent)) then 
        ply.SCP0555_FrameGameEvent:Remove()
        ply.SCP0555_FrameGameEvent = nil
    end
end

function scp_055.BlueScreen(ply, keyText, font, duration, multH, delay, sfx)
    local multW = 0.5
    local defineMultH = multH
    local key = type(keyText) == "table" and keyText[1] or keyText
    local i = 1
    delay = delay or 0
    timer.Simple(delay, function()
        if (not IsValid(ply)) then return end

        ply.SCP055_staticNoise = scp_055.DisPlayGIF(ply, "https://i.imgur.com/fVFcRiM.gif", 0.2)
        hook.Add("HUDPaint", "HUDPaint.SCP055_BlueScreen_".. ply:EntIndex(), function()
            surface.SetDrawColor( 0, 102, 255)
            surface.DrawRect(0, 0, SCP_055_CONFIG.ScrW, SCP_055_CONFIG.ScrH)
            draw.DrawText( scp_055.GetTranslation(key), font, SCP_055_CONFIG.ScrW * multW, SCP_055_CONFIG.ScrH * multH, Color(255, 255, 255, 199), TEXT_ALIGN_CENTER )
            multW = multW == 0.5 and 0.498 or 0.5
            multH = multH == defineMultH and defineMultH - 0.002 or defineMultH
        end)
        
        if (type(keyText) == "table") then
            timer.Create("SCP055_DelayBlueScreen_".. ply:EntIndex(), duration, #keyText - 1, function()
                if (not IsValid(ply)) then return end
                i = i + 1
                key = keyText[i]
            end)
        end

        ply:EmitSound( Sound( sfx ))
        duration = type(keyText) == "table" and duration * #keyText or duration
        timer.Simple(duration, function()
            if (not IsValid(ply)) then return end
            hook.Remove("HUDPaint", "HUDPaint.SCP055_BlueScreen_".. ply:EntIndex())
            ply.SCP055_staticNoise:Remove()
        end)
    end)
end

net.Receive(SCP_055_CONFIG.ItEvent, function()
    scp_055.ItEvent()
end)

net.Receive(SCP_055_CONFIG.SetToTheDark, function()
    scp_055.SetToTheDark()
end)

net.Receive(SCP_055_CONFIG.RemoveTheDark, function()
    scp_055.RemoveTheDark()
end)

net.Receive(SCP_055_CONFIG.BlueScreen, function()
    local ply = LocalPlayer()
    local keyText = net.ReadString()
    local font = net.ReadString()
    local duration = net.ReadUInt(4)
    local multH = net.ReadFloat()
    local delay = net.ReadUInt(5)
    local sfx = net.ReadString()
    scp_055.BlueScreen(ply, keyText, font, duration, multH, delay, sfx)

    hook.Remove("RenderScreenspaceEffects", "RenderScreenspaceEffects.SCP055_ItEvent_".. ply:EntIndex())
end)

net.Receive(SCP_055_CONFIG.BlueScreens, function()
    local ply = LocalPlayer()
    local keyText = net.ReadTable()
    local font = net.ReadString()
    local duration = net.ReadUInt(4)
    local multH = net.ReadFloat()
    local delay = net.ReadUInt(5)
    local sfx = net.ReadString()
    scp_055.BlueScreen(ply, keyText, font, duration, multH, delay, sfx)

    hook.Remove("RenderScreenspaceEffects", "RenderScreenspaceEffects.SCP055_ItEvent_".. ply:EntIndex())
end)