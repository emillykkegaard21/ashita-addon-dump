local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');

local weaponsLocked = false;

local sets = {
    -- =========================================================
    --  IDLE / DEFENSIVE
    -- =========================================================
    Idle = {
        Ammo = 'Staunch Tathlum',
        Head = 'Aya. Zucchetto +2',
        Neck = 'Sanctity Necklace',
        Ear1 = 'Alabaster Earring',
        Ear2 = 'Eabani Earring',
        Body = "CS Tunic +1",
        Hands = "CSM Gloves +1",
        Ring1 = 'Chirich Ring',
        Ring2 = 'Murky Ring',
        Back = 'Sucellos\'s Cape',
        Waist = 'Grunfeld Rope',
        Legs = "CS Slacks +1",
        Feet = "CSM boots +1",
    },
    Resting = {},
    Idle_Regen = {
        Ear1 = 'Infused Earring',
        Ring2 = 'Chirich Ring',
    },
    Idle_Refresh = {
        Body = 'Atrophy Tabard +1',
    },

    Town = {
        Head = 'Aya. Zucchetto +2',
        Neck = 'Sanctity Necklace',
        Body = 'Vrikodara Jupon',
        Hands = 'Aya. Manopolas +2',
        Ring1 = 'Chirich Ring',
        Ring2 = 'Murky Ring',
        Back = 'Sucellos\'s Cape',
        Waist = 'Grunfeld Rope',
        Legs = 'Jhakri Slops +1',
        Feet = 'Aya. Gambieras +2',
    },

    Dt = {
        Ammo = 'Staunch Tathlum',
        Head = 'Aya. Zucchetto +2',
        Neck = 'Sanctity Necklace',
        Ear1 = 'Cessance Earring',
        Ear2 = 'Eabani Earring',
        Body = 'Ayanmo Corazza +2',
        Hands = 'Aya. Manopolas +2',
        Ring1 = 'Gelatinous Ring +1',
        Ring2 = 'Murky Ring',
        Back = 'Sucellos\'s Cape',
        Waist = 'Grunfeld Rope',
        Legs = 'Aya. Cosciales +2',
        Feet = 'Aya. Gambieras +2',
    },

    -- =========================================================
    --  TP / MELEE
    -- =========================================================
    Tp_Default = {
        Ammo = 'Ginsen',
        Head = 'Aya. Zucchetto +2',
        Neck = 'Asperity Necklace',
        Ear1 = 'Alabaster Earring',
        Ear2 = 'Cessance Earring',
        Body = 'Ayanmo Corazza +2',
        Hands = 'Malignance Gloves',
        Ring1 = 'Chirich Ring',
        Ring2 = 'Petrov Ring',
        Back = 'Sucellos\'s Cape',
        Waist = 'Grunfeld Rope',
        Legs = 'Jhakri Slops +1',
        Feet = 'Aya. Gambieras +2',
    },
    Tp_Hybrid = {
        Body = "CS Tunic +1",
        Neck = 'Asperity Necklace',
        Ear1 = 'Alabaster Earring',
        Ring1 = 'Chirich Ring',
        Ring2 = 'Murky Ring',
        Hands = 'Malignance Gloves',
        Legs = "CS Slacks +1",
        Feet = "CSM boots +1",
    },
    Tp_Acc = {
        Body = "CS Tunic +1",
        Hands = "CSM Gloves +1",
        Legs = "CS Slacks +1",
        Feet = "CSM boots +1",
    },

    -- =========================================================
    --  FAST CAST / PRECAST
    -- =========================================================
    Precast = {
        Head = 'Atrophy Chapeau +1',
        Body = 'Vrikodara Jupon',
        Hands = 'Atrophy Gloves +1',
        Waist = 'Embla Sash',
        Ring1 = 'Weather. Ring',
    },
    Cure_Precast = {},
    Enhancing_Precast = {},
    Stoneskin_Precast = {},

    -- =========================================================
    --  HEALING MAGIC
    -- =========================================================
    Cure = {
        Ammo = 'Staunch Tathlum',
        Head = 'Atrophy Chapeau +1',
        Neck = 'Sanctity Necklace',
        Body = 'Vrikodara Jupon',
        Hands = 'Atrophy Gloves +1',
        Ring1 = 'Weather. Ring',
        Back = 'Sucellos\'s Cape',
        Waist = 'Embla Sash',
        Legs = 'Atrophy Tights +1',
        Feet = 'Jhakri Pigaches +2',
    },
    Self_Cure = {},
    Regen = {},
    Cursna = {},

    -- =========================================================
    --  ENHANCING MAGIC
    -- =========================================================
    Enhancing = {
        Sub = 'Pukulatmuj +1',
        Ammo = 'Staunch Tathlum',
        Head = 'Atrophy Chapeau +1',
        Neck = 'Duelist\'s Torque',
        Body = 'Atrophy Tabard +1',
        Hands = 'Atrophy Gloves +1',
        Ring1 = 'Weather. Ring',
        Back = 'Sucellos\'s Cape',
        Waist = 'Embla Sash',
        Legs = 'Atrophy Tights +1',
        Feet = 'Jhakri Pigaches +2',
    },
    Self_Enhancing = {},
    Skill_Enhancing = {},
    Stoneskin = {
        Sub = 'Pukulatmuj +1',
    },
    Phalanx = {},
    Refresh = {},
    Self_Refresh = {},

    -- =========================================================
    --  ENFEEBLING MAGIC
    -- =========================================================
    Enfeebling = {
        Ammo = 'Staunch Tathlum',
        Head = 'Atrophy Chapeau +1',
        Neck = 'Duelist\'s Torque',
        Body = "CS Tunic +1",
        Hands = "CSM Gloves +1",
        Ring1 = 'Weather. Ring',
        Back = 'Sucellos\'s Cape',
        Waist = 'Embla Sash',
        Legs = "CS Slacks +1",
        Feet = "CSM boots +1",
    },
    EnfeeblingACC = {
        Neck = 'Duelist\'s Torque',
        Hands = 'Jhakri Cuffs +2',
    },
    Mind_Enfeebling = {},
    Int_Enfeebling = {},
    Potency_Enfeebling = {},

    -- =========================================================
    --  DARK MAGIC (Drain/Aspir)
    -- =========================================================
    Drain = {
        Ammo = 'Staunch Tathlum',
        Head = 'Atrophy Chapeau +1',
        Neck = 'Duelist\'s Torque',
        Body = "CS Tunic +1",
        Hands = "CSM Gloves +1",
        Ring1 = 'Weather. Ring',
        Ring2 = 'Petrov Ring',
        Back = 'Sucellos\'s Cape',
        Waist = 'Embla Sash',
        Legs = "CS Slacks +1",
        Feet = "CSM boots +1",
    },

    -- =========================================================
    --  ELEMENTAL MAGIC (Nuke)
    -- =========================================================
    Nuke = {
        Ammo = 'Staunch Tathlum',
        Head = 'Atrophy Chapeau +1',
        Neck = 'Sanctity Necklace',
        Body = "CS Tunic +1",
        Hands = "CSM Gloves +1",
        Ring1 = 'Chirich Ring',
        Ring2 = 'Petrov Ring',
        Back = 'Sucellos\'s Cape',
        Waist = 'Grunfeld Rope',
        Legs = "CS Slacks +1",
        Feet = "CSM boots +1",
    },
    NukeACC = {},
    Burst = {},
    Helix = {},
    Mp_Body = {
        Body = 'Vrikodara Jupon',
    },

    -- =========================================================
    --  RANGED
    -- =========================================================
    Preshot = {},
    Midshot = {},

    -- =========================================================
    --  WEAPONSKILLS
    -- =========================================================
    Ws_Default = {
        Ammo = 'Ginsen',
        Head = 'Aya. Zucchetto +2',
        Neck = 'Fotia Gorget',
        Ear2 = { Name = 'Moonshade Earring', Augment = { [1] = 'Accuracy+4', [2] = 'TP Bonus +250' } },
        Body = 'Ayanmo Corazza +2',
        Hands = 'Jhakri Cuffs +2',
        Back = 'Sucellos\'s Cape',
        Waist = 'Grunfeld Rope',
        Legs = 'Jhakri slops +1',
        Feet = 'Jhakri Pigaches +2'
    },
    Ws_Hybrid = {
        Ammo = 'Staunch Tathlum',
    },
    Ws_Acc = {
        Ear1 = 'Cessance Earring',
        Ring1 = 'Chirich Ring',
    },

    -- Savage Blade
    Savage_Default = {
        Ammo = 'Ginsen',
        Head = 'Aya. Zucchetto +2',
        Neck = 'Fotia Gorget',
        Ear1 = 'Cessance Earring',
        Ear2 = { Name = 'Moonshade Earring', Augment = { [1] = 'Accuracy+4', [2] = 'TP Bonus +250' } },
        Body = 'Ayanmo Corazza +2',
        Hands = 'Jhakri Cuffs +2',
        Ring1 = 'Karieyh Ring',
        Ring2 = 'Petrov Ring',
        Back = 'Sucellos\'s Cape',
        Waist = 'Grunfeld Rope',
        Legs = 'Jhakri slops +1',
        Feet = 'Jhakri Pigaches +2',
    },
    Savage_Hybrid = {
        Ammo = 'Staunch Tathlum',
        Ring1 = 'Gelatinous Ring +1',
    },
    Savage_Acc = {
        Ring1 = 'Chirich Ring',
    },

    -- Chant du Cygne
    Chant_Default = {
        Ammo = 'Ginsen',
        Head = 'Aya. Zucchetto +2',
        Neck = 'Fotia Gorget',
        Ear1 = 'Cessance Earring',
        Ear2 = { Name = 'Moonshade Earring', Augment = { [1] = 'Accuracy+4', [2] = 'TP Bonus +250' } },
        Body = 'Ayanmo Corazza +2',
        Hands = 'Jhakri Cuffs +2',
        Ring1 = 'Petrov Ring',
        Ring2 = 'Karieyh Ring',
        Back = 'Sucellos\'s Cape',
        Waist = 'Grunfeld Rope',
        Legs = 'Aya. Cosciales +2',
        Feet = 'Aya. Gambieras +2',
    },
    Chant_Hybrid = {
        Ammo = 'Staunch Tathlum',
        Ring1 = 'Gelatinous Ring +1',
    },
    Chant_Acc = {
        Ring1 = 'Chirich Ring',
    },

    -- =========================================================
    --  MISC
    -- =========================================================
    CS = {},
    TH = {
        Ammo = 'Per. Lucky Egg',
        Head = 'Wh. Rarab Cap +1',
    },
    Movement = {},
};
profile.Sets = sets;

