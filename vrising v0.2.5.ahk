; ---------------------------------------------------------------------------
; V RISING TPS CAMERA FOLLOW SCRIPT V0.25
; IT'S NOT PERFECT
; USE WITH BEPINEX MODERN CAMERA MOD TO ENJOY FULL POTENTIAL OF TPS VIEW
; F12 TO EXIT BY DEFAULT
; -----------------------------------------------------------------------------
;  !! 				NEEDED TO BE DONE BEFORE USE 							!!
;  !! 				CONFIGURE KEY BINDING BELOW  							!!
;  !! 				EVERYTHING IS CASE SENSITIVE 							!!
;  !!   				RESPECT THE CASE OR DIE   								!!
;  !! 		FOR THE SCRIPT TO WORK AS EXPECTED, YOU NEED TO  		!!
;	!! 		OPEN AND QUIT MENUS WITH MENU KEY ( NO ESC KEY, 		!! 
;  !! 		NO PLAYER MOVING AWAY FROM CHEST, SERVANTS, ETC ... )	!!
;  !!       PRESSING INTERACT KEY MORE THAN HALF SECOND WILL 		!!
;	!!			BRING CURSOR BACK, PRESSING QUICKLY INTERACT KEY 		!!
;	!!			AGAIN WILl BRING TPS VIEW LOCK BACK, USEFULL FOR		!!
;	!!			CHEST OPENING, SERVANTS... AGAINST DOORS					!!
;	!!																					!!
; -----------------------------------------------------------------------------

; ==========================================================================
; KEYS CONFIGURATION 

; CHANGE CAMERAFOLLOWKEY VALUE ACCORDING TO THE ROTATE CAMERA KEY SET IN VRISING
; EXAMPLE IF YOU BIND F TO ROTATE CAMERA IN VRISING, REPLACE ² WITH f ( lower case )

InGameCameraFollowKey=²					; <-------- !!! NEEDED CONFIGURE THIS  !!!

; CHANGE ALL MENUS KEY, REPLACE WITH MENUS KEYS SET IN VRISING 
; EXAMPLE IF YOU USE B FOR BUILD MENU, REPLACE c WITH b in line InGameBuildMenuKey=c

InGameCharacterMenuKey=b				; <-------- !!! NEEDED CONFIGURE THIS  !!!
InGameBuildMenuKey=c					; <-------- !!! NEEDED CONFIGURE THIS  !!!
InGameMapMenuKey=,					; <-------- !!! NEEDED CONFIGURE THIS  !!!
InGameSocialMenuKey=p					; <-------- !!! NEEDED CONFIGURE THIS  !!!
InGameSpellbookMenuKey=j				; <-------- !!! NEEDED CONFIGURE THIS  !!!
InGameVampirePowersMenuKey=g				; <-------- !!! NEEDED CONFIGURE THIS  !!!
InGameVBloodMenuKey=k					; <-------- !!! NEEDED CONFIGURE THIS  !!!

; BUTTON TO ACTIVATE TPS VIEW FOLLOW 
; MIDDLE MOUSE BUTTON BY DEFAULT ( MButton )
; EXAMPLE IF YOU WANT TO USE C , REPLACE LINE WITH CameraManualSwitchKey=c
; !!! SHOULD NOT BE BOUND IN VRISING SETTINGS !!!

CameraManualSwitchKey=MButton				; <-------- !!! NEEDED CONFIGURE THIS  !!!

; INTERACT KEY, REPLACE WITH INTERACT KEY SET IN VRISING 
; BEACUSE INTERACT IS USE WITH DIFFERENT BEHAVIOUR IN GAME ( OPNENING CHEST, DOORS ... )
; YOU CAN KEEP THE KEY PRESSED TO ACTIVATE CURSOR, TPS MODE WILL COME BACK WHEN PRESSING QUICK KEY BACK AGAIN
; USEFUL TO BRING CURSOR FOR OPENING CHEST, SERVANTS, MERCHANTS ... ( KEEP PRESSED ) 
; AND KEEP TPS VIEW WITH DOORS ( QUICKLY PRESS )

