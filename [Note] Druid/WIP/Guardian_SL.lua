-------------------------------
-- Note TMW Action Rotation --
--      Version 1.0.0       --
-------------------------------
local _G, setmetatable							= _G, setmetatable
local A                         			    = _G.Action
local Listener									= Action.Listener
local Create									= Action.Create
local GetToggle									= Action.GetToggle
local SetToggle									= Action.SetToggle
local GetGCD									= Action.GetGCD
local GetCurrentGCD								= Action.GetCurrentGCD
local GetPing									= Action.GetPing
local ShouldStop								= Action.ShouldStop
local BurstIsON									= Action.BurstIsON
local AuraIsValid								= Action.AuraIsValid
local AuraIsValidByPhialofSerenity              = A.AuraIsValidByPhialofSerenity
local InterruptIsValid							= Action.InterruptIsValid
local FrameHasSpell								= Action.FrameHasSpell
local Utils										= Action.Utils
local TeamCache									= Action.TeamCache
local EnemyTeam									= Action.EnemyTeam
local FriendlyTeam								= Action.FriendlyTeam
local LoC										= Action.LossOfControl
local Player									= Action.Player 
local MultiUnits								= Action.MultiUnits
local UnitCooldown								= Action.UnitCooldown
local Unit										= Action.Unit 
local IsUnitEnemy								= Action.IsUnitEnemy
local IsUnitFriendly							= Action.IsUnitFriendly
local ActiveUnitPlates							= MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit                     = IsIndoors, UnitIsUnit
local TR                                        = Action.TasteRotation
local pairs                                     = pairs
local Pet                                       = LibStub("PetLibrary")
local next, pairs, type, print                  = next, pairs, type, print
local wipe                                      = wipe 
local math_floor                                = math.floor
local math_ceil                                 = math.ceil
local tinsert                                   = table.insert 
local TMW                                       = TMW
local _G, setmetatable                          = _G, setmetatable
local select, unpack, table, pairs              = select, unpack, table, pairs 
local CombatLogGetCurrentEventInfo              = _G.CombatLogGetCurrentEventInfo
local UnitGUID, UnitIsUnit, UnitDamage, UnitAttackSpeed, UnitAttackPower = UnitGUID, UnitIsUnit, UnitDamage, UnitAttackSpeed, UnitAttackPower

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999
-- Spells
Action[ACTION_CONST_DRUID_GUARDIAN] = {
    -- Racial
    ArcaneTorrent                          = Action.Create({ Type = "Spell", ID = 50613     }),
    BloodFury                              = Action.Create({ Type = "Spell", ID = 20572      }),
    Fireblood                              = Action.Create({ Type = "Spell", ID = 265221     }),
    AncestralCall                          = Action.Create({ Type = "Spell", ID = 274738     }),
    Berserking                             = Action.Create({ Type = "Spell", ID = 26297    }),
    ArcanePulse                            = Action.Create({ Type = "Spell", ID = 260364    }),
    QuakingPalm                            = Action.Create({ Type = "Spell", ID = 107079     }),
    Haymaker                               = Action.Create({ Type = "Spell", ID = 287712     }), 
    WarStomp                               = Action.Create({ Type = "Spell", ID = 20549     }),
    BullRush                               = Action.Create({ Type = "Spell", ID = 255654     }),  
    GiftofNaaru                            = Action.Create({ Type = "Spell", ID = 59544    }),
    Shadowmeld                             = Action.Create({ Type = "Spell", ID = 58984    }), -- usable in Action Core 
    Stoneform                              = Action.Create({ Type = "Spell", ID = 20594    }), 
    BagofTricks                            = Action.Create({ Type = "Spell", ID = 312411    }),
    WilloftheForsaken                      = Action.Create({ Type = "Spell", ID = 7744        }), -- not usable in APL but user can Queue it   
    EscapeArtist                           = Action.Create({ Type = "Spell", ID = 20589    }), -- not usable in APL but user can Queue it
    EveryManforHimself                     = Action.Create({ Type = "Spell", ID = 59752    }), -- not usable in APL but user can Queue it
    -- Generics
    BearFormBuff                           = Action.Create({ Type = "Spell", ID = 5487, Hidden = true }),
    BearForm                               = Action.Create({ Type = "Spell", ID = 5487 }),
    CatForm                                = Action.Create({ Type = "Spell", ID = 768     }),
    HeartEssence                           = Action.Create({ Type = "Spell", ID = 298554 }),
    LightsJudgment                         = Action.Create({ Type = "Spell", ID = 255647 }),
    Barkskin                               = Action.Create({ Type = "Spell", ID = 22812 }),
    BristlingFur                           = Action.Create({ Type = "Spell", ID = 155835 }),
    Incarnation                            = Action.Create({ Type = "Spell", ID = 102558 }),
    MoonfireDebuff                         = Action.Create({ Type = "Spell", ID = 164812 }),
    IncarnationBuff                        = Action.Create({ Type = "Spell", ID = 102558, Hidden = true }),
    ThrashBearDebuff                       = Action.Create({ Type = "Spell", ID = 192090 }),
    Maul                                   = Action.Create({ Type = "Spell", ID = 6807 }),
    Ironfur                                = Action.Create({ Type = "Spell", ID = 192081 }),
    LayeredMane                            = Action.Create({ Type = "Spell", ID = 279552 }),
    Pulverize                              = Action.Create({ Type = "Spell", ID = 80313 }),
    Moonfire                               = Action.Create({ Type = "Spell", ID = 8921 }),
    ThrashCat                              = Action.Create({ Type = "Spell", ID = 106830 }),
    ThrashBear                             = Action.Create({ Type = "Spell", ID = 77758 }),
    SwipeCat                               = Action.Create({ Type = "Spell", ID = 106785 }),
    SwipeBear                              = Action.Create({ Type = "Spell", ID = 213771 }),
    Mangle                                 = Action.Create({ Type = "Spell", ID = 33917 }),
    BalanceAffinity                       = Action.Create({ Type = "Spell", ID = 197488     }),
    WildChargeTalent                      = Action.Create({ Type = "Spell", ID = 102401     }),
    WildChargeBear                        = Action.Create({ Type = "Spell", ID = 16979     }),
    SurvivalInstincts                     = Action.Create({ Type = "Spell", ID = 61336     }),
    SkullBash                             = Action.Create({ Type = "Spell", ID = 106839     }),
	Berserk                               = Action.Create({ Type = "Spell", ID = 50334      }),
	-- Utilities
	Typhoon                               = Action.Create({ Type = "Spell", ID = 132469 }),
	MightyBash                            = Action.Create({ Type = "Spell", ID = 5211   }),
	IncapacitatingRoar                    = Action.Create({ Type = "Spell", ID = 99  }),
	Soothe                                = Action.Create({ Type = "Spell", ID = 2908   }),
	Growl                                 = Action.Create({ Type = "Spell", ID = 6795   }),
	StampedingRoar                        = Action.Create({ Type = "Spell", ID = 77761   }),
	Rebirth                               = Action.Create({ Type = "Spell", ID = 20484     }),  -- Combat Rez
    -- Defensive
	SurvivalInstincts                     = Action.Create({ Type = "Spell", ID = 61336   }),
	FrenziedRegeneration                  = Action.Create({ Type = "Spell", ID = 22842, predictName = "FrenziedRegeneration"   }),
	Renewal                               = Action.Create({ Type = "Spell", ID = 108238   }),
    -- Buffs
    IronfurBuff                            = Action.Create({ Type = "Spell", ID = 192081, Hidden = true }),
    PulverizeBuff                         = Action.Create({ Type = "Spell", ID = 158792, Hidden = true     }),
    IncarnationBuff                       = Action.Create({ Type = "Spell", ID = 102558, Hidden = true     }),
    GalacticGuardianBuff                  = Action.Create({ Type = "Spell", ID = 213708, Hidden = true     }),
    SharpenedClawsBuff                    = Action.Create({ Type = "Spell", ID = 279943, Hidden = true     }),
	ToothandClaw                          = Action.Create({ Type = "Spell", ID = 135286, Hidden = true     }), -- Talent
	-- Debuffs 
    ThrashBearDebuff                      = Action.Create({ Type = "Spell", ID = 192090, Hidden = true     }),
    MoonfireDebuff                        = Action.Create({ Type = "Spell", ID = 164812, Hidden = true     }), 
    -- Potions
	PhialOfSerenity                        = Action.Create({ Type = "Potion", ID = 177278, QueueForbidden = true }), -- Kyrian, dispel, HP pot
	PotionofSpectralAgility                = Action.Create ({ Type = "Potion", ID = 307093, QueueForbidden = true }),
	PotonofDeathlyFixation                 = Action.Create ({ Type = "Potion", ID = 307384, QueueForbidden = true }),
	PotionofEmpoweredExorcisms             = Action.Create ({ Type = "Potion", ID = 307381, QueueForbidden = true }),
	PotionofPhantomFire                    = Action.Create ({ Type = "Potion", ID = 307382, QueueForbidden = true }),
	PotionofSacrificialAnima               = Action.Create ({ Type = "Potion", ID = 322301, QueueForbidden = true }),
	PotionofDivineAwakening                = Action.Create ({ Type = "Potion", ID = 307383, QueueForbidden = true }),
	SpiritualHealingPotion                 = Action.Create({ Type = "Potion", ID = 171267, QueueForbidden = true }),     
    -- Trinkets
	-- Generic Covenants
	Fleshcraft                             = Action.Create({ Type = "Spell", ID = 324631 }),
	SummonSteward                          = Action.Create({ Type = "Spell", ID = 324739 }),
	DoorOfShadows                          = Action.Create({ Type = "Spell", ID = 300728 }),
	SoulShape                              = Action.Create({ Type = "Spell", ID = 310143 }),
	-- Covenants
	AdaptiveSwarm                          = Action.Create({ Type = "Spell", ID = 325727 }),
	KindredSpirits                         = Action.Create({ Type = "Spell", ID = 326434 }),
	RavenousFrenzy                         = Action.Create({ Type = "Spell", ID = 323546 }),
	ConvokeTheSpirit                       = Action.Create({ Type = "Spell", ID = 323764 }),
	-- Generic Legendaries
	DraughtOfDeepFocus                     = Action.Create({ Type = "Spell", ID = 338658 }),
	CircleOfLifeAndDeath                   = Action.Create({ Type = "Spell", ID = 338657 }),
	LycarasFleetingGlimpse                 = Action.Create({ Type = "Spell", ID = 340059 }),
	OathOfTheElderDruid                    = Action.Create({ Type = "Spell", ID = 338608 }),
	-- Guardian Legendaries
	TheNaturalOrdersWill                   = Action.Create({ Type = "Spell", ID = 339063 }),
	UrsocsFuryRemembered                   = Action.Create({ Type = "Spell", ID = 339056 }),
	LuffaInfusedEmbrace                    = Action.Create({ Type = "Spell", ID = 339060 }),
	LegacyOfTheSleeper                     = Action.Create({ Type = "Spell", ID = 339062 }),
	-- Conduits
    -- Misc
    Channeling                             = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),	-- Show an icon during channeling
    TargetEnemy                            = Action.Create({ Type = "Spell", ID = 44603, Hidden = true     }),	-- Change Target (Tab button)
    StopCast                               = Action.Create({ Type = "Spell", ID = 61721, Hidden = true     }),		-- spell_magic_polymorphrabbit
};

