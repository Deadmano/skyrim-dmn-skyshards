ScriptName DMN_SkyshardsConfig Extends Quest

{Skyshards - Configuration Script by Deadmano.}
;==============================================
; Version: 1.0.0
;===============

Import DMN_DeadmaniacFunctions
Import Debug
Import Game
Import Utility

GlobalVariable Property DMN_SkyshardsDebug Auto
{Set to the debug global variable.}

; User's Installed Script Version as an Integer.
Int Property DMN_iSkyshardsVersionInstalled Auto 
{Do not fill in manually, the script will do so.}
; User's Installed Script Version as a string.
String Property DMN_sSkyshardsVersionInstalled Auto 
{Do not fill in manually, the script will do so.}

; Current Script Version Being Run.
Int DMN_iSkyshardsVersionRunning
String DMN_sSkyshardsVersionRunning

; Update Related Variables and Properties
; =======================================

;========================================

Event OnInit()
    Maintenance() ; Function to handle script maintenance.
EndEvent
 
Function Maintenance()
; The latest (current) version of Skyshards. Update this to the version number.
	parseSkyshardsVersion("1", "0", "0") ; <--- CHANGE! No more than: "infinite", "99", "9".
; ---------------- UPDATE! ^^^^^^^^^^^
	If (DMN_SkyshardsDebug.GetValue() == 1)
		If DMN_sSkyshardsVersionInstalled
			Wait(0.1)
			Notification("Skyshards DEBUG: An existing install of Skyshards was detected on this save!")
			Notification("Skyshards DEBUG: This save is referencing version " + DMN_sSkyshardsVersionInstalled + " of Skyshards' configuration script.")
			Notification("Skyshards DEBUG: You are running Skyshards' version " + DMN_sSkyshardsVersionRunning + " configuration script.")
		EndIf
	EndIf

; Check to see if the user's installed Skyshards version is less than this running version of Skyshards.
	If (DMN_iSkyshardsVersionInstalled < DMN_iSkyshardsVersionRunning)

	; //Debug - Check if Skyshards reaches the update check.
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Checkpoint - Update Check Reached.")
	
	; If it is then we need to run the update on it.
		updateSkyshards()

; Check to see if the user is loading a save with an existing Skyshards install but is using older Skyshards scripts than those saved with.
	ElseIf (DMN_iSkyshardsVersionInstalled > DMN_iSkyshardsVersionRunning)
		Wait(0.1)
		MessageBox("Skyshards has detected that you are using one or more outdated scripts than those used when this save was created. This is just a warning and you may continue to play with unknown side-effects; though for best results it is advised that you update to the latest version.")

; Check to see if the user's installed Skyshards version matches this running version of Skyshards.
	ElseIf (DMN_iSkyshardsVersionInstalled == DMN_iSkyshardsVersionRunning)
	
	; //Debug - Check if Skyshards reaches the versions match check.
		debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Checkpoint - Versions Match Check Reached.")
		debugNotification(DMN_SkyshardsDebug, "Skyshard String: " + DMN_sSkyshardsVersionRunning)
		debugNotification(DMN_SkyshardsDebug, "Skyshard Integer: " + DMN_iSkyshardsVersionRunning)

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

Function updateSkyshards()
; //Debug - Check if Skyshards reaches the update function.
	debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Checkpoint - Update Function Reached.")

	If (DMN_iSkyshardsVersionInstalled < ver3ToInteger("1", "0", "0"))
		Wait(0.1)
		Notification("Skyshards: Installation and configuration in progress.")
	Else
		Wait(0.1)
		Notification("Skyshards: Updating from version " + DMN_sSkyshardsVersionInstalled + ".")
	EndIf

	
	; // BEGIN UPDATE FOR CURRENT SCRIPT VERSION
	;-------------------------------------------
	

	; // END UPDATE FOR CURRENT SCRIPT VERSION
	;-------------------------------------------
	
; Updates the user's installed Skyshards version to this running version of Skyshards.
	DMN_iSkyshardsVersionInstalled = DMN_iSkyshardsVersionRunning ; Integer.
	DMN_sSkyshardsVersionInstalled = DMN_sSkyshardsVersionRunning ; String.
	
	Wait(5.0)
	Notification("Skyshards: You are now running version " + DMN_sSkyshardsVersionInstalled + ". Enjoy!")
	
; //Debug - Check if Skyshards passes the update function.
	debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: Checkpoint - Update Function Passed.")
EndFunction
