--###############################
--##### TRIP'S HOLY PALADIN #####
--###############################


local _G, setmetatable							= _G, setmetatable
local TMW                                       = TMW
local CNDT                                      = TMW.CNDT
local Env                                       = CNDT.Env
local A                         			    = _G.Action
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
local AuraIsValidByPhialofSerenity				= A.AuraIsValidByPhialofSerenity
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
local select, math                              = select, math 
local huge                                      = math.huge  
local UIParent                                  = _G.UIParent 
local CreateFrame                               = _G.CreateFrame
local wipe                                      = _G.wipe
local IsUsableSpell                             = IsUsableSpell
local UnitPowerType                             = UnitPowerType 

--For Toaster
local Toaster									= _G.Toaster
local GetSpellTexture 							= _G.TMW.GetSpellTexture

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

-- Spells
Action[ACTION_CONST_PALADIN_HOLY] = {
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
    GiftofNaaru                            = Create({ Type = "Spell", ID = 59544    }),
    Shadowmeld                             = Create({ Type = "Spell", ID = 58984    }), -- usable in Action Core 
    Stoneform                              = Create({ Type = "Spell", ID = 20594    }), 
    WilloftheForsaken                      = Create({ Type = "Spell", ID = 7744        }), -- not usable in APL but user can Queue it   
    EscapeArtist                           = Create({ Type = "Spell", ID = 20589    }), -- not usable in APL but user can Queue it
    EveryManforHimself                     = Create({ Type = "Spell", ID = 59752    }), -- not usable in APL but user can Queue it
    
	-- Spells
	-- Paladin General
    AvengingWrath					= Action.Create({ Type = "Spell", ID = 31884	}),	
    BlessingofFreedom				= Action.Create({ Type = "Spell", ID = 1044		}),
    BlessingofProtection			= Action.Create({ Type = "Spell", ID = 1022		}),
    BlessingofSacrifice				= Action.Create({ Type = "Spell", ID = 6940		}),
    ConcentrationAura				= Action.Create({ Type = "Spell", ID = 317920	}),
    Consecration					= Action.Create({ Type = "Spell", ID = 26573	}),
    CrusaderAura					= Action.Create({ Type = "Spell", ID = 32223	}),
    CrusaderStrike					= Action.Create({ Type = "Spell", ID = 35395	}),
    DevotionAura					= Action.Create({ Type = "Spell", ID = 465		}),	
    DivineShield					= Action.Create({ Type = "Spell", ID = 642		}),
    DivineSteed						= Action.Create({ Type = "Spell", ID = 190784	}),
    FlashofLight					= Action.Create({ Type = "Spell", ID = 19750, predictName = "FlashofLight"		}),
    HammerofJustice					= Action.Create({ Type = "Spell", ID = 853		}),
    HammerofJusticeGreen            = Create({ Type = "SpellSingleColor", ID = 853, Color = "GREEN", Desc = "[1] CC", Hidden = true, Hidden = true, QueueForbidden = true }),	
    HammerofWrath					= Action.Create({ Type = "Spell", ID = 24275	}),
    HandofReckoning					= Action.Create({ Type = "Spell", ID = 62124	}),	
	Judgment						= Action.Create({ Type = "Spell", ID = 275773	}),
    LayOnHands						= Action.Create({ Type = "Spell", ID = 633, predictName = "LayOnHands"			}),	
    Redemption						= Action.Create({ Type = "Spell", ID = 7328		}),
    RetributionAura					= Action.Create({ Type = "Spell", ID = 183435	}),
    ShieldoftheRighteous			= Action.Create({ Type = "Spell", ID = 53600	}),
    TurnEvil						= Action.Create({ Type = "Spell", ID = 10326	}),
    WordofGlory						= Action.Create({ Type = "Spell", ID = 85673, predictName = "WordofGlory"		}),	
    Forbearance						= Action.Create({ Type = "Spell", ID = 25771	}),

	
	-- Holy Specific
    Absolution						= Action.Create({ Type = "Spell", ID = 212056	}),
    AuraMastery						= Action.Create({ Type = "Spell", ID = 31821	}),
    BeaconofLight					= Action.Create({ Type = "Spell", ID = 53563	}),
    Cleanse							= Action.Create({ Type = "Spell", ID = 4987		}),
    DivineProtection				= Action.Create({ Type = "Spell", ID = 498		}),
    HolyLight						= Action.Create({ Type = "Spell", ID = 82326, predictName = "HolyLight"			}),
    HolyShock						= Action.Create({ Type = "Spell", ID = 20473, predictName = "HolyShock"			}),
    LightofDawn						= Action.Create({ Type = "Spell", ID = 85222, predictName = "LightofDawn"		}),
    LightofMartyr					= Action.Create({ Type = "Spell", ID = 183998, predictName = "LightofMartyr"	}),
    InfusionofLight					= Action.Create({ Type = "Spell", ID = 53576, Hidden = true		}),	
    InfusionofLightBuff				= Action.Create({ Type = "Spell", ID = 54149, Hidden = true		}),	
	
	-- Normal Talents
    CrusadersMight					= Action.Create({ Type = "Spell", ID = 196926, Hidden = true	}),
    BestowFaith						= Action.Create({ Type = "Spell", ID = 223306, predictName = "BestowFaith"		}),
    LightsHammer					= Action.Create({ Type = "Spell", ID = 114158	}),	
    SavedbytheLight					= Action.Create({ Type = "Spell", ID = 157047, Hidden = true	}),
    JudgmentofLight					= Action.Create({ Type = "Spell", ID = 183778, Hidden = true	}),		
    HolyPrism						= Action.Create({ Type = "Spell", ID = 114165, predictName = "HolyPrism"		}),
    FistofJustice					= Action.Create({ Type = "Spell", ID = 234299, Hidden = true	}),
    Repentance						= Action.Create({ Type = "Spell", ID = 20066	}),
    BlindingLight					= Action.Create({ Type = "Spell", ID = 115750	}),		
    UnbreakableSpirit				= Action.Create({ Type = "Spell", ID = 114154, Hidden = true	}),		
    Cavalier						= Action.Create({ Type = "Spell", ID = 230332, Hidden = true	}),
    RuleofLaw						= Action.Create({ Type = "Spell", ID = 214202	}),
    DivinePurpose					= Action.Create({ Type = "Spell", ID = 223817, Hidden = true	}),	
    HolyAvenger						= Action.Create({ Type = "Spell", ID = 105809	}),
    Seraphim						= Action.Create({ Type = "Spell", ID = 152262	}),
    SanctifiedWrath					= Action.Create({ Type = "Spell", ID = 53376	}),	
    AvengingCrusader				= Action.Create({ Type = "Spell", ID = 216331	}),
    Awakening						= Action.Create({ Type = "Spell", ID = 248033, Hidden = true	}),
    GlimmerofLight					= Action.Create({ Type = "Spell", ID = 325966, Hidden = true	}),
    GlimmerofLightBuff				= Action.Create({ Type = "Spell", ID = 287280, Hidden = true	}),
    BeaconofFaith					= Action.Create({ Type = "Spell", ID = 156910	}),
    BeaconofVirtue					= Action.Create({ Type = "Spell", ID = 200025	}),		

	-- PvP Talents
	--	Later

	-- Covenant Abilities
    DivineToll						= Action.Create({ Type = "Spell", ID = 304971	}),	
    SummonSteward					= Action.Create({ Type = "Spell", ID = 324739	}),
    AshenHallow						= Action.Create({ Type = "Spell", ID = 316958	}),	
    DoorofShadows					= Action.Create({ Type = "Spell", ID = 300728	}),
    VanquishersHammer				= Action.Create({ Type = "Spell", ID = 328204	}),	
    Fleshcraft						= Action.Create({ Type = "Spell", ID = 331180	}),
    BlessingoftheSeasons			= Action.Create({ Type = "Spell", ID = 328278	}),
    BlessingofSummer				= Action.Create({ Type = "Spell", ID = 328620	}),	
    BlessingofAutumn				= Action.Create({ Type = "Spell", ID = 328622	}),	
    BlessingofSpring				= Action.Create({ Type = "Spell", ID = 328282	}),	
    BlessingofWinter				= Action.Create({ Type = "Spell", ID = 328281	}),		
    Soulshape						= Action.Create({ Type = "Spell", ID = 310143	}),
    Flicker							= Action.Create({ Type = "Spell", ID = 324701	}),

	-- Conduits
	
	
	-- Legendaries
	-- General Legendaries

	--Holy Legendaries


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
	Cyclone                         = Action.Create({ Type = "Spell", ID = 33786, Hidden = true     }), -- Cyclone 	

}

