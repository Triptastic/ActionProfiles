--#####################################
--##### TRIP'S AFFLICTION WARLOCK #####
--#####################################

local _G, setmetatable                            = _G, setmetatable
local A                                         = _G.Action
local Covenant                                    = _G.LibStub("Covenant")
local TMW                                        = _G.TMW
local Listener                                    = Action.Listener
local Create                                    = Action.Create
local GetToggle                                    = Action.GetToggle
local SetToggle                                    = Action.SetToggle
local GetGCD                                    = Action.GetGCD
local GetCurrentGCD                                = Action.GetCurrentGCD
local GetPing                                    = Action.GetPing
local ShouldStop                                = Action.ShouldStop
local BurstIsON                                    = Action.BurstIsON
local CovenantIsON                                = Action.CovenantIsON
local AuraIsValid                                = Action.AuraIsValid
local AuraIsValidByPhialofSerenity				= A.AuraIsValidByPhialofSerenity
local InterruptIsValid                            = Action.InterruptIsValid
local FrameHasSpell                             = Action.FrameHasSpell
local Utils                                        = Action.Utils
local TeamCache                                    = Action.TeamCache
local EnemyTeam                                    = Action.EnemyTeam
local FriendlyTeam                                = Action.FriendlyTeam
local LoC                                        = Action.LossOfControl
local Player                                    = Action.Player
local Pet                                       = LibStub("PetLibrary") 
local MultiUnits                                = Action.MultiUnits
local UnitCooldown                                = Action.UnitCooldown
local Unit                                        = Action.Unit 
local IsUnitEnemy                                = Action.IsUnitEnemy
local IsUnitFriendly                            = Action.IsUnitFriendly
local ActiveUnitPlates                          = MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit                     = IsIndoors, UnitIsUnit
local pairs                                     = pairs

--For Toaster
local Toaster                                    = _G.Toaster
local GetSpellTexture                             = _G.TMW.GetSpellTexture

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

