-- Fighting System
-- All fights are handled with this script
-- Written by Flux


-- SUPER IMPORTANT TIP:
-- There are several variables in this script that can be easily tweaked to change things in the game.
-- Only a few of them should ever be considered for changing. These are the ones:
-- The Armour Scaling Factor (ASF). This scales how much better the top armour is than the bottom one.
-- The Shield Scaling Factor (SSF). This scales how much better the top shield is than the bottom one.
-- The Global Damage Factor (GDF). This scales how much damage all weapons do.
-- The Global Speed Mod (GSM). This scales how fast everyone hits.
-- The Distance Reduction Modifier (DRM). Modifies how inaccurate archers get from further away.

-- Weapon scaling is actually done in the stats, because it needs to scaled the Weapon Factor (WF).
-- This is equal to Attack*Accuracy/Actionpoints. This is harder to scale.
-- This is because armour is obvious. 100 armour = The top stat. With weapons it is much different.
-- Because some weapons are slow but strong and some accurate but weak etc. etc.
-- Ideally weapon fightpoints should be >=10, accuray <=98 and attack can be anything.
-- The WF itself scales up to 7.5.

--[[ Weapontypes:
1:  1 hd slashing
2:  1 hd concussion
3:  1 hd puncture
4:  2 hd slashing
5:  2 hd concussion
6:  2 hd puncture
7:  (cross-) Bow, sling, spear, throwing star
10: Arrows
11: Crossbow bolts
12: Sling ammo
13: Wands
14: shields
]]

-- Hang in base.common - Some functions of the collection are needed
require("base.common")

-- Include base.character to use the methods changing some attributes of the character properly there
require("base.character")

-- For learning skills...
require("server.learn")

-- Lists with static values of the fighting system
require("content.fighting")

-- Include the regeneration LTE to access the control functions of this LTE
require("lte.chr_reg");

-- for gem bonus
require("base.gems")

module("development.testscript", package.seeall)

--- Main Attack function. This function is called by the server to start an
-- attack. It is called once for each hand of the attacker. Only the hand holding a
-- weapon will attack. In case there are weapons in both hands, only the
-- right hand will be used to perform the attack.
-- @param Attacker The character who attacks
-- @param Defender The character who is attacked
-- @return true in case a attack was performed, else false
function onAttack(Attacker, Defender)
    -- Prepare the lists that store the required values for the calculation
    local Attacker = { ["Char"]=Attacker };
    local Defender = { ["Char"]=Defender };
    local Globals = {};


    -- Newbie Island Check
    if not NewbieIsland(Attacker.Char, Defender.Char) then return false; end;
    -- Load the weapons of the attacker
    LoadWeapons(Attacker);
    -- Check the range between the both fighting characters

	-- Find out the attack type and the required combat skill
	GetAttackType(Attacker);

    if not CheckRange(Attacker, Defender.Char) then return false; end;
    
    -- Check if the attack is good to go (possible weapon configuration)
    if not CheckAttackOK(Attacker) then 
        return false; 
    end;
    -- Check if ammunition is needed and use it
    if not HandleAmmunition(Attacker) then return false; end;
    
    -- Load Skills and Attributes of the attacking character
    LoadAttribsSkills(Attacker, true);
    -- Load weapon data, skills and attributes of the attacked character
    LoadWeapons(Defender);
    LoadAttribsSkills(Defender, false);

	--Calculate crit chance
	if CheckCriticals(Attacker, Defender, Globals) then
		--Do special crit effects
		Specials(Attacker, Defender, Globals);
	end;

    -- Calculate and reduce the required movepoints
    APreduction=HandleMovepoints(Attacker, Globals);

	-- Turning the attacker to his victim
    base.common.TurnTo(Attacker.Char,Defender.Char.pos);
    -- Show the attacking animation
    ShowAttackGFX(Attacker);
    -- Check if a coup de gr�ce is performed
    if CoupDeGrace(Attacker, Defender) then return true; end;
    
    -- Calculate the chance to hit
    if not HitChanceFlux(Attacker, Defender, Globals) then
        -- Place some ammo on the ground in case ammo was used
        DropAmmo(Attacker, Defender.Char, true);
        return;
    end;
    
    -- Calculate the damage caused by the attack
    CalculateDamage(Attacker, Globals);

    -- Reduce the damage due the absorbtion of the armor
    ArmourAbsorption(Attacker, Defender, Globals);

    -- The effect of the constitution. After this the final damage is avaiable.
    ConstitutionEffect(Defender, Globals);

    -- Cause the finally calculated damage to the player
    CauseDamage(Attacker, Defender, Globals);
    
	--Cause degradation
	ArmourDegrade(Defender,Globals);

    -- Show the final effects of the attack.
    ShowEffects(Attacker, Defender, Globals);
    
    -- Teach the attacker the skill he earned for his success
    LearnSuccess(Attacker, Defender, APreduction)
end;

--------------------------------------------------------------------------------
-- The following functions are support functions that are used to make the    --
-- fighting system work in the way expected. They contain all the needed      --
-- calculations to perform a proper fight.                                    --
--------------------------------------------------------------------------------

--- Calculate the damage that is absorbed by the armor and reduce the stored
-- armor value by this amount.
-- @param Attacker The table that stores the data of the attacker
-- @param Defender The table that stores the data of the defender
-- @param Globals The table that stores the global values
function ArmourAbsorption(Attacker, Defender, Globals)

	GetArmourType(Defender, Globals);
	local armourfound, armour;
	armourfound, armour = world:getArmorStruct(Globals.HittedItem.id);

	local armourValue = 0;

	local skillmod = 1;
	local qualitymod = 0.91+0.02*math.floor(Globals.HittedItem.quality/100);

    if armourfound then
		skillmod = 1-Defender.DefenseSkill/250;
        if (Attacker.AttackKind == 0) then --wrestling
            armourValue = armour.ThrustArmor;
        elseif (Attacker.AttackKind == 1) then --slashing
            armourValue = armour.StrokeArmor;
        elseif (Attacker.AttackKind == 2) then --concussion
            armourValue = armour.ThrustArmor;
        elseif (Attacker.AttackKind == 3) then --puncture
            armourValue = armour.PunctureArmor;
        elseif (Attacker.AttackKind == 4) then --distance
            armourValue = armour.PunctureArmor;
        end;
    end;

	local Noobmessupmalus = 5; -- Amount that armour value is divided by if your skill isn't high enough to use this armour.
	--No level implemented yet, for now derive it from the armour value.
	--[[local ArmourLevel=0;

	local skilltype= Defender.DefenseSkillName;
	if(skilltype==Character.lightArmour) then
		ArmourLevel = armour.ThrustArmor;
	elseif (skilltype==Character.mediumArmour) then
		ArmourLevel = armour.StrokeArmor;
	elseif (skilltype==Character.heavyArmour) then
		ArmourLevel = armour.PunctureArmor;
	end;]]

	--if(Globals.HittedItem.Level>Defender.DefenseSkill) then
		--armourValue = armourValue/Noobmessupmalus;
	--end

	local Rarity = NotNil(tonumber(Globals.HittedItem:getData("RareArmour")));

	if(Rarity<0) then -- Armour is broken
		armourValue = armourValue/2;
	elseif(Rarity>0) then -- Armour is a rare artifact
		--Each bonus is equivalent to 20 skill levels of equipment.
		local RarityBonus = 20*Rarity;
		armourValue = armourValue+RarityBonus;
	end

	if(Globals.criticalHit==6) then
		--Armour pierce
		armourValue=0;
	end;

    armourfound, armour = world:getNaturalArmor(Defender.Race);
    if armourfound then
        if (Attacker.AttackKind == 0) then --wrestling
            armourValue = armourValue + armour.thrustArmor;
        elseif (Attacker.AttackKind == 1) then --slashing
            armourValue = armourValue + armour.strokeArmor;
        elseif (Attacker.AttackKind == 2) then --concussion
            armourValue = armourValue + armour.thrustArmor;
        elseif (Attacker.AttackKind == 3) then --puncture
            armourValue = armourValue + armour.punctureArmor;
        elseif (Attacker.AttackKind == 4) then --distance
            armourValue = armourValue + armour.punctureArmor;
        end;
    end;

	-- This Armour Scaling Factor (ASF) is important. You can think of it like this:
	-- If ASF = 5, the top armour in the game is 5x as good as the worst armour in the game
	local ArmourScalingFactor = 5;

	armourValue = (100/ArmourScalingFactor) + armourValue*(1-1/ArmourScalingFactor);

    Globals.Damage = Globals.Damage - (Globals.Damage * armourValue * qualitymod / 250);

	Globals.Damage = skillmod*Globals.Damage;

    Globals.Damage = math.max(0, Globals.Damage);
