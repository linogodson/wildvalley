extends Node

var gold = 0

var items = {
	0: {
		"Name": "Apple",
		"Des": "This is an apple!",
		"Cost": 2,
		"Icon": preload("res://arts/Apple.png"), # check if file exists
	},
	1: {
		"Name": "Banana",
		"Des": "This is a banana!",
		"Cost": 5,
		"Icon": preload("res://arts/banana.png"), # update path if needed
	},
	2: {
		"Name": "Kiwi",
		"Des": "This is a kiwi!",
		"Cost": 7,
		"Icon": preload("res://arts/kiwi.png"), # update path if needed
	},
	3: {
		"Name": "Cherry",
		"Des": "This is a cherry!",
		"Cost": 9,
		"Icon": preload("res://arts/cherry.png"), # update path if needed
	},
}

var inventory = {}
