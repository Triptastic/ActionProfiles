--#####################################
--##### Spiken's AFFLICTION WARLOCK #####
--#####################################

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


--local GetSpellTexture 							= _G.TMW.GetSpellTexture
FirstTarget = {"FirstTarget"}
SwappedTarget = {"SwappedTarget"}
Swapped = false
DotRotation = false
DotRotationCount = 0
isFirstUnit = true


--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

Action[ACTION_CONST_WARLOCK_AFFLICTION] = {
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
	
	--Warlock General
    Banish			     		= Action.Create({ Type = "Spell", ID = 710		}),
    Corruption					= Action.Create({ Type = "Spell", ID = 172		}),
    CorruptionDebuff			= Action.Create({ Type = "Spell", ID = 146739, Hidden = true	}),
    CreateHealthstone       	= Action.Create({ Type = "Spell", ID = 6201		}),
    CreateSoulwell		    	= Action.Create({ Type = "Spell", ID = 29893	}),
    CurseofExhaustion      	 	= Action.Create({ Type = "Spell", ID = 334275	}),
    CurseofTongues				= Action.Create({ Type = "Spell", ID = 1714		}),
    CurseofWeakness				= Action.Create({ Type = "Spell", ID = 702		}),
    DemonicCircle				= Action.Create({ Type = "Spell", ID = 48018	}),
    DemonicCircleTeleport		= Action.Create({ Type = "Spell", ID = 48020	}),	
    DemonicGateway				= Action.Create({ Type = "Spell", ID = 111771	}),	
    DrainLife					= Action.Create({ Type = "Spell", ID = 234153	}),
    EyeofKilrogg				= Action.Create({ Type = "Spell", ID = 126		}),
	Fear						= Action.Create({ Type = "Spell", ID = 5782		}),
	FelDomination				= Action.Create({ Type = "Spell", ID = 333889	}),	
	HealthFunnel				= Action.Create({ Type = "Spell", ID = 755		}),	
	RitualofDoom				= Action.Create({ Type = "Spell", ID = 342601	}),	
	RitualofSummoning			= Action.Create({ Type = "Spell", ID = 698		}),	
	ShadowBolt					= Action.Create({ Type = "Spell", ID = 686		}),	
	Shadowfury					= Action.Create({ Type = "Spell", ID = 30283	}),	
	Soulstone					= Action.Create({ Type = "Spell", ID = 20707	}),	
	SubjugateDemon				= Action.Create({ Type = "Spell", ID = 1098		}),	
	UnendingBreath				= Action.Create({ Type = "Spell", ID = 5697		}),	
	UnendingResolve				= Action.Create({ Type = "Spell", ID = 104773	}),	

	--Pet Summon
    SummonImp					= Action.Create({ Type = "Spell", ID = 688		}),    
    SummonVoidwalker			= Action.Create({ Type = "Spell", ID = 697		}),
    SummonFelhunter				= Action.Create({ Type = "Spell", ID = 691		}),
    SummonSuccubus				= Action.Create({ Type = "Spell", ID = 712		}),	
    CommandDemon				= Action.Create({ Type = "Spell", ID = 119898	}),	
    SingeMagic					= Action.Create({ Type = "Spell", ID = 119905	}),	
    ShadowBulwark				= Action.Create({ Type = "Spell", ID = 119907	}),	
    SpellLock					= Action.Create({ Type = "Spell", ID = 119910	}),	
    Seduction					= Action.Create({ Type = "Spell", ID = 119909	}),	

	--Affliction Spells
    Agony						= Action.Create({ Type = "Spell", ID = 980		}),
    AgonyDebuff					= Action.Create({ Type = "Spell", ID = 980, Hidden = true		}),
    MaleficRapture				= Action.Create({ Type = "Spell", ID = 324536, Hidden = true	}),
    SeedofCorruption			= Action.Create({ Type = "Spell", ID = 27243	}),
    SeedofCorruptionDebuff		= Action.Create({ Type = "Spell", ID = 27243, Hidden = true		}),
	SummonDarkglare				= Action.Create({ Type = "Spell", ID = 205180	}),
    UnstableAffliction			= Action.Create({ Type = "Spell", ID = 316099	}),
    UnstableAfflictionDebuff	= Action.Create({ Type = "Spell", ID = 316099, Hidden = true	}),

	--Normal Talents
    Nightfall					= Action.Create({ Type = "Spell", ID = 108558, Hidden = true	}),
    NightfallBuff				= Action.Create({ Type = "Spell", ID = 264571, Hidden = true	}),
    InevitableDemise			= Action.Create({ Type = "Spell", ID = 334319, Hidden = true	}),
    InevitableDemiseBuff		= Action.Create({ Type = "Spell", ID = 273525, Hidden = true	}),
    DrainSoul					= Action.Create({ Type = "Spell", ID = 198590	}),
    WritheinAgony				= Action.Create({ Type = "Spell", ID = 196102	}),
    AbsoluteCorruption			= Action.Create({ Type = "Spell", ID = 196103	}),
    SiphonLife					= Action.Create({ Type = "Spell", ID = 63106	}),
    SiphonLifeDebuff			= Action.Create({ Type = "Spell", ID = 63106, Hidden = true		}),	
    DemonSkin					= Action.Create({ Type = "Spell", ID = 219272, Hidden = true	}),
    BurningRush					= Action.Create({ Type = "Spell", ID = 111400	}),
    DarkPact					= Action.Create({ Type = "Spell", ID = 108416	}),
    SowtheSeeds					= Action.Create({ Type = "Spell", ID = 196226, Hidden = true	}),
    PhantomSingularity			= Action.Create({ Type = "Spell", ID = 205179	}),
    PhantomSingularityDebuff	= Action.Create({ Type = "Spell", ID = 205179, Hidden = true	}),	
    VileTaint					= Action.Create({ Type = "Spell", ID = 278350	}),
    Darkfury					= Action.Create({ Type = "Spell", ID = 264874, Hidden = true	}),
	MortalCoil					= Action.Create({ Type = "Spell", ID = 6789		}),
	HowlofTerror				= Action.Create({ Type = "Spell", ID = 5484		}),
	DarkCaller					= Action.Create({ Type = "Spell", ID = 334183, Hidden = true	}),
    Haunt						= Action.Create({ Type = "Spell", ID = 48181	}),
    GrimoireofSacrifice			= Action.Create({ Type = "Spell", ID = 108503	}),
    GrimoireofSacrificeBuff		= Action.Create({ Type = "Spell", ID = 196099, Hidden = true	}),
    SoulConduit					= Action.Create({ Type = "Spell", ID = 215941, Hidden = true	}),
    CreepingDeath				= Action.Create({ Type = "Spell", ID = 264000, Hidden = true	}),
    DarkSoulMisery				= Action.Create({ Type = "Spell", ID = 113860	}),

    
       -- Buffs
       ActiveUasBuff                        = Action.Create({ Type = "Spell", ID = 233490, Hidden = true     }),
       CascadingCalamityBuff                = Action.Create({ Type = "Spell", ID = 275378, Hidden = true     }),
       WrackingBrillianceBuff               = Action.Create({ Type = "Spell", ID = 272891, Hidden = true    }),
       -- Debuffs 
       ShadowEmbraceDebuff                  = Action.Create({ Type = "Spell", ID = 32390, Hidden = true     }),
       ShiverVenomDebuff                    = Action.Create({ Type = "Spell", ID = 301624, Hidden = true     }),
       HauntDebuff                          = Action.Create({ Type = "Spell", ID = 48181, Hidden = true}),


	--PvP Talents
    BaneofFragility				= Action.Create({ Type = "Spell", ID = 199954	}),
    Deathbolt					= Action.Create({ Type = "Spell", ID = 264106	}),
    Soulshatter					= Action.Create({ Type = "Spell", ID = 212356	}),
    GatewayMastery				= Action.Create({ Type = "Spell", ID = 248855, Hidden = true	}),
    RotandDecay					= Action.Create({ Type = "Spell", ID = 212371, Hidden = true	}),
    BaneofShadows				= Action.Create({ Type = "Spell", ID = 234877	}),
    NetherWard					= Action.Create({ Type = "Spell", ID = 212295	}),
    EssenceDrain				= Action.Create({ Type = "Spell", ID = 221711, Hidden = true	}),
    CastingCircle				= Action.Create({ Type = "Spell", ID = 221703	}),
    DemonArmor					= Action.Create({ Type = "Spell", ID = 285933	}),
    AmplifyCurse				= Action.Create({ Type = "Spell", ID = 328774	}),
    RampantAfflictions			= Action.Create({ Type = "Spell", ID = 335052, Hidden = true	}),
    RapidContagion				= Action.Create({ Type = "Spell", ID = 344566	}),
	
	-- Covenant Abilities
    ScouringTithe				= Action.Create({ Type = "Spell", ID = 312321	}),
    SummonSteward				= Action.Create({ Type = "Spell", ID = 324739	}),
    ImpendingCatastrophe		= Action.Create({ Type = "Spell", ID = 321792	}),
    DoorofShadows				= Action.Create({ Type = "Spell", ID = 300728	}),
    DecimatingBolt				= Action.Create({ Type = "Spell", ID = 325289	}),
    Fleshcraft					= Action.Create({ Type = "Spell", ID = 331180	}),
    SoulRot						= Action.Create({ Type = "Spell", ID = 325640	}),
    Soulshape					= Action.Create({ Type = "Spell", ID = 310143	}),
    Flicker						= Action.Create({ Type = "Spell", ID = 324701	}),

	-- Conduits
    ColdEmbrace					= Action.Create({ Type = "Spell", ID = 339576, Hidden = true	}),	
    CorruptingLeer				= Action.Create({ Type = "Spell", ID = 339455, Hidden = true	}),	
    FocusedMalignancy			= Action.Create({ Type = "Spell", ID = 339500, Hidden = true	}),	
    RollingAgony				= Action.Create({ Type = "Spell", ID = 339481, Hidden = true	}),	
    SoulTithe					= Action.Create({ Type = "Spell", ID = 340229, Hidden = true	}),	
    CatastrophicOrigin			= Action.Create({ Type = "Spell", ID = 340316, Hidden = true	}),	
    FatalDecimation				= Action.Create({ Type = "Spell", ID = 340268, Hidden = true	}),	
    SoulEater					= Action.Create({ Type = "Spell", ID = 340348, Hidden = true	}),	
    AccruedVitality				= Action.Create({ Type = "Spell", ID = 339282, Hidden = true	}),	
    DiabolicBloodstone			= Action.Create({ Type = "Spell", ID = 340562, Hidden = true	}),	
    ResoluteBarrier				= Action.Create({ Type = "Spell", ID = 339272, Hidden = true	}),	
    DemonicMomentum				= Action.Create({ Type = "Spell", ID = 339411, Hidden = true	}),	
    FelCelerity					= Action.Create({ Type = "Spell", ID = 339130, Hidden = true	}),	
    ShadeofTerror				= Action.Create({ Type = "Spell", ID = 339379, Hidden = true	}),	
    KilroggsCunning				= Action.Create({ Type = "Spell", ID = 58081, Hidden = true		}),	

	

	-- Legendaries
	-- General Legendaries
    ClawofEndereth				= Action.Create({ Type = "Spell", ID = 337038, Hidden = true	}),
    PillarsoftheDarkPortal		= Action.Create({ Type = "Spell", ID = 337065, Hidden = true	}),
    RelicofDemonicSynergy		= Action.Create({ Type = "Spell", ID = 337057, Hidden = true	}),
    WilfredsSigil				= Action.Create({ Type = "Spell", ID = 337020, Hidden = true	}),
	--Affliction
    MaleficWrath				= Action.Create({ Type = "Spell", ID = 337122, Hidden = true	}),
    PerpetualAgony				= Action.Create({ Type = "Spell", ID = 337106, Hidden = true	}),
    SacrolashsDarkStrike		= Action.Create({ Type = "Spell", ID = 337111, Hidden = true	}),
    WrathofConsumption			= Action.Create({ Type = "Spell", ID = 337128, Hidden = true	}),


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
    SpiritualHealingPotion			= Action.Create({ Type = "Potion", ID = 171267, QueueForbidden = true }),   


	-- Extra icons until GG update
	SpatialRift							   = Action.Create({ Type = "Spell", ID = 256948 }), -- used for Malefic Rapture
	RocketJump							   = Action.Create({ Type = "Spell", ID = 69070 }), -- used for FelDomination
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

-- Pet Handler UI (Thanks Taste and Trip)--
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

local function CheckingRange()
    
    local rangeCheckCount = 0     
        
        for irangeCheckCount in pairs(ActiveUnitPlates) do     
            local unit = "nameplate"..irangeCheckCount
            if UnitCanAttack("player", unit) and UnitAffectingCombat("target") and IsItemInRange(10645, unit) and UnitIsUnit("player", unit) then
                rangeCheckCount = rangeCheckCount + 1
                
            end
        end
    
    if rangeCheckCount > 1 then return true else return false end
end

local function EnemiesCount()
    
    local enemiesCheckCount = 0     
        
        for ienemiesCheckCount in pairs(ActiveUnitPlates) do    
            local unit = "nameplate"..ienemiesCheckCount
            if UnitCanAttack("player", unit) and UnitAffectingCombat("target") and IsItemInRange(10645, unit) and UnitIsUnit("player", unit) then
                enemiesCheckCount = enemiesCheckCount + 1
                
            end
        end
    
    if enemiesCheckCount > 1 then return enemiesCheckCount else return 0 end
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
		---  UI stuff  ---
		--------------------
        local MultiDotDistance = A.GetToggle(2, "MultiDotDistance")
        local AutoMultiDot = A.GetToggle(2, "AutoMultiDot")
        local AoE = A.GetToggle(2, "AoE")
        local DrainLifeHP = A.GetToggle(2, "DrainLifeHP")	
        local HealthFunnelHP = A.GetToggle(2, "HealthFunnelHP")
		 
	--------------------
	---  VARIABLES   ---
	--------------------
    local isMoving = A.Player:IsMoving()
    local Pull = Action.BossMods:GetPullTimer()
    local Pull2 = Unit("player"):CombatTime()
	local profileStop = false	
	local inCombat = Unit("player"):CombatTime() > 0
    local ShouldStop = Action.ShouldStop()

	--------------------
	---  ENEMIES   ---
	--------------------
local arrySize = 1
local RememberTargetGuid = {}
local isInArray = false
DotRotationDot = Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true)



	--------------------
	---  DOT Stuff and AoE  ---
	--------------------


    local function num(val)
    if val then return 1 else return 0 end
  end
  
  local function bool(val)
    return val ~= 0
  end
  
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
        		
		-->PRECOMBAT <-- DONE
   
        local function Precombat(unit)
            --print("Precombat 1")
			-- flask
			-- food
			-- augmentation
			-- summon_pet
            -- Summon Pet - DONE
            --print("Precombat not in combat")

            			--Fel Domination if Pet dies
			if A.FelDomination:IsReady("player") and not Pet:IsActive() and Unit("player"):HasBuffs(A.GrimoireofSacrificeBuff.ID, true) == 0 and inCombat then
				return A.RocketJump:Show(icon)
            end
            
			if SummonPet:IsReady(unit) and (not isMoving) and not Pet:IsActive() and Unit("player"):HasBuffs(A.GrimoireofSacrificeBuff.ID, true) == 0 then
				return SummonPet:Show(icon)
			end		
					  
			--actions.precombat+=/grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled-DONE
			if A.GrimoireofSacrifice:IsReady(unit) and Unit("player"):HasBuffs(A.GrimoireofSacrificeBuff.ID, true) == 0 and A.GrimoireofSacrifice:IsTalentLearned() then
				return A.GrimoireofSacrifice:Show(icon)
			end		
			-- snapshot_stats
			-- seed_of_corruption,if=spell_targets.seed_of_corruption_aoe>=3 - DONE
			if A.SeedofCorruption:IsReady(unit) and (not isMoving) and A.LastPlayerCastID ~= A.SeedofCorruption.ID and (EnemiesCount() >= 3 or MultiUnits:GetActiveEnemies() >= 3) and Player:SoulShards() > 0 and Unit("target"):HasDeBuffs(A.SeedofCorruptionDebuff.ID,true) == 0 and Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID,true) == 0 and not A.IsSpellInCasting(A.SeedofCorruption) and Player:GetDeBuffsUnitCount(A.SeedofCorruptionDebuff.ID) < 1 and A.SeedofCorruption:GetSpellTimeSinceLastCast() > 3 then
			 return A.SeedofCorruption:Show(icon) 
            end
            -- Custom precombat Agony with talents 3,3,1,1,1,1,3 - DONE
            if  A.Agony:IsReady(unit) and A.Agony:AbsentImun(unit, Temp.TotalAndMag) and Unit("target"):GetRange() <= 40 and A.LastPlayerCastID ~= A.Agony.ID then
                return A.Agony:Show(icon)
            end
			-- haunt -Use haunt if talent as precast else use shadowbolt DONE
            if A.Haunt:IsSpellLearned() and A.Haunt:IsReady(unit) and not isMoving and not ShouldStop and A.LastPlayerCastID ~= A.Haunt.ID and (not isMoving) and A.Haunt:IsTalentLearned() then
			  return A.Haunt:Show(icon)
			end
			-- shadow_bolt
			if A.ShadowBolt:IsReady(unit) and not A.DrainSoul:IsSpellLearned() and not ShouldStop and not isMoving and (not A.Haunt:IsSpellLearned() and MultiUnits:GetActiveEnemies() < 3) then
				return A.ShadowBolt:Show(icon)
			end
             -- vile_taint,if=soul_shard>1 - DONE
              if A.VileTaint:IsReady(unit) and A.VileTaint:IsSpellInRange(unitID) and not isMoving then
                return A.VileTaint:Show(icon)
            end
			--Done
			-- corruption,if=(active_enemies<3|talent.vile_taint.enabled|talent.writhe_in_agony.enabled&!talent.sow_the_seeds.enabled)&refreshable
			if A.Corruption:IsReady(unit) and Unit("target"):HasDeBuffs(A.Corruption.ID, true) == 0 and A.LastPlayerCastID ~= A.Corruption.ID and A.LastPlayerCastID ~= A.SeedofCorruption.ID then
				return A.Corruption:Show(icon) 
			end
			-- DONE
			if A.UnstableAffliction:IsReady(unit) and not isMoving and A.LastPlayerCastID ~= A.UnstableAffliction.ID and (Unit("target"):HasDeBuffs(A.UnstableAffliction.ID,true) > 5 or Unit("target"):HasDeBuffs(A.UnstableAffliction.ID,true) > 5) then
			    return A.UnstableAffliction:Show(icon)
			end 
			--actions+=/siphon_life
            if A.SiphonLife:IsReady(unit) and A.SiphonLife:AbsentImun(unit, Temp.TotalAndMag) and Unit("target"):GetRange() <= 40 and A.LastPlayerCastID ~= A.SiphonLife.ID and A.SiphonLife:IsTalentLearned() then 
				return A.SiphonLife:Show(icon)
			end	

		  -- If full on SoulShard cast one MaleficRapture to not waste any soulshards - DONE
		  if A.MaleficRapture:IsReady(unit) and Player:SoulShards() == 5  and not isMoving and (Unit("target"):HasDeBuffs(A.AgonyDebuff.ID,true) > 5 or Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID,true) > 5 or Unit("target"):HasDeBuffs(A.VileTaint.ID,true) > 5) then
			return A.SpatialRift:Show(icon)
          end
            -- malefic_rapture,if=dot.vile_taint.ticking -- DONE
            if A.MaleficRapture:IsReady(unit) and not isMoving and Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) > 6 and Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID, true) > 6 and Unit("target"):HasDeBuffs(A.UnstableAfflictionDebuff.ID, true) > 6 and Player:SoulShards() >= 2 then
                return A.SpatialRift:Show(icon)
            end
            if A.MaleficRapture:IsReady(unit) and not isMoving and MultiUnits:GetActiveEnemies() >= 3 and Unit("target"):HasDeBuffs(A.VileTaint.ID, true) > 6 and Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) > 6 or Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID, true) > 6 or Unit("target"):HasDeBuffs(A.UnstableAfflictionDebuff.ID, true) > 6 and Player:SoulShards() >= 2 then
                return A.SpatialRift:Show(icon)
            end
          
        end -- PRecombat close
        ----------------------------------------------------------------------------------------------------------
		--> DARKGLARE PREP <-- DONE

        local function Darkglare_prep(unit)
            --print("Darkglare prep")
			-- dark_soul - DONE
			if A.DarkSoulMisery:IsReady(unit) and not isMoving then
			  return A.DarkSoulMisery:Show(icon)
			end
			-- potion TODO
			-- fireblood - DONE
			if A.Fireblood:IsCastable(unit) and not isMoving then
			  return A.Fireblood:Show(icon)
			end
			-- blood_fury - DONE
			if A.BloodFury:IsCastable(unit) and not isMoving then
			  return A.BloodFury:Show(icon)
			end
			-- berserking - DONE
			if A.Berserking:IsCastable(unit) and not isMoving then
			  return A.Berserking:Show(icon) 
			end
			-- summon_darkglare - DONE
			if A.SummonDarkglare:IsReady(unit) and not isMoving then
                return A.SummonDarkglare:Show(icon)
            end
            -- Trinket One
		    if A.Trinket1:IsReady("target") and BurstIsON("target") and not isMoving then 
			    return A.Trinket1:Show(icon)
		    end 		
			-- Trinket Two
		    if A.Trinket2:IsReady("target") and BurstIsON("target") and not isMoving then 
			    return A.Trinket2:Show(icon)
		    end 
		end -- Darkglare prep close
        ----------------------------------------------------------------------------------------------------------
        --> Fillers <--

        local function Fillers(unit)

                -- unstable_affliction,if=refreshable -- DONE
                if A.UnstableAffliction:IsReady(unit) and not isMoving and A.LastPlayerCastID ~= A.UnstableAffliction.ID and not Unit("target"):HasDeBuffs(A.UnstableAfflictionDebuff.ID,true) and (Unit("target"):HealthPercent() > 15 or Unit("target"):IsBoss()) then
                    return A.UnstableAffliction:Show(icon)
                end
                -- vile_taint,if=soul_shard>1 - DONE
                if A.VileTaint:IsReady(unit) and A.VileTaint:IsSpellInRange("target") and not isMoving and MultiUnits:GetActiveEnemies() >= 3 then
                    return A.VileTaint:Show(icon)
                end
                -- malefic_rapture,if=soul_shard>4 -- DONE
                if A.MaleficRapture:IsReady(unit) and not isMoving and Player:SoulShards() == 5 and (Unit("target"):HasDeBuffs(A.AgonyDebuff.ID,true) > 7 or Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID,true) > 7 or Unit("target"):HasDeBuffs(A.VileTaint.ID, true) > 7) and (Unit("target"):HealthPercent() > 15 or Unit("target"):IsBoss()) then
                    return A.SpatialRift:Show(icon)
                end
                -- haunt
                if A.Haunt:IsReady(unit) and A.Haunt:IsSpellInRange("target") and not isMoving and A.Haunt:IsTalentLearned() then
                    return A.Haunt:Show(icon) 
                end
                -- vile_taint,if=soul_shard>1 - DONE
                if A.VileTaint:IsReady(unit) and A.VileTaint:IsSpellInRange("target") and not isMoving then
                    return A.VileTaint:Show(icon)
                end
                -- malefic_rapture,if=soul_shard>4 -- DONE
                if A.SoulRot:IsReady(unit) and not isMoving then
                    return A.SoulRot:Show(icon)
                end
                -- drain_soul
                if A.DrainSoul:IsReady(unit) and A.DrainSoul:IsSpellInRange(unitID) and not isMoving and Unit("target"):HealthPercent() < 15 and Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) > 5 and A.AbsoluteCorruption:IsTalentLearned() and MultiUnits:GetActiveEnemies() >= 3 then
                    return A.DrainSoul:Show(icon)
                end
                -- drain_soul
                if A.DrainSoul:IsReady(unit) and A.DrainSoul:IsSpellInRange(unitID) and not isMoving and Unit("target"):HealthPercent() < 15 and Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) > 5 and MultiUnits:GetActiveEnemies() < 3 then
                    return A.DrainSoul:Show(icon)
                end
                -- drain_soul
                if A.DrainSoul:IsReady(unit) and A.DrainSoul:IsSpellInRange(unitID) and not isMoving and Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) > 5 and Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID, true) > 5 and Unit("target"):HasDeBuffs(A.UnstableAfflictionDebuff.ID, true) > 5 and not A.AbsoluteCorruption:IsTalentLearned() and MultiUnits:GetActiveEnemies() < 3 and Player:SoulShards() >= 3 then
                    return A.DrainSoul:Show(icon)
                end
                -- drain_soul
                if A.DrainSoul:IsReady(unit) and A.DrainSoul:IsSpellInRange(unitID) and not isMoving and Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) > 5 and Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID, true) and Unit("target"):HasDeBuffs(A.UnstableAfflictionDebuff.ID, true) > 5 and A.AbsoluteCorruption:IsTalentLearned() and MultiUnits:GetActiveEnemies() < 3 and Player:SoulShards() >= 3 then
                    return A.DrainSoul:Show(icon)
                end
                -- drain_soul
                if A.DrainSoul:IsReady(unit) and A.DrainSoul:IsSpellInRange(unitID) and not isMoving  and Player:SoulShards() <= 1 then
                    return A.DrainSoul:Show(icon)
                end
                -- shadow_bolt -- DONE
                if A.ShadowBolt:IsReady(unit) and A.ShadowBolt:IsSpellInRange(unitID) and not A.DrainSoul:IsTalentLearned() and not isMoving then
                    return A.ShadowBolt:Show(icon)
                end   
                        --Drain Life below HP %
		        if A.DrainLife:IsReady(unit) and Unit("player"):HealthPercent() <= DrainLifeHP then
			        return A.DrainLife:Show(icon)
                end	
                --Health Funnel
		        if A.HealthFunnel:IsReady("player") and Unit("pet"):HealthPercent() <= HealthFunnelHP and Unit("player"):HealthPercent() >= 30 then
			        return A.HealthFunnel:Show(icon)
                end	
        end   -- Fillers close
        ----------------------------------------------------------------------------------------------------------

		--> MAIN ROTATION <--
		
    local function Main(unit)
        --message("i main")
        if (Unit("player"):CombatTime() > 15 and DotRotationDot < 5) or (MultiUnits:GetActiveEnemies() <= 1 and UnitIsDead("target")) then
            --message("reset")
            FirstTarget = {"FirstTarget"}
            SwappedTarget = {"SwappedTarget"}
            Swapped = false
            DotRotation = false
            DotRotationCount = 0
            isFirstUnit = true  
        end

        if (EnemiesCount() >= 2 or CheckingRange() or MultiUnits:GetActiveEnemies() >= 2 or Unit("target"):IsDummy()) and AoE then
            --print("swapped target",SwappedTarget[1])
        if DotRotation == false then
               -- print("DotRotation = false")
            --Firsta omgång - DotRotation = false
            if isFirstUnit == true then
                --message("isFirstUnit = true",FirstTarget)
                if DotRotationDot > 1 and UnitAffectingCombat("target") then
                    --print("agony got cast on first target ")
                    isFirstUnit = false
                    DotRotationCount = DotRotationCount+1
                    Swapped = true
                        if FirstTarget[1] == "FirstTarget" then
                            --message("FirstTarget yes")
                            --print("first target")
                            FirstTarget[1] = UnitGUID("target")
                        end
                    --print("first target is: ", FirstTarget[1])
                    --message("Swappade firsttarget")
                    return A:Show(icon, ACTION_CONST_AUTOTARGET)
                end       
                   -- return

                if DotRotationDot == 0 and UnitAffectingCombat("target") then
                    --print("target has not debuff")
                    --if not UnitGUID("target") == SwappedTarget then
                        --print("not equal to swappedTarget")
                        --Swapped = false  
                       return A.Agony:Show(icon)
                end
            --Andra omgång - DotRotation = false
            elseif isFirstUnit == false then
                SwappedTarget[1] = UnitGUID("target")
                --print("isFirstUnit = false")
                    --Om vi är tillbaka på första target - DotRotation = true
                    if UnitGUID("target") == FirstTarget[1] or DotRotationCount >= 5 then
                       -- message("dotrotation = true")
                        --print("dotrotation = true")
                     DotRotation = true
                     --return
                    end 
                
                --if not UnitGUID("target") == SwappedTarget[1] or not SwappedTarget[1] == FirstTarget[1] then
                    --print("Not swapped")
                    if DotRotationDot > 1 and UnitAffectingCombat("target") then
                        --print("target has agony > 1")
                        DotRotationCount = DotRotationCount+1
                        SwappedTarget[1] = UnitGUID("target")
                        Swapped = true
                        --print("swapped second time")
                        return A:Show(icon, ACTION_CONST_AUTOTARGET)
                    end           
                    if DotRotationDot == 0 and UnitAffectingCombat("target") then
                        --print("Agony last")
                    return A.Agony:Show(icon)
                   end
                --end
            end
        end -- End DotRotation
        --else
    end
    if DotRotation == true or MultiUnits:GetActiveEnemies() <= 1 or EnemiesCount() <= 1 then
        --message("else clearar allt och main")

        -- drain_soul
        if A.DrainSoul:IsReady(unit) and A.DrainSoul:IsSpellInRange(unitID) and not isMoving and Unit("target"):HealthPercent() < 15 and Player:SoulShards() <= 4 then
            return A.DrainSoul:Show(icon)
        end
         -- phantom_singularity - DONE
         if A.PhantomSingularity:IsReady(unit) and EnemiesCount() >= 3 and (not isMoving) and A.PhantomSingularity:IsSpellInRange(unitID) then
            return A.PhantomSingularity:Show(icon)
          end
         -- phantom_singularity - DONE
        if A.PhantomSingularity:IsReady(unit) and A.PhantomSingularity:IsSpellInRange(unitID) and not isMoving then
            return A.PhantomSingularity:Show(icon)
        end
        -- agony,if=refreshable#
        if A.Agony:IsReady(unit) and Unit("target"):HasDeBuffs(A.AgonyDebuff.ID,true) <= 8 and A.Agony:IsSpellInRange(unitID) then -- DONE
           -- print("agony main 1")
            return A.Agony:Show(icon)
        end
        -- agony,cycle_targets=1,if=active_enemies>1,target_if=refreshable -- DONE
        if A.Agony:IsReady(unit) and EnemiesCount() > 1 and Unit("target"):HasDeBuffs(A.AgonyDebuff.ID,true) <= 8 and (UnitAffectingCombat("target") or Unit("target"):IsDummy()) and A.Agony:IsSpellInRange(unitID) then
            --print("agony main 2")
            return A.Agony:Show(icon)
        end
        -- agony,cycle_targets=1,if=active_dot.agony>=4,target_if=refreshable&dot.agony.ticking - DONE
        if A.Agony:IsReady(unit) and (EnemiesCount() >= 4) and Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) <= 8 and (UnitAffectingCombat("target") or Unit("target"):IsDummy()) and A.Agony:IsSpellInRange(unitID) then
            --print("agony main 3")
            return A.Agony:Show(icon)
        end
        -- seed_of_corruption,if=active_enemies>2&!talent.vile_taint.enabled&(!talent.writhe_in_agony.enabled|talent.sow_the_seeds.enabled)&!dot.seed_of_corruption.ticking&!in_flight&dot.corruption.refreshable -- DONE
        if A.SeedofCorruption:IsReady(unit) and Unit("target"):HealthPercent() > 15 and (EnemiesCount() >= 3 or MultiUnits:GetActiveEnemies() >= 3) and not A.IsSpellInCasting(A.SeedofCorruption) and Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID,true) == 0 and Player:GetDeBuffsUnitCount(A.SeedofCorruptionDebuff.ID) < 1 and not A.VileTaint:IsTalentLearned() and not (A.WritheinAgony:IsTalentLearned() or A.SowtheSeeds:IsTalentLearned()) and Unit("target"):HasDeBuffs(A.SeedofCorruptionDebuff.ID,true) == 0 and Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID,true) == 0 and A.SeedofCorruption:GetSpellTimeSinceLastCast() > 3 then
            return A.SeedofCorruption:Show(icon)
        end
        -- seed_of_corruption,if=talent.sow_the_seeds.enabled&can_seed - DONE
        if A.SeedofCorruption:IsReady(unit) and A.SowtheSeeds:IsTalentLearned() and Unit("target"):HealthPercent() > 15 and (EnemiesCount() >= 3 or MultiUnits:GetActiveEnemies() >= 3) and Unit("target"):HasDeBuffs(A.SeedofCorruptionDebuff.ID,true) == 0 and Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID,true) == 0 and not A.IsSpellInCasting(A.SeedofCorruption) and Player:GetDeBuffsUnitCount(A.SeedofCorruptionDebuff.ID) < 1 and A.SeedofCorruption:GetSpellTimeSinceLastCast() > 3 then
            return A.SeedofCorruption:Show(icon)
        end
        -- seed_of_corruption,if=!talent.sow_the_seeds.enabled&!dot.seed_of_corruption.ticking&!in_flight&dot.corruption.refreshable - DONE
        if A.SeedofCorruption:IsReady(unit) and Unit("target"):HasDeBuffs(A.SeedofCorruptionDebuff.ID,true) == 0 and Unit("target"):HealthPercent() > 15 and (EnemiesCount() >= 3 or MultiUnits:GetActiveEnemies() >= 3) and not A.IsSpellInCasting(A.SeedofCorruption) and Player:GetDeBuffsUnitCount(A.SeedofCorruptionDebuff.ID) < 1 and Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID,true) == 0 and A.SeedofCorruption:GetSpellTimeSinceLastCast() > 3 then
            return A.SeedofCorruption:Show(icon)
        end
        -- corruption,if=(active_enemies<3|talent.vile_taint.enabled|talent.writhe_in_agony.enabled&!talent.sow_the_seeds.enabled)&refreshable -- DONE
        if A.Corruption:IsReady(unit) and A.LastPlayerCastID ~= A.SeedofCorruption.ID and ((EnemiesCount() < 3 or A.VileTaint:IsTalentLearned() or A.WritheinAgony:IsTalentLearned() and not A.SowtheSeeds:IsTalentLearned()) and Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID) < 5) and A.Corruption:IsSpellInRange(unitID) then
            return A.Corruption:Show(icon)
        end
        -- corruption,cycle_targets=1,if=active_enemies<3|talent.vile_taint.enabled|talent.writhe_in_agony.enabled&!talent.sow_the_seeds.enabled,target_if=dot.corruption.remains<3 -- DONE
        if A.Corruption:IsReady(unit) and A.LastPlayerCastID ~= A.SeedofCorruption.ID and (EnemiesCount() >= 2 or A.VileTaint:IsTalentLearned() or A.WritheinAgony:IsTalentLearned() and not A.SowtheSeeds:IsTalentLearned()) and Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID) < 5 and (UnitAffectingCombat("target") or Unit("target"):IsDummy()) and A.Corruption:IsSpellInRange(unitID) then
            return A.Corruption:Show(icon)
        end
        -- unstable_affliction,if=refreshable -- DONE
        if A.UnstableAffliction:IsReady(unit) and A.LastPlayerCastID ~= A.UnstableAffliction.ID and (Unit("target"):HealthPercent() > 15 or Unit("target"):IsBoss()) and (not isMoving) and (Unit("target"):HasDeBuffs(A.UnstableAfflictionDebuff.ID,true) <= 6 or Unit("target"):HasDeBuffs(A.UnstableAffliction.ID,true) < 5 or Player:GetDeBuffsUnitCount(A.UnstableAffliction.ID) < 1) then
            return A.UnstableAffliction:Show(icon)
        end 
        -- unstable_affliction,target_if=min:contagion,if=!variable.use_seed&soul_shard=5
        if A.UnstableAffliction:IsReady(unit) and not isMoving and not ShouldStop and Player:SoulShardsP() == 5 and (Unit("target"):HealthPercent() > 15 or Unit("target"):IsBoss()) and (Unit("target"):HasDeBuffs(A.UnstableAfflictionDebuff.ID,true) <= 6 or Unit("target"):HasDeBuffs(A.UnstableAffliction.ID,true) < 5 or Player:GetDeBuffsUnitCount(A.UnstableAffliction.ID) < 1) then
            return A.UnstableAffliction:Show(icon)
        end
        --Drain Life below HP %
		if A.DrainLife:IsReady(unit) and Unit("player"):HealthPercent() <= DrainLifeHP then
			return A.DrainLife:Show(icon)
        end	     
        --Health Funnel
		if A.HealthFunnel:IsReady("player") and Unit("pet"):HealthPercent() <= HealthFunnelHP and Unit("player"):HealthPercent() >= 30 then
			return A.HealthFunnel:Show(icon)
        end	
        -- vile_taint,if=(soul_shard>1|active_enemies>2)&cooldown.summon_darkglare.remains>12 -- DONE
        if A.VileTaint:IsReady(unit) and Player:SoulShards() > 1 and not A.IsSpellInCasting(A.VileTaint) and not isMoving then
            return A.VileTaint:Show(icon)
        end
        -- call_action_list,name=darkglare_prep,if=active_enemies>2&cooldown.summon_darkglare.ready&(dot.phantom_singularity.ticking|!talent.phantom_singularity.enabled) -- DONE
        if A.SummonDarkglare:IsReady(unit) and BurstIsON("target") and (Unit("target"):HasDeBuffs(A.PhantomSingularityDebuff.ID,true) > 2 or not A.PhantomSingularity:IsSpellLearned()) then
            return Darkglare_prep(unit) 
        end
        -- malefic_rapture,if=soul_shard>4 -- DONE
        if A.MaleficRapture:IsReady(unit) and not isMoving and Player:SoulShards() == 5 and (Unit("target"):HasDeBuffs(A.AgonyDebuff.ID,true) > 7 or Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID,true) > 7 or Unit("target"):HasDeBuffs(A.VileTaint.ID, true) > 7) and (Unit("target"):HealthPercent() > 15 or Unit("target"):IsBoss()) then
            return A.SpatialRift:Show(icon)
        end
        -- malefic_rapture,if=dot.vile_taint.ticking -- DONE
        if A.MaleficRapture:IsReady(unit) and (Unit("target"):HealthPercent() > 15 or Unit("target"):IsBoss()) and not isMoving and Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) > 5 and Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID, true) > 5 and not A.AbsoluteCorruption:IsTalentLearned() and Unit("target"):HasDeBuffs(A.UnstableAfflictionDebuff.ID, true) > 5 and Player:SoulShards() >= 2 then
            return A.SpatialRift:Show(icon)
        end
        -- malefic_rapture,if=dot.vile_taint.ticking -- DONE
        if A.MaleficRapture:IsReady(unit) and not isMoving and (Unit("target"):HealthPercent() > 15 or Unit("target"):IsBoss()) and Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) > 5 and Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID, true) and A.AbsoluteCorruption:IsTalentLearned() and Unit("target"):HasDeBuffs(A.UnstableAfflictionDebuff.ID, true) > 5 and Player:SoulShards() >= 2 then
            return A.SpatialRift:Show(icon)
        end
        -- malefic_rapture,if=!talent.vile_taint.enabled - DONE
        if A.MaleficRapture:IsReady(unit) and A.VileTaint:IsTalentLearned() and (Unit("target"):HealthPercent() > 15 or Unit("target"):IsBoss()) and not A.AbsoluteCorruption:IsTalentLearned() and MultiUnits:GetActiveEnemies() >= 3 and (not isMoving) and Unit("target"):HasDeBuffs(A.VileTaint.ID) > 5 and Player:SoulShards() >= 2 then
            return A.SpatialRift:Show(icon)
        end
        -- malefic_rapture,if=!talent.vile_taint.enabled - DONE
        if A.MaleficRapture:IsReady(unit) and not A.VileTaint:IsTalentLearned() and (Unit("target"):HealthPercent() > 15 or Unit("target"):IsBoss()) and A.AbsoluteCorruption:IsTalentLearned() and MultiUnits:GetActiveEnemies() >= 3 and (not isMoving) and Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID, true) and Player:SoulShards() >= 2 then
            return A.SpatialRift:Show(icon)
        end
        -- malefic_rapture,if=!talent.vile_taint.enabled - DONE
        if A.MaleficRapture:IsReady(unit) and not A.VileTaint:IsTalentLearned() and (Unit("target"):HealthPercent() > 15 or Unit("target"):IsBoss()) and not A.AbsoluteCorruption:IsTalentLearned() and MultiUnits:GetActiveEnemies() >= 3 and (not isMoving) and Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) > 5 and Player:SoulShards() >= 2 then
            return A.SpatialRift:Show(icon)
        end
      -- vile_taint,if=(soul_shard>1|active_enemies>2)&cooldown.summon_darkglare.remains>12 -- DONE
      if A.VileTaint:IsReady(unit) and A.VileTaint:IsSpellInRange(unitID) and not isMoving then
        return A.VileTaint:Show(icon)
      end
      -- siphon_life,if=refreshable -- DONE
      if A.SiphonLife:IsReady(unit) and Unit("target"):HasDeBuffs(A.SiphonLife.ID,true) <= 5 and (UnitAffectingCombat("target") or Unit("target"):IsDummy()) and A.SiphonLife:IsSpellInRange(unitID) and A.SiphonLife:IsTalentLearned() then
        return A.SiphonLife:Show(icon)
      end
      -- haunt -- DONE
      if A.Haunt:IsReady(unit) and Unit("target"):HasDeBuffs(A.HauntDebuff.ID,true) <= 5 and A.Haunt:IsSpellInRange(unitID) and not isMoving and A.Haunt:IsTalentLearned() then
        return A.Haunt:Show(icon)
      end
      -- call_action_list,name=darkglare_prep,if=cooldown.summon_darkglare.remains<2&(dot.phantom_singularity.remains>2|!talent.phantom_singularity.enabled) -- DONE
      if BurstIsON("target") and (A.SummonDarkglare:GetCooldown() < 2 and (Unit("target"):HasDeBuffs(A.PhantomSingularityDebuff.ID, true) > 2 or not A.PhantomSingularity:IsTalentLearned())) then
        return Darkglare_prep(unit)
      end
      -- dark_soul,if=cooldown.summon_darkglare.remains>time_to_die -- DONE
      if A.DarkSoulMisery:IsReady(unit) and BurstIsON("target") and not isMoving and (A.SummonDarkglare:GetCooldown() > Unit("target"):TimeToDie()) then
        return A.DarkSoulMisery:Show(icon)
      end
      -- call_action_list,name=se,if=debuff.shadow_embrace.stack<(3-action.shadow_bolt.in_flight)|debuff.shadow_embrace.remains<3 -- DONE
      if Unit("target"):HasDeBuffs(A.ShadowEmbraceDebuff.ID,true) < (3 - num(A.ShadowBolt:GetSpellCastTime())) or Unit("target"):HasDeBuffs(A.ShadowEmbraceDebuff.ID, true) < 3 then
        return Fillers(unit)
      end
      -- drain_life,if=buff.inevitable_demise.stack>30|buff.inevitable_demise.up&time_to_die<5 -- DONE
      if A.DrainLife:IsReady(unit) and A.InevitableDemise:IsTalentLearned() and Unit("player"):HasDeBuffsStacks(A.InevitableDemiseBuff.ID, true) > 30 and Unit("target"):TimeToDie() < 5 and A.DrainLife:IsSpellInRange(unitID) then
        return A.DrainLife:Show(icon)
      end
      -- drain_life,if=buff.inevitable_demise_az.stack>30 TODO -- DONE
      -- drain_soul
      if A.DrainSoul:IsReady(unit) and A.DrainSoul:IsSpellInRange(unitID) and not isMoving and Unit("target"):HealthPercent() < 15 and Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) > 5 and Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID, true) > 5 and MultiUnits:GetActiveEnemies() >= 3 then
        return A.DrainSoul:Show(icon)
      end
        -- vile_taint,if=(soul_shard>1|active_enemies>2)&cooldown.summon_darkglare.remains>12 -- DONE
        if A.VileTaint:IsReady(unit) and A.VileTaint:IsSpellInRange(unitID) and not isMoving and A.VileTaint:IsTalentLearned() then
            return A.VileTaint:Show(icon)
        end
        -- malefic_rapture,if=soul_shard>4 -- DONE
        if A.SoulRot:IsReady(unit) and not isMoving then
            return A.SoulRot:Show(icon)
        end
        -- drain_soul
        if A.DrainSoul:IsReady(unit) and A.DrainSoul:IsSpellInRange(unitID) and not isMoving and Unit("target"):HealthPercent() < 15 and Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) > 5 and A.AbsoluteCorruption:IsTalentLearned() and MultiUnits:GetActiveEnemies() >= 3 then
            return A.DrainSoul:Show(icon)
        end
        -- drain_soul
        if A.DrainSoul:IsReady(unit) and A.DrainSoul:IsSpellInRange(unitID) and not isMoving and Unit("target"):HealthPercent() < 15 and Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) > 5 and MultiUnits:GetActiveEnemies() < 3 then
            return A.DrainSoul:Show(icon)
        end
        -- drain_soul
        if A.DrainSoul:IsReady(unit) and A.DrainSoul:IsSpellInRange(unitID) and not isMoving and Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) > 5 and Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID, true) > 5 and Unit("target"):HasDeBuffs(A.UnstableAfflictionDebuff.ID, true) > 5 and not A.AbsoluteCorruption:IsTalentLearned() and MultiUnits:GetActiveEnemies() < 3 and Player:SoulShards() >= 3 then
            return A.DrainSoul:Show(icon)
        end
        -- drain_soul
        if A.DrainSoul:IsReady(unit) and A.DrainSoul:IsSpellInRange(unitID) and not isMoving and Unit("target"):HasDeBuffs(A.AgonyDebuff.ID, true) > 5 and Unit("target"):HasDeBuffs(A.CorruptionDebuff.ID, true) and Unit("target"):HasDeBuffs(A.UnstableAfflictionDebuff.ID, true) > 5 and A.AbsoluteCorruption:IsTalentLearned() and MultiUnits:GetActiveEnemies() < 3 and Player:SoulShards() >= 3 then
            return A.DrainSoul:Show(icon)
        end
        -- drain_soul
        if A.DrainSoul:IsReady(unit) and A.DrainSoul:IsSpellInRange(unitID) and not isMoving  and Player:SoulShards() <= 1 then
             return A.DrainSoul:Show(icon)
        end
        --Drain Life below HP %
		if A.DrainLife:IsReady(unit) and Unit("player"):HealthPercent() <= DrainLifeHP then
			return A.DrainLife:Show(icon)
        end	
        
        --Health Funnel
		if A.HealthFunnel:IsReady("player") and Unit("pet"):HealthPercent() <= HealthFunnelHP and Unit("player"):HealthPercent() >= 30 then
			return A.HealthFunnel:Show(icon)
        end	 
        -- Trinket One
		if A.Trinket1:IsReady("target") and BurstIsON("target") then 
			return A.Trinket1:Show(icon)
		end 		
			
		-- Trinket Two
		if A.Trinket2:IsReady("target") and BurstIsON("target") then 
			return A.Trinket2:Show(icon)
        end 	


        
