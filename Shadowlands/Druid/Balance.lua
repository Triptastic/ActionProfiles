--###################################
--###### TRIP'S BALANCE DRUID  ######
--###################################

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
local TeamCache                               = Action.TeamCache
local TeamCacheFriendly                       = TeamCache.Friendly
local ActiveUnitPlates							= MultiUnits:GetActiveUnitPlates()
local IsIndoors, UnitIsUnit                     = IsIndoors, UnitIsUnit
local HealingEngine                           = Action.HealingEngine
local HealingEngineMembersALL                 = HealingEngine.GetMembersAll()
local pairs                                     = pairs
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

Action[ACTION_CONST_DRUID_BALANCE] = {
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
    Darkflight								= Create({ Type = "Spell", ID = 68992    }),	

	-- Druid General
    Barkskin								= Action.Create({ Type = "Spell", ID = 22812	}),
    BearForm								= Action.Create({ Type = "Spell", ID = 5487		}),
    CatForm									= Action.Create({ Type = "Spell", ID = 768		}),
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
    MoonfireDebuff                       	= Action.Create({ Type = "Spell", ID = 164812, Hidden = true     }),	
    Prowl									= Action.Create({ Type = "Spell", ID = 5215		}),	
    Rebirth									= Action.Create({ Type = "Spell", ID = 20484	}),
    Regrowth								= Action.Create({ Type = "Spell", ID = 8936		}),
    Revive									= Action.Create({ Type = "Spell", ID = 50769	}),
    Shred									= Action.Create({ Type = "Spell", ID = 5221		}),	
    Soothe									= Action.Create({ Type = "Spell", ID = 2908		}),	
    StampedingRoar							= Action.Create({ Type = "Spell", ID = 106898	}),	
    TravelForm								= Action.Create({ Type = "Spell", ID = 783		}),	
	
	-- Balance Specific
    CelestialAlignment						= Action.Create({ Type = "Spell", ID = 194223	}),  
    Innervate								= Action.Create({ Type = "Spell", ID = 29166	}),  	
    MoonkinForm								= Action.Create({ Type = "Spell", ID = 24858	}),
    RemoveCorruption						= Action.Create({ Type = "Spell", ID = 2782		}), 
    SolarBeam								= Action.Create({ Type = "Spell", ID = 78675	}), 
    Starfall								= Action.Create({ Type = "Spell", ID = 191034	}), 
    Starfire								= Action.Create({ Type = "Spell", ID = 194153	}), 
    Starsurge								= Action.Create({ Type = "Spell", ID = 78674	}),
    Sunfire									= Action.Create({ Type = "Spell", ID = 93402	}),
    Typhoon									= Action.Create({ Type = "Spell", ID = 132469	}),  
    Wrath									= Action.Create({ Type = "Spell", ID = 190984	}),    	
    LunarEclipse							= Action.Create({ Type = "Spell", ID = 48518	}),	
    SolarEclipse							= Action.Create({ Type = "Spell", ID = 48517	}),	
	
	-- Restoration Affinity
    Rejuvenation							= Action.Create({ Type = "Spell", ID = 774		}),
    Swiftmend								= Action.Create({ Type = "Spell", ID = 18562	}),
    WildGrowth								= Action.Create({ Type = "Spell", ID = 48438	}),		
    UrsolsVortex							= Action.Create({ Type = "Spell", ID = 102793	}),	
	
	-- Guardian Affinity
    FrenziedRegeneration					= Action.Create({ Type = "Spell", ID = 22842	}),
    IncapacitatingRoar						= Action.Create({ Type = "Spell", ID = 99		}),	
    ThrashBear								= Action.Create({ Type = "Spell", ID = 106832	}),	
	
	-- Feral Affinity
    Rake									= Action.Create({ Type = "Spell", ID = 1822		}),
    RakeDebuff                              = Action.Create({ Type = "Spell", ID = 155722, Hidden = true   }),		
    Rip										= Action.Create({ Type = "Spell", ID = 1079		}),
    SwipeCat								= Action.Create({ Type = "Spell", ID = 213764	}),
    Maim									= Action.Create({ Type = "Spell", ID = 22570	}),	
	
	-- Normal Talents
    NaturesBalance							= Action.Create({ Type = "Spell", ID = 202430	}),
    WarriorofElune							= Action.Create({ Type = "Spell", ID = 202425	}),
    ForceofNature							= Action.Create({ Type = "Spell", ID = 205636	}),	
    TigerDash								= Action.Create({ Type = "Spell", ID = 252216	}),
    Renewal									= Action.Create({ Type = "Spell", ID = 108238	}),
    WildCharge								= Action.Create({ Type = "Spell", ID = 102401	}),
    FeralAffinity							= Action.Create({ Type = "Spell", ID = 202157	}),
    GuardianAffinity						= Action.Create({ Type = "Spell", ID = 197491	}),
    RestorationAffinity						= Action.Create({ Type = "Spell", ID = 197492	}),
    MightyBash								= Action.Create({ Type = "Spell", ID = 5211		}),
    MassEntanglement						= Action.Create({ Type = "Spell", ID = 102359	}),	
    HeartoftheWild							= Action.Create({ Type = "Spell", ID = 319454	}),	
    SouloftheForest							= Action.Create({ Type = "Spell", ID = 114107	}),
    Starlord								= Action.Create({ Type = "Spell", ID = 202345	}),
    Incarnation								= Action.Create({ Type = "Spell", ID = 102560	}),
    StellarDrift							= Action.Create({ Type = "Spell", ID = 202354, Hidden = true	}),
    TwinMoons								= Action.Create({ Type = "Spell", ID = 279620	}),
    StellarFlare							= Action.Create({ Type = "Spell", ID = 202347	}),
    Solstice								= Action.Create({ Type = "Spell", ID = 343647	}),
    FuryofElune								= Action.Create({ Type = "Spell", ID = 202770	}),
    NewMoon									= Action.Create({ Type = "Spell", ID = 274281	}),	
    HalfMoon								= Action.Create({ Type = "Spell", ID = 274282	}),
    FullMoon								= Action.Create({ Type = "Spell", ID = 274283	}),	

	-- PvP Talents
	

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
    PotionofSpectralIntellect				= Action.Create({ Type = "Potion", ID = 171273, QueueForbidden = true }),
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

local A = setmetatable(Action[ACTION_CONST_DRUID_BALANCE], { __index = Action })

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
}

local IsIndoors, UnitIsUnit, UnitName = IsIndoors, UnitIsUnit, UnitName
local player = "player"
local target = "target"
local mouseover = "mouseover"


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

	-- BearForm 
	if A.BearForm:IsReady(player) and Unit(player):HasBuffs(A.BearForm) > 0 and Unit(player):HasDeBuffs("Rooted") > 0 then
		return A.BearForm
	end
    
    --[[ FrenziedRegeneration
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
	
    -- Renewal
    local Renewal = A.GetToggle(2, "Renewal")
    if     Renewal >= 0 and A.Renewal:IsReady(player) and 
    (
        (     -- Auto 
            Renewal >= 100 and 
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
            Renewal < 100 and 
            Unit(player):HealthPercent() <= Renewal
        )
    ) 
    then 
        -- Notification                    
        A.Toaster:SpawnByTimer("TripToast", 0, "Renewal!", "Using Renewal!", A.Renewal.ID)
        return A.Renewal
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
    end ]]
    
    
end 
SelfDefensives = A.MakeFunctionCachedStatic(SelfDefensives)

A[3] = function(icon, isMulti)

	--Function remaps
	local isMoving = A.Player:IsMoving()
	local isMovingFor = A.Player:IsMovingTime()
    local inCombat = Unit(player):CombatTime() > 0
	
	local InMoonkinForm = Unit(player):HasBuffs(A.MoonkinForm.ID, true) > 0
	local InBearForm = Unit(player):HasBuffs(A.BearForm.ID, true) > 0
	local InCatForm = Unit(player):HasBuffs(A.CatForm.ID, true) > 0	
	local InNoForm = Unit(player):HasBuffs(A.MoonkinForm.ID, true) == 0 and Unit(player):HasBuffs(A.BearForm.ID, true) == 0 and Unit(player):HasBuffs(A.CatForm.ID, true) == 0
	
	local SolarEclipse = Unit(player):HasBuffs(A.SolarEclipse.ID, true) > 0 or A.Wrath:GetSpellCharges() >= 1
	local LunarEclipse = Unit(player):HasBuffs(A.LunarEclipse.ID, true) > 0 or A.Starfire:GetSpellCharges() >= 1
	local NoEclipse = Unit(player):HasBuffs(A.SolarEclipse.ID, true) == 0 and Unit(player):HasBuffs(A.LunarEclipse.ID, true) == 0
	
	local ComboPoints = Player:ComboPoints()
	local Mana = Player:ManaPercentage()
	
	--Toggle remaps
	local AutoShift = A.GetToggle(2, "AutoShift")
	local UseDispel = A.GetToggle(2, "UseDispel")
	local UseCovenant = A.GetToggle(1, "Covenant")


	local function DamageRotation()

	local MoonfireRefreshable = Unit(unitID):HasDeBuffs(A.MoonfireDebuff.ID, true) < 4.8
	local SunfireRefreshable = Unit(unitID):HasDeBuffs(A.Sunfire.ID, true) < 4
	local RipRefreshable = Unit(unitID):HasDeBuffs(A.Rip.ID, true) < 7
	local RakeRefreshable = Unit(unitID):HasDeBuffs(A.RakeDebuff.ID, true) < 4

		if A.MoonkinForm:IsReady(player) and not InMoonkinForm and AutoShift then
			return A.MoonkinForm:Show(icon)
		end
		
		if A.Moonfire:IsReady(unitID) and MoonfireRefreshable then
			return A.Moonfire:Show(icon)
		end

		if A.Sunfire:IsReady(unitID) and SunfireRefreshable then
			return A.Sunfire:Show(icon)
		end
		
		if SolarEclipse then
			if A.Wrath:IsReady(unitID) then
				return A.Wrath:Show(icon)
			end
		end
		
		if LunarEclipse then
			if A.Starfire:IsReady(unitID) then
				return A.Starfire:Show(icon)
			end
		end
	
	end


    -- Defensive
    local SelfDefensive = SelfDefensives()
    if SelfDefensive then 
        return SelfDefensive:Show(icon)
    end 
	
    -- Enemy Mouseover 
    if A.IsUnitEnemy(mouseover) then 
        unitID = mouseover	
		
        if DamageRotation(unitID) then 
            return true 
        end 
    end 
    
    -- DPS Target     
    if A.IsUnitEnemy(target) then 
        unitID = target
        
        if DamageRotation(unitID) then 
            return true 
        end 
    end 

end

