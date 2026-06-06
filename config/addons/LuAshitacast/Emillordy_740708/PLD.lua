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
        Head = 'Flam. Zucchetto +2',
        Neck = 'Sanctity Necklace',
        Ear1 = 'Cassie Earring',
        Ear2 = 'Cessance Earring',
        Body = 'Flamma Korazin +2',
        Hands = 'Flam. Manopolas +2',
        Ring1 = 'Moonbeam Ring',
        Ring2 = 'Gelatinous Ring +1',
        Back = 'Rudianos\'s Mantle',
        Waist = 'Sailfi Belt +1',
        Legs = 'Sulev. Cuisses +2',
        Feet = 'Flam. Gambieras +2',
    },
    ['WeaponskillLow'] = {
        Head = 'Flam. Zucchetto +2',
        Neck = 'Fotia Gorget',
        Ear1 = { Name = 'Moonshade Earring', Augment = { [1] = 'Accuracy+4', [2] = 'TP Bonus +250' } },
        Ear2 = 'Cessance Earring',
        Body = 'Flamma Korazin +2',
        Hands = 'Flam. Manopolas +2',
        Ring1 = 'Moonbeam Ring',
        Ring2 = 'Karieyh Ring',
        Back = 'Rudianos\'s Mantle',
        Waist = 'Thunder Belt',
        Legs = 'Sulev. Cuisses +2',
        Feet = 'Flam. Gambieras +2',
    },
};
profile.Sets = sets;

------------------------------------------------------------
-- Simple offense/defense switch for when you're engaged.
--   false = TP set (offense)   |   true = TankingLow (defense)
-- Toggle it in game with:  /lac fwd tank
------------------------------------------------------------
local tankMode = false;

------------------------------------------------------------
-- Load / Unload
------------------------------------------------------------
profile.OnLoad = function()
    gSettings.AllowAddSet = true;   -- lets you keep using /lac addset to build new sets
    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 11');
    AshitaCore:GetChatManager():QueueCommand(1, '/macro set 10');

    -- Convenience alias so you can just type  /warp
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias /warp /lac fwd warp');
end

profile.OnUnload = function()
    AshitaCore:GetChatManager():QueueCommand(-1, '/alias del /warp');
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
        -- The Warp Ring has a ~10s equip delay before it can be used, so we
        -- equip it, lock the slot so idle/engaged swaps can't strip it while
        -- it charges, wait out the delay, use it, then unlock.
        local mgr = AshitaCore:GetChatManager();
        mgr:QueueCommand(1, '/lac equip ring2 "Warp Ring"'); -- put the ring on
        mgr:QueueCommand(1, '/lac disable ring2');           -- lock the slot

        local function fire()
            AshitaCore:GetChatManager():QueueCommand(1, '/item "Warp Ring" <me>'); -- ring is ready, use it
            local function restore()
                AshitaCore:GetChatManager():QueueCommand(1, '/lac enable ring2');  -- unlock; normal gear returns
            end
            restore:once(8); -- after the warp's cast finishes
        end
        fire:once(11); -- wait out the ring's equip/charge delay

        print('[PLD] Warping... hold still for ~11s.');
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