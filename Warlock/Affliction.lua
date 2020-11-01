--#####################################
--##### TRIP'S AFFLICTION WARLOCK #####
--#####################################

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

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

Action[ACTION_CONST_WARLOCK_AFFLICTION] = {
    -- Racial
    ArcaneTorrent                        = Action.Create({ Type = "Spell", ID = 50613     }),
    BloodFury                            = Action.Create({ Type = "Spell", ID = 20572      }),
    Fireblood                            = Action.Create({ Type = "Spell", ID = 265221     }),
    AncestralCall                        = Action.Create({ Type = "Spell", ID = 274738     }),
    Berserking                           = Action.Create({ Type = "Spell", ID = 26297    }),
    ArcanePulse                          = Action.Create({ Type = "Spell", ID = 260364    }),
    QuakingPalm                          = Action.Create({ Type = "Spell", ID = 107079     }),
    Haymaker                             = Action.Create({ Type = "Spell", ID = 287712     }), 
    BullRush                             = Action.Create({ Type = "Spell", ID = 255654     }),    
    WarStomp                             = Action.Create({ Type = "Spell", ID = 20549     }),
    GiftofNaaru                          = Action.Create({ Type = "Spell", ID = 59544    }),
    Shadowmeld                           = Action.Create({ Type = "Spell", ID = 58984    }), -- usable in Action Core 
    Stoneform                            = Action.Create({ Type = "Spell", ID = 20594    }), 
    BagofTricks                          = Action.Create({ Type = "Spell", ID = 312411    }),
    WilloftheForsaken                    = Action.Create({ Type = "Spell", ID = 7744        }), -- not usable in APL but user can Queue it    
    EscapeArtist                         = Action.Create({ Type = "Spell", ID = 20589    }), -- not usable in APL but user can Queue it
    EveryManforHimself                   = Action.Create({ Type = "Spell", ID = 59752    }), -- not usable in APL but user can Queue it
    -- Generics Spells
    DreadfulCalling                      = Action.Create({ Type = "Spell", ID = 279650     }), -- Azerite traits
    SummonImp                            = Action.Create({ Type = "Spell", ID = 688        }),    
    SummonVoidwalker                     = Action.Create({ Type = "Spell", ID = 697        }),
    SummonFelhunter                      = Action.Create({ Type = "Spell", ID = 691        }),
    SummonSuccubus                       = Action.Create({ Type = "Spell", ID = 712        }),
    GrimoireofSacrifice                  = Action.Create({ Type = "Spell", ID = 108503     }),
    SeedofCorruption                     = Action.Create({ Type = "Spell", ID = 27243      }),
    Haunt                                = Action.Create({ Type = "Spell", ID = 48181      }),
    ShadowBolt                           = Action.Create({ Type = "Spell", ID = 232670     }),
    DarkSoulMisery                       = Action.Create({ Type = "Spell", ID = 113860     }),
    SummonDarkglare                      = Action.Create({ Type = "Spell", ID = 205180     }),
    SiphonLife                           = Action.Create({ Type = "Spell", ID = 63106      }),
    Agony                                = Action.Create({ Type = "Spell", ID = 980        }),
    Corruption                           = Action.Create({ Type = "Spell", ID = 172        }),
    CreepingDeath                        = Action.Create({ Type = "Spell", ID = 264000     }),
    WritheInAgony                        = Action.Create({ Type = "Spell", ID = 196102     }),
    UnstableAffliction                   = Action.Create({ Type = "Spell", ID = 316099      }),
    Deathbolt                            = Action.Create({ Type = "Spell", ID = 264106     }),
    AbsoluteCorruption                   = Action.Create({ Type = "Spell", ID = 196103     }),
    DrainLife                            = Action.Create({ Type = "Spell", ID = 234153     }),
    PhantomSingularity                   = Action.Create({ Type = "Spell", ID = 205179     }),
    VileTaint                            = Action.Create({ Type = "Spell", ID = 278350     }),
    DrainSoul                            = Action.Create({ Type = "Spell", ID = 198590     }),
    ShadowEmbrace                        = Action.Create({ Type = "Spell", ID = 32388      }),
    CascadingCalamity                    = Action.Create({ Type = "Spell", ID = 275372     }),
    SowtheSeeds                          = Action.Create({ Type = "Spell", ID = 196226     }),
    PetKick                              = Action.Create({ Type = "SpellSingleColor", ID = 119910, Color = "RED", Desc = "RED Color for Pet Target kick" }),  
    FearGreen                            = Action.Create({ Type = "SpellSingleColor", ID = 5782, Color = "GREEN", Desc = "[2] Kick", Hidden = true, QueueForbidden = true }),	
    Fear                                 = Action.Create({ Type = "Spell", ID = 5782       }),
    SpellLock                            = Action.Create({ Type = "Spell", ID = 119898     }),
    DispellMagic                         = Action.Create({ Type = "Spell", ID = 111400     }),
    Shadowfury                           = Action.Create({ Type = "Spell", ID = 30283      }),
    PandemicInvocation                   = Action.Create({ Type = "Spell", ID = 289364     }),
	MaleficRapture						 = Action.Create({ Type = "Spell", ID = 324536	   }),
    -- Defensive
    UnendingResolve                      = Action.Create({ Type = "Spell", ID = 104773     }),
	SingeMagic                           = Action.Create({ Type = "Spell", ID = 89808, Color = "YELLOW", Desc = "YELLOW Color for Pet Target dispel"     }),
    -- Utilities
    DemonicCircle                        = Action.Create({ Type = "Spell", ID = 268358     }),
    DemonicCircleTeleport                = Action.Create({ Type = "Spell", ID = 48020     }),
	-- Misc
    BurningRush                          = Action.Create({ Type = "Spell", ID = 278727     }),
    Channeling                           = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),	-- Show an icon during channeling
    --TargetEnemy                          = Action.Create({ Type = "Spell", ID = 44603, Hidden = true     }),	-- Change Target (Tab button)
	--StopCast 				             = Action.Create({ Type = "Spell", ID = 61721, Hidden = true     }),		-- spell_magic_polymorphrabbit
    -- Buffs
    GrimoireofSacrificeBuff              = Action.Create({ Type = "Spell", ID = 196099, Hidden = true     }),
    ActiveUasBuff                        = Action.Create({ Type = "Spell", ID = 233490, Hidden = true     }),
    InevitableDemiseBuff                 = Action.Create({ Type = "Spell", ID = 273525, Hidden = true     }),
    NightfallBuff                        = Action.Create({ Type = "Spell", ID = 264571, Hidden = true     }),
    CascadingCalamityBuff                = Action.Create({ Type = "Spell", ID = 275378, Hidden = true     }),
    WrackingBrillianceBuff               = Action.Create({ Type = "Spell", ID = 272891, Hidden = true    }),
    -- Debuffs 
    ShadowEmbraceDebuff                  = Action.Create({ Type = "Spell", ID = 32390, Hidden = true     }),
    ShiverVenomDebuff                    = Action.Create({ Type = "Spell", ID = 301624, Hidden = true     }),
    SeedofCorruptionDebuff               = Action.Create({ Type = "Spell", ID = 27243, Hidden = true}),
    HauntDebuff                          = Action.Create({ Type = "Spell", ID = 48181, Hidden = true}),
    UnstableAfflictionDebuff             = Action.Create({ Type = "Spell", ID = 316099, Hidden = true}),
    PhantomSingularityDebuff             = Action.Create({ Type = "Spell", ID = 205179, Hidden = true}),
    SiphonLifeDebuff                     = Action.Create({ Type = "Spell", ID = 63106, Hidden = true}),
    AgonyDebuff                          = Action.Create({ Type = "Spell", ID = 980, Hidden = true}),
    CorruptionDebuff                     = Action.Create({ Type = "Spell", ID = 146739, Hidden = true     }),
	--[[ UA Debuff
    UnstableAfflictionDebuff1             = Action.Create({ Type = "Spell", ID = 233490, Hidden = true}),	
    UnstableAfflictionDebuff2             = Action.Create({ Type = "Spell", ID = 233496, Hidden = true}),   
    UnstableAfflictionDebuff3             = Action.Create({ Type = "Spell", ID = 233497, Hidden = true}),  
    UnstableAfflictionDebuff4             = Action.Create({ Type = "Spell", ID = 233498, Hidden = true}),   
    UnstableAfflictionDebuff5             = Action.Create({ Type = "Spell", ID = 233499, Hidden = true}),]]
    -- PvP
    NetherWard                           = Action.Create({ Type = "Spell", ID = 212295     }), -- Spell Reflect	
	DemonArmor                           = Action.Create({ Type = "Spell", ID = 285933     }), -- Demon Armor PvP		
	CurseofTongues                       = Action.Create({ Type = "Spell", ID = 199890     }), -- 30% increase cast time on target for 10sec
	CurseofWeakness                      = Action.Create({ Type = "Spell", ID = 199892     }), -- 30% reduction attack power for 10sec
	CastingCircle                        = Action.Create({ Type = "Spell", ID = 221703     }), -- Silence interrupt immune for 8sec
	CurseofShadows                       = Action.Create({ Type = "Spell", ID = 234877     }), -- Additional damage 10sec
	RotandDecay                          = Action.Create({ Type = "Spell", ID = 212371, Hidden = true        }), -- Drain Life increasing dots duration by 1sec per tick
	Soulshatter                          = Action.Create({ Type = "Spell", ID = 212356     }), -- Big burst on multi target 
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
    CyclotronicBlast                     = Action.Create({ Type = "Spell", ID = 293491, Hidden = true}),
    ConcentratedFlameBurn                = Action.Create({ Type = "Spell", ID = 295368, Hidden = true}),
    -- Hidden Heart of Azeroth
    VisionofPerfectionMinor              = Action.Create({ Type = "Spell", ID = 296320, Hidden = true}), -- used by APL 
    VisionofPerfectionMinor2             = Action.Create({ Type = "Spell", ID = 299367, Hidden = true}),
    VisionofPerfectionMinor3             = Action.Create({ Type = "Spell", ID = 299369, Hidden = true}),
	DummyTest                            = Action.Create({ Type = "Spell", ID = 159999, Hidden = true     }), -- Dummy stop dps icon
    -- Here come all the stuff needed by simcraft but not classic spells or items. 
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
}

