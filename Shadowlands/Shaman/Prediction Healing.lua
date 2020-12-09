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

local RESTO 						= A[CONST.SHAMAN_RESTORATION]

local UnitIsUnit					= _G.UnitIsUnit


-- Resto Shaman Mastery Calculate Deep Healing    
local function GetHealingModifier(unitID)
	local extraHealModifier = 1
	
	if A.IamHealer then     	  
   	    local total, mastery = 0, 1
		local deephealing = 0
		local UnitHP = Unit(unitID):HealthPercent() / 100 or 0    
   	    local bonus = GetMasteryEffect()        
		mastery = bonus / 100
		extraHealModifier = (1 + mastery * (1 - UnitHP))
	end 
	
	return extraHealModifier
end 

function A:PredictHeal(unitID, variation)  
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
    
    -- Healing Surge
    if self.predictName == "HealingSurge" then        
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
		
		local extraHealModifier = GetHealingModifier(unitID)
		
		local withoutOptions = desc[1] * extraHealModifier * variation
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total           
    end 
 
    -- Healing Wave
    if self.predictName == "HealingWave" then        
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
		
		local extraHealModifier = GetHealingModifier(unitID)
		
		local withoutOptions = desc[1] * extraHealModifier * variation
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total          
    end
 
    -- Riptide 
    if self.predictName == "Riptide" then    
		local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
		
		-- Get back variation if we have buff up ThunderFocusTea
		if isManaSave and Unit("player"):HasBuffs(MK.ThunderFocusTea.ID, true) > 0 then 
			variation = defaultVariation
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
		
		local extraHealModifier = GetHealingModifier(unitID)
		
		local withoutOptions = (desc[1] * variation * extraHealModifier) + (desc[2] * variation * 1.7)
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total   

    end 
	
    -- UnleashLife
    if self.predictName == "UnleashLife" then    
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
		
		local extraHealModifier = GetHealingModifier(unitID)
		
		local withoutOptions = desc[1] * extraHealModifier * variation
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total   
    end 

    -- HealingStreamTotem
    if self.predictName == "HealingStreamTotem" then
		local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
		
		-- Get back variation if we have buff up ThunderFocusTea
		if isManaSave and Unit("player"):HasBuffs(MK.ThunderFocusTea.ID, true) > 0 then 
			variation = defaultVariation
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
		
		local extraHealModifier = GetHealingModifier(unitID)
		
		local withoutOptions = (desc[1] * variation * extraHealModifier) + (desc[2] * variation * 1.7)
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total 
    end    
	
	-- HealingTideTotem
    if self.predictName == "HealingTideTotem" then
		local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
		
		-- Get back variation if we have buff up ThunderFocusTea
		if isManaSave and Unit("player"):HasBuffs(MK.ThunderFocusTea.ID, true) > 0 then 
			variation = defaultVariation
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
		
		local extraHealModifier = GetHealingModifier(unitID)
		
		local withoutOptions = (desc[1] * variation * extraHealModifier) + (desc[2] * variation * 1.7)
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total 
    end 
	
    -- EarthShield	
    if self.predictName == "EarthShield" then  
		local desc = self:GetSpellDescription()
		local castTime = self:GetSpellCastTime()
		
		-- Add current GCD to pre-pare 
		if castTime > 0 then 
			castTime = castTime + GetCurrentGCD()
		end 
		
		-- Get back variation if we have buff up ThunderFocusTea
		if isManaSave and Unit("player"):HasBuffs(MK.ThunderFocusTea.ID, true) > 0 then 
			variation = defaultVariation
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
		
		local extraHealModifier = GetHealingModifier(unitID)
		
		local withoutOptions = (desc[1] * variation * extraHealModifier) + (desc[2] * variation * 1.7)
		local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
		
		return Unit(unitID):HealthDeficit() >= total, total 
    end
	
	-- Debug 
	if not self.predictName then 
		error((self:GetKeyName() or "Unknown action name") .. " doesn't contain predictName")		
	end 

    return false, 0
	
end