-- To create essences use next code:
Action:CreateEssencesFor(ACTION_CONST_DRUID_GUARDIAN)  -- where PLAYERSPEC is Constance (example: ACTION_CONST_MONK_BM)
local A = setmetatable(Action[ACTION_CONST_DRUID_GUARDIAN], { __index = Action })

local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end

local IsIndoors, UnitIsUnit, UnitName = IsIndoors, UnitIsUnit, UnitName
local player = "player"

------------------------------------------
-------------- COMMON PREAPL -------------
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
	BigDeff                                 = {A.SurvivalInstincts.ID},
}

local IsIndoors, UnitIsUnit, UnitName = IsIndoors, UnitIsUnit, UnitName
local player = "player"

local function IsSchoolFree()
	return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "SHADOW") == 0
end 

local function GetStance()
    -- @return number (1 - Bear, 2 - Cat, 3 - Travel)
    return Player:GetStance()
end 

local function Swipe()
  if Unit("player"):HasBuffs(A.CatForm.ID, true) > 0 then
    return A.SwipeCat
  else
    return A.SwipeBear
  end
end

local function Thrash()
  if Unit("player"):HasBuffs(A.CatForm.ID, true) > 0 then
    return A.ThrashCat
  else
    return A.ThrashBear
  end
end


-- SelfDefensives
local function SelfDefensives()
    local HPLoosePerSecond = math.max((Unit(player):GetDMG() * 100 / Unit(player):HealthMax()) - (Unit(player):GetHEAL() * 100 / Unit(player):HealthMax()), 0)

	
    if Unit(player):CombatTime() == 0 then 
        return 
    end 
			
    -- Ironfur (any role, whenever have physical damage)
	local IronfurHPLost = GetToggle(2, "IronfurHPLost")
	local IsTanking = Unit(player):IsTanking("target", 8) or Unit(player):IsTankingAoE(8)
    if Player:Rage() >= A.Ironfur:GetSpellPowerCost() and A.Ironfur:IsReady(player) and 
	(
	    HPLoosePerSecond >= IronfurHPLost
		or
        Unit(player):HealthPercent() < 99 and IsTanking
	)
	then 
        return A.Ironfur
    end 

    -- Emergency FrenziedRegeneration
    local FrenziedRegeneration = Action.GetToggle(2, "FrenziedRegenerationHP")
    if     FrenziedRegeneration >= 0 and A.FrenziedRegeneration:IsReady("player") and Unit("player"):HasBuffs(A.FrenziedRegeneration.ID, true) == 0 and
    (
        (   -- Auto 
            FrenziedRegeneration >= 100 and 
            (
                -- HP lose per sec >= 5
                Unit("player"):GetDMG() * 100 / Unit("player"):HealthMax() >= 15 or 
                Unit("player"):GetRealTimeDMG() >= Unit("player"):HealthMax() * 0.15 or 
                -- TTD 
                Unit("player"):TimeToDieX(25) < 5 or 
				-- Custom logic with current HPS and DMG
				Unit("player"):HealthPercent() <= 85 or
	    		Unit("player"):GetHEAL() * 2 < Unit("player"):GetDMG() or
                (
                    A.IsInPvP and 
                    (
                        Unit("player"):UseDeff() or 
                        (
                            Unit("player", 5):HasFlags() and 
                            Unit("player"):GetRealTimeDMG() > 0 and 
                            Unit("player"):IsFocused() 
                        )
                    )
                )
            ) 
        ) or 
        (    -- Custom
            FrenziedRegeneration < 100 and 
            Unit("player"):HealthPercent() <= FrenziedRegeneration
        )
    ) 
    then 
        return A.FrenziedRegeneration
    end 
	
	    -- Emergency Renewal
    local Renewal = Action.GetToggle(2, "RenewalHP")
    if     Renewal >= 0 and A.Renewal:IsReady("player") and Unit("player"):HasBuffs(A.Renewal.ID, true) == 0 and
    (
        (   -- Auto 
            Renewal >= 100 and 
            (
                -- HP lose per sec >= 5
                Unit("player"):GetDMG() * 100 / Unit("player"):HealthMax() >= 15 or 
                Unit("player"):GetRealTimeDMG() >= Unit("player"):HealthMax() * 0.15 or 
                -- TTD 
                Unit("player"):TimeToDieX(25) < 5 or 
				-- Custom logic with current HPS and DMG
				Unit("player"):HealthPercent() <= 85 or
	    		Unit("player"):GetHEAL() * 2 < Unit("player"):GetDMG() or
                (
                    A.IsInPvP and 
                    (
                        Unit("player"):UseDeff() or 
                        (
                            Unit("player", 5):HasFlags() and 
                            Unit("player"):GetRealTimeDMG() > 0 and 
                            Unit("player"):IsFocused() 
                        )
                    )
                )
            ) 
        ) or 
        (    -- Custom
            Renewal < 100 and 
            Unit("player"):HealthPercent() <= Renewal
        )
    ) 
    then 
        return A.Renewal
    end 
			
    -- SurvivalInstincts
    if A.SurvivalInstincts:IsReadyByPassCastGCD(player) then 
        local SI_HP                 = A.GetToggle(2, "SurvivalInstinctsHP")
        local SI_TTD                = A.GetToggle(2, "SurvivalInstinctsTTD")
            
        if  (    
                ( SI_HP     >= 0     or SI_TTD                              >= 0                                        ) and 
                ( SI_HP     <= 0     or Unit(player):HealthPercent()     <= SI_HP                                    ) and 
                ( SI_TTD     <= 0     or Unit(player):TimeToDie()         <= SI_TTD      )  
            ) 
			or 
            (
                A.GetToggle(2, "SurvivalInstinctsCatchKillStrike") and 
                (
                    ( Unit(player):GetDMG()         >= Unit(player):Health() and Unit(player):HealthPercent() <= 20 ) or 
                    Unit(player):GetRealTimeDMG() >= Unit(player):Health() or 
                    Unit(player):TimeToDie()         <= A.GetGCD() + A.GetCurrentGCD()
                )
            )                
        then
            -- Ironfur
            if A.Ironfur:IsReadyByPassCastGCD(player) and Player:Rage() >= A.Ironfur:GetSpellPowerCostCache() and Unit(player):HasBuffs(A.IronfurBuff.ID, true) == 0 and Unit(player):HasBuffs(A.SurvivalInstincts.ID, true) == 0 then  
                return A.Ironfur        -- #4
            end 
                
            -- SurvivalInstincts
            return A.SurvivalInstincts         -- #3                  
             
        end 
    end

    -- Barkskin	
    if A.Barkskin:IsReadyByPassCastGCD(player) and (not A.GetToggle(2, "BarkskinIgnoreBigDeff") or Unit(player):HasBuffs(Temp.BigDeff, true) == 0) then 
        local BS_HP                 = A.GetToggle(2, "BarkskinHP")
        local BS_TTD                = A.GetToggle(2, "BarkskinTTD")
            
        if  (    
                ( BS_HP     >= 0     or BS_TTD                              >= 0                                     ) and 
                ( BS_HP     <= 0     or Unit(player):HealthPercent()     <= BS_HP                                    ) and 
                ( BS_TTD    <= 0     or Unit(player):TimeToDie()         <= BS_TTD                                   ) 
            ) 
		    or 
            (
                A.GetToggle(2, "BarkskinCatchKillStrike") and 
                (
                    ( Unit(player):GetDMG()         >= Unit(player):Health() and Unit(player):HealthPercent() <= 20 ) or 
                    Unit(player):GetRealTimeDMG() >= Unit(player):Health() or 
                    Unit(player):TimeToDie()         <= A.GetGCD()
                )
            )                
        then                
            return A.Barkskin
        end 
    end 
	
	-- PhialOfSerenity
    local PhialOfSerenity = A.GetToggle(2, "PhialOfSerenityHP")
    if PhialOfSerenity >= 0 and A.PhialOfSerenity:IsReady(player) and 
    (
        (     -- Auto 
            PhialOfSerenity >= 100 and 
            (
                -- HP lose per sec >= 20
                Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 10 or 
                Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.10 or 
                -- TTD 
                Unit(player):TimeToDieX(20) < 5 or 
                (
                    A.IsInPvP and 
                    (
                        Unit(player):UseDeff() or 
                        (
                            Unit(player, 5):HasFlags() and 
                            Unit(player):GetRealTimeDMG() > 0 and 
                            Unit(player):IsFocused() 
                        )
                    )
                )
            ) and 
            Unit(player):HasBuffs("DeffBuffs", true) == 0
        ) or 
        (    -- Custom
            PhialOfSerenity < 100 and 
            Unit(player):HealthPercent() <= PhialOfSerenity
        )
    ) 
    then 
        return A.PhialOfSerenity
    end 		

	-- SpiritualHealingPotionHP
    local SpiritualHealingPotion = A.GetToggle(2, "SpiritualHealingPotionHP")
    if SpiritualHealingPotion >= 0 and A.SpiritualHealingPotion:IsReady(player) and 
    (
        (     -- Auto 
            SpiritualHealingPotion >= 100 and 
            (
                -- HP lose per sec >= 20
                Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 10 or 
                Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.10 or 
                -- TTD 
                Unit(player):TimeToDieX(20) < 5 or 
                (
                    A.IsInPvP and 
                    (
                        Unit(player):UseDeff() or 
                        (
                            Unit(player, 5):HasFlags() and 
                            Unit(player):GetRealTimeDMG() > 0 and 
                            Unit(player):IsFocused() 
                        )
                    )
                )
            ) and 
            Unit(player):HasBuffs("DeffBuffs", true) == 0
        ) or 
        (    -- Custom
            SpiritualHealingPotion < 100 and 
            Unit(player):HealthPercent() <= SpiritualHealingPotion
        )
    ) 
    then 
        return A.SpiritualHealingPotion
    end 	

