--######################################
--##### TRIP'S DESTRUCTION WARLOCK #####
--######################################

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
local AuraIsValidByPhialofSerenity				= A.AuraIsValidByPhialofSerenity
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

--For Toaster
local Toaster									= _G.Toaster
local GetSpellTexture 							= _G.TMW.GetSpellTexture

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

Action[ACTION_CONST_WARLOCK_DESTRUCTION] = {
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

	--Destruction Spells
    ChaosBolt					= Action.Create({ Type = "Spell", ID = 116858	}),
    Conflagrate					= Action.Create({ Type = "Spell", ID = 17962	}),
    Havoc						= Action.Create({ Type = "Spell", ID = 80240	}),
	Immolate					= Action.Create({ Type = "Spell", ID = 348		}),
	ImmolateDebuff				= Action.Create({ Type = "Spell", ID = 157736, Hidden = true 	}),
    Incinerate					= Action.Create({ Type = "Spell", ID = 29722	}),
    RainofFire					= Action.Create({ Type = "Spell", ID = 5740		}),
    SummonInfernal				= Action.Create({ Type = "Spell", ID = 1122		}),
    Backdraft					= Action.Create({ Type = "Spell", ID = 196406, Hidden = true	}),
    BackdraftBuff				= Action.Create({ Type = "Spell", ID = 117828, Hidden = true	}),	

	--Normal Talents
    Flashover					= Action.Create({ Type = "Spell", ID = 267115, Hidden = true	}),
    Eradication					= Action.Create({ Type = "Spell", ID = 196412, Hidden = true	}),
    EradicationDebuff			= Action.Create({ Type = "Spell", ID = 196414, Hidden = true	}),	
    SoulFire					= Action.Create({ Type = "Spell", ID = 6353		}),
    ReverseEntropy				= Action.Create({ Type = "Spell", ID = 205148, Hidden = true 	}),
    InternalCombustion			= Action.Create({ Type = "Spell", ID = 266134, Hidden = true	}),
    Shadowburn					= Action.Create({ Type = "Spell", ID = 17877	}),
    DemonSkin					= Action.Create({ Type = "Spell", ID = 219272, Hidden = true	}),
    BurningRush					= Action.Create({ Type = "Spell", ID = 111400	}),
    DarkPact					= Action.Create({ Type = "Spell", ID = 108416	}),
    Inferno						= Action.Create({ Type = "Spell", ID = 270545, Hidden = true	}),
    FireandBrimstone			= Action.Create({ Type = "Spell", ID = 196408, Hidden = true	}),
    Cataclysm					= Action.Create({ Type = "Spell", ID = 152108	}),
    Darkfury					= Action.Create({ Type = "Spell", ID = 264874, Hidden = true	}),
    MortalCoil					= Action.Create({ Type = "Spell", ID = 6789		}),
    HowlofTerror				= Action.Create({ Type = "Spell", ID = 5484		}),
    RoaringBlaze				= Action.Create({ Type = "Spell", ID = 205184, Hidden = true	}),
    RainofChaos					= Action.Create({ Type = "Spell", ID = 266086, Hidden = true	}),
    GrimoireofSacrifice			= Action.Create({ Type = "Spell", ID = 108503	}),
    GrimoireofSacrificeBuff		= Action.Create({ Type = "Spell", ID = 196099, Hidden = true	}),	
    SoulConduit					= Action.Create({ Type = "Spell", ID = 215941, Hidden = true	}),
    ChannelDemonfire			= Action.Create({ Type = "Spell", ID = 196447	}),
    DarkSoulInstability			= Action.Create({ Type = "Spell", ID = 113858	}),

	--PvP Talents
    FelFissure					= Action.Create({ Type = "Spell", ID = 200586, Hidden = true	}),
    Cremation					= Action.Create({ Type = "Spell", ID = 212282, Hidden = true	}),
    FocusedChaos				= Action.Create({ Type = "Spell", ID = 233577, Hidden = true	}),
    BaneofHavoc					= Action.Create({ Type = "Spell", ID = 200546	}),
    BaneofFragility				= Action.Create({ Type = "Spell", ID = 199954	}),
    AmplifyCurse				= Action.Create({ Type = "Spell", ID = 328774	}),
    NetherWard					= Action.Create({ Type = "Spell", ID = 212295	}),
    EssenceDrain				= Action.Create({ Type = "Spell", ID = 221711, Hidden = true	}),
    CastingCircle				= Action.Create({ Type = "Spell", ID = 221703	}),
    DemonArmor					= Action.Create({ Type = "Spell", ID = 285933	}),
    GatewayMastery				= Action.Create({ Type = "Spell", ID = 248855, Hidden = true 	}),

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
    AshenRemains				= Action.Create({ Type = "Spell", ID = 339892, Hidden = true	}),	
    CombustingEngine			= Action.Create({ Type = "Spell", ID = 339896, Hidden = true	}),	
    DuplicitousHavoc			= Action.Create({ Type = "Spell", ID = 339890, Hidden = true	}),	
    InfernalBrand				= Action.Create({ Type = "Spell", ID = 340041, Hidden = true	}),	
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
    LeadByExample				= Action.Create({ Type = "Spell", ID = 342156, Hidden = true	}),	

	-- Legendaries
	-- General Legendaries
    ClawofEndereth				= Action.Create({ Type = "Spell", ID = 337038, Hidden = true	}),
    PillarsoftheDarkPortal		= Action.Create({ Type = "Spell", ID = 337065, Hidden = true	}),
    RelicofDemonicSynergy		= Action.Create({ Type = "Spell", ID = 337057, Hidden = true	}),
    WilfredsSigil				= Action.Create({ Type = "Spell", ID = 337020, Hidden = true	}),
	--Destruction
    CindersoftheAzjAqir			= Action.Create({ Type = "Spell", ID = 337166, Hidden = true	}),
    EmbersoftheDiabolicRaiment	= Action.Create({ Type = "Spell", ID = 337272, Hidden = true	}),
    MadnessoftheAzjAqir			= Action.Create({ Type = "Spell", ID = 337169, Hidden = true	}),
    OdrShawloftheYmirjar		= Action.Create({ Type = "Spell", ID = 337163, Hidden = true	}),

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

	HealthStoneItem					= Action.Create({ Type = "Item", ID = 5512, Hidden = true }), -- Just for notification icon really
	
	-- Borrowed Bindings
	Darkflight						= Action.Create({ Type = "Spell", ID = 68992 }), -- used for Heart of Azeroth	
	RocketJump						= Action.Create({ Type = "Spell", ID = 69070 }), -- used for Heart of Azeroth	
}

