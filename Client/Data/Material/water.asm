ps.2.0
dcl v0
dcl v1.xyz
dcl t0.xy
;dcl t1.xy
dcl_2d s0
;dcl_2d s1
texld r0,t0,s0
;texld r1,t1,s1
;add r0,r0,r1
add r0.xyz,r0,v0
mad r0.xyz,v1,r0.w,r0
mov r0.w,v0.w
;texld r0,t1,s1
mov oC0,r0