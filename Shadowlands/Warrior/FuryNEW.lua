--###############################
--##### TRIP'S FURY WARRIOR #####
--###############################

local _G, setmetatable							= _G, setmetatable
local A                         			    = _G.Action
local Covenant									= _G.LibStub("Covenant")
local TMW										= _G.TMW
local Listener                                  = Action.Listener
local Create                                    = Action.Create
local GetToggle                                 = Action.GetToggle
local SetToggle                                 = Action.SetToggle
local GetGCD                                    = Action.GetGCD
local GetCurrentGCD                             = Action.GetCurrentGCD
local GetPing                                   = Action.GetPing
local ShouldStop                                = Action.ShouldStop
local BurstIsON                                 = Action.BurstIsON
local CovenantIsON								= Action.CovenantIsON
local AuraIsValid                               = Action.AuraIsValid
local InterruptIsValid                          = Action.InterruptIsValid
local FrameHasSpell                             = Action.FrameHasSpell
local Utils                                     = Action.Utils
local TeamCache                                 = Action.TeamCache
local EnemyTeam                                 = Action.EnemyTeam
local FriendlyTeam                              = Action.FriendlyTeam
local LoC                                       = Action.LossOfControl
local Player                                    = Action.Player
local Pet                                       = LibStub("PetLibrary") 
local MultiUnits                                = Action.MultiUnits
local UnitCooldown                              = Action.UnitCooldown
local Unit                                      = Action.Unit 
local IsUnitEnemy                               = Action.IsUnitEnemy
local IsUnitFriendly                            = Action.IsUnitFriendly
local ActiveUnitPlates                          = MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit                     = IsIndoors, UnitIsUnit
local pairs                                     = pairs

--For Toaster
local Toaster									= _G.Toaster
local GetSpellTexture 							= _G.TMW.GetSpellTexture

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

