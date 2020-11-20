--###############################
--##### TRIP'S HOLY PALADIN #####
--###############################

-- Full credit to Taste


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
    Cleanse                                = Create({ Type = "Spell", ID = 4987 }),
    Judgement                              = Create({ Type = "Spell", ID = 275773 }),
    CrusaderStrike                         = Create({ Type = "Spell", ID = 35395 }),
    Consecration                           = Create({ Type = "Spell", ID = 26573 }),
    LightofMartyr                          = Create({ Type = "Spell", ID = 183998, predictName = "LightofMartyr" }),
    LightoftheMartyrStack                  = Create({ Type = "Spell", ID = 223316 }),
    FlashofLight                           = Create({ Type = "Spell", ID = 19750, predictName = "FlashofLight" }),
    HolyShock                              = Create({ Type = "Spell", ID = 20473, predictName = "HolyShock" }),
    InfusionofLight                        = Create({ Type = "Spell", ID = 54149 }),
    BeaconofLight                          = Create({ Type = "Spell", ID = 53563 }),
    BeaconofVirtue                         = Create({ Type = "Spell", ID = 200025 }),
    LightofDawn                            = Create({ Type = "Spell", ID = 85222, predictName = "LightofDawn" }),
    AuraMastery                            = Create({ Type = "Spell", ID = 31821 }),
    AvengingWrath                          = Create({ Type = "Spell", ID = 31884 }),
    HolyAvenger                            = Create({ Type = "Spell", ID = 105809 }),
    BestowFaith                            = Create({ Type = "Spell", ID = 223306, predictName = "BestowFaith" }),
    AvengingCrusader                       = Create({ Type = "Spell", ID = 216331 }),
    JudgmentOfLightHoly                    = Create({ Type = "Spell", ID = 183778, Hidden = true  }),
    BlessingofSacrifice                    = Create({ Type = "Spell", ID = 6940 }),
    BeaconOfFaith                          = Create({ Type = "Spell", ID = 156910 }),
    JudgementofLight                       = Create({ Type = "Spell", ID = 183778 }),
    CrusadersMight                         = Create({ Type = "Spell", ID = 196926 }),
    ConsecrationUp                         = Create({ Type = "Spell", ID = 204242 }),
    JudgmentUp                             = Create({ Type = "Spell", ID = 214222 }),
    HolyPrism                              = Create({ Type = "Spell", ID = 114165, predictName = "HolyPrism" }),
    LightsHammer                           = Create({ Type = "Spell", ID = 114158, predictName = "LightsHammer" }),
    CleansingLight                         = Create({ Type = "Spell", ID = 236186, Hidden = true     }), -- Talent AoE Dispell
	BlessingofSanctuary                    = Create({ Type = "Spell", ID = 210256, Hidden = true     }), 
    -- Utilities
    Cavalier                               = Create({ Type = "Spell", ID = 190784     }),
    JusticarsVengeance                     = Create({ Type = "Spell", ID = 215661    }),
    BlessingofProtectionYellow             = Create({ Type = "Spell", ID = 1022, Color = "YELLOW", Desc = "YELLOW Color for Party Blessing"     }),    
    BlessingofProtection                   = Create({ Type = "Spell", ID = 1022     }), 
    BlessingofFreedom                      = Create({ Type = "Spell", ID = 1044     }),
    BlessingofFreedomYellow                = Create({ Type = "Spell", ID = 1044, Color = "YELLOW", Desc = "YELLOW Color for Party Blessing"     }),    
    HammerofJustice                        = Create({ Type = "Spell", ID = 853     }),
    HammerofJusticeGreen                   = Create({ Type = "SpellSingleColor", ID = 853, Color = "GREEN", Desc = "[1] CC", Hidden = true, Hidden = true, QueueForbidden = true }),
    DivineShield                           = Create({ Type = "Spell", ID = 642     }),
    CleanseToxins                          = Create({ Type = "Spell", ID = 213644   }),
    Rebuke                                 = Create({ Type = "Spell", ID = 96231     }),
    Absolution                             = Create({ Type = "Spell", ID = 212056 }), -- Mass Rez
    Redemption                             = Create({ Type = "Spell", ID = 7328 }), -- Rez
	BlindingLight                          = Create({ Type = "Spell", ID = 115750  }),
    -- Azerite
    DivineRevelations                      = Create({ Type = "Spell", ID = 275469 }),
    GlimmerofLight                         = Create({ Type = "Spell", ID = 287268 }),
    -- PvP
    UltimateSacrifice                      = Create({ Type = "Spell", ID = 199452 }),
    -- Healing
    HolyLight                              = Create({ Type = "Spell", ID = 82326, predictName = "HolyLight" }),
    LayOnHands                             = Create({ Type = "Spell", ID = 633, predictName = "LayOnHands" }),
    Forbearance                            = Create({ Type = "Spell", ID = 25771 }),
    DivineProtection                       = Create({ Type = "Spell", ID = 498 }),
    RuleofLaw                              = Create({ Type = "Spell", ID = 214202, Hidden = true     }),
    GlimmerofLightBuff                     = Create({ Type = "Spell", ID = 287280, Hidden = true     }),
    BreakingDawn                           = Create({ Type = "Spell", ID = 278594, Hidden = true     }),
    DivinePurpose                          = Create({ Type = "Spell", ID = 216413, Hidden = true     }),
    WordofGlory                            = Create({ Type = "Spell", ID = 85673     }),	
    -- Raid
    DarkestDepths                          = Create({ Type = "Spell", ID = 292127, Hidden = true     }), -- Eternal Palace debuff heal
	-- Misc
	Cyclone                                = Create({ Type = "Spell", ID = 33786, Hidden = true     }), -- Cyclone 
    -- Hidden Heart of Azeroth
    -- added all 3 ranks ids in case used by rotation
    VisionofPerfectionMinor                = Create({ Type = "Spell", ID = 296320, Hidden = true     }),
    VisionofPerfectionMinor2               = Create({ Type = "Spell", ID = 299367, Hidden = true     }),
    VisionofPerfectionMinor3               = Create({ Type = "Spell", ID = 299369, Hidden = true     }),
    UnleashHeartOfAzeroth                  = Create({ Type = "Spell", ID = 280431, Hidden = true     }),
    RecklessForceBuff                      = Create({ Type = "Spell", ID = 302932, Hidden = true     }),    
    PoolResource                           = Create({ Type = "Spell", ID = 209274, Hidden = true     }),
    DummyTest                              = Create({ Type = "Spell", ID = 159999, Hidden = true     }), -- Dummy stop dps icon    
	--Mythic Plus Spells 
	Quake                                  = Create({ Type = "Spell", ID = 240447, Hidden = true     }), -- Quake (Mythic Plus Affix)
	Burst                                  = Create({ Type = "Spell", ID = 240443, Hidden = true     }), -- Bursting (Mythic Plus Affix) Upon death the creature Bursts, inflicting damage equal to (35 / 10)% of maximum health every 1 sec.
	GrievousWound                          = Create({ Type = "Spell", ID = 240559, Hidden = true     }), -- Grievous (Mythic Plus Affix) 2% of a player's maximum health every 3 sec
    Slow                                   = Create({ Type = "Spell", ID = 313255, Hidden = true     }), -- Shadhar slow
	Fixate                                 = Create({ Type = "Spell", ID = 318078, Hidden = true     }), -- Wrathion Fixate
	IneffableTruthBuff                     = Create({ Type = "Spell", ID = 316801, Hidden = true     }), -- ineffable-truth corruption buff
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
    return A.Judgement:IsInRange(unit)
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

-- [1] CC AntiFake Rotation
local function AntiFakeStun(unit) 
    return 
    IsUnitEnemy(unit) and  
    Unit(unit):GetRange() <= 10 and 
    A.HammerofJusticeGreen:AbsentImun(unit, Temp.TotalAndPhysAndCCAndStun, true)          
end 
A[1] = function(icon)    
    local useKick, useCC, useRacial = A.InterruptIsValid(targettarget, "TargetMouseover")    
    
     
 
    -- Auto targettarget ?
    if useCC and A.HammerofJustice:IsReady(targettarget) and A.HammerofJustice:AbsentImun(targettarget, Temp.TotalAndPhysAndCCAndStun, true) then 
        -- Notification                    
        Action.SendNotification("HammerofJustice interrupting...", A.HammerofJustice.ID)
        return A.HammerofJusticeGreen              
    end 
	
	-- Manual Key
    if     A.HammerofJusticeGreen:IsReady(nil, nil, nil, true) and 
    (
        AntiFakeStun(mouseover) or 
        AntiFakeStun(target) or 
        (
            not IsUnitEnemy(mouseover) and 
            not IsUnitEnemy(target) and                     
            (
                (A.IsInPvP and EnemyTeam():PlayersInRange(1, 10)) or 
                (not A.IsInPvP and GetByRange(1, 10))
            )
        )
    )
    then 
        return A.HammerofJusticeGreen:Show(icon)         
    end
    
	
end

-- [2] Kick AntiFake Rotation
A[2] = function(icon)        
    local unit
    if IsUnitEnemy(mouseover) then 
        unit = mouseover
    elseif IsUnitEnemy(target) then 
        unit = target
    end 
    
    if unit then         
        local castLeft, _, _, _, notKickAble = Unit(unit):IsCastingRemains()
        if castLeft > 0 then             
            if not notKickAble and A.Rebuke:IsReady(unit, nil, nil, true) and A.Rebuke:AbsentImun(unit, Temp.TotalAndMag, true) then
                return A.Rebuke:Show(icon)                                                  
            end 
            
            -- Racials 
            if A.QuakingPalm:IsRacialReadyP(unit, nil, nil, true) then 
                return A.QuakingPalm:Show(icon)
            end 
            
            if A.Haymaker:IsRacialReadyP(unit, nil, nil, true) then 
                return A.Haymaker:Show(icon)
            end 
            
            if A.WarStomp:IsRacialReadyP(unit, nil, nil, true) then 
                return A.WarStomp:Show(icon)
            end 
            
            if A.BullRush:IsRacialReadyP(unit, nil, nil, true) then 
                return A.BullRush:Show(icon)
            end                         
        end 
    end                                                                                 
end

-----------------------------------------
--        ROTATION FUNCTIONS           --
-----------------------------------------

-- Return number
-- Consecration duration left
local function Consecration()
    for i = 1, 5 do
        local active, totemName, startTime, duration, textureId  = GetTotemInfo(i)
        if active == true and textureId == 135926 then
            return startTime + duration - GetTime()
        end
    end
    return 0
end

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

