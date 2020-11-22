-------------------------------
-- Taste TMW Action Rotation --
-------------------------------
local TMW                                       = TMW
local CNDT                                      = TMW.CNDT
local Env                                       = CNDT.Env
local Action                                    = Action
local Listener                                  = Action.Listener
local Create                                    = Action.Create
local GetToggle                                 = Action.GetToggle
local SetToggle                                 = Action.SetToggle
local GetGCD                                    = Action.GetGCD
local GetCurrentGCD                             = Action.GetCurrentGCD
local GetPing                                   = Action.GetPing
local ShouldStop                                = Action.ShouldStop
local BurstIsON                                 = Action.BurstIsON
local AuraIsValid                               = Action.AuraIsValid
local InterruptIsValid                          = Action.InterruptIsValid
local FrameHasSpell                             = Action.FrameHasSpell
local Azerite                                   = LibStub("AzeriteTraits")
local Utils                                     = Action.Utils
local TeamCache                                 = Action.TeamCache
local EnemyTeam                                 = Action.EnemyTeam
local FriendlyTeam                              = Action.FriendlyTeam
local LoC                                       = Action.LossOfControl
local Player                                    = Action.Player
local MultiUnits                                = Action.MultiUnits
local UnitCooldown                              = Action.UnitCooldown
local Unit                                      = Action.Unit
local IsUnitEnemy                               = Action.IsUnitEnemy
local IsUnitFriendly                            = Action.IsUnitFriendly
local HealingEngine                             = Action.HealingEngine
local ActiveUnitPlates                          = MultiUnits:GetActiveUnitPlates()
local TeamCacheFriendly                         = TeamCache.Friendly
local TeamCacheFriendlyIndexToPLAYERs           = TeamCacheFriendly.IndexToPLAYERs
local IsIndoors, UnitIsUnit                     = IsIndoors, UnitIsUnit
local TR                                        = Action.TasteRotation
local Pet                                       = LibStub("PetLibrary")
local next, pairs, type, print                  = next, pairs, type, print
local math_floor                                = math.floor
local math_ceil                                 = math.ceil
local tinsert                                   = table.insert
local select, unpack, table                     = select, unpack, table
local CombatLogGetCurrentEventInfo              = _G.CombatLogGetCurrentEventInfo
local UnitGUID, UnitIsUnit, UnitDamage, UnitAttackSpeed, UnitAttackPower = UnitGUID, UnitIsUnit, UnitDamage, UnitAttackSpeed, UnitAttackPower
local _G, setmetatable, select, math            = _G, setmetatable, select, math
local huge                                      = math.huge
local UIParent                                  = _G.UIParent
local CreateFrame                               = _G.CreateFrame
local wipe                                      = _G.wipe
local IsUsableSpell                             = IsUsableSpell
local UnitPowerType                             = UnitPowerType

--- ============================ CONTENT =========================== ---
--- ======================= SPELLS DECLARATION ===================== ---

