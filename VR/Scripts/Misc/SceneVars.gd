class_name SceneVars extends Node3D

@export var MusicPath : String = "Song.mp3";
@export var DialogueOnStart : DialogueGrid;
@export var StopMusic = false;

@export var starting_pool_items : Array[PackedScene];
@export var starting_pool_names : Array[String];

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	if MusicPath != "":
		PlayMusic.PlaySong(MusicPath);
	
	if StopMusic:
		PlayMusic.PlaySong("");
	if DialogueOnStart != null:
		await get_tree().create_timer(0.1).timeout;
		DialogueHandler.Instance.StartDialogue(DialogueOnStart);

	if starting_pool_items.size() > 0:
		_initpool();

func _initpool():
	for i in range(0, starting_pool_items.size()):
		Node3DPool.InitPoolItem(get_tree(), starting_pool_names[i], starting_pool_items[i], 40);

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