InGameInteractKey=x 					; <-------- !!! NEEDED CONFIGURE THIS  !!!			

; ACTION WHEEL KEY, REPLACE WITH ACTION WHEEL KEY SET IN VRISING 

InGameActionWheelKey=Tab				; <-------- !!! NEEDED CONFIGURE THIS  !!!

; SPELL KEYS BOUND IN VIRISING

FirstSpellKey=a					; <-------- !!! NEEDED CONFIGURE THIS  !!!
SecondSpellKey=z					; <-------- !!! NEEDED CONFIGURE THIS  !!!
UltimateSpellKey=e				; <-------- !!! NEEDED CONFIGURE THIS  !!!

; VERTICAL POSITION OF MOUSE CURSOR ON SCREEN WHEN TPS VIEW ACTIVE
; 0=TOP OF SCREEN, 1=BOTTOM, 0.35=DEFAULT, 0.6=PLAYER FEETS, USUALLY DONT GO UPPER THAN 0.45

CursorScreenYPositionn=0.35			; <-------- CONFIGURE THIS OPTIONAL

; F10 TO SWITCH BETWEEN SPELL CASTING MODES ( FRONT MODE/FREE MODE )

SpellModeKey=F10						; <-------- CONFIGURE THIS OPTIONAL

; F9 KEY TO ACTIATE/DESACTIVATE , F12 TO QUIT 

ActivateKey=F9						; <-------- CONFIGURE THIS OPTIONAL
QuitKey=F12							; <-------- CONFIGURE THIS OPTIONAL

; DONE !
; ==================================================================================
; ==================================================================================

#UseHook					; need for bypassing key input and output
#SingleInstance				; one instance
;#IfWinActive VRising 

global cameraFollowKey := InGameCameraFollowKey        
global scriptActive := 0
global tpsMode := 0
global cameraFollow := 0
global previousKeyUsed := "Nulle"
global previousKeyUsedNull := "Nulle"
global gameMenuOpen := 0
global mouseX := 0		
global mouseY := 0
global debug := 0
global pushTimeToSwitch := 400
global pushLastSwitch := 0
global cursorScreenYPos := CursorScreenYPositionn
global spellMode := 0

Hotkey,*%InGameCharacterMenuKey%,IGCharacterMenu
Hotkey,*%InGameBuildMenuKey%,IGBuildMenu
Hotkey,*%InGameMapMenuKey%,IGMapMenu
Hotkey,*%InGameSocialMenuKey%,IGSocialMenu
Hotkey,*%InGameSpellbookMenuKey%,IGSpellbookMenu
Hotkey,*%InGameVampirePowersMenuKey%,IGVampirePowersMenu
Hotkey,*%InGameVBloodMenuKey%,IGVBloodMenu
Hotkey,*%CameraManualSwitchKey%,CameraManualSwitchLabel
Hotkey,*%InGameInteractKey%,InGameInteract
Hotkey,*%InGameActionWheelKey%,ActionWheelLabel
Hotkey,*%ActivateKey%,ActivateScript
Hotkey,*%QuitKey%,QuitScript
Hotkey,*%FirstSpellKey%,FirstSpellLabel
Hotkey,*%SecondSpellKey%,SecondSpellLabel
Hotkey,*%UltimateSpellKey%,UltimateSpellLabel
Hotkey,*%SpellModeKey%,SwitchSpellModeLabel

; ======================================= DEFINITIONS =======================================

ResetPreviousKeyUsed() {
	previousKeyUsed := previousKeyUsedNull
}

SwitchSpellMode() {
	spellMode := !spellMode
	if ( debug ) { 
		ToolTip, Spell Mode : %spellMode%, 10, 70, 4
	}
}

