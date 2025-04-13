class_name HannahMusicController extends Node3D

signal Song1;
signal Song2;
signal Song3;

@export var TargetLeftPrefab : PackedScene;
@export var TargetRightPrefab : PackedScene;
@export var TargetMinePrefab : PackedScene;
@export var LeftGun : NodePath;
@export var RightGun : NodePath;

var isPlaying = false;

@onready var song1_res = preload("res://Mine/Models/Hannah/song1.res");
@onready var song2_res = preload("res://Mine/Models/Hannah/song2.res");
@onready var song3_res = preload("res://Mine/Models/Hannah/song3.res");
var CurrentSong : BeatList;

var songNode : AudioStreamPlayer3D;

func _ready() -> void:
	get_node(LeftGun).visible = false;
	get_node(RightGun).visible = false;
	isPlaying = false;
	#Node3DPool.InitPoolItem(get_tree(), "Target_Left", TargetLeftPrefab, 10);
	#Node3DPool.InitPoolItem(get_tree(), "Target_Right", TargetRightPrefab, 10);
	#Node3DPool.InitPoolItem(get_tree(), "Target_Mine", TargetRightPrefab, 10);
	songNode = get_node("AudioStreamPlayer3D");

func StartSong(id : int):
	var songPath = "";
	if id == 1:
		CurrentSong = song1_res;
		#PlayMusic.PlaySong("Engage the Maya.mp3");
		songPath = "res://Audio/Music/Engage the Maya.mp3";
	if id == 2:
		CurrentSong = song2_res;
		#PlayMusic.PlaySong("One More Time.mp3");
		songPath = "res://Audio/Music/One More Time.mp3";
	if id == 3:
		CurrentSong = song3_res;
		#PlayMusic.PlaySong("The Hungry Cat.mp3");
		songPath = "res://Audio/Music/The Hungry Cat.mp3";

	songNode.stream = load(songPath);
	songNode.play();
	get_node(LeftGun).visible = true;
	get_node(RightGun).visible = true;
	isPlaying = true;


func _on_song_1() -> void:
	StartSong(1);


func _on_song_2() -> void:
	StartSong(2);


func _on_song_3() -> void:
	StartSong(3);