Action[ACTION_CONST_WARRIOR_ARMS] = {
    -- Racial
    ArcaneTorrent                          = Create({ Type = "Spell", ID = 50613     }),
    BloodFury                              = Create({ Type = "Spell", ID = 20572      }),
    Fireblood                              = Create({ Type = "Spell", ID = 265221     }),
    AncestralCall                          = Create({ Type = "Spell", ID = 274738     }),
    Berserking                             = Create({ Type = "Spell", ID = 26297    }),
    ArcanePulse                            = Create({ Type = "Spell", ID = 260364    }),
    QuakingPalm                            = Create({ Type = "Spell", ID = 107079     }),
    Haymaker                               = Create({ Type = "Spell", ID = 287712     }), 
    WarStomp                               = Create({ Type = "Spell", ID = 20549     }),
    BullRush                               = Create({ Type = "Spell", ID = 255654     }),  
    BagofTricks                            = Create({ Type = "Spell", ID = 312411 }),	
    GiftofNaaru                            = Create({ Type = "Spell", ID = 59544    }),
    Shadowmeld                             = Create({ Type = "Spell", ID = 58984    }), -- usable in Action Core 
    Stoneform                              = Create({ Type = "Spell", ID = 20594    }), 
    WilloftheForsaken                      = Create({ Type = "Spell", ID = 7744        }), -- not usable in APL but user can Queue it   
    EscapeArtist                           = Create({ Type = "Spell", ID = 20589    }), -- not usable in APL but user can Queue it
    EveryManforHimself                     = Create({ Type = "Spell", ID = 59752    }), -- not usable in APL but user can Queue it
    -- Generics
    Rend                                   = Create({ Type = "Spell", ID = 772 }),
    RendDebuff                             = Create({ Type = "Spell", ID = 772, Hidden = true }),
    DeadlyCalm                             = Create({ Type = "Spell", ID = 262228 }),
    Skullsplitter                          = Create({ Type = "Spell", ID = 260643 }),
    Ravager                                = Create({ Type = "Spell", ID = 152277 }),
    ColossusSmash                          = Create({ Type = "Spell", ID = 167105 }),
    Warbreaker                             = Create({ Type = "Spell", ID = 262161 }),
    MortalStrike                           = Create({ Type = "Spell", ID = 12294 }),
    DeepWoundsDebuff                       = Create({ Type = "Spell", ID = 262115, Hidden = true }),
    Cleave                                 = Create({ Type = "Spell", ID = 845 }),
    CleaveBuff                             = Create({ Type = "Spell", ID = 231833 }),
    Bladestorm                             = Create({ Type = "Spell", ID = 227847 }),
    TestofMightBuff                        = Create({ Type = "Spell", ID = 275540 }),
    DeadlyCalmBuff                         = Create({ Type = "Spell", ID = 262228, Hidden = true }),
    Execute                                = Create({ Type = "Spell", ID = 163201 }),
    ColossusSmashDebuff                    = Create({ Type = "Spell", ID = 208086 }),
    Slam                                   = Create({ Type = "Spell", ID = 1464 }),
    CrushingAssaultBuff                    = Create({ Type = "Spell", ID = 278826 }),
    Overpower                              = Create({ Type = "Spell", ID = 7384 }),
    Massacre                               = Create({ Type = "Spell", ID = 281001, Hidden = true }),
    SuddenDeathBuff                        = Create({ Type = "Spell", ID = 52437 }),
    TestofMight                            = Create({ Type = "Spell", ID = 275529 }),
    Whirlwind                              = Create({ Type = "Spell", ID = 1680 }),
    FervorofBattle                         = Create({ Type = "Spell", ID = 202316 }),
    Charge                                 = Create({ Type = "Spell", ID = 100 }),
    Berserking                             = Create({ Type = "Spell", ID = 26297 }),
    LightsJudgment                         = Create({ Type = "Spell", ID = 255647 }),
    Avatar                                 = Create({ Type = "Spell", ID = 107574 }),
    SweepingStrikes                        = Create({ Type = "Spell", ID = 260708 }),
    ReapingFlames                          = Create({ Type = "Spell", ID = 311195 }),
    CondensedLifeforce                     = Create({ Type = "Spell", ID = 299357 }),	
    -- Trinkets
    TrinketTest                            = Create({ Type = "Trinket", ID = 122530, QueueForbidden = true }), 
    TrinketTest2                           = Create({ Type = "Trinket", ID = 159611, QueueForbidden = true }), 
    AzsharasFontofPower                    = Create({ Type = "Trinket", ID = 169314, QueueForbidden = true }), 
    PocketsizedComputationDevice           = Create({ Type = "Trinket", ID = 167555, QueueForbidden = true }), 
    RotcrustedVoodooDoll                   = Create({ Type = "Trinket", ID = 159624, QueueForbidden = true }), 
    ShiverVenomRelic                       = Create({ Type = "Trinket", ID = 168905, QueueForbidden = true }), 
    AquipotentNautilus                     = Create({ Type = "Trinket", ID = 169305, QueueForbidden = true }), 
    TidestormCodex                         = Create({ Type = "Trinket", ID = 165576, QueueForbidden = true }), 
    VialofStorms                           = Create({ Type = "Trinket", ID = 158224, QueueForbidden = true }), 
    -- Potions
    PotionofUnbridledFury                  = Create({ Type = "Potion", ID = 169299, QueueForbidden = true }), 
    BattlePotionOfAgility                  = Create({ Type = "Potion", ID = 163223, QueueForbidden = true }), 
    SuperiorBattlePotionOfAgility          = Create({ Type = "Potion", ID = 168489, QueueForbidden = true }), 
    PotionTest                             = Create({ Type = "Potion", ID = 142117, QueueForbidden = true }), 
	PotionofSpectralStrength			   = Create({ Type = "Potion", ID = 171275, QueueForbidden = true }),
    -- Trinkets
    GenericTrinket1                        = Create({ Type = "Trinket", ID = 114616, QueueForbidden = true }),
    GenericTrinket2                        = Create({ Type = "Trinket", ID = 114081, QueueForbidden = true }),
    GalecallersBoon                        = Create({ Type = "Trinket", ID = 159614, QueueForbidden = true }),
    InvocationOfYulon                      = Create({ Type = "Trinket", ID = 165568, QueueForbidden = true }),
    LustrousGoldenPlumage                  = Create({ Type = "Trinket", ID = 159617, QueueForbidden = true }),
    VigorTrinket                           = Create({ Type = "Trinket", ID = 165572, QueueForbidden = true }),
    AshvanesRazorCoral                     = Create({ Type = "Trinket", ID = 169311, QueueForbidden = true }),
    -- Misc
    Channeling                             = Create({ Type = "Spell", ID = 209274, Hidden = true     }),	-- Show an icon during channeling
    TargetEnemy                            = Create({ Type = "Spell", ID = 44603, Hidden = true     }),	-- Change Target (Tab button)
    StopCast                               = Create({ Type = "Spell", ID = 61721, Hidden = true     }),		-- spell_magic_polymorphrabbit
    CyclotronicBlast                       = Create({ Type = "Spell", ID = 293491, Hidden = true}),
    ConcentratedFlameBurn                  = Create({ Type = "Spell", ID = 295368, Hidden = true}),
    RazorCoralDebuff                       = Create({ Type = "Spell", ID = 303568, Hidden = true     }),
    ConductiveInkDebuff                    = Create({ Type = "Spell", ID = 302565, Hidden = true     }),
	
	Darkflight							   = Action.Create({ Type = "Spell", ID = 68992 }), -- used for Heart of Azeroth
--	Regeneratin							   = Action.Create({ Type = "Spell", ID = 291944 }), -- used for SweepingStrikes	
};

-- To create covenant use next code:
--Action:CreateCovenantsFor(ACTION_CONST_WARRIOR_ARMS)  -- where PLAYERSPEC is Constance (example: ACTION_CONST_MONK_BM)
Action:CreateEssencesFor(ACTION_CONST_WARRIOR_ARMS)
local A = setmetatable(Action[ACTION_CONST_WARRIOR_ARMS], { __index = Action })





local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end

------------------------------------------
---------- ARMS PRE APL SETUP ------------
------------------------------------------

