local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');

------------------------------------------------------------
-- Warrior (WAR) profile -- GetAwayCoxn gcinclude framework,
-- populated with YOUR owned gear.
--
-- Sets you don't own gear for yet are left empty {} on purpose. In this
-- framework an empty set is a safe no-op: the handler still calls it, it
-- just doesn't swap anything. Drop owned pieces in later and they light up.
--
-- Emptied for now (no owned gear): the magic sets (Precast/Cure/Enhancing/
-- Enfeebling/Macc/Drain/Nuke), the ranged sets (Preshot/Midshot), the
-- JA-enhance sets (Warcry/Aggressor/Defender/Berserk/BloodRage), TH, and
-- the Hybrid/Acc melee + WS overlays. Tomahawk is kept (you own the axe).
--
-- WS handling: his Aeolian Edge branch is renamed to Upheaval, since that's
-- the WS you actually use. Savage Blade and Impulse Drive kept.
------------------------------------------------------------
local sets = {
    Idle = {
        Ammo = 'Staunch Tathlum',
        Head = "Sulevia's Mask +2",
        Neck = 'Sanctity Necklace',
        Ear1 = 'Cassie Earring',
        Ear2 = 'Infused Earring',
        Body = "Sulevia's Plate. +2",
        Hands = 'Sulev. Gauntlets +2',
        Ring1 = 'Gelatinous Ring +1',
        Ring2 = 'Karieyh Ring',
        Back = { Name = 'Cichol\'s Mantle', Augment = { [1] = 'Accuracy+30', [2] = '"Dbl.Atk."+10', [3] = 'Attack+20', [4] = 'DEX+20' } },
        Waist = 'Ioskeha Belt',
        Legs = 'Sulev. Cuisses +2',
        Feet = "Hermes' Sandals",
    },
    Resting = {},

    -- Auto-equips below RegenGearHPP (65%) while idle. Overlays on Idle, so
    -- it only lists what changes. Idle already wears Infused Earring; kept
    -- here per your earlier request.
    Idle_Regen = {
        Ear2 = 'Infused Earring',
    },
    Idle_Refresh = {},

    -- Auto-equips in town zones. Mirrors Idle (no weapon lock, so it won't
    -- fight you over whichever weapon you're holding).
    Town = {
        Ammo = 'Staunch Tathlum',
        Head = "Sulevia's Mask +2",
        Neck = 'Sanctity Necklace',
        Ear1 = 'Cassie Earring',
        Ear2 = 'Infused Earring',
        Body = "Sulevia's Plate. +2",
        Hands = 'Sulev. Gauntlets +2',
        Ring1 = 'Gelatinous Ring +1',
        Ring2 = 'Karieyh Ring',
        Back = { Name = 'Cichol\'s Mantle', Augment = { [1] = 'Accuracy+30', [2] = '"Dbl.Atk."+10', [3] = 'Attack+20', [4] = 'DEX+20' } },
        Waist = 'Ioskeha Belt',
        Legs = 'Sulev. Cuisses +2',
        Feet = "Hermes' Sandals",
    },

    -- /dt toggle (F9) and the framework's auto-DT (<40% HP). Full override.
    Dt = {
        Ammo = 'Staunch Tathlum',
        Head = "Sulevia's Mask +2",
        Neck = 'Sanctity Necklace',
        Ear1 = 'Cessance Earring',
        Ear2 = 'Brutal Earring',
        Body = "Sulevia's Plate. +2",
        Hands = 'Sulev. Gauntlets +2',
        Ring1 = 'Gelatinous Ring +1',
        Ring2 = 'Moonbeam Ring',
        Back = { Name = 'Cichol\'s Mantle', Augment = { [1] = 'Accuracy+30', [2] = '"Dbl.Atk."+10', [3] = 'Attack+20', [4] = 'DEX+20' } },
        Waist = 'Ioskeha Belt',
        Legs = 'Sulev. Cuisses +2',
        Feet = "Sulev. Leggins +2",
    },

    Tp_Default = {
        Ammo = 'Ginsen',
        Head = 'Flam. Zucchetto +2',
        Neck = 'Asperity Necklace',
        Ear1 = 'Cessance Earring',
        Ear2 = 'Brutal Earring',
        Body = 'Flamma Korazin +2',
        Hands = 'Sulev. Gauntlets +2',
        Ring1 = 'Petrov ring',
        Ring2 = 'Chirich ring',
        Back = { Name = 'Cichol\'s Mantle', Augment = { [1] = 'Accuracy+30', [2] = '"Dbl.Atk."+10', [3] = 'Attack+20', [4] = 'DEX+20' } },
        Waist = 'Ioskeha Belt',
        Legs = 'Pumm. Cuisses +2',
        Feet = 'Flam. Gambieras +2',
    },
    Tp_Hybrid = {},
    Tp_Acc = {},

    -- Magic sets -- empty until you own caster gear. Safe no-ops.
    Precast = {},
    Cure = {},
    Enhancing = {},
    Enfeebling = {},
    Macc = {},
    Drain = {},
    Nuke = {},

    -- Ranged sets -- empty (no owned ranged gear).
    Preshot = {},
    Midshot = {},

    -- Base WS set. Equipped for every WS; full set for any WS not named in
    -- HandleWeaponskill. Slots not listed carry over from your TP gear.
    -- Moonshade is hard-set here; the framework's DoMoonshade also runs in
    -- Default melee mode and only adds Moonshade under MoonshadeTP (2250),
    -- so this stays consistent either way.
    Ws_Default = {
        Ammo = 'Seeth. Bomblet',
        Neck = 'Fotia Gorget',
        Ear1 = 'Cessance Earring',
        Ear2 = { Name = 'Moonshade Earring', Augment = { [1] = 'Accuracy+4', [2] = 'TP Bonus +250' } },
        Ring1 = 'Petrov ring',
        Ring2 = 'Karieyh Ring',
        Hands = 'Sulev. Gauntlets +2',
        Back = { Name = 'Cichol\'s Mantle', Augment = { [1] = 'STR+30', [2] = 'Weapon skill damage +10%', [3] = 'Attack+20', [4] = 'Accuracy+20' } },
        Waist = 'Ioskeha Belt',
    },
    Ws_Hybrid = {},
    Ws_Acc = {},

    -- Upheaval (great axe): STR/VIT modifier, gains hits + Attack with TP.
    Upheaval_Default = {
        Ammo = 'Seeth. Bomblet',
        Head = "Sulevia's Mask +2",
        Neck = 'Fotia Gorget',
        Ear1 = 'Cessance Earring',
        Ear2 = { Name = 'Moonshade Earring', Augment = { [1] = 'Accuracy+4', [2] = 'TP Bonus +250' } },
        Body = "Sulevia's Plate. +2",
        Hands = 'Sulev. Gauntlets +2',
        Ring1 = 'Petrov ring',
        Ring2 = 'Karieyh Ring',
        Back = { Name = 'Cichol\'s Mantle', Augment = { [1] = 'VIT+25', [2] = 'Weapon skill damage +10%', [3] = 'Attack+20', [4] = 'Accuracy+20' } },
        Waist = 'Gunfeld Rope',
        Legs = 'Sulev. Cuisses +2',
        Feet = "Sulev. Leggins +2",
    },
    Upheaval_Hybrid = {},
    Upheaval_Acc = {},

    -- Savage Blade (sword): STR/MND, 2 hits, loves Attack.
    Savage_Default = {
        Ammo = 'Seeth. Bomblet',
        Neck = 'Fotia Gorget',
        Ear1 = 'Cessance Earring',
        Ear2 = { Name = 'Moonshade Earring', Augment = { [1] = 'Accuracy+4', [2] = 'TP Bonus +250' } },
        Ring1 = 'Petrov ring',
        Ring2 = 'Karieyh Ring',
        Hands = 'Sulev. Gauntlets +2',
        Back = { Name = 'Cichol\'s Mantle', Augment = { [1] = 'STR+30', [2] = 'Weapon skill damage +10%', [3] = 'Attack+20', [4] = 'Accuracy+20' } },
        Waist = 'Ioskeha Belt',
        Feet = "Sulev. Leggins +2",
    },
    Savage_Hybrid = {},
    Savage_Acc = {},

    -- Impulse Drive (polearm): DEX modifier, 2 hits, high crit. Rides on top
    -- of Ws_Default, so it only swaps the crit-oriented ring.
    Impulse_Default = {
        Ring2 = 'Chirich ring',
    },
    Impulse_Hybrid = {},
    Impulse_Acc = {},

    -- Owned: thrown axe for the Tomahawk merit ability.
    Tomahawk = {
        Ammo = 'Thr. Tomahawk',
    },

    -- JA-enhance sets -- empty until you own Agoge / Pummeler's / Boii.
    Warcry = {},
    Aggressor = {},
    Defender = {},
    Berserk = {},
    BloodRage = {},

    TH = {},

    Movement = {
        Feet = "Hermes' Sandals",
    },
};
profile.Sets = sets;

profile.Packer = {
    {Name = 'Thr. Tomahawk', Quantity = 'all'},
    {Name = 'Red Curry Bun', Quantity = 'all'},
};

profile.OnLoad = function()
	gSettings.AllowAddSet = true;
    gcinclude.Initialize();

    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 3');
    AshitaCore:GetChatManager():QueueCommand(1, '/macro set 10');

    gcinclude.settings.RegenGearHPP = 65;
    gcinclude.settings.RefreshGearMPP = 40;

    -- Show chat text when toggling /dt, /th, /kite, /meleeset, etc. (off by
    -- default in the framework -- this is why F9 felt silent before).
    gcinclude.settings.Messages = true;

    -- F9 toggles the DT set (same as typing /dt). State also shows on the
    -- on-screen gcdisplay HUD (green = on, red = off).
    AshitaCore:GetChatManager():QueueCommand(-1, '/bind F9 /dt');
end

profile.OnUnload = function()
    gcinclude.Unload();

    AshitaCore:GetChatManager():QueueCommand(-1, '/unbind F9');
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

    if ability.Name == 'Tomahawk' then gFunc.EquipSet(sets.Tomahawk);
    elseif ability.Name == 'Berserk' then gFunc.EquipSet(sets.Berserk);
    elseif ability.Name == 'Aggressor' then gFunc.EquipSet(sets.Aggressor);
    elseif ability.Name == 'Warcry' then gFunc.EquipSet(sets.Warcry);
    elseif ability.Name == 'Defender' then gFunc.EquipSet(sets.Defender);
    elseif ability.Name == 'Blood Rage' then gFunc.EquipSet(sets.BloodRage) end;

    gcinclude.CheckCancels();
end

profile.HandleItem = function()
    local item = gData.GetAction();

	if string.match(item.Name, 'Holy Water') then gFunc.EquipSet(gcinclude.sets.Holy_Water) end
end

profile.HandlePrecast = function()
    local spell = gData.GetAction();
    gFunc.EquipSet(sets.Precast);

    gcinclude.CheckCancels();
end

profile.HandleMidcast = function()
    local weather = gData.GetEnvironment();
    local spell = gData.GetAction();
    local target = gData.GetActionTarget();

    if (spell.Skill == 'Enhancing Magic') then
        gFunc.EquipSet(sets.Enhancing);
    elseif (spell.Skill == 'Healing Magic') then
        gFunc.EquipSet(sets.Cure);
    elseif (spell.Skill == 'Elemental Magic') then
        gFunc.EquipSet(sets.Nuke);
        if (spell.Element == weather.WeatherElement) or (spell.Element == weather.DayElement) then
            gFunc.Equip('Waist', 'Hachirin-no-Obi');
        end
    elseif (spell.Skill == 'Enfeebling Magic') then
        gFunc.EquipSet(sets.Enfeebling);
    elseif (spell.Skill == 'Dark Magic') then
        gFunc.EquipSet(sets.Macc);
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
        
        if string.match(ws.Name, 'Upheaval') then
            gFunc.EquipSet(sets.Upheaval_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Upheaval_' .. gcdisplay.GetCycle('MeleeSet')); end
            if (gcdisplay.GetCycle('MeleeSet') == 'Default') then gcinclude.DoMoonshade() end;
        elseif string.match(ws.Name, 'Savage Blade') then
            gFunc.EquipSet(sets.Savage_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Savage_' .. gcdisplay.GetCycle('MeleeSet')); end
            if (gcdisplay.GetCycle('MeleeSet') == 'Default') then gcinclude.DoMoonshade() end;
        elseif string.match(ws.Name, 'Impulse Drive') then
            gFunc.EquipSet(sets.Impulse_Default)
            if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Impulse_' .. gcdisplay.GetCycle('MeleeSet')); end
            if (gcdisplay.GetCycle('MeleeSet') == 'Default') then gcinclude.DoMoonshade() end;
        end
    end
end

return profile;