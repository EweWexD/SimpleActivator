--╔═══╗╔══╗╔═╗╔═╗╔═══╗╔╗   ╔═══╗     ╔═══╗╔═══╗╔════╗╔══╗╔╗──╔╗╔═══╗╔════╗╔═══╗╔═══╗
--║╔═╗║╚╣─╝║║╚╝║║║╔═╗║║║   ║╔══╝     ║╔═╗║║╔═╗║║╔╗╔╗║╚╣─╝║╚╗╔╝║║╔═╗║║╔╗╔╗║║╔═╗║║╔═╗║
--║╚══╗ ║║ ║╔╗╔╗║║╚═╝║║║   ║╚══╗     ║║ ║║║║ ╚╝╚╝║║╚╝ ║║ ╚╗║║╔╝║║ ║║╚╝║║╚╝║║ ║║║╚═╝║
--╚══╗║ ║║ ║║║║║║║╔══╝║║ ╔╗║╔══╝     ║╚═╝║║║ ╔╗  ║║   ║║  ║╚╝║ ║╚═╝║  ║║  ║║ ║║║╔╗╔╝
--║╚═╝║╔╣─╗║║║║║║║║   ║╚═╝║║╚══╗     ║╔═╗║║╚═╝║  ║║  ╔╣─╗ ╚╗╔╝ ║╔═╗║  ║║  ║╚═╝║║║║╚╗
--╚═══╝╚══╝╚╝╚╝╚╝╚╝   ╚═══╝╚═══╝     ╚╝ ╚╝╚═══╝  ╚╝  ╚══╝  ╚╝  ╚╝─╚╝  ╚╝  ╚═══╝╚╝╚═╝
-- V1.01 Changelog
-- +Some error fixed.
--
-- V1.0 Changelog
-- +Released to GoS




-- [[ Lib ]]
require("Inspired")
require("DamageLib")

function SimpleActivatorPrint(msg)
	print("<font color=\"#0A760C\">[SimpleActivator]:</font><font color=\"#ffffff\"> "..msg.."</font>")

end
SimpleActivatorPrint("Loaded!")
SimpleActivatorPrint("Made by EweEwe")

-- [[ Update ]]
local version = "1.01"
function AutoUpdate(data)

    if tonumber(data) > tonumber(version) then
        PrintChat("<font color='#0A760C'>New version found!"  .. data)
        PrintChat("<font color='#0A760C'>Downloading update, please wait...")
        DownloadFileAsync("https://raw.githubusercontent.com/EweWexD/SimpleActivator/master/SimpleActivator.lua", SCRIPT_PATH .. "SimpleActivator.lua", function() PrintChat("<font color='#0A760C'>Update Complete, please 2x F6!") return end)
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
SAMenu.Sum:Boolean("Ignite", "Use Smite to kill steal", true)
SAMenu.Sum:Slider("HealI", "HP to Heal me", 20, 0, 100, 5)
SAMenu.Sum:Slider("HealA", "HP to Heal ally", 20, 0, 100, 5)
SAMenu.Sum:Slider("BarrierI", "HP to Barrier me", 20, 0, 100, 5)
-- [[ Items ]]
SAMenu:SubMenu("ItemsDMG", " Items Use")
SAMenu.ItemsDMG:Boolean("BOTRK", "Use BOTRK", true)
SAMenu.ItemsDMG:Boolean("HG", "Use Hextech Gunblade", true)
SAMenu.ItemsDMG:Boolean("BC", "Use Bilfewater Cutlass", true)
SAMenu.ItemsDMG:Slider("Wm", "HP to use this items", 50, 0, 100, 5)
--SAMenu.Items:Boolean("MS", "Use Mercurial Scimitar", true)
--SAMenu.Items:Boolean("QS", "Use Quicksliver Sash", true)
-- [[ AutoSmite ]]
-- Soon 
-- [[ Tick ]]
OnTick(function(myHero)
	target = GetCurrentTarget()
	Summoners()
	ItemsDMG()
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
	if SAMenu.Sum.Ignite:Value() then
		if Ignite then
			for _, enemy in pairs(GetEnemyHeroes()) do
				if 20*GetLEvel(myHero)+50 > GetCurrentHP(enemy)+GetHPRegen(enemy)*3 and ValidTarget(enemy, 600) then
					DrawText("Burn!",30,enemy.pos2D.x-30,enemy.pos2D.y-40,0xFFFF0000)
					CasTargetSpell(enemy, Ignite)
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
end

-- [[ Items ]]
function ItemsDMG()
	if Mode() == "Combo" then
		if (GetCurrentHP(target)/GetMaxHP(target))*100 <= SAMenu.ItemsDMG.Wm:Value() then
			if SAMenu.ItemsDMG.BOTRK:Value() then
				if GetItemSlot(myHero, 3153) >= 1 and ValidTarget(target, 550) then
					if CanUseSpell(myHero, GetItemSlot(myHero, 3153)) then
						CastTargetSpell(target, GetItemSlot(myHero, 3153))
					end
				end
			end
			if SAMenu.ItemsDMG.HG:Value() then
				if GetItemSlot(myHero, 3146) >= 1 and ValidTarget(target, 700) then
					if CanUseSpell(myHero, GetItemSlot(myHero, 3146)) then
						CastTargetSpell(target, GetItemSlot(myHero, 3146))
					end
				end
			end
			if SAMenu.ItemsDMG.BC:Value() then
				if GetItemSlot(myHero, 3144) >= 1 and ValidTarget(target, 550) then
					if CanUseSpell(myHero, GetItemSlot(myHero, 3144)) then
						CastTargetSpell(target, GetItemSlot(myHero, 3144))
					end
				end
			end
		end
	end
end