local Temp = {
    TotalAndPhys                            = {"TotalImun", "DamagePhysImun"},
    TotalAndCC                              = {"TotalImun", "CCTotalImun"},
    TotalAndPhysKick                        = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC                       = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun                     = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun                = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMag                             = {"TotalImun", "DamageMagicImun"},
    TotalAndMagKick                         = {"TotalImun", "DamageMagicImun", "KickImun"},
    DisablePhys                             = {"TotalImun", "DamagePhysImun", "Freedom", "CCTotalImun"},
    DisableMag                              = {"TotalImun", "DamageMagicImun", "Freedom", "CCTotalImun"},
}

local IsIndoors, UnitIsUnit = IsIndoors, UnitIsUnit

local function IsSchoolFree()
    return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "SHADOW") == 0
end 

local function InMelee(unit)
    -- @return boolean 
    return A.MortalStrike:IsInRange(unit)
end 
InMelee = A.MakeFunctionCachedDynamic(InMelee)

local function InRange(unit)
    -- @return boolean 
    return A.MortalStrike:IsInRange(unit)
end 
InRange = A.MakeFunctionCachedDynamic(InRange)

local function GetByRange(count, range, isStrictlySuperior, isStrictlyInferior, isCheckEqual, isCheckCombat)
    -- @return boolean 
    local c = 0 
    
    if isStrictlySuperior == nil then
        isStrictlySuperior = false
    end
    
    if isStrictlyInferior == nil then
        isStrictlyInferior = false
    end    
    
    for unit in pairs(ActiveUnitPlates) do 
        if (not isCheckEqual or not UnitIsUnit("target", unit)) and (not isCheckCombat or Unit(unit):CombatTime() > 0) then 
            if InRange(unit) then 
                c = c + 1
            elseif range then 
                local r = Unit(unit):GetRange()
                if r > 0 and r <= range then 
                    c = c + 1
                end 
            end 
            -- Strictly superior than >
            if isStrictlySuperior and not isStrictlyInferior then
                if c > count then
                    return true
                end
            end
            
            -- Stryctly inferior <
            if isStrictlyInferior and not isStrictlySuperior then
                if c < count then
                    return true
                end
            end
            
            -- Classic >=
            if not isStrictlyInferior and not isStrictlySuperior then
                if c >= count then 
                    return true 
                end 
            end
        end 
        
    end
    
end  
GetByRange = A.MakeFunctionCachedDynamic(GetByRange)

local function UpdateExecuteID()
    Execute = A.Massacre:IsTalentLearned() and A.ExecuteMassacre or A.ExecuteDefault
end

--[[ [1] CC AntiFake Rotation
local function AntiFakeStun(unit) 
    return 
    A.IsUnitEnemy(unit) and  
    Unit(unit):GetRange() <= 20 and 
    (
        (A.IsInPvP and Unit(unit):IsControlAble("stun", 0)) 
        or
        not A.IsInPvP        
    ) 
    and A.StormboltGreen:AbsentImun(unit, Temp.TotalAndPhysAndCCAndStun, true)          
end 
A[1] = function(icon)    
    if    A.StormboltGreen:IsReady(nil, nil, nil, true) and 
    (
        AntiFakeStun("mouseover") or 
        AntiFakeStun("target") or 
        (
            not A.IsUnitEnemy("mouseover") and 
            not A.IsUnitEnemy("target")
        )
    )
    then 
        return A.StormboltGreen:Show(icon)         
    end                                                                     
end

-- [2] Kick AntiFake Rotation
A[2] = function(icon)        
    local unit
    if A.IsUnitEnemy("mouseover") then 
        unit = "mouseover"
    elseif A.IsUnitEnemy("target") then 
        unit = "target"
    end 
    
    if unit then         
        local castLeft, _, _, _, notKickAble = Unit(unit):IsCastingRemains()
        if castLeft > 0 then 
            -- Pummel        
            if not notKickAble and A.PummelGreen:IsReady(unit, nil, nil, true) and A.PummelGreen:AbsentImun(unit, Temp.TotalAndPhysKick, true) then
                return A.PummelGreen:Show(icon)                                                  
            end 
            
            -- Stormbolt
            if A.Stormbolt:IsReady(unit, nil, nil, true) and A.Stormbolt:AbsentImun(unit, Temp.TotalAndPhysAndStun, true) and Unit(unit):IsControlAble("stun", 0) then
                return A.Stormbolt:Show(icon)                  
            end 
            
            -- Racials 
            if A.QuakingPalm:IsRacialReadyP(unit, nil, nil, true) then 
                return A.QuakingPalm:Show(icon)
            end 
            
            if A.Haymaker:IsRacialReadyP(unit, nil, nil, true) then 
                return A.Haymaker:Show(icon)
            end 
            
            if A.WarStomp:IsRacialReadyP(unit, nil, nil, true) then 
                return A.WarStomp:Show(icon)
            end 
            
            if A.BullRush:IsRacialReadyP(unit, nil, nil, true) then 
                return A.BullRush:Show(icon)
            end                         
        end 
    end                                                                                 
end]]

local function SelfDefensives()
    local HPLoosePerSecond = Unit("player"):GetDMG() * 100 / Unit("player"):HealthMax()
    if Unit(player):CombatTime() == 0 then 
        return 
    end 
    
    -- Rallying Cry
    local RallyingCry = A.GetToggle(2, "RallyingCry")
    if     RallyingCry >= 0 and A.RallyingCry:IsReady(player) and 
    (
        (     -- Auto 
            RallyingCry >= 100 and 
            (
                -- HP lose per sec >= 20
                Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 20 or 
                Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.20 or 
                -- TTD 
                Unit(player):TimeToDieX(25) < 5 or 
                (
                    A.IsInPvP and 
                    (
                        Unit(player):UseDeff() or 
                        (
                            Unit("player", 5):HasFlags() and 
                            Unit(player):GetRealTimeDMG() > 0 and 
                            Unit(player):IsFocused() 
                        )
                    )
                )
            ) and 
            Unit(player):HasBuffs("DeffBuffs", true) == 0
        ) 
        or 
        (    -- Custom
            RallyingCry < 100 and 
            Unit(player):HealthPercent() <= RallyingCry
        )
    ) 
    then 
        return A.RallyingCry
    end  
    
