.thumb
.equ LunarBraceID, SkillTester+4

push {r4-r7,lr}
mov r4, r0 @attacker
mov r5, r1 @defender

@check for Lunar Brace
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @attacker data
ldr r1, LunarBraceID
.short 0xf800
cmp r0, #0
beq End


@and set defender (def or res)=(def or res)*.75
mov r1, #0x5C
ldrh r0, [ r5, r1 ] @Load def/res
mov r2, #0x3 
mul r0,r2 @Multiply def/res by 3
lsr r0,r0,#0x2 @Divide def/res by 4
strh r0, [ r5, r1 ]


cmp r0, #0x7f @damage cap of 127
ble NotDmgCap
mov r0, #0x7f
NotDmgCap:
strh r0, [r7, #4] @final damage

End:
pop {r4-r7}
pop {r15}

.align
.ltorg
SkillTester:
@POIN SkillTester
@WORD LunarBraceID
