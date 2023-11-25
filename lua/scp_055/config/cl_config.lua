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
		pause = 0.92
	},
	{
		key = "subtiles_2",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 1.44
	},
	{
		key = "subtiles_3",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 2.29
	},
	{
		key = "subtiles_4",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 1.61
	},
	{
		key = "subtiles_5",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 1.86
	},
	{
		key = "subtiles_6",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 1.87
	},
	{
		key = "subtiles_7",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 1.37
	},
	{
		key = "subtiles_8",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 3.4
	},
	{
		key = "subtiles_9",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 1.18
	},
	{
		key = "subtiles_10",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 2.55
	},
	{
		key = "subtiles_11",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 1.22
	},
	{
		key = "subtiles_12",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 1.99
	},
	{
		key = "subtiles_13",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 1.68
	},
	{
		key = "subtiles_14",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 3.35
	},
	{
		key = "subtiles_15",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 1.91
	},
	{
		key = "subtiles_16",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 9.95
	},
	{
		key = "subtiles_17",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 1.65
	},
	{
		key = "subtiles_18",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 1.28
	},
	{
		key = "subtiles_19",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 8.14
	},
	{
		key = "subtiles_20",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 10.43
	},
	{
		key = "subtiles_21",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 2.93
	},
	{
		key = "subtiles_22",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 8.41
	},
	{
		key = "subtiles_23",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 8.73
	},
	{
		key = "subtiles_24",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 1.81
	},
	{
		key = "subtiles_25",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 10.07
	},
	{
		key = "subtiles_26",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 6.16
	},
	{
		key = "subtiles_27",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 4.04
	},
	{
		key = "subtiles_28",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 1.01
	},
	{
		key = "subtiles_29",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 0.87
	},
	{
		key = "subtiles_30",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 4.84
	},
	{
		key = "subtiles_31",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 1.84
	},
	{
		key = "subtiles_32",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 4.76
	},
	{
		key = "subtiles_33",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 1.84
	},
	{
		key = "subtiles_34",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 4.43
	},
	{
		key = "subtiles_35",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 1.79
	},
	{
		key = "subtiles_36",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 0.97
	},
	{
		key = "subtiles_37",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 2.20
	},
	{
		key = "subtiles_38",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 7.39
	},
	{
		key = "subtiles_39",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 2.15
	},
	{
		key = "subtiles_40",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 4.24
	},
	{
		key = "subtiles_41",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 3.07
	},
	{
		key = "subtiles_42",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 1.02
	},
	{
		key = "subtiles_43",
		color = SCP_055_CONFIG.ColorBrightTalk,
		pause = 3.25
	},
	{
		key = "subtiles_44",
		color = SCP_055_CONFIG.ColorPietroTalk,
		pause = 2
	}
}