Action[ACTION_CONST_WARRIOR_FURY] = {
    -- Racial
    ArcaneTorrent					= Action.Create({ Type = "Spell", ID = 50613    }),
    BloodFury						= Action.Create({ Type = "Spell", ID = 20572    }),
    Fireblood						= Action.Create({ Type = "Spell", ID = 265221   }),
    AncestralCall					= Action.Create({ Type = "Spell", ID = 274738   }),
    Berserking						= Action.Create({ Type = "Spell", ID = 26297    }),
    ArcanePulse						= Action.Create({ Type = "Spell", ID = 260364   }),
    QuakingPalm						= Action.Create({ Type = "Spell", ID = 107079   }),
    Haymaker						= Action.Create({ Type = "Spell", ID = 287712   }), 
    WarStomp						= Action.Create({ Type = "Spell", ID = 20549    }),
    BullRush						= Action.Create({ Type = "Spell", ID = 255654   }),  
    GiftofNaaru						= Action.Create({ Type = "Spell", ID = 59544    }),
    Shadowmeld						= Action.Create({ Type = "Spell", ID = 58984    }), 
    Stoneform						= Action.Create({ Type = "Spell", ID = 20594    }), 
    BagofTricks						= Action.Create({ Type = "Spell", ID = 312411	}),
    WilloftheForsaken				= Action.Create({ Type = "Spell", ID = 7744		}),   
    EscapeArtist					= Action.Create({ Type = "Spell", ID = 20589    }), 
    EveryManforHimself				= Action.Create({ Type = "Spell", ID = 59752    }), 
	LightsJudgment					= Action.Create({ Type = "Spell", ID = 255647	}),

	-- Warrior General
    BattleShout						= Action.Create({ Type = "Spell", ID = 6673		}),
    BerserkerRage					= Action.Create({ Type = "Spell", ID = 18499	}),
    Charge							= Action.Create({ Type = "Spell", ID = 100		}),
    Execute							= Action.Create({ Type = "Spell", ID = 5308		}),
    Hamstring						= Action.Create({ Type = "Spell", ID = 1715		}),
    HeroicLeap						= Action.Create({ Type = "Spell", ID = 6544		}),
    HeroicThrow						= Action.Create({ Type = "Spell", ID = 57755	}),
    IgnorePain						= Action.Create({ Type = "Spell", ID = 190456	}),
    Intervene						= Action.Create({ Type = "Spell", ID = 3411		}),	
    IntimidatingShout				= Action.Create({ Type = "Spell", ID = 5246		}),
    Pummel							= Action.Create({ Type = "Spell", ID = 6552		}),
    RallyingCry						= Action.Create({ Type = "Spell", ID = 97462	}),
    ShatteringThrow					= Action.Create({ Type = "Spell", ID = 64382	}),	
    ShieldBlock						= Action.Create({ Type = "Spell", ID = 2565		}),
    ShieldSlam						= Action.Create({ Type = "Spell", ID = 23922	}),
    Slam							= Action.Create({ Type = "Spell", ID = 1464		}),	
    SpellReflection					= Action.Create({ Type = "Spell", ID = 23950	}),
    Taunt							= Action.Create({ Type = "Spell", ID = 355		}),
    VictoryRush						= Action.Create({ Type = "Spell", ID = 34428	}),
    Whirlwind						= Action.Create({ Type = "Spell", ID = 190411	}),		
    WhirlwindBuff					= Action.Create({ Type = "Spell", ID = 85739, Hidden = true 	}),		
	
	-- Fury Specific
    Bloodthirst						= Action.Create({ Type = "Spell", ID = 23881	}),
    Bloodbath						= Action.Create({ Type = "Spell", ID = 335096	}),	
    EnragedRegeneration				= Action.Create({ Type = "Spell", ID = 184364	}),
    PiercingHowl					= Action.Create({ Type = "Spell", ID = 12323	}),
    RagingBlow						= Action.Create({ Type = "Spell", ID = 85288	}),
    CrushingBlow					= Action.Create({ Type = "Spell", ID = 335097	}),	
    Rampage							= Action.Create({ Type = "Spell", ID = 184367	}),
    Recklessness					= Action.Create({ Type = "Spell", ID = 1719		}),
    Enrage							= Action.Create({ Type = "Spell", ID = 184361, Hidden = true	}),	
    EnrageBuff						= Action.Create({ Type = "Spell", ID = 184362, Hidden = true	}),		

	-- Normal Talents
    WarMachine						= Action.Create({ Type = "Spell", ID = 346002, Hidden = true	}),
    SuddenDeath						= Action.Create({ Type = "Spell", ID = 280721, Hidden = true	}),
    FreshMeat						= Action.Create({ Type = "Spell", ID = 215568, Hidden = true	}),
    DoubleTime						= Action.Create({ Type = "Spell", ID = 103827, Hidden = true 	}),	
    ImpendingVictory				= Action.Create({ Type = "Spell", ID = 202168	}),
    StormBolt						= Action.Create({ Type = "Spell", ID = 107570	}),
    Massacre						= Action.Create({ Type = "Spell", ID = 206315, Hidden = true	}),
    Frenzy							= Action.Create({ Type = "Spell", ID = 335077, Hidden = true	}),
    FrenzyBuff						= Action.Create({ Type = "Spell", ID = 335082, Hidden = true	}),	
    Onslaught						= Action.Create({ Type = "Spell", ID = 315720	}),
    FuriousCharge					= Action.Create({ Type = "Spell", ID = 202224, Hidden = true	}),
    BoundingStride					= Action.Create({ Type = "Spell", ID = 202163, Hidden = true	}),	
    Warpaint						= Action.Create({ Type = "Spell", ID = 208154, Hidden = true	}),
    Seethe							= Action.Create({ Type = "Spell", ID = 335091, Hidden = true	}),
    FrothingBerserker				= Action.Create({ Type = "Spell", ID = 215571, Hidden = true	}),
    Cruelty							= Action.Create({ Type = "Spell", ID = 335070, Hidden = true	}),	
    MeatCleaver						= Action.Create({ Type = "Spell", ID = 280392, Hidden = true	}),
    DragonRoar						= Action.Create({ Type = "Spell", ID = 118000	}),
    Bladestorm						= Action.Create({ Type = "Spell", ID = 46924	}),	
    AngerManagement					= Action.Create({ Type = "Spell", ID = 152278, Hidden = true	}),
    RecklessAbandon					= Action.Create({ Type = "Spell", ID = 202751, Hidden = true	}),
    Siegebreaker					= Action.Create({ Type = "Spell", ID = 280772	}),	
    SiegebreakerDebuff				= Action.Create({ Type = "Spell", ID = 280773	}),		

	-- PvP Talents

	
	-- Covenant Abilities
    SummonSteward					= Action.Create({ Type = "Spell", ID = 324739	}),
    DoorofShadows					= Action.Create({ Type = "Spell", ID = 300728	}),
    Fleshcraft						= Action.Create({ Type = "Spell", ID = 331180	}),
    Soulshape						= Action.Create({ Type = "Spell", ID = 310143	}),
    Flicker							= Action.Create({ Type = "Spell", ID = 324701	}),
    SpearofBastion					= Action.Create({ Type = "Spell", ID = 307865	}),
    Condemn							= Action.Create({ Type = "Spell", ID = 317349	}),	
    ConquerorsBanner				= Action.Create({ Type = "Spell", ID = 324143	}),
    AncientAftershock				= Action.Create({ Type = "Spell", ID = 325886	}),	

	-- Conduits


	-- Legendaries
	-- General Legendaries


	--Fury Legendaries
	WilloftheBerserker				= Action.Create({ Type = "Spell", ID = 335594	}),	

	--Anima Powers - to add later...
	
	
	-- Trinkets
	

	-- Potions
    PotionofUnbridledFury			= Action.Create({ Type = "Potion", ID = 169299, QueueForbidden = true }), 	
    SuperiorPotionofUnbridledFury	= Action.Create({ Type = "Potion", ID = 168489, QueueForbidden = true }),
    PotionofSpectralStrength		= Action.Create({ Type = "Potion", ID = 171275, QueueForbidden = true }),
    PotionofSpectralStamina			= Action.Create({ Type = "Potion", ID = 171274, QueueForbidden = true }),
    PotionofEmpoweredExorcisms		= Action.Create({ Type = "Potion", ID = 171352, QueueForbidden = true }),
    PotionofHardenedShadows			= Action.Create({ Type = "Potion", ID = 171271, QueueForbidden = true }),
    PotionofPhantomFire				= Action.Create({ Type = "Potion", ID = 171349, QueueForbidden = true }),
    PotionofDeathlyFixation			= Action.Create({ Type = "Potion", ID = 171351, QueueForbidden = true }),
    SpiritualHealingPotion			= Action.Create({ Type = "Potion", ID = 171267, QueueForbidden = true }),  	

    -- Misc
    Channeling                      = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),    -- Show an icon during channeling
    TargetEnemy                     = Action.Create({ Type = "Spell", ID = 44603, Hidden = true     }),    -- Change Target (Tab button)
    StopCast                        = Action.Create({ Type = "Spell", ID = 61721, Hidden = true     }),        -- spell_magic_polymorphrabbit
    PoolResource                    = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),
	Quake                           = Action.Create({ Type = "Spell", ID = 240447, Hidden = true     }), -- Quake (Mythic Plus Affix)
	Bloodlust						= Action.Create({ Type = "Spell", ID = 2825, Hidden = true	}),
	Heroism							= Action.Create({ Type = "Spell", ID = 32182, Hidden = true	}),
	TimeWarp						= Action.Create({ Type = "Spell", ID = 80353, Hidden = true	}),	
	PrimalRage						= Action.Create({ Type = "Spell", ID = 264667, Hidden = true	}),	
	DrumsofDeathlyFerocity			= Action.Create({ Type = "Spell", ID = 309658, Hidden = true	}),		
}