-- Blessing of Sanctuary
local function BoS(unit)    
    return
    A.BlessingofSanctuary:IsSpellLearned() and 
    A.BlessingofSanctuary:IsReady() and 
    UnitExists(unit) and      
    A.BlessingofSanctuary:IsSpellInRange(unit) and     
    Unit(unit):HasDeBuffs(33786, true) == 0 and -- Cyclone
    (
        (
            --MacroSpells(Icon, "HoS") and 
            (
                Unit(unit):HasDeBuffs("Stuned") > 1.5 or 
                Unit(unit):HasDeBuffs("Fear") > 1.5 or 
                (
                    Unit(unit):HasDeBuffs("Silenced") > 1.5 and 
                    Unit(unit):HasDeBuffs(78675, true) == 0 -- Solar Beam
                )
            )
        ) or 
        (
            HoS_toggle and 
            (
                Unit(unit):HasDeBuffs({115080, 79140}, true) == 0 or -- Touch of Death, Vendetta
                not BlessingofProtection:IsReady() or -- BoP
                Unit(unit):HasDeBuffs(25771, true) > 1 -- Forbearance
            ) and 
            (
                (
                    (
                        Unit(unit):HasDeBuffs(5246, true) > 3.5 and -- Intimidating Shout                
                        not Unit(unit):IsFocused() 
                    ) or 
                    (
                        Unit(unit):HasDeBuffs("PhysStuned") > 3.5 and 
                        (
                            Unit(unit):HasBuffs("DamageBuffs") > 3 or 
                            (
                                Unit(unit):HasDeBuffs(76577, true) > 0 and -- Smoke Bomb
                                Unit(unit):IsFocused("MELEE")
                            )
                        )
                    ) or             
                    (
                        Unit(unit):Role("HEALER") and 
                        (
                            Unit(unit):HasDeBuffs("Stuned") > 3.5 or
                            Unit(unit):HasDeBuffs("Fear") > 3.5 or 
                            (
                                Unit(unit):HasDeBuffs("Silenced") > 3.5 and 
                                Unit(unit):HasDeBuffs(78675, true) == 0 -- Solar Beam
                            ) 
                        )  
                    ) 
                ) and 
                -- Hex, Polly, Repentance, Blind, Wyvern Sting, Ring of Frost, Paralysis, Freezing Trap, Mind Control
                Unit(unit):HasDeBuffs({51514, 118, 20066, 2094, 19386, 82691, 115078, 3355, 605}, true) <= GetCurrentGCD() 
            )
        ) 
    )
end

