
_waitpid:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char* argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	83 ec 20             	sub    $0x20,%esp
  int pid, wait, status;

  pid = fork();
   a:	e8 bb 02 00 00       	call   2ca <fork>

  switch (pid)
   f:	83 f8 ff             	cmp    $0xffffffff,%eax
  pid = fork();
  12:	89 c3                	mov    %eax,%ebx
  switch (pid)
  14:	74 55                	je     6b <main+0x6b>
  16:	85 c0                	test   %eax,%eax
  18:	74 2f                	je     49 <main+0x49>
    case -1: printf(2, "Error in forking!\n"); exitStatus(1); break;

    case 0: printf(1, "Child process executed.\n"); exitStatus(5); break;

    default:
      wait = waitpid(pid, &status, 0);
  1a:	8d 44 24 1c          	lea    0x1c(%esp),%eax
  1e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  25:	00 
  26:	89 44 24 04          	mov    %eax,0x4(%esp)
  2a:	89 1c 24             	mov    %ebx,(%esp)
  2d:	e8 50 03 00 00       	call   382 <waitpid>

      if (pid == wait)
  32:	39 c3                	cmp    %eax,%ebx
  34:	74 57                	je     8d <main+0x8d>
        printf(1, "Process: %d terminated with exit status: %d\n", wait, status);

      break;
  }

  exitStatus(0);
  36:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3d:	e8 30 03 00 00       	call   372 <exitStatus>
  return 0;
}
  42:	31 c0                	xor    %eax,%eax
  44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  47:	c9                   	leave  
  48:	c3                   	ret    
    case 0: printf(1, "Child process executed.\n"); exitStatus(5); break;
  49:	c7 44 24 04 ab 07 00 	movl   $0x7ab,0x4(%esp)
  50:	00 
  51:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  58:	e8 d3 03 00 00       	call   430 <printf>
  5d:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  64:	e8 09 03 00 00       	call   372 <exitStatus>
  69:	eb cb                	jmp    36 <main+0x36>
    case -1: printf(2, "Error in forking!\n"); exitStatus(1); break;
  6b:	c7 44 24 04 98 07 00 	movl   $0x798,0x4(%esp)
  72:	00 
  73:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  7a:	e8 b1 03 00 00       	call   430 <printf>
  7f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  86:	e8 e7 02 00 00       	call   372 <exitStatus>
  8b:	eb a9                	jmp    36 <main+0x36>
        printf(1, "Process: %d terminated with exit status: %d\n", wait, status);
  8d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  91:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  95:	c7 44 24 04 c4 07 00 	movl   $0x7c4,0x4(%esp)
  9c:	00 
  9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  a8:	e8 83 03 00 00       	call   430 <printf>
  ad:	eb 87                	jmp    36 <main+0x36>
  af:	90                   	nop

000000b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	8b 45 08             	mov    0x8(%ebp),%eax
  b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  b9:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ba:	89 c2                	mov    %eax,%edx
  bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  c0:	83 c1 01             	add    $0x1,%ecx
  c3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  c7:	83 c2 01             	add    $0x1,%edx
  ca:	84 db                	test   %bl,%bl
  cc:	88 5a ff             	mov    %bl,-0x1(%edx)
  cf:	75 ef                	jne    c0 <strcpy+0x10>
    ;
  return os;
}
  d1:	5b                   	pop    %ebx
  d2:	5d                   	pop    %ebp
  d3:	c3                   	ret    
  d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	8b 55 08             	mov    0x8(%ebp),%edx
  e6:	53                   	push   %ebx
  e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  ea:	0f b6 02             	movzbl (%edx),%eax
  ed:	84 c0                	test   %al,%al
  ef:	74 2d                	je     11e <strcmp+0x3e>
  f1:	0f b6 19             	movzbl (%ecx),%ebx
  f4:	38 d8                	cmp    %bl,%al
  f6:	74 0e                	je     106 <strcmp+0x26>
  f8:	eb 2b                	jmp    125 <strcmp+0x45>
  fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 100:	38 c8                	cmp    %cl,%al
 102:	75 15                	jne    119 <strcmp+0x39>
    p++, q++;
 104:	89 d9                	mov    %ebx,%ecx
 106:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 109:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 10c:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 10f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 113:	84 c0                	test   %al,%al
 115:	75 e9                	jne    100 <strcmp+0x20>
 117:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 119:	29 c8                	sub    %ecx,%eax
}
 11b:	5b                   	pop    %ebx
 11c:	5d                   	pop    %ebp
 11d:	c3                   	ret    
 11e:	0f b6 09             	movzbl (%ecx),%ecx
  while(*p && *p == *q)
 121:	31 c0                	xor    %eax,%eax
 123:	eb f4                	jmp    119 <strcmp+0x39>
 125:	0f b6 cb             	movzbl %bl,%ecx
 128:	eb ef                	jmp    119 <strcmp+0x39>
 12a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000130 <strlen>:

uint
strlen(const char *s)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 136:	80 39 00             	cmpb   $0x0,(%ecx)
 139:	74 12                	je     14d <strlen+0x1d>
 13b:	31 d2                	xor    %edx,%edx
 13d:	8d 76 00             	lea    0x0(%esi),%esi
 140:	83 c2 01             	add    $0x1,%edx
 143:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 147:	89 d0                	mov    %edx,%eax
 149:	75 f5                	jne    140 <strlen+0x10>
    ;
  return n;
}
 14b:	5d                   	pop    %ebp
 14c:	c3                   	ret    
  for(n = 0; s[n]; n++)
 14d:	31 c0                	xor    %eax,%eax
}
 14f:	5d                   	pop    %ebp
 150:	c3                   	ret    
 151:	eb 0d                	jmp    160 <memset>
 153:	90                   	nop
 154:	90                   	nop
 155:	90                   	nop
 156:	90                   	nop
 157:	90                   	nop
 158:	90                   	nop
 159:	90                   	nop
 15a:	90                   	nop
 15b:	90                   	nop
 15c:	90                   	nop
 15d:	90                   	nop
 15e:	90                   	nop
 15f:	90                   	nop

00000160 <memset>:

void*
memset(void *dst, int c, uint n)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 55 08             	mov    0x8(%ebp),%edx
 166:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 167:	8b 4d 10             	mov    0x10(%ebp),%ecx
 16a:	8b 45 0c             	mov    0xc(%ebp),%eax
 16d:	89 d7                	mov    %edx,%edi
 16f:	fc                   	cld    
 170:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 172:	89 d0                	mov    %edx,%eax
 174:	5f                   	pop    %edi
 175:	5d                   	pop    %ebp
 176:	c3                   	ret    
 177:	89 f6                	mov    %esi,%esi
 179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000180 <strchr>:

char*
strchr(const char *s, char c)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	8b 45 08             	mov    0x8(%ebp),%eax
 186:	53                   	push   %ebx
 187:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 18a:	0f b6 18             	movzbl (%eax),%ebx
 18d:	84 db                	test   %bl,%bl
 18f:	74 1d                	je     1ae <strchr+0x2e>
    if(*s == c)
 191:	38 d3                	cmp    %dl,%bl
 193:	89 d1                	mov    %edx,%ecx
 195:	75 0d                	jne    1a4 <strchr+0x24>
 197:	eb 17                	jmp    1b0 <strchr+0x30>
 199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1a0:	38 ca                	cmp    %cl,%dl
 1a2:	74 0c                	je     1b0 <strchr+0x30>
  for(; *s; s++)
 1a4:	83 c0 01             	add    $0x1,%eax
 1a7:	0f b6 10             	movzbl (%eax),%edx
 1aa:	84 d2                	test   %dl,%dl
 1ac:	75 f2                	jne    1a0 <strchr+0x20>
      return (char*)s;
  return 0;
 1ae:	31 c0                	xor    %eax,%eax
}
 1b0:	5b                   	pop    %ebx
 1b1:	5d                   	pop    %ebp
 1b2:	c3                   	ret    
 1b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001c0 <gets>:

