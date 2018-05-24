extends Node

#objects that can't be thrown away can't be sold either
var objects = [
	{"name": "Shield",
	 "cost": 100,
	 "throwable": true,
	 "equipable": true,
	 "infos": {} 
	 }, 
	{"name": "Useless Object",
	"cost": 150,
	"throwable": true,
	"equipable": false,
	"infos": {} 
	},
	{"name": "Useless annoying Object",
	"cost": 0,
	"throwable": false,
	"equipable": false,
	"infos": {} 
	}
]

var player_name = "UNKNOWN"
var gold = 500

func add_object_in_inventory(obj): 
	objects.push_back(obj)
	
func remove_object_from_inventory(obj):
	objects.remove(obj)