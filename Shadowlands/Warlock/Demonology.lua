--#####################################
--##### TRIP'S DEMONOLOGY WARLOCK #####
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
local TR 										= Action.TasteRotation

--For Toaster
local Toaster									= _G.Toaster
local GetSpellTexture 							= _G.TMW.GetSpellTexture

--- ============================ CONTENT ===========================
--- ======= APL LOCALS =======
-- luacheck: max_line_length 9999

Action[ACTION_CONST_WARLOCK_DEMONOLOGY] = {
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
	SummonFelguard				= Action.Create({ Type = "Spell", ID = 30146	}),
    CommandDemon				= Action.Create({ Type = "Spell", ID = 119898	}),	
    SingeMagic					= Action.Create({ Type = "Spell", ID = 119905	}),	
    ShadowBulwark				= Action.Create({ Type = "Spell", ID = 119907	}),	
    SpellLock					= Action.Create({ Type = "Spell", ID = 119910	}),	
    Seduction					= Action.Create({ Type = "Spell", ID = 119909	}),	
    AxeToss						= Action.Create({ Type = "Spell", ID = 119914	}),	
    Felstorm					= Action.Create({ Type = "Spell", ID = 89751	}),	
    LegionStrike				= Action.Create({ Type = "Spell", ID = 30213	}),		

	--Demonology Spells
    CallDreadstalkers			= Action.Create({ Type = "Spell", ID = 104316	}),
    Demonbolt					= Action.Create({ Type = "Spell", ID = 264178	}),
    HandofGuldan				= Action.Create({ Type = "Spell", ID = 105174	}),
    Implosion					= Action.Create({ Type = "Spell", ID = 196277	}),
    SummonDemonicTyrant			= Action.Create({ Type = "Spell", ID = 265187	}),
    DemonicCore					= Action.Create({ Type = "Spell", ID = 267102, Hidden = true	}),
    DemonicCoreBuff				= Action.Create({ Type = "Spell", ID = 264173, Hidden = true	}),	

	--Normal Talents
    Dreadlash					= Action.Create({ Type = "Spell", ID = 264078, Hidden = true	}),
    BilescourgeBombers			= Action.Create({ Type = "Spell", ID = 267211	}),
    DemonicStrength				= Action.Create({ Type = "Spell", ID = 267171	}),
    DemonicCalling				= Action.Create({ Type = "Spell", ID = 205145, Hidden = true	}),
    DemonicCallingBuff			= Action.Create({ Type = "Spell", ID = 205146, Hidden = true	}),	
    PowerSiphon					= Action.Create({ Type = "Spell", ID = 264130	}),
    Doom						= Action.Create({ Type = "Spell", ID = 603		}),
    DemonSkin					= Action.Create({ Type = "Spell", ID = 219272, Hidden = true	}),
    BurningRush					= Action.Create({ Type = "Spell", ID = 111400	}),
    DarkPact					= Action.Create({ Type = "Spell", ID = 108416	}),
    FromtheShadows				= Action.Create({ Type = "Spell", ID = 267170, Hidden = true 	}),
    SoulStrike					= Action.Create({ Type = "Spell", ID = 264057	}),
    SummonVilefiend				= Action.Create({ Type = "Spell", ID = 264119	}),
    Darkfury					= Action.Create({ Type = "Spell", ID = 264874, Hidden = true	}),
    MortalCoil					= Action.Create({ Type = "Spell", ID = 6789		}),
    HowlofTerror				= Action.Create({ Type = "Spell", ID = 5484		}),
    SoulConduit					= Action.Create({ Type = "Spell", ID = 215941, Hidden = true	}),
    InnerDemons					= Action.Create({ Type = "Spell", ID = 267216, Hidden = true	}),
    GrimoireFelguard			= Action.Create({ Type = "Spell", ID = 111898	}),
	GrimoireFelguardT     		= Action.Create({ Type = "Spell", ID = 108503 	}),	
    SacrificedSouls				= Action.Create({ Type = "Spell", ID = 267214, Hidden = true	}),
    DemonicConsumption			= Action.Create({ Type = "Spell", ID = 267215, Hidden = true	}),
    NetherPortal				= Action.Create({ Type = "Spell", ID = 267217	}),
    NetherPortalBuff			= Action.Create({ Type = "Spell", ID = 267218, Hidden = true	}),

	--PvP Talents
    SingeMagic					= Action.Create({ Type = "Spell", ID = 212623	}),
    CallFelhunter				= Action.Create({ Type = "Spell", ID = 212619	}),
    PleasurethroughPain			= Action.Create({ Type = "Spell", ID = 212618, Hidden = true	}),
    CallFelLord					= Action.Create({ Type = "Spell", ID = 212459	}),
    CallObserver				= Action.Create({ Type = "Spell", ID = 201996	}),
    MasterSummoner				= Action.Create({ Type = "Spell", ID = 212628, Hidden = true	}),
    BaneofFragility				= Action.Create({ Type = "Spell", ID = 199954	}),
    AmplifyCurse				= Action.Create({ Type = "Spell", ID = 328774	}),
    NetherWard					= Action.Create({ Type = "Spell", ID = 212295	}),
    EssenceDrain				= Action.Create({ Type = "Spell", ID = 221711, Hidden = true	}),
    CastingCircle				= Action.Create({ Type = "Spell", ID = 221703	}),
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
	--Demonology
    BalespidersBurningCore		= Action.Create({ Type = "Spell", ID = 337159, Hidden = true	}),
    GrimInquisitorsDreadCalling	= Action.Create({ Type = "Spell", ID = 337141, Hidden = true	}),
    ForcesoftheHornedNightmare	= Action.Create({ Type = "Spell", ID = 337146, Hidden = true	}),
    ImplosivePotential			= Action.Create({ Type = "Spell", ID = 337135, Hidden = true	}),

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
}

