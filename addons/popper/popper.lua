addon.name      = 'popper';
addon.author    = 'Soralin';
addon.version   = '4.0';
addon.desc      = 'NPC/??? popping helper for registering item pops for trading';
addon.link      = 'https://github.com/SteffenBlake/popper-ashita';

require('common');
local chat = require('chat');
local flatdb = require 'flatdb'

local function settings_path()
    return AshitaCore:GetInstallPath() .. "\\config\\addons\\popper\\";
end

ashita.events.register('load', 'load_cb', function ()
    os.execute(
        'mkdir "' .. settings_path() .. '"'
    );
end);

local function LogInfo(text)
	print(chat.header(addon.name) + chat.message(text));
end

local function PrintHelp(isError)
    -- Print the help header..
    if (isError) then
        print(chat.header(addon.name):append(chat.error('Invalid command syntax for command: ')):append(chat.success('/' .. addon.name)));
    else
        print(chat.header(addon.name):append(chat.message('Available commands:')));
    end

    local cmds = T{
        { '/pop help', 'Displays the addons help information.' },
        { '/pop "Item Name" [count=1] "Item Name" [count=1] ... etc', 'Registers a trade for a targetted NPC, then performs the trade' },
        { '/pop', 'Attempts to perform a registered trade for a targetted npc' },
    };

    -- Print the command list..
    cmds:ieach(function (v)
        local cmd = v[1];
        local msg = v[2];
        print(
            chat.header(
                addon.name
            ):append(
                chat.error('Usage: ')
            ):append(
                chat.message(
                    cmd
                ):append(
                    ' - '
                )
            ):append(
                chat.color1(6, msg)
            )
        );
    end);
end

local function normalize_args(args)
    local out = {}
    for i = 2, #args do
        local asNumber = tonumber(args[i]);
        if (asNumber ~= nil) then
            goto continue;
        end

        table.insert(out, '"' .. args[i] .. '"');

        local next = args[i+1];
        if (next == nil) then
            next = "1";
        end

        local count = tonumber(next);
        if (count == nil) then
            count = 1;
        end
        table.insert(out, count);

        ::continue::
    end
    return out
end

----------------------------------------------------------------------------------------------------
-- func: command -- Code adapted from drawdistance.
-- desc: Event called when a command was entered.
----------------------------------------------------------------------------------------------------
ashita.events.register('command', 'command_cb', function(e)
    local args = e.command:args();

	if (args[1] ~= '/pop') then
		return;
	end

    -- Block all popper related commands..
    e.blocked = true;

	if (#args == 1) then
		ExecutePop();
		return;
	end

	if (#args == 2 and string.lower(args[2]) == "help") then
        PrintHelp();
        return true;
	end

    local normalizedArgs = normalize_args(args);
	RegisterPop(normalizedArgs);
	ExecutePop();
    return true;
end);

-- Target identity consists of "<ZoneId>-<TargetIndex>"
function GetTargetIdentity()
	local zoneId = AshitaCore:GetMemoryManager():GetParty():GetMemberZone(0);

    local target = GetEntity(AshitaCore:GetMemoryManager():GetTarget():GetTargetIndex(0));

    if (target == nil or target.Name == '' or target.TargetIndex == 0) then
		LogInfo('No target found, make sure you target an NPC before executing popper!');
		return nil, nil;
	end

	return zoneId, target.TargetIndex;
end

function RegisterPop(args)
	local zoneId, targetId = GetTargetIdentity();
    if (zoneId == nil or targetId == nil) then
        return nil;
    end

    local db = flatdb(settings_path());
    if (db[zoneId] == nil) then
        db[zoneId] = {};
    end

    db[zoneId][targetId] = args;
    db:save();

    LogInfo(
        "Registered Trade: " .. zoneId .. "-" .. targetId .. ": " .. table.concat(args, " ")
    );
end

function ExecutePop()
	local zoneId, targetId = GetTargetIdentity();
    if (zoneId == nil or targetId == nil) then
        return nil;
    end

    local db = flatdb(settings_path());
    if (db[zoneId] == nil or db[zoneId][targetId] == nil) then
		LogInfo('No registered item(s) for this target.');
		LogInfo('Use /pop \"<itemName>\" # \"<itemName>\" # ... etc, to register a pop');
		return true;
	end

    local args = db[zoneId][targetId];

	local command = '/bh tradenpc ' .. table.concat(args, " ");
    LogInfo(command);

	AshitaCore:GetChatManager():QueueCommand(1, command);
end
