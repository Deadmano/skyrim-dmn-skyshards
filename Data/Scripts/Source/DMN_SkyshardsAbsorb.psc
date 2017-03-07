ScriptName DMN_SkyshardsAbsorb Extends ObjectReference  
{Handles several things when a player absorbs a Skyshard;

*Absorption tracking across base game + DLCs/Mods.
*Perk handling.
*Activation blocking.
*Skyshard activator & beacon effect disabling.
}

Import DMN_DeadmaniacFunctions
Import Game
Import Debug
Import Utility

DMN_SkyshardsQuest Property DMN_SQ Auto

Actor Property PlayerRef Auto
{The player reference we will be checking for. Auto-Fill}

Static Property DMN_SkyshardActivated Auto
{Static version of the Skyshard, switched out when the player 
activates and absorbs a Skyshard. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsActivatedCounter Auto
{Set this to the ACTIVATED global variable to which DLC/Mod this Skyshard belongs to.
So DMN_SkyshardsSkyrimCountActivated will increment the Skyrim Skyshard counter.}

GlobalVariable Property DMN_SkyshardsCountCurrent Auto
{The current amount of Skyshards the player has activated throughout Skyrim and
other DLCs/Mods which resets once it reaches DMN_SkyshardsCountCap. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsCountCap Auto
{The amount of Skyshard absorptions required before gaining a perk point. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsPerkPoints Auto
{The amount of perk points awarded to the player after absorbing DMN_SkyshardsCountCap. Auto-Fill.}

Message Property DMN_SkyshardAbsorbedMessage Auto
{The message shown to the player as a notification when a Skyshard is absorbed. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsSkyrimCountActivated Auto
{Tracks Skyrim Skyshard activations. Set on Skyshard object if in Skyrim worldspace. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsDLC01CountActivated Auto
{Tracks DLC01 Skyshard activations. Set on Skyshard object if in DLC01 worldspace. Auto-Fill.}

GlobalVariable Property DMN_SkyshardsDebug Auto
{Set to the debug global variable. Auto-Fill.}

FormList Property DMN_SkyshardsAbsorbedList Auto

Auto State Absorbing
	Event OnActivate(ObjectReference WhoDaresTouchMe)
		If (WhoDaresTouchMe == PlayerRef)
			GotoState("KochBlock")

			DMN_SkyshardsCountCurrent.Mod(1 as Int)
			DMN_SkyshardsActivatedCounter.Mod(1 as Int)
			
			DMN_SkyshardsAbsorbedList.AddForm(Self)
			
		; Update the global variable values for the tracking quest.
			DMN_SQ.updateSkyshardsGlobals()
			DMN_SQ.updateSkyshardsQuestProgress()
			
		; Check if the Skyshard activated is from Skyrim.
			If (DMN_SkyshardsActivatedCounter == DMN_SkyshardsSkyrimCountActivated)

			;Debugger.
				debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: You activated a Skyrim Skyshard!")

			; Check if the Skyshards in Skyrim quest is running, and if it is not then start it.
				DMN_SQ.startSkyshardsSkyrim()
				Wait(2)

		; Check if the Skyshard activated is from DLC01 (Dawnguard).
			ElseIf (DMN_SkyshardsActivatedCounter == DMN_SkyshardsDLC01CountActivated)

			;Debugger.
				debugNotification(DMN_SkyshardsDebug, "Skyshards DEBUG: You activated a DLC01 Skyshard!")
				
			; Add DLC01 start quest here.
					Wait(2)
			EndIf

		; Show the abosrb message once we've allocated the Skyshard counters.
			DMN_SkyshardAbsorbedMessage.Show()

		; Check if we reach the specified Skyshards cap to gain perk points.
			If (DMN_SkyshardsCountCurrent.GetValue() as Int == DMN_SkyshardsCountCap.GetValue() as Int)
				AddPerkPoints(DMN_SkyshardsPerkPoints.GetValue() as Int)
				DMN_SkyshardsCountCurrent.SetValue(0 as Int)
			EndIf

			ObjectReference disabledSkyshardStatic = PlaceAtMe(DMN_SkyshardActivated, 1, True, True)
			disabledSkyshardStatic.EnableNoWait() ; Used to enable the Static Skyshard WITHOUT a fade-in.
			Wait(1)
			DisableNoWait() ; Disable the Skyshard Activator WITHOUT a fade-out.
			GetLinkedRef().Disable() ; Disable the Skyshard Beacon with a fade-out.
		EndIf
	EndEvent
EndState

State KochBlock
	Event OnActivate(ObjectReference WhoDaresTouchMe)
	; Empty state. Ensures we don't run our Absorbing state multiple times due to player triggers.
	EndEvent
EndState