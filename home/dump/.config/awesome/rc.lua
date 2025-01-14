-- Standard awesome library
local awful = require('awful')
require('awful.autofocus')

-- Autostartup
awful.spawn.with_shell('$HOME/.xprofile')

local gears = require('gears')
-- Widget and layout library
local wibox = require('wibox')
-- Theme handling library
local beautiful = require('beautiful')
-- Notification library
local naughty = require('naughty')
-- Make notifications appear in the bottom right
naughty.config.defaults.position = 'bottom_right'
-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = 'Oops, there were errors during startup!',
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup
do
	local in_error = false
	awesome.connect_signal('debug::error', function(err)
		-- Make sure we don't go into an endless error loop
		if in_error then
			return
		end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = 'Oops, an error happened!',
			text = tostring(err),
		})
		in_error = false
	end)
end
-- }}}
-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. 'grav.lua')

Terminal = 'st'
File_manager = 'joshuto'
File_manager_cmd = Terminal .. ' -e ' .. File_manager
Launcher = 'launcher'
Powermenu = 'powermenu'
Screenshot = 'ss'
Screenshot_window = 'ss-window'
Screenshot_desktop = 'ss-desktop'
Screenshot_ocr = 'ss-ocr'
Screenshot_menu = 'screenshot'
Lightdecrease = 'monitorlight +-5'
Lightincrease = 'monitorlight +5'
Discord = 'flatpak run io.github.spacingbat3.webcord'
Org = 'org'
Grayscale = 'grayscale-toggle'
Browser = 'flatpak run com.brave.Browser'
Pomodoro = 'flatpak run io.gitlab.idevecore.Pomodoro'
Anki = 'flatpak run net.ankiweb.Anki'
Recorder = 'obs'
RecordImmediately = 'obs --startrecording --minimize-to-tray'
Music =
	"flatpak 'run' '--command=brave' 'com.brave.Browser' '--profile-directory=Profile 1' '--app-id=cinhimbnkkaeohfgghhklpknlkffjgod'"

