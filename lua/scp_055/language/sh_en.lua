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

local LANG_EN = {
    enter = "ENTER",
    quit = "QUIT",
    not055 = "It isn't you",
    notstupid = "It isn't stupid",
    notalone = "It isn't alone",
    isalive = "Is isn't alive",

    introtalkevent_1 = "And I heard as it were the noise of thunder",
    introtalkevent_2 = "One of the four beasts saying come and see",
    introtalkevent_3 = "And I saw",
    introtalkevent_4 = "And behold a white horse",

    outrotalkevent_1 = "And I heard a voice in the midst of the four beasts",
    outrotalkevent_2 = "And I looked and behold a pale horse",
    outrotalkevent_3 = "And his name that sat on him was death",
    outrotalkevent_4 = "And hell followed with him",

    ohsothatis = "Oh … so that's how it is.",

    needcard_description = "Enable if it need to have the security card for open SCP-055 briefcase",
    radiuseffect_description = "Radius effect of the briefcase, set it to 0 to disable it",
    warningsettings = "Only Super Admins can change these values, all other roles will do nothing.",
    useonceperlife_description = "If checked, a player can only use SCP-055 once per lifetime.",
    maxdurationgameevent_description = "Set max time before tp directly to last screen during the mini game event.",

    -- Subtiles TalkEvent
    subtiles_1 = "Can I come in?",
    subtiles_2 = "But of course.",
    subtiles_3 = "There's enough broken glass for everyone!",
    subtiles_4 = "I was joking, you know.",
    subtiles_5 = "You could have grabbed a chair.",
    subtiles_6 = "It's fine. The suit's sturdy.",
    subtiles_7 = "Suit yourself then.",
    subtiles_8 = "Hey, That's a fancy piece of kit you've got there.",
    subtiles_9 = "Wanna trade?",
    subtiles_10 = "No way! I've read the file.",
    subtiles_11 = "Worth a shot.",
    subtiles_12 = "Been a while since you laughed, huh?",
    subtiles_13 = "Not been much to laugh at.",
    subtiles_14 = "Not even when Pesterbot showed up on all the TVs?",
    subtiles_15 = "Okay, that was kind of funny.",
    subtiles_16 = "So, you got away too. I mean, I'm assuming you were a Foundation guy, not one of the many people I've pissed off in my lifetime here for revenge.",
    subtiles_17 = "Aren't those the same thing?",
    subtiles_18 = "Now you're getting it!",
    subtiles_19 = "Yeah, I'm Foundation. Was Foundation, I mean. Got lucky when this all started, got into the suit and escaped. You?",
    subtiles_20 = "Well, I was Senior Staff, we would have been told about the plan before anyone else, but damn if I can't remember what it was. Probably because of the second file.",
    subtiles_21 = "The second file? You saw it? What was it?!",
    subtiles_22 = "Woah, cool your jets, kid. We've got all the time in the world. They were just a bunch of images, eggs, trees, religious stuff",
    subtiles_23 = "Didn't mean anything to me by themselves, but I guess they had something encoded in them. Didn't take like they should have, probably because of this thing.",
    subtiles_24 = "So it was a memetic agent...",
    subtiles_25 = "Don't know about that. I've pretty much had everything that can happen to me, well, happen to me. I know what a memetic agent feels like.",
    subtiles_26 = "It didn't feel like that, more like I was being released from something than something being forced on me.",
    subtiles_27 = "I ... I see. So, you don't really know what's going on, either?",
    subtiles_28 = "Nope.",
    subtiles_29 = "F ... uck.",
    subtiles_30 = "So, you heading somewhere or just wandering around feeling sorry for yourself?",
    subtiles_31 = "I'm heading to 579.",
    subtiles_32 = "If you're suicidal, there are easier ways to go about it, believe me!",
    subtiles_33 = "You know what it is?",
    subtiles_34 = "Not a clue, which is concerning, because I'm kind of a big deal.",
    subtiles_35 = "Doesn't matter. I have to get there.",
    subtiles_36 = "Why?",
    subtiles_37 = "I just do. Where are you headed?",
    subtiles_38 = "1437. Gonna see if I can't piss into another universe. Then throw this amulet down there and see where I wake up.",
    subtiles_39 = "Sounds like a plan. Good luck to you.",
    subtiles_40 = "I'd wish you good luck, too, but we both know you're not getting it.",
    subtiles_41 = "Day's about to break. I'm heading off.",
    subtiles_42 = "Okay.",
    subtiles_43 = "I hope you find what you're looking for, at least.",
    subtiles_44 = "Me too."
}

scp_055.AddLanguage("en", LANG_EN)