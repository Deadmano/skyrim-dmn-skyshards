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

ScriptName DMN_SkyshardsAbsorbAnimation Extends ObjectReference  
{Adds an animation sequence to the Skyshard activaton.}
; Credit goes to Dragon Soul Absorb More Glorious (DSAMG) for the ritual animation script.

Import Debug
Import Game
Import Utility

Actor Property PlayerREF Auto
EffectShader Property DMN_SkyshardsAbsorbingFX Auto
{Auto-Fill.}
VisualEffect Property DMN_SkyshardsAbsorbedVFX Auto
{Auto-Fill.}

Event OnActivate(ObjectReference AbsorbActor)
	If (AbsorbActor == PlayerREF)
	; Adds a blue aura around the player to signify the absorption.
		DMN_SkyshardsAbsorbedVFX.Play(AbsorbActor)
	; Plays the absorbing visual effect on the player.
		DMN_SkyshardsAbsorbingFX.Play(AbsorbActor)
		DisablePlayerControls(1,1,1,0,1,1,1,1,0) ; 1 = enabled, 0 = disabled: Movement, Combat, POV Switch, Looking, Sneaking, Menu, Activation, Journal Tabs, DisablePOVType (0 = Script).
		SetGodMode(True)
		SendAnimationEvent(AbsorbActor, "RitualSpellStart")
		Wait(2.0)
	EndIf

	If (AbsorbActor == PlayerREF)
		Wait(1.0)
		SendAnimationEvent(AbsorbActor, "MLh_SpellReady_event")
		Wait(2.0)
	EndIf

	If (AbsorbActor == PlayerREF)
	; Stops the visual effect and shader on the player.	
		DMN_SkyshardsAbsorbingFX.Stop(AbsorbActor)
		DMN_SkyshardsAbsorbedVFX.Stop(AbsorbActor)
		SendAnimationEvent(AbsorbActor, "Ritualspellout")
		SetGodMode(False)
		EnablePlayerControls()
		Notification("I feel the power of the Skyshard coursing through me as I absorb it!")
	EndIf
EndEvent