-- Super key
Modkey = 'Mod4'

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
	-- Master and children type shit
	awful.layout.suit.tile,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.magnifier,

	-- More fun stuff
	awful.layout.suit.fair,
	awful.layout.suit.floating,
	-- awful.layout.suit.corner.nw,
	-- awful.layout.suit.spiral,
	-- awful.layout.suit.spiral.dwindle,
	-- awful.layout.suit.fair.horizontal,
	-- awful.layout.suit.max,
	-- awful.layout.suit.max.fullscreen,
	-- awful.layout.suit.tile.left,
	-- awful.layout.suit.tile.top,
	-- awful.layout.suit.corner.ne,
	-- awful.layout.suit.corner.sw,
	-- awful.layout.suit.corner.se,
}
-- }}}
-- {{{ Wibar
-- Create a textclock widget
Mytextclock = wibox.widget.textclock('%b %d, %H:%M ')

local calendar_widget = require('awesome-wm-widgets.calendar-widget.calendar')

local cw = calendar_widget({
	theme = 'outrun',
	placement = 'bottom_right',
	start_sunday = true,
	radius = 8,
	-- with customized next/previous (see table above)
	previous_month_button = 1,
	next_month_button = 3,
})

Mytextclock:connect_signal('button::press', function(_, _, _, button)
	if button == 1 then
		cw.toggle()
	elseif button == 3 then
		awful.spawn(Terminal .. ' -e syncclock')
	end
end)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ Modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ Modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal('request::activate', 'tasklist', { raise = true })
		end
	end),
	awful.button({}, 2, function(c)
		c:kill()
	end),

	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

-- local function set_wallpaper(s)
-- 	-- Wallpaper
-- 	if beautiful.wallpaper then
-- 		local wallpaper = beautiful.wallpaper
-- 		-- If wallpaper is a function, call it with the screen
-- 		if type(wallpaper) == 'function' then
-- 			wallpaper = wallpaper(s)
-- 		end
-- 		gears.wallpaper.maximized(wallpaper, s, true)
-- 	end
-- end
--
-- -- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
-- screen.connect_signal('property::geometry', set_wallpaper)
SCRATCH_ICON = ''
local volume_widget = require('awesome-wm-widgets.pactl-widget.volume')
awful.screen.connect_for_each_screen(function(s)
	-- Wallpaper
	-- set_wallpaper(s)

	-- Each screen has its own tag table.
	awful.tag({ '1', '2', '3', '4', '5', '6', '7', '8', '9' }, s, awful.layout.layouts[1])

	awful.tag.add(SCRATCH_ICON, { s, layout = awful.layout.suit.floating })

	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.mylayoutbox = awful.widget.layoutbox(s)
	s.mylayoutbox:buttons(gears.table.join(
		awful.button({}, 1, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 3, function()
			awful.layout.inc(-1)
		end),
		awful.button({}, 4, function()
			awful.layout.inc(1)
		end),
		awful.button({}, 5, function()
			awful.layout.inc(-1)
		end)
	))
	-- Create a taglist widget
	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
		style = {
			shape = gears.shape.rounded_bar,
		},
		-- layout  = {
		-- 	spacing        = 20,
		-- 	spacing_widget = {
		-- 		color = '#dddddd',
		-- 		shape = gears.shape.rounded_bar,
		-- 	},
		-- 	layout         = wibox.layout.fixed.horizontal
		-- },
	})

	-- Create a tasklist widget
	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
		style = {
			shape = gears.shape.rounded_bar,
		},
		layout = {
			spacing = 3,
			-- spacing_widget = {
			-- 	{
			-- 		forced_width = 1,
			-- 		-- shape        = gears.shape.circle,
			-- 		widget       = wibox.widget.separator,
			-- 		color        = beautiful.bg_normal
			-- 	},
			-- 	valign = 'center',
			-- 	halign = 'center',
			-- 	widget = wibox.container.place,
			-- },
			layout = wibox.layout.flex.horizontal,
		},
	})

	s.seperator = wibox.widget({
		widget = wibox.widget.separator,
		orientation = 'vertical',
		forced_width = 10,
		color = beautiful.border_focus,
		visible = true,
	})

	s.empty_seperator = function(width)
		return wibox.widget({
			widget = wibox.widget.separator,
			orientation = 'vertical',
			forced_width = width,
			color = beautiful.bg_normal,
			visible = true,
		})
	end

	s.net_wired = require('net_widgets').indicator({
		-- interface = 'eth0',
		popup_position = 'bottom_right',
		onclick = Terminal .. ' -e wpa_cli',
	})

	-- net_wireless = net_widgets.wired({ interface = 'eth0' })
	-- Create the wibox
	-- local function custom_shape(cr, width, height)
	-- 	gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, 14)
	-- end

	s.mywibox = awful.wibar({
		position = 'bottom',
		screen = s,
		-- shape = custom_shape,
	})
	-- Add widgets to the wibox
	s.mywibox:setup({
		layout = wibox.layout.align.horizontal,
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			-- mylauncher,
			s.mytaglist,
			-- s.mypromptbox,
			s.empty_seperator(10),
		},
		s.mytasklist, -- Middle widget
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,

			-- mykeyboardlayout,
			wibox.widget.systray(),
			s.empty_seperator(10),
			volume_widget({
				widget_type = 'arc',
				mixer_cmd = 'st -e pulsemixer',
				tooltip = true,
			}),
			s.net_wired,
			Mytextclock,
			s.mylayoutbox,
		},
	})
