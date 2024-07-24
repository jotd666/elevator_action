
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
;	map(0xd000, 0xd05f).ram().share(m_colscrolly);
;	map(0xd100, 0xd1ff).ram().share(m_spriteram);
;	map(0xd200, 0xd27f).mirror(0x0080).ram().share(m_paletteram);
;	map(0xd300, 0xd300).mirror(0x00ff).writeonly().share(m_video_priority);
;	map(0xd400, 0xd403).mirror(0x00f0).readonly().share(m_collision_reg);
;	map(0xd404, 0xd404).mirror(0x00f3).r(FUNC(taitosj_state::gfxrom_r));
;	map(0xd408, 0xd408).mirror(0x00f0).portr("IN0");
;	map(0xd409, 0xd409).mirror(0x00f0).portr("IN1");
;	map(0xd40a, 0xd40a).mirror(0x00f0).portr("DSW1");
;	map(0xd40b, 0xd40b).mirror(0x00f0).portr("IN2");
;	map(0xd40c, 0xd40c).mirror(0x00f0).portr("IN3");          // Service
;	map(0xd40d, 0xd40d).mirror(0x00f0).portr("IN4");
;	map(0xd40e, 0xd40f).mirror(0x00f0).w(m_ay[0], FUNC(ay8910_device::address_data_w));
;	map(0xd40f, 0xd40f).mirror(0x00f0).r(m_ay[0], FUNC(ay8910_device::data_r));   // DSW2 and DSW3
;	map(0xd500, 0xd505).mirror(0x00f0).writeonly().share(m_scroll);
;	map(0xd506, 0xd507).mirror(0x00f0).writeonly().share(m_colorbank);
;	map(0xd508, 0xd508).mirror(0x00f0).w(FUNC(taitosj_state::collision_reg_clear_w));
;	map(0xd509, 0xd50a).mirror(0x00f0).writeonly().share(m_gfxpointer);
;	map(0xd50b, 0xd50b).mirror(0x00f0).w(FUNC(taitosj_state::soundlatch_w));
;	map(0xd50c, 0xd50c).mirror(0x00f0).w(FUNC(taitosj_state::sound_semaphore2_w));
;	map(0xd50d, 0xd50d).mirror(0x00f0).w("watchdog", FUNC(watchdog_timer_device::reset_w));
;	map(0xd50e, 0xd50e).mirror(0x00f0).w(FUNC(taitosj_state::bankswitch_w));
;	map(0xd50f, 0xd50f).mirror(0x00f0).nopw();
;	map(0xd600, 0xd600).mirror(0x00ff).writeonly().share(m_video_mode);

character_state_04 = 0x4
character_delta_x_05 = 0x5
move_direction_0d = 0xd

state_unknown_00 = 0
state_title_01 = 1
state_push_start_03 = 3
state_game_starting_04 = 4
state_ingame_05 = 5
state_ground_floor_reached_06 = 6
state_next_life_07 = 7
state_game_over_08 = 8
state_insert_coin_09 = 9

0000: C3 8F 33    jp   bootup_338f

0003: 21 49 86    ld   hl,$8649
0006: 7E          ld   a,(hl)
0007: C8          ret  z

0008: 2F          cpl
0009: 32 49 86    ld   ($8649),a
000C: 3E 9C       ld   a,$9C
000E: E7          rst  $20
000F: C9          ret

0010: 07          rlca
0011: 21 47 86    ld   hl,$8647
0014: 7E          ld   a,(hl)
0015: 38 04       jr   c,$001B
0017: C6 F3       add  a,$F3
0019: CB 2F       sra  a
001B: C6 17       add  a,$17
001D: 77          ld   (hl),a
001E: C9          ret



0020: E5          push hl
0021: CD CF 77    call $77CF
0024: D7          rst  $10
0025: E1          pop  hl
0026: C9          ret


0028: E6 1F       and  $1F
002A: E7          rst  $20
002B: 21 48 86    ld   hl,$8648
002E: B6          or   (hl)
002F: 77          ld   (hl),a
0030: CD BD 77    call $77BD
0033: C9          ret

elevator_irq_0038:
0038: C3 99 11    jp   elevator_irq_1199

003B: DD 7E 09    ld   a,(ix+$09)
003E: 3C          inc  a
003F: C8          ret  z
0040: DD 7E 06    ld   a,(ix+$06)
0043: FE 03       cp   $03
0045: D0          ret  nc
0046: DD 7E 10    ld   a,(ix+$10)
0049: B7          or   a
004A: C8          ret  z
004B: DD 7E 12    ld   a,(ix+$12)
004E: E6 07       and  $07
0050: 5F          ld   e,a
0051: FE 04       cp   $04
0053: 38 10       jr   c,$0065
0055: DD 7E 13    ld   a,(ix+$13)
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
006B: 21 70 00    ld   hl,$0070
006E: 19          add  hl,de
006F: E9          jp   (hl)

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
00BB: C3 EF 85    jp   $85EF
00BE: 16 00       ld   d,$00
00C0: DD 72 11    ld   (ix+$11),d
00C3: CD 74 01    call $0174
00C6: 3A 00 80    ld   a,($8000)
00C9: DD BE 10    cp   (ix+$10)
00CC: 28 02       jr   z,$00D0
00CE: 16 20       ld   d,$20
00D0: C3 EF 85    jp   $85EF
00D3: 16 00       ld   d,$00
00D5: DD 72 11    ld   (ix+$11),d
00D8: C3 CF 85    jp   $85CF
00DB: 16 00       ld   d,$00
00DD: DD 72 11    ld   (ix+$11),d
00E0: CD 74 01    call $0174
00E3: 3A 00 80    ld   a,($8000)
00E6: DD BE 10    cp   (ix+$10)
00E9: 28 02       jr   z,$00ED
00EB: 16 20       ld   d,$20
00ED: C3 CF 85    jp   $85CF
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
0174: CD F5 1D    call $1DF5
0177: FE 0C       cp   $0C
0179: D0          ret  nc
017A: DD 36 11 FF ld   (ix+$11),$FF
017E: C9          ret

handle_main_scrolling_017F:
017F: CD 86 01    call $0186
0182: CD 06 02    call $0206
0185: C9          ret

0186: AF          xor  a
0187: 32 04 80    ld   ($8004),a
018A: CD BA 01    call $01BA
018D: D8          ret  c
018E: 7D          ld   a,l
018F: D6 6E       sub  $6E
0191: C8          ret  z
0192: 38 0C       jr   c,$01A0
0194: 3A 03 80    ld   a,($8003)
0197: FE 1D       cp   $1D
0199: C8          ret  z
019A: 3E 02       ld   a,$02
019C: 32 04 80    ld   ($8004),a
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
01B6: 32 04 80    ld   ($8004),a
01B9: C9          ret
01BA: DD 21 1A 85 ld   ix,player_structure_851A
01BE: DD 7E 06    ld   a,(ix+$06)
01C1: B7          or   a
01C2: 28 16       jr   z,$01DA
01C4: 3D          dec  a
01C5: 28 1D       jr   z,$01E4
01C7: 3D          dec  a
01C8: 28 23       jr   z,$01ED
01CA: FE 03       cp   $03
01CC: CA DA 01    jp   z,$01DA
01CF: DD 46 07    ld   b,(ix+$07)
01D2: 0E 00       ld   c,$00
01D4: DD 56 03    ld   d,(ix+character_y_offset_03)
01D7: C3 6C 1E    jp   $1E6C
01DA: DD 46 07    ld   b,(ix+$07)
01DD: 0E 00       ld   c,$00
01DF: 16 06       ld   d,$06
01E1: C3 6C 1E    jp   $1E6C
01E4: CD CE 62    call $62CE
01E7: FD 46 01    ld   b,(iy+$01)
01EA: C3 F4 01    jp   $01F4
01ED: CD CE 62    call $62CE
01F0: FD 46 01    ld   b,(iy+$01)
01F3: 04          inc  b
01F4: 0E 00       ld   c,$00
01F6: FD 7E 00    ld   a,(iy+$00)
01F9: 57          ld   d,a
01FA: DD 7E 08    ld   a,(ix+$08)
01FD: 17          rla
01FE: D2 6C 1E    jp   nc,$1E6C
0201: 05          dec  b
0202: 05          dec  b
0203: C3 6C 1E    jp   $1E6C
0206: AF          xor  a
0207: 32 07 80    ld   ($8007),a
020A: 3A 04 80    ld   a,($8004)
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
0223: 3A 05 80    ld   a,($8005)
0226: 91          sub  c
0227: 32 05 80    ld   ($8005),a
022A: 79          ld   a,c
022B: B7          or   a
022C: C8          ret  z
022D: F2 7D 02    jp   p,$027D
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
024F: 26 00       ld   h,$00
0251: 29          add  hl,hl
0252: 29          add  hl,hl
0253: 29          add  hl,hl
0254: 29          add  hl,hl
0255: 29          add  hl,hl
0256: EB          ex   de,hl
0257: 21 80 5F    ld   hl,$5F80
025A: 19          add  hl,de
025B: D5          push de
025C: 22 09 D5    ld   ($D509),hl
025F: 11 08 80    ld   de,$8008
0262: 21 04 D4    ld   hl,$D404
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
0273: 22 06 80    ld   ($8006),hl
0276: CD 9C 02    call $029C
0279: CD 87 03    call $0387
027C: C9          ret
027D: 21 01 80    ld   hl,$8001
0280: 7E          ld   a,(hl)
0281: 81          add  a,c
0282: 77          ld   (hl),a
0283: D6 08       sub  $08
0285: D8          ret  c
0286: 77          ld   (hl),a
0287: 23          inc  hl
0288: 34          inc  (hl)
0289: 7E          ld   a,(hl)
028A: D6 06       sub  $06
028C: DA 93 02    jp   c,$0293
028F: 77          ld   (hl),a
0290: 23          inc  hl
0291: 34          inc  (hl)
0292: 2B          dec  hl
0293: 4E          ld   c,(hl)
0294: 23          inc  hl
0295: 7E          ld   a,(hl)
0296: C6 05       add  a,$05
0298: 47          ld   b,a
0299: C3 47 02    jp   $0247
029C: 3A 07 80    ld   a,($8007)
029F: B7          or   a
02A0: C8          ret  z
02A1: 2A 02 80    ld   hl,($8002)
02A4: 3A 04 80    ld   a,($8004)
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
02C2: CD CA 02    call $02CA
02C5: C9          ret
02C6: CD 5F 03    call $035F
02C9: C9          ret
02CA: 21 10 82    ld   hl,red_door_position_array_8210
02CD: 19          add  hl,de
02CE: 7E          ld   a,(hl)
02CF: FE 08       cp   $08
02D1: D0          ret  nc
02D2: 21 08 80    ld   hl,$8008
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
0387: 3A 04 80    ld   a,($8004)
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
03C3: 3A 04 80    ld   a,($8004)
03C6: B7          or   a
03C7: C8          ret  z
03C8: 3A 05 80    ld   a,($8005)
03CB: 21 20 D0    ld   hl,$D020
03CE: 06 20       ld   b,$20
03D0: 77          ld   (hl),a
03D1: 23          inc  hl
03D2: 10 FC       djnz $03D0
03D4: 2A 06 80    ld   hl,($8006)
03D7: 7C          ld   a,h
03D8: B7          or   a
03D9: C8          ret  z
03DA: EB          ex   de,hl
03DB: 21 08 80    ld   hl,$8008
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
0422: 3A 21 85    ld   a,($8521)
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
0438: 06 04       ld   b,$04
043A: DD 21 3A 85 ld   ix,enemy_1_853A
043E: DD 7E 09    ld   a,(ix+$09)
0441: FE 05       cp   $05
0443: 30 23       jr   nc,$0468
0445: DD 7E 0F    ld   a,(ix+$0f)
0448: B7          or   a
0449: 20 1D       jr   nz,$0468
044B: DD 7E 1C    ld   a,(ix+$1c)
044E: FE 0C       cp   $0C
0450: 28 16       jr   z,$0468
0452: DD 7E 06    ld   a,(ix+$06)
0455: B7          or   a
0456: 20 10       jr   nz,$0468
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
04FD: CD F5 1D    call $1DF5
0500: FE 40       cp   $40
0502: 38 03       jr   c,$0507
0504: 79          ld   a,c
0505: 87          add  a,a
0506: 4F          ld   c,a
0507: CD 3E 1E    call $1E3E
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
0521: CD 3E 1E    call $1E3E
0524: 81          add  a,c
0525: DD 77 10    ld   (ix+$10),a
0528: C9          ret
0529: 21 48 05    ld   hl,$0548
052C: DD 7E 0E    ld   a,(ix+$0e)
052F: B7          or   a
0530: 28 03       jr   z,$0535
0532: 21 58 05    ld   hl,$0558
0535: DD 5E 13    ld   e,(ix+$13)
0538: 16 00       ld   d,$00
053A: 19          add  hl,de
053B: CD F5 1D    call $1DF5
053E: BE          cp   (hl)
053F: 06 00       ld   b,$00
0541: 30 01       jr   nc,$0544
0543: 04          inc  b
0544: DD 70 12    ld   (ix+$12),b
0547: C9          ret
0548: 00          nop
0549: 00          nop
054A: 10 10       djnz $055C
054C: 20 20       jr   nz,$056E
054E: 30 30       jr   nc,$0580
0550: 40          ld   b,b
0551: 40          ld   b,b
0552: 50          ld   d,b
0553: 50          ld   d,b
0554: 60          ld   h,b
0555: 60          ld   h,b
0556: 70          ld   (hl),b
0557: 70          ld   (hl),b
0558: 00          nop
0559: 10 20       djnz $057B
055B: 30 40       jr   nc,$059D
055D: 50          ld   d,b
055E: 60          ld   h,b
055F: 70          ld   (hl),b
0560: 80          add  a,b
0561: 90          sub  b
0562: A0          and  b
0563: B0          or   b
0564: C0          ret  nz
0565: D0          ret  nc
0566: E0          ret  po
0567: F0          ret  p
0568: DD 7E 0E    ld   a,(ix+$0e)
056B: B7          or   a
056C: 20 10       jr   nz,$057E
056E: 3A 1A 85    ld   a,(player_structure_851A)
0571: DD 96 00    sub  (ix+character_x_00)
0574: 3F          ccf
0575: 17          rla
0576: E6 01       and  $01
0578: DD BE 0B    cp   (ix+$0b)
057B: C2 8E 05    jp   nz,$058E
057E: 3A 20 85    ld   a,($8520)
0581: FE 03       cp   $03
0583: D0          ret  nc
0584: CD E1 05    call $05E1
0587: D0          ret  nc
0588: CD 90 05    call $0590
058B: C9          ret
058C: 37          scf
058D: C9          ret
058E: AF          xor  a
058F: C9          ret
0590: 3A 21 85    ld   a,($8521)
0593: 47          ld   b,a
0594: FE 12       cp   $12
0596: 20 16       jr   nz,$05AE
0598: 3A 1A 85    ld   a,(player_structure_851A)
059B: FE 7D       cp   $7D
059D: 38 29       jr   c,$05C8
059F: DD 7E 07    ld   a,(ix+$07)
05A2: FE 12       cp   $12
05A4: C2 8E 05    jp   nz,$058E
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
05BF: 20 CD       jr   nz,$058E
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
05D9: 20 B1       jr   nz,$058C
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
05F5: CD F5 1D    call $1DF5
05F8: 21 59 06    ld   hl,$0659
05FB: DD 5E 13    ld   e,(ix+$13)
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
0612: 11 08 00    ld   de,$0008
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
0659: 00          nop
065A: 00          nop
065B: 02          ld   (bc),a
065C: 02          ld   (bc),a
065D: 04          inc  b
065E: 08          ex   af,af'
065F: 10 10       djnz $0671
0661: 20 20       jr   nz,$0683
0663: 40          ld   b,b
0664: 40          ld   b,b
0665: 60          ld   h,b
0666: 80          add  a,b
0667: C4 FF DD    call nz,$DDFF
066A: 7E          ld   a,(hl)
066B: 12          ld   (de),a
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
078A: 11 E3 16    ld   de,$16E3
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
07C6: FD 21 7D 83 ld   iy,$837D
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
08B8: CA D2 08    jp   z,$08D2
08BB: 3A 50 82    ld   a,($8250)
08BE: CB 77       bit  6,a
08C0: C0          ret  nz
08C1: FD 21 1A 85 ld   iy,player_structure_851A
08C5: CD F8 08    call animate_enemy_08F8
08C8: 3A 39 83    ld   a,($8339)
08CB: B7          or   a
08CC: C8          ret  z
08CD: AF          xor  a
08CE: 32 EB 82    ld   ($82EB),a
08D1: C9          ret

08D2: FD 21 3A 85 ld   iy,enemy_1_853A
08D6: CD F8 08    call animate_enemy_08F8
08D9: FD 21 5A 85 ld   iy,enemy_2_855A
08DD: CD F8 08    call animate_enemy_08F8
08E0: FD 21 7A 85 ld   iy,enemy_3_857A
08E4: CD F8 08    call animate_enemy_08F8
08E7: FD 21 9A 85 ld   iy,enemy_4_859A
08EB: CD F8 08    call animate_enemy_08F8
08EE: 3A 39 83    ld   a,($8339)
08F1: B7          or   a
08F2: C8          ret  z
08F3: AF          xor  a
08F4: 32 EC 82    ld   ($82EC),a
08F7: C9          ret

animate_enemy_08F8:
08F8: FD 7E 04    ld   a,(iy+character_state_04)
08FB: FE 02       cp   $02
08FD: C0          ret  nz
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
095C: 21 7D 83    ld   hl,$837D
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

09A3: AF          xor  a
09A4: 32 AB 80    ld   ($80AB),a
09A7: CD D8 0A    call $0AD8
09AA: CD 4D 36    call $364D
09AD: 3E C0       ld   a,$C0
09AF: 32 0B D5    ld   ($D50B),a
09B2: CD E5 45    call ground_floor_reached_45E5
09B5: 21 2E 82    ld   hl,$822E
09B8: 06 1E       ld   b,$1E
09BA: 7E          ld   a,(hl)
09BB: FE 08       cp   $08
09BD: 20 06       jr   nz,$09C5
09BF: 2B          dec  hl
09C0: 10 F8       djnz $09BA
09C2: C3 D3 09    jp   $09D3
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
09FA: CD A0 15    call $15A0
09FD: CD CF 73    call $73CF
0A00: 3A 33 80    ld   a,($8033)
0A03: FE FF       cp   $FF
0A05: 20 CC       jr   nz,$09D3
0A07: CD F9 56    call $56F9
0A0A: 21 37 82    ld   hl,skill_level_8237
0A0D: 34          inc  (hl)					; increase difficulty level
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
0A2F: 32 21 85    ld   ($8521),a
0A32: 3E 01       ld   a,$01
0A34: 32 A9 80    ld   ($80A9),a
0A37: CD 03 0B    call $0B03
0A3A: 21 32 85    ld   hl,$8532
0A3D: 3A 04 80    ld   a,($8004)
0A40: B7          or   a
0A41: 20 01       jr   nz,$0A44
0A43: 34          inc  (hl)
0A44: 7E          ld   a,(hl)
0A45: FE 14       cp   $14
0A47: 38 0B       jr   c,$0A54
0A49: 3E 39       ld   a,$39
0A4B: 32 0B D5    ld   ($D50B),a
0A4E: CD 72 2F    call $2F72
0A51: 3E 01       ld   a,$01
0A53: C9          ret
0A54: CD 06 02    call $0206
0A57: CD F0 0A    call $0AF0
0A5A: CD BF 0E    call handle_elevators_0EBF
0A5D: CD A2 12    call handle_enemies_12A2
0A60: CD E1 0B    call $0BE1
0A63: CD A0 15    call $15A0
0A66: CD CF 73    call $73CF
0A69: C3 15 0A    jp   $0A15
0A6C: 3A 23 85    ld   a,($8523)
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
0A84: CC D0 0A    call z,$0AD0
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
0AA5: 32 27 85    ld   (player_move_direction_8527),a
0AA8: C3 B5 0A    jp   $0AB5
0AAB: 3E 00       ld   a,$00
0AAD: 32 27 85    ld   (player_move_direction_8527),a
0AB0: 21 23 81    ld   hl,$8123
0AB3: 36 FF       ld   (hl),$FF
0AB5: CD 06 02    call $0206
0AB8: CD F0 0A    call $0AF0
0ABB: CD BF 0E    call handle_elevators_0EBF
0ABE: CD A2 12    call handle_enemies_12A2
0AC1: CD E8 2F    call $2FE8
0AC4: CD E1 0B    call $0BE1
0AC7: CD A0 15    call $15A0
0ACA: CD CF 73    call $73CF
0ACD: C3 15 0A    jp   $0A15
0AD0: F5          push af
0AD1: 3E 38       ld   a,$38
0AD3: 32 0B D5    ld   ($D50B),a
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
0AF0: 21 81 80    ld   hl,$8081
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
0B05: 32 04 80    ld   ($8004),a
0B08: 3A 2C 80    ld   a,($802C)
0B0B: 47          ld   b,a
0B0C: 0E 00       ld   c,$00
0B0E: 16 06       ld   d,$06
0B10: CD 6C 1E    call $1E6C
0B13: 11 6E 00    ld   de,$006E
0B16: AF          xor  a
0B17: ED 52       sbc  hl,de
0B19: C8          ret  z
0B1A: D8          ret  c
0B1B: 3E 02       ld   a,$02
0B1D: 32 04 80    ld   ($8004),a
0B20: C9          ret
0B21: 06 08       ld   b,$08
0B23: 3A 23 85    ld   a,($8523)
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
0B51: 32 23 85    ld   ($8523),a
0B54: 3E 01       ld   a,$01
0B56: 32 33 80    ld   ($8033),a
0B59: 3E 03       ld   a,$03
0B5B: 32 A9 80    ld   ($80A9),a
0B5E: 3D          dec  a
0B5F: 32 AA 80    ld   (timer_8bit_80AA),a
0B62: 3E 00       ld   a,$00
0B64: 32 AB 80    ld   ($80AB),a
0B67: C9          ret
0B68: CD EB 58    call $58EB
0B6B: DD 21 3A 85 ld   ix,enemy_1_853A
0B6F: 21 32 81    ld   hl,$8132
0B72: 22 BD 85    ld   ($85BD),hl
0B75: 3E 01       ld   a,$01
0B77: 32 BA 85    ld   ($85BA),a
0B7A: CD 98 0B    call $0B98
0B7D: 11 20 00    ld   de,$0020
0B80: DD 19       add  ix,de
0B82: 2A BD 85    ld   hl,($85BD)
0B85: 11 05 00    ld   de,$0005
0B88: 19          add  hl,de
0B89: 22 BD 85    ld   ($85BD),hl
0B8C: 3A BA 85    ld   a,($85BA)
0B8F: 3C          inc  a
0B90: 32 BA 85    ld   ($85BA),a
0B93: FE 05       cp   $05
0B95: 20 E3       jr   nz,$0B7A
0B97: C9          ret
0B98: DD 36 17 00 ld   (ix+$17),$00
0B9C: DD 7E 09    ld   a,(ix+$09)
0B9F: B7          or   a
0BA0: F8          ret  m
0BA1: FE 05       cp   $05
0BA3: D0          ret  nc
0BA4: DD 7E 06    ld   a,(ix+$06)
0BA7: 4F          ld   c,a
0BA8: FE 03       cp   $03
0BAA: D2 D1 0B    jp   nc,$0BD1
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
0BBA: 21 BF 0B    ld   hl,$0BBF
0BBD: 19          add  hl,de
0BBE: E9          jp   (hl)
0BBF: C3 F6 53    jp   $53F6
0BC2: C3 A7 51    jp   $51A7
0BC5: C3 4E 52    jp   $524E
0BC8: C3 14 1C    jp   $1C14
0BCB: C3 E3 1A    jp   $1AE3
0BCE: C3 38 1B    jp   $1B38
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
0C06: DA 43 0C    jp   c,$0C43
0C09: D6 04       sub  $04
0C0B: 32 36 80    ld   ($8036),a
0C0E: DA 43 0C    jp   c,$0C43
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
0C33: 32 0B D5    ld   ($D50B),a
0C36: C9          ret
0C37: 3E 00       ld   a,$00
0C39: 32 35 80    ld   ($8035),a
0C3C: 32 34 80    ld   ($8034),a
0C3F: CD CD 0C    call $0CCD
0C42: C9          ret
0C43: D5          push de
0C44: 11 F6 82    ld   de,$82F6
0C47: 1B          dec  de
0C48: 1A          ld   a,(de)
0C49: A7          and  a
0C4A: CA 50 0C    jp   z,$0C50
0C4D: C3 81 0C    jp   $0C81
0C50: D1          pop  de
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
0CD3: CD 6C 1E    call $1E6C
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
0CE4: 21 2D 0D    ld   hl,$0D2D
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
0D2D: 10 00       djnz $0D2F
0D2F: 01 6D 20    ld   bc,$206D
0D32: 00          nop
0D33: 01 6C 00    ld   bc,$006C
0D36: 00          nop
0D37: 01 00 00    ld   bc,$0000
0D3A: 00          nop
0D3B: 00          nop
0D3C: 00          nop
0D3D: 10 00       djnz $0D3F
0D3F: 01 6D 20    ld   bc,$206D
0D42: 00          nop
0D43: 01 6C 00    ld   bc,$006C
0D46: 00          nop
0D47: 01 00 14    ld   bc,$1400
0D4A: 07          rlca
0D4B: 01 4E 10    ld   bc,$104E
0D4E: 02          ld   (bc),a
0D4F: 01 6D 20    ld   bc,$206D
0D52: 02          ld   (bc),a
0D53: 01 6C 00    ld   bc,$006C
0D56: 02          ld   (bc),a
0D57: 01 6B 14    ld   bc,$146B
0D5A: 09          add  hl,bc
0D5B: 01 4E 10    ld   bc,$104E
0D5E: 00          nop
0D5F: 00          nop
0D60: 6E          ld   l,(hl)
0D61: 20 00       jr   nz,$0D63
0D63: 00          nop
0D64: 6F          ld   l,a
0D65: 00          nop
0D66: 00          nop
0D67: 01 00 00    ld   bc,$0000
0D6A: 00          nop
0D6B: 00          nop
0D6C: 00          nop
0D6D: 00          nop
0D6E: 00          nop
0D6F: 00          nop
0D70: 6C          ld   l,h
0D71: 10 00       djnz $0D73
0D73: 00          nop
0D74: 6D          ld   l,l
0D75: 00          nop
0D76: 00          nop
0D77: 00          nop
0D78: 00          nop
0D79: 0C          inc  c
0D7A: 07          rlca
0D7B: 00          nop
0D7C: 4E          ld   c,(hl)
0D7D: 00          nop
0D7E: 02          ld   (bc),a
0D7F: 00          nop
0D80: 6C          ld   l,h
0D81: 10 02       djnz $0D85
0D83: 00          nop
0D84: 6D          ld   l,l
0D85: 20 02       jr   nz,$0D89
0D87: 00          nop
0D88: 6B          ld   l,e
0D89: 0C          inc  c
0D8A: 09          add  hl,bc
0D8B: 00          nop
0D8C: 4E          ld   c,(hl)
0D8D: 00          nop
0D8E: 00          nop
0D8F: 00          nop
0D90: 00          nop
0D91: 10 00       djnz $0D93
0D93: 00          nop
0D94: 6D          ld   l,l
0D95: 00          nop
0D96: 00          nop
0D97: 00          nop
0D98: 00          nop
0D99: 0C          inc  c
0D9A: 07          rlca
0D9B: 00          nop
0D9C: 4E          ld   c,(hl)
0D9D: 00          nop
0D9E: 00          nop
0D9F: 00          nop
0DA0: 00          nop
0DA1: 10 02       djnz $0DA5
0DA3: 00          nop
0DA4: 6E          ld   l,(hl)
0DA5: 20 02       jr   nz,$0DA9
0DA7: 00          nop
0DA8: 6F          ld   l,a
0DA9: 00          nop
0DAA: 00          nop
0DAB: 00          nop
0DAC: 00          nop
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
0DC3: CD 5B 80    call $805B
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
0DD8: CD 5B 80    call $805B
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
0DED: CD 5B 80    call $805B
0DF0: 15          dec  d
0DF1: 15          dec  d
0DF2: 23          inc  hl
0DF3: 10 F8       djnz $0DED
0DF5: C9          ret
0DF6: 11 40 80    ld   de,$8040
0DF9: 21 6D 83    ld   hl,$836D
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
0E40: DA 71 80    jp   c,$8071
0E43: D6 08       sub  $08
0E45: 5F          ld   e,a
0E46: FE 14       cp   $14
0E48: 28 0F       jr   z,$0E59
0E4A: D0          ret  nc
0E4B: E5          push hl
0E4C: C5          push bc
0E4D: 21 66 0E    ld   hl,$0E66
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
0EC5: CD 65 0F    call $0F65
0EC8: CD 31 0F    call $0F31
0ECB: CD 61 5D    call $5D61
0ECE: CD 99 0F    call $0F99
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
0F00: 11 81 80    ld   de,$8081
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
0F12: 11 08 00    ld   de,$0008
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
0F25: 21 80 80    ld   hl,$8080
0F28: 4E          ld   c,(hl)
0F29: 09          add  hl,bc
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
0F84: 11 81 80    ld   de,$8081
0F87: 21 E1 83    ld   hl,$83E1
0F8A: 06 07       ld   b,$07
0F8C: 1A          ld   a,(de)
0F8D: 77          ld   (hl),a
0F8E: 13          inc  de
0F8F: 13          inc  de
0F90: D5          push de
0F91: 11 15 00    ld   de,$0015
0F94: 19          add  hl,de
0F95: D1          pop  de
0F96: 10 F4       djnz $0F8C
0F98: C9          ret
0F99: 21 84 83    ld   hl,$8384
0F9C: 11 08 00    ld   de,$0008
0F9F: 06 0B       ld   b,$0B
0FA1: 3E 80       ld   a,$80
0FA3: 77          ld   (hl),a
0FA4: 19          add  hl,de
0FA5: 10 FC       djnz $0FA3
0FA7: 21 97 80    ld   hl,$8097
0FAA: 06 0B       ld   b,$0B
0FAC: 77          ld   (hl),a
0FAD: 23          inc  hl
0FAE: 10 FC       djnz $0FAC
0FB0: C9          ret
0FB1: 21 A5 80    ld   hl,$80A5
0FB4: 3A 4F 82    ld   a,($824F)
0FB7: CD D2 0F    call $0FD2
0FBA: 21 A7 80    ld   hl,$80A7
0FBD: 3A 4F 82    ld   a,($824F)
0FC0: 0F          rrca
0FC1: 0F          rrca
0FC2: 0F          rrca
0FC3: 0F          rrca
0FC4: CD D2 0F    call $0FD2
0FC7: AF          xor  a
0FC8: 32 A2 80    ld   ($80A2),a
0FCB: 32 A3 80    ld   ($80A3),a
0FCE: 32 A4 80    ld   ($80A4),a
0FD1: C9          ret
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
0FEA: 3A AC 80    ld   a,(game_state_80AC)
0FED: B7          or   a
0FEE: C8          ret  z
0FEF: CD 36 10    call $1036
0FF2: 3A A3 80    ld   a,($80A3)
0FF5: 21 A5 80    ld   hl,$80A5
0FF8: CD 19 10    call $1019
0FFB: 78          ld   a,b
0FFC: 32 A3 80    ld   ($80A3),a
0FFF: CD 36 10    call $1036
1002: 3A 50 82    ld   a,($8250)
1005: CB 7F       bit  7,a
1007: C0          ret  nz
1008: 3A A4 80    ld   a,($80A4)
100B: 21 A7 80    ld   hl,$80A7
100E: CD 19 10    call $1019
1011: 78          ld   a,b
1012: 32 A4 80    ld   ($80A4),a
1015: CD 36 10    call $1036
1018: C9          ret
1019: 47          ld   b,a
101A: 3A A2 80    ld   a,($80A2)
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
1032: 32 A2 80    ld   ($80A2),a
1035: C9          ret
1036: 3A A2 80    ld   a,($80A2)
1039: FE 09       cp   $09
103B: 30 10       jr   nc,$104D
103D: AF          xor  a
103E: 32 45 82    ld   ($8245),a
1041: 3A 4D 82    ld   a,($824D)
1044: F6 01       or   $01
1046: 32 4D 82    ld   ($824D),a
1049: 32 0E D5    ld   ($D50E),a
104C: C9          ret
104D: 3A 4D 82    ld   a,($824D)
1050: E6 FE       and  $FE
1052: 32 4D 82    ld   ($824D),a
1055: 32 0E D5    ld   ($D50E),a
1058: C9          ret
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
106F: 32 0B D5    ld   ($D50B),a
1072: 34          inc  (hl)
1073: 3A 50 82    ld   a,($8250)
1076: CB 7F       bit  7,a
1078: 20 0B       jr   nz,$1085
107A: CB 60       bit  4,b
107C: 28 07       jr   z,$1085
107E: 23          inc  hl
107F: 3E C1       ld   a,$C1
1081: 32 0B D5    ld   ($D50B),a
1084: 34          inc  (hl)
1085: 3A 4C 82    ld   a,($824C)
1088: 47          ld   b,a
1089: 3A 0C D4    ld   a,($D40C)
108C: 32 4C 82    ld   ($824C),a
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
10A5: 3A A2 80    ld   a,($80A2)
10A8: FE 09       cp   $09
10AA: D0          ret  nc
10AB: 3C          inc  a
10AC: 32 A2 80    ld   ($80A2),a
10AF: C9          ret

10B0: 3A 4E 82    ld   a,($824E)
10B3: CB 57       bit  2,a
10B5: 20 09       jr   nz,$10C0
10B7: 3A A2 80    ld   a,($80A2)
10BA: C6 10       add  a,$10
10BC: 32 BE C7    ld   ($C7BE),a
10BF: C9          ret
10C0: 21 CA 10    ld   hl,table_10CA
10C3: 11 B7 C7    ld   de,$C7B7
10C6: CD F9 29    call copy_bytes_to_screen_29F9
10C9: C9          ret

table_10CA:
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
1122: 32 3B 82    ld   ($823B),a
1125: 3A 51 82    ld   a,($8251)
1128: B7          or   a
1129: CA 67 11    jp   z,$1167
112C: 3D          dec  a
112D: CA 5A 11    jp   z,$115A
1130: 21 D3 7D    ld   hl,$7DD3
1133: 22 3C 82    ld   ($823C),hl
1136: 3E 05       ld   a,$05
1138: 32 2C 80    ld   ($802C),a
113B: AF          xor  a
113C: 32 AB 80    ld   ($80AB),a
113F: 32 34 82    ld   (nb_lives_8234),a
1142: 32 00 D6    ld   ($D600),a
1145: CD 75 11    call $1175
1148: 3E 02       ld   a,$02
114A: 32 37 82    ld   (skill_level_8237),a
114D: CD 3E 2A    call $2A3E
1150: CD 00 27    call $2700
1153: CD 65 2A    call $2A65
1156: CD 9B 75    call $759B
1159: C9          ret
115A: 21 D3 7B    ld   hl,$7BD3
115D: 22 3C 82    ld   ($823C),hl
1160: 3E 12       ld   a,$12
1162: 32 2C 80    ld   ($802C),a
1165: 18 D4       jr   $113B
1167: 21 63 7A    ld   hl,$7A63
116A: 22 3C 82    ld   ($823C),hl
116D: 3E 1C       ld   a,$1C
116F: 32 2C 80    ld   ($802C),a
1172: 18 C7       jr   $113B
1174: C9          ret
1175: 3A 3B 82    ld   a,($823B)
1178: 3D          dec  a
1179: 28 0F       jr   z,$118A
117B: 2A 3C 82    ld   hl,($823C)
117E: 5E          ld   e,(hl)
117F: 23          inc  hl
1180: 56          ld   d,(hl)
1181: 23          inc  hl
1182: 22 3C 82    ld   ($823C),hl
1185: ED 53 D6 81 ld   ($81D6),de
1189: C9          ret
118A: 2A 3C 82    ld   hl,($823C)
118D: ED 5B D6 81 ld   de,($81D6)
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
11BE: 32 00 D6    ld   ($D600),a
11C1: 3A AC 80    ld   a,(game_state_80AC)
11C4: 47          ld   b,a
11C5: 80          add  a,b
11C6: 80          add  a,b	; times 3 to adjust to jump table
11C7: 5F          ld   e,a
11C8: 16 00       ld   d,$00
11CA: 21 CF 11    ld   hl,$11CF
11CD: 19          add  hl,de
11CE: E9          jp   (hl)

11CF: C3 ED 11    jp   $11ED				            | 0 ???
11D2: C3 F0 11    jp   title_sequence_11F0              | 1
11D5: C3 F6 11    jp   $11F6                            | 2 ???
11D8: C3 F9 11    jp   push_start_screen_11F9           | 3
11DB: C3 02 12    jp   game_intro_1202                  | 4
11DE: C3 11 12    jp   game_running_1211                | 5
11E1: C3 29 12    jp   ground_floor_reached_1229        | 6
11E4: C3 2F 12    jp   next_life_122F                   | 7
11E7: C3 35 12    jp   game_over_1235                   | 8
11EA: C3 3B 12    jp   insert_coint_screen_123B         | 9

11ED: C3 3E 12    jp   $123E

title_sequence_11F0:
11F0: CD 30 74    call $7430
11F3: C3 3E 12    jp   $123E

11F6: C3 3E 12    jp   $123E

push_start_screen_11F9:
11F9: CD B6 2E    call $2EB6
11FC: CD B0 10    call $10B0
11FF: C3 3E 12    jp   $123E

game_intro_1202:
1202: CD 0B 50    call $500B
1205: CD B0 10    call $10B0
1208: CD C6 57    call $57C6
120B: CD 01 58    call $5801
120E: C3 3E 12    jp   $123E

game_running_1211:
1211: CD C3 03    call $03C3
1214: CD 70 15    call $1570
1217: CD 5C 61    call $615C
121A: CD F0 15    call $15F0
121D: CD C6 57    call $57C6
1220: CD B0 10    call $10B0
1223: CD 01 58    call $5801
1226: C3 3E 12    jp   $123E

ground_floor_reached_1229:
1229: CD 7A 0E    call $0E7A
122C: C3 11 12    jp   game_running_1211

next_life_122F:
122F: CD CA 26    call $26CA
1232: C3 3E 12    jp   $123E

game_over_1235:
1235: CD B0 10    call $10B0
1238: C3 3E 12    jp   $123E

