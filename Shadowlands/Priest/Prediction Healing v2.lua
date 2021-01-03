local _G, math, error				= _G, math, error
local math_ceil						= math.ceil
local math_max						= math.max

local TMW 							= _G.TMW

local A 							= _G.Action
local CONST 						= A.Const
local HealingEngine					= Action.HealingEngine
local Unit 							= A.Unit 
local GetCurrentGCD					= A.GetCurrentGCD
local GetSpellDescription			= A.GetSpellDescription
local GetToggle						= A.GetToggle
local GetLatency					= A.GetLatency

local HealingEngineIsManaSave		= HealingEngine.IsManaSave

local UnitIsUnit					= _G.UnitIsUnit

local AtonementBuff = 0

function A:PredictHeal(unitID, variation, enemies)  
	-- @usage obj:PredictHeal(unitID[, variation]) 
	-- @return boolean, number 
	-- Returns:
	-- [1] true if action can be used
	-- [2] total amount of predicted missed health 
	-- Any healing spell can be applied     
	if Unit(unitID):IsPenalty() then
        return true, 0
    end     
	
	local PO = GetToggle(8, "PredictOptions")
	-- PO[1] incHeal
	-- PO[2] incDMG
	-- PO[3] threat -- not usable in prediction
	-- PO[4] HoTs
	-- PO[5] absorbPossitive
	-- PO[6] absorbNegative
	local defaultVariation, isManaSave
	local variation = variation or 1
	if A.IamHealer and HealingEngineIsManaSave(unitID) then 
		isManaSave = true 
		defaultVariation = variation
		variation = math_max(variation - 1 + GetToggle(8, "ManaManagementPredictVariation"), 1)		
	end    
    
	local enemies = enemies or 0
	
    -- Class things
    -- Discipline
    if Unit("player"):HasSpec(256) then 
        AtonementBuff = Unit(unitID):HasBuffs(81749, "player", true)
        AtonementBuff = (AtonementBuff > A.GetGCD() + A.GetCurrentGCD() and AtonementBuff) or 0
    elseif AtonementBuff ~= 0 then 
        AtonementBuff = 0
    end 
    
    -- Spells
    if self.predictName == "PenanceHeal" then
        local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
				
		local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
		if PO[1] and castTime > 0 then 
			incHeal = Unit(unitID):GetIncomingHeals()
		end 
		
		if PO[2] and castTime > 0 then 
			incDMG = Unit(unitID):GetDMG() * castTime
		end 
		
		if PO[4] and castTime > 0 then -- 4 here!
			HoTs = Unit(unitID):GetHEAL() * castTime
		end 
		
		if PO[5] then 
			absorbPossitive = Unit(unitID):GetAbsorb()
			-- Better don't touch it, not tested anyway
			if absorbPossitive >= Unit(unitID):HealthDeficit() then 
				absorbPossitive = 0
			end 
		end 
		
		if PO[6] then 
			absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
		end 
		
		local withoutOptions = desc[1] * variation
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total         
    end 
    
    if self.predictName == "PenanceDMG" then
        local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
				
		local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
		if PO[1] and castTime > 0 then 
			incHeal = Unit(unitID):GetIncomingHeals()
		end 
		
		if PO[2] and castTime > 0 then 
			incDMG = Unit(unitID):GetDMG() * castTime
		end 
		
		if PO[4] and castTime > 0 then -- 4 here!
			HoTs = Unit(unitID):GetHEAL() * castTime
		end 
		
		if PO[5] then 
			absorbPossitive = Unit(unitID):GetAbsorb()
			-- Better don't touch it, not tested anyway
			if absorbPossitive >= Unit(unitID):HealthDeficit() then 
				absorbPossitive = 0
			end 
		end 
		
		if PO[6] then 
			absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
		end 
		
		local withoutOptions = desc[1] * 0.55 * variation
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total                  
    end 
    
    -- Power Word: Shield
    if self.predictName == "PowerWordShield" then   
        local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
				
		local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
		if PO[1] and castTime > 0 then 
			incHeal = Unit(unitID):GetIncomingHeals()
		end 
		
		if PO[2] and castTime > 0 then 
			incDMG = Unit(unitID):GetDMG() * castTime
		end 
		
		if PO[4] and castTime > 0 then -- 4 here!
			HoTs = Unit(unitID):GetHEAL() * castTime
		end 
		
		if PO[5] then 
			absorbPossitive = Unit(unitID):GetAbsorb()
			-- Better don't touch it, not tested anyway
			if absorbPossitive >= Unit(unitID):HealthDeficit() then 
				absorbPossitive = 0
			end 
		end 
		
		if PO[6] then 
			absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
		end 
		
		local withoutOptions = desc[1] * variation
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total 
    end 
    
    -- Power Word: Radiance
    if self.predictName == "PowerWordRadiance" then  
        local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
				
		local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
		if PO[1] and castTime > 0 then 
			incHeal = Unit(unitID):GetIncomingHeals()
		end 
		
		if PO[2] and castTime > 0 then 
			incDMG = Unit(unitID):GetDMG() * castTime
		end 
		
		if PO[4] and castTime > 0 then -- 4 here!
			HoTs = Unit(unitID):GetHEAL() * castTime
		end 
		
		if PO[5] then 
			absorbPossitive = Unit(unitID):GetAbsorb()
			-- Better don't touch it, not tested anyway
			if absorbPossitive >= Unit(unitID):HealthDeficit() then 
				absorbPossitive = 0
			end 
		end 
		
		if PO[6] then 
			absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
		end 
		
		local withoutOptions = desc[1] * variation
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total                    
    end 
    
    if self.predictName == "ShadowMend" then  
        local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
				
		local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
		if PO[1] and castTime > 0 then 
			incHeal = Unit(unitID):GetIncomingHeals()
		end 
		
		if PO[2] and castTime > 0 then 
			incDMG = Unit(unitID):GetDMG() * castTime
		end 
		
		if PO[4] and castTime > 0 then -- 4 here!
			HoTs = Unit(unitID):GetHEAL() * castTime
		end 
		
		if PO[5] then 
			absorbPossitive = Unit(unitID):GetAbsorb()
			-- Better don't touch it, not tested anyway
			if absorbPossitive >= Unit(unitID):HealthDeficit() then 
				absorbPossitive = 0
			end 
		end 
		
		if PO[6] then 
			absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
		end 
		
		local withoutOptions = desc[1] * variation
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total               
    end 
    
    if self.predictName == "DivineStar" then               
        local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
				
		local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
		if PO[1] and castTime > 0 then 
			incHeal = Unit(unitID):GetIncomingHeals()
		end 
		
		if PO[2] and castTime > 0 then 
			incDMG = Unit(unitID):GetDMG() * castTime
		end 
		
		if PO[4] and castTime > 0 then -- 4 here!
			HoTs = Unit(unitID):GetHEAL() * castTime
		end 
		
		if PO[5] then 
			absorbPossitive = Unit(unitID):GetAbsorb()
			-- Better don't touch it, not tested anyway
			if absorbPossitive >= Unit(unitID):HealthDeficit() then 
				absorbPossitive = 0
			end 
		end 
		
		if PO[6] then 
			absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
		end 
		
		local withoutOptions = desc[1] * variation
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total        
    end    
    
    if self.predictName == "Halo" then  
	
        local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
				
		local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
		if PO[1] and castTime > 0 then 
			incHeal = Unit(unitID):GetIncomingHeals()
		end 
		
		if PO[2] and castTime > 0 then 
			incDMG = Unit(unitID):GetDMG() * castTime
		end 
		
		if PO[4] and castTime > 0 then -- 4 here!
			HoTs = Unit(unitID):GetHEAL() * castTime
		end 
		
		if PO[5] then 
			absorbPossitive = Unit(unitID):GetAbsorb()
			-- Better don't touch it, not tested anyway
			if absorbPossitive >= Unit(unitID):HealthDeficit() then 
				absorbPossitive = 0
			end 
		end 
		
		if PO[6] then 
			absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
		end 
		local cast = Unit("player"):CastTime(120517) + A.GetCurrentGCD()
		local withoutOptions = (desc[1] * variation) + ((AtonementBuff > cast and desc[1] * 0.55 * enemies) or 0) 
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total 
    end 
    
    if self.predictName == "HolyNova" then   
	
        local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
				
		local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
		if PO[1] and castTime > 0 then 
			incHeal = Unit(unitID):GetIncomingHeals()
		end 
		
		if PO[2] and castTime > 0 then 
			incDMG = Unit(unitID):GetDMG() * castTime
		end 
		
		if PO[4] and castTime > 0 then -- 4 here!
			HoTs = Unit(unitID):GetHEAL() * castTime
		end 
		
		if PO[5] then 
			absorbPossitive = Unit(unitID):GetAbsorb()
			-- Better don't touch it, not tested anyway
			if absorbPossitive >= Unit(unitID):HealthDeficit() then 
				absorbPossitive = 0
			end 
		end 
		
		if PO[6] then 
			absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
		end 
		
		local withoutOptions = (desc[2] * variation) + ((AtonementBuff > 0 and desc[1] * 0.55 * enemies) or 0) 
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total           
    end 
    
    if self.predictName == "ShadowCovenant" then
        local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
				
		local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
		if PO[1] and castTime > 0 then 
			incHeal = Unit(unitID):GetIncomingHeals()
		end 
		
		if PO[2] and castTime > 0 then 
			incDMG = Unit(unitID):GetDMG() * castTime
		end 
		
		if PO[4] and castTime > 0 then -- 4 here!
			HoTs = Unit(unitID):GetHEAL() * castTime
		end 
		
		if PO[5] then 
			absorbPossitive = Unit(unitID):GetAbsorb()
			-- Better don't touch it, not tested anyway
			if absorbPossitive >= Unit(unitID):HealthDeficit() then 
				absorbPossitive = 0
			end 
		end 
		
		if PO[6] then 
			absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
		end 
		
		local withoutOptions = desc[1] * variation + desc[2] 
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total  

    end 
    
    -- Holy 
    -- Note about Mastery: Regarding overwrite previous effect by any next spell here is no reason to add that 
    -- Holy Word: Sanctify 
    if self.predictName == "HolyWordSanctify" then       
		local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
				
		local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
		if PO[1] and castTime > 0 then 
			incHeal = Unit(unitID):GetIncomingHeals()
		end 
		
		if PO[2] and castTime > 0 then 
			incDMG = Unit(unitID):GetDMG() * castTime
		end 
		
		if PO[4] and castTime > 0 then -- 4 here!
			HoTs = Unit(unitID):GetHEAL() * castTime
		end 
		
		if PO[5] then 
			absorbPossitive = Unit(unitID):GetAbsorb()
			-- Better don't touch it, not tested anyway
			if absorbPossitive >= Unit(unitID):HealthDeficit() then 
				absorbPossitive = 0
			end 
		end 
		
		if PO[6] then 
			absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
		end 
		
		local withoutOptions = desc[1] * variation
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total    
    end 
    
    -- Holy Word: Serenity 
    if self.predictName == "HolyWordSerenity" then       
		local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
				
		local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
		if PO[1] and castTime > 0 then 
			incHeal = Unit(unitID):GetIncomingHeals()
		end 
		
		if PO[2] and castTime > 0 then 
			incDMG = Unit(unitID):GetDMG() * castTime
		end 
		
		if PO[4] and castTime > 0 then -- 4 here!
			HoTs = Unit(unitID):GetHEAL() * castTime
		end 
		
		if PO[5] then 
			absorbPossitive = Unit(unitID):GetAbsorb()
			-- Better don't touch it, not tested anyway
			if absorbPossitive >= Unit(unitID):HealthDeficit() then 
				absorbPossitive = 0
			end 
		end 
		
		if PO[6] then 
			absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
		end 
		
		local withoutOptions = desc[1] * variation
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total 
    end 
    
    -- Circle of Healing 
    if self.predictName == "CircleOfHealing" then       
		local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
				
		local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
		if PO[1] and castTime > 0 then 
			incHeal = Unit(unitID):GetIncomingHeals()
		end 
		
		if PO[2] and castTime > 0 then 
			incDMG = Unit(unitID):GetDMG() * castTime
		end 
		
		if PO[4] and castTime > 0 then -- 4 here!
			HoTs = Unit(unitID):GetHEAL() * castTime
		end 
		
		if PO[5] then 
			absorbPossitive = Unit(unitID):GetAbsorb()
			-- Better don't touch it, not tested anyway
			if absorbPossitive >= Unit(unitID):HealthDeficit() then 
				absorbPossitive = 0
			end 
		end 
		
		if PO[6] then 
			absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
		end 
		
		local withoutOptions = desc[1] * variation
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total 
    end 
    
    -- Prayer Of Mending    
    if self.predictName == "PrayerofMending" then   
		local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
				
		local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
		if PO[1] and castTime > 0 then 
			incHeal = Unit(unitID):GetIncomingHeals()
		end 
		
		if PO[2] and castTime > 0 then 
			incDMG = Unit(unitID):GetDMG() * castTime
		end 
		
		if PO[4] and castTime > 0 then -- 4 here!
			HoTs = Unit(unitID):GetHEAL() * castTime
		end 
		
		if PO[5] then 
			absorbPossitive = Unit(unitID):GetAbsorb()
			-- Better don't touch it, not tested anyway
			if absorbPossitive >= Unit(unitID):HealthDeficit() then 
				absorbPossitive = 0
			end 
		end 
		
		if PO[6] then 
			absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
		end 
		
		local withoutOptions = desc[1] * variation
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total 
    end 
    
    -- Prayer Of Mending HoT   
    if self.predictName == "PrayerofMendingHoT" then   
		local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
				
		local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
		if PO[1] and castTime > 0 then 
			incHeal = Unit(unitID):GetIncomingHeals()
		end 
		
		if PO[2] and castTime > 0 then 
			incDMG = Unit(unitID):GetDMG() * castTime
		end 
		
		if PO[4] and castTime > 0 then -- 4 here!
			HoTs = Unit(unitID):GetHEAL() * castTime
		end 
		
		if PO[5] then 
			absorbPossitive = Unit(unitID):GetAbsorb()
			-- Better don't touch it, not tested anyway
			if absorbPossitive >= Unit(unitID):HealthDeficit() then 
				absorbPossitive = 0
			end 
		end 
		
		if PO[6] then 
			absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
		end 
		
		local withoutOptions = desc[1] * variation
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total 
    end 
    
    -- Prayer of Healing
    if self.predictName == "PrayerOfHealing" then   
		local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
				
		local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
		if PO[1] and castTime > 0 then 
			incHeal = Unit(unitID):GetIncomingHeals()
		end 
		
		if PO[2] and castTime > 0 then 
			incDMG = Unit(unitID):GetDMG() * castTime
		end 
		
		if PO[4] and castTime > 0 then -- 4 here!
			HoTs = Unit(unitID):GetHEAL() * castTime
		end 
		
		if PO[5] then 
			absorbPossitive = Unit(unitID):GetAbsorb()
			-- Better don't touch it, not tested anyway
			if absorbPossitive >= Unit(unitID):HealthDeficit() then 
				absorbPossitive = 0
			end 
		end 
		
		if PO[6] then 
			absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
		end 
		
		local withoutOptions = desc[1] * variation
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total 
    end 
    
    -- Binding Heal
    if self.predictName == "BindingHeal" then   
		local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
				
		local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
		if PO[1] and castTime > 0 then 
			incHeal = Unit(unitID):GetIncomingHeals()
		end 
		
		if PO[2] and castTime > 0 then 
			incDMG = Unit(unitID):GetDMG() * castTime
		end 
		
		if PO[4] and castTime > 0 then -- 4 here!
			HoTs = Unit(unitID):GetHEAL() * castTime
		end 
		
		if PO[5] then 
			absorbPossitive = Unit(unitID):GetAbsorb()
			-- Better don't touch it, not tested anyway
			if absorbPossitive >= Unit(unitID):HealthDeficit() then 
				absorbPossitive = 0
			end 
		end 
		
		if PO[6] then 
			absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
		end 
		
		local withoutOptions = desc[1] * variation
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total 
    end 
    
    -- Renew 
    if self.predictName == "Renew" then   
		local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
				
		local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
		if PO[1] and castTime > 0 then 
			incHeal = Unit(unitID):GetIncomingHeals()
		end 
		
		if PO[2] and castTime > 0 then 
			incDMG = Unit(unitID):GetDMG() * castTime
		end 
		
		if PO[4] and castTime > 0 then -- 4 here!
			HoTs = Unit(unitID):GetHEAL() * castTime
		end 
		
		if PO[5] then 
			absorbPossitive = Unit(unitID):GetAbsorb()
			-- Better don't touch it, not tested anyway
			if absorbPossitive >= Unit(unitID):HealthDeficit() then 
				absorbPossitive = 0
			end 
		end 
		
		if PO[6] then 
			absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
		end 
		
		local withoutOptions = desc[2] * variation + (desc[1] * 15)
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total              

    end 
    
    -- Flash Heal
    if self.predictName == "FlashHeal" then   
		local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
				
		local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
		if PO[1] and castTime > 0 then 
			incHeal = Unit(unitID):GetIncomingHeals()
		end 
		
		if PO[2] and castTime > 0 then 
			incDMG = Unit(unitID):GetDMG() * castTime
		end 
		
		if PO[4] and castTime > 0 then -- 4 here!
			HoTs = Unit(unitID):GetHEAL() * castTime
		end 
		
		if PO[5] then 
			absorbPossitive = Unit(unitID):GetAbsorb()
			-- Better don't touch it, not tested anyway
			if absorbPossitive >= Unit(unitID):HealthDeficit() then 
				absorbPossitive = 0
			end 
		end 
		
		if PO[6] then 
			absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
		end 
		
		local withoutOptions = desc[1] * variation
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total 
    end 
    
    -- Heal 
    if self.predictName == "Heal" then   
		local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
				
		local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
		if PO[1] and castTime > 0 then 
			incHeal = Unit(unitID):GetIncomingHeals()
		end 
		
		if PO[2] and castTime > 0 then 
			incDMG = Unit(unitID):GetDMG() * castTime
		end 
		
		if PO[4] and castTime > 0 then -- 4 here!
			HoTs = Unit(unitID):GetHEAL() * castTime
		end 
		
		if PO[5] then 
			absorbPossitive = Unit(unitID):GetAbsorb()
			-- Better don't touch it, not tested anyway
			if absorbPossitive >= Unit(unitID):HealthDeficit() then 
				absorbPossitive = 0
			end 
		end 
		
		if PO[6] then 
			absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
		end 
		
		local withoutOptions = desc[1] * variation
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total 
    end 
    
    -- Apotheosis
    if self.predictName == "Apotheosis" then   
		local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
				
		local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
		if PO[1] and castTime > 0 then 
			incHeal = Unit(unitID):GetIncomingHeals()
		end 
		
		if PO[2] and castTime > 0 then 
			incDMG = Unit(unitID):GetDMG() * castTime
		end 
		
		if PO[4] and castTime > 0 then -- 4 here!
			HoTs = Unit(unitID):GetHEAL() * castTime
		end 
		
		if PO[5] then 
			absorbPossitive = Unit(unitID):GetAbsorb()
			-- Better don't touch it, not tested anyway
			if absorbPossitive >= Unit(unitID):HealthDeficit() then 
				absorbPossitive = 0
			end 
		end 
		
		if PO[6] then 
			absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
		end 
		
        local Serenity = A.GetSpellDescription(2050)[1] * variation 
        local Sancify = A.GetSpellDescription(34861)[1] * variation		
		local withoutOptions = Serenity + Sancify
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total 

    end 
    
    -- PvP: Greater Heal 
    if self.predictName == "GreaterHeal" then   
		local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
				
		local incHeal, incDMG, HoTs, absorbPossitive, absorbNegative = 0, 0, 0, 0, 0
		if PO[1] and castTime > 0 then 
			incHeal = Unit(unitID):GetIncomingHeals()
		end 
		
		if PO[2] and castTime > 0 then 
			incDMG = Unit(unitID):GetDMG() * castTime
		end 
		
		if PO[4] and castTime > 0 then -- 4 here!
			HoTs = Unit(unitID):GetHEAL() * castTime
		end 
		
		if PO[5] then 
			absorbPossitive = Unit(unitID):GetAbsorb()
			-- Better don't touch it, not tested anyway
			if absorbPossitive >= Unit(unitID):HealthDeficit() then 
				absorbPossitive = 0
			end 
		end 
		
		if PO[6] then 
			absorbNegative = Unit(unitID):GetTotalHealAbsorbs()
		end 
		
		local withoutOptions = desc[1] * variation
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total 
    end 
        
	-- Debug 
	if not self.predictName then 
		error((self:GetKeyName() or "Unknown action name") .. " doesn't contain predictName")		
	end 

    return false, 0
	
end
