# Obsidian-Lib by section
### First, an overview of Obsidian UI
First, an overview of Obsidian UI:
Obsidian UI is a Roblox UI library known for its high quality and widespread adoption. It was developed by mspaint, the renowned script team behind Doors. Obsidian UI is the team’s second project, succeeding Linoria UI.

As an open-source library, Obsidian UI allows for deep customization. Based on it, Section UI is our customized extension that adds convenient features and enhancements, making it even more user-friendly for everyone.
### Extensions
**Mini Footer**


```MiniFooter, MiniFooterText, MiniFooterAnchor, MiniFooterAnchorSide, MiniFooterOffset, MiniFooterScreenNotMainUI```

**UI Frame**

```UIFrame, UIFrameColor, UIFrameThickness, UIFrameTransparency, frameColorRainbow```

**Icon disable**

```IconDisable```

**Font customizer**

```FontCustomizer, FontConfig```

**Extensions**

```Library:CreateConditionalHolder```

**UiLoading**
```loadwaittime, Window:loadwaittime("..."), UiLoadingCustomUI: function(Loading, Window), Loading.MainFrame ```

**TabDescribe**
```Window:TabDescribeIcon(ImageID, "Right")```

**ExAnimation**
```ExAnimation```

# explain
> Note: Honestly, I don’t even think I need to be here lol

**Mini Footer**

Full support for Mini Footer FPS/PING replacement: Automatic handling via dragging or top/bottom/left/right anchoring.

**UI Frame**
Add RGB border around Main UI
> hint: lol rainbow

**Icon disable**
Completely stop generating icons
> hint: We don’t really recommend using this feature at the moment

**Font customizer**

Specify the font using the Enum.Font name.

**Extensions**

Toggle GroupBox visibility by condition function

**UiLoading**

UI loading, Displays the standard loading screen. loadwaittime sets the display duration in seconds, and Window:loadwaittime("...") sets the display message.

Callback in the format of UiLoadingCustomUI: function(Loading, Window), allowing you to customize elements such as Loading.MainFrame.

**TabDescribe**
Displays a description, a smaller subtitle/description text, and an icon at the top. The icon can be specified via configuration options or by using Window:TabDescribeIcon(ImageID, "Right").


# example
**repo**
> Note🍭
```lua
local section = "https://raw.githubusercontent.com/parudayoo/Obsidian-Lib-by-section/refs/heads/main/"

local Library = loadstring(game:HttpGet(section .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(section .. "ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(section .. "SaveManager.lua"))()
```

> Note: These features are intended to be added to the function below.


```lua
local Window = Library:CreateWindow({
    -- existing
    Title = 'Section', -- <b></b> to customize Title
    Icon = '',
    Footer = 'V 1.0',
　　DisableSearch = false,
    EnableCompacting = true,
    SidebarCompacted = true,
    EnableSidebarResize = true,
    CornerRadius = 30,
    BackgroundImage = 'rbxassetid://',
    -- section
    MiniFooter = false,　-- true or false
    UIFrame = true, -- true or false
    IconDisable = false, -- true or false
    FontCustomizer = true, -- true or false
    Extensions = true, -- true or false
    UiLoading = false, -- true or false
    TabDescribe = false, -- true or false
    ExAnimation = false, -- false
})
```
### full example code
> hint: A fully functional UI example (virtually identical to the official Obsidian interface)

