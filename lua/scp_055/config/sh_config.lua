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

local alphabet = {}
for char = 97, 122 do
    table.insert(alphabet, math.random(1, #alphabet), string.char(char))
end

for digit = 0, 9 do
    table.insert(alphabet, math.random(1, #alphabet), tostring(digit))
end

local password = ""

for i = 1, 6 do
    local randomIndex = math.random(1, #alphabet)
    password = password .. alphabet[randomIndex]
end

SCP_055_CONFIG.SecurityPassword = password
SCP_055_CONFIG.ItEventText = {}
SCP_055_CONFIG.ItEventText[1] = "not055"
SCP_055_CONFIG.ItEventText[2] = "notstupid"
SCP_055_CONFIG.ItEventText[3] = "notalone"
SCP_055_CONFIG.ItEventText[4] = "isalive"

-- In seconds, the time it takes to the ascent effect.
SCP_055_CONFIG.AscentTime = 5
SCP_055_CONFIG.TalkEventDuration = 167
SCP_055_CONFIG.AscentDirection = Vector(0, 0, 10000)
SCP_055_CONFIG.XDistanceSkull = 800
SCP_055_CONFIG.EventCount = 3
SCP_055_CONFIG.MinBotPause = 4
SCP_055_CONFIG.MinBotMove = 4

-- NET VAR
SCP_055_CONFIG.OpenPanelPassword = "SCP_055_CONFIG.OpenPanelPassword"
SCP_055_CONFIG.OpenBriefcase = "SCP_055_CONFIG.OpenBriefcase"
SCP_055_CONFIG.UnCheckBriefcase = "SCP_055_CONFIG.UnCheckBriefcase"
SCP_055_CONFIG.SetToTheDark = "SCP_055_CONFIG.SetToTheDark"
SCP_055_CONFIG.RemoveTheDark = "SCP_055_CONFIG.RemoveTheDark"
SCP_055_CONFIG.ItEvent = "SCP_055_CONFIG.ItEvent"
SCP_055_CONFIG.ItSeeIt = "SCP_055_CONFIG.ItSeeIt"
SCP_055_CONFIG.BlueScreen = "SCP_055_CONFIG.BlueScreen"
SCP_055_CONFIG.BlurEffect = "SCP_055_CONFIG.BlurEffect"
SCP_055_CONFIG.TalkEvent = "SCP_055_CONFIG.TalkEvent"
SCP_055_CONFIG.BlueScreens = "SCP_055_CONFIG.BlueScreens"
SCP_055_CONFIG.RemoveHook = "SCP_055_CONFIG.RemoveHook"
SCP_055_CONFIG.GameEvent = "SCP_055_CONFIG.GameEvent"
SCP_055_CONFIG.EndGameEvent = "SCP_055_CONFIG.EndGameEvent"
SCP_055_CONFIG.SoundToServer = "SCP_055_CONFIG.SoundToServer"
SCP_055_CONFIG.SetConvarInt = "SCP_055_CONFIG.SetConvarInt"
SCP_055_CONFIG.SetConvarBool = "SCP_055_CONFIG.SetConvarBool"
SCP_055_CONFIG.SetConvarClientSide = "SCP_055_CONFIG.SetConvarClientSide"