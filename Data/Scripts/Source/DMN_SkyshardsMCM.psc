; Copyright (C) 2017 Phillip Stolić
; 
; This program is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
; 
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
; 
; You should have received a copy of the GNU General Public License
; along with this program.  If not, see <http://www.gnu.org/licenses/>.

ScriptName DMN_SkyshardsMCM Extends ObjectReference

{Temporary mod configuration script pre-MCM.}

Import Game
Import Debug
Import Utility
Import DMN_SkyshardsFunctions

Alias Property skyshardBeaconEnabled Auto
Alias Property skyshardBeaconDisabled Auto

FormList Property DMN_SkyshardsMapMarkersList Auto
FormList Property DMN_SkyshardsBeaconList Auto
FormList Property DMN_SkyshardsAbsorbedList Auto

Message Property DMN_SkyshardsConfigMenu Auto
Message Property DMN_SkyshardsConfigMenuMapMarkers Auto
Message Property DMN_SkyshardsConfigMenuBeacons Auto

Quest Property DMN_SkyshardsHelper Auto

Event OnRead()
	Wait(0.1)
	configureMod()
EndEvent

Function configureMod()
; Stop further config menu activation until we finish processing this request.
	GotoState("configuring")
	Int choice = DMN_SkyshardsConfigMenu.Show() ; Main Config Menu.
	If (choice == 0) ; Map Markers.
		Int choice00 = DMN_SkyshardsConfigMenuMapMarkers.Show()
		If (choice00 == 0)
		; Enable Map Markers.
			Wait(0.1)
			Notification("Skyshards: Enabling map markers...")
			showSkyshardMapMarkers(DMN_SkyshardsMapMarkersList, True)
			Wait(0.1)
			Notification("Skyshards: Map markers have been enabled!")
		ElseIf (choice00 == 1)
		; Disable Map Markers.
			Wait(0.1)
			Notification("Skyshards: Disabling map markers...")
			showSkyshardMapMarkers(DMN_SkyshardsMapMarkersList, False)
			Wait(0.1)
			Notification("Skyshards: Map markers have been disabled!")
		ElseIf (choice00 == 2)
		; Return To Main Config Menu.
			GoToState("postConfig")
			configureMod()
		EndIf
	ElseIf (choice == 1) ; Skyshard Beacons.
		Int choice01 = DMN_SkyshardsConfigMenuBeacons.Show()
		If (choice01 == 0)
		; Enable Beacons.
			Wait(0.1)
			Notification("Skyshards: Enabling Skyshard beacons...")
			showSkyshardBeacons(DMN_SkyshardsHelper, DMN_SkyshardsBeaconList, True)
			Wait(0.1)
			Notification("Skyshards: Skyshard beacons have been enabled!")
		ElseIf (choice01 == 1)
		; Disable Beacons.
			Wait(0.1)
			Notification("Skyshards: Disabling Skyshard beacons...")
			showSkyshardBeacons(DMN_SkyshardsHelper, DMN_SkyshardsBeaconList, False, skyshardBeaconEnabled)
			Wait(0.1)
			Notification("Skyshards: Skyshard beacons have been disabled!")
		ElseIf (choice01 == 2)
		; Return To Main Config Menu.
			GoToState("postConfig")
			configureMod()
		EndIf
	ElseIf (choice == 2) ; Exit Config Menu.
	Else
		Notification("Skyshards: The mod configuration script ran into an unknown error. Please inform Deadmano.")
	EndIf
; We can allow config menu activation once more now that the first request has been completed.
	GoToState("postConfig")
EndFunction

State configuring
	Function configureMod()
		; Empty function to ensure user doesn't activate the config menu several times in succession.
		Notification("Skyshards: Please wait for the previous configuration changes to complete...")
	EndFunction
EndState
