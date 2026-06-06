require('common');

local settings = T{ };
settings["commandPresets"] = T{ };
settings["commandPresets"][1] = T{ };
settings["commandPresets"][1]["quantity"] = 1;
settings["commandPresets"][1]["command"] = "/ma \"Cure IV\" <me>";
settings["commandPresets"][1]["name"] = "heal level";
settings["commandPresets"][1]["interval"] = 6;

return settings;
