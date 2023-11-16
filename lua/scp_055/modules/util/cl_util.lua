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

local AddAlpha = 0.1
local DrawAlpha = 0.2
local Delay = 0.05

function scp_055.SetBriefcaseEffect(ent)
    local ply = LocalPlayer()
    local maxRange = SCP_055_CONFIG.RadiusEffect

    if (ply:GetPos():Distance(ent:GetPos()) > maxRange) then return end

    local distanceLeft = maxRange - ply:GetPos():Distance(ent:GetPos())
    tab[ "$pp_colour_contrast" ] = 1 - 0.99 * (distanceLeft / maxRange)

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

        ent:DrawModel()

        render.SetStencilEnable( false )
    cam.End3D()

    DrawMotionBlur( AddAlpha, DrawAlpha, Delay )
end