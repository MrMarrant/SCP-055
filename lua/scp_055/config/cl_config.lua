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

SCP_055_CONFIG.ColorPietroTalk = Color(0, 196, 105)
SCP_055_CONFIG.ColorBrightTalk = Color(0, 111, 196)

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

surface.CreateFont( "SCP055_BlueScreen_3", {
    font = "Rock Salt",
    size = 100,
} )

hook.Add( "ChatText", "ChatText.SCP055_BotJoin", function( index, name, text, typeText )
    if (name == "Console") then
        local startText, endText = string.find( text, "SCP-055-01", 1, true )
        if (startText) then return true end
    end
end )

SCP_055_CONFIG.Subtiles = {
	{
		key = "subtiles_1",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 0.55
	},
	{
		key = "subtiles_2",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0.35
	},
	{
		key = "subtiles_3",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0
	},
	{
		key = "subtiles_4",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0.2
	},
	{
		key = "subtiles_5",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0
	},
	{
		key = "subtiles_6",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 0
	},
	{
		key = "subtiles_7",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0.5
	},
	{
		key = "subtiles_8",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0.17
	},
	{
		key = "subtiles_9",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0.2
	},
	{
		key = "subtiles_10",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 0.2
	},
	{
		key = "subtiles_11",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0.2
	},
	{
		key = "subtiles_12",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0.1
	},
	{
		key = "subtiles_13",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 0.2
	},
	{
		key = "subtiles_14",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0.2
	},
	{
		key = "subtiles_15",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 0.7
	},
	{
		key = "subtiles_16",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0.33
	},
	{
		key = "subtiles_17",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 0.17
	},
	{
		key = "subtiles_18",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0.24
	},
	{
		key = "subtiles_19",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0.51
	},
	{
		key = "subtiles_20",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 0.44
	},
	{
		key = "subtiles_21",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0.33
	},
	{
		key = "subtiles_22",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0.35
	},
	{
		key = "subtiles_23",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 0.36
	},
	{
		key = "subtiles_24",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0.48
	},
	{
		key = "subtiles_25",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0
	},
	{
		key = "subtiles_26",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0
	},
	{
		key = "subtiles_27",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 0
	},
	{
		key = "subtiles_28",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0.35
	},
	{
		key = "subtiles_29",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 0.41
	},
	{
		key = "subtiles_30",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0
	},
	{
		key = "subtiles_31",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 0.35
	},
	{
		key = "subtiles_32",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0.35
	},
	{
		key = "subtiles_33",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 0.48
	},
	{
		key = "subtiles_34",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0.5
	},
	{
		key = "subtiles_35",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 0.33
	},
	{
		key = "subtiles_36",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0.31
	},
	{
		key = "subtiles_37",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 0.1
	},
	{
		key = "subtiles_38",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0
	},
	{
		key = "subtiles_39",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 0.1
	},
	{
		key = "subtiles_40",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0.38
	},
	{
		key = "subtiles_41",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0.32
	},
	{
		key = "subtiles_42",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 0.64
	},
	{
		key = "subtiles_43",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0.46
	},
	{
		key = "subtiles_44",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 2
	}
}