local IsIndoors, UnitIsUnit, UnitName = IsIndoors, UnitIsUnit, UnitName

local function IsSchoolFree()
	return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "SHADOW") == 0
end 

-- Pet Handler UI --
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

--[[ Multidot Handler UI --
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
end]]

local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end

--[[local function IsLatenced(self)
    -- @return boolean 
    return TMW.time - (Temp.CastStartTime[self:Info()] or 0) > GetGCD() + 0.5
end ]]

--[[Action.Enum.SpellDuration = {
    -- SiphonLife  
    [63106] = {15000, 19500},
    -- Agony
    [980] = {18000, 23400},
    --Corruption
    [146739] = {14000, 18200},
    -- Darkglare
    [205180] = {20000, 26000},

}]]

--[[ Base Duration of a dot/hot/channel...
local SpellDuration = Action.Enum.SpellDuration
function Action:BaseDuration()
    local Duration = SpellDuration[self.ID]
    if not Duration or Duration == 0 then 
	    return 0 
	end
    local BaseDuration = Duration[1]
    return BaseDuration / 1000
end

-- Pandemic Threshold
function Action:PandemicThreshold()
    local BaseDuration = self:BaseDuration()
    if not BaseDuration or BaseDuration == 0 then 
	    return 0 
    end
    return BaseDuration * 0.3
end

-- Agony TickTime 
local function AgonyTickTime()
    local BaseTickTime = 2
    local Hasted = true
    if Hasted then
        return BaseTickTime * Player:SpellHaste() 
	end
    return BaseTickTime
end

-- "time.to.shard"
local function TimeToShard()
    local ActiveAgony = MultiUnits:GetByRangeAppliedDoTs(40, 10, A.AgonyDebuff.ID)
    if ActiveAgony == 0 then
        return 10000 
    end
    return 1 / (0.16 / math.sqrt(ActiveAgony) * (ActiveAgony == 1 and 1.15 or 1) * ActiveAgony / AgonyTickTime())
end]]

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
    -- Stoneform on self dispel (only PvE)
    if A.Stoneform:IsRacialReady("player", true) and not A.IsInPvP and A.AuraIsValid("player", "UseDispel", "Dispel") then 
        return A.Stoneform
    end 
	
	    -- HealingPotion
    local AbyssalHealingPotion = A.GetToggle(2, "AbyssalHealingPotionHP")
    if     AbyssalHealingPotion >= 0 and A.AbyssalHealingPotion:IsReady("player") and 
    (
        (     -- Auto 
            AbyssalHealingPotion >= 100 and 
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
            AbyssalHealingPotion < 100 and 
            Unit("player"):HealthPercent() <= AbyssalHealingPotion
        )
    ) 
    then 
        return A.AbyssalHealingPotion
    end 
	