end;


function ArmourDegrade(Defender, Globals)
	
	local Rarity = NotNil(tonumber(Globals.HittedItem:getData("RareArmour")));

	if(Rarity<0) then
		
		local durability = math.mod(Globals.HittedItem.quality, 100);
		local quality = (Globals.HittedItem.quality - durability) / 100;
		
		durability = durability - 20;

		if (durability <= 0) then
			base.common.InformNLS(Defender.Char,
		  "Das Werkzeug wird nicht mehr lange halten. Du solltest dich nach einem neuen umschauen.",
		  "Your artifact shatters. You should take better care of it next time.");
		  world:erase(Globals.HittedItem, 1);
		  return true;
		end;

		
		Globals.HittedItem.quality = quality * 100 + durability;
		--world:changeItem(Globals.HittedItem.WeaponItem);
		world:changeItem(Globals.HittedItem);

    
		base.common.InformNLS(Defender.Char,
		"Das Werkzeug wird nicht mehr lange halten. Du solltest dich nach einem neuen umschauen.",
		"You should take off your broken artifact before it shatters!");

	elseif (base.common.Chance(Globals.Damage, 6000)) then

		local durability = math.mod(Globals.HittedItem.quality, 100);
		local quality = (Globals.HittedItem.quality - durability) / 100;
    
		if (durability == 0) then
			base.common.InformNLS(Defender.Char,
		  "Das Werkzeug wird nicht mehr lange halten. Du solltest dich nach einem neuen umschauen.",
		  "Your armour piece shatters. Thankfully, no fragments end up in your body.");
		  world:erase(Globals.HittedItem, 1);
		  return true;
		end;
    
		durability = durability - 1;
		Globals.HittedItem.quality = quality * 100 + durability;
		--world:changeItem(Globals.HittedItem.WeaponItem);
		world:changeItem(Globals.HittedItem);

    
		if (durability == 10) then 
		  base.common.InformNLS(Defender.Char,
		  "Das Werkzeug wird nicht mehr lange halten. Du solltest dich nach einem neuen umschauen.",
		  "Your armour has seen better days. You may want to repair it.");
		end;
	end;

end;

-- @param Attacker The table that stores the data of the attacker
-- @param Defender The table that stores the data of the defender
-- @param ParryWeapon The item which was used to parry
function WeaponDegrade(Attacker, Defender, ParryWeapon)
	
	local Rarity = NotNil(tonumber(Attacker.WeaponItem:getData("RareWeapon")));

	if(Rarity<0) then
		
		local durability = math.mod(Attacker.WeaponItem.quality, 100);
		local quality = (Attacker.WeaponItem.quality - durability) / 100;
		
		durability = durability - 20;

		if (durability <= 0) then
			base.common.InformNLS(Defender.Char,
		  "Das Werkzeug wird nicht mehr lange halten. Du solltest dich nach einem neuen umschauen.",
		  "Your artifact shatters. You should take better care of it next time.");
		  world:erase(Attacker.WeaponItem, 1);
		  return true;
		end;

		
		Attacker.WeaponItem.quality = quality * 100 + durability;
		--world:changeItem(Globals.HittedItem.WeaponItem);
		world:changeItem(Attacker.WeaponItem);

    
		base.common.InformNLS(Defender.Char,
		"Das Werkzeug wird nicht mehr lange halten. Du solltest dich nach einem neuen umschauen.",
		"You should stop wielding your broken artifact before it shatters!");

	elseif (base.common.Chance(1, 20)) then
		local durability = math.mod(Attacker.WeaponItem.quality, 100);
		local quality = (Attacker.WeaponItem.quality - durability) / 100;
    
		if (durability == 0) then
			base.common.InformNLS(Attacker.Char,
		  "Das Werkzeug wird nicht mehr lange halten. Du solltest dich nach einem neuen umschauen.",
		  "Your weapon shatters. You shed a single tear and bid it farewell as it moves onto its next life.");
		  world:erase(Attacker.WeaponItem, 1);
		  return true;
		end
    
		durability = durability - 1;
		Attacker.WeaponItem.quality = quality * 100 + durability;
		world:changeItem(Attacker.WeaponItem);
    
		if (durability == 10) then 
		  base.common.InformNLS(Attacker.Char,
		  "Das Werkzeug wird nicht mehr lange halten. Du solltest dich nach einem neuen umschauen.",
		  "Your weapon has seen better days. You may want to repair it.");
		end;
	end;

	Rarity = NotNil(tonumber(ParryWeapon:getData("RareWeapon")));

	if(Rarity<0) then
		
		local durability = math.mod(ParryWeapon.quality, 100);
		local quality = (ParryWeapon.quality - durability) / 100;
		
		durability = durability - 20;

		if (durability <= 0) then
			base.common.InformNLS(Defender.Char,
		  "Das Werkzeug wird nicht mehr lange halten. Du solltest dich nach einem neuen umschauen.",
		  "Your artifact shatters. You should take better care of it next time.");
		  world:erase(ParryWeapon, 1);
		  return true;
		end;

		
		ParryWeapon.quality = quality * 100 + durability;
		--world:changeItem(Globals.HittedItem.WeaponItem);
		world:changeItem(ParryWeapon);

    
		base.common.InformNLS(Defender.Char,
		"Das Werkzeug wird nicht mehr lange halten. Du solltest dich nach einem neuen umschauen.",
		"You should stop wielding your broken artifact before it shatters!");

	elseif (base.common.Chance(1, 20)) then
		local durability = math.mod(ParryWeapon.quality, 100);
		local quality = (ParryWeapon.quality - durability) / 100;
    
		if (durability == 0) then
			base.common.InformNLS(Defender.Char,
		  "Das Werkzeug wird nicht mehr lange halten. Du solltest dich nach einem neuen umschauen.",
		  "Your item shatters, making it more difficult for you to defend yourself.");
		  world:erase(ParryWeapon, 1);
		  return true;
		end
    
		durability = durability - 1;
		ParryWeapon.quality = quality * 100 + durability;
		world:changeItem(ParryWeapon);

		if (durability == 10) then 
		  base.common.InformNLS(Defender.Char,
		  "Das Werkzeug wird nicht mehr lange halten. Du solltest dich nach einem neuen umschauen.",
		  "Your item has seen better days. You may want to repair it.");
		end;
	end;

