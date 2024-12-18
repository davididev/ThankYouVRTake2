extends Node2D

@export var possibleImages : Array[NodePath];
@export var root : NodePath;
var x : int = 0;
var y : int = 0;
var hover_empty_node = false;
const IMAGE_EMPTY = 0;
const IMAGE_SINGLE_FORK = 1;
const IMAGE_MULTI_FORK = 2
const IMAGE_NO_FORK = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("OptionButton").visible = false;

func RefreshNode(myself : DialogueEntry):
	if myself == null:
		SetImage(IMAGE_EMPTY);
		get_node("txt_NodeName").text = "";
		get_node("OptionButton").visible = false;
		get_node("Txt_Main").text = "";
	else:
		get_node("OptionButton").visible = true;
		if myself.cmd == "str":
			SetImage(IMAGE_SINGLE_FORK);
			get_node("txt_NodeName").text = "Dialogue Box";
		if myself.cmd == "choice":
			SetImage(IMAGE_MULTI_FORK);
			get_node("txt_NodeName").text = "Choice Selection";
		if myself.cmd == "var":
			SetImage(IMAGE_SINGLE_FORK);
			get_node("txt_NodeName").text = "Set/Modify Var";
		if myself.cmd == "ifthen":
			SetImage(IMAGE_MULTI_FORK);
			get_node("txt_NodeName").text = "If/Then/Else";
		if myself.cmd == "msg":
			SetImage(IMAGE_SINGLE_FORK);
			get_node("txt_NodeName").text = "Send Message";
		if myself.cmd == "move":
			SetImage(IMAGE_SINGLE_FORK);
			get_node("txt_NodeName").text = "Move Actor";
		if myself.cmd == "wait":
			SetImage(IMAGE_SINGLE_FORK);
			get_node("txt_NodeName").text = "Wait";
		if myself.cmd == "flash":
			SetImage(IMAGE_SINGLE_FORK);
			get_node("txt_NodeName").text = "Flash";	
		if myself.cmd == "snd":
			SetImage(IMAGE_SINGLE_FORK);
			get_node("txt_NodeName").text = "Play Sound";	
		if myself.cmd == "mus":
			SetImage(IMAGE_SINGLE_FORK);
			get_node("txt_NodeName").text = "Play Music";	
		if myself.cmd == "end":
			SetImage(IMAGE_NO_FORK);
			get_node("txt_NodeName").text = "End event";
		if myself.cmd == "sce":
			SetImage(IMAGE_NO_FORK);
			get_node("txt_NodeName").text = "Change scene";	
		if myself.cmd == "tel":
			SetImage(IMAGE_SINGLE_FORK);
			get_node("txt_NodeName").text = "Teleport actor";
		if myself.cmd == "ais":
			SetImage(IMAGE_MULTI_FORK);
			get_node("txt_NodeName").text = "Add Item/Spell";
		if myself.cmd == "cis":
			SetImage(IMAGE_SINGLE_FORK);
			get_node("txt_NodeName").text = "Count Item/Spell";
		var args = myself.GetArguments();
		var argsStr = "";
		for arg in args:
			argsStr = str(argsStr, arg, "\n");
		get_node("Txt_Main").text = argsStr;

func SetImage(id : int):
	var i = 0;
	for np : NodePath in possibleImages:
		get_node(np).set_visible(i == id);
		i += 1;


func SetCoord(x1 : int, y1 : int):
	x = x1;
	y = y1;
	get_node("txt_Coord").text = str("(", x, ",", y, ")");
	

func InitNode(ref : DialogueEntry):
	if ref == null:
		SetImage(0);
		return;
	
	#Blue nodes (1) don't have multiple forks, Red nodes do.
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if hover_empty_node:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			#print("Clicked empty node.  TODO: Add create node.");
			get_node(root).CreateNewNode(x, y);
			hover_empty_node = false;

func _on_node_empty_mouse_entered() -> void:
	if get_node("NodeEmpty").visible == true:
		hover_empty_node = true;
		get_node("NodeEmpty").modulate = Color(1.0, 1.0, 1.0, 1.0);


func _on_node_empty_mouse_exited() -> void:
	if get_node("NodeEmpty").visible == true:
		hover_empty_node = false;
		get_node("NodeEmpty").modulate = Color(1.0, 1.0, 1.0, (55.0 / 255.0));


func _on_option_button_item_selected(index: int) -> void:
	if index == 0:  #Edit
		get_node(root).StartEditNode(x, y);
	if index == 1:
		get_node(root).DeleteNode(x, y);
	get_node("OptionButton").selected = -1;
