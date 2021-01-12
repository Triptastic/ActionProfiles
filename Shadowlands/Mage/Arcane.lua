--##############################
--##### TRIP'S ARCANE MAGE #####
--##############################

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

Action[ACTION_CONST_MAGE_ARCANE] = {
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
    FireBlast		     		= Action.Create({ Type = "Spell", ID = 319836	}),	
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

	--Arcane Spells
    AlterTime		     		= Action.Create({ Type = "Spell", ID = 342245	}),	
    ArcaneBarrage	     		= Action.Create({ Type = "Spell", ID = 44425	}),
    ArcaneBlast		     		= Action.Create({ Type = "Spell", ID = 30451	}),	
    ArcaneMissiles	     		= Action.Create({ Type = "Spell", ID = 5143		}),	
    ArcanePower		     		= Action.Create({ Type = "Spell", ID = 12042	}),	
    ConjureManaGem	     		= Action.Create({ Type = "Spell", ID = 759		}),	
    Evocation		     		= Action.Create({ Type = "Spell", ID = 12051	}),	
    GreaterInvisibility    		= Action.Create({ Type = "Spell", ID = 110959	}),
    PresenceofMind	     		= Action.Create({ Type = "Spell", ID = 205025	}),
    PrismaticBarrier     		= Action.Create({ Type = "Spell", ID = 235450	}),
    Slow			     		= Action.Create({ Type = "Spell", ID = 31589	}),
    TouchoftheMagi	     		= Action.Create({ Type = "Spell", ID = 321507	}),
    TouchoftheMagiDebuff   		= Action.Create({ Type = "Spell", ID = 210824	}),	
    Clearcasting	     		= Action.Create({ Type = "Spell", ID = 79684, Hidden = true	}),	
    ClearcastingBuff     		= Action.Create({ Type = "Spell", ID = 263725, Hidden = true	}),	

	--Normal Talents
    Amplification	     		= Action.Create({ Type = "Spell", ID = 236628, Hidden = true	}),	
    RuleofThrees	     		= Action.Create({ Type = "Spell", ID = 264354, Hidden = true	}),
    RuleofThreesBuff     		= Action.Create({ Type = "Spell", ID = 264774, Hidden = true	}),	
    ArcaneFamiliar	     		= Action.Create({ Type = "Spell", ID = 205022	}),	
    MasterofTime	     		= Action.Create({ Type = "Spell", ID = 342249, Hidden = true	}),
    Shimmer			     		= Action.Create({ Type = "Spell", ID = 263725	}),	
    Slipstream		     		= Action.Create({ Type = "Spell", ID = 236457, Hidden = true	}),
    IncantersFlow	     		= Action.Create({ Type = "Spell", ID = 1463, Hidden = true		}),	
    FocusMagic		     		= Action.Create({ Type = "Spell", ID = 321358	}),
    RuneofPower		     		= Action.Create({ Type = "Spell", ID = 116011	}),	
    Resonance		     		= Action.Create({ Type = "Spell", ID = 205028, Hidden = true	}),	
    ArcaneEcho		     		= Action.Create({ Type = "Spell", ID = 342231, Hidden = true	}),
    NetherTempest	     		= Action.Create({ Type = "Spell", ID = 114923	}),	
    ChronoShift		     		= Action.Create({ Type = "Spell", ID = 235711, Hidden = true	}),
    IceWard			     		= Action.Create({ Type = "Spell", ID = 205036, Hidden = true	}),
    RingofFrost		     		= Action.Create({ Type = "Spell", ID = 113724	}),
    Reverberate		     		= Action.Create({ Type = "Spell", ID = 281482, Hidden = true	}),	
    ArcaneOrb		     		= Action.Create({ Type = "Spell", ID = 153626	}),		
    Supernova		     		= Action.Create({ Type = "Spell", ID = 157980	}),	
    Overpowered     			= Action.Create({ Type = "Spell", ID = 155147, Hidden = true	}),
    TimeAnomaly		     		= Action.Create({ Type = "Spell", ID = 210805, Hidden = true	}),
    Enlightened		     		= Action.Create({ Type = "Spell", ID = 321387, Hidden = true	}),		

	--PvP Talents
		

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

	-- Arcane Legendaries

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

	--Extra
	StopCast                        = Action.Create({ Type = "Spell", ID = 61721, Hidden = true     }),	

}
local A = setmetatable(Action[ACTION_CONST_MAGE_ARCANE], { __index = Action })

local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end

local player = "player"
local target = "target"
local mouseover = "mouseover"

