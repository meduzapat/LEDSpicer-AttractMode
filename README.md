# LEDSpicer Plugin for Attract-Mode

The LEDSpicer Plugin for Attract-Mode works with LEDSpicer to change your lighting configuration and joystick restrictors based on your currently selected ROM.

## Requirements

- [LEDSpicer](https://github.com/meduzapat/LEDSpicer) 0.7.0+ (compatible with 0.6.4+)
- Attract-Mode frontend

## Installation

1. Make sure LEDSpicer is installed and configured
2. Copy the `LEDSpicer` folder to your Attract-Mode plugins directory
3. Ensure correct permissions are set so Attract-Mode can access the plugin
4. Start (or restart) Attract-Mode and enable the plugin

## How It Works

The plugin calls the LEDSpicer emitter with commands like:
```
emitter LoadProfileByEmulator digdug arcade -f "NO_ROTATOR"
```

This tells LEDSpicer which profile to load based on the currently selected ROM and emulator name.

**Important:** The emulator name passed to LEDSpicer is the *configured emulator name* in Attract-Mode. If you named your emulator "Bob", then "bob" will be passed to LEDSpicer (uppercase is converted to lowercase). Use descriptive names like "arcade", "nes", "daphne", "mame", etc.

### Arcade Detection

The plugin automatically detects arcade-type systems by matching emulator names containing: `arcade`, `mame`, `neo geo`, `neogeo`, `fba`, `final burn`, or `daphne`.

## Options

![Plugin Options Menu](https://github.com/meduzapat/LEDSpicer-AttractMode/assets/15333057/0ea00bb1-a8c2-47f8-87a0-91a38c1bde10)

### Joystick Default Position

Sets the restrictor mode while navigating Attract-Mode.

Options: `4-way`, `8-way`, `Analog`, `None`, `Vertical 2-way`

### Joystick System Position

Sets the restrictor mode when exiting Attract-Mode (returning to the system).

Options: `4-way`, `8-way`, `Analog`, `None`, `Vertical 2-way`

### Interaction Type

Determines how LED profiles change during navigation:

| Setting | Behavior |
|---------|----------|
| None | No profile changes occur during navigation |
| Rom | Profile changes based on the currently selected ROM |
| Emulator | Profile changes based on the selected system/emulator |

### Allow Animations on Navigation

When enabled, profile animations will play while browsing games. Disable for static lighting during navigation.

### Screen Saver Profile

The profile name to load when the screen saver activates. Leave empty to disable screen saver integration.

![ledspicerTag1](https://github.com/meduzapat/LEDSpicer-AttractMode/assets/15333057/080214ca-8c37-4716-a178-bd18c95b3eab)

## Debugging

To enable debug output, edit `plugin.nut` and set:
```squirrel
debug = true
```

This will print diagnostic information to the console.