char*
gets(char *buf, int max)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	57                   	push   %edi
 1c4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c5:	31 f6                	xor    %esi,%esi
{
 1c7:	53                   	push   %ebx
 1c8:	83 ec 2c             	sub    $0x2c,%esp
    cc = read(0, &c, 1);
 1cb:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1ce:	eb 31                	jmp    201 <gets+0x41>
    cc = read(0, &c, 1);
 1d0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1d7:	00 
 1d8:	89 7c 24 04          	mov    %edi,0x4(%esp)
 1dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1e3:	e8 02 01 00 00       	call   2ea <read>
    if(cc < 1)
 1e8:	85 c0                	test   %eax,%eax
 1ea:	7e 1d                	jle    209 <gets+0x49>
      break;
    buf[i++] = c;
 1ec:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  for(i=0; i+1 < max; ){
 1f0:	89 de                	mov    %ebx,%esi
    buf[i++] = c;
 1f2:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 1f5:	3c 0d                	cmp    $0xd,%al
    buf[i++] = c;
 1f7:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 1fb:	74 0c                	je     209 <gets+0x49>
 1fd:	3c 0a                	cmp    $0xa,%al
 1ff:	74 08                	je     209 <gets+0x49>
  for(i=0; i+1 < max; ){
 201:	8d 5e 01             	lea    0x1(%esi),%ebx
 204:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 207:	7c c7                	jl     1d0 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 209:	8b 45 08             	mov    0x8(%ebp),%eax
 20c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 210:	83 c4 2c             	add    $0x2c,%esp
 213:	5b                   	pop    %ebx
 214:	5e                   	pop    %esi
 215:	5f                   	pop    %edi
 216:	5d                   	pop    %ebp
 217:	c3                   	ret    
 218:	90                   	nop
 219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000220 <stat>:

int
stat(const char *n, struct stat *st)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	56                   	push   %esi
 224:	53                   	push   %ebx
 225:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 228:	8b 45 08             	mov    0x8(%ebp),%eax
 22b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 232:	00 
 233:	89 04 24             	mov    %eax,(%esp)
 236:	e8 d7 00 00 00       	call   312 <open>
  if(fd < 0)
 23b:	85 c0                	test   %eax,%eax
  fd = open(n, O_RDONLY);
 23d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 23f:	78 27                	js     268 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 241:	8b 45 0c             	mov    0xc(%ebp),%eax
 244:	89 1c 24             	mov    %ebx,(%esp)
 247:	89 44 24 04          	mov    %eax,0x4(%esp)
 24b:	e8 da 00 00 00       	call   32a <fstat>
  close(fd);
 250:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 253:	89 c6                	mov    %eax,%esi
  close(fd);
 255:	e8 a0 00 00 00       	call   2fa <close>
  return r;
 25a:	89 f0                	mov    %esi,%eax
}
 25c:	83 c4 10             	add    $0x10,%esp
 25f:	5b                   	pop    %ebx
 260:	5e                   	pop    %esi
 261:	5d                   	pop    %ebp
 262:	c3                   	ret    
 263:	90                   	nop
 264:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 268:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 26d:	eb ed                	jmp    25c <stat+0x3c>
 26f:	90                   	nop

00000270 <atoi>:

int
atoi(const char *s)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	8b 4d 08             	mov    0x8(%ebp),%ecx
 276:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 277:	0f be 11             	movsbl (%ecx),%edx
 27a:	8d 42 d0             	lea    -0x30(%edx),%eax
 27d:	3c 09                	cmp    $0x9,%al
  n = 0;
 27f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 284:	77 17                	ja     29d <atoi+0x2d>
 286:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 288:	83 c1 01             	add    $0x1,%ecx
 28b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 28e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 292:	0f be 11             	movsbl (%ecx),%edx
 295:	8d 5a d0             	lea    -0x30(%edx),%ebx
 298:	80 fb 09             	cmp    $0x9,%bl
 29b:	76 eb                	jbe    288 <atoi+0x18>
  return n;
}
 29d:	5b                   	pop    %ebx
 29e:	5d                   	pop    %ebp
 29f:	c3                   	ret    

000002a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a0:	55                   	push   %ebp
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a1:	31 d2                	xor    %edx,%edx
{
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	56                   	push   %esi
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	53                   	push   %ebx
 2aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
 2ad:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n-- > 0)
 2b0:	85 db                	test   %ebx,%ebx
 2b2:	7e 12                	jle    2c6 <memmove+0x26>
 2b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 2b8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2bf:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2c2:	39 da                	cmp    %ebx,%edx
 2c4:	75 f2                	jne    2b8 <memmove+0x18>
  return vdst;
}
 2c6:	5b                   	pop    %ebx
 2c7:	5e                   	pop    %esi
 2c8:	5d                   	pop    %ebp
 2c9:	c3                   	ret    