insert_coint_screen_123B:
123B: C3 3E 12    jp   $123E

123E: 3A A9 80    ld   a,($80A9)
1241: 3D          dec  a
1242: 32 AA 80    ld   (timer_8bit_80AA),a
1245: AF          xor  a
1246: 32 AB 80    ld   ($80AB),a
1249: 3A EA 82    ld   a,($82EA)
124C: B7          or   a
124D: 20 0B       jr   nz,$125A
124F: CD 59 10    call $1059
1252: 3A 0C D4    ld   a,($D40C)
1255: CB 6F       bit  5,a
1257: CA EB 70    jp   z,$70EB
125A: 32 0D D5    ld   ($D50D),a
125D: CD 00 65    call $6500
1260: CD 6A 65    call $656A
1263: CD DF 65    call $65DF
1266: 21 48 86    ld   hl,$8648
1269: 7E          ld   a,(hl)
126A: 3C          inc  a
126B: 3C          inc  a
126C: CB DF       set  3,a
126E: FA 73 12    jp   m,$1273
1271: EE 9A       xor  $9A
1273: 77          ld   (hl),a
1274: CD CF 77    call $77CF
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
12A2: 21 BD 80    ld   hl,$80BD
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
12DF: CA B6 13    jp   z,$13B6
12E2: FE 30       cp   $30
12E4: DA 56 14    jp   c,$1456
12E7: CD EC 13    call $13EC
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
1301: C3 B6 13    jp   $13B6
1304: 3E 01       ld   a,$01
1306: C3 6A 13    jp   $136A
1309: CD 81 15    call $1581
130C: DD 7E 02    ld   a,(ix+$02)
130F: FE 07       cp   $07
1311: 38 3D       jr   c,$1350
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
1326: CD 86 14    call $1486
1329: DD 7E 02    ld   a,(ix+$02)
132C: 21 40 13    ld   hl,$1340
132F: FE 10       cp   $10
1331: D2 3C 13    jp   nc,$133C
1334: FE 0B       cp   $0B
1336: DA 3C 13    jp   c,$133C
1339: 21 48 13    ld   hl,$1348
133C: CD C3 14    call $14C3
133F: C9          ret
1340: 9D          sbc  a,l
1341: 9D          sbc  a,l
1342: 00          nop
1343: 00          nop
1344: 00          nop
1345: 00          nop
1346: 00          nop
1347: 00          nop
1348: 9F          sbc  a,a
1349: 9F          sbc  a,a
134A: 00          nop
134B: 00          nop
134C: 00          nop
134D: 00          nop
134E: 00          nop
134F: 00          nop
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
1384: 3A 04 80    ld   a,($8004)
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
13B6: CD 81 15    call $1581
13B9: DD 7E 06    ld   a,(ix+$06)
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
13DE: 21 16 14    ld   hl,$1416
13E1: 09          add  hl,bc
13E2: CD C3 14    call $14C3
13E5: DD 7E 06    ld   a,(ix+$06)
13E8: FE 02       cp   $02
13EA: 30 12       jr   nc,$13FE
13EC: 3E FF       ld   a,$FF
13EE: DD 77 05    ld   (ix+character_delta_x_05),a
13F1: DD 77 02    ld   (ix+$02),a
13F4: 2A EF 80    ld   hl,($80EF)
13F7: 77          ld   (hl),a
13F8: 11 05 00    ld   de,$0005
13FB: 19          add  hl,de
13FC: 77          ld   (hl),a
13FD: C9          ret
13FE: CD 00 15    call $1500
1401: 3E FF       ld   a,$FF
1403: 2A EF 80    ld   hl,($80EF)
1406: 77          ld   (hl),a
1407: 11 05 00    ld   de,$0005
140A: 19          add  hl,de
140B: 77          ld   (hl),a
140C: 23          inc  hl
140D: 23          inc  hl
140E: 3A 04 80    ld   a,($8004)
1411: ED 44       neg
1413: 86          add  a,(hl)
1414: 77          ld   (hl),a
1415: C9          ret
1416: 57          ld   d,a
1417: 57          ld   d,a
1418: 58          ld   e,b
1419: 58          ld   e,b
141A: 59          ld   e,c
141B: 58          ld   e,b
141C: 58          ld   e,b
141D: 58          ld   e,b
141E: 40          ld   b,b
141F: 40          ld   b,b
1420: 40          ld   b,b
1421: 40          ld   b,b
1422: 40          ld   b,b
1423: 40          ld   b,b
1424: 40          ld   b,b
1425: 40          ld   b,b
1426: 9E          sbc  a,(hl)
1427: 9E          sbc  a,(hl)
1428: 82          add  a,d
1429: 82          add  a,d
142A: 83          add  a,e
142B: 82          add  a,d
142C: 82          add  a,d
142D: 82          add  a,d
142E: 80          add  a,b
142F: 80          add  a,b
1430: 82          add  a,d
1431: 82          add  a,d
1432: 83          add  a,e
1433: 82          add  a,d
1434: 82          add  a,d
1435: 82          add  a,d
1436: 57          ld   d,a
1437: 57          ld   d,a
1438: 58          ld   e,b
1439: 58          ld   e,b
143A: 58          ld   e,b
143B: 5A          ld   e,d
143C: 58          ld   e,b
143D: 58          ld   e,b
143E: 40          ld   b,b
143F: 40          ld   b,b
1440: 40          ld   b,b
1441: 40          ld   b,b
1442: 40          ld   b,b
1443: 40          ld   b,b
1444: 40          ld   b,b
1445: 40          ld   b,b
1446: 9E          sbc  a,(hl)
1447: 9E          sbc  a,(hl)
1448: 82          add  a,d
1449: 82          add  a,d
144A: 82          add  a,d
144B: 84          add  a,h
144C: 82          add  a,d
144D: 82          add  a,d
144E: 80          add  a,b
144F: 80          add  a,b
1450: 82          add  a,d
1451: 82          add  a,d
1452: 82          add  a,d
1453: 84          add  a,h
1454: 82          add  a,d
1455: 82          add  a,d
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
146E: 3A 04 80    ld   a,($8004)
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
1480: 3E 36       ld   a,$36
1482: CD 56 36    call $3656
1485: C9          ret
1486: 2A EF 80    ld   hl,($80EF)
1489: 36 01       ld   (hl),$01
148B: 23          inc  hl
148C: DD 7E 00    ld   a,(ix+character_x_00)
148F: 77          ld   (hl),a
1490: 23          inc  hl
1491: DD 46 02    ld   b,(ix+$02)
1494: 0E 00       ld   c,$00
1496: 16 04       ld   d,$04
1498: E5          push hl
1499: CD 6C 1E    call $1E6C
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
14C3: E5          push hl
14C4: DD 46 02    ld   b,(ix+$02)
14C7: DD 4E 04    ld   c,(ix+$04)
14CA: CD 05 56    call $5605
14CD: 44          ld   b,h
14CE: 4D          ld   c,l
14CF: E1          pop  hl
14D0: ED 5B ED 80 ld   de,($80ED)
14D4: CD E5 14    call $14E5
14D7: CD E5 14    call $14E5
14DA: CD E5 14    call $14E5
14DD: CD E5 14    call $14E5
14E0: ED 53 ED 80 ld   ($80ED),de
14E4: C9          ret
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
1500: DD 46 02    ld   b,(ix+$02)
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
151D: DD 7E 02    ld   a,(ix+$02)
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
1570: 21 BD 80    ld   hl,$80BD
1573: 7E          ld   a,(hl)
1574: B7          or   a
1575: C8          ret  z
1576: 57          ld   d,a
1577: 23          inc  hl
1578: 5E          ld   e,(hl)
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
15A0: 11 69 81    ld   de,$8169
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
15BD: 28 15       jr   z,$15D4
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
15ED: C3 BF 15    jp   $15BF
15F0: 21 69 81    ld   hl,$8169
15F3: 11 7C D1    ld   de,$D17C
15F6: ED A0       ldi
15F8: ED A0       ldi
15FA: ED A0       ldi
15FC: ED A0       ldi
15FE: 11 00 D1    ld   de,$D100
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
1681: 11 60 D1    ld   de,$D160
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
16E3: 06 0C       ld   b,$0C
16E5: 31 01 47    ld   sp,$4701
16E8: 0C          inc  c
16E9: 51          ld   d,c
16EA: 02          ld   (bc),a
16EB: 67          ld   h,a
16EC: 0C          inc  c
16ED: 71          ld   (hl),c
16EE: 03          inc  bc
16EF: 87          add  a,a
16F0: 0C          inc  c
16F1: 91          sub  c
16F2: 04          inc  b
16F3: A7          and  a
16F4: 0C          inc  c
16F5: B1          or   c
16F6: 05          dec  b
16F7: C7          rst  $00
16F8: 0C          inc  c
16F9: FA 0B 5B    jp   m,$5B0B
16FC: 20 2B       jr   nz,$1729
16FE: 36 4B       ld   (hl),$4B
1700: 24          inc  h
1701: 2F          cpl
1702: 1C          inc  e
1703: 06 0C       ld   b,$0C
1705: 31 01 47    ld   sp,$4701
1708: 0C          inc  c
1709: 51          ld   d,c
170A: 02          ld   (bc),a
170B: 67          ld   h,a
170C: 0C          inc  c
170D: 71          ld   (hl),c
170E: 03          inc  bc
170F: 87          add  a,a
1710: 0C          inc  c
1711: 91          sub  c
1712: 04          inc  b
1713: A7          and  a
1714: 0C          inc  c
1715: B1          or   c
1716: 05          dec  b
1717: C7          rst  $00
1718: 0C          inc  c
1719: FA 0B 5B    jp   m,$5B0B
171C: 20 2B       jr   nz,$1749
171E: 84          add  a,h
171F: 6F          ld   l,a
1720: 7F          ld   a,a
1721: 84          add  a,h
1722: 82          add  a,d
1723: 06 0C       ld   b,$0C
1725: 31 01 47    ld   sp,$4701
1728: 0C          inc  c
1729: 51          ld   d,c
172A: 02          ld   (bc),a
172B: 67          ld   h,a
172C: 0C          inc  c
172D: 71          ld   (hl),c
172E: 03          inc  bc
172F: 87          add  a,a
1730: 0C          inc  c
1731: 91          sub  c
1732: 04          inc  b
1733: A7          and  a
1734: 0C          inc  c
1735: B1          or   c
1736: 05          dec  b
1737: C7          rst  $00
1738: 0C          inc  c
1739: FA 0B 5B    jp   m,$5B0B
173C: 20 2B       jr   nz,$1769
173E: 36 4B       ld   (hl),$4B
1740: 24          inc  h
1741: 2F          cpl
1742: 1C          inc  e
1743: 06 0C       ld   b,$0C
1745: 31 01 47    ld   sp,$4701
1748: 0C          inc  c
1749: 51          ld   d,c
174A: 02          ld   (bc),a
174B: 67          ld   h,a
174C: 0C          inc  c
174D: 71          ld   (hl),c
174E: 03          inc  bc
174F: 87          add  a,a
1750: 0C          inc  c
1751: 91          sub  c
1752: 04          inc  b
1753: A7          and  a
1754: 0C          inc  c
1755: B1          or   c
1756: 05          dec  b
1757: C7          rst  $00
1758: 0C          inc  c
1759: FA 0B 5B    jp   m,$5B0B
175C: 20 2B       jr   nz,$1789
175E: 36 4B       ld   (hl),$4B
1760: 24          inc  h
1761: 2F          cpl
1762: 1C          inc  e
1763: 06 0C       ld   b,$0C
1765: 31 01 47    ld   sp,$4701
1768: 0C          inc  c
1769: 51          ld   d,c
176A: 02          ld   (bc),a
176B: 67          ld   h,a
176C: 0C          inc  c
176D: 71          ld   (hl),c
176E: 03          inc  bc
176F: 87          add  a,a
1770: 0C          inc  c
1771: 91          sub  c
1772: 04          inc  b
1773: A7          and  a
1774: 0C          inc  c
1775: B1          or   c
1776: 05          dec  b
1777: C7          rst  $00
1778: 0C          inc  c
1779: FA 0B 5B    jp   m,$5B0B
177C: 20 2B       jr   nz,$17A9
177E: 36 4B       ld   (hl),$4B
1780: 24          inc  h
1781: 2F          cpl
1782: 1C          inc  e
1783: 06 0C       ld   b,$0C
1785: 31 01 47    ld   sp,$4701
1788: 0C          inc  c
1789: 51          ld   d,c
178A: 02          ld   (bc),a
178B: 67          ld   h,a
178C: 0C          inc  c
178D: 71          ld   (hl),c
178E: 03          inc  bc
178F: 87          add  a,a
1790: 0C          inc  c
1791: 91          sub  c
1792: 04          inc  b
1793: A7          and  a
1794: 0C          inc  c
1795: B1          or   c
1796: 05          dec  b
1797: C7          rst  $00
1798: 0C          inc  c
1799: FA 0B 5B    jp   m,$5B0B
179C: 20 2B       jr   nz,$17C9
179E: 36 4B       ld   (hl),$4B
17A0: 24          inc  h
17A1: 2F          cpl
17A2: 1C          inc  e
17A3: 06 0C       ld   b,$0C
17A5: 31 01 47    ld   sp,$4701
17A8: 0C          inc  c
17A9: 51          ld   d,c
17AA: 02          ld   (bc),a
17AB: 67          ld   h,a
17AC: 0C          inc  c
17AD: 91          sub  c
17AE: 04          inc  b
17AF: A7          and  a
17B0: 0C          inc  c
17B1: B1          or   c
17B2: 05          dec  b
17B3: C7          rst  $00
17B4: 0C          inc  c
17B5: FA 0B 5B    jp   m,$5B0B
17B8: 20 2B       jr   nz,$17E5
17BA: 36 4B       ld   (hl),$4B
17BC: 24          inc  h
17BD: 2F          cpl
17BE: 1C          inc  e
17BF: 45          ld   b,l
17C0: D2 37 D4    jp   nc,$D437
17C3: 06 0C       ld   b,$0C
17C5: 11 00 27    ld   de,$2700
17C8: 0C          inc  c
17C9: 51          ld   d,c
17CA: 02          ld   (bc),a
17CB: 67          ld   h,a
17CC: 0C          inc  c
17CD: 91          sub  c
17CE: 04          inc  b
17CF: A7          and  a
17D0: 0C          inc  c
17D1: B1          or   c
17D2: 05          dec  b
17D3: C7          rst  $00
17D4: 0C          inc  c
17D5: D1          pop  de
17D6: 06 E7       ld   b,$E7
17D8: 0C          inc  c
17D9: FA 0B 5B    jp   m,$5B0B
17DC: 20 2B       jr   nz,$1809
17DE: 36 4B       ld   (hl),$4B
17E0: 24          inc  h
17E1: 2F          cpl
17E2: 1C          inc  e
17E3: 06 0C       ld   b,$0C
17E5: 11 00 27    ld   de,$2700
17E8: 0C          inc  c
17E9: D1          pop  de
17EA: 06 E7       ld   b,$E7
17EC: 0C          inc  c
17ED: FA 0B 5B    jp   m,$5B0B
17F0: 20 2B       jr   nz,$181D
17F2: 36 4B       ld   (hl),$4B
17F4: 24          inc  h
17F5: 2F          cpl
17F6: 1C          inc  e
17F7: 3B          dec  sp
17F8: 6E          ld   l,(hl)
17F9: 01 20 21    ld   bc,$2120
17FC: 36 5F       ld   (hl),$5F
17FE: 24          inc  h
17FF: 39          add  hl,sp
1800: 62          ld   h,d
1801: 31 D2 06    ld   sp,$06D2
1804: 0C          inc  c
1805: 11 00 27    ld   de,$2700
1808: 0C          inc  c
1809: D1          pop  de
180A: 06 E7       ld   b,$E7
180C: 0C          inc  c
180D: FA 0B BF    jp   m,$BF0B
1810: 20 35       jr   nz,$1847
1812: 36 55       ld   (hl),$55
1814: 24          inc  h
1815: 2F          cpl
1816: 30 3B       jr   nc,$1853
1818: 6E          ld   l,(hl)
1819: 01 E8 49    ld   bc,$49E8
181C: 36 19       ld   (hl),$19
181E: 24          inc  h
181F: 25          dec  h
1820: 62          ld   h,d
1821: 27          daa
1822: D2 06 0C    jp   nc,$0C06
1825: 11 00 27    ld   de,$2700
1828: 0C          inc  c
1829: 71          ld   (hl),c
182A: 08          ex   af,af'
182B: 87          add  a,a
182C: 0C          inc  c
182D: D1          pop  de
182E: 06 E7       ld   b,$E7
1830: 0C          inc  c
1831: FA 0B 1F    jp   m,$1F0B
1834: 52          ld   d,d
1835: 2B          dec  hl
1836: 40          ld   b,b
1837: 4B          ld   c,e
1838: 4C          ld   c,h
1839: 1B          dec  de
183A: 1C          inc  e
183B: 29          add  hl,hl
183C: 34          inc  (hl)
183D: 21 40 5F    ld   hl,$5F40
1840: 38 25       jr   c,$1867
1842: 62          ld   h,d
1843: 06 0C       ld   b,$0C
1845: 11 00 27    ld   de,$2700
1848: 0C          inc  c
1849: 71          ld   (hl),c
184A: 08          ex   af,af'
184B: 87          add  a,a
184C: 0C          inc  c
184D: D1          pop  de
184E: 06 E7       ld   b,$E7
1850: 0C          inc  c
1851: FA 0B 33    jp   m,$330B
1854: 2A 17 0E    ld   hl,($0E17)
1857: 5F          ld   e,a
1858: 38 1B       jr   c,$1875
185A: 76          halt
185B: 29          add  hl,hl
185C: 34          inc  (hl)
185D: 21 40 5F    ld   hl,$5F40
1860: 38 25       jr   c,$1887
1862: E4 06 0C    call po,$0C06
1865: 71          ld   (hl),c
1866: 08          ex   af,af'
1867: 87          add  a,a
1868: 0C          inc  c
1869: D1          pop  de
186A: 06 E7       ld   b,$E7
186C: 0C          inc  c
186D: FA 0B BF    jp   m,$BF0B
1870: 20 35       jr   nz,$18A7
1872: 36 55       ld   (hl),$55
1874: 24          inc  h
1875: 2F          cpl
1876: 30 3B       jr   nc,$18B3
1878: 6E          ld   l,(hl)
1879: 01 E8 49    ld   bc,$49E8
187C: 36 19       ld   (hl),$19
187E: 24          inc  h
187F: 25          dec  h
1880: 62          ld   h,d
1881: 27          daa
1882: D2 06 0C    jp   nc,$0C06
1885: 11 07 27    ld   de,$2707
1888: 0C          inc  c
1889: D1          pop  de
188A: 06 E7       ld   b,$E7
188C: 0C          inc  c
188D: FA 0B BF    jp   m,$BF0B
1890: 20 35       jr   nz,$18C7
1892: 36 55       ld   (hl),$55
1894: 24          inc  h
1895: 2F          cpl
1896: 30 3B       jr   nc,$18D3
1898: 6E          ld   l,(hl)
1899: 01 E8 49    ld   bc,$49E8
189C: 36 19       ld   (hl),$19
189E: 24          inc  h
189F: 25          dec  h
18A0: 62          ld   h,d
18A1: 27          daa
18A2: D2 06 0C    jp   nc,$0C06
18A5: 11 07 27    ld   de,$2707
18A8: 0C          inc  c
18A9: FA 0B BF    jp   m,$BF0B
18AC: 20 35       jr   nz,$18E3
18AE: 36 55       ld   (hl),$55
18B0: 24          inc  h
18B1: 2F          cpl
18B2: 30 3B       jr   nc,$18EF
18B4: 6E          ld   l,(hl)
18B5: 6F          ld   l,a
18B6: 70          ld   (hl),b
18B7: 5B          ld   e,e
18B8: E8          ret  pe
18B9: 35          dec  (hl)
18BA: 22 19 24    ld   ($2419),hl
18BD: 43          ld   b,e
18BE: 44          ld   b,h
18BF: 27          daa
18C0: D2 6F 70    jp   nc,$706F
18C3: 06 0C       ld   b,$0C
18C5: 11 07 27    ld   de,$2707
18C8: 0C          inc  c
18C9: 71          ld   (hl),c
18CA: 09          add  hl,bc
18CB: 87          add  a,a
18CC: 0C          inc  c
18CD: FA 0B 8D    jp   m,$8D0B
18D0: 0C          inc  c
18D1: 17          rla
18D2: 36 2D       ld   (hl),$2D
18D4: 24          inc  h
18D5: 43          ld   b,e
18D6: 30 3B       jr   nc,$1913
18D8: 6E          ld   l,(hl)
18D9: 1F          rra
18DA: 84          add  a,h
18DB: 49          ld   c,c
18DC: 36 19       ld   (hl),$19
18DE: 2E 25       ld   l,$25
18E0: 1C          inc  e
18E1: 27          daa
18E2: D2 06 0C    jp   nc,$0C06
18E5: 71          ld   (hl),c
18E6: 09          add  hl,bc
18E7: 87          add  a,a
18E8: 0C          inc  c
18E9: FA 0B 79    jp   m,$790B
18EC: 16 35       ld   d,$35
18EE: 18 55       jr   $1945
18F0: 1A          ld   a,(de)
18F1: 1B          dec  de
18F2: 30 1D       jr   nc,$1911
18F4: 6E          ld   l,(hl)
18F5: 0B          dec  bc
18F6: 0C          inc  c
18F7: 01 DE 49    ld   bc,$49DE
18FA: 18 19       jr   $1915
18FC: 1A          ld   a,(de)
18FD: 1B          dec  de
18FE: 62          ld   h,d
18FF: 3B          dec  sp
1900: D2 0B 0C    jp   nc,$0C0B
1903: 06 0C       ld   b,$0C
1905: 71          ld   (hl),c
1906: 09          add  hl,bc
1907: 87          add  a,a
1908: 0C          inc  c
1909: FA 0B 79    jp   m,$790B
190C: 16 35       ld   d,$35
190E: 18 55       jr   $1965
1910: 1A          ld   a,(de)
1911: 1B          dec  de
1912: 30 1D       jr   nc,$1931
1914: 6E          ld   l,(hl)
1915: 0B          dec  bc
1916: 0C          inc  c
1917: 01 DE 49    ld   bc,$49DE
191A: 18 19       jr   $1935
191C: 1A          ld   a,(de)
191D: 1B          dec  de
191E: 62          ld   h,d
191F: 3B          dec  sp
1920: D2 0B 0C    jp   nc,$0C0B
1923: 06 0C       ld   b,$0C
1925: 79          ld   a,c
1926: 0B          dec  bc
1927: 7F          ld   a,a
1928: 0C          inc  c
1929: FA 0B 79    jp   m,$790B
192C: 16 35       ld   d,$35
192E: 18 55       jr   $1985
1930: 1A          ld   a,(de)
1931: 1B          dec  de
1932: 30 1D       jr   nc,$1951
1934: 6E          ld   l,(hl)
1935: 0B          dec  bc
1936: 0C          inc  c
1937: 01 DE 49    ld   bc,$49DE
193A: 18 19       jr   $1955
193C: 1A          ld   a,(de)
193D: 1B          dec  de
193E: 62          ld   h,d
193F: 3B          dec  sp
1940: D2 0B 0C    jp   nc,$0C0B
1943: 06 0C       ld   b,$0C
1945: 71          ld   (hl),c
1946: 0A          ld   a,(bc)
1947: 87          add  a,a
1948: 0C          inc  c
1949: FA 0B 79    jp   m,$790B
194C: 16 35       ld   d,$35
194E: 18 55       jr   $19A5
1950: 1A          ld   a,(de)
1951: 1B          dec  de
1952: 30 1D       jr   nc,$1971
1954: 6E          ld   l,(hl)
1955: 0B          dec  bc
1956: 0C          inc  c
1957: 01 DE 49    ld   bc,$49DE
195A: 18 19       jr   $1975
195C: 1A          ld   a,(de)
195D: 1B          dec  de
195E: 62          ld   h,d
195F: 3B          dec  sp
1960: D2 0B 0C    jp   nc,$0C0B
1963: 06 0C       ld   b,$0C
1965: 71          ld   (hl),c
1966: 0A          ld   a,(bc)
1967: 87          add  a,a
1968: 0C          inc  c
1969: A9          xor  c
196A: 0B          dec  bc
196B: AF          xor  a
196C: 0C          inc  c
196D: FA 0B 35    jp   m,$350B
1970: 18 55       jr   $19C7
1972: 1A          ld   a,(de)
1973: 1B          dec  de
1974: 30 1D       jr   nc,$1993
1976: 6E          ld   l,(hl)
1977: 0B          dec  bc
1978: 0C          inc  c
1979: 49          ld   c,c
197A: 18 19       jr   $1995
197C: 1A          ld   a,(de)
197D: 1B          dec  de
197E: 62          ld   h,d
197F: 3B          dec  sp
1980: D2 0B 0C    jp   nc,$0C0B
1983: 26 0C       ld   h,$0C
1985: 71          ld   (hl),c
1986: 0A          ld   a,(bc)
1987: 87          add  a,a
1988: 0C          inc  c
1989: D2 0B 79    jp   nc,$790B
198C: 16 35       ld   d,$35
198E: 18 55       jr   $19E5
1990: 1A          ld   a,(de)
1991: 1B          dec  de
1992: 30 1D       jr   nc,$19B1
1994: 6E          ld   l,(hl)
1995: 0B          dec  bc
1996: 0C          inc  c
1997: 01 DE 49    ld   bc,$49DE
199A: 18 19       jr   $19B5
199C: 1A          ld   a,(de)
199D: 1B          dec  de
199E: 62          ld   h,d
199F: 3B          dec  sp
19A0: D2 0B 0C    jp   nc,$0C0B
19A3: 26 0C       ld   h,$0C
19A5: 71          ld   (hl),c
19A6: 0A          ld   a,(bc)
19A7: 87          add  a,a
19A8: 0C          inc  c
19A9: D2 0B 79    jp   nc,$790B
19AC: 16 35       ld   d,$35
19AE: 18 55       jr   $1A05
19B0: 1A          ld   a,(de)
19B1: 1B          dec  de
19B2: 30 1D       jr   nc,$19D1
19B4: 6E          ld   l,(hl)
19B5: 0B          dec  bc
19B6: 0C          inc  c
19B7: 01 DE 49    ld   bc,$49DE
19BA: 18 19       jr   $19D5
19BC: 1A          ld   a,(de)
19BD: 1B          dec  de
19BE: 62          ld   h,d
19BF: 3B          dec  sp
19C0: D2 0B 0C    jp   nc,$0C0B
19C3: 26 0C       ld   h,$0C
19C5: 71          ld   (hl),c
19C6: 0A          ld   a,(bc)
19C7: 87          add  a,a
19C8: 0C          inc  c
19C9: D2 0B 79    jp   nc,$790B
19CC: 16 35       ld   d,$35
19CE: 18 55       jr   $1A25
19D0: 1A          ld   a,(de)
19D1: 1B          dec  de
19D2: 30 1D       jr   nc,$19F1
19D4: 6E          ld   l,(hl)
19D5: 0B          dec  bc
19D6: 0C          inc  c
19D7: 01 DE 49    ld   bc,$49DE
19DA: 18 19       jr   $19F5
19DC: 1A          ld   a,(de)
19DD: 1B          dec  de
19DE: 62          ld   h,d
19DF: 3B          dec  sp
19E0: D2 0B 0C    jp   nc,$0C0B
19E3: 26 0C       ld   h,$0C
19E5: 71          ld   (hl),c
19E6: 0A          ld   a,(bc)
19E7: 87          add  a,a
19E8: 0C          inc  c
19E9: D2 0B 79    jp   nc,$790B
19EC: 16 35       ld   d,$35
19EE: 18 55       jr   $1A45
19F0: 1A          ld   a,(de)
19F1: 1B          dec  de
19F2: 30 1D       jr   nc,$1A11
19F4: 6E          ld   l,(hl)
19F5: 0B          dec  bc
19F6: 0C          inc  c
19F7: 01 DE 49    ld   bc,$49DE
19FA: 18 19       jr   $1A15
19FC: 1A          ld   a,(de)
19FD: 1B          dec  de
19FE: 62          ld   h,d
19FF: 3B          dec  sp
1A00: D2 0B 0C    jp   nc,$0C0B
1A03: 26 0C       ld   h,$0C
1A05: 71          ld   (hl),c
1A06: 0A          ld   a,(bc)
1A07: 87          add  a,a
1A08: 0C          inc  c
1A09: D2 0B 79    jp   nc,$790B
1A0C: 16 35       ld   d,$35
1A0E: 18 55       jr   $1A65
1A10: 1A          ld   a,(de)
1A11: 1B          dec  de
1A12: 30 1D       jr   nc,$1A31
1A14: 6E          ld   l,(hl)
1A15: 0B          dec  bc
1A16: 0C          inc  c
1A17: 01 DE 49    ld   bc,$49DE
1A1A: 18 19       jr   $1A35
1A1C: 1A          ld   a,(de)
1A1D: 1B          dec  de
1A1E: 62          ld   h,d
1A1F: 3B          dec  sp
1A20: D2 0B 0C    jp   nc,$0C0B
1A23: 26 0C       ld   h,$0C
1A25: 71          ld   (hl),c
1A26: 0A          ld   a,(bc)
1A27: 87          add  a,a
1A28: 0C          inc  c
1A29: D2 0B 79    jp   nc,$790B
1A2C: 16 35       ld   d,$35
1A2E: 18 55       jr   $1A85
1A30: 1A          ld   a,(de)
1A31: 1B          dec  de
1A32: 30 1D       jr   nc,$1A51
1A34: 6E          ld   l,(hl)
1A35: 0B          dec  bc
1A36: 0C          inc  c
1A37: 01 DE 49    ld   bc,$49DE
1A3A: 18 19       jr   $1A55
1A3C: 1A          ld   a,(de)
1A3D: 1B          dec  de
1A3E: 62          ld   h,d
1A3F: 3B          dec  sp
1A40: D2 0B 0C    jp   nc,$0C0B
1A43: 26 0C       ld   h,$0C
1A45: 71          ld   (hl),c
1A46: 0A          ld   a,(bc)
1A47: 87          add  a,a
1A48: 0C          inc  c
1A49: D2 0B 79    jp   nc,$790B
1A4C: 16 35       ld   d,$35
1A4E: 18 55       jr   $1AA5
1A50: 1A          ld   a,(de)
1A51: 1B          dec  de
1A52: 30 1D       jr   nc,$1A71
1A54: 6E          ld   l,(hl)
1A55: 0B          dec  bc
1A56: 0C          inc  c
1A57: 01 DE 49    ld   bc,$49DE
1A5A: 18 19       jr   $1A75
1A5C: 1A          ld   a,(de)
1A5D: 1B          dec  de
1A5E: 62          ld   h,d
1A5F: 3B          dec  sp
1A60: D2 0B 0C    jp   nc,$0C0B
1A63: 26 0C       ld   h,$0C
1A65: 71          ld   (hl),c
1A66: 0A          ld   a,(bc)
1A67: 87          add  a,a
1A68: 0C          inc  c
1A69: D2 0B 79    jp   nc,$790B
1A6C: 16 35       ld   d,$35
1A6E: 18 55       jr   $1AC5
1A70: 1A          ld   a,(de)
1A71: 1B          dec  de
1A72: 30 1D       jr   nc,$1A91
1A74: 6E          ld   l,(hl)
1A75: 0B          dec  bc
1A76: 0C          inc  c
1A77: 01 DE 49    ld   bc,$49DE
1A7A: 18 19       jr   $1A95
1A7C: 1A          ld   a,(de)
1A7D: 1B          dec  de
1A7E: 62          ld   h,d
1A7F: 3B          dec  sp
1A80: D2 0B 0C    jp   nc,$0C0B
1A83: 26 0C       ld   h,$0C
1A85: 71          ld   (hl),c
1A86: 0A          ld   a,(bc)
1A87: 87          add  a,a
1A88: 0C          inc  c
1A89: D2 0B 79    jp   nc,$790B
1A8C: 16 35       ld   d,$35
1A8E: 18 55       jr   $1AE5
1A90: 1A          ld   a,(de)
1A91: 1B          dec  de
1A92: 30 1D       jr   nc,$1AB1
1A94: 6E          ld   l,(hl)
1A95: 0B          dec  bc
1A96: 0C          inc  c
1A97: 01 DE 49    ld   bc,$49DE
1A9A: 18 19       jr   $1AB5
1A9C: 1A          ld   a,(de)
1A9D: 1B          dec  de
1A9E: 62          ld   h,d
1A9F: 3B          dec  sp
1AA0: D2 0B 0C    jp   nc,$0C0B
1AA3: 26 0C       ld   h,$0C
1AA5: 71          ld   (hl),c
1AA6: 0A          ld   a,(bc)
1AA7: 87          add  a,a
1AA8: 0C          inc  c
1AA9: D2 0B 79    jp   nc,$790B
1AAC: 16 35       ld   d,$35
1AAE: 18 55       jr   $1B05
1AB0: 1A          ld   a,(de)
1AB1: 1B          dec  de
1AB2: 30 1D       jr   nc,$1AD1
1AB4: 6E          ld   l,(hl)
1AB5: 0B          dec  bc
1AB6: 0C          inc  c
1AB7: 01 DE 49    ld   bc,$49DE
1ABA: 18 19       jr   $1AD5
1ABC: 1A          ld   a,(de)
1ABD: 1B          dec  de
1ABE: 62          ld   h,d
1ABF: 3B          dec  sp
1AC0: D2 0B 0C    jp   nc,$0C0B
1AC3: 26 0C       ld   h,$0C
1AC5: 71          ld   (hl),c
1AC6: 0A          ld   a,(bc)
1AC7: 87          add  a,a
1AC8: 0B          dec  bc
1AC9: 79          ld   a,c
1ACA: 16 35       ld   d,$35
1ACC: 18 55       jr   $1B23
1ACE: 1A          ld   a,(de)
1ACF: 1B          dec  de
1AD0: 30 1D       jr   nc,$1AEF
1AD2: 6E          ld   l,(hl)
1AD3: 0B          dec  bc
1AD4: 0C          inc  c
1AD5: 71          ld   (hl),c
1AD6: 01 DE 49    ld   bc,$49DE
1AD9: 18 19       jr   $1AF4
1ADB: 1A          ld   a,(de)
1ADC: 1B          dec  de
1ADD: 62          ld   h,d
1ADE: 3B          dec  sp
1ADF: D2 0B 0C    jp   nc,$0C0B
1AE2: 71          ld   (hl),c
1AE3: AF          xor  a
1AE4: DD 77 18    ld   (ix+$18),a
1AE7: DD 77 1A    ld   (ix+$1a),a
1AEA: DD 77 17    ld   (ix+$17),a
1AED: DD 36 0E 5A ld   (ix+$0e),$5A
1AF1: 3A 21 85    ld   a,($8521)
1AF4: FE 07       cp   $07
1AF6: DA 25 1B    jp   c,$1B25
1AF9: DD 7E 10    ld   a,(ix+$10)
1AFC: B7          or   a
1AFD: C2 1C 1B    jp   nz,$1B1C
1B00: CD 68 05    call $0568
1B03: D2 20 1B    jp   nc,$1B20
1B06: 3A 20 85    ld   a,($8520)
1B09: B7          or   a
1B0A: 28 0D       jr   z,$1B19
1B0C: 3A 22 85    ld   a,($8522)
1B0F: DD BE 08    cp   (ix+$08)
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
1B2C: CD 68 05    call $0568
1B2F: D2 20 1B    jp   nc,$1B20
1B32: CD 44 1C    call $1C44
1B35: C3 1C 1B    jp   $1B1C
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
1B68: CD 68 05    call $0568
1B6B: D2 20 1B    jp   nc,$1B20
1B6E: CD 9E 1B    call $1B9E
1B71: C3 1C 1B    jp   $1B1C
1B74: CD CE 62    call $62CE
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
1BB8: 3A 23 85    ld   a,($8523)
1BBB: D6 05       sub  $05
1BBD: 28 16       jr   z,$1BD5
1BBF: 3D          dec  a
1BC0: 28 13       jr   z,$1BD5
1BC2: 21 04 1C    ld   hl,$1C04
1BC5: DD 5E 13    ld   e,(ix+$13)
1BC8: 16 00       ld   d,$00
1BCA: 19          add  hl,de
1BCB: CD F5 1D    call $1DF5
1BCE: BE          cp   (hl)
1BCF: 30 04       jr   nc,$1BD5
1BD1: DD 36 12 04 ld   (ix+$12),$04
1BD5: 3A BA 85    ld   a,($85BA)
1BD8: 5F          ld   e,a
1BD9: 16 00       ld   d,$00
1BDB: 21 F8 82    ld   hl,$82F8
1BDE: 19          add  hl,de
1BDF: 3E 0A       ld   a,$0A
1BE1: DD 96 13    sub  (ix+$13)
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
1C04: 00          nop
1C05: 20 40       jr   nz,$1C47
1C07: 80          add  a,b
1C08: 90          sub  b
1C09: A0          and  b
1C0A: B0          or   b
1C0B: C0          ret  nz
1C0C: FF          rst  $38
1C0D: FF          rst  $38
1C0E: FF          rst  $38
1C0F: FF          rst  $38
1C10: FF          rst  $38
1C11: FF          rst  $38
1C12: FF          rst  $38
1C13: FF          rst  $38
1C14: DD 36 1B 00 ld   (ix+$1b),$00
1C18: DD 36 18 00 ld   (ix+$18),$00
1C1C: DD 36 0E 5A ld   (ix+$0e),$5A
1C20: DD 7E 10    ld   a,(ix+$10)
1C23: B7          or   a
1C24: C2 30 1C    jp   nz,$1C30
1C27: CD 68 05    call $0568
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
1C4E: 3A BA 85    ld   a,($85BA)
1C51: FE 03       cp   $03
1C53: 21 D5 1D    ld   hl,$1DD5
1C56: 30 03       jr   nc,$1C5B
1C58: 21 B5 1D    ld   hl,$1DB5
1C5B: CD 3F 1D    call $1D3F
1C5E: C9          ret
1C5F: 3A 23 85    ld   a,($8523)
1C62: D6 05       sub  $05
1C64: 28 E8       jr   z,$1C4E
1C66: 3D          dec  a
1C67: 28 E5       jr   z,$1C4E
1C69: 3A BA 85    ld   a,($85BA)
1C6C: FE 03       cp   $03
1C6E: 21 95 1D    ld   hl,$1D95
1C71: 30 03       jr   nc,$1C76
1C73: 21 75 1D    ld   hl,$1D75
1C76: CD 7A 1C    call $1C7A
1C79: C9          ret
1C7A: DD 7E 13    ld   a,(ix+$13)
1C7D: E6 FE       and  $FE
1C7F: 87          add  a,a
1C80: 5F          ld   e,a
1C81: 16 00       ld   d,$00
1C83: 19          add  hl,de
1C84: CD F5 1D    call $1DF5
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
1C9A: 3A BA 85    ld   a,($85BA)
1C9D: 5F          ld   e,a
1C9E: 16 00       ld   d,$00
1CA0: 21 F8 82    ld   hl,$82F8
1CA3: 19          add  hl,de
1CA4: 3E 0A       ld   a,$0A
1CA6: DD 96 13    sub  (ix+$13)
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
1CD3: DD 7E 13    ld   a,(ix+$13)
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
1D3F: DD 7E 13    ld   a,(ix+$13)
1D42: E6 FE       and  $FE
1D44: 87          add  a,a
1D45: 5F          ld   e,a
1D46: 16 00       ld   d,$00
1D48: 19          add  hl,de
1D49: CD F5 1D    call $1DF5
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
1D75: C4 C4 C4    call nz,$C4C4
1D78: 00          nop
1D79: 80          add  a,b
1D7A: C4 C4 00    call nz,$00C4
1D7D: 40          ld   b,b
1D7E: C4 C4 00    call nz,$00C4
1D81: 20 80       jr   nz,$1D03
1D83: C4 00 08    call nz,$0800
1D86: 40          ld   b,b
1D87: C4 00 08    call nz,$0800
1D8A: 20 C4       jr   nz,$1D50
1D8C: 00          nop
1D8D: 08          ex   af,af'
1D8E: 10 C4       djnz $1D54
1D90: 00          nop
1D91: 00          nop
1D92: 08          ex   af,af'
1D93: C4 00 40    call nz,$4000
1D96: 40          ld   b,b
1D97: 40          ld   b,b
1D98: 00          nop
1D99: 30 40       jr   nc,$1DDB
1D9B: 40          ld   b,b
1D9C: 00          nop
1D9D: 20 40       jr   nz,$1DDF
1D9F: 40          ld   b,b
1DA0: 00          nop
1DA1: 18 30       jr   $1DD3
1DA3: 40          ld   b,b
1DA4: 00          nop
1DA5: 10 20       djnz $1DC7
1DA7: 40          ld   b,b
1DA8: 00          nop
1DA9: 08          ex   af,af'
1DAA: 10 40       djnz $1DEC
1DAC: 00          nop
1DAD: 00          nop
1DAE: 08          ex   af,af'
1DAF: 40          ld   b,b
1DB0: 00          nop
1DB1: 00          nop
1DB2: 00          nop
1DB3: 40          ld   b,b
1DB4: 00          nop
1DB5: C4 C4 DC    call nz,$DCC4
1DB8: 00          nop
1DB9: 90          sub  b
1DBA: C4 DC 00    call nz,$00DC
1DBD: 80          add  a,b
1DBE: C4 DC 00    call nz,$00DC
1DC1: 40          ld   b,b
1DC2: C4 DC 00    call nz,$00DC
1DC5: 20 C4       jr   nz,$1D8B
1DC7: DC 00 10    call c,$1000
1DCA: C4 DC 00    call nz,$00DC
1DCD: 00          nop
1DCE: C4 DC 00    call nz,$00DC
1DD1: 00          nop
1DD2: C4 DC 00    call nz,$00DC
1DD5: 80          add  a,b
1DD6: 80          add  a,b
1DD7: FF          rst  $38
1DD8: 00          nop
1DD9: 70          ld   (hl),b
1DDA: 80          add  a,b
1DDB: FF          rst  $38
1DDC: 00          nop
1DDD: 60          ld   h,b
1DDE: 80          add  a,b
1DDF: FF          rst  $38
1DE0: 00          nop
1DE1: 40          ld   b,b
1DE2: 80          add  a,b
1DE3: FF          rst  $38
1DE4: 00          nop
1DE5: 20 C4       jr   nz,$1DAB
1DE7: FF          rst  $38
1DE8: 00          nop
1DE9: 10 C4       djnz $1DAF
1DEB: FF          rst  $38
1DEC: 00          nop
1DED: 08          ex   af,af'
1DEE: C4 FF 00    call nz,$00FF
1DF1: 00          nop
1DF2: C4 FF 00    call nz,$00FF
1DF5: E5          push hl
1DF6: 2A D6 81    ld   hl,($81D6)
1DF9: 7D          ld   a,l
1DFA: C6 C7       add  a,$C7
1DFC: 6F          ld   l,a
1DFD: 8C          adc  a,h
1DFE: D6 C7       sub  $C7
1E00: 67          ld   h,a
1E01: 22 D6 81    ld   ($81D6),hl
1E04: E1          pop  hl
1E05: C9          ret
1E06: 2A D6 81    ld   hl,($81D6)
1E09: 7D          ld   a,l
1E0A: C6 C7       add  a,$C7
1E0C: 6F          ld   l,a
1E0D: 8C          adc  a,h
1E0E: D6 C7       sub  $C7
1E10: 67          ld   h,a
1E11: 22 D6 81    ld   ($81D6),hl
1E14: C9          ret
1E15: E5          push hl
1E16: CD 06 1E    call $1E06
1E19: 26 A0       ld   h,$A0
1E1B: 2E 06       ld   l,$06
1E1D: BC          cp   h
1E1E: DA 22 1E    jp   c,$1E22
1E21: 94          sub  h
1E22: CB 0C       rrc  h
1E24: 2D          dec  l
1E25: C2 1D 1E    jp   nz,$1E1D
1E28: E1          pop  hl
1E29: C9          ret
1E2A: E5          push hl
1E2B: CD 06 1E    call $1E06
1E2E: 26 C0       ld   h,$C0
1E30: 2E 07       ld   l,$07
1E32: C3 1D 1E    jp   $1E1D
1E35: E5          push hl
1E36: CD 06 1E    call $1E06
1E39: 26 E0       ld   h,$E0
1E3B: C3 1B 1E    jp   $1E1B
1E3E: E5          push hl
1E3F: CD 06 1E    call $1E06
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
1E6C: CD 5A 1E    call $1E5A
1E6F: ED 5B 2A 80 ld   de,($802A)
1E73: AF          xor  a
1E74: ED 52       sbc  hl,de
1E76: C9          ret
1E77: 2C          inc  l
1E78: 75          ld   (hl),l
1E79: 4C          ld   c,h
1E7A: 26 85       ld   h,$85
1E7C: 34          inc  (hl)
1E7D: B7          or   a
1E7E: 45          ld   b,l
1E7F: 7A          ld   a,d
1E80: 26 2B       ld   h,$2B
1E82: 12          ld   (de),a
1E83: BB          cp   e
1E84: 57          ld   d,a
1E85: C3 75 38    jp   $3875
1E88: 6B          ld   l,e
1E89: 12          ld   (de),a
1E8A: 63          ld   h,e
1E8B: 3D          dec  a
1E8C: C1          pop  bc
1E8D: 9A          sbc  a,d
1E8E: 26 2B       ld   h,$2B
1E90: 10 3F       djnz $1ED1
1E92: 1F          rra
1E93: 5F          ld   e,a
1E94: 70          ld   (hl),b
1E95: 9C          sbc  a,h
1E96: 88          adc  a,b
1E97: A0          and  b
1E98: 4C          ld   c,h
1E99: 97          sub  a
1E9A: B4          or   h
1E9B: C3 8C 73    jp   $738C
1E9E: 90          sub  b
1E9F: A0          and  b
1EA0: 4F          ld   c,a
1EA1: 0B          dec  bc
1EA2: 4F          ld   c,a
1EA3: 58          ld   e,b
1EA4: 1E A4       ld   e,$A4
1EA6: C6 49       add  a,$49
1EA8: 94          sub  h
1EA9: BE          cp   (hl)
1EAA: 8C          adc  a,h
1EAB: 39          add  hl,sp
1EAC: C3 89 38    jp   $3889
1EAF: 8B          adc  a,e
1EB0: FD 6F       ld   iyl,a
1EB2: FB          ei
1EB3: 6F          ld   l,a
1EB4: E7          rst  $20
1EB5: BD          cp   l
1EB6: C3 4A 8F    jp   $8F4A
1EB9: 55          ld   d,l
1EBA: F7          rst  $30
1EBB: B2          or   d
1EBC: 2B          dec  hl
1EBD: 68          ld   l,b
1EBE: C7          rst  $00
1EBF: 35          dec  (hl)
1EC0: 93          sub  e
1EC1: F9          ld   sp,hl
1EC2: 9B          sbc  a,e
1EC3: E7          rst  $20
1EC4: 83          add  a,e
1EC5: 4E          ld   c,(hl)
1EC6: DB 87       in   a,($87)
1EC8: ED          db   $ed
1EC9: B6          or   (hl)
1ECA: 2E CC       ld   l,$CC
1ECC: 18 78       jr   $1F46
1ECE: 86          add  a,(hl)
1ECF: 11 73 0F    ld   de,$0F73
1ED2: FB          ei
1ED3: B7          or   a
1ED4: 44          ld   b,h
1ED5: EF          rst  $28
1ED6: 0E 3F       ld   c,$3F
1ED8: 44          ld   b,h
1ED9: 54          ld   d,h
1EDA: 00          nop
1EDB: 30 69       jr   nc,$1F46
1EDD: 27          daa
1EDE: A4          and  h
1EDF: 5F          ld   e,a
1EE0: 27          daa
1EE1: B7          or   a
1EE2: 9A          sbc  a,d
1EE3: E8          ret  pe
1EE4: 7A          ld   a,d
1EE5: 50          ld   d,b
1EE6: 0F          rrca
1EE7: 4B          ld   c,e
1EE8: 4D          ld   c,l
1EE9: DD 67       ld   ixh,a
1EEB: C1          pop  bc
1EEC: 67          ld   h,a
1EED: A5          and  l
1EEE: 2B          dec  hl
1EEF: 66          ld   h,(hl)
1EF0: 7A          ld   a,d
1EF1: D5          push de
1EF2: F1          pop  af
1EF3: 39          add  hl,sp
1EF4: E3          ex   (sp),hl
1EF5: 8E          adc  a,(hl)
1EF6: EE A2       xor  $A2
1EF8: EC B1 54    call pe,$54B1
1EFB: EB          ex   de,hl
1EFC: 2D          dec  l
1EFD: A0          and  b
1EFE: 52          ld   d,d
1EFF: 92          sub  d
1F00: 79          ld   a,c
1F01: C9          ret
1F02: B6          or   (hl)
1F03: ED          db   $ed
1F04: C8          ret  z
1F05: 62          ld   h,d
1F06: 8D          adc  a,l
1F07: E5          push hl
1F08: 5F          ld   e,a
1F09: 5E          ld   e,(hl)
1F0A: 05          dec  b
1F0B: 3A 3E B0    ld   a,($B03E)
1F0E: 4B          ld   c,e
1F0F: 30 F7       jr   nc,$1F08
1F11: AE          xor  (hl)
1F12: 87          add  a,a
1F13: 3A 21 4E    ld   a,($4E21)
1F16: E7          rst  $20
1F17: C3 75 38    jp   $3875
1F1A: 17          rla
1F1B: AC          xor  h
1F1C: 82          add  a,d
1F1D: 68          ld   l,b
1F1E: 49          ld   c,c
1F1F: 10 4C       djnz $1F6D
1F21: 94          sub  h
1F22: 03          inc  bc
1F23: 06 04       ld   b,$04
1F25: 2C          inc  l
1F26: 10 24       djnz $1F4C
1F28: 77          ld   (hl),a
1F29: 2C          inc  l
1F2A: 7B          ld   a,e
1F2B: E1          pop  hl
1F2C: AF          xor  a
1F2D: 9D          sbc  a,l
1F2E: 62          ld   h,d
1F2F: F0          ret  p
1F30: F7          rst  $30
1F31: B0          or   b
1F32: 0E 42       ld   c,$42
1F34: 41          ld   b,c
1F35: 9A          sbc  a,d
1F36: 26 2B       ld   h,$2B
1F38: 18 3A       jr   $1F74
1F3A: 2C          inc  l
1F3B: F7          rst  $30
1F3C: F5          push af
1F3D: 61          ld   h,c
1F3E: 18 E8       jr   $1F28
1F40: 7D          ld   a,l
1F41: 7E          ld   a,(hl)
1F42: E3          ex   (sp),hl
1F43: 11 71 44    ld   de,$4471
1F46: 9E          sbc  a,(hl)
1F47: 2F          cpl
1F48: 40          ld   b,b
1F49: 04          inc  b
1F4A: 6A          ld   l,d
1F4B: 81          add  a,c
1F4C: F9          ld   sp,hl
1F4D: 51          ld   d,c
1F4E: 77          ld   (hl),a
1F4F: A5          and  l
1F50: 47          ld   b,a
1F51: F4 7B 90    call p,$907B
1F54: 17          rla
1F55: 57          ld   d,a
1F56: 91          sub  c
1F57: B7          or   a
1F58: 41          ld   b,c
1F59: 61          ld   h,c
1F5A: 62          ld   h,d
1F5B: DC AC 86    call c,$86AC
1F5E: 65          ld   h,l
1F5F: 55          ld   d,l
1F60: 3D          dec  a
1F61: 88          adc  a,b
1F62: A2          and  d
1F63: CA C7 66    jp   z,$66C7
1F66: 26 1A       ld   h,$1A
1F68: DA EB 6F    jp   c,$6FEB
1F6B: 2B          dec  hl
1F6C: 29          add  hl,hl
1F6D: 00          nop
1F6E: EB          ex   de,hl
1F6F: 97          sub  a
1F70: 9D          sbc  a,l
1F71: 77          ld   (hl),a
1F72: AF          xor  a
1F73: EC 88 D7    call pe,$D788
1F76: 4D          ld   c,l
1F77: 9A          sbc  a,d
1F78: FD          db   $fd
1F79: C0          ret  nz
1F7A: 4B          ld   c,e
1F7B: 74          ld   (hl),h
1F7C: C4 EF 8E    call nz,$8EEF
1F7F: 64          ld   h,h
1F80: 03          inc  bc
1F81: 75          ld   (hl),l
1F82: 3C          inc  a
1F83: 36 5E       ld   (hl),$5E
1F85: AF          xor  a
1F86: C3 92 5D    jp   $5D92
1F89: CD AC 5F    call $5FAC
1F8C: EF          rst  $28
1F8D: 63          ld   h,e
1F8E: A2          and  d
1F8F: 62          ld   h,d
1F90: B1          or   c
1F91: B0          or   b
1F92: F9          ld   sp,hl
1F93: 1B          dec  de
1F94: 44          ld   b,h
1F95: B1          or   c
1F96: 38 43       jr   c,$1FDB
1F98: 6D          ld   l,l
1F99: 75          ld   (hl),l
1F9A: AB          xor  e
1F9B: 22 A3 0B    ld   ($0BA3),hl
1F9E: B0          or   b
1F9F: BF          cp   a
1FA0: BD          cp   l
1FA1: 35          dec  (hl)
1FA2: D2 84 A1    jp   nc,$A184
1FA5: 13          inc  de
1FA6: 37          scf
1FA7: 62          ld   h,d
1FA8: 40          ld   b,b
1FA9: 7A          ld   a,d
1FAA: D1          pop  de
1FAB: F3          di
1FAC: D5          push de
1FAD: 55          ld   d,l
1FAE: EA 0C 8A    jp   pe,$8A0C
1FB1: 9E          sbc  a,(hl)
1FB2: 2D          dec  l
1FB3: DA 2F 7C    jp   c,$7C2F
1FB6: F5          push af
1FB7: 7D          ld   a,l
1FB8: 5F          ld   e,a
1FB9: 41          ld   b,c
1FBA: E1          pop  hl
1FBB: 6B          ld   l,e
1FBC: DF          rst  $18
1FBD: 57          ld   d,a
1FBE: F4 EF F1    call p,$F1EF
1FC1: 91          sub  c
1FC2: 41          ld   b,c
1FC3: B1          or   c
1FC4: DC 44 0E    call c,$0E44
1FC7: A5          and  l
1FC8: 2B          dec  hl
1FC9: 4C          ld   c,h
1FCA: 74          ld   (hl),h
1FCB: 3A E3 A2    ld   a,($A2E3)
1FCE: 67          ld   h,a
1FCF: D5          push de
1FD0: F1          pop  af
1FD1: 41          ld   b,c
1FD2: C8          ret  z
1FD3: 90          sub  b
1FD4: 41          ld   b,c
1FD5: 87          add  a,a
1FD6: C7          rst  $00
1FD7: 53          ld   d,e
1FD8: B3          or   e
1FD9: 9B          sbc  a,e
1FDA: 61          ld   h,c
1FDB: 4D          ld   c,l
1FDC: D6 41       sub  $41
1FDE: 60          ld   h,b
1FDF: 48          ld   c,b
1FE0: B4          or   h
1FE1: C4 C4 B3    call nz,$B3C4
1FE4: 9A          sbc  a,d
1FE5: 26 2B       ld   h,$2B
1FE7: 1F          rra
1FE8: C9          ret
1FE9: C7          rst  $00
1FEA: 40          ld   b,b
1FEB: 0C          inc  c
1FEC: 9C          sbc  a,h
1FED: 51          ld   d,c
1FEE: 26 3E       ld   h,$3E
1FF0: A7          and  a
1FF1: 76          halt
1FF2: 24          inc  h
1FF3: 52          ld   d,d
1FF4: 88          adc  a,b
1FF5: BF          cp   a
1FF6: D6 12       sub  $12
1FF8: 61          ld   h,c
1FF9: B9          cp   c
1FFA: E9          jp   (hl)
1FFB: D5          push de
1FFC: C7          rst  $00
1FFD: D6 0D       sub  $0D
1FFF: 13          inc  de
2000: 66          ld   h,(hl)
2001: 5D          ld   e,l
2002: 7D          ld   a,l
2003: 5A          ld   e,d
2004: 31 6E AE    ld   sp,$AE6E
2007: 77          ld   (hl),a
2008: 1E 38       ld   e,$38
200A: 27          daa
200B: DF          rst  $18
200C: 2B          dec  hl
200D: DF          rst  $18
200E: 95          sub  l
200F: D7          rst  $10
2010: C7          rst  $00
2011: AA          xor  d
2012: E8          ret  pe
2013: 7E          ld   a,(hl)
2014: 5F          ld   e,a
2015: 7C          ld   a,h
2016: 8E          adc  a,(hl)
2017: 7C          ld   a,h
2018: 8B          adc  a,e
2019: E1          pop  hl
201A: CE 5F       adc  a,$5F
201C: 73          ld   (hl),e
201D: 3E E4       ld   a,$E4
201F: 76          halt
2020: 62          ld   h,d
2021: 67          ld   h,a
2022: 8C          adc  a,h
2023: 4C          ld   c,h
2024: D6 2C       sub  $2C
2026: 45          ld   b,l
2027: 04          inc  b
2028: 03          inc  bc
2029: F7          rst  $30
202A: 92          sub  d
202B: 89          adc  a,c
202C: 60          ld   h,b
202D: FE E8       cp   $E8
202F: E2 5D C5    jp   po,$C55D
2032: 26 1C       ld   h,$1C
2034: 91          sub  c
2035: C7          rst  $00
2036: 9A          sbc  a,d
2037: E8          ret  pe
2038: 79          ld   a,c
2039: E0          ret  po
203A: EF          rst  $28
203B: DC 73 EC    call c,$EC73
203E: 86          add  a,(hl)
203F: 52          ld   d,d
2040: A1          and  c
2041: 14          inc  d
2042: C7          rst  $00
2043: 39          add  hl,sp
2044: 0E C2       ld   c,$C2
2046: 8C          adc  a,h
2047: AE          xor  (hl)
2048: E9          jp   (hl)
2049: 9E          sbc  a,(hl)
204A: E8          ret  pe
204B: 76          halt
204C: 2B          dec  hl
204D: 10 28       djnz $2077
204F: A1          and  c
2050: 4C          ld   c,h
2051: 73          ld   (hl),e
2052: 77          ld   (hl),a
2053: 91          sub  c
2054: FE C2       cp   $C2
2056: 63          ld   h,e
2057: B5          or   l
2058: A0          and  b
2059: 23          inc  hl
205A: 9B          sbc  a,e
205B: 49          ld   c,c
205C: 9C          sbc  a,h
205D: 59          ld   e,c
205E: A3          and  e
205F: 4E          ld   c,(hl)
2060: AE          xor  (hl)
2061: AE          xor  (hl)
2062: AD          xor  l
2063: A8          xor  b
2064: 54          ld   d,h
2065: 0E 3D       ld   c,$3D
2067: 6C          ld   l,h
2068: 29          add  hl,hl
2069: 3A 23 9B    ld   a,($9B23)
206C: 5E          ld   e,(hl)
206D: 82          add  a,d
206E: 6E          ld   l,(hl)
206F: 9C          sbc  a,h
2070: 00          nop
2071: 9B          sbc  a,e
2072: D5          push de
2073: 78          ld   a,b
2074: 4B          ld   c,e
2075: 44          ld   b,h
2076: 83          add  a,e
2077: A2          and  d
2078: E6 4C       and  $4C
207A: 44          ld   b,h
207B: E4 C2 C5    call po,$C5C2
207E: D3 1B       out  ($1B),a
2080: CD 09 AE    call $AE09
2083: 87          add  a,a
2084: EA 75 4B    jp   pe,$4B75
2087: 5B          ld   e,e
2088: 46          ld   b,(hl)
2089: 44          ld   b,h
208A: CC BC 9B    call z,$9BBC
208D: A4          and  h
208E: F0          ret  p
208F: 47          ld   b,a
2090: 45          ld   b,l
2091: 4E          ld   c,(hl)
2092: 39          add  hl,sp
2093: E4 13 CD    call po,$CD13
2096: FD 96 52    sub  (iy+$52)
2099: DD E9       jp   (ix)
209B: C6 7D       add  a,$7D
209D: 7C          ld   a,h
209E: C7          rst  $00
209F: 52          ld   d,d
20A0: C2 5D C5    jp   nz,$C55D
20A3: F2 66 26    jp   p,$2666
20A6: 4F          ld   c,a
20A7: 16 24       ld   d,$24
20A9: BA          cp   d
20AA: C8          ret  z
20AB: 66          ld   h,(hl)
20AC: 29          add  hl,hl
20AD: D9          exx
20AE: 0F          rrca
20AF: EA 11 5E    jp   pe,$5E11
20B2: E8          ret  pe
20B3: B2          or   d
20B4: A0          and  b
20B5: 17          rla
20B6: 5E          ld   e,(hl)
20B7: AB          xor  e
20B8: 3B          dec  sp
20B9: 50          ld   d,b
20BA: 5F          ld   e,a
20BB: 10 5D       djnz $211A
20BD: C5          push bc
20BE: B3          or   e
20BF: 8B          adc  a,e
20C0: 15          dec  d
20C1: FD          db   $fd
20C2: 3B          dec  sp
20C3: 5D          ld   e,l
20C4: C3 9C 4A    jp   $4A9C
20C7: DA E9 9E    jp   c,$9EE9
20CA: A3          and  e
20CB: 50          ld   d,b
20CC: 0A          ld   a,(bc)
20CD: FA E9 DB    jp   m,$DBE9
20D0: 00          nop
20D1: 1C          inc  e
20D2: 96          sub  (hl)
20D3: 4A          ld   c,d
20D4: C3 75 38    jp   $3875
20D7: 26 0E       ld   h,$0E
20D9: 98          sbc  a,b
20DA: 60          ld   h,b
20DB: 26 16       ld   h,$16
20DD: 29          add  hl,hl
20DE: 2B          dec  hl
20DF: F9          ld   sp,hl
20E0: 97          sub  a
20E1: 72          ld   (hl),d
20E2: 5D          ld   e,l
20E3: CB E7       set  4,a
20E5: 66          ld   h,(hl)
20E6: 26 AD       ld   h,$AD
20E8: 71          ld   (hl),c
20E9: 4C          ld   c,h
20EA: 7B          ld   a,e
20EB: 26 04       ld   h,$04
20ED: 10 05       djnz $20F4
20EF: 04          inc  b
20F0: 3D          dec  a
20F1: 68          ld   l,b
20F2: 37          scf
20F3: 53          ld   d,e
20F4: 8E          adc  a,(hl)
20F5: 58          ld   e,b
20F6: C2 5D C8    jp   nz,$C85D
20F9: A9          xor  c
20FA: 95          sub  l
20FB: 64          ld   h,h
20FC: A2          and  d
20FD: 02          ld   (bc),a
20FE: B5          or   l
20FF: 39          add  hl,sp
2100: F2 56 75    jp   p,$7556
2103: EA 07 95    jp   pe,$9507
2106: DF          rst  $18
2107: B8          cp   b
2108: 09          add  hl,bc
2109: E4 C9 EB    call po,$EBC9
210C: F5          push af
210D: 2E AE       ld   l,$AE
210F: C4 30 37    call nz,$3730
2112: B4          or   h
2113: C8          ret  z
2114: A3          and  e
2115: C6 40       add  a,$40
2117: 34          inc  (hl)
2118: 2A F5 DC    ld   hl,($DCF5)
211B: 3B          dec  sp
211C: 5F          ld   e,a
211D: 0F          rrca
211E: 17          rla
211F: 79          ld   a,c
2120: AE          xor  (hl)
2121: 87          add  a,a
2122: 86          add  a,(hl)
2123: 11 2A 34    ld   de,$342A
2126: C9          ret
2127: AF          xor  a
2128: B1          or   c
2129: 50          ld   d,b
212A: 5D          ld   e,l
212B: D3 C6       out  ($C6),a
212D: EC 01 14    call pe,$1401
2130: EE 51       xor  $51
2132: 49          ld   c,c
2133: C8          ret  z
2134: 8A          adc  a,d
2135: D6 13       sub  $13
2137: 50          ld   d,b
2138: 5B          ld   e,e
2139: 5B          ld   e,e
213A: 21 02 4D    ld   hl,$4D02
213D: 99          sbc  a,c
213E: AE          xor  (hl)
213F: AE          xor  (hl)
2140: AE          xor  (hl)
2141: AC          xor  h
2142: 24          inc  h
2143: B4          or   h
2144: 62          ld   h,d
2145: 94          sub  h
2146: 0E 3A       ld   c,$3A
2148: DF          rst  $18
2149: 71          ld   (hl),c
214A: 1B          dec  de
214B: 37          scf
214C: 3E 93       ld   a,$93
214E: 58          ld   e,b
214F: A3          and  e
2150: 9A          sbc  a,d
2151: 26 2B       ld   h,$2B
2153: 1B          dec  de
2154: FA 9B 12    jp   m,$129B
2157: 6D          ld   l,l
2158: A5          and  l
2159: 25          dec  h
215A: 5A          ld   e,d
215B: CD 74 73    call $7374
215E: D6 81       sub  $81
2160: 8D          adc  a,l
2161: 5C          ld   e,h
2162: 02          ld   (bc),a
2163: DE 5F       sbc  a,$5F
2165: 71          ld   (hl),c
2166: EE BF       xor  $BF
2168: 75          ld   (hl),l
2169: 86          add  a,(hl)
216A: 5D          ld   e,l
216B: 79          ld   a,c
216C: B5          or   l
216D: E3          ex   (sp),hl
216E: E8          ret  pe
216F: 02          ld   (bc),a
2170: 81          add  a,c
2171: 40          ld   b,b
2172: 8F          adc  a,a
2173: EE 00       xor  $00
2175: 09          add  hl,bc
2176: 2F          cpl
2177: 93          sub  e
2178: 15          dec  d
2179: 2D          dec  l
217A: 8F          adc  a,a
217B: 34          inc  (hl)
217C: C9          ret
217D: DA F3 74    jp   c,$74F3
2180: 00          nop
2181: 28 8D       jr   z,$2110
2183: 74          ld   (hl),h
2184: 26 43       ld   h,$43
2186: 8F          adc  a,a
2187: D8          ret  c
2188: D7          rst  $10
2189: 51          ld   d,c
218A: 8B          adc  a,e
218B: 4B          ld   c,e
218C: 17          rla
218D: 8A          adc  a,d
218E: 24          inc  h
218F: DA 13 89    jp   c,$8913
2192: E8          ret  pe
2193: 63          ld   h,e
2194: C8          ret  z
2195: 99          sbc  a,c
2196: B0          or   b
2197: 0E C7       ld   c,$C7
2199: 5D          ld   e,l
219A: BF          cp   a
219B: D5          push de
219C: 23          inc  hl
219D: A1          and  c
219E: F7          rst  $30
219F: 5D          ld   e,l
21A0: BE          cp   (hl)
21A1: BD          cp   l
21A2: 82          add  a,d
21A3: 4C          ld   c,h
21A4: 4E          ld   c,(hl)
21A5: 88          adc  a,b
21A6: 66          ld   h,(hl)
21A7: 0F          rrca
21A8: 87          add  a,a
21A9: 2A A3 5C    ld   hl,($5CA3)
21AC: 4B          ld   c,e
21AD: D8          ret  c
21AE: 38 89       jr   c,$2139
21B0: EA C3 70    jp   pe,$70C3
21B3: 24          inc  h
21B4: 9B          sbc  a,e
21B5: FB          ei
21B6: 94          sub  h
21B7: DA 86 60    jp   c,$6086
21BA: F5          push af
21BB: 12          ld   (de),a
21BC: FB          ei
21BD: BC          cp   h
21BE: 9B          sbc  a,e
21BF: E6 6B       and  $6B
21C1: A0          and  b
21C2: 62          ld   h,d
21C3: 6B          ld   l,e
21C4: D5          push de
21C5: A4          and  h
21C6: 85          add  a,l
21C7: AF          xor  a
21C8: 87          add  a,a
21C9: 39          add  hl,sp
21CA: 20 26       jr   nz,$21F2
21CC: E7          rst  $20
21CD: 5F          ld   e,a
21CE: CB 1A       rr   d
21D0: D5          push de
21D1: F8          ret  m
21D2: CA 04 C2    jp   z,$C204
21D5: B7          or   a
21D6: BA          cp   d
21D7: 04          inc  b
21D8: A2          and  d
21D9: 83          add  a,e
21DA: 1D          dec  e
21DB: E2 77 0B    jp   po,$0B77
21DE: 2A 00 0A    ld   hl,($0A00)
21E1: FB          ei
21E2: 1B          dec  de
21E3: 71          ld   (hl),c
21E4: 8B          adc  a,e
21E5: 1C          inc  e
21E6: 25          dec  h
21E7: DC 61 65    call c,$6561
21EA: 5E          ld   e,(hl)
21EB: 20 2E       jr   nz,$221B
21ED: 4C          ld   c,h
21EE: A5          and  l
21EF: 4B          ld   c,e
21F0: 1A          ld   a,(de)
21F1: 0E 90       ld   c,$90
21F3: 3B          dec  sp
21F4: 01 70 EA    ld   bc,$EA70
21F7: 0F          rrca
21F8: C5          push bc
21F9: 02          ld   (bc),a
21FA: 40          ld   b,b
21FB: 26 8B       ld   h,$8B
21FD: 3B          dec  sp
21FE: 61          ld   h,c
21FF: 4C          ld   c,h
2200: 73          ld   (hl),e
2201: B1          or   c
2202: 29          add  hl,hl
2203: 60          ld   h,b
2204: FB          ei
2205: 12          ld   (de),a
2206: 6F          ld   l,a
2207: EA FD 9C    jp   pe,$9CFD
220A: 86          add  a,(hl)
220B: 60          ld   h,b
220C: F9          ld   sp,hl
220D: C5          push bc
220E: 0F          rrca
220F: B4          or   h
2210: A2          and  d
2211: 13          inc  de
2212: 48          ld   c,b
2213: 26 D7       ld   h,$D7
2215: 2A B2 3B    ld   hl,($3BB2)
2218: 0C          inc  c
2219: 3E BA       ld   a,$BA
221B: 11 39 C4    ld   de,$C439
221E: AD          xor  l
221F: AE          xor  (hl)
2220: 82          add  a,d
2221: 86          add  a,(hl)
2222: 60          ld   h,b
2223: F6 29       or   $29
2225: 4D          ld   c,l
2226: 58          ld   e,b
2227: 50          ld   d,b
2228: F5          push af
2229: 4E          ld   c,(hl)
222A: A8          xor  b
222B: 47          ld   b,a
222C: 5E          ld   e,(hl)
222D: A5          and  l
222E: FB          ei
222F: 5F          ld   e,a
2230: CA 39 A2    jp   z,$A239
2233: 62          ld   h,d
2234: B1          or   c
2235: AC          xor  h
2236: 73          ld   (hl),e
2237: 7E          ld   a,(hl)
2238: 91          sub  c
2239: D0          ret  nc
223A: 71          ld   (hl),c
223B: D1          pop  de
223C: CE 30       adc  a,$30
223E: DB 32       in   a,($32)
2240: 54          ld   d,h
2241: E8          ret  pe
2242: D6 20       sub  $20
2244: 31 C6 60    ld   sp,$60C6
2247: F1          pop  af
2248: 20 29       jr   nz,$2273
224A: B5          or   l
224B: E4 58 AC    call po,$AC58
224E: 37          scf
224F: 53          ld   d,e
2250: 8C          adc  a,h
2251: 60          ld   h,b
2252: 81          add  a,c
2253: 78          ld   a,b
2254: 03          inc  bc
2255: 7D          ld   a,l
2256: EB          ex   de,hl
2257: 7A          ld   a,d
2258: EA E2 9B    jp   pe,$9BE2
225B: 5E          ld   e,(hl)
225C: 2D          dec  l
225D: EF          rst  $28
225E: CB 41       bit  0,c
2260: 15          dec  d
2261: 3A F4 8D    ld   a,($8DF4)
2264: D9          exx
2265: D9          exx
2266: AE          xor  (hl)
2267: AE          xor  (hl)
2268: 01 4E 1A    ld   bc,$1A4E
226B: 28 8D       jr   z,$21FA
226D: 11 3D 9A    ld   de,$9A3D
2270: E8          ret  pe
2271: 79          ld   a,c
2272: 72          ld   (hl),d
2273: 0F          rrca
2274: C8          ret  z
2275: 89          adc  a,c
2276: 60          ld   h,b
2277: 9A          sbc  a,d
2278: D5          push de
2279: F0          ret  p
227A: 9D          sbc  a,l
227B: 85          add  a,l
227C: 1F          rra
227D: 4B          ld   c,e
227E: D9          exx
227F: 78          ld   a,b
2280: 47          ld   b,a
2281: EB          ex   de,hl
2282: C4 C7 EB    call nz,$EBC7
2285: 73          ld   (hl),e
2286: 31 36 16    ld   sp,$1636
2289: EB          ex   de,hl
228A: B1          or   c
228B: 26 02       ld   h,$02
228D: C0          ret  nz
228E: 00          nop
228F: 1F          rra
2290: B1          or   c
2291: 0D          dec  c
2292: 5E          ld   e,(hl)
2293: A3          and  e
2294: 82          add  a,d
2295: 83          add  a,e
2296: 80          add  a,b
2297: 47          ld   b,a
2298: 3E 93       ld   a,$93
229A: 94          sub  h
229B: E8          ret  pe
229C: 00          nop
229D: 70          ld   (hl),b
229E: 0A          ld   a,(bc)
229F: 83          add  a,e
22A0: E3          ex   (sp),hl
22A1: 6E          ld   l,(hl)
22A2: E1          pop  hl
22A3: C0          ret  nz
22A4: CB CE       set  1,(hl)
22A6: AC          xor  h
22A7: 0B          dec  bc
22A8: 0C          inc  c
22A9: 20 87       jr   nz,$2232
22AB: 0B          dec  bc
22AC: 75          ld   (hl),l
22AD: EA 37 C5    jp   pe,$C537
22B0: 41          ld   b,c
22B1: CD 62 00    call $0062
22B4: E9          jp   (hl)
22B5: 44          ld   b,h
22B6: 59          ld   e,c
22B7: 27          daa
22B8: 99          sbc  a,c
22B9: 0F          rrca
22BA: BB          cp   e
22BB: 95          sub  l
22BC: D7          rst  $10
22BD: 97          sub  a
22BE: AD          xor  l
22BF: 5F          ld   e,a
22C0: 6A          ld   l,d
22C1: 76          halt
22C2: 81          add  a,c
22C3: 65          ld   h,l
22C4: DC 69 3C    call c,$3C69
22C7: 4D          ld   c,l
22C8: AE          xor  (hl)
22C9: 87          add  a,a
22CA: CB 61       bit  4,c
22CC: A4          and  h
22CD: 5A          ld   e,d
22CE: E2 25 4C    jp   po,$4C25
22D1: 75          ld   (hl),l
22D2: 11 90 EA    ld   de,$EA90
22D5: 32 61 83    ld   ($8361),a
22D8: AD          xor  l
22D9: CD 74 20    call $2074
22DC: FB          ei
22DD: 65          ld   h,l
22DE: 66          ld   h,(hl)
22DF: 39          add  hl,sp
22E0: B6          or   (hl)
22E1: B1          or   c
22E2: 23          inc  hl
22E3: 74          ld   (hl),h
22E4: 00          nop
22E5: F0          ret  p
22E6: C0          ret  nz
22E7: AC          xor  h
22E8: 4B          ld   c,e
22E9: EE 5C       xor  $5C
22EB: B3          or   e
22EC: 1F          rra
22ED: F6 15       or   $15
22EF: 60          ld   h,b
22F0: 1B          dec  de
22F1: F0          ret  p
22F2: BC          cp   h
22F3: A0          and  b
22F4: E5          push hl
22F5: 96          sub  (hl)
22F6: 29          add  hl,hl
22F7: 6F          ld   l,a
22F8: D7          rst  $10
22F9: 55          ld   d,l
22FA: EB          ex   de,hl
22FB: 92          sub  d
22FC: 4B          ld   c,e
22FD: FC D6 25    call m,$25D6
2300: 73          ld   (hl),e
2301: E9          jp   (hl)
2302: 47          ld   b,a
2303: 0D          dec  c
2304: 5D          ld   e,l
2305: 7F          ld   a,a
2306: 60          ld   h,b
2307: F6 0F       or   $0F
2309: 5C          ld   e,h
230A: B1          or   c
230B: CC 46 FA    call z,$FA46
230E: 74          ld   (hl),h
230F: C2 E2 F6    jp   nz,$F6E2
2312: 11 BD E0    ld   de,$E0BD
2315: 96          sub  (hl)
2316: 26 A8       ld   h,$A8
2318: 00          nop
2319: A9          xor  c
231A: 3C          inc  a
231B: 41          ld   b,c
231C: B6          or   (hl)
231D: 20 65       jr   nz,$2384
231F: 0E 82       ld   c,$82
2321: 45          ld   b,l
2322: F8          ret  m
2323: AE          xor  (hl)
2324: 00          nop
2325: 6B          ld   l,e
2326: A7          and  a
2327: 69          ld   l,c
2328: 06 AD       ld   b,$AD
232A: A4          and  h
232B: 2D          dec  l
232C: 81          add  a,c
232D: 79          ld   a,c
232E: A8          xor  b
232F: 7A          ld   a,d
2330: 17          rla
2331: AD          xor  l
2332: B0          or   b
2333: 47          ld   b,a
2334: 87          add  a,a
2335: D4 D7 45    call nc,$45D7
2338: 61          ld   h,c
2339: 65          ld   h,l
233A: D0          ret  nc
233B: DC 86 97    call c,$9786
233E: 77          ld   (hl),a
233F: 30 88       jr   nc,$22C9
2341: D4 EA CA    call nc,$CAEA
2344: 66          ld   h,(hl)
2345: 26 4A       ld   h,$4A
2347: DA EF 62    jp   c,$62EF
234A: 5E          ld   e,(hl)
234B: 5B          ld   e,e
234C: 00          nop
234D: EE 99       xor  $99
234F: 90          sub  b
2350: 7A          ld   a,d
2351: A2          and  d
2352: EE C8       xor  $C8
2354: D7          rst  $10
2355: 40          ld   b,b
2356: 9A          sbc  a,d
2357: 2F          cpl
2358: C2 4D 74    jp   nz,$744D
235B: F8          ret  m
235C: EF          rst  $28
235D: B1          or   c
235E: 86          add  a,(hl)
235F: 23          inc  hl
2360: 77          ld   (hl),a
2361: 5C          ld   e,h
2362: 68          ld   l,b
2363: 80          add  a,b
2364: D2 C5 C2    jp   nc,$C2C5
2367: 5D          ld   e,l
2368: CF          rst  $08
2369: AF          xor  a
236A: 71          ld   (hl),c
236B: 2F          cpl
236C: 95          sub  l
236D: D2 62 B1    jp   nc,$B162
2370: E3          ex   (sp),hl
2371: FB          ei
2372: 1E 47       ld   e,$47
2374: E1          pop  hl
2375: 38 73       jr   c,$23EA
2377: 90          sub  b
2378: 75          ld   (hl),l
2379: EE 25       xor  $25
237B: A6          and  (hl)
237C: 0E E0       ld   c,$E0
237E: E2 BF 57    jp   po,$57BF
2381: 16 86       ld   d,$86
2383: D1          pop  de
2384: 13          inc  de
2385: 5A          ld   e,d
2386: 62          ld   h,d
2387: 43          ld   b,e
2388: 7D          ld   a,l
2389: 14          inc  d
238A: 13          inc  de
238B: F8          ret  m
238C: 75          ld   (hl),l
238D: EA 3F 8E    jp   pe,$8E3F
2390: DE 5F       sbc  a,$5F
2392: DD 22 BE 27 ld   ($27BE),ix
2396: AD          xor  l
2397: 5F          ld   e,a
2398: 73          ld   (hl),e
2399: 14          inc  d
239A: 8E          adc  a,(hl)
239B: 11 79 38    ld   de,$3879
239E: EF          rst  $28
239F: 11 B1 74    ld   de,$74B1
23A2: B3          or   e
23A3: 1C          inc  e
23A4: 67          ld   h,a
23A5: 0E C7       ld   c,$C7
23A7: 2F          cpl
23A8: 4F          ld   c,a
23A9: 77          ld   (hl),a
23AA: 6A          ld   l,d
23AB: 06 A2       ld   b,$A2
23AD: AA          xor  d
23AE: D5          push de
23AF: F4 64 FB    call p,$FB64
23B2: C4 83 89    call nz,$8983
23B5: FA 56 E6    jp   m,$E656
23B8: CB 61       bit  4,c
23BA: 8F          adc  a,a
23BB: 06 85       ld   b,$85
23BD: 90          sub  b
23BE: 4A          ld   c,d
23BF: B4          or   h
23C0: C7          rst  $00
23C1: C7          rst  $00
23C2: E7          rst  $20
23C3: 9A          sbc  a,d
23C4: 26 2B       ld   h,$2B
23C6: 12          ld   (de),a
23C7: F9          ld   sp,hl
23C8: FA 70 0F    jp   m,$0F70
23CB: 9F          sbc  a,a
23CC: 81          add  a,c
23CD: 66          ld   h,(hl)
23CE: 5E          ld   e,(hl)
23CF: AA          xor  d
23D0: A6          and  (hl)
23D1: 24          inc  h
23D2: 84          add  a,h
23D3: B8          cp   b
23D4: BF          cp   a
23D5: D6 46       sub  $46
23D7: 64          ld   h,h
23D8: BC          cp   h
23D9: 2C          inc  l
23DA: D8          ret  c
23DB: F7          rst  $30
23DC: 09          add  hl,bc
23DD: 00          nop
23DE: 46          ld   b,(hl)
23DF: 86          add  a,(hl)
23E0: 5D          ld   e,l
23E1: 70          ld   (hl),b
23E2: 9E          sbc  a,(hl)
23E3: 35          dec  (hl)
23E4: 60          ld   h,b
23E5: EE A7       xor  $A7
23E7: 41          ld   b,c
23E8: 6B          ld   l,e
23E9: 5A          ld   e,d
23EA: 0F          rrca
23EB: 5B          ld   e,e
23EC: 03          inc  bc
23ED: C8          ret  z
23EE: 07          rlca
23EF: F7          rst  $30
23F0: DD          db   $dd
23F1: E8          ret  pe
23F2: 72          ld   (hl),d
23F3: 9F          sbc  a,a
23F4: AF          xor  a
23F5: 82          add  a,d
23F6: AF          xor  a
23F7: 8F          adc  a,a
23F8: 14          inc  d
23F9: F0          ret  p
23FA: 8F          adc  a,a
23FB: A3          and  e
23FC: 61          ld   h,c
23FD: E6 A6       and  $A6
23FF: 62          ld   h,d
2400: 69          ld   l,c
2401: 8C          adc  a,h
2402: 4C          ld   c,h
2403: 06 20       ld   b,$20
2405: 48          ld   c,b
2406: 04          inc  b
2407: 23          inc  hl
2408: 29          add  hl,hl
2409: 95          sub  l
240A: 8B          adc  a,e
240B: 90          sub  b
240C: F0          ret  p
240D: E8          ret  pe
240E: 15          dec  d
240F: 5D          ld   e,l
2410: C8          ret  z
2411: 26 4F       ld   h,$4F
2413: 95          sub  l
2414: FA 9A E8    jp   m,$E89A
2417: 7C          ld   a,h
2418: 00          nop
2419: 1F          rra
241A: DF          rst  $18
241B: 73          ld   (hl),e
241C: 1F          rra
241D: 86          add  a,(hl)
241E: 94          sub  h
241F: A1          and  c
2420: 44          ld   b,h
2421: C7          rst  $00
2422: 69          ld   l,c
2423: 01 C2 C0    ld   bc,$C0C2
2426: D2 19 92    jp   nc,$9219
2429: 18 7A       jr   $24A5
242B: 2B          dec  hl
242C: 13          inc  de
242D: 5C          ld   e,h
242E: A4          and  h
242F: 8C          adc  a,h
2430: A6          and  (hl)
2431: 7A          ld   a,d
2432: B1          or   c
2433: 21 C2 96    ld   hl,$96C2
2436: B5          or   l
2437: E3          ex   (sp),hl
2438: 56          ld   d,(hl)
2439: CE 7C       adc  a,$7C
243B: 9F          sbc  a,a
243C: 5C          ld   e,h
243D: E3          ex   (sp),hl
243E: 8E          adc  a,(hl)
243F: EE AE       xor  $AE
2441: D1          pop  de
2442: AB          xor  e
2443: 84          add  a,h
2444: 0E 6D       ld   c,$6D
2446: 6F          ld   l,a
2447: 59          ld   e,c
2448: 6C          ld   l,h
2449: 26 9B       ld   h,$9B
244B: 5E          ld   e,(hl)
244C: B5          or   l
244D: 60          ld   h,b
244E: DF          rst  $18
244F: 40          ld   b,b
2450: CE 05       adc  a,$05
2452: B8          cp   b
2453: 7B          ld   a,e
2454: 47          ld   b,a
2455: B6          or   (hl)
2456: A2          and  d
2457: 1A          ld   a,(de)
2458: 4C          ld   c,h
2459: 47          ld   b,a
245A: E7          rst  $20
245B: C2 F5 D6    jp   nz,$D6F5
245E: 4E          ld   c,(hl)
245F: F1          pop  af
2460: 4C          ld   c,h
2461: AE          xor  (hl)
2462: 87          add  a,a
2463: 1A          ld   a,(de)
2464: A5          and  l
2465: 4B          ld   c,e
2466: 7D          ld   a,l
2467: 49          ld   c,c
2468: 47          ld   b,a
2469: CF          rst  $08
246A: EC 9B D6    call pe,$D69B
246D: F0          ret  p
246E: 7A          ld   a,d
246F: 48          ld   c,b
2470: 8E          adc  a,(hl)
2471: 79          ld   a,c
2472: 08          ex   af,af'
2473: 13          inc  de
2474: F1          pop  af
2475: 3D          dec  a
2476: D9          exx
2477: 72          ld   (hl),d
2478: 10 19       djnz $2493
247A: F6 B0       or   $B0
247C: 70          ld   (hl),b
247D: F7          rst  $30
247E: 92          sub  d
247F: F2 5D C8    jp   p,$C85D
2482: F2 96 26    jp   p,$2696
2485: 6F          ld   l,a
2486: 49          ld   c,c
2487: 24          inc  h
2488: FD          db   $fd
2489: C8          ret  z
248A: 69          ld   l,c
248B: 2C          inc  l
248C: 0D          dec  c
248D: 02          ld   (bc),a
248E: ED          db   $ed
248F: 14          inc  d
2490: 50          ld   d,b
2491: E8          ret  pe
2492: E2 D3 4B    jp   po,$4BD3
2495: 5E          ld   e,(hl)
2496: AE          xor  (hl)
2497: 6E          ld   l,(hl)
2498: 93          sub  e
2499: 5F          ld   e,a
249A: 14          inc  d
249B: 50          ld   d,b
249C: F5          push af
249D: E6 BF       and  $BF
249F: 18 FD       jr   $249E
24A1: 7E          ld   a,(hl)
24A2: 80          add  a,b
24A3: C3 CC 4A    jp   $4ACC
24A6: DA EC C1    jp   c,$C1EC
24A9: E3          ex   (sp),hl
24AA: 80          add  a,b
24AB: 0D          dec  c
24AC: 2A 1C DB    ld   hl,($DB1C)
24AF: 03          inc  bc
24B0: 10 99       djnz $244B
24B2: 4D          ld   c,l
24B3: C3 75 38    jp   $3875
24B6: 49          ld   c,c
24B7: 3E 9B       ld   a,$9B
24B9: 94          sub  h
24BA: 26 36       ld   h,$36
24BC: 29          add  hl,hl
24BD: 5B          ld   e,e
24BE: 29          add  hl,hl
24BF: CA 75 5D    jp   z,$5D75
24C2: CF          rst  $08
24C3: 1A          ld   a,(de)
24C4: 66          ld   h,(hl)
24C5: 26 E1       ld   h,$E1
24C7: 74          ld   (hl),h
24C8: 4C          ld   c,h
24C9: 7E          ld   a,(hl)
24CA: 26 04       ld   h,$04
24CC: 43          ld   b,e
24CD: 08          ex   af,af'
24CE: 04          inc  b
24CF: 6D          ld   l,l
24D0: 6B          ld   l,e
24D1: 67          ld   h,a
24D2: 53          ld   d,e
24D3: 80          add  a,b
24D4: 9B          sbc  a,e
24D5: C2 5D CC    jp   nz,$CC5D
24D8: AC          xor  h
24D9: 98          sbc  a,b
24DA: 94          sub  h
24DB: A4          and  h
24DC: 42          ld   b,d
24DD: E5          push hl
24DE: 69          ld   l,c
24DF: 22 5A 75    ld   ($755A),hl
24E2: EA 3A C8    jp   pe,$C83A
24E5: D3 BC       out  ($BC),a
24E7: 4C          ld   c,h
24E8: 18 C9       jr   $24B3
24EA: 1B          dec  de
24EB: F8          ret  m
24EC: 51          ld   d,c
24ED: A2          and  d
24EE: C4 73 77    call nz,$7773
24F1: E4 CC D6    call po,$D6CC
24F4: 06 73       ld   b,$73
24F6: 64          ld   h,h
24F7: 5A          ld   e,d
24F8: 28 DC       jr   z,$24D6
24FA: 6B          ld   l,e
24FB: 93          sub  e
24FC: 02          ld   (bc),a
24FD: 4A          ld   c,d
24FE: 79          ld   a,c
24FF: AE          xor  (hl)
2500: 87          add  a,a
2501: B6          or   (hl)
2502: 11 5D 64    ld   de,$645D
2505: C9          ret
2506: DF          rst  $18
2507: B1          or   c
2508: 94          sub  h
2509: 51          ld   d,c
250A: 03          inc  bc
250B: F9          ld   sp,hl
250C: EF          rst  $28
250D: 34          inc  (hl)
250E: 44          ld   b,h
250F: 1E 81       ld   e,$81
2511: 7C          ld   a,h
2512: C8          ret  z
2513: 8E          adc  a,(hl)
2514: 09          add  hl,bc
2515: 16 54       ld   d,$54
2517: 5F          ld   e,a
2518: 8B          adc  a,e
2519: 54          ld   d,h
251A: 32 80 D9    ld   ($D980),a
251D: EE AE       xor  $AE
251F: EE EF       xor  $EF
2521: 54          ld   d,h
2522: B4          or   h
2523: 92          sub  d
2524: 97          sub  a
2525: 0E 6A       ld   c,$6A
2527: 02          ld   (bc),a
2528: A4          and  h
2529: 4E          ld   c,(hl)
252A: 3A 3E 96    ld   a,($963E)
252D: 9C          sbc  a,h
252E: A3          and  e
252F: 9A          sbc  a,d
2530: 26 2B       ld   h,$2B
2532: 1E FE       ld   e,$FE
2534: CB 12       rl   d
2536: 60          ld   h,b
2537: A9          xor  c
2538: 25          dec  h
2539: 8D          adc  a,l
253A: ED 74       neg  *
253C: B3          or   e
253D: D6 C5       sub  $C5
253F: 81          add  a,c
2540: 8C          adc  a,h
2541: 25          dec  h
2542: 02          ld   (bc),a
2543: 9F          sbc  a,a
2544: A1          and  c
2545: 11 BF B5    ld   de,$B5BF
2548: C6 5D       add  a,$5D
254A: 7D          ld   a,l
254B: B5          or   l
254C: E7          rst  $20
254D: 18 32       jr   $2581
254F: B4          or   h
2550: 43          ld   b,e
2551: B2          or   d
2552: E1          pop  hl
2553: 40          ld   b,b
2554: 0C          inc  c
2555: 62          ld   h,d
2556: 97          sub  a
2557: 49          ld   c,c
2558: 20 B3       jr   nz,$250D
255A: 64          ld   h,h
255B: C9          ret
255C: 1A          ld   a,(de)
255D: 27          daa
255E: 74          ld   (hl),h
255F: 00          nop
2560: 68          ld   l,b
2561: 8D          adc  a,l
2562: 74          ld   (hl),h
2563: 5A          ld   e,d
2564: 46          ld   b,(hl)
2565: C2 DB 17    jp   nz,$17DB
2568: 84          add  a,h
2569: BF          cp   a
256A: 4F          ld   c,a
256B: 1B          dec  de
256C: BD          cp   l
256D: 27          daa
256E: 1D          dec  e
256F: 53          ld   d,e
2570: B9          cp   c
2571: 18 96       jr   $2509
2573: FB          ei
2574: 99          sbc  a,c
2575: B0          or   b
2576: 0E FA       ld   c,$FA
2578: 9D          sbc  a,l
2579: B2          or   d
257A: D9          exx
257B: 56          ld   d,(hl)
257C: A4          and  h
257D: 1B          dec  de
257E: 9D          sbc  a,l
257F: B1          or   c
2580: B0          or   b
2581: B6          or   (hl)
2582: 4F          ld   c,a
2583: 82          add  a,d
2584: 8B          adc  a,e
2585: 66          ld   h,(hl)
2586: 0F          rrca
2587: BA          cp   d
2588: 2A E3 8F    ld   hl,($8FE3)
258B: 4E          ld   c,(hl)
258C: 08          ex   af,af'
258D: 68          ld   l,b
258E: B9          cp   c
258F: EA C6 73    jp   pe,$73C6
2592: 27          daa
2593: DB 3E       in   a,($3E)
2595: C7          rst  $00
2596: DA B6 60    jp   c,$60B6
2599: F8          ret  m
259A: 12          ld   (de),a
259B: 2E EC       ld   l,$EC
259D: 9B          sbc  a,e
259E: 18 9E       jr   $253E
25A0: D0          ret  nc
25A1: A2          and  d
25A2: 6E          ld   l,(hl)
25A3: 18 A7       jr   $254C
25A5: C9          ret
25A6: DF          rst  $18
25A7: B7          or   a
25A8: 39          add  hl,sp
25A9: 54          ld   d,h
25AA: 26 2A       ld   h,$2A
25AC: 5F          ld   e,a
25AD: CE 1D       adc  a,$1D
25AF: D5          push de
25B0: FB          ei
25B1: FD          db   $fd
25B2: 07          rlca
25B3: C2 EB ED    jp   nz,$EDEB
25B6: 07          rlca
25B7: A6          and  (hl)
25B8: 86          add  a,(hl)
25B9: 50          ld   d,b
25BA: 14          inc  d
25BB: 9A          sbc  a,d
25BC: 0D          dec  c
25BD: 5E          ld   e,(hl)
25BE: 00          nop
25BF: 0D          dec  c
25C0: FB          ei
25C1: 1E A1       ld   e,$A1
25C3: 8E          adc  a,(hl)
25C4: 1F          rra
25C5: 25          dec  h
25C6: DC 91 68    call c,$6891
25C9: 8E          adc  a,(hl)
25CA: 40          ld   b,b
25CB: 50          ld   d,b
25CC: 4C          ld   c,h
25CD: C5          push bc
25CE: 4B          ld   c,e
25CF: 5D          ld   e,l
25D0: 0E 93       ld   c,$93
25D2: 6B          ld   l,e
25D3: 04          inc  b
25D4: A0          and  b
25D5: ED          db   $ed
25D6: 02          ld   (bc),a
25D7: C8          ret  z
25D8: 32 44 26    ld   ($2644),a
25DB: BE          cp   (hl)
25DC: 6F          ld   l,a
25DD: 94          sub  h
25DE: 4C          ld   c,h
25DF: 76          halt
25E0: E4 5C 60    call po,$605C
25E3: FE 15       cp   $15
25E5: 62          ld   h,d
25E6: EA 3D D0    jp   pe,$D03D
25E9: B6          or   (hl)
25EA: 60          ld   h,b
25EB: FD          db   $fd
25EC: F5          push af
25ED: 3F          ccf
25EE: B7          or   a
25EF: A2          and  d
25F0: 46          ld   b,(hl)
25F1: 7A          ld   a,d
25F2: 26 0A       ld   h,$0A
25F4: 2A E5 6B    ld   hl,($6BE5)
25F7: 0F          rrca
25F8: 51          ld   d,c
25F9: EA 11 3C    jp   pe,$3C11
25FC: C4 AD AE    call nz,$AEAD
25FF: B5          or   l
2600: 86          add  a,(hl)
2601: 60          ld   h,b
2602: F9          ld   sp,hl
2603: 29          add  hl,hl
2604: 7D          ld   a,l
2605: 88          adc  a,b
2606: 80          add  a,b
2607: 28 8E       jr   z,$2597
2609: AC          xor  h
260A: 7B          ld   a,e
260B: 5E          ld   e,(hl)
260C: 3E 06       ld   a,$06
260E: 32 00 D3    ld   ($D300),a
2611: AF          xor  a
2612: 32 00 D6    ld   ($D600),a
2615: 32 AB 80    ld   ($80AB),a
2618: CD 9E 26    call init_video_269E
261B: 32 01 D5    ld   ($D501),a
261E: 32 03 D5    ld   ($D503),a
2621: 32 05 D5    ld   ($D505),a
2624: 3E 10       ld   a,$10
2626: 32 06 D5    ld   ($D506),a
2629: 3E 32       ld   a,$32
262B: 32 07 D5    ld   ($D507),a
262E: 3A D8 81    ld   a,($81D8)
2631: B7          or   a
2632: 20 10       jr   nz,$2644
2634: 3E 0D       ld   a,$0D
2636: 32 00 D5    ld   ($D500),a
2639: 3E 16       ld   a,$16
263B: 32 02 D5    ld   ($D502),a
263E: 32 04 D5    ld   ($D504),a
2641: C3 51 26    jp   $2651
2644: 3E FD       ld   a,$FD
2646: 32 00 D5    ld   ($D500),a
2649: 3E F5       ld   a,$F5
264B: 32 02 D5    ld   ($D502),a
264E: 32 04 D5    ld   ($D504),a
2651: 3A D9 81    ld   a,($81D9)
2654: B7          or   a
2655: CA 5C 26    jp   z,$265C
2658: 3D          dec  a
2659: CA 76 26    jp   z,$2676
265C: 21 00 00    ld   hl,$0000
265F: 22 09 D5    ld   ($D509),hl
2662: 11 00 90    ld   de,$9000
2665: 01 30 00    ld   bc,$0030
2668: 3A 04 D4    ld   a,($D404)
266B: 12          ld   (de),a
266C: 13          inc  de
266D: 10 F9       djnz $2668
266F: 0D          dec  c
2670: C2 68 26    jp   nz,$2668
2673: C3 8D 26    jp   $268D
2676: 21 00 30    ld   hl,$3000
2679: 22 09 D5    ld   ($D509),hl
267C: 11 00 90    ld   de,$9000
267F: 01 30 00    ld   bc,$0030
2682: 3A 04 D4    ld   a,($D404)
2685: 12          ld   (de),a
2686: 13          inc  de
2687: 10 F9       djnz $2682
2689: 0D          dec  c
268A: C2 82 26    jp   nz,$2682
268D: 3E 07       ld   a,state_next_life_07
268F: 32 AC 80    ld   (game_state_80AC),a
2692: 3E 01       ld   a,$01
2694: 32 A9 80    ld   ($80A9),a
2697: CD C2 26    call $26C2
269A: CD CF 73    call $73CF
269D: C9          ret