local function BoP(unit, Icon)
    local id = 1022

    return
    A.BlessingofProtection:IsReady(unit) and 
    Unit(unit):IsExists() and 
    Unit(unit):IsPlayer() and
    not Unit(unit):IsTank() and
    (
        not UnitIsUnit(unit, player) or
        -- Divine Shield
        A.DivineShield:GetCooldown() > 5
    ) and
    --not Unit(unit):InLOS() and    
    (UnitInRaid(unit) or UnitInParty(unit)) and
    A.BlessingofProtection:IsInRange(unit) and     
    Unit(unit):HasDeBuffs({33786, 25771}, true) == 0 and -- Cyclone and Forbearance   
    ( 
        not A.IsInPvP or
        not Unit(unit):HasFlags()       
    ) and
    (
       -- ( 
       --     Icon and 
       --     MacroSpells(Icon, "BoP")
       -- ) or 
        (
            --BoP_toggle and 
            id == 1022 and 
            (
                -- Deffensive
                (            
                    Unit(unit):GetDMG(3) > 0 and 
                    (
                        (
                            Unit(player):HasSpec(65) and -- Holy
                            Unit(unit):HealthPercent() <= 38 and 
                            -- Physical real damage still appear
                            select(3, Unit(unit):GetRealTimeDMG()) > 0
                        ) or
                        (
                            not Unit(player):HasSpec(65) and -- Holy                            
                            Unit(unit):HealthPercent() <= 31 and 
                            (
                                FriendlyTeam("HEALER"):GetCC() or
                                Unit(unit):TimeToDieX(20) < 2
                            ) and
                            Unit(unit):HasBuffs("DeffBuffs") == 0 
                        )
                    ) and                     
                    (
                        -- PvP 
                        (
                            A.IsInPvP and
                            (
                                Unit(unit):IsFocused("MELEE") or
                                (
                                    Unit(unit):UseDeff() and 
                                    -- Physical real damage still appear
                                    select(3, Unit(unit):GetRealTimeDMG()) > 0
                                )
                            )
                        ) or
                        -- PvE 
                        not A.IsInPvP 
                    )
                ) or 
                -- Damage DeBuffs
                Unit(unit):HasDeBuffs({115080, 122470}, true) > 4 or -- Touch of Death and KARMA
                Unit(unit):HasDeBuffs(79140, true) > 15 or -- Vendetta
                -- CC Physical DeBuffs
                (
                    (
                        -- Disarmed
                        (
                            not Unit(player):HasSpec(70) and -- Retribution
                            Unit(unit):IsMelee() and 
                            Unit(unit):HasDeBuffs("Disarmed") > 4.5 and                             
                            Unit(unit):HasBuffs("DamageBuffs") > 4                      
                        ) or 
                        -- Another BreakAble CC 
                        (
                            (
                                Unit(unit):HasDeBuffs(2094, true) > 3.2 or -- Blind
                                (
                                    Unit(unit):HasDeBuffs(5246, true) > 3.2 and -- Intimidating Shout
                                    (
                                        not Unit(player):HasSpec(70) or -- Retribution
                                        -- Blessing of Sanctuary
                                        not A.BlessingofSanctuary:IsSpellLearned() or 
                                        not A.BlessingofSanctuary:IsReady(unit)
                                    )
                                )
                            ) and 
                            (
                                not A.IsInPvP or 
                                not Unit(unit):IsFocused()
                            )
                        ) or 
                        -- HEALER HELP 
                        (
                            Unit(unit):Role("HEALER") and 
                            (
                                Unit(unit):HasDeBuffs("Stuned") >= 4 or 
                                -- Garrote
                                Unit(unit):HasDeBuffs(1330, true) >= 2.5
                            ) and 
                            (
                                not Unit(player):HasSpec(70) or -- Retribution
                                -- Blessing of Sanctuary
                                not A.BlessingofSanctuary:IsSpellLearned() or  
                                not A.BlessingofSanctuary:IsReady(unit)
                            ) and 
                            Unit(unit):HasBuffs("DeffBuffs") <= GetCurrentGCD() and
                            (
                                not A.IsInPvP or 
                                -- if enemy melee bursting 
                                Unit(unit):IsFocused("MELEE") 
                            )
                        ) 
                    ) and 
                    -- Check for non physical CC 
                    (
                        Unit(unit):HasDeBuffs("Silenced") <= GetCurrentGCD() or 
                        -- Garrote
                        Unit(unit):HasDeBuffs(1330, true) >= 2.5
                    ) and 
                    Unit(unit):HasDeBuffs("Magic") <= GetCurrentGCD() and 
                    -- Hex
                    Unit(unit):HasDeBuffs(51514, true) <= GetCurrentGCD()
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
	
        -- Junkyard
        if inCombat and select(8, GetInstanceInfo()) == 2097 then
            for i = 1, #getmembersAll do
                if Unit(getmembersAll[i].Unit):HasDeBuffs(302274, true) ~= 0 --Fulminating Zap
                        and Unit(getmembersAll[i].Unit):HealthPercent() < 80 
				then
                    HealingEngine.SetTarget(getmembersAll[i].Unit, 0.5)
                end
            end
        end
		
        -- Waycrest Manor
        if inCombat and select(8, GetInstanceInfo()) == 1862 then
            for i = 1, #getmembersAll do
                if Unit(getmembersAll[i].Unit):HasDeBuffs(260741, true) ~= 0 --Jagged Nettles
                        and Unit(getmembersAll[i].Unit):HealthPercent() < 95 
				then
                    HealingEngine.SetTarget(getmembersAll[i].Unit, 0.5)
                end
            end
        end
		
        --Kings Rest
        if inCombat and select(8, GetInstanceInfo()) == 1762 then
            for i = 1, #getmembersAll do
                if Unit(getmembersAll[i].Unit):HasDeBuffs(267626, true) ~= 0 -- Dessication
                        or Unit(getmembersAll[i].Unit):HasDeBuffs(267618, true) ~= 0 -- Drain Fluids
                        or Unit(getmembersAll[i].Unit):HasDeBuffs(266231, true) ~= 0 -- Severing axe from axe lady in council
                        or Unit(getmembersAll[i].Unit):HasDeBuffs(272388, true) ~= 0 -- shadow barrage
                        or Unit(getmembersAll[i].Unit):HasDeBuffs(265773, true) > 1 -- spit-gold
                        or (Unit(getmembersAll[i].Unit):HasDeBuffs(270487, true) ~= 0 and Unit(getmembersAll[i].Unit):HasDeBuffsStacks(270487, true) > 1) -- severing-blade
                        and Unit(getmembersAll[i].Unit):HealthPercent() < 95 
				then
                    HealingEngine.SetTarget(getmembersAll[i].Unit, 0.5)
                end
            end
        end
        
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
    local InfLight = Unit(player):HasBuffs(A.InfusionofLight.ID, true)
    local HLcast_t = Unit(player):CastTime(A.HolyLight.ID)
    local FLcast_t = Unit(player):CastTime(A.FlashofLight.ID)
	local inCombat = Unit(player):CombatTime() > 0
    local isMoving = Player:IsMoving()
    local isMovingFor = A.Player:IsMovingTime()
    local combatTime = Unit(player):CombatTime()    
    local ShouldStop = Action.ShouldStop()
    local Pull = Action.BossMods:GetPullTimer()
	local AoEON = GetToggle(2, "AoE")
    local Emergency = NeedEmergencyHPS()
    local SuperEmergency = NeedUltraEmergencyHPS()   
    local GlimmerofLightCount = GlimmerofLightCount()
    local ActiveBeacon = ActiveBeacon()
	local ActiveBeaconOnTank = ActiveBeaconOnTank()
    -- Healing Engine vars
    local ReceivedLast5sec = FriendlyTeam("ALL"):GetLastTimeDMGX(5) --Unit(player):GetLastTimeDMGX(5) -- LastIncDMG(player, 5)
    local AVG_DMG = HealingEngine.GetIncomingDMGAVG()
    local AVG_HPS = HealingEngine.GetIncomingHPSAVG()
    local TeamCacheEnemySize = TeamCache.Enemy.Size
    local TeamCacheFriendlySize = TeamCache.Friendly.Size
    local TeamCacheFriendlyType = TeamCache.Friendly.Type or "none" 
    RotationsVariables()    
    --------------------
    --- DPS ROTATION ---
    --------------------
    local function DamageRotation(unit)
    
        -- Out of Combat
        LeftCtrl = IsLeftControlKeyDown();
        LeftShift = IsLeftShiftKeyDown();
        LeftAlt = IsLeftAltKeyDown();
                
        -- Bursting 
        if A.BurstIsON(unit) and InMelee(unit) then 
            
            if Unit(unit):HealthPercent() <= A.GetToggle(2, "RacialBurstDamaging") then 
                if A.BloodFury:AutoRacial(unit, nil, nil, true) then 
                    return A.BloodFury:Show(icon)
                end 
                
                if A.Fireblood:AutoRacial(unit, nil, nil, true) then 
                    return A.Fireblood:Show(icon)
                end 
                
                if A.AncestralCall:AutoRacial(unit, nil, nil, true) then 
                    return A.AncestralCall:Show(icon)
                end 
                
                if A.Berserking:AutoRacial(unit, nil, nil, true) then 
                    return A.Berserking:Show(icon)
                end 
            end 
        end
        
        -- Trinkets DPS         
        local TrinketsMode = GetToggle(2, "TrinketBurstSyncUP")
        if unit ~= targettarget and Player:ManaPercentage() <= TrinketMana and (TrinketsMode == "Always" or (TrinketsMode == "BurstSync" and BurstIsON(unit))) and inCombat and IsUnitEnemy(unit) and Unit(unit):GetRange() <= 40 then 
            if A.Trinket1:IsReady(unit) and A.Trinket1:GetItemCategory() ~= "DEFF" and A.Trinket1:AbsentImun(unit, Temp.TotalAndMag) then 
                return A.Trinket1:Show(icon)
            end 
            
            if A.Trinket2:IsReady(unit) and A.Trinket2:GetItemCategory() ~= "DEFF" and A.Trinket2:AbsentImun(unit, Temp.TotalAndMag) then 
                return A.Trinket2:Show(icon)
            end     
        end
        
        -- HPvE #1 Judgment
        if A.Judgement:IsReady(unit) and A.JudgementofLight:IsSpellLearned() and
        (
            -- MouseOver
            (      
                MouseOver and
                IsUnitEnemy(mouseover) and        
                A.Judgement:IsInRange(mouseover) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone
                Unit(mouseover):PT(196941, "debuff", true) and                       
                A.Judgement:AbsentImun(mouseover, Temp.TotalAndPhys, true) 
            ) or 
            -- Target
            ( 
                (
                    not MouseOver or
                    not A.MouseHasFrame()
                ) and       
                IsUnitEnemy(target) and        
                A.Judgement:IsInRange(target) and
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) == 0 and 
                Unit(target):PT(196941, "debuff", true) and        
                A.Judgement:AbsentImun(target, Temp.TotalAndPhys, true) 
            ) or 
            -- TargetTarget
            ( 
                (
                    not MouseOver or
                    not A.MouseHasFrame() or
                    not IsUnitEnemy(mouseover)
                ) and
                not IsUnitEnemy(target) and
                IsUnitEnemy(targettarget) and
                A.Judgement:IsInRange(targettarget) and
                Unit(targettarget):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone
                Unit(targettarget):PT(196941, "debuff", true) and        
                A.Judgement:AbsentImun(targettarget, Temp.TotalAndPhys, true)          
            ) 
        )
        then
            return A.Judgement:Show(icon)
        end

        -- HPvE #1 Crusader Strike
        if A.CrusaderStrike:IsReady(unit) and A.CrusadersMight:IsSpellLearned() and
        -- Holy Shock
        A.HolyShock:GetCooldown() >= 1.5 and -- GetCurrentGCD() and
        (
            -- MouseOver
            (      
                MouseOver and
                IsUnitEnemy(mouseover) and        
                A.CrusaderStrike:IsInRange(mouseover) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone               
                A.CrusaderStrike:AbsentImun(mouseover, Temp.TotalAndPhys, true)
            ) or 
            -- Target
            ( 
                (
                    not MouseOver or
                    not A.MouseHasFrame() 
                ) and        
                IsUnitEnemy(target) and        
                A.CrusaderStrike:IsInRange(target) and
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) == 0 and                
                A.CrusaderStrike:AbsentImun(target, Temp.TotalAndPhys, true)  
            ) or
            -- TargetTarget
            ( 
                (
                    not MouseOver or
                    not A.MouseHasFrame() or
                    not IsUnitEnemy(mouseover)
                ) and
                not IsUnitEnemy(target) and
                IsUnitEnemy(targettarget) and
                A.CrusaderStrike:IsInRange(targettarget) and
                Unit(targettarget):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone             
                A.CrusaderStrike:AbsentImun(targettarget, Temp.TotalAndPhys, true)          
            ) 
        )
        then
            return A.CrusaderStrike:Show(icon)
        end

        -- Consecration
        if A.Consecration:IsReady(player) and IsUnitEnemy(unit) and Unit(unit):GetRange() <= 6 and Unit(player):HasBuffs(A.AvengingCrusader.ID, true) == 0 and Consecration() <= 3 then
            return A.Consecration:Show(icon)
        end
                        
        -- HPvE #2 Judgment
        if A.Judgement:IsReady(unit) and InMelee(unit) and 
        (
            -- MouseOver
            (      
                MouseOver and
                IsUnitEnemy(mouseover) and        
                A.Judgement:IsInRange(mouseover) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone
                Unit(mouseover):HasDeBuffs(A.Judgement.ID, player, true) <= GetCurrentGCD() and
                A.Judgement:AbsentImun(mouseover, Temp.TotalAndPhys, true)  
            ) or 
            -- Target
            ( 
                (
                    not MouseOver or
                    not A.MouseHasFrame() or
                    not IsUnitEnemy(mouseover)
                ) and        
                IsUnitEnemy(target) and        
                A.Judgement:IsInRange(target) and
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) == 0 and 
                Unit(target):HasDeBuffs(A.Judgement.ID, player, true) <= GetCurrentGCD() and 
                A.Judgement:AbsentImun(target, Temp.TotalAndPhys, true)   
            ) or
            -- TargetTarget
            ( 
                (
                    not MouseOver or
                    not A.MouseHasFrame() or
                    not IsUnitEnemy(mouseover)
                ) and
                not IsUnitEnemy(target) and
                IsUnitEnemy(targettarget) and
                A.Judgement:IsInRange(targettarget) and
                Unit(targettarget):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone
                Unit(targettarget):HasDeBuffs(A.Judgement.ID, player, true) <= GetCurrentGCD() and
                A.Judgement:AbsentImun(targettarget, Temp.TotalAndPhys, true)          
            ) 
        )        
        then
            return A.Judgement:Show(icon)
        end

        -- HPvE #2 Holy Shock (DMG)
        if A.HolyShock:IsReady(unit) and HolyShockDPS and
        (
            -- MouseOver
            (      
                MouseOver and
                IsUnitEnemy(mouseover) and            
                A.Judgement:IsInRange(mouseover) and
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone    
                (
                    -- Glimmer of Light 
                    A.GlimmerofLight:GetAzeriteRank() == 0 or
                    -- Everyone already buffed so then we can free spend on enemy
                    not FriendlyTeam(nil, 1):MissedBuffs(A.GlimmerofLightBuff.ID, player)
                ) and   
                A.HolyShock:AbsentImun(mouseover, Temp.TotalAndMag, true)
            ) or 
            -- TargetTarget
            --[[
            ( 
                (
                    not MouseOver or
                    not A.MouseHasFrame() or
                    not IsUnitEnemy(mouseover)
                ) and
                not IsUnitEnemy(target) and
                IsUnitEnemy(targettarget) and
                SpellInRange(targettarget, 20271) and
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone
                DeBuffs(targettarget, 275773, player)<=GetCurrentGCD() and
                NOMagicImun(targettarget)         
            ) or 
            ]]--
            -- Target
            ( 
                (
                    not MouseOver or
                    not A.MouseHasFrame() or
                    not IsUnitEnemy(mouseover)
                ) and        
                IsUnitEnemy(target) and        
                A.Judgement:IsInRange(target) and
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone         
                A.HolyShock:AbsentImun(target, Temp.TotalAndMag, true)  
            )
        )        
        then
            return A.HolyShock:Show(icon)
        end
        
        -- HPvE #2 Crusader Strike
        if A.CrusaderStrike:IsReady(unit) and 
        (
            -- MouseOver
            (      
                MouseOver and
                IsUnitEnemy(mouseover) and        
                A.CrusaderStrike:IsInRange(mouseover) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone               
                A.CrusaderStrike:AbsentImun(mouseover, Temp.TotalAndPhys, true)
            )
            or 
            -- Target
            ( 
                (
                    not MouseOver or
                    not A.MouseHasFrame() or
                    not IsUnitEnemy(mouseover)
                ) and
                not IsUnitEnemy(targettarget) and
                IsUnitEnemy(target) and        
                A.CrusaderStrike:IsInRange(target) and
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone                
                A.CrusaderStrike:AbsentImun(target, Temp.TotalAndPhys, true) 
            ) 
            or
            -- TargetTarget
            ( 
                (
                    not MouseOver or
                    not A.MouseHasFrame() or
                    not IsUnitEnemy(mouseover)
                ) and
                not IsUnitEnemy(target) and
                IsUnitEnemy(targettarget) and
                A.CrusaderStrike:IsInRange(targettarget) and
                Unit(targettarget):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone             
                A.CrusaderStrike:AbsentImun(targettarget, Temp.TotalAndPhys, true)         
            )
        )
        then
            return A.CrusaderStrike:Show(icon)
        end
    end
    DamageRotation = Action.MakeFunctionCachedDynamic(DamageRotation)
    
    ---------------------
    --- HEAL ROTATION ---
    ---------------------
    local function HealingRotation(unit) 
        
		-- Vars
		local useDispel, useShields, useHoTs, useUtils = HealingEngine.GetOptionsByUnitID(unit)
        local unitGUID = UnitGUID(unit)
        
        -- StopCast if destination is unknown as unitID 
        if not Temp.LastPrimaryUnitID and StopCastOverHeal and CanStopCastingOverHeal(unit, unitGUID) then 
            return A:Show(icon, ACTION_CONST_STOPCAST)
        end 

    	-- Dispel Sniper
        if A.Cleanse:IsReady() then
     		for i = 1, #getmembersAll do 
                if Unit(getmembersAll[i].Unit):GetRange() <= 40 and AuraIsValid(getmembersAll[i].Unit, "UseDispel", "Dispel") then  
			        HealingEngine.SetTarget(getmembersAll[i].Unit)                  					
			        -- Notification					
                    Action.SendNotification("Sniping dispel", A.Cleanse.ID) 					
                end				
            end
        end
        -- #1 HPvE Dispel
        if A.Cleanse:IsReady(unit) and
		useDispel and
        (
            -- MouseOver
            (
                A.GetToggle(2, "mouseover") and
                Unit("mouseover"):IsExists() and 
                MouseHasFrame() and                      
                not IsUnitEnemy("mouseover") and         
				AuraIsValid(mouseover, "UseDispel", "Dispel")
            ) or 
            (
                (
                    not A.GetToggle(2, "mouseover") or 
                    not Unit("mouseover"):IsExists() or 
                    IsUnitEnemy("mouseover")
                ) and        
                not IsUnitEnemy("target") and
				AuraIsValid(target, "UseDispel", "Dispel")
            )
        )
		then
		    return A.Cleanse:Show(icon)
        end		
      
        -- #2 HPvE Arcane Torrent dispel
        if A.ArcaneTorrent:IsRacialReady(unit) and combatTime > 0 and
		useDispel and
        (
            -- Mouseover
            (
                MouseOver and
                Unit(mouseover):IsExists() and 
                IsUnitEnemy(mouseover) and
                Unit(mouseover):GetRange() <= 8 and
                AuraIsValid(mouseover, "UsePurge", "Dispel") and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) == 0 
            ) or
            -- Target
            (
                IsUnitEnemy(target) and
                Unit(target):GetRange() <= 8 and
                AuraIsValid(target, "UsePurge", "Dispel") and
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) == 0 -- Cyclone
            ) or
            -- Mana 
            (
                IsSaveManaPhase() and Player:Mana() <= Player:ManaMax() * 0.75 or--and
                Player:Mana() <= Player:ManaMax() * 0.60
                -- PowerSave(player) and
                --MultiUnits:GetByRange(8) >= 1
            )
        )        
        then 
            return A.ArcaneTorrent:Show(icon)
        end           

        -- #3 Special Glimmer of Light Buff spreader (Only Friendly and not Pet)
       if A.GlimmerofLight:GetAzeriteRank() >= 1 and GlimmerofLightCount < 8 and ForceGlimmerOnMaxUnits then
            if (IsInGroup() or A.IsInPvP or IsInRaid()) then
                local _, currGUID = HealingEngine.GetTarget()
                for i = 1, #getmembersAll do 
                    if Unit(getmembersAll[i].Unit):IsPlayer() and not IsUnitEnemy(getmembersAll[i].Unit) and A.HolyShock:IsReadyByPassCastGCD(getmembersAll[i].Unit) and Unit(getmembersAll[i].Unit):GetRange() <= 40 and Unit(getmembersAll[i].Unit):HasBuffs(A.GlimmerofLightBuff.ID, true) == 0 then 
                        if UnitGUID(getmembersAll[i].Unit) ~= currGUID then
                          HealingEngine.SetTarget(getmembersAll[i].Unit) 
                          break
                        else 
                          -- Notification                    
                          Action.SendNotification("Spreading " .. A.GetSpellInfo(A.GlimmerofLightBuff.ID), A.GlimmerofLightBuff.ID)        
                          return A.HolyShock:Show(icon)                            
                        end                        
                    end                
                end    
            end
        end       

        -- #3.1 Special Holy Shock force as soon as its available MostlyIncDMG
        if A.HolyShock:GetCooldown() == 0 then
            for i = 1, #getmembersAll do 
                if Unit(getmembersAll[i].Unit):IsPlayer() and not IsUnitEnemy(getmembersAll[i].Unit) and A.HolyShock:IsReady(getmembersAll[i].Unit) and Unit(getmembersAll[i].Unit):GetRange() <= 40 
				then 
                    HealingEngine.IsMostlyIncDMG(getmembersAll[i].Unit)					
                    -- Notification                    
                    Action.SendNotification("Forcing " .. A.GetSpellInfo(A.HolyShock.ID), A.HolyShock.ID)        
                    return A.HolyShock:Show(icon)
                end                
            end    
        end     

        -- #3.2 Special Holy Shock force as soon as its available HP <= 98
        if A.HolyShock:GetCooldown() == 0 then
            for i = 1, #getmembersAll do 
                if Unit(getmembersAll[i].Unit):IsPlayer() and not IsUnitEnemy(getmembersAll[i].Unit) and A.HolyShock:IsReady(getmembersAll[i].Unit) and Unit(getmembersAll[i].Unit):HealthPercent() <= 98 and Unit(getmembersAll[i].Unit):GetRange() <= 40 
				then 
                    HealingEngine.SetTarget(getmembersAll[i].Unit)					
                    -- Notification                    
                    Action.SendNotification("Forcing " .. A.GetSpellInfo(A.HolyShock.ID), A.HolyShock.ID)        
                    return A.HolyShock:Show(icon)
                end                
            end    
        end  

        -- #4 Custom Beacon TANK
        if A.BeaconofLight:IsReady() and BeaconWorkMode == "Tanking Units" and ActiveBeaconOnTank == 0 then
            for i = 1, #CurrentTanks do 
                if Unit(CurrentTanks[i].Unit):GetRange() <= 40 then 
                      if Unit(CurrentTanks[i].Unit):IsPlayer() and Unit(CurrentTanks[i].Unit):HasBuffs(A.BeaconofLight.ID, true) == 0  then    
                        -- Notification                    
                        Action.SendNotification("Placing " .. A.GetSpellInfo(A.BeaconofLight.ID) .. " on " .. UnitName(CurrentTanks[i].Unit), A.BeaconofLight.ID)
                        HealingEngine.SetTarget(CurrentTanks[i].Unit)    -- Add 1sec delay in case of emergency switch                         
                        return A.BeaconofLight:Show(icon)                        
                    end                    
                end                
            end    
        end
        
        -- #4.1 Custom Beacon MostlyIncDMG
        if A.BeaconofLight:IsReady(unit) and combatTime > 0 and ActiveBeacon == 0 and not Unit(unit):IsPet() and BeaconWorkMode == "Mostly Inc. Damage" and Unit(unit):HasBuffs(A.BeaconofLight.ID, true) == 0 then
            HealingEngine.SetTargetMostlyIncDMG(1)
            return A.BeaconofLight:Show(icon)
        end
        
        -- #4.2 Custom Beacon HPS < Inc. Damage
        if A.BeaconofLight:IsReady(unit) and combatTime > 0 and ActiveBeacon == 0 and BeaconWorkMode == "HPS < Inc. Damage" and Unit(unit):HasBuffs(A.BeaconofLight.ID, true) == 0 then
            if not Unit(unit):IsPet() and Unit(unit):HasBuffs(A.BeaconofLight.ID, true) == 0 and Unit(unit):GetHPS() < Unit(unit):GetDMG() then
			    HealingEngine.SetTarget(unit)
                return A.BeaconofLight:Show(icon)
            end
        end

        -- #5 Bursting Essences		        
        -- #5.1 Life Binders Invocation
        if A.LifeBindersInvocation:AutoHeartOfAzeroth(unit, true) and A.BurstIsON(unit) and HealingEngine.GetBelowHealthPercentUnits(LifeBindersInvocationHP, 40) >= LifeBindersInvocationUnits then
            -- Notification                    
            Action.SendNotification("Burst " .. A.GetSpellInfo(A.LifeBindersInvocation.ID), A.LifeBindersInvocation.ID)            
            return A.LifeBindersInvocation:Show(icon)
        end
            
        -- #5.2 Overcharge Mana
        if A.OverchargeMana:AutoHeartOfAzeroth(unit, true) then
            return A.OverchargeMana:Show(icon)
        end
                
        -- #5.3 MemoryofLucidDreams if less than 85% mana left
        if A.MemoryofLucidDreams:AutoHeartOfAzeroth(unit, true) and Player:Mana() < Player:ManaMax() * (LucidDreamManaPercent / 100) then
            return A.MemoryofLucidDreams:Show(icon)
        end

        -- #5.4 Concentrated Flame Heal
        if A.ConcentratedFlame:AutoHeartOfAzeroth(unit, true) then
            return A.ConcentratedFlame:Show(icon)
        end
        
        -- #5.5 Vitality Conduit
        if (isMulti or AoEON) then 
            if A.VitalityConduit:AutoHeartOfAzeroth(unit, true) then 
                return A.VitalityConduit:Show(icon)
            end
            -- OverchargeMana    
            if A.OverchargeMana:AutoHeartOfAzeroth(unit, true) and (not IsEnoughHPS(unit) or HealingEngine.GetIncomingDMGAVG() > HealingEngine.GetIncomingHPSAVG() + 10) then 
                return A.OverchargeMana:Show(icon)
            end 
        end 

        -- #6 Utilities
        -- #6.1 HPvE Blessing of Protection
        if A.BlessingofProtection:IsReady(unit) and combatTime > 0 and
        (
            -- MouseOver
            (
                MouseOver and
                Unit(mouseover):IsExists() and 
                A.MouseHasFrame() and                       
                not IsUnitEnemy(mouseover) and 
                -- HoS
                Unit(mouseover):HasBuffs(6940, true) <= GetCurrentGCD() and 
                BoP(mouseover)
            ) or 
            -- Target
            (
                (
                    not MouseOver or 
                    not Unit(mouseover):IsExists() 
                ) and        
                not IsUnitEnemy(target) and  
                -- HoS
                Unit(target):HasBuffs(6940, true) <= GetCurrentGCD() and 
                BoP(target)         
            )
        )
        then
            return A.BlessingofProtection:Show(icon)
        end

        -- #6.2 Blessing Of Sacrifice
        if A.BlessingofSacrifice:IsReady(unit) and combatTime > 0 and Unit(player):Health() > Unit(player):HealthMax() * 0.2 and
        (
            -- MouseOver
            (
                MouseOver and        
                A.MouseHasFrame() and                      
                not IsUnitEnemy(mouseover) and                 
                (UnitInRaid(mouseover) or UnitInParty(mouseover)) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone        
                (
                    (    
                        not Unit(mouseover):IsTank() and
                        (
                            HoS(mouseover, nil, true, true) or
                            (
                                HealingEngine.IsMostlyIncDMG(mouseover) and
                                Unit(mouseover):GetDMG()>Unit(mouseover):HealthMax()*0.3                        
                            )
                        )
                    ) or 
                    (
                        Unit(mouseover):IsTank() and
                        -- Divine Shield
                        Unit(player):HasBuffs(642, true) > 5 and
                        Unit(mouseover):GetRealTimeDMG() >= Unit(mouseover):HealthMax() * 0.2
                    )
                )
            ) or 
            -- Target
            (  
                (
                    not MouseOver or 
                    not Unit(mouseover):IsExists() 
                ) and     
                (UnitInRaid(target) or UnitInParty(target)) and
                not IsUnitEnemy(target) and                 
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone   
                (
                    (
                        (
                            not Unit(target):IsTank() and
                            (
                                HoS(target, nil, true, true) or
                                (
                                    HealingEngine.IsMostlyIncDMG(mouseover) and
                                    Unit(target):GetDMG() > Unit(target):HealthMax()*0.3 
                                )
                            )                
                        )
                    ) or 
                    (
                        Unit(target):IsTank() and
                        -- Divine Shield
                        Unit(player):HasBuffs(642, true) > 5 and
                        Unit(target):GetRealTimeDMG() >= Unit(target):HealthMax() * 0.2
                    )
                )        
            )
        )
        then
            return A.BlessingofSacrifice:Show(icon)
        end
		
        -- #6.3 HPvE Rule of Law
        if A.RuleofLaw:IsReady(player) and combatTime > 0 and A.RuleofLaw:IsSpellLearned() and
        Unit(player):HasBuffs(A.RuleofLaw.ID, true) == 0 and
        (
            -- MouseOver
            (
                MouseOver and
                Unit(mouseover):IsExists() and 
                A.MouseHasFrame() and                        
                not IsUnitEnemy("mouseover") and  
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone 
                (
                    -- HEALING
                    (
                        Unit(mouseover):CanInterract(40) and        
                        (
                            (
                                A.RuleofLaw:GetSpellChargesFrac() >= 2 and
                                Unit(mouseover):Health() <= Unit(mouseover):HealthMax()*0.6
                            ) or            
                            TimeToDie("mouseover") <= 6 or
                            Unit(mouseover):Health() <= Unit(mouseover):HealthMax()*0.35
                        ) 
                    ) or
                    -- OUT OF RANGE
                    (
                        not Unit(mouseover):CanInterract(40) and 
                        combatTime > 0                
                    )
                )        
            ) or 
            -- Target
            (
                (
                    not MouseOver or 
                    not Unit(mouseover):IsExists() 
                ) and        
                not IsUnitEnemy("target") and
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) == 0 and   
                (
                    -- HEALING
                    (
                        Unit(target):CanInterract(40) and                
                        (
                            (
                                A.RuleofLaw:GetSpellChargesFrac() >= 2 and
                                Unit(target):Health() <= Unit(target):HealthMax()*0.6
                            ) or            
                            Unit(target):TimeToDie() <= 6 or
                            Unit(target):Health() <= Unit(target):HealthMax()*0.35
                        ) 
                    ) or
                    -- OUT OF RANGE
                    (
                        not Unit(target):CanInterract(40) and 
                        combatTime > 0                     
                    )
                )            
            )
        )
        then
            return A.RuleofLaw:Show(icon)
        end

        -- Tank Emergency
        -- #7 HPvE Lay on Hands
        if A.LayOnHands:IsReady(unit) and Action.Zone ~= "arena" and not Action.InstanceInfo.isRated and combatTime > 0 and
        (
            -- MouseOver
            (
                MouseOver and
                Unit(mouseover):IsExists() and 
                A.MouseHasFrame() and                       
                not IsUnitEnemy(mouseover) and 
                Unit(mouseover):HealthPercent() < LayOnHandsHP and        
                (
                    A.LayOnHands:PredictHeal("mouseover") or           
                    Unit(mouseover):Health() <= Unit(mouseover):HealthMax() * 0.17
                ) and
                Unit(mouseover):IsPlayer() and  
                A.LayOnHands:IsInRange(mouseover) and 
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone
                -- Forbearance
                Unit(mouseover):HasDeBuffs(A.Forbearance.ID, true) == 0 
            ) 
            or 
            -- Target
            (
                (
                    not MouseOver or 
                    not Unit(mouseover):IsExists()
                ) and        
                not IsUnitEnemy(target) and
                Unit(target):HealthPercent() < LayOnHandsHP and 
                (
                    A.LayOnHands:PredictHeal("target") or            
                    Unit(target):Health() <= Unit(target):HealthMax() * 0.17
                ) and
                Unit(target):IsPlayer() and  
                A.LayOnHands:IsInRange(target) and
                Unit(target):HasBuffs(A.Cyclone.ID, true) == 0 and
                -- Forbearance
                Unit(target):HasDeBuffs(A.Forbearance.ID, true) == 0 
            )
        )
        then
            -- Notification                    
            Action.SendNotification("Emergency " .. A.GetSpellInfo(A.LayOnHands.ID), A.LayOnHands.ID)
            return A.LayOnHands:Show(icon)
        end

        -- #7.1 Emergency Lay on Hands 
        if combatTime > 0 and Action.Zone ~= "arena" and not Action.InstanceInfo.isRated   -- Forbearance
        then
            for i = 1, #getmembersAll do 
                if Unit(getmembersAll[i].Unit):GetRange() <= 40 then 
                      if not Unit(getmembersAll[i].Unit):IsPet() and A.LayOnHands:IsReady(getmembersAll[i].Unit) and (Unit(getmembersAll[i].Unit):HealthPercent() <= LayOnHandsHP or Unit(getmembersAll[i].Unit):TimeToDie() <= LayOnHandsTTD) and Unit(getmembersAll[i].Unit):HasDeBuffs(A.Forbearance.ID, true) == 0 then
                        HealingEngine.SetTarget(getmembersAll[i].Unit, 1)    -- Add 1sec delay in case of emergency switch     
                        -- Notification                    
                        Action.SendNotification("Emergency " .. A.GetSpellInfo(A.LayOnHands.ID) .. " on " .. UnitName(getmembersAll[i].Unit), A.LayOnHands.ID)        
                        return A.LayOnHands:Show(icon)                        
                    end                    
                end                
            end    

        end 
		
        -- #8 Trinkets Heal         
        if A.AbsentImun(nil, unit) and Unit(unit):HealthPercent() <= GetToggle(2, "TrinketBurstHealing") and not IsUnitEnemy(unit) and Unit(unit):InRange() and inCombat then 
            if A.Trinket1:IsReady(unit) and A.Trinket1:GetItemCategory() ~= "DPS" then 
                return A.Trinket1:Show(icon)
            end 
            
            if A.Trinket2:IsReady(unit) and A.Trinket2:GetItemCategory() ~= "DPS" then 
                return A.Trinket2:Show(icon)
            end     
        end 

        -- #9 Burst Cooldowns
        -- #9.1 HolyAvenger
        if A.HolyAvenger:IsReady(player) and A.BurstIsON(unit) and A.HolyAvenger:IsSpellLearned() and
        -- AW Original
        Unit(player):HasBuffs(A.AvengingWrath.ID, true) == 0 and
        (       
            -- HealingEngine conditions for burst raid/party heal
            (
                AoEON and
                (
                    (
                        not MouseOver or
                        not A.MouseHasFrame() or
                        not IsUnitEnemy(mouseover)
                    ) and
                    not IsUnitEnemy(target) 
                ) and
                (            
                    (
                        TeamCacheFriendlySize > 1 and 
                        (
                            AVG_DMG and
                            ReceivedLast5sec and 
                            AVG_HPS and
                            (
                                ReceivedLast5sec > AVG_DMG + AVG_HPS or
                                AVG_DMG >= AVG_HPS * 3
                            ) 
                        ) and
                        (
                            HealingEngine.GetTimeToDieUnits(15) >= GetValidMembers(true) * 0.5 or
                            HealingEngine.GetBelowHealthPercentUnits(60) >= GetValidMembers(true) * 0.5
                        )
                    ) or        
                    (
                        TeamCacheFriendlyType == "party" and
                        HealingEngine.GetBelowHealthPercentUnits(HolyAvengerPartyHP) >= HolyAvengerPartyUnits  
                    ) or 
                    (
                        TeamCacheFriendlyType == "raid" and
                        HealingEngine.GetBelowHealthPercentUnits(HolyAvengerRaidHP) >= HolyAvengerRaidUnits               
                    )
                )
            ) or
            -- MouseOver
            (
                MouseOver and
                Unit(mouseover):IsExists() and 
                A.MouseHasFrame() and               
                not IsUnitEnemy(mouseover) and                 
                Unit(mouseover):IsPlayer() and
                Unit(mouseover):GetRange() <= 40 and
                --Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) <= GetCurrentGCD() + GetGCD() and
                Unit(mouseover):Health() <= Unit(mouseover):HealthMax() * 0.7 and
                Unit(mouseover):GetRealTimeDMG() > 0 and
                (                          
                    Unit(mouseover):GetDMG() > Unit(mouseover):HealthMax()*0.2 or
                    Unit(mouseover):GetDMG() > Unit(mouseover):GetHEAL() * 1.2 or
                    Unit(mouseover):Health() <= Unit(mouseover):HealthMax()*0.25
                ) and
                Unit(mouseover):TimeToDie() > 3
            ) or 
            -- Target
            (
                (
                    not MouseOver or 
                    not Unit(mouseover):IsExists() 
                ) and       
                not IsUnitEnemy(target) and
                Unit(target):IsPlayer() and
                Unit(target):GetRange() <= 40 and 
                --Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) and
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) <= GetCurrentGCD() + GetGCD() and
                Unit(target):Health() <= Unit(target):HealthMax() * 0.7 and
                Unit(target):GetRealTimeDMG() > 0 and
                (                        
                    Unit(target):GetDMG() > Unit(target):HealthMax() * 0.2 or
                    Unit(target):GetDMG() > Unit(target):GetHEAL() * 1.2 or            
                    Unit(target):Health() <= Unit(target):HealthMax() * 0.25
                ) and        
                Unit(target):TimeToDie() > 3
            ) 
        )        
        then
            -- Notification                    
            Action.SendNotification("Burst " .. A.GetSpellInfo(A.HolyAvenger.ID), A.HolyAvenger.ID)
            return A.HolyAvenger:Show(icon)
        end

        -- #9.2 Avenging Wrath
        if A.AvengingWrath:IsReady(player) and A.BurstIsON(unit) and Unit(player):HasBuffs({A.AvengingCrusader.ID, A.AvengingWrath.ID}, true) == 0 and
        (
            -- HEALING
            (
                not A.AvengingCrusader:IsSpellLearned() and
                A.AvengingWrath:GetCooldown() == 0 and
                -- Holy Avenger, AW Original
                Unit(player):HasBuffs({A.HolyAvenger.ID, A.AvengingWrath.ID}, true) <= GetCurrentGCD() and
                (       
                    -- HealingEngine conditions for burst raid/party heal
                    (
                        AoEON and
                        (
                            (
                                not MouseOver or
                                not A.MouseHasFrame() or
                                not IsUnitEnemy(mouseover)
                            ) and
                            not IsUnitEnemy(target) 
                        ) and
                        (
                            (
                                TeamCacheFriendlySize > 1 and
                                ReceivedLast5sec > AVG_DMG + AVG_HPS 
                                and 
                                HealingEngine.GetTimeToDieUnits(16) >= TeamCacheFriendlySize * 0.67
                            ) 
							or
                            (
                                TeamCacheFriendlyType == "party" and
                                HealingEngine.GetBelowHealthPercentUnits(AvengingWrathPartyHP) >= AvengingWrathPartyUnits
                            ) 
							or 
                            (
                                TeamCacheFriendlyType == "raid" and
                                HealingEngine.GetBelowHealthPercentUnits(AvengingWrathRaidHP) >= AvengingWrathRaidUnits
                            )  
                        )                
                    ) 
					or
                    -- MouseOver
                    (
                        MouseOver and
                        Unit(mouseover):IsExists() and 
                        A.MouseHasFrame() and               
                        not IsUnitEnemy(mouseover) and                 
                        Unit(mouseover):IsPlayer() and
                        Unit(mouseover):GetRange() <= 40 and
                        --Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) and
                        Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) <= GetCurrentGCD() + GetGCD() and
                        Unit(mouseover):Health() <= Unit(mouseover):HealthMax() * 0.4
                        and
                        Unit(mouseover):GetRealTimeDMG() > 0 and
                        (
                            Unit(mouseover):GetDMG() > Unit(mouseover):GetHEAL() * 1.2 or
                            Unit(mouseover):Health() <= Unit(mouseover):HealthMax() * 0.35 
                        ) and
                        Unit(mouseover):TimeToDie() > 4
                    ) or 
                    -- Target
                    (
                        (
                            not MouseOver or 
                            not Unit(mouseover):IsExists() 
                        ) and       
                        not IsUnitEnemy(target) and
                        Unit(target):IsPlayer() and
                        Unit(target):GetRange() <= 40 and 
                        -- Unit(unit):HasDeBuffs(A.Cyclone.ID, true) and
                        Unit(target):HasDeBuffs(A.Cyclone.ID, true) <= GetCurrentGCD() + GetGCD() and
                        Unit(target):Health() <= Unit(target):HealthMax() * 0.4 and
                        Unit(target):GetRealTimeDMG() >= 0 and
                        (
                            Unit(target):GetDMG() > Unit(target):GetHEAL() * 1.2 or
                            Unit(target):Health() <= Unit(target):HealthMax() * 0.35
                        ) and
                        Unit(target):TimeToDie() > 4
                    )
                )
            ) 
			or
            -- DAMAGE
            (
                (
                    (
                        A.AvengingCrusader:IsSpellLearned() and
                        A.AvengingCrusader:GetCooldown() == 0
                    ) 
					or
                    (
                        not A.AvengingCrusader:IsSpellLearned() and
                        A.AvengingWrath:GetCooldown() == 0
                    )
                ) and
                combatTime > 0 and
                (
                    (
                        MouseOver and
                        IsUnitEnemy(mouseover) and                
                        Unit(mouseover):GetLevel() == -1 and
                        Unit(mouseover):GetRange() <= 40
                    ) 
					or
                    (
                        IsUnitEnemy(target) and
                        Unit(target):GetLevel() == -1 and
                        Unit(target):GetRange() <= 40
                    )
                )
            )
        ) 
        then
            -- Notification                    
            Action.SendNotification("Burst " .. A.GetSpellInfo(A.AvengingWrath.ID), A.AvengingWrath.ID)            
            return A.AvengingWrath:Show(icon)
        end		

        -- #9.3 Aura Mastery            
        if A.AuraMastery:IsReady(player) and A.BurstIsON(unit) and combatTime > AuraMasteryAfter and -- AuraMasteryAfter
        (
               HealingEngine.GetTimeToDieUnits(AuraMasteryAoETTD) >= GetValidMembers(true) * 0.4 -- AuraMasteryAoETTD
            or
               ReceivedLast5sec > AVG_DMG * AuraMasteryLast -- AuraMasteryLast
            or
            HealingEngine.GetBelowHealthPercentUnits(AuraMasteryBelowHealthPercent) >= GetValidMembers(true) * 0.35 -- -- AuraMasteryBelowHealthPercent
            or
            HealingEngine.GetBelowHealthPercentUnits(AuraMasteryBelowHealthPercent) >= AuraMasteryUnits -- -- AuraMasteryBelowHealthPercent
        )             
        then
            -- Notification                    
            Action.SendNotification("Burst " .. A.GetSpellInfo(A.AuraMastery.ID), A.AuraMastery.ID)                
            return A.AuraMastery:Show(icon)
        end

        -- #10 Special Mythic + logic - Critical Healing required
		-- Return specific units to target depending on current dungeon logic triggers
		-- Also contain specific Affixes logic
        if UrgentMythicPlusTargetting() and A.IsInInstance and not A.IsInPvP then
		    return true
		end
		
		-- #10.1 Special Raid logic
		-- Wrathion and Shadhar
        if IsInRaid() then
            for i = 1, #getmembersAll do
                local localClass, englishClass, classIndex = UnitClass(getmembersAll[i].Unit)
                local thisUnit = getmembersAll[i].Unit
                if UnitInRange(thisUnit) and A.BlessingofFreedom:IsReady() then
                    if BlessingofFreedomShadhar and Unit(thisUnit):HasDeBuffs(A.Fixate.ID, true) ~= nil and (classIndex == 1 or classIndex == 2 or classIndex == 4 or classIndex == 5 or classIndex == 9) then						    
				    	HealingEngine.SetTarget(thisUnit, 0.5)
						return A.BlessingofFreedom:Show(icon)							
                    end
                    if BlessingofFreedomWrathion and Unit(thisUnit):HasDeBuffsStacks(A.Slow.ID, true) >= WrathionMovementStacks then						    
						HealingEngine.SetTarget(thisUnit, 0.5)
						return A.BlessingofFreedom:Show(icon)
                    end
			    end
            end
        end
		
        -- #11 HPvE #1 Holy Shock (HPS)
        if A.HolyShock:IsReadyByPassCastGCD(unit) and
        (
            -- MouseOver
            (
                MouseOver and
                Unit(mouseover):IsExists() and 
                A.MouseHasFrame() and                        
                not IsUnitEnemy(mouseover) and                 
                A.HolyShock:IsInRange(mouseover) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone
                A.HolyShock:PredictHeal("mouseover") and
                (
                    (
                        Action.InstanceInfo.KeyStone > 0 and
                        Action.InstanceInfo.GroupSize <= 5
                    ) 
					or 
                    Unit(mouseover):TimeToDie() <= GetGCD() * 2.5 or
                    (
                        (
                            -- AW
                            Unit(player):HasBuffs(31884, true) < GetCurrentGCD() + GetGCD() or
                            -- Glimmer of Light
                            Unit(mouseover):HasBuffs(287280, player, true) <= 8.5 or
                            -- Divine Purpose
                            (
                                Unit(player):HasBuffs(216411, true) > 0 and
                                Unit(player):HasBuffs(216411, true) < GetCurrentGCD() + GetGCD()
                            )
                        ) and 
                        (                                   
                            -- Infusion of Light                            
                            Unit(player):HasBuffs(54149, true) <= Unit(player):CastTime(19750) + GetCurrentGCD() + 0.3 or                    
                            Unit(player):GetCurrentSpeed() ~= 0 
                        )
                    )
                )        
            ) 
			or 
            -- Target
            (
                (
                    not MouseOver or 
                    not Unit(mouseover):IsExists() 
                ) and        
                not IsUnitEnemy(target) and
                A.HolyShock:IsInRange(target) and
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone
                A.HolyShock:PredictHeal("target") and
                (
                    (
                        Action.InstanceInfo.KeyStone > 0 and
                        Action.InstanceInfo.GroupSize <= 5
                    ) 
                    or 
                    Unit(target):TimeToDie() <= GetGCD() * 2.5 
                    or
                    (
                        (
                            -- AW
                            Unit(player):HasBuffs(31884, true) < GetCurrentGCD() + GetGCD() 
                            or
                            -- Glimmer of Light
                            Unit(target):HasBuffs(287280, player, true) <= 8.5 
                            or   
                            -- Divine Purpose
                            (
                                Unit(player):HasBuffs(216411, player, true) > 0 and
                                Unit(player):HasBuffs(216411, player, true) < GetCurrentGCD() + GetGCD()
                            )
                        ) and 
                        (                                   
                            -- Infusion of Light                            
                            Unit(player):HasBuffs(54149, true) <= Unit(player):CastTime(19750) + GetCurrentGCD() + 0.3 or                    
                            Unit(player):GetCurrentSpeed() ~= 0 
                        )
                    )
                )        
            ) 
			or
            -- Precombat Glimmer on tanks
			GlimmerTankOOC and
			(
			    combatTime == 0 and 
				GlimmerofLightCount < 8 and 
				Unit(unit):HasBuffs(A.GlimmerofLightBuff.ID, true) == 0 and
				Unit(unit):IsTank()
			) 
			or
			-- IneffableTruth Buff 
			Unit(player):HasBuffs(A.IneffableTruthBuff.ID, player, true) > 0 
        )        
        then
            return A.HolyShock:Show(icon)
        end
		
         -- #12.1 HPvE Light of Dawn
        if A.LightofDawn:IsReady(player) and
        (
            (
                TeamCache.Friendly.Size > 5 and 
                HealingEngine.GetBelowHealthPercentUnits(LightofDawnHP) >= LightofDawnUnits
            ) or
            (
                TeamCache.Friendly.Size <= 5 and 
                HealingEngine.GetBelowHealthPercentUnits(LightofDawnHP) >= LightofDawnUnits
            ) 
        )
        then  
            return A.LightofDawn:Show(icon)
        end  

		--	#12.2 HPvE Word of Glory
        if A.WordofGlory:IsReady(unit) and
        (    
				Unit(target):HealthPercent() < WordofGloryHP
		)
        then
            return A.WordofGlory:Show(icon)
        end  

        -- #13 Bestow Faith
        if A.BestowFaith:IsSpellLearned() and A.BestowFaith:IsReady(unit) and A.BestowFaith:IsSpellLearned() and
        (
            -- MouseOver
            (
                MouseOver and
                Unit(mouseover):IsExists() and 
                A.MouseHasFrame() and                        
                not IsUnitEnemy(mouseover) and                  
                A.BestowFaith:IsInRange(mouseover) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone
                A.BestowFaith:PredictHeal("mouseover") 
            ) or 
            -- Target
            (
                (
                    not MouseOver or 
                    not Unit(mouseover):IsExists() 
                ) and        
                not IsUnitEnemy(target) and
                A.BestowFaith:IsInRange(target) and
                Unit(target):HasBuffs(A.Cyclone.ID, true) == 0 and
                A.BestowFaith:PredictHeal("target") 
            )
        )
        then
            return A.BestowFaith:Show(icon)
        end

        -- #14 HPvE #1 FlashofLight
        if A.FlashofLight:IsReady(unit) and InfLight > 0 and InfLight > HLcast_t + GetCurrentGCD() + 0.1 and Unit(player):GetCurrentSpeed() == 0 and Unit(unit):HealthPercent() <= FlashofLightHP and
        (
            -- MouseOver
            (
                MouseOver and
                Unit(mouseover):IsExists() and 
                A.MouseHasFrame() and                        
                not IsUnitEnemy(mouseover) and                 
                A.FlashofLight:IsInRange(mouseover) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) < HLcast_t + GetCurrentGCD() and
                A.FlashofLight:PredictHeal("mouseover") --and
--                Unit(mouseover):TimeToDie() > HLcast_t + GetCurrentGCD() + 1 or
--                Unit(mouseover):HealthPercent() < HolyLightHP or
--                Unit(mouseover):TimeToDieX(15) < HolyLightTTD            
            ) or 
            -- Target
            (
                (
                    not MouseOver or 
                    not Unit(mouseover):IsExists() or 
                    IsUnitEnemy(mouseover)
                ) and        
                not IsUnitEnemy(target) and
                A.FlashofLight:IsInRange(target) and
                Unit(target):HasBuffs(A.Cyclone.ID, true) < HLcast_t + GetCurrentGCD() and
                A.FlashofLight:PredictHeal("target") --and
--                Unit(target):TimeToDie() > HLcast_t + GetCurrentGCD() + 1 or
--                Unit(target):HealthPercent() < HolyLightHP or
--                Unit(target):TimeToDieX(15) < HolyLightTTD            
            )
