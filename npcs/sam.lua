--Name:        Sam
--Race:        Human
--Town:        Grey Rose Castle
--Function:    Public trader
--Position:    x=-63 y=-221 z=0
--Facing:      North
--Last Update: 04/26/2006
--Update by:   Nitram

dofile("npc_trader_functions.lua")
dofile("npc_functions.lua")

function useNPC(user,counter,param)
    local lang=user:getPlayerLanguage();
    thisNPC:increaseSkill(1,"common language",100);
    if (lang==0) then thisNPC:talk(CCharacter.say, "Finger weg!") end
    if (lang==1) then thisNPC:talk(CCharacter.say, "Don't you touch me!") end
end

function initializeNpc()
    InitTalkLists()
    InitItemLists()

    thisNPC:increaseSkill(1,"common language",100);
    --------------------------------------------- *** EDIT BELOW HERE ***--------------------------------------
    --            EPr ,ID  ,Am,SPr,SA,Qual ,Dura   ,Data,Catagory
    AddTraderItem(80  ,180 ,5 ,2  ,5 ,{5,7},{66,77},0   ,0       ); -- shirt
    AddTraderItem(50  ,183 ,5 ,2  ,5 ,{5,7},{66,77},0   ,0       ); -- trousers
    AddTraderItem(120 ,369 ,3 ,3  ,3 ,{5,7},{66,77},0   ,0       ); -- shoes
    AddTraderItem(250 ,55  ,5 ,3  ,5 ,{5,7},{66,77},0   ,0       ); -- cape
    AddTraderItem(200 ,48  ,5 ,4  ,5 ,{5,7},{66,77},0   ,0       ); -- gloves
    AddTraderItem(350 ,53  ,5 ,4  ,5 ,{5,7},{66,77},0   ,0       ); -- boots
    AddTraderItem(120 ,356 ,5 ,2  ,5 ,{5,7},{66,77},0   ,0       ); -- farmers hat
    AddTraderItem(25  ,9   ,3 ,0  ,3 ,{4,6},{77,90},0   ,0       ); -- saw
    AddTraderItem(25  ,126 ,4 ,0  ,4 ,{4,6},{77,90},0   ,0       ); -- sickle
    AddTraderItem(25  ,24  ,5 ,0  ,5 ,{4,6},{77,90},0   ,0       ); -- shovel
    AddTraderItem(40  ,2763,5 ,0  ,5 ,{4,6},{77,90},0   ,0       ); -- pickaxe
    AddTraderItem(25  ,23  ,3 ,0  ,3 ,{4,6},{77,90},0   ,0       ); -- hammer
    AddTraderItem(40  ,311 ,3 ,0  ,3 ,{4,6},{77,90},0   ,0       ); -- glass blow pipe
    AddTraderItem(25  ,74  ,3 ,0  ,3 ,{4,6},{77,90},0   ,0       ); -- axe

    TraderCopper=300;

    AddTraderTrigger("[Gg]reetings","Indeed. Greetings. Who are you?");
    AddAdditionalTrigger("[Hh]ello");
    AddAdditionalText("Hello. How may I help you?");
    AddTraderTrigger("[Hh]allo","Hallo. Kann ich euch vielleicht helfen?");
    AddAdditionalTrigger("[Gg]r[u�][s�]+");
    AddAdditionalText("In der Tat. Gr��e. Wie geht es euch?");
    AddTraderTrigger("[Yy]ou.+[Tt]rader","Yes, I am a trader. What can I get you?");
    AddTraderTrigger("[DdIi][uh]r*.+[Hh][�a]ndler","Ja. Ich bin ein H�ndler. Kann ich etwas f�r euch besorgen?");
    AddTraderTrigger("[Ww]hat.+sell","I sell clothes, tools and more.");
    AddTraderTrigger("[Ww]as.+verkauf","Ich verkaufe Kleidung, Werkzeug und mehr.");
    AddTraderTrigger("[Ww]hat.+[Cc]loth","I sell farmer hats, shirts, trousers, capes, gloves, shoes and boots and leatherarmor.");
    AddTraderTrigger("[Ww]as.+[Kk]leidung","Ich verkaufe Schlapph�te, Hemden, Hosen, Umh�nge, Handschuhe, Schuhe, Stiefel und Lederr�stungen.");
    AddTraderTrigger("[Ww]hat.+[Tt]ool","I sell needles and scissors, saws, shovels, axes hammers and glass blowing pipes.");
    AddTraderTrigger("[Ww]as.+[Ww]erkzeug","Ich verkaufe Nadeln und Scheren. S�gen und Schaufeln. �xte und Hammer. Und Glasblasrohre.");
    AddTraderTrigger("[Ww]hat.+[Mm]ore","I have some empty bottles for sale.");
    AddTraderTrigger("[Ww]as.+[Mm]ehr","Ich habe einige leere Flaschen zum verkauf.");
    AddTraderTrigger("[Bb]ye.","Aye. Good day to you");
    AddAdditionalTrigger("[Ff]are.+well");
    AddAdditionalText("Aye! Good day.");
    AddTraderTrigger("[Aa]uf.+[Bb]ald","Bis bald!");
    AddAdditionalTrigger("[Bb]is.+[Bb]ald");
    AddAdditionalText("Kommt doch noch einmal! Ich habe immer die besten Waren");
    AddTraderTrigger("[hH]elp","'List your wares', 'I want to buy <number> <wares>', 'I want to buy a <ware>', 'I want to sell <number|a> <wares>', 'Price of ...','What do you pay for ...', 'What wares do you buy?'");
    AddTraderTrigger("[Hh]ilfe","'Welche Waren verkauft ihr', 'Ich m�chte <Anzahl> <Ware> kaufen', 'Ich m�chte <Ware> kaufen', 'Ich m�chte <Anzahl> <Ware> verkaufen', 'Was ist der Preis von <Ware>','Was zahlt ihr f�r <Ware>', 'Was kauft ihr?'");

    TraderLang={"Gold","gold","Silber", "silver","Kupfer","copper","st�cke","pieces"};
    TraderMonths={"Elos","Tanos","Zhas","Ushos","Siros","Ronas","Bras","Eldas","Irmas","Malas","Findos","Olos","Adras","Naras","Chos","Mas"};
    RefreshTime={10000,40000};

    TradSpeakLang={0,1};
    TradStdLang=0;
    --common language=0
    --human language=1
    --dwarf language=2
    --elf language=3
    --lizard language=4
    --orc language=5
    --halfling language=6
    --fairy language=7
    --gnome language=8
    --goblin language=9
    --ancient language=10