init_video_269E:
269E: 21 00 C4    ld   hl,videoram_layer_1_C400
26A1: 01 0C 00    ld   bc,$000C
26A4: 36 00       ld   (hl),$00
26A6: 23          inc  hl
26A7: 10 FB       djnz $26A4
26A9: 0D          dec  c
26AA: C2 A4 26    jp   nz,$26A4
26AD: 21 00 D1    ld   hl,$D100
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

26C2: 3A A9 80    ld   a,($80A9)
26C5: 3D          dec  a
26C6: 32 AA 80    ld   (timer_8bit_80AA),a
26C9: C9          ret
26CA: 3A D9 81    ld   a,($81D9)
26CD: B7          or   a
26CE: 28 03       jr   z,$26D3
26D0: 3D          dec  a
26D1: 28 28       jr   z,$26FB
26D3: 21 E3 77    ld   hl,$77E3
26D6: 3A 3B 82    ld   a,($823B)
26D9: B7          or   a
26DA: 20 12       jr   nz,$26EE
26DC: 3A 50 82    ld   a,($8250)
26DF: 47          ld   b,a
26E0: 3A 37 82    ld   a,(skill_level_8237)
26E3: 90          sub  b
26E4: E6 03       and  $03
26E6: 0F          rrca
26E7: 0F          rrca
26E8: EB          ex   de,hl
26E9: 26 00       ld   h,$00
26EB: 6F          ld   l,a
26EC: 29          add  hl,hl
26ED: 19          add  hl,de
26EE: 11 00 D2    ld   de,$D200
26F1: 01 80 00    ld   bc,$0080
26F4: ED B0       ldir
26F6: AF          xor  a
26F7: 32 AB 80    ld   ($80AB),a
26FA: C9          ret
26FB: 21 E3 79    ld   hl,$79E3
26FE: 18 EE       jr   $26EE
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
2726: 21 0E 28    ld   hl,$280E
2729: 01 1F 00    ld   bc,$001F
272C: ED B0       ldir
272E: 21 10 82    ld   hl,red_door_position_array_8210
2731: 06 1F       ld   b,$1F
2733: 36 08       ld   (hl),$08
2735: 23          inc  hl
2736: 10 FB       djnz $2733
2738: CD 53 27    call $2753
273B: CD 8B 27    call $278B
273E: C9          ret
273F: CD F5 1D    call $1DF5
2742: 0E A0       ld   c,$A0
2744: 06 06       ld   b,$06
2746: B9          cp   c
2747: DA 4B 27    jp   c,$274B
274A: 91          sub  c
274B: CB 09       rrc  c
274D: 10 F7       djnz $2746
274F: 32 2D 80    ld   ($802D),a
2752: C9          ret
2753: 21 2D 28    ld   hl,$282D
2756: 06 06       ld   b,$06
2758: 0E 01       ld   c,$01
275A: CD D2 27    call $27D2
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
278B: 21 36 28    ld   hl,$2836
278E: 06 08       ld   b,$08
2790: 0E 08       ld   c,$08
2792: CD D2 27    call $27D2
2795: 21 3F 28    ld   hl,$283F
2798: 06 0B       ld   b,$0B
279A: 0E 09       ld   c,$09
279C: CD D2 27    call $27D2
279F: 21 48 28    ld   hl,$2848
27A2: 06 0E       ld   b,$0E
27A4: 0E 0C       ld   c,$0C
27A6: CD D2 27    call $27D2
27A9: 21 51 28    ld   hl,$2851
27AC: 06 11       ld   b,$11
27AE: 0E 0F       ld   c,$0F
27B0: CD D2 27    call $27D2
27B3: 21 5A 28    ld   hl,$285A
27B6: 06 14       ld   b,$14
27B8: 0E 12       ld   c,$12
27BA: CD D2 27    call $27D2
27BD: 21 63 28    ld   hl,$2863
27C0: 06 19       ld   b,$19
27C2: 0E 15       ld   c,$15
27C4: CD D2 27    call $27D2
27C7: 21 6C 28    ld   hl,$286C
27CA: 06 1E       ld   b,$1E
27CC: 0E 1A       ld   c,$1A
27CE: CD D2 27    call $27D2
27D1: C9          ret
27D2: 3A 37 82    ld   a,(skill_level_8237)
27D5: 5F          ld   e,a
27D6: FE 09       cp   $09
27D8: 38 02       jr   c,$27DC
27DA: 1E 08       ld   e,$08
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
27E7: D5          push de
27E8: CD 3E 1E    call $1E3E
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
27FE: CD F5 1D    call $1DF5
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
280E: 00          nop
280F: 81          add  a,c
2810: 81          add  a,c
2811: 81          add  a,c
2812: 81          add  a,c
2813: 81          add  a,c
2814: 81          add  a,c
2815: 00          nop
2816: 7E          ld   a,(hl)
2817: 7E          ld   a,(hl)
2818: 66          ld   h,(hl)
2819: 66          ld   h,(hl)
281A: E6 7E       and  $7E
281C: 7F          ld   a,a
281D: 67          ld   h,a
281E: E6 66       and  $66
2820: 7E          ld   a,(hl)
2821: 66          ld   h,(hl)
2822: 66          ld   h,(hl)
2823: 66          ld   h,(hl)
2824: 66          ld   h,(hl)
2825: 66          ld   h,(hl)
2826: 66          ld   h,(hl)
2827: 66          ld   h,(hl)
2828: 66          ld   h,(hl)
2829: 66          ld   h,(hl)
282A: 66          ld   h,(hl)
282B: 66          ld   h,(hl)
282C: 66          ld   h,(hl)
282D: 00          nop
282E: 01 02 02    ld   bc,$0202
2831: 02          ld   (bc),a
2832: 02          ld   (bc),a
2833: 03          inc  bc
2834: 04          inc  b
2835: 05          dec  b
2836: 00          nop
2837: 00          nop
2838: 00          nop
2839: 01 01 01    ld   bc,$0101
283C: 01 01 01    ld   bc,$0101
283F: 02          ld   (bc),a
2840: 02          ld   (bc),a
2841: 02          ld   (bc),a
2842: 01 01 02    ld   bc,$0201
2845: 01 01 01    ld   bc,$0101
2848: 01 01 01    ld   bc,$0101
284B: 01 01 01    ld   bc,$0101
284E: 01 01 01    ld   bc,$0101
2851: 01 01 01    ld   bc,$0101
2854: 01 01 01    ld   bc,$0101
2857: 01 01 01    ld   bc,$0101
285A: 01 01 01    ld   bc,$0101
285D: 01 01 01    ld   bc,$0101
2860: 01 01 01    ld   bc,$0101
2863: 00          nop
2864: 00          nop
2865: 00          nop
2866: 01 01 01    ld   bc,$0101
2869: 01 01 00    ld   bc,$0001
286C: 00          nop
286D: 00          nop
286E: 00          nop
286F: 00          nop
2870: 01 01 01    ld   bc,$0101
2873: 00          nop
2874: 00          nop
2875: 00          nop
2876: 00          nop
2877: 00          nop
2878: 07          rlca
2879: 00          nop
287A: 07          rlca
287B: 00          nop
287C: 07          rlca
287D: 00          nop
287E: 07          rlca
287F: 00          nop
2880: 07          rlca
2881: 00          nop
2882: 07          rlca
2883: 00          nop
2884: 00          nop
2885: 02          ld   (bc),a
2886: 05          dec  b
2887: 03          inc  bc
2888: 04          inc  b
2889: 02          ld   (bc),a
288A: 05          dec  b
288B: 01 06 00    ld   bc,$0006
288E: 05          dec  b
288F: 02          ld   (bc),a
2890: 04          inc  b
2891: 01 05 02    ld   bc,$0205
2894: 06 01       ld   b,$01
2896: 05          dec  b
2897: 02          ld   (bc),a
2898: 05          dec  b
2899: 03          inc  bc
289A: 04          inc  b
289B: 02          ld   (bc),a
289C: 05          dec  b
289D: 01 06 01    ld   bc,$0106
28A0: 05          dec  b
28A1: 02          ld   (bc),a
28A2: 06 01       ld   b,$01
28A4: 05          dec  b
28A5: 02          ld   (bc),a
28A6: 06 01       ld   b,$01
28A8: 05          dec  b
28A9: 02          ld   (bc),a
28AA: 06 01       ld   b,$01
28AC: 05          dec  b
28AD: 02          ld   (bc),a
28AE: 06 01       ld   b,$01
28B0: 05          dec  b
28B1: 02          ld   (bc),a
28B2: 06 CD       ld   b,$CD
28B4: C0          ret  nz
28B5: 28 CD       jr   z,$2884
28B7: DE 28       sbc  a,$28
28B9: CD 21 29    call $2921
28BC: CD BD 16    call $16BD
28BF: C9          ret
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
28E3: 32 04 80    ld   ($8004),a
28E6: E5          push hl
28E7: 06 1F       ld   b,$1F
28E9: C5          push bc
28EA: 2A 02 80    ld   hl,($8002)
28ED: 44          ld   b,h
28EE: 4D          ld   c,l
28EF: CD 47 02    call $0247
28F2: 2A 06 80    ld   hl,($8006)
28F5: EB          ex   de,hl
28F6: 21 08 80    ld   hl,$8008
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
2914: 21 20 D0    ld   hl,$D020
2917: 06 20       ld   b,$20
2919: 3A 05 80    ld   a,($8005)
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
2940: CD 5F 29    call $295F
2943: CD CF 73    call $73CF
2946: 3A A2 80    ld   a,($80A2)
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
295F: AF          xor  a
2960: 32 AB 80    ld   ($80AB),a
2963: 32 00 D6    ld   ($D600),a
2966: 21 00 C4    ld   hl,videoram_layer_1_C400
2969: 0E 0C       ld   c,$0C
296B: 47          ld   b,a
296C: 77          ld   (hl),a
296D: 23          inc  hl
296E: 10 FC       djnz $296C
2970: 0D          dec  c
2971: 20 F8       jr   nz,$296B
2973: CD 39 58    call $5839
2976: CD C6 57    call $57C6
2979: CD B0 10    call $10B0
297C: CD 8E 29    call $298E
297F: 21 2C 01    ld   hl,$012C
2982: 22 2F 82    ld   ($822F),hl
2985: 3E 09       ld   a,state_insert_coin_09
2987: 32 AC 80    ld   (game_state_80AC),a
298A: CD C2 26    call $26C2
298D: C9          ret
298E: 21 02 2A    ld   hl,table_2A02
2991: 11 89 C5    ld   de,$C589
2994: CD F9 29    call copy_bytes_to_screen_29F9
2997: 3A 50 82    ld   a,($8250)
299A: CB 67       bit  4,a
299C: C0          ret  nz
299D: CB 7F       bit  7,a
299F: 20 25       jr   nz,$29C6
29A1: 21 13 2A    ld   hl,$2A13
29A4: 11 EA C5    ld   de,$C5EA
29A7: CD F9 29    call copy_bytes_to_screen_29F9
29AA: 2A A5 80    ld   hl,($80A5)
29AD: 11 28 C6    ld   de,$C628
29B0: CD D0 29    call $29D0
29B3: 21 22 2A    ld   hl,$2A22
29B6: 11 89 C6    ld   de,$C689
29B9: CD F9 29    call copy_bytes_to_screen_29F9
29BC: 2A A7 80    ld   hl,($80A7)
29BF: 11 C8 C6    ld   de,$C6C8
29C2: CD D0 29    call $29D0
29C5: C9          ret
29C6: 2A A5 80    ld   hl,($80A5)
29C9: 11 28 C6    ld   de,$C628
29CC: CD D0 29    call $29D0
29CF: C9          ret
29D0: 44          ld   b,h
29D1: 4D          ld   c,l
29D2: 79          ld   a,c
29D3: F6 10       or   $10
29D5: 12          ld   (de),a
29D6: 13          inc  de
29D7: 13          inc  de
29D8: 21 32 2A    ld   hl,$2A32
29DB: CD F9 29    call copy_bytes_to_screen_29F9
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
29ED: 21 37 2A    ld   hl,table_2A37
29F0: CD F9 29    call copy_bytes_to_screen_29F9
29F3: 05          dec  b
29F4: C8          ret  z
29F5: 3E 2D       ld   a,$2D
29F7: 12          ld   (de),a
29F8: C9          ret

