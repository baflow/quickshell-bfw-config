# QuickShell Configuration

This directory contains a personal QuickShell configuration optimized for the Sway window manager.

## About QuickShell

QuickShell is a highly customizable desktop shell for Linux that provides an alternative to traditional desktop environments. It offers a flexible and efficient workflow through configurable panels, widgets, and launchers.

## Sway Integration

This configuration is specifically designed to work with **Sway**, the tiling Wayland compositor. It includes:
- Sway-aware workspace management
- Wayland-compatible widgets
- Optimized panel layouts for tiling workflows

## Configuration Structure

This configuration includes:
- Custom launchers
- Shell panels
- Widget configurations
- Theme settings
- Sway-specific integrations

## Installation

To use this configuration:

1. Install QuickShell following the official installation guide
2. Ensure Sway is installed and running
3. Copy the configuration files to your QuickShell config directory
4. Reload or restart QuickShell to apply changes

## Requirements

- QuickShell
- Sway window manager
- Wayland compositor

## Adding Keyboard Shortcuts

To integrate QuickShell with your Sway configuration, you can add keyboard shortcuts to your `~/.config/sway/config` file.

**Example: Adding a QuickShell launcher shortcut**

```bash
# Add this line to your ~/.config/sway/config
bindsym $mod+d exec --no-startup-id $HOME/.config/quickshell/bfw/launcher/toggle.sh
```

**Common shortcut patterns:**
- `$mod+d` - Application launcher (Mod+D)
- `$mod+space` - QuickShell panel toggle (Mod+Space)
- `$mod+Shift+q` - QuickShell settings (Mod+Shift+Q)

After adding shortcuts, reload Sway with:
```bash
swaymsg reload
```

## Customization

This configuration can be modified by editing the QML files and configuration files in this directory. Each component is modular and can be customized independently.

## Support

For QuickShell documentation and support:
- Official documentation: https://quickshell.org/docs
- Community discussions: https://github.com/quickshell/quickshell/discussions

---

*This configuration is tailored for personal use with Sway and may require adjustments for different systems or preferences.*