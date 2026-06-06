local profile = {};

------------------------------------------------------------
-- Small helper: shallow-merge two sets (replacement for
-- GearSwap's set_combine). over wins on conflicts.
------------------------------------------------------------
local function combine(base, over)
    local t = {};
    for k, v in pairs(base or {}) do t[k] = v; end
    for k, v in pairs(over or {}) do t[k] = v; end
    return t;
end

------------------------------------------------------------
-- Augmented gear (LuAshitacast {Name=, Augment={}} format)
------------------------------------------------------------
local AdhemarJacket = {
    Accuracy = { Name = 'Adhemar Jacket +1', Augment = { [1] = 'DEX+12', [2] = 'AGI+12', [3] = 'Accuracy+20' } },
    FC       = { Name = 'Adhemar Jacket +1', Augment = { [1] = 'HP+105', [2] = '"Fast Cast"+10', [3] = 'Magic dmg. taken -4' } },
};

local AdhemarWrists = {
    Attack   = { Name = 'Adhemar Wrist. +1', Augment = { [1] = 'STR+12', [2] = 'DEX+12', [3] = 'Attack+20' } },
    Accuracy = { Name = 'Adhemar Wrist. +1', Augment = { [1] = 'DEX+12', [2] = 'AGI+12', [3] = 'Accuracy+20' } },
};

local HerculeanHelm = {
    Nuke    = { Name = 'Herculean Helm', Augment = { [1] = 'Mag. Acc.+18 "Mag.Atk.Bns."+18', [2] = '"Fast Cast"+1', [3] = 'INT+9', [4] = 'Mag. Acc.+9', [5] = '"Mag.Atk.Bns."+12' } },
    DT      = { Name = 'Herculean Helm', Augment = { [1] = 'Attack+12', [2] = 'Phys. dmg. taken -4%', [3] = 'STR+9', [4] = 'Accuracy+8' } },
    Refresh = { Name = 'Herculean Helm', Augment = { [1] = 'Weapon skill damage +2%', [2] = 'Pet: Accuracy+11 Pet: Rng. Acc.+11', [3] = '"Refresh"+2' } },
    Reso    = { Name = 'Herculean Helm', Augment = { [1] = 'Accuracy+27', [2] = '"Triple Atk."+3', [3] = 'STR+3' } },
};

local HerculeanVest = {
    Phalanx = { Name = 'Herculean Vest', Augment = { [1] = 'Chance of successful block +3', [2] = 'Pet: Attack+4 Pet: Rng.Atk.+4', [3] = 'Phalanx +5', [4] = 'Mag. Acc.+10 "Mag.Atk.Bns."+10' } },
    CDC     = { Name = 'Herculean Vest', Augment = { [1] = 'Accuracy+19 Attack+19', [2] = 'Crit. hit damage +3%', [3] = 'DEX+14', [4] = 'Accuracy+3' } },
};

local HerculeanGloves = {
    DT             = { Name = 'Herculean Gloves', Augment = { [1] = 'Accuracy+13', [2] = 'Damage taken-3%', [3] = 'AGI+1', [4] = 'Attack+5' } },
    Refresh        = { Name = 'Herculean Gloves', Augment = { [1] = 'Spell interruption rate down -1%', [2] = '"Repair" potency +4%', [3] = '"Refresh"+2', [4] = 'Accuracy+9 Attack+9', [5] = 'Mag. Acc.+16 "Mag.Atk.Bns."+16' } },
    Crit           = { Name = 'Herculean Gloves', Augment = { [1] = 'Attack+23', [2] = 'Crit. hit damage +4%', [3] = 'DEX+8', [4] = 'Accuracy+11' } },
    Phalanx        = { Name = 'Herculean Gloves', Augment = { [1] = 'INT+5', [2] = 'Pet: "Dbl. Atk."+3', [3] = 'Phalanx +4' } },
    PhysicalSpells = { Name = 'Herculean Gloves', Augment = { [1] = 'Accuracy+11 Attack+11', [2] = '"Triple Atk."+2', [3] = 'STR+10', [4] = 'Accuracy+15', [5] = 'Attack+5' } },
};

local HerculeanLegs = {
    TH      = { Name = 'Herculean Trousers', Augment = { [1] = 'INT+5', [2] = 'MND+6', [3] = '"Treasure Hunter"+1', [4] = 'Mag. Acc.+17 "Mag.Atk.Bns."+17' } },
    Phalanx = { Name = 'Herculean Trousers', Augment = { [1] = 'Attack+13', [2] = 'Pet: Haste+4', [3] = 'Phalanx +4' } },
    Refresh = { Name = 'Herculean Trousers', Augment = { [1] = 'Pet: INT+3', [2] = 'STR+4', [3] = '"Refresh"+2', [4] = 'Accuracy+19 Attack+19' } },
};

local LustFeet = {
    STRDEX = { Name = 'Lustra. Leggings +1', Augment = { [1] = 'HP+50', [2] = 'STR+10', [3] = 'DEX+10' } },
    STRDA  = { Name = 'Lustra. Leggings +1', Augment = { [1] = 'Attack+20', [2] = 'STR+8', [3] = '"Dbl.Atk."+3' } },
};

local HerculeanFeet = {
    QA      = { Name = 'Herculean Boots', Augment = { [1] = 'Enmity-2', [2] = 'Crit.hit rate+1', [3] = 'Quadruple Attack +3', [4] = 'Accuracy+20 Attack+20', [5] = 'Mag. Acc.+16 "Mag.Atk.Bns."+16' } },
    TA      = { Name = 'Herculean Boots', Augment = { [1] = 'Accuracy+14 Attack+14', [2] = '"Triple Atk."+4', [3] = 'DEX+3', [4] = 'Accuracy+2', [5] = 'Attack+15' } },
    STP     = { Name = 'Herculean Boots', Augment = { [1] = '"Conserve MP"+4', [2] = 'MND+9', [3] = '"Store TP"+8', [4] = 'Accuracy+10 Attack+10', [5] = 'Mag. Acc.+13 "Mag.Atk.Bns."+13' } },
    Idle    = { Name = 'Herculean Boots', Augment = { [1] = 'Crit. hit damage +1%', [2] = 'STR+10', [3] = '"Refresh"+2', [4] = 'Accuracy+15 Attack+15', [5] = 'Mag. Acc.+17 "Mag.Atk.Bns."+17' } },
    DW      = { Name = 'Herculean Boots', Augment = { [1] = 'Accuracy+3 Attack+3', [2] = '"Dual Wield"+4', [3] = 'AGI+3', [4] = 'Accuracy+14' } },
    Phalanx = { Name = 'Herculean Boots', Augment = { [1] = '"Store TP"+1', [2] = 'INT+10', [3] = 'Phalanx +3', [4] = 'Accuracy+16 Attack+16', [5] = 'Mag. Acc.+19 "Mag.Atk.Bns."+19' } },
    TH      = { Name = 'Herculean Boots', Augment = { [1] = 'Phys. dmg. taken -2%', [2] = 'Pet: Phys. dmg. taken -2%', [3] = '"Treasure Hunter"+2', [4] = 'Accuracy+16 Attack+16', [5] = 'Mag. Acc.+18 "Mag.Atk.Bns."+18' } },
};

local Ogma = {
    STP     = { Name = "Ogma's Cape", Augment = { [1] = 'DEX+20', [2] = 'Accuracy+20 Attack+20', [3] = 'Accuracy+10', [4] = '"Store TP"+10', [5] = 'Phys. dmg. taken-10%' } },
    Tank    = { Name = "Ogma's Cape", Augment = { [1] = 'HP+60', [2] = 'Eva.+20 /Mag. Eva.+20', [3] = 'Mag. Evasion+10', [4] = 'Phys. dmg. taken-10%' } },
    Parry   = { Name = "Ogma's Cape", Augment = { [1] = 'HP+60', [2] = 'Eva.+20 /Mag. Eva.+20', [3] = 'Mag. Evasion+10', [4] = 'Enmity+10', [5] = 'Parrying rate+5%' } },
    WSD     = { Name = "Ogma's Cape", Augment = { [1] = 'DEX+20', [2] = 'Accuracy+20 Attack+20', [3] = 'DEX+10', [4] = 'Weapon skill damage +10%', [5] = 'Phys. dmg. taken-10%' } },
    DA      = { Name = "Ogma's Cape", Augment = { [1] = 'STR+20', [2] = 'Accuracy+20 Attack+20', [3] = 'STR+10', [4] = '"Dbl.Atk."+10', [5] = 'Phys. dmg. taken-10%' } },
    FC      = { Name = "Ogma's Cape", Augment = { [1] = 'HP+60', [2] = 'Eva.+20 /Mag. Eva.+20', [3] = 'HP+20', [4] = '"Fast Cast"+10', [5] = 'Phys. dmg. taken-10%' } },
    Evasion = { Name = "Ogma's Cape", Augment = { [1] = 'AGI+20', [2] = 'Eva.+20 /Mag. Eva.+20', [3] = 'Evasion+10', [4] = 'Enmity+10', [5] = 'Evasion+15' } },
    Cure    = { Name = "Ogma's Cape", Augment = { [1] = 'MND+20', [2] = 'Eva.+20 /Mag. Eva.+20', [3] = 'HP+20', [4] = '"Cure" potency +10%', [5] = 'Phys. dmg. taken-10%' } },
};

------------------------------------------------------------
-- Gear sets
------------------------------------------------------------
local sets = {
    -------------------------------------------------- Idle (cycle)
    Idle_Standard = {
        Ammo = 'Staunch Tathlum', Head = 'Erilaz Galea', Body = 'Meg. Cuirie +2',
        Hands = 'Turms Mittens +1', Legs = 'Meg. Chausses +2', Feet = "Hermes' Sandals",
        Neck = 'Sanctity Necklace', Waist = 'Sailfi Belt +1', Ear1 = 'Bladeborn Earring',
        Ear2 = 'Steelflash Earring', Ring2 = 'Gelatinous Ring +1', Ring1 = 'Karieyh Ring',
    },
    Idle_DT = {
        Ammo = 'Staunch Tathlum +1', Head = 'Nyame Helm', Neck = "Warder's Charm +1",
        Ear2 = 'Tuisto Earring', Ear1 = 'Odnowa Earring +1', Body = 'Nyame Mail',
        Hands = 'Nyame Gauntlets', Ring2 = 'Moonlight Ring', Ring1 = 'Shneddick Ring +1',
        Back = Ogma.Tank, Waist = 'Engraved Belt', Legs = 'Erilaz Leg Guards +3', Feet = 'Erilaz Greaves +3',
    },
    Idle_Evasion = {
        Ammo = 'Staunch Tathlum +1', Head = 'Nyame Helm', Neck = 'Bathy Choker +1',
        Ear1 = 'Eabani Earring', Ear2 = 'Infused Earring', Body = 'Nyame Mail',
        Hands = 'Nyame Gauntlets', Ring2 = 'Gelatinous Ring +1', Ring1 = 'Shneddick Ring +1',
        Back = Ogma.Evasion, Waist = 'Kasiri Belt', Legs = 'Nyame Flanchard', Feet = 'Nyame Sollerets',
    },

    -------------------------------------------------- 1H TP (cycle)
    TP1H_DualWield = {
        Ammo = 'Ginsen', Head = 'Aya. Zucchetto +2', Body = 'Adhemar Jacket +1',
        Hands = AdhemarWrists.Accuracy, Legs = 'Samnuha Tights', Feet = 'Meg. Jam. +2',
        Neck = 'Sanctity Necklace', Waist = 'Sailfi Belt +1', Ear1 = 'Bladeborn Earring',
        Ear2 = 'Steelflash Earring', Ring2 = "Epona's Ring", Ring1 = 'Moonbeam Ring', Back = Ogma.DA,
    },
    TP1H_CapHaste = {
        Ammo = 'Coiste Bodhar', Head = 'Dampening Tam', Neck = 'Anu Torque', Ear1 = 'Eabani Earring',
        Ear2 = 'Sherida Earring', Body = 'Adhemar Jacket +1', Hands = AdhemarWrists.Attack,
        Ring1 = "Epona's Ring", Ring2 = 'Niqmaddu Ring', Back = Ogma.STP, Waist = 'Reiki Yotai',
        Legs = 'Samnuha Tights', Feet = HerculeanFeet.QA,
    },
    TP1H_AccLite = {
        Ammo = 'Yamarang', Head = 'Adhemar Bonnet +1', Neck = "Combatant's Torque", Ear1 = 'Suppanomimi',
        Ear2 = 'Sherida Earring', Body = AdhemarJacket.Accuracy, Hands = AdhemarWrists.Attack,
        Ring1 = "Epona's Ring", Ring2 = 'Niqmaddu Ring', Back = Ogma.STP, Waist = 'Kentarch Belt +1',
        Legs = 'Samnuha Tights', Feet = HerculeanFeet.TA,
    },
    TP1H_AccMid = {
        Ammo = 'Yamarang', Head = 'Dampening Tam', Neck = "Combatant's Torque", Ear1 = 'Suppanomimi',
        Ear2 = 'Telos Earring', Body = AdhemarJacket.Accuracy, Hands = AdhemarWrists.Attack,
        Ring1 = "Epona's Ring", Ring2 = 'Niqmaddu Ring', Back = Ogma.STP, Waist = 'Kentarch Belt +1',
        Legs = 'Samnuha Tights', Feet = HerculeanFeet.TA,
    },
    TP1H_AccFull = {
        Ammo = 'Yamarang', Head = 'Carmine Mask +1', Neck = "Combatant's Torque", Ear1 = 'Mache Earring +1',
        Ear2 = 'Telos Earring', Body = AdhemarJacket.Accuracy, Hands = AdhemarWrists.Accuracy,
        Ring1 = 'Cacoethic Ring +1', Ring2 = 'Niqmaddu Ring', Back = Ogma.STP, Waist = 'Kentarch Belt +1',
        Legs = 'Carmine Cuisses +1', Feet = HerculeanFeet.TA, -- NOTE: original referenced HerculeanFeet.CritDmg, which was never defined. Using TA.
    },

    -------------------------------------------------- 2H TP (cycle)
    TP2H_CapHaste = {
        Sub = 'Nepenthe Grip', Ammo = 'Ginsen', Head = 'Aya. Zucchetto +2', Body = 'Adhemar Jacket +1',
        Hands = AdhemarWrists.Accuracy, Legs = 'Samnuha Tights', Feet = 'Meg. Jam. +2',
        Neck = 'Sanctity Necklace', Waist = 'Sailfi Belt +1', Ear1 = 'Bladeborn Earring',
        Ear2 = 'Steelflash Earring', Ring2 = "Epona's Ring", Ring1 = 'Moonbeam Ring', Back = Ogma.DA,
    },
    TP2H_AccLite = {
        Ammo = 'Aurgelmir Orb +1', Head = 'Adhemar Bonnet +1', Neck = "Combatant's Torque",
        Ear1 = 'Telos Earring', Ear2 = 'Sherida Earring', Body = AdhemarJacket.Accuracy,
        Hands = AdhemarWrists.Accuracy, Ring1 = "Epona's Ring", Ring2 = 'Niqmaddu Ring', Back = Ogma.STP,
        Waist = 'Ioskeha Belt +1', Legs = 'Samnuha Tights', Feet = HerculeanFeet.TA,
    },
    TP2H_AccMid = {
        Ammo = 'Yamarang', Head = 'Dampening Tam', Neck = "Combatant's Torque", Ear1 = 'Telos Earring',
        Ear2 = 'Sherida Earring', Body = AdhemarJacket.Accuracy, Hands = AdhemarWrists.Accuracy,
        Ring1 = "Epona's Ring", Ring2 = 'Niqmaddu Ring', Back = Ogma.STP, Waist = 'Ioskeha Belt +1',
        Legs = 'Samnuha Tights', Feet = HerculeanFeet.TA,
    },
    TP2H_AccFull = {
        Ammo = 'Yamarang', Head = 'Carmine Mask +1', Neck = "Combatant's Torque", Ear1 = 'Telos Earring',
        Ear2 = 'Mache Earring +1', Body = AdhemarJacket.Accuracy, Hands = 'Gazu Bracelet +1',
        Ring1 = 'Chirich Ring +1', Ring2 = 'Chirich Ring +1', Back = Ogma.STP, Waist = 'Kentarch Belt +1',
        Legs = 'Carmine Cuisses +1', Feet = 'Erilaz Greaves +3',
    },

    -------------------------------------------------- Tanking TP (cycle)
    Tank_Tank = {
        Sub = 'Refined Grip +1', Ammo = 'Staunch Tathlum', Head = 'Meghanada Visor +2',
        Body = 'Futhark Coat +1', Hands = 'Turms Mittens +1', Legs = 'Meg. Chausses +2',
        Feet = 'Aya. Gambieras +1', Neck = 'Futhark Torque', Waist = 'Sailfi Belt +1',
        Ear1 = 'Bladeborn Earring', Ear2 = 'Steelflash Earring', Ring2 = 'Ayanmo Ring',
        Ring1 = 'Moonbeam Ring', Back = Ogma.Parry,
    },
    Tank_TankHyb = {
        Ammo = 'Coiste Bodhar', Head = 'Nyame Helm', Neck = "Combatant's Torque", Ear1 = 'Telos Earring',
        Ear2 = 'Sherida Earring', Body = 'Nyame Mail', Hands = 'Nyame Gauntlets', Ring1 = 'Moonlight Ring',
        Ring2 = 'Niqmaddu Ring', Back = Ogma.DA, Waist = 'Ioskeha Belt +1', Legs = 'Nyame Flanchard',
        Feet = 'Nyame Sollerets',
    },
    Tank_DDHyb = {
        Ammo = 'Coiste Bodhar', Head = 'Nyame Helm', Neck = 'Anu Torque', Ear1 = 'Telos Earring',
        Ear2 = 'Sherida Earring', Body = 'Nyame Mail', Hands = AdhemarWrists.Accuracy, -- fixed: was a string in the original
        Ring1 = "Epona's Ring", Ring2 = 'Niqmaddu Ring', Back = Ogma.DA, Waist = 'Ioskeha Belt +1',
        Legs = 'Samnuha Tights', Feet = 'Nyame Sollerets',
    },
    Tank_Magic1 = {
        Ammo = 'Staunch Tathlum +1', Head = 'Nyame Helm', Neck = "Warder's Charm +1", Ear1 = 'Odnowa Earring +1',
        Ear2 = 'Erilaz Earring +1', Body = 'Nyame Mail', Hands = 'Turms Mittens +1', Ring2 = 'Moonlight Ring',
        Ring1 = 'Defending Ring', Back = Ogma.Parry, Waist = 'Flume Belt', Legs = 'Erilaz Leg Guards +3',
        Feet = 'Turms Leggings +1',
    },
    Tank_Magic2 = {
        Ammo = 'Staunch Tathlum +1', Head = 'Nyame Helm', Neck = "Warder's Charm +1", Ear1 = 'Odnowa Earring +1',
        Ear2 = 'Erilaz Earring +1', Body = 'Erilaz Surcoat +3', Hands = 'Nyame Gauntlets', Ring2 = 'Shadow Ring',
        Ring1 = 'Defending Ring', Back = Ogma.Parry, Waist = 'Flume Belt', Legs = 'Erilaz Leg Guards +3',
        Feet = 'Turms Leggings +1',
    },
    -- Defined in the original but never placed in the cycle index; kept for /lac set use.
    Tank_Magic3 = {
        Ammo = 'Staunch Tathlum +1', Head = 'Nyame Helm', Neck = "Warder's Charm +1", Ear1 = 'Brutal Earring',
        Ear2 = 'Erilaz Earring +1', Body = 'Nyame Mail', Hands = 'Nyame Gauntlets', Ring2 = 'Moonlight Ring',
        Ring1 = 'Shadow Ring', Back = Ogma.STP, Waist = 'Ioskeha Belt +1', Legs = 'Nyame Flanchard',
        Feet = 'Nyame Sollerets',
    },

    -------------------------------------------------- Weaponskills
    Resolution_AttackUncap = {
        Ammo = 'Ginsen', Head = 'Lustratio Cap +1', Body = 'Adhemar Jacket +1', Hands = 'Meg. Gloves +2',
        Legs = 'Meg. Chausses +2', Feet = LustFeet.STRDA, Neck = 'Fotia Gorget', Waist = 'Thunder Belt',
        Ear1 = 'Moonshade Earring', Ear2 = 'Cessance Earring', Ring2 = "Epona's Ring", Ring1 = 'Ayanmo Ring', Back = Ogma.DA,
    },
    Resolution_AttackCap = {
        Ammo = 'Seething Bomblet +1', Head = 'Nyame Helm', Neck = 'Fotia Gorget', Ear1 = 'Moonshade Earring',
        Ear2 = 'Sherida Earring', Body = 'Nyame Mail', Hands = AdhemarWrists.Attack, Ring1 = "Epona's Ring",
        Ring2 = 'Niqmaddu Ring', Back = Ogma.DA, Waist = 'Fotia Belt', Legs = 'Samnuha Tights', Feet = 'Nyame Sollerets',
    },
    Resolution_Accuracy = {
        Ammo = 'Voluspa Tathlum', Head = 'Nyame Helm', Neck = 'Fotia Gorget', Ear1 = 'Moonshade Earring',
        Ear2 = 'Sherida Earring', Body = AdhemarJacket.Accuracy, Hands = AdhemarWrists.Attack, Ring1 = 'Regal Ring',
        Ring2 = 'Niqmaddu Ring', Back = Ogma.DA, Waist = 'Fotia Belt', Legs = 'Meghanada Chausses +2', Feet = HerculeanFeet.TA,
    },

    Dimidiation_AttackUncap = {
        Ammo = 'Ginsen', Head = 'Lustratio Cap +1', Body = 'Meg. Cuirie +2', Hands = 'Meg. Gloves +2',
        Legs = 'Meg. Chausses +2', Feet = LustFeet.STRDA, Neck = 'Sanctity Necklace', Waist = 'Sailfi Belt +1',
        Ear1 = 'Moonshade Earring', Ear2 = 'Cessance Earring', Ring2 = "Epona's Ring", Ring1 = 'Ayanmo Ring', Back = Ogma.DA,
    },
    Dimidiation_AttackCap = {
        Ammo = 'Knobkierrie', Head = 'Nyame Helm', Neck = 'Fotia Gorget', Ear1 = 'Moonshade Earring',
        Ear2 = 'Sherida Earring', Body = AdhemarJacket.Accuracy, Hands = 'Nyame Gauntlets', Ring2 = 'Niqmaddu Ring',
        Ring1 = "Epona's Ring", Back = Ogma.WSD, Waist = 'Fotia Belt', Legs = 'Lustratio Subligar +1', Feet = LustFeet.STRDA,
    },
    Dimidiation_Accuracy = {
        Ammo = 'Voluspa Tathlum', Head = 'Carmine Mask +1', Neck = 'Fotia Gorget', Ear1 = 'Moonshade Earring',
        Ear2 = 'Mache Earring +1', Body = AdhemarJacket.Accuracy, Hands = 'Gazu Bracelet +1', Ring2 = 'Niqmaddu Ring',
        Ring1 = 'Ilabrat Ring', Back = Ogma.WSD, Waist = 'Kentarch Belt +1', Legs = 'Carmine Cuisses +1', Feet = 'Nyame Sollerets',
    },

    Requiescat_AttackUncap = {
        Ammo = 'Quartz Tathlum +1', Head = 'Carmine Mask +1', Neck = 'Fotia Gorget', Ear1 = 'Moonshade Earring',
        Ear2 = 'Sherida Earring', Body = AdhemarJacket.Accuracy, Hands = AdhemarWrists.Attack, Ring1 = "Epona's Ring",
        Ring2 = 'Regal Ring', Back = Ogma.DA, Waist = 'Fotia Belt', Legs = 'Meghanada Chausses +2', Feet = 'Carmine Greaves +1',
    },
    Requiescat_AttackCap = {
        Ammo = 'Quartz Tathlum +1', Head = 'Carmine Mask +1', Neck = 'Fotia Gorget', Ear1 = 'Moonshade Earring',
        Ear2 = 'Sherida Earring', Body = AdhemarJacket.Accuracy, Hands = AdhemarWrists.Attack, Ring1 = "Epona's Ring",
        Ring2 = 'Regal Ring', Back = Ogma.DA, Waist = 'Fotia Belt', Legs = 'Meghanada Chausses +2', Feet = 'Carmine Greaves +1',
    },
    Requiescat_Accuracy = {
        Ammo = 'Yamarang', Head = 'Carmine Mask +1', Neck = 'Fotia Gorget', Ear1 = 'Crepuscular Earring',
        Ear2 = 'Telos Earring', Body = AdhemarJacket.Accuracy, Hands = AdhemarWrists.Attack, Ring1 = "Epona's Ring",
        Ring2 = 'Regal Ring', Back = Ogma.DA, Waist = 'Fotia Belt', Legs = 'Telchine Braconi', Feet = 'Carmine Greaves +1',
    },

    SavageBlade_AttackUncap = {
        Ammo = 'Knobkierrie', Head = 'Nyame Helm', Neck = 'Futhark Torque +1', Ear1 = 'Moonshade Earring',
        Ear2 = 'Sherida Earring', Body = 'Nyame Mail', Hands = 'Nyame Gauntlets', Ring1 = "Epaminondas's Ring",
        Ring2 = 'Niqmaddu Ring', Back = Ogma.WSD, Waist = 'Sailfi Belt +1', Legs = 'Nyame Flanchard', Feet = 'Nyame Sollerets',
    },
    SavageBlade_AttackCap = {
        Ammo = 'Knobkierrie', Head = 'Nyame Helm', Neck = 'Futhark Torque +1', Ear1 = 'Moonshade Earring',
        Ear2 = 'Sherida Earring', Body = 'Nyame Mail', Hands = 'Nyame Gauntlets', Ring1 = "Epaminondas's Ring",
        Ring2 = 'Niqmaddu Ring', Back = Ogma.WSD, Waist = 'Sailfi Belt +1', Legs = 'Nyame Flanchard', Feet = 'Nyame Sollerets',
    },
    SavageBlade_Accuracy = {
        Ammo = 'Voluspa Tathlum', Head = 'Nyame Helm', Neck = 'Fotia Gorget', Ear1 = 'Moonshade Earring',
        Ear2 = 'Telos Earring', Body = AdhemarJacket.Accuracy, Hands = 'Nyame Gauntlets', Ring2 = "Epaminondas's Ring",
        Ring1 = 'Regal Ring', Back = Ogma.WSD, Waist = 'Sailfi Belt +1', Legs = 'Nyame Flanchard', Feet = 'Nyame Sollerets',
    },

    BlackHalo_AttackUncap = {
        Ammo = 'Knobkierrie', Head = 'Nyame Helm', Neck = 'Futhark Torque +1', Ear1 = 'Moonshade Earring',
        Ear2 = 'Sherida Earring', Body = 'Nyame Mail', Hands = 'Nyame Gauntlets', Ring1 = 'Regal Ring',
        Ring2 = 'Niqmaddu Ring', Back = Ogma.WSD, Waist = 'Sailfi Belt +1', Legs = 'Nyame Flanchard', Feet = 'Nyame Sollerets',
    },

    Realmrazer_AttackUncap = {
        Ammo = 'Quartz Tathlum +1', Head = 'Carmine Mask +1', Neck = 'Fotia Gorget', Ear1 = 'Moonshade Earring',
        Ear2 = 'Sherida Earring', Body = AdhemarJacket.Accuracy, Hands = 'Nyame Gauntlets', Ring1 = "Epona's Ring",
        Ring2 = 'Rufescent Ring', Back = 'Cornflower Cape', Waist = 'Fotia Belt', Legs = 'Telchine Braconi', Feet = 'Carmine Greaves +1',
    },

    FlashNova = {
        Ammo = 'Pemphredo Tathlum', Head = 'Nyame Helm', Neck = 'Baetyl Pendant', Ear1 = 'Friomisi Earring',
        Ear2 = 'Hermetic Earring', Body = 'Nyame Mail', Hands = 'Nyame Gauntlets', Ring1 = 'Shiva Ring +1',
        Ring2 = 'Shiva Ring +1', Back = "Evasionist's Cape", Waist = 'Eschan Stone', Legs = 'Nyame Flanchard', Feet = 'Nyame Sollerets',
    },
    SanguineBlade = {
        Ammo = 'Pemphredo Tathlum', Head = 'Pixie Hairpin +1', Neck = 'Baetyl Pendant', Ear1 = 'Friomisi Earring',
        Ear2 = 'Hermetic Earring', Body = 'Nyame Mail', Hands = 'Nyame Gauntlets', Ring1 = 'Archon Ring',
        Ring2 = 'Shiva Ring +1', Back = "Evasionist's Cape", Waist = 'Hachirin-no-obi', Legs = 'Nyame Flanchard', Feet = 'Nyame Sollerets',
    },
    StatusWS = {
        Ammo = 'Yamarang', Head = 'Nyame Helm', Neck = "Combatant's Torque", Ear1 = 'Crepuscular Earring',
        Ear2 = 'Crepuscular Earring', Body = 'Nyame Mail', Hands = 'Nyame Gauntlets', Ring1 = 'Chirich Ring +1',
        Ring2 = 'Moonlight Ring', Waist = 'Eschan Stone', Legs = 'Nyame Flanchard', Feet = 'Nyame Sollerets',
    },

    -------------------------------------------------- Magic / utility
    Cures = {
        Ammo = 'Staunch Tathlum +1', Head = 'Nyame Helm', Neck = 'Sacro Gorget', Ear1 = 'Cryptic Earring',
        Ear2 = 'Magnetic Earring', Body = 'Nyame Mail', Hands = 'Erilaz Gauntlets +3', Ring1 = "Menelaus's Ring",
        Ring2 = 'Eihwaz Ring', Back = Ogma.Parry, Waist = 'Sroda Belt', Legs = 'Erilaz Leg Guards +3', Feet = 'Erilaz Greaves +3',
    },
    SIR = {
        Ammo = 'Staunch Tathlum +1', Head = "Agwu's Cap", Neck = 'Moonlight Necklace', Ear2 = 'Magnetic Earring',
        Ear1 = 'Odnowa Earring +1', Body = 'Emet Harness +1', Hands = 'Regal Gauntlets', Ring1 = 'Moonlight Ring',
        Ring2 = 'Gelatinous Ring +1', Back = Ogma.Tank, Waist = 'Audumbla Sash', Legs = 'Carmine Cuisses +1', Feet = 'Taeon Boots',
    },
    Enmity = {
        Ammo = 'Sapience Orb', Head = 'Halitus Helm', Neck = 'Moonlight Necklace', Ear2 = 'Cryptic Earring',
        Ear1 = 'Odnowa Earring +1', Body = 'Emet Harness +1', Hands = 'Kurys Gloves', Ring1 = 'Supershear Ring',
        Ring2 = 'Eihwaz Ring', Back = Ogma.Tank, Waist = 'Kasiri Belt', Legs = 'Erilaz Leg Guards +3', Feet = 'Erilaz Greaves +3',
    },

    Util_TH = {
        Head = 'Volte Cap', Waist = 'Chaac Belt', Legs = HerculeanLegs.TH, Feet = HerculeanFeet.TH,
    },
    Util_Derp = {
        Ammo = 'Staunch Tathlum +1', Head = 'Nyame Helm', Neck = "Warder's Charm +1", Ear2 = 'Eabani Earring',
        Ear1 = 'Odnowa Earring +1', Body = 'Nyame Mail', Hands = 'Nyame Gauntlets', Ring1 = 'Shadow Ring',
        Ring2 = 'Moonlight Ring', Back = Ogma.Tank, Waist = 'Engraved Belt', Legs = 'Nyame Flanchard', Feet = 'Nyame Sollerets',
    },
    Util_Doom = {
        Ammo = 'Staunch Tathlum +1', Head = 'Nyame Helm', Neck = "Nicander's Necklace", Ear2 = 'Eabani Earring',
        Ear1 = 'Odnowa Earring +1', Body = 'Futhark Coat +3', Hands = 'Nyame Gauntlets', Ring1 = 'Saida Ring',
        Ring2 = 'Purity Ring', Back = Ogma.Tank, Waist = 'Gishdubar Sash', Legs = 'Erilaz Leg Guards +3', Feet = 'Erilaz Greaves +3',
    },

    -------------------------------------------------- Enhancing
    Enh_Base = {
        Ammo = 'Staunch Tathlum +1', Head = 'Erilaz Galea +3', Neck = "Incanter's Torque", Ear2 = 'Andoaa Earring',
        Ear1 = 'Odnowa Earring +1', Body = 'Nyame Mail', Hands = 'Runeist Mitons +3', Ring1 = 'Moonlight Ring',
        Ring2 = 'Stikini Ring +1', Back = 'Moonlight Cape', Waist = 'Flume Belt', Legs = 'Futhark Trousers +3', Feet = 'Erilaz Greaves +3',
    },
    Enh_Barspell = {
        Ammo = 'Staunch Tathlum +1', Head = 'Carmine Mask +1', Neck = "Incanter's Torque", Ear2 = 'Andoaa Earring',
        Ear1 = 'Odnowa Earring +1', Body = 'Nyame Mail', Hands = 'Regal Gauntlets', Ring1 = 'Moonlight Ring',
        Ring2 = 'Stikini Ring +1', Back = 'Moonlight Cape', Waist = 'Flume Belt', Legs = 'Carmine Cuisses +1', Feet = 'Erilaz Greaves +3',
    },
    Enh_Temper = {
        Ammo = 'Staunch Tathlum +1', Head = 'Carmine Mask +1', Neck = "Incanter's Torque", Ear2 = 'Andoaa Earring',
        Ear1 = 'Odnowa Earring +1', Body = 'Nyame Mail', Hands = 'Runeist Mitons +3', Ring1 = 'Moonlight Ring',
        Ring2 = 'Stikini Ring +1', Back = 'Moonlight Cape', Waist = 'Flume Belt', Legs = 'Carmine Cuisses +1', Feet = 'Erilaz Greaves +3',
    },
    Enh_Crusade = {
        Head = 'Erilaz Galea', Neck = 'Futhark Torque +1', Ear2 = 'Etiolation Earring', Ear1 = 'Odnowa Earring +1',
        Body = 'Nyame Mail', Hands = 'Regal Gauntlets', Ring1 = 'Defending Ring', Ring2 = 'Moonlight Ring',
        Legs = 'Futhark Trousers +3', Feet = 'Nyame Sollerets',
    },
    Enh_Refresh = {
        Ammo = 'Staunch Tathlum +1', Head = 'Erilaz Galea', Neck = "Incanter's Torque", Ear2 = 'Etiolation Earring',
        Ear1 = 'Odnowa Earring +1', Body = 'Nyame Mail', Hands = 'Regal Gauntlets', Ring2 = 'Gelatinous Ring +1',
        Ring1 = 'Shneddick Ring +1', Back = Ogma.Tank, Waist = 'Gishdubar Sash', Legs = 'Futhark Trousers +3', Feet = 'Nyame Sollerets',
    },
    Enh_Regen = {
        Ammo = 'Staunch Tathlum +1', Head = 'Runeist Bandeau +3', Neck = 'Sacro Gorget', Ear1 = 'Etiolation Earring',
        Ear2 = 'Odnowa Earring +1', Body = 'Nyame Mail', Hands = 'Regal Gauntlets', Ring2 = 'Gelatinous Ring +1',
        Ring1 = 'Defending Ring', Back = Ogma.Tank, Waist = 'Engraved Belt', Legs = 'Futhark Trousers +3', Feet = 'Nyame Sollerets',
    },

    -------------------------------------------------- Precast (Fast Cast)
    FC_Standard = {
        Ammo = 'Sapience Orb', Head = 'Runeist Bandeau', Neck = 'Baetyl Pendant', Ear1 = 'Etiolation Earring',
        Ear2 = 'Loquacious Earring', Body = 'Erilaz Surcoat', Hands = 'Leyline Gloves', Ring1 = 'Kishar Ring',
        Ring2 = 'Gelatinous Ring +1', Back = Ogma.FC, Waist = 'Kasiri Belt', Legs = "Agwu's Slops", Feet = 'Carmine Greaves +1',
    },
    FC_Val = {
        Ammo = 'Staunch Tathlum +1', Head = 'Nyame Helm', Neck = 'Futhark Torque +1', Ear2 = 'Loquacious Earring',
        Ear1 = 'Odnowa Earring +1', Body = 'Nyame Mail', Hands = 'Nyame Gauntlets', Ring1 = 'Moonlight Ring',
        Ring2 = 'Gelatinous Ring +1', Back = Ogma.FC, Waist = 'Engraved Belt', Legs = 'Futhark Trousers +3', Feet = 'Carmine Greaves +1',
    },

    -------------------------------------------------- Item-use ring sets (for warp/teleport binds)
    Warp     = { Ring2 = 'Warp Ring' },
    DimHolla = { Ring2 = 'Dim. Ring (Holla)' },
};

-- Derived sets (built with combine, mirroring the original set_combine calls)
sets.AM3_CapHaste = combine(sets.TP2H_CapHaste, { Body = 'Ashera Harness', Ring1 = 'Chirich Ring +1', Back = Ogma.STP, Waist = 'Kentarch Belt +1', Feet = HerculeanFeet.STP });
sets.AM3_AccLite  = combine(sets.TP2H_AccLite,  { Body = 'Ashera Harness', Ring1 = 'Chirich Ring +1', Back = Ogma.STP, Waist = 'Kentarch Belt +1', Feet = HerculeanFeet.STP });
sets.AM3_AccMid   = combine(sets.TP2H_AccMid,   { Body = 'Ashera Harness', Ring1 = 'Chirich Ring +1', Back = Ogma.STP, Waist = 'Kentarch Belt +1', Feet = HerculeanFeet.STP });
sets.AM3_AccFull  = combine(sets.TP2H_AccFull,  { Body = 'Ashera Harness', Ring1 = 'Chirich Ring +1', Back = Ogma.STP, Waist = 'Kentarch Belt +1' });

sets.BlackHalo_AttackCap = sets.BlackHalo_AttackUncap;
sets.BlackHalo_Accuracy  = sets.BlackHalo_AttackUncap;
sets.Realmrazer_AttackCap = sets.Realmrazer_AttackUncap;
sets.Realmrazer_Accuracy  = sets.Realmrazer_AttackUncap;

sets.Cures_Self = combine(sets.Cures, { Neck = 'Phalaina Locket', Ear2 = "Mendicant's Earring", Ring2 = 'Kunaji Ring' });

sets.Enh_Duration = combine(sets.Enh_Base, { Head = 'Erilaz Galea +3', Hands = 'Regal Gauntlets', Legs = 'Futhark Trousers +3' });
sets.Enh_Phalanx  = combine(sets.Enh_Base, { Head = 'Futhark Bandeau', Body = HerculeanVest.Phalanx, Hands = HerculeanGloves.Phalanx, Ring1 = 'Defending Ring', Ring2 = 'Moonlight Ring', Legs = HerculeanLegs.Phalanx, Feet = HerculeanFeet.Phalanx });
sets.Enh_ProShell = combine(sets.Enh_Duration, { Ear1 = 'Brachyura Earring' });
sets.Enh_Foil     = combine(sets.Enmity, { Ammo = 'Staunch Tathlum +1' });

sets.FC_Enhancing    = combine(sets.FC_Standard, { Legs = 'Futhark Trousers +3', Ring1 = 'Defending Ring' });
sets.FC_ValEnhancing = combine(sets.FC_Val, { Legs = 'Futhark Trousers +3' });

-- Job abilities (most are Enmity + a piece)
sets.JA_Lunge = {
    Sub = 'Nepenthe Grip', Ammo = 'Seething Bomblet', Head = 'Aya. Zucchetto +2', Body = 'Meg. Cuirie +2',
    Hands = 'Meg. Gloves +2', Legs = 'Meg. Chausses +2', Feet = 'Meg. Jam. +2', Neck = 'Sanctity Necklace',
    Waist = 'Sailfi Belt +1', Ear1 = "Hecate's Earring", Ear2 = 'Steelflash Earring', Ring2 = 'Ayanmo Ring',
    Ring1 = 'Gelatinous Ring +1', Back = Ogma.DA,
};
sets.JA_Pulse = {
    Ammo = 'Staunch Tathlum +1', Head = 'Erilaz Galea', Neck = "Incanter's Torque", Ear2 = 'Etiolation Earring',
    Ear1 = 'Odnowa Earring +1', Body = 'Nyame Mail', Ring1 = 'Moonlight Ring', Ring2 = 'Stikini Ring +1',
    Back = 'Moonlight Cape', Waist = 'Engraved Belt', Legs = 'Runeist Trousers +3', Feet = 'Nyame Sollerets',
};
sets.JA_One = {
    Ammo = 'Staunch Tathlum +1', Head = 'Runeist Bandeau +3', Neck = 'Unmoving Collar +1', Ear2 = 'Etiolation Earring',
    Ear1 = 'Odnowa Earring +1', Body = 'Runeist Coat +3', Hands = 'Nyame Gauntlets', Ring2 = 'Moonlight Ring',
    Ring1 = 'Gelatinous Ring +1', Back = 'Moonlight Cape', Waist = 'Kasiri Belt', Legs = 'Nyame Flanchard', Feet = 'Carmine Greaves +1',
};
sets.JA_Sforzo    = combine(sets.Enmity, { Body = 'Futhark Coat +3' });
sets.JA_Swordplay = combine(sets.Enmity, { Hands = 'Futhark Mitons +3' });
sets.JA_Vallation = combine(sets.Enmity, { Body = 'Runeist Coat +3', Legs = 'Futhark Trousers +3', Back = "Ogma's Cape" });
sets.JA_Pflug     = combine(sets.Enmity, {});
sets.JA_Embolden  = combine(sets.Enmity, {});
sets.JA_Gambit    = combine(sets.Enmity, { Hands = 'Runeist Mitons +3' });
sets.JA_Battuta   = combine(sets.Enmity, { Head = 'Futhark Bandeau +3' });
sets.JA_Rayke     = combine(sets.Enmity, { Feet = 'Futhark Boots +1' });
sets.JA_Liement   = combine(sets.Enmity, { Body = 'Futhark Coat +3' });
sets.JA_Meditate  = combine(sets.Enmity, {});
sets.JA_Provoke   = combine(sets.Enmity, {});
sets.JA_Warcry    = combine(sets.Enmity, {});
sets.JA_Subterfuge = combine(sets.Enmity, {});

profile.Sets = sets;

------------------------------------------------------------
-- Cycle lists + state
------------------------------------------------------------
local idle_cycle = { 'Idle_Standard', 'Idle_DT', 'Idle_Evasion' };
local tp1h_cycle = { 'TP1H_DualWield', 'TP1H_CapHaste', 'TP1H_AccLite', 'TP1H_AccMid', 'TP1H_AccFull' };
local tp2h_cycle = { 'TP2H_CapHaste', 'TP2H_AccLite', 'TP2H_AccMid', 'TP2H_AccFull' };
local am3_cycle  = { 'AM3_CapHaste', 'AM3_AccLite', 'AM3_AccMid', 'AM3_AccFull' };
local tank_cycle = { 'Tank_Tank', 'Tank_TankHyb', 'Tank_DDHyb', 'Tank_Magic1', 'Tank_Magic2' };
local ws_cycle   = { 'AttackUncap', 'AttackCap', 'Accuracy' };

local idle_ind, tp1h_ind, tp2h_ind, am3_ind, tank_ind, ws_ind = 1, 1, 1, 1, 1, 1;

local TankingTP  = true;   -- start in tanking TP
local TwoHandedTP = true;  -- auto-set by equipped weapon each cycle
local EpeoAM3    = false;  -- auto-set when Epeolatry AM3 is up
local TH         = false;
local SIR        = false;

-- Skill IDs that count as two-handed: GSword(4) GAxe(6) Scythe(7) Polearm(8) GKatana(10) Staff(12)
local twoHandSkill = { [4] = true, [6] = true, [7] = true, [8] = true, [10] = true, [12] = true };

-- Word-sets used by handlers
local function inSet(t, name) for _, v in ipairs(t) do if v == name then return true end end return false; end
local STRWS       = { 'Vorpal Blade', 'Fell Cleave', 'Circle Blade', 'Swift Blade', 'Shockwave' };
local DimWS       = { 'Dimidiation', 'Ground Strike', 'Upheaval' };
local IgnoreSIR   = { 'Phalanx', 'Temper', 'Refresh', 'Regen' };
local RunEnmity   = { 'Flash', 'Stun' };

------------------------------------------------------------
-- Helpers
------------------------------------------------------------
local function fwdCycle(i, list) return (i % #list) + 1; end
local function backCycle(i, list) return ((i - 2) % #list) + 1; end

local function updateWeaponState()
    local eq = gData.GetEquipment();
    local main = eq and eq.Main or nil;
    local mname = '';
    if (main ~= nil) then
        if (main.Name ~= nil) then mname = main.Name;
        elseif (main.Resource ~= nil and main.Resource.Name ~= nil) then mname = main.Resource.Name[1]; end
        if (main.Resource ~= nil and main.Resource.Skill ~= nil) then
            TwoHandedTP = (twoHandSkill[main.Resource.Skill] == true);
        end
    end
    EpeoAM3 = (gData.GetBuffCount('Aftermath: Lv.3') > 0 and mname == 'Epeolatry');
end

local function equipIdle()
    gFunc.EquipSet(sets[idle_cycle[idle_ind]]);
    local player = gData.GetPlayer();
    if (player.MPP <= 50 and idle_ind == 1) then
        gFunc.EquipSet({ Head = HerculeanHelm.Refresh, Waist = 'Fucho-no-obi' });
    end
end

local function equipEngaged()
    if (TankingTP) then
        gFunc.EquipSet(sets[tank_cycle[tank_ind]]);
    elseif (EpeoAM3) then
        gFunc.EquipSet(sets[am3_cycle[am3_ind]]);
    elseif (TwoHandedTP) then
        gFunc.EquipSet(sets[tp2h_cycle[tp2h_ind]]);
    else
        gFunc.EquipSet(sets[tp1h_cycle[tp1h_ind]]);
    end
end

------------------------------------------------------------
-- Load / Unload
------------------------------------------------------------
profile.OnLoad = function()
    gSettings.AllowAddSet = true;
    local q = AshitaCore:GetChatManager();

    -- Macros + lockstyle (book 10, set 1, lockstyle 98 -- change to taste)
    q:QueueCommand(1, '/macro book 10');
    q:QueueCommand(1, '/macro set 1');
    q:QueueCommand(1, '/lockstyleset 98');

    -- Toggle / cycle binds (forwarded to HandleCommand via /lac fwd)
    q:QueueCommand(1, '/bind F9 /lac fwd cycletp');       -- cycle the active TP set forward
    q:QueueCommand(1, '/bind !F9 /lac fwd cycletpback');  -- alt+F9: cycle backward
    q:QueueCommand(1, '/bind F10 /lac fwd cyclews');      -- cycle WS sub-set
    q:QueueCommand(1, '/bind F12 /lac fwd cycleidle');    -- cycle idle set
    q:QueueCommand(1, '/bind ^F8 /lac fwd togglesir');    -- ctrl+F8: spell interruption set on/off
    q:QueueCommand(1, '/bind !F8 /lac fwd toggletank');   -- alt+F8: tanking TP on/off
    q:QueueCommand(1, '/bind !F7 /lac fwd cycletankset'); -- alt+F7: cycle tanking TP set
    q:QueueCommand(1, '/bind !T /lac fwd toggleth');      -- alt+T: treasure hunter on/off

    -- Weaponskill binds
    q:QueueCommand(1, '/bind ^F9 /ws "Resolution" <t>');
    q:QueueCommand(1, '/bind ^F10 /ws "Dimidiation" <t>');
    q:QueueCommand(1, '/bind ^F11 /ws "Ground Strike" <t>');
    q:QueueCommand(1, '/bind ^F12 /ws "Savage Blade" <t>');

    -- Item binds
    q:QueueCommand(1, '/bind !E /item "Echo Drops" <me>');
    q:QueueCommand(1, '/bind !R /item "Remedy" <me>');
    q:QueueCommand(1, '/bind !P /item "Panacea" <me>');
    q:QueueCommand(1, '/bind !H /item "Holy Water" <me>');
    q:QueueCommand(1, '/bind !W /lac fwd warp');          -- equip + use Warp Ring
    q:QueueCommand(1, '/bind !Q /lac fwd dimholla');      -- equip + use Dim. Ring (Holla)
end

profile.OnUnload = function()
    local q = AshitaCore:GetChatManager();
    local keys = { 'F9', '!F9', 'F10', 'F12', '^F8', '!F8', '!F7', '!T',
                   '^F9', '^F10', '^F11', '^F12', '!E', '!R', '!P', '!H', '!W', '!Q' };
    for _, k in ipairs(keys) do q:QueueCommand(1, '/unbind ' .. k); end
end

------------------------------------------------------------
-- Commands (sent via  /lac fwd <name>)
------------------------------------------------------------
profile.HandleCommand = function(args)
    local cmd = string.lower(args[1] or '');

    if (cmd == 'cycletp') then
        if (TankingTP) then
            tank_ind = fwdCycle(tank_ind, tank_cycle);
            print('[RUN] Tanking TP -> ' .. tank_cycle[tank_ind]);
        elseif (TwoHandedTP) then
            tp2h_ind = fwdCycle(tp2h_ind, tp2h_cycle);
            am3_ind  = fwdCycle(am3_ind, am3_cycle);
            print('[RUN] 2H TP -> ' .. tp2h_cycle[tp2h_ind]);
        else
            tp1h_ind = fwdCycle(tp1h_ind, tp1h_cycle);
            print('[RUN] 1H TP -> ' .. tp1h_cycle[tp1h_ind]);
        end

    elseif (cmd == 'cycletpback') then
        if (TankingTP) then
            tank_ind = backCycle(tank_ind, tank_cycle);
            print('[RUN] Tanking TP -> ' .. tank_cycle[tank_ind]);
        elseif (TwoHandedTP) then
            tp2h_ind = backCycle(tp2h_ind, tp2h_cycle);
            am3_ind  = backCycle(am3_ind, am3_cycle);
            print('[RUN] 2H TP -> ' .. tp2h_cycle[tp2h_ind]);
        else
            tp1h_ind = backCycle(tp1h_ind, tp1h_cycle);
            print('[RUN] 1H TP -> ' .. tp1h_cycle[tp1h_ind]);
        end

    elseif (cmd == 'cycletankset') then
        tank_ind = fwdCycle(tank_ind, tank_cycle);
        print('[RUN] Tanking TP -> ' .. tank_cycle[tank_ind]);

    elseif (cmd == 'cyclews') then
        ws_ind = fwdCycle(ws_ind, ws_cycle);
        print('[RUN] WS sets -> ' .. ws_cycle[ws_ind]);

    elseif (cmd == 'cycleidle') then
        idle_ind = fwdCycle(idle_ind, idle_cycle);
        print('[RUN] Idle -> ' .. idle_cycle[idle_ind]);

    elseif (cmd == 'toggletank') then
        TankingTP = not TankingTP;
        print('[RUN] Tanking TP: ' .. (TankingTP and '[On]' or '[Off]'));

    elseif (cmd == 'togglesir') then
        SIR = not SIR;
        print('[RUN] Spell Interruption Rate set: ' .. (SIR and '[On]' or '[Off]'));

    elseif (cmd == 'toggleth') then
        TH = not TH;
        print('[RUN] Treasure Hunter: ' .. (TH and '[On]' or '[Off]'));

    elseif (cmd == 'warp') then
        local q = AshitaCore:GetChatManager();
        q:QueueCommand(1, '/lac set Warp 12');
        q:QueueCommand(1, '/item "Warp Ring" <me>');

    elseif (cmd == 'dimholla') then
        local q = AshitaCore:GetChatManager();
        q:QueueCommand(1, '/lac set DimHolla 12');
        q:QueueCommand(1, '/item "Dim. Ring (Holla)" <me>');
    end
end

------------------------------------------------------------
-- Idle / Engaged (+ buff-driven overrides)
------------------------------------------------------------
profile.HandleDefault = function()
    updateWeaponState();
    local player = gData.GetPlayer();

    if (player.Status == 'Engaged') then
        equipEngaged();
        if (TH) then gFunc.EquipSet(sets.Util_TH); end
    else
        equipIdle();
    end

    -- Embolden: keep the magic-evasion cape on
    if (gData.GetBuffCount('Embolden') > 0) then
        gFunc.EquipSet({ Back = "Evasionist's Cape" });
    end

    -- Incapacitated (terror/sleep/stun/petrify): wear the high-DT "Derp" set
    local incap = gData.GetBuffCount('Terror') + gData.GetBuffCount('Sleep')
                + gData.GetBuffCount('Stun') + gData.GetBuffCount('Petrification');
    if (incap > 0) then gFunc.EquipSet(sets.Util_Derp); end

    -- Doom: cursna-receptive / HP set, override everything
    if (gData.GetBuffCount('Doom') > 0) then gFunc.EquipSet(sets.Util_Doom); end
end

------------------------------------------------------------
-- Job abilities
------------------------------------------------------------
profile.HandleAbility = function()
    local n = gData.GetAction().Name;

    if (n == 'Lunge' or n == 'Swipe') then gFunc.EquipSet(sets.JA_Lunge);
    elseif (n == 'Elemental Sforzo') then gFunc.EquipSet(sets.JA_Sforzo);
    elseif (n == 'Swordplay') then gFunc.EquipSet(sets.JA_Swordplay);
    elseif (n == 'Vallation' or n == 'Valiance') then gFunc.EquipSet(sets.JA_Vallation);
    elseif (n == 'Pflug') then gFunc.EquipSet(sets.JA_Pflug);
    elseif (n == 'Embolden') then gFunc.EquipSet(sets.JA_Embolden);
    elseif (n == 'Vivacious Pulse') then gFunc.EquipSet(sets.JA_Pulse);
    elseif (n == 'Gambit') then gFunc.EquipSet(sets.JA_Gambit);
    elseif (n == 'Battuta') then gFunc.EquipSet(sets.JA_Battuta);
    elseif (n == 'Rayke') then gFunc.EquipSet(sets.JA_Rayke);
    elseif (n == 'Liement') then gFunc.EquipSet(sets.JA_Liement);
    elseif (n == 'One For All') then gFunc.EquipSet(sets.JA_One);
    elseif (n == 'Odyllic Subterfuge') then gFunc.EquipSet(sets.JA_Subterfuge);
    elseif (n == 'Meditate') then gFunc.EquipSet(sets.JA_Meditate);
    elseif (n == 'Provoke') then gFunc.EquipSet(sets.JA_Provoke);
    elseif (n == 'Warcry') then gFunc.EquipSet(sets.JA_Warcry);
    end
end

------------------------------------------------------------
-- Precast (Fast Cast)
------------------------------------------------------------
profile.HandlePrecast = function()
    local spell = gData.GetAction();
    local val = gData.GetBuffCount('Valiance') + gData.GetBuffCount('Vallation');

    if (spell.Skill == 'Enhancing Magic') then
        gFunc.EquipSet(val > 0 and sets.FC_ValEnhancing or sets.FC_Enhancing);
    else
        gFunc.EquipSet(val > 0 and sets.FC_Val or sets.FC_Standard);
    end
end

------------------------------------------------------------
-- Midcast
------------------------------------------------------------
profile.HandleMidcast = function()
    local spell = gData.GetAction();
    local name = spell.Name;

    -- Spell Interruption Rate override (skips the "ignore" list and Bar-spells)
    if (SIR and not (inSet(IgnoreSIR, name) or string.find(name, 'Bar') or string.find(name, 'Regen'))) then
        if (spell.Skill == 'Healing Magic') then
            gFunc.EquipSet(combine(sets.SIR, { Body = 'Vrikodara Jupon', Back = Ogma.Cure }));
        else
            gFunc.EquipSet(sets.SIR);
        end
        return;
    end

    if (spell.Skill == 'Enhancing Magic') then
        local embolden = gData.GetBuffCount('Embolden') > 0;
        if (embolden) then
            if (name == 'Phalanx') then gFunc.EquipSet(combine(sets.Enh_Phalanx, { Back = "Evasionist's Cape" }));
            elseif (string.find(name, 'Shell') or string.find(name, 'Protect')) then gFunc.EquipSet(combine(sets.Enh_ProShell, { Back = "Evasionist's Cape" }));
            else gFunc.EquipSet(combine(sets.Enh_Duration, { Back = "Evasionist's Cape" })); end
        elseif (name == 'Aquaveil') then gFunc.EquipSet(sets.SIR);
        elseif (name == 'Refresh') then gFunc.EquipSet(sets.Enh_Refresh);
        elseif (string.find(name, 'Regen')) then gFunc.EquipSet(sets.Enh_Regen);
        elseif (string.find(name, 'Bar')) then gFunc.EquipSet(sets.Enh_Barspell);
        elseif (name == 'Temper') then gFunc.EquipSet(sets.Enh_Temper);
        elseif (name == 'Phalanx') then gFunc.EquipSet(sets.Enh_Phalanx);
        elseif (name == 'Crusade') then gFunc.EquipSet(sets.Enh_Crusade);
        elseif (name == 'Foil') then gFunc.EquipSet(sets.Enh_Foil);
        elseif (string.find(name, 'Shell') or string.find(name, 'Protect')) then gFunc.EquipSet(sets.Enh_ProShell);
        else gFunc.EquipSet(sets.Enh_Duration); end

    elseif (spell.Skill == 'Healing Magic') then
        local tgt = gData.GetActionTarget();
        if (tgt ~= nil and tgt.Name == gData.GetPlayer().Name) then
            gFunc.EquipSet(sets.Cures_Self);
        else
            gFunc.EquipSet(sets.Cures);
        end

    elseif (inSet(RunEnmity, name)) then
        gFunc.EquipSet(sets.Enmity);
    end

    if (TH) then gFunc.EquipSet(sets.Util_TH); end
end

------------------------------------------------------------
-- Weaponskills
------------------------------------------------------------
profile.HandleWeaponskill = function()
    local player = gData.GetPlayer();
    if (player.TP < 1000) then gFunc.CancelAction(); return; end

    local n = gData.GetAction().Name;
    local sfx = ws_cycle[ws_ind]; -- AttackUncap / AttackCap / Accuracy

    if (n == 'Requiescat') then gFunc.EquipSet(sets['Requiescat_' .. sfx]);
    elseif (inSet(DimWS, n)) then gFunc.EquipSet(sets['Dimidiation_' .. sfx]);
    elseif (n == 'Resolution' or inSet(STRWS, n)) then gFunc.EquipSet(sets['Resolution_' .. sfx]);
    elseif (n == 'Savage Blade') then gFunc.EquipSet(sets['SavageBlade_' .. sfx]);
    elseif (n == 'Realmrazer') then gFunc.EquipSet(sets['Realmrazer_' .. sfx]);
    elseif (n == 'Black Halo' or n == 'Judgment' or n == 'Judgement') then gFunc.EquipSet(sets['BlackHalo_' .. sfx]);
    elseif (n == 'Flash Nova' or n == 'Red Lotus Blade') then gFunc.EquipSet(sets.FlashNova);
    elseif (n == 'Sanguine Blade') then gFunc.EquipSet(sets.SanguineBlade);
    elseif (n == 'Armor Break' or n == 'Weapon Break') then gFunc.EquipSet(sets.StatusWS);
    else gFunc.EquipSet(sets['Resolution_' .. sfx]); end -- generic fallback
end

profile.HandleItem = function()
end

return profile;