# Aleksana's bash theme

![image](https://user-images.githubusercontent.com/42209822/225917739-0ef3d18c-1d21-4ed0-b6da-4d92b92dd134.png)

A simple bash theme tailored for my daily use. This theme includes:

- [Nord palette](https://www.nordtheme.com/) (requires truecolor support)
- [gitstatus](https://github.com/romkatv/gitstatus) prompt
- Nix shell detection
- Path shrinking like powerlevel10k
- Various icons

## Make icons display correctly

Install a font with these glyphs supported (paste theme into your terminal to test if works!):

```
 -> NixOS
 -> Clock
 -> Home
❯ -> Right arrow
 -> Git
↑ -> Up arrow
↓ -> Down arrow
✓ -> Tick
✎ -> Pencil
 -> Warning
 -> Folder
```

You probably want to install [nerd fonts](https://www.nerdfonts.com/). After that, make sure it's in fontconfig list (`fc-list`) or set as the default terminal font.

## Use gitstatus

Gitstatus is optional. If you are using a FHS compliant distro, just install it. Otherwise, set
```
GITSTATUS_PLUGIN_PATH=/path/to/your/gitstatus.plugin.sh
```
 If you are using Homemanager, you can set something like
 ```nix
 programs.bash.bashrcExtra = 
 let
   aleksanaPS1 = pkgs.fetchFromGitHub {
     owner = "Aleksanaa";
     repo = "bash-theme";
     rev = "2d0931cd8dc7f61d769097e8c4674ce8b757ef2a";
     hash = "sha256-5fjMtcn/1DYQT3YFEsbCh6b4SNlc2yEyl74Xm+x6D7o=";
   };
 in
 ''
   export GITSTATUS_PLUGIN_PATH=${pkgs.gitstatus}/share/gitstatus
   source ${aleksanaPS1}/aleksana
 '';
```
