ScriptName DMN_SkyshardsTracker Extends ObjectReference
{Handles the tracking of Skyshards across Skyrim + DLCs/Mods.}

Import Game
Import Debug
Import Quest
Import Utility

;ObjectReference[] Property skyshardsArray Auto

FormList Property DMN_SkyshardsAbsorbedList Auto

; TO DO: Add option for uninstallation to remove things
; like FormLists!

Event OnRead()
	;isSkyshardActivated(DMN_SkyshardsAbsorbedList)
	If (strVer3ToInt("1", "2", "7") > strVer3ToInt("9", "0", "0"))
	Notification("We are running a greater version!")
	Else
	Notification("We are running an older version!")
	EndIf
	;strVer3ToInt("1", "0", "1")
EndEvent

Function isSkyshardActivated(FormList Skyshards)

	Int iIndex = Skyshards.GetSize() ; Indices are offset by 1 relative to size
	Int iAmountActivated = 0
	While iIndex
		iIndex -= 1
		;ObjectReference SkyshardTest = Skyshards.GetAt(iIndex) As ObjectReference ; Note that you must typecast the entry from the formlist using 'As'.
		Notification("Form " + iIndex + " is " + Skyshards.GetAt(iIndex))
		Trace("Form " + iIndex + " is " + Skyshards.GetAt(iIndex))
		;If SkyshardTest.IsDisabled()
		;	iAmountActivated += 1
		;	Notification("The Skyshard " + Skyshards.GetAt(0) + "] is disabled!")
		;	Notification(iAmountActivated)
		;Else ; If Skyshard.IsEnabled() 
		;	Notification("The Skyshard " + SkyshardTest + " is enabled!")
		;EndIf
	EndWhile

EndFunction

Int Function strVer3ToInt(String sMajorVer, String sMinorVer, String sReleaseVer)

	Int iMajorVer = sMajorVer as Int
	Int iMinorVer = sMinorVer as Int
	Int iReleaseVer = sReleaseVer as Int
	
	Int iVersion = (iMajorVer * 100) + (iMinorVer * 10) + iReleaseVer
	;Notification(iMajorVer + "." + iMinorVer + "." + iReleaseVer)
	Return iVersion

EndFunction