end;

--- Calculate the damage that is caused by the attack. This function calculates
-- the raw damage and stores it in the globals table. The damage calculated here
-- has to be lowered by the armor and the constitution of the attacked
-- character.
-- @param Attacker The table of the character who is attacking
-- @param Globals The global data table
function CalculateDamage(Attacker, Globals)
    local BaseDamage;
    local StrengthBonus;
    local PerceptionBonus;
    local DexterityBonus;
    local SkillBonus;
	local CritBonus=1;
	local QualityBonus;
    --local TacticsBonus;
    
    if Attacker.IsWeapon then
        BaseDamage = Attacker.Weapon.Attack * 10;

		-- If it has RareWeapon data 1, 2 or 3 it's a special version. Has more attack.
		local Rarity = NotNil(tonumber(Attacker.WeaponItem:getData("RareWeapon")));
		if (Rarity>0) then
			--This "20" corresponds to how many skill levels it should boost by. 20 is the value for now. Might be OP. If so, lower.
			local RarityBonus = 20*Rarity;
			--This "6" value isn't a frickelfactor. It comes from the fact that attack for eachh weapon is derived by:
			--AP/Accuracy*(150+ASL*6), where ASL is Associated Skill Level. This means a level 100 weapon is 5x as good as a base one.
			--This formula is used because the base WF values are based on 1.5+ASL*6/100
			BaseDamage = BaseDamage + Attacker.Weapon.ActionPoints/Attacker.Weapon.Accuracy*6*RarityBonus;
		end 

    else
        BaseDamage = content.fighting.GetWrestlingAttack( Attacker.Race ) * 10;
    end;
 
    StrengthBonus = (Attacker.strength - 6) * 3;
    PerceptionBonus = (Attacker.perception - 6) * 1;
    DexterityBonus = (Attacker.dexterity - 6) * 1;
    SkillBonus = (Attacker.skill - 20) * 1.5;
    --TacticsBonus = (Attacker.tactics - 20) * 0.5;
    GemBonus = 0.5*base.gems.getGemBonus(Attacker.WeaponItem);
	
	--Quality Bonus: Multiplies final value by 0.91-1.09
	QualityBonus = 0.91+0.02*math.floor(Attacker.WeaponItem.quality/100);

	--Crit bonus
	if Globals.criticalHit>0 then
		CritBonus=2;
	end;

	--The Global Damage Factor (GDF). Adjust this to change how much damage is done per hit on all attacks.
	local GlobalDamageFactor = 1/100;

    Globals["Damage"] = GlobalDamageFactor*BaseDamage * CritBonus * QualityBonus * (100 + StrengthBonus + PerceptionBonus + DexterityBonus + SkillBonus + GemBonus);
   
end;

--- Deform some final checks on the damage that would be caused and send it to
-- the character. Also here the Coup de Gr�ce is done.
-- @param Attacker The table of the attacking Character
-- @param Defender The table of the attacked Character
-- @param Globals The table of the global values

function CauseDamage(Attacker, Defender, Globals)

	Globals.Damage=Globals.Damage*(math.random(8,12)/10); --Damage is randomised: 80-120%
	
	Globals.Damage=math.min(Globals.Damage,4999); --Damage is capped at 4999 Hitpoints to prevent "one hit kills"
	
	Globals.Damage=math.floor(Globals.Damage); --Hitpoints are an integer
	
    --Attacker.Char:inform("Dealt damage: ".. Globals.Damage .. " HP."); --Debugging
	--Defender.Char:inform("Received damage: ".. Globals.Damage .. " HP."); --Debugging
	
    if base.character.IsPlayer(Defender.Char) 
        and base.character.WouldDie(Defender.Char, Globals.Damage + 1)
        --and (Attacker.AttackKind ~= 4)
        and not base.character.AtBrinkOfDeath(Defender.Char) then
        -- Character would die. Nearly killing him and moving him back in case it's possible
        base.character.ToBrinkOfDeath(Defender.Char);

        local CharOffsetX = Attacker.Char.pos.x - Defender.Char.pos.x;
        local CharOffsetY = Attacker.Char.pos.y - Defender.Char.pos.y;
		
		local range = Attacker.Weapon.Range;
		if(Attacker.AttackKind == 4) then
			range = 1;
		end;

        if (CharOffsetY > 0) then
            CharOffsetY = (range - math.abs(CharOffsetX) + 1)
                * (-1);
        elseif (CharOffsetY < 0) then
            CharOffsetY = (range - math.abs( CharOffsetX ) + 1);
        end;

        if (CharOffsetX > 0) then
            CharOffsetX = (range - math.abs(CharOffsetY) + 1)
                * (-1);
        elseif (CharOffsetX < 0) then
            CharOffsetX = (range - math.abs(CharOffsetY) + 1);
        end;

        local newPos = position(Defender.Char.pos.x + CharOffsetX,
            Defender.Char.pos.y + CharOffsetY, Defender.Char.pos.z);
            
        local targetPos=Defender.Char.pos;
        
        isNotBlocked = function(pos)
            if world:getField(pos):isPassable() then
                targetPos = pos;
                return true;
            else
                return false;
            end
        end
        
        base.common.CreateLine(Defender.Char.pos, newPos, isNotBlocked);
        
        if targetPos ~= startPos then
            Defender.Char:warp(targetPos)
        end

        base.common.TalkNLS(Defender.Char, Character.say,
            "#me stolpert zur�ck und geht zu Boden.",
            "#me stumbles back and falls to the ground.");

		if not Defender.Char:isAdmin() then --Admins don't want to get paralysed!
		
            base.common.ParalyseCharacter(Defender.Char, 7, false, true);
            lte.chr_reg.stallRegeneration(Defender.Char, 20);
			
		end

        return true;
    else
        if not base.character.ChangeHP(Defender.Char, -Globals.Damage) then

		--removed: Call of base.playerdeath
		
        end;
        
        if (Attacker.AttackKind == 4) then -- Distanzangriff.
            Defender.Char.movepoints = Defender.Char.movepoints - 5;
            DropAmmo(Attacker, Defender.Char, false);
        end;
    end;
end;


