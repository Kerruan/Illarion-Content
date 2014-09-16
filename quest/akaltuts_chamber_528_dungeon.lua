--[[
Illarion Server

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU Affero General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU Affero General Public License for more
details.

You should have received a copy of the GNU Affero General Public License along
with this program.  If not, see <http://www.gnu.org/licenses/>.
]]
-- INSERT INTO "quests" ("qst_id", "qst_script") VALUES (528, 'quest.Akaltuts_Chamber_528_dungeon');

require("base.common")
module("quest.akaltuts_chamber_528_dungeon", package.seeall)

GERMAN = Player.german
ENGLISH = Player.english

-- Insert the quest title here, in both languages
Title = {}
Title[GERMAN] = "Die Kammer von Akaltut IV"
Title[ENGLISH] = "Akaltut's Chamber IV"

-- Insert an extensive description of each status here, in both languages
-- Make sure that the player knows exactly where to go and what to do
Description = {}
Description[GERMAN] = {}
Description[ENGLISH] = {}
Description[GERMAN][1] = "T�te Zombies f�r den Defensor Torrens. Du ben�tigst noch zehn."
Description[ENGLISH][1] = "Kill zombies for Defensor Torrens.  You still need ten."
Description[GERMAN][2] = "T�te Zombies f�r den Defensor Torrens. Du ben�tigst noch neun."
Description[ENGLISH][2] = "Kill zombies for Defensor Torrens.  You still need nine."
Description[GERMAN][3] = "T�te Zombies f�r den Defensor Torrens. Du ben�tigst noch acht."
Description[ENGLISH][3] = "Kill zombies for Defensor Torrens.  You still need eight."
Description[GERMAN][4] = "T�te Zombies f�r den Defensor Torrens. Du ben�tigst noch sieben."
Description[ENGLISH][4] = "Kill zombies for Defensor Torrens.  You still need seven."
Description[GERMAN][5] = "T�te Zombies f�r den Defensor Torrens. Du ben�tigst noch sechs."
Description[ENGLISH][5] = "Kill zombies for Defensor Torrens.  You still need six."
Description[GERMAN][6] = "T�te Zombies f�r den Defensor Torrens. Du ben�tigst noch f�nf"
Description[ENGLISH][6] = "Kill zombies for Defensor Torrens.  You still need five."
Description[GERMAN][7] = "T�te Zombies f�r den Defensor Torrens. Du ben�tigst noch vier."
Description[ENGLISH][7] = "Kill zombies for Defensor Torrens.  You still need four."
Description[GERMAN][8] = "T�te Zombies f�r den Defensor Torrens. Du ben�tigst noch drei."
Description[ENGLISH][8] = "Kill zombies for Defensor Torrens.  You still need three."
Description[GERMAN][9] = "T�te Zombies f�r den Defensor Torrens. Du ben�tigst noch zwei."
Description[ENGLISH][9] = "Kill zombies for Defensor Torrens.  You still need two."
Description[GERMAN][10] = "T�te Zombies f�r den Defensor Torrens. Du ben�tigst noch einen."
Description[ENGLISH][10] = "Kill zombies for Defensor Torrens.  You still need one."
Description[GERMAN][11] = "Kehre zur�ck zum Defensor Torrens. Du hast seinen Test bestanden."
Description[ENGLISH][11] = "Report back to Defensor Torrens, you have finished his test."

Description[GERMAN][12] = "Der Defensor Delinificus hat vielleicht eine Aufgabe f�r dich."
Description[ENGLISH][12] = "The Defensor Delinificus may have a task for you."

