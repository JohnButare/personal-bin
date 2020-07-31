PiCheckPower() { ! dmesg --time-format ctime | grep -i volt; } # check for under voltage in the log

PI_FIRMWARE_CHANNEL="/etc/default/rpi-eeprom-update"
PI_FIRMWARE_DIR="/lib/firmware/raspberrypi/bootloader"

PiFirmwareInfo()
{
	printf "Bootloader version:"
	sudoc vcgencmd bootloader_version || return
	
	[[ -f "$PI_FIRMWARE_CHANNEL" ]] && { printf "\nUpdate channel:\n"; cat "$PI_FIRMWARE_CHANNEL"; }

	printf "\nBootloader configuration:\n"
	sudo vcgencmd bootloader_config | RemoveEmptyLines || return
}

PiFirmwareEdit()
{
	local FIRMWARE_RELEASE_STATUS; . "$PI_FIRMWARE_CHANNEL" || return
	local dir="$PI_FIRMWARE_DIR/$FIRMWARE_RELEASE_STATUS"
	local config="$dir/bootconf.txt"; [[ -f "$config" ]] && { sudo bak --move "$config" || return; }
		
	# select the firmware file
	local file="$1"; shift
	[[ ! "$file" ]] && { file="$(dialog --title "Select Firmware" --stdout --fselect ""$dir/"" $(($LINES-12)) 100)"; clear; }
	[[ ! "$file" ]] && { MissingOperand "file" "PiFirmwareEdit"; return 1; }
	[[ ! -f "$file" ]] && { EchoErr "PiFirmwareEdit: firmware file \"$file\" does not exist"; return 1; }
	
	# extract the configuration
	sudoc cp "$file" "$dir/current.bin" || return
	rpi-eeprom-config "$dir/current.bin" | sudo tee "$config" || return
	[[ ! -f "$config" || "$(cat "$config")" == "" ]] && { EchoErr "Unable to extract the firmware configuration from \"$file\""; return 1; }
	sudo cp "$config" "$config.orig" || return
	
	# edit the configuration
	sudoedit "$config" || return
	diff "$config" "$config.orig" >& /dev/null && return
	
	# update the firmware file
	sudo rpi-eeprom-config --out "$dir/new-config.bin" --config "$config" "$dir/current.bin" || return
	
	# apply the firmware
	sudo rpi-eeprom-update -d -f "$dir/new-config.bin" || return
}


PiFirmwareDir() { cd "$PI_FIRMWARE_DIR"; }
PiFirmwareEditChannel() { sudoedit "$PI_FIRMWARE_CHANNEL"; }
PiFirmwareUpdate() { sudo rpi-eeprom-update -a && { ask "Reboot" && power reboot || return 0; }; }
