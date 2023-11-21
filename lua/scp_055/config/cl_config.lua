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

SCP_055_CONFIG.ScrW = ScrW()
SCP_055_CONFIG.ScrH = ScrH()

SCP_055_CONFIG.RadiusEffect = SCP_055_CONFIG.RadiusEffect or 300

surface.CreateFont( "SCP055_Password", {
    font = "Oswald",
    size = 100,
} )

surface.CreateFont( "SCP055_BlueScreen_1", {
    font = "Libre Barcode 39",
    size = 100,
} )

surface.CreateFont( "SCP055_BlueScreen_2", {
    font = "Rock Salt",
    size = 300,
} )

hook.Add( "ChatText", "ChatText.SCP055_BotJoin", function( index, name, text, typeText )
    if (name == "Console") then
        local startText, endText = string.find( text, "SCP-055-01", 1, true )
        if (startText) then return true end
    end
end )