copy_bytes_to_screen_29F9:
29F9: 7E          ld   a,(hl)
29FA: FE FF       cp   $FF
29FC: C8          ret  z
29FD: 12          ld   (de),a
29FE: 23          inc  hl
29FF: 13          inc  de
2A00: 18 F7       jr   copy_bytes_to_screen_29F9

2A02: 2C          inc  l
2A03: 25          dec  h
2A04: 2D          dec  l
2A05: 1E 1F       ld   e,$1F
2A07: 31 00 00    ld   sp,$0000
2A0A: 00          nop
2A0B: 2E 2F       ld   l,$2F
2A0D: 2C          inc  l
2A0E: 25          dec  h
2A0F: 07          rlca
2A10: 2D          dec  l
2A11: 08          ex   af,af'
2A12: FF          rst  $38
2A13: 1B          dec  de
2A14: 1E 27       ld   e,$27
2A16: 31 00 2E    ld   sp,$2E00
2A19: 2F          cpl
2A1A: 2C          inc  l
2A1B: 25          dec  h
2A1C: 00          nop
2A1D: 2D          dec  l
2A1E: 1B          dec  de
2A1F: 2F          cpl
2A20: 31 FF 1F    ld   sp,$1FFF
2A23: 2C          inc  l
2A24: 28 2B       jr   z,$2A51
2A26: 31 00 2E    ld   sp,$2E00
2A29: 2F          cpl
2A2A: 2C          inc  l
2A2B: 25          dec  h
2A2C: 00          nop
2A2D: 2D          dec  l
2A2E: 1B          dec  de
2A2F: 2F          cpl
2A30: 31 FF 2E    ld   sp,$2EFF
2A33: 2F          cpl
2A34: 2C          inc  l
2A35: 25          dec  h
2A36: FF          rst  $38

table_2A37:
    dc.b  2E 1F
    dc.b  1E 30
    dc.b  2C   
    dc.b  31 FF

