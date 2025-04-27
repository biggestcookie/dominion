class_name Score
extends Resource

var _start_msec: int
var _finish_msec: int
var unix_time: float
var total_msec: int:
	get():
		return _finish_msec - _start_msec

var press_ticks: Array[int] = [] # Each element is the tick each press occurred
var press_count: int:
	get():
		return len(press_ticks)


func _init() -> void:
	_start_msec = Time.get_ticks_msec()


func finish() -> void:
	_finish_msec = Time.get_ticks_msec()
	unix_time = Time.get_unix_time_from_system()


func press() -> void:
	press_ticks.append(Time.get_ticks_msec())


func get_elapsed_time() -> String:
	# Make this store and return msec instead of storing frame times?
	var total_seconds := (Time.get_ticks_msec() - _start_msec) / 1000.0
	var minutes := int(total_seconds / 60.0)
	var seconds := int(total_seconds) % 60
	var milliseconds := int(total_seconds * 1000) % 1000
	return "%02d:%02d.%03d" % [minutes, seconds, milliseconds]