-- To create essences use next code:
Action:CreateEssencesFor(ACTION_CONST_PALADIN_HOLY)  -- where PLAYERSPEC is Constance (example: ACTION_CONST_MONK_BM)
local A = setmetatable(Action[ACTION_CONST_PALADIN_HOLY], { __index = Action })


local player = "player"
local targettarget = "targettarget"
local target = "target"
local mouseover = "mouseover"

-- Call to avoid lua limit of 60upvalues 
-- Call RotationsVariables in each function that need these vars
local function RotationsVariables()
    combatTime = Unit(player):CombatTime()
	inCombat = Unit(player):CombatTime() > 0
    UseDBM = GetToggle(1 ,"DBM") -- Don't call it DBM else it broke all the global DBM var used by another addons
    Potion = GetToggle(1, "Potion")
    Racial = GetToggle(1, "Racial")
    HeartOfAzeroth = GetToggle(1, "HeartOfAzeroth")
	MouseOver = GetToggle(2, "mouseover")
    -- ProfileUI vars
    LayOnHandsHP = GetToggle(2, "LayOnHandsHP")
    LayOnHandsTTD = GetToggle(2, "LayOnHandsTTD")
    HolyShockHP = GetToggle(2, "HolyShockHP")
    HolyShockTTD = GetToggle(2, "HolyShockTTD")
	WordofGloryHP = GetToggle(2, "WordofGloryHP")
    LightofDawnHP = GetToggle(2, "LightofDawnHP")
    LightofDawnTTD = GetToggle(2, "LightofDawnTTD")    
    LightofDawnUnits = GetToggle(2, "LightofDawnUnits")
    FlashofLightHP = GetToggle(2, "FlashofLightHP")
    FlashofLightTTD = GetToggle(2, "FlashofLightTTD")
    HolyLightHP = GetToggle(2, "HolyLightHP")
    HolyLightTTD = GetToggle(2, "HolyLightTTD")
    LightoftheMartyrHP = GetToggle(2, "LightoftheMartyrHP")
    LightoftheMartyrTTD = GetToggle(2, "LightoftheMartyrTTD")
    LightsHammerHP = GetToggle(2, "LightsHammerHP")
    LightsHammerTTD = GetToggle(2, "LightsHammerTTD")
    HolyPrismHP = GetToggle(2, "HolyPrismHP")
    HolyPrismTTD = GetToggle(2, "HolyPrismTTD")   
    BeaconofVirtueHP = GetToggle(2, "BeaconofVirtueHP")
    BeaconofVirtueTTD = GetToggle(2, "BeaconofVirtueTTD")   
    BeaconWorkMode = GetToggle(2, "BeaconWorkMode")    
    LucidDreamManaPercent = GetToggle(2, "LucidDreamManaPercent")    
    LifeBindersInvocationUnits = GetToggle(2, "LifeBindersInvocationUnits")  
    LifeBindersInvocationHP = GetToggle(2, "LifeBindersInvocationHP")   
    ForceGlimmerOnMaxUnits = GetToggle(2, "ForceGlimmerOnMaxUnits")
	GlimmerTankOOC = GetToggle(2, "GlimmerTankOOC")
    AuraMasteryAoETTD = GetToggle(2, "AuraMasteryAoETTD")
    AuraMasteryAfter = GetToggle(2, "AuraMasteryAfter")
    AuraMasteryBelowHealthPercent = GetToggle(2, "AuraMasteryBelowHealthPercent")
    AuraMasteryLast = GetToggle(2, "AuraMasteryLast")
    AuraMasteryUnits = GetToggle(2, "AuraMasteryUnits")
    StartByPreCast = GetToggle(2, "StartByPreCast")
    TrinketMana = GetToggle(2, "TrinketMana")
    HolyShockDPS = GetToggle(2, "HolyShockDPS")
    -- Burst Settings from UI
    AvengingWrathPartyHP = GetToggle(2, "AvengingWrathPartyHP")
    AvengingWrathPartyUnits = GetToggle(2, "AvengingWrathPartyUnits")
    AvengingWrathRaidHP = GetToggle(2, "AvengingWrathRaidHP")
    AvengingWrathRaidUnits = GetToggle(2, "AvengingWrathRaidUnits")
    HolyAvengerPartyHP = GetToggle(2, "HolyAvengerPartyHP")
    HolyAvengerPartyUnits = GetToggle(2, "HolyAvengerPartyUnits")
    HolyAvengerRaidHP = GetToggle(2, "HolyAvengerRaidHP")
    HolyAvengerRaidUnits = GetToggle(2, "HolyAvengerRaidUnits")
	MythicPlusLogic = GetToggle(2, "MythicPlusLogic")
	StopCastOverHeal = GetToggle(2, "StopCastOverHeal")
	StopCastQuake = GetToggle(2, "StopCastQuake")
	StopCastQuakeSec = GetToggle(2, "StopCastQuakeSec")
	GrievousWoundsLogic = GetToggle(2, "GrievousWoundsLogic")
	GrievousWoundsMinStacks = GetToggle(2, "GrievousWoundsMinStacks")
	BlessingofFreedomWrathion = GetToggle(2, "BlessingofFreedomWrathion")
	WrathionMovementStacks = GetToggle(2, "WrathionMovementStacks")
	BlessingofFreedomShadhar = GetToggle(2, "BlessingofFreedomShadhar")
	AutoFreedom = GetToggle(2, "AutoFreedom")
end


-- Get Lowest Tank
local function GetLowestTank(option)
    -- Get Current Tanks Table
    local CurrentTanks = A.HealingEngine.GetMembersByMode("TANK")
   
    -- Protect against nil values
    if #CurrentTanks == 0 then
        if option == "GUID" then
            return "NoGuid"
        end

        if option == 'HP' then
            return 1000
        end
        
        if option == 'AHP' then
            return 1000
        end
        
        if option == 'UnitID' then
            return "NoUnit"
        end
    end

    -- GUID
    if option == "GUID" then
        return CurrentTanks[1].GUID or "NoGuid"
    end
    
    -- HP
    if option == 'HP' then
        return CurrentTanks[1].HP or 1000
    end
    
    -- AHP
    if option == 'AHP' then
        return CurrentTanks[1].AHP or 1000
    end
    
    -- UnitID
    if option == 'UnitID' then
        return CurrentTanks[1].Unit or "NoUnit"
    end
end

-- Get Lowest Healer
local function GetLowestHealer(option)
    -- Get Current Healers Table
    local CurrentHealers = A.HealingEngine.GetMembersByMode("HEALER")

    -- Protect against nil values
    if #CurrentHealers == 0 then
        if option == "GUID" then
            return "NoGuid"
        end

        if option == 'HP' then
            return 1000
        end
        
        if option == 'AHP' then
            return 1000
        end
        
        if option == 'UnitID' then
            return "NoUnit"
        end
    end

    -- GUID
    if option == "GUID" then
        return CurrentHealers[1].GUID or "NoGuid"
    end
    
    -- HP
    if option == 'HP' then
        return CurrentHealers[1].HP or 1000
    end
    
    -- AHP
    if option == 'AHP' then
        return CurrentHealers[1].AHP or 1000
    end
    
    -- UnitID
    if option == 'UnitID' then
        return CurrentHealers[1].Unit or "NoUnit"
    end
