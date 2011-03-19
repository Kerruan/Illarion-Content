--37 cow id, faceto= 6 (west)
--775,796,0
--Cheeseball

require("base.common")
require("quest.aquest28");    --the quest file
module("npc.cow2_aquest28", package.seeall)
			   

function InitNPC()
    if not InitDone then
        InitDone = true;
        CowID = 3; --id of this cow NEEDS TO BE CHANGED AT EACH COW
        
		ActiveTask = 0;
		
		TradSpeakLang={0,1,2,3,4,5,6,7,8,9,10};
		quest.aquest28.increaseLangSkill(TradSpeakLang,thisNPC);
    	thisNPC.activeLanguage=0;
    	
                  --comb, water bucket, lute ,   nothing,bundle of grain, big empty bottle         
        itemlist = quest.aquest28.getTaskItems();
       -- npc_names = { "Betsy", "Mjilka", "Cheeseball"};
    end
end 

function useNPC(originator,counter,param)
  	User = getCharForId(originator.id);  --create a save copy of the char struct
  	
	ActiveTask = quest.aquest28.Cow_useNPC(User, CowID, ActiveTask,thisNPC);
end
 

function receiveText(texttype, message, originator)
	quest_aquest28.Cow_receiveText(originator,message, CowID,thisNPC);
end                

function nextCycle()
-- disabled, does not work

    InitNPC();
    
    ActiveTask = quest.aquest28.Cow_NextCycle(User,ActiveTask,thisNPC);
end