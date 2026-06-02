--[[
* Addons - Copyright (c) 2021 Ashita Development Team
* Contact: https://www.ashitaxi.com/
* Contact: https://discord.gg/Ashita
*
* This file is part of Ashita.
*
* Ashita is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* Ashita is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with Ashita.  If not, see <https://www.gnu.org/licenses/>.
--]]

addon.name      = 'gamepadfix';
addon.author    = 'AddonsXI';
addon.version   = '1.0.0';
addon.link      = 'https://github.com/addonsxi';
addon.desc      = 'Automatically manages the gamepad state based on controller presence to prevent frame stutter';

require('common');
local chat = require('chat');
local ffi = require('ffi');
local win32types = require('win32types');

-- FFI definitions for XInput
ffi.cdef[[
    typedef struct _XINPUT_STATE {
        DWORD dwPacketNumber;
        WORD wButtons;
        BYTE bLeftTrigger;
        BYTE bRightTrigger;
        SHORT sThumbLX;
        SHORT sThumbLY;
        SHORT sThumbRX;
        SHORT sThumbRY;
    } XINPUT_STATE, *PXINPUT_STATE;

    DWORD XInputGetState(DWORD dwUserIndex, XINPUT_STATE* pState);
]];

-- Load XInput DLL
local xinput = ffi.load('xinput1_4') or ffi.load('xinput1_3') or ffi.load('xinput9_1_0');

-- Constants
local CHECK_INTERVAL = 3.0;  -- Check interval in seconds

-- Addon State
local gamepadfix = T{
    lastCheckTime = 0,
    lastControllerState = false,
    lastGamepadState = nil,       -- Track last gamepad enabled/disabled state
    inputManager = nil,
};

--[[
* Checks if any XInput controller is present
* @return {boolean} True if any controller is detected
--]]
local function checkControllerPresence()
    if not xinput then
        return false;
    end

    local state = ffi.new('XINPUT_STATE');
    
    -- Check controllers 0-3 (XInput supports up to 4 controllers)
    for i = 0, 3 do
        local result = xinput.XInputGetState(i, state);
        -- ERROR_SUCCESS = 0, ERROR_DEVICE_NOT_CONNECTED = 1167
        if result == 0 then
            return true;  -- At least one controller is present
        end
    end
    
    return false;  -- No controllers detected
end

--[[
* Monitors gamepad state and controller presence
--]]
local function monitorGamepad()
    -- Get input manager
    if not gamepadfix.inputManager then
        local ok, result = pcall(function()
            return AshitaCore:GetInputManager();
        end);
        
        if not ok or not result then
            -- InputManager not available, skip this check
            return;
        end
        
        gamepadfix.inputManager = result;
    end

    local inputMgr = gamepadfix.inputManager;
    if not inputMgr then
        return;
    end

    -- Check controller presence
    local controllerPresent = checkControllerPresence();
    local gamepadDisabled = inputMgr:GetDisableGamepad();
    local gamepadEnabled = not gamepadDisabled;
    local gamepadStateChanged = false;

    -- Auto-disable gamepad when no controller is present
    if gamepadEnabled and not controllerPresent then
        -- Gamepad enabled but no controller - disable to prevent stutter
        inputMgr:SetDisableGamepad(true);
        gamepadDisabled = true;  -- Update local state after change
        gamepadStateChanged = true;
        gamepadfix.lastControllerState = false;
        
        -- Show status message
        print(chat.header(addon.name):append(chat.message('Controller disconnected.')));
    elseif not gamepadEnabled and controllerPresent then
        -- Controller present but gamepad disabled - enable gamepad
        inputMgr:SetDisableGamepad(false);
        gamepadDisabled = false;  -- Update local state after change
        gamepadStateChanged = true;
        gamepadfix.lastControllerState = true;
        
        -- Show status message
        print(chat.header(addon.name):append(chat.message('Controller connected.')));
    elseif controllerPresent ~= gamepadfix.lastControllerState then
        -- Controller state changed, update tracking and show message
        gamepadfix.lastControllerState = controllerPresent;
        
        if controllerPresent then
            print(chat.header(addon.name):append(chat.message('Controller connected.')));
        else
            print(chat.header(addon.name):append(chat.message('Controller disconnected.')));
        end
    end
    
    -- Track gamepad state changes (including manual changes) and show status
    if gamepadfix.lastGamepadState ~= nil and gamepadDisabled ~= gamepadfix.lastGamepadState and not gamepadStateChanged then
        -- State changed but not by us - show status
        if gamepadDisabled then
            print(chat.header(addon.name):append(chat.message('Gamepad disabled.')));
        else
            print(chat.header(addon.name):append(chat.message('Gamepad enabled.')));
        end
    end
    
    gamepadfix.lastGamepadState = gamepadDisabled;
end

--[[
* Prints current status
--]]
local function print_status()
    local inputMgr = gamepadfix.inputManager;
    if not inputMgr then
        local ok, result = pcall(function()
            return AshitaCore:GetInputManager();
        end);
        if ok and result then
            inputMgr = result;
            gamepadfix.inputManager = inputMgr;
        end
    end

    print(chat.header(addon.name):append(chat.message('Status:')));
    
    if inputMgr then
        local gamepadDisabled = inputMgr:GetDisableGamepad();
        print(chat.header(addon.name):append(chat.message('  Gamepad: ')):append(chat.success(gamepadDisabled and 'Disabled' or 'Enabled')));
    end
    
    local controllerPresent = checkControllerPresence();
    print(chat.header(addon.name):append(chat.message('  Controller: ')):append(chat.success(controllerPresent and 'Connected' or 'Not Connected')));
end

--[[
* event: load
* desc : Event called when the addon is being loaded.
--]]
ashita.events.register('load', 'load_cb', function ()
    -- Try to get input manager
    local ok, result = pcall(function()
        return AshitaCore:GetInputManager();
    end);
    
    if ok and result then
        gamepadfix.inputManager = result;
        -- Initialize last gamepad state
        gamepadfix.lastGamepadState = result:GetDisableGamepad();
    end
    
    print(chat.header(addon.name):append(chat.message('Loaded. Automatically monitoring gamepad state.')));
end);

--[[
* event: unload
* desc : Event called when the addon is being unloaded.
--]]
ashita.events.register('unload', 'unload_cb', function ()
    -- Cleanup
end);

--[[
* event: command
* desc : Event called when the addon is processing a command.
--]]
ashita.events.register('command', 'command_cb', function (e)
    local args = e.command:args();
    if (#args == 0 or args[1] ~= '/gamepadfix') then
        return;
    end

    e.blocked = true;

    -- Handle: /gamepadfix status
    if (#args == 1 or (#args == 2 and args[2]:any('status'))) then
        print_status();
        return;
    end

    -- Unknown command - just show status
    print_status();
end);

--[[
* event: d3d_present
* desc : Event called when the Direct3D device is presenting a scene.
--]]
ashita.events.register('d3d_present', 'present_cb', function ()
    -- Throttle checks to once per second
    local currentTime = os.clock();
    
    if (currentTime - gamepadfix.lastCheckTime) >= CHECK_INTERVAL then
        gamepadfix.lastCheckTime = currentTime;
        monitorGamepad();
    end
end);