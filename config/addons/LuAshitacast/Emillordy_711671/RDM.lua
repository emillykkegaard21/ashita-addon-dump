local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');

local sets = {
    -- =========================================================
    --  IDLE / DEFENSIVE
    -- =========================================================
    Idle = {
        Ammo = 'Staunch Tathlum',
        Head = 'Aya. Zucchetto +2',
        Neck = 'Sanctity Necklace',
        Ear1 = 'Eabani Earring',
        Ear2 = 'Cessance Earring',
        Body = 'Ayanmo Corazza +2',
        Hands = 'Aya. Manopolas +2',
        Ring1 = 'Gelatinous Ring +1',
        Ring2 = 'Chirich Ring',
        Back = 'Sucellos\'s Cape',
        Waist = 'Grunfeld Rope',
        Legs = 'Aya. Cosciales +2',
        Feet = 'Aya. Gambieras +2',
    },
    Resting = {},
    Idle_Regen = {
        Neck = 'Sanctity Necklace',   -- "Regen" +2 (HP)
    },
    Idle_Refresh = {
        Body = 'Vrikodara Jupon',     -- "Refresh" +2 (also FC+5%, PDT-3%)
    },

    Town = {
        Head = 'Aya. Zucchetto +2',
        Neck = 'Sanctity Necklace',
        Body = 'Vrikodara Jupon',
        Hands = 'Aya. Manopolas +2',
        Ring1 = 'Chirich Ring',
        Ring2 = 'Petrov Ring',
        Back = 'Sucellos\'s Cape',
        Waist = 'Grunfeld Rope',
        Legs = 'Jhakri Slops +1',
        Feet = 'Aya. Gambieras +2',
    },

    Dt = {
        Ammo = 'Staunch Tathlum',
        Head = 'Aya. Zucchetto +2',
        Neck = 'Sanctity Necklace',
        Ear1 = 'Eabani Earring',
        Ear2 = 'Cessance Earring',
        Body = 'Ayanmo Corazza +2',
        Hands = 'Aya. Manopolas +2',
        Ring1 = 'Gelatinous Ring +1',
        Ring2 = 'Chirich Ring',
        Back = 'Sucellos\'s Cape',
        Waist = 'Grunfeld Rope',
        Legs = 'Aya. Cosciales +2',
        Feet = 'Aya. Gambieras +2',
    },

    -- =========================================================
    --  TP / MELEE  (your provided set)
    -- =========================================================
    Tp_Default = {
        Ammo = 'Ginsen',
        Head = 'Aya. Zucchetto +2',
        Neck = 'Asperity Necklace',
        Ear1 = 'Cessance Earring',
        Ear2 = 'Eabani Earring',
        Body = 'Ayanmo Corazza +2',
        Hands = 'Aya. Manopolas +2',
        Ring1 = 'Chirich Ring',
        Ring2 = 'Petrov Ring',
        Back = 'Sucellos\'s Cape',
        Waist = 'Grunfeld Rope',
        Legs = 'Jhakri Slops +1',
        Feet = 'Aya. Gambieras +2',
    },
    Tp_Hybrid = {
        Ammo = 'Staunch Tathlum',        -- swaps DD ammo out for DT
        Ring1 = 'Gelatinous Ring +1',    -- PDT -7%
    },
    Tp_Acc = {},   -- Tp_Default already wears all your acc gear (Ginsen/Cessance/Chirich/Asperity); nothing left to swap in

    -- =========================================================
    --  FAST CAST / PRECAST
    -- =========================================================
    Precast = {
        Head = 'Atrophy Chapeau',   -- Enhances Fast Cast (~10%), Macc+15
        Body = 'Vrikodara Jupon',   -- Fast Cast +5%
        Waist = 'Embla Sash',       -- Fast Cast +5%
    },
    Cure_Precast = {},
    Enhancing_Precast = {},
    Stoneskin_Precast = {},

    -- =========================================================
    --  HEALING MAGIC  (your provided Cure set)
    -- =========================================================
    Cure = {
        Ammo = 'Staunch Tathlum',
        Head = 'Atrophy Chapeau',
        Neck = 'Sanctity Necklace',
        Body = 'Vrikodara Jupon',
        Hands = 'Aya. Manopolas +2',
        Ring1 = 'Gelatinous Ring +1',
        Back = 'Sucellos\'s Cape',
        Waist = 'Embla Sash',
        Legs = 'Atrophy Tights',
        Feet = 'Jhakri Pigaches +2',
    },
    Self_Cure = {},
    Regen = {},
    Cursna = {},

    -- =========================================================
    --  ENHANCING MAGIC  (your provided Enhancing set)
    --  Duelist's Torque duration bonus applies only if Oboro-augmented
    -- =========================================================
    Enhancing = {
        Sub = 'Pukulatmuj',
        Ammo = 'Staunch Tathlum',
        Head = 'Atrophy Chapeau',
        Neck = 'Duelist\'s Torque',   -- Enh. duration +% (augment) over filler Asperity
        Ear1 = 'Eabani Earring',
        Body = 'Atrophy Tabard',
        Hands = 'Aya. Manopolas +2',
        Ring1 = 'Gelatinous Ring +1',
        Back = 'Sucellos\'s Cape',
        Waist = 'Embla Sash',
        Legs = 'Atrophy Tights',
        Feet = 'Jhakri Pigaches +2',
    },
    Self_Enhancing = {},
    Skill_Enhancing = {},
    Stoneskin = {},
    Phalanx = {},
    Refresh = {},
    Self_Refresh = {},

    -- =========================================================
    --  ENFEEBLING MAGIC  (your provided Enfeebling set)
    -- =========================================================
    Enfeebling = {
        Ammo = 'Staunch Tathlum',
        Head = 'Atrophy Chapeau',
        Neck = 'Duelist\'s Torque',   -- Macc+20, Enfeeb skill +5 (beats Sanctity's Macc+10)
        Body = 'Atrophy Tabard',
        Hands = 'Aya. Manopolas +2',
        Ring1 = 'Gelatinous Ring +1',
        Back = 'Sucellos\'s Cape',
        Waist = 'Embla Sash',
        Legs = 'Atrophy Tights',
        Feet = 'Jhakri Pigaches +2',
    },
    EnfeeblingACC = {
        Neck = 'Duelist\'s Torque',   -- Macc+20; also carries "Dispel"+1 onto Dispel casts (Dark Magic routes here)
        Hands = 'Jhakri Cuffs +2',    -- magic accuracy over melee Aya. Manopolas
    },
    Mind_Enfeebling = {},
    Int_Enfeebling = {},
    Potency_Enfeebling = {},

    -- =========================================================
    --  DARK MAGIC (Drain/Aspir) - built from your Jhakri pieces
    -- =========================================================
    Drain = {
        Ammo = 'Staunch Tathlum',
        Head = 'Atrophy Chapeau',
        Neck = 'Duelist\'s Torque',   -- Macc+20 to land Aspir/Drain
        Ear1 = 'Eabani Earring',
        Ear2 = 'Cessance Earring',
        Body = 'Atrophy Tabard',
        Hands = 'Jhakri Cuffs +2',
        Ring1 = 'Chirich Ring',
        Ring2 = 'Petrov Ring',
        Back = 'Sucellos\'s Cape',
        Waist = 'Embla Sash',
        Legs = 'Jhakri Slops +1',
        Feet = 'Jhakri Pigaches +2',
    },

    -- =========================================================
    --  ELEMENTAL MAGIC (Nuke) - built from your Jhakri pieces
    --  Keeps Sanctity (MAB+10) since Duelist's has no Magic Atk. Bonus
    -- =========================================================
    Nuke = {
        Ammo = 'Staunch Tathlum',
        Head = 'Atrophy Chapeau',
        Neck = 'Sanctity Necklace',
        Ear1 = 'Cessance Earring',
        Ear2 = 'Eabani Earring',
        Body = 'Atrophy Tabard',      -- MAB+7, Macc+7 (beats Vrikodara for nuking)
        Hands = 'Jhakri Cuffs +2',
        Ring1 = 'Chirich Ring',
        Ring2 = 'Petrov Ring',
        Back = 'Sucellos\'s Cape',
        Waist = 'Grunfeld Rope',
        Legs = 'Jhakri Slops +1',
        Feet = 'Jhakri Pigaches +2',
    },
    NukeACC = {},
    Burst = {},
    Helix = {},
    Mp_Body = {
        Body = 'Vrikodara Jupon',   -- MP+59 + Refresh; auto-equips when nuking under 40% MP
    },

    -- =========================================================
    --  RANGED (RDM doesn't really use this - left empty)
    -- =========================================================
    Preshot = {},
    Midshot = {},

    -- =========================================================
    --  WEAPONSKILLS  (your provided Ws_Default set)
    --  Fotia Gorget: fTP + WS acc on any skillchain WS
    -- =========================================================
    Ws_Default = {
        Ammo = 'Ginsen',
        Head = 'Aya. Zucchetto +2',
        Neck = 'Fotia Gorget',
        Ear1 = 'Eabani Earring',
        Ear2 = { Name = 'Moonshade Earring', Augment = { [1] = 'Accuracy+4', [2] = 'TP Bonus +250' } },
        Body = 'Ayanmo Corazza +2',
        Hands = 'Jhakri Cuffs +2',
        Ring1 = 'Gelatinous Ring +1',
        Ring2 = 'Karieyh Ring',
        Back = 'Sucellos\'s Cape',
        Waist = 'Grunfeld Rope',
        Legs = 'Aya. Cosciales +2',
        Feet = 'Aya. Gambieras +2',
    },
    Ws_Hybrid = {
        Ammo = 'Staunch Tathlum',        -- Ws_Default already wears the PDT ring; add DT ammo
    },
    Ws_Acc = {
        Ear1 = 'Cessance Earring',       -- Acc+6 over Eabani
        Ring1 = 'Chirich Ring',          -- Acc over Gelatinous
    },

    -- Savage Blade (STR/MND) - Moonshade for the TP bonus
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
        Legs = 'Aya. Cosciales +2',
        Feet = 'Aya. Gambieras +2',
    },
    Savage_Hybrid = {
        Ammo = 'Staunch Tathlum',
        Ring1 = 'Gelatinous Ring +1',    -- PDT over Karieyh
    },
    Savage_Acc = {
        Ring1 = 'Chirich Ring',          -- Acc over Karieyh
    },

    -- Chant du Cygne (DEX/crit/multihit)
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
        Ring1 = 'Gelatinous Ring +1',    -- PDT over Petrov
    },
    Chant_Acc = {
        Ring1 = 'Chirich Ring',          -- Acc over Petrov
    },

    -- =========================================================
    --  MISC
    -- =========================================================
    CS = {},                                 -- no Chainspell-specific gear owned
    TH = {
        Ammo = 'Per. Lucky Egg',     -- TH +1
        Head = 'Wh. Rarab Cap +1',   -- TH +1
    },
    Movement = {},   -- no movement-speed piece in your inventory
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
        if (gcdisplay.GetToggle('Fight') == false) then
            AshitaCore:GetChatManager():QueueCommand(1, '/fight') end
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Resting);
    elseif (player.IsMoving == true) then
		gFunc.EquipSet(sets.Movement);
    end
	
    gcinclude.CheckDefault ();
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
        gFunc.EquipSet(sets.EnfeeblingACC); -- mostly MACC anyways; Duelist's Torque here gives Dispel its "Dispel"+1
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