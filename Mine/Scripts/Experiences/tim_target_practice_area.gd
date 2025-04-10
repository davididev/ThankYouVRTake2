class_name ShootingGalleryController extends Node3D

@export var TargetPrefabs : Array[PackedScene];
@export var ExplosionsPrefabs : Array[PackedScene];

static var Explosions : Array[PackedScene]

var process_timer = 0.0;
const MAKE_TARGET_TIME = 1.5;

func _ready():
	Explosions.clear();
	for i in range(0, TargetPrefabs.size()):
		TargetPrefabs[i].instantiate();
		
	for i in range(0, ExplosionsPrefabs.size()):
		var tempInst = ExplosionsPrefabs[i].instantiate();
	
	Explosions = ExplosionsPrefabs;

func _process(delta: float) -> void:
	
	if LightningChainGun.HoldingGun == true:
		process_timer -= delta;
		if process_timer < 0.0:
			process_timer = MAKE_TARGET_TIME;
			_create_target();
		pass;
	else:
		var nodes = get_tree().get_nodes_in_group(&"Target");
		if !nodes.is_empty():
			for n in nodes:
				n.queue_free();

func _create_target():
	
	var possibleChildIDs : Array[int];
	for i in range(0, get_child_count()):
		if get_child(i).get_child_count() == 0:
			possibleChildIDs.append(i);
	
	if possibleChildIDs.is_empty():
		return;
	
	var chance = randi_range(0, 100);
	var childID = randi_range(0, possibleChildIDs.size() - 1);
	
	if chance >= 0 and chance <= 60:
		var inst = TargetPrefabs[0].instantiate();
		get_child(possibleChildIDs[childID]).add_child(inst)
		inst.position = Vector3.ZERO;
	if chance >= 61 and chance <= 90:
		var inst = TargetPrefabs[1].instantiate();
		get_child(possibleChildIDs[childID]).add_child(inst)
		inst.position = Vector3.ZERO;
	if chance >= 91 and chance <= 100:
		var inst = TargetPrefabs[2].instantiate();
		get_child(possibleChildIDs[childID]).add_child(inst)
		inst.position = Vector3.ZERO;		
		
