/// @desc get inputs
left = (
	port == 0 && keyboard_check(ord("A")) ||
	port == 1 && keyboard_check(vk_left)
);
right = (
	port == 0 && keyboard_check(ord("D")) ||
	port == 1 && keyboard_check(vk_right)
);
up = (
	port == 0 && keyboard_check(ord("W")) ||
	port == 1 && keyboard_check(vk_up)
);
down = (
	port == 0 && keyboard_check(ord("S")) ||
	port == 1 && keyboard_check(vk_down)
);
attack = (
	port == 0 && keyboard_check_pressed(vk_space) ||
	port == 1 && keyboard_check_pressed(vk_shift)
);