end)
-- }}}
-- {{{ Key bindings
-- Global keys {{{
-- function dump(o)
-- 	if type(o) == 'table' then
-- 		local s = '{ '
-- 		for k, v in pairs(o) do
-- 			if type(k) ~= 'number' then
-- 				k = '"' .. k .. '"'
-- 			end
-- 			s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
-- 		end
-- 		return s .. '} '
-- 	else
-- 		return tostring(o)
-- 	end
-- end
--
globalkeys = gears.table.join(
	-- Programs{{{
	awful.key({ Modkey }, 'r', function()
		awful.spawn(Recorder)
	end, { description = 'open Recorder', group = 'launcher' }),
	awful.key({ Modkey, 'Shift' }, 'r', function()
		awful.spawn(RecordImmediately)
	end, { description = 'start recording immediately', group = 'launcher' }),
	awful.key({ Modkey }, 'p', function()
		awful.spawn(Pomodoro)
	end, { description = 'open Pomodoro', group = 'launcher' }),
	awful.key({ Modkey, 'Shift' }, 'p', function()
		awful.spawn(Music)
	end, { description = 'open Poor taste in music', group = 'launcher' }),
	awful.key({ Modkey, 'Shift' }, 'a', function()
		awful.spawn(Anki)
	end, { description = 'open Anki', group = 'launcher' }),
	awful.key({ Modkey }, 'f', function()
		awful.spawn(Launcher)
	end, { description = 'find application', group = 'launcher' }),
	awful.key({ Modkey }, 'b', function()
		awful.spawn(Browser)
	end, { description = 'open a browser', group = 'launcher' }),
	awful.key({ Modkey }, 'a', function()
		awful.spawn(Org)
	end, { description = 'open agenda', group = 'launcher' }),
	-- Screenshots{{{
	awful.key({ Modkey }, 's', function()
		awful.spawn(Screenshot)
	end, { description = 'take a selection screenshot', group = 'launcher' }),
	awful.key({ Modkey, 'Shift' }, 's', function()
		awful.spawn(Screenshot_desktop)
	end, { description = 'take a window screenshot', group = 'launcher' }),
	awful.key({ Modkey, 'Control' }, 's', function()
		awful.spawn(Screenshot_window)
	end, { description = 'take a desktop screenshot', group = 'launcher' }),
	awful.key({ Modkey, 'Mod1' }, 's', function()
		awful.spawn(Screenshot_ocr)
	end, { description = 'take a tesseract selection', group = 'launcher' }),
	awful.key({ Modkey, 'Shift', 'Control' }, 's', function()
		awful.spawn(Screenshot_menu)
	end, { description = 'open screenshot menu', group = 'launcher' }), -- }}}
	awful.key({ Modkey }, 'd', function()
		awful.spawn(Discord)
	end, { description = 'open discord', group = 'launcher' }),
	awful.key({ Modkey }, 't', function()
		awful.spawn(Terminal)
	end, { description = 'open a terminal', group = 'launcher' }),
	awful.key({ Modkey, 'Shift' }, 't', function()
		awful.spawn(File_manager_cmd)
	end, { description = 'open a file manager', group = 'launcher' }),
	-- }}}
	-- Scratchpad{{{
	awful.key({ Modkey }, '`', function()
		local tag = awful.screen.focused().tags[10]
		local clients = tag:clients()
		if clients[1] then
			awful.tag.viewtoggle(tag)
			clients[#clients]:emit_signal('request::activate', { raise = true })
			-- for _, c in pairs(clients) do
			-- 	c:emit_signal('request::activate', { raise = true })
			-- end
		elseif tag.selected == true then
			awful.tag.viewtoggle(tag)
		end
	end, { description = 'toggle scratchpad', group = 'client' }), -- }}}
	-- Focus client in given direction{{{
	awful.key({ Modkey }, 'h', function()
		awful.client.focus.bydirection('left')
	end, { description = 'focus client towards left', group = 'client' }),
	awful.key({ Modkey }, 'j', function()
		awful.client.focus.bydirection('down')
	end, { description = 'focus client towards down', group = 'client' }),
	awful.key({ Modkey }, 'k', function()
		awful.client.focus.bydirection('up')
	end, { description = 'focus client towards up', group = 'client' }),
	awful.key({ Modkey }, 'l', function()
		awful.client.focus.bydirection('right')
	end, { description = 'focus client towards right', group = 'client' }),
	-- Backup
	awful.key({ Modkey }, '.', function()
		awful.client.focus.byidx(1)
	end, { description = 'focus next by index', group = 'client' }),
	awful.key({ Modkey }, ',', function()
		awful.client.focus.byidx(-1)
	end, { description = 'focus previous by index', group = 'client' }),
	-- }}}
	-- Monitors{{{
	awful.key({ Modkey }, ']', function()
		awful.screen.focus_relative(1)
	end, { description = 'focus the next screen', group = 'screen' }),
	awful.key({ Modkey }, '[', function()
		awful.screen.focus_relative(-1)
	end, { description = 'focus the previous screen', group = 'screen' }),
	-- }}}
	-- Layout manipulation{{{
	-- Uninimize
	awful.key({ Modkey, 'Shift' }, 'n', function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:emit_signal('request::activate', 'key.unminimize', { raise = true })
		end
	end, { description = 'restore minimized', group = 'client' }),
	awful.key({ Modkey }, 'u', awful.client.urgent.jumpto, { description = 'jump to urgent client', group = 'client' }),
	-- awful.key({ modkey, }, 'l', function() awful.tag.incmwfact(0.05) end,
	--     { description = 'increase master width factor', group = 'layout' }),
	-- awful.key({ modkey, }, 'h', function() awful.tag.incmwfact(-0.05) end,
	--     { description = 'decrease master width factor', group = 'layout' }),
	awful.key({ Modkey }, 'i', function()
		awful.tag.incnmaster(1, nil, true)
	end, { description = 'increase the number of master clients', group = 'layout' }),
	awful.key({ Modkey }, 'o', function()
		awful.tag.incnmaster(-1, nil, true)
	end, { description = 'decrease the number of master clients', group = 'layout' }),
	awful.key({ Modkey, 'Shift' }, 'i', function()
		awful.tag.incncol(1, nil, true)
	end, { description = 'increase the number of columns', group = 'layout' }),
	awful.key({ Modkey, 'Shift' }, 'o', function()
		awful.tag.incncol(-1, nil, true)
	end, { description = 'decrease the number of columns', group = 'layout' }),
	awful.key({ Modkey }, '\\', function()
		awful.layout.inc(1)
	end, { description = 'select next preset layout', group = 'layout' }),
	awful.key({ Modkey, 'Shift' }, '\\', function()
		awful.layout.inc(-1)
	end, { description = 'select previous preset layout', group = 'layout' }),
	-- }}}
	-- System{{{
	awful.key({ Modkey }, 'Left', awful.tag.viewprev, { description = 'view previous', group = 'tag' }),
	awful.key({ Modkey }, 'Right', awful.tag.viewnext, { description = 'view next', group = 'tag' }),
	awful.key({ Modkey }, 'g', function()
		awful.spawn(Grayscale)
	end, { description = 'toggle grayscale', group = 'launcher' }),
	awful.key({ Modkey, 'Shift' }, 'b', function()
		myscreen = awful.screen.focused()
		myscreen.mywibox.visible = not myscreen.mywibox.visible
	end, { description = 'toggle statusbar', group = 'awesome' }),
	awful.key({ Modkey, 'Control' }, 'r', awesome.restart, { description = 'reload awesome', group = 'awesome' }),
	awful.key({ Modkey, 'Shift' }, 'e', function()
		awful.spawn(Powermenu)
	end, { description = 'quit awesome', group = 'awesome' }),
	-- Brightness
	awful.key({}, 'XF86MonBrightnessUp', function()
		awful.spawn(Lightdecrease)
	end, { description = 'increase monitor brightness', group = 'screen' }),
	awful.key({}, 'XF86MonBrightnessDown', function()
		awful.spawn(Lightincrease)
	end, { description = 'decrease monitor brightness', group = 'screen' }),

	awful.key({}, 'XF86AudioRaiseVolume', function()
		volume_widget:inc(5)
	end),
	awful.key({}, 'XF86AudioLowerVolume', function()
		volume_widget:dec(5)
	end),
	awful.key({}, 'XF86AudioMute', function()
		volume_widget:toggle()
	end) -- }}}
)
-- }}}
-- Client keys {{{
local floating_resize_amount = 72
local tiling_resize_factor = 0.05

local function resize_client(c, direction)
	if awful.layout.get(mouse.screen) == awful.layout.suit.floating or (c and c.floating) then
		if direction == 'down' then
			c:relative_move(0, 0, 0, floating_resize_amount)
		end
		if direction == 'up' then
			c:relative_move(0, 0, 0, -floating_resize_amount)
		end
		if direction == 'left' then
			c:relative_move(0, 0, -floating_resize_amount, 0)
		end
		if direction == 'right' then
			c:relative_move(0, 0, floating_resize_amount, 0)
		end
	else
		if direction == 'up' then
			awful.client.incwfact(tiling_resize_factor)
		end
		if direction == 'down' then
			awful.client.incwfact(-tiling_resize_factor)
		end
		if direction == 'left' then
			awful.tag.incmwfact(-tiling_resize_factor)
		end
		if direction == 'right' then
			awful.tag.incmwfact(tiling_resize_factor)
		end
	end
end

local function move_client(c, direction)
	if awful.layout.get(mouse.screen) == awful.layout.suit.floating or (c and c.floating) then
		if direction == 'up' then
			c:relative_move(0, -floating_resize_amount, 0, 0)
		end
		if direction == 'down' then
			c:relative_move(0, floating_resize_amount, 0, 0)
		end
		if direction == 'left' then
			c:relative_move(-floating_resize_amount, 0, 0, 0)
		end
		if direction == 'right' then
			c:relative_move(floating_resize_amount, 0, 0, 0)
		end
	else
		awful.client.swap.bydirection(direction, c.focus)
	end
end

clientkeys = gears.table.join(
	awful.key({ Modkey, 'Shift' }, '`', function(c)
		local tag = client.focus.screen.tags[10]
		local screen = awful.screen.focused()
		local scratch = screen.tags[10]
		if client.focus.first_tag.index == 10 then
			c:move_to_tag(awful.screen.focused().selected_tag)
			c.floating = false

			if scratch.selected then
				awful.tag.viewtoggle(scratch)
			end
		else
			c:move_to_tag(tag)
			if not scratch.selected then
				awful.tag.viewtoggle(scratch)
			end
			c.floating = true

			local place = awful.placement.maximize + awful.placement.top
			place(c, { honor_workarea = true, margins = 10 })
			c.border_color = beautiful.border_scratch
		end
	end, { description = 'toggle client to scratchpad', group = 'client' }),

	-- Move client by direction
	awful.key({ Modkey, 'Shift' }, 'h', function(c)
		move_client(c, 'left')
	end, { description = 'move client towards left', group = 'client' }),
	awful.key({ Modkey, 'Shift' }, 'j', function(c)
		move_client(c, 'down')
	end, { description = 'move client towards down', group = 'client' }),
	awful.key({ Modkey, 'Shift' }, 'k', function(c)
		move_client(c, 'up')
	end, { description = 'move client towards up', group = 'client' }),
	awful.key({ Modkey, 'Shift' }, 'l', function(c)
		move_client(c, 'right')
	end, { description = 'move client towards right', group = 'client' }),

	-- Resize client in given direction
	awful.key({ Modkey, 'Ctrl' }, 'h', function(c)
		resize_client(c, 'left')
	end, { description = 'increase client width factor', group = 'client' }),
	awful.key({ Modkey, 'Ctrl' }, 'j', function(c)
		resize_client(c, 'down')
	end, { description = 'decrease client width factor', group = 'client' }),
	awful.key({ Modkey, 'Ctrl' }, 'k', function(c)
		resize_client(c, 'up')
	end, { description = 'increase client width factor', group = 'client' }),
	awful.key({ Modkey, 'Ctrl' }, 'l', function(c)
		resize_client(c, 'right')
	end, { description = 'decrease client width factor', group = 'client' }),

	-- Backup
	awful.key({ Modkey, 'Shift' }, '.', function()
		awful.client.swap.byidx(1)
	end, { description = 'swap with next client by index', group = 'client' }),
	awful.key({ Modkey, 'Shift' }, ',', function()
		awful.client.swap.byidx(-1)
	end, { description = 'swap with previous client by index', group = 'client' }),
	awful.key({ Modkey, 'Shift' }, 'f', function(c)
		if c.floating then
			c.floating = true
			c.fullscreen = not c.fullscreen
		elseif not c.floating then
			c.floating = false
			c.fullscreen = not c.fullscreen
		else
			c.fullscreen = not c.fullscreen
		end
		c:raise()
	end, { description = 'toggle fullscreen', group = 'client' }),
	awful.key({ Modkey }, 'c', function(c)
		c:kill()
	end, { description = 'close', group = 'client' }),
	awful.key({ Modkey }, 'space', function(c)
		if not c.fullscreen then
			awful.client.floating.toggle()
		end
	end, { description = 'toggle floating', group = 'client' }),
	awful.key({ Modkey }, 'Return', function(c)
		c:swap(awful.client.getmaster())
	end, { description = 'move to master', group = 'client' }),
	awful.key({ Modkey, 'Shift' }, ']', function(c)
		c:move_to_screen(1)
		awful.screen.focus_relative(1)
	end, { description = 'move to screen', group = 'client' }),
	awful.key({ Modkey, 'Shift' }, '[', function(c)
		c:move_to_screen(-1)
		awful.screen.focus_relative(-1)
	end, { description = 'move to screen', group = 'client' }),
	-- awful.key({ modkey, }, 't', function(c) c.ontop = not c.ontop end,
	--     { description = 'toggle keep on top', group = 'client' }),
	awful.key({ Modkey }, 'n', function(c)
		-- The client currently has the input focus, so it cannot be
		-- minimized, since minimized clients can't have the focus.
		c.minimized = true
	end, { description = 'minimize', group = 'client' })
	-- awful.key({ modkey, }, 'm',
	--     function(c)
	--         c.maximized = not c.maximized
	--         c:raise()
	--     end,
	--     { description = '(un)maximize', group = 'client' }),
	-- awful.key({ modkey, 'Control' }, 'm',
	--     function(c)
	--         c.maximized_vertical = not c.maximized_vertical
	--         c:raise()
	--     end,
	--     { description = '(un)maximize vertically', group = 'client' }),
	-- awful.key({ modkey, 'Shift' }, 'm',
	--     function(c)
	--         c.maximized_horizontal = not c.maximized_horizontal
	--         c:raise()
	--     end,
	--     { description = '(un)maximize horizontally', group = 'client' })
)
-- }}}
-- Client mouse buttons {{{
clientbuttons = gears.table.join(
	awful.button({}, 1, function(c)
		c:emit_signal('request::activate', 'mouse_click', { raise = true })
	end),
	awful.button({ Modkey }, 1, function(c)
		c:emit_signal('request::activate', 'mouse_click', { raise = true })
		awful.mouse.client.move(c)
	end),
	awful.button({ Modkey }, 3, function(c)
		c:emit_signal('request::activate', 'mouse_click', { raise = true })
		awful.mouse.client.resize(c)
	end)
)

-- }}}
-- Tags {{{
-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
	globalkeys = gears.table.join(
		globalkeys,
		-- View tag only.
		awful.key({ Modkey }, '#' .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]

			local scratch = screen.tags[10]
			if tag then
				-- Allow scratchpad to remain visible while changing tags
				if scratch and scratch.selected then
					tag:view_only()
					awful.tag.viewtoggle(scratch)
				else
					tag:view_only()
				end
			end
		end, { description = 'view tag #' .. i, group = 'tag' }),
		-- Move client to tag.
		awful.key({ Modkey, 'Shift' }, '#' .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = 'move focused client to tag #' .. i, group = 'tag' }),
		-- Toggle tag display.
		awful.key({ Modkey, 'Control' }, '#' .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end, { description = 'toggle tag #' .. i, group = 'tag' }),
		-- Toggle tag on focused client.
		awful.key({ Modkey, 'Control', 'Shift' }, '#' .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end, { description = 'toggle focused client on tag #' .. i, group = 'tag' })
	)
end
-- }}}
-- Set keys
root.keys(globalkeys)
-- }}}
-- {{{ Rules
-- Rules to apply to new clients (through the 'manage' signal).
awful.rules.rules = {
	{ -- All clients will match this rule. {{{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = clientkeys,
			buttons = clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	}, -- }}}
	{ -- Put Discord in 5 {{{
		rule_any = { class = { 'WebCord', 'webcord', 'discord' } },
		properties = { tag = '5' },
	}, -- }}}
	{ -- Put Org Emacs in Scratchpad{{{
		rule = { name = 'scratchy' },
		properties = { tag = SCRATCH_ICON },
	}, -- }}}
	{ -- Floating clients {{{
		rule = { floating = true },
		properties = { placement = awful.placement.centered },
	}, -- }}}
	{ -- Scratchpad applications{{{
		rule = { tag = SCRATCH_ICON },
		properties = {
			floating = true,
			placement = awful.placement.maximize + awful.placement.top,
		},
	}, -- }}}
}
-- }}}
-- {{{ Signals
-- Signal function to execute when a new client appears.{{{
client.connect_signal('manage', function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	-- if not awesome.startup then awful.client.setslave(c) end
	if not awesome.startup then
		awful.client.setslave(c)
	elseif awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
	-- To stop clients from getting included in the scratch tag when the scratch tag is open and a client is opened
	c:tags({ c.first_tag })
	if c.first_tag == awful.screen.focused().tags[10] then
		local place = awful.placement.maximize + awful.placement.top
		place(c, { honor_workarea = true, margins = 10 })
		-- naughty.notify({
		-- 	title = tostring(c),
		-- 	text = tostring(#c.first_tag:clients()),
		-- 	-- text = tostring(awful.screen.focused().tags[10].master_count),
		-- })
	end
end) -- }}}
-- Enable sloppy focus, so that focus follows mouse.{{{
client.connect_signal('mouse::enter', function(c)
	c:emit_signal('request::activate', 'mouse_enter', { raise = false })
end) -- }}}
-- All floating are on top{{{
client.connect_signal('property::floating', function(c)
	if c.floating then
		c.ontop = true
	else
		c.ontop = false
	end
end) -- }}}
-- Focus color{{{
client.connect_signal('focus', function(c)
	if c.first_tag.index == 10 then
		c.border_color = beautiful.border_scratch
	else
		c.border_color = beautiful.border_focus
	end
end) -- }}}
-- Unfocus border colors{{{
client.connect_signal('unfocus', function(c)
	c.border_color = beautiful.border_normal
end) -- }}}
-- Disable Mixmization{{{
client.connect_signal('property::maximized', function(c)
	c.maximized = false
end) -- }}}
-- }}}
-- vim:foldmethod=marker:
