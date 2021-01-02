--###############################
--##### TRIP'S ARMS WARRIOR #####
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
local AuraIsValidByPhialofSerenity				= A.AuraIsValidByPhialofSerenity
local InterruptIsValid                          = Action.InterruptIsValid
local FrameHasSpell                             = Action.FrameHasSpell
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
local ActiveUnitPlates                          = MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit                     = IsIndoors, UnitIsUnit
local pairs                                     = pairs

--For Toaster
local Toaster									= _G.Toaster
local GetSpellTexture 							= _G.TMW.GetSpellTexture

--- ============================ CONTENT =========================== ---
--- ======================= SPELLS DECLARATION ===================== ---

Action[ACTION_CONST_WARRIOR_ARMS] = {
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
    ChallengingShout				= Action.Create({ Type = "Spell", ID = 1161		}),		
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
	
	-- Arms Specific
    Bladestorm						= Action.Create({ Type = "Spell", ID = 227847	}),
    ColossusSmash					= Action.Create({ Type = "Spell", ID = 167105	}),
    ColossusSmashDebuff				= Action.Create({ Type = "Spell", ID = 208086 	}),	
    DiebytheSword					= Action.Create({ Type = "Spell", ID = 118038	}),
    MortalStrike					= Action.Create({ Type = "Spell", ID = 12294	}),
    Overpower						= Action.Create({ Type = "Spell", ID = 7384		}),
    PiercingHowl					= Action.Create({ Type = "Spell", ID = 12323	}),
    SweepingStrikes					= Action.Create({ Type = "Spell", ID = 260708	}),
    DeepWounds						= Action.Create({ Type = "Spell", ID = 262115, Hidden = true }),	

	-- Normal Talents
    WarMachine						= Action.Create({ Type = "Spell", ID = 262231, Hidden = true	}),
    SuddenDeath						= Action.Create({ Type = "Spell", ID = 29725, Hidden = true		}),
    Skullsplitter					= Action.Create({ Type = "Spell", ID = 260643	}),	
    DoubleTime						= Action.Create({ Type = "Spell", ID = 103827, Hidden = true	}),	
    ImpendingVictory				= Action.Create({ Type = "Spell", ID = 202168	}),	
    StormBolt						= Action.Create({ Type = "Spell", ID = 107570	}),	
    Massacre						= Action.Create({ Type = "Spell", ID = 281001, Hidden = true	}),
    FervorofBattle					= Action.Create({ Type = "Spell", ID = 202316, Hidden = true	}),	
    Rend							= Action.Create({ Type = "Spell", ID = 772		}),	
    SecondWind						= Action.Create({ Type = "Spell", ID = 29838, Hidden = true		}),
    BoundingStride					= Action.Create({ Type = "Spell", ID = 202163, Hidden = true	}),
    DefensiveStance					= Action.Create({ Type = "Spell", ID = 197690	}),
    CollateralDamage				= Action.Create({ Type = "Spell", ID = 334779, Hidden = true	}),
    Warbreaker						= Action.Create({ Type = "Spell", ID = 262161	}),	
    Cleave							= Action.Create({ Type = "Spell", ID = 845		}),
    InForTheKill					= Action.Create({ Type = "Spell", ID = 248621, Hidden = true	}),	
    Avatar							= Action.Create({ Type = "Spell", ID = 107574	}),	
    DeadlyCalm						= Action.Create({ Type = "Spell", ID = 262228	}),	
    AngerManagement					= Action.Create({ Type = "Spell", ID = 152278, Hidden = true	}),	
    Dreadnaught						= Action.Create({ Type = "Spell", ID = 262150, Hidden = true	}),
    Ravager							= Action.Create({ Type = "Spell", ID = 152277	}),	

	-- PvP Talents
    MasterandCommander				= Action.Create({ Type = "Spell", ID = 235941, Hidden = true	}),
    ShadowoftheColossus				= Action.Create({ Type = "Spell", ID = 198807, Hidden = true 	}),	
    StormofDestruction				= Action.Create({ Type = "Spell", ID = 236308, Hidden = true	}),	
    WarBanner						= Action.Create({ Type = "Spell", ID = 236320	}),
    SharpenBlade					= Action.Create({ Type = "Spell", ID = 198817	}),
    Duel							= Action.Create({ Type = "Spell", ID = 236273	}),
    DeathSentence					= Action.Create({ Type = "Spell", ID = 198500, Hidden = true	}),
    Disarm							= Action.Create({ Type = "Spell", ID = 236077	}),	
    Demolition						= Action.Create({ Type = "Spell", ID = 329033, Hidden = true	}),
    Overwatch						= Action.Create({ Type = "Spell", ID = 329035, Hidden = true	}),	
	
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


	--Arms Legendaries
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

};