local A = setmetatable(Action[ACTION_CONST_WARRIOR_FURY], { __index = Action })


local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end
local player = "player"
local target = "target"

local function InRange(unitID)
    return A.Bloodthirst:IsInRange(unitID)
end 

local function SelfDefensives()
    if Unit(player):CombatTime() == 0 then 
        return 
    end 
    
    local unit
    if A.IsUnitEnemy("mouseover") then 
        unit = "mouseover"
    elseif A.IsUnitEnemy("target") then 
        unit = "target"
    end  
    
    -- VictoryRush
    local VictoryRush = A.GetToggle(2, "VictoryRush")
    if     VictoryRush >= 0 and A.VictoryRush:IsReady("unit") and not A.ImpendingVictory:IsTalentLearned() and 
    (
        (     -- Auto 
            VictoryRush >= 100 and 
            (
                -- HP lose per sec >= 20
                Unit("player"):GetDMG() * 100 / Unit("player"):HealthMax() >= 20 or 
                Unit("player"):GetRealTimeDMG() >= Unit("player"):HealthMax() * 0.20 or 
                -- TTD 
                Unit("player"):TimeToDieX(25) < 5 or 
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
            ) and 
            Unit("player"):HasBuffs("DeffBuffs", true) == 0
        ) 
        or 
        (    -- Custom
            VictoryRush < 100 and 
            Unit("player"):HealthPercent() <= VictoryRush
        )
    ) 
    then 
        return A.VictoryRush
    end  
	
    local VictoryRush = A.GetToggle(2, "VictoryRush")
    if     VictoryRush >= 0 and A.ImpendingVictory:IsReady("unit") and A.ImpendingVictory:IsTalentLearned() and 
    (
        (     -- Auto 
            VictoryRush >= 100 and 
            (
                -- HP lose per sec >= 20
                Unit("player"):GetDMG() * 100 / Unit("player"):HealthMax() >= 20 or 
                Unit("player"):GetRealTimeDMG() >= Unit("player"):HealthMax() * 0.20 or 
                -- TTD 
                Unit("player"):TimeToDieX(25) < 5 or 
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
            ) and 
            Unit("player"):HasBuffs("DeffBuffs", true) == 0
        ) 
        or 
        (    -- Custom
            VictoryRush < 100 and 
            Unit("player"):HealthPercent() <= VictoryRush
        )
    ) 
    then 
        return A.ImpendingVictory
    end 	
    
    -- Rallying Cry
    local RallyingCry = A.GetToggle(2, "RallyingCry")
    if     RallyingCry >= 0 and A.RallyingCry:IsReady("player") and 
    (
        (     -- Auto 
            RallyingCry >= 100 and 
            (
                -- HP lose per sec >= 20
                Unit("player"):GetDMG() * 100 / Unit("player"):HealthMax() >= 20 or 
                Unit("player"):GetRealTimeDMG() >= Unit("player"):HealthMax() * 0.20 or 
                -- TTD 
                Unit("player"):TimeToDieX(25) < 5 or 
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
            ) and 
            Unit("player"):HasBuffs("DeffBuffs", true) == 0
        ) 
        or 
        (    -- Custom
            RallyingCry < 100 and 
            Unit("player"):HealthPercent() <= RallyingCry
        )
    ) 
    then 
        return A.RallyingCry
    end  
	
    local IgnorePain = A.GetToggle(2, "IgnorePain")
    if     IgnorePain >= 0 and A.IgnorePain:IsReady("player") and 
    (
        (     -- Auto 
            IgnorePain >= 100 and 
            (
                -- HP lose per sec >= 20
                Unit("player"):GetDMG() * 100 / Unit("player"):HealthMax() >= 20 or 
                Unit("player"):GetRealTimeDMG() >= Unit("player"):HealthMax() * 0.20 or 
                -- TTD 
                Unit("player"):TimeToDieX(25) < 5 or 
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
            ) and 
            Unit("player"):HasBuffs("DeffBuffs", true) == 0
        ) 
        or 
        (    -- Custom
            IgnorePain < 100 and 
            Unit("player"):HealthPercent() <= IgnorePain
        )
    ) 
    then 
        return A.IgnorePain
    end  

	if not Player:IsStealthed() then 	
		-- Healthstone | AbyssalHealingPotion
		local Healthstone = GetToggle(1, "HealthStone") 
		if Healthstone >= 0 then 
			if A.HS:IsReady(player) then 					
				if Healthstone >= 100 then -- AUTO 
					if Unit(player):TimeToDie() <= 9 and Unit(player):HealthPercent() <= 40 then
						A.Toaster:SpawnByTimer("TripToast", 0, "Healthstone!", "Using Healthstone!", A.HS.ID)						
						return A.HS
					end 
				elseif Unit(player):HealthPercent() <= Healthstone then 
					A.Toaster:SpawnByTimer("TripToast", 0, "Healthstone!", "Using Healthstone!", A.HS.ID)				
					return A.HS							 
				end
			elseif A.Zone ~= "arena" and (A.Zone ~= "pvp" or not A.InstanceInfo.isRated) and A.SpiritualHealingPotion:IsReady(player) then 
				if Healthstone >= 100 then -- AUTO 
					if Unit(player):TimeToDie() <= 9 and Unit(player):HealthPercent() <= 40 and Unit(player):HealthDeficit() >= A.SpiritualHealingPotion:GetItemDescription()[1] then
						A.Toaster:SpawnByTimer("TripToast", 0, "Health Potion!", "Using Health Potion!", A.SpiritualHealingPotion.ID)					
						return A.AbyssalHealingPotion
					end 
				elseif Unit(player):HealthPercent() <= Healthstone then
					A.Toaster:SpawnByTimer("TripToast", 0, "Health Potion!", "Using Health Potion!", A.SpiritualHealingPotion.ID)				
					return A.AbyssalHealingPotion						 
				end				
			end 
		end
		
		-- PhialofSerenity
		if A.Zone ~= "arena" and (A.Zone ~= "pvp" or not A.InstanceInfo.isRated) and A.PhialofSerenity:IsReady(player) then 
			-- Healing 
			local PhialofSerenityHP, PhialofSerenityOperator, PhialofSerenityTTD = GetToggle(2, "PhialofSerenityHP"), GetToggle(2, "PhialofSerenityOperator"), GetToggle(2, "PhialofSerenityTTD")
			if PhialofSerenityOperator == "AND" then 
				if (PhialofSerenityHP <= 0 or Unit(player):HealthPercent() <= PhialofSerenityHP) and (PhialofSerenityTTD <= 0 or Unit(player):TimeToDie() <= PhialofSerenityTTD) then 
					return A.PhialofSerenity
				end 
			else
				if (PhialofSerenityHP > 0 and Unit(player):HealthPercent() <= PhialofSerenityHP) or (PhialofSerenityTTD > 0 and Unit(player):TimeToDie() <= PhialofSerenityTTD) then 
					return A.PhialofSerenity
				end 
			end 
			
			-- Dispel 
			if AuraIsValidByPhialofSerenity() then 
				return A.PhialofSerenity	
			end 
		end 
	end

    -- HealingPotion
    local SpiritualHealingPotion = A.GetToggle(2, "SpiritualHealingPotionHP")
    if     SpiritualHealingPotion >= 0 and A.SpiritualHealingPotion:IsReady(player) and 
    (
        (     -- Auto 
            SpiritualHealingPotion >= 100 and 
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
        ) or 
        (    -- Custom
            SpiritualHealingPotion < 100 and 
            Unit(player):HealthPercent() <= SpiritualHealingPotion
        )
    ) 
    then 
        return A.SpiritualHealingPotion
    end 
    
    -- Stoneform on self dispel (only PvE)
    if A.Stoneform:IsRacialReady("player", true) and not A.IsInPvP and A.AuraIsValid("player", "UseDispel", "Dispel") then 
        return A.Stoneform
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
        useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, nil, nil, countInterruptGCD(unit))
    
	if castRemainsTime >= A.GetLatency() then
        -- Pummel
		if useKick and not notInterruptable and A.Pummel:IsReady(unitID) and A.Pummel:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then 
			return A.Pummel
		end 

        -- StormBolt
        if useCC and A.StormBolt:IsTalentLearned() and A.StormBolt:IsReady(unit) and not A.Pummel:IsReady(unit) and A.StormBolt:AbsentImun(unit, Temp.TotalAndPhysAndCCAndStun, true) then 
            return A.StormBolt              
        end 

    end
