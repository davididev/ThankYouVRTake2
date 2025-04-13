class_name BeatEntry extends Resource

#https://docs.godotengine.org/en/stable/classes/class_array.html#class-array-method-sort-custom
@export var BTime : float;
@export var Targets : Array[int];

const EMPTY = 0;
const LEFT_HAND = 1;
const RIGHT_HAND = 2;
const MINE = 3;

#Should be called whenever a new beat entry is made
func EmptyEntry(t : float = 0.0):
	BTime = t;
	
	for i in range(0, 16):
		Targets.append(0);  #Empty slots
	
func GetTargetValue(x : int, y : int):
	var id : int = (y * 4) + x;
	return Targets[id];

func SetTargetValue(val : int, x : int, y: int):
	var id : int = (y * 4) + x;
	Targets[id] = val;