--- Check that the attack hits
-- @param Defender The character who attacks
-- @param Defender The character who is attacked
-- @return true if the attack is successful
function HitChanceFlux(Attacker, Defender, Globals)

	local DirectionDifference = math.abs(Defender.Char:getFaceTo()-Attacker.Char:getFaceTo());
    local parryWeapon;
	local canParry=true;
	local parryItem; -- For degradation

	--Miss chance. 2% bonus to hit chance for 18 perc, 1.75% malus for 3 perc. Added onto weapon accuracy.
	local chancetohit;
	
	if Attacker.IsWeapon then
		chancetohit=math.max(math.min(Attacker.Weapon.Accuracy*(1+(Attacker.perception-10)/500),100),5);
		
		--if Attacker.Weapon.Level>Attacker.skill) then
			--chancetohit=chancetohit/5;
		--end

	else
		chancetohit=math.max(math.min(90*(1+(Attacker.perception-10)/500),100),5);
	end;

	if (Attacker.AttackKind==4) then

		--The Distance Reduction Modifier (DRM). This value scales the chance of hitting in archery
		--After the pointblank range. In other words, 3 squares away (just out of PB range) has
		--1x the normal accuracy. One square further away is DRM x normal accuracy.
		--One square even further away is DRM^2 x normal accuracy.
		local DistanceReductionModifier = 0.93

		local distance = Attacker.Char:distanceMetric(Defender.Char);
		local archerymod = math.min(1,(1-DistanceReductionModifier)+math.pow(DistanceReductionModifier,distance-2))
		--The value of 2 is used because that's the number of squares away it starts.
		chancetohit = chancetohit*archerymod;

	end;

	--Surefire Special
	if(Globals.criticalHit==7) then
		chancetohit = 100;
	end;

	if not base.common.Chance(chancetohit, 100) then
		return false;
	end;

	--Cannot parry without a weapon
	if not Defender.LeftIsWeapon and not Defender.RightIsWeapon then
        canParry = false;
    end;

	--Cannot parry people who aren't in the front quadrant
    if (DirectionDifference<=2) or (DirectionDifference>=6) then
       canParry = false;
	end;

	local parryChance;

	if canParry then
		
		--Choose which weapon has the largest defense
		if Defender.LeftIsWeapon then
			parryItem = Defender.LeftWeaponItem;
			parryWeapon = Defender.LeftWeapon;
		end;
    
		if Defender.RightIsWeapon then
			if not parryWeapon then
				parryItem = Defender.RightWeaponItem
				parryWeapon = Defender.RightWeapon;
			elseif (parryWeapon.Defence < Defender.RightWeapon.Defence) then
				parryItem = Defender.RightWeaponItem
				parryWeapon = Defender.RightWeapon;
			end;
		end;
		
		--The Shield Scaling Factor (SSF). Changes how much the top shield is better than the worse one.
		local ShieldScalingFactor =5;

		local Rarity = NotNil(tonumber(parryItem:getData("RareWeapon")));

		if (parryWeapon.WeaponType~=14) then
			Rarity = 0;
		end

		local parryweapondefense = parryWeapon.Defence+Rarity*20;
		local defenderdefense = (100/ShieldScalingFactor) + parryweapondefense*(1-1/ShieldScalingFactor);

		if(parryWeapon.WeaponType~=14) then
			defenderdefense = defenderdefense/2;
		end

		local qualitymod = 0.91+0.02*math.floor(parryItem.quality/100);
		parryChance = (Defender.parry / 5); --0-20% by the skill
        parryChance = parryChance * (0.5 + (Defender.agility) / 20); --Skill value gets multiplied by 0.5-1.5 (+/-50% of a normal player) scaled by agility
        parryChance = parryChance + (defenderdefense) / 5; --0-20% bonus by the weapon/shield
		parryChance = parryChance * qualitymod;

		--if(parryItem.Level>Defender.parry) then
			--parryChance = parryChance/5;
		--end

		parryChance = math.min(math.max(parryChance,5),95); -- Min and max parry are 5% and 95% respectively
		
	else
		return true; -- If they can't parry, it succeeds
	end;

	local ParrySuccess = base.common.Chance(parryChance, 100);

	--Unblockable Special
	if(Globals.criticalHit==2) then
		ParrySuccess = false;
	end;

	if ParrySuccess then
		LearnParry(Attacker, Defender, Globals.AP)
		PlayParrySound(Attacker, Defender)
		Defender.Char:performAnimation(9);
		WeaponDegrade(Attacker, Defender, parryItem);
		Counter(Attacker,Defender);
		return false;
	else
		return true;
	end;

end;


--- Check if the setting of items the character is using is good for a attack
-- @param CharStruct The table of the attacker that holds all values load
-- @return true in case the attack is fine
function CheckAttackOK(CharStruct)
--CharStruct.Char:talk(Character.say,"check 1 ok");
    if (CharStruct["AttackKind"] == nil) then -- finding the attack type failed ******************************
        return false;
    end;
--    CharStruct.Char:talk(Character.say,"check 2 ok");
    if (CharStruct.WeaponItem.id == 228) then -- Item is occupied
        return false;
    end;

	--Uncomment this line if rares should be unuseable
	--[[if (NotNil(tonumber(CharStruct.WeaponItem:getData("RareWeapon")))<0) then -- Item is a broken artifact
        return false;
    end;]]

--    CharStruct.Char:talk(Character.say,"check 3 ok");
    if (CharStruct.SecIsWeapon) then
        -- there is something in the second hand
        if (CharStruct.AttackKind == 0) then
            -- but nothing in the first
--           CharStruct.Char:talk(Character.say,"check 4 ok");--  ******************************
            return false;
        elseif (CharStruct.SecWeapon.WeaponType == 7) then
            -- but a distance weapon in the first
--            CharStruct.Char:talk(Character.say,"check 5 ok");
            return false;
        elseif (CharStruct.Weapon.WeaponType == 13) then
            -- but a wand in the first
--            CharStruct.Char:talk(Character.say,"check 6 ok");
            return false;
        end;
    end;
--   CharStruct.Char:talk(Character.say,"check 7 ok");
    return true;
end;

--- Check the range from the attacker to the defender and ensure that it is
-- within weapon distance.
-- @param AttackerStruct The table that stores the data of the attacker
-- @param Defender The character who is attacked
-- @return true in case the range is fine, else false
function CheckRange(AttackerStruct, Defender)
	local distance = AttackerStruct.Char:distanceMetric(Defender);

    if distance > 1 then
        blockList = world:LoS( AttackerStruct.Char.pos, Defender.pos )
		local next = next	-- make next-iterator local		
        if (next(blockList)~=nil) then	-- see if there is a "next" (first) object in blockList!
			return false;				-- something blocks
		end
    end

    if (distance <= 2 and AttackerStruct.AttackKind == 4) then
		--AttackerStruct.Char:inform("I acknowledge that bows shouldn't fire."); --Debugging
        return false;
    end
    if AttackerStruct.IsWeapon then
        return (distance <= AttackerStruct.Weapon.Range);
    end;
    return (distance <= 1 );
end;

--- Calculate the effect of the constitution on the damage. Depending on the
-- constitution this can raise or lower the damage.
-- @param Defender The table that stores the data of the defender
-- @param Globals The table that stores the global values
function ConstitutionEffect(Defender, Globals)
    if (Globals.Damage == 0) then
        return;
    end;
    
    Globals.Damage = Globals.Damage * 14 / Defender.constitution;
end;