local A = setmetatable(Action[ACTION_CONST_WARLOCK_DEMONOLOGY], { __index = Action })


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
	DemonboltDelay							= 0,	
	ShadowBoltDelay							= 0,		
}

local IsIndoors, UnitIsUnit, UnitName = IsIndoors, UnitIsUnit, UnitName



local function IsSchoolFree()
	return LoC:IsMissed("SILENCE") and LoC:Get("SCHOOL_INTERRUPT", "SHADOW") == 0
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

---------------------------
----- PETS MANAGEMENT -----
---------------------------
-- API - Spell v2
-- Lib:AddActionsSpells(owner, spells, useManagement, useSilence, delMacros)
Pet:AddActionsSpells(266, { 
	-- number accepted
	A.Felstorm.ID, -- Felstorm 
	A.LegionStrike.ID, -- Legion Strike	
}, true)

-- API - Tracker v2
-- Initialize Tracker 
Pet:AddTrackers(266, Pet.Data.TrackersConfigPetID[266])

-- Pet Lib v2
local owner = "PlayerSpec"
local Pointer = Pet.Data.Trackers[266]
local petID, petData = next(Pointer.PetIDs)

-- Function to check for remaining Dreadstalker duration
local function DreadStalkersTime()
    return Pet:GetRemainDuration(98035) or 0
end

-- Function to check for remaining Grimoire Felguard duration
local function GrimoireFelguardTime()
    return Pet:GetRemainDuration(17252) or 0
end

-- Function to check for Demonic Tyrant duration
local function DemonicTyrantTime()
    return Pet:GetRemainDuration(135002) or 0
end  

-- Function to check for Vilefiend duration
local function VilefiendTime()
    return Pet:GetRemainDuration(135816) or 0
end        

-- Check for Real Tyran summoned since VoP randomly summon a Tyran for 35% of its base duration
local function RealTyrantIsActive()
    return DemonicTyrantTime() > 6 and true or false
end

-- Function to check for Demonic Tyrant duration
local function DemonicTyrantIsActive()
    return DemonicTyrantTime() > 0 and true or false
end 

-- Hack to record timestamp of passive imp spawn 
local function LastPassiveImpTimeStamp()
    -- Since imp is active for 20sec, track every special npcid for Inner Demons imps with duration at 19.9 to get timestamp record
    return Pet:GetRemainDuration(143622) > 19.8 and TMW.time or 0
end

-- Imps spawn every 12sec with talent Inner Demons
-- Use our previous timestamp to predict next passive Imp spawn timestamp
local function NextPassiveImpSpawn()
    return (LastPassiveImpTimeStamp() + 12) or 0 
end

local function GetGUID(unitID)
	return UnitGUID(unitID)
end 

--------------------------------------------------------------------------
------- SHAMELESSLY STOLEN FROM TASTE - COMPLETE PET/IMP TRACKING --------
--------------------------------------------------------------------------
-- Protect errors
TMW:RegisterCallback("TMW_ACTION_IS_INITIALIZED", function()
    Action.TimerSet("DISABLE_PET_ERRORS", 99999, function() Pet:DisableErrors(true)  end)
end)

TMW:RegisterCallback("TMW_ACTION_PET_LIBRARY_ADDED", function(callbackEvent, PetID, PetGUID, PetData)
	-- PetData is a @table with next keys: name, duration, count, GUIDs 
	if PetID == 55659 then
	    PetData.GUIDs[PetGUID].impcasts = 5
	    PetData.GUIDs[PetGUID].petenergy = 100
		PetData.GUIDs[PetGUID].counter = 1
		--PetData.GUIDs[PetGUID].impcasts = 5
	    --print("Added " .. PetID .. ", his name is " .. PetData.name .. ", he got " .. PetData.GUIDs[PetGUID].impcasts .. " cast lefts and got " .. PetData.GUIDs[PetGUID].petenergy .. " energy. GUID: " .. PetGUID)
	    -- If we want to modify data we can 
	    --Pointer.PetIDs.myVar = "custom data"
	    --print(Pointer.PetIDs.myVar)
	end
end)
--/dump LibStub("PetLibrary"):GetTrackerData().[55659].GUIDs