Action[ACTION_CONST_WARLOCK_AFFLICTION] = {
    -- Racial
    ArcaneTorrent                = Action.Create({ Type = "Spell", ID = 50613    }),
    BloodFury                    = Action.Create({ Type = "Spell", ID = 20572    }),
    Fireblood                    = Action.Create({ Type = "Spell", ID = 265221    }),
    AncestralCall                = Action.Create({ Type = "Spell", ID = 274738    }),
    Berserking                    = Action.Create({ Type = "Spell", ID = 26297    }),
    ArcanePulse                 = Action.Create({ Type = "Spell", ID = 260364    }),
    QuakingPalm                   = Action.Create({ Type = "Spell", ID = 107079    }),
    Haymaker                       = Action.Create({ Type = "Spell", ID = 287712    }), 
    BullRush                       = Action.Create({ Type = "Spell", ID = 255654    }),    
    WarStomp                    = Action.Create({ Type = "Spell", ID = 20549    }),
    GiftofNaaru                   = Action.Create({ Type = "Spell", ID = 59544    }),
    Shadowmeld                   = Action.Create({ Type = "Spell", ID = 58984    }),
    Stoneform                     = Action.Create({ Type = "Spell", ID = 20594    }), 
    BagofTricks                    = Action.Create({ Type = "Spell", ID = 312411    }),
    WilloftheForsaken            = Action.Create({ Type = "Spell", ID = 7744        }),   
    EscapeArtist                = Action.Create({ Type = "Spell", ID = 20589    }), 
    EveryManforHimself            = Action.Create({ Type = "Spell", ID = 59752    }), 
    
    --Warlock General
    Banish                         = Action.Create({ Type = "Spell", ID = 710        }),
    Corruption                    = Action.Create({ Type = "Spell", ID = 172        }),
    CorruptionDebuff            = Action.Create({ Type = "Spell", ID = 146739, Hidden = true    }),
    CreateHealthstone           = Action.Create({ Type = "Spell", ID = 6201        }),
    CreateSoulwell                = Action.Create({ Type = "Spell", ID = 29893    }),
    CurseofExhaustion               = Action.Create({ Type = "Spell", ID = 334275    }),
    CurseofTongues                = Action.Create({ Type = "Spell", ID = 1714        }),
    CurseofWeakness                = Action.Create({ Type = "Spell", ID = 702        }),
    DemonicCircle                = Action.Create({ Type = "Spell", ID = 48018    }),
    DemonicCircleTeleport        = Action.Create({ Type = "Spell", ID = 48020    }),    
    DemonicGateway                = Action.Create({ Type = "Spell", ID = 111771    }),    
    DrainLife                    = Action.Create({ Type = "Spell", ID = 234153    }),
    EyeofKilrogg                = Action.Create({ Type = "Spell", ID = 126        }),
    Fear                        = Action.Create({ Type = "Spell", ID = 5782        }),
    FelDomination                = Action.Create({ Type = "Spell", ID = 333889    }),    
    HealthFunnel                = Action.Create({ Type = "Spell", ID = 755        }),    
    RitualofDoom                = Action.Create({ Type = "Spell", ID = 342601    }),    
    RitualofSummoning            = Action.Create({ Type = "Spell", ID = 698        }),    
    ShadowBolt                    = Action.Create({ Type = "Spell", ID = 686        }),    
    Shadowfury                    = Action.Create({ Type = "Spell", ID = 30283    }),    
    Soulstone                    = Action.Create({ Type = "Spell", ID = 20707    }),    
    SubjugateDemon                = Action.Create({ Type = "Spell", ID = 1098        }),    
    UnendingBreath                = Action.Create({ Type = "Spell", ID = 5697        }),    
    UnendingResolve                = Action.Create({ Type = "Spell", ID = 104773    }),    
    
    --Pet Summon
    SummonImp                    = Action.Create({ Type = "Spell", ID = 688        }),    
    SummonVoidwalker            = Action.Create({ Type = "Spell", ID = 697        }),
    SummonFelhunter                = Action.Create({ Type = "Spell", ID = 691        }),
    SummonSuccubus                = Action.Create({ Type = "Spell", ID = 712        }),    
    CommandDemon                = Action.Create({ Type = "Spell", ID = 119898    }),    
    SingeMagic                    = Action.Create({ Type = "Spell", ID = 119905    }),    
    ShadowBulwark                = Action.Create({ Type = "Spell", ID = 119907    }),    
    SpellLock                    = Action.Create({ Type = "Spell", ID = 119910    }),    
    Seduction                    = Action.Create({ Type = "Spell", ID = 119909    }),    
    
    --Affliction Spells
    Agony                        = Action.Create({ Type = "Spell", ID = 980        }),
    AgonyDebuff                    = Action.Create({ Type = "Spell", ID = 980, Hidden = true        }),
    MaleficRapture                = Action.Create({ Type = "Spell", ID = 324536, Hidden = true    }),
    SeedofCorruption            = Action.Create({ Type = "Spell", ID = 27243    }),
    SeedofCorruptionDebuff        = Action.Create({ Type = "Spell", ID = 27243, Hidden = true        }),
    SummonDarkglare                = Action.Create({ Type = "Spell", ID = 205180    }),
    UnstableAffliction            = Action.Create({ Type = "Spell", ID = 316099    }),
    UnstableAfflictionDebuff    = Action.Create({ Type = "Spell", ID = 316099, Hidden = true    }),
    ShadowEmbrace                = Action.Create({ Type = "Spell", ID = 32390, Hidden = true        }),    
    
    --Normal Talents
    Nightfall                    = Action.Create({ Type = "Spell", ID = 108558, Hidden = true    }),
    NightfallBuff                = Action.Create({ Type = "Spell", ID = 264571, Hidden = true    }),
    InevitableDemise            = Action.Create({ Type = "Spell", ID = 334319, Hidden = true    }),
    InevitableDemiseBuff        = Action.Create({ Type = "Spell", ID = 273525, Hidden = true    }),
    DrainSoul                    = Action.Create({ Type = "Spell", ID = 198590    }),
    WritheInAgony                = Action.Create({ Type = "Spell", ID = 196102    }),
    AbsoluteCorruption            = Action.Create({ Type = "Spell", ID = 196103    }),
    SiphonLife                    = Action.Create({ Type = "Spell", ID = 63106    }),
    SiphonLifeDebuff            = Action.Create({ Type = "Spell", ID = 63106, Hidden = true        }),    
    DemonSkin                    = Action.Create({ Type = "Spell", ID = 219272, Hidden = true    }),
    BurningRush                    = Action.Create({ Type = "Spell", ID = 111400    }),
    DarkPact                    = Action.Create({ Type = "Spell", ID = 108416    }),
    SowtheSeeds                    = Action.Create({ Type = "Spell", ID = 196226, Hidden = true    }),
    PhantomSingularity            = Action.Create({ Type = "Spell", ID = 205179    }),
    PhantomSingularityDebuff    = Action.Create({ Type = "Spell", ID = 205179, Hidden = true    }),    
    VileTaint                    = Action.Create({ Type = "Spell", ID = 278350    }),
    Darkfury                    = Action.Create({ Type = "Spell", ID = 264874, Hidden = true    }),
    MortalCoil                    = Action.Create({ Type = "Spell", ID = 6789        }),
    HowlofTerror                = Action.Create({ Type = "Spell", ID = 5484        }),
    DarkCaller                    = Action.Create({ Type = "Spell", ID = 334183, Hidden = true    }),
    Haunt                        = Action.Create({ Type = "Spell", ID = 48181    }),
    GrimoireofSacrifice            = Action.Create({ Type = "Spell", ID = 108503    }),
    GrimoireofSacrificeBuff        = Action.Create({ Type = "Spell", ID = 196099, Hidden = true    }),
    SoulConduit                    = Action.Create({ Type = "Spell", ID = 215941, Hidden = true    }),
    CreepingDeath                = Action.Create({ Type = "Spell", ID = 264000, Hidden = true    }),
    DarkSoulMisery                = Action.Create({ Type = "Spell", ID = 113860    }),
    
    --PvP Talents
    BaneofFragility                = Action.Create({ Type = "Spell", ID = 199954    }),
    Deathbolt                    = Action.Create({ Type = "Spell", ID = 264106    }),
    Soulshatter                    = Action.Create({ Type = "Spell", ID = 212356    }),
    GatewayMastery                = Action.Create({ Type = "Spell", ID = 248855, Hidden = true    }),
    RotandDecay                    = Action.Create({ Type = "Spell", ID = 212371, Hidden = true    }),
    BaneofShadows                = Action.Create({ Type = "Spell", ID = 234877    }),
    NetherWard                    = Action.Create({ Type = "Spell", ID = 212295    }),
    EssenceDrain                = Action.Create({ Type = "Spell", ID = 221711, Hidden = true    }),
    CastingCircle                = Action.Create({ Type = "Spell", ID = 221703    }),
    DemonArmor                    = Action.Create({ Type = "Spell", ID = 285933    }),
    AmplifyCurse                = Action.Create({ Type = "Spell", ID = 328774    }),
    RampantAfflictions            = Action.Create({ Type = "Spell", ID = 335052, Hidden = true    }),
    RapidContagion                = Action.Create({ Type = "Spell", ID = 344566    }),
    
    -- Covenant Abilities
    ScouringTithe                = Action.Create({ Type = "Spell", ID = 312321    }),
    SummonSteward                = Action.Create({ Type = "Spell", ID = 324739    }),
    ImpendingCatastrophe        = Action.Create({ Type = "Spell", ID = 321792    }),
    DoorofShadows                = Action.Create({ Type = "Spell", ID = 300728    }),
    DecimatingBolt                = Action.Create({ Type = "Spell", ID = 325289    }),
    Fleshcraft                    = Action.Create({ Type = "Spell", ID = 331180    }),
    SoulRot                        = Action.Create({ Type = "Spell", ID = 325640    }),
    Soulshape                    = Action.Create({ Type = "Spell", ID = 310143    }),
    Flicker                        = Action.Create({ Type = "Spell", ID = 324701    }),
    
    -- Conduits
    ColdEmbrace                    = Action.Create({ Type = "Spell", ID = 339576, Hidden = true    }),    
    CorruptingLeer                = Action.Create({ Type = "Spell", ID = 339455, Hidden = true    }),    
    FocusedMalignancy            = Action.Create({ Type = "Spell", ID = 339500, Hidden = true    }),    
    RollingAgony                = Action.Create({ Type = "Spell", ID = 339481, Hidden = true    }),    
    SoulTithe                    = Action.Create({ Type = "Spell", ID = 340229, Hidden = true    }),    
    CatastrophicOrigin            = Action.Create({ Type = "Spell", ID = 340316, Hidden = true    }),    
    FatalDecimation                = Action.Create({ Type = "Spell", ID = 340268, Hidden = true    }),    
    SoulEater                    = Action.Create({ Type = "Spell", ID = 340348, Hidden = true    }),    
    AccruedVitality                = Action.Create({ Type = "Spell", ID = 339282, Hidden = true    }),    
    DiabolicBloodstone            = Action.Create({ Type = "Spell", ID = 340562, Hidden = true    }),    
    ResoluteBarrier                = Action.Create({ Type = "Spell", ID = 339272, Hidden = true    }),    
    DemonicMomentum                = Action.Create({ Type = "Spell", ID = 339411, Hidden = true    }),    
    FelCelerity                    = Action.Create({ Type = "Spell", ID = 339130, Hidden = true    }),    
    ShadeofTerror                = Action.Create({ Type = "Spell", ID = 339379, Hidden = true    }),    
    KilroggsCunning                = Action.Create({ Type = "Spell", ID = 58081, Hidden = true        }),    
    
    
    
    -- Legendaries
    -- General Legendaries
    ClawofEndereth                = Action.Create({ Type = "Spell", ID = 337038, Hidden = true    }),
    PillarsoftheDarkPortal        = Action.Create({ Type = "Spell", ID = 337065, Hidden = true    }),
    RelicofDemonicSynergy        = Action.Create({ Type = "Spell", ID = 337057, Hidden = true    }),
    WilfredsSigil                = Action.Create({ Type = "Spell", ID = 337020, Hidden = true    }),
    --Affliction
    MaleficWrath                = Action.Create({ Type = "Spell", ID = 337122, Hidden = true    }),
    PerpetualAgony                = Action.Create({ Type = "Spell", ID = 337106, Hidden = true    }),
    SacrolashsDarkStrike        = Action.Create({ Type = "Spell", ID = 337111, Hidden = true    }),
    WrathofConsumption            = Action.Create({ Type = "Spell", ID = 337128, Hidden = true    }),
    
    
    --Anima Powers - to add later...
    
    
    -- Trinkets
    
    
    -- Potions
    PotionofUnbridledFury            = Action.Create({ Type = "Potion", ID = 169299, QueueForbidden = true }),     
    SuperiorPotionofUnbridledFury    = Action.Create({ Type = "Potion", ID = 168489, QueueForbidden = true }),
    PotionofSpectralIntellect        = Action.Create({ Type = "Potion", ID = 171273, QueueForbidden = true }),
    PotionofSpectralStamina            = Action.Create({ Type = "Potion", ID = 171274, QueueForbidden = true }),
    PotionofEmpoweredExorcisms        = Action.Create({ Type = "Potion", ID = 171352, QueueForbidden = true }),
    PotionofHardenedShadows            = Action.Create({ Type = "Potion", ID = 171271, QueueForbidden = true }),
    PotionofPhantomFire                = Action.Create({ Type = "Potion", ID = 171349, QueueForbidden = true }),
    PotionofDeathlyFixation            = Action.Create({ Type = "Potion", ID = 171351, QueueForbidden = true }),
    SpiritualHealingPotion            = Action.Create({ Type = "Potion", ID = 171267, QueueForbidden = true }),   
    
	HealthStoneItem					= Action.Create({ Type = "Item", ID = 5512, Hidden = true }), -- Just for notification icon really    
	
    -- Extra icons until GG update
    SpatialRift                        = Action.Create({ Type = "Spell", ID = 256948     }), -- used for Malefic Rapture
    Darkflight                        = Action.Create({ Type = "Spell", ID = 68992     }), -- used for Heart of Azeroth    
    RocketJump                        = Action.Create({ Type = "Spell", ID = 69070     }), -- used for FelDomination
    StopCast                        = Action.Create({ Type = "Spell", ID = 61721, Hidden = true    }),
	
    
}

