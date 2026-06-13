local profile = {};
gcinclude = gFunc.LoadFile('common\\gcinclude.lua');

------------------------------------------------------------
-- Warrior (WAR) luashitacast profile  --  gcinclude version
--
-- Same framework wiring as the reference, but every set below is filled
-- ONLY with gear from your old profile (the stuff you actually own).
-- Sets you have no gear for yet are left empty {} -- they're safe no-ops,
-- so the framework can still call them; they just won't swap anything
-- until you drop owned pieces in.
--
-- Removed vs the file you pasted (because your old profile had none of
-- this gear): all the magic-casting sets + HandlePrecast/HandleMidcast,
-- the ranged Preshot/Midshot sets, the JA-enhance sets (Warcry / Aggressor
-- / Defender / Berserk / Blood Rage -- those want Agoge / Pummeler's /
-- Boii), and the TH gear. Ask me and I'll add any of them back as you
-- collect the gear.
--
-- WS sets: Savage Blade / Upheaval / Impulse Drive are now split out as
-- per-WS overlays (see the Ws_* block and HandleWeaponskill below).
------------------------------------------------------------
local sets = {
    -- Not engaged. Your survivability set.
    Idle = {
        Ammo = 'Staunch Tathlum',
        Head = "Sulevia's Mask +2",
        Neck = 'Sanctity Necklace',
        Ear1 = 'Cassie Earring',
        Ear2 = 'Cessance Earring',
        Body = "Sulevia's Plate. +2",
        Hands = 'Sulev. Gauntlets +2',
        Ring1 = 'Moonbeam Ring',
        Ring2 = 'Gelatinous Ring +1',
        Back = { Name = 'Cichol\'s Mantle', Augment = { [1] = 'Accuracy+30', [2] = '"Dbl.Atk."+10', [3] = 'Attack+20', [4] = 'DEX+20' } },
        Waist = 'Ioskeha Belt',
        Legs = 'Sulev. Cuisses +2',
        Feet = "Hermes' Sandals",
    },
    Resting = {},

    -- Auto-equipped by the framework while idle, below the HP/MP % set in
    -- OnLoad. Empty for now -- you don't own dedicated regen/refresh gear.
    Idle_Regen = {},
    Idle_Refresh = {},

    -- Auto-equipped in town zones. Just your movement feet.
    Town = {
        Feet = "Hermes' Sandals",
    },

    -- Damage-taken set. Doubles as the framework's auto-DT (<40% HP) and
    -- the /dt toggle. This is your old defensive Idle.
    Dt = {
        Ammo = 'Staunch Tathlum',
        Head = "Sulevia's Mask +2",
        Neck = 'Sanctity Necklace',
        Ear1 = 'Cessance Earring',
        Ear2 = 'Brutal Earring',
        Body = "Sulevia's Plate. +2",
        Hands = 'Sulev. Gauntlets +2',
        Ring1 = 'Moonbeam Ring',
        Ring2 = 'Gelatinous Ring +1',
        Back = { Name = 'Cichol\'s Mantle', Augment = { [1] = 'Accuracy+30', [2] = '"Dbl.Atk."+10', [3] = 'Attack+20', [4] = 'DEX+20' } },
        Waist = 'Ioskeha Belt',
        Legs = 'Sulev. Cuisses +2',
        Feet = "Sulev. Leggins +2",
    },

    -- Engaged offense. Your old TP set.
    Tp_Default = {
        Ammo = 'Ginsen',
        Head = 'Flam. Zucchetto +2',
        Neck = 'Asperity Necklace',
        Ear1 = 'Cessance Earring',
        Ear2 = 'Brutal Earring',
        Body = 'Flamma Korazin +2',
        Hands = 'Sulev. Gauntlets +2',
        Ring1 = 'Moonbeam Ring',
        Ring2 = 'Chirich Ring',
        Back = { Name = 'Cichol\'s Mantle', Augment = { [1] = 'Accuracy+30', [2] = '"Dbl.Atk."+10', [3] = 'Attack+20', [4] = 'DEX+20' } },
        Waist = 'Ioskeha Belt',
        Legs = 'Sulev. Cuisses +2',
        Feet = 'Flam. Gambieras +2',
    },
    -- Overlays on top of Tp_Default when you /meleeset off Default.
    -- Hybrid is empty (no owned defensive-DD pieces). Acc swaps in the
    -- accuracy ammo you said you have (the non-+1 Seeth. Bomblet).
    Tp_Hybrid = {},
    Tp_Acc = {
        Ammo = 'Seeth. Bomblet',
    },

    ------------------------------------------------------------
    -- Weaponskill sets.
    --
    -- Ws_Default is the BASE set: HandleWeaponskill equips it for every WS,
    -- and it's the full set for any WS not named below. It only lists the
    -- slots that should change vs your TP set -- the rest carry over from
    -- whatever you're wearing when the WS fires (your TP gear).
    --
    -- Savage / Upheaval / Impulse are thin overlays that ride on TOP of
    -- Ws_Default, so each only lists the slots it changes. With your current
    -- gear they're nearly identical (you mostly own generic STR weaponskill
    -- gear), so the differences are small for now -- the structure is here
    -- so you can tune each one as you pick up WS-specific pieces.
    ------------------------------------------------------------
    Ws_Default = {
        Neck = 'Fotia Gorget',
        Ear1 = 'Cessance Earring',
        Ear2 = { Name = 'Moonshade Earring', Augment = { [1] = 'Accuracy+4', [2] = 'TP Bonus +250' } },
        Ring2 = 'Karieyh Ring',
        Hands = 'Sulev. Gauntlets +2',
        Back = { Name = 'Cichol\'s Mantle', Augment = { [1] = 'STR+30', [2] = 'Weapon skill damage +10%', [3] = 'Attack+20', [4] = 'Accuracy+20' } },
        Waist = 'Thunder Belt',
    },
    Ws_Hybrid = {},
    Ws_Acc = {},

    -- Savage Blade (sword): STR + MND modifier, 2 hits, loves Attack.
    -- Brutal's Double Attack helps land the extra swing. No owned MND/STR
    -- WS pieces beyond what's already here, so it mirrors the base set.
    Savage = {
        Neck = 'Fotia Gorget',
        Ear1 = 'Cessance Earring',
        Ear2 = { Name = 'Moonshade Earring', Augment = { [1] = 'Accuracy+4', [2] = 'TP Bonus +250' } },
        Ring2 = 'Karieyh Ring',
        Hands = 'Sulev. Gauntlets +2',
        Back = { Name = 'Cichol\'s Mantle', Augment = { [1] = 'STR+30', [2] = 'Weapon skill damage +10%', [3] = 'Attack+20', [4] = 'Accuracy+20' } },
        Waist = 'Thunder Belt',
        Feet = "Sulev. Leggins +2",
    },

    -- Upheaval (great axe): STR modifier; gains hits and Attack the higher
    -- your TP is. Same STR-stacking approach as Savage.
    Upheaval = {
        Ammo = 'Seeth. Bomblet',
        Head = "Sulevia's Mask +2",
        Neck = 'Fotia Gorget',
        Ear1 = 'Cessance Earring',
        Ear2 = { Name = 'Moonshade Earring', Augment = { [1] = 'Accuracy+4', [2] = 'TP Bonus +250' } }
        Body = "Sulevia's Plate. +2",
        Hands = 'Sulev. Gauntlets +2',
        Ring1 = 'Moonbeam Ring',
        Ring2 = 'Karieyh Ring',
        Back = { Name = 'Cichol\'s Mantle', Augment = { [1] = 'VIT+30', [2] = 'Weapon skill damage +10%', [3] = 'Attack+20', [4] = 'Accuracy+20' } },
        Waist = 'Ioskeha Belt',
        Legs = 'Sulev. Cuisses +2',
        Feet = "Sulev. Leggins +2",
    },

    -- Impulse Drive (polearm): DEX modifier, 2 hits, very high crit rate.
    Impulse = {
        Ring2 = 'Chirich Ring',
    },

    -- Tomahawk (lv75 WAR merit ability): just needs the thrown axe in Ammo.
    -- Name matches your Packer entry / the framework's working string.
    Tomahawk = {
        Ammo = 'Thr. Tomahawk',
    },

    -- Empty so the framework's TH toggle has a set to call without erroring.
    -- Fill if you get TH gear (e.g. a TH ammo / Chaac Belt).
    TH = {},

    Movement = {
        Feet = "Hermes' Sandals",
    },
};
profile.Sets = sets;

