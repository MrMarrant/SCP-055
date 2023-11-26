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

if (SERVER) then
    function scp_055.TalkEvent(ply)
        local duration = 1 -- TODO : Mettre à 3
        local keyText = {"introtalkevent_1", "introtalkevent_2", "introtalkevent_3", "introtalkevent_4"}

        scp_055.RemoveHook(ply, "HUDPaint", "HUDPaint.SCP055_SetToTheDark".. ply:EntIndex())
        scp_055.BlueScreens(ply, keyText, "SCP055_BlueScreen_3", duration, 0.45, 0)
        timer.Create( "SCP055_Timer_TalkEvent_".. ply:EntIndex(), duration * #keyText, 1, function()
            if (not scp_055.IsValid(ply)) then return end

            scp_055.ChaosChaos(ply, SCP_055_CONFIG.TalkEventDuration)
            net.Start(SCP_055_CONFIG.TalkEvent)
            net.Send(ply)
            timer.Create("SCP055_Timer_TalkEvent_".. ply:EntIndex(), SCP_055_CONFIG.TalkEventDuration, 1, function()
                if (not scp_055.IsValid(ply)) then return end

                keyText = {"outrotalkevent_1", "outrotalkevent_2", "outrotalkevent_3", "outrotalkevent_4"}
                scp_055.BlueScreens(ply, keyText, "SCP055_BlueScreen_3", duration, 0.45, 0)
                timer.Create( "SCP055_Timer_TalkEvent_".. ply:EntIndex(), duration * #keyText, 1, function()
                    if (not scp_055.IsValid(ply)) then return end

                    local pos = IsValid(ply.SCP055_NPCReplace) and ply.SCP055_NPCReplace:GetPos() or ply.SCP055_OriginPos
                    scp_055.MovePlayerToAPos(ply, pos, 100, 100, true)
                end)
            end )
        end )
    end

    function scp_055.ChaosChaos(ply, duration)
        local rayon = SCP_055_CONFIG.XDistanceSkull
        local speedRotation = 5
        local posEnt = ply:GetPos() + Vector(rayon, 0, 50)
        local timeCur = 0
        
		ply:SetEyeAngles(Angle(0, -180, 0))

        hook.Add("Think", "Think.SCP055_ChaosChaos_".. ply:EntIndex(), function()
            local angle = timeCur * speedRotation
            local newPos = scp_055.NewPosCircle(angle, rayon, posEnt)
        
            ply:SetPos(newPos)
            timeCur = timeCur + engine.TickInterval()
        end)

        timer.Create("HookRemove_SCP055_ChaosChaos_".. ply:EntIndex(), duration, 1, function()
            if (not IsValid(ply)) then return end

            hook.Remove("Think", "Think.SCP055_ChaosChaos_".. ply:EntIndex())
        end )
    end
end

if (CLIENT) then
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

    local SkullModel = ClientsideModel( "models/skull_055/skull_055.mdl" )
    SkullModel:SetModelScale(40)
    SkullModel:SetNoDraw( true )

    function scp_055.TalkEvent(ply)
        scp_055.SpawnSkull(ply, SCP_055_CONFIG.TalkEventDuration)
        timer.Create("SCP055_TalkEvent_CreateSubtiles".. ply:EntIndex(), 11.29, 1, function()
            if (not IsValid(ply)) then return end
            local timeEventDuration = SCP_055_CONFIG.TalkEventDuration - 11.29
            scp_055.Subtitles(ply, SCP_055_CONFIG.Subtiles, timeEventDuration)
            local countPsycho = 3
            local timePsycho = timeEventDuration/countPsycho
            local gifToDisplay = {
                "https://i.imgur.com/zb6q1Hh.gif",
                "https://i.imgur.com/gchvc46.gif",
                "https://i.imgur.com/bw9C3Zy.gif"
            }
            local i = 0
            timer.Create("SCP055_PsychoEffect_".. ply:EntIndex(), timePsycho, countPsycho, function()
                if (not IsValid(ply)) then return end

                i = math.random(1, #gifToDisplay)
                scp_055.DisPlayGIF(ply, gifToDisplay[i], 250, 3.7, 40, 40)
                timer.Simple(0.5, function() --? 0.5s delay before the gif show up
                    if (not IsValid(ply)) then return end
                    ply:EmitSound( Sound( "scp_055/interlude.mp3" ))
                end)

                local nextPsycho = math.Rand(timePsycho*0.3, timePsycho)
                table.remove(gifToDisplay, i)
                timer.Adjust("SCP055_PsychoEffect_".. ply:EntIndex(), nextPsycho, nil, nil)
            end)
        end)
        ply:EmitSound( Sound( "scp_055/text_event.mp3" ), 75, 100, 1)
    end
    
    function scp_055.SpawnSkull(ply, duration)
        local posPlayer = ply:GetPos()
        SkullModel:SetPos( posPlayer + Vector(SCP_055_CONFIG.XDistanceSkull, 0, 50) )
        SkullModel:SetAngles( Angle(0, -90, 0) )

        hook.Remove("HUDPaint", "HUDPaint.SCP055_SetToTheDark".. ply:EntIndex())

        hook.Add( "RenderScreenspaceEffects", "RenderScreenspaceEffects.SCP055_TalkEvent_".. ply:EntIndex(), function()
            DrawColorModify( tab )
            DrawSobel( 0.1 )
            cam.Start3D()
                render.SetStencilEnable( true )
                render.SetStencilWriteMask( 1 )
                render.SetStencilTestMask( 1 )
                render.SetStencilReferenceValue( 1 )
                render.SetStencilFailOperation( STENCIL_KEEP )
                render.SetStencilZFailOperation( STENCIL_KEEP )
                SkullModel:DrawModel()
                render.SetStencilEnable( false )
            cam.End3D()
        end )

        timer.Create("HookRemove_SCP055_TalkEvent_".. ply:EntIndex(), duration, 1, function()
            if (not IsValid(ply)) then return end
            hook.Remove("RenderScreenspaceEffects", "RenderScreenspaceEffects.SCP055_TalkEvent_".. ply:EntIndex())
        end )
    end

    net.Receive(SCP_055_CONFIG.TalkEvent, function()
        local ply = LocalPlayer()
        scp_055.TalkEvent(ply)
    end)
end