end

-- Get Lowest DPS
local function GetLowestDamager(option)
    -- Get Current Damagers Table
    local CurrentDamagers = A.HealingEngine.GetMembersByMode("DAMAGER")
    --Unit = member, GUID = memberGUID, HP = memberhp, AHP = memberahp, isPlayer = true, incDMG = Actual_DMG
   
    -- Protect against nil values
    if #CurrentDamagers == 0 then
        if option == "GUID" then
            return "NoGuid"
        end

        if option == 'HP' then
            return 1000
        end
        
        if option == 'AHP' then
            return 1000
        end
        
        if option == 'UnitID' then
            return "NoUnit"
        end
    end

    -- GUID
    if option == "GUID" then
        return CurrentDamagers[1].GUID or "NoGuid"
    end
    
    -- HP
    if option == 'HP' then
        return CurrentDamagers[1].HP or 1000
    end
    
    -- AHP
    if option == 'AHP' then
        return CurrentDamagers[1].AHP or 1000
    end
    
    -- UnitID
    if option == 'UnitID' then
        return CurrentDamagers[1].Unit or "NoUnit"
    end
end

-- Get Lowest ALL
local function GetLowestALL(option)
    -- Get Current Members Table
    local CurrentMembers = A.HealingEngine.GetMembersAll()
    --Unit = member, GUID = memberGUID, HP = memberhp, AHP = memberahp, isPlayer = true, incDMG = Actual_DMG
   
    -- Protect against nil values
    if #CurrentMembers == 0 then
        if option == "GUID" then
            return "NoGuid"
        end

        if option == 'HP' then
            return 1000
        end
        
        if option == 'AHP' then
            return 1000
        end
        
        if option == 'UnitID' then
            return "NoUnit"
        end
    end

    -- GUID
    if option == "GUID" then
        return CurrentMembers[1].GUID or "NoGuid"
    end
    
    -- HP
    if option == 'HP' then
        return CurrentMembers[1].HP or 1000
    end
    
    -- AHP
    if option == 'AHP' then
        return CurrentMembers[1].AHP or 1000
    end
    
    -- UnitID
    if option == 'UnitID' then
        return CurrentMembers[1].Unit or "NoUnit"
    end
end

-- Get Lowest Ally depending on parameters 
-- @parameters target and option are mandatory
-- @target can be "TANK", "DAMAGER", "HEALER" or "ALL"
-- @option can be "GUID", "HP", "AHP" or "UnitID"
-- return the current lowest member depending of choosen option

local function GetLowestAlly(target, option)
    if target == "TANK" then
        return GetLowestTank(option)
    end

    if target == "DAMAGER" then
        return GetLowestDamager(option)
    end

    if target == "HEALER" then
        return GetLowestHealer(option)
    end

    if target == "ALL" then
        return GetLowestALL(option)
    end
end

healingTarget = "None"
healingTargetGUID = "None"

-- Custom targetting function
-- @Parameter: TARGET is mandatory
-- @usage: Arguments can be "TANK", "HEALER", "DAMAGER", "ALL"
-- Return current LowestAlly based on arguments, example: current lowest tank
local function ForceHealingTarget(TARGET)
    --local target = TARGET or nil
    local CurrentHealers = A.HealingEngine.GetMembersByMode("HEALER")
    local CurrentDamagers = A.HealingEngine.GetMembersByMode("DAMAGER")
    local CurrentTanks = A.HealingEngine.GetMembersByMode("TANK")
    local CurrentMembers = A.HealingEngine.GetMembersAll()
    healingTarget = "None"
    healingTargetGUID = "None"
    HealingEngine.SetTarget(healingTarget)

    if TARGET == "TANK" then
        healingTarget = CurrentTanks[1].Unit
        healingTargetGUID = CurrentTanks[1].GUID
        HealingEngine.SetTarget(healingTarget)
        return
    end

    if TARGET == "DPS" and CurrentDamagers[1].HP < hp then
        healingTarget = CurrentDamagers[1].Unit
        healingTargetGUID = CurrentDamagers[1].GUID
        HealingEngine.SetTarget(healingTarget)
        return
    end

    if TARGET == "HEAL" and CurrentHealers[1].HP < hp then
        healingTarget = CurrentHealers[1].Unit
        healingTargetGUID = CurrentHealers[1].GUID
        HealingEngine.SetTarget(healingTarget)
        return
    end

    if TARGET == "ALL" and CurrentMembers[1].HP < 99 then
        healingTarget = CurrentMembers[1].Unit
        healingTargetGUID = CurrentMembers[1].GUID
        HealingEngine.SetTarget(healingTarget)
        return
    end
end

-- Custom HPal Dispell handler
local function ShouldDispell(unit)
    -- Do not dispel these spells
    local blacklist = {
        33786,
        131736,
        30108,
        124465,
        34914
    }
    -- Dispell Types
    local dispelTypes = {
        "Poison",
        "Disease",
        "Magic"
    }
    
    for i = 1, 40 do
        for x = 1, #dispelTypes do
            local name, rank, icon, count, debuffType = UnitDebuff(unit, i) 
            if debuffType == dispelTypes[x] then
                for i = 1, #blacklist do
                    if Unit(unit):HasDeBuffs(blacklist[i], true) then
                        return false
                    end
                end
                return true
            end
        end
    end
    return false
end
ShouldDispell = A.MakeFunctionCachedDynamic(ShouldDispell)

local Temp                               = {
    TotalAndPhys                            = {"TotalImun", "DamagePhysImun"},
    TotalAndPhysKick                        = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC                       = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun                     = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun                = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMag                             = {"TotalImun", "DamageMagicImun"},
    TotalAndMagKick                         = {"TotalImun", "DamageMagicImun", "KickImun"},
	-- Anti overhealing
	IsSpellIsCast                           = {
        [A.FlashofLight:Info()]                 = "FlashofLight",
        [A.HolyLight:Info()]                    = "HolyLight",        
    }, 
}

local GetTotemInfo, IsMouseButtonDown, UnitIsUnit = GetTotemInfo, IsMouseButtonDown, UnitIsUnit

local function IsSchoolFree()
    return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "NATURE") == 0
end 

local function InMelee(unit)
    -- @return boolean 
    return A.Judgment:IsInRange(unit)
end 