--- Checks if a coup de gr�ce is performed on the attacked character and kills
-- the char if needed
-- @param Attacker The table of the attacking character
-- @param Defender The table of the attacked character
-- @return true if a coup de gr�ce was done
function CoupDeGrace(Attacker, Defender)
    if (Attacker.Char:getType() ~= 0) then -- Only for player characters
        return false;
    end;

    if (Attacker.AttackKind == 4) then -- Not done for distance weapons
        return false;
    end;

    if content.fighting.IsTrainingWeapon(Attacker.WeaponItem.id) then
        -- not done for training weapons
        return false;
    end;

    if (base.character.AtBrinkOfDeath(Defender.Char)) then
        -- character nearly down
        local gText = base.common.GetGenderText(Attacker.Char, "seinem",
            "ihrem");
        local eText = base.common.GetGenderText(Attacker.Char, "his",
            "her");
        Attacker.Char:talk(Character.say,
                string.format("#me gibt %s Gegner den Gnadensto�.", gText),
                string.format("#me gives %s enemy the coup de gr�ce.", eText))
        
        -- Kill character and notify other scripts about the death
        if not base.character.Kill(Defender.Char) then
            -- something interrupted the kill
            return true;
        end;
    
        -- Drop much blood around the player
        DropMuchBlood(Defender.Char.pos);
		
    end;
    
    return false;
end;

--- Drops the used ammo in case there is any ammo. This functions placed the
-- used ammunition under the character in case the target character is a player,
-- else the ammunition is dropped into the inventory of the target.
-- @param Attacker The table of the attacking char
-- @param Defender The character of the character that is supposed to receive
--                  the attack
-- @param GroundOnly true in case the item is supposed to be dropped only on the
--                  ground
function DropAmmo(Attacker, Defender, GroundOnly)
    if ( Attacker.AttackKind ~= 4 ) then -- no distanz Attack --> no ammo
        return;
    end;
    
    if base.common.Chance(0.33) then
        local AmmoItem;
        if (Attacker.Weapon.AmmunitionType
            == Attacker.SecWeapon.WeaponType) then
            AmmoItem = Attacker.SecWeaponItem;
        elseif (Attacker.Weapon.AmmunitionType == 255) then
            AmmoItem = Attacker.WeaponItem;
        else
            return false;
        end;
    
        if not GroundOnly and (Defender:getType() == 1) then -- monsters get the ammo into the inventory
            Defender:createItem(AmmoItem.id, 1, AmmoItem.quality, nil);
        else
            if world:isItemOnField(Defender.pos) then
                local oldItem = world:getItemOnField(Defender.pos);
                if (oldItem.wear < 255 and oldItem.id == AmmoItem.id
                    and oldItem.quality == AmmoItem.quality
                    and oldItem:getData("ammoData") == AmmoItem:getData("ammoData")) then
                    
                    oldItem.number = oldItem.number + 1;
                    oldItem.wear = 5;
                    world:changeItem( oldItem );
                    return;
                elseif (oldItem.wear == 255) then
                    return;
                end;
            end;

            tmpItem = world:createItemFromId(AmmoItem.id, 1, Defender.pos, true, AmmoItem.quality, nil);
			if AmmoItem:getData("ammoData") ~= "" then
				tmpItem:setData("ammoData",AmmoItem:getData("ammoData"));
			end;
        end;
    end;
end;

--- Drop a blood spot on the ground at a specified location.
-- @param Posi The location where the blood spot is placed
function DropBlood(Posi)

    if world:isItemOnField(Posi) then
        return; --no blood on tiles with items on them!
    end;
	
    Blood = world:createItemFromId(3101, 1, Posi, true, 333, nil);
    Blood.wear = 2;
    world:changeItem(Blood);
	
end;

--- Drop alot of blood. This function drops blood on every tile around the
-- position set as center.
-- @param Posi The center of the bloody area
function DropMuchBlood(Posi)
    local workingPos = base.common.CopyPosition(Posi);
    
    workingPos.x = workingPos.x - 1;
    workingPos.y = workingPos.y - 1;
    for i = 1, 3 do
        for j = 1, 3 do
            DropBlood(workingPos);
            workingPos.x = workingPos.x + 1;
        end;
        workingPos.x = workingPos.x - 3;
        workingPos.y = workingPos.y + 1;
    end;
end;

--@CharStruct The table of the defender
--@return Returns the armour type
-- 0 - Unarmoured
-- 1 - Puncture
-- 2 - Stroke
-- 3 - Thrust
function GetArmourType(Defender, Globals)

    Globals["HittedArea"] = content.fighting.GetHitArea(Defender.Race);
    Globals["HittedItem"] = Defender.Char:getItemAt(Globals.HittedArea);
    
    local armour, armourfound;
    if (Globals.HittedItem ~= nil and Globals.HittedItem.id > 0) then
        armourfound, armour = world:getArmorStruct(Globals.HittedItem.id);
    else
        -- No armour worn
		Defender["DefenseSkill"] = 0;
		return false;
    end;


	--local armourtype = armour.ArmourType;

	local highestvalue=armour.PunctureArmor;
	local armourtype=1;

	if(armour.StrokeArmor>highestvalue) then
		highestvalue = armour.StrokeArmor;
		armourtype = 2;
	elseif(armour.StrokeArmor==highestvalue) then
		armourtype = 12;
	end;

	if(armour.ThrustArmor>highestvalue) then
		highestvalue = armour.ThrustArmor;
		armourtype = 3;
	elseif(armour.ThrustArmor==highestvalue) then
		if(armourtype==1) then
			armourtype = 13;
		elseif(armourtype==2) then
			armourtype = 23;
		elseif(armourtype==12) then
			armourtype = 123;
		end;
	end;

	--A check in case the defense stats of the armour are equal, will return a random value of the tied ranks.
	if(armourtype>3) then
		if(armourtype==12) then
			if(base.common.Chance(1,2)) then
				armourtype = 1;
			else
				armourtype = 2;
			end;
		elseif(armourtype==23) then
			if(base.common.Chance(1,2)) then
				armourtype = 2;
			else
				armourtype = 3;
			end;
		elseif(armourtype==13) then
			if(base.common.Chance(1,2)) then
				armourtype = 1;
			else
				armourtype = 3;
			end;
		elseif(armourtype==123) then
			local tempchance = base.common.Chance(1,3)
			if(tempchance==1) then
				armourtype = 1;
			elseif(tempchance==2) then
				armourtype = 2;
			else
				armourtype = 3;
			end;
		end;
	end;


	if armourtype == 1 then
		-- Heavy is good against punc
		Defender["DefenseSkillName"] = Character.heavyArmour;
	elseif armourtype == 2 then
		-- Medium is good against slash/stroke
		Defender["DefenseSkillName"] = Character.mediumArmour;
	elseif armourtype == 3 then
		-- Light is good against conc/thrust
		Defender["DefenseSkillName"] = Character.lightArmour;
	else
		Defender["DefenseSkillName"] = false;
		Defender["DefenseSkill"] = false;
		return false;
	end;

	Defender["DefenseSkill"] = NotNil(Defender.Char:getSkill(Defender.DefenseSkillName));

	return true;

end;


---Calculate if there was a critical
-- @param Attacker The table of the attacking Character
-- @param Defender The table of the attacked Character
-- @param Globals The table of the global values
function CheckCriticals(Attacker, Defender, Globals)

	
	
	local chance=1;
	local weapontype = 8;
	if Attacker.IsWeapon then
		weapontype = Attacker.Weapon.WeaponType;
		--Special: Backstab
		if weapontype == 3 then
			if (Defender.Char:getFaceTo() == Attacker.Char:getFaceTo()) then
				chance=10;
			else
				chance=0;
			end;
		end;
	end;
	
	if not base.common.Chance(chance, 100) then
		Globals["criticalHit"] = 0;
		return false;
	else
		Globals["criticalHit"] = weapontype;
		return true;
	end;