profile.Packer = {
    {Name = 'Tropical Crepe', Quantity = 'all'},
    {Name = 'Rolan. Daifuku', Quantity = 'all'},
};

profile.OnLoad = function()
	gSettings.AllowAddSet = true;
    gcinclude.Initialize();

    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 1');
    AshitaCore:GetChatManager():QueueCommand(1, '/macro set 10');
end

profile.OnUnload = function()
    gcinclude.Unload();
end

profile.HandleCommand = function(args)
    gcinclude.HandleCommands(args);
end

profile.HandleDefault = function()
    gFunc.EquipSet(sets.Idle);

    local player = gData.GetPlayer();
    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.Tp_Default)
        if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Tp_' .. gcdisplay.GetCycle('MeleeSet')) end
        if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end

        -- lock weapon slots ONCE on engage
        if (weaponsLocked == false) then
            AshitaCore:GetChatManager():QueueCommand(-1, '/lac disable Main');
            AshitaCore:GetChatManager():QueueCommand(-1, '/lac disable Sub');
            AshitaCore:GetChatManager():QueueCommand(-1, '/lac disable Range');
            weaponsLocked = true;
        end
    else
        -- unlock weapon slots ONCE when we stop fighting
        if (weaponsLocked == true) then
            AshitaCore:GetChatManager():QueueCommand(-1, '/lac enable Main');
            AshitaCore:GetChatManager():QueueCommand(-1, '/lac enable Sub');
            AshitaCore:GetChatManager():QueueCommand(-1, '/lac enable Range');
            weaponsLocked = false;
        end

        if (player.Status == 'Resting') then
            gFunc.EquipSet(sets.Resting);
        elseif (player.IsMoving == true) then
            gFunc.EquipSet(sets.Movement);
        end
    end

    gcinclude.CheckDefault();
    if (gcdisplay.GetToggle('DTset') == true) then gFunc.EquipSet(sets.Dt) end;
    if (gcdisplay.GetToggle('Kite') == true) then gFunc.EquipSet(sets.Movement) end;