profile.Packer = {
    { Name = 'Thr. Tomahawk', Quantity = 'all' },
    { Name = 'Red Curry Bun', Quantity = 'all' },
};

------------------------------------------------------------
-- Ring helpers
------------------------------------------------------------
local function useBonusRing(ringName, label)
    local mgr = AshitaCore:GetChatManager();
    mgr:QueueCommand(1, '/lac equip ring2 "' .. ringName .. '"');
    mgr:QueueCommand(1, '/lac disable ring2');

    local function fire()
        AshitaCore:GetChatManager():QueueCommand(1, '/item "' .. ringName .. '" <me>');
        local function restore()
            AshitaCore:GetChatManager():QueueCommand(1, '/lac enable ring2');
        end
        restore:once(4);
    end
    fire:once(6);

    print('[WAR] Activating ' .. label .. ' (' .. ringName .. '). Buff stays on after the swap-back.');
end

-- Teleport/warp rings: must be WORN a few seconds to charge before they
-- fire, then a cast you hold still through. chargeSecs = equip delay (the
-- last number in the ring's <.../[reuse, equip-delay]> description; raise
-- it if a use fails with "cannot use yet"). castSecs = hold-still time.
local function useTeleportRing(ringName, label, chargeSecs, castSecs)
    local mgr = AshitaCore:GetChatManager();
    mgr:QueueCommand(1, '/lac equip ring2 "' .. ringName .. '"');
    mgr:QueueCommand(1, '/lac disable ring2');

    local function fire()
        AshitaCore:GetChatManager():QueueCommand(1, '/item "' .. ringName .. '" <me>');
        local function restore()
            AshitaCore:GetChatManager():QueueCommand(1, '/lac enable ring2');
        end
        restore:once(castSecs);
    end
    fire:once(chargeSecs);

    print('[WAR] ' .. label .. '... hold still for ~' .. chargeSecs .. 's.');
