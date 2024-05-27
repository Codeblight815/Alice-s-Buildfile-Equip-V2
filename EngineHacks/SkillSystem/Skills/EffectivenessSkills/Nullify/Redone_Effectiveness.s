.thumb

@r0=attacker's item id, r1=defender battle struct

.equ NullifyID, SkillTester+4
.equ WingedShieldID, NullifyID+4
.equ ArmorShieldID, WingedShieldID+4
.equ HorseShieldID, ArmorShieldID+4
.equ DragonShieldID, HorseShieldID+4
.equ FlierType, DragonShieldID+4
.equ ArmorType, FlierType+4
.equ HorseType, ArmorType+4
.equ DragonType, HorseType+4

push	{r4-r7,r14}
mov		r4,r0
mov		r5,r1
ldr		r0,[r5,#0x4]
cmp		r0,#0
beq		RetFalse
mov		r0,r4
ldr		r3,=#0x80176D0		@get effectiveness pointer
mov		r14,r3
.short	0xF800
cmp		r0,#0
beq		RetFalse			@if weapon isn't effective, end
ldr		r1,[r5,#0x4]
mov		r6,#0x50
ldr		r6,[r1,r6]			@class weaknesses


@ used with Dragz's Effectiveness Items
/*
push 	{r0-r3}
mov 	r0,r5
bl 		GetUnitDebuffEntry 
ldr 	r1, =FlammableBitOffset_Link
ldr 	r1, [r1] 
bl 		CheckBit 
cmp		r0,#0
beq		DousedCheck
mov		r2, #0x40
orr		r6, r2

DousedCheck:
mov 	r0,r5
bl 		GetUnitDebuffEntry 
ldr 	r1, =DousedBitOffset_Link
ldr 	r1, [r1] 
bl 		CheckBit 
cmp		r0,#0
beq		LevitatingCheck
mov		r2, #0x80
orr		r6, r2

LevitatingCheck:
mov 	r0,r5
bl 		GetUnitDebuffEntry 
ldr 	r1, =LevitatingBitOffset_Link
ldr 	r1, [r1] 
bl 		CheckBit 
cmp		r0,#0
beq		DebuffEnd
mov		r2, #0x04
orr		r6, r2
DebuffEnd:
pop 	{r0-r3}
*/

cmp		r6,#0
beq		RetFalse			@if class has no weaknesses, end

mov		r4,r0				@save effectiveness ptr
mov		r7,#0				@inventory slot counter
ProtectiveItemsLoop:
lsl		r0,r7,#1
add		r0,#0x1E
ldrh	r0,[r5,r0]
cmp		r0,#0
beq		EffectiveWeaponLoop
mov		r1,#0xFF
and		r0,r1
ldr		r3,=#0x80177B0		@get_item_data
mov		r14,r3
.short	0xF800
ldr		r1,[r0,#0x8]		@weapon abilities
mov		r2,#0x80
lsl		r2,#0x7				@delphi shield bit, aka 'protector item'
tst		r1,r2
beq		NextItem
ldr		r1,[r0,#0x10]		@pointer to classes it protects
cmp		r1,#0
beq		NextItem
ldrh	r1,[r1,#2]
bic		r6,r1				@remove bits that are protected from the class weaknesses bitfield
cmp		r6,#0
beq		RetFalse
NextItem:
add		r7,#1
cmp		r7,#4
ble		ProtectiveItemsLoop

EffectiveWeaponLoop:
ldrh	r1,[r4,#2]			@bitfield of types this weapon is effective against
cmp		r1,#0
beq		RetFalse
and		r1,r6				@see if they have bits in common
cmp		r1,#0
bne		WingedShield
add		r4,#4
b		EffectiveWeaponLoop

WingedShield:
mov     r0,r5               @copy over the defender class
ldr		r1,WingedShieldID   @load the skill ID
ldr		r3,SkillTester      @load the address for skill tester
mov		r14,r3              @load the skill tester address into the link register
.short	0xF800              @navigate to the skill tester address
cmp		r0,#0               @check if the user has the skill (0 means no, 1 means yes)
beq		ArmorShield         @branch elsewhere if they don't have the skill

ldr		r2,[r5,#4]
mov		r1,#0x50
ldrh	r2,[r2,r1]			@weaknesses defender unit has
ldrh 	r0,FlierType
and		r0,r2
cmp		r0,#0
beq		ArmorShield
b		RetFalse            @otherwise, if there's a match, branch to set the effectiveness to 0

ArmorShield:
mov     r0,r5               @copy over the defender class
ldr		r1,ArmorShieldID    @load the skill ID
ldr		r3,SkillTester      @load the address for skill tester
mov		r14,r3              @load the skill tester address into the link register
.short	0xF800              @navigate to the skill tester address
cmp		r0,#0               @check if the user has the skill (0 means no, 1 means yes)
beq		HorseShield         @branch elsewhere if they don't have the skill

ldr		r2,[r5,#4]
mov		r1,#0x50
ldrh	r2,[r2,r1]			@weaknesses defender unit has
ldrh 	r0,ArmorType
and		r0,r2
cmp		r0,#0
beq		HorseShield
b		RetFalse            @otherwise, if there's a match, branch to set the effectiveness to 0

HorseShield:
mov     r0,r5               @copy over the defender class
ldr		r1,HorseShieldID    @load the skill ID
ldr		r3,SkillTester      @load the address for skill tester
mov		r14,r3              @load the skill tester address into the link register
.short	0xF800              @navigate to the skill tester address
cmp		r0,#0               @check if the user has the skill (0 means no, 1 means yes)
beq		DragonShield        @branch elsewhere if they don't have the skill

ldr		r2,[r5,#4]
mov		r1,#0x50
ldrh	r2,[r2,r1]			@weaknesses defender unit has
ldrh 	r0,HorseType
and		r0,r2
cmp		r0,#0
beq		DragonShield
b		RetFalse            @otherwise, if there's a match, branch to set the effectiveness to 0

DragonShield:
mov     r0,r5               @copy over the defender class
ldr		r1,DragonShieldID   @load the skill ID
ldr		r3,SkillTester      @load the address for skill tester
mov		r14,r3              @load the skill tester address into the link register
.short	0xF800              @navigate to the skill tester address
cmp		r0,#0               @check if the user has the skill (0 means no, 1 means yes)
beq		NullifyCheck        @branch elsewhere if they don't have the skill

ldr		r2,[r5,#4]
mov		r1,#0x50
ldrh	r2,[r2,r1]			@weaknesses defender unit has
ldrh 	r0,DragonType
and		r0,r2
cmp		r0,#0
beq		NullifyCheck
b		RetFalse            @otherwise, if there's a match, branch to set the effectiveness to 0

NullifyCheck:
mov		r0,r5
ldr		r1,NullifyID
ldr		r3,SkillTester
mov		r14,r3
.short	0xF800
cmp		r0,#0
bne		RetFalse

ldrb	r0,[r4,#0x1]		@coefficient
b		GoBack
RetFalse:
mov		r0,#0
GoBack:
pop		{r4-r7}
pop		{r1}
bx		r1

.ltorg
SkillTester:
@WORD NullifyID
