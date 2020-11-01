--###################################
--##### TRIP'S ELEMENTAL SHAMAN #####
--###################################

--Full credit to Taste

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
    BagofTricks                            = Action.Create({ Type = "Spell", ID = 312411    }),
    WilloftheForsaken                      = Action.Create({ Type = "Spell", ID = 7744        }), -- not usable in APL but user can Queue it   
    EscapeArtist                           = Action.Create({ Type = "Spell", ID = 20589    }), -- not usable in APL but user can Queue it
    EveryManforHimself                     = Action.Create({ Type = "Spell", ID = 59752    }), -- not usable in APL but user can Queue it
    -- Generics
    AncestralGuidance                      = Action.Create({ Type = "Spell", ID = 108281 }),
    StormkeeperBuff                        = Action.Create({ Type = "Spell", ID = 191634, Hidden = true     }),
    Stormkeeper                            = Action.Create({ Type = "Spell", ID = 191634 }),
    FireElemental                          = Action.Create({ Type = "Spell", ID = 198067 }),
    StormElemental                         = Action.Create({ Type = "Spell", ID = 192249 }),
    ElementalBlast                         = Action.Create({ Type = "Spell", ID = 117014 }),
    LavaBurst                              = Action.Create({ Type = "Spell", ID = 51505 }),
    ChainLightning                         = Action.Create({ Type = "Spell", ID = 188443 }),
    FlameShock                             = Action.Create({ Type = "Spell", ID = 188389 }),
    FlameShockDebuff                       = Action.Create({ Type = "Spell", ID = 188389, Hidden = true }),
    WindGustBuff                           = Action.Create({ Type = "Spell", ID = 263806, Hidden = true     }),
    Ascendance                             = Action.Create({ Type = "Spell", ID = 114050 }),
    Icefury                                = Action.Create({ Type = "Spell", ID = 210714 }),
    IcefuryBuff                            = Action.Create({ Type = "Spell", ID = 210714, Hidden = true     }),
    LiquidMagmaTotem                       = Action.Create({ Type = "Spell", ID = 192222 }),
    Earthquake                             = Action.Create({ Type = "Spell", ID = 61882 }),
    MasteroftheElements                    = Action.Create({ Type = "Spell", ID = 16166 }),
    MasteroftheElementsBuff                = Action.Create({ Type = "Spell", ID = 260734 , Hidden = true     }),
    LavaSurgeBuff                          = Action.Create({ Type = "Spell", ID = 77762 , Hidden = true     }),
    AscendanceBuff                         = Action.Create({ Type = "Spell", ID = 114050 , Hidden = true     }),
    FrostShock                             = Action.Create({ Type = "Spell", ID = 196840 }),
    LavaBeam                               = Action.Create({ Type = "Spell", ID = 114074 }),
    IgneousPotential                       = Action.Create({ Type = "Spell", ID = 279829 }),
    SurgeofPowerBuff                       = Action.Create({ Type = "Spell", ID = 285514 , Hidden = true     }),
    NaturalHarmony                         = Action.Create({ Type = "Spell", ID = 278697 }),
    SurgeofPower                           = Action.Create({ Type = "Spell", ID = 262303 }),
    LightningBolt                          = Action.Create({ Type = "Spell", ID = 188196 }),
    LavaShock                              = Action.Create({ Type = "Spell", ID = 273448 }),
    LavaShockBuff                          = Action.Create({ Type = "Spell", ID = 273453 , Hidden = true     }),
    EarthShock                             = Action.Create({ Type = "Spell", ID = 8042 }),
    CalltheThunder                         = Action.Create({ Type = "Spell", ID = 260897 }),
    EchooftheElementals                    = Action.Create({ Type = "Spell", ID = 275381 }),
    EchooftheElements                      = Action.Create({ Type = "Spell", ID = 333919 }),
    ResonanceTotemBuff                     = Action.Create({ Type = "Spell", ID = 202192 , Hidden = true     }),
    TectonicThunder                        = Action.Create({ Type = "Spell", ID = 286949 }),
    TectonicThunderBuff                    = Action.Create({ Type = "Spell", ID = 286949 , Hidden = true     }),
	UnlimitedPower                         = Action.Create({ Type = "Spell", ID = 260895}),
    WindShear                              = Action.Create({ Type = "Spell", ID = 57994 }),
    BloodFury                              = Action.Create({ Type = "Spell", ID = 20572 }),
    Berserking                             = Action.Create({ Type = "Spell", ID = 26297 }),
    Fireblood                              = Action.Create({ Type = "Spell", ID = 265221 }),
    AncestralCall                          = Action.Create({ Type = "Spell", ID = 274738 }),
    EarthElemental                         = Action.Create({ Type = "Spell", ID = 198103 }), -- Earth Elemental manual queue
	EchoingShock						   = Action.Create({ Type = "Spell", ID = 320125 }),
	LightningShield						   = Action.Create({ Type = "Spell", ID = 192106 }),
	StaticDischarge						   = Action.Create({ Type = "Spell", ID = 342243 }), 
    -- Utilities
    LightningLasso                         = Action.Create({ Type = "Spell", ID = 305483     }),
    CapacitorTotem                         = Action.Create({ Type = "Spell", ID = 192058     }),
    Purge                                  = Action.Create({ Type = "Spell", ID = 370     }),
    GhostWolf                              = Action.Create({ Type = "Spell", ID = 2645     }),
    EarthShield                            = Action.Create({ Type = "Spell", ID = 974     }),
    HealingSurge                           = Action.Create({ Type = "Spell", ID = 8004     }),
    PrimalElementalist                     = Action.Create({ Type = "Spell", ID = 117013 , Hidden = true     }),
    GhostWolfBuff                          = Action.Create({ Type = "Spell", ID = 2645, Hidden = true     }),    
    Hex                                    = Create({ Type = "Spell", ID = 51514 }),	
    -- Storm Elemental   
    EyeOfTheStorm                          = Action.Create({ Type = "Spell", ID = 157375 , Hidden = true     }), 
    CallLightning                          = Action.Create({ Type = "Spell", ID = 157348 , Hidden = true     }),
    -- Defensive
    AstralShift                            = Action.Create({ Type = "Spell", ID = 108271     }),    
    ShiverVenomDebuff                      = Action.Create({ Type = "Spell", ID = 301624, Hidden = true     }),
	CleanseSpirit                          = Action.Create({ Type = "Spell", ID = 51886     }), -- PartyDispell
    -- Potions
    PotionofUnbridledFury                  = Action.Create({ Type = "Potion", ID = 169299, QueueForbidden = true }), 
    BattlePotionOfAgility                  = Action.Create({ Type = "Potion", ID = 163223, QueueForbidden = true }),  
    SuperiorPotionofUnbridledFury          = Action.Create({ Type = "Potion", ID = 168489, QueueForbidden = true }), 
	SuperiorSteelskinPotion                = Action.Create({ Type = "Potion", ID = 168501, QueueForbidden = true }), 
	AbyssalHealingPotion                   = Action.Create({ Type = "Potion", ID = 169451, QueueForbidden = true }),     
	PotionofFocusedResolve                 = Action.Create({ Type = "Potion", ID = 168506 }),
	SuperiorBattlePotionofStrength         = Action.Create({ Type = "Potion", ID = 168500 }),
	PotionofEmpoweredProximity             = Action.Create({ Type = "Potion", ID = 168529 }),
    -- Trinkets
    AzsharasFontofPower                    = Action.Create({ Type = "Trinket", ID = 169314 }),
    PocketsizedComputationDevice           = Action.Create({ Type = "Trinket", ID = 167555 }),
    RotcrustedVoodooDoll                   = Action.Create({ Type = "Trinket", ID = 159624 }),
    ShiverVenomRelic                       = Action.Create({ Type = "Trinket", ID = 168905 }),
    AquipotentNautilus                     = Action.Create({ Type = "Trinket", ID = 169305 }),
    TidestormCodex                         = Action.Create({ Type = "Trinket", ID = 165576 }),
    VialofStorms                           = Action.Create({ Type = "Trinket", ID = 158224 }),
    GalecallersBoon                        = Action.Create({ Type = "Trinket", ID = 159614 }),
    InvocationOfYulon                      = Action.Create({ Type = "Trinket", ID = 165568 }),
    LustrousGoldenPlumage                  = Action.Create({ Type = "Trinket", ID = 159617 }),
    LurkersInsidiousGift                   = Action.Create({ Type = "Trinket", ID = 167866 }),
    VigorTrinket                           = Action.Create({ Type = "Trinket", ID = 165572 }),
    AshvanesRazorCoral                     = Action.Create({ Type = "Trinket", ID = 169311 }),
    MalformedHeraldsLegwraps               = Action.Create({ Type = "Trinket", ID = 167835 }),
    HyperthreadWristwraps                  = Action.Create({ Type = "Trinket", ID = 168989 }),
    NotoriousAspirantsBadge                = Action.Create({ Type = "Trinket", ID = 167528 }),
    NotoriousGladiatorsBadge               = Action.Create({ Type = "Trinket", ID = 167380 }),
    SinisterGladiatorsBadge                = Action.Create({ Type = "Trinket", ID = 165058 }),
    SinisterAspirantsBadge                 = Action.Create({ Type = "Trinket", ID = 165223 }),
    DreadGladiatorsBadge                   = Action.Create({ Type = "Trinket", ID = 161902 }),
    DreadAspirantsBadge                    = Action.Create({ Type = "Trinket", ID = 162966 }),
    DreadCombatantsInsignia                = Action.Create({ Type = "Trinket", ID = 161676 }),
    NotoriousAspirantsMedallion            = Action.Create({ Type = "Trinket", ID = 167525 }),
    NotoriousGladiatorsMedallion           = Action.Create({ Type = "Trinket", ID = 167377 }),
    SinisterGladiatorsMedallion            = Action.Create({ Type = "Trinket", ID = 165055 }),
    SinisterAspirantsMedallion             = Action.Create({ Type = "Trinket", ID = 165220 }),
    DreadGladiatorsMedallion               = Action.Create({ Type = "Trinket", ID = 161674 }),
    DreadAspirantsMedallion                = Action.Create({ Type = "Trinket", ID = 162897 }),
    DreadCombatantsMedallion               = Action.Create({ Type = "Trinket", ID = 161811 }),
    IgnitionMagesFuse                      = Action.Create({ Type = "Trinket", ID = 159615 }),
    TzanesBarkspines                       = Action.Create({ Type = "Trinket", ID = 161411 }),
    AzurethosSingedPlumage                = Action.Create({ Type = "Trinket", ID = 161377 }),
    AncientKnotofWisdomAlliance            = Action.Create({ Type = "Trinket", ID = 161417 }),
    AncientKnotofWisdomHorde               = Action.Create({ Type = "Trinket", ID = 166793 }),
    ShockbitersFang                        = Action.Create({ Type = "Trinket", ID = 169318 }),
    NeuralSynapseEnhancer                  = Action.Create({ Type = "Trinket", ID = 168973 }),
    BalefireBranch                         = Action.Create({ Type = "Trinket", ID = 159630 }),
	GrongsPrimalRage                       = Action.Create({ Type = "Trinket", ID = 165574 }),
	BygoneBeeAlmanac                       = Action.Create({ Type = "Trinket", ID = 163936 }),
	RampingAmplitudeGigavoltEngine         = Action.Create({ Type = "Trinket", ID = 165580 }),
	VisionofDemise                         = Action.Create({ Type = "Trinket", ID = 169307 }),
	JesHowler                              = Action.Create({ Type = "Trinket", ID = 159627 }),
	GalecallersBeak                        = Action.Create({ Type = "Trinket", ID = 161379 }),
    DribblingInkpod                        = Action.Create({ Type = "Trinket", ID = 169319 }),
    MerekthasFang                          = Action.Create({ Type = "Trinket", ID = 158367 }),	
	GrongsPrimalRage                       = Action.Create({ Type = "Trinket", ID = 165574 }),
	BygoneBeeAlmanac                       = Action.Create({ Type = "Trinket", ID = 163936 }),
	RampingAmplitudeGigavoltEngine         = Action.Create({ Type = "Trinket", ID = 165580 }),
	VisionofDemise                         = Action.Create({ Type = "Trinket", ID = 169307 }),
	JesHowler                              = Action.Create({ Type = "Trinket", ID = 159627 }),
	GalecallersBeak                        = Action.Create({ Type = "Trinket", ID = 161379 }),
    DribblingInkpod                        = Action.Create({ Type = "Trinket", ID = 169319 }),
    RazdunksBigRedButton                   = Action.Create({ Type = "Trinket", ID = 159611 }),
    MerekthasFang                          = Action.Create({ Type = "Trinket", ID = 158367 }),
    KnotofAncientFuryAlliance              = Action.Create({ Type = "Trinket", ID = 161413 }),
    KnotofAncientFuryHorde                 = Action.Create({ Type = "Trinket", ID = 166795 }),
    FirstMatesSpyglass                     = Action.Create({ Type = "Trinket", ID = 158163 }),
    VialofAnimatedBlood                    = Action.Create({ Type = "Trinket", ID = 159625 }),
    -- Misc
    Channeling                             = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),    -- Show an icon during channeling
    TargetEnemy                            = Action.Create({ Type = "Spell", ID = 44603, Hidden = true     }),    -- Change Target (Tab button)
    StopCast                               = Action.Create({ Type = "Spell", ID = 61721, Hidden = true     }),        -- spell_magic_polymorphrabbit
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
	Darkflight							   = Action.Create({ Type = "Spell", ID = 68992 }), -- used for Heart of Azeroth	
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