end 
SelfDefensives = A.MakeFunctionCachedDynamic(SelfDefensives)

-- Non GCD spell check
local function countInterruptGCD(unit)
    if not A.SkullBash:IsReadyByPassCastGCD(unit) or not A.SkullBash:AbsentImun(unit, Temp.TotalAndMagKick) then
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
    local EnemiesCasting = MultiUnits:GetByRangeCasting(10, 5, true, "TargetMouseover")
	
	if castRemainsTime >= A.GetLatency() then
        if useKick and A.SkullBash:IsReady(unit) and A.SkullBash:AbsentImun(unit, Temp.TotalAndPhysKick, true) then 
            -- Notification                    
            Action.SendNotification("Skull Bash interrupting on " .. unit, A.SkullBash.ID)
            return A.SkullBash
        end         

        if useCC and A.MightyBash:IsReady(unit) and A.MightyBash:IsSpellLearned() and A.MightyBash:AbsentImun(unit, Temp.TotalAndPhysKick, true) then 
            -- Notification                    
            Action.SendNotification("Mighty Bash interrupting on " .. unit, A.MightyBash.ID)
            return A.MightyBash
        end  

 	     -- IncapacitatingRoar
   	    if useCC and EnemiesCasting >= 3 and (not A.MightyBash:IsSpellLearned() or not A.MightyBash:IsReady(unit)) and A.IncapacitatingRoar:IsReady(unit) then 
   	        return A.IncapacitatingRoar
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
Interrupts = A.MakeFunctionCachedDynamic(Interrupts)

