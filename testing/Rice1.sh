#!/bin/bash

wget_links=(
    "https://raw.githubusercontent.com/EnokiPPT/dotfiles/main/Rice1/Lean/close.xbm" 
    "https://raw.githubusercontent.com/EnokiPPT/dotfiles/main/Rice1/Lean/desk.xbm" 
    "https://raw.githubusercontent.com/EnokiPPT/dotfiles/main/Rice1/Lean/desk_toggled.xbm" 
    "https://raw.githubusercontent.com/EnokiPPT/dotfiles/main/Rice1/Lean/iconify.xbm" 
    "https://raw.githubusercontent.com/EnokiPPT/dotfiles/main/Rice1/Lean/max.xbm" 
    "https://raw.githubusercontent.com/EnokiPPT/dotfiles/main/Rice1/Lean/max_toggled.xbm" 
    "https://raw.githubusercontent.com/EnokiPPT/dotfiles/main/Rice1/Lean/shade_toggled.xbm" 
    "https://raw.githubusercontent.com/EnokiPPT/dotfiles/main/Rice1/Lean/themerc" 
    "https://raw.githubusercontent.com/EnokiPPT/dotfiles/main/Rice1/Lean/themerc.in" 
    )


function check_for_installed() {
  command -v xfce4-panel-profiles >/dev/null 2>&1 || { echo >&2 "Please install xfce4-panel-profiles, then re-run the script."; exit 1; }
  command -v openbox >/dev/null 2>&1 || { echo >&2 "Please install openbox, then re-run the script."; exit 1; }	
  if [[ ! command -v picom &> /dev/null ]]; then
    echo "Picom is not installed. However, it is optional and for this script picom is not necessary. Would you like to exit to install it? [Y/n]"
    read picomchk
    if [[ ${picomchk,,} == "y" ]]; then
      exit 0
    else
      true
    fi
  fi
}

function dl_obtheme() {
  if [[ ! -e ~/.themes/Lean ]]; then
	  # -r for recursiveness in the event ~/.themes doesn't exist
	  mkdir -r ~/.themes/Lean
  else
  	  echo " '~/.themes/Lean' already exists! Would you like to relocate it? [Y/n]"
  	  read overwrite
          if [[ "${overwrite,,}" == "y"]]; then
		  mv ~/.themes/Lean ~/.themes/Lean_RELOCATED && echo "Successfully moved ~/.themes/Lean to ~/.themes/Lean_RELOCATED" || echo "Could not move ~/.themes/Lean to ~/.themes/Lean_RELOCATED. Exiting..." && exit 0
	  fi        	
  fi

  if ! command -v wget >/dev/null 2>&1; then
      echo "wget is not installed. aborting..."
    return 1
  fi
  echo "Downloading files for openbox theme..."
  wget "${wget_links[@]}" -P ~/.themes/Lean
  
  echo "Items for ~/.themes/Lean have been successfully cloned."
  wait 1
  clear
  return 0
}

function dl_openbox_stuff() {
  if [[ -e ~/.config/openbox/rc.xml ]]; then
	echo "Openbox rc file exists. Relocating it to rcBACKUP.xml"
	mv ~/.config/openbox/rc.xml ~/.config/openbox/rcBACKUP.xml
  fi
  
  if [[ -e ~/.config/openbox/menu.xml ]]; then
	echo "Openbox menu file exists. Relocating it to menuBACKUP.xml"
	mv ~/.config/openbox/menu.xml ~/.config/openbox/menuBACKUP.xml
  fi
  
  if [[ -e ~/.config/picom/picom.conf ]]; then
    echo "Picom configuration file exists. "
  fi
  
  echo "Downloading openbox RC and menu..."
  wget https://raw.githubusercontent.com/EnokiPPT/dotfiles/main/Rice1/openbox/rc.xml -P ~/.config/openbox/rc.xml -P ~/.config/openbox
  wget https://raw.githubusercontent.com/EnokiPPT/dotfiles/main/Rice1/openbox/menu.xml -P ~/.config/openbox/rc.xml -P ~/.config/openbox
}

function dl_xfce_stuff() {
  	echo "Downloading and applying XFCE panel theme..."
  	wget https://github.com/EnokiPPT/dotfiles/raw/main/Rice1/xfce-stuff/Rice1Panel && xfce4-panel-profiles load Rice1Panel
  	if [[ ! -e ~/.walls ]]; then
  	  mkdir ~/.walls
  	fi
  	wget https://github.com/EnokiPPT/dotfiles/raw/main/Rice1/modern-architecture-building-blue-illustration-waves-4134x1849-2543.png -P ~/.walls
  	echo "Cannot apply wallpaper programatically, so the wallpaper is in ~/.walls ."
}


main() {
  dl_obtheme
  dl_openbox_stuff
  dl_xfce_stuff
  check_for_installed
}


main "$@"