--[[            or
            -- Save us
            (
                Unit(player):HealthPercent() < HolyLightHP or
                Unit(player):TimeToDieX(15) < HolyLightTTD    
            ) ]]   
        )
        then
            return A.FlashofLight:Show(icon)
        end

        -- #15 HPvE #1 Light of Martyr
        if A.LightofMartyr:IsReady(unit) and
        (
            -- MouseOver
            (
                MouseOver and
                Unit(mouseover):IsExists() and 
                A.MouseHasFrame() and                        
                not IsUnitEnemy(mouseover) and  
                not UnitIsUnit(mouseover, player) and        
                A.LightofMartyr:IsInRange(mouseover) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) == 0 and
                (
                    -- Divine Shield
                    Unit(player):HasBuffs(642, true) > 0 or
                    Unit(player):Health() >= select(2, A.LightofMartyr:PredictHeal("mouseover")) * 3
                ) and        
                (
                    Unit(mouseover):Health() <= Unit(mouseover):HealthMax()*0.18 or
                    (
                        Unit(mouseover):Health() <= Unit(mouseover):HealthMax()*0.25 and
                        Unit(mouseover):TimeToDie() <= 2
                    )            
                ) 
            ) or 
            -- Target
            (
                (
                    not MouseOver or 
                    not Unit(mouseover):IsExists() 
                ) and        
                not IsUnitEnemy(target) and
                not UnitIsUnit(target, player) and
                A.LightofMartyr:IsInRange(target) and
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) == 0 and
                (
                    -- Divine Shield
                    Unit(player):HasBuffs(642, true) > 0 or            
                    Unit(player):Health() >= select(2, A.LightofMartyr:PredictHeal("target")) * 3
                ) and
                (
                    Unit(target):Health() <= Unit(target):HealthMax()*0.18 or
                    (
                        Unit(target):Health() <= Unit(target):HealthMax()*0.25 and
                        Unit(target):TimeToDie() <= 2
                    )  
                ) 
            )
        )        
        then
            return A.LightofMartyr:Show(icon)
        end
        
        -- #16 HPvE #1 HolyLight
        if A.HolyLight:IsReady(unit) and InfLight > 0 and InfLight > HLcast_t + GetCurrentGCD() + 0.1 and Unit(player):GetCurrentSpeed() == 0 and Unit(unit):HealthPercent() <= HolyLightHP and
        (
            -- MouseOver
            (
                MouseOver and
                Unit(mouseover):IsExists() and 
                A.MouseHasFrame() and                        
                not IsUnitEnemy(mouseover) and                 
                A.HolyLight:IsInRange(mouseover) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) < HLcast_t + GetCurrentGCD() and
                A.HolyLight:PredictHeal("mouseover") --and
--                Unit(mouseover):TimeToDie() > HLcast_t + GetCurrentGCD() + 1 or
--                Unit(mouseover):HealthPercent() < HolyLightHP or
--                Unit(mouseover):TimeToDieX(15) < HolyLightTTD            
            ) or 
            -- Target
            (
                (
                    not MouseOver or 
                    not Unit(mouseover):IsExists() or 
                    IsUnitEnemy(mouseover)
                ) and        
                not IsUnitEnemy(target) and
                A.HolyLight:IsInRange(target) and
                Unit(target):HasBuffs(A.Cyclone.ID, true) < HLcast_t + GetCurrentGCD() and
                A.HolyLight:PredictHeal("target") --and
--                Unit(target):TimeToDie() > HLcast_t + GetCurrentGCD() + 1 or
--                Unit(target):HealthPercent() < HolyLightHP or
--                Unit(target):TimeToDieX(15) < HolyLightTTD            
            )
