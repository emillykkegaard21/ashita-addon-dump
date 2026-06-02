--[[
* statustimers - Copyright (c) 2022-2026 Heals
*
* This file is part of statustimers for Ashita.
*
* statustimers is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* statustimers is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with statustimers.  If not, see <https://www.gnu.org/licenses/>.
--]]

-------------------------------------------------------------------------------
-- imports
-------------------------------------------------------------------------------
require('common');
-------------------------------------------------------------------------------
-- local state
-------------------------------------------------------------------------------
local cleanup_callbacks = T{};
local init_callbacks = T{};

local pGameMenu = ashita.memory.find('FFXiMain.dll', 0, '8B480C85C974??8B510885D274??3B05', 16, 0)

local function get_game_menu_name()
    local menu_pointer = ashita.memory.read_uint32(pGameMenu)
    local menu_val = ashita.memory.read_uint32(menu_pointer)
    if menu_val == 0 then return '' end
    local menu_header = ashita.memory.read_uint32(menu_val + 4)
    local menu_name = ashita.memory.read_string(menu_header + 0x46, 16)
    return menu_name:gsub('\x00', ''):gsub('menu[%s]+', ''):trimex()
end

-- set this to true to print the current menu name to chat for discovery.
-- it only prints when the name actually changes, so it won't spam every frame.
-- set it back to false (or reload) when you're done finding names.
local debug_menu_names = false;
local dbg_last_menu = nil;

-- internal menu-name patterns to hide statustimers for.
-- ported from minimapcontrol's defines.lua (window + main_menu + command_menu + map + auction).
-- these names are the truncated identifiers FFXI stores in memory, NOT the on-screen labels.
-- to keep timers visible for a particular menu, delete its line. to hide for an extra
-- menu, add its name here (use the debug print below to discover the exact string).
local hide_menus = T{
    -- main menu / entry points (right side) -- 'socialme' is the communication / social menu
    'configwi', 'inventor', 'miss00', 'region', 'mgc', 'cmb', 'abi$',
    -- left-side windows
    'inventor', 'equip', 'bank', 'evitem', 'quest', 'scresult',
    'handover', 'shop', 'statcom', 'auclist', 'auchisto', 'itmsort',
    'sortyn', 'itemctrl', 'itmstora', 'iuse', 'cmbhlst', 'link[%d]',
    'conf[%d]win', 'merit[%d]', 'meritcat', 'comyn', 'mcr[%d]pall',
    'mnstorag', 'scoption', 'jbpcat', 'ut_', 'mcresed', 'post[%d]',
    'delivery', 'stringdl', 'trade',
    -- map / region / widescan
    'map', 'cnqframe', 'scanlist',
    -- auction house
    'auc[%d]',
    -- friend list / messages (communication)
    'friend', 'msglist',
};

-------------------------------------------------------------------------------
-- exported functions
-------------------------------------------------------------------------------
local module = {};

-- register a callback to be executed by 'run_init'
---@param callback function a callback to be executed on cleanup
module.register_init = function(name, callback)
    init_callbacks[#init_callbacks+1] = {
        name = name,
        cb = callback
    };
end

-- run all callbacks queued by register_init in order
--- if a callback returns a value and that value is false then abort.
---@return boolean status true if all callbacks succeeded.
module.run_init = function()
    if (not next(init_callbacks)) then
        return true;
    end

    for i = 1,#init_callbacks,1 do
        local res = init_callbacks[i]['cb']();
        if (res ~= nil and res == false) then
            print('init failed for ' .. init_callbacks[i]['name']);
            return false;
        end
    end
    return true;
end

-- register a callback to be executed by 'run_cleanup'
---@param callback function a callback to be executed on cleanup
module.register_cleanup = function(name, callback)
    cleanup_callbacks[#cleanup_callbacks+1] = {
        name = name,
        cb = callback
    };
end

-- run all callbacks queued by register_cleanup in order.
--- if a callback returns a value and that value is false then abort.
---@return boolean status true if all callbacks succeeded.
module.run_cleanup = function()
    if (not next(cleanup_callbacks)) then
        return true;
    end

    for i = 1,#cleanup_callbacks,1 do
        local res = cleanup_callbacks[i]['cb']();
        if (res ~= nil and res == false) then
            print('cleanup failed for ' .. cleanup_callbacks[i]['name']);
            return false;
        end
    end
    return true;
end

-- return true if any in-game menu is currently open (blunt: matches everything)
---@return boolean open true if a game menu is open
module.is_game_menu_open = function()
    return get_game_menu_name() ~= '';
end

-- return true if the currently open menu is one of the menus we want to hide for.
-- this matches the same set minimapcontrol hides for, including the communication
-- (social) menu. edit the 'hide_menus' list above to change which menus qualify.
---@return boolean hide true if the current menu should hide statustimers
module.is_hide_menu_open = function()
    local name = get_game_menu_name();
    -- print the menu name only when it changes (flip debug_menu_names above to enable)
    if (debug_menu_names and name ~= dbg_last_menu) then
        dbg_last_menu = name;
        print('[statustimers menu] "' .. name .. '"');
    end
    if (name == '') then
        return false;
    end
    for _, pattern in ipairs(hide_menus) do
        if (name:match(pattern)) then
            return true;
        end
    end
    return false;
end

-- return a pre-formated duration string
---@param duration number the numerical duration (in seconds) or -1 for inf
---@return string duration_str the formatted duration string
module.formatted_duration = function(duration)
    if (duration == nil or duration == -1) then
        return '--';
    elseif (duration > 3600) then
        return ('%dh'):fmt(duration / 3600);
    elseif (duration >= 60) then
        return ('%dm'):fmt(duration / 60);
    elseif (duration <= 5) then
        return (' ');
    end
    return ('%d'):fmt(duration);
end

-- convert a u32 AARRGGBB color into an ImVec4
---@param color number the colour as 32 bit argb value
---@return table color_vec ImVec4 representation of color
module.color_u32_to_v4 = function(color)
    return {
        bit.band(bit.rshift(color, 16), 0xff) / 255.0, -- red
        bit.band(bit.rshift(color,  8), 0xff) / 255.0, -- green
        bit.band(color, 0xff) / 255.0, -- blue
        bit.rshift(color, 24) / 255.0, -- alpha
    };
end

-- convert an ImVec3 to a u32 AARRGGBB color
---@param color_vec table the colour as ImVec4 argument
---@return number color 32bit rgba representation of color_vec
module.color_v4_to_u32 = function(color_vec)
    local r = color_vec[1] * 255;
    local g = color_vec[2] * 255;
    local b = color_vec[3] * 255;
    local a = color_vec[4] * 255;

    return bit.bor(
        bit.lshift(bit.band(a, 0xff), 24),  -- alpha
        bit.lshift(bit.band(r, 0xff), 16), -- red
        bit.lshift(bit.band(g, 0xff), 8), -- green
        bit.band(b, 0xff) -- blue
    );
end

return module;