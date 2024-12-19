extends Node3D

@export var Dialogue1 : DialogueGrid;
@export var Dialogue2 : DialogueGrid;
@export var Particles : NodePath;
var pickedUp = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pickedUp = false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_internet_pickup_grabbed(pickable: Variant, by: Variant) -> void:
	pickedUp = true;
	DialogueHandler.Instance.StartDialogue(Dialogue1);


func _on_internet_pickup_body_entered(body: Node) -> void:
	if pickedUp == true:
		DialogueHandler.Instance.StartDialogue(Dialogue2);
		get_node(Particles).set_emitting(true);
