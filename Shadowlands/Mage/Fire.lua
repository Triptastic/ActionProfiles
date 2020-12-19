--############################
--##### TRIP'S FIRE MAGE #####
--############################

local _G, setmetatable							= _G, setmetatable
local A                         			    = _G.Action
local Covenant									= _G.LibStub("Covenant")
local TMW										= _G.TMW
local Listener									= Action.Listener
local Create									= Action.Create
local GetToggle									= Action.GetToggle
local SetToggle									= Action.SetToggle
local GetGCD									= Action.GetGCD
local GetCurrentGCD								= Action.GetCurrentGCD
local GetPing									= Action.GetPing
local ShouldStop								= Action.ShouldStop
local BurstIsON									= Action.BurstIsON
local CovenantIsON								= Action.CovenantIsON
local AuraIsValid								= Action.AuraIsValid
local InterruptIsValid							= Action.InterruptIsValid
local FrameHasSpell                             = Action.FrameHasSpell
local Utils										= Action.Utils
local TeamCache									= Action.TeamCache
local EnemyTeam									= Action.EnemyTeam
local FriendlyTeam								= Action.FriendlyTeam
local LoC										= Action.LossOfControl
local Player									= Action.Player
local Pet                                       = LibStub("PetLibrary") 
local MultiUnits								= Action.MultiUnits
local UnitCooldown								= Action.UnitCooldown
local Unit										= Action.Unit 
local IsUnitEnemy								= Action.IsUnitEnemy
local IsUnitFriendly							= Action.IsUnitFriendly
local ActiveUnitPlates                          = MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit                     = IsIndoors, UnitIsUnit
local pairs                                     = pairs

--For Toaster
local Toaster									= _G.Toaster
local GetSpellTexture 							= _G.TMW.GetSpellTexture

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

