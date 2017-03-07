ScriptName DMN_SkyshardsAbsorbAnimation Extends ObjectReference  
{Adds an animation sequence to the Skyshard activaton.}
; Credit goes to Dragon Soul Absorb More Glorious (DSAMG) for the ritual animation script.

Import Debug
Import Game
Import Utility

EffectShader Property DragonPowerAbsorbFXS Auto
{Auto-Fill.}
VisualEffect Property DragonAbsorbManEffect Auto
{Use DLC2MiraakAbsorbManE.}

Event OnActivate(ObjectReference AbsorbActor)
	If AbsorbActor == GetPlayer()
	; Adds the dragon soul absorption effect to the player.
		DragonAbsorbManEffect.Play(AbsorbActor)
	; Adds a blue aura around the player to signify the absorption.
		DragonPowerAbsorbFXS.Play(AbsorbActor)

		DisablePlayerControls(1,1,1,0,1,1,1,1,0) ; 1 = enabled, 0 = disabled: Movement, Combat, POV Switch, Looking, Sneaking, Menu, Activation, Journal Tabs, DisablePOVType (0 = Script).
		SetGodMode(True)
		SendAnimationEvent(AbsorbActor, "RitualSpellStart")
		Wait(2)
	EndIf

	If AbsorbActor == GetPlayer()
		Wait(1)
		SendAnimationEvent(AbsorbActor, "MLh_SpellReady_event")
		Wait(2)
	EndIf

	If AbsorbActor == GetPlayer()
	; Stop the visual effect and shader on the player.	
		DragonPowerAbsorbFXS.Stop(AbsorbActor)
		DragonAbsorbManEffect.Stop(AbsorbActor)

		SendAnimationEvent(AbsorbActor, "Ritualspellout")
		SetGodMode(False)
		EnablePlayerControls()
		Notification("I feel the power of the Skyshard coursing through me as I absorb it!")
	EndIf
EndEvent
