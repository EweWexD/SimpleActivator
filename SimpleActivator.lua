-- [[ Lib ]]
require("Inspired")

function SimpleActivatorPrint(msg)
	print("<font color=\"#0A760C\">[SimpleActivator]:</font><font color=\"#ffffff\"> "..msg.."</font>")

end
SimpleActivatorPrint("Loaded!")
SimpleActivatorPrint("Made by EweEwe")

-- [[ Update ]]
local version = "1.0"
function AutoUpdate(data)

    if tonumber(data) > tonumber(version) then
        PrintChat("<font color='#0A760C'>New version found!"  .. data)
        PrintChat("<font color='#0A760C'>Downloading update, please wait...")
        DownloadFileAsync("https://raw.githubusercontent.com/EweWexD/SimpleActivator/master/SimpleActivator.version", SCRIPT_PATH .. "SimpleActivator.lua", function() PrintChat("<font color='#0A760C'>Update Complete, please 2x F6!") return end)
    else
        PrintChat("<font color='#0A760C'>No updates found!")
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/EweWexD/SimpleActivator/master/SimpleActivator.version", AutoUpdate)


-- [[ Menu ]]
local SAMenu = Menu("Activator", "Simple Activator")
-- [[ Summoner Spells ]]
SAMenu:SubMenu("Sum", "Summoner Spells")
SAMenu.Sum:Boolean("Heal", "Use Heal", true)
SAMenu.Sum:Boolean("SHeal", "Use Heal to save Ally", true)
SAMenu.Sum:Boolean("Barrier", "Use Barrier", true)
SAMenu.Sum:Boolean("Ignite", "Use Ignite to kill steal", true)
SAMenu.Sum:Slider("HealI", "HP to Heal me", 20, 0, 100, 5)
SAMenu.Sum:Slider("HealA", "HP to Heal ally", 20, 0, 100, 5)
SAMenu.Sum:Slider("BarrierI", "HP to Barrier me", 20, 0, 100, 5)
-- [[ Items ]]
SAMenu:SubMenu("Items", "Items Use")
SAMenu.Items:Boolean("BOTRK", "Use BOTRK", true)
SAMenu.Items:Boolean("HG", "Use Hextech Gunblade", true)
SAMenu.Items:Boolean("BC", "Use Bilfewater Cutlass", true)
--SAMenu.Items:Boolean("MS", "Use Mercurial Scimitar", true)
--SAMenu.Items:Boolean("QS", "Use Quicksliver Sash", true)
-- [[ AutoSmite ]]
-- Soon 
--  [[ Me ]]
SAMenu:Info("Juan", "--------------")
SAMenu:Info("Created", "Made by EweEwe")

-- [[ Tick ]]
OnTick(function(myHero)
	target = GetCurrentTarget()
			 Summoners()
			 Items()
end)
-- [[ Summoners ]]
Barrier = (GetCastName(myHero,SUMMONER_1):lower():find("summonerbarrier") and SUMMONER_1 or (GetCastName(myHero,SUMMONER_2):lower():find("summonerbarrier") and SUMMONER_2 or nil))
Heal = (GetCastName(myHero,SUMMONER_1):lower():find("summonerheal") and SUMMONER_1 or (GetCastName(myHero,SUMMONER_2):lower():find("summonerheal") and SUMMONER_2 or nil))
Ignite = (GetCastName(myHero,SUMMONER_1):lower():find("summonerdot") and SUMMONER_1 or (GetCastName(myHero,SUMMONER_2):lower():find("summonerdot") and SUMMONER_2 or nil))

-- [[ Orbwalker ]]
function Mode()
	if _G.IOW_Loaded and IOW:Mode() then
		return IOW:Mode()
	elseif _G.PW_Loaded and PW:Mode() then
		return PW:Mode()
	elseif _G.DAC_Loaded and DAC:Mode() then
		return DAC:Mode()
	elseif _G.AutoCarry_Loaded and DACR:Mode() then
		return DACR:Mode()
	elseif _G.SLW_Loaded and SLW:Mode() then
		return SLW:Mode()
	elseif GoSWalkLoaded and GoSWalk.CurrentMode then
		return ({"Combo", "Harass", "LaneClear", "LastHit"})[GoSWalk.CurrentMode+1]
	end
end

function Summoners()
	-- [[ Ignite ]]
	if SAMenu.Sum.Ignite:Value() and IsReady(Ignite) then
			for _, enemy in pairs(GetEnemyHeroes()) do
				if 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetHPRegen(enemy)*3 and ValidTarget(enemy, 600) then
					DrawText("Burn!",30,enemy.pos2D.x-30,enemy.pos2D.y-40,0xFFFF0000)
					CastTargetSpell(enemy, Ignite)
				end
			end
		end
	end
	-- [[ Heal for me ]]
	if SAMenu.Sum.HealI:Value() then 
		if Heal then 
			if (GetCurrentHP(myHero)/GetMaxHP(myHero))*100 <= SAMenu.Sum.HealI:Value() then
				CastSpell(Heal)
			end
		end
	end
	-- [[ Heal for ally ]]
	if SAMenu.Sum.SHeal:Value() then 
		if Heal then 
			for _,ally in pairs(GetAllyHeroes()) do
				if ValidTarget(ally, 850) then 
					if (GetCurrentHP(ally)/GetMaxHP(ally))*100 <= SAMenu.Sum.HealA:Value() then 
						CasTargetSpell(ally, Heal)
					end
				end
			end
		end
	end
	-- [[ Barrier ]]
	if SAMenu.Sum.Barrier:Value() then 
		if Barrier then 
			if (GetCurrentHP(myHero)/GetMaxHP(myHero))*100 <= SAMenu.Sum.BarrierI:Value() then 
				CastSpell(Barrier)
			end
		end
	end

-- [[ Items ]]
function Items()
	if Mode() == "Combo" then
		if SAMenu.Items.BOTRK:Value() then
			if GetItemSlot(myHero, 3153) >= 1 and ValidTarget(target, 550) then
				if CanUseSpell(myHero, GetItemSlot(myHero, 3153)) == READY then
				CastTargetSpell(target, GetItemSlot(myHero, 3153))
				end
			end
		end
		if SAMenu.Items.HG:Value() then
			if GetItemSlot(myHero, 3146) >= 1 and ValidTarget(target, 700) then
				if CanUseSpell(myHero, GetItemSlot(myHero, 3146)) == READY then
					CastTargetSpell(target, GetItemSlot(myHero, 3146))
				end
			end
		end
		if SAMenu.Items.BC:Value() then
			if GetItemSlot(myHero, 3144) >= 1 and ValidTarget(target, 550) then
				if CanUseSpell(myHero, GetItemSlot(myHero, 3144)) == READY then
					CastTargetSpell(target, GetItemSlot(myHero, 3144))
				end
			end
		end
	end
end
