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

ScriptName DMN_SkyshardsAbsorbAnimation Extends ObjectReference  
{Adds an animation sequence to the Skyshard activation.}
; Credit goes to Dragon Soul Absorb More Glorious (DSAMG) for the ritual
; animation script.

Import Debug
Import Game
Import Utility
Import DMN_DeadmaniacFunctions

DMN_SkyshardsConfig Property DMN_SC Auto
{Set to the updater quest to access the properties on it.}

Actor Property PlayerREF Auto
{The player reference we will be checking for. Auto-Fill}
EffectShader Property DMN_SkyshardsAbsorbingFX Auto
{The absorbing visual effect added to the player during animation. Auto-Fill.}
Sound Property DMN_SkyshardsAbsorbSM Auto
{The sound played during the absorb animation. Auto-Fill.}
VisualEffect Property DMN_SkyshardsAbsorbedVFX Auto
{The blue aura added to the player during animation. Auto-Fill.}

Bool isAnimationPlaying

Event OnActivate(ObjectReference AbsorbActor)
; Ignore any further activation attempts on the same Skyshard.
	If (isAnimationPlaying)
		Return
	EndIf

; Mark this Skyshard as being absorbed using IgnoreFriendlyHits.
	Self.IgnoreFriendlyHits(True)

	If (AbsorbActor == PlayerREF)
		Int godMode =  DMN_SC.DMN_SkyshardsPersistGodMode.GetValue() as Int
		isAnimationPlaying = True
	; Disable any combat the player may be in as well as their movement.
		disableControl("fighting")
		disableControl("movement")
	; Enable god mode during the animation sequence, if god mode is not enabled.
		If (godMode == 0)
			SetGodMode(True)
		EndIf
	; Play the absorbing sound.
		DMN_SkyshardsAbsorbSM.Play(Self)
	; Play the absorbing animation sequences.
		SendAnimationEvent(AbsorbActor, "RitualSpellStart")
	; Adds a blue aura around the player to signify the absorption.
		DMN_SkyshardsAbsorbedVFX.Play(AbsorbActor)
	; Adds an absorbing visual effect on the player.
		DMN_SkyshardsAbsorbingFX.Play(AbsorbActor)
		Wait(2.6)
		SendAnimationEvent(AbsorbActor, "MLh_SpellReady_event")
		Wait(2.5)
		SendAnimationEvent(AbsorbActor, "Ritualspellout")
	; Disable the skyshard activator with a fade-out.
		Disable(True)
	; Resume any combat the player may be in and enable their movement.
		disableControl("movement", False)
		disableControl("fighting", False)
	; Disable the skyshard beacon with a fade-out.
		GetLinkedRef().Disable(True)
	; Stops the visual effect and shader on the player and ends the animation.
		DMN_SkyshardsAbsorbingFX.Stop(AbsorbActor)
		DMN_SkyshardsAbsorbedVFX.Stop(AbsorbActor)
	; Disable god mode if it wasn't enabled by the player manually.
		If (godMode == 0)
			SetGodMode(False)
		EndIf
		Notification("I feel the power of the Skyshard coursing through me " \
		+ "as I absorb it!")
	; We can now clean up this Skyshard as absorption is complete.
		Self.IgnoreFriendlyHits(False)
		isAnimationPlaying = False
	EndIf
EndEvent
