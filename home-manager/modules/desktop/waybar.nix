{
  config,
  lib,
  gVar,
  ...
}: let
  cfg = config.desktop.waybar;
  theme = gVar.palette;
in {
  options.desktop.waybar = {
    enable = lib.mkEnableOption "Enable Waybar";
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      settings = [
        {
          layer = "top";
          position = "top";

          modules-left = ["clock" "hyprland/window"];
          modules-center = ["hyprland/workspaces"];
          modules-right = ["idle_inhibitor" "custom/notification" "battery" "network" "pulseaudio" "tray"];
          "hyprland/workspaces" = {
            format = "";
            format-icons = {
              default = "";
              active = "";
              urgent = "";
            };
            persistent-workspaces = {
              "*" = 5;
            };
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
          };
          "clock" = {
            format = "{:L%I:%M %p}";
            tooltip = false;
          };
          "hyprland/window" = {
            max-length = 50;
            separate-outputs = false;
          };
          "memory" = {
            interval = 5;
            format = " {}%";
            tooltip = true;
          };
          "cpu" = {
            interval = 5;
            format = " {usage:2}%";
            tooltip = true;
          };
          "disk" = {
            format = "  {free}";
            tooltip = true;
          };
          "network" = {
            format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
            format-ethernet = ": {bandwidthDownOctets}";
            format-wifi = "{icon} {signalStrength}%";
            format-disconnected = "󰤮";
            tooltip = false;
            on-click = "kitty -e nmcli";
          };
          "tray" = {
            spacing = 12;
          };
          "pulseaudio" = {
            format = "{icon} {volume}% {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = " {icon} {format_source}";
            format-muted = " {format_source}";
            format-source = " {volume}%";
            format-source-muted = "";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = ["" "" ""];
            };
            on-click = "pavucontrol";
          };
          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              activated = " ";
              deactivated = " ";
            };
            tooltip = "true";
          };
          "custom/notification" = {
            tooltip = false;
            format = "{icon} {}";
            format-icons = {
              notification = "<span foreground='red'><sup></sup></span>";
              none = "";
              dnd-notification = "<span foreground='red'><sup></sup></span>";
              dnd-none = "";
              inhibited-notification = "<span foreground='red'><sup></sup></span>";
              inhibited-none = "";
              dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
              dnd-inhibited-none = "";
            };
            return-type = "json";
            exec-if = "which swaync-client";
            exec = "swaync-client -swb";
            on-click = "task-waybar";
            escape = true;
          };
          "battery" = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = "󰂄 {capacity}%";
            format-plugged = "󱘖 {capacity}%";
            format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
            on-click = "";
            tooltip = false;
          };
        }
      ];
      style = ''
        * {
              font-size: 16px;
              font-family: JetBrainsMono Nerd Font, Font Awesome, sans-serif;
              font-weight: bold;
        }
        window#waybar {
              background-color: #${theme.base00};
              border-bottom: 1px solid #${theme.base00};
              border-radius: 0px;
              color: #${theme.base0F};
        }
        #workspaces {
              padding: 0px;
        }
        #workspaces button {
              margin: 0 3px;
              padding: 5px;
              min-width: 9px;
              border: 0px;
              border-radius: 100%;
              background-color: #${theme.base05};
              background-size: 9px 9px;
              opacity: 0.5;
              transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
        }
        #workspaces button.empty {
              background-color: #${theme.base04};
        }
        #workspaces button.active {
              min-width: 27px;
              transition: all 0.3s cubic-bezier(.55,-0.68,.48,1.682);
              background-color: #${theme.base05};
              opacity: 1.0;
        }
        #workspaces button:hover {
              opacity: 0.8;
        }
        tooltip {
            background: #${theme.base00};
            border: 1px solid #${theme.base04};
            border-radius: 10px;
        }
        tooltip label {
            color: #${theme.base05};
        }
        #window {
              color: #${theme.base04};
              margin: 4px;
              padding: 2px 10px;
        }
        #memory {
              color: #${theme.base03};
              margin: 4px;
              padding: 2px 10px;
        }
        #clock {
              color: #${theme.base05};
              margin: 4px;
              padding: 2px 10px;
        }
        #idle_inhibitor {
              color: #${theme.base0A};
              margin: 4px;
              padding: 2px 10px;
        }
        #cpu {
              color: #${theme.base03};
              margin: 4px;
              padding: 2px 10px;
        }
        #disk {
              color: #${theme.base03};
              margin: 4px;
              padding: 2px 10px;
        }
        #battery {
              color: #${theme.base0B};
              margin: 4px;
              padding: 2px 10px;
        }
        #network {
              color: #${theme.base0C};
              margin: 4px;
              padding: 2px 10px;
        }
        #tray {
              color: #${theme.base05};
              background: #${theme.base01};
              border-radius: 10px;
              margin: 4px;
              padding: 2px 10px;
        }
        #pulseaudio {
              color: #${theme.base0D};
              margin: 4px;
              padding: 2px 10px;
        }
        #custom-notification {
              color: #${theme.base0C};
              background: #${theme.base01};
              border-radius: 10px;
              margin: 4px;
              padding: 2px 10px;
        }
        #idle_inhibitor {
              color: #${theme.base0A};
              border-radius: 10px;
              margin: 4px;
              padding: 2px 10px 2px 13px;
        }
      '';
    };
  };
}
