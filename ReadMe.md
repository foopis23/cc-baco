# CC Baco
This is an attempt to improve the out of the box experience of Computer Craft's CraftOS.

## Features
- Unix style file system
- Path aliases and auto-completion for `~`
- Alias `restart` for `reboot`

## Installation
### Using Install Script (Recommended)
1. Run `wget run https://raw.githubusercontent.com/foopis23/cc-baco/master/setup-cc-os.lua`
2. Waiting for Install Script to finish, after which it will reboot your computer

### Manual Installation
This is not recommended and is only really for people who can't use http requests.

1. Copy and paste the contents of `https://raw.githubusercontent.com/foopis23/cc-baco/master/startup-cc-os.lua` to the file `startup.lua`.
2. Create the directory `/bin`, `/home`, `/etc`, `/lib`
3. Reboot your computer