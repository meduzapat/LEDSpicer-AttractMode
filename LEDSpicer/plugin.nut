/**
 * Attract-Mode Frontend -  LEDSpicer launcher
 * 
 * By Patricio Rossi
 * Based on the Plugin by mahuti https://github.com/meduzapat/LEDSpicer-AttractMode
 *
 * requires LEDSpicer to be installed and configured to use.
 *
 */

fe.load_module("helpers")

/***********************
 * Plugin User Options *
 ***********************/
class UserConfig </ help="This plugin: 1. Changes light profiles while navigating AM based on the currently shown rom. 2. Changes light and joystick profiles when a rom is launched. FOR ARCADE SYSTEMS: Emulator System Name must include one of the following, arcade, mame, neo geo, neogeo, fba, final burn, or daphne. FOR CONSOLES: Emulator System Name must match the LEDSPicer profile name (for instance a system named \"Nintendo Entertainment System\" will launch the \"Nintendo Entertainment System.xml\" profile ) " /> {
	</ label = "Joystick Default Position",
		options="4-way,8-way,Analog,None,Vertical 2-way"
		help="If using dynamic joysticks, you can set a default joystick mode to use while in AttractMode. Your joystick must support the selected mode, or the closest mode will be used instead.",
		order=0
	/>
	default_rotation = "4-way"

	</ label = "Joystick System Position",
		options="4-way,8-way,Analog,None,Vertical 2-way"
		help="If using dynamic joysticks, you can set the joystick mode to use when leaving AttractMode. Your joystick must support the selected mode, or the closest mode will be used instead.",
		order=1
	/>
	system_rotation = "Analog"

	</ label="Interaction Type",
		options="Rom,Emulator,None",
		help="Rom will display the current ROM controllers, Emulator will load a profile for the current emulator system ex: system_arcade, None will keep the default profile.",
		order=2
	/>
	display_selected = "Rom"

	</ label="Allow animations on navigation",
		options="Yes,No",
		help="If you want the profile animations to be used while in select mode.",
		order=3
	/>
	allow_animations = "Yes"

	</ label="Screen Saver profile",
		help="The profile to execute when the screen Saver starts.",
		order=4
	/>
	screensaver = ""
}

class LEDSpicer {

	config           = null
	default_rotation = ""
	system_rotation  = ""
	display_selected = true
	display          = ""
	type             = ""
	currentRom       = ""
	allow_animations = false
	screensaver      = ""
	debug            = false // Set to true for debugging only.

	constructor() {
		config           = fe.get_config()
		display_selected = config["display_selected"] != "None"
		display          = config["display_selected"]
		allow_animations = config["allow_animations"] == "Yes"
		screensaver      = config["screensaver"]
		default_rotation = extractMode(config["default_rotation"])
		system_rotation  = extractMode(config["system_rotation"])
		fe.add_transition_callback(this, "loadgame")
	}

	/**
	 * Convert the mode selection to rotator mode.
	 * @param mode the mode to use.
	 * @return string
	 */
	function extractMode(mode) {
		switch (mode) {
			case "Vertical 2-way": return "vertical2"
			case "8-way":          return "8"
			case "Analog":         return "analog"
			case "None":           return "None"
			default:               return "4"
		}
	}

	/**
	 * Launches the game profile.
	 * @return null
	 */
	function launch() {
		if (debug) {
			print("Loading \"" + currentRom + "\"\nEmulator is " + type + "\n")
		}
		system("emitter LoadProfileByEmulator \"" + currentRom + "\" " + type + " > /dev/null 2>&1")
	}

	function select() {
		currentRom = fe.game_info(Info.Name)
		type       = fe.game_info(Info.Emulator).tolower()
		// Check for arcade-type systems.
		if (regexp("f(?:inal burn|ba)|neo ?geo|(?:daphn|mam)e|arcade").match(type)) {
			type = "arcade"
		}

		if (display != "Rom") {
			return
		}

		local flags = "-f \"NO_TRANSITIONS|NO_INPUTS|NO_ROTATOR|REPLACE"
		if (!allow_animations) {
			flags += "|NO_ANIMATIONS"
		}
		flags += "\""

		if (debug) {
			print("Selecting \"" + currentRom + "\"\nEmulator is " + type + "\n\"Flags: " + flags + "\n")
		}
		system("emitter LoadProfileByEmulator \"" + currentRom + "\" " + type + " " + flags + " > /dev/null 2>&1")
	}

	function change() {
		if (display != "Emulator") {
			return
		}
		
		local currentDisplay = fe.displays[fe.list.display_index].name

		if (debug) {
			print("Changing to system \"" + currentDisplay + "\"\n")
		}
		system("emitter LoadProfile \"system_" + currentDisplay + "\" -f \"NO_TRANSITIONS|REPLACE\" > /dev/null 2>&1")
	}

	/**
	 * Reset
	 * 
	 * Clears last profile and returns to the previous profile.
	 * @param rotate rotate hardware.
	 * @param wheel reset back to wheel.
	 * @return null
	 */
	function reset(rotate) {
		if (debug) {
			print("Reseting\n" + (rotate ? "Rotating to: " + default_rotation + "\n": "") + "\n")
		}
		system("emitter FinishLastProfile -f \"NO_TRANSITIONS\" > /dev/null 2>&1")
		if (rotate && default_rotation != "None") {
			system("rotator -r " + default_rotation + " > /dev/null 2>&1")
		}
	}

	/**
	 * When AT starts, Rotate to default and load current game profile.
	 */
	function startup() {
		if (debug) {
			print("Starting\nRotating to: " + default_rotation + "\n")
		}
		if (default_rotation != "None") {
			system("rotator -r " + default_rotation + " > /dev/null 2>&1")
		}
		select()
	}

	/**
	 * When AM ends, kill all profiles and set rotation to system default.
	 */
	function shutdown() {
		if (debug) {
			print("Shutting down\nRotating to: " + system_rotation + "\n")
		}
		if (system_rotation != "None") {
			system("rotator -r " + system_rotation + " > /dev/null 2>&1")
		}
		system("emitter FinishAllProfiles > /dev/null 2>&1")
	}

	/**
	 * loadgame
	 * transition callback
	 * 
	 * both manual and automatic modes
	 * 
	 * launches emitter & rotator on ToGame
	 * resets emitter & rotator on FromGame
	 *
	 * @return false
	 */
	function loadgame(ttype, var, ttime) {
		switch (ttype) {
			// Launch game.
			case Transition.ToGame:
				launch()
				break
			// Game selected.
			case Transition.FromOldSelection:
				select()
				break
			// Game ended.
			case Transition.FromGame:
				reset(true)
				select()
				break
			case Transition.StartLayout:
				switch (var) {
				// Starting up.
				case FromTo.Frontend:
					startup()
					break
				// Screen saver ended.
				case FromTo.ScreenSaver:
					if (screensaver != "") {
						if (debug) {
							print("End screensaver\n")
						}
						reset(false)
						select()
					}
					break
				}
				break
			case Transition.EndLayout:
				switch (var) {
				// Shutting down.
				case FromTo.Frontend:
					shutdown()
					break
				// Screen saver started.
				case FromTo.ScreenSaver:
					if (screensaver != "") {
						if (debug) {
							print("Screensaver " + screensaver + "\n")
						}
						system("emitter LoadProfile \"" + screensaver + "\" -f \"NO_INPUTS\" > /dev/null 2>&1")
					}
					break
				}
				break
			case Transition.ToNewList:
				reset(false)
				select()
				change()
				break
		}
		// No refersh needed.
		return false
	}
}
fe.plugin["LEDSpicer"] <- LEDSpicer()

