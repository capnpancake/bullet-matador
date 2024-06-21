/// @desc 
if (keyboard_check_pressed(ord("Z"))) {
	window_scale++;
	if (window_scale > max_scale) window_scale = 1;
	window_set_size(width*window_scale, height*window_scale);
	alarm[0] = 1;
}