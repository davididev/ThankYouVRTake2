class_name BeatList extends Resource

@export var Beats : Array[BeatEntry];

func sort_list(a : BeatEntry, b : BeatEntry):
	if a.BTime < b.BTime:
		return true;
	return false;

func CreateBeat(be : BeatEntry):
	var duplicateID = -1;
	for i in range(0, Beats.size()):
		if is_equal_approx(Beats[i].BTime, be.BTime):
			duplicateID = i;
	if duplicateID == -1:  #Is new
		Beats.append(be);
		ResortList();
	else:  #Edit exisitng
		Beats[duplicateID] = be.duplicate();

func ResortList():
	Beats.sort_custom(sort_list);

#Returns a beat at that time or creates a new one
func GetBeatAtTime(current_time : float):
	for i in range(0, Beats.size()):
		if is_equal_approx(Beats[i].BTime, current_time):
			return Beats[i];
	
	var newEntry = BeatEntry.new();
	newEntry.EmptyEntry();
	newEntry.BTime = current_time;
	return newEntry;
	

func GetBeatIDAtTime(current_time : float):
	var return_id = -1;
	for i in range(0, Beats.size()):
		if is_equal_approx(Beats[i].BTime, current_time):
			return_id = i;
	
	return return_id;

func GetNextKeyframeID(current_time : float):
	var previous_entry_found = true;
	var return_id = -1;
	var first_one = true;
	for i in range(0, Beats.size()):
		if Beats[i].BTime > current_time and first_one == true:  #Only go one over
			return_id = i;
			first_one = false;
	if return_id > -1:
		return_id = clamp(return_id, 0, Beats.size() - 1);
	return return_id;

func GetPrevKeyframeID(current_time : float):
	var previous_entry_found = true;
	var return_id = -1;
	for i in range(0, Beats.size()):
		if Beats[i].BTime < current_time:
			return_id = i;
	if return_id > -1:
		return_id = clamp(return_id, 0, Beats.size() - 1);
	return return_id;