-------------------------------------------------------------------------------
-- Remap
-------------------------------------------------------------------------------
local TeamCacheFriendly, TeamCacheFriendlyUNITs
local A_Unit						= A.Unit
local A_GetSpellInfo				= A.GetSpellInfo
local A_GetSpellLink				= A.GetSpellLink
local ActiveNameplates				= A.MultiUnits:GetActiveUnitPlates()
local TeamCacheFriendly				= TeamCache.Friendly
local TeamCacheFriendlyUNITs		= TeamCacheFriendly.UNITs

local PetOnEventCLEU					= {
		["UNIT_DIED"] 		= "Remove",
		["UNIT_DESTROYED"] 	= "Remove",
		["UNIT_DISSIPATES"] = "Remove",		
		["PARTY_KILL"] 		= "Remove",
		["SPELL_INSTAKILL"] = "Remove",
		["SPELL_SUMMON"] 	= "Add",
}
	
-- Global ImpData	
TR.ImpData = {
    ImpCastsRemaing = 0,
	ImpCount = 0,
	ImpTotalEnergy = 0,
}

-- Tools
local function GetGUID(unitID)
	return (unitID and TeamCacheFriendlyUNITs[unitID]) or UnitGUID(unitID)
end 
	  
local function ConvertGUIDtoNPCID(GUID)
	if A_Unit then 
		local _, _, _, _, _, npc_id = A_Unit(""):InfoGUID(GUID) -- A_Unit("") because no unitID 
		return npc_id
	else
		local _, _, _, _, _, _, _, NPCID = strfind(GUID, "(%S+)-(%d+)-(%d+)-(%d+)-(%d+)-(%d+)-(%S+)")
		return NPCID and tonumber(NPCID)
	end 
end 

-- Deprecated
local function AddWildImpToTracker(PetID, PetGUID, PetName)
	
	if not Pointer.PetIDs[PetID] then 
		Pointer.PetIDs[PetID] = { count = 0, GUIDs = {} }
	end 
	
	Pointer.PetIDs[PetID].name 				= "Wild Imp"
	Pointer.PetIDs[PetID].duration 			= 20
	Pointer.PetIDs[PetID].count				= Pointer.PetIDs[PetID].count + 1
	Pointer.PetIDs[PetID].GUIDs[PetGUID]	= { 
		updated			= TMW.time, 
		start 			= TMW.time, 
		expiration		= TMW.time + Pointer.PetIDs[PetID].duration,
		impcasts        = 5,
		petenergy       = 100,
	}
	
	--Pointer.PetGUIDs[DestGUID]				= Pointer.PetIDs[PetID]
	--PetTrackerGUID[PetGUID]					= PetID
	Pet.Data.Trackers[266].PetGUIDs[PetGUID]					= PetID
	
	TMW:Fire("TMW_ACTION_PET_LIBRARY_ADDED", PetID, PetGUID, Pointer.PetIDs[PetID])
end 

-- CLEU events 
TR.COMBAT_LOG_EVENT_UNFILTERED			= function(...)

	if Unit("player"):HasSpec(266) then -- check for Demonology spec
 	
	    local _, Event, _, SourceGUID, _, SourceFlags, _, DestGUID, DestName, DestFlags,_, SpellID, SpellName = CombatLogGetCurrentEventInfo()
	    --local PetID = 55659

	    if SourceGUID and Pointer.PetIDs[55659] and Pointer.PetIDs[55659].GUIDs and Pointer.PetIDs[55659].GUIDs[SourceGUID] then 
	    	Pointer.PetIDs[55659].GUIDs[SourceGUID].updated = TMW.time 
	    end 

        -- Decrement impcasts and petenergy
	    if Pointer.PetIDs and Pointer.PetIDs[55659] and Pointer.PetIDs[55659].GUIDs and Pointer.PetGUIDs[SourceGUID] and SourceGUID and (Event == "SPELL_CAST_SUCCESS") and SpellID == 104318 then
            --Pointer.PetIDs[Pointer.PetGUIDs[SourceGUID]].GUIDs[SourceGUID].impcasts = Pointer.PetIDs[Pointer.PetGUIDs[SourceGUID]].GUIDs[SourceGUID].impcasts - 1
	        Pointer.PetIDs[55659].GUIDs[SourceGUID].impcasts = Pointer.PetIDs[55659].GUIDs[SourceGUID].impcasts - 1 
	    	--Pointer.PetIDs[Pointer.PetGUIDs[SourceGUID]].GUIDs[SourceGUID].petenergy = Pointer.PetIDs[Pointer.PetGUIDs[SourceGUID]].GUIDs[SourceGUID].petenergy - 20
		    Pointer.PetIDs[55659].GUIDs[SourceGUID].petenergy = Pointer.PetIDs[55659].GUIDs[SourceGUID].petenergy - 20
	    end

	    -- Add Implosion and Demonic Consumption listener
	    if  (Event == "SPELL_CAST_SUCCESS") and SourceGUID == GetGUID("player") and Pointer.PetIDs[55659] and  --and SourceGUID  and
	        (   -- Implosion
	            SpellID == 196277 or SpellName == A.Implosion:Info()
	           	or 
	   	        -- Summon Demonic Tyrant with Demonic Consumption
	   	        (SpellID == 265187 and A.DemonicConsumption:IsSpellLearned())
	        ) 
	    then 
	        local PetID = 55659
			if Pointer.PetIDs[55659] then
	            for GUID in pairs(Pointer.PetIDs[PetID].GUIDs) do 
  	                Pointer.PetGUIDs[GUID] = nil 
	            end
	            wipe(Pointer.PetIDs[PetID].GUIDs)
	            if Pointer.PetIDs[PetID].count > 1 then 
  	                Pointer.PetIDs[PetID].count = 0  
	            else  
 	                Pointer.PetIDs[PetID].GUIDs = nil 
				end
	        end 
	    end
		
    end -- check for Demonology spec	
