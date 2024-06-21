/// @desc 

if (place_meeting(x, y, oZephyrHitbox)) {
	with (instance_place(x, y, oZephyrHitbox)) {
		with (playerRef) {
			// state = PLAYERSTATE.CLANK;
			show_debug_message("clanked!");
		}
	}
	destroy_self();
} else if (place_meeting(x, y, oZephyr)) {
	with (instance_place(x, y, oZephyr)) {
		//show_debug_message(string(ds_list_find_value()));
		if (id != other.playerRef && ds_list_find_index(other.hitlist, id) == -1) {
			show_debug_message("slashed!");
			ds_list_add(other.hitlist, id);
		}
	}
}

if (animation_end()) destroy_self();