local Temp = {
    TotalAndPhys                            = {"TotalImun", "DamagePhysImun"},
	TotalAndCC                              = {"TotalImun", "CCTotalImun"},
    TotalAndPhysKick                        = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC                       = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun                     = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun                = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMag                             = {"TotalImun", "DamageMagicImun"},
	TotalAndMagKick                         = {"TotalImun", "DamageMagicImun", "KickImun"},
    TotalAndMagAndCC                        = {"TotalImun", "DamageMagicImun", "CCTotalImun"},	
    DisablePhys                             = {"TotalImun", "DamagePhysImun", "Freedom", "CCTotalImun"},
    DisableMag                              = {"TotalImun", "DamageMagicImun", "Freedom", "CCTotalImun"},
	BurnPhase								= false,
	MiniBurnPhase							= false,
	ConservePhase							= false
}

local IsIndoors, UnitIsUnit = IsIndoors, UnitIsUnit

local function IsSchoolFree()
	return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "ARCANE") == 0
end 

local function InRange(unit)
	-- @return boolean 
	return A.ArcaneBlast:IsInRange(unit)
end 
InRange = A.MakeFunctionCachedDynamic(InRange)

--Register Toaster
Toaster:Register("TripToast", function(toast, ...)
        local title, message, spellID = ...
        toast:SetTitle(title or "nil")
        toast:SetText(message or "nil")
        if spellID then 
            if type(spellID) ~= "number" then 
                error(tostring(spellID) .. " (spellID) is not a number for TripToast!")
                toast:SetIconTexture("Interface\FriendsFrame\Battlenet-WoWicon")
            else 
                toast:SetIconTexture((GetSpellTexture(spellID)))
            end 
        else 
            toast:SetIconTexture("Interface\FriendsFrame\Battlenet-WoWicon")
        end 
        toast:SetUrgencyLevel("normal") 
end)


-- Non GCD spell check
local function countInterruptGCD(unit)
    if not A.CounterSpell:IsReadyByPassCastGCD(unit) or not A.CounterSpell:AbsentImun(unit, Temp.TotalAndMagKick) then
	    return true
	end