Action[ACTION_CONST_MAGE_FIRE] = {
    -- Racial
    ArcaneTorrent				= Action.Create({ Type = "Spell", ID = 50613	}),
    BloodFury					= Action.Create({ Type = "Spell", ID = 20572	}),
    Fireblood					= Action.Create({ Type = "Spell", ID = 265221	}),
    AncestralCall				= Action.Create({ Type = "Spell", ID = 274738	}),
    Berserking					= Action.Create({ Type = "Spell", ID = 26297	}),
    ArcanePulse             	= Action.Create({ Type = "Spell", ID = 260364	}),
    QuakingPalm           		= Action.Create({ Type = "Spell", ID = 107079	}),
    Haymaker           			= Action.Create({ Type = "Spell", ID = 287712	}), 
    BullRush           			= Action.Create({ Type = "Spell", ID = 255654	}),    
    WarStomp        			= Action.Create({ Type = "Spell", ID = 20549	}),
    GiftofNaaru   				= Action.Create({ Type = "Spell", ID = 59544	}),
    Shadowmeld   				= Action.Create({ Type = "Spell", ID = 58984    }),
    Stoneform 					= Action.Create({ Type = "Spell", ID = 20594    }), 
    BagofTricks					= Action.Create({ Type = "Spell", ID = 312411	}),
    WilloftheForsaken			= Action.Create({ Type = "Spell", ID = 7744		}),   
    EscapeArtist				= Action.Create({ Type = "Spell", ID = 20589    }), 
    EveryManforHimself			= Action.Create({ Type = "Spell", ID = 59752    }), 
	
	--Mage General
    ArcaneExplosion	     		= Action.Create({ Type = "Spell", ID = 1449		}),
    ArcaneIntellect	     		= Action.Create({ Type = "Spell", ID = 1459		}),
    Blink			     		= Action.Create({ Type = "Spell", ID = 1953		}),	
    ConjureRefreshment     		= Action.Create({ Type = "Spell", ID = 190336	}),
    CounterSpell	     		= Action.Create({ Type = "Spell", ID = 2139		}),	
    FrostNova		     		= Action.Create({ Type = "Spell", ID = 122		}),
    FrostBolt		     		= Action.Create({ Type = "Spell", ID = 116		}),	
    IceBlock		     		= Action.Create({ Type = "Spell", ID = 45438	}),	
    Invisibility	     		= Action.Create({ Type = "Spell", ID = 66		}),
    MirrorImage		     		= Action.Create({ Type = "Spell", ID = 55342	}),
    Polymorph		     		= Action.Create({ Type = "Spell", ID = 118		}),	
    RemoveCurse		     		= Action.Create({ Type = "Spell", ID = 475		}),
    SlowFall		     		= Action.Create({ Type = "Spell", ID = 130		}),
    Spellsteal		     		= Action.Create({ Type = "Spell", ID = 30449	}),
    TimeWarp		     		= Action.Create({ Type = "Spell", ID = 80353	}),	

	--Fire Spells
    BlazingBarrier	     		= Action.Create({ Type = "Spell", ID = 235313	}),
    Combustion		     		= Action.Create({ Type = "Spell", ID = 190319	}),	
    DragonsBreath	     		= Action.Create({ Type = "Spell", ID = 31661	}),
    FireBlast		     		= Action.Create({ Type = "Spell", ID = 108853	}),	
    Fireball		     		= Action.Create({ Type = "Spell", ID = 133		}),
    Flamestrike		     		= Action.Create({ Type = "Spell", ID = 2120		}),
    PhoenixFlames	     		= Action.Create({ Type = "Spell", ID = 257541	}),	
    Pyroblast		     		= Action.Create({ Type = "Spell", ID = 11366	}),	
    Scorch			     		= Action.Create({ Type = "Spell", ID = 2948		}),	
    Cauterize		     		= Action.Create({ Type = "Spell", ID = 86949, Hidden = true		}),	
    CriticalMass	     		= Action.Create({ Type = "Spell", ID = 117216, Hidden = true	}),	
    HotStreak		     		= Action.Create({ Type = "Spell", ID = 195283, Hidden = true	}),
    HotStreakBuff	     		= Action.Create({ Type = "Spell", ID = 48108, Hidden = true		}),		
    HeatingUp		     		= Action.Create({ Type = "Spell", ID = 48107, Hidden = true		}),			

	--Normal Talents
    Firestarter		     		= Action.Create({ Type = "Spell", ID = 205026, Hidden = true	}),
    Pyromaniac		     		= Action.Create({ Type = "Spell", ID = 205020, Hidden = true	}),	
    SearingTouch	     		= Action.Create({ Type = "Spell", ID = 269644, Hidden = true	}),	
    BlazingSoul		     		= Action.Create({ Type = "Spell", ID = 235365, Hidden = true	}),	
    Shimmer			     		= Action.Create({ Type = "Spell", ID = 212653	}),	
    BlastWave		     		= Action.Create({ Type = "Spell", ID = 157981	}),
    IncantersFlow	     		= Action.Create({ Type = "Spell", ID = 1463, Hidden = true		}),
    FocusMagic		     		= Action.Create({ Type = "Spell", ID = 321358	}),	
    RuneofPower	     			= Action.Create({ Type = "Spell", ID = 116011	}),
    RuneofPowerBuff    			= Action.Create({ Type = "Spell", ID = 116014	}),	
    FlameOn			     		= Action.Create({ Type = "Spell", ID = 205029, Hidden = true	}),	
    AlexstraszasFury     		= Action.Create({ Type = "Spell", ID = 235870, Hidden = true	}),	
    FromtheAshes	     		= Action.Create({ Type = "Spell", ID = 342344, Hidden = true	}),
    FreneticSpeed	     		= Action.Create({ Type = "Spell", ID = 236058, Hidden = true	}),	
    IceWard	     				= Action.Create({ Type = "Spell", ID = 205036, Hidden = true	}),	
    RingofFrost		     		= Action.Create({ Type = "Spell", ID = 113724	}),	
    FlamePatch		     		= Action.Create({ Type = "Spell", ID = 205037, Hidden = true	}),
    Conflagration	     		= Action.Create({ Type = "Spell", ID = 205023, Hidden = true	}),
    LivingBomb		     		= Action.Create({ Type = "Spell", ID = 44457	}),	
    Kindling		     		= Action.Create({ Type = "Spell", ID = 155148, Hidden = true	}),
    Pyroclasm		     		= Action.Create({ Type = "Spell", ID = 269650, Hidden = true	}),	
    Meteor			     		= Action.Create({ Type = "Spell", ID = 153561	}),	

	--PvP Talents
	--Later

	--Covenant Abilities
    RadiantSpark				= Action.Create({ Type = "Spell", ID = 307443	}),
    SummonSteward				= Action.Create({ Type = "Spell", ID = 324739	}),
    MirrorsofTorment			= Action.Create({ Type = "Spell", ID = 314793	}),
    DoorofShadows				= Action.Create({ Type = "Spell", ID = 300728	}),
    Deathborne					= Action.Create({ Type = "Spell", ID = 324220	}),
    Fleshcraft					= Action.Create({ Type = "Spell", ID = 331180	}),
    ShiftingPower				= Action.Create({ Type = "Spell", ID = 314791	}),
    Soulshape					= Action.Create({ Type = "Spell", ID = 310143	}),
    Flicker						= Action.Create({ Type = "Spell", ID = 324701	}),

	-- Conduits


	-- Legendaries
	-- General Legendaries

	-- Fire Legendaries

	-- Anima Powers - to add later...
	
	
	-- Trinkets
	

	-- Potions
    PotionofUnbridledFury			= Action.Create({ Type = "Potion", ID = 169299, QueueForbidden = true }), 	
    SuperiorPotionofUnbridledFury	= Action.Create({ Type = "Potion", ID = 168489, QueueForbidden = true }),
    PotionofSpectralIntellect		= Action.Create({ Type = "Potion", ID = 171273, QueueForbidden = true }),
    PotionofSpectralStamina			= Action.Create({ Type = "Potion", ID = 171274, QueueForbidden = true }),
    PotionofEmpoweredExorcisms		= Action.Create({ Type = "Potion", ID = 171352, QueueForbidden = true }),
    PotionofHardenedShadows			= Action.Create({ Type = "Potion", ID = 171271, QueueForbidden = true }),
    PotionofPhantomFire				= Action.Create({ Type = "Potion", ID = 171349, QueueForbidden = true }),
    PotionofDeathlyFixation			= Action.Create({ Type = "Potion", ID = 171351, QueueForbidden = true }),
    SpiritualHealingPotion			= Action.Create({ Type = "Potion", ID = 171267, QueueForbidden = true }),   
	
	-- Borrowed Bindings
	Darkflight						= Action.Create({ Type = "Spell", ID = 68992 }), -- used for AoE Combust	
	RocketJump						= Action.Create({ Type = "Spell", ID = 69070 }), -- used for ST Combust	
}
local A = setmetatable(Action[ACTION_CONST_MAGE_FIRE], { __index = Action })

