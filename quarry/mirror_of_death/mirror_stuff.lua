
-- will be used post vbu --
-- Mirror of Death --
	if (Item.pos == position(892,390,0)) and (User:getFaceTo() == 2) and (User.pos == position(890,390,0)) then
	    MirrorOfDeath(User)
	    return
	end	-- end of mirror of death
	
	
	
	
	function MirrorOfDeath(User)
	-- shows the a picture of him after his death
	-- can be reducned by donations, see coin scripts MoveItemAfterMove
	
	getProgress = User:getQuestProgress(666)
	if getProgress == 0 then
	    getProgress = 10000
	end	
	charSex = User:increaseAttrib("sex",0)
	charRace = User:getRace()
	deathCounter = getProgress-((math.floor(getProgress/10))*10)  
	
	if deathCounter == 0 then
		base.common.InformNLS(User, "Im Spiegel siehst du ein Bild deiner selbst - jedoch in den besten deiner Jahre, bei voller Gesundheit.",
									"You see yourself in the mirror - but in your prime time and fit as a fiddle.")
	else
	    if charSex == 0 then
		    base.common.InformNLS(User, DeathTextMaleDE[charRace][deathCounter], DeathTextMaleEN[charRace][deathCounter])
	    else
	        base.common.InformNLS(User, DeathTextFemaleDE[charRace][deathCounter], DeathTextFemaleEN[charRace][deathCounter])
	    end
	end
end

DeathTextMaleDE = {}
DeathTextMaleEN = {}
-- human
DeathTextMaleDE[0] = {"de1","de2","de3","de4","de5"}
DeathTextMaleEN[0] = {"en1","en2","en3","en4","en5"}
-- dwarf
DeathTextMaleDE[1] = {"de1","de2","de3","de4","de5"}
DeathTextMaleEN[1] = {"en1","en2","en3","en4","en5"}
-- halfling
DeathTextMaleDE[2] = {"de1","de2","de3","de4","de5"}
DeathTextMaleEN[2] = {"en1","en2","en3","en4","en5"}
-- elf
DeathTextMaleDE[3] = {"de1","de2","de3","de4","de5"}
DeathTextMaleEN[3] = {"en1","en2","en3","en4","en5"}
-- orc
DeathTextMaleDE[4] = {"de1","de2","de3","de4","de5"}
DeathTextMaleEN[4] = {"en1","en2","en3","en4","en5"}
-- lizard
DeathTextMaleDE[5] = {"de1","de2","de3","de4","de5"}
DeathTextMaleEN[5] = {"en1","en2","en3","en4","en5"}

DeathTextFemaleDE = {}
DeathTextFemaleEN = {}
-- human
DeathTextFemaleDE[0] = {"de1","de2","de3","de4","de5"}
DeathTextFemaleEN[0] = {"en1","en2","en3","en4","en5"}
-- dwarf
DeathTextFemaleDE[1] = {"de1","de2","de3","de4","de5"}
DeathTextFemaleEN[1] = {"en1","en2","en3","en4","en5"}
-- halfling
DeathTextFemaleDE[2] = {"de1","de2","de3","de4","de5"}
DeathTextFemaleEN[2] = {"en1","en2","en3","en4","en5"}
-- elf
DeathTextFemaleDE[3] = {"de1","de2","de3","de4","de5"}
DeathTextFemaleEN[3] = {"en1","en2","en3","en4","en5"}
-- orc
DeathTextFemaleDE[4] = {"de1","de2","de3","de4","de5"}
DeathTextFemaleEN[4] = {"en1","en2","en3","en4","en5"}
-- lizard
DeathTextFemaleDE[5] = {"de1","de2","de3","de4","de5"}
DeathTextFemaleEN[5] = {"en1","en2","en3","en4","en5"}


function LookAtItem(User,Item)
    if Item.pos == position(891,390,0) then -- cherga temple, infront of Mirror of Death
	    world:itemInform( User,Item,base.common.GetNLS( User, "Opferschale", "Sacrificial bowl") )
    else
        world:itemInform( User,Item,base.common.GetNLS( User, "Teller", "plate") )
    end
end

-- sacrificial bowl for the Mirror of Death
-- here, the death counter is reduced 
-- only money is accepted 
-- see also: 
-- item.id_2874_mirror

function MoveToField(User) -- char dares to step on the sacrificial bowl
    if User:getType() == 0 then -- only if a player the char gets damaged; no abuse for monsters
	   User:increaseAttrib("hitpoints",-1000)
	end   
	world:gfx(44,User.pos)
	world:makeSound(5,User.pos)
	base.common.HighInformNLS(User,"Deine F��e brennen schmerzhaft.","Your feet burn painfully.")
end

function PutItemOnField(Item,User)

    if (Item.id ~= 61) and (Item.id ~= 3076) and (Item.id ~= 3077) then -- no money, refuse of the sacrifice
        base.common.InformNLS(User,"Dein Opfer springt wie von selbst aus der Sch�ssel heraus. Dir ist, als h�rst du das Klimpern von M�nzen. Vielleicht ein Hinweis."
		                          ,"On its own, your sacrifice jumps out of the bowl. You think to hear jingling of coins. Maybe a hint. ")
        world:createItemFromItem(Item,position(891,389,0)) -- next to the bowl, we create the new item
		world:eraseItem(Item,Item.number) -- and delete the old one
		
    else 
	    local moneyAmount
		-- money sacrificed in copper coins
		if Item.id == 61 then
		    moneySacr = Item.number*10000
        elseif Item.id == 3077 then
		    moneySacr = Item.number*100
		else	
            moneySacr = Item.number
        end
		
		--The code below is hard to understand. Please add commentaries. ~Estralis
		local quPrg
		quPrg = User:getQuestProgress(666)
		if quPrg == 0 then
			quPrg = 10000 -- first digit doesn't play any role; second digit = how often the char died; third to sixth digit = money counter
		end

		--Especially here: 10000, 1000, where do these constants come from? ~Estralis
		local deathCounter = math.floor((quPrg-10000)/1000)
		local oldMoney = quPrg - 10000 - deathCounter*1000
		
		if deathCounter == 0 then -- there is no death count to be lowered, we accept any donation happily
		    world:gfx(31,position(891,390,0))
		    base.common.InformNLS(User, "Ein angenehmes Gef�hl erf�llt dich, als die Gottheit deine Spende zu akzeptieren scheint.",
				                        "You get a comfortable feeling, as the divinity seems to accept your offer.")
		else
		    local newMoney = moneySacr + oldMoney
			if newMoney < 500 then -- not enough donated yet
			    base.common.InformNLS(User, "Die M�nzen verschwinden, doch dich beschleicht das Gef�hl noch nicht genug gespendet zu haben. Wirf einen Blick in den Spiegel.",
				                            "The coins vansih, but you get the feeling that you may haven't sacrificed enough. Look in the mirror.")
				local setMoney = (quPrg - oldMoney + newMoney)						
		        User:setQuestProgress(666, setMoney)
		
            else 
			    local deathReducer = math.floor(newMoney/500)
				local moneyKept = newMoney - (deathReducer*500) -- rest of money, below 500 copper coins; we keep it for further payments
				local newDeathCounter = 1000*(base.common.Limit(deathCounter-deathReducer, 0, 5))
			    User:setQuestProgress(666,10000+newDeathCounter+moneyKept)
			end	
		end
	end
end	