/// @desc 

playerRef = noone;
hitlist = ds_list_create();

destroy_self = function() {
	show_debug_message("destroying hitbox... ");
	ds_list_destroy(hitlist);
	instance_destroy();
}