local function IsSchoolFree()
    return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "SHADOW") == 0
end 

-- API - Tracker
-- Initialize Tracker 
Pet:AddTrackers(ACTION_CONST_SHAMAN_ENCHANCEMENT, { -- this template table is the same with what has this library already built-in, just for example
    [77942] = {
        name = "Primal Storm Elemental",
        duration = 30,
    },
})

-- Function to check for Infernal duration
local function PrimalStormElementalTime()
    return Pet:GetRemainDuration(77942) or 0
end 

local function StormElementalIsActive()
    if PrimalStormElementalTime() > 0 then
        return true
    else
        return false
    end
end

local function ResonanceTotemTime()
    for index = 1, 4 do
        local _, totemName, startTime, duration = GetTotemInfo(index)
        if totemName == A.TotemMastery:Info() then
            return (floor(startTime + duration - TMW.time + 0.5)) or 0
        end
    end
    return 0
end

local function FutureMaelstromPower()
    local castName, castStartTime, castEndTime, notInterruptable, spellID, isChannel = Unit("player"):IsCasting()
    local castLeft, _, _, _, notKickAble = Unit("player"):IsCastingRemains()
    local MaelstromPower = Player:Maelstrom()
    local overloadChance = Player:MasteryPct() / 100
    local factor = 1 + 0.75 * overloadChance
    local resonance = 0
    
    if Unit("player"):CombatTime() > 0 then
        if A.TotemMastery:IsReady("player") then
            resonance = castLeft
        end
        if not castLeft then
            return MaelstromPower
        else
            if spellID == A.LightningBolt.ID then
                return MaelstromPower + 8 + resonance
            elseif spellID == A.LavaBurst.ID then
                return MaelstromPower + 10 + resonance
            elseif spellID == A.ChainLightning.ID then
                local enemiesHit = min(MultiUnits:GetActiveEnemies(), 3)
                return MaelstromPower + 4 * enemiesHit * factor + resonance
            elseif spellID == A.Icefury.ID then
                return MaelstromPower + 25 * factor + resonance
            else
                return MaelstromPower
            end
        end
    end
