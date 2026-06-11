local profile = {};

------------------------------------------------------------
-- Warrior (WAR) luashitacast profile
--
-- The ring / teleport helpers are job-agnostic and carry over
-- unchanged. The gear is now organised around a melee DD:
--
--   Idle  -> worn when NOT engaged (survivability / damage taken)
--   TP    -> worn when engaged + single wield, offense
--   TP_DW -> worn when engaged + dual wield, offense (needs /NIN or /DNC)
--   WS    -> overlaid on top of the engaged set on weaponskills
--
-- Two in-game toggles drive which engaged set you get:
--   F9  -> tank mode on/off  (offense  <-> defense / off-tank)
--   F10 -> dual wield on/off (single wield <-> dual wield)
--
-- Gear note: every piece in the TP / Idle / WS sets below is something
-- this character already owned on PLD. The TP_DW set is a copy of TP as
-- a starting point -- the slots that normally carry Dual Wield+ are
-- flagged inline so you can swap in whatever DW gear you own/pick up.
------------------------------------------------------------
local sets = {
    ['TP'] = {
        Ammo = 'Ginsen',
        Head = 'Flam. Zucchetto +2',
        Neck = 'Asperity Necklace',
        Ear1 = 'Bladeborn Earring',
        Ear2 = 'Steelflash Earring',
        Body = 'Flamma Korazin +2',
        Hands = 'Sulev. Gauntlets +2',
        Ring1 = 'Moonbeam Ring',
        Ring2 = 'Chirich Ring',
        Back = "Cichol's mantle",
        Waist = 'Ioskeha belt',
        Legs = 'Sulev. Cuisses +2',
        Feet = 'Flam. Gambieras +2',
    },
    -- Dual-wield engaged set (worn when DW mode is on -- requires /NIN or /DNC
    -- for the Dual Wield trait). Right now this is just a copy of TP so it
    -- works out of the box; replace the flagged slots with Dual Wield+ pieces
    -- you own so you actually hit your delay cap. Common DW slots:
    --   Ear1/Ear2 -> Suppanomimi, Eabani Earring, etc. (the sword procs do
    --                nothing useful when you're dual wielding non-swords)
    --   Waist     -> Reiki Yotai and similar DW belts
    --   Body      -> some bodies carry Dual Wield+
    -- Anything you leave as-is below just behaves like your TP set.
    ['TP_DW'] = {
        Ammo = 'Ginsen',
        Head = 'Flam. Zucchetto +2',
        Neck = 'Asperity Necklace',
        Ear1 = 'Eabani Earring',   -- TODO: swap to a Dual Wield earring you own
        Ear2 = 'Cessance Earring',  -- TODO: swap to a Dual Wield earring you own
        Body = 'Flamma Korazin +2',
        Hands = 'Flam. Manopolas +2',
        Ring1 = 'Moonbeam Ring',
        Ring2 = 'Chirich Ring',
        Back = "Cichol's mantle",
        Waist = 'Ioskeha belt',     -- TODO: swap to a Dual Wield belt if you have one
        Legs = 'Sulev. Cuisses +2',
        Feet = 'Flam. Gambieras +2',
    },
    -- Worn whenever you are NOT engaged (idle / resting). Leans on your
    -- Sulevia set + Staunch Tathlum for damage reduction and HP. Also
    -- doubles as the defensive engaged set when tank mode is on (below).
    ['Idle'] = {
        Ammo = 'Staunch Tathlum',
        Head = "Sulevia's Mask +2",
        Neck = 'Sanctity Necklace',
        Ear1 = 'Cassie Earring',
        Ear2 = 'Cessance Earring',
        Body = "Sulevia's Plate. +2",
        Hands = 'Sulev. Gauntlets +2',
        Ring1 = 'Moonbeam Ring',
        Ring2 = 'Gelatinous Ring +1',
        Back = "Cichol's mantle",
        Waist = 'Ioskeha belt',
        Legs = 'Sulev. Cuisses +2',
        Feet = "Hermes' Sandals",
    },
    -- Partial set: only the slots listed here get swapped on a WS, the
    -- rest stays as whatever your engaged set already had on.
    ['WS'] = {
        Neck = 'Fotia Gorget',
        Ear1 = { Name = 'Moonshade Earring', Augment = { [1] = 'Accuracy+4', [2] = 'TP Bonus +250' } },
        Ring2 = 'Karieyh Ring',
        Hands = 'Sulev. Gauntlets +2',
        Back = "Cichol's mantle",
        Waist = 'Thunder Belt',
    },
};
profile.Sets = sets;

------------------------------------------------------------
-- Engaged-mode switches.
--
--   tankMode  (F9)  : false = offense, true = defense / off-tank
--   dualWield (F10) : false = single wield, true = dual wield
--
-- WAR is set up as a DD, so both default off (offense + single wield).
-- Toggle in game with the F-keys (bound in OnLoad) or manually:
--   /lac fwd tank
--   /lac fwd dw
--
-- (If you later pick up dedicated enmity gear, copy the Idle set to a
--  new 'Tank' set, tune it, and point the tankMode branch below at it.)
------------------------------------------------------------
local tankMode = false;
local dualWield = false;

------------------------------------------------------------
-- Helper: activate an enchanted bonus ring (Echad / Trizek).
--
-- These are NOT like the teleport rings. They have no charge delay, and
-- the buff they grant (Dedication for Echad, Commitment for Trizek) sticks
-- around even after you take the ring off. So the flow is just:
--   1. equip the ring in ring2
--   2. lock the slot briefly so an idle/engaged swap can't strip it
--      before the /item lands
--   3. wait for the equip to register, then use it
--   4. unlock so your normal ring2 comes back -- the buff stays on
--
-- The waits below are deliberately generous to ride out lag. If a use ever
-- still fails ("you do not have that item equipped"), bump the first
-- :once() up another second or two.
------------------------------------------------------------
local function useBonusRing(ringName, label)
    local mgr = AshitaCore:GetChatManager();
    mgr:QueueCommand(1, '/lac equip ring2 "' .. ringName .. '"'); -- put the ring on
    mgr:QueueCommand(1, '/lac disable ring2');                    -- lock the slot

    local function fire()
        AshitaCore:GetChatManager():QueueCommand(1, '/item "' .. ringName .. '" <me>'); -- activate it
        local function restore()
            AshitaCore:GetChatManager():QueueCommand(1, '/lac enable ring2');           -- unlock; normal ring returns
        end
        restore:once(4); -- buffer so the /item fully resolves before we swap back
    end
    fire:once(6); -- let the equip register before using

    print('[WAR] Activating ' .. label .. ' (' .. ringName .. '). Buff stays on after the swap-back.');
end

------------------------------------------------------------
-- Helper: use a teleport/warp enchantment ring.
--
-- Unlike the bonus rings above, these must be WORN for a few seconds to
-- "charge" before the enchantment can fire, and the cast itself takes a
-- moment during which you must hold still. So the flow is:
--   1. equip the ring in ring2
--   2. lock the slot so an idle/engaged swap can't strip it mid-charge
--   3. wait out the charge delay, then use it
--   4. wait out the cast, then unlock so normal gear returns
--
-- chargeSecs = how long the ring must be equipped before it's usable.
--   You can read the exact value off the ring in-game: its description
--   ends in <.../[reuse, equip-delay]> and the equip-delay is the LAST
--   number. The enchantment text turns blue when it's ready. If a teleport
--   ever fails with "cannot use yet," raise chargeSecs to match.
-- castSecs   = how long to hold still while it casts before swapping back.
------------------------------------------------------------
local function useTeleportRing(ringName, label, chargeSecs, castSecs)
    local mgr = AshitaCore:GetChatManager();
    mgr:QueueCommand(1, '/lac equip ring2 "' .. ringName .. '"'); -- put the ring on
    mgr:QueueCommand(1, '/lac disable ring2');                    -- lock the slot while it charges

    local function fire()
        AshitaCore:GetChatManager():QueueCommand(1, '/item "' .. ringName .. '" <me>'); -- ring is ready, use it
        local function restore()
            AshitaCore:GetChatManager():QueueCommand(1, '/lac enable ring2');           -- unlock; normal gear returns
        end
        restore:once(castSecs); -- after the cast finishes
    end
    fire:once(chargeSecs); -- wait out the ring's equip/charge delay

    print('[WAR] ' .. label .. '... hold still for ~' .. chargeSecs .. 's.');
end

------------------------------------------------------------
-- Load / Unload
------------------------------------------------------------
profile.OnLoad = function()
    gSettings.AllowAddSet = true;   -- lets you keep using /lac addset to build new sets
    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 1');  -- TODO: set this to your WAR macro book
    AshitaCore:GetChatManager():QueueCommand(1, '/macro set 1');   -- TODO: set this to your WAR macro page

    -- Convenience aliases
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /warp /lac fwd warp');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /holla /lac fwd holla');    -- Dimensional Ring (Holla)
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /xp /lac fwd echad');   -- Echad Ring  (EXP)
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /cp /lac fwd trizek'); -- Trizek Ring (Capacity)

    -- Mode toggle keybinds.
    --   F9  -> tank on/off    F10 -> dual wield on/off
    -- Note: FFXI may already use some F-keys; if a key doesn't fire, pick
    -- another (e.g. ^F9 = Ctrl+F9, !F9 = Alt+F9) and update OnUnload to match.
    AshitaCore:GetChatManager():QueueCommand(-1, '/bind F9 /lac fwd tank');
    AshitaCore:GetChatManager():QueueCommand(-1, '/bind F10 /lac fwd dw');
