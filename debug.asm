;debug.asm

Char_STAR = $12

Debug_RLEText0:
	.db 1
	.db $20, Char_STAR
	.db " DEBUG MAP EDIT SCREEN "
	.db Char_STAR, $20
	.db 1, 0
Debug_RLEText1:
	.db 1
	.db "START "
	.db Char_STAR
	.db " EXIT SEL "
	.db Char_STAR
	.db "SPAWN BALL"
	.db 1, 0
Debug_RLEText2:
	.db 1
	.db  "A "
	.db Char_STAR 
	.db " REM"
	.db 1, 0
Debug_RLEText3:
	.db 1
	.db  "B "
	.db Char_STAR 
	.db " INS"
	.db 1, 0

Debug_StateMachine0:
	.db OPC_DrawSquare, $40, 32, 30
	.dw $2000
	
	.db OPC_Delay, 60
	
	.db OPC_DrawRLE
	.dw $2000, bg_Playfield
	
	.db OPC_DrawSquare, $40, 28, 3
	.dw $2342
	
	.db OPC_DrawRLE
	.dw $2343, Debug_RLEText0
	
	.db OPC_DrawRLE
	.dw $2362, Debug_RLEText1
	
	.db OPC_DrawRLE
	.dw $2385, Debug_RLEText2
	
	.db OPC_DrawRLE
	.dw $2393, Debug_RLEText3
	
	.db OPC_Halt
	
Debug_MapEdit_Init:
	LDX #LOW(Debug_StateMachine0)
	LDY #HIGH(Debug_StateMachine0)
	JSR State_Interpreter_Init
	
	LDX #16
	LDY #48
	LDA #OBJ_DEBUG_CHECKERED
	JSR ObjectList_Insert
	STX DEBUG_CURSORID
	LDA #1
	STA DEBUG_CURSORX
	LDA #3
	STA DEBUG_CURSORY
	
	
	LDX #64
	LDY #96
	LDA #OBJ_DEBUG_CHECKERED_SMALL
	JSR ObjectList_Insert
	
	LDX #$78
	LDY #$BC
	LDA #OBJ_PLAYER
	JSR ObjectList_Insert
	
	JSR CollisionMap_DefaultBorder
	RTS
	
Debug_MapEdit:
	JSR State_Interpreter

	LDA DEBUG_CURSORX
	STA DEBUG_OLDCURX
	LDA DEBUG_CURSORY
	STA DEBUG_OLDCURY
	
.StartButton
	LDA CTRLPORT_1
	AND #CTRL_START
	BEQ .SelectButton
	LDA OLDCTRL_1
	AND #CTRL_START
	BNE .SelectButton
	
	LDA #STATE_TITLE
	JSR GameState_Change
	RTS
	
.SelectButton
	LDA CTRLPORT_1
	AND #CTRL_SELECT
	BEQ .LeftRight
	LDA OLDCTRL_1
	AND #CTRL_SELECT
	BNE .LeftRight
	
	LDA #OBJ_BALL
	LDX #128
	LDY #120
	JSR ObjectList_Insert ;X and Y aren't needed since the ball randomizes its position on init
	RTS
	
	
.LeftRight
	LDA CTRLPORT_1
	AND #CTRL_LEFT
	BEQ .right
	LDA OLDCTRL_1
	AND #CTRL_LEFT
	BNE .UpDown
	DEC DEBUG_CURSORX
	LDA DEBUG_CURSORX
	CMP #COLMAP_EDITABLE_X1
	BCS .UpDown
	INC DEBUG_CURSORX ;set cursor X to zero
	JMP .UpDown
.right
	LDA CTRLPORT_1
	AND #CTRL_RIGHT
	BEQ .UpDown
	LDA OLDCTRL_1
	AND #CTRL_RIGHT
	BNE .UpDown
	INC DEBUG_CURSORX
	LDA DEBUG_CURSORX
	CMP #COLMAP_EDITABLE_X2
	BCC .UpDown
	DEC DEBUG_CURSORX ;set cursor X to 13
.UpDown
	LDA CTRLPORT_1
	AND #CTRL_UP
	BEQ .down
	LDA OLDCTRL_1
	AND #CTRL_UP
	BNE .down
	DEC DEBUG_CURSORY
	LDA DEBUG_CURSORY
	CMP #COLMAP_EDITABLE_Y1
	BCS .buttonB
	INC DEBUG_CURSORY ;set cursor X to zero
	JMP .buttonB