end;

---Handles special effects
-- @param Attacker The table of the attacking Character
-- @param Defender The table of the attacked Character
-- @param Globals The table of the global values
function Specials(Attacker, Defender, Globals)

	local hisher =  base.common.GetGenderText(Attacker.Char,"his","her");

	if(Globals.criticalHit==1) then -- 1HS
		base.common.TalkNLS(Attacker.Char, Character.say,
            "#me stolpert zur�ck und geht zu Boden.",
            "#me sweeps "..hisher.." blade, dealing two blows in rapid succession.");
	elseif(Globals.criticalHit==2) then -- 1HC
		base.common.TalkNLS(Attacker.Char, Character.say,
            "#me stolpert zur�ck und geht zu Boden.",
            "#me swings "..hisher.." weapon with such force that it cannot be blocked.");
	elseif(Globals.criticalHit==3) then -- 1HP
		base.common.TalkNLS(Attacker.Char, Character.say,
            "#me stolpert zur�ck und geht zu Boden.",
            "#me slams "..hisher.." blade quickly into "..hisher.." opponent's back.");
	elseif(Globals.criticalHit==4) then -- 2HS
		base.common.TalkNLS(Attacker.Char, Character.say,
            "#me stolpert zur�ck und geht zu Boden.",
            "#me delivers a mighty swing, knocking back "..hisher.." opponent.");
	elseif(Globals.criticalHit==5) then -- 2HC
		base.common.TalkNLS(Attacker.Char, Character.say,
            "#me stolpert zur�ck und geht zu Boden.",
            "#me brings down "..hisher.." weapon with great force, stunning "..hisher.." foe.");
	elseif(Globals.criticalHit==6) then -- 2HP
		base.common.TalkNLS(Attacker.Char, Character.say,
            "#me stolpert zur�ck und geht zu Boden.",
            "#me thrusts "..hisher.." weapon with a powerful, piercing attack.");
	elseif(Globals.criticalHit==7) then -- Dist
		base.common.TalkNLS(Attacker.Char, Character.say,
            "#me stolpert zur�ck und geht zu Boden.",
            "#me takes careful aim, hitting "..hisher.." target with precision and power.");
	elseif(Globals.criticalHit==8) then -- Wrest
		base.common.TalkNLS(Attacker.Char, Character.say,
            "#me stolpert zur�ck und geht zu Boden.",
            "#me strikes out extremely quickly, dealing a powerful blow to "..hisher.." opponent.");
	end;

	if(Globals.criticalHit==4) then
		--Knockback
		local CharOffsetX = Attacker.Char.pos.x - Defender.Char.pos.x;
        local CharOffsetY = Attacker.Char.pos.y - Defender.Char.pos.y;

        if (CharOffsetY > 0) then
            CharOffsetY = (Attacker.Weapon.Range - math.abs(CharOffsetX) + 1)
                * (-1);
        elseif (CharOffsetY < 0) then
            CharOffsetY = (Attacker.Weapon.Range - math.abs( CharOffsetX ) + 1);
        end;

        if (CharOffsetX > 0) then
            CharOffsetX = (Attacker.Weapon.Range - math.abs(CharOffsetY) + 1)
                * (-1);
        elseif (CharOffsetX < 0) then
            CharOffsetX = (Attacker.Weapon.Range - math.abs(CharOffsetY) + 1);
        end;

        local newPos = position(Defender.Char.pos.x + CharOffsetX,
            Defender.Char.pos.y + CharOffsetY, Defender.Char.pos.z);
            
        local targetPos=Defender.Char.pos;
        
        isNotBlocked = function(pos)
            if world:getField(pos):isPassable() then
                targetPos = pos;
                return true;
            else
                return false;
            end
        end;
        
        base.common.CreateLine(Defender.Char.pos, newPos, isNotBlocked);
        
        if targetPos ~= startPos then
            Defender.Char:warp(targetPos)
        end;
	elseif(Globals.criticalHit==5) then
		--Stun
		local stuntime = 2;
		base.common.ParalyseCharacter(Defender.Char, stuntime, false, true);
	end;

end;


---Handles special effects
-- @param Defender The table of the attacked Character
function Counter(Attacker, Defender)
	
	if Defender.Char.attackmode then
		if base.common.Chance(1,50) then
			base.common.TalkNLS(Defender.Char, Character.say,
            "#me stolpert zur�ck und geht zu Boden.",
            "#me deftly blocks the hit and quickly readies stance for a counter attack.");
			base.character.ChangeFightingpoints(Defender.Char,-Defender.Char.fightpoints);
			Defender.Char.movepoints=21; 
		end;
	end;

end;


--- Identify the used attack kind and set up identifier values and the skill
-- name. This also finds out if a singlehanded or a two-handed weapon is used.
-- Possible Values for AttackKind
-- 0 - wrestling
-- 1 - slashing
-- 2 - concussion
-- 3 - puncture
-- 4 - distance
-- @param CharStruct The table of the character the values should be generated
function GetAttackType(CharStruct)
	-- No weapon present:
    if not CharStruct.IsWeapon then
--CharStruct.Char:talk(Character.say,"GETATTTYPE 1"); --- schild richtig
        CharStruct["AttackKind"] = 0;
        CharStruct["UsedHands"] = 1;
        CharStruct["Skillname"] = Character.wrestling;
        return;
    end;
    
	-- weapon present:
    local weaponType = CharStruct.Weapon.WeaponType;
--CharStruct.Char:talk(Character.say,"WPTYPE="..weaponType);	-- 14 wenn schild falsch
    if (weaponType == 1) or (weaponType == 4) then
--CharStruct.Char:talk(Character.say,"GETATTTYPE 2");
        CharStruct["AttackKind"] = 1;
        CharStruct["Skillname"] = Character.slashingWeapons;
        if (weaponType == 1) then
            CharStruct["UsedHands"] = 1;
        else
            CharStruct["UsedHands"] = 2;
        end;
    elseif (weaponType == 2) or (weaponType == 5) then
--CharStruct.Char:talk(Character.say,"GETATTTYPE 3");
        CharStruct["AttackKind"] = 2;
        CharStruct["Skillname"] = Character.concussionWeapons;
        if (weaponType == 2) then
            CharStruct["UsedHands"] = 1;
        else
            CharStruct["UsedHands"] = 2;
        end;
    elseif (weaponType == 3) or (weaponType == 6) then
--CharStruct.Char:talk(Character.say,"GETATTTYPE 4");
        CharStruct["AttackKind"] = 3;
        CharStruct["Skillname"] = Character.punctureWeapons;
        if (weaponType == 3) then
            CharStruct["UsedHands"] = 1;
        else
            CharStruct["UsedHands"] = 2;
        end;
    elseif (weaponType == 7) or (weaponType == 255) then
--CharStruct.Char:talk(Character.say,"GETATTTYPE 5");
        CharStruct["AttackKind"] = 4;
        CharStruct["Skillname"] = Character.distanceWeapons;
        if (weaponType == 255) then
            CharStruct["UsedHands"] = 1;
        else
            CharStruct["UsedHands"] = 2;
        end;
    end;