-- To create essences use next code:
Action:CreateEssencesFor(ACTION_CONST_WARLOCK_DESTRUCTION)        -- where PLAYERSPEC is Constance (example: ACTION_CONST_MONK_BM)
local A = setmetatable(Action[ACTION_CONST_WARLOCK_DESTRUCTION], { __index = Action })

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
	ImmolateDelay							= 0,
}

local IsIndoors, UnitIsUnit, UnitName = IsIndoors, UnitIsUnit, UnitName



local function IsSchoolFree()
	return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "FIRE") == 0
end 

local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end

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

Pet:AddTrackers(ACTION_CONST_WARLOCK_DESTRUCTION, {
    [89] = {
        name = "Infernal",
        duration = 30,
    },
})

local function InfernalTime()
    return Pet:GetRemainDuration(89) or 0
end 

local function InfernalIsActive()
    return InfernalTime() > 8 and true or false
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
			elseif A.Zone ~= "arena" and (A.Zone ~= "pvp") and A.SpiritualHealingPotion:IsReady(player) then 
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
		if A.Zone ~= "arena" and (A.Zone ~= "pvp") and A.PhialofSerenity:IsReady(player) then 
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

local Havoc_Nameplates = MultiUnits:GetActiveUnitPlates()

local function HavocDebuffTime()

        for Havoc_UnitID in pairs(Havoc_Nameplates) do
            local debuff = Unit(Havoc_UnitID):HasDeBuffs(A.Havoc.ID, true)
            if debuff > 0 then         
                return debuff 
            end
        end  
    return 0   
	
