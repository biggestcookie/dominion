class_name Result
extends Resource

var start_msec := 0
var finish_msec := 0
var elapsed := 0
var frame_presses: Array[float] = [] # Each element is the second that each press occurred

func _init(p_start_msec := 0) -> void:
	start_msec = p_start_msec


func finish() -> void:
	finish_msec = Time.get_ticks_msec()
	total_msec = finish_msec - start_msec


func get_elapsed_time() -> String:
	var total_seconds := (current_msec - start_msec) / 1000.0
	var minutes := int(total_seconds / 60.0)
	var seconds := int(total_seconds) % 60
	var milliseconds := int(total_seconds * 1000) % 1000
	return "%02d:%02d.%03d" % [minutes, seconds, milliseconds]