-- @return boolean  
-- @parameters count, range are mandatory, others parameters optionals
local ActiveUnitPlates = MultiUnits:GetActiveUnitPlates()
local function GetByRange(count, range, isCheckEqual, isCheckCombat)
    local c = 0 
    for unit in pairs(ActiveUnitPlates) do 
        if (not isCheckEqual or not UnitIsUnit(target, unit)) and (not isCheckCombat or Unit(unit):CombatTime() > 0) then 
            if InMelee(unit) then 
                c = c + 1
            elseif range then 
                local r = Unit(unit):GetRange()
                if r > 0 and r <= range then 
                    c = c + 1
                end 
            end 
            
            if c >= count then 
                return true 
            end 
        end 
    end
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

    -- DivineShield
    local DivineShield = A.GetToggle(2, "DivineShield")
    if     DivineShield >= 0 and A.DivineShield:IsReady(player) and 
    (
        (     -- Auto 
            DivineShield >= 100 and 
            (
                (
                    not A.IsInPvP and 
                    Unit(player):HealthPercent() < 25 and 
                    Unit(player):TimeToDieX(5) < 6 
                ) or 
                (
                    A.IsInPvP and Unit(player):HealthPercent() < 20 and 
                    (
                        Unit(player):UseDeff() or 
                        (
                            Unit(player, 5):HasFlags() and 
                            Unit(player):GetRealTimeDMG() > 0 and 
                            Unit(player):IsFocused(nil, true)                                 
                        )
                    )
                )
            ) and 
            Unit(player):HasDeBuffs(A.Forbearance.ID, true) == 0
        ) or 
        (    -- Custom
            DivineShield < 100 and 
            Unit(player):HealthPercent() <= DivineShield
        )
    ) 
    then 
        return A.DivineShield
    end
    
    -- BlessingofProtection
    local BlessingofProtection = A.GetToggle(2, "BlessingofProtection")
    if BlessingofProtection >= 0 and A.BlessingofProtection:IsReady(player) and
    (
        (    -- Auto
            BlessingofProtection >=  100 and
            (
                (
                    not A.IsInPvP and
                    Unit(player):HealthPercent() < 30 and
                    Unit(player):TimeToDieX(20) < 3 and 
                    Unit(player):GetRealTimeDMG(3) > 0 and
                    Unit(player):HasDeBuffs(A.Forbearance.ID, true) == 0
                ) or
                (
                    A.IsInPvP and                        
                    (
                        (    -- Defensive
                            Unit(player):HealthPercent() < 35 and
                            Unit(player):GetRealTimeDMG(3) > 0 and
                            Unit(player):IsFocused("MELEE", true) and
                            Unit(player):HasBuffs("DeffBuffs") == 0
                        ) or
                        (    -- Disarmed
                            Unit(player):HasBuffs(A.AvengingWrath.ID, true) > 10 and
                            LoC:Get("DISARM") > 4.5
                        ) or
                        (    -- PvP Debuffs (Touch of Death, Karma, Vendetta
                            Unit(player):HasDeBuffs(Temp.BoPDebuffsPvP) > 4 or
                            Unit(player):HasDeBuffs(A.VendettaDebuff.ID) > 15
                        )
                    )
                )
            )
        ) or 
        (    -- Custom
            BlessingofProtection < 100 and 
            Unit(player):HealthPercent() <= BlessingofProtection
        )
    ) 
    then 
        return A.BlessingofProtection
    end

	if not Player:IsStealthed() then 	
		-- Healthstone | AbyssalHealingPotion
		local Healthstone = GetToggle(1, "HealthStone") 
		if Healthstone >= 0 then 
			if A.HS:IsReady(player) then 					
				if Healthstone >= 100 then -- AUTO 
					if Unit(player):TimeToDie() <= 9 and Unit(player):HealthPercent() <= 40 then					
						return A.HS
					end 
				elseif Unit(player):HealthPercent() <= Healthstone then 				
					return A.HS							 
				end
			elseif A.Zone ~= "arena" and (A.Zone ~= "pvp" or not Action.InstanceInfo.isRated) and A.SpiritualHealingPotion:IsReady(player) then 
				if Healthstone >= 100 then -- AUTO 
					if Unit(player):TimeToDie() <= 9 and Unit(player):HealthPercent() <= 40 and Unit(player):HealthDeficit() >= A.SpiritualHealingPotion:GetItemDescription()[1] then					
						return A.AbyssalHealingPotion
					end 
				elseif Unit(player):HealthPercent() <= Healthstone then				
					return A.AbyssalHealingPotion						 
				end				
			end 
		end
		
		-- PhialofSerenity
		if A.Zone ~= "arena" and (A.Zone ~= "pvp" or not Action.InstanceInfo.isRated) and A.PhialofSerenity:IsReady(player) then 
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
    
    -- Stoneform on self dispel (only PvE)
    if A.Stoneform:IsRacialReady("player", true) and not A.IsInPvP and A.AuraIsValid("player", "UseDispel", "Dispel") then 
        return A.Stoneform
    end 
      
end 
SelfDefensives = A.MakeFunctionCachedStatic(SelfDefensives)

-----------------------------------------
--        ROTATION FUNCTIONS           --
-----------------------------------------

-- Return boolean
-- Current HPS > Incoming damage
local function IsEnoughHPS(unit)
    return Unit(player):GetHPS() > Unit(unit):GetDMG()
end 

-- Return boolean
-- Current Group HPS > Incoming damage
local function IsGroupEnoughHPS()
    return ((HealingEngine.GetIncomingHPSAVG() > HealingEngine.GetIncomingDMGAVG()) or (not IsInRaid() and not IsInGroup()))
end

-- Return boolean
-- Current Group is taking massive damage that need burst
local function NeedEmergencyHPS()
    return ( HealingEngine.GetIncomingHPSAVG() * 2 < HealingEngine.GetIncomingDMGAVG() )
end

-- Return boolean
-- Current Group is taking ultra massive damage that need burst
local function NeedUltraEmergencyHPS()
    return ( HealingEngine.GetIncomingHPSAVG() * 3 < HealingEngine.GetIncomingDMGAVG() )
end

-- Mana Management
local function IsSaveManaPhase()
    if not A.IsInPvP and A.GetToggle(2, "ManaManagement") then 
        for i = 1, MAX_BOSS_FRAMES do 
            if Unit("boss" .. i):IsExists() and not Unit("boss" .. i):IsDead() and Unit(player):PowerPercent() < Unit("boss" .. i):HealthPercent() then 
                return true 
            end 
        end 
    end 
    return Unit(player):PowerPercent() < 20 
end 
IsSaveManaPhase = A.MakeFunctionCachedStatic(IsSaveManaPhase)

-- Non GCD spell check
local function countInterruptGCD(unit)
    if not A.Rebuke:IsReadyByPassCastGCD(unit) or not A.Rebuke:AbsentImun(unit, Temp.TotalAndMagKick) then
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
        
		-- Try Aoe CC Enemy if no agro
        if useCC and not A.Rebuke:IsReady(unit) and A.BlindingLight:IsSpellLearned() and A.BlindingLight:IsReady("player") and (GetByRange(2, 10) or EnemiesCasting > 1) then
            return A.BlindingLight
        end

        if useKick and A.Rebuke:IsReady(unit) and A.Rebuke:AbsentImun(unit, Temp.TotalAndPhysKick, true) then 
            -- Notification                    
            Action.SendNotification("Rebuke interrupting on Target ", A.Rebuke.ID)
            return A.Rebuke
        end 
    
        if useCC and A.HammerofJustice:IsReady(unit) and A.HammerofJustice:AbsentImun(unit, Temp.TotalAndPhysAndCCAndStun, true) then 
            -- Notification                    
            Action.SendNotification("HammerofJustice interrupting...", A.HammerofJustice.ID)
            return A.HammerofJusticeGreen              
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

-- Return total active Glimmer of Light buff and debuff
local function GlimmerofLightCount()
    return HealingEngine.GetBuffsCount(A.GlimmerofLightBuff.ID, 0, player, true)
end

-- Return total active Beacon of Light Buff for player only
local function ActiveBeacon()
    return HealingEngine.GetBuffsCount(A.BeaconofLight.ID, 0, player, true)
end

-- Return total active Beacon of Light Buff for tank only
local function ActiveBeaconOnTank()
    local CurrentTanks = HealingEngine.GetMembersByMode("TANK")
	local total = 0
	-- Iterate through current tanks
	for i = 1, #CurrentTanks do 
	    if Unit(CurrentTanks[i].Unit):HasBuffs(A.BeaconofLight.ID, true) > 0 then
            total = total + 1
        end
	end
    return total
end

-- Return valid members that can be healed
--@parameter IsPlayer : return only members that are real players
local function GetValidMembers(IsPlayer)
    local HealingEngineMembersALL = A.HealingEngine.GetMembersAll()
    if not IsPlayer then 
        return #HealingEngineMembersALL
    else 
        local total = 0 
        if #HealingEngineMembersALL > 0 then 
            for i = 1, #HealingEngineMembersALL do
                if Unit(HealingEngineMembersALL[i].Unit):IsPlayer() then
                    total = total + 1
                end
            end 
        end 
        return total 
    end 
end

-- Tracks destination unit of the casting spells to prevent by stopcasting overhealing 
local TeamCacheFriendlyGUIDs				= Action.TeamCache.Friendly.GUIDs
local function CastStart(event, ...)
    local unitID, _, spellID = ...
    if unitID == player and spellID then 
        local spellName = GetSpellInfo(spellID)
        if spellName and Temp.IsSpellIsCast[spellName] then 
            Temp.LastPrimaryUnitGUID     = (IsUnitFriendly(mouseover) and Unit(mouseover):InfoGUID()) or (IsUnitFriendly(target) and Unit(target):InfoGUID()) or Unit(player):InfoGUID()
            Temp.LastPrimaryUnitID       = TeamCacheFriendlyGUIDs[Temp.LastPrimaryUnitGUID]
            Temp.LastPrimarySpellName    = spellName 
            Temp.LastPrimarySpellID      = spellID
        end 
    end 
end 

local function CastStop(event, ...)
    if Temp.LastPrimaryUnitGUID then     
        local unitID = ...
        if unitID == player then 
            Temp.LastPrimaryUnitGUID     = nil 
            Temp.LastPrimaryUnitID       = nil 
            Temp.LastPrimarySpellName    = nil 
            Temp.LastPrimarySpellID      = nil 
        end 
    end 
end 

Listener:Add("ACTION_EVENT_HOLY_PALADIN", "UNIT_SPELLCAST_START",            CastStart   )
Listener:Add("ACTION_EVENT_HOLY_PALADIN", "UNIT_SPELLCAST_STOP",             CastStop    )
Listener:Add("ACTION_EVENT_HOLY_PALADIN", "UNIT_SPELLCAST_FAILED",           CastStop    )
Listener:Add("ACTION_EVENT_HOLY_PALADIN", "UNIT_SPELLCAST_INTERRUPTED",      CastStop    )
Listener:Add("ACTION_EVENT_HOLY_PALADIN", "UNIT_SPELLCAST_CHANNEL_START",    CastStart   )
Listener:Add("ACTION_EVENT_HOLY_PALADIN", "UNIT_SPELLCAST_CHANNEL_STOP",     CastStop    )

local function CanStopCastingOverHeal(unitID, unitGUID)
    -- @return boolean 
    if GetToggle(1, "StopCast") and Temp.LastPrimaryUnitGUID then
        local castLeftSeconds, castDonePercent, _, spellName = Unit(player):IsCastingRemains()
        if castLeftSeconds > 0 and castLeftSeconds <= 0.35 and spellName == Temp.LastPrimarySpellName and (Temp.LastPrimaryUnitID or (unitID and ((unitGUID or UnitGUID(unitID)) == Temp.LastPrimaryUnitGUID))) then
            local unit = Temp.LastPrimaryUnitID or unitID
            if Unit(unit):HealthPercent() >= 100 then 
                return true 
            end 
            
            local Key = Temp.IsSpellIsCast[spellName]
            local ObjKey
            for i = 0, huge do 
                if i == 0 then 
                    ObjKey = Key
                else 
                    ObjKey = Key .. i
                end 
                
                if A[ObjKey] then 
                    if A[ObjKey].ID == Temp.LastPrimarySpellID then 
                        --return not A[ObjKey]:PredictHeal(unit, 0.8, unitGUID)
						return not A[ObjKey]:PredictHeal(unit, 0.8)
                    end 
                else 
                    break 
                end 
            end 
        end 
    end 
end 

local function HoF(unit, Icon)    
    --local msg = MacroSpells(Icon, "Freedom")
    return
    --(
   --     msg or 
   --     HoF_toggle  
   -- ) and
    A.BlessingofFreedom:IsReady(unit) and 
    Unit(unit):IsPlayer() and
    (
        -- SELF
        (
            UnitIsUnit(unit, player) and 
            (
                Unit(unit):HasDeBuffs("Rooted") > GetCurrentGCD() + GetGCD() or 
                (
                    Unit(player):GetCurrentSpeed() > 0 and 
                    Unit(player):GetMaxSpeed() < 100
                )
            )
        ) or
        -- ANOTHER UNIT 
        (
            -- Useable conditions
            Unit(unit):IsExists() and 
            not UnitIsUnit(unit, player) and 
            select(2, UnitClass(unit)) ~= "DRUID" and
            --not Unit(unit):InLOS() and         
            A.BlessingofFreedom:IsInRange(unit)    and        
            Unit(unit):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone    
            (
                -- MSG System
               -- msg or 
                -- Rooted and Solar Beam
                (
                    Unit(unit):HasDeBuffs(78675, true) > 0 and  
                    Unit(unit):HasDeBuffs("Rooted") > GetCurrentGCD()
                ) 
                or 
                -- Rooted without inc dmg 
                (
                    Unit(unit):HasDeBuffs("Rooted") > 3 and
                    Unit(unit):GetRealTimeDMG() <= Unit(unit):HealthMax() * 0.1 
                ) 
                or 
                -- Slowed (if we no need freedom for self)
                (
                    (
                        -- 8.2 changes Unbound Freedom
                        A.IsSpellLearned(305394) or 
                        not Unit(player):IsFocused() or 
                        Unit(player):GetMaxSpeed() >= 100
                    ) and
                    Unit(unit):GetCurrentSpeed() > 0 and 
                    Unit(unit):GetMaxSpeed() < 80 and 
                    (
                        (
                            -- 8.2 changes Unbound Freedom
                            A.IsSpellLearned(305394) and 
                            Unit(player):GetCurrentSpeed() < 100
                        ) or 
                        (
                            Unit(unit):HasBuffs("DamageBuffs") > 6 and 
                            Unit(unit):HasDeBuffs("Slowed") > 0 and 
                            Unit(unit):HasDeBuffs("Disarmed") <= GetCurrentGCD()
                        )
                    )
                ) 
                or 
                (                
                    Action.ZoneID == 1580 and                   -- Ny'alotha - Vision of Destiny
                    Unit(unit):HasDeBuffsStacks(307056) >= 40 -- Burning Madness
                )
            )
        )
    ) and
    -- Check another CC types 
    -- Hex, Polly, Repentance, Blind, Wyvern Sting, Ring of Frost, Paralysis, Freezing Trap, Mind Control
    Unit(unit):HasDeBuffs({51514, 118, 20066, 2094, 19386, 82691, 115078, 3355, 605}, true) <= GetCurrentGCD() and 
    Unit(unit):HasDeBuffs("Incapacitated") <= GetCurrentGCD() and 
    Unit(unit):HasDeBuffs("Disoriented") <= GetCurrentGCD() and 
    Unit(unit):HasDeBuffs("Fear") <= GetCurrentGCD() and 
    Unit(unit):HasDeBuffs("Stuned") <= GetCurrentGCD()  
end    


local function SacrificeAble(unit)
    -- Function to check if we can use sacriface with max profit time duration on unit
    local dmg, u_ttd, bubble, shield = Unit(unit):GetDMG() * 0.7, Unit(unit):TimeToDie() * 0.7, Unit(player):HasBuffs(642, true), 1
    -- -20% incoming damage
    local shield_buff = Unit(player):HasBuffs(498, true)
    if shield_buff > 0 then 
        shield = dmg * ( 0.2 - (0.2 - (shield_buff * 0.2 / 8)) )
    end
    
    local p_ttd, p_chp = 0, Unit(player):Health()
    if not A.UltimateSacrifice:IsSpellLearned() or not A.IsInPvP then
        -- Real player's ttd to lower 20% under sacriface and shield buff
        local p_mhp = Unit(player):HealthMax() * 0.2
        if p_chp > p_mhp and dmg > 0 and u_ttd > 0 then 
            local muliplier = 0.75
            -- If Protection then 100% receiving damage by Sacriface
            if Unit(player):HasSpec(66) then 
                muliplier = 1
            end     
            p_ttd = math.abs(        
                -- Current HP without 20% / incdmg by Sacriface + already exist incdmg for yourself
                (p_chp - p_mhp) /
                (( dmg * muliplier * (1 - (GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE)/2/100)) ) + Unit(player):GetDMG() )
            )     
        end
    else
        p_ttd = math.abs(        
            -- Current HP / incdmg by Sacriface + already exist incdmg for yourself
            p_chp /
            (( dmg * (1 - (GetCombatRatingBonus(CR_VERSATILITY_DAMAGE_DONE)/2/100)) ) + Unit(player):GetDMG() )
        )    
    end 
    
    if bubble > 0 then 
        p_ttd = p_ttd + bubble
    end
    
    return p_ttd + GetCurrentGCD() >= u_ttd, p_ttd
