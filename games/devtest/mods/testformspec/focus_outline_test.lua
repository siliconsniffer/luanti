-- Test formspec for focus outline styling feature
-- This demonstrates the outline_color and outline_width style properties
-- Use /focus_test to open the test formspec
-- Use Tab key to navigate and see the focus outlines

local function get_formspec()
	return
		"formspec_version[4]" ..
		"size[12,12]" ..
		"label[0.5,0.3;Focus Outline Styling Test]" ..
		"label[0.5,0.7;Use Tab to navigate, observe outline colors and widths]" ..

		-- Default style section
		"label[0.5,1.3;Default Outline (White, 2px)]" ..
		"button[0.5,1.7;3,0.5;btn_default;Default Button]" ..

		-- Custom color section
		"label[0.5,2.5;Custom Colors]" ..
		"button[0.5,2.9;2.3,0.5;btn_red;Red Outline]" ..
		"button[3,2.9;2.3,0.5;btn_green;Green Outline]" ..
		"button[5.5,2.9;2.3,0.5;btn_blue;Blue Outline]" ..
		"button[8,2.9;2.3,0.5;btn_yellow;Yellow Outline]" ..

		-- Custom width section
		"label[0.5,3.8;Custom Widths]" ..
		"button[0.5,4.2;2.2,0.5;btn_thin;1px Width]" ..
		"button[2.9,4.2;2.2,0.5;btn_normal;2px Width]" ..
		"button[5.3,4.2;2.2,0.5;btn_thick;4px Width]" ..
		"button[7.7,4.2;2.2,0.5;btn_very_thick;6px Width]" ..

		-- Combined styling section
		"label[0.5,5.1;Combined Styling]" ..
		"button[0.5,5.5;3,0.5;btn_orange_thick;Orange, 3px]" ..
		"button[3.7,5.5;3,0.5;btn_cyan_thin;Cyan, 1px]" ..
		"button[7.0,5.5;3,0.5;btn_magenta_wide;Magenta, 5px]" ..

		-- Outline offset section
		"label[0.5,6.4;Outline Offset (gap between element and outline)]" ..
		"button[0.5,6.8;2.2,0.5;btn_offset_neg;Offset -2px]" ..
		"button[2.9,6.8;2.2,0.5;btn_offset_zero;Offset 0px]" ..
		"button[5.3,6.8;2.2,0.5;btn_offset_pos;Offset +2px]" ..
		"button[7.7,6.8;2.2,0.5;btn_offset_large;Offset +5px]" ..

		-- Form fields section
		"label[0.5,7.7;Form Fields]" ..
		"field[0.5,8.2;5,0.5;text_field;Text Input:;]" ..
		"field[5.7,8.2;5,0.5;email_field;Email:;]" ..

		-- Dropdown and checkbox
		"label[0.5,9.1;Other Elements]" ..
		"dropdown[0.5,9.5;3,0.5;dropdown_test;Option 1,Option 2,Option 3;1]" ..
		"checkbox[3.8,9.5;checkbox_test;Checkbox;false]" ..

		-- Accessibility demo
		"label[0.5,10.5;Accessibility Demo (High Contrast)]" ..
		"button[0.5,10.9;11,0.5;btn_accessible;Bright Yellow, 4px - Easy to See!]" ..

		-- Style definitions
		"style[btn_red:focus-visible;outline_color=#FF0000;outline_width=2]" ..
		"style[btn_green:focus-visible;outline_color=#00FF00;outline_width=2]" ..
		"style[btn_blue:focus-visible;outline_color=#0000FF;outline_width=2]" ..
		"style[btn_yellow:focus-visible;outline_color=#FFFF00;outline_width=2]" ..

		"style[btn_thin:focus-visible;outline_color=#FF6B00;outline_width=1]" ..
		"style[btn_normal:focus-visible;outline_color=#FF6B00;outline_width=2]" ..
		"style[btn_thick:focus-visible;outline_color=#FF6B00;outline_width=4]" ..
		"style[btn_very_thick:focus-visible;outline_color=#FF6B00;outline_width=6]" ..

		"style[btn_orange_thick:focus-visible;outline_color=#FF8800;outline_width=3]" ..
		"style[btn_cyan_thin:focus-visible;outline_color=#00FFFF;outline_width=1]" ..
		"style[btn_magenta_wide:focus-visible;outline_color=#FF00FF;outline_width=5]" ..

		"style[btn_offset_neg:focus-visible;outline_color=#FF00FF;outline_width=2;outline_offset=-2]" ..
		"style[btn_offset_zero:focus-visible;outline_color=#00FF00;outline_width=2;outline_offset=0]" ..
		"style[btn_offset_pos:focus-visible;outline_color=#0099FF;outline_width=2;outline_offset=2]" ..
		"style[btn_offset_large:focus-visible;outline_color=#FF6600;outline_width=2;outline_offset=5]" ..

		"style[text_field:focus-visible;outline_color=#0066FF;outline_width=2]" ..
		"style[email_field:focus-visible;outline_color=#0066FF;outline_width=2]" ..
		"style[dropdown_test:focus-visible;outline_color=#FF0099;outline_width=2]" ..
		"style[checkbox_test:focus-visible;outline_color=#FF0099;outline_width=2]" ..

		"style[btn_accessible:focus-visible;outline_color=#FFFF00;outline_width=4]"
end

local function show_formspec(player_name)
	minetest.show_formspec(player_name, "testformspec:focus_outline_test", get_formspec())
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "testformspec:focus_outline_test" then
		return false
	end

	if fields.quit then
		return true
	end

	-- Any button press - just keep the formspec open
	show_formspec(player:get_player_name())
	return true
end)

-- Chat command to open the test
minetest.register_chatcommand("focus_test", {
	description = "Show focus outline styling test formspec",
	func = function(player_name, param)
		show_formspec(player_name)
		return true, "Opened focus outline test. Use Tab to navigate and see the outlines!"
	end
})
