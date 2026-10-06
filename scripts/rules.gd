extends RefCounted

func block_widths(seed_value: int) -> PackedInt32Array:
	var rng := RandomNumberGenerator.new()
	rng.seed = seed_value
	var widths := PackedInt32Array()
	for _i in 4:
		widths.append(2 + rng.randi_range(0, 2))
	return widths

func scale_accepted(factor: float) -> bool:
	return is_equal_approx(factor, 1.0)

var bar_open := false
var phase := "closed"

func curb_open(phase_name: String) -> bool:
	return phase_name == "open"

func open_bar() -> void:
	bar_open = true
	phase = "open"

func may_cross() -> bool:
	return bar_open and curb_open(phase)