000002ca <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ca:	b8 01 00 00 00       	mov    $0x1,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <exit>:
SYSCALL(exit)
 2d2:	b8 02 00 00 00       	mov    $0x2,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <wait>:
SYSCALL(wait)
 2da:	b8 03 00 00 00       	mov    $0x3,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <pipe>:
SYSCALL(pipe)
 2e2:	b8 04 00 00 00       	mov    $0x4,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <read>:
SYSCALL(read)
 2ea:	b8 05 00 00 00       	mov    $0x5,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <write>:
SYSCALL(write)
 2f2:	b8 10 00 00 00       	mov    $0x10,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <close>:
SYSCALL(close)
 2fa:	b8 15 00 00 00       	mov    $0x15,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <kill>:
SYSCALL(kill)
 302:	b8 06 00 00 00       	mov    $0x6,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <exec>:
SYSCALL(exec)
 30a:	b8 07 00 00 00       	mov    $0x7,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <open>:
SYSCALL(open)
 312:	b8 0f 00 00 00       	mov    $0xf,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <mknod>:
SYSCALL(mknod)
 31a:	b8 11 00 00 00       	mov    $0x11,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <unlink>:
SYSCALL(unlink)
 322:	b8 12 00 00 00       	mov    $0x12,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <fstat>:
SYSCALL(fstat)
 32a:	b8 08 00 00 00       	mov    $0x8,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <link>:
SYSCALL(link)
 332:	b8 13 00 00 00       	mov    $0x13,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <mkdir>:
SYSCALL(mkdir)
 33a:	b8 14 00 00 00       	mov    $0x14,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <chdir>:
SYSCALL(chdir)
 342:	b8 09 00 00 00       	mov    $0x9,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <dup>:
SYSCALL(dup)
 34a:	b8 0a 00 00 00       	mov    $0xa,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <getpid>:
SYSCALL(getpid)
 352:	b8 0b 00 00 00       	mov    $0xb,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <sbrk>:
SYSCALL(sbrk)
 35a:	b8 0c 00 00 00       	mov    $0xc,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <sleep>:
SYSCALL(sleep)
 362:	b8 0d 00 00 00       	mov    $0xd,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <uptime>:
SYSCALL(uptime)
 36a:	b8 0e 00 00 00       	mov    $0xe,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <exitStatus>:
SYSCALL(exitStatus) //cs153_lab1
 372:	b8 16 00 00 00       	mov    $0x16,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <waitStatus>:
SYSCALL(waitStatus) //cs153_lab1
 37a:	b8 17 00 00 00       	mov    $0x17,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <waitpid>:
SYSCALL(waitpid) //cs153_lab1
 382:	b8 18 00 00 00       	mov    $0x18,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    
 38a:	66 90                	xchg   %ax,%ax
 38c:	66 90                	xchg   %ax,%ax
 38e:	66 90                	xchg   %ax,%ax

00000390 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	56                   	push   %esi
 395:	89 c6                	mov    %eax,%esi
 397:	53                   	push   %ebx
 398:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 39b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 39e:	85 db                	test   %ebx,%ebx
 3a0:	74 09                	je     3ab <printint+0x1b>
 3a2:	89 d0                	mov    %edx,%eax
 3a4:	c1 e8 1f             	shr    $0x1f,%eax
 3a7:	84 c0                	test   %al,%al
 3a9:	75 75                	jne    420 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ab:	89 d0                	mov    %edx,%eax
  neg = 0;
 3ad:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3b4:	89 75 c0             	mov    %esi,-0x40(%ebp)
  }

  i = 0;
 3b7:	31 ff                	xor    %edi,%edi
 3b9:	89 ce                	mov    %ecx,%esi
 3bb:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3be:	eb 02                	jmp    3c2 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 3c0:	89 cf                	mov    %ecx,%edi
 3c2:	31 d2                	xor    %edx,%edx
 3c4:	f7 f6                	div    %esi
 3c6:	8d 4f 01             	lea    0x1(%edi),%ecx
 3c9:	0f b6 92 fb 07 00 00 	movzbl 0x7fb(%edx),%edx
  }while((x /= base) != 0);
 3d0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 3d2:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 3d5:	75 e9                	jne    3c0 <printint+0x30>
  if(neg)
 3d7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    buf[i++] = digits[x % base];
 3da:	89 c8                	mov    %ecx,%eax
 3dc:	8b 75 c0             	mov    -0x40(%ebp),%esi
  if(neg)
 3df:	85 d2                	test   %edx,%edx
 3e1:	74 08                	je     3eb <printint+0x5b>
    buf[i++] = '-';
 3e3:	8d 4f 02             	lea    0x2(%edi),%ecx
 3e6:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 3eb:	8d 79 ff             	lea    -0x1(%ecx),%edi
 3ee:	66 90                	xchg   %ax,%ax
 3f0:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 3f5:	83 ef 01             	sub    $0x1,%edi
  write(fd, &c, 1);
 3f8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3ff:	00 
 400:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 404:	89 34 24             	mov    %esi,(%esp)
 407:	88 45 d7             	mov    %al,-0x29(%ebp)
 40a:	e8 e3 fe ff ff       	call   2f2 <write>
  while(--i >= 0)
 40f:	83 ff ff             	cmp    $0xffffffff,%edi
 412:	75 dc                	jne    3f0 <printint+0x60>
    putc(fd, buf[i]);
}
 414:	83 c4 4c             	add    $0x4c,%esp
 417:	5b                   	pop    %ebx
 418:	5e                   	pop    %esi
 419:	5f                   	pop    %edi
 41a:	5d                   	pop    %ebp
 41b:	c3                   	ret    
 41c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    x = -xx;
 420:	89 d0                	mov    %edx,%eax
 422:	f7 d8                	neg    %eax
    neg = 1;
 424:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 42b:	eb 87                	jmp    3b4 <printint+0x24>
 42d:	8d 76 00             	lea    0x0(%esi),%esi

00000430 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 434:	31 ff                	xor    %edi,%edi
{
 436:	56                   	push   %esi
 437:	53                   	push   %ebx
 438:	83 ec 3c             	sub    $0x3c,%esp
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 43b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  ap = (uint*)(void*)&fmt + 1;
 43e:	8d 45 10             	lea    0x10(%ebp),%eax
{
 441:	8b 75 08             	mov    0x8(%ebp),%esi
  ap = (uint*)(void*)&fmt + 1;
 444:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 447:	0f b6 13             	movzbl (%ebx),%edx
 44a:	83 c3 01             	add    $0x1,%ebx
 44d:	84 d2                	test   %dl,%dl
 44f:	75 39                	jne    48a <printf+0x5a>
 451:	e9 c2 00 00 00       	jmp    518 <printf+0xe8>
 456:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 458:	83 fa 25             	cmp    $0x25,%edx
 45b:	0f 84 bf 00 00 00    	je     520 <printf+0xf0>
  write(fd, &c, 1);
 461:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 464:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 46b:	00 
 46c:	89 44 24 04          	mov    %eax,0x4(%esp)
 470:	89 34 24             	mov    %esi,(%esp)
        state = '%';
      } else {
        putc(fd, c);
 473:	88 55 e2             	mov    %dl,-0x1e(%ebp)
  write(fd, &c, 1);
 476:	e8 77 fe ff ff       	call   2f2 <write>
 47b:	83 c3 01             	add    $0x1,%ebx
  for(i = 0; fmt[i]; i++){
 47e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 482:	84 d2                	test   %dl,%dl
 484:	0f 84 8e 00 00 00    	je     518 <printf+0xe8>
    if(state == 0){
 48a:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 48c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 48f:	74 c7                	je     458 <printf+0x28>
      }
    } else if(state == '%'){
 491:	83 ff 25             	cmp    $0x25,%edi
 494:	75 e5                	jne    47b <printf+0x4b>
      if(c == 'd'){
 496:	83 fa 64             	cmp    $0x64,%edx
 499:	0f 84 31 01 00 00    	je     5d0 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 49f:	25 f7 00 00 00       	and    $0xf7,%eax
 4a4:	83 f8 70             	cmp    $0x70,%eax
 4a7:	0f 84 83 00 00 00    	je     530 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4ad:	83 fa 73             	cmp    $0x73,%edx
 4b0:	0f 84 a2 00 00 00    	je     558 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4b6:	83 fa 63             	cmp    $0x63,%edx
 4b9:	0f 84 35 01 00 00    	je     5f4 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4bf:	83 fa 25             	cmp    $0x25,%edx
 4c2:	0f 84 e0 00 00 00    	je     5a8 <printf+0x178>
  write(fd, &c, 1);
 4c8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4cb:	83 c3 01             	add    $0x1,%ebx
 4ce:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4d5:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4d6:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 4d8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4dc:	89 34 24             	mov    %esi,(%esp)
 4df:	89 55 d0             	mov    %edx,-0x30(%ebp)
 4e2:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 4e6:	e8 07 fe ff ff       	call   2f2 <write>
        putc(fd, c);
 4eb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  write(fd, &c, 1);
 4ee:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4f1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4f8:	00 
 4f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4fd:	89 34 24             	mov    %esi,(%esp)
        putc(fd, c);
 500:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 503:	e8 ea fd ff ff       	call   2f2 <write>
  for(i = 0; fmt[i]; i++){
 508:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 50c:	84 d2                	test   %dl,%dl
 50e:	0f 85 76 ff ff ff    	jne    48a <printf+0x5a>
 514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }
}
 518:	83 c4 3c             	add    $0x3c,%esp
 51b:	5b                   	pop    %ebx
 51c:	5e                   	pop    %esi
 51d:	5f                   	pop    %edi
 51e:	5d                   	pop    %ebp
 51f:	c3                   	ret    
        state = '%';
 520:	bf 25 00 00 00       	mov    $0x25,%edi
 525:	e9 51 ff ff ff       	jmp    47b <printf+0x4b>
 52a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 530:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 533:	b9 10 00 00 00       	mov    $0x10,%ecx
      state = 0;
 538:	31 ff                	xor    %edi,%edi
        printint(fd, *ap, 16, 0);
 53a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 541:	8b 10                	mov    (%eax),%edx
 543:	89 f0                	mov    %esi,%eax
 545:	e8 46 fe ff ff       	call   390 <printint>
        ap++;
 54a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 54e:	e9 28 ff ff ff       	jmp    47b <printf+0x4b>
 553:	90                   	nop
 554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 558:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 55b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        s = (char*)*ap;
 55f:	8b 38                	mov    (%eax),%edi
          s = "(null)";
 561:	b8 f4 07 00 00       	mov    $0x7f4,%eax
 566:	85 ff                	test   %edi,%edi
 568:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 56b:	0f b6 07             	movzbl (%edi),%eax
 56e:	84 c0                	test   %al,%al
 570:	74 2a                	je     59c <printf+0x16c>
 572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 578:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 57b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
          s++;
 57e:	83 c7 01             	add    $0x1,%edi
  write(fd, &c, 1);
 581:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 588:	00 
 589:	89 44 24 04          	mov    %eax,0x4(%esp)
 58d:	89 34 24             	mov    %esi,(%esp)
 590:	e8 5d fd ff ff       	call   2f2 <write>
        while(*s != 0){
 595:	0f b6 07             	movzbl (%edi),%eax
 598:	84 c0                	test   %al,%al
 59a:	75 dc                	jne    578 <printf+0x148>
      state = 0;
 59c:	31 ff                	xor    %edi,%edi
 59e:	e9 d8 fe ff ff       	jmp    47b <printf+0x4b>
 5a3:	90                   	nop
 5a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 5a8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      state = 0;
 5ab:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 5ad:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5b4:	00 
 5b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b9:	89 34 24             	mov    %esi,(%esp)
 5bc:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 5c0:	e8 2d fd ff ff       	call   2f2 <write>
 5c5:	e9 b1 fe ff ff       	jmp    47b <printf+0x4b>
 5ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 5d0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
      state = 0;
 5d8:	66 31 ff             	xor    %di,%di
        printint(fd, *ap, 10, 1);
 5db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5e2:	8b 10                	mov    (%eax),%edx
 5e4:	89 f0                	mov    %esi,%eax
 5e6:	e8 a5 fd ff ff       	call   390 <printint>
        ap++;
 5eb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5ef:	e9 87 fe ff ff       	jmp    47b <printf+0x4b>
        putc(fd, *ap);
 5f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      state = 0;
 5f7:	31 ff                	xor    %edi,%edi
        putc(fd, *ap);
 5f9:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 5fb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 602:	00 
 603:	89 34 24             	mov    %esi,(%esp)
        putc(fd, *ap);
 606:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 609:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 60c:	89 44 24 04          	mov    %eax,0x4(%esp)
 610:	e8 dd fc ff ff       	call   2f2 <write>
        ap++;
 615:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 619:	e9 5d fe ff ff       	jmp    47b <printf+0x4b>
 61e:	66 90                	xchg   %ax,%ax

00000620 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 620:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 621:	a1 7c 0a 00 00       	mov    0xa7c,%eax
{
 626:	89 e5                	mov    %esp,%ebp
 628:	57                   	push   %edi
 629:	56                   	push   %esi
 62a:	53                   	push   %ebx
 62b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 62e:	8b 08                	mov    (%eax),%ecx
  bp = (Header*)ap - 1;
 630:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 633:	39 d0                	cmp    %edx,%eax
 635:	72 11                	jb     648 <free+0x28>
 637:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 638:	39 c8                	cmp    %ecx,%eax
 63a:	72 04                	jb     640 <free+0x20>
 63c:	39 ca                	cmp    %ecx,%edx
 63e:	72 10                	jb     650 <free+0x30>
 640:	89 c8                	mov    %ecx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 642:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 644:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 646:	73 f0                	jae    638 <free+0x18>
 648:	39 ca                	cmp    %ecx,%edx
 64a:	72 04                	jb     650 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 64c:	39 c8                	cmp    %ecx,%eax
 64e:	72 f0                	jb     640 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 650:	8b 73 fc             	mov    -0x4(%ebx),%esi
 653:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 656:	39 cf                	cmp    %ecx,%edi
 658:	74 1e                	je     678 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 65a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 65d:	8b 48 04             	mov    0x4(%eax),%ecx
 660:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 663:	39 f2                	cmp    %esi,%edx
 665:	74 28                	je     68f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 667:	89 10                	mov    %edx,(%eax)
  freep = p;
 669:	a3 7c 0a 00 00       	mov    %eax,0xa7c
}
 66e:	5b                   	pop    %ebx
 66f:	5e                   	pop    %esi
 670:	5f                   	pop    %edi
 671:	5d                   	pop    %ebp
 672:	c3                   	ret    
 673:	90                   	nop
 674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 678:	03 71 04             	add    0x4(%ecx),%esi
 67b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 67e:	8b 08                	mov    (%eax),%ecx
 680:	8b 09                	mov    (%ecx),%ecx
 682:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 685:	8b 48 04             	mov    0x4(%eax),%ecx
 688:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 68b:	39 f2                	cmp    %esi,%edx
 68d:	75 d8                	jne    667 <free+0x47>
    p->s.size += bp->s.size;
 68f:	03 4b fc             	add    -0x4(%ebx),%ecx
  freep = p;
 692:	a3 7c 0a 00 00       	mov    %eax,0xa7c
    p->s.size += bp->s.size;
 697:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 69a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 69d:	89 10                	mov    %edx,(%eax)
}
 69f:	5b                   	pop    %ebx
 6a0:	5e                   	pop    %esi
 6a1:	5f                   	pop    %edi
 6a2:	5d                   	pop    %ebp
 6a3:	c3                   	ret    
 6a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 6aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000006b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	57                   	push   %edi
 6b4:	56                   	push   %esi
 6b5:	53                   	push   %ebx
 6b6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6b9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6bc:	8b 1d 7c 0a 00 00    	mov    0xa7c,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6c2:	8d 48 07             	lea    0x7(%eax),%ecx
 6c5:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 6c8:	85 db                	test   %ebx,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6ca:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 6cd:	0f 84 9b 00 00 00    	je     76e <malloc+0xbe>
 6d3:	8b 13                	mov    (%ebx),%edx
 6d5:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6d8:	39 fe                	cmp    %edi,%esi
 6da:	76 64                	jbe    740 <malloc+0x90>
 6dc:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  if(nu < 4096)
 6e3:	bb 00 80 00 00       	mov    $0x8000,%ebx
 6e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 6eb:	eb 0e                	jmp    6fb <malloc+0x4b>
 6ed:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6f2:	8b 78 04             	mov    0x4(%eax),%edi
 6f5:	39 fe                	cmp    %edi,%esi
 6f7:	76 4f                	jbe    748 <malloc+0x98>
 6f9:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 6fb:	3b 15 7c 0a 00 00    	cmp    0xa7c,%edx
 701:	75 ed                	jne    6f0 <malloc+0x40>
  if(nu < 4096)
 703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 706:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 70c:	bf 00 10 00 00       	mov    $0x1000,%edi
 711:	0f 43 fe             	cmovae %esi,%edi
 714:	0f 42 c3             	cmovb  %ebx,%eax
  p = sbrk(nu * sizeof(Header));
 717:	89 04 24             	mov    %eax,(%esp)
 71a:	e8 3b fc ff ff       	call   35a <sbrk>
  if(p == (char*)-1)
 71f:	83 f8 ff             	cmp    $0xffffffff,%eax
 722:	74 18                	je     73c <malloc+0x8c>
  hp->s.size = nu;
 724:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 727:	83 c0 08             	add    $0x8,%eax
 72a:	89 04 24             	mov    %eax,(%esp)
 72d:	e8 ee fe ff ff       	call   620 <free>
  return freep;
 732:	8b 15 7c 0a 00 00    	mov    0xa7c,%edx
      if((p = morecore(nunits)) == 0)
 738:	85 d2                	test   %edx,%edx
 73a:	75 b4                	jne    6f0 <malloc+0x40>
        return 0;
 73c:	31 c0                	xor    %eax,%eax
 73e:	eb 20                	jmp    760 <malloc+0xb0>
    if(p->s.size >= nunits){
 740:	89 d0                	mov    %edx,%eax
 742:	89 da                	mov    %ebx,%edx
 744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 748:	39 fe                	cmp    %edi,%esi
 74a:	74 1c                	je     768 <malloc+0xb8>
        p->s.size -= nunits;
 74c:	29 f7                	sub    %esi,%edi
 74e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 751:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 754:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 757:	89 15 7c 0a 00 00    	mov    %edx,0xa7c
      return (void*)(p + 1);
 75d:	83 c0 08             	add    $0x8,%eax
  }
}
 760:	83 c4 1c             	add    $0x1c,%esp
 763:	5b                   	pop    %ebx
 764:	5e                   	pop    %esi
 765:	5f                   	pop    %edi
 766:	5d                   	pop    %ebp
 767:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 768:	8b 08                	mov    (%eax),%ecx
 76a:	89 0a                	mov    %ecx,(%edx)
 76c:	eb e9                	jmp    757 <malloc+0xa7>
    base.s.ptr = freep = prevp = &base;
 76e:	c7 05 7c 0a 00 00 80 	movl   $0xa80,0xa7c
 775:	0a 00 00 
    base.s.size = 0;
 778:	ba 80 0a 00 00       	mov    $0xa80,%edx
    base.s.ptr = freep = prevp = &base;
 77d:	c7 05 80 0a 00 00 80 	movl   $0xa80,0xa80
 784:	0a 00 00 
    base.s.size = 0;
 787:	c7 05 84 0a 00 00 00 	movl   $0x0,0xa84
 78e:	00 00 00 
 791:	e9 46 ff ff ff       	jmp    6dc <malloc+0x2c>
