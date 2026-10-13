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
    MiniFooter = false,　-- true or false
    UIFrame = true, -- true or false
    IconDisable = false, -- true or false
    FontCustomizer = true, -- true or false
    Extensions = true, -- true or false
})
```
### full example code
> hint: A fully functional UI example (virtually identical to the official Obsidian interface)

```lua
-- repo(section) loading
local section = "https://raw.githubusercontent.com/parudayoo/Obsidian-Lib-by-section/refs/heads/main/"

local Library = loadstring(game:HttpGet(section .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(section .. "ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(section .. "SaveManager.lua"))()

-- Managers
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("MyScript/Themes")

SaveManager:SetLibrary(Library)
SaveManager:SetFolder("MyScript/Configs")
SaveManager:SetAutoload(true, "default")
SaveManager:SetAutoSave(true, 30)

-- Window
local Window = Library:CreateWindow({
    Title = "Section",
    Footer = "v1.0.0｜section ui by mspaint",
    ToggleKeybind = Enum.KeyCode.RightControl,
    NotifySide = "Right",

    -- Section UI extensions (optional)
    MiniFooter = true,
    MiniFooterText = "Section | FPS: #FPS | PING: #PING",
    MiniFooterAnchor = true,
    MiniFooterAnchorSide = "down",
    MiniFooterOffset = 8,

    UIFrame = true,
    UIFrameColor = Color3.fromRGB(125, 85, 255),
    UIFrameThickness = 4,

    FontCustomizer = true,
    FontConfig = "Arcade",
})

-- Tabs
local MainTab = Window:AddTab({ Name = "Main", Icon = "home" })
local SettingsTab = Window:AddTab({ Name = "Settings", Icon = "settings" })

-- Main controls
local MainGroup = MainTab:AddLeftGroupbox("General")

MainGroup:AddToggle("ExampleToggle", {
    Text = "Example Toggle",
    Default = false,
    Callback = function(value)
        print("Example Toggle:", value)
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

MainGroup:AddDropdown("ExampleDropdown", {
    Text = "Example Dropdown",
    Values = { "Option 1", "Option 2", "Option 3" },
    Default = 1,
    Callback = function(value)
        print("Example Dropdown:", value)
    end,
})

MainGroup:AddInput("ExampleInput", {
    Text = "Example Input",
    Default = "",
    Placeholder = "Type something",
    Finished = true,
    Callback = function(value)
        print("Example Input:", value)
    end,
})

MainGroup:AddButton({
    Text = "Example Button",
    Func = function()
        print("Button clicked")
    end,
})

-- Manager UI
ThemeManager:BuildThemeManager(Window)
SaveManager:BuildConfigSection(SettingsTab)

-- Load the autoload config after creating the controls.
SaveManager:LoadAutoloadConfig()
SaveManager:InitAutoSave()
```