end 
SelfDefensives = A.MakeFunctionCachedStatic(SelfDefensives)

-- Non GCD spell check
local function countInterruptGCD(unit)
    if not A.Pummel:IsReadyByPassCastGCD(unit) or not A.Pummel:AbsentImun(unit, Temp.TotalAndMagKick) then
	    return true
	end
end

-- Interrupts spells
local function Interrupts(unit)
    if A.GetToggle(2, "TasteInterruptList") and (IsInRaid() or A.InstanceInfo.KeyStone > 1) then
	    useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, "TasteBFAContent", true, countInterruptGCD(unit))
	else
        useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, nil, nil, countInterruptGCD(unit))
    end
    
	if castRemainsTime >= A.GetLatency() then
        -- Pummel
        if useKick and A.Pummel:IsReady(unit) and A.Pummel:AbsentImun(unit, Temp.TotalAndPhysKick, true) and Unit(unit):CanInterrupt(true, nil, 25, 70) then 
            return A.Pummel
        end 
    
        -- Stormbolt
        if useCC and A.Stormbolt:IsReady(unit) and A.Stormbolt:AbsentImun(unit, Temp.TotalAndPhysAndCC, true) and Unit(unit):CanInterrupt(true, nil, 25, 70) and Unit(unit):IsControlAble("stun", 0) then
            return A.Stormbolt              
        end  
    
        -- IntimidatingShout
        if useCC and A.IntimidatingShout:IsReady(unit) and A.IntimidatingShout:AbsentImun(unit, Temp.TotalAndPhysAndCC, true) and Unit(unit):CanInterrupt(true, nil, 25, 70) and Unit(unit):IsControlAble("fear", 0) then 
            return A.IntimidatingShout              
        end  
		    
   	    if useRacial and A.QuakingPalm:AutoRacial(unit) then 
   	        return A.QuakingPalm
   	    end 
    
   	    if useRacial and A.Haymaker:AutoRacial(unit) then 
            return A.Haymaker
   	    end 
    
   	    if useRacial and A.WarStomp:AutoRacial(unit) then 
            return A.WarStomp
   	    end 
    
   	    if useRacial and A.BullRush:AutoRacial(unit) then 
            return A.BullRush
   	    end 
    end
end


--- ======= ACTION LISTS =======