2A41: 22 31 82    ld   (timer_16bit_8231),hl
2A44: 3E 04       ld   a,$04
2A46: 32 33 82    ld   ($8233),a
2A49: 3A 37 82    ld   a,(skill_level_8237)
2A4C: CB 3F       srl  a
2A4E: CB 3F       srl  a
2A50: C6 06       add  a,$06
2A52: FE 08       cp   $08
2A54: 38 02       jr   c,$2A58
2A56: 3E 08       ld   a,$08
2A58: 32 4C 83    ld   ($834C),a
2A5B: 3E 46       ld   a,$46
2A5D: 32 ED 82    ld   ($82ED),a
2A60: AF          xor  a
2A61: 32 76 83    ld   ($8376),a
2A64: C9          ret
2A65: CD 75 2A    call $2A75
2A68: CD 9A 2A    call $2A9A
2A6B: CD 20 2C    call $2C20
2A6E: CD 52 2D    call $2D52
2A71: CD AC 2D    call $2DAC
2A74: C9          ret
2A75: 06 0B       ld   b,$0B
2A77: 21 83 83    ld   hl,$8383
2A7A: 11 08 00    ld   de,$0008
2A7D: 36 00       ld   (hl),$00
2A7F: 19          add  hl,de
2A80: 10 FB       djnz $2A7D
2A82: 06 02       ld   b,$02
2A84: CD 35 1E    call $1E35
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
2A9A: CD AA 2A    call $2AAA
2A9D: CD ED 2A    call $2AED
2AA0: CD 10 2B    call $2B10
2AA3: CD 99 0F    call $0F99
2AA6: CD 08 2C    call $2C08
2AA9: C9          ret
2AAA: DD 21 7D 83 ld   ix,$837D
2AAE: 11 D7 2A    ld   de,$2AD7
2AB1: 06 00       ld   b,$00
2AB3: 1A          ld   a,(de)
2AB4: DD 77 03    ld   (ix+character_y_offset_03),a
2AB7: 13          inc  de
2AB8: 1A          ld   a,(de)
2AB9: DD 77 02    ld   (ix+$02),a
2ABC: 13          inc  de
2ABD: 3A 2D 80    ld   a,($802D)
2AC0: 3C          inc  a
2AC1: B8          cp   b
2AC2: C2 C8 2A    jp   nz,$2AC8
2AC5: DD 35 03    dec  (ix+character_y_offset_03)
2AC8: C5          push bc
2AC9: 01 08 00    ld   bc,$0008
2ACC: DD 09       add  ix,bc
2ACE: C1          pop  bc
2ACF: 04          inc  b
2AD0: 78          ld   a,b
2AD1: FE 0B       cp   $0B
2AD3: C2 B3 2A    jp   nz,$2AB3
2AD6: C9          ret
2AD7: 07          rlca
2AD8: 0B          dec  bc
2AD9: 01 06 01    ld   bc,$0106
2ADC: 07          rlca
2ADD: 01 05 01    ld   bc,$0105
2AE0: 07          rlca
2AE1: 01 07 07    ld   bc,$0707
2AE4: 0D          dec  c
2AE5: 0D          dec  c
2AE6: 0F          rrca
2AE7: 0A          ld   a,(bc)
2AE8: 0C          inc  c
2AE9: 0F          rrca
2AEA: 11 13 1F    ld   de,$1F13
2AED: 21 81 83    ld   hl,$8381
2AF0: 11 05 2B    ld   de,$2B05
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
2B05: 11 31 51    ld   de,$5131
2B08: 71          ld   (hl),c
2B09: 91          sub  c
2B0A: B1          or   c
2B0B: D1          pop  de
2B0C: 11 71 71    ld   de,$7171
2B0F: 71          ld   (hl),c
2B10: 21 7D 83    ld   hl,$837D
2B13: 06 0B       ld   b,$0B
2B15: 11 08 00    ld   de,$0008
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
2B2A: CD 3E 1E    call $1E3E
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
2C08: 21 81 80    ld   hl,$8081
2C0B: 06 0B       ld   b,$0B
2C0D: CD F5 1D    call $1DF5
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
2C31: 21 66 2C    ld   hl,$2C66
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
2C66: 6F          ld   l,a
2C67: 02          ld   (bc),a
2C68: 84          add  a,h
2C69: 01 7F 01    ld   bc,handle_main_scrolling_017F
2C6C: 64          ld   h,h
2C6D: 00          nop
2C6E: AF          xor  a
2C6F: 01 64 00    ld   bc,$0064
2C72: 4F          ld   c,a
2C73: 01 64 00    ld   bc,$0064
2C76: AF          xor  a
2C77: 01 64 00    ld   bc,$0064
2C7A: AF          xor  a
2C7B: 01 64 00    ld   bc,$0064
2C7E: CF          rst  $08
2C7F: 02          ld   (bc),a
2C80: 84          add  a,h
2C81: 01 2F 03    ld   bc,$032F
2C84: A4          and  h
2C85: 02          ld   (bc),a
2C86: 9F          sbc  a,a
2C87: 02          ld   (bc),a
2C88: 14          inc  d
2C89: 02          ld   (bc),a
2C8A: 8F          adc  a,a
2C8B: 03          inc  bc
2C8C: 04          inc  b
2C8D: 03          inc  bc
2C8E: 2F          cpl
2C8F: 06 C4       ld   b,$C4
2C91: 03          inc  bc
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
2CC0: DD 75 02    ld   (ix+$02),l
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
2CE6: FD 21 7D 83 ld   iy,$837D
2CEA: 06 0B       ld   b,$0B
2CEC: FD 7E 06    ld   a,(iy+$06)
2CEF: DD 77 0E    ld   (ix+$0e),a
2CF2: 11 15 00    ld   de,$0015
2CF5: DD 19       add  ix,de
2CF7: 11 08 00    ld   de,$0008
2CFA: FD 19       add  iy,de
2CFC: 10 EE       djnz $2CEC
2CFE: C9          ret
2CFF: DD 21 7D 83 ld   ix,$837D
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
2D2E: 11 08 00    ld   de,$0008
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
2D56: FD 21 7D 83 ld   iy,$837D
2D5A: 06 07       ld   b,$07
2D5C: C5          push bc
2D5D: CD 77 2D    call $2D77
2D60: CD 8F 2D    call $2D8F
2D63: C1          pop  bc
2D64: 11 15 00    ld   de,$0015
2D67: DD 19       add  ix,de
2D69: 11 08 00    ld   de,$0008
2D6C: FD 19       add  iy,de
2D6E: 10 EC       djnz $2D5C
2D70: CD 29 5F    call $5F29
2D73: CD 63 61    call $6163
2D76: C9          ret
2D77: FD 7E 01    ld   a,(iy+$01)
2D7A: CD 84 2D    call $2D84
2D7D: DD 75 0F    ld   (ix+$0f),l
2D80: DD 74 10    ld   (ix+$10),h
2D83: C9          ret
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
2D92: CD 84 2D    call $2D84
2D95: DD 74 12    ld   (ix+$12),h
2D98: DD 75 11    ld   (ix+$11),l
2D9B: FD 7E 06    ld   a,(iy+$06)
2D9E: 87          add  a,a
2D9F: FD 86 03    add  a,(iy+$03)
2DA2: CD 84 2D    call $2D84
2DA5: DD 74 14    ld   (ix+$14),h
2DA8: DD 75 13    ld   (ix+$13),l
2DAB: C9          ret
2DAC: DD 21 D5 83 ld   ix,$83D5
2DB0: 06 00       ld   b,$00
2DB2: DD 7E 0D    ld   a,(ix+move_direction_0d)
2DB5: B7          or   a
2DB6: CA E1 2D    jp   z,$2DE1
2DB9: 78          ld   a,b
2DBA: 32 0E 85    ld   ($850E),a
2DBD: DD 4E 09    ld   c,(ix+$09)
2DC0: C5          push bc
2DC1: 21 BC 84    ld   hl,$84BC
2DC4: 22 0F 85    ld   ($850F),hl
2DC7: CD 68 60    call $6068
2DCA: DD 46 0E    ld   b,(ix+$0e)
2DCD: CD AD 60    call $60AD
2DD0: 2A 0F 85    ld   hl,($850F)
2DD3: 36 00       ld   (hl),$00
2DD5: CD 77 61    call $6177
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
2DF1: CD C2 26    call $26C2
2DF4: CD CF 73    call $73CF
2DF7: 3A 0B D4    ld   a,($D40B)
2DFA: E6 C0       and  $C0
2DFC: 28 F6       jr   z,$2DF4
2DFE: FE C0       cp   $C0
2E00: 28 F2       jr   z,$2DF4
2E02: CB 7F       bit  7,a
2E04: 20 15       jr   nz,$2E1B
2E06: 3A 4E 82    ld   a,($824E)
2E09: CB 57       bit  2,a
2E0B: 20 0A       jr   nz,$2E17
2E0D: 3A A2 80    ld   a,($80A2)
2E10: D6 02       sub  $02
2E12: 38 E0       jr   c,$2DF4
2E14: 32 A2 80    ld   ($80A2),a
2E17: CD 85 2E    call $2E85
2E1A: C9          ret
2E1B: 3A 4E 82    ld   a,($824E)
2E1E: CB 57       bit  2,a
2E20: 20 04       jr   nz,$2E26
2E22: 21 A2 80    ld   hl,$80A2
2E25: 35          dec  (hl)
2E26: CD 50 2E    call $2E50
2E29: C9          ret
2E2A: AF          xor  a
2E2B: 32 AB 80    ld   ($80AB),a
2E2E: 32 36 82    ld   ($8236),a
2E31: CD E1 71    call $71E1
2E34: 3E 01       ld   a,$01
2E36: 32 D9 81    ld   ($81D9),a
2E39: CD 0C 26    call $260C
2E3C: 3E 03       ld   a,state_push_start_03
2E3E: 32 AC 80    ld   (game_state_80AC),a
2E41: 3E 01       ld   a,$01
2E43: 32 A9 80    ld   ($80A9),a
2E46: CD 39 58    call $5839
2E49: CD C6 57    call $57C6
2E4C: CD B0 10    call $10B0
2E4F: C9          ret
2E50: CD 98 2E    call $2E98
2E53: DD 2A 48 82 ld   ix,($8248)
2E57: DD 6E 17    ld   l,(ix+$17)
2E5A: DD 66 18    ld   h,(ix+$18)
2E5D: 3A 45 82    ld   a,($8245)
2E60: ED 44       neg
2E62: CC 46 82    call z,$8246
2E65: 3E DD       ld   a,$DD
2E67: DD 21 46 82 ld   ix,$8246
2E6B: DD 77 00    ld   (ix+character_x_00),a
2E6E: DD 21 45 82 ld   ix,$8245
2E72: DD 77 00    ld   (ix+character_x_00),a
2E75: 28 DC       jr   z,$2E53
2E77: 3A A2 80    ld   a,($80A2)
2E7A: 77          ld   (hl),a
2E7B: 3E 01       ld   a,$01
2E7D: 32 35 82    ld   ($8235),a
2E80: AF          xor  a
2E81: 32 36 82    ld   ($8236),a
2E84: C9          ret
2E85: CD 98 2E    call $2E98
2E88: CD 9E 35    call $359E
2E8B: CD 98 2E    call $2E98
2E8E: 3E 02       ld   a,$02
2E90: 32 35 82    ld   ($8235),a
2E93: AF          xor  a
2E94: 32 36 82    ld   ($8236),a
2E97: C9          ret
2E98: 3A 52 82    ld   a,($8252)
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
2EAD: 3A 50 82    ld   a,($8250)
2EB0: E6 03       and  $03
2EB2: 32 37 82    ld   (skill_level_8237),a
2EB5: C9          ret
2EB6: 21 E0 2E    ld   hl,$2EE0
2EB9: 11 4E C5    ld   de,$C54E
2EBC: CD F9 29    call copy_bytes_to_screen_29F9
2EBF: 3A 4E 82    ld   a,($824E)
2EC2: CB 57       bit  2,a
2EC4: 20 10       jr   nz,$2ED6
2EC6: 3A A2 80    ld   a,($80A2)
2EC9: 3D          dec  a
2ECA: 20 0A       jr   nz,$2ED6
2ECC: 21 E5 2E    ld   hl,$2EE5
2ECF: 11 A4 C5    ld   de,$C5A4
2ED2: CD F9 29    call copy_bytes_to_screen_29F9
2ED5: C9          ret
2ED6: 21 FD 2E    ld   hl,$2EFD
2ED9: 11 A4 C5    ld   de,$C5A4
2EDC: CD F9 29    call copy_bytes_to_screen_29F9
2EDF: C9          ret
2EE0: 1A          ld   a,(de)
2EE1: 22 2D 2B    ld   ($2B2D),hl
2EE4: FF          rst  $38
2EE5: 00          nop
2EE6: 00          nop
2EE7: 2F          cpl
2EE8: 25          dec  h
2EE9: 1B          dec  de
2EEA: 1D          dec  e
2EEB: 00          nop
2EEC: 11 00 1A    ld   de,$1A00
2EEF: 1B          dec  de
2EF0: 1C          inc  e
2EF1: 1D          dec  e
2EF2: 1E 1F       ld   e,$1F
2EF4: 00          nop
2EF5: 29          add  hl,hl
2EF6: 22 31 31    ld   ($3131),hl
2EF9: 2F          cpl
2EFA: 25          dec  h
2EFB: 00          nop
2EFC: FF          rst  $38
2EFD: 11 2A 00    ld   de,$002A
2F00: 2F          cpl
2F01: 1F          rra
2F02: 00          nop
2F03: 00          nop
2F04: 12          ld   (de),a
2F05: 2A 1A 1B    ld   hl,($1B1A)
2F08: 1C          inc  e
2F09: 1D          dec  e
2F0A: 1E 1F       ld   e,$1F
2F0C: 00          nop
2F0D: 00          nop
2F0E: 29          add  hl,hl
2F0F: 22 31 31    ld   ($3131),hl
2F12: 2F          cpl
2F13: 25          dec  h
2F14: FF          rst  $38
2F15: AF          xor  a
2F16: 3E 14       ld   a,$14
2F18: C9          ret
2F19: E5          push hl
2F1A: 3E 01       ld   a,$01
2F1C: 21 2A 2E    ld   hl,$2E2A
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
2F36: 44          ld   b,h
2F37: 82          add  a,d
2F38: D5          push de
2F39: 10 21       djnz $2F5C
2F3B: FB          ei
2F3C: 80          add  a,b
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
2F72: CD A9 46    call $46A9
2F75: 06 0A       ld   b,$0A
2F77: 36 FF       ld   (hl),$FF
2F79: 23          inc  hl
2F7A: 10 FB       djnz $2F77
2F7C: 21 9C 2F    ld   hl,$2F9C
2F7F: 11 1A 85    ld   de,player_structure_851A
2F82: 01 0E 00    ld   bc,$000E
2F85: ED B0       ldir
2F87: 06 12       ld   b,$12
2F89: 3E 00       ld   a,$00
2F8B: 32 38 82    ld   ($8238),a
2F8E: 12          ld   (de),a
2F8F: 13          inc  de
2F90: 10 FC       djnz $2F8E
2F92: 3A 2C 80    ld   a,($802C)
2F95: 32 21 85    ld   ($8521),a
2F98: CD AA 2F    call $2FAA
2F9B: C9          ret
2F9C: 67          ld   h,a
2F9D: 6F          ld   l,a
2F9E: 1C          inc  e
2F9F: 06 02       ld   b,$02
2FA1: 00          nop
2FA2: 00          nop
2FA3: 00          nop
2FA4: 00          nop
2FA5: 00          nop
2FA6: 00          nop
2FA7: 01 00 00    ld   bc,$0000
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
2FEE: 32 BA 85    ld   ($85BA),a
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
3010: CD 46 30    call $3046
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
3046: 16 00       ld   d,$00
3048: 3A 20 85    ld   a,($8520)
304B: B7          or   a
304C: 28 21       jr   z,$306F
304E: FE 03       cp   $03
3050: 30 1D       jr   nc,$306F
3052: 3A 23 85    ld   a,($8523)
3055: FE 05       cp   $05
3057: 38 04       jr   c,$305D
3059: FE 07       cp   $07
305B: 20 12       jr   nz,$306F
305D: 3A 22 85    ld   a,($8522)
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
3078: 3E 64       ld   a,$64
307A: 20 01       jr   nz,$307D
307C: 3C          inc  a
307D: CD 56 36    call $3656
3080: C9          ret
3081: DD 21 3A 85 ld   ix,enemy_1_853A
3085: 3E 01       ld   a,$01
3087: 32 BA 85    ld   ($85BA),a
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
30BD: 3A BA 85    ld   a,($85BA)
30C0: 3C          inc  a
30C1: 32 BA 85    ld   ($85BA),a
30C4: FE 05       cp   $05
30C6: C2 99 30    jp   nz,$3099
30C9: C9          ret
30CA: AF          xor  a
30CB: 32 3A 82    ld   (shoot_gun_requested_823A),a
30CE: C9          ret

handle_player_30CF:
30CF: 3A 3B 82    ld   a,($823B)
30D2: B7          or   a
30D3: C2 0C 31    jp   nz,$310C
30D6: 3A 4E 82    ld   a,($824E)
30D9: 07          rlca
30DA: 07          rlca
30DB: E6 01       and  $01
30DD: 47          ld   b,a
30DE: 3A D8 81    ld   a,($81D8)
30E1: A8          xor  b
30E2: 20 05       jr   nz,$30E9
30E4: 3A 08 D4    ld   a,($D408)
30E7: 18 03       jr   $30EC
30E9: 3A 09 D4    ld   a,($D409)
30EC: 2F          cpl
30ED: 47          ld   b,a
30EE: E6 0F       and  $0F
30F0: 4F          ld   c,a
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
* $10: jump, 1 move left, 2 move right
3104: 32 27 85    ld   (player_move_direction_8527),a
3107: 78          ld   a,b
3108: 32 3A 82    ld   (shoot_gun_requested_823A),a
310B: C9          ret
310C: 2A 3C 82    ld   hl,($823C)
310F: 3D          dec  a
3110: 28 0A       jr   z,$311C
3112: 7E          ld   a,(hl)
3113: 23          inc  hl
3114: CB BC       res  7,h
3116: 22 3C 82    ld   ($823C),hl
3119: C3 EC 30    jp   $30EC
311C: 3A 08 D4    ld   a,($D408)
311F: 77          ld   (hl),a
3120: 23          inc  hl
3121: 22 3C 82    ld   ($823C),hl
3124: C3 EC 30    jp   $30EC
3127: 3A 23 85    ld   a,($8523)
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
314B: CD 64 31    call $3164
314E: DD 21 5A 85 ld   ix,enemy_2_855A
3152: CD 64 31    call $3164
3155: DD 21 7A 85 ld   ix,enemy_3_857A
3159: CD 64 31    call $3164
315C: DD 21 9A 85 ld   ix,enemy_4_859A
3160: CD 64 31    call $3164
3163: C9          ret
3164: DD 7E 09    ld   a,(ix+$09)
3167: FE 05       cp   $05
3169: D0          ret  nc
316A: DD 7E 06    ld   a,(ix+$06)
316D: FE 03       cp   $03
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
318F: 3E CB       ld   a,$CB
3191: CD 56 36    call $3656
3194: AF          xor  a
3195: 32 EC 82    ld   ($82EC),a
3198: 3A 3B 82    ld   a,($823B)
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
31A9: C2 65 32    jp   nz,$3265
31AC: C9          ret
31AD: 3E FF       ld   a,$FF
31AF: 32 40 82    ld   (lamp_shot_state_8240),a
31B2: 32 64 81    ld   ($8164),a
31B5: AF          xor  a
31B6: 32 42 82    ld   ($8242),a
31B9: C9          ret

shot_lamp_collision_31BA:
31BA: 3A 40 82    ld   a,(lamp_shot_state_8240)
31BD: 3C          inc  a
31BE: C8          ret  z
31BF: 32 40 82    ld   (lamp_shot_state_8240),a
31C2: 3D          dec  a
31C3: CA E1 31    jp   z,$31E1
31C6: FE 03       cp   $03
31C8: DA 07 32    jp   c,$3207
31CB: CA 14 32    jp   z,$3214
31CE: FE 15       cp   $15
31D0: DA 25 32    jp   c,$3225
31D3: FE 18       cp   $18
31D5: DA 51 32    jp   c,$3251
31D8: CA 65 32    jp   z,$3265
31DB: FE 5A       cp   $5A
31DD: CA 92 32    jp   z,$3292
31E0: C9          ret
31E1: 3E 24       ld   a,$24
31E3: 32 3F 82    ld   ($823F),a
31E6: CD 3A 33    call $333A
31E9: CD 55 33    call $3355
31EC: 21 64 81    ld   hl,$8164
31EF: 36 00       ld   (hl),$00
31F1: 23          inc  hl
31F2: 3A 41 82    ld   a,($8241)
31F5: D6 04       sub  $04
31F7: 77          ld   (hl),a
31F8: 23          inc  hl
31F9: CD 7D 33    call $337D
31FC: 23          inc  hl
31FD: 36 00       ld   (hl),$00
31FF: 23          inc  hl
3200: 36 7F       ld   (hl),$7F
3202: 3E C7       ld   a,$C7
3204: C3 56 36    jp   $3656
3207: CF          rst  $08
3208: 3A 04 80    ld   a,($8004)
320B: 47          ld   b,a
320C: 3A 66 81    ld   a,($8166)
320F: 90          sub  b
3210: 32 66 81    ld   ($8166),a
3213: C9          ret
3214: 21 66 81    ld   hl,$8166
3217: 3A 04 80    ld   a,($8004)
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
3230: 3A 04 80    ld   a,($8004)
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
3243: CD CC 32    call $32CC
3246: 3A 43 82    ld   a,($8243)
3249: B7          or   a
324A: C8          ret  z
324B: 3E 15       ld   a,$15
324D: 32 40 82    ld   (lamp_shot_state_8240),a
3250: C9          ret
3251: 21 66 81    ld   hl,$8166
3254: 3A 04 80    ld   a,($8004)
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
3265: 3E FF       ld   a,$FF
3267: 32 64 81    ld   ($8164),a
326A: 3E 30       ld   a,$30
326C: 32 06 D5    ld   ($D506),a
326F: 3E 22       ld   a,$22
3271: 32 07 D5    ld   ($D507),a
3274: 3E 01       ld   a,$01
3276: 32 42 82    ld   ($8242),a
3279: 3A 3B 82    ld   a,($823B)
327C: B7          or   a
327D: C0          ret  nz
327E: DD E5       push ix
3280: DD 21 2B 86 ld   ix,$862B
3284: DD 7E 17    ld   a,(ix+$17)
3287: A7          and  a
3288: DD E1       pop  ix
328A: C8          ret  z
328B: 3A D6 81    ld   a,($81D6)
328E: 32 32 82    ld   (timer_16bit_msb_8232),a
3291: C9          ret
3292: CD AD 31    call $31AD
3295: 3E 10       ld   a,$10
3297: 32 06 D5    ld   ($D506),a
329A: 3E 32       ld   a,$32
329C: 32 07 D5    ld   ($D507),a
329F: 3A 3B 82    ld   a,($823B)
32A2: B7          or   a
32A3: C0          ret  nz
32A4: FD E5       push iy
32A6: FD 21 8F 85 ld   iy,$858F
32AA: FD 7E 35    ld   a,(iy+$35)
32AD: A7          and  a
32AE: FD E1       pop  iy
32B0: C8          ret  z
32B1: 3A D6 81    ld   a,($81D6)
32B4: 32 32 82    ld   (timer_16bit_msb_8232),a
32B7: AF          xor  a
32B8: DD E5       push ix
32BA: DD 21 A4 85 ld   ix,$85A4
32BE: DD 77 20    ld   (ix+$20),a
32C1: DD 21 44 82 ld   ix,$8244
32C5: DD CB 0A D6 set  2,(ix+$0a)
32C9: DD E1       pop  ix
32CB: C9          ret
32CC: AF          xor  a
32CD: 32 43 82    ld   ($8243),a
32D0: DD 21 3A 85 ld   ix,enemy_1_853A
32D4: CD ED 32    call $32ED
32D7: DD 21 5A 85 ld   ix,enemy_2_855A
32DB: CD ED 32    call $32ED
32DE: DD 21 7A 85 ld   ix,enemy_3_857A
32E2: CD ED 32    call $32ED
32E5: DD 21 9A 85 ld   ix,enemy_4_859A
32E9: CD ED 32    call $32ED
32EC: C9          ret
32ED: DD 7E 09    ld   a,(ix+$09)
32F0: 3C          inc  a
32F1: C8          ret  z
32F2: DD 7E 06    ld   a,(ix+$06)
32F5: B7          or   a
32F6: C0          ret  nz
32F7: 3A 3E 82    ld   a,($823E)
32FA: DD BE 07    cp   (ix+$07)
32FD: C0          ret  nz
32FE: 3A 3F 82    ld   a,($823F)
3301: DD BE 02    cp   (ix+$02)
3304: D0          ret  nc
3305: 3A 41 82    ld   a,($8241)
3308: DD BE 00    cp   (ix+character_x_00)
330B: DA 15 33    jp   c,$3315
330E: DD BE 01    cp   (ix+character_x_right_01)
3311: D0          ret  nc
3312: C3 1B 33    jp   $331B
3315: C6 08       add  a,$08
3317: DD BE 00    cp   (ix+character_x_00)
331A: D8          ret  c
331B: 32 43 82    ld   ($8243),a
331E: DD 7E 09    ld   a,(ix+$09)
3321: FE 05       cp   $05
3323: C8          ret  z
3324: DD 36 09 05 ld   (ix+$09),$05
3328: DD 36 0A 00 ld   (ix+$0a),$00
332C: CD DE 56    call $56DE
332F: 3E CB       ld   a,$CB
3331: CD 56 36    call $3656
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
3346: 3A 41 82    ld   a,($8241)
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
3366: 3A 41 82    ld   a,($8241)
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
3388: CD 6C 1E    call $1E6C
338B: 7D          ld   a,l
338C: E1          pop  hl
338D: 77          ld   (hl),a
338E: C9          ret