--[[            or
            -- Save us
            (
                Unit(player):HealthPercent() < HolyLightHP or
                Unit(player):TimeToDieX(15) < HolyLightTTD    
            ) ]]   
        )
        then
            return A.HolyLight:Show(icon)
        end
        
        -- #17 HPvE Beacon of Virtue
        if A.BeaconofVirtue:IsReady(unit) and AoEON and A.BeaconofVirtue:IsSpellLearned() and TeamCacheFriendlyType ~= "none" and
        (
            -- MouseOver
            (
                MouseOver and
                Unit(mouseover):IsExists() and 
                A.MouseHasFrame() and                        
                not IsUnitEnemy(mouseover) and                 
                A.BeaconofVirtue:IsInRange(mouseover) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) == 0 
            ) or 
            -- Target
            (
                (
                    not MouseOver or 
                    not Unit(mouseover):IsExists() 
                ) and        
                not IsUnitEnemy(target) and
                A.BeaconofVirtue:IsInRange(target) and
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) == 0
            )
        ) and
        (
            (
                TeamCacheFriendlyType == "party" and
                HealingEngine.GetBelowHealthPercentUnits(80) >= 3 
            ) or
            (
                TeamCacheFriendlyType == "raid" and
                HealingEngine.GetBelowHealthPercentUnits(75) >= 4
            )
        )
        then
            return A.BeaconofVirtue:Show(icon)
        end

        -- #18 Blessing of Freedom
        if A.BlessingofFreedom:IsReady(unit) and 
        (
            -- MouseOver
            (
                MouseOver and        
                A.MouseHasFrame() and                      
                not IsUnitEnemy(mouseover) and                          
                Unit(mouseover):TimeToDie() > GetGCD() * 3.8 and
                HoF(mouseover)
            ) 
            or 
            -- Target
            (
                (
                    not MouseOver or 
                    not Unit(mouseover):IsExists() 
                ) and       
                not IsUnitEnemy(target) and        
                Unit(unit):TimeToDie() > GetGCD() * 3.8 and
                HoF(target)
            )
        )
        then
            return A.BlessingofFreedom:Show(icon)
        end
        
        -- #19 LightsHammer
        if (isMulti or AoEON) and A.LightsHammer:IsReady(unit) and A.LightsHammer:IsSpellLearned() and
        (
            (
                not MouseOver or
                not A.MouseHasFrame() or
                not IsUnitEnemy(mouseover)
            ) and
            not IsUnitEnemy(target) 
        ) and
        (            
            (
                TeamCacheFriendlySize > 1 and
                (
                    ReceivedLast5sec > AVG_DMG + AVG_HPS or
                    AVG_DMG >= AVG_HPS * 2
                ) and
                (
                    HealingEngine.GetTimeToDieUnits(15) >= ValidMembers(true) * 0.5 or
                    HealingEngine.GetBelowHealthPercentUnits(50) >= ValidMembers(true) * 0.5
                )
            ) or        
            (
                TeamCacheFriendlyType == "party" and
                HealingEngine.GetBelowHealthPercentUnits(50) >= 3
            ) or 
            (
                TeamCacheFriendlyType == "raid" and
                HealingEngine.GetBelowHealthPercentUnits(65) >= 6              
            ) or
            -- Master Aur
            A.LastPlayerCastName == A.AuraMastery:Info()
        )        
        then
            return A.LightsHammer:Show(icon)
        end
				
