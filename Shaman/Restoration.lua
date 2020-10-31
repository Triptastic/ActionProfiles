--#####################################
--##### TRIP'S RESTORATION SHAMAN #####
--#####################################

--Full credit to Taste

local _G, setmetatable							= _G, setmetatable
local TMW                                       = TMW
local CNDT                                      = TMW.CNDT
local Env                                       = CNDT.Env
local A                         			    = _G.Action
local Listener                                  = Action.Listener
local Create                                    = Action.Create
local GetSpellInfo                              = Action.GetSpellInfo
local GetToggle                                 = Action.GetToggle
local GetGCD                                    = Action.GetGCD
local GetCurrentGCD                             = Action.GetCurrentGCD
local ShouldStop                                = Action.ShouldStop
local AuraIsValid                               = Action.AuraIsValid
local InterruptIsValid                          = Action.InterruptIsValid
local BurstIsON                                 = Action.BurstIsON
local BossMods_Pulling                          = Action.BossMods_Pulling
local TeamCache                                 = Action.TeamCache
local EnemyTeam                                 = Action.EnemyTeam
local FriendlyTeam                              = Action.FriendlyTeam
local HealingEngine                             = Action.HealingEngine
local LoC                                       = Action.LossOfControl
local Player                                    = Action.Player 
local MultiUnits                                = Action.MultiUnits
local UnitCooldown                              = Action.UnitCooldown
local Unit                                      = Action.Unit 
local IsUnitEnemy                               = Action.IsUnitEnemy 
local IsUnitFriendly                            = Action.IsUnitFriendly 
local TeamCacheFriendly                         = TeamCache.Friendly
local HealingEngineMembersALL                   = HealingEngine.GetMembersAll() -- function call!
local HealingEngineGetMinimumUnits              = HealingEngine.GetMinimumUnits
local HealingEngineGetIncomingDMGAVG            = HealingEngine.GetIncomingDMGAVG
local HealingEngineGetIncomingHPSAVG            = HealingEngine.GetIncomingHPSAVG
local TeamCacheFriendlyIndexToPLAYERs           = TeamCacheFriendly.IndexToPLAYERs
local select, math                              = select, math 
local ACTION_CONST_STOPCAST                     = _G.ACTION_CONST_STOPCAST
local ACTION_CONST_SPELLID_FREEZING_TRAP        = _G.ACTION_CONST_SPELLID_FREEZING_TRAP
local TR                                        = Action.TasteRotation
local Pet                                       = LibStub("PetLibrary")
local next, pairs, type, print                  = next, pairs, type, print 
local math_floor                                = math.floor
local math_ceil                                 = math.ceil
local tinsert                                   = table.insert 
local select, unpack, table                     = select, unpack, table 
local CombatLogGetCurrentEventInfo              = _G.CombatLogGetCurrentEventInfo
local UnitGUID, UnitIsUnit, UnitDamage, UnitAttackSpeed, UnitAttackPower = UnitGUID, UnitIsUnit, UnitDamage, UnitAttackSpeed, UnitAttackPower
local _G, setmetatable, select, math            = _G, setmetatable, select, math 
local huge                                      = math.huge  
local UIParent                                  = _G.UIParent 
local CreateFrame                               = _G.CreateFrame
local wipe                                      = _G.wipe
local IsUsableSpell                             = IsUsableSpell
local UnitPowerType                             = UnitPowerType 

--Toaster stuff
local Toaster																	= _G.Toaster
local GetSpellTexture 															= _G.TMW.GetSpellTexture


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
    -- Main Spells
    Riptide                                = Action.Create({ Type = "Spell", ID = 61295, predictName = "Riptide"   }),
	HealingSurge                           = Action.Create({ Type = "Spell", ID = 8004, predictName = "HealingSurge"   }),
	HealingWave                            = Action.Create({ Type = "Spell", ID = 77472, predictName = "HealingWave"   }),	
	ChainHeal                              = Action.Create({ Type = "Spell", ID = 1064, predictName = "ChainHeal"   }),
	HealingRain                            = Action.Create({ Type = "Spell", ID = 73920, predictName = "HealingRain"   }),
	HealingStreamTotem                     = Action.Create({ Type = "Spell", ID = 5394, predictName = "HealingStreamTotem"   }),
	EarthShield                            = Action.Create({ Type = "Spell", ID = 974, predictName = "EarthShield"     }),
	WaterShield							   = Action.Create({ Type = "Spell", ID = 52127, }),
	TidalWaveBuff                          = Action.Create({ Type = "Spell", ID = 53390, Hidden = true   }),
	FlashFloodBuff                         = Action.Create({ Type = "Spell", ID = 280615, Hidden = true   }),
	-- Offensive Abilities
	FlameShock                             = Action.Create({ Type = "Spell", ID = 188389   }),
	FlameShockDebuff                       = Action.Create({ Type = "Spell", ID = 188389, Hidden = true   }),
	LavaBurst                              = Action.Create({ Type = "Spell", ID = 51505   }),
	LightningBolt                          = Action.Create({ Type = "Spell", ID = 188196   }),
	ChainLightning                         = Action.Create({ Type = "Spell", ID = 188443   }),
	-- Cooldowns
	HealingTideTotem                       = Action.Create({ Type = "Spell", ID = 108280  , predictName = "HealingTideTotem" }),
	SpiritLinkTotem                        = Action.Create({ Type = "Spell", ID = 98008   }),
	SpiritWalkersGrace                     = Action.Create({ Type = "Spell", ID = 79206   }),
	UnleashLife                            = Action.Create({ Type = "Spell", ID = 73685, predictName = "UnleashLife"   }), -- Increase next direct heal by 35%
	Ascendance                             = Action.Create({ Type = "Spell", ID = 114052   }),
	-- Totems
	CloudburstTotem                        = Action.Create({ Type = "Spell", ID = 157153   }), -- Talent, replace HealingStreamTotem
	AncestralProtectionTotem               = Action.Create({ Type = "Spell", ID = 207399   }), -- Incoming death on critical unit
	WindRushTotem                          = Action.Create({ Type = "Spell", ID = 192077   }), -- Speed
	EarthgrabTotem                         = Action.Create({ Type = "Spell", ID = 51485   }), -- Rooted
	EarthenWallTotem                       = Action.Create({ Type = "Spell", ID = 198838   }), -- Shield phys
	EarthbindTotem                         = Action.Create({ Type = "Spell", ID = 2484   }), -- Slow
	CapacitorTotem                         = Action.Create({ Type = "Spell", ID = 192058   }), -- Stun
	TremorTotem                            = Action.Create({ Type = "Spell", ID = 8143   }), -- Antifear, charm, sleep
	SkyfuryTotem                           = Action.Create({ Type = "Spell", ID = 204330   }), -- Burst
	-- Talents
	HighTide                               = Action.Create({ Type = "Spell", ID = 157154, Hidden = true     }),
	EchooftheElements                      = Action.Create({ Type = "Spell", ID = 108283, Hidden = true     }),
	AncestralVigor                         = Action.Create({ Type = "Spell", ID = 207401, Hidden = true     }),
	FlashFlood                             = Action.Create({ Type = "Spell", ID = 280614, Hidden = true     }),
	Torrent                                = Action.Create({ Type = "Spell", ID = 200072, Hidden = true     }),
	Undulation                             = Action.Create({ Type = "Spell", ID = 200071     }),
	SpiritWolf                             = Action.Create({ Type = "Spell", ID = 260878     }),
	Wellspring                             = Action.Create({ Type = "Spell", ID = 197995     }),
	Downpour                               = Action.Create({ Type = "Spell", ID = 207778     }),
	-- Defensives
	AstralShift                            = Action.Create({ Type = "Spell", ID = 108271   }),
	-- Utilities
	AncestralSpirit                        = Action.Create({ Type = "Spell", ID = 2008   }),
	AncestralVision                        = Action.Create({ Type = "Spell", ID = 212048   }),
	AstralRecall                           = Action.Create({ Type = "Spell", ID = 556   }),
	FarSight                               = Action.Create({ Type = "Spell", ID = 6196   }),
	GhostWolf                              = Action.Create({ Type = "Spell", ID = 2645   }),
	Bloodlust                              = Action.Create({ Type = "Spell", ID = 2825   }),
	Heroism                                = Action.Create({ Type = "Spell", ID = 32182   }),
	Hex                                    = Action.Create({ Type = "Spell", ID = 51514   }),
    HexGreen                               = Action.Create({ Type = "SpellSingleColor", ID = 51514, Color = "GREEN", Desc = "[1] CC", Hidden = true,  QueueForbidden = true }),
	Purge                                  = Action.Create({ Type = "Spell", ID = 370   }),
	PurifySpirit                           = Action.Create({ Type = "Spell", ID = 77130   }),
	WaterWalking                           = Action.Create({ Type = "Spell", ID = 546   }),	
	WindShear                              = Action.Create({ Type = "Spell", ID = 57994   }),
    WindShearAntiFake                      = Action.Create({ Type = "Spell", ID = 57994, Desc = "[2] Kick", QueueForbidden = true    }),
	EarthElemental                         = Action.Create({ Type = "Spell", ID = 198103   }),
	LavaSurge                              = Action.Create({ Type = "Spell", ID = 77762  }),
	-- PvP
	SpiritLink                             = Action.Create({ Type = "Spell", ID = 204293   }),
	Tidebringer                            = Action.Create({ Type = "Spell", ID = 236501   }),
	SpectralRecovery                       = Action.Create({ Type = "Spell", ID = 204261   }),
	CleansingWaters                        = Action.Create({ Type = "Spell", ID = 290250   }),
	AncestralGift                          = Action.Create({ Type = "Spell", ID = 290254, Hidden = true}), -- PvP Talent - Silence and interrupt immune
	SwellingWaves                          = Action.Create({ Type = "Spell", ID = 204264   }),
	VoodooMastery                          = Action.Create({ Type = "Spell", ID = 204268   }),
	Electrocute                            = Action.Create({ Type = "Spell", ID = 206642   }),	
    -- Potions
    PotionofUnbridledFury                  = Action.Create({ Type = "Potion", ID = 169299, Hidden = true,  QueueForbidden = true }), 
    BattlePotionOfAgility                  = Action.Create({ Type = "Potion", ID = 163223, Hidden = true,  QueueForbidden = true }), 
    SuperiorBattlePotionOfAgility          = Action.Create({ Type = "Potion", ID = 168489, Hidden = true,  QueueForbidden = true }), 
	SuperiorSteelskinPotion                = Action.Create({ Type = "Potion", ID = 168501, Hidden = true,  QueueForbidden = true }), 
	AbyssalHealingPotion                   = Action.Create({ Type = "Potion", ID = 169451, Hidden = true,  QueueForbidden = true }), 
    PotionTest                             = Action.Create({ Type = "Potion", ID = 142117, Hidden = true,  QueueForbidden = true }), 
    -- Trinkets
    GenericTrinket1                        = Action.Create({ Type = "Trinket", ID = 114616, Hidden = true,  QueueForbidden = true }),
    GenericTrinket2                        = Action.Create({ Type = "Trinket", ID = 114081, Hidden = true,  QueueForbidden = true }),
    TrinketTest                            = Action.Create({ Type = "Trinket", ID = 122530, Hidden = true,  QueueForbidden = true }),
    TrinketTest2                           = Action.Create({ Type = "Trinket", ID = 159611, Hidden = true,  QueueForbidden = true }), 
    AzsharasFontofPower                    = Action.Create({ Type = "Trinket", ID = 169314, Hidden = true,  QueueForbidden = true }),
    PocketsizedComputationDevice           = Action.Create({ Type = "Trinket", ID = 167555, Hidden = true,  QueueForbidden = true }),
    RotcrustedVoodooDoll                   = Action.Create({ Type = "Trinket", ID = 159624, Hidden = true,  QueueForbidden = true }),
    ShiverVenomRelic                       = Action.Create({ Type = "Trinket", ID = 168905, Hidden = true,  QueueForbidden = true }),
    AquipotentNautilus                     = Action.Create({ Type = "Trinket", ID = 169305, Hidden = true,  QueueForbidden = true }),
    TidestormCodex                         = Action.Create({ Type = "Trinket", ID = 165576, Hidden = true,  QueueForbidden = true }),
    VialofStorms                           = Action.Create({ Type = "Trinket", ID = 158224, Hidden = true,  QueueForbidden = true }),
    GalecallersBoon                        = Action.Create({ Type = "Trinket", ID = 159614, Hidden = true,  QueueForbidden = true }),
    InvocationOfYulon                      = Action.Create({ Type = "Trinket", ID = 165568, Hidden = true,  QueueForbidden = true }),
    LustrousGoldenPlumage                  = Action.Create({ Type = "Trinket", ID = 159617, Hidden = true,  QueueForbidden = true }),
    ComputationDevice                      = Action.Create({ Type = "Trinket", ID = 167555, Hidden = true,  QueueForbidden = true }),
    VigorTrinket                           = Action.Create({ Type = "Trinket", ID = 165572, Hidden = true,  QueueForbidden = true }),
    FontOfPower                            = Action.Create({ Type = "Trinket", ID = 169314, Hidden = true,  QueueForbidden = true }),
    RazorCoral                             = Action.Create({ Type = "Trinket", ID = 169311, Hidden = true,  QueueForbidden = true }),
    AshvanesRazorCoral                     = Action.Create({ Type = "Trinket", ID = 169311, Hidden = true,  QueueForbidden = true }),
    -- Misc
    Channeling                             = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),	-- Show an icon during channeling
    TargetEnemy                            = Action.Create({ Type = "Spell", ID = 44603, Hidden = true     }),	-- Change Target (Tab button)
    StopCast                               = Action.Create({ Type = "Spell", ID = 61721, Hidden = true     }),		-- spell_magic_polymorphrabbit
    CyclotronicBlast                       = Action.Create({ Type = "Spell", ID = 293491, Hidden = true}),
    ConcentratedFlameBurn                  = Action.Create({ Type = "Spell", ID = 295368, Hidden = true}),
    RazorCoralDebuff                       = Action.Create({ Type = "Spell", ID = 303568, Hidden = true     }),
    ConductiveInkDebuff                    = Action.Create({ Type = "Spell", ID = 302565, Hidden = true     }),
    -- Hidden Heart of Azeroth
    -- added all 3 ranks ids in case used by rotation
    VisionofPerfectionMinor                = Action.Create({ Type = "Spell", ID = 296320, Hidden = true}),
    VisionofPerfectionMinor2               = Action.Create({ Type = "Spell", ID = 299367, Hidden = true}),
    VisionofPerfectionMinor3               = Action.Create({ Type = "Spell", ID = 299369, Hidden = true}),
    UnleashHeartOfAzeroth                  = Action.Create({ Type = "Spell", ID = 280431, Hidden = true}),
    RecklessForceBuff                      = Action.Create({ Type = "Spell", ID = 302932, Hidden = true     }),	
	PoolResource                           = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),
	--Mythic Plus Spells 
	Quake                                  = Create({ Type = "Spell", ID = 240447, Hidden = true     }), -- Quake (Mythic Plus Affix)
	Burst                                  = Create({ Type = "Spell", ID = 240443, Hidden = true     }), -- Bursting (Mythic Plus Affix) Upon death the creature Bursts, inflicting damage equal to (35 / 10)% of maximum health every 1 sec.
	GrievousWound                          = Create({ Type = "Spell", ID = 240559, Hidden = true     }), -- Grievous (Mythic Plus Affix) 2% of a player's maximum health every 3 sec
    Slow                                   = Create({ Type = "Spell", ID = 313255, Hidden = true     }), -- Shadhar slow
	Fixate                                 = Create({ Type = "Spell", ID = 318078, Hidden = true     }), -- Wrathion Fixate
	Cyclone                                = Create({ Type = "Spell", ID = 33786, Hidden = true   }), -- Debuff check
	Innervate                              = Create({ Type = "Spell", ID = 29166, Hidden = true     }),
};