bootup_338f:
338F: F3          di
3390: 31 00 88    ld   sp,$8800
3393: ED 56       im   1
3395: 21 00 80    ld   hl,$8000
3398: AF          xor  a
3399: 77          ld   (hl),a
339A: 23          inc  hl
339B: CB 5C       bit  3,h
339D: 28 FA       jr   z,$3399
339F: 32 EA 82    ld   ($82EA),a
33A2: CD 17 34    call $3417
33A5: 21 1E 17    ld   hl,$171E
33A8: 11 C9 81    ld   de,$81C9
33AB: 01 05 00    ld   bc,$0005
33AE: ED B0       ldir
33B0: AF          xor  a
33B1: 32 AB 80    ld   ($80AB),a
33B4: 32 AC 80    ld   (game_state_80AC),a
33B7: 3E FF       ld   a,$FF
33B9: 32 80 80    ld   ($8080),a
33BC: CD 9F 77    call $779F
33BF: 21 F9 34    ld   hl,$34F9
33C2: 01 0A 00    ld   bc,$000A
33C5: FB          ei
33C6: C2 C5 34    jp   nz,$34C5
33C9: CD AC 34    call $34AC
33CC: 32 80 80    ld   ($8080),a
33CF: 32 C6 85    ld   ($85C6),a
33D2: 3A 4E 82    ld   a,($824E)
33D5: CB 57       bit  2,a
33D7: 20 0B       jr   nz,$33E4
33D9: CD 5F 71    call $715F
33DC: 3A A2 80    ld   a,($80A2)
33DF: B7          or   a
33E0: 28 1F       jr   z,$3401
33E2: 18 00       jr   $33E4
33E4: CD 29 35    call $3529
33E7: 3E C0       ld   a,$C0
33E9: 32 0B D5    ld   ($D50B),a
33EC: CD 4D 36    call $364D
33EF: 3A 4E 82    ld   a,($824E)
33F2: CB 57       bit  2,a
33F4: 20 EE       jr   nz,$33E4
33F6: 3A A2 80    ld   a,($80A2)
33F9: B7          or   a
33FA: 20 E8       jr   nz,$33E4
33FC: 32 51 82    ld   ($8251),a
33FF: 18 D1       jr   $33D2
3401: CD 1B 11    call $111B
3404: 3A A2 80    ld   a,($80A2)
3407: B7          or   a
3408: 20 DA       jr   nz,$33E4
340A: 21 51 82    ld   hl,$8251
340D: 34          inc  (hl)
340E: 7E          ld   a,(hl)
340F: FE 03       cp   $03
3411: 38 BF       jr   c,$33D2
3413: 36 00       ld   (hl),$00
3415: 18 BB       jr   $33D2
3417: CD 03 35    call $3503
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
3432: CD B1 0F    call $0FB1
3435: 3E 01       ld   a,$01
3437: 32 35 82    ld   ($8235),a
343A: AF          xor  a
343B: 32 4B 82    ld   ($824B),a
343E: 32 4C 82    ld   ($824C),a
3441: 06 03       ld   b,$03
3443: 3A 50 82    ld   a,($8250)
3446: CB 7F       bit  7,a
3448: 28 02       jr   z,$344C
344A: 06 23       ld   b,$23
344C: 78          ld   a,b
344D: 32 0E D5    ld   ($D50E),a
3450: 32 4D 82    ld   ($824D),a
3453: 3E C0       ld   a,$C0
3455: 32 0B D5    ld   ($D50B),a
3458: CD 4D 36    call $364D
345B: 3A 4E 82    ld   a,($824E)
345E: 0F          rrca
345F: 0F          rrca
3460: 0F          rrca
3461: E6 03       and  $03
3463: C6 02       add  a,$02
3465: 32 52 82    ld   ($8252),a
3468: 3A 4E 82    ld   a,($824E)
346B: E6 03       and  $03
346D: 3C          inc  a
346E: 21 9D 34    ld   hl,$349D
3471: 23          inc  hl
3472: 23          inc  hl
3473: 23          inc  hl
3474: 3D          dec  a
3475: 20 FA       jr   nz,$3471
3477: 11 70 83    ld   de,$8370
347A: 01 03 00    ld   bc,$0003
347D: ED B0       ldir
347F: 3E DD       ld   a,$DD
3481: 32 45 82    ld   ($8245),a
3484: 21 46 82    ld   hl,$8246
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
34A0: 00          nop
34A1: 00          nop
34A2: 01 00 50    ld   bc,$5000
34A5: 01 00 00    ld   bc,$0000
34A8: 02          ld   (bc),a
34A9: 00          nop
34AA: 50          ld   d,b
34AB: 02          ld   (bc),a
34AC: 00          nop
34AD: 06 00       ld   b,$00
34AF: 60          ld   h,b
34B0: 68          ld   l,b
34B1: 7E          ld   a,(hl)
34B2: 80          add  a,b
34B3: 47          ld   b,a
34B4: 23          inc  hl
34B5: 7C          ld   a,h
34B6: EE 80       xor  $80
34B8: 32 0D D5    ld   ($D50D),a
34BB: 20 F4       jr   nz,$34B1
34BD: A8          xor  b
34BE: C8          ret  z
34BF: 21 E2 34    ld   hl,$34E2
34C2: 01 17 00    ld   bc,$0017
34C5: E5          push hl
34C6: C5          push bc
34C7: AF          xor  a
34C8: 32 36 82    ld   ($8236),a
34CB: CD E1 71    call $71E1
34CE: 3E 01       ld   a,$01
34D0: 32 D9 81    ld   ($81D9),a
34D3: CD 0C 26    call $260C
34D6: C1          pop  bc
34D7: E1          pop  hl
34D8: 11 84 C5    ld   de,$C584
34DB: ED B0       ldir
34DD: 32 0D D5    ld   ($D50D),a
34E0: 18 FB       jr   $34DD
34E2: 07          rlca
34E3: 00          nop
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
34FC: 1C          inc  e
34FD: 30 00       jr   nc,$34FF
34FF: 2B          dec  hl
3500: 26 00       ld   h,$00
3502: 08          ex   af,af'
3503: 3A 0A D4    ld   a,($D40A)
3506: 2F          cpl
3507: 32 4E 82    ld   ($824E),a
350A: 21 07 3F    ld   hl,$3F07
350D: 22 0E D4    ld   ($D40E),hl
3510: 3E 0E       ld   a,$0E
3512: 32 0E D4    ld   ($D40E),a
3515: 3A 0F D4    ld   a,($D40F)
3518: 2F          cpl
3519: 32 4F 82    ld   ($824F),a
351C: 3E 0F       ld   a,$0F
351E: 32 0E D4    ld   ($D40E),a
3521: 3A 0F D4    ld   a,($D40F)
3524: 2F          cpl
3525: 32 50 82    ld   ($8250),a
3528: C9          ret
3529: CD EE 2D    call $2DEE
352C: 3E 00       ld   a,$00
352E: 32 3B 82    ld   ($823B),a
3531: 3A 4A 82    ld   a,($824A)
3534: B7          or   a
3535: 20 10       jr   nz,$3547
3537: CD D5 76    call $76D5
353A: CD 70 4D    call $4D70
353D: 3E 01       ld   a,$01
353F: 32 4A 82    ld   ($824A),a
3542: CD 9E 75    call $759E
3545: 18 09       jr   $3550
3547: CD D5 76    call $76D5
354A: CD 3F 36    call $363F
354D: CD 9B 75    call $759B
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
3567: CD 9E 35    call $359E
356A: 18 C5       jr   $3531
356C: AF          xor  a
356D: 32 46 86    ld   ($8646),a
3570: CD C7 76    call $76C7
3573: 3A 35 82    ld   a,($8235)
3576: 3D          dec  a
3577: C8          ret  z
3578: CD 9E 35    call $359E
357B: 3A 34 82    ld   a,(nb_lives_8234)
357E: B7          or   a
357F: F2 31 35    jp   p,$3531
3582: 3A 36 82    ld   a,($8236)
3585: B7          or   a
3586: C4 9E 35    call nz,$359E
3589: 3E 01       ld   a,$01
358B: 32 46 86    ld   ($8646),a
358E: CD C7 76    call $76C7
3591: C9          ret
3592: CD 3E 2A    call $2A3E
3595: CD 00 27    call $2700
3598: CD 65 2A    call $2A65
359B: C3 47 35    jp   $3547
359E: 3A 36 82    ld   a,($8236)
35A1: EE 01       xor  $01
35A3: 32 36 82    ld   ($8236),a
35A6: 21 53 82    ld   hl,$8253
35A9: 11 34 82    ld   de,nb_lives_8234
35AC: CD 13 36    call $3613
35AF: 11 4D 83    ld   de,$834D
35B2: CD 1B 36    call $361B
35B5: 11 4A 82    ld   de,$824A
35B8: CD 13 36    call $3613
35BB: 11 73 83    ld   de,$8373
35BE: CD 13 36    call $3613
35C1: 11 37 82    ld   de,skill_level_8237
35C4: CD 13 36    call $3613
35C7: 11 2C 80    ld   de,$802C
35CA: CD 13 36    call $3613
35CD: 11 31 82    ld   de,timer_16bit_8231
35D0: CD 13 36    call $3613
35D3: CD 13 36    call $3613
35D6: 11 33 82    ld   de,$8233
35D9: CD 13 36    call $3613
35DC: 11 00 80    ld   de,$8000
35DF: CD 13 36    call $3613
35E2: 11 4C 83    ld   de,$834C
35E5: CD 13 36    call $3613
35E8: 11 ED 82    ld   de,$82ED
35EB: CD 13 36    call $3613
35EE: 11 CE 81    ld   de,$81CE
35F1: CD 23 36    call $3623
35F4: 11 2D 80    ld   de,$802D
35F7: CD 13 36    call $3613
35FA: 11 83 83    ld   de,$8383
35FD: CD 2F 36    call $362F
3600: 11 DA 81    ld   de,$81DA
3603: CD 27 36    call $3627
3606: 11 10 82    ld   de,red_door_position_array_8210
3609: CD 2B 36    call $362B
360C: 11 F1 81    ld   de,$81F1
360F: CD 2B 36    call $362B
3612: C9          ret
3613: 1A          ld   a,(de)
3614: 4E          ld   c,(hl)
3615: 77          ld   (hl),a
3616: 79          ld   a,c
3617: 12          ld   (de),a
3618: 23          inc  hl
3619: 13          inc  de
361A: C9          ret
361B: 06 03       ld   b,$03
361D: CD 13 36    call $3613
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
3632: CD 13 36    call $3613
3635: 01 07 00    ld   bc,$0007
3638: EB          ex   de,hl
3639: 09          add  hl,bc
363A: EB          ex   de,hl
363B: C1          pop  bc
363C: 10 F3       djnz $3631
363E: C9          ret
363F: 3A 3B 82    ld   a,($823B)
3642: B7          or   a
3643: C0          ret  nz
3644: CD B7 46    call $46B7
3647: 00          nop
3648: 00          nop
3649: CD D2 64    call $64D2
364C: C9          ret
364D: 3E 80       ld   a,$80
364F: 32 79 87    ld   ($8779),a
3652: CD D2 64    call $64D2
3655: C9          ret
3656: 47          ld   b,a
3657: 3A 3B 82    ld   a,($823B)
365A: B7          or   a
365B: C0          ret  nz
365C: 78          ld   a,b
365D: 32 0B D5    ld   ($D50B),a
3660: C9          ret
3661: DD 7E 06    ld   a,(ix+$06)
3664: B7          or   a
3665: C2 6B 36    jp   nz,$366B
3668: C3 C5 46    jp   $46C5
366B: CD CE 62    call $62CE
366E: FD 46 01    ld   b,(iy+$01)
3671: DD 7E 03    ld   a,(ix+character_y_offset_03)
3674: FD 86 00    add  a,(iy+$00)
3677: FE 30       cp   $30
3679: 30 01       jr   nc,$367C
367B: 05          dec  b
367C: 78          ld   a,b
367D: DD 86 06    add  a,(ix+$06)
3680: 47          ld   b,a
3681: DD 7E 08    ld   a,(ix+$08)
3684: E6 80       and  $80
3686: 28 02       jr   z,$368A
3688: 05          dec  b
3689: 05          dec  b
368A: DD 70 07    ld   (ix+$07),b
368D: CD E9 37    call $37E9
3690: DD 7E 09    ld   a,(ix+$09)
3693: FE 05       cp   $05
3695: C8          ret  z
3696: DD 46 00    ld   b,(ix+character_x_00)
3699: DD 4E 01    ld   c,(ix+character_x_right_01)
369C: FD 56 04    ld   d,(iy+character_state_04)
369F: FD 5E 05    ld   e,(iy+$05)
36A2: 7B          ld   a,e
36A3: 91          sub  c
36A4: 67          ld   h,a
36A5: DA DA 36    jp   c,$36DA
36A8: 78          ld   a,b
36A9: 92          sub  d
36AA: 67          ld   h,a
36AB: DA 1A 37    jp   c,$371A
36AE: DD 7E 06    ld   a,(ix+$06)
36B1: 3D          dec  a
36B2: C8          ret  z
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
36F3: DD 46 02    ld   b,(ix+$02)
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
3733: DD 46 02    ld   b,(ix+$02)
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
37C1: DD 77 02    ld   (ix+$02),a
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
37DF: DD 86 02    add  a,(ix+$02)
37E2: DD 77 02    ld   (ix+$02),a
37E5: DD 71 03    ld   (ix+character_y_offset_03),c
37E8: C9          ret
37E9: DD 7E 06    ld   a,(ix+$06)
37EC: 3D          dec  a
37ED: C8          ret  z
37EE: DD 7E 08    ld   a,(ix+$08)
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
3806: DD 36 09 06 ld   (ix+$09),$06
380A: DD 36 0A 00 ld   (ix+$0a),$00
380E: 3A BA 85    ld   a,($85BA)
3811: B7          or   a
3812: 28 16       jr   z,$382A
3814: 3E 02       ld   a,$02
3816: 32 EC 82    ld   ($82EC),a
3819: 3A 20 85    ld   a,($8520)
381C: 3D          dec  a
381D: C0          ret  nz
381E: 3A 22 85    ld   a,($8522)
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
3842: 3A BA 85    ld   a,($85BA)
3845: B7          or   a
3846: C2 4B 38    jp   nz,$384B
3849: 0E 28       ld   c,$28
384B: 78          ld   a,b
384C: B9          cp   c
384D: DA 84 38    jp   c,$3884
3850: 47          ld   b,a
3851: 3A BA 85    ld   a,($85BA)
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
38AC: DD 7E 06    ld   a,(ix+$06)
38AF: B7          or   a
38B0: C2 B7 38    jp   nz,$38B7
38B3: CD B4 39    call $39B4
38B6: C9          ret
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
38EB: CD 00 39    call $3900
38EE: 19          add  hl,de
38EF: DD 7E 0C    ld   a,(ix+$0c)
38F2: FE 0D       cp   $0D
38F4: 28 05       jr   z,$38FB
38F6: 7E          ld   a,(hl)
38F7: DD 77 0C    ld   (ix+$0c),a
38FA: C9          ret
38FB: DD 36 04 FF ld   (ix+$04),$FF
38FF: C9          ret
3900: 3A BA 85    ld   a,($85BA)
3903: B7          or   a
3904: 20 0D       jr   nz,$3913
3906: 11 20 39    ld   de,$3920
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
3920: 04          inc  b
3921: 03          inc  bc
3922: 05          dec  b
3923: 0A          ld   a,(bc)
3924: 0A          ld   a,(bc)
3925: 05          dec  b
3926: 0A          ld   a,(bc)
3927: 05          dec  b
3928: 0A          ld   a,(bc)
3929: 0D          dec  c
392A: 0D          dec  c
392B: 0D          dec  c
392C: 04          inc  b
392D: 03          inc  bc
392E: 05          dec  b
392F: 0A          ld   a,(bc)
3930: 0D          dec  c
3931: 0D          dec  c
3932: 0D          dec  c
3933: 0D          dec  c
3934: 04          inc  b
3935: 0B          dec  bc
3936: 0B          dec  bc
3937: 0B          dec  bc
3938: 0C          inc  c
3939: 0C          inc  c
393A: 0C          inc  c
393B: 0C          inc  c
393C: 0D          dec  c
393D: 0D          dec  c
393E: 0D          dec  c
393F: 0D          dec  c
3940: 04          inc  b
3941: 0B          dec  bc
3942: 0B          dec  bc
3943: 0C          inc  c
3944: 0D          dec  c
3945: 0D          dec  c
3946: 0D          dec  c
3947: 0D          dec  c
3948: DD 7E 04    ld   a,(ix+$04)
394B: 3C          inc  a
394C: C8          ret  z
394D: DD 7E 06    ld   a,(ix+$06)
3950: B7          or   a
3951: CA 7F 39    jp   z,$397F
3954: FE 02       cp   $02
3956: C0          ret  nz
3957: DD 7E 08    ld   a,(ix+$08)
395A: E6 80       and  $80
395C: C0          ret  nz
395D: CD CE 62    call $62CE
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
397F: DD 7E 08    ld   a,(ix+$08)
3982: FE 0C       cp   $0C
3984: C8          ret  z
3985: CD CE 62    call $62CE
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
3A08: CD CE 62    call $62CE
3A0B: FD 7E 03    ld   a,(iy+$03)
3A0E: DD BE 07    cp   (ix+$07)
3A11: C8          ret  z
3A12: DD 36 09 00 ld   (ix+$09),$00
3A16: DD 36 0A 00 ld   (ix+$0a),$00
3A1A: DD 36 06 03 ld   (ix+$06),$03
3A1E: C9          ret
3A1F: DD 77 08    ld   (ix+$08),a
3A22: CD CE 62    call $62CE
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
3A85: DD 36 06 03 ld   (ix+$06),$03
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
3AB9: CD CE 62    call $62CE
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
3AE1: 3A BA 85    ld   a,($85BA)
3AE4: B7          or   a
3AE5: 28 10       jr   z,$3AF7
3AE7: 3A EC 82    ld   a,($82EC)
3AEA: B7          or   a
3AEB: C8          ret  z
3AEC: 3D          dec  a
3AED: 32 EC 82    ld   ($82EC),a
3AF0: C8          ret  z
3AF1: 3E C9       ld   a,$C9
3AF3: CD 56 36    call $3656
3AF6: C9          ret
3AF7: 3A EB 82    ld   a,($82EB)
3AFA: B7          or   a
3AFB: C8          ret  z
3AFC: 3D          dec  a
3AFD: 32 EB 82    ld   ($82EB),a
3B00: C8          ret  z
3B01: 3E C5       ld   a,$C5
3B03: CD 56 36    call $3656
3B06: C9          ret
3B07: 3A BA 85    ld   a,($85BA)
3B0A: B7          or   a
3B0B: 28 0F       jr   z,$3B1C
3B0D: 3A EC 82    ld   a,($82EC)
3B10: B7          or   a
3B11: C0          ret  nz
3B12: 3C          inc  a
3B13: 32 EC 82    ld   ($82EC),a
3B16: 3E C9       ld   a,$C9
3B18: CD 56 36    call $3656
3B1B: C9          ret
3B1C: 3A EB 82    ld   a,($82EB)
3B1F: B7          or   a
3B20: C0          ret  nz
3B21: 3C          inc  a
3B22: 32 EB 82    ld   ($82EB),a
3B25: 3E C5       ld   a,$C5
3B27: CD 56 36    call $3656
3B2A: C9          ret
3B2B: CD 9A 3B    call $3B9A
3B2E: DD 34 0A    inc  (ix+$0a)
3B31: CD A7 3B    call $3BA7
3B34: CD BB 3B    call $3BBB
3B37: CD CE 62    call $62CE
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
3B5C: DD 36 06 02 ld   (ix+$06),$02
3B60: 18 11       jr   $3B73
3B62: DD 7E 07    ld   a,(ix+$07)
3B65: FD BE 03    cp   (iy+$03)
3B68: C0          ret  nz
3B69: DD 7E 03    ld   a,(ix+character_y_offset_03)
3B6C: FE 06       cp   $06
3B6E: D0          ret  nc
3B6F: DD 36 06 00 ld   (ix+$06),$00
3B73: DD 36 03 06 ld   (ix+character_y_offset_03),$06
3B77: DD 36 02 15 ld   (ix+$02),$15
3B7B: DD 36 09 05 ld   (ix+$09),$05
3B7F: DD 36 0A 00 ld   (ix+$0a),$00
3B83: 3A BA 85    ld   a,($85BA)
3B86: B7          or   a
3B87: 28 06       jr   z,$3B8F
3B89: 3E 01       ld   a,$01
3B8B: 32 EC 82    ld   ($82EC),a
3B8E: C9          ret
3B8F: 3E 01       ld   a,$01
3B91: 32 EB 82    ld   ($82EB),a
3B94: 3E C4       ld   a,$C4
3B96: CD 56 36    call $3656
3B99: C9          ret
3B9A: 3A BA 85    ld   a,($85BA)
3B9D: DD B6 0A    or   (ix+$0a)
3BA0: C0          ret  nz
3BA1: 3E C3       ld   a,$C3
3BA3: CD 56 36    call $3656
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
3BE1: 3A BA 85    ld   a,($85BA)
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
3C18: DD 36 06 05 ld   (ix+$06),$05
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
3C6E: C3 A3 3C    jp   $3CA3
3C71: DD 36 04 00 ld   (ix+$04),$00
3C75: 06 12       ld   b,$12
3C77: 3A BA 85    ld   a,($85BA)
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
3C92: 3A BA 85    ld   a,($85BA)
3C95: B7          or   a
3C96: C8          ret  z
3C97: DD 36 09 FF ld   (ix+$09),$FF
3C9B: 3A 75 83    ld   a,($8375)
3C9E: DD 77 10    ld   (ix+$10),a
3CA1: C9          ret
3CA2: C9          ret
3CA3: DD 36 04 02 ld   (ix+$04),$02
3CA7: DD 36 06 00 ld   (ix+$06),$00
3CAB: DD 36 02 1D ld   (ix+$02),$1D
3CAF: DD 36 03 06 ld   (ix+character_y_offset_03),$06
3CB3: DD 36 09 00 ld   (ix+$09),$00
3CB7: DD 36 0C 00 ld   (ix+$0c),$00
3CBB: DD 36 05 00 ld   (ix+character_delta_x_05),$00
3CBF: 3A BA 85    ld   a,($85BA)
3CC2: B7          or   a
3CC3: C0          ret  nz
3CC4: DD 5E 07    ld   e,(ix+$07)
3CC7: 16 00       ld   d,$00
3CC9: 21 10 82    ld   hl,red_door_position_array_8210
3CCC: 19          add  hl,de
3CCD: 36 08       ld   (hl),$08
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
3D14: CD 6A 3D    call $3D6A
3D17: C2 65 3D    jp   nz,$3D65
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
3D5A: 3A BA 85    ld   a,($85BA)
3D5D: B7          or   a
3D5E: C0          ret  nz
3D5F: 3E 37       ld   a,$37
3D61: CD 56 36    call $3656
3D64: C9          ret
3D65: DD 36 06 00 ld   (ix+$06),$00
3D69: C9          ret
3D6A: FD 21 AD 80 ld   iy,$80AD
3D6E: CD AD 3D    call $3DAD
3D71: CA A9 3D    jp   z,$3DA9
3D74: FD 21 B5 80 ld   iy,$80B5
3D78: CD AD 3D    call $3DAD
3D7B: CA A9 3D    jp   z,$3DA9
3D7E: FD 21 AD 80 ld   iy,$80AD
3D82: FD 7E 05    ld   a,(iy+$05)
3D85: 3C          inc  a
3D86: CA 92 3D    jp   z,$3D92
3D89: FD 21 B5 80 ld   iy,$80B5
3D8D: FD 7E 05    ld   a,(iy+$05)
3D90: 3C          inc  a
3D91: C0          ret  nz
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
3DF1: CD 6A 3D    call $3D6A
3DF4: C2 5B 3E    jp   nz,$3E5B
3DF7: 3A BA 85    ld   a,($85BA)
3DFA: B7          or   a
3DFB: 20 0A       jr   nz,$3E07
3DFD: FD 36 06 02 ld   (iy+$06),$02
3E01: DD 36 13 30 ld   (ix+$13),$30
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
3E5F: DD 36 06 05 ld   (ix+$06),$05
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
3EE0: CD 6C 1E    call $1E6C
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
3F0A: CD 6C 1E    call $1E6C
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
3F1E: 3A BA 85    ld   a,($85BA)
3F21: B7          or   a
3F22: C0          ret  nz
3F23: DD 7E 0A    ld   a,(ix+$0a)
3F26: 3D          dec  a
3F27: C0          ret  nz
3F28: 3E 62       ld   a,$62
3F2A: CD 56 36    call $3656
3F2D: C9          ret
3F2E: DD 36 00 29 ld   (ix+character_x_00),$29
3F32: DD 36 0C 07 ld   (ix+$0c),$07
3F36: DD 46 07    ld   b,(ix+$07)
3F39: 0E 00       ld   c,$00
3F3B: 16 30       ld   d,$30
3F3D: CD 6C 1E    call $1E6C
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
3F5D: CD 6C 1E    call $1E6C
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
3F7D: 3A 04 80    ld   a,($8004)
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
3F95: 3A 04 80    ld   a,($8004)
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
3FBA: 3A 04 80    ld   a,($8004)
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
3FD9: 3A 04 80    ld   a,($8004)
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
3FF2: 3A 04 80    ld   a,($8004)
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
4065: DD 36 06 00 ld   (ix+$06),$00
4069: 3A BA 85    ld   a,($85BA)
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
4095: CD 56 36    call $3656
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
4104: CD 6C 1E    call $1E6C
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
4131: CD 6C 1E    call $1E6C
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
4145: 3A BA 85    ld   a,($85BA)
4148: B7          or   a
4149: C0          ret  nz
414A: 3E 63       ld   a,$63
414C: CD 56 36    call $3656
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
41B9: 3A 04 80    ld   a,($8004)
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
41D8: 3A 04 80    ld   a,($8004)
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
41F3: 3A 04 80    ld   a,($8004)
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
420B: 3A 04 80    ld   a,($8004)
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
4266: 21 48 86    ld   hl,$8648
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
42C9: 11 E2 42    ld   de,$42E2
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
42E2: 07          rlca
42E3: 15          dec  d
42E4: 03          inc  bc
42E5: 00          nop
42E6: 05          dec  b
42E7: 15          dec  d
42E8: 03          inc  bc
42E9: 01 07 0F    ld   bc,$0F07
42EC: 05          dec  b
42ED: 02          ld   (bc),a
42EE: 03          inc  bc
42EF: 0F          rrca
42F0: 05          dec  b
42F1: 03          inc  bc
42F2: 02          ld   (bc),a
42F3: 0F          rrca
42F4: 05          dec  b
42F5: 04          inc  b
42F6: 01 0F 05    ld   bc,$050F
42F9: 05          dec  b
42FA: 00          nop
42FB: 0F          rrca
42FC: 05          dec  b
42FD: 06 FF       ld   b,$FF
42FF: 0F          rrca
4300: 05          dec  b
4301: 07          rlca
4302: FE 0F       cp   $0F
4304: 05          dec  b
4305: 08          ex   af,af'
4306: FD          db   $fd
4307: 0F          rrca
4308: 05          dec  b
4309: 09          add  hl,bc
430A: FC 0F 05    call m,$050F
430D: 0A          ld   a,(bc)
430E: FB          ei
430F: 0F          rrca
4310: 05          dec  b
4311: 0B          dec  bc
4312: F9          ld   sp,hl
4313: 15          dec  d
4314: 03          inc  bc
4315: 0C          inc  c
4316: F9          ld   sp,hl
4317: 15          dec  d
4318: 03          inc  bc
4319: 0D          dec  c
431A: F9          ld   sp,hl
431B: 15          dec  d
431C: 03          inc  bc
431D: 0E F9       ld   c,$F9
431F: 15          dec  d
4320: 03          inc  bc
4321: 0F          rrca
4322: F9          ld   sp,hl
4323: 15          dec  d
4324: 03          inc  bc
4325: 10 F9       djnz $4320
4327: 15          dec  d
4328: 03          inc  bc
4329: 11 DD 7E    ld   de,$7EDD
432C: 09          add  hl,bc
432D: B7          or   a
432E: F8          ret  m
432F: FE 05       cp   $05
4331: DA 3C 43    jp   c,$433C
4334: FE 07       cp   $07
4336: DA 30 38    jp   c,$3830
4339: C3 51 42    jp   $4251
433C: DD 7E 06    ld   a,(ix+$06)
433F: FE 03       cp   $03
4341: DA 4F 43    jp   c,$434F
4344: CA 2B 3B    jp   z,$3B2B
4347: FE 05       cp   $05
4349: DA 64 3E    jp   c,$3E64
434C: C3 3E 3C    jp   $3C3E
434F: CD 59 43    call $4359
4352: CD 61 36    call $3661
4355: CD 58 45    call $4558
4358: C9          ret
4359: DD 7E 09    ld   a,(ix+$09)
435C: FE 01       cp   $01
435E: CA 8C 43    jp   z,$438C
4361: DA 2A 44    jp   c,$442A
4364: FE 03       cp   $03
4366: CA 6E 44    jp   z,$446E
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
43F5: 3A BA 85    ld   a,($85BA)
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
4416: 3E 33       ld   a,$33
4418: CD 56 36    call $3656
441B: C9          ret
441C: F5          push af
441D: 3A BA 85    ld   a,($85BA)
4420: B7          or   a
4421: 20 05       jr   nz,$4428
4423: 3E 66       ld   a,$66
4425: CD 56 36    call $3656
4428: F1          pop  af
4429: C9          ret
442A: CD B4 45    call $45B4
442D: DD 7E 0D    ld   a,(ix+move_direction_0d)		; read character direction
4430: CB 67       bit  4,a
4432: C2 F5 43    jp   nz,is_jumping_43F5
4435: 0F          rrca
4436: DA 50 44    jp   c,$4450
4439: 0F          rrca
443A: DA 5F 44    jp   c,$445F
443D: 0F          rrca
443E: D0          ret  nc
443F: DD 36 02 14 ld   (ix+$02),$14
4443: DD 36 03 06 ld   (ix+character_y_offset_03),$06
4447: DD 36 09 02 ld   (ix+$09),$02
444B: DD 36 0C 02 ld   (ix+$0c),$02
444F: C9          ret
4450: DD 36 05 FE ld   (ix+character_delta_x_05),$FE
4454: DD 36 09 01 ld   (ix+$09),$01
4458: DD 36 0A 00 ld   (ix+$0a),$00
445C: C3 B2 43    jp   $43B2
445F: DD 36 05 02 ld   (ix+character_delta_x_05),$02
4463: DD 36 09 01 ld   (ix+$09),$01
4467: DD 36 0A 00 ld   (ix+$0a),$00
446B: C3 E7 43    jp   $43E7
446E: DD 7E 0D    ld   a,(ix+move_direction_0d)
4471: E6 03       and  $03
4473: CA 82 44    jp   z,$4482
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
44A5: 11 D8 44    ld   de,$44D8
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
44D4: CD 56 36    call $3656
44D7: C9          ret
44D8: 22 0D 03    ld   ($030D),hl
44DB: 00          nop
44DC: 27          daa
44DD: 12          ld   (de),a
44DE: 03          inc  bc
44DF: 01 28 19    ld   bc,$1928
44E2: 05          dec  b
44E3: 02          ld   (bc),a
44E4: 2B          dec  hl
44E5: 1C          inc  e
44E6: 05          dec  b
44E7: 03          inc  bc
44E8: 2D          dec  l
44E9: 1E 05       ld   e,$05
44EB: 04          inc  b
44EC: 2E 1F       ld   l,$1F
44EE: 05          dec  b
44EF: 05          dec  b
44F0: 2E 1F       ld   l,$1F
44F2: 05          dec  b
44F3: 06 2D       ld   b,$2D
44F5: 1E 05       ld   e,$05
44F7: 07          rlca
44F8: 2B          dec  hl
44F9: 1C          inc  e
44FA: 05          dec  b
44FB: 08          ex   af,af'
44FC: 28 19       jr   z,$4517
44FE: 05          dec  b
44FF: 09          add  hl,bc
4500: 24          inc  h
4501: 15          dec  d
4502: 05          dec  b
4503: 0A          ld   a,(bc)
4504: 22 0D 03    ld   ($030D),hl
4507: 0B          dec  bc
4508: 21 0A 00    ld   hl,$000A
450B: 0C          inc  c
450C: 1F          rra
450D: 08          ex   af,af'
450E: 01 0D DD    ld   bc,$DD0D
4511: 7E          ld   a,(hl)
4512: 0D          dec  c
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
4533: DD 7E 06    ld   a,(ix+$06)
4536: FE 02       cp   $02
4538: C8          ret  z
4539: 3A BA 85    ld   a,($85BA)
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
455E: 06 02       ld   b,$02
4560: 3A BA 85    ld   a,($85BA)
4563: B7          or   a
4564: 28 37       jr   z,$459D
4566: 2A BD 85    ld   hl,($85BD)
4569: 7E          ld   a,(hl)
456A: 3C          inc  a
456B: C0          ret  nz
456C: DD 7E 06    ld   a,(ix+$06)
456F: FE 03       cp   $03
4571: D0          ret  nc
4572: DD 7E 09    ld   a,(ix+$09)
4575: FE 07       cp   $07
4577: 28 03       jr   z,$457C
4579: FE 05       cp   $05
457B: D0          ret  nc
457C: 21 FF 82    ld   hl,$82FF
457F: 3A BA 85    ld   a,($85BA)
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
4598: 3A BA 85    ld   a,($85BA)
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
45B4: DD 7E 06    ld   a,(ix+$06)
45B7: 3D          dec  a
45B8: C0          ret  nz
45B9: 3A BA 85    ld   a,($85BA)
45BC: C3 74 46    jp   $4674
45BF: 3A 21 85    ld   a,($8521)
45C2: FE 07       cp   $07
45C4: D8          ret  c
45C5: DD 7E 0D    ld   a,(ix+move_direction_0d)
45C8: 47          ld   b,a
45C9: E6 F3       and  $F3
45CB: DD 77 0D    ld   (ix+move_direction_0d),a
45CE: CB 58       bit  3,b
45D0: 20 0B       jr   nz,$45DD
45D2: CB 50       bit  2,b
45D4: C8          ret  z
45D5: CD CE 62    call $62CE
45D8: FD 36 07 FE ld   (iy+$07),$FE
45DC: C9          ret
45DD: CD CE 62    call $62CE
45E0: FD 36 07 02 ld   (iy+$07),$02
45E4: C9          ret

ground_floor_reached_45E5:
45E5: 3E 06       ld   a,state_ground_floor_reached_06
45E7: 32 AC 80    ld   (game_state_80AC),a
45EA: 21 81 80    ld   hl,$8081
45ED: 3A 2D 80    ld   a,($802D)
45F0: 3C          inc  a
45F1: 87          add  a,a
45F2: 5F          ld   e,a
45F3: 16 00       ld   d,$00
45F5: 19          add  hl,de
45F6: 36 FE       ld   (hl),$FE
45F8: DD 21 1A 85 ld   ix,player_structure_851A
45FC: DD 36 0D 00 ld   (ix+move_direction_0d),$00
4600: CD CE 62    call $62CE
4603: C3 52 63    jp   $6352

4608: CD 7F 01    call handle_main_scrolling_017F
460B: CD BF 0E    call handle_elevators_0EBF
460E: CD A2 12    call handle_enemies_12A2
4611: CD E8 2F    call $2FE8
4614: CD E1 0B    call $0BE1
4617: CD A0 15    call $15A0
461A: CD CF 73    call $73CF
461D: C3 EA 45    jp   $45EA
4620: 32 74 83    ld   ($8374),a
4623: AF          xor  a
4624: 32 F0 82    ld   ($82F0),a
4627: 3A 32 82    ld   a,(timer_16bit_msb_8232)
462A: D6 10       sub  $10
462C: D8          ret  c
462D: 3C          inc  a
462E: 87          add  a,a
462F: FE 0C       cp   $0C
4631: 38 02       jr   c,$4635
4633: 3E 0C       ld   a,$0C
4635: 32 F0 82    ld   ($82F0),a
4638: E6 04       and  $04
463A: C2 49 46    jp   nz,$4649
463D: 3A 4C 83    ld   a,($834C)
4640: FE 08       cp   $08
4642: D2 49 46    jp   nc,$4649
4645: 3C          inc  a
4646: 32 4C 83    ld   ($834C),a
4649: 3A 32 82    ld   a,(timer_16bit_msb_8232)
464C: FE 10       cp   $10
464E: C0          ret  nz
464F: 3A 31 82    ld   a,(timer_16bit_8231)
4652: B7          or   a
4653: CA 65 46    jp   z,$4665
4656: 3D          dec  a
4657: CA 6E 46    jp   z,$466E
465A: 3D          dec  a
465B: C0          ret  nz
465C: 3E 82       ld   a,$82
465E: 32 79 87    ld   ($8779),a
4661: CD D2 64    call $64D2
4664: C9          ret
4665: 3E 80       ld   a,$80
4667: 32 79 87    ld   ($8779),a
466A: CD D2 64    call $64D2
466D: C9          ret
466E: 3E 3E       ld   a,$3E
4670: 32 0B D5    ld   ($D50B),a
4673: C9          ret
4674: B7          or   a
4675: C2 BF 45    jp   nz,$45BF
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
4690: DA A0 46    jp   c,$46A0
4693: 36 00       ld   (hl),$00
4695: C3 C5 45    jp   $45C5
4698: 21 EF 82    ld   hl,$82EF
469B: 36 00       ld   (hl),$00
469D: C3 8A 46    jp   $468A
46A0: DD 7E 0D    ld   a,(ix+move_direction_0d)
46A3: E6 F3       and  $F3
46A5: DD 77 0D    ld   (ix+move_direction_0d),a
46A8: C9          ret
46A9: AF          xor  a
46AA: 32 EE 82    ld   ($82EE),a
46AD: 32 EF 82    ld   ($82EF),a
46B0: 32 F0 82    ld   ($82F0),a
46B3: 21 F1 80    ld   hl,$80F1
46B6: C9          ret
46B7: 21 79 87    ld   hl,$8779
46BA: 36 81       ld   (hl),$81
46BC: 3A 32 82    ld   a,(timer_16bit_msb_8232)
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
473E: CD CE 62    call $62CE
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
4774: CD CE 62    call $62CE
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
47C3: DD 36 06 02 ld   (ix+$06),$02
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
47F1: DD 36 06 02 ld   (ix+$06),$02
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
4829: DD 36 06 01 ld   (ix+$06),$01
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
485A: DD 36 06 01 ld   (ix+$06),$01
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
4988: DD 36 06 03 ld   (ix+$06),$03
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
49B5: 3A BA 85    ld   a,($85BA)
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
49CB: 3A 22 85    ld   a,($8522)
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
49DF: 3A BA 85    ld   a,($85BA)
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
4A33: CD CE 62    call $62CE
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
4A66: 3A BA 85    ld   a,($85BA)
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
4A97: 3A BA 85    ld   a,($85BA)
4A9A: B7          or   a
4A9B: C8          ret  z
4A9C: 3A 20 85    ld   a,($8520)
4A9F: 3D          dec  a
4AA0: C0          ret  nz
4AA1: 3A 22 85    ld   a,($8522)
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
4ABD: 11 E3 16    ld   de,$16E3
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
4B2B: DD 36 06 04 ld   (ix+$06),$04
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
4B97: 11 08 00    ld   de,$0008
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
4BBA: DD 21 FD 82 ld   ix,$82FD
4BBE: 21 23 81    ld   hl,$8123
4BC1: 22 36 83    ld   ($8336),hl
4BC4: AF          xor  a
4BC5: 32 35 83    ld   ($8335),a
4BC8: CD E7 4B    call $4BE7
4BCB: 11 08 00    ld   de,$0008
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
4BFE: CA 78 4C    jp   z,$4C78
4C01: FE FE       cp   $FE
4C03: DA 9C 4C    jp   c,$4C9C
4C06: CA B0 4C    jp   z,$4CB0
4C09: C9          ret
4C0A: DD 34 02    inc  (ix+$02)
4C0D: CD 54 50    call $5054
4C10: C9          ret
4C11: DD 36 02 FB ld   (ix+$02),$FB
4C15: CD 54 50    call $5054
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
4C36: 3A F8 7F    ld   a,($7FF8)
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
4C68: 3E 91       ld   a,$91
4C6A: CD 56 36    call $3656
4C6D: 18 05       jr   $4C74
4C6F: 3E 92       ld   a,$92
4C71: CD 56 36    call $3656
4C74: CD B9 4C    call $4CB9
4C77: C9          ret
4C78: 2A 36 83    ld   hl,($8336)
4C7B: 36 04       ld   (hl),$04
4C7D: 23          inc  hl
4C7E: 7E          ld   a,(hl)
4C7F: DD 86 03    add  a,(ix+character_y_offset_03)
4C82: 77          ld   (hl),a
4C83: 23          inc  hl
4C84: 3A 04 80    ld   a,($8004)
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

4C9C: DD 34 02    inc  (ix+$02)
4C9F: 2A 36 83    ld   hl,($8336)
4CA2: 23          inc  hl
4CA3: 23          inc  hl
4CA4: 3A 04 80    ld   a,($8004)
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
4CF4: CA 33 4D    jp   z,$4D33
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
4D20: 3E C4       ld   a,$C4
4D22: CD 56 36    call $3656
4D25: C3 58 4D    jp   $4D58
4D28: 3E 3A       ld   a,$3A
4D2A: CD 56 36    call $3656
4D2D: CD 94 56    call $5694
4D30: C3 58 4D    jp   $4D58
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
4D53: 3E 93       ld   a,$93
4D55: CD 56 36    call $3656
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
4D70: AF          xor  a
4D71: 32 AB 80    ld   ($80AB),a
4D74: 3E 1F       ld   a,$1F
4D76: 32 2C 80    ld   ($802C),a
4D79: CD 6F 4E    call $4E6F
4D7C: AF          xor  a
4D7D: 32 3C 83    ld   ($833C),a
4D80: 32 3D 83    ld   ($833D),a
4D83: CD CF 73    call $73CF
4D86: 21 3C 83    ld   hl,$833C
4D89: 34          inc  (hl)
4D8A: 7E          ld   a,(hl)
4D8B: FE 14       cp   $14
4D8D: DA 83 4D    jp   c,$4D83
4D90: 3E C2       ld   a,$C2
4D92: 32 0B D5    ld   ($D50B),a
4D95: AF          xor  a
4D96: 32 3C 83    ld   ($833C),a
4D99: CD AC 4E    call $4EAC
4D9C: CD CF 73    call $73CF
4D9F: 21 3C 83    ld   hl,$833C
4DA2: 34          inc  (hl)
4DA3: 7E          ld   a,(hl)
4DA4: FE 0D       cp   $0D
4DA6: DA 99 4D    jp   c,$4D99
4DA9: AF          xor  a
4DAA: 32 3C 83    ld   ($833C),a
4DAD: CD E7 4E    call $4EE7
4DB0: CD CF 73    call $73CF
4DB3: 21 3C 83    ld   hl,$833C
4DB6: 34          inc  (hl)
4DB7: 7E          ld   a,(hl)
4DB8: FE 07       cp   $07
4DBA: DA AD 4D    jp   c,$4DAD
4DBD: AF          xor  a
4DBE: 32 3C 83    ld   ($833C),a
4DC1: CD 13 4F    call $4F13
4DC4: CD CF 73    call $73CF
4DC7: 21 3C 83    ld   hl,$833C
4DCA: 34          inc  (hl)
4DCB: 7E          ld   a,(hl)
4DCC: FE 12       cp   $12
4DCE: DA C1 4D    jp   c,$4DC1
4DD1: AF          xor  a
4DD2: 32 3C 83    ld   ($833C),a
4DD5: CD 4F 4F    call $4F4F
4DD8: CD CF 73    call $73CF
4DDB: 21 3C 83    ld   hl,$833C
4DDE: 34          inc  (hl)
4DDF: 7E          ld   a,(hl)
4DE0: FE 10       cp   $10
4DE2: DA D5 4D    jp   c,$4DD5
4DE5: AF          xor  a
4DE6: 32 3C 83    ld   ($833C),a
4DE9: CD 5D 4F    call $4F5D
4DEC: CD CF 73    call $73CF
4DEF: 21 3C 83    ld   hl,$833C
4DF2: 34          inc  (hl)
4DF3: 7E          ld   a,(hl)
4DF4: FE 09       cp   $09
4DF6: DA E9 4D    jp   c,$4DE9
4DF9: AF          xor  a
4DFA: 32 3C 83    ld   ($833C),a
4DFD: CD C7 4F    call $4FC7
4E00: CD CF 73    call $73CF
4E03: 21 3C 83    ld   hl,$833C
4E06: 34          inc  (hl)
4E07: 7E          ld   a,(hl)
4E08: FE 1A       cp   $1A
4E0A: DA FD 4D    jp   c,$4DFD
4E0D: CD 3F 36    call $363F
4E10: CD 14 4E    call $4E14
4E13: C9          ret

