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

-- Introduction LTE
-- by Estralis
-- EffectID = 37
-- Quest status = 44 (places), 45 (greeting), 46 (overall status)

local common = require("base.common")
local factions = require("base.factions")

local M = {}

function M.init(User)

    --[[This is a list of places the player should visit during the introduction. The order does not matter.
    1: Depot
    2: Market
    3: Workshop
    4: Cross
    5: Money Changer
    6: Notary
    7: Treasurer
    8: Faction leader
    9: Gate/guard
    10: Teleporter
    11: Temple 1
    12: Temple 2
    13: Temple 3
    ]]

    local waypoint = {}
    local waypointRadius = {}
    local informTextG = {}
    local informTextE = {}
    local dialogTextG = {}
    local dialogTextE = {}
    
    if factions.isCadomyrCitizen(User) then
    
        waypoint = {
        position(133, 626, 0),
        position(118, 606, 0),
        position(140, 587, 0),
        position(102, 562, 0),
        position(98, 567, 0),
        position(106, 553, 0),
        position(129, 529, 0),
        position(122, 521, 0),
        position(120, 642, 0),
        position(127, 647, 0),
        position(142, 564, 0),
        position(146, 677, 1),
        position(176, 761, 0)}
        
        waypointRadius = {3, 7, 5, 3, 3, 3, 3, 3, 3, 3, 5, 5, 5}
        
        informTextG = {
        "Text1 - Depot",
        "Text2 - Markt",
        "Text3 - Werkstatt",
        "Text4 - Wiederbelebung",
        "Text5 - Geldwechsler",
        "Text6 - Notar",
        "Text7 - Schatzmeister",
        "Text8 - Anf�hrer",
        "Text9 - Wache",
        "Text10 - Teleporter",
        "Text11 - Tempel 1",
        "Text12 - Tempel 2",
        "Text13 - Tempel 3"}
        
        informTextE = {
        "A highly embellished golden chest sits prominently on a table in Cadomyr, shimmering with energy and seemingly harbouring remarkable depths.",
        "Fine clothing, sparkling glassware and intricate pottery adorn the market stalls of Cadomyr as merchants toiling in the desert heat proclaim their wares to be worthy of their Queen.",
        "Suffocating heat from the vast kilns and ovens of Cadomyr's potters and glassblowers fills the sweltering workshops, whilst tailors rhythmically spin thread and weave cloth for stitching in the neighbouring room.",
        "Light splits as it strikes the ornately carved cross, colour falling to the sparkling marble surround as the atmosphere shimmers and crackles with energy. ",
        "In the backstreets of Cadomyr a humble woman diligently counts coins into cloth bags. On occasion she inconspiciously exchanges coins with passing citizens with barely a few words passing between them.",
        "A dignified woman sits at a desk neatly ordering ledgers. Two shimmering red and white banners of Cadomyr frame her, an indication she is an official of the realm.",
        "A stern man keeps careful watch on the donation platform from across the Throne Room. Two shimmering red and white banners of Cadomyr flank him, an indication of his importance to the realm.",
        "A proud, yet beautiful, woman wears a crown in the Throne Room of the Royal Palace. Undoubtedly she is Queen Rosaline Edwards, the righteous and ambitious ruler of Cadomyr.",
        "An imposing and heavily armoured guard stands to attention before the grand entrance to Cadomyr, scrutinising all those who try to pass over the bridge.",
        "The air crackles with energy around an ornate marble podium. A weathered pell sits on the podium listing a number of destinations.",
        "Lines of glorious mounted riders form a guard of honour leading to an altar, flanked by two armoured figures that depict a noble young soldier who epitomises the bravery and camaradarie of Zhambra.",
        "On occasion, the distant howl of a wolf might be carried on winds whistling through the modestly adorned mountain-top temple guarded by armoured statues that encapsulate the dignified honour of Malach�n.",
        "The once beautiful oasis temple lies in ruins with only the altar remaining intact, yet the comfort of Sirani may still be felt by those with an open heart."}
        
        dialogTextG = {
        "Text1 - Depot",
        "Text2 - Markt",
        "Text3 - Werkstatt",
        "Text4 - Wiederbelebung",
        "Text5 - Geldwechsler",
        "Text6 - Notar",
        "Text7 - Schatzmeister",
        "Text8 - Anf�hrer",
        "Text9 - Wache",
        "Text10 - Teleporter",
        "Text11 - Tempel 1",
        "Text12 - Tempel 2",
        "Text13 - Tempel 3"}
        
        dialogTextE = {
        "You will find several depots around Cadomyr, each giving you access to your stored possesions. Access the depot by double clicking it and drag items in and out of the slots. Each realm and the neutral Hemp Necktie Inn have their own storage system.",
        "The market contains a wealth of traders buying and selling anything from raw materials to the finest crafted products. Items can be sold at a tenth of their value in the primary crafting realm, indicated by the gold coin in the trading menu. They can only be sold at a twentieth of their value in the secondary crafting realm, indicated by the silver coin in the trading menu.",
        "The primary crafts of glassblowing, pottery and tailoring are fully supported with static tools, resources, merchants and guilds in Cadomyr. Secondary crafts are only partially supported with static tools, limited resources and poorer trading opportunities. Most static tools are found in or around the workshops. Hover over a tool to find out what it should be used for.",
        "Should you be unfortunate enough to perish there is every chance Cherga, the goddess of spirits and the underworld, will deny you entry to her realm as there is still so much for you to experience in Ilarion. Returned to the resurrection pillar of you chosen realm you will find yourself weak so give yourself time to recover.",
        "Copper, silver and gold coins are used in Illarion. One hundred copper coins can be exchanged for one silver coin and one hundred silver coins can be exchanged for a gold coin by the Money Changer, Cassandra Hestan.",
        "Speak to the Notary Reret Odohir if you wish to join or leave Cadomyr, find out what your rank is as a citizen of Cadomyr, or if you need to purchase a licence to use tools as a visitor to Cadomyr. You can improve your rank and advance in the Queen's favour by completing quests issued by NPCs in Cadomyr or receiving rank points from a Game Master for your contribution to the realm.",
        "Together with tax returns, donations made to the realm contribute to faction wealth and determine the number of magic gems distributed between citizens. A donation is made by placing an item or coins on the donation platform. Donated items contribute a tenth of their value.",
        "The faction ruler may be played by one of the Game Masters on occasions to attend events and interact with their subjects. If you wish to leave a message for the Queen you can contact the relevant Game Master via the forum account Rosaline Edwards. Be aware though each realm has developed their own customs and etiquette so you should try to find out what is expected of citizens. Often the faction ruler will be supported by a number of player characters who have worked their way into positions of influence.",
        "Horatio Milenus is a loyal guard of Queen Rosaline and will only allow the respectable to pass through Cadomyr's gates. Behind the gates, Cadomyr is a safe haven from the dangers beyond as the guard will defend against any monsters. Should you displease the Queen or her officials, however, you may find yourself banned from the realm and the Horatio will see you do not enter either.",
        "A teleporter can be found outside the entrance to each town and the neutral Hemp Necktie Inn. Double click on the podium to use it and for five silver you will be able to travel to another realm. Portal books can also be bought for ten silver to use anywhere on the map to transport you to a designated teleporter. In Cadomyr, Evera sells portal books from the Quartermaster Store to the east, just inside the gates.",
        "The Younger Gods dominate daily life in Illarion and Zhambra is one of three patron deities of Cadomyr. As the god of friendhip and loyalty his righteous intentions are held in high esteem amongst the faithful of Cadomyr.",
        "The Younger Gods dominate daily life in Illarion and Malach�n is one of three patron deities of Cadomyr. As the god of battle and hunting his valour and strong sense of justice are revered by the honourable of Cadomyr.",
        "The Younger Gods dominate daily life in Illarion and Sirani is one of three patron deities of Cadomyr. Amongst the faithful of Cadomyr, few will not recognise the beauty of the goddess of love and pleasure in their Queen."}
        
    elseif factions.isRunewickCitizen(User) then
    
        waypoint = {
        position(1,1,0),
        position(2,2,0),
        position(3,3,0),
        position(4,4,0),
        position(5,5,0),
        position(6,6,0),
        position(7,7,0),
        position(8,8,0),
        position(9,9,0),
        position(10,10,0),
        position(11,11,0),
        position(12,12,0),
        position(13,13,0)}
        
        waypointRadius = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
        
        informTextG = {
        "Text1 - Depot",
        "Text2 - Markt",
        "Text3 - Werkstatt",
        "Text4 - Wiederbelebung",
        "Text5 - Geldwechsler",
        "Text6 - Notar",
        "Text7 - Schatzmeister",
        "Text8 - Anf�hrer",
        "Text9 - Wache",
        "Text10 - Teleporter",
        "Text11 - Tempel Elara",
        "Text12 - Tempel Adron",
        "Text13 - Tempel Oldra"}
        
        informTextE = {
        "A highly embellished golden chest sits prominently on a table in Runewick, shimmering with energy and seemingly harbouring remarkable depths.",
        "Text2 - Market",
        "Text3 - Workshop",
        "Light splits as it strikes the ornately carved cross, the refracted colours framed by four dark columns as the atmosphere shimmers and crackles with energy. ",
        "A studious man sits diligently counting coins and recording transactions in a ledger with great accuracy. Polite exchanges are made over the table with citizens frequenting Runewick's market.",
        "A studious woman sits surrounded by parchments as she writes in a thick volume. To her side stands the blue and grey pennant of Runewick, an indication she is an official of the realm.",
        "A diligent elf carefully records any donations left on the platform beside him. Behind, the towering blue and grey pennant of Runewick provides an indication of his importance to the realm.",
        "Within his secluded island villa, an elf deep in thought, studies countless artefacts and scrolls. Undoubtedly he is Archmage Elvaine Morgan, the wise and elightened ruler of Runewick.",
        "Text9 - Guard",
        "The air crackles with energy around an ornate marble podium. An elaborately scribed pell sits on the podium listing a number of destinations.",
        "Nestled in a quiet corner of the immense library and surrounded by books and manuscripts, a simple table serves as a modest altar that encapsulates the restraint and wisdom of Elara. ",
        "Backed by tangled vines bearing bountiful bunches of grapes and flanked by heavy barrels of the finest ale, a prominent altar dominates the homely tavern, a place of many joyous festivities worthy of Adron.",
        "Carved wooden columns embraced by tangled vines shelter a modestly adorned altar, surrounded by bountiful flowers that epitomise the life Oldra brings."}
        
        dialogTextG = {
        "Text1 - Depot",
        "Text2 - Markt",
        "Text3 - Werkstatt",
        "Text4 - Wiederbelebung",
        "Text5 - Geldwechsler",
        "Text6 - Notar",
        "Text7 - Schatzmeister",
        "Text8 - Anf�hrer",
        "Text9 - Wache",
        "Text10 - Teleporter",
        "Text11 - Tempel Elara",
        "Text12 - Tempel Adron",
        "Text13 - Tempel Oldra"}
        
        dialogTextE = {
        "You will find several depots around Runewick, each giving you access to your stored possesions. Access the depot by double clicking it and drag items in and out of the slots. Each realm and the neutral Hemp Necktie Inn have their own storage system.",
        "The market contains a wealth of traders buying and selling anything from raw materials to the finest crafted products. Items can be sold at a tenth of their value in the primary crafting realm, indicated by the gold coin in the trading menu. They can only be sold at a twentieth of their value in the secondary crafting realm, indicated by the silver coin in the trading menu.",
        "The primary crafts of carpentry, cooking and brewing are fully supported with static tools, resources, merchants and guilds in Runewick. Secondary crafts are only partially supported with static tools, limited resources and poorer trading opportunities. Most static tools are found in or around the workshops. Hover over a tool to find out what it should be used for.",
        "Should you be unfortunate enough to perish there is every chance Cherga, the goddess of spirits and the underworld, will deny you entry to her realm as there is still so much for you to experience in Ilarion. Returned to the resurrection pillar of you chosen realm you will find yourself weak so give yourself time to recover.",
        "Copper, silver and gold coins are used throughout Illarion. One hundred copper coins can be exchanged for one silver coin and one hundred silver coins can be exchanged for a gold coin by the Money Changer, Argentus Almsbag.",
        "Speak to the Notary Torina Scibrim if you wish to join or leave Runewick, find out what your rank is as a citizen of Runewick, or if you need to purchase a licence to use tools as a visitor to Runewick. You can improve your rank and advance in the Archmage's favour by completing quests issued by NPCs in Runewick or receiving rank points from a Game Master for your contribution to the realm.",
        "Together with tax returns, donations made to the realm contribute to faction wealth and determine the number of magic gems distributed between citizens. A donation is made by placing an item or coins on the donation platform. Donated items contribute a tenth of their value.",
        "The faction ruler may be played by one of the Game Masters on occasions to attend events and interact with their subjects. If you wish to leave a message for the Archmage you can contact the relevant Game Master via the forum account Elvaine Morgan. Be aware though each realm has developed their own customs and etiquette so you should try to find out what is expected of citizens. Often the faction ruler will be supported by a number of player characters who have worked their way into positions of influence.",
        "Text9 - Guard",
        "A teleporter can be found outside the entrance to each town and the neutral Hemp Necktie Inn. Double click on the podium to use it and for five silver you will be able to travel to another realm. Portal books can also be bought for ten silver to use anywhere on the map to transport you to a designated teleporter. In Runewick, Phillibald sells portal books from the Guard House to the north, just as you cross the bridge.",
        "The Younger Gods dominate daily life in Illarion and Elara is one of three patron deities of Runewick. As the goddess of wisdom and knowledge her righteous intentions are held in high esteem amongst the learned of Runewick.",
        "The Younger Gods dominate daily life in Illarion and Adron is one of three patron deities of Runewick. As the god of festivities and wine his xxxxxx is revered amongst the xxxxxxxxx of Runewick.",
        "The Younger Gods dominate daily life in Illarion and Oldra is one of three patron deities of Runewick. As the goddess of xxxxxxxx amongst the xxxxxxxxx of Runewick."}
        
    elseif factions.isGalmairCitizen(User) then
    
        waypoint = {
        position(1,1,0),
        position(2,2,0),
        position(3,3,0),
        position(4,4,0),
        position(5,5,0),
        position(6,6,0),
        position(7,7,0),
        position(8,8,0),
        position(9,9,0),
        position(10,10,0),
        position(11,11,0),
        position(12,12,0),
        position(13,13,0)}
        
        waypointRadius = {1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
        
        informTextG = {
        "Text1 - Depot",
        "Text2 - Markt",
        "Text3 - Werkstatt",
        "Text4 - Wiederbelebung",
        "Text5 - Geldwechsler",
        "Text6 - Notar",
        "Text7 - Schatzmeister",
        "Text8 - Anf�hrer",
        "Text9 - Wache",
        "Text10 - Teleporter",
        "Text11 - Tempel 1",
        "Text12 - Tempel 2",
        "Text13 - Tempel 3"}
        
        informTextE = {
        "A highly embellished golden chest sits prominently in Galmair, shimmering with energy and seemingly harbouring remarkable depths.",
        "Text2 - Market",
        "Text3 - Workshop",
        "Light splits as it strikes the ornately carved cross, refracted colour falling to the feet of four golden armoured guards as the atmosphere shimmers and crackles with energy.",
        "Text5 - Money changer",
        "A man peers scrupiously at some tax records, checking off names. The sparsely decorated room gives little hint he is an official of the realm but the seal of Galmair adorns his letters.",
        "Text7 - Treasury",
        "A richly attired dwarf flips a gold coin as you enter the vast Guilianni Residence in Galmair's Crest. Undoubtedly he is Don Valerio Guilianni, the wealthy and prudent ruler of Galmair.",
        "Text9 - Guard",
        "The air crackles with energy around an ornate marble podium. A weathered pell sits on the podium listing a number of destinations.",
        "Text11 - Temple Irmorom",
        "Text12 - Temple 2",
        "Text13 - Temple 3"}
        
        dialogTextG = {
        "Text1 - Depot",
        "Text2 - Markt",
        "Text3 - Werkstatt",
        "Text4 - Wiederbelebung",
        "Text5 - Geldwechsler",
        "Text6 - Notar",
        "Text7 - Schatzmeister",
        "Text8 - Anf�hrer",
        "Text9 - Wache",
        "Text10 - Teleporter",
        "Text11 - Tempel Irmorom",
        "Text12 - Tempel 2",
        "Text13 - Tempel 3"}
        
        dialogTextE = {
        "You will find several depots around Galmair, each giving you access to your stored possesions. Access the depot by double clicking it and drag items in and out of the slots. Each realm and the neutral Hemp Necktie Inn have their own storage system.",
        "The market contains a wealth of traders buying and selling anything from raw materials to the finest crafted products. Items can be sold at a tenth of their value in the primary crafting realm, indicated by the gold coin in the trading menu. They can only be sold at a twentieth of their value in the secondary crafting realm, indicated by the silver coin in the trading menu.",
        "The primary crafts of blacksmithing, armour smithing and finesmithing are fully supported with static tools, resources, merchants and guilds in Galmair. Secondary crafts are only partially supported with static tools, limited resources and poorer trading opportunities. Most static tools are found in or around the workshops. Hover over a tool to find out what it should be used for.",
        "Should you be unfortunate enough to perish there is every chance Cherga, the goddess of spirits and the underworld, will deny you entry to her realm as there is still so much for you to experience in Ilarion. Returned to the resurrection pillar of you chosen realm you will find yourself weak so give yourself time to recover.",
        "Copper, silver and gold coins are used throughout Illarion. One hundred copper coins can be exchanged for one silver coin and one hundred silver coins can be exchanged for a gold coin by the Money Changer, XXXXX.",
        "Speak to the Notary Frederik Silvereye if you wish to join or leave Galmair, find out what your rank is as a citizen of Galmair, or if you need to purchase a licence to use tools as a visitor to Galmair. You can improve your rank and advance in the Don's favour by completing quests issued by NPCs in Galmair or receiving rank points from a Game Master for your contribution to the realm.",
        "Together with tax returns, donations made to the realm contribute to faction wealth and determine the number of magic gems distributed between citizens. A donation is made by placing an item or coins on the donation platform. Donated items contribute a tenth of their value.",
        "The faction ruler may be played by one of the Game Masters on occasions to attend events and interact with their subjects. If you wish to leave a message for the Don you can contact the relevant Game Master via the forum account Valerio Guilianni. Be aware though each realm has developed their own customs and etiquette so you should try to find out what is expected of citizens. Often the faction ruler will be supported by a number of player characters who have worked their way into positions of influence.",
        "Text9 - Guard",
        "A teleporter can be found outside the entrance to each town and the neutral Hemp Necktie Inn. Double click on the podium to use it and for five silver you will be able to travel to another realm. Portal books can also be bought for ten silver to use anywhere on the map to transport you to a designated teleporter. In Galmair, Pipillo sells portal books from the stall to the north, just inside the gates.",
        "The Younger Gods dominate daily life in Illarion and Irmorom is one of three patron deities of Galmair. As the god of xxxxxxxxxxx his xxxxxxxxx is revered by many xxxxxxxxx in Galmair.",
        "The Younger Gods dominate daily life in Illarion and Narg�n is one of three patron deities of Galmair. As the god of xxxxxxxxxxx his xxxxxxxxx are held in high esteem amongst the xxxxxxxxxx of Galmair.",
        "The Younger Gods dominate daily life in Illarion and Ronagan is one of three patron deities of Galmair. As the god of xxxxxxxxxxx his xxxxxxxxx are held in high esteem amongst the xxxxxxxxxx of Galmair."}

    end
    
    return waypoint, waypointRadius, informTextG, informTextE, dialogTextG, dialogTextE
end

function M.addEffect(introductionEffect, User)
    introductionEffect:addValue("10",0) --dummy value to make sure the effect does not get deleted right after the first call
end

function M.callEffect(introductionEffect, User)
  
    if factions.isOutlaw(User) then --abort the quest
        User:setQuestProgress(44,0)
        User:setQuestProgress(45,0)
        User:setQuestProgress(46,0)
        return false
    end

    local waypoint = {}
    local waypointRadius = {}
    local informTextG = {}
    local informTextE = {}
    local dialogTextG = {}
    local dialogTextE = {}
    
    local waypoint, waypointRadius, informTextG, informTextE, dialogTextG, dialogTextE = M.init(User)

    -- QUEST FINISHED DIALOG
    local function finishDialog()
        if M.questFinished(User, waypoint) then
            local callbackFinish = function() end --empty callback
            local dialogText = common.GetNLS(User,"Letzte Hinweise...","Final hints...")
            local dialogTitle = common.GetNLS(User,"Einf�hrung","Introduction")
            local dialogFinish = MessageDialog(dialogTitle, dialogText, callbackFinish)
            User:requestMessageDialog(dialogFinish)
        end
    end
 
    -- CHECK LOCATIONS    
    local queststatus = User:getQuestProgress(44) --here, we save which places were visited
    
    for i = 1, #waypoint do
     
        if not common.isBitSet(queststatus, i) and User:isInRangeToPosition(waypoint[i], waypointRadius[i]) then

            User:setQuestProgress(44,common.addBit(queststatus,i)) --remember we visited the place        
            local callbackFound = function(dialogFound)
                common.InformNLS(User,informTextG[i],informTextE[i])
                finishDialog()
            end --callback
           
            local dialogText = common.GetNLS(User,dialogTextG[i],dialogTextE[i])
            local dialogTitle = common.GetNLS(User,"Einf�hrung","Introduction")
            local dialogFound = MessageDialog(dialogTitle, dialogText, callbackFound)
            User:requestMessageDialog(dialogFound)            
           
        end
       
    end
 
    -- LOOK FOR OTHER PLAYERS
    local otherPlayers = world:getPlayersInRangeOf(User.pos, 5)
    if #otherPlayers > 1 and User:getQuestProgress(45) == 0 then

        User:setQuestProgress(45,1) --remember we found someone    
        local callbackGreeting = function(dialogGreeting)
            finishDialog()
        end --callback
        local callbackGreeting = function(dialogGreeting) end --callback
        local dialogText = common.GetNLS(User,"Interaktion, #i usw.","Interaction, introduction etc.")
        local dialogTitle = common.GetNLS(User,"Einf�hrung","Introduction")
        local dialogGreeting = MessageDialog(dialogTitle, dialogText, callbackGreeting)
        User:requestMessageDialog(dialogGreeting)
        
    end
 
    -- FINISH QUEST OR NEXT CALL
    if M.questFinished(User, waypoint) then
        User:setQuestProgress(46,2) --end the quest
        return false --remove the effect
    end
    
    introductionEffect.nextCalled = 10 
    return true
end

function M.removeEffect(introductionEffect, User)
    return false
end

function M.loadEffect(introductionEffect, User)

    -- Login Dialog
    local callbackLogin = function() end --empty callback
    local dialogText = common.GetNLS(User,"Willkommen zur�ck!\n\nGERMAN","Welcome back!\n\nENGLISH")
    local dialogTitle = common.GetNLS(User,"Einf�hrung","Introduction")
    local dialogLogin = MessageDialog(dialogTitle, dialogText, callbackLogin)
    User:requestMessageDialog(dialogLogin)
    
end

function M.questFinished(User, waypoint)

    if common.countBit(User:getQuestProgress(44)) == #waypoint and User:getQuestProgress(45) == 1 then
        return true
    else
        return false
    end

end

return M