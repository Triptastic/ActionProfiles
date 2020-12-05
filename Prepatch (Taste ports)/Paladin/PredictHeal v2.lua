local _G, math, error                = _G, math, error
local math_ceil                        = math.ceil
local math_max                        = math.max

local TMW                             = _G.TMW

local A                             = _G.Action
local CONST                         = A.Const
local HealingEngine                    = Action.HealingEngine
local Unit                             = A.Unit 
local GetCurrentGCD                    = A.GetCurrentGCD
local GetSpellDescription            = A.GetSpellDescription
local GetToggle                        = A.GetToggle
local GetLatency                    = A.GetLatency

local HealingEngineIsManaSave        = HealingEngine.IsManaSave

local HOLY                         = A[CONST.PALADIN_HOLY]

local UnitIsUnit                    = _G.UnitIsUnit


-- Holy Paladin Mastery Calculate  
local function GetHealingModifier(unitID)
    local extraHealModifier = 1    
    
    if Unit("player"):HasSpec(65) then
        local c_range, m_range = Unit(unitID):GetRange(), 40
        local bonus = GetMasteryEffect()
        if Unit("player"):HasBuffs(214202, "player", true) > 0 then
            m_range = 60
        end
        
        extraHealModifier = (bonus - ( bonus / m_range * c_range )) / 100 + 1
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
    
    -- Spells
    if self.predictName == "FlashofLight" then        
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
    
    -- Holy
    if self.predictName == "WordofGlory" then    
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

    if self.predictName == "HolyShock" then    
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
    
    if self.predictName == "LightofDawn" then               
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
    
    if self.predictName == "LightofMartyr" then               
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
    
    if self.predictName == "HolyPrism" then               
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
    
    if self.predictName == "HolyPrismAoE" then               
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
        
        local withoutOptions = desc[3] * extraHealModifier * variation
        local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
        
        return Unit(unitID):HealthDeficit() >= total, total     
    end 
    
    if self.predictName == "HolyLight" then          
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
    
    if self.predictName == "LightsHammer" then  
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
        
        local withoutOptions = desc[2] / 2 * extraHealModifier * 14 * variation
        local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
        
        return Unit(unitID):HealthDeficit() >= total, total  
        
    end 
    
    if self.predictName == "BestowFaith" then  
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
    
    -- Protection
    if self.predictName == "LightOfProtector" then 
        
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
        
        local bonus_heal = (200 - (200 / Unit(unitID):HealthMax() * Unit(unitID):Health())) / 100 + 1
        local LightOfProtector = 0
        if A.IsSpellLearned(213652) then
            LightOfProtector = A.GetSpellDescription(213652)[1] * bonus_heal * variation
        else
            LightOfProtector = A.GetSpellDescription(184092)[1] * bonus_heal * variation
        end  
        
        local extraHealModifier = GetHealingModifier(unitID)
        
        local withoutOptions = LightOfProtector * extraHealModifier * variation
        local total = withoutOptions + incHeal - incDMG + HoTs + absorbPossitive - absorbNegative
        
        return Unit(unitID):HealthDeficit() >= total, total
    end 
    
    -- All 
    -- These spells doesn't relative for increasing heal buffs
    if self.predictName == "LayonHands" then
        local total = UnitHealthMax(unitID) * 0.8
        return Unit(unitID):HealthDeficit() >= total, total
    end     
    
    -- Debug 
    if not self.predictName then 
        error((self:GetKeyName() or "Unknown action name") .. " doesn't contain predictName")        
    end 
    
    return false, 0
    
end