4E14: 3E 05       ld   a,state_ingame_05
4E16: 32 AC 80    ld   (game_state_80AC),a
4E19: CD 3A 2F    call $2F3A
4E1C: CD AD 31    call $31AD
4E1F: CD 87 12    call $1287
4E22: CD DC 0B    call $0BDC
4E25: CD 95 4B    call $4B95
4E28: CD 72 2F    call $2F72
4E2B: AF          xor  a
4E2C: 32 3C 83    ld   ($833C),a
4E2F: FB          ei
4E30: 21 3C 83    ld   hl,$833C
4E33: 7E          ld   a,(hl)
4E34: 34          inc  (hl)
4E35: FE 08       cp   $08
4E37: 30 07       jr   nc,$4E40
4E39: 3E 02       ld   a,$02
4E3B: 32 27 85    ld   (player_move_direction_8527),a
4E3E: 18 17       jr   $4E57
4E40: AF          xor  a
4E41: 32 27 85    ld   (player_move_direction_8527),a
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
4E66: CD A0 15    call $15A0
4E69: CD CF 73    call $73CF
4E6C: C3 30 4E    jp   $4E30
4E6F: 21 3E 83    ld   hl,$833E
4E72: 06 08       ld   b,$08
4E74: 36 00       ld   (hl),$00
4E76: 23          inc  hl
4E77: 10 FB       djnz $4E74
4E79: 21 4B 83    ld   hl,$834B
4E7C: 22 46 83    ld   ($8346),hl
4E7F: 22 49 83    ld   ($8349),hl
4E82: CD E1 71    call $71E1
4E85: AF          xor  a
4E86: 32 D9 81    ld   ($81D9),a
4E89: CD 0C 26    call $260C
4E8C: 3E 04       ld   a,state_game_starting_04
4E8E: 32 AC 80    ld   (game_state_80AC),a
4E91: CD 3E 2A    call $2A3E
4E94: CD 2E 58    call $582E
4E97: CD 00 27    call $2700
4E9A: CD 65 2A    call $2A65
4E9D: CD 01 58    call $5801
4EA0: CD C6 57    call $57C6
4EA3: 3E 05       ld   a,$05
4EA5: 32 A9 80    ld   ($80A9),a
4EA8: CD C2 26    call $26C2
4EAB: C9          ret
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
4F5D: 3A 3C 83    ld   a,($833C)
4F60: 87          add  a,a
4F61: 87          add  a,a
4F62: 87          add  a,a
4F63: 5F          ld   e,a
4F64: 16 00       ld   d,$00
4F66: 21 7F 4F    ld   hl,$4F7F
4F69: 19          add  hl,de
4F6A: 11 3E 83    ld   de,$833E
4F6D: 01 08 00    ld   bc,$0008
4F70: ED B0       ldir
4F72: 21 3E 83    ld   hl,$833E
4F75: CD 40 4F    call $4F40
4F78: 21 42 83    ld   hl,$8342
4F7B: CD 40 4F    call $4F40
4F7E: C9          ret
4F7F: 53          ld   d,e
4F80: 94          sub  h
4F81: 01 44 00    ld   bc,$0044
4F84: 00          nop
4F85: 00          nop
4F86: 00          nop
4F87: 54          ld   d,h
4F88: 93          sub  e
4F89: 01 44 00    ld   bc,$0044
4F8C: 00          nop
4F8D: 00          nop
4F8E: 00          nop
4F8F: 55          ld   d,l
4F90: 91          sub  c
4F91: 01 44 00    ld   bc,$0044
4F94: 00          nop
4F95: 00          nop
4F96: 00          nop
4F97: 56          ld   d,(hl)
4F98: 8E          adc  a,(hl)
4F99: 01 44 00    ld   bc,$0044
4F9C: 00          nop
4F9D: 00          nop
4F9E: 00          nop
4F9F: 57          ld   d,a
4FA0: 86          add  a,(hl)
4FA1: 01 43 57    ld   bc,$5743
4FA4: 96          sub  (hl)
4FA5: 01 4E 59    ld   bc,$594E
4FA8: 81          add  a,c
4FA9: 01 43 59    ld   bc,$5943
4FAC: 91          sub  c
4FAD: 01 4E 5A    ld   bc,$5A4E
4FB0: 7B          ld   a,e
4FB1: 01 43 5A    ld   bc,$5A43
4FB4: 8B          adc  a,e
4FB5: 01 4E 5B    ld   bc,$5B4E
4FB8: 6E          ld   l,(hl)
4FB9: 01 43 5B    ld   bc,$5B43
4FBC: 7E          ld   a,(hl)
4FBD: 01 4E 60    ld   bc,$604E
4FC0: 6E          ld   l,(hl)
4FC1: 01 42 00    ld   bc,$0042
4FC4: 00          nop
4FC5: 00          nop
4FC6: 00          nop
4FC7: 3A 3C 83    ld   a,($833C)
4FCA: 32 3D 83    ld   ($833D),a
4FCD: E6 F8       and  $F8
4FCF: 5F          ld   e,a
4FD0: 16 00       ld   d,$00
4FD2: 21 EB 4F    ld   hl,$4FEB
4FD5: 19          add  hl,de
4FD6: 11 3E 83    ld   de,$833E
4FD9: 01 08 00    ld   bc,$0008
4FDC: ED B0       ldir
4FDE: 21 3E 83    ld   hl,$833E
4FE1: CD 40 4F    call $4F40
4FE4: 21 42 83    ld   hl,$8342
4FE7: CD 40 4F    call $4F40
4FEA: C9          ret
4FEB: 60          ld   h,b
4FEC: 6E          ld   l,(hl)
4FED: 01 42 00    ld   bc,$0042
4FF0: 00          nop
4FF1: 00          nop
4FF2: 00          nop
4FF3: 5C          ld   e,h
4FF4: 6E          ld   l,(hl)
4FF5: 00          nop
4FF6: 42          ld   b,d
4FF7: 00          nop
4FF8: 00          nop
4FF9: 00          nop
4FFA: 00          nop
4FFB: 60          ld   h,b
4FFC: 6E          ld   l,(hl)
4FFD: 01 42 00    ld   bc,$0042
5000: 00          nop
5001: 00          nop
5002: 00          nop
5003: 5C          ld   e,h
5004: 6E          ld   l,(hl)
5005: 01 41 5D    ld   bc,$5D41
5008: 7E          ld   a,(hl)
5009: 01 4E 21    ld   bc,$214E
500C: 3E 83       ld   a,$83
500E: 11 00 D1    ld   de,$D100
5011: 01 08 00    ld   bc,$0008
5014: ED B0       ldir
5016: 3A 3D 83    ld   a,($833D)
5019: B7          or   a
501A: CA 26 50    jp   z,$5026
501D: 3D          dec  a
501E: CA 35 50    jp   z,$5035
5021: 3D          dec  a
5022: CA 43 50    jp   z,$5043
5025: C9          ret
5026: 2A 46 83    ld   hl,($8346)
5029: 3A 48 83    ld   a,($8348)
502C: 77          ld   (hl),a
502D: 2A 49 83    ld   hl,($8349)
5030: 3A 4B 83    ld   a,($834B)
5033: 77          ld   (hl),a
5034: C9          ret
5035: 21 C0 C8    ld   hl,$C8C0
5038: 11 22 00    ld   de,$0022
503B: 06 07       ld   b,$07
503D: 36 40       ld   (hl),$40
503F: 19          add  hl,de
5040: 10 FB       djnz $503D
5042: C9          ret
5043: 21 C1 C8    ld   hl,$C8C1
5046: 11 22 00    ld   de,$0022
5049: 06 06       ld   b,$06
504B: CD 3D 50    call $503D
504E: 3E 41       ld   a,$41
5050: 32 8D C9    ld   ($C98D),a
5053: C9          ret
5054: DD E5       push ix
5056: DD 5E 05    ld   e,(ix+character_delta_x_05)
5059: DD 56 06    ld   d,(ix+$06)
505C: D5          push de
505D: DD E1       pop  ix
505F: DD 7E 09    ld   a,(ix+$09)
5062: FE 07       cp   $07
5064: 28 05       jr   z,$506B
5066: FE 05       cp   $05
5068: D2 A0 50    jp   nc,$50A0
506B: DD 7E 06    ld   a,(ix+$06)
506E: FE 03       cp   $03
5070: CA A0 50    jp   z,$50A0
5073: CD 10 51    call $5110
5076: CD AC 50    call $50AC
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
50A0: DD E1       pop  ix
50A2: DD 36 02 FF ld   (ix+$02),$FF
50A6: 2A 36 83    ld   hl,($8336)
50A9: 36 FF       ld   (hl),$FF
50AB: C9          ret
50AC: 21 D8 50    ld   hl,$50D8
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
50D8: 0F          rrca
50D9: FE F8       cp   $F8
50DB: 72          ld   (hl),d
50DC: 0F          rrca
50DD: 0B          dec  bc
50DE: 08          ex   af,af'
50DF: 72          ld   (hl),d
50E0: 0F          rrca
50E1: FE F8       cp   $F8
50E3: 72          ld   (hl),d
50E4: 0F          rrca
50E5: 0B          dec  bc
50E6: 08          ex   af,af'
50E7: 72          ld   (hl),d
50E8: 09          add  hl,bc
50E9: FE F8       cp   $F8
50EB: 74          ld   (hl),h
50EC: 09          add  hl,bc
50ED: 0B          dec  bc
50EE: 08          ex   af,af'
50EF: 74          ld   (hl),h
50F0: 0C          inc  c
50F1: FE F8       cp   $F8
50F3: 72          ld   (hl),d
50F4: 0C          inc  c
50F5: 0B          dec  bc
50F6: 08          ex   af,af'
50F7: 72          ld   (hl),d
50F8: 0C          inc  c
50F9: FE F8       cp   $F8
50FB: 00          nop
50FC: 0C          inc  c
50FD: 0B          dec  bc
50FE: 08          ex   af,af'
50FF: 00          nop
5100: 06 FE       ld   b,$FE
5102: F8          ret  m
5103: 74          ld   (hl),h
5104: 06 0B       ld   b,$0B
5106: 08          ex   af,af'
5107: 74          ld   (hl),h
5108: 03          inc  bc
5109: FE F8       cp   $F8
510B: 76          halt
510C: 03          inc  bc
510D: 15          dec  d
510E: 08          ex   af,af'
510F: 76          halt
5110: DD 7E 06    ld   a,(ix+$06)
5113: B7          or   a
5114: CA 4C 51    jp   z,$514C
5117: 3D          dec  a
5118: CA 34 51    jp   z,$5134
511B: CD CE 62    call $62CE
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
5134: CD CE 62    call $62CE
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
5164: CD 6C 1E    call $1E6C
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
51A7: CD CE 62    call $62CE
51AA: AF          xor  a
51AB: DD 77 1A    ld   (ix+$1a),a
51AE: DD 77 17    ld   (ix+$17),a
51B1: CD 68 05    call $0568
51B4: DA F8 51    jp   c,$51F8
51B7: 3A 21 85    ld   a,($8521)
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
520F: 3A 21 85    ld   a,($8521)
5212: FE 07       cp   $07
5214: 30 09       jr   nc,$521F
5216: 3A 20 85    ld   a,($8520)
5219: 3D          dec  a
521A: 28 19       jr   z,$5235
521C: 3D          dec  a
521D: 28 16       jr   z,$5235
521F: CD 7A 52    call $527A
5222: 3A 21 85    ld   a,($8521)
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
524E: DD 36 1A 00 ld   (ix+$1a),$00
5252: CD 68 05    call $0568
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
5295: 21 81 80    ld   hl,$8081
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
52A8: 3A BA 85    ld   a,($85BA)
52AB: C6 03       add  a,$03
52AD: DD 77 10    ld   (ix+$10),a
52B0: CD B4 52    call $52B4
52B3: C9          ret
52B4: 3A 21 85    ld   a,($8521)
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
5329: 3A BA 85    ld   a,($85BA)
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
5346: 3A BA 85    ld   a,($85BA)
5349: E6 01       and  $01
534B: 20 06       jr   nz,$5353
534D: CD 8B 53    call $538B
5350: C3 F4 51    jp   $51F4
5353: CD BA 53    call $53BA
5356: C3 F4 51    jp   $51F4
5359: 3A 21 85    ld   a,($8521)
535C: FE 14       cp   $14
535E: 20 10       jr   nz,$5370
5360: 3A 1A 85    ld   a,(player_structure_851A)
5363: FE AC       cp   $AC
5365: 38 DF       jr   c,$5346
5367: DD 36 0B 01 ld   (ix+$0b),$01
536B: 18 13       jr   $5380
536D: 3A 21 85    ld   a,($8521)
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
53F6: AF          xor  a
53F7: DD 77 1B    ld   (ix+$1b),a
53FA: DD 77 18    ld   (ix+$18),a
53FD: CD 68 05    call $0568
5400: DA 36 54    jp   c,$5436
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
5464: CD CE 62    call $62CE
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
5499: 21 81 80    ld   hl,$8081
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
54FB: CD F5 1D    call $1DF5
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
5580: 3A 21 85    ld   a,($8521)
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
55BF: DD 36 06 05 ld   (ix+$06),$05
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
5605: 21 3F 56    ld   hl,$563F
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
5637: 21 3F 56    ld   hl,$563F
563A: 19          add  hl,de
563B: 5E          ld   e,(hl)
563C: 23          inc  hl
563D: 56          ld   d,(hl)
563E: C9          ret
563F: 80          add  a,b
5640: 01 C0 00    ld   bc,$00C0
5643: 00          nop
5644: 00          nop
5645: 40          ld   b,b
5646: 03          inc  bc
5647: 80          add  a,b
5648: 02          ld   (bc),a
5649: C0          ret  nz
564A: 01 00 01    ld   bc,$0100
564D: 40          ld   b,b
564E: 00          nop
564F: 80          add  a,b
5650: 03          inc  bc
5651: C0          ret  nz
5652: 02          ld   (bc),a
5653: 00          nop
5654: 02          ld   (bc),a
5655: 40          ld   b,b
5656: 01 80 00    ld   bc,$0080
5659: C0          ret  nz
565A: 03          inc  bc
565B: 00          nop
565C: 03          inc  bc
565D: 40          ld   b,b
565E: 02          ld   (bc),a
565F: 80          add  a,b
5660: 01 C0 00    ld   bc,$00C0
5663: 00          nop
5664: 00          nop
5665: 40          ld   b,b
5666: 03          inc  bc
5667: 80          add  a,b
5668: 02          ld   (bc),a
5669: C0          ret  nz
566A: 01 00 01    ld   bc,$0100
566D: 40          ld   b,b
566E: 00          nop
566F: 80          add  a,b
5670: 03          inc  bc
5671: C0          ret  nz
5672: 02          ld   (bc),a
5673: 00          nop
5674: 02          ld   (bc),a
5675: 40          ld   b,b
5676: 01 80 00    ld   bc,$0080
5679: C0          ret  nz
567A: 03          inc  bc
567B: 00          nop
567C: 03          inc  bc
567D: 40          ld   b,b
567E: 02          ld   (bc),a
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
56B3: 21 7B 57    ld   hl,$577B
56B6: C3 02 57    jp   $5702
56B9: C5          push bc
56BA: D5          push de
56BB: E5          push hl
56BC: 21 84 57    ld   hl,$5784
56BF: 3A 42 82    ld   a,($8242)
56C2: B7          or   a
56C3: C2 02 57    jp   nz,$5702
56C6: DD 7E 06    ld   a,(ix+$06)
56C9: B7          or   a
56CA: 20 0C       jr   nz,$56D8
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
56F9: C5          push bc
56FA: D5          push de
56FB: E5          push hl
56FC: 21 6D 83    ld   hl,$836D
56FF: C3 02 57    jp   $5702
5702: 3A 3B 82    ld   a,($823B)
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
5725: CD D3 58    call $58D3
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
5750: CD D3 58    call $58D3
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
5777: 32 0B D5    ld   ($D50B),a
577A: C9          ret
577B: 00          nop
577C: 01 00 50    ld   bc,$5000
577F: 01 00 50    ld   bc,$5000
5782: 01 00 00    ld   bc,$0000
5785: 02          ld   (bc),a
5786: 00          nop
5787: 00          nop
5788: 03          inc  bc
5789: 00          nop
578A: 00          nop
578B: 03          inc  bc
578C: 00          nop
578D: 00          nop
578E: 05          dec  b
578F: 00          nop
5790: 00          nop
5791: 10 00       djnz $5793
5793: 3A 50 82    ld   a,($8250)
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
57A7: 21 6D 83    ld   hl,$836D
57AA: AF          xor  a
57AB: 06 03       ld   b,$03
57AD: 77          ld   (hl),a
57AE: 23          inc  hl
57AF: 10 FC       djnz $57AD
57B1: 06 03       ld   b,$03
57B3: 11 6D 83    ld   de,$836D
57B6: 21 90 57    ld   hl,$5790
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
57C6: 21 53 83    ld   hl,$8353
57C9: 11 63 C4    ld   de,$C463
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
5801: 3A 50 82    ld   a,($8250)
5804: CB 77       bit  6,a
5806: 20 15       jr   nz,$581D
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
581D: 21 27 58    ld   hl,$5827
5820: 11 A1 C7    ld   de,$C7A1
5823: CD F9 29    call copy_bytes_to_screen_29F9
5826: C9          ret
5827: 25          dec  h
5828: 2F          cpl
5829: 33          inc  sp
582A: 2B          dec  hl
582B: 2C          inc  l
582C: 31 FF 21    ld   sp,$21FF
582F: 40          ld   b,b
5830: C7          rst  $00
5831: 3E 32       ld   a,$32
5833: 06 60       ld   b,$60
5835: 77          ld   (hl),a
5836: 23          inc  hl
5837: 10 FC       djnz $5835
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
5850: 21 72 58    ld   hl,$5872
5853: 11 42 C4    ld   de,$C442
5856: ED B0       ldir
5858: CD 95 58    call $5895
585B: 21 A0 C7    ld   hl,$C7A0
585E: 3E 33       ld   a,$33
5860: 06 20       ld   b,$20
5862: 77          ld   (hl),a
5863: 23          inc  hl
5864: 10 FC       djnz $5862
5866: 21 8E 58    ld   hl,$588E
5869: 11 B7 C7    ld   de,$C7B7
586C: 01 07 00    ld   bc,$0007
586F: ED B0       ldir
5871: C9          ret
5872: 1A          ld   a,(de)
5873: 1B          dec  de
5874: 1C          inc  e
5875: 1D          dec  e
5876: 1E 1F       ld   e,$1F
5878: 2A 11 33    ld   hl,($3311)
587B: 33          inc  sp
587C: 2B          dec  hl
587D: 2C          inc  l
587E: 2A 2D 2E    ld   hl,($2E2D)
5881: 2F          cpl
5882: 1F          rra
5883: 1E 33       ld   e,$33
5885: 33          inc  sp
5886: 1A          ld   a,(de)
5887: 1B          dec  de
5888: 1C          inc  e
5889: 1D          dec  e
588A: 1E 1F       ld   e,$1F
588C: 2A 12 2E    ld   hl,($2E12)
588F: 1F          rra
5890: 1E 30       ld   e,$30
5892: 2C          inc  l
5893: 31 2A 21    ld   sp,$212A
5896: 53          ld   d,e
5897: 83          add  a,e
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
58AF: CD D3 58    call $58D3
58B2: 21 50 83    ld   hl,$8350
58B5: 11 62 83    ld   de,$8362
58B8: CD D3 58    call $58D3
58BB: 3A 35 82    ld   a,($8235)
58BE: 3D          dec  a
58BF: C8          ret  z
58C0: 21 54 82    ld   hl,$8254
58C3: 11 58 83    ld   de,$8358
58C6: 3A 36 82    ld   a,($8236)
58C9: B7          or   a
58CA: 20 03       jr   nz,$58CF
58CC: 11 6C 83    ld   de,$836C
58CF: CD D3 58    call $58D3
58D2: C9          ret
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
58EE: CD 6C 59    call $596C
58F1: CD BB 59    call $59BB
58F4: CD F4 59    call $59F4
58F7: CD 1F 04    call $041F
58FA: C9          ret

58FB: 2A 31 82    ld   hl,(timer_16bit_8231)
58FE: 23          inc  hl
58FF: 22 31 82    ld   (timer_16bit_8231),hl
5902: CD 2F 59    call $592F
5905: 06 01       ld   b,$01
5907: 3A 32 82    ld   a,(timer_16bit_msb_8232)
590A: FE 03       cp   $03
590C: 38 06       jr   c,$5914
590E: 04          inc  b
590F: FE 0C       cp   $0C
5911: 38 01       jr   c,$5914
5913: 04          inc  b
5914: 78          ld   a,b
5915: 32 7A 83    ld   ($837A),a
5918: 3A 74 83    ld   a,($8374)
591B: 87          add  a,a
591C: 47          ld   b,a
591D: 3E 50       ld   a,$50
591F: 90          sub  b
5920: 90          sub  b
5921: 90          sub  b
5922: 30 01       jr   nc,$5925
5924: AF          xor  a
5925: 32 75 83    ld   ($8375),a
5928: CD 4D 59    call $594D
592B: CD FC 5A    call $5AFC
592E: C9          ret
592F: 3A 32 82    ld   a,(timer_16bit_msb_8232)
5932: FE 10       cp   $10
5934: 30 13       jr   nc,$5949
5936: CB 3F       srl  a
5938: CB 3F       srl  a
593A: 47          ld   b,a
593B: 3A 37 82    ld   a,(skill_level_8237)
593E: 80          add  a,b
593F: FE 10       cp   $10
5941: 38 02       jr   c,$5945
5943: 3E 0F       ld   a,$0F
5945: CD 20 46    call $4620
5948: C9          ret
5949: D6 0C       sub  $0C
594B: 18 ED       jr   $593A
594D: 06 03       ld   b,$03
594F: 3A 37 82    ld   a,(skill_level_8237)
5952: 87          add  a,a
5953: 87          add  a,a
5954: 4F          ld   c,a
5955: 3A 32 82    ld   a,(timer_16bit_msb_8232)
5958: 81          add  a,c
5959: FE 0E       cp   $0E
595B: 38 02       jr   c,$595F
595D: 06 04       ld   b,$04
595F: 78          ld   a,b
5960: 32 7B 83    ld   ($837B),a
5963: 3A 74 83    ld   a,($8374)
5966: 87          add  a,a
5967: 87          add  a,a
5968: 32 7C 83    ld   ($837C),a
596B: C9          ret
596C: 21 77 83    ld   hl,$8377
596F: AF          xor  a
5970: 77          ld   (hl),a
5971: 23          inc  hl
5972: 77          ld   (hl),a
5973: 23          inc  hl
5974: 77          ld   (hl),a
5975: DD 21 3A 85 ld   ix,enemy_1_853A
5979: 11 20 00    ld   de,$0020
597C: 06 04       ld   b,$04
597E: 3A 21 85    ld   a,($8521)
5981: 4F          ld   c,a
5982: 0D          dec  c
5983: DD 7E 09    ld   a,(ix+$09)
5986: 3C          inc  a
5987: CA B6 59    jp   z,$59B6
598A: DD 7E 06    ld   a,(ix+$06)
598D: FE 05       cp   $05
598F: 28 0C       jr   z,$599D
5991: B7          or   a
5992: 20 22       jr   nz,$59B6
5994: DD 7E 1C    ld   a,(ix+$1c)
5997: FE 0C       cp   $0C
5999: 28 1B       jr   z,$59B6
599B: 18 07       jr   $59A4
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
59C3: 3A 74 83    ld   a,($8374)
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
59D9: 28 07       jr   z,$59E2
59DB: 3D          dec  a
59DC: 28 04       jr   z,$59E2
59DE: 23          inc  hl
59DF: 10 F1       djnz $59D2
59E1: C9          ret
59E2: 3E 5A       ld   a,$5A
59E4: 32 76 83    ld   ($8376),a
59E7: 21 48 85    ld   hl,$8548
59EA: 11 20 00    ld   de,$0020
59ED: 06 04       ld   b,$04
59EF: 77          ld   (hl),a
59F0: 19          add  hl,de
59F1: 10 FC       djnz $59EF
59F3: C9          ret
59F4: 3A 20 85    ld   a,($8520)
59F7: B7          or   a
59F8: CA FF 59    jp   z,$59FF
59FB: CD 0D 5A    call $5A0D
59FE: C9          ret
59FF: 3A 76 83    ld   a,($8376)
5A02: B7          or   a
5A03: 20 04       jr   nz,$5A09
5A05: CD 0D 5A    call $5A0D
5A08: C9          ret
5A09: CD 26 5A    call $5A26
5A0C: C9          ret
5A0D: 3A 7B 83    ld   a,($837B)
5A10: 47          ld   b,a
5A11: DD 21 3A 85 ld   ix,enemy_1_853A
5A15: CD 2A 1E    call $1E2A
5A18: 5F          ld   e,a
5A19: 0E 01       ld   c,$01
5A1B: CD 4C 5A    call $5A4C
5A1E: 11 20 00    ld   de,$0020
5A21: DD 19       add  ix,de
5A23: 10 F0       djnz $5A15
5A25: C9          ret
5A26: 3A 7B 83    ld   a,($837B)
5A29: 47          ld   b,a
5A2A: DD 21 3A 85 ld   ix,enemy_1_853A
5A2E: 3A 7A 83    ld   a,($837A)
5A31: 4F          ld   c,a
5A32: 1E 01       ld   e,$01
5A34: CD F5 1D    call $1DF5
5A37: 21 7C 83    ld   hl,$837C
5A3A: BE          cp   (hl)
5A3B: 38 04       jr   c,$5A41
5A3D: CD 2A 1E    call $1E2A
5A40: 5F          ld   e,a
5A41: CD 4C 5A    call $5A4C
5A44: 11 20 00    ld   de,$0020
5A47: DD 19       add  ix,de
5A49: 10 E3       djnz $5A2E
5A4B: C9          ret
5A4C: DD 7E 09    ld   a,(ix+$09)
5A4F: 3C          inc  a
5A50: 28 0C       jr   z,$5A5E
5A52: DD 7E 06    ld   a,(ix+$06)
5A55: FE 05       cp   $05
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
5A6C: 3A 21 85    ld   a,($8521)
5A6F: 83          add  a,e
5A70: 3D          dec  a
5A71: DD 77 07    ld   (ix+$07),a
5A74: CD F5 1D    call $1DF5
5A77: E6 07       and  $07
5A79: DD 77 08    ld   (ix+$08),a
5A7C: E5          push hl
5A7D: CD AB 5A    call $5AAB
5A80: E1          pop  hl
5A81: DD 36 09 FF ld   (ix+$09),$FF
5A85: C8          ret  z
5A86: 3E 00       ld   a,$00
5A88: DD 77 0D    ld   (ix+move_direction_0d),a
5A8B: DD 77 19    ld   (ix+$19),a
5A8E: DD 77 09    ld   (ix+$09),a
5A91: DD 77 0F    ld   (ix+$0f),a
5A94: DD 77 10    ld   (ix+$10),a
5A97: DD 36 06 05 ld   (ix+$06),$05
5A9B: DD 36 04 FF ld   (ix+$04),$FF
5A9F: DD 36 0A E0 ld   (ix+$0a),$E0
5AA3: 34          inc  (hl)
5AA4: 3A 74 83    ld   a,($8374)
5AA7: DD 77 13    ld   (ix+$13),a
5AAA: C9          ret
5AAB: C5          push bc
5AAC: DD 7E 07    ld   a,(ix+$07)
5AAF: B7          or   a
5AB0: DA DC 5A    jp   c,$5ADC
5AB3: FE 1F       cp   $1F
5AB5: D2 DC 5A    jp   nc,$5ADC
5AB8: FE 14       cp   $14
5ABA: 28 23       jr   z,$5ADF
5ABC: DD 5E 07    ld   e,(ix+$07)
5ABF: 16 00       ld   d,$00
5AC1: 21 10 82    ld   hl,red_door_position_array_8210
5AC4: 19          add  hl,de
5AC5: 7E          ld   a,(hl)
5AC6: DD BE 08    cp   (ix+$08)
5AC9: 28 11       jr   z,$5ADC
5ACB: 21 F1 81    ld   hl,$81F1
5ACE: 19          add  hl,de
5ACF: 7E          ld   a,(hl)
5AD0: DD 46 08    ld   b,(ix+$08)
5AD3: 07          rlca
5AD4: 05          dec  b
5AD5: F2 D3 5A    jp   p,$5AD3
5AD8: E6 01       and  $01
5ADA: C1          pop  bc
5ADB: C9          ret
5ADC: AF          xor  a
5ADD: C1          pop  bc
5ADE: C9          ret
5ADF: 3A 21 85    ld   a,($8521)
5AE2: FE 14       cp   $14
5AE4: 20 D6       jr   nz,$5ABC
5AE6: 3A 1A 85    ld   a,(player_structure_851A)
5AE9: FE AE       cp   $AE
5AEB: 38 CF       jr   c,$5ABC
5AED: 3A 32 82    ld   a,(timer_16bit_msb_8232)
5AF0: FE 10       cp   $10
5AF2: 38 C8       jr   c,$5ABC
5AF4: DD 36 08 06 ld   (ix+$08),$06
5AF8: F6 01       or   $01
5AFA: C1          pop  bc
5AFB: C9          ret
5AFC: 3A 31 82    ld   a,(timer_16bit_8231)
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
5B19: CD 25 5B    call $5B25
5B1C: 21 4A 85    ld   hl,$854A
5B1F: CD 25 5B    call $5B25
5B22: 21 53 85    ld   hl,$8553
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
5B37: 3A 21 85    ld   a,($8521)
5B3A: 47          ld   b,a
5B3B: FE 1F       cp   $1F
5B3D: 38 02       jr   c,$5B41
5B3F: 06 1E       ld   b,$1E
5B41: DD 7E 07    ld   a,(ix+$07)
5B44: B8          cp   b
5B45: CA 13 5D    jp   z,$5D13
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
5B7A: 3A BA 85    ld   a,($85BA)
5B7D: E6 01       and  $01
5B7F: 83          add  a,e
5B80: 5F          ld   e,a
5B81: 16 00       ld   d,$00
5B83: 21 91 5B    ld   hl,$5B91
5B86: 19          add  hl,de
5B87: 7E          ld   a,(hl)
5B88: DD 77 1A    ld   (ix+$1a),a
5B8B: FE C2       cp   $C2
5B8D: C0          ret  nz
5B8E: DD 36 1C 0B ld   (ix+$1c),$0B
5B92: C9          ret
5B93: 58          ld   e,b
5B94: 98          sbc  a,b
5B95: 58          ld   e,b
5B96: 98          sbc  a,b
5B97: 58          ld   e,b
5B98: 98          sbc  a,b
5B99: 58          ld   e,b
5B9A: 98          sbc  a,b
5B9B: 58          ld   e,b
5B9C: 98          sbc  a,b
5B9D: 58          ld   e,b
5B9E: 98          sbc  a,b
5B9F: 18 D8       jr   $5B79
5BA1: 18 D8       jr   $5B7B
5BA3: 18 D8       jr   $5B7D
5BA5: 18 D8       jr   $5B7F
5BA7: 78          ld   a,b
5BA8: D8          ret  c
5BA9: D8          ret  c
5BAA: D8          ret  c
5BAB: 18 18       jr   $5BC5
5BAD: 18 18       jr   $5BC7
5BAF: 78          ld   a,b
5BB0: 78          ld   a,b
5BB1: 78          ld   a,b
5BB2: C2 DD 36    jp   nz,$36DD
5BB5: 1A          ld   a,(de)
5BB6: 78          ld   a,b
5BB7: DD 7E 00    ld   a,(ix+character_x_00)
5BBA: FE AC       cp   $AC
5BBC: D8          ret  c
5BBD: DD 36 1C 0B ld   (ix+$1c),$0B
5BC1: DD 36 1A E7 ld   (ix+$1a),$E7
5BC5: C9          ret
5BC6: 3A 21 85    ld   a,($8521)
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
5BE5: 3A BA 85    ld   a,($85BA)
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
5C07: 3A 21 85    ld   a,($8521)
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
5C26: 3A BA 85    ld   a,($85BA)
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
5C4B: 87          add  a,a
5C4C: C6 38       add  a,$38
5C4E: DD 77 1A    ld   (ix+$1a),a
5C51: C9          ret
5C52: DD 36 1C 03 ld   (ix+$1c),$03
5C56: DD 36 1E 01 ld   (ix+$1e),$01
5C5A: DD 36 1A 78 ld   (ix+$1a),$78
5C5E: DD 7E 07    ld   a,(ix+$07)
5C61: FE 14       cp   $14
5C63: 28 4A       jr   z,$5CAF
5C65: D0          ret  nc
5C66: FE 12       cp   $12
5C68: CA 00 5D    jp   z,$5D00
5C6B: D2 D2 5C    jp   nc,$5CD2
5C6E: B7          or   a
5C6F: CA 44 5C    jp   z,$5C44
5C72: 87          add  a,a
5C73: 5F          ld   e,a
5C74: 3A BA 85    ld   a,($85BA)
5C77: E6 01       and  $01
5C79: 83          add  a,e
5C7A: 5F          ld   e,a
5C7B: 16 00       ld   d,$00
5C7D: 21 8B 5C    ld   hl,$5C8B
5C80: 19          add  hl,de
5C81: 7E          ld   a,(hl)
5C82: DD 77 1A    ld   (ix+$1a),a
5C85: FE E7       cp   $E7
5C87: C0          ret  nz
5C88: DD 36 1C 0B ld   (ix+$1c),$0B
5C8C: C9          ret
5C8D: 58          ld   e,b
5C8E: 98          sbc  a,b
5C8F: 58          ld   e,b
5C90: 98          sbc  a,b
5C91: 58          ld   e,b
5C92: 98          sbc  a,b
5C93: 58          ld   e,b
5C94: 98          sbc  a,b
5C95: 58          ld   e,b
5C96: 98          sbc  a,b
5C97: 58          ld   e,b
5C98: 98          sbc  a,b
5C99: 58          ld   e,b
5C9A: 98          sbc  a,b
5C9B: 18 D8       jr   $5C75
5C9D: 18 D8       jr   $5C77
5C9F: 18 D8       jr   $5C79
5CA1: 18 D8       jr   $5C7B
5CA3: 78          ld   a,b
5CA4: D8          ret  c
5CA5: D8          ret  c
5CA6: D8          ret  c
5CA7: 18 18       jr   $5CC1
5CA9: 18 18       jr   $5CC3
5CAB: 78          ld   a,b
5CAC: 78          ld   a,b
5CAD: 78          ld   a,b
5CAE: E7          rst  $20
5CAF: DD 7E 00    ld   a,(ix+character_x_00)
5CB2: FE AC       cp   $AC
5CB4: 30 13       jr   nc,$5CC9
5CB6: 3A BA 85    ld   a,($85BA)
5CB9: DD 36 1A 78 ld   (ix+$1a),$78
5CBD: E6 01       and  $01
5CBF: C0          ret  nz
5CC0: DD 36 1C 0B ld   (ix+$1c),$0B
5CC4: DD 36 1A 09 ld   (ix+$1a),$09
5CC8: C9          ret
5CC9: DD 36 1A E7 ld   (ix+$1a),$E7
5CCD: DD 36 1C 0B ld   (ix+$1c),$0B
5CD1: C9          ret
5CD2: 3A 21 85    ld   a,($8521)
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
5CF1: 3A BA 85    ld   a,($85BA)
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
5D4B: CD F5 1D    call $1DF5
5D4E: E6 0F       and  $0F
5D50: C6 40       add  a,$40
5D52: 47          ld   b,a
5D53: DD 7E 07    ld   a,(ix+$07)
5D56: B7          or   a
5D57: 78          ld   a,b
5D58: F2 5D 5D    jp   p,$5D5D
5D5B: ED 44       neg
5D5D: DD 77 1A    ld   (ix+$1a),a
5D60: C9          ret
5D61: CD 8E 5D    call $5D8E
5D64: 3E 0A       ld   a,$0A
5D66: 32 0E 85    ld   ($850E),a
5D69: 21 BC 84    ld   hl,$84BC
5D6C: 22 0F 85    ld   ($850F),hl
5D6F: DD 21 A7 84 ld   ix,$84A7
5D73: CD 44 5F    call $5F44
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
5D91: CD 29 5F    call $5F29
5D94: C9          ret
5D95: DD 21 D5 83 ld   ix,$83D5
5D99: FD 21 7D 83 ld   iy,$837D
5D9D: 21 81 80    ld   hl,$8081
5DA0: 22 11 85    ld   ($8511),hl
5DA3: AF          xor  a
5DA4: 32 0E 85    ld   ($850E),a
5DA7: CD DB 5D    call $5DDB
5DAA: 11 15 00    ld   de,$0015
5DAD: DD 19       add  ix,de
5DAF: 11 08 00    ld   de,$0008
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
5DFC: CD 76 5E    call $5E76
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
5E3F: CD F5 1D    call $1DF5
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
5F29: 3A 05 80    ld   a,($8005)
5F2C: 4F          ld   c,a
5F2D: DD 21 D5 83 ld   ix,$83D5
5F31: 21 13 85    ld   hl,$8513
5F34: 11 15 00    ld   de,$0015
5F37: 06 07       ld   b,$07
5F39: DD 7E 0F    ld   a,(ix+$0f)
5F3C: 81          add  a,c
5F3D: 77          ld   (hl),a
5F3E: 23          inc  hl
5F3F: DD 19       add  ix,de
5F41: 10 F6       djnz $5F39
5F43: C9          ret
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
5FB9: DD 7E 09    ld   a,(ix+$09)
5FBC: 32 0C 85    ld   ($850C),a
5FBF: 7D          ld   a,l
5FC0: DD 86 08    add  a,(ix+$08)
5FC3: DD 96 0C    sub  (ix+$0c)
5FC6: DD 77 08    ld   (ix+$08),a
5FC9: FA D6 5F    jp   m,$5FD6
5FCC: D6 08       sub  $08
5FCE: D8          ret  c
5FCF: DD 77 08    ld   (ix+$08),a
5FD2: DD 34 09    inc  (ix+$09)
5FD5: C9          ret
5FD6: C6 08       add  a,$08
5FD8: DD 77 08    ld   (ix+$08),a
5FDB: DD 35 09    dec  (ix+$09)
5FDE: C9          ret
5FDF: 2A 2A 80    ld   hl,($802A)
5FE2: 44          ld   b,h
5FE3: 4D          ld   c,l
5FE4: DD 56 07    ld   d,(ix+$07)
5FE7: DD 5E 06    ld   e,(ix+$06)
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
6069: 21 97 60    ld   hl,$6097
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
6097: 82          add  a,d
6098: 01 86 01    ld   bc,$0186
609B: 8A          adc  a,d
609C: 01 8E 01    ld   bc,$018E
609F: 92          sub  d
60A0: 01 96 01    ld   bc,$0196
60A3: 9A          sbc  a,d
60A4: 01 82 02    ld   bc,$0282
60A7: 4E          ld   c,(hl)
60A8: 00          nop
60A9: 8E          adc  a,(hl)
60AA: 00          nop
60AB: 8E          adc  a,(hl)
60AC: 01 16 07    ld   bc,$0716
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
60CB: 11 DE 60    ld   de,$60DE
60CE: 19          add  hl,de
60CF: ED 5B 0F 85 ld   de,($850F)
60D3: ED A0       ldi
60D5: ED A0       ldi
60D7: ED A0       ldi
60D9: ED 53 0F 85 ld   ($850F),de
60DD: C9          ret
60DE: 3A FC 38    ld   a,($38FC)
60E1: 00          nop
60E2: 3B          dec  sp
60E3: 3B          dec  sp
60E4: 3B          dec  sp
60E5: 00          nop
60E6: 3B          dec  sp
60E7: 3B          dec  sp
60E8: 3B          dec  sp
60E9: 00          nop
60EA: 3B          dec  sp
60EB: 3B          dec  sp
60EC: 3B          dec  sp
60ED: 00          nop
60EE: 3B          dec  sp
60EF: 3B          dec  sp
60F0: 3B          dec  sp
60F1: 00          nop
60F2: 3B          dec  sp
60F3: 3B          dec  sp
60F4: 3B          dec  sp
60F5: 00          nop
60F6: 3E 3D       ld   a,$3D
60F8: 3C          inc  a
60F9: 00          nop
60FA: 3F          ccf
60FB: 37          scf
60FC: 3F          ccf
60FD: 00          nop
60FE: 3F          ccf
60FF: 37          scf
6100: 3F          ccf
6101: 00          nop
6102: 3F          ccf
6103: 37          scf
6104: 3F          ccf
6105: 00          nop
6106: 3F          ccf
6107: 37          scf
6108: 3F          ccf
6109: 00          nop
610A: 3F          ccf
610B: 37          scf
610C: 3F          ccf
610D: 00          nop
610E: 3A FC 38    ld   a,($38FC)
6111: 00          nop
6112: 3B          dec  sp
6113: 3B          dec  sp
6114: 3B          dec  sp
6115: 00          nop
6116: 3B          dec  sp
6117: 3B          dec  sp
6118: 3B          dec  sp
6119: 00          nop
611A: 3B          dec  sp
611B: 3B          dec  sp
611C: 3B          dec  sp
611D: 00          nop
611E: 3B          dec  sp
611F: 3B          dec  sp
6120: 3B          dec  sp
6121: 00          nop
6122: 3B          dec  sp
6123: 3B          dec  sp
6124: 3B          dec  sp
6125: 00          nop
6126: 3E 3D       ld   a,$3D
6128: 3C          inc  a
6129: 00          nop
612A: 3F          ccf
612B: 3F          ccf
612C: 3F          ccf
612D: 00          nop
612E: 21 7D 83    ld   hl,$837D
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
6146: 01 08 00    ld   bc,$0008
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
615C: CD 63 61    call $6163
615F: CD 77 61    call $6177
6162: C9          ret
6163: 21 42 D0    ld   hl,$D042
6166: 11 13 85    ld   de,$8513
6169: 06 07       ld   b,$07
616B: 1A          ld   a,(de)
616C: 77          ld   (hl),a
616D: 23          inc  hl
616E: 77          ld   (hl),a
616F: 23          inc  hl
6170: 77          ld   (hl),a
6171: 23          inc  hl
6172: 23          inc  hl
6173: 13          inc  de
6174: 10 F5       djnz $616B
6176: C9          ret
6177: 21 BC 84    ld   hl,$84BC
617A: 7E          ld   a,(hl)
617B: B7          or   a
617C: C8          ret  z
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
618E: 28 54       jr   z,$61E4
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
61B9: CD F0 61    call $61F0
61BC: CD F0 61    call $61F0
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
61D8: DD 7E 06    ld   a,(ix+$06)
61DB: FE 04       cp   $04
61DD: C0          ret  nz
61DE: 2A BB 85    ld   hl,($85BB)
61E1: 36 FF       ld   (hl),$FF
61E3: C9          ret
61E4: 2A BF 85    ld   hl,($85BF)
61E7: 3E FF       ld   a,$FF
61E9: 77          ld   (hl),a
61EA: 11 05 00    ld   de,$0005
61ED: 19          add  hl,de
61EE: 77          ld   (hl),a
61EF: C9          ret
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
620C: DD 7E 06    ld   a,(ix+$06)
620F: 3D          dec  a
6210: CA 22 62    jp   z,$6222
6213: 3D          dec  a
6214: CA 2B 62    jp   z,$622B
6217: DD 46 07    ld   b,(ix+$07)
621A: 0E 00       ld   c,$00
621C: DD 56 03    ld   d,(ix+character_y_offset_03)
621F: C3 6C 1E    jp   $1E6C
6222: CD CE 62    call $62CE
6225: FD 46 01    ld   b,(iy+$01)
6228: C3 32 62    jp   $6232
622B: CD CE 62    call $62CE
622E: FD 46 01    ld   b,(iy+$01)
6231: 04          inc  b
6232: 0E 00       ld   c,$00
6234: FD 7E 00    ld   a,(iy+$00)
6237: DD 86 03    add  a,(ix+character_y_offset_03)
623A: 57          ld   d,a
623B: DD 7E 08    ld   a,(ix+$08)
623E: 17          rla
623F: D2 6C 1E    jp   nc,$1E6C
6242: 05          dec  b
6243: 05          dec  b
6244: C3 6C 1E    jp   $1E6C
6247: 3A BA 85    ld   a,($85BA)
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
6261: 11 E2 62    ld   de,$62E2
6264: 19          add  hl,de
6265: EB          ex   de,hl
6266: 0E 00       ld   c,$00
6268: 3A BA 85    ld   a,($85BA)
626B: B7          or   a
626C: C8          ret  z
626D: DD 7E 0C    ld   a,(ix+$0c)
6270: FE 0D       cp   $0D
6272: 28 1B       jr   z,$628F
6274: DD 7E 06    ld   a,(ix+$06)
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
629C: 3A BA 85    ld   a,($85BA)
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
62CE: D9          exx
62CF: DD 7E 08    ld   a,(ix+$08)
62D2: E6 7F       and  $7F
62D4: 87          add  a,a
62D5: 87          add  a,a
62D6: 87          add  a,a
62D7: 16 00       ld   d,$00
62D9: 5F          ld   e,a
62DA: FD 21 7D 83 ld   iy,$837D
62DE: FD 19       add  iy,de
62E0: D9          exx
62E1: C9          ret
62E2: FB          ei
62E3: 00          nop
62E4: 00          nop
62E5: 40          ld   b,b
62E6: FB          ei
62E7: 10 00       djnz $62E9
62E9: 4E          ld   c,(hl)
62EA: FB          ei
62EB: 00          nop
62EC: 00          nop
62ED: 41          ld   b,c
62EE: FA 10 00    jp   m,$0010
62F1: 4E          ld   c,(hl)
62F2: FA 00 00    jp   m,$0000
62F5: 42          ld   b,d
62F6: 00          nop
62F7: 00          nop
62F8: 00          nop
62F9: 00          nop
62FA: FB          ei
62FB: FE 00       cp   $00
62FD: 43          ld   b,e
62FE: FB          ei
62FF: 0E 00       ld   c,$00
6301: 4E          ld   c,(hl)
6302: FB          ei
6303: 00          nop
6304: 00          nop
6305: 49          ld   c,c
6306: FB          ei
6307: 10 00       djnz $6309
6309: 4F          ld   c,a
630A: FC 00 00    call m,$0000
630D: 44          ld   b,h
630E: 00          nop
630F: 00          nop
6310: 00          nop
6311: 00          nop
6312: FD          db   $fd
6313: 00          nop
6314: 03          inc  bc
6315: 44          ld   b,h
6316: 00          nop
6317: 00          nop
6318: 00          nop
6319: 00          nop
631A: FB          ei
631B: 08          ex   af,af'
631C: 00          nop
631D: 45          ld   b,l
631E: 00          nop
631F: 00          nop
6320: 00          nop
6321: 00          nop
6322: FB          ei
6323: 08          ex   af,af'
6324: 00          nop
6325: 46          ld   b,(hl)
6326: 00          nop
6327: 00          nop
6328: 00          nop
6329: 00          nop
632A: 00          nop
632B: 00          nop
632C: 00          nop
632D: 00          nop
632E: 00          nop
632F: 00          nop
6330: 00          nop
6331: 00          nop
6332: FD          db   $fd
6333: 00          nop
6334: 00          nop
6335: 4A          ld   c,d
6336: 00          nop
6337: 00          nop
6338: 00          nop
6339: 00          nop
633A: FC 00 00    call m,$0000
633D: 47          ld   b,a
633E: 00          nop
633F: 00          nop
6340: 00          nop
6341: 00          nop
6342: FC 00 00    call m,$0000
6345: 48          ld   c,b
6346: 00          nop
6347: 00          nop
6348: 00          nop
6349: 00          nop
634A: FD          db   $fd
634B: 00          nop
634C: 00          nop
634D: 4B          ld   c,e
634E: 00          nop
634F: 00          nop
6350: 00          nop
6351: 00          nop
6352: FD 7E 00    ld   a,(iy+$00)
6355: B7          or   a
6356: C8          ret  z
6357: DD 7E 06    ld   a,(ix+$06)
635A: B7          or   a
635B: C3 D2 63    jp   $63D2
635E: FD 7E 00    ld   a,(iy+$00)
6361: C9          ret
6362: FE 00       cp   $00
6364: 01 40 FE    ld   bc,$FE40
6367: 10 01       djnz $636A
6369: 4E          ld   c,(hl)
636A: FE 00       cp   $00
636C: 01 41 FF    ld   bc,$FF41
636F: 10 01       djnz $6372
6371: 4E          ld   c,(hl)
6372: FF          rst  $38
6373: 00          nop
6374: 01 42 00    ld   bc,$0042
6377: 00          nop
6378: 00          nop
6379: 00          nop
637A: FE FE       cp   $FE
637C: 01 43 FE    ld   bc,$FE43
637F: 0E 01       ld   c,$01
6381: 4E          ld   c,(hl)
6382: FE 00       cp   $00
6384: 01 49 FE    ld   bc,$FE49
6387: 10 01       djnz $638A
6389: 4F          ld   c,a
638A: FD          db   $fd
638B: 00          nop
638C: 01 44 00    ld   bc,$0044
638F: 00          nop
6390: 00          nop
6391: 00          nop
6392: FC 00 02    call m,$0200
6395: 44          ld   b,h
6396: 00          nop
6397: 00          nop
6398: 00          nop
6399: 00          nop
639A: FE 08       cp   $08
639C: 01 45 00    ld   bc,$0045
639F: 00          nop
63A0: 00          nop
63A1: 00          nop
63A2: FE 08       cp   $08
63A4: 01 46 00    ld   bc,$0046
63A7: 00          nop
63A8: 00          nop
63A9: 00          nop
63AA: 00          nop
63AB: 00          nop
63AC: 00          nop
63AD: 00          nop
63AE: 00          nop
63AF: 00          nop
63B0: 00          nop
63B1: 00          nop
63B2: FC 00 01    call m,$0100
63B5: 4A          ld   c,d
63B6: 00          nop
63B7: 00          nop
63B8: 00          nop
63B9: 00          nop
63BA: FD          db   $fd
63BB: 00          nop
63BC: 01 47 00    ld   bc,$0047
63BF: 00          nop
63C0: 00          nop
63C1: 00          nop
63C2: FD          db   $fd
63C3: 00          nop
63C4: 01 48 00    ld   bc,$0048
63C7: 00          nop
63C8: 00          nop
63C9: 00          nop
63CA: FC 00 01    call m,$0100
63CD: 4B          ld   c,e
63CE: 00          nop
63CF: 00          nop
63D0: 00          nop
63D1: 00          nop
63D2: C2 08 46    jp   nz,$4608
63D5: DD 7E 03    ld   a,(ix+character_y_offset_03)
63D8: FE 07       cp   $07
63DA: D8          ret  c
63DB: C3 08 46    jp   $4608
63DE: DD 7E 03    ld   a,(ix+character_y_offset_03)
63E1: D8          ret  c
63E2: FB          ei
63E3: 00          nop
63E4: 00          nop
63E5: 50          ld   d,b
63E6: FB          ei
63E7: 10 00       djnz $63E9
63E9: 5E          ld   e,(hl)
63EA: FB          ei
63EB: 00          nop
63EC: 00          nop
63ED: 51          ld   d,c
63EE: FA 10 00    jp   m,$0010
63F1: 5E          ld   e,(hl)
63F2: FA 00 00    jp   m,$0000
63F5: 52          ld   d,d
63F6: 00          nop
63F7: 00          nop
63F8: 00          nop
63F9: 00          nop
63FA: FB          ei
63FB: FE 00       cp   $00
63FD: 53          ld   d,e
63FE: FB          ei
63FF: 0E 00       ld   c,$00
6401: 5E          ld   e,(hl)
6402: FB          ei
6403: 00          nop
6404: 00          nop
6405: 59          ld   e,c
6406: FB          ei
6407: 10 00       djnz $6409
6409: 5F          ld   e,a
640A: FC 00 00    call m,$0000
640D: 54          ld   d,h
640E: 00          nop
640F: 00          nop
6410: 00          nop
6411: 00          nop
6412: FD          db   $fd
6413: 00          nop
6414: 03          inc  bc
6415: 54          ld   d,h
6416: 00          nop
6417: 00          nop
6418: 00          nop
6419: 00          nop
641A: FB          ei
641B: 08          ex   af,af'
641C: 00          nop
641D: 55          ld   d,l
641E: 00          nop
641F: 00          nop
6420: 00          nop
6421: 00          nop
6422: FB          ei
6423: 08          ex   af,af'
6424: 00          nop
6425: 56          ld   d,(hl)
6426: 00          nop
6427: 00          nop
6428: 00          nop
6429: 00          nop
642A: F6 00       or   $00
642C: 00          nop
642D: 5D          ld   e,l
642E: 06 00       ld   b,$00
6430: 00          nop
6431: 5C          ld   e,h
6432: FD          db   $fd
6433: 00          nop
6434: 00          nop
6435: 5A          ld   e,d
6436: 00          nop
6437: 00          nop
6438: 00          nop
6439: 00          nop
643A: FC 00 00    call m,$0000
643D: 57          ld   d,a
643E: 00          nop
643F: 00          nop
6440: 00          nop
6441: 00          nop
6442: FC 00 00    call m,$0000
6445: 58          ld   e,b
6446: 00          nop
6447: 00          nop
6448: 00          nop
6449: 00          nop
644A: FD          db   $fd
644B: 00          nop
644C: 00          nop
644D: 5B          ld   e,e
644E: 00          nop
644F: 00          nop
6450: 00          nop
6451: 00          nop
6452: FA 01 FF    jp   m,$FF01
6455: 00          nop
6456: 19          add  hl,de
6457: 00          nop
6458: 00          nop
6459: 01 6D 00    ld   bc,$006D
645C: A7          and  a
645D: 00          nop
645E: 53          ld   d,e
645F: 00          nop
6460: 0A          ld   a,(bc)
6461: 00          nop
6462: FE 00       cp   $00
6464: 01 50 FE    ld   bc,$FE50
6467: 10 01       djnz $646A
6469: 5E          ld   e,(hl)
646A: FE 00       cp   $00
646C: 01 51 FF    ld   bc,$FF51
646F: 10 01       djnz $6472
6471: 5E          ld   e,(hl)
6472: FF          rst  $38
6473: 00          nop
6474: 01 52 00    ld   bc,$0052
6477: 00          nop
6478: 00          nop
6479: 00          nop
647A: FE FE       cp   $FE
647C: 01 53 FE    ld   bc,$FE53
647F: 0E 01       ld   c,$01
6481: 5E          ld   e,(hl)
6482: FE 00       cp   $00
6484: 01 59 FE    ld   bc,$FE59
6487: 10 01       djnz $648A
6489: 5F          ld   e,a
648A: FD          db   $fd
648B: 00          nop
648C: 01 54 00    ld   bc,$0054
648F: 00          nop
6490: 00          nop
6491: 00          nop
6492: FC 00 02    call m,$0200
6495: 54          ld   d,h
6496: 00          nop
6497: 00          nop
6498: 00          nop
6499: 00          nop
649A: FE 08       cp   $08
649C: 01 55 00    ld   bc,$0055
649F: 00          nop
64A0: 00          nop
64A1: 00          nop
64A2: FE 08       cp   $08
64A4: 01 56 00    ld   bc,$0056
64A7: 00          nop
64A8: 00          nop
64A9: 00          nop
64AA: FD          db   $fd
64AB: 00          nop
64AC: 01 5C 0D    ld   bc,$0D5C
64AF: 00          nop
64B0: 01 5D FC    ld   bc,$FC5D
64B3: 00          nop
64B4: 01 5A 00    ld   bc,$005A
64B7: 00          nop
64B8: 00          nop
64B9: 00          nop
64BA: FD          db   $fd
64BB: 00          nop
64BC: 01 57 00    ld   bc,$0057
64BF: 00          nop
64C0: 00          nop
64C1: 00          nop
64C2: FD          db   $fd
64C3: 00          nop
64C4: 01 58 00    ld   bc,$0058
64C7: 00          nop
64C8: 00          nop
64C9: 00          nop
64CA: FC 00 01    call m,$0100
64CD: 5B          ld   e,e
64CE: 00          nop
64CF: 00          nop
64D0: 00          nop
64D1: 00          nop
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
6514: C2 31 65    jp   nz,$6531
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
6535: 21 0E D4    ld   hl,$D40E
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
6594: 21 D6 6B    ld   hl,$6BD6
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
65FA: 01 08 00    ld   bc,$0008
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
6643: DD 6E 06    ld   l,(ix+$06)
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
66CA: FD 21 7F 67 ld   iy,$677F
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
677F: DF          rst  $18
6780: 66          ld   h,(hl)
6781: EC 66 05    call pe,$0566
6784: 67          ld   h,a
6785: 1E 67       ld   e,$67
6787: 40          ld   b,b
6788: 67          ld   h,a
6789: EC 66 05    call pe,$0566
678C: 67          ld   h,a
678D: 1E 67       ld   e,$67
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
67B3: FD 21 CA 67 ld   iy,$67CA
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
67CA: 1F          rra
67CB: 00          nop
67CC: 23          inc  hl
67CD: 00          nop
67CE: 27          daa
67CF: 00          nop
67D0: 2B          dec  hl
67D1: 00          nop
67D2: 2F          cpl
67D3: 33          inc  sp
67D4: 37          scf
67D5: 00          nop
67D6: 00          nop
67D7: 00          nop
67D8: 3B          dec  sp
67D9: 3F          ccf
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
6885: CD D6 68    call $68D6
6888: CD B9 6B    call $6BB9
688B: 09          add  hl,bc
688C: 1A          ld   a,(de)
688D: 4F          ld   c,a
688E: FD 7E 01    ld   a,(iy+$01)
6891: E6 0F       and  $0F
6893: CD D6 68    call $68D6
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
68B0: CD B9 6B    call $6BB9
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
6967: 21 48 6A    ld   hl,$6A48
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
6987: 18 4A       jr   $69D3
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
69A6: 18 2B       jr   $69D3
69A8: CD CB 6A    call $6ACB
69AB: 30 0D       jr   nc,$69BA
69AD: DD 6E 02    ld   l,(ix+$02)
69B0: 26 00       ld   h,$00
69B2: FD 75 01    ld   (iy+$01),l
69B5: FD CB 00 AE res  5,(iy+$00)
69B9: 19          add  hl,de
69BA: 18 17       jr   $69D3
69BC: CD 0E 6B    call $6B0E
69BF: 18 12       jr   $69D3
69C1: CD 0E 6B    call $6B0E
69C4: 18 0D       jr   $69D3
69C6: CD 51 6B    call $6B51
69C9: 18 08       jr   $69D3
69CB: CD 51 6B    call $6B51
69CE: 18 03       jr   $69D3
69D0: CD 7E 6B    call $6B7E
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
6A48: 87          add  a,a
6A49: 69          ld   l,c
6A4A: 89          adc  a,c
6A4B: 69          ld   l,c
6A4C: A8          xor  b
6A4D: 69          ld   l,c
6A4E: BC          cp   h
6A4F: 69          ld   l,c
6A50: C1          pop  bc
6A51: 69          ld   l,c
6A52: C6 69       add  a,$69
6A54: CB 69       bit  5,c
6A56: D0          ret  nc
6A57: 69          ld   l,c
6A58: E5          push hl
6A59: D5          push de
6A5A: 79          ld   a,c
6A5B: E6 0F       and  $0F
6A5D: 5F          ld   e,a
6A5E: 16 00       ld   d,$00
6A60: 21 7D 6A    ld   hl,$6A7D
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

