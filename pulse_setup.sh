#!/bin/bash

# This script sets up pulseaudio virtual devices
# The following variables must be set to the names of your own microphone and speakers devices
# You can find their names with the following commands :
# pacmd list-sources | grep alsa_input
# pacmd list-source-outputs | grep alsa_output
# Use pavucontrol to make tests for your setup and to make the runtime configuration
# Route your audio source to soundflower1
# Record your sound (videoconference) from soundflower2.monitor

MICROPHONE="alsa_input.usb-0b0e_Jabra_SPEAK_410_USB_501AA5A00C87x010900-00.mono-fallback"
SPEAKERS="alsa_output.usb-Lenovo_ThinkPad_Thunderbolt_3_Dock_USB_Audio_000000000000-00.analog-stereo"


# Create the null sinks
# soundflower1 gets your audio sources (mplayer ...) that you want to hear and share
# soundflower2 gets all the audio you want to share (soundflower1 + micro)
pactl load-module module-null-sink sink_name=soundflower1 sink_properties=device.description="soundflower1"
pactl load-module module-null-sink sink_name=soundflower2 sink_properties=device.description="soundflower2"

# Now create the loopback devices, all arguments are optional and can be configured with pavucontrol
pactl load-module module-loopback source=soundflower1.monitor sink=$SPEAKERS latency_msec=1
pactl load-module module-loopback source=soundflower1.monitor sink=soundflower2 latency_msec=1
pactl load-module module-loopback source=$MICROPHONE sink=soundflower2 latency_msec=1

# If you struggle to find the correct values of your physical devices, you can
# also simply leave these undefined, and configure everything manually via pavucontrol
# pactl load-module module-loopback source=soundflower1.monitor
# pactl load-module module-loopback source=soundflower1.monitor sink=soundflower2
# pactl load-module module-loopback sink=soundflower2
