--#############################
--##### TRIP'S FROST MAGE #####
--#############################

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

Action[ACTION_CONST_MAGE_FROST] = {
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
    Frostbolt		     		= Action.Create({ Type = "Spell", ID = 116		}),	
    IceBlock		     		= Action.Create({ Type = "Spell", ID = 45438	}),	
    Invisibility	     		= Action.Create({ Type = "Spell", ID = 66		}),
    MirrorImage		     		= Action.Create({ Type = "Spell", ID = 55342	}),
    Polymorph		     		= Action.Create({ Type = "Spell", ID = 118		}),	
    RemoveCurse		     		= Action.Create({ Type = "Spell", ID = 475		}),
    SlowFall		     		= Action.Create({ Type = "Spell", ID = 130		}),
    Spellsteal		     		= Action.Create({ Type = "Spell", ID = 30449	}),
    TimeWarp		     		= Action.Create({ Type = "Spell", ID = 80353	}),
    AlterTime		     		= Action.Create({ Type = "Spell", ID = 108978	}),	
    FireBlast		     		= Action.Create({ Type = "Spell", ID = 319836	}),		
    Exhaustion		     		= Action.Create({ Type = "Spell", ID = 80354, Hidden = true	}),			

	--Frost Spells
    Blizzard		     		= Action.Create({ Type = "Spell", ID = 190356	}),
    ColdSnap		     		= Action.Create({ Type = "Spell", ID = 235219	}),	
    ConeofCold		     		= Action.Create({ Type = "Spell", ID = 120		}),
    Flurry			     		= Action.Create({ Type = "Spell", ID = 44614	}),
    WintersChill	     		= Action.Create({ Type = "Spell", ID = 228358	}),	
    FrozenOrb		     		= Action.Create({ Type = "Spell", ID = 84714	}),	
    IceBarrier		     		= Action.Create({ Type = "Spell", ID = 11426	}),	
    IceLance		     		= Action.Create({ Type = "Spell", ID = 30455	}),
    IcyVeins		     		= Action.Create({ Type = "Spell", ID = 12472	}),
	SummonWaterElemental		= Action.Create({ Type = "Spell", ID = 31687	}),
    BrainFreeze		     		= Action.Create({ Type = "Spell", ID = 190447, Hidden = true	}),
    BrainFreezeBuff	     		= Action.Create({ Type = "Spell", ID = 190446, Hidden = true	}),	
    FingersofFrost	     		= Action.Create({ Type = "Spell", ID = 112965, Hidden = true	}),	
    FingersofFrostBuff     		= Action.Create({ Type = "Spell", ID = 44544, Hidden = true		}),		
    Icicles			     		= Action.Create({ Type = "Spell", ID = 205473, Hidden = true	}),	

	--Normal Talents
    Bonechilling	     		= Action.Create({ Type = "Spell", ID = 205027, Hidden = true	}),
    LonelyWinter	     		= Action.Create({ Type = "Spell", ID = 205024, Hidden = true	}),	
    IceNova			     		= Action.Create({ Type = "Spell", ID = 157997	}),
    GlacialInsulation	   		= Action.Create({ Type = "Spell", ID = 235297, Hidden = true	}),
    Shimmer			     		= Action.Create({ Type = "Spell", ID = 212653	}),		
    IceFloes		     		= Action.Create({ Type = "Spell", ID = 108839	}),		
    IncanctersFlow	     		= Action.Create({ Type = "Spell", ID = 1463, Hidden = true		}),	
    FocusMagic		     		= Action.Create({ Type = "Spell", ID = 321358	}),
    RuneofPower		     		= Action.Create({ Type = "Spell", ID = 116011	}),
    RuneofPowerBuff    			= Action.Create({ Type = "Spell", ID = 116014, Hidden = true	}),		
    FrozenTouch		     		= Action.Create({ Type = "Spell", ID = 205030, Hidden = true	}),	
    ChainReaction	     		= Action.Create({ Type = "Spell", ID = 278309, Hidden = true	}),
    Ebonbolt		     		= Action.Create({ Type = "Spell", ID = 257537	}),	
    FrigidWinds		     		= Action.Create({ Type = "Spell", ID = 235224, Hidden = true	}),	
    IceWard			     		= Action.Create({ Type = "Spell", ID = 205036, Hidden = true	}),	
    RingofFrost		     		= Action.Create({ Type = "Spell", ID = 112965	}),	
    FreezingRain	     		= Action.Create({ Type = "Spell", ID = 270233, Hidden = true	}),	
    FreezingRainBuff     		= Action.Create({ Type = "Spell", ID = 270232, Hidden = true	}),		
    SplittingIce	     		= Action.Create({ Type = "Spell", ID = 56377, Hidden = true	}),	
    CometStorm		     		= Action.Create({ Type = "Spell", ID = 153595	}),		
    ThermalVoid		     		= Action.Create({ Type = "Spell", ID = 155149, Hidden = true	}),	
    RayofFrost		     		= Action.Create({ Type = "Spell", ID = 205021	}),		
    GlacialSpike	     		= Action.Create({ Type = "Spell", ID = 199786	}),		

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
	DisciplinaryCommand			= Action.Create({ Type = "Spell", ID = 327365, Hidden = true	}),

	-- Frost Legendaries
	GlacialFragments			= Action.Create({ Type = "Spell", ID = 327492, Hidden = true	}),
	SlickIce					= Action.Create({ Type = "Spell", ID = 327511, Hidden = true	}),	
	TemporalWarp				= Action.Create({ Type = "Spell", ID = 327351, Hidden = true	}),		
	FreezingWinds				= Action.Create({ Type = "Spell", ID = 327364, Hidden = true	}),			
	
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
local A = setmetatable(Action[ACTION_CONST_MAGE_FROST], { __index = Action })

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
}

