# LEDSpicer Plugin

The LEDSpicer Plugin for AttractMode works with LEDSpicer to change your lighting configuration based on your currently selected ROM in AttractMode.

## Installation

*NOTE:* Make sure you have [LEDSpicer](https://github.com/meduzapat/LEDSpicer/wiki) installed and configured or this plugin will not work, and will probably aggravate your system.

Once you've confirmed LEDSpicer is installed and working, add the LEDSpicer Plugin folder to the plugins folder of AttractMode (make sure the correct permissions are set on the folder so that AttractMode can see the newly added plugin). Start (or restart) AttractMode and enable the plugin.

## Setup

The plugin calls the LEDSpicer app with a command similar to this:

    ledspicer LoadProfileByEmulator digdug arcade -f "NO_ROTATOR"

This will tell LEDSpicer what profile to use based on the currently selected ROM name and emulator name, but will not make any changes to dynamic joysticks like the Ultimarc Ultrastik 360, Servostiks or others.

*VERY IMPORTANT CONFIGURATION NOTE:* The emulator name is the *configured emulator name* in AttractMode. If you named your emulator "Bob" when you created it in AttractMode, then the emulator name passed to LEDSpicer will be "Bob". So, name it something like "Arcade" (if using RetroPie) or "NES", "Daphne", "Mame" etc. Any uppercase letters in the name will be converted to lowercase, so you at least don't have to worry about that.

## Options

![Plugin Options Menu](https://github.com/meduzapat/LEDSpicer-AttractMode/assets/15333057/0ea00bb1-a8c2-47f8-87a0-91a38c1bde10)

The LEDSpicer Plugin allows you to configure the following options:

1. **Rotate Joysticks**: This option enables the plugin to automatically rotate joysticks to match the configuration required by the current game. If this option is enabled, dynamic joysticks like the Ultimarc Ultrastik 360 or Servostiks will be rotated accordingly.

2. **Reset Joysticks**: This option allows the plugin to reset joysticks to their default position or configuration when exiting a game or returning to the menu. This ensures that the joysticks are in a known state before starting another game.

3. **Iteration Type**: This option determines how the LEDSpicer profile changes as you navigate through AttractMode. There are three settings for this option:
   - **None**: No profile changes occur during navigation.
   - **ROM**: The profile changes based on the currently selected ROM. This provides immediate feedback and lighting changes based on the selected game, even before starting it.
   - **Emulator**: The profile changes based on the selected gaming system or emulator. When you select a different system, the lighting profile will adjust to match the requirements of that system.

4. **Allow Animations on Navigation**: If enabled, this option permits animations to play when navigating through games. These animations can be configured in LEDSpicer and provide a more dynamic visual experience as you browse your game collection.

5. **Screensaver Mode**: This option activates a screensaver mode where a predefined lighting pattern or animation is displayed when AttractMode is idle for a certain period. This is useful for showcasing your setup or protecting your display from burn-in.