end

profile.HandleAbility = function()
    local ability = gData.GetAction();

    if ability.Name == 'Chainspell' then
        gFunc.EquipSet(sets.CS);
    end

    gcinclude.CheckCancels();
end

profile.HandleItem = function()
    local item = gData.GetAction();

	if string.match(item.Name, 'Holy Water') then gFunc.EquipSet(gcinclude.sets.Holy_Water) end
end

profile.HandlePrecast = function()
    local spell = gData.GetAction();
    gFunc.EquipSet(sets.Precast)

    if (spell.Skill == 'Enhancing Magic') then
        gFunc.EquipSet(sets.Enhancing_Precast);

        if string.contains(spell.Name, 'Stoneskin') then
            gFunc.EquipSet(sets.Stoneskin_Precast);
        end
    elseif (spell.Skill == 'Healing Magic') then
        gFunc.EquipSet(sets.Cure_Precast);
    end

    gcinclude.CheckCancels();
end

profile.HandleMidcast = function()
    local weather = gData.GetEnvironment();
    local spell = gData.GetAction();
    local target = gData.GetActionTarget();
    local me = AshitaCore:GetMemoryManager():GetParty():GetMemberName(0);
    local player = gData.GetPlayer();

    if (spell.Skill == 'Enhancing Magic') then
        gFunc.EquipSet(sets.Enhancing);
        if (target.Name == me) then
            gFunc.EquipSet(sets.Self_Enhancing);
        end

        if string.match(spell.Name, 'Phalanx') then
            gFunc.EquipSet(sets.Phalanx);
        elseif string.match(spell.Name, 'Stoneskin') then
            gFunc.EquipSet(sets.Stoneskin);
        elseif string.contains(spell.Name, 'Temper') then
            gFunc.EquipSet(sets.Skill_Enhancing);
        elseif string.contains(spell.Name, 'Regen') then
            gFunc.EquipSet(sets.Regen);
        elseif string.contains(spell.Name, 'Refresh') then
            gFunc.EquipSet(sets.Refresh);
            if (target.Name == me) then
                gFunc.EquipSet(sets.Self_Refresh);
            end
        elseif (target.Name == me) and string.contains(spell.Name, 'En') then
            gFunc.EquipSet(sets.Skill_Enhancing);
        end
    elseif (spell.Skill == 'Healing Magic') then
        gFunc.EquipSet(sets.Cure);
        if (target.Name == me) then
            gFunc.EquipSet(sets.Self_Cure);
        end
        if string.match(spell.Name, 'Cursna') then
            gFunc.EquipSet(sets.Cursna);
        end
    elseif (spell.Skill == 'Elemental Magic') then
        gFunc.EquipSet(sets.Nuke);

        if (gcdisplay.GetToggle('NukeSet') == 'Macc') then
            gFunc.EquipSet(sets.NukeACC);
        end
        if (gcdisplay.GetToggle('Burst') == true) then
            gFunc.EquipSet(sets.Burst);
        end
        if (spell.Element == weather.WeatherElement) or (spell.Element == weather.DayElement) then
            gFunc.Equip('Waist', 'Hachirin-no-Obi');
        end
        if string.match(spell.Name, 'helix') then
            gFunc.EquipSet(sets.Helix);
        end
        if (player.MPP <= 40) then
            gFunc.EquipSet(sets.Mp_Body);
        end
    elseif (spell.Skill == 'Enfeebling Magic') then
        gFunc.EquipSet(sets.Enfeebling);
        if (gcdisplay.GetToggle('NukeSet') == 'Macc') then
            gFunc.EquipSet(sets.EnfeeblingACC);
        end
        if string.contains(spell.Name, 'Paralyze') or string.contains(spell.Name, 'Slow') or string.contains(spell.Name, 'Addle') then
            gFunc.EquipSet(sets.Mind_Enfeebling);
        elseif string.contains(spell.Name, 'Poison') then
            gFunc.EquipSet(sets.Int_Enfeebling);
        elseif string.contains(spell.Name, 'Distract') or string.match(spell.Name, 'Frazzle III') then
            gFunc.EquipSet(sets.Potency_Enfeebling);
        end
    elseif (spell.Skill == 'Dark Magic') then
        gFunc.EquipSet(sets.EnfeeblingACC);
        if (string.contains(spell.Name, 'Aspir') or string.contains(spell.Name, 'Drain')) then
            gFunc.EquipSet(sets.Drain);
        end
    end
	if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
end

profile.HandlePreshot = function()
    gFunc.EquipSet(sets.Preshot);
end

profile.HandleMidshot = function()
    gFunc.EquipSet(sets.Midshot);
	if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
end

profile.HandleWeaponskill = function()
    local canWS = gcinclude.CheckWsBailout();
    if (canWS == false) then gFunc.CancelAction() return;
    else
        local ws = gData.GetAction();
    
        gFunc.EquipSet(sets.Ws_Default)
        if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
        gFunc.EquipSet('Ws_' .. gcdisplay.GetCycle('MeleeSet')) end
   
        if string.match(ws.Name, 'Chant du Cygne') then
            gFunc.EquipSet(sets.Chant_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Chant_' .. gcdisplay.GetCycle('MeleeSet')); end
	    elseif string.match(ws.Name, 'Savage Blade') then
            gFunc.EquipSet(sets.Savage_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Savage_' .. gcdisplay.GetCycle('MeleeSet')); end
        end
    end
end

return profile;