-- To create essences use next code:
Action:CreateEssencesFor(ACTION_CONST_SHAMAN_RESTORATION)  -- where PLAYERSPEC is Constance (example: ACTION_CONST_MONK_BM)
local A = setmetatable(Action[ACTION_CONST_SHAMAN_RESTORATION], { __index = Action })


local player = "player"
local targettarget = "targettarget"
local target = "target"
local mouseover = "mouseover"

local Temp                                  = {
    TotalAndPhys                            = {"TotalImun", "DamagePhysImun"},
    TotalAndPhysKick                        = {"TotalImun", "DamagePhysImun", "KickImun"},
    TotalAndPhysAndCC                       = {"TotalImun", "DamagePhysImun", "CCTotalImun"},
    TotalAndPhysAndStun                     = {"TotalImun", "DamagePhysImun", "StunImun"},
    TotalAndPhysAndCCAndStun                = {"TotalImun", "DamagePhysImun", "CCTotalImun", "StunImun"},
    TotalAndMag                             = {"TotalImun", "DamageMagicImun"},
}

local GetTotemInfo, IsMouseButtonDown, UnitIsUnit = 
GetTotemInfo, IsMouseButtonDown, UnitIsUnit

local function IsSchoolFree()
    return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "NATURE") == 0
end 

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
    StartByPreCast = GetToggle(2, "StartByPreCast")
    TrinketMana = GetToggle(2, "TrinketMana")
	MythicPlusLogic = GetToggle(2, "MythicPlusLogic")
	StopCastOverHeal = GetToggle(2, "StopCastOverHeal")
	StopCastQuake = GetToggle(2, "StopCastQuake")
	StopCastQuakeSec = GetToggle(2, "StopCastQuakeSec")
	GrievousWoundsLogic = GetToggle(2, "GrievousWoundsLogic")
	GrievousWoundsMinStacks = GetToggle(2, "GrievousWoundsMinStacks")
	HealingStreamTotemRefresh = GetToggle(2, "HealingStreamTotemRefresh")
	HealingRainRefresh = GetToggle(2, "HealingRainRefresh")
	AoEON = GetToggle(2, "AoE")
	EarthShieldWorkMode = GetToggle(2, "EarthShieldWorkMode")
    UseSpiritWalkersGrace = GetToggle(2, "UseSpiritWalkersGrace")
	SpiritWalkersGraceTime = GetToggle(2, "SpiritWalkersGraceTime")
	SpiritWalkersCatch = GetToggle(2, "SpiritWalkersGraceTime")
	HealingTideTotemRaidUnits = GetToggle(2, "HealingTideTotemRaidUnits")
	HealingTideTotemPartyUnits = GetToggle(2, "HealingTideTotemPartyUnits")
	HealingTideTotemRaidHP = GetToggle(2, "HealingTideTotemRaidHP")
	HealingTideTotemPartyHP = GetToggle(2, "HealingTideTotemPartyHP")
	ChainHealRaidUnits = GetToggle(2, "ChainHealRaidUnits")
	ChainHealPartyUnits = GetToggle(2, "ChainHealPartyUnits")
	ChainHealRaidHP = GetToggle(2, "ChainHealRaidHP")
	ChainHealPartyHP = GetToggle(2, "ChainHealPartyHP")
	UseGhostWolf = GetToggle(2, "UseGhostWolf")
	GhostWolfTime = GetToggle(2, "GhostWolfTime")
	
end

-- [1] CC AntiFake Rotation
local function AntiFakeStun(unit) 
    return 
    IsUnitEnemy(unit) and 
    Unit(unit):IsControlAble("incapacitate", 0) and 
    A.HexGreen:AbsentImun(unit, Temp.TotalAndPhysAndCC, true)          
end 
A[1] = function(icon)    
    if     A.HexGreen:IsReady(nil, nil, nil, true) and 
    (
        AntiFakeStun("mouseover") or 
        AntiFakeStun("target") or 
        AntiFakeStun("targettarget") or 
        (
            not IsUnitEnemy("mouseover") and 
            not IsUnitEnemy("target") and             
            not IsUnitEnemy("targettarget") 
        )
    )
    then 
        return A.HexGreen:Show(icon)         
    end                                                                     
end

-- [2] Kick AntiFake Rotation
A[2] = function(icon)        
    local unit
    if IsUnitEnemy("mouseover") then 
        unit = "mouseover"
    elseif IsUnitEnemy("target") then 
        unit = "target"
    elseif IsUnitEnemy("targettarget") then 
        unit = "targettarget"
    end 
    
    if unit then         
        local total, sleft, _, _, _, notKickAble = Unit(unit):CastTime()
        if sleft > 0 then                                     
            if A.WindShearAntiFake:IsReady(unit) and A.WindShearAntiFake:AbsentImun(unit, Temp.TotalAndPhysAndCC, true) then
                return A.WindShearAntiFake:Show(icon)                  
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
--                 ROTATION  
-----------------------------------------

local function IsEnoughHPS(unit)
    return Unit(player):GetHPS() > Unit(unit):GetDMG()
end 

local function IsSaveManaPhase()
    if not A.IsInPvP and GetToggle(2, "ManaManagement") and Unit(player):HasBuffs(A.Innervate.ID) == 0 then 
        local bossID
        for i = 1, MAX_BOSS_FRAMES do 
            bossID = "boss" .. i
            if Unit(bossID):IsExists() and not Unit(bossID):IsDead() and Unit(player):PowerPercent() < Unit(bossID):HealthPercent() then 
                return true 
            end 
        end 
    end 
    return Unit(player):PowerPercent() < 20 
end 
IsSaveManaPhase = A.MakeFunctionCachedStatic(IsSaveManaPhase)		

local function HealingRainDuration()
    for i = 1, 5 do
        local active, totemName, startTime, duration, textureId  = GetTotemInfo(i)
        if active == true and textureId == 136037 then
            return startTime + duration - GetTime()
        end
    end
    return 0
end
HealingRainDuration = A.MakeFunctionCachedStatic(HealingRainDuration)

local function HealingStreamTotemDuration()
    for i = 1, 5 do
        local active, totemName, startTime, duration, textureId  = GetTotemInfo(i)
        if active == true and textureId == 5394 then
            return startTime + duration - GetTime()
        end
    end
    return 0
end
HealingStreamTotemDuration = A.MakeFunctionCachedStatic(HealingStreamTotemDuration)

local function CloudburstTotemDuration()
    for i = 1, 5 do
        local active, totemName, startTime, duration, textureId  = GetTotemInfo(i)
        if active == true and textureId == 157153 then
            return startTime + duration - GetTime()
        end
    end
    return 0
end
CloudburstTotemDuration = A.MakeFunctionCachedStatic(CloudburstTotemDuration)