local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end

local player = "player"
local target = "target"

------------------------------------------
---------- FIRE PRE APL SETUP -----------
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
	return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "FIRE") == 0
end 

local function InRange(unit)
	-- @return boolean 
	return A.Fireball:IsInRange(unit)
end 
InRange = A.MakeFunctionCachedDynamic(InRange)


-- Non GCD spell check
local function countInterruptGCD(unit)
    if not A.CounterSpell:IsReadyByPassCastGCD(unit) or not A.CounterSpell:AbsentImun(unit, Temp.TotalAndMagKick) then
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
        -- CounterSpell
        if useKick and not notInterruptable and A.CounterSpell:IsReady(unit) then 
            return A.CounterSpell
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
-- [3] Single Rotation
A[3] = function(icon, isMulti)

    --------------------
    --- ROTATION VAR ---
    --------------------
    local isMoving = A.Player:IsMoving()
    local isMovingFor = A.Player:IsMovingTime()
    local inCombat = Unit(player):CombatTime() > 0
    local combatTime = Unit(player):CombatTime()
    local ShouldStop = Action.ShouldStop()
    local Pull = Action.BossMods_Pulling()
    local DBM = Action.GetToggle(1, "DBM")
    local HeartOfAzeroth = Action.GetToggle(1, "HeartOfAzeroth")
    local Racial = Action.GetToggle(1, "Racial")
    local Potion = Action.GetToggle(1, "Potion")
	local Covenant = Action.GetToggle(1, "Covenant")
	local UseAoE = Action.GetToggle(2, "AoE")

    ------------------------------------------------------
    ---------------- ENEMY UNIT ROTATION -----------------
    ------------------------------------------------------
    local function EnemyRotation(unit)
	
		local function NoCombust(unitID)
	
			if A.RuneofPower:IsReady(player) and Unit(player):HasBuffs(A.RuneofPowerBuff.ID, true) == 0 and A.Combustion:GetCooldown() > 10 then
				return A.RuneofPower:Show(icon)
			end	

			if A.Combustion:IsReady(player) and A.PhoenixFlames:GetSpellChargesFrac() >= 2.9 and ((A.FireBlast:GetSpellChargesFrac() >= 1.9 and not A.FlameOn:IsTalentLearned()) or (A.FireBlast:GetSpellChargesFrac() >= 2.9 and A.FlameOn:IsTalentLearned())) and A.BurstIsON then
				return A.Combustion:Show(icon)
			end	

			-- Covenant
			if A.RadiantSpark:IsReady(unitID) and Covenant then
				return A.RadiantSpark:Show(icon)
			end	
		
			if A.MirrorsofTorment:IsReady(unitID) and Covenant then
				return A.MirrorsofTorment:Show(icon)
			end	
		
			if A.Deathborne:IsReady(unitID) and Covenant then
				return A.Deathborne:Show(icon)
			end	
			
			if A.ShiftingPower:IsReady(player) and A.Combustion:GetCooldown() > 4 and A.RuneofPower:GetCooldown() > 4 and A.FireBlast:GetSpellChargesFrac() < 1.5 and A.PhoenixFlames:GetSpellChargesFrac() < 1.5 and not isMoving then
				return A.ShiftingPower:Show(icon)
			end	

			if A.Pyroblast:IsReady(unitID) and Unit(player):HasBuffs(A.HotStreakBuff.ID, true) > 0 then
				return A.Pyroblast:Show(icon)
			end	

			if A.FireBlast:IsReady(unitID, nil, nil, true) and Unit(player):HasBuffs(A.HeatingUp.ID, true) > 0 and A.FireBlast:GetSpellChargesFrac() > A.PhoenixFlames:GetSpellChargesFrac() and A.LastPlayerCastID ~= A.PhoenixFlames:Info() and ((A.Combustion:GetCooldown() > 10 and A.BurstIsON) or not A.BurstIsON) then
				return A.FireBlast:Show(icon)
			end				

			if A.Flamestrike:IsReady(player) and A.FlamePatch:IsTalentLearned() and MultiUnits:GetActiveEnemies() >= 2 and UseAoE then
				return A.Flamestrike:Show(icon)
			end

			if A.Scorch:IsReady(unitID) and A.SearingTouch:IsTalentLearned() and Unit(unit):HealthPercent() <= 30 and Unit(player):HasBuffs(A.HeatingUp.ID, true) == 0 then
				return A.Scorch:Show(icon)
			end	
			
			if A.Fireball:IsReady(unitID) and Unit(player):HasBuffs(A.HotStreakBuff.ID, true) == 0 then
				return A.Fireball:Show(icon)
			end	

		end
		
		local function YesCombust(unitID)

			if MultiUnits:GetActiveEnemies() >= 3 and UseAoE then
				A.Toaster:SpawnByTimer("TripToast", 0, "Flamestrike Spam!", "Get your cursor ready!", A.Flamestrike.ID)
				if A.Flamestrike:IsReady(player) and Unit(player):HasBuffs(A.HotStreak.ID, true) > 0 then
					return A.Flamestrike:Show(icon)
				end
			end
			
			if MultiUnits:GetActiveEnemies() == 1 or not UseAoE then
				if A.Pyroblast:IsReady(player) and Unit(player):HasBuffs(A.HotStreakBuff.ID, true) > 0 then
					return A.Pyroblast:Show(icon)
				end
			end

			if A.FireBlast:IsReady(unitID, nil, nil, true) and Unit(player):HasBuffs(A.HeatingUp.ID, true) > 0 and A.LastPlayerCastID ~= A.PhoenixFlames:Info() then
				return A.FireBlast:Show(icon)
			end
	
			if A.PhoenixFlames:IsReady(unitID) and Unit(player):HasBuffs(A.HotStreakBuff.ID, true) == 0 and Unit(player):HasBuffs(A.HeatingUp.ID, true) == 0 then
				return A.PhoenixFlames:Show(icon)
			end

			if A.Scorch:IsReady(unitID) and Unit(player):HasBuffs(A.HotStreakBuff.ID, true) == 0 then
				return A.Scorch:Show(icon)
			end	


		
		end

		if A.BlazingBarrier:IsReady(player) and not inCombat then
			return A.BlazingBarrier:Show(icon)
		end

		-- Hardcast Pyroblast opener
		if not inCombat and DBM and Pull <= 4 and not isMoving then
			return A.Pyroblast:Show(icon)
		end
		
		if not inCombat and not DBM and not isMoving then
			return A.Fireball:Show(icon)
		end	
		
		if Unit(player):HasBuffs(A.Combustion.ID, true) > 0 and YesCombust() and inCombat then
			return true
		end
		
		if Unit(player):HasBuffs(A.Combustion.ID, true) == 0 and NoCombust() and inCombat then
			return true
		end
	
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


