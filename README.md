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

# example
> Note: These features are intended to be added to the function below.


```lua
local Window = Library:CreateWindow({
    MiniFooter = false,
    UIFrame = true,
    IconDisable = false,
    FontCustomizer = true,
    Extensions = true,
})
