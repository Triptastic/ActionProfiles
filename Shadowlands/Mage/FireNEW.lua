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
    AlterTime		     		= Action.Create({ Type = "Spell", ID = 108978	}),	

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
    PyroclasmBuff	     		= Action.Create({ Type = "Spell", ID = 269651, Hidden = true	}),		
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

    ------------------------------------------------------
    ---------------- ENEMY UNIT ROTATION -----------------
    ------------------------------------------------------
    local function EnemyRotation(unitID)
	
		local function Interrupt()

			useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, nil, nil, countInterruptGCD(unit))
			if castRemainsTime >= A.GetLatency() then
				if useKick and not notInterruptable and A.CounterSpell:IsReady(unit) then 
					return A.CounterSpell:Show(icon)
				end	
			end
		end	
	
		local function Defensives()
		
			if Unit(player):HealthPercent() <= 40 and Unit(player):TimeToDie() <= Unit(unit):TimeToDie() and A.Cauterize:GetCooldown() > 0 then
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
			
			if Pull < (Player:Execute_Time(A.Pyroblast.ID) + A.GetGCD()) then
				if A.MirrorImage:IsReady(unitID) and A.BurstIsON(unitID) then
					return A.MirrorImage:Show(icon)
				end
			end
		
			if Pull < (Player:Execute_Time(A.Pyroblast.ID) + A.GetGCD()) then
				if A.Pyroblast:IsReady(unitID) then
					return A.Pyroblast:Show(icon)
				end
			end
		
		end
		
		local function NoCombustion()
		
			if A.Combustion:IsReady(unit, nil, nil, true) and BurstIsON(unit) and A.FireBlast:GetSpellCharges() >= 2 and A.PhoenixFlames:GetSpellCharges() >= 2 and (A.Meteor:GetCooldown() > 2 or not A.Meteor:IsTalentLearned()) and (A.Firestarter:IsTalentLearned() and Unit(unit):HealthPercent() < 90 or not A.Firestarter:IsTalentLearned()) and (Player:AreaTTD(40) >= 12 or Unit(unit):IsBoss()) then
				if combatTime > 5 then
					if Unit(player):HasBuffs(A.HeatingUp.ID, true) > 0 then
						return A.Combustion:Show(icon)
					end
				elseif combatTime <= 5 then
					return A.Combustion:Show(icon)
				end
			end
		
			if A.RuneofPower:IsReady(player) and Player:IsStayingTime() > 0.2 and Player:AreaTTD(40) > 12 and Unit(player):HasBuffs(A.RuneofPowerBuff.ID, true) == 0 and (A.Combustion:GetCooldown() >= 10 or A.Firestarter:IsTalentLearned() and Unit(unit):HealthPercent() > 90) then
				return A.RuneofPower:Show(icon)
			end
			
			if A.DragonsBreath:IsReady(player) and MultiUnits:GetByRange(10, 3) >= 3 then
				return A.DragonsBreath:Show(icon)
			end
			
			if A.Pyroblast:IsReady(unit) and not isMoving and Unit(player):HasBuffs(A.PyroclasmBuff.ID, true) > Player:Execute_Time(A.Pyroblast.ID) and Unit(unit):TimeToDie() > Player:Execute_Time(A.Pyroblast.ID) and A.LastPlayerCastID ~= A.Pyroblast.ID then
				A.Toaster:SpawnByTimer("TripToast", 0, "Hardcasting!", "Hardcasting Pyroblast with Pyroclasm!", A.Pyroblast.ID)
				return A.Pyroblast:Show(icon)
			end
			
			if A.Meteor:IsReady(player) and (Unit(player):HasBuffs(A.RuneofPowerBuff.ID, true) or A.Combustion:GetCooldown() < A.GetGCD()) and Player:AreaTTD(40) > 10 then
				A.Toaster:SpawnByTimer("TripToast", 0, "Meteor!", "Using Meteor!", A.Meteor.ID)			
				return A.Meteor:Show(icon)
			end
		
			if A.PhoenixFlames:IsReady(unit) and (A.PhoenixFlames:GetSpellChargesFullRechargeTime() <= 2 or A.PhoenixFlames:GetSpellCharges() == A.PhoenixFlames:GetSpellChargesMax()) then
				return A.PhoenixFlames:Show(icon)
			end
			
			if A.FireBlast:IsReady(unit, nil, nil, true) and (A.FireBlast:GetSpellChargesFullRechargeTime() <= 2 or A.FireBlast:GetSpellChargesFullRechargeTime() <= 4 and Unit(player):HasBuffs(A.HeatingUp.ID, true) > 0 or A.FireBlast:GetSpellCharges() == A.FireBlast:GetSpellChargesMax()) then
				return A.FireBlast:Show(icon)
			end
			
			if A.Flamestrike:IsReady(player) and ((MultiUnits:GetActiveEnemies() >= 2 and A.FlamePatch:IsTalentLearned()) or MultiUnits:GetActiveEnemies() >= 3) and Unit(player):HasBuffs(A.HotStreakBuff.ID, true) > 0 then
				A.Toaster:SpawnByTimer("TripToast", 0, "Flamestrike!", "Keep your cursor on your enemies!", A.Flamestrike.ID)				
				return A.Flamestrike:Show(icon)
			end
			
			if A.Pyroblast:IsReady(unit) and Unit(player):HasBuffs(A.HotStreakBuff.ID, true) > 0 then
				return A.Pyroblast:Show(icon)
			end
			
			if A.FireBlast:IsReady(unit, nil, nil, true) and Unit(player):HasBuffs(A.HeatingUp.ID, true) > 0 and A.Combustion:GetCooldown() >= A.FireBlast:GetSpellChargesFullRechargeTime() then
				return A.FireBlast:Show(icon)
			end
			
			if A.Scorch:IsReady(unit) and A.SearingTouch:IsTalentLearned() and Unit(unit):HealthPercent() <= 30 then
				return A.Scorch:Show(icon)
			end
			
			if A.Flamestrike:IsReady(player) and A.FlamePatch:IsTalentLearned() and not isMoving and MultiUnits:GetActiveEnemies() >= 2 and Player:AreaTTD(40) >= 10 then
				A.Toaster:SpawnByTimer("TripToast", 0, "Hardcasting Flamestrike!", "Calculated to be worth it to hardcast right now!", A.Flamestrike.ID)	
				return A.Flamestrike:Show(icon)
			end
			
			if A.Fireball:IsReady(unit) and not isMoving then
				return A.Fireball:Show(icon)
			end 
			
			if A.Scorch:IsReady(unit) and isMoving then
				return A.Scorch:Show(icon)
			end
		
		end
		
		local function Combustion()
		
			if A.Trinket1:IsReady(unitID) then
				return A.Trinket1:Show(icon)
			end
			
			if A.Trinket2:IsReady(unitID) then
				return A.Trinket2:Show(icon)
			end
			
			if A.Berserking:IsReady(player) and UseRacial then
				return A.Berserking:Show(icon)
			end
			
			if A.BloodFury:IsReady(player) and UseRacial then
				return A.BloodFury:Show(icon)
			end

			if A.AncestralCall:IsReady(player) and UseRacial then
				return A.AncestralCall:Show(icon)
			end			
		
			if A.Meteor:IsReady(player) and (Unit(player):HasBuffs(A.RuneofPowerBuff.ID, true) or A.Combustion:GetCooldown() < A.GetGCD()) and Player:AreaTTD(40) > 10 then
				A.Toaster:SpawnByTimer("TripToast", 0, "Meteor!", "Using Meteor!", A.Meteor.ID)			
				return A.Meteor:Show(icon)
			end
			
			if A.Pyroblast:IsReady(unit) and not isMoving and Unit(player):HasBuffs(A.PyroclasmBuff.ID, true) > Player:Execute_Time(A.Pyroblast.ID) and Unit(unit):TimeToDie() < Player:Execute_Time(A.Pyroblast.ID) then
				A.Toaster:SpawnByTimer("TripToast", 0, "Hardcasting!", "Hardcasting Pyroblast with Pyroclasm!", A.Pyroblast.ID)
				return A.Pyroblast:Show(icon)
			end
			
			if A.Flamestrike:IsReady(unit) and Unit(player):HasBuffs(A.HotStreakBuff.ID, true) > 0 and ((MultiUnits:GetActiveEnemies() >= 3 and A.FlamePatch:IsTalentLearned()) or MultiUnits:GetActiveEnemies() >= 6) then
				A.Toaster:SpawnByTimer("TripToast", 0, "Flamestrike!", "Keep your cursor on your enemies!", A.Flamestrike.ID)
				return A.Flamestrike:Show(icon)
			end
			
			if A.Pyroblast:IsReady(unit) and Unit(player):HasBuffs(A.HotStreakBuff.ID, true) > 0 then
				return A.Pyroblast:Show(icon)
			end
		
			if A.FireBlast:IsReady(unit) and Unit(player):HasBuffs(A.HeatingUp.ID, true) > 0 and A.FireBlast:GetSpellCharges() == A.FireBlast:GetSpellChargesMax() then
				return A.FireBlast:Show(icon)
			end	

			if A.PhoenixFlames:IsReady(unit) and Unit(player):HasBuffs(A.HeatingUp.ID, true) > 0 and A.PhoenixFlames:GetSpellCharges() == A.PhoenixFlames:GetSpellChargesMax() then
				return A.PhoenixFlames:Show(icon)
			end		
			
			if A.FireBlast:IsReady(unit) and Unit(player):HasBuffs(A.HeatingUp.ID, true) > 0 then
				return A.FireBlast:Show(icon)
			end	

			if A.PhoenixFlames:IsReady(unit) and Unit(player):HasBuffs(A.HeatingUp.ID, true) > 0 then
				return A.PhoenixFlames:Show(icon)
			end				

			if A.Scorch:IsReady(unit) then
				return A.Scorch:Show(icon)
			end
		
		end
		
		local function CovenantCall()
		
			if A.RadiantSpark:IsReady(unit) and Unit(unit):TimeToDie() >= 10 then
				return A.RadiantSpark:Show(icon)
			end
			
			if A.MirrorsofTorment:IsReady(unit) and ((Unit(player):HasBuffs(A.Combustion.ID, true) > 0 and Unit(unit):TimeToDie() >= 10) or A.Combustion:GetCooldown() >= Unit(unit):TimeToDie() and Unit(unit):IsBoss()) then
				return A.MirrorsofTorment:Show(icon)
			end
			
			if A.ShiftingPower:IsReady(player) and Unit(player):HasBuffs(A.Combustion.ID, true) == 0 and A.FireBlast:GetSpellChargesFrac() < 1.5 and Unit(unit):GetRange() <= 15 then
				return A.ShiftingPower:Show(icon)
			end
			
			if A.Deathborne:IsReady(unit) and ((Unit(player):HasBuffs(A.Combustion.ID, true) > 0 and Unit(unit):TimeToDie() >= 10) or A.Combustion:GetCooldown() >= Unit(unit):TimeToDie() and Unit(unit):IsBoss()) then
				return A.Deathborne:Show(icon)
			end
		
		end
	
	if (not inCombat or Unit(player):HealthPercent() <= 70) and Unit(player):HasBuffs(A.BlazingBarrier.ID, true) < 2 and Unit(player):HasBuffs(A.Invisibility.ID, true) == 0 then
		return A.BlazingBarrier:Show(icon)
	end
	
	if not inCombat then
		if DBM and Opener() then
			return true
		elseif not DBM then
			return A.Fireball:Show(icon)
		end
	end
	
	if A.IsUnitEnemy(unitID) and Unit(player):HasBuffs(A.Invisibility.ID, true) == 0 then
		if inCombat then
		
			if Interrupt() then
				return true
			end
			
			if UseCovenant then
				if CovenantCall() then
					return true
				end
			end
			
			if Unit(player):HasBuffs(A.Combustion.ID, true) == 0 then
				return NoCombustion()
			end
			
			if Unit(player):HasBuffs(A.Combustion.ID, true) > 0 then
				return Combustion()
			end
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