end

local function HandleAncestralGuidance()
    local choice = Action.GetToggle(2, "AncestralGuidanceSelection")
    
    if choice == "In Raid" then
        if IsInRaid() then
            return true
        else
            return false
        end
    elseif choice == "In Dungeon" then 
        if IsInGroup() then
            return true
        else
            return false
        end
    elseif choice == "In PvP" then     
        if A.IsInPvP then 
            return true
        else
            return false
        end        
    elseif choice == "Everywhere" then 
        return true
    else
        return false
    end
    --print(choice)
end

-- Multidot Handler UI --
local function HandleMultidots()
    local choice = Action.GetToggle(2, "AutoDotSelection")
    
    if choice == "In Raid" then
        if IsInRaid() then
            return true
        else
            return false
        end
    elseif choice == "In Dungeon" then 
        if IsInGroup() then
            return true
        else
            return false
        end
    elseif choice == "In PvP" then     
        if A.IsInPvP then 
            return true
        else
            return false
        end        
    elseif choice == "Everywhere" then 
        return true
    else
        return false
    end
    --print(choice)
end

-- Stormkeeper Handler UI --
local function HandleStormkeeper()
    local choice = A.GetToggle(2, "StormkeeperMode")
    --print(choice) 
    local unit = "target"
    -- CDs ON
    if choice[1] then 
        -- also checks AoE
        if choice[2] then
            return (A.BurstIsON(unit) and MultiUnits:GetActiveEnemies() > 2 and A.GetToggle(2, "AoE")) or false
        else
            return (A.BurstIsON(unit)) or false
        end
        -- AoE Only
    elseif choice[2] then
        -- also checks CDs
        if choice[1] then
            return (A.BurstIsON(unit) and MultiUnits:GetActiveEnemies() > 2 and A.GetToggle(2, "AoE")) or false
        else
            return (MultiUnits:GetActiveEnemies() > 2 and A.GetToggle(2, "AoE")) or false
        end
        -- Everytime
    elseif choice[3] then
        return A.Stormkeeper:IsReady(unit) or false
    else
        return false
    end
    
