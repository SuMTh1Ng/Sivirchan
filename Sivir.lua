if GetObjectName(myHero) ~= "Sivir" then return end

SivirMenu = Menu("Sivir", "Sivir")
SivirMenu:SubMenu("Combo", "Combo")
SivirMenu.Combo:Boolean("Q", "Use Q", true)
SivirMenu.Combo:Boolean("W", "Use W", true)
SivirMenu.Combo:Boolean("R", "Use R", true)

SivirMenu:SubMenu("Harass", "Harass")
SivirMenu.Harass:Boolean("Q", "Use Q", true)
SivirMenu.Harass:Boolean("W", "Use W", true)
SivirMenu.Harass:Slider("Mana", "if Mana % is More than", 30, 0, 80, 1)

SivirMenu:SubMenu("LaneClear", "Lane Clear")
SivirMenu.LaneClear:Boolean("Q", "Use Q", true)
SivirMenu.LaneClear:Boolean("W", "Use W", true)

SivirMenu:SubMenu("Killsteal", "Killsteal")
SivirMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)


SivirMenu:SubMenu("Junglesteal", "Baron/Drake Steal")
SivirMenu.Junglesteal:Boolean("Q", "Use Q", true)

SivirMenu:SubMenu("Drawings", "Drawings")
SivirMenu.Drawings:Boolean("Q", "Draw Q Range", true)
SivirMenu.Drawings:Boolean("E", "Draw R Proc Range", true)
SivirMenu.Drawings:Boolean("R", "Draw R Range", true)


local callback = nil
local mouse = GetMousePos()


OnLoop(function(myHero)
    if IOW:Mode() == "Combo" then
	
	        local target = GetCurrentTarget()
		local QPre = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),1800,490,1250,80,true,true)
		
                if CanUseSpell(myHero, _Q) == READY and QPre.HitChance == 1 and GoS:ValidTarget(target, 1250) and SivirMenu.Combo.Q:Value() then
                CastSkillShot(_Q,QPre.PredPos.x,QPre.PredPos.y,QPre.PredPos.z)
	        end
                          
                if CanUseSpell(myHero, _W) == READY and GoS:ValidTarget(target, 510) and GoS:GetDistance(myHero, target) > 1 and SivirMenu.Combo.W:Value() then
                CastSpell(_W)
		end
		
			if CanUseSpell(myHero, _R) == READY and GoS:ValidTarget(target, 1500) and GoS:GetDistance(myHero, target) > 1 and SivirMenu.Combo.R:Value() then
                CastSpell(_R)
		end
			
	                      
	end	
	
	if IOW:Mode() == "Harass" and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= SivirMenu.Harass.Mana:Value() then
	
		local target = GetCurrentTarget()
		local QPre = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),1800,250,1250,80,true,true)
		
                if CanUseSpell(myHero, _Q) == READY and QPre.HitChance == 1 and GoS:ValidTarget(target, 1250) and SivirMenu.Harass.Q:Value() then
                CastSkillShot(_Q,QPre.PredPos.x,QPre.PredPos.y,QPre.PredPos.z)
	        end
		
		if CanUseSpell(myHero, _W) == READY and GoS:ValidTarget(target, 490) and SivirMenu.Harass.W:Value() then
                CastSpell(_W)
		end
		
	end
	
	if IOW:Mode() == "LaneClear" then
		local mouse = GetMousePos()
		
		if CanUseSpell(myHero, _Q) == READY and SivirMenu.Harass.Q:Value() then
                CastSkillShot(_Q, mouse.x, mouse.y, mouse.z)
	        end
		
		if CanUseSpell(myHero, _W) == READY and SivirMenu.Harass.W:Value() then
                CastSpell(_W)
		end
		
	end
	
	for i,enemy in pairs(GoS:GetEnemyHeroes()) do
	
	    local QPre = GetPredictionForPlayer(GoS:myHeroPos(),enemy,GetMoveSpeed(enemy),1800,250,1250,80,true,true)
		
		local ExtraDmg = 0
		if GotBuff(myHero, "itemmagicshankcharge") > 99 then
		ExtraDmg = ExtraDmg + GetBonusDmg(myHero) + 60
		end
		
		
  	        if CanUseSpell(myHero, _Q) == READY and QPre.HitChance == 1 and GoS:ValidTarget(enemy, 1250) and SivirMenu.Killsteal.Q:Value() and GetCurrentHP(enemy)+GetMagicShield(enemy)+GetDmgShield(enemy) < GoS:CalcDamage(myHero, enemy, 0, 55*GetCastLevel(myHero,_Q)+25+GetBonusDmg(myHero) + ExtraDmg) then 
                CastSkillShot(_Q,QPre.PredPos.x,QPre.PredPos.y,QPre.PredPos.z)
	        end
		
	end
	
if  IOW:Mode() == "Combo" then
	local bilge = GetItemSlot(myHero,3144)
	local botrk = GetItemSlot(myHero,3153)
	
	if bilge >= 1 and GoS:ValidTarget(target,550) then
		if CanUseSpell(myHero,GetItemSlot(myHero,3144)) == READY then
			CastTargetSpell(target, GetItemSlot(myHero,3144))
		end	
	elseif botrk >= 1 and GoS:ValidTarget(target,550) and (GetMaxHP(myHero) / GetCurrentHP(myHero)) >= 1.25 then 
		if CanUseSpell(myHero,GetItemSlot(myHero,3153)) == READY then
			CastTargetSpell(target,GetItemSlot(myHero,3153))
		end
	end
end

for _,mob in pairs(GoS:GetAllMinions(MINION_JUNGLE)) do
	
	local mobPos = GetOrigin(mob)
        local ExtraDmg = 0
	if GotBuff(myHero, "itemmagicshankcharge") > 99 then
	ExtraDmg = ExtraDmg + GetBonusDmg(myHero) + 60
	end	
	
	if GetObjectName(mob) == "SRU_Dragon" or GetObjectName(mob) == "SRU_Baron" then
	  if CanUseSpell(myHero, _Q) == READY and SivirMenu.Junglesteal.Q:Value() and GoS:ValidTarget(mob, 1250) and GetCurrentHP(mob) < GoS:CalcDamage(myHero, mob, 0, 55*GetCastLevel(myHero,_Q)+25+GetBonusDmg(myHero) + ExtraDmg) then
	  CastSkillShot(_Q,mobPos.x, mobPos.y, mobPos.z)
	  end
    end
end

if SivirMenu.Drawings.Q:Value() then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,1250,3,100,0xff00ff00) end
if SivirMenu.Drawings.E:Value() then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,1500,3,100,0xff00ff00) end
if SivirMenu.Drawings.R:Value() then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,1000,3,100,0xff00ff00) end
end)