local IsIndoors, UnitIsUnit = IsIndoors, UnitIsUnit

local function IsSchoolFree()
	return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "FIRE") == 0
end 

local function InRange(unit)
	-- @return boolean 
	return A.Frostbolt:IsInRange(unit)
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
		local EnemiesCasting = MultiUnits:GetByRangeCasting(10, 5, true)

			useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, nil, nil, countInterruptGCD(unit))
			if castRemainsTime >= A.GetLatency() then
				if useKick and not notInterruptable and A.CounterSpell:IsReady(unit) then 
					return A.CounterSpell:Show(icon)
				end	
				
				if useKick and A.CounterSpell:GetCooldown() > 0 and EnemiesCasting > 1 and A.DragonsBreath:AbsentImun(unit, Temp.TotalAndMagAndCC, true) then
					return A.DragonsBreath:Show(icon)
				end
				
			end
		end	
	
		local function Defensives()
		
			if Unit(player):HealthPercent() <= 40 and Unit(player):TimeToDie() <= Unit(unit):TimeToDie() and Unit(player):HasDeBuffs(A.CauterizeDebuff.ID, true) > 0 then
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

		local function AoERotation()
		
			-- actions.aoe=frozen_orb
			if A.FrozenOrb:IsReady(player) and Unit(unit):GetRange() <= 40 then
				return A.FrozenOrb:Show(icon)
			end
			
			-- actions.aoe+=/blizzard
			if A.Blizzard:IsReady(player) and (not isMoving or Unit(player):HasBuffs(A.IceFloes.ID, true) > 0 or Unit(player):HasBuffs(A.FreezingRainBuff.ID, true) > 0) and Unit(unit):GetRange() <= 40 then
				return A.Blizzard:Show(icon)
			end
			
			-- actions.aoe+=/flurry,if=(remaining_winters_chill=0|debuff.winters_chill.down)&(prev_gcd.1.ebonbolt|buff.brain_freeze.react&buff.fingers_of_frost.react=0)
			if A.Flurry:IsReady(unit) and (not isMoving or Unit(player):HasBuffs(A.IceFloes.ID, true) > 0) and Unit(unit):HasDeBuffs(A.WintersChill.ID, true) == 0 and (A.LastPlayerCastName == A.Ebonbolt:Info() or (Unit(player):HasBuffs(A.BrainFreezeBuff.ID, true) > 0 and Unit(player):HasBuffs(A.FingersofFrostBuff.ID, true) == 0)) then
				return A.Flurry:Show(icon)
			end
			
			-- actions.aoe+=/ice_nova
			if A.IceNova:IsReady(player) and MultiUnits:GetByRange(10, 3) >= 3 then
				return A.IceNova:Show(icon)
			end
			
			-- actions.aoe+=/comet_storm
			if A.CometStorm:IsReady(unit) then
				return A.CometStorm:Show(icon)
			end
			
			-- actions.aoe+=/ice_lance,if=buff.fingers_of_frost.react|debuff.frozen.remains>travel_time|remaining_winters_chill&debuff.winters_chill.remains>travel_time
			if A.IceLance:IsReady(unit) and (Unit(player):HasBuffs(A.FingersofFrostBuff.ID, true) > 0 or Unit(unit):HasDeBuffs(A.WintersChill.ID, true) > 1) then
				return A.IceLance:Show(icon)
			end
			
			-- actions.aoe+=/radiant_spark
			if A.RadiantSpark:IsReady(unit) and UseCovenant and (not isMoving or Unit(player):HasBuffs(A.IceFloes.ID, true) > 0) and (Unit(unit):TimeToDie() > 10 or Unit(unit):IsBoss()) then
				return A.RadiantSpark:Show(icon)
			end
			
			-- actions.aoe+=/mirrors_of_torment
			if A.MirrorsofTorment:IsReady(unit) and UseCovenant and (not isMoving or Unit(player):HasBuffs(A.IceFloes.ID, true) > 0) and (Unit(unit):TimeToDie() > 25 or Unit(unit):IsBoss()) then
				return A.MirrorsofTorment:Show(icon)
			end
			
			-- actions.aoe+=/shifting_power
			if A.ShiftingPower:IsReady(player) and UseCovenant and (not isMoving or Unit(player):HasBuffs(A.IceFloes.ID, true) > 0) and MultiUnits:GetByRange(10, 3) >= 3 and Unit(unit):TimeToDie() > 4 then
				return A.ShiftingPower:Show(icon)
			end
			
			-- actions.aoe+=/fire_blast,if=runeforge.disciplinary_command&cooldown.buff_disciplinary_command.ready&buff.disciplinary_command_fire.down
			--if A.FireBlast:IsReady(unit) and A.DisciplinaryCommand:HasLegendaryCraftingPower()
			
			-- actions.aoe+=/arcane_explosion,if=mana.pct>30&active_enemies>=6&!runeforge.glacial_fragments
			if A.ArcaneExplosion:IsReady(player) and Player:ManaPercent() > 30 and MultiUnits:GetByRange(10, 6) >= 6 and not A.GlacialFragments:HasLegendaryCraftingPower() then
				return A.ArcaneExplosion:Show(icon)
			end
			
			-- actions.aoe+=/ebonbolt
			if A.Ebonbolt:IsReady(unit) and (not isMoving or Unit(player):HasBuffs(A.IceFloes.ID, true) > 0) then
				return A.Ebonbolt:Show(icon)
			end
			
			-- actions.aoe+=/ice_lance,if=runeforge.glacial_fragments&talent.splitting_ice&travel_time<ground_aoe.blizzard.remains
			if IceLance:IsReady(unit) and A.GlacialFragments:HasLegendaryCraftingPower() and A.SplittingIce:IsTalentLearned() then
				return A.IceLance:Show(icon)
			end
			
			-- actions.aoe+=/wait,sec=0.1,if=runeforge.glacial_fragments&talent.splitting_ice
			-- actions.aoe+=/frostbolt
			if A.Frostbolt:IsReady(unit) and (not isMoving or Unit(player):HasBuffs(A.IceFloes.ID, true) > 0) then
				return A.Frostbolt:Show(icon)
			end

		end

		local function Cooldowns()
		
			-- actions.cds=potion,if=prev_off_gcd.icy_veins|fight_remains<30
			-- actions.cds+=/deathborne
			if A.Deathborne:IsReady(player) and (not isMoving or Unit(player):HasBuffs(A.IceFloes.ID, true) > 0) and (Unit(unit):TimeToDie() >= 25 or Unit(unit):IsBoss()) then
				return A.Deathborne:Show(icon)
			end
			
			-- actions.cds+=/mirrors_of_torment,if=active_enemies<3&(conduit.siphoned_malice|soulbind.wasteland_propriety)
			if A.MirrorsofTorment:IsReady(unit) and (not isMoving or Unit(player):HasBuffs(A.IceFloes.ID, true) > 0) and MultiUnits:GetActiveEnemies() < 3 and (Unit(unit):TimeToDie() >= 25 or Unit(unit):IsBoss()) then
				return A.MirrorsofTorment:Show(icon)
			end
			
			-- actions.cds+=/rune_of_power,if=cooldown.icy_veins.remains>12&buff.rune_of_power.down
			if A.RuneofPower:IsReady(player) and (not isMoving or Unit(player):HasBuffs(A.IceFloes.ID, true) > 0) and A.IcyVeins:GetCooldown() > 12 and Unit(player):HasBuffs(A.RuneofPowerBuff.ID, true) == 0 then
				return A.RuneofPower:Show(icon)
			end
			
			-- actions.cds+=/icy_veins,if=buff.rune_of_power.down&(buff.slick_ice.down|active_enemies>=2)
			if A.IcyVeins:IsReady(player) and Unit(player):HasBuffs(A.RuneofPowerBuff.ID, true) == 0 and (Unit(player):HasBuffs(A.SlickIce.ID, true) == 0 or MultiUnits:GetActiveEnemies() >= 2) then
				return A.IcyVeins:Show(icon)
			end
			
			-- actions.cds+=/time_warp,if=runeforge.temporal_warp&buff.exhaustion.up&(prev_off_gcd.icy_veins|fight_remains<30)
			if A.TimeWarp:IsReady(player) and A.TemporalWarp:HasLegendaryCraftingPower() and Unit(player):HasDeBuffs(A.Exhaustion.ID, true) > 0 and (Unit(player):HasBuffs(A.IcyVeins.ID, true) > 0) then
				return A.TimeWarp:Show(icon)
			end
			
			-- actions.cds+=/use_items
			-- actions.cds+=/blood_fury
			if A.BloodFury:IsReady(player) and UseRacial then
				return A.BloodFury:Show(icon)
			end
			
			-- actions.cds+=/berserking
			if A.Berserking:IsReady(player) and UseRacial then
				return A.Berserking:Show(icon)
			end			
			
			-- actions.cds+=/lights_judgment
		
			
			-- actions.cds+=/fireblood
			if A.Fireblood:IsReady(player) and UseRacial then
				return A.Fireblood:Show(icon)
			end			
			
			-- actions.cds+=/ancestral_call
			if A.AncestralCall:IsReady(player) and UseRacial then
				return A.AncestralCall:Show(icon)
			end			
			
			-- actions.cds+=/bag_of_tricks

		end

		local function Movement()
		
			-- actions.movement=blink_any,if=movement.distance>10
			
			
			-- actions.movement+=/ice_floes,if=buff.ice_floes.down
			if A.IceFloes:IsReady(player) and Unit(player):HasBuffs(A.IceFloes.ID, true) == 0 then
				return A.IceFloes:Show(icon)
			end
			
			-- actions.movement+=/arcane_explosion,if=mana.pct>30&active_enemies>=2
			if A.ArcaneExplosion:IsReady(player) and Player:ManaPercent() > 30 and MultiUnits:GetByRange(10, 3) >= 2 then
				return A.ArcaneExplosion:Show(icon)
			end
			
			-- actions.movement+=/fire_blast
			if A.FireBlast:IsReady(unit) then
				return A.FireBlast:Show(icon)
			end
			
			-- actions.movement+=/ice_lance
			if A.IceLance:IsReady(unit) then
				return A.IceLance:Show(icon)
			end
			

		end

		local function ST()
		
			-- actions.st=flurry,if=(remaining_winters_chill=0|debuff.winters_chill.down)&(prev_gcd.1.ebonbolt|buff.brain_freeze.react&(prev_gcd.1.glacial_spike|prev_gcd.1.frostbolt&(!conduit.ire_of_the_ascended|cooldown.radiant_spark.remains|runeforge.freezing_winds)|prev_gcd.1.radiant_spark|buff.fingers_of_frost.react=0&(debuff.mirrors_of_torment.up|buff.freezing_winds.up|buff.expanded_potential.react)))
			if A.Flurry:IsReady(unit) and (not isMoving or Unit(player):HasBuffs(A.IceFloes.ID, true) > 0) and Unit(unit):HasDeBuffs(A.WintersChill.ID, true) == 0 and (A.LastPlayerCastName == A.Ebonbolt:Info() or A.LastPlayerCastName == A.Frostbolt:Info() and (A.RadiantSpark:GetCooldown() > 0 or A.FreezingWinds:HasLegendaryCraftingPower()) or A.LastPlayerCastName == A.RadiantSpark:Info() or Unit(unit):HasBuffs(A.FingersofFrostBuff.ID, true) == 0 and (Unit(unit):HasDeBuffs(A.MirrorsofTorment.ID, true) > 0 or Unit(player):HasBuffs(A.FreezingWinds.ID, true) > 0)) then
				return A.Flurry:Show(icon)
			end
			
			-- actions.st+=/frozen_orb
			if A.FrozenOrb:IsReady(player) and Unit(unit):GetRange() <= 40 then
				return A.FrozenOrb:Show(icon)
			end
			
			-- actions.st+=/blizzard,if=buff.freezing_rain.up|active_enemies>=2|runeforge.glacial_fragments&remaining_winters_chill=2
			if A.Blizzard:IsReady(player) and not (isMoving or Unit(unit):HasBuffs(A.IceFloes.ID, true) > 0 or Unit(player):HasBuffs(A.FreezingRainBuff.ID, true) > 0) and Unit(unit):GetRange() <= 40  and (Unit(unit):HasBuffs(A.FreezingRainBuff.ID, true) > 0 or MultiUnits:GetActiveEnemies() >= 2 or (A.GlacialFragments:HasLegendaryCraftingPower() and Unit(unit):HasDeBuffsStacks(A.WintersChill.ID, true) == 2)) then
				return A.Blizzard:Show(icon)
			end
			
			-- actions.st+=/ray_of_frost,if=remaining_winters_chill=1&debuff.winters_chill.remains
			if A.RayofFrost:IsReady(unit) and (not isMoving or Unit(player):HasBuffs(A.IceFloes.ID, true) > 0) and Unit(unit):HasDeBuffs(A.WintersChill.ID, true) > 0 then
				return A.RayofFrost:Show(icon)
			end
			
			-- actions.st+=/glacial_spike,if=remaining_winters_chill&debuff.winters_chill.remains>cast_time+travel_time
			if A.GlacialSpike:IsReady(unit) and (not isMoving or Unit(player):HasBuffs(A.IceFloes.ID, true) > 0) and Unit(unit):HasDeBuffs(A.WintersChill.ID, true) > 2 then
				return A.GlacialSpike:Show(icon)
			end
			
			-- actions.st+=/ice_lance,if=remaining_winters_chill&remaining_winters_chill>buff.fingers_of_frost.react&debuff.winters_chill.remains>travel_time
			if A.IceLance:IsReady(unit) and Unit(unit):HasDeBuffs(A.WintersChill.ID, true) > Unit(unit):HasBuffs(A.FingersofFrostBuff.ID, true) then
				return A.IceLance:Show(icon)
			end
			
			-- actions.st+=/comet_storm
			if A.CometStorm:IsReady(unit) then
				return A.CometStorm:Show(icon)
			end
			
			-- actions.st+=/ice_nova
			if A.IceNova:IsReady(unit) and Unit(unit):GetRange() < 10 then
				return A.IceNova:Show(icon)
			end
			
			-- actions.st+=/radiant_spark,if=buff.freezing_winds.up&active_enemies=1
			if A.RadiantSpark:IsReady(unit) and UseCovenant and Unit(player):HasBuffs(A.FreezingWinds.ID, true) > 0 and MultiUnits:GetActiveEnemies() == 1 then
				return A.RadiantSpark:Show(icon)
			end
			
			-- actions.st+=/ice_lance,if=buff.fingers_of_frost.react|debuff.frozen.remains>travel_time
			if A.IceLance:IsReady(unit) and Unit(player):HasBuffs(A.FingersofFrostBuff.ID, true) > 1 then
				return A.IceLance:Show(icon)
			end
			
			-- actions.st+=/ebonbolt
			if A.Ebonbolt:IsReady(unit) and (not isMoving or Unit(player):HasBuffs(A.IceFloes.ID, true) > 0) then
				return A.Ebonbolt:Show(icon)
			end
			
			-- actions.st+=/radiant_spark,if=(!runeforge.freezing_winds|active_enemies>=2)&buff.brain_freeze.react
			if A.RadiantSpark:IsReady(unit) and UseCovenant and (not isMoving or Unit(player):HasBuffs(A.IceFloes.ID, true) > 0) and (not A.FreezingWinds:HasLegendaryCraftingPower() or MultiUnits:GetActiveEnemies() >= 2) and Unit(player):HasBuffs(A.BrainFreezeBuff.ID, true) > 0 then
				return A.RadiantSpark:Show(icon)
			end
			
			-- actions.st+=/mirrors_of_torment
			if A.MirrorsofTorment:IsReady(unit) and BurstIsON(unit) and UseCovenant and (not isMoving or Unit(player):HasBuffs(A.IceFloes.ID, true) > 0) and (Unit(unit):TimeToDie() > 25 or Unit(unit):IsBoss()) then
				return A.MirrorsofTorment:Show(icon)
			end
			
			-- actions.st+=/shifting_power,if=buff.rune_of_power.down&(soulbind.grove_invigoration|soulbind.field_of_blossoms|active_enemies>=2)
			if A.ShiftingPower:IsReady(player) and UseCovenant and (not isMoving or Unit(player):HasBuffs(A.IceFloes.ID, true) > 0) and Unit(player):HasBuffs(A.RuneofPowerBuff.ID, true) == 0 and MultiUnits:GetByRange(15, 2) >= 2 then
				return A.ShiftingPower:Show(icon)
			end
			
			-- actions.st+=/arcane_explosion,if=runeforge.disciplinary_command&cooldown.buff_disciplinary_command.ready&buff.disciplinary_command_arcane.down
			--if A.ArcaneExplosion:IsReady(player) and 
			
			-- actions.st+=/fire_blast,if=runeforge.disciplinary_command&cooldown.buff_disciplinary_command.ready&buff.disciplinary_command_fire.down
			
			-- actions.st+=/glacial_spike,if=buff.brain_freeze.react
			if A.GlacialSpike:IsReady(unit) and (not isMoving or Unit(player):HasBuffs(A.IceFloes.ID, true) > 0) and Unit(player):HasBuffs(A.BrainFreezeBuff.ID, true) > 0 then
				return A.GlacialSpike:Show(icon)
			end
			
			-- actions.st+=/frostbolt
			if A.Frostbolt:IsReady(unit) and (not isMoving or Unit(player):HasBuffs(A.IceFloes.ID, true) > 0) then
				return A.Frostbolt:Show(icon)
			end

		end


		-- actions.precombat+=/summon_water_elemental
		if A.SummonWaterElemental:IsReady(player) and not A.LonelyWinter:IsTalentLearned() and not Pet:IsActive() then
			return A.SummonWaterElemental:Show(icon)
		end
		
		if A.BlazingBarrier:IsReady(player) and (not inCombat or Unit(player):HealthPercent() <= 70) and Unit(player):HasBuffs(A.BlazingBarrier.ID, true) < 2 and Unit(player):HasBuffs(A.Invisibility.ID, true) == 0 then
			return A.BlazingBarrier:Show(icon)
		end
		
		-- actions.precombat+=/frostbolt	
		if A.Frostbolt:IsReady(unit) then
			return A.Frostbolt:Show(icon)
		end

		-- actions+=/call_action_list,name=cds
		if BurstIsON(unit) then
			if Cooldowns() then
				return true
			end
		end
		
		-- actions+=/call_action_list,name=aoe,if=active_enemies>=3
		if MultiUnits:GetActiveEnemies() >= 3 and UseAoE then
			if AoERotation() then
				return true
			end
		end
		
		-- actions+=/call_action_list,name=st,if=active_enemies<3
		if MultiUnits:GetActiveEnemies() > 0 and MultiUnits:GetActiveEnemies() < 3 then
			if ST() then
				return true
			end
		end
		
		-- actions+=/call_action_list,name=movement
		if isMoving then
			if Movement() then
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


