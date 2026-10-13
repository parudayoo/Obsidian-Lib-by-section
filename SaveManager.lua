local HttpService = game:GetService("HttpService")

local SaveManager = {}
SaveManager.__index = SaveManager

local Library
local Folder = "Obsidian/Configs"
local Autoload = true
local AutoloadName
local AutoSave = false
local AutoSaveInterval = 30
local IgnoreIndexes = {}
local IgnoreTheme = false
local LastAutoSave = 0

local function EnsureFolder(path)
    if not isfolder or not makefolder then return false end
    local current = ""
    for segment in path:gmatch("[^/\\]+") do
        current = current == "" and segment or (current .. "/" .. segment)
        if not isfolder(current) then
            local ok = pcall(makefolder, current)
            if not ok and not isfolder(current) then return false end
        end
    end
    return isfolder(path)
end

local function SerializeValue(value)
    local kind = typeof(value)
    if kind == "Color3" then
        return { __type = "Color3", r = value.R, g = value.G, b = value.B }
    elseif kind == "EnumItem" then
        return {
            __type = "EnumItem",
            enum = tostring(value.EnumType):gsub("^Enum%.", ""),
            name = value.Name,
        }
    elseif kind == "Vector2" then
        return { __type = "Vector2", x = value.X, y = value.Y }
    elseif kind == "Vector3" then
        return { __type = "Vector3", x = value.X, y = value.Y, z = value.Z }
    elseif kind == "UDim2" then
        return {
            __type = "UDim2",
            xs = value.X.Scale, xo = value.X.Offset,
            ys = value.Y.Scale, yo = value.Y.Offset,
        }
    elseif kind == "table" then
        local result = {}
        for key, item in value do
            result[key] = SerializeValue(item)
        end
        return result
    end
    return value
end

local function DeserializeValue(value)
    if typeof(value) ~= "table" then return value end
    if value.__type == "Color3" then
        return Color3.new(value.r, value.g, value.b)
    elseif value.__type == "Vector2" then
        return Vector2.new(value.x, value.y)
    elseif value.__type == "Vector3" then
        return Vector3.new(value.x, value.y, value.z)
    elseif value.__type == "UDim2" then
        return UDim2.new(value.xs, value.xo, value.ys, value.yo)
    elseif value.__type == "EnumItem" then
        local ok, item = pcall(function()
            return Enum[value.enum][value.name]
        end)
        return ok and item or nil
    elseif value.__type then
        return nil
    end

    local result = {}
    for key, item in value do
        result[key] = DeserializeValue(item)
    end
    return result
end

local function GetThemeManager()
    if getgenv then return getgenv().ThemeManager end
    return nil
end

function SaveManager:SetLibrary(library)
    Library = library
    return self
end

function SaveManager:SetFolder(folder)
    Folder = folder
    EnsureFolder(Folder)
    return self
end

function SaveManager:IgnoreThemeSettings()
    IgnoreTheme = true
    return self
end

function SaveManager:SetIgnoreIndexes(indexes)
    IgnoreIndexes = {}
    for _, index in (indexes or {}) do
        IgnoreIndexes[index] = true
    end
    return self
end

function SaveManager:SetAutoload(enabled, name)
    Autoload = enabled ~= false
    AutoloadName = name
    return self
end

function SaveManager:SetAutoSave(enabled, interval)
    AutoSave = enabled == true
    AutoSaveInterval = math.max(1, tonumber(interval) or AutoSaveInterval)
    return self
end

function SaveManager:CollectConfig()
    local data = { Options = {}, Theme = nil }
    if not Library then return data end

    for index, option in Library.Options do
        if not IgnoreIndexes[index] then
            local kind = option.Type
            if kind == "KeyPicker" then
                data.Options[index] = {
                    Type = kind,
                    Value = SerializeValue(option.Value),
                    Mode = option.Mode,
                    Modifiers = SerializeValue(option.Modifiers),
                }
            elseif kind == "Toggle" or kind == "Slider" or kind == "Input"
                or kind == "Dropdown" or kind == "ColorPicker" then
                data.Options[index] = {
                    Type = kind,
                    Value = SerializeValue(option.Value),
                    Transparency = option.Transparency,
                }
            end
        end
    end

    local themeManager = GetThemeManager()
    if not IgnoreTheme and themeManager then
        data.Theme = themeManager:GetCurrentTheme()
    end
    return data
end

