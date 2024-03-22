.equ ProwessIDList, SkillTester+4
.thumb

.macro blh to, reg
	ldr \reg, =\to
	mov lr, \reg
	.short 0xF800
.endm

push	{r4-r7, lr} 
mov		r4,r0 @ r0 = battle struct.

mov		r1, #0x4A
ldrh	r0, [r4, r1]
cmp		r0, #0x00
beq		NoSkill
blh		0x080174EC, r1
blh		0x080177B0, r1
ldrb	r0, [r0, #0x07] @Get Equiped Weapon Type
mov		r5, r0 @Save Weapon Type in r5

ldr		r1,ProwessIDList @Load Prowess Table
ldrb	r1,[r1,r0] @Get corresponding skill
mov		r0,r4 @Load Attacker
ldr		r3,SkillTester
mov		lr, r3
.short	0xf800
cmp		r0, #0
beq		NoSkill

mov		r0, r5
cmp		r0, #0			@Check if is Sword
beq		CheckSword
cmp		r0, #1			@Check if is Lance
beq		CheckLance
cmp		r0, #2			@Check if is Axe
beq		CheckAxe
cmp		r0, #3			@Check if is Bow
beq		CheckBow
cmp		r0, #4			@Check if is Staff
beq		CheckStaff
cmp		r0, #5			@Check if is Anima
beq		CheckAnima
cmp		r0, #6			@Check if is Light
beq		CheckLight
cmp		r0, #7			@Check if is Dark
beq		CheckDark
b 		NoSkill

CheckSword:
mov		r1, #0x28
ldrb	r0, [r4,r1] @Load Sword Rank
b		CheckWeaponRank
CheckLance:
mov		r1, #0x29
ldrb	r0, [r4,r1] @Load Lance Rank
b		CheckWeaponRank
CheckAxe:
mov		r1, #0x2A
ldrb	r0, [r4,r1] @Load Axe Rank
b		CheckWeaponRank
CheckBow:
mov		r1, #0x2B
ldrb	r0, [r4,r1] @Load Bow Rank
b		CheckWeaponRank
CheckStaff:
mov		r1, #0x2C
ldrb	r0, [r4,r1] @Load Staff Rank
b		CheckWeaponRank
CheckAnima:
mov		r1, #0x2D
ldrb	r0, [r4,r1] @Load Anima Rank
b		CheckWeaponRank
CheckLight:
mov		r1, #0x2E
ldrb	r0, [r4,r1] @Load Light Rank
b		CheckWeaponRank
CheckDark:
mov		r1, #0x2F
ldrb	r0, [r4,r1] @Load Dark Rank
b		CheckWeaponRank

CheckWeaponRank:
mov		r1, #251
cmp		r0, r1
bge		SRankBonus @If S Rank, Add +15 Hit/Avo/C. Avo
mov		r1, #181
cmp		r0, r1
bge		ARankBonus @If A Rank, Add +10 Hit/Avo/C. Avo
mov		r1, #121
cmp		r0, r1
bge		BRankBonus @If B Rank, Add +5 Hit/Avo/C. Avo
b 		NoSkill @If C or lower, skip

SRankBonus:
mov		r0,r4
add		r0,#0x60
ldrh	r3,[r0]
add		r3,#0x0F @15 Hit
strh	r3,[r0]
mov		r0,r4
add		r0,#0x62
ldrh	r3,[r0]
add		r3,#0x0F @15 Avo
strh	r3,[r0]
mov		r0,r4
add		r0,#0x68
ldrh	r3,[r0]
add		r3,#0x0F @15 Crit Avo
strh	r3,[r0]
b		NoSkill

ARankBonus:
mov		r0,r4
add		r0,#0x60
ldrh	r3,[r0]
add		r3,#0x0A @10 Hit
strh	r3,[r0]
mov		r0,r4
add		r0,#0x62
ldrh	r3,[r0]
add		r3,#0x0A @10 Avo
strh	r3,[r0]
mov		r0,r4
add		r0,#0x68
ldrh	r3,[r0]
add		r3,#0x0A @10 Crit Avo
strh	r3,[r0]
b		NoSkill

BRankBonus:
mov		r0,r4
add		r0,#0x60
ldrh	r3,[r0]
add		r3,#0x05 @5 Hit
strh	r3,[r0]
mov		r0,r4
add		r0,#0x62
ldrh	r3,[r0]
add		r3,#0x05 @5 Avo
strh	r3,[r0]
mov		r0,r4
add		r0,#0x68
ldrh	r3,[r0]
add		r3,#0x05 @5 Crit Avo
strh	r3,[r0]

NoSkill:
pop		{r4-r7} 
pop		{r0}
bx		r0

.align
.ltorg
SkillTester:
@POIN SkillTester
@POIN ProwessIDList
