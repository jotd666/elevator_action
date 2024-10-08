

***    
*** BUILD OPTIONS
***
	.ifdef		RELEASE
    * hardware options
    OPT_DISABLE_BG_LAYER=0
    OPT_DISABLE_SPRITES=0
    
	* cheats to test game
    * score is decimal format
	* all options must be zeroed for release
    OPT_START_SCORE=0

	OPT_START_WITH_HIGH_SCORE_TABLE=0
	OPT_SKIP_GAME_DEMO=0
	OPT_ONLY_ONE_ENEMY=0
	OPT_ONLY_ONE_LIFE=0
	OPT_NO_ENEMIES=0
	OPT_DEBUG_SCROLLING=0
	.else
	
    OPT_DISABLE_BG_LAYER=0
    OPT_DISABLE_SPRITES=0
   
	* cheats to test game
    * score is decimal format
	* all options must be zeroed for release
    OPT_START_SCORE=0

	OPT_START_WITH_HIGH_SCORE_TABLE=0
	OPT_SKIP_GAME_DEMO=0
	OPT_ONLY_ONE_ENEMY=0
	OPT_ONLY_ONE_LIFE=0
	OPT_NO_ENEMIES=0
	OPT_DEBUG_SCROLLING=0
	
	
	.endif
	
***
*** end of BUILD OPTIONS
***

	* file is generated
	.include	"sounds.inc"
    
.macro _STRUCT
  .set _offset_,0
.endm

.macro _DS _element, _size
   \_element = _offset_
   .set _offset_,_offset_+\_size
.endm


| write current PC value to some address
.macro LOGPC	address
	.ifndef	RELEASE
     bsr    .next_\@
.next_\@:
      addq.l    #6,(a7) | skip this & next instruction
      move.l    (a7)+,0x\address
	.endif
.endm
