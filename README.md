# Obsidian-Lib by section
### First, an overview of Obsidian UI
First, an overview of Obsidian UI:
Obsidian UI is a Roblox UI library known for its high quality and widespread adoption. It was developed by mspaint, the renowned script team behind Doors. Obsidian UI is the team’s second project, succeeding Linoria UI.

As an open-source library, Obsidian UI allows for deep customization. Based on it, Section UI is our customized extension that adds convenient features and enhancements, making it even more user-friendly for everyone.
### Extensions
**Mini Footer**


```MiniFooter, MiniFooterText, MiniFooterAnchor, MiniFooterAnchorSide, MiniFooterOffset```

**UI Frame**

```UIFrame, UIFrameColor, UIFrameThickness, UIFrameTransparency```

**Icon disable**

```IconDisable```

**Font customizer**

```FontCustomizer, FontConfig```

**Extensions**

```Library:CreateConditionalHolder```

# explain
> Note: Honestly, I don’t even think I need to be here lol
**Mini Footer**

Full support for Mini Footer FPS/PING replacement: Automatic handling via dragging or top/bottom/left/right anchoring.

**UI Frame**
Add RGB border around Main UI
> hint: I'll add Rainbow at some point, don't worry 😉

**Icon disable**
Completely stop generating icons
> hint: We don’t really recommend using this feature at the moment

**Font customizer**

Specify the font using the Enum.Font name.

**Extensions**

Toggle GroupBox visibility by condition function



# example
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
local Window = Library:CreateWindow({
    Title = "Section UI by Obsidian ui",
    Footer = "v1.0.0",

    -- Mini Footer
    MiniFooter = true,
    MiniFooterText = "FPS: #FPS | PING: #PING | User: " .. game.Players.LocalPlayer.Name,
    MiniFooterAnchor = true,
    MiniFooterAnchorSide = "down", -- up / down / left / right
    MiniFooterOffset = 8,

    -- UI Frame
    UIFrame = true,
    UIFrameColor = Color3.fromRGB(125, 85, 255),
    UIFrameThickness = 2,

    -- Icon full disable
    IconDisable = false,

    -- Font
    FontCustomizer = true,
    FontConfig = "Gotham",
})

local Tab = Window:AddTab("Main", "home")
local Group = Tab:AddLeftGroupbox("Settings")

local Toggle = Group:AddToggle("AutoFarm", { Text = "Auto Farm", Default = false })

-- Extensions example
local Conditional = Library:CreateConditionalHolder({
    Parent = Group.Container,
    Condition = function()
        return Toggle.Value == true
    end,
})

-- Elements can be added to conditional holders using the same API as for standard holders.
Conditional:AddSlider("Speed", { Text = "Speed", Min = 1, Max = 100, Default = 16 })
Conditional:AddButton({ Text = "Execute", Func = function() print("Executed!") end })
```
