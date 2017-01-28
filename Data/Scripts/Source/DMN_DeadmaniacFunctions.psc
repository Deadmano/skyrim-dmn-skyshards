ScriptName DMN_DeadmaniacFunctions

{A custom collection of functions by Deadmano
to enhance Papyrus scripting.}
;==============================================
; Version: 0.0.1
; Updated: 2017/01/17
;--------------------
; HISTORY:
;====================
; 2017/01/28:
;	*Added debugNotification.
; 2017/01/17:
; 	*Added StrVer3ToInt.
;--------------------
; FUNCTIONS:
;	-[debugNotification]: Takes a [GlobalVariable] which handles if the debug notifcations are shown and a [String] that displays the notification message.
; 	-[StrVer3ToInt]: Takes a [string] in the format of Major/Minor/Release versioning (x.x.x) (direct or variable) and outputs it into a plain number [integer].
;===============

Import StringUtil
Import Debug

; StrVer3ToInt: Takes the provided string input in Major/Minor/Release versioning format (x.x.x)
; and outputs it into a plain number integer for use in calculations to check for version differences.
;
; EXAMPLE USAGE: 
; String Property sVersionUsr Auto ; User's installed version.
; String sVersionCur = "1.2.1" ; Current script version.
; If (strVer3ToInt(sVersionUsr) < strVer3ToInt(sVersionCur)) ; Does direct integer comparison.
; 	sVersionUsr = sVersionCur ; Sets the user's script version to the current script version.
; EndIf
; Debug.Notification(sVersionUsr) ; OUTPUT: 121.

Int Function strVer3ToInt(String verStr) Global

	String majorVerStr = getNthChar(verStr, 0)
	String minorVerStr = getNthChar(verStr, 2)
	String releaseVerStr = getNthChar(verStr, 4)

	Int x1 = majorVerStr as Int
	Int y1 = minorVerStr as Int
	Int z1 = releaseVerStr as Int

	Int verInt = (x1 * 100) + (y1 * 10) + z1
	Return verInt

EndFunction

; debugNotification: Takes the provided GlobalVariable which decides if the provided String
; message is shown as a notification or not. It expects that your global variable is set to
; 1 for debug notifications to be shown. If the variable is 0 then no notifications are shown.
; 
; EXAMPLE USAGE: 
; GlobalVariable Property gDebugVariable Auto ; The global variable that handles your debug state.
; debugNotification(gDebugVariable, "This is my debug notification.") ; OUTPUT: This is my debug notification.

String Function debugNotification(GlobalVariable gDebugVariable, String sDebugMessage) Global
	If (gDebugVariable.GetValue() == 1)
		Notification(sDebugMessage)
	EndIf
EndFunction