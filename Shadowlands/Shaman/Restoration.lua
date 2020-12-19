--#####################################
--##### TRIP'S RESTORATION SHAMAN #####
--#####################################

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
local HealingEngine                             = Action.HealingEngine
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
local TeamCacheFriendly                         = TeamCache.Friendly
local pairs                                     = pairs

--For Toaster
local Toaster									= _G.Toaster
local GetSpellTexture 							= _G.TMW.GetSpellTexture


-- Spells
Action[ACTION_CONST_SHAMAN_RESTORATION] = {
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
    WilloftheForsaken                      = Action.Create({ Type = "Spell", ID = 7744        }), -- not usable in APL but user can Queue it   
    EscapeArtist                           = Action.Create({ Type = "Spell", ID = 20589    }), -- not usable in APL but user can Queue it
    EveryManforHimself                     = Action.Create({ Type = "Spell", ID = 59752    }), -- not usable in APL but user can Queue it

	-- Shaman General
    AncestralSpirit					= Action.Create({ Type = "Spell", ID = 2008		}),
    AstralRecall					= Action.Create({ Type = "Spell", ID = 556		}),
    AstralShift						= Action.Create({ Type = "Spell", ID = 108271	}),	
    Bloodlust						= Action.Create({ Type = "Spell", ID = 2825		}),
    CapacitorTotem					= Action.Create({ Type = "Spell", ID = 192058	}),	
    ChainHeal						= Action.Create({ Type = "Spell", ID = 1064		}),	
    ChainLightning					= Action.Create({ Type = "Spell", ID = 188443	}),	
    EarthElemental					= Action.Create({ Type = "Spell", ID = 198103	}),
    EarthbindTotem					= Action.Create({ Type = "Spell", ID = 2484		}),
    FarSight						= Action.Create({ Type = "Spell", ID = 6196		}),
    FlameShock						= Action.Create({ Type = "Spell", ID = 188389	}),
    FlametongueWeapon				= Action.Create({ Type = "Spell", ID = 318038	}),	
    FrostShock						= Action.Create({ Type = "Spell", ID = 196840	}),
    GhostWolf						= Action.Create({ Type = "Spell", ID = 2645		}),	
    HealingStreamTotem				= Action.Create({ Type = "Spell", ID = 5394		}),	
    HealingSurge					= Action.Create({ Type = "Spell", ID = 8004		}),	
    Hex								= Action.Create({ Type = "Spell", ID = 51514	}),	
    LightningBolt					= Action.Create({ Type = "Spell", ID = 188196	}),	
    LightningShield					= Action.Create({ Type = "Spell", ID = 192106	}),
    PrimalStrike					= Action.Create({ Type = "Spell", ID = 73899	}),	
    Purge							= Action.Create({ Type = "Spell", ID = 370		}),
    TremorTotem						= Action.Create({ Type = "Spell", ID = 8143		}),	
    WaterWalking					= Action.Create({ Type = "Spell", ID = 546		}),
    WindShear						= Action.Create({ Type = "Spell", ID = 57994	}),
    Reincarnation					= Action.Create({ Type = "Spell", ID = 20608, Hidden = true		}),	
	
	-- Restoration Specific
    AncestralVision					= Action.Create({ Type = "Spell", ID = 212048	}),
    EarthShield						= Action.Create({ Type = "Spell", ID = 974		}),
    HealingRain						= Action.Create({ Type = "Spell", ID = 73920	}),	
    HealingTideTotem				= Action.Create({ Type = "Spell", ID = 108280	}),		
    HealingWave						= Action.Create({ Type = "Spell", ID = 77472	}),
    LavaBurst						= Action.Create({ Type = "Spell", ID = 51505	}),
    ManaTideTotem					= Action.Create({ Type = "Spell", ID = 16191	}),
    PurifySpirit					= Action.Create({ Type = "Spell", ID = 77130	}),
    Riptide							= Action.Create({ Type = "Spell", ID = 61295	}),
    SpiritLinkTotem					= Action.Create({ Type = "Spell", ID = 98008	}),
    SpiritwalkersGrace				= Action.Create({ Type = "Spell", ID = 79206	}),
    WaterShield						= Action.Create({ Type = "Spell", ID = 52127	}),
    LavaSurge						= Action.Create({ Type = "Spell", ID = 77756, Hidden = true		}),
    TidalWaves						= Action.Create({ Type = "Spell", ID = 51564, Hidden = true		}),	
    TidalWavesBuff					= Action.Create({ Type = "Spell", ID = 61295, Hidden = true		}),		
	
	-- Normal Talents
    Torrent							= Action.Create({ Type = "Spell", ID = 200072, isTalent = true, Hidden = true	}),
    Undulation						= Action.Create({ Type = "Spell", ID = 200071, isTalent = true, Hidden = true	}),
    UnleashLife						= Action.Create({ Type = "Spell", ID = 73685, isTalent = true	}),
    EchooftheElements				= Action.Create({ Type = "Spell", ID = 200072, isTalent = true, Hidden = true	}),	
    Deluge							= Action.Create({ Type = "Spell", ID = 200076, isTalent = true, Hidden = true	}),	
    SurgeofEarth					= Action.Create({ Type = "Spell", ID = 320746, isTalent = true	}),
    SpiritWolf						= Action.Create({ Type = "Spell", ID = 260878, isTalent = true, Hidden = true	}),	
    EarthgrabTotem					= Action.Create({ Type = "Spell", ID = 51485, isTalent = true	}),
    StaticCharge					= Action.Create({ Type = "Spell", ID = 265046, isTalent = true, Hidden = true	}),
    AncestralVigor					= Action.Create({ Type = "Spell", ID = 207401, isTalent = true, Hidden = true	}),	
    EarthenWallTotem				= Action.Create({ Type = "Spell", ID = 198838, isTalent = true	}),
    AncestralProtectionTotem		= Action.Create({ Type = "Spell", ID = 207399, isTalent = true	}),
    NaturesGuardian					= Action.Create({ Type = "Spell", ID = 30884, isTalent = true, Hidden = true	}),
    GracefulSpirit					= Action.Create({ Type = "Spell", ID = 192088, isTalent = true, Hidden = true	}),
    WindRushTotem					= Action.Create({ Type = "Spell", ID = 192077, isTalent = true	}),	
    FlashFlood						= Action.Create({ Type = "Spell", ID = 280614, isTalent = true, Hidden = true	}),
    Downpour						= Action.Create({ Type = "Spell", ID = 207778, isTalent = true	}),	
    CloudburstTotem					= Action.Create({ Type = "Spell", ID = 157153, isTalent = true	}),	
    HighTide						= Action.Create({ Type = "Spell", ID = 157154, isTalent = true, Hidden = true	}),	
    Wellspring						= Action.Create({ Type = "Spell", ID = 197995	}),
    Ascendance						= Action.Create({ Type = "Spell", ID = 114052, isTalent = true	}),	

	-- PvP Talents


	-- Covenants
    VesperTotem						= Action.Create({ Type = "Spell", ID = 324386	}),
    SummonSteward					= Action.Create({ Type = "Spell", ID = 324739	}),
    ChainHarvest					= Action.Create({ Type = "Spell", ID = 320674	}),
    DoorofShadows					= Action.Create({ Type = "Spell", ID = 300728	}),
    PrimordialWave					= Action.Create({ Type = "Spell", ID = 326059	}),
    Fleshcraft						= Action.Create({ Type = "Spell", ID = 331180	}),
    FaeTransfusion					= Action.Create({ Type = "Spell", ID = 328923	}),
    Soulshape						= Action.Create({ Type = "Spell", ID = 310143	}),
    Flicker							= Action.Create({ Type = "Spell", ID = 324701	}),	

	-- Conduits

	
	-- Legendaries
	-- General Legendaries

	-- Restoration Legendaries


	--Anima Powers - to add later...
	
	
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
    SpiritualHealingPotion			= Action.Create({ Type = "Item", ID = 171267, QueueForbidden = true }),
	PhialofSerenity				    = Action.Create({ Type = "Item", ID = 177278 }),
	
    -- Misc
    Channeling                      = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),    -- Show an icon during channeling
    TargetEnemy                     = Action.Create({ Type = "Spell", ID = 44603, Hidden = true     }),    -- Change Target (Tab button)
    StopCast                        = Action.Create({ Type = "Spell", ID = 61721, Hidden = true     }),        -- spell_magic_polymorphrabbit
    PoolResource                    = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),
	Quake                           = Action.Create({ Type = "Spell", ID = 240447, Hidden = true     }), -- Quake (Mythic Plus Affix)
	
};