end

------------------------------------------------------------
-- Ring registries.  To add a ring you can use, add ONE row here, then add
-- a matching alias in OnLoad / OnUnload below. The command key (the left
-- side, e.g. ['holla']) is what HandleCommand matches on.
--
--   teleRings  = must charge while worn, then cast (warp + crag rings).
--                charge = equip delay (raise if "cannot use yet"),
--                cast   = hold-still time before swapping back.
--   bonusRings = instant use, buff persists after the ring comes off.
-- Commented rows are common examples -- verify the exact item name and,
-- for teleports, the timings before enabling.
------------------------------------------------------------
local teleRings = {
    ['warp']  = { name = 'Warp Ring',         label = 'Warping',              charge = 11, cast = 8 },
    ['holla'] = { name = 'Dim. Ring (Holla)', label = 'Teleporting to Holla', charge = 11, cast = 8 },
    -- ['dem'] = { name = 'Dim. Ring (Dem)',  label = 'Teleporting to Dem',   charge = 11, cast = 8 },
    -- ['mea'] = { name = 'Dim. Ring (Mea)',  label = 'Teleporting to Mea',   charge = 11, cast = 8 },
};

local bonusRings = {
    ['echad']  = { name = 'Echad ring',  label = 'EXP bonus' },
    ['trizek'] = { name = 'Trizek Ring', label = 'Capacity bonus' },
    -- ['endorse']  = { name = 'Endorsement Ring', label = 'EXP bonus' },
    -- ['capacity'] = { name = 'Capacity Ring',    label = 'Capacity bonus' },
};