.down
	LDA CTRLPORT_1
	AND #CTRL_DOWN
	BEQ .buttonB
	LDA OLDCTRL_1
	AND #CTRL_DOWN
	BNE .buttonB
	INC DEBUG_CURSORY
	LDA DEBUG_CURSORY
	CMP #COLMAP_EDITABLE_Y2
	BCC .buttonB
	DEC DEBUG_CURSORY ;set cursor X to 10

.buttonB:
	LDA CTRLPORT_1
	AND #CTRL_B
	BEQ .buttonA
	LDA OLDCTRL_1
	AND #CTRL_B
	BNE .buttonA
	
	LDA #0
	LDX #FT_SFX_CH0
	JSR FamiToneSfxPlay
	
	LDA #TILE_BRICK
	STA <CALL_ARGS
	LDA DEBUG_CURSORX
	STA <CALL_ARGS + 1
	LDA DEBUG_CURSORY
	STA <CALL_ARGS + 2
	JSR PPU_DrawMetatile
	
	
	LDA #TILE_BRICK
	TAY
	ORA Metatile_Durability, y
	PHA
	
	LDA DEBUG_CURSORY
	TAY
	LDA MUL16_Table, y
	CLC
	ADC DEBUG_CURSORX
	TAY
	
	PLA
	STA COLLISION_MAP, y

.buttonA:
	LDA CTRLPORT_1
	AND #CTRL_A
	BEQ .endCtrl
	LDA OLDCTRL_1
	AND #CTRL_A
	BNE .endCtrl
	
	LDA #1
	LDX #FT_SFX_CH0
	JSR FamiToneSfxPlay
	
	LDA #TILE_EMPTY
	STA <CALL_ARGS
	LDA DEBUG_CURSORX
	STA <CALL_ARGS + 1
	LDA DEBUG_CURSORY
	STA <CALL_ARGS + 2
	JSR PPU_DrawMetatile
	
	LDA DEBUG_CURSORY
	TAY
	LDA MUL16_Table, y
	CLC
	ADC DEBUG_CURSORX
	TAY
	LDA #TILE_EMPTY
	STA COLLISION_MAP, y
	
.endCtrl
	LDA DEBUG_CURSORX
	CMP DEBUG_OLDCURX
	BEQ .updateX
	
.drawXPos
	JSR ConvertToDecimal
	LDA <TEMP_BYTE
	STA DEBUG_DECIMALX
	LDA <TEMP_BYTE + 1
	STA DEBUG_DECIMALX + 1
	LDA <TEMP_BYTE + 2
	STA DEBUG_DECIMALX + 2
	
	LDA #LOW(DEBUG_DECIMALX)
	STA <CALL_ARGS + 2
	LDA #HIGH(DEBUG_DECIMALX)
	STA <CALL_ARGS + 3
	LDY #$23
	STY <CALL_ARGS + 1
	LDX #$8C
	STX <CALL_ARGS
	JSR PPU_DrawNumber ;Draws X position on screen next frame
	
.updateX
	LDX DEBUG_CURSORID
	LDA DEBUG_CURSORX
	ASL A
	ASL A
	ASL A
	ASL A ;times 16
	
	STA OBJ_XPOS, x
	
	LDA DEBUG_CURSORY
	CMP DEBUG_OLDCURY
	BEQ .updateY
	
.drawYPos
	JSR ConvertToDecimal
	LDA <TEMP_BYTE
	STA DEBUG_DECIMALY
	LDA <TEMP_BYTE + 1
	STA DEBUG_DECIMALY + 1
	LDA <TEMP_BYTE + 2
	STA DEBUG_DECIMALY + 2
	
	LDA #LOW(DEBUG_DECIMALY)
	STA <CALL_ARGS + 2
	LDA #HIGH(DEBUG_DECIMALY)
	STA <CALL_ARGS + 3
	LDY #$23
	STY <CALL_ARGS + 1
	LDX #$8F
	STX <CALL_ARGS
	JSR PPU_DrawNumber ;Draws X position on screen next frame
	
.updateY
	LDX DEBUG_CURSORID
	LDA DEBUG_CURSORY
	ASL A
	ASL A
	ASL A
	ASL A ;times 16
	
	STA OBJ_YPOS, x
	
	RTS
	

	