end;

--- Checks if the attacker is using a distance weapon and check and remove the
-- ammunition in case its needed
-- @param Attacker The table that stores the data of the attacking char
-- @return true in case the attack is good to go
function HandleAmmunition(Attacker)
    if (Attacker.Char:getType() == 1) then -- Monsters do not use ammo
        return true;
    end;
    
    if (Attacker.AttackKind ~= 4) then -- Ammo only needed for distance attacks
        return true;
    end;
    
    if (Attacker.Weapon.AmmunitionType == Attacker.SecWeapon.WeaponType) then
        Attacker.Char:increaseAtPos(Attacker.SecWeaponItem.itempos, -1);
    elseif (Attacker.Weapon.AmmunitionType == 255) then		-- throwing axes, spears and throwing stars, thus they ARE the ammunition!
        Attacker.Char:increaseAtPos(Attacker.WeaponItem.itempos, -1);
    else
        return false;
    end;
    return true;
end;

--- Calculate the required movepoints for this attack and reduce the attacker
-- movepoints by the fitting value.
-- @param Attacker The table that stores the values of the attacker
function HandleMovepoints(Attacker, Globals)
	
    local weaponFightpoints;
    if Attacker.IsWeapon then
        weaponFightpoints = Attacker.Weapon.ActionPoints;
    else
        weaponFightpoints = content.fighting.GetWrestlingMovepoints(Attacker.Race);
    end;

	if Attacker.Weapon.AmmunitionType==10 then
		if(Attacker.SecWeaponItem.id==322) then
			weaponFightpoints = weaponFightpoints-1;
		end
	end
    
    -- The Global Speed Mod (GSM). Increase this to make fights faster.
	local GlobalSpeedMod = 100;

    local reduceFightpoints = math.max( 7 , weaponFightpoints*(100 - (Attacker.agility-6)*2.5) / GlobalSpeedMod );

	if(Globals.criticalHit==1) then
		reduceFightpoints = 2;
	elseif(Globals.criticalHit>0) then
		reduceFightpoints = reduceFightpoints*1.5;
	end;

	base.character.ChangeFightingpoints(Attacker.Char,-math.floor(reduceFightpoints));
    Attacker.Char.movepoints=Attacker.Char.movepoints-math.floor(reduceFightpoints); 
	
	Globals["AP"] = reduceFightpoints;

    return reduceFightpoints;
end;

--- Learning function called when ever the attacked character fails to avoid the
-- attack. The defender learns nothing in this case, the attacker learns his
-- attack skill as well as the tactics skill.
-- @param Attacker The table containing the attacker data
-- @param Defender The table containing the defender data
function LearnSuccess(Attacker, Defender, AP)
--debug("          NOW LEARNING att: "..Attacker.Skillname..", "..(AP/3)..", "..(math.max(Defender.dodge, Defender.parry) + 20));
	if not Defender.DefenseSkillName then
		if Attacker.Skillname then
			Attacker.Char:learn(Attacker.Skillname, AP/2, math.max(Defender.parry) + 20);
		end
	else
		if Attacker.Skillname then
			Attacker.Char:learn(Attacker.Skillname, AP/2, math.max(Defender.DefenseSkill, Defender.parry) + 20);
		end
		Defender.Char:learn(Defender.DefenseSkillName,AP/2,Attacker.skill+20);
	end;
    
--debug("          DONE LEARNING");    
end;



--- Learning function called when ever the attacked character parries the
-- attack. The defender learns parry skill in this case, the attacker learns his
-- attack skill as well as the tactics skill.
-- @param Attacker The table containing the attacker data
-- @param Defender The table containing the defender data
function LearnParry(Attacker, Defender, AP)
--debug("          NOW LEARNING parry: "..Character.parry..", "..(AP/3)..", "..(Attacker.skill + 20));
    Defender.Char:learn(Character.parry, AP/2, Attacker.skill + 20)
--debug("          DONE LEARNING");   	
	
end;

function NotNil(val)
    if val==nil then
        return 0;
    end
    return val;
end


--- Load the attributes and skills of a character. Depending on the offensive
-- parameter the skills for attacking or for defending are load.
-- @param CharStruct The character table of the char the values are load for
-- @param Offensive true in case attributes and skills for the attacker shall be
--                      load
function LoadAttribsSkills(CharStruct, Offensive)
    if Offensive then
        CharStruct["strength"] = NotNil(CharStruct.Char:increaseAttrib("strength", 0));
        CharStruct["agility"] = NotNil(CharStruct.Char:increaseAttrib("agility", 0));
        CharStruct["perception"]
            = NotNil(CharStruct.Char:increaseAttrib("perception", 0));
        CharStruct["skill"] = NotNil(CharStruct.Char:getSkill(CharStruct.Skillname));
        CharStruct["natpoison"] = 0;
        --CharStruct["tactics"] = NotNil(CharStruct.Char:getSkill(Character.tactics));
        CharStruct["dexterity"]
            = NotNil(CharStruct.Char:increaseAttrib("dexterity", 0));
    else
        CharStruct["dexterity"]
            = NotNil(CharStruct.Char:increaseAttrib("dexterity", 0));
        CharStruct["constitution"]
            = NotNil(CharStruct.Char:increaseAttrib("constitution", 0));
        CharStruct["parry"] = NotNil(CharStruct.Char:getSkill(Character.parry));
        CharStruct["dodge"] = NotNil(CharStruct.Char:getSkill(Character.dodge));
		CharStruct["agility"] = NotNil(CharStruct.Char:increaseAttrib("agility", 0));
    end;
    CharStruct["Race"] = CharStruct.Char:getRace();
end;

--- Load all weapon data for a character. The data is stored in the table that
-- is used as the parameter. 
-- @param CharStruct The table of the character the weapons are supposed to be
--                      load for
function LoadWeapons(CharStruct)
    local rItem = CharStruct.Char:getItemAt(Character.right_tool);
    local lItem = CharStruct.Char:getItemAt(Character.left_tool);
    local rAttFound, rAttWeapon = world:getWeaponStruct(rItem.id);
    local lAttFound, lAttWeapon = world:getWeaponStruct(lItem.id);
    
    --CharStruct.Char:inform("R: "..rItem.id .. " L: "..lItem.id);
    
    -- the right item is ALWAYS used as the weapon now!
    isRWp=1;
	isLWp=1;
	
	if rAttFound then
		rWType=rAttWeapon.WeaponType;
		if rWType==10 or rWType==11 or rWType==14 then -- Ammo or shield in right hand: switch r and l hand!
			isRWp=0;
		end
--		debug("*** FOUND WP IN R!");
	else
		isRWp=0;
	end
	
	if lAttFound then
		lWType=lAttWeapon.WeaponType;
		if lWType==10 or lWType==11 or lWType==14 then -- Ammo or shield in right hand: switch r and l hand!
			isLWp=0;
		end
--		debug("*** FOUND WP IN L!");
	else
		isLWp=0;
	end
	
	if isRWp==0 and isLWp==1 then 	-- switch weapons