end 
SelfDefensives = A.MakeFunctionCachedStatic(SelfDefensives)

-- Non GCD spell check
local function countInterruptGCD(unit)
    if not A.PetKick:IsReadyByPassCastGCD(unit) or not A.PetKick:AbsentImun(unit, Temp.TotalAndMagKick) then
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
        if useKick and A.PetKick:IsReady(unit) and A.PetKick:AbsentImun(unit, Temp.TotalAndMagKick, true) and Unit(unit):IsControlAble("stun", 0) then 
            return A.PetKick
        end 
    
        if useCC and A.Shadowfury:IsReady(unit) and MultiUnits:GetActiveEnemies() >= 2 and A.Shadowfury:AbsentImun(unit, Temp.TotalAndCC, true) and Unit(unit):IsControlAble("stun", 0) then 
            return A.Shadowfury              
        end          
	
	    if useCC and A.Fear:IsReady(unit) and A.Fear:AbsentImun(unit, Temp.TotalAndCC, true) and Unit(unit):IsControlAble("disorient", 75) then 
            return A.Fear              
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

-- [2] Kick AntiFake Rotation
A[2] = function(icon)        
    local unit
    if A.IsUnitEnemy("mouseover") then 
        unit = "mouseover"
    elseif A.IsUnitEnemy("target") then 
        unit = "target"
    end 
    
    if unit then         
        local castLeft, _, _, _, notKickAble = Unit(unit):IsCastingRemains()
        if castLeft > 0 then             
            if not notKickAble and A.PetKick:IsReady(unit, nil, nil, true) and A.PetKick:AbsentImun(unit, Temp.TotalAndMag, true) then
                return A.PetKick:Show(icon)                                                  
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


