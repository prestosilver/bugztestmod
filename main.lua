hooks = require "hooks"

SPEED = 20.0

DVD_SPECIAL = Special.new(tr"players.special_dvd")

-- settings
settings = Settings.new_section(tr"settings.dvd_head")
settings:add_checkbox(tr"settings.dvd_kill", tr"settings.dvd_kill_info", "false", "Kill")
settings:register()

-- players
dvd = PlayerData.new(tr"players.dvd", tr"players.dvd_info")
dvd:set_color(Color.new(0, 0, 255, 255))
dvd:set_special(DVD_SPECIAL)
dvd_id = dvd:register()

-- shops
shop.add_item(builtin_shop.wardrobe, item_kind.player, dvd_id, item_cost.diamonds, 50)

-- dvd related assets
texture = TexAsset.new(file"mod://dvd.png")
bounce_sound = SfxAsset.new(file"mod://bounce.wav")
boom_sound = SfxAsset.new(file"mod://boom.wav")

-- locales
Locale.add_data("en", file"mod://locales/en.cfg")
Locale.add_data("aa", file"mod://locales/aa.cfg")

dvds = {}