--[[        -- #20 HPvE #2 FlashofLight
        if A.FlashofLight:IsReady(unit) and Unit(player):GetCurrentSpeed() == 0 and 
        (
            -- MouseOver
            (
                MouseOver and
                Unit(mouseover):IsExists() and 
                A.MouseHasFrame() and                        
                not IsUnitEnemy(mouseover) and                 
                A.FlashofLight:IsInRange(mouseover) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) < FLcast_t + GetCurrentGCD() and
                A.FlashofLight:PredictHeal("mouseover") and
 --               (
                    -- Tank
                    (                
                        Unit(mouseover):HealthPercent() < 95 and
                        Unit(mouseover):IsTank() and
						CombatTime == 0
                    ) 
--                    or
--                    Unit(mouseover):Health() <= Unit(mouseover):HealthMax() * 0.75 or
--                    Player:Mana() >= Player:ManaMax() * 0.80            
--                ) 
				and
                (
                    TeamCacheFriendlySize <= 5 or
                    Unit(mouseover):IsTank() or
                    Unit(mouseover):HealthPercent() <= 40
                )
            ) or 
            -- Target
            (
                (
                    not MouseOver or 
                    not Unit(mouseover):IsExists() 
                ) and        
                not IsUnitEnemy(target) and
                A.FlashofLight:IsInRange(target) and
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) and
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) < FLcast_t + GetCurrentGCD() and
                A.FlashofLight:PredictHeal("target") and
                (
                    -- Tank
                    (                
                        Unit(target):HealthPercent() < 95 and
                        Unit(target):IsTank() and
						CombatTime == 0
                    ) 
                    or  
--                    Unit(target):Health() <= Unit(target):HealthMax() * 0.75 or
--                    Player:Mana() >= Player:ManaMax() * 0.80
					(
						Unit(target):HealthPercent() < FlashofLightHP
					)
--                ) and
--                (
--                    TeamCacheFriendlySize <= 5 or
--                    Unit(target):IsTank() or
--                    Unit(target):HealthPercent() <= 40            
                )
            )
        )
        then
            return A.FlashofLight:Show(icon)
        end]]
        
        --[[ #21 HPvE #2 HolyLight
        if A.HolyLight:IsReady(unit) and Unit(player):GetCurrentSpeed() == 0 and 
        (
            -- MouseOver
            (
                MouseOver and
                Unit(mouseover):IsExists() and 
                A.MouseHasFrame() and                        
                not IsUnitEnemy(mouseover) and                 
                A.HolyLight:IsInRange(mouseover) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) < HLcast_t + GetCurrentGCD() and
                (
                    Unit(mouseover):HealthPercent() < 94 
                )        
                --PredictHeal("HolyLight", mouseover) 
            ) or 
            -- Target
            (
                (
                    not MouseOver or 
                    not Unit(mouseover):IsExists() 
                ) and        
                not IsUnitEnemy(target) and
                A.HolyLight:IsInRange(target) and
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) and
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) < HLcast_t + GetCurrentGCD() and
                (
                    Unit(target):HealthPercent() < 94
                )        
                --PredictHeal("HolyLight", target) 
            )
        )
        then
            return A.HolyLight:Show(icon)
        end]]

        -- #22 Holy Prism
        if (isMulti or AoEON) and A.HolyPrism:IsSpellLearned() and A.HolyPrism:IsReady(unit) and
        (
            -- HPS
            -- MouseOver
            (
                MouseOver and
                Unit(mouseover):IsExists() and 
                A.MouseHasFrame() and                        
                not IsUnitEnemy(mouseover) and                 
                A.HolyPrism:IsInRange(mouseover) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone
                A.HolyPrism:PredictHeal("mouseover")
            ) or 
            -- Target
            (
                (
                    not MouseOver or 
                    not Unit(mouseover):IsExists() 
                ) and        
                not IsUnitEnemy(target) and
                A.HolyPrism:IsInRange(target) and
                Unit(unit):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone
                A.HolyPrism:PredictHeal("target")
            ) or
            -- DMG
            -- MouseOver
            (
                MouseOver and
                IsUnitEnemy(mouseover) and
                A.HolyPrism:IsInRange(mouseover) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone
                (
                    not AoEON or
                    HealingEngine.HealingBySpell("HolyPrism", 114165) >= 2
                ) and
                A.HolyPrism:AbsentImun(mouseover, Temp.TotalAndMag, true)        
            ) or
            -- Target
            (
                (
                    not MouseOver or
                    not A.MouseHasFrame() or
                    not IsUnitEnemy(mouseover)
                ) and
                IsUnitEnemy(target) and
                A.HolyPrism:AbsentImun(target, Temp.TotalAndMag, true)  
            )    
        )
        then        
            return A.HolyPrism:Show(icon)
        end

        -- Consecration

        -- #23 HPvE #2 Light of Martyr
        if A.LightofMartyr:IsReady(unit) and 
        (
            -- MouseOver
            (
               MouseOver and
              Unit(mouseover):IsExists() and 
              A.MouseHasFrame() and                        
               not IsUnitEnemy(mouseover) and  
               not UnitIsUnit(mouseover, player) and        
               A.LightofMartyr:IsInRange(mouseover) and
               Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) == 0 and
            (
                 -- Divine Shield
                 Unit(player):HasBuffs(642, true) > 0 or
                  Unit(player):Health() >= select(2, A.LightofMartyr:PredictHeal("mouseover")) * 4.5
               ) and        
               A.LightofMartyr:PredictHeal("mouseover")
           ) or 
           -- Target
           (
              (
                   not MouseOver or 
                not Unit(mouseover):IsExists() 
               ) and        
               not IsUnitEnemy(target) and
               not UnitIsUnit(target, player) and
              A.LightofMartyr:IsInRange(target) and
               Unit(target):HasDeBuffs(A.Cyclone.ID, true) == 0 and
               (
                   -- Divine Shield
                   Unit(player):HasBuffs(642, true) > 0 or            
                  Unit(player):Health() >= select(2, A.LightofMartyr:PredictHeal("target")) * 4.5
               ) and
                A.LightofMartyr:PredictHeal("target")
            )
        )
        then        
            return A.LightofMartyr:Show(icon)
        end
  
        -- #24 HPvE #2 Light of Dawn
        if A.LightofDawn:IsReady(unit) and 
        (            
            -- MouseOver
            (
                MouseOver and
                Unit(mouseover):IsExists() and 
                A.MouseHasFrame() and                        
                not IsUnitEnemy(mouseover) and                         
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) == 0 and
                A.LightofDawn:PredictHeal("mouseover") and
                -- Azerite Breaking Dawn
                Unit(mouseover):CanInterract((A.BreakingDawn:GetAzeriteRank() > 0 and 40) or 15)
            ) or 
            -- Target
            (
                (
                    not MouseOver or 
                    not Unit(mouseover):IsExists() 
                ) and        
                not IsUnitEnemy(target) and        
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) == 0 and
                A.LightofDawn:PredictHeal("target") and
                -- Azerite Breaking Dawn
                Unit(target):CanInterract((A.BreakingDawn:GetAzeriteRank() > 0 and 40) or 15)
            )
        )
        then        
            return A.LightofDawn:Show(icon)
        end
		
		-- #25 Nothing to do so DPS ? Seems good idea yeah
		-- DPS targettarget ofc     
    	if IsUnitEnemy(targettarget) then         
        	if DamageRotation(targettarget) then 
            	return true 
        	end 
    	end 
        			
    end    
    HealingRotation = Action.MakeFunctionCachedDynamic(HealingRotation)

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