-- To create essences use next code:
Action:CreateEssencesFor(ACTION_CONST_WARLOCK_AFFLICTION)        -- where PLAYERSPEC is Constance (example: ACTION_CONST_MONK_BM)
local A = setmetatable(Action[ACTION_CONST_WARLOCK_AFFLICTION], { __index = Action })

-- Used for VisionofPerfectionMinor check
local function DetermineEssenceRanks()
    A.VisionofPerfectionMinor = A.VisionofPerfectionMinor2:IsSpellLearned() and A.VisionofPerfectionMinor2 or A.VisionofPerfectionMinor
    A.VisionofPerfectionMinor = A.VisionofPerfectionMinor3:IsSpellLearned() and A.VisionofPerfectionMinor3 or A.VisionofPerfectionMinor
end
DetermineEssenceRanks = A.MakeFunctionCachedStatic(DetermineEssenceRanks)

local player = "player"


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
    CastStartTime                           = {},
    UnstableAfflictionDelay                    = 0,
    SeedofCorruptionDelay                    = 0,
}

local IsIndoors, UnitIsUnit, UnitName = IsIndoors, UnitIsUnit, UnitName



local function IsSchoolFree()
    return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "SHADOW") == 0
end 

-- Pet Handler UI (Thanks Taste)--
local function HandlePetChoice()
    local choice = Action.GetToggle(2, "PetChoice")
    local currentspell = "Spell(688)"
    
    if choice == "IMP" then
        --print("IMP")
        currentspell = "Spell(688)"    
    elseif choice == "VOIDWALKER" then
        --print("VOIDWALKER")
        currentspell = "Spell(697)"
    elseif choice == "FELHUNTER" then 
        --print("FELHUNTER")    
        currentspell = "Spell(691)"
    elseif choice == "SUCCUBUS" then 
        --print("SUCCUBUS")    
        currentspell = "Spell(712)"
    else
        print("No Pet Data")
    end
    return choice
end

local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
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

-- Non GCD spell check
local function countInterruptGCD(unit)
    if not A.SpellLock:IsReadyByPassCastGCD(unit) or not A.SpellLock:AbsentImun(unit, Temp.TotalAndMagKick) then
        return true
    end
end

-- Interrupts spells
local function Interrupts(unit)
    
    local unit
    if A.IsUnitEnemy("mouseover") then 
        unit = "mouseover"
    elseif A.IsUnitEnemy("target") then 
        unit = "target"
    end  
    
    useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, nil, nil, countInterruptGCD("target"))
    
    if castRemainsTime >= A.GetLatency() then
        -- SpellLock
        if useKick and not notInterruptable and A.SpellLock:IsReady(unit) then 
            return A.PetKick
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
    
    -- UnendingResolve
    local UnendingResolve = A.GetToggle(2, "UnendingResolve")
    if     UnendingResolve >= 0 and A.UnendingResolve:IsReady("player") and 
    (
        (     -- Auto 
            UnendingResolve >= 100 and 
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
            UnendingResolve < 100 and 
            Unit("player"):HealthPercent() <= UnendingResolve
        )
    ) 
    then 
        return A.UnendingResolve
    end     

	if not Player:IsStealthed() then 	
		-- Healthstone | AbyssalHealingPotion
		local Healthstone = GetToggle(1, "HealthStone") 
		if Healthstone >= 0 then 
			if A.HS:IsReady(player) then 					
				if Healthstone >= 100 then -- AUTO 
					if Unit(player):TimeToDie() <= 9 and Unit(player):HealthPercent() <= 40 then
						A.Toaster:SpawnByTimer("TripToast", 0, "Healthstone!", "Using Healthstone!", A.HealthStoneItem.ID)						
						return A.HS
					end 
				elseif Unit(player):HealthPercent() <= Healthstone then 
					A.Toaster:SpawnByTimer("TripToast", 0, "Healthstone!", "Using Healthstone!", A.HealthStoneItem.ID)				
					return A.HS							 
				end
			elseif A.Zone ~= "arena" and (A.Zone ~= "pvp" or not InstanceInfo.isRated) and A.SpiritualHealingPotion:IsReady(player) then 
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
		
		-- PhialofSerenity
		if A.Zone ~= "arena" and (A.Zone ~= "pvp" or not InstanceInfo.isRated) and A.PhialofSerenity:IsReady(player) then 
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


-- [2] Kick AntiFake Rotation
A[2] = nil