A[3] = function(icon, isMulti)

	local function EnemyRotation()
		--    local Precombat, Execute, SingleUnit(unit)
	  --UpdateRanges()
	  --Everyone.AoEToggleEnemiesUpdate()
	  --UpdateExecuteID()
			--Precombat
			local function Precombat(unit)
			
				-- flask
				-- food
				-- augmentation
				-- snapshot_stats
				-- use_item,name=azsharas_font_of_power
				if A.AzsharasFontofPower:IsReady(unit) then
					return A.AzsharasFontofPower:Show(icon)
				end
				
				-- worldvein_resonance
				if A.WorldveinResonance:AutoHeartOfAzerothP(unit, true) and HeartOfAzeroth then
					return A.WorldveinResonance:Show(icon)
				end
				
				-- memory_of_lucid_dreams
				if A.MemoryofLucidDreams:AutoHeartOfAzerothP(unit, true) and HeartOfAzeroth then
					return A.MemoryofLucidDreams:Show(icon)
				end
				
				-- guardian_of_azeroth
				if A.GuardianofAzeroth:AutoHeartOfAzerothP(unit, true) and HeartOfAzeroth then
					return A.GuardianofAzeroth:Show(icon)
				end
				
				-- potion
				if A.PotionofSpectralStrength:IsReady(unit) and Potion then
					return A.PotionofSpectralStrength:Show(icon)
				end
				
			end
			
			--Execute
			local function Execute(unit)
			
				-- rend,if=remains<=duration*0.3
				if A.Rend:IsReady(unit) and Unit(unit):HasDeBuffs(A.RendDebuff.ID, true) <= 5 then
					return A.Rend:Show(icon)
				end
				
				-- deadly_calm
				if A.DeadlyCalm:IsReady("player") then
					return A.DeadlyCalm:Show(icon)
				end
				
				-- skullsplitter,if=rage<52&buff.memory_of_lucid_dreams.down|rage<20
				if A.Skullsplitter:IsReady(unit) and (Player:Rage() < 52 and Unit("player"):HasBuffs(A.MemoryofLucidDreams.ID, true) == 0 or Player:Rage() < 20) then
					return A.Skullsplitter:Show(icon)
				end
				
				-- ravager,,if=cooldown.colossus_smash.remains<2|(talent.warbreaker.enabled&cooldown.warbreaker.remains<2)
				if A.Ravager:IsReady("player") and BurstIsON(unit) and (A.ColossusSmash:GetCooldown() < 2 or (A.Warbreaker:IsTalentLearned() and A.Warbreaker:GetCooldown() < 2)) then
					return A.Ravager:Show(icon)
				end
				
				-- colossus_smash,if=!essence.memory_of_lucid_dreams.major|(buff.memory_of_lucid_dreams.up|cooldown.memory_of_lucid_dreams.remains>10)
				if A.ColossusSmash:IsReady(unit) and (not Azerite:EssenceHasMajor(A.MemoryofLucidDreams.ID) or (Unit("player"):HasBuffs(A.MemoryofLucidDreams.ID, true) > 0 or A.MemoryofLucidDreams:GetCooldown() > 10)) then
					return A.ColossusSmash:Show(icon)
				end
				
				-- warbreaker,if=!essence.memory_of_lucid_dreams.major|(buff.memory_of_lucid_dreams.up|cooldown.memory_of_lucid_dreams.remains>10)
				if A.Warbreaker:IsReady(unit) and A.BurstIsON(unit) and (not Azerite:EssenceHasMajor(A.MemoryofLucidDreams.ID) or (Unit("player"):HasBuffs(A.MemoryofLucidDreams.ID, true) > 0 or A.MemoryofLucidDreams:GetCooldown() > 10)) then
					return A.Warbreaker:Show(icon)
				end
				
				-- mortal_strike,if=dot.deep_wounds.remains<=duration*0.3&(spell_targets.whirlwind=1|!spell_targets.whirlwind>1&!talent.cleave.enabled)
				if A.MortalStrike:IsReady(unit) and Unit(unit):HasDeBuffs(A.DeepWoundsDebuff.ID, true) <= 4 and MultiUnits:GetByRange(8, 1) == 1 or (not MultiUnits:GetByRange(8, 2) > 1 and not A.Cleave:IsTalentLearned()) then
					return A.MortalStrike:Show(icon)
				end
				
				-- cleave,if=(spell_targets.whirlwind>2&dot.deep_wounds.remains<=duration*0.3)|(spell_targets.whirlwind>3)
				if A.Cleave:IsReady(unit) and (MultiUnits:GetByRange(8, 3) > 2 and Unit(unit):HasDeBuffs(A.DeepWoundsDebuff.ID, true) <= 4) or MultiUnits:GetByRange(8, 4) > 3 then
					return A.Cleave:Show(icon)
				end
				
				-- bladestorm,if=!buff.memory_of_lucid_dreams.up&buff.test_of_might.up&rage<30&!buff.deadly_calm.up
				if A.Bladestorm:IsReady("player") and A.BurstIsON(unit) and (Unit("player"):HasBuffs(A.MemoryofLucidDreams.ID, true) == 0 and Unit("player"):HasBuffs(A.TestofMightBuff.ID, true) > 0 and Player:Rage() < 30 and Unit("player"):HasBuffs(A.DeadlyCalmBuff.ID, true) == 0) then
					return A.Bladestorm:Show(icon)
				end
				
				-- execute,if=buff.memory_of_lucid_dreams.up|buff.deadly_calm.up|debuff.colossus_smash.up|buff.test_of_might.up
				if A.Execute:IsReady(unit) and (Unit("player"):HasBuffs(A.MemoryofLucidDreams.ID, true) > 0 or Unit("player"):HasBuffs(A.DeadlyCalmBuff.ID, true) > 0 or Unit(unit):HasDeBuffs(A.ColossusSmashDebuff.ID, true) > 0 or Unit("player"):HasBuffs(A.TestofMightBuff.ID, true) > 0) then
					return A.Execute:Show(icon)
				end
				
				-- slam,if=buff.crushing_assault.up&buff.memory_of_lucid_dreams.down
				if A.Slam:IsReady(unit) and (Unit("player"):HasBuffs(A.CrushingAssaultBuff.ID, true) > 0 and Unit("player"):HasBuffs(A.MemoryofLucidDreams.ID, true) == 0) then
					return A.Slam:Show(icon)
				end
				
				-- overpower
				if A.Overpower:IsReady(unit) then
					return A.Overpower:Show(icon)
				end
				
				-- execute
				if A.Execute:IsReady(unit) then
					return A.Execute:Show(icon)
				end
				
			end
			
			--SingleUnit(unit)
			local function SingleUnit(unit)
			
				-- rend,if=remains<=duration*0.3
				if A.Rend:IsReady(unit) and Unit(unit):HasDeBuffs(A.RendDebuff.ID, true) <= 5 then
					return A.Rend:Show(icon)
				end
				
				-- deadly_calm
				if A.DeadlyCalm:IsReady(unit) then
					return A.DeadlyCalm:Show(icon)
				end
				
				-- skullsplitter,if=rage<60&buff.deadly_calm.down&buff.memory_of_lucid_dreams.down|rage<20
				if A.Skullsplitter:IsReady(unit) and (Player:Rage() < 60 and Unit("player"):HasBuffs(A.DeadlyCalmBuff.ID, true) == 0 and Unit("player"):HasBuffs(A.MemoryofLucidDreams.ID, true) == 0 or Player:Rage() < 20) then
					return A.Skullsplitter:Show(icon)
				end
				
				-- ravager,if=(cooldown.colossus_smash.remains<2|(talent.warbreaker.enabled&cooldown.warbreaker.remains<2))
				if A.Ravager:IsReady("player") and BurstIsON(unit) and (A.ColossusSmash:GetCooldown() < 2 or (A.Warbreaker:IsTalentLearned() and A.Warbreaker:GetCooldown() < 2)) then
					return A.Ravager:Show(icon)
				end
				
				-- mortal_strike,if=dot.deep_wounds.remains<=duration*0.3&(spell_targets.whirlwind=1|!talent.cleave.enabled)
				if A.MortalStrike:IsReady(unit) and Unit(unit):HasDeBuffs(A.DeepWoundsDebuff.ID, true) <= 4 and (MultiUnits:GetByRange(8, 2) == 1 or not A.Cleave:IsTalentLearned()) then
					return A.MortalStrike:Show(icon)
				end
				
				-- cleave,if=spell_targets.whirlwind>2&dot.deep_wounds.remains<=duration*0.3
				if A.Cleave:IsReady(unit) and (MultiUnits:GetByRange(8, 3) > 2 and Unit(unit):HasDeBuffs(A.DeepWoundsDebuff.ID, true) <= 4) then
					return A.Cleave:Show(icon)
				end
				
				-- colossus_smash,if=!essence.condensed_lifeforce.enabled&!talent.massacre.enabled&(target.time_to_pct_20>10|target.time_to_die>50)|essence.condensed_lifeforce.enabled&!talent.massacre.enabled&(target.time_to_pct_20>10|target.time_to_die>80)|talent.massacre.enabled&(target.time_to_pct_35>10|target.time_to_die>50)
				if A.ColossusSmash:IsReady(unit) and (not A.CondensedLifeforce:IsTalentLearned() and not A.Massacre:IsTalentLearned() and (Unit(unit):HealthPercent() <= 25 or Unit(unit):TimeToDie() > 50) or A.CondensedLifeforce:IsTalentLearned() and not A.Massacre:IsTalentLearned() and (Unit(unit):HealthPercent() <= 25 or Unit(unit):TimeToDie() > 80) or A.Massacre:IsTalentLearned() and (Unit(unit):HealthPercent() <= 40 or Unit(unit):TimeToDie() > 50)) then
					return A.ColossusSmash:Show(icon)
				end
				
				-- warbreaker,if=!essence.condensed_lifeforce.enabled&!talent.massacre.enabled&(target.time_to_pct_20>10|target.time_to_die>50)|essence.condensed_lifeforce.enabled&!talent.massacre.enabled&(target.time_to_pct_20>10|target.time_to_die>80)|talent.massacre.enabled&(target.time_to_pct_35>10|target.time_to_die>50)
				if A.Warbreaker:IsReady(unit) and A.BurstIsON(unit) and (not A.CondensedLifeforce:IsTalentLearned() and not A.Massacre:IsTalentLearned() and (Unit(unit):HealthPercent() <= 25 or Unit(unit):TimeToDie() > 50) or A.CondensedLifeforce:IsTalentLearned() and not A.Massacre:IsTalentLearned() and (Unit(unit):HealthPercent() <= 25 or Unit(unit):TimeToDie() > 80) or A.Massacre:IsTalentLearned() and (Unit(unit):HealthPercent() <= 40 or Unit(unit):TimeToDie() > 50)) then
					return A.Warbreaker:Show(icon)
				end
				
				-- execute,if=buff.sudden_death.react
				if A.Execute:IsReady(unit) and (Unit("player"):HasBuffs(A.SuddenDeathBuff.ID, true) > 0) then
					return A.Execute:Show(icon)
				end
				
				-- bladestorm,if=cooldown.mortal_strike.remains&debuff.colossus_smash.down&(!talent.deadly_calm.enabled|buff.deadly_calm.down)&((debuff.colossus_smash.up&!azerite.test_of_might.enabled)|buff.test_of_might.up)&buff.memory_of_lucid_dreams.down&rage<40
				if A.Bladestorm:IsReady("player") and A.BurstIsON(unit) and (not A.MortalStrike:IsReady() and Unit(unit):HasDeBuffs(A.ColossusSmashDebuff.ID, true) == 0 and (not A.DeadlyCalm:IsTalentLearned() or Unit("player"):HasBuffs(A.DeadlyCalmBuff.ID, true) == 0) and ((Unit(unit):HasDeBuffs(A.ColossusSmashDebuff.ID, true) > 0 and not A.TestofMight:GetAzeriteRank() > 0) or Unit("player"):HasBuffs(A.TestofMightBuff.ID, true) > 0) and Unit("player"):HasBuffs(A.MemoryofLucidDreams.ID, true) == 0 and Player:Rage() < 40) then
					return A.Bladestorm:Show(icon)
				end
				
				-- mortal_strike,if=spell_targets.whirlwind=1|!talent.cleave.enabled
				if A.MortalStrike:IsReady(unit) and (MultiUnits:GetByRange(8, 2) == 1 or not A.Cleave:IsTalentLearned()) then
					return A.MortalStrike:Show(icon)
				end
				
				-- cleave,if=spell_targets.whirlwind>2
				if A.Cleave:IsReady(unit) and MultiUnits:GetByRange(8, 3) > 2 then
					return A.Cleave:Show(icon)
				end
				
				-- whirlwind,if=(((buff.memory_of_lucid_dreams.up)|(debuff.colossus_smash.up)|(buff.deadly_calm.up))&talent.fervor_of_battle.enabled)|((buff.memory_of_lucid_dreams.up|rage>89)&debuff.colossus_smash.up&buff.test_of_might.down&!talent.fervor_of_battle.enabled)
				if A.Whirlwind:IsReady(player) and ((((Unit("player"):HasBuffs(A.MemoryofLucidDreams.ID, true) > 0) or (Unit(unit):HasDeBuffs(A.ColossusSmashDebuff.ID, true) > 0) or (Unit("player"):HasBuffs(A.DeadlyCalmBuff.ID, true) > 0)) and A.FervorofBattle:IsTalentLearned()) or ((Unit("player"):HasBuffs(A.MemoryofLucidDreams.ID, true) > 0 or Player:Rage() > 89) and Unit(unit):HasDeBuffs(A.ColossusSmashDebuff.ID, true) > 0 and Unit("player"):HasBuffs(A.TestofMightBuff.ID, true) == 0 and not A.FervorofBattle:IsTalentLearned())) then
					return A.Whirlwind:Show(icon)
				end
				
				-- slam,if=!talent.fervor_of_battle.enabled&(buff.memory_of_lucid_dreams.up|debuff.colossus_smash.up)
				if A.Slam:IsReady(unit) and (not A.FervorofBattle:IsTalentLearned() and (Unit("player"):HasBuffs(A.MemoryofLucidDreams.ID, true) > 0 or Unit(unit):HasDeBuffs(A.ColossusSmashDebuff.ID, true) > 0)) then
					return A.Slam:Show(icon)
				end
				
				-- overpower
				if A.Overpower:IsReady(unit) then
					return A.Overpower:Show(icon)
				end
				
				-- whirlwind,if=talent.fervor_of_battle.enabled&(buff.test_of_might.up|debuff.colossus_smash.down&buff.test_of_might.down&rage>60)
				if A.Whirlwind:IsReady("player") and (A.FervorofBattle:IsTalentLearned() and (Unit("player"):HasBuffs(A.TestofMightBuff.ID, true) > 0 or Unit(unit):HasDeBuffs(A.ColossusSmashDebuff.ID, true) == 0 and Unit("player"):HasBuffs(A.TestofMightBuff.ID, true) == 0 and Player:Rage() > 60)) then
					return A.Whirlwind:Show(icon)
				end
				
				-- slam,if=!talent.fervor_of_battle.enabled
				if A.Slam:IsReady(unit) and (not A.FervorofBattle:IsTalentLearned()) then
					return A.Slam:Show(icon)
				end
				
			end
			
			
			-- call precombat
			if Precombat(unit) and not inCombat and Unit(unit):IsExists() and unit ~= "mouseover" then 
				return true
			end
			
			if Unit(unit):IsExists() then
				-- charge
				
				if A.Charge:IsReady(unit) then
					return A.Charge:Show(icon)
				end
				
				-- auto_attack
				-- blood_fury,if=buff.memory_of_lucid_dreams.remains<5|(!essence.memory_of_lucid_dreams.major&debuff.colossus_smash.up)
				if A.BloodFury:AutoRacial(unit) and Racial and A.BurstIsON(unit) and (Unit("player"):HasBuffs(A.MemoryofLucidDreams.ID, true) < 5 or (not Azerite:EssenceHasMajor(A.MemoryofLucidDreams.ID) and Unit(unit):HasDeBuffs(A.ColossusSmashDebuff.ID, true) > 0)) then
					return A.BloodFury:Show(icon)
				end
				
				-- berserking,if=buff.memory_of_lucid_dreams.up|(!essence.memory_of_lucid_dreams.major&debuff.colossus_smash.up)
				if A.Berserking:AutoRacial(unit) and Racial and A.BurstIsON(unit) and (Unit("player"):HasBuffs(A.MemoryofLucidDreams.ID, true) or (not Azerite:EssenceHasMajor(A.MemoryofLucidDreams.ID) and Unit(unit):HasDeBuffs(A.ColossusSmashDebuff.ID, true) > 0)) then
					return A.Berserking:Show(icon)
				end
				
				-- arcane_torrent,if=cooldown.mortal_strike.remains>1.5&buff.memory_of_lucid_dreams.down&rage<50
				if A.ArcaneTorrent:AutoRacial(unit) and Racial and A.BurstIsON(unit) and (A.MortalStrike:GetCooldown() > 1.5 and Unit("player"):HasBuffsDown(A.MemoryofLucidDreams.ID, true) and Player:Rage() < 50) then
					return A.ArcaneTorrent:Show(icon)
				end
				
				-- lights_judgment,if=debuff.colossus_smash.down&buff.memory_of_lucid_dreams.down&cooldown.mortal_strike.remains
				if A.LightsJudgment:IsReady(unit) and A.BurstIsON(unit) and (Unit(unit):HasDeBuffs(A.ColossusSmashDebuff.ID, true) == 0 and Unit("player"):HasBuffs(A.MemoryofLucidDreams.ID, true) == 0 and not A.MortalStrike:IsReady()) then
					return A.LightsJudgment:Show(icon)
				end
				
				-- fireblood,if=buff.memory_of_lucid_dreams.remains<5|(!essence.memory_of_lucid_dreams.major&debuff.colossus_smash.up)
				if A.Fireblood:AutoRacial(unit) and Racial and A.BurstIsON(unit) and (Unit("player"):HasBuffs(A.MemoryofLucidDreams.ID, true) < 5 or (not Azerite:EssenceHasMajor(A.MemoryofLucidDreams.ID) and Unit(unit):HasDeBuffs(A.ColossusSmashDebuff.ID, true) > 0)) then
					return A.Fireblood:Show(icon)
				end
				
				-- ancestral_call,if=buff.memory_of_lucid_dreams.remains<5|(!essence.memory_of_lucid_dreams.major&debuff.colossus_smash.up)
				if A.AncestralCall:AutoRacial(unit) and Racial and A.BurstIsON(unit) and (Unit("player"):HasBuffs(A.MemoryofLucidDreams.ID, true) < 5 or (not Azerite:EssenceHasMajor(A.MemoryofLucidDreams.ID) and Unit(unit):HasDeBuffs(A.ColossusSmashDebuff.ID, true) > 0)) then
					return A.AncestralCall:Show(icon)
				end
				
				-- bag_of_tricks,if=debuff.colossus_smash.down&buff.memory_of_lucid_dreams.down&cooldown.mortal_strike.remains
				if A.BagofTricks:IsReady(unit) and (Unit(unit):HasDeBuffs(A.ColossusSmashDebuff.ID, true) == 0 and Unit("player"):HasBuffsD(A.MemoryofLucidDreams.ID, true) == 0 and not A.MortalStrike:IsReady()) then
					return A.BagofTricks:Show(icon)
				end
				
				-- avatar,if=!essence.memory_of_lucid_dreams.major|(buff.memory_of_lucid_dreams.up|cooldown.memory_of_lucid_dreams.remains>45)
				if A.Avatar:IsReady("player") and A.BurstIsON(unit) and (not Azerite:EssenceHasMajor(A.MemoryofLucidDreams.ID) or (Unit("player"):HasBuffs(A.MemoryofLucidDreams.ID, true) > 0 or A.MemoryofLucidDreams:GetCooldown() > 45)) then
					return A.Avatar:Show(icon)
				end
				
				-- sweeping_strikes,if=spell_targets.whirlwind>1&(cooldown.bladestorm.remains>10|cooldown.colossus_smash.remains>8|azerite.test_of_might.enabled)
				if A.SweepingStrikes:IsReady("player") and MultiUnits:GetByRange(8, 2) > 1 and (A.Bladestorm:GetCooldown() > 10 or A.ColossusSmash:GetCooldown() > 8 or A.TestofMight:GetAzeriteRank() > 0) then
					return A.SweepingStrikes:Show(icon)
				end
				
				-- guardian_of_azeroth
				if A.GuardianofAzeroth:IsReady(unit) and A.BurstIsON(unit) then
					return A.Darkflight:Show(icon)
				end
				
				-- focused_azerite_beam
				if A.FocusedAzeriteBeam:IsReady(unit) and A.BurstIsON(unit) then
					return A.Darkflight:Show(icon)
				end
				
				-- memory_of_lucid_dreams
				if A.MemoryofLucidDreams:IsReady(unit) and A.BurstIsON(unit) then
					return A.Darkflight:Show(icon)
				end
				
				-- blood_of_the_enemy
				if A.BloodoftheEnemy:IsReady(unit) and A.BurstIsON(unit) then
					return A.Darkflight:Show(icon)
				end
				
				-- purifying_blast
				if A.PurifyingBlast:IsReady(unit) and A.BurstIsON(unit) then
					return A.Darkflight:Show(icon)
				end
				
				--[[ ripple_in_space
				if A.RippleInSpace:AutoHeartOfAzerothP(unit, true) and HeartOfAzeroth then
					return A.Darkflight:Show(icon)
				end]]
				
				-- concentrated_flame,line_cd=6
				if A.ConcentratedFlame:IsReady(unit) and A.BurstIsON(unit) then
					return A.Darkflight:Show(icon)
				end
				
				-- reaping_flames
				if A.ReapingFlames:IsReady(unit) and A.BurstIsON(unit) then
					return A.Darkflight:Show(icon)
				end
				
				-- run_action_list,name=execute,if=(talent.massacre.enabled&target.health.pct<35)|target.health.pct<20
				if ((A.Massacre:IsTalentLearned() and Unit(unit):HealthPercent() < 35) or Unit(unit):HealthPercent() < 20) then
					return Execute(unit)
				else
				-- run_action_list,name=single_target
					return SingleUnit(unit)
				end
			end
	end		

    -- End on EnemyRotation()

    -- Defensive
    --local SelfDefensive = SelfDefensives()
    if SelfDefensive then 
        return SelfDefensive:Show(icon)
    end 

    -- Mouseover
    if A.IsUnitEnemy("mouseover") then
        unit = "mouseover"
        if EnemyRotation(unit) then 
            return true 
        end 
    end 

    -- Target  
    if A.IsUnitEnemy("target") then 
        unit = "target"
        if EnemyRotation(unit) then 
            return true
        end 

    end