-- To create covenant use next code:

local A = setmetatable(Action[ACTION_CONST_WARRIOR_ARMS], { __index = Action })

local player = "player"
local target = "target"
local mouseover = "mouseover"

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

function Player:AreaTTD(range)
    local ttdtotal = 0
	local totalunits = 0
    local r = range
    
	for _, unitID in pairs(ActiveUnitPlates) do 
		if Unit(unitID):GetRange() <= r then 
			local ttd = Unit(unitID):TimeToDie()
			totalunits = totalunits + 1
			ttdtotal = ttd + ttdtotal
		end
	end
    
	if totalunits == 0 then
		return 0
	end
    
	return ttdtotal / totalunits
end	

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

local function SelfDefensives()
    local HPLoosePerSecond = Unit("player"):GetDMG() * 100 / Unit("player"):HealthMax()
    if Unit("player"):CombatTime() == 0 then 
        return 
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
    
end 
SelfDefensives = A.MakeFunctionCachedStatic(SelfDefensives)

function Action:IsSuspended(delay, reset)
    -- @return boolean
    -- Returns true if action should be delayed before use, reset argument is a internal refresh cycle of expiration future time
    if (self.expirationSuspend or 0) + reset <= TMW.time then
        self.expirationSuspend = TMW.time + delay
    end 
    
    return self.expirationSuspend > TMW.time
end

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
        if useKick and A.Pummel:IsReady(unit) and A.Pummel:AbsentImun(unit, Temp.TotalAndPhysKick, true) and Unit(unit):CanInterrupt(true, nil, 25, 70) then 
            return A.Pummel
        end 
    
        -- StormBolt
        if useCC and A.StormBolt:IsReady(unit) and A.StormBolt:AbsentImun(unit, Temp.TotalAndPhysAndCC, true) and Unit(unit):CanInterrupt(true, nil, 25, 70) and Unit(unit):IsControlAble("stun", 0) then
            return A.StormBolt              
        end  
    
        -- IntimidatingShout
        if useCC and A.IntimidatingShout:IsReady(unit) and A.IntimidatingShout:AbsentImun(unit, Temp.TotalAndPhysAndCC, true) and Unit(unit):CanInterrupt(true, nil, 25, 70) and Unit(unit):IsControlAble("fear", 0) then 
            return A.IntimidatingShout              
        end  

    end
end


--- ======= ACTION LISTS =======

