--######################################
--##### TRIP'S FROST DEATH KNIGHT #####
--######################################

local _G, setmetatable							= _G, setmetatable
local A                         			    = _G.Action
local Covenant									= _G.LibStub("Covenant")
local TMW										= _G.TMW
local Listener                                  = Action.Listener
local Create                                    = Action.Create
local GetToggle                                 = Action.GetToggle
local SetToggle                                 = Action.SetToggle
local GetGCD                                    = Action.GetGCD
local GetCurrentGCD                             = Action.GetCurrentGCD
local GetPing                                   = Action.GetPing
local ShouldStop                                = Action.ShouldStop
local BurstIsON                                 = Action.BurstIsON
local CovenantIsON								= Action.CovenantIsON
local AuraIsValid                               = Action.AuraIsValid
local InterruptIsValid                          = Action.InterruptIsValid
local FrameHasSpell                             = Action.FrameHasSpell
local Utils                                     = Action.Utils
local TeamCache                                 = Action.TeamCache
local EnemyTeam                                 = Action.EnemyTeam
local FriendlyTeam                              = Action.FriendlyTeam
local LoC                                       = Action.LossOfControl
local Player                                    = Action.Player
local Pet                                       = LibStub("PetLibrary") 
local MultiUnits                                = Action.MultiUnits
local UnitCooldown                              = Action.UnitCooldown
local Unit                                      = Action.Unit 
local IsUnitEnemy                               = Action.IsUnitEnemy
local IsUnitFriendly                            = Action.IsUnitFriendly
local ActiveUnitPlates                          = MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit                     = IsIndoors, UnitIsUnit
local pairs                                     = pairs

--For Toaster
local Toaster									= _G.Toaster
local GetSpellTexture 							= _G.TMW.GetSpellTexture

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

