;this file for FamiTone2 library generated by text2data tool

WinJingle_music_data:
	.db 1
	.dw .instruments
	.dw .samples-3
	.dw .song0ch0,.song0ch1,.song0ch2,.song0ch3,.song0ch4,337,281

.instruments:
	.db $30 ;instrument $01
	.dw .env4,.env5,.env0
	.db $00
	.db $30 ;instrument $04
	.dw .env1,.env0,.env0
	.db $00
	.db $30 ;instrument $06
	.dw .env2,.env0,.env0
	.db $00
	.db $b0 ;instrument $0b
	.dw .env3,.env0,.env0
	.db $00

.samples:
.env0:
	.db $c0,$00,$00
.env1:
	.db $cb,$c8,$c6,$c4,$c3,$c2,$c1,$04,$c0,$00,$08
.env2:
	.db $ce,$cb,$ca,$c9,$c8,$c8,$c7,$c6,$02,$c5,$c4,$c3,$03,$c2,$c2,$c1
	.db $02,$c0,$00,$11
.env3:
	.db $c8,$ca,$cc,$cd,$ce,$cd,$cc,$cb,$ca,$ca,$c9,$c9,$c9,$00,$0c
.env4:
	.db $cf,$cf,$ce,$cd,$cc,$cb,$ca,$c9,$c8,$c7,$c6,$c5,$00,$0b
.env5:
	.db $cc,$00,$00


.song0ch0:
	.db $fb,$04
.song0ch0loop:
.ref0:
	.db $9f,$86,$34,$8d,$30,$85,$34,$95,$3e,$8d,$3e,$ab
	.db $fd
	.dw .song0ch0loop

.song0ch1:
.song0ch1loop:
.ref1:
	.db $9f,$86,$26,$8d,$22,$85,$26,$95,$30,$8d,$34,$ab
	.db $fd
	.dw .song0ch1loop

.song0ch2:
.song0ch2loop:
.ref2:
	.db $8f,$80,$3f,$45,$49,$53,$4c,$ad,$48,$8d,$4c,$85,$4c,$87,$00,$99
	.db $fd
	.dw .song0ch2loop

.song0ch3:
.song0ch3loop:
.ref3:
	.db $82,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$1c,$84,$1b,$82,$1d,$1d,$1d,$84
	.db $12,$85,$82,$1d,$1d,$1d,$1d,$84,$12,$85,$1a,$85,$82,$1c,$1c,$1c
	.db $1c,$84,$1a,$8d,$1a,$ab
	.db $fd
	.dw .song0ch3loop

.song0ch4:
.song0ch4loop:
.ref4:
	.db $f9,$93
	.db $fd
	.dw .song0ch4loop