local function RotationPassive(icon)
    if not GetToggle(2, "UseRotationPassive") then 
        return 
    end 
    
    -- UI Settings var
    local DivineProtectionTTD = GetToggle(2, "DivineProtectionTTD")
    local DivineProtectionHP = GetToggle(2, "DivineProtectionHP")
    local DivineShieldHP = GetToggle(2, "DivineShieldHP")
    local DivineShieldTTD = GetToggle(2, "DivineShieldTTD")
    local LayOnHandsHP = GetToggle(2, "LayOnHandsHP")
    local LayOnHandsTTD = GetToggle(2, "LayOnHandsTTD")
    RotationsVariables()
	
    -- RESS ALL PEOPLE
    if A.Absolution:IsReady(player) and combatTime == 0 and Unit(player):GetCurrentSpeed() == 0 and
    (
        -- MouseOver
        (
            MouseOver and
            A.MouseHasFrame() and
            Unit(mouseover):IsExists() and        
            Unit(mouseover):IsDead() and
            Unit(mouseover):IsPlayer() and        
            (UnitInRaid(mouseover) or UnitInParty(mouseover)) and        
            Unit(mouseover):GetRange() <= 100
        ) or 
        (
            (
                not MouseOver or 
                not Unit(mouseover):IsExists() or 
                IsUnitEnemy(mouseover)
            ) and
            Unit(target):IsDead() and
            Unit(target):IsPlayer() and
            (UnitInRaid(target) or UnitInParty(target)) and
            Unit(target):GetRange() <= 100
        )
    )
    then
        -- Notification                    
        Action.SendNotification("Mass Resurrection " .. A.GetSpellInfo(A.Absolution.ID), A.Absolution.ID)
        return A.Absolution:Show(icon)
    end    

    -- RESS Single
    if A.Redemption:IsReady(unit) and combatTime == 0 and Unit(player):GetCurrentSpeed() == 0 and
    (
        -- MouseOver
        (
            MouseOver and
            A.MouseHasFrame() and
            Unit(mouseover):IsExists() and        
            Unit(mouseover):IsDead() and
            Unit(mouseover):IsPlayer() and        
            not IsUnitEnemy(mouseover) and         
            A.Redemption:IsInRange(mouseover)    
        ) or 
        (
            (
                not MouseOver or 
                not Unit(mouseover):IsExists() or 
                IsUnitEnemy(mouseover)
            ) and
            Unit(target):IsDead() and
            Unit(target):IsPlayer() and
            not IsUnitEnemy(target) and
            A.Redemption:IsInRange(target)
        )
    )
    then
        -- Notification                    
        Action.SendNotification("Resurrection " .. A.GetSpellInfo(A.Redemption.ID), A.Redemption.ID)
        return A.Redemption:Show(icon)
    end    

        
    -- Passive Lay on Hands Player
    if A.LayOnHands:IsReady(player) and combatTime > 0 and Action.Zone ~= "arena" and not Action.InstanceInfo.isRated and (Unit(player):HealthPercent() <= LayOnHandsHP or Unit(player):TimeToDie() <= LayOnHandsTTD) and Unit(player):HasDeBuffs(A.Forbearance.ID, true) == 0 -- Forbearance
    then
        -- Notification                    
        Action.SendNotification("Emergency " .. A.GetSpellInfo(A.LayOnHands.ID), A.LayOnHands.ID)
        return A.LayOnHands:Show(icon)
    end    
        
    -- Passive Divine Shield
    if A.DivineShield:IsReady(player) and combatTime > 0 and
    (
        (
            not UnitIsUnit(target, player) and
             (
                not MouseOver 
                or
                not A.MouseHasFrame() 
                or
                not UnitIsUnit(mouseover, player)
            )        
        ) 
        or
        (
            Unit(player):TimeToDieX(8) < 3 and
            (
                GetByRange(1, 10) 
                or
                EnemyTeam("DAMAGER"):PlayersInRange(1, 10)
            ) and
            Unit(player):GetDMG() > Unit(player):GetHPS() 
        )
    ) and
    Unit(player):HasDeBuffs(A.Forbearance.ID, true) == 0 and -- Forbearance
    (
        (
            Unit(player):HealthPercent() < DivineShieldHP and
            Unit(player):TimeToDieX(8) <= GetGCD() * 1.5 + GetCurrentGCD()
        ) 
        or
        (
            A.IsInPvP and
            Unit(player):IsFocused() and
            Unit(player):HealthPercent() < 35 and
            not Unit(player):HasFlags() and
            (
                Unit(player):HealthPercent() <= 21 or
                (                
                    Unit(player):HasBuffs("DeffBuffs") == 0 and
                    FriendlyTeam("HEALER"):GetCC() and
                    Unit(player):IsExecuted()
                ) 
                or            
                (
                    Unit(player):UseDeff() and
                    Unit(player):TimeToDie() <= GetGCD() * 3
                )
                or
                (
                    Unit(player):UseDeff() and
                    Unit(player):TimeToDie() <= DivineShieldTTD
                )
            )
        ) 
    ) and
    (
        Unit(player):HasBuffs("DeffBuffs") <= GetCurrentGCD() or
        Unit(player):HealthPercent() < DivineShieldHP   
    )
    then
        -- Notification                    
        Action.SendNotification("Emergency " .. A.GetSpellInfo(A.DivineShield.ID), A.DivineShield.ID)
        return A.DivineShield:Show(icon)
    end  

      -- BlessingofFreedom
    if A.BlessingofFreedom:IsReady(player) and Unit(player):HasDeBuffs("Rooted") > 0 then
        return A.BlessingofFreedom:Show(icon)
    end	
    
    -- Passive Divine Protection
    if A.DivineProtection:IsReady(player) and combatTime > 0 and
    -- Divine Shield 
    Unit(player):HasBuffs(642, true) == 0 and
    (
        -- Sacriface
        (   
            Unit(player):Health() > Unit(player):HealthMax() * 0.2 and
            A.LastPlayerCastName == A.BlessingofSacrifice:Info()
        )
        or
        (   
            -- PvE        
            (
               Unit(player):HasBuffs("DeffBuffs") == 0 and
                (
                    (
                        not A.IsInPvP and
                        Unit(player):TimeToDie() < 12 and
                        Unit(player):Health() <= Unit(player):HealthMax() * 0.58
                    ) 
                    or
                    (
                        Unit(player):TimeToDie() < 14 and
                        Unit(player):GetDMG() * 3 >= Unit(player):Health()
                    ) 
                    or
                    (
                        Unit(player):TimeToDie() < 7 and
                        Unit(player):GetRealTimeDMG() > 0 and
                        Unit(player):Health() <= Unit(player):HealthMax() * 0.25
                    )
                )
            ) 
            or
            -- PvP
            (
                A.IsInPvP and
                Unit(player):IsFocused() and
                (
                    (
                        Unit(player):UseDeff() and
                        (
                            (
                                Unit(player):HasBuffs("DeffBuffs") == 0 and
                                Unit(player):TimeToDie() <= GetGCD() * 8
                            ) or
                            Unit(player):IsExecuted()            
                        ) and  
                        (                                               
                            Unit(player):HasBuffs(212182, true) > 0 or -- Smoke Bomb
                            Unit(player):GetDMG() > Unit(player):GetHEAL()
                        ) 
                    ) or
                    (
                        Unit(player):HasBuffs("DeffBuffs") == 0 and
                        Unit(player):HasDeBuffs("Stuned") > 2 and
                        (
                            Unit(player):IsFocused(nil, true, true) or                                
                            (
                                Unit(player):UseDeff() and
                                Unit(player):HealthPercent() < 80
                            )
                        )
                    )
                )
            )
        )         
    )
    or
    -- Custom Settings UI
    (
        Unit(player):TimeToDie() <= DivineProtectionTTD
        or
        Unit(player):HealthPercent() <= DivineProtectionHP
    )
    then
        -- Notification                    
        Action.SendNotification("Emergency " .. A.GetSpellInfo(A.DivineProtection.ID), A.DivineProtection.ID)
        return A.DivineProtection:Show(icon)
    end    
