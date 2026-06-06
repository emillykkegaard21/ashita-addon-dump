--[[
    Corsair (COR) profile for LuAshitacast (Ashita v4).

    Building / updating sets in game:
      - This profile enables addset, so you can capture your currently
        equipped gear into a set with:
            /lac addset SetName
      - To preview an existing set without engaging:
            /lac set Tp_Default       (equips it for a few seconds)
      - /lac reload   reloads this file after you edit it.
      - /lac debug on  prints every swap so you can see what is equipping.

    Slot names (GearSwap -> LuAshitacast):
        main -> Main        sub -> Sub          range -> Range      ammo -> Ammo
        head -> Head        neck -> Neck        left_ear -> Ear1    right_ear -> Ear2
        body -> Body        hands -> Hands      left_ring -> Ring1  right_ring -> Ring2
        back -> Back        waist -> Waist      legs -> Legs        feet -> Feet

    Augment format (GearSwap -> LuAshitacast):
        { name="X", augments={'A','B',} }
        becomes
        { Name = 'X', Augment = { [1] = 'A', [2] = 'B' } }
]]

local profile = {};

local sets = {
    ------------------------------------------------------------
    -- Idle: gear to stand around in (regen / refresh works well).
    -- Uncomment this set AND the matching line in HandleDefault to use it.
    ------------------------------------------------------------
    -- Idle = {
    -- },

    ------------------------------------------------------------
    -- TP Set (engaged / melee). Do not put anything here that resets TP.
    ------------------------------------------------------------
    Tp_Default = {
        Ammo = 'Bronze Bullet',
        Head = 'Mummu Bonnet +1',
        Body = 'Mummu Jacket +1',
        Hands = 'Mummu Wrists +1',
        Legs = 'Mummu Kecks +1',
        Feet = 'Mummu Gamash. +1',
        Neck = 'Sanctity Necklace',
        Waist = 'Sailfi Belt +1',
        Ear1 = 'Bladeborn Earring',
        Ear2 = 'Steelflash Earring',
        Ring1 = 'Mummu Ring',
        Ring2 = 'Rajas Ring',
        Back = "Camulus's Mantle",
    },

    ------------------------------------------------------------
    -- Defense / PDT set. Uncomment this and the toggle in HandleDefault.
    ------------------------------------------------------------
    -- Pdt = {
    -- },

    ------------------------------------------------------------
    -- Fast Cast set (spell precast). Uncomment this and the line in HandlePrecast.
    ------------------------------------------------------------
    -- Precast_FC = {
    -- },

    ------------------------------------------------------------
    -- Ranged precast (Snapshot / ranged delay reduction).
    -- Uncomment this and the line in HandlePreshot.
    ------------------------------------------------------------
    -- Preshot = {
    -- },

    ------------------------------------------------------------
    -- General Weapon Skill set.
    ------------------------------------------------------------
    Ws_Default = {
        Head = 'Mummu Bonnet +1',
        Body = 'Mummu Jacket +1',
        Hands = 'Meg. Gloves +1',
        Legs = 'Mummu Kecks +1',
        Feet = 'Mummu Gamash. +1',
        Neck = 'Sanctity Necklace',
        Waist = 'Sailfi Belt +1',
        Ear1 = { Name = 'Moonshade Earring', Augment = { [1] = 'Accuracy+4', [2] = 'TP Bonus +250' } },
        Ear2 = 'Steelflash Earring',
        Ring1 = 'Mummu Ring',
        Ring2 = 'Rajas Ring',
        Back = "Camulus's Mantle",
    },

    ------------------------------------------------------------
    -- Specific Weapon Skill set example (e.g. Last Stand, Leaden Salute).
    -- Uncomment this and the matching block in HandleWeaponskill.
    ------------------------------------------------------------
    -- Ws_LastStand = {
    -- },

    ------------------------------------------------------------
    -- Ranged attack set (midshot: Store TP / Rapid Shot / ranged acc).
    -- Uncomment this and the line in HandleMidshot.
    ------------------------------------------------------------
    -- Midshot = {
    -- },

    ------------------------------------------------------------
    -- General spell midcast set. Uncomment this and the line in HandleMidcast.
    ------------------------------------------------------------
    -- Midcast = {
    -- },

    ------------------------------------------------------------
    -- Specific magic-type / spell midcast example (e.g. Healing Magic).
    -- Uncomment this and the matching block in HandleMidcast.
    ------------------------------------------------------------
    -- Midcast_Healing = {
    -- },

    ------------------------------------------------------------
    -- Phantom Roll / Quick Draw ability sets (COR-specific).
    -- Uncomment these and the matching blocks in HandleAbility.
    ------------------------------------------------------------
    -- Roll = {
    -- },
    -- QuickDraw = {
    -- },
};
profile.Sets = sets;

------------------------------------------------------------
-- Load / Unload
------------------------------------------------------------
profile.OnLoad = function()
    gSettings.AllowAddSet = true;   -- lets you build sets in game with /lac addset

    -- Macros / lockstyle (uncomment and set your own numbers):
    -- AshitaCore:GetChatManager():QueueCommand(1, '/macro book 1');
    -- AshitaCore:GetChatManager():QueueCommand(1, '/macro set 1');
    -- AshitaCore:GetChatManager():QueueCommand(1, '/lockstyleset 1');
end

profile.OnUnload = function()
end

profile.HandleCommand = function(args)
    -- Custom commands forwarded with  /lac fwd <name>  go here.
    -- Example PDT toggle (uncomment sets.Pdt and the HandleDefault block too):
    -- if (string.lower(args[1] or '') == 'dt') then
    --     PdtOn = not PdtOn;
    --     print('[COR] PDT: ' .. (PdtOn and '[On]' or '[Off]'));
    -- end
end

------------------------------------------------------------
-- Idle / Engaged
------------------------------------------------------------
profile.HandleDefault = function()
    local player = gData.GetPlayer();

    -- Idle (uncomment once sets.Idle exists):
    -- gFunc.EquipSet(sets.Idle);

    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.Tp_Default);
    end

    -- Defense toggle (uncomment once sets.Pdt and the PdtOn toggle exist):
    -- if (PdtOn == true) then gFunc.EquipSet(sets.Pdt); end
end

------------------------------------------------------------
-- Spell precast (Fast Cast)
------------------------------------------------------------
profile.HandlePrecast = function()
    -- Fast Cast (uncomment once sets.Precast_FC exists):
    -- gFunc.EquipSet(sets.Precast_FC);
end

------------------------------------------------------------
-- Spell midcast
------------------------------------------------------------
profile.HandleMidcast = function()
    -- local spell = gData.GetAction();

    -- General casting set (uncomment once sets.Midcast exists):
    -- gFunc.EquipSet(sets.Midcast);

    -- Specific magic-type set (uncomment sets.Midcast_Healing too):
    -- if (spell.Skill == 'Healing Magic') then gFunc.EquipSet(sets.Midcast_Healing); end
end

------------------------------------------------------------
-- Ranged precast (Snapshot)
------------------------------------------------------------
profile.HandlePreshot = function()
    -- Uncomment once sets.Preshot exists:
    -- gFunc.EquipSet(sets.Preshot);
end

------------------------------------------------------------
-- Ranged midshot (the actual shot)
------------------------------------------------------------
profile.HandleMidshot = function()
    -- Uncomment once sets.Midshot exists:
    -- gFunc.EquipSet(sets.Midshot);
end

------------------------------------------------------------
-- Job abilities (Phantom Roll, Quick Draw, etc.)
------------------------------------------------------------
profile.HandleAbility = function()
    -- local ability = gData.GetAction();

    -- Phantom Roll / Double-Up (uncomment sets.Roll too):
    -- if (ability.Name == 'Phantom Roll' or ability.Name == 'Double-Up') then
    --     gFunc.EquipSet(sets.Roll);
    -- end

    -- Quick Draw (uncomment sets.QuickDraw too):
    -- if (ability.Name == 'Quick Draw') then
    --     gFunc.EquipSet(sets.QuickDraw);
    -- end
end

------------------------------------------------------------
-- Weaponskills
------------------------------------------------------------
profile.HandleWeaponskill = function()
    gFunc.EquipSet(sets.Ws_Default);

    -- Specific weaponskill set example (uncomment sets.Ws_LastStand too):
    -- local ws = gData.GetAction();
    -- if (ws.Name == 'Last Stand') then gFunc.EquipSet(sets.Ws_LastStand); end
end

profile.HandleItem = function()
end

return profile;