end
Listener:Add("ACTION_TASTE_IMP_TRACKER", "COMBAT_LOG_EVENT_UNFILTERED", TR.COMBAT_LOG_EVENT_UNFILTERED)

-- Imps advanced Data
-- Return the realtime Wild Imps count, Total Energy for all active Imps and Total Casts remains for all active Imps
-- @usage: local WildImpsCount, WildImpTotalEnergy, WildImpTotalCastsRemains = GetImpsData(55659, "Wild Imp")
-- @parameters: petID or petName or both
-- @return number, number, number
local function GetImpsData(petID, petName)
	
	local TotalImpEnergy = 0
	local TotalImpCast = 0
	local TotalImpCount = 0
	
	-- Note: Imp energy value + remaining casts
	if petID and Pointer.PetIDs[petID] then 
        for _, petData in pairs(Pointer.PetIDs) do 
			if petData.id == petID or petData.name == petName then 
				for _, dataGUID in pairs(petData.GUIDs) do 
			        local petenergy = dataGUID.petenergy
			        local impcasts = dataGUID.impcasts
			        local impcounter = dataGUID.counter
					
			        -- Imp casts
			        if impcasts > 0 then 
                        TotalImpCast = TotalImpCast + impcasts
					else
					    impcounter = 0
			        end 
			
			        -- Imp Energy
			        if petenergy > 0 then 
                        TotalImpEnergy = TotalImpEnergy + petenergy
					else
					    impcounter = 0
			        end 
					TotalImpCount = TotalImpCount + impcounter
				end 
			end 
		end 
	end 
	
	return TotalImpCount, TotalImpEnergy, TotalImpCast  
end 
	
-- On Successful HoG cast add how many Imps will spawn
local ImpsSpawnedFromHoG = 0 
local _, event, _, sourceGUID, _, _, _, destGUID, destName, _, _, spellID, spellName = CombatLogGetCurrentEventInfo()	
if (event == "SPELL_CAST_SUCCESS") and sourceGUID == UnitGUID(player) and spellID == 105174 then
    ImpsSpawnedFromHoG = ImpsSpawnedFromHoG + (Player:SoulShards() >= 3 and 3 or Player:SoulShards())
    Env.LastPlayerCastID 	= spellID
	A.LastPlayerCastName	= spellName
	A.LastPlayerCastID		= spellID
    TMW:Fire("TMW_CNDT_LASTCAST_UPDATED")
end

-- Give imp count prediction with HoG cast
local function ImpsSpawnedDuring(miliseconds)
    local ImpSpawned = 0
    -- Used for Wild Imps spawn prediction
    local InnerDemonsNextCast = 0
    local ImpCastsRemaing = 0
    local SpellCastTime = ( miliseconds / 1000 ) * Player:SpellHaste()
    local castName, castStartTime, castEndTime, notInterruptable, spellID, isChannel = Unit(player):IsCasting()
	
    if TMW.time <= NextPassiveImpSpawn() and (TMW.time + SpellCastTime) >= NextPassiveImpSpawn() then
        ImpSpawned = ImpSpawned + 1
    end

    if castName == A.HandofGuldan:Info() then
        ImpSpawned = ImpSpawned + (Player:SoulShards() >= 3 and 3 or Player:SoulShards())
    end

    ImpSpawned = ImpSpawned + ImpsSpawnedFromHoG

    return ImpSpawned
end
ImpsSpawnedDuring = A.MakeFunctionCachedDynamic(ImpsSpawnedDuring)

-- SummonDemonicTyrant checker
local function MegaTyrant()
    local castName, castStartTime, castEndTime, notInterruptable, spellID, isChannel = Unit(player):IsCasting()
	local WildImpsCount, WildImpTotalEnergy, WildImpTotalCastsRemains = GetImpsData(55659, "Wild Imp")
    return WildImpsCount > 6 and castName == A.HandofGuldan:Info()
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