end

--------------------------------------------- *** DON'T EDIT BELOW HERE ***--------------------------------------

function nextCycle()  -- ~10 times per second
    if (TraderFirst == nil) then
        initializeNpc();
        increaseLangSkill(TradSpeakLang)
        TraderStdCopper=TraderCopper;
        thisNPC.activeLanguage=TradStdLang;
    end
    TraderCycle();
    SpeakerCycle();
end

function receiveText(texttype, message, originator)
    if BasicNPCChecks(originator,2) then
        if (LangOK(originator,TradSpeakLang)==true) then
            thisNPC.activeLanguage=originator.activeLanguage;
            Status,Values=SayPriceSell(originator, message)
            if (Status==0) then Status,Values=SayPriceBuy(originator, message) end
            if (Status==0) then Status,Values=ShowItemList(originator, message) end
            if (Status==0) then Status,Values=Selling(originator, message) end
            if (Status==0) then Status,Values=Buying(originator, message) end
            if (Status==0) then Status,Values=TellDate(originator, message, TraderMonths) end
            if (Status==0) then TellSmallTalk(message) end

            ----------------------------EDIT BELOW HERE-----------------------------------
            if (Status==1) then -- Verkauf von mehreren Items erfolgreich // Selling of multible items succeed
                gText="Ihr m�chtet "..Values[1].." "..world:getItemName(Values[2],0).." kaufen? Bitte sehr, macht dann"..MoneyText(0,Values[3],Values[4],Values[5],TraderLang)..".";
                eText="You want "..Values[1].." "..world:getItemName(Values[2],1).."? Here you are, that makes"..MoneyText(1,Values[3],Values[4],Values[5],TraderLang)..".";
            end
            if (Status==2) then -- Item kann wegen Platzmangel nicht erstellt werden // Item can't created, cause of lag of space
                gText="Tut mir leid, aber ihr habt nicht genug Platz in eurem Inventar.";
                eText="Sorry, you do not have enough space in your inventory.";
            end
            if (Status==3) then -- Nicht genug Geld um das Item zu bezahlen // not enougth money to buy the item
                gText="Kommt wieder wenn ihr genug Geld habt!";
                eText="Come back when you have enough money!";
            end
            if (Status==4) then -- Item ausverkauft // item out of stock
                gText="Tut mir leid. Ich habe das im Moment nicht. Kommt doch bitte sp�ter wieder.";
                eText="I am sorry, I don't have this currently. Come back later.";
            end
            if (Status==5) then -- Item wird nicht verkauft // item
                gText="Tut mir Leid. Ich verkaufe das nicht.";
                eText="Sorry, I do not sell that item.";
            end
            if (Status==6) then -- Verkauf eines einzelnen Items erfolgreich // Selling of a single item succeed
                gText=GenusSel(Values[2],"Ein","Eine","Ein").." "..world:getItemName(Values[2],0).." ist es, was ihr kaufen wollt? Bitte sehr, das macht"..MoneyText(0,Values[3],Values[4],Values[5],TraderLang)..".";
                eText="You want a "..world:getItemName(Values[2],1).."? Here you are, that makes"..MoneyText(1,Values[3],Values[4],Values[5],TraderLang)..".";
            end
            if (Status==7) then -- Verkaufspreis Ansage f�r ein Item // selling price announcement for an item
                gText=GenusSel(Values[1],"Ein","Eine","Ein").." "..world:getItemName(Values[1],0).." kostet"..MoneyText(0,Values[2],Values[3],Values[4],TraderLang)..".";
                eText="The "..world:getItemName(Values[1],1).." costs"..MoneyText(1,Values[2],Values[3],Values[4],TraderLang)..".";
            end
            if (Status==8) then -- Einkaufspreis Ansage f�r ein Item // buying price announcement for an item
                gText=GenusSel(Values[2],"Ein","Eine","Ein").." "..world:getItemName(Values[2],0).." w�re mir"..MoneyText(0,Values[3],Values[4],Values[5],TraderLang).." wert.";
                eText="I would pay"..MoneyText(1,Values[3],Values[4],Values[5],TraderLang).." for "..Values[1]..world:getItemName(Values[2],1);
            end
            if (Status==9) then -- Einkauf von mehreren Items erfolgreich // Buying of multible items succeed
                gText="Ihr wollt "..Values[1].." "..world:getItemName(Values[2],0).." verkaufen? Ich gebe euch"..MoneyText(0,Values[3],Values[4],Values[5],TraderLang)..".";
                eText="You want to sell "..Values[1].." "..world:getItemName(Values[2],1).."? I give you"..MoneyText(1,Values[3],Values[4],Values[5],TraderLang)..".";
            end
            if (Status==10) then -- Item das gekauft werden soll nicht vorhanden // item that should be buyed is not aviable
                gText="Kommt wieder wenn ihr das habt!";
                eText="Come back when you have that!";
            end
            if (Status==11) then -- H�ndler hat nicht genug Geld // trader don't have enougth money
                gText="Tut mir leid. Ich kann das nicht kaufen. Ich habe nicht genug Geld.";
                eText="Sorry, I cannot buy that. I do not have enough money.";
            end
            if (Status==12) then -- H�ndler kauft das Item nicht // trader didn't buy the item
                gText="So etwas kaufe ich nicht. Tut mir leid.";
                eText="Sorry, I do not buy that item.";
            end
            if (Status==13) then -- Einkauf eines einzelnen Items erfolgreich // Buying of a single item succeed
                gText=GenusSel(Values[2],"Ein","Eine","Ein").." "..world:getItemName(Values[2],0).." ist es, was ihr verkaufen m�chtet? Ich gebe euch"..MoneyText(0,Values[3],Values[4],Values[5],TraderLang)..".";
                eText="You want to sell a "..world:getItemName(Values[2],1).."? I give you"..MoneyText(1,Values[3],Values[4],Values[5],TraderLang)..".";
            end
            if (Status==14) then -- Liste der Waren die der NPC verkauft ist nicht leer // List of the wares the NPC sells, is not empty
                gText="Ich verkaufe Kleidung, Werkzeug und mehr.";
                eText="I sell clothes, tools and more.";
            end
            if (Status==15) then -- Liste der Waren die der NPC verkauft ist leer // List of the wares the NPC sells, is empty
                gText="Ich verkaufe nichts.";
                eText="I do not sell anything.";
            end
            if (Status==16) then -- Liste der Waren die der NPC kauft ist nicht leer // List of the wares the NPC buys, is not empty
                gText="Ich kaufe Kleidung, Werkzeug und mehr.";
                eText="I buy clothes, tools and more.";
            end
            if (Status==17) then -- Liste der Waren die der NPC kauft ist leer // List of the wares the NPC buys, is empty
                gText="Ich kaufe nichts.";
                eText="I do not buy anything.";
            end
            if (Status==18) then
                gText="Es ist der "..Values[1]..". Tag des Monates "..Values[2].." im Jahre "..Values[3]..".";
                local seleced=math.random(1,2)
                if (seleced==1) then
                    eText="It's day "..Values[1].." of "..Values[2].." of the year "..Values[3]..".";
                elseif (seleced==2) then
                    eText="It's the "..EnglDigit(Values[1]).." of "..Values[2].." of the year "..Values[3]..".";
                end
            end

            if (Status~=0) then
                outText=GetNLS(originator,gText,eText);
                thisNPC:talk(CCharacter.say,outText);
            end

            ---------------------------------- DON'T EDIT BELOW HERE ------------------------------
            if (string.find(message,"[sS]tatus")~=nil and originator:isAdmin()==true) then
                thisNPC:talk(CCharacter.say,"Copper="..TraderCopper ..", next delivery: "..nextDelivery.."cycCount:"..cycCount);
                statusString="Wares: ";
                for itnCnt=1,table.getn(TraderItemId) do
                    if string.len(statusString)+string.len(world:getItemName(TraderItemId[itnCnt],1))>240 then    -- line too long
                        originator:inform(statusString);                     -- say everything until here
                        statusString="";
                    end
                    statusString=statusString..world:getItemName(TraderItemId[itnCnt],1).."="..TraderItemNumber[itnCnt]..", ";
                end
                originator:inform(statusString);
            end
            if (string.find(message,"[Rr]efill")~=nil and originator:isAdmin()==true) then
                for itnCnt=1,table.getn(TraderItemId) do
                    refill(itnCnt);
                    if (TraderCopper<TraderStdCopper) then TraderCopper=TraderStdCopper end
                end
            end -- string find buy/sell/list...
        else
            if (verwirrt==false) then
                gText="#me sieht dich leicht verwirrt an";
                eText="#me looks at you a little confused";
                outText=GetNLS(originator,gText,eText);
                thisNPC:talk(CCharacter.say,outText);
                verwirrt=true;
            end
        end
    end --id
end--function
