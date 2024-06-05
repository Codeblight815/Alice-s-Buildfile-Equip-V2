.thumb
.equ FairFightID, SkillTester+4

push {r4-r7, lr}
mov r4, r0 @atkr
mov r5, r1 @dfdr

@has FairFight
ldr r0, SkillTester
mov lr, r0
mov r0, r4 @attacker data
ldr r1, FairFightID
.short 0xf800
cmp r0, #0
beq End

@add 20% battle hit on both sides
mov r1, #0x60 
ldrsh r0, [r4, r1] @hit
add r0, #20
strh r0, [r4,r1]
mov r1, #0x62
ldrsh r0, [r4, r1] @avoid
sub r0, #20 
strh r0, [r4,r1]

End:
pop {r4-r7, r15}
.align
.ltorg
SkillTester:
@Poin SkillTester
@WORD FairFightID