local function FutureShard()
    local Shard = Player:SoulShards()
    local castName, castStartTime, castEndTime, notInterruptable, spellID, isChannel = Unit(player):IsCasting()
    
	if not Unit(player):IsCasting() then
        return Shard
    else
        if spellID == A.NetherPortal.ID then
            return Shard - 1
        elseif spellID == A.CallDreadstalkers.ID and Unit(player):HasBuffs(A.DemonicCallingBuff.ID, true) == 0 then
            return Shard - 2
        elseif spellID == A.BilescourgeBombers.ID then
            return Shard - 2
        elseif spellID == A.SummonVilefiend.ID then
            return Shard - 1
        elseif spellID == A.GrimoireFelguard.ID then
            return Shard - 1
        elseif spellID == A.HandofGuldan.ID then
            if Shard > 3 then
                return Shard - 3
            else
                return 0
            end
        elseif spellID == A.Demonbolt.ID then
            if Shard >= 4 then
                return 5
            else
                return Shard + 2
            end
        elseif spellID == A.ShadowBolt.ID then
            if Shard == 5 then
                return Shard
            else
                return Shard + 1
            end
        elseif spellID == A.SoulStrike.ID then
            if Shard == 5 then
                return Shard
            else
                return Shard + 1
            end
        else
            return Shard
        end
    end
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
	local AutoMultiDot = A.GetToggle(2, "AutoMultiDot")
	local DrainLifeHP = A.GetToggle(2, "DrainLifeHP")	
	local HealthFunnelHP = A.GetToggle(2, "HealthFunnelHP")
	local UseAoE = A.GetToggle(2, "AoE")

	local FutureShard = FutureShard()
    local WildImpsCount, WildImpTotalEnergy, WildImpTotalCastsRemains = GetImpsData(55659, "Wild Imp")
	local DreadStalkersTime = DreadStalkersTime()
	local GrimoireFelguardTime = GrimoireFelguardTime()
	local DemonicTyrantTime = DemonicTyrantTime()
	local VilefiendTime = VilefiendTime()
	local RealTyrantIsActive = RealTyrantIsActive()
	local DemonicTyrantIsActive = DemonicTyrantIsActive()
	local MegaTyrant = MegaTyrant()	

    if Temp.DemonboltDelay == 0 and Unit(player):IsCasting() == "Demonbolt" then
        Temp.DemonboltDelay = 90
    end
    
    if Temp.DemonboltDelay > 0 then		
        Temp.DemonboltDelay = Temp.DemonboltDelay - 1
    end
	
    if Temp.ShadowBoltDelay == 0 and Unit(player):IsCasting() == "Shadow Bolt" and Player:SoulShards() == 4 then		
        Temp.ShadowBoltDelay = 90
    end
	
    if Temp.ShadowBoltDelay > 0 and Player:SoulShards() == 5 then
        Temp.ShadowBoltDelay = 0
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
			if A.SummonFelguard:IsReady("player") and (not isMoving) and not Pet:IsActive() then
				return A.SummonFelguard:Show(icon)
			end		

			--actions.precombat+=/demonbolt
			if A.Demonbolt:IsReady(unit) and ((not isMoving) or Unit(player):HasBuffs(A.DemonicCoreBuff.ID, true) > 0) and Temp.DemonboltDelay == 0 then
				return A.Demonbolt:Show(icon)
			end	
			
			--actions.precombat+=/variable,name=tyrant_ready,value=0			
			VarTyrantReady = false

		end
		
		--##################
		--##### OffGCD #####
		--##################
		
		local function OffGCD(unit)
		

			--actions.off_gcd=berserking,if=pet.demonic_tyrant.active
			if A.Berserking:IsReady(player) and BurstIsON("target") and DemonicTyrantIsActive then
				return A.Berserking:Show(icon)
			end	
			
			--actions.off_gcd+=/potion,if=buff.berserking.up|pet.demonic_tyrant.active&!race.troll
			
			
			--actions.off_gcd+=/blood_fury,if=pet.demonic_tyrant.active
			if A.BloodFury:IsReady(player) and BurstIsON("target") and DemonicTyrantIsActive then
				return A.BloodFury:Show(icon)
			end	
			
			--actions.off_gcd+=/fireblood,if=pet.demonic_tyrant.active
			if A.Fireblood:IsReady(player) and BurstIsON("target") and DemonicTyrantIsActive then
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
									
		end

		--####################
		--##### ESSENCES #####
		--####################
		
		local function Essences(unit)

			--Temporary Covenants until they're simmed
			if A.ScouringTithe:IsReady(unit) and (not isMoving) and A.GetToggle(1, "Covenant") then
				return A.ScouringTithe:Show(icon)
			end	
			
			if A.ImpendingCatastrophe:IsReady(unit) and (not isMoving) and A.GetToggle(1, "Covenant") then
				return A.ImpendingCatastrophe:Show(icon)
			end				
			
			if A.DecimatingBolt:IsReady(unit) and (not isMoving) and A.GetToggle(1, "Covenant") then
				return A.DecimatingBolt:Show(icon)
			end	

			if A.SoulRot:IsReady(unit) and (not isMoving) and A.GetToggle(1, "Covenant") then
				return A.SoulRot:Show(icon)
			end	

		end
	
		--#########################
		--##### SUMMON TYRANT #####
		--#########################
	
		local function SummonTyrant(unit)
		
			--actions.summon_tyrant=hand_of_guldan,if=soul_shard=5,line_cd=20
			if A.HandofGuldan:IsReady(unit) and TMW.time - (A.HandofGuldan.t1_start or 0) > 20 and (not isMoving) and FutureShard == 5 then
				if A.HandofGuldan:IsSpellInCasting() then
					A.HandofGuldan.t1_start = TMW.time
				end
				return A.HandofGuldan:Show(icon)
			end	
			
			--actions.summon_tyrant+=/demonbolt,if=buff.demonic_core.up&(talent.demonic_consumption.enabled|buff.nether_portal.down),line_cd=20
			if A.Demonbolt:IsReady(unit) and TMW.time - (A.Demonbolt.t1_start or 0) > 20 and Unit(player):HasBuffs(A.DemonicCoreBuff.ID, true) > 0 and (A.DemonicConsumption:IsTalentLearned() or Unit(player):HasBuffs(A.NetherPortalBuff.ID, true) == 0) then
				if A.Demonbolt:IsSpellInCasting() then
					A.Demonbolt.t1_start = TMW.time
				end
				return A.Demonbolt:Show(icon)
			end 
			
			--actions.summon_tyrant+=/shadow_bolt,if=buff.wild_imps.stack+incoming_imps<4&(talent.demonic_consumption.enabled|buff.nether_portal.down),line_cd=20
			if A.ShadowBolt:IsReady(unit) and (not isMoving) and TMW.time - (A.ShadowBolt.t1_start or 0) > 20 and Temp.ShadowBoltDelay == 0 and WildImpsCount < 4 and (A.DemonicConsumption:IsTalentLearned() or Unit(player):HasBuffs(A.NetherPortalBuff.ID, true) == 0) then
				if A.ShadowBolt:IsSpellInCasting() then
					A.ShadowBolt.t1_start = TMW.time
				end			
				return A.ShadowBolt:Show(icon)
			end	
			
			--actions.summon_tyrant+=/call_dreadstalkers
			if A.CallDreadstalkers:IsReady(unit) then
				if (Unit(player):HasBuffs(A.DemonicCallingBuff.ID, true) == 0 and not isMoving) or Unit(player):HasBuffs(A.DemonicCallingBuff.ID, true) > 0 then
					return A.CallDreadstalkers:Show(icon)
				end
			end	
			
			--actions.summon_tyrant+=/hand_of_guldan
			if A.HandofGuldan:IsReady(unit) and (not isMoving) then
				return A.HandofGuldan:Show(icon)
			end	
			--actions.summon_tyrant+=/demonbolt,if=buff.demonic_core.up&buff.nether_portal.up&((buff.vilefiend.remains>5|!talent.summon_vilefiend.enabled)&(buff.grimoire_felguard.remains>5|buff.grimoire_felguard.down))
			if A.Demonbolt:IsReady(unit) and Unit(player):HasBuffs(A.DemonicCoreBuff.ID, true) > 0 and Unit(player):HasBuffs(A.NetherPortalBuff.ID, true) > 0 and (((VilefiendTime <= 10 and VilefiendTime > 0) or not A.SummonVilefiend:IsTalentLearned()) and (GrimoireFelguardTime <= 12 or GrimoireFelguardTime == 0)) then
				return A.Demonbolt:Show(icon)
			end	
			
			--actions.summon_tyrant+=/shadow_bolt,if=buff.nether_portal.up&((buff.vilefiend.remains>5|!talent.summon_vilefiend.enabled)&(buff.grimoire_felguard.remains>5|buff.grimoire_felguard.down))
			if A.ShadowBolt:IsReady(unit) and (not isMoving) and Temp.ShadowBoltDelay == 0 and Unit(player):HasBuffs(A.NetherPortalBuff.ID, true) > 0 and (((VilefiendTime <= 10 and VilefiendTime > 0) or not A.SummonVilefiend:IsTalentLearned()) and (GrimoireFelguardTime <= 12 or GrimoireFelguardTime == 0)) then
				return A.ShadowBolt:Show(icon)
			end	
			
			--actions.summon_tyrant+=/variable,name=tyrant_ready,value=!cooldown.summon_demonic_tyrant.ready
			if A.SummonDemonicTyrant:GetCooldown() > 5 then 
				VarTyrantReady = false
			end 
			
			--actions.summon_tyrant+=/summon_demonic_tyrant
			if A.SummonDemonicTyrant:IsReady(player) and (not isMoving) then
				return A.SummonDemonicTyrant:Show(icon)
			end	
			
			--actions.summon_tyrant+=/shadow_bolt
			if A.ShadowBolt:IsReady(player) and (not isMoving) and Temp.ShadowBoltDelay == 0 then
				return A.ShadowBolt:Show(icon)
			end	

		end

		--#######################
		--##### TYRANT PREP #####
		--#######################

		local function TyrantPrep(unit)
		
			--actions.tyrant_prep=doom,line_cd=30
			if A.Doom:IsReady(unit) and A.Doom:IsTalentLearned() and Unit("target"):TimeToDie() > 18 and Unit("target"):HasDeBuffs(A.Doom.ID, true) == 0 then
				return A.Doom:Show(icon)
			end	
			
			--actions.tyrant_prep+=/demonic_strength,if=!talent.demonic_consumption.enabled
			if A.DemonicStrength:IsReady(player) and A.DemonicStrength:IsTalentLearned() and not A.DemonicConsumption:IsTalentLearned() then
				return A.DemonicStrength:Show(icon)
			end	
			
			--actions.tyrant_prep+=/nether_portal
			if A.NetherPortal:IsReady(player) and (not isMoving) and A.NetherPortal:IsTalentLearned() then
				return A.NetherPortal:Show(icon)
			end	
			
			--actions.tyrant_prep+=/grimoire_felguard
			if A.GrimoireFelguard:IsReady(unit) and A.GrimoireFelguard:IsTalentLearned() then
				return A.GrimoireFelguardT:Show(icon)
			end	
			
			--actions.tyrant_prep+=/summon_vilefiend
			if A.SummonVilefiend:IsReady(player) and A.SummonVilefiend:IsTalentLearned() and (not isMoving) then
				return A.SummonVilefiend:Show(icon)
			end	
			
			--actions.tyrant_prep+=/call_dreadstalkers
			if A.CallDreadstalkers:IsReady(unit) then
				if (Unit(player):HasBuffs(A.DemonicCallingBuff.ID, true) == 0 and not isMoving) or Unit(player):HasBuffs(A.DemonicCallingBuff.ID, true) > 0 then
					return A.CallDreadstalkers:Show(icon)
				end
			end	
			
			--actions.tyrant_prep+=/demonbolt,if=buff.demonic_core.up&soul_shard<4&(talent.demonic_consumption.enabled|buff.nether_portal.down)
			if A.Demonbolt:IsReady(unit) and Unit(player):HasBuffs(A.DemonicCoreBuff.ID, true) > 0 and FutureShard < 4 and (A.DemonicConsumption:IsTalentLearned() or Unit(player):HasBuffs(A.NetherPortalBuff.ID, true) == 0) then
				return A.Demonbolt:Show(icon)
			end	
			
			--actions.tyrant_prep+=/shadow_bolt,if=soul_shard<5-4*buff.nether_portal.up
			if A.ShadowBolt:IsReady(unit) and (not isMoving) and Temp.ShadowBoltDelay == 0 and FutureShard < 5 - (4 * num(Unit(player):HasBuffs(A.NetherPortalBuff.ID, true) > 0)) then
				return A.ShadowBolt:Show(icon)
			end	
			
			--actions.tyrant_prep+=/variable,name=tyrant_ready,value=1
			if A.SummonVilefiend:GetCooldown() > 0 and A.GrimoireFelguard:GetCooldown() > 0 and (A.NetherPortal:GetCooldown() > 0 or not A.NetherPortal:IsTalentLearned()) then
			VarTyrantReady = true
			end
			
			--actions.tyrant_prep+=/hand_of_guldan	
			if A.HandofGuldan:IsReady(unit) and (not isMoving) then
				return A.HandofGuldan:Show(icon)
			end	
		
		
		end

		--#########################
		--##### MAIN ROTATION #####
		--#########################

		if inCombat then

			--Fel Domination if Pet dies
			if A.FelDomination:IsReady("player") and not Pet:IsActive() then
				return A.FelDomination:Show(icon)
			end			
			
			-- Summon Pet 
			if A.SummonFelguard:IsReady("player") and (not isMoving) and not Pet:IsActive() and Unit(player):HasBuffs(A.FelDomination.ID, true) > 0 then
				return A.SummonFelguard:Show(icon)
			end		
			

			--Drain Life below HP %
			if A.DrainLife:IsReady(unit) and Unit(player):HealthPercent() <= DrainLifeHP then
				return A.DrainLife:Show(icon)
			end	
			
			--Health Funnel
			if A.HealthFunnel:IsReady(player) and Pet:IsActive() and Unit("pet"):HealthPercent() <= HealthFunnelHP and Unit(player):HealthPercent() >= 30 then
				return A.HealthFunnel:Show(icon)
			end	
		
			--actions=call_action_list,name=off_gcd
			if BurstIsON(unit) then 
				if OffGCD() then
					return true
				end
			end
			
			--actions+=/call_action_list,name=essences
			if BurstIsON(unit) then 
				if Essences() then
					return true
				end
			end
			
			--actions+=/run_action_list,name=tyrant_prep,if=cooldown.summon_demonic_tyrant.remains<5&!variable.tyrant_ready
			if BurstIsON(unit) and A.SummonDemonicTyrant:GetCooldown() < 5 and not VarTyrantReady then
				if TyrantPrep() then
					return true	
				end
			end
			
			--actions+=/run_action_list,name=summon_tyrant,if=variable.tyrant_ready
			if BurstIsON(unit) and VarTyrantReady then
				if SummonTyrant() then				
					return true
				end
			end
			
			--actions+=/summon_vilefiend,if=cooldown.summon_demonic_tyrant.remains>40|time_to_die<cooldown.summon_demonic_tyrant.remains+25
			if A.SummonVilefiend:IsReady(player) and (not isMoving) and A.SummonVilefiend:IsTalentLearned() then
				if (BurstIsON(unit) and (A.SummonDemonicTyrant:GetCooldown() > 40 or Unit("target"):TimeToDie() < A.SummonDemonicTyrant:GetCooldown() + 25)) or not BurstIsON(unit) then
					return A.SummonVilefiend:Show(icon)
				end
			end

			--Scuffed AoE
			if A.HandofGuldan:IsReady(unit) and MultiUnits:GetActiveEnemies() >= 3 and FutureShard >= 3 and UseAoE then
				return A.HandofGuldan:Show(icon)
			end	
			
			if A.Implosion:IsReady(unit) and WildImpsCount >= 3 and MultiUnits:GetActiveEnemies() >= 3 and UseAoE then
				return A.Implosion:Show(icon)
			end
			
			--actions+=/call_dreadstalkers
			if A.CallDreadstalkers:IsReady(unit) then
				if (Unit(player):HasBuffs(A.DemonicCallingBuff.ID, true) == 0 and not isMoving) or Unit(player):HasBuffs(A.DemonicCallingBuff.ID, true) > 0 then
					return A.CallDreadstalkers:Show(icon)
				end
			end	
			
			--actions+=/doom,if=refreshable
			if A.Doom:IsReady(unit) and A.Doom:IsTalentLearned() and Unit("target"):TimeToDie() > 18 and Unit("target"):HasDeBuffs(A.Doom.ID, true) == 0 then
				return A.Doom:Show(icon)
			end	
			
			--actions+=/demonic_strength
			if A.DemonicStrength:IsReady(unit) and A.DemonicStrength:IsTalentLearned() and Unit("pet"):IsCasting() ~= "Felstorm" and Unit("target"):TimeToDie() > 8 then
				return A.DemonicStrength:Show(icon)
			end	
			
			--actions+=/bilescourge_bombers
			if A.BilescourgeBombers:IsReady(player) and A.BilescourgeBombers:IsTalentLearned() then
				return A.BilescourgeBombers:Show(icon)
			end	
			
			--actions+=/hand_of_guldan,if=soul_shard=5|buff.nether_portal.up
			if A.HandofGuldan:IsReady(unit) and (not isMoving) and (FutureShard == 5 or Unit(player):HasBuffs(A.NetherPortalBuff.ID, true) > 0) then
				return A.HandofGuldan:Show(icon)
			end	
			
			--actions+=/hand_of_guldan,if=soul_shard>=3&cooldown.summon_demonic_tyrant.remains>20&(cooldown.summon_vilefiend.remains>5|!talent.summon_vilefiend.enabled)&cooldown.call_dreadstalkers.remains>2
			if A.HandofGuldan:IsReady(unit) and (not isMoving) and FutureShard >= 3 and A.SummonDemonicTyrant:GetCooldown() > 20 and (A.SummonVilefiend:GetCooldown() > 5 or not A.SummonVilefiend:IsTalentLearned()) and A.CallDreadstalkers:GetCooldown() > 2 then
				return A.HandofGuldan:Show(icon)
			end	
			
			--actions+=/demonbolt,if=buff.demonic_core.react&soul_shard<4
			if A.Demonbolt:IsReady(unit) and Unit(player):HasBuffs(A.DemonicCoreBuff.ID, true) > 0 and FutureShard < 4 then
				return A.Demonbolt:Show(icon)
			end	
			
			--actions+=/grimoire_felguard,if=cooldown.summon_demonic_tyrant.remains+cooldown.summon_demonic_tyrant.duration>time_to_die|time_to_die<cooldown.summon_demonic_tyrant.remains+15
			if BurstIsON(unit) and A.GrimoireFelguard:IsReady(unit) and A.GrimoireFelguard:IsTalentLearned() then
				return A.GrimoireFelguardT:Show(icon)
			end	
			
			--actions+=/use_items
			--actions+=/power_siphon,if=buff.wild_imps.stack>1&buff.demonic_core.stack<3
			if A.PowerSiphon:IsReady(player) and A.PowerSiphon:IsTalentLearned() and WildImpsCount > 1 and Unit(player):HasBuffsStacks(A.DemonicCoreBuff.ID, true) < 3 then
				return A.PowerSiphon:Show(icon)
			end	
			
			--actions+=/soul_strike
			if A.SoulStrike:IsReady(player) and A.SoulStrike:IsTalentLearned() then
				return A.SoulStrike:Show(icon)
			end	
			
			--actions+=/shadow_bolt
			if A.ShadowBolt:IsReady(unit) and (not isMoving) and Temp.ShadowBoltDelay == 0 then
				return A.ShadowBolt:Show(icon)
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