end

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
    local DBM = A.GetToggle(1, "DBM")
    local UseRacial = A.GetToggle(1, "Racial")
    local UsePotion = A.GetToggle(1, "Potion")
	local UseCovenant = A.GetToggle(1, "Covenant")
	local UseAoE = A.GetToggle(2, "AoE")
	local UseArcaneIntellect = A.GetToggle(2, "ArcaneIntellect")
	local InRange = InRange()

    ------------------------------------------------------
    ---------------- ENEMY UNIT ROTATION -----------------
    ------------------------------------------------------
    local function EnemyRotation(unitID)
	
		local function Interrupt()
		local EnemiesCasting = MultiUnits:GetByRangeCasting(10, 5, true)

			useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, nil, nil, countInterruptGCD(unit))
			if castRemainsTime >= A.GetLatency() then
				if useKick and not notInterruptable and A.CounterSpell:IsReady(unit) then 
					return A.CounterSpell:Show(icon)
				end	
				
			end
		end	
	
		local function Defensives()
		
			if Unit(player):HealthPercent() <= 40 and Unit(player):TimeToDie() <= Unit(unit):TimeToDie() then
				return A.IceBlock:Show(icon)
			end
			
			local AlterTimeActive = A.AlterTime:GetSpellTimeSinceLastCast() < 10
			if combatTime > 2 and Unit(unit):HealthPercentLosePerSecond() >= 10 and not AlterTimeActive then
				return A.AlterTime:Show(icon)
			end
			
			if AlterTimeActive and Unit(player):HealthPercent() <= 25 then
				return A.AlterTime:Show(icon)
			end
		
		end
	
		local function Opener()
			

		
		end
		
		local function BurnPhase()
		
			if A.Trinket1:IsReady(unitID) and InRange then
				return A.Trinket1:Show(icon)
			end
			
			if A.Trinket2:IsReady(unitID) and InRange then
				return A.Trinket2:Show(icon)
			end
			
			if A.Berserking:IsReady(player) and InRange and UseRacial then
				return A.Berserking:Show(icon)
			end
			
			if A.BloodFury:IsReady(player) and InRange and UseRacial then
				return A.BloodFury:Show(icon)
			end

			if A.AncestralCall:IsReady(player) and InRange and UseRacial then
				return A.AncestralCall:Show(icon)
			end		

			if A.NetherTempest:IsReady(unit) and Player:ArcaneCharges() == 4 and (Player:GetDeBuffsUnitCount(A.NetherTempest.ID) < 1 or Unit(unit):HasDeBuffs(A.NetherTempest.ID, true) < 3) then
				return A.NetherTempest:Show(icon)
			end
			
			if A.Deathborne:IsReady(player) and UseCovenant and InRange and not isMoving and (Unit(unit):TimeToDie() > 25 or Unit(unit):IsBoss()) then
				return A.Deathborne:Show(icon)
			end
			
			if A.MirrorsofTorment:IsReady(unit) and UseCovenant and not isMoving and (Unit(unit):TimeToDie() > 25 or Unit(unit):IsBoss()) then
				return A.MirrorsofTorment
			end
			
			if A.RadiantSpark:IsReady(unit) and UseCovenant and not isMoving and (Unit(unit):TimeToDie() > 10 or Unit(unit):IsBoss()) then
				return A.RadiantSpark:Show(icon)
			end
			
			if A.TouchoftheMagi:IsReady(unit) and not isMoving then
				return A.TouchoftheMagi:Show(icon)
			end
			
			if A.ArcanePower:IsReady(player) and InRange then
				return A.ArcanePower:Show(icon)
			end
			
			if A.ArcaneMissiles:IsReady(unit) and (not isMoving or A.Slipstream:IsTalentLearned()) and A.ArcaneEcho:IsTalentLearned() and Unit(unit):HasDeBuffs(A.TouchoftheMagiDebuff.ID, true) > 0 then
				return A.ArcaneMissiles:Show(icon)
			end

			if A.PresenceofMind:IsReady(unit) and not A.ArcaneEcho:IsTalentLearned() and Unit(unit):HasDeBuffs(A.TouchoftheMagiDebuff.ID, true) < Player:Execute_Time(A.ArcaneBlast.ID) * 3 then
				return A.PresenceofMind:Show(icon)
			end	
			
			if A.ArcaneBlast:IsReady(unit) and (not isMoving or Unit(player):HasBuff(A.PresenceofMind.ID, true) > 0) and not A.ArcaneEcho:IsTalentLearned() and Unit(unit):HasDeBuffs(A.TouchoftheMagiDebuff.ID, true) > Player:Execute_Time(A.ArcaneBlast.ID) then
				return A.ArcaneBlast:Show(icon)
			end	

			if A.RuneofPower:IsReady(player) and InRange and not isMoving and Unit(player):HasBuffs(A.ArcanePower.ID, true) == 0 then
				return A.RuneofPower:Show(icon)
			end
			
			if A.ArcaneMissiles:IsReady(unit) and (not isMoving or A.Slipstream:IsTalentLearned()) and Unit(player):HasBuffs(A.ClearcastingBuff.ID, true) > 0 then
				return A.ArcaneMissiles:Show(icon)
			end
			
			if A.ArcaneBlast:IsReady(unit) and (not isMoving or Unit(player):HasBuff(A.PresenceofMind.ID, true) > 0) then
				return A.ArcaneBlast:Show(icon)
			end
			
			if Player:ManaPercentage() < 15 then
				Temp.BurnPhase = false
			end
		
		end
		
		local function MiniBurnPhase()
		
			if A.NetherTempest:IsReady(unit) and Player:ArcaneCharges() == 4 and (Player:GetDeBuffsUnitCount(A.NetherTempest.ID) < 1 or Unit(unit):HasDeBuffs(A.NetherTempest.ID, true) < 3) then
				return A.NetherTempest:Show(icon)
			end

			if A.RadiantSpark:IsReady(unit) and UseCovenant and not isMoving and (Unit(unit):TimeToDie() > 10 or Unit(unit):IsBoss()) then
				return A.RadiantSpark:Show(icon)
			end
			
			if A.TouchoftheMagi:IsReady(unit) and not isMoving then
				return A.TouchoftheMagi:Show(icon)
			end		
			
			if A.RuneofPower:IsReady(player) and not isMoving and Unit(player):HasBuffs(A.ArcanePower.ID, true) == 0 then
				return A.RuneofPower:Show(icon)
			end

			if A.PresenceofMind:IsReady(unit) and not A.ArcaneEcho:IsTalentLearned() and Unit(unit):HasDeBuffs(A.TouchoftheMagiDebuff.ID, true) < Player:Execute_Time(A.ArcaneBlast.ID) * 3 and A.ArcanePower:GetCooldown() > 60 then
				return A.PresenceofMind:Show(icon)
			end	
			
			if A.ArcaneBlast:IsReady(unit) and (not isMoving or Unit(player):HasBuff(A.PresenceofMind.ID, true) > 0) and not A.ArcaneEcho:IsTalentLearned() and Unit(unit):HasDeBuffs(A.TouchoftheMagiDebuff.ID, true) > Player:Execute_Time(A.ArcaneBlast.ID) then
				return A.ArcaneBlast:Show(icon)
			end	

			if A.ArcaneMissiles:IsReady(unit) and (not isMoving or A.Slipstream:IsTalentLearned()) and Unit(player):HasBuffs(A.ClearcastingBuff.ID, true) > 0 then
				return A.ArcaneMissiles:Show(icon)
			end
			
			if A.ArcaneBlast:IsReady(unit) and (not isMoving or Unit(player):HasBuff(A.PresenceofMind.ID, true) > 0) then
				return A.ArcaneBlast:Show(icon)
			end
			
			if Player:ManaPercentage() < 30 then
				Temp.MiniBurnPhase = false
			end
		
		end
		
		local function ConservePhase()
			
			if A.ShiftingPower:IsReady(player) and not isMoving and UseCovenant and Unit(unit):GetRange() <= 15 and A.Evocation:GetCooldown() > 5 then
				return A.ShiftingPower:Show(icon)
			end
			
			if A.NetherTempest:IsReady(unit) and Player:ArcaneCharges() == 4 and (Player:GetDeBuffsUnitCount(A.NetherTempest.ID) < 1 or Unit(unit):HasDeBuffs(A.NetherTempest.ID, true) < 3) then
				return A.NetherTempest:Show(icon)
			end
			
			if A.ArcaneOrb:IsReady(player) and InRange and Player:ArcaneCharges() < 4 then
				return A.ArcaneOrb:Show(icon)
			end
			
			if A.ArcaneBlast:IsReady(unit) and (not isMoving or Unit(player):HasBuff(A.PresenceofMind.ID, true) > 0) and Unit(player):HasBuff(A.RuleofThreesBuff.ID, true) > 0 then
				return A.ArcaneBlast:Show(icon)
			end
			
			if A.ArcaneMissiles:IsReady(unit) and (not isMoving or A.Slipstream:IsTalentLearned()) and Unit(player):HasBuffs(A.ClearcastingBuff.ID, true) > 0 then
				return A.ArcaneMissiles:Show(icon)
			end

			if A.ArcaneBarrage:IsReady(unit) and Player:ArcaneCharges() == 4 and Player:ManaPercentage() < 60 then
				return A.ArcaneBarrage:Show(icon)
			end
			
			if A.Supernova:IsReady(unit) then
				return A.Supernova:Show(icon)
			end
			
			if A.ArcaneBlast:IsReady(unit) and (not isMoving or Unit(player):HasBuff(A.PresenceofMind.ID, true) > 0) then
				return A.ArcaneBlast:Show(icon)
			end
		
		end

		if Player:IsCasting() == A.Evocation:Info() and Player:ManaPercentage() > 95 then
			return A.StopCast:Show(icon)
		end

		if A.ArcanePower:GetCooldown() < 1 and A.TouchoftheMagi:GetCooldown() < 1 and ((A.RuneofPower:IsTalentLearned() and A.RuneofPower:GetCooldown() < 15) or not A.RuneofPower:IsTalentLearned()) and Player:ManaPercentage() > 15 and BurstIsON(unit) then
			Temp.BurnPhase = true
		end
		
		if A.TouchoftheMagi:GetCooldown() < 1 and ((A.RuneofPower:IsTalentLearned() and A.RuneofPower:GetCooldown() < 1) or not A.RuneofPower:IsTalentLearned()) and Player:ManaPercentage() > 30 then
			Temp.MiniBurnPhase = true
		end

		if A.PrismaticBarrier:IsReady(player) and (not inCombat or Unit(player):HealthPercent() <= 70) and Unit(player):HasBuffs(A.PrismaticBarrier.ID, true) < 2 and Unit(player):HasBuffs(A.Invisibility.ID, true) == 0 then
			return A.PrismaticBarrier:Show(icon)
		end

		if A.Evocation:IsReady(player) and (not isMoving or A.Slipstream:IsTalentLearned()) and Player:ManaPercentage() < 15 then
			return A.Evocation:Show(icon)
		end
		
		if A.IsUnitEnemy(unitID) and Unit(player):HasBuffs(A.Invisibility.ID, true) == 0 then
		
			if Interrupt() then
				return true
			end
			
			if Temp.BurnPhase then
				A.Toaster:SpawnByTimer("TripToast", 0, "Burn Phase!", "Burning!", A.ArcaneBlast.ID)
				return BurnPhase()
			end
			
			if Temp.MiniBurnPhase then
				A.Toaster:SpawnByTimer("TripToast", 0, "Mini Burn Phase!", "Mini Burning!", A.ArcaneBarrage.ID)
				return MiniBurnPhase()
			end

			if ConservePhase() then 
				A.Toaster:SpawnByTimer("TripToast", 0, "Conserve Phase", "Conserving!", A.Evocation.ID)
				return true
			end


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