```lua
local section = "https://raw.githubusercontent.com/parudayoo/Obsidian-Lib-by-section/refs/heads/main/"

local Library = loadstring(game:HttpGet(section .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(section .. "ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(section .. "SaveManager.lua"))()

ThemeManager:SetLibrary(Library):SetFolder("MyScript/Themes")
SaveManager:SetLibrary(Library):SetFolder("MyScript/Configs")
-- Keep the explicit window colors below from being replaced by an old saved theme.
SaveManager:IgnoreThemeSettings()
SaveManager:SetAutoload(true, "default")
SaveManager:SetAutoSave(true, 30)

local Window = Library:CreateWindow({
    Title = "My Script",
    Footer = "v1.0",
    TitleTextEffect = true,
    TitleTextMultiT1 = "My Script",
    TitleTextMultiT2 = "Obsidian UI",
    TitleTextMultiT3 = "Welcome",
    TitleTextEffectConfig = function(_label, effect)
        effect:TypeR({ Interval = 0.04 })
        effect:MultiT({ Interval = 0.025, HoldTime = 0.8 })
        effect:FadeIO({ Duration = 0.2 })
        effect:WSWAP()
        effect:MCD({ Steps = 12, Interval = 0.04 })
    end,
    FooterTextEffect = true,
    FooterTextMultiT1 = "v1.0",
    FooterTextMultiT2 = "All systems ready",
    FooterTextEffectConfig = function(_label, effect)
        effect:MultiT({ Interval = 0.03, HoldTime = 1.2 })
        effect:FadeIO(0.25)
    end,
    ToggleKeybind = Enum.KeyCode.RightControl,
    NotifySide = "Right",

    -- Keep the mini footer visible while the main window is hidden.
    MiniFooter = true,
    MiniFooterText = "FPS: #FPS | PING: #PING",
    MiniFooterTextEffect = true,
    MiniFooterTextMultiT1 = "FPS: #FPS | PING: #PING",
    MiniFooterTextMultiT2 = "Status: active",
    MiniFooterTextEffectConfig = function(_label, effect)
        effect:MultiT({ Interval = 0.02, HoldTime = 1 })
        effect:WSWAP()
        effect:MCD({ Steps = 10, Interval = 0.05 })
    end,
    MiniFooterAnchor = true,
    MiniFooterAnchorSide = "down",
    MiniFooterOffset = 8,
    MiniFooterScreenNotMainUI = true,

    -- Thick rainbow border.
    UIFrame = true,
    UIFrameThickness = 6,
    frameColorRainbow = true,

    -- Startup loading screen.
    UiLoading = true,
    loadwaittime = 2.5,
    UiLoadingMessage = "Loading settings...",
    UiLoadingCustomUI = function(Loading, _Window)
        if Loading.MainFrame then
            Loading.MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        end
    end,

    -- Header description.
    TabDescribe = true,
    TabDescribeText = "Dashboard",
    TabDescribeMiniText = "Choose a setting from the tabs.",
    TabDescribeIcon = 1234567890, -- Replace with your Roblox image ID.
    TabDescribeIconOffset = "Right",

    ExAnimation = true,
    FontCustomizer = true,
    FontConfig = "Code",

    -- Access controls. The ID lists accept numbers or arrays of numbers.
    PremiumMode = true,
    PremiumKeyConfig = { "demo-24h#24H", "demo-life#Lifetime", "demo-week#1week" },
    -- This makes the current player premium in the demo. Use another ID to test denied access.
    PremiumUserID = { game.Players.LocalPlayer.UserId },
    VisiblePremiumMode = true,
    StaffMode = true,
    -- This makes the current player staff in the demo. Use another ID to test denied access.
    StaffUserID = { game.Players.LocalPlayer.UserId },
    VisibleStaffMode = true,

    -- Color and window decoration.
    RightTabsModes = true, -- Put the tab list on the right; false keeps it on the left.
    AccentColor = Color3.fromRGB(200, 100, 100),
    AccentColorRainbow = false, -- Turn on only when you want rainbow to override the static color.
    BackGroundColor = Color3.fromRGB(20, 20, 20),
    DynamicACBG = false, -- Turn on only when you want the animated gradient over the background.
    BannerImage = "rbxassetid://1234567890", -- Replace with your image ID, or "" to disable.
    PlayerProfile = true,
    dialog = true,

    -- Optional key gate. It is a client-side convenience check.
    KeySystem = true,
    Key = "example-key",
    KeysysNote = "Enter the key to open this UI.",
    Getkey = "https://example.com/get-key",
    GetkeyToMessage = "The link was copied if clipboard access is available.",
})

-- This string replaces the startup loading message.
Window:loadwaittime("Preparing the interface...")

local MainTab = Window:AddTab({ Name = "Main", Icon = "home", Description = "Main settings" })
local SettingsTab = Window:AddTab({ Name = "Settings", Icon = "settings", Description = "UI and config settings" })

local MainGroup = MainTab:AddLeftGroupbox("General")
local PremiumGroup = MainTab:AddGroupbox({ Name = "Premium controls", Side = 1, PremiumMode = true })
local StaffGroup = MainTab:AddGroupbox({ Name = "Staff controls", Side = 2, StaffMode = true })

local ModeDropdown
local Conditional

ModeDropdown = MainGroup:AddDropdown("ExampleMode", {
    Text = "Choose a mode",
    Values = { "None", "Mode A", "Mode B" },
    Default = "None",
    Callback = function(value)
        print("Selected mode:", value)
        if Conditional then
            Conditional:Refresh()
        end
    end,
})

MainGroup:PlayerDropbox("ExamplePlayer", {
    Text = "Select a player",
    ExcludeLocalPlayer = true,
    Callback = function(player)
        if player then
            print("Selected player:", player.DisplayName, "(@" .. player.Name .. ")")
        end
    end,
})

-- Selecting any mode except "None" reveals the extra toggle and dropdown.
Conditional = Library:CreateConditionalHolder({
    Parent = MainGroup.Container,
    Condition = function()
        return ModeDropdown.Value ~= "None"
    end,
})

Conditional:AddToggle("AdvancedToggle", {
    Text = "Advanced option",
    Default = false,
    Callback = function(value)
        print("Advanced option:", value)
    end,
})

Conditional:AddDropdown("AdvancedDropdown", {
    Text = "Advanced selection",
    Values = { "Option 1", "Option 2", "Option 3" },
    Default = "Option 1",
    Callback = function(value)
        print("Advanced selection:", value)
    end,
})

MainGroup:AddSlider("ExampleSlider", {
    Text = "Example Slider",
    Default = 25,
    Min = 0,
    Max = 100,
    Rounding = 0,
    Callback = function(value)
        print("Example Slider:", value)
    end,
})

MainGroup:AddButton({
    Text = "Example Button",
    Really = true,
    ReallyDescription = "Continue with this action?",
    Func = function()
        print("Button clicked")
    end,
})

PremiumGroup:AddToggle("PremiumExample", {
    Text = "Premium-only option",
    PremiumMode = true,
    Default = false,
})

PremiumGroup:AddButton({
    Text = "Premium-only button",
    PremiumMode = true,
    Func = function()
        print("Premium action")
    end,
})

PremiumGroup:AddInput("PremiumExampleInput", {
    Text = "Premium-only input",
    PremiumMode = true,
    Default = "",
    Callback = function(value)
        print("Premium input:", value)
    end,
})

PremiumGroup:AddDropdown("PremiumExampleDropdown", {
    Text = "Premium-only dropdown",
    PremiumMode = true,
    Values = { "Basic", "Advanced" },
    Default = "Basic",
    Callback = function(value)
        print("Premium dropdown:", value)
    end,
})

StaffGroup:AddToggle("StaffExampleToggle", {
    Text = "Staff-only toggle",
    StaffMode = true,
    Default = false,
})

StaffGroup:AddInput("StaffExampleInput", {
    Text = "Staff-only input",
    StaffMode = true,
    Default = "",
})

StaffGroup:AddDropdown("StaffExampleDropdown", {
    Text = "Staff-only dropdown",
    StaffMode = true,
    Values = { "Review", "Manage" },
    Default = "Review",
})

StaffGroup:AddButton({
    Text = "Staff-only action",
    StaffMode = true,
    Func = function()
        print("Staff action")
    end,
})

Window:PlanPlayerProfile({ "Example Plan", "Premium" })

-- Remove PremiumUserID above to test the sample redemption keys:
-- demo-24h, demo-life, and demo-week. KeySystem uses: example-key.

ThemeManager:BuildThemeManager(Window)
SaveManager:BuildConfigSection(SettingsTab)
SaveManager:LoadAutoloadConfig()
SaveManager:InitAutoSave()
```
# Credit
v1.4.2
by mazuiteam
for mspaint - obisidian
