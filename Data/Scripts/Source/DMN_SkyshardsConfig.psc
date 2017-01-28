ScriptName DMN_SkyshardsConfig Extends Quest

{Skyshards - Configuration Script by Deadmano.}
;==============================================
; Version: 1.0.0
;===============

Import DMN_DeadmaniacFunctions
Import Debug
Import Game
Import StringUtil
Import Utility

GlobalVariable Property DMN_SkyshardsDebug Auto
{Set to the debug global variable.}

; User's Installed Script Version.
String Property DMN_SkyshardsVersionInstalled Auto 
{Do not fill in manually, the script will do so.}

; Current Script Version Being Run.
String DMN_SkyshardsVersionRunning

; Update Related Variables and Properties
; =======================================

; Introduced in v1.0.1.
Message Property DMN_SkyshardsSkyshardActivationFPFOVBug Auto

;============================================================

Event OnInit()
    Maintenance() ; Function to handle script maintenance.
EndEvent
 
Function Maintenance()

; The latest (current) version of Skyshards. Update this to the version number.
	DMN_SkyshardsVersionRunning = "1.0.0" ; <--- CHANGE! Can't go over 9.9.9.
	; -----------------------UPDATE!^^^ 
	
	If (DMN_SkyshardsDebug.GetValue() == 1)
		If DMN_SkyshardsVersionInstalled
			Wait(0.1)
			Notification("Skyshards DEBUG: An existing install of Skyshards was detected on this save!")
			Notification("Skyshards DEBUG: This save is referencing version " + DMN_SkyshardsVersionInstalled + " of Skyshards.")
			Notification("Skyshards DEBUG: You are using Skyshards' version " + DMN_SkyshardsVersionRunning + " configuration script.")
		EndIf
	EndIf

; Check to see if the user's installed Skyshards version is less than this running version of Skyshards.
	If (strVer3ToInt(DMN_SkyshardsVersionInstalled) < strVer3ToInt(DMN_SkyshardsVersionRunning))

	; //Debug - Check if Skyshards reaches the update check.
		If (DMN_SkyshardsDebug.GetValue() == 1)
			Wait(0.1)
			Notification("Skyshards DEBUG: Checkpoint - Update Check Reached.")
		EndIf
	
	; If it is then we need to run the update on it.
		updateSkyshards()

; Check to see if the user is loading a save with an existing Skyshards install but is using older Skyshards scripts than those saved with.
	ElseIf (strVer3ToInt(DMN_SkyshardsVersionInstalled) > strVer3ToInt(DMN_SkyshardsVersionRunning))
		Wait(0.1)
		MessageBox("Skyshards has detected that you are using one or more outdated scripts than those used when this save was created. This is just a warning and you may continue to play with unknown side-effects; though for best results it is advised that you update to the latest version.")

; Check to see if the user's installed Skyshards version matches this running version of Skyshards.
	ElseIf (strVer3ToInt(DMN_SkyshardsVersionInstalled) == strVer3ToInt(DMN_SkyshardsVersionRunning))
	
	; //Debug - Check if Skyshards reaches the versions match check.
		If (DMN_SkyshardsDebug.GetValue() == 1)
			Wait(0.1)
			Notification("Skyshards DEBUG: Checkpoint - Versions Match Check Reached.")
		EndIf
	
; Code for if the versions match. Nothing needs to be done, for now.

; No idea how the user got here, but good to grab just in case!
	Else
		Wait(0.1)
		MessageBox("WARNING: The version of Skyshards cannot be detected! Please inform Deadmano.")
	EndIf

EndFunction

; UPDATE FUNCTION
;----------------

Function updateSkyshards()

; //Debug - Check if Skyshards reaches the update function.
	If (DMN_SkyshardsDebug.GetValue() == 1)
		Wait(0.1)
		Notification("Skyshards DEBUG: Checkpoint - Update Function Reached.")
	EndIf

	If (strVer3ToInt(DMN_SkyshardsVersionInstalled) < strVer3ToInt("1.0.0"))
		Wait(0.1)
		Notification("Skyshards: Installation and configuration in progress.")
	Else
		Wait(0.1)
		Notification("Skyshards: Updating from version " + DMN_SkyshardsVersionInstalled + ".")
	EndIf

	
	; // BEGIN UPDATE FOR CURRENT SCRIPT VERSION
	;-------------------------------------------
	
	; Begin v1.0.1 Updates
	;=====================

; Fix player controls that were stuck in 1st-person due to a bug in Skyshards v1.0.0.
	;If DMN_SkyshardsVersionInstalled < "1.0.1"
	If (strVer3ToInt(DMN_SkyshardsVersionInstalled) < strVer3ToInt("1.0.1"))
	EnablePlayerControls()
	DMN_SkyshardsSkyshardActivationFPFOVBug.Show()
	EndIf
	
	; End v1.0.1 Updates
	;=====================

	; // END UPDATE FOR CURRENT SCRIPT VERSION
	;-------------------------------------------
	
; Updates the user's installed Skyshards version to this running version of Skyshards.
	DMN_SkyshardsVersionInstalled = DMN_SkyshardsVersionRunning 
	Wait(5.0)
	Notification("Skyshards: You are now running version " + DMN_SkyshardsVersionInstalled + ". Enjoy!")
	
; //Debug - Check if Skyshards passes the update function.
	If (DMN_SkyshardsDebug.GetValue() == 1)
		Wait(0.1)
		Notification("Skyshards DEBUG: Checkpoint - Update Function Passed.")
	EndIf
	
EndFunction