6A83: 01 10 00    ld   bc,$0010
6A86: 00          nop
6A87: 01 10 10    ld   bc,$1010
6A8A: 10 00       djnz $6A8C
6A8C: 01 EB FD    ld   bc,$FDEB
6A8F: 4E          ld   c,(hl)
6A90: 01 06 00    ld   bc,$0006
6A93: FD CB 00 6E bit  5,(iy+$00)
6A97: 28 02       jr   z,$6A9B
6A99: 06 FF       ld   b,$FF
6A9B: C5          push bc
6A9C: CD B9 6B    call $6BB9
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
6ADA: CD B9 6B    call $6BB9
6ADD: 09          add  hl,bc
6ADE: EB          ex   de,hl
6ADF: E1          pop  hl
6AE0: DD 7E 01    ld   a,(ix+character_x_right_01)
6AE3: E6 0F       and  $0F
6AE5: 4F          ld   c,a
6AE6: 06 00       ld   b,$00
6AE8: CD B9 6B    call $6BB9
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
6B19: CD B9 6B    call $6BB9
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
6B38: CD B9 6B    call $6BB9
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
6B90: CD D6 68    call $68D6
6B93: CD B9 6B    call $6BB9
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
6BB3: CD D6 68    call $68D6
6BB6: EB          ex   de,hl
6BB7: 09          add  hl,bc
6BB8: C9          ret
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

70EB: 31 00 88    ld   sp,$8800
70EE: 3E 01       ld   a,$01
70F0: 32 EA 82    ld   ($82EA),a
70F3: CD 3A 71    call $713A
70F6: 3E 00       ld   a,state_unknown_00
70F8: 32 AC 80    ld   (game_state_80AC),a
70FB: 3E 20       ld   a,$20
70FD: 32 0E D5    ld   ($D50E),a
7100: 32 4D 82    ld   ($824D),a
7103: 3E C0       ld   a,$C0
7105: 32 0B D5    ld   ($D50B),a
7108: CD 4D 36    call $364D
710B: 21 5A 71    ld   hl,$715A
710E: 11 EE C5    ld   de,$C5EE
7111: CD F9 29    call copy_bytes_to_screen_29F9
7114: 3E 5A       ld   a,$5A
7116: 32 C5 85    ld   ($85C5),a
7119: CD C2 26    call $26C2
711C: CD CF 73    call $73CF
711F: 3A 0C D4    ld   a,($D40C)
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
7142: 22 0E D4    ld   ($D40E),hl
7145: AF          xor  a
7146: 32 36 82    ld   ($8236),a
7149: CD E1 71    call $71E1
714C: 3E 01       ld   a,$01
714E: 32 D9 81    ld   ($81D9),a
7151: CD 0C 26    call $260C
7154: 3E 02       ld   a,$02
7156: 32 A9 80    ld   ($80A9),a
7159: C9          ret
715A: 31 2C 1B    ld   sp,$1B2C
715D: 31 FF CD    ld   sp,$CDFF
7160: 9A          sbc  a,d
7161: 71          ld   (hl),c
7162: CD 50 72    call $7250
7165: 21 A3 80    ld   hl,$80A3
7168: 7E          ld   a,(hl)
7169: 23          inc  hl
716A: B6          or   (hl)
716B: C2 40 29    jp   nz,$2940
716E: CD C2 26    call $26C2
7171: CD 61 72    call $7261
7174: CD 00 74    call $7400
7177: 3A A2 80    ld   a,($80A2)
717A: B7          or   a
717B: C0          ret  nz
717C: 21 A3 80    ld   hl,$80A3
717F: 7E          ld   a,(hl)
7180: 23          inc  hl
7181: B6          or   (hl)
7182: C2 40 29    jp   nz,$2940
7185: 21 3F 86    ld   hl,$863F
7188: 34          inc  (hl)
7189: 7E          ld   a,(hl)
718A: FE 08       cp   $08
718C: 38 E3       jr   c,$7171
718E: 36 00       ld   (hl),$00
7190: 23          inc  hl
7191: 34          inc  (hl)
7192: 7E          ld   a,(hl)
7193: FE 5A       cp   $5A
7195: 38 DA       jr   c,$7171
7197: C3 40 29    jp   $2940
719A: AF          xor  a
719B: 32 36 82    ld   ($8236),a
719E: CD E1 71    call $71E1
71A1: 3E 01       ld   a,$01
71A3: 32 D9 81    ld   ($81D9),a
71A6: CD 0C 26    call $260C
71A9: 3E 01       ld   a,state_title_01
71AB: 32 AC 80    ld   (game_state_80AC),a
71AE: 3E 01       ld   a,$01
71B0: 32 A9 80    ld   ($80A9),a
71B3: CD 39 58    call $5839
71B6: CD C6 57    call $57C6
71B9: CD B0 10    call $10B0
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
71E1: 3A 4E 82    ld   a,($824E)
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
71F9: 3A 50 82    ld   a,($8250)
71FC: 21 0F 72    ld   hl,$720F
71FF: CB 6F       bit  5,a
7201: 28 03       jr   z,$7206
7203: 21 38 72    ld   hl,$7238
7206: 11 44 C7    ld   de,$C744
7209: 01 18 00    ld   bc,$0018
720C: ED B0       ldir
720E: C9          ret
720F: 24          inc  h
7210: 00          nop
7211: 31 1C 2C    ld   sp,$2C1C
7214: 31 2F 00    ld   sp,$002F
7217: 2E 2F       ld   l,$2F
7219: 1F          rra
721A: 1A          ld   a,(de)
721B: 06 00       ld   b,$00
721D: 20 2E       jr   nz,$724D
721F: 20 1B       jr   nz,$723C
7221: 21 21 21    ld   hl,$2121
7224: 2C          inc  l
7225: 2C          inc  l
7226: 2C          inc  l
7227: 4F          ld   c,a
7228: 7E          ld   a,(hl)
7229: F6 C0       or   $C0
722B: B9          cp   c
722C: 32 0D D5    ld   ($D50D),a
722F: 28 F7       jr   z,$7228
7231: 78          ld   a,b
7232: 32 46 82    ld   ($8246),a
7235: DD E5       push ix
7237: C9          ret

7250: 21 00 00    ld   hl,$0000
7253: 22 3F 86    ld   ($863F),hl
7256: 21 2F 86    ld   hl,$862F
7259: 06 10       ld   b,$10
725B: 36 00       ld   (hl),$00
725D: 23          inc  hl
725E: 10 FB       djnz $725B
7260: C9          ret
7261: CD AF 72    call $72AF
7264: 21 08 CC    ld   hl,$CC08
7267: 22 09 86    ld   ($8609),hl
726A: 21 61 73    ld   hl,$7361
726D: 22 0B 86    ld   ($860B),hl
7270: 21 0F 86    ld   hl,$860F
7273: 22 0D 86    ld   ($860D),hl
7276: 11 2F 86    ld   de,$862F
7279: 06 08       ld   b,$08
727B: 1A          ld   a,(de)
727C: 32 08 86    ld   ($8608),a
727F: 13          inc  de
7280: 1A          ld   a,(de)
7281: 32 07 86    ld   ($8607),a
7284: 13          inc  de
7285: D5          push de
7286: C5          push bc
7287: CD 34 73    call $7334
728A: CD A5 73    call $73A5
728D: 2A 09 86    ld   hl,($8609)
7290: 23          inc  hl
7291: 23          inc  hl
7292: 22 09 86    ld   ($8609),hl
7295: 2A 0B 86    ld   hl,($860B)
7298: 11 08 00    ld   de,$0008
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
72AF: 3A 40 86    ld   a,($8640)
72B2: 4F          ld   c,a
72B3: 11 2F 86    ld   de,$862F
72B6: 21 D2 72    ld   hl,$72D2
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
72D4: 01 00 15    ld   bc,$1500
72D7: FF          rst  $38
72D8: 1F          rra
72D9: 02          ld   (bc),a
72DA: 26 00       ld   h,$00
72DC: 31 FF FF    ld   sp,$FFFF
72DF: 00          nop
72E0: 02          ld   (bc),a
72E1: 00          nop
72E2: 16 FF       ld   d,$FF
72E4: 1F          rra
72E5: 01 FF 00    ld   bc,$00FF
72E8: FF          rst  $38
72E9: 00          nop
72EA: FF          rst  $38
72EB: 00          nop
72EC: 03          inc  bc
72ED: 00          nop
72EE: 17          rla
72EF: FF          rst  $38
72F0: 21 02 26    ld   hl,$2602
72F3: 00          nop
72F4: 31 FF FF    ld   sp,$FFFF
72F7: 00          nop
72F8: 04          inc  b
72F9: 00          nop
72FA: 18 FF       jr   $72FB
72FC: 21 01 FF    ld   hl,$FF01
72FF: 00          nop
7300: FF          rst  $38
7301: 00          nop
7302: FF          rst  $38
7303: 00          nop
7304: 05          dec  b
7305: 00          nop
7306: 19          add  hl,de
7307: FF          rst  $38
7308: 23          inc  hl
7309: 02          ld   (bc),a
730A: 26 00       ld   h,$00
730C: 31 FF FF    ld   sp,$FFFF
730F: 00          nop
7310: 06 00       ld   b,$00
7312: 1A          ld   a,(de)
7313: FF          rst  $38
7314: 23          inc  hl
7315: 01 FF 00    ld   bc,$00FF
7318: FF          rst  $38
7319: 00          nop
731A: FF          rst  $38
731B: 00          nop
731C: 07          rlca
731D: 00          nop
731E: 1B          dec  de
731F: FF          rst  $38
7320: 25          dec  h
7321: 02          ld   (bc),a
7322: 26 00       ld   h,$00
7324: 31 FF FF    ld   sp,$FFFF
7327: 00          nop
7328: 08          ex   af,af'
7329: 00          nop
732A: 1C          inc  e
732B: FF          rst  $38
732C: 25          dec  h
732D: 01 FF 00    ld   bc,$00FF
7330: FF          rst  $38
7331: 00          nop
7332: FF          rst  $38
7333: 00          nop
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

73A4: F9          ld   sp,hl
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

73CF: CD EA 0F    call $0FEA
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
73EC: 21 C6 85    ld   hl,$85C6
73EF: 4E          ld   c,(hl)
73F0: 09          add  hl,bc
73F1: 77          ld   (hl),a
73F2: 3A AB 80    ld   a,($80AB)
73F5: B7          or   a
73F6: 20 FA       jr   nz,$73F2
73F8: C9          ret

73F9: 1E 12       ld   e,$12
73FB: 08          ex   af,af'
73FC: 1D          dec  e
73FD: 02          ld   (bc),a
73FE: 08          ex   af,af'
73FF: 5E          ld   e,(hl)
7400: CD EA 0F    call $0FEA
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
7419: 3A D6 81    ld   a,($81D6)
741C: E6 07       and  $07
741E: 4F          ld   c,a
741F: 06 00       ld   b,$00
7421: EF          rst  $28
7422: 21 F8 73    ld   hl,$73F8
7425: 09          add  hl,bc
7426: AE          xor  (hl)
7427: 28 C9       jr   z,$73F2
7429: E1          pop  hl
742A: C1          pop  bc
742B: D1          pop  de
742C: DD E1       pop  ix
742E: DD E9       jp   (ix)
7430: CD 37 74    call $7437
7433: CD 75 74    call $7475
7436: C9          ret


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

7475: 3A 40 86    ld   a,($8640)
7478: 21 98 74    ld   hl,$7498
747B: BE          cp   (hl)
747C: CA 03 75    jp   z,$7503
747F: 23          inc  hl
7480: BE          cp   (hl)
7481: 28 1C       jr   z,$749F
7483: 23          inc  hl
7484: BE          cp   (hl)
7485: 28 20       jr   z,$74A7
7487: 23          inc  hl
7488: BE          cp   (hl)
7489: 28 24       jr   z,$74AF
748B: 23          inc  hl
748C: BE          cp   (hl)
748D: 28 40       jr   z,$74CF
748F: 23          inc  hl
7490: BE          cp   (hl)
7491: 28 24       jr   z,$74B7
7493: 23          inc  hl
7494: BE          cp   (hl)
7495: 28 4E       jr   z,$74E5
7497: C9          ret

7498: 30 32       jr   nc,$74CC
749A: 36 3A       ld   (hl),$3A
749C: 3E 42       ld   a,$42
749E: 46          ld   b,(hl)
749F: 21 17 75    ld   hl,$7517
74A2: 11 E6 C9    ld   de,$C9E6
74A5: 18 16       jr   $74BD
74A7: 21 29 75    ld   hl,$7529
74AA: 11 E9 C9    ld   de,$C9E9
74AD: 18 0E       jr   $74BD
74AF: 21 3B 75    ld   hl,$753B
74B2: 11 EC C9    ld   de,$C9EC
74B5: 18 06       jr   $74BD
74B7: 21 59 75    ld   hl,$7559
74BA: 11 F1 C9    ld   de,$C9F1
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
74CF: 21 4D 75    ld   hl,$754D
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
74E5: 21 6B 75    ld   hl,$756B
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
7517: 9E          sbc  a,(hl)
7518: B5          or   l
7519: 00          nop
751A: C8          ret  z
751B: C9          ret
751C: CA DC DD    jp   z,$DDDC
751F: DE F0       sbc  a,$F0
7521: F1          pop  af
7522: F2 53 54    jp   p,$5453
7525: 55          ld   d,l
7526: 66          ld   h,(hl)
7527: 67          ld   h,a
7528: 68          ld   l,b
7529: B7          or   a
752A: B8          cp   b
752B: B9          cp   c
752C: CB CC       set  1,h
752E: CD DF E0    call $E0DF
7531: E1          pop  hl
7532: F3          di
7533: F4 F5 56    call p,$56F5
7536: 57          ld   d,a
7537: 58          ld   e,b
7538: 69          ld   l,c
7539: 6A          ld   l,d
753A: 6B          ld   l,e
753B: BA          cp   d
753C: BB          cp   e
753D: BC          cp   h
753E: CE CF       adc  a,$CF
7540: D0          ret  nc
7541: E2 E3 E4    jp   po,$E4E3
7544: F6 F7       or   $F7
7546: 00          nop
7547: 59          ld   e,c
7548: 5A          ld   e,d
7549: 00          nop
754A: 6C          ld   l,h
754B: 6D          ld   l,l
754C: 6E          ld   l,(hl)
754D: BD          cp   l
754E: BE          cp   (hl)
754F: D1          pop  de
7550: D2 E5 E6    jp   nc,$E6E5
7553: E5          push hl
7554: E6 5B       and  $5B
7556: 5C          ld   e,h
7557: 6F          ld   l,a
7558: 70          ld   (hl),b
7559: BF          cp   a
755A: C0          ret  nz
755B: C1          pop  bc
755C: D3 D4       out  ($D4),a
755E: D5          push de
755F: E7          rst  $20
7560: E8          ret  pe
7561: E9          jp   (hl)
7562: FA FB FC    jp   m,$FCFB
7565: 5D          ld   e,l
7566: 5E          ld   e,(hl)
7567: 5F          ld   e,a
7568: 71          ld   (hl),c
7569: 72          ld   (hl),d
756A: 73          ld   (hl),e
756B: 7A          ld   a,d
756C: 7B          ld   a,e
756D: 7C          ld   a,h
756E: 7D          ld   a,l
756F: 7E          ld   a,(hl)
7570: 00          nop
7571: 7F          ld   a,a
7572: B6          or   (hl)
7573: 52          ld   d,d
7574: 65          ld   h,l
7575: 79          ld   a,c
7576: 00          nop
7577: C2 C3 C4    jp   nz,$C4C3
757A: C5          push bc
757B: C6 C7       add  a,$C7
757D: D6 D7       sub  $D7
757F: D8          ret  c
7580: D9          exx
7581: DA DB EA    jp   c,$EADB
7584: EB          ex   de,hl
7585: EC ED EE    call pe,$EEED
7588: EF          rst  $28
7589: FD          db   $fd
758A: FE FF       cp   $FF
758C: 50          ld   d,b
758D: 51          ld   d,c
758E: 00          nop
758F: 60          ld   h,b
7590: 61          ld   h,c
7591: 62          ld   h,d
7592: 63          ld   h,e
7593: 64          ld   h,h
7594: 00          nop
7595: 74          ld   (hl),h
7596: 75          ld   (hl),l
7597: 76          halt
7598: 77          ld   (hl),a
7599: 78          ld   a,b
759A: 00          nop
759B: CD 60 76    call $7660
759E: CD 7A 76    call $767A
75A1: AF          xor  a
75A2: 32 41 86    ld   ($8641),a

75A5: CD A2 76    call $76A2
75A8: CD CF 73    call $73CF
75AB: 3A 3B 82    ld   a,($823B)
75AE: B7          or   a
75AF: 28 05       jr   z,$75B6
75B1: 3A A2 80    ld   a,($80A2)
75B4: B7          or   a
75B5: C0          ret  nz
75B6: DD 21 1A 85 ld   ix,player_structure_851A
75BA: CD E8 75    call $75E8
75BD: DD 7E 09    ld   a,(ix+$09)
75C0: FE FF       cp   $FF
75C2: CA FE 75    jp   z,$75FE
75C5: FE 05       cp   $05
75C7: D2 A5 75    jp   nc,$75A5
75CA: DD 7E 06    ld   a,(ix+$06)
75CD: FE 02       cp   $02
75CF: D2 A5 75    jp   nc,$75A5

75DF: DD 7E 07    ld   a,(ix+$07)
75E2: B7          or   a
75E3: 20 C0       jr   nz,$75A5
75E5: C3 4E 76    jp   $764E
75E8: DD 7E 09    ld   a,(ix+$09)
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
7620: 3A 48 86    ld   a,($8648)
7623: EE 99       xor  $99
7625: E7          rst  $20
7626: 01 00 20    ld   bc,$2000
7629: 0B          dec  bc
762A: 78          ld   a,b
762B: B1          or   c
762C: 20 FB       jr   nz,$7629
762E: 3E C0       ld   a,$C0
7630: 32 0B D5    ld   ($D50B),a
7633: 3A 21 85    ld   a,($8521)
7636: FE 05       cp   $05
7638: D2 3D 76    jp   nc,$763D
763B: 3E 05       ld   a,$05
763D: 32 2C 80    ld   ($802C),a
7640: 3A 50 82    ld   a,($8250)
7643: CB 77       bit  6,a
7645: 20 04       jr   nz,$764B
7647: 21 34 82    ld   hl,nb_lives_8234
764A: 35          dec  (hl)
764B: 3E 01       ld   a,$01
764D: C9          ret
764E: CD A3 09    call $09A3
7651: F5          push af
7652: 3E C0       ld   a,$C0
7654: 32 0B D5    ld   ($D50B),a
7657: F1          pop  af
7658: B7          or   a
7659: C8          ret  z
765A: CD 3F 36    call $363F
765D: C3 9E 75    jp   $759E
7660: CD E1 71    call $71E1
7663: AF          xor  a
7664: 32 D9 81    ld   ($81D9),a
7667: CD 0C 26    call $260C
766A: CD 2E 58    call $582E
766D: CD B3 28    call $28B3
7670: CD 68 2A    call $2A68
7673: CD 93 57    call $5793
7676: CD 72 2F    call $2F72
7679: C9          ret
767A: AF          xor  a
767B: 32 AB 80    ld   ($80AB),a
767E: CD DC 0B    call $0BDC
7681: CD 3A 2F    call $2F3A
7684: CD 95 4B    call $4B95
7687: CD AD 31    call $31AD
768A: CD 87 12    call $1287
768D: CD 93 57    call $5793
7690: CD CA 30    call $30CA
7693: 3A 33 82    ld   a,($8233)
7696: 32 A9 80    ld   ($80A9),a
7699: 3E 05       ld   a,state_ingame_05
769B: 32 AC 80    ld   (game_state_80AC),a
769E: CD C2 26    call $26C2
76A1: C9          ret

76A2: CD CF 30    call handle_player_30CF
76A5: CD 7F 01    call handle_main_scrolling_017F
76A8: CD BF 0E    call handle_elevators_0EBF
76AB: CD A2 12    call handle_enemies_12A2
76AE: CD BA 31    call shot_lamp_collision_31BA
76B1: CD 68 0B    call $0B68
76B4: CD E8 2F    call $2FE8
76B7: CD 27 31    call $3127
76BA: CD 81 30    call $3081
76BD: CD BA 4B    call $4BBA
76C0: CD E1 0B    call $0BE1
76C3: CD A0 15    call $15A0
76C6: C9          ret

76C7: CD 2F 57    call $572F
76CA: 3E C0       ld   a,$C0
76CC: 32 0B D5    ld   ($D50B),a
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
76E4: CD C2 26    call $26C2
76E7: CD CF 73    call $73CF
76EA: 2A 43 86    ld   hl,($8643)
76ED: 2B          dec  hl
76EE: 22 43 86    ld   ($8643),hl
76F1: 7C          ld   a,h
76F2: B5          or   l
76F3: 20 F2       jr   nz,$76E7
76F5: C9          ret

76F6: AF          xor  a
76F7: 32 AB 80    ld   ($80AB),a
76FA: CD E1 71    call $71E1
76FD: 3E 01       ld   a,$01
76FF: 32 D9 81    ld   ($81D9),a
7702: CD 0C 26    call $260C
7705: 3E 08       ld   a,state_game_over_08
7707: 32 AC 80    ld   (game_state_80AC),a
770A: 3E 02       ld   a,$02
770C: 32 A9 80    ld   ($80A9),a
770F: CD 39 58    call $5839
7712: CD C6 57    call $57C6
7715: CD B0 10    call $10B0
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
7738: 21 65 77    ld   hl,$7765
773B: 11 AB C5    ld   de,$C5AB
773E: CD F9 29    call copy_bytes_to_screen_29F9
7741: 3E CA       ld   a,$CA
7743: 32 0B D5    ld   ($D50B),a
7746: 21 78 00    ld   hl,$0078
7749: 22 43 86    ld   ($8643),hl
774C: C9          ret
774D: 21 6F 77    ld   hl,$776F
7750: 11 27 C6    ld   de,$C627
7753: CD F9 29    call copy_bytes_to_screen_29F9
7756: 3A 36 82    ld   a,($8236)
7759: C6 11       add  a,$11
775B: 32 2E C6    ld   ($C62E),a
775E: 21 3C 00    ld   hl,$003C
7761: 22 43 86    ld   ($8643),hl
7764: C9          ret
7765: 28 1C       jr   z,$7783
7767: 20 1E       jr   nz,$7787
7769: 00          nop
776A: 2F          cpl
776B: 23          inc  hl
776C: 1E 1F       ld   e,$1F
776E: FF          rst  $38
776F: 1A          ld   a,(de)
7770: 1B          dec  de
7771: 1C          inc  e
7772: 1D          dec  e
7773: 1E 1F       ld   e,$1F
7775: 04          inc  b
7776: 00          nop
7777: 05          dec  b
7778: 00          nop
7779: 28 1C       jr   z,$7797
777B: 20 1E       jr   nz,$779B
777D: 00          nop
777E: 2F          cpl
777F: 23          inc  hl
7780: 1E 1F       ld   e,$1F
7782: FF          rst  $38
7783: 21 95 77    ld   hl,$7795
7786: 11 CC C5    ld   de,$C5CC
7789: CD F9 29    call copy_bytes_to_screen_29F9
778C: 3A 36 82    ld   a,($8236)
778F: C6 11       add  a,$11
7791: 32 D3 C5    ld   ($C5D3),a
7794: C9          ret
7795: 1A          ld   a,(de)
7796: 1B          dec  de
7797: 1C          inc  e
7798: 1D          dec  e
7799: 1E 1F       ld   e,$1F
779B: 04          inc  b
779C: 00          nop
779D: 05          dec  b
779E: FF          rst  $38
779F: 3A 00 88    ld   a,($8800)
77A2: 3A F4 7F    ld   a,($7FF4)
77A5: 21 47 86    ld   hl,$8647
77A8: 36 00       ld   (hl),$00
77AA: E5          push hl
77AB: CD CF 77    call $77CF
77AE: CD BD 77    call $77BD
77B1: E1          pop  hl
77B2: FE 17       cp   $17
77B4: 3E 58       ld   a,$58
77B6: 77          ld   (hl),a
77B7: CB C7       set  0,a
77B9: 32 48 86    ld   ($8648),a
77BC: C9          ret

77BD: 3A 47 86    ld   a,($8647)
77C0: 21 01 88    ld   hl,$8801
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

77CF: 21 47 86    ld   hl,$8647
77D2: 96          sub  (hl)
77D3: 21 01 88    ld   hl,$8801
77D6: CB 46       bit  0,(hl)
77D8: 28 FC       jr   z,$77D6
77DA: 2B          dec  hl
77DB: 77          ld   (hl),a
77DC: C9          ret

77DD: E6 7F       and  $7F
77DF: F6 40       or   $40
77E1: E7          rst  $20
77E2: C9          ret
