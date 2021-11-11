#!/bin/bash

err() {
    printf 'An error has occurred: %s\nExiting...' "$@" >&2
    exit    
}

inspkg() {

	# Note: local var so it's only declared in the function
    local PKGS
    PKGS="openbox picom tint2 flameshot nitrogen"
    readonly PKGS

    local PKGS_AUR
    PKGS_AUR="pnmixer albert"
    readonly PKGS_AUR

    # Install packages using variables
    if ! sudo pacman -S --needed "$PKGS"; then 
        err "Pacman failed to install packages. Make sure you're using arch."
    fi

    if ! yay -S "$PKGS_AUR" ; then
        err 'Yay failed to install packages. Make sure you have yay installed.'
    fi
}

filebank() {
	## Declare links to pull dotfiles from

	# ~/.config/openbox
	RC="https://raw.githubusercontent.com/EnokiPPT/dotfiles/main/Openbox-Minimal/.config/openbox/rc.xml"
	AUTOSTART="https://raw.githubusercontent.com/EnokiPPT/dotfiles/main/Openbox-Minimal/.config/openbox/autostart"

	# ~/.config/picom
	PICOMCONF="https://raw.githubusercontent.com/EnokiPPT/dotfiles/main/Openbox-Minimal/.config/picom/picom.conf"

	# ~/.config/tint2
	TINT2RC="https://raw.githubusercontent.com/EnokiPPT/dotfiles/main/Openbox-Minimal/.config/tint2/tint2rc"
	TINT2RC2="https://raw.githubusercontent.com/EnokiPPT/dotfiles/main/Openbox-Minimal/.config/tint2/tint2rc2"

	# ~/.themes/sunstone
	SUNSTONE="https://raw.githubusercontent.com/EnokiPPT/dotfiles/main/Openbox-Minimal/.themes/sunstone/sunstone.zip"
}

dotfiles() {
    local error
    error=0
    
    if ! command -v curl &>/dev/null; then
        err 'curl is not installed'
        error=1
    fi

    # Get dotfiles
    if ! curl "$RC" --create-dirs -o ~/.config/openbox/rc.xml; then
        printf 'Warning: failed to acquire %s\n' "$RC" >&2
        error=1
    fi
    if ! curl "$AUTOSTART" --create-dirs -o ~/.config/openbox/autostart; then
        printf 'Warning: failed to acquire %s\n' "$AUTOSTART" >&2
        error=1
    fi
    if ! curl "$PICOMCONF" --create-dirs -o ~/.config/picom/picom.conf; then
        printf 'Warning: failed to acquire %s\n' "$PICOMCONF" >&2
        error=1
    fi  
    if ! curl "$TINT2RC" --create-dirs -o ~/.config/tint2; then
        printf 'Warning: failed to acquire %s\n' "$TINT2RC" >&2
        error=1
    fi   
    if ! curl "$TINT2RC2" --create-dirs -o ~/.config/tint2; then
        printf 'Warning: failed to acquire %s\n' "$TINT2RC2" >&2
        error=1
    fi    
    if ! curl "$SUNSTONE" -o /tmp/sunstone; then        
        printf 'Warning: failed to acquire %s\n' "$SUNSTONE" >&2
        error=1
    else
        # Extract Sunstone to ~/.themes
        if ! unzip /tmp/sunstone -d ~/.themes; then
            printf 'Warning: failed to unzip\n' >&2
            error=1
        fi
    fi

    if ((error == 0)); then
        return 0;
    fi

    return 1
}

main() {
    # Execute all functions in correct order
    if ! inspkg; then
        err 'Failed to execute function to install packages.'
    fi

    if ! dotfiles; then
        err 'Failed to download dotfiles.'
    fi
    # always exit with a exit number
    return 0
}

# Run the script
main "$@"
exit
