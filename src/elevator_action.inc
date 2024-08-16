

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
	
	
	.endif
	
***
*** end of BUILD OPTIONS
***




* sound ordinals

    .equ  BOSS_KILLED_SND,         0x0
    .equ  BEE_KILLED_SND,     0x01          | used around 07F8:sub 
    .equ  MOTH_KILLED_SND,         0x02     | used around 07F8:sub 
    .equ  GALAXIAN_KILLED_SND,    0x03      | used around 07F8:sub 
    .equ  GREEN_BOSS_HIT_SND,     0x03      | used around 07F8:sub 
    .equ  CAPTURE_DOWN_SND,     0x05
    .equ  FIGHTER_KILLED_SND,         0x06  | used around 07F8:sub 
    .equ  SHOT_SND,           0xF
	.equ  CHALLENGING_STAGE_SND, 0xD
    .equ  MUTANT_SND,         0x12
    .equ  ATTACK_SND,         0x13
    .equ  TICK_SND,           0x15
    .equ  EXPLOSION_SND,         0x19
    .equ  HIGHEST_SCORE_SND,         0xc
    .equ  HIGH_SCORE_SND,         0x10
    .equ  CREDIT_SND,         0x1A
    .equ  EXTRA_LIFE_SND,         0x1B
	
    .equ  GAME_START_SND,         0x9
    .equ  FIGHTER_CAPTURED_SND,         0x16
    .equ  CAPTURE_UP_SND,     0x17    
    .equ  FIGHTER_RESCUED_SND,         0x18
    .equ  END_CHALLENGE_SND,         0xE
    .equ  PERFECT_SND,         0x14
    .equ  SWARM_SND,         0x1C
	.equ  SND_COUNT,  0x20
    
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