end

--######START ROTATION######

A[3] = function(icon, isMulti)

	--Toggle Remaps
	local UseCovenant = A.GetToggle(1, "Covenant")
	local UseRacial = A.GetToggle(1, "Racial")
	local ViciousContemptR5 = A.GetToggle(2, "ViciousContemptR5")
	local inMelee = InRange()
	local Trinket1IsAllowed = Action.GetToggle(1, "Trinkets")[1]
	local Trinket2IsAllowed = Action.GetToggle(1, "Trinkets")[2]
	local UseAoE = Action.GetToggle(2, "AoE")

	--Function Remaps
	local inCombat = Unit(player):CombatTime() > 0	
	local Rage = Player:Rage() 
	local LustEffect = Unit(player):HasBuffs(A.Bloodlust.ID, true) > 0 or Unit(player):HasBuffs(A.Heroism.ID, true) > 0 or Unit(player):HasBuffs(A.TimeWarp.ID, true) > 0 or Unit(player):HasBuffs(A.PrimalRage.ID, true) > 0 or Unit(player):HasBuffs(A.DrumsofDeathlyFerocity.ID, true) > 0

	local function EnemyRotation(unit)

		--[[local function BurstAoE()

			if (A.Bloodthirst:IsReady(unitID) or A.Bloodbath:IsReady(unitID)) and A.FreshMeat:IsTalentLearned() and Unit(player):HasBuffs(A.EnrageBuff.ID, true) == 0 then
				return A.Bloodthirst:Show(icon)
			end

			if A.Recklessness:IsReadyByPassCastGCD(player) and A.BurstIsON(unitID) and (inMelee or A.LastPlayerCastName == A.Charge:Info()) and (Unit(unitID):TimeToDie() > 10 or Unit(unitID):IsBoss()) then
				return A.Recklessness:Show(icon)
			end
			
			if A.Rampage:IsReady(unitID) and Unit(player):HasBuffs(A.EnrageBuff.ID, true) == 0 then
				return A.Rampage:Show(icon)
			end

			if A.DragonRoar:IsReady(player) and Unit(player):HasBuffs(A.EnrageBuff.ID, true) > 0 and Unit(unitID):GetRange() <= 10 and inCombat then
				return A.DragonRoar:Show(icon)
			end	
			
			if A.Whirlwind:IsReady(player) and Unit(player):HasBuffs(A.WhirlwindBuff.ID, true) == 0 and inCombat then
				return A.Whirlwind:Show(icon)
			end
			
			if A.Siegebreaker:IsReady(unitID) and (inMelee or A.LastPlayerCastName == A.Charge:Info()) and Unit(unitID):HasDeBuffs(A.SiegebreakerDebuff.ID, true) == 0 and inCombat then
				return A.Siegebreaker:Show(icon)
			end	

			if A.Condemn:IsReady(unitID) and UseCovenant and Player:GetCovenant() == 2 then
				return A.Condemn:Show(icon)
			end
			
			if A.Execute:IsReady(unitID) and Player:GetCovenant() ~= 2 then
				return A.Execute:Show(icon)
			end
			
			if A.SpearofBastion:IsReady(player) and UseCovenant and Unit(player):HasBuffs(A.EnrageBuff.ID, true) > 0 and Unit(unitID):GetRange() <= 25 and inCombat then
				return A.SpearofBastion:Show(icon)
			end

			if A.AncientAftershock:IsReady(player) and UseCovenant and Unit(player):HasBuffs(A.EnrageBuff.ID, true) > 0 and Unit(unitID):GetRange() <= 10 and inCombat then
				return A.AncientAftershock:Show(icon)
			end		
		
			
			if A.Bladestorm:IsReady(player) and inMelee and inCombat then
				return A.Bladestorm:Show(icon)
			end

		end	]]	
	
		--actions+=/charge
		if A.Charge:IsReady(unitID) and Unit(unitID):GetRange() > 10 then
			return A.Charge:Show(icon)
		end			

		-- Non SIMC Custom Trinket1
		if A.Trinket1:IsReady(unitID) and A.BurstIsON(unitID) and Trinket1IsAllowed and inMelee and inCombat then        
			return A.Trinket1:Show(icon)        
		end
		
		-- Non SIMC Custom Trinket2
		if A.Trinket2:IsReady(unitID) and A.BurstIsON(unitID) and Trinket2IsAllowed and inMelee and inCombat then        
			return A.Trinket2:Show(icon)    
		end 
		
		--actions+=/blood_fury
		if A.BloodFury:IsReady(player) and UseRacial and A.BurstIsON(unitID) and inMelee and inCombat then
			return A.BloodFury:Show(icon)
		end
		
		--actions+=/berserking,if=buff.recklessness.up
		if A.Berserking:IsReady(player) and UseRacial and A.BurstIsON(unitID) and inMelee and Unit(player):HasBuffs(A.Recklessness.ID, true) > 0 and inCombat then
			return A.Berserking:Show(icon)
		end		
		
		--actions+=/lights_judgment,if=buff.recklessness.down&debuff.siegebreaker.down
		if A.LightsJudgment:IsReady(player) and UseRacial and A.BurstIsON(unitID) and Unit(player):HasBuffs(A.Recklessness.ID, true) == 0 and Unit(unitID):HasDeBuffs(A.SiegebreakerDebuff.ID, true) == 0 then
			return A.LightsJudgment:Show(icon)
		end
		
		--actions+=/fireblood
		if A.Fireblood:IsReady(player) and UseRacial and A.BurstIsON(unitID) and inMelee and inCombat then
			return A.Fireblood:Show(icon)
		end		
		
		--actions+=/ancestral_call
		if A.AncestralCall:IsReady(player) and UseRacial and A.BurstIsON(unitID) and inMelee and inCombat then
			return A.AncestralCall:Show(icon)
		end		
		
		--actions+=/bag_of_tricks,if=buff.recklessness.down&debuff.siegebreaker.down&buff.enrage.up
		if A.BagofTricks:IsReady(player) and UseRacial and A.BurstIsON(unitID) and Unit(player):HasBuffs(A.Recklessness.ID, true) == 0 and Unit(unitID):HasDeBuffs(A.SiegebreakerDebuff.ID, true) == 0 and Unit(player):HasBuffs(A.EnrageBuff.ID, true) > 0 then
			return A.BagofTricks:Show(icon)
		end		


		if A.Whirlwind:IsReady(player) and MultiUnits:GetByRange(8, 2) > 1 and inCombat and UseAoE and Unit(player):HasBuffs(A.WhirlwindBuff.ID, true) == 0 and inCombat then
			return A.Whirlwind:Show(icon)
		end
		
		--[[if BurstAoE() and MultiUnits:GetByRange(8, 2) > 1 and inCombat then
			return true
		end]]

		--if A.ConquerorsBanner:IsReady(player) and UseCovenant and 

		if A.Rampage:IsReady(unitID) and (Unit(player):HasBuffs(A.EnrageBuff.ID, true) == 0 or Rage >= 90) then
			return A.Rampage:Show(icon)
		end	
		
		if A.Recklessness:IsReadyByPassCastGCD(player) and A.BurstIsON(unitID) and (inMelee or A.LastPlayerCastName == A.Charge:Info()) and (Unit(unitID):TimeToDie() > 10 or Unit(unitID):IsBoss()) and inCombat then
			return A.Recklessness:Show(icon)
		end
		
		if A.Siegebreaker:IsReady(unitID) and (inMelee or A.LastPlayerCastName == A.Charge:Info()) and Unit(unitID):HasDeBuffs(A.SiegebreakerDebuff.ID, true) == 0 then
			return A.Siegebreaker:Show(icon)
		end			

		--[[if A.Condemn:IsReady(unitID) and UseCovenant and Player:GetCovenant() == 2 then
			return A.Condemn:Show(icon)
		end]]
		
		if A.Execute:IsReady(unitID) then
			return A.Execute:Show(icon)
		end

		if A.RagingBlow:IsReady(unitID) and A.RagingBlow:GetSpellCharges() > 1 then
			return A.RagingBlow:Show(icon)
		end

		if A.CrushingBlow:IsReady(unitID) and A.CrushingBlow:GetSpellCharges() > 1 then
			return A.CrushingBlow:Show(icon)
		end		
		
		if A.Onslaught:IsReady(unitID) and Unit(player):HasBuffs(A.EnrageBuff.ID, true) > 0 then
			return A.Onslaught:Show(icon)
		end

		if A.Bloodthirst:IsReady(unitID) then
			return A.Bloodthirst:Show(icon)
		end

		if A.Bloodbath:IsReady(unitID) then
			return A.Bloodbath:Show(icon)
		end

		if A.DragonRoar:IsReady(player) and Unit(player):HasBuffs(A.EnrageBuff.ID, true) > 0 and Unit(unitID):GetRange() <= 10 and inCombat then
			return A.DragonRoar:Show(icon)
		end

		
		if A.SpearofBastion:IsReady(player) and UseCovenant and Unit(player):HasBuffs(A.EnrageBuff.ID, true) > 0 and Unit(unitID):GetRange() <= 25 and inCombat then
			return A.SpearofBastion:Show(icon)
		end

		if A.AncientAftershock:IsReady(player) and UseCovenant and Unit(player):HasBuffs(A.EnrageBuff.ID, true) > 0 and Unit(unitID):GetRange() <= 12 and inCombat then
			return A.AncientAftershock:Show(icon)
		end
		
		if A.Bladestorm:IsReady(player) and Unit(player):HasBuffs(A.EnrageBuff.ID, true) > 0 and inMelee and inCombat then
			return A.Bladestorm:Show(icon)
		end
	
		if A.RagingBlow:IsReady(unitID) then
			return A.RagingBlow:Show(icon)
		end
		
		if A.CrushingBlow:IsReady(unitID) then
			return A.CrushingBlow:Show(icon)
		end
		
		if A.Whirlwind:IsReady(player) and inMelee and inCombat then
			return A.Whirlwind:Show(icon)
		end
	
	end

    -- Defensive
    local SelfDefensive = SelfDefensives()
    if SelfDefensive then 
        return SelfDefensive:Show(icon)
    end 

    -- Mouseover
    if A.IsUnitEnemy("mouseover") then
        unitID = "mouseover"
        if EnemyRotation(unitID) then 
            return true 
        end 
    end 

    -- Target  
    if A.IsUnitEnemy("target") then 
        unitID = "target"
        if EnemyRotation(unitID) then 
            return true
        end 
    end

end