end

profile.OnUnload = function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias del /warp');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias del /holla');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias del /xp');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias del /cp');

    AshitaCore:GetChatManager():QueueCommand(-1, '/unbind F9');
    AshitaCore:GetChatManager():QueueCommand(-1, '/unbind F10');
end

------------------------------------------------------------
-- Custom commands forwarded with  /lac fwd ...
------------------------------------------------------------
profile.HandleCommand = function(args)
    local cmd = string.lower(args[1] or '');

    if (cmd == 'tank') then
        tankMode = not tankMode;
        if (tankMode) then
            print('[WAR] Tank mode ON  -> engaged set: Idle (defense / off-tank)');
        else
            print('[WAR] Tank mode OFF -> engaged set: offense (' .. (dualWield and 'dual wield' or 'single wield') .. ')');
        end

    elseif (cmd == 'dw') then
        dualWield = not dualWield;
        if (dualWield) then
            print('[WAR] Dual wield ON  (needs /NIN or /DNC for the trait)');
        else
            print('[WAR] Dual wield OFF (single wield)');
        end

    elseif (cmd == 'warp') then
        -- Warp Ring: ~10s equip/charge delay, then a short Warp cast.
        useTeleportRing('Warp Ring', 'Warping', 11, 8);

    elseif (cmd == 'holla') then
        -- Dimensional Ring (Holla): teleports to the Crag of Holla in
        -- La Theine Plateau. Same flow as warp. If the use fails, the
        -- equip delay on your ring is longer -- raise the 11 below to the
        -- last number in the ring's <.../[reuse, delay]> description.
        -- (If the name doesn't match in-game, try 'Dim. Ring (Holla)'.)
        useTeleportRing('Dim. Ring (Holla)', 'Teleporting to Holla', 11, 8);

    elseif (cmd == 'echad') then
        -- EXP ring. Activate it and keep fighting; buff persists.
        useBonusRing('Echad ring', 'EXP bonus');

    elseif (cmd == 'trizek') then
        -- Capacity-point ring. Activate it and keep fighting; buff persists.
        useBonusRing('Trizek Ring', 'Capacity bonus');
    end
end

------------------------------------------------------------
-- Idle / Engaged
--
-- Engaged priority:
--   tank mode on            -> Idle (defensive / off-tank)
--   else dual wield on      -> TP_DW
--   else                    -> TP (single wield)
------------------------------------------------------------
profile.HandleDefault = function()
    local player = gData.GetPlayer();

    if (player.Status == 'Engaged') then
        if (tankMode) then
            gFunc.EquipSet(sets.Idle);   -- defensive engaged set (off-tanking)
        elseif (dualWield) then
            gFunc.EquipSet(sets.TP_DW);  -- offense, dual wield
        else
            gFunc.EquipSet(sets.TP);     -- offense, single wield
        end
    else
        -- Not fighting (idle / resting): stand in the survivability set.
        gFunc.EquipSet(sets.Idle);
    end
end

------------------------------------------------------------
-- Weaponskills (one WS overlay for now, used for all weaponskills)
------------------------------------------------------------
profile.HandleWeaponskill = function()
    gFunc.EquipSet(sets.WS);
end

return profile;