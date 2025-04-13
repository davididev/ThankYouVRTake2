class_name ChoiceHolderUI extends Control

static var Choices : Array[String];

static var ChoiceID = -1;
static var Update = false;  #Should be set to true when we're ready to set up

func _process(delta: float) -> void:
	if Update == true:
		Update = false;
		ChoiceID = -1;
		for i in range(0, 4):
			var tnode = get_node(str("Choice", i));
			if i < Choices.size():
				tnode.visible = true;
				tnode.get_child(0).text = Choices[i];
			else:
				tnode.visible = false;
			


func _on_choice_0_pressed() -> void:
	ChoiceID = 0;


func _on_choice_1_pressed() -> void:
	ChoiceID = 1;


func _on_choice_2_pressed() -> void:
	ChoiceID = 2;


func _on_choice_3_pressed() -> void:
	ChoiceID = 3;
