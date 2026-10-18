extends Node

var menu_data: Dictionary = {
	"ice_floor": {
		"title" : "Ice Floor",
		"icon" : "",
		"desc" : "The floor is now slippery! Friction and acceleration are much higher! Scales with the level.",
		"points" : 100
	},
	"rigid_jump": {
		"title" : "Rigid Jump",
		"icon" : "",
		"desc" : "Now player can jump only with full force. No more small hops.",
		"points": 150
	},
	"popups": {
		"title" : "Popups",
		"icon" : "",
		"desc" : "Annoying ads. Close them with your mouse. Higher level means more frequent popups.",
		"points": 100
	},
	"wanna_keep_playing": {
		"title" : "Wanna keep playing?",
		"icon" : "",
		"desc" : "Annoying popup with two options. Choosing the 'No' option ends the game. 50% that the popup will be in a different language, sometimes troll text. Higher level means more frequent popups.",
		"points": 100
	},
	"mirror": {
		"title" : "Mirror",
		"icon" : "",
		"desc" : "Your screen might flip horizontaly. Higher level means longer time the screen is flipped and also more frequent flips",
		"points": 100
	},
	"random_shaders": {
		"title" : "Random Shaders",
		"icon" : "",
		"desc" : "Your screen might get a random shader (grayscale, Inverted colors, blur).  Higher level means more frequent shaders change.",
		"points": 100
	},
	"fall_damage": {
		"title" : "Fall Damage - Dark Souls Like",
		"icon" : "",
		"desc" : "Not immortal anymore. Get fall damage. Higher level means less falling time to die.",
		"points": 100
	},
	"random_animations": {
		"title" : "Random Animations",
		"icon" : "",
		"desc" : "Player's sprite now changes animations randomly. Higher level means more frequent changes",
		"points": 100
	},
	"immortal_snail": {
		"title" : "Immortal Snail",
		"icon" : "",
		"desc" : "It is always behind you. The snail slowly goes towards you. Higher level means more speed of the snail",
		"points": 100
	},
	"flashbang_cat": {
		"title" : "Flashbang cat",
		"icon" : "",
		"desc" : "Kitties on screen go boom. Use Mouse and hover them to make them dissapear. Higher level means higher speed of the cats and higher spawning frequency",
		"points": 100
	},
	"flashlight": {
		"title" : "Flashlight Mode",
		"icon" : "",
		"desc" : "It got dark... Use your mouse to see the path. Higher level means smaller radius of flashlight.",
		"points": 100
	},
	"lag": {
		"title" : "Lag",
		"icon" : "",
		"desc" : "The game intentionally lags. Small amount of FPS and glitch effect. Higher level means less FPS and more frequent lags",
		"points": 100
	},
	"dead_pixels": {
		"title" : "Dead Pixels",
		"icon" : "",
		"desc" : "Dead pixels are multiplying. Beat the level fast so they do not cover your entire screen. Higher level means more pixels and faster spreading",
		"points": 100
	},
	"gambling": {
		"title" : "Gambling",
		"icon" : "",
		"desc" : "Let's go gambling! 5% chance to die. Higher level means more frequent slot machine spawn",
		"points": 100
	},
	"visual_effects" : {
		"title": "Visual Effects",
		"icon" : "",
		"desc": "Cool fireworks! Direworks can randomly start shooting. Higher levels means more frequent events and more particles",
		"points" : 100
	}
}
