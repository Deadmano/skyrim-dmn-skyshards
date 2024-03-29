; Copyright (C) 2021 Phillip Stolić
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

ScriptName DMN_SkyshardsConfig Extends Quest

{Skyshards - Configuration Script by Deadmano.}
;==============================================
; Version: 1.6.0
;===============

Import DMN_DeadmaniacFunctions
Import DMN_SkyshardsFunctions
Import Debug
Import Game
Import Utility

DMN_SkyshardsQuest Property DMN_SQN Auto
DMN_SkyshardsQuestData Property DMN_SQD Auto

Book Property DMN_SkyshardsConfigurator Auto
{Stores the temporary mod configurator. Auto-Fill.}

FormList Property DMN_SkyshardsMapMarkersList Auto
{Stores all the Skyshard map markers.}

GlobalVariable Property DMN_SkyshardsDebug Auto
{Set to the debug global variable.}

; --

; User's Installed Script Version as an Integer.
GlobalVariable Property DMN_iSkyshardsVersionInstalled Auto 
{Stores the users Skyshards version. Auto-Fill.}
; User's Installed Script Version as a string.
String DMN_sSkyshardsVersionInstalled 

; Current Script Version Being Run.
Int DMN_iSkyshardsVersionRunning
String DMN_sSkyshardsVersionRunning

; The version of the Skyshards script currently running accessable
; by other scripts as a property.
Int Property skyshardsVersion Hidden
  Int Function get()
    Return DMN_iSkyshardsVersionRunning
  EndFunction
EndProperty

; User's Installed Configurator Script Version.
Int DMN_iSkyshardsConfiguratorVersionInstalled

; The version of the Skyshards configurator script installed on the player's
; save accessable by other scripts as a property.
Int Property skyshardsConfiguratorVersion Hidden
	Int Function get()
	  Return DMN_iSkyshardsConfiguratorVersionInstalled
	EndFunction
EndProperty

; The following store the amount of Skyshards
; that each version of the mod contains.
Int DMN_iSkyshardsTotalCurrent
Int DMN_iSkyshardsTotal_v1_0_0
Int DMN_iSkyshardsTotal_v1_1_0
Int DMN_iSkyshardsTotal_v1_2_0
Int DMN_iSkyshardsTotal_v1_3_0
Int DMN_iSkyshardsTotal_v1_4_0
Int DMN_iSkyshardsTotal_v1_5_0

; BEGIN Update Related Variables and Properties
;==============================================
;
; BEGIN v1.1.0
;-------------

Alias Property skyshardStatic Auto
{The alias on the Helper quest that fills with all found Skyshard statics. Auto-Fill.}

FormList Property DMN_SkyshardsAbsorbedList Auto
{Stores all absorbed Skyshards into this FormList. Auto-Fill.}