Action[ACTION_CONST_DEATHKNIGHT_FROST] = {
    -- Racial
    ArcaneTorrent					= Action.Create({ Type = "Spell", ID = 50613    }),
    BloodFury						= Action.Create({ Type = "Spell", ID = 20572    }),
    Fireblood						= Action.Create({ Type = "Spell", ID = 265221   }),
    AncestralCall					= Action.Create({ Type = "Spell", ID = 274738   }),
    Berserking						= Action.Create({ Type = "Spell", ID = 26297    }),
    ArcanePulse						= Action.Create({ Type = "Spell", ID = 260364   }),
    QuakingPalm						= Action.Create({ Type = "Spell", ID = 107079   }),
    Haymaker						= Action.Create({ Type = "Spell", ID = 287712   }), 
    WarStomp						= Action.Create({ Type = "Spell", ID = 20549    }),
    BullRush						= Action.Create({ Type = "Spell", ID = 255654   }),  
    GiftofNaaru						= Action.Create({ Type = "Spell", ID = 59544    }),
    Shadowmeld						= Action.Create({ Type = "Spell", ID = 58984    }), 
    Stoneform						= Action.Create({ Type = "Spell", ID = 20594    }), 
    BagofTricks						= Action.Create({ Type = "Spell", ID = 312411	}),
    WilloftheForsaken				= Action.Create({ Type = "Spell", ID = 7744		}),   
    EscapeArtist					= Action.Create({ Type = "Spell", ID = 20589    }), 
    EveryManforHimself				= Action.Create({ Type = "Spell", ID = 59752    }), 
	LightsJudgment					= Action.Create({ Type = "Spell", ID = 255647	}),

	-- Death Knight General
    AntiMagicShell					= Action.Create({ Type = "Spell", ID = 48707	}),
    AntiMagicZone					= Action.Create({ Type = "Spell", ID = 51052	}),
    ChainsofIce						= Action.Create({ Type = "Spell", ID = 45524	}),
    ControlUndead					= Action.Create({ Type = "Spell", ID = 111673	}),
    DarkCommand						= Action.Create({ Type = "Spell", ID = 56222	}),
    DeathandDecay					= Action.Create({ Type = "Spell", ID = 43265	}),
    DeathCoil						= Action.Create({ Type = "Spell", ID = 47541	}),
    DeathGate						= Action.Create({ Type = "Spell", ID = 50977	}),
    DeathGrip						= Action.Create({ Type = "Spell", ID = 49576	}),
    DeathStrike						= Action.Create({ Type = "Spell", ID = 49998	}),
    DeathsAdvance					= Action.Create({ Type = "Spell", ID = 48265	}),	
    IceboundFortitude				= Action.Create({ Type = "Spell", ID = 48792	}),
    Lichborne						= Action.Create({ Type = "Spell", ID = 49039	}),	
    MindFreeze						= Action.Create({ Type = "Spell", ID = 47528	}),
    PathofFrost						= Action.Create({ Type = "Spell", ID = 3714		}),
    RaiseAlly						= Action.Create({ Type = "Spell", ID = 61999	}),
	RaiseDead						= Action.Create({ Type = "Spell", ID = 46585	}),
    Runeforging						= Action.Create({ Type = "Spell", ID = 53428	}),
    SacrificialPact					= Action.Create({ Type = "Spell", ID = 327574	}),
    OnaPaleHorse					= Action.Create({ Type = "Spell", ID = 51986, Hidden = true		}),
    VeteranoftheFourthWar			= Action.Create({ Type = "Spell", ID = 319278, Hidden = true	}),
	UnholyStrength					= Action.Create({ Type = "Spell", ID = 53365, Hidden = true		}),
	
	-- Frost Specific
    EmpowerRuneWeapon				= Action.Create({ Type = "Spell", ID = 47568	}),
    FrostStrike						= Action.Create({ Type = "Spell", ID = 49143	}),
    FrostwyrmsFury					= Action.Create({ Type = "Spell", ID = 279302	}),
    HowlingBlast					= Action.Create({ Type = "Spell", ID = 49184	}),
	FrostFever						= Action.Create({ Type = "Spell", ID = 55095, Hidden = true 	}),
    Obliterate						= Action.Create({ Type = "Spell", ID = 49020	}),
    PillarofFrost					= Action.Create({ Type = "Spell", ID = 51271	}),
    RemorselessWinter				= Action.Create({ Type = "Spell", ID = 196770	}),	
    DarkSuccor						= Action.Create({ Type = "Spell", ID = 178819, Hidden = true	}),
    KillingMachine					= Action.Create({ Type = "Spell", ID = 51128, Hidden = true		}),
    KillingMachineBuff				= Action.Create({ Type = "Spell", ID = 51124, Hidden = true		}),	
    MasteryFrozenHeart				= Action.Create({ Type = "Spell", ID = 77514, Hidden = true 	}),
    MightoftheFrozenWastes			= Action.Create({ Type = "Spell", ID = 81333, Hidden = true		}),
    Rime							= Action.Create({ Type = "Spell", ID = 59057, Hidden = true 	}),
	RimeBuff						= Action.Create({ Type = "Spell", ID = 59052, Hidden = true 	}),
    RunicEmpowerment				= Action.Create({ Type = "Spell", ID = 81229, Hidden = true 	}),
    RazoriceDebuff					= Action.Create({ Type = "Spell", ID = 51714, Hidden = true 	}),	

	-- Normal Talents
    InexorableAssault				= Action.Create({ Type = "Spell", ID = 253593, Hidden = true	}),
    IcyTalons						= Action.Create({ Type = "Spell", ID = 194878, Hidden = true	}),
    ColdHeart						= Action.Create({ Type = "Spell", ID = 281208, Hidden = true	}),
    ColdHeartBuff					= Action.Create({ Type = "Spell", ID = 281209, Hidden = true	}),	
    RunicAttenuation				= Action.Create({ Type = "Spell", ID = 207104, Hidden = true	}),
    MurderousEfficiency				= Action.Create({ Type = "Spell", ID = 207061, Hidden = true	}),
    HornofWinter					= Action.Create({ Type = "Spell", ID = 57330	}),
	DeathsReach						= Action.Create({ Type = "Spell", ID = 276079, Hidden = true	}),
    Asphyxiate						= Action.Create({ Type = "Spell", ID = 108194	}),
    BlindingSleet					= Action.Create({ Type = "Spell", ID = 207167	}),
    Avalanche						= Action.Create({ Type = "Spell", ID = 207142, Hidden = true	}),
    FrozenPulse						= Action.Create({ Type = "Spell", ID = 194909, Hidden = true	}),
    Frostscythe						= Action.Create({ Type = "Spell", ID = 207230	}),
    Permafrost						= Action.Create({ Type = "Spell", ID = 207200, Hidden = true	}),
    WraithWalk						= Action.Create({ Type = "Spell", ID = 212552	}),
    DeathPact						= Action.Create({ Type = "Spell", ID = 48743	}),
    DeathPact						= Action.Create({ Type = "Spell", ID = 48743	}),	
    GatheringStorm					= Action.Create({ Type = "Spell", ID = 194912, Hidden = true	}),
    HypothermicPresence				= Action.Create({ Type = "Spell", ID = 321995	}),
    GlacialAdvance					= Action.Create({ Type = "Spell", ID = 194913	}),
    Icecap							= Action.Create({ Type = "Spell", ID = 207126, Hidden = true	}),
    Obliteration					= Action.Create({ Type = "Spell", ID = 281238, Hidden = true 	}),
    BreathofSindragosa				= Action.Create({ Type = "Spell", ID = 152279	}),	

	-- PvP Talents
    NecroticAura					= Action.Create({ Type = "Spell", ID = 199642, Hidden = true 	}),
    Deathchill						= Action.Create({ Type = "Spell", ID = 204080, Hidden = true 	}),
    Delirium						= Action.Create({ Type = "Spell", ID = 233396, Hidden = true	}),
    ChillStreak						= Action.Create({ Type = "Spell", ID = 305392	}),
    HeartstopAura					= Action.Create({ Type = "Spell", ID = 199719, Hidden = true	}),
    DarkSimulacrum					= Action.Create({ Type = "Spell", ID = 77606	}),
    DecomposingAura					= Action.Create({ Type = "Spell", ID = 199720, Hidden = true	}),
    CadaverousPallor				= Action.Create({ Type = "Spell", ID = 201995, Hidden = true	}),	
    DeadofWinter					= Action.Create({ Type = "Spell", ID = 287250, Hidden = true	}),
    Transfusion						= Action.Create({ Type = "Spell", ID = 288977	}),
    DomeofAncientShadow				= Action.Create({ Type = "Spell", ID = 328718, Hidden = true	}),	
	
	-- Covenant Abilities
    SummonSteward					= Action.Create({ Type = "Spell", ID = 324739	}),
    DoorofShadows					= Action.Create({ Type = "Spell", ID = 300728	}),
    Fleshcraft						= Action.Create({ Type = "Spell", ID = 331180	}),
    Soulshape						= Action.Create({ Type = "Spell", ID = 310143	}),
    Flicker							= Action.Create({ Type = "Spell", ID = 324701	}),
    ShackletheUnworthy				= Action.Create({ Type = "Spell", ID = 312202	}),
    SwarmingMist					= Action.Create({ Type = "Spell", ID = 311648	}),	
    AbominationLimb					= Action.Create({ Type = "Spell", ID = 315443	}),
    DeathsDue						= Action.Create({ Type = "Spell", ID = 324128	}),	

	-- Conduits
    AcceleratedCold					= Action.Create({ Type = "Spell", ID = 337822, Hidden = true	}),
    EradicatingBlow					= Action.Create({ Type = "Spell", ID = 337934, Hidden = true	}),
    Everfrost						= Action.Create({ Type = "Spell", ID = 337988, Hidden = true	}),
    UnleasedFrenzy					= Action.Create({ Type = "Spell", ID = 338501, Hidden = true	}),
    Proliferation					= Action.Create({ Type = "Spell", ID = 338664, Hidden = true	}),	
    ImpenetrableGloom				= Action.Create({ Type = "Spell", ID = 338628, Hidden = true	}),
    BrutalGrasp						= Action.Create({ Type = "Spell", ID = 338651, Hidden = true	}),
    WitheringGround					= Action.Create({ Type = "Spell", ID = 341344, Hidden = true	}),
    HardenedBones					= Action.Create({ Type = "Spell", ID = 337972, Hidden = true	}),
    InsatiableAppetite				= Action.Create({ Type = "Spell", ID = 338330, Hidden = true	}),	
    ReinforcedShell					= Action.Create({ Type = "Spell", ID = 337764, Hidden = true	}),
    ChilledResilience				= Action.Create({ Type = "Spell", ID = 337704, Hidden = true	}),
    FleetingWind					= Action.Create({ Type = "Spell", ID = 338093, Hidden = true	}),
    SpiritDrain						= Action.Create({ Type = "Spell", ID = 337705, Hidden = true	}),
    UnendingGrip					= Action.Create({ Type = "Spell", ID = 338311, Hidden = true	}),	

	-- Legendaries
	-- General Legendaries
    DeathsEmbrace					= Action.Create({ Type = "Spell", ID = 334728, Hidden = true	}),
    GripoftheEverlasting			= Action.Create({ Type = "Spell", ID = 334724, Hidden = true	}),
    Phearomones						= Action.Create({ Type = "Spell", ID = 335177, Hidden = true	}),
    Superstain						= Action.Create({ Type = "Spell", ID = 334974, Hidden = true	}),	

	--Frost Legendaries
    AbsoluteZero					= Action.Create({ Type = "Spell", ID = 334692, Hidden = true	}),
    BitingCold						= Action.Create({ Type = "Spell", ID = 334678, Hidden = true	}),
    KoltirasFavor					= Action.Create({ Type = "Spell", ID = 334583, Hidden = true	}),
    RageoftheFrozenChampion			= Action.Create({ Type = "Spell", ID = 341724, Hidden = true	}),	

	--Anima Powers - to add later...
	
	
	-- Trinkets
	

	-- Potions
    PotionofUnbridledFury			= Action.Create({ Type = "Potion", ID = 169299, QueueForbidden = true }), 	
    SuperiorPotionofUnbridledFury	= Action.Create({ Type = "Potion", ID = 168489, QueueForbidden = true }),
    PotionofSpectralStrength		= Action.Create({ Type = "Potion", ID = 171275, QueueForbidden = true }),
    PotionofSpectralStamina			= Action.Create({ Type = "Potion", ID = 171274, QueueForbidden = true }),
    PotionofEmpoweredExorcisms		= Action.Create({ Type = "Potion", ID = 171352, QueueForbidden = true }),
    PotionofHardenedShadows			= Action.Create({ Type = "Potion", ID = 171271, QueueForbidden = true }),
    PotionofPhantomFire				= Action.Create({ Type = "Potion", ID = 171349, QueueForbidden = true }),
    PotionofDeathlyFixation			= Action.Create({ Type = "Potion", ID = 171351, QueueForbidden = true }),
    SpiritualHealingPotion			= Action.Create({ Type = "Potion", ID = 171267, QueueForbidden = true }),  	

    -- Misc
    Channeling                      = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),    -- Show an icon during channeling
    TargetEnemy                     = Action.Create({ Type = "Spell", ID = 44603, Hidden = true     }),    -- Change Target (Tab button)
    StopCast                        = Action.Create({ Type = "Spell", ID = 61721, Hidden = true     }),        -- spell_magic_polymorphrabbit
    PoolResource                    = Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),
	Quake                           = Action.Create({ Type = "Spell", ID = 240447, Hidden = true     }), -- Quake (Mythic Plus Affix)
}

-- To create essences use next code:
A:CreateEssencesFor(ACTION_CONST_DEATHKNIGHT_FROST)  -- where PLAYERSPEC is Constance (example: ACTION_CONST_MONK_BM)
local A = setmetatable(Action[ACTION_CONST_DEATHKNIGHT_FROST], { __index = Action })


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

local function InMelee(unit)
	-- @return boolean 
	return A.ScourgeStrike:IsInRange(unit)
end 

local function GetByRange(count, range, isCheckEqual, isCheckCombat)
	-- @return boolean 
	local c = 0 
	for unit in pairs(ActiveUnitPlates) do 
		if (not isCheckEqual or not UnitIsUnit("target", unit)) and (not isCheckCombat or Unit(unit):CombatTime() > 0) then 
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
GetByRange = A.MakeFunctionCachedDynamic(GetByRange)

-- Non GCD spell check
local function countInterruptGCD(unit)
    if not A.MindFreeze:IsReadyByPassCastGCD(unit) or not A.MindFreeze:AbsentImun(unit, Temp.TotalAndMagKick) then
	    return true
	end
end

-- Interrupts spells
local function Interrupts(unit)
local DeathGripInterrupt = Action.GetToggle(2, "DeathGripInterrupt")
local AsphyxiateInterrupt = Action.GetToggle(2, "AsphyxiateInterrupt")

useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, nil, nil, countInterruptGCD(unit))

	if castRemainsTime >= A.GetLatency() then
        -- MindFreeze
        if useKick and not notInterruptable and A.MindFreeze:IsReady(unit) then 
            return A.MindFreeze
        end
	
        -- DeathGrip
        if A.DeathGrip:IsReady(unit) and DeathGripInterrupt and A.MindFreeze:GetCooldown() > 1 and useCC then 
            return A.DeathGrip
   	    end 
	
   	    -- Asphyxiate
   	    if A.Asphyxiate:IsSpellLearned() and A.Asphyxiate:IsReady(unit) and AsphyxiateInterrupt and A.MindFreeze:GetCooldown() > 1 and useCC then 
   	        return A.Asphyxiate
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

local function SelfDefensives(unit)
    local HPLoosePerSecond = Unit(player):GetDMG() * 100 / Unit(player):HealthMax()
		
    if Unit(player):CombatTime() == 0 then 
        return 
    end 

    -- Icebound Fortitude
	
	local IceboundFortitudeAntiStun = GetToggle(2, "IceboundFortitudeAntiStun")
    local IceboundFortitude = GetToggle(2, "IceboundFortitudeHP")
    if     IceboundFortitude >= 0 and A.IceboundFortitude:IsReady(player) and 
    (
        (   -- Auto 
            IceboundFortitude >= 100 and 
            (
                -- HP lose per sec >= 20
                Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 30 or 
                Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.30 or 
                -- TTD 
                Unit(player):TimeToDieX(25) < 2 or
				-- Player stunned
                LoC:Get("STUN") > 2 and IceboundFortitudeAntiStun or			
                (
                    A.IsInPvP and 
                    (
                        Unit(player):UseDeff() or 
                        (
                            Unit(player, 5):HasFlags() and 
                            Unit(player):GetRealTimeDMG() > 0 and 
                            Unit(player):IsFocused() 
                        )
                    )
                )
            ) and 
            Unit(player):HasBuffs("DeffBuffs", true) == 0
        ) or 
        (    -- Custom
            IceboundFortitude < 100 and 
            Unit(player):HealthPercent() <= IceboundFortitude
        )
    ) 
    then 
        return A.IceboundFortitude
    end  
		
    -- Emergency AntiMagicShell
        local AntiMagicShell = GetToggle(2, "AntiMagicShellHP")
        if     AntiMagicShell >= 0 and A.AntiMagicShell:IsReady(player) and 
        (
            (   -- Auto 
                AntiMagicShell >= 100 and 
                (
                    -- HP lose per sec >= 10
                    Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 15 or 
                    Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.15 or 
                    -- TTD Magic
                    Unit(player):TimeToDieMagicX(30) < 3 or 
					
                    (
                        A.IsInPvP and 
                        (
                            Unit(player):UseDeff() or 
                            (
                                Unit(player, 5):HasFlags() and 
                                Unit(player):GetRealTimeDMG() > 0 and 
                                Unit(player):IsFocused() 
                            )
                        )
                    )
                ) and 
                Unit(player):HasBuffs("DeffBuffs", true) == 0
            ) or 
            (    -- Custom
                AntiMagicShell < 100 and 
                Unit(player):HealthPercent() <= AntiMagicShell
            )
        ) 
        then 
            return A.AntiMagicShell
        end  		

        -- Emergency Death Pact
        local DeathPact = GetToggle(2, "DeathPactHP")
        if     DeathPact >= 0 and A.DeathPact:IsReady(player) and A.DeathPact:IsSpellLearned() and 
        (
            (   -- Auto 
                DeathPact >= 100 and 
                (
                    -- HP lose per sec >= 30
                    Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 30 or 
                    Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.30 or 
                    -- TTD 
                    Unit(player):TimeToDieX(25) < 5 or 
                    (
                        A.IsInPvP and 
                        (
                            Unit(player):UseDeff() or 
                            (
                                Unit(player, 5):HasFlags() and 
                                Unit(player):GetRealTimeDMG() > 0 and 
                                Unit(player):IsFocused() 
                            )
                        )
                    )
                ) and 
                Unit(player):HasBuffs("DeffBuffs", true) == 0
            ) or 
            (    -- Custom
                DeathPact < 100 and 
                Unit(player):HealthPercent() <= DeathPact
            )
        ) 
        then 
            return A.DeathPact
        end  		

    -- HealingPotion
    local SpiritualHealingPotion = A.GetToggle(2, "SpiritualHealingPotionHP")
    if     SpiritualHealingPotion >= 0 and A.SpiritualHealingPotion:IsReady(player) and 
    (
        (     -- Auto 
            SpiritualHealingPotion >= 100 and 
            (
                -- HP lose per sec >= 20
                Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 20 or 
                Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.20 or 
                -- TTD 
                Unit(player):TimeToDieX(25) < 5 or 
                (
                    A.IsInPvP and 
                    (
                        Unit(player):UseDeff() or 
                        (
                            Unit("player", 5):HasFlags() and 
                            Unit(player):GetRealTimeDMG() > 0 and 
                            Unit(player):IsFocused() 
                        )
                    )
                )
            ) and 
            Unit(player):HasBuffs("DeffBuffs", true) == 0
        ) or 
        (    -- Custom
            SpiritualHealingPotion < 100 and 
            Unit(player):HealthPercent() <= SpiritualHealingPotion
        )
    ) 
    then 
        return A.SpiritualHealingPotion
    end 

end 
SelfDefensives = A.MakeFunctionCachedDynamic(SelfDefensives)