end

-- Hand of Sacrifice
local function HoS(unit, hp, IsRealDMG, IsDeffensed)  
    return 
    Unit(unit):IsExists() and 
    Unit(unit):IsPlayer() and
    not UnitIsUnit(unit, player) and
    --not Unit(unit):InLOS() and 
    (UnitInRaid(unit) or UnitInParty(unit)) and 
    A.BlessingofSacrifice:IsReady(unit) and
    A.BlessingofSacrifice:IsInRange(unit) and 
    Unit(unit):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone 
    Unit(player):Health() > Unit(player):HealthMax() * 0.2 and       
    (
        -- MSG System TO ACTION
        --(
        --    Icon and 
         --   MacroSpells(Icon, "HoS") 
        --) or  
        -- HoS conditions 
        (
           -- HoS_toggle and 
            SacrificeAble(unit) and 
            Unit(unit):HasBuffs(1022, true) == 0 and -- BoP
            -- Check args
            (
                not IsRealDMG or
                Unit(unit):GetRealTimeDMG() > 0
            ) and 
            ( 
                not IsDeffensed or 
                Unit(unit):HasBuffs("DeffBuffs", true) == 0
            ) and 
            -- Check if unit don't will be killed 
            (
                not Unit(player):HasSpec(65) or -- Holy
                Unit(unit):TimeToDie() >= 4 
            ) and 
            -- Conditions
            (
                -- Check for HP arg
                ( 
                    hp and 
                    Unit(unit):Health() <= Unit(unit):HealthMax() * (hp / 100)
                ) or 
                -- Another check 
                (
                    Unit(unit):TimeToDie() < 14 and 
                    (
                        (
                            Unit(unit):Health() <= Unit(unit):HealthMax() * 0.35 and 
                            (
                                Unit(unit):GetHEAL()  * 1.4 < Unit(unit):GetDMG() or
                                Unit(unit):Health() <= Unit(unit):GetDMG() * 3.5 
                            ) 
                        ) or 
                        -- if unit has 35% dmg per sec 
                        Unit(unit):GetRealTimeDMG() >= Unit(unit):HealthMax() * 0.35 or 
                        -- if unit has sustain 20% dmg per sec 
                        Unit(unit):GetDMG() >= Unit(unit):HealthMax() * 0.2
                    )
                )
            )
        )
    )