end

--FlameShockTTD
local function HandleFlameShockTTD()
    local FlameShock = A.GetToggle(2, "FlameShockTTD")
    if     FlameShock >= 0 and 
    (
        (     -- Auto 
            FlameShock >= 100 and 
            (
                -- TTD > 15
                Unit("target"):TimeToDie() > 15
            ) 
        ) or 
        (    -- Custom
            FlameShock < 100 and 
            Unit("target"):HealthPercent() > FlameShock
        )
    ) 
    then 
        return true
    end
end

local function ExpectedCombatLength()
    local BossTTD = 0
    if not A.IsInPvP then 
        for i = 1, MAX_BOSS_FRAMES do 
            if Unit("boss" .. i):IsExists() and not Unit("boss" .. i):IsDead() then 
                BossTTD = Unit("boss" .. i):TimeToDie()
            end 
        end 
    end 
    return BossTTD
end 
ExpectedCombatLength = A.MakeFunctionCachedStatic(ExpectedCombatLength)

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
SelfDefensives = A.MakeFunctionCachedStatic(SelfDefensives)

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
        if useCC and A.Hex:IsReady(unit) and A.Hex:AbsentImun(unit, Temp.TotalAndCC, true) and Unit(unit):IsControlAble("incapacitate", 0) then 
	        -- Notification					
            A.Toaster:SpawnByTimer("TripToast", 0, "Interrupt!", "Interrupting with Hex!", A.Hex.ID)
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