-- [3] Single Rotation
A[3] = function(icon, isMulti)
	
	--------------------
	---  VARIABLES   ---
	--------------------
--    local ActiveAgony = MultiUnits:GetByRangeAppliedDoTs(40, 10, A.Agony.ID, 5)
--    local ActiveCorruption = MultiUnits:GetByRangeAppliedDoTs(40, 10, A.Corruption.ID, 5)
--    local ActiveSiphonLife = MultiUnits:GetByRangeAppliedDoTs(40, 10, A.SiphonLife.ID, 5)
    local isMoving = A.Player:IsMoving()
	local inCombat = Unit("player"):CombatTime() > 0
--	local ShouldStop = Action.ShouldStop()
	local Pull = Action.BossMods:GetPullTimer()
--    local CanMultidot = HandleMultidots()
--    local time_to_shard = TimeToShard()
--	local PredictSpells = A.GetToggle(2, "PredictSpells")
--	local MultiDotDistance = A.GetToggle(2, "MultiDotDistance")
	local profileStop = false	
		
--	DetermineEssenceRanks()
	--[[ Multidots var
	local MissingCorruption = MultiUnits:GetByRangeMissedDoTs(MultiDotDistance, 5, A.Corruption.ID) --MultiDots(40, A.FlameShockDebuff, 15, 4) --MultiUnits:GetByRangeMissedDoTs(40, 10, 188389)  MultiUnits:GetByRangeMissedDoTs(range, stop, dots, ttd)
	local MissingAgony = MultiUnits:GetByRangeMissedDoTs(MultiDotDistance, 5, A.Agony.ID) --MultiDots(40, A.FlameShockDebuff, 15, 4) --MultiUnits:GetByRangeMissedDoTs(40, 10, 188389)  MultiUnits:GetByRangeMissedDoTs(range, stop, dots, ttd)
    --print(MissingVampiricTouch)
    local AppliedCorruption = MultiUnits:GetByRangeAppliedDoTs(MultiDotDistance, 5, 146739) --MultiDots(40, A.FlameShockDebuff, 15, 4) --MultiUnits:GetByRangeMissedDoTs(40, 10, 188389)  MultiUnits:GetByRangeMissedDoTs(range, stop, dots, ttd)
 	local AppliedAgony = MultiUnits:GetByRangeAppliedDoTs(MultiDotDistance, 5, 980) --MultiDots(40, A.FlameShockDebuff, 15, 4) --MultiUnits:GetByRangeMissedDoTs(40, 10, 188389)  MultiUnits:GetByRangeMissedDoTs(range, stop, dots, ttd)
    --print(AppliedVampiricTouch)
    local CorruptionToRefresh = MultiUnits:GetByRangeDoTsToRefresh(MultiDotDistance, 5, 146739, 6, 5)
    local AgonyToRefresh = MultiUnits:GetByRangeDoTsToRefresh(MultiDotDistance, 5, 980, 6, 5)
    --SiphonLifeToRefresh = MultiUnits:GetByRangeDoTsToRefresh(40, 5, 980, 5)
	--print(VampiricTouchToRefresh)]]

	--Refreshables
	SiphonLifeRefreshable = (Unit("target"):HasDeBuffs(A.SiphonLifeDebuff.ID, true) == 0 or Unit("target"):HasDeBuffs(A.SiphonLife.ID, true) < 4)
	CorruptionRefreshable = (Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID, true) == 0 or Unit("target"):HasDeBuffs(A.Corruption.ID, true) < 4)
	AgonyRefreshable = (Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) == 0 or Unit("target"):HasDeBuffs(A.Agony.ID, true) < 4)	
	UARefreshable = (Unit("target"):HasDeBuffs(A.UnstableAfflictionDebuff.ID, true) == 0 or Unit("target"):HasDeBuffs(A.UnstableAfflictionDebuff.ID, true) < 4)	

	HasAllDots = Unit("target"):HasDeBuffs(A.SiphonLifeDebuff.ID, true) > 0 and Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID, true) > 0 and Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) > 0 and Unit("target"):HasDeBuffs(A.UnstableAfflictionDebuff.ID, true) > 0

    local castName    = Unit("player"):IsCasting()
    -- Log CastStartTime - Latency
    if castName then 
        Temp.CastStartTime[castName] = TMW.time 
    end 
	
	-- Pet Selection Menu
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
	
	------------------------------------
	---------- DUMMY DPS TEST ----------
	------------------------------------
	local DummyTime = GetToggle(2, "DummyTime")
	if DummyTime > 0 then
    	local unit = "target"
		local endtimer = 0
		
    	if Unit(unit):IsExists() and Unit(unit):IsDummy() then
        	if Unit("player"):CombatTime() >= (DummyTime * 60) then
            	StopAttack()
				endtimer = TMW.time
            	--ClearTarget() -- Protected ? 
	       	    -- Notification					
          	    Action.SendNotification(DummyTime .. " Minutes Dummy Test Concluded - Profile Stopped", A.DummyTest.ID)			
         	    
				if endtimer < TMW.time + 5 then
				    profileStop = true
				    --return A.DummyTest:Show(icon)
				end
    	    end
  	    end
	end		
	------------------------------------------------------
	---------------- ENEMY UNIT ROTATION -----------------
	------------------------------------------------------
	local function EnemyRotation(unit)	
	    
			-- Interrupt vars		
	local useKick, useCC, useRacial = Action.InterruptIsValid(unit, "TargetMouseover")  
	-- Trinkets vars
	local Trinket1IsAllowed, Trinket2IsAllowed = TR:TrinketIsAllowed()	
		
		--#####################
		--##### PRECOMBAT #####
		--#####################		
		
		local function Precombat(unit)
			
			-- Summon Pet 
			if SummonPet:IsReady("player") and (not isMoving) and not Pet:IsActive() and not Unit("player"):HasBuffs(A.GrimoireofSacrificeBuff.ID, true) then
				return SummonPet:Show(icon)
			end			
			
			--actions.precombat+=/grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled
			if A.GrimoireofSacrifice:IsReady("player") and Unit("player"):HasBuffs(A.GrimoireofSacrificeBuff.ID, true) == 0 and A.GrimoireofSacrifice:IsSpellLearned() then
				return A.GrimoireofSacrifice:Show(icon)
			end		
			
			--actions.precombat+=/use_item,name=azsharas_font_of_power


			--actions.precombat+=/seed_of_corruption,if=spell_targets.seed_of_corruption_aoe>=3&!equipped.169314
			if A.SeedofCorruption:IsReady(unit) and (not isMoving) and not ShouldStop and A.GetToggle(2, "AoE") and Unit(unit):HasDeBuffs(A.SeedofCorruptionDebuff.ID, true) == 0 and MultiUnits:GetActiveEnemies() >= 3 then
				return A.SeedofCorruption:Show(icon)
			end		
			
			--actions.precombat+=/haunt
			if A.Haunt:IsReady(unit) then
				return A.Haunt:Show(icon)
			end	
			
			--actions.precombat+=/shadow_bolt,if=!talent.haunt.enabled&spell_targets.seed_of_corruption_aoe<3&!equipped.169314
			if A.ShadowBolt:IsReady(unit) and not A.Haunt:IsSpellLearned() and MultiUnits:GetActiveEnemies() < 3 then
				return A.ShadowBolt:Show(icon)
			end	
		
		end
		
		
		--#####################
		--##### COOLDOWNS #####
		--#####################
		
		local function Cooldowns(unit)
		
			--actions.cooldowns=worldvein_resonance
			if A.WorldveinResonance:AutoHeartOfAzeroth(unit, true) and not ShouldStop then
				return A.Darkflight:Show(icon)
			end			
			--actions.cooldowns+=/memory_of_lucid_dreams
			if A.MemoryofLucidDreams:AutoHeartOfAzeroth(unit, true) and not ShouldStop then
				return A.Darkflight:Show(icon)
			end
			
			--actions.cooldowns+=/blood_of_the_enemy
			if A.BloodoftheEnemy:AutoHeartOfAzeroth(unit, true) and not ShouldStop then
				return A.Darkflight:Show(icon)
			end			
			
			--actions.cooldowns+=/guardian_of_azeroth
            if A.GuardianofAzeroth:AutoHeartOfAzeroth(unit, true) and not ShouldStop then
                return A.Darkflight:Show(icon)
            end			
			
			--actions.cooldowns+=/ripple_in_space
			if A.RippleinSpace:AutoHeartOfAzeroth(unit, true) and not ShouldStop then
				return A.Darkflight:Show(icon)
			end	
			
			--actions.cooldowns+=/focused_azerite_beam
            if A.FocusedAzeriteBeam:IsReady(unit) and not ShouldStop then
                return A.Darkflight:Show(icon)
            end			
			
			--actions.cooldowns+=/purifying_blast
            if A.PurifyingBlast:IsReady(unit) and not ShouldStop then
                return A.Darkflight:Show(icon)
            end
			
			--actions.cooldowns+=/reaping_flames
            if A.ReapingFlames:AutoHeartOfAzeroth(unit, true) and not ShouldStop then
                return A.Darkflight:Show(icon)
            end
			
			--actions.cooldowns+=/concentrated_flame
            if A.ConcentratedFlame:AutoHeartOfAzeroth(unit, true) and not ShouldStop and (Unit(unit):HasDeBuffs(A.ConcentratedFlameBurn.ID, true) == 0 and not A.ConcentratedFlame:IsSpellInFlight()) then
                return A.Darkflight:Show(icon)
            end
			
			--actions.cooldowns+=/the_unbound_force,if=buff.reckless_force.remains
            if A.TheUnboundForce:AutoHeartOfAzeroth(unit, true) and not ShouldStop and Unit("player"):HasBuffs(A.RecklessForceBuff.ID, true) then
                return A.Darkflight:Show(icon)
            end			
		
			-- Non SIMC Custom Trinket1
			if A.Trinket1:IsReady(unit) and Trinket1IsAllowed and inCombat and     
			(
				A.GetToggle(2, "TrinketsAoE") and GetByRange(A.GetToggle(2, "TrinketsMinUnits"), A.GetToggle(2, "TrinketsUnitsRange")) and Player:AreaTTD(A.GetToggle(2, "TrinketsUnitsRange")) > A.GetToggle(2, "TrinketsMinTTD")	
				or
				not A.GetToggle(2, "TrinketsAoE") and Unit(unit):TimeToDie() >= A.GetToggle(2, "TrinketsMinTTD")	 					
			)
			then 
				return A.Trinket1:Show(icon)
			end 		
			
			-- Non SIMC Custom Trinket2
			if A.Trinket2:IsReady(unit) and Trinket2IsAllowed and inCombat and    
			(
				A.GetToggle(2, "TrinketsAoE") and GetByRange(A.GetToggle(2, "TrinketsMinUnits"), A.GetToggle(2, "TrinketsUnitsRange")) and Player:AreaTTD(A.GetToggle(2, "TrinketsUnitsRange")) > A.GetToggle(2, "TrinketsMinTTD")	
				or
				not A.GetToggle(2, "TrinketsAoE") and Unit(unit):TimeToDie() >= A.GetToggle(2, "TrinketsMinTTD")					
			)
			then
				return A.Trinket2:Show(icon) 	
	   		end 
			
		end
		
		--##########################
		--##### DARKGLARE PREP #####
		--##########################
		
		local function PrepareDarkglare(unit)
		
			--actions.darkglare_prep=vile_taint
			if A.VileTaint:IsReady(unit) then
				return A.VileTaint:Show(icon)
			end	
			
			--actions.darkglare_prep+=/dark_soul
			if A.DarkSoulMisery:IsReady(unit) then
				return A.DarkSoulMisery:Show(icon)
			end	
				
			--actions.darkglare_prep+=/fireblood
			if A.Fireblood:IsReady(unit) then
				return A.Fireblood:Show(icon)
			end	
			
			--actions.darkglare_prep+=/blood_fury
			if A.BloodFury:IsReady(unit) then
				return A.BloodFury:Show(icon)
			end	
			
			--actions.darkglare_prep+=/berserking
			if A.Berserking:IsReady(unit) then
				return A.Berserking:Show(icon)
			end	
			
			--actions.darkglare_prep+=/summon_darkglare
			if A.SummonDarkglare:IsReady(unit) then
				return A.SummonDarkglare:Show(icon)
			end	
		
		end

		--#########################
		--##### MAIN ROTATION #####
		--#########################
		
			--[[actions+=/call_action_list,name=darkglare_prep,if=cooldown.summon_darkglare.remains<2&(dot.phantom_singularity.remains>2|!talent.phantom_singularity.enabled)
			if (A.Darkglare:IsReady(unit) or A.Darkglare:GetCooldown() < 2) and (Unit(unit):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) > 2 or not A.PhantomSingularity:IsSpellLearned()) and HasAllDots then
				return A.PrepareDarkglare()
			end]]

			
			--actions=phantom_singularity
			if A.PhantomSingularity:IsReady(unit) then
				return A.PhantomSingularity:Show(icon)
			end
			
			--actions+=/vile_taint,if=soul_shard>1
			if A.VileTaint:IsReady(unit) and Player:SoulShardsP() > 1 then
				return A.VileTaint:Show(icon)
			end
			
			--actions+=/siphon_life,if=refreshable
			if A.SiphonLife:IsReady(unit) and SiphonLifeRefreshable then
				return A.SiphonLife:Show(icon)
			end	
			
			--actions+=/agony,if=refreshable
			if A.Agony:IsReady(unit) and AgonyRefreshable then
				return A.Agony:Show(icon)
			end				
			
			--actions+=/unstable_affliction,if=refreshable
			if A.UnstableAffliction:IsReady(unit) and UARefreshable then
				return A.UnstableAffliction:Show(icon)
			end
			
			--actions+=/unstable_affliction,if=azerite.cascading_calamity.enabled&buff.cascading_calamity.remains<3
			if A.UnstableAffliction:IsReady(unit) and A.CascadingCalamity:GetAzeriteRank() > 0 and Unit("player"):HasBuffs(A.CascadingCalamityBuff.ID, true) > 0 then
				return A.UnstableAffliction:Show(icon)
			end
			
			--actions+=/corruption,if=refreshable
			if A.Corruption:IsReady(unit) and CorruptionRefreshable and MultiUnits:GetActiveEnemies() < 3 then
				return A.Corruption:Show(icon)
			end				

			--actions+=/corruption,if=refreshable (AOE)
			if A.SeedofCorruption:IsReady(unit) and CorruptionRefreshable and MultiUnits:GetActiveEnemies() > 3 and Unit(unit):HasDeBuffs(A.SeedofCorruptionDebuff.ID, true) == 0 and A.SeedofCorruption:GetSpellTimeSinceLastCast() > 2 then
				return A.SeedofCorruption:Show(icon)
			end		
			
			--actions+=/haunt
			if A.Haunt:IsReady(unit) then
				return A.Haunt:Show(icon)
			end
			
			--[[actions+=/call_action_list,name=darkglare_prep,if=cooldown.summon_darkglare.remains<2&(dot.phantom_singularity.remains>2|!talent.phantom_singularity.enabled)
			if (A.SummonDarkglare:IsReady(unit) or A.SummonDarkglare:GetCooldown() < 2) and (Unit(unit):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) > 2 or not A.PhantomSingularity:IsSpellLearned()) then
				if PrepareDarkglare(unit) then
					return true
				end
			end]]
			
			--actions+=/dark_soul,if=cooldown.summon_darkglare.remains>time_to_die
			if A.DarkSoulMisery:IsReady(unit) and A.SummonDarkglare:GetCooldown() > Unit(unit):TimeToDie() then
				return A.DarkSoulMisery:Show(icon)
			end	
			
			--[[actions+=/call_action_list,name=cooldowns
			if BurstIsON and Cooldowns() then
				return true
			end]]
			
			--actions+=/malefic_rapture,if=dot.vile_taint.ticking
			if A.MaleficRapture:IsReady(unit) and Unit(unit):HasDeBuffs(A.VileTaint.ID, true) > 0 then
				return A.MaleficRapture:Show(icon)
			end	
			
			--actions+=/malefic_rapture,if=talent.phantom_singularity.enabled&(dot.phantom_singularity.ticking||cooldown.phantom_singularity.remains>12||soul_shard>3)
			if A.MaleficRapture:IsReady(unit) and A.PhantomSingularity:IsSpellLearned() and (Unit(unit):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) > 0 or A.PhantomSingularity:GetCooldown() > 12 or Player:SoulShardsP() > 3) then
				return A.MaleficRapture:Show(icon)
			end	
			
			--actions+=/malefic_rapture,if=talent.sow_the_seeds.enabled
			if A.MaleficRapture:IsReady(unit) and A.SowtheSeeds:IsSpellLearned() then
				return A.MaleficRapture:Show(icon)
			end	
			
			--actions+=/drain_life,if=buff.inevitable_demise.stack>30
			if A.DrainLife:IsReady(unit) and Unit("player"):HasBuffsStacks(A.InevitableDemiseBuff.ID, true) > 30 then
				return A.DrainLife:Show(icon)
			end
			
			--actions+=/drain_life,if=buff.inevitable_demise_az.stack>30
			--actions+=/drain_soul
			if A.DrainSoul:IsReady(unit) then
				return A.DrainShow:Show(icon)
			end	
			
			--actions+=/shadow_bolt
			if A.ShadowBolt:IsReady(unit) then
				return A.ShadowBolt:Show(icon)
			end	


        --[[ Mouseover
        if unit == "mouseover" then  -- and not Unit(unit):IsTotem()
	
			-- Variables
		    local useKick, useCC, useRacial = Action.InterruptIsValid(unit, "TargetMouseover") 
            inRange = A.Agony:IsInRange(unit)
		
		    -- PetKick
            if useKick and A.PetKick:IsReady(unit) then 
                return A.PetKick:Show(icon)
            end 

    	    -- SingeMagic
	        if A.SingeMagic:IsCastable() and not A.IsUnitEnemy("mouseover") and not ShouldStop and Action.AuraIsValid(unit, "UseDispel", "Magic") then
	            return A.SingeMagic:Show(icon)
            end		
	
			--actions+=/siphon_life,if=refreshable
			if A.SiphonLife:IsReady() and SiphonLifeRefreshable then
				return A.SiphonLife:Show(icon)
			end	
			
			--actions+=/agony,if=refreshable
			if A.Agony:IsReady() and AgonyRefreshable then
				return A.Agony:Show(icon)
			end				
			
			--actions+=/unstable_affliction,if=refreshable
			if A.UnstableAffliction:IsReady() and UARefreshable then
				return A.UnstableAffliction:Show(icon)
			end				
			
			--actions+=/unstable_affliction,if=azerite.cascading_calamity.enabled&buff.cascading_calamity.remains<3
			if A.UnstableAffliction:IsReady() and A.CascadingCalamity:GetAzeriteRank() > 0 and Unit("player"):HasBuffs(A.CascadingCalamityBuff.ID, true) > 0 then
				return A.UnstableAffliction:Show(icon)
			end	
			
			--actions+=/corruption,if=refreshable
			if A.Corruption:IsReady() and CorruptionRefreshable and MultiUnits:GetActiveEnemies() < 3 then
				return A.Corruption:Show(icon)
			end		
			
		end]]	
		
		if not inCombat then
			return Precombat()
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
    Unit("player"):GetDR("incapacitate") >= 50 
    then 
        local Caster = UnitCooldown:GetUnitID("arena", 3355)
        if Caster and Unit(Caster):GetRange() <= 40 then 
            return true 
        end 
    end 
