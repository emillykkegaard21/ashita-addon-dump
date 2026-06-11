local profile = {};

------------------------------------------------------------
-- Red Mage (RDM) luashitacast profile
-- Built in the same style as the WAR profile.
--
-- Scope for now (per request): just two gear sets.
--   Casting -> worn for every spell (Jhakri-based magic set)
--   TP      -> worn when engaged in melee (Ayanmo-based)
--
-- Casting also doubles as the idle / not-engaged set for now, so you're
-- always ready to cast. When you want to optimise later you can:
--   * split Casting into Fast Cast / Enfeebling / Nuke / Cure / Enhancing
--     sets and point the relevant cast handler at them, and
--   * add a dedicated Idle (refresh) set and a WS set.
-- The handlers near the bottom show exactly where those would hook in.
--
-- Gear note: the five armour slots are filled with Jhakri (casting) and
-- Ayanmo (TP) as requested. Item names use the BASE versions -- edit the
-- names to add ' +1' or ' +2' to match the pieces you actually own
-- (e.g. 'Jhakri Robe +2'). The accessory slots are sensible starting
-- picks; swap any flagged piece for whatever you have. Where it made
-- sense I reused gear your WAR already carried (Cichol's mantle, Sailfi
-- Belt +1, Chirich/Moonbeam rings, Cessance Earring, Ginsen).
--
-- The ring / teleport helpers at the bottom are job-agnostic and carry
-- over from the WAR profile (just re-tagged [RDM]).
------------------------------------------------------------
local sets = {
    -- General "do everything" magic set. Leans on fast cast in the
    -- accessory slots so it's safe for any spell school; for hard
    -- enfeebles / nukes you'll eventually want magic-accuracy swaps
    -- (those go in a dedicated set later -- see HandleMidcast).
    ['Casting'] = {       -- fast cast; swap to Pemphredo Tathlum for magic acc
        Head  = 'Jhakri Coronal +2',
        Body  = 'Jhakri Robe +2',         -- add ' +1'/' +2'
        Hands = 'Jhakri Cuffs +2',        -- add ' +1'/' +2'
        Ring1 = 'Jhakri Ring',        -- great all-round mage ring (use +1 if you have it)
        Ring2 = 'Ayanmo Ring',        -- needs two copies; otherwise pair with another mage ring
        Legs  = 'Jhakri Slops +2',
        Feet  = 'Jhakri Pigaches +2',
    },
    -- Melee / TP set. Worn whenever you're engaged. Ayanmo across the
    -- armour slots; accessories are accuracy / haste oriented -- swap freely.
    ['TP'] = {             -- attack-speed ammo; swap as you like
        Head  = 'Ayanmo Zucchetto +2',    -- add ' +1'/' +2' to match what you own
        Body  = 'Ayanmo Corazza +2',      -- add ' +1'/' +2'
        Hands = 'Ayanmo Manopolas +2',    -- add ' +1'/' +2'
        Ring1 = 'Jhakri Ring',        -- great all-round mage ring (use +1 if you have it)
        Ring2 = 'Ayanmo Ring',
        Legs  = 'Ayanmo Cosciales +2',    -- add ' +1'/' +2'
        Feet  = 'Ayanmo Gambieras +2',    -- add ' +1'/' +2'
    },
};
profile.Sets = sets;