--- ======= ACTION LISTS =======
-- [3] Single Rotation
A[3] = function(icon, isMulti)
    --------------------
    --- ROTATION VAR ---
    --------------------
    local isMoving = Player:IsMoving()
    local inCombat = Unit("player"):CombatTime() > 0
    local ShouldStop = Action.ShouldStop()
    local Pull = Action.BossMods:GetPullTimer()
    local MaelstromPower = Player:Maelstrom()
    -- Trinkets vars
    local Trinket1IsAllowed, Trinket2IsAllowed = TR:TrinketIsAllowed()
    local TrinketsAoE = GetToggle(2, "TrinketsAoE")
	--local TrinketASAP = GetToggle(2, "TrinketASAP")
    local TrinketsMinTTD = GetToggle(2, "TrinketsMinTTD")
    local TrinketsUnitsRange = GetToggle(2, "TrinketsUnitsRange")
    local TrinketsMinUnits = GetToggle(2, "TrinketsMinUnits")
	local UseGhostWolf = Action.GetToggle(2, "UseGhostWolf")	
	local EarthElementalHP = Action.GetToggle(2, "EarthElementalHP")
	local EarthElementalRange = Action.GetToggle(2, "EarthElementalRange")
	local EarthElementalUnits = Action.GetToggle(2, "EarthElementalUnits")	
    ------------------------------------------------------
    ---------------- ENEMY UNIT ROTATION -----------------
    ------------------------------------------------------
    local function EnemyRotation(unit)

    	-- Interrupt
        local Interrupt = Interrupts(unit)
        if Interrupt then 
            return Interrupt:Show(icon)
        end	

		--Earth Elemental calls
		if not inCombat and Unit("player"):HealthPercent() <= EarthElementalHP and GetByRange(EarthElementalUnits, EarthElementalRange) then
			A.EarthElemental:Show(icon)
		end

		--Ghost Wolf calls
		if not inCombat and UseGhostWolf and isMoving then
			A.GhostWolf:Show(icon)
		end	

		-- Lightning Shield
		if Unit("player"):HasBuffs(A.LightningShield.ID, true) == 0 then
			return A.LightningShield:Show(icon)
		end			
		
		--Force AoE opener check
		if A.ChainLightning:IsReady(unit) and A.GetToggle(2, "ForceAoE") and A.GetToggle(2, "AoE") and not inCombat and (A.LastPlayerCastName ~= A.ChainLightning:Info())
		then
			return A.ChainLightning:Show(icon)
		end			

		-- elemental_blast,if=talent.elemental_blast.enabled
		if A.ElementalBlast:IsReady(unit) and (A.ElementalBlast:IsSpellLearned()) and not A.GetToggle(2, "ForceAoE") and
		((Pull > 0.1 and Pull <= A.ElementalBlast:GetSpellCastTime()) or not Action.GetToggle(1, "BossMods")) then
			return A.ElementalBlast:Show(icon)
		end
		
		-- lava_burst,if=!talent.elemental_blast.enabled&spell_targets.chain_lightning<3
		if A.LavaBurst:IsReady(unit) and (not A.ElementalBlast:IsSpellLearned()) and not A.GetToggle(2, "ForceAoE") and
		((Pull > 0.1 and Pull <= A.LavaBurst:GetSpellCastTime()) or not Action.GetToggle(1, "BossMods")) then
			return A.LavaBurst:Show(icon)
		end
		
		--actions+=/flame_shock,if=!ticking
		if A.FlameShock:IsReady(unit) and Unit("target"):HasDeBuffs(A.FlameShockDebuff.ID, true) == 0 and Unit("target"):TimeToDie() >= 15 then
			return A.FlameShock:Show(icon)
		end	
		
		--Static Discharge for whatever reason...
		if A.StaticDischarge:IsReady(unit) then
			return A.StaticDischarge:Show(icon)
		end
	
		--actions+=/fire_elemental
		if BurstIsON and A.FireElemental:IsReady(unit) then 
			return A.FireElemental:Show(icon)
		end
		
		--actions+=/storm_elemental
		if BurstIsON and A.StormElemental:IsReady(unit) then
			return A.StormElemental:Show(icon)
		end

		-- Non SIMC Custom Trinket1
	    if A.Trinket1:IsReady(unit) and Trinket1IsAllowed and CanCast and    
		(
    		TrinketsAoE and GetByRange(TrinketsMinUnits, TrinketsUnitsRange) and Player:AreaTTD(TrinketsUnitsRange) > TrinketsMinTTD
			or
			not TrinketsAoE and Unit(unit):TimeToDie() >= TrinketsMinTTD 					
		)
		then 
      	    return A.Trinket1:Show(icon)
   	    end 		
	        
		
		-- Non SIMC Custom Trinket2
	    if A.Trinket2:IsReady(unit) and Trinket2IsAllowed and CanCast and	    
		(
    		TrinketsAoE and GetByRange(TrinketsMinUnits, TrinketsUnitsRange) and Player:AreaTTD(TrinketsUnitsRange) > TrinketsMinTTD
			or
			not TrinketsAoE and Unit(unit):TimeToDie() >= TrinketsMinTTD 					
		)
		then
      	    return A.Trinket2:Show(icon) 	
	    end
		
		--actions+=/blood_fury,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
		if A.BloodFury:IsReady(unit) and BurstIsON and AutoRacial and (not A.Ascendance:IsSpellLearned() or Unit("player"):HasBuffs(A.AscendanceBuff.ID) > 0 or A.Ascendance:GetCooldown() > 50) then
			return A.BloodFury:Show(icon)
		end
		
		--actions+=/berserking,if=!talent.ascendance.enabled|buff.ascendance.up
		if A.Berserking:IsReady(unit) and BurstIsON and AutoRacial and (not A.Ascendance:IsSpellLearned() or Unit("player"):HasBuffs(A.AscendanceBuff.ID) > 0) then
			return A.Berserking:Show(icon)
		end		
		
		--actions+=/fireblood,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
		if A.Fireblood:IsReady(unit) and BurstIsON and AutoRacial and (not A.Ascendance:IsSpellLearned() or Unit("player"):HasBuffs(A.AscendanceBuff.ID) > 0 or A.Ascendance:GetCooldown() > 50) then
			return A.Fireblood:Show(icon)
		end				
		
		--actions+=/ancestral_call,if=!talent.ascendance.enabled|buff.ascendance.up|cooldown.ascendance.remains>50
		if A.AncestralCall:IsReady(unit) and BurstIsON and AutoRacial and (not A.Ascendance:IsSpellLearned() or Unit("player"):HasBuffs(A.AscendanceBuff.ID) > 0 or A.Ascendance:GetCooldown() > 50) then
			return A.AncestralCall:Show(icon)
		end			
		
		--actions+=/bag_of_tricks,if=!talent.ascendance.enabled|!buff.ascendance.up
		if A.BagofTricks:IsReady(unit) and BurstIsON and AutoRacial and (not A.Ascendance:IsSpellLearned() or Unit("player"):HasBuffs(A.AscendanceBuff.ID) == 0) then
			return A.BagofTricks:Show(icon)
		end	

		-- guardian_of_azeroth
		if A.GuardianofAzeroth:AutoHeartOfAzerothP(unit, true) and A.BurstIsON(unit) then
			return A.Darkflight:Show(icon)
		end
		
		-- focused_azerite_beam
		if A.FocusedAzeriteBeam:AutoHeartOfAzerothP(unit, true) and A.BurstIsON(unit) then
			return A.Darkflight:Show(icon)
		end
		
		-- memory_of_lucid_dreams
		if A.MemoryofLucidDreams:AutoHeartOfAzerothP(unit, true) and A.BurstIsON(unit) then
			return A.Darkflight:Show(icon)
		end
		
		-- blood_of_the_enemy
		if A.BloodoftheEnemy:AutoHeartOfAzerothP(unit, true) and A.BurstIsON(unit) then
			return A.Darkflight:Show(icon)
		end
		
		-- purifying_blast
		if A.PurifyingBlast:AutoHeartOfAzerothP(unit, true) and A.BurstIsON(unit) then
			return A.Darkflight:Show(icon)
		end
		
		--[[ ripple_in_space
		if A.RippleInSpace:AutoHeartOfAzerothP(unit, true) and HeartOfAzeroth then
			return A.Darkflight:Show(icon)
		end]]
		
		-- concentrated_flame,line_cd=6
		if A.ConcentratedFlame:AutoHeartOfAzerothP(unit, true) and A.BurstIsON(unit) then
			return A.Darkflight:Show(icon)
		end
		
		-- reaping_flames
		if A.ReapingFlames:IsReady(unit) and A.BurstIsON(unit) then
			return A.Darkflight:Show(icon)
		end
		
		-- the_unbound_force,if=buff.reckless_force.up
		if A.TheUnboundForce:AutoHeartOfAzerothP(unit, true) and A.BurstIsON(unit) and (Unit("player"):HasBuffs(A.RecklessForceBuff.ID, true)) then
			return A.Darkflight:Show(icon)
		end
		
		-- worldvein_resonance
		if A.WorldveinResonance:AutoHeartOfAzerothP(unit, true) and A.BurstIsON(unit) then
			return A.Darkflight:Show(icon)
		end
		
		--[[actions+=/primordial_wave,if=covenant.necrolord
		if A.PrimordialWave:IsReady() then
			return A.PrimordialWave:Show(icon)
		end
		
		--actions+=/vesper_totem,if=covenant.kyrian
		if A.VesperTotem:IsReady() then
			return A.VesperTotem:Show(icon)
		end		
		
		--actions+=/chain_harvest,if=covenant.venthyr
		if A.ChainHarvest:IsReady() then
			return A.ChainHarvest:Show(icon)
		end		
		
		--actions+=/fae_transfusion,if=covenant.night_fae
		if A.FaeTransfusion:IsReady() then
			return A.FaeTransfusion:Show(icon)
		end		]]
		
		--[[actions+=/run_action_list,name=single_target,if=active_enemies<=2
		if MultiUnits:GetActiveEnemies() <= 2 then
			return SingleRotation()
		end]]		

			local function AoERotation(unit)
			
				--actions.aoe=stormkeeper,if=talent.stormkeeper.enabled
				if A.Stormkeeper:IsReady(unit) then
					return A.Stormkeeper:Show(icon)
				end
				
				--actions.aoe+=/flame_shock,target_if=refreshable
				if A.FlameShock:IsReady(unit) and (Unit("target"):HasDeBuffs(A.FlameShockDebuff.ID, true) == 0 or Unit("target"):HasDeBuffs(A.FlameShockDebuff.ID, true) < 4) and Unit("target"):TimeToDie() >= 15 then
					return A.FlameShock:Show(icon)
				end
				
				--actions.aoe+=/liquid_magma_totem,if=talent.liquid_magma_totem.enabled
				if A.LiquidMagmaTotem:IsReady(unit) then
					return A.LiquidMagmaTotem:Show(icon)
				end
				
				--actions.aoe+=/lava_burst,if=talent.master_of_the_elements.enabled&maelstrom>=50&buff.lava_surge.up
				if A.LavaBurst:IsReady(unit) and A.MasteroftheElements:IsSpellLearned() and Player:Maelstrom() >= 50 and Unit("player"):HasBuffs(A.LavaSurgeBuff.ID, true) > 0 then
					return A.LavaBurst:Show(icon)
				end
				
				--actions.aoe+=/echoing_shock,if=talent.echoing_shock.enabled
				if A.EchoingShock:IsReady(unit) then
					return A.EchoingShock:Show(icon)
				end	
				
				--actions.aoe+=/earthquake
				if A.Earthquake:IsReady(unit) then
					return A.Earthquake:Show(icon)
				end
				
				--actions.aoe+=/chain_lightning
				if A.ChainLightning:IsReady(unit) or A.LavaBeam:IsReady(unit) then
					return A.ChainLightning:Show(icon)
				end	
			end

			local function SingleRotation(unit)

				--actions.single_target=flame_shock,target_if=refreshable
				if A.FlameShock:IsReady(unit) and (Unit("target"):HasDeBuffs(A.FlameShockDebuff.ID, true) == 0 or Unit("target"):HasDeBuffs(A.FlameShockDebuff.ID, true) < 4) and Unit("target"):TimeToDie() >= 15 then
					return A.FlameShock:Show(icon)
				end
				
				--actions.single_target+=/elemental_blast,if=talent.elemental_blast.enabled
				if A.ElementalBlast:IsReady(unit) then
					return A.ElementalBlast:Show(icon)
				end	
				
				--actions.single_target+=/stormkeeper,if=talent.stormkeeper.enabled
				if A.Stormkeeper:IsReady(unit) then
					return A.Stormkeeper:Show(icon)
				end				
				
				--actions.single_target+=/liquid_magma_totem,if=talent.liquid_magma_totem.enabled
				if A.LiquidMagmaTotem:IsReady(unit) then
					return A.LiquidMagmaTotem:Show(icon)
				end				
				
				--actions.single_target+=/echoing_shock,if=talent.echoing_shock.enabled
				if A.EchoingShock:IsReady(unit) then
					return A.EchoingShock:Show(icon)
				end					
				
				--actions.single_target+=/ascendance,if=talent.ascendance.enabled
				if A.Ascendance:IsReady(unit) and BurstIsON then
					return A.Ascendance:Show(icon)
				end	
				
				--actions.single_target+=/lava_burst,if=cooldown_react
				if A.LavaBurst:IsReady(unit) then
					return A.LavaBurst:Show(icon)
				end	
				
				--actions.single_target+=/earthquake,if=(spell_targets.chain_lightning>1&!runeforge.echoes_of_great_sundering.equipped|buff.echoes_of_great_sundering.up)
					--SL legendary condition
				
				--actions.single_target+=/earth_shock
				if A.EarthShock:IsReady(unit) then
					return A.EarthShock:Show(icon)
				end	
				
				--actions.single_target+=/lightning_lasso
				if A.LightningLasso:IsReady(unit) then
					return A.LightningLasso:Show(icon)
				end	
				
				--actions.single_target+=/frost_shock,if=talent.icefury.enabled&buff.icefury.up
				if A.FrostShock:IsReady(unit) and Unit("player"):HasBuffs(A.IcefuryBuff.ID, true) > 0 then
					return A.FrostShock:Show(icon)
				end	
				
				--actions.single_target+=/icefury,if=talent.icefury.enabled
				if A.Icefury:IsReady(unit) then
					return A.Icefury:Show(icon)
				end	
				
				--actions.single_target+=/lightning_bolt
				if A.LightningBolt:IsReady(unit) then
					return A.LightningBolt:Show(icon)
				end
			
			end
			
			local function MovingRotation(unit)
			
				--actions.single_target+=/flame_shock,moving=1,target_if=refreshable
				if A.FlameShock:IsReady(unit) and (Unit("target"):HasDeBuffs(A.FlameShockDebuff.ID, true) == 0 or Unit("target"):HasDeBuffs(A.FlameShockDebuff.ID, true) < 4) and Unit("target"):TimeToDie() >= 15 then
					return A.FlameShock:Show(icon)
				end				

				--actions.single_target+=/frost_shock,moving=1			
				if A.FrostShock:IsReady(unit) then
					return A.FrostShock:Show(icon)
				end	
				
			end
        
        --[[call precombat
        if not inCombat and Unit(unit):IsExists() then 
            local ShouldReturn = Precombat(unit); if ShouldReturn then return ShouldReturn; end
        end]]
		
		--moving check
		if isMoving then
			return MovingRotation()
		end	
		
		--actions+=/run_action_list,name=aoe,if=active_enemies>2&(spell_targets.chain_lightning>2|spell_targets.lava_beam>2)
		if MultiUnits:GetActiveEnemies() > 2 then
			return AoERotation()
			else
			return SingleRotation()
		end		
        
        -- In Combat
        if inCombat and Unit(unit):IsExists() then
            
            -- Interrupt Handler          
            local unit = "target"
            local useKick, useCC, useRacial = Action.InterruptIsValid(unit, "TargetMouseover")    
            local Trinket1IsAllowed, Trinket2IsAllowed = TR.TrinketIsAllowed()
            
            -- WindShear
            if useKick and A.WindShear:IsReady(unit) and not ShouldStop then 
                if Unit(unit):CanInterrupt(true, nil, 25, 70) then
                    return A.WindShear:Show(icon)
                end 
            end    
		
        end

    end
    
    -- End on EnemyRotation()
    
    -- Mouseover DPS Rotation
    -- Only handling mouseover multidots and dots refreshable
    local function MouseoverRotation(unit)
        
        -- Variables
        inRange = A.ChainLightning:IsInRange(unit)
        
        -- Note: Toggles  ("UseDispel", "UsePurge", "UseExpelEnrage")
        -- Category ("Dispel", "MagicMovement", "PurgeFriendly", "PurgeHigh", "PurgeLow", "Enrage")
        -- Purge
        if A.Purge:IsReady(unit) and Action.GetToggle(2, "mouseover") and not ShouldStop and Action.AuraIsValid(unit, "UsePurge", "PurgeHigh") then
            return A.Purge:Show(icon)
        end    
        
        -- WindShear
        if useKick and A.WindShear:IsReady(unit) and not ShouldStop then 
            if Unit(unit):CanInterrupt(true, nil, 25, 70) then
                return A.WindShear:Show(icon)
            end 
        end                   
        
    end
    
    -- FriendlyTeam Rotation
    -- Only handling mouseover multidots and dots refreshable
    local function FriendlyRotation()
        -- AncestralGuidance
        local AncestralGuidance = A.GetToggle(2, "AncestralGuidanceHP")
        if HandleAncestralGuidance() and
        AncestralGuidance >= 0 and A.AncestralGuidance:IsReady("player") and 
        (
            (    -- Auto 
                AncestralGuidance >= 100 and 
                (
                    A.HealingEngine.GetIncomingDMGAVG() >= 35
                )
            ) or 
            (    -- Custom
                AncestralGuidance < 100 and 
                -- HP lose per sec >= 40
                A.HealingEngine.GetIncomingDMGAVG() >= AncestralGuidance
            )
        ) 
        then 
            return A.AncestralGuidance
        end    
    end
    
    -- Friendly Rotation
    if FriendlyRotation() then
        return true
    end
    
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