-- Cached parts 
-- PvP: Balance Solar Interrupt 
UnitCooldown:Register("arena", 78675, 60) 
-- PvP: Mage Counterspell
UnitCooldown:Register("arena", 2139, 24)
-- SpiritWalkersGrace with AncestralGift talent to give player silence and interrupt immunities
local function CanSpiritWalkersGrace(mode)
    if A.IsInPvP and A.SpiritWalkersGrace:IsReady("player") and Unit(player):HasBuffs(A.SpiritWalkersGrace.ID, true) == 0 and A.AncestralGift:IsSpellLearned() then 
        -- If melee is around (doesn't tracking their kick but anyway)
        if not mode and EnemyTeam("DAMAGER_MELEE"):GetUnitID(15) ~= "none" then 
            return true 
        end 
        
        -- Catch Balance Interrupt if enemy in burst or while rooted
        if UnitCooldown:GetCooldown("arena", 78675) == 0 then 
            local UnitBalance = EnemyTeam("DAMAGER_RANGE"):GetUnitID(40, 102)         
            if UnitBalance ~= "none" and Unit(UnitBalance):InCC() == 0 and Unit(player):HasBuffs("Reflect") == 0 then
                -- If rooted 
                if mode == "CATCH" and LoC:Get("ROOT") > 0 then 
                    return true   
                end 
                -- If bursting 
                if not mode and (EnemyTeam("DAMAGER"):GetBuffs("DamageBuffs", 40) > 0 or FriendlyTeam():GetTTD(1, 8)) then 
                    return true 
                end 
            end 
        end 
        
        -- Catch Mage Interrupt if enemy in burst or through Blink / Shrimmer 
        if not mode and UnitCooldown:GetCooldown("arena", 2139) == 0 then 
            local UnitMage = EnemyTeam("DAMAGER_RANGE"):GetUnitID(60, {62, 63, 64})
            if UnitMage ~= "none" and Unit(UnitMage):InCC() == 0 and Unit(player):HasBuffs("Reflect") == 0 then
                -- If Blink / Shrimmer  
                if Unit(UnitMage):GetRange() > 40 and Unit(UnitMage):GetBlinkOrShrimmer() <= 1.5 then 
                    return true   
                end 
                -- If bursting 
                if EnemyTeam("DAMAGER"):GetBuffs("DamageBuffs", 40) > 0 or FriendlyTeam():GetTTD(1, 8) then 
                    return true 
                end 
            end 
        end 
    end 
    return false 
end 
CanSpiritWalkersGrace = A.MakeFunctionCachedDynamic(CanSpiritWalkersGrace)

local function SelfDefensives()
    if Unit(player):CombatTime() == 0 then 
        return 
    end 
        
    -- Abyssal Healing Potion
    local AbyssalHealingPotion = A.GetToggle(2, "AbyssalHealingPotionHP")
    if     AbyssalHealingPotion >= 0 and A.AbyssalHealingPotion:IsReady("player") and 
    (
        (     -- Auto 
            AbyssalHealingPotion >= 100 and 
            (
                -- HP lose per sec >= 25
                Unit("player"):GetDMG() * 100 / Unit("player"):HealthMax() >= 25 or 
                Unit("player"):GetRealTimeDMG() >= Unit("player"):HealthMax() * 0.25 or 
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
            AbyssalHealingPotion < 100 and 
            Unit("player"):HealthPercent() <= AbyssalHealingPotion
        )
    ) 
    then 
        return A.AbyssalHealingPotion
    end  
    
    -- AstralShift
    local AstralShift = A.GetToggle(2, "AstralShiftHP")
    if     AstralShift >= 0 and A.AstralShift:IsReady("player") and 
    (
        (     -- Auto 
            AstralShift >= 100 and 
            (
                -- HP lose per sec >= 20
                Unit("player"):GetDMG() * 100 / Unit("player"):HealthMax() >= 20 or 
                Unit("player"):GetRealTimeDMG() >= Unit("player"):HealthMax() * 0.20 or 
                -- TTD 
                Unit("player"):TimeToDieX(15) < 3 or 
                (
                    A.IsInPvP and 
                    (
                        Unit("player"):UseDeff() or 
                        (
                            Unit("player", 5):HasFlags() and 
                            Unit("player"):GetRealTimeDMG() > 0 and 
                            Unit("player"):IsFocused() 
                        ) or
						Unit(player):IsExecuted()
                    )
                )
            ) and 
            Unit("player"):HasBuffs("DeffBuffs", true) == 0
        ) or 
        (    -- Custom
            AstralShift < 100 and 
            Unit("player"):HealthPercent() <= AstralShift
        )
    ) 
    then 
        return A.AstralShift
    end   
	
    -- Stoneform on self dispel (only PvE)
    if A.Stoneform:IsRacialReady("player", true) and not A.IsInPvP and A.AuraIsValid("player", "UseDispel", "Dispel") then 
        return A.Stoneform
    end 
end 

-- Non GCD spell check
local function countInterruptGCD(unit)
    if not A.WindShear:IsReadyByPassCastGCD(unit) or not A.WindShear:AbsentImun(unit, Temp.TotalAndMagKick) then
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
	    -- WindShear
        if useKick and A.WindShear:IsReady(unit) then 
	        -- Notification					
            Action.SendNotification("Wind Shear interrupting on " .. unit, A.WindShear.ID)
            return A.WindShear
        end 
	
        -- CapacitorTotem
        if useCC and Action.GetToggle(2, "UseCapacitorTotem") and A.WindShear:GetCooldown() > 0 and A.CapacitorTotem:IsReady(player) then 
			-- Notification					
            Action.SendNotification("Capacitor Totem interrupting", A.CapacitorTotem.ID)
            return A.CapacitorTotem
        end  
    
        -- Hex	
        if useCC and A.Hex:IsReady(unit) and A.Hex:AbsentImun(unit, Temp.TotalAndCC, true) and Unit(unit):IsControlAble("incapacitate", 0) then 
	        -- Notification					
            Action.SendNotification("Hex interrupting", A.Hex.ID)
            return A.Hex              
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
Interrupts = A.MakeFunctionCachedDynamic(Interrupts)

local function CanHealingStreamTotem()
    if A.HealingStreamTotem:IsReady(unit, true, nil, nil) and IsSchoolFree() then 
        local HealingStreamTotemHP = GetToggle(2, "HealingStreamTotemHP")
        local HealingStreamTotemUnits = GetToggle(2, "HealingStreamTotemUnits") 
        
        -- Auto Counter
        if HealingStreamTotemUnits >= 5 then 
            HealingStreamTotemUnits = HealingEngineGetMinimumUnits(1)
            -- Reduce size in raid by 35%
            if HealingStreamTotemUnits > 5 then 
                HealingStreamTotemUnits = HealingStreamTotemUnits - (#HealingEngineMembersALL * 0.35)
            end 
            -- If user typed counter higher than max available members 
        elseif HealingStreamTotemUnits >= TeamCacheFriendly.Size then 
            HealingStreamTotemUnits = TeamCacheFriendly.Size
        end 
        
        if HealingStreamTotemUnits < 3 and not A.IsInPvP then 
            return false 
        end 
        
        local counter = 0 
        for i = 1, #HealingEngineMembersALL do 
            -- Auto HP 
            if HealingStreamTotemHP >= 100 and A.HealingStreamTotem:PredictHeal(HealingEngineMembersALL[i].Unit, 1500) then 
                counter = counter + 1
            end 
            
            -- Custom HP 
            if HealingStreamTotemHP < 100 and HealingEngineMembersALL[i].HP <= HealingStreamTotemHP then 
                counter = counter + 1
            end 
            
            if counter >= HealingStreamTotemUnits then 
                return true 
            end 
        end 
    end 
    return false 
end 
CanHealingStreamTotem = A.MakeFunctionCachedStatic(CanHealingStreamTotem)

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
        if Unit(player):Role(ROLE) then  
            lastDMG = Unit(player):GetLastTimeDMGX(x)
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
            lastDMG = lastDMG + Unit(player):GetLastTimeDMGX(x)  
            members = members + 1
        end 
    end      
    
    if lastDMG == 0 and members == 0 then 
        return 0, lastDMG, members
    else 
        return lastDMG / members, lastDMG, members
    end 
end

local function noDamageCheck(unit)
    if isChecked("Dont DPS spotter") and GetObjectID(unit) == 135263 then
        return true
    end
    if isCC(unit) then
        return true
    end
    if isCasting(302415, unit) then
        -- emmisary teleporting home
        return true
    end

    if hasBuff(263246, unit) then
        -- shields on first boss in temple
        return true
    end
    if hasBuff(260189, unit) then
        -- shields on last boss in MOTHERLODE
        return true
    end
    if hasBuff(261264, unit) or hasBuff(261265, unit) or hasBuff(261266, unit) then
        -- shields on witches in wm
        return true
    end

    if GetObjectID(thisUnit) == 155432 then
        --emmisaries to punt, dealt with seperately
        return true
    end
    return false --catchall
end
noDamageCheck = Action.MakeFunctionCachedDynamic(noDamageCheck)

local StunsBlackList = {
    -- Atal'Dazar
    [87318] = "Dazar'ai Colossus",
    [122984] = "Dazar'ai Colossus",
    [128455] = "T'lonja",
    [129553] = "Dinomancer Kish'o",
    [129552] = "Monzumi",
    -- Freehold
    [129602] = "Irontide Enforcer",
    [130400] = "Irontide Crusher",
    -- King's Rest
    [133935] = "Animated Guardian",
    [134174] = "Shadow-Borne Witch Doctor",
    [134158] = "Shadow-Borne Champion",
    [137474] = "King Timalji",
    [137478] = "Queen Wasi",
    [137486] = "Queen Patlaa",
    [137487] = "Skeletal Hunting Raptor",
    [134251] = "Seneschal M'bara",
    [134331] = "King Rahu'ai",
    [137484] = "King A'akul",
    [134739] = "Purification Construct",
    [137969] = "Interment Construct",
    [135231] = "Spectral Brute",
    [138489] = "Shadow of Zul",
    -- Shrine of the Storm
    [134144] = "Living Current",
    [136214] = "Windspeaker Heldis",
    [134150] = "Runecarver Sorn",
    [136249] = "Guardian Elemental",
    [134417] = "Deepsea Ritualist",
    [136353] = "Colossal Tentacle",
    [136295] = "Sunken Denizen",
    [136297] = "Forgotten Denizen",
    -- Siege of Boralus
    [129369] = "Irontide Raider",
    [129373] = "Dockhound Packmaster",
    [128969] = "Ashvane Commander",
    [138255] = "Ashvane Spotter",
    [138465] = "Ashvane Cannoneer",
    [135245] = "Bilge Rat Demolisher",
    -- Temple of Sethraliss
    [134991] = "Sandfury Stonefist",
    [139422] = "Scaled Krolusk Tamer",
    [136076] = "Agitated Nimbus",
    [134691] = "Static-charged Dervish",
    [139110] = "Spark Channeler",
    [136250] = "Hoodoo Hexer",
    [139946] = "Heart Guardian",
    -- MOTHERLODE!!
    [130485] = "Mechanized Peacekeeper",
    [136139] = "Mechanized Peacekeeper",
    [136643] = "Azerite Extractor",
    [134012] = "Taskmaster Askari",
    [133430] = "Venture Co. Mastermind",
    [133463] = "Venture Co. War Machine",
    [133436] = "Venture Co. Skyscorcher",
    [133482] = "Crawler Mine",
    -- Underrot
    [131436] = "Chosen Blood Matron",
    [133912] = "Bloodsworn Defiler",
    [138281] = "Faceless Corruptor",
    -- Tol Dagor
    [130025] = "Irontide Thug",
    -- Waycrest Manor
    [131677] = "Heartsbane Runeweaver",
    [135329] = "Matron Bryndle",
    [131812] = "Heartsbane Soulcharmer",
    [131670] = "Heartsbane Vinetwister",
    [135365] = "Matron Alma",
}

local precast_spell_list = {
    --spell_id	, precast_time	,	spell_name
    { 214652, 5, 'Acidic Fragments' },
    { 205862, 5, 'Slam' },
    { 259832, 1.5, 'Massive Glaive - Stormbound Conqueror (Warport Wastari, Zuldazar, for testing purpose only)' },
    { 218774, 5, 'Summon Plasma Spheres' },
    { 206949, 5, 'Frigid Nova' },
    { 206517, 5, 'Fel Nova' },
    { 207720, 5, 'Witness the Void' },
    { 206219, 5, 'Liquid Hellfire' },
    { 211439, 5, 'Will of the Demon Within' },
    { 209270, 5, 'Eye of Guldan' },
    { 227071, 5, 'Flame Crash' },
    { 233279, 5, 'Shattering Star' },
    { 233441, 5, 'Bone Saw' },
    { 235230, 5, 'Fel Squall' },
    { 231854, 5, 'Unchecked Rage' },
    { 232174, 5, 'Frosty Discharge' },
    { 230139, 5, 'Hydra Shot' },
    { 233264, 5, 'Embrace of the Eclipse' },
    { 236542, 5, 'Sundering Doom' },
    { 236544, 5, 'Doomed Sundering' },
    { 235059, 5, 'Rupturing Singularity' },
    { 288693, 3, 'Tormented Soul - Grave Bolt (Reaping affix)' },
    { 262347, 5, 'Static Pulse' },
    { 302420, 5, 'Queen\'s Decree: Hide' },
    { 260333, 7, 'Tantrum - Underrot 2nd boss' },
    { 255577, 5, 'Transfusion' }, -- https://www.wowhead.com/spell=255577/transfusion
    { 259732, 5, 'Festering Harvest' }, --https://www.wowhead.com/spell=259732/festering-harvest
    { 285388, 5, 'Vent Jets' }, --https://www.wowhead.com/spell=285388/vent-jets
    { 291626, 3, 'Cutting Beam' }, --https://www.wowhead.com/spell=291626/cutting-beam
    { 300207, 3, 'shock-coil' }, -- https://www.wowhead.com/spell=300207/shock-coil
    { 297261, 5, 'rumble' }, -- https://www.wowhead.com/spell=297261/rumble
    { 262347, 5, 'pulse' }, --https://www.wowhead.com/spell=262347/static-pulse
}
--end of dbm list

local DebuffSniperList = {

    --junkyard
    { spellID = 298669, stacks = 0, secs = 1 }, -- Taze
    -- Uldir
    { spellID = 262313, stacks = 0, secs = 5 }, -- Malodorous Miasma
    { spellID = 262314, stacks = 0, secs = 3 }, -- Putrid Paroxysm
    { spellID = 264382, stacks = 0, secs = 1 }, -- Eye Beam
    { spellID = 264210, stacks = 0, secs = 5 }, -- Jagged Mandible
    { spellID = 265360, stacks = 0, secs = 5 }, -- Roiling Deceit
    { spellID = 265129, stacks = 0, secs = 5 }, -- Omega Vector
    { spellID = 266948, stacks = 0, secs = 5 }, -- Plague Bomb
    { spellID = 274358, stacks = 0, secs = 5 }, -- Rupturing Blood
    { spellID = 274019, stacks = 0, secs = 1 }, -- Mind Flay
    { spellID = 272018, stacks = 0, secs = 1 }, -- Absorbed in Darkness
    { spellID = 273359, stacks = 0, secs = 5 }, -- Shadow Barrage
    -- Freehold
    { spellID = 257437, stacks = 0, secs = 5 }, -- Poisoning Strike
    { spellID = 267523, stacks = 0, secs = 5 }, -- Cutting Surge
    { spellID = 256363, stacks = 0, secs = 5 }, -- Ripper Punch
    -- Shrine of the Storm
    { spellID = 264526, stacks = 0, secs = 5 }, -- Grasp from the Depths
    { spellID = 264166, stacks = 0, secs = 1 }, -- Undertow
    { spellID = 268214, stacks = 0, secs = 1 }, -- Carve Flesh
    { spellID = 276297, stacks = 0, secs = 5 }, -- Void Seed
    { spellID = 268322, stacks = 0, secs = 5 }, -- Touch of the Drowned
    -- Siege of Boralus
    { spellID = 256897, stacks = 0, secs = 5 }, -- Clamping Jaws
    { spellID = 273470, stacks = 0, secs = 3 }, -- Gut Shot
    { spellID = 275014, stacks = 0, secs = 5 }, -- Putrid Waters
    -- Tol Dagor
    { spellID = 258058, stacks = 0, secs = 1 }, -- Squeeze
    { spellID = 260016, stacks = 0, secs = 3 }, -- Itchy Bite
    { spellID = 260067, stacks = 0, secs = 5 }, -- Vicious Mauling
    { spellID = 258864, stacks = 0, secs = 5 }, -- Suppression Fire
    { spellID = 258917, stacks = 0, secs = 3 }, -- Righteous Flames
    { spellID = 256198, stacks = 0, secs = 5 }, -- Azerite Rounds: Incendiary
    { spellID = 256105, stacks = 0, secs = 1 }, -- Explosive Burst
    -- Waycrest Manor
    { spellID = 266035, stacks = 0, secs = 1 }, -- Bone Splinter
    { spellID = 260703, stacks = 0, secs = 1 }, -- Unstable Runic Mark
    { spellID = 260741, stacks = 0, secs = 1 }, -- Jagged Nettles
    { spellID = 264050, stacks = 0, secs = 3 }, -- Infected Thorn
    { spellID = 264556, stacks = 0, secs = 2 }, -- Tearing Strike
    { spellID = 264150, stacks = 0, secs = 1 }, -- Shatter
    { spellID = 265761, stacks = 0, secs = 1 }, -- Thorned Barrage
    { spellID = 263905, stacks = 0, secs = 1 }, -- Marking Cleave
    { spellID = 264153, stacks = 0, secs = 3 }, -- Spit
    { spellID = 278456, stacks = 0, secs = 3 }, -- Infest
    { spellID = 271178, stacks = 0, secs = 3 }, -- Ravaging Leap
    { spellID = 265880, stacks = 0, secs = 1 }, -- Dread Mark
    { spellID = 265882, stacks = 0, secs = 1 }, -- Lingering Dread
    { spellID = 264378, stacks = 0, secs = 5 }, -- Fragment Soul
    { spellID = 261438, stacks = 0, secs = 1 }, -- Wasting Strike
    { spellID = 261440, stacks = 0, secs = 1 }, -- Virulent Pathogen
    { spellID = 268202, stacks = 0, secs = 1 }, -- Death Lens
    -- Atal'Dazar
    { spellID = 253562, stacks = 0, secs = 3 }, -- Wildfire
    { spellID = 254959, stacks = 0, secs = 2 }, -- Soulburn
    { spellID = 255558, stacks = 0, secs = 5 }, -- Tainted Blood
    { spellID = 255814, stacks = 0, secs = 5 }, -- Rending Maul
    { spellID = 250372, stacks = 0, secs = 5 }, -- Lingering Nausea
    { spellID = 250096, stacks = 0, secs = 1 }, -- Wracking Pain
    { spellID = 256577, stacks = 0, secs = 5 }, -- Soulfeast
    -- King's Rest
    { spellID = 269932, stacks = 0, secs = 3 }, -- Gust Slash
    { spellID = 265773, stacks = 0, secs = 4 }, -- Spit Gold
    { spellID = 270084, stacks = 0, secs = 3 }, -- Axe Barrage
    { spellID = 270865, stacks = 0, secs = 3 }, -- Hidden Blade
    { spellID = 270289, stacks = 0, secs = 3 }, -- Purification Beam
    { spellID = 271564, stacks = 0, secs = 3 }, -- Embalming
    { spellID = 267618, stacks = 0, secs = 3 }, -- Drain Fluids
    { spellID = 270487, stacks = 0, secs = 3 }, -- Severing Blade
    { spellID = 270507, stacks = 0, secs = 5 }, -- Poison Barrage
    { spellID = 266231, stacks = 0, secs = 3 }, -- Severing Axe
    { spellID = 267273, stacks = 0, secs = 3 }, -- Poison Nova
    { spellID = 268419, stacks = 0, secs = 3 }, -- Gale Slash
    -- MOTHERLODE!!
    { spellID = 269298, stacks = 0, secs = 1 }, -- Widowmaker
    { spellID = 262347, stacks = 0, secs = 1 }, -- Static Pulse
    { spellID = 263074, stacks = 0, secs = 3 }, -- Festering Bite
    { spellID = 262270, stacks = 0, secs = 1 }, -- Caustic Compound
    { spellID = 262794, stacks = 0, secs = 1 }, -- Energy Lash
    { spellID = 259853, stacks = 0, secs = 3 }, -- Chemical Burn
    { spellID = 269092, stacks = 0, secs = 1 }, -- Artillery Barrage
    { spellID = 262348, stacks = 0, secs = 1 }, -- Mine Blast
    { spellID = 260838, stacks = 0, secs = 1 }, -- Homing Missile
    -- Temple of Sethraliss
    { spellID = 263371, stacks = 0, secs = 1 }, -- Conduction
    { spellID = 272657, stacks = 0, secs = 3 }, -- Noxious Breath
    { spellID = 267027, stacks = 0, secs = 1 }, -- Cytotoxin
    { spellID = 272699, stacks = 0, secs = 3 }, -- Venomous Spit
    { spellID = 268013, stacks = 0, secs = 5 }, -- Flame Shock
    -- Underrot
    { spellID = 265019, stacks = 0, secs = 1 }, -- Savage Cleave
    { spellID = 265568, stacks = 0, secs = 1 }, -- Dark Omen
    { spellID = 260685, stacks = 0, secs = 5 }, -- Taint of G'huun
    { spellID = 278961, stacks = 0, secs = 5 }, -- Decaying Mind
    { spellID = 260455, stacks = 0, secs = 1 }, -- Serrated Fangs
    { spellID = 273226, stacks = 0, secs = 1 }, -- Decaying Spores
    { spellID = 269301, stacks = 0, secs = 5 }, -- Putrid Blood
    -- all
    { spellID = 302421, stacks = 0, secs = 5 }, -- Queen's Decree
}

local NeedSnipe = false
local function SetFriendlyToSnipe()
    local getmembersAll = A.HealingEngine.GetMembersAll()
    for i = 1, #getmembersAll do
        if Unit(getmembersAll[i].Unit):GetRange() <= 40 then
            for k, v in pairs(DebuffSniperList) do
                if Unit(getmembersAll[i].Unit):HasDeBuffs(v.spellID, true) > v.secs and 
				    --Unit(getmembersAll[i].Unit):HasDeBuffsStacks(v.spellID, true) >= v.stacks and 
				    Unit(getmembersAll[i].Unit):HasBuffs(A.Rejuvenation.ID, player, true) > 0 and
					-- Germination
					(
					    A.Germination:IsSpellLearned() and 
						Unit(getmembersAll[i].Unit):HasBuffs(A.RejuvenationGermimation.ID, player, true) > 0 
						or 
						not A.Germination:IsSpellLearned()
					)					
				then
					-- Notification					
                    Action.SendNotification("Healing snipe on " .. UnitName(getmembersAll[i].Unit), A.Regrowth.ID)
	    			-- Global var
					NeedSnipe = true
					-- Force target
                    A.HealingEngine.SetTarget(getmembersAll[i].Unit)
                end
            end
        end
	end
end
SetFriendlyToSnipe = Action.MakeFunctionCachedDynamic(SetFriendlyToSnipe)

local pre_hot_list = {   --snipe list
    --Battle of Dazar'alor
    [283572] = { targeted = true }, --"Sacred Blade"
    [284578] = { targeted = true }, --"Penance"
    [286988] = { targeted = true }, --Divine Burst"
    [282036] = { targeted = true }, --"Fireball"
    [282182] = { targeted = false }, --"Buster Cannon"
    --Uldir
    [279669] = { targeted = false }, --"Bacterial Outbreak"
    [279660] = { targeted = false }, --"Endemic Virus"
    [274262] = { targeted = false }, --"Explosive Corruption"
    --Reaping
    [288693] = { targeted = true }, --"Grave Bolt",
    --Atal'Dazar
    [250096] = { targeted = true }, --"Wracking Pain"
    [253562] = { targeted = true }, --"Wildfire"
    [252781] = { targeted = true }, --"Unstable Hex"
    [252923] = { targeted = true }, --"Venom Blast"
    [253239] = { targeted = true }, -- Dazarai Juggernaut - Merciless Assault },
    [256846] = { targeted = true }, --'Dinomancer Kisho - Deadeye Aim'},
    [257407] = { targeted = true }, -- Rezan - Pursuit},
    --Kings Rest
    [267618] = { targeted = true }, --"Drain Fluids"
    [267308] = { targeted = true }, --"Lighting Bolt"
    [270493] = { targeted = true }, --"Spectral Bolt"
    [269973] = { targeted = true }, --"Deathly Chill"
    [270923] = { targeted = true }, --"Shadow Bolt"
    [272388] = { targeted = true }, --"Shadow Barrage"
    [266231] = { targeted = true }, -- Kula the Butcher - Severing Axe},
    [270507] = { targeted = true }, --  Spectral Beastmaster - Poison Barrage},
    [265773] = { targeted = true }, -- The Golden Serpent - Spit Gold},
    [270506] = { targeted = true }, -- Spectral Beastmaster - Deadeye Shot},
    [265773] = { targeted = true }, -- https://www.wowhead.com/spell=270487/severing-blade
    [268586] = { targeted = true }, -- https://www.wowhead.com/spell=268586/blade-combo
    --Free Hold
    [259092] = { targeted = true }, --"Lightning Bolt"
    [281420] = { targeted = true }, --"Water Bolt"
    [257267] = { targeted = false }, --"Swiftwind Saber"
    [257739] = { targeted = true }, -- Blacktooth Scrapper - Blind Rage},
    [258338] = { targeted = true }, -- Captain Raoul - Blackout Barrel},
    [256979] = { targeted = true }, -- Captain Eudora - Powder Shot},
    --Siege of Boralus
    [272588] = { targeted = true }, --"Rotting Wounds"
    [272827] = { targeted = false }, --"Viscous Slobber"
    [272581] = { targeted = true }, -- "Water Spray"
    [257883] = { targeted = false }, -- "Break Water"
    [257063] = { targeted = true }, --"Brackish Bolt"
    [272571] = { targeted = true }, --"Choking Waters"
    [257641] = { targeted = true }, -- Kul Tiran Marksman - Molten Slug},
    [272874] = { targeted = true }, -- Ashvane Commander - Trample},
    [272581] = { targeted = true }, -- Bilge Rat Tempest - Water Spray},
    [272528] = { targeted = true }, -- Ashvane Sniper - Shoot},
    [272542] = { targeted = true }, -- Ashvane Sniper - Ricochet},
    -- Temple of Sethraliss
    [263775] = { targeted = true }, --"Gust"
    [268061] = { targeted = true }, --"Chain Lightning"
    [272820] = { targeted = true }, --"Shock"
    [263365] = { targeted = true }, --"https://www.wowhead.com/spell=263365/a-peal-of-thunder"
    [268013] = { targeted = true }, --"Flame Shock"
    [274642] = { targeted = true }, --"Lava Burst"
    [268703] = { targeted = true }, --"Lightning Bolt"
    [272699] = { targeted = true }, --"Venomous Spit"
    [268703] = { targeted = true }, -- Charged Dust Devil - Lightning Bolt},
    [272670] = { targeted = true }, -- Sandswept Marksman - Shoot},
    [267278] = { targeted = true }, -- Static-charged Dervish - Electrocute},
    [272820] = { targeted = true }, -- Spark Channeler - Shock},
    [274642] = { targeted = true }, -- Hoodoo Hexer - Lava Burst},
    [268061] = { targeted = true }, -- Plague Doctor - Chain Lightning},
    --Shrine of the Storm
    [265001] = { targeted = true }, --"Sea Blast"
    [268347] = { targeted = true }, --"Void Bolt"
    [267969] = { targeted = true }, --"Water Blast"
    [268233] = { targeted = true }, --"Electrifying Shock"
    [268315] = { targeted = true }, --"Lash"
    [268177] = { targeted = true }, --"Windblast"
    [268273] = { targeted = true }, --"Deep Smash"
    [268317] = { targeted = true }, --"Rip Mind"
    [265001] = { targeted = true }, --"Sea Blast"
    [274703] = { targeted = true }, --"Void Bolt"
    [268214] = { targeted = true }, --"Carve Flesh"
    [264166] = { targeted = true }, -- Aqusirr - Undertow},
    [268214] = { targeted = true }, -- Runecarver Sorn - Carve Flesh},
    --Motherlode
    [259856] = { targeted = true }, --"Chemical Burn"
    [260318] = { targeted = true }, --"Alpha Cannon"
    [262794] = { targeted = true }, --"Energy Lash"
    [263202] = { targeted = true }, --"Rock Lance"
    [262268] = { targeted = true }, --"Caustic Compound"
    [263262] = { targeted = true }, --"Shale Spit"
    [263628] = { targeted = true }, --"Charged Claw"
    [268185] = { targeted = true }, -- Refreshment Vendor, Iced Spritzer},
    [258674] = { targeted = true }, -- Off-Duty Laborer - Throw Wrench},
    [276304] = { targeted = true }, -- Rowdy Reveler - Penny For Your Thoughts},
    [263209] = { targeted = true }, -- Mine Rat - Throw Rock},
    [263202] = { targeted = true }, -- Venture Co. Earthshaper - Rock Lance},
    [262794] = { targeted = true }, -- Venture Co. Mastermind - Energy Lash},
    [260669] = { targeted = true }, -- Rixxa Fluxflame - Propellant Blast},
    [271456] = { targeted = true }, -- https://www.wowhead.com/spell=271456/drill-smash},
    --Underrot
    [260879] = { targeted = true }, --"Blood Bolt"
    [265084] = { targeted = true }, --"Blood Bolt"
    [259732] = { targeted = false }, --"Festering Harvest"
    [266209] = { targeted = false }, --"Wicked Frenzy"
    [265376] = { targeted = true }, -- Fanatical Headhunter - Barbed Spear},
    [265625] = { targeted = true }, -- Befouled Spirit - Dark Omen},
    --Tol Dagor
    [257777] = { targeted = true }, --"Crippling Shiv"
    [258150] = { targeted = true }, --"Salt Blast"
    [258869] = { targeted = true }, --"Blaze"
    [256039] = { targeted = true }, -- Overseer Korgus - Deadeye},
    [185857] = { targeted = true }, -- Ashvane Spotter - Shoot},

    --work shop_
    [294195] = { targeted = true }, --https://www.wowhead.com/spell=294195/arcing-zap
    [293827] = { targeted = true }, --https://www.wowhead.com/spell=293827/giga-wallop
    [292264] = { targeted = true }, -- https://www.wowhead.com/spell=292264/giga-zap
    --junk yard
    [300650] = { targeted = true }, --https://www.wowhead.com/spell=300650/suffocating-smog
    [299438] = { targeted = true }, --https://www.wowhead.com/spell=299438/sledgehammer
    [300188] = { targeted = true }, -- https://www.wowhead.com/spell=300188/scrap-cannon#used-by-npc
    [302682] = { targeted = true }, --https://www.wowhead.com/spell=302682/mega-taze

    --Waycrest Manor
    [260701] = { targeted = true }, --"Bramble Bolt"
    [260700] = { targeted = true }, --"Ruinous Bolt"
    [260699] = { targeted = true }, --"Soul Bolt"
    [261438] = { targeted = true }, --"Wasting Strike"
    [266225] = { targeted = true }, --Darkened Lightning"
    [273653] = { targeted = true }, --"Shadow Claw"
    [265881] = { targeted = true }, --"Decaying Touch"
    [264153] = { targeted = true }, --"Spit"
    [278444] = { targeted = true }, --"Infest"
    [167385] = { targeted = true }, --"Infest"
    [263891] = { targeted = true }, -- Heartsbane Vinetwister - Grasping Thorns},
    [264510] = { targeted = true }, -- Crazed Marksman - Shoot},
    [260699] = { targeted = true }, -- Coven Diviner - Soul Bolt},
    [260551] = { targeted = true }, -- Soulbound Goliath - Soul Thorns},
    [260741] = { targeted = true }, -- Heartsbane Triad - Jagged Nettles},
    [268202] = { targeted = true } -- Gorak Tul - Death Lens},
}
local CC_CreatureTypeList = { "Beast", "Dragonkin" }
local StunsBlackList = {
    -- Atal'Dazar
    [87318] = "Dazar'ai Colossus",
    [122984] = "Dazar'ai Colossus",
    [128455] = "T'lonja",
    [129553] = "Dinomancer Kish'o",
    [129552] = "Monzumi",
    -- Freehold
    [129602] = "Irontide Enforcer",
    [130400] = "Irontide Crusher",
    -- King's Rest
    [133935] = "Animated Guardian",
    [134174] = "Shadow-Borne Witch Doctor",
    [134158] = "Shadow-Borne Champion",
    [137474] = "King Timalji",
    [137478] = "Queen Wasi",
    [137486] = "Queen Patlaa",
    [137487] = "Skeletal Hunting Raptor",
    [134251] = "Seneschal M'bara",
    [134331] = "King Rahu'ai",
    [137484] = "King A'akul",
    [134739] = "Purification Construct",
    [137969] = "Interment Construct",
    [135231] = "Spectral Brute",
    [138489] = "Shadow of Zul",
    -- Shrine of the Storm
    [134144] = "Living Current",
    [136214] = "Windspeaker Heldis",
    [134150] = "Runecarver Sorn",
    [136249] = "Guardian Elemental",
    [134417] = "Deepsea Ritualist",
    [136353] = "Colossal Tentacle",
    [136295] = "Sunken Denizen",
    [136297] = "Forgotten Denizen",
    -- Siege of Boralus
    [129369] = "Irontide Raider",
    [129373] = "Dockhound Packmaster",
    [128969] = "Ashvane Commander",
    [138255] = "Ashvane Spotter",
    [138465] = "Ashvane Cannoneer",
    [135245] = "Bilge Rat Demolisher",
    -- Temple of Sethraliss
    [134991] = "Sandfury Stonefist",
    [139422] = "Scaled Krolusk Tamer",
    [136076] = "Agitated Nimbus",
    [134691] = "Static-charged Dervish",
    [139110] = "Spark Channeler",
    [136250] = "Hoodoo Hexer",
    [139946] = "Heart Guardian",
    -- MOTHERLODE!!
    [130485] = "Mechanized Peacekeeper",
    [136139] = "Mechanized Peacekeeper",
    [136643] = "Azerite Extractor",
    [134012] = "Taskmaster Askari",
    [133430] = "Venture Co. Mastermind",
    [133463] = "Venture Co. War Machine",
    [133436] = "Venture Co. Skyscorcher",
    [133482] = "Crawler Mine",
    -- Underrot
    [131436] = "Chosen Blood Matron",
    [133912] = "Bloodsworn Defiler",
    [138281] = "Faceless Corruptor",
    -- Tol Dagor
    [130025] = "Irontide Thug",
    -- Waycrest Manor
    [131677] = "Heartsbane Runeweaver",
    [135329] = "Matron Bryndle",
    [131812] = "Heartsbane Soulcharmer",
    [131670] = "Heartsbane Vinetwister",
    [135365] = "Matron Alma",
    --mini bosses
    [161241] = "Voidweaver Mal'thir",
}

