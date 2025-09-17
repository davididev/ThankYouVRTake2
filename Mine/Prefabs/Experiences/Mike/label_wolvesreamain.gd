extends Label3D

var last_ct = -1;

func _process(delta: float) -> void:
	if last_ct != WolfEnem.Count:
		last_ct = WolfEnem.Count;
		text = str(last_ct, " remains");