end]]-- 

--[[local function ArenaRotation(icon, unit)
    if A.IsInPvP and (A.Zone == "pvp" or A.Zone == "arena") and not Player:IsStealthed() and not Player:IsMounted() then   
        local useKick, useCC, useRacial = A.InterruptIsValid(unit, "PvP")    
 		
		-- Interrupt
   		local Interrupt = Interrupts(unit)
  		if Interrupt then 
  		    return Interrupt:Show(icon)
  		end	 
		
	    -- Pet Kick
        if useKick and A.PetKick:IsReady(unit) and A.PetKick:AbsentImun(unit, Temp.TotalAndMagKick, true) then 
            return A.PetKick:Show(icon)
        end 
   
        -- Shadow Fury   
        if useCC and A.Shadowfury:IsReady(unit) and MultiUnits:GetByRange(10) >= 2 and A.Shadowfury:AbsentImun(unit, Temp.TotalAndCC, true) and Unit(unit):IsControlAble("stun", 0) then 
            return A.Shadowfury:Show(icon)              
        end 
		
	    -- Fear
	    if useCC and A.Fear:IsReady(unit) and A.Fear:AbsentImun(unit, Temp.TotalAndCC, true) and Unit(unit):IsControlAble("disorient", 0) then 
            return A.Fear:Show(icon)              
        end	
		
        -- Reflect Casting BreakAble CC
        if A.NetherWard:IsReady() and A.NetherWard:IsSpellLearned() and Action.ShouldReflect(unit) and EnemyTeam():IsCastingBreakAble(0.25) then 
            return A.NetherWard:Show(icon)
        end  
                        
    end 
end ]]

A[6] = nil

A[7] = nil

A[8] = nil