end  -- End enemies +2

        end -- Main function close

        if not inCombat then
          --  print(FirstTarget)
          --  print(SwappedTarget)
  
            return Precombat()
        end

        if Unit("player"):CombatTime() <= 0 then
            for irangeCheckCount in pairs(ActiveUnitPlates) do     
                    FirstTarget = {"FirstTarget"}
                    SwappedTarget = {"SwappedTarget"}
                    Swapped = false
                    DotRotation = false
                    DotRotationCount = 0
                    isFirstUnit = true  
            end


        end


        --elseif inCombat and (AoE or AutoMultiDot) and (EnemiesCount() >= 2 or CheckingRange() or MultiUnits:GetActiveEnemies() >= 2 or Unit("target"):IsDummy()) then
            --print ("woho hittade AoE combat")
           -- return Aoe(unit)
       -- else
            --return Main(unit)
        --print("innan AoE")
        --if inCombat and (AoE or AutoMultiDot) and (EnemiesCount() >= 2 or CheckingRange() or MultiUnits:GetActiveEnemies() >= 2 or Unit("target"):IsDummy()) then
            --print ("woho hittade AoE combat")
           -- return Aoe(unit)
        --end
        --print("efter AoE")
                
       -- if inCombat and Action.GetToggle(2, "AoE") and Action.GetToggle(2, "AutoMultiDot") then
          --  return Aoe()
       -- end
       --print("innan main")
        if inCombat then
           return Main()
        end
        --print("efter main")
    
    end -- End on EnemyRotation()
    
	    
   
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
end -- A[3] end
-- Finished

A[1] = nil

A[4] = nil

A[5] = nil

A[6] = nil

A[7] = nil

A[8] = nil