end
HavocDebuffTime = A.MakeFunctionCachedStatic(HavocDebuffTime)


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
	local TargetsMissingImmolate = MultiUnits:GetByRangeMissedDoTs(nil, 8, A.ImmolateDebuff.ID)
	local AutoMultiDot = A.GetToggle(2, "AutoMultiDot")
	local DrainLifeHP = A.GetToggle(2, "DrainLifeHP")	
	local HealthFunnelHP = A.GetToggle(2, "HealthFunnelHP")
	local UseAoE = A.GetToggle(2, "AoE")
	local AutoHavoc = A.GetToggle(2, "AutoHavoc")

    if Temp.ImmolateDelay == 0 and (Unit(player):IsCasting() == "Immolate" or Unit(player):IsCasting() == "Cataclsym") then
        Temp.ImmolateDelay = 90
    end
    
    if Temp.ImmolateDelay > 0 then
        Temp.ImmolateDelay = Temp.ImmolateDelay - 1
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
		
	if Player:IsCasting() and A.Cataclysm:IsTalentLearned() and A.Cataclysm:GetCooldown() < 2 then
		A.Toaster:SpawnByTimer("TripToast", 0, "Cataclsym Soon!", "Get your cursor ready!", A.Cataclysm.ID)
	end	
	
	if MultiUnits:GetActiveEnemies() > 2 and A.RainofFire:IsReadyP(player) and Player:GetDeBuffsUnitCount(A.Havoc.ID) < 1 and A.Havoc:GetCooldown() > 1 then
		A.Toaster:SpawnByTimer("TripToast", 0, "Rain of Fire Soon!", "Get your cursor ready!", A.RainofFire.ID)
	end		
		
		--#####################
		--##### PRECOMBAT #####
		--#####################		
		
		local function Precombat(unit)
			
			-- Summon Pet 
			if SummonPet:IsReady("player") and (not isMoving) and not Pet:IsActive() and Unit("player"):HasBuffs(A.GrimoireofSacrificeBuff.ID, true) == 0 then
				return SummonPet:Show(icon)
			end		

			--actions.precombat+=/grimoire_of_sacrifice,if=talent.grimoire_of_sacrifice.enabled
			if A.GrimoireofSacrifice:IsReady("player") and Unit("player"):HasBuffs(A.GrimoireofSacrificeBuff.ID, true) == 0 and A.GrimoireofSacrifice:IsTalentLearned() then
				return A.GrimoireofSacrifice:Show(icon)
			end		
			
			--actions.precombat+=/soul_fire
			if A.SoulFire:IsReady(unit) and (not isMoving) and A.SoulFire:IsTalentLearned() then
				return A.SoulFire:Show(icon)
			end	
			
			--actions.precombat+=/incinerate,if=!talent.soul_fire.enabled
			if A.Incinerate:IsReady(unit) and (not isMoving) and not A.SoulFire:IsTalentLearned() then
				return A.Incinerate:Show(icon)
			end	

		end
		
		--########################
		--##### AOE ROTATION #####
		--########################
		
		local function AoERotation(unit)
		
			--actions.aoe=rain_of_fire,if=pet.infernal.active&(!cooldown.havoc.ready|active_enemies>3)
			if A.RainofFire:IsReady(player) and InfernalIsActive() and (A.Havoc:GetCooldown() > 0 or MultiUnits:GetActiveEnemies() > 3) then
				return A.RainofFire:Show(icon)
			end	
			
			--actions.aoe+=/soul_rot
			if A.SoulRot:IsReady(unit) and (not isMoving) and A.GetToggle(1, "Covenant") then
				return A.SoulRot:Show(icon)
			end	
			
			--actions.aoe+=/channel_demonfire,if=dot.immolate.remains>cast_time
			if A.ChannelDemonfire:IsReady(player) and (not isMoving) and A.ChannelDemonfire:IsTalentLearned() and Unit("target"):HasDeBuffs(A.ImmolateDebuff.ID, true) >= Player:Execute_Time(A.ChannelDemonfire.ID) then
				return A.ChannelDemonfire:Show(icon)
			end	
			
			--actions.aoe+=/immolate,cycle_targets=1,if=remains<5&(!talent.cataclysm.enabled|cooldown.cataclysm.remains>remains)
			if A.Immolate:IsReady(unit) and (not isMoving) and (Unit("target"):HasDeBuffs(A.ImmolateDebuff.ID, true) < 5 or Unit("target"):HasDeBuffs(A.ImmolateDebuff.ID, true) == 0) and (not A.Cataclysm:IsTalentLearned() or A.Cataclysm:GetCooldown() > Unit("target"):HasDeBuffs(A.ImmolateDebuff.ID, true)) then
				return A.Immolate:Show(icon)
			end	
			
			--actions.aoe+=/call_action_list,name=cds
			--actions.cds=summon_infernal
			if A.SummonInfernal:IsReady(player) and A.BurstIsON("target") then
				return A.SummonInfernal:Show(icon)
			end
			
			--actions.cds+=/dark_soul_instability
			if A.DarkSoulInstability:IsReady(player) and A.BurstIsON("target") then
				return A.DarkSoulInstability:Show(icon)
			end	
			
			--actions.cds+=/potion,if=pet.infernal.active
			
			
			--actions.cds+=/berserking,if=pet.infernal.active
			if A.Berserking:IsReady(player) and A.BurstIsON("target") and InfernalIsActive() then
				return A.Berserking:Show(icon)
			end	
			
			--actions.cds+=/blood_fury,if=pet.infernal.active
			if A.BloodFury:IsReady(player) and A.BurstIsON("target") and InfernalIsActive() then
				return A.BloodFury:Show(icon)
			end	
			
			--actions.cds+=/fireblood,if=pet.infernal.active
			if A.Fireblood:IsReady(player) and A.BurstIsON("target") and InfernalIsActive() then
				return A.Fireblood:Show(icon)
			end			
		
			-- Trinket One
			if A.Trinket1:IsReady("target") and BurstIsON("target") and Player:AreaTTD(40) > 10 then 
				return A.Trinket1:Show(icon)
			end 		
			
			-- Trinket Two
			if A.Trinket2:IsReady("target") and BurstIsON("target") and Player:AreaTTD(40) > 10 then 
				return A.Trinket2:Show(icon)
			end 					
			
			--actions.aoe+=/havoc,cycle_targets=1,if=!(target=self.target)&active_enemies<4
			if A.Havoc:IsReady(unit) and Player:AreaTTD(40) > 10 and (MultiUnits:GetActiveEnemies() >= 2 and MultiUnits:GetActiveEnemies() < 4) then
				return A.Havoc:Show(icon)
			end
			
			--actions.aoe+=/rain_of_fire
			if A.RainofFire:IsReady(player) then
				return A.RainofFire:Show(icon)
			end
			
			--actions.aoe+=/decimating_bolt,if=(soulbind.lead_by_example.enabled|!talent.fire_and_brimstone.enabled)
			if A.DecimatingBolt:IsReady(unit) and (not isMoving) and A.GetToggle(1, "Covenant") and (A.LeadByExample:IsSoulbindLearned() or not A.FireandBrimstone:IsTalentLearned()) then
				return A.DecimatingBolt:Show(icon)
			end	
			
			--actions.aoe+=/incinerate,if=talent.fire_and_brimstone.enabled&buff.backdraft.up&soul_shard<5-0.2*active_enemies
			if A.Incinerate:IsReady(unit) and (not isMoving) and A.FireandBrimstone:IsTalentLearned() and Unit(player):HasBuffs(A.BackdraftBuff.ID, true) > 0 and Player:SoulShards() < (5 - 0.2 * MultiUnits:GetActiveEnemies()) then
				return A.Incinerate:Show(icon)
			end	
			
			--actions.aoe+=/soul_fire
			if A.SoulFire:IsReady(unit) and (not isMoving) and A.SoulFire:IsTalentLearned() then
				return A.SoulFire:Show(icon)
			end	
			
			--actions.aoe+=/conflagrate,if=buff.backdraft.down
			if A.Conflagrate:IsReady(unit) and Unit(player):HasBuffs(A.BackdraftBuff.ID, true) == 0 then
				return A.Conflagrate:Show(icon)
			end	
			
			--actions.aoe+=/shadowburn,if=target.health.pct<20
			if A.Shadowburn:IsReady(unit) and A.Shadowburn:IsTalentLearned() and Unit("target"):HealthPercent() < 20 then
				return A.Shadowburn:Show(icon)
			end	
			
			--actions.aoe+=/scouring_tithe,if=!(talent.fire_and_brimstone.enabled|talent.inferno.enabled)
			if A.ScouringTithe:IsReady(unit) and (not isMoving) and not (A.FireandBrimstone:IsTalentLearned() or A.Inferno:IsTalentLearned()) then
				return A.ScouringTithe:Show(icon)
			end	
			
			--actions.aoe+=/impending_catastrophe,if=!(talent.fire_and_brimstone.enabled|talent.inferno.enabled)
			if A.ImpendingCatastrophe:IsReady(unit) and (not isMoving) and not (A.FireandBrimstone:IsTalentLearned() or A.Inferno:IsTalentLearned()) then
				return A.ImpendingCatastrophe:Show(icon)
			end	
			
			--actions.aoe+=/incinerate
			if A.Incinerate:IsReady(unit) and (not isMoving) then
				return A.Incinerate:Show(icon)
			end	
		
		end

		--#########################
		--##### HAVOC ROTATION#####
		--#########################
		
		local function HavocRotation(unit)
				
			--actions.havoc=conflagrate,if=buff.backdraft.down&soul_shard>=1&soul_shard<=4
			if A.Conflagrate:IsReady(unit) and Unit(player):HasBuffs(A.BackdraftBuff.ID, true) == 0 and Player:SoulShards() >= 1 and Player:SoulShards() <= 4 then
				return A.Conflagrate:Show(icon)
			end	
			
			--actions.havoc+=/soul_fire,if=cast_time<havoc_remains
			if A.SoulFire:IsReady(unit) and (not isMoving) and A.SoulFire:IsTalentLearned() and Player:Execute_Time(A.SoulFire.ID) < HavocDebuffTime() then
				return A.SoulFire:Show(icon)
			end
			
			--actions.havoc+=/decimating_bolt,if=cast_time<havoc_remains&soulbind.lead_by_example.enabled
			if A.DecimatingBolt:IsReady(unit) and (not isMoving) and A.GetToggle(1, "Covenant") and Player:Execute_Time(A.DecimatingBolt.ID) < HavocDebuffTime() and A.LeadByExample:IsSoulbindLearned() then
				return A.DecimatingBolt:Show(icon)
			end	
			
			--actions.havoc+=/scouring_tithe,if=cast_time<havoc_remains
			if A.ScouringTithe:IsReady(unit) and (not isMoving) and A.GetToggle(1, "Covenant") and Player:Execute_Time(A.ScouringTithe.ID) < HavocDebuffTime() then
				return A.ScouringTithe:Show(icon)
			end	
			
			--actions.havoc+=/immolate,if=talent.internal_combustion.enabled&remains<duration*0.5|!talent.internal_combustion.enabled&refreshable
			if A.Immolate:IsReady(unit) and (not isMoving) and Temp.ImmolateDelay == 0 and ((A.InternalCombustion:IsTalentLearned() and Unit("target"):HasDeBuffs(A.ImmolateDebuff.ID, true) < 9) or (not A.InternalCombustion:IsTalentLearned() and (Unit("target"):HasDeBuffs(A.ImmolateDebuff.ID, true) < 4 or Unit("target"):HasDeBuffs(A.ImmolateDebuff.ID, true) == 0))) then
				return A.Immolate:Show(icon)
			end	
			
			--actions.havoc+=/chaos_bolt,if=cast_time<havoc_remains
			if A.ChaosBolt:IsReady(unit) and (not isMoving) and Player:Execute_Time(A.ChaosBolt.ID) < HavocDebuffTime() then
				return A.ChaosBolt:Show(icon)
			end	
			
			--actions.havoc+=/shadowburn
			if A.Shadowburn:IsReady(unit) and A.Shadowburn:IsTalentLearned() then
				return A.Shadowburn:Show(icon)
			end	
			
			--actions.havoc+=/incinerate,if=cast_time<havoc_remains			
			if A.Incinerate:IsReady(unit) and (not isMoving) and Player:Execute_Time(A.Incinerate.ID) < HavocDebuffTime() then
				return A.Incinerate:Show(icon)
			end	

		end
	
		--###########################
		--##### EVERYTHING ELSE #####
		--###########################
	
		if inCombat then
		
			if Player:IsChanneling() == A.ChannelDemonfire:Info() and Player:GetDeBuffsUnitCount(A.ImmolateDebuff.ID) < 1 then
				return A:Show(icon, CONST_STOPCAST)
			end	
			
			--Fel Domination if Pet dies
			if A.FelDomination:IsReady("player") and not Pet:IsActive() and Unit("player"):HasBuffs(A.GrimoireofSacrificeBuff.ID, true) == 0 and inCombat and HavocDebuffTime() < 1 then
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

			--Drain Life below HP %
			if A.DrainLife:IsReady(unit) and Unit(player):HealthPercent() <= DrainLifeHP then
				return A.DrainLife:Show(icon)
			end	
			
			--Health Funnel
			if A.HealthFunnel:IsReady(player) and Pet:IsActive() and Unit("pet"):HealthPercent() <= HealthFunnelHP and Unit(player):HealthPercent() >= 30 then
				return A.HealthFunnel:Show(icon)
			end	

			if Unit(unit):HasDeBuffs(A.Havoc.ID) > 0 and unit ~= "mouseover" and (not A.IsInPvP) and MultiUnits:GetActiveEnemies() >= 2 and AutoHavoc then
				return A:Show(icon, ACTION_CONST_AUTOTARGET) 
			end	

			if A.Shadowburn:IsReady(unit) and A.Shadowburn:IsTalentLearned() and Unit("target"):HealthPercent() < 20 then
				return A.Shadowburn:Show(icon)
			end	
			
			--actions=call_action_list,name=havoc,if=havoc_active&active_enemies>1&active_enemies<5-talent.inferno.enabled+(talent.inferno.enabled&talent.internal_combustion.enabled)
			if HavocDebuffTime() > 0 and MultiUnits:GetActiveEnemies() > 1 and MultiUnits:GetActiveEnemies() < (5 - (num(A.Inferno:IsTalentLearned()) + (num(A.Inferno:IsTalentLearned()) + num(A.InternalCombustion:IsTalentLearned())))) then
				if HavocRotation() then			
					return true
				end
			end
			
			--actions+=/cataclysm,if=!(pet.infernal.active&dot.immolate.remains+1>pet.infernal.remains)|spell_targets.cataclysm>1
			if A.Cataclysm:IsReady(player) and (not isMoving) and A.Cataclysm:IsTalentLearned() and (not (InfernalIsActive() and Unit("target"):HasDeBuffs(A.ImmolateDebuff.ID, true) + 1 > InfernalTime()) or MultiUnits:GetActiveEnemies() > 1) then
				return A.Cataclysm:Show(icon)
			end	
			
			--actions+=/call_action_list,name=aoe,if=active_enemies>2
			if MultiUnits:GetActiveEnemies() > 2 and UseAoE then
				if AoERotation() then
					return true
				end
			end
			
			--actions+=/soul_fire,cycle_targets=1,if=refreshable&soul_shard<=4&(!talent.cataclysm.enabled|cooldown.cataclysm.remains>remains)
			if A.SoulFire:IsReady(unit) and (not isMoving) and A.SoulFire:IsTalentLearned() and (Unit("target"):HasDeBuffs(A.ImmolateDebuff.ID, true) < 4 or Unit("target"):HasDeBuffs(A.ImmolateDebuff.ID, true) == 0) and Player:SoulShards() <= 4 and (not A.Cataclysm:IsTalentLearned() or (A.Cataclysm:IsTalentLearned() and A.Cataclysm:GetCooldown() > Unit("target"):HasDeBuffs(A.ImmolateDebuff.ID, true))) then
				return A.SoulFire:Show(icon)
			end	
			
			--actions+=/immolate,cycle_targets=1,if=refreshable&(!talent.cataclysm.enabled|cooldown.cataclysm.remains>remains)
			if A.Immolate:IsReady(unit) and (not isMoving) and Temp.ImmolateDelay == 0 and (Unit("target"):HasDeBuffs(A.ImmolateDebuff.ID, true) < 4 or Unit("target"):HasDeBuffs(A.ImmolateDebuff.ID, true) == 0) and Player:SoulShards() <= 4 and (not A.Cataclysm:IsTalentLearned() or (A.Cataclysm:IsTalentLearned() and A.Cataclysm:GetCooldown() > Unit("target"):HasDeBuffs(A.ImmolateDebuff.ID, true))) then
				return A.Immolate:Show(icon)
			end	
			
			--actions+=/immolate,if=talent.internal_combustion.enabled&action.chaos_bolt.in_flight&remains<duration*0.5
			if A.Immolate:IsReady(unit) and (not isMoving) and Temp.ImmolateDelay == 0 and A.InternalCombustion:IsTalentLearned() and A.ChaosBolt:IsSpellInFlight() and Unit("target"):HasDeBuffs(A.ImmolateDebuff.ID, true) < 9 then
				return A.Immolate:Show(icon)
			end	
			
			--actions+=/call_action_list,name=cds
			if A.SummonInfernal:IsReady(player) and A.BurstIsON("target") then
				return A.SummonInfernal:Show(icon)
			end
			
			--actions.cds+=/dark_soul_instability
			if A.DarkSoulInstability:IsReady(player) and A.BurstIsON("target") then
				return A.DarkSoulInstability:Show(icon)
			end	
			
			--actions.cds+=/potion,if=pet.infernal.active
			
			
			--actions.cds+=/berserking,if=pet.infernal.active
			if A.Berserking:IsReady(player) and A.BurstIsON("target") and InfernalIsActive() then
				return A.Berserking:Show(icon)
			end	
			
			--actions.cds+=/blood_fury,if=pet.infernal.active
			if A.BloodFury:IsReady(player) and A.BurstIsON("target") and InfernalIsActive() then
				return A.BloodFury:Show(icon)
			end	
			
			--actions.cds+=/fireblood,if=pet.infernal.active
			if A.Fireblood:IsReady(player) and A.BurstIsON("target") and InfernalIsActive() then
				return A.Fireblood:Show(icon)
			end	
			
			--actions.cds+=/use_items,if=pet.infernal.active|target.time_to_die<20			
		
			-- Trinket One
			if A.Trinket1:IsReady("target") and BurstIsON("target") and Player:AreaTTD(40) > 10 then 
				return A.Trinket1:Show(icon)
			end 		
			
			-- Trinket Two
			if A.Trinket2:IsReady("target") and BurstIsON("target") and Player:AreaTTD(40) > 10 then 
				return A.Trinket2:Show(icon)
			end 			
			
			--actions+=/call_action_list,name=essences
			--actions+=/channel_demonfire
			if A.ChannelDemonfire:IsReady(player) and (not isMoving) and Unit(unit):HasDeBuffs(A.ImmolateDebuff.ID, true) > Player:Execute_Time(A.ChannelDemonfire.ID) then
				return A.ChannelDemonfire:Show(icon)
			end	
			
			--actions+=/scouring_tithe
			if A.ScouringTithe:IsReady(unit) and (not isMoving) and A.GetToggle(1, "Covenant") then
				return A.ScouringTithe:Show(icon)
			end	
			
			--actions+=/decimating_bolt
			if A.DecimatingBolt:IsReady(unit) and (not isMoving) and A.GetToggle(1, "Covenant") then
				return A.DecimatingBolt:Show(icon)
			end	
			
			--actions+=/havoc,cycle_targets=1,if=!(target=self.target)&(dot.immolate.remains>dot.immolate.duration*0.5|!talent.internal_combustion.enabled)
			if A.Havoc:IsReady(unit) and Unit("target"):TimeToDie() > 10 and MultiUnits:GetActiveEnemies() > 1 and MultiUnits:GetActiveEnemies() < 5 and (Unit(unit):HasDeBuffs(A.ImmolateDebuff.ID, true) > 9 or not A.InternalCombustion:IsTalentLearned()) then 
				return A.Havoc:Show(icon)
			end	
			
			--actions+=/impending_catastrophe
			if A.ImpendingCatastrophe:IsReady(unit) and (not isMoving) and A.GetToggle(1, "Covenant") then
				return A.ImpendingCatastrophe:Show(icon)
			end	
			
			--actions+=/soul_rot
			if A.SoulRot:IsReady(unit) and (not isMoving) and A.GetToggle(1, "Covenant") then
				return A.SoulRot:Show(icon)
			end	
			
			--actions+=/havoc,if=runeforge.odr_shawl_of_the_ymirjar.equipped
			if A.Havoc:IsReady(unit) and Unit("target"):TimeToDie() > 10 and Player:HasLegendaryCraftingPower(A.OdrShawloftheYmirjar) then
				return A.Havoc:Show(icon)
			end	
			--actions+=/variable,name=pool_soul_shards,value=active_enemies>1&cooldown.havoc.remains<=10|cooldown.summon_infernal.remains<=15&talent.dark_soul_instability.enabled&cooldown.dark_soul_instability.remains<=15|talent.dark_soul_instability.enabled&cooldown.dark_soul_instability.remains<=15&(cooldown.summon_infernal.remains>target.time_to_die|cooldown.summon_infernal.remains+cooldown.summon_infernal.duration>target.time_to_die)
			VarPoolSoulShards = MultiUnits:GetActiveEnemies() > 1 and (A.Havoc:GetCooldown() <= 10) or (A.SummonInfernal:GetCooldown() <= 15 and A.DarkSoulInstability:IsTalentLearned() and A.DarkSoulInstability:GetCooldown() <= 15) or A.DarkSoulInstability:IsTalentLearned() and A.DarkSoulInstability:GetCooldown() <= 15 and (A.SummonInfernal:GetCooldown() > Unit("target"):TimeToDie())
			
			--actions+=/conflagrate,if=buff.backdraft.down&soul_shard>=1.5-0.3*talent.flashover.enabled&!variable.pool_soul_shards
			if A.Conflagrate:IsReady(unit) and Unit(player):HasBuffs(A.Backdraft.ID, true) == 0 and Player:SoulShards() >= 1.5 - (0.3 * num(A.Flashover:IsTalentLearned())) and not VarPoolSoulShards then
				return A.Conflagrate:Show(icon)
			end	
			
			--actions+=/chaos_bolt,if=buff.dark_soul_instability.up
			if A.ChaosBolt:IsReady(unit) and (not isMoving) and Unit(player):HasBuffs(A.DarkSoulInstability.ID, true) > 0 then
				return A.ChaosBolt:Show(icon)
			end	
			
			--actions+=/chaos_bolt,if=buff.backdraft.up&!variable.pool_soul_shards&!talent.eradication.enabled
			if A.ChaosBolt:IsReady(unit) and (not isMoving) and Unit(player):HasBuffs(A.Backdraft.ID, true) > 0 and not VarPoolSoulShards and not A.Eradication:IsTalentLearned() then
				return A.ChaosBolt:Show(icon)
			end	
			
			--actions+=/chaos_bolt,if=!variable.pool_soul_shards&talent.eradication.enabled&(debuff.eradication.remains<cast_time|buff.backdraft.up)
			if A.ChaosBolt:IsReady(unit) and (not isMoving) and not VarPoolSoulShards and A.Eradication:IsTalentLearned() and (Unit(unit):HasDeBuffs(A.EradicationDebuff.ID, true) < Player:Execute_Time(A.ChaosBolt.ID) or Unit(player):HasBuffs(A.BackdraftBuff.ID, true) > 0) then
				return A.ChaosBolt:Show(icon)
			end		
			
			--actions+=/shadowburn,if=!variable.pool_soul_shards|soul_shard>=4.5
			if A.Shadowburn:IsReady(unit) and A.Shadowburn:IsTalentLearned() and (not VarPoolSoulShards or Player:SoulShards() >= 4.5) then
				return A.Shadowburn:Show(icon)
			end	
			
			--actions+=/chaos_bolt,if=(soul_shard>=4.5-0.2*active_enemies)
			if A.ChaosBolt:IsReady(unit) and (not isMoving) and (Player:SoulShards() >= 4.5 - (0.2 * MultiUnits:GetActiveEnemies())) then
				return A.ChaosBolt:Show(icon)
			end	
			
			--actions+=/conflagrate,if=charges>1
			if A.Conflagrate:IsReady(unit) and A.Conflagrate:GetSpellCharges() > 1 then
				return A.Conflagrate:Show(icon)
			end	
			
			--actions+=/incinerate
			if A.Incinerate:IsReady(unit) and (not isMoving) then
				return A.Incinerate:Show(icon)
			end	
		end
		
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

A[1] = nil

A[4] = nil

A[5] = nil

A[6] = nil

A[7] = nil

A[8] = nil