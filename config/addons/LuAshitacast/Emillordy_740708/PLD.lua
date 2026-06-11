local profile = {};

------------------------------------------------------------
-- Gear sets
-- You only have these three for now. Everything below this
-- block is wired to use ONLY these names.
------------------------------------------------------------
local sets = {
    ['TP'] = {
        Ammo = 'Ginsen',
        Head = 'Flam. Zucchetto +2',
        Neck = 'Asperity Necklace',
        Ear1 = 'Bladeborn Earring',
        Ear2 = 'Steelflash Earring',
        Body = 'Flamma Korazin +2',
        Hands = 'Flam. Manopolas +2',
        Ring1 = 'Moonbeam Ring',
        Ring2 = 'Chirich Ring',
        Back = 'Rudianos\'s Mantle',
        Waist = 'Sailfi Belt +1',
        Legs = 'Flamma Dirs',
        Feet = 'Flam. Gambieras +2',
    },
    ['TankingLow'] = {
        Ammo = 'Staunch Tathlum',
        Head = "Sulevia's Mask +2",
        Neck = 'Sanctity Necklace',
        Ear1 = 'Cassie Earring',
        Ear2 = 'Cessance Earring',
        Body = "Sulevia's Plate. +2",
        Hands = 'Sulev. Gauntlets +2',
        Ring1 = 'Moonbeam Ring',
        Ring2 = 'Gelatinous Ring +1',
        Back = 'Rudianos\'s Mantle',
        Waist = 'Sailfi Belt +1',
        Legs = 'Sulev. Cuisses +2',
        Feet = 'Sulev. Leggings +2',
    },
    ['WeaponskillLow'] = {
        Neck = 'Fotia Gorget',
        Ear1 = { Name = 'Moonshade Earring', Augment = { [1] = 'Accuracy+4', [2] = 'TP Bonus +250' } },
        Ring2 = 'Karieyh Ring',
        Back = 'Rudianos\'s Mantle',
        Waist = 'Thunder Belt',
    },
};
profile.Sets = sets;

------------------------------------------------------------
-- Simple offense/defense switch for when you're engaged.
--   false = TP set (offense)   |   true = TankingLow (defense)
-- Toggle it in game with:  /lac fwd tank
------------------------------------------------------------
local tankMode = true;

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

    print('[PLD] Activating ' .. label .. ' (' .. ringName .. '). Buff stays on after the swap-back.');
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

    print('[PLD] ' .. label .. '... hold still for ~' .. chargeSecs .. 's.');
end

------------------------------------------------------------
-- Load / Unload
------------------------------------------------------------
profile.OnLoad = function()
    gSettings.AllowAddSet = true;   -- lets you keep using /lac addset to build new sets
    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 11');
    AshitaCore:GetChatManager():QueueCommand(1, '/macro set 10');

    -- Convenience aliases
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /warp /lac fwd warp');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /holla /lac fwd holla');    -- Dimensional Ring (Holla)
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /xp /lac fwd echad');   -- Echad Ring  (EXP)
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /cp /lac fwd trizek'); -- Trizek Ring (Capacity)
end

profile.OnUnload = function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias del /warp');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias del /holla');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias del /xp');
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias del /cp');
end

------------------------------------------------------------
-- Custom commands forwarded with  /lac fwd ...
------------------------------------------------------------
profile.HandleCommand = function(args)
    local cmd = string.lower(args[1] or '');

    if (cmd == 'tank') then
        tankMode = not tankMode;
        if (tankMode) then
            print('[PLD] Engaged set: TankingLow (defense)');
        else
            print('[PLD] Engaged set: TP (offense)');
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
        useBonusRing('Trizek ring', 'Capacity bonus');
    end
end

------------------------------------------------------------
-- Idle / Engaged
------------------------------------------------------------
profile.HandleDefault = function()
    local player = gData.GetPlayer();

    if (player.Status == 'Engaged') then
        if (tankMode) then
            gFunc.EquipSet(sets.TankingLow);
        else
            gFunc.EquipSet(sets.TP);
        end
    else
        -- Not fighting (idle / resting): stand in the defensive set.
        gFunc.EquipSet(sets.TankingLow);
    end
end

------------------------------------------------------------
-- Weaponskills (you only have one WS set for now, so use it for all)
------------------------------------------------------------
profile.HandleWeaponskill = function()
    gFunc.EquipSet(sets.WeaponskillLow);
end

return profile;