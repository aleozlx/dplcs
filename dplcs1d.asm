; Outer-loop initialization
  400ba0:	31 f6                	xor    esi,esi ; i = 0
  400ba8:	44 0f b6 44 35 00    	movzx  r8d,BYTE PTR [rbp+rsi*1+0x0] ; (int)seq1[i] cached in r8

; Inner-loop initialization
  400bae:	31 d2                	xor    edx,edx ; j = 0
  400bb0:	31 c9                	xor    ecx,ecx ; left = 0
  400bb2:	eb 22                	jmp    400bd6 <lcs1d+0x56>
  
; max() inlined
  400bb8:	39 4c 94 14          	cmp    DWORD PTR [rsp+rdx*4+0x14],ecx ; compare dp[j+1], left
  400bbc:	89 c8                	mov    eax,ecx ; current = left
  400bbe:	0f 4d 44 94 14       	cmovge eax,DWORD PTR [rsp+rdx*4+0x14] ; current = dp[j+1] if compare dp[j+1] >= left

; Inner-loop transition
  400bc3:	89 4c 94 10          	mov    DWORD PTR [rsp+rdx*4+0x10],ecx ; dp[j] = left
  400bc7:	48 83 c2 01          	add    rdx,0x1 ; j += 1
  400bcb:	48 81 fa e8 03 00 00 	cmp    rdx,0x3e8 ; compare j, SEQ_SZ
  400bd2:	74 1c                	je     400bf0 <lcs1d+0x70>
  400bd4:	89 c1                	mov    ecx,eax ; left = current

; Inner-loop body
  400bd6:	44 38 04 13          	cmp    BYTE PTR [rbx+rdx*1],r8b ; compare seq1[i], seq2[j]
  400bda:	75 dc                	jne    400bb8 <lcs1d+0x38>
  400bdc:	8b 44 94 10          	mov    eax,DWORD PTR [rsp+rdx*4+0x10] ; current = dp[j]
  400be0:	89 44 24 0c          	mov    DWORD PTR [rsp+0xc],eax ; write-back of current (unnecessary here)
  400be4:	83 c0 01             	add    eax,0x1 ; current += 1
  400be7:	eb da                	jmp    400bc3 <lcs1d+0x43>

; Outer-loop transition
  400bf0:	48 83 c6 01          	add    rsi,0x1 ; i += 1
  400bf4:	48 81 fe e8 03 00 00 	cmp    rsi,0x3e8 ; compare i, SEQ_SZ
  400bfb:	75 ab                	jne    400ba8 <lcs1d+0x28>