--- ======= ACTION LISTS =======
-- [3] Single Rotation
A[3] = function(icon, isMulti)
    --------------------
    --- ROTATION VAR ---
    --------------------
    local isMoving = A.Player:IsMoving()
    local inCombat = Unit("player"):CombatTime() > 0
    local combatTime = Unit("player"):CombatTime()
	local RunicPower = Player:RunicPower()
	local RunicPowerDeficit = Player:RunicPowerDeficit()
	local AutoPotionSelect = Action.GetToggle(2, "AutoPotionSelect")
	local PotionTrue = Action.GetToggle(1, "Potion")	
	local DeathandDecayTicking = A.DeathandDecay:GetSpellTimeSinceLastCast() <= 10
    local Racial = Action.GetToggle(1, "Racial")
	local UseAoE = Action.GetToggle(2, "AoE")
	local DeathStrikeHP = Action.GetToggle(2, "DeathStrikeHP")
	local AoETargets = Action.GetToggle(2, "AoETargets")
	local AutoSwitchRazorice = Action.GetToggle(2, "AutoSwitchRazorice")
	local currentTargets = MultiUnits:GetByRange(7)	
	local MissingRazorice = MultiUnits:GetByRangeMissedDoTs(10, 5, A.RazoriceDebuff.ID)
    local mainHandEnchantment, mainHandExpire, mainHandCarges, mainHandEnchantmentID, offHandEnchantment = GetWeaponEnchantInfo() 
	local PotionIsReady = (Action.GetToggle(2, "AutoPotionSelect") == "UnbridledFuryPot" and A.PotionofUnbridledFury:IsReady("player"))	or (Action.GetToggle(2, "AutoPotionSelect") == "SpectralStrengthPot" and A.PotionofSpectralStrength:IsReady("player")) or (Action.GetToggle(2, "AutoPotionSelect") == "EmpoweredExorcismsPot" and A.PotionofEmpoweredExorcisms:IsReady("player")) or (Action.GetToggle(2, "AutoPotionSelect") == "PhantomFirePot" and A.PotionofPhantomFire:IsReady("player")) or (Action.GetToggle(2, "AutoPotionSelect") == "DeathlyFixationPot" and A.PotionofDeathlyFixation:IsReady("player"))	
	
    ------------------------------------------------------
    ---------------- ENEMY UNIT ROTATION -----------------
    ------------------------------------------------------
    local function EnemyRotation(unit)

		local Interrupt = Interrupts(unit)
		if Interrupt then 
			return Interrupt:Show(icon)
		end	

		--Death Strike below HP %
		if A.DeathStrike:IsReady(unit) and Unit(player):HealthPercent() <= DeathStrikeHP then
			return A.DeathStrike:Show(icon)
		end			

		--########################
		--##### AOE ROTATION #####
		--########################
		
		local function AoERotation(unit)
		
			--actions.aoe=remorseless_winter,if=talent.gathering_storm.enabled
			if A.RemorselessWinter:IsReady(player) and A.GatheringStorm:IsTalentLearned() then
				return A.RemorselessWinter:Show(icon)
			end	
			
			--actions.aoe+=/glacial_advance,if=talent.frostscythe.enabled
			if A.GlacialAdvance:IsReady(unit) and A.GlacialAdvance:IsTalentLearned() and A.Frostscythe:IsTalentLearned() then
				return A.GlacialAdvance:Show(icon)
			end	
			--actions.aoe+=/frost_strike,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=cooldown.remorseless_winter.remains<=2*gcd&talent.gathering_storm.enabled
			if AutoSwitchRazorice and (mainHandEnchantment == "Rune of Razorice" or offHandEnchantment == "Rune of Razorice") and Unit(unit):HasDeBuffsStacks(A.RazoriceDebuff.ID, true) > 0 and (A.RemorselessWinter:GetCooldown() <= 2 * A.GetGCD()) and A.GatheringStorm:IsTalentLearned() and Player:AreaTTD(10) > 5 and RunicPower >= 25 and currentTargets >= 2 and currentTargets <= 5 and (MissingRazorice > 0 and MissingRazorice < 5 or Unit(unit):IsDummy())
			then
				local Razorice_Nameplates = MultiUnits:GetActiveUnitPlates()
				if Razorice_Nameplates then  
					for Razorice_UnitID in pairs(Razorice_Nameplates) do             
						if Unit(Razorice_UnitID):GetRange() < 6 and InMelee(Razorice_UnitID) and not Unit(Razorice_UnitID):InLOS() and Unit(Razorice_UnitID):HasDeBuffsStacks(A.Razorice.ID, true) == 0 then 
							return A:Show(icon, ACTION_CONST_AUTOTARGET)
						end         
					end 
				end
			end			
			
			--actions.aoe+=/howling_blast,if=buff.rime.up
			if A.HowlingBlast:IsReady(unit) and Unit(player):HasBuffs(A.RimeBuff.ID, true) > 0 then
				return A.HowlingBlast:Show(icon)
			end	
			
			--actions.aoe+=/frostscythe,if=buff.killing_machine.up
			if A.Frostscythe:IsReady(player) and A.Frostscythe:IsTalentLearned() and Unit(player):HasBuffs(A.KillingMachineBuff.ID, true) > 0 then
				return A.Frostscythe:Show(icon)
			end
			
			--actions.aoe+=/glacial_advance,if=runic_power.deficit<(15+talent.runic_attenuation.enabled*3)
			if A.GlacialAdvance:IsReady(player) and A.GlacialAdvance:IsTalentLearned() and RunicPowerDeficit < (15 + num(RunicAttenuation:IsTalentLearned()) * 3) then
				return A.GlacialAdvance:Show(icon)
			end	
			
			--actions.aoe+=/frost_strike,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=runic_power.deficit<(15+talent.runic_attenuation.enabled*3)
			if AutoSwitchRazorice and (mainHandEnchantment == "Rune of Razorice" or offHandEnchantment == "Rune of Razorice") and Unit(unit):HasDeBuffsStacks(A.RazoriceDebuff.ID, true) > 0 and RunicPowerDeficit < (15 + num(A.RunicAttenuation:IsTalentLearned()) * 3) and Player:AreaTTD(10) > 5 and currentTargets >= 2 and currentTargets <= 5 and (MissingRazorice > 0 and MissingRazorice < 5 or Unit(unit):IsDummy())
			then
				local Razorice_Nameplates = MultiUnits:GetActiveUnitPlates()
				if Razorice_Nameplates then  
					for Razorice_UnitID in pairs(Razorice_Nameplates) do             
						if Unit(Razorice_UnitID):GetRange() < 6 and InMelee(Razorice_UnitID) and not Unit(Razorice_UnitID):InLOS() and Unit(Razorice_UnitID):HasDeBuffsStacks(A.Razorice.ID, true) == 0 then 
							return A:Show(icon, ACTION_CONST_AUTOTARGET)
						end         
					end 
				end
			end				
			
			
			--actions.aoe+=/remorseless_winter
			if A.RemorselessWinter:IsReady(player) then
				return A.RemorselessWinter:Show(icon)
			end	
			
			--actions.aoe+=/frostscythe
			if A.Frostscythe:IsReady(player) and A.Frostscythe:IsTalentLearned() then
				return A.Frostscythe:Show(icon)
			end	
			
			--actions.aoe+=/obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=runic_power.deficit>(25+talent.runic_attenuation.enabled*3)
			if A.Obliterate:IsReady(unit) and Unit("target"):HasDeBuffs(A.RazoriceDebuff.ID, true) > 0  and RunicPowerDeficit > (25 + num(A.RunicAttenuation:IsTalentLearned()) * 3) then
				return A.Obliterate:Show(icon)
			end	
			
			--actions.aoe+=/glacial_advance
			if A.GlacialAdvance:IsReady(player) and A.GlacialAdvance:IsTalentLearned() then
				return A.GlacialAdvance:Show(icon)
			end	
			
			--actions.aoe+=/frost_strike,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice
			if A.FrostStrike:IsReady(unit) and Unit("target"):HasDeBuffs(A.RazoriceDebuff.ID, true) == 0 then
				return A.FrostStrike:Show(icon)
			end	
			
			--actions.aoe+=/horn_of_winter
			if A.HornofWinter:IsReady(player) and A.HornofWinter:IsTalentLearned() then
				return A.HornofWinter:Show(icon)
			end	
			
			--actions.aoe+=/arcane_torrent		
			if A.ArcaneTorrent:IsReady(player) and A.ArcaneTorrent:AutoRacial(player) then
				return A.ArcaneTorrent:Show(icon)
			end	
		
		end

		--#######################
		--##### BOS POOLING #####
		--#######################

		local function BoSPooling()

			--actions.bos_pooling=howling_blast,if=buff.rime.up
			if A.HowlingBlast:IsReady(unit) and Unit(player):HasBuffs(A.RimeBuff.ID, true) > 0 then
				return A.HowlingBlast:Show(icon)
			end	
			
			--actions.bos_pooling+=/remorseless_winter,if=talent.gathering_storm.enabled&rune>=5|active_enemies>=2
			if A.RemorselessWinter:IsReady(player) and A.GatheringStorm:IsTalentLearned() and Player:Rune() >= 5 or MultiUnits:GetByRange(8, 2) >= 2 then
				return A.RemorselessWinter:Show(icon)
			end	
			
			--# 'target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice' Repeats a lot, this is intended to target the highest priority enemy with an ability that will apply razorice if runeforged. That being an enemy with 0 stacks, or an enemy that the debuff will soon expire on.
			if AutoSwitchRazorice and (mainHandEnchantment == "Rune of Razorice" or offHandEnchantment == "Rune of Razorice") and Unit(unit):HasDeBuffsStacks(A.RazoriceDebuff.ID, true) > 0 and RunicPower >= 25 and Player:AreaTTD(10) > 5 and currentTargets >= 2 and currentTargets <= 5 and (MissingRazorice > 0 and MissingRazorice < 5 or Unit(unit):IsDummy())
			then
				local Razorice_Nameplates = MultiUnits:GetActiveUnitPlates()
				if Razorice_Nameplates then  
					for Razorice_UnitID in pairs(Razorice_Nameplates) do             
						if Unit(Razorice_UnitID):GetRange() < 6 and InMelee(Razorice_UnitID) and not Unit(Razorice_UnitID):InLOS() and Unit(Razorice_UnitID):HasDeBuffsStacks(A.Razorice.ID, true) == 0 then 
							return A:Show(icon, ACTION_CONST_AUTOTARGET)
						end         
					end 
				end
			end				
			
			--actions.bos_pooling+=/obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=runic_power.deficit>=25
			if A.Obliterate:IsReady(unit) and Unit(unit):HasDeBuffs(A.RazoriceDebuff.ID, true) > 0 and RunicPowerDeficit >= 25 then
				return A.Obliterate:Show(icon)
			end	
			
			--actions.bos_pooling+=/glacial_advance,if=runic_power.deficit<20&spell_targets.glacial_advance>=2&cooldown.pillar_of_frost.remains>5
			if A.GlacialAdvance:IsReady(player) and A.GlacialAdvance:IsTalentLearned() and RunicPowerDeficit < 20 and MultiUnits:GetByRange(12, 2) >= 2 and A.PillarofFrost:GetCooldown() > 5 then
				return A.GlacialAdvance:Show(icon)
			end	
			--actions.bos_pooling+=/frost_strike,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=runic_power.deficit<20&cooldown.pillar_of_frost.remains>5
			if AutoSwitchRazorice and (mainHandEnchantment == "Rune of Razorice" or offHandEnchantment == "Rune of Razorice") and Unit(unit):HasDeBuffsStacks(A.RazoriceDebuff.ID, true) > 0 and RunicPowerDeficit < 20 and A.PillarofFrost:GetCooldown() > 5 and Player:AreaTTD(10) > 5 and currentTargets >= 2 and currentTargets <= 5 and (MissingRazorice > 0 and MissingRazorice < 5 or Unit(unit):IsDummy())
			then
				local Razorice_Nameplates = MultiUnits:GetActiveUnitPlates()
				if Razorice_Nameplates then  
					for Razorice_UnitID in pairs(Razorice_Nameplates) do             
						if Unit(Razorice_UnitID):GetRange() < 6 and InMelee(Razorice_UnitID) and not Unit(Razorice_UnitID):InLOS() and Unit(Razorice_UnitID):HasDeBuffsStacks(A.Razorice.ID, true) == 0 then 
							return A:Show(icon, ACTION_CONST_AUTOTARGET)
						end         
					end 
				end
			end	
			
			--actions.bos_pooling+=/frostscythe,if=buff.killing_machine.up&runic_power.deficit>(15+talent.runic_attenuation.enabled*3)&spell_targets.frostscythe>=2
			if A.Frostscythe:IsReady(player) and A.Frostscythe:IsTalentLearned() and Unit(player):HasBuffs(A.KillingMachineBuff.ID, true) > 0 and RunicPowerDeficit > (15 + num(A.RunicAttenuation:IsTalentLearned()) * 3) and MultiUnits:GetByRange(8, 2) >= 2 then
				return A.Frostscythe:Show(icon)
			end	
			
			--actions.bos_pooling+=/frostscythe,if=runic_power.deficit>=(35+talent.runic_attenuation.enabled*3)&spell_targets.frostscythe>=2
			if A.Frostscythe:IsReady(player) and A.Frostscythe:IsTalentLearned() and RunicPowerDeficit >= (35 + num(A.RunicAttenuation:IsTalentLearned()) * 3) and MultiUnits:GetByRange(8, 2) >= 2 then
				return A.Frostscythe:Show(icon)
			end		
			
			--actions.bos_pooling+=/obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=runic_power.deficit>=(35+talent.runic_attenuation.enabled*3)
			if A.Obliterate:IsReady(unit) and Unit(unit):HasDeBuffs(A.RazoriceDebuff.ID, true) > 0 and RunicPowerDeficit >= (35 + num(A.RunicAttenuation:IsTalentLearned()) * 3) then
				return A.Obliterate:Show(icon)
			end	
			
			--actions.bos_pooling+=/glacial_advance,if=cooldown.pillar_of_frost.remains>rune.time_to_4&runic_power.deficit<40&spell_targets.glacial_advance>=2
			if A.GlacialAdvance:IsReady(player) and A.PillarofFrost:GetCooldown() > Player:RuneTimeToX(4) and RunicPowerDeficit < 40 and MultiUnits:GetByRange(12, 2) >= 2 then
				return A.GlacialAdvance:Show(icon)
			end
			
			--actions.bos_pooling+=/frost_strike,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=cooldown.pillar_of_frost.remains>rune.time_to_4&runic_power.deficit<40	
			if AutoSwitchRazorice and (mainHandEnchantment == "Rune of Razorice" or offHandEnchantment == "Rune of Razorice") and Unit(unit):HasDeBuffsStacks(A.RazoriceDebuff.ID, true) > 0 and  A.PillarofFrost:GetCooldown() > Player:RuneTimeToX(4) and RunicPowerDeficit < 40 and Player:AreaTTD(10) > 5 and currentTargets >= 2 and currentTargets <= 5 and (MissingRazorice > 0 and MissingRazorice < 5 or Unit(unit):IsDummy())
			then
				local Razorice_Nameplates = MultiUnits:GetActiveUnitPlates()
				if Razorice_Nameplates then  
					for Razorice_UnitID in pairs(Razorice_Nameplates) do             
						if Unit(Razorice_UnitID):GetRange() < 6 and InMelee(Razorice_UnitID) and not Unit(Razorice_UnitID):InLOS() and Unit(Razorice_UnitID):HasDeBuffsStacks(A.Razorice.ID, true) == 0 then 
							return A:Show(icon, ACTION_CONST_AUTOTARGET)
						end         
					end 
				end
			end	
	
		end 
		
		--#######################
		--##### BOS TICKING #####
		--#######################		
		
		local function BoSTicking()
		
			--actions.bos_ticking=obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=runic_power<=40
			if A.Obliterate:IsReady(unit) and Unit(unit):HasDeBuffs(A.RazoriceDebuff.ID, true) > 0 and RunicPower <= 40 then
				return A.Obliterate:Show(icon)
			end	
			
			--actions.bos_ticking+=/remorseless_winter,if=talent.gathering_storm.enabled|active_enemies>=2
			if A.RemorselessWinter:IsReady(unit) and (A.GatheringStorm:IsTalentLearned() or MultiUnits:GetByRange(8, 2) >= 2) then
				return A.RemorselessWinter:Show(icon)
			end			
			
			--actions.bos_ticking+=/howling_blast,if=buff.rime.up
			if A.HowlingBlast:IsReady(unit) and Unit(player):HasBuffs(A.RimeBuff.ID, true) > 0 then
				return A.HowlingBlast:Show(icon)
			end	
			
			--actions.bos_ticking+=/obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=rune.time_to_4<gcd|runic_power<=45
			if A.Obliterate:IsReady(unit) and Unit(unit):HasDeBuffs(A.RazoriceDebuff.ID, true) > 0 and (Player:RuneTimeToX(4) < A.GetGCD() or RunicPower <= 45) then
				return A.Obliterate:Show(icon)
			end	
			
			--actions.bos_ticking+=/frostscythe,if=buff.killing_machine.up&spell_targets.frostscythe>=2
			if A.Frostscythe:IsReady(player) and Unit(player):HasBuffs(A.KillingMachineBuff.ID, true) > 0 and MultiUnits:GetByRange(8, 2) >= 2 then
				return A.Frostscythe:Show(icon)
			end	
			
			--actions.bos_ticking+=/horn_of_winter,if=runic_power.deficit>=40&rune.time_to_3>gcd
			if A.HornofWinter:IsReady(player) and RunicPowerDeficit >= 40 and Player:RuneTimeToX(3) > A.GetGCD() then
				return A.HornofWinter:Show(icon)
			end	
			
			--actions.bos_ticking+=/frostscythe,if=spell_targets.frostscythe>=2
			if A.Frostscythe:IsReady(player) and MultiUnits:GetByRange(8, 2) >= 2 then
				return A.Frostscythe:Show(icon)
			end	
			
			--actions.bos_ticking+=/obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=runic_power.deficit>25|rune>3
			if A.Obliterate:IsReady(unit) and Unit(unit):HasDeBuffs(A.RazoriceDebuff.ID, true) > 0 and (RunicPowerDeficit > 25 or Player:Rune() > 3) then
				return A.Obliterate:Show(icon)
			end	
			
			--actions.bos_ticking+=/arcane_torrent,if=runic_power.deficit>50
			if A.ArcaneTorrent:IsReady(player) and A.ArcaneTorrent:AutoRacial(player) and RunicPowerDeficit > 50 then
				return A.ArcaneTorrent:Show(icon)
			end	
			
		end
		
		--######################
		--##### COLD HEART #####
		--######################			
		
		local function ColdHeartRotation()
		
			--actions.cold_heart=chains_of_ice,if=fight_remains<gcd|buff.pillar_of_frost.remains<3&buff.cold_heart.stack=20&!talent.obliteration.enabled
			if A.ChainsofIce:IsReady(unit) and (Player:AreaTTD(30) < A.GetGCD() or (Unit(player):HasBuffs(A.PillarofFrost.ID, true) < 3 and Unit(player):HasBuffsStacks(A.ColdHeartBuff.ID, true) == 20 and not A.Obliteration:IsTalentLearned())) then
				return A.ChainsofIce:Show(icon)
			end
			
			--actions.cold_heart+=/chains_of_ice,if=talent.obliteration.enabled&!buff.pillar_of_frost.up&(buff.cold_heart.stack>=16&buff.unholy_strength.up|buff.cold_heart.stack>=19)		
			if A.ChainsofIce:IsReady(unit) and A.Obliteration:IsTalentLearned() and Unit(player):HasBuffs(A.PillarofFrost.ID, true) == 0 and (Unit(player):HasBuffsStacks(A.ColdHeartBuff.ID, true) >= 16 and Unit(player):HasBuffs(A.UnholyStrength.ID, true) > 0 or Unit(player):HasBuffsStacks(A.ColdHeartBuff.ID, true) >= 19) then
				return A.ChainsofIce:Show(icon)
			end	
		
		end
		
		--#####################
		--##### COOLDOWNS #####
		--#####################		
		
		local function Cooldowns()
		
			--actions.cooldowns+=/potion,if=buff.pillar_of_frost.up&buff.empower_rune_weapon.up
            if PotionIsReady and Unit(unit):HasBuffs(A.PillarofFrost.ID, true) > 0 and Unit(unit):HasBuffs(A.EmpowerRuneWeapon.ID, true) > 0 then
				A.Toaster:SpawnByTimer("TripToast", 0, "Combat Potion!", "Using Combat Potion!", A.PotionofUnbridledFury.ID)  
				if AutoPotionSelect == "UnbridledFuryPot" then                  
					return A.PotionofUnbridledFury:Show(icon)
				elseif AutoPotionSelect == "SpectralStrengthPot" then
					return A.PotionofSpectralStrength:Show(icon)
				elseif AutoPotionSelect == "EmpoweredExorcismsPot" then
					return A.PotionofEmpoweredExorcisms:Show(icon)
				elseif AutoPotionSelect == "PhantomFirePot" then
					return A.PotionofPhantomFire:Show(icon)
				elseif AutoPotionSelect == "DeathlyFixationPot" then
					return A.PotionofDeathlyFixation:Show(icon)
				end
			end	
					
			--actions.cooldowns+=/blood_fury,if=buff.pillar_of_frost.up&buff.empower_rune_weapon.up
            if A.BloodFury:IsReady(player) and Unit(player):HasBuffs(A.PillarofFrost.ID, true) > 0 and Unit(player):HasBuffs(A.EmpowerRuneWeapon.ID, true) > 0 then
				return A.BloodFury:Show(icon)
			end	
			
			--actions.cooldowns+=/berserking,if=buff.pillar_of_frost.up
			if A.Berserking:IsReady(player) and Unit(player):HasBuffs(A.PillarofFrost.ID, true) > 0 then
				return A.Berserking:Show(icon)
			end	
			
			--actions.cooldowns+=/arcane_pulse,if=(!buff.pillar_of_frost.up&active_enemies>=2)|!buff.pillar_of_frost.up&(rune.deficit>=5&runic_power.deficit>=60)
			if A.ArcanePulse:IsReady(unit) and ((Unit(player):HasBuffs(A.PillarofFrost.ID, true) == 0 and MultiUnits:GetByRange(8, 2) >= 2) or ((Unit(player):HasBuffs(A.PillarofFrost.ID, true) == 0 and (Player:Rune() <= 1 and RunicPowerDeficit >= 60)))) then
				return A.ArcanePulse:Show(icon)
			end	
			
			--actions.cooldowns+=/lights_judgment,if=buff.pillar_of_frost.up
			if A.LightsJudgment:IsReady(unit) and Unit(player):HasBuffs(A.PillarofFrost.ID, true) > 0 then
				return A.LightsJudgment:Show(icon)
			end	
			
			--actions.cooldowns+=/ancestral_call,if=buff.pillar_of_frost.up&buff.empower_rune_weapon.up
            if A.AncestralCall:IsReady(player) and Unit(player):HasBuffs(A.PillarofFrost.ID, true) > 0 and Unit(player):HasBuffs(A.EmpowerRuneWeapon.ID, true) > 0 then
				return A.AncestralCall:Show(icon)
			end				
			
			--actions.cooldowns+=/fireblood,if=buff.pillar_of_frost.remains<=8&buff.empower_rune_weapon.up
            if A.Fireblood:IsReady(player) and Unit(player):HasBuffs(A.PillarofFrost.ID, true) <= 8 and Unit(player):HasBuffs(A.EmpowerRuneWeapon.ID, true) > 0 then
				return A.Fireblood:Show(icon)
			end				
			
			--actions.cooldowns+=/bag_of_tricks,if=buff.pillar_of_frost.up&(buff.pillar_of_frost.remains<5&talent.cold_heart.enabled|!talent.cold_heart.enabled&buff.pillar_of_frost.remains<3)&active_enemies=1
			if A.BagofTricks:IsReady(unit) and Unit(player):HasBuffs(A.PillarofFrost.ID, true) > 0 and ((Unit(player):HasBuffs(A.PillarofFrost, true) < 5 and A.ColdHeart:IsTalentLearned()) or not A.ColdHeart:IsTalentLearned() and (Unit(player):HasBuffs(A.PillarofFrost, true) < 3)) and MultiUnits:GetByRange(10, 2) == 1 then
				return A.BagofTricks:Show(icon)
			end	
			--actions.cooldowns+=/empower_rune_weapon,if=talent.obliteration.enabled&(cooldown.pillar_of_frost.ready&rune.time_to_5>gcd&runic_power.deficit>=10|buff.pillar_of_frost.up&rune.time_to_5>gcd)|fight_remains<20
			if A.EmpowerRuneWeapon:IsReady(player) and A.Obliteration:IsTalentLearned() and ((A.PillarofFrost:GetCooldown() == 0 and Player:RuneTimeToX(5) > A.GetGCD() and RunicPowerDeficit >= 10) or (Unit(player):HasBuffs(A.PillarofFrost.ID, true) > 0 and Player:RuneTimeToX(5) > A.GetGCD())) then
				return A.EmpowerRuneWeapon:Show(icon)
			end	
			
			--actions.cooldowns+=/empower_rune_weapon,if=talent.breath_of_sindragosa.enabled&runic_power.deficit>40&rune.time_to_5>gcd&(buff.breath_of_sindragosa.up|fight_remains<20)
			if A.EmpowerRuneWeapon:IsReady(player) and A.BreathofSindragosa:IsTalentLearned() and RunicPowerDeficit > 40 and Player:RuneTimeToX(5) > A.GetGCD() and Unit(player):HasBuffs(A.BreathofSindragosa.ID, true) > 0 then
				return A.EmpowerRuneWeapon:Show(icon)
			end	
			
			--actions.cooldowns+=/empower_rune_weapon,if=talent.icecap.enabled&rune<3
			if A.EmpowerRuneWeapon:IsReady(player) and A.Icecap:IsTalentLearned() and Player:Rune() < 3 then
				return A.EmpowerRuneWeapon:Show(icon)
			end	
			
			--actions.cooldowns+=/pillar_of_frost,if=talent.breath_of_sindragosa.enabled&(cooldown.breath_of_sindragosa.remains|cooldown.breath_of_sindragosa.ready&runic_power.deficit<60)
			if A.PillarofFrost:IsReady(player) and A.BreathofSindragosa:IsTalentLearned() and (A.BreathofSindragosa:GetCooldown() > 0 or (A.BreathofSindragosa:GetCooldown() == 0 and RunicPowerDeficit < 60)) then 
				return A.PillarofFrost:Show(icon)
			end	
			
			--actions.cooldowns+=/pillar_of_frost,if=talent.icecap.enabled&!buff.pillar_of_frost.up
			if A.PillarofFrost:IsReady(player) and A.Icecap:IsTalentLearned() and Unit(player):HasBuffs(A.PillarofFrost.ID, true) == 0 then
				return A.PillarofFrost:Show(icon)
			end	
			
			--actions.cooldowns+=/pillar_of_frost,if=talent.obliteration.enabled&(talent.gathering_storm.enabled&buff.remorseless_winter.up|!talent.gathering_storm.enabled)
			if A.PillarofFrost:IsReady(player) and A.Obliteration:IsTalentLearned() and ((A.GatheringStorm:IsTalentLearned() and Unit(player):HasBuffs(A.RemorselessWinter.ID, true) > 0) or not A.GatheringStorm:IsTalentLearned()) then
				return A.PillarofFrost:Show(icon)
			end	
			
			--actions.cooldowns+=/breath_of_sindragosa,if=buff.pillar_of_frost.up
			if A.BreathofSindragosa:IsReady(player) and A.BreathofSindragosa:IsTalentLearned() and Unit(player):HasBuffs(A.PillarofFrost.ID, true) > 0 then
				return A.BreathofSindragosa:Show(icon)
			end	
			
			--actions.cooldowns+=/frostwyrms_fury,if=buff.pillar_of_frost.remains<gcd&buff.pillar_of_frost.up&!talent.obliteration.enabled
			if A.FrostwyrmsFury:IsReady(player) and Unit(player):HasBuffs(A.PillarofFrost.ID, true) < A.GetGCD() and not A.Obliteration:IsTalentLearned() then
				return A.FrostwyrmsFury:Show(icon)
			end	
			
			--actions.cooldowns+=/frostwyrms_fury,if=active_enemies>=2&cooldown.pillar_of_frost.remains+15>target.time_to_die|fight_remains<gcd
			if A.FrostwyrmsFury:IsReady(player) and MultiUnits:GetByRange(15, 2) >= 2 and A.PillarofFrost:GetCooldown() + 15 > Player:AreaTTD(15) then
				return A.FrostwyrmsFury:Show(icon)
			end				
			--actions.cooldowns+=/frostwyrms_fury,if=talent.obliteration.enabled&!buff.pillar_of_frost.up&((buff.unholy_strength.up|!death_knight.runeforge.fallen_crusader)&(debuff.razorice.stack=5|!death_knight.runeforge.razorice))
			if A.FrostwyrmsFury:IsReady(player) and A.Obliteration:IsTalentLearned() and Unit(player):HasBuffs(A.PillarofFrost.ID, true) == 0 and ((Unit(player):HasBuffs(A.UnholyStrength.ID, true) > 0 or (mainHandEnchantment ~= "Rune of the Fallen Crusader" or offHandEnchantment ~= "Rune of the Fallen Crusader")) and (Unit(unit):HasDeBuffsStacks(A.RazoriceDebuff.ID, true) > 4 or (mainHandEnchantment ~= "Rune of Razorice" or offHandEnchantment ~= "Rune of Razorice"))) then
				return A.FrostwyrmsFury:Show(icon)
			end	
			
			--actions.cooldowns+=/hypothermic_presence,if=talent.breath_of_sindragosa.enabled&runic_power.deficit>40&rune>=3&buff.pillar_of_frost.up|!talent.breath_of_sindragosa.enabled&runic_power.deficit>=25
			if A.HypothermicPresence:IsReady(player) and A.HypothermicPresence:IsTalentLearned() and ((A.BreathofSindragosa:IsTalentLearned() and RunicPowerDeficit > 40 and Player:Rune() >= 3 and Unit(player):HasBuffs(A.PillarofFrost.ID, true) > 0) or (not A.BreathofSindragosa:IsTalentLearned() and RunicPowerDeficit >= 25)) then
				return A.HypothermicPresence:Show(icon)
			end	
			
			--actions.cooldowns+=/raise_dead,if=buff.pillar_of_frost.up		
			if A.RaiseDead:IsReady(player) and Unit(player):HasBuffs(A.PillarofFrost.ID, true) > 0 then
				return A.RaiseDead:Show(icon)
			end	
		
		end
	
		--#################################
		--##### OBLITERATION ROTATION #####
		--#################################

		local function ObliterationRotation()
		
			--actions.obliteration=remorseless_winter,if=talent.gathering_storm.enabled&active_enemies>=3
			if A.RemorselessWinter:IsReady(unit) and A.GatheringStorm:IsTalentLearned() and MultiUnits:GetByRange(8, 3) >= 3 then
				return A.RemorselessWinter:Show(icon)
			end	
			
			--actions.obliteration+=/howling_blast,if=!dot.frost_fever.ticking&!buff.killing_machine.up
			if A.HowlingBlast:IsReady(unit) and Unit(unit):HasDeBuffs(A.FrostFever.ID, true) == 0 and Unit(player):HasBuffs(A.KillingMachineBuff.ID, true) == 0 then
				return A.HowlingBlast:Show(icon)
			end	
			
			--actions.obliteration+=/frostscythe,if=buff.killing_machine.react&spell_targets.frostscythe>=2
			if A.Frostscythe:IsReady(player) and Unit(player):HasBuffs(A.KillingMachineBuff.ID, true) > 0 and MultiUnits:GetByRange(8, 2) >= 2 then
				return A.Frostscythe:Show(icon)
			end	
			
			--actions.obliteration+=/obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=buff.killing_machine.react|!buff.rime.up&spell_targets.howling_blast>=3
			if A.Obliterate:IsReady(unit) and ((Unit(unit):HasDeBuffs(A.RazoriceDebuff.ID, true) > 0 and Unit(player):HasBuffs(A.KillingMachineBuff.ID, true) > 0) or (Unit(player):HasBuffs(A.RimeBuff.ID, true) == 0 and MultiUnits:GetByRange(10, 3) >= 3)) then
				return A.Obliterate:Show(icon)
			end	
			
			--actions.obliteration+=/glacial_advance,if=spell_targets.glacial_advance>=2&(runic_power.deficit<10|rune.time_to_2>gcd)|(debuff.razorice.stack<5|debuff.razorice.remains<15)
			if A.GlacialAdvance:IsReady(player) and MultiUnits:GetByRange(15, 2) >= 2 and (RunicPowerDeficit < 10 or Player:RuneTimeToX(2) > A.GetGCD()) then
				return A.GlacialAdvance:Show(icon)
			end	
			
			--actions.obliteration+=/frost_strike,if=conduit.eradicating_blow.enabled&buff.eradicating_blow.stack=2&active_enemies=1
			if A.FrostStrike:IsReady(unit) and A.EradicatingBlow:IsSoulbindLearned() and Unit(player):HasBuffsStacks(A.EradicatingBlow.ID, true) == 2 and MultiUnits:GetByRange(10, 2) == 1 then
				return A.FrostStrike:Show(icon)
			end	
			
			--actions.obliteration+=/howling_blast,if=buff.rime.up&spell_targets.howling_blast>=2
			if A.HowlingBlast:IsReady(unit) and Unit(player):HasBuffs(A.RimeBuff.ID, true) > 0 and MultiUnits:GetByRange(10, 2) >= 2 then
				return A.HowlingBlast:Show(icon)
			end
			
			--actions.obliteration+=/glacial_advance,if=spell_targets.glacial_advance>=2
			if A.GlacialAdvance:IsReady(player) and MultiUnits:GetByRange(10, 2) >= 2 then
				return A.GlacialAdvance:Show(icon)
			end	
			--actions.obliteration+=/frost_strike,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice,if=runic_power.deficit<10|rune.time_to_2>gcd|!buff.rime.up
			if A.FrostStrike:IsReady(unit) and Unit(unit):HasDeBuffs(A.RazoriceDebuff.ID, true) == 0 and (RunicPowerDeficit < 10 or Player:RuneTimeToX(2) > A.GetGCD() or Unit(player):HasBuffs(A.RimeBuff.ID, true) == 0) then 
				return A.FrostStrike:Show(icon)
			end	
			
			--actions.obliteration+=/howling_blast,if=buff.rime.up
			if A.HowlingBlast:IsReady(unit) and Unit(player):HasBuffs(A.RimeBuff.ID, true) > 0 then
				return A.HowlingBlast:Show(icon)
			end	
			
			--actions.obliteration+=/obliterate,target_if=max:(debuff.razorice.stack+1)%(debuff.razorice.remains+1)*death_knight.runeforge.razorice
			if AutoSwitchRazorice and (mainHandEnchantment == "Rune of Razorice" or offHandEnchantment == "Rune of Razorice") and Unit(unit):HasDeBuffsStacks(A.RazoriceDebuff.ID, true) > 0 and RunicPower >= 20 and Player:AreaTTD(10) > 5 and currentTargets >= 2 and currentTargets <= 5 and (MissingRazorice > 0 and MissingRazorice < 5 or Unit(unit):IsDummy())
			then
				local Razorice_Nameplates = MultiUnits:GetActiveUnitPlates()
				if Razorice_Nameplates then  
					for Razorice_UnitID in pairs(Razorice_Nameplates) do             
						if Unit(Razorice_UnitID):GetRange() < 6 and InMelee(Razorice_UnitID) and not Unit(Razorice_UnitID):InLOS() and Unit(Razorice_UnitID):HasDeBuffsStacks(A.Razorice.ID, true) == 0 then 
							return A:Show(icon, ACTION_CONST_AUTOTARGET)
						end         
					end 
				end
			end				

		end
		
		--#############################
		--##### STANDARD ROTATION #####
		--#############################

		local function StandardRotation()
		
			--actions.standard=remorseless_winter,if=talent.gathering_storm.enabled|conduit.everfrost.enabled|runeforge.biting_cold.equipped
			if A.RemorselessWinter:IsReady(player) and (A.GatheringStorm:IsTalentLearned() or A.Everfrost:IsSoulbindLearned() or Player:HasLegendaryCraftingPower(A.BitingCold)) then
				return A.RemorselessWinter:Show(icon)
			end	
			
			--actions.standard+=/glacial_advance,if=!death_knight.runeforge.razorice&(debuff.razorice.stack<5|debuff.razorice.remains<7)
			if A.GlacialAdvance:IsReady(player) and (mainHandEnchantment ~= "Rune of Razorice" or offHandEnchantment ~= "Rune of Razorice") and (Unit(unit):HasDeBuffsStacks(A.RazoriceDebuff.ID, true) < 5 or Unit(unit):HasDeBuffs(A.RazoriceDebuff.ID, true) < 7) then
				return A.GlacialAdvance:Show(icon)
			end	
			
			--actions.standard+=/frost_strike,if=cooldown.remorseless_winter.remains<=2*gcd&talent.gathering_storm.enabled
			if A.FrostStrike:IsReady(unit) and A.RemorselessWinter:GetCooldown() <= (2 * A.GetGCD()) and A.GatheringStorm:IsTalentLearned() then
				return A.FrostStrike:Show(icon)
			end	
			
			--actions.standard+=/frost_strike,if=conduit.unleashed_frenzy.enabled&buff.unleashed_frenzy.remains<3|conduit.eradicating_blow.enabled&buff.eradicating_blow.stack=2
			if A.FrostStrike:IsReady(unit) and ((A.UnleasedFrenzy:IsSoulbindLearned() and Unit(player):HasBuffs(A.UnleasedFrenzy.ID, true) < 3) or (A.EradicatingBlow:IsSoulbindLearned() and Unit(player):HasBuffsStacks(A.EradicatingBlow.ID, true) == 2)) then
				return A.FrostStrike:Show(icon)
			end	
			
			--actions.standard+=/howling_blast,if=buff.rime.up
			if A.HowlingBlast:IsReady(unit) and Unit(player):HasBuffs(A.RimeBuff.ID, true) > 0 then
				return A.HowlingBlast:Show(icon)
			end	
			
			--actions.standard+=/obliterate,if=!buff.frozen_pulse.up&talent.frozen_pulse.enabled
			if A.Obliterate:IsReady(unit) and Unit(player):HasBuffs(A.FrozenPulse.ID, true) == 0 and A.FrozenPulse:IsTalentLearned() then
				return A.Obliterate:Show(icon)
			end	
			
			--actions.standard+=/frost_strike,if=runic_power.deficit<(15+talent.runic_attenuation.enabled*3)
			if A.FrostStrike:IsReady(unit) and RunicPowerDeficit < (15 + num(A.RunicAttenuation:IsTalentLearned()) * 3) then
				return A.FrostStrike:Show(icon)
			end	
			
			--actions.standard+=/frostscythe,if=buff.killing_machine.up&rune.time_to_4>=gcd
			if A.Frostscythe:IsReady(player) and Unit(player):HasBuffs(A.KillingMachineBuff.ID, true) > 0 and Player:RuneTimeToX(4) >= A.GetGCD() then
				return A.Frostscythe:Show(icon)
			end	
			
			--actions.standard+=/obliterate,if=runic_power.deficit>(25+talent.runic_attenuation.enabled*3)
			if A.Obliterate:IsReady(unit) and RunicPowerDeficit > (25 + num(A.RunicAttenuation:IsTalentLearned()) * 3) then
				return A.Obliterate:Show(icon)
			end
			
			--actions.standard+=/frost_strike
			if A.FrostStrike:IsReady(unit) then
				return A.FrostStrike:Show(icon)
			end	
			
			--actions.standard+=/horn_of_winter
			if A.HornofWinter:IsReady(player) then
				return A.HornofWinter:Show(icon)
			end	
			
			--actions.standard+=/arcane_torrent	
			if A.ArcaneTorrent:IsReady(player) and A.ArcaneTorrent:AutoRacial(player) then
				return A.ArcaneTorrent:Show(icon)
			end	
		
		end

		--###########################
		--##### ALWAYS ROTATION #####
		--###########################

		--actions+=/howling_blast,if=!dot.frost_fever.ticking&(talent.icecap.enabled|cooldown.breath_of_sindragosa.remains>15|talent.obliteration.enabled&cooldown.pillar_of_frost.remains<dot.frost_fever.remains)
		if A.HowlingBlast:IsReady(unit) and Unit(unit):HasDeBuffs(A.FrostFever.ID, true) == 0 and (A.Icecap:IsTalentLearned() or A.BreathofSindragosa:GetCooldown() > 15 or (A.Obliteration:IsTalentLearned() and A.PillarofFrost:GetCooldown() < Unit(unit):HasDeBuffs(A.FrostFever.ID, true))) then
			return A.HowlingBlast:Show(icon)
		end	
			
		--actions+=/glacial_advance,if=buff.icy_talons.remains<=gcd&buff.icy_talons.up&spell_targets.glacial_advance>=2&(!talent.breath_of_sindragosa.enabled|cooldown.breath_of_sindragosa.remains>15)
		if A.GlacialAdvance:IsReady(player) and Unit(player):HasBuffs(A.IcyTalons.ID, true) <= A.GetGCD() and Unit(player):HasBuffs(A.IcyTalons.ID, true) > 0 and MultiUnits:GetByRange(15, 2) >= 2 and (not A.BreathofSindragosa:IsTalentLearned() or not A.BurstIsON(unit) or (A.BurstIsON(unit) and A.BreathofSindragosa:GetCooldown() > 15)) then
			return A.GlacialAdvance:Show(icon)
		end	
		
		--actions+=/frost_strike,if=buff.icy_talons.remains<=gcd&buff.icy_talons.up&(!talent.breath_of_sindragosa.enabled|cooldown.breath_of_sindragosa.remains>15)
		if A.FrostStrike:IsReady(player) and Unit(player):HasBuffs(A.IcyTalons.ID, true) <= A.GetGCD() and Unit(player):HasBuffs(A.IcyTalons.ID, true) > 0 and (not A.BreathofSindragosa:IsTalentLearned() or not A.BurstIsON(unit) or (A.BurstIsON(unit) and A.BreathofSindragosa:GetCooldown() > 15)) then
			return A.FrostStrike:Show(icon)
		end	

		--actions+=/call_action_list,name=cooldowns
		if A.BurstIsON(unit) then
			if Cooldowns() then
				return true
			end
		end	
		
		--actions+=/call_action_list,name=essences
		
		--actions+=/call_action_list,name=cold_heart,if=talent.cold_heart.enabled&(buff.cold_heart.stack>=10&(debuff.razorice.stack=5|!death_knight.runeforge.razorice)|fight_remains<=gcd)
		if A.ColdHeart:IsTalentLearned() and (Unit(player):HasBuffsStacks(A.ColdHeartBuff.ID, true) >= 10 and (Unit(unit):HasDeBuffsStacks(A.RazoriceDebuff.ID, true) == 5 or (mainHandEnchantment ~= "Rune of Razorice" and offHandEnchantment ~= "Rune of Razorice") or Player:AreaTTD(10) <= A.GetGCD())) then
			if ColdHeartRotation() then
				return true
			end
		end
		
		--actions+=/run_action_list,name=bos_ticking,if=buff.breath_of_sindragosa.up
		if Unit(player):HasBuffs(A.BreathofSindragosa.ID, true) > 0 then
			if BoSTicking() then
				return true
			end
		end
		
		--actions+=/run_action_list,name=bos_pooling,if=talent.breath_of_sindragosa.enabled&(cooldown.breath_of_sindragosa.remains<10)
		if A.BreathofSindragosa:IsTalentLearned() and A.BreathofSindragosa:GetCooldown() < 10 then
			if BoSPooling() then
				return true
			end
		end
		
		--actions+=/run_action_list,name=obliteration,if=buff.pillar_of_frost.up&talent.obliteration.enabled
		if Unit(player):HasBuffs(A.PillarofFrost.ID, true) > 0 and A.Obliteration:IsTalentLearned() then
			if ObliterationRotation() then
				return true
			end
		end
		
		--actions+=/run_action_list,name=aoe,if=active_enemies>=2
		if MultiUnits:GetByRange(10, 2) >= 2 and UseAoE then
			if AoERotation() then
				return true
			end
		end
		
		--actions+=/call_action_list,name=standard
		if StandardRotation() then
			return true
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