end 


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
    Unit(player):GetDR("incapacitate") >= 50 
    then 
        local Caster = UnitCooldown:GetUnitID("arena", 3355)
        if Caster and Unit(Caster):GetRange() <= 40 then 
            return true 
        end 
    end 
end ]]--

local function ArenaRotation(icon, unit)
    if A.IsInPvP and (Action.Zone == "pvp" or Action.Zone == "arena") and not Player:IsStealthed() and not Player:IsMounted() then
        -- Note: "arena1" is just identification of meta 6
        if (unit == "arena1" or unit == "arena2" or unit == "arena3") then  
            -- Reflect Casting BreakAble CC
            if A.HammerofJustice:IsReady() and A.HammerofJustice:IsSpellLearned() and EnemyTeam():IsCastingBreakAble(0.25) then 
                return A.HammerofJustice
            end 
        end
    end 
end 

local function PartyRotation(unit)
    if (unit == "party1" and not A.GetToggle(2, "PartyUnits")[1]) or (unit == "party2" and not A.GetToggle(2, "PartyUnits")[2]) then 
        return false 
    end

    --Dispell
	if A.Cleanse:IsReady(unit) and not UnitIsUnit("target", unit) and AuraIsValid(unit, "UseDispel", "Dispel")
    then
        return A.Cleanse
    end
	
	-- BlessingofSacrifice
    if A.BlessingofSacrifice:IsReady(unit) and
    not UnitIsUnit("target", unit) and
    (
        -- Blessing of Sanctuary
        BoS(unit) or
        -- Hand of Sacriface
        HoS(unit, 35, true, true)
    )
    then
        return A.BlessingofSacrifice
    end

    -- BlessingofFreedom
    if A.BlessingofFreedom:IsReady(unit) and not UnitIsUnit("target", unit) and HoF(unit)
	then
        return A.BlessingofFreedom
    end
    
    -- BlessingofProtection
    if A.BlessingofProtection:IsReady(unit) and not UnitIsUnit("target", unit) and BoP(unit)
    then
        return A.BlessingofProtection
    end
    
end 

A[6] = function(icon)
    -- Call rotations variables
	RotationsVariables()
	
    -- StopCast OverHeal
    if Temp.LastPrimaryUnitID and CanStopCastingOverHeal() and StopCastOverHeal then 
        return A:Show(icon, ACTION_CONST_STOPCAST)
    end

    -- ZakLL Stop Cast M+ Quake Affix
    if Unit(player):IsCastingRemains() > 0 and StopCastQuake and Unit(player):HasDeBuffs(A.Quake.ID) <= StopCastQuakeSec and Unit(player):HasDeBuffs(A.Quake.ID) > 0 then
        return A:Show(icon, ACTION_CONST_STOPCAST)
    end
  
    if RotationPassive(icon) then 
        return true 
    end 
    
    local Arena = ArenaRotation("arena1")
    if Arena then 
        return Arena:Show(icon)
    end 
end

A[7] = function(icon)
    if RotationPassive(icon) then 
        return true 
    end 
    
    local Party = PartyRotation("party1") 
    if Party then 
        return Party:Show(icon)
    end   
    
    local Arena = ArenaRotation("arena2")
    if Arena then 
        return Arena:Show(icon)
    end 
end

A[8] = function(icon)
    if RotationPassive(icon) then 
        return true 
    end 
    
    local Party = PartyRotation("party2") 
    if Party then 
        return Party:Show(icon)
    end     
    
    local Arena = ArenaRotation("arena3")
    if Arena then 
        return Arena:Show(icon)
    end 
end