profile.OnLoad = function()
    gSettings.AllowAddSet = true;

    -- Drop the framework's built-in /warpring and /telering so they don't
    -- duplicate our own /warp and crag-ring commands. Done BEFORE
    -- Initialize (which wires the framework aliases on a short delay).
    -- Removing them from AliasList disables both the alias and the handler,
    -- and the framework's own cleanup on unload stays in sync.
    for i = #gcinclude.AliasList, 1, -1 do
        local v = gcinclude.AliasList[i];
        if (v == 'warpring') or (v == 'telering') then
            table.remove(gcinclude.AliasList, i);
        end
    end

    gcinclude.Initialize();

    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 3');  -- TODO: confirm your WAR macro book
    AshitaCore:GetChatManager():QueueCommand(1, '/macro set 10');  -- TODO: confirm your WAR macro page

    gcinclude.settings.RegenGearHPP = 65;
    gcinclude.settings.RefreshGearMPP = 40;

    -- Ring aliases.  /warp /holla = teleport,  /xp = Echad,  /cp = Trizek
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /warp /lac fwd warp');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /holla /lac fwd holla');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /xp /lac fwd echad');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /cp /lac fwd trizek');
end

profile.OnUnload = function()
    gcinclude.Unload();

    AshitaCore:GetChatManager():QueueCommand(-1, '/alias del /warp');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias del /holla');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias del /xp');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias del /cp');
end

profile.HandleCommand = function(args)
    local cmd = string.lower(args[1] or '');

    if (teleRings[cmd] ~= nil) then
        local r = teleRings[cmd];
        useTeleportRing(r.name, r.label, r.charge, r.cast);
    elseif (bonusRings[cmd] ~= nil) then
        local r = bonusRings[cmd];
        useBonusRing(r.name, r.label);
    end

    gcinclude.HandleCommands(args);
end

profile.HandleDefault = function()
    gFunc.EquipSet(sets.Idle);

    local player = gData.GetPlayer();
    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.Tp_Default);
        if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
            gFunc.EquipSet('Tp_' .. gcdisplay.GetCycle('MeleeSet')) end
        if (gcdisplay.GetToggle('TH') == true) then gFunc.EquipSet(sets.TH) end
    elseif (player.Status == 'Resting') then
        gFunc.EquipSet(sets.Resting);
    elseif (player.IsMoving == true) then
        gFunc.EquipSet(sets.Movement);
    end

    gcinclude.CheckDefault();
    if (gcdisplay.GetToggle('DTset') == true) then gFunc.EquipSet(sets.Dt) end;
    if (gcdisplay.GetToggle('Kite') == true) then gFunc.EquipSet(sets.Movement) end;
end

profile.HandleAbility = function()
    local ability = gData.GetAction();

    if ability.Name == 'Tomahawk' then gFunc.EquipSet(sets.Tomahawk);
    -- Re-enable these once you own the JA-enhance gear and add the sets:
    -- elseif ability.Name == 'Berserk'    then gFunc.EquipSet(sets.Berserk);
    -- elseif ability.Name == 'Aggressor'  then gFunc.EquipSet(sets.Aggressor);
    -- elseif ability.Name == 'Warcry'     then gFunc.EquipSet(sets.Warcry);
    -- elseif ability.Name == 'Defender'   then gFunc.EquipSet(sets.Defender);
    -- elseif ability.Name == 'Blood Rage' then gFunc.EquipSet(sets.BloodRage);
    end

    gcinclude.CheckCancels();
end

profile.HandleWeaponskill = function()
    local ws = gData.GetAction();

    if (gcinclude.CheckWsBailout() == false) then
        gFunc.CancelAction();
        return;
    end

    -- Base WS set (applies to every weaponskill, and is the full set for any
    -- WS not named below).
    gFunc.EquipSet(sets.Ws_Default);

    -- Per-weaponskill overlay.
    if (ws.Name == 'Savage Blade') then gFunc.EquipSet(sets.Savage);
    elseif (ws.Name == 'Upheaval') then gFunc.EquipSet(sets.Upheaval);
    elseif (ws.Name == 'Impulse Drive') then gFunc.EquipSet(sets.Impulse);
    end

    -- Melee-cycle overlay (Hybrid / Acc) if you've toggled MeleeSet off
    -- Default. Rides on top so an Acc/Hybrid toggle still wins.
    if (gcdisplay.GetCycle('MeleeSet') ~= 'Default') then
        gFunc.EquipSet('Ws_' .. gcdisplay.GetCycle('MeleeSet'));
    end
end

return profile;