-- [3] Single Rotation
A[3] = function(icon, isMulti)
    
    --------------------
    ---  VARIABLES   ---
    --------------------
    local isMoving = A.Player:IsMoving()
    local UseAoE = A.GetToggle(2, "AoE")
    local inCombat = Unit("player"):CombatTime() > 0
    local Pull = Action.BossMods:GetPullTimer()
    local profileStop = false    
    local TargetsMissingAgony = MultiUnits:GetByRangeMissedDoTs(nil, 5, A.AgonyDebuff.ID)
    local AutoMultiDot = A.GetToggle(2, "AutoMultiDot")
    local DrainLifeHP = A.GetToggle(2, "DrainLifeHP")    
    local HealthFunnelHP = A.GetToggle(2, "HealthFunnelHP")
    local UseCov = A.GetToggle(1, "Covenant")
    
    --Refreshables
    SiphonLifeRefreshable = (Unit("target"):HasDeBuffs(A.SiphonLifeDebuff.ID, true) == 0 or Unit("target"):HasDeBuffs(A.SiphonLifeDebuff.ID, true) < 4) and Player:GetDeBuffsUnitCount(A.SiphonLifeDebuff.ID) <= 3
    CorruptionRefreshable = (Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID, true) == 0 or Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID, true) < 2)
    AgonyRefreshable = (Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) == 0 or Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) < 4) and Player:GetDeBuffsUnitCount(A.AgonyDebuff.ID) <= 7 
    
    
    HasAllDots = (Unit("target"):HasDeBuffs(A.SiphonLifeDebuff.ID, true) > 0 and A.SiphonLife:IsTalentLearned()) and (Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID, true) > 0 or Player:GetDeBuffsUnitCount(A.SeedofCorruptionDebuff.ID) >= 1) and Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) > 0 
    
    Dotcap = Player:GetDeBuffsUnitCount(A.SiphonLifeDebuff.ID) <= 3 or Player:GetDeBuffsUnitCount(A.AgonyDebuff.ID) <= 7 
    
    
    -- Pet Selection Menu (Thanks Taste)
    local PetSpell = HandlePetChoice()    
    if PetSpell == "IMP" then
        SummonPet = A.SummonImp    
    elseif PetSpell == "VOIDWALKER" then
        SummonPet = A.SummonVoidwalker
    elseif PetSpell == "FELHUNTER" then    
        SummonPet = A.SummonFelhunter
    elseif PetSpell == "SUCCUBUS" then     
        SummonPet = A.SummonSuccubus
    else
        Action.Print("Error : You have to select Pet in UI Settings.") 
    end    
    
    --UA Delay count
    if Temp.UnstableAfflictionDelay == 0 and Unit(player):IsCasting() == A.UnstableAffliction:Info() then
        Temp.UnstableAfflictionDelay = 90
    end
    
    if Temp.UnstableAfflictionDelay > 0 then
        Temp.UnstableAfflictionDelay = Temp.UnstableAfflictionDelay - 1
    end
    
    --SoC Delay count
    if Temp.SeedofCorruptionDelay == 0 and Unit(player):IsCasting() == A.SeedofCorruption:Info() then
        Temp.SeedofCorruptionDelay = 90
    end
    
    if Temp.SeedofCorruptionDelay > 0 then
        Temp.SeedofCorruptionDelay = Temp.SeedofCorruptionDelay - 1
    end    
    
    ------------------------------------------------------
    ---------------- ENEMY UNIT ROTATION -----------------
    ------------------------------------------------------
    local function EnemyRotation(unit)    
        
        --#####################
        --##### PRECOMBAT #####
        --#####################        
        
        local function Precombat(unit)
            
            -- Summon Pet 
            if SummonPet:IsReady("player") and (not isMoving) and not Pet:IsActive() and Unit("player"):HasBuffs(A.GrimoireofSacrificeBuff.ID, true) == 0 then
                return SummonPet:Show(icon)
            end        
            
            --Force AoE opener check
            if A.SeedofCorruption:IsReady("target") and A.SowtheSeeds:IsTalentLearned() and (not isMoving) and Temp.SeedofCorruptionDelay == 0 and A.GetToggle(2, "ForceAoE") and UseAoE and not inCombat then
                return A.SeedofCorruption:Show(icon)
            end    
            
            --actions.precombat+=/grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled
            if A.GrimoireofSacrifice:IsReady("player") and Unit("player"):HasBuffs(A.GrimoireofSacrificeBuff.ID, true) == 0 and A.GrimoireofSacrifice:IsTalentLearned() then
                return A.GrimoireofSacrifice:Show(icon)
            end        
            
            --actions.precombat+=/use_item,name=azsharas_font_of_power
            
            
            --actions.precombat+=/seed_of_corruption,if=spell_targets.seed_of_corruption_aoe>=3&!equipped.169314
            if A.SeedofCorruption:IsReady("target") and (not isMoving) and Temp.SeedofCorruptionDelay == 0 and UseAoE and Player:GetDeBuffsUnitCount(A.SeedofCorruptionDebuff.ID) < 1 and MultiUnits:GetActiveEnemies() >= 3 then
                return A.SeedofCorruption:Show(icon)
            end        
            
            --actions.precombat+=/haunt
            if A.Haunt:IsReady(unit) and (not isMoving) then
                return A.Haunt:Show(icon)
            end    
            
            --actions.precombat+=/shadow_bolt,if=!talent.haunt.enabled&spell_targets.seed_of_corruption_aoe<3&!equipped.169314
            if A.ShadowBolt:IsReady(unit) and (not isMoving) and not A.DrainSoul:IsTalentLearned() and not A.Haunt:IsTalentLearned() and MultiUnits:GetActiveEnemies() < 3 then
                return A.ShadowBolt:Show(icon)
            end    
            
            if A.Agony:IsReady(unit) then
                return A.Agony:Show(icon)
            end        
        end
        
        --##########################
        --##### DARKGLARE PREP #####
        --##########################
        
        local function PrepareDarkglare(unit)
            
            --actions.darkglare_prep=vile_taint,if=cooldown.summon_darkglare.remains<2
            if A.VileTaint:IsReady(player) and (not isMoving) and A.SummonDarkglare:GetCooldown() < 2 then
                return A.VileTaint:Show(icon)
            end    
            
            --actions.darkglare_prep+=/dark_soul
            if A.DarkSoulMisery:IsReady(player) then
                return A.DarkSoulMisery:Show(icon)
            end    
            
            --actions.darkglare_prep+=/fireblood
            if A.Fireblood:IsReady(player) then
                return A.Fireblood:Show(icon)
            end    
            
            --actions.darkglare_prep+=/blood_fury
            if A.BloodFury:IsReady(player) then
                return A.BloodFury:Show(icon)
            end    
            
            --actions.darkglare_prep+=/berserking
            if A.Berserking:IsReady(player) then
                return A.Berserking:Show(icon)
            end    
            
            --actions.darkglare_prep+=/call_action_list,name=covenant,if=!covenant.necrolord&cooldown.summon_darkglare.remains<2
            if UseCov and Player:GetCovenant() ~= 4 and A.SummonDarkglare:GetCooldown() < 2 then
                if CovenantCall() then
                    return true
                end
            end
            
            --actions.darkglare_prep+=/summon_darkglare
            if A.SummonDarkglare:IsReady(unit) then
                return A.SummonDarkglare:Show(icon)
            end    
            
        end
        
        --###################################
        --##### SHADOW EMBRACE ROTATION #####
        --###################################
        
        local function ShadowEmbraceRotation()
            
            --actions.se=haunt
            if A.Haunt:IsReady(unit) and not isMoving then
                return A.Haunt:Show(icon)
            end
            
            --actions.se+=/drain_soul,interrupt_global=1,interrupt_if=debuff.shadow_embrace.stack>=3
            if Unit(player):HasBuffsStacks(A.ShadowEmbrace.ID, true) >= 3 and Player:IsChanneling() == "Drain Soul" then
                return A.StopCast:Show(icon)
            end        
            
            if A.DrainSoul:IsReady(unit) and not isMoving and A.DrainSoul:IsTalentLearned() and Unit(player):HasBuffsStacks(A.ShadowEmbrace.ID, true) <= 2 then
                return A.DrainSoul:Show(icon)
            end    
            
            --actions.se+=/shadow_bolt
            if A.ShadowBolt:IsReady(unit) and not isMoving then
                return A.ShadowBolt:Show(icon)
            end        
            
        end

        --#####################
        --##### COVENANTS #####
        --#####################
        
        local function CovenantCall(unit)
            
            --actions.covenant=impending_catastrophe,if=cooldown.summon_darkglare.remains<10|cooldown.summon_darkglare.remains>50
            if A.ImpendingCatastrophe:IsReady(unit) and (A.SummonDarkglare:GetCooldown() < 10 or A.SummonDarkglare:GetCooldown() > 50) then
                return A.ImpendingCatastrophe:Show(icon)
            end    
            
            --actions.covenant+=/decimating_bolt,if=cooldown.summon_darkglare.remains>5&(debuff.haunt.remains>4|!talent.haunt.enabled)
            if A.DecimatingBolt:IsReady(unit) and A.SummonDarkglare:GetCooldown() > 5 and (Unit(unit):HasDeBuffs(A.Haunt.ID, true) > 4 or not A.Haunt:IsTalentLearned()) then
                return A.DecimatingBolt:Show(icon)
            end    
            
            --actions.covenant+=/soul_rot,if=cooldown.summon_darkglare.remains<5|cooldown.summon_darkglare.remains>50|cooldown.summon_darkglare.remains>25&conduit.corrupting_leer.enabled
            if A.SoulRot:IsReady(unit) and (A.SummonDarkglare:GetCooldown() < 5 or A.SummonDarkglare:GetCooldown() > 50 or (A.SummonDarkglare:GetCooldown() > 25 and A.CorruptingLeer:IsSoulbindLearned())) then
                return A.SoulRot:Show(icon)
            end    
            
            --actions.covenant+=/scouring_tithe
            if A.ScouringTithe:IsReady(unit) then
                return A.ScouringTithe:Show(icon)
            end    
            
        end
        
        --########################
        --##### AOE ROTATION #####
        --########################
        
        local function AoERotation(unit)
            
            --actions.aoe=phantom_singularity
            if A.PhantomSingularity:IsReady(unit, nil, nil, true) and Unit("target"):TimeToDie() >= 14 and Unit(player):HealthPercent() >= DrainLifeHP then
                return A.PhantomSingularity:Show(icon)
            end        
            
            --actions.aoe+=/haunt
            if A.Haunt:IsReady(unit) and (not isMoving) then
                return A.Haunt:Show(icon)
            end            
            --actions.aoe+=/call_action_list,name=darkglare_prep,if=covenant.venthyr&dot.impending_catastrophe_dot.ticking&cooldown.summon_darkglare.remains<2&(dot.phantom_singularity.remains>2|!talent.phantom_singularity.enabled)
            if Player:GetCovenant() == 2 and Unit(unit):HasDeBuffs(A.ImpendingCatastrophe.ID, true) > 0 and A.SummonDarkglare:GetCooldown() < 2 and (Unit(unit):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) > 2 or not A.PhantomSingularity:IsTalentLearned()) then
                if PrepareDarkglare() then
                    return true
                end
            end
            
            --actions.aoe+=/call_action_list,name=darkglare_prep,if=covenant.night_fae&dot.soul_rot.ticking&cooldown.summon_darkglare.remains<2&(dot.phantom_singularity.remains>2|!talent.phantom_singularity.enabled)
            if Player:GetCovenant() == 3 and Unit(unit):HasDeBuffs(A.SoulRot.ID, true) > 0 and A.SummonDarkglare:GetCooldown() < 2 and (Unit(unit):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) > 2 or not A.PhantomSingularity:IsTalentLearned()) then
                if PrepareDarkglare() then
                    return true
                end
            end            
            
            --actions.aoe+=/call_action_list,name=darkglare_prep,if=(covenant.necrolord|covenant.kyrian|covenant.none)&dot.phantom_singularity.ticking&dot.phantom_singularity.remains<2
            if (Player:GetCovenant() == 4 or Player:GetCovenant() == 1 or Player:GetCovenant() == 0) and Unit(unit):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) > 0 and Unit(unit):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) < 2 then
                if PrepareDarkglare() then
                    return true
                end
            end                
            
            --actions.aoe+=/seed_of_corruption,if=talent.sow_the_seeds.enabled&can_seed
            if A.SeedofCorruption:IsReady("target", nil, nil, true) and (not isMoving) and Temp.SeedofCorruptionDelay == 0 and CorruptionRefreshable and Unit("target"):HasDeBuffs(A.SeedofCorruptionDebuff.ID, true) == 0 and Player:AreaTTD(40) > 5 and Unit(player):HealthPercent() >= DrainLifeHP then
                return A.SeedofCorruption:Show(icon)
            end         
            
            --actions.aoe+=/agony,cycle_targets=1,if=active_dot.agony<4,target_if=!dot.agony.ticking
            if A.Agony:IsReady(unit, nil, nil, true) and AgonyRefreshable and Unit("target"):TimeToDie() > 5 and Unit(player):HealthPercent() >= DrainLifeHP then
                return A.Agony:Show(icon)
            end                                            
            
            --actions.aoe+=/unstable_affliction,if=dot.unstable_affliction.refreshable
            if A.UnstableAffliction:IsReady(unit, nil, nil, true) and (not isMoving) and Temp.UnstableAfflictionDelay == 0 and (Player:GetDeBuffsUnitCount(A.UnstableAffliction.ID) < 1 or (Unit("target"):HasDeBuffs(A.UnstableAffliction.ID, true) > 0 and Unit("target"):HasDeBuffs(A.UnstableAffliction.ID, true) < 5)) and Unit("target"):TimeToDie() > 5 and Unit(player):HealthPercent() >= DrainLifeHP then
                return A.UnstableAffliction:Show(icon)
            end
            
            --actions.aoe+=/vile_taint,if=soul_shard>1
            if A.VileTaint:IsReady(unit, nil, nil, true) and (not isMoving) and not A.IsSpellInCasting(A.VileTaint) and Player:SoulShardsP() > 1 and Player:AreaTTD(40) > 9 and Unit(player):HealthPercent() >= DrainLifeHP then
                return A.VileTaint:Show(icon)
            end            
            
            --actions.aoe+=/call_action_list,name=covenant,if=!covenant.necrolord
            if UseCov and Player:GetCovenant() ~= 4 then
                if CovenantCall() then
                    return true
                end
            end
            
            --actions.aoe+=/call_action_list,name=darkglare_prep,if=covenant.venthyr&(cooldown.impending_catastrophe.ready|dot.impending_catastrophe_dot.ticking)&cooldown.summon_darkglare.remains<2&(dot.phantom_singularity.remains>2|!talent.phantom_singularity.enabled)
            if Player:GetCovenant() == 2 and (A.ImpendingCatastrophe:IsReady(unit) or Unit(unit):HasDeBuffs(A.ImpendingCatastrophe.ID, true) > 0) and A.SummonDarkglare:GetCooldown() < 2 and (Unit(unit):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) > 2 or not A.PhantomSingularity:IsTalentLearned()) then
                if A.PrepareDarkglare() then
                    return true
                end
            end
            
            --actions.aoe+=/call_action_list,name=darkglare_prep,if=(covenant.necrolord|covenant.kyrian|covenant.none)&cooldown.summon_darkglare.remains<2&(dot.phantom_singularity.remains>2|!talent.phantom_singularity.enabled)
            if (Player:GetCovenant() == 4 or Player:GetCovenant() == 1 or Player:GetCovenant() == 0) and A.SummonDarkglare:GetCooldown() < 2 and (Unit(unit):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) > 2 or not A.PhantomSingularity:IsTalentLearned()) then
                if PrepareDarkglare() then
                    return true
                end
            end    
            
            --actions.aoe+=/call_action_list,name=darkglare_prep,if=covenant.night_fae&(cooldown.soul_rot.ready|dot.soul_rot.ticking)&cooldown.summon_darkglare.remains<2&(dot.phantom_singularity.remains>2|!talent.phantom_singularity.enabled)
            if Player:GetCovenant() == 3 and (A.SoulRot:IsReady(unit) or Unit(unit):HasDeBuffs(A.SoulRot.ID, true) > 0) and A.SummonDarkglare:GetCooldown() < 2 and (Unit(unit):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) > 2 or not A.PhantomSingularity:IsTalentLearned()) then
                if PrepareDarkglare() then
                    return true
                end
            end    
            
            --actions.aoe+=/dark_soul,if=cooldown.summon_darkglare.remains>time_to_die
            if A.DarkSoulMisery:IsReady(player) and BurstIsON("target") and A.SummonDarkglare:GetCooldown() > Unit("target"):TimeToDie() then
                return A.DarkSoulMisery:Show(icon)
            end    
            
            --actions.aoe+=/call_action_list,name=item
            
            
            --actions.aoe+=/malefic_rapture,if=dot.vile_taint.ticking
            if A.MaleficRapture:IsReady("player") and (not isMoving) and Unit("target"):HasDeBuffs(A.VileTaint.ID, true) > 0 and Unit("target"):TimeToDie() >= 3 then
                return A.SpatialRift:Show(icon)
            end        
            
            --actions.aoe+=/malefic_rapture,if=dot.soul_rot.ticking&!talent.sow_the_seeds.enabled
            if A.MaleficRapture:IsReady("player") and (not isMoving) and Unit("target"):HasDeBuffs(A.SoulRot.ID, true) > 0 and not A.SowtheSeeds:IsTalentLearned() then
                return A.MaleficRapture:Show(icon)
            end    
            
            --actions.aoe+=/malefic_rapture,if=!talent.vile_taint.enabled    
            if A.MaleficRapture:IsReady("player") and (not isMoving) and not A.VileTaint:IsTalentLearned() then
                return A.MaleficRapture:Show(icon)
            end    
            
            --actions.aoe+=/malefic_rapture,if=soul_shard>4
            if A.MaleficRapture:IsReady("player") and (not isMoving) and Player:SoulShards() > 4 then
                return A.MaleficRapture:Show(icon)
            end    
            
            --[[actions.aoe+=/siphon_life,cycle_targets=1,if=active_dot.siphon_life<=3,target_if=!dot.siphon_life.ticking
            if AutoMultiDot and A.SiphonLife:IsReady("target") and A.SiphonLife:IsTalentLearned() and Player:GetDeBuffsUnitCount(A.SiphonLifeDebuff.ID) <= 4 and Unit("target"):HasDeBuffs(A.SiphonLifeDebuff.ID, true) > 5 then
                local Siphon_Nameplates = MultiUnits:GetActiveUnitPlates()
                if Siphon_Nameplates then  
                    for Siphon_UnitID in pairs(ActiveUnitPlates) do 
                        if not UnitIsUnit("target", Siphon_UnitID) then
                            if Unit(Siphon_UnitID):GetRange() < 40 and not Unit(Siphon_UnitID):InLOS() and Unit(Siphon_UnitID):TimeToDie() > 5 and Unit(Siphon_UnitID):HasDeBuffs(A.SiphonLifeDebuff.ID, true) < 4 and ((A.Zone == "none" and (Unit(Siphon_UnitID):IsDummy() or Unit(Siphon_UnitID):IsDummyPvP())) or Unit(Siphon_UnitID):CombatTime() > 0) then 
                                return A:Show(icon, ACTION_CONST_AUTOTARGET)
                            end
                        elseif Unit(Siphon_UnitID):GetRange() > 40 or (not (A.Zone == "none" and (Unit(Siphon_UnitID):IsDummy() or Unit(Siphon_UnitID):IsDummyPvP())) and Unit(Siphon_UnitID):CombatTime() == 0) then
                            return A:Show(icon, ACTION_CONST_AUTOTARGET)
                        end 
                    end
                end
            end    ]]    
            
            --actions.aoe+=/call_action_list,name=covenant
            if UseCov and CovenantCall() then
                return true
            end    
            
            --actions.aoe+=/drain_life,if=buff.inevitable_demise.stack>=50|buff.inevitable_demise.up&time_to_die<5|buff.inevitable_demise.stack>=35&dot.soul_rot.ticking
            if A.DrainLife:IsReady(unit) and (not isMoving) and (Unit(player):HasBuffsStacks(A.InevitableDemiseBuff.ID, true) >= 50 or (Unit(player):HasBuffsStacks(A.InevitableDemiseBuff.ID, true) > 0 and Unit("target"):TimeToDie() < 5) or (Unit(player):HasBuffsStacks(A.InevitableDemiseBuff.ID, true) >= 35 and Unit("target"):HasDeBuffs(A.SoulRot.ID, true) > 0)) then
                return A.DrainLife:Show(icon)
            end    
            
            --actions.aoe+=/drain_soul,interrupt=1
            if A.DrainSoul:IsReady(unit) and (not isMoving) then
                return A.DrainSoul:Show(icon)
            end    
            
            --actions.aoe+=/shadow_bolt
            if A.ShadowBolt:IsReady(unit) and (not isMoving) then
                return A.ShadowBolt:Show(icon)
            end    
            
            
        end
        
        
        --#########################
        --##### MAIN ROTATION #####
        --#########################
        
        if not inCombat then
            return Precombat()
        end
        
        --Fel Domination if Pet dies
        if A.FelDomination:IsReady("player") and not Pet:IsActive() and Unit("player"):HasBuffs(A.GrimoireofSacrificeBuff.ID, true) == 0 and inCombat then
            return A.RocketJump:Show(icon)
        end
        
        --Summon Pet with Fel Domination
        if SummonPet:IsReady("player") and (not isMoving) and not Pet:IsActive() and Unit("player"):HasBuffs(A.GrimoireofSacrificeBuff.ID, true) == 0 and Unit("player"):HasBuffs(A.FelDomination.ID, true) > 0 then
            return SummonPet:Show(icon)
        end        
        
        local Interrupt = Interrupts(unit)
        if Interrupt then 
            return Interrupt:Show(icon)
        end    
        
        --Drain Soul TTD 2
        if A.DrainSoul:IsReady(unit) and A.DrainSoul:IsTalentLearned() and Unit("target"):TimeToDie() <= 3 and Player:SoulShards() < 5 then
            return A.DrainSoul:Show(icon)
        end    
        
        --Drain Life below HP %
        if A.DrainLife:IsReady(unit) and Unit(player):HealthPercent() <= DrainLifeHP then
            return A.DrainLife:Show(icon)
        end    
        
        --Health Funnel
        if A.HealthFunnel:IsReady(player) and Unit("pet"):HealthPercent() <= HealthFunnelHP and Unit(player):HealthPercent() >= 30 then
            return A.HealthFunnel:Show(icon)
        end    
        
        
        --actions=call_action_list,name=aoe,if=active_enemies>3
        if MultiUnits:GetActiveEnemies() > 3 then
            if UseAoE and AoERotation() then
                return true
            end
        end    
        
        --actions+=/phantom_singularity,if=time>30
        if A.PhantomSingularity:IsReady(unit, nil, nil, true) and A.PhantomSingularity:IsTalentLearned() then
            return A.PhantomSingularity:Show(icon)
        end    
        --actions+=/call_action_list,name=darkglare_prep,if=covenant.venthyr&dot.impending_catastrophe_dot.ticking&cooldown.summon_darkglare.remains<2&(dot.phantom_singularity.remains>2|!talent.phantom_singularity.enabled)
        if Player:GetCovenant() == 2 and Unit(unit):HasDeBuffs(A.ImpendingCatastrophe.ID, true) > 0 and A.SummonDarkglare:GetCooldown() < 2 and (Unit(unit):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) > 2 or not A.PhantomSingularity:IsTalentLearned()) then
            if PrepareDarkglare() then
                return true
            end
        end
        
        --actions+=/call_action_list,name=darkglare_prep,if=covenant.night_fae&dot.soul_rot.ticking&cooldown.summon_darkglare.remains<2&(dot.phantom_singularity.remains>2|!talent.phantom_singularity.enabled)
        if Player:GetCovenant() == 3 and Unit(unit):HasDeBuffs(A.SoulRot.ID, true) > 0 and A.SummonDarkglare:GetCooldown() < 2 and (Unit(unit):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) > 2 or not A.PhantomSingularity:IsTalentLearned()) then
            if PrepareDarkglare() then
                return true
            end
        end
        
        --actions+=/call_action_list,name=darkglare_prep,if=(covenant.necrolord|covenant.kyrian|covenant.none)&dot.phantom_singularity.ticking&dot.phantom_singularity.remains<2
        if (Player:GetCovenant() == 4 or Player:GetCovenant() == 1 or Player:GetCovenant() == 0) and Unit(unit):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) > 0 and Unit(unit):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) < 2 then
            if PrepareDarkglare() then
                return true
            end
        end    
        
        --actions+=/agony,if=dot.agony.remains<4
        if A.Agony:IsReady(unit, nil, nil, true) and AgonyRefreshable then
            return A.Agony:Show(icon)
        end    
        
        if AutoMultiDot and Dotcap and (HasAllDots and unit ~= "mouseover") and Player:AreaTTD(40) > 8 and MultiUnits:GetActiveEnemies() >= 2 or Unit("target"):IsDummy()
        then
            local Agony_Nameplates = MultiUnits:GetActiveUnitPlates()
            if Agony_Nameplates then  
                for Agony_UnitID in pairs(ActiveUnitPlates) do 
                    if not UnitIsUnit("target", Agony_UnitID) then
                        if Unit(Agony_UnitID):GetRange() < 40 and not Unit(Agony_UnitID):InLOS() and Unit(Agony_UnitID):HasDeBuffs(A.Agony.ID, true) == 0 and ((A.Zone == "none" and (Unit(Agony_UnitID):IsDummy() or Unit(Agony_UnitID):IsDummyPvP())) or Unit(Agony_UnitID):CombatTime() > 0) then 
                            return A:Show(icon, ACTION_CONST_AUTOTARGET)
                        end
                    elseif Unit(Agony_UnitID):GetRange() > 40 or (not (A.Zone == "none" and (Unit(Agony_UnitID):IsDummy() or Unit(Agony_UnitID):IsDummyPvP())) and Unit(Agony_UnitID):CombatTime() == 0) then
                        return A:Show(icon, ACTION_CONST_AUTOTARGET)
                    end 
                end
            end
        end    
        
        --actions+=/haunt
        if A.Haunt:IsReady(unit) and A.Haunt:IsTalentLearned() and (not isMoving) then
            return A.Haunt:Show(icon)
        end    
        --actions+=/call_action_list,name=darkglare_prep,if=active_enemies>2&covenant.venthyr&(cooldown.impending_catastrophe.ready|dot.impending_catastrophe_dot.ticking)&(dot.phantom_singularity.ticking|!talent.phantom_singularity.enabled)
        if MultiUnits:GetActiveEnemies() > 2 and Player:GetCovenant() == 2 and (A.ImpendingCatastrophe:IsReady(unit) or Unit(unit):HasDeBuffs(A.ImpendingCatastrophe.ID, true) > 0) and (Unit(unit):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) > 0 or not A.PhantomSingularity:IsTalentLearned()) then
            if PrepareDarkglare() then
                return true
            end
        end
        
        --actions+=/call_action_list,name=darkglare_prep,if=active_enemies>2&(covenant.necrolord|covenant.kyrian|covenant.none)&(dot.phantom_singularity.ticking|!talent.phantom_singularity.enabled)
        if MultiUnits:GetActiveEnemies() > 2 and (Player:GetCovenant() == 4 or Player:GetCovenant() == 1 or Player:GetCovenant() == 0) and Unit(unit):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) > 0 and Unit(unit):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) < 2 then
            if PrepareDarkglare() then
                return true
            end
        end                
        --actions+=/call_action_list,name=darkglare_prep,if=active_enemies>2&covenant.night_fae&(cooldown.soul_rot.ready|dot.soul_rot.ticking)&(dot.phantom_singularity.ticking|!talent.phantom_singularity.enabled)
        if MultiUnits:GetActiveEnemies() > 2 and Player:GetCovenant() == 3 and Unit(unit):HasDeBuffs(A.SoulRot.ID, true) > 0 and A.SummonDarkglare:GetCooldown() < 2 and (Unit(unit):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) > 2 or not A.PhantomSingularity:IsTalentLearned()) then
            if PrepareDarkglare() then
                return true
            end
        end            
        
        --actions+=/seed_of_corruption,if=active_enemies>2&talent.sow_the_seeds.enabled&!dot.seed_of_corruption.ticking&!in_flight
        if A.SeedofCorruption:IsReady("target", nil, nil, true) and (not isMoving) and MultiUnits:GetActiveEnemies() > 2 and A.SowtheSeeds:IsTalentLearned() and Temp.SeedofCorruptionDelay == 0 and Unit("target"):HasDeBuffs(A.SeedofCorruptionDebuff.ID, true) == 0 and Player:AreaTTD(40) > 5 and Unit(player):HealthPercent() >= DrainLifeHP then
            return A.SeedofCorruption:Show(icon)
        end                 
        
        --actions+=/seed_of_corruption,if=active_enemies>2&talent.siphon_life.enabled&!dot.seed_of_corruption.ticking&!in_flight&dot.corruption.remains<4
        if A.SeedofCorruption:IsReady("target", nil, nil, true) and (not isMoving) and MultiUnits:GetActiveEnemies() > 2 and A.SiphonLife:IsTalentLearned() and Temp.SeedofCorruptionDelay == 0 and CorruptionRefreshable and Unit("target"):HasDeBuffs(A.SeedofCorruptionDebuff.ID, true) == 0 and Player:AreaTTD(40) > 5 and Unit(player):HealthPercent() >= DrainLifeHP then
            return A.SeedofCorruption:Show(icon)
        end                 
        
        --actions+=/vile_taint,if=(soul_shard>1|active_enemies>2)&cooldown.summon_darkglare.remains>12
        if A.VileTaint:IsReady("player", nil, nil, true) and (not isMoving) and (Player:SoulShards() > 1 or MultiUnits:GetActiveEnemies() > 2) and A.SummonDarkglare:GetCooldown() > 12 then
            return A.VileTaint:Show(icon)
        end
        
        --actions+=/unstable_affliction,if=dot.unstable_affliction.remains<4
        if A.UnstableAffliction:IsReady(unit, nil, nil, true) and (not isMoving) and Temp.UnstableAfflictionDelay == 0 and (Player:GetDeBuffsUnitCount(A.UnstableAffliction.ID) < 1 or (Unit("target"):HasDeBuffs(A.UnstableAffliction.ID, true) > 0 and Unit("target"):HasDeBuffs(A.UnstableAffliction.ID, true) < 4)) and Unit("target"):TimeToDie() > 5 and Unit(player):HealthPercent() >= DrainLifeHP then
            return A.UnstableAffliction:Show(icon)
        end
        
        --actions+=/siphon_life,if=dot.siphon_life.remains<4
        if A.SiphonLife:IsReady(unit, nil, nil, true) and A.SiphonLife:IsTalentLearned() and SiphonLifeRefreshable then
            return A.SiphonLife:Show(icon)
        end        
        
        --actions+=/call_action_list,name=covenant,if=!covenant.necrolord
        if Player:GetCovenant() ~= 4 and UseCov then
            if CovenantCall() then
                return true
            end
        end
        
        --actions+=/corruption,if=active_enemies<4-(talent.sow_the_seeds.enabled|talent.siphon_life.enabled)&dot.corruption.remains<2
        if A.Corruption:IsReady(unit, nil, nil, true) and MultiUnits:GetActiveEnemies() < 4 - num(A.SowtheSeeds:IsTalentLearned() or A.SiphonLife:IsTalentLearned()) and CorruptionRefreshable then
            return A.Corruption:Show(icon)
        end    
        
        --actions+=/phantom_singularity,if=covenant.necrolord|covenant.night_fae|covenant.kyrian|covenant.none
        if A.PhantomSingularity:IsReady(unit, nil, nil, true) and A.PhantomSingularity:IsTalentLearned() and (Player:GetCovenant() == 4 or Player:GetCovenant() == 1 or Player:GetCovenant() == 0) then
            return A.PhantomSingularity:Show(icon)
        end    
        
        --actions+=/malefic_rapture,if=soul_shard>4
        if A.MaleficRapture:IsReady(unit, nil, nil, true) and Player:SoulShards() > 4 then
            return A.SpatialRift:Show(icon)
        end    
        
        --actions+=/call_action_list,name=darkglare_prep,if=covenant.venthyr&(cooldown.impending_catastrophe.ready|dot.impending_catastrophe_dot.ticking)&cooldown.summon_darkglare.remains<2&(dot.phantom_singularity.remains>2|!talent.phantom_singularity.enabled)
        if Player:GetCovenant() == 2 and (A.ImpendingCatastrophe:IsReady(unit) or Unit(unit):HasDeBuffs(A.ImpendingCatastrophe.ID, true) > 0) and A.SummonDarkglare:GetCooldown() < 2 and (Unit(unit):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) > 2 or not A.PhantomSingularity:IsTalentLearned()) then
            if PrepareDarkglare() then
                return true
            end
        end
        
        --actions+=/call_action_list,name=darkglare_prep,if=(covenant.necrolord|covenant.kyrian|covenant.none)&cooldown.summon_darkglare.remains<2&(dot.phantom_singularity.remains>2|!talent.phantom_singularity.enabled)
        if (Player:GetCovenant() == 4 or Player:GetCovenant() == 1 or Player:GetCovenant() == 0) and A.SummonDarkglare:GetCooldown() < 2 and (Unit(unit):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) > 2 or not A.PhantomSingularity:IsTalentLearned()) then
            if PrepareDarkglare() then
                return true
            end
        end
        
        --actions+=/call_action_list,name=darkglare_prep,if=covenant.night_fae&(cooldown.soul_rot.ready|dot.soul_rot.ticking)&cooldown.summon_darkglare.remains<2&(dot.phantom_singularity.remains>2|!talent.phantom_singularity.enabled)
        if Player:GetCovenant() == 3 and (A.SoulRot:IsReady(unit) or Unit(unit):HasDeBuffs(A.SoulRot.ID, true) > 0) and A.SummonDarkglare:GetCooldown() < 2 and (Unit(unit):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) > 2 or not A.PhantomSingularity:IsTalentLearned()) then
            if PrepareDarkglare() then
                return true
            end
        end            
        
        --actions+=/dark_soul,if=cooldown.summon_darkglare.remains>time_to_die
        if A.DarkSoulMisery:IsReady(player) and BurstIsON("target") and A.SummonDarkglare:GetCooldown() > Unit("target"):TimeToDie() then
            return A.DarkSoulMisery:Show(icon)
        end    
        
        --actions+=/call_action_list,name=item
        --[[actions+=/call_action_list,name=se,if=debuff.shadow_embrace.stack<(2-action.shadow_bolt.in_flight)|debuff.shadow_embrace.remains<3
        if Unit(unit):HasBuffsStacks(A.ShadowEmbrace.ID, true) < 3 or Unit(unit):HasDeBuffs(A.ShadowEmbrace.ID, true) < 3 then
            if ShadowEmbraceRotation() then
                return true
            end
        end]]
        
        --actions+=/malefic_rapture,if=dot.vile_taint.ticking
        if A.MaleficRapture:IsReady(unit, nil, nil, true) and (not isMoving) and A.VileTaint:IsTalentLearned() and Unit(unit):HasDeBuffs(A.VileTaint.ID, true) > 0 then
            return A.SpatialRift:Show(icon)
        end    
        
        --actions+=/malefic_rapture,if=dot.impending_catastrophe_dot.ticking
        if A.MaleficRapture:IsReady(unit, nil, nil, true) and (not isMoving) and Unit(unit):HasDeBuffs(A.ImpendingCatastrophe.ID, true) > 0 then
            return A.SpatialRift:Show(icon)
        end    
        
        --actions+=/malefic_rapture,if=dot.soul_rot.ticking
        if A.MaleficRapture:IsReady(unit, nil, nil, true) and (not isMoving) and Unit(unit):HasDeBuffs(A.SoulRot.ID, true) > 0 then
            return A.SpatialRift:Show(icon)
        end                
        
        --actions+=/malefic_rapture,if=talent.phantom_singularity.enabled&(dot.phantom_singularity.ticking|soul_shard>3|time_to_die<cooldown.phantom_singularity.remains)
        if A.MaleficRapture:IsReady(unit, nil, nil, true) and (not isMoving) and A.PhantomSingularity:IsTalentLearned() and (Unit(unit):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) > 0 or Player:SoulShards() > 3 or Unit(unit):TimeToDie() < A.PhantomSingularity:GetCooldown()) then
            return A.SpatialRift:Show(icon)
        end                
        
        --actions+=/malefic_rapture,if=talent.sow_the_seeds.enabled
        if A.MaleficRapture:IsReady(unit, nil, nil, true) and (not isMoving) and A.SowtheSeeds:IsTalentLearned() then
            return A.SpatialRift:Show(icon)
        end                
        
        --actions+=/drain_life,if=buff.inevitable_demise.stack>40|buff.inevitable_demise.up&time_to_die<4
        if A.DrainLife:IsReady(unit) and (not isMoving) and (Unit(player):HasBuffs(A.InevitableDemiseBuff.ID, true) > 40 or (Unit(player):HasBuffs(A.InevitableDemiseBuff.ID, true) > 0 and Unit(unit):TimeToDie() < 4)) then
            return A.DrainLife:Show(icon)
        end    
        
        --actions+=/call_action_list,name=covenant
        if UseCov and CovenantCall() then
            return true
        end    
        
        --actions+=/agony,if=refreshable
        if A.Agony:IsReady(unit, nil, nil, true) and AgonyRefreshable then
            return A.Agony:Show(icon)
        end    
        
        --actions+=/drain_soul,interrupt=1
        if A.DrainSoul:IsReady(unit) and (not isMoving) and A.DrainSoul:IsTalentLearned() then
            return A.DrainSoul:Show(icon)
        end    
        
        --actions+=/shadow_bolt
        if A.ShadowBolt:IsReady(unit) and (not isMoving) then
            return A.ShadowBolt:Show(icon)
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

A[1] = nil

A[4] = nil

A[5] = nil

A[6] = nil

A[7] = nil

A[8] = nil