Description[GERMAN][13] = "T�te Skelette f�r den Defensor Delinificus. Du ben�tigst noch zehn."
Description[ENGLISH][13] = "Kill skeletons for Defensor Delinificus.  You still need ten."
Description[GERMAN][14] = "T�te Skelette f�r den Defensor Delinificus. Du ben�tigst noch neun."
Description[ENGLISH][14] = "Kill skeletons for Defensor Delinificus.  You still need nine."
Description[GERMAN][15] = "T�te Skelette f�r den Defensor Delinificus. Du ben�tigst noch eight."
Description[ENGLISH][15] = "Kill skeletons for Defensor Delinificus.  You still need eight."
Description[GERMAN][16] = "T�te Skelette f�r den Defensor Delinificus. Du ben�tigst noch sieben."
Description[ENGLISH][16] = "Kill skeletons for Defensor Delinificus.  You still need seven."
Description[GERMAN][17] = "T�te Skelette f�r den Defensor Delinificus. Du ben�tigst noch sechs."
Description[ENGLISH][17] = "Kill skeletons for Defensor Delinificus.  You still need six."
Description[GERMAN][18] = "T�te Skelette f�r den Defensor Delinificus. Du ben�tigst noch f�nf."
Description[ENGLISH][18] = "Kill skeletons for Defensor Delinificus.  You still need five."
Description[GERMAN][19] = "T�te Skelette f�r den Defensor Delinificus. Du ben�tigst noch vier."
Description[ENGLISH][19] = "Kill skeletons for Defensor Delinificus.  You still need four."
Description[GERMAN][20] = "T�te Skelette f�r den Defensor Delinificus. Du ben�tigst noch drei."
Description[ENGLISH][20] = "Kill skeletons for Defensor Delinificus.  You still need three."
Description[GERMAN][21] = "T�te Skelette f�r den Defensor Delinificus. Du ben�tigst noch zwei."
Description[ENGLISH][21] = "Kill skeletons for Defensor Delinificus.  You still need two."
Description[GERMAN][22] = "T�te Skelette f�r den Defensor Delinificus. Du ben�tigst noch ein."
Description[ENGLISH][22] = "Kill skeletons for Defensor Delinificus.  You still need one."
Description[GERMAN][23] = "Kehre zur�ck zum Defensor Delinificus. Du hast seinen Test bestanden."
Description[ENGLISH][23] = "Report back to Defensor Delinificus, you have finished his test."

Description[GERMAN][24] = "Der Defensor Fervor hat vielleicht eine Aufgabe f�r dich."
Description[ENGLISH][24] = "The Defensor Fervor may have a task for you."

Description[GERMAN][25] = "Nenne Defensor Fervor den Namen des Gebirges in dem du dich befindest."
Description[ENGLISH][25] = "Tell Defensor Fervor the name of the mountain range you are currently in."
Description[GERMAN][26] = "Der Defensor Transmutatio hat vielleicht eine Aufgabe f�r dich."
Description[ENGLISH][26] = "The Defensor Transmutatio may have a task for you."

Description[GERMAN][27] = "Besiege den Unheiligen Erzmagier auf der Pauldron Insel f�r Defensor Transmutatio."
Description[ENGLISH][27] = "Slay the Unholy Archmage at the Pauldron Island for Defensor Transmutatio."
Description[GERMAN][28] = "Kehre zu Defensor Transmutatio zur�ck um deine Belohnung zu erhalten."
Description[ENGLISH][28] = "Return to Defensor Transmutatio for your reward."
Description[GERMAN][29] = "Der Defensor Animus hat vielleicht eine Aufgabe f�r dich."
Description[ENGLISH][29] = "The Defensor Animus may have a task for you."

Description[GERMAN][30] = "Du hast den vierte Teil der Pr�fung bestanden."
Description[ENGLISH][30] = "You have finished part four of the testing."

-- Insert the position of the quest start here (probably the position of an NPC or item)
Start = {}

-- For each status insert a list of positions where the quest will continue, i.e. a new status can be reached there
QuestTarget = {}

-- Insert the quest status which is reached at the end of the quest
FINAL_QUEST_STATUS = 30


function QuestTitle(user)
    return base.common.GetNLS(user, Title[GERMAN], Title[ENGLISH])
end

function QuestDescription(user, status)
    local german = Description[GERMAN][status] or ""
    local english = Description[ENGLISH][status] or ""

    return base.common.GetNLS(user, german, english)
end

function QuestStart()
    return Start
end

function QuestTargets(user, status)
    return QuestTarget[status]
end

function QuestFinalStatus()
    return FINAL_QUEST_STATUS
end

function QuestAvailability(user, status)
    return Player.questAvailable
end