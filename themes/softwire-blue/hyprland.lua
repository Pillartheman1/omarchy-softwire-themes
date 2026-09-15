local active_border_color = "#0094ba"
local inactive_border_color = "rgba(595959aa)"

hl.config({
  general = {
    col = {
      active_border = active_border_color,
      inactive_border = inactive_border_color,
    },
  },

  group = {
    col = {
      border_active = active_border_color,
      border_inactive = inactive_border_color,
    },
  },

  decoration = {
    active_opacity = 1,
    inactive_opacity = 1,
    fullscreen_opacity = 1,
    blur = {
      enabled = true,
      size = 8,
      passes = 2,
      ignore_opacity = true,
      new_optimizations = false,
      xray = false,
      popups = true,
      popups_ignorealpha = 0.2,
      noise = 0.02,
      contrast = 0.9,
      brightness = 1.0,
      vibrancy = 0.2,
    },
  },
})

-- Opacity must be on the window rule or Hyprland skips the window blur pass.
local opacity_rule = "0.65 override 0.65 override 1.0 override"
o.window(".*", { opacity = opacity_rule })

o.window("[bB]rave.*", {
  opacity = "1.0 override 1.0 override 1.0 override",
  opaque = true,
  no_blur = true,
})

o.window("[bB]rave-(x\\.com|twitter\\.com).*", {
  opacity = opacity_rule,
  opaque = false,
  no_blur = false,
})

o.window("(com\\.ktechpit\\.)?[Ww]onder[Ww]all", {
  opacity = "1.0 override 1.0 override 1.0 override",
  opaque = true,
  no_blur = true,
})

local function opaque_media(match)
  o.window(match, {
    opacity = "1.0 override 1.0 override 1.0 override",
    opaque = true,
    no_blur = true,
  })
end

opaque_media(
  "^(imv|mpv|vlc|celluloid|haruna|totem|loupe|eog|feh|sxiv|nsxiv|swayimg|qimgv|viewnior|zoom|[sS]potify|clapper|WebcamOverlay-.*|[Gg][Ii][Mm][Pp]|org\\.gimp\\.[Gg][Ii][Mm][Pp]|org.gnome.(Loupe|eog|Totem|NautilusPreviewer|Showtime)|org.kde.(gwenview|kdenlive)|com.obsproject.Studio|com.github.PintaProject.Pinta|com.github.rafostar.Clapper|io.github.celluloid_player.Celluloid)$"
)
opaque_media({ content = "photo" })
opaque_media({ content = "video" })
opaque_media({ tag = "pip" })

hl.layer_rule({
  match = { namespace = "negative:^omarchy-background$" },
  blur = true,
  blur_popups = true,
  ignore_alpha = 0.2,
})
