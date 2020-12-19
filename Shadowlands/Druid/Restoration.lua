--#######################################
--###### TRIP'S RESTORATION DRUID  ######
--#######################################

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

Action[ACTION_CONST_DRUID_RESTORATION] = {
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
    MoonfireDebuff                       	= Action.Create({ Type = "Spell", ID = 164812, Hidden = true     }),	
    Prowl									= Action.Create({ Type = "Spell", ID = 5215		}),	
    Rebirth									= Action.Create({ Type = "Spell", ID = 20484	}),
    Regrowth								= Action.Create({ Type = "Spell", ID = 8936		}),
    Revive									= Action.Create({ Type = "Spell", ID = 50769	}),
    Shred									= Action.Create({ Type = "Spell", ID = 5221		}),	
    Soothe									= Action.Create({ Type = "Spell", ID = 2908		}),	
    StampedingRoar							= Action.Create({ Type = "Spell", ID = 106898	}),	
    TravelForm								= Action.Create({ Type = "Spell", ID = 783		}),	
    Wrath									= Action.Create({ Type = "Spell", ID = 5176		}),
	
	-- Restoration Specific
    Efflorescence							= Action.Create({ Type = "Spell", ID = 145205	}),
    Innervate								= Action.Create({ Type = "Spell", ID = 29166	}),	
    Ironbark								= Action.Create({ Type = "Spell", ID = 102342	}),
    Lifebloom								= Action.Create({ Type = "Spell", ID = 33763	}),
    DarkTitan								= Action.Create({ Type = "Spell", ID = 188550	}),	
    NaturesCure								= Action.Create({ Type = "Spell", ID = 88423	}),	
    Rejuvenation							= Action.Create({ Type = "Spell", ID = 774		}),
    Revitalize								= Action.Create({ Type = "Spell", ID = 212040	}),	
    Sunfire									= Action.Create({ Type = "Spell", ID = 93402	}),	
    Swiftmend								= Action.Create({ Type = "Spell", ID = 18562	}),	
    Tranquility								= Action.Create({ Type = "Spell", ID = 740		}),
    UrsolsVortex							= Action.Create({ Type = "Spell", ID = 102793	}),
    WildGrowth								= Action.Create({ Type = "Spell", ID = 48438	}),
    NaturesSwiftness						= Action.Create({ Type = "Spell", ID = 132158	}),
    ClearCasting							= Action.Create({ Type = "Spell", ID = 16870,    Hidden = true }),	
	
	-- Balance Affinity
    Starfire								= Action.Create({ Type = "Spell", ID = 197628	}),
    Starsurge								= Action.Create({ Type = "Spell", ID = 197626	}),
    Typhoon									= Action.Create({ Type = "Spell", ID = 132469	}),	
    LunarEclipse							= Action.Create({ Type = "Spell", ID = 48518	}),	
    SolarEclipse							= Action.Create({ Type = "Spell", ID = 48517	}),		
	
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
    Abundance								= Action.Create({ Type = "Spell", ID = 207383	}),
    Nourish									= Action.Create({ Type = "Spell", ID = 50464	}),
    CenarionWard							= Action.Create({ Type = "Spell", ID = 102351	}),
    TigerDash								= Action.Create({ Type = "Spell", ID = 252216	}),	
    Renewal									= Action.Create({ Type = "Spell", ID = 108238	}),
    WildCharge								= Action.Create({ Type = "Spell", ID = 102401	}),	
    BalanceAffinity							= Action.Create({ Type = "Spell", ID = 197632, Hidden = true	}),	
    FeralAffinity							= Action.Create({ Type = "Spell", ID = 197490, Hidden = true	}),
    GuardianAffinity						= Action.Create({ Type = "Spell", ID = 197491, Hidden = true	}),	
    MightyBash								= Action.Create({ Type = "Spell", ID = 5211		}),
    MassEntanglement						= Action.Create({ Type = "Spell", ID = 102359	}),
    HeartoftheWild							= Action.Create({ Type = "Spell", ID = 319454	}),
    SouloftheForest							= Action.Create({ Type = "Spell", ID = 158478, Hidden = true	}),	
    SouloftheForestBuff						= Action.Create({ Type = "Spell", ID = 114108, Hidden = true	}),		
    Cultivation								= Action.Create({ Type = "Spell", ID = 200390, Hidden = true	}),	
    Incarnation								= Action.Create({ Type = "Spell", ID = 33891	}),	
    IncarnationBuff							= Action.Create({ Type = "Spell", ID = 117679, Hidden = true	}),		
    InnerPeace								= Action.Create({ Type = "Spell", ID = 197073, Hidden = true	}),
    SpringBlossoms							= Action.Create({ Type = "Spell", ID = 207385, Hidden = true	}),	
    Overgrowth								= Action.Create({ Type = "Spell", ID = 203651	}),
    Photosynthesis							= Action.Create({ Type = "Spell", ID = 274902, Hidden = true	}),	
    Germination								= Action.Create({ Type = "Spell", ID = 155675, Hidden = true	}),
	RejuvenationGerm						= Action.Create({ Type = "Spell", ID = 155777   }),	
    Flourish								= Action.Create({ Type = "Spell", ID = 197721	}),	

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

local A = setmetatable(Action[ACTION_CONST_DRUID_RESTORATION], { __index = Action })

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
local focus = "focus"
local targettarget = "targettarget"

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

local function CanAoEFlourish(pHP)   
    local total = 0
    local getmembersAll = HealingEngine.GetMembersAll()
    
    for i = 1, #getmembersAll do
        if getmembersAll[i].HP <= pHP and
        -- Rejuvenation
        Unit(getmembersAll[i].Unit):HasBuffs(774) > 0 and 
        (
            -- Wild Growth
            Unit(getmembersAll[i].Unit):HasBuffs(48438, true) > 0 or 
            -- Lifebloom or Regrowth or Germination
            Unit(getmembersAll[i].Unit):HasBuffs({33763, 8936, 155777}, true) > 0 
        )
        then
            total = total + 1
        end
    end
    return total >= #getmembersAll * 0.3
end 

local function ActiveLifebloomOnTank()
    local CurrentTanks = HealingEngine.GetMembersByMode("TANK")
	local total = 0
	for i = 1, #CurrentTanks do 
	    if Unit(CurrentTanks[i].Unit):HasBuffs(A.Lifebloom.ID, player, true) > 0 then
            total = total + 1
        end
	end
    return total
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
    end 
    
    
end 
SelfDefensives = A.MakeFunctionCachedStatic(SelfDefensives)

A[3] = function(icon, isMulti)

	--Function remaps
	local isMoving = A.Player:IsMoving()
	local isMovingFor = A.Player:IsMovingTime()
    local inCombat = Unit(player):CombatTime() > 0
	local inParty = TeamCache.Friendly.Size <= 5
	local inRaid = TeamCache.Friendly.Size > 5
	local ActiveLifebloomOnTank = ActiveLifebloomOnTank()
	local EfflorescenceActive = A.Efflorescence:GetSpellTimeSinceLastCast() < 30
	local Emergency = HealingEngine.GetBelowHealthPercentUnits(25, 40) >= 1
	local getmembersAll = HealingEngine.GetMembersAll()
	
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
	local DarkTitan = A.GetToggle(2, "DarkTitan")
	local EfflorescenceOnSelf = A.GetToggle(2, "EfflorescenceOnSelf")

	-- Don't cancel Tranquility
    local CanCast = true
    local secondsLeft, percentLeft, spellID, spellName, notInterruptable, isChannel = Unit(player):IsCastingRemains()	
    if inCombat and (spellID == A.Tranquility.ID) then 
        if secondsLeft > 0 + A.GetPing() then
            CanCast = false
        else
            CanCast = true
        end
    end
    if not CanCast then
        return A.PoolResource:Show(icon)
    end  

	local function DamageRotation()

	local MoonfireRefreshable = Unit(unitID):HasDeBuffs(A.MoonfireDebuff.ID, true) < Unit(unitID):HasDeBuffs(A.Sunfire.ID, true) and Unit(unitID):TimeToDie() > 5
	local SunfireRefreshable = Unit(unitID):HasDeBuffs(A.Sunfire.ID, true) < 2 and Unit(unitID):TimeToDie() > 5
	local RipRefreshable = Unit(unitID):HasDeBuffs(A.Rip.ID, true) < 7 and Unit(unitID):TimeToDie() > 5
	local RakeRefreshable = Unit(unitID):HasDeBuffs(A.RakeDebuff.ID, true) < 4 and Unit(unitID):TimeToDie() > 5

		if A.IsUnitEnemy(target) then
			if HealingEngine.GetBelowHealthPercentUnits(50, 40) >= 1 or (Unit(focus):HealthPercent() < 80 and Unit(focus):IsExists() and Unit(focus):HasBuffs(A.Lifebloom.ID, true) == 0 and Unit(focus):HasBuffs(A.Rejuvenation.ID, true) == 0) then
				return A.Darkflight:Show(icon)
			end
		end

		if A.Moonfire:IsReady(unitID) and MoonfireRefreshable then
			return A.Moonfire:Show(icon)
		end
		
		if A.Sunfire:IsReady(unitID) and SunfireRefreshable then
			return A.Sunfire:Show(icon)
		end
	
		if AutoShift then
			if A.MoonkinForm:IsReady(player) and A.BalanceAffinity:IsTalentLearned() and not InMoonkinForm then
				return A.MoonkinForm:Show(icon)
			end
			
			if A.CatForm:IsReady(player) and A.FeralAffinity:IsTalentLearned() and Unit(unitID):HasDeBuffs(A.MoonfireDebuff.ID, true) > 6 and Unit(unitID):HasDeBuffs(A.Sunfire.ID, true) > 6  and not InCatForm and Unit(unitID):GetRange() <= 7 then
				return A.CatForm:Show(icon)
			end
		end
	
		-- Balance Affinity Rotation
		if A.BalanceAffinity:IsTalentLearned() and InMoonkinForm then

			-- Nature's Swiftness
			if A.NaturesSwiftness:IsReady(unitID) and HealingEngine.GetBelowHealthPercentUnits(80, 40) >= 1 then
				return A.NaturesSwiftness:Show(icon)
			end

            if A.HeartoftheWild:IsReady(unitID) and not MoonfireRefreshable and not SunfireRefreshable and BurstIsON(unitID) then
                return A.HeartoftheWild:Show(icon)
            end

			if A.ConvoketheSpirits:IsReady(player) and UseCovenant and BurstIsON(unitID) then
				return A.ConvoketheSpirits:Show(icon)
			end

			if A.Starsurge:IsReady(unitID) then
				return A.Starsurge:Show(icon)
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
			
			if NoEclipse then
				if A.Wrath:IsReady(unitID) then
					return A.Wrath:Show(icon)
				end
			end
		
		end
		
		-- Feral Affinity Rotation
		if A.FeralAffinity:IsTalentLearned() and InCatForm then

			if A.NaturesSwiftness:IsReady(unitID) and HealingEngine.GetBelowHealthPercentUnits(80, 40) >= 1 then
				return A.NaturesSwiftness:Show(icon)
			end

            if A.HeartoftheWild:IsReady(unitID) and not MoonfireRefreshable and not SunfireRefreshable and BurstIsON(unitID) then
                return A.HeartoftheWild:Show(icon)
            end

			if A.ConvoketheSpirits:IsReady(player) and UseCovenant and BurstIsON(unitID) then
				return A.ConvoketheSpirits:Show(icon)
			end
			
			if A.Rake:IsReady(unitID) and A.Rake:AbsentImun(unitID, Temp.TotalAndPhys, true) and A.Rake:IsSpellInRange(unit) and RakeRefreshable then
				return A.Rake:Show(icon)
			end 
			
			if A.Rip:IsReady(unitID) and A.Rip:AbsentImun(unitID, Temp.TotalAndPhys, true) and ComboPoints > 4 and RipRefreshable then
				return A.Rip:Show(icon)
			end                 
			
			if A.FerociousBite:IsReady(unitID) and ComboPoints > 4 then
				return A.FerociousBite:Show(icon)
			end                            
			
			if A.SwipeCat:IsReady(unitID) and MultiUnits:GetByRange(3, 8) then
				return A.SwipeCat:Show(icon)
			end               
			
			if A.Shred:IsReady(unitID) then
				return A.Shred:Show(icon)
			end  				
				
		end
	
		-- In case we get stuck in Bear Form
		if InBearForm then
		
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
	
		-- If no shifting
		if A.Wrath:IsReady(unitID) and InNoForm then
			return A.Wrath:Show(icon)
		end
	
	end
	DamageRotation = Action.MakeFunctionCachedDynamic(DamageRotation) 
	
	local function HealingRotation()
	local HoTActive = (Unit(unitID):HasBuffs(A.Rejuvenation.ID, player, true) > 0 or Unit(unitID):HasBuffs(A.WildGrowth.ID, player, true) > 0 or Unit(unitID):HasBuffs(A.Regrowth.ID, player, true) > 0)
	local AllHoTsActive = (Unit(unitID):HasBuffs(A.Rejuvenation.ID, player, true) > 0 and Unit(unitID):HasBuffs(A.WildGrowth.ID, player, true) > 0 and Unit(unitID):HasBuffs(A.Regrowth.ID, player, true) > 0)
	local HoTExpiring = (Unit(unitID):HasBuffs(A.Rejuvenation.ID, player, true) > 0 and Unit(unitID):HasBuffs(A.Rejuvenation.ID, player, true) < 3) or (Unit(unitID):HasBuffs(A.WildGrowth.ID, player, true) > 0 and Unit(unitID):HasBuffs(A.Rejuvenation.ID, player, true) < 3) or (Unit(unitID):HasBuffs(A.Regrowth.ID, player, true) > 0 and Unit(unitID):HasBuffs(A.Rejuvenation.ID, player, true) < 3)	
	
		-- Set Tank as Focus
		if A.IsUnitFriendly(target) and not Unit(focus):IsExists() and Unit(target):IsTank() then
			return A.Shadowmeld:Show(icon)
		end
	
		-- Dispel Sniper 
		if A.NaturesCure:IsReady() and UseDispel and CanCast then
			for i = 1, #getmembersAll do 
				if Unit(getmembersAll[i].Unit):GetRange() <= 40 and AuraIsValid(getmembersAll[i].Unit, "UseDispel", "Dispel") then  
					HealingEngine.SetTarget(getmembersAll[i].Unit)                                                          
				end                
			end
		end
		
		-- General Dispel
		if UseDispel and CanCast and A.NaturesCure:IsReady(unitID) and AuraIsValid(target, "UseDispel", "Dispel") then
			return A.NaturesCure:Show(icon)
		end  

		-- Cenarion Ward
		if A.CenarionWard:IsReady(unitID) and CanCast and Unit(unitID):IsTanking() then
			return A.CenarionWard:Show(icon)
		end

		-- Convoke as healing
		if A.ConvoketheSpirits:IsReady(player) and UseCovenant and CanCast and inCombat and InNoForm and inCombat and Unit(player):HasBuffs(A.Innervate.ID, true) == 0 and Unit(player):HasBuffs(A.IncarnationBuff.ID, true) == 0 then
			if inParty then
				if HealingEngine.GetHealthAVG() < 80 then
					return A.ConvoketheSpirits:Show(icon)
				end
			end
			
			if inRaid then
				if HealingEngine.GetHealthAVG() < 90 then
					return A.ConvoketheSpirits:Show(icon)
				end
			end
		end	
		
		-- Emergency Incarnation
		if A.Incarnation:IsReady(player) and inCombat and CanCast and Unit(player):HasBuffs(A.IncarnationBuff.ID, true) == 0 then
			if inParty then
				if HealingEngine.GetHealthAVG() < 30 then
					return A.Incarnation:Show(icon)
				end
			end
			
			if inRaid then
				if HealingEngine.GetTimeToDieUnits(5) <= 2 then
					return A.Incarnation:Show(icon)
				end
			end
		end
		
		-- Tranquility
		if A.Tranquility:IsReady(player) and inCombat and CanCast then
			if inParty then
				if HealingEngine.GetHealthAVG() < 40 then
					return A.Tranquility:Show(icon)
				end
			end
			
			if inRaid then
				if HealingEngine.GetHealthAVG() < 60 then
					return A.Tranquility:Show(icon)
				end
			end
		end


		-- Flourish 
		if A.Flourish:IsReady(player) and Unit(player):CombatTime() > 10 and CanAoEFlourish(70) then
			return A.Flourish:Show(icon)
		end

		-- Innervate
		if A.Innervate:IsReady(player) and inCombat and CanCast then
			if inParty then
				if HealingEngine.GetHealthAVG() < 30 and Mana < 15 then
					return A.Innervate:Show(icon)
				end
			end
			
			if inRaid then
				if HealingEngine.GetHealthAVG() < 40 then
					return A.Innervate:Show(icon)
				end
			end
		end		
		
		-- Ironbark
		if A.Ironbark:IsReady(unit) and Unit(player):CombatTime() > 5 and CanCast and Unit(unitID):HealthPercent() <= 40 and Unit(unitID):IsTanking() then
			return A.Ironbark:Show(icon)
		end

		-- Swiftmend HoT snipe
		if A.Swiftmend:IsReady(unitID) and CanCast and Unit(unitID):HealthPercent() <= 85 and HoTExpiring then
			return A.Swiftmend:Show(icon)
		end

		-- Swiftmend Emergency
		if A.Swiftmend:IsReady(unitID) and CanCast and Unit(unitID):HealthPercent() <= 50 and HoTActive then
			return A.Swiftmend:Show(icon)
		end
           
		-- Wild Growth
		if A.WildGrowth:IsReady(unitID) and CanCast and not isMoving then
			if inParty then
				if HealingEngine.GetBelowHealthPercentUnits(85, 30) >= 3 then
					return A.WildGrowth:Show(icon)
				end
			end
				
			if inRaid then
				if HealingEngine.GetBelowHealthPercentUnits(85, 30) >= 5 then
					return A.WildGrowth:Show(icon)
				end
			end
			
			if Unit(player):HasBuffs(A.Innervate.ID, true) > 0 then
				return A.WildGrowth:Show(icon)
			end
		end

		-- Lifebloom
		if A.Lifebloom:IsReady(unitID) and CanCast and not DarkTitan and HealingEngine.GetBuffsCount(A.Lifebloom.ID, 1, player) == 0 then
			HealingEngine.SetTarget("TANK", 0.5)
			return A.Lifebloom:Show(icon)
		end
		
		-- Dark Titan
		if A.DarkTitan:IsReady(unitID) and CanCast and DarkTitan and A.Photosynthesis:IsTalentLearned() and HealingEngine.GetBuffsCount(A.Lifebloom.ID, 1) ~= 2 then 
			if Unit(player):HasBuffs(A.Lifebloom.ID, true) == 0 then
				HealingEngine.SetTarget("player", 0.5)
				return A.Lifebloom:Show(icon)
			end	
	
			if ActiveLifebloomOnTank == 0 then
				HealingEngine.SetTarget("TANK", 0.5)
				return A.Lifebloom:Show(icon)
			end	
		end
			
		-- Regrowth
		if A.Regrowth:IsReady(unitID) and CanCast and (not isMoving or Unit(player):HasBuffs(A.NaturesSwiftness.ID, true) > 0 or Unit(player):HasBuffs(A.IncarnationBuff.ID, true) > 0) then
			if Unit(player):HasBuffs(A.SouloftheForestBuff.ID, true) > 1 then
				if Unit(unitID):HealthPercent() <= 60 then
					return A.Regrowth:Show(icon)
				end
			end

			if Unit(player):HasBuffs(A.SouloftheForestBuff.ID, true) == 0 then
				if Unit(unitID):HealthPercent() <= 70 then
					return A.Regrowth:Show(icon)
				end
			end
		end
	
		-- Overgrowth
		if A.Overgrowth:IsReady(unitID) and CanCast and Unit(unitID):HealthPercent() <= 50 then
			return A.Overgrowth:Show(icon)
		end

		-- Rejuvenation
		if A.Rejuvenation:IsReady(unitID) and CanCast and A.Germination.IsTalentLearned() and Unit(unitID):HasBuffs(A.RejuvenationGerm.ID, true) == 0 and Unit(unitID):HasBuffs(A.Rejuvenation.ID, true) > 0 then
			if Unit(unitID):HealthPercent() <= 80 or Unit(unitID):IsTanking() then
				return A.Rejuvenation:Show(icon)
			end
		end
		
		
		if A.Rejuvenation:IsReady(unitID) and CanCast and Unit(unitID):HasBuffs(A.Rejuvenation.ID, true) == 0 then
			if Unit(unitID):HealthPercent() <= 95 then
				return A.Rejuvenation:Show(icon)
			end
		end
		
		-- Efflorescence
		if A.Efflorescence:IsReady(player) and CanCast and EfflorescenceOnSelf and not Emergency then
			if A.SpringBlossoms:IsTalentLearned() and Unit(player):HasBuffs(A.SpringBlossoms.ID, true) == 0 and A.LastPlayerCastName ~= A.Efflorescence:Info() then
				return A.Efflorescence:Show(icon)
			end
			
			if not A.SpringBlossoms:IsTalentLearned() and not EfflorescenceActive then
				return A.Efflorescence:Show(icon)
			end
		end
		
		if A.Efflorescence:IsReady(player) and CanCast and not EfflorescenceActive and not Emergency then
			return A.Efflorescence:Show(icon)
		end
	
		-- Nourish
		if A.Nourish:IsReady(unitID) and CanCast and AllHoTsActive and Unit(unitID):HealthPercent() <= 60 then
			return A.Nourish:Show(icon)
		end
	
	end

	--[[Switch to friendly
	if A.IsUnitEnemy(target) and (Unit(targettarget):HealthPercent() <= 70 or (Unit(targettarget):HealthPercent() <= 80 and Unit(targettarget):HasBuffs(A.Rejuvenation.ID, true) == 0)) then
		return A.Darkflight:Show(icon)
	end
	
	--Switch to enemy
	if A.IsUnitFriendly(target) and HealingEngine.GetHealthAVG() >= 90 and Unit(target):HealthPercent() >= 90 and Unit(target):HasBuffs(A.Rejuvenation.ID, true) > 2 then
		return A:Show(icon, ACTION_CONST_AUTOTARGET)
	end	]]


    -- Defensive
    local SelfDefensive = SelfDefensives()
    if SelfDefensive then 
        return SelfDefensive:Show(icon)
    end 
    
	-- Friendly Mouseover
    if A.IsUnitFriendly(mouseover) then 
        unitID = mouseover  
		
        if HealingRotation(unitID) then 
            return true 
        end             
    end
	
    -- Heal Target 
    if A.IsUnitFriendly(target) then 
        unitID = target 
		
        if HealingRotation(unitID) then 
            return true 
        end 
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

    -- DPS targettarget     
    if A.IsUnitEnemy(targettarget) then 
        unitID = targettarget
        
        if DamageRotation(unitID) then 
            return true 
        end 
    end 

end

