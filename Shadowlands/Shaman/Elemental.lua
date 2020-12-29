--###################################
--##### TRIP'S ELEMENTAL SHAMAN #####
--###################################


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
local AuraIsValidByPhialofSerenity				= A.AuraIsValidByPhialofSerenity
local InterruptIsValid							= Action.InterruptIsValid
local FrameHasSpell								= Action.FrameHasSpell
local Azerite									= LibStub("AzeriteTraits")
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

--Toaster stuff
local Toaster																	= _G.Toaster
local GetSpellTexture 															= _G.TMW.GetSpellTexture

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

-- Spells
Action[ACTION_CONST_SHAMAN_ELEMENTAL] = {
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
    BagofTricks                            = Action.Create({ Type = "Spell", ID = 312411    }),	

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
	
	-- Elemental Specific
    CleanseSpirit					= Action.Create({ Type = "Spell", ID = 51886	}),
    EarthShock						= Action.Create({ Type = "Spell", ID = 8042		}),
    Earthquake						= Action.Create({ Type = "Spell", ID = 61882	}),
    FireElemental					= Action.Create({ Type = "Spell", ID = 198067	}),	
    LavaBurst						= Action.Create({ Type = "Spell", ID = 51505	}),	
    SpiritwalkersGrace				= Action.Create({ Type = "Spell", ID = 79206	}),	
    Thunderstorm					= Action.Create({ Type = "Spell", ID = 51490	}),
	LavaSurge						= Action.Create({ Type = "Spell", ID = 77762, Hidden = true 	}),
	
	-- Normal Talents
    EarthenRage						= Action.Create({ Type = "Spell", ID = 170374, Hidden = true	}),
    EchooftheElements				= Action.Create({ Type = "Spell", ID = 333919, Hidden = true	}),	
    StaticDischarge					= Action.Create({ Type = "Spell", ID = 342243	}),	
    Aftershock						= Action.Create({ Type = "Spell", ID = 273221, Hidden = true	}),
    EchoingShock					= Action.Create({ Type = "Spell", ID = 320125	}),	
    ElementalBlast					= Action.Create({ Type = "Spell", ID = 117014	}),	
    SpiritWolf						= Action.Create({ Type = "Spell", ID = 260878, Hidden = true	}),
    EarthShield						= Action.Create({ Type = "Spell", ID = 974		}),	
    StaticCharge					= Action.Create({ Type = "Spell", ID = 265046, Hidden = true	}),	
    MasteroftheElements				= Action.Create({ Type = "Spell", ID = 16166, Hidden = true		}),
    MasteroftheElementsBuff			= Action.Create({ Type = "Spell", ID = 260734, Hidden = true	}),	
    StormElemental					= Action.Create({ Type = "Spell", ID = 192249	}),
    WindGust						= Action.Create({ Type = "Spell", ID = 263806	}),	
    LiquidMagmaTotem				= Action.Create({ Type = "Spell", ID = 192222	}),		
    NaturesGuardian					= Action.Create({ Type = "Spell", ID = 30884, Hidden = true		}),
    AncestralGuidance				= Action.Create({ Type = "Spell", ID = 108281	}),	
    WindRushTotem					= Action.Create({ Type = "Spell", ID = 192077	}),
    SurgeofPower					= Action.Create({ Type = "Spell", ID = 262303, Hidden = true	}),	
    PrimalElementalist				= Action.Create({ Type = "Spell", ID = 117013, Hidden = true	}),	
    Icefury							= Action.Create({ Type = "Spell", ID = 210714	}),	
    UnlimitedPower					= Action.Create({ Type = "Spell", ID = 260895, Hidden = true	}),	
    Stormkeeper						= Action.Create({ Type = "Spell", ID = 191634	}),	
    Ascendance						= Action.Create({ Type = "Spell", ID = 114050	}),	

	-- PvP Talents


	-- Covenants
    VesperTotem						= Action.Create({ Type = "Spell", ID = 324386	}),
    SummonSteward					= Action.Create({ Type = "Spell", ID = 324739	}),
    ChainHarvest					= Action.Create({ Type = "Spell", ID = 320674	}),
    DoorofShadows					= Action.Create({ Type = "Spell", ID = 300728	}),
    PrimordialWave					= Action.Create({ Type = "Spell", ID = 326059	}),
    PrimordialWaveBuff				= Action.Create({ Type = "Spell", ID = 327164	}),	
    Fleshcraft						= Action.Create({ Type = "Spell", ID = 331180	}),
    FaeTransfusion					= Action.Create({ Type = "Spell", ID = 328923	}),
    Soulshape						= Action.Create({ Type = "Spell", ID = 310143	}),
    Flicker							= Action.Create({ Type = "Spell", ID = 324701	}),	

	-- Conduits

	
	-- Legendaries
	-- General Legendaries

	-- Elemental Legendaries
	EchoesofGreatSundering			= Action.Create({ Type = "Spell", ID = 336217	}),	


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
	
	--Lusts
    Bloodlust						= Action.Create({ Type = "Spell", ID = 2825, Hidden = true		}),
    Heroism							= Action.Create({ Type = "Spell", ID = 32182, Hidden = true		}),
    TimeWarp						= Action.Create({ Type = "Spell", ID = 80353, Hidden = true		}),    
    PrimalRage						= Action.Create({ Type = "Spell", ID = 264667, Hidden = true    }),    
    DrumsofDeathlyFerocity			= Action.Create({ Type = "Spell", ID = 309658, Hidden = true    }),	
	
};

-- To create essences use next code:
Action:CreateEssencesFor(ACTION_CONST_SHAMAN_ELEMENTAL)  -- where PLAYERSPEC is Constance (example: ACTION_CONST_MONK_BM)
local A = setmetatable(Action[ACTION_CONST_SHAMAN_ELEMENTAL], { __index = Action })

local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end

local player = "player"
local target = "target"
local mouseover = "mouseover"

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
}

local IsIndoors, UnitIsUnit, UnitName = IsIndoors, UnitIsUnit, UnitName

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