local A = setmetatable(Action[ACTION_CONST_SHAMAN_RESTORATION], { __index = Action })

local player = "player"
local target = "target"
local targettarget = "targettarget"
local mouseover = "mouseover"

local Temp                                  = {
    TotalAndPhys                            = {"TotalImun", "DamagePhysImun"},
    TotalAndPhysKick                        = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC                       = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun                     = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun                = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMag                             = {"TotalImun", "DamageMagicImun"},
}

local function ActiveEarthShield()
    return HealingEngine.GetBuffsCount(A.EarthShield.ID, 0, player, true)
end

local function ActiveEarthShieldOnTank()
    local CurrentTanks = HealingEngine.GetMembersByMode("TANK")
	local total = 0
	for i = 1, #CurrentTanks do 
	    if Unit(CurrentTanks[i].Unit):HasBuffs(A.EarthShield.ID, player, true) > 0 then
            total = total + 1
        end
	end
    return total
end

local function countInterruptGCD(unitID)
    if not A.WindShear:IsReadyByPassCastGCD(unitID) or not A.WindShear:AbsentImun(unitID, Temp.TotalAndMagKick) then
	    return true
	end
end

local function Interrupts(unitID)
        useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unitID, nil, nil, countInterruptGCD(unitID))
    
	if castRemainsTime >= A.GetLatency() then
		if useKick and not notInterruptable and A.WindShear:IsReady(unitID) and A.WindShear:AbsentImun(unitID, Temp.TotalAndPhysKick, true) then 
			return A.WindShear
		end 

    end