-- [4] AoE Rotation
A[4] = function(icon)
    return A[3](icon, true)
end
-- [5] Trinket Rotation
-- No specialization trinket actions 
-- Passive 
--[[
local function FreezingTrapUsedByEnemy()
    if     UnitCooldown:GetCooldown("arena", 3355) > UnitCooldown:GetMaxDuration("arena", 3355) - 2 and
    UnitCooldown:IsSpellInFly("arena", 3355) and 
    Unit("player"):GetDR("incapacitate") >= 50 
    then 
        local Caster = UnitCooldown:GetUnitID("arena", 3355)
        if Caster and Unit(Caster):GetRange() <= 40 then 
            return true 
        end 
    end 
end 
local function ArenaRotation(icon, unit)
    if A.IsInPvP and (A.Zone == "pvp" or A.Zone == "arena") and not Player:IsStealthed() and not Player:IsMounted() then
        -- Note: "arena1" is just identification of meta 6
        if (unit == "arena1" or unit == "arena2" or unit == "arena3") then 
			-- Interrupt
   		    local Interrupt = Interrupts(unit)
  		    if Interrupt then 
  		        return Interrupt:Show(icon)
  		    end	
        end
    end 
end 
local function PartyRotation(unit)
    if (unit == "party1" and not Action.GetToggle(2, "PartyUnits")[1]) or (unit == "party2" and not Action.GetToggle(2, "PartyUnits")[2]) then 
        return false 
    end

  	-- CleanseSpirit
    if A.CleanseSpirit:IsReady(unit) and A.CleanseSpirit:AbsentImun(unit, Temp.TotalAndMag) and Action.AuraIsValid(unit, "UseDispel", "Magic") and not Unit(unit):InLOS() then
        return A.CleanseSpirit
    end
end 

A[6] = function(icon)
    return ArenaRotation(icon, "arena1")
end

A[7] = function(icon)
    local Party = PartyRotation("party1") 
    if Party then 
        return Party:Show(icon)
    end 
    return ArenaRotation(icon, "arena2")
end

A[8] = function(icon)
    local Party = PartyRotation("party2") 
    if Party then 
        return Party:Show(icon)
    end     
    return ArenaRotation(icon, "arena3")
end]]--