------------------------------------------------------------
-- Helper: activate an enchanted bonus ring (Echad / Trizek).
--
-- IMPORTANT: these reward rings DO have an equip/charge delay before the
-- enchantment can be used -- the enchantment text stays greyed for ~10s
-- after you equip them, same as the teleport rings. (An earlier version of
-- this helper assumed "no charge delay" and only waited 6s, so /item fired
-- before the ring was ready and failed silently.) The buff they grant
-- (Dedication for Echad, Commitment for Trizek) DOES stick around after you
-- take the ring off, so only the swap-back is quick. Flow:
--   1. equip the ring in ring2
--   2. lock the slot so an idle/engaged swap can't strip it while it charges
--   3. wait out the charge delay, then use it
--   4. unlock so your normal ring2 comes back -- the buff stays on
--
-- chargeSecs defaults to 12. If a use still fails ("you do not have that
-- item equipped" / "cannot use yet"), bump it up a second or two, or pass
-- an explicit value per ring, e.g. useBonusRing('Trizek Ring', '...', 13).
------------------------------------------------------------
local function useBonusRing(ringName, label, chargeSecs)
    chargeSecs = chargeSecs or 12;  -- these rings need to charge after equipping
    local mgr = AshitaCore:GetChatManager();
    mgr:QueueCommand(1, '/lac equip ring2 "' .. ringName .. '"'); -- put the ring on
    mgr:QueueCommand(1, '/lac disable ring2');                    -- lock the slot while it charges

    local function fire()
        AshitaCore:GetChatManager():QueueCommand(1, '/item "' .. ringName .. '" <me>'); -- ring is ready, use it
        local function restore()
            AshitaCore:GetChatManager():QueueCommand(1, '/lac enable ring2');           -- unlock; buff stays on
        end
        restore:once(5); -- short buffer; activation is instant and the buff persists
    end
    fire:once(chargeSecs); -- wait out the charge before using

    print('[RDM] Activating ' .. label .. ' (' .. ringName .. '). Buff stays on after the swap-back.');
end

------------------------------------------------------------
-- Helper: use a teleport/warp enchantment ring.
--
-- Like the bonus rings, these must be WORN for a few seconds to "charge"
-- before the enchantment can fire, and the cast itself takes a moment
-- during which you must hold still. So the flow is:
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

    print('[RDM] ' .. label .. '... hold still for ~' .. chargeSecs .. 's.');
end

------------------------------------------------------------
-- Load / Unload
------------------------------------------------------------
profile.OnLoad = function()
    gSettings.AllowAddSet = true;   -- lets you keep using /lac addset to build new sets
    AshitaCore:GetChatManager():QueueCommand(1, '/macro book 1');  -- TODO: set this to your RDM macro book
    AshitaCore:GetChatManager():QueueCommand(1, '/macro set 1');   -- TODO: set this to your RDM macro page

    -- Convenience aliases (same as WAR)
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
-- (tank/dw toggles from the WAR profile dropped -- RDM doesn't use them)
------------------------------------------------------------
profile.HandleCommand = function(args)
    local cmd = string.lower(args[1] or '');

    if (cmd == 'warp') then
        -- Warp Ring: ~10s equip/charge delay, then a short Warp cast.
        useTeleportRing('Warp Ring', 'Warping', 11, 8);

    elseif (cmd == 'holla') then
        -- Dimensional Ring (Holla): teleports to the Crag of Holla in
        -- La Theine Plateau. If the use fails, the equip delay on your ring
        -- is longer -- raise the 11 below to the last number in the ring's
        -- <.../[reuse, delay]> description.
        -- (If the name doesn't match in-game, try 'Dim. Ring (Holla)'.)
        useTeleportRing('Dim. Ring (Holla)', 'Teleporting to Holla', 11, 8);

    elseif (cmd == 'echad') then
        -- EXP ring. Activate it and keep going; buff persists.
        useBonusRing('Echad Ring', 'EXP bonus');

    elseif (cmd == 'trizek') then
        -- Capacity-point ring. Activate it and keep going; buff persists.
        useBonusRing('Trizek Ring', 'Capacity bonus');
    end
end

------------------------------------------------------------
-- Idle / Engaged
--
--   engaged -> TP (melee)
--   else    -> Casting (stay in magic gear so you're ready to cast)
--
-- When you build a dedicated Idle/refresh set later, add it to `sets`
-- and point the else-branch at sets.Idle instead.
------------------------------------------------------------
profile.HandleDefault = function()
    local player = gData.GetPlayer();

    if (player.Status == 'Engaged') then
        gFunc.EquipSet(sets.TP);
    else
        gFunc.EquipSet(sets.Casting);
    end
end

------------------------------------------------------------
-- Spellcasting
--
-- One general set for everything for now. Precast and midcast both use it,
-- so it covers fast cast AND the actual spell effect in one go.
--
-- To optimise later, branch on the spell here, e.g. in HandleMidcast:
--   local spell = gData.GetAction();
--   if (spell.Skill == 'Enfeebling Magic') then gFunc.EquipSet(sets.Enfeeb);
--   elseif (spell.Skill == 'Elemental Magic') then gFunc.EquipSet(sets.Nuke);
--   else gFunc.EquipSet(sets.Casting); end
-- ...and keep HandlePrecast on a dedicated Fast Cast set.
------------------------------------------------------------
profile.HandlePrecast = function()
    gFunc.EquipSet(sets.Casting);
end

profile.HandleMidcast = function()
    gFunc.EquipSet(sets.Casting);
end

------------------------------------------------------------
-- Weaponskills
-- No dedicated WS set yet, so WS in your melee/TP gear. Add a partial
-- 'WS' set (like the WAR profile had) and point this at it when ready.
------------------------------------------------------------
profile.HandleWeaponskill = function()
    gFunc.EquipSet(sets.TP);
end

return profile;