end 

local function UrgentMythicPlusTargetting()
    
    local getmembersAll = HealingEngine.GetMembersAll()
	local BleedFriendCount = 0
	local BleedStack = 0
	RotationsVariables()
	
	if MythicPlusLogic then
 
		-- Grievous Wounds
		-- Only check on minimum Mythic +7
        if Action.InstanceInfo.KeyStone >= 7 and GrievousWoundsLogic then
            for i = 1, #getmembersAll do
                if Unit(getmembersAll[i].Unit):HealthPercent() < 100 and Unit(getmembersAll[i].Unit):GetRange() <= 40 or UnitIsUnit(getmembersAll[i].Unit, "player") then
					local CurrentBleedstack = Unit(getmembersAll[i].Unit):HasDeBuffsStacks(A.GrievousWound.ID, true)
                    if CurrentBleedstack >= GrievousWoundsMinStacks then
                        HealingEngine.SetTarget(getmembersAll[i].Unit) -- default 2sec delay to stay on target
                    end
					
                end
            end
        end			
		
    end     
end

-- Return average DMG taken from all our current member team
local function FriendlyTeamReceivedLast5sec()
    local total = 0
	local getmembersAll = HealingEngine.GetMembersAll()
	
    if #getmembersAll > 0 then 
        for i = 1, #getmembersAll do
		    -- Avoid getting pet damage
		    if Unit(getmembersAll[i].Unit):IsPlayer() then
                total = total + Unit(getmembersAll[i].Unit):GetLastTimeDMGX(5)
			end
        end
		
		avg = total / #getmembersAll
    end 
    return total
end

function FriendlyTeam:GetLastTimeDMGX(x, range)
    -- @return number, number, number
    -- [1] Average received damage latest 'x' seconds 
    -- [2] Summary received damage latest 'x' seconds 
    -- [3] Count of members valid for conditions
    -- Nill-able: range
    local ROLE                            = self.ROLE
    local lastDMG, members                = 0, 0
    local member
    
    if TeamCacheFriendly.Size <= 1 then 
        if Unit("player"):Role(ROLE) then  
            lastDMG = Unit("player"):GetLastTimeDMGX(x)
            return lastDMG, 1     
        end 
        
        return lastDMG, members
    end         
    
    if ROLE and TeamCacheFriendly[ROLE] then 
        for member in pairs(TeamCacheFriendly[ROLE]) do
            if Unit(member):InRange() and (not range or Unit(member):GetRange() <= range) then
                lastDMG = lastDMG + Unit(member):GetLastTimeDMGX(x)   
                members = members + 1
            end             
        end             
    else
        for i = 1, TeamCacheFriendly.MaxSize do
            member = TeamCacheFriendlyIndexToPLAYERs[i]                
            if member and Unit(member):InRange() and (not range or Unit(member):GetRange() <= range) then
                lastDMG = lastDMG + Unit(member):GetLastTimeDMGX(x)   
                members = members + 1
            end 
        end  
        
        if TeamCacheFriendly.Type ~= "raid" then
            lastDMG = lastDMG + Unit("player"):GetLastTimeDMGX(x)  
            members = members + 1
        end 
    end      
    
    if lastDMG == 0 and members == 0 then 
        return 0, lastDMG, members
    else 
        return lastDMG / members, lastDMG, members
    end 
end

		
-- [3] Single Rotation
A[3] = function(icon, isMulti)
    --------------------
    --- ROTATION VAR ---
    --------------------
    local CurrentTanks = HealingEngine.GetMembersByMode("TANK")
	local getmembersAll = HealingEngine.GetMembersAll()
	local inCombat = Unit(player):CombatTime() > 0
    local isMoving = Player:IsMoving()
    local isMovingFor = A.Player:IsMovingTime()
    local combatTime = Unit(player):CombatTime()    
    local ShouldStop = Action.ShouldStop()
    local Pull = Action.BossMods:GetPullTimer()
	local AoEON = GetToggle(2, "AoE")
    -- Healing Engine vars
    local ReceivedLast5sec = FriendlyTeam("ALL"):GetLastTimeDMGX(5) --Unit(player):GetLastTimeDMGX(5) -- LastIncDMG(player, 5)
    local AVG_DMG = HealingEngine.GetIncomingDMGAVG()
    local AVG_HPS = HealingEngine.GetIncomingHPSAVG()
    local TeamCacheEnemySize = TeamCache.Enemy.Size
	local DungeonGroup = TeamCache.Friendly.Size >= 2 and TeamCache.Friendly.Size <= 5
	local RaidGroup = TeamCache.Friendly.Size >= 5
    RotationsVariables()    
	local WingsIsUp = Unit(player):HasBuffs(A.AvengingWrath.ID, true) > 0 or Unit(player):HasBuffs(A.AvengingCrusader.ID, true) > 0 or A.AvengingWrath:GetCooldown() < A.GetGCD() or A.AvengingCrusader:GetCooldown() < A.GetGCD()
	
	--------------------------------
	local UseCovenant = A.GetToggle(1, "Covenant")

	
    --------------------
    --- DPS ROTATION ---
    --------------------
    local function DamageRotation(unitID)
 
 		if A.VanquishersHammer:IsReady(unitID) and UseCovenant then
			return A.VanquishersHammer:Show(icon)
		end	
 
		if A.Consecration:IsReady(unitID) and MultiUnits:GetByRange(5, 2) >= 1 then
			return A.Consecration:Show(icon)
		end	
		
 		if A.ShieldoftheRighteous:IsReady(player) and HealingEngine.GetBelowHealthPercentUnits(90, 40) < 1 then
			return A.ShieldoftheRighteous:Show(icon)
		end	
		
		if A.HammerofWrath:IsReady(unitID) then
			return A.HammerofWrath:Show(icon)
		end	
	
		if A.Judgment:IsReady(unitID) then
			return A.Judgment:Show(icon)
		end

		if A.HolyPrism:IsReady(unitID) then
			return A.HolyPrism:Show(icon)
		end	

		if A.HolyShock:IsReady(unitID) and A.IsUnitEnemy(target) then
			return A.HolyShock:Show(icon)
		end
		
		if A.CrusaderStrike:IsReady(unitID) then
			return A.CrusaderStrike:Show(icon)
		end	

    end
    DamageRotation = Action.MakeFunctionCachedDynamic(DamageRotation)
    
    ---------------------
    --- HEAL ROTATION ---
    ---------------------
    local function HealingRotation(unitID) 
        
	local useDispel, useShields, useHoTs, useUtils = HealingEngine.GetOptionsByUnitID(unit)
	local unitGUID = UnitGUID(unit)	
	
		--Avenging Wrath
		if A.AvengingWrath:IsReady(unitID) and Unit(player):HasBuffs(A.HolyAvenger.ID, true) == 0 and (HealingEngine.GetBelowHealthPercentUnits(50, 30) >= 3 or Unit(unitID):HealthPercent() <= 25) then
			return A.AvengingWrath:Show(icon)
		end	
	
		--Holy Avenger
		if A.HolyAvenger:IsReady(unitID) and not WingsIsUp and (HealingEngine.GetBelowHealthPercentUnits(50, 30) >= 3 or Unit(unitID):HealthPercent() <= 25) then
			return A.HolyAvenger:Show(icon)
		end	
	
		--Light of Dawn at 5 HP
		if A.LightofDawn:IsReady(player) and HealingEngine.GetBelowHealthPercentUnits(95, 15) >= 4 and Player:HolyPower() >= 5 then
			return A.LightofDawn:Show(icon)
		end

		--Word of Glory at 5 HP
		if A.WordofGlory:IsReady(unitID) and A.WordofGlory:PredictHeal(unitID) and Unit(unitID):HealthPercent() <= 95 and Player:HolyPower() >= 5 then
			return A.WordofGlory:Show(icon)
		end

		--Blessing of Sacrifice
		if BlessingofSacrifice:IsReady(unitID) and Unit(unitID):HealthPercent() <= 50 and Unit(unitID):IsTanking() and not WingsIsUp and not Unit(player):HasBuffs(A.AuraMastery.ID, true) > 0 then
			return A.BlessingofSacrifice:Show(icon)
		end	
		
		--Divine Shield while BoS active to prevent fall off
		if A.DivineShield:IsReady(unitID) and HealingEngine.GetBuffsCount(A.BlessingofSacrifice.ID, 3) >= 1 and Unit(player):HealthPercent() <= 30 then
			return A.DivineShield:Show(icon)
		end	

		--Lay on hands
        if A.LayOnHands:IsReady(unitID) and inCombat and Action.Zone ~= "arena" and not Action.InstanceInfo.isRated 
        then
            for i = 1, #getmembersAll do 
                if Unit(getmembersAll[i].Unit):GetRange() <= 40 then 
                      if not Unit(getmembersAll[i].Unit):IsPet() and A.LayOnHands:IsReady(getmembersAll[i].Unit) and Unit(getmembersAll[i].Unit):HealthPercent() <= 15 and Unit(getmembersAll[i].Unit):HasDeBuffs(A.Forbearance.ID, true) == 0 then
                        HealingEngine.SetTarget(getmembersAll[i].Unit, 1)        
                        return A.LayOnHands:Show(icon)                        
                    end                    
                end                
            end    
        end 
		
    	-- Dispel Sniper
        if A.Cleanse:IsReady() then
     		for i = 1, #getmembersAll do 
                if Unit(getmembersAll[i].Unit):GetRange() <= 40 and AuraIsValid(getmembersAll[i].Unit, "UseDispel", "Dispel") then 
					if UnitGUID(getmembersAll[i].Unit) ~= currGUID then
						HealingEngine.SetTarget(getmembersAll[i].Unit) 
						break
					else 				
			        HealingEngine.SetTarget(getmembersAll[i].Unit)
					end
                end				
            end
        end
		-- Dispel cast
		if CanCast and A.Purify:IsReady(player) and A.Purify:AbsentImun(player) and A.AuraIsValid(player, "UseDispel", "Dispel") and Unit(player):TimeToDie() > 5 then 
			return A.Purify:Show(icon)
		end 			

		-- Becon of Light tank
        if A.BeaconofLight:IsReady() and BeaconWorkMode == "Tanking Units" and ActiveBeaconOnTank == 0 then
            for i = 1, #CurrentTanks do 
                if Unit(CurrentTanks[i].Unit):GetRange() <= 40 then 
                      if Unit(CurrentTanks[i].Unit):IsPlayer() and Unit(CurrentTanks[i].Unit):HasBuffs(A.BeaconofLight.ID, true) == 0  then    
						if UnitGUID(getmembersAll[i].Unit) ~= currGUID then
							HealingEngine.SetTarget(getmembersAll[i].Unit) 
							break
						else 
						HealingEngine.SetTarget(CurrentTanks[i].Unit, 1)                      
                        return A.BeaconofLight:Show(icon)
						end
                    end                    
                end                
            end    
        end

		--Beacon of Virtue
		if A.BeaconofVirtue:IsReady(unitID) and HealingEngine.GetBelowHealthPercentUnits(85, 40) >= 4 then
			return A.BeaconofVirtue:Show(icon)
		end	

		--Divine Toll
		if A.DivineToll:IsReady(unitID) and UseCovenant and Player:HolyPower() == 0 and HealingEngine.GetBelowHealthPercentUnits(90, 30) >= 3 and not WingsIsUp then
			return A.DivineToll:Show(icon)
		end
		
		--Aura Mastery
		if DungeonGroup then
			if A.AuraMastery:IsReady(unitID) and HealingEngine.GetBelowHealthPercentUnits(60, 30) >= 3 and A.DivineToll:GetCooldown() > 2 and not WingsIsUp then
				return A.AuraMastery:Show(icon)
			end	
		end
		
		if RaidGroup then
			if A.AuraMastery:IsReady(unitID) and HealingEngine.GetBelowHealthPercentUnits(60, 30) >= 10 and A.DivineToll:GetCooldown() > 2 and not WingsIsUp then
				return A.AuraMastery:Show(icon)
			end	
		end	

		--Ashen Hallow
		if A.AshenHallow:IsReady(unitID) and UseCovenant and HealingEngine.GetBelowHealthPercentUnits(95, 30) >= 3 then
			return A.AshenHallow:Show(icon)
		end

		--Holy Shock target
		if A.HolyShock:IsReady(unitID) and A.HolyShock:PredictHeal(unitID) and Unit(unitID):HealthPercent() <= 90 then
			return A.HolyShock:Show(icon)
		end

		--[[Holy Shock spread
        if A.HolyShock:GetCooldown() == 0 and A.GlimmerofLight:IsTalentLearned() then
            for i = 1, #getmembersAll do 
                if Unit(getmembersAll[i].Unit):IsPlayer() and not IsUnitEnemy(getmembersAll[i].Unit) and A.HolyShock:IsReady(getmembersAll[i].Unit) and Unit(getmembersAll[i].Unit):HealthPercent() <= 98 and Unit(getmembersAll[i].Unit):GetRange() <= 40 then 
					if UnitGUID(getmembersAll[i].Unit) ~= currGUID then
						HealingEngine.SetTarget(getmembersAll[i].Unit) 
						break
					else 				
                    HealingEngine.SetTarget(getmembersAll[i].Unit)					      
                    return A.HolyShock:Show(icon)
					end 
				end
            end    
        end  ]]

		--Rule of Law
        if A.RuleofLaw:IsReady(player) and A.IsUnitFriendly(unit) and combatTime > 0 and A.RuleofLaw:IsSpellLearned() and Unit(player):HasBuffs(A.RuleofLaw.ID, true) == 0 and inCombat and 
		((Unit(unit):CanInterract(40) and (A.RuleofLaw:GetSpellChargesFrac() >= 2 and Unit(unit):Health() <= Unit(unit):HealthMax()*0.6) or (Unit(unit):TimeToDie() <= 6 or Unit(unit):Health() <= Unit(unit):HealthMax()*0.35) or (not Unit(unit):CanInterract(40)))) then
            return A.RuleofLaw:Show(icon)
        end

		--Bestow Faith
		if A.BestowFaith:IsReady(unitID) and A.BestowFaith:PredictHeal(unitID) and Unit(unitID):HealthPercent() <= 95 then
			return A.BestowFaith:Show(icon)
		end	

		--Light of Dawn 4 HP
		if A.LightofDawn:IsReady(player) and HealingEngine.GetBelowHealthPercentUnits(95, 15) >= 4 then
			return A.LightofDawn:Show(icon)
		end

		--Word of Glory 3 HP
		if A.WordofGlory:IsReady(unitID) and A.WordofGlory:PredictHeal(unitID) and Unit(unitID):HealthPercent() <= 90 then
			return A.WordofGlory:Show(icon)
		end
		
		--CrusaderStrike to prevent charge cap
		if A.CrusaderStrike:IsReady(unitID) and A.CrusaderStrike:GetSpellChargesFrac() > 1.7 then
			return A.CrusaderStrike:Show(icon)
		end

		--Judgment with Judgment of Light talent
		if A.Judgment:IsReady(unitID) and A.JudgmentofLight:IsTalentLearned() then
			return A.Judgment:Show(icon)
		end

		--Light's Hammer
		if A.LightsHammer:IsReady(unitID) and HealingEngine.GetBelowHealthPercentUnits(85, 15) >= 3 then
			return A.LightsHammer:Show(icon)
		end	

		--Night Fae covenant
		if A.BlessingofSummer:IsReady(unitID) and UseCovenant then
			return A.BlessingofSummer:Show(icon)
		end

		if A.BlessingofSpring:IsReady(unitID) and UseCovenant then
			return A.BlessingofSpring:Show(icon)
		end		
		
		if A.BlessingofAutumn:IsReady(unitID) and UseCovenant then
			return A.BlessingofAutumn:Show(icon)
		end		
		
		if A.BlessingofWinter:IsReady(unitID) and UseCovenant then
			return A.BlessingofWinter:Show(icon)
		end		

		--Caster Heals
		--Party
		if DungeonGroup then 

			-- Light of the Martyr Emergency
			if A.LightofMartyr:IsReady(unitID) and A.LightofMartyr:PredictHeal(unitID) and Unit(unitID):HealthPercent() <= 50  and not UnitIsUnit(unitID, player) then
				return A.LightofMartyr:Show(icon)
			end	

			--Holy Light Infusion proc
			if A.HolyLight:IsReady(unitID) and Unit(player):HasBuffs(A.InfusionofLightBuff.ID, true) > 0 and A.HolyLight:PredictHeal(unitID) and Unit(unitID):HealthPercent() <= 80 and not isMoving then
				return A.HolyLight:Show(icon)
			end	
			
			--Flash of Light no infusion
			if A.FlashofLight:IsReady(unitID) and A.FlashofLight:PredictHeal(unitID) and Unit(unitID):HealthPercent() <= 30 and not isMoving then
				return A.FlashofLight:Show(icon)
			end
		end 

		if RaidGroup then
		
			--Flash of Light Infusion proc
			if A.FlashofLight:IsReady(unitID) and Unit(player):HasBuffs(A.InfusionofLightBuff.ID, true) > 0 and A.FlashofLight:PredictHeal(unitID) and Unit(unitID):HealthPercent() <= 50 and not isMoving then
				return A.FlashofLight:Show(icon)
			end

			--Holy Light Infusion proc
			if A.HolyLight:IsReady(unitID) and Unit(player):HasBuffs(A.InfusionofLightBuff.ID, true) > 0 and A.HolyLight:PredictHeal(unitID) and Unit(unitID):HealthPercent() <= 90 and not isMoving then
				return A.HolyLight:Show(icon)
			end	

			--Flash of Light no infusion			
			if A.FlashofLight:IsReady(unitID) and A.FlashofLight:PredictHeal(unitID) and Unit(unitID):HealthPercent() <= 50 and not isMoving then
				return A.FlashofLight:Show(icon)
			end	
			
			--Holy Light no infusion
			if A.HolyLight:IsReady(unitID) and A.HolyLight:PredictHeal(unitID) and Unit(unitID):HealthPercent() <= 85 and not isMoving then
				return A.HolyLight:Show(icon)
			end	
			
		end
			
		-- Light of the Martyr when moving
		if A.LightofMartyr:IsReady(unitID) and A.LightofMartyr:PredictHeal(unitID) and Unit(unitID):HealthPercent() <= 90 and isMoving and not UnitIsUnit(unitID, player) then
			return A.LightofMartyr:Show(icon)
		end	

        if UrgentMythicPlusTargetting() and A.IsInInstance and not A.IsInPvP then
		    return true
		end
        			
    end    
    HealingRotation = Action.MakeFunctionCachedDynamic(HealingRotation)

    -- Defensive
    local SelfDefensive = SelfDefensives()
    if SelfDefensive and CanCast then 
        return SelfDefensive:Show(icon)
    end 

    -- Heal Target 
    if IsUnitFriendly(target) then 
        unit = target 
        
        if HealingRotation(unit) then 
            return true 
        end 
    end  
	    
    -- Heal Mouseover
    if IsUnitFriendly(mouseover) then 
        unit = mouseover  
        
        if HealingRotation(unit) then 
            return true 
        end             
    end 
	
    -- DPS TargetTarget 
    if IsUnitEnemy(targettarget) then 
        unit = targettarget    
        
        if DamageRotation(unit) then 
            return true 
        end 
    end     
	
    -- DPS Mouseover 
    if IsUnitEnemy(mouseover) then 
        unit = mouseover    
        
        if DamageRotation(unit) then 
            return true 
        end 
    end 
	
    -- DPS Target     
    if IsUnitEnemy(target) then 
        unit = target
        
        if DamageRotation(unit) then 
            return true 
        end 
    end         
end 