--	debug("*** SWITCHING WEAPONS NOW!"); 
		local dItem=rItem;
		local dAttFound=rAttFound;
		local dAttWeapon=rAttWeapon;
		rItem=lItem;
		rAttFound=lAttFound;
		rAttWeapon=lAttWeapon;
		lItem=dItem;
		lAttFound=dAttFound;
		lAttWeapon=dAttWeapon;
	end
	
	-- 1: slash, 2: 
	
    CharStruct["WeaponItem"] = rItem;
    CharStruct["IsWeapon"] = rAttFound;
    CharStruct["Weapon"] = rAttWeapon;

    CharStruct["SecWeaponItem"] = lItem;
    CharStruct["SecIsWeapon"] = lAttFound;
    CharStruct["SecWeapon"] = lAttWeapon;
--    CharStruct.Char:talk(Character.say,"**** WPTYPE R: "..CharStruct.Weapon.WeaponType);
--	CharStruct.Char:talk(Character.say,"**** WPTYPE L: "..CharStruct.SecWeapon.WeaponType);
	-- still  needed? :
    CharStruct["LeftWeaponItem"] = lItem;
    CharStruct["LeftIsWeapon"] = lAttFound;
    CharStruct["LeftWeapon"] = lAttWeapon;
    
    CharStruct["RightWeaponItem"] = rItem;
    CharStruct["RightIsWeapon"] = rAttFound;
    CharStruct["RightWeapon"] = rAttWeapon;

end;

--- Check if the character is on newbie island and reject the attack in that.
-- This is required to allow newbie island to work correctly.
-- @param Attacker The character who is attacking
-- @param Defender The character who is attacked
-- @return true in case the attack can go on, else it has to be stopped
function NewbieIsland(Attacker, Defender)
    -- Newbie Island is on z-level 100 and aboth. if that does not fit we are
    -- not in the newbie island and the Attack is okay.
    if (Attacker.pos.z < 100 or Attacker.pos.z > 105) then
        return true;
    end;

    --if (Attacker.pos.z) ~= -40 then     -- same for the prisons
    --    return true;
    --end;

    -- in case the character it not a other player character, the Attack is
    -- okay anyway.
    if (Defender:getType() ~= 0) then
        return true;
    end;

    -- the Attacker did not start the newbie island quest. Attack is fine.
    if (Attacker:getQuestProgress(2) == 0) then
        return true;
    end;

    -- The Attacker is a GM. Attacking is fine
    if Attacker:isAdmin() then
        return true;
    end;

    -- So now the character is on newbie island and not allowed to Attack.
    -- Some lines to ensure the player is not spammed to death if messages
    if (_AntiSpamVar==nil) then
        _AntiSpamVar = {};
    end;
    if (_AntiSpamVar[Attacker.id] == nil) then 
        _AntiSpamVar[Attacker.id] = 0;
    elseif (_AntiSpamVar[Attacker.id] < 280) then
        _AntiSpamVar[Attacker.id] =_AntiSpamVar[Attacker.id] + 1;
    else
        base.common.InformNLS(Attacker,
        "[Tutorial] Du darfst w�hrend des Tutorials noch keine anderen Spieler angreifen. Klicke nochmals auf deinen Gegner in der Angriffsliste um den Kampf abzubrechen.",
        "[Tutorial] You are not allowed to attack other players during the tutorial. Click again on your enemy in the attack list to cancel the attack.");
        _AntiSpamVar[Attacker.id] = 0;
    end;
    return false;
end;

--- Play the sound of a successful parry.
-- @param Attacker The table of the character who is attacking
-- @param Defender The table of the character who is attacked
function PlayParrySound(Attacker, Defender)
    if not Attacker.IsWeapon then
        world:makeSound(32,Attacker.Char.pos);
        return true;
    end;
    
    if not Defender.RightIsWeapon and not Defender.LeftIsWeapon then
        world:makeSound(32,Attacker.Char.pos);
        return true;
    end;
    
    local DefenderWeapon = 0;
    if Defender.RightIsWeapon then
        DefenderWeapon = Defender.RightWeapon.WeaponType;
    end;
    
    if Defender.LeftIsWeapon then
        DefenderWeapon = math.max(DefenderWeapon,
            Defender.LeftWeapon.WeaponType);
    end;
    if (Sounds[DefenderWeapon] ~= nil) then
        if (Sounds[DefenderWeapon][Attacker.Weapon.WeaponType] ~= nil) then
            world:makeSound(Sounds[DefenderWeapon][Attacker.Weapon.WeaponType],
                Attacker.Char.pos);
            return true;
        end;
    end;
    world:makeSound(32, Attacker.Char.pos);
    return true;
end

--- Show the attacking animation for the attacking character.
-- @param Attacker The table that stores the attacker data
function ShowAttackGFX(Attacker)
    if (Attacker.AttackKind == 0) then -- wrestling
        Attacker.Char:performAnimation(5);
    elseif (Attacker.AttackKind == 4) then -- distance
        Attacker.Char:performAnimation(7);
    elseif (Attacker.UsedHands == 2) then -- 2 hands attack
        Attacker.Char:performAnimation(6);
    else -- 1 hand attack
        Attacker.Char:performAnimation(5);
    end;
end;

--- Show the effects of a successful attack. This Drops some blood in case
-- the attack is very strong or a critical hit and it raises the sound effects
-- that fit this attack.
-- @param Attacker The table of the attacking Character
-- @param Defender The table of the attacked Character
-- @param Globals The table of the global values
function ShowEffects(Attacker, Defender, Globals)
    if (Globals.Damage > 0) then
        world:gfx(13, Defender.Char.pos); -- Blood effect, remove maybe?
        Defender.Char:performAnimation(10); -- Hit animation
        if Globals.criticalHit>0 then
            --InformAboutCritical(Attacker.Char, Defender.Char, Globals.HittedArea);
            --[[ Wounds Script - Disabled for now
            if base.character.IsPlayer(Defender.Char) and (math.random(8) == 1) then
                Defender.Char.effects:addEffect(LongTimeEffect(21, 10));
            end;
            --]]
            
            DropMuchBlood(Defender.Char.pos);
        elseif (Globals.Damage > 2000) then
            DropBlood(Defender.Char.pos);
        end;
    end;
    
    if (Attacker.AttackKind == 0) then --wresting
        world:makeSound(3,Defender.Char.pos);
    elseif (Attacker.AttackKind==1) then --slashing
        world:makeSound(33,Defender.Char.pos);
    elseif (Attacker.AttackKind==2) then --concussion
        world:makeSound(32,Defender.Char.pos);
    elseif (Attacker.AttackKind==3) then --puncture
        world:makeSound(33,Defender.Char.pos);
    elseif (Attacker.AttackKind==4) then --distance
        world:makeSound(31,Defender.Char.pos);
    end;
end;


-- Parry sounds
-- Line and column the item Types the attacker and the defender are
-- using
-- id of the sounds that shall be played at a parry
Sounds={};
Sounds[1]={32,32,32,32,32,32};
Sounds[2]={32,42,43,42,42,44};
Sounds[3]={32,43,41,42,40,41};
Sounds[4]={32,42,42,42,42,44};
Sounds[5]={32,42,40,42,42,44};
Sounds[6]={32,44,41,44,44,41};
Sounds[14]={32,43,41,42,40,41};

