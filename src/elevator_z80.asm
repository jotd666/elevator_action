
	map(0x0000, 0x5fff).rom();
;	map(0x6000, 0x7fff).bankr(m_mainbank);
;	map(0x8000, 0x87ff).ram();
;	map(0x8800, 0x8800).mirror(0x07fe).rw(FUNC(taitosj_state::fake_data_r), FUNC(taitosj_state::fake_data_w));
;	map(0x8801, 0x8801).mirror(0x07fe).r(FUNC(taitosj_state::fake_status_r));
;	map(0x9000, 0xbfff).w(FUNC(taitosj_state::characterram_w)).share(m_characterram);
;	map(0xc000, 0xc3ff).ram();
;	map(0xc400, 0xc7ff).ram().share(m_videoram[0]);
;	map(0xc800, 0xcbff).ram().share(m_videoram[1]);
;	map(0xcc00, 0xcfff).ram().share(m_videoram[2]);
;	map(0xd000, 0xd05f).ram().share(m_colscrolly); 0x20 values per layer
;	map(0xd100, 0xd1ff).ram().share(m_spriteram);
;	map(0xd200, 0xd27f).mirror(0x0080).ram().share(m_paletteram);
;	map(0xd300, 0xd300).mirror(0x00ff).writeonly().share(m_video_priority);
;	map(0xd400, 0xd403).mirror(0x00f0).readonly().share(m_collision_reg);  not used here!
;	map(0xd404, 0xd404).mirror(0x00f3).r(FUNC(taitosj_state::gfxrom_r));
;	map(0xd408, 0xd408).mirror(0x00f0).portr("IN0");
;	map(0xd409, 0xd409).mirror(0x00f0).portr("IN1");
;	map(0xd40a, 0xd40a).mirror(0x00f0).portr("DSW1");
;	map(0xd40b, 0xd40b).mirror(0x00f0).portr("IN2");
;	map(0xd40c, 0xd40c).mirror(0x00f0).portr("IN3");          // Service
;	map(0xd40d, 0xd40d).mirror(0x00f0).portr("IN4");  not used
;	map(0xd40e, 0xd40f).mirror(0x00f0).w(m_ay[0], FUNC(ay8910_device::address_data_w));
;	map(0xd40f, 0xd40f).mirror(0x00f0).r(m_ay[0], FUNC(ay8910_device::data_r));   // DSW2 and DSW3
; main scroll
; D500: horiz scroll of layer 1 (score)
; D501: vertical scroll of layer 1 (score)
; D502: horiz scroll of layer 2 (building)
; D503: vertical scroll of layer 2 (building)
; D502: horiz scroll of layer 3 (elevators)
;	map(0xd500, 0xd505).mirror(0x00f0).writeonly().share(m_scroll);
;	map(0xd506, 0xd507).mirror(0x00f0).writeonly().share(m_colorbank);
;	map(0xd508, 0xd508).mirror(0x00f0).w(FUNC(taitosj_state::collision_reg_clear_w)); NOT USED!!
;	map(0xd509, 0xd50a).mirror(0x00f0).writeonly().share(m_gfxpointer);
;	map(0xd50b, 0xd50b).mirror(0x00f0).w(FUNC(taitosj_state::soundlatch_w));
;	map(0xd50c, 0xd50c).mirror(0x00f0).w(FUNC(taitosj_state::sound_semaphore2_w));
;	map(0xd50d, 0xd50d).mirror(0x00f0).w("watchdog", FUNC(watchdog_timer_device::reset_w));
;	map(0xd50e, 0xd50e).mirror(0x00f0).w(FUNC(taitosj_state::bankswitch_w));
;	map(0xd50f, 0xd50f).mirror(0x00f0).nopw();
;	map(0xd600, 0xd600).mirror(0x00ff).writeonly().share(m_video_mode);


; character struct offsets
character_x_00 = 0x0
character_x_right_01 = 0x1
character_fine_y_offset_02 = 0x2
character_y_offset_03 = 0x3
character_state_04 = 0x4
character_delta_x_05 = 0x5
character_situation_06 = 0x6  ; 0: ground, 1: in elevator, 2: on elevator, 3: ??, 4: in stairs, 5: ??
current_floor_07 = 0x7
associated_elevator_08 = 0x8	; for player & enemies
spawning_door_08 = 0x8			; for unspawned enemies, number of door to spawn from 0-7
enemy_state_09 = 0x9			; 0xFF: inactive, 0: active, 1: ??
character_unknown_0a = 0xa
character_unknown_0b = 0xb
character_unknown_0c = 0xc
move_direction_0d = 0xd

; elevator structs offsets (size=8)
current_floor_01 = 0x1
max_floor_02 = 0x2
min_floor_03 = 0x3
player_control_07 = 0x7		; when player can control elevator

; character situations
CS_ON_GROUND_00 = 0
CS_IN_ELEVATOR_01 = 1
CS_ABOVE_ELEVATOR_02 = 2
CS_FALLING_03 = 3
CS_IN_STAIRS_04 = 4
CS_IN_ROOM_05 = 5

; global game state
GS_UNKNOWN_00 = 0
GS_TITLE_01 = 1
GS_PUSH_START_03 = 3
GS_GAME_STARTING_04 = 4
GS_IN_GAME_05 = 5
GS_GROUND_FLOOR_REACHED_06 = 6
GS_NEXT_LIFE_07 = 7
GS_GAME_OVER_08 = 8
GS_INSERT_COIN_09 = 9

0000: C3 8F 33    jp   bootup_338f

; doesn't seem reached
0003: 21 49 86    ld   hl,$8649
0006: 7E          ld   a,(hl)
0007: C8          ret  z

rst_08:
protection_crap_0008:
0008: 2F          cpl
0009: 32 49 86    ld   ($8649),a
000C: 3E 9C       ld   a,$9C
000E: E7          rst  $20
000F: C9          ret

; updates protection_random_variable_8647 pseudo-randomly (it seems)
randomize_8647_0010:
0010: 07          rlca
0011: 21 47 86    ld   hl,$8647
0014: 7E          ld   a,(hl)
0015: 38 04       jr   c,$001B
0017: C6 F3       add  a,$F3
0019: CB 2F       sra  a
001B: C6 17       add  a,$17
001D: 77          ld   (hl),a
001E: C9          ret

; part of protection, RET it on bootleg
rst_20:
0020: E5          push hl
0021: CD CF 77    call mcu_comm_routine_77CF
0024: D7          rst  $10
0025: E1          pop  hl
0026: C9          ret

; part of protection?, RET it on bootleg as it's not useful
0028: E6 1F       and  $1F
002A: E7          rst  $20
002B: 21 48 86    ld   hl,protection_variable_8648
002E: B6          or   (hl)
002F: 77          ld   (hl),a
0030: CD BD 77    call mcu_comm_routine_77BD
0033: C9          ret

elevator_irq_0038:
0038: C3 99 11    jp   elevator_irq_1199

003B: DD 7E 09    ld   a,(ix+$09)
003E: 3C          inc  a
003F: C8          ret  z
0040: DD 7E 06    ld   a,(ix+character_situation_06)
0043: FE 03       cp   CS_FALLING_03
0045: D0          ret  nc
; either on ground, in or above elevator
0046: DD 7E 10    ld   a,(ix+$10)
0049: B7          or   a
004A: C8          ret  z
004B: DD 7E 12    ld   a,(ix+$12)
004E: E6 07       and  $07
0050: 5F          ld   e,a
0051: FE 04       cp   $04
0053: 38 10       jr   c,$0065
0055: DD 7E 13    ld   a,(ix+enemy_aggressivity_13)
0058: 87          add  a,a
0059: 87          add  a,a
005A: 87          add  a,a
005B: D6 50       sub  $50
005D: 38 01       jr   c,$0060
005F: AF          xor  a
0060: ED 44       neg
0062: DD 77 19    ld   (ix+$19),a
0065: 7B          ld   a,e
0066: 83          add  a,e
0067: 83          add  a,e
0068: 5F          ld   e,a
0069: 16 00       ld   d,$00
006B: 21 70 00    ld   hl,jump_table_0070
006E: 19          add  hl,de
006F: E9          jp   (hl)

jump_table_0070:
0070: C3 88 00    jp   $0088
0073: C3 B3 00    jp   $00B3
0076: C3 D3 00    jp   $00D3
0079: C3 F0 00    jp   $00F0
007C: C3 92 00    jp   $0092
007F: C3 BE 00    jp   $00BE
0082: C3 DB 00    jp   $00DB
0085: C3 F7 00    jp   $00F7

0088: CD 48 01    call $0148
008B: 16 00       ld   d,$00
008D: DD 72 11    ld   (ix+$11),d
0090: 18 12       jr   $00A4
0092: 16 00       ld   d,$00
0094: DD 72 11    ld   (ix+$11),d
0097: CD 74 01    call $0174
009A: 3A 00 80    ld   a,($8000)
009D: DD BE 10    cp   (ix+$10)
00A0: 20 02       jr   nz,$00A4
00A2: 16 20       ld   d,$20
00A4: DD 7E 09    ld   a,(ix+$09)
00A7: FE 02       cp   $02
00A9: 38 04       jr   c,$00AF
00AB: 3E 08       ld   a,$08
00AD: B2          or   d
00AE: 57          ld   d,a
00AF: CD 34 01    call $0134
00B2: C9          ret

00B3: CD 48 01    call $0148
00B6: 16 00       ld   d,$00
00B8: DD 72 11    ld   (ix+$11),d
00BB: C3 EF 85    jp   dynamic_ram_code_85EF

00BE: 16 00       ld   d,$00
00C0: DD 72 11    ld   (ix+$11),d
00C3: CD 74 01    call $0174
00C6: 3A 00 80    ld   a,($8000)
00C9: DD BE 10    cp   (ix+$10)
00CC: 28 02       jr   z,$00D0
00CE: 16 20       ld   d,$20
00D0: C3 EF 85    jp   dynamic_ram_code_85EF
00D3: 16 00       ld   d,$00
00D5: DD 72 11    ld   (ix+$11),d
00D8: C3 CF 85    jp   dynamic_ram_code_85CF
00DB: 16 00       ld   d,$00
00DD: DD 72 11    ld   (ix+$11),d
00E0: CD 74 01    call $0174
00E3: 3A 00 80    ld   a,($8000)
00E6: DD BE 10    cp   (ix+$10)
00E9: 28 02       jr   z,$00ED
00EB: 16 20       ld   d,$20
00ED: C3 CF 85    jp   dynamic_ram_code_85CF
00F0: 16 00       ld   d,$00
00F2: DD 72 11    ld   (ix+$11),d
00F5: 18 12       jr   $0109
00F7: 16 00       ld   d,$00
00F9: DD 72 11    ld   (ix+$11),d
00FC: CD 74 01    call $0174
00FF: 3A 00 80    ld   a,($8000)
0102: DD BE 10    cp   (ix+$10)
0105: 20 02       jr   nz,$0109
0107: 16 20       ld   d,$20
0109: DD 7E 09    ld   a,(ix+$09)
010C: 06 08       ld   b,$08
010E: FE 02       cp   $02
0110: 30 09       jr   nc,$011B
0112: DD 7E 0B    ld   a,(ix+$0b)
0115: 06 01       ld   b,$01
0117: B7          or   a
0118: 28 01       jr   z,$011B
011A: 04          inc  b
011B: 78          ld   a,b
011C: B2          or   d
011D: 57          ld   d,a
011E: CD 34 01    call $0134
0121: DD 7E 05    ld   a,(ix+character_delta_x_05)
0124: B7          or   a
0125: C8          ret  z
0126: 17          rla
0127: 17          rla
0128: E6 01       and  $01
012A: DD BE 0B    cp   (ix+$0b)
012D: C0          ret  nz
012E: EE 01       xor  $01
0130: DD 77 0B    ld   (ix+$0b),a
0133: C9          ret
0134: DD 7E 17    ld   a,(ix+$17)
0137: B7          or   a
0138: 28 09       jr   z,$0143
013A: FA 41 01    jp   m,$0141
013D: 3E 08       ld   a,$08
013F: 18 02       jr   $0143
0141: 3E 04       ld   a,$04
0143: B2          or   d
0144: DD 77 0D    ld   (ix+move_direction_0d),a
0147: C9          ret

0148: DD 7E 0F    ld   a,(ix+$0f)
014B: B7          or   a
014C: C0          ret  nz
014D: DD 7E 0E    ld   a,(ix+$0e)
0150: B7          or   a
0151: 20 0C       jr   nz,$015F
0153: DD 7E 10    ld   a,(ix+$10)
0156: FE 0A       cp   $0A
0158: 28 11       jr   z,$016B
015A: FE 14       cp   $14
015C: 28 0D       jr   z,$016B
015E: C9          ret

015F: DD 7E 10    ld   a,(ix+$10)
0162: FE 07       cp   $07
0164: 28 05       jr   z,$016B
0166: FE 0E       cp   $0E
0168: 28 01       jr   z,$016B
016A: C9          ret

016B: DD 7E 0B    ld   a,(ix+$0b)
016E: EE 01       xor  $01
0170: DD 77 0B    ld   (ix+$0b),a
0173: C9          ret

0174: CD F5 1D    call pseudo_random_1DF5
0177: FE 0C       cp   $0C
0179: D0          ret  nc
017A: DD 36 11 FF ld   (ix+$11),$FF
017E: C9          ret

handle_main_scrolling_017F:
017F: CD 86 01    call adjust_scrolling_speed_direction_0186
0182: CD 06 02    call update_scrolling_playfield_0206
0185: C9          ret

adjust_scrolling_speed_direction_0186:
0186: AF          xor  a
0187: 32 04 80    ld   (scroll_speed_8004),a
018A: CD BA 01    call stabilize_view_handle_falls_01BA
018D: D8          ret  c				; careful: checks carry from subroutine return
018E: 7D          ld   a,l
018F: D6 6E       sub  $6E
0191: C8          ret  z
0192: 38 0C       jr   c,$01A0
0194: 3A 03 80    ld   a,($8003)
0197: FE 1D       cp   $1D
0199: C8          ret  z
019A: 3E 02       ld   a,$02
019C: 32 04 80    ld   (scroll_speed_8004),a
019F: C9          ret
01A0: 3A 03 80    ld   a,($8003)
01A3: 3C          inc  a
01A4: C2 B4 01    jp   nz,$01B4
01A7: 3A 02 80    ld   a,($8002)
01AA: B7          or   a
01AB: C2 B4 01    jp   nz,$01B4
01AE: 3A 01 80    ld   a,($8001)
01B1: D6 02       sub  $02
01B3: F8          ret  m
01B4: 3E FE       ld   a,$FE
01B6: 32 04 80    ld   (scroll_speed_8004),a
01B9: C9          ret

; if disabled, game scrolls down and restarts, seems to make up that scrolling down!
stabilize_view_handle_falls_01BA:
01BA: DD 21 1A 85 ld   ix,player_structure_851A
01BE: DD 7E 06    ld   a,(ix+character_situation_06)
01C1: B7          or   a
01C2: 28 16       jr   z,player_falling_01DA
01C4: 3D          dec  a
01C5: 28 1D       jr   z,player_inside_elevator_01E4
01C7: 3D          dec  a
01C8: 28 23       jr   z,player_above_elevator_01ED
01CA: FE 03       cp   CS_IN_ROOM_05-2
01CC: CA DA 01    jp   z,player_falling_01DA
01CF: DD 46 07    ld   b,(ix+$07)
01D2: 0E 00       ld   c,$00
01D4: DD 56 03    ld   d,(ix+character_y_offset_03)
01D7: C3 6C 1E    jp   compute_delta_height_1e6c

; player falls
player_falling_01DA:
01DA: DD 46 07    ld   b,(ix+$07)
01DD: 0E 00       ld   c,$00
01DF: 16 06       ld   d,$06
01E1: C3 6C 1E    jp   compute_delta_height_1e6c

player_inside_elevator_01E4:
01E4: CD CE 62    call load_character_elevator_structure_62CE
01E7: FD 46 01    ld   b,(iy+$01)
01EA: C3 F4 01    jp   player_in_or_on_elevator_01F4

player_above_elevator_01ED:
01ED: CD CE 62    call load_character_elevator_structure_62CE
01F0: FD 46 01    ld   b,(iy+$01)
01F3: 04          inc  b
player_in_or_on_elevator_01F4:
01F4: 0E 00       ld   c,$00
01F6: FD 7E 00    ld   a,(iy+$00)
01F9: 57          ld   d,a
01FA: DD 7E 08    ld   a,(ix+$08)
01FD: 17          rla
01FE: D2 6C 1E    jp   nc,compute_delta_height_1e6c
0201: 05          dec  b
0202: 05          dec  b
0203: C3 6C 1E    jp   compute_delta_height_1e6c

update_scrolling_playfield_0206:
0206: AF          xor  a
0207: 32 07 80    ld   ($8007),a
020A: 3A 04 80    ld   a,(scroll_speed_8004)
020D: 4F          ld   c,a
020E: 06 00       ld   b,$00
0210: 17          rla
0211: 30 02       jr   nc,$0215
0213: 06 FF       ld   b,$FF
0215: 2A 2A 80    ld   hl,($802A)
0218: 09          add  hl,bc
0219: 22 2A 80    ld   ($802A),hl
021C: 11 DF 00    ld   de,$00DF
021F: 19          add  hl,de
0220: 22 28 80    ld   ($8028),hl
0223: 3A 05 80    ld   a,(main_scroll_value_8005)
0226: 91          sub  c
0227: 32 05 80    ld   (main_scroll_value_8005),a
022A: 79          ld   a,c
022B: B7          or   a
022C: C8          ret  z
022D: F2 7D 02    jp   p,update_bottom_horizon_027d
0230: 21 01 80    ld   hl,$8001
0233: 7E          ld   a,(hl)
0234: 81          add  a,c
0235: 77          ld   (hl),a
0236: D8          ret  c
0237: C6 08       add  a,$08
0239: 77          ld   (hl),a
023A: 23          inc  hl
023B: 35          dec  (hl)
023C: F2 44 02    jp   p,$0244
023F: 36 05       ld   (hl),$05
0241: 23          inc  hl
0242: 35          dec  (hl)
0243: 2B          dec  hl
0244: 4E          ld   c,(hl)
0245: 23          inc  hl
0246: 46          ld   b,(hl)
0247: 3E 66       ld   a,$66
0249: 90          sub  b
024A: 90          sub  b
024B: 90          sub  b
024C: 87          add  a,a
024D: 91          sub  c
024E: 6F          ld   l,a
; compute proper address in gfx rom
024F: 26 00       ld   h,$00
0251: 29          add  hl,hl
0252: 29          add  hl,hl
0253: 29          add  hl,hl
0254: 29          add  hl,hl
0255: 29          add  hl,hl	; times 32
0256: EB          ex   de,hl
0257: 21 80 5F    ld   hl,$5F80	; start in gfx rom
025A: 19          add  hl,de
025B: D5          push de
025C: 22 09 D5    ld   (gfx_pointer_d509),hl
025F: 11 08 80    ld   de,scroll_row_8008
0262: 21 04 D4    ld   hl,gfx_rom_D404
; copy 32 bytes of gfx rom to ram, value read from D404 changes at each read!!!
; reads a row of building data from gfx rom to RAM
0265: 06 20       ld   b,$20
0267: 7E          ld   a,(hl)
0268: 12          ld   (de),a
0269: 13          inc  de
026A: 10 FB       djnz $0267
026C: E1          pop  hl
026D: 7C          ld   a,h
026E: E6 03       and  $03
0270: C6 C8       add  a,$C8
0272: 67          ld   h,a
0273: 22 06 80    ld   (scroll_tile_pointer_8006),hl
0276: CD 9C 02    call add_dynamic_tiles_if_needed_029c
0279: CD 87 03    call $0387
027C: C9          ret

update_bottom_horizon_027d:
027D: 21 01 80    ld   hl,$8001
0280: 7E          ld   a,(hl)
0281: 81          add  a,c
0282: 77          ld   (hl),a
0283: D6 08       sub  $08
0285: D8          ret  c
0286: 77          ld   (hl),a
0287: 23          inc  hl		; now pointing on $8002
0288: 34          inc  (hl)		; increment value
0289: 7E          ld   a,(hl)
028A: D6 06       sub  $06
028C: DA 93 02    jp   c,$0293
028F: 77          ld   (hl),a
0290: 23          inc  hl		; now pointing on $8003
0291: 34          inc  (hl)		; increment value		
0292: 2B          dec  hl		; now pointing on $8002
0293: 4E          ld   c,(hl)
0294: 23          inc  hl		; now pointing on $8003
0295: 7E          ld   a,(hl)
0296: C6 05       add  a,$05
0298: 47          ld   b,a
0299: C3 47 02    jp   $0247

add_dynamic_tiles_if_needed_029c:
029C: 3A 07 80    ld   a,(scroll_tile_pointer_8006+1)
029F: B7          or   a
02A0: C8          ret  z
02A1: 2A 02 80    ld   hl,($8002)
02A4: 3A 04 80    ld   a,(scroll_speed_8004)
02A7: B7          or   a
02A8: FA AF 02    jp   m,$02AF
02AB: 7C          ld   a,h
02AC: C6 05       add  a,$05
02AE: 67          ld   h,a
02AF: 4D          ld   c,l
02B0: 7C          ld   a,h
02B1: FE 08       cp   $08
02B3: DA 40 03    jp   c,$0340
02B6: FE 1F       cp   $1F
02B8: D0          ret  nc
02B9: 5F          ld   e,a
02BA: 16 00       ld   d,$00
02BC: 79          ld   a,c
02BD: FE 05       cp   $05
02BF: CA C6 02    jp   z,$02C6
02C2: CD CA 02    call add_red_door_tiles_to_scroll_data_02ca
02C5: C9          ret
02C6: CD 5F 03    call display_broken_lamp_if_needed_035f
02C9: C9          ret

add_red_door_tiles_to_scroll_data_02ca:
02CA: 21 10 82    ld   hl,red_door_position_array_8210
02CD: 19          add  hl,de
02CE: 7E          ld   a,(hl)
02CF: FE 08       cp   $08
02D1: D0          ret  nc
02D2: 21 08 80    ld   hl,scroll_row_8008
02D5: 47          ld   b,a
02D6: D5          push de
02D7: 87          add  a,a
02D8: 80          add  a,b
02D9: C6 04       add  a,$04
02DB: 5F          ld   e,a
02DC: 19          add  hl,de
02DD: D1          pop  de
02DE: 79          ld   a,c
02DF: B7          or   a
02E0: CA 22 03    jp   z,$0322
02E3: FE 03       cp   $03
02E5: CA 09 03    jp   z,$0309
02E8: D2 0F 03    jp   nc,$030F
02EB: 3D          dec  a
02EC: CA 09 03    jp   z,$0309
02EF: 0E 04       ld   c,$04
02F1: 7B          ld   a,e
02F2: FE 14       cp   $14
02F4: 20 02       jr   nz,$02F8
02F6: 0E 06       ld   c,$06
02F8: 78          ld   a,b
02F9: B9          cp   c
02FA: D2 03 03    jp   nc,$0303
02FD: 36 83       ld   (hl),$83
02FF: 23          inc  hl
0300: 36 82       ld   (hl),$82
0302: C9          ret
0303: 36 82       ld   (hl),$82
0305: 23          inc  hl
0306: 36 84       ld   (hl),$84
0308: C9          ret
0309: 36 82       ld   (hl),$82
030B: 23          inc  hl
030C: 36 82       ld   (hl),$82
030E: C9          ret
030F: 06 9E       ld   b,$9E
0311: 7B          ld   a,e
0312: FE 10       cp   $10
0314: D2 1E 03    jp   nc,$031E
0317: FE 0B       cp   $0B
0319: DA 1E 03    jp   c,$031E
031C: 06 80       ld   b,$80
031E: 70          ld   (hl),b
031F: 23          inc  hl
0320: 70          ld   (hl),b
0321: C9          ret
0322: 0E E0       ld   c,$E0
0324: 2B          dec  hl
0325: 78          ld   a,b
0326: FE 04       cp   $04
0328: 38 04       jr   c,$032E
032A: 0E E2       ld   c,$E2
032C: 23          inc  hl
032D: 23          inc  hl
032E: 7B          ld   a,e
032F: FE 0B       cp   $0B
0331: 38 08       jr   c,$033B
0333: FE 10       cp   $10
0335: 30 04       jr   nc,$033B
0337: 79          ld   a,c
0338: C6 04       add  a,$04
033A: 4F          ld   c,a
033B: 71          ld   (hl),c
033C: 23          inc  hl
033D: 0C          inc  c
033E: 71          ld   (hl),c
033F: C9          ret
0340: B7          or   a
0341: C8          ret  z
0342: 5F          ld   e,a
0343: 16 00       ld   d,$00
0345: 79          ld   a,c
0346: FE 05       cp   $05
0348: C8          ret  z
0349: 21 10 82    ld   hl,red_door_position_array_8210
034C: 19          add  hl,de
034D: 7E          ld   a,(hl)
034E: 47          ld   b,a
034F: FE 08       cp   $08
0351: D0          ret  nc
0352: 21 0B 80    ld   hl,$800B
0355: B7          or   a
0356: CA DE 02    jp   z,$02DE
0359: 21 22 80    ld   hl,$8022
035C: C3 DE 02    jp   $02DE

display_broken_lamp_if_needed_035f:
035F: 7B          ld   a,e
0360: D6 08       sub  $08
0362: 5F          ld   e,a
0363: FE 03       cp   $03
0365: DA 6B 03    jp   c,$036B
0368: FE 08       cp   $08
036A: D8          ret  c
036B: 21 DA 81    ld   hl,$81DA
036E: 19          add  hl,de
036F: 46          ld   b,(hl)
0370: 7B          ld   a,e
0371: FE 0C       cp   $0C
0373: 3E 97       ld   a,$97
0375: CA 80 03    jp   z,$0380
0378: CB 40       bit  0,b
037A: C2 80 03    jp   nz,$0380
037D: 32 1D 80    ld   ($801D),a
0380: CB 48       bit  1,b
0382: C0          ret  nz
0383: 32 11 80    ld   ($8011),a
0386: C9          ret

0387: 3A 04 80    ld   a,(scroll_speed_8004)
038A: B7          or   a
038B: F0          ret  p
038C: 2A 02 80    ld   hl,($8002)
038F: 25          dec  h
0390: CA AC 03    jp   z,$03AC
0393: 24          inc  h
0394: C0          ret  nz
0395: 2D          dec  l
0396: F8          ret  m
0397: 3A 2D 80    ld   a,($802D)
039A: 87          add  a,a
039B: 87          add  a,a
039C: 16 00       ld   d,$00
039E: 5F          ld   e,a
039F: 21 0E 80    ld   hl,$800E
03A2: 19          add  hl,de
03A3: 36 00       ld   (hl),$00
03A5: 23          inc  hl
03A6: 36 00       ld   (hl),$00
03A8: 23          inc  hl
03A9: 36 00       ld   (hl),$00
03AB: C9          ret
03AC: 2D          dec  l
03AD: F0          ret  p
03AE: 3A 2D 80    ld   a,($802D)
03B1: 87          add  a,a
03B2: 87          add  a,a
03B3: 16 00       ld   d,$00
03B5: 5F          ld   e,a
03B6: 21 0E 80    ld   hl,$800E
03B9: 19          add  hl,de
03BA: 36 4D       ld   (hl),$4D
03BC: 23          inc  hl
03BD: 36 00       ld   (hl),$00
03BF: 23          inc  hl
03C0: 36 4E       ld   (hl),$4E
03C2: C9          ret

; update hardware scroll value & tile data (if needed, if speed != 0)
update_main_scrolling_03C3:
03C3: 3A 04 80    ld   a,(scroll_speed_8004)	; 2 (down), 0 (not moving), -2 (up)
03C6: B7          or   a
03C7: C8          ret  z
; set main scroll value for main view (building stories)
03C8: 3A 05 80    ld   a,(main_scroll_value_8005)
03CB: 21 20 D0    ld   hl,main_scroll_columns_D020
03CE: 06 20       ld   b,$20
03D0: 77          ld   (hl),a
03D1: 23          inc  hl
03D2: 10 FC       djnz $03D0
03D4: 2A 06 80    ld   hl,(scroll_tile_pointer_8006)
03D7: 7C          ld   a,h
03D8: B7          or   a
03D9: C8          ret  z
03DA: EB          ex   de,hl
; set top row with new tiles
03DB: 21 08 80    ld   hl,scroll_row_8008
03DE: ED A0       ldi
03E0: ED A0       ldi
03E2: ED A0       ldi
03E4: ED A0       ldi
03E6: ED A0       ldi
03E8: ED A0       ldi
03EA: ED A0       ldi
03EC: ED A0       ldi
03EE: ED A0       ldi
03F0: ED A0       ldi
03F2: ED A0       ldi
03F4: ED A0       ldi
03F6: ED A0       ldi
03F8: ED A0       ldi
03FA: ED A0       ldi
03FC: ED A0       ldi
03FE: ED A0       ldi
0400: ED A0       ldi
0402: ED A0       ldi
0404: ED A0       ldi
0406: ED A0       ldi
0408: ED A0       ldi
040A: ED A0       ldi
040C: ED A0       ldi
040E: ED A0       ldi
0410: ED A0       ldi
0412: ED A0       ldi
0414: ED A0       ldi
0416: ED A0       ldi
0418: ED A0       ldi
041A: ED A0       ldi
041C: ED A0       ldi
041E: C9          ret

041F: 21 77 83    ld   hl,$8377
0422: 3A 21 85    ld   a,(player_structure_851A+current_floor_07)
0425: 4F          ld   c,a
0426: 0D          dec  c
0427: 06 03       ld   b,$03
0429: 7E          ld   a,(hl)
042A: FE 03       cp   $03
042C: 30 06       jr   nc,$0434
042E: 23          inc  hl
042F: 0C          inc  c
0430: 10 F7       djnz $0429
0432: 0E 28       ld   c,$28
0434: 3A 30 85    ld   a,($8530)
0437: 57          ld   d,a
0438: 06 04       ld   b,$04		; 4 enemies
043A: DD 21 3A 85 ld   ix,enemy_1_853A
; start loop on enemies
043E: DD 7E 09    ld   a,(ix+$09)
0441: FE 05       cp   $05
0443: 30 23       jr   nc,$0468
0445: DD 7E 0F    ld   a,(ix+$0f)
0448: B7          or   a
0449: 20 1D       jr   nz,$0468
044B: DD 7E 1C    ld   a,(ix+$1c)
044E: FE 0C       cp   $0C
0450: 28 16       jr   z,$0468
0452: DD 7E 06    ld   a,(ix+character_situation_06)
0455: B7          or   a
0456: 20 10       jr   nz,$0468
; enemy on ground (not in elevator)
0458: DD 7E 07    ld   a,(ix+$07)
045B: B9          cp   c
045C: 28 14       jr   z,$0472
045E: DD 7E 16    ld   a,(ix+$16)
0461: 92          sub  d
0462: 38 04       jr   c,$0468
0464: FE 50       cp   $50
0466: 30 0A       jr   nc,$0472
0468: 7A          ld   a,d
0469: 11 20 00    ld   de,$0020
046C: DD 19       add  ix,de
046E: 57          ld   d,a
046F: 10 CD       djnz $043E
0471: C9          ret
0472: DD 7E 07    ld   a,(ix+$07)
0475: FE 08       cp   $08
0477: D8          ret  c
0478: FE 14       cp   $14
047A: C8          ret  z
047B: 5F          ld   e,a
047C: DD 7E 00    ld   a,(ix+character_x_00)
047F: 4F          ld   c,a
0480: FE 10       cp   $10
0482: D8          ret  c
0483: FE E0       cp   $E0
0485: D0          ret  nc
0486: 16 00       ld   d,$00
0488: 21 10 82    ld   hl,red_door_position_array_8210
048B: 19          add  hl,de
048C: 46          ld   b,(hl)
048D: 04          inc  b
048E: AF          xor  a
048F: 3D          dec  a
0490: 1F          rra
0491: 10 FD       djnz $0490
0493: 21 F1 81    ld   hl,$81F1
0496: 19          add  hl,de
0497: A6          and  (hl)
0498: 57          ld   d,a
0499: 79          ld   a,c
049A: DD 86 01    add  a,(ix+character_x_right_01)
049D: 1F          rra
049E: 4F          ld   c,a
049F: FE 7B       cp   $7B
04A1: 30 1B       jr   nc,$04BE
04A3: 06 04       ld   b,$04
04A5: 1E 00       ld   e,$00
04A7: 3E 08       ld   a,$08
04A9: C6 18       add  a,$18
04AB: CB 02       rlc  d
04AD: 30 03       jr   nc,$04B2
04AF: B9          cp   c
04B0: 30 27       jr   nc,$04D9
04B2: 1C          inc  e
04B3: 10 F4       djnz $04A9
04B5: 1D          dec  e
04B6: CB 0A       rrc  d
04B8: 38 1F       jr   c,$04D9
04BA: D6 18       sub  $18
04BC: 18 F7       jr   $04B5
04BE: 06 04       ld   b,$04
04C0: 1E 07       ld   e,$07
04C2: 3E F0       ld   a,$F0
04C4: D6 18       sub  $18
04C6: CB 0A       rrc  d
04C8: 30 03       jr   nc,$04CD
04CA: B9          cp   c
04CB: 38 0C       jr   c,$04D9
04CD: 1D          dec  e
04CE: 10 F4       djnz $04C4
04D0: 1C          inc  e
04D1: CB 02       rlc  d
04D3: 38 04       jr   c,$04D9
04D5: C6 18       add  a,$18
04D7: 18 F7       jr   $04D0
04D9: D6 04       sub  $04
04DB: DD 77 1A    ld   (ix+$1a),a
04DE: DD 36 1C 0C ld   (ix+$1c),$0C
04E2: DD 73 1D    ld   (ix+$1d),e
04E5: C9          ret
04E6: DD 7E 12    ld   a,(ix+$12)
04E9: E6 03       and  $03
04EB: FE 03       cp   $03
04ED: 20 20       jr   nz,$050F
04EF: CD 29 05    call $0529
04F2: 06 0A       ld   b,$0A
04F4: DD 7E 10    ld   a,(ix+$10)
04F7: B7          or   a
04F8: 28 02       jr   z,$04FC
04FA: 06 07       ld   b,$07
04FC: 48          ld   c,b
04FD: CD F5 1D    call pseudo_random_1DF5
0500: FE 40       cp   $40
0502: 38 03       jr   c,$0507
0504: 79          ld   a,c
0505: 87          add  a,a
0506: 4F          ld   c,a
0507: CD 3E 1E    call get_random_value_1e3e
050A: 81          add  a,c
050B: DD 77 10    ld   (ix+$10),a
050E: C9          ret
050F: DD 36 12 03 ld   (ix+$12),$03
0513: 06 0A       ld   b,$0A
0515: 0E 14       ld   c,$14
0517: DD 7E 0E    ld   a,(ix+$0e)
051A: B7          or   a
051B: 28 04       jr   z,$0521
051D: 06 08       ld   b,$08
051F: 0E 0F       ld   c,$0F
0521: CD 3E 1E    call get_random_value_1e3e
0524: 81          add  a,c
0525: DD 77 10    ld   (ix+$10),a
0528: C9          ret

0529: 21 48 05    ld   hl,table_0548
052C: DD 7E 0E    ld   a,(ix+$0e)
052F: B7          or   a
0530: 28 03       jr   z,$0535
0532: 21 58 05    ld   hl,$0558
0535: DD 5E 13    ld   e,(ix+enemy_aggressivity_13)
0538: 16 00       ld   d,$00
053A: 19          add  hl,de
053B: CD F5 1D    call pseudo_random_1DF5
053E: BE          cp   (hl)
053F: 06 00       ld   b,$00
0541: 30 01       jr   nc,$0544
0543: 04          inc  b
0544: DD 70 12    ld   (ix+$12),b
0547: C9          ret

table_0548:
	dc.b	00   
	dc.b	00   
	dc.b	10 10
	dc.b	20 20
	dc.b	30 30
	dc.b	40   
	dc.b	40   
	dc.b	50   
	dc.b	50   
	dc.b	60   
	dc.b	60   
	dc.b	70   
	dc.b	70   
	dc.b	00   
	dc.b	10 20
	dc.b	30 40
	dc.b	50   
	dc.b	60   
	dc.b	70   
	dc.b	80   
	dc.b	90   
	dc.b	A0   
	dc.b	B0   
	dc.b	C0   
	dc.b	D0   
	dc.b	E0   
	dc.b	F0   

should_enemy_shoot_0568:
0568: DD 7E 0E    ld   a,(ix+$0e)
056B: B7          or   a
056C: 20 10       jr   nz,$057E
056E: 3A 1A 85    ld   a,(player_structure_851A)
0571: DD 96 00    sub  (ix+character_x_00)
0574: 3F          ccf
0575: 17          rla
0576: E6 01       and  $01
0578: DD BE 0B    cp   (ix+$0b)
057B: C2 8E 05    jp   nz,enemy_doesnt_shoot_058e
057E: 3A 20 85    ld   a,(player_structure_851A+character_situation_06)
0581: FE 03       cp   CS_FALLING_03
0583: D0          ret  nc
; walking, elevator or falling
0584: CD E1 05    call $05E1
0587: D0          ret  nc
0588: CD 90 05    call does_facing_enemy_see_player_0590
058B: C9          ret

enemy_shoots_058c:
058C: 37          scf
058D: C9          ret

enemy_doesnt_shoot_058e:
058E: AF          xor  a
058F: C9          ret

does_facing_enemy_see_player_0590:
0590: 3A 21 85    ld   a,(player_structure_851A+0x07)
0593: 47          ld   b,a
0594: FE 12       cp   $12
0596: 20 16       jr   nz,$05AE
0598: 3A 1A 85    ld   a,(player_structure_851A)
059B: FE 7D       cp   $7D
059D: 38 29       jr   c,$05C8
059F: DD 7E 07    ld   a,(ix+$07)
05A2: FE 12       cp   $12
05A4: C2 8E 05    jp   nz,enemy_doesnt_shoot_058e
05A7: DD 7E 00    ld   a,(ix+character_x_00)
05AA: FE 7D       cp   $7D
05AC: 3F          ccf
05AD: C9          ret
05AE: 78          ld   a,b
05AF: FE 14       cp   $14
05B1: 20 15       jr   nz,$05C8
05B3: 3A 1A 85    ld   a,(player_structure_851A)
05B6: FE AC       cp   $AC
05B8: 38 0E       jr   c,$05C8
05BA: DD 7E 07    ld   a,(ix+$07)
05BD: FE 14       cp   $14
05BF: 20 CD       jr   nz,enemy_doesnt_shoot_058e
05C1: DD 7E 00    ld   a,(ix+character_x_00)
05C4: FE AC       cp   $AC
05C6: 3F          ccf
05C7: C9          ret
05C8: DD 7E 07    ld   a,(ix+$07)
05CB: 47          ld   b,a
05CC: FE 12       cp   $12
05CE: 20 06       jr   nz,$05D6
05D0: DD 7E 00    ld   a,(ix+character_x_00)
05D3: FE 7D       cp   $7D
05D5: C9          ret
05D6: 78          ld   a,b
05D7: FE 14       cp   $14
05D9: 20 B1       jr   nz,enemy_shoots_058c
05DB: DD 7E 00    ld   a,(ix+character_x_00)
05DE: FE AC       cp   $AC
05E0: C9          ret
05E1: 3A 30 85    ld   a,($8530)
05E4: DD BE 16    cp   (ix+$16)
05E7: 38 04       jr   c,$05ED
05E9: DD BE 15    cp   (ix+$15)
05EC: C9          ret
05ED: 3A 2F 85    ld   a,($852F)
05F0: DD BE 16    cp   (ix+$16)
05F3: 3F          ccf
05F4: C9          ret
05F5: CD F5 1D    call pseudo_random_1DF5
05F8: 21 59 06    ld   hl,odds_table_0659
05FB: DD 5E 13    ld   e,(ix+enemy_aggressivity_13)
05FE: 16 00       ld   d,$00
0600: 19          add  hl,de
0601: BE          cp   (hl)
0602: D0          ret  nc
0603: FD 21 FD 82 ld   iy,$82FD
0607: DD 7E 01    ld   a,(ix+character_x_right_01)
060A: DD 86 00    add  a,(ix+character_x_00)
060D: CB 1F       rr   a
060F: 4F          ld   c,a
0610: 06 03       ld   b,$03
0612: 11 08 00    ld   de,protection_crap_0008
0615: FD 7E 02    ld   a,(iy+$02)
0618: 3C          inc  a
0619: 28 22       jr   z,$063D
061B: FD 7E 00    ld   a,(iy+$00)
061E: DD BE 07    cp   (ix+$07)
0621: 20 1A       jr   nz,$063D
0623: FD 7E 01    ld   a,(iy+$01)
0626: FE 1F       cp   $1F
0628: 30 13       jr   nc,$063D
062A: FE 0C       cp   $0C
062C: 38 0F       jr   c,$063D
062E: FD 7E 04    ld   a,(iy+character_state_04)
0631: FD 86 03    add  a,(iy+$03)
0634: 91          sub  c
0635: 30 02       jr   nc,$0639
0637: ED 44       neg
0639: FE 14       cp   $14
063B: 38 05       jr   c,$0642
063D: FD 19       add  iy,de
063F: 10 D4       djnz $0615
0641: C9          ret
0642: FD 7E 01    ld   a,(iy+$01)
0645: 06 01       ld   b,$01
0647: FE 15       cp   $15
0649: 30 01       jr   nc,$064C
064B: 04          inc  b
064C: DD 7E 12    ld   a,(ix+$12)
064F: E6 04       and  $04
0651: B0          or   b
0652: DD 77 12    ld   (ix+$12),a
0655: CD 69 06    call $0669
0658: C9          ret

table_0659:
	dc.b	00    
	dc.b	00    
	dc.b	02    
	dc.b	02    
	dc.b	04    
	dc.b	08    
	dc.b	10 10 
	dc.b	20 20 
	dc.b	40    
	dc.b	40    
	dc.b	60    
	dc.b	80    
	dc.b	C4 FF
	
0669: DD 7E 12    ld   a,(ix+$12)                                     
066C: E6 03       and  $03
066E: FE 02       cp   $02
0670: C0          ret  nz
0671: DD 7E 00    ld   a,(ix+character_x_00)
0674: FE 10       cp   $10
0676: 38 32       jr   c,$06AA
0678: FE F0       cp   $F0
067A: 30 2E       jr   nc,$06AA
067C: DD 7E 07    ld   a,(ix+$07)
067F: B7          or   a
0680: C8          ret  z
0681: FE 06       cp   $06
0683: 38 07       jr   c,$068C
0685: 28 10       jr   z,$0697
0687: FE 07       cp   $07
0689: 28 16       jr   z,$06A1
068B: C9          ret
068C: DD 7E 00    ld   a,(ix+character_x_00)
068F: FE 41       cp   $41
0691: D8          ret  c
0692: FE B4       cp   $B4
0694: D0          ret  nc
0695: 18 13       jr   $06AA
0697: DD 7E 00    ld   a,(ix+character_x_00)
069A: FE 41       cp   $41
069C: D8          ret  c
069D: FE 5A       cp   $5A
069F: 38 09       jr   c,$06AA
06A1: DD 7E 00    ld   a,(ix+character_x_00)
06A4: FE A0       cp   $A0
06A6: D8          ret  c
06A7: FE B4       cp   $B4
06A9: D0          ret  nc
06AA: DD 7E 12    ld   a,(ix+$12)
06AD: E6 04       and  $04
06AF: 3C          inc  a
06B0: DD 77 12    ld   (ix+$12),a
06B3: C9          ret
06B4: CD 55 07    call $0755
06B7: 3A 30 80    ld   a,($8030)
06BA: FE 0C       cp   $0C
06BC: CA FC 06    jp   z,$06FC
06BF: CD 8F 07    call $078F
06C2: 15          dec  d
06C3: C2 D1 06    jp   nz,$06D1
06C6: 06 04       ld   b,$04
06C8: DD 7E 04    ld   a,(ix+$04)
06CB: DD 96 03    sub  (ix+character_y_offset_03)
06CE: C3 CD 07    jp   $07CD
06D1: DD 7E 01    ld   a,(ix+character_x_right_01)
06D4: FE 06       cp   $06
06D6: D2 F6 06    jp   nc,$06F6
06D9: FD 7E 05    ld   a,(iy+$05)
06DC: DD BE 04    cp   (ix+$04)
06DF: D2 E7 06    jp   nc,$06E7
06E2: 06 04       ld   b,$04
06E4: C3 CD 07    jp   $07CD
06E7: DD 7E 04    ld   a,(ix+$04)
06EA: FD BE 04    cp   (iy+character_state_04)
06ED: D0          ret  nc
06EE: FD 7E 04    ld   a,(iy+character_state_04)
06F1: 06 04       ld   b,$04
06F3: C3 CD 07    jp   $07CD
06F6: DD 7E 00    ld   a,(ix+character_x_00)
06F9: FE 1F       cp   $1F
06FB: C0          ret  nz
06FC: DD 7E 03    ld   a,(ix+character_y_offset_03)
06FF: B7          or   a
0700: F2 29 07    jp   p,$0729
0703: 21 2F 80    ld   hl,$802F
0706: 5E          ld   e,(hl)
0707: DD 7E 04    ld   a,(ix+$04)
070A: DD 96 03    sub  (ix+character_y_offset_03)
070D: DD 86 03    add  a,(ix+character_y_offset_03)
0710: D2 4F 07    jp   nc,$074F
0713: BB          cp   e
0714: D0          ret  nc
0715: 2B          dec  hl
0716: 7E          ld   a,(hl)
0717: FE 0B       cp   $0B
0719: CA 4F 07    jp   z,$074F
071C: CD 8F 07    call $078F
071F: 15          dec  d
0720: C0          ret  nz
0721: FD 7E 05    ld   a,(iy+$05)
0724: 06 04       ld   b,$04
0726: C3 CD 07    jp   $07CD
0729: 21 31 80    ld   hl,$8031
072C: 5E          ld   e,(hl)
072D: DD 7E 04    ld   a,(ix+$04)
0730: DD 96 03    sub  (ix+character_y_offset_03)
0733: DD 86 03    add  a,(ix+character_y_offset_03)
0736: DA 4F 07    jp   c,$074F
0739: BB          cp   e
073A: D8          ret  c
073B: 23          inc  hl
073C: 7E          ld   a,(hl)
073D: FE 0B       cp   $0B
073F: CA 4F 07    jp   z,$074F
0742: CD 8F 07    call $078F
0745: 15          dec  d
0746: C0          ret  nz
0747: FD 7E 04    ld   a,(iy+character_state_04)
074A: 06 04       ld   b,$04
074C: C3 CD 07    jp   $07CD
074F: 7B          ld   a,e
0750: 06 04       ld   b,$04
0752: C3 CD 07    jp   $07CD
0755: CD 7A 07    call $077A
0758: 0E 0B       ld   c,$0B
075A: 23          inc  hl
075B: 46          ld   b,(hl)
075C: 23          inc  hl
075D: DD 7E 04    ld   a,(ix+$04)
0760: DD 96 03    sub  (ix+character_y_offset_03)
0763: BE          cp   (hl)
0764: DA 6E 07    jp   c,$076E
0767: 23          inc  hl
0768: 48          ld   c,b
0769: 46          ld   b,(hl)
076A: 23          inc  hl
076B: C3 63 07    jp   $0763
076E: 11 32 80    ld   de,$8032
0771: 79          ld   a,c
0772: 23          inc  hl
0773: 01 04 00    ld   bc,$0004
0776: ED B8       lddr
0778: 12          ld   (de),a
0779: C9          ret

077A: 21 CE 81    ld   hl,$81CE
077D: DD 7E 00    ld   a,(ix+character_x_00)
0780: B7          or   a
0781: C8          ret  z
0782: 87          add  a,a
0783: 87          add  a,a
0784: 6F          ld   l,a
0785: 26 00       ld   h,$00
0787: 29          add  hl,hl
0788: 29          add  hl,hl
0789: 29          add  hl,hl
078A: 11 E3 16    ld   de,table_16E3
078D: 19          add  hl,de
078E: C9          ret

078F: CD C0 07    call $07C0
0792: 16 00       ld   d,$00
0794: DD 7E 00    ld   a,(ix+character_x_00)
0797: C6 02       add  a,$02
0799: FD 96 01    sub  (iy+$01)
079C: D8          ret  c
079D: 4F          ld   c,a
079E: DD 7E 01    ld   a,(ix+character_x_right_01)
07A1: FD 96 00    sub  (iy+$00)
07A4: D2 AB 07    jp   nc,$07AB
07A7: C6 30       add  a,$30
07A9: 0D          dec  c
07AA: F8          ret  m
07AB: FE 06       cp   $06
07AD: D0          ret  nc
07AE: 79          ld   a,c
07AF: FE 04       cp   $04
07B1: D0          ret  nc
07B2: 16 01       ld   d,$01
07B4: FD 7E 06    ld   a,(iy+$06)
07B7: B7          or   a
07B8: C0          ret  nz
07B9: 79          ld   a,c
07BA: FE 02       cp   $02
07BC: D0          ret  nc
07BD: 16 00       ld   d,$00
07BF: C9          ret
07C0: 87          add  a,a
07C1: 87          add  a,a
07C2: 87          add  a,a
07C3: 5F          ld   e,a
07C4: 16 00       ld   d,$00
07C6: FD 21 7D 83 ld   iy,elevator_array_837D
07CA: FD 19       add  iy,de
07CC: C9          ret
07CD: 4F          ld   c,a
07CE: DD 7E 03    ld   a,(ix+character_y_offset_03)
07D1: B7          or   a
07D2: F2 DC 07    jp   p,$07DC
07D5: 3A 38 83    ld   a,($8338)
07D8: B9          cp   c
07D9: DA E1 07    jp   c,$07E1
07DC: 3A 38 83    ld   a,($8338)
07DF: B9          cp   c
07E0: D8          ret  c
07E1: 79          ld   a,c
07E2: 32 38 83    ld   ($8338),a
07E5: 78          ld   a,b
07E6: 32 39 83    ld   ($8339),a
07E9: FD 22 3A 83 ld   ($833A),iy
07ED: C9          ret
07EE: DD 7E 01    ld   a,(ix+character_x_right_01)
07F1: FE 06       cp   $06
07F3: D8          ret  c
07F4: FE 22       cp   $22
07F6: D0          ret  nc
07F7: FD 21 AD 80 ld   iy,$80AD
07FB: 3A 54 81    ld   a,($8154)
07FE: CD 08 08    call $0808
0801: FD 21 B5 80 ld   iy,$80B5
0805: 3A 5E 81    ld   a,($815E)
0808: FE 60       cp   $60
080A: C8          ret  z
080B: 3C          inc  a
080C: C8          ret  z
080D: FD 7E 05    ld   a,(iy+$05)
0810: B7          or   a
0811: F8          ret  m
0812: FE 01       cp   $01
0814: D8          ret  c
0815: FD 7E 02    ld   a,(iy+$02)
0818: DD BE 00    cp   (ix+character_x_00)
081B: C0          ret  nz
081C: DD 56 03    ld   d,(ix+character_y_offset_03)
081F: 7A          ld   a,d
0820: B7          or   a
0821: F2 38 08    jp   p,$0838
0824: DD 7E 04    ld   a,(ix+$04)
0827: 5F          ld   e,a
0828: DD 96 03    sub  (ix+character_y_offset_03)
082B: 57          ld   d,a
082C: FD 7E 01    ld   a,(iy+$01)
082F: BA          cp   d
0830: D0          ret  nc
0831: BB          cp   e
0832: D8          ret  c
0833: 06 04       ld   b,$04
0835: C3 CD 07    jp   $07CD
0838: DD 7E 04    ld   a,(ix+$04)
083B: 5F          ld   e,a
083C: DD 96 03    sub  (ix+character_y_offset_03)
083F: 57          ld   d,a
0840: FD 7E 00    ld   a,(iy+$00)
0843: BA          cp   d
0844: D8          ret  c
0845: BB          cp   e
0846: D0          ret  nc
0847: 06 04       ld   b,$04
0849: C3 CD 07    jp   $07CD
084C: 3A 40 82    ld   a,(lamp_shot_state_8240)
084F: 3C          inc  a
0850: C0          ret  nz
0851: DD 7E 01    ld   a,(ix+character_x_right_01)
0854: FE 2A       cp   $2A
0856: D8          ret  c
0857: DD 5E 04    ld   e,(ix+$04)
085A: 7B          ld   a,e
085B: DD 96 03    sub  (ix+character_y_offset_03)
085E: 57          ld   d,a
085F: 93          sub  e
0860: FA 7C 08    jp   m,$087C
0863: 0E 4F       ld   c,$4F
0865: 06 02       ld   b,$02
0867: 79          ld   a,c
0868: BA          cp   d
0869: D2 70 08    jp   nc,$0870
086C: BB          cp   e
086D: D4 95 08    call nc,$0895
0870: 0E AF       ld   c,$AF
0872: 06 01       ld   b,$01
0874: 79          ld   a,c
0875: BA          cp   d
0876: D0          ret  nc
0877: BB          cp   e
0878: D2 95 08    jp   nc,$0895
087B: C9          ret
087C: 0E A8       ld   c,$A8
087E: 06 01       ld   b,$01
0880: 79          ld   a,c
0881: BA          cp   d
0882: DA 89 08    jp   c,$0889
0885: BB          cp   e
0886: DC 95 08    call c,$0895
0889: 0E 48       ld   c,$48
088B: 06 02       ld   b,$02
088D: 79          ld   a,c
088E: BA          cp   d
088F: D8          ret  c
0890: BB          cp   e
0891: DA 95 08    jp   c,$0895
0894: C9          ret
0895: DD 7E 00    ld   a,(ix+character_x_00)
0898: D6 08       sub  $08
089A: D8          ret  c
089B: FE 17       cp   $17
089D: D0          ret  nc
089E: D9          exx
089F: 21 DA 81    ld   hl,$81DA
08A2: 5F          ld   e,a
08A3: 16 00       ld   d,$00
08A5: 19          add  hl,de
08A6: 7E          ld   a,(hl)
08A7: D9          exx
08A8: A0          and  b
08A9: C8          ret  z
08AA: 06 03       ld   b,$03
08AC: FD 21 3E 82 ld   iy,$823E
08B0: 79          ld   a,c
08B1: C3 CD 07    jp   $07CD
08B4: DD 7E 07    ld   a,(ix+$07)
08B7: B7          or   a
08B8: CA D2 08    jp   z,enemies_shot_collision_08D2
08BB: 3A 50 82    ld   a,(copy_of_dip_switches_3_8250)
08BE: CB 77       bit  6,a
08C0: C0          ret  nz
08C1: FD 21 1A 85 ld   iy,player_structure_851A
08C5: CD F8 08    call enemy_shot_collision_08F8
08C8: 3A 39 83    ld   a,($8339)
08CB: B7          or   a
08CC: C8          ret  z
08CD: AF          xor  a
08CE: 32 EB 82    ld   ($82EB),a
08D1: C9          ret

enemies_shot_collision_08D2: 
08D2: FD 21 3A 85 ld   iy,enemy_1_853A
08D6: CD F8 08    call enemy_shot_collision_08F8
08D9: FD 21 5A 85 ld   iy,enemy_2_855A
08DD: CD F8 08    call enemy_shot_collision_08F8
08E0: FD 21 7A 85 ld   iy,enemy_3_857A
08E4: CD F8 08    call enemy_shot_collision_08F8
08E7: FD 21 9A 85 ld   iy,enemy_4_859A
08EB: CD F8 08    call enemy_shot_collision_08F8
08EE: 3A 39 83    ld   a,($8339)
08F1: B7          or   a
08F2: C8          ret  z
08F3: AF          xor  a
08F4: 32 EC 82    ld   ($82EC),a
08F7: C9          ret

* check collision enemies / player bullets
enemy_shot_collision_08F8:
08F8: FD 7E 04    ld   a,(iy+character_state_04)
08FB: FE 02       cp   $02
08FD: C0          ret  nz
* character is active
08FE: FD 7E 09    ld   a,(iy+$09)
0901: FE 05       cp   $05
0903: C8          ret  z
0904: FD 7E 06    ld   a,(iy+$06)
0907: B7          or   a
0908: 28 16       jr   z,$0920
090A: D6 03       sub  $03
090C: 28 12       jr   z,$0920
090E: DA 5C 09    jp   c,$095C
0911: FE 04       cp   $04
0913: C8          ret  z
0914: FD 7E 0A    ld   a,(iy+$0a)
0917: B7          or   a
0918: F2 1D 09    jp   p,$091D
091B: ED 44       neg
091D: FE 02       cp   $02
091F: D0          ret  nc
0920: FD 7E 07    ld   a,(iy+$07)
0923: DD BE 00    cp   (ix+character_x_00)
0926: C0          ret  nz
0927: DD 7E 01    ld   a,(ix+character_x_right_01)
092A: FD BE 02    cp   (iy+$02)
092D: D0          ret  nc
092E: FD BE 03    cp   (iy+$03)
0931: D8          ret  c
0932: DD 5E 04    ld   e,(ix+$04)
0935: 7B          ld   a,e
0936: DD 96 03    sub  (ix+character_y_offset_03)
0939: 57          ld   d,a
093A: 93          sub  e
093B: FA 4D 09    jp   m,$094D
093E: 14          inc  d
093F: 14          inc  d
0940: 14          inc  d
0941: FD 7E 01    ld   a,(iy+$01)
0944: BA          cp   d
0945: D0          ret  nc
0946: BB          cp   e
0947: D8          ret  c
0948: 06 01       ld   b,$01
094A: C3 CD 07    jp   $07CD
094D: FD 7E 00    ld   a,(iy+$00)
0950: 15          dec  d
0951: 15          dec  d
0952: 15          dec  d
0953: BA          cp   d
0954: D8          ret  c
0955: BB          cp   e
0956: D0          ret  nc
0957: 06 01       ld   b,$01
0959: C3 CD 07    jp   $07CD
095C: 21 7D 83    ld   hl,elevator_array_837D
095F: FD 7E 08    ld   a,(iy+$08)
0962: E6 7F       and  $7F
0964: 87          add  a,a
0965: 87          add  a,a
0966: 87          add  a,a
0967: 5F          ld   e,a
0968: 16 00       ld   d,$00
096A: 19          add  hl,de
096B: 4E          ld   c,(hl)
096C: 23          inc  hl
096D: 46          ld   b,(hl)
096E: FD 7E 08    ld   a,(iy+$08)
0971: E6 80       and  $80
0973: CA 78 09    jp   z,$0978
0976: 05          dec  b
0977: 05          dec  b
0978: 78          ld   a,b
0979: FD 86 06    add  a,(iy+$06)
097C: DD 96 00    sub  (ix+character_x_00)
097F: D8          ret  c
0980: FE 02       cp   $02
0982: D0          ret  nc
0983: 06 00       ld   b,$00
0985: B7          or   a
0986: CA 8B 09    jp   z,$098B
0989: 06 30       ld   b,$30
098B: 78          ld   a,b
098C: 81          add  a,c
098D: FD 86 03    add  a,(iy+$03)
0990: 57          ld   d,a
0991: 78          ld   a,b
0992: 81          add  a,c
0993: FD 86 02    add  a,(iy+$02)
0996: 5F          ld   e,a
0997: DD 7E 01    ld   a,(ix+character_x_right_01)
099A: C6 30       add  a,$30
099C: BA          cp   d
099D: D8          ret  c
099E: BB          cp   e
099F: D0          ret  nc
09A0: C3 32 09    jp   $0932

check_if_all_documents_collected_09A3:
09A3: AF          xor  a
09A4: 32 AB 80    ld   ($80AB),a
09A7: CD D8 0A    call $0AD8
09AA: CD 4D 36    call $364D
09AD: 3E C0       ld   a,$C0
09AF: 32 0B D5    ld   (sound_latch_D50B),a
09B2: CD E5 45    call ground_floor_reached_45E5
; check if all documents have been collected, starting by the top floor
09B5: 21 2E 82    ld   hl,red_door_position_array_8210+$1E
09B8: 06 1E       ld   b,$1E
09BA: 7E          ld   a,(hl)
09BB: FE 08       cp   $08
09BD: 20 06       jr   nz,$09C5
09BF: 2B          dec  hl
09C0: 10 F8       djnz $09BA
09C2: C3 D3 09    jp   $09D3
; a document was not retrieved
09C5: 78          ld   a,b
09C6: 32 2C 80    ld   ($802C),a
09C9: AF          xor  a
09CA: 32 32 85    ld   ($8532),a
09CD: 32 2C 85    ld   ($852C),a
09D0: C3 15 0A    jp   $0A15

09D3: 3A 33 80    ld   a,($8033)
09D6: B7          or   a
09D7: 20 0F       jr   nz,$09E8
09D9: 3A 1A 85    ld   a,(player_structure_851A)
09DC: FE 34       cp   $34
09DE: 38 05       jr   c,$09E5
09E0: CD 21 0B    call $0B21
09E3: 18 03       jr   $09E8
09E5: CD 31 0B    call $0B31
09E8: CD 7F 01    call handle_main_scrolling_017F
09EB: CD F0 0A    call $0AF0
09EE: CD BF 0E    call handle_elevators_0EBF
09F1: CD A2 12    call handle_enemies_12A2
09F4: CD E8 2F    call $2FE8
09F7: CD E1 0B    call $0BE1
09FA: CD A0 15    call update_sprite_shadow_ram_15a0
09FD: CD CF 73    call game_tick_73cf
0A00: 3A 33 80    ld   a,($8033)
0A03: FE FF       cp   $FF
0A05: 20 CC       jr   nz,$09D3
0A07: CD F9 56    call award_end_of_level_bonus_56F9
0A0A: 21 37 82    ld   hl,skill_level_8237
0A0D: 34          inc  (hl)					; increase difficulty level on level completed
0A0E: 3E 1E       ld   a,$1E
0A10: 32 2C 80    ld   ($802C),a
0A13: AF          xor  a
0A14: C9          ret

0A15: 21 2C 85    ld   hl,$852C
0A18: 7E          ld   a,(hl)
0A19: FE 1E       cp   $1E
0A1B: 38 4F       jr   c,$0A6C
0A1D: 3E FF       ld   a,$FF
0A1F: 32 1E 85    ld   ($851E),a
0A22: 32 F1 80    ld   ($80F1),a
0A25: 32 F6 80    ld   ($80F6),a
0A28: AF          xor  a
0A29: 32 20 85    ld   ($8520),a
0A2C: 3A 2C 80    ld   a,($802C)
0A2F: 32 21 85    ld   (player_structure_851A+current_floor_07),a
0A32: 3E 01       ld   a,$01
0A34: 32 A9 80    ld   (timer_8bit_reload_value_80A9),a
0A37: CD 03 0B    call $0B03
0A3A: 21 32 85    ld   hl,$8532
0A3D: 3A 04 80    ld   a,(scroll_speed_8004)
0A40: B7          or   a
0A41: 20 01       jr   nz,$0A44
0A43: 34          inc  (hl)
0A44: 7E          ld   a,(hl)
0A45: FE 14       cp   $14
0A47: 38 0B       jr   c,$0A54
0A49: 3E 39       ld   a,$39
0A4B: 32 0B D5    ld   (sound_latch_D50B),a
0A4E: CD 72 2F    call set_player_initial_state_2f72
0A51: 3E 01       ld   a,$01
0A53: C9          ret
0A54: CD 06 02    call update_scrolling_playfield_0206
0A57: CD F0 0A    call $0AF0
0A5A: CD BF 0E    call handle_elevators_0EBF
0A5D: CD A2 12    call handle_enemies_12A2
0A60: CD E1 0B    call $0BE1
0A63: CD A0 15    call update_sprite_shadow_ram_15a0
0A66: CD CF 73    call game_tick_73cf
0A69: C3 15 0A    jp   $0A15
0A6C: 3A 23 85    ld   a,(player_structure_851A+9)
0A6F: FE 03       cp   $03
0A71: 38 04       jr   c,$0A77
0A73: 7E          ld   a,(hl)
0A74: B7          or   a
0A75: 28 3E       jr   z,$0AB5
0A77: AF          xor  a
0A78: 32 1F 85    ld   ($851F),a
0A7B: 32 25 85    ld   ($8525),a
0A7E: 7E          ld   a,(hl)
0A7F: 34          inc  (hl)
0A80: FE 04       cp   $04
0A82: 38 1F       jr   c,$0AA3
0A84: CC D0 0A    call z,play_missing_document_end_sound_0ad0
0A87: FE 09       cp   $09
0A89: 30 20       jr   nc,$0AAB
0A8B: 21 23 81    ld   hl,$8123
0A8E: 36 00       ld   (hl),$00
0A90: 23          inc  hl
0A91: 3A F2 80    ld   a,($80F2)
0A94: C6 09       add  a,$09
0A96: 77          ld   (hl),a
0A97: 23          inc  hl
0A98: 36 67       ld   (hl),$67
0A9A: 23          inc  hl
0A9B: 36 00       ld   (hl),$00
0A9D: 23          inc  hl
0A9E: 36 7D       ld   (hl),$7D
0AA0: C3 B5 0A    jp   $0AB5
0AA3: 3E 10       ld   a,$10
0AA5: 32 27 85    ld   (player_move_direction_8527),a	; force fire??
0AA8: C3 B5 0A    jp   $0AB5
0AAB: 3E 00       ld   a,$00
0AAD: 32 27 85    ld   (player_move_direction_8527),a	; no move
0AB0: 21 23 81    ld   hl,$8123
0AB3: 36 FF       ld   (hl),$FF
0AB5: CD 06 02    call update_scrolling_playfield_0206
0AB8: CD F0 0A    call $0AF0
0ABB: CD BF 0E    call handle_elevators_0EBF
0ABE: CD A2 12    call handle_enemies_12A2
0AC1: CD E8 2F    call $2FE8
0AC4: CD E1 0B    call $0BE1
0AC7: CD A0 15    call update_sprite_shadow_ram_15a0
0ACA: CD CF 73    call game_tick_73cf
0ACD: C3 15 0A    jp   $0A15

play_missing_document_end_sound_0ad0:
0AD0: F5          push af
0AD1: 3E 38       ld   a,$38
0AD3: 32 0B D5    ld   (sound_latch_D50B),a
0AD6: F1          pop  af
0AD7: C9          ret
0AD8: 21 FB 80    ld   hl,$80FB
0ADB: 11 05 00    ld   de,$0005
0ADE: 06 08       ld   b,$08
0AE0: 36 FF       ld   (hl),$FF
0AE2: 19          add  hl,de
0AE3: 10 FB       djnz $0AE0
0AE5: 21 23 81    ld   hl,$8123
0AE8: 06 07       ld   b,$07
0AEA: 36 FF       ld   (hl),$FF
0AEC: 19          add  hl,de
0AED: 10 FB       djnz $0AEA
0AEF: C9          ret
0AF0: 21 81 80    ld   hl,elevator_directions_array_8081
0AF3: 3A 2D 80    ld   a,($802D)
0AF6: 3C          inc  a
0AF7: 87          add  a,a
0AF8: 3C          inc  a
0AF9: 5F          ld   e,a
0AFA: 16 00       ld   d,$00
0AFC: 19          add  hl,de
0AFD: 7E          ld   a,(hl)
0AFE: B7          or   a
0AFF: C8          ret  z
0B00: 36 0A       ld   (hl),$0A
0B02: C9          ret
0B03: 3E 00       ld   a,$00
0B05: 32 04 80    ld   (scroll_speed_8004),a
0B08: 3A 2C 80    ld   a,($802C)
0B0B: 47          ld   b,a
0B0C: 0E 00       ld   c,$00
0B0E: 16 06       ld   d,$06
0B10: CD 6C 1E    call compute_delta_height_1e6c
0B13: 11 6E 00    ld   de,$006E
0B16: AF          xor  a
0B17: ED 52       sbc  hl,de
0B19: C8          ret  z
0B1A: D8          ret  c
0B1B: 3E 02       ld   a,$02
0B1D: 32 04 80    ld   (scroll_speed_8004),a
0B20: C9          ret
0B21: 06 08       ld   b,$08
0B23: 3A 23 85    ld   a,(player_structure_851A+9)
0B26: FE 02       cp   $02
0B28: 30 02       jr   nc,$0B2C
0B2A: 06 01       ld   b,$01
0B2C: 78          ld   a,b
0B2D: 32 27 85    ld   (player_move_direction_8527),a
0B30: C9          ret
0B31: FE 20       cp   $20
0B33: 38 17       jr   c,$0B4C
0B35: 06 00       ld   b,$00
0B37: FE 28       cp   $28
0B39: 30 02       jr   nc,$0B3D
0B3B: 06 01       ld   b,$01
0B3D: 3E 10       ld   a,$10
0B3F: 32 27 85    ld   (player_move_direction_8527),a
0B42: 3E FE       ld   a,$FE
0B44: 32 1F 85    ld   ($851F),a
0B47: 78          ld   a,b
0B48: 32 25 85    ld   ($8525),a
0B4B: C9          ret

0B4C: 3E FF       ld   a,$FF
0B4E: 32 1E 85    ld   ($851E),a
0B51: 32 23 85    ld   (player_structure_851A+9),a
0B54: 3E 01       ld   a,$01
0B56: 32 33 80    ld   ($8033),a
0B59: 3E 03       ld   a,$03
0B5B: 32 A9 80    ld   (timer_8bit_reload_value_80A9),a
0B5E: 3D          dec  a
0B5F: 32 AA 80    ld   (timer_8bit_80AA),a
0B62: 3E 00       ld   a,$00
0B64: 32 AB 80    ld   ($80AB),a
0B67: C9          ret

handle_enemes_0B68:
handle_enemies_0B68:
0B68: CD EB 58    call $58EB
0B6B: DD 21 3A 85 ld   ix,enemy_1_853A
0B6F: 21 32 81    ld   hl,$8132
0B72: 22 BD 85    ld   ($85BD),hl
0B75: 3E 01       ld   a,$01
0B77: 32 BA 85    ld   (current_enemy_index_85BA),a
; loop
0B7A: CD 98 0B    call $0B98
0B7D: 11 20 00    ld   de,$0020
0B80: DD 19       add  ix,de		; next enemy
0B82: 2A BD 85    ld   hl,($85BD)
0B85: 11 05 00    ld   de,$0005
0B88: 19          add  hl,de
0B89: 22 BD 85    ld   ($85BD),hl
0B8C: 3A BA 85    ld   a,(current_enemy_index_85BA)
0B8F: 3C          inc  a
0B90: 32 BA 85    ld   (current_enemy_index_85BA),a
0B93: FE 05       cp   $05
0B95: 20 E3       jr   nz,$0B7A
0B97: C9          ret

; < ix: enemy character structure
0B98: DD 36 17 00 ld   (ix+$17),$00
0B9C: DD 7E 09    ld   a,(ix+$09)
0B9F: B7          or   a
0BA0: F8          ret  m
0BA1: FE 05       cp   $05
0BA3: D0          ret  nc
0BA4: DD 7E 06    ld   a,(ix+character_situation_06)
0BA7: 4F          ld   c,a
0BA8: FE 03       cp   CS_FALLING_03
0BAA: D2 D1 0B    jp   nc,$0BD1
; ground, in/on elevator or unknown 3
0BAD: DD 7E 0F    ld   a,(ix+$0f)
0BB0: 47          ld   b,a
0BB1: 80          add  a,b
0BB2: 80          add  a,b
0BB3: 81          add  a,c
0BB4: 5F          ld   e,a
0BB5: 83          add  a,e
0BB6: 83          add  a,e
0BB7: 5F          ld   e,a
0BB8: 16 00       ld   d,$00
0BBA: 21 BF 0B    ld   hl,jump_table_0BBF
0BBD: 19          add  hl,de
0BBE: E9          jp   (hl)

jump_table_0BBF:
0BBF: C3 F6 53    jp   enemy_walk_state_53F6
0BC2: C3 A7 51    jp   enemy_unknown_state_51A7
0BC5: C3 4E 52    jp   enemy_above_elevator_524E
0BC8: C3 14 1C    jp   enemy_shooting_state_1C14
0BCB: C3 E3 1A    jp   enemy_in_elevator_1AE3
0BCE: C3 38 1B    jp   enemy_jumping_above_elevator_1B38  | ontop of elev too

0BD1: AF          xor  a
0BD2: DD 77 10    ld   (ix+$10),a
0BD5: DD 77 1A    ld   (ix+$1a),a
0BD8: DD 77 18    ld   (ix+$18),a
0BDB: C9          ret
0BDC: AF          xor  a
0BDD: 32 33 80    ld   ($8033),a
0BE0: C9          ret

0BE1: CD AD 0D    call $0DAD
0BE4: 3E FF       ld   a,$FF
0BE6: 32 46 81    ld   ($8146),a
0BE9: 32 4B 81    ld   ($814B),a
0BEC: 3A 33 80    ld   a,($8033)
0BEF: FE FF       cp   $FF
0BF1: C8          ret  z
0BF2: 3A 33 80    ld   a,($8033)
0BF5: B7          or   a
0BF6: CA 37 0C    jp   z,$0C37
0BF9: FE 01       cp   $01
0BFB: CC 31 0C    call z,$0C31
0BFE: 3A 33 80    ld   a,($8033)
0C01: D6 05       sub  $05
0C03: 32 36 80    ld   ($8036),a
0C06: DA 43 0C    jp   c,protection_0C43
0C09: D6 04       sub  $04
0C0B: 32 36 80    ld   ($8036),a
0C0E: DA 43 0C    jp   c,protection_0C43
0C11: D6 2C       sub  $2C
0C13: DA 81 0C    jp   c,$0C81
0C16: D6 03       sub  $03
0C18: 32 36 80    ld   ($8036),a
0C1B: DA 91 0C    jp   c,$0C91
0C1E: D6 03       sub  $03
0C20: 32 36 80    ld   ($8036),a
0C23: DA 91 0C    jp   c,$0C91
0C26: D6 03       sub  $03
0C28: 32 36 80    ld   ($8036),a
0C2B: DA 91 0C    jp   c,$0C91
0C2E: C3 AE 0C    jp   $0CAE
0C31: 3E C8       ld   a,$C8
0C33: 32 0B D5    ld   (sound_latch_D50B),a
0C36: C9          ret
0C37: 3E 00       ld   a,$00
0C39: 32 35 80    ld   ($8035),a
0C3C: 32 34 80    ld   ($8034),a
0C3F: CD CD 0C    call $0CCD
0C42: C9          ret

protection_0C43:
; the bootleg version NOPs the following
; bootleg: start NOP patch
protection_0C43:
0C43: D5          push de
0C44: 11 F6 82    ld   de,$82F6
0C47: 1B          dec  de
0C48: 1A          ld   a,(de)
0C49: A7          and  a
0C4A: CA 50 0C    jp   z,$0C50
0C4D: C3 81 0C    jp   $0C81
0C50: D1          pop  de
; bootleg: end NOP patch
0C51: 3E 02       ld   a,$02
0C53: 32 34 80    ld   ($8034),a
0C56: 3A 36 80    ld   a,($8036)
0C59: FE FF       cp   $FF
0C5B: CA 68 0C    jp   z,$0C68
0C5E: FE FC       cp   $FC
0C60: CA 68 0C    jp   z,$0C68
0C63: 3E 01       ld   a,$01
0C65: 32 34 80    ld   ($8034),a
0C68: CD CD 0C    call $0CCD
0C6B: CD 1B 0D    call $0D1B
0C6E: 3A 33 80    ld   a,($8033)
0C71: 3C          inc  a
0C72: 32 33 80    ld   ($8033),a
0C75: 3A 35 80    ld   a,($8035)
0C78: FE E0       cp   $E0
0C7A: C0          ret  nz
0C7B: 3E FF       ld   a,$FF
0C7D: 32 33 80    ld   ($8033),a
0C80: C9          ret
0C81: 3E 01       ld   a,$01
0C83: 32 34 80    ld   ($8034),a
0C86: 3A 35 80    ld   a,($8035)
0C89: C6 04       add  a,$04
0C8B: 32 35 80    ld   ($8035),a
0C8E: C3 68 0C    jp   $0C68
0C91: 3E 03       ld   a,$03
0C93: 32 34 80    ld   ($8034),a
0C96: 3A 36 80    ld   a,($8036)
0C99: FE FD       cp   $FD
0C9B: C2 68 0C    jp   nz,$0C68
0C9E: 3A 35 80    ld   a,($8035)
0CA1: C6 04       add  a,$04
0CA3: 32 35 80    ld   ($8035),a
0CA6: 3E 07       ld   a,$07
0CA8: 32 34 80    ld   ($8034),a
0CAB: C3 68 0C    jp   $0C68
0CAE: 3E 04       ld   a,$04
0CB0: 32 34 80    ld   ($8034),a
0CB3: 3A 35 80    ld   a,($8035)
0CB6: D6 04       sub  $04
0CB8: 32 35 80    ld   ($8035),a
0CBB: FE E0       cp   $E0
0CBD: DA 68 0C    jp   c,$0C68
0CC0: FE F0       cp   $F0
0CC2: D2 68 0C    jp   nc,$0C68
0CC5: 3E 06       ld   a,$06
0CC7: 32 34 80    ld   ($8034),a
0CCA: C3 68 0C    jp   $0C68
0CCD: 06 00       ld   b,$00
0CCF: 0E 00       ld   c,$00
0CD1: 16 06       ld   d,$06
0CD3: CD 6C 1E    call compute_delta_height_1e6c
0CD6: 7C          ld   a,h
0CD7: B7          or   a
0CD8: C0          ret  nz
0CD9: 3A 34 80    ld   a,($8034)
0CDC: 4D          ld   c,l
0CDD: 87          add  a,a
0CDE: 87          add  a,a
0CDF: 87          add  a,a
0CE0: 87          add  a,a
0CE1: 5F          ld   e,a
0CE2: 16 00       ld   d,$00
0CE4: 21 2D 0D    ld   hl,table_0D2D
0CE7: 19          add  hl,de
0CE8: 11 46 81    ld   de,$8146
0CEB: 06 03       ld   b,$03
0CED: CD 03 0D    call $0D03
0CF0: CD 03 0D    call $0D03
0CF3: 3A 34 80    ld   a,($8034)
0CF6: B7          or   a
0CF7: C8          ret  z
0CF8: 11 23 81    ld   de,$8123
0CFB: 06 02       ld   b,$02
0CFD: CD 03 0D    call $0D03
0D00: 11 F6 80    ld   de,$80F6
0D03: 78          ld   a,b
0D04: 12          ld   (de),a
0D05: 13          inc  de
0D06: 3A 35 80    ld   a,($8035)
0D09: 86          add  a,(hl)
0D0A: 23          inc  hl
0D0B: 12          ld   (de),a
0D0C: 13          inc  de
0D0D: 79          ld   a,c
0D0E: 86          add  a,(hl)
0D0F: 23          inc  hl
0D10: 12          ld   (de),a
0D11: 13          inc  de
0D12: 7E          ld   a,(hl)
0D13: 12          ld   (de),a
0D14: 23          inc  hl
0D15: 13          inc  de
0D16: 7E          ld   a,(hl)
0D17: 12          ld   (de),a
0D18: 23          inc  hl
0D19: 13          inc  de
0D1A: C9          ret

0D1B: 21 F1 80    ld   hl,$80F1
0D1E: 36 04       ld   (hl),$04
0D20: 23          inc  hl
0D21: 36 F0       ld   (hl),$F0
0D23: 23          inc  hl
0D24: 36 3E       ld   (hl),$3E
0D26: 23          inc  hl
0D27: 36 04       ld   (hl),$04
0D29: 23          inc  hl
0D2A: 36 03       ld   (hl),$03
0D2C: C9          ret

table_0D2D:
	dc.b	10 00   
	dc.b	01 6D 20
	dc.b	00      
	dc.b	01 6C 00
	dc.b	00      
	dc.b	01 00 00
	dc.b	00      
	dc.b	00      
	dc.b	00      
	dc.b	10 00   
	dc.b	01 6D 20
	dc.b	00      
	dc.b	01 6C 00
	dc.b	00      
	dc.b	01 00 14
	dc.b	07      
	dc.b	01 4E 10
	dc.b	02      
	dc.b	01 6D 20
	dc.b	02      
	dc.b	01 6C 00
	dc.b	02      
	dc.b	01 6B 14
	dc.b	09      
	dc.b	01 4E 10
	dc.b	00      
	dc.b	00      
	dc.b	6E      
	dc.b	20 00   
	dc.b	00      
	dc.b	6F      
	dc.b	00      
	dc.b	00      
	dc.b	01 00 00
	dc.b	00      
	dc.b	00      
	dc.b	00      
	dc.b	00      
	dc.b	00      
	dc.b	00      
	dc.b	6C      
	dc.b	10 00   
	dc.b	00      
	dc.b	6D      
	dc.b	00      
	dc.b	00      
	dc.b	00      
	dc.b	00      
	dc.b	0C      
	dc.b	07      
	dc.b	00      
	dc.b	4E      
	dc.b	00      
	dc.b	02      
	dc.b	00      
	dc.b	6C      
	dc.b	10 02   
	dc.b	00      
	dc.b	6D      
	dc.b	20 02   
	dc.b	00      
	dc.b	6B      
	dc.b	0C      
	dc.b	09      
	dc.b	00      
	dc.b	4E      
	dc.b	00      
	dc.b	00      
	dc.b	00      
	dc.b	00      
	dc.b	10 00   
	dc.b	00      
	dc.b	6D      
	dc.b	00      
	dc.b	00      
	dc.b	00      
	dc.b	00      
	dc.b	0C      
	dc.b	07      
	dc.b	00      
	dc.b	4E      
	dc.b	00      
	dc.b	00      
	dc.b	00      
	dc.b	00      
	dc.b	10 02   
	dc.b	00      
	dc.b	6E      
	dc.b	20 02   
	dc.b	00      
	dc.b	6F      
	dc.b	00      
	dc.b	00      
	dc.b	00      
	dc.b	00      

0DAD: 3A 33 80    ld   a,($8033)
0DB0: FE FF       cp   $FF
0DB2: C8          ret  z
0DB3: B7          or   a
0DB4: C8          ret  z
0DB5: FE 01       cp   $01
0DB7: CA F6 0D    jp   z,$0DF6
0DBA: D6 07       sub  $07
0DBC: D8          ret  c
0DBD: 21 41 80    ld   hl,$8041
0DC0: 57          ld   d,a
0DC1: 06 09       ld   b,$09
0DC3: CD 5B 80    call dynamic_ram_code_805B
0DC6: 15          dec  d
0DC7: 15          dec  d
0DC8: 23          inc  hl
0DC9: 10 F8       djnz $0DC3
0DCB: 06 05       ld   b,$05
0DCD: 0E 00       ld   c,$00
0DCF: CD 3B 0E    call $0E3B
0DD2: 0C          inc  c
0DD3: 15          dec  d
0DD4: 15          dec  d
0DD5: 23          inc  hl
0DD6: 10 F7       djnz $0DCF
0DD8: CD 5B 80    call dynamic_ram_code_805B
0DDB: 15          dec  d
0DDC: 15          dec  d
0DDD: 23          inc  hl
0DDE: 06 05       ld   b,$05
0DE0: 0E 05       ld   c,$05
0DE2: CD 3B 0E    call $0E3B
0DE5: 0C          inc  c
0DE6: 15          dec  d
0DE7: 15          dec  d
0DE8: 23          inc  hl
0DE9: 10 F7       djnz $0DE2
0DEB: 06 06       ld   b,$06
0DED: CD 5B 80    call dynamic_ram_code_805B
0DF0: 15          dec  d
0DF1: 15          dec  d
0DF2: 23          inc  hl
0DF3: 10 F8       djnz $0DED
0DF5: C9          ret
0DF6: 11 40 80    ld   de,$8040
0DF9: 21 6D 83    ld   hl,points_awarded_on_level_end_836D
0DFC: 06 03       ld   b,$03
0DFE: 4E          ld   c,(hl)
0DFF: 79          ld   a,c
0E00: E6 0F       and  $0F
0E02: 87          add  a,a
0E03: C6 C6       add  a,$C6
0E05: 12          ld   (de),a
0E06: 1B          dec  de
0E07: 79          ld   a,c
0E08: 0F          rrca
0E09: 0F          rrca
0E0A: 0F          rrca
0E0B: 0F          rrca
0E0C: E6 0F       and  $0F
0E0E: 87          add  a,a
0E0F: C6 C6       add  a,$C6
0E11: 12          ld   (de),a
0E12: 1B          dec  de
0E13: 23          inc  hl
0E14: 10 E8       djnz $0DFE
0E16: 21 3C 80    ld   hl,$803C
0E19: 7E          ld   a,(hl)
0E1A: FE C6       cp   $C6
0E1C: 20 05       jr   nz,$0E23
0E1E: 36 00       ld   (hl),$00
0E20: 23          inc  hl
0E21: 18 F6       jr   $0E19
0E23: 21 37 80    ld   hl,$8037
0E26: 3E DA       ld   a,$DA
0E28: 06 05       ld   b,$05
0E2A: 77          ld   (hl),a
0E2B: C6 02       add  a,$02
0E2D: 23          inc  hl
0E2E: 10 FA       djnz $0E2A
0E30: 21 41 80    ld   hl,$8041
0E33: AF          xor  a
0E34: 06 1A       ld   b,$1A
0E36: 77          ld   (hl),a
0E37: 23          inc  hl
0E38: 10 FC       djnz $0E36
0E3A: C9          ret
0E3B: 7A          ld   a,d
0E3C: B7          or   a
0E3D: F8          ret  m
0E3E: FE 08       cp   $08
0E40: DA 71 80    jp   c,dynamic_ram_code_8071
0E43: D6 08       sub  $08
0E45: 5F          ld   e,a
0E46: FE 14       cp   $14
0E48: 28 0F       jr   z,$0E59
0E4A: D0          ret  nc
0E4B: E5          push hl
0E4C: C5          push bc
0E4D: 21 66 0E    ld   hl,table_0E66
0E50: 06 00       ld   b,$00
0E52: 4B          ld   c,e
0E53: 09          add  hl,bc
0E54: 7E          ld   a,(hl)
0E55: C1          pop  bc
0E56: E1          pop  hl
0E57: 77          ld   (hl),a
0E58: C9          ret
0E59: E5          push hl
0E5A: C5          push bc
0E5B: 21 37 80    ld   hl,$8037
0E5E: 06 00       ld   b,$00
0E60: 09          add  hl,bc
0E61: 7E          ld   a,(hl)
0E62: C1          pop  bc
0E63: E1          pop  hl
0E64: 77          ld   (hl),a
0E65: C9          ret
table_0E66:
	dc.b	E4 E6 E8 E8 E6 E4 E6 EA EA E6 E4 E6 E8 E8 E6 E4
	dc.b	E6 EA EA E6 

0E7A: 3A 33 80    ld   a,($8033)
0E7B: 33          inc  sp
0E7C: 80          add  a,b
0E7D: B7          or   a
0E7E: C8          ret  z
0E7F: F8          ret  m
0E80: FE 02       cp   $02
0E82: 28 1B       jr   z,$0E9F
0E84: 21 41 80    ld   hl,$8041
0E87: 11 C1 C6    ld   de,$C6C1
0E8A: 01 1A 00    ld   bc,$001A
0E8D: ED B0       ldir
0E8F: 21 41 80    ld   hl,$8041
0E92: 11 E1 C6    ld   de,$C6E1
0E95: 06 1A       ld   b,$1A
0E97: 7E          ld   a,(hl)
0E98: 3C          inc  a
0E99: 12          ld   (de),a
0E9A: 23          inc  hl
0E9B: 13          inc  de
0E9C: 10 F9       djnz $0E97
0E9E: C9          ret
0E9F: 21 00 97    ld   hl,$9700
0EA2: 06 68       ld   b,$68
0EA4: 36 00       ld   (hl),$00
0EA6: 23          inc  hl
0EA7: 10 FB       djnz $0EA4
0EA9: 21 83 7F    ld   hl,$7F83
0EAC: 11 00 9F    ld   de,$9F00
0EAF: 01 68 00    ld   bc,$0068
0EB2: ED B0       ldir
0EB4: 21 00 A7    ld   hl,$A700
0EB7: 06 68       ld   b,$68
0EB9: 36 00       ld   (hl),$00
0EBB: 23          inc  hl
0EBC: 10 FB       djnz $0EB9
0EBE: C9          ret

handle_elevators_0EBF:
0EBF: CD D2 0E    call $0ED2
0EC2: CD FD 0E    call $0EFD
0EC5: CD 65 0F    call update_elevator_directions_0F65
0EC8: CD 31 0F    call $0F31
0ECB: CD 61 5D    call $5D61
0ECE: CD 99 0F    call set_elevators_neutral_controls_0F99
0ED1: C9          ret

0ED2: 3A C4 83    ld   a,($83C4)
0ED5: FE 80       cp   $80
0ED7: CA DD 0E    jp   z,$0EDD
0EDA: 32 9C 83    ld   ($839C),a
0EDD: 3A CC 83    ld   a,($83CC)
0EE0: FE 80       cp   $80
0EE2: CA E8 0E    jp   z,$0EE8
0EE5: 32 9C 83    ld   ($839C),a
0EE8: 3A D4 83    ld   a,($83D4)
0EEB: FE 80       cp   $80
0EED: CA F3 0E    jp   z,$0EF3
0EF0: 32 9C 83    ld   ($839C),a
0EF3: 3A BC 83    ld   a,($83BC)
0EF6: FE 80       cp   $80
0EF8: C8          ret  z
0EF9: 32 84 83    ld   ($8384),a
0EFC: C9          ret

0EFD: 21 84 83    ld   hl,$8384
0F00: 11 81 80    ld   de,elevator_directions_array_8081
0F03: 06 07       ld   b,$07
0F05: 7E          ld   a,(hl)
0F06: FE 80       cp   $80
0F08: 28 05       jr   z,$0F0F
0F0A: 12          ld   (de),a
0F0B: 13          inc  de
0F0C: AF          xor  a
0F0D: 12          ld   (de),a
0F0E: 1B          dec  de
0F0F: 13          inc  de
0F10: 13          inc  de
0F11: D5          push de
0F12: 11 08 00    ld   de,protection_crap_0008
0F15: 19          add  hl,de
0F16: D1          pop  de
0F17: 10 EC       djnz $0F05
0F19: 21 80 80    ld   hl,$8080
0F1C: CB 76       bit  6,(hl)
0F1E: C0          ret  nz
0F1F: CD DD 77    call $77DD
0F22: 7E          ld   a,(hl)
0F23: 34          inc  (hl)
0F24: EF          rst  $28
; bootleg: code replaced by below
0F25: 21 80 80    ld   hl,$8080
0F28: 4E          ld   c,(hl)
0F29: 09          add  hl,bc
; end code to replace
; bootleg replacement code
0F25: CD EC 34    call $34EC		; alternate code put where there was room
0F28: 00          nop
0F29: 00          nop
; end bootleg code

0F2A: 3F          ccf
0F2B: 0E 25       ld   c,$25
0F2D: ED 42       sbc  hl,bc
0F2F: 77          ld   (hl),a
0F30: C9          ret
0F31: 3A 9E 80    ld   a,($809E)
0F34: FE 80       cp   $80
0F36: 28 03       jr   z,$0F3B
0F38: 32 97 80    ld   ($8097),a
0F3B: 21 9F 80    ld   hl,$809F
0F3E: 11 9A 80    ld   de,$809A
0F41: 06 03       ld   b,$03
0F43: 7E          ld   a,(hl)
0F44: FE 80       cp   $80
0F46: 28 01       jr   z,$0F49
0F48: 12          ld   (de),a
0F49: 23          inc  hl
0F4A: 10 F7       djnz $0F43
0F4C: 11 97 80    ld   de,$8097
0F4F: 21 E1 83    ld   hl,$83E1
0F52: 06 07       ld   b,$07
0F54: 1A          ld   a,(de)
0F55: FE 80       cp   $80
0F57: CA 5B 0F    jp   z,$0F5B
0F5A: 77          ld   (hl),a
0F5B: 13          inc  de
0F5C: D5          push de
0F5D: 11 15 00    ld   de,$0015
0F60: 19          add  hl,de
0F61: D1          pop  de
0F62: 10 F0       djnz $0F54
0F64: C9          ret

update_elevator_directions_0F65:
0F65: 3A 03 80    ld   a,($8003)
0F68: FE 14       cp   $14
0F6A: 38 18       jr   c,$0F84
0F6C: 3A CE 83    ld   a,($83CE)
0F6F: FE 1E       cp   $1E
0F71: 38 11       jr   c,$0F84
0F73: 3E FE       ld   a,$FE
0F75: 32 87 80    ld   ($8087),a
0F78: 3A 9C 83    ld   a,($839C)
0F7B: FE 02       cp   $02
0F7D: 20 05       jr   nz,$0F84
0F7F: 3E 0F       ld   a,$0F
0F81: 32 88 80    ld   ($8088),a
0F84: 11 81 80    ld   de,elevator_directions_array_8081
0F87: 21 E1 83    ld   hl,$83E1		; in the middle of elevator struct
0F8A: 06 07       ld   b,$07
; loop on 7 elevators (out of 21?)
0F8C: 1A          ld   a,(de)
0F8D: 77          ld   (hl),a
0F8E: 13          inc  de
0F8F: 13          inc  de
0F90: D5          push de
0F91: 11 15 00    ld   de,$0015		; skip 2 elevators
0F94: 19          add  hl,de
0F95: D1          pop  de
0F96: 10 F4       djnz $0F8C
0F98: C9          ret

set_elevators_neutral_controls_0F99:

set_elevators_neutral_controls_0F99:
0F99: 21 84 83    ld   hl,elevator_array_837D+player_control_07
0F9C: 11 08 00    ld   de,protection_crap_0008
0F9F: 06 0B       ld   b,$0B
0FA1: 3E 80       ld   a,$80		; set no move
0FA3: 77          ld   (hl),a
0FA4: 19          add  hl,de
0FA5: 10 FC       djnz $0FA3
0FA7: 21 97 80    ld   hl,$8097
0FAA: 06 0B       ld   b,$0B
0FAC: 77          ld   (hl),a
0FAD: 23          inc  hl
0FAE: 10 FC       djnz $0FAC
0FB0: C9          ret

read_dip_switches_0fb1:
0FB1: 21 A5 80    ld   hl,$80A5
0FB4: 3A 4F 82    ld   a,(copy_of_dip_switches_2_824F)
0FB7: CD D2 0F    call decode_dip_switches_0fd2
0FBA: 21 A7 80    ld   hl,coin_slot_2_dsw_copy_80A7
0FBD: 3A 4F 82    ld   a,(copy_of_dip_switches_2_824F)
0FC0: 0F          rrca
0FC1: 0F          rrca
0FC2: 0F          rrca
0FC3: 0F          rrca
0FC4: CD D2 0F    call decode_dip_switches_0fd2
0FC7: AF          xor  a
0FC8: 32 A2 80    ld   (nb_credits_80A2),a
0FCB: 32 A3 80    ld   ($80A3),a
0FCE: 32 A4 80    ld   ($80A4),a
0FD1: C9          ret

decode_dip_switches_0fd2:
0FD2: E6 0F       and  $0F
0FD4: FE 08       cp   $08
0FD6: 30 09       jr   nc,$0FE1
0FD8: D6 09       sub  $09
0FDA: ED 44       neg
0FDC: 77          ld   (hl),a
0FDD: 23          inc  hl
0FDE: 36 01       ld   (hl),$01
0FE0: C9          ret
0FE1: 36 01       ld   (hl),$01
0FE3: 23          inc  hl
0FE4: D6 10       sub  $10
0FE6: ED 44       neg
0FE8: 77          ld   (hl),a
0FE9: C9          ret

check_credits_0fea:
0FEA: 3A AC 80    ld   a,(game_state_80AC)
0FED: B7          or   a
0FEE: C8          ret  z
0FEF: CD 36 10    call switch_bank_on_9_credits_1036
0FF2: 3A A3 80    ld   a,($80A3)
0FF5: 21 A5 80    ld   hl,$80A5
0FF8: CD 19 10    call increase_credits_if_required_1019
0FFB: 78          ld   a,b
0FFC: 32 A3 80    ld   ($80A3),a
0FFF: CD 36 10    call switch_bank_on_9_credits_1036
1002: 3A 50 82    ld   a,(copy_of_dip_switches_3_8250)
1005: CB 7F       bit  7,a
1007: C0          ret  nz
1008: 3A A4 80    ld   a,($80A4)
100B: 21 A7 80    ld   hl,coin_slot_2_dsw_copy_80A7
100E: CD 19 10    call increase_credits_if_required_1019
1011: 78          ld   a,b
1012: 32 A4 80    ld   ($80A4),a
1015: CD 36 10    call switch_bank_on_9_credits_1036
1018: C9          ret

increase_credits_if_required_1019:
1019: 47          ld   b,a
101A: 3A A2 80    ld   a,(nb_credits_80A2)
101D: 4F          ld   c,a
101E: 56          ld   d,(hl)
101F: 23          inc  hl
1020: 5E          ld   e,(hl)
1021: 78          ld   a,b
1022: 92          sub  d
1023: 38 0C       jr   c,$1031
1025: 47          ld   b,a
1026: 79          ld   a,c
1027: 83          add  a,e
1028: FE 09       cp   $09
102A: 38 02       jr   c,$102E
102C: 3E 09       ld   a,$09
102E: 4F          ld   c,a
102F: 18 F0       jr   $1021
1031: 79          ld   a,c
1032: 32 A2 80    ld   (nb_credits_80A2),a
1035: C9          ret

switch_bank_on_9_credits_1036:
1036: 3A A2 80    ld   a,(nb_credits_80A2)
1039: FE 09       cp   $09
103B: 30 10       jr   nc,over_9_credits_104D
103D: AF          xor  a
103E: 32 45 82    ld   ($8245),a
1041: 3A 4D 82    ld   a,(bank_switch_copy_824D)
1044: F6 01       or   $01
1046: 32 4D 82    ld   (bank_switch_copy_824D),a
1049: 32 0E D5    ld   (bank_switch_d50e),a
104C: C9          ret

over_9_credits_104D:
104D: 3A 4D 82    ld   a,(bank_switch_copy_824D)
1050: E6 FE       and  $FE
1052: 32 4D 82    ld   (bank_switch_copy_824D),a
1055: 32 0E D5    ld   (bank_switch_d50e),a
1058: C9          ret

check_coin_inserted_1059:
1059: 21 A3 80    ld   hl,$80A3
105C: 3A 4B 82    ld   a,($824B)
105F: 47          ld   b,a
1060: 3A 0B D4    ld   a,($D40B)
1063: 32 4B 82    ld   ($824B),a
1066: 2F          cpl
1067: A0          and  b
1068: 47          ld   b,a
1069: CB 68       bit  5,b
106B: 28 06       jr   z,$1073
106D: 3E C1       ld   a,$C1
106F: 32 0B D5    ld   (sound_latch_D50B),a
1072: 34          inc  (hl)
1073: 3A 50 82    ld   a,(copy_of_dip_switches_3_8250)
1076: CB 7F       bit  7,a
1078: 20 0B       jr   nz,$1085
107A: CB 60       bit  4,b
107C: 28 07       jr   z,$1085
107E: 23          inc  hl
107F: 3E C1       ld   a,$C1
1081: 32 0B D5    ld   (sound_latch_D50B),a
1084: 34          inc  (hl)
1085: 3A 4C 82    ld   a,(copy_of_service_mode_824C)
1088: 47          ld   b,a
1089: 3A 0C D4    ld   a,(service_mode_D40C)
108C: 32 4C 82    ld   (copy_of_service_mode_824C),a
108F: CB 67       bit  4,a
1091: C8          ret  z
1092: CB 60       bit  4,b
1094: 20 06       jr   nz,$109C
1096: 3E 03       ld   a,$03
1098: 32 F1 82    ld   ($82F1),a
109B: C9          ret
109C: 3A F1 82    ld   a,($82F1)
109F: 3D          dec  a
10A0: F8          ret  m
10A1: 32 F1 82    ld   ($82F1),a
10A4: C0          ret  nz
10A5: 3A A2 80    ld   a,(nb_credits_80A2)
10A8: FE 09       cp   $09
10AA: D0          ret  nc
10AB: 3C          inc  a
10AC: 32 A2 80    ld   (nb_credits_80A2),a
10AF: C9          ret

display_credit_info_10b0:
10B0: 3A 4E 82    ld   a,(copy_of_dip_switches_1_824E)
10B3: CB 57       bit  2,a
10B5: 20 09       jr   nz,$10C0
10B7: 3A A2 80    ld   a,(nb_credits_80A2)
10BA: C6 10       add  a,$10
10BC: 32 BE C7    ld   ($C7BE),a
10BF: C9          ret
10C0: 21 CA 10    ld   hl,free_play_string_10CA
10C3: 11 B7 C7    ld   de,$C7B7
10C6: CD F9 29    call copy_string_to_screen_29F9
10C9: C9          ret

free_play_string_10CA:
	dc.b  27 1F 1E 1E 33 1A 1B 1C 1D 1E FF

; seems not reached
10D5: DD 46 37    ld   b,(ix+$37)
10D8: DD 66 39    ld   h,(ix+$39)
10DB: DD 4E 38    ld   c,(ix+$38)
10DE: DD 6E 3A    ld   l,(ix+$3a)
10E1: 2B          dec  hl
10E2: DD 23       inc  ix
10E4: DD 7E 3A    ld   a,(ix+$3a)
10E7: 91          sub  c
10E8: 4F          ld   c,a
10E9: 96          sub  (hl)
10EA: 77          ld   (hl),a
10EB: 10 F4       djnz $10E1
10ED: FE 00       cp   $00
10EF: CA 16 2F    jp   z,$2F16
10F2: DD 66 3B    ld   h,(ix+$3b)
10F5: DD 7E 3D    ld   a,(ix+$3d)
10F8: DD 46 3E    ld   b,(ix+$3e)
10FB: DD 6E 3C    ld   l,(ix+$3c)
10FE: E5          push hl
10FF: DD 6E 3F    ld   l,(ix+$3f)
1102: DD 66 40    ld   h,(ix+$40)
1105: E5          push hl
1106: DD E1       pop  ix
1108: E1          pop  hl
1109: C3 27 72    jp   $7227

110C: 05          dec  b
110D: 14          inc  d
110E: C6 33       add  a,$33
1110: 43          ld   b,e
1111: 60          ld   h,b
1112: 5D          ld   e,l
1113: 48          ld   c,b
1114: 4D          ld   c,l
1115: D4 08 E7    call nc,$E708
1118: C9          ret
1119: D5          push de
111A: 10 00       djnz $111C
111C: 00          nop
111D: 00          nop
111E: 00          nop
111F: 00          nop
1120: 3E 02       ld   a,$02
1122: 32 3B 82    ld   (game_in_play_flag_823B),a
1125: 3A 51 82    ld   a,($8251)
1128: B7          or   a
1129: CA 67 11    jp   z,$1167
112C: 3D          dec  a
112D: CA 5A 11    jp   z,$115A
1130: 21 D3 7D    ld   hl,recorded_inputs_7DD3
1133: 22 3C 82    ld   ($823C),hl
1136: 3E 05       ld   a,$05
1138: 32 2C 80    ld   ($802C),a
113B: AF          xor  a
113C: 32 AB 80    ld   ($80AB),a
113F: 32 34 82    ld   (nb_lives_8234),a
1142: 32 00 D6    ld   (video_mode_d600),a
1145: CD 75 11    call fix_random_seed_for_demo_1175
1148: 3E 02       ld   a,$02
114A: 32 37 82    ld   (skill_level_8237),a
114D: CD 3E 2A    call init_level_skill_params_2A2E
1150: CD 00 27    call init_building_2700
1153: CD 65 2A    call init_elevators_2a65
1156: CD 9B 75    call start_next_level_759B
1159: C9          ret
115A: 21 D3 7B    ld   hl,recorded_inputs_7BD3
115D: 22 3C 82    ld   ($823C),hl
1160: 3E 12       ld   a,$12
1162: 32 2C 80    ld   ($802C),a
1165: 18 D4       jr   $113B
1167: 21 63 7A    ld   hl,recorded_inputs_7A63
116A: 22 3C 82    ld   ($823C),hl
116D: 3E 1C       ld   a,$1C
116F: 32 2C 80    ld   ($802C),a
1172: 18 C7       jr   $113B
1174: C9          ret

fix_random_seed_for_demo_1175:
1175: 3A 3B 82    ld   a,(game_in_play_flag_823B)
1178: 3D          dec  a
1179: 28 0F       jr   z,$118A		; never called
117B: 2A 3C 82    ld   hl,($823C)
117E: 5E          ld   e,(hl)
117F: 23          inc  hl
1180: 56          ld   d,(hl)
1181: 23          inc  hl
1182: 22 3C 82    ld   ($823C),hl
1185: ED 53 D6 81 ld   (pseudo_random_seed_81D6),de
1189: C9          ret
; doesn't seem to be ever called
; this is part of the record mode used to record demo sequences

118A: 2A 3C 82    ld   hl,($823C)
118D: ED 5B D6 81 ld   de,(pseudo_random_seed_81D6)
1191: 73          ld   (hl),e
1192: 23          inc  hl
1193: 72          ld   (hl),d
1194: 23          inc  hl
1195: 22 3C 82    ld   ($823C),hl
1198: C9          ret

elevator_irq_1199:
1199: F3          di
119A: F5          push af
119B: E5          push hl
119C: D5          push de
119D: C5          push bc
119E: 08          ex   af,af'
119F: D9          exx
11A0: F5          push af
11A1: E5          push hl
11A2: D5          push de
11A3: C5          push bc
11A4: DD E5       push ix
11A6: FD E5       push iy
11A8: 21 AA 80    ld   hl,timer_8bit_80AA
11AB: 35          dec  (hl)
11AC: F2 49 12    jp   p,$1249
11AF: 3A AB 80    ld   a,($80AB)
11B2: B7          or   a
11B3: CA 49 12    jp   z,$1249
11B6: 3A D8 81    ld   a,($81D8)
11B9: 47          ld   b,a
11BA: 80          add  a,b
11BB: 80          add  a,b
11BC: F6 F0       or   $F0
11BE: 32 00 D6    ld   (video_mode_d600),a
11C1: 3A AC 80    ld   a,(game_state_80AC)
11C4: 47          ld   b,a
11C5: 80          add  a,b
11C6: 80          add  a,b	; times 3 to adjust to jump table
11C7: 5F          ld   e,a
11C8: 16 00       ld   d,$00
11CA: 21 CF 11    ld   hl,game_screen_jump_table_11CF
11CD: 19          add  hl,de
11CE: E9          jp   (hl)

game_screen_jump_table_11CF:
11CF: C3 ED 11    jp   $11ED				            | 0 ???
11D2: C3 F0 11    jp   title_sequence_11F0              | 1
11D5: C3 F6 11    jp   $11F6                            | 2 ???
11D8: C3 F9 11    jp   push_start_screen_11F9           | 3
11DB: C3 02 12    jp   game_intro_1202                  | 4
11DE: C3 11 12    jp   game_running_1211                | 5
11E1: C3 29 12    jp   ground_floor_reached_1229        | 6
11E4: C3 2F 12    jp   next_life_122F                   | 7
11E7: C3 35 12    jp   game_over_1235                   | 8
11EA: C3 3B 12    jp   insert_coin_screen_123B         | 9

11ED: C3 3E 12    jp   finish_irq_123E

title_sequence_11F0:
11F0: CD 30 74    call title_animation_7430
11F3: C3 3E 12    jp   finish_irq_123E

11F6: C3 3E 12    jp   finish_irq_123E

push_start_screen_11F9:
11F9: CD B6 2E    call $2EB6
11FC: CD B0 10    call display_credit_info_10b0
11FF: C3 3E 12    jp   finish_irq_123E

game_intro_1202:
1202: CD 0B 50    call $500B
1205: CD B0 10    call display_credit_info_10b0
1208: CD C6 57    call update_upper_status_bar_57C6
120B: CD 01 58    call display_nb_lives_5801
120E: C3 3E 12    jp   finish_irq_123E

game_running_1211:
1211: CD C3 03    call update_main_scrolling_03C3
1214: CD 70 15    call update_door_background_1570
1217: CD 5C 61    call animate_elevators_615C
121A: CD F0 15    call update_sprites_15F0
121D: CD C6 57    call update_upper_status_bar_57C6
1220: CD B0 10    call display_credit_info_10b0
1223: CD 01 58    call display_nb_lives_5801
1226: C3 3E 12    jp   finish_irq_123E

ground_floor_reached_1229:
1229: CD 7A 0E    call $0E7A
122C: C3 11 12    jp   game_running_1211

next_life_122F:
122F: CD CA 26    call set_level_palette_26ca
1232: C3 3E 12    jp   finish_irq_123E

game_over_1235:
1235: CD B0 10    call display_credit_info_10b0
1238: C3 3E 12    jp   finish_irq_123E

insert_coin_screen_123B:
123B: C3 3E 12    jp   finish_irq_123E

finish_irq_123E:
123E: 3A A9 80    ld   a,(timer_8bit_reload_value_80A9)
1241: 3D          dec  a
1242: 32 AA 80    ld   (timer_8bit_80AA),a
1245: AF          xor  a
1246: 32 AB 80    ld   ($80AB),a
1249: 3A EA 82    ld   a,(coin_counter_lock_82EA)
124C: B7          or   a
124D: 20 0B       jr   nz,$125A
124F: CD 59 10    call check_coin_inserted_1059
1252: 3A 0C D4    ld   a,(service_mode_D40C)
1255: CB 6F       bit  5,a
1257: CA EB 70    jp   z,run_in_service_mode_70EB
125A: 32 0D D5    ld   (watchdog_d50d),a
125D: CD 00 65    call handle_music_6500
1260: CD 6A 65    call handle_music_656a
1263: CD DF 65    call $65DF
1266: 21 48 86    ld   hl,protection_variable_8648
1269: 7E          ld   a,(hl)
126A: 3C          inc  a
126B: 3C          inc  a
126C: CB DF       set  3,a
126E: FA 73 12    jp   m,$1273
1271: EE 9A       xor  $9A
1273: 77          ld   (hl),a
1274: CD CF 77    call mcu_comm_routine_77CF
1277: FD E1       pop  iy
1279: DD E1       pop  ix
127B: C1          pop  bc
127C: D1          pop  de
127D: E1          pop  hl
127E: F1          pop  af
127F: D9          exx
1280: 08          ex   af,af'
1281: C1          pop  bc
1282: D1          pop  de
1283: E1          pop  hl
1284: F1          pop  af
1285: FB          ei
1286: C9          ret

init_moving_door_slots_1287:
1287: 3E FF       ld   a,$FF
1289: 32 B2 80    ld   ($80B2),a
128C: 32 BA 80    ld   ($80BA),a
128F: 32 AF 80    ld   ($80AF),a
1292: 32 B7 80    ld   ($80B7),a
1295: 32 50 81    ld   ($8150),a
1298: 32 55 81    ld   ($8155),a
129B: 32 5A 81    ld   ($815A),a
129E: 32 5F 81    ld   ($815F),a
12A1: C9          ret

handle_enemies_12A2:
handle_moving_doors_12A2:
12A2: 21 BD 80    ld   hl,opening_door_screen_address_80BD
12A5: 22 ED 80    ld   ($80ED),hl
12A8: DD 21 AD 80 ld   ix,$80AD
12AC: 21 50 81    ld   hl,$8150
12AF: 22 EF 80    ld   ($80EF),hl
12B2: CD C8 12    call $12C8
12B5: DD 21 B5 80 ld   ix,$80B5
12B9: 21 5A 81    ld   hl,$815A
12BC: 22 EF 80    ld   ($80EF),hl
12BF: CD C8 12    call $12C8
12C2: 2A ED 80    ld   hl,($80ED)
12C5: 36 00       ld   (hl),$00
12C7: C9          ret
12C8: DD 7E 07    ld   a,(ix+$07)
12CB: B7          or   a
12CC: 20 1D       jr   nz,$12EB
12CE: DD 7E 05    ld   a,(ix+character_delta_x_05)
12D1: B7          or   a
12D2: F8          ret  m
12D3: DD 34 05    inc  (ix+character_delta_x_05)
12D6: B7          or   a
12D7: CA 09 13    jp   z,$1309
12DA: FE 0D       cp   $0D
12DC: DA 6A 13    jp   c,$136A
12DF: CA B6 13    jp   z,a_door_has_closed_13b6
12E2: FE 30       cp   $30
12E4: DA 56 14    jp   c,reward_for_documents_1456
12E7: CD EC 13    call a_blue_door_has_closed_13ec
12EA: C9          ret
12EB: DD 7E 05    ld   a,(ix+character_delta_x_05)
12EE: B7          or   a
12EF: F8          ret  m
12F0: DD 34 05    inc  (ix+character_delta_x_05)
12F3: B7          or   a
12F4: CA 09 13    jp   z,$1309
12F7: D6 08       sub  $08
12F9: 38 09       jr   c,$1304
12FB: 3C          inc  a
12FC: FE 0D       cp   $0D
12FE: DA 6A 13    jp   c,$136A
1301: C3 B6 13    jp   a_door_has_closed_13b6
1304: 3E 01       ld   a,$01
1306: C3 6A 13    jp   $136A
1309: CD 81 15    call $1581
130C: DD 7E 02    ld   a,(ix+$02)
130F: FE 07       cp   $07
1311: 38 3D       jr   c,door_on_lower_floors_1350
1313: DD 7E 04    ld   a,(ix+$04)
1316: 87          add  a,a
1317: 87          add  a,a
1318: 87          add  a,a
1319: 47          ld   b,a
131A: 80          add  a,b
131B: 80          add  a,b
131C: C6 20       add  a,$20
131E: DD 77 00    ld   (ix+character_x_00),a
1321: C6 0F       add  a,$0F
1323: DD 77 01    ld   (ix+character_x_right_01),a
1326: CD 86 14    call animate_moving_door_sprite_1486
1329: DD 7E 02    ld   a,(ix+$02)
132C: 21 40 13    ld   hl,table_1340
132F: FE 10       cp   $10
1331: D2 3C 13    jp   nc,$133C
1334: FE 0B       cp   $0B
1336: DA 3C 13    jp   c,$133C
1339: 21 48 13    ld   hl,$1348
133C: CD C3 14    call draw_door_tiles_14c3
133F: C9          ret

table_1340:
	dc.b	9D
	dc.b	9D
	dc.b	00
	dc.b	00
	dc.b	00
	dc.b	00
	dc.b	00
	dc.b	00
	dc.b	9F
	dc.b	9F
	dc.b	00
	dc.b	00
	dc.b	00
	dc.b	00
	dc.b	00
	dc.b	00
	
door_on_lower_floors_1350:
1350: DD 7E 04    ld   a,(ix+$04)
1353: B7          or   a
1354: 20 0A       jr   nz,$1360
1356: DD 36 00 18 ld   (ix+character_x_00),$18
135A: DD 36 01 27 ld   (ix+character_x_right_01),$27
135E: 18 C6       jr   $1326
1360: DD 36 00 D0 ld   (ix+character_x_00),$D0
1364: DD 36 01 DF ld   (ix+character_x_right_01),$DF
1368: 18 BC       jr   $1326
136A: 3D          dec  a
136B: 47          ld   b,a
136C: FE 04       cp   $04
136E: DA 7B 13    jp   c,$137B
1371: 3E 0B       ld   a,$0B
1373: 90          sub  b
1374: FE 04       cp   $04
1376: DA 7B 13    jp   c,$137B
1379: 3E 03       ld   a,$03
137B: 47          ld   b,a
137C: CD 39 15    call $1539
137F: 78          ld   a,b
1380: 87          add  a,a
1381: C6 60       add  a,$60
1383: 47          ld   b,a
1384: 3A 04 80    ld   a,(scroll_speed_8004)
1387: ED 44       neg
1389: 4F          ld   c,a
138A: 2A EF 80    ld   hl,($80EF)
138D: 23          inc  hl
138E: 23          inc  hl
138F: 7E          ld   a,(hl)
1390: 81          add  a,c
1391: 77          ld   (hl),a
1392: FE 18       cp   $18
1394: 38 04       jr   c,$139A
1396: FE D8       cp   $D8
1398: 38 0E       jr   c,$13A8
139A: DD 36 05 0D ld   (ix+character_delta_x_05),$0D
139E: DD 7E 07    ld   a,(ix+$07)
13A1: B7          or   a
13A2: 28 04       jr   z,$13A8
13A4: DD 36 05 15 ld   (ix+character_delta_x_05),$15
13A8: 23          inc  hl
13A9: 23          inc  hl
13AA: 70          ld   (hl),b
13AB: 04          inc  b
13AC: 23          inc  hl
13AD: 23          inc  hl
13AE: 23          inc  hl
13AF: 7E          ld   a,(hl)
13B0: 81          add  a,c
13B1: 77          ld   (hl),a
13B2: 23          inc  hl
13B3: 23          inc  hl
13B4: 70          ld   (hl),b
13B5: C9          ret

a_door_has_closed_13b6:
13B6: CD 81 15    call $1581
13B9: DD 7E 06    ld   a,(ix+character_situation_06)
13BC: E6 01       and  $01
13BE: DD 46 03    ld   b,(ix+character_y_offset_03)
13C1: 80          add  a,b
13C2: 80          add  a,b
13C3: 87          add  a,a
13C4: 47          ld   b,a
13C5: 0E 00       ld   c,$00
13C7: DD 7E 02    ld   a,(ix+$02)
13CA: FE 10       cp   $10
13CC: D2 D6 13    jp   nc,$13D6
13CF: FE 0B       cp   $0B
13D1: DA D6 13    jp   c,$13D6
13D4: 0E 01       ld   c,$01
13D6: 78          ld   a,b
13D7: 81          add  a,c
13D8: 87          add  a,a
13D9: 87          add  a,a
13DA: 87          add  a,a
13DB: 4F          ld   c,a
13DC: 06 00       ld   b,$00
13DE: 21 16 14    ld   hl,table_1416
13E1: 09          add  hl,bc
13E2: CD C3 14    call draw_door_tiles_14c3
13E5: DD 7E 06    ld   a,(ix+character_situation_06)
13E8: FE 02       cp   CS_ABOVE_ELEVATOR_02
13EA: 30 12       jr   nc,a_red_door_has_closed_13fe
a_blue_door_has_closed_13ec:
13EC: 3E FF       ld   a,$FF
13EE: DD 77 05    ld   (ix+character_delta_x_05),a
13F1: DD 77 02    ld   (ix+character_fine_y_offset_02),a
13F4: 2A EF 80    ld   hl,($80EF)
13F7: 77          ld   (hl),a
13F8: 11 05 00    ld   de,$0005
13FB: 19          add  hl,de
13FC: 77          ld   (hl),a
13FD: C9          ret

a_red_door_has_closed_13fe:
13FE: CD 00 15    call $1500
1401: 3E FF       ld   a,$FF
1403: 2A EF 80    ld   hl,($80EF)
1406: 77          ld   (hl),a
1407: 11 05 00    ld   de,$0005
140A: 19          add  hl,de
140B: 77          ld   (hl),a
140C: 23          inc  hl
140D: 23          inc  hl
140E: 3A 04 80    ld   a,(scroll_speed_8004)
1411: ED 44       neg
1413: 86          add  a,(hl)
1414: 77          ld   (hl),a
1415: C9          ret

table_1416:
	dc.b	57
	dc.b	57
	dc.b	58
	dc.b	58
	dc.b	59
	dc.b	58
	dc.b	58
	dc.b	58
	dc.b	40
	dc.b	40
	dc.b	40
	dc.b	40
	dc.b	40
	dc.b	40
	dc.b	40
	dc.b	40
	dc.b	9E
	dc.b	9E
	dc.b	82
	dc.b	82
	dc.b	83
	dc.b	82
	dc.b	82
	dc.b	82
	dc.b	80
	dc.b	80
	dc.b	82
	dc.b	82
	dc.b	83
	dc.b	82
	dc.b	82
	dc.b	82
	dc.b	57
	dc.b	57
	dc.b	58
	dc.b	58
	dc.b	58
	dc.b	5A
	dc.b	58
	dc.b	58
	dc.b	40
	dc.b	40
	dc.b	40
	dc.b	40
	dc.b	40
	dc.b	40
	dc.b	40
	dc.b	40
	dc.b	9E
	dc.b	9E
	dc.b	82
	dc.b	82
	dc.b	82
	dc.b	84
	dc.b	82
	dc.b	82
	dc.b	80
	dc.b	80
	dc.b	82
	dc.b	82
	dc.b	82
	dc.b	84
	dc.b	82
	dc.b	82
reward_for_documents_1456:
1456: DD 7E 05    ld   a,(ix+character_delta_x_05)
1459: CB 57       bit  2,a
145B: 06 2F       ld   b,$2F
145D: 20 02       jr   nz,$1461
145F: 06 01       ld   b,$01
1461: 2A EF 80    ld   hl,($80EF)
1464: 36 FF       ld   (hl),$FF
1466: 11 05 00    ld   de,$0005
1469: 19          add  hl,de
146A: 36 00       ld   (hl),$00
146C: 23          inc  hl
146D: 23          inc  hl
146E: 3A 04 80    ld   a,(scroll_speed_8004)
1471: ED 44       neg
1473: 86          add  a,(hl)
1474: 77          ld   (hl),a
1475: 23          inc  hl
1476: 36 00       ld   (hl),$00
1478: 23          inc  hl
1479: 70          ld   (hl),b
147A: DD 7E 05    ld   a,(ix+character_delta_x_05)
147D: FE 0F       cp   $0F
147F: C0          ret  nz
1480: 3E 36       ld   a,$36	; bonus for document retrieved sound
1482: CD 56 36    call play_sound_3656
1485: C9          ret

animate_moving_door_sprite_1486:
1486: 2A EF 80    ld   hl,($80EF)
1489: 36 01       ld   (hl),$01
148B: 23          inc  hl
148C: DD 7E 00    ld   a,(ix+character_x_00)
148F: 77          ld   (hl),a
1490: 23          inc  hl
1491: DD 46 02    ld   b,(ix+character_fine_y_offset_02)
1494: 0E 00       ld   c,$00
1496: 16 04       ld   d,$04
1498: E5          push hl
1499: CD 6C 1E    call compute_delta_height_1e6c
149C: 4D          ld   c,l
149D: E1          pop  hl
149E: 71          ld   (hl),c
149F: 23          inc  hl
14A0: DD 7E 06    ld   a,(ix+$06)
14A3: 2F          cpl
14A4: E6 01       and  $01
14A6: 87          add  a,a
14A7: 87          add  a,a
14A8: DD 86 03    add  a,(ix+character_y_offset_03)
14AB: 57          ld   d,a
14AC: 72          ld   (hl),d
14AD: 23          inc  hl
14AE: 36 60       ld   (hl),$60
14B0: 23          inc  hl
14B1: 36 01       ld   (hl),$01
14B3: 23          inc  hl
14B4: DD 7E 00    ld   a,(ix+character_x_00)
14B7: 77          ld   (hl),a
14B8: 23          inc  hl
14B9: 79          ld   a,c
14BA: C6 10       add  a,$10
14BC: 77          ld   (hl),a
14BD: 23          inc  hl
14BE: 72          ld   (hl),d
14BF: 23          inc  hl
14C0: 36 61       ld   (hl),$61
14C2: C9          ret

draw_door_tiles_14c3:
14C3: E5          push hl
14C4: DD 46 02    ld   b,(ix+character_fine_y_offset_02)
14C7: DD 4E 04    ld   c,(ix+$04)
14CA: CD 05 56    call $5605
14CD: 44          ld   b,h
14CE: 4D          ld   c,l
14CF: E1          pop  hl
14D0: ED 5B ED 80 ld   de,($80ED)
14D4: CD E5 14    call update_behind_door_tile_14e5
14D7: CD E5 14    call update_behind_door_tile_14e5
14DA: CD E5 14    call update_behind_door_tile_14e5
14DD: CD E5 14    call update_behind_door_tile_14e5
14E0: ED 53 ED 80 ld   ($80ED),de
14E4: C9          ret

update_behind_door_tile_14e5:
14E5: 3E C8       ld   a,$C8
14E7: 80          add  a,b
14E8: 12          ld   (de),a
14E9: 13          inc  de
14EA: 79          ld   a,c
14EB: 12          ld   (de),a
14EC: 13          inc  de
14ED: 7E          ld   a,(hl)
14EE: 12          ld   (de),a
14EF: 23          inc  hl
14F0: 13          inc  de
14F1: 7E          ld   a,(hl)
14F2: 12          ld   (de),a
14F3: 23          inc  hl
14F4: 13          inc  de
14F5: 79          ld   a,c
14F6: C6 20       add  a,$20
14F8: 4F          ld   c,a
14F9: 78          ld   a,b
14FA: CE 00       adc  a,$00
14FC: E6 03       and  $03
14FE: 47          ld   b,a
14FF: C9          ret
1500: DD 46 02    ld   b,(ix+character_fine_y_offset_02)
1503: DD 4E 04    ld   c,(ix+$04)
1506: CD 05 56    call $5605
1509: 11 7F C8    ld   de,$C87F
150C: 19          add  hl,de
150D: 7C          ld   a,h
150E: E6 CB       and  $CB
1510: 67          ld   h,a
1511: EB          ex   de,hl
1512: 06 5C       ld   b,$5C
1514: DD 7E 04    ld   a,(ix+$04)
1517: FE 04       cp   $04
1519: 38 02       jr   c,$151D
151B: 13          inc  de
151C: 13          inc  de
151D: DD 7E 02    ld   a,(ix+character_fine_y_offset_02)
1520: FE 0B       cp   $0B
1522: 38 06       jr   c,$152A
1524: FE 10       cp   $10
1526: 30 02       jr   nc,$152A
1528: 06 85       ld   b,$85
152A: 2A ED 80    ld   hl,($80ED)
152D: 72          ld   (hl),d
152E: 23          inc  hl
152F: 73          ld   (hl),e
1530: 23          inc  hl
1531: 70          ld   (hl),b
1532: 23          inc  hl
1533: 70          ld   (hl),b
1534: 23          inc  hl
1535: 22 ED 80    ld   ($80ED),hl
1538: C9          ret
1539: DD 7E 04    ld   a,(ix+$04)
153C: 87          add  a,a
153D: 87          add  a,a
153E: 87          add  a,a
153F: 57          ld   d,a
1540: 82          add  a,d
1541: 82          add  a,d
1542: C6 20       add  a,$20
1544: 57          ld   d,a
1545: 78          ld   a,b
1546: 0E 00       ld   c,$00
1548: FE 01       cp   $01
154A: FA 5B 15    jp   m,$155B
154D: 0E 02       ld   c,$02
154F: CA 5B 15    jp   z,$155B
1552: 0E 05       ld   c,$05
1554: FE 02       cp   $02
1556: CA 5B 15    jp   z,$155B
1559: 0E 08       ld   c,$08
155B: DD 7E 03    ld   a,(ix+character_y_offset_03)
155E: B7          or   a
155F: C2 68 15    jp   nz,$1568
1562: 7A          ld   a,d
1563: 81          add  a,c
1564: DD 77 00    ld   (ix+character_x_00),a
1567: C9          ret
1568: 7A          ld   a,d
1569: C6 10       add  a,$10
156B: 91          sub  c
156C: DD 77 01    ld   (ix+character_x_right_01),a
156F: C9          ret

update_door_background_1570:
1570: 21 BD 80    ld   hl,opening_door_screen_address_80BD
1573: 7E          ld   a,(hl)
1574: B7          or   a
1575: C8          ret  z
; change door into background: it's opening
1576: 57          ld   d,a
1577: 23          inc  hl
1578: 5E          ld   e,(hl)	; load DE as screen address of door to update
1579: 23          inc  hl
157A: ED A0       ldi
157C: ED A0       ldi
157E: C3 73 15    jp   $1573

1581: 21 10 82    ld   hl,red_door_position_array_8210
1584: DD 7E 06    ld   a,(ix+$06)
1587: E6 FE       and  $FE
1589: DD 77 06    ld   (ix+$06),a
158C: DD 4E 02    ld   c,(ix+$02)
158F: 06 00       ld   b,$00
1591: 09          add  hl,bc
1592: 7E          ld   a,(hl)
1593: DD BE 04    cp   (ix+$04)
1596: C0          ret  nz
1597: 3E 01       ld   a,$01
1599: DD B6 06    or   (ix+$06)
159C: DD 77 06    ld   (ix+$06),a
159F: C9          ret

update_sprite_shadow_ram_15a0:
15A0: 11 69 81    ld   de,sprites_shadow_ram_8169
15A3: 3A D8 81    ld   a,($81D8)
15A6: 06 02       ld   b,$02
15A8: 0E 00       ld   c,$00
15AA: B7          or   a
15AB: 28 04       jr   z,$15B1
15AD: 06 FF       ld   b,$FF
15AF: 0E FE       ld   c,$FE
15B1: D9          exx
15B2: 3E 04       ld   a,$04
15B4: 11 05 00    ld   de,$0005
15B7: 06 18       ld   b,$18
15B9: 21 F1 80    ld   hl,$80F1
15BC: BE          cp   (hl)
15BD: 28 15       jr   z,update_sprite_ram_with_object_15d4
next_object_15bf:
15BF: 19          add  hl,de
15C0: 10 FA       djnz $15BC
15C2: 3D          dec  a
15C3: F2 B7 15    jp   p,$15B7
15C6: D9          exx
15C7: 21 C9 81    ld   hl,$81C9
15CA: AF          xor  a
15CB: ED 52       sbc  hl,de
15CD: C8          ret  z
15CE: 45          ld   b,l
15CF: 12          ld   (de),a
15D0: 13          inc  de
15D1: 10 FC       djnz $15CF
15D3: C9          ret

update_sprite_ram_with_object_15d4:
15D4: 08          ex   af,af'
15D5: E5          push hl
15D6: D9          exx
15D7: E1          pop  hl
15D8: 23          inc  hl
15D9: 7E          ld   a,(hl)
15DA: 80          add  a,b
15DB: 12          ld   (de),a
15DC: 23          inc  hl
15DD: 13          inc  de
15DE: 7E          ld   a,(hl)
15DF: 81          add  a,c
15E0: 12          ld   (de),a
15E1: 23          inc  hl
15E2: 13          inc  de
15E3: 7E          ld   a,(hl)
15E4: 12          ld   (de),a
15E5: 23          inc  hl
15E6: 13          inc  de
15E7: 7E          ld   a,(hl)
15E8: 12          ld   (de),a
15E9: 23          inc  hl
15EA: 13          inc  de
15EB: D9          exx
15EC: 08          ex   af,af'
15ED: C3 BF 15    jp   next_object_15bf

update_sprites_15F0:
15F0: 21 69 81    ld   hl,sprites_shadow_ram_8169
; that's one hell of a loop unrolling!!
15F3: 11 7C D1    ld   de,sprite_ram_d100+$7C
15F6: ED A0       ldi
15F8: ED A0       ldi
15FA: ED A0       ldi
15FC: ED A0       ldi
15FE: 11 00 D1    ld   de,sprite_ram_d100
1601: ED A0       ldi
1603: ED A0       ldi
1605: ED A0       ldi
1607: ED A0       ldi
1609: ED A0       ldi
160B: ED A0       ldi
160D: ED A0       ldi
160F: ED A0       ldi
1611: ED A0       ldi
1613: ED A0       ldi
1615: ED A0       ldi
1617: ED A0       ldi
1619: ED A0       ldi
161B: ED A0       ldi
161D: ED A0       ldi
161F: ED A0       ldi
1621: ED A0       ldi
1623: ED A0       ldi
1625: ED A0       ldi
1627: ED A0       ldi
1629: ED A0       ldi
162B: ED A0       ldi
162D: ED A0       ldi
162F: ED A0       ldi
1631: ED A0       ldi
1633: ED A0       ldi
1635: ED A0       ldi
1637: ED A0       ldi
1639: ED A0       ldi
163B: ED A0       ldi
163D: ED A0       ldi
163F: ED A0       ldi
1641: ED A0       ldi
1643: ED A0       ldi
1645: ED A0       ldi
1647: ED A0       ldi
1649: ED A0       ldi
164B: ED A0       ldi
164D: ED A0       ldi
164F: ED A0       ldi
1651: ED A0       ldi
1653: ED A0       ldi
1655: ED A0       ldi
1657: ED A0       ldi
1659: ED A0       ldi
165B: ED A0       ldi
165D: ED A0       ldi
165F: ED A0       ldi
1661: ED A0       ldi
1663: ED A0       ldi
1665: ED A0       ldi
1667: ED A0       ldi
1669: ED A0       ldi
166B: ED A0       ldi
166D: ED A0       ldi
166F: ED A0       ldi
1671: ED A0       ldi
1673: ED A0       ldi
1675: ED A0       ldi
1677: ED A0       ldi
1679: ED A0       ldi
167B: ED A0       ldi
167D: ED A0       ldi
167F: ED A0       ldi
1681: 11 60 D1    ld   de,sprite_ram_d100+$60
1684: ED A0       ldi
1686: ED A0       ldi
1688: ED A0       ldi
168A: ED A0       ldi
168C: ED A0       ldi
168E: ED A0       ldi
1690: ED A0       ldi
1692: ED A0       ldi
1694: ED A0       ldi
1696: ED A0       ldi
1698: ED A0       ldi
169A: ED A0       ldi
169C: ED A0       ldi
169E: ED A0       ldi
16A0: ED A0       ldi
16A2: ED A0       ldi
16A4: ED A0       ldi
16A6: ED A0       ldi
16A8: ED A0       ldi
16AA: ED A0       ldi
16AC: ED A0       ldi
16AE: ED A0       ldi
16B0: ED A0       ldi
16B2: ED A0       ldi
16B4: ED A0       ldi
16B6: ED A0       ldi
16B8: ED A0       ldi
16BA: ED A0       ldi
16BC: C9          ret

16BD: 21 CE 81    ld   hl,$81CE
16C0: 36 06       ld   (hl),$06
16C2: 23          inc  hl
16C3: 36 0C       ld   (hl),$0C
16C5: 23          inc  hl
16C6: 3A 2D 80    ld   a,($802D)
16C9: 4F          ld   c,a
16CA: 0C          inc  c
16CB: 87          add  a,a
16CC: 87          add  a,a
16CD: 87          add  a,a
16CE: 87          add  a,a
16CF: 87          add  a,a
16D0: C6 31       add  a,$31
16D2: 77          ld   (hl),a
16D3: 23          inc  hl
16D4: 71          ld   (hl),c
16D5: 23          inc  hl
16D6: C6 16       add  a,$16
16D8: 77          ld   (hl),a
16D9: 23          inc  hl
16DA: 36 0C       ld   (hl),$0C
16DC: 23          inc  hl
16DD: 36 FA       ld   (hl),$FA
16DF: 23          inc  hl
16E0: 36 0B       ld   (hl),$0B
16E2: C9          ret

table_16E3
	dc.b	06 0C   
	dc.b	31 01 47
	dc.b	0C      
	dc.b	51      
	dc.b	02      
	dc.b	67      
	dc.b	0C      
	dc.b	71      
	dc.b	03      
	dc.b	87      
	dc.b	0C      
	dc.b	91      
	dc.b	04      
	dc.b	A7      
	dc.b	0C      
	dc.b	B1      
	dc.b	05      
	dc.b	C7      
	dc.b	0C      
	dc.b	FA 0B 5B
	dc.b	20 2B   
	dc.b	36 4B   
	dc.b	24      
	dc.b	2F      
	dc.b	1C      
	dc.b	06 0C   
	dc.b	31 01 47
	dc.b	0C      
	dc.b	51      
	dc.b	02      
	dc.b	67      
	dc.b	0C      
	dc.b	71      
	dc.b	03      
	dc.b	87      
	dc.b	0C      
	dc.b	91      
	dc.b	04      
	dc.b	A7      
	dc.b	0C      
	dc.b	B1      
	dc.b	05      
	dc.b	C7      
	dc.b	0C      
	dc.b	FA 0B 5B
	dc.b	20 2B   
table_171E:
	dc.b	84      
	dc.b	6F      
	dc.b	7F      
	dc.b	84      
	dc.b	82      
	dc.b	06 0C   
	dc.b	31 01 47
	dc.b	0C      
	dc.b	51      
	dc.b	02      
	dc.b	67      
	dc.b	0C      
	dc.b	71      
	dc.b	03      
	dc.b	87      
	dc.b	0C      
	dc.b	91      
	dc.b	04      
	dc.b	A7      
	dc.b	0C      
	dc.b	B1      
	dc.b	05      
	dc.b	C7      
	dc.b	0C      
	dc.b	FA 0B 5B
	dc.b	20 2B   
	dc.b	36 4B   
	dc.b	24      
	dc.b	2F      
	dc.b	1C      
	dc.b	06 0C   
	dc.b	31 01 47
	dc.b	0C      
	dc.b	51      
	dc.b	02      
	dc.b	67      
	dc.b	0C      
	dc.b	71      
	dc.b	03      
	dc.b	87      
	dc.b	0C      
	dc.b	91      
	dc.b	04      
	dc.b	A7      
	dc.b	0C      
	dc.b	B1      
	dc.b	05      
	dc.b	C7      
	dc.b	0C      
	dc.b	FA 0B 5B
	dc.b	20 2B   
	dc.b	36 4B   
	dc.b	24      
	dc.b	2F      
	dc.b	1C      
	dc.b	06 0C   
	dc.b	31 01 47
	dc.b	0C      
	dc.b	51      
	dc.b	02      
	dc.b	67      
	dc.b	0C      
	dc.b	71      
	dc.b	03      
	dc.b	87      
	dc.b	0C      
	dc.b	91      
	dc.b	04      
	dc.b	A7      
	dc.b	0C      
	dc.b	B1      
	dc.b	05      
	dc.b	C7      
	dc.b	0C      
	dc.b	FA 0B 5B
	dc.b	20 2B   
	dc.b	36 4B   
	dc.b	24      
	dc.b	2F      
	dc.b	1C      
	dc.b	06 0C   
	dc.b	31 01 47
	dc.b	0C      
	dc.b	51      
	dc.b	02      
	dc.b	67      
	dc.b	0C      
	dc.b	71      
	dc.b	03      
	dc.b	87      
	dc.b	0C      
	dc.b	91      
	dc.b	04      
	dc.b	A7      
	dc.b	0C      
	dc.b	B1      
	dc.b	05      
	dc.b	C7      
	dc.b	0C      
	dc.b	FA 0B 5B
	dc.b	20 2B   
	dc.b	36 4B   
	dc.b	24      
	dc.b	2F      
	dc.b	1C      
	dc.b	06 0C   
	dc.b	31 01 47
	dc.b	0C      
	dc.b	51      
	dc.b	02      
	dc.b	67      
	dc.b	0C      
	dc.b	91      
	dc.b	04      
	dc.b	A7      
	dc.b	0C      
	dc.b	B1      
	dc.b	05      
	dc.b	C7      
	dc.b	0C      
	dc.b	FA 0B 5B
	dc.b	20 2B   
	dc.b	36 4B   
	dc.b	24      
	dc.b	2F      
	dc.b	1C      
	dc.b	45      
	dc.b	D2 37 D4
	dc.b	06 0C   
	dc.b	11 00 27
	dc.b	0C      
	dc.b	51      
	dc.b	02      
	dc.b	67      
	dc.b	0C      
	dc.b	91      
	dc.b	04      
	dc.b	A7      
	dc.b	0C      
	dc.b	B1      
	dc.b	05      
	dc.b	C7      
	dc.b	0C      
	dc.b	D1      
	dc.b	06 E7   
	dc.b	0C      
	dc.b	FA 0B 5B
	dc.b	20 2B   
	dc.b	36 4B   
	dc.b	24      
	dc.b	2F      
	dc.b	1C      
	dc.b	06 0C   
	dc.b	11 00 27
	dc.b	0C      
	dc.b	D1      
	dc.b	06 E7   
	dc.b	0C      
	dc.b	FA 0B 5B
	dc.b	20 2B   
	dc.b	36 4B   
	dc.b	24      
	dc.b	2F      
	dc.b	1C      
	dc.b	3B      
	dc.b	6E      
	dc.b	01 20 21
	dc.b	36 5F   
	dc.b	24      
	dc.b	39      
	dc.b	62      
	dc.b	31 D2 06
	dc.b	0C      
	dc.b	11 00 27
	dc.b	0C      
	dc.b	D1      
	dc.b	06 E7   
	dc.b	0C      
	dc.b	FA 0B BF
	dc.b	20 35   
	dc.b	36 55   
	dc.b	24      
	dc.b	2F      
	dc.b	30 3B   
	dc.b	6E      
	dc.b	01 E8 49
	dc.b	36 19   
	dc.b	24      
	dc.b	25      
	dc.b	62      
	dc.b	27      
	dc.b	D2 06 0C
	dc.b	11 00 27
	dc.b	0C      
	dc.b	71      
	dc.b	08      
	dc.b	87      
	dc.b	0C      
	dc.b	D1      
	dc.b	06 E7   
	dc.b	0C      
	dc.b	FA 0B 1F
	dc.b	52      
	dc.b	2B      
	dc.b	40      
	dc.b	4B      
	dc.b	4C      
	dc.b	1B      
	dc.b	1C      
	dc.b	29      
	dc.b	34      
	dc.b	21 40 5F
	dc.b	38 25   
	dc.b	62      
	dc.b	06 0C   
	dc.b	11 00 27
	dc.b	0C      
	dc.b	71      
	dc.b	08      
	dc.b	87      
	dc.b	0C      
	dc.b	D1      
	dc.b	06 E7   
	dc.b	0C      
	dc.b	FA 0B 33
	dc.b	2A 17 0E7)
	dc.b	5F      
	dc.b	38 1B   
	dc.b	76      
	dc.b	29      
	dc.b	34      
	dc.b	21 40 5F
	dc.b	38 25   
	dc.b	E4 06 0C
	dc.b	71      
	dc.b	08      
	dc.b	87      
	dc.b	0C      
	dc.b	D1      
	dc.b	06 E7   
	dc.b	0C      
	dc.b	FA 0B BF
	dc.b	20 35   
	dc.b	36 55   
	dc.b	24      
	dc.b	2F      
	dc.b	30 3B   
	dc.b	6E      
	dc.b	01 E8 49
	dc.b	36 19   
	dc.b	24      
	dc.b	25      
	dc.b	62      
	dc.b	27      
	dc.b	D2 06 0C
	dc.b	11 07 27
	dc.b	0C      
	dc.b	D1      
	dc.b	06 E7   
	dc.b	0C      
	dc.b	FA 0B BF
	dc.b	20 35   
	dc.b	36 55   
	dc.b	24      
	dc.b	2F      
	dc.b	30 3B   
	dc.b	6E      
	dc.b	01 E8 49
	dc.b	36 19   
	dc.b	24      
	dc.b	25      
	dc.b	62      
	dc.b	27      
	dc.b	D2 06 0C
	dc.b	11 07 27
	dc.b	0C      
	dc.b	FA 0B BF
	dc.b	20 35   
	dc.b	36 55   
	dc.b	24      
	dc.b	2F      
	dc.b	30 3B   
	dc.b	6E      
	dc.b	6F      
	dc.b	70      
	dc.b	5B      
	dc.b	E8      
	dc.b	35      
	dc.b	22 19 24hl
	dc.b	43      
	dc.b	44      
	dc.b	27      
	dc.b	D2 6F 70
	dc.b	06 0C   
	dc.b	11 07 27
	dc.b	0C      
	dc.b	71      
	dc.b	09      
	dc.b	87      
	dc.b	0C      
	dc.b	FA 0B 8D
	dc.b	0C      
	dc.b	17      
	dc.b	36 2D   
	dc.b	24      
	dc.b	43      
	dc.b	30 3B   
	dc.b	6E      
	dc.b	1F      
	dc.b	84      
	dc.b	49      
	dc.b	36 19   
	dc.b	2E 25   
	dc.b	1C      
	dc.b	27      
	dc.b	D2 06 0C
	dc.b	71      
	dc.b	09      
	dc.b	87      
	dc.b	0C      
	dc.b	FA 0B 79
	dc.b	16 35   
	dc.b	18 55   
	dc.b	1A      
	dc.b	1B      
	dc.b	30 1D   
	dc.b	6E      
	dc.b	0B      
	dc.b	0C      
	dc.b	01 DE 49
	dc.b	18 19   
	dc.b	1A      
	dc.b	1B      
	dc.b	62      
	dc.b	3B      
	dc.b	D2 0B 0C
	dc.b	06 0C   
	dc.b	71      
	dc.b	09      
	dc.b	87      
	dc.b	0C      
	dc.b	FA 0B 79
	dc.b	16 35   
	dc.b	18 55   
	dc.b	1A      
	dc.b	1B      
	dc.b	30 1D   
	dc.b	6E      
	dc.b	0B      
	dc.b	0C      
	dc.b	01 DE 49
	dc.b	18 19   
	dc.b	1A      
	dc.b	1B      
	dc.b	62      
	dc.b	3B      
	dc.b	D2 0B 0C
	dc.b	06 0C   
	dc.b	79      
	dc.b	0B      
	dc.b	7F      
	dc.b	0C      
	dc.b	FA 0B 79
	dc.b	16 35   
	dc.b	18 55   
	dc.b	1A      
	dc.b	1B      
	dc.b	30 1D   
	dc.b	6E      
	dc.b	0B      
	dc.b	0C      
	dc.b	01 DE 49
	dc.b	18 19   
	dc.b	1A      
	dc.b	1B      
	dc.b	62      
	dc.b	3B      
	dc.b	D2 0B 0C
	dc.b	06 0C   
	dc.b	71      
	dc.b	0A      
	dc.b	87      
	dc.b	0C      
	dc.b	FA 0B 79
	dc.b	16 35   
	dc.b	18 55   
	dc.b	1A      
	dc.b	1B      
	dc.b	30 1D   
	dc.b	6E      
	dc.b	0B      
	dc.b	0C      
	dc.b	01 DE 49
	dc.b	18 19   
	dc.b	1A      
	dc.b	1B      
	dc.b	62      
	dc.b	3B      
	dc.b	D2 0B 0C
	dc.b	06 0C   
	dc.b	71      
	dc.b	0A      
	dc.b	87      
	dc.b	0C      
	dc.b	A9      
	dc.b	0B      
	dc.b	AF      
	dc.b	0C      
	dc.b	FA 0B 35
	dc.b	18 55   
	dc.b	1A      
	dc.b	1B      
	dc.b	30 1D   
	dc.b	6E      
	dc.b	0B      
	dc.b	0C      
	dc.b	49      
	dc.b	18 19   
	dc.b	1A      
	dc.b	1B      
	dc.b	62      
	dc.b	3B      
	dc.b	D2 0B 0C
	dc.b	26 0C   
	dc.b	71      
	dc.b	0A      
	dc.b	87      
	dc.b	0C      
	dc.b	D2 0B 79
	dc.b	16 35   
	dc.b	18 55   
	dc.b	1A      
	dc.b	1B      
	dc.b	30 1D   
	dc.b	6E      
	dc.b	0B      
	dc.b	0C      
	dc.b	01 DE 49
	dc.b	18 19   
	dc.b	1A      
	dc.b	1B      
	dc.b	62      
	dc.b	3B      
	dc.b	D2 0B 0C
	dc.b	26 0C   
	dc.b	71      
	dc.b	0A      
	dc.b	87      
	dc.b	0C      
	dc.b	D2 0B 79
	dc.b	16 35   
	dc.b	18 55   
	dc.b	1A      
	dc.b	1B      
	dc.b	30 1D   
	dc.b	6E      
	dc.b	0B      
	dc.b	0C      
	dc.b	01 DE 49
	dc.b	18 19   
	dc.b	1A      
	dc.b	1B      
	dc.b	62      
	dc.b	3B      
	dc.b	D2 0B 0C
	dc.b	26 0C   
	dc.b	71      
	dc.b	0A      
	dc.b	87      
	dc.b	0C      
	dc.b	D2 0B 79
	dc.b	16 35   
	dc.b	18 55   
	dc.b	1A      
	dc.b	1B      
	dc.b	30 1D   
	dc.b	6E      
	dc.b	0B      
	dc.b	0C      
	dc.b	01 DE 49
	dc.b	18 19   
	dc.b	1A      
	dc.b	1B      
	dc.b	62      
	dc.b	3B      
	dc.b	D2 0B 0C
	dc.b	26 0C   
	dc.b	71      
	dc.b	0A      
	dc.b	87      
	dc.b	0C      
	dc.b	D2 0B 79
	dc.b	16 35   
	dc.b	18 55   
	dc.b	1A      
	dc.b	1B      
	dc.b	30 1D   
	dc.b	6E      
	dc.b	0B      
	dc.b	0C      
	dc.b	01 DE 49
	dc.b	18 19   
	dc.b	1A      
	dc.b	1B      
	dc.b	62      
	dc.b	3B      
	dc.b	D2 0B 0C
	dc.b	26 0C   
	dc.b	71      
	dc.b	0A      
	dc.b	87      
	dc.b	0C      
	dc.b	D2 0B 79
	dc.b	16 35   
	dc.b	18 55   
	dc.b	1A      
	dc.b	1B      
	dc.b	30 1D   
	dc.b	6E      
	dc.b	0B      
	dc.b	0C      
	dc.b	01 DE 49
	dc.b	18 19   
	dc.b	1A      
	dc.b	1B      
	dc.b	62      
	dc.b	3B      
	dc.b	D2 0B 0C
	dc.b	26 0C   
	dc.b	71      
	dc.b	0A      
	dc.b	87      
	dc.b	0C      
	dc.b	D2 0B 79
	dc.b	16 35   
	dc.b	18 55   
	dc.b	1A      
	dc.b	1B      
	dc.b	30 1D   
	dc.b	6E      
	dc.b	0B      
	dc.b	0C      
	dc.b	01 DE 49
	dc.b	18 19   
	dc.b	1A      
	dc.b	1B      
	dc.b	62      
	dc.b	3B      
	dc.b	D2 0B 0C
	dc.b	26 0C   
	dc.b	71      
	dc.b	0A      
	dc.b	87      
	dc.b	0C      
	dc.b	D2 0B 79
	dc.b	16 35   
	dc.b	18 55   
	dc.b	1A      
	dc.b	1B      
	dc.b	30 1D   
	dc.b	6E      
	dc.b	0B      
	dc.b	0C      
	dc.b	01 DE 49
	dc.b	18 19   
	dc.b	1A      
	dc.b	1B      
	dc.b	62      
	dc.b	3B      
	dc.b	D2 0B 0C
	dc.b	26 0C   
	dc.b	71      
	dc.b	0A      
	dc.b	87      
	dc.b	0C      
	dc.b	D2 0B 79
	dc.b	16 35   
	dc.b	18 55   
	dc.b	1A      
	dc.b	1B      
	dc.b	30 1D   
	dc.b	6E      
	dc.b	0B      
	dc.b	0C      
	dc.b	01 DE 49
	dc.b	18 19   
	dc.b	1A      
	dc.b	1B      
	dc.b	62      
	dc.b	3B      
	dc.b	D2 0B 0C
	dc.b	26 0C   
	dc.b	71      
	dc.b	0A      
	dc.b	87      
	dc.b	0C      
	dc.b	D2 0B 79
	dc.b	16 35   
	dc.b	18 55   
	dc.b	1A      
	dc.b	1B      
	dc.b	30 1D   
	dc.b	6E      
	dc.b	0B      
	dc.b	0C      
	dc.b	01 DE 49
	dc.b	18 19   
	dc.b	1A      
	dc.b	1B      
	dc.b	62      
	dc.b	3B      
	dc.b	D2 0B 0C
	dc.b	26 0C   
	dc.b	71      
	dc.b	0A      
	dc.b	87      
	dc.b	0C      
	dc.b	D2 0B 79
	dc.b	16 35   
	dc.b	18 55   
	dc.b	1A      
	dc.b	1B      
	dc.b	30 1D   
	dc.b	6E      
	dc.b	0B      
	dc.b	0C      
	dc.b	01 DE 49
	dc.b	18 19   
	dc.b	1A      
	dc.b	1B      
	dc.b	62      
	dc.b	3B      
	dc.b	D2 0B 0C
	dc.b	26 0C   
	dc.b	71      
	dc.b	0A      
	dc.b	87      
	dc.b	0B      
	dc.b	79      
	dc.b	16 35   
	dc.b	18 55   
	dc.b	1A      
	dc.b	1B      
	dc.b	30 1D   
	dc.b	6E      
	dc.b	0B      
	dc.b	0C      
	dc.b	71      
	dc.b	01 DE 49
	dc.b	18 19   
	dc.b	1A      
	dc.b	1B      
	dc.b	62      
	dc.b	3B      
	dc.b	D2 0B 0C
	dc.b	71      

enemy_in_elevator_1AE3:
1AE3: AF          xor  a
1AE4: DD 77 18    ld   (ix+$18),a
1AE7: DD 77 1A    ld   (ix+$1a),a
1AEA: DD 77 17    ld   (ix+$17),a
1AED: DD 36 0E 5A ld   (ix+$0e),$5A
1AF1: 3A 21 85    ld   a,(player_structure_851A+current_floor_07)
1AF4: FE 07       cp   $07
1AF6: DA 25 1B    jp   c,$1B25
1AF9: DD 7E 10    ld   a,(ix+$10)
1AFC: B7          or   a
1AFD: C2 1C 1B    jp   nz,$1B1C
1B00: CD 68 05    call should_enemy_shoot_0568
1B03: D2 20 1B    jp   nc,$1B20
1B06: 3A 20 85    ld   a,($8520)
1B09: B7          or   a
1B0A: 28 0D       jr   z,$1B19
1B0C: 3A 22 85    ld   a,(player_structure_851A+associated_elevator_08)
1B0F: DD BE 08    cp   (ix+associated_elevator_08)
1B12: 20 05       jr   nz,$1B19
1B14: CD 89 1B    call $1B89
1B17: 18 03       jr   $1B1C
1B19: CD 74 1B    call $1B74
1B1C: CD 3B 00    call $003B
1B1F: C9          ret
1B20: DD 36 0F 00 ld   (ix+$0f),$00
1B24: C9          ret
1B25: DD 7E 10    ld   a,(ix+$10)
1B28: B7          or   a
1B29: C2 1C 1B    jp   nz,$1B1C
1B2C: CD 68 05    call should_enemy_shoot_0568
1B2F: D2 20 1B    jp   nc,$1B20
1B32: CD 44 1C    call $1C44
1B35: C3 1C 1B    jp   $1B1C

enemy_jumping_above_elevator_1B38:
1B38: AF          xor  a
1B39: DD 77 18    ld   (ix+$18),a
1B3C: DD 77 1A    ld   (ix+$1a),a
1B3F: DD 77 17    ld   (ix+$17),a
1B42: DD 36 0E 5A ld   (ix+$0e),$5A
1B46: DD 7E 11    ld   a,(ix+$11)
1B49: B7          or   a
1B4A: 28 15       jr   z,$1B61
1B4C: DD 7E 12    ld   a,(ix+$12)
1B4F: FE 04       cp   $04
1B51: 30 0A       jr   nc,$1B5D
1B53: DD 7E 0B    ld   a,(ix+$0b)
1B56: EE 01       xor  $01
1B58: DD 77 0B    ld   (ix+$0b),a
1B5B: 18 04       jr   $1B61
1B5D: DD 36 12 04 ld   (ix+$12),$04
1B61: DD 7E 10    ld   a,(ix+$10)
1B64: B7          or   a
1B65: C2 1C 1B    jp   nz,$1B1C
1B68: CD 68 05    call should_enemy_shoot_0568
1B6B: D2 20 1B    jp   nc,$1B20
1B6E: CD 9E 1B    call $1B9E
1B71: C3 1C 1B    jp   $1B1C

1B74: CD CE 62    call load_character_elevator_structure_62CE
1B77: CD AA 1B    call $1BAA
1B7A: FD 7E 00    ld   a,(iy+$00)
1B7D: FE 10       cp   $10
1B7F: D0          ret  nc
1B80: 3E 03       ld   a,$03
1B82: DD B6 12    or   (ix+$12)
1B85: DD 77 12    ld   (ix+$12),a
1B88: C9          ret
1B89: CD AA 1B    call $1BAA
1B8C: DD 7E 12    ld   a,(ix+$12)
1B8F: B7          or   a
1B90: C0          ret  nz
1B91: DD 36 12 03 ld   (ix+$12),$03
1B95: DD 7E 0B    ld   a,(ix+$0b)
1B98: EE 01       xor  $01
1B9A: DD 77 0B    ld   (ix+$0b),a
1B9D: C9          ret
1B9E: CD AA 1B    call $1BAA
1BA1: DD 7E 12    ld   a,(ix+$12)
1BA4: F6 03       or   $03
1BA6: DD 77 12    ld   (ix+$12),a
1BA9: C9          ret
1BAA: DD 36 12 00 ld   (ix+$12),$00
1BAE: 2A BD 85    ld   hl,($85BD)
1BB1: 7E          ld   a,(hl)
1BB2: 3C          inc  a
1BB3: DD B6 19    or   (ix+$19)
1BB6: 20 1D       jr   nz,$1BD5
1BB8: 3A 23 85    ld   a,(player_structure_851A+9)
1BBB: D6 05       sub  $05
1BBD: 28 16       jr   z,$1BD5
1BBF: 3D          dec  a
1BC0: 28 13       jr   z,$1BD5
1BC2: 21 04 1C    ld   hl,table_1C04
1BC5: DD 5E 13    ld   e,(ix+enemy_aggressivity_13)
1BC8: 16 00       ld   d,$00
1BCA: 19          add  hl,de
1BCB: CD F5 1D    call pseudo_random_1DF5
1BCE: BE          cp   (hl)
1BCF: 30 04       jr   nc,$1BD5
1BD1: DD 36 12 04 ld   (ix+$12),$04
1BD5: 3A BA 85    ld   a,(current_enemy_index_85BA)
1BD8: 5F          ld   e,a
1BD9: 16 00       ld   d,$00
1BDB: 21 F8 82    ld   hl,$82F8
1BDE: 19          add  hl,de
1BDF: 3E 0A       ld   a,$0A
1BE1: DD 96 13    sub  (ix+enemy_aggressivity_13)
1BE4: 30 01       jr   nc,$1BE7
1BE6: AF          xor  a
1BE7: 77          ld   (hl),a
1BE8: C6 02       add  a,$02
1BEA: FE 07       cp   $07
1BEC: 30 02       jr   nc,$1BF0
1BEE: 3E 07       ld   a,$07
1BF0: DD 77 10    ld   (ix+$10),a
1BF3: 32 00 80    ld   ($8000),a
1BF6: 3A 1A 85    ld   a,(player_structure_851A)
1BF9: DD 96 00    sub  (ix+character_x_00)
1BFC: 3F          ccf
1BFD: 17          rla
1BFE: E6 01       and  $01
1C00: DD 77 0B    ld   (ix+$0b),a
1C03: C9          ret

table_1C04:
	dc.b	00       
	dc.b	20 40    
	dc.b	80       
	dc.b	90       
	dc.b	A0       
	dc.b	B0       
	dc.b	C0       
	dc.b	FF       
	dc.b	FF       
	dc.b	FF       
	dc.b	FF       
	dc.b	FF       
	dc.b	FF       
	dc.b	FF       
	dc.b	FF       

enemy_shooting_state_1C14:
1C14: DD 36 1B 00 ld   (ix+$1b),$00
1C18: DD 36 18 00 ld   (ix+$18),$00
1C1C: DD 36 0E 5A ld   (ix+$0e),$5A
1C20: DD 7E 10    ld   a,(ix+$10)
1C23: B7          or   a
1C24: C2 30 1C    jp   nz,$1C30
1C27: CD 68 05    call should_enemy_shoot_0568
1C2A: D2 3B 1C    jp   nc,$1C3B
1C2D: CD 44 1C    call $1C44
1C30: CD F5 05    call $05F5
1C33: CD 3B 00    call $003B
1C36: DD 36 08 FF ld   (ix+$08),$FF
1C3A: C9          ret
1C3B: DD 36 0F 00 ld   (ix+$0f),$00
1C3F: DD 36 10 00 ld   (ix+$10),$00
1C43: C9          ret

1C44: 2A BD 85    ld   hl,($85BD)
1C47: 7E          ld   a,(hl)
1C48: 3C          inc  a
1C49: DD B6 19    or   (ix+$19)
1C4C: 28 11       jr   z,$1C5F
1C4E: 3A BA 85    ld   a,(current_enemy_index_85BA)
1C51: FE 03       cp   $03
1C53: 21 D5 1D    ld   hl,$1DD5
1C56: 30 03       jr   nc,$1C5B
1C58: 21 B5 1D    ld   hl,$1DB5
1C5B: CD 3F 1D    call $1D3F
1C5E: C9          ret
1C5F: 3A 23 85    ld   a,(player_structure_851A+9)
1C62: D6 05       sub  $05
1C64: 28 E8       jr   z,$1C4E
1C66: 3D          dec  a
1C67: 28 E5       jr   z,$1C4E
1C69: 3A BA 85    ld   a,(current_enemy_index_85BA)
1C6C: FE 03       cp   $03
1C6E: 21 95 1D    ld   hl,$1D95
1C71: 30 03       jr   nc,$1C76
1C73: 21 75 1D    ld   hl,table_1D75
1C76: CD 7A 1C    call $1C7A
1C79: C9          ret

1C7A: DD 7E 13    ld   a,(ix+enemy_aggressivity_13)
1C7D: E6 FE       and  $FE
1C7F: 87          add  a,a
1C80: 5F          ld   e,a
1C81: 16 00       ld   d,$00
1C83: 19          add  hl,de
1C84: CD F5 1D    call pseudo_random_1DF5
1C87: 06 04       ld   b,$04
1C89: BE          cp   (hl)
1C8A: 38 0B       jr   c,$1C97
1C8C: 04          inc  b
1C8D: 23          inc  hl
1C8E: BE          cp   (hl)
1C8F: 38 06       jr   c,$1C97
1C91: 04          inc  b
1C92: 23          inc  hl
1C93: BE          cp   (hl)
1C94: 38 01       jr   c,$1C97
1C96: 04          inc  b
1C97: DD 70 12    ld   (ix+$12),b
1C9A: 3A BA 85    ld   a,(current_enemy_index_85BA)
1C9D: 5F          ld   e,a
1C9E: 16 00       ld   d,$00
1CA0: 21 F8 82    ld   hl,$82F8
1CA3: 19          add  hl,de
1CA4: 3E 0A       ld   a,$0A
1CA6: DD 96 13    sub  (ix+enemy_aggressivity_13)
1CA9: 30 01       jr   nc,$1CAC
1CAB: AF          xor  a
1CAC: 77          ld   (hl),a
1CAD: C6 02       add  a,$02
1CAF: FE 07       cp   $07
1CB1: 30 02       jr   nc,$1CB5
1CB3: 3E 07       ld   a,$07
1CB5: DD 77 10    ld   (ix+$10),a
1CB8: 32 00 80    ld   ($8000),a
1CBB: 3A 1A 85    ld   a,(player_structure_851A)
1CBE: DD BE 00    cp   (ix+character_x_00)
1CC1: 3F          ccf
1CC2: 3E 00       ld   a,$00
1CC4: 17          rla
1CC5: DD 77 0B    ld   (ix+$0b),a
1CC8: CD CC 1C    call $1CCC
1CCB: C9          ret

1CCC: DD 7E 12    ld   a,(ix+$12)
1CCF: FE 06       cp   $06
1CD1: 28 29       jr   z,$1CFC
1CD3: DD 7E 13    ld   a,(ix+enemy_aggressivity_13)
1CD6: B7          or   a
1CD7: C8          ret  z
1CD8: 3A 30 85    ld   a,($8530)
1CDB: DD 96 16    sub  (ix+$16)
1CDE: C6 08       add  a,$08
1CE0: FA F1 1C    jp   m,$1CF1
1CE3: FE 10       cp   $10
1CE5: D8          ret  c
1CE6: DD 7E 12    ld   a,(ix+$12)
1CE9: FE 07       cp   $07
1CEB: C8          ret  z
1CEC: DD 36 12 04 ld   (ix+$12),$04
1CF0: C9          ret
1CF1: DD 7E 12    ld   a,(ix+$12)
1CF4: FE 06       cp   $06
1CF6: C8          ret  z
1CF7: DD 36 12 05 ld   (ix+$12),$05
1CFB: C9          ret
1CFC: DD 7E 00    ld   a,(ix+character_x_00)
1CFF: FE 10       cp   $10
1D01: 38 37       jr   c,$1D3A
1D03: FE F0       cp   $F0
1D05: 30 33       jr   nc,$1D3A
1D07: DD 7E 07    ld   a,(ix+$07)
1D0A: FE 07       cp   $07
1D0C: 28 21       jr   z,$1D2F
1D0E: FE 06       cp   $06
1D10: 28 12       jr   z,$1D24
1D12: 30 BF       jr   nc,$1CD3
1D14: B7          or   a
1D15: 28 BC       jr   z,$1CD3
1D17: DD 7E 00    ld   a,(ix+character_x_00)
1D1A: FE 41       cp   $41
1D1C: 38 B5       jr   c,$1CD3
1D1E: FE B4       cp   $B4
1D20: 38 18       jr   c,$1D3A
1D22: 18 AF       jr   $1CD3
1D24: DD 7E 00    ld   a,(ix+character_x_00)
1D27: FE 41       cp   $41
1D29: 38 A8       jr   c,$1CD3
1D2B: FE 5A       cp   $5A
1D2D: 38 0B       jr   c,$1D3A
1D2F: DD 7E 00    ld   a,(ix+character_x_00)
1D32: FE A0       cp   $A0
1D34: 38 9D       jr   c,$1CD3
1D36: FE B4       cp   $B4
1D38: 30 99       jr   nc,$1CD3
1D3A: DD 36 12 05 ld   (ix+$12),$05
1D3E: C9          ret
1D3F: DD 7E 13    ld   a,(ix+enemy_aggressivity_13)
1D42: E6 FE       and  $FE
1D44: 87          add  a,a
1D45: 5F          ld   e,a
1D46: 16 00       ld   d,$00
1D48: 19          add  hl,de
1D49: CD F5 1D    call pseudo_random_1DF5
1D4C: 01 00 00    ld   bc,$0000
1D4F: BE          cp   (hl)
1D50: 38 0D       jr   c,$1D5F
1D52: 04          inc  b
1D53: 23          inc  hl
1D54: BE          cp   (hl)
1D55: 38 08       jr   c,$1D5F
1D57: 06 03       ld   b,$03
1D59: 23          inc  hl
1D5A: BE          cp   (hl)
1D5B: 38 02       jr   c,$1D5F
1D5D: 0E 01       ld   c,$01
1D5F: DD 70 12    ld   (ix+$12),b
1D62: DD 36 10 0A ld   (ix+$10),$0A
1D66: 3A 1A 85    ld   a,(player_structure_851A)
1D69: DD BE 00    cp   (ix+character_x_00)
1D6C: 3F          ccf
1D6D: 3E 00       ld   a,$00
1D6F: 17          rla
1D70: A9          xor  c
1D71: DD 77 0B    ld   (ix+$0b),a
1D74: C9          ret

table_1D75:
	dc.b	C4 C4 C4    
	dc.b	00          
	dc.b	80          
	dc.b	C4 C4 00    
	dc.b	40          
	dc.b	C4 C4 00    
	dc.b	20 80       
	dc.b	C4 00 08    
	dc.b	40          
	dc.b	C4 00 08    
	dc.b	20 C4       
	dc.b	00          
	dc.b	08          
	dc.b	10 C4       
	dc.b	00          
	dc.b	00          
	dc.b	08          
	dc.b	C4 00 40    
	dc.b	40          
	dc.b	40          
	dc.b	00          
	dc.b	30 40       
	dc.b	40          
	dc.b	00          
	dc.b	20 40       
	dc.b	40          
	dc.b	00          
	dc.b	18 30       
	dc.b	40          
	dc.b	00          
	dc.b	10 20       
	dc.b	40          
	dc.b	00          
	dc.b	08          
	dc.b	10 40       
	dc.b	00          
	dc.b	00          
	dc.b	08          
	dc.b	40          
	dc.b	00          
	dc.b	00          
	dc.b	00          
	dc.b	40          
	dc.b	00          
	dc.b	C4 C4 DC    
	dc.b	00          
	dc.b	90          
	dc.b	C4 DC 00    
	dc.b	80          
	dc.b	C4 DC 00    
	dc.b	40          
	dc.b	C4 DC 00    
	dc.b	20 C4       
	dc.b	DC 00 10    
	dc.b	C4 DC 00    
	dc.b	00          
	dc.b	C4 DC 00    
	dc.b	00          
	dc.b	C4 DC 00    
	dc.b	80          
	dc.b	80          
	dc.b	FF          
	dc.b	00          
	dc.b	70          
	dc.b	80          
	dc.b	FF          
	dc.b	00          
	dc.b	60          
	dc.b	80          
	dc.b	FF          
	dc.b	00          
	dc.b	40          
	dc.b	80          
	dc.b	FF          
	dc.b	00          
	dc.b	20 C4       
	dc.b	FF          
	dc.b	00          
	dc.b	10 C4       
	dc.b	FF          
	dc.b	00          
	dc.b	08          
	dc.b	C4 FF 00    
	dc.b	00          
	dc.b	C4 FF 00    

pseudo_random_1DF5:
pseudo_random_with_regsave_1DF5:
1DF5: E5          push hl
1DF6: 2A D6 81    ld   hl,(pseudo_random_seed_81D6)
1DF9: 7D          ld   a,l
1DFA: C6 C7       add  a,$C7
1DFC: 6F          ld   l,a
1DFD: 8C          adc  a,h
1DFE: D6 C7       sub  $C7
1E00: 67          ld   h,a
1E01: 22 D6 81    ld   (pseudo_random_seed_81D6),hl
1E04: E1          pop  hl
1E05: C9          ret

pseudo_random_1E06:
1E06: 2A D6 81    ld   hl,(pseudo_random_seed_81D6)
1E09: 7D          ld   a,l
1E0A: C6 C7       add  a,$C7
1E0C: 6F          ld   l,a
1E0D: 8C          adc  a,h
1E0E: D6 C7       sub  $C7
1E10: 67          ld   h,a
1E11: 22 D6 81    ld   (pseudo_random_seed_81D6),hl
1E14: C9          ret

; seems to be never called. Only called from 1E1D through ramdon_1E2A
1E15: E5          push hl
1E16: CD 06 1E    call pseudo_random_1E06
1E19: 26 A0       ld   h,$A0		; standard params for random
1E1B: 2E 06       ld   l,$06		; not called/used
; now the code is used
some_arith_op_1E1D:
1E1D: BC          cp   h
1E1E: DA 22 1E    jp   c,$1E22	; jumps if h > a
1E21: 94          sub  h		; a = a - h
1E22: CB 0C       rrc  h		; h = h / 2
1E24: 2D          dec  l		; do it l times
1E25: C2 1D 1E    jp   nz,some_arith_op_1E1D
1E28: E1          pop  hl
1E29: C9          ret

; random dollowed by some kind of division to get a small
; number in A
ramdon_1E2A:
random_1E2A:
1E2A: E5          push hl
1E2B: CD 06 1E    call pseudo_random_1E06
1E2E: 26 C0       ld   h,$C0
1E30: 2E 07       ld   l,$07
1E32: C3 1D 1E    jp   some_arith_op_1E1D

; random dollowed by some kind of division to get a small
; number in A
ramdon_1E35:
random_1E35:
1E35: E5          push hl
1E36: CD 06 1E    call pseudo_random_1E06
1E39: 26 E0       ld   h,$E0
1E3B: C3 1B 1E    jp   $1E1B

get_random_value_1e3e:
1E3E: E5          push hl
1E3F: CD 06 1E    call pseudo_random_1E06
1E42: 60          ld   h,b
1E43: 2E 00       ld   l,$00
1E45: 2C          inc  l
1E46: CB 04       rlc  h
1E48: D2 45 1E    jp   nc,$1E45
1E4B: CB 0C       rrc  h
1E4D: BC          cp   h
1E4E: DA 52 1E    jp   c,$1E52
1E51: 94          sub  h
1E52: CB 0C       rrc  h
1E54: 2D          dec  l
1E55: C2 4D 1E    jp   nz,$1E4D
1E58: E1          pop  hl
1E59: C9          ret

1E5A: 04          inc  b
1E5B: 78          ld   a,b
1E5C: 80          add  a,b
1E5D: 80          add  a,b
1E5E: 87          add  a,a
1E5F: 81          add  a,c
1E60: 3C          inc  a
1E61: 26 00       ld   h,$00
1E63: 6F          ld   l,a
1E64: 29          add  hl,hl
1E65: 29          add  hl,hl
1E66: 29          add  hl,hl
1E67: 5A          ld   e,d
1E68: 16 00       ld   d,$00
1E6A: 19          add  hl,de
1E6B: C9          ret

compute_delta_height_1e6c:
1E6C: CD 5A 1E    call $1E5A
1E6F: ED 5B 2A 80 ld   de,($802A)
1E73: AF          xor  a
1E74: ED 52       sbc  hl,de
1E76: C9          ret

; seems unused? we'll see
	dc.b	2C      
	dc.b	75      
	dc.b	4C      
	dc.b	26 85   
	dc.b	34      
	dc.b	B7      
	dc.b	45      
	dc.b	7A      
	dc.b	26 2B   
	dc.b	12      
	dc.b	BB      
	dc.b	57      
	dc.b	C3 75 38
	dc.b	6B      
	dc.b	12      
	dc.b	63      
	dc.b	3D      
	dc.b	C1      
	dc.b	9A      
	dc.b	26 2B   
	dc.b	10 3F   
	dc.b	1F      
	dc.b	5F      
	dc.b	70      
	dc.b	9C      
	dc.b	88      
	dc.b	A0      
	dc.b	4C      
	dc.b	97      
	dc.b	B4      
	dc.b	C3 8C 73
	dc.b	90      
	dc.b	A0      
	dc.b	4F      
	dc.b	0B      
	dc.b	4F      
	dc.b	58      
	dc.b	1E A4   
	dc.b	C6 49   
	dc.b	94      
	dc.b	BE      
	dc.b	8C      
	dc.b	39      
	dc.b	C3 89 38
	dc.b	8B      
	dc.b	FD 6F   
	dc.b	FB      
	dc.b	6F      
	dc.b	E7      
	dc.b	BD      
	dc.b	C3 4A 8F
	dc.b	55      
	dc.b	F7      
	dc.b	B2      
	dc.b	2B      
	dc.b	68      
	dc.b	C7      
	dc.b	35      
	dc.b	93      
	dc.b	F9      
	dc.b	9B      
	dc.b	E7      
	dc.b	83      
	dc.b	4E      
	dc.b	DB 87   
	dc.b	ED      
	dc.b	B6      
	dc.b	2E CC   
	dc.b	18 78   
	dc.b	86      
	dc.b	11 73 0F
	dc.b	FB      
	dc.b	B7      
	dc.b	44      
	dc.b	EF      
	dc.b	0E 3F   
	dc.b	44      
	dc.b	54      
	dc.b	00      
	dc.b	30 69   
	dc.b	27      
	dc.b	A4      
	dc.b	5F      
	dc.b	27      
	dc.b	B7      
	dc.b	9A      
	dc.b	E8      
	dc.b	7A      
	dc.b	50      
	dc.b	0F      
	dc.b	4B      
	dc.b	4D      
	dc.b	DD 67   
	dc.b	C1      
	dc.b	67      
	dc.b	A5      
	dc.b	2B      
	dc.b	66      
	dc.b	7A      
	dc.b	D5      
	dc.b	F1      
	dc.b	39      
	dc.b	E3      
	dc.b	8E      
	dc.b	EE A2   
	dc.b	EC B1 54
	dc.b	EB      
	dc.b	2D      
	dc.b	A0      
	dc.b	52      
	dc.b	92      
	dc.b	79      
	dc.b	C9      
	dc.b	B6      
	dc.b	ED      
	dc.b	C8      
	dc.b	62      
	dc.b	8D      
	dc.b	E5      
	dc.b	5F      
	dc.b	5E      
	dc.b	05      
	dc.b	3A 3E B0
	dc.b	4B      
	dc.b	30 F7   
	dc.b	AE      
	dc.b	87      
	dc.b	3A 21 4E
	dc.b	E7      
	dc.b	C3 75 38
	dc.b	17      
	dc.b	AC      
	dc.b	82      
	dc.b	68      
	dc.b	49      
	dc.b	10 4C   
	dc.b	94      
	dc.b	03      
	dc.b	06 04   
	dc.b	2C      
	dc.b	10 24   
	dc.b	77      
	dc.b	2C      
	dc.b	7B      
	dc.b	E1      
	dc.b	AF      
	dc.b	9D      
	dc.b	62      
	dc.b	F0      
	dc.b	F7      
	dc.b	B0      
	dc.b	0E 42   
	dc.b	41      
	dc.b	9A      
	dc.b	26 2B   
	dc.b	18 3A   
	dc.b	2C      
	dc.b	F7      
	dc.b	F5      
	dc.b	61      
	dc.b	18 E8   
	dc.b	7D      
	dc.b	7E      
	dc.b	E3      
	dc.b	11 71 44
	dc.b	9E      
	dc.b	2F      
	dc.b	40      
	dc.b	04      
	dc.b	6A      
	dc.b	81      
	dc.b	F9      
	dc.b	51      
	dc.b	77      
	dc.b	A5      
	dc.b	47      
	dc.b	F4 7B 90
	dc.b	17      
	dc.b	57      
	dc.b	91      
	dc.b	B7      
	dc.b	41      
	dc.b	61      
	dc.b	62      
	dc.b	DC AC 86
	dc.b	65      
	dc.b	55      
	dc.b	3D      
	dc.b	88      
	dc.b	A2      
	dc.b	CA C7 66
	dc.b	26 1A   
	dc.b	DA EB 6F
	dc.b	2B      
	dc.b	29      
	dc.b	00      
	dc.b	EB      
	dc.b	97      
	dc.b	9D      
	dc.b	77      
	dc.b	AF      
	dc.b	EC 88 D7
	dc.b	4D      
	dc.b	9A      
	dc.b	FD      
	dc.b	C0      
	dc.b	4B      
	dc.b	74      
	dc.b	C4 EF 8E
	dc.b	64      
	dc.b	03      
	dc.b	75      
	dc.b	3C      
	dc.b	36 5E   
	dc.b	AF      
	dc.b	C3 92 5D
	dc.b	CD AC 5F
	dc.b	EF      
	dc.b	63      
	dc.b	A2      
	dc.b	62      
	dc.b	B1      
	dc.b	B0      
	dc.b	F9      
	dc.b	1B      
	dc.b	44      
	dc.b	B1      
	dc.b	38 43   
	dc.b	6D      
	dc.b	75      
	dc.b	AB      
	dc.b	22 A3 0Bhl
	dc.b	B0      
	dc.b	BF      
	dc.b	BD      
	dc.b	35      
	dc.b	D2 84 A1
	dc.b	13      
	dc.b	37      
	dc.b	62      
	dc.b	40      
	dc.b	7A      
	dc.b	D1      
	dc.b	F3      
	dc.b	D5      
	dc.b	55      
	dc.b	EA 0C 8A
	dc.b	9E      
	dc.b	2D      
	dc.b	DA 2F 7C
	dc.b	F5      
	dc.b	7D      
	dc.b	5F      
	dc.b	41      
	dc.b	E1      
	dc.b	6B      
	dc.b	DF      
	dc.b	57      
	dc.b	F4 EF F1
	dc.b	91      
	dc.b	41      
	dc.b	B1      
	dc.b	DC 44 0E
	dc.b	A5      
	dc.b	2B      
	dc.b	4C      
	dc.b	74      
	dc.b	3A E3 A2
	dc.b	67      
	dc.b	D5      
	dc.b	F1      
	dc.b	41      
	dc.b	C8      
	dc.b	90      
	dc.b	41      
	dc.b	87      
	dc.b	C7      
	dc.b	53      
	dc.b	B3      
	dc.b	9B      
	dc.b	61      
	dc.b	4D      
	dc.b	D6 41   
	dc.b	60      
	dc.b	48      
	dc.b	B4      
	dc.b	C4 C4 B3
	dc.b	9A      
	dc.b	26 2B   
	dc.b	1F      
	dc.b	C9      
	dc.b	C7      
	dc.b	40      
	dc.b	0C      
	dc.b	9C      
	dc.b	51      
	dc.b	26 3E   
	dc.b	A7      
	dc.b	76      
	dc.b	24      
	dc.b	52      
	dc.b	88      
	dc.b	BF      
	dc.b	D6 12   
	dc.b	61      
	dc.b	B9      
	dc.b	E9      
	dc.b	D5      
	dc.b	C7      
	dc.b	D6 0D   
	dc.b	13      
	dc.b	66      
	dc.b	5D      
	dc.b	7D      
	dc.b	5A      
	dc.b	31 6E AE
	dc.b	77      
	dc.b	1E 38   
	dc.b	27      
	dc.b	DF      
	dc.b	2B      
	dc.b	DF      
	dc.b	95      
	dc.b	D7      
	dc.b	C7      
	dc.b	AA      
	dc.b	E8      
	dc.b	7E      
	dc.b	5F      
	dc.b	7C      
	dc.b	8E      
	dc.b	7C      
	dc.b	8B      
	dc.b	E1      
	dc.b	CE 5F   
	dc.b	73      
	dc.b	3E E4   
	dc.b	76      
	dc.b	62      
	dc.b	67      
	dc.b	8C      
	dc.b	4C      
	dc.b	D6 2C   
	dc.b	45      
	dc.b	04      
	dc.b	03      
	dc.b	F7      
	dc.b	92      
	dc.b	89      
	dc.b	60      
	dc.b	FE E8   
	dc.b	E2 5D C5
	dc.b	26 1C   
	dc.b	91      
	dc.b	C7      
	dc.b	9A      
	dc.b	E8      
	dc.b	79      
	dc.b	E0      
	dc.b	EF      
	dc.b	DC 73 EC
	dc.b	86      
	dc.b	52      
	dc.b	A1      
	dc.b	14      
	dc.b	C7      
	dc.b	39      
	dc.b	0E C2   
	dc.b	8C      
	dc.b	AE      
	dc.b	E9      
	dc.b	9E      
	dc.b	E8      
	dc.b	76      
	dc.b	2B      
	dc.b	10 28   
	dc.b	A1      
	dc.b	4C      
	dc.b	73      
	dc.b	77      
	dc.b	91      
	dc.b	FE C2   
	dc.b	63      
	dc.b	B5      
	dc.b	A0      
	dc.b	23      
	dc.b	9B      
	dc.b	49      
	dc.b	9C      
	dc.b	59      
	dc.b	A3      
	dc.b	4E      
	dc.b	AE      
	dc.b	AE      
	dc.b	AD      
	dc.b	A8      
	dc.b	54      
	dc.b	0E 3D   
	dc.b	6C      
	dc.b	29      
	dc.b	3A 23 9B
	dc.b	5E      
	dc.b	82      
	dc.b	6E      
	dc.b	9C      
	dc.b	00      
	dc.b	9B      
	dc.b	D5      
	dc.b	78      
	dc.b	4B      
	dc.b	44      
	dc.b	83      
	dc.b	A2      
	dc.b	E6 4C   
	dc.b	44      
	dc.b	E4 C2 C5
	dc.b	D3 1B   
	dc.b	CD 09 AE
	dc.b	87      
	dc.b	EA 75 4B
	dc.b	5B      
	dc.b	46      
	dc.b	44      
	dc.b	CC BC 9B
	dc.b	A4      
	dc.b	F0      
	dc.b	47      
	dc.b	45      
	dc.b	4E      
	dc.b	39      
	dc.b	E4 13 CD
	dc.b	FD 96 52
	dc.b	DD E9   
	dc.b	C6 7D   
	dc.b	7C      
	dc.b	C7      
	dc.b	52      
	dc.b	C2 5D C5
	dc.b	F2 66 26
	dc.b	4F      
	dc.b	16 24   
	dc.b	BA      
	dc.b	C8      
	dc.b	66      
	dc.b	29      
	dc.b	D9      
	dc.b	0F      
	dc.b	EA 11 5E
	dc.b	E8      
	dc.b	B2      
	dc.b	A0      
	dc.b	17      
	dc.b	5E      
	dc.b	AB      
	dc.b	3B      
	dc.b	50      
	dc.b	5F      
	dc.b	10 5D   
	dc.b	C5      
	dc.b	B3      
	dc.b	8B      
	dc.b	15      
	dc.b	FD      
	dc.b	3B      
	dc.b	5D      
	dc.b	C3 9C 4A
	dc.b	DA E9 9E
	dc.b	A3      
	dc.b	50      
	dc.b	0A      
	dc.b	FA E9 DB
	dc.b	00      
	dc.b	1C      
	dc.b	96      
	dc.b	4A      
	dc.b	C3 75 38
	dc.b	26 0E   
	dc.b	98      
	dc.b	60      
	dc.b	26 16   
	dc.b	29      
	dc.b	2B      
	dc.b	F9      
	dc.b	97      
	dc.b	72      
	dc.b	5D      
	dc.b	CB E7   
	dc.b	66      
	dc.b	26 AD   
	dc.b	71      
	dc.b	4C      
	dc.b	7B      
	dc.b	26 04   
	dc.b	10 05   
	dc.b	04      
	dc.b	3D      
	dc.b	68      
	dc.b	37      
	dc.b	53      
	dc.b	8E      
	dc.b	58      
	dc.b	C2 5D C8
	dc.b	A9      
	dc.b	95      
	dc.b	64      
	dc.b	A2      
	dc.b	02      
	dc.b	B5      
	dc.b	39      
	dc.b	F2 56 75
	dc.b	EA 07 95
	dc.b	DF      
	dc.b	B8      
	dc.b	09      
	dc.b	E4 C9 EB
	dc.b	F5      
	dc.b	2E AE   
	dc.b	C4 30 37
	dc.b	B4      
	dc.b	C8      
	dc.b	A3      
	dc.b	C6 40   
	dc.b	34      
	dc.b	2A F5 DC5
	dc.b	3B      
	dc.b	5F      
	dc.b	0F      
	dc.b	17      
	dc.b	79      
	dc.b	AE      
	dc.b	87      
	dc.b	86      
	dc.b	11 2A 34
	dc.b	C9      
	dc.b	AF      
	dc.b	B1      
	dc.b	50      
	dc.b	5D      
	dc.b	D3 C6   
	dc.b	EC 01 14
	dc.b	EE 51   
	dc.b	49      
	dc.b	C8      
	dc.b	8A      
	dc.b	D6 13   
	dc.b	50      
	dc.b	5B      
	dc.b	5B      
	dc.b	21 02 4D
	dc.b	99      
	dc.b	AE      
	dc.b	AE      
	dc.b	AE      
	dc.b	AC      
	dc.b	24      
	dc.b	B4      
	dc.b	62      
	dc.b	94      
	dc.b	0E 3A   
	dc.b	DF      
	dc.b	71      
	dc.b	1B      
	dc.b	37      
	dc.b	3E 93   
	dc.b	58      
	dc.b	A3      
	dc.b	9A      
	dc.b	26 2B   
	dc.b	1B      
	dc.b	FA 9B 12
	dc.b	6D      
	dc.b	A5      
	dc.b	25      
	dc.b	5A      
	dc.b	CD 74 73
	dc.b	D6 81   
	dc.b	8D      
	dc.b	5C      
	dc.b	02      
	dc.b	DE 5F   
	dc.b	71      
	dc.b	EE BF   
	dc.b	75      
	dc.b	86      
	dc.b	5D      
	dc.b	79      
	dc.b	B5      
	dc.b	E3      
	dc.b	E8      
	dc.b	02      
	dc.b	81      
	dc.b	40      
	dc.b	8F      
	dc.b	EE 00   
	dc.b	09      
	dc.b	2F      
	dc.b	93      
	dc.b	15      
	dc.b	2D      
	dc.b	8F      
	dc.b	34      
	dc.b	C9      
	dc.b	DA F3 74
	dc.b	00      
	dc.b	28 8D   
	dc.b	74      
	dc.b	26 43   
	dc.b	8F      
	dc.b	D8      
	dc.b	D7      
	dc.b	51      
	dc.b	8B      
	dc.b	4B      
	dc.b	17      
	dc.b	8A      
	dc.b	24      
	dc.b	DA 13 89
	dc.b	E8      
	dc.b	63      
	dc.b	C8      
	dc.b	99      
	dc.b	B0      
	dc.b	0E C7   
	dc.b	5D      
	dc.b	BF      
	dc.b	D5      
	dc.b	23      
	dc.b	A1      
	dc.b	F7      
	dc.b	5D      
	dc.b	BE      
	dc.b	BD      
	dc.b	82      
	dc.b	4C      
	dc.b	4E      
	dc.b	88      
	dc.b	66      
	dc.b	0F      
	dc.b	87      
	dc.b	2A A3 5C3
	dc.b	4B      
	dc.b	D8      
	dc.b	38 89   
	dc.b	EA C3 70
	dc.b	24      
	dc.b	9B      
	dc.b	FB      
	dc.b	94      
	dc.b	DA 86 60
	dc.b	F5      
	dc.b	12      
	dc.b	FB      
	dc.b	BC      
	dc.b	9B      
	dc.b	E6 6B   
	dc.b	A0      
	dc.b	62      
	dc.b	6B      
	dc.b	D5      
	dc.b	A4      
	dc.b	85      
	dc.b	AF      
	dc.b	87      
	dc.b	39      
	dc.b	20 26   
	dc.b	E7      
	dc.b	5F      
	dc.b	CB 1A   
	dc.b	D5      
	dc.b	F8      
	dc.b	CA 04 C2
	dc.b	B7      
	dc.b	BA      
	dc.b	04      
	dc.b	A2      
	dc.b	83      
	dc.b	1D      
	dc.b	E2 77 0B
	dc.b	2A 00 0A0
	dc.b	FB      
	dc.b	1B      
	dc.b	71      
	dc.b	8B      
	dc.b	1C      
	dc.b	25      
	dc.b	DC 61 65
	dc.b	5E      
	dc.b	20 2E   
	dc.b	4C      
	dc.b	A5      
	dc.b	4B      
	dc.b	1A      
	dc.b	0E 90   
	dc.b	3B      
	dc.b	01 70 EA
	dc.b	0F      
	dc.b	C5      
	dc.b	02      
	dc.b	40      
	dc.b	26 8B   
	dc.b	3B      
	dc.b	61      
	dc.b	4C      
	dc.b	73      
	dc.b	B1      
	dc.b	29      
	dc.b	60      
	dc.b	FB      
	dc.b	12      
	dc.b	6F      
	dc.b	EA FD 9C
	dc.b	86      
	dc.b	60      
	dc.b	F9      
	dc.b	C5      
	dc.b	0F      
	dc.b	B4      
	dc.b	A2      
	dc.b	13      
	dc.b	48      
	dc.b	26 D7   
	dc.b	2A B2 3B2
	dc.b	0C      
	dc.b	3E BA   
	dc.b	11 39 C4
	dc.b	AD      
	dc.b	AE      
	dc.b	82      
	dc.b	86      
	dc.b	60      
	dc.b	F6 29   
	dc.b	4D      
	dc.b	58      
	dc.b	50      
	dc.b	F5      
	dc.b	4E      
	dc.b	A8      
	dc.b	47      
	dc.b	5E      
	dc.b	A5      
	dc.b	FB      
	dc.b	5F      
	dc.b	CA 39 A2
	dc.b	62      
	dc.b	B1      
	dc.b	AC      
	dc.b	73      
	dc.b	7E      
	dc.b	91      
	dc.b	D0      
	dc.b	71      
	dc.b	D1      
	dc.b	CE 30   
	dc.b	DB 32   
	dc.b	54      
	dc.b	E8      
	dc.b	D6 20   
	dc.b	31 C6 60
	dc.b	F1      
	dc.b	20 29   
	dc.b	B5      
	dc.b	E4 58 AC
	dc.b	37      
	dc.b	53      
	dc.b	8C      
	dc.b	60      
	dc.b	81      
	dc.b	78      
	dc.b	03      
	dc.b	7D      
	dc.b	EB      
	dc.b	7A      
	dc.b	EA E2 9B
	dc.b	5E      
	dc.b	2D      
	dc.b	EF      
	dc.b	CB 41   
	dc.b	15      
	dc.b	3A F4 8D
	dc.b	D9      
	dc.b	D9      
	dc.b	AE      
	dc.b	AE      
	dc.b	01 4E 1A
	dc.b	28 8D   
	dc.b	11 3D 9A
	dc.b	E8      
	dc.b	79      
	dc.b	72      
	dc.b	0F      
	dc.b	C8      
	dc.b	89      
	dc.b	60      
	dc.b	9A      
	dc.b	D5      
	dc.b	F0      
	dc.b	9D      
	dc.b	85      
	dc.b	1F      
	dc.b	4B      
	dc.b	D9      
	dc.b	78      
	dc.b	47      
	dc.b	EB      
	dc.b	C4 C7 EB
	dc.b	73      
	dc.b	31 36 16
	dc.b	EB      
	dc.b	B1      
	dc.b	26 02   
	dc.b	C0      
	dc.b	00      
	dc.b	1F      
	dc.b	B1      
	dc.b	0D      
	dc.b	5E      
	dc.b	A3      
	dc.b	82      
	dc.b	83      
	dc.b	80      
	dc.b	47      
	dc.b	3E 93   
	dc.b	94      
	dc.b	E8      
	dc.b	00      
	dc.b	70      
	dc.b	0A      
	dc.b	83      
	dc.b	E3      
	dc.b	6E      
	dc.b	E1      
	dc.b	C0      
	dc.b	CB CE   
	dc.b	AC      
	dc.b	0B      
	dc.b	0C      
	dc.b	20 87   
	dc.b	0B      
	dc.b	75      
	dc.b	EA 37 C5
	dc.b	41      
	dc.b	CD 62 00
	dc.b	E9      
	dc.b	44      
	dc.b	59      
	dc.b	27      
	dc.b	99      
	dc.b	0F      
	dc.b	BB      
	dc.b	95      
	dc.b	D7      
	dc.b	97      
	dc.b	AD      
	dc.b	5F      
	dc.b	6A      
	dc.b	76      
	dc.b	81      
	dc.b	65      
	dc.b	DC 69 3C
	dc.b	4D      
	dc.b	AE      
	dc.b	87      
	dc.b	CB 61   
	dc.b	A4      
	dc.b	5A      
	dc.b	E2 25 4C
	dc.b	75      
	dc.b	11 90 EA
	dc.b	32 61 83a
	dc.b	AD      
	dc.b	CD 74 20
	dc.b	FB      
	dc.b	65      
	dc.b	66      
	dc.b	39      
	dc.b	B6      
	dc.b	B1      
	dc.b	23      
	dc.b	74      
	dc.b	00      
	dc.b	F0      
	dc.b	C0      
	dc.b	AC      
	dc.b	4B      
	dc.b	EE 5C   
	dc.b	B3      
	dc.b	1F      
	dc.b	F6 15   
	dc.b	60      
	dc.b	1B      
	dc.b	F0      
	dc.b	BC      
	dc.b	A0      
	dc.b	E5      
	dc.b	96      
	dc.b	29      
	dc.b	6F      
	dc.b	D7      
	dc.b	55      
	dc.b	EB      
	dc.b	92      
	dc.b	4B      
	dc.b	FC D6 25
	dc.b	73      
	dc.b	E9      
	dc.b	47      
	dc.b	0D      
	dc.b	5D      
	dc.b	7F      
	dc.b	60      
	dc.b	F6 0F   
	dc.b	5C      
	dc.b	B1      
	dc.b	CC 46 FA
	dc.b	74      
	dc.b	C2 E2 F6
	dc.b	11 BD E0
	dc.b	96      
	dc.b	26 A8   
	dc.b	00      
	dc.b	A9      
	dc.b	3C      
	dc.b	41      
	dc.b	B6      
	dc.b	20 65   
	dc.b	0E 82   
	dc.b	45      
	dc.b	F8      
	dc.b	AE      
	dc.b	00      
	dc.b	6B      
	dc.b	A7      
	dc.b	69      
	dc.b	06 AD   
	dc.b	A4      
	dc.b	2D      
	dc.b	81      
	dc.b	79      
	dc.b	A8      
	dc.b	7A      
	dc.b	17      
	dc.b	AD      
	dc.b	B0      
	dc.b	47      
	dc.b	87      
	dc.b	D4 D7 45
	dc.b	61      
	dc.b	65      
	dc.b	D0      
	dc.b	DC 86 97
	dc.b	77      
	dc.b	30 88   
	dc.b	D4 EA CA
	dc.b	66      
	dc.b	26 4A   
	dc.b	DA EF 62
	dc.b	5E      
	dc.b	5B      
	dc.b	00      
	dc.b	EE 99   
	dc.b	90      
	dc.b	7A      
	dc.b	A2      
	dc.b	EE C8   
	dc.b	D7      
	dc.b	40      
	dc.b	9A      
	dc.b	2F      
	dc.b	C2 4D 74
	dc.b	F8      
	dc.b	EF      
	dc.b	B1      
	dc.b	86      
	dc.b	23      
	dc.b	77      
	dc.b	5C      
	dc.b	68      
	dc.b	80      
	dc.b	D2 C5 C2
	dc.b	5D      
	dc.b	CF      
	dc.b	AF      
	dc.b	71      
	dc.b	2F      
	dc.b	95      
	dc.b	D2 62 B1
	dc.b	E3      
	dc.b	FB      
	dc.b	1E 47   
	dc.b	E1      
	dc.b	38 73   
	dc.b	90      
	dc.b	75      
	dc.b	EE 25   
	dc.b	A6      
	dc.b	0E E0   
	dc.b	E2 BF 57
	dc.b	16 86   
	dc.b	D1      
	dc.b	13      
	dc.b	5A      
	dc.b	62      
	dc.b	43      
	dc.b	7D      
	dc.b	14      
	dc.b	13      
	dc.b	F8      
	dc.b	75      
	dc.b	EA 3F 8E
	dc.b	DE 5F   
	dc.b	DD 22 BEix
	dc.b	AD      
	dc.b	5F      
	dc.b	73      
	dc.b	14      
	dc.b	8E      
	dc.b	11 79 38
	dc.b	EF      
	dc.b	11 B1 74
	dc.b	B3      
	dc.b	1C      
	dc.b	67      
	dc.b	0E C7   
	dc.b	2F      
	dc.b	4F      
	dc.b	77      
	dc.b	6A      
	dc.b	06 A2   
	dc.b	AA      
	dc.b	D5      
	dc.b	F4 64 FB
	dc.b	C4 83 89
	dc.b	FA 56 E6
	dc.b	CB 61   
	dc.b	8F      
	dc.b	06 85   
	dc.b	90      
	dc.b	4A      
	dc.b	B4      
	dc.b	C7      
	dc.b	C7      
	dc.b	E7      
	dc.b	9A      
	dc.b	26 2B   
	dc.b	12      
	dc.b	F9      
	dc.b	FA 70 0F
	dc.b	9F      
	dc.b	81      
	dc.b	66      
	dc.b	5E      
	dc.b	AA      
	dc.b	A6      
	dc.b	24      
	dc.b	84      
	dc.b	B8      
	dc.b	BF      
	dc.b	D6 46   
	dc.b	64      
	dc.b	BC      
	dc.b	2C      
	dc.b	D8      
	dc.b	F7      
	dc.b	09      
	dc.b	00      
	dc.b	46      
	dc.b	86      
	dc.b	5D      
	dc.b	70      
	dc.b	9E      
	dc.b	35      
	dc.b	60      
	dc.b	EE A7   
	dc.b	41      
	dc.b	6B      
	dc.b	5A      
	dc.b	0F      
	dc.b	5B      
	dc.b	03      
	dc.b	C8      
	dc.b	07      
	dc.b	F7      
	dc.b	DD      
	dc.b	E8      
	dc.b	72      
	dc.b	9F      
	dc.b	AF      
	dc.b	82      
	dc.b	AF      
	dc.b	8F      
	dc.b	14      
	dc.b	F0      
	dc.b	8F      
	dc.b	A3      
	dc.b	61      
	dc.b	E6 A6   
	dc.b	62      
	dc.b	69      
	dc.b	8C      
	dc.b	4C      
	dc.b	06 20   
	dc.b	48      
	dc.b	04      
	dc.b	23      
	dc.b	29      
	dc.b	95      
	dc.b	8B      
	dc.b	90      
	dc.b	F0      
	dc.b	E8      
	dc.b	15      
	dc.b	5D      
	dc.b	C8      
	dc.b	26 4F   
	dc.b	95      
	dc.b	FA 9A E8
	dc.b	7C      
	dc.b	00      
	dc.b	1F      
	dc.b	DF      
	dc.b	73      
	dc.b	1F      
	dc.b	86      
	dc.b	94      
	dc.b	A1      
	dc.b	44      
	dc.b	C7      
	dc.b	69      
	dc.b	01 C2 C0
	dc.b	D2 19 92
	dc.b	18 7A   
	dc.b	2B      
	dc.b	13      
	dc.b	5C      
	dc.b	A4      
	dc.b	8C      
	dc.b	A6      
	dc.b	7A      
	dc.b	B1      
	dc.b	21 C2 96
	dc.b	B5      
	dc.b	E3      
	dc.b	56      
	dc.b	CE 7C   
	dc.b	9F      
	dc.b	5C      
	dc.b	E3      
	dc.b	8E      
	dc.b	EE AE   
	dc.b	D1      
	dc.b	AB      
	dc.b	84      
	dc.b	0E 6D   
	dc.b	6F      
	dc.b	59      
	dc.b	6C      
	dc.b	26 9B   
	dc.b	5E      
	dc.b	B5      
	dc.b	60      
	dc.b	DF      
	dc.b	40      
	dc.b	CE 05   
	dc.b	B8      
	dc.b	7B      
	dc.b	47      
	dc.b	B6      
	dc.b	A2      
	dc.b	1A      
	dc.b	4C      
	dc.b	47      
	dc.b	E7      
	dc.b	C2 F5 D6
	dc.b	4E      
	dc.b	F1      
	dc.b	4C      
	dc.b	AE      
	dc.b	87      
	dc.b	1A      
	dc.b	A5      
	dc.b	4B      
	dc.b	7D      
	dc.b	49      
	dc.b	47      
	dc.b	CF      
	dc.b	EC 9B D6
	dc.b	F0      
	dc.b	7A      
	dc.b	48      
	dc.b	8E      
	dc.b	79      
	dc.b	08      
	dc.b	13      
	dc.b	F1      
	dc.b	3D      
	dc.b	D9      
	dc.b	72      
	dc.b	10 19   
	dc.b	F6 B0   
	dc.b	70      
	dc.b	F7      
	dc.b	92      
	dc.b	F2 5D C8
	dc.b	F2 96 26
	dc.b	6F      
	dc.b	49      
	dc.b	24      
	dc.b	FD      
	dc.b	C8      
	dc.b	69      
	dc.b	2C      
	dc.b	0D      
	dc.b	02      
	dc.b	ED      
	dc.b	14      
	dc.b	50      
	dc.b	E8      
	dc.b	E2 D3 4B
	dc.b	5E      
	dc.b	AE      
	dc.b	6E      
	dc.b	93      
	dc.b	5F      
	dc.b	14      
	dc.b	50      
	dc.b	F5      
	dc.b	E6 BF   
	dc.b	18 FD   
	dc.b	7E      
	dc.b	80      
	dc.b	C3 CC 4A
	dc.b	DA EC C1
	dc.b	E3      
	dc.b	80      
	dc.b	0D      
	dc.b	2A 1C DBC
	dc.b	03      
	dc.b	10 99   
	dc.b	4D      
	dc.b	C3 75 38
	dc.b	49      
	dc.b	3E 9B   
	dc.b	94      
	dc.b	26 36   
	dc.b	29      
	dc.b	5B      
	dc.b	29      
	dc.b	CA 75 5D
	dc.b	CF      
	dc.b	1A      
	dc.b	66      
	dc.b	26 E1   
	dc.b	74      
	dc.b	4C      
	dc.b	7E      
	dc.b	26 04   
	dc.b	43      
	dc.b	08      
	dc.b	04      
	dc.b	6D      
	dc.b	6B      
	dc.b	67      
	dc.b	53      
	dc.b	80      
	dc.b	9B      
	dc.b	C2 5D CC
	dc.b	AC      
	dc.b	98      
	dc.b	94      
	dc.b	A4      
	dc.b	42      
	dc.b	E5      
	dc.b	69      
	dc.b	22 5A 75hl
	dc.b	EA 3A C8
	dc.b	D3 BC   
	dc.b	4C      
	dc.b	18 C9   
	dc.b	1B      
	dc.b	F8      
	dc.b	51      
	dc.b	A2      
	dc.b	C4 73 77
	dc.b	E4 CC D6
	dc.b	06 73   
	dc.b	64      
	dc.b	5A      
	dc.b	28 DC   
	dc.b	6B      
	dc.b	93      
	dc.b	02      
	dc.b	4A      
	dc.b	79      
	dc.b	AE      
	dc.b	87      
	dc.b	B6      
	dc.b	11 5D 64
	dc.b	C9      
	dc.b	DF      
	dc.b	B1      
	dc.b	94      
	dc.b	51      
	dc.b	03      
	dc.b	F9      
	dc.b	EF      
	dc.b	34      
	dc.b	44      
	dc.b	1E 81   
	dc.b	7C      
	dc.b	C8      
	dc.b	8E      
	dc.b	09      
	dc.b	16 54   
	dc.b	5F      
	dc.b	8B      
	dc.b	54      
	dc.b	32 80 D9a
	dc.b	EE AE   
	dc.b	EE EF   
	dc.b	54      
	dc.b	B4      
	dc.b	92      
	dc.b	97      
	dc.b	0E 6A   
	dc.b	02      
	dc.b	A4      
	dc.b	4E      
	dc.b	3A 3E 96
	dc.b	9C      
	dc.b	A3      
	dc.b	9A      
	dc.b	26 2B   
	dc.b	1E FE   
	dc.b	CB 12   
	dc.b	60      
	dc.b	A9      
	dc.b	25      
	dc.b	8D      
	dc.b	ED 74   
	dc.b	B3      
	dc.b	D6 C5   
	dc.b	81      
	dc.b	8C      
	dc.b	25      
	dc.b	02      
	dc.b	9F      
	dc.b	A1      
	dc.b	11 BF B5
	dc.b	C6 5D   
	dc.b	7D      
	dc.b	B5      
	dc.b	E7      
	dc.b	18 32   
	dc.b	B4      
	dc.b	43      
	dc.b	B2      
	dc.b	E1      
	dc.b	40      
	dc.b	0C      
	dc.b	62      
	dc.b	97      
	dc.b	49      
	dc.b	20 B3   
	dc.b	64      
	dc.b	C9      
	dc.b	1A      
	dc.b	27      
	dc.b	74      
	dc.b	00      
	dc.b	68      
	dc.b	8D      
	dc.b	74      
	dc.b	5A      
	dc.b	46      
	dc.b	C2 DB 17
	dc.b	84      
	dc.b	BF      
	dc.b	4F      
	dc.b	1B      
	dc.b	BD      
	dc.b	27      
	dc.b	1D      
	dc.b	53      
	dc.b	B9      
	dc.b	18 96   
	dc.b	FB      
	dc.b	99      
	dc.b	B0      
	dc.b	0E FA   
	dc.b	9D      
	dc.b	B2      
	dc.b	D9      
	dc.b	56      
	dc.b	A4      
	dc.b	1B      
	dc.b	9D      
	dc.b	B1      
	dc.b	B0      
	dc.b	B6      
	dc.b	4F      
	dc.b	82      
	dc.b	8B      
	dc.b	66      
	dc.b	0F      
	dc.b	BA      
	dc.b	2A E3 8F3
	dc.b	4E      
	dc.b	08      
	dc.b	68      
	dc.b	B9      
	dc.b	EA C6 73
	dc.b	27      
	dc.b	DB 3E   
	dc.b	C7      
	dc.b	DA B6 60
	dc.b	F8      
	dc.b	12      
	dc.b	2E EC   
	dc.b	9B      
	dc.b	18 9E   
	dc.b	D0      
	dc.b	A2      
	dc.b	6E      
	dc.b	18 A7   
	dc.b	C9      
	dc.b	DF      
	dc.b	B7      
	dc.b	39      
	dc.b	54      
	dc.b	26 2A   
	dc.b	5F      
	dc.b	CE 1D   
	dc.b	D5      
	dc.b	FB      
	dc.b	FD      
	dc.b	07      
	dc.b	C2 EB ED
	dc.b	07      
	dc.b	A6      
	dc.b	86      
	dc.b	50      
	dc.b	14      
	dc.b	9A      
	dc.b	0D      
	dc.b	5E      
	dc.b	00      
	dc.b	0D      
	dc.b	FB      
	dc.b	1E A1   
	dc.b	8E      
	dc.b	1F      
	dc.b	25      
	dc.b	DC 91 68
	dc.b	8E      
	dc.b	40      
	dc.b	50      
	dc.b	4C      
	dc.b	C5      
	dc.b	4B      
	dc.b	5D      
	dc.b	0E 93   
	dc.b	6B      
	dc.b	04      
	dc.b	A0      
	dc.b	ED      
	dc.b	02      
	dc.b	C8      
	dc.b	32 44 26a
	dc.b	BE      
	dc.b	6F      
	dc.b	94      
	dc.b	4C      
	dc.b	76      
	dc.b	E4 5C 60
	dc.b	FE 15   
	dc.b	62      
	dc.b	EA 3D D0
	dc.b	B6      
	dc.b	60      
	dc.b	FD      
	dc.b	F5      
	dc.b	3F      
	dc.b	B7      
	dc.b	A2      
	dc.b	46      
	dc.b	7A      
	dc.b	26 0A   
	dc.b	2A E5 6B5
	dc.b	0F      
	dc.b	51      
	dc.b	EA 11 3C
	dc.b	C4 AD AE
	dc.b	B5      
	dc.b	86      
	dc.b	60      
	dc.b	F9      
	dc.b	29      
	dc.b	7D      
	dc.b	88      
	dc.b	80      
	dc.b	28 8E   
	dc.b	AC      
	dc.b	7B      
	dc.b	5E      



init_hw_scroll_and_charset_260C:
260C: 3E 06       ld   a,$06
260E: 32 00 D3    ld   (video_priority_D300),a
2611: AF          xor  a
2612: 32 00 D6    ld   (video_mode_d600),a
2615: 32 AB 80    ld   ($80AB),a
2618: CD 9E 26    call init_video_269E
; write 0 in scroll registers
261B: 32 01 D5    ld   ($D501),a
261E: 32 03 D5    ld   ($D503),a
2621: 32 05 D5    ld   ($D505),a
2624: 3E 10       ld   a,$10
2626: 32 06 D5    ld   (colorbank_D506),a
2629: 3E 32       ld   a,$32
262B: 32 07 D5    ld   (colorbank_D507),a
262E: 3A D8 81    ld   a,($81D8)
2631: B7          or   a
2632: 20 10       jr   nz,$2644
2634: 3E 0D       ld   a,$0D
2636: 32 00 D5    ld   (scroll_d500),a
2639: 3E 16       ld   a,$16
263B: 32 02 D5    ld   ($D502),a
263E: 32 04 D5    ld   ($D504),a
2641: C3 51 26    jp   $2651
2644: 3E FD       ld   a,$FD
2646: 32 00 D5    ld   (scroll_d500),a
2649: 3E F5       ld   a,$F5
264B: 32 02 D5    ld   ($D502),a
264E: 32 04 D5    ld   ($D504),a
2651: 3A D9 81    ld   a,(menu_or_game_tiles_81D9)
2654: B7          or   a
2655: CA 5C 26    jp   z,$265C
2658: 3D          dec  a
2659: CA 76 26    jp   z,$2676
; copy gfx rom contents into character data
265C: 21 00 00    ld   hl,$0000		; game tiles
265F: 22 09 D5    ld   (gfx_pointer_d509),hl
2662: 11 00 90    ld   de,character_data_9000
2665: 01 30 00    ld   bc,$0030		; 256*48 bytes
2668: 3A 04 D4    ld   a,(gfx_rom_D404)
266B: 12          ld   (de),a
266C: 13          inc  de
266D: 10 F9       djnz $2668
266F: 0D          dec  c
2670: C2 68 26    jp   nz,$2668
2673: C3 8D 26    jp   $268D

2676: 21 00 30    ld   hl,$3000		; menu tiles
2679: 22 09 D5    ld   (gfx_pointer_d509),hl
267C: 11 00 90    ld   de,character_data_9000
267F: 01 30 00    ld   bc,$0030		; 256*48 bytes
2682: 3A 04 D4    ld   a,(gfx_rom_D404)
2685: 12          ld   (de),a
2686: 13          inc  de
2687: 10 F9       djnz $2682
2689: 0D          dec  c
268A: C2 82 26    jp   nz,$2682
268D: 3E 07       ld   a,GS_NEXT_LIFE_07
268F: 32 AC 80    ld   (game_state_80AC),a
2692: 3E 01       ld   a,$01
2694: 32 A9 80    ld   (timer_8bit_reload_value_80A9),a
2697: CD C2 26    call reload_8bit_tiimer_26C2
269A: CD CF 73    call game_tick_73cf
269D: C9          ret

init_video_269E:
269E: 21 00 C4    ld   hl,videoram_layer_1_C400
26A1: 01 0C 00    ld   bc,$000C
26A4: 36 00       ld   (hl),$00
26A6: 23          inc  hl
26A7: 10 FB       djnz $26A4
26A9: 0D          dec  c
26AA: C2 A4 26    jp   nz,$26A4
26AD: 21 00 D1    ld   hl,sprite_ram_d100
26B0: 06 80       ld   b,$80
26B2: 36 00       ld   (hl),$00
26B4: 23          inc  hl
26B5: 10 FB       djnz $26B2
; reset all column scroll registers
26B7: 21 00 D0    ld   hl,$D000
26BA: 06 60       ld   b,$60
26BC: 36 00       ld   (hl),$00
26BE: 23          inc  hl
26BF: 10 FB       djnz $26BC
26C1: C9          ret

reload_8bit_tiimer_26C2:
reload_8bit_timer_26C2:
26C2: 3A A9 80    ld   a,(timer_8bit_reload_value_80A9)
26C5: 3D          dec  a
26C6: 32 AA 80    ld   (timer_8bit_80AA),a
26C9: C9          ret

set_level_palette_26ca:
26CA: 3A D9 81    ld   a,(menu_or_game_tiles_81D9)
26CD: B7          or   a
26CE: 28 03       jr   z,$26D3
26D0: 3D          dec  a
26D1: 28 28       jr   z,$26FB
26D3: 21 E3 77    ld   hl,palette_data_77E3
26D6: 3A 3B 82    ld   a,(game_in_play_flag_823B)
26D9: B7          or   a
26DA: 20 12       jr   nz,$26EE
26DC: 3A 50 82    ld   a,(copy_of_dip_switches_3_8250)
26DF: 47          ld   b,a
26E0: 3A 37 82    ld   a,(skill_level_8237)
26E3: 90          sub  b
26E4: E6 03       and  $03		; 4 palettes
26E6: 0F          rrca			
26E7: 0F          rrca			; multiply by 64
26E8: EB          ex   de,hl
26E9: 26 00       ld   h,$00
26EB: 6F          ld   l,a
26EC: 29          add  hl,hl	; times 2, 128 bytes for each of 4 entries
26ED: 19          add  hl,de
26EE: 11 00 D2    ld   de,palette_D200
26F1: 01 80 00    ld   bc,$0080
26F4: ED B0       ldir
26F6: AF          xor  a
26F7: 32 AB 80    ld   ($80AB),a
26FA: C9          ret

26FB: 21 E3 79    ld   hl,table_79E3
26FE: 18 EE       jr   $26EE

init_building_2700:
2700: CD 0A 27    call $270A
2703: CD 3F 27    call $273F
2706: CD B3 28    call $28B3
2709: C9          ret

270A: 21 DA 81    ld   hl,$81DA
270D: 06 17       ld   b,$17
270F: 36 03       ld   (hl),$03
2711: 23          inc  hl
2712: 10 FB       djnz $270F
2714: 3E 02       ld   a,$02
2716: 32 E6 81    ld   ($81E6),a
2719: 21 DD 81    ld   hl,$81DD
271C: 06 05       ld   b,$05
271E: 36 00       ld   (hl),$00
2720: 23          inc  hl
2721: 10 FB       djnz $271E
2723: 11 F1 81    ld   de,$81F1
2726: 21 0E 28    ld   hl,table_280E
2729: 01 1F 00    ld   bc,$001F
272C: ED B0       ldir
; reset all red doors
272E: 21 10 82    ld   hl,red_door_position_array_8210
2731: 06 1F       ld   b,$1F
2733: 36 08       ld   (hl),$08
2735: 23          inc  hl
2736: 10 FB       djnz $2733
2738: CD 53 27    call position_red_doors_on_lower_floors_2753
273B: CD 8B 27    call position_red_doors_on_higher_floors_278b
273E: C9          ret

273F: CD F5 1D    call pseudo_random_1DF5
2742: 0E A0       ld   c,$A0
2744: 06 06       ld   b,$06
2746: B9          cp   c
2747: DA 4B 27    jp   c,$274B
274A: 91          sub  c
274B: CB 09       rrc  c
274D: 10 F7       djnz $2746
274F: 32 2D 80    ld   ($802D),a
2752: C9          ret

position_red_doors_on_lower_floors_2753:
2753: 21 2D 28    ld   hl,$282D
2756: 06 06       ld   b,$06
2758: 0E 01       ld   c,$01
275A: CD D2 27    call position_red_doors_27D2
275D: 3A 37 82    ld   a,(skill_level_8237)
2760: FE 02       cp   $02
2762: D8          ret  c
2763: FE 04       cp   $04
2765: 38 10       jr   c,$2777
2767: 21 10 82    ld   hl,red_door_position_array_8210
276A: CD 84 27    call $2784
276D: 47          ld   b,a
276E: CD 84 27    call $2784
2771: 2B          dec  hl
2772: 3E 07       ld   a,$07
2774: 90          sub  b
2775: 77          ld   (hl),a
2776: C9          ret
2777: 21 10 82    ld   hl,red_door_position_array_8210
277A: CD 84 27    call $2784
277D: 47          ld   b,a
277E: CD 84 27    call $2784
2781: 2B          dec  hl
2782: 77          ld   (hl),a
2783: C9          ret
2784: 7E          ld   a,(hl)
2785: 23          inc  hl
2786: FE 08       cp   $08
2788: 30 FA       jr   nc,$2784
278A: C9          ret

position_red_doors_on_higher_floors_278b:
278B: 21 36 28    ld   hl,$2836
278E: 06 08       ld   b,$08
2790: 0E 08       ld   c,$08
2792: CD D2 27    call position_red_doors_27D2
2795: 21 3F 28    ld   hl,$283F
2798: 06 0B       ld   b,$0B
279A: 0E 09       ld   c,$09
279C: CD D2 27    call position_red_doors_27D2
279F: 21 48 28    ld   hl,$2848
27A2: 06 0E       ld   b,$0E
27A4: 0E 0C       ld   c,$0C
27A6: CD D2 27    call position_red_doors_27D2
27A9: 21 51 28    ld   hl,$2851
27AC: 06 11       ld   b,$11
27AE: 0E 0F       ld   c,$0F
27B0: CD D2 27    call position_red_doors_27D2
27B3: 21 5A 28    ld   hl,$285A
27B6: 06 14       ld   b,$14
27B8: 0E 12       ld   c,$12
27BA: CD D2 27    call position_red_doors_27D2
27BD: 21 63 28    ld   hl,$2863
27C0: 06 19       ld   b,$19
27C2: 0E 15       ld   c,$15
27C4: CD D2 27    call position_red_doors_27D2
27C7: 21 6C 28    ld   hl,$286C
27CA: 06 1E       ld   b,$1E
27CC: 0E 1A       ld   c,$1A
27CE: CD D2 27    call position_red_doors_27D2
27D1: C9          ret

position_red_doors_27D2:
27D2: 3A 37 82    ld   a,(skill_level_8237)
27D5: 5F          ld   e,a
27D6: FE 09       cp   $09
27D8: 38 02       jr   c,$27DC
27DA: 1E 08       ld   e,$08	; max skill level 8
27DC: 16 00       ld   d,$00
27DE: 19          add  hl,de
27DF: 56          ld   d,(hl)
27E0: 7A          ld   a,d
27E1: B7          or   a
27E2: C8          ret  z
27E3: 78          ld   a,b
27E4: 91          sub  c
27E5: 47          ld   b,a
27E6: 04          inc  b
; loop
27E7: D5          push de
27E8: CD 3E 1E    call get_random_value_1e3e
27EB: 81          add  a,c
27EC: 5F          ld   e,a
27ED: 16 00       ld   d,$00
27EF: 21 10 82    ld   hl,red_door_position_array_8210
27F2: 19          add  hl,de
27F3: 7E          ld   a,(hl)
27F4: FE 08       cp   $08
27F6: 38 F0       jr   c,$27E8
27F8: E5          push hl
27F9: 21 75 28    ld   hl,$2875
27FC: 19          add  hl,de
27FD: 19          add  hl,de
27FE: CD F5 1D    call pseudo_random_1DF5
2801: E6 01       and  $01
2803: 20 01       jr   nz,$2806
2805: 23          inc  hl
2806: D1          pop  de
2807: 7E          ld   a,(hl)
2808: 12          ld   (de),a
2809: D1          pop  de
280A: 15          dec  d
280B: 20 DA       jr   nz,$27E7
280D: C9          ret

table_280E:
	dc.B	00          
	dc.B	81          
	dc.B	81          
	dc.B	81          
	dc.B	81          
	dc.B	81          
	dc.B	81          
	dc.B	00          
	dc.B	7E          
	dc.B	7E          
	dc.B	66          
	dc.B	66          
	dc.B	E6 7E       
	dc.B	7F          
	dc.B	67          
	dc.B	E6 66       
	dc.B	7E          
	dc.B	66          
	dc.B	66          
	dc.B	66          
	dc.B	66          
	dc.B	66          
	dc.B	66          
	dc.B	66          
	dc.B	66          
	dc.B	66          
	dc.B	66          
	dc.B	66          
	dc.B	66          
	dc.B	00          
	dc.B	01 02 02    
	dc.B	02          
	dc.B	02          
	dc.B	03          
	dc.B	04          
	dc.B	05          
	dc.B	00          
	dc.B	00          
	dc.B	00          
	dc.B	01 01 01    
	dc.B	01 01 01    
	dc.B	02          
	dc.B	02          
	dc.B	02          
	dc.B	01 01 02    
	dc.B	01 01 01    
	dc.B	01 01 01    
	dc.B	01 01 01    
	dc.B	01 01 01    
	dc.B	01 01 01    
	dc.B	01 01 01    
	dc.B	01 01 01    
	dc.B	01 01 01    
	dc.B	01 01 01    
	dc.B	01 01 01    
	dc.B	00          
	dc.B	00          
	dc.B	00          
	dc.B	01 01 01    
	dc.B	01 01 00    
	dc.B	00          
	dc.B	00          
	dc.B	00          
	dc.B	00          
	dc.B	01 01 01    
	dc.B	00          
	dc.B	00          
	dc.B	00          
	dc.B	00          
	dc.B	00          
	dc.B	07          
	dc.B	00          
	dc.B	07          
	dc.B	00          
	dc.B	07          
	dc.B	00          
	dc.B	07          
	dc.B	00          
	dc.B	07          
	dc.B	00          
	dc.B	07          
	dc.B	00          
	dc.B	00          
	dc.B	02          
	dc.B	05          
	dc.B	03          
	dc.B	04          
	dc.B	02          
	dc.B	05          
	dc.B	01 06 00    
	dc.B	05          
	dc.B	02          
	dc.B	04          
	dc.B	01 05 02    
	dc.B	06 01       
	dc.B	05          
	dc.B	02          
	dc.B	05          
	dc.B	03          
	dc.B	04          
	dc.B	02          
	dc.B	05          
	dc.B	01 06 01    
	dc.B	05          
	dc.B	02          
	dc.B	06 01       
	dc.B	05          
	dc.B	02          
	dc.B	06 01       
	dc.B	05          
	dc.B	02          
	dc.B	06 01       
	dc.B	05          
	dc.B	02          
	dc.B	06 01       
	dc.B	05          
	dc.B	02          
	dc.B	06

28B3: CD C0 28    call update_scroll_value_from_viewed_floor_28c0                                          
28B6: CD DE 28    call $28DE                                          
28B9: CD 21 29    call $2921
28BC: CD BD 16    call $16BD
28BF: C9          ret

update_scroll_value_from_viewed_floor_28c0:
28C0: 21 01 80    ld   hl,$8001
28C3: 36 00       ld   (hl),$00
28C5: 23          inc  hl
28C6: 36 00       ld   (hl),$00
28C8: 23          inc  hl
28C9: 3A 2C 80    ld   a,($802C)
28CC: 47          ld   b,a
28CD: 3D          dec  a
28CE: 3D          dec  a
28CF: 77          ld   (hl),a
28D0: 23          inc  hl
28D1: 23          inc  hl
28D2: 3E 1F       ld   a,$1F
28D4: 90          sub  b
28D5: 47          ld   b,a
28D6: 80          add  a,b
28D7: 80          add  a,b
28D8: 87          add  a,a
28D9: 87          add  a,a
28DA: 87          add  a,a
28DB: 87          add  a,a
28DC: 77          ld   (hl),a
28DD: C9          ret

28DE: 2A 02 80    ld   hl,($8002)
28E1: 3E FF       ld   a,$FF
28E3: 32 04 80    ld   (scroll_speed_8004),a
28E6: E5          push hl
28E7: 06 1F       ld   b,$1F
28E9: C5          push bc
28EA: 2A 02 80    ld   hl,($8002)
28ED: 44          ld   b,h
28EE: 4D          ld   c,l
28EF: CD 47 02    call $0247
28F2: 2A 06 80    ld   hl,(scroll_tile_pointer_8006)
28F5: EB          ex   de,hl
28F6: 21 08 80    ld   hl,scroll_row_8008
28F9: 01 20 00    ld   bc,$0020
28FC: ED B0       ldir
28FE: C1          pop  bc
28FF: 2A 02 80    ld   hl,($8002)
2902: 2C          inc  l
2903: 7D          ld   a,l
2904: D6 06       sub  $06
2906: C2 0B 29    jp   nz,$290B
2909: 6F          ld   l,a
290A: 24          inc  h
290B: 22 02 80    ld   ($8002),hl
290E: 10 D9       djnz $28E9
2910: E1          pop  hl
2911: 22 02 80    ld   ($8002),hl
2914: 21 20 D0    ld   hl,main_scroll_columns_D020
2917: 06 20       ld   b,$20
2919: 3A 05 80    ld   a,(main_scroll_value_8005)
291C: 77          ld   (hl),a
291D: 23          inc  hl
291E: 10 FC       djnz $291C
2920: C9          ret
2921: 01 03 80    ld   bc,$8003
2924: 26 00       ld   h,$00
2926: 0A          ld   a,(bc)
2927: 6F          ld   l,a
2928: 2C          inc  l
2929: 54          ld   d,h
292A: 5D          ld   e,l
292B: 19          add  hl,de
292C: 19          add  hl,de
292D: 29          add  hl,hl
292E: 0B          dec  bc
292F: 0A          ld   a,(bc)
2930: 5F          ld   e,a
2931: 19          add  hl,de
2932: 29          add  hl,hl
2933: 29          add  hl,hl
2934: 29          add  hl,hl
2935: 22 2A 80    ld   ($802A),hl
2938: 11 DF 00    ld   de,$00DF
293B: 19          add  hl,de
293C: 22 28 80    ld   ($8028),hl
293F: C9          ret

goto_next_screen_2940:
2940: CD 5F 29    call display_insert_coin_screen_295f
2943: CD CF 73    call game_tick_73cf
2946: 3A A2 80    ld   a,(nb_credits_80A2)
2949: B7          or   a
294A: C0          ret  nz
294B: 21 A3 80    ld   hl,$80A3
294E: 7E          ld   a,(hl)
294F: 23          inc  hl
2950: B6          or   (hl)
2951: 20 F0       jr   nz,$2943
2953: 2A 2F 82    ld   hl,($822F)
2956: 2B          dec  hl
2957: 22 2F 82    ld   ($822F),hl
295A: 7C          ld   a,h
295B: B5          or   l
295C: 20 E5       jr   nz,$2943
295E: C9          ret

display_insert_coin_screen_295f:
295F: AF          xor  a
2960: 32 AB 80    ld   ($80AB),a
2963: 32 00 D6    ld   (video_mode_d600),a
2966: 21 00 C4    ld   hl,videoram_layer_1_C400
2969: 0E 0C       ld   c,$0C
296B: 47          ld   b,a
296C: 77          ld   (hl),a
296D: 23          inc  hl
296E: 10 FC       djnz $296C
2970: 0D          dec  c
2971: 20 F8       jr   nz,$296B
2973: CD 39 58    call display_status_bars_5839
2976: CD C6 57    call update_upper_status_bar_57C6
2979: CD B0 10    call display_credit_info_10b0
297C: CD 8E 29    call display_insert_coin_298e
297F: 21 2C 01    ld   hl,$012C
2982: 22 2F 82    ld   ($822F),hl
2985: 3E 09       ld   a,GS_INSERT_COIN_09
2987: 32 AC 80    ld   (game_state_80AC),a
298A: CD C2 26    call reload_8bit_tiimer_26C2
298D: C9          ret

display_insert_coin_298e:
298E: 21 02 2A    ld   hl,insert_coin_string_2A02
2991: 11 89 C5    ld   de,$C589
2994: CD F9 29    call copy_string_to_screen_29F9
2997: 3A 50 82    ld   a,(copy_of_dip_switches_3_8250)
299A: CB 67       bit  4,a
299C: C0          ret  nz
299D: CB 7F       bit  7,a
299F: 20 25       jr   nz,$29C6
29A1: 21 13 2A    ld   hl,left_coin_shot_string_2A13
29A4: 11 EA C5    ld   de,$C5EA
29A7: CD F9 29    call copy_string_to_screen_29F9
29AA: 2A A5 80    ld   hl,($80A5)
29AD: 11 28 C6    ld   de,$C628
29B0: CD D0 29    call display_coin_credit_text_29d0
29B3: 21 22 2A    ld   hl,right_coin_shot_string_2A22
29B6: 11 89 C6    ld   de,$C689
29B9: CD F9 29    call copy_string_to_screen_29F9
29BC: 2A A7 80    ld   hl,(coin_slot_2_dsw_copy_80A7)
29BF: 11 C8 C6    ld   de,$C6C8
29C2: CD D0 29    call display_coin_credit_text_29d0
29C5: C9          ret
29C6: 2A A5 80    ld   hl,($80A5)
29C9: 11 28 C6    ld   de,$C628
29CC: CD D0 29    call display_coin_credit_text_29d0
29CF: C9          ret

display_coin_credit_text_29d0:
29D0: 44          ld   b,h
29D1: 4D          ld   c,l
29D2: 79          ld   a,c
29D3: F6 10       or   $10
29D5: 12          ld   (de),a
29D6: 13          inc  de
29D7: 13          inc  de
29D8: 21 32 2A    ld   hl,coin_string_2A32
29DB: CD F9 29    call copy_string_to_screen_29F9
29DE: 0D          dec  c
29DF: 28 03       jr   z,$29E4
29E1: 3E 2D       ld   a,$2D
29E3: 12          ld   (de),a
29E4: 13          inc  de
29E5: 13          inc  de
29E6: 13          inc  de
29E7: 78          ld   a,b
29E8: F6 10       or   $10
29EA: 12          ld   (de),a
29EB: 13          inc  de
29EC: 13          inc  de
29ED: 21 37 2A    ld   hl,credit_string_2A37
29F0: CD F9 29    call copy_string_to_screen_29F9
29F3: 05          dec  b
29F4: C8          ret  z
29F5: 3E 2D       ld   a,$2D
29F7: 12          ld   (de),a
29F8: C9          ret

copy_string_to_screen_29F9:
29F9: 7E          ld   a,(hl)
29FA: FE FF       cp   $FF
29FC: C8          ret  z
29FD: 12          ld   (de),a
29FE: 23          inc  hl
29FF: 13          inc  de
2A00: 18 F7       jr   copy_string_to_screen_29F9

; "INSERT COIN (S)"
insert_coin_string_2A02:
	dc.b	2C          
	dc.b	25          
	dc.b	2D          
	dc.b	1E 1F       
	dc.b	31 00 00    
	dc.b	00          
	dc.b	2E 2F       
	dc.b	2C          
	dc.b	25          
	dc.b	07          
	dc.b	2D          
	dc.b	08          
	dc.b	FF     
	
; "LEFT COIN SHOT"
left_coin_shot_string_2A13:
	dc.b	1B          
	dc.b	1E 27       
	dc.b	31 00 2E    
	dc.b	2F          
	dc.b	2C          
	dc.b	25          
	dc.b	00          
	dc.b	2D          
	dc.b	1B          
	dc.b	2F          
	dc.b	31 FF 

; "RIGHT COIN SHOT"
right_coin_shot_string_2A22:
	dc.b	1F    
	dc.b	2C         
	dc.b	28 2B      
	dc.b	31 00 2E   
	dc.b	2F         
	dc.b	2C         
	dc.b	25         
	dc.b	00         
	dc.b	2D         
	dc.b	1B         
	dc.b	2F         
	dc.b	31 FF

; "COIN"
coin_string_2A32:	
	dc.b	2E   
	dc.b	2F   
	dc.b	2C   
	dc.b	25   
	dc.b	FF   

; "CREDIT"
credit_string_2A37:
    dc.b  2E 1F
    dc.b  1E 30
    dc.b  2C   
    dc.b  31 FF
	
init_level_skill_params_2A2E:
2A3E: 21 00 00    ld   hl,$0000                                      
2A41: 22 31 82    ld   (level_timer_16bit_8231),hl		; reset timer
2A44: 3E 04       ld   a,$04
2A46: 32 33 82    ld   ($8233),a
2A49: 3A 37 82    ld   a,(skill_level_8237)
2A4C: CB 3F       srl  a
2A4E: CB 3F       srl  a		; skill level times 4
2A50: C6 06       add  a,$06
2A52: FE 08       cp   $08
2A54: 38 02       jr   c,$2A58
2A56: 3E 08       ld   a,$08	; maxed out
2A58: 32 4C 83    ld   ($834C),a
2A5B: 3E 46       ld   a,$46
2A5D: 32 ED 82    ld   ($82ED),a
2A60: AF          xor  a
2A61: 32 76 83    ld   ($8376),a
2A64: C9          ret

init_elevators_2a65:
2A65: CD 75 2A    call $2A75
2A68: CD 9A 2A    call $2A9A
2A6B: CD 20 2C    call $2C20
2A6E: CD 52 2D    call $2D52
2A71: CD AC 2D    call initialize_elevator_screen_2dac
2A74: C9          ret

2A75: 06 0B       ld   b,$0B
2A77: 21 83 83    ld   hl,$8383
2A7A: 11 08 00    ld   de,protection_crap_0008
2A7D: 36 00       ld   (hl),$00
2A7F: 19          add  hl,de
2A80: 10 FB       djnz $2A7D
2A82: 06 02       ld   b,$02
2A84: CD 35 1E    call ramdon_1E35
2A87: 26 00       ld   h,$00
2A89: 6F          ld   l,a
2A8A: 29          add  hl,hl
2A8B: 29          add  hl,hl
2A8C: 29          add  hl,hl
2A8D: 11 83 83    ld   de,$8383
2A90: 19          add  hl,de
2A91: 7E          ld   a,(hl)
2A92: B7          or   a
2A93: C2 84 2A    jp   nz,$2A84
2A96: 34          inc  (hl)
2A97: 10 EB       djnz $2A84
2A99: C9          ret

2A9A: CD AA 2A    call init_elevator_params_2aaa
2A9D: CD ED 2A    call $2AED
2AA0: CD 10 2B    call $2B10
2AA3: CD 99 0F    call set_elevators_neutral_controls_0F99
2AA6: CD 08 2C    call $2C08
2AA9: C9          ret

init_elevator_params_2aaa:
2AAA: DD 21 7D 83 ld   ix,elevator_array_837D
2AAE: 11 D7 2A    ld   de,table_2AD7
2AB1: 06 00       ld   b,$00
2AB3: 1A          ld   a,(de)
2AB4: DD 77 03    ld   (ix+min_floor_03),a
2AB7: 13          inc  de
2AB8: 1A          ld   a,(de)
2AB9: DD 77 02    ld   (ix+$02),a
2ABC: 13          inc  de
2ABD: 3A 2D 80    ld   a,($802D)
2AC0: 3C          inc  a
2AC1: B8          cp   b
2AC2: C2 C8 2A    jp   nz,$2AC8
2AC5: DD 35 03    dec  (ix+min_floor_03)
2AC8: C5          push bc
2AC9: 01 08 00    ld   bc,protection_crap_0008			; elevator struct size
2ACC: DD 09       add  ix,bc
2ACE: C1          pop  bc
2ACF: 04          inc  b
2AD0: 78          ld   a,b
2AD1: FE 0B       cp   $0B
2AD3: C2 B3 2A    jp   nz,$2AB3
2AD6: C9          ret

table_2AD7:
	dc.b	07      
	dc.b	0B      
	dc.b	01 06 01
	dc.b	07      
	dc.b	01 05 01
	dc.b	07      
	dc.b	01 07 07
	dc.b	0D      
	dc.b	0D      
	dc.b	0F      
	dc.b	0A      
	dc.b	0C      
	dc.b	0F      
	dc.b	11 13 1F
2AED: 21 81 83    ld   hl,$8381
2AF0: 11 05 2B    ld   de,table_2B05
2AF3: 06 0B       ld   b,$0B
2AF5: C5          push bc
2AF6: 1A          ld   a,(de)
2AF7: 77          ld   (hl),a
2AF8: 13          inc  de
2AF9: 23          inc  hl
2AFA: C6 15       add  a,$15
2AFC: 77          ld   (hl),a
2AFD: 01 07 00    ld   bc,$0007
2B00: 09          add  hl,bc
2B01: C1          pop  bc
2B02: 10 F1       djnz $2AF5
2B04: C9          ret
table_2B05:
	dc.b	11 31 51
	dc.b	71      
	dc.b	91      
	dc.b	B1      
	dc.b	D1      
	dc.b	11 71 71
	dc.b	71  
    
2B10: 21 7D 83    ld   hl,elevator_array_837D
2B13: 06 0B       ld   b,$0B
2B15: 11 08 00    ld   de,protection_crap_0008
2B18: 36 00       ld   (hl),$00
2B1A: 19          add  hl,de
2B1B: 10 FB       djnz $2B18
2B1D: DD 21 AD 83 ld   ix,$83AD
2B21: 0E 07       ld   c,$07
2B23: CD 7F 2B    call $2B7F
2B26: 7B          ld   a,e
2B27: 92          sub  d
2B28: 3C          inc  a
2B29: 47          ld   b,a
2B2A: CD 3E 1E    call get_random_value_1e3e
2B2D: 82          add  a,d
2B2E: DD 77 01    ld   (ix+character_x_right_01),a
2B31: 11 F8 FF    ld   de,$FFF8
2B34: DD 19       add  ix,de
2B36: 0D          dec  c
2B37: 20 EA       jr   nz,$2B23
2B39: 3A 7E 83    ld   a,($837E)
2B3C: C6 04       add  a,$04
2B3E: 32 B6 83    ld   ($83B6),a
2B41: CD 57 2B    call $2B57
2B44: 3A 96 83    ld   a,($8396)
2B47: C6 07       add  a,$07
2B49: 32 BE 83    ld   ($83BE),a
2B4C: C6 05       add  a,$05
2B4E: 32 C6 83    ld   ($83C6),a
2B51: C6 04       add  a,$04
2B53: 32 CE 83    ld   ($83CE),a
2B56: C9          ret
2B57: 3A 2C 80    ld   a,($802C)
2B5A: FE 13       cp   $13
2B5C: 30 13       jr   nc,$2B71
2B5E: FE 12       cp   $12
2B60: D0          ret  nc
2B61: FE 0F       cp   $0F
2B63: 30 10       jr   nc,$2B75
2B65: FE 0D       cp   $0D
2B67: D0          ret  nc
2B68: FE 0A       cp   $0A
2B6A: 30 0D       jr   nc,$2B79
2B6C: FE 05       cp   $05
2B6E: 28 0B       jr   z,$2B7B
2B70: C9          ret
2B71: D6 10       sub  $10
2B73: 18 06       jr   $2B7B
2B75: D6 0C       sub  $0C
2B77: 18 02       jr   $2B7B
2B79: D6 07       sub  $07
2B7B: 32 96 83    ld   ($8396),a
2B7E: C9          ret
2B7F: 3A 03 80    ld   a,($8003)
2B82: 47          ld   b,a
2B83: 79          ld   a,c
2B84: 3D          dec  a
2B85: CA DD 2B    jp   z,$2BDD
2B88: FE 03       cp   $03
2B8A: CA BE 2B    jp   z,$2BBE
2B8D: DD 7E 06    ld   a,(ix+$06)
2B90: 87          add  a,a
2B91: DD 86 03    add  a,(ix+character_y_offset_03)
2B94: C6 02       add  a,$02
2B96: 6F          ld   l,a
2B97: 60          ld   h,b
2B98: 7C          ld   a,h
2B99: BD          cp   l
2B9A: 30 02       jr   nc,$2B9E
2B9C: 65          ld   h,l
2B9D: 6F          ld   l,a
2B9E: DD 6E 02    ld   l,(ix+$02)
2BA1: 7C          ld   a,h
2BA2: BD          cp   l
2BA3: 30 02       jr   nc,$2BA7
2BA5: 65          ld   h,l
2BA6: 6F          ld   l,a
2BA7: 7D          ld   a,l
2BA8: D6 02       sub  $02
2BAA: 57          ld   d,a
2BAB: DD 7E 06    ld   a,(ix+$06)
2BAE: 87          add  a,a
2BAF: 80          add  a,b
2BB0: C6 04       add  a,$04
2BB2: 6F          ld   l,a
2BB3: DD 66 02    ld   h,(ix+$02)
2BB6: 7C          ld   a,h
2BB7: BD          cp   l
2BB8: 30 02       jr   nc,$2BBC
2BBA: 65          ld   h,l
2BBB: 6F          ld   l,a
2BBC: 5D          ld   e,l
2BBD: C9          ret
2BBE: 78          ld   a,b
2BBF: D6 12       sub  $12
2BC1: DA 8D 2B    jp   c,$2B8D
2BC4: 47          ld   b,a
2BC5: 6F          ld   l,a
2BC6: 26 03       ld   h,$03
2BC8: 7C          ld   a,h
2BC9: BD          cp   l
2BCA: 30 02       jr   nc,$2BCE
2BCC: 65          ld   h,l
2BCD: 6F          ld   l,a
2BCE: 54          ld   d,h
2BCF: 68          ld   l,b
2BD0: 26 0A       ld   h,$0A
2BD2: 7C          ld   a,h
2BD3: BD          cp   l
2BD4: 30 02       jr   nc,$2BD8
2BD6: 65          ld   h,l
2BD7: 6F          ld   l,a
2BD8: 7D          ld   a,l
2BD9: C6 05       add  a,$05
2BDB: 5F          ld   e,a
2BDC: C9          ret
2BDD: DD 7E 06    ld   a,(ix+$06)
2BE0: 87          add  a,a
2BE1: DD 86 03    add  a,(ix+character_y_offset_03)
2BE4: 6F          ld   l,a
2BE5: 60          ld   h,b
2BE6: 24          inc  h
2BE7: 7C          ld   a,h
2BE8: BD          cp   l
2BE9: 30 02       jr   nc,$2BED
2BEB: 65          ld   h,l
2BEC: 6F          ld   l,a
2BED: DD 6E 02    ld   l,(ix+$02)
2BF0: 2D          dec  l
2BF1: 2D          dec  l
2BF2: 7C          ld   a,h
2BF3: BD          cp   l
2BF4: 30 02       jr   nc,$2BF8
2BF6: 65          ld   h,l
2BF7: 6F          ld   l,a
2BF8: 55          ld   d,l
2BF9: 78          ld   a,b
2BFA: C6 06       add  a,$06
2BFC: 6F          ld   l,a
2BFD: DD 66 02    ld   h,(ix+$02)
2C00: 7C          ld   a,h
2C01: BD          cp   l
2C02: 30 02       jr   nc,$2C06
2C04: 65          ld   h,l
2C05: 6F          ld   l,a
2C06: 5D          ld   e,l
2C07: C9          ret

2C08: 21 81 80    ld   hl,elevator_directions_array_8081
2C0B: 06 0B       ld   b,$0B
2C0D: CD F5 1D    call pseudo_random_1DF5
2C10: 4F          ld   c,a
2C11: CB 09       rrc  c
2C13: 79          ld   a,c
2C14: E6 04       and  $04
2C16: D6 02       sub  $02
2C18: 77          ld   (hl),a
2C19: 23          inc  hl
2C1A: 36 14       ld   (hl),$14
2C1C: 23          inc  hl
2C1D: 10 F2       djnz $2C11
2C1F: C9          ret

2C20: CD 2D 2C    call $2C2D
2C23: CD 92 2C    call $2C92
2C26: CD E2 2C    call $2CE2
2C29: CD FF 2C    call $2CFF
2C2C: C9          ret

2C2D: DD 21 D5 83 ld   ix,$83D5
2C31: 21 66 2C    ld   hl,table_2C66
2C34: 06 00       ld   b,$00
2C36: 7E          ld   a,(hl)
2C37: DD 77 04    ld   (ix+$04),a
2C3A: 23          inc  hl
2C3B: 7E          ld   a,(hl)
2C3C: DD 77 05    ld   (ix+character_delta_x_05),a
2C3F: 23          inc  hl
2C40: 5E          ld   e,(hl)
2C41: 23          inc  hl
2C42: 56          ld   d,(hl)
2C43: 23          inc  hl
2C44: E5          push hl
2C45: 3A 2D 80    ld   a,($802D)
2C48: 3C          inc  a
2C49: B8          cp   b
2C4A: C2 52 2C    jp   nz,$2C52
2C4D: 21 D0 FF    ld   hl,$FFD0
2C50: 19          add  hl,de
2C51: EB          ex   de,hl
2C52: DD 73 06    ld   (ix+$06),e
2C55: DD 72 07    ld   (ix+$07),d
2C58: E1          pop  hl
2C59: 11 15 00    ld   de,$0015
2C5C: DD 19       add  ix,de
2C5E: 04          inc  b
2C5F: 3E 0B       ld   a,$0B
2C61: B8          cp   b
2C62: C2 36 2C    jp   nz,$2C36
2C65: C9          ret
table_2C66:
	dc.b	6F      
	dc.b	02      
	dc.b	84      
	dc.b	01 7F 01
	dc.b	64      
	dc.b	00      
	dc.b	AF      
	dc.b	01 64 00
	dc.b	4F      
	dc.b	01 64 00
	dc.b	AF      
	dc.b	01 64 00
	dc.b	AF      
	dc.b	01 64 00
	dc.b	CF      
	dc.b	02      
	dc.b	84      
	dc.b	01 2F 03
	dc.b	A4      
	dc.b	02      
	dc.b	9F      
	dc.b	02      
	dc.b	14      
	dc.b	02      
	dc.b	8F      
	dc.b	03      
	dc.b	04      
	dc.b	03      
	dc.b	2F      
	dc.b	06 C4   
	dc.b	03      

2C92: DD 21 D5 83 ld   ix,$83D5
2C96: 06 0B       ld   b,$0B
2C98: 2A 28 80    ld   hl,($8028)
2C9B: DD 56 05    ld   d,(ix+character_delta_x_05)
2C9E: DD 5E 04    ld   e,(ix+$04)
2CA1: 7D          ld   a,l
2CA2: 93          sub  e
2CA3: 7C          ld   a,h
2CA4: 9A          sbc  a,d
2CA5: F2 A9 2C    jp   p,$2CA9
2CA8: EB          ex   de,hl
2CA9: DD 73 00    ld   (ix+character_x_00),e
2CAC: DD 72 01    ld   (ix+character_x_right_01),d
2CAF: 2A 2A 80    ld   hl,($802A)
2CB2: DD 56 07    ld   d,(ix+$07)
2CB5: DD 5E 06    ld   e,(ix+$06)
2CB8: 7D          ld   a,l
2CB9: 93          sub  e
2CBA: 7C          ld   a,h
2CBB: 9A          sbc  a,d
2CBC: F2 C0 2C    jp   p,$2CC0
2CBF: EB          ex   de,hl
2CC0: DD 75 02    ld   (ix+character_fine_y_offset_02),l
2CC3: DD 74 03    ld   (ix+character_y_offset_03),h
2CC6: EB          ex   de,hl
2CC7: DD 36 0D 01 ld   (ix+move_direction_0d),$01
2CCB: DD 66 01    ld   h,(ix+character_x_right_01)
2CCE: DD 6E 00    ld   l,(ix+character_x_00)
2CD1: AF          xor  a
2CD2: ED 52       sbc  hl,de
2CD4: D2 DA 2C    jp   nc,$2CDA
2CD7: DD 35 0D    dec  (ix+move_direction_0d)
2CDA: 11 15 00    ld   de,$0015
2CDD: DD 19       add  ix,de
2CDF: 10 B7       djnz $2C98
2CE1: C9          ret
2CE2: DD 21 D5 83 ld   ix,$83D5
2CE6: FD 21 7D 83 ld   iy,elevator_array_837D
2CEA: 06 0B       ld   b,$0B
2CEC: FD 7E 06    ld   a,(iy+$06)
2CEF: DD 77 0E    ld   (ix+$0e),a
2CF2: 11 15 00    ld   de,$0015
2CF5: DD 19       add  ix,de
2CF7: 11 08 00    ld   de,protection_crap_0008
2CFA: FD 19       add  iy,de
2CFC: 10 EE       djnz $2CEC
2CFE: C9          ret
2CFF: DD 21 7D 83 ld   ix,elevator_array_837D
2D03: FD 21 D5 83 ld   iy,$83D5
2D07: 06 0B       ld   b,$0B
2D09: C5          push bc
2D0A: FD 66 01    ld   h,(iy+$01)
2D0D: FD 6E 00    ld   l,(iy+$00)
2D10: CD 36 2D    call $2D36
2D13: FD 71 08    ld   (iy+$08),c
2D16: FD 70 09    ld   (iy+$09),b
2D19: FD 66 03    ld   h,(iy+$03)
2D1C: FD 6E 02    ld   l,(iy+$02)
2D1F: CD 36 2D    call $2D36
2D22: FD 71 0A    ld   (iy+$0a),c
2D25: FD 70 0B    ld   (iy+$0b),b
2D28: C1          pop  bc
2D29: 11 15 00    ld   de,$0015
2D2C: FD 19       add  iy,de
2D2E: 11 08 00    ld   de,protection_crap_0008
2D31: DD 19       add  ix,de
2D33: 10 D4       djnz $2D09
2D35: C9          ret
2D36: 7D          ld   a,l
2D37: E6 07       and  $07
2D39: 4F          ld   c,a
2D3A: 7D          ld   a,l
2D3B: CB 2C       sra  h
2D3D: 1F          rra
2D3E: CB 2C       sra  h
2D40: 1F          rra
2D41: CB 2C       sra  h
2D43: 1F          rra
2D44: 6F          ld   l,a
2D45: DD 7E 01    ld   a,(ix+character_x_right_01)
2D48: 3C          inc  a
2D49: 47          ld   b,a
2D4A: 80          add  a,b
2D4B: 80          add  a,b
2D4C: 87          add  a,a
2D4D: 47          ld   b,a
2D4E: 7D          ld   a,l
2D4F: 90          sub  b
2D50: 47          ld   b,a
2D51: C9          ret

2D52: DD 21 D5 83 ld   ix,$83D5
2D56: FD 21 7D 83 ld   iy,elevator_array_837D
2D5A: 06 07       ld   b,$07
2D5C: C5          push bc
2D5D: CD 77 2D    call $2D77
2D60: CD 8F 2D    call $2D8F
2D63: C1          pop  bc
2D64: 11 15 00    ld   de,$0015
2D67: DD 19       add  ix,de
2D69: 11 08 00    ld   de,protection_crap_0008
2D6C: FD 19       add  iy,de
2D6E: 10 EC       djnz $2D5C
2D70: CD 29 5F    call propagate_main_scroll_value_to_elevators_5f29
2D73: CD 63 61    call set_elevator_column_scroll_6163
2D76: C9          ret

2D77: FD 7E 01    ld   a,(iy+$01)
2D7A: CD 84 2D    call return_a_times_48_in_hl_2D84
2D7D: DD 75 0F    ld   (ix+$0f),l
2D80: DD 74 10    ld   (ix+$10),h
2D83: C9          ret

return_a_times_48_in_hl_2D84:
2D84: 47          ld   b,a
2D85: 80          add  a,b
2D86: 80          add  a,b
2D87: 87          add  a,a
2D88: 6F          ld   l,a
2D89: 26 00       ld   h,$00
2D8B: 29          add  hl,hl
2D8C: 29          add  hl,hl
2D8D: 29          add  hl,hl
2D8E: C9          ret

2D8F: FD 7E 02    ld   a,(iy+$02)
2D92: CD 84 2D    call return_a_times_48_in_hl_2D84
2D95: DD 74 12    ld   (ix+$12),h
2D98: DD 75 11    ld   (ix+$11),l
2D9B: FD 7E 06    ld   a,(iy+$06)
2D9E: 87          add  a,a
2D9F: FD 86 03    add  a,(iy+$03)
2DA2: CD 84 2D    call return_a_times_48_in_hl_2D84
2DA5: DD 74 14    ld   (ix+$14),h
2DA8: DD 75 13    ld   (ix+$13),l
2DAB: C9          ret

initialize_elevator_screen_2dac:
2DAC: DD 21 D5 83 ld   ix,$83D5
2DB0: 06 00       ld   b,$00
2DB2: DD 7E 0D    ld   a,(ix+move_direction_0d)
2DB5: B7          or   a
2DB6: CA E1 2D    jp   z,$2DE1
2DB9: 78          ld   a,b
2DBA: 32 0E 85    ld   ($850E),a
2DBD: DD 4E 09    ld   c,(ix+$09)
2DC0: C5          push bc
2DC1: 21 BC 84    ld   hl,elevator_tile_address_84BC
2DC4: 22 0F 85    ld   ($850F),hl
2DC7: CD 68 60    call $6068
2DCA: DD 46 0E    ld   b,(ix+$0e)
2DCD: CD AD 60    call $60AD
2DD0: 2A 0F 85    ld   hl,($850F)
2DD3: 36 00       ld   (hl),$00
2DD5: CD 77 61    call feed_elevator_columns_6177
2DD8: C1          pop  bc
2DD9: 0D          dec  c
2DDA: 79          ld   a,c
2DDB: DD BE 0B    cp   (ix+$0b)
2DDE: F2 C0 2D    jp   p,$2DC0
2DE1: 11 15 00    ld   de,$0015
2DE4: DD 19       add  ix,de
2DE6: 04          inc  b
2DE7: 78          ld   a,b
2DE8: FE 0B       cp   $0B
2DEA: C2 B2 2D    jp   nz,$2DB2
2DED: C9          ret

2DEE: CD 2A 2E    call $2E2A
2DF1: CD C2 26    call reload_8bit_tiimer_26C2
2DF4: CD CF 73    call game_tick_73cf
2DF7: 3A 0B D4    ld   a,($D40B)
2DFA: E6 C0       and  $C0
2DFC: 28 F6       jr   z,$2DF4
2DFE: FE C0       cp   $C0
2E00: 28 F2       jr   z,$2DF4
2E02: CB 7F       bit  7,a
2E04: 20 15       jr   nz,game_start_2e1b
2E06: 3A 4E 82    ld   a,(copy_of_dip_switches_1_824E)
2E09: CB 57       bit  2,a
2E0B: 20 0A       jr   nz,$2E17
2E0D: 3A A2 80    ld   a,(nb_credits_80A2)
2E10: D6 02       sub  $02
2E12: 38 E0       jr   c,$2DF4
2E14: 32 A2 80    ld   (nb_credits_80A2),a
2E17: CD 85 2E    call $2E85
2E1A: C9          ret

game_start_2e1b:
2E1B: 3A 4E 82    ld   a,(copy_of_dip_switches_1_824E)
2E1E: CB 57       bit  2,a
2E20: 20 04       jr   nz,$2E26
2E22: 21 A2 80    ld   hl,nb_credits_80A2
2E25: 35          dec  (hl)
2E26: CD 50 2E    call $2E50
2E29: C9          ret
2E2A: AF          xor  a
2E2B: 32 AB 80    ld   ($80AB),a
2E2E: 32 36 82    ld   ($8236),a
2E31: CD E1 71    call check_if_must_flip_screen_71e1
2E34: 3E 01       ld   a,$01
2E36: 32 D9 81    ld   (menu_or_game_tiles_81D9),a
2E39: CD 0C 26    call init_hw_scroll_and_charset_260C
2E3C: 3E 03       ld   a,GS_PUSH_START_03
2E3E: 32 AC 80    ld   (game_state_80AC),a
2E41: 3E 01       ld   a,$01
2E43: 32 A9 80    ld   (timer_8bit_reload_value_80A9),a
2E46: CD 39 58    call display_status_bars_5839
2E49: CD C6 57    call update_upper_status_bar_57C6
2E4C: CD B0 10    call display_credit_info_10b0
2E4F: C9          ret

2E50: CD 98 2E    call init_player_data_2e98
2E53: DD 2A 48 82 ld   ix,($8248)
2E57: DD 6E 17    ld   l,(ix+$17)
2E5A: DD 66 18    ld   h,(ix+$18)
2E5D: 3A 45 82    ld   a,($8245)
2E60: ED 44       neg
2E62: CC 46 82    call z,execute_dynamic_ram_code_8246
2E65: 3E DD       ld   a,$DD
2E67: DD 21 46 82 ld   ix,execute_dynamic_ram_code_8246
2E6B: DD 77 00    ld   (ix+$00),a
2E6E: DD 21 45 82 ld   ix,$8245
2E72: DD 77 00    ld   (ix+$00),a
2E75: 28 DC       jr   z,$2E53
2E77: 3A A2 80    ld   a,(nb_credits_80A2)
2E7A: 77          ld   (hl),a
2E7B: 3E 01       ld   a,$01
2E7D: 32 35 82    ld   ($8235),a
2E80: AF          xor  a
2E81: 32 36 82    ld   ($8236),a
2E84: C9          ret

2E85: CD 98 2E    call init_player_data_2e98
2E88: CD 9E 35    call switch_players_data_359e
2E8B: CD 98 2E    call init_player_data_2e98
2E8E: 3E 02       ld   a,$02
2E90: 32 35 82    ld   ($8235),a
2E93: AF          xor  a
2E94: 32 36 82    ld   ($8236),a
2E97: C9          ret

init_player_data_2e98:
2E98: 3A 52 82    ld   a,(dsw_copy_nb_lives_per_play_8252)
2E9B: 32 34 82    ld   (nb_lives_8234),a
2E9E: AF          xor  a
2E9F: 21 4D 83    ld   hl,$834D
2EA2: 77          ld   (hl),a
2EA3: 23          inc  hl
2EA4: 77          ld   (hl),a
2EA5: 23          inc  hl
2EA6: 77          ld   (hl),a
2EA7: 32 4A 82    ld   ($824A),a
2EAA: 32 73 83    ld   ($8373),a
2EAD: 3A 50 82    ld   a,(copy_of_dip_switches_3_8250)
2EB0: E6 03       and  $03
2EB2: 32 37 82    ld   (skill_level_8237),a
2EB5: C9          ret

2EB6: 21 E0 2E    ld   hl,push_string_2EE0
2EB9: 11 4E C5    ld   de,$C54E
2EBC: CD F9 29    call copy_string_to_screen_29F9
2EBF: 3A 4E 82    ld   a,(copy_of_dip_switches_1_824E)
2EC2: CB 57       bit  2,a
2EC4: 20 10       jr   nz,$2ED6
2EC6: 3A A2 80    ld   a,(nb_credits_80A2)
2EC9: 3D          dec  a
2ECA: 20 0A       jr   nz,$2ED6
2ECC: 21 E5 2E    ld   hl,only_1_player_button_string_2EE5
2ECF: 11 A4 C5    ld   de,$C5A4
2ED2: CD F9 29    call copy_string_to_screen_29F9
2ED5: C9          ret

2ED6: 21 FD 2E    ld   hl,one_or_two_players_button_string_2EFD
2ED9: 11 A4 C5    ld   de,$C5A4
2EDC: CD F9 29    call copy_string_to_screen_29F9
2EDF: C9          ret

; "PUSH"
push_string_2EE0:
	dc.b	1A          
	dc.b	22 2D 2B    
	dc.b	FF          

; "ONLY 1 PLAYER BUTTON"
only_1_player_button_string_2EE5:
	dc.b	00      
	dc.b	00      
	dc.b	2F      
	dc.b	25      
	dc.b	1B      
	dc.b	1D      
	dc.b	00      
	dc.b	11 00 1A
	dc.b	1B      
	dc.b	1C      
	dc.b	1D      
	dc.b	1E 1F   
	dc.b	00      
	dc.b	29      
	dc.b	22 31 31
	dc.b	2F      
	dc.b	25      
	dc.b	00      
	dc.b	FF      

; "1 - OR 2 PLAYERS BUTTON"
one_or_two_players_button_string_2EFD:
	dc.b	11 2A 00
	dc.b	2F      
	dc.b	1F      
	dc.b	00      
	dc.b	00      
	dc.b	12      
	dc.b	2A 1A 1B
	dc.b	1C      
	dc.b	1D      
	dc.b	1E 1F   
	dc.b	00      
	dc.b	00      
	dc.b	29      
	dc.b	22 31 31
	dc.b	2F      
	dc.b	25      
	dc.b	FF      


2F15: AF          xor  a
2F16: 3E 14       ld   a,$14
2F18: C9          ret

; this seems uncalled/unused
2F19: E5          push hl
2F1A: 3E 01       ld   a,$01
2F1C: 21 2A 2E    ld   hl,$2E2A

; dynamic code executed by game
2F1F: 86          add  a,(hl)
2F20: FD E3       ex   (sp),iy
2F22: 06 C9       ld   b,$C9
2F24: 98          sbc  a,b
2F25: C6 C5       add  a,$C5
2F27: FD E3       ex   (sp),iy
2F29: 20 EA       jr   nz,$2F15
2F2B: DD 6E 19    ld   l,(ix+$19)
2F2E: DD 66 1A    ld   h,(ix+$1a)
2F31: E5          push hl
2F32: DD E1       pop  ix
2F34: DD E9       jp   (ix)

	dc.b	44     
	dc.b	82     
	dc.b	D5     
	dc.b	10 

2F3A: 21 FB 80    ld   hl,$80FB                                      
2F3D: 06 28       ld   b,$28
2F3F: 36 FF       ld   (hl),$FF
2F41: 23          inc  hl
2F42: 10 FB       djnz $2F3F
2F44: 21 3A 85    ld   hl,enemy_1_853A
2F47: 06 80       ld   b,$80
2F49: 36 00       ld   (hl),$00
2F4B: 23          inc  hl
2F4C: 10 FB       djnz $2F49
2F4E: 21 3A 85    ld   hl,enemy_1_853A
2F51: 0E 04       ld   c,$04
2F53: 11 12 00    ld   de,$0012
2F56: 06 0E       ld   b,$0E
2F58: 36 FF       ld   (hl),$FF
2F5A: 23          inc  hl
2F5B: 10 FB       djnz $2F58
2F5D: 19          add  hl,de
2F5E: 0D          dec  c
2F5F: 20 F5       jr   nz,$2F56
2F61: 21 4A 85    ld   hl,$854A
2F64: 11 20 00    ld   de,$0020
2F67: 06 04       ld   b,$04
2F69: 3E 0A       ld   a,$0A
2F6B: 77          ld   (hl),a
2F6C: C6 0F       add  a,$0F
2F6E: 19          add  hl,de
2F6F: 10 FA       djnz $2F6B
2F71: C9          ret


set_player_initial_state_2f72:
2F72: CD A9 46    call get_sprite_shadow_ram_46a9
2F75: 06 0A       ld   b,$0A
2F77: 36 FF       ld   (hl),$FF
2F79: 23          inc  hl
2F7A: 10 FB       djnz $2F77
2F7C: 21 9C 2F    ld   hl,initial_player_structure_2F9C
2F7F: 11 1A 85    ld   de,player_structure_851A
2F82: 01 0E 00    ld   bc,$000E
2F85: ED B0       ldir			; copy initial player structure to current player structure at start
2F87: 06 12       ld   b,$12
2F89: 3E 00       ld   a,$00
2F8B: 32 38 82    ld   ($8238),a
2F8E: 12          ld   (de),a
2F8F: 13          inc  de
2F90: 10 FC       djnz $2F8E
2F92: 3A 2C 80    ld   a,($802C)
2F95: 32 21 85    ld   (player_structure_851A+current_floor_07),a
2F98: CD AA 2F    call $2FAA
2F9B: C9          ret

initial_player_structure_2F9C:
	dc.b	67      ; x
	dc.b	6F      ; fine x
	dc.b	1C      ;
	dc.b	06 		; y offset
	dc.b	02
	dc.b	00   
	dc.b	00   
	dc.b	00   
	dc.b	00   
	dc.b	00   
	dc.b	00   
	dc.b	01 00 00
	
2FAA: DD 21 1A 85 ld   ix,player_structure_851A
2FAE: DD 7E 07    ld   a,(ix+$07)
2FB1: FE 1F       cp   $1F
2FB3: D0          ret  nc
2FB4: 5F          ld   e,a
2FB5: 16 00       ld   d,$00
2FB7: 21 10 82    ld   hl,red_door_position_array_8210
2FBA: 19          add  hl,de
2FBB: 7E          ld   a,(hl)
2FBC: FE 08       cp   $08
2FBE: D0          ret  nc
2FBF: 57          ld   d,a
2FC0: 7B          ld   a,e
2FC1: FE 07       cp   $07
2FC3: 30 0B       jr   nc,$2FD0
2FC5: 7A          ld   a,d
2FC6: FE 04       cp   $04
2FC8: 3E 1C       ld   a,$1C
2FCA: 38 0C       jr   c,$2FD8
2FCC: 3E D4       ld   a,$D4
2FCE: 18 08       jr   $2FD8
2FD0: 7A          ld   a,d
2FD1: 82          add  a,d
2FD2: 82          add  a,d
2FD3: 87          add  a,a
2FD4: 87          add  a,a
2FD5: 87          add  a,a
2FD6: C6 24       add  a,$24
2FD8: DD 77 00    ld   (ix+character_x_00),a
2FDB: C6 08       add  a,$08
2FDD: DD 77 01    ld   (ix+character_x_right_01),a
2FE0: FE 80       cp   $80
2FE2: D0          ret  nc
2FE3: DD 36 0B 00 ld   (ix+$0b),$00
2FE7: C9          ret

2FE8: DD 21 1A 85 ld   ix,player_structure_851A
2FEC: 3E 00       ld   a,$00
2FEE: 32 BA 85    ld   (current_enemy_index_85BA),a
2FF1: 21 F1 80    ld   hl,$80F1
2FF4: 22 BF 85    ld   ($85BF),hl
2FF7: 21 64 81    ld   hl,$8164
2FFA: 22 BB 85    ld   ($85BB),hl
2FFD: 21 2D 81    ld   hl,$812D
3000: 22 BD 85    ld   ($85BD),hl
3003: CD 1C 30    call $301C
3006: DD 36 1B 01 ld   (ix+$1b),$01
300A: CD 2A 43    call $432A
300D: CD 8A 61    call $618A
3010: CD 46 30    call handle_elevator_sound_3046
3013: DD 7E 13    ld   a,(ix+$13)
3016: B7          or   a
3017: C8          ret  z
3018: DD 35 13    dec  (ix+$13)
301B: C9          ret

301C: DD 7E 11    ld   a,(ix+$11)
301F: B7          or   a
3020: 28 1B       jr   z,$303D
3022: 3D          dec  a
3023: 28 18       jr   z,$303D
3025: DD 34 14    inc  (ix+$14)
3028: DD 7E 14    ld   a,(ix+$14)
302B: FE 08       cp   $08
302D: 30 05       jr   nc,$3034
302F: DD 36 11 00 ld   (ix+$11),$00
3033: C9          ret
3034: DD 36 11 FF ld   (ix+$11),$FF
3038: DD 36 14 00 ld   (ix+$14),$00
303C: C9          ret
303D: DD 36 11 00 ld   (ix+$11),$00
3041: DD 36 14 00 ld   (ix+$14),$00
3045: C9          ret

handle_elevator_sound_3046:
3046: 16 00       ld   d,$00
3048: 3A 20 85    ld   a,(player_structure_851A+character_situation_06)
304B: B7          or   a
304C: 28 21       jr   z,$306F
304E: FE 03       cp   $03
3050: 30 1D       jr   nc,$306F
3052: 3A 23 85    ld   a,(player_structure_851A+9)
3055: FE 05       cp   $05
3057: 38 04       jr   c,$305D
3059: FE 07       cp   $07
305B: 20 12       jr   nz,$306F
305D: 3A 22 85    ld   a,(player_structure_851A+8)
3060: E6 7F       and  $7F
3062: 5F          ld   e,a
3063: 87          add  a,a
3064: 87          add  a,a
3065: 83          add  a,e
3066: 87          add  a,a
3067: 87          add  a,a
3068: 83          add  a,e
3069: 5F          ld   e,a
306A: 21 E1 83    ld   hl,$83E1
306D: 19          add  hl,de
306E: 56          ld   d,(hl)
306F: 21 38 82    ld   hl,$8238
3072: 7E          ld   a,(hl)
3073: 72          ld   (hl),d
3074: BA          cp   d
3075: C8          ret  z
3076: 7A          ld   a,d
3077: B7          or   a
3078: 3E 64       ld   a,$64			; elevator move sound
307A: 20 01       jr   nz,$307D
307C: 3C          inc  a				; elevator sound stop?
307D: CD 56 36    call play_sound_3656
3080: C9          ret

update_enemies_3081:
3081: DD 21 3A 85 ld   ix,enemy_1_853A
3085: 3E 01       ld   a,$01
3087: 32 BA 85    ld   (current_enemy_index_85BA),a
308A: 21 FB 80    ld   hl,$80FB
308D: 22 BF 85    ld   ($85BF),hl
3090: 21 32 81    ld   hl,$8132
3093: 22 BD 85    ld   ($85BD),hl
3096: 22 BB 85    ld   ($85BB),hl
3099: CD 2A 43    call $432A
309C: CD 8A 61    call $618A
309F: 11 20 00    ld   de,$0020
30A2: DD 19       add  ix,de
30A4: 2A BF 85    ld   hl,($85BF)
30A7: 11 05 00    ld   de,$0005
30AA: 19          add  hl,de
30AB: 19          add  hl,de
30AC: 22 BF 85    ld   ($85BF),hl
30AF: 2A BD 85    ld   hl,($85BD)
30B2: 19          add  hl,de
30B3: 22 BD 85    ld   ($85BD),hl
30B6: 2A BB 85    ld   hl,($85BB)
30B9: 19          add  hl,de
30BA: 22 BB 85    ld   ($85BB),hl
30BD: 3A BA 85    ld   a,(current_enemy_index_85BA)
30C0: 3C          inc  a
30C1: 32 BA 85    ld   (current_enemy_index_85BA),a
30C4: FE 05       cp   $05
30C6: C2 99 30    jp   nz,$3099
30C9: C9          ret

30CA: AF          xor  a
30CB: 32 3A 82    ld   (shoot_gun_requested_823A),a
30CE: C9          ret

handle_player_controls_30CF:
30CF: 3A 3B 82    ld   a,(game_in_play_flag_823B)
30D2: B7          or   a
30D3: C2 0C 31    jp   nz,demo_or_input_log_310C
; zero: game in play
30D6: 3A 4E 82    ld   a,(copy_of_dip_switches_1_824E)
30D9: 07          rlca
30DA: 07          rlca
30DB: E6 01       and  $01
30DD: 47          ld   b,a
30DE: 3A D8 81    ld   a,($81D8)
30E1: A8          xor  b
30E2: 20 05       jr   nz,$30E9
30E4: 3A 08 D4    ld   a,(input_1_D408)
30E7: 18 03       jr   carry_on_with_controls_30ec
; probably cocktail mode: read input 2
30E9: 3A 09 D4    ld   a,(input_2_D409)

; up: 8, down/crouch: 4, fire: $10, jump: $20, left: 1, right: 2, else 0
carry_on_with_controls_30ec:
30EC: 2F          cpl
30ED: 47          ld   b,a
30EE: E6 0F       and  $0F
30F0: 4F          ld   c,a		; keep only directions in c
30F1: 78          ld   a,b
30F2: E6 20       and  $20
30F4: 0F          rrca
30F5: 57          ld   d,a
30F6: 78          ld   a,b
30F7: E6 10       and  $10
30F9: 07          rlca
30FA: B2          or   d
30FB: 47          ld   b,a
30FC: 3A 3A 82    ld   a,(shoot_gun_requested_823A)
30FF: 2F          cpl
3100: A0          and  b
3101: E6 30       and  $30
3103: B1          or   c
* $10: jump, 1 move left, 2 move right... see above
3104: 32 27 85    ld   (player_move_direction_8527),a
3107: 78          ld   a,b
3108: 32 3A 82    ld   (shoot_gun_requested_823A),a
310B: C9          ret

demo_or_input_log_310C:
demo_controls_310C:
310C: 2A 3C 82    ld   hl,($823C)
310F: 3D          dec  a
3110: 28 0A       jr   z,read_and_log_input_311C
3112: 7E          ld   a,(hl)
3113: 23          inc  hl
3114: CB BC       res  7,h
3116: 22 3C 82    ld   ($823C),hl
3119: C3 EC 30    jp   carry_on_with_controls_30ec
	; this is not reachable, as the routine is only called if game in play
	; so with D0==1 or D0==2 (demo)
	; it is probably a leftover of input recording code
read_and_log_input_311C:
311C: 3A 08 D4    ld   a,(input_1_D408)
311F: 77          ld   (hl),a
3120: 23          inc  hl
3121: 22 3C 82    ld   ($823C),hl
3124: C3 EC 30    jp   carry_on_with_controls_30ec

3127: 3A 23 85    ld   a,(player_structure_851A+9)
312A: FE 07       cp   $07
312C: C0          ret  nz
312D: 3A 20 85    ld   a,($8520)
3130: FE 03       cp   $03
3132: D0          ret  nc
3133: DD 21 1A 85 ld   ix,player_structure_851A
3137: DD 56 00    ld   d,(ix+character_x_00)
313A: DD 5E 01    ld   e,(ix+character_x_right_01)
313D: DD 66 15    ld   h,(ix+$15)
3140: DD 6E 16    ld   l,(ix+$16)
3143: AF          xor  a
3144: 32 28 85    ld   ($8528),a
3147: DD 21 3A 85 ld   ix,enemy_1_853A
314B: CD 64 31    call unknown_enemy_handling_3164
314E: DD 21 5A 85 ld   ix,enemy_2_855A
3152: CD 64 31    call unknown_enemy_handling_3164
3155: DD 21 7A 85 ld   ix,enemy_3_857A
3159: CD 64 31    call unknown_enemy_handling_3164
315C: DD 21 9A 85 ld   ix,enemy_4_859A
3160: CD 64 31    call unknown_enemy_handling_3164
3163: C9          ret

unknown_enemy_handling_3164:
3164: DD 7E 09    ld   a,(ix+$09)
3167: FE 05       cp   $05
3169: D0          ret  nc
316A: DD 7E 06    ld   a,(ix+character_situation_06)
316D: FE 03       cp   CS_FALLING_03
316F: D0          ret  nc
3170: DD 7E 15    ld   a,(ix+$15)
3173: BD          cp   l
3174: D8          ret  c
3175: DD 7E 16    ld   a,(ix+$16)
3178: BC          cp   h
3179: D0          ret  nc
317A: DD 7E 00    ld   a,(ix+character_x_00)
317D: BB          cp   e
317E: D0          ret  nc
317F: DD 7E 01    ld   a,(ix+character_x_right_01)
3182: BA          cp   d
3183: D8          ret  c
3184: DD 36 0A 00 ld   (ix+$0a),$00
3188: DD 36 09 05 ld   (ix+$09),$05
318C: CD B9 56    call $56B9
318F: 3E CB       ld   a,$CB	; jumped/killed enemy
3191: CD 56 36    call play_sound_3656
3194: AF          xor  a
3195: 32 EC 82    ld   ($82EC),a
3198: 3A 3B 82    ld   a,(game_in_play_flag_823B)
319B: B7          or   a
319C: C0          ret  nz
319D: E5          push hl
319E: 21 C2 85    ld   hl,$85C2
31A1: 23          inc  hl
31A2: 23          inc  hl
31A3: AF          xor  a
31A4: B6          or   (hl)
31A5: E1          pop  hl
31A6: 32 42 86    ld   ($8642),a
31A9: C2 65 32    jp   nz,make_building_dark_3265
31AC: C9          ret

31AD: 3E FF       ld   a,$FF
31AF: 32 40 82    ld   (lamp_shot_state_8240),a
31B2: 32 64 81    ld   ($8164),a
31B5: AF          xor  a
31B6: 32 42 82    ld   ($8242),a
31B9: C9          ret

shot_lamp_collision_31BA:
update_shot_lamp_31BA:
31BA: 3A 40 82    ld   a,(lamp_shot_state_8240)
31BD: 3C          inc  a
31BE: C8          ret  z
31BF: 32 40 82    ld   (lamp_shot_state_8240),a
31C2: 3D          dec  a
31C3: CA E1 31    jp   z,$31E1
31C6: FE 03       cp   $03
31C8: DA 07 32    jp   c,$3207
31CB: CA 14 32    jp   z,change_to_falling_lamp_sprite_3214
31CE: FE 15       cp   $15
31D0: DA 25 32    jp   c,$3225
31D3: FE 18       cp   $18
31D5: DA 51 32    jp   c,$3251
31D8: CA 65 32    jp   z,make_building_dark_3265
31DB: FE 5A       cp   $5A
31DD: CA 92 32    jp   z,restore_building_lights_3292
31E0: C9          ret
31E1: 3E 24       ld   a,$24
31E3: 32 3F 82    ld   ($823F),a
31E6: CD 3A 33    call $333A
31E9: CD 55 33    call $3355
31EC: 21 64 81    ld   hl,$8164
31EF: 36 00       ld   (hl),$00
31F1: 23          inc  hl
31F2: 3A 41 82    ld   a,(falling_lamp_x_8241)
31F5: D6 04       sub  $04
31F7: 77          ld   (hl),a
31F8: 23          inc  hl
31F9: CD 7D 33    call $337D
31FC: 23          inc  hl
31FD: 36 00       ld   (hl),$00
31FF: 23          inc  hl
3200: 36 7F       ld   (hl),$7F
3202: 3E C7       ld   a,$C7		; lamp falling sound
3204: C3 56 36    jp   play_sound_3656
3207: CF          rst  $08
3208: 3A 04 80    ld   a,(scroll_speed_8004)
320B: 47          ld   b,a
320C: 3A 66 81    ld   a,($8166)
320F: 90          sub  b
3210: 32 66 81    ld   ($8166),a
3213: C9          ret

change_to_falling_lamp_sprite_3214:
3214: 21 66 81    ld   hl,$8166
3217: 3A 04 80    ld   a,(scroll_speed_8004)
321A: 47          ld   b,a
321B: 7E          ld   a,(hl)
321C: 90          sub  b
321D: 77          ld   (hl),a
321E: 23          inc  hl
321F: 36 04       ld   (hl),$04
3221: 23          inc  hl
3222: 36 7E       ld   (hl),$7E
3224: C9          ret
3225: 3A 3F 82    ld   a,($823F)
3228: D6 02       sub  $02
322A: 32 3F 82    ld   ($823F),a
322D: 21 66 81    ld   hl,$8166
3230: 3A 04 80    ld   a,(scroll_speed_8004)
3233: 47          ld   b,a
3234: 7E          ld   a,(hl)
3235: 90          sub  b
3236: D6 02       sub  $02
3238: 77          ld   (hl),a
3239: 23          inc  hl
323A: 3A 40 82    ld   a,(lamp_shot_state_8240)
323D: 1F          rra
323E: E6 01       and  $01
3240: C6 04       add  a,$04
3242: 77          ld   (hl),a
3243: CD CC 32    call enemies_vs_lamp_collision_32CC
3246: 3A 43 82    ld   a,($8243)
3249: B7          or   a
324A: C8          ret  z
324B: 3E 15       ld   a,$15
324D: 32 40 82    ld   (lamp_shot_state_8240),a
3250: C9          ret
3251: 21 66 81    ld   hl,$8166
3254: 3A 04 80    ld   a,(scroll_speed_8004)
3257: 47          ld   b,a
3258: 7E          ld   a,(hl)
3259: 90          sub  b
325A: 77          ld   (hl),a
325B: 23          inc  hl
325C: 3A 40 82    ld   a,(lamp_shot_state_8240)
325F: E6 01       and  $01
3261: C6 04       add  a,$04
3263: 77          ld   (hl),a
3264: C9          ret

make_building_dark_3265:
3265: 3E FF       ld   a,$FF
3267: 32 64 81    ld   ($8164),a
326A: 3E 30       ld   a,$30
326C: 32 06 D5    ld   (colorbank_D506),a
326F: 3E 22       ld   a,$22
3271: 32 07 D5    ld   (colorbank_D507),a
3274: 3E 01       ld   a,$01
3276: 32 42 82    ld   ($8242),a
3279: 3A 3B 82    ld   a,(game_in_play_flag_823B)
327C: B7          or   a
327D: C0          ret  nz
327E: DD E5       push ix
3280: DD 21 2B 86 ld   ix,$862B
3284: DD 7E 17    ld   a,(ix+$17)
3287: A7          and  a
3288: DD E1       pop  ix
328A: C8          ret  z
	; ouch! this is going to make game much harder! TODO check this
	; possibly a protection check
328B: 3A D6 81    ld   a,(pseudo_random_seed_81D6)
328E: 32 32 82    ld   (level_timer_16bit_msb_8232),a
3291: C9          ret

restore_building_lights_3292:
3292: CD AD 31    call $31AD
3295: 3E 10       ld   a,$10
3297: 32 06 D5    ld   (colorbank_D506),a
329A: 3E 32       ld   a,$32
329C: 32 07 D5    ld   (colorbank_D507),a
329F: 3A 3B 82    ld   a,(game_in_play_flag_823B)
32A2: B7          or   a
32A3: C0          ret  nz
32A4: FD E5       push iy
32A6: FD 21 8F 85 ld   iy,$858F
32AA: FD 7E 35    ld   a,(iy+$35)
32AD: A7          and  a
32AE: FD E1       pop  iy
32B0: C8          ret  z
32B1: 3A D6 81    ld   a,(pseudo_random_seed_81D6)
32B4: 32 32 82    ld   (level_timer_16bit_msb_8232),a
32B7: AF          xor  a
32B8: DD E5       push ix
32BA: DD 21 A4 85 ld   ix,$85A4
32BE: DD 77 20    ld   (ix+$20),a
32C1: DD 21 44 82 ld   ix,$8244
32C5: DD CB 0A D6 set  2,(ix+$0a)
32C9: DD E1       pop  ix
32CB: C9          ret

enemies_vs_lamp_collision_32CC:
32CC: AF          xor  a
32CD: 32 43 82    ld   ($8243),a
32D0: DD 21 3A 85 ld   ix,enemy_1_853A
32D4: CD ED 32    call enemy_vs_lamp_collision_32ED
32D7: DD 21 5A 85 ld   ix,enemy_2_855A
32DB: CD ED 32    call enemy_vs_lamp_collision_32ED
32DE: DD 21 7A 85 ld   ix,enemy_3_857A
32E2: CD ED 32    call enemy_vs_lamp_collision_32ED
32E5: DD 21 9A 85 ld   ix,enemy_4_859A
32E9: CD ED 32    call enemy_vs_lamp_collision_32ED
32EC: C9          ret

enemy_vs_lamp_collision_32ED:
32ED: DD 7E 09    ld   a,(ix+enemy_state_09)
32F0: 3C          inc  a
32F1: C8          ret  z				; $FF: inactive
32F2: DD 7E 06    ld   a,(ix+character_situation_06)
32F5: B7          or   a
32F6: C0          ret  nz
; character is on ground
32F7: 3A 3E 82    ld   a,($823E)
32FA: DD BE 07    cp   (ix+$07)
32FD: C0          ret  nz
32FE: 3A 3F 82    ld   a,($823F)
3301: DD BE 02    cp   (ix+character_fine_y_offset_02)
3304: D0          ret  nc
3305: 3A 41 82    ld   a,(falling_lamp_x_8241)
3308: DD BE 00    cp   (ix+character_x_00)
330B: DA 15 33    jp   c,$3315
330E: DD BE 01    cp   (ix+character_x_right_01)
3311: D0          ret  nc
3312: C3 1B 33    jp   enemy_hit_by_lamp_331b
3315: C6 08       add  a,$08
3317: DD BE 00    cp   (ix+character_x_00)
331A: D8          ret  c
; enemy hit by falling lamp
enemy_hit_by_lamp_331b:
331B: 32 43 82    ld   ($8243),a
331E: DD 7E 09    ld   a,(ix+enemy_state_09)
3321: FE 05       cp   $05
3323: C8          ret  z		; already hit
3324: DD 36 09 05 ld   (ix+enemy_state_09),$05
3328: DD 36 0A 00 ld   (ix+$0a),$00
332C: CD DE 56    call $56DE
332F: 3E CB       ld   a,$CB
3331: CD 56 36    call play_sound_3656
3334: AF          xor  a
3335: 32 EC 82    ld   ($82EC),a
3338: F1          pop  af
3339: C9          ret

333A: 3A 3E 82    ld   a,($823E)
333D: D6 08       sub  $08
333F: 5F          ld   e,a
3340: 16 00       ld   d,$00
3342: 21 DA 81    ld   hl,$81DA
3345: 19          add  hl,de
3346: 3A 41 82    ld   a,(falling_lamp_x_8241)
3349: 06 02       ld   b,$02
334B: FE 80       cp   $80
334D: D2 51 33    jp   nc,$3351
3350: 05          dec  b
3351: 78          ld   a,b
3352: A6          and  (hl)
3353: 77          ld   (hl),a
3354: C9          ret
3355: 3A 3E 82    ld   a,($823E)
3358: FE 10       cp   $10
335A: D2 60 33    jp   nc,$3360
335D: FE 0B       cp   $0B
335F: D0          ret  nc
3360: CD 33 56    call $5633
3363: 21 69 FF    ld   hl,$FF69
3366: 3A 41 82    ld   a,(falling_lamp_x_8241)
3369: FE 80       cp   $80
336B: DA 71 33    jp   c,$3371
336E: 21 75 FF    ld   hl,$FF75
3371: 19          add  hl,de
3372: 7C          ld   a,h
3373: E6 03       and  $03
3375: 67          ld   h,a
3376: 11 00 C8    ld   de,videoram_layer_2_C800
3379: 19          add  hl,de
337A: 36 97       ld   (hl),$97
337C: C9          ret

337D: E5          push hl
337E: 3A 3F 82    ld   a,($823F)
3381: 57          ld   d,a
3382: 0E 00       ld   c,$00
3384: 3A 3E 82    ld   a,($823E)
3387: 47          ld   b,a
3388: CD 6C 1E    call compute_delta_height_1e6c
338B: 7D          ld   a,l
338C: E1          pop  hl
338D: 77          ld   (hl),a
338E: C9          ret

bootup_338f:
338F: F3          di				; disable interrupts
3390: 31 00 88    ld   sp,mcu_read_8800		; set stack pointer
3393: ED 56       im   1			; set interrupt mode
3395: 21 00 80    ld   hl,$8000		; erase RAM
3398: AF          xor  a
3399: 77          ld   (hl),a
339A: 23          inc  hl
339B: CB 5C       bit  3,h
339D: 28 FA       jr   z,$3399		; until 8800
339F: 32 EA 82    ld   (coin_counter_lock_82EA),a
33A2: CD 17 34    call read_dip_switches_3417
33A5: 21 1E 17    ld   hl,table_171E
33A8: 11 C9 81    ld   de,$81C9
33AB: 01 05 00    ld   bc,$0005
33AE: ED B0       ldir
33B0: AF          xor  a
33B1: 32 AB 80    ld   ($80AB),a
33B4: 32 AC 80    ld   (game_state_80AC),a
33B7: 3E FF       ld   a,$FF
33B9: 32 80 80    ld   ($8080),a
33BC: CD 9F 77    call hardware_test_779F
33BF: 21 F9 34    ld   hl,$34F9
33C2: 01 0A 00    ld   bc,$000A
33C5: FB          ei
; bootleg: below code NOPed out
33C6: C2 C5 34    jp   nz,bad_hardware_34C5
; bootleg: end of NOPed code
33C9: CD AC 34    call rom_checksum_34AC
33CC: 32 80 80    ld   ($8080),a
33CF: 32 C6 85    ld   ($85C6),a
33D2: 3A 4E 82    ld   a,(copy_of_dip_switches_1_824E)
33D5: CB 57       bit  2,a					;  free play ?
33D7: 20 0B       jr   nz,$33E4				; yes? skip title sequence
33D9: CD 5F 71    call title_and_insert_coin_sequence_715F
33DC: 3A A2 80    ld   a,(nb_credits_80A2)
33DF: B7          or   a
33E0: 28 1F       jr   z,$3401
33E2: 18 00       jr   $33E4		; useless jump
33E4: CD 29 35    call $3529
33E7: 3E C0       ld   a,$C0
33E9: 32 0B D5    ld   (sound_latch_D50B),a
33EC: CD 4D 36    call $364D
33EF: 3A 4E 82    ld   a,(copy_of_dip_switches_1_824E)
33F2: CB 57       bit  2,a
33F4: 20 EE       jr   nz,$33E4
33F6: 3A A2 80    ld   a,(nb_credits_80A2)
33F9: B7          or   a
33FA: 20 E8       jr   nz,$33E4
33FC: 32 51 82    ld   ($8251),a
33FF: 18 D1       jr   $33D2
3401: CD 1B 11    call $111B
3404: 3A A2 80    ld   a,(nb_credits_80A2)
3407: B7          or   a
3408: 20 DA       jr   nz,$33E4
340A: 21 51 82    ld   hl,$8251
340D: 34          inc  (hl)
340E: 7E          ld   a,(hl)
340F: FE 03       cp   $03
3411: 38 BF       jr   c,$33D2
3413: 36 00       ld   (hl),$00
3415: 18 BB       jr   $33D2

read_dip_switches_3417:
3417: CD 03 35    call cache_dip_switches_3503
341A: 21 50 83    ld   hl,$8350
341D: AF          xor  a
341E: 77          ld   (hl),a
341F: 23          inc  hl
3420: 77          ld   (hl),a
3421: 23          inc  hl
3422: 36 01       ld   (hl),$01
3424: 21 4D 83    ld   hl,$834D
3427: 11 54 82    ld   de,$8254
342A: 06 03       ld   b,$03
342C: 77          ld   (hl),a
342D: 12          ld   (de),a
342E: 23          inc  hl
342F: 13          inc  de
3430: 10 FA       djnz $342C
3432: CD B1 0F    call read_dip_switches_0fb1
3435: 3E 01       ld   a,$01
3437: 32 35 82    ld   ($8235),a
343A: AF          xor  a
343B: 32 4B 82    ld   ($824B),a
343E: 32 4C 82    ld   (copy_of_service_mode_824C),a
3441: 06 03       ld   b,$03
3443: 3A 50 82    ld   a,(copy_of_dip_switches_3_8250)
3446: CB 7F       bit  7,a
3448: 28 02       jr   z,$344C
344A: 06 23       ld   b,$23
344C: 78          ld   a,b
344D: 32 0E D5    ld   (bank_switch_d50e),a
3450: 32 4D 82    ld   (bank_switch_copy_824D),a
3453: 3E C0       ld   a,$C0
3455: 32 0B D5    ld   (sound_latch_D50B),a
3458: CD 4D 36    call $364D
345B: 3A 4E 82    ld   a,(copy_of_dip_switches_1_824E)
345E: 0F          rrca
345F: 0F          rrca
3460: 0F          rrca
3461: E6 03       and  $03
3463: C6 02       add  a,$02
3465: 32 52 82    ld   (dsw_copy_nb_lives_per_play_8252),a
3468: 3A 4E 82    ld   a,(copy_of_dip_switches_1_824E)
346B: E6 03       and  $03
346D: 3C          inc  a
346E: 21 9D 34    ld   hl,table_34A0-3
3471: 23          inc  hl
3472: 23          inc  hl
3473: 23          inc  hl		; kind of hides table_34A0
3474: 3D          dec  a
3475: 20 FA       jr   nz,$3471
3477: 11 70 83    ld   de,$8370
347A: 01 03 00    ld   bc,$0003
347D: ED B0       ldir
347F: 3E DD       ld   a,$DD
3481: 32 45 82    ld   ($8245),a
3484: 21 46 82    ld   hl,execute_dynamic_ram_code_8246
3487: 77          ld   (hl),a
3488: 23          inc  hl
3489: 3E E9       ld   a,$E9
348B: 77          ld   (hl),a
348C: 01 1F 2F    ld   bc,$2F1F
348F: 21 48 82    ld   hl,$8248
3492: 71          ld   (hl),c
3493: 23          inc  hl
3494: 70          ld   (hl),b
3495: 21 00 87    ld   hl,$8700
3498: 06 A0       ld   b,$A0
349A: AF          xor  a
349B: 77          ld   (hl),a
349C: 23          inc  hl
349D: 10 FC       djnz $349B
349F: C9          ret

table_34A0:
	dc.b	00         
	dc.b	00         
	dc.b	01 00 50   
	dc.b	01 00 00   
	dc.b	02         
	dc.b	00         
	dc.b	50         
	dc.b	02         

rom_checksum_34AC:
34AC: 00          nop
34AD: 06 00       ld   b,$00
34AF: 60          ld   h,b
34B0: 68          ld   l,b
; checksum ROM 0-$8000
34B1: 7E          ld   a,(hl)
34B2: 80          add  a,b
34B3: 47          ld   b,a
34B4: 23          inc  hl
34B5: 7C          ld   a,h
34B6: EE 80       xor  $80
34B8: 32 0D D5    ld   (watchdog_d50d),a
; bootleg: code below patched
34BB: 20 F4       jr   nz,$34B1
34BD: A8          xor  b
34BE: C8          ret  z
; bootleg: by code below
34BB: 00          nop
34BC: 3E 00       ld   a,$00
34BE: C9          ret
; bootleg: end patched code
34BF: 21 E2 34    ld   hl,$34E2
34C2: 01 17 00    ld   bc,$0017
bad_hardware_34C5:
34C5: E5          push hl
34C6: C5          push bc
34C7: AF          xor  a
34C8: 32 36 82    ld   ($8236),a
34CB: CD E1 71    call check_if_must_flip_screen_71e1
34CE: 3E 01       ld   a,$01
34D0: 32 D9 81    ld   (menu_or_game_tiles_81D9),a
34D3: CD 0C 26    call init_hw_scroll_and_charset_260C
34D6: C1          pop  bc
34D7: E1          pop  hl
34D8: 11 84 C5    ld   de,$C584
34DB: ED B0       ldir
34DD: 32 0D D5    ld   (watchdog_d50d),a
34E0: 18 FB       jr   $34DD
34E2: 07          rlca
34E3: 00          nop
; bootleg: code replaced by the code below
34E4: 29          add  hl,hl
34E5: 1C          inc  e
34E6: 30 00       jr   nc,$34E8
34E8: 1F          rra
34E9: 2F          cpl
34EA: 20 00       jr   nz,$34EC
34EC: 10 10       djnz $34FE
34EE: 10 10       djnz $3500
34F0: 2B          dec  hl
34F1: 2A 17 27    ld   hl,($2717)
34F4: 27          daa
34F5: 27          daa
34F6: 2B          dec  hl
34F7: 00          nop
34F8: 08          ex   af,af'
34F9: 07          rlca
34FA: 00          nop
34FB: 29          add  hl,hl
; bootleg: end of original code, replacement code below
34E4: 3E 81       ld   a,$81
34E6: 32 0E D5    ld   ($D50E),a
34E9: C3 DE 73    jp   $73DE
; entrypoint for aux. bootleg routine where there was room for it
34EC: 3E 81       ld   a,$81
34EE: 32 0E D5    ld   ($D50E),a
34F1: C3 20 70    jp   $7020
34F4: 3E 01       ld   a,$01
34F6: 32 0E D5    ld   ($D50E),a
34F9: F1          pop  af
34FA: E1          pop  hl
34FB: C9          ret
; bootleg: end of replacement code
34FC: 1C          inc  e
34FD: 30 00       jr   nc,$34FF
34FF: 2B          dec  hl
3500: 26 00       ld   h,$00
3502: 08          ex   af,af'

; lifted from bootleg ROM
7020: 21 80 80    ld   hl,$8080                                       
7023: 4E          ld   c,(hl)                                         
7024: 09          add  hl,bc                                          
7025: E5          push hl                                             
7026: 21 FF 71    ld   hl,$71FF                                       
7029: 09          add  hl,bc                                          
702A: 7E          ld   a,(hl)                                         
702B: F5          push af                                             
702C: C3 F4 34    jp   $34F4                                          

cache_dip_switches_3503:
3503: 3A 0A D4    ld   a,(dip_switches_D40A)
3506: 2F          cpl			; active low?
3507: 32 4E 82    ld   (copy_of_dip_switches_1_824E),a		; main DSW (lives, skill...)
350A: 21 07 3F    ld   hl,$3F07
350D: 22 0E D4    ld   (dip_switches_D40E),hl
3510: 3E 0E       ld   a,$0E
3512: 32 0E D4    ld   (dip_switches_D40E),a
3515: 3A 0F D4    ld   a,(dip_switches_D40F)
3518: 2F          cpl
3519: 32 4F 82    ld   (copy_of_dip_switches_2_824F),a		; other DSW (coinage...)
351C: 3E 0F       ld   a,$0F
351E: 32 0E D4    ld   (dip_switches_D40E),a
3521: 3A 0F D4    ld   a,(dip_switches_D40F)
3524: 2F          cpl
3525: 32 50 82    ld   (copy_of_dip_switches_3_8250),a		; other DSW (coinage...)
3528: C9          ret

3529: CD EE 2D    call $2DEE
352C: 3E 00       ld   a,$00
352E: 32 3B 82    ld   (game_in_play_flag_823B),a
3531: 3A 4A 82    ld   a,($824A)
3534: B7          or   a
3535: 20 10       jr   nz,$3547
3537: CD D5 76    call $76D5
353A: CD 70 4D    call player_arriving_on_roof_anim_4d70
353D: 3E 01       ld   a,$01
353F: 32 4A 82    ld   ($824A),a
3542: CD 9E 75    call start_level_759e
3545: 18 09       jr   $3550
3547: CD D5 76    call $76D5
354A: CD 3F 36    call start_music_if_in_game_363f
354D: CD 9B 75    call start_next_level_759B
3550: B7          or   a
3551: 28 3F       jr   z,$3592
3553: 3A 34 82    ld   a,(nb_lives_8234)
3556: B7          or   a
3557: FA 6C 35    jp   m,$356C
355A: 3A 35 82    ld   a,($8235)
355D: 3D          dec  a
355E: 28 D1       jr   z,$3531
3560: 3A 53 82    ld   a,($8253)
3563: B7          or   a
3564: FA 31 35    jp   m,$3531
3567: CD 9E 35    call switch_players_data_359e
356A: 18 C5       jr   $3531
356C: AF          xor  a
356D: 32 46 86    ld   ($8646),a
3570: CD C7 76    call $76C7
3573: 3A 35 82    ld   a,($8235)
3576: 3D          dec  a
3577: C8          ret  z
3578: CD 9E 35    call switch_players_data_359e
357B: 3A 34 82    ld   a,(nb_lives_8234)
357E: B7          or   a
357F: F2 31 35    jp   p,$3531
3582: 3A 36 82    ld   a,($8236)
3585: B7          or   a
3586: C4 9E 35    call nz,switch_players_data_359e
3589: 3E 01       ld   a,$01
358B: 32 46 86    ld   ($8646),a
358E: CD C7 76    call $76C7
3591: C9          ret

3592: CD 3E 2A    call init_level_skill_params_2A2E
3595: CD 00 27    call init_building_2700
3598: CD 65 2A    call init_elevators_2a65
359B: C3 47 35    jp   $3547

switch_players_data_359e:
359E: 3A 36 82    ld   a,($8236)
35A1: EE 01       xor  $01
35A3: 32 36 82    ld   ($8236),a
35A6: 21 53 82    ld   hl,$8253
35A9: 11 34 82    ld   de,nb_lives_8234
35AC: CD 13 36    call swap_memory_increase_pointers_3613
35AF: 11 4D 83    ld   de,$834D
35B2: CD 1B 36    call $361B
35B5: 11 4A 82    ld   de,$824A
35B8: CD 13 36    call swap_memory_increase_pointers_3613
35BB: 11 73 83    ld   de,$8373
35BE: CD 13 36    call swap_memory_increase_pointers_3613
35C1: 11 37 82    ld   de,skill_level_8237
35C4: CD 13 36    call swap_memory_increase_pointers_3613
35C7: 11 2C 80    ld   de,$802C
35CA: CD 13 36    call swap_memory_increase_pointers_3613
35CD: 11 31 82    ld   de,level_timer_16bit_8231
35D0: CD 13 36    call swap_memory_increase_pointers_3613
35D3: CD 13 36    call swap_memory_increase_pointers_3613
35D6: 11 33 82    ld   de,$8233
35D9: CD 13 36    call swap_memory_increase_pointers_3613
35DC: 11 00 80    ld   de,$8000
35DF: CD 13 36    call swap_memory_increase_pointers_3613
35E2: 11 4C 83    ld   de,$834C
35E5: CD 13 36    call swap_memory_increase_pointers_3613
35E8: 11 ED 82    ld   de,$82ED
35EB: CD 13 36    call swap_memory_increase_pointers_3613
35EE: 11 CE 81    ld   de,$81CE
35F1: CD 23 36    call $3623
35F4: 11 2D 80    ld   de,$802D
35F7: CD 13 36    call swap_memory_increase_pointers_3613
35FA: 11 83 83    ld   de,$8383
35FD: CD 2F 36    call $362F
3600: 11 DA 81    ld   de,$81DA
3603: CD 27 36    call $3627
3606: 11 10 82    ld   de,red_door_position_array_8210
3609: CD 2B 36    call $362B
360C: 11 F1 81    ld   de,$81F1
360F: CD 2B 36    call $362B
3612: C9          ret

; < HL,DE
; swaps memory pointed by addresses, then increases HL and DE
swap_memory_increase_pointers_3613:
3613: 1A          ld   a,(de)
3614: 4E          ld   c,(hl)
3615: 77          ld   (hl),a
3616: 79          ld   a,c
3617: 12          ld   (de),a
3618: 23          inc  hl
3619: 13          inc  de
361A: C9          ret

361B: 06 03       ld   b,$03
361D: CD 13 36    call swap_memory_increase_pointers_3613
3620: 10 FB       djnz $361D
3622: C9          ret
3623: 06 08       ld   b,$08
3625: 18 F6       jr   $361D
3627: 06 17       ld   b,$17
3629: 18 F2       jr   $361D
362B: 06 1F       ld   b,$1F
362D: 18 EE       jr   $361D
362F: 06 0A       ld   b,$0A
3631: C5          push bc
3632: CD 13 36    call swap_memory_increase_pointers_3613
3635: 01 07 00    ld   bc,$0007
3638: EB          ex   de,hl
3639: 09          add  hl,bc
363A: EB          ex   de,hl
363B: C1          pop  bc
363C: 10 F3       djnz $3631
363E: C9          ret

start_music_if_in_game_363f:
363F: 3A 3B 82    ld   a,(game_in_play_flag_823B)
3642: B7          or   a
3643: C0          ret  nz
3644: CD B7 46    call increase_difficulty_if_late_46b7
3647: 00          nop
3648: 00          nop
3649: CD D2 64    call l_64D2
364C: C9          ret

364D: 3E 80       ld   a,$80
364F: 32 79 87    ld   ($8779),a
3652: CD D2 64    call l_64D2
3655: C9          ret

play_sound_3656:
3656: 47          ld   b,a
3657: 3A 3B 82    ld   a,(game_in_play_flag_823B)
365A: B7          or   a
365B: C0          ret  nz
; plays sound only if real game (not demo)
365C: 78          ld   a,b
365D: 32 0B D5    ld   (sound_latch_D50B),a
3660: C9          ret

3661: DD 7E 06    ld   a,(ix+character_situation_06)
3664: B7          or   a
3665: C2 6B 36    jp   nz,$366B
; character on ground
3668: C3 C5 46    jp   $46C5

366B: CD CE 62    call load_character_elevator_structure_62CE
366E: FD 46 01    ld   b,(iy+current_floor_01)        ; 83CE: elevator current floor
3671: DD 7E 03    ld   a,(ix+character_y_offset_03)
3674: FD 86 00    add  a,(iy+$00)
3677: FE 30       cp   $30
3679: 30 01       jr   nc,$367C
367B: 05          dec  b
367C: 78          ld   a,b
367D: DD 86 06    add  a,(ix+character_situation_06)
3680: 47          ld   b,a
3681: DD 7E 08    ld   a,(ix+$08)
3684: E6 80       and  $80
3686: 28 02       jr   z,$368A
3688: 05          dec  b
3689: 05          dec  b
368A: DD 70 07    ld   (ix+$07),b		; set current floor for current elevator?
368D: CD E9 37    call $37E9
3690: DD 7E 09    ld   a,(ix+$09)
3693: FE 05       cp   $05
3695: C8          ret  z
3696: DD 46 00    ld   b,(ix+$00)
3699: DD 4E 01    ld   c,(ix+$01)
369C: FD 56 04    ld   d,(iy+$04)
369F: FD 5E 05    ld   e,(iy+$05)
36A2: 7B          ld   a,e
36A3: 91          sub  c
36A4: 67          ld   h,a
36A5: DA DA 36    jp   c,$36DA
36A8: 78          ld   a,b
36A9: 92          sub  d
36AA: 67          ld   h,a
36AB: DA 1A 37    jp   c,$371A
36AE: DD 7E 06    ld   a,(ix+character_situation_06)
36B1: 3D          dec  a
36B2: C8          ret  z
; not in elevator
36B3: 78          ld   a,b
36B4: 81          add  a,c
36B5: 92          sub  d
36B6: 93          sub  e
36B7: F2 C3 36    jp   p,$36C3
36BA: 7A          ld   a,d
36BB: C6 0A       add  a,$0A
36BD: 91          sub  c
36BE: 67          ld   h,a
36BF: DA CC 36    jp   c,$36CC
36C2: C9          ret
36C3: 78          ld   a,b
36C4: C6 0A       add  a,$0A
36C6: 93          sub  e
36C7: 67          ld   h,a
36C8: DA D3 36    jp   c,$36D3
36CB: C9          ret
36CC: DD 36 11 03 ld   (ix+$11),$03
36D0: C3 5A 37    jp   $375A
36D3: DD 36 11 03 ld   (ix+$11),$03
36D7: C3 65 37    jp   $3765
36DA: DD 7E 09    ld   a,(ix+$09)
36DD: FE 08       cp   $08
36DF: CA 5A 37    jp   z,$375A
36E2: DD 7E 05    ld   a,(ix+character_delta_x_05)
36E5: B7          or   a
36E6: CA 5A 37    jp   z,$375A
36E9: F8          ret  m
36EA: DD 7E 07    ld   a,(ix+$07)
36ED: FE 1F       cp   $1F
36EF: CA 13 37    jp   z,$3713
36F2: D9          exx
36F3: DD 46 02    ld   b,(ix+character_fine_y_offset_02)
36F6: DD 4E 03    ld   c,(ix+character_y_offset_03)
36F9: FD 56 00    ld   d,(iy+$00)
36FC: 78          ld   a,b
36FD: 82          add  a,d
36FE: FE 30       cp   $30
3700: DA 70 37    jp   c,$3770
3703: FD 7E 01    ld   a,(iy+$01)
3706: FE 1E       cp   $1E
3708: CA 12 37    jp   z,$3712
370B: 79          ld   a,c
370C: 82          add  a,d
370D: FE 34       cp   $34
370F: D2 78 37    jp   nc,$3778
3712: D9          exx
3713: DD 36 11 04 ld   (ix+$11),$04
3717: C3 5A 37    jp   $375A
371A: DD 7E 09    ld   a,(ix+$09)
371D: FE 08       cp   $08
371F: CA 65 37    jp   z,$3765
3722: DD 7E 05    ld   a,(ix+character_delta_x_05)
3725: B7          or   a
3726: CA 65 37    jp   z,$3765
3729: F0          ret  p
372A: DD 7E 07    ld   a,(ix+$07)
372D: FE 1F       cp   $1F
372F: CA 53 37    jp   z,$3753
3732: D9          exx
3733: DD 46 02    ld   b,(ix+character_fine_y_offset_02)
3736: DD 4E 03    ld   c,(ix+character_y_offset_03)
3739: FD 56 00    ld   d,(iy+$00)
373C: 78          ld   a,b
373D: 82          add  a,d
373E: FE 30       cp   $30
3740: DA 70 37    jp   c,$3770
3743: DD 7E 07    ld   a,(ix+$07)
3746: FE 1E       cp   $1E
3748: CA 52 37    jp   z,$3752
374B: 79          ld   a,c
374C: 82          add  a,d
374D: FE 34       cp   $34
374F: D2 78 37    jp   nc,$3778
3752: D9          exx
3753: DD 36 11 04 ld   (ix+$11),$04
3757: C3 65 37    jp   $3765
375A: 78          ld   a,b
375B: 84          add  a,h
375C: DD 77 00    ld   (ix+character_x_00),a
375F: 79          ld   a,c
3760: 84          add  a,h
3761: DD 77 01    ld   (ix+character_x_right_01),a
3764: C9          ret
3765: 78          ld   a,b
3766: 94          sub  h
3767: DD 77 00    ld   (ix+character_x_00),a
376A: 79          ld   a,c
376B: 94          sub  h
376C: DD 77 01    ld   (ix+character_x_right_01),a
376F: C9          ret
3770: 79          ld   a,c
3771: 82          add  a,d
3772: 4F          ld   c,a
3773: 16 FF       ld   d,$FF
3775: C3 80 37    jp   $3780
3778: D6 30       sub  $30
377A: 4F          ld   c,a
377B: 16 00       ld   d,$00
377D: C3 80 37    jp   $3780
3780: FD 7E 01    ld   a,(iy+$01)
3783: DD 86 06    add  a,(ix+$06)
3786: 82          add  a,d
3787: 47          ld   b,a
3788: DD 7E 08    ld   a,(ix+$08)
378B: 17          rla
378C: 17          rla
378D: E6 01       and  $01
378F: 87          add  a,a
3790: ED 44       neg
3792: 80          add  a,b
3793: DD 77 07    ld   (ix+$07),a
3796: DD 36 06 00 ld   (ix+$06),$00
379A: C3 9D 37    jp   $379D
379D: DD 7E 09    ld   a,(ix+$09)
37A0: FE 07       cp   $07
37A2: 20 04       jr   nz,$37A8
37A4: CD D4 37    call $37D4
37A7: C9          ret
37A8: DD 36 09 03 ld   (ix+$09),$03
37AC: 06 05       ld   b,$05
37AE: 21 ED 44    ld   hl,$44ED
37B1: 11 04 00    ld   de,$0004
37B4: 79          ld   a,c
37B5: BE          cp   (hl)
37B6: D2 BF 37    jp   nc,$37BF
37B9: 19          add  hl,de
37BA: 10 F9       djnz $37B5
37BC: 21 05 45    ld   hl,$4505
37BF: 2B          dec  hl
37C0: 7E          ld   a,(hl)
37C1: DD 77 02    ld   (ix+character_fine_y_offset_02),a
37C4: 23          inc  hl
37C5: 7E          ld   a,(hl)
37C6: DD 77 03    ld   (ix+character_y_offset_03),a
37C9: 23          inc  hl
37CA: 7E          ld   a,(hl)
37CB: DD 77 0C    ld   (ix+$0c),a
37CE: 23          inc  hl
37CF: 7E          ld   a,(hl)
37D0: DD 77 0A    ld   (ix+$0a),a
37D3: C9          ret
37D4: 79          ld   a,c
37D5: FE 06       cp   $06
37D7: 30 02       jr   nc,$37DB
37D9: 0E 06       ld   c,$06
37DB: 79          ld   a,c
37DC: DD 96 03    sub  (ix+character_y_offset_03)
37DF: DD 86 02    add  a,(ix+character_fine_y_offset_02)
37E2: DD 77 02    ld   (ix+character_fine_y_offset_02),a
37E5: DD 71 03    ld   (ix+character_y_offset_03),c
37E8: C9          ret

37E9: DD 7E 06    ld   a,(ix+character_situation_06)
37EC: 3D          dec  a
37ED: C8          ret  z
; not in elevator
37EE: DD 7E 08    ld   a,(ix+associated_elevator_08)
37F1: E6 80       and  $80
37F3: C0          ret  nz
37F4: FD 7E 02    ld   a,(iy+$02)
37F7: FD 96 01    sub  (iy+$01)
37FA: FE 02       cp   $02
37FC: D0          ret  nc
37FD: FD 7E 00    ld   a,(iy+$00)
3800: DD 86 02    add  a,(ix+$02)
3803: FE 30       cp   $30
3805: D8          ret  c
3806: DD 36 09 06 ld   (ix+enemy_state_09),$06
380A: DD 36 0A 00 ld   (ix+$0a),$00
380E: 3A BA 85    ld   a,(current_enemy_index_85BA)
3811: B7          or   a
3812: 28 16       jr   z,$382A
3814: 3E 02       ld   a,$02
3816: 32 EC 82    ld   ($82EC),a
3819: 3A 20 85    ld   a,($8520)
381C: 3D          dec  a
381D: C0          ret  nz
381E: 3A 22 85    ld   a,(player_structure_851A+8)
3821: DD AE 08    xor  (ix+$08)
3824: E6 7F       and  $7F
3826: CC E7 56    call z,$56E7
3829: C9          ret

382A: 3E 02       ld   a,$02
382C: 32 EB 82    ld   ($82EB),a
382F: C9          ret
3830: DD 7E 0A    ld   a,(ix+$0a)
3833: B7          or   a
3834: CA 76 38    jp   z,$3876
3837: FE 01       cp   $01
3839: CA 80 38    jp   z,$3880
383C: DD 34 0A    inc  (ix+$0a)
383F: 47          ld   b,a
3840: 0E 11       ld   c,$11
3842: 3A BA 85    ld   a,(current_enemy_index_85BA)
3845: B7          or   a
3846: C2 4B 38    jp   nz,$384B
3849: 0E 28       ld   c,$28
384B: 78          ld   a,b
384C: B9          cp   c
384D: DA 84 38    jp   c,$3884
3850: 47          ld   b,a
3851: 3A BA 85    ld   a,(current_enemy_index_85BA)
3854: B7          or   a
3855: C2 5E 38    jp   nz,$385E
3858: 78          ld   a,b
3859: FE 3C       cp   $3C
385B: DA 8B 38    jp   c,$388B
385E: 3E FF       ld   a,$FF
3860: DD 77 09    ld   (ix+$09),a
3863: DD 77 04    ld   (ix+$04),a
3866: 3A 75 83    ld   a,($8375)
3869: DD 77 10    ld   (ix+$10),a
386C: 2A BF 85    ld   hl,($85BF)
386F: 77          ld   (hl),a
3870: 11 05 00    ld   de,$0005
3873: 19          add  hl,de
3874: 77          ld   (hl),a
3875: C9          ret
3876: CD 8F 38    call $388F
3879: CD E1 3A    call $3AE1
387C: CD 48 39    call $3948
387F: C9          ret
3880: CD BB 38    call $38BB
3883: C9          ret
3884: CD E2 38    call $38E2
3887: CD 48 39    call $3948
388A: C9          ret
388B: CD 48 39    call $3948
388E: C9          ret
388F: DD 36 0C 05 ld   (ix+$0c),$05
3893: DD 34 0A    inc  (ix+$0a)
3896: DD 7E 02    ld   a,(ix+$02)
3899: D6 0F       sub  $0F
389B: DA A4 38    jp   c,$38A4
389E: DD 77 03    ld   (ix+character_y_offset_03),a
38A1: C3 AC 38    jp   $38AC
38A4: DD 36 02 15 ld   (ix+$02),$15
38A8: DD 36 03 06 ld   (ix+character_y_offset_03),$06
38AC: DD 7E 06    ld   a,(ix+character_situation_06)
38AF: B7          or   a
38B0: C2 B7 38    jp   nz,$38B7
; character on ground
38B3: CD B4 39    call $39B4
38B6: C9          ret
; not on ground (elevator, stairs ...)
38B7: CD B5 3A    call $3AB5
38BA: C9          ret
38BB: 3E 0B       ld   a,$0B
38BD: DD 96 0C    sub  (ix+$0c)
38C0: DD 77 0C    ld   (ix+$0c),a
38C3: DD 7E 03    ld   a,(ix+character_y_offset_03)
38C6: D6 04       sub  $04
38C8: FE 07       cp   $07
38CA: D2 D9 38    jp   nc,$38D9
38CD: DD 36 03 06 ld   (ix+character_y_offset_03),$06
38D1: DD 36 02 15 ld   (ix+$02),$15
38D5: DD 34 0A    inc  (ix+$0a)
38D8: C9          ret
38D9: DD 77 03    ld   (ix+character_y_offset_03),a
38DC: C6 0F       add  a,$0F
38DE: DD 77 02    ld   (ix+$02),a
38E1: C9          ret
38E2: E6 FC       and  $FC
38E4: CB 3F       srl  a
38E6: CB 3F       srl  a
38E8: 6F          ld   l,a
38E9: 26 00       ld   h,$00
38EB: CD 00 39    call select_proper_table_3900
38EE: 19          add  hl,de
38EF: DD 7E 0C    ld   a,(ix+$0c)
38F2: FE 0D       cp   $0D
38F4: 28 05       jr   z,$38FB
38F6: 7E          ld   a,(hl)
38F7: DD 77 0C    ld   (ix+$0c),a
38FA: C9          ret
38FB: DD 36 04 FF ld   (ix+$04),$FF
38FF: C9          ret

select_proper_table_3900:
3900: 3A BA 85    ld   a,(current_enemy_index_85BA)
3903: B7          or   a
3904: 20 0D       jr   nz,$3913
3906: 11 20 39    ld   de,table_3920
3909: DD 7E 09    ld   a,(ix+$09)
390C: FE 05       cp   $05
390E: C8          ret  z
390F: 11 34 39    ld   de,$3934
3912: C9          ret
3913: 11 2C 39    ld   de,$392C
3916: DD 7E 09    ld   a,(ix+$09)
3919: FE 05       cp   $05
391B: C8          ret  z
391C: 11 40 39    ld   de,$3940
391F: C9          ret

table_3920:
	dc.b	04
	dc.b	03
	dc.b	05
	dc.b	0A
	dc.b	0A
	dc.b	05
	dc.b	0A
	dc.b	05
	dc.b	0A
	dc.b	0D
	dc.b	0D
	dc.b	0D
	dc.b	04
	dc.b	03
	dc.b	05
	dc.b	0A
	dc.b	0D
	dc.b	0D
	dc.b	0D
	dc.b	0D
	dc.b	04
	dc.b	0B
	dc.b	0B
	dc.b	0B
	dc.b	0C
	dc.b	0C
	dc.b	0C
	dc.b	0C
	dc.b	0D
	dc.b	0D
	dc.b	0D
	dc.b	0D
	dc.b	04
	dc.b	0B
	dc.b	0B
	dc.b	0C
	dc.b	0D
	dc.b	0D
	dc.b	0D
	dc.b	0D
	
3948: DD 7E 04    ld   a,(ix+$04)
394B: 3C          inc  a
394C: C8          ret  z
394D: DD 7E 06    ld   a,(ix+character_situation_06)
3950: B7          or   a
3951: CA 7F 39    jp   z,character_on_ground_397F
3954: FE 02       cp   CS_ABOVE_ELEVATOR_02
3956: C0          ret  nz
; character above elevator
3957: DD 7E 08    ld   a,(ix+$08)
395A: E6 80       and  $80
395C: C0          ret  nz
395D: CD CE 62    call load_character_elevator_structure_62CE
3960: FD 7E 02    ld   a,(iy+$02)
3963: FD 96 01    sub  (iy+$01)
3966: FE 02       cp   $02
3968: D0          ret  nc
3969: FD 7E 00    ld   a,(iy+$00)
396C: DD 86 02    add  a,(ix+$02)
396F: FE 30       cp   $30
3971: D8          ret  c
3972: CD A7 39    call $39A7
3975: 36 FE       ld   (hl),$FE
3977: DD 36 09 06 ld   (ix+$09),$06
397B: CD 07 3B    call $3B07
397E: C9          ret

character_on_ground_397F:
397F: DD 7E 08    ld   a,(ix+$08)
3982: FE 0C       cp   $0C
3984: C8          ret  z
3985: CD CE 62    call load_character_elevator_structure_62CE
3988: FD 7E 06    ld   a,(iy+$06)
398B: 87          add  a,a
398C: DD 86 07    add  a,(ix+$07)
398F: FD 96 01    sub  (iy+$01)
3992: D8          ret  c
3993: DD 7E 02    ld   a,(ix+$02)
3996: FD 96 00    sub  (iy+$00)
3999: D8          ret  c
399A: CD A7 39    call $39A7
399D: 36 02       ld   (hl),$02
399F: DD 36 09 06 ld   (ix+$09),$06
39A3: CD 07 3B    call $3B07
39A6: C9          ret
39A7: DD 7E 08    ld   a,(ix+$08)
39AA: E6 7F       and  $7F
39AC: 6F          ld   l,a
39AD: 26 00       ld   h,$00
39AF: 11 97 80    ld   de,$8097
39B2: 19          add  hl,de
39B3: C9          ret
39B4: DD 36 08 0C ld   (ix+$08),$0C
39B8: DD 36 05 00 ld   (ix+character_delta_x_05),$00
39BC: CD AD 4A    call $4AAD
39BF: DD 46 00    ld   b,(ix+character_x_00)
39C2: DD 4E 01    ld   c,(ix+character_x_right_01)
39C5: 16 0B       ld   d,$0B
39C7: 78          ld   a,b
39C8: BE          cp   (hl)
39C9: DA D2 39    jp   c,$39D2
39CC: 23          inc  hl
39CD: 56          ld   d,(hl)
39CE: 23          inc  hl
39CF: C3 C8 39    jp   $39C8
39D2: 5E          ld   e,(hl)
39D3: 23          inc  hl
39D4: 7B          ld   a,e
39D5: 3D          dec  a
39D6: 91          sub  c
39D7: DA E4 39    jp   c,$39E4
39DA: DD 72 08    ld   (ix+$08),d
39DD: 7A          ld   a,d
39DE: FE 0C       cp   $0C
39E0: C2 08 3A    jp   nz,$3A08
39E3: C9          ret
39E4: 7A          ld   a,d
39E5: FE 0B       cp   $0B
39E7: 38 36       jr   c,$3A1F
39E9: 7E          ld   a,(hl)
39EA: FE 0B       cp   $0B
39EC: 38 31       jr   c,$3A1F
39EE: FE 0C       cp   $0C
39F0: CA FE 39    jp   z,$39FE
39F3: 7B          ld   a,e
39F4: 3D          dec  a
39F5: DD 77 01    ld   (ix+character_x_right_01),a
39F8: D6 08       sub  $08
39FA: DD 77 00    ld   (ix+character_x_00),a
39FD: C9          ret
39FE: 7B          ld   a,e
39FF: DD 77 00    ld   (ix+character_x_00),a
3A02: C6 08       add  a,$08
3A04: DD 77 01    ld   (ix+character_x_right_01),a
3A07: C9          ret
3A08: CD CE 62    call load_character_elevator_structure_62CE
3A0B: FD 7E 03    ld   a,(iy+$03)
3A0E: DD BE 07    cp   (ix+$07)
3A11: C8          ret  z
3A12: DD 36 09 00 ld   (ix+$09),$00
3A16: DD 36 0A 00 ld   (ix+$0a),$00
3A1A: DD 36 06 03 ld   (ix+character_situation_06),CS_FALLING_03
3A1E: C9          ret
3A1F: DD 77 08    ld   (ix+$08),a
3A22: CD CE 62    call load_character_elevator_structure_62CE
3A25: DD 7E 07    ld   a,(ix+$07)
3A28: FD BE 03    cp   (iy+$03)
3A2B: 28 1E       jr   z,$3A4B
3A2D: 47          ld   b,a
3A2E: FD 7E 01    ld   a,(iy+$01)
3A31: 3C          inc  a
3A32: B8          cp   b
3A33: 38 48       jr   c,$3A7D
3A35: 78          ld   a,b
3A36: FD 86 06    add  a,(iy+$06)
3A39: FD 86 06    add  a,(iy+$06)
3A3C: FD BE 01    cp   (iy+$01)
3A3F: 38 3C       jr   c,$3A7D
3A41: 20 08       jr   nz,$3A4B
3A43: DD 7E 02    ld   a,(ix+$02)
3A46: FD BE 00    cp   (iy+$00)
3A49: 38 32       jr   c,$3A7D
3A4B: DD 36 08 0C ld   (ix+$08),$0C
3A4F: DD 7E 00    ld   a,(ix+character_x_00)
3A52: DD 86 01    add  a,(ix+character_x_right_01)
3A55: CB 1F       rr   a
3A57: 47          ld   b,a
3A58: FD 7E 05    ld   a,(iy+$05)
3A5B: FD 86 04    add  a,(iy+character_state_04)
3A5E: CB 1F       rr   a
3A60: B8          cp   b
3A61: 38 0D       jr   c,$3A70
3A63: FD 7E 04    ld   a,(iy+character_state_04)
3A66: 3D          dec  a
3A67: DD 77 01    ld   (ix+character_x_right_01),a
3A6A: D6 08       sub  $08
3A6C: DD 77 00    ld   (ix+character_x_00),a
3A6F: C9          ret
3A70: FD 7E 05    ld   a,(iy+$05)
3A73: 3C          inc  a
3A74: DD 77 00    ld   (ix+character_x_00),a
3A77: C6 08       add  a,$08
3A79: DD 77 01    ld   (ix+character_x_right_01),a
3A7C: C9          ret
3A7D: DD 36 09 00 ld   (ix+$09),$00
3A81: DD 36 0A 00 ld   (ix+$0a),$00
3A85: DD 36 06 03 ld   (ix+character_situation_06),CS_FALLING_03
3A89: DD 7E 00    ld   a,(ix+character_x_00)
3A8C: DD 86 01    add  a,(ix+character_x_right_01)
3A8F: CB 1F       rr   a
3A91: 47          ld   b,a
3A92: FD 7E 05    ld   a,(iy+$05)
3A95: FD 86 04    add  a,(iy+character_state_04)
3A98: CB 1F       rr   a
3A9A: B8          cp   b
3A9B: 30 0C       jr   nc,$3AA9
3A9D: FD 7E 05    ld   a,(iy+$05)
3AA0: DD 77 01    ld   (ix+character_x_right_01),a
3AA3: D6 08       sub  $08
3AA5: DD 77 00    ld   (ix+character_x_00),a
3AA8: C9          ret
3AA9: FD 7E 04    ld   a,(iy+character_state_04)
3AAC: DD 77 00    ld   (ix+character_x_00),a
3AAF: C6 08       add  a,$08
3AB1: DD 77 01    ld   (ix+character_x_right_01),a
3AB4: C9          ret
3AB5: DD 36 05 00 ld   (ix+character_delta_x_05),$00
3AB9: CD CE 62    call load_character_elevator_structure_62CE
3ABC: DD 7E 00    ld   a,(ix+character_x_00)
3ABF: FD BE 04    cp   (iy+character_state_04)
3AC2: DA D5 3A    jp   c,$3AD5
3AC5: FD 7E 05    ld   a,(iy+$05)
3AC8: DD BE 01    cp   (ix+character_x_right_01)
3ACB: D0          ret  nc
3ACC: DD 77 01    ld   (ix+character_x_right_01),a
3ACF: D6 08       sub  $08
3AD1: DD 77 00    ld   (ix+character_x_00),a
3AD4: C9          ret
3AD5: FD 7E 04    ld   a,(iy+character_state_04)
3AD8: DD 77 00    ld   (ix+character_x_00),a
3ADB: C6 08       add  a,$08
3ADD: DD 77 01    ld   (ix+character_x_right_01),a
3AE0: C9          ret
3AE1: 3A BA 85    ld   a,(current_enemy_index_85BA)
3AE4: B7          or   a
3AE5: 28 10       jr   z,$3AF7
3AE7: 3A EC 82    ld   a,($82EC)
3AEA: B7          or   a
3AEB: C8          ret  z
3AEC: 3D          dec  a
3AED: 32 EC 82    ld   ($82EC),a
3AF0: C8          ret  z
3AF1: 3E C9       ld   a,$C9
3AF3: CD 56 36    call play_sound_3656
3AF6: C9          ret
3AF7: 3A EB 82    ld   a,($82EB)
3AFA: B7          or   a
3AFB: C8          ret  z
3AFC: 3D          dec  a
3AFD: 32 EB 82    ld   ($82EB),a
3B00: C8          ret  z
3B01: 3E C5       ld   a,$C5		; player crushed by elevator
3B03: CD 56 36    call play_sound_3656
3B06: C9          ret

3B07: 3A BA 85    ld   a,(current_enemy_index_85BA)
3B0A: B7          or   a
3B0B: 28 0F       jr   z,$3B1C
3B0D: 3A EC 82    ld   a,($82EC)
3B10: B7          or   a
3B11: C0          ret  nz
3B12: 3C          inc  a
3B13: 32 EC 82    ld   ($82EC),a
3B16: 3E C9       ld   a,$C9
3B18: CD 56 36    call play_sound_3656
3B1B: C9          ret
3B1C: 3A EB 82    ld   a,($82EB)
3B1F: B7          or   a
3B20: C0          ret  nz
3B21: 3C          inc  a
3B22: 32 EB 82    ld   ($82EB),a
3B25: 3E C5       ld   a,$C5
3B27: CD 56 36    call play_sound_3656
3B2A: C9          ret
3B2B: CD 9A 3B    call $3B9A
3B2E: DD 34 0A    inc  (ix+$0a)
3B31: CD A7 3B    call $3BA7
3B34: CD BB 3B    call $3BBB
3B37: CD CE 62    call load_character_elevator_structure_62CE
3B3A: FD 7E 01    ld   a,(iy+$01)
3B3D: DD 96 07    sub  (ix+$07)
3B40: D2 62 3B    jp   nc,$3B62
3B43: 06 00       ld   b,$00
3B45: ED 44       neg
3B47: 3D          dec  a
3B48: CA 52 3B    jp   z,$3B52
3B4B: FA 5C 3B    jp   m,$3B5C
3B4E: 06 30       ld   b,$30
3B50: 3D          dec  a
3B51: C0          ret  nz
3B52: 78          ld   a,b
3B53: DD 86 03    add  a,(ix+character_y_offset_03)
3B56: FD 96 00    sub  (iy+$00)
3B59: D6 06       sub  $06
3B5B: F0          ret  p
3B5C: DD 36 06 02 ld   (ix+character_situation_06),CS_ABOVE_ELEVATOR_02
3B60: 18 11       jr   $3B73
3B62: DD 7E 07    ld   a,(ix+$07)
3B65: FD BE 03    cp   (iy+$03)
3B68: C0          ret  nz
3B69: DD 7E 03    ld   a,(ix+character_y_offset_03)
3B6C: FE 06       cp   $06
3B6E: D0          ret  nc
3B6F: DD 36 06 00 ld   (ix+character_situation_06),CS_ON_GROUND_00
3B73: DD 36 03 06 ld   (ix+character_y_offset_03),$06
3B77: DD 36 02 15 ld   (ix+$02),$15
3B7B: DD 36 09 05 ld   (ix+$09),$05
3B7F: DD 36 0A 00 ld   (ix+$0a),$00
3B83: 3A BA 85    ld   a,(current_enemy_index_85BA)
3B86: B7          or   a
3B87: 28 06       jr   z,$3B8F
3B89: 3E 01       ld   a,$01
3B8B: 32 EC 82    ld   ($82EC),a
3B8E: C9          ret
3B8F: 3E 01       ld   a,$01
3B91: 32 EB 82    ld   ($82EB),a
3B94: 3E C4       ld   a,$C4
3B96: CD 56 36    call play_sound_3656
3B99: C9          ret
3B9A: 3A BA 85    ld   a,(current_enemy_index_85BA)
3B9D: DD B6 0A    or   (ix+$0a)
3BA0: C0          ret  nz
3BA1: 3E C3       ld   a,$C3		; player falling sound
3BA3: CD 56 36    call play_sound_3656
3BA6: C9          ret
3BA7: DD 7E 0A    ld   a,(ix+$0a)
3BAA: 1F          rra
3BAB: 47          ld   b,a
3BAC: E6 01       and  $01
3BAE: C6 05       add  a,$05
3BB0: DD 77 0C    ld   (ix+$0c),a
3BB3: 78          ld   a,b
3BB4: 1F          rra
3BB5: E6 01       and  $01
3BB7: DD 77 0B    ld   (ix+$0b),a
3BBA: C9          ret
3BBB: DD 7E 03    ld   a,(ix+character_y_offset_03)
3BBE: D6 06       sub  $06
3BC0: D2 D1 3B    jp   nc,$3BD1
3BC3: C6 30       add  a,$30
3BC5: DD 77 03    ld   (ix+character_y_offset_03),a
3BC8: C6 0F       add  a,$0F
3BCA: DD 77 02    ld   (ix+$02),a
3BCD: DD 35 07    dec  (ix+$07)
3BD0: C9          ret
3BD1: DD 77 03    ld   (ix+character_y_offset_03),a
3BD4: C6 0F       add  a,$0F
3BD6: DD 77 02    ld   (ix+$02),a
3BD9: C9          ret
3BDA: DD 7E 09    ld   a,(ix+$09)
3BDD: B7          or   a
3BDE: C2 26 3C    jp   nz,$3C26
3BE1: 3A BA 85    ld   a,(current_enemy_index_85BA)
3BE4: B7          or   a
3BE5: C2 26 3C    jp   nz,$3C26
3BE8: CD 2A 3C    call $3C2A
3BEB: 79          ld   a,c
3BEC: FE 08       cp   $08
3BEE: CA 26 3C    jp   z,$3C26
3BF1: DD 71 08    ld   (ix+$08),c
3BF4: CD BB 3D    call $3DBB
3BF7: 79          ld   a,c
3BF8: DD BE 0B    cp   (ix+$0b)
3BFB: CA 26 3C    jp   z,$3C26
3BFE: 79          ld   a,c
3BFF: 0E F7       ld   c,$F7
3C01: B7          or   a
3C02: CA 07 3C    jp   z,$3C07
3C05: 0E 09       ld   c,$09
3C07: 80          add  a,b
3C08: 81          add  a,c
3C09: 47          ld   b,a
3C0A: C6 07       add  a,$07
3C0C: 4F          ld   c,a
3C0D: DD 7E 00    ld   a,(ix+character_x_00)
3C10: B8          cp   b
3C11: DA 26 3C    jp   c,$3C26
3C14: B9          cp   c
3C15: D2 26 3C    jp   nc,$3C26
3C18: DD 36 06 05 ld   (ix+character_situation_06),CS_IN_ROOM_05
3C1C: AF          xor  a
3C1D: DD 36 0A 00 ld   (ix+$0a),$00
3C21: DD 36 04 00 ld   (ix+$04),$00
3C25: C9          ret
3C26: 3E 01       ld   a,$01
3C28: B7          or   a
3C29: C9          ret
3C2A: 0E 08       ld   c,$08
3C2C: DD 7E 07    ld   a,(ix+$07)
3C2F: B7          or   a
3C30: C8          ret  z
3C31: FE 1F       cp   $1F
3C33: D0          ret  nc
3C34: D0          ret  nc
3C35: 16 00       ld   d,$00
3C37: 5F          ld   e,a
3C38: 21 10 82    ld   hl,red_door_position_array_8210
3C3B: 19          add  hl,de
3C3C: 4E          ld   c,(hl)
3C3D: C9          ret

update_in_room_timer_3c3e:
3C3E: DD 7E 0A    ld   a,(ix+$0a)
3C41: DD 34 0A    inc  (ix+$0a)
3C44: B7          or   a
3C45: CA 14 3D    jp   z,$3D14
3C48: FE 08       cp   $08
3C4A: DA D3 3C    jp   c,$3CD3
3C4D: CA 8E 3C    jp   z,$3C8E
3C50: 21 ED 82    ld   hl,$82ED
3C53: BE          cp   (hl)
3C54: DA FB 3C    jp   c,$3CFB
3C57: CA F1 3D    jp   z,$3DF1
3C5A: FE E0       cp   $E0
3C5C: DA FB 3C    jp   c,$3CFB
3C5F: CA F1 3D    jp   z,$3DF1
3C62: FE E1       cp   $E1
3C64: 28 0B       jr   z,$3C71
3C66: FE F7       cp   $F7
3C68: D8          ret  c
3C69: FE FA       cp   $FA
3C6B: C2 D3 3C    jp   nz,$3CD3
3C6E: C3 A3 3C    jp   character_exited_door_3ca3
3C71: DD 36 04 00 ld   (ix+$04),$00
3C75: 06 12       ld   b,$12
3C77: 3A BA 85    ld   a,(current_enemy_index_85BA)
3C7A: B7          or   a
3C7B: 28 09       jr   z,$3C86
3C7D: 3A 37 82    ld   a,(skill_level_8237)
3C80: FE 02       cp   $02
3C82: 30 02       jr   nc,$3C86
3C84: 06 0A       ld   b,$0A
3C86: DD 7E 0A    ld   a,(ix+$0a)
3C89: 80          add  a,b
3C8A: DD 77 0A    ld   (ix+$0a),a
3C8D: C9          ret
3C8E: DD 36 04 FF ld   (ix+$04),$FF
3C92: 3A BA 85    ld   a,(current_enemy_index_85BA)
3C95: B7          or   a
3C96: C8          ret  z
3C97: DD 36 09 FF ld   (ix+$09),$FF
3C9B: 3A 75 83    ld   a,($8375)
3C9E: DD 77 10    ld   (ix+$10),a
3CA1: C9          ret
3CA2: C9          ret

character_exited_door_3ca3:
3CA3: DD 36 04 02 ld   (ix+$04),$02
3CA7: DD 36 06 00 ld   (ix+character_situation_06),CS_ON_GROUND_00
3CAB: DD 36 02 1D ld   (ix+$02),$1D
3CAF: DD 36 03 06 ld   (ix+character_y_offset_03),$06
3CB3: DD 36 09 00 ld   (ix+$09),$00
3CB7: DD 36 0C 00 ld   (ix+$0c),$00
3CBB: DD 36 05 00 ld   (ix+character_delta_x_05),$00
3CBF: 3A BA 85    ld   a,(current_enemy_index_85BA)
3CC2: B7          or   a
3CC3: C0          ret  nz
3CC4: DD 5E 07    ld   e,(ix+$07)
3CC7: 16 00       ld   d,$00
3CC9: 21 10 82    ld   hl,red_door_position_array_8210
3CCC: 19          add  hl,de
3CCD: 36 08       ld   (hl),$08			; document collected, set 8 to clear door
3CCF: CD F0 56    call $56F0
3CD2: C9          ret

3CD3: DD 36 04 00 ld   (ix+$04),$00
3CD7: DD 46 05    ld   b,(ix+character_delta_x_05)
3CDA: DD 7E 00    ld   a,(ix+character_x_00)
3CDD: 80          add  a,b
3CDE: DD 77 00    ld   (ix+character_x_00),a
3CE1: DD 7E 01    ld   a,(ix+character_x_right_01)
3CE4: 80          add  a,b
3CE5: DD 77 01    ld   (ix+character_x_right_01),a
3CE8: 3E 01       ld   a,$01
3CEA: DD 96 0C    sub  (ix+$0c)
3CED: DD 77 0C    ld   (ix+$0c),a
3CF0: C6 06       add  a,$06
3CF2: DD 77 03    ld   (ix+character_y_offset_03),a
3CF5: C6 17       add  a,$17
3CF7: DD 77 02    ld   (ix+$02),a
3CFA: C9          ret
3CFB: DD 7E 0D    ld   a,(ix+move_direction_0d)
3CFE: 0F          rrca
3CFF: DA 0C 3D    jp   c,$3D0C
3D02: 0F          rrca
3D03: D0          ret  nc
3D04: DD 7E 0B    ld   a,(ix+$0b)
3D07: B7          or   a
3D08: CC F1 3D    call z,$3DF1
3D0B: C9          ret
3D0C: DD 7E 0B    ld   a,(ix+$0b)
3D0F: B7          or   a
3D10: C4 F1 3D    call nz,$3DF1
3D13: C9          ret
3D14: CD 6A 3D    call get_free_moving_door_slot_3d6a
3D17: C2 65 3D    jp   nz,set_character_on_ground_3D65
3D1A: CD BB 3D    call $3DBB
3D1D: 79          ld   a,c
3D1E: B7          or   a
3D1F: C2 38 3D    jp   nz,$3D38
3D22: 78          ld   a,b
3D23: D6 02       sub  $02
3D25: DD 77 01    ld   (ix+character_x_right_01),a
3D28: D6 08       sub  $08
3D2A: DD 77 00    ld   (ix+character_x_00),a
3D2D: DD 36 0B 01 ld   (ix+$0b),$01
3D31: DD 36 05 02 ld   (ix+character_delta_x_05),$02
3D35: C3 4B 3D    jp   $3D4B
3D38: 78          ld   a,b
3D39: C6 19       add  a,$19
3D3B: DD 77 01    ld   (ix+character_x_right_01),a
3D3E: D6 08       sub  $08
3D40: DD 77 00    ld   (ix+character_x_00),a
3D43: DD 36 0B 00 ld   (ix+$0b),$00
3D47: DD 36 05 FE ld   (ix+character_delta_x_05),$FE
3D4B: DD 36 04 00 ld   (ix+$04),$00
3D4F: DD 36 0A 01 ld   (ix+$0a),$01
3D53: DD 36 0C 01 ld   (ix+$0c),$01
3D57: FD 71 03    ld   (iy+$03),c
3D5A: 3A BA 85    ld   a,(current_enemy_index_85BA)
3D5D: B7          or   a
3D5E: C0          ret  nz
3D5F: 3E 37       ld   a,$37		; entering document room sound
3D61: CD 56 36    call play_sound_3656
3D64: C9          ret

set_character_on_ground_3D65:
3D65: DD 36 06 00 ld   (ix+character_situation_06),CS_ON_GROUND_00
3D69: C9          ret

get_free_moving_door_slot_3d6a:
3D6A: FD 21 AD 80 ld   iy,$80AD
3D6E: CD AD 3D    call check_opening_door_matches_character_3dad
3D71: CA A9 3D    jp   z,$3DA9
3D74: FD 21 B5 80 ld   iy,$80B5
3D78: CD AD 3D    call check_opening_door_matches_character_3dad
3D7B: CA A9 3D    jp   z,$3DA9
3D7E: FD 21 AD 80 ld   iy,$80AD
3D82: FD 7E 05    ld   a,(iy+$05)
3D85: 3C          inc  a
3D86: CA 92 3D    jp   z,init_door_slot_3d92
3D89: FD 21 B5 80 ld   iy,$80B5
3D8D: FD 7E 05    ld   a,(iy+$05)
3D90: 3C          inc  a
3D91: C0          ret  nz

init_door_slot_3d92:
3D92: DD 7E 07    ld   a,(ix+$07)
3D95: FD 77 02    ld   (iy+$02),a
3D98: DD 7E 08    ld   a,(ix+$08)
3D9B: FD 77 04    ld   (iy+character_state_04),a
3D9E: AF          xor  a
3D9F: FD 77 05    ld   (iy+$05),a
3DA2: FD 77 06    ld   (iy+$06),a
3DA5: FD 77 07    ld   (iy+$07),a
3DA8: C9          ret

3DA9: 3E 01       ld   a,$01
3DAB: B7          or   a
3DAC: C9          ret

check_opening_door_matches_character_3dad:
3DAD: FD 7E 02    ld   a,(iy+$02)
3DB0: DD BE 07    cp   (ix+$07)
3DB3: C0          ret  nz
3DB4: FD 7E 04    ld   a,(iy+character_state_04)
3DB7: DD BE 08    cp   (ix+$08)
3DBA: C9          ret
3DBB: DD 7E 07    ld   a,(ix+$07)
3DBE: FE 07       cp   $07
3DC0: DA E5 3D    jp   c,$3DE5
3DC3: DD 7E 08    ld   a,(ix+$08)
3DC6: 87          add  a,a
3DC7: 87          add  a,a
3DC8: 87          add  a,a
3DC9: 47          ld   b,a
3DCA: 80          add  a,b
3DCB: 80          add  a,b
3DCC: C6 20       add  a,$20
3DCE: 47          ld   b,a
3DCF: 0E 00       ld   c,$00
3DD1: FE 98       cp   $98
3DD3: CA DC 3D    jp   z,$3DDC
3DD6: FE 80       cp   $80
3DD8: D8          ret  c
3DD9: 0E 01       ld   c,$01
3DDB: C9          ret
3DDC: DD 7E 07    ld   a,(ix+$07)
3DDF: FE 14       cp   $14
3DE1: C8          ret  z
3DE2: 0E 01       ld   c,$01
3DE4: C9          ret
3DE5: 01 00 18    ld   bc,$1800
3DE8: DD 7E 08    ld   a,(ix+$08)
3DEB: B7          or   a
3DEC: C8          ret  z
3DED: 01 01 D0    ld   bc,$D001
3DF0: C9          ret
3DF1: CD 6A 3D    call get_free_moving_door_slot_3d6a
3DF4: C2 5B 3E    jp   nz,$3E5B
3DF7: 3A BA 85    ld   a,(current_enemy_index_85BA)
3DFA: B7          or   a
3DFB: 20 0A       jr   nz,$3E07
3DFD: FD 36 06 02 ld   (iy+$06),$02
3E01: DD 36 13 30 ld   (ix+enemy_aggressivity_13),$30
3E05: 18 0B       jr   $3E12

3E07: 3A 37 82    ld   a,(skill_level_8237)
3E0A: FE 02       cp   $02
3E0C: 30 04       jr   nc,$3E12
3E0E: FD 36 07 01 ld   (iy+$07),$01
3E12: CD BB 3D    call $3DBB
3E15: 79          ld   a,c
3E16: B7          or   a
3E17: CA 30 3E    jp   z,$3E30
3E1A: 78          ld   a,b
3E1B: C6 04       add  a,$04
3E1D: DD 77 00    ld   (ix+character_x_00),a
3E20: C6 08       add  a,$08
3E22: DD 77 01    ld   (ix+character_x_right_01),a
3E25: DD 36 0B 01 ld   (ix+$0b),$01
3E29: DD 36 05 02 ld   (ix+character_delta_x_05),$02
3E2D: C3 43 3E    jp   $3E43
3E30: 78          ld   a,b
3E31: C6 03       add  a,$03
3E33: DD 77 00    ld   (ix+character_x_00),a
3E36: C6 08       add  a,$08
3E38: DD 77 01    ld   (ix+character_x_right_01),a
3E3B: DD 36 0B 00 ld   (ix+$0b),$00
3E3F: DD 36 05 FE ld   (ix+character_delta_x_05),$FE
3E43: DD 36 04 FF ld   (ix+$04),$FF
3E47: DD 36 0A E1 ld   (ix+$0a),$E1
3E4B: DD 36 02 1F ld   (ix+$02),$1F
3E4F: DD 36 03 08 ld   (ix+character_y_offset_03),$08
3E53: DD 36 0C 00 ld   (ix+$0c),$00
3E57: FD 71 03    ld   (iy+$03),c
3E5A: C9          ret
3E5B: DD 36 0A E0 ld   (ix+$0a),$E0
3E5F: DD 36 06 05 ld   (ix+character_situation_06),CS_IN_ROOM_05
3E63: C9          ret
3E64: DD 7E 05    ld   a,(ix+character_delta_x_05)
3E67: B7          or   a
3E68: F2 75 3E    jp   p,$3E75
3E6B: DD 7E 0B    ld   a,(ix+$0b)
3E6E: B7          or   a
3E6F: CA C9 40    jp   z,$40C9
3E72: C3 A4 40    jp   $40A4
3E75: DD 7E 0B    ld   a,(ix+$0b)
3E78: B7          or   a
3E79: CA 7F 3E    jp   z,$3E7F
3E7C: C3 A6 3E    jp   $3EA6
3E7F: DD 7E 0A    ld   a,(ix+$0a)
3E82: DD 34 0A    inc  (ix+$0a)
3E85: B7          or   a
3E86: CA CD 3E    jp   z,$3ECD
3E89: FE 01       cp   $01
3E8B: CA 2E 3F    jp   z,$3F2E
3E8E: FE 17       cp   $17
3E90: DA 6E 3F    jp   c,$3F6E
3E93: CA A7 3F    jp   z,$3FA7
3E96: FE 19       cp   $19
3E98: DA E5 3F    jp   c,$3FE5
3E9B: CA 05 40    jp   z,$4005
3E9E: FE 1E       cp   $1E
3EA0: DA 23 40    jp   c,$4023
3EA3: C3 4D 40    jp   $404D
3EA6: DD 7E 0A    ld   a,(ix+$0a)
3EA9: DD 34 0A    inc  (ix+$0a)
3EAC: B7          or   a
3EAD: CA F7 3E    jp   z,$3EF7
3EB0: FE 01       cp   $01
3EB2: CA 4E 3F    jp   z,$3F4E
3EB5: FE 17       cp   $17
3EB7: DA 86 3F    jp   c,$3F86
3EBA: CA C6 3F    jp   z,$3FC6
3EBD: FE 19       cp   $19
3EBF: DA FA 3F    jp   c,$3FFA
3EC2: CA 14 40    jp   z,$4014
3EC5: FE 1E       cp   $1E
3EC7: DA 38 40    jp   c,$4038
3ECA: C3 99 40    jp   $4099
3ECD: DD 36 00 2E ld   (ix+character_x_00),$2E
3ED1: DD 36 03 08 ld   (ix+character_y_offset_03),$08
3ED5: DD 36 0C 01 ld   (ix+$0c),$01
3ED9: DD 46 07    ld   b,(ix+$07)
3EDC: 0E 00       ld   c,$00
3EDE: 16 08       ld   d,$08
3EE0: CD 6C 1E    call compute_delta_height_1e6c
3EE3: 45          ld   b,l
3EE4: 2A BB 85    ld   hl,($85BB)
3EE7: 36 01       ld   (hl),$01
3EE9: 23          inc  hl
3EEA: 36 20       ld   (hl),$20
3EEC: 23          inc  hl
3EED: 70          ld   (hl),b
3EEE: 23          inc  hl
3EEF: 36 04       ld   (hl),$04
3EF1: 23          inc  hl
3EF2: 36 68       ld   (hl),$68
3EF4: C3 1E 3F    jp   $3F1E
3EF7: DD 36 00 C2 ld   (ix+character_x_00),$C2
3EFB: DD 36 03 08 ld   (ix+character_y_offset_03),$08
3EFF: DD 36 0C 01 ld   (ix+$0c),$01
3F03: DD 46 07    ld   b,(ix+$07)
3F06: 0E 00       ld   c,$00
3F08: 16 08       ld   d,$08
3F0A: CD 6C 1E    call compute_delta_height_1e6c
3F0D: 45          ld   b,l
3F0E: 2A BB 85    ld   hl,($85BB)
3F11: 36 01       ld   (hl),$01
3F13: 23          inc  hl
3F14: 36 C8       ld   (hl),$C8
3F16: 23          inc  hl
3F17: 70          ld   (hl),b
3F18: 23          inc  hl
3F19: 36 05       ld   (hl),$05
3F1B: 23          inc  hl
3F1C: 36 68       ld   (hl),$68
3F1E: 3A BA 85    ld   a,(current_enemy_index_85BA)
3F21: B7          or   a
3F22: C0          ret  nz
3F23: DD 7E 0A    ld   a,(ix+$0a)
3F26: 3D          dec  a
3F27: C0          ret  nz
3F28: 3E 62       ld   a,$62		; climbing stairs
3F2A: CD 56 36    call play_sound_3656
3F2D: C9          ret
3F2E: DD 36 00 29 ld   (ix+character_x_00),$29
3F32: DD 36 0C 07 ld   (ix+$0c),$07
3F36: DD 46 07    ld   b,(ix+$07)
3F39: 0E 00       ld   c,$00
3F3B: 16 30       ld   d,$30
3F3D: CD 6C 1E    call compute_delta_height_1e6c
3F40: 45          ld   b,l
3F41: 2A BB 85    ld   hl,($85BB)
3F44: 23          inc  hl
3F45: 36 26       ld   (hl),$26
3F47: 23          inc  hl
3F48: 70          ld   (hl),b
3F49: 23          inc  hl
3F4A: 23          inc  hl
3F4B: 36 00       ld   (hl),$00
3F4D: C9          ret

3F4E: DD 36 00 C6 ld   (ix+character_x_00),$C6
3F52: DD 36 0C 07 ld   (ix+$0c),$07
3F56: DD 46 07    ld   b,(ix+$07)
3F59: 0E 00       ld   c,$00
3F5B: 16 30       ld   d,$30
3F5D: CD 6C 1E    call compute_delta_height_1e6c
3F60: 45          ld   b,l
3F61: 2A BB 85    ld   hl,($85BB)
3F64: 23          inc  hl
3F65: 36 C4       ld   (hl),$C4
3F67: 23          inc  hl
3F68: 70          ld   (hl),b
3F69: 23          inc  hl
3F6A: 23          inc  hl
3F6B: 36 00       ld   (hl),$00
3F6D: C9          ret

3F6E: DD 35 00    dec  (ix+character_x_00)
3F71: DD 34 03    inc  (ix+character_y_offset_03)
3F74: DD 34 03    inc  (ix+character_y_offset_03)
3F77: 2A BB 85    ld   hl,($85BB)
3F7A: 23          inc  hl
3F7B: 35          dec  (hl)
3F7C: 23          inc  hl
3F7D: 3A 04 80    ld   a,(scroll_speed_8004)
3F80: ED 44       neg
3F82: 86          add  a,(hl)
3F83: 77          ld   (hl),a
3F84: 18 16       jr   $3F9C

3F86: DD 34 00    inc  (ix+character_x_00)
3F89: DD 34 03    inc  (ix+character_y_offset_03)
3F8C: DD 34 03    inc  (ix+character_y_offset_03)
3F8F: 2A BB 85    ld   hl,($85BB)
3F92: 23          inc  hl
3F93: 34          inc  (hl)
3F94: 23          inc  hl
3F95: 3A 04 80    ld   a,(scroll_speed_8004)
3F98: ED 44       neg
3F9A: 86          add  a,(hl)
3F9B: 77          ld   (hl),a
3F9C: DD 7E 0A    ld   a,(ix+$0a)
3F9F: FE 0B       cp   $0B
3FA1: C0          ret  nz
3FA2: 23          inc  hl
3FA3: 23          inc  hl
3FA4: 36 6A       ld   (hl),$6A
3FA6: C9          ret

3FA7: DD 36 00 13 ld   (ix+character_x_00),$13
3FAB: DD 36 03 34 ld   (ix+character_y_offset_03),$34
3FAF: DD 36 0C 00 ld   (ix+$0c),$00
3FB3: 2A BB 85    ld   hl,($85BB)
3FB6: 23          inc  hl
3FB7: 36 10       ld   (hl),$10
3FB9: 23          inc  hl
3FBA: 3A 04 80    ld   a,(scroll_speed_8004)
3FBD: ED 44       neg
3FBF: 86          add  a,(hl)
3FC0: 77          ld   (hl),a
3FC1: 23          inc  hl
3FC2: 23          inc  hl
3FC3: 36 69       ld   (hl),$69
3FC5: C9          ret

3FC6: DD 36 00 DC ld   (ix+character_x_00),$DC
3FCA: DD 36 03 34 ld   (ix+character_y_offset_03),$34
3FCE: DD 36 0C 00 ld   (ix+$0c),$00
3FD2: 2A BB 85    ld   hl,($85BB)
3FD5: 23          inc  hl
3FD6: 36 D8       ld   (hl),$D8
3FD8: 23          inc  hl
3FD9: 3A 04 80    ld   a,(scroll_speed_8004)
3FDC: ED 44       neg
3FDE: 86          add  a,(hl)
3FDF: 77          ld   (hl),a
3FE0: 23          inc  hl
3FE1: 23          inc  hl
3FE2: 36 69       ld   (hl),$69
3FE4: C9          ret

3FE5: DD 36 00 12 ld   (ix+character_x_00),$12
3FE9: DD 36 03 36 ld   (ix+character_y_offset_03),$36
3FED: 2A BB 85    ld   hl,($85BB)
3FF0: 23          inc  hl
3FF1: 23          inc  hl
3FF2: 3A 04 80    ld   a,(scroll_speed_8004)
3FF5: ED 44       neg
3FF7: 86          add  a,(hl)
3FF8: 77          ld   (hl),a
3FF9: C9          ret

3FFA: DD 36 00 DD ld   (ix+character_x_00),$DD
3FFE: DD 36 03 36 ld   (ix+character_y_offset_03),$36
4002: C3 ED 3F    jp   $3FED
4005: DD 36 00 11 ld   (ix+character_x_00),$11
4009: DD 36 03 38 ld   (ix+character_y_offset_03),$38
400D: DD 36 0C 01 ld   (ix+$0c),$01
4011: C3 ED 3F    jp   $3FED
4014: DD 36 00 DE ld   (ix+character_x_00),$DE
4018: DD 36 03 38 ld   (ix+character_y_offset_03),$38
401C: DD 36 0C 01 ld   (ix+$0c),$01
4020: C3 ED 3F    jp   $3FED
4023: DD 35 00    dec  (ix+character_x_00)
4026: DD 35 00    dec  (ix+character_x_00)
4029: DD 7E 0A    ld   a,(ix+$0a)
402C: E6 01       and  $01
402E: DD 7E 0C    ld   a,(ix+$0c)
4031: DD 36 03 38 ld   (ix+character_y_offset_03),$38
4035: C3 ED 3F    jp   $3FED
4038: DD 34 00    inc  (ix+character_x_00)
403B: DD 34 00    inc  (ix+character_x_00)
403E: DD 7E 0A    ld   a,(ix+$0a)
4041: E6 01       and  $01
4043: DD 77 0C    ld   (ix+$0c),a
4046: DD 36 03 38 ld   (ix+character_y_offset_03),$38
404A: C3 ED 3F    jp   $3FED

404D: DD 36 00 06 ld   (ix+character_x_00),$06
4051: DD 36 01 0F ld   (ix+character_x_right_01),$0F
4055: DD 34 07    inc  (ix+$07)
4058: 2A BB 85    ld   hl,($85BB)
405B: 36 FF       ld   (hl),$FF
405D: DD 36 02 1D ld   (ix+$02),$1D
4061: DD 36 03 06 ld   (ix+character_y_offset_03),$06
4065: DD 36 06 00 ld   (ix+character_situation_06),CS_ON_GROUND_00
4069: 3A BA 85    ld   a,(current_enemy_index_85BA)
406C: B7          or   a
406D: 28 0E       jr   z,$407D
406F: AF          xor  a
4070: DD 77 09    ld   (ix+$09),a
4073: DD 77 0C    ld   (ix+$0c),a
4076: DD 77 05    ld   (ix+character_delta_x_05),a
4079: DD 77 0A    ld   (ix+$0a),a
407C: C9          ret

407D: DD 36 09 03 ld   (ix+$09),$03
4081: DD 36 0C 01 ld   (ix+$0c),$01
4085: DD 7E 0B    ld   a,(ix+$0b)
4088: 87          add  a,a
4089: 87          add  a,a
408A: D6 02       sub  $02
408C: DD 77 05    ld   (ix+character_delta_x_05),a
408F: DD 36 0A 0C ld   (ix+$0a),$0C
4093: 3E 60       ld   a,$60
4095: CD 56 36    call play_sound_3656
4098: C9          ret

4099: DD 36 00 EC ld   (ix+character_x_00),$EC
409D: DD 36 01 F4 ld   (ix+character_x_right_01),$F4
40A1: C3 55 40    jp   $4055

40A4: DD 7E 0A    ld   a,(ix+$0a)
40A7: DD 34 0A    inc  (ix+$0a)
40AA: B7          or   a
40AB: CA EE 40    jp   z,$40EE
40AE: FE 05       cp   $05
40B0: DA 50 41    jp   c,$4150
40B3: CA 72 41    jp   z,$4172
40B6: FE 07       cp   $07
40B8: DA 90 41    jp   c,$4190
40BB: CA A6 41    jp   z,$41A6
40BE: FE 1D       cp   $1D
40C0: DA E4 41    jp   c,$41E4
40C3: CA 1D 42    jp   z,$421D
40C6: C3 3B 42    jp   $423B
40C9: DD 7E 0A    ld   a,(ix+$0a)
40CC: DD 34 0A    inc  (ix+$0a)
40CF: B7          or   a
40D0: CA 1B 41    jp   z,$411B
40D3: FE 05       cp   $05
40D5: DA 61 41    jp   c,$4161
40D8: CA 81 41    jp   z,$4181
40DB: FE 07       cp   $07
40DD: DA 9B 41    jp   c,$419B
40E0: CA C5 41    jp   z,$41C5
40E3: FE 1D       cp   $1D
40E5: DA FC 41    jp   c,$41FC
40E8: CA 2C 42    jp   z,$422C
40EB: C3 46 42    jp   $4246
40EE: DD 36 00 09 ld   (ix+character_x_00),$09
40F2: DD 36 03 38 ld   (ix+character_y_offset_03),$38
40F6: DD 35 07    dec  (ix+$07)
40F9: DD 36 0C 01 ld   (ix+$0c),$01
40FD: DD 46 07    ld   b,(ix+$07)
4100: 0E 00       ld   c,$00
4102: 16 30       ld   d,$30
4104: CD 6C 1E    call compute_delta_height_1e6c
4107: 45          ld   b,l
4108: 2A BB 85    ld   hl,($85BB)
410B: 36 01       ld   (hl),$01
410D: 23          inc  hl
410E: 36 10       ld   (hl),$10
4110: 23          inc  hl
4111: 70          ld   (hl),b
4112: 23          inc  hl
4113: 36 04       ld   (hl),$04
4115: 23          inc  hl
4116: 36 69       ld   (hl),$69
4118: C3 45 41    jp   $4145
411B: DD 36 00 E6 ld   (ix+character_x_00),$E6
411F: DD 36 03 38 ld   (ix+character_y_offset_03),$38
4123: DD 35 07    dec  (ix+$07)
4126: DD 36 0C 01 ld   (ix+$0c),$01
412A: DD 46 07    ld   b,(ix+$07)
412D: 0E 00       ld   c,$00
412F: 16 30       ld   d,$30
4131: CD 6C 1E    call compute_delta_height_1e6c
4134: 45          ld   b,l
4135: 2A BB 85    ld   hl,($85BB)
4138: 36 01       ld   (hl),$01
413A: 23          inc  hl
413B: 36 D8       ld   (hl),$D8
413D: 23          inc  hl
413E: 70          ld   (hl),b
413F: 23          inc  hl
4140: 36 05       ld   (hl),$05
4142: 23          inc  hl
4143: 36 69       ld   (hl),$69
4145: 3A BA 85    ld   a,(current_enemy_index_85BA)
4148: B7          or   a
4149: C0          ret  nz
414A: 3E 63       ld   a,$63		; climbing down stairs
414C: CD 56 36    call play_sound_3656
414F: C9          ret

4150: DD 34 00    inc  (ix+character_x_00)
4153: DD 34 00    inc  (ix+character_x_00)
4156: DD 7E 0A    ld   a,(ix+$0a)
4159: E6 01       and  $01
415B: DD 77 0C    ld   (ix+$0c),a
415E: C3 ED 3F    jp   $3FED

4161: DD 35 00    dec  (ix+character_x_00)
4164: DD 35 00    dec  (ix+character_x_00)
4167: DD 7E 0A    ld   a,(ix+$0a)
416A: E6 01       and  $01
416C: DD 77 0C    ld   (ix+$0c),a
416F: C3 ED 3F    jp   $3FED

4172: DD 36 00 12 ld   (ix+character_x_00),$12
4176: DD 36 03 36 ld   (ix+character_y_offset_03),$36
417A: DD 36 0C 00 ld   (ix+$0c),$00
417E: C3 ED 3F    jp   $3FED

4181: DD 36 00 DE ld   (ix+character_x_00),$DE
4185: DD 36 03 36 ld   (ix+character_y_offset_03),$36
4189: DD 36 0C 00 ld   (ix+$0c),$00
418D: C3 ED 3F    jp   $3FED

4190: DD 36 00 13 ld   (ix+character_x_00),$13
4194: DD 36 03 34 ld   (ix+character_y_offset_03),$34
4198: C3 ED 3F    jp   $3FED

419B: DD 36 00 DC ld   (ix+character_x_00),$DC
419F: DD 36 03 34 ld   (ix+character_y_offset_03),$34
41A3: C3 ED 3F    jp   $3FED

41A6: DD 36 00 15 ld   (ix+character_x_00),$15
41AA: DD 36 03 32 ld   (ix+character_y_offset_03),$32
41AE: DD 36 0C 08 ld   (ix+$0c),$08
41B2: 2A BB 85    ld   hl,($85BB)
41B5: 23          inc  hl
41B6: 36 10       ld   (hl),$10
41B8: 23          inc  hl
41B9: 3A 04 80    ld   a,(scroll_speed_8004)
41BC: ED 44       neg
41BE: 86          add  a,(hl)
41BF: 77          ld   (hl),a
41C0: 23          inc  hl
41C1: 23          inc  hl
41C2: 36 6A       ld   (hl),$6A
41C4: C9          ret
41C5: DD 36 00 DA ld   (ix+character_x_00),$DA
41C9: DD 36 03 32 ld   (ix+character_y_offset_03),$32
41CD: DD 36 0C 08 ld   (ix+$0c),$08
41D1: 2A BB 85    ld   hl,($85BB)
41D4: 23          inc  hl
41D5: 36 D8       ld   (hl),$D8
41D7: 23          inc  hl
41D8: 3A 04 80    ld   a,(scroll_speed_8004)
41DB: ED 44       neg
41DD: 86          add  a,(hl)
41DE: 77          ld   (hl),a
41DF: 23          inc  hl
41E0: 23          inc  hl
41E1: 36 6A       ld   (hl),$6A
41E3: C9          ret
41E4: DD 34 00    inc  (ix+character_x_00)
41E7: DD 35 03    dec  (ix+character_y_offset_03)
41EA: DD 35 03    dec  (ix+character_y_offset_03)
41ED: 2A BB 85    ld   hl,($85BB)
41F0: 23          inc  hl
41F1: 34          inc  (hl)
41F2: 23          inc  hl
41F3: 3A 04 80    ld   a,(scroll_speed_8004)
41F6: ED 44       neg
41F8: 86          add  a,(hl)
41F9: 77          ld   (hl),a
41FA: 18 16       jr   $4212
41FC: DD 35 00    dec  (ix+character_x_00)
41FF: DD 35 03    dec  (ix+character_y_offset_03)
4202: DD 35 03    dec  (ix+character_y_offset_03)
4205: 2A BB 85    ld   hl,($85BB)
4208: 23          inc  hl
4209: 35          dec  (hl)
420A: 23          inc  hl
420B: 3A 04 80    ld   a,(scroll_speed_8004)
420E: ED 44       neg
4210: 86          add  a,(hl)
4211: 77          ld   (hl),a
4212: DD 7E 0A    ld   a,(ix+$0a)
4215: FE 16       cp   $16
4217: C0          ret  nz
4218: 23          inc  hl
4219: 23          inc  hl
421A: 36 00       ld   (hl),$00
421C: C9          ret
421D: DD 36 00 2A ld   (ix+character_x_00),$2A
4221: DD 36 03 08 ld   (ix+character_y_offset_03),$08
4225: DD 36 0C 01 ld   (ix+$0c),$01
4229: C3 D9 3E    jp   $3ED9
422C: DD 36 00 C5 ld   (ix+character_x_00),$C5
4230: DD 36 03 08 ld   (ix+character_y_offset_03),$08
4234: DD 36 0C 01 ld   (ix+$0c),$01
4238: C3 03 3F    jp   $3F03
423B: DD 36 00 34 ld   (ix+character_x_00),$34
423F: DD 36 01 3C ld   (ix+character_x_right_01),$3C
4243: C3 58 40    jp   $4058
4246: DD 36 00 BE ld   (ix+character_x_00),$BE
424A: DD 36 01 C6 ld   (ix+character_x_right_01),$C6
424E: C3 58 40    jp   $4058
4251: CD 66 42    call $4266
4254: CD 61 36    call $3661
4257: DD 7E 09    ld   a,(ix+$09)
425A: FE 08       cp   $08
425C: 20 04       jr   nz,$4262
425E: DD 36 09 00 ld   (ix+$09),$00
4262: CD 58 45    call $4558
4265: C9          ret
4266: 21 48 86    ld   hl,protection_variable_8648
4269: 86          add  a,(hl)
426A: F6 BD       or   $BD
426C: 2B          dec  hl
426D: B6          or   (hl)
426E: EE 63       xor  $63
4270: E7          rst  $20
4271: CD A7 42    call $42A7
4274: DD 7E 02    ld   a,(ix+$02)
4277: D6 30       sub  $30
4279: 30 23       jr   nc,$429E
427B: DD 7E 03    ld   a,(ix+character_y_offset_03)
427E: FE 07       cp   $07
4280: F0          ret  p
4281: DD 7E 0A    ld   a,(ix+$0a)
4284: FE 08       cp   $08
4286: D8          ret  c
4287: DD 36 03 06 ld   (ix+character_y_offset_03),$06
428B: DD 36 02 1D ld   (ix+$02),$1D
428F: DD 36 09 08 ld   (ix+$09),$08
4293: AF          xor  a
4294: DD 77 05    ld   (ix+character_delta_x_05),a
4297: DD 77 0C    ld   (ix+$0c),a
429A: DD 77 0A    ld   (ix+$0a),a
429D: C9          ret
429E: DD 36 02 2E ld   (ix+$02),$2E
42A2: DD 36 0A 08 ld   (ix+$0a),$08
42A6: C9          ret

42A7: DD 7E 0D    ld   a,(ix+move_direction_0d)
42AA: E6 03       and  $03
42AC: 28 05       jr   z,$42B3
42AE: CB 3F       srl  a
42B0: DD 77 0B    ld   (ix+$0b),a
42B3: DD 7E 05    ld   a,(ix+character_delta_x_05)
42B6: DD 86 00    add  a,(ix+character_x_00)
42B9: DD 77 00    ld   (ix+character_x_00),a
42BC: C6 08       add  a,$08
42BE: DD 77 01    ld   (ix+character_x_right_01),a
42C1: 26 00       ld   h,$00
42C3: DD 7E 0A    ld   a,(ix+$0a)
42C6: 87          add  a,a
42C7: 87          add  a,a
42C8: 6F          ld   l,a
42C9: 11 E2 42    ld   de,table_42E2
42CC: 19          add  hl,de
42CD: 7E          ld   a,(hl)
42CE: 23          inc  hl
42CF: DD 86 03    add  a,(ix+character_y_offset_03)
42D2: DD 77 03    ld   (ix+character_y_offset_03),a
42D5: 86          add  a,(hl)
42D6: 23          inc  hl
42D7: DD 77 02    ld   (ix+$02),a
42DA: 7E          ld   a,(hl)
42DB: DD 77 0C    ld   (ix+$0c),a
42DE: DD 34 0A    inc  (ix+$0a)
42E1: C9          ret

table_42E2:
	dc.b	07          
	dc.b	15          
	dc.b	03          
	dc.b	00          
	dc.b	05          
	dc.b	15          
	dc.b	03          
	dc.b	01 07 0F    
	dc.b	05          
	dc.b	02          
	dc.b	03          
	dc.b	0F          
	dc.b	05          
	dc.b	03          
	dc.b	02          
	dc.b	0F          
	dc.b	05          
	dc.b	04          
	dc.b	01 0F 05    
	dc.b	05          
	dc.b	00          
	dc.b	0F          
	dc.b	05          
	dc.b	06 FF       
	dc.b	0F          
	dc.b	05          
	dc.b	07          
	dc.b	FE 0F       
	dc.b	05          
	dc.b	08          
	dc.b	FD          
	dc.b	0F          
	dc.b	05          
	dc.b	09          
	dc.b	FC 0F 05    
	dc.b	0A          
	dc.b	FB          
	dc.b	0F          
	dc.b	05          
	dc.b	0B          
	dc.b	F9          
	dc.b	15          
	dc.b	03          
	dc.b	0C          
	dc.b	F9          
	dc.b	15          
	dc.b	03          
	dc.b	0D          
	dc.b	F9          
	dc.b	15          
	dc.b	03          
	dc.b	0E F9       
	dc.b	15          
	dc.b	03          
	dc.b	0F          
	dc.b	F9          
	dc.b	15          
	dc.b	03          
	dc.b	10 F9       
	dc.b	15          
	dc.b	03          
	dc.b	11

432A: DD 7E 09    ld   a,(ix+$09)                                     
432D: B7          or   a
432E: F8          ret  m
432F: FE 05       cp   $05
4331: DA 3C 43    jp   c,$433C
4334: FE 07       cp   $07
4336: DA 30 38    jp   c,$3830
4339: C3 51 42    jp   $4251
433C: DD 7E 06    ld   a,(ix+character_situation_06)
433F: FE 03       cp   CS_FALLING_03
4341: DA 4F 43    jp   c,$434F
4344: CA 2B 3B    jp   z,$3B2B
4347: FE 05       cp   CS_IN_ROOM_05
4349: DA 64 3E    jp   c,$3E64
434C: C3 3E 3C    jp   update_in_room_timer_3c3e
434F: CD 59 43    call $4359
4352: CD 61 36    call $3661
4355: CD 58 45    call $4558
4358: C9          ret

4359: DD 7E 09    ld   a,(ix+$09)
435C: FE 01       cp   $01
435E: CA 8C 43    jp   z,character_walks_438C
4361: DA 2A 44    jp   c,handle_character_ground_controls_442A
4364: FE 03       cp   $03
4366: CA 6E 44    jp   z,handle_character_entering_elevator_446E
4369: DA 10 45    jp   c,$4510
436C: DD 7E 0D    ld   a,(ix+move_direction_0d)
436F: CB 5F       bit  3,a
4371: C8          ret  z
4372: DD 7E 00    ld   a,(ix+character_x_00)
4375: C6 05       add  a,$05
4377: DD 77 00    ld   (ix+character_x_00),a
437A: C6 08       add  a,$08
437C: DD 77 01    ld   (ix+character_x_right_01),a
437F: DD 36 02 14 ld   (ix+$02),$14
4383: DD 36 09 02 ld   (ix+$09),$02
4387: DD 36 0C 02 ld   (ix+$0c),$02
438B: C9          ret

character_walks_438C:
438C: CD B4 45    call $45B4
438F: DD 7E 0D    ld   a,(ix+move_direction_0d)
4392: CB 67       bit  4,a
4394: C2 F5 43    jp   nz,is_jumping_43F5
4397: 0F          rrca
4398: DA B2 43    jp   c,$43B2
439B: 0F          rrca
439C: DA E7 43    jp   c,$43E7
439F: DD 36 02 1D ld   (ix+$02),$1D
43A3: DD 36 03 06 ld   (ix+character_y_offset_03),$06
43A7: AF          xor  a
43A8: DD 77 05    ld   (ix+character_delta_x_05),a
43AB: DD 77 09    ld   (ix+$09),a
43AE: DD 77 0C    ld   (ix+$0c),a
43B1: C9          ret
43B2: DD 7E 0B    ld   a,(ix+$0b)
43B5: DD 36 0B 00 ld   (ix+$0b),$00
43B9: B7          or   a
43BA: C2 9F 43    jp   nz,$439F
43BD: DD 7E 0A    ld   a,(ix+$0a)
43C0: EE 01       xor  $01
43C2: C4 1C 44    call nz,$441C
43C5: DD 77 0A    ld   (ix+$0a),a
43C8: DD 77 0C    ld   (ix+$0c),a
43CB: 47          ld   b,a
43CC: 3E 06       ld   a,$06
43CE: 80          add  a,b
43CF: DD 77 03    ld   (ix+character_y_offset_03),a
43D2: C6 17       add  a,$17
43D4: DD 77 02    ld   (ix+$02),a
43D7: DD 46 05    ld   b,(ix+character_delta_x_05)
43DA: DD 7E 00    ld   a,(ix+character_x_00)
43DD: 80          add  a,b
43DE: DD 77 00    ld   (ix+character_x_00),a
43E1: C6 08       add  a,$08
43E3: DD 77 01    ld   (ix+character_x_right_01),a
43E6: C9          ret
43E7: DD 7E 0B    ld   a,(ix+$0b)
43EA: DD 36 0B 01 ld   (ix+$0b),$01
43EE: B7          or   a
43EF: CA 9F 43    jp   z,$439F
43F2: C3 BD 43    jp   $43BD

; ix:851A for player
is_jumping_43F5:
43F5: 3A BA 85    ld   a,(current_enemy_index_85BA)
43F8: AF          xor  a
43F9: C0          ret  nz
43FA: DD 7E 0D    ld   a,(ix+move_direction_0d)
43FD: E6 03       and  $03
43FF: 0E 00       ld   c,$00
4401: B7          or   a
4402: 28 07       jr   z,$440B
4404: 0E FE       ld   c,$FE
4406: 3D          dec  a
4407: 28 02       jr   z,$440B
4409: 0E 02       ld   c,$02
440B: DD 71 05    ld   (ix+character_delta_x_05),c
440E: DD 36 0A 00 ld   (ix+$0a),$00
4412: DD 36 09 07 ld   (ix+$09),$07
4416: 3E 33       ld   a,$33		; player jump sound
4418: CD 56 36    call play_sound_3656
441B: C9          ret

441C: F5          push af
441D: 3A BA 85    ld   a,(current_enemy_index_85BA)
4420: B7          or   a
4421: 20 05       jr   nz,$4428
4423: 3E 66       ld   a,$66		; player walk sound
4425: CD 56 36    call play_sound_3656
4428: F1          pop  af
4429: C9          ret

; not in elevator: only left, right, jump, crouch
handle_character_ground_controls_442A:
442A: CD B4 45    call $45B4
442D: DD 7E 0D    ld   a,(ix+move_direction_0d)		; read character direction (player: player_move_direction_8527)
4430: CB 67       bit  4,a
4432: C2 F5 43    jp   nz,is_jumping_43F5
4435: 0F          rrca
4436: DA 50 44    jp   c,move_character_left_4450
4439: 0F          rrca
443A: DA 5F 44    jp   c,move_character_right_445F
443D: 0F          rrca
443E: D0          ret  nc
; character crouches
443F: DD 36 02 14 ld   (ix+$02),$14
4443: DD 36 03 06 ld   (ix+character_y_offset_03),$06
4447: DD 36 09 02 ld   (ix+$09),$02
444B: DD 36 0C 02 ld   (ix+$0c),$02
444F: C9          ret

move_character_left_4450:
4450: DD 36 05 FE ld   (ix+character_delta_x_05),$FE
4454: DD 36 09 01 ld   (ix+$09),$01
4458: DD 36 0A 00 ld   (ix+$0a),$00
445C: C3 B2 43    jp   $43B2

move_character_right_445F:
445F: DD 36 05 02 ld   (ix+character_delta_x_05),$02
4463: DD 36 09 01 ld   (ix+$09),$01
4467: DD 36 0A 00 ld   (ix+$0a),$00
446B: C3 E7 43    jp   $43E7

handle_character_entering_elevator_446E:
446E: DD 7E 0D    ld   a,(ix+move_direction_0d)
4471: E6 03       and  $03
4473: CA 82 44    jp   z,$4482
; left or right: jumps out of elevator (game forces jump)
4476: DD 36 0B 00 ld   (ix+$0b),$00
447A: 1F          rra
447B: DA 82 44    jp   c,$4482
447E: DD 36 0B 01 ld   (ix+$0b),$01
4482: DD 7E 0D    ld   a,(ix+move_direction_0d)
4485: CB 67       bit  4,a
4487: C2 BB 44    jp   nz,$44BB
448A: DD 7E 05    ld   a,(ix+character_delta_x_05)
448D: DD 86 00    add  a,(ix+character_x_00)
4490: DD 77 00    ld   (ix+character_x_00),a
4493: C6 08       add  a,$08
4495: DD 77 01    ld   (ix+character_x_right_01),a
4498: DD 7E 0A    ld   a,(ix+$0a)
449B: FE 0E       cp   $0E
449D: CA 9F 43    jp   z,$439F
44A0: 26 00       ld   h,$00
44A2: 87          add  a,a
44A3: 87          add  a,a
44A4: 6F          ld   l,a
44A5: 11 D8 44    ld   de,table_44D8
44A8: 19          add  hl,de
44A9: 7E          ld   a,(hl)
44AA: DD 77 02    ld   (ix+$02),a
44AD: 23          inc  hl
44AE: 7E          ld   a,(hl)
44AF: DD 77 03    ld   (ix+character_y_offset_03),a
44B2: 23          inc  hl
44B3: 7E          ld   a,(hl)
44B4: DD 77 0C    ld   (ix+$0c),a
44B7: DD 34 0A    inc  (ix+$0a)
44BA: C9          ret
44BB: DD 36 0A 00 ld   (ix+$0a),$00
44BF: DD 36 09 07 ld   (ix+$09),$07
44C3: 3E 06       ld   a,$06
44C5: DD 96 03    sub  (ix+character_y_offset_03)
44C8: DD 36 03 06 ld   (ix+character_y_offset_03),$06
44CC: DD 86 02    add  a,(ix+$02)
44CF: DD 77 02    ld   (ix+$02),a
44D2: 3E 33       ld   a,$33
44D4: CD 56 36    call play_sound_3656
44D7: C9          ret

table_44D8:
	dc.b	22 0D 03
	dc.b	00      
	dc.b	27      
	dc.b	12      
	dc.b	03      
	dc.b	01 28 19
	dc.b	05      
	dc.b	02      
	dc.b	2B      
	dc.b	1C      
	dc.b	05      
	dc.b	03      
	dc.b	2D      
	dc.b	1E 05   
	dc.b	04      
	dc.b	2E 1F   
	dc.b	05      
	dc.b	05      
	dc.b	2E 1F   
	dc.b	05      
	dc.b	06 2D   
	dc.b	1E 05   
	dc.b	07      
	dc.b	2B      
	dc.b	1C      
	dc.b	05      
	dc.b	08      
	dc.b	28 19   
	dc.b	05      
	dc.b	09      
	dc.b	24      
	dc.b	15      
	dc.b	05      
	dc.b	0A      
	dc.b	22 0D 03
	dc.b	0B      
	dc.b	21 0A 00
	dc.b	0C      
	dc.b	1F      
	dc.b	08      
	dc.b	01 0D

4510: DD 7E 0D    ld   a,(ix+move_direction_0d)                         
4513: CB 67       bit  4,a
4515: C2 F5 43    jp   nz,is_jumping_43F5
4518: 0F          rrca
4519: DA 29 45    jp   c,$4529
451C: 0F          rrca
451D: DA 2E 45    jp   c,$452E
4520: 0F          rrca
4521: DA 33 45    jp   c,$4533
4524: 0F          rrca
4525: D0          ret  nc
4526: C3 9F 43    jp   $439F
4529: DD 36 0B 00 ld   (ix+$0b),$00
452D: C9          ret
452E: DD 36 0B 01 ld   (ix+$0b),$01
4532: C9          ret
4533: DD 7E 06    ld   a,(ix+character_situation_06)
4536: FE 02       cp   CS_ABOVE_ELEVATOR_02
4538: C8          ret  z
4539: 3A BA 85    ld   a,(current_enemy_index_85BA)
453C: B7          or   a
453D: C8          ret  z
453E: DD 7E 00    ld   a,(ix+character_x_00)
4541: D6 05       sub  $05
4543: DD 77 00    ld   (ix+character_x_00),a
4546: C6 12       add  a,$12
4548: DD 77 01    ld   (ix+character_x_right_01),a
454B: DD 36 02 0B ld   (ix+$02),$0B
454F: DD 36 09 04 ld   (ix+$09),$04
4553: DD 36 0C 09 ld   (ix+$0c),$09
4557: C9          ret

4558: DD 7E 0D    ld   a,(ix+move_direction_0d)
455B: CB 6F       bit  5,a
455D: C8          ret  z
; character is shooting
455E: 06 02       ld   b,$02
4560: 3A BA 85    ld   a,(current_enemy_index_85BA)
4563: B7          or   a
4564: 28 37       jr   z,$459D
4566: 2A BD 85    ld   hl,($85BD)
4569: 7E          ld   a,(hl)
456A: 3C          inc  a
456B: C0          ret  nz
456C: DD 7E 06    ld   a,(ix+character_situation_06)
456F: FE 03       cp   CS_FALLING_03
4571: D0          ret  nc
; ground or in elevator or falling
4572: DD 7E 09    ld   a,(ix+$09)
4575: FE 07       cp   $07
4577: 28 03       jr   z,$457C
4579: FE 05       cp   $05
457B: D0          ret  nc
457C: 21 FF 82    ld   hl,$82FF
457F: 3A BA 85    ld   a,(current_enemy_index_85BA)
4582: 80          add  a,b
4583: 87          add  a,a
4584: 87          add  a,a
4585: 87          add  a,a
4586: 85          add  a,l
4587: 6F          ld   l,a
4588: 7C          ld   a,h
4589: CE 00       adc  a,$00
458B: 67          ld   h,a
458C: 36 00       ld   (hl),$00
458E: 23          inc  hl
458F: 23          inc  hl
4590: 23          inc  hl
4591: DD E5       push ix
4593: D1          pop  de
4594: 73          ld   (hl),e
4595: 23          inc  hl
4596: 72          ld   (hl),d
4597: 23          inc  hl
4598: 3A BA 85    ld   a,(current_enemy_index_85BA)
459B: 77          ld   (hl),a
459C: C9          ret
459D: 2A BD 85    ld   hl,($85BD)
45A0: 7E          ld   a,(hl)
45A1: 3C          inc  a
45A2: 28 C8       jr   z,$456C
45A4: 05          dec  b
45A5: 11 FB FF    ld   de,$FFFB
45A8: 19          add  hl,de
45A9: 7E          ld   a,(hl)
45AA: 3C          inc  a
45AB: 28 BF       jr   z,$456C
45AD: 05          dec  b
45AE: 19          add  hl,de
45AF: 7E          ld   a,(hl)
45B0: 3C          inc  a
45B1: 28 B9       jr   z,$456C
45B3: C9          ret

45B4: DD 7E 06    ld   a,(ix+character_situation_06)
45B7: 3D          dec  a
45B8: C0          ret  nz
; in elevator
45B9: 3A BA 85    ld   a,(current_enemy_index_85BA)
45BC: C3 74 46    jp   $4674

player_elevator_control_upper_stories_45BF:
45BF: 3A 21 85    ld   a,(player_structure_851A+current_floor_07)
45C2: FE 07       cp   $07
45C4: D8          ret  c		; can't control elevators from 7 to ground from here
player_elevator_control_45C5:	; called from somewhere else
45C5: DD 7E 0D    ld   a,(ix+move_direction_0d)
45C8: 47          ld   b,a
45C9: E6 F3       and  $F3		; cancel down movement: no crouch in elevator
45CB: DD 77 0D    ld   (ix+move_direction_0d),a
45CE: CB 58       bit  3,b
45D0: 20 0B       jr   nz,player_commands_elevator_up_45DD
45D2: CB 50       bit  2,b
45D4: C8          ret  z
player_commands_elevator_down_45D5:
45D5: CD CE 62    call load_character_elevator_structure_62CE
45D8: FD 36 07 FE ld   (iy+player_control_07),$FE
45DC: C9          ret

player_commands_elevator_up_45DD:
45DD: CD CE 62    call load_character_elevator_structure_62CE
45E0: FD 36 07 02 ld   (iy+player_control_07),$02
45E4: C9          ret

ground_floor_reached_45E5:
45E5: 3E 06       ld   a,GS_GROUND_FLOOR_REACHED_06
45E7: 32 AC 80    ld   (game_state_80AC),a
45EA: 21 81 80    ld   hl,elevator_directions_array_8081
45ED: 3A 2D 80    ld   a,($802D)
45F0: 3C          inc  a
45F1: 87          add  a,a
45F2: 5F          ld   e,a
45F3: 16 00       ld   d,$00
45F5: 19          add  hl,de
45F6: 36 FE       ld   (hl),$FE
45F8: DD 21 1A 85 ld   ix,player_structure_851A
45FC: DD 36 0D 00 ld   (ix+move_direction_0d),$00
4600: CD CE 62    call load_character_elevator_structure_62CE
4603: C3 52 63    jp   $6352

4608: CD 7F 01    call handle_main_scrolling_017F
460B: CD BF 0E    call handle_elevators_0EBF
460E: CD A2 12    call handle_enemies_12A2
4611: CD E8 2F    call $2FE8
4614: CD E1 0B    call $0BE1
4617: CD A0 15    call update_sprite_shadow_ram_15a0
461A: CD CF 73    call game_tick_73cf
461D: C3 EA 45    jp   $45EA

4620: 32 74 83    ld   (instant_difficulty_level_8374),a
4623: AF          xor  a
4624: 32 F0 82    ld   ($82F0),a
4627: 3A 32 82    ld   a,(level_timer_16bit_msb_8232)
462A: D6 10       sub  $10
462C: D8          ret  c
462D: 3C          inc  a		; instant difficulty level - $10 + 1
462E: 87          add  a,a		; times 2
462F: FE 0C       cp   $0C
4631: 38 02       jr   c,$4635
4633: 3E 0C       ld   a,$0C		; maxed out
4635: 32 F0 82    ld   ($82F0),a
4638: E6 04       and  $04
463A: C2 49 46    jp   nz,$4649
463D: 3A 4C 83    ld   a,($834C)
4640: FE 08       cp   $08
4642: D2 49 46    jp   nc,$4649
4645: 3C          inc  a
4646: 32 4C 83    ld   ($834C),a
4649: 3A 32 82    ld   a,(level_timer_16bit_msb_8232)
464C: FE 10       cp   $10
464E: C0          ret  nz
; switch to hurry up music as soon as fine timer is 0xFF
464F: 3A 31 82    ld   a,(level_timer_16bit_8231)
4652: B7          or   a
4653: CA 65 46    jp   z,$4665
4656: 3D          dec  a
4657: CA 6E 46    jp   z,switch_to_hurry_up_music_466E
465A: 3D          dec  a
465B: C0          ret  nz
465C: 3E 82       ld   a,$82
465E: 32 79 87    ld   ($8779),a
4661: CD D2 64    call l_64D2
4664: C9          ret

4665: 3E 80       ld   a,$80
4667: 32 79 87    ld   ($8779),a
466A: CD D2 64    call l_64D2
466D: C9          ret

switch_to_hurry_up_music_466E:
466E: 3E 3E       ld   a,$3E
4670: 32 0B D5    ld   (sound_latch_D50B),a
4673: C9          ret

4674: B7          or   a
4675: C2 BF 45    jp   nz,player_elevator_control_upper_stories_45BF
4678: DD 7E 0D    ld   a,(ix+move_direction_0d)
467B: E6 0C       and  $0C
467D: 47          ld   b,a
467E: 21 EE 82    ld   hl,$82EE
4681: BE          cp   (hl)
4682: 77          ld   (hl),a
4683: C2 98 46    jp   nz,$4698
4686: 21 EF 82    ld   hl,$82EF
4689: 34          inc  (hl)
468A: 3A F0 82    ld   a,($82F0)
468D: 47          ld   b,a
468E: 7E          ld   a,(hl)
468F: B8          cp   b
4690: DA A0 46    jp   c,$46A0		; skips when level_timer_16bit_msb_8232 >= $10
4693: 36 00       ld   (hl),$00
4695: C3 C5 45    jp   player_elevator_control_45C5	; for all stories

4698: 21 EF 82    ld   hl,$82EF
469B: 36 00       ld   (hl),$00
469D: C3 8A 46    jp   $468A

46A0: DD 7E 0D    ld   a,(ix+move_direction_0d)
46A3: E6 F3       and  $F3
46A5: DD 77 0D    ld   (ix+move_direction_0d),a
46A8: C9          ret

get_sprite_shadow_ram_46a9:
46A9: AF          xor  a
46AA: 32 EE 82    ld   ($82EE),a
46AD: 32 EF 82    ld   ($82EF),a
46B0: 32 F0 82    ld   ($82F0),a
46B3: 21 F1 80    ld   hl,$80F1
46B6: C9          ret

increase_difficulty_if_late_46b7:
46B7: 21 79 87    ld   hl,$8779
46BA: 36 81       ld   (hl),$81
46BC: 3A 32 82    ld   a,(level_timer_16bit_msb_8232)
46BF: FE 10       cp   $10
46C1: D8          ret  c
46C2: 34          inc  (hl)
46C3: 34          inc  (hl)
46C4: C9          ret

46C5: DD 36 04 02 ld   (ix+$04),$02
46C9: CD AD 4A    call $4AAD
46CC: DD 46 00    ld   b,(ix+character_x_00)
46CF: DD 4E 01    ld   c,(ix+character_x_right_01)
46D2: 16 0B       ld   d,$0B
46D4: 78          ld   a,b
46D5: BE          cp   (hl)
46D6: DA DF 46    jp   c,$46DF
46D9: 23          inc  hl
46DA: 56          ld   d,(hl)
46DB: 23          inc  hl
46DC: C3 D4 46    jp   $46D4
46DF: 5E          ld   e,(hl)
46E0: 7B          ld   a,e
46E1: 3D          dec  a
46E2: 91          sub  c
46E3: DA F4 46    jp   c,$46F4
46E6: 7A          ld   a,d
46E7: FE 0B       cp   $0B
46E9: DA 30 4A    jp   c,$4A30
46EC: CD DA 3B    call $3BDA
46EF: C8          ret  z
46F0: CD C2 4A    call $4AC2
46F3: C9          ret
46F4: 23          inc  hl
46F5: 66          ld   h,(hl)
46F6: 7A          ld   a,d
46F7: FE 0B       cp   $0B
46F9: CA 1E 47    jp   z,$471E
46FC: 7C          ld   a,h
46FD: FE 0B       cp   $0B
46FF: 28 0E       jr   z,$470F
4701: DD 7E 09    ld   a,(ix+$09)
4704: FE 08       cp   $08
4706: C2 2C 47    jp   nz,$472C
4709: 7A          ld   a,d
470A: FE 0C       cp   $0C
470C: C2 1E 47    jp   nz,$471E
470F: DD 36 11 01 ld   (ix+$11),$01
4713: 1D          dec  e
4714: 7B          ld   a,e
4715: 91          sub  c
4716: 80          add  a,b
4717: DD 77 00    ld   (ix+character_x_00),a
471A: DD 73 01    ld   (ix+character_x_right_01),e
471D: C9          ret
471E: DD 36 11 01 ld   (ix+$11),$01
4722: 7B          ld   a,e
4723: 90          sub  b
4724: 81          add  a,c
4725: DD 77 01    ld   (ix+character_x_right_01),a
4728: DD 73 00    ld   (ix+character_x_00),e
472B: C9          ret
472C: 7A          ld   a,d
472D: DD 77 08    ld   (ix+$08),a
4730: FE 0C       cp   $0C
4732: DA 6B 47    jp   c,$476B
4735: DD 7E 05    ld   a,(ix+character_delta_x_05)
4738: B7          or   a
4739: F8          ret  m
473A: 7C          ld   a,h
473B: DD 77 08    ld   (ix+$08),a
473E: CD CE 62    call load_character_elevator_structure_62CE
4741: DD 7E 07    ld   a,(ix+$07)
4744: FD 96 01    sub  (iy+$01)
4747: FE 03       cp   $03
4749: F2 99 49    jp   p,$4999
474C: FE 01       cp   $01
474E: CA FD 47    jp   z,$47FD
4751: F2 A1 47    jp   p,$47A1
4754: FE FF       cp   $FF
4756: CA 01 49    jp   z,$4901
4759: F2 5F 48    jp   p,$485F
475C: FE FE       cp   $FE
475E: CA 47 49    jp   z,$4947
4761: FD 7E 03    ld   a,(iy+$03)
4764: DD BE 07    cp   (ix+$07)
4767: C2 99 49    jp   nz,$4999
476A: C9          ret
476B: DD 7E 05    ld   a,(ix+character_delta_x_05)
476E: 3D          dec  a
476F: F0          ret  p
4770: 7A          ld   a,d
4771: DD 77 08    ld   (ix+$08),a
4774: CD CE 62    call load_character_elevator_structure_62CE
4777: DD 7E 07    ld   a,(ix+$07)
477A: FD 96 01    sub  (iy+$01)
477D: FE 03       cp   $03
477F: F2 6B 49    jp   p,$496B
4782: FE 01       cp   $01
4784: CA 2E 48    jp   z,$482E
4787: F2 CF 47    jp   p,$47CF
478A: FE FF       cp   $FF
478C: CA 24 49    jp   z,$4924
478F: F2 B0 48    jp   p,$48B0
4792: FE FE       cp   $FE
4794: CA 59 49    jp   z,$4959
4797: FD 7E 03    ld   a,(iy+$03)
479A: DD BE 07    cp   (ix+$07)
479D: C2 6B 49    jp   nz,$496B
47A0: C9          ret
47A1: DD 7E 05    ld   a,(ix+character_delta_x_05)
47A4: B7          or   a
47A5: CA C8 47    jp   z,$47C8
47A8: DD 7E 03    ld   a,(ix+character_y_offset_03)
47AB: C6 30       add  a,$30
47AD: FD 96 00    sub  (iy+$00)
47B0: FE 20       cp   $20
47B2: D2 99 49    jp   nc,$4999
47B5: 6F          ld   l,a
47B6: CD B5 49    call $49B5
47B9: 30 0D       jr   nc,$47C8
47BB: 4D          ld   c,l
47BC: CD 9D 37    call $379D
47BF: DD 36 05 02 ld   (ix+character_delta_x_05),$02
47C3: DD 36 06 02 ld   (ix+character_situation_06),CS_ABOVE_ELEVATOR_02
47C7: C9          ret
47C8: DD 36 11 02 ld   (ix+$11),$02
47CC: C3 13 47    jp   $4713
47CF: DD 7E 05    ld   a,(ix+character_delta_x_05)
47D2: B7          or   a
47D3: CA F6 47    jp   z,$47F6
47D6: DD 7E 03    ld   a,(ix+character_y_offset_03)
47D9: C6 30       add  a,$30
47DB: FD 96 00    sub  (iy+$00)
47DE: FE 20       cp   $20
47E0: D2 6B 49    jp   nc,$496B
47E3: 6F          ld   l,a
47E4: CD B5 49    call $49B5
47E7: 30 0D       jr   nc,$47F6
47E9: 4D          ld   c,l
47EA: CD 9D 37    call $379D
47ED: DD 36 05 FE ld   (ix+character_delta_x_05),$FE
47F1: DD 36 06 02 ld   (ix+character_situation_06),CS_ABOVE_ELEVATOR_02
47F5: C9          ret
47F6: DD 36 11 02 ld   (ix+$11),$02
47FA: C3 22 47    jp   $4722
47FD: DD 7E 05    ld   a,(ix+character_delta_x_05)
4800: B7          or   a
4801: CA C8 47    jp   z,$47C8
4804: DD 7E 03    ld   a,(ix+character_y_offset_03)
4807: FD 96 00    sub  (iy+$00)
480A: FE 04       cp   $04
480C: F2 B5 47    jp   p,$47B5
480F: C6 30       add  a,$30
4811: 6F          ld   l,a
4812: DD 7E 02    ld   a,(ix+$02)
4815: FD 96 00    sub  (iy+$00)
4818: D2 C8 47    jp   nc,$47C8
481B: CD DF 49    call $49DF
481E: D2 C8 47    jp   nc,$47C8
4821: 4D          ld   c,l
4822: CD 9D 37    call $379D
4825: DD 36 05 02 ld   (ix+character_delta_x_05),$02
4829: DD 36 06 01 ld   (ix+character_situation_06),CS_IN_ELEVATOR_01
482D: C9          ret
482E: DD 7E 05    ld   a,(ix+character_delta_x_05)
4831: B7          or   a
4832: CA F6 47    jp   z,$47F6
4835: DD 7E 03    ld   a,(ix+character_y_offset_03)
4838: FD 96 00    sub  (iy+$00)
483B: FE 04       cp   $04
483D: F2 E3 47    jp   p,$47E3
4840: C6 30       add  a,$30
4842: 6F          ld   l,a
4843: DD 7E 02    ld   a,(ix+$02)
4846: FD 96 00    sub  (iy+$00)
4849: D2 F6 47    jp   nc,$47F6
484C: CD DF 49    call $49DF
484F: D2 F6 47    jp   nc,$47F6
4852: 4D          ld   c,l
4853: CD 9D 37    call $379D
4856: DD 36 05 FE ld   (ix+character_delta_x_05),$FE
485A: DD 36 06 01 ld   (ix+character_situation_06),CS_IN_ELEVATOR_01
485E: C9          ret
485F: FD 7E 06    ld   a,(iy+$06)
4862: B7          or   a
4863: CA 91 48    jp   z,$4891
4866: DD 7E 05    ld   a,(ix+character_delta_x_05)
4869: B7          or   a
486A: CA C8 47    jp   z,$47C8
486D: DD 7E 03    ld   a,(ix+character_y_offset_03)
4870: FD 96 00    sub  (iy+$00)
4873: 6F          ld   l,a
4874: FE 04       cp   $04
4876: F2 1B 48    jp   p,$481B
4879: C6 30       add  a,$30
487B: 6F          ld   l,a
487C: DD 7E 08    ld   a,(ix+$08)
487F: F6 80       or   $80
4881: DD 77 08    ld   (ix+$08),a
4884: DD 7E 02    ld   a,(ix+$02)
4887: FD 96 00    sub  (iy+$00)
488A: D2 C8 47    jp   nc,$47C8
488D: 7D          ld   a,l
488E: C3 B5 47    jp   $47B5
4891: DD 7E 03    ld   a,(ix+character_y_offset_03)
4894: FD 96 00    sub  (iy+$00)
4897: 6F          ld   l,a
4898: FE 04       cp   $04
489A: F2 1B 48    jp   p,$481B
489D: DD 7E 02    ld   a,(ix+$02)
48A0: FD 96 00    sub  (iy+$00)
48A3: D2 C8 47    jp   nc,$47C8
48A6: DD 7E 07    ld   a,(ix+$07)
48A9: FD BE 03    cp   (iy+$03)
48AC: C8          ret  z
48AD: C3 99 49    jp   $4999
48B0: FD 7E 06    ld   a,(iy+$06)
48B3: B7          or   a
48B4: CA E2 48    jp   z,$48E2
48B7: DD 7E 05    ld   a,(ix+character_delta_x_05)
48BA: B7          or   a
48BB: CA F6 47    jp   z,$47F6
48BE: DD 7E 03    ld   a,(ix+character_y_offset_03)
48C1: FD 96 00    sub  (iy+$00)
48C4: 6F          ld   l,a
48C5: FE 04       cp   $04
48C7: F2 4C 48    jp   p,$484C
48CA: C6 30       add  a,$30
48CC: 6F          ld   l,a
48CD: DD 7E 08    ld   a,(ix+$08)
48D0: F6 80       or   $80
48D2: DD 77 08    ld   (ix+$08),a
48D5: DD 7E 02    ld   a,(ix+$02)
48D8: FD 96 00    sub  (iy+$00)
48DB: D2 F6 47    jp   nc,$47F6
48DE: 7D          ld   a,l
48DF: C3 E3 47    jp   $47E3
48E2: DD 7E 03    ld   a,(ix+character_y_offset_03)
48E5: FD 96 00    sub  (iy+$00)
48E8: 6F          ld   l,a
48E9: FE 04       cp   $04
48EB: F2 4C 48    jp   p,$484C
48EE: DD 7E 02    ld   a,(ix+$02)
48F1: FD 96 00    sub  (iy+$00)
48F4: D2 F6 47    jp   nc,$47F6
48F7: DD 7E 07    ld   a,(ix+$07)
48FA: FD BE 03    cp   (iy+$03)
48FD: C8          ret  z
48FE: C3 6B 49    jp   $496B
4901: FD 7E 06    ld   a,(iy+$06)
4904: B7          or   a
4905: CA 13 49    jp   z,$4913
4908: DD 7E 08    ld   a,(ix+$08)
490B: F6 80       or   $80
490D: DD 77 08    ld   (ix+$08),a
4910: C3 FD 47    jp   $47FD
4913: FD 7E 03    ld   a,(iy+$03)
4916: DD BE 07    cp   (ix+$07)
4919: C8          ret  z
491A: DD 7E 05    ld   a,(ix+character_delta_x_05)
491D: B7          or   a
491E: CA C8 47    jp   z,$47C8
4921: C3 99 49    jp   $4999
4924: FD 7E 06    ld   a,(iy+$06)
4927: B7          or   a
4928: CA 36 49    jp   z,$4936
492B: DD 7E 08    ld   a,(ix+$08)
492E: F6 80       or   $80
4930: DD 77 08    ld   (ix+$08),a
4933: C3 2E 48    jp   $482E
4936: FD 7E 03    ld   a,(iy+$03)
4939: DD BE 07    cp   (ix+$07)
493C: C8          ret  z
493D: DD 7E 05    ld   a,(ix+character_delta_x_05)
4940: B7          or   a
4941: CA F6 47    jp   z,$47F6
4944: C3 6B 49    jp   $496B
4947: FD 7E 06    ld   a,(iy+$06)
494A: B7          or   a
494B: CA 13 49    jp   z,$4913
494E: DD 7E 08    ld   a,(ix+$08)
4951: F6 80       or   $80
4953: DD 77 08    ld   (ix+$08),a
4956: C3 91 48    jp   $4891
4959: FD 7E 06    ld   a,(iy+$06)
495C: B7          or   a
495D: CA 36 49    jp   z,$4936
4960: DD 7E 08    ld   a,(ix+$08)
4963: F6 80       or   $80
4965: DD 77 08    ld   (ix+$08),a
4968: C3 E2 48    jp   $48E2
496B: DD 7E 09    ld   a,(ix+$09)
496E: FE 07       cp   $07
4970: C8          ret  z
4971: DD 7E 11    ld   a,(ix+$11)
4974: 3C          inc  a
4975: C2 F6 47    jp   nz,$47F6
4978: FD 7E 05    ld   a,(iy+$05)
497B: 3D          dec  a
497C: DD 77 01    ld   (ix+character_x_right_01),a
497F: D6 08       sub  $08
4981: DD 77 00    ld   (ix+character_x_00),a
4984: DD 36 0A 00 ld   (ix+$0a),$00
4988: DD 36 06 03 ld   (ix+character_situation_06),CS_FALLING_03
498C: DD 36 05 00 ld   (ix+character_delta_x_05),$00
4990: DD 7E 08    ld   a,(ix+$08)
4993: E6 7F       and  $7F
4995: DD 77 08    ld   (ix+$08),a
4998: C9          ret
4999: DD 7E 09    ld   a,(ix+$09)
499C: FE 07       cp   $07
499E: C8          ret  z
499F: DD 7E 11    ld   a,(ix+$11)
49A2: 3C          inc  a
49A3: C2 C8 47    jp   nz,$47C8
49A6: FD 7E 04    ld   a,(iy+character_state_04)
49A9: 3C          inc  a
49AA: DD 77 00    ld   (ix+character_x_00),a
49AD: C6 08       add  a,$08
49AF: DD 77 01    ld   (ix+character_x_right_01),a
49B2: C3 84 49    jp   $4984
49B5: 3A BA 85    ld   a,(current_enemy_index_85BA)
49B8: B7          or   a
49B9: 28 22       jr   z,$49DD
49BB: DD 7E 0F    ld   a,(ix+$0f)
49BE: B7          or   a
49BF: 20 1C       jr   nz,$49DD
49C1: 3A 20 85    ld   a,($8520)
49C4: B7          or   a
49C5: 28 10       jr   z,$49D7
49C7: FE 03       cp   $03
49C9: 30 0C       jr   nc,$49D7
49CB: 3A 22 85    ld   a,(player_structure_851A+8)
49CE: DD AE 08    xor  (ix+$08)
49D1: E6 7F       and  $7F
49D3: 20 02       jr   nz,$49D7
49D5: AF          xor  a
49D6: C9          ret
49D7: DD 7E 1E    ld   a,(ix+$1e)
49DA: B7          or   a
49DB: 28 F8       jr   z,$49D5
49DD: 37          scf
49DE: C9          ret
49DF: 3A BA 85    ld   a,(current_enemy_index_85BA)
49E2: B7          or   a
49E3: CA DD 49    jp   z,$49DD
49E6: DD 7E 0F    ld   a,(ix+$0f)
49E9: B7          or   a
49EA: C2 DD 49    jp   nz,$49DD
49ED: FD 7E 06    ld   a,(iy+$06)
49F0: B7          or   a
49F1: CA DD 49    jp   z,$49DD
49F4: DD 7E 1E    ld   a,(ix+$1e)
49F7: B7          or   a
49F8: 28 1B       jr   z,$4A15
49FA: DD 7E 07    ld   a,(ix+$07)
49FD: FD 96 03    sub  (iy+$03)
4A00: FE 03       cp   $03
4A02: D2 DD 49    jp   nc,$49DD
4A05: DD 7E 07    ld   a,(ix+$07)
4A08: FD 96 01    sub  (iy+$01)
4A0B: CA D5 49    jp   z,$49D5
4A0E: 3D          dec  a
4A0F: CA D5 49    jp   z,$49D5
4A12: C3 DD 49    jp   $49DD
4A15: FD 7E 02    ld   a,(iy+$02)
4A18: DD 96 07    sub  (ix+$07)
4A1B: FE 03       cp   $03
4A1D: D2 DD 49    jp   nc,$49DD
4A20: DD 7E 07    ld   a,(ix+$07)
4A23: FD 96 01    sub  (iy+$01)
4A26: CA DD 49    jp   z,$49DD
4A29: 3D          dec  a
4A2A: CA DD 49    jp   z,$49DD
4A2D: C3 D5 49    jp   $49D5
4A30: DD 72 08    ld   (ix+$08),d
4A33: CD CE 62    call load_character_elevator_structure_62CE
4A36: CD 78 4A    call $4A78
4A39: DD 7E 07    ld   a,(ix+$07)
4A3C: FD BE 03    cp   (iy+$03)
4A3F: C8          ret  z
4A40: DD 7E 09    ld   a,(ix+$09)
4A43: FE 07       cp   $07
4A45: 20 17       jr   nz,$4A5E
4A47: FD 7E 01    ld   a,(iy+$01)
4A4A: DD BE 07    cp   (ix+$07)
4A4D: D0          ret  nc
4A4E: FD 7E 04    ld   a,(iy+character_state_04)
4A51: FD 86 05    add  a,(iy+$05)
4A54: CB 1F       rr   a
4A56: DD BE 01    cp   (ix+character_x_right_01)
4A59: D0          ret  nc
4A5A: DD BE 00    cp   (ix+character_x_00)
4A5D: D8          ret  c
4A5E: DD 36 09 05 ld   (ix+$09),$05
4A62: DD 36 0A 00 ld   (ix+$0a),$00
4A66: 3A BA 85    ld   a,(current_enemy_index_85BA)
4A69: B7          or   a
4A6A: 28 06       jr   z,$4A72
4A6C: 3E 02       ld   a,$02
4A6E: 32 EC 82    ld   ($82EC),a
4A71: C9          ret
4A72: 3E 02       ld   a,$02
4A74: 32 EB 82    ld   ($82EB),a
4A77: C9          ret
4A78: DD 7E 07    ld   a,(ix+$07)
4A7B: FD 86 06    add  a,(iy+$06)
4A7E: FD 86 06    add  a,(iy+$06)
4A81: FD BE 01    cp   (iy+$01)
4A84: C0          ret  nz
4A85: DD 7E 02    ld   a,(ix+$02)
4A88: FD 96 00    sub  (iy+$00)
4A8B: D8          ret  c
4A8C: DD 36 09 05 ld   (ix+$09),$05
4A90: DD 36 0A 00 ld   (ix+$0a),$00
4A94: CD 66 4A    call $4A66
4A97: 3A BA 85    ld   a,(current_enemy_index_85BA)
4A9A: B7          or   a
4A9B: C8          ret  z
4A9C: 3A 20 85    ld   a,($8520)
4A9F: 3D          dec  a
4AA0: C0          ret  nz
4AA1: 3A 22 85    ld   a,(player_structure_851A+8)
4AA4: DD AE 08    xor  (ix+$08)
4AA7: E6 7F       and  $7F
4AA9: CC E7 56    call z,$56E7
4AAC: C9          ret
4AAD: 21 CE 81    ld   hl,$81CE
4AB0: DD 7E 07    ld   a,(ix+$07)
4AB3: B7          or   a
4AB4: C8          ret  z
4AB5: 87          add  a,a
4AB6: 87          add  a,a
4AB7: 6F          ld   l,a
4AB8: 26 00       ld   h,$00
4ABA: 29          add  hl,hl
4ABB: 29          add  hl,hl
4ABC: 29          add  hl,hl
4ABD: 11 E3 16    ld   de,table_16E3
4AC0: 19          add  hl,de
4AC1: C9          ret
4AC2: DD 7E 09    ld   a,(ix+$09)
4AC5: FE 03       cp   $03
4AC7: D0          ret  nc
4AC8: DD 7E 1B    ld   a,(ix+$1b)
4ACB: B7          or   a
4ACC: C8          ret  z
4ACD: 2A BB 85    ld   hl,($85BB)
4AD0: 7E          ld   a,(hl)
4AD1: 3C          inc  a
4AD2: C0          ret  nz
4AD3: DD 7E 07    ld   a,(ix+$07)
4AD6: FE 10       cp   $10
4AD8: CA F7 4A    jp   z,$4AF7
4ADB: D8          ret  c
4ADC: FE 11       cp   $11
4ADE: CA FB 4A    jp   z,$4AFB
4AE1: FE 14       cp   $14
4AE3: CA 07 4B    jp   z,$4B07
4AE6: D0          ret  nc
4AE7: CD 0F 4B    call $4B0F
4AEA: C8          ret  z
4AEB: CD 3B 4B    call $4B3B
4AEE: C8          ret  z
4AEF: CD 59 4B    call $4B59
4AF2: C8          ret  z
4AF3: CD 77 4B    call $4B77
4AF6: C9          ret
4AF7: CD 0F 4B    call $4B0F
4AFA: C9          ret
4AFB: CD 0F 4B    call $4B0F
4AFE: C8          ret  z
4AFF: CD 3B 4B    call $4B3B
4B02: C8          ret  z
4B03: CD 59 4B    call $4B59
4B06: C9          ret
4B07: CD 3B 4B    call $4B3B
4B0A: C8          ret  z
4B0B: CD 77 4B    call $4B77
4B0E: C9          ret
4B0F: DD 7E 0D    ld   a,(ix+move_direction_0d)
4B12: 2F          cpl
4B13: CB 5F       bit  3,a
4B15: C0          ret  nz
4B16: DD 7E 00    ld   a,(ix+character_x_00)
4B19: FE BF       cp   $BF
4B1B: DA 37 4B    jp   c,$4B37
4B1E: FE C7       cp   $C7
4B20: D2 37 4B    jp   nc,$4B37
4B23: DD 36 0B 01 ld   (ix+$0b),$01
4B27: DD 36 05 01 ld   (ix+character_delta_x_05),$01
4B2B: DD 36 06 04 ld   (ix+character_situation_06),CS_IN_STAIRS_04
4B2F: AF          xor  a
4B30: DD 77 04    ld   (ix+$04),a
4B33: DD 77 0A    ld   (ix+$0a),a
4B36: C9          ret
4B37: 3E 01       ld   a,$01
4B39: B7          or   a
4B3A: C9          ret
4B3B: DD 7E 0D    ld   a,(ix+move_direction_0d)
4B3E: 2F          cpl
4B3F: CB 57       bit  2,a
4B41: C0          ret  nz
4B42: DD 7E 00    ld   a,(ix+character_x_00)
4B45: FE E4       cp   $E4
4B47: DA 37 4B    jp   c,$4B37
4B4A: FE EC       cp   $EC
4B4C: D2 37 4B    jp   nc,$4B37
4B4F: DD 36 0B 00 ld   (ix+$0b),$00
4B53: DD 36 05 FF ld   (ix+character_delta_x_05),$FF
4B57: 18 D2       jr   $4B2B
4B59: DD 7E 0D    ld   a,(ix+move_direction_0d)
4B5C: 2F          cpl
4B5D: CB 5F       bit  3,a
4B5F: C0          ret  nz
4B60: DD 7E 00    ld   a,(ix+character_x_00)
4B63: FE 2A       cp   $2A
4B65: DA 37 4B    jp   c,$4B37
4B68: FE 32       cp   $32
4B6A: D2 37 4B    jp   nc,$4B37
4B6D: DD 36 0B 00 ld   (ix+$0b),$00
4B71: DD 36 05 01 ld   (ix+character_delta_x_05),$01
4B75: 18 B4       jr   $4B2B
4B77: DD 7E 0D    ld   a,(ix+move_direction_0d)
4B7A: 2F          cpl
4B7B: CB 57       bit  2,a
4B7D: C0          ret  nz
4B7E: DD 7E 00    ld   a,(ix+character_x_00)
4B81: FE 04       cp   $04
4B83: DA 37 4B    jp   c,$4B37
4B86: FE 0C       cp   $0C
4B88: D2 37 4B    jp   nc,$4B37
4B8B: DD 36 0B 01 ld   (ix+$0b),$01
4B8F: DD 36 05 FF ld   (ix+character_delta_x_05),$FF
4B93: 18 96       jr   $4B2B
4B95: 06 07       ld   b,$07
4B97: 11 08 00    ld   de,protection_crap_0008
4B9A: 21 FF 82    ld   hl,$82FF
4B9D: 36 FF       ld   (hl),$FF
4B9F: 19          add  hl,de
4BA0: 10 FB       djnz $4B9D
4BA2: 06 07       ld   b,$07
4BA4: 11 05 00    ld   de,$0005
4BA7: 21 23 81    ld   hl,$8123
4BAA: 36 FF       ld   (hl),$FF
4BAC: 19          add  hl,de
4BAD: 10 FB       djnz $4BAA
4BAF: 21 F6 82    ld   hl,$82F6
4BB2: AF          xor  a
4BB3: 06 07       ld   b,$07
4BB5: 77          ld   (hl),a
4BB6: 23          inc  hl
4BB7: 10 FC       djnz $4BB5
4BB9: C9          ret

update_bullets_4bba:
4BBA: DD 21 FD 82 ld   ix,$82FD
4BBE: 21 23 81    ld   hl,$8123
4BC1: 22 36 83    ld   ($8336),hl
4BC4: AF          xor  a
4BC5: 32 35 83    ld   ($8335),a
4BC8: CD E7 4B    call update_bullet_4be7
4BCB: 11 08 00    ld   de,protection_crap_0008
4BCE: DD 19       add  ix,de
4BD0: 2A 36 83    ld   hl,($8336)
4BD3: 11 05 00    ld   de,$0005
4BD6: 19          add  hl,de
4BD7: 22 36 83    ld   ($8336),hl
4BDA: 3A 35 83    ld   a,($8335)
4BDD: 3C          inc  a
4BDE: 32 35 83    ld   ($8335),a
4BE1: FE 07       cp   $07
4BE3: C2 C8 4B    jp   nz,$4BC8
4BE6: C9          ret

update_bullet_4be7:
4BE7: 3A 35 83    ld   a,($8335)
4BEA: 21 F6 82    ld   hl,$82F6
4BED: 5F          ld   e,a
4BEE: 16 00       ld   d,$00
4BF0: 19          add  hl,de
4BF1: 4E          ld   c,(hl)
4BF2: DD 7E 02    ld   a,(ix+$02)
4BF5: B9          cp   c
4BF6: DA 0A 4C    jp   c,$4C0A
4BF9: CA 11 4C    jp   z,$4C11
4BFC: FE FB       cp   $FB
4BFE: CA 78 4C    jp   z,bullet_flies_4c78
4C01: FE FE       cp   $FE
4C03: DA 9C 4C    jp   c,bullet_hits_wall_4c9c
4C06: CA B0 4C    jp   z,$4CB0
4C09: C9          ret
4C0A: DD 34 02    inc  (ix+$02)
4C0D: CD 54 50    call handle_shoot_5054
4C10: C9          ret
4C11: DD 36 02 FB ld   (ix+$02),$FB
4C15: CD 54 50    call handle_shoot_5054
4C18: 06 10       ld   b,$10
4C1A: C5          push bc
4C1B: 3A F4 82    ld   a,($82F4)
4C1E: 2A F2 82    ld   hl,($82F2)
4C21: AD          xor  l
4C22: 96          sub  (hl)
4C23: 32 F4 82    ld   ($82F4),a
4C26: 23          inc  hl
4C27: 22 F2 82    ld   ($82F2),hl
4C2A: 01 0A 80    ld   bc,$800A
4C2D: 09          add  hl,bc
4C2E: 30 17       jr   nc,$4C47
4C30: 22 F2 82    ld   ($82F2),hl
4C33: 21 F4 82    ld   hl,$82F4
4C36: 3A F8 7F    ld   a,(table_7FF8)
4C39: 00          nop
4C3A: AE          xor  (hl)
4C3B: 77          ld   (hl),a
4C3C: 28 09       jr   z,$4C47
4C3E: 21 B1 82    ld   hl,$82B1
4C41: 06 00       ld   b,$00
4C43: 0E 44       ld   c,$44
4C45: 09          add  hl,bc
4C46: 71          ld   (hl),c
4C47: C1          pop  bc
4C48: 10 D0       djnz $4C1A
4C4A: 2A 36 83    ld   hl,($8336)
4C4D: 7E          ld   a,(hl)
4C4E: 3C          inc  a
4C4F: C8          ret  z
4C50: 11 03 00    ld   de,$0003
4C53: 19          add  hl,de
4C54: 7E          ld   a,(hl)
4C55: E6 FB       and  $FB
4C57: 77          ld   (hl),a
4C58: 23          inc  hl
4C59: 34          inc  (hl)
4C5A: DD 7E 07    ld   a,(ix+$07)
4C5D: B7          or   a
4C5E: 20 0F       jr   nz,$4C6F
4C60: 7E          ld   a,(hl)
4C61: D6 73       sub  $73
4C63: CB 2F       sra  a
4C65: C6 70       add  a,$70
4C67: 77          ld   (hl),a
4C68: 3E 91       ld   a,$91	; player shot
4C6A: CD 56 36    call play_sound_3656
4C6D: 18 05       jr   $4C74

4C6F: 3E 92       ld   a,$92		; enemy shot
4C71: CD 56 36    call play_sound_3656
4C74: CD B9 4C    call $4CB9
4C77: C9          ret

bullet_flies_4c78:
4C78: 2A 36 83    ld   hl,($8336)
4C7B: 36 04       ld   (hl),$04
4C7D: 23          inc  hl
4C7E: 7E          ld   a,(hl)
4C7F: DD 86 03    add  a,(ix+character_y_offset_03)
4C82: 77          ld   (hl),a
4C83: 23          inc  hl
4C84: 3A 04 80    ld   a,(scroll_speed_8004)
4C87: ED 44       neg
4C89: 86          add  a,(hl)
4C8A: 77          ld   (hl),a
4C8B: 23          inc  hl
4C8C: 23          inc  hl
4C8D: 36 78       ld   (hl),$78
4C8F: DD 7E 04    ld   a,(ix+$04)
4C92: DD 86 03    add  a,(ix+character_y_offset_03)
4C95: DD 77 04    ld   (ix+$04),a
4C98: CD B9 4C    call $4CB9
4C9B: C9          ret

bullet_hits_wall_4c9c:
4C9C: DD 34 02    inc  (ix+$02)
4C9F: 2A 36 83    ld   hl,($8336)
4CA2: 23          inc  hl
4CA3: 23          inc  hl
4CA4: 3A 04 80    ld   a,(scroll_speed_8004)
4CA7: ED 44       neg
4CA9: 86          add  a,(hl)
4CAA: 77          ld   (hl),a
4CAB: 23          inc  hl
4CAC: 23          inc  hl
4CAD: 36 79       ld   (hl),$79
4CAF: C9          ret
4CB0: DD 34 02    inc  (ix+$02)
4CB3: 2A 36 83    ld   hl,($8336)
4CB6: 36 FF       ld   (hl),$FF
4CB8: C9          ret

4CB9: AF          xor  a
4CBA: 32 39 83    ld   ($8339),a
4CBD: 06 FF       ld   b,$FF
4CBF: DD 7E 03    ld   a,(ix+character_y_offset_03)
4CC2: B7          or   a
4CC3: F2 C8 4C    jp   p,$4CC8
4CC6: 06 00       ld   b,$00
4CC8: 78          ld   a,b
4CC9: 32 38 83    ld   ($8338),a
4CCC: CD B4 06    call $06B4
4CCF: CD EE 07    call $07EE
4CD2: 3A 35 83    ld   a,($8335)
4CD5: FE 03       cp   $03
4CD7: D2 DD 4C    jp   nc,$4CDD
4CDA: CD 4C 08    call $084C
4CDD: CD B4 08    call $08B4
4CE0: 3A 39 83    ld   a,($8339)
4CE3: B7          or   a
4CE4: C8          ret  z
4CE5: 2A 36 83    ld   hl,($8336)
4CE8: 11 04 00    ld   de,$0004
4CEB: 19          add  hl,de
4CEC: 36 79       ld   (hl),$79
4CEE: 3D          dec  a
4CEF: CA FA 4C    jp   z,$4CFA
4CF2: D6 02       sub  $02
4CF4: CA 33 4D    jp   z,fire_bullet_4d33
4CF7: C3 53 4D    jp   $4D53
4CFA: FD 2A 3A 83 ld   iy,($833A)
4CFE: FD 7E 09    ld   a,(iy+$09)
4D01: FE 07       cp   $07
4D03: 28 05       jr   z,$4D0A
4D05: FE 05       cp   $05
4D07: D2 58 4D    jp   nc,$4D58
4D0A: FD 7E 06    ld   a,(iy+$06)
4D0D: FE 03       cp   $03
4D0F: D2 58 4D    jp   nc,$4D58
4D12: FD 36 0A 00 ld   (iy+$0a),$00
4D16: FD 36 09 05 ld   (iy+$09),$05		; character (player or enemy) hit: set death state
4D1A: DD 7E 07    ld   a,(ix+$07)
4D1D: B7          or   a
4D1E: 28 08       jr   z,$4D28
4D20: 3E C4       ld   a,$C4		; player killed (shot) sound
4D22: CD 56 36    call play_sound_3656
4D25: C3 58 4D    jp   $4D58

4D28: 3E 3A       ld   a,$3A		; enemy killed sound
4D2A: CD 56 36    call play_sound_3656
4D2D: CD 94 56    call $5694
4D30: C3 58 4D    jp   $4D58

fire_bullet_4d33:
4D33: FD 2A 3A 83 ld   iy,($833A)
4D37: DD 7E 00    ld   a,(ix+character_x_00)
4D3A: FD 77 00    ld   (iy+$00),a
4D3D: FD 36 02 00 ld   (iy+$02),$00
4D41: 06 48       ld   b,$48
4D43: DD 7E 04    ld   a,(ix+$04)
4D46: FE 80       cp   $80
4D48: DA 4D 4D    jp   c,$4D4D
4D4B: 06 A8       ld   b,$A8
4D4D: FD 70 03    ld   (iy+$03),b
4D50: C3 58 4D    jp   $4D58
4D53: 3E 93       ld   a,$93		; bullet hits wall
4D55: CD 56 36    call play_sound_3656
4D58: DD 36 02 FC ld   (ix+$02),$FC
4D5C: 3A 38 83    ld   a,($8338)
4D5F: DD 46 04    ld   b,(ix+$04)
4D62: DD 77 04    ld   (ix+$04),a
4D65: 90          sub  b
4D66: DD 96 03    sub  (ix+character_y_offset_03)
4D69: 2A 36 83    ld   hl,($8336)
4D6C: 23          inc  hl
4D6D: 86          add  a,(hl)
4D6E: 77          ld   (hl),a
4D6F: C9          ret

player_arriving_on_roof_anim_4d70:
4D70: AF          xor  a
4D71: 32 AB 80    ld   ($80AB),a
4D74: 3E 1F       ld   a,$1F
4D76: 32 2C 80    ld   ($802C),a
4D79: CD 6F 4E    call init_everything_4e6f
4D7C: AF          xor  a
4D7D: 32 3C 83    ld   ($833C),a
4D80: 32 3D 83    ld   ($833D),a
4D83: CD CF 73    call game_tick_73cf
4D86: 21 3C 83    ld   hl,$833C
4D89: 34          inc  (hl)
4D8A: 7E          ld   a,(hl)
4D8B: FE 14       cp   $14
4D8D: DA 83 4D    jp   c,$4D83
4D90: 3E C2       ld   a,$C2	; sound of grappine thrown on roof
4D92: 32 0B D5    ld   (sound_latch_D50B),a
4D95: AF          xor  a
4D96: 32 3C 83    ld   ($833C),a
4D99: CD AC 4E    call update_grappling_hook_tiles_4eac
4D9C: CD CF 73    call game_tick_73cf
4D9F: 21 3C 83    ld   hl,$833C
4DA2: 34          inc  (hl)
4DA3: 7E          ld   a,(hl)
4DA4: FE 0D       cp   $0D
4DA6: DA 99 4D    jp   c,$4D99
4DA9: AF          xor  a
4DAA: 32 3C 83    ld   ($833C),a
4DAD: CD E7 4E    call grappling_wire_in_tension_4ee7
4DB0: CD CF 73    call game_tick_73cf
4DB3: 21 3C 83    ld   hl,$833C
4DB6: 34          inc  (hl)
4DB7: 7E          ld   a,(hl)
4DB8: FE 07       cp   $07
4DBA: DA AD 4D    jp   c,$4DAD
4DBD: AF          xor  a
4DBE: 32 3C 83    ld   ($833C),a
4DC1: CD 13 4F    call compute_player_sliding_on_wire_sprites_4f13
4DC4: CD CF 73    call game_tick_73cf
4DC7: 21 3C 83    ld   hl,$833C
4DCA: 34          inc  (hl)
4DCB: 7E          ld   a,(hl)
4DCC: FE 12       cp   $12
4DCE: DA C1 4D    jp   c,$4DC1
4DD1: AF          xor  a
4DD2: 32 3C 83    ld   ($833C),a
4DD5: CD 4F 4F    call player_sliding_slowing_down_4f4f
4DD8: CD CF 73    call game_tick_73cf
4DDB: 21 3C 83    ld   hl,$833C
4DDE: 34          inc  (hl)
4DDF: 7E          ld   a,(hl)
4DE0: FE 10       cp   $10
4DE2: DA D5 4D    jp   c,$4DD5
4DE5: AF          xor  a
4DE6: 32 3C 83    ld   ($833C),a
4DE9: CD 5D 4F    call player_releases_wire_4f5d
4DEC: CD CF 73    call game_tick_73cf
4DEF: 21 3C 83    ld   hl,$833C
4DF2: 34          inc  (hl)
4DF3: 7E          ld   a,(hl)
4DF4: FE 09       cp   $09
4DF6: DA E9 4D    jp   c,$4DE9
4DF9: AF          xor  a
4DFA: 32 3C 83    ld   ($833C),a
4DFD: CD C7 4F    call player_checking_surroundings_4fc7
4E00: CD CF 73    call game_tick_73cf
4E03: 21 3C 83    ld   hl,$833C
4E06: 34          inc  (hl)
4E07: 7E          ld   a,(hl)
4E08: FE 1A       cp   $1A
4E0A: DA FD 4D    jp   c,$4DFD
4E0D: CD 3F 36    call start_music_if_in_game_363f
4E10: CD 14 4E    call force_player_into_elevator_4e14
4E13: C9          ret

force_player_into_elevator_4e14:
4E14: 3E 05       ld   a,GS_IN_GAME_05
4E16: 32 AC 80    ld   (game_state_80AC),a
4E19: CD 3A 2F    call $2F3A
4E1C: CD AD 31    call $31AD
4E1F: CD 87 12    call init_moving_door_slots_1287
4E22: CD DC 0B    call $0BDC
4E25: CD 95 4B    call $4B95
4E28: CD 72 2F    call set_player_initial_state_2f72
4E2B: AF          xor  a
4E2C: 32 3C 83    ld   ($833C),a
4E2F: FB          ei
4E30: 21 3C 83    ld   hl,$833C
4E33: 7E          ld   a,(hl)
4E34: 34          inc  (hl)
4E35: FE 08       cp   $08
4E37: 30 07       jr   nc,$4E40
4E39: 3E 02       ld   a,$02			; force move right
4E3B: 32 27 85    ld   (player_move_direction_8527),a
4E3E: 18 17       jr   $4E57
4E40: AF          xor  a
4E41: 32 27 85    ld   (player_move_direction_8527),a	; no move
4E44: 3A CE 83    ld   a,($83CE)
4E47: FE 1E       cp   $1E
4E49: 20 07       jr   nz,$4E52
4E4B: 3A CD 83    ld   a,($83CD)
4E4E: B7          or   a
4E4F: 20 06       jr   nz,$4E57
4E51: C9          ret
4E52: 3E 04       ld   a,$04
4E54: 32 27 85    ld   (player_move_direction_8527),a
4E57: CD 7F 01    call handle_main_scrolling_017F
4E5A: CD BF 0E    call handle_elevators_0EBF
4E5D: CD A2 12    call handle_enemies_12A2
4E60: CD E8 2F    call $2FE8
4E63: CD E1 0B    call $0BE1
4E66: CD A0 15    call update_sprite_shadow_ram_15a0
4E69: CD CF 73    call game_tick_73cf
4E6C: C3 30 4E    jp   $4E30

init_everything_4e6f:
4E6F: 21 3E 83    ld   hl,$833E
4E72: 06 08       ld   b,$08
4E74: 36 00       ld   (hl),$00
4E76: 23          inc  hl
4E77: 10 FB       djnz $4E74
4E79: 21 4B 83    ld   hl,$834B
4E7C: 22 46 83    ld   ($8346),hl
4E7F: 22 49 83    ld   ($8349),hl
4E82: CD E1 71    call check_if_must_flip_screen_71e1
4E85: AF          xor  a
4E86: 32 D9 81    ld   (menu_or_game_tiles_81D9),a
4E89: CD 0C 26    call init_hw_scroll_and_charset_260C
4E8C: 3E 04       ld   a,GS_GAME_STARTING_04
4E8E: 32 AC 80    ld   (game_state_80AC),a
4E91: CD 3E 2A    call init_level_skill_params_2A2E
4E94: CD 2E 58    call display_bottom_bricks_582e
4E97: CD 00 27    call init_building_2700
4E9A: CD 65 2A    call init_elevators_2a65
4E9D: CD 01 58    call display_nb_lives_5801
4EA0: CD C6 57    call update_upper_status_bar_57C6
4EA3: 3E 05       ld   a,$05
4EA5: 32 A9 80    ld   (timer_8bit_reload_value_80A9),a
4EA8: CD C2 26    call reload_8bit_tiimer_26C2
4EAB: C9          ret

update_grappling_hook_tiles_4eac:
4EAC: 3A 3C 83    ld   a,($833C)
4EAF: 47          ld   b,a
4EB0: E6 FE       and  $FE
4EB2: 87          add  a,a
4EB3: 87          add  a,a
4EB4: 87          add  a,a
4EB5: 87          add  a,a
4EB6: 80          add  a,b
4EB7: 5F          ld   e,a
4EB8: 16 00       ld   d,$00
4EBA: 21 C0 C8    ld   hl,$C8C0
4EBD: 19          add  hl,de
4EBE: 22 46 83    ld   ($8346),hl
4EC1: 11 FE 98    ld   de,$98FE
4EC4: 23          inc  hl
4EC5: CB 40       bit  0,b
4EC7: CA D1 4E    jp   z,$4ED1
4ECA: 01 20 00    ld   bc,$0020
4ECD: 09          add  hl,bc
4ECE: 11 FD 99    ld   de,$99FD
4ED1: 3A 3C 83    ld   a,($833C)
4ED4: FE 0C       cp   $0C
4ED6: C2 DB 4E    jp   nz,$4EDB
4ED9: 1E 9C       ld   e,$9C
4EDB: 22 49 83    ld   ($8349),hl
4EDE: 7A          ld   a,d
4EDF: 32 48 83    ld   ($8348),a
4EE2: 7B          ld   a,e
4EE3: 32 4B 83    ld   ($834B),a
4EE6: C9          ret

grappling_wire_in_tension_4ee7:
4EE7: 3A 3C 83    ld   a,($833C)
4EEA: 47          ld   b,a
4EEB: 87          add  a,a
4EEC: 87          add  a,a
4EED: 87          add  a,a
4EEE: 87          add  a,a
4EEF: 87          add  a,a
4EF0: 80          add  a,b
4EF1: 80          add  a,b
4EF2: 5F          ld   e,a
4EF3: 16 00       ld   d,$00
4EF5: 21 C0 C8    ld   hl,$C8C0
4EF8: 19          add  hl,de
4EF9: 22 46 83    ld   ($8346),hl
4EFC: 23          inc  hl
4EFD: 22 49 83    ld   ($8349),hl
4F00: 3E 9A       ld   a,$9A
4F02: 32 48 83    ld   ($8348),a
4F05: 3C          inc  a
4F06: 32 4B 83    ld   ($834B),a
4F09: 78          ld   a,b
4F0A: FE 06       cp   $06
4F0C: D8          ret  c
4F0D: 3E 9C       ld   a,$9C
4F0F: 32 4B 83    ld   ($834B),a
4F12: C9          ret

compute_player_sliding_on_wire_sprites_4f13:
4F13: 3A 3C 83    ld   a,($833C)
4F16: 87          add  a,a
4F17: 47          ld   b,a
4F18: 87          add  a,a
4F19: C6 F0       add  a,$F0
4F1B: 4F          ld   c,a
4F1C: 3E C8       ld   a,$C8
4F1E: 90          sub  b
4F1F: 47          ld   b,a
4F20: 21 3E 83    ld   hl,$833E
4F23: 36 F0       ld   (hl),$F0
4F25: 23          inc  hl
4F26: 70          ld   (hl),b
4F27: 23          inc  hl
4F28: 36 04       ld   (hl),$04
4F2A: 23          inc  hl
4F2B: 36 02       ld   (hl),$02
4F2D: 23          inc  hl
4F2E: 71          ld   (hl),c
4F2F: 23          inc  hl
4F30: 70          ld   (hl),b
4F31: 23          inc  hl
4F32: 36 00       ld   (hl),$00
4F34: 23          inc  hl
4F35: 36 4D       ld   (hl),$4D
4F37: 21 3E 83    ld   hl,$833E
4F3A: CD 40 4F    call $4F40
4F3D: 21 42 83    ld   hl,$8342
4F40: 3A D8 81    ld   a,($81D8)
4F43: B7          or   a
4F44: C2 4A 4F    jp   nz,$4F4A
4F47: 34          inc  (hl)
4F48: 34          inc  (hl)
4F49: C9          ret
4F4A: 35          dec  (hl)
4F4B: 23          inc  hl
4F4C: 35          dec  (hl)
4F4D: 35          dec  (hl)
4F4E: C9          ret

player_sliding_slowing_down_4f4f:
4F4F: 21 42 83    ld   hl,$8342
4F52: 34          inc  (hl)
4F53: 34          inc  (hl)
4F54: 23          inc  hl
4F55: 35          dec  (hl)
4F56: 23          inc  hl
4F57: 23          inc  hl
4F58: 3E 99       ld   a,$99
4F5A: 96          sub  (hl)
4F5B: 77          ld   (hl),a
4F5C: C9          ret

player_releases_wire_4f5d:
4F5D: 3A 3C 83    ld   a,($833C)
4F60: 87          add  a,a
4F61: 87          add  a,a
4F62: 87          add  a,a
4F63: 5F          ld   e,a
4F64: 16 00       ld   d,$00
4F66: 21 7F 4F    ld   hl,table_4F7F
4F69: 19          add  hl,de
4F6A: 11 3E 83    ld   de,$833E
4F6D: 01 08 00    ld   bc,protection_crap_0008
4F70: ED B0       ldir
4F72: 21 3E 83    ld   hl,$833E
4F75: CD 40 4F    call $4F40
4F78: 21 42 83    ld   hl,$8342
4F7B: CD 40 4F    call $4F40
4F7E: C9          ret

table_4F7F:
	dc.b	53       
	dc.b	94       
	dc.b	01 44 00 
	dc.b	00       
	dc.b	00       
	dc.b	00       
	dc.b	54       
	dc.b	93       
	dc.b	01 44 00 
	dc.b	00       
	dc.b	00       
	dc.b	00       
	dc.b	55       
	dc.b	91       
	dc.b	01 44 00 
	dc.b	00       
	dc.b	00       
	dc.b	00       
	dc.b	56       
	dc.b	8E       
	dc.b	01 44 00 
	dc.b	00       
	dc.b	00       
	dc.b	00       
	dc.b	57       
	dc.b	86       
	dc.b	01 43 57 
	dc.b	96       
	dc.b	01 4E 59 
	dc.b	81       
	dc.b	01 43 59 
	dc.b	91       
	dc.b	01 4E 5A 
	dc.b	7B       
	dc.b	01 43 5A 
	dc.b	8B       
	dc.b	01 4E 5B 
	dc.b	6E       
	dc.b	01 43 5B 
	dc.b	7E       
	dc.b	01 4E 60 
	dc.b	6E       
	dc.b	01 42 00 
	dc.b	00       
	dc.b	00       
	dc.b	00 
	
player_checking_surroundings_4fc7:
4FC7: 3A 3C 83    ld   a,($833C)
4FCA: 32 3D 83    ld   ($833D),a
4FCD: E6 F8       and  $F8
4FCF: 5F          ld   e,a
4FD0: 16 00       ld   d,$00
4FD2: 21 EB 4F    ld   hl,table_4FEB
4FD5: 19          add  hl,de
4FD6: 11 3E 83    ld   de,$833E
4FD9: 01 08 00    ld   bc,protection_crap_0008
4FDC: ED B0       ldir
4FDE: 21 3E 83    ld   hl,$833E
4FE1: CD 40 4F    call $4F40
4FE4: 21 42 83    ld   hl,$8342
4FE7: CD 40 4F    call $4F40
4FEA: C9          ret

table_4FEB:
	dc.b	60      
	dc.b	6E      
	dc.b	01 42 00
	dc.b	00      
	dc.b	00      
	dc.b	00      
	dc.b	5C      
	dc.b	6E      
	dc.b	00      
	dc.b	42      
	dc.b	00      
	dc.b	00      
	dc.b	00      
	dc.b	00      
	dc.b	60      
	dc.b	6E      
	dc.b	01 42 00
	dc.b	00      
	dc.b	00      
	dc.b	00      
	dc.b	5C      
	dc.b	6E      
	dc.b	01 41 5D
	dc.b	7E      
	dc.b	01 4E 
	
500B: 21 3E 83    ld   hl,$833E                                       
500C: 3E 83       ld   a,$83			; why??
500E: 11 00 D1    ld   de,sprite_ram_d100
5011: 01 08 00    ld   bc,protection_crap_0008
5014: ED B0       ldir
5016: 3A 3D 83    ld   a,($833D)
5019: B7          or   a
501A: CA 26 50    jp   z,display_grappling_wire_5026
501D: 3D          dec  a
501E: CA 35 50    jp   z,erase_grappling_wire_5035
5021: 3D          dec  a
5022: CA 43 50    jp   z,erase_grappling_wire_5043
5025: C9          ret

display_grappling_wire_5026:
5026: 2A 46 83    ld   hl,($8346)
5029: 3A 48 83    ld   a,($8348)
502C: 77          ld   (hl),a
502D: 2A 49 83    ld   hl,($8349)
5030: 3A 4B 83    ld   a,($834B)
5033: 77          ld   (hl),a
5034: C9          ret

erase_grappling_wire_5035:
5035: 21 C0 C8    ld   hl,$C8C0
5038: 11 22 00    ld   de,$0022
503B: 06 07       ld   b,$07
503D: 36 40       ld   (hl),$40
503F: 19          add  hl,de
5040: 10 FB       djnz $503D
5042: C9          ret

erase_grappling_wire_5043:
5043: 21 C1 C8    ld   hl,$C8C1
5046: 11 22 00    ld   de,$0022
5049: 06 06       ld   b,$06
504B: CD 3D 50    call $503D
504E: 3E 41       ld   a,$41
5050: 32 8D C9    ld   ($C98D),a
5053: C9          ret

handle_shoot_5054:
5054: DD E5       push ix
5056: DD 5E 05    ld   e,(ix+character_delta_x_05)
5059: DD 56 06    ld   d,(ix+character_situation_06)
505C: D5          push de
505D: DD E1       pop  ix
505F: DD 7E 09    ld   a,(ix+$09)
5062: FE 07       cp   $07
5064: 28 05       jr   z,$506B
5066: FE 05       cp   $05
5068: D2 A0 50    jp   nc,character_falling_50A0
506B: DD 7E 06    ld   a,(ix+character_situation_06)
506E: FE 03       cp   CS_FALLING_03
5070: CA A0 50    jp   z,character_falling_50A0
5073: CD 10 51    call $5110
5076: CD AC 50    call compute_d5_from_table_50ac
5079: DD E1       pop  ix
507B: DD 70 00    ld   (ix+character_x_00),b
507E: DD 71 01    ld   (ix+character_x_right_01),c
5081: DD 72 04    ld   (ix+$04),d
5084: 43          ld   b,e
5085: DD 7E 07    ld   a,(ix+$07)
5088: B7          or   a
5089: CA 99 50    jp   z,$5099
508C: 3A 4C 83    ld   a,($834C)
508F: 47          ld   b,a
5090: ED 44       neg
5092: 4F          ld   c,a
5093: 7B          ld   a,e
5094: B7          or   a
5095: F2 99 50    jp   p,$5099
5098: 41          ld   b,c
5099: DD 70 03    ld   (ix+character_y_offset_03),b
509C: CD 53 51    call $5153
509F: C9          ret

character_falling_50A0:
50A0: DD E1       pop  ix
50A2: DD 36 02 FF ld   (ix+$02),$FF
50A6: 2A 36 83    ld   hl,($8336)
50A9: 36 FF       ld   (hl),$FF
50AB: C9          ret

compute_d5_from_table_50ac:
50AC: 21 D8 50    ld   hl,table_50D8
50AF: DD 7E 0C    ld   a,(ix+$0c)
50B2: FE 07       cp   $07
50B4: 38 02       jr   c,$50B8
50B6: D6 03       sub  $03
50B8: 87          add  a,a
50B9: DD 86 0B    add  a,(ix+$0b)
50BC: 87          add  a,a
50BD: 87          add  a,a
50BE: 5F          ld   e,a
50BF: 16 00       ld   d,$00
50C1: 19          add  hl,de
50C2: 7E          ld   a,(hl)
50C3: 23          inc  hl
50C4: 81          add  a,c
50C5: FE 30       cp   $30
50C7: DA CD 50    jp   c,$50CD
50CA: D6 30       sub  $30
50CC: 04          inc  b
50CD: 4F          ld   c,a
50CE: 7E          ld   a,(hl)
50CF: 23          inc  hl
50D0: DD 86 00    add  a,(ix+character_x_00)
50D3: 57          ld   d,a
50D4: 5E          ld   e,(hl)
50D5: 23          inc  hl
50D6: 66          ld   h,(hl)
50D7: C9          ret

table_50D8:
	dc.b	0F          
	dc.b	FE F8       
	dc.b	72          
	dc.b	0F          
	dc.b	0B          
	dc.b	08          
	dc.b	72          
	dc.b	0F          
	dc.b	FE F8       
	dc.b	72          
	dc.b	0F          
	dc.b	0B          
	dc.b	08          
	dc.b	72          
	dc.b	09          
	dc.b	FE F8       
	dc.b	74          
	dc.b	09          
	dc.b	0B          
	dc.b	08          
	dc.b	74          
	dc.b	0C          
	dc.b	FE F8       
	dc.b	72          
	dc.b	0C          
	dc.b	0B          
	dc.b	08          
	dc.b	72          
	dc.b	0C          
	dc.b	FE F8       
	dc.b	00          
	dc.b	0C          
	dc.b	0B          
	dc.b	08          
	dc.b	00          
	dc.b	06 FE       
	dc.b	F8          
	dc.b	74          
	dc.b	06 0B       
	dc.b	08          
	dc.b	74          
	dc.b	03          
	dc.b	FE F8       
	dc.b	76          
	dc.b	03          
	dc.b	15          
	dc.b	08          
	dc.b	76          

5110: DD 7E 06    ld   a,(ix+character_situation_06)
5113: B7          or   a
5114: CA 4C 51    jp   z,character_on_ground_514C
5117: 3D          dec  a
5118: CA 34 51    jp   z,character_in_elevator_5134

511B: CD CE 62    call load_character_elevator_structure_62CE
511E: DD 7E 08    ld   a,(ix+$08)
5121: E6 80       and  $80
5123: 07          rlca
5124: 07          rlca
5125: ED 44       neg
5127: FD 86 01    add  a,(iy+$01)
512A: 3C          inc  a
512B: 47          ld   b,a
512C: DD 7E 03    ld   a,(ix+character_y_offset_03)
512F: FD 86 00    add  a,(iy+$00)
5132: 4F          ld   c,a
5133: C9          ret

character_in_elevator_5134:
5134: CD CE 62    call load_character_elevator_structure_62CE
5137: DD 7E 08    ld   a,(ix+$08)
513A: E6 80       and  $80
513C: 07          rlca
513D: 07          rlca
513E: ED 44       neg
5140: FD 86 01    add  a,(iy+$01)
5143: 47          ld   b,a
5144: DD 7E 03    ld   a,(ix+character_y_offset_03)
5147: FD 86 00    add  a,(iy+$00)
514A: 4F          ld   c,a
514B: C9          ret

character_on_ground_514C:
514C: DD 46 07    ld   b,(ix+$07)
514F: DD 4E 03    ld   c,(ix+character_y_offset_03)
5152: C9          ret

5153: 4C          ld   c,h
5154: 2A 36 83    ld   hl,($8336)
5157: 11 04 00    ld   de,$0004
515A: 19          add  hl,de
515B: 71          ld   (hl),c
515C: DD 46 00    ld   b,(ix+character_x_00)
515F: 0E 00       ld   c,$00
5161: DD 56 01    ld   d,(ix+character_x_right_01)
5164: CD 6C 1E    call compute_delta_height_1e6c
5167: 7C          ld   a,h
5168: B7          or   a
5169: C2 9D 51    jp   nz,$519D
516C: 7D          ld   a,l
516D: D6 08       sub  $08
516F: 4F          ld   c,a
5170: 2A 36 83    ld   hl,($8336)
5173: 36 00       ld   (hl),$00
5175: 23          inc  hl
5176: 06 FB       ld   b,$FB
5178: DD 7E 03    ld   a,(ix+character_y_offset_03)
517B: B7          or   a
517C: F2 81 51    jp   p,$5181
517F: 06 F5       ld   b,$F5
5181: DD 7E 04    ld   a,(ix+$04)
5184: 80          add  a,b
5185: 77          ld   (hl),a
5186: 23          inc  hl
5187: 71          ld   (hl),c
5188: 23          inc  hl
5189: E5          push hl
518A: 21 F4 80    ld   hl,$80F4
518D: DD 7E 07    ld   a,(ix+$07)
5190: 47          ld   b,a
5191: 87          add  a,a
5192: 87          add  a,a
5193: 80          add  a,b
5194: 87          add  a,a
5195: 5F          ld   e,a
5196: 16 00       ld   d,$00
5198: 19          add  hl,de
5199: 7E          ld   a,(hl)
519A: E1          pop  hl
519B: 77          ld   (hl),a
519C: C9          ret

519D: DD 36 02 FF ld   (ix+$02),$FF
51A1: 2A 36 83    ld   hl,($8336)
51A4: 36 FF       ld   (hl),$FF
51A6: C9          ret

; when???
enemy_unknown_state_51A7:
51A7: CD CE 62    call load_character_elevator_structure_62CE
51AA: AF          xor  a
51AB: DD 77 1A    ld   (ix+$1a),a
51AE: DD 77 17    ld   (ix+$17),a
51B1: CD 68 05    call should_enemy_shoot_0568
51B4: DA F8 51    jp   c,$51F8
51B7: 3A 21 85    ld   a,(player_structure_851A+current_floor_07)
51BA: FE 07       cp   $07
51BC: 38 47       jr   c,$5205
51BE: DD 7E 10    ld   a,(ix+$10)
51C1: B7          or   a
51C2: 20 12       jr   nz,$51D6
51C4: DD 36 12 00 ld   (ix+$12),$00
51C8: DD 36 10 0A ld   (ix+$10),$0A
51CC: DD 7E 0E    ld   a,(ix+$0e)
51CF: B7          or   a
51D0: 28 04       jr   z,$51D6
51D2: DD 36 10 07 ld   (ix+$10),$07
51D6: DD 7E 18    ld   a,(ix+$18)
51D9: B7          or   a
51DA: 20 05       jr   nz,$51E1
51DC: CD A8 52    call $52A8
51DF: 18 13       jr   $51F4
51E1: CD FF 52    call $52FF
51E4: DD 7E 07    ld   a,(ix+$07)
51E7: DD BE 18    cp   (ix+$18)
51EA: 20 08       jr   nz,$51F4
51EC: FD 7E 00    ld   a,(iy+$00)
51EF: FE 10       cp   $10
51F1: DA 3B 53    jp   c,$533B
51F4: CD 3B 00    call $003B
51F7: C9          ret
51F8: DD 36 18 00 ld   (ix+$18),$00
51FC: DD 36 0F 01 ld   (ix+$0f),$01
5200: DD 36 10 00 ld   (ix+$10),$00
5204: C9          ret
5205: CD 24 53    call $5324
5208: DD 7E 10    ld   a,(ix+$10)
520B: B7          or   a
520C: C2 F4 51    jp   nz,$51F4
520F: 3A 21 85    ld   a,(player_structure_851A+current_floor_07)
5212: FE 07       cp   $07
5214: 30 09       jr   nc,$521F
5216: 3A 20 85    ld   a,($8520)
5219: 3D          dec  a
521A: 28 19       jr   z,$5235
521C: 3D          dec  a
521D: 28 16       jr   z,$5235
521F: CD 7A 52    call $527A
5222: 3A 21 85    ld   a,(player_structure_851A+current_floor_07)
5225: DD 96 07    sub  (ix+$07)
5228: 3E 00       ld   a,$00
522A: 17          rla
522B: B8          cp   b
522C: C2 35 52    jp   nz,$5235
522F: CD 29 05    call $0529
5232: C3 C8 51    jp   $51C8
5235: 3A 1A 85    ld   a,(player_structure_851A)
5238: 47          ld   b,a
5239: DD 7E 00    ld   a,(ix+character_x_00)
523C: 90          sub  b
523D: 3E 00       ld   a,$00
523F: 17          rla
5240: DD 77 0B    ld   (ix+$0b),a
5243: DD 36 12 03 ld   (ix+$12),$03
5247: DD 36 10 0F ld   (ix+$10),$0F
524B: C3 F4 51    jp   $51F4

; called when enemy is on top of elevator cabin, A.I there
enemy_above_elevator_524E:
524E: DD 36 1A 00 ld   (ix+$1a),$00
5252: CD 68 05    call should_enemy_shoot_0568
5255: DA F8 51    jp   c,$51F8
5258: DD 7E 11    ld   a,(ix+$11)
525B: B7          or   a
525C: 20 09       jr   nz,$5267
525E: DD 7E 10    ld   a,(ix+$10)
5261: B7          or   a
5262: 28 03       jr   z,$5267
5264: C3 F4 51    jp   $51F4
5267: DD 7E 0B    ld   a,(ix+$0b)
526A: EE 01       xor  $01
526C: DD 77 0B    ld   (ix+$0b),a
526F: DD 36 10 05 ld   (ix+$10),$05
5273: DD 36 12 03 ld   (ix+$12),$03
5277: C3 F4 51    jp   $51F4
527A: 06 01       ld   b,$01
527C: FD 7E 01    ld   a,(iy+$01)
527F: FD BE 02    cp   (iy+$02)
5282: C8          ret  z
5283: 06 00       ld   b,$00
5285: FD 96 06    sub  (iy+$06)
5288: FD 96 06    sub  (iy+$06)
528B: FD BE 03    cp   (iy+$03)
528E: 20 05       jr   nz,$5295
5290: FD 7E 00    ld   a,(iy+$00)
5293: B7          or   a
5294: C8          ret  z
5295: 21 81 80    ld   hl,elevator_directions_array_8081
5298: DD 7E 08    ld   a,(ix+$08)
529B: E6 7F       and  $7F
529D: 87          add  a,a
529E: 5F          ld   e,a
529F: 16 00       ld   d,$00
52A1: 19          add  hl,de
52A2: 7E          ld   a,(hl)
52A3: B7          or   a
52A4: F0          ret  p
52A5: 06 01       ld   b,$01
52A7: C9          ret
52A8: 3A BA 85    ld   a,(current_enemy_index_85BA)
52AB: C6 03       add  a,$03
52AD: DD 77 10    ld   (ix+$10),a
52B0: CD B4 52    call $52B4
52B3: C9          ret
52B4: 3A 21 85    ld   a,(player_structure_851A+current_floor_07)
52B7: 47          ld   b,a
52B8: DD 7E 08    ld   a,(ix+$08)
52BB: E6 7F       and  $7F
52BD: FE 0A       cp   $0A
52BF: CA E4 52    jp   z,$52E4
52C2: DD 7E 08    ld   a,(ix+$08)
52C5: E6 80       and  $80
52C7: 07          rlca
52C8: 07          rlca
52C9: 57          ld   d,a
52CA: FD 7E 02    ld   a,(iy+$02)
52CD: 92          sub  d
52CE: 5F          ld   e,a
52CF: B8          cp   b
52D0: 38 0D       jr   c,$52DF
52D2: FD 7E 06    ld   a,(iy+$06)
52D5: 87          add  a,a
52D6: FD 86 03    add  a,(iy+$03)
52D9: 92          sub  d
52DA: 5F          ld   e,a
52DB: 78          ld   a,b
52DC: BB          cp   e
52DD: 30 01       jr   nc,$52E0
52DF: 43          ld   b,e
52E0: DD 70 18    ld   (ix+$18),b
52E3: C9          ret
52E4: 78          ld   a,b
52E5: FE 1E       cp   $1E
52E7: 30 11       jr   nc,$52FA
52E9: FE 14       cp   $14
52EB: 20 D5       jr   nz,$52C2
52ED: 3A 1A 85    ld   a,(player_structure_851A)
52F0: FE AC       cp   $AC
52F2: 38 CE       jr   c,$52C2
52F4: 06 13       ld   b,$13
52F6: 16 00       ld   d,$00
52F8: 18 E6       jr   $52E0
52FA: DD 36 18 1E ld   (ix+$18),$1E
52FE: C9          ret
52FF: 06 00       ld   b,$00
5301: DD 7E 08    ld   a,(ix+$08)
5304: 07          rlca
5305: 07          rlca
5306: E6 02       and  $02
5308: 4F          ld   c,a
5309: FD 7E 01    ld   a,(iy+$01)
530C: 91          sub  c
530D: DD BE 18    cp   (ix+$18)
5310: 28 06       jr   z,$5318
5312: 06 01       ld   b,$01
5314: 38 0A       jr   c,$5320
5316: 18 06       jr   $531E
5318: FD 7E 00    ld   a,(iy+$00)
531B: B7          or   a
531C: 28 02       jr   z,$5320
531E: 06 FF       ld   b,$FF
5320: DD 70 17    ld   (ix+$17),b
5323: C9          ret
5324: DD 7E 18    ld   a,(ix+$18)
5327: B7          or   a
5328: C0          ret  nz
5329: 3A BA 85    ld   a,(current_enemy_index_85BA)
532C: C6 03       add  a,$03
532E: DD 77 10    ld   (ix+$10),a
5331: DD 7E 09    ld   a,(ix+$09)
5334: B7          or   a
5335: C0          ret  nz
5336: DD 36 18 28 ld   (ix+$18),$28
533A: C9          ret
533B: DD 7E 18    ld   a,(ix+$18)
533E: FE 13       cp   $13
5340: 28 17       jr   z,$5359
5342: FE 11       cp   $11
5344: 28 27       jr   z,$536D
5346: 3A BA 85    ld   a,(current_enemy_index_85BA)
5349: E6 01       and  $01
534B: 20 06       jr   nz,$5353
534D: CD 8B 53    call $538B
5350: C3 F4 51    jp   $51F4
5353: CD BA 53    call $53BA
5356: C3 F4 51    jp   $51F4
5359: 3A 21 85    ld   a,(player_structure_851A+current_floor_07)
535C: FE 14       cp   $14
535E: 20 10       jr   nz,$5370
5360: 3A 1A 85    ld   a,(player_structure_851A)
5363: FE AC       cp   $AC
5365: 38 DF       jr   c,$5346
5367: DD 36 0B 01 ld   (ix+$0b),$01
536B: 18 13       jr   $5380
536D: 3A 21 85    ld   a,(player_structure_851A+current_floor_07)
5370: FE 12       cp   $12
5372: 20 D2       jr   nz,$5346
5374: 3A 1A 85    ld   a,(player_structure_851A)
5377: D6 7D       sub  $7D
5379: 3F          ccf
537A: 17          rla
537B: E6 01       and  $01
537D: DD 77 0B    ld   (ix+$0b),a
5380: DD 36 12 03 ld   (ix+$12),$03
5384: DD 36 10 14 ld   (ix+$10),$14
5388: C3 F4 51    jp   $51F4
538B: DD 36 0B 00 ld   (ix+$0b),$00
538F: DD 7E 08    ld   a,(ix+$08)
5392: E6 7F       and  $7F
5394: FE 02       cp   $02
5396: 38 1C       jr   c,$53B4
5398: FE 07       cp   $07
539A: 28 18       jr   z,$53B4
539C: FE 08       cp   $08
539E: 20 09       jr   nz,$53A9
53A0: DD 7E 07    ld   a,(ix+$07)
53A3: FE 0C       cp   $0C
53A5: 28 0D       jr   z,$53B4
53A7: 18 44       jr   $53ED
53A9: FE 09       cp   $09
53AB: 20 40       jr   nz,$53ED
53AD: DD 7E 07    ld   a,(ix+$07)
53B0: FE 10       cp   $10
53B2: 20 39       jr   nz,$53ED
53B4: DD 36 0B 01 ld   (ix+$0b),$01
53B8: 18 33       jr   $53ED
53BA: DD 36 0B 01 ld   (ix+$0b),$01
53BE: DD 7E 08    ld   a,(ix+$08)
53C1: E6 7F       and  $7F
53C3: FE 02       cp   $02
53C5: 28 22       jr   z,$53E9
53C7: FE 06       cp   $06
53C9: 28 1E       jr   z,$53E9
53CB: FE 09       cp   $09
53CD: 20 09       jr   nz,$53D8
53CF: DD 7E 07    ld   a,(ix+$07)
53D2: FE 0F       cp   $0F
53D4: 28 13       jr   z,$53E9
53D6: 18 15       jr   $53ED
53D8: FE 0A       cp   $0A
53DA: 20 11       jr   nz,$53ED
53DC: DD 7E 07    ld   a,(ix+$07)
53DF: FE 14       cp   $14
53E1: CA E9 53    jp   z,$53E9
53E4: FE 1F       cp   $1F
53E6: C2 ED 53    jp   nz,$53ED
53E9: DD 36 0B 00 ld   (ix+$0b),$00
53ED: DD 36 12 03 ld   (ix+$12),$03
53F1: DD 36 10 1E ld   (ix+$10),$1E
53F5: C9          ret

; most of enemy A.I. is probably there
enemy_walk_state_53F6:
53F6: AF          xor  a
53F7: DD 77 1B    ld   (ix+$1b),a
53FA: DD 77 18    ld   (ix+$18),a
53FD: CD 68 05    call should_enemy_shoot_0568
5400: DA 36 54    jp   c,enemy_decided_to_shoot_5436
5403: DD 7E 1A    ld   a,(ix+$1a)
5406: B7          or   a
5407: CC 33 5B    call z,$5B33
540A: DD 7E 08    ld   a,(ix+$08)
540D: 3C          inc  a
540E: C2 5E 54    jp   nz,$545E
5411: DD 7E 00    ld   a,(ix+character_x_00)
5414: DD 96 1A    sub  (ix+$1a)
5417: C6 02       add  a,$02
5419: FE 05       cp   $05
541B: DA 43 54    jp   c,$5443
541E: DD 7E 11    ld   a,(ix+$11)
5421: 3C          inc  a
5422: FE 02       cp   $02
5424: D2 D7 55    jp   nc,$55D7
5427: DD 7E 10    ld   a,(ix+$10)
542A: B7          or   a
542B: CC EF 55    call z,$55EF
542E: DD 36 08 FF ld   (ix+$08),$FF
5432: CD 3B 00    call $003B
5435: C9          ret

enemy_decided_to_shoot_5436:
5436: DD 36 0F 01 ld   (ix+$0f),$01
543A: DD 36 10 00 ld   (ix+$10),$00
543E: DD 36 1A 00 ld   (ix+$1a),$00
5442: C9          ret
5443: DD 7E 1C    ld   a,(ix+$1c)
5446: D6 0B       sub  $0B
5448: CA 19 55    jp   z,$5519
544B: 3D          dec  a
544C: CA B0 55    jp   z,$55B0
544F: DD 36 12 00 ld   (ix+$12),$00
5453: DD 36 10 07 ld   (ix+$10),$07
5457: DD 36 1A 00 ld   (ix+$1a),$00
545B: C3 2E 54    jp   $542E
545E: CD 64 54    call $5464
5461: C3 2E 54    jp   $542E
5464: CD CE 62    call load_character_elevator_structure_62CE
5467: DD 7E 11    ld   a,(ix+$11)
546A: 3C          inc  a
546B: FE 02       cp   $02
546D: D2 A9 54    jp   nc,$54A9
5470: DD 7E 1C    ld   a,(ix+$1c)
5473: FE 0B       cp   $0B
5475: 30 0E       jr   nc,$5485
5477: DD 7E 1A    ld   a,(ix+$1a)
547A: DD 96 00    sub  (ix+character_x_00)
547D: 30 02       jr   nc,$5481
547F: ED 44       neg
5481: FE 11       cp   $11
5483: 38 2B       jr   c,$54B0
5485: FD 7E 07    ld   a,(iy+$07)
5488: FD 96 06    sub  (iy+$06)
548B: FD 96 06    sub  (iy+$06)
548E: DD BE 07    cp   (ix+$07)
5491: C0          ret  nz
5492: DD 7E 08    ld   a,(ix+$08)
5495: 87          add  a,a
5496: 5F          ld   e,a
5497: 16 00       ld   d,$00
5499: 21 81 80    ld   hl,elevator_directions_array_8081
549C: 19          add  hl,de
549D: 7E          ld   a,(hl)
549E: B7          or   a
549F: F0          ret  p
54A0: DD 36 12 03 ld   (ix+$12),$03
54A4: DD 36 10 01 ld   (ix+$10),$01
54A8: C9          ret
54A9: FD 7E 03    ld   a,(iy+$03)
54AC: DD BE 07    cp   (ix+$07)
54AF: C8          ret  z
54B0: FD 7E 06    ld   a,(iy+$06)
54B3: B7          or   a
54B4: 28 35       jr   z,$54EB
54B6: DD 7E 1E    ld   a,(ix+$1e)
54B9: B7          or   a
54BA: 28 11       jr   z,$54CD
54BC: DD 7E 07    ld   a,(ix+$07)
54BF: FD 96 03    sub  (iy+$03)
54C2: FE 03       cp   $03
54C4: 30 11       jr   nc,$54D7
54C6: FD 46 01    ld   b,(iy+$01)
54C9: 05          dec  b
54CA: 05          dec  b
54CB: 18 21       jr   $54EE
54CD: FD 7E 02    ld   a,(iy+$02)
54D0: DD 96 07    sub  (ix+$07)
54D3: FE 03       cp   $03
54D5: 38 14       jr   c,$54EB
54D7: DD 7E 07    ld   a,(ix+$07)
54DA: FD 96 01    sub  (iy+$01)
54DD: 28 31       jr   z,$5510
54DF: 3D          dec  a
54E0: 28 2E       jr   z,$5510
54E2: C6 03       add  a,$03
54E4: 28 2A       jr   z,$5510
54E6: 3D          dec  a
54E7: 28 27       jr   z,$5510
54E9: 18 0C       jr   $54F7
54EB: FD 46 01    ld   b,(iy+$01)
54EE: DD 7E 07    ld   a,(ix+$07)
54F1: 90          sub  b
54F2: 28 1C       jr   z,$5510
54F4: 3D          dec  a
54F5: 28 19       jr   z,$5510
54F7: DD 36 1C 0D ld   (ix+$1c),$0D
54FB: CD F5 1D    call pseudo_random_1DF5
54FE: E6 0F       and  $0F
5500: 47          ld   b,a
5501: DD 7E 0B    ld   a,(ix+$0b)
5504: B7          or   a
5505: 78          ld   a,b
5506: 28 02       jr   z,$550A
5508: ED 44       neg
550A: DD 86 00    add  a,(ix+character_x_00)
550D: DD 77 1A    ld   (ix+$1a),a
5510: DD 36 12 00 ld   (ix+$12),$00
5514: DD 36 10 05 ld   (ix+$10),$05
5518: C9          ret
5519: DD 7E 1A    ld   a,(ix+$1a)
551C: FE 09       cp   $09
551E: 28 2F       jr   z,$554F
5520: FE 2F       cp   $2F
5522: 28 0B       jr   z,$552F
5524: FE C2       cp   $C2
5526: 28 07       jr   z,$552F
5528: FE E7       cp   $E7
552A: 28 23       jr   z,$554F
552C: C3 2E 54    jp   $542E
552F: 2A BD 85    ld   hl,($85BD)
5532: 7E          ld   a,(hl)
5533: 3C          inc  a
5534: 20 39       jr   nz,$556F
5536: CD 7A 55    call $557A
5539: CA 93 55    jp   z,$5593
553C: DD 36 12 00 ld   (ix+$12),$00
5540: DD 36 10 01 ld   (ix+$10),$01
5544: DD 36 09 02 ld   (ix+$09),$02
5548: DD 36 1B 01 ld   (ix+$1b),$01
554C: C3 2E 54    jp   $542E
554F: 2A BD 85    ld   hl,($85BD)
5552: 7E          ld   a,(hl)
5553: 3C          inc  a
5554: 20 19       jr   nz,$556F
5556: CD 7A 55    call $557A
5559: CA 93 55    jp   z,$5593
555C: DD 36 12 01 ld   (ix+$12),$01
5560: DD 36 10 01 ld   (ix+$10),$01
5564: DD 36 09 00 ld   (ix+$09),$00
5568: DD 36 1B 01 ld   (ix+$1b),$01
556C: C3 2E 54    jp   $542E
556F: DD 36 12 00 ld   (ix+$12),$00
5573: DD 36 10 01 ld   (ix+$10),$01
5577: C3 2E 54    jp   $542E

557A: 3A 20 85    ld   a,($8520)
557D: FE 04       cp   $04
557F: C0          ret  nz
5580: 3A 21 85    ld   a,(player_structure_851A+current_floor_07)
5583: DD 96 07    sub  (ix+$07)
5586: 28 02       jr   z,$558A
5588: 3C          inc  a
5589: C0          ret  nz
558A: 3A 1A 85    ld   a,(player_structure_851A)
558D: DD AE 00    xor  (ix+character_x_00)
5590: E6 80       and  $80
5592: C9          ret
5593: DD 7E 0B    ld   a,(ix+$0b)
5596: B7          or   a
5597: 3E 0A       ld   a,$0A
5599: 20 02       jr   nz,$559D
559B: 3E F6       ld   a,$F6
559D: DD 86 00    add  a,(ix+character_x_00)
55A0: DD 77 1A    ld   (ix+$1a),a
55A3: DD 36 12 03 ld   (ix+$12),$03
55A7: DD 36 10 07 ld   (ix+$10),$07
55AB: DD 36 1C 0D ld   (ix+$1c),$0D
55AF: C9          ret

55B0: DD 7E 16    ld   a,(ix+$16)
55B3: FE CF       cp   $CF
55B5: 30 13       jr   nc,$55CA
55B7: DD 36 0A 00 ld   (ix+$0a),$00
55BB: DD 36 04 00 ld   (ix+$04),$00
55BF: DD 36 06 05 ld   (ix+character_situation_06),CS_IN_ROOM_05
55C3: DD 7E 1D    ld   a,(ix+$1d)
55C6: DD 77 08    ld   (ix+$08),a
55C9: C9          ret

55CA: DD 36 10 0A ld   (ix+$10),$0A
55CE: DD 36 12 00 ld   (ix+$12),$00
55D2: DD 36 1A 00 ld   (ix+$1a),$00
55D6: C9          ret

55D7: DD 36 1A 00 ld   (ix+$1a),$00
55DB: 06 0A       ld   b,$0A
55DD: DD 7E 0E    ld   a,(ix+$0e)
55E0: B7          or   a
55E1: 28 02       jr   z,$55E5
55E3: 06 07       ld   b,$07
55E5: DD 70 10    ld   (ix+$10),b
55E8: DD 36 12 00 ld   (ix+$12),$00
55EC: C3 2E 54    jp   $542E

55EF: CD E6 04    call $04E6
55F2: DD 7E 12    ld   a,(ix+$12)
55F5: FE 03       cp   $03
55F7: C0          ret  nz
55F8: DD 7E 00    ld   a,(ix+character_x_00)
55FB: DD 96 1A    sub  (ix+$1a)
55FE: 3E 00       ld   a,$00
5600: 17          rla
5601: DD 77 0B    ld   (ix+$0b),a
5604: C9          ret

5605: 21 3F 56    ld   hl,table_563F
5608: 16 00       ld   d,$00
560A: 58          ld   e,b
560B: 19          add  hl,de
560C: 19          add  hl,de
560D: 5E          ld   e,(hl)
560E: 23          inc  hl
560F: 56          ld   d,(hl)
5610: 78          ld   a,b
5611: FE 07       cp   $07
5613: 38 0E       jr   c,$5623
5615: 21 84 FF    ld   hl,$FF84
5618: 19          add  hl,de
5619: 7C          ld   a,h
561A: E6 03       and  $03
561C: 67          ld   h,a
561D: 79          ld   a,c
561E: 81          add  a,c
561F: 81          add  a,c
5620: 85          add  a,l
5621: 6F          ld   l,a
5622: C9          ret
5623: 79          ld   a,c
5624: 21 83 FF    ld   hl,$FF83
5627: B7          or   a
5628: 28 03       jr   z,$562D
562A: 21 9A FF    ld   hl,$FF9A
562D: 19          add  hl,de
562E: 7C          ld   a,h
562F: E6 03       and  $03
5631: 67          ld   h,a
5632: C9          ret
5633: 87          add  a,a
5634: 5F          ld   e,a
5635: 16 00       ld   d,$00
5637: 21 3F 56    ld   hl,table_563F
563A: 19          add  hl,de
563B: 5E          ld   e,(hl)
563C: 23          inc  hl
563D: 56          ld   d,(hl)
563E: C9          ret

table_563F:
	dc.b	80      
	dc.b	01 C0 00
	dc.b	00      
	dc.b	00      
	dc.b	40      
	dc.b	03      
	dc.b	80      
	dc.b	02      
	dc.b	C0      
	dc.b	01 00 01
	dc.b	40      
	dc.b	00      
	dc.b	80      
	dc.b	03      
	dc.b	C0      
	dc.b	02      
	dc.b	00      
	dc.b	02      
	dc.b	40      
	dc.b	01 80 00
	dc.b	C0      
	dc.b	03      
	dc.b	00      
	dc.b	03      
	dc.b	40      
	dc.b	02      
	dc.b	80      
	dc.b	01 C0 00
	dc.b	00      
	dc.b	00      
	dc.b	40      
	dc.b	03      
	dc.b	80      
	dc.b	02      
	dc.b	C0      
	dc.b	01 00 01
	dc.b	40      
	dc.b	00      
	dc.b	80      
	dc.b	03      
	dc.b	C0      
	dc.b	02      
	dc.b	00      
	dc.b	02      
	dc.b	40      
	dc.b	01 80 00
	dc.b	C0      
	dc.b	03      
	dc.b	00      
	dc.b	03      
	dc.b	40      
	dc.b	02      

; seems unreached
567F: 21 4D 83    ld   hl,$834D
5682: 06 03       ld   b,$03
5684: 36 00       ld   (hl),$00
5686: 23          inc  hl
5687: 10 FB       djnz $5684
5689: 21 54 82    ld   hl,$8254
568C: 06 03       ld   b,$03
568E: 36 00       ld   (hl),$00
5690: 23          inc  hl
5691: 10 FB       djnz $568E
5693: C9          ret

5694: C5          push bc
5695: D5          push de
5696: E5          push hl
5697: 21 7E 57    ld   hl,$577E
569A: 3A 42 82    ld   a,($8242)
569D: B7          or   a
569E: C2 02 57    jp   nz,$5702
56A1: FD 7E 06    ld   a,(iy+$06)
56A4: B7          or   a
56A5: 20 0C       jr   nz,$56B3
56A7: FD 7E 07    ld   a,(iy+$07)
56AA: FE 0B       cp   $0B
56AC: 38 05       jr   c,$56B3
56AE: FE 10       cp   $10
56B0: DA 02 57    jp   c,$5702
56B3: 21 7B 57    ld   hl,table_577B
56B6: C3 02 57    jp   $5702
56B9: C5          push bc
56BA: D5          push de
56BB: E5          push hl
56BC: 21 84 57    ld   hl,$5784
56BF: 3A 42 82    ld   a,($8242)
56C2: B7          or   a
56C3: C2 02 57    jp   nz,$5702
56C6: DD 7E 06    ld   a,(ix+character_situation_06)
56C9: B7          or   a
56CA: 20 0C       jr   nz,$56D8
; on ground
56CC: DD 7E 07    ld   a,(ix+$07)
56CF: FE 0B       cp   $0B
56D1: 38 05       jr   c,$56D8
56D3: FE 10       cp   $10
56D5: DA 02 57    jp   c,$5702
56D8: 21 81 57    ld   hl,$5781
56DB: C3 02 57    jp   $5702
56DE: C5          push bc
56DF: D5          push de
56E0: E5          push hl
56E1: 21 87 57    ld   hl,$5787
56E4: C3 02 57    jp   $5702
56E7: C5          push bc
56E8: D5          push de
56E9: E5          push hl
56EA: 21 8A 57    ld   hl,$578A
56ED: C3 02 57    jp   $5702
56F0: C5          push bc
56F1: D5          push de
56F2: E5          push hl
56F3: 21 8D 57    ld   hl,$578D
56F6: C3 02 57    jp   $5702

award_end_of_level_bonus_56F9:
56F9: C5          push bc
56FA: D5          push de
56FB: E5          push hl
56FC: 21 6D 83    ld   hl,points_awarded_on_level_end_836D
56FF: C3 02 57    jp   $5702	; useless!
5702: 3A 3B 82    ld   a,(game_in_play_flag_823B)
5705: B7          or   a
5706: 20 0E       jr   nz,$5716
5708: 11 4D 83    ld   de,$834D
570B: 06 03       ld   b,$03
570D: AF          xor  a
570E: 1A          ld   a,(de)
570F: 8E          adc  a,(hl)
5710: 27          daa
5711: 12          ld   (de),a
5712: 23          inc  hl
5713: 13          inc  de
5714: 10 F8       djnz $570E
5716: 21 4D 83    ld   hl,$834D
5719: 11 58 83    ld   de,$8358
571C: 3A 36 82    ld   a,($8236)
571F: B7          or   a
5720: 28 03       jr   z,$5725
5722: 11 6C 83    ld   de,$836C
5725: CD D3 58    call encode_score_as_tiles_58d3
5728: CD 54 57    call $5754
572B: E1          pop  hl
572C: D1          pop  de
572D: C1          pop  bc
572E: C9          ret

572F: 21 50 83    ld   hl,$8350
5732: 11 4D 83    ld   de,$834D
5735: 06 03       ld   b,$03
5737: AF          xor  a
5738: 1A          ld   a,(de)
5739: 9E          sbc  a,(hl)
573A: 23          inc  hl
573B: 13          inc  de
573C: 10 FA       djnz $5738
573E: D8          ret  c
573F: 21 4D 83    ld   hl,$834D
5742: 11 50 83    ld   de,$8350
5745: 01 03 00    ld   bc,$0003
5748: ED B0       ldir
574A: 21 50 83    ld   hl,$8350
574D: 11 62 83    ld   de,$8362
5750: CD D3 58    call encode_score_as_tiles_58d3
5753: C9          ret
5754: 3A 73 83    ld   a,($8373)
5757: B7          or   a
5758: C0          ret  nz
5759: 21 70 83    ld   hl,$8370
575C: 11 4D 83    ld   de,$834D
575F: 06 03       ld   b,$03
5761: AF          xor  a
5762: 1A          ld   a,(de)
5763: 9E          sbc  a,(hl)
5764: 23          inc  hl
5765: 13          inc  de
5766: 10 FA       djnz $5762
5768: D8          ret  c
5769: 3E 01       ld   a,$01
576B: 32 73 83    ld   ($8373),a
576E: 3A 34 82    ld   a,(nb_lives_8234)
5771: 3C          inc  a
5772: 32 34 82    ld   (nb_lives_8234),a
5775: 3E 3D       ld   a,$3D
5777: 32 0B D5    ld   (sound_latch_D50B),a
577A: C9          ret
table_577B:     
	dc.b	00 01 00 50
	dc.b	01 00 50
	dc.b	01 00 00
	dc.b	02      
	dc.b	00      
	dc.b	00      
	dc.b	03      
	dc.b	00      
	dc.b	00      
	dc.b	03      
	dc.b	00      
	dc.b	00      
	dc.b	05      
	dc.b	00      
thousand_points_5790:
	dc.b	00 10 00
	
compute_end_level_points_5793: 
5793: 3A 50 82    ld   a,(copy_of_dip_switches_3_8250)
5796: E6 03       and  $03
5798: 47          ld   b,a
5799: 3A 37 82    ld   a,(skill_level_8237)
579C: 90          sub  b
579D: 3C          inc  a
579E: 28 FD       jr   z,$579D
57A0: FE 0B       cp   $0B
57A2: 38 02       jr   c,$57A6
57A4: 3E 0A       ld   a,$0A
57A6: 4F          ld   c,a
57A7: 21 6D 83    ld   hl,points_awarded_on_level_end_836D
57AA: AF          xor  a
57AB: 06 03       ld   b,$03
57AD: 77          ld   (hl),a
57AE: 23          inc  hl
57AF: 10 FC       djnz $57AD
57B1: 06 03       ld   b,$03
57B3: 11 6D 83    ld   de,points_awarded_on_level_end_836D
57B6: 21 90 57    ld   hl,thousand_points_5790
57B9: AF          xor  a
57BA: 1A          ld   a,(de)
57BB: 8E          adc  a,(hl)
57BC: 27          daa
57BD: 12          ld   (de),a
57BE: 23          inc  hl
57BF: 13          inc  de
57C0: 10 F8       djnz $57BA
57C2: 0D          dec  c
57C3: 20 EC       jr   nz,$57B1
57C5: C9          ret

update_upper_status_bar_57C6:
57C6: 21 53 83    ld   hl,$8353
57C9: 11 63 C4    ld   de,$C463		; screen address of status bar
57CC: ED A0       ldi
57CE: ED A0       ldi
57D0: ED A0       ldi
57D2: ED A0       ldi
57D4: ED A0       ldi
57D6: ED A0       ldi
57D8: ED A0       ldi
57DA: ED A0       ldi
57DC: ED A0       ldi
57DE: ED A0       ldi
57E0: ED A0       ldi
57E2: ED A0       ldi
57E4: ED A0       ldi
57E6: ED A0       ldi
57E8: ED A0       ldi
57EA: ED A0       ldi
57EC: ED A0       ldi
57EE: ED A0       ldi
57F0: ED A0       ldi
57F2: ED A0       ldi
57F4: ED A0       ldi
57F6: ED A0       ldi
57F8: ED A0       ldi
57FA: ED A0       ldi
57FC: ED A0       ldi
57FE: ED A0       ldi
5800: C9          ret

display_nb_lives_5801:
5801: 3A 50 82    ld   a,(copy_of_dip_switches_3_8250)
5804: CB 77       bit  6,a
5806: 20 15       jr   nz,no_hit_dsw_set_581d
5808: 21 A1 C7    ld   hl,$C7A1
580B: 3A 34 82    ld   a,(nb_lives_8234)
580E: B7          or   a
580F: 28 09       jr   z,$581A
5811: FA 1A 58    jp   m,$581A
5814: 47          ld   b,a
5815: 36 FF       ld   (hl),$FF
5817: 23          inc  hl
5818: 10 FB       djnz $5815
581A: 36 33       ld   (hl),$33
581C: C9          ret

no_hit_dsw_set_581d:
581D: 21 27 58    ld   hl,string_5827
5820: 11 A1 C7    ld   de,$C7A1
5823: CD F9 29    call copy_string_to_screen_29F9
5826: C9          ret

string_5827:	; "NO HIT"
	dc.b	25     
	dc.b	2F     
	dc.b	33     
	dc.b	2B     
	dc.b	2C     
	dc.b	31 FF

display_bottom_bricks_582e:
582E: 21 40 C7    ld   hl,$C740                                       
5831: 3E 32       ld   a,$32                                          
5833: 06 60       ld   b,$60                                          
5835: 77          ld   (hl),a                                         
5836: 23          inc  hl                                             
5837: 10 FC       djnz $5835                                          
display_status_bars_5839:
5839: 21 40 C4    ld   hl,$C440
583C: 3E 33       ld   a,$33
583E: 06 40       ld   b,$40
5840: 77          ld   (hl),a
5841: 23          inc  hl
5842: 10 FC       djnz $5840
5844: 01 12 00    ld   bc,$0012
5847: 3A 35 82    ld   a,($8235)
584A: 3D          dec  a
584B: 28 03       jr   z,$5850
584D: 01 1C 00    ld   bc,$001C
5850: 21 72 58    ld   hl,table_5872
5853: 11 42 C4    ld   de,$C442
5856: ED B0       ldir
5858: CD 95 58    call $5895
585B: 21 A0 C7    ld   hl,$C7A0
585E: 3E 33       ld   a,$33
5860: 06 20       ld   b,$20
5862: 77          ld   (hl),a
5863: 23          inc  hl
5864: 10 FC       djnz $5862
5866: 21 8E 58    ld   hl,table_588E
5869: 11 B7 C7    ld   de,$C7B7
586C: 01 07 00    ld   bc,$0007
586F: ED B0       ldir
5871: C9          ret

table_5872:
	dc.b	1A      
	dc.b	1B      
	dc.b	1C      
	dc.b	1D      
	dc.b	1E 1F   
	dc.b	2A 11 33
	dc.b	33      
	dc.b	2B      
	dc.b	2C      
	dc.b	2A 2D
	
table_588E:	
	dc.b	2E
	dc.b	2F      
	dc.b	1F      
	dc.b	1E 33   
	dc.b	33      
	dc.b	1A      
	dc.b	1B      
	dc.b	1C      
	dc.b	1D      
	dc.b	1E 1F   
	dc.b	2A 12 2E
	dc.b	1F      
	dc.b	1E 30   
	dc.b	2C      
	dc.b	31 2A

5895: 21 53 83    ld   hl,$8353                                       
5898: 06 1A       ld   b,$1A
589A: 3E 33       ld   a,$33
589C: 77          ld   (hl),a
589D: 23          inc  hl
589E: 10 FC       djnz $589C
58A0: 21 4D 83    ld   hl,$834D
58A3: 11 58 83    ld   de,$8358
58A6: 3A 36 82    ld   a,($8236)
58A9: B7          or   a
58AA: 28 03       jr   z,$58AF
58AC: 11 6C 83    ld   de,$836C
58AF: CD D3 58    call encode_score_as_tiles_58d3
58B2: 21 50 83    ld   hl,$8350
58B5: 11 62 83    ld   de,$8362
58B8: CD D3 58    call encode_score_as_tiles_58d3
58BB: 3A 35 82    ld   a,($8235)
58BE: 3D          dec  a
58BF: C8          ret  z
58C0: 21 54 82    ld   hl,$8254
58C3: 11 58 83    ld   de,$8358
58C6: 3A 36 82    ld   a,($8236)
58C9: B7          or   a
58CA: 20 03       jr   nz,$58CF
58CC: 11 6C 83    ld   de,$836C
58CF: CD D3 58    call encode_score_as_tiles_58d3
58D2: C9          ret

encode_score_as_tiles_58d3:
58D3: 06 03       ld   b,$03
58D5: 7E          ld   a,(hl)
58D6: E6 0F       and  $0F
58D8: C6 10       add  a,$10
58DA: 12          ld   (de),a
58DB: 1B          dec  de
58DC: 7E          ld   a,(hl)
58DD: 0F          rrca
58DE: 0F          rrca
58DF: 0F          rrca
58E0: 0F          rrca
58E1: E6 0F       and  $0F
58E3: C6 10       add  a,$10
58E5: 12          ld   (de),a
58E6: 1B          dec  de
58E7: 23          inc  hl
58E8: 10 EB       djnz $58D5
58EA: C9          ret

58EB: CD FB 58    call $58FB
58EE: CD 6C 59    call check_opening_doors_596c
58F1: CD BB 59    call $59BB
58F4: CD F4 59    call $59F4
58F7: CD 1F 04    call $041F
58FA: C9          ret

58FB: 2A 31 82    ld   hl,(level_timer_16bit_8231)
58FE: 23          inc  hl
58FF: 22 31 82    ld   (level_timer_16bit_8231),hl
5902: CD 2F 59    call compute_difficulty_592F
5905: 06 01       ld   b,$01
5907: 3A 32 82    ld   a,(level_timer_16bit_msb_8232)
590A: FE 03       cp   $03
590C: 38 06       jr   c,$5914
590E: 04          inc  b
590F: FE 0C       cp   $0C
5911: 38 01       jr   c,$5914
5913: 04          inc  b
5914: 78          ld   a,b
5915: 32 7A 83    ld   ($837A),a
5918: 3A 74 83    ld   a,(instant_difficulty_level_8374)
591B: 87          add  a,a
591C: 47          ld   b,a
591D: 3E 50       ld   a,$50
591F: 90          sub  b
5920: 90          sub  b
5921: 90          sub  b
5922: 30 01       jr   nc,$5925
5924: AF          xor  a
5925: 32 75 83    ld   ($8375),a
5928: CD 4D 59    call update_max_nb_enemies_and_spawn_proba_594D
592B: CD FC 5A    call update_enemies_timers_and_aggressivity_5afc
592E: C9          ret

; real-time difficulty computation from skill level
; and current time elapsed in the level
compute_difficulty_592F:
592F: 3A 32 82    ld   a,(level_timer_16bit_msb_8232)
5932: FE 10       cp   $10
5934: 30 13       jr   nc,$5949
5936: CB 3F       srl  a
5938: CB 3F       srl  a
593A: 47          ld   b,a
593B: 3A 37 82    ld   a,(skill_level_8237)
593E: 80          add  a,b	; add skill level with time spent in level
593F: FE 10       cp   $10
5941: 38 02       jr   c,$5945
5943: 3E 0F       ld   a,$0F	; maxed out at $F
5945: CD 20 46    call $4620
5948: C9          ret
; player has overstayed his welcome as
; timer MSB 8232 just reached $10: max out difficulty
5949: D6 0C       sub  $0C
594B: 18 ED       jr   $593A

; depending on difficulty level, select max enemies
; either 3 or 4, also update probability to spawn enemies
update_max_nb_enemies_and_spawn_proba_594D:
594D: 06 03       ld   b,$03
594F: 3A 37 82    ld   a,(skill_level_8237)
5952: 87          add  a,a
5953: 87          add  a,a
5954: 4F          ld   c,a
5955: 3A 32 82    ld   a,(level_timer_16bit_msb_8232)
5958: 81          add  a,c
5959: FE 0E       cp   $0E
595B: 38 02       jr   c,$595F
595D: 06 04       ld   b,$04
595F: 78          ld   a,b
5960: 32 7B 83    ld   (max_nb_enemies_837B),a
5963: 3A 74 83    ld   a,(instant_difficulty_level_8374)
5966: 87          add  a,a
5967: 87          add  a,a			; times 4
5968: 32 7C 83    ld   (probablility_to_spawn_an_enemy_837C),a
596B: C9          ret

check_opening_doors_596c:
596C: 21 77 83    ld   hl,$8377
596F: AF          xor  a
5970: 77          ld   (hl),a
5971: 23          inc  hl
5972: 77          ld   (hl),a
5973: 23          inc  hl
5974: 77          ld   (hl),a
5975: DD 21 3A 85 ld   ix,enemy_1_853A	; first enemy pointer
5979: 11 20 00    ld   de,$0020			; $20 per enemy
597C: 06 04       ld   b,$04			; 4 enemies
597E: 3A 21 85    ld   a,(player_structure_851A+current_floor_07)
5981: 4F          ld   c,a
5982: 0D          dec  c
; start loop on enemies
5983: DD 7E 09    ld   a,(ix+$09)
5986: 3C          inc  a
5987: CA B6 59    jp   z,$59B6
598A: DD 7E 06    ld   a,(ix+character_situation_06)
598D: FE 05       cp   CS_IN_ROOM_05
598F: 28 0C       jr   z,enemy_exiting_room_599D
5991: B7          or   a
5992: 20 22       jr   nz,$59B6
5994: DD 7E 1C    ld   a,(ix+$1c)
5997: FE 0C       cp   $0C
5999: 28 1B       jr   z,$59B6
599B: 18 07       jr   $59A4

; starting point for enemies
enemy_exiting_room_599D:
599D: DD 7E 0A    ld   a,(ix+$0a)
59A0: B7          or   a
59A1: F2 B6 59    jp   p,$59B6
59A4: DD 7E 07    ld   a,(ix+$07)
59A7: 21 77 83    ld   hl,$8377
59AA: 91          sub  c
59AB: 28 08       jr   z,$59B5
59AD: 23          inc  hl
59AE: 3D          dec  a
59AF: 28 04       jr   z,$59B5
59B1: 23          inc  hl
59B2: 3D          dec  a
59B3: 20 01       jr   nz,$59B6
59B5: 34          inc  (hl)
59B6: DD 19       add  ix,de
59B8: 10 C9       djnz $5983
59BA: C9          ret

59BB: 21 76 83    ld   hl,$8376
59BE: 7E          ld   a,(hl)
59BF: B7          or   a
59C0: 28 01       jr   z,$59C3
59C2: 35          dec  (hl)
59C3: 3A 74 83    ld   a,(instant_difficulty_level_8374)
59C6: B7          or   a
59C7: C8          ret  z
59C8: 21 23 81    ld   hl,$8123
59CB: 11 04 00    ld   de,$0004
59CE: 06 03       ld   b,$03
59D0: 0E 70       ld   c,$70
59D2: 7E          ld   a,(hl)
59D3: 19          add  hl,de
59D4: 3C          inc  a
59D5: 28 07       jr   z,$59DE
59D7: 7E          ld   a,(hl)
59D8: 91          sub  c
59D9: 28 07       jr   z,reload_timer_for_all_enemies_59e2
59DB: 3D          dec  a
59DC: 28 04       jr   z,reload_timer_for_all_enemies_59e2
59DE: 23          inc  hl
59DF: 10 F1       djnz $59D2
59E1: C9          ret

reload_timer_for_all_enemies_59e2:
59E2: 3E 5A       ld   a,$5A
59E4: 32 76 83    ld   ($8376),a
59E7: 21 48 85    ld   hl,$8548
59EA: 11 20 00    ld   de,$0020
59ED: 06 04       ld   b,$04
59EF: 77          ld   (hl),a
59F0: 19          add  hl,de
59F1: 10 FC       djnz $59EF
59F3: C9          ret

59F4: 3A 20 85    ld   a,(player_structure_851A+character_situation_06)
59F7: B7          or   a
59F8: CA FF 59    jp   z,$59FF
59FB: CD 0D 5A    call player_hit_by_enemy_shots_test_5A0D
59FE: C9          ret
59FF: 3A 76 83    ld   a,($8376)
5A02: B7          or   a
5A03: 20 04       jr   nz,$5A09
5A05: CD 0D 5A    call player_hit_by_enemy_shots_test_5A0D
5A08: C9          ret
5A09: CD 26 5A    call try_to_spawn_an_enemy_5A26
5A0C: C9          ret

player_hit_by_enemy_shots_test_5A0D:
5A0D: 3A 7B 83    ld   a,(max_nb_enemies_837B)
5A10: 47          ld   b,a
5A11: DD 21 3A 85 ld   ix,enemy_1_853A
; loop on enemies
5A15: CD 2A 1E    call ramdon_1E2A
5A18: 5F          ld   e,a
5A19: 0E 01       ld   c,$01
5A1B: CD 4C 5A    call maybe_spawn_an_enemy_5a4c
5A1E: 11 20 00    ld   de,$0020
5A21: DD 19       add  ix,de
5A23: 10 F0       djnz $5A15
5A25: C9          ret

try_to_spawn_an_enemy_5A26:
5A26: 3A 7B 83    ld   a,(max_nb_enemies_837B)	; 3 or 4
5A29: 47          ld   b,a
5A2A: DD 21 3A 85 ld   ix,enemy_1_853A
; loop
5A2E: 3A 7A 83    ld   a,($837A)
5A31: 4F          ld   c,a
5A32: 1E 01       ld   e,$01
5A34: CD F5 1D    call pseudo_random_1DF5
5A37: 21 7C 83    ld   hl,probablility_to_spawn_an_enemy_837C
5A3A: BE          cp   (hl)
5A3B: 38 04       jr   c,$5A41
5A3D: CD 2A 1E    call ramdon_1E2A
5A40: 5F          ld   e,a
5A41: CD 4C 5A    call maybe_spawn_an_enemy_5a4c
5A44: 11 20 00    ld   de,$0020
5A47: DD 19       add  ix,de
5A49: 10 E3       djnz $5A2E
5A4B: C9          ret

; < e: random offset to apply
maybe_spawn_an_enemy_5a4c:
5A4C: DD 7E 09    ld   a,(ix+enemy_state_09)
5A4F: 3C          inc  a
5A50: 28 0C       jr   z,$5A5E		; jump if enemy inactive
5A52: DD 7E 06    ld   a,(ix+character_situation_06)
5A55: FE 05       cp   CS_IN_ROOM_05
5A57: C0          ret  nz
5A58: DD 7E 0A    ld   a,(ix+$0a)
5A5B: FE E0       cp   $E0
5A5D: C0          ret  nz
5A5E: DD 7E 10    ld   a,(ix+$10)
5A61: B7          or   a
5A62: C0          ret  nz
5A63: 21 77 83    ld   hl,$8377
5A66: 16 00       ld   d,$00
5A68: 19          add  hl,de
5A69: 7E          ld   a,(hl)
5A6A: B9          cp   c
5A6B: D0          ret  nc
5A6C: 3A 21 85    ld   a,(player_structure_851A+current_floor_07)
5A6F: 83          add  a,e
5A70: 3D          dec  a
5A71: DD 77 07    ld   (ix+current_floor_07),a
5A74: CD F5 1D    call pseudo_random_1DF5
5A77: E6 07       and  $07
5A79: DD 77 08    ld   (ix+spawning_door_08),a
5A7C: E5          push hl
5A7D: CD AB 5A    call must_spawn_enemy_5AAB
5A80: E1          pop  hl
5A81: DD 36 09 FF ld   (ix+enemy_state_09),$FF	; inactive
5A85: C8          ret  z
; must_spawn_enemy_5AAB returned nonzero:
; spawn a new enemy, located in the room we picked at random
; above, or by "cheating" if floor 20 and timer > 0x1000
spawn_enemy_5A86:
5A86: 3E 00       ld   a,$00
5A88: DD 77 0D    ld   (ix+move_direction_0d),a
5A8B: DD 77 19    ld   (ix+$19),a
5A8E: DD 77 09    ld   (ix+enemy_state_09),a	; enemy active
5A91: DD 77 0F    ld   (ix+$0f),a
5A94: DD 77 10    ld   (ix+$10),a
5A97: DD 36 06 05 ld   (ix+character_situation_06),CS_IN_ROOM_05
5A9B: DD 36 04 FF ld   (ix+$04),$FF
5A9F: DD 36 0A E0 ld   (ix+$0a),$E0
5AA3: 34          inc  (hl)
5AA4: 3A 74 83    ld   a,(instant_difficulty_level_8374)
5AA7: DD 77 13    ld   (ix+enemy_aggressivity_13),a
5AAA: C9          ret

must_spawn_enemy_5AAB:
5AAB: C5          push bc
5AAC: DD 7E 07    ld   a,(ix+current_floor_07)
; probably never happens, floor range is 0-31
5AAF: B7          or   a
5AB0: DA DC 5A    jp   c,$5ADC
5AB3: FE 1F       cp   $1F
5AB5: D2 DC 5A    jp   nc,$5ADC
5AB8: FE 14       cp   $14
5ABA: 28 23       jr   z,special_enemy_cheat_20th_floor_5ADF
5ABC: DD 5E 07    ld   e,(ix+current_floor_07)
5ABF: 16 00       ld   d,$00
5AC1: 21 10 82    ld   hl,red_door_position_array_8210
5AC4: 19          add  hl,de
5AC5: 7E          ld   a,(hl)		; red door index
5AC6: DD BE 08    cp   (ix+spawning_door_08)
5AC9: 28 11       jr   z,$5ADC		; don"t spawn enemy from red door
5ACB: 21 F1 81    ld   hl,$81F1
5ACE: 19          add  hl,de
5ACF: 7E          ld   a,(hl)
5AD0: DD 46 08    ld   b,(ix+spawning_door_08)
5AD3: 07          rlca
5AD4: 05          dec  b
5AD5: F2 D3 5A    jp   p,$5AD3
5AD8: E6 01       and  $01		; test spawn enemy
5ADA: C1          pop  bc
5ADB: C9          ret

5ADC: AF          xor  a		; don't spawn enemy
try_to_spawn_an_enemy_player_in_elev_5ADD:
5ADD: C1          pop  bc
5ADE: C9          ret

special_enemy_cheat_20th_floor_5ADF:
5ADF: 3A 21 85    ld   a,(player_structure_851A+current_floor_07)
5AE2: FE 14       cp   $14
5AE4: 20 D6       jr   nz,$5ABC
5AE6: 3A 1A 85    ld   a,(player_structure_851A+character_x_00)
5AE9: FE AE       cp   $AE
5AEB: 38 CF       jr   c,$5ABC
5AED: 3A 32 82    ld   a,(level_timer_16bit_msb_8232)
5AF0: FE 10       cp   $10
5AF2: 38 C8       jr   c,$5ABC
; if player is on 20th floor on the hard right part
; (the isolated door, with a wall on the left, and stairs)
; force enemies to spawn on that very door 
; when timer is in "hurry" mode
; (seems that they'll ignore the fact that the door is red too!)
5AF4: DD 36 08 06 ld   (ix+spawning_door_08),$06
5AF8: F6 01       or   $01		; spawn enemy
5AFA: C1          pop  bc
5AFB: C9          ret

update_enemies_timers_and_aggressivity_5afc:
5AFC: 3A 31 82    ld   a,(level_timer_16bit_8231)
5AFF: E6 FF       and  $FF
5B01: FE FF       cp   $FF
5B03: 20 11       jr   nz,$5B16
5B05: 21 4D 85    ld   hl,$854D
5B08: 11 20 00    ld   de,$0020
5B0B: 06 04       ld   b,$04
5B0D: 7E          ld   a,(hl)
5B0E: FE 0F       cp   $0F
5B10: 28 01       jr   z,$5B13
5B12: 34          inc  (hl)
5B13: 19          add  hl,de
5B14: 10 F7       djnz $5B0D
5B16: 21 48 85    ld   hl,$8548
5B19: CD 25 5B    call decrease_value_for_all_enemies_5b25
5B1C: 21 4A 85    ld   hl,$854A
5B1F: CD 25 5B    call decrease_value_for_all_enemies_5b25
5B22: 21 53 85    ld   hl,$8553
decrease_value_for_all_enemies_5b25:
5B25: 11 20 00    ld   de,$0020
5B28: 06 04       ld   b,$04
5B2A: 7E          ld   a,(hl)
5B2B: B7          or   a
5B2C: 28 01       jr   z,$5B2F
5B2E: 35          dec  (hl)
5B2F: 19          add  hl,de
5B30: 10 F8       djnz $5B2A
5B32: C9          ret
5B33: DD 36 08 FF ld   (ix+$08),$FF
5B37: 3A 21 85    ld   a,(player_structure_851A+current_floor_07)
5B3A: 47          ld   b,a
5B3B: FE 1F       cp   $1F
5B3D: 38 02       jr   c,$5B41
5B3F: 06 1E       ld   b,$1E
5B41: DD 7E 07    ld   a,(ix+$07)
5B44: B8          cp   b
5B45: CA 13 5D    jp   z,player_and_enemy_same_floor_5d13
5B48: DA 4E 5B    jp   c,$5B4E
5B4B: C3 52 5C    jp   $5C52
5B4E: DD 36 1C 03 ld   (ix+$1c),$03
5B52: DD 36 1E 00 ld   (ix+$1e),$00
5B56: DD 36 1A 78 ld   (ix+$1a),$78
5B5A: DD 7E 07    ld   a,(ix+$07)
5B5D: FE 14       cp   $14
5B5F: 28 52       jr   z,$5BB3
5B61: D0          ret  nc
5B62: FE 12       cp   $12
5B64: CA F4 5B    jp   z,$5BF4
5B67: D2 C6 5B    jp   nc,$5BC6
5B6A: FE 11       cp   $11
5B6C: CA 07 5C    jp   z,$5C07
5B6F: B7          or   a
5B70: CA 44 5C    jp   z,$5C44
5B73: FE 07       cp   $07
5B75: CA 35 5C    jp   z,$5C35
5B78: 87          add  a,a
5B79: 5F          ld   e,a
5B7A: 3A BA 85    ld   a,(current_enemy_index_85BA)
5B7D: E6 01       and  $01
5B7F: 83          add  a,e
5B80: 5F          ld   e,a
5B81: 16 00       ld   d,$00
5B83: 21 91 5B    ld   hl,table_5B93-2
5B86: 19          add  hl,de
5B87: 7E          ld   a,(hl)
5B88: DD 77 1A    ld   (ix+$1a),a
5B8B: FE C2       cp   $C2
5B8D: C0          ret  nz
5B8E: DD 36 1C 0B ld   (ix+$1c),$0B
5B92: C9          ret

table_5B93:
	dc.b	58   
	dc.b	98   
	dc.b	58   
	dc.b	98   
	dc.b	58   
	dc.b	98   
	dc.b	58   
	dc.b	98   
	dc.b	58   
	dc.b	98   
	dc.b	58   
	dc.b	98   
	dc.b	18 D8
	dc.b	18 D8
	dc.b	18 D8
	dc.b	18 D8
	dc.b	78   
	dc.b	D8   
	dc.b	D8   
	dc.b	D8   
	dc.b	18 18
	dc.b	18 18
	dc.b	78   
	dc.b	78   
	dc.b	78   
	dc.b	C2 
	.align	2

5BB3: DD 36 1A 78 ld   (ix+$1a),$78        
5BB7: DD 7E 00    ld   a,(ix+character_x_00)
5BBA: FE AC       cp   $AC
5BBC: D8          ret  c
5BBD: DD 36 1C 0B ld   (ix+$1c),$0B
5BC1: DD 36 1A E7 ld   (ix+$1a),$E7
5BC5: C9          ret
5BC6: 3A 21 85    ld   a,(player_structure_851A+current_floor_07)
5BC9: FE 14       cp   $14
5BCB: 20 10       jr   nz,$5BDD
5BCD: 3A 1A 85    ld   a,(player_structure_851A)
5BD0: FE AC       cp   $AC
5BD2: 30 17       jr   nc,$5BEB
5BD4: DD 36 1C 0B ld   (ix+$1c),$0B
5BD8: DD 36 1A 2F ld   (ix+$1a),$2F
5BDC: C9          ret
5BDD: DD 36 1A 2F ld   (ix+$1a),$2F
5BE1: DD 36 1C 0B ld   (ix+$1c),$0B
5BE5: 3A BA 85    ld   a,(current_enemy_index_85BA)
5BE8: E6 01       and  $01
5BEA: C8          ret  z
5BEB: DD 36 1A C2 ld   (ix+$1a),$C2
5BEF: DD 36 1C 0B ld   (ix+$1c),$0B
5BF3: C9          ret
5BF4: DD 36 1C 0B ld   (ix+$1c),$0B
5BF8: DD 36 1A 2F ld   (ix+$1a),$2F
5BFC: DD 7E 00    ld   a,(ix+character_x_00)
5BFF: FE 7D       cp   $7D
5C01: D8          ret  c
5C02: DD 36 1A C2 ld   (ix+$1a),$C2
5C06: C9          ret
5C07: 3A 21 85    ld   a,(player_structure_851A+current_floor_07)
5C0A: FE 12       cp   $12
5C0C: 20 10       jr   nz,$5C1E
5C0E: 3A 1A 85    ld   a,(player_structure_851A)
5C11: FE 7D       cp   $7D
5C13: 30 17       jr   nc,$5C2C
5C15: DD 36 1A 2F ld   (ix+$1a),$2F
5C19: DD 36 1C 0B ld   (ix+$1c),$0B
5C1D: C9          ret
5C1E: DD 36 1A 2F ld   (ix+$1a),$2F
5C22: DD 36 1C 0B ld   (ix+$1c),$0B
5C26: 3A BA 85    ld   a,(current_enemy_index_85BA)
5C29: E6 01       and  $01
5C2B: C8          ret  z
5C2C: DD 36 1A C2 ld   (ix+$1a),$C2
5C30: DD 36 1C 0B ld   (ix+$1c),$0B
5C34: C9          ret
5C35: DD 36 1A 18 ld   (ix+$1a),$18
5C39: DD 7E 00    ld   a,(ix+character_x_00)
5C3C: FE 91       cp   $91
5C3E: D8          ret  c
5C3F: DD 36 1A D8 ld   (ix+$1a),$D8
5C43: C9          ret

5C44: 3A 2D 80    ld   a,($802D)
5C47: 87          add  a,a
5C48: 87          add  a,a
5C49: 87          add  a,a
5C4A: 87          add  a,a
5C4B: 87          add  a,a		; times 32
5C4C: C6 38       add  a,$38
5C4E: DD 77 1A    ld   (ix+$1a),a
5C51: C9          ret

5C52: DD 36 1C 03 ld   (ix+$1c),$03
5C56: DD 36 1E 01 ld   (ix+$1e),$01
5C5A: DD 36 1A 78 ld   (ix+$1a),$78
5C5E: DD 7E 07    ld   a,(ix+current_floor_07)
5C61: FE 14       cp   $14		; 20th floor
5C63: 28 4A       jr   z,$5CAF
5C65: D0          ret  nc
5C66: FE 12       cp   $12		; 18th floor
5C68: CA 00 5D    jp   z,$5D00
5C6B: D2 D2 5C    jp   nc,$5CD2
5C6E: B7          or   a
5C6F: CA 44 5C    jp   z,$5C44
5C72: 87          add  a,a
5C73: 5F          ld   e,a
5C74: 3A BA 85    ld   a,(current_enemy_index_85BA)
5C77: E6 01       and  $01
5C79: 83          add  a,e
5C7A: 5F          ld   e,a
5C7B: 16 00       ld   d,$00
5C7D: 21 8B 5C    ld   hl,table_5C8D-2		; TODO looks fishy
5C80: 19          add  hl,de
5C81: 7E          ld   a,(hl)
5C82: DD 77 1A    ld   (ix+$1a),a
5C85: FE E7       cp   $E7
5C87: C0          ret  nz
5C88: DD 36 1C 0B ld   (ix+$1c),$0B
5C8C: C9          ret
table_5C8D:
	dc.b	58   
	dc.b	98   
	dc.b	58   
	dc.b	98   
	dc.b	58   
	dc.b	98   
	dc.b	58   
	dc.b	98   
	dc.b	58   
	dc.b	98   
	dc.b	58   
	dc.b	98   
	dc.b	58   
	dc.b	98   
	dc.b	18 D8
	dc.b	18 D8
	dc.b	18 D8
	dc.b	18 D8
	dc.b	78   
	dc.b	D8   
	dc.b	D8   
	dc.b	D8   
	dc.b	18 18
	dc.b	18 18
	dc.b	78   
	dc.b	78   
	dc.b	78   
	dc.b	E7   
	
5CAF: DD 7E 00    ld   a,(ix+character_x_00)
5CB2: FE AC       cp   $AC
5CB4: 30 13       jr   nc,$5CC9
5CB6: 3A BA 85    ld   a,(current_enemy_index_85BA)
5CB9: DD 36 1A 78 ld   (ix+$1a),$78
5CBD: E6 01       and  $01
5CBF: C0          ret  nz
5CC0: DD 36 1C 0B ld   (ix+$1c),$0B
5CC4: DD 36 1A 09 ld   (ix+$1a),$09
5CC8: C9          ret
5CC9: DD 36 1A E7 ld   (ix+$1a),$E7
5CCD: DD 36 1C 0B ld   (ix+$1c),$0B
5CD1: C9          ret
5CD2: 3A 21 85    ld   a,(player_structure_851A+current_floor_07)
5CD5: FE 12       cp   $12
5CD7: 20 10       jr   nz,$5CE9
5CD9: 3A 1A 85    ld   a,(player_structure_851A)
5CDC: FE 7D       cp   $7D
5CDE: 30 17       jr   nc,$5CF7
5CE0: DD 36 1A 09 ld   (ix+$1a),$09
5CE4: DD 36 1C 0B ld   (ix+$1c),$0B
5CE8: C9          ret
5CE9: DD 36 1A 09 ld   (ix+$1a),$09
5CED: DD 36 1C 0B ld   (ix+$1c),$0B
5CF1: 3A BA 85    ld   a,(current_enemy_index_85BA)
5CF4: E6 01       and  $01
5CF6: C8          ret  z
5CF7: DD 36 1A E7 ld   (ix+$1a),$E7
5CFB: DD 36 1C 0B ld   (ix+$1c),$0B
5CFF: C9          ret
5D00: DD 36 1A 09 ld   (ix+$1a),$09
5D04: DD 36 1C 0B ld   (ix+$1c),$0B
5D08: DD 7E 00    ld   a,(ix+character_x_00)
5D0B: FE 7D       cp   $7D
5D0D: D8          ret  c
5D0E: DD 36 1A E7 ld   (ix+$1a),$E7
5D12: C9          ret

player_and_enemy_same_floor_5d13:
5D13: DD 7E 07    ld   a,(ix+$07)
5D16: FE 14       cp   $14
5D18: 28 1A       jr   z,$5D34
5D1A: FE 12       cp   $12
5D1C: C2 47 5D    jp   nz,$5D47
5D1F: 3A 1A 85    ld   a,(player_structure_851A)
5D22: D6 7B       sub  $7B
5D24: 17          rla
5D25: 47          ld   b,a
5D26: DD 7E 00    ld   a,(ix+character_x_00)
5D29: D6 7B       sub  $7B
5D2B: 17          rla
5D2C: A8          xor  b
5D2D: E6 01       and  $01
5D2F: C2 52 5C    jp   nz,$5C52
5D32: 18 13       jr   $5D47
5D34: 3A 1A 85    ld   a,(player_structure_851A)
5D37: D6 AB       sub  $AB
5D39: 17          rla
5D3A: 47          ld   b,a
5D3B: DD 7E 00    ld   a,(ix+character_x_00)
5D3E: D6 AB       sub  $AB
5D40: 17          rla
5D41: A8          xor  b
5D42: E6 01       and  $01
5D44: C2 52 5C    jp   nz,$5C52
5D47: DD 36 1C 0D ld   (ix+$1c),$0D
5D4B: CD F5 1D    call pseudo_random_1DF5
5D4E: E6 0F       and  $0F
5D50: C6 40       add  a,$40
5D52: 47          ld   b,a
5D53: DD 7E 07    ld   a,(ix+current_floor_07)
5D56: B7          or   a
5D57: 78          ld   a,b
5D58: F2 5D 5D    jp   p,$5D5D
5D5B: ED 44       neg
5D5D: DD 77 1A    ld   (ix+$1a),a
5D60: C9          ret

5D61: CD 8E 5D    call $5D8E
5D64: 3E 0A       ld   a,$0A
5D66: 32 0E 85    ld   ($850E),a
5D69: 21 BC 84    ld   hl,elevator_tile_address_84BC
5D6C: 22 0F 85    ld   ($850F),hl
5D6F: DD 21 A7 84 ld   ix,$84A7
5D73: CD 44 5F    call elevator_stuff_5f44
5D76: 11 EB FF    ld   de,$FFEB
5D79: DD 19       add  ix,de
5D7B: 3A 0E 85    ld   a,($850E)
5D7E: 3D          dec  a
5D7F: 32 0E 85    ld   ($850E),a
5D82: F2 73 5D    jp   p,$5D73
5D85: 2A 0F 85    ld   hl,($850F)
5D88: 36 00       ld   (hl),$00
5D8A: CD 2E 61    call $612E
5D8D: C9          ret

5D8E: CD 95 5D    call $5D95
5D91: CD 29 5F    call propagate_main_scroll_value_to_elevators_5f29
5D94: C9          ret

5D95: DD 21 D5 83 ld   ix,$83D5
5D99: FD 21 7D 83 ld   iy,elevator_array_837D
5D9D: 21 81 80    ld   hl,elevator_directions_array_8081
5DA0: 22 11 85    ld   ($8511),hl
5DA3: AF          xor  a
5DA4: 32 0E 85    ld   ($850E),a
5DA7: CD DB 5D    call handle_automatic_elevator_directions_5ddb
5DAA: 11 15 00    ld   de,$0015
5DAD: DD 19       add  ix,de
5DAF: 11 08 00    ld   de,protection_crap_0008
5DB2: FD 19       add  iy,de
5DB4: 2A 11 85    ld   hl,($8511)
5DB7: 23          inc  hl
5DB8: 23          inc  hl
5DB9: 22 11 85    ld   ($8511),hl
5DBC: 3A 0E 85    ld   a,($850E)
5DBF: 3C          inc  a
5DC0: 32 0E 85    ld   ($850E),a
5DC3: FE 07       cp   $07
5DC5: C2 A7 5D    jp   nz,$5DA7
5DC8: 3A E1 83    ld   a,($83E1)
5DCB: 32 74 84    ld   ($8474),a
5DCE: 3A 20 84    ld   a,($8420)
5DD1: 32 89 84    ld   ($8489),a
5DD4: 32 9E 84    ld   ($849E),a
5DD7: 32 B3 84    ld   ($84B3),a
5DDA: C9          ret

handle_automatic_elevator_directions_5ddb:
5DDB: 2A 11 85    ld   hl,($8511)
5DDE: 23          inc  hl
5DDF: 7E          ld   a,(hl)
5DE0: B7          or   a
5DE1: CA E8 5D    jp   z,$5DE8
5DE4: DD 36 0C 00 ld   (ix+$0c),$00
5DE8: DD 66 10    ld   h,(ix+$10)
5DEB: DD 6E 0F    ld   l,(ix+$0f)
5DEE: DD 4E 0C    ld   c,(ix+$0c)
5DF1: 06 00       ld   b,$00
5DF3: 79          ld   a,c
5DF4: B7          or   a
5DF5: F2 FA 5D    jp   p,$5DFA
5DF8: 06 FF       ld   b,$FF
5DFA: 09          add  hl,bc
5DFB: E5          push hl
5DFC: CD 76 5E    call compute_d3w_from_d5w_5e76
5DFF: C1          pop  bc
5E00: EB          ex   de,hl
5E01: AF          xor  a
5E02: ED 42       sbc  hl,bc
5E04: FA 49 5E    jp   m,$5E49
5E07: 60          ld   h,b
5E08: 69          ld   l,c
5E09: AF          xor  a
5E0A: ED 52       sbc  hl,de
5E0C: FA 60 5E    jp   m,$5E60
5E0F: DD 71 0F    ld   (ix+$0f),c
5E12: DD 70 10    ld   (ix+$10),b
5E15: 2A 11 85    ld   hl,($8511)
5E18: 23          inc  hl
5E19: 7E          ld   a,(hl)
5E1A: 35          dec  (hl)
5E1B: B7          or   a
5E1C: C0          ret  nz
5E1D: 34          inc  (hl)
5E1E: FD 7E 00    ld   a,(iy+$00)
5E21: DD 86 0C    add  a,(ix+$0c)
5E24: B7          or   a
5E25: CA 2B 5E    jp   z,$5E2B
5E28: FE 30       cp   $30
5E2A: C0          ret  nz
5E2B: 06 1E       ld   b,$1E
5E2D: 3A 0E 85    ld   a,($850E)
5E30: D6 03       sub  $03
5E32: CA 47 5E    jp   z,$5E47
5E35: D2 3A 5E    jp   nc,$5E3A
5E38: ED 44       neg
5E3A: FE 03       cp   $03
5E3C: D2 47 5E    jp   nc,$5E47
5E3F: CD F5 1D    call pseudo_random_1DF5
5E42: E6 0F       and  $0F
5E44: C6 05       add  a,$05
5E46: 47          ld   b,a
5E47: 70          ld   (hl),b
5E48: C9          ret
5E49: 7D          ld   a,l
5E4A: DD 86 0C    add  a,(ix+$0c)
5E4D: DD 77 0C    ld   (ix+$0c),a
5E50: 09          add  hl,bc
5E51: DD 75 0F    ld   (ix+$0f),l
5E54: DD 74 10    ld   (ix+$10),h
5E57: 2A 11 85    ld   hl,($8511)
5E5A: 36 FE       ld   (hl),$FE
5E5C: 23          inc  hl
5E5D: 36 00       ld   (hl),$00
5E5F: C9          ret
5E60: DD 7E 0C    ld   a,(ix+$0c)
5E63: 95          sub  l
5E64: DD 77 0C    ld   (ix+$0c),a
5E67: DD 73 0F    ld   (ix+$0f),e
5E6A: DD 72 10    ld   (ix+$10),d
5E6D: 2A 11 85    ld   hl,($8511)
5E70: 36 02       ld   (hl),$02
5E72: 23          inc  hl
5E73: 36 00       ld   (hl),$00
5E75: C9          ret

compute_d3w_from_d5w_5e76:
5E76: 2A 2A 80    ld   hl,($802A)
5E79: 3A 0E 85    ld   a,($850E)
5E7C: B7          or   a
5E7D: CA FA 5E    jp   z,$5EFA
5E80: FE 03       cp   $03
5E82: 20 0B       jr   nz,$5E8F
5E84: 7C          ld   a,h
5E85: FE 03       cp   $03
5E87: 20 03       jr   nz,$5E8C
5E89: 7D          ld   a,l
5E8A: FE 60       cp   $60
5E8C: D2 D5 5E    jp   nc,$5ED5
5E8F: DD 56 14    ld   d,(ix+$14)
5E92: DD 5E 13    ld   e,(ix+$13)
5E95: EB          ex   de,hl
5E96: 01 60 00    ld   bc,$0060
5E99: 09          add  hl,bc
5E9A: 7D          ld   a,l
5E9B: 93          sub  e
5E9C: 7C          ld   a,h
5E9D: 9A          sbc  a,d
5E9E: F2 A2 5E    jp   p,$5EA2
5EA1: EB          ex   de,hl
5EA2: DD 56 12    ld   d,(ix+$12)
5EA5: DD 5E 11    ld   e,(ix+$11)
5EA8: 7D          ld   a,l
5EA9: 93          sub  e
5EAA: 7C          ld   a,h
5EAB: 9A          sbc  a,d
5EAC: F2 B0 5E    jp   p,$5EB0
5EAF: EB          ex   de,hl
5EB0: 21 A0 FF    ld   hl,$FFA0
5EB3: 19          add  hl,de
5EB4: E5          push hl
5EB5: 2A 2A 80    ld   hl,($802A)
5EB8: 11 C0 00    ld   de,$00C0
5EBB: DD 7E 0E    ld   a,(ix+$0e)
5EBE: B7          or   a
5EBF: 28 03       jr   z,$5EC4
5EC1: 11 20 01    ld   de,$0120
5EC4: 19          add  hl,de
5EC5: DD 56 12    ld   d,(ix+$12)
5EC8: DD 5E 11    ld   e,(ix+$11)
5ECB: 7D          ld   a,l
5ECC: 93          sub  e
5ECD: 7C          ld   a,h
5ECE: 9A          sbc  a,d
5ECF: F2 D3 5E    jp   p,$5ED3
5ED2: EB          ex   de,hl
5ED3: E1          pop  hl
5ED4: C9          ret
5ED5: 11 F0 03    ld   de,$03F0
5ED8: 7D          ld   a,l
5ED9: 93          sub  e
5EDA: 7C          ld   a,h
5EDB: 9A          sbc  a,d
5EDC: F2 E0 5E    jp   p,$5EE0
5EDF: EB          ex   de,hl
5EE0: 11 A0 FC    ld   de,$FCA0
5EE3: 19          add  hl,de
5EE4: E5          push hl
5EE5: 2A 2A 80    ld   hl,($802A)
5EE8: 11 40 05    ld   de,$0540
5EEB: 7D          ld   a,l
5EEC: 93          sub  e
5EED: 7C          ld   a,h
5EEE: 9A          sbc  a,d
5EEF: F2 F3 5E    jp   p,$5EF3
5EF2: EB          ex   de,hl
5EF3: 21 90 FD    ld   hl,$FD90
5EF6: 19          add  hl,de
5EF7: EB          ex   de,hl
5EF8: E1          pop  hl
5EF9: C9          ret
5EFA: DD 56 14    ld   d,(ix+$14)
5EFD: DD 5E 13    ld   e,(ix+$13)
5F00: 01 E0 FF    ld   bc,$FFE0
5F03: 09          add  hl,bc
5F04: 7D          ld   a,l
5F05: 93          sub  e
5F06: 7C          ld   a,h
5F07: 9A          sbc  a,d
5F08: F2 0C 5F    jp   p,$5F0C
5F0B: EB          ex   de,hl
5F0C: EB          ex   de,hl
5F0D: DD 66 12    ld   h,(ix+$12)
5F10: DD 6E 11    ld   l,(ix+$11)
5F13: 01 A0 FF    ld   bc,$FFA0
5F16: 09          add  hl,bc
5F17: 7D          ld   a,l
5F18: 93          sub  e
5F19: 7C          ld   a,h
5F1A: 9A          sbc  a,d
5F1B: F2 1F 5F    jp   p,$5F1F
5F1E: EB          ex   de,hl
5F1F: D5          push de
5F20: 2A 2A 80    ld   hl,($802A)
5F23: 11 20 01    ld   de,$0120
5F26: C3 C4 5E    jp   $5EC4

propagate_main_scroll_value_to_elevators_5f29:
5F29: 3A 05 80    ld   a,(main_scroll_value_8005)
5F2C: 4F          ld   c,a
5F2D: DD 21 D5 83 ld   ix,$83D5
5F31: 21 13 85    ld   hl,elevator_scroll_array_8513
5F34: 11 15 00    ld   de,$0015
5F37: 06 07       ld   b,$07
; loop on elevators
5F39: DD 7E 0F    ld   a,(ix+$0f)
5F3C: 81          add  a,c
5F3D: 77          ld   (hl),a
5F3E: 23          inc  hl
5F3F: DD 19       add  ix,de
5F41: 10 F6       djnz $5F39
5F43: C9          ret

elevator_stuff_5f44:
5F44: CD 96 5F    call $5F96
5F47: CD DF 5F    call $5FDF
5F4A: DD 66 01    ld   h,(ix+character_x_right_01)
5F4D: DD 6E 00    ld   l,(ix+character_x_00)
5F50: DD 56 03    ld   d,(ix+character_y_offset_03)
5F53: DD 5E 02    ld   e,(ix+$02)
5F56: AF          xor  a
5F57: ED 52       sbc  hl,de
5F59: D2 75 5F    jp   nc,$5F75
5F5C: DD 7E 0D    ld   a,(ix+move_direction_0d)
5F5F: B7          or   a
5F60: C8          ret  z
5F61: DD 35 0D    dec  (ix+move_direction_0d)
5F64: 3A 0C 85    ld   a,($850C)
5F67: 57          ld   d,a
5F68: D5          push de
5F69: CD 33 60    call $6033
5F6C: D1          pop  de
5F6D: 3A 0D 85    ld   a,($850D)
5F70: BA          cp   d
5F71: C8          ret  z
5F72: C3 33 60    jp   $6033
5F75: DD 7E 0D    ld   a,(ix+move_direction_0d)
5F78: B7          or   a
5F79: CA 83 5F    jp   z,$5F83
5F7C: CD 28 60    call $6028
5F7F: CD 5A 60    call $605A
5F82: C9          ret
5F83: DD 34 0D    inc  (ix+move_direction_0d)
5F86: DD 56 09    ld   d,(ix+$09)
5F89: CD 4B 60    call $604B
5F8C: DD 56 0B    ld   d,(ix+$0b)
5F8F: DD BE 09    cp   (ix+$09)
5F92: C8          ret  z
5F93: C3 4B 60    jp   $604B
5F96: 2A 28 80    ld   hl,($8028)
5F99: 44          ld   b,h
5F9A: 4D          ld   c,l
5F9B: DD 56 05    ld   d,(ix+character_delta_x_05)
5F9E: DD 5E 04    ld   e,(ix+$04)
5FA1: AF          xor  a
5FA2: ED 52       sbc  hl,de
5FA4: D2 A9 5F    jp   nc,$5FA9
5FA7: 50          ld   d,b
5FA8: 59          ld   e,c
5FA9: DD 66 01    ld   h,(ix+character_x_right_01)
5FAC: DD 6E 00    ld   l,(ix+character_x_00)
5FAF: DD 72 01    ld   (ix+character_x_right_01),d
5FB2: DD 73 00    ld   (ix+character_x_00),e
5FB5: EB          ex   de,hl
5FB6: AF          xor  a
5FB7: ED 52       sbc  hl,de
5FB9: DD 7E 09    ld   a,(ix+enemy_state_09)
5FBC: 32 0C 85    ld   ($850C),a
5FBF: 7D          ld   a,l
5FC0: DD 86 08    add  a,(ix+associated_elevator_08)
5FC3: DD 96 0C    sub  (ix+$0c)
5FC6: DD 77 08    ld   (ix+associated_elevator_08),a
5FC9: FA D6 5F    jp   m,$5FD6
5FCC: D6 08       sub  $08
5FCE: D8          ret  c
5FCF: DD 77 08    ld   (ix+associated_elevator_08),a
5FD2: DD 34 09    inc  (ix+enemy_state_09)
5FD5: C9          ret
5FD6: C6 08       add  a,$08
5FD8: DD 77 08    ld   (ix+associated_elevator_08),a
5FDB: DD 35 09    dec  (ix+enemy_state_09)
5FDE: C9          ret
5FDF: 2A 2A 80    ld   hl,($802A)
5FE2: 44          ld   b,h
5FE3: 4D          ld   c,l
5FE4: DD 56 07    ld   d,(ix+current_floor_07)
5FE7: DD 5E 06    ld   e,(ix+character_situation_06)
5FEA: AF          xor  a
5FEB: ED 52       sbc  hl,de
5FED: DA F2 5F    jp   c,$5FF2
5FF0: 50          ld   d,b
5FF1: 59          ld   e,c
5FF2: DD 66 03    ld   h,(ix+character_y_offset_03)
5FF5: DD 6E 02    ld   l,(ix+$02)
5FF8: DD 72 03    ld   (ix+character_y_offset_03),d
5FFB: DD 73 02    ld   (ix+$02),e
5FFE: EB          ex   de,hl
5FFF: AF          xor  a
6000: ED 52       sbc  hl,de
6002: DD 7E 0B    ld   a,(ix+$0b)
6005: 32 0D 85    ld   ($850D),a
6008: 7D          ld   a,l
6009: DD 86 0A    add  a,(ix+$0a)
600C: DD 96 0C    sub  (ix+$0c)
600F: DD 77 0A    ld   (ix+$0a),a
6012: FA 1F 60    jp   m,$601F
6015: D6 08       sub  $08
6017: D8          ret  c
6018: DD 77 0A    ld   (ix+$0a),a
601B: DD 34 0B    inc  (ix+$0b)
601E: C9          ret
601F: C6 08       add  a,$08
6021: DD 77 0A    ld   (ix+$0a),a
6024: DD 35 0B    dec  (ix+$0b)
6027: C9          ret
6028: 3A 0C 85    ld   a,($850C)
602B: DD 56 09    ld   d,(ix+$09)
602E: BA          cp   d
602F: C8          ret  z
6030: FA 4B 60    jp   m,$604B
6033: 4F          ld   c,a
6034: 3A 0E 85    ld   a,($850E)
6037: 47          ld   b,a
6038: CD 68 60    call $6068
603B: 2A 0F 85    ld   hl,($850F)
603E: 36 00       ld   (hl),$00
6040: 23          inc  hl
6041: 36 00       ld   (hl),$00
6043: 23          inc  hl
6044: 36 00       ld   (hl),$00
6046: 23          inc  hl
6047: 22 0F 85    ld   ($850F),hl
604A: C9          ret
604B: 4A          ld   c,d
604C: 3A 0E 85    ld   a,($850E)
604F: 47          ld   b,a
6050: CD 68 60    call $6068
6053: DD 46 0E    ld   b,(ix+$0e)
6056: CD AD 60    call $60AD
6059: C9          ret
605A: 3A 0D 85    ld   a,($850D)
605D: DD 56 0B    ld   d,(ix+$0b)
6060: BA          cp   d
6061: C8          ret  z
6062: F2 4B 60    jp   p,$604B
6065: C3 33 60    jp   $6033
6068: C5          push bc
6069: 21 97 60    ld   hl,table_6097
606C: 16 00       ld   d,$00
606E: 58          ld   e,b
606F: 19          add  hl,de
6070: 19          add  hl,de
6071: 5E          ld   e,(hl)
6072: 23          inc  hl
6073: 56          ld   d,(hl)
6074: 61          ld   h,c
6075: AF          xor  a
6076: CB 2C       sra  h
6078: 1F          rra
6079: CB 2C       sra  h
607B: 1F          rra
607C: CB 2C       sra  h
607E: 1F          rra
607F: 6F          ld   l,a
6080: EB          ex   de,hl
6081: AF          xor  a
6082: ED 52       sbc  hl,de
6084: 7C          ld   a,h
6085: E6 03       and  $03
6087: C6 CC       add  a,$CC
6089: 67          ld   h,a
608A: EB          ex   de,hl
608B: 2A 0F 85    ld   hl,($850F)
608E: 72          ld   (hl),d
608F: 23          inc  hl
6090: 73          ld   (hl),e
6091: 23          inc  hl
6092: 22 0F 85    ld   ($850F),hl
6095: C1          pop  bc
6096: C9          ret

table_6097:
	dc.b	82      
	dc.b	01 86 01
	dc.b	8A      
	dc.b	01 8E 01
	dc.b	92      
	dc.b	01 96 01
	dc.b	9A      
	dc.b	01 82 02
	dc.b	4E      
	dc.b	00      
	dc.b	8E      
	dc.b	00      
	dc.b	8E      
	dc.b	01
	
60AD: 16 07	      ld   d,$07        
60AF: 79          ld   a,c
60B0: 05          dec  b
60B1: C2 B8 60    jp   nz,$60B8
60B4: 16 13       ld   d,$13
60B6: C6 0C       add  a,$0C
60B8: 21 2A 61    ld   hl,$612A
60BB: B7          or   a
60BC: FA CF 60    jp   m,$60CF
60BF: 21 FA 60    ld   hl,$60FA
60C2: BA          cp   d
60C3: D2 CF 60    jp   nc,$60CF
60C6: 26 00       ld   h,$00
60C8: 87          add  a,a
60C9: 87          add  a,a
60CA: 6F          ld   l,a
60CB: 11 DE 60    ld   de,table_60DE
60CE: 19          add  hl,de
60CF: ED 5B 0F 85 ld   de,($850F)
60D3: ED A0       ldi
60D5: ED A0       ldi
60D7: ED A0       ldi
60D9: ED 53 0F 85 ld   ($850F),de
60DD: C9          ret

table_60DE:
	dc.b	3A FC 38
	dc.b	00      
	dc.b	3B      
	dc.b	3B      
	dc.b	3B      
	dc.b	00      
	dc.b	3B      
	dc.b	3B      
	dc.b	3B      
	dc.b	00      
	dc.b	3B      
	dc.b	3B      
	dc.b	3B      
	dc.b	00      
	dc.b	3B      
	dc.b	3B      
	dc.b	3B      
	dc.b	00      
	dc.b	3B      
	dc.b	3B      
	dc.b	3B      
	dc.b	00      
	dc.b	3E 3D   
	dc.b	3C      
	dc.b	00      
	dc.b	3F      
	dc.b	37      
	dc.b	3F      
	dc.b	00      
	dc.b	3F      
	dc.b	37      
	dc.b	3F      
	dc.b	00      
	dc.b	3F      
	dc.b	37      
	dc.b	3F      
	dc.b	00      
	dc.b	3F      
	dc.b	37      
	dc.b	3F      
	dc.b	00      
	dc.b	3F      
	dc.b	37      
	dc.b	3F      
	dc.b	00      
	dc.b	3A FC 38
	dc.b	00      
	dc.b	3B      
	dc.b	3B      
	dc.b	3B      
	dc.b	00      
	dc.b	3B      
	dc.b	3B      
	dc.b	3B      
	dc.b	00      
	dc.b	3B      
	dc.b	3B      
	dc.b	3B      
	dc.b	00      
	dc.b	3B      
	dc.b	3B      
	dc.b	3B      
	dc.b	00      
	dc.b	3B      
	dc.b	3B      
	dc.b	3B      
	dc.b	00      
	dc.b	3E 3D   
	dc.b	3C      
	dc.b	00      
	dc.b	3F      
	dc.b	3F      
	dc.b	3F      
	dc.b	00
	
612E: 21 7D 83    ld   hl,elevator_array_837D
6131: 11 E1 83    ld   de,$83E1
6134: 06 0B       ld   b,$0B
6136: C5          push bc
6137: 1A          ld   a,(de)
6138: 86          add  a,(hl)
6139: 77          ld   (hl),a
613A: FA 54 61    jp   m,$6154
613D: D6 30       sub  $30
613F: DA 46 61    jp   c,$6146
6142: 77          ld   (hl),a
6143: 23          inc  hl
6144: 34          inc  (hl)
6145: 2B          dec  hl
6146: 01 08 00    ld   bc,protection_crap_0008
6149: 09          add  hl,bc
614A: EB          ex   de,hl
614B: 01 15 00    ld   bc,$0015
614E: 09          add  hl,bc
614F: EB          ex   de,hl
6150: C1          pop  bc
6151: 10 E3       djnz $6136
6153: C9          ret

6154: C6 30       add  a,$30
6156: 77          ld   (hl),a
6157: 23          inc  hl
6158: 35          dec  (hl)
6159: C3 45 61    jp   $6145

animate_elevators_615C:
615C: CD 63 61    call set_elevator_column_scroll_6163
615F: CD 77 61    call feed_elevator_columns_6177
6162: C9          ret

set_elevator_column_scroll_6163:
6163: 21 42 D0    ld   hl,column_scroll_layer_3_D040+2
6166: 11 13 85    ld   de,elevator_scroll_array_8513
6169: 06 07       ld   b,$07		; 4*7 = 28 columns, set 3 out of 4
616B: 1A          ld   a,(de)
616C: 77          ld   (hl),a
616D: 23          inc  hl
616E: 77          ld   (hl),a
616F: 23          inc  hl
6170: 77          ld   (hl),a
6171: 23          inc  hl
6172: 23          inc  hl			; skip 1 column out of 4
6173: 13          inc  de
6174: 10 F5       djnz $616B
6176: C9          ret

feed_elevator_columns_6177:
6177: 21 BC 84    ld   hl,elevator_tile_address_84BC
617A: 7E          ld   a,(hl)
617B: B7          or   a
617C: C8          ret  z
; not zero: copy to update elevator tile columns
617D: 57          ld   d,a
617E: 23          inc  hl
617F: 5E          ld   e,(hl)
6180: 23          inc  hl
6181: ED A0       ldi
6183: ED A0       ldi
6185: ED A0       ldi
6187: C3 7A 61    jp   $617A

618A: DD 7E 09    ld   a,(ix+$09)
618D: 3C          inc  a
618E: 28 54       jr   z,disable_enemy_sprite_61e4
6190: CD 0C 62    call $620C
6193: 7C          ld   a,h
6194: B7          or   a
6195: C2 C3 61    jp   nz,$61C3
6198: 7D          ld   a,l
6199: FE 18       cp   $18
619B: DA C3 61    jp   c,$61C3
619E: FE E8       cp   $E8
61A0: D2 C3 61    jp   nc,$61C3
61A3: 7D          ld   a,l
61A4: DD 77 16    ld   (ix+$16),a
61A7: DD 86 02    add  a,(ix+$02)
61AA: DD 96 03    sub  (ix+character_y_offset_03)
61AD: DD 77 15    ld   (ix+$15),a
61B0: E5          push hl
61B1: CD 47 62    call $6247
61B4: E1          pop  hl
61B5: 45          ld   b,l
61B6: 2A BF 85    ld   hl,($85BF)
61B9: CD F0 61    call update_character_graphic_properties_61f0
61BC: CD F0 61    call update_character_graphic_properties_61f0
61BF: CD 9C 62    call $629C
61C2: C9          ret
61C3: 2A BF 85    ld   hl,($85BF)
61C6: 3E FF       ld   a,$FF
61C8: 77          ld   (hl),a
61C9: 11 05 00    ld   de,$0005
61CC: 19          add  hl,de
61CD: 77          ld   (hl),a
61CE: DD 77 04    ld   (ix+$04),a
61D1: DD 77 09    ld   (ix+$09),a
61D4: DD 36 10 00 ld   (ix+$10),$00
61D8: DD 7E 06    ld   a,(ix+character_situation_06)
61DB: FE 04       cp   $04
61DD: C0          ret  nz
61DE: 2A BB 85    ld   hl,($85BB)
61E1: 36 FF       ld   (hl),$FF
61E3: C9          ret

disable_enemy_sprite_61e4:
61E4: 2A BF 85    ld   hl,($85BF)
61E7: 3E FF       ld   a,$FF
61E9: 77          ld   (hl),a
61EA: 11 05 00    ld   de,$0005
61ED: 19          add  hl,de
61EE: 77          ld   (hl),a
61EF: C9          ret

update_character_graphic_properties_61f0:
61F0: DD 7E 04    ld   a,(ix+$04)
61F3: 77          ld   (hl),a
61F4: 23          inc  hl
61F5: 1A          ld   a,(de)
61F6: DD 86 00    add  a,(ix+character_x_00)
61F9: 77          ld   (hl),a
61FA: 13          inc  de
61FB: 23          inc  hl
61FC: 1A          ld   a,(de)
61FD: 80          add  a,b
61FE: 77          ld   (hl),a
61FF: 13          inc  de
6200: 23          inc  hl
6201: 71          ld   (hl),c
6202: 1A          ld   a,(de)
6203: B1          or   c
6204: 77          ld   (hl),a
6205: 13          inc  de
6206: 23          inc  hl
6207: 1A          ld   a,(de)
6208: 77          ld   (hl),a
6209: 13          inc  de
620A: 23          inc  hl
620B: C9          ret

620C: DD 7E 06    ld   a,(ix+character_situation_06)
620F: 3D          dec  a
6210: CA 22 62    jp   z,$6222
; not in elevator
6213: 3D          dec  a
6214: CA 2B 62    jp   z,$622B
6217: DD 46 07    ld   b,(ix+$07)
621A: 0E 00       ld   c,$00
621C: DD 56 03    ld   d,(ix+character_y_offset_03)
621F: C3 6C 1E    jp   compute_delta_height_1e6c
6222: CD CE 62    call load_character_elevator_structure_62CE
6225: FD 46 01    ld   b,(iy+$01)
6228: C3 32 62    jp   $6232
622B: CD CE 62    call load_character_elevator_structure_62CE
622E: FD 46 01    ld   b,(iy+$01)
6231: 04          inc  b
6232: 0E 00       ld   c,$00
6234: FD 7E 00    ld   a,(iy+$00)
6237: DD 86 03    add  a,(ix+character_y_offset_03)
623A: 57          ld   d,a
623B: DD 7E 08    ld   a,(ix+$08)
623E: 17          rla
623F: D2 6C 1E    jp   nc,compute_delta_height_1e6c
6242: 05          dec  b
6243: 05          dec  b
6244: C3 6C 1E    jp   compute_delta_height_1e6c
6247: 3A BA 85    ld   a,(current_enemy_index_85BA)
624A: 47          ld   b,a
624B: AF          xor  a
624C: 90          sub  b
624D: 3E 00       ld   a,$00
624F: 17          rla
6250: 17          rla
6251: DD 86 0B    add  a,(ix+$0b)
6254: 87          add  a,a
6255: 87          add  a,a
6256: 87          add  a,a
6257: 87          add  a,a
6258: DD 86 0C    add  a,(ix+$0c)
625B: 6F          ld   l,a
625C: 26 00       ld   h,$00
625E: 29          add  hl,hl
625F: 29          add  hl,hl
6260: 29          add  hl,hl
6261: 11 E2 62    ld   de,character_sprite_code_table_62E2
6264: 19          add  hl,de
6265: EB          ex   de,hl
6266: 0E 00       ld   c,$00
6268: 3A BA 85    ld   a,(current_enemy_index_85BA)
626B: B7          or   a
626C: C8          ret  z
626D: DD 7E 0C    ld   a,(ix+$0c)
6270: FE 0D       cp   $0D
6272: 28 1B       jr   z,$628F
6274: DD 7E 06    ld   a,(ix+character_situation_06)
6277: B7          or   a
6278: 28 03       jr   z,$627D
627A: FE 04       cp   $04
627C: C0          ret  nz
627D: 3A 42 82    ld   a,($8242)
6280: B7          or   a
6281: 20 09       jr   nz,$628C
6283: DD 7E 07    ld   a,(ix+$07)
6286: FE 10       cp   $10
6288: D0          ret  nc
6289: FE 0B       cp   $0B
628B: D8          ret  c
628C: 0E 04       ld   c,$04
628E: C9          ret

628F: DD 7E 00    ld   a,(ix+character_x_00)
6292: DD 77 01    ld   (ix+character_x_right_01),a
6295: DD 7E 03    ld   a,(ix+character_y_offset_03)
6298: DD 77 02    ld   (ix+$02),a
629B: C9          ret
629C: 3A BA 85    ld   a,(current_enemy_index_85BA)
629F: B7          or   a
62A0: C0          ret  nz
62A1: DD 7E 13    ld   a,(ix+$13)
62A4: B7          or   a
62A5: C8          ret  z
62A6: 2A BF 85    ld   hl,($85BF)
62A9: 11 04 00    ld   de,$0004
62AC: 19          add  hl,de
62AD: 7E          ld   a,(hl)
62AE: D6 40       sub  $40
62B0: 28 0D       jr   z,$62BF
62B2: 3D          dec  a
62B3: 28 0D       jr   z,$62C2
62B5: 3D          dec  a
62B6: 28 0D       jr   z,$62C5
62B8: 3D          dec  a
62B9: 28 0D       jr   z,$62C8
62BB: 3D          dec  a
62BC: 28 0D       jr   z,$62CB
62BE: C9          ret
62BF: 36 08       ld   (hl),$08
62C1: C9          ret
62C2: 36 30       ld   (hl),$30
62C4: C9          ret
62C5: 36 7A       ld   (hl),$7A
62C7: C9          ret
62C8: 36 7B       ld   (hl),$7B
62CA: C9          ret
62CB: 36 7C       ld   (hl),$7C
62CD: C9          ret

; < ix: character structure
; > iy: associated elevator
load_character_elevator_structure_62CE:
62CE: D9          exx
62CF: DD 7E 08    ld   a,(ix+associated_elevator_08)	; elevator next to character?
62D2: E6 7F       and  $7F
62D4: 87          add  a,a
62D5: 87          add  a,a
62D6: 87          add  a,a		; times 8
62D7: 16 00       ld   d,$00
62D9: 5F          ld   e,a
62DA: FD 21 7D 83 ld   iy,elevator_array_837D
62DE: FD 19       add  iy,de
62E0: D9          exx
62E1: C9          ret

; sprite table with parts of code "hidden" in it, probably inserted there to save space
; because some offsets weren't used?? WTF
table_62E2:
	.byte	FB 00 00 40 FB 10 00 4E FB 00 00 41 FA 10 00 4E ; 62E2 
	.byte	FA 00 00 42 00 00 00 00 FB FE 00 43 FB 0E 00 4E ; 62F2 
	.byte	FB 00 00 49 FB 10 00 4F FC 00 00 44 00 00 00 00 ; 6302 
	.byte	FD 00 03 44 00 00 00 00 FB 08 00 45 00 00 00 00 ; 6312 
	.byte	FB 08 00 46 00 00 00 00 00 00 00 00 00 00 00 00 ; 6322 
	.byte	FD 00 00 4A 00 00 00 00 FC 00 00 47 00 00 00 00 ; 6332 
	.byte	FC 00 00 48 00 00 00 00 FD 00 00 4B 00 00 00 00 ; 6342 
	.byte	FD 7E 00 B7 C8 DD 7E 06 B7 C3 D2 63 FD 7E 00 C9 ; 6352 real code!
	.byte	FE 00 01 40 FE 10 01 4E FE 00 01 41 FF 10 01 4E ; 6362 
	.byte	FF 00 01 42 00 00 00 00 FE FE 01 43 FE 0E 01 4E ; 6372 
	.byte	FE 00 01 49 FE 10 01 4F FD 00 01 44 00 00 00 00 ; 6382 
	.byte	FC 00 02 44 00 00 00 00 FE 08 01 45 00 00 00 00 ; 6392 
	.byte	FE 08 01 46 00 00 00 00 00 00 00 00 00 00 00 00 ; 63A2 
	.byte	FC 00 01 4A 00 00 00 00 FD 00 01 47 00 00 00 00 ; 63B2 
	.byte	FD 00 01 48 00 00 00 00 FC 00 01 4B 00 00 00 00 ; 63C2 
	.byte	C2 08 46 DD 7E 03 FE 07 D8 C3 08 46 DD 7E 03 D8 ; 63D2 real code!
	.byte	FB 00 00 50 FB 10 00 5E FB 00 00 51 FA 10 00 5E ; 63E2 
	.byte	FA 00 00 52 00 00 00 00 FB FE 00 53 FB 0E 00 5E ; 63F2 
	.byte	FB 00 00 59 FB 10 00 5F FC 00 00 54 00 00 00 00 ; 6402 
	.byte	FD 00 03 54 00 00 00 00 FB 08 00 55 00 00 00 00 ; 6412 
	.byte	FB 08 00 56 00 00 00 00 F6 00 00 5D 06 00 00 5C ; 6422 
	.byte	FD 00 00 5A 00 00 00 00 FC 00 00 57 00 00 00 00 ; 6432 
	.byte	FC 00 00 58 00 00 00 00 FD 00 00 5B 00 00 00 00 ; 6442 
	.byte	FA 01 FF 00 19 00 00 01 6D 00 A7 00 53 00 0A 00 ; 6452
	.byte	FE 00 01 50 FE 10 01 5E FE 00 01 51 FF 10 01 5E ; 6462 
	.byte	FF 00 01 52 00 00 00 00 FE FE 01 53 FE 0E 01 5E ; 6472 
	.byte	FE 00 01 59 FE 10 01 5F FD 00 01 54 00 00 00 00 ; 6482 
	.byte	FC 00 02 54 00 00 00 00 FE 08 01 55 00 00 00 00 ; 6492 
	.byte	FE 08 01 56 00 00 00 00 FD 00 01 5C 0D 00 01 5D ; 64A2 
	.byte	FC 00 01 5A 00 00 00 00 FD 00 01 57 00 00 00 00 ; 64B2 
	.byte	FD 00 01 58 00 00 00 00 FC 00 01 5B 00 00 00 00 ; 64C2 



6352: FD 7E 00    ld   a,(iy+$00)
6355: B7          or   a
6356: C8          ret  z
6357: DD 7E 06    ld   a,(ix+$06)
635A: B7          or   a
635B: C3 D2 63    jp   $63D2

635E: FD 7E 00    ld   a,(iy+$00)
6361: C9          ret


63D2: C2 08 46    jp   nz,$4608
63D5: DD 7E 03    ld   a,(ix+character_y_offset_03)
63D8: FE 07       cp   $07
63DA: D8          ret  c
63DB: C3 08 46    jp   $4608

l_64D2:
music_control_64d2:
64D2: 3A 79 87    ld   a,($8779)
64D5: FE FF       cp   $FF
64D7: 28 26       jr   z,$64FF
64D9: 47          ld   b,a
64DA: 3E FF       ld   a,$FF
64DC: 32 79 87    ld   ($8779),a
64DF: 3A 61 87    ld   a,($8761)
64E2: 4F          ld   c,a
64E3: 3A 60 87    ld   a,($8760)
64E6: 3C          inc  a
64E7: E6 0F       and  $0F
64E9: B9          cp   c
64EA: 20 01       jr   nz,$64ED
64EC: 0C          inc  c
64ED: 6F          ld   l,a
64EE: 26 00       ld   h,$00
64F0: 32 60 87    ld   ($8760),a
64F3: 79          ld   a,c
64F4: E6 0F       and  $0F
64F6: 32 61 87    ld   ($8761),a
64F9: 78          ld   a,b
64FA: 01 62 87    ld   bc,$8762
64FD: 09          add  hl,bc
64FE: 77          ld   (hl),a
64FF: C9          ret

handle_music_6500:
6500: 2A C1 85    ld   hl,($85C1)
6503: 3A C3 85    ld   a,($85C3)
6506: 4F          ld   c,a
6507: 7E          ld   a,(hl)
6508: AD          xor  l
6509: 81          add  a,c
650A: 32 C3 85    ld   ($85C3),a
650D: 23          inc  hl
650E: 22 C1 85    ld   ($85C1),hl
6511: 7C          ld   a,h
6512: FE 60       cp   $60
6514: C2 31 65    jp   nz,$6531	; bootleg: remove nz cond, always jump
6517: 21 00 00    ld   hl,$0000
651A: 22 C1 85    ld   ($85C1),hl
651D: 21 C3 85    ld   hl,$85C3
6520: 3A FA 7F    ld   a,($7FFA)
6523: 00          nop
6524: AE          xor  (hl)
6525: 77          ld   (hl),a
6526: CA 31 65    jp   z,$6531
6529: 3E 33       ld   a,$33
652B: 32 C4 85    ld   ($85C4),a
652E: 3E 24       ld   a,$24
6530: E7          rst  $20
6531: DD 21 00 87 ld   ix,$8700
6535: 21 0E D4    ld   hl,dip_switches_D40E
6538: DD CB 16 B6 res  6,(ix+$16)
653C: DD CB 16 BE res  7,(ix+$16)
6540: 06 00       ld   b,$00
6542: DD E5       push ix
6544: FD E1       pop  iy
6546: DD 5E 0D    ld   e,(ix+move_direction_0d)
6549: DD 56 0E    ld   d,(ix+$0e)
654C: DD 36 0D 00 ld   (ix+move_direction_0d),$00
6550: DD 36 0E 00 ld   (ix+$0e),$00
6554: CB 3A       srl  d
6556: CB 1B       rr   e
6558: 30 07       jr   nc,$6561
655A: FD 7E 0F    ld   a,(iy+$0f)
655D: 70          ld   (hl),b
655E: 23          inc  hl
655F: 77          ld   (hl),a
6560: 2B          dec  hl
6561: FD 23       inc  iy
6563: 04          inc  b
6564: 78          ld   a,b
6565: FE 10       cp   $10
6567: 38 EB       jr   c,$6554
6569: C9          ret

handle_music_656a:
656A: 3A 60 87    ld   a,($8760)
656D: 47          ld   b,a
656E: 3A 61 87    ld   a,($8761)
6571: B8          cp   b
6572: 28 1C       jr   z,$6590
6574: 3C          inc  a
6575: E6 0F       and  $0F
6577: 32 61 87    ld   ($8761),a
657A: 21 62 87    ld   hl,$8762
657D: 06 00       ld   b,$00
657F: 4F          ld   c,a
6580: 09          add  hl,bc
6581: 7E          ld   a,(hl)
6582: FE FF       cp   $FF
6584: 20 07       jr   nz,$658D
6586: 3E 01       ld   a,$01
6588: 32 73 87    ld   ($8773),a
658B: 18 03       jr   $6590
658D: CD 91 65    call $6591
6590: C9          ret

6591: 01 06 00    ld   bc,$0006
6594: 21 D6 6B    ld   hl,table_6BDC-6
6597: 09          add  hl,bc
6598: BE          cp   (hl)
6599: 30 FC       jr   nc,$6597
659B: 3F          ccf
659C: ED 42       sbc  hl,bc
659E: 46          ld   b,(hl)
659F: 90          sub  b
65A0: 47          ld   b,a
65A1: 23          inc  hl
65A2: 7E          ld   a,(hl)
65A3: B8          cp   b
65A4: 30 02       jr   nc,$65A8
65A6: 06 00       ld   b,$00
65A8: 23          inc  hl
65A9: 5E          ld   e,(hl)
65AA: 23          inc  hl
65AB: 56          ld   d,(hl)
65AC: D5          push de
65AD: 23          inc  hl
65AE: 5E          ld   e,(hl)
65AF: 23          inc  hl
65B0: 56          ld   d,(hl)
65B1: 7A          ld   a,d
65B2: D5          push de
65B3: DD E1       pop  ix
65B5: D1          pop  de
65B6: 26 00       ld   h,$00
65B8: 68          ld   l,b
65B9: 29          add  hl,hl
65BA: 19          add  hl,de
65BB: 4E          ld   c,(hl)
65BC: 23          inc  hl
65BD: 46          ld   b,(hl)
65BE: 0A          ld   a,(bc)
65BF: E6 1F       and  $1F
65C1: 57          ld   d,a
65C2: DD 7E 03    ld   a,(ix+character_y_offset_03)
65C5: E6 1F       and  $1F
65C7: BA          cp   d
65C8: 30 06       jr   nc,$65D0
65CA: DD CB 00 4E bit  1,(ix+character_x_00)
65CE: 20 0E       jr   nz,$65DE
65D0: DD CB 00 C6 set  0,(ix+character_x_00)
65D4: DD CB 00 8E res  1,(ix+character_x_00)
65D8: DD 71 01    ld   (ix+character_x_right_01),c
65DB: DD 70 02    ld   (ix+$02),b
65DE: C9          ret

65DF: DD 21 00 87 ld   ix,$8700
65E3: 3E 01       ld   a,$01
65E5: 32 72 87    ld   ($8772),a
65E8: DD CB 00 46 bit  0,(ix+character_x_00)
65EC: 28 26       jr   z,$6614
65EE: DD E5       push ix
65F0: D1          pop  de
65F1: 13          inc  de
65F2: 13          inc  de
65F3: 13          inc  de
65F4: DD 66 02    ld   h,(ix+$02)
65F7: DD 6E 01    ld   l,(ix+character_x_right_01)
65FA: 01 08 00    ld   bc,protection_crap_0008
65FD: ED B0       ldir
65FF: DD 7E 05    ld   a,(ix+character_delta_x_05)
6602: DD 77 0C    ld   (ix+$0c),a
6605: DD 36 0B 01 ld   (ix+$0b),$01
6609: DD CB 00 CE set  1,(ix+character_x_00)
660D: DD CB 00 86 res  0,(ix+character_x_00)
6611: CD C1 6B    call $6BC1
6614: DD CB 00 4E bit  1,(ix+character_x_00)
6618: 28 03       jr   z,$661D
661A: CD 3D 66    call $663D
661D: DD CB 00 4E bit  1,(ix+character_x_00)
6621: 28 0C       jr   z,$662F
6623: DD 7E 09    ld   a,(ix+$09)
6626: A7          and  a
6627: 28 03       jr   z,$662C
6629: CD F4 68    call $68F4
662C: CD 05 68    call $6805
662F: 06 00       ld   b,$00
6631: 0E 60       ld   c,$60
6633: DD 09       add  ix,bc
6635: 3A 72 87    ld   a,($8772)
6638: 3D          dec  a
6639: C2 E5 65    jp   nz,$65E5
663C: C9          ret
663D: DD 35 0B    dec  (ix+$0b)
6640: C2 7E 67    jp   nz,$677E
6643: DD 6E 06    ld   l,(ix+character_situation_06)
6646: DD 66 07    ld   h,(ix+$07)
6649: 7E          ld   a,(hl)
664A: FE 80       cp   $80
664C: 20 50       jr   nz,$669E
664E: 3E FF       ld   a,$FF
6650: DD BE 0A    cp   (ix+$0a)
6653: 28 36       jr   z,$668B
6655: DD 35 0A    dec  (ix+$0a)
6658: 20 31       jr   nz,$668B
665A: DD 35 0C    dec  (ix+$0c)
665D: 20 18       jr   nz,$6677
665F: 3E FF       ld   a,$FF
6661: DD BE 04    cp   (ix+$04)
6664: 28 05       jr   z,$666B
6666: DD 35 04    dec  (ix+$04)
6669: 28 08       jr   z,$6673
666B: DD 7E 05    ld   a,(ix+character_delta_x_05)
666E: DD 77 0C    ld   (ix+$0c),a
6671: 18 04       jr   $6677
6673: DD CB 00 8E res  1,(ix+character_x_00)
6677: CD 8F 67    call $678F
667A: DD 77 0A    ld   (ix+$0a),a
667D: DD 70 07    ld   (ix+$07),b
6680: DD 71 06    ld   (ix+$06),c
6683: DD 72 09    ld   (ix+$09),d
6686: DD 73 08    ld   (ix+$08),e
6689: 18 09       jr   $6694
668B: CD 8F 67    call $678F
668E: DD 70 07    ld   (ix+$07),b
6691: DD 71 06    ld   (ix+$06),c
6694: DD 36 0B 01 ld   (ix+$0b),$01
6698: CD C1 6B    call $6BC1
669B: C3 7E 67    jp   $677E
669E: E6 7F       and  $7F
66A0: DD 77 0B    ld   (ix+$0b),a
66A3: 23          inc  hl
66A4: 7E          ld   a,(hl)
66A5: CB 7F       bit  7,a
66A7: C2 78 67    jp   nz,$6778
66AA: 47          ld   b,a
66AB: E6 0F       and  $0F
66AD: 4F          ld   c,a
66AE: 78          ld   a,b
66AF: E6 70       and  $70
66B1: 47          ld   b,a
66B2: DD E5       push ix
66B4: 59          ld   e,c
66B5: 16 00       ld   d,$00
66B7: DD 19       add  ix,de
66B9: 23          inc  hl
66BA: 7E          ld   a,(hl)
66BB: DD 77 0F    ld   (ix+$0f),a
66BE: DD E1       pop  ix
66C0: 78          ld   a,b
66C1: CB 3F       srl  a
66C3: CB 3F       srl  a
66C5: CB 3F       srl  a
66C7: 5F          ld   e,a
66C8: 16 00       ld   d,$00
66CA: FD 21 7F 67 ld   iy,table_677F
66CE: FD 19       add  iy,de
66D0: FD 5E 00    ld   e,(iy+$00)
66D3: FD 23       inc  iy
66D5: FD 56 00    ld   d,(iy+$00)
66D8: D5          push de
66D9: FD E1       pop  iy
66DB: 06 00       ld   b,$00
66DD: FD E9       jp   (iy)
66DF: CD B2 67    call $67B2
66E2: FE 00       cp   $00
66E4: 28 04       jr   z,$66EA
66E6: FD 36 00 01 ld   (iy+$00),$01
66EA: 18 75       jr   $6761
66EC: CD B2 67    call $67B2
66EF: FE 00       cp   $00
66F1: 28 10       jr   z,$6703
66F3: 06 50       ld   b,$50
66F5: CD DA 67    call $67DA
66F8: FD 70 00    ld   (iy+$00),b
66FB: FD 34 00    inc  (iy+$00)
66FE: 23          inc  hl
66FF: 7E          ld   a,(hl)
6700: FD 77 01    ld   (iy+$01),a
6703: 18 5C       jr   $6761
6705: CD B2 67    call $67B2
6708: FE 00       cp   $00
670A: 28 10       jr   z,$671C
670C: 06 40       ld   b,$40
670E: CD DA 67    call $67DA
6711: FD 70 00    ld   (iy+$00),b
6714: FD 34 00    inc  (iy+$00)
6717: 23          inc  hl
6718: 7E          ld   a,(hl)
6719: FD 77 01    ld   (iy+$01),a
671C: 18 43       jr   $6761
671E: 23          inc  hl
671F: 79          ld   a,c
6720: FE 0F       cp   $0F
6722: 28 0D       jr   z,$6731
6724: DD E5       push ix
6726: 59          ld   e,c
6727: 16 00       ld   d,$00
6729: DD 19       add  ix,de
672B: 7E          ld   a,(hl)
672C: DD 77 10    ld   (ix+$10),a
672F: DD E1       pop  ix
6731: CD B2 67    call $67B2
6734: FE 00       cp   $00
6736: 28 04       jr   z,$673C
6738: FD 36 00 81 ld   (iy+$00),$81
673C: 06 80       ld   b,$80
673E: 18 21       jr   $6761
6740: CD B2 67    call $67B2
6743: FE 00       cp   $00
6745: 28 1A       jr   z,$6761
6747: 06 60       ld   b,$60
6749: CD DA 67    call $67DA
674C: FD 70 00    ld   (iy+$00),b
674F: FD 34 00    inc  (iy+$00)
6752: 23          inc  hl
6753: 7E          ld   a,(hl)
6754: FD 77 01    ld   (iy+$01),a
6757: 23          inc  hl
6758: 7E          ld   a,(hl)
6759: FD 77 02    ld   (iy+$02),a
675C: 23          inc  hl
675D: 7E          ld   a,(hl)
675E: FD 77 03    ld   (iy+$03),a
6761: 78          ld   a,b
6762: B1          or   c
6763: 4F          ld   c,a
6764: CD EC 67    call $67EC
6767: DD 7E 0D    ld   a,(ix+move_direction_0d)
676A: B3          or   e
676B: DD 77 0D    ld   (ix+move_direction_0d),a
676E: DD 7E 0E    ld   a,(ix+$0e)
6771: B2          or   d
6772: DD 77 0E    ld   (ix+$0e),a
6775: C3 A3 66    jp   $66A3
6778: DD 74 07    ld   (ix+$07),h
677B: DD 75 06    ld   (ix+$06),l
677E: C9          ret

table_677F:
	dc.B	DF      
	dc.B	66      
	dc.B	EC 66 05
	dc.B	67      
	dc.B	1E 67   
	dc.B	40      
	dc.B	67      
	dc.B	EC 66 05
	dc.B	67      
	dc.B	1E 67   

678F: DD 5E 01    ld   e,(ix+character_x_right_01)
6792: DD 56 02    ld   d,(ix+$02)
6795: 13          inc  de
6796: 13          inc  de
6797: 13          inc  de
6798: DD 7E 05    ld   a,(ix+character_delta_x_05)
679B: DD 46 0C    ld   b,(ix+$0c)
679E: 90          sub  b
679F: 06 00       ld   b,$00
67A1: 4F          ld   c,a
67A2: C5          push bc
67A3: E1          pop  hl
67A4: 29          add  hl,hl
67A5: 29          add  hl,hl
67A6: 09          add  hl,bc
67A7: 19          add  hl,de
67A8: 4E          ld   c,(hl)
67A9: 23          inc  hl
67AA: 46          ld   b,(hl)
67AB: 23          inc  hl
67AC: 5E          ld   e,(hl)
67AD: 23          inc  hl
67AE: 56          ld   d,(hl)
67AF: 23          inc  hl
67B0: 7E          ld   a,(hl)
67B1: C9          ret

67B2: D5          push de
67B3: FD 21 CA 67 ld   iy,table_67CA
67B7: 59          ld   e,c
67B8: 16 00       ld   d,$00
67BA: FD 19       add  iy,de
67BC: FD 7E 00    ld   a,(iy+$00)
67BF: 5F          ld   e,a
67C0: 16 00       ld   d,$00
67C2: DD E5       push ix
67C4: FD E1       pop  iy
67C6: FD 19       add  iy,de
67C8: D1          pop  de
67C9: C9          ret

table_67CA:
	dc.b	1F
	dc.b	00
	dc.b	23
	dc.b	00
	dc.b	27
	dc.b	00
	dc.b	2B
	dc.b	00
	dc.b	2F
	dc.b	33
	dc.b	37
	dc.b	00
	dc.b	00
	dc.b	00
	dc.b	3B
	dc.b	3F

67DA: 79          ld   a,c
67DB: FE 00       cp   $00
67DD: 28 0A       jr   z,$67E9
67DF: FE 02       cp   $02
67E1: 28 06       jr   z,$67E9
67E3: FE 04       cp   $04
67E5: 28 02       jr   z,$67E9
67E7: 18 02       jr   $67EB
67E9: CB F8       set  7,b
67EB: C9          ret

67EC: 11 01 00    ld   de,$0001
67EF: CB 79       bit  7,c
67F1: 28 03       jr   z,$67F6
67F3: 11 03 00    ld   de,$0003
67F6: 79          ld   a,c
67F7: E6 0F       and  $0F
67F9: FE 00       cp   $00
67FB: 28 07       jr   z,$6804
67FD: CB 23       sla  e
67FF: CB 12       rl   d
6801: 3D          dec  a
6802: 18 F5       jr   $67F9
6804: C9          ret

6805: 97          sub  a
6806: 32 74 87    ld   ($8774),a
6809: 4F          ld   c,a
680A: CD B2 67    call $67B2
680D: FE 00       cp   $00
680F: CA CC 68    jp   z,$68CC
6812: FD CB 00 76 bit  6,(iy+$00)
6816: CA CC 68    jp   z,$68CC
6819: FD 35 00    dec  (iy+$00)
681C: FD 7E 00    ld   a,(iy+$00)
681F: E6 0F       and  $0F
6821: C2 CC 68    jp   nz,$68CC
6824: FD 7E 01    ld   a,(iy+$01)
6827: E6 F0       and  $F0
6829: CB 3F       srl  a
682B: CB 3F       srl  a
682D: CB 3F       srl  a
682F: CB 3F       srl  a
6831: FD B6 00    or   (iy+$00)
6834: FD 77 00    ld   (iy+$00),a
6837: 3A 74 87    ld   a,($8774)
683A: FD CB 00 7E bit  7,(iy+$00)
683E: 28 02       jr   z,$6842
6840: CB FF       set  7,a
6842: 4F          ld   c,a
6843: CD EC 67    call $67EC
6846: 7B          ld   a,e
6847: DD B6 0D    or   (ix+move_direction_0d)
684A: DD 77 0D    ld   (ix+move_direction_0d),a
684D: 7A          ld   a,d
684E: DD B6 0E    or   (ix+$0e)
6851: DD 77 0E    ld   (ix+$0e),a
6854: DD E5       push ix
6856: 3A 74 87    ld   a,($8774)
6859: 5F          ld   e,a
685A: 16 00       ld   d,$00
685C: DD 19       add  ix,de
685E: DD 6E 0F    ld   l,(ix+$0f)
6861: DD 66 10    ld   h,(ix+$10)
6864: DD E1       pop  ix
6866: FD CB 00 6E bit  5,(iy+$00)
686A: 28 33       jr   z,$689F
686C: FD 5E 02    ld   e,(iy+$02)
686F: FD 56 03    ld   d,(iy+$03)
string_player_hiscore_6872:
6872: 1A          ld   a,(de)
6873: 4F          ld   c,a
6874: 13          inc  de
6875: 1A          ld   a,(de)
6876: FD 73 02    ld   (iy+$02),e
6879: FD 72 03    ld   (iy+$03),d
687C: FE 00       cp   $00
687E: 28 19       jr   z,$6899
6880: FD 7E 01    ld   a,(iy+$01)
6883: E6 0F       and  $0F
6885: CD D6 68    call compute_d1w_from_d0b_68d6
6888: CD B9 6B    call compute_d1w_6bb9
688B: 09          add  hl,bc
688C: 1A          ld   a,(de)
688D: 4F          ld   c,a
688E: FD 7E 01    ld   a,(iy+$01)
6891: E6 0F       and  $0F
6893: CD D6 68    call compute_d1w_from_d0b_68d6
6896: 09          add  hl,bc
6897: 18 04       jr   $689D
6899: FD CB 00 B6 res  6,(iy+$00)
689D: 18 15       jr   $68B4
689F: FD 7E 01    ld   a,(iy+$01)
68A2: E6 0F       and  $0F
68A4: 4F          ld   c,a
68A5: 06 00       ld   b,$00
68A7: FD CB 00 66 bit  4,(iy+$00)
68AB: 28 03       jr   z,$68B0
68AD: 09          add  hl,bc
68AE: 18 04       jr   $68B4
68B0: CD B9 6B    call compute_d1w_6bb9
68B3: 09          add  hl,bc
68B4: DD E5       push ix
68B6: 3A 74 87    ld   a,($8774)
68B9: 5F          ld   e,a
68BA: 16 00       ld   d,$00
68BC: DD 19       add  ix,de
68BE: DD 75 0F    ld   (ix+$0f),l
68C1: FD CB 00 7E bit  7,(iy+$00)
68C5: 28 03       jr   z,$68CA
68C7: DD 74 10    ld   (ix+$10),h
68CA: DD E1       pop  ix
68CC: 3A 74 87    ld   a,($8774)
68CF: 3C          inc  a
68D0: FE 10       cp   $10
68D2: DA 06 68    jp   c,$6806
68D5: C9          ret

compute_d1w_from_d0b_68d6:
68D6: E5          push hl
68D7: F5          push af
68D8: 79          ld   a,c
68D9: C6 80       add  a,$80
68DB: 4F          ld   c,a
68DC: F1          pop  af
68DD: 06 00       ld   b,$00
68DF: CB 79       bit  7,c
68E1: 28 02       jr   z,$68E5
68E3: 06 FF       ld   b,$FF
68E5: 21 00 00    ld   hl,$0000
68E8: FE 00       cp   $00
68EA: 28 04       jr   z,$68F0
68EC: 09          add  hl,bc
68ED: 3D          dec  a
68EE: 18 F8       jr   $68E8
68F0: E5          push hl
68F1: C1          pop  bc
68F2: E1          pop  hl
68F3: C9          ret

68F4: DD 22 75 87 ld   ($8775),ix
68F8: DD E5       push ix
68FA: FD E1       pop  iy
68FC: 11 43 00    ld   de,$0043
68FF: FD 19       add  iy,de
6901: DD 5E 08    ld   e,(ix+$08)
6904: DD 56 09    ld   d,(ix+$09)
6907: D5          push de
6908: DD E1       pop  ix
690A: 97          sub  a
690B: 32 74 87    ld   ($8774),a
690E: FE 08       cp   $08
6910: D2 31 6A    jp   nc,$6A31
6913: DD 7E 00    ld   a,(ix+$00)
6916: E6 70       and  $70
6918: CA 31 6A    jp   z,$6A31
691B: DD 4E 00    ld   c,(ix+$00)
691E: CD 58 6A    call $6A58
6921: DA 25 6A    jp   c,$6A25
6924: CD EC 67    call $67EC
6927: DD E5       push ix
6929: DD 2A 75 87 ld   ix,($8775)
692D: DD 7E 0D    ld   a,(ix+$0d)
6930: A3          and  e
6931: C2 03 6A    jp   nz,$6A03
6934: DD 7E 0E    ld   a,(ix+$0e)
6937: A2          and  d
6938: C2 03 6A    jp   nz,$6A03
693B: DD E1       pop  ix
693D: FD 35 00    dec  (iy+$00)
6940: FD 7E 00    ld   a,(iy+$00)
6943: E6 0F       and  $0F
6945: C2 01 6A    jp   nz,$6A01
6948: DD 7E 01    ld   a,(ix+$01)
694B: E6 F0       and  $F0
694D: CB 3F       srl  a
694F: CB 3F       srl  a
6951: CB 3F       srl  a
6953: CB 3F       srl  a
6955: FD B6 00    or   (iy+$00)
6958: FD 77 00    ld   (iy+$00),a
695B: 79          ld   a,c
695C: E6 70       and  $70
695E: CB 3F       srl  a
6960: CB 3F       srl  a
6962: CB 3F       srl  a
6964: 5F          ld   e,a
6965: 16 00       ld   d,$00
6967: 21 48 6A    ld   hl,jump_table_64A8
696A: 19          add  hl,de
696B: 5E          ld   e,(hl)
696C: 23          inc  hl
696D: 56          ld   d,(hl)
696E: D5          push de
696F: E1          pop  hl
6970: DD E5       push ix
6972: 79          ld   a,c
6973: E6 0F       and  $0F
6975: 5F          ld   e,a
6976: 16 00       ld   d,$00
6978: DD 2A 75 87 ld   ix,($8775)
697C: DD 19       add  ix,de
697E: DD 5E 0F    ld   e,(ix+$0f)
6981: DD 56 10    ld   d,(ix+$10)
6984: DD E1       pop  ix
6986: E9          jp   (hl)

jump_6987:
6987: 18 4A       jr   jump_end_69d3
jump_6989:
6989: CD 8D 6A    call $6A8D
698C: 30 18       jr   nc,$69A6
698E: DD 7E 03    ld   a,(ix+$03)
6991: 2F          cpl
6992: 6F          ld   l,a
6993: 26 FF       ld   h,$FF
6995: 23          inc  hl
6996: FD 75 01    ld   (iy+$01),l
6999: FD CB 00 EE set  5,(iy+$00)
699D: CB 7C       bit  7,h
699F: 20 04       jr   nz,$69A5
69A1: FD CB 00 AE res  5,(iy+$00)
69A5: 19          add  hl,de
69A6: 18 2B       jr   jump_end_69d3
jump_69a8:
69A8: CD CB 6A    call $6ACB
69AB: 30 0D       jr   nc,$69BA
69AD: DD 6E 02    ld   l,(ix+$02)
69B0: 26 00       ld   h,$00
69B2: FD 75 01    ld   (iy+$01),l
69B5: FD CB 00 AE res  5,(iy+$00)
69B9: 19          add  hl,de
69BA: 18 17       jr   jump_end_69d3
jump_69BC:
69BC: CD 0E 6B    call $6B0E
69BF: 18 12       jr   jump_end_69d3
jump_69C1:
69C1: CD 0E 6B    call $6B0E
69C4: 18 0D       jr   jump_end_69d3
jump_69C6:
69C6: CD 51 6B    call $6B51
69C9: 18 08       jr   jump_end_69d3
jump_69CB:
69CB: CD 51 6B    call $6B51
69CE: 18 03       jr   jump_end_69d3
jump_69D0:
69D0: CD 7E 6B    call $6B7E
jump_end_69d3:
69D3: DD 4E 00    ld   c,(ix+0x00)
69D6: DD E5       push ix
69D8: 79          ld   a,c
69D9: E6 0F       and  $0F
69DB: 5F          ld   e,a
69DC: 16 00       ld   d,$00
69DE: DD 2A 75 87 ld   ix,($8775)
69E2: DD 19       add  ix,de
69E4: DD 75 0F    ld   (ix+$0f),l
69E7: CB 79       bit  7,c
69E9: 28 03       jr   z,$69EE
69EB: DD 74 10    ld   (ix+$10),h
69EE: DD E1       pop  ix
69F0: CD EC 67    call $67EC
69F3: 3A 77 87    ld   a,($8777)
69F6: B3          or   e
69F7: 32 77 87    ld   ($8777),a
69FA: 3A 78 87    ld   a,($8778)
69FD: B2          or   d
69FE: 32 78 87    ld   ($8778),a
6A01: 18 1E       jr   $6A21
6A03: DD E1       pop  ix
6A05: DD 7E 01    ld   a,(ix+character_x_right_01)
6A08: E6 F0       and  $F0
6A0A: CB 3F       srl  a
6A0C: CB 3F       srl  a
6A0E: CB 3F       srl  a
6A10: CB 3F       srl  a
6A12: DD CB 00 66 bit  4,(ix+character_x_00)
6A16: 28 02       jr   z,$6A1A
6A18: CB F7       set  6,a
6A1A: FD 77 00    ld   (iy+$00),a
6A1D: FD 36 01 00 ld   (iy+$01),$00
6A21: FD 23       inc  iy
6A23: FD 23       inc  iy
6A25: 01 04 00    ld   bc,$0004
6A28: DD 09       add  ix,bc
6A2A: 3A 74 87    ld   a,($8774)
6A2D: 3C          inc  a
6A2E: C3 0B 69    jp   $690B
6A31: DD 2A 75 87 ld   ix,($8775)
6A35: 3A 77 87    ld   a,($8777)
6A38: DD B6 0D    or   (ix+move_direction_0d)
6A3B: DD 77 0D    ld   (ix+move_direction_0d),a
6A3E: 3A 78 87    ld   a,($8778)
6A41: DD B6 0E    or   (ix+$0e)
6A44: DD 77 0E    ld   (ix+$0e),a
6A47: C9          ret

jump_table_64A8:
	.word	jump_6987   
	.word	jump_6989   
	.word	jump_69a8   
	.word	jump_69BC   
	.word	jump_69C1   
	.word	jump_69C6
	.word	jump_69CB
	.word	jump_69D0   

6A58: E5          push hl
6A59: D5          push de
6A5A: 79          ld   a,c
6A5B: E6 0F       and  $0F
6A5D: 5F          ld   e,a
6A5E: 16 00       ld   d,$00
6A60: 21 7D 6A    ld   hl,table_6A7D
6A63: 19          add  hl,de
6A64: 7E          ld   a,(hl)
6A65: FE 00       cp   $00
6A67: 20 04       jr   nz,$6A6D
6A69: 37          scf
6A6A: 3F          ccf
6A6B: 18 0D       jr   $6A7A
6A6D: FE 01       cp   $01
6A6F: 20 08       jr   nz,$6A79
6A71: 37          scf
6A72: CB 79       bit  7,c
6A74: 20 01       jr   nz,$6A77
6A76: 3F          ccf
6A77: 18 01       jr   $6A7A
6A79: 37          scf
6A7A: D1          pop  de
6A7B: E1          pop  hl
6A7C: C9          ret

table_6A7D:
	dc.b	00 00 00 00 00 00 01 10 00 00 01 10 10 10 00 01

6A8D: EB          ex   de,hl                                          
6A8E: FD 4E 01    ld   c,(iy+$01)                                     
6A91: 06 00       ld   b,$00                                          
6A93: FD CB 00 6E bit  5,(iy+$00)
6A97: 28 02       jr   z,$6A9B
6A99: 06 FF       ld   b,$FF
6A9B: C5          push bc
6A9C: CD B9 6B    call compute_d1w_6bb9
6A9F: 09          add  hl,bc
6AA0: EB          ex   de,hl
6AA1: E1          pop  hl
6AA2: DD 7E 01    ld   a,(ix+character_x_right_01)
6AA5: E6 0F       and  $0F
6AA7: 4F          ld   c,a
6AA8: 06 00       ld   b,$00
6AAA: 09          add  hl,bc
6AAB: FD CB 00 EE set  5,(iy+$00)
6AAF: CB 7C       bit  7,h
6AB1: 20 11       jr   nz,$6AC4
6AB3: FD CB 00 AE res  5,(iy+$00)
6AB7: 97          sub  a
6AB8: BC          cp   h
6AB9: 38 06       jr   c,$6AC1
6ABB: DD 7E 02    ld   a,(ix+$02)
6ABE: BD          cp   l
6ABF: 30 03       jr   nc,$6AC4
6AC1: 37          scf
6AC2: 18 06       jr   $6ACA
6AC4: FD 75 01    ld   (iy+$01),l
6AC7: 19          add  hl,de
6AC8: 37          scf
6AC9: 3F          ccf
6ACA: C9          ret

6ACB: EB          ex   de,hl
6ACC: FD 4E 01    ld   c,(iy+$01)
6ACF: 06 00       ld   b,$00
6AD1: FD CB 00 6E bit  5,(iy+$00)
6AD5: 28 02       jr   z,$6AD9
6AD7: 06 FF       ld   b,$FF
6AD9: C5          push bc
6ADA: CD B9 6B    call compute_d1w_6bb9
6ADD: 09          add  hl,bc
6ADE: EB          ex   de,hl
6ADF: E1          pop  hl
6AE0: DD 7E 01    ld   a,(ix+character_x_right_01)
6AE3: E6 0F       and  $0F
6AE5: 4F          ld   c,a
6AE6: 06 00       ld   b,$00
6AE8: CD B9 6B    call compute_d1w_6bb9
6AEB: 09          add  hl,bc
6AEC: FD CB 00 AE res  5,(iy+$00)
6AF0: CB 7C       bit  7,h
6AF2: 28 13       jr   z,$6B07
6AF4: FD CB 00 EE set  5,(iy+$00)
6AF8: 7C          ld   a,h
6AF9: FE FF       cp   $FF
6AFB: 38 07       jr   c,$6B04
6AFD: DD 7E 03    ld   a,(ix+character_y_offset_03)
6B00: 2F          cpl
6B01: BD          cp   l
6B02: 38 03       jr   c,$6B07
6B04: 37          scf
6B05: 18 06       jr   $6B0D
6B07: FD 75 01    ld   (iy+$01),l
6B0A: 19          add  hl,de
6B0B: 37          scf
6B0C: 3F          ccf
6B0D: C9          ret

6B0E: FD CB 00 76 bit  6,(iy+$00)
6B12: 28 1F       jr   z,$6B33
6B14: CD 8D 6A    call $6A8D
6B17: 30 18       jr   nc,$6B31
6B19: CD B9 6B    call compute_d1w_6bb9
6B1C: 09          add  hl,bc
6B1D: FD CB 00 B6 res  6,(iy+$00)
6B21: FD 75 01    ld   (iy+$01),l
6B24: FD CB 00 AE res  5,(iy+$00)
6B28: CB 7C       bit  7,h
6B2A: 28 04       jr   z,$6B30
6B2C: FD CB 00 EE set  5,(iy+$00)
6B30: 19          add  hl,de
6B31: 18 1D       jr   $6B50
6B33: CD CB 6A    call $6ACB
6B36: 30 18       jr   nc,$6B50
6B38: CD B9 6B    call compute_d1w_6bb9
6B3B: 09          add  hl,bc
6B3C: FD CB 00 F6 set  6,(iy+$00)
6B40: FD 75 01    ld   (iy+$01),l
6B43: FD CB 00 EE set  5,(iy+$00)
6B47: CB 7C       bit  7,h
6B49: 20 E5       jr   nz,$6B30
6B4B: FD CB 00 AE res  5,(iy+$00)
6B4F: 19          add  hl,de
6B50: C9          ret

6B51: FD CB 00 76 bit  6,(iy+$00)
6B55: 28 14       jr   z,$6B6B
6B57: CD 8D 6A    call $6A8D
6B5A: 30 0D       jr   nc,$6B69
6B5C: FD CB 00 B6 res  6,(iy+$00)
6B60: FD CB 00 AE res  5,(iy+$00)
6B64: FD 36 01 00 ld   (iy+$01),$00
6B68: EB          ex   de,hl
6B69: 18 12       jr   $6B7D
6B6B: CD CB 6A    call $6ACB
6B6E: 30 0D       jr   nc,$6B7D
6B70: FD CB 00 F6 set  6,(iy+$00)
6B74: FD CB 00 AE res  5,(iy+$00)
6B78: FD 36 01 00 ld   (iy+$01),$00
6B7C: EB          ex   de,hl
6B7D: C9          ret

6B7E: DD 6E 02    ld   l,(ix+$02)
6B81: DD 66 03    ld   h,(ix+character_y_offset_03)
6B84: FD 4E 01    ld   c,(iy+$01)
6B87: 06 00       ld   b,$00
6B89: 09          add  hl,bc
6B8A: 4E          ld   c,(hl)
6B8B: DD 7E 01    ld   a,(ix+character_x_right_01)
6B8E: E6 0F       and  $0F
6B90: CD D6 68    call compute_d1w_from_d0b_68d6
6B93: CD B9 6B    call compute_d1w_6bb9
6B96: EB          ex   de,hl
6B97: 09          add  hl,bc
6B98: EB          ex   de,hl
6B99: 23          inc  hl
6B9A: FD 34 01    inc  (iy+$01)
6B9D: 7E          ld   a,(hl)
6B9E: FE 00       cp   $00
6BA0: 20 0B       jr   nz,$6BAD
6BA2: DD 6E 02    ld   l,(ix+$02)
6BA5: DD 66 03    ld   h,(ix+character_y_offset_03)
6BA8: 7E          ld   a,(hl)
6BA9: FD 36 01 00 ld   (iy+$01),$00
6BAD: 4F          ld   c,a
6BAE: DD 7E 01    ld   a,(ix+character_x_right_01)
6BB1: E6 0F       and  $0F
6BB3: CD D6 68    call compute_d1w_from_d0b_68d6
6BB6: EB          ex   de,hl
6BB7: 09          add  hl,bc
6BB8: C9          ret

compute_d1w_6bb9:
6BB9: 78          ld   a,b
6BBA: 2F          cpl
6BBB: 47          ld   b,a
6BBC: 79          ld   a,c
6BBD: 2F          cpl
6BBE: 4F          ld   c,a
6BBF: 03          inc  bc
6BC0: C9          ret
6BC1: DD E5       push ix
6BC3: E1          pop  hl
6BC4: 01 0F 00    ld   bc,$000F
6BC7: 09          add  hl,bc
6BC8: 06 51       ld   b,$51
6BCA: 36 00       ld   (hl),$00
6BCC: 23          inc  hl
6BCD: 10 FB       djnz $6BCA
6BCF: DD 36 16 FF ld   (ix+$16),$FF
6BD3: DD 36 0E 7F ld   (ix+$0e),$7F
6BD7: DD 36 0D FF ld   (ix+move_direction_0d),$FF
6BDB: C9          ret

table_6BDC:
	dc.b	80 03 E3 6B 00 87 FF EB 6B F3 6B FB 6B 08 6C 00	; 6BDC
	dc.b	01 01 10 6C 00 00 01 01 01 01 2E 6C D2 6F FF 01	; 6BEC
	dc.b	01 02 E2 70 00 00 01 DF 6F D5 70 FF 01 01 01 DF	; 6BFC
	dc.b	6F D5 70 FF 81 00 00 01 00 02 00 03 00 04 00 05	; 6C0C
	dc.b	00 06 00 07 FF 08 00 09 00 0A 00 0B 00 0C 00 0D	; 6C1C
	dc.b	00 80 8F 07 F8 08 10 09 10 0A 10 0B 00 0C 10 0D	; 6C2C
	dc.b	00 30 78 00 32 A0 00 34 BD 03 8D 0C 08 0D 00 8F	; 6C3C
	dc.b	07 FF 9C 07 F8 0C 0A 0D 00 00 5F 02 BE 34 EF 00	; 6C4C
	dc.b	9C 0D 00 00 50 02 A0 34 1C 01 8E 0D 00 00 47 02	; 6C5C
	dc.b	8E 04 3F 8E 0C 0D 0D 00 00 43 02 86 04 1C 8E 0D	; 6C6C
	dc.b	00 00 47 02 8E 04 3F 8E 0D 00 00 50 02 A0 04 7C	; 6C7C
	dc.b	8E 0D 00 00 55 02 A9 04 AA 8E 08 0F 09 0F 0D 00	; 6C8C
	dc.b	40 50 32 84 6F 42 A0 23 84 6F 04 DE 8E 0D 00 34	; 6C9C
	dc.b	39 02 8E 08 10 09 10 0A 0F 0D 00 04 7E 8E 08 0F	; 6CAC
	dc.b	09 0F 0A 10 0D 00 00 78 02 EF 8F 08 10 09 10 0C	; 6CBC
	dc.b	10 0D 00 00 78 02 A0 34 BD 03 8D 0C 08 0D 00 8F	; 6CCC
	dc.b	07 FF 9C 07 F8 0C 0A 0D 00 00 5F 02 BE 34 EF 00	; 6CDC
	dc.b	9C 0D 00 00 50 02 A0 34 1C 01 8E 0D 00 00 47 02	; 6CEC
	dc.b	8E 04 3F 8E 0C 0D 0D 00 00 43 02 86 04 1C 8E 0D	; 6CFC
	dc.b	00 00 47 02 8E 04 3F 8E 0D 00 00 50 02 A0 04 7C	; 6D0C
	dc.b	8E 0D 00 00 5F 02 BE 04 AA 8E 08 0F 09 0F 0D 00	; 6D1C
	dc.b	40 78 33 84 6F 42 EF 34 84 6F 04 DE 8E 0D 00 34	; 6D2C
	dc.b	39 02 8E 08 10 09 10 0A 0F 0D 00 34 DE 01 8E 08	; 6D3C
	dc.b	0F 09 0F 0A 10 0D 00 30 3F 01 32 7E 02 8F 08 10	; 6D4C
	dc.b	09 10 0C 10 0D 00 30 78 00 32 A0 00 34 BD 03 8D	; 6D5C
	dc.b	0C 08 0D 00 8F 07 FF 9C 07 F8 0C 0A 0D 00 00 5F	; 6D6C
	dc.b	02 BE 34 EF 00 9C 0D 00 00 50 02 A0 34 1C 01 8E	; 6D7C
	dc.b	0D 00 00 47 02 8E 04 3F 8E 0C 0D 0D 00 00 43 02	; 6D8C
	dc.b	86 04 1C 8E 0D 00 00 47 02 8E 04 3F 8E 0D 00 00	; 6D9C
	dc.b	50 02 A0 04 7C 8E 0D 00 00 55 02 A9 04 AA 8E 08	; 6DAC
	dc.b	0F 09 0F 0D 00 40 50 32 84 6F 42 A0 23 84 6F 04	; 6DBC
	dc.b	DE 8E 0D 00 34 39 02 8E 08 10 09 10 0A 0F 0D 00	; 6DCC
	dc.b	04 7E 8E 08 0F 09 0F 0A 10 0D 00 00 78 02 EF 8F	; 6DDC
	dc.b	08 10 09 10 0C 10 0D 00 00 78 02 A0 34 BD 03 8D	; 6DEC
	dc.b	0C 08 0D 00 8F 07 FF 9C 07 F8 0C 0A 0D 00 00 5F	; 6DFC
	dc.b	02 BE 34 EF 00 9C 0D 00 00 50 02 A0 34 1C 01 8E	; 6E0C
	dc.b	0D 00 00 47 02 8E 04 3F 8E 0C 0D 0D 00 00 43 02	; 6E1C
	dc.b	86 04 1C 8E 0D 00 00 47 02 8E 04 3F 8E 0D 00 00	; 6E2C
	dc.b	50 02 A0 04 7C 8E 0D 00 00 5F 02 BE 04 AA 9C 0C	; 6E3C
	dc.b	20 0D 00 40 78 33 84 6F 42 EF 34 84 6F 04 DE 89	; 6E4C
	dc.b	0C 0A 0D 00 00 8E 32 1C 01 34 39 02 89 0D 00 00	; 6E5C
	dc.b	78 32 EF 00 34 DE 01 89 0D 00 00 6B 02 D5 04 AA	; 6E6C
	dc.b	94 0D 00 00 65 02 C9 34 BD 03 88 0D 00 00 5F 02	; 6E7C
	dc.b	BE 94 0D 00 00 65 02 C9 34 F7 02 88 0D 00 00 5F	; 6E8C
	dc.b	02 BE 94 0D 00 00 50 02 A0 04 7E 88 0D 00 00 5A	; 6E9C
	dc.b	02 B3 94 0D 00 00 5F 02 BE 04 39 88 0D 00 00 78	; 6EAC
	dc.b	02 EF 04 7E 94 0D 00 00 5F 02 BE 34 BD 03 88 0D	; 6EBC
	dc.b	00 00 5A 02 B3 94 0D 00 00 5F 02 BE 34 F7 02 88	; 6ECC
	dc.b	08 0F 09 0F 0D 00 00 50 02 A0 94 08 10 09 10 0D	; 6EDC
	dc.b	00 04 7E 87 0D 00 89 0A 0F 0D 00 04 39 89 0A 10	; 6EEC
	dc.b	0D 00 00 47 02 8E 89 0D 00 00 3F 02 7F 04 7E 9C	; 6EFC
	dc.b	0D 00 00 3C 02 50 34 DE 01 8E 08 0F 09 0F 0A 0D	; 6F0C
	dc.b	00 2F 02 5F 8E 00 2E 22 5E 41 94 08 10 09 10 0D	; 6F1C
	dc.b	00 00 2C 02 5A 88 0D 00 00 2F 02 5F 94 0D 00 00	; 6F2C
	dc.b	3C 02 78 88 0D 00 00 50 02 A0 89 0A 10 0D 00 00	; 6F3C
	dc.b	3C 02 78 34 BD 03 89 0D 00 00 43 02 86 34 DE 01	; 6F4C
	dc.b	89 0D 00 00 50 02 A0 34 7E 02 94 0D 00 00 3F 02	; 6F5C
	dc.b	7F 34 FB 01 C0 0C 30 0D 00 40 3C 12 84 6F 42 78	; 6F6C
	dc.b	13 84 6F 34 7E 02 9C 80 80 81 80 7F 80 81 80 7F	; 6F7C
	dc.b	80 81 80 7F 80 81 80 7F 80 81 80 7F 80 81 80 7F	; 6F8C
	dc.b	80 81 80 7F 80 81 80 7F 80 81 80 7F 80 81 80 7F	; 6F9C
	dc.b	80 81 80 7F 80 81 80 7F 80 81 80 7F 80 81 80 7F	; 6FAC
	dc.b	80 81 80 7F 80 81 80 7F 80 81 80 7F 80 81 80 7F	; 6FBC
	dc.b	80 81 80 7F 80 00 B0 11 01 01 B2 11 01 01 D4 14	; 6FCC
	dc.b	10 10 00 86 37 F8 0F 39 0D 10 3B 00 0A 0D 00 30	; 6FDC
	dc.b	65 00 32 C9 00 34 F6 03 86 00 6B 02 D5 86 0D 00	; 6FEC
	dc.b	00 71 02 E2 34 A4 02 86 00 78 02 EF 8D 38 10 10	; 6FFC
	dc.b	0D 00 00 7F 02 FD 34 F6 03 8D 0D 00 00 A9 32 52	; 700C
	dc.b	01 34 A4 02 86 38 0F 0D 0D 00 00 65 32 C9 00 34	; 701C
	dc.b	F6 03 86 00 6B 02 D5 86 0D 00 00 71 02 E2 34 A4	; 702C
	dc.b	02 86 00 78 02 EF 8D 38 10 10 0D 00 00 7F 02 FD	; 703C
	dc.b	34 F6 03 8D 0D 00 00 A9 32 52 01 34 A4 02 86 38	; 704C
	dc.b	0F 0D 0D 00 00 55 32 A9 00 34 49 05 86 00 5A 02	; 705C
	dc.b	B3 86 0D 00 00 5F 02 BE 34 87 03 86 00 65 02 C9	; 706C
	dc.b	8D 38 10 10 0D 00 00 71 02 E2 34 49 05 8D 0D 00	; 707C
	dc.b	00 65 02 C9 34 87 03 87 38 0F 0D 0D 00 00 7F 02	; 708C
	dc.b	FD 34 FB 01 86 00 B3 32 66 01 86 0D 00 00 A9 02	; 709C
	dc.b	52 34 A4 02 86 00 A0 02 3F 86 0D 00 00 97 02 2D	; 70AC
	dc.b	34 F6 03 86 00 8E 02 1C 86 0D 00 00 86 02 0C 34	; 70BC
	dc.b	49 05 86 00 7F 32 FD 00 80 E0 11 03 03 D2 12 06	; 70CC
	dc.b	06 C4 14 0C 0C 00 FF 37 FF 00 39 00 00 F0 80 31	; 70DC
	dc.b	00 88 3E 01 32 EA 82 CD 3A 71 3E 00 32 AC 80 3E	; 70EC
	dc.b	20 32 0E D5 32 4D 82 3E C0 32 0B D5 CD 4D 36 21	; 70FC
	dc.b	5A 71 11 EE C5 CD F9 29 3E 5A 32 C5 85 CD C2 26	; 710C
	dc.b	CD CF 73 3A 0C D4 CB 6F C2 2C 71 3E 5A 32 C5 85	; 711C
	dc.b	3A C5 85 3D 32 C5 85 20 E7 F3 3E 33 E7 C7 AF 32	; 712C
	dc.b	AB 80 FB 21 07 3F 22 0E D4 AF 32 36 82 CD E1 71	; 713C
	dc.b	3E 01 32 D9 81 CD 0C 26 3E 02 32 A9 80 C9 31 2C	; 714C
	dc.b	1B 31 FF CD 9A 71 CD 50 72 21 A3 80 7E 23 B6 C2	; 715C
	dc.b	40 29 CD C2 26 CD 61 72 CD 00 74 3A A2 80 B7 C0	; 716C
	dc.b	21 A3 80 7E 23 B6 C2 40 29 21 3F 86 34 7E FE 08	; 717C
	dc.b	38 E3 36 00 23 34 7E FE 5A 38 DA C3 40 29 AF 32	; 718C
	dc.b	36 82 CD E1 71 3E 01 32 D9 81 CD 0C 26 3E 01 32	; 719C
	dc.b	AC 80 3E 01 32 A9 80 CD 39 58 CD C6 57 CD B0 10	; 71AC
	dc.b	CD F9 71 FD E5 DD E5 DD 21 99 C7 FD 21 76 81 06	; 71BC
	dc.b	05 0E 53 DD 7E AD 81 FD 77 53 FD 23 DD 23 10 F3	; 71CC
	dc.b	DD E1 FD E1 C9 3A 4E 82 57 3A 36 82 CB 7A 28 01	; 71DC
	dc.b	AF 47 AF CB 72 28 01 3C A8 32 D8 81 C9 3A 50 82	; 71EC
end_table_6BDC:

run_in_service_mode_70EB:
70EB: 31 00 88    ld   sp,mcu_read_8800
70EE: 3E 01       ld   a,$01
70F0: 32 EA 82    ld   (coin_counter_lock_82EA),a		; insert coin not allowed
70F3: CD 3A 71    call $713A
70F6: 3E 00       ld   a,GS_UNKNOWN_00
70F8: 32 AC 80    ld   (game_state_80AC),a
70FB: 3E 20       ld   a,$20
70FD: 32 0E D5    ld   (bank_switch_d50e),a
7100: 32 4D 82    ld   (bank_switch_copy_824D),a
7103: 3E C0       ld   a,$C0
7105: 32 0B D5    ld   (sound_latch_D50B),a
7108: CD 4D 36    call $364D
710B: 21 5A 71    ld   hl,string_715A
710E: 11 EE C5    ld   de,$C5EE
7111: CD F9 29    call copy_string_to_screen_29F9
7114: 3E 5A       ld   a,$5A
7116: 32 C5 85    ld   ($85C5),a
7119: CD C2 26    call reload_8bit_tiimer_26C2
711C: CD CF 73    call game_tick_73cf
711F: 3A 0C D4    ld   a,(service_mode_D40C)
7122: CB 6F       bit  5,a
7124: C2 2C 71    jp   nz,$712C
7127: 3E 5A       ld   a,$5A
7129: 32 C5 85    ld   ($85C5),a
712C: 3A C5 85    ld   a,($85C5)
712F: 3D          dec  a
7130: 32 C5 85    ld   ($85C5),a
7133: 20 E7       jr   nz,$711C
7135: F3          di
7136: 3E 33       ld   a,$33
7138: E7          rst  $20
7139: C7          rst  $00
713A: AF          xor  a
713B: 32 AB 80    ld   ($80AB),a
713E: FB          ei
713F: 21 07 3F    ld   hl,$3F07
7142: 22 0E D4    ld   (dip_switches_D40E),hl
7145: AF          xor  a
7146: 32 36 82    ld   ($8236),a
7149: CD E1 71    call check_if_must_flip_screen_71e1
714C: 3E 01       ld   a,$01
714E: 32 D9 81    ld   (menu_or_game_tiles_81D9),a
7151: CD 0C 26    call init_hw_scroll_and_charset_260C
7154: 3E 02       ld   a,$02
7156: 32 A9 80    ld   (timer_8bit_reload_value_80A9),a
7159: C9          ret
; "TILT"
string_715A:
		dc.b	31 2C 1B
		dc.b	31 FF

title_and_insert_coin_sequence_715F:
715F: CD 9A 71    call init_title_state_719a                                          
7162: CD 50 72    call init_title_screen_7250
7165: 21 A3 80    ld   hl,$80A3
7168: 7E          ld   a,(hl)
7169: 23          inc  hl
716A: B6          or   (hl)
716B: C2 40 29    jp   nz,goto_next_screen_2940
716E: CD C2 26    call reload_8bit_tiimer_26C2
title_screen_loop_7171:
7171: CD 61 72    call title_animation_7261
7174: CD 00 74    call protection_check_7400
7177: 3A A2 80    ld   a,(nb_credits_80A2)
717A: B7          or   a
717B: C0          ret  nz
717C: 21 A3 80    ld   hl,$80A3
717F: 7E          ld   a,(hl)
7180: 23          inc  hl
7181: B6          or   (hl)
7182: C2 40 29    jp   nz,goto_next_screen_2940
7185: 21 3F 86    ld   hl,$863F
7188: 34          inc  (hl)
7189: 7E          ld   a,(hl)
718A: FE 08       cp   $08
718C: 38 E3       jr   c,title_screen_loop_7171
718E: 36 00       ld   (hl),$00
7190: 23          inc  hl
7191: 34          inc  (hl)
7192: 7E          ld   a,(hl)
7193: FE 5A       cp   $5A
7195: 38 DA       jr   c,title_screen_loop_7171
7197: C3 40 29    jp   goto_next_screen_2940

init_title_state_719a:
719A: AF          xor  a
719B: 32 36 82    ld   ($8236),a
719E: CD E1 71    call check_if_must_flip_screen_71e1
71A1: 3E 01       ld   a,$01
71A3: 32 D9 81    ld   (menu_or_game_tiles_81D9),a
71A6: CD 0C 26    call init_hw_scroll_and_charset_260C
71A9: 3E 01       ld   a,GS_TITLE_01
71AB: 32 AC 80    ld   (game_state_80AC),a
71AE: 3E 01       ld   a,$01
71B0: 32 A9 80    ld   (timer_8bit_reload_value_80A9),a
71B3: CD 39 58    call display_status_bars_5839
71B6: CD C6 57    call update_upper_status_bar_57C6
71B9: CD B0 10    call display_credit_info_10b0
71BC: CD F9 71    call $71F9
71BF: FD E5       push iy
71C1: DD E5       push ix
71C3: DD 21 99 C7 ld   ix,$C799
71C7: FD 21 76 81 ld   iy,$8176
71CB: 06 05       ld   b,$05
71CD: 0E 53       ld   c,$53
71CF: DD 7E AD    ld   a,(ix-$53)
71D2: 81          add  a,c
71D3: FD 77 53    ld   (iy+$53),a
71D6: FD 23       inc  iy
71D8: DD 23       inc  ix
71DA: 10 F3       djnz $71CF
71DC: DD E1       pop  ix
71DE: FD E1       pop  iy
71E0: C9          ret

check_if_must_flip_screen_71e1:
71E1: 3A 4E 82    ld   a,(copy_of_dip_switches_1_824E)
71E4: 57          ld   d,a
71E5: 3A 36 82    ld   a,($8236)
71E8: CB 7A       bit  7,d
71EA: 28 01       jr   z,$71ED
71EC: AF          xor  a
71ED: 47          ld   b,a
71EE: AF          xor  a
71EF: CB 72       bit  6,d
71F1: 28 01       jr   z,$71F4
71F3: 3C          inc  a
71F4: A8          xor  b
71F5: 32 D8 81    ld   ($81D8),a
71F8: C9          ret
71F9: 3A 50 82    ld   a,(copy_of_dip_switches_3_8250)
71FC: 21 0F 72    ld   hl,table_720F
71FF: CB 6F       bit  5,a
7201: 28 03       jr   z,$7206
7203: 21 38 72    ld   hl,table_7238
7206: 11 44 C7    ld   de,$C744
7209: 01 18 00    ld   bc,$0018
720C: ED B0       ldir
720E: C9          ret

table_720F:
	dc.b	24      
	dc.b	00      
	dc.b	31 1C 2C
	dc.b	31 2F 00
	dc.b	2E 2F   
	dc.b	1F      
	dc.b	1A      
	dc.b	06 00   
	dc.b	20 2E   
	dc.b	20 1B   
	dc.b	21 21 21
	dc.b	2C      
	dc.b	2C      
	dc.b	2C  

table_7238:
     dc.b	24 00 31 1C 2C 31 2F 00 2E 2F 1F 1A 2F 1F 1C 31
     dc.b	2C 2F 25 00 00 00 00 00


7227: 4F          ld   c,a
7228: 7E          ld   a,(hl)
7229: F6 C0       or   $C0
722B: B9          cp   c
722C: 32 0D D5    ld   (watchdog_d50d),a
722F: 28 F7       jr   z,$7228
7231: 78          ld   a,b
7232: 32 46 82    ld   (execute_dynamic_ram_code_8246),a
7235: DD E5       push ix
7237: C9          ret

init_title_screen_7250:
7250: 21 00 00    ld   hl,$0000
7253: 22 3F 86    ld   ($863F),hl
7256: 21 2F 86    ld   hl,title_letters_y_scroll_values_862F
7259: 06 10       ld   b,$10
725B: 36 00       ld   (hl),$00
725D: 23          inc  hl
725E: 10 FB       djnz $725B
7260: C9          ret

title_animation_7261:
7261: CD AF 72    call update_title_y_scroll_value_72af
7264: 21 08 CC    ld   hl,$CC08
7267: 22 09 86    ld   ($8609),hl
726A: 21 61 73    ld   hl,table_7361
726D: 22 0B 86    ld   ($860B),hl
7270: 21 0F 86    ld   hl,$860F
7273: 22 0D 86    ld   ($860D),hl
7276: 11 2F 86    ld   de,title_letters_y_scroll_values_862F
7279: 06 08       ld   b,$08
727B: 1A          ld   a,(de)
727C: 32 08 86    ld   ($8608),a
727F: 13          inc  de
7280: 1A          ld   a,(de)
7281: 32 07 86    ld   ($8607),a
7284: 13          inc  de
7285: D5          push de
7286: C5          push bc
7287: CD 34 73    call animate_elevator_letters_7334
728A: CD A5 73    call feed_scroll_with_elevator_letters_73a5
728D: 2A 09 86    ld   hl,($8609)
7290: 23          inc  hl
7291: 23          inc  hl
7292: 22 09 86    ld   ($8609),hl
7295: 2A 0B 86    ld   hl,($860B)
7298: 11 08 00    ld   de,protection_crap_0008
729B: 19          add  hl,de
729C: 22 0B 86    ld   ($860B),hl
729F: C1          pop  bc
72A0: D1          pop  de
72A1: 10 D8       djnz $727B
72A3: 21 3E 86    ld   hl,$863E
72A6: 06 08       ld   b,$08
72A8: 7E          ld   a,(hl)
72A9: 2B          dec  hl
72AA: 77          ld   (hl),a
72AB: 2B          dec  hl
72AC: 10 FA       djnz $72A8
72AE: C9          ret

update_title_y_scroll_value_72af:
72AF: 3A 40 86    ld   a,($8640)
72B2: 4F          ld   c,a
72B3: 11 2F 86    ld   de,title_letters_y_scroll_values_862F
72B6: 21 D2 72    ld   hl,table_72D4-2
72B9: 06 08       ld   b,$08
72BB: C5          push bc
72BC: E5          push hl
72BD: 79          ld   a,c
72BE: 23          inc  hl
72BF: 23          inc  hl
72C0: BE          cp   (hl)
72C1: 30 FB       jr   nc,$72BE
72C3: 23          inc  hl
72C4: 7E          ld   a,(hl)
72C5: 12          ld   (de),a
72C6: 13          inc  de
72C7: 1A          ld   a,(de)
72C8: 86          add  a,(hl)
72C9: 12          ld   (de),a
72CA: 13          inc  de
72CB: E1          pop  hl
72CC: 01 0C 00    ld   bc,$000C
72CF: 09          add  hl,bc
72D0: C1          pop  bc
72D1: 10 E8       djnz $72BB
72D3: C9          ret

table_72D4:
	dc.B	01 00 15    
	dc.B	FF          
	dc.B	1F          
	dc.B	02          
	dc.B	26 00       
	dc.B	31 FF FF    
	dc.B	00          
	dc.B	02          
	dc.B	00          
	dc.B	16 FF       
	dc.B	1F          
	dc.B	01 FF 00    
	dc.B	FF          
	dc.B	00          
	dc.B	FF          
	dc.B	00          
	dc.B	03          
	dc.B	00          
	dc.B	17          
	dc.B	FF          
	dc.B	21 02 26    
	dc.B	00          
	dc.B	31 FF FF    
	dc.B	00          
	dc.B	04          
	dc.B	00          
	dc.B	18 FF       
	dc.B	21 01 FF    
	dc.B	00          
	dc.B	FF          
	dc.B	00          
	dc.B	FF          
	dc.B	00          
	dc.B	05          
	dc.B	00          
	dc.B	19          
	dc.B	FF          
	dc.B	23          
	dc.B	02          
	dc.B	26 00       
	dc.B	31 FF FF    
	dc.B	00          
	dc.B	06 00       
	dc.B	1A          
	dc.B	FF          
	dc.B	23          
	dc.B	01 FF 00    
	dc.B	FF          
	dc.B	00          
	dc.B	FF          
	dc.B	00          
	dc.B	07          
	dc.B	00          
	dc.B	1B          
	dc.B	FF          
	dc.B	25          
	dc.B	02          
	dc.B	26 00       
	dc.B	31 FF FF    
	dc.B	00          
	dc.B	08          
	dc.B	00          
	dc.B	1C          
	dc.B	FF          
	dc.B	25          
	dc.B	01 FF 00    
	dc.B	FF          
	dc.B	00          
	dc.B	FF          
	dc.B	00      
    
animate_elevator_letters_7334:
7334: 3A 08 86    ld   a,($8608)
7337: 3D          dec  a
7338: 11 A1 73    ld   de,$73A1
733B: F2 56 73    jp   p,$7356
733E: 3A 07 86    ld   a,($8607)
7341: ED 44       neg
7343: FE 20       cp   $20
7345: 11 A3 73    ld   de,$73A3
7348: 30 0C       jr   nc,$7356
734A: E6 F8       and  $F8
734C: 0F          rrca
734D: 0F          rrca
734E: 5F          ld   e,a
734F: 16 00       ld   d,$00
7351: 2A 0B 86    ld   hl,($860B)
7354: 19          add  hl,de
7355: EB          ex   de,hl
7356: 2A 0D 86    ld   hl,($860D)
7359: 73          ld   (hl),e
735A: 23          inc  hl
735B: 72          ld   (hl),d
735C: 23          inc  hl
735D: 22 0D 86    ld   ($860D),hl
7360: C9          ret

table_7361:
	dc.b	86 87 84 85 82 83 80 81 8D 8E 8B 8C 8B 00 89 8A
	dc.b	86 87 84 85 82 83 80 81 95 96 93 94 91 92 8F 90
	dc.b	9D 9D 9B 9C 99 9A 97 98 A5 A6 A3 A4 A1 A2 9F A0
	dc.b	AB AC A9 AA A9 AA A7 A8 B3 B4 B1 B2 AF B0 AD AE
	dc.b	00 00 F8 

73A4: F9          ld   sp,hl
feed_scroll_with_elevator_letters_73a5:
73A5: 3A 07 86    ld   a,($8607)
73A8: E6 F8       and  $F8
73AA: 6F          ld   l,a
73AB: 26 00       ld   h,$00
73AD: 29          add  hl,hl
73AE: 29          add  hl,hl
73AF: 3A 08 86    ld   a,($8608)
73B2: 3D          dec  a
73B3: F2 BE 73    jp   p,$73BE
73B6: 11 20 00    ld   de,$0020
73B9: 19          add  hl,de
73BA: 7C          ld   a,h
73BB: E6 03       and  $03
73BD: 67          ld   h,a
73BE: ED 5B 09 86 ld   de,($8609)
73C2: 19          add  hl,de
73C3: EB          ex   de,hl
73C4: 2A 0D 86    ld   hl,($860D)
73C7: 73          ld   (hl),e
73C8: 23          inc  hl
73C9: 72          ld   (hl),d
73CA: 23          inc  hl
73CB: 22 0D 86    ld   ($860D),hl
73CE: C9          ret

game_tick_73cf:
73CF: CD EA 0F    call check_credits_0fea
73D2: 3E 01       ld   a,$01
73D4: 32 AB 80    ld   ($80AB),a
73D7: 21 C6 85    ld   hl,$85C6
73DA: CB 76       bit  6,(hl)
73DC: 20 14       jr   nz,$73F2
73DE: 3E 06       ld   a,$06
73E0: CB 6E       bit  5,(hl)
73E2: 28 02       jr   z,$73E6
73E4: 3E 03       ld   a,$03
73E6: CD DD 77    call $77DD
73E9: 7E          ld   a,(hl)
73EA: 34          inc  (hl)
73EB: EF          rst  $28
; bootleg: code below replaced by alternate (lifted
; from alternate bank at 73DE
73EC: 21 C6 85    ld   hl,$85C6
73EF: 4E          ld   c,(hl)
73F0: 09          add  hl,bc
; bootleg: end original code, replacement code below
73EC: C3 E4 34    jp   $34E4
73EF: F1          pop  af
73F0: E1          pop  hl
; bootleg: end replacement code
73F1: 77          ld   (hl),a
73F2: 3A AB 80    ld   a,($80AB)
73F5: B7          or   a
73F6: 20 FA       jr   nz,$73F2
73F8: C9          ret

table_73F9:
	dc.b	1E 12
	dc.b	08   
	dc.b	1D   
	dc.b	02   
	dc.b	08   
	dc.b	5E 
	
protection_check_7400:
7400: CD EA 0F    call check_credits_0fea
7403: 3E 01       ld   a,$01
7405: 32 AB 80    ld   ($80AB),a
7408: 21 C6 85    ld   hl,$85C6
740B: CB 76       bit  6,(hl)
740D: 28 CF       jr   z,$73DE
740F: 3E 09       ld   a,$09
7411: CD DD 77    call $77DD
7414: 3A AB 80    ld   a,($80AB)
7417: B7          or   a
7418: C8          ret  z
7419: 3A D6 81    ld   a,(pseudo_random_seed_81D6)
741C: E6 07       and  $07
741E: 4F          ld   c,a
741F: 06 00       ld   b,$00
7421: EF          rst  $28
7422: 21 F8 73    ld   hl,table_73F9-1
7425: 09          add  hl,bc
7426: AE          xor  (hl)
; bootleg: should jump inconditionally	
7427: 28 C9       jr   z,$73F2   ; bootleg: should be jr $73F2
; bootleg end. Rest of the code is meant to crash
; protection fails: jump in the woods
7429: E1          pop  hl
742A: C1          pop  bc
742B: D1          pop  de
742C: DD E1       pop  ix
742E: DD E9       jp   (ix)			; indirect call!! looks like a protection!

title_animation_7430:
7430: CD 37 74    call update_title_elevator_scroll_7437
7433: CD 75 74    call display_action_title_7475
7436: C9          ret

update_title_elevator_scroll_7437:
7437: 21 2F 86    ld   hl,title_letters_y_scroll_values_862F                                       
743A: 11 48 D0    ld   de,$D048                                       
743D: ED A0       ldi                                                 
743F: ED A0       ldi  	; E                                               
7441: ED A0       ldi                                                 
7443: ED A0       ldi   ; L                                           
7445: ED A0       ldi                                                 
7447: ED A0       ldi   ; E                                              
7449: ED A0       ldi                                                 
744B: ED A0       ldi   ; V                                              
744D: ED A0       ldi                                                 
744F: ED A0       ldi   ; A                                              
7451: ED A0       ldi                                                 
7453: ED A0       ldi   ; T                                              
7455: ED A0       ldi                                                 
7457: ED A0       ldi   ; O                                              
7459: ED A0       ldi                                                 
745B: ED A0       ldi   ; R                                                                     
745D: 21 0F 86    ld   hl,$860F
7460: 06 08       ld   b,$08
7462: C5          push bc
7463: 4E          ld   c,(hl)
7464: 23          inc  hl
7465: 46          ld   b,(hl)
7466: 23          inc  hl
7467: 5E          ld   e,(hl)
7468: 23          inc  hl
7469: 56          ld   d,(hl)
746A: 23          inc  hl
746B: 0A          ld   a,(bc)
746C: 12          ld   (de),a
746D: 03          inc  bc
746E: 13          inc  de
746F: 0A          ld   a,(bc)
7470: 12          ld   (de),a
7471: C1          pop  bc
7472: 10 EE       djnz $7462
7474: C9          ret

display_action_title_7475:
7475: 3A 40 86    ld   a,($8640)
7478: 21 98 74    ld   hl,table_7498
747B: BE          cp   (hl)
747C: CA 03 75    jp   z,clear_screen_block_7503
747F: 23          inc  hl
7480: BE          cp   (hl)
7481: 28 1C       jr   z,draw_action_a_749f
7483: 23          inc  hl
7484: BE          cp   (hl)
7485: 28 20       jr   z,draw_action_c_74a7
7487: 23          inc  hl
7488: BE          cp   (hl)
7489: 28 24       jr   z,draw_action_t_74af
748B: 23          inc  hl
748C: BE          cp   (hl)
748D: 28 40       jr   z,draw_action_i_74cf
748F: 23          inc  hl
7490: BE          cp   (hl)
7491: 28 24       jr   z,draw_action_o_74b7
7493: 23          inc  hl
7494: BE          cp   (hl)
7495: 28 4E       jr   z,draw_action_n_74e5
7497: C9          ret


table_7498: 
	dc.b	30 32
	dc.b	36 3A
	dc.b	3E 42
	dc.b	46
	
draw_action_a_749f:
749F: 21 17 75    ld   hl,table_7517
74A2: 11 E6 C9    ld   de,$C9E6
74A5: 18 16       jr   $74BD
draw_action_c_74a7:
74A7: 21 29 75    ld   hl,table_7529
74AA: 11 E9 C9    ld   de,$C9E9
74AD: 18 0E       jr   $74BD
draw_action_t_74af:
74AF: 21 3B 75    ld   hl,table_753B
74B2: 11 EC C9    ld   de,$C9EC
74B5: 18 06       jr   $74BD
draw_action_o_74b7:
74B7: 21 59 75    ld   hl,table_7559
74BA: 11 F1 C9    ld   de,$C9F1		; screen address, first layer
74BD: 3E 06       ld   a,$06
74BF: ED A0       ldi
74C1: ED A0       ldi
74C3: ED A0       ldi
74C5: EB          ex   de,hl
74C6: 01 1D 00    ld   bc,$001D
74C9: 09          add  hl,bc
74CA: EB          ex   de,hl
74CB: 3D          dec  a
74CC: 20 F1       jr   nz,$74BF
74CE: C9          ret

draw_action_i_74cf:
74CF: 21 4D 75    ld   hl,table_754D
74D2: 11 EF C9    ld   de,$C9EF
74D5: 3E 06       ld   a,$06
74D7: ED A0       ldi
74D9: ED A0       ldi
74DB: EB          ex   de,hl
74DC: 01 1E 00    ld   bc,$001E
74DF: 09          add  hl,bc
74E0: EB          ex   de,hl
74E1: 3D          dec  a
74E2: 20 F3       jr   nz,$74D7
74E4: C9          ret

draw_action_n_74e5:
74E5: 21 6B 75    ld   hl,table_756B
74E8: 11 B4 C9    ld   de,$C9B4
74EB: 3E 08       ld   a,$08
74ED: ED A0       ldi
74EF: ED A0       ldi
74F1: ED A0       ldi
74F3: ED A0       ldi
74F5: ED A0       ldi
74F7: ED A0       ldi
74F9: EB          ex   de,hl
74FA: 01 1A 00    ld   bc,$001A
74FD: 09          add  hl,bc
74FE: EB          ex   de,hl
74FF: 3D          dec  a
7500: 20 EB       jr   nz,$74ED
7502: C9          ret

clear_screen_block_7503:
7503: 21 A8 CF    ld   hl,$CFA8
7506: 11 D0 FF    ld   de,$FFD0
7509: AF          xor  a
750A: 0E 07       ld   c,$07
750C: 06 10       ld   b,$10
750E: 77          ld   (hl),a
750F: 23          inc  hl
7510: 10 FC       djnz $750E
7512: 19          add  hl,de
7513: 0D          dec  c
7514: 20 F6       jr   nz,$750C
7516: C9          ret
table_7517:
	dc.b	9E       
	dc.b	B5       
	dc.b	00       
	dc.b	C8       
	dc.b	C9       
	dc.b	CA DC DD 
	dc.b	DE F0    
	dc.b	F1       
	dc.b	F2 53 54 
	dc.b	55       
	dc.b	66       
	dc.b	67       
	dc.b	68       

table_7529:
	dc.b	B7      
	dc.b	B8      
	dc.b	B9      
	dc.b	CB CC   
	dc.b	CD DF E0
	dc.b	E1      
	dc.b	F3      
	dc.b	F4 F5 56
	dc.b	57      
	dc.b	58      
	dc.b	69      
	dc.b	6A      
	dc.b	6B      
table_753B:
	dc.b	BA       
	dc.b	BB       
	dc.b	BC       
	dc.b	CE CF    
	dc.b	D0       
	dc.b	E2 E3 E4 
	dc.b	F6 F7    
	dc.b	00       
	dc.b	59       
	dc.b	5A       
	dc.b	00       
	dc.b	6C       
	dc.b	6D       
	dc.b	6E  
table_754D:	
	dc.b	BD       
	dc.b	BE       
	dc.b	D1       
	dc.b	D2 E5 E6 
	dc.b	E5       
	dc.b	E6 5B    
	dc.b	5C       
	dc.b	6F       
	dc.b	70       

table_7559:
	dc.b	BF      
	dc.b	C0      
	dc.b	C1      
	dc.b	D3 D4   
	dc.b	D5      
	dc.b	E7      
	dc.b	E8      
	dc.b	E9      
	dc.b	FA FB FC
	dc.b	5D      
	dc.b	5E      
	dc.b	5F      
	dc.b	71      
	dc.b	72      
	dc.b	73  
table_756B:    
	dc.b	7A      
	dc.b	7B      
	dc.b	7C      
	dc.b	7D      
	dc.b	7E      
	dc.b	00      
	dc.b	7F      
	dc.b	B6      
	dc.b	52      
	dc.b	65      
	dc.b	79      
	dc.b	00      
	dc.b	C2 C3 C4
	dc.b	C5      
	dc.b	C6 C7   
	dc.b	D6 D7   
	dc.b	D8      
	dc.b	D9      
	dc.b	DA DB EA
	dc.b	EB      
	dc.b	EC ED EE
	dc.b	EF      
	dc.b	FD      
	dc.b	FE FF   
	dc.b	50      
	dc.b	51      
	dc.b	00      
	dc.b	60      
	dc.b	61      
	dc.b	62      
	dc.b	63      
	dc.b	64      
	dc.b	00      
	dc.b	74      
	dc.b	75      
	dc.b	76      
	dc.b	77      
	dc.b	78      
	dc.b	00
	
start_next_level_759B:
759B: CD 60 76    call display_playfield_layout_7660
start_level_759e:
759E: CD 7A 76    call $767A
75A1: AF          xor  a
75A2: 32 41 86    ld   ($8641),a

mainloop_75A5:
75A5: CD A2 76    call perform_all_in_game_tasks_76A2
75A8: CD CF 73    call game_tick_73cf
75AB: 3A 3B 82    ld   a,(game_in_play_flag_823B)
75AE: B7          or   a
75AF: 28 05       jr   z,$75B6		; 0: game really playing (else demo)
75B1: 3A A2 80    ld   a,(nb_credits_80A2)
75B4: B7          or   a
75B5: C0          ret  nz
75B6: DD 21 1A 85 ld   ix,player_structure_851A
75BA: CD E8 75    call $75E8
75BD: DD 7E 09    ld   a,(ix+enemy_state_09)
75C0: FE FF       cp   $FF
75C2: CA FE 75    jp   z,player_died_75fe
75C5: FE 05       cp   $05
75C7: D2 A5 75    jp   nc,mainloop_75A5
75CA: DD 7E 06    ld   a,(ix+character_situation_06)
75CD: FE 02       cp   CS_ABOVE_ELEVATOR_02
75CF: D2 A5 75    jp   nc,mainloop_75A5
75DF: DD 7E 07    ld   a,(ix+current_floor_07)		; character current floor ix=851A
75E2: B7          or   a
75E3: 20 C0       jr   nz,mainloop_75A5
75E5: C3 4E 76    jp   ground_floor_reached_764E	; ground, now check documents

75E8: DD 7E 09    ld   a,(ix+enemy_state_09)
75EB: FE 05       cp   $05
75ED: D8          ret  c
75EE: FE 07       cp   $07
75F0: D0          ret  nc
75F1: 3A 41 86    ld   a,($8641)
75F4: B7          or   a
75F5: C0          ret  nz
75F6: 3C          inc  a
75F7: 32 41 86    ld   ($8641),a
75FA: CD 4D 36    call $364D
75FD: C9          ret			; reaches here when player is shot

player_died_75fe:
75FE: CD 4D 36    call $364D
7601: 11 94 81    ld   de,$8194
7604: 2E 39       ld   l,$39
7606: 26 00       ld   h,$00
7608: 19          add  hl,de
7609: EB          ex   de,hl
760A: EB          ex   de,hl
760B: 06 05       ld   b,$05
760D: AF          xor  a
760E: 86          add  a,(hl)
760F: 2B          dec  hl
7610: 10 FC       djnz $760E
7612: FE 78       cp   $78
7614: 00          nop
7615: 28 0F       jr   z,$7626
7617: 1E 81       ld   e,$81
7619: 16 00       ld   d,$00
761B: 21 C1 85    ld   hl,$85C1
761E: 19          add  hl,de
761F: 73          ld   (hl),e
7620: 3A 48 86    ld   a,(protection_variable_8648)
7623: EE 99       xor  $99
7625: E7          rst  $20
7626: 01 00 20    ld   bc,$2000
7629: 0B          dec  bc
762A: 78          ld   a,b
762B: B1          or   c
762C: 20 FB       jr   nz,$7629
762E: 3E C0       ld   a,$C0
7630: 32 0B D5    ld   (sound_latch_D50B),a
7633: 3A 21 85    ld   a,(player_structure_851A+current_floor_07)
7636: FE 05       cp   $05
7638: D2 3D 76    jp   nc,$763D
763B: 3E 05       ld   a,$05
763D: 32 2C 80    ld   ($802C),a
7640: 3A 50 82    ld   a,(copy_of_dip_switches_3_8250)
7643: CB 77       bit  6,a
7645: 20 04       jr   nz,$764B
7647: 21 34 82    ld   hl,nb_lives_8234
764A: 35          dec  (hl)
764B: 3E 01       ld   a,$01
764D: C9          ret

ground_floor_reached_764E:
764E: CD A3 09    call check_if_all_documents_collected_09A3
7651: F5          push af
7652: 3E C0       ld   a,$C0
7654: 32 0B D5    ld   (sound_latch_D50B),a
7657: F1          pop  af
7658: B7          or   a
7659: C8          ret  z
765A: CD 3F 36    call start_music_if_in_game_363f
765D: C3 9E 75    jp   start_level_759e

display_playfield_layout_7660:
7660: CD E1 71    call check_if_must_flip_screen_71e1
7663: AF          xor  a
7664: 32 D9 81    ld   (menu_or_game_tiles_81D9),a
7667: CD 0C 26    call init_hw_scroll_and_charset_260C
766A: CD 2E 58    call display_bottom_bricks_582e
766D: CD B3 28    call $28B3
7670: CD 68 2A    call $2A68
7673: CD 93 57    call compute_end_level_points_5793
7676: CD 72 2F    call set_player_initial_state_2f72
7679: C9          ret

767A: AF          xor  a
767B: 32 AB 80    ld   ($80AB),a
767E: CD DC 0B    call $0BDC
7681: CD 3A 2F    call $2F3A
7684: CD 95 4B    call $4B95
7687: CD AD 31    call $31AD
768A: CD 87 12    call init_moving_door_slots_1287
768D: CD 93 57    call compute_end_level_points_5793
7690: CD CA 30    call $30CA
7693: 3A 33 82    ld   a,($8233)
7696: 32 A9 80    ld   (timer_8bit_reload_value_80A9),a
7699: 3E 05       ld   a,GS_IN_GAME_05
769B: 32 AC 80    ld   (game_state_80AC),a
769E: CD C2 26    call reload_8bit_tiimer_26C2
76A1: C9          ret

perform_all_in_game_tasks_76A2:
76A2: CD CF 30    call handle_player_controls_30CF
76A5: CD 7F 01    call handle_main_scrolling_017F
76A8: CD BF 0E    call handle_elevators_0EBF
76AB: CD A2 12    call handle_enemies_12A2
76AE: CD BA 31    call shot_lamp_collision_31BA
76B1: CD 68 0B    call handle_enemes_0B68		; if skipped, enemy lies down and stays there, then no enemies appear
76B4: CD E8 2F    call $2FE8
76B7: CD 27 31    call $3127
76BA: CD 81 30    call update_enemies_3081
76BD: CD BA 4B    call update_bullets_4bba
76C0: CD E1 0B    call $0BE1
76C3: CD A0 15    call update_sprite_shadow_ram_15a0
76C6: C9          ret

76C7: CD 2F 57    call $572F
76CA: 3E C0       ld   a,$C0
76CC: 32 0B D5    ld   (sound_latch_D50B),a
76CF: AF          xor  a
76D0: 32 45 86    ld   ($8645),a
76D3: 18 0C       jr   $76E1
76D5: 3A 35 82    ld   a,($8235)
76D8: 3D          dec  a
76D9: C8          ret  z
76DA: 3E 01       ld   a,$01
76DC: 32 45 86    ld   ($8645),a
76DF: 18 00       jr   $76E1

76E1: CD F6 76    call $76F6
76E4: CD C2 26    call reload_8bit_tiimer_26C2
76E7: CD CF 73    call game_tick_73cf
76EA: 2A 43 86    ld   hl,($8643)
76ED: 2B          dec  hl
76EE: 22 43 86    ld   ($8643),hl
76F1: 7C          ld   a,h
76F2: B5          or   l
76F3: 20 F2       jr   nz,$76E7
76F5: C9          ret

76F6: AF          xor  a
76F7: 32 AB 80    ld   ($80AB),a
76FA: CD E1 71    call check_if_must_flip_screen_71e1
76FD: 3E 01       ld   a,$01
76FF: 32 D9 81    ld   (menu_or_game_tiles_81D9),a
7702: CD 0C 26    call init_hw_scroll_and_charset_260C
7705: 3E 08       ld   a,GS_GAME_OVER_08
7707: 32 AC 80    ld   (game_state_80AC),a
770A: 3E 02       ld   a,$02
770C: 32 A9 80    ld   (timer_8bit_reload_value_80A9),a
770F: CD 39 58    call display_status_bars_5839
7712: CD C6 57    call update_upper_status_bar_57C6
7715: CD B0 10    call display_credit_info_10b0
7718: 3A 45 86    ld   a,($8645)
771B: B7          or   a
771C: 20 04       jr   nz,$7722
771E: CD 2C 77    call $772C
7721: C9          ret

7722: CD 83 77    call $7783
7725: 21 3C 00    ld   hl,$003C
7728: 22 43 86    ld   ($8643),hl
772B: C9          ret

772C: 3A 46 86    ld   a,($8646)
772F: B7          or   a
7730: 20 06       jr   nz,$7738
7732: 3A 35 82    ld   a,($8235)
7735: 3D          dec  a
7736: 20 15       jr   nz,$774D
7738: 21 65 77    ld   hl,string_7765
773B: 11 AB C5    ld   de,$C5AB
773E: CD F9 29    call copy_string_to_screen_29F9
7741: 3E CA       ld   a,$CA
7743: 32 0B D5    ld   (sound_latch_D50B),a
7746: 21 78 00    ld   hl,$0078
7749: 22 43 86    ld   ($8643),hl
774C: C9          ret
774D: 21 6F 77    ld   hl,string_776F
7750: 11 27 C6    ld   de,$C627
7753: CD F9 29    call copy_string_to_screen_29F9
7756: 3A 36 82    ld   a,($8236)
7759: C6 11       add  a,$11
775B: 32 2E C6    ld   ($C62E),a
775E: 21 3C 00    ld   hl,$003C
7761: 22 43 86    ld   ($8643),hl
7764: C9          ret

string_7765:
	dc.b	28 1C       
	dc.b	20 1E       
	dc.b	00          
	dc.b	2F          
	dc.b	23          
	dc.b	1E 1F       
	dc.b	FF 
     
string_776F:	 
	dc.b	1A          
	dc.b	1B          
	dc.b	1C          
	dc.b	1D          
	dc.b	1E 1F       
	dc.b	04          
	dc.b	00          
	dc.b	05          
	dc.b	00          
	dc.b	28 1C       
	dc.b	20 1E       
	dc.b	00          
	dc.b	2F          
	dc.b	23          
	dc.b	1E 1F       
	dc.b	FF 
         
7783: 21 95 77    ld   hl,player_500_message_7795
7786: 11 CC C5    ld   de,$C5CC
7789: CD F9 29    call copy_string_to_screen_29F9
778C: 3A 36 82    ld   a,($8236)
778F: C6 11       add  a,$11
7791: 32 D3 C5    ld   ($C5D3),a
7794: C9          ret

player_500_message_7795:
	dc.b	1A   
	dc.b	1B   
	dc.b	1C   
	dc.b	1D   
	dc.b	1E 1F
	dc.b	04   
	dc.b	00   
	dc.b	05   
	dc.b	FF   


; this sets important variables. Can't be skipped properly
; else game sets itself in a strange mode (title screen but
; nothing happening on screen)
hardware_test_779F:
779F: 3A 00 88    ld   a,(mcu_read_8800)
77A2: 3A F4 7F    ld   a,($7FF4)
77A5: 21 47 86    ld   hl,$8647
77A8: 36 00       ld   (hl),$00
77AA: E5          push hl
77AB: CD CF 77    call mcu_comm_routine_77CF
77AE: CD BD 77    call mcu_comm_routine_77BD
77B1: E1          pop  hl
77B2: FE 17       cp   $17			; must be 0x17 else fails check
77B4: 3E 58       ld   a,$58
77B6: 77          ld   (hl),a
; bootleg: original code
77B7: CB C7       set  0,a
77B9: 32 48 86    ld   (protection_variable_8648),a
; bootleg: replacement code: seems to do the same
77B7: 21 48 86    ld   hl,protection_variable_8648    ; useless patch
77BA: 36 59       ld   (hl),$59
; bootleg: end replacement code
77BC: C9          ret

; communicates with MC68705 MCU for protection
mcu_comm_routine_77BD:
77BD: 3A 47 86    ld   a,($8647)
77C0: 21 01 88    ld   hl,mcu_status_8801
77C3: CB 4E       bit  1,(hl)
77C5: 28 FC       jr   z,$77C3
77C7: 2B          dec  hl
77C8: 6E          ld   l,(hl)
77C9: 85          add  a,l
77CA: F5          push af
77CB: 7D          ld   a,l
77CC: D7          rst  $10
77CD: F1          pop  af
77CE: C9          ret

mcu_comm_routine_77CF:
77CF: 21 47 86    ld   hl,$8647
77D2: 96          sub  (hl)
77D3: 21 01 88    ld   hl,mcu_status_8801
77D6: CB 46       bit  0,(hl)
77D8: 28 FC       jr   z,$77D6
77DA: 2B          dec  hl
77DB: 77          ld   (hl),a
77DC: C9          ret

77DD: E6 7F       and  $7F
77DF: F6 40       or   $40
77E1: E7          rst  $20
77E2: C9          ret

palette_data_77E3:
	dc.b	01 FF 00 19 00 00 01 6D 00 A7 00 53 00 0A 00 3F
	dc.b	01 FF 00 92 01 92 00 49 01 B1 00 3F 00 00 01 6D
	dc.b	00 98 01 A4 01 B6 00 92 00 11 00 92 00 49 01 F8
	dc.b	01 FF 01 E2 01 FF 01 FF 01 FF 00 3F 01 24 01 FF
	dc.b	01 FF 00 3F 00 A7 00 53 00 0A 00 00 00 0B 01 FF
	dc.b	01 FF 01 FA 01 E2 01 FF 01 FF 01 24 01 FF 01 FA
	dc.b	01 FF 00 3F 00 A7 00 53 00 0A 00 00 00 0B 01 6D
	dc.b	01 FF 01 F8 00 92 00 49 01 92 00 00 01 6D 01 FA

	dc.b	01 FF 00 19 00 00 01 6D 00 A7 00 53 00 0A 00 03
	dc.b	01 FF 00 92 00 59 00 49 01 B1 00 3F 00 00 01 6D
	dc.b	00 98 00 08 01 B6 00 92 00 80 00 92 00 49 01 F8
	dc.b	01 FF 01 E2 01 FF 01 FF 01 FF 00 3F 01 24 01 FF
	dc.b	01 FF 00 3F 00 A7 00 53 00 0A 00 00 00 0B 01 FF
	dc.b	01 FF 01 FA 01 E2 01 FF 01 FF 01 24 01 FF 01 FA
	dc.b	01 FF 00 3F 00 A7 00 53 00 0A 00 00 00 0B 01 6D
	dc.b	01 FF 01 F8 00 92 00 49 00 59 00 00 01 6D 01 FA

	dc.b	01 FF 00 19 00 00 01 6D 00 A7 00 53 00 0A 00 3F
	dc.b	01 FF 00 92 00 40 00 49 01 B1 00 3F 00 00 01 6D
	dc.b	00 98 01 D1 01 B6 00 92 00 1A 00 92 00 49 01 F8
	dc.b	01 FF 01 E2 01 FF 01 FF 01 FF 00 3F 01 24 01 FF
	dc.b	01 FF 00 3F 00 A7 00 53 00 0A 00 00 00 0B 01 FF
	dc.b	01 FF 01 FA 01 E2 01 FF 01 FF 01 24 01 FF 01 FA
	dc.b	01 FF 00 3F 00 A7 00 53 00 0A 00 00 00 0B 01 6D
	dc.b	01 FF 01 F8 00 92 00 49 00 40 00 00 01 6D 01 FA

	dc.b	01 FF 00 19 00 00 01 6D 00 A7 00 53 00 0A 00 87
	dc.b	01 FF 00 92 00 DB 00 49 01 B1 00 3F 00 00 01 6D
	dc.b	00 98 01 FF 01 B6 00 92 01 89 00 92 00 49 01 F8
	dc.b	01 FF 01 E2 01 FF 01 FF 01 FF 00 3F 01 24 01 FF
	dc.b	01 FF 00 3F 00 A7 00 53 00 0A 00 00 00 0B 01 FF
	dc.b	01 FF 01 FA 01 E2 01 FF 01 FF 01 24 01 FF 01 FA
	dc.b	01 FF 00 3F 00 A7 00 53 00 0A 00 00 00 0B 01 6D
	dc.b	01 FF 01 F8 00 92 00 49 00 DB 00 00 01 6D 01 FA

table_7FF8:
	dc.b	73 1E BD 19 3E E4 D1 C9

table_79E3:
	dc.b	01 20 01 FF 00 00 01 6D 00 A7 00 53 00 0A 00 3F
	dc.b	01 FF 01 C7 00 3F 00 07 00 0A 00 9C 01 D8 00 00
	dc.b	01 FF 01 C7 01 FF 00 07 01 FF 01 FF 01 FF 01 FF
	dc.b	01 FF 01 FF 01 FF 01 FF 01 FF 01 FF 01 FF 01 FF
	dc.b	01 FF 01 FF 01 FF 01 FF 01 FF 01 FF 01 FF 01 FF
	dc.b	01 FF 01 FF 01 FF 01 FF 01 FF 01 FF 01 FF 01 FF
	dc.b	01 FF 01 FF 01 FF 01 FF 01 FF 01 FF 01 FF 01 FF
	dc.b	01 FF 01 FF 01 FF 01 FF 01 FF 01 FF 01 FF 01 FF
 
recorded_inputs_7A63:
	dc.b	05 AF FF FF FF FF FF FF FF FD FD FD FD FD FD FD 
	dc.b	FD FF FF FF FE FF FF FF FF FF FF FF FF FB FB FB 
	dc.b	FB FB FB FB FB FB FB FB FB FF FF FF FF FF FF FF 
	dc.b	FF FF FF FF FF F7 F7 F7 FF FF FB FB FB FB FB FF 
	dc.b	FF F7 F7 F7 FF FF FF EF EF EF FB FB FB FF FF FF 
	dc.b	FF FF FF FF FF FF FF FF FF F7 F7 F7 F7 F7 F7 FF 
	dc.b	FF FF FF FF FF FD FD FF FF FF FF FF EF EB EB FB 
	dc.b	FB FB FB FB FF FF FF FF FF FF FF FF FD F5 F5 F5 
	dc.b	F5 F5 F5 F5 F5 FF FF FF FF FF FF FE FE FE FE FE 
	dc.b	DE DE DE FE FE FE FE FE FE FE FE FE FE FE FE FE 
	dc.b	FE FE FE FE FE FE FE FE FE FE FE FF FD FD FF FF 
	dc.b	FF FF FF FF FF FB FB FB FB FB EB EB FB FB FB FB 
	dc.b	FB FB FB FB FB FB FB FB FB FB FB FB FB FB FF FF 
	dc.b	F7 F7 F7 F5 F5 F5 F5 F5 F5 F5 F5 F5 F5 D5 D5 D5 
	dc.b	F5 F5 F5 F5 F5 F5 F5 F5 F5 F5 F5 F5 F5 F5 F5 F5 
	dc.b	F5 F5 F5 F5 F5 F5 F5 F5 F5 F5 F5 F5 F5 F5 F5 F5 
	dc.b	F5 FD FF FE FE FE FE FE FE FE FE FE FF FF FD FD 
	dc.b	FD FD FD FD FE FE FE FE FE DE DE DE DE FE FE FE 
	dc.b	FE FE FE FE FE FE FE FE FE FE FE FE FE FE FE FE 
	dc.b	FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 
	dc.b	FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 
	dc.b	FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF 
	dc.b	FF FF FF FF FF FB FB FB FB FB FB FB FB FB FB FB 
recorded_inouts_7BD3:
	dc.b	02 94 FF FF FF FF FF FF FF FF FF FE FE FE FE FE  
	dc.b	FE FE FE FE FE FE FE FE FE FE FE FE FE FE FE FE  
	dc.b	FE FE FE FE FE FE FE FE FE FE FE FE FE FE FE FE  
	dc.b	FE FE FA FA FA FA FA FA FA FA FA FA FA FA FA FA  
	dc.b	FA FA FA FA FA FA FA FA FA FA FA FA FE FF FF FF  
	dc.b	FF FF FF FF FF FD FD FD FD FD FD FD FD FD FD FD  
	dc.b	FD FD FD FD FD FD FD FD FD FD FD FD FD FD FD FD  
	dc.b	FD FD FD FD FD FD FD FD FE FF FF FF FB EB EB FB  
	dc.b	EB EB FB FB FB FB FB FB FB FB FB FF FF FF FF FF  
	dc.b	FF FF FF FF EB EB FB FB EB FB FB FB FF FF FF FF  
	dc.b	FF FF FF F7 F7 F7 F7 F7 F7 FF FF FF FF FF FF FD  
	dc.b	FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF  
	dc.b	FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FB  
	dc.b	FB FB FB FB FB FF FF FF FF FF FF FF FF F7 F7 F7  
	dc.b	F7 F7 F7 F7 FF FF FF FF FF FB FB FB FB FB FB FB  
	dc.b	FB FB FF FF FF FF FF FF FF F7 F7 FF FF FF FF FF  
	dc.b	FF FF FF FF FF FF FF FF FB FB FB FB FB FB FB FF  
	dc.b	FB FB FB FB FB FB FB FF FF FF FF FF FD FD FD FD  
	dc.b	FD FD FD FD FD FD FD FD FD FD FD FD FD FD FD FD  
	dc.b	FD FD FD FD FD FD FD FD FD FD FD FD FD FD FD FD  
	dc.b	FD FD FD FD FD FE FF FF FF FF FF FF FF FF FF FF  
	dc.b	FD FD FD FD FD FD FD FD FD FD FD FD FD FD FD FD  
	dc.b	FE FE FE FE FE FE FE FE FE FE FE FE FF FB FB FB  
	dc.b	FB EB EB EB FB EB EB FB EB EB FB FB FB FB FB FB  
	dc.b	FB FB FB FF F7 F7 F7 FF FF FF FE FE FE FE FE FF  
	dc.b	FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF  
	dc.b	FF FF FF FF FE FE FE FE FE FE FE FE FE FE FE FE  
	dc.b	FE FE FE FE FE FE FE FE FE FE FE FE FE FE FE FE  
	dc.b	FE FE FE FE FE FE FE FE FE FE FE FE FE FF FF FF  
	dc.b	FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF  
	dc.b	FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF  
	dc.b	FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF FF  
recorded_inputs_7DD3:
	dc.b	69 F9 BF BF BF BF BF BF BF BF BF BF BD BD BD BD
	dc.b	BD BF BB BB BB BB BB BB BB BB BB BF BF BF BF BF
	dc.b	BF BF BF BE BE BE BE BE BF BB B9 B9 B9 B9 B9 A9
	dc.b	A9 B9 A9 B9 B9 B9 BD BF BF BF BF BF BF B7 B7 B7
	dc.b	BF BF BF BF BF BF BF BF BF BF BF BF BF BF BF BF
	dc.b	BF BF BF BF BF BF BE BE BE BE BE BF BF BF BB BB
	dc.b	BB BB BB BB BB BB BB BB BB BB BA BE BE BE BE BE
	dc.b	BE BE BE BE BE BE BE BE BE BE BE BE BD BD BF BF
	dc.b	BF AB AB BB BB BB BF BF 9F 9F BF BF BF BF BF BF
	dc.b	BF BE BE BE BE BE BE BE BE BE BE BE BE BE BE BE
	dc.b	BE BE BE BE BE BE BE BE BE BE BE BE BE BD BF BF
	dc.b	BF BF BF BF BF BF BF BF BF BE BE BE BE BE BE BE
	dc.b	BF BF BF BD BD BD BD BD BD BD BD BD BD BD BF AB
	dc.b	BB BB AB BB BB BB BB BB BB BB BB BB BF BF B7 B7
	dc.b	B5 B5 B5 B5 B5 B5 B5 BF BF BB BB BB BB BB BB BB
	dc.b	BB BB BB BB BB BB BB BB BB BB BB BB BB BB BB BB
	dc.b	BB BB BB BB BB BB BB BB BB BB BB BB BB BF BF BF
	dc.b	BD BD BD BD BD BD BD BD BD 9D 9D BD BD BD BD BD
	dc.b	BD BD BD BD BF BF BF BF 9F 9F 9F BF BF BF BE BE
	dc.b	BE BE BE BE BF BF BF BD BD 9D BD BD BD BD BD BD
	dc.b	BD BD BD BD BD BD BD BD BD BD BD BD BD BD BD BD
	dc.b	9D 9D BD BD BD BF BF BE BE BE BE BE BE BE BE BE
	dc.b	BE BE BE BE BE BE BE BE BE BF BF BF BF BF BF BF
	dc.b	BF BF BF BF BF BF BF BF BF BF BF BF BF BF BF BF
	dc.b	BF BF BF BF BF BF BF BF BF BF BF BF BF BF BF BF
	dc.b	BF BF BF BF BF BF BF BF BF BF BF BF BF BF BF BF
	dc.b	BF BF BF BF BF BF BF BF BF BF BF BF BF BF BF BF
 
; the following code is installed in RAM by the protection process
; I don't know if it's decrypted or whatever, it's copied and called from
; within the game. If it's not decrypted properly, of course the game is
; going to freeze/crash. For instance dynamic_ram_code_85EF
; is called during demo, when lamps are shot, and regularly from then

dynamic_ram_code_805B:
dynamic_ram_code_805b:
805B: 36 00    ld   (hl),$00
805D: 7A       ld   a,d
805E: B7       or   a
805F: F8       ret  m
8060: FE 0C    cp   $0C
8062: D0       ret  nc
8063: FE 08    cp   $08
8065: 38 0A    jr   c,dynamic_ram_code_8071
8067: D6 08    sub  $08
8069: 87       add  a,a
806A: 87       add  a,a
806B: 5F       ld   e,a
806C: 3E FA    ld   a,$FA
806E: 93       sub  e
806F: 77       ld   (hl),a
8070: C9       ret

dynamic_ram_code_8071:
8071: 87       add  a,a
8072: C6 EC    add  a,$EC
8074: 77       ld   (hl),a
8075: C9       ret

dynamic_ram_code_85CF:
dynamic_ram_code_85cf:
85CF: DD 7E 09 ld   a,(ix+enemy_state_09)
85D2: 06 00    ld   b,$00
85D4: FE 04    cp   $04
85D6: 28 02    jr   z,$85DA
85D8: 06 04    ld   b,$04
85DA: 78       ld   a,b
85DB: B2       or   d
85DC: DD 77 0D ld   (ix+move_direction_0d),a
85DF: C9       ret

dynamic_ram_code_85EF:
dynamic_ram_code_85ef:
85EF: DD 7E 09 ld   a,(ix+enemy_state_09)
85F2: 06 00    ld   b,$00
85F4: FE 02    cp   $02
85F6: 28 06    jr   z,$85FE
85F8: 06 04    ld   b,$04
85FA: 38 02    jr   c,$85FE
85FC: 06 08    ld   b,$08
85FE: 78       ld   a,b
85FF: B2       or   d
8600: DD 77 0D ld   (ix+move_direction_0d),a
8603: C9       ret

; here's the code found in alternate bank (bank switch = 81)

7021: 80       add  a,b
7022: 80       add  a,b
7023: 4E       ld   c,(hl)
7024: 09       add  hl,bc
7025: E5       push hl
7026: 21 FF 71 ld   hl,$71FF
7029: 09       add  hl,bc
702A: 7E       ld   a,(hl)
702B: F5       push af
702C: C3 F4 34 jp   $34F4

73DE: 21 C6 85 ld   hl,$85C6
73E1: 4E       ld   c,(hl)
73E2: 09       add  hl,bc
73E3: E5       push hl
73E4: 21 FF 70 ld   hl,$70FF
73E7: 09       add  hl,bc
73E8: 7E       ld   a,(hl)
73E9: F5       push af
73EA: 3E 01    ld   a,$01
73EC: 32 0E D5 ld   ($D50E),a

7100: B2       or   d
7101: DD 77 0D ld   (ix+$0d),a
7104: C9       ret
7105: A0       and  b
7106: 05       dec  b
7107: 5E       ld   e,(hl)

; part then copied to 85CF and maybe to 85EF
; with a few manual changes
7108: DD 7E 09 ld   a,(ix+$09)
710B: 06 00    ld   b,$00
710D: FE 04    cp   $04
710F: 28 02    jr   z,$7113
7111: 06 04    ld   b,$04
7113: 78       ld   a,b
7114: B2       or   d
7115: DD 77 0D ld   (ix+$0d),a
7118: C9       ret

7119: 1E 12    ld   e,$12
711B: 08       ex   af,af'
711C: 1D       dec  e
711D: 02       ld   (bc),a
711E: 08       ex   af,af'
711F: 5E       ld   e,(hl)
7120: EC 77 C9 call pe,$C977
7123: 5E       ld   e,(hl)
7124: 92       sub  d
7125: 08       ex   af,af'
7126: 1E C9    ld   e,$C9
7128: DD 7E 09 ld   a,(ix+$09)
712B: 06 00    ld   b,$00
712D: FE 02    cp   $02
712F: 28 06    jr   z,$7137
7131: 06 04    ld   b,$04
7133: 38 02    jr   c,$7137
7135: 06 08    ld   b,$08
7137: 78       ld   a,b
7138: B2       or   d
7139: DD 77 0D ld   (ix+$0d),a
713C: C9       ret
713D: A0       and  b
713E: 05       dec  b
713F: 5E       ld   e,(hl)