FormList Property DMN_SkyshardsAbsorbedStaticList Auto
{Stores all dynamically placed Skyshard Statics into this FormList. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsCountActivated Auto
{The total amount of Skyshards the player has activated throughout Skyrim and other DLCs/Mods. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsSkyrimCountActivated Auto
{The total amount of Skyshards the player has activated throughout Skyrim. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsDLC01CountActivated Auto
{Tracks DLC01 Skyshard activations. Set on Skyshard object if in DLC01 worldspace. Auto-Fill.}

Message Property DMN_SkyshardsUpdateAnnouncement_v1_1_0 Auto
{The message that is shown to the player for the update to version 1.1.0. Auto-Fill.}

Quest Property DMN_SkyshardsHelper Auto
{The Quest that also handles the once-off removal of dynamically placed Skyshard Statics. Auto-Fill.}

Static Property DMN_SkyshardActivated Auto
{Static version of the Skyshard, switched out when the player activates and absorbs a Skyshard. Auto-Fill.}

; END v1.1.0
;-------------

; BEGIN v1.2.0
;-------------

GlobalVariable Property DMN_SkyshardsCountTotal Auto
{The amount of Skyshards that exist in total throughout Skyrim and other DLCs/Mods. Auto-Fill.}
GlobalVariable Property DMN_SkyshardsSkyrimCountTotal Auto
{The amount of Skyshards that exist in total throughout Skyrim. Auto-Fill.}

Message Property DMN_SkyshardsUpdateAnnouncement_v1_2_0 Auto
{The message that is shown to the player for the update to version 1.2.0. Auto-Fill.}

; END v1.2.0
;-------------

; BEGIN v1.3.0
;-------------

Message Property DMN_SkyshardsUpdateAnnouncement_v1_3_0 Auto
{The message that is shown to the player for the update to version 1.3.0. Auto-Fill.}

; END v1.3.0
;-------------

; BEGIN v1.4.0
;-------------

Message Property DMN_SkyshardsUpdateAnnouncement_v1_4_0 Auto
{The message that is shown to the player for the update to version 1.4.0. Auto-Fill.}

; END v1.4.0
;-------------

; BEGIN v1.5.0
;-------------

Message Property DMN_SkyshardsUpdateAnnouncement_v1_5_0 Auto
{The message that is shown to the player for the update to version 1.5.0. Auto-Fill.}

; END v1.5.0
;-------------

; BEGIN v1.6.0
;-------------

FormList Property DMN_SkyshardsBeaconList Auto
{Stores all the Skyshard beacons. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsComplete Auto
{Whether or not all Skyshards have been found across all main quests.
0 = there are Skyshards to be found, 1 = all have been found. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsPersistGodMode Auto
{Stores whether god mode is persisted after Skyshard activation. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsShowBeacons Auto
{Stores whether beacons are enabled or disabled. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsShowMapMarkers Auto
{Stores whether map markers are enabled or disabled. Auto-Fill.}

Message Property DMN_SkyshardsUpdateAnnouncement_v1_6_0 Auto
{The message that is shown to the player for the update to version 1.6.0. Auto-Fill.}

; END v1.6.0
;-------------

Message Property DMN_SkyshardsUpdateAnnouncementHandler Auto
{The message that is shown to the player when multiple updates are detected. Auto-Fill.}

; END Update Related Variables and Properties
;==============================================

; The following will be run once per game load.
Event OnInit()
	preMaintenance() ; Function to run before the main script maintenance.
    Maintenance() ; Function to handle script maintenance.
EndEvent

Function preMaintenance()
; Set the total Skyshards found values to the total of each DLC/Mod + base game.
; Skipped if an existing value is found. Used to correct v1.0.0 saves only.
	Int i = 0

	If (i == 0 && DMN_SkyshardsCountActivated.GetValue() as Int == 0)
	i = (DMN_SkyshardsSkyrimCountActivated.GetValue() as Int) + (DMN_SkyshardsDLC01CountActivated.GetValue() as Int)
	DMN_SkyshardsCountActivated.SetValue(i as Int)
	i = 0
	EndIf

	; Add support for tracking the configurator version to avoid issues where an
	; outdated configurator won't have new properties. v1.5.0 saves or under.
	If (DMN_iSkyshardsVersionInstalled.GetValue() as Int <= 1500)
		giveConfigurator(DMN_SkyshardsConfigurator)
		DMN_iSkyshardsConfiguratorVersionInstalled = skyshardsVersion
	EndIf

	; Check if the player's configurator is up to date.
	checkConfigurator()
EndFunction
 
Function Maintenance()
; The latest (current) version of Skyshards. Update this to the version number.
	parseSkyshardsVersion("1", "6", "0") ; <--- CHANGE! No more than: "9e9", "99", "9".
; ---------------- UPDATE! ^^^^^^^^^^^

; Skyshards added per version.
	DMN_iSkyshardsTotalCurrent = DMN_SkyshardsCountTotal.GetValue() as Int
	DMN_iSkyshardsTotal_v1_0_0 = 21	; v1.0.0
	DMN_iSkyshardsTotal_v1_1_0 = 21 ; v1.1.0
	DMN_iSkyshardsTotal_v1_2_0 = 43 ; v1.2.0
	DMN_iSkyshardsTotal_v1_3_0 = 67 ; v1.3.0
	DMN_iSkyshardsTotal_v1_4_0 = 89 ; v1.4.0
	DMN_iSkyshardsTotal_v1_5_0 = 108 ; v1.5.0

	If (DMN_SkyshardsDebug.GetValue() == 1)
		If (DMN_sSkyshardsVersionInstalled)
			Wait(0.1)
			Notification("Skyshards DEBUG: An existing install of Skyshards was detected on this save!")
			If (DMN_sSkyshardsVersionInstalled == "")
				Wait(0.1)
				Notification("Skyshards DEBUG: This save is referencing an unknown version of Skyshards' configuration script.")
			Else
				Wait(0.1)
				Notification("Skyshards DEBUG: This save is referencing version " + DMN_sSkyshardsVersionInstalled + " of Skyshards' configuration script.")
			EndIf
			Wait(0.1)
			Notification("Skyshards DEBUG: You are running Skyshards' version " + DMN_sSkyshardsVersionRunning + " configuration script.")
		EndIf
	EndIf

; Check to see if this is a new install.
	If (DMN_iSkyshardsVersionInstalled.GetValue() as Int < ver3ToInteger("1", "0", "0"))
	
	; //Debug - Check if Skyshards reaches the new install check.
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Checkpoint - New Install Check Reached.")
	
	; If it is, install Skyshards for the first time to this save.
		installSkyshards()

; Else check to see if the user's installed Skyshards version is less than this running version of Skyshards.
; Or if any Skyshards were absorbed, to detect a previous install from the legacy v1.0.0 version.
	ElseIf (DMN_iSkyshardsVersionInstalled.GetValue() as Int < DMN_iSkyshardsVersionRunning)

	; //Debug - Check if Skyshards reaches the update check.
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Checkpoint - Update Check Reached.")
	
	; If it is then we need to run the update on this save.
		updateSkyshards()

; Check to see if the user is loading a save with an existing Skyshards install but is using older Skyshards scripts than those saved with.
	ElseIf (DMN_iSkyshardsVersionInstalled.GetValue() as Int > DMN_iSkyshardsVersionRunning)
		Wait(0.1)
		MessageBox("Skyshards has detected that you are using one or more outdated scripts than those used when this save was created. This is just a warning and you may continue to play with unknown side-effects; though for best results it is advised that you update to the latest version.")

; Check to see if the user's installed Skyshards version matches this running version of Skyshards.
	ElseIf (DMN_iSkyshardsVersionInstalled.GetValue() as Int == DMN_iSkyshardsVersionRunning)
	
	; //Debug - Check if Skyshards reaches the versions match check.
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Checkpoint - Versions Match Check Reached.")
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: String Value: " + DMN_sSkyshardsVersionRunning)
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Integer Value: " + DMN_iSkyshardsVersionRunning)

; No idea how the user got here, but good to grab just in case!
	Else
		Wait(0.1)
		MessageBox("WARNING: The version of Skyshards cannot be detected! Please inform Deadmano.")
	EndIf
EndFunction

Function parseSkyshardsVersion(String sMajorVer, String sMinorVer, String sReleaseVer)
	DMN_iSkyshardsVersionRunning = ver3ToInteger(sMajorVer, sMinorVer, sReleaseVer)
	DMN_sSkyshardsVersionRunning = ver3ToString(sMajorVer, sMinorVer, sReleaseVer)
EndFunction

Function installSkyshards()
; //Debug - Check if Skyshards reaches the install function.
	debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Checkpoint - Install Function Reached.")
	
; Check if previous Skyshards have been found from the legacy v1.0.0 version of Skyshards.
	If (DMN_SkyshardsCountActivated.GetValue() as Int > 0)
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Checkpoint - Unknown Previous Version Update.")
	; If any are found, we need to update this save's version of Skyshards.
		updateSkyshards()
; Otherwise treat this save as a clean install.
	Else
		Wait(0.1)
		Notification("Skyshards: Installation and configuration in progress.")
		Notification("Skyshards: Please do not quit or save the game until this process is complete.")
		
	; Set the default configuration settings.
		configurationDefaults()
		
	; Updates the user's installed Skyshards version to this running version of Skyshards.
		DMN_iSkyshardsVersionInstalled.SetValue(DMN_iSkyshardsVersionRunning as Int) ; Integer.
		DMN_sSkyshardsVersionInstalled = DMN_sSkyshardsVersionRunning ; String.
		Wait(0.1)
		Notification("Skyshards: You are now running version " + DMN_sSkyshardsVersionInstalled + ". Enjoy!")
		Notification("Skyshards: It is now safe to save your game to finalise the installation!")

	; //Debug - Check if Skyshards passes the install function.
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Checkpoint - Install Function Passed.")
	EndIf
EndFunction

Function updateSkyshards()
; //Debug - Check if Skyshards reaches the update function.
	debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Checkpoint - Update Function Reached.")

	If (DMN_sSkyshardsVersionInstalled == "")
		Wait(0.1)
		Notification("Skyshards: Updating from a previous unknown version.")
	Else
		Wait(0.1)
		Notification("Skyshards: Updating from version " + DMN_sSkyshardsVersionInstalled + ".")
	EndIf
	
	Notification("Skyshards: Please do not quit or save the game until this process is complete.")

	; // BEGIN UPDATE FOR CURRENT SCRIPT VERSION
	;-------------------------------------------
	
; BEGIN v1.0.0 FIXES/PATCHES
	If (DMN_iSkyshardsVersionInstalled.GetValue() as Int < ver3ToInteger("1", "1", "0"))
	; Removal of all static (activated) Skyshards that were dynamically added and couldn't be directly referenced.
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Removing dynamically placed Skyshard statics now...")
		removeDynamicSkyshardStatics(DMN_SkyshardsHelper, skyshardStatic)
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: All dynamically placed Skyshard statics have been removed!")
	; Adding Skyshard Statics dynamically at the location of the Skyshard Activators.
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Placing Skyshard statics at updated absorbed Skyshard locations now...")
		placeSkyshardStatics(DMN_SkyshardsAbsorbedList, DMN_SkyshardActivated, DMN_SkyshardsAbsorbedStaticList)
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: All Skyshard statics have been placed!")
	; Start the main quest up to start tracking existing Skyshards and future ones as well.
		DMN_SQN.startMainQuest("Skyrim")
	; Update the quest progress of all previously found Skyshards.
		DMN_SQD.startSideQuests()
	EndIf
; END v1.0.0 FIXES/PATCHES
	
	; // BEGIN VERSION SPECIFIC UPDATES
	;----------------------------------
	
; v1.2.0
;-------
	If (DMN_iSkyshardsVersionInstalled.GetValue() as Int < ver3ToInteger("1", "2", "0") && \
	DMN_sSkyshardsVersionRunning == "1.2.0")
		DMN_SkyshardsCountTotal.SetValue(DMN_iSkyshardsTotal_v1_2_0 as Int)
		DMN_SkyshardsSkyrimCountTotal.SetValue(DMN_iSkyshardsTotal_v1_2_0 as Int)
		Notification("Skyshards: Scholars confirm additional Skyshards have phased into existence! " \
		+ "(" + DMN_iSkyshardsTotalCurrent + " > " + DMN_iSkyshardsTotal_v1_2_0 + ").")
	EndIf
	
; v1.3.0
;-------
	If (DMN_iSkyshardsVersionInstalled.GetValue() as Int < ver3ToInteger("1", "3", "0") && \
	DMN_SkyshardsSkyrimCountTotal.GetValue() as Int != DMN_iSkyshardsTotal_v1_3_0 && \
	DMN_iSkyshardsVersionRunning == 1300)
		DMN_SkyshardsCountTotal.SetValue(DMN_iSkyshardsTotal_v1_3_0 as Int)
		DMN_SkyshardsSkyrimCountTotal.SetValue(DMN_iSkyshardsTotal_v1_3_0 as Int)
		Notification("Skyshards: Scholars confirm additional Skyshards have phased into existence! " \
		+ "(" + DMN_iSkyshardsTotalCurrent + " > " + DMN_iSkyshardsTotal_v1_3_0 + ").")
	EndIf
	
; v1.4.0
;-------
	If (DMN_iSkyshardsVersionInstalled.GetValue() as Int < ver3ToInteger("1", "4", "0") && \
	DMN_SkyshardsSkyrimCountTotal.GetValue() as Int != DMN_iSkyshardsTotal_v1_4_0 && \
	DMN_iSkyshardsVersionRunning == 1400)
		DMN_SkyshardsCountTotal.SetValue(DMN_iSkyshardsTotal_v1_4_0 as Int)
		DMN_SkyshardsSkyrimCountTotal.SetValue(DMN_iSkyshardsTotal_v1_4_0 as Int)
		Notification("Skyshards: Scholars confirm additional Skyshards have phased into existence! " \
		+ "(" + DMN_iSkyshardsTotalCurrent + " > " + DMN_iSkyshardsTotal_v1_4_0 + ").")
	EndIf
	
; v1.5.0
;-------
	If (DMN_iSkyshardsVersionInstalled.GetValue() as Int < ver3ToInteger("1", "5", "0") && \
	DMN_SkyshardsSkyrimCountTotal.GetValue() as Int != DMN_iSkyshardsTotal_v1_5_0 && \
	DMN_iSkyshardsVersionRunning >= 1500) ; Greater Than or Equal To v1.5.0.
		DMN_SkyshardsCountTotal.SetValue(DMN_iSkyshardsTotal_v1_5_0 as Int)
		DMN_SkyshardsSkyrimCountTotal.SetValue(DMN_iSkyshardsTotal_v1_5_0 as Int)
		Notification("Skyshards: Scholars confirm additional Skyshards have phased into existence! " \
		+ "(" + DMN_iSkyshardsTotalCurrent + " > " + DMN_iSkyshardsTotal_v1_5_0 + ").")
	EndIf

; v1.6.0
;-------
	; Resolve map markers being turned off every update for those who chose to have map markers enabled.
	If (DMN_iSkyshardsVersionInstalled.GetValue() as Int < ver3ToInteger("1", "6", "0") && \
	DMN_iSkyshardsVersionRunning >= 1600 && DMN_SkyshardsShowMapMarkers.GetValue() != 1) ; Greater Than or Equal To v1.6.0.
		Int i = DMN_SkyshardsMapMarkersList.GetSize() ; Get the count of map markers in the FormList.
		debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: Checking if map markers were previously enabled...")
		While (i) ; Stop looping if we can't find a map marker in our FormList.
			i -= 1
			ObjectReference ref = DMN_SkyshardsMapMarkersList.GetAt(i) as ObjectReference
		; Ensure our reference is a map marker in our FormList.
			If (DMN_SkyshardsMapMarkersList.GetAt(i) == ref)
			; Check if the map marker is enabled.
				If (ref.IsEnabled())
					debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: Found a previously enabled map marker! Assuming map markers were previously enabled.")
					DMN_SkyshardsShowMapMarkers.SetValue(1 as Int) ; Update the newly added global variable to preserve the map markers visibility state.
					Notification("Skyshards: Your previously enabled map markers have been preserved!")
					i = 0 ; Stop looking once we've found an enabled map marker.
				EndIf
			EndIf
		EndWhile
		debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: Stopped checking for map markers!")
	EndIf

	; Persist beacon visibility state to a global variable.
	If (DMN_iSkyshardsVersionInstalled.GetValue() as Int < ver3ToInteger("1", "6", "0") && \
		DMN_iSkyshardsVersionRunning >= 1600 && DMN_SkyshardsCountActivated.GetValue() != DMN_SkyshardsCountTotal.GetValue()) ; Greater Than or Equal To v1.6.0.
			Int i = DMN_SkyshardsBeaconList.GetSize() ; Get the count of beacons in the FormList.
			Bool beaconsDisabled = False
			debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: Checking if there are any beacons still active...")
			While (i) ; Stop looping if we can't find a beacon in our FormList.
				i -= 1
				ObjectReference ref = DMN_SkyshardsBeaconList.GetAt(i) as ObjectReference
			; Ensure our reference is a beacon in our FormList.
				If (DMN_SkyshardsBeaconList.GetAt(i) == ref)
				; Check if the beacon is enabled.
					If (ref.IsEnabled())
						debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: Found a previously enabled beacon! Assuming beacons were previously enabled.")
						beaconsDisabled = False ; Update the boolean to specify beacons are indeed enabled.
						i = 0 ; Stop looking once we've found an enabled beacon.
				; If we find a disabled beacon, update the boolean.
					ElseIf (ref.IsDisabled())
						beaconsDisabled = True
					EndIf
				EndIf
			EndWhile
			; If our boolean was set to false at any point due to no active beacons being found,
			; update the newly added global variable to reflect this change.
			If (beaconsDisabled)
				debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: No active beacons found despite active Skyshards. Assuming beacons were previously disabled.")
				DMN_SkyshardsShowBeacons.SetValue(0 as Int)
			EndIf
			debugTrace(DMN_SkyshardsDebug, "Skyshards DEBUG: Stopped checking for beacons!")
		EndIf
	
	; // END VERSION SPECIFIC UPDATES
	;----------------------------------

	; // END UPDATE FOR CURRENT SCRIPT VERSION
	;-------------------------------------------
	
; Set the default configuration settings.
	configurationDefaults()

; Sync quest progress with any changes this update may have brought.
	DMN_SQD.syncQuestProgress()

	; // BEGIN VERSION SPECIFIC ANNOUNCEMENT MESSAGES
	;------------------------------------------------
	
	Bool v1_1_0 = False
	Bool v1_2_0 = False
	Bool v1_3_0 = False
	Bool v1_4_0 = False
	Bool v1_5_0 = False
	Bool v1_6_0 = False
	Int updateCount = 0
	; Change this to the latest update announcement message.
	Message latestUpdate = DMN_SkyshardsUpdateAnnouncement_v1_6_0

; v1.1.0
;-------
	If (DMN_iSkyshardsVersionInstalled.GetValue() as Int < ver3ToInteger("1", "1", "0") && \
		DMN_iSkyshardsVersionRunning >= 1100)
		Wait(3.0)
		v1_1_0 = True
		updateCount += 1
	EndIf
	
; v1.2.0
;-------
	If (DMN_iSkyshardsVersionInstalled.GetValue() as Int < ver3ToInteger("1", "2", "0") && \
		DMN_iSkyshardsVersionRunning >= 1200)
		v1_2_0 = True
		updateCount += 1
	EndIf
	
; v1.3.0
;-------
	If (DMN_iSkyshardsVersionInstalled.GetValue() as Int < ver3ToInteger("1", "3", "0") && \
		DMN_iSkyshardsVersionRunning >= 1300)
		v1_3_0 = True
		updateCount += 1
	EndIf
	
; v1.4.0
;-------
	If (DMN_iSkyshardsVersionInstalled.GetValue() as Int < ver3ToInteger("1", "4", "0") && \
		DMN_iSkyshardsVersionRunning >= 1400)
		v1_4_0 = True
		updateCount += 1
	EndIf
	
; v1.5.0
;-------
	If (DMN_iSkyshardsVersionInstalled.GetValue() as Int < ver3ToInteger("1", "5", "0") && \
		DMN_iSkyshardsVersionRunning >= 1500)
		v1_5_0 = True
		updateCount += 1
	EndIf

; v1.6.0
;-------
	If (DMN_iSkyshardsVersionInstalled.GetValue() as Int < ver3ToInteger("1", "6", "0") && \
		DMN_iSkyshardsVersionRunning >= 1600)
		v1_6_0 = True
		updateCount += 1
	EndIf
	
	If (updateCount > 1)
	; Detected more than one update happening on this user's save.
	; Give them the choice to display all updates or only the latest.
		Int updateAnnouncement = DMN_SkyshardsUpdateAnnouncementHandler.Show()
	; Show all update announcements.
		If (updateAnnouncement == 0)
			If (v1_1_0)
				Wait(1.0)
				DMN_SkyshardsUpdateAnnouncement_v1_1_0.Show()
			EndIf
			If (v1_2_0)
				Wait(1.0)
				DMN_SkyshardsUpdateAnnouncement_v1_2_0.Show()
			EndIf
			If (v1_3_0)
				Wait(1.0)
				DMN_SkyshardsUpdateAnnouncement_v1_3_0.Show()
			EndIf
			If (v1_4_0)
				Wait(1.0)
				DMN_SkyshardsUpdateAnnouncement_v1_4_0.Show()
			EndIf
			If (v1_5_0)
				Wait(1.0)
				DMN_SkyshardsUpdateAnnouncement_v1_5_0.Show()
			EndIf
			If (v1_6_0)
				Wait(1.0)
				DMN_SkyshardsUpdateAnnouncement_v1_6_0.Show()
			EndIf
	; Show only the latest update announcement.
		ElseIf (updateAnnouncement == 1)
			Wait(1.0)
			latestUpdate.Show()
		EndIf
	ElseIf (updateCount == 1)
	; Detected a single update, we assume it will be the latest one.
	; Display the latest update announcement message.
		Wait(1.0)
		latestUpdate.Show()
	EndIf

	; // END VERSION SPECIFIC ANNOUNCEMENT MESSAGES
	;------------------------------------------------

; Updates the user's installed Skyshards version to this running version of Skyshards.
	DMN_iSkyshardsVersionInstalled.SetValue(DMN_iSkyshardsVersionRunning as Int) ; Integer.
	DMN_sSkyshardsVersionInstalled = DMN_sSkyshardsVersionRunning ; String.

	Wait(0.1)
	Notification("Skyshards: You are now running version " + DMN_sSkyshardsVersionInstalled + ". Enjoy!")
	Notification("Skyshards: It is now safe to save your game to finalise the update!")

; //Debug - Check if Skyshards passes the update function.
	debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Checkpoint - Update Function Passed.")
EndFunction

Function configurationDefaults()
; Add (or update) the mod configurator to the player inventory silently.
; Runs once per install or update.
	giveConfigurator(DMN_SkyshardsConfigurator)
; Update the installed configurator version for future comparisons.
	DMN_iSkyshardsConfiguratorVersionInstalled = skyshardsVersion
	debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Gave the player the latest Skyshards Configurator!")

; Disable the Skyshard map markers if players have not previously chosen to display them.
	If (DMN_SkyshardsShowMapMarkers.GetValue() != 1)
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Disabling Skyshard map markers...")
		showSkyshardMapMarkers(DMN_SkyshardsMapMarkersList, False)
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Skyshard map markers have been disabled!")
	EndIf
EndFunction

Function checkConfigurator()
; Check to see if the player has a configurator in their inventory.
	If (!hasConfigurator(DMN_SkyshardsConfigurator))
	; If they don't, give them one.
		giveConfigurator(DMN_SkyshardsConfigurator)
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Did not " + \
		"detect a configurator. Gave the player a new one.")
	EndIf

; Check to see if the mod configurator given to the player matches the Skyshards
; script version running. This is done to ensure any newly added properties to
; the configurator are accessible.
	If (skyshardsConfiguratorVersion != skyshardsVersion)
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Detected " + \
		"an older version of the configurator! Replacing it with the " + \
		"latest one...")
	; If the configurator is outdated, give the player a new one.
		updateConfigurator(skyshardsVersion, skyshardsConfiguratorVersion, \
		DMN_SkyshardsConfigurator, DMN_SkyshardsDebug)
	; Then update the installed configurator version for future comparisons.
		DMN_iSkyshardsConfiguratorVersionInstalled = skyshardsVersion
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: The " + \
		"configurator was updated to the latest version!")
	ElseIf (skyshardsConfiguratorVersion == skyshardsVersion)
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: The " + \
		"configurator is up to date.")
	EndIf
EndFunction