A[3] = function(icon, isMulti)

	local UseRacial = A.GetToggle(1, "Racial")
	local UseAoE = A.GetToggle(2, "AoE")	

	local function EnemyRotation()
	

		local function ExecuteRotation()
			-- actions.execute=deadly_calm
			if A.DeadlyCalm:IsReady(unit) then
				return A.DeadlyCalm:Show(icon)
			end
			
			-- actions.execute+=/rend,if=remains<=duration*0.3
			if A.Rend:IsReady(unit) and Unit(unit):HasDeBuffs(A.Rend.ID, true) <= 4 and Unit(unit):TimeToDie() >= 4 then
				return A.Rend:Show(icon)
			end
			
			-- actions.execute+=/skullsplitter,if=rage<60&(!talent.deadly_calm.enabled|buff.deadly_calm.down)
			if A.Skullsplitter:IsReady(unit) and Player:Rage() < 60 and Unit(player):HasBuffs(A.DeadlyCalm.ID, true) == 0 then
				return A.Skullsplitter:Show(icon)
			end
			
			-- actions.execute+=/avatar,if=cooldown.colossus_smash.remains<8&gcd.remains=0
			if A.Avatar:IsReady(player) and BurstIsON(unit) and A.ColossusSmash:GetCooldown() < 8 then
				return A.Avatar:Show(icon)
			end
			
			-- actions.execute+=/ravager,if=buff.avatar.remains<18&!dot.ravager.remains
			if A.Ravager:IsReady(player) and A.Ravager:IsTalentLearned() and Unit(player):HasBuffs(A.Avatar.ID, true) < 18 then
				return A.Ravager:Show(icon)
			end
			
			-- actions.execute+=/cleave,if=spell_targets.whirlwind>1&dot.deep_wounds.remains<gcd
			if A.Cleave:IsReady(player) and MultiUnits:GetByRange(8, 2) > 1 and Unit(unit):HasDeBuffs(A.DeepWounds.ID, true) < A.GetGCD() then
				return A.Cleave:Show(icon)
			end
			
			-- actions.execute+=/warbreaker
			if A.Warbreaker:IsReady(player) and A.Warbreaker:IsTalentLearned() and Unit(unit):GetRange() <= 5 and BurstIsON(unit) and Unit(unit):TimeToDie() >= 8 then
				return A.Warbreaker:Show(icon)
			end
			
			-- actions.execute+=/colossus_smash
			if A.ColossusSmash:IsReady(unit) and not A.Warbreaker:IsTalentLearned() then
				return A.ColossusSmash:Show(icon)
			end
			
			-- actions.execute+=/condemn,if=debuff.colossus_smash.up|buff.sudden_death.react|rage>65
			if A.Execute:IsReady(unit) and Player:GetCovenant() == 2 and (Unit(unit):HasDeBuffs(A.ColossusSmashDebuff.ID, true) > 0 or Player:Rage() > 65) then
				return A.Execute:Show(icon)
			end
			
			-- actions.execute+=/overpower,if=charges=2
			if A.Overpower:IsReady(unit) and A.Overpower:GetSpellCharges() > 1 then
				return A.Overpower:Show(icon)
			end
			
			-- actions.execute+=/bladestorm,if=buff.deadly_calm.down&rage<50
			if A.Bladestorm:IsReady(player) and BurstIsON(unit) and Unit(player):HasBuffs(A.DeadlyCalm.ID, true) == 0 and Player:Rage() < 50 then
				return A.Bladestorm:Show(icon)
			end
			
			-- actions.execute+=/mortal_strike,if=dot.deep_wounds.remains<=gcd
			if A.MortalStrike:IsReady(unit) and Unit(unit):HasDeBuffs(A.DeepWounds.ID, true) <= A.GetGCD() then
				return A.MortalStrike:Show(icon)
			end
			
			-- actions.execute+=/skullsplitter,if=rage<40
			if A.Skullsplitter:IsReady(unit) and Player:Rage() < 40 then
				return A.Skullsplitter:Show(icon)
			end
			
			-- actions.execute+=/overpower
			if A.Overpower:IsReady(unit) then
				return A.Overpower:Show(icon)
			end
			
			--[[ actions.execute+=/condemn
			if A.Condemn:IsReady(unit) then
				return A.Condemn:Show(icon)
			end]]
			
			-- actions.execute+=/execute
			if A.Execute:IsReady(unit) then
				return A.Execute:Show(icon)
			end
			
			
		end	

		local function HAC()
			-- actions.hac=skullsplitter,if=rage<60&buff.deadly_calm.down
			if A.Skullsplitter:IsReady(unit) and Player:Rage() < 60 and Unit(player):HasBuffs(A.DeadlyCalm.ID, true) == 0 then
				return A.Skullsplitter:Show(icon)
			end
			
			-- actions.hac+=/avatar,if=cooldown.colossus_smash.remains<1
			if A.Avatar:IsReady(player) and BurstIsON(unit) and A.ColossusSmash:GetCooldown() < 1 then
				return A.Avatar:Show(icon)
			end
			
			-- actions.hac+=/cleave,if=dot.deep_wounds.remains<=gcd
			if A.Cleave:IsReady(player) and Unit(unit):HasDeBuffs(A.DeepWounds.ID, true) <= A.GetGCD() then
				return A.Cleave:Show(icon)
			end
			
			-- actions.hac+=/warbreaker
			if A.Warbreaker:IsReady(player) and A.Warbreaker:IsTalentLearned() and Unit(unit):GetRange() <= 5 and BurstIsON(unit) and Unit(unit):TimeToDie() >= 8 then
				return A.Warbreaker:Show(icon)
			end
			
			-- actions.hac+=/bladestorm
			if A.Bladestorm:IsReady(player) and not A.Ravager:IsTalentLearned() and BurstIsON(unit) then
				return A.Bladestorm:Show(icon)
			end
			
			-- actions.hac+=/ravager
			if A.Ravager:IsReady(player) and A.Ravager:IsTalentLearned() then
				return A.Ravager:Show(icon)
			end
			
			-- actions.hac+=/colossus_smash
			if A.ColossusSmash:IsReady(unit) then
				return A.ColossusSmash:Show(icon)
			end
			
			-- actions.hac+=/rend,if=remains<=duration*0.3&buff.sweeping_strikes.up
			if A.Rend:IsReady(unit) and Unit(unit):HasDeBuffs(A.Rend.ID, true) < 4 and Unit(player):HasBuffs(A.SweepingStrikes.ID, true) > 0 then
				return A.Rend:Show(icon)
			end
			
			-- actions.hac+=/cleave
			if A.Cleave:IsReady(player) then
				return A.Cleave:Show(icon)
			end
			
			-- actions.hac+=/mortal_strike,if=buff.sweeping_strikes.up|dot.deep_wounds.remains<gcd&!talent.cleave.enabled
			if A.MortalStrike:IsReady(unit) and (Unit(player):HasBuffs(A.SweepingStrikes.ID, true) > 0 or Unit(unit):HasDeBuffs(A.DeepWounds.ID, true) < A.GetGCD() and not A.Cleave:IsTalentLearned()) then
				return A.MortalStrike:Show(icon)
			end
			
			-- actions.hac+=/overpower,if=talent.dreadnaught.enabled
			if A.Overpower:IsReady(unit) and A.Dreadnaught:IsTalentLearned() then
				return A.Overpower:Show(icon)
			end
			
			-- actions.hac+=/condemn
			if A.Execute:IsReady(unit) and Player:GetCovenant() == 2 then
				return A.Execute:Show(icon)
			end
			
			-- actions.hac+=/execute,if=buff.sweeping_strikes.up
			if A.Execute:IsReady(unit) and Unit(player):HasBuffs(A.SweepingStrikes.ID, true) > 0 then
				return A.Execute:Show(icon)
			end
			
			-- actions.hac+=/overpower
			if A.Overpower:IsReady(unit) then
				return A.Overpower:Show(icon)
			end
			
			-- actions.hac+=/whirlwind
			if A.Whirlwind:IsReady(player) then
				return A.Whirlwind:Show(icon)
			end
			
		end	

		local function SingleTarget()	
			-- actions.single_target=avatar,if=cooldown.colossus_smash.remains<8&gcd.remains=0
			if A.Avatar:IsReady(player) and BurstIsON(unit) and A.ColossusSmash:GetCooldown() < 8 then
				return A.Avatar:Show(icon)
			end
			
			-- actions.single_target+=/rend,if=remains<=duration*0.3
			if A.Rend:IsReady(unit) and Unit(unit):HasDeBuffs(A.Rend.ID, true) <= 4 and Unit(unit):TimeToDie() >= 4 then
				return A.Rend:Show(icon)
			end
			
			-- actions.single_target+=/cleave,if=spell_targets.whirlwind>1&dot.deep_wounds.remains<gcd
			if A.Cleave:IsReady(player) and MultiUnits:GetByRange(8, 2) > 1 and Unit(unit):HasDeBuffs(A.DeepWounds.ID, true) < A.GetGCD() then
				return A.Cleave:Show(icon)
			end			
			
			-- actions.single_target+=/warbreaker
			if A.Warbreaker:IsReady(player) and A.Warbreaker:IsTalentLearned() and Unit(unit):GetRange() <= 5 and BurstIsON(unit) and Unit(unit):TimeToDie() >= 8 then
				return A.Warbreaker:Show(icon)
			end
			
			-- actions.single_target+=/colossus_smash
			if A.ColossusSmash:IsReady(unit) and not A.Warbreaker:IsTalentLearned() then
				return A.ColossusSmash:Show(icon)
			end
			
			-- actions.single_target+=/ravager,if=buff.avatar.remains<18&!dot.ravager.remains
			if A.Ravager:IsReady(player) and Unit(player):HasBuffs(A.Avatar.ID, true) < 18 then
				return A.Ravager:Show(icon)
			end
			
			-- actions.single_target+=/overpower,if=charges=2
			if A.Overpower:IsReady(unit) and A.Overpower:GetSpellCharges() > 1 then
				return A.Overpower:Show(icon)
			end
			
			-- actions.single_target+=/bladestorm,if=buff.deadly_calm.down&(debuff.colossus_smash.up&rage<30|rage<70)
			if A.Bladestorm:IsReady(player) and BurstIsON(unit) and Unit(player):HasBuffs(A.DeadlyCalm.ID, true) == 0 and (Unit(unit):HasDeBuffs(A.ColossusSmashDebuff.ID, true) > 0 and Player:Rage() < 30 or Player:Rage() < 70) then
				return A.Bladestorm:Show(icon)
			end
			
			-- actions.single_target+=/mortal_strike,if=buff.overpower.stack>=2&buff.deadly_calm.down|(dot.deep_wounds.remains<=gcd&cooldown.colossus_smash.remains>gcd)
			if A.MortalStrike:IsReady(unit) and (Unit(player):HasBuffsStacks(A.Overpower.ID, true) >= 2 and Unit(player):HasBuffs(A.DeadlyCalm.ID, true) == 0 or (Unit(unit):HasDeBuffs(A.DeepWounds.ID, true) <= A.GetGCD() and A.ColossusSmash:GetCooldown() > A.GetGCD())) then
				return A.MortalStrike:Show(icon)
			end
			
			-- actions.single_target+=/deadly_calm
			if A.DeadlyCalm:IsReady(player) then
				return A.DeadlyCalm:Show(icon)
			end
			
			-- actions.single_target+=/skullsplitter,if=rage<60&buff.deadly_calm.down
			if A.Skullsplitter:IsReady(unit) and Player:Rage() < 60 and Unit(player):HasBuffs(A.DeadlyCalm.ID, true) == 0 then
				return A.Skullsplitter:Show(icon)
			end
			
			-- actions.single_target+=/overpower
			if A.Overpower:IsReady(unit) then
				return A.Overpower:Show(icon)
			end
			
			-- actions.single_target+=/condemn,if=buff.sudden_death.react
			
			-- actions.single_target+=/execute,if=buff.sudden_death.react
			if A.Execute:IsReady(unit) then
				return A.Execute:Show(icon)
			end
			
			-- actions.single_target+=/mortal_strike
			if A.MortalStrike:IsReady(unit) then
				return A.MortalStrike:Show(icon)
			end
			
			-- actions.single_target+=/whirlwind,if=talent.fervor_of_battle.enabled
			if A.Whirlwind:IsReady(player) and Unit(unit):GetRange() <= 8 and A.FervorofBattle:IsTalentLearned() then
				return A.Whirlwind:Show(icon)
			end
			
			-- actions.single_target+=/slam,if=!talent.fervor_of_battle.enabled
			if A.Slam:IsReady(unit) and not A.FervorofBattle:IsTalentLearned() then
				return A.Slam:Show(icon)
			end
		
		end

		--ZakLL Berserker Rage
		if LoC:Get("FEAR") > 0 and not A.BerserkerRage:IsSuspended((math_random(25, 40) / 100) - GetLatency(), 6) then
			return A.BerserkerRage:Show(icon)
		end

        -- Interrupts
        local Interrupt = Interrupts(unit)
        if inCombat and Interrupt then 
            return Interrupt:Show(icon)
        end 

		-- actions=charge
		if A.Charge:IsReady(unit) then
			return A.Charge:Show(icon)
		end
		
		-- actions+=/blood_fury,if=debuff.colossus_smash.up
		if A.BloodFury:IsReady(player) and UseRacial and BurstIsON(unit) and Unit(unit):HasDeBuffs(A.ColossusSmashDebuff.ID, true) > 0 then
			return A.BloodFury:Show(icon)
		end
		
		-- actions+=/berserking,if=debuff.colossus_smash.remains>6
		if A.Berserking:IsReady(player) and UseRacial and BurstIsON(unit) and Unit(unit):HasDeBuffs(A.ColossusSmashDebuff.ID, true) > 6 then
			return A.Berserking:Show(icon)
		end
		
		-- actions+=/arcane_torrent,if=cooldown.mortal_strike.remains>1.5&rage<50
		if A.ArcaneTorrent:IsReady(player) and UseRacial and BurstIsON(unit) and A.MortalStrike:GetCooldown() > 1.5 and Player:Rage() < 50 then
			return A.ArcaneTorrent:Show(icon)
		end
		
		-- actions+=/lights_judgment,if=debuff.colossus_smash.down&cooldown.mortal_strike.remains
		if A.LightsJudgment:IsReady(unit) and UseRacial and BurstIsON(unit) and Unit(unit):HasDeBuffs(A.ColossusSmashDebuff.ID, true) == 0 and A.MortalStrike:GetCooldown() > 0 then
			return A.LightsJudgment:Show(icon)
		end
		
		-- actions+=/fireblood,if=debuff.colossus_smash.up
		if A.Fireblood:IsReady(player) and UseRacial and BurstIsON(unit) and Unit(unit):HasDeBuffs(A.ColossusSmashDebuff.ID, true) > 0 then
			return A.Fireblood:Show(icon)
		end
		
		-- actions+=/ancestral_call,if=debuff.colossus_smash.up
		if A.AncestralCall:IsReady(player) and UseRacial and BurstIsON(unit) and Unit(unit):HasDeBuffs(A.ColossusSmashDebuff.ID, true) > 0 then
			return A.AncestralCall:Show(icon)
		end		
		
		-- actions+=/bag_of_tricks,if=debuff.colossus_smash.down&cooldown.mortal_strike.remains
		if A.BagofTricks:IsReady(unit) and UseRacial and BurstIsON(unit) and Unit(unit):HasDeBuffs(A.ColossusSmashDebuff.ID, true) == 0 and A.MortalStrike:GetCooldown() > 0 then
			return A.BagofTricks:Show(icon)
		end		
		
		-- actions+=/use_item,name=inscrutable_quantum_device
		
		-- actions+=/use_item,name=dreadfire_vessel
		
		
		-- actions+=/sweeping_strikes,if=spell_targets.whirlwind>1&(cooldown.bladestorm.remains>15|talent.ravager.enabled)
		if A.SweepingStrikes:IsReady(player) and UseAoE and MultiUnits:GetByRange(8, 2) > 1 and (not BurstIsON(unit) or (A.Bladestorm:GetCooldown() > 15 and BurstIsON(unit)) or A.Ravager:IsTalentLearned()) then
			return A.SweepingStrikes:Show(icon)
		end
		
		-- actions+=/run_action_list,name=hac,if=raid_event.adds.exists
		if UseAoE and MultiUnits:GetByRange(8, 2) > 1 then
			if HAC() then
				return true
			end
		end
		
		-- actions+=/run_action_list,name=execute,if=(talent.massacre.enabled&target.health.pct<35)|target.health.pct<20|(target.health.pct>80&covenant.venthyr)
		if Unit(unit):GetRange() <= 8 and (A.Massacre:IsTalentLearned() and Unit(unit):HealthPercent() < 35) or Unit(unit):HealthPercent() < 20 or (Unit(unit):HealthPercent() > 80 and Player:GetCovenant() == 2) then
			if ExecuteRotation() then
				return true
			end
		end
		
		-- actions+=/run_action_list,name=single_target
		if SingleTarget() and Unit(unit):GetRange() <= 8 then
			return true
		end
		

	end		

    -- End on EnemyRotation()

    -- Defensive
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
