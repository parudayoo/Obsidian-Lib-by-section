local ThemeManager = {}
ThemeManager.__index = ThemeManager

local Themes = {}
local ThemeOrder = {}
local CurrentTheme = "Default"
local ThemesFolder = "Obsidian/Themes"
local Library

local BaseScheme = {
    BackgroundColor = Color3.fromRGB(15, 15, 15),
    MainColor = Color3.fromRGB(25, 25, 25),
    AccentColor = Color3.fromRGB(125, 85, 255),
    OutlineColor = Color3.fromRGB(40, 40, 40),
    FontColor = Color3.new(1, 1, 1),
    RedColor = Color3.fromRGB(255, 50, 50),
    DarkColor = Color3.new(0, 0, 0),
    WhiteColor = Color3.new(1, 1, 1),
}

local function CopyScheme(source)
    local result = {}
    for key, value in source do
        result[key] = value
    end
    return result
end

local function RegisterBuiltin(name, overrides)
    local scheme = CopyScheme(BaseScheme)
    for key, value in (overrides or {}) do
        scheme[key] = value
    end
    Themes[name] = scheme
    table.insert(ThemeOrder, name)
end

RegisterBuiltin("Default", {})
RegisterBuiltin("Light", {
    BackgroundColor = Color3.fromRGB(240, 240, 240),
    MainColor = Color3.fromRGB(220, 220, 220),
    OutlineColor = Color3.fromRGB(180, 180, 180),
    FontColor = Color3.fromRGB(30, 30, 30),
})
RegisterBuiltin("Blood", { AccentColor = Color3.fromRGB(255, 50, 50) })
RegisterBuiltin("Ocean", { AccentColor = Color3.fromRGB(50, 150, 255) })
RegisterBuiltin("Emerald", { AccentColor = Color3.fromRGB(50, 200, 120) })

function ThemeManager:SetLibrary(library)
    Library = library
    return self
end

function ThemeManager:GetLibrary()
    return Library
end

function ThemeManager:SetFolder(folder)
    ThemesFolder = folder
    if isfolder and makefolder and not isfolder(ThemesFolder) then
        pcall(makefolder, ThemesFolder)
    end
    return self
end

function ThemeManager:ApplyTheme(name)
    local theme = Themes[name]
    if not theme or not Library or not Library.Scheme then
        return false
    end

    CurrentTheme = name
    for key, value in theme do
        if Library.Scheme[key] ~= nil then
            Library.Scheme[key] = value
        end
    end

    if Library.UpdateColorsUsingRegistry then
        Library:UpdateColorsUsingRegistry()
    end
    return true
end

function ThemeManager:GetCurrentTheme()
    return CurrentTheme
end

function ThemeManager:RegisterTheme(name, scheme)
    if typeof(name) ~= "string" or name == "" or typeof(scheme) ~= "table" then
        return false
    end
    Themes[name] = CopyScheme(scheme)
    if not table.find(ThemeOrder, name) then
        table.insert(ThemeOrder, name)
    end
    return true
end

function ThemeManager:GetThemeNames()
    return table.clone(ThemeOrder)
end

function ThemeManager:SaveTheme(name)
    if not writefile or not isfolder or not Themes[name] then
        return false, "filesystem unavailable or theme not found"
    end
    if not isfolder(ThemesFolder) then
        if not makefolder then return false, "makefolder unavailable" end
        local ok, err = pcall(makefolder, ThemesFolder)
        if not ok then return false, err end
    end

    local lines = {}
    for key, value in Themes[name] do
        if typeof(value) == "Color3" then
            table.insert(lines, string.format("%s=%f,%f,%f", key, value.R, value.G, value.B))
        elseif typeof(value) == "number" or typeof(value) == "boolean" or typeof(value) == "string" then
            table.insert(lines, string.format("%s=%s", key, tostring(value)))
        end
    end
    return pcall(writefile, ThemesFolder .. "/" .. name .. ".txt", table.concat(lines, "\n"))
end

function ThemeManager:LoadThemeFile(name)
    if not isfile or not readfile then return false end
    local path = ThemesFolder .. "/" .. name .. ".txt"
    if not isfile(path) then return false end

    local ok, contents = pcall(readfile, path)
    if not ok then return false end
    local scheme = {}
    for line in contents:gmatch("[^\r\n]+") do
        local key, value = line:match("^([^=]+)=(.+)$")
        if key and value then
            local red, green, blue = value:match("^([%d%.%-]+),([%d%.%-]+),([%d%.%-]+)$")
            if red then
                scheme[key] = Color3.new(tonumber(red), tonumber(green), tonumber(blue))
            elseif value == "true" then
                scheme[key] = true
            elseif value == "false" then
                scheme[key] = false
            elseif tonumber(value) then
                scheme[key] = tonumber(value)
            else
                scheme[key] = value
            end
        end
    end
    return self:RegisterTheme(name, scheme)
end

function ThemeManager:RefreshThemeList()
    if not isfolder or not listfiles then return end
    if not isfolder(ThemesFolder) then
        if not makefolder then return end
        pcall(makefolder, ThemesFolder)
    end
    if not isfolder(ThemesFolder) then return end

    for _, file in listfiles(ThemesFolder) do
        local name = file:match("([^/\\]+)%.txt$")
        if name and not Themes[name] then
            self:LoadThemeFile(name)
        end
    end
end

function ThemeManager:BuildThemeManager(window)
    self:RefreshThemeList()
    local tab = window:AddTab({ Name = "Themes", Icon = "palette" })
    local group = tab:AddLeftGroupbox("Themes")
    local dropdown = group:AddDropdown("ThemeManager_ThemeDropdown", {
        Text = "Theme",
        Values = self:GetThemeNames(),
        Default = CurrentTheme,
        Callback = function(value) self:ApplyTheme(value) end,
    })

    group:AddButton({
        Text = "Save Current Theme",
        Func = function() self:SaveTheme(CurrentTheme) end,
    })
    group:AddButton({
        Text = "Refresh Theme List",
        Func = function()
            self:RefreshThemeList()
            dropdown:SetValues(self:GetThemeNames())
        end,
    })
    return tab, dropdown
end

if getgenv then
    getgenv().ThemeManager = ThemeManager
end

return ThemeManager
