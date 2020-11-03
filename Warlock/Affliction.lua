--#####################################
--##### TRIP'S AFFLICTION WARLOCK #####
--#####################################

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
local IsIndoors, UnitIsUnit                     = IsIndoors, UnitIsUnit
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
    ShadowBolt                           = Action.Create({ Type = "Spell", ID = 686     }),
    DarkSoulMisery                       = Action.Create({ Type = "Spell", ID = 113860     }),
    SummonDarkglare                      = Action.Create({ Type = "Spell", ID = 205180     }),
    SiphonLife                           = Action.Create({ Type = "Spell", ID = 63106      }),
    Agony                                = Action.Create({ Type = "Spell", ID = 980        }),
    Corruption                           = Action.Create({ Type = "Spell", ID = 172        }),
    CreepingDeath                        = Action.Create({ Type = "Spell", ID = 264000, Hidden = true     }),
    WritheInAgony                        = Action.Create({ Type = "Spell", ID = 196102, Hidden = true     }),
    UnstableAffliction                   = Action.Create({ Type = "Spell", ID = 316099      }),
    AbsoluteCorruption                   = Action.Create({ Type = "Spell", ID = 196103, Hidden = true     }),
    DrainLife                            = Action.Create({ Type = "Spell", ID = 234153     }),
    PhantomSingularity                   = Action.Create({ Type = "Spell", ID = 205179     }),
    VileTaint                            = Action.Create({ Type = "Spell", ID = 278350     }),
    DrainSoul                            = Action.Create({ Type = "Spell", ID = 198590     }),
    CascadingCalamity                    = Action.Create({ Type = "Spell", ID = 275372     }),
    SowtheSeeds                          = Action.Create({ Type = "Spell", ID = 196226, Hidden = true     }),
    PetKick                              = Action.Create({ Type = "SpellSingleColor", ID = 119910, Color = "RED", Desc = "RED Color for Pet Target kick" }),  
    FearGreen                            = Action.Create({ Type = "SpellSingleColor", ID = 5782, Color = "GREEN", Desc = "[2] Kick", Hidden = true, QueueForbidden = true }),	
    Fear                                 = Action.Create({ Type = "Spell", ID = 5782       }),
    SpellLock                            = Action.Create({ Type = "Spell", ID = 119898     }),
    DispellMagic                         = Action.Create({ Type = "Spell", ID = 111400     }),
    Shadowfury                           = Action.Create({ Type = "Spell", ID = 30283      }),
    PandemicInvocation                   = Action.Create({ Type = "Spell", ID = 289364     }),
	MaleficRapture						 = Action.Create({ Type = "Spell", ID = 324536	   }),
	FelDomination						 = Action.Create({ Type = "Spell", ID = 333889	   }),	
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
	StopCast 				             = Action.Create({ Type = "Spell", ID = 61721, Hidden = true     }),		-- spell_magic_polymorphrabbit
    -- Buffs
    GrimoireofSacrificeBuff              = Action.Create({ Type = "Spell", ID = 196099, Hidden = true     }),
    ActiveUasBuff                        = Action.Create({ Type = "Spell", ID = 233490, Hidden = true     }),
    InevitableDemiseBuff                 = Action.Create({ Type = "Spell", ID = 273525, Hidden = true     }),
    NightfallBuff                        = Action.Create({ Type = "Spell", ID = 264571, Hidden = true     }),
    CascadingCalamityBuff                = Action.Create({ Type = "Spell", ID = 275378, Hidden = true     }),
    WrackingBrillianceBuff               = Action.Create({ Type = "Spell", ID = 272891, Hidden = true    }),
    -- Debuffs 
    SeedofCorruptionDebuff               = Action.Create({ Type = "Spell", ID = 27243, Hidden = true}),
    HauntDebuff                          = Action.Create({ Type = "Spell", ID = 48181, Hidden = true}),
    UnstableAfflictionDebuff             = Action.Create({ Type = "Spell", ID = 316099, Hidden = true}),
    PhantomSingularityDebuff             = Action.Create({ Type = "Spell", ID = 205179, Hidden = true}),
    SiphonLifeDebuff                     = Action.Create({ Type = "Spell", ID = 63106, Hidden = true}),
    AgonyDebuff                          = Action.Create({ Type = "Spell", ID = 980, Hidden = true}),
    CorruptionDebuff                     = Action.Create({ Type = "Spell", ID = 146739, Hidden = true     }),
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
	
	-- Extra icons until GG update
	SpatialRift							   = Action.Create({ Type = "Spell", ID = 256948 }), -- used for Malefic Rapture
	Darkflight							   = Action.Create({ Type = "Spell", ID = 68992 }), -- used for Heart of Azeroth	
	RocketJump							   = Action.Create({ Type = "Spell", ID = 69070 }), -- used for Heart of Azeroth	
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
	local inCombat = Unit("player"):CombatTime() > 0
	local Pull = Action.BossMods:GetPullTimer()
	local profileStop = false	

	--Refreshables
	SiphonLifeRefreshable = (Unit("target"):HasDeBuffs(A.SiphonLifeDebuff.ID, true) == 0 or Unit("target"):HasDeBuffs(A.SiphonLifeDebuff.ID, true) < 6)
	CorruptionRefreshable = (Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID, true) == 0 or Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID, true) < 6)
	AgonyRefreshable = (Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) == 0 or Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) < 6)


	HasAllDots = Unit("target"):HasDeBuffs(A.SiphonLifeDebuff.ID, true) > 0 and Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID, true) > 0 and Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) > 0 and Unit("target"):HasDeBuffs(A.UnstableAfflictionDebuff.ID, true) > 0

	
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
			if A.SeedofCorruption:IsReady("target") and A.SowtheSeeds:IsTalentLearned() and not A.IsSpellInCasting(A.SeedofCorruption) and A.GetToggle(2, "ForceAoE") and A.GetToggle(2, "AoE") and A.LastPlayerCastID ~= A.SeedofCorruption.ID and not inCombat then
				return A.SeedofCorruption:Show(icon)
			end	
			
			--actions.precombat+=/grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled
			if A.GrimoireofSacrifice:IsReady("player") and Unit("player"):HasBuffs(A.GrimoireofSacrificeBuff.ID, true) == 0 and A.GrimoireofSacrifice:IsTalentLearned() then
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
			if A.ShadowBolt:IsReady(unit) and not A.DrainSoul:IsTalentLearned() and not A.Haunt:IsTalentLearned() and MultiUnits:GetActiveEnemies() < 3 then
				return A.ShadowBolt:Show(icon)
			end	

			if A.Agony:IsReady(unit) and AgonyRefreshable then
				return A.Agony:Show(icon)
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
		
		local function Main(unit)
				
			--Fel Domination if Pet dies
			if A.FelDomination:IsReady("player") and not Pet:IsActive() and inCombat then
				return A.RocketJump:Show(icon)
			end
			
			--Summon Pet with Fel Domination
			if SummonPet:IsReady("player") and (not isMoving) and not Pet:IsActive() and Unit("player"):HasBuffs(A.GrimoireofSacrificeBuff.ID, true) == 0 and Unit("player"):HasBuffs(A.FelDomination.ID, true) > 0 then
				return SummonPet:Show(icon)
			end		
			
			--actions=phantom_singularity
			if A.PhantomSingularity:IsReady(unit, nil, nil, true) then
				return A.PhantomSingularity:Show(icon)
			end
			
			--actions+=/vile_taint,if=soul_shard>1
			if A.VileTaint:IsReady(unit, nil, nil, true) and not A.IsSpellInCasting(A.VileTaint) and Player:SoulShardsP() > 1 then
				return A.VileTaint:Show(icon)
			end

			--actions+=/corruption,if=refreshable (AOE)
			if A.SeedofCorruption:IsReady("target", nil, nil, true) and not A.IsSpellInCasting(A.SeedofCorruption) and CorruptionRefreshable and MultiUnits:GetActiveEnemies() >= 3 and Unit("target"):HasDeBuffs(A.SeedofCorruptionDebuff.ID, true) == 0 then
				return A.SeedofCorruption:Show(icon)
			end					
			
			--actions+=/siphon_life,if=refreshable
			if A.SiphonLife:IsReady(unit, nil, nil, true) and SiphonLifeRefreshable and Unit("target"):TimeToDie() > 5 then
				return A.SiphonLife:Show(icon)
			end	
			
			--actions+=/agony,if=refreshable
			if A.Agony:IsReady(unit, nil, nil, true) and AgonyRefreshable and Unit("target"):TimeToDie() > 5 then
				return A.Agony:Show(icon)
			end				
			
			--actions+=/unstable_affliction,if=refreshable
			if A.UnstableAffliction:IsReady(unit, nil, nil, true) and not A.IsSpellInCasting(A.UnstableAffliction) and (Player:GetDeBuffsUnitCount(A.UnstableAffliction.ID) < 1 or (Unit("target"):HasDeBuffs(A.UnstableAffliction.ID, true) > 0 and Unit("target"):HasDeBuffs(A.UnstableAffliction.ID, true) < 5)) then
				return A.UnstableAffliction:Show(icon)
			end
			
			
			--actions+=/corruption,if=refreshable
			if A.Corruption:IsReady(unit, nil, nil, true) and CorruptionRefreshable and Unit("target"):TimeToDie() > 5 and  MultiUnits:GetActiveEnemies() < 3 and not A.IsSpellInCasting(A.SeedofCorruption) and Unit("target"):HasDeBuffs(A.SeedofCorruptionDebuff.ID, true) == 0 then
				return A.Corruption:Show(icon)
			end				
			
			--actions+=/haunt
			if A.Haunt:IsReady(unit) then
				return A.Haunt:Show(icon)
			end
			
			--actions+=/call_action_list,name=darkglare_prep,if=cooldown.summon_darkglare.remains<2&(dot.phantom_singularity.remains>2|!talent.phantom_singularity.enabled)
			if (A.SummonDarkglare:IsReady("player") or A.SummonDarkglare:GetCooldown() < 2) and BurstIsON("target") and (Unit("target"):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) > 2 or not A.PhantomSingularity:IsTalentLearned()) then
				if PrepareDarkglare(unit) then
					return true
				end
			end
			
			--actions+=/dark_soul,if=cooldown.summon_darkglare.remains>time_to_die
			if A.DarkSoulMisery:IsReady("player") and BurstIsON("target") and A.SummonDarkglare:GetCooldown() > Unit("target"):TimeToDie() then
				return A.DarkSoulMisery:Show(icon)
			end	
			
			--[[actions+=/call_action_list,name=cooldowns
			if BurstIsON(unit) then 
				if Cooldowns(unit) then
				return true
			end]]
			
				-- guardian_of_azeroth
			if A.GuardianofAzeroth:IsReady("target") and BurstIsON("target") then
				return A.Darkflight:Show(icon)
			end
			
			-- focused_azerite_beam
			if A.FocusedAzeriteBeam:IsReady("target") and BurstIsON("target") then
				return A.Darkflight:Show(icon)
			end
			
			-- memory_of_lucid_dreams
			if A.MemoryofLucidDreams:IsReady("target") and BurstIsON("target") then
				return A.Darkflight:Show(icon)
			end
			
			-- blood_of_the_enemy
			if A.BloodoftheEnemy:IsReady("target") and BurstIsON("target") then
				return A.Darkflight:Show(icon)
			end
			
			-- purifying_blast
			if A.PurifyingBlast:IsReady("target") and BurstIsON("target") then
				return A.Darkflight:Show(icon)
			end
			
			--[[ ripple_in_space
			if A.RippleInSpace:AutoHeartOfAzerothP(unit, true) and HeartOfAzeroth then
				return A.Darkflight:Show(icon)
			end]]
			
			-- concentrated_flame,line_cd=6
			if A.ConcentratedFlame:IsReady("target") and BurstIsON("target") then
				return A.Darkflight:Show(icon)
			end
			
			-- reaping_flames
			if A.ReapingFlames:IsReady("target") and BurstIsON("target") then
				return A.Darkflight:Show(icon)
			end	
		
			-- Trinket One
			if A.Trinket1:IsReady("target") and BurstIsON("target") then 
				return A.Trinket1:Show(icon)
			end 		
			
			-- Trinket Two
			if A.Trinket1:IsReady("target") and BurstIsON("target") then 
				return A.Trinket2:Show(icon)
			end 		
			
			--actions+=/malefic_rapture,if=dot.vile_taint.ticking
			if A.MaleficRapture:IsReady("player") and Unit("target"):HasDeBuffs(A.VileTaint.ID, true) > 0 then
				return A.SpatialRift:Show(icon)
			end	
			
			--actions+=/malefic_rapture,if=talent.phantom_singularity.enabled&(dot.phantom_singularity.ticking||cooldown.phantom_singularity.remains>12||soul_shard>3)
			if A.MaleficRapture:IsReady("player") and A.PhantomSingularity:IsTalentLearned() and (Unit("target"):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) > 0 or A.PhantomSingularity:GetCooldown() > 12 or Player:SoulShardsP() > 3) then
				return A.SpatialRift:Show(icon)
			end	
			
			--actions+=/malefic_rapture,if=talent.sow_the_seeds.enabled
			if A.MaleficRapture:IsReady("player") and A.SowtheSeeds:IsTalentLearned() then
				return A.SpatialRift:Show(icon)
			end	
			
			--actions+=/drain_life,if=buff.inevitable_demise.stack>30
			if A.DrainLife:IsReady(unit) and Unit("player"):HasBuffsStacks(A.InevitableDemiseBuff.ID, true) > 30 then
				return A.DrainLife:Show(icon)
			end
			
			--actions+=/drain_life,if=buff.inevitable_demise_az.stack>30
			--actions+=/drain_soul
			if A.DrainSoul:IsReady(unit) then
				return A.DrainSoul:Show(icon)
			end	
			
			--actions+=/shadow_bolt
			if A.ShadowBolt:IsReady(unit) then
				return A.ShadowBolt:Show(icon)
			end	
		end
		
		if not inCombat then
			return Precombat()
		end
		
		if inCombat then
			return Main()
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