function SaveManager:ApplyConfig(data)
    if not data or not Library then return false end
    local themeManager = GetThemeManager()
    if data.Theme and themeManager then
        themeManager:ApplyTheme(data.Theme)
    end

    for index, entry in (data.Options or {}) do
        local option = Library.Options[index]
        if option and typeof(entry) == "table" then
            local value = DeserializeValue(entry.Value)
            if entry.Type == "KeyPicker" and option.Type == "KeyPicker" then
                option:SetValue({ value, entry.Mode, DeserializeValue(entry.Modifiers) })
            elseif entry.Type == "ColorPicker" and option.Type == "ColorPicker" then
                option:SetValueRGB(value, entry.Transparency)
            elseif entry.Type == option.Type and option.SetValue then
                option:SetValue(value)
            end
        end
    end
    return true
end

function SaveManager:Save(name)
    if typeof(name) ~= "string" or name == "" then return false, "invalid name" end
    if not writefile or not EnsureFolder(Folder) then return false, "filesystem unavailable" end

    local ok, encoded = pcall(HttpService.JSONEncode, HttpService, self:CollectConfig())
    if not ok then return false, encoded end
    return pcall(writefile, Folder .. "/" .. name .. ".json", encoded)
end

function SaveManager:Load(name)
    if typeof(name) ~= "string" or name == "" then return false, "invalid name" end
    if not isfile or not readfile then return false, "filesystem unavailable" end

    local path = Folder .. "/" .. name .. ".json"
    if not isfile(path) then return false, "not found" end
    local ok, data = pcall(function()
        return HttpService:JSONDecode(readfile(path))
    end)
    if not ok then return false, data end
    return self:ApplyConfig(data)
end

function SaveManager:Delete(name)
    if typeof(name) ~= "string" or name == "" or not isfile or not delfile then return false end
    local path = Folder .. "/" .. name .. ".json"
    if not isfile(path) then return false end
    return pcall(delfile, path)
end

function SaveManager:ListConfigs()
    if not listfiles or not isfolder or not isfolder(Folder) then return {} end
    local configs = {}
    for _, file in listfiles(Folder) do
        local name = file:match("([^/\\]+)%.json$")
        if name then table.insert(configs, name) end
    end
    table.sort(configs)
    return configs
end

function SaveManager:BuildConfigSection(tab)
    if not Library then
        warn("[SaveManager] SetLibrary must be called before BuildConfigSection.")
        return
    end

    local group = tab:AddLeftGroupbox("Configuration")
    local nameInput = group:AddInput("SaveManager_ConfigName", {
        Text = "Config Name",
        Default = AutoloadName or "default",
        Placeholder = "config name",
        Finished = true,
    })
    group:AddButton({
        Text = "Save Config",
        Func = function()
            if nameInput.Value and nameInput.Value ~= "" then self:Save(nameInput.Value) end
        end,
    })
    group:AddButton({
        Text = "Load Config",
        Func = function()
            if nameInput.Value and nameInput.Value ~= "" then self:Load(nameInput.Value) end
        end,
    })
    group:AddButton({
        Text = "Delete Config",
        Func = function()
            if nameInput.Value and nameInput.Value ~= "" then self:Delete(nameInput.Value) end
        end,
    })
    group:AddDropdown("SaveManager_ConfigList", {
        Text = "Saved Configs",
        Values = self:ListConfigs(),
        Callback = function(value)
            if typeof(value) == "string" then nameInput:SetValue(value) end
        end,
    })

    local options = tab:AddRightGroupbox("Options")
    options:AddToggle("SaveManager_AutoSave", {
        Text = "Auto Save",
        Default = AutoSave,
        Callback = function(value) self:SetAutoSave(value) end,
    })
    options:AddToggle("SaveManager_Autoload", {
        Text = "Auto Load on Inject",
        Default = Autoload,
        Callback = function(value) self:SetAutoload(value, nameInput.Value) end,
    })
    return group
end

function SaveManager:LoadAutoloadConfig()
    if Autoload and AutoloadName then return self:Load(AutoloadName) end
    return false, "autoload is not configured"
end

function SaveManager:InitAutoSave()
    if not Library or not Library.GiveSignal or not game:GetService("RunService") then return end
    Library:GiveSignal(game:GetService("RunService").Heartbeat:Connect(function()
        if AutoSave and AutoloadName and os.clock() - LastAutoSave >= AutoSaveInterval then
            LastAutoSave = os.clock()
            self:Save(AutoloadName)
        end
    end))
end

return SaveManager
