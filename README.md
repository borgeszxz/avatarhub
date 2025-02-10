# AvatarHub 1.0  
**Advanced Character Control Hub for Roblox**  
By: **borges**

## Overview  
AvatarHub is a powerful and intuitive character control script designed to enhance your Roblox gameplay. It provides several key features, such as **Slow Walk**, **Speed Control**, **NoClip**, **Invisibility**, and **Mouse Teleport**, all accessible through a sleek and interactive UI.  

Built using the **Fluent Library**, AvatarHub delivers a seamless user experience and customization options.

---

## Features  

### 🔑 **Main Features**
1. **Slow Walk**  
   - Enables slower walking speed for precision movement.
   - Default speed: **8** (adjustable in the script).
   - Togglable via the **Slow Walk** tab.

2. **Speed Control**  
   - Allows full control over your character's walking speed.
   - Adjustable via a slider (**2-200**) and a reset button for default speed (**16**).

3. **NoClip**  
   - Allows the player to walk through walls and objects.
   - Fully togglable with notifications for activation and deactivation.

4. **Invisibility**  
   - Makes the player invisible (including accessories and decals).
   - Togglable with instant feedback notifications.

5. **Mouse Teleport**  
   - Teleports your character to the mouse cursor position.
   - Activated with the **T** key by default.
   - Togglable for activation/deactivation.

---
## How to Use  

### 🎛 **Tabs and Functionalities**

1. **Welcome Tab**  
   - Displays general information about the hub.  
   - Serves as the starting point when the hub is opened.

2. **Slow Walk**  
   - Toggle to enable or disable slow walking.
   - Default speed: **8**.
   - Automatically reverts to normal speed when disabled.

3. **Speed Control**  
   - Adjust walking speed with a slider.
   - Reset button to revert to default walking speed (**16**).

4. **NoClip**  
   - Toggle to walk through walls and objects.
   - Notifications confirm the current state.

5. **Invisibility**  
   - Toggle to become invisible or visible.
   - Works on body parts, accessories, and decals.

6. **Mouse Teleport**  
   - Enable to teleport to the mouse cursor position using the **T** key.
   - Notifications inform you of the feature's activation state.

7. **Settings**  
   - Save and manage your configurations.
   - Customize the hub’s appearance and settings.

---

## Script Breakdown  

### **Library Initialization**  
The script uses the **Fluent Library** to build the interface, manage settings, and provide notifications.  
Key components include:
- **Library**: Core UI and theme management.
- **SaveManager**: Handles saving and loading configurations.
- **InterfaceManager**: Manages the appearance of the interface.

### **Feature Implementation**  

#### **Slow Walk**  
- Uses a toggle button to switch between normal and slow walking speeds.  
- Example:  
```lua
humanoid.WalkSpeed = Value and 8 or 16
```

#### **Speed Control**  
- Provides a slider for adjusting the walking speed in real time.  
- Example:  
```lua
humanoid.WalkSpeed = SliderValue
```

#### **NoClip**  
- Adjusts `CanCollide` property of all character parts to enable/disable collision.  
- Example:  
```lua
part.CanCollide = not Value
```

#### **Invisibility**  
- Sets transparency of all character parts, including accessories and decals.  
- Example:  
```lua
part.Transparency = Value and 1 or 0
```

#### **Mouse Teleport**  
- Teleports the player’s `HumanoidRootPart` to the mouse cursor position.  
- Example:  
```lua
humanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 3, 0))
```

---

## Notifications  

- Every action triggers a notification to provide instant feedback.
- Example Notifications:  
  - **Slow Walk enabled**: `"Slow Walk successfully enabled!"`  
  - **Mouse Teleport error**: `"No valid position under the mouse!"`

---

## Configuration Management  

- **SaveManager** and **InterfaceManager** handle saving and restoring configurations.  
- Settings are stored in the `"FluentScriptHub"` folder.  

Example configuration setup:
```lua
SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)
SaveManager:SetFolder("FluentScriptHub")
```

---

## Keybinds  

| Feature          | Default Key |  
|------------------|-------------|  
| Mouse Teleport   | `T`         |  

---
