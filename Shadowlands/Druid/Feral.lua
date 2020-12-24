--#################################
--###### TRIP'S FERAL DRUID  ######
--#################################

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
local AuraIsValidByPhialofSerenity				= A.AuraIsValidByPhialofSerenity
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
local next, pairs, type, print                  = next, pairs, type, print
local wipe                                      = wipe 
local math_floor                                = math.floor
local math_ceil                                 = math.ceil
local tinsert                                   = table.insert 
local TMW                                       = TMW
local _G, setmetatable                          = _G, setmetatable
local select, unpack, table, pairs              = select, unpack, table, pairs 
local CombatLogGetCurrentEventInfo              = _G.CombatLogGetCurrentEventInfo
local UnitGUID, UnitIsUnit, UnitDamage, UnitAttackSpeed, UnitAttackPower = UnitGUID, UnitIsUnit, UnitDamage, UnitAttackSpeed, UnitAttackPower

--Toaster stuff
local Toaster																	= _G.Toaster
local GetSpellTexture 															= _G.TMW.GetSpellTexture

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

Action[ACTION_CONST_DRUID_FERAL] = {
    -- Racial
    ArcaneTorrent                           = Create({ Type = "Spell", ID = 50613		}),
    BloodFury                               = Create({ Type = "Spell", ID = 20572		}),
    Fireblood                               = Create({ Type = "Spell", ID = 265221		}),
    AncestralCall                           = Create({ Type = "Spell", ID = 274738		}),
    Berserking                              = Create({ Type = "Spell", ID = 26297		}),
    ArcanePulse                             = Create({ Type = "Spell", ID = 260364		}),
    QuakingPalm                             = Create({ Type = "Spell", ID = 107079      }),
    Haymaker                                = Create({ Type = "Spell", ID = 287712      }), 
    WarStomp                                = Create({ Type = "Spell", ID = 20549		}),
    BullRush                                = Create({ Type = "Spell", ID = 255654      }),  
    GiftofNaaru                             = Create({ Type = "Spell", ID = 59544		}),
    Shadowmeld                              = Create({ Type = "Spell", ID = 58984		}),
    Stoneform                               = Create({ Type = "Spell", ID = 20594		}), 
    BagofTricks                             = Create({ Type = "Spell", ID = 312411		}),
    WilloftheForsaken                       = Create({ Type = "Spell", ID = 7744		}),    
    EscapeArtist                            = Create({ Type = "Spell", ID = 20589		}),
    EveryManforHimself                      = Create({ Type = "Spell", ID = 59752		}), 

	-- Druid General
    Barkskin								= Action.Create({ Type = "Spell", ID = 22812	}),
    BearForm								= Action.Create({ Type = "Spell", ID = 5487		}),
    CatForm									= Action.Create({ Type = "Spell", ID = 768		}),
    MoonkinForm								= Action.Create({ Type = "Spell", ID = 197625	}),	
    Cyclone									= Action.Create({ Type = "Spell", ID = 33786	}),
    Dash									= Action.Create({ Type = "Spell", ID = 1850		}),
    Dreamwalk								= Action.Create({ Type = "Spell", ID = 193753	}),
    EntanglingRoots							= Action.Create({ Type = "Spell", ID = 339		}),	
    FerociousBite							= Action.Create({ Type = "Spell", ID = 22568	}),
    Growl									= Action.Create({ Type = "Spell", ID = 6795		}),	
    Hibernate								= Action.Create({ Type = "Spell", ID = 2637		}),
    Ironfur									= Action.Create({ Type = "Spell", ID = 192081	}),
    Mangle									= Action.Create({ Type = "Spell", ID = 33917	}),	
    Moonfire								= Action.Create({ Type = "Spell", ID = 8921		}),
    MoonfireDebuff                       	= Create({ Type = "Spell", ID = 164812, Hidden = true     }),	
    Prowl									= Action.Create({ Type = "Spell", ID = 5215		}),	
    Rebirth									= Action.Create({ Type = "Spell", ID = 20484	}),
    Regrowth								= Action.Create({ Type = "Spell", ID = 8936		}),
    Revive									= Action.Create({ Type = "Spell", ID = 50769	}),
    Shred									= Action.Create({ Type = "Spell", ID = 5221		}),	
    Soothe									= Action.Create({ Type = "Spell", ID = 2908		}),	
    StampedingRoar							= Action.Create({ Type = "Spell", ID = 106898	}),	
    TravelForm								= Action.Create({ Type = "Spell", ID = 783		}),	
    Wrath									= Action.Create({ Type = "Spell", ID = 5176		}),
	
	-- Feral Specific
    Berserk									= Action.Create({ Type = "Spell", ID = 106951	}),
    Maim									= Action.Create({ Type = "Spell", ID = 22570	}),
    Rake									= Action.Create({ Type = "Spell", ID = 1822		}),
    RakeDebuff                              = Action.Create({ Type = "Spell", ID = 155722, Hidden = true   }),	
    RemoveCorruption						= Action.Create({ Type = "Spell", ID = 2782		}),
    Rip										= Action.Create({ Type = "Spell", ID = 1079		}),
    RipDebuff                               = Action.Create({ Type = "Spell", ID = 1079, Hidden = true     }),	
    SkullBash								= Action.Create({ Type = "Spell", ID = 106839	}),
    SurvivalInstincts						= Action.Create({ Type = "Spell", ID = 61336	}),
    Swipe									= Action.Create({ Type = "Spell", ID = 213764	}),
    SwipeBear								= Action.Create({ Type = "Spell", ID = 213771	}),	
    Thrash									= Action.Create({ Type = "Spell", ID = 106832	}),
    ThrashBear								= Action.Create({ Type = "Spell", ID = 77758	}),	
    ThrashDebuff                         	= Action.Create({ Type = "Spell", ID = 106830, Hidden = true   }),	
    TigersFury								= Action.Create({ Type = "Spell", ID = 5217		}),
    Clearcasting	                        = Action.Create({ Type = "Spell", ID = 135700, Hidden = true     }),
    PredatorySwiftness						= Action.Create({ Type = "Spell", ID = 69369, Hidden = true     }),
	
	-- Balance Affinity
    Starfire								= Action.Create({ Type = "Spell", ID = 197628	}),
    Starsurge								= Action.Create({ Type = "Spell", ID = 197626	}),
    Sunfire									= Action.Create({ Type = "Spell", ID = 197630	}),
    Typhoon									= Action.Create({ Type = "Spell", ID = 132469	}),	
	
	-- Guardian Affinity
    FrenziedRegeneration					= Action.Create({ Type = "Spell", ID = 22842	}),
    IncapacitatingRoar						= Action.Create({ Type = "Spell", ID = 99		}),		
	
	-- Restoration Affinity
    Rejuvenation							= Action.Create({ Type = "Spell", ID = 774		}),
    Swiftmend								= Action.Create({ Type = "Spell", ID = 18562	}),
    WildGrowth								= Action.Create({ Type = "Spell", ID = 48438	}),
    UrsolsVortex							= Action.Create({ Type = "Spell", ID = 102793	}),	
	
	-- Normal Talents
    Predator								= Action.Create({ Type = "Spell", ID = 202021	}),
    Sabertooth								= Action.Create({ Type = "Spell", ID = 202031	}),
    LunarInspiration						= Action.Create({ Type = "Spell", ID = 155580	}),
    MoonfireCat								= Action.Create({ Type = "Spell", ID = 155625	}),	
    TigerDash								= Action.Create({ Type = "Spell", ID = 252216	}),
    Renewal									= Action.Create({ Type = "Spell", ID = 108238	}),
    WildCharge								= Action.Create({ Type = "Spell", ID = 102401	}),
    BalanceAffinity							= Action.Create({ Type = "Spell", ID = 197488	}),
    GuardianAffinity						= Action.Create({ Type = "Spell", ID = 217615	}),	
    RestorationAffinity						= Action.Create({ Type = "Spell", ID = 197492	}),
    MightyBash								= Action.Create({ Type = "Spell", ID = 5211		}),
    MassEntanglement						= Action.Create({ Type = "Spell", ID = 102359	}),
    HeartoftheWild							= Action.Create({ Type = "Spell", ID = 319454	}),
    SouloftheForest							= Action.Create({ Type = "Spell", ID = 158476	}),
    SavageRoar								= Action.Create({ Type = "Spell", ID = 52610	}),
    Incarnation								= Action.Create({ Type = "Spell", ID = 102543	}),
    ScentofBlood							= Action.Create({ Type = "Spell", ID = 285564	}),	
    BrutalSlash								= Action.Create({ Type = "Spell", ID = 202028	}),
    PrimalWrath								= Action.Create({ Type = "Spell", ID = 285381	}),	
    MomentofClarity							= Action.Create({ Type = "Spell", ID = 236068	}),
    Bloodtalons								= Action.Create({ Type = "Spell", ID = 319439	}),	
    BloodtalonsBuff							= Action.Create({ Type = "Spell", ID = 145152	}),		
    FeralFrenzy								= Action.Create({ Type = "Spell", ID = 274837	}),	

	-- PvP Talents
    Thorns									= Action.Create({ Type = "Spell", ID = 305497	}),							

	-- AntiFake icons
	WildChargeRed							= Action.Create({ Type = "SpellSingleColor", ID = 102401, Color = "RED", Desc = "[1] CC Focus"}), 
	MightyBashGreen							= Action.Create({ Type = "SpellSingleColor", ID = 5211, Color = "GREEN", Desc = "[1] CC Focus", isTalent = true}), 
	CycloneFocus							= Action.Create({ Type = "Spell", ID = 33786, Desc = "[1] CC Focus", isTalent = true}), 
	SkullBashGreen							= Action.Create({ Type = "SpellSingleColor", ID = 106839, Color = "GREEN", Desc = "[2] Kick", QueueForbidden = true}),	

	-- Covenant Abilities
    SummonSteward							= Action.Create({ Type = "Spell", ID = 324739	}),
    DoorofShadows							= Action.Create({ Type = "Spell", ID = 300728	}),
    Fleshcraft								= Action.Create({ Type = "Spell", ID = 331180	}),
    Soulshape								= Action.Create({ Type = "Spell", ID = 310143	}),
    Flicker									= Action.Create({ Type = "Spell", ID = 324701	}),
	RavenousFrenzy							= Action.Create({ Type = "Spell", ID = 323546 	}),
	KindredSpirits							= Action.Create({ Type = "Spell", ID = 326434, Texture = 338041	}),
	LoneEmpowerment							= Action.Create({ Type = "Spell", ID = 338142, Texture = 338041	}),
	KindredEmpowerment						= Action.Create({ Type = "Spell", ID = 327022, Texture = 338041	}),	
	AdaptiveSwarm							= Action.Create({ Type = "Spell", ID = 325727 	}),
	ConvoketheSpirits						= Action.Create({ Type = "Spell", ID = 323764 	}),	

	-- Conduits

	
	-- Legendaries
	-- General Legendaries

	-- Feral Legendaries
	

	-- Anima Powers - to add later...
	
	
	-- Trinkets
	

	-- Potions
    PotionofUnbridledFury					= Action.Create({ Type = "Potion", ID = 169299, QueueForbidden = true }), 	
    SuperiorPotionofUnbridledFury			= Action.Create({ Type = "Potion", ID = 168489, QueueForbidden = true }),
    PotionofSpectralAgility					= Action.Create({ Type = "Potion", ID = 171270, QueueForbidden = true }),
    PotionofSpectralStamina					= Action.Create({ Type = "Potion", ID = 171274, QueueForbidden = true }),
    PotionofEmpoweredExorcisms				= Action.Create({ Type = "Potion", ID = 171352, QueueForbidden = true }),
    PotionofHardenedShadows					= Action.Create({ Type = "Potion", ID = 171271, QueueForbidden = true }),
    PotionofPhantomFire						= Action.Create({ Type = "Potion", ID = 171349, QueueForbidden = true }),
    PotionofDeathlyFixation					= Action.Create({ Type = "Potion", ID = 171351, QueueForbidden = true }),
    SpiritualHealingPotion					= Action.Create({ Type = "Item", ID = 171267, QueueForbidden = true }),
	AbyssalHealingPotion					= Action.Create({ Type = "Item", ID = 169451, QueueForbidden = true }),
	PhialofSerenity							= Action.Create({ Type = "Item", ID = 177278 }),
	
    -- Misc
    Channeling                   	   		= Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),    -- Show an icon during channeling
    TargetEnemy             		        = Action.Create({ Type = "Spell", ID = 44603, Hidden = true     }),    -- Change Target (Tab button)
    StopCast                  		      	= Action.Create({ Type = "Spell", ID = 61721, Hidden = true     }),        -- spell_magic_polymorphrabbit
    PoolResource              		      	= Action.Create({ Type = "Spell", ID = 209274, Hidden = true     }),
	Quake 									= Action.Create({ Type = "Spell", ID = 240447, Hidden = true     }), -- Quake (Mythic Plus Affix)

}

local A = setmetatable(Action[ACTION_CONST_DRUID_FERAL], { __index = Action })

local function num(val)
    if val then return 1 else return 0 end
end

local function bool(val)
    return val ~= 0
end

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
	AuraForOnlyCCAndStun					= {"CCTotalImun", "StunImun"},
}

local IsIndoors, UnitIsUnit, UnitName = IsIndoors, UnitIsUnit, UnitName
local player = "player"
local target = "target"

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
    return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "NATURE") == 0
end 

local function InMelee(unitID)
    return A.Rake:IsInRange(unitID)
end 

local function countInterruptGCD(unit)
    if not A.SkullBash:IsReadyByPassCastGCD(unit) or not A.SkullBash:AbsentImun(unit, Temp.TotalAndPhysKick) then
	    return true
	end
end

local function Interrupts(unit)

    useKick, useCC, useRacial, notInterruptable, castRemainsTime, castDoneTime = Action.InterruptIsValid(unit, nil, nil, countInterruptGCD(unit))
    
	if castRemainsTime >= A.GetLatency() then
        if useKick and A.SkullBash:IsReady(unit) and A.SkullBash:AbsentImun(unit, Temp.TotalAndPhysKick, true) then 
            return A.SkullBash
        end         

        if useCC and A.MightyBash:IsReady(unit) and A.MightyBash:IsTalentLearned() and A.MightyBash:AbsentImun(unit, Temp.TotalAndPhysKick, true) then 
            return A.MightyBash
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
    
    -- FrenziedRegeneration
    local FrenziedRegeneration = A.GetToggle(2, "FrenziedRegeneration")
    if     FrenziedRegeneration >= 0 and A.FrenziedRegeneration:IsReady(player) and Unit(player):HasBuffs(A.BearForm) > 0 and A.GuardianAffinity:IsTalentLearned() and 
    (
        (     -- Auto 
            FrenziedRegeneration >= 100 and 
            (
                -- HP lose per sec >= 10
                Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 10 or 
                Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.10 or 
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
            FrenziedRegeneration < 100 and 
            Unit(player):HealthPercent() <= FrenziedRegeneration
        )
    ) 
    then 
        -- Notification                    
        A.Toaster:SpawnByTimer("TripToast", 0, "Frenzied Regeneration!", "Using Frenzied Regeneration!", A.FrenziedRegeneration.ID)
        return A.FrenziedRegeneration
    end
    
    -- SurvivalInstincts
    local SurvivalInstincts = A.GetToggle(2, "SurvivalInstincts")
    if     SurvivalInstincts >= 0 and A.SurvivalInstincts:IsReady(player) and 
    (
        (     -- Auto 
            SurvivalInstincts >= 100 and 
            (
                -- HP lose per sec >= 10
                Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 10 or 
                Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.10 or 
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
            SurvivalInstincts < 100 and 
            Unit(player):HealthPercent() <= SurvivalInstincts
        )
    ) 
    then 
        -- Notification                    
        A.Toaster:SpawnByTimer("TripToast", 0, "Survival Instincts!", "Using Survival Instincts!", A.SurvivalInstincts.ID)
        return A.SurvivalInstincts
    end
	
    -- Barkskin
    local Barkskin = A.GetToggle(2, "Barkskin")
    if     Barkskin >= 0 and A.Barkskin:IsReady(player) and 
    (
        (     -- Auto 
            Barkskin >= 100 and 
            (
                -- HP lose per sec >= 10
                Unit(player):GetDMG() * 100 / Unit(player):HealthMax() >= 10 or 
                Unit(player):GetRealTimeDMG() >= Unit(player):HealthMax() * 0.10 or 
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
            Barkskin < 100 and 
            Unit(player):HealthPercent() <= Barkskin
        )
    ) 
    then 
        -- Notification                    
        A.Toaster:SpawnByTimer("TripToast", 0, "Barkskin!", "Using Barkskin!", A.Barkskin.ID)
        return A.Barkskin
    end	

	if not Player:IsStealthed() then 	
		-- Healthstone | AbyssalHealingPotion
		local Healthstone = GetToggle(1, "HealthStone") 
		if Healthstone >= 0 then 
			if A.HS:IsReady(player) then 					
				if Healthstone >= 100 then -- AUTO 
					if Unit(player):TimeToDie() <= 9 and Unit(player):HealthPercent() <= 40 then
						A.Toaster:SpawnByTimer("TripToast", 0, "Healthstone!", "Using Healthstone!", A.HS.ID)						
						return A.HS
					end 
				elseif Unit(player):HealthPercent() <= Healthstone then 
					A.Toaster:SpawnByTimer("TripToast", 0, "Healthstone!", "Using Healthstone!", A.HS.ID)				
					return A.HS							 
				end
			elseif A.Zone ~= "arena" and (A.Zone ~= "pvp" or not A.InstanceInfo.isRated) and A.SpiritualHealingPotion:IsReady(player) then 
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
		if A.Zone ~= "arena" and (A.Zone ~= "pvp" or not A.InstanceInfo.isRated) and A.PhialofSerenity:IsReady(player) then 
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
        return A.AbyssalHealingPotion
    end 
    
    -- Stoneform on self dispel (only PvE)
    if A.Stoneform:IsRacialReady("player", true) and not A.IsInPvP and A.AuraIsValid("player", "UseDispel", "Dispel") then 
        return A.Stoneform
    end 
    
    
end 
SelfDefensives = A.MakeFunctionCachedStatic(SelfDefensives)

-- [1] CC Focus AntiFake Rotation
A[1] = function(icon)  
	local unitID = "focus"
	
	if A.WildCharge:IsSpellLearned() and A.MightyBashGreen:IsSpellLearned() and A.MightyBashGreen:GetCooldown() == 0 and Unit(unitID):GetRange() >= 8 and Unit(unitID):GetRange() <= 28
	and A.WildChargeRed:IsReady(unitID) then
		return A.WildChargeRed:Show(icon)
	end
	
	 if A.MightyBashGreen:IsReady(unitID) and A.MightyBashGreen:AbsentImun(unitID, Temp.TotalAndPhysAndCCAndStun) and 
	 Unit(unitID):IsControlAble("stun", 0) and A.IsUnitEnemy(unitID) then
		return A.MightyBashGreen:Show(icon)
	 end
	 
	 if A.CycloneFocus:IsReady(unitID) and A.MightyBash:GetCooldown() > 0 then
		return A.CycloneFocus:Show(icon)
	 end
end

-- [2] Kick AntiFake Rotation
A[2] = function(icon)	
	-- Note: This will ignore energy check!
	local unitID
	if A.IsUnitEnemy("target") then 
		unitID = "target"	
	end 
			
	if unitID then 		
		local castLeft, _, _, _, notKickAble = Unit(unitID):IsCastingRemains()
		if castLeft > 0 then 
			-- Kick 
			if not notKickAble and A.SkullBashGreen:IsReady(unit, nil, nil, true) and A.SkullBashGreen:AbsentImun(unitID, Temp.TotalAndPhysKick) then 
				return A.SkullBashGreen:Show(icon)	
			end 
		end 
	end 																		
end

A[3] = function(icon)

	--Function remaps
	local isMoving = A.Player:IsMoving()
	local isMovingFor = A.Player:IsMovingTime()
    local inCombat = Unit(player):CombatTime() > 0
    local Energy = Player:Energy()
    local EnergyRegen = Player:EnergyRegen()
	local EnergyDeficit = Player:EnergyDeficit()
	local ComboPoints = Player:ComboPoints()
	local ComboPointsDeficit = Player:ComboPointsDeficit()
	local InMelee = InMelee()
	
	--Toggle remaps
	local UseAoE = A.GetToggle(2, "AoE")
	local UseCovenant = A.GetToggle(1, "Covenant")
	local AutoCatForm = A.GetToggle(2, "AutoCatForm")
	local RegrowthProcs = A.GetToggle(2, "RegrowthProcs")
    local FrenziedRegeneration = A.GetToggle(2, "FrenziedRegeneration")
	local PrimalWrathTargets = A.GetToggle(2, "PrimalWrathTargets")

	--Variables
	VarNoBT = (A.Rake:GetSpellTimeSinceLastCast() > 4 and A.MoonfireCat:GetSpellTimeSinceLastCast() > 4 and A.Thrash:GetSpellTimeSinceLastCast() > 4 and A.BrutalSlash:GetSpellTimeSinceLastCast() > 4 and A.Swipe:GetSpellTimeSinceLastCast() > 4 and A.Shred:GetSpellTimeSinceLastCast() > 4)

	VarTwoBT = (A.Rake:GetSpellTimeSinceLastCast() > 4 and A.Thrash:GetSpellTimeSinceLastCast() > 4) or (A.Rake:GetSpellTimeSinceLastCast() > 4 and A.Swipe:GetSpellTimeSinceLastCast() > 4) or (A.Rake:GetSpellTimeSinceLastCast() > 4 and A.Shred:GetSpellTimeSinceLastCast() > 4) or (A.Rake:GetSpellTimeSinceLastCast() > 4 and A.MoonfireCat:GetSpellTimeSinceLastCast() > 4) or (A.Rake:GetSpellTimeSinceLastCast() > 4 and A.BrutalSlash:GetSpellTimeSinceLastCast() > 4) or (A.Thrash:GetSpellTimeSinceLastCast() > 4 and A.Swipe:GetSpellTimeSinceLastCast() > 4) or (A.Thrash:GetSpellTimeSinceLastCast() > 4 and A.Shred:GetSpellTimeSinceLastCast() > 4) or (A.Thrash:GetSpellTimeSinceLastCast() > 4 and A.MoonfireCat:GetSpellTimeSinceLastCast() > 4) or (A.Thrash:GetSpellTimeSinceLastCast() > 4 and A.BrutalSlash:GetSpellTimeSinceLastCast() > 4) or (A.Swipe:GetSpellTimeSinceLastCast() > 4 and A.Shred:GetSpellTimeSinceLastCast() > 4)	

	local function EnemyRotation()

	local RakeRefreshable = Unit(unitID):HasDeBuffs(A.RakeDebuff.ID, true) < 4
	local MoonfireRefreshable = Unit(unitID):HasDeBuffs(A.MoonfireDebuff.ID, true) < 4
	local ThrashRefreshable = Unit(unitID):HasDeBuffs(A.Thrash.ID, true) < 4
	local RipRefreshable = Unit(unitID):HasDeBuffs(A.RipDebuff.ID, true) < 7
	
	local drTick, drDuration = Unit(unitID):GetDR("stun")
	
	--[[###############################
		###### BLOODTALONS LOGIC ######
		###############################]]

		local function BloodtalonsRotation()

			--actions.bloodtalons=rake,target_if=(!ticking|(refreshable&persistent_multiplier>dot.rake.pmultiplier))&buff.bt_rake.down&druid.rake.ticks_gained_on_refresh>=2
			if A.Rake:IsReady(unitID) and RakeRefreshable and A.Rake:GetSpellTimeSinceLastCast() > 4 then
				return A.Rake:Show(icon)
			end	
			
			--actions.bloodtalons+=/lunar_inspiration,target_if=refreshable&buff.bt_moonfire.down
			if A.MoonfireCat:IsReady(unitID) and A.LunarInspiration:IsTalentLearned() and MoonfireRefreshable and A.MoonfireCat:GetSpellTimeSinceLastCast() > 4 then
				return A.MoonfireCat:Show(icon)
			end
			
			--actions.bloodtalons+=/thrash_cat,target_if=refreshable&buff.bt_thrash.down&druid.thrash_cat.ticks_gained_on_refresh>8
			if A.Thrash:IsReady(player) and ThrashRefreshable and A.Thrash:GetSpellTimeSinceLastCast() > 4 then
				return A.Thrash:Show(icon)
			end	 
			
			--actions.bloodtalons+=/brutal_slash,if=buff.bt_brutal_slash.down
			if A.BrutalSlash:IsReady(player) and A.BrutalSlash:GetSpellTimeSinceLastCast() > 4 then
				return A.BrutalSlash:Show(icon)
			end
			
			--actions.bloodtalons+=/swipe_cat,if=buff.bt_swipe.down&spell_targets.swipe_cat>1
			if A.Swipe:IsReady(player) and (MultiUnits:GetByRange(8, 2) > 1) and A.Swipe:GetSpellTimeSinceLastCast() > 4 then
				return A.Swipe:Show(icon)
			end
			
			--actions.bloodtalons+=/shred,if=buff.bt_shred.down
			if A.Shred:IsReady(unitID) and A.Shred:GetSpellTimeSinceLastCast() > 4 then
				return A.Shred:Show(icon)
			end	
			
			--actions.bloodtalons+=/swipe_cat,if=buff.bt_swipe.down
			if A.Swipe:IsReady(player) and A.Swipe:GetSpellTimeSinceLastCast() > 4 then
				return A.Swipe:Show(icon)
			end
			
			--actions.bloodtalons+=/thrash_cat,if=buff.bt_thrash.down
			if A.Thrash:IsReady(player) and A.Thrash:GetSpellTimeSinceLastCast() > 4 then
				return A.Thrash:Show(icon)
			end

		end	

		--[[###############################
			######     COOLDOWNS     ######
			###############################]]
		
		local function Cooldowns()

			--actions.cooldown=berserk,if=combo_points>=3
			if A.Berserk:IsReady(player) and ComboPoints >= 3 then
				return A.Berserk:Show(icon)
			end
			
			--actions.cooldown+=/incarnation,if=combo_points>=3
			if A.Incarnation:IsReady(player) and ComboPoints >= 3 then
				return A.Incarnation:Show(icon)
			end
					

			--actions.cooldown+=/berserking,if=buff.tigers_fury.up|buff.bs_inc.up
			if A.Berserking:IsReady(player) and (Unit(player):HasBuffs(A.TigersFury.ID, true) > 0 or (Unit(player):HasBuffs(A.Berserk.ID, true) > 0 or Unit(player):HasBuffs(A.Incarnation.ID, true) > 0)) then
				return A.Berserking:Show(icon)
			end
			
			--actions.cooldown+=/ravenous_frenzy,if=buff.bs_inc.up|fight_remains<21
			if A.RavenousFrenzy:IsReady(player) and UseCovenant and ((Unit(player):HasBuffs(A.Berserk.ID, true) > 0 or Unit(player):HasBuffs(A.Incarnation.ID, true) > 0) or (Unit(unitID):IsBoss() and Unit(unitID):TimeToDie() < 21)) then
				return A.RavenousFrenzy:Show(icon)
			end
			
			--actions.cooldown+=/convoke_the_spirits,if=(dot.rip.remains>4&combo_points<3&dot.rake.ticking)|fight_remains<5
			if A.ConvoketheSpirits:IsReady(unitID) and UseCovenant and (not RipRefreshable and ComboPoints < 3 and not RakeRefreshable or (Unit(unitID):IsBoss() and Unit(unitID):TimeToDie() < 5)) then
				return A.ConvoketheSpirits:Show(icon)
			end
			
			--actions.cooldown+=/kindred_spirits,if=buff.tigers_fury.up|(conduit.deep_allegiance.enabled)
			if (A.LoneEmpowerment:IsReady(player) or A.KindredEmpowerment:IsReady(player)) and UseCovenant and Unit(player):HasBuffs(A.TigersFury.ID, true) > 0 then --or A.DeepAllegiance:IsSoulbindLearned()) then
				return A.KindredSpirits:Show(icon)
			end
			
			--actions.cooldown+=/adaptive_swarm,target_if=max:time_to_die*(combo_points=5&!dot.adaptive_swarm_damage.ticking)
			if A.AdaptiveSwarm:IsReady(unitID) and UseCovenant and Player:ComboPoints() > 4 then
				return A.AdaptiveSwarm:Show(icon)
			end	
			
			--Trinket 1
			if A.Trinket1:IsReady(unitID) then
				return A.Trinket1:Show(icon)    
			end
			
			--Trinket 2
			if A.Trinket2:IsReady(unitID) then
				return A.Trinket2:Show(icon)    
			end
			
		end

		--[[###############################
			######      FILLER       ######
			###############################]]

		local function Filler()

			--actions.filler=rake,target_if=variable.filler=1&dot.rake.pmultiplier<=persistent_multiplier
			if A.Rake:IsReady(unitID) and RakeRefreshable then
				return A.Rake:Show(icon)
			end
			
			--actions.filler+=/rake,if=variable.filler=2
			
			
			--actions.filler+=/lunar_inspiration,if=variable.filler=3
			if A.MoonfireCat:IsReady(unitID) and A.LunarInspiration:IsTalentLearned() and MoonfireRefreshable then
				return A.MoonfireCat:Show(icon)
			end
			
			--actions.filler+=/swipe,if=variable.filler=4
			if A.Swipe:IsReady(player) and (MultiUnits:GetByRange(8) > 2) then
				return A.Swipe:Show(icon)
			end
			--actions.filler+=/shred
			if A.Shred:IsReady(unitID) then
				return A.Shred:Show(icon)
			end

		end

		--[[###############################
			######     FINISHER      ######
			###############################]]
			
		local function Finisher()


			--actions.finisher=savage_roar,if=buff.savage_roar.down|buff.savage_roar.remains<(combo_points*6+1)*0.3
			if A.SavageRoar:IsReady(unitID) and (Unit(player):HasBuffs(A.SavageRoarBuff.ID, true) == 0 or Unit(player):HasBuffs(A.SavageRoarBuff.ID, true) < (((Player:ComboPoints() * 6) + 1) * 0.3)) then
				return A.SavageRoar:Show(icon)
			end

			--actions.finisher+=/primal_wrath,if=druid.primal_wrath.ticks_gained_on_refresh>(variable.rip_ticks>?variable.best_rip)|spell_targets.primal_wrath>(3+1*talent.sabertooth.enabled)
			if A.PrimalWrath:IsReady(player) and A.PrimalWrath:IsTalentLearned() and RipRefreshable and MultiUnits:GetByRange(8, 5) >= PrimalWrathTargets then
				return A.PrimalWrath:Show(icon)
			end
			
			--actions.finisher+=/rip,target_if=(!ticking|(remains+combo_points*talent.sabertooth.enabled)<duration*0.3|dot.rip.pmultiplier<persistent_multiplier)&druid.rip.ticks_gained_on_refresh>variable.rip_ticks
			if A.Rip:IsReady(unitID) and (not A.PrimalWrath:IsTalentLearned() or MultiUnits:GetByRange(8, 5) < PrimalWrathTargets) and RipRefreshable and Unit(unitID):TimeToDie() > 5 then
				return A.Rip:Show(icon)
			end
			
			--actions.finisher+=/ferocious_bite,max_energy=1,target_if=max:time_to_die
			if A.FerociousBite:IsReady(unitID) then
				return A.FerociousBite:Show(icon)
			end

		end



	--[[###############################
		######BEGIN ACTION CALLS ######
		###############################]]

		--actions=cat_form,if=buff.cat_form.down
		if A.CatForm:IsReady(player) and Unit(player):HasBuffs(A.CatForm.ID, true) == 0 and AutoCatForm and ((Unit(player):HasBuffs(A.FrenziedRegeneration.ID) == 0 and A.FrenziedRegeneration:GetCooldown() > 0) or Unit(player):HealthPercent() >= 80) then 
			return A.CatForm:Show(icon)
		end
		
		--actions+=/prowl
		if A.Prowl:IsReady(player) and not inCombat and Unit(player):HasBuffs(A.Prowl.ID, true) == 0 and not Player:IsMounted() and not Player:IsStealthed() then
			return A.Prowl:Show(icon)
		end

		-- Purge (high) 
		if unitID ~= "targettarget" and A.Soothe:IsReady(unitID, nil, nil, true) and A.Soothe:AbsentImun(unitID, Temp.AuraForOnlyCCAndStun) and A.AuraIsValid(unitID, "UseExpelEnrage", "Enrage") then 
			return A.Soothe:Show(icon)
		end 

		--Regrowth
		if A.Regrowth:IsReady(player) and RegrowthProcs and Unit(player):HealthPercent() <= 90 and Unit(player):HasBuffs(A.PredatorySwiftness.ID, true) > 0 and not Player:IsStealthed() then
			return A.Regrowth:Show(icon)
		end
		
		--Bear Form for Frenzied Regeneration
		if A.BearForm:IsReady(player) and Unit(player):HealthPercent() <= FrenziedRegeneration and Unit(player):HasBuffs(A.BearForm.ID, true) == 0 and A.GuardianAffinity:IsTalentLearned() then
			return A.BearForm:Show(icon)
		end

		--Botched Bear Form rotation so we don't just do nothing during regen
		if Unit(player):HasBuffs(A.BearForm.ID, true) > 0 then
		
			if A.FrenziedRegeneration:IsReady(player) and Unit(player):HealthPercent() <= FrenziedRegeneration + 5 then
				return A.FrenziedRegeneration:Show(icon)
			end
		
			if A.ThrashBear:IsReady(player) and Unit(unitID):GetRange() <= 5 then
				return A.ThrashBear:Show(icon)
			end
			
			if A.SwipeBear:IsReady(player) and MultiUnits:GetByRange(5, 2) >= 2 then
				return A.SwipeBear:Show(icon)
			end
		
			if A.Mangle:IsReady(unitID) then
				return A.Mangle:Show(icon)
			end
		
		end

		--actions.cooldown+=/tigers_fury,if=energy.deficit>55|buff.bs_inc.up|(talent.predator.enabled&variable.shortest_ttd<3)
				--Try and not waste TF energy, but also just use it for zerk and incarns
		if A.TigersFury:IsReady(player) and (EnergyDeficit > 55 or (Unit(player):HasBuffs(A.Berserk.ID, true) > 0 or Unit(player):HasBuffs(A.Incarnation.ID, true) > 0) or (A.Predator:IsTalentLearned() and Unit(unitID):TimeToDie() < 3)) then
			return A.TigersFury:Show(icon)
		end 

		--actions.precombat+=/variable,name=filler,value=1
		if A.Rake:IsReady(unitID) and not inCombat then
			return A.Rake:Show(icon)
		end

		--STUN PVP 
		if A.IsInPvP then 	
			if A.MightyBash:IsReady(unitID) and A.MightyBash:AbsentImun(unitID, Temp.TotalAndPhysAndCCAndStun) and Unit(unitID):IsControlAble("stun", 50) and 
			(A.Berserk:IsReady(player) or A.FeralFrenzy:IsReady(unitID) or EnemyTeam("HEALER"):GetCC() >= A.GetGCD() * 3) and Unit(unitID):HasBuffs("DeffBuffs") == 0 then
				return A.MightyBash:Show(icon)
			end
			
			if A.Maim:IsReady(unitID) and A.Maim:AbsentImun(unitID, Temp.TotalAndPhysAndCCAndStun) and Unit(unitID):IsControlAble("stun", 50) and Unit(unitID):HasDeBuffs("Stuned") == 0 and 
			ComboPoints > 3 then
				return A.Maim:Show(icon)
			end
			
		end

		--actions+=/call_action_list,name=cooldown
		if BurstIsON(unitID) and inCombat and Cooldowns() and InMelee then
			return true
		end	
		
		--actions+=/run_action_list,name=finisher,if=combo_points>=(5-variable.4cp_bite)
		if ComboPoints >= 5 and Unit(player):HasBuffs(A.Prowl.ID, true) == 0 then
			if Finisher() then
				return true
			end
		end

		--actions+=/run_action_list,name=stealth,if=buff.bs_inc.up|buff.sudden_ambush.up

		--actions+=/pool_resource,if=talent.bloodtalons.enabled&buff.bloodtalons.down&(energy+3.5*energy.regen+(40*buff.clearcasting.up))<(115-23*buff.incarnation_king_of_the_jungle.up)&active_bt_triggers=0
		if A.Bloodtalons:IsTalentLearned() and Unit(player):HasBuffs(A.BloodtalonsBuff.ID, true) == 0 and (Energy + (3.5 * EnergyRegen) + (40 * num(Unit(player):HasBuffs(A.Clearcasting.ID, true) > 0))) < (115 - 23 * num(Unit(player):HasBuffs(A.Incarnation.ID, true) > 0)) and VarNoBT then	
			return A.PoolResource:Show(icon)
		end

		--actions+=/run_action_list,name=bloodtalons,if=talent.bloodtalons.enabled&(buff.bloodtalons.down|active_bt_triggers=2)
		if A.Bloodtalons:IsTalentLearned() and (Unit(player):HasBuffs(A.BloodtalonsBuff.ID, true) == 0 or VarTwoBT) and InMelee then
			if BloodtalonsRotation() then
				return true
			end
		end
		
		--actions+=/rake,target_if=refreshable|persistent_multiplier>dot.rake.pmultiplier
		if A.Rake:IsReady(unitID) and RakeRefreshable and A.LastPlayerCastName ~= A.FeralFrenzy:Info() and Unit(player):HasBuffs(A.BloodtalonsBuff.ID, true) == 0 then
			return A.Rake:Show(icon)
		end

		--actions+=/feral_frenzy,if=combo_points=0
		if A.FeralFrenzy:IsReady(unitID) and ComboPoints < 3 and not Player:IsStealthed() then
			return A.FeralFrenzy:Show(icon)
		end

		--actions+=/moonfire_cat,target_if=refreshable
		if A.MoonfireCat:IsReady(unitID) and A.LunarInspiration:IsTalentLearned() and MoonfireRefreshable and A.LastPlayerCastName ~= A.FeralFrenzy:Info() and Unit(player):HasBuffs(A.BloodtalonsBuff.ID, true) == 0 and not Player:IsStealthed() then
			return A.MoonfireCat:Show(icon)
		end

		--actions+=/thrash_cat,if=refreshable&druid.thrash_cat.ticks_gained_on_refresh>variable.thrash_ticks
		if A.Thrash:IsReady(player) and ThrashRefreshable and Unit(unitID):GetRange() <= 5 and A.LastPlayerCastName ~= A.FeralFrenzy:Info() and Unit(player):HasBuffs(A.BloodtalonsBuff.ID, true) == 0 and InMelee and not Player:IsStealthed() then
			return A.Thrash:Show(icon)
		end

		--actions+=/brutal_slash,if=(buff.tigers_fury.up&(raid_event.adds.in>(1+max_charges-charges_fractional)*recharge_time))&(spell_targets.brutal_slash*action.brutal_slash.damage%action.brutal_slash.cost)>(action.shred.damage%action.shred.cost)

		--actions+=/swipe_cat,if=spell_targets.swipe_cat>2
		if A.Swipe:IsReady(player) and MultiUnits:GetByRange(8, 2) > 2 and A.LastPlayerCastName ~= A.FeralFrenzy:Info() and Unit(player):HasBuffs(A.BloodtalonsBuff.ID, true) == 0 and InMelee and not Player:IsStealthed() then
			return A.Swipe:Show(icon)
		end
		
		--actions+=/shred,if=buff.clearcasting.up
		if A.Shred:IsReady(unitID) and Unit(player):HasBuffs(A.Clearcasting.ID, true) > 0 and A.LastPlayerCastName ~= A.FeralFrenzy:Info() and Unit(player):HasBuffs(A.BloodtalonsBuff.ID, true) == 0 then
			return A.Shred:Show(icon)
		end
		
		--actions+=/call_action_list,name=filler
		if inCombat and IsUnitEnemy(unitID) and A.LastPlayerCastName ~= A.FeralFrenzy:Info() and Unit(player):HasBuffs(A.BloodtalonsBuff.ID, true) == 0 and InMelee then
			if Filler() then
				return true
			end
		end

	end
		EnemyRotation = A.MakeFunctionCachedDynamic(EnemyRotation)     

	
    -- Defensive
    local SelfDefensive = SelfDefensives()
    if SelfDefensive and inCombat then 
        return SelfDefensive:Show(icon)
    end 

    -- Mouseover
    if A.IsUnitEnemy("mouseover") then
        unitID = "mouseover"
        if EnemyRotation(unitID) then 
            return true 
        end 
    end 

    -- Target  
    if A.IsUnitEnemy("target") then 
        unitID = "target"
        if EnemyRotation(unitID) then 
            return true
        end 

    end
end

--[[ local function ArenaRotation(icon, unitID)
    if A.IsInPvP and (A.Zone == "pvp" or A.Zone == "arena") and not Player:IsStealthed() and not Player:IsMounted() then     
		--Dispell Enrage
		if unitID ~= "targettarget" and A.Soothe:IsReady(unitID, nil, nil, true) and A.Soothe:AbsentImun(unitID, Temp.AuraForOnlyCCAndStun) and A.AuraIsValid(unitID, "UseExpelEnrage", "Enrage") then 
			return A.Soothe:Show(icon)
		end 
		
		--Root
		if A.EntanglingRoots:IsReady(unitID) and A.EntanglingRoots:AbsentImun(unitID, Temp.AuraForDisableMag) and not UnitIsUnit(unitID, "target") and 
		Unit(unitID):IsMelee() and (Unit(unitID):HasBuffs("DamageBuffs") > 0 or Unit(unitID):GetDMG() == 0) and Unit(player):HasBuffs(A.PredatorySwiftnessBuff.ID, true) > 0 and 
		Unit(unitID):HasBuffs("Reflect") == 0 then
			return A.EntanglingRoots:Show(icon)
		end
		
		
		if Player:ComboPoints() == Player:ComboPointsMax() then
			if A.Rip:IsReady(unitID) and A.Rip:AbsentImun(unitID, Temp.TotalAndPhys) and Unit(unitID):HasDeBuffs(A.RipDebuff.ID, true) <= A.GetGCD() + A.GetCurrentGCD() and 
			Unit(unitID):TimeToDie() > 4 then --and Unit("target"):TimeToDie() > 10 and Unit("target"):HasDeBuffs("Stuned") == 0 then
				return A.Rip:Show(icon)
			end
		end
		
		if Player:ComboPoints() < Player:ComboPointsMax() then
			if A.Rake:IsReady(unitID) and A.Rake:AbsentImun(unitID, Temp.TotalAndPhys) and Unit(unitID):HasDeBuffs(A.RakeDebuff.ID, true, true) <= A.GetGCD() + A.GetCurrentGCD() and
			Unit(unitID):TimeToDie() > 4 then-- and Unit("target"):TimeToDie() > 10 and Unit("target"):HasDeBuffs("Stuned") == 0 then
				return A.Rake:Show(icon)
			end
		end
	end
end

local function PartyRotation(unitID) 
	-- Dispel 
    if A.RemoveCorruption:IsReady(unitID) and A.RemoveCorruption:AbsentImun(unitID) and A.AuraIsValid(unitID, "UseDispel", "Dispel") and not Unit(unitID):InLOS() then                         
        return A.RemoveCorruption
    end    
	
	local ThornsHP = A.GetToggle(2, "ThornsPvP")
	if A.IsInPvP and A.Thorns:IsReady(unitID) and A.Thorns:AbsentImun(unitID) and Unit(unitID):IsFocused("MELEE") and Unit(unitID):HealthPercent() <= ThornsHP and not Unit(unitID):InLOS() then
		return A.Thorns
    end
	
end 

A[6] = function(icon)    
	local ThornsHP	= A.GetToggle(2, "ThornsPvP")
	if A.IsInPvP and A.Thorns:IsReady(player) and A.Thorns:AbsentImun(player) and Unit(player):IsFocused("MELEE") and Unit(player):HealthPercent() <= ThornsHP then
		return A.Thorns:Show(icon)
	end

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
end]]