Pet:AddTrackers(ACTION_CONST_SHAMAN_ELEMENTAL, {
		[61029] = {
			name = "Primal Fire Elemental",
			duration = 30,
		},
		[77942] = {
			name = "Primal Storm Elemental",
			duration = 30,
		},			
		[61056] = {
			name = "Primal Earth Elemental",
			duration = 60,
		},
		[95061] = {
			name = "Greater Fire Elemental",
			duration = 30,
		},
		[77936] = {
			name = "Greater Storm Elemental",
			duration = 30,
		},
		[95072] = {
			name = "Greater Earth Elemental",
			duration = 60,
		},
})

local function StormElementalTime()
    return (Pet:IsActive(77942) and Pet:GetRemainDuration(77942)) or (Pet:IsActive(77936) and Pet:GetRemainDuration(77936)) or 0
end 

local function FireElementalTime()
    return (Pet:IsActive(61029) and Pet:GetRemainDuration(61029)) or (Pet:IsActive(95061) and Pet:GetRemainDuration(95061)) or 0
end 

local function EarthElementalTime()
    return (Pet:IsActive(61056) and Pet:GetRemainDuration(61056)) or (Pet:IsActive(95072) and Pet:GetRemainDuration(95072)) or 0
end 

local function SelfDefensives()
    if Unit("player"):CombatTime() == 0 then 
        return 
    end 
    
    local unit
    if A.IsUnitEnemy("mouseover") then 
        unit = "mouseover"
    elseif A.IsUnitEnemy("target") then 
        unit = "target"
    end      
    
    -- EarthShieldHP
    local EarthShield = A.GetToggle(2, "EarthShieldHP")
    if     EarthShield >= 0 and A.EarthShield:IsReady("player") and  
    (
        (     -- Auto 
            EarthShield >= 100 and 
            (
                Unit("player"):HasBuffsStacks(A.EarthShield.ID, true) <= 3 
                or A.IsInPvP and Unit("player"):HasBuffsStacks(A.EarthShield.ID, true) <= 2
            ) 
        ) or 
        (    -- Custom
            EarthShield < 100 and 
            Unit("player"):HasBuffs(A.EarthShield.ID, true) <= 5 and 
            Unit("player"):HealthPercent() <= EarthShield
        )
    ) 
    then 
        return A.EarthShield
    end
    
    -- HealingSurgeHP
    local HealingSurge = A.GetToggle(2, "HealingSurgeHP")
    if     HealingSurge >= 0 and A.HealingSurge:IsReady("player") and 
    (
        (     -- Auto 
            HealingSurge >= 100 and 
            (
                -- HP lose per sec >= 40
                Unit("player"):GetDMG() * 100 / Unit("player"):HealthMax() >= 40 or 
                Unit("player"):GetRealTimeDMG() >= Unit("player"):HealthMax() * 0.40 or 
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
        ) or 
        (    -- Custom
            HealingSurge < 100 and 
            Unit("player"):HealthPercent() <= HealingSurge
        )
    ) 
    then 
        return A.HealingSurge
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
		
		--PhialofSerenity
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
    
    -- AstralShift
    local AstralShift = A.GetToggle(2, "AstralShiftHP")
    if A.AstralShift:IsReady(player) and Unit(player):HealthPercent() <= AstralShift then
		return A.AstralShift
    end     
	
	
    -- Stoneform on self dispel (only PvE)
    if A.Stoneform:IsRacialReady("player", true) and not A.IsInPvP and A.AuraIsValid("player", "UseDispel", "Dispel") then 
        return A.Stoneform
    end 
end 
SelfDefensives = A.MakeFunctionCachedStatic(SelfDefensives)

-- Non GCD spell check
local function countInterruptGCD(unitID)
    if not A.WindShear:IsReadyByPassCastGCD(unitID) or not A.WindShear:AbsentImun(unitID, Temp.TotalAndMagKick) then
	    return true
	end
end

-- Interrupts spells
local function Interrupts(unitID)

    useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unitID, nil, nil, countInterruptGCD(unitID))

	if castRemainsTime >= A.GetLatency() then
	    -- WindShear
        if useKick and A.WindShear:IsReady(unitID) and not notInterruptable then 
	        -- Notification					
			A.Toaster:SpawnByTimer("TripToast", 0, "Interrupt!", "Interrupting with Wind Shear!", A.WindShear.ID)
            return A.WindShear
        end 
	
        -- CapacitorTotem
        if useCC and Action.GetToggle(2, "UseCapacitorTotem") and A.WindShear:GetCooldown() > 0 and A.CapacitorTotem:IsReady(player) then 
			-- Notification					
            A.Toaster:SpawnByTimer("TripToast", 0, "Interrupt!", "Interrupting with Capacitor Totem!", A.CapacitorTotem.ID)
            return A.CapacitorTotem
        end  
    
        -- Hex	
        if useCC and A.Hex:IsReady(unitID) and A.Hex:AbsentImun(unitID, Temp.TotalAndCC, true) and Unit(unitID):IsControlAble("incapacitate", 0) then 
	        -- Notification					
            A.Toaster:SpawnByTimer("TripToast", 0, "Interrupt!", "Interrupting with Hex!", A.Hex.ID)
            return A.Hex              
        end  
    end
end

--- ======= ACTION LISTS =======
-- [3] Single Rotation
A[3] = function(icon, isMulti)

	--Function Remaps
    local isMoving = Player:IsMoving()
	local isMovingFor = A.Player:IsMovingTime()		
    local inCombat = Unit(player):CombatTime() > 0
    local combatTime = Unit(player):CombatTime()
	
	local Maelstrom = Player:Maelstrom()
	local LustActive = Unit(player):HasBuffs(A.Bloodlust.ID, true) > 0 or Unit(player):HasBuffs(A.TimeWarp.ID, true) > 0 or Unit(player):HasBuffs(A.Heroism.ID, true) > 0 or Unit(player):HasBuffs(A.PrimalRage.ID, true) > 0 or Unit(player):HasBuffs(A.DrumsofDeathlyFerocity.ID, true) > 0
	
	-- local StormElementalTime = StormElementalTime()
	local StormElementalActive = Pet:IsActive(77942) or Pet:IsActive(77936)
	-- local FireElementalTime = FireElementalTime()
	local FireElementalActive = Pet:IsActive(61029) or Pet:IsActive(95061)
	-- local EarthElementalTime = EarthElementalTime()
	local EarthElementalActive = Pet:IsActive(61056) or Pet:IsActive(95072)	
	
	--Toggle Remaps
	local UseAoE = A.GetToggle(2, "AoE")
	local ForceAoE = A.GetToggle(2, "ForceAoE")
	local UseCovenant = A.GetToggle(1, "Covenant")
	local UseRacial = A.GetToggle(1, "Racial")	
	local SkybreakersFieryDemise = A.GetToggle(2, "SkybreakersFieryDemise")
	local EchoesofGreatSundering = A.GetToggle(2, "EchoesofGreatSundering")
	local DeeptremorStone = A.GetToggle(2, "DeeptremorStone")
	--local ElementalEquilibrium = A.GetToggle(2, "ElementalEquilibrium")
	local SpiritwalkersGraceTime = A.GetToggle(2, "SpiritwalkersGraceTime")

	inRange = A.ChainLightning:IsInRange(unitID)

	local function EnemyRotation()
	
		local function Precombat()
			-- actions.precombat+=/earth_elemental,if=!talent.primal_elementalist.enabled
			if A.EarthElemental:IsReady(player) and BurstIsON(unitID) and not A.PrimalElementalist:IsTalentLearned() then
				return A.EarthElemental:Show(icon)
			end
			
			-- # Use Stormkeeper precombat unless some adds will spawn soon.
			-- actions.precombat+=/stormkeeper,if=talent.stormkeeper.enabled&(raid_event.adds.count<3|raid_event.adds.in>50)
			if A.Stormkeeper:IsReady(player) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) and MultiUnits:GetActiveEnemies() < 3 then
				return A.Stormkeeper:Show(icon)
			end

			--Force AoE opener check
			if A.ChainLightning:IsReady(unit) and ForceAoE and UseAoE and (A.LastPlayerCastName ~= A.ChainLightning:Info()) then
				return A.ChainLightning:Show(icon)
			end		
			
			-- actions.precombat+=/elemental_blast,if=talent.elemental_blast.enabled
			if A.ElementalBlast:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) then
				return A.ElementalBlast:Show(icon)
			end
			
			-- actions.precombat+=/lava_burst,if=!talent.elemental_blast.enabled
			if A.LavaBurst:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) and not A.ElementalBlast:IsTalentLearned() then
				return A.LavaBurst:Show(icon)
			end

		end

		local function AoERotation()
			-- actions.aoe=earthquake,if=buff.echoing_shock.up
			if A.Earthquake:IsReady(player) and Unit(player):HasBuffs(A.EchoingShock.ID, true) > 0 then
				return A.Earthquake:Show(icon)
			end
			
			-- actions.aoe+=/chain_harvest
			if A.ChainHarvest:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) and UseCovenant then
				return A.ChainHarvest:Show(icon)
			end
			
			-- actions.aoe+=/stormkeeper,if=talent.stormkeeper.enabled
			if A.Stormkeeper:IsReady(player) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) then
				return A.Stormkeeper:Show(icon)
			end
			
			-- actions.aoe+=/flame_shock,if=active_dot.flame_shock<3&active_enemies<=5|runeforge.skybreakers_fiery_demise.equipped,target_if=refreshable
			if A.FlameShock:IsReady(unitID) and ((Unit(unitID):HasDeBuffs(A.FlameShock.ID, true) < 3 and MultiUnits:GetActiveEnemies() <= 5) or (SkybreakersFieryDemise and Unit(unitID):HasDeBuffs(A.FlameShock.ID, true) < 6)) then
				return A.FlameShock:Show(icon)
			end
			
			-- actions.aoe+=/flame_shock,if=!active_dot.flame_shock
			if A.FlameShock:IsReady(unitID) and Unit(unitID):HasDeBuffs(A.FlameShock.ID, true) == 0 then
				return A.FlameShock:Show(icon)
			end
			
			-- actions.aoe+=/echoing_shock,if=talent.echoing_shock.enabled&maelstrom>=60
			if A.EchoingShock:IsReady(unitID) and Maelstrom >= 60 then
				return A.EchoingShock:Show(icon)
			end
			
			-- actions.aoe+=/ascendance,if=talent.ascendance.enabled&(!pet.storm_elemental.active)&(!talent.icefury.enabled|!buff.icefury.up&!cooldown.icefury.up)
			if A.Ascendance:IsReady(player) and BurstIsON(unitID) and (not StormElementalActive) and (not A.Icefury:IsTalentLearned() or (not Unit(player):HasBuffs(A.Icefury.ID, true) > 0 and A.Icefury:GetCooldown() > 0)) then
				return A.Ascendance:Show(icon)
			end
			
			-- actions.aoe+=/liquid_magma_totem,if=talent.liquid_magma_totem.enabled
			if A.LiquidMagmaTotem:IsReady(player) then
				return A.LiquidMagmaTotem:Show(icon)
			end
			
			-- actions.aoe+=/earth_shock,if=runeforge.echoes_of_great_sundering.equipped&!buff.echoes_of_great_sundering.up
			if A.EarthShock:IsReady(unitID) and EchoesofGreatSundering and Unit(player):HasBuffs(A.EchoesofGreatSundering.ID, true) == 0 then
				return A.EarthShock:Show(icon)
			end
			
			-- actions.aoe+=/earth_elemental,if=runeforge.deeptremor_stone.equipped&(!talent.primal_elementalist.enabled|(!pet.storm_elemental.active&!pet.fire_elemental.active))
			if A.EarthElemental:IsReady(unitID) and BurstIsON(unitID) and DeeptremorStone and (not A.PrimalElementalist:IsTalentLearned() or (not StormElementalActive and not FireElementalActive)) then
				return A.EarthElemental:Show(icon)
			end
			
			-- actions.aoe+=/lava_burst,target_if=dot.flame_shock.remains,if=spell_targets.chain_lightning<4|buff.lava_surge.up|(talent.master_of_the_elements.enabled&!buff.master_of_the_elements.up&maelstrom>=60)
			if A.LavaBurst:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0 or Unit(player):HasBuffs(A.LavaSurge.ID, true) > 0) and Unit(unitID):HasDeBuffs(A.FlameShock.ID, true) > 0 and (MultiUnits:GetActiveEnemies() < 4 or (A.MasteroftheElements:IsTalentLearned() and Unit(player):HasBuffs(A.MasteroftheElementsBuff.ID, true) == 0 and Maelstrom >= 60)) then
				return A.LavaBurst:Show(icon)
			end
			
			-- # Try to game Earthquake with Master of the Elements buff when fighting 3 targets. Don't overcap Maelstrom!
			-- actions.aoe+=/earthquake,if=!talent.master_of_the_elements.enabled|buff.stormkeeper.up|maelstrom>=(100-4*spell_targets.chain_lightning)|buff.master_of_the_elements.up|spell_targets.chain_lightning>3
			if A.Earthquake:IsReady(player) and (not A.MasteroftheElements:IsTalentLearned() or Unit(player):HasBuffs(A.Stormkeeper.ID, true) > 0 or Maelstrom >= (100 - 4 * MultiUnits:GetActiveEnemies()) or Unit(player):HasBuffs(A.MasteroftheElementsBuff.ID, true) > 0 or MultiUnits:GetActiveEnemies() > 3) then
				return A.Earthquake:Show(icon)
			end
			
			-- # Make sure you don't lose a Stormkeeper buff.
			-- actions.aoe+=/chain_lightning,if=buff.stormkeeper.remains<3*gcd*buff.stormkeeper.stack
			if A.ChainLightning:IsReady(unitID) and Unit(player):HasBuffs(A.Stormkeeper.ID, true) > 0 and Unit(player):HasBuffs(A.Stormkeeper.ID, true) < (3 * A.GetGCD() * Unit(player):HasBuffsStacks(A.Stormkeeper.ID, true)) then
				return A.ChainLightning:Show(icon)
			end
			
			-- # Only cast Lava Burst on three targets if it is an instant and Storm Elemental is NOT active.
			-- actions.aoe+=/lava_burst,if=buff.lava_surge.up&spell_targets.chain_lightning<4&(!pet.storm_elemental.active)&dot.flame_shock.ticking
			if A.LavaBurst:IsReady(unitID) and Unit(player):HasBuffs(A.LavaSurge.ID, true) > 0 and (MultiUnits:GetActiveEnemies() < 4 or Unit(player):HasBuffs(A.PrimordialWaveBuff.ID, true) > 0) and (not StormElementalActive) and Unit(unitID):HasDeBuffs(A.FlameShock.ID, true) > 0 then
				return A.LavaBurst:Show(icon)
			end
			
			-- # Use Elemental Blast against up to 3 targets as long as Storm Elemental is not active.
			-- actions.aoe+=/elemental_blast,if=talent.elemental_blast.enabled&spell_targets.chain_lightning<5&(!pet.storm_elemental.active)
			if A.ElementalBlast:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) and MultiUnits:GetActiveEnemies() < 5 and (not StormElementalActive) then
				return A.ElementalBlast:Show(icon)
			end
			
			-- actions.aoe+=/lava_beam,if=talent.ascendance.enabled
			if A.Ascendance:IsReady(player) and BurstIsON(unitID) then
				return A.Ascendance:Show(icon)
			end
			
			-- actions.aoe+=/chain_lightning
			if A.ChainLightning:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) then
				return A.ChainLightning:Show(icon)
			end
			
			-- actions.aoe+=/lava_burst,moving=1,if=buff.lava_surge.up&cooldown_react
			if A.LavaBurst:IsReady(unitID) and isMoving and Unit(player):HasBuffs(A.LavaSurge.ID, true) > 0 then
				return A.LavaBurst:Show(icon)
			end
			
			-- actions.aoe+=/flame_shock,moving=1,target_if=refreshable
			if A.FlameShock:IsReady(unitID) and isMoving and Unit(unitID):HasDeBuffs(A.FlameShock.ID, true) < 6 then
				return A.FlameShock:Show(icon)
			end
			
			-- actions.aoe+=/frost_shock,moving=1
			if A.FrostShock:IsReady(unitID) and isMoving then
				return A.FrostShock:Show(icon)
			end
		
		end


		local function SESingleTarget()
		
			-- actions.se_single_target=flame_shock,target_if=(remains<=gcd)&(buff.lava_surge.up|!buff.bloodlust.up)
			if A.FlameShock:IsReady(unitID) and Unit(unitID):HasDeBuffs(A.FlameShock.ID, true) <= A.GetGCD() and (Unit(unitID):HasBuffs(A.LavaSurge.ID, true) > 0 or not LustActive) then
				return A.FlameShock:Show(icon)
			end
			
			-- actions.se_single_target+=/elemental_blast,if=talent.elemental_blast.enabled
			if A.ElementalBlast:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) then
				return A.ElementalBlast:Show(icon)
			end
			
			-- actions.se_single_target+=/stormkeeper,if=talent.stormkeeper.enabled&(maelstrom<44)
			if A.Stormkeeper:IsReady(player) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) and Maelstrom < 44 then
				return A.Stormkeeper:Show(icon)
			end
			
			-- actions.se_single_target+=/echoing_shock,if=talent.echoing_shock.enabled
			if A.EchoingShock:IsReady(unitID) then
				return A.EchoingShock:Show(icon)
			end
			
			-- actions.se_single_target+=/lava_burst,if=buff.wind_gust.stack<18|buff.lava_surge.up
			if A.LavaBurst:IsReady(unitID) and ((Unit(player):HasBuffsStacks(A.WindGust.ID, true) < 18 and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0)) or Unit(player):HasBuffs(A.LavaSurge.ID, true) > 0) then
				return A.LavaBurst:Show(icon)
			end
			
			-- actions.se_single_target+=/lightning_bolt,if=buff.stormkeeper.up
			if A.LightningBolt:IsReady(unitID) and Unit(player):HasBuffs(A.Stormkeeper.ID, true) > 0 then
				return A.LightningBolt:Show(icon)
			end
			
			-- actions.se_single_target+=/earthquake,if=buff.echoes_of_great_sundering.up
			if A.Earthquake:IsReady(player) and Unit(player):HasBuffs(A.EchoesofGreatSundering.ID, true) > 0 and UseAoE then
				return A.Earthquake:Show(icon)
			end
			
			-- actions.se_single_target+=/earthquake,if=(spell_targets.chain_lightning>1)&(!dot.flame_shock.refreshable)
			if A.Earthquake:IsReady(player) and UseAoE and MultiUnits:GetActiveEnemies() > 1 and Unit(unitID):HasDeBuffs(A.FlameShock.ID, true) > 0 then
				return A.Earthquake:Show(icon)
			end
			
			-- actions.se_single_target+=/earth_shock,if=spell_targets.chain_lightning<2&maelstrom>=60&(buff.wind_gust.stack<20|maelstrom>90)
			if A.EarthShock:IsReady(unitID) and (MultiUnits:GetActiveEnemies() < 2 or not UseAoE) and Maelstrom >= 60 and (Unit(player):HasBuffsStacks(A.WindGust.ID, true) < 20 or Maelstrom > 90) then
				return A.EarthShock:Show(icon)
			end
			
			-- actions.se_single_target+=/lightning_bolt,if=(buff.stormkeeper.remains<1.1*gcd*buff.stormkeeper.stack|buff.stormkeeper.up&buff.master_of_the_elements.up)
			if A.LightningBolt:IsReady(unitID) and (Unit(player):HasBuffs(A.Stormkeeper.ID, true) < (1.1 * A.GetGCD() * Unit(player):HasBuffsStacks(A.Stormkeeper.ID, true)) or Unit(player):HasBuffs(A.Stormkeeper.ID, true) > 0 and Unit(player):HasBuffs(A.MasteroftheElementsBuff.ID, true) > 0) then
				return A.LightningBolt:Show(icon)
			end
			
			-- actions.se_single_target+=/frost_shock,if=talent.icefury.enabled&talent.master_of_the_elements.enabled&buff.icefury.up&buff.master_of_the_elements.up
			if A.FrostShock:IsReady(unitID) and Unit(player):HasBuffs(A.Icefury.ID, true) > 0 and Unit(player):HasBuffs(A.MasteroftheElementsBuff.ID, true) > 0 then
				return A.FrostShock:Show(icon)
			end
			
			-- actions.se_single_target+=/lava_burst,if=buff.ascendance.up
			if A.LavaBurst:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) and Unit(player):HasBuffs(A.Ascendance.ID, true) > 0 then
				return A.LavaBurst:Show(icon)
			end
			
			-- actions.se_single_target+=/lava_burst,if=cooldown_react&!talent.master_of_the_elements.enabled
			if A.LavaBurst:IsReady(unitID) and not A.MasteroftheElements:IsTalentLearned() then
				return A.LavaBurst:Show(icon)
			end
			
			-- actions.se_single_target+=/icefury,if=talent.icefury.enabled&!(maelstrom>75&cooldown.lava_burst.remains<=0)
			if A.Icefury:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) and Maelstrom < 75 and A.LavaBurst:GetCooldown() > 0 then
				return A.Icefury:Show(icon)
			end
			
			-- actions.se_single_target+=/lava_burst,if=cooldown_react&charges>talent.echo_of_the_elements.enabled
			if A.LavaBurst:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0 or Unit(player):HasBuffs(A.LavaSurge.ID, true) > 0) and A.LavaBurst:GetSpellCharges() > num(A.EchooftheElements:IsTalentLearned()) then
				return A.LavaBurst:Show(icon)
			end
			
			-- actions.se_single_target+=/frost_shock,if=talent.icefury.enabled&buff.icefury.up
			if A.FrostShock:IsReady(unitID) and A.Icefury:IsTalentLearned() and Unit(player):HasBuffs(A.Icefury.ID, true) > 0 then
				return A.FrostShock:Show(icon)
			end
			
			-- actions.se_single_target+=/chain_harvest
			if A.ChainHarvest:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) and UseCovenant then
				return A.ChainHarvest:Show(icon)
			end
			
			-- actions.se_single_target+=/static_discharge,if=talent.static_discharge.enabled
			if A.StaticDischarge:IsReady(player) and Unit(unitID):GetRange() < 40 then
				return A.StaticDischarge:Show(icon)
			end
			
			-- actions.se_single_target+=/earth_elemental,if=!talent.primal_elementalist.enabled|talent.primal_elementalist.enabled&(!pet.storm_elemental.active)
			if A.EarthElemental:IsReady(unitID) and BurstIsON(unitID) and (not A.PrimalElementalist:IsTalentLearned() or (A.PrimalElementalist:IsTalentLearned() and not StormElementalActive)) then
				return A.EarthElemental:Show(icon)
			end
			
			-- actions.se_single_target+=/lightning_bolt
			if A.LightningBolt:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) then
				return A.LightningBolt:Show(icon)
			end
			
			-- actions.se_single_target+=/flame_shock,moving=1,target_if=refreshable
			if A.FlameShock:IsReady(unitID) and isMoving and Unit(unitID):HasDeBuffs(A.FlameShock.ID, true) < 6 then
				return A.FlameShock:Show(icon)
			end
			
			-- actions.se_single_target+=/flame_shock,moving=1,if=movement.distance>6
			
			
			-- actions.se_single_target+=/frost_shock,moving=1
			if A.FrostShock:IsReady(unitID) and isMoving then
				return A.FrostShock:Show(icon)
			end

		end
		
		local function SingleTarget()
			-- actions.single_target=flame_shock,target_if=(!ticking|dot.flame_shock.remains<=gcd|talent.ascendance.enabled&dot.flame_shock.remains<(cooldown.ascendance.remains+buff.ascendance.duration)&cooldown.ascendance.remains<4)&(buff.lava_surge.up|!buff.bloodlust.up)
			if A.FlameShock:IsReady(unitID) and (Unit(unitID):HasDeBuffs(A.FlameShock.ID, true) <= A.GetGCD() or A.Ascendance:IsTalentLearned() and Unit(unitID):HasDeBuffs(A.FlameShock.ID, true) < (A.Ascendance:GetCooldown() + Unit(unitID):HasBuffs(A.Ascendance.ID, true)) and A.Ascendance:GetCooldown() < 4) and (Unit(unitID):HasBuffs(A.LavaSurge.ID, true) > 0 or not LustActive) then
				return A.FlameShock:Show(icon)
			end
			
			-- actions.single_target+=/ascendance,if=talent.ascendance.enabled&(time>=60|buff.bloodlust.up)&(cooldown.lava_burst.remains>0)&(!talent.icefury.enabled|!buff.icefury.up&!cooldown.icefury.up)
			if A.Ascendance:IsReady(unitID) and BurstIsON(unitID) and (combatTime >= 60 or LustActive) and A.LavaBurst:GetCooldown() > 0 and (not A.Icefury:IsTalentLearned() or (not A.Icefury:IsTalentLearned() and A.Icefury:GetCooldown() > 0)) then
				return A.Ascendance:Show(icon)
			end
			
			-- actions.single_target+=/elemental_blast,if=talent.elemental_blast.enabled&(talent.master_of_the_elements.enabled&(buff.master_of_the_elements.up&maelstrom<60|!buff.master_of_the_elements.up)|!talent.master_of_the_elements.enabled)
			if A.ElementalBlast:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) and ((Unit(player):HasBuffs(A.MasteroftheElementsBuff.ID, true) > 0 and Maelstrom < 60) or not A.MasteroftheElements:IsTalentLearned()) then
				return A.ElementalBlast:Show(icon)
			end
			
			-- actions.single_target+=/stormkeeper,if=talent.stormkeeper.enabled&(raid_event.adds.count<3|raid_event.adds.in>50)&(maelstrom<44)
			if A.Stormkeeper:IsReady(player) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) and (MultiUnits:GetActiveEnemies() < 3 or not UseAoE) and Maelstrom < 44 then
				return A.Stormkeeper:Show(icon)
			end
			
			-- actions.single_target+=/echoing_shock,if=talent.echoing_shock.enabled&cooldown.lava_burst.remains<=0
			if A.EchoingShock:IsReady(unitID) and A.LavaBurst:GetCooldown() <= 0 then
				return A.EchoingShock:Show(icon)
			end
			
			-- actions.single_target+=/lava_burst,if=talent.echoing_shock.enabled&buff.echoing_shock.up
			if A.LavaBurst:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0 or Unit(player):HasBuffs(A.LavaSurge.ID, true) > 0) and Unit(player):HasBuffs(A.EchoingShock.ID, true) > 0 then
				return A.LavaBurst:Show(icon)
			end
			
			-- actions.single_target+=/liquid_magma_totem,if=talent.liquid_magma_totem.enabled
			if A.LiquidMagmaTotem:IsReady(player) then
				return A.LiquidMagmaTotem:Show(icon)
			end
			
			-- actions.single_target+=/lightning_bolt,if=buff.stormkeeper.up&spell_targets.chain_lightning<2&(buff.master_of_the_elements.up)
			if A.LightningBolt:IsReady(unitID) and Unit(player):HasBuffs(A.Stormkeeper.ID, true) > 0 and (MultiUnits:GetActiveEnemies() < 2 or not UseAoE) and Unit(player):HasBuffs(A.MasteroftheElementsBuff.ID, true) > 0 then
				return A.LightningBolt:Show(icon)
			end
			
			-- actions.single_target+=/earthquake,if=buff.echoes_of_great_sundering.up&(!talent.master_of_the_elements.enabled|buff.master_of_the_elements.up)
			if A.Earthquake:IsReady(player) and UseAoE and Unit(player):HasBuffs(A.EchoesofGreatSundering.ID, true) and (not A.MasteroftheElements:IsTalentLearned() or Unit(player):HasBuffs(A.MasteroftheElementsBuff.ID, true) > 0) then
				return A.Earthquake:Show(icon)
			end
			
			-- actions.single_target+=/earthquake,if=spell_targets.chain_lightning>1&!dot.flame_shock.refreshable&!runeforge.echoes_of_great_sundering.equipped&(!talent.master_of_the_elements.enabled|buff.master_of_the_elements.up|cooldown.lava_burst.remains>0&maelstrom>=92)
			if A.Earthquake:IsReady(player) and UseAoE and MultiUnits:GetActiveEnemies() > 1 and Unit(unitID):HasDeBuffs(A.FlameShock.ID, true) > 0 and not EchoesofGreatSundering and (not A.MasteroftheElements:IsTalentLearned() or Unit(player):HasBuffs(A.MasteroftheElementsBuff.ID, true) > 0 or (A.LavaBurst:GetCooldown() > 0 and Maelstrom >= 92)) then
				return A.Earthquake:Show(icon)
			end
			
			-- actions.single_target+=/earth_shock,if=talent.master_of_the_elements.enabled&(buff.master_of_the_elements.up|cooldown.lava_burst.remains>0&maelstrom>=92|spell_targets.chain_lightning<2&buff.stormkeeper.up&cooldown.lava_burst.remains<=gcd)|!talent.master_of_the_elements.enabled
			if A.EarthShock:IsReady(unitID) and (Unit(player):HasBuffs(A.MasteroftheElementsBuff.ID, true) > 0 or (A.LavaBurst:GetCooldown() > 0 and Maelstrom >= 92) or ((MultiUnits:GetActiveEnemies() < 2 or not UseAoE) and Unit(player):HasBuffs(A.Stormkeeper.ID, true) > 0 and A.LavaBurst:GetCooldown() <= A.GetGCD())) then
				return A.EarthShock:Show(icon)
			end
			
			-- actions.single_target+=/lightning_bolt,if=(buff.stormkeeper.remains<1.1*gcd*buff.stormkeeper.stack|buff.stormkeeper.up&buff.master_of_the_elements.up)
			if A.LightningBolt:IsReady(unitID) and (Unit(player):HasBuffs(A.Stormkeeper.ID, true) < (1.1 * A.GetGCD() * Unit(player):HasBuffsStacks(A.Stormkeeper.ID, true)) or Unit(player):HasBuffs(A.Stormkeeper.ID, true) > 0 and Unit(player):HasBuffs(A.MasteroftheElementsBuff.ID, true) > 0) then
				return A.LightningBolt:Show(icon)
			end
			
			-- actions.single_target+=/frost_shock,if=talent.icefury.enabled&talent.master_of_the_elements.enabled&buff.icefury.up&buff.master_of_the_elements.up
			if A.FrostShock:IsReady(unitID) and Unit(player):HasBuffs(A.Icefury.ID, true) > 0 and Unit(player):HasBuffs(A.MasteroftheElementsBuff.ID, true) > 0 then
				return A.FrostShock:Show(icon)
			end
			
			-- actions.single_target+=/lava_burst,if=buff.ascendance.up
			if A.LavaBurst:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0 and Unit(player):HasBuffs(A.LavaSurge.ID, true) > 0) and Unit(player):HasBuffs(A.Ascendance.ID, true) > 0 then
				return A.LavaBurst:Show(icon)
			end
			
			-- actions.single_target+=/lava_burst,if=cooldown_react&!talent.master_of_the_elements.enabled
			if A.LavaBurst:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0 and Unit(player):HasBuffs(A.LavaSurge.ID, true) > 0) and not A.MasteroftheElements:IsTalentLearned() then
				return A.LavaBurst:Show(icon)
			end
			
			-- actions.single_target+=/icefury,if=talent.icefury.enabled&!(maelstrom>75&cooldown.lava_burst.remains<=0)
			if A.Icefury:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) and Maelstrom < 75 and A.LavaBurst:GetCooldown() > 0 then
				return A.Icefury:Show(icon)
			end
			
			-- actions.single_target+=/lava_burst,if=cooldown_react&charges>talent.echo_of_the_elements.enabled
			if A.LavaBurst:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0 and Unit(player):HasBuffs(A.LavaSurge.ID, true) > 0) and A.LavaBurst:GetSpellCharges() > num(A.EchooftheElements:IsTalentLearned()) then
				return A.LavaBurst:Show(icon)
			end
			
			-- actions.single_target+=/frost_shock,if=talent.icefury.enabled&buff.icefury.up&buff.icefury.remains<1.1*gcd*buff.icefury.stack
			if A.FrostShock:IsReady(unitID) and Unit(player):HasBuffs(A.Icefury.ID, true) > 0 and Unit(player):HasBuffs(A.Icefury.ID, true) < (1.1 * A.GetGCD() * Unit(player):HasBuffsStacks(A.Icefury.ID, true)) then
				return A.FrostShock:Show(icon)
			end
			
			-- actions.single_target+=/lava_burst,if=cooldown_react
			if A.LavaBurst:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0 and Unit(player):HasBuffs(A.LavaSurge.ID, true) > 0) then
				return A.LavaBurst:Show(icon)
			end
			
			-- actions.single_target+=/flame_shock,target_if=refreshable
			if A.FlameShock:IsReady(unitID) and Unit(unitID):HasDeBuffs(A.FlameShock.ID, true) <= 6 then
				return A.FlameShock:Show(icon)
			end
			
			-- actions.single_target+=/earthquake,if=spell_targets.chain_lightning>1&!runeforge.echoes_of_great_sundering.equipped|buff.echoes_of_great_sundering.up
			if A.Earthquake:IsReady(player) and UseAoE and MultiUnits:GetActiveEnemies() > 1 and (not EchoesofGreatSundering or Unit(player):HasBuffs(A.EchoesofGreatSundering.ID, true) > 0) then
				return A.Earthquake:Show(icon)
			end
			
			-- actions.single_target+=/frost_shock,if=talent.icefury.enabled&buff.icefury.up&(buff.icefury.remains<gcd*4*buff.icefury.stack|buff.stormkeeper.up|!talent.master_of_the_elements.enabled)
			if A.FrostShock:IsReady(unitID) and Unit(player):HasBuffs(A.Icefury.ID, true) > 0 and ((Unit(player):HasBuffs(A.Icefury.ID, true) < A.GetGCD() * 4 * Unit(player):HasBuffsStacks(A.Icefury.ID, true)) or Unit(player):HasBuffs(A.Stormkeeper.ID, true) < 0 or not A.MasteroftheElements:IsTalentLearned()) then
				return A.FrostShock:Show(icon)
			end
			
			-- actions.single_target+=/frost_shock,if=runeforge.elemental_equilibrium.equipped&!buff.elemental_equilibrium_debuff.up&!talent.elemental_blast.enabled&!talent.echoing_shock.enabled
			--if A.FrostShock:IsReady(unitID) and ElementalEquilibrium and 
			
			-- actions.single_target+=/chain_harvest
			if A.ChainHarvest:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) and UseCovenant and BurstIsON(unitID) then
				return A.ChainHarvest:Show(icon)
			end
			
			-- actions.single_target+=/static_discharge,if=talent.static_discharge.enabled
			if A.StaticDischarge:IsReady(unitID) then
				return A.StaticDischarge:Show(icon)
			end
			
			-- actions.single_target+=/earth_elemental,if=!talent.primal_elementalist.enabled|!pet.fire_elemental.active
			if A.EarthElemental:IsReady(player) and BurstIsON(unitID) and (not A.PrimalElementalist:IsTalentLearned() or not FireElementalActive) then
				return A.EarthElemental:Show(icon)
			end
			
			-- actions.single_target+=/lightning_bolt
			if A.LightningBolt:IsReady(unitID) and (not isMoving or Unit(player):HasBuffs(A.SpiritwalkersGrace.ID, true) > 0) then
				return A.LightningBolt:Show(icon)
			end
			
			-- actions.single_target+=/flame_shock,moving=1,target_if=refreshable
			if A.FlameShock:IsReady(unitID) and isMoving and Unit(unitID):HasDeBuffs(A.FlameShock.ID, true) < 6 then
				return A.FlameShock:Show(icon)
			end
			
			-- actions.single_target+=/flame_shock,moving=1,if=movement.distance>6
			-- actions.single_target+=/frost_shock,moving=1
			if A.FrostShock:IsReady(unitID) and isMoving then
				return A.FrostShock:Show(icon)
			end
		
		end
		
		--Lightning Shield
		if A.LightningShield:IsReady(unit) and ((not inCombat and Unit("player"):HasBuffs(A.LightningShield.ID, true) < 150) or Unit("player"):HasBuffs(A.LightningShield.ID, true) == 0) then
			return A.LightningShield:Show(icon)
		end		

		if not inCombat then
			if Precombat() then
				return true
			end
		end

		-- # Executed every time the actor is available.
		-- actions=spiritwalkers_grace,moving=1,if=movement.distance>6
		if A.SpiritwalkersGrace:IsReady(player) and isMovingFor >= SpiritwalkersGraceTime then
			return A.SpiritwalkersGrace:Show(icon)
		end
		
		-- # Interrupt of casts.
		-- actions+=/wind_shear
		local Interrupt = Interrupts(unitID)
		if Interrupt then 
			return Interrupt:Show(icon)
		end	
		
		-- actions+=/potion
		-- actions+=/use_items

		-- actions+=/primordial_wave,target_if=min:dot.flame_shock.remains,cycle_targets=1,if=!buff.primordial_wave.up
		if A.PrimordialWave:IsReady(unitID) and UseCovenant and Unit(player):HasBuffs(A.PrimordialWaveBuff.ID, true) == 0 then
			return A.PrimordialWave:Show(icon)
		end
		
		-- actions+=/flame_shock,if=!ticking
		if A.FlameShock:IsReady(unitID) and Unit(unitID):HasDeBuffs(A.FlameShock.ID, true) == 0 then
			return A.FlameShock:Show(icon)
		end
		
		-- actions+=/fire_elemental
		if A.FireElemental:IsReady(player) and BurstIsON(unitID) and Unit(unitID):GetRange() <= 40 then
			return A.FireElemental:Show(icon)
		end
		
		-- actions+=/storm_elemental
		if A.StormElemental:IsReady(player) and BurstIsON(unitID) and Unit(unitID):GetRange() <= 40 then
			return A.StormElemental:Show(icon)
		end		
		
		-- actions+=/blood_fury,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
		if A.BloodFury:IsReady(player) and BurstIsON(unitID) and UseRacial and (not A.Ascendance:IsTalentLearned() or Unit(player):HasBuffs(A.Ascendance.ID, true) > 0 or A.Ascendance:GetCooldown() > 50) then
			return A.BloodFury:Show(icon)
		end
		
		-- actions+=/berserking,if=!talent.ascendance.enabled|buff.ascendance.up
		if A.Berserking:IsReady(player) and BurstIsON(unitID) and UseRacial and (not A.Ascendance:IsTalentLearned() or Unit(player):HasBuffs(A.Ascendance.ID, true) > 0) then
			return A.Berserking:Show(icon)
		end		
		
		-- actions+=/fireblood,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
		if A.Fireblood:IsReady(player) and BurstIsON(unitID) and UseRacial and (not A.Ascendance:IsTalentLearned() or Unit(player):HasBuffs(A.Ascendance.ID, true) > 0 or A.Ascendance:GetCooldown() > 50) then
			return A.Fireblood:Show(icon)
		end		
		
		-- actions+=/ancestral_call,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
		if A.AncestralCall:IsReady(player) and BurstIsON(unitID) and UseRacial and (not A.Ascendance:IsTalentLearned() or Unit(player):HasBuffs(A.Ascendance.ID, true) > 0 or A.Ascendance:GetCooldown() > 50) then
			return A.AncestralCall:Show(icon)
		end		
		
		-- actions+=/bag_of_tricks,if=!talent.ascendance.enabled|!buff.ascendance.up
		if A.BagofTricks:IsReady(player) and BurstIsON(unitID) and UseRacial and Unit(player):HasBuffs(A.Ascendance.ID, true) == 0 then
			return A.BagofTricks:Show(icon)
		end		
		
		-- actions+=/vesper_totem,if=covenant.kyrian
		if A.VesperTotem:IsReady(player) and UseCovenant then
			return A.VesperTotem:Show(icon)
		end
		
		-- actions+=/fae_transfusion,if=covenant.night_fae
		if A.FaeTransfusion:IsReady(player) and UseCovenant then
			return A.FaeTransfusion:Show(icon)
		end
		
		-- actions+=/run_action_list,name=aoe,if=active_enemies>2&(spell_targets.chain_lightning>2|spell_targets.lava_beam>2)
		if MultiUnits:GetActiveEnemies() > 2 and inRange and UseAoE then
			if AoERotation() then
				return true
			end
		end
		
		-- actions+=/run_action_list,name=single_target,if=!talent.storm_elemental.enabled&active_enemies<=2
		if not A.StormElemental:IsTalentLearned() and (MultiUnits:GetActiveEnemies() <= 2 or not UseAoE) and inRange then
			if SingleTarget() then
				return true
			end
		end
		
		-- actions+=/run_action_list,name=se_single_target,if=talent.storm_elemental.enabled&active_enemies<=2
		if A.StormElemental:IsTalentLearned() and (MultiUnits:GetActiveEnemies() <= 2 or not UseAoE) and inRange then
			if SESingleTarget() then
				return true
			end
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
-- Finished