end

A[3] = function(icon, isMulti)

	--ProfileUI toggles
	local UseAoE = A.GetToggle(2, "AoE")
	local UseCovenant = A.GetToggle(1, "Covenant")
	local ShieldType = A.GetToggle(2, "ShieldType")
	local SpiritwalkersGraceTime = A.GetToggle(2, "SpiritwalkersGraceTime")
	local AutoPurify = A.GetToggle(2, "AutoPurify")
	local EarthShieldWorkMode = A.GetToggle(2, "EarthShieldWorkMode")
	
	--Function shortcuts
	local inCombat = Unit(player):CombatTime() > 0
	local isMoving = Player:IsMoving()
	local isMovingFor = A.Player:IsMovingTime()
	local DungeonGroup = TeamCacheFriendly.Size >= 2 and TeamCacheFriendly.Size <= 5 
	local RaidGroup = TeamCacheFriendly.Size >= 6
	local getmembersAll = HealingEngine.GetMembersAll()
	local TargetCritical = Unit(target):HealthPercent() <= 20
	
	--Buffs
	local WaterShieldRefresh = Unit(player):HasBuffs(A.WaterShield.ID, true) == 0 or (Unit(player):HasBuffs(A.WaterShield.ID, true) < 300 and not inCombat)
	local EarthShieldRefresh = Unit(player):HasBuffs(A.EarthShield.ID, true) == 0 or (Unit(player):HasBuffsStacks(A.EarthShield.ID, true) < 2 and not inCombat)
	local LightningShieldRefresh = Unit(player):HasBuffs(A.LightningShield.ID, true) == 0 or (Unit(player):HasBuffs(A.LightningShield.ID, true) < 300 and not inCombat)	
	local CloudburstTotemActive = A.CloudburstTotem:GetSpellTimeSinceLastCast() <= 15
	local VesperTotemActive = A.VesperTotem:GetSpellTimeSinceLastCast() <= 30
	local FaeTransfusionActive = A.FaeTransfusion:GetSpellTimeSinceLastCast() <= 20
	

	local function DamageRotation(unitID)
	
	     -- Purge
        if A.Purge:IsReady(unitID) and inCombat and AuraIsValid(unitID, "UsePurge", "PurgeHigh") then 
            return A.Purge:Show(icon)
        end   
        
        -- Interrupts
        local Interrupt = Interrupts(unitID)
        if Interrupt then 
            return Interrupt:Show(icon)
        end         
                
        -- PvP Crowd Control (Enemy Healer)
        if A.IsInPvP then 
            local EnemyHealerUnitID = EnemyTeam("HEALER"):GetUnitID(40)
            
            if EnemyHealerUnitID ~= "none" and A.Hex:IsReady(EnemyHealerUnitID, true, nil, nil) and A.Hex:AbsentImun(EnemyHealerUnitID, Temp.TotalAndPhysAndCCAndStun, true) and Unit(EnemyHealerUnitID):IsControlAble("incapacitate", 0) and Unit(EnemyHealerUnitID):InCC() <= GetCurrentGCD() then
                return A.Hex:Show(icon)     
            end 
        end     

		--Elemental Shields
		if A.WaterShield:IsReady(unitID) and WaterShieldRefresh and ShieldType == "WATER SHIELD" then
			return A.WaterShield:Show(icon)
		end
		
		if A.EarthShield:IsReady(unitID) and EarthShieldRefresh and ShieldType == "EARTH SHIELD" then
			return A.EarthShield:Show(icon)
		end

		if A.LightningShield:IsReady(unitID) and LightningShieldRefresh and ShieldType == "LIGHTNING SHIELD" then
			return A.LightningShield:Show(icon)
		end	
		
		if A.FaeTransfusion:IsReady(player) and MultiUnits:GetActiveEnemies() >= 3 then
			A.Toaster:SpawnByTimer("TripToast", 0, "Fae Transfusion!", "Put your cursor on your enemies!", A.FaeTransfusion.ID)	
			return A.FaeTransfusion:Show(icon)
		end
		
		-- LavaBurst
        if A.LavaBurst:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) and A.LavaBurst:AbsentImun(unitID, Temp.TotalAndMag) and Unit(unitID):HasDeBuffs(A.FlameShock.ID, true) > 0 then 
            return A.LavaBurst:Show(icon)
        end 
        
		-- FlameShock
        if A.FlameShock:IsReady(unitID) and A.FlameShock:AbsentImun(unitID, Temp.TotalAndMag) and Unit(unitID):HasDeBuffs(A.FlameShock.ID, true) < 3 then 
            return A.FlameShock:Show(icon)
        end 

		-- ChainLightning
        if A.ChainLightning:IsReady(unitID) and UseAoE and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) and A.ChainLightning:AbsentImun(unitID, Temp.TotalAndMag) and Unit(unitID):HasDeBuffs(A.FlameShock.ID, true) > 0 and A.MultiUnits:GetActiveEnemies() > 2 then 
            return A.ChainLightning:Show(icon)
        end 

		-- LightningBolt
        if A.LightningBolt:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) and A.LightningBolt:AbsentImun(unitID, Temp.TotalAndMag) and Unit(unitID):HasDeBuffs(A.FlameShock.ID, true) > 0 then 
            return A.LightningBolt:Show(icon)
        end 
	
	end
	
	
	local function HealingRotation(unitID)
	local useDispel, useShields, useHoTs, useUtils = HealingEngine.GetOptionsByUnitID(unitID)	
	local unitGUID = UnitGUID(unitID)	
	
		--Earth Shield on tank
		local CurrentTanks = A.HealingEngine.GetMembersByMode("TANK")
        if not A.IsInPvP and A.EarthShield:IsReady() and EarthShieldWorkMode == "Tanking Units" and A.LastPlayerCastID ~= A.EarthShield.ID and ActiveEarthShieldOnTank() == 0 then
            for i = 1, #CurrentTanks do 
                if Unit(CurrentTanks[i].Unit):GetRange() <= 40 then 
                      if Unit(CurrentTanks[i].Unit):IsPlayer() and Unit(CurrentTanks[i].Unit):HasBuffsStacks(A.EarthShield.ID, true) < 2 then                       
                        HealingEngine.SetTarget(CurrentTanks[i].Unit)                            
                        return A.EarthShield:Show(icon)                        
                    end                    
                end                
            end    
        end
		
		--Earth Shield on most incoming damage
        if inCombat and A.EarthShield:IsReady(unitID) then  
		    if EarthShieldWorkMode == "Mostly Inc. Damage"  then
                HealingEngine.SetTargetMostlyIncDMG(1) 			 
				if Unit(unitID):HasBuffsStacks(A.EarthShield.ID, true) <= 2 and Unit(unitID):HasBuffs(A.WaterShield.ID, true) == 0 and Unit(unitID):HasBuffs(A.LightningShield.ID, true) == 0 then 		
				    return A.EarthShield:Show(icon)	
                end					
			end
		end		

		--Dispel
		if A.PurifySpirit:IsReady(unitID) and AutoPurify then
			for i = 1, #getmembersAll do 
				if Unit(getmembersAll[i].Unit):GetRange() <= 40 and AuraIsValid(getmembersAll[i].Unit, "UseDispel", "Dispel magic") then  
				--	if UnitGUID(getmembersAll[i].Unit) ~= currGUID then
					  HealingEngine.SetTarget(getmembersAll[i].Unit) 
					  A.PurifySpirit:Show(icon)
				--	end 					                									
				end				
			end
		end
		
		--Elemental Shields
		if A.WaterShield:IsReady(unitID) and WaterShieldRefresh and ShieldType == "WATER SHIELD" then
			return A.WaterShield:Show(icon)
		end
		
		if A.EarthShield:IsReady(unitID) and EarthShieldRefresh and ShieldType == "EARTH SHIELD" then
			return A.EarthShield:Show(icon)
		end

		if A.LightningShield:IsReady(unitID) and LightningShieldRefresh and ShieldType == "LIGHTNING SHIELD" then
			return A.LightningShield:Show(icon)
		end		
	
		--Covenants
		if A.PrimordialWave:IsReady(unitID) and UseCovenant and Unit(unitID):HealthPercent() <= 70 then
			return A.PrimordialWave:Show(icon)
		end
		
		if A.ChainHarvest:IsReady(unitID) and UseCovenant and HealingEngine.GetBelowHealthPercentUnits(60, 40) >= 3 then
			return A.ChainHarvest:Show(icon)
		end
		
		if A.VesperTotem:IsReady(player) and UseCovenant and not VesperTotemActive and HealingEngine.GetBelowHealthPercentUnits(90, 40) >= 3 then
			A.Toaster:SpawnByTimer("TripToast", 0, "Vesper Totem!", "Get your cursor ready!", A.VesperTotem.ID)
			return A.VesperTotem:Show(icon)
		end	
		
		if A.FaeTransfusion:IsReady(unitID) and UseCovenant and FaeTransfusionActive and HealingEngine.GetBelowHealthPercentUnits(85, 40) >= 3 then
			return A.FaeTransfusion:Show(icon)
		end
		
		--Spirit Link Totem when heavy damage incoming - use manual for now, need DBM timers
		
		--Healing Tide Totem
		if DungeonGroup then
			if A.HealingTideTotem:IsReady(unitID) and HealingEngine.GetBelowHealthPercentUnits(50, 40) >= 4 and Player:IsStayingTime() > 0.5 and A.SpiritLinkTotem:GetSpellTimeSinceLastCast() > 6 then
				return A.HealingTideTotem:Show(icon)
			end
		end
		
		if RaidGroup then
			if A.HealingTideTotem:IsReady(unitID) and HealingEngine.GetBelowHealthPercentUnits(50, 40) >= 10 and Player:IsStayingTime() > 0.5 and A.SpiritLinkTotem:GetSpellTimeSinceLastCast() > 6 then
				return A.HealingTideTotem:Show(icon)
			end
		end
		
		if A.Ascendance:IsReady(unitID) and A.Ascendance:IsTalentLearned() and ((DungeonGroup and HealingEngine.GetBelowHealthPercentUnits(30, 40) >= 3) or (RaidGroup and HealingEngine.GetBelowHealthPercentUnits(30, 40) >= 6)) then
			return A.Ascendance:Show(icon)
		end
		
		--Healing Stream Totem
		if A.HealingStreamTotem:IsReady(unitID) and not A.CloudburstTotem:IsTalentLearned() and Player:IsStayingTime() > 0.5 and HealingEngine.GetBelowHealthPercentUnits(95, 40) >= 1 and A.HealingStreamTotem:GetSpellTimeSinceLastCast() > 15 then
			return A.HealingStreamTotem:Show(icon)
		end	
		
		--Cloudburst Totem
		if A.CloudburstTotem:IsReady(unitID) and A.CloudburstTotem:IsTalentLearned() and not CloudburstTotemActive and Player:IsStayingTime() > 0.5 and HealingEngine.GetBelowHealthPercentUnits(90, 40) >= 1 and A.CloudburstTotem:GetSpellTimeSinceLastCast() > 15 then
			return A.CloudburstTotem:Show(icon)
		end	
		
		if A.CloudburstTotem:IsReady(unitID) and CloudburstTotemActive and HealingEngine.GetBelowHealthPercentUnits(60, 40) >= 1 then
			return A.CloudburstTotem:Show(icon)
		end

		--Riptide
		if A.Riptide:IsReady(unitID) and A.LastPlayerCastID ~= A.Riptide.ID and Unit(unitID):HealthPercent() <= 95 then
			return A.Riptide:Show(icon)
		end
		
		if A.Riptide:IsReady(unitID) and A.LastPlayerCastID ~= A.Riptide.ID and Unit(unitID):IsTanking() and Unit(unitID):HasBuffs(A.Riptide.ID, true) < 3 then
			return A.Riptide:Show(icon)
		end

		--Healing Rain
		if A.HealingRain:IsReady(player) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) and HealingEngine.GetBelowHealthPercentUnits(85, 40) >= 3 then
			A.Toaster:SpawnByTimer("TripToast", 0, "Healing Rain!", "Get your cursor ready!", A.HealingRain.ID)		
			return A.HealingRain:Show(icon)
		end
		
		--Unleash Life
		if A.UnleashLife:IsReady(unitID) and A.UnleashLife:IsTalentLearned() and Unit(unitID):HealthPercent() <= 90 then
			return A.UnleashLife:Show(icon)
		end
		
		--Wellspring
		if A.Wellspring:IsReady(player) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) and HealingEngine.GetBelowHealthPercentUnits(85, 40) >= 3 then
			A.Toaster:SpawnByTimer("TripToast", 0, "Wellspring!", "Position yourself correctly!", A.Wellspring.ID)		
			return A.Wellspring:Show(icon)
		end
		
		--Downpour
		if A.Downpour:IsReady(player) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) and HealingEngine.GetBelowHealthPercentUnits(85, 40) >= 3 then
			A.Toaster:SpawnByTimer("TripToast", 0, "Downpour!", "Get your cursor ready!", A.Downpour.ID)		
			return A.Downpour:Show(icon)
		end
		
		--Earthen Wall Totem
		if A.EarthenWallTotem:IsReady(player) and HealingEngine.GetBelowHealthPercentUnits(70, 40) >= 3 then
			A.Toaster:SpawnByTimer("TripToast", 0, "Earthen Wall Totem!", "Get your cursor ready!", A.EarthenWallTotem.ID)		
			return A.EarthenWallTotem:Show(icon)
		end		
		
		--Spiritwalker's Graceful
		if A.SpiritwalkersGrace:IsReady(unitID) and isMovingFor > SpiritwalkersGraceTime and inCombat then
			A.Toaster:SpawnByTimer("TripToast", 0, "Spiritwalker's Grace!", "Run around like a headless chicken!", A.SpiritwalkersGrace.ID)				
			return A.SpiritwalkersGrace:Show(icon)
		end
		
		--Chain Heal
		if A.ChainHeal:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) and HealingEngine.GetBelowHealthPercentUnits(80, 40) >= 3 and Unit(player):HasBuffsStacks(A.TidalWavesBuff.ID, true) < 2 and Unit(unitID):HealthPercent() > 20 and not isMoving then
			return A.ChainHeal:Show(icon)
		end
		
		--HealingSurge Emergency w/ Tidal Waves
		if A.HealingSurge:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) and Unit(unitID):HealthPercent() <= 40 then
			return A.HealingSurge:Show(icon)
		end
		
		--Healing Wave
		if A.HealingWave:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) and Unit(unitID):HealthPercent() <= 80 then
			return A.HealingWave:Show(icon)
		end
		
	
	end

    -- Heal Target 
    if IsUnitFriendly(target) then 
        unitID = target 
        
        if HealingRotation(unitID) then 
            return true 
        end 
    end  
	    
    -- Heal Mouseover
    if IsUnitFriendly(mouseover) then 
        unitID = mouseover  
        
        if HealingRotation(unitID) then 
            return true 
        end             
    end 
	
    -- DPS TargetTarget 
    if IsUnitEnemy(targettarget) then 
        unitID = targettarget    
        
        if DamageRotation(unitID) then 
            return true 
        end 
    end     
	
    -- DPS Mouseover 
    if IsUnitEnemy(mouseover) then 
        unitID = mouseover    
        
        if DamageRotation(unitID) then 
            return true 
        end 
    end 
	
    -- DPS Target     
    if IsUnitEnemy(target) then 
        unitID = target
        
        if DamageRotation(unitID) then 
            return true 
        end 
    end     

end

local function PartyRotation(unitID) 
	-- Dispel 
    if A.PurifySpirit:IsReady(unitID) and A.RemoveCorruption:AbsentImun(unitID) and A.AuraIsValid(unitID, "UseDispel", "Dispel") and not Unit(unitID):InLOS() then                         
        return A.PurifySpirit
    end    
	
end 