end
-- Finished

-- [4] AoE Rotation
A[4] = function(icon)
    return A[3](icon, true)
end
 -- [5] Trinket Rotation
-- No specialization trinket actions 
-- Passive 
--[[local function FreezingTrapUsedByEnemy()
    if     UnitCooldown:GetCooldown("arena", 3355) > UnitCooldown:GetMaxDuration("arena", 3355) - 2 and
    UnitCooldown:IsSpellInFly("arena", 3355) and 
    Unit("player"):GetDR("incapacitate") >= 50 
    then 
        local Caster = UnitCooldown:GetUnitID("arena", 3355)
        if Caster and Unit(Caster):GetRange() <= 40 then 
            return true 
        end 
    end 
end 
local function ArenaRotation(icon, unit)
    if A.IsInPvP and (A.Zone == "pvp" or A.Zone == "arena") and not Player:IsStealthed() and not Player:IsMounted() then
        -- Note: "arena1" is just identification of meta 6
        if (unit == "arena1" or unit == "arena2" or unit == "arena3") then 
            -- Reflect Casting BreakAble CC
            if A.NetherWard:IsReady() and A.NetherWard:IsTalentLearned() and Action.ShouldReflect(EnemyTeam()) and EnemyTeam():IsCastingBreakAble(0.25) then 
                return A.NetherWard:Show(icon)
            end 
        end
    end 
end 
local function PartyRotation(unit)
    if (unit == "party1" and not A.GetToggle(2, "PartyUnits")[1]) or (unit == "party2" and not A.GetToggle(2, "PartyUnits")[2]) then 
        return false 
    end

  	-- SingeMagic
    if A.SingeMagic:IsCastable() and A.SingeMagic:AbsentImun(unit, Temp.TotalAndMag) and IsSchoolFree() and Action.AuraIsValid(unit, "UseDispel", "Magic") and not Unit(unit):InLOS() then
        return A.SingeMagic:Show(icon)
    end
end 

A[6] = function(icon)
    return ArenaRotation(icon, "arena1")
end

A[7] = function(icon)
    local Party = PartyRotation("party1") 
    if Party then 
        return Party:Show(icon)
    end 
    return ArenaRotation(icon, "arena2")
end

A[8] = function(icon)
    local Party = PartyRotation("party2") 
    if Party then 
        return Party:Show(icon)
    end     
    return ArenaRotation(icon, "arena3")
end]]--