-- Multidot Handler UI --
local function HandleMultidots()
    local choice = Action.GetToggle(2, "AutoDotSelection")
       
    if choice == "In Raid" then
		if IsInRaid() then
    		return true
		else
		    return false
		end
    elseif choice == "In Dungeon" then 
		if IsInGroup() then
    		return true
		else
		    return false
		end
	elseif choice == "In PvP" then 	
		if A.IsInPvP then 
    		return true
		else
		    return false
		end		
    elseif choice == "Everywhere" then 
        return true
    else
		return false
    end
	--print(choice)
end

local function EvaluateCycleMoonfire118(unit)
    return Unit(unit):HasDeBuffsRefreshable(A.MoonfireDebuff.ID, true) and MultiUnits:GetByRange(40, 5, 10) < 2
end

local function EvaluateCycleMoonfire167(unit)
    return Unit("player"):HasBuffs(A.GalacticGuardianBuff.ID, true) and MultiUnits:GetByRange(40, 5, 10) < 2
end

--- ======= ACTION LISTS =======
-- [3] Single Rotation
A[3] = function(icon, isMulti)
    --------------------
    --- ROTATION VAR ---
    --------------------
    local isMoving = A.Player:IsMoving()
	local isMovingFor = A.Player:IsMovingTime()
    local inCombat = Unit("player"):CombatTime() > 0
    local combatTime = Unit("player"):CombatTime()
    local inStance = GetStance()
    local ShouldStop = Action.ShouldStop()
    local Pull = Action.BossMods:GetPullTimer()
    local ActiveMitigationNeeded = Player:ActiveMitigationNeeded()
	local IsTanking = Unit("player"):IsTanking("target", 8) or Unit("player"):IsTankingAoE(8)
	local HPLoosePerSecond = Unit("player"):GetDMG() * 100 / Unit("player"):HealthMax()
	local Thrash = Thrash()
	local Swipe = Swipe()
	local targetThreatSituation, targetThreatPercent = Unit("player"):ThreatSituation()
	local threatDamagerLimit = (A.Role == "DAMAGER" and A.GetToggle(2, "ThreatDamagerLimit")) or -1
    local isSafestThreatRotation = not A.IsInPvP and A.Zone ~= "none" and A.TeamCache.Friendly.Size > 1 and threatDamagerLimit ~= -1 and targetThreatPercent >= threatDamagerLimit
	-- Multidots var
	local MultiDotDistance = A.GetToggle(2, "MultiDotDistance")
	local MissingMoonfire = MultiUnits:GetByRangeMissedDoTs(20, 5, A.Moonfire.ID)	
	local CanMultidot = HandleMultidots()
	
    ------------------------------------------------------
    ---------------- ENEMY UNIT ROTATION -----------------
    ------------------------------------------------------
	local function EnemyRotation(unit)
        
		--Precombat
        local function Precombat(unit)
            -- flask
            -- food
            -- augmentation
            -- snapshot_stats
            -- bear_form
            if A.BearForm:IsReady(unit) and inStance ~= 1 then
                return A.BearForm:Show(icon)
            end
            -- potion
            if A.SuperiorSteelskinPotion:IsReady(unit) and Action.GetToggle(1, "Potion") 
			and (Pull > 0 and Pull <= 2 or not A.GetToggle(1 ,"DBM"))
			then
                return A.SuperiorSteelskinPotion:Show(icon)
            end
            -- thrash,if=(buff.incarnation.down&active_enemies>1)|(buff.incarnation.up&active_enemies>4)
            if Thrash:IsReady("player") and MultiUnits:GetByRange(8) > 1 
			and (Pull > 0 and Pull <= 2 or not A.GetToggle(1 ,"DBM"))
			then
                return Thrash:Show(icon)
            end		
			-- Moonfire
            if A.Moonfire:IsReady(unit) and Unit(unit):GetRange() > 8 and Unit(unit):GetRange() <= 40 and Unit(unit):HasDeBuffs(A.MoonfireDebuff.ID, true) == 0 
			and (Pull > 0 and Pull <= 2 or not A.GetToggle(1 ,"DBM"))
			then
                return A.Moonfire:Show(icon) 
            end			
        end
        
        --Cooldowns
        local function Cooldowns(unit)
            -- potion
            if A.SuperiorSteelskinPotion:IsReady(unit) and Action.GetToggle(1, "Potion") and (ActiveMitigationNeeded or HPLoosePerSecond > 15) then
                return A.SuperiorSteelskinPotion:Show(icon)
            end
						
            -- blood_fury
            if A.BloodFury:AutoRacial(unit) and Action.GetToggle(1, "Racial") and A.BurstIsON(unit) then
                return A.BloodFury:Show(icon)
            end
			
            -- berserking
            if A.Berserking:AutoRacial(unit) and Action.GetToggle(1, "Racial") and A.BurstIsON(unit) then
                return A.Berserking:Show(icon)
            end
			
            -- arcane_torrent
            if A.ArcaneTorrent:IsRacialReady(unit) and Action.GetToggle(1, "Racial") and A.BurstIsON(unit) then
                return A.ArcaneTorrent:Show(icon)
            end
			
            -- lights_judgment
            if A.LightsJudgment:IsReady(unit) and A.BurstIsON(unit) then
                return A.LightsJudgment:Show(icon)
            end
			
            -- fireblood
            if A.Fireblood:AutoRacial(unit) and Action.GetToggle(1, "Racial") and A.BurstIsON(unit) then
                return A.Fireblood:Show(icon)
            end
			
            -- ancestral_call
            if A.AncestralCall:AutoRacial(unit) and Action.GetToggle(1, "Racial") and A.BurstIsON(unit) then
                return A.AncestralCall:Show(icon)
            end
			
            -- bristling_fur,if=buff.bear_form.up
            if A.BristlingFur:IsReady(unit) and Unit("player"):HasBuffs(A.BearFormBuff.ID, true) and Player:Rage() < Action.GetToggle(2, "BristlingFurRage") then
                return A.BristlingFur:Show(icon)
            end
			
            -- incarnation,if=(dot.moonfire.ticking|active_enemies>1)&dot.thrash_bear.ticking
            if A.Incarnation:IsReady(unit) and ((Unit(unit):HasDeBuffs(A.MoonfireDebuff.ID, true) or MultiUnits:GetByRange(30) > 1) and Unit(unit):HasDeBuffs(A.ThrashBearDebuff.ID, true)) then
                return A.Incarnation:Show(icon)
            end
			
			-- berserk,if=buff.bear_form.up,burstON
			if A.Berserk:IsReady(unit) and ((Unit(unit):HasDeBuffs(A.MoonfireDebuff.ID, true) or MultiUnits:GetByRange(30) > 1) and Unit(unit):HasDeBuffs(A.ThrashBearDebuff.ID, true)) then
				return A.Berserk:Show(icon)
			end
			
			-- venthyr,if=buff.bear_form.up,burstON
			if A.RavenousFrenzy:IsReady(unit) and ((Unit(unit):HasDeBuffs(A.MoonfireDebuff.ID, true) or MultiUnits:GetByRange(30) > 1) and Unit(unit):HasDeBuffs(A.ThrashBearDebuff.ID, true)) then
				return A.RavenousFrenzy:Show(icon)
			end
			
			-- necrolord, if=buff.bear_form.up,burstON,(dot.adaptiveswarm.ticking|active_enemies>1)
			if A.AdaptiveSwarm:IsReady(unit) and A.BurstIsON(unit) and not (Unit(unit):HasDeBuffs(A.AdaptiveSwarm.ID, true)) then
				return A.AdaptiveSwarm:Show(icon)
			end
			
            -- use_items
        end
        
        
        -- call precombat
        if Precombat(unit) and not inCombat and Unit(unit):IsExists() and unit ~= "mouseover" then 
            return true
        end

        -- In Combat
        if inCombat and Unit(unit):IsExists() then

		    -- Soothe
		    -- Note: Toggles  ("UseDispel", "UsePurge", "UseExpelEnrage")
            -- Category ("Dispel", "MagicMovement", "PurgeFriendly", "PurgeHigh", "PurgeLow", "Enrage")
            if A.Soothe:IsReady(unit) and Action.AuraIsValid("target", "UseExpelEnrage", "Enrage") then
                return A.Soothe:Show(icon)
            end	
        			
			-- Interrupt
            local Interrupt = Interrupts(unit)
            if Interrupt then 
                return Interrupt:Show(icon)
            end	
								
		    -- Taunt logic by KhalDrogo1988
            if A.GetToggle(2, "AutoTaunt") and combatTime > 0 then 
				if not Unit(unit):IsBoss() and
                A.Growl:IsReady(unit) then
					local agroLevels = TargetWithAgroExsist()
                    if agroLevels[0] and Unit(player):ThreatSituation(unit) ~= 0 then
                        return A:Show(icon, ACTION_CONST_AUTOTARGET)
                    end
                    if agroLevels[1] and Unit(player):ThreatSituation(unit) > 1 then
                        return A:Show(icon, ACTION_CONST_AUTOTARGET)
                    end
                    if agroLevels[2] and Unit(player):ThreatSituation(unit) > 2 then
                        return A:Show(icon, ACTION_CONST_AUTOTARGET)
                    end
                end
            end
			
			-- Moonfire
            if A.Moonfire:IsReady(unit) and (Unit("player"):HasBuffs(A.GalacticGuardianBuff.ID, true) > 0 or (MultiUnits:GetByRange(30) >= 2 and Unit(unit):HasDeBuffs(A.MoonfireDebuff.ID, true) == 0)) then
                return A.Moonfire:Show(icon) 
            end
			
	    	-- Auto Multidot
		    if Unit(unit):TimeToDie() > 10  
		       and Action.GetToggle(2, "AoE") and Action.GetToggle(2, "AutoDot") and CanMultidot
		       and (
        	    	   MissingMoonfire >= 1 and MissingMoonfire <= 8 and Unit(unit):HasDeBuffs(A.MoonfireDebuff.ID, true) > 0 and Unit(unit):HasDeBuffs(A.ThrashBearDebuff.ID, true) > 0 
			        ) 
		       and MultiUnits:GetByRange(20) > 1 and MultiUnits:GetByRange(20) <= 8
		    then
		       return A:Show(icon, ACTION_CONST_AUTOTARGET)
		    end	
			
		    -- Charge if out of range
            if A.WildChargeTalent:IsSpellLearned() and A.WildChargeBear:IsReady(unit) and Unit(unit):GetRange() >= 8 and Unit(unit):GetRange() <= 25 then
                return A.WildChargeBear:Show(icon)
            end
			
		    -- StampedingRoar if out of range 
            if A.StampedingRoar:IsReady("player") and isMovingFor > A.GetToggle(2, "StampedingRoarTime") and A.GetToggle(2, "UseStampedingRoar") then
                return A.StampedingRoar:Show(icon)
            end
			
            -- call_action_list,name=cooldowns
            if Cooldowns(unit) then
                return true
            end
			
            -- maul,if=rage.deficit<10&active_enemies<4
            if A.Maul:IsReady(unit) and Unit("player"):HasBuffsStacks(A.ToothandClaw.ID, true) >= 1 and
			
			(
				A.Maul:GetSpellPowerCostCache() == 0
				or
				(
					Player:Rage() > A.Maul:GetSpellPowerCostCache()
				)
			)
			then
                return A.Maul:Show(icon)
            end
			
            -- maul
            if A.Maul:IsReady(unit) and Player:Rage() > 90 and A.GetToggle(2, "OffensiveRage") then
                return A.Maul:Show(icon)
            end
			
            -- ironfur,if=cost=0|(rage>cost&azerite.layered_mane.enabled&active_enemies>2)
            if A.Ironfur:IsReady("player") and Unit("player"):HasBuffsStacks(A.ToothandClaw.ID, true) <=0 and
			(
			    A.Ironfur:GetSpellPowerCostCache() == 0 
				or 
				(
				    Player:Rage() > A.Ironfur:GetSpellPowerCostCache() and 
					A.LayeredMane:GetAzeriteRank() > 0 and 
					MultiUnits:GetByRange(40, 5, 10) > 2
				)
			) 
			then
                return A.Ironfur:Show(icon)
            end
			
            -- pulverize,target_if=dot.thrash_bear.stack=dot.thrash_bear.max_stacks
            if A.Pulverize:IsReady(unit) then
                if Unit(unit):HasDeBuffsStacks(A.ThrashBearDebuff.ID, true) == 3 then
                    return A.Pulverize:Show(icon) 
                end
            end

            -- thrash,if=(buff.incarnation.down&active_enemies>1)|(buff.incarnation.up&active_enemies>4)
            if Thrash:IsReady("player") and ((Unit("player"):HasBuffs(A.IncarnationBuff.ID, true) == 0 and MultiUnits:GetByRange(8) > 1) or (Unit("player"):HasBuffs(A.IncarnationBuff.ID, true) > 0 and MultiUnits:GetByRangeInCombat(40, 5, 10) >= 4)) then
                return Thrash:Show(icon)
            end
			
            -- swipe,if=buff.incarnation.down&active_enemies>4
            if Swipe:IsReady("player") and (Unit("player"):HasBuffs(A.IncarnationBuff.ID, true) == 0 and MultiUnits:GetByRange(8) >= 4) then
                return Swipe:Show(icon)
            end
			
            -- mangle,if=dot.thrash_bear.ticking
            if A.Mangle:IsReady(unit) and (Unit(unit):HasDeBuffs(A.ThrashBearDebuff.ID, true) > 0) then
                return A.Mangle:Show(icon)
            end
			
            -- thrash
            if Thrash:IsReady("player") then
                return Thrash:Show(icon)
            end
			
            -- swipe
            if Swipe:IsReady("player") then
                return Swipe:Show(icon)
            end
			
        end
    end

    -- End on EnemyRotation()
	
    -- bear_form
    if A.BearForm:IsReady(unit) and inStance ~= 1 and inCombat then
        return A.BearForm:Show(icon)
    end
	
	-- Defensives
    local SelfDefensive = SelfDefensives()
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
            if A.NetherWard:IsReady() and A.NetherWard:IsSpellLearned() and Action.ShouldReflect(unit) and EnemyTeam():IsCastingBreakAble(0.25) then 
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