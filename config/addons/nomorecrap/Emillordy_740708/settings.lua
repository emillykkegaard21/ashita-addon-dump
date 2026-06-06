require('common');

local settings = T{ };
settings["commandPresets"] = T{ };
settings["commandPresets"][1] = T{ };
settings["commandPresets"][1]["quantity"] = 20;
settings["commandPresets"][1]["command"] = "/ma \"Healing Breeze\" <me>";
settings["commandPresets"][1]["name"] = "blue level";
settings["commandPresets"][1]["interval"] = 6;

return settings;