SpellFunc( hotkey ) {
	if ( scriptActive && tpsMode ) {
		;MsgBox, (%hotkey% start)
		if ( spellMode ) {
			ForceCursor( )
			;MouseMove, A_ScreenWidth*0.5, A_ScreenHeight*cursorScreenYPos, 0 
		}
		SendInput {%hotkey% down}
		While, GetKeyState(hotkey, "P") 		
		{
			Sleep, 5
		}
		SendInput {%hotkey% up}
		Sleep, 5
		if ( spellMode ) {
			ForceCameraFollow( )
		}		
		
	}
}

CameraSwitch() {
	if ( scriptActive ) {
		cameraFollow := !cameraFollow
		if cameraFollow {
			ForceCameraFollow()
		} else {
			ForceCursor( )
		}
	}
	return
}

ForceCameraFollow( ) {
	MouseGetPos, mouseX, mouseY
	MouseMove, A_ScreenWidth*0.5, A_ScreenHeight*cursorScreenYPos, 0
	ForceOnlyCameraFollow()
}

ForceOnlyCameraFollow( ) {
	if ( debug ) { 
		ToolTip, Camera ON, 10, 40, 2
	}
	cameraFollow := 1
	SendInput {%cameraFollowKey% down}
}

ForceCursor( ) {
	if ( debug ) { 
		ToolTip, Camera OFF, 10, 40, 2
	}
	cameraFollow := 0
	SendInput {%cameraFollowKey% up}
	;MouseMove, mouseX, mouseY, 0
}

CameraSwitchState( state ) {
	if ( scriptActive ) {
		; Switch Camera follow if different from state given
		if ( state != cameraFollow ) {
			CameraSwitch()
		}
	}
	return
}

CameraSwitchKey( hotKey ) {
	ResetPushLastSwitch()
	Send {%hotKey% down}
		
	if ( scriptActive ) {
		; Return to game
		if ( previousKeyUsed == hotKey ) {
			CameraSwitchState( tpsMode )
			ResetPreviousKeyUsed()
			gameMenuOpen := 0
		} 
		; Open menu or switch to another menu
		else {
			; Press ESC key
			if ( hotKey == "Esc" ) {
				; Was in game
				if ( !gameMenuOpen ) {
					CameraSwitchState( 0 )
					previousKeyUsed := hotkey
					gameMenuOpen := 1
				}
				; Was in a menu
				else {
					CameraSwitchState( tpsMode )
					ResetPreviousKeyUsed()
					gameMenuOpen := 0
				}
			; Press another menu key
			} else {
				CameraSwitchState( 0 )
				previousKeyUsed := hotkey
				gameMenuOpen := 1
			}
		}
	}
	While, GetKeyState(hotKey, "P") {
		Sleep, 5
	}
	Send {%hotKey% up}
	return
}

CameraManualSwitch() {
	if ( scriptActive ) {
		tpsMode := !tpsMode
		ShowTPS()
		CameraSwitchState( tpsMode )
		if ( tpsMode ) {
			ResetPreviousKeyUsed()
		} else {
			ResetPushLastSwitch()
		}
	}
}

KeepPressMenu( hotKey ) {
	ResetPushLastSwitch()	
	if ( scriptActive ) {
		CameraSwitchState( 0 )
	}
	Send {%hotKey% down}		
	While, GetKeyState(hotKey, "P") 		
	{
		Sleep, 5
	}
	Send {%hotKey% up}					
	if ( scriptActive ) {
		CameraSwitchState( tpsMode )
	}
}

ResetPushLastSwitch() {
	pushLastSwitch = 0	
}

Interact( hotkey ) {
	startTime := HR_TickCount()
	pushEnoughToTrigger := 0
	Send, {%hotkey% down}				
	While, GetKeyState(hotkey, "P") 		
	{
		Sleep, 5
		if ( scriptActive ) {
			deltaTime := HR_TickCount()-startTime
			if ( tpsMode && cameraFollow && deltaTime > pushTimeToSwitch ) {
				CameraSwitchState( 0 )
				pushEnoughToTrigger = 1
			}
		}
	}
	if ( pushLastSwitch ) {
		if ( !pushEnoughToTrigger ) {
			CameraSwitchState( 1 )
		}
	} else if ( pushEnoughToTrigger ) {
		pushLastSwitch = 1 
	}
	Send, {%hotkey% up}
}