local DispelSpell = {
    -- DeBuffs Poison and Disease
    ["Slow"] = {
        3408, -- Crippling Poison
        58180, -- Infected Wounds
        197091, -- Neurotoxin
        -- 55095б -- Frost DK dot (no reason spend gcd for that)
    },
}

local function Dispel(unit)    
    return 
    (
        -- SELF 
        (
            UnitIsUnit(unit, player) and 
            (
                (          
                    A.PurifySpirit:IsReady(unit) and 
                    A.LastPlayerCastID ~= A.PurifySpirit.ID
                )
            ) and 
            Unit(unit):HasDeBuffs(DispelSpell["Slow"], true) > 2 and 
            Unit(unit):GetCurrentSpeed() > 0 and
            Unit(unit):GetCurrentSpeed() < 100 
        ) or 
        -- PvE: ANOTHER UNIT   
        (
            -- Useable conditions
            not A.IsInPvP and
            Unit(unit):IsExists() and
            --not UnitIsUnit(unit, player) and 
            Unit(unit):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone
            AuraIsValid(unit, "UseDispel", "Dispel")            
        ) or
        -- PvP: ANOTHER UNIT   
        (
            -- Useable conditions
            A.IsInPvP and
            Unit(unit):IsExists() and
            --not UnitIsUnit(unit, player) and 
            Unit(unit):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone
            (
                (
                    A.PurifySpirit:IsReady(unit) and 
                    A.LastPlayerCastID ~= A.PurifySpirit.ID and
                    A.PurifySpirit:IsInRange(unit)
                )
            ) and 
            -- Dispel types 
            (
                -- Poison CC 
                Unit(unit):HasDeBuffs("Curse") > 2 or
                (
                    (
                        Unit(unit):HasDeBuffs("Magic") > 2 or 
                        -- Magic Rooted (if not available Tremor)
                        (                            
                            (
                                not A.TremorTotem:IsReady(player) -- Tremor
                            ) and 
                            select(2, UnitClass(unit)) ~= "DRUID" and
                            Unit(unit):HasDeBuffs("MagicRooted") > 3 and 
                            Unit(unit):IsMelee() and
                            Unit(unit):GetRealTimeDMG() <= Unit(unit):HealthMax() * 0.1 
                        )
                    )
                )
            )
        )
    ) and
    -- Check another CC types     
    Unit(unit):HasDeBuffs("Physical") <= GetCurrentGCD() and 
    -- Hex
    Unit(unit):HasDeBuffs(51514, true) <= GetCurrentGCD()
end

-- Custom RSham Offensive Dispell handler
local function ShouldPurge(unit)
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
        "Magic"
    }
    
    for i = 1, 40 do
        for x = 1, #dispelTypes do
            local name, rank, icon, count, buffType = UnitBuff(unit, i) 
            if buffType == dispelTypes[x] then
                for i = 1, #blacklist do
                    if Unit(unit):HasBuffs(blacklist[i], true) then
                        return false
                    end
                end
                return true
            end
        end
    end
    return false
end
ShouldPurge = A.MakeFunctionCachedDynamic(ShouldPurge)

-- Return total active Beacon of Light Buff for player only
local function ActiveEarthShield()
    return HealingEngine.GetBuffsCount(A.EarthShield.ID, 0, player, true)
end

-- Return total active Beacon of Light Buff for tank only
local function ActiveEarthShieldOnTank()
    local CurrentTanks = HealingEngine.GetMembersByMode("TANK")
	local total = 0
	-- Iterate through current tanks
	for i = 1, #CurrentTanks do 
	    if Unit(CurrentTanks[i].Unit):HasBuffs(A.EarthShield.ID, player, true) > 0 then
            total = total + 1
        end
	end
    return total
end

local StopCast = false 

-- Return boolean
-- Current Group HPS > Incoming damage
local function IsGroupEnoughHPS()
    return ((HealingEngine.GetIncomingHPSAVG() > HealingEngine.GetIncomingDMGAVG()) or (not IsInRaid() and not IsInGroup()))
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

-- [3] Single Rotation
A[3] = function(icon, isMulti)
    
	local inCombat = Unit(player):CombatTime() > 0
    local isMoving = Player:IsMoving()
    local isMovingFor = A.Player:IsMovingTime()
    local combatTime = Unit(player):CombatTime()    
    local ShouldStop = Action.ShouldStop()
    local Pull = Action.BossMods:GetPullTimer()
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
        
        -- Purge
        if A.ArcaneTorrent:IsRacialReady(unit) then 
            return A.ArcaneTorrent:Show(icon)
        end             
 
        -- Purge
        if A.Purge:IsReady(unit) and inCombat and 
		(
		    ShouldPurge(unit) 
		    or 
		    AuraIsValid(unit, "UsePurge", "PurgeHigh") 
		)
		then 
            return A.Purge:Show(icon)
        end   
        
        -- Interrupts
        local Interrupt = Interrupts(unit)
        if Interrupt then 
            return Interrupt:Show(icon)
        end         
                
        -- PvP CrownControl (Enemy Healer)
        if A.IsInPvP then 
            local EnemyHealerUnitID = EnemyTeam("HEALER"):GetUnitID(40)
            
            if EnemyHealerUnitID ~= "none" and A.Hex:IsReady(EnemyHealerUnitID, true, nil, nil) and A.Hex:AbsentImun(EnemyHealerUnitID, Temp.TotalAndPhysAndCCAndStun, true) and Unit(EnemyHealerUnitID):IsControlAble("incapacitate", 0) and Unit(EnemyHealerUnitID):InCC() <= GetCurrentGCD() then
                return A.Hex:Show(icon)     
            end 
        end 
 
        -- 
 
        -- Bursting 
        if BurstIsON(unit) and A.AbsentImun(nil, unit, Temp.TotalAndPhys) then 
            
            if Unit(unit):HealthPercent() <= GetToggle(2, "RacialBurstDamaging") then 
                if A.BloodFury:AutoRacial(unit) then 
                    return A.BloodFury:Show(icon)
                end 
                
                if A.Fireblood:AutoRacial(unit) then 
                    return A.Fireblood:Show(icon)
                end 
                
                if A.AncestralCall:AutoRacial(unit) then 
                    return A.AncestralCall:Show(icon)
                end 
                
                if A.Berserking:AutoRacial(unit) then 
                    return A.Berserking:Show(icon)
                end 
            end 
        end
        
        -- Trinkets 
        if inMelee and A.AbsentImun(nil, unit, Temp.TotalAndPhys) and Unit(unit):HealthPercent() <= GetToggle(2, "TrinketBurstDamaging") then 
            if A.Trinket1:IsReady(unit) and A.Trinket1:GetItemCategory() ~= "DEFF" then 
                return A.Trinket1:Show(icon)
            end 
            
            if A.Trinket2:IsReady(unit) and A.Trinket2:GetItemCategory() ~= "DEFF" then 
                return A.Trinket2:Show(icon)
            end     
        end     
        
        -- Damage Rotation 
		
		-- LavaBurst
        if A.LavaBurst:IsReady(unit) and 
		A.LavaBurst:AbsentImun(unit, Temp.TotalAndMag) and 
		Unit(unit):HasDeBuffs(A.FlameShock.ID, true) > 0 and 
		(
		    Unit("player"):HasBuffs(A.LavaSurge.ID, true) > 0 
			or
			A.EchooftheElements:IsSpellLearned() and A.LavaBurst:GetSpellCharges() > 1
		)
		then 
            return A.LavaBurst:Show(icon)
        end 
        
		-- FlameShock
        if A.FlameShock:IsReady(unit) and A.FlameShock:AbsentImun(unit, Temp.TotalAndMag) and Unit(unit):HasDeBuffs(A.FlameShock.ID, true) < 3 then 
            return A.FlameShock:Show(icon)
        end 

		-- ChainLightning
        if A.ChainLightning:IsReady(unit) and A.GetToggle(2, "AoE") and A.ChainLightning:AbsentImun(unit, Temp.TotalAndMag) and Unit(unit):HasDeBuffs(A.FlameShock.ID, true) > 0 and MultiUnits:GetByRange(30) > 2 then 
            return A.ChainLightning:Show(icon)
        end 

		-- LightningBolt
        if A.LightningBolt:IsReady(unit) and A.LightningBolt:AbsentImun(unit, Temp.TotalAndMag) and Unit(unit):HasDeBuffs(A.FlameShock.ID, true) > 0 then 
            return A.LightningBolt:Show(icon)
        end 
        
        -- Azerite Essence 
        if A.ConcentratedFlame:AutoHeartOfAzeroth(unit) then 
            return A.ConcentratedFlame:Show(icon)
        end 
        
        if     (isMulti or GetToggle(2, "AoE")) and A.RippleinSpace:AutoHeartOfAzeroth(unit) and A.RippleinSpace:AbsentImun(unit, Temp.TotalAndMag) and MultiUnits:GetByRange(25, 3) >= 3 and 
        (
            not A.IsInPvP or 
            not EnemyTeam("HEALER"):IsBreakAble(25)    
        ) 
        then 
            return A.RippleinSpace:Show(icon)
        end 
		
		-- To COntinue ? 
                    
    end 
	
    ---------------------
    --- HEAL ROTATION ---
    ---------------------  
    local function HealingRotation(unit)
	
        local TidalWave = Unit(player):HasBuffs(A.TidalWaveBuff.ID, true)
		local FlashFlood = Unit(player):HasBuffs(A.FlashFloodBuff.ID, true)
		local HWcast_t = Unit(player):CastTime(A.HealingWave.ID)
		local HScast_t = Unit(player):CastTime(A.HealingSurge.ID)
		
		if Unit(player):HasBuffs(A.WaterShield.ID, true) == 0
		then
			return A.WaterShield:Show(icon)
		end
		
        -- RESS ALL PEOPLE
        if A.AncestralVision:IsReady(player) and
        Unit(player):CombatTime()==0 and
        Unit(player):GetCurrentSpeed()==0 and
        (
            -- MouseOver
            (
                A.GetToggle(2, "mouseover") and
                Unit("mouseover"):IsExists() and        
                Unit("mouseover"):IsDead() and
                Unit("mouseover"):IsPlayer() and        
                (UnitInRaid("mouseover") or UnitInParty("mouseover")) and
                A.MouseHasFrame() and
                Unit("mouseover"):GetRange()<=100
            ) or 
            (
                (
                    not A.GetToggle(2, "mouseover") or 
                    not Unit("mouseover"):IsExists() or 
                    IsUnitEnemy("mouseover")
                ) and
                Unit("target"):IsDead() and
                Unit("target"):IsPlayer() and
                (UnitInRaid("target") or UnitInParty("target")) and
                Unit("target"):GetRange()<=100
            )
        )
		then
		    return A.AncestralVision:Show(icon)
        end

        -- RESS Single
        if A.AncestralSpirit:IsReady(unit) and
        Unit(player):CombatTime()==0 and
        Unit(player):GetCurrentSpeed()==0 and
        (
            -- MouseOver
            (
                A.GetToggle(2, "mouseover") and
                Unit("mouseover"):IsExists() and        
                Unit("mouseover"):IsDead() and
                Unit("mouseover"):IsPlayer() and        
                not IsUnitEnemy("mouseover") and  
                A.MouseHasFrame() and
                A.AncestralSpirit:IsSpellInRange("mouseover")
            ) or 
            (
                (
                    not A.GetToggle(2, "mouseover") or 
                    not Unit("mouseover"):IsExists() or 
                    IsUnitEnemy("mouseover")
                ) and
                Unit("target"):IsDead() and
                Unit("target"):IsPlayer() and
                not IsUnitEnemy("target") and
                A.AncestralSpirit:IsSpellInRange("target")
            )
        )
		then
		    return A.AncestralSpirit:Show(icon)
        end
		
        -- TremorTotem
        if A.TremorTotem:IsReady(player) and inCombat and 
		(
            FriendlyTeam():GetDeBuffs("Sleep", 30) > 0 or
		    FriendlyTeam():GetDeBuffs("Fear", 30) > 0 --or
			-- Do we got charm check anywhere ?
			--FriendlyTeam():IsCharmed()
		)
		then 
            return A.TremorTotem:Show(icon)
        end   
 
        -- ArcaneTorrent
        if A.ArcaneTorrent:IsRacialReady(unit) and inCombat then 
            return A.ArcaneTorrent:Show(icon)
        end      
        
        -- Interrupts (@targettarget)
        if unit == "target" and IsUnitEnemy("targettarget")  and inCombat then 
            local Interrupt = Interrupts("targettarget")
            if Interrupt then 
                return Interrupt:Show(icon)
            end 
        end    
        
        -- Special Mythic + logic - Critical Healing required
		-- Return specific units to target depending on current dungeon logic triggers
		-- Also contain specific Affixes logic
        if UrgentMythicPlusTargetting() and inCombat and A.IsInInstance and not A.IsInPvP then
		    return true
		end    

        -- Priority Earth Shield on tanks
		local CurrentTanks = A.HealingEngine.GetMembersByMode("TANK")
        if not A.IsInPvP and A.EarthShield:IsReady() and EarthShieldWorkMode == "Tanking Units" and A.LastPlayerCastID ~= A.EarthShield.ID and ActiveEarthShieldOnTank() == 0 then
            for i = 1, #CurrentTanks do 
                if Unit(CurrentTanks[i].Unit):GetRange() <= 40 then 
                      if Unit(CurrentTanks[i].Unit):IsPlayer() and Unit(CurrentTanks[i].Unit):HasBuffsStacks(A.EarthShield.ID, true) < 2 then    
                        -- Notification                    
                        Action.SendNotification("Placing " .. A.GetSpellInfo(A.EarthShield.ID) .. " on " .. UnitName(CurrentTanks[i].Unit), A.EarthShield.ID)
                        HealingEngine.SetTarget(CurrentTanks[i].Unit)    -- Add 1sec delay in case of emergency switch                         
                        return A.EarthShield:Show(icon)                        
                    end                    
                end                
            end    
        end

        -- EarthShield force on MostlyIncDMG
        if inCombat and 
		A.EarthShield:IsReady()  
		then  
		    if EarthShieldWorkMode == "Mostly Inc. Damage"  then
                HealingEngine.SetTargetMostlyIncDMG(1)   -- Add 1sec delay in case of emergency switch				 
			    -- Notification
				if Unit(unit):HasBuffsStacks(A.EarthShield.ID, true) <= 2 then 
			        Action.SendNotification("Refreshing " .. A.GetSpellInfo(A.EarthShield.ID) .. " on : " .. UnitName(unit), A.EarthShield.ID)			
				    return A.EarthShield:Show(icon)	
                end					
			end
		end

        -- Priority Earth Shield
        if CanCast and A.EarthShield:IsReady(unit) and 
		EarthShieldWorkMode == "Auto" and 
        (
            -- MouseOver
            (
                A.GetToggle(2, "mouseover") and
                Unit(mouseover):IsExists() and 
                A.MouseHasFrame() and
                not Unit(mouseover):IsDead() and                
                not IsUnitEnemy(mouseover) and                 
                A.EarthShield:IsSpellInRange(mouseover) and
                --A.EarthShield:PredictHeal("EarthShield", "mouseover") and
                Unit(mouseover):HasBuffs(A.EarthShield.ID, player, true) == 0 and
                (
                    (
                        HealingEngine.IsMostlyIncDMG(mouseover) and
                        Unit(mouseover):GetRealTimeDMG() > 0
                    ) or
                    Unit(mouseover):Role("TANK") or
                    combatTime == 0 or
                    -- EarthShield Tracker (is not applied for any one unit)
                    A.HealingEngine.GetBuffsCount(A.EarthShield.ID, 0, player, true) == 0 
                )
            ) or 
            (
                (
                    not A.GetToggle(2, "mouseover") or 
                    not Unit(mouseover):IsExists() or 
                    IsUnitEnemy(mouseover)
                ) and
                not Unit(target):IsDead() and
                not IsUnitEnemy(target) and
                A.EarthShield:IsSpellInRange(target) and
                --A.EarthShield:PredictHeal("EarthShield", "target") and
                Unit(target):HasBuffs(A.EarthShield.ID, player, true) == 0 and
                (
                    (
                        HealingEngine.IsMostlyIncDMG(target) and
                        Unit(target):GetRealTimeDMG() > 0
                    ) or
                    Unit(target):Role("TANK") or
                    combatTime == 0 or
                    -- EarthShield Tracker (is not applied for any one unit)
                    A.HealingEngine.GetBuffsCount(A.EarthShield.ID, 0, player, true) == 0 
                )
            )
        )
        then 
            return A.EarthShield:Show(icon)
        end

        -- #1 RPvE Dispel
        if A.PurifySpirit:IsReady(unit) and 
        (
            -- MouseOver
            (
                MouseOver and        
                A.MouseHasFrame() and                      
                not IsUnitEnemy(mouseover) and                 
                Unit(mouseover):IsPlayer() and  
                Unit(mouseover):TimeToDie() >= 6 and
                Dispel(mouseover)
            ) or 
            -- Target
            (
                (
                    not MouseOver or 
                    not Unit(mouseover):IsExists() 
                ) and       
                not IsUnitEnemy(target) and
                Unit(target):IsPlayer() and  
                Unit(target):TimeToDie() >= 6 and
                Dispel(target)
            )
        )
        then
            return A.PurifySpirit:Show(icon)
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
		
        -- #9 Burst Cooldowns
		
        -- #9.1 Ascendance
        if A.Ascendance:IsReady(player) and A.Ascendance:IsSpellLearned() and A.BurstIsON(unit) and combatTime > 5 and 
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
                            HealingEngine.GetTimeToDieUnits(5) >= GetValidMembers(true) * 0.5 or
                            HealingEngine.GetBelowHealthPercentUnits(60) >= GetValidMembers(true) * 0.5
                        )
                    ) or        
                    (
                        TeamCacheFriendlyType == "party" and
                        HealingEngine.GetBelowHealthPercentUnits(20) >= 3  
                    ) or 
                    (
                        TeamCacheFriendlyType == "raid" and
                        HealingEngine.GetBelowHealthPercentUnits(30) >= 5               
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
            Action.SendNotification("Burst " .. A.GetSpellInfo(A.Ascendance.ID), A.Ascendance.ID)
            return A.Ascendance:Show(icon)
        end		

        -- Spirit Link Totem
        if A.SpiritLinkTotem:IsReady(player) and 
		A.BurstIsON(unit) and 
		combatTime > 5 and
        (            
            (
                TeamCacheFriendlySize > 1 and 
                (
                    AVG_DMG and
                    ReceivedLast5sec and 
                    AVG_HPS and
                    (
                        ReceivedLast5sec > (AVG_DMG + AVG_HPS) * 2 or
                        AVG_DMG >= AVG_HPS * 5
                    ) 
                ) and
                (
                    HealingEngine.GetTimeToDieUnits(5) >= GetValidMembers(true) * 0.5 or
                    HealingEngine.GetBelowHealthPercentUnits(25) >= GetValidMembers(true) * 0.5
                )
            ) or        
            (
                TeamCacheFriendlyType == "party" and
                HealingEngine.GetBelowHealthPercentUnits(15) >= 3  
            ) or 
            (
                TeamCacheFriendlyType == "raid" and
                HealingEngine.GetBelowHealthPercentUnits(15) >= 5               
            ) or
			A.HealingEngine.GetTimeToFullDie() < 3
        )
        then
            -- Notification                    
            Action.SendNotification("Burst " .. A.GetSpellInfo(A.SpiritLinkTotem.ID), A.SpiritLinkTotem.ID)                
            return A.SpiritLinkTotem:Show(icon)
        end
		
        -- #9.3 HealingTideTotem            
        if A.HealingTideTotem:IsReady(player) and
		A.BurstIsON(unit) and 
		combatTime > 5 and 
        (        
            (
                TeamCache.Friendly.Size <= 2 and
                HealingEngine.GetBelowHealthPercentUnits(45) >= 2
            ) or
            (
                TeamCache.Friendly.Size <= 5 and
                HealingEngine.GetBelowHealthPercentUnits(HealingTideTotemPartyHP) >= HealingTideTotemPartyUnits
            ) or
            (
                TeamCache.Friendly.Size > 5 and      
                HealingEngine.GetBelowHealthPercentUnits(HealingTideTotemRaidHP) >= HealingTideTotemRaidUnits
            ) or     
            HealingEngine.GetHealthFrequency(GetGCD()*2) > 35
			or
			A.HealingEngine.GetTimeToFullDie() < 4
        )          
        then
            -- Notification                    
            Action.SendNotification("Burst " .. A.GetSpellInfo(A.HealingTideTotem.ID), A.HealingTideTotem.ID)                
            return A.HealingTideTotem:Show(icon)
        end
		
        -- RPvE #1 Riptide (HPS)
        if A.Riptide:IsReadyByPassCastGCD(unit) and
        (
            -- MouseOver
            (
                MouseOver and
                Unit(mouseover):IsExists() and 
                A.MouseHasFrame() and                        
                not IsUnitEnemy(mouseover) and                 
                A.Riptide:IsInRange(mouseover) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone
                A.Riptide:PredictHeal(mouseover) and
                (
                    (
                        Action.InstanceInfo.KeyStone > 0 and
                        Action.InstanceInfo.GroupSize <= 5
                    ) 
					or 
                    Unit(mouseover):TimeToDie() <= GetGCD() * 2.5 or
                    (
                        (
                            -- Ascendance
                            Unit(player):HasBuffs(A.Ascendance.ID, true) < GetCurrentGCD() + GetGCD() or
                            -- CloudburstTotem snipe 
                            (
                                CloudburstTotemDuration() > 0 and
                                CloudburstTotemDuration() < GetCurrentGCD() + GetGCD()
                            )
                        ) and 
                        (                                   
                            -- Tidal Wave Buff                          
                            Unit(player):HasBuffs(A.TidalWaveBuff.ID, true) <= Unit(player):CastTime(A.ChainHeal.ID) + GetCurrentGCD() + 0.3 or                    
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
                A.Riptide:IsInRange(target) and
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) == 0 and -- Cyclone
                A.Riptide:PredictHeal(target) and
                (
                    (
                        Action.InstanceInfo.KeyStone > 0 and
                        Action.InstanceInfo.GroupSize <= 5
                    ) 
					or 
                    Unit(target):TimeToDie() <= GetGCD() * 2.5 or
                    (
                        (
                            -- Ascendance
                            Unit(player):HasBuffs(A.Ascendance.ID, true) < GetCurrentGCD() + GetGCD() or
                            -- CloudburstTotem snipe 
                            (
                                CloudburstTotemDuration() > 0 and
                                CloudburstTotemDuration() < GetCurrentGCD() + GetGCD() * 2
                            )
                        ) and 
                        (                                   
                            -- Tidal Wave Buff                          
                            Unit(player):HasBuffs(A.TidalWaveBuff.ID, true) <= Unit(player):CastTime(A.ChainHeal.ID) + GetCurrentGCD() + 0.3 or                    
                            Unit(player):GetCurrentSpeed() ~= 0 
                        )
                    )
                )           
            ) 
        ) and
        A.LastPlayerCastID ~= A.Riptide.ID      
        then
            return A.Riptide:Show(icon)
        end
		
		-- RPvE #1 Healing Stream Totem Maintain
        --if we have 3+ melee units which can be healed or while run 
        if A.HealingStreamTotem:IsReady(player) and
		not A.CloudburstTotem:IsSpellLearned() and
		HealingStreamTotemDuration() < GetGCD() + 0.1 and 
        A.GetToggle(2, "AoE") and
		-- Mana Check
		(
		    not IsSaveManaPhase() or
            Unit(player):HasBuffs(29166, player, true) > GetCurrentGCD() + 0.2 
		) and
        (
            -- MouseOver
            (
                A.GetToggle(2, "mouseover") and
                Unit(mouseover):IsExists() and 
                A.MouseHasFrame() and
                not Unit(mouseover):IsDead() and                
                not IsUnitEnemy(mouseover) and  
                Unit("mouseover"):IsPlayer() and
                Unit(mouseover):CanInterract(40) and
                (
                    Unit(player):GetCurrentSpeed() > 0 or
                    HealingStreamTotemDuration() <= HealingStreamTotemRefresh  
                ) and
                A.HealingStreamTotem:PredictHeal("mouseover")        
            ) or 
            (
                (
                    not A.GetToggle(2, "mouseover") or 
                    not Unit(mouseover):IsExists() or 
                    IsUnitEnemy(mouseover)
                ) and
                not Unit(target):IsDead() and
                not IsUnitEnemy(target) and
                Unit("target"):IsPlayer() and
                Unit(target):CanInterract(40) and
                (
                    Unit(player):GetCurrentSpeed() > 0 or
                    HealingStreamTotemDuration() <= HealingStreamTotemRefresh					
               ) and
                A.HealingStreamTotem:PredictHeal("target") 
            ) or
            HealingEngine.HealingByRange(40, nil, A.Riptide, true) >= 3
			or     
            HealingEngine.GetHealthFrequency(GetGCD()*2) > 15
        ) and
        A.LastPlayerCastID ~= A.HealingStreamTotem.ID
        then 
            return A.HealingStreamTotem:Show(icon)
        end	

        -- RPvE #1 Cloudburst Totem Recall in the 0 - 5sec range remain
		if A.CloudburstTotem:IsSpellLearned() and A.CloudburstTotem:IsReady(player) and
		CloudburstTotemDuration() > 0 and
		CloudburstTotemDuration() < 5 and
		A.CloudburstTotem:GetSpellTimeSinceLastCast() > 10 and
		combatTime > 3 and
		(        
            (
                TeamCache.Friendly.Size <= 2 and
                HealingEngine.GetBelowHealthPercentUnits(85) >= 2
            ) or
            (
                TeamCache.Friendly.Size <= 5 and
                HealingEngine.GetBelowHealthPercentUnits(85) >= 3
            ) or
            (
                TeamCache.Friendly.Size > 5 and      
                HealingEngine.GetBelowHealthPercentUnits(85) >= 5
            ) or     
			-- Big damage
            HealingEngine.GetHealthFrequency(GetGCD()*2) > 25
			or
			HealingEngine.GetHealthAVG() < 92
        ) and
        A.LastPlayerCastID ~= A.CloudburstTotem.ID
        then 
            return A.CloudburstTotem:Show(icon)
        end 		

        -- RPvE #2 Cloudburst Totem Call
		if A.CloudburstTotem:IsSpellLearned() and A.CloudburstTotem:IsReady(player) and
		CloudburstTotemDuration() <= 0 and
		combatTime > 2  and
		(        
            (
                TeamCache.Friendly.Size <= 2 and
                HealingEngine.GetBelowHealthPercentUnits(95) >= 2
            ) or
            (
                TeamCache.Friendly.Size <= 5 and
                HealingEngine.GetBelowHealthPercentUnits(92) >= 3
            ) or
            (
                TeamCache.Friendly.Size > 5 and      
                HealingEngine.GetBelowHealthPercentUnits(94) >= 5
            ) or
			HealingEngine.GetHealthFrequency(GetGCD()*2) > 5
			or
			HealingEngine.GetHealthAVG() < 95
        )	and
        A.LastPlayerCastID ~= A.CloudburstTotem.ID
        then 
            return A.CloudburstTotem:Show(icon)
        end 		
		
        -- RPvE #1 UnleashLife
        if A.UnleashLife:IsReady(unit) and
        -- Unleash Life buff
        Unit(player):HasBuffs(73685, player, true) == 0 and
        (
            -- MouseOver
            (
                A.GetToggle(2, "mouseover") and
                Unit(mouseover):IsExists() and 
                A.MouseHasFrame() and
                not Unit(mouseover):IsDead() and                
                not IsUnitEnemy(mouseover) and                 
                A.UnleashLife:IsSpellInRange(mouseover) and
                A.UnleashLife:PredictHeal("mouseover") and
                (
                    Unit(mouseover):Health() <= Unit(mouseover):HealthMax()*0.95
                )
            ) or 
            (
                (
                    not A.GetToggle(2, "mouseover") or 
                    not Unit(mouseover):IsExists() or 
                    IsUnitEnemy(mouseover)
                ) and
                not Unit(target):IsDead() and
                not IsUnitEnemy(target) and
                A.UnleashLife:IsSpellInRange(target) and
                A.UnleashLife:PredictHeal("target") and
                (
                    Unit(target):Health() <= Unit(target):HealthMax()*0.95
                )
            )
        ) and
        A.LastPlayerCastID ~= A.UnleashLife.ID
        then 
            return A.UnleashLife:Show(icon)
        end 
		
        -- SpiritWalkersGrace
        if A.SpiritWalkersGrace:IsReady(player) and
		isMoving and
		UseSpiritWalkersGrace and
		isMovingFor >= SpiritWalkersGraceTime and
		(
            (
                TeamCacheFriendlyType == "party" and
                HealingEngine.GetBelowHealthPercentUnits(25) >= 3  
            ) or 
            (
                TeamCacheFriendlyType == "raid" and
                HealingEngine.GetBelowHealthPercentUnits(35) >= 4               
            ) or
			A.IsInPvP and Unit(player):IsFocused("MELEE") and
			(
		        CanSpiritWalkersGrace("CATCH") and SpiritWalkersCatch
			    or 
			    CanSpiritWalkersGrace()
			    or
			    Unit(player):HasBuffs(A.Ascendance.ID, true) > 3
			)
		)
		then 
            return A.SpiritWalkersGrace:Show(icon)
        end 	
		
        -- RPvE #1 Chain Heal
        if A.ChainHeal:IsReady(unit) and
		(
		    not A.IsInPvP 
			or 
			A.Tidebringer:IsSpellLearned() and Unit(player):HasBuffsStacks(236502, true) > 0
		) and
        A.GetToggle(2, "AoE") and
		TeamCache.Friendly.Size > 2 and
		-- UnleashLife
		(
		    A.UnleashLife:IsSpellLearned() and 
			(    
			    Unit(player):HasBuffs(A.UnleashLife.ID, true) > 0 or
			    A.UnleashLife:GetCooldown() > 10 
			) or
			not A.UnleashLife:IsSpellLearned()
		) and		
		(        
            (
                TeamCache.Friendly.Size <= 5 and
                HealingEngine.GetBelowHealthPercentUnits(ChainHealPartyHP) >= ChainHealPartyUnits and
				Unit(player):HasBuffs(A.TidalWaveBuff.ID, true) == 0
            ) or
            (
                TeamCache.Friendly.Size > 5 and      
                HealingEngine.GetBelowHealthPercentUnits(ChainHealRaidHP) >= ChainHealRaidUnits 
            ) or     
            HealingEngine.GetHealthFrequency(GetGCD()*2) > 10
        )
        then 
            return A.ChainHeal:Show(icon)
        end 

        -- HPvE #1 HealingSurge Critical Dungeon		
        if A.HealingSurge:IsReady(unit) and 
        -- TidalWave
        TidalWave > 0 and
        TidalWave > HScast_t + GetCurrentGCD() + 0.1 and
		(
            Unit(player):GetCurrentSpeed() == 0 
			or 
			Unit(player):HasBuffs(A.SpiritWalkersGrace.ID, true) > HScast_t + GetCurrentGCD() + 0.1 
		)and 
        (
            -- MouseOver
            (
                MouseOver and
                Unit(mouseover):IsExists() and 
                A.MouseHasFrame() and                        
                not IsUnitEnemy(mouseover) and                 
                A.HealingSurge:IsInRange(mouseover) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) < HScast_t + GetCurrentGCD() and
                A.HealingSurge:PredictHeal(mouseover) and
                Unit(mouseover):TimeToDie() > HScast_t + GetCurrentGCD() + 2 and
                (
                    Unit(mouseover):IsTank() or
                    HealingEngine.IsMostlyIncDMG(mouseover) or
                    Unit(mouseover):Health() < Unit(mouseover):HealthMax() * 0.8 --or
                    --Unit(mouseover):HealthPercent() < FlashofLightHP or
                    --Unit(mouseover):TimeToDieX(3) < FlashofLightTTD    
                )
            ) or 
            -- Target
            (
                (
                    not MouseOver or 
                    not Unit(mouseover):IsExists() 
                ) and        
                not IsUnitEnemy(target) and
                A.HealingSurge:IsInRange(target) and
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) < HScast_t + GetCurrentGCD() and
                A.HealingSurge:PredictHeal(target) and
                Unit(target):TimeToDie() > HScast_t + GetCurrentGCD() + 2 and
                (
                    Unit(target):IsTank() or
                    HealingEngine.IsMostlyIncDMG(target) or
                    Unit(target):Health() < Unit(target):HealthMax() * 0.8 --or
                    --Unit(target):HealthPercent() < FlashofLightHP or
                    --Unit(target):TimeToDieX(5) < FlashofLightTTD                
                )
            ) or
            -- Save us
            (
                Unit(player):HealthPercent() < 60 or
                Unit(player):TimeToDieX(5) < 2    
            )            
        )
        then
            return A.HealingSurge:Show(icon)
        end

        -- HPvE #1 HealingWave - Low to Moderate Dungeon
        if A.HealingWave:IsReady(unit) and 		
		(
            Unit(player):GetCurrentSpeed() == 0 
			or 
			Unit(player):HasBuffs(A.SpiritWalkersGrace.ID, true) > HScast_t + GetCurrentGCD() + 0.1 
		)and 
		(
		    TidalWave > 0 and TidalWave > HWcast_t + GetCurrentGCD() + 0.1
		    or 
			A.FlashFlood:IsSpellLearned() and FlashFlood > 0 and FlashFlood > HWcast_t + GetCurrentGCD() + 0.1
		) and 
        (
            -- MouseOver
            (
                MouseOver and
                Unit(mouseover):IsExists() and 
                A.MouseHasFrame() and                        
                not IsUnitEnemy(mouseover) and                 
                A.HealingWave:IsInRange(mouseover) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) < HWcast_t + GetCurrentGCD() and
                A.HealingWave:PredictHeal(mouseover) and
                Unit(mouseover):TimeToDie() > HWcast_t + GetCurrentGCD() + 1
            ) or 
            -- Target
            (
                (
                    not MouseOver or 
                    not Unit(mouseover):IsExists() or 
                    IsUnitEnemy(mouseover)
                ) and        
                not IsUnitEnemy(target) and
                A.HealingWave:IsInRange(target) and
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) < HWcast_t + GetCurrentGCD() and
                A.HealingWave:PredictHeal(target) and
                Unit(target):TimeToDie() > HWcast_t + GetCurrentGCD() + 1
            )   
        )
        then
            return A.HealingWave:Show(icon)
        end	

		
        -- RPvE #1 HealingRain 
        if A.HealingRain:IsReady(player) and
		not A.IsInPvP and
		Unit(player):GetCurrentSpeed() == 0 and
		Player:IsStayingTime() > 3 and
        A.GetToggle(2, "AoE") and
		HealingRainDuration() <= HealingRainRefresh and
		-- Mana Check
		(
		    not IsSaveManaPhase() or
            Unit(player):HasBuffs(29166, player, true) > GetCurrentGCD() + 0.2 
		) and
		(        
            (
                TeamCache.Friendly.Size <= 2 and
                HealingEngine.GetBelowHealthPercentUnits(95) >= 2
            ) or
            (
                TeamCache.Friendly.Size <= 5 and
                HealingEngine.GetBelowHealthPercentUnits(95) >= 3
            ) or
            (
                TeamCache.Friendly.Size > 5 and      
                HealingEngine.GetBelowHealthPercentUnits(90) >= 5
            ) or     
            HealingEngine.GetHealthFrequency(GetGCD()*4) > 10
        )
        then 
            return A.HealingRain:Show(icon)
        end 	
		
        -- RPvE #1 Earthen Wall Totem 
        if A.EarthenWallTotem:IsReady(player) and
		(        
            (
                TeamCache.Friendly.Size <= 2 and
                HealingEngine.GetBelowHealthPercentUnits(95) >= 2
            ) or
            (
                TeamCache.Friendly.Size <= 5 and
                HealingEngine.GetBelowHealthPercentUnits(95) >= 3
            ) or
            (
                TeamCache.Friendly.Size > 5 and      
                HealingEngine.GetBelowHealthPercentUnits(90) >= 5
            ) or     
            HealingEngine.GetHealthFrequency(GetGCD()*4) > 10
        )
        then 
            return A.EarthenWallTotem:Show(icon)
        end 
		
		-- RPvE #1 Wellspring
        if A.Wellspring:IsReady(unit) and
        A.GetToggle(2, "AoE") and
		TeamCache.Friendly.Size > 2 and		
		(        
            (
                TeamCache.Friendly.Size <= 5 and
                HealingEngine.GetBelowHealthPercentUnits(70) >= 4
            ) or
            (
                TeamCache.Friendly.Size > 5 and      
                HealingEngine.GetBelowHealthPercentUnits(90) >= 4
            ) or     
            HealingEngine.GetHealthFrequency(GetGCD()*4) > 20
        )
        then 
            return A.Wellspring:Show(icon)
        end 
		
        -- HPvE #2 HealingSurge Critical Raid
        if A.HealingSurge:IsReady(unit) and 
		(
            Unit(player):GetCurrentSpeed() == 0 
			or 
			Unit(player):HasBuffs(A.SpiritWalkersGrace.ID, true) > HScast_t + GetCurrentGCD() + 0.1 
		)and 
        (
            -- MouseOver
            (
                MouseOver and
                Unit(mouseover):IsExists() and 
                A.MouseHasFrame() and                        
                not IsUnitEnemy(mouseover) and                 
                A.HealingSurge:IsInRange(mouseover) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) < HScast_t + GetCurrentGCD() and
                A.HealingSurge:PredictHeal(mouseover) and
                Unit(mouseover):TimeToDie() > HScast_t + GetCurrentGCD() + 2 and
                (
                    Unit(mouseover):IsTank() or
                    HealingEngine.IsMostlyIncDMG(mouseover) or
                    Unit(mouseover):Health() < Unit(mouseover):HealthMax() * 0.8 --or
                    --Unit(mouseover):HealthPercent() < FlashofLightHP or
                    --Unit(mouseover):TimeToDieX(3) < FlashofLightTTD    
                )
            ) or 
            -- Target
            (
                (
                    not MouseOver or 
                    not Unit(mouseover):IsExists() 
                ) and        
                not IsUnitEnemy(target) and
                A.HealingSurge:IsInRange(target) and
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) < HScast_t + GetCurrentGCD() and
                A.HealingSurge:PredictHeal(target) and
                Unit(target):TimeToDie() > HScast_t + GetCurrentGCD() + 2 and
                (
                    Unit(target):IsTank() or
                    HealingEngine.IsMostlyIncDMG(target) or
                    Unit(target):Health() < Unit(target):HealthMax() * 0.8 --or
                    --Unit(target):HealthPercent() < FlashofLightHP or
                    --Unit(target):TimeToDieX(5) < FlashofLightTTD                
                )
            ) or
            -- Save us
            (
                Unit(player):HealthPercent() < 60 or
                Unit(player):TimeToDieX(5) < 2    
            )            
        )
        then
            return A.HealingSurge:Show(icon)
        end
		 
        -- HPvE #2 HealingWave - Low to Moderate Raid		
        if A.HealingWave:IsReady(unit) and 		
		(
            Unit(player):GetCurrentSpeed() == 0 
			or 
			Unit(player):HasBuffs(A.SpiritWalkersGrace.ID, true) > HScast_t + GetCurrentGCD() + 0.1 
		)and  
        (
            -- MouseOver
            (
                MouseOver and
                Unit(mouseover):IsExists() and 
                A.MouseHasFrame() and                        
                not IsUnitEnemy(mouseover) and                 
                A.HealingWave:IsInRange(mouseover) and
                Unit(mouseover):HasDeBuffs(A.Cyclone.ID, true) < HWcast_t + GetCurrentGCD() and
                A.HealingWave:PredictHeal(mouseover) and
                Unit(mouseover):TimeToDie() > HWcast_t + GetCurrentGCD() + 1
            ) or 
            -- Target
            (
                (
                    not MouseOver or 
                    not Unit(mouseover):IsExists() or 
                    IsUnitEnemy(mouseover)
                ) and        
                not IsUnitEnemy(target) and
                A.HealingWave:IsInRange(target) and
                Unit(target):HasDeBuffs(A.Cyclone.ID, true) < HWcast_t + GetCurrentGCD() and
                A.HealingWave:PredictHeal(target) and
                Unit(target):TimeToDie() > HWcast_t + GetCurrentGCD() + 1
            )
            or
            -- Save us
            (
                Unit(player):HealthPercent() < 91 or
                Unit(player):TimeToDieX(15) < 5    
            )    
        )
        then
            return A.HealingWave:Show(icon)
        end	
    end 
		
    -- GhostWolf if out of range 
    if A.GhostWolf:IsReady(player) and A.GhostWolf:GetSpellTimeSinceLastCast() > 2 and not A.LastPlayerCastID == A.GhostWolf.ID and UseGhostWolf and Unit(player):HasBuffs(A.GhostWolf.ID, true) == 0 and 
	(
	    isMovingFor > GhostWolfTime  
	    or
		-- Defensives
		Unit("player"):IsFocused("MELEE", true) and Unit("player"):HealthPercent() < 90 and A.IsInPvP and A.SpiritWolf:IsSpellLearned()
	)
	then
        return A.GhostWolf:Show(icon)
    end	
	if A.IsInPvP and Unit(player):HasBuffs(A.GhostWolf.ID, true) > 0 and A.SpiritWolf:IsSpellLearned() then	    
        return A.PoolResource:Show(icon)
    end		
	    
    -- Defensive
    local SelfDefensive = SelfDefensives()
    if SelfDefensive then 
        return SelfDefensive:Show(icon)
    end 
    
	-- Friendly Mouseover
    if A.IsUnitFriendly(mouseover) then 
        unit = mouseover  
		
        if HealingRotation(unit) then 
            return true 
        end             
    end
	
    -- Heal Target 
    if A.IsUnitFriendly(target) then 
        unit = target 
		
        if HealingRotation(unit) then 
            return true 
        end 
    end    
	
    -- Enemy Mouseover 
    if A.IsUnitEnemy(mouseover) then 
        unit = mouseover	
		
        if DamageRotation(unit) then 
            return true 
        end 
    end 
    
    -- DPS Target     
    if A.IsUnitEnemy(target) then 
        unit = target
        
        if DamageRotation(unit) then 
            return true 
        end 
    end 

    -- DPS targettarget     
    if A.IsUnitEnemy(targettarget) then 
        unit = targettarget
        
        if DamageRotation(unit) then 
            return true 
        end 
    end 
      
end 

-- [4] AoE Rotation
A[4] = function(icon)
    return A[3](icon, true)
end 

-- [5] Trinket Rotation
-- No specialization trinket actions 
A[5] = nil 

local function ArenaRotation(icon, unit)
    if A.IsInPvP and (Action.Zone == "pvp" or Action.Zone == "arena") and not Player:IsStealthed() and not Player:IsMounted() then
        -- Note: "arena1" is just identification of meta 6
        if (unit == "arena1" or unit == "arena2" or unit == "arena3") and (Unit(player):GetDMG() == 0 or not Unit(player):IsFocused("DAMAGER")) then 
         
		     -- Interrupt
   		    local Interrupt = Interrupts(unit)
  		    if Interrupt then 
  		        return Interrupt:Show(icon)
  		    end	
			
			-- Hex BreakAble CC
            if A.Hex:IsReady(unit) and EnemyTeam():IsCastingBreakAble(0.25) then 
                return A.Hex
            end 
        end
    end 
end 

local function PartyRotation(unit)
    if (unit == "party1" and not A.GetToggle(2, "PartyUnits")[1]) or (unit == "party2" and not A.GetToggle(2, "PartyUnits")[2]) then 
        return false 
    end

    -- TremorTotem
    if A.TremorTotem:IsReady(player) and Unit(unit):HasDeBuffs("Fear") > 0 then
        return A.TremorTotem
    end
    
    -- Purify Spirit
    if A.PurifySpirit:IsReady(unit) and      
    (
        Unit(unit):IsPlayer() and  
        Unit(unit):TimeToDie() >= 6 and
        AuraIsValid(unit, "UseDispel", "Dispel")    
    )
    then
        return A.PurifySpirit
    end
    
end 

A[6] = function(icon)
    -- Call rotations variables
	RotationsVariables()
	
    -- StopCast OverHeal
   -- if Temp.LastPrimaryUnitID and CanStopCastingOverHeal() and StopCastOverHeal then 
   --     return A:Show(icon, ACTION_CONST_STOPCAST)
  --  end

    -- Stop Cast M+ Quake Affix
    if Unit(player):IsCastingRemains() > 0 and StopCastQuake and Unit(player):HasDeBuffs(A.Quake.ID) <= StopCastQuakeSec and Unit(player):HasDeBuffs(A.Quake.ID) > 0 then
        return A:Show(icon, ACTION_CONST_STOPCAST)
    end
  
    --if RotationPassive(icon) then 
    --    return true 
    --end 
    
    local Arena = ArenaRotation("arena1")
    if Arena then 
        return Arena:Show(icon)
    end 
end

A[7] = function(icon)
    --if RotationPassive(icon) then 
    --    return true 
    --end 
    
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
    --if RotationPassive(icon) then 
    --    return true 
    --end 
    
    local Party = PartyRotation("party2") 
    if Party then 
        return Party:Show(icon)
    end     
    
    local Arena = ArenaRotation("arena3")
    if Arena then 
        return Arena:Show(icon)
    end 
end