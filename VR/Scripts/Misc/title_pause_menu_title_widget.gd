extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_return_to_title_pressed() -> void:
	Engine.time_scale = 1.0;  #Return normal game scale
	var args : Array[String];
	args.append("Mine/Scenes/TitleScreen.tscn");
	args.append("0.0,0.0,0.0");
	DialogueHandler.Instance.SteamTeleport(args);


func _on_button_quit_pressed() -> void:
	get_tree().quit();