ScriptRunSwitch() {
	;ACTIVATE SCRIPT
	if ( !scriptActive ) {
		scriptActive := 1
		cameraFollow := 0
		tpsMode := 1
		ResetPreviousKeyUsed()
		gameMenuOpen := 0
		pushLastSwitch := 0
		CameraSwitchState( tpsMode )
		Tooltip, Script ON, 10, 10, 1
		ShowTPS()
	}
	;DESACTIVATE SCRIPT
	else {
		CameraSwitchState( 0 )
		scriptActive := 0
		tpsMode := 0
		ToolTip, , , , 2
		ToolTip, , , , 3
		ToolTip, Script OFF, 10, 10, 1
	}
}

ShowTPS() {
	if tpsMode
		ToolTip, TPS ON, 80, 10, 3
	else 
		ToolTip, TPS OFF, 80, 10, 3	
}

Byebye() {
	SendInput {%cameraFollowKey% up}
	ExitApp
}

; ==================================================================================================
; High resolution replacement for A_TickCount
; Returns the number of microseconds that have elapsed since the system was started.
; docs.microsoft.com/en-us/windows/win32/api/profileapi/nf-profileapi-queryperformancecounter
; ==================================================================================================
HR_TickCount() {
   Static F, C := DllCall("QueryPerformanceFrequency", "Int64P", F)
   Return (DllCall("QueryPerformanceCounter", "Int64P", C) ? C * 1000 // F : 0)
}

; ============================= EXECUTIVE CODE ============================

Msgbox,
(
			    VRISING TPS CAMERA SCRIPT V0.25

			! BEFORE USE !
 CONFIGURE KEYS IN SCRIPT BY EDITING FILE WITH NOTEPAD

  PRESS F9 BY DEFAULT TO ACTIVATE/DESACTIVATE THE SCRIPT
 ALWAYS ACTIVATE THE SCRIPT FROM IN GAME, NO MENUS OPEN

 	F10 TO SWITCH BETWEEN SPELL CASTING MODE
 		FRONT MODE (DEFAULT) OR FREE MODE

		PRESS F12 BY DEFAULT TO EXIT THE SCRIPT

)
return


*Esc::CameraSwitchKey( "Esc" )		; <-------- !! DO NOT CHANGE !!

IGCharacterMenu:
CameraSwitchKey( InGameCharacterMenuKey )
Return

IGBuildMenu:
CameraSwitchKey( InGameBuildMenuKey )
Return

IGMapMenu:
CameraSwitchKey( InGameMapMenuKey )
Return

IGSocialMenu:
CameraSwitchKey( InGameSocialMenuKey )
Return

IGSpellbookMenu:
CameraSwitchKey( InGameSpellbookMenuKey )
Return

IGVampirePowersMenu:
CameraSwitchKey( InGameVampirePowersMenuKey )
Return

IGVBloodMenu:
CameraSwitchKey( InGameVBloodMenuKey )
Return

CameraManualSwitchLabel:
CameraManualSwitch()
Return

InGameInteract:
Interact( InGameInteractKey )
Return

ActionWheelLabel:
KeepPressMenu( InGameActionWheelKey )
Return

ActivateScript:
ScriptRunSwitch()
Return

QuitScript:
Byebye()
Return

FirstSpellLabel:
SpellFunc( FirstSpellKey )
Return

SecondSpellLabel:
SpellFunc( SecondSpellKey )
Return

UltimateSpellLabel:
SpellFunc( UltimateSpellKey )
Return

SwitchSpellModeLabel:
SwitchSpellMode()
Return