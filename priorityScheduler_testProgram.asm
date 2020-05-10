
_priorityScheduler_testProgram:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
	
	int PScheduler(void);
	
	printf(1, "\n This program tests the correctness of your lab#2\n");
   9:	c7 44 24 04 18 0a 00 	movl   $0xa18,0x4(%esp)
  10:	00 
  11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  18:	e8 e3 04 00 00       	call   500 <printf>
  
	PScheduler();
  1d:	e8 0e 00 00 00       	call   30 <PScheduler>
  22:	66 90                	xchg   %ax,%ax
  24:	66 90                	xchg   %ax,%ax
  26:	66 90                	xchg   %ax,%ax
  28:	66 90                	xchg   %ax,%ax
  2a:	66 90                	xchg   %ax,%ax
  2c:	66 90                	xchg   %ax,%ax
  2e:	66 90                	xchg   %ax,%ax

00000030 <PScheduler>:
	return 0;
 }
  
    
int PScheduler(void)
{
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	53                   	push   %ebx
  34:	83 ec 14             	sub    $0x14,%esp
	int pid;
  	int i,j,k;
  
    	printf(1, "\n  Step 2: testing the priority scheduler and setpriority(int priority)) systema call:\n");
  37:	c7 44 24 04 68 08 00 	movl   $0x868,0x4(%esp)
  3e:	00 
  3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  46:	e8 b5 04 00 00       	call   500 <printf>
    	printf(1, "\n  Step 2: Assuming that the priorities range between range between 0 to 31\n");
  4b:	c7 44 24 04 c0 08 00 	movl   $0x8c0,0x4(%esp)
  52:	00 
  53:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5a:	e8 a1 04 00 00       	call   500 <printf>
    	printf(1, "\n  Step 2: 0 is the highest priority. All processes have a default priority of 15\n");
  5f:	c7 44 24 04 10 09 00 	movl   $0x910,0x4(%esp)
  66:	00 
  67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  6e:	e8 8d 04 00 00       	call   500 <printf>
    	printf(1, "\n  Step 2: The parent processes will switch to priority 0\n");
  73:	c7 44 24 04 64 09 00 	movl   $0x964,0x4(%esp)
  7a:	00 
  7b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  82:	e8 79 04 00 00       	call   500 <printf>
    	
	setPrior(0);
  87:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8e:	e8 af 03 00 00       	call   442 <setPrior>

    	for (i = 0; i < 2; i++)
	{
        	pid = fork();
  93:	e8 e2 02 00 00       	call   37a <fork>

		if (pid > 0 ) 
  98:	83 f8 00             	cmp    $0x0,%eax
  9b:	7e 3e                	jle    db <PScheduler+0xab>
  9d:	8d 76 00             	lea    0x0(%esi),%esi
        	pid = fork();
  a0:	e8 d5 02 00 00       	call   37a <fork>
		if (pid > 0 ) 
  a5:	83 f8 00             	cmp    $0x0,%eax
  a8:	7e 49                	jle    f3 <PScheduler+0xc3>
	}

	if(pid > 0) 
	{
		for (i = 0; i <  2; i++)
            		waitStatus(0);
  aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  b1:	e8 74 03 00 00       	call   42a <waitStatus>
  b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  bd:	e8 68 03 00 00       	call   42a <waitStatus>

		printf(1,"\n if processes with highest priority finished first then its correct \n");
  c2:	c7 44 24 04 d0 09 00 	movl   $0x9d0,0x4(%esp)
  c9:	00 
  ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d1:	e8 2a 04 00 00       	call   500 <printf>
	}

	exit();		
  d6:	e8 a7 02 00 00       	call   382 <exit>
		else if ( pid == 0)
  db:	74 2e                	je     10b <PScheduler+0xdb>
			printf(2," \n Error \n");
  dd:	c7 44 24 04 4c 0a 00 	movl   $0xa4c,0x4(%esp)
  e4:	00 
  e5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  ec:	e8 0f 04 00 00       	call   500 <printf>
  f1:	eb aa                	jmp    9d <PScheduler+0x6d>
		else if ( pid == 0)
  f3:	74 64                	je     159 <PScheduler+0x129>
			printf(2," \n Error \n");
  f5:	c7 44 24 04 4c 0a 00 	movl   $0xa4c,0x4(%esp)
  fc:	00 
  fd:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 104:	e8 f7 03 00 00       	call   500 <printf>
 109:	eb cb                	jmp    d6 <PScheduler+0xa6>
    	for (i = 0; i < 2; i++)
 10b:	31 c0                	xor    %eax,%eax
			setPrior(30-15*i);
 10d:	6b c0 f1             	imul   $0xfffffff1,%eax,%eax
 110:	8d 58 1e             	lea    0x1e(%eax),%ebx
 113:	89 1c 24             	mov    %ebx,(%esp)
 116:	e8 27 03 00 00       	call   442 <setPrior>
 11b:	ba 50 c3 00 00       	mov    $0xc350,%edx
    	for (i = 0; i < 2; i++)
 120:	b8 e8 03 00 00       	mov    $0x3e8,%eax
 125:	8d 76 00             	lea    0x0(%esi),%esi
					asm("nop"); 
 128:	90                   	nop
				for(k=0;k<1000;k++) 
 129:	83 e8 01             	sub    $0x1,%eax
 12c:	75 fa                	jne    128 <PScheduler+0xf8>
			for (j=0;j<50000;j++)
 12e:	83 ea 01             	sub    $0x1,%edx
 131:	75 ed                	jne    120 <PScheduler+0xf0>
			printf(1, "\n child# %d with priority %d has finished! \n",getpid(),30-15*i);
 133:	e8 ca 02 00 00       	call   402 <getpid>
 138:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 13c:	c7 44 24 04 a0 09 00 	movl   $0x9a0,0x4(%esp)
 143:	00 
 144:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 14b:	89 44 24 08          	mov    %eax,0x8(%esp)
 14f:	e8 ac 03 00 00       	call   500 <printf>
			exit();
 154:	e8 29 02 00 00       	call   382 <exit>
    	for (i = 0; i < 2; i++)
 159:	b8 01 00 00 00       	mov    $0x1,%eax
 15e:	eb ad                	jmp    10d <PScheduler+0xdd>

00000160 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 169:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 16a:	89 c2                	mov    %eax,%edx
 16c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 170:	83 c1 01             	add    $0x1,%ecx
 173:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 177:	83 c2 01             	add    $0x1,%edx
 17a:	84 db                	test   %bl,%bl
 17c:	88 5a ff             	mov    %bl,-0x1(%edx)
 17f:	75 ef                	jne    170 <strcpy+0x10>
    ;
  return os;
}
 181:	5b                   	pop    %ebx
 182:	5d                   	pop    %ebp
 183:	c3                   	ret    
 184:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 18a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000190 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	8b 55 08             	mov    0x8(%ebp),%edx
 196:	53                   	push   %ebx
 197:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 19a:	0f b6 02             	movzbl (%edx),%eax
 19d:	84 c0                	test   %al,%al
 19f:	74 2d                	je     1ce <strcmp+0x3e>
 1a1:	0f b6 19             	movzbl (%ecx),%ebx
 1a4:	38 d8                	cmp    %bl,%al
 1a6:	74 0e                	je     1b6 <strcmp+0x26>
 1a8:	eb 2b                	jmp    1d5 <strcmp+0x45>
 1aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1b0:	38 c8                	cmp    %cl,%al
 1b2:	75 15                	jne    1c9 <strcmp+0x39>
    p++, q++;
 1b4:	89 d9                	mov    %ebx,%ecx
 1b6:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 1b9:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 1bc:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 1bf:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 1c3:	84 c0                	test   %al,%al
 1c5:	75 e9                	jne    1b0 <strcmp+0x20>
 1c7:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 1c9:	29 c8                	sub    %ecx,%eax
}
 1cb:	5b                   	pop    %ebx
 1cc:	5d                   	pop    %ebp
 1cd:	c3                   	ret    
 1ce:	0f b6 09             	movzbl (%ecx),%ecx
  while(*p && *p == *q)
 1d1:	31 c0                	xor    %eax,%eax
 1d3:	eb f4                	jmp    1c9 <strcmp+0x39>
 1d5:	0f b6 cb             	movzbl %bl,%ecx
 1d8:	eb ef                	jmp    1c9 <strcmp+0x39>
 1da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001e0 <strlen>:

uint
strlen(const char *s)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1e6:	80 39 00             	cmpb   $0x0,(%ecx)
 1e9:	74 12                	je     1fd <strlen+0x1d>
 1eb:	31 d2                	xor    %edx,%edx
 1ed:	8d 76 00             	lea    0x0(%esi),%esi
 1f0:	83 c2 01             	add    $0x1,%edx
 1f3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1f7:	89 d0                	mov    %edx,%eax
 1f9:	75 f5                	jne    1f0 <strlen+0x10>
    ;
  return n;
}
 1fb:	5d                   	pop    %ebp
 1fc:	c3                   	ret    
  for(n = 0; s[n]; n++)
 1fd:	31 c0                	xor    %eax,%eax
}
 1ff:	5d                   	pop    %ebp
 200:	c3                   	ret    
 201:	eb 0d                	jmp    210 <memset>
 203:	90                   	nop
 204:	90                   	nop
 205:	90                   	nop
 206:	90                   	nop
 207:	90                   	nop
 208:	90                   	nop
 209:	90                   	nop
 20a:	90                   	nop
 20b:	90                   	nop
 20c:	90                   	nop
 20d:	90                   	nop
 20e:	90                   	nop
 20f:	90                   	nop

00000210 <memset>:

void*
memset(void *dst, int c, uint n)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	8b 55 08             	mov    0x8(%ebp),%edx
 216:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 217:	8b 4d 10             	mov    0x10(%ebp),%ecx
 21a:	8b 45 0c             	mov    0xc(%ebp),%eax
 21d:	89 d7                	mov    %edx,%edi
 21f:	fc                   	cld    
 220:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 222:	89 d0                	mov    %edx,%eax
 224:	5f                   	pop    %edi
 225:	5d                   	pop    %ebp
 226:	c3                   	ret    
 227:	89 f6                	mov    %esi,%esi
 229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000230 <strchr>:

char*
strchr(const char *s, char c)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	53                   	push   %ebx
 237:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 23a:	0f b6 18             	movzbl (%eax),%ebx
 23d:	84 db                	test   %bl,%bl
 23f:	74 1d                	je     25e <strchr+0x2e>
    if(*s == c)
 241:	38 d3                	cmp    %dl,%bl
 243:	89 d1                	mov    %edx,%ecx
 245:	75 0d                	jne    254 <strchr+0x24>
 247:	eb 17                	jmp    260 <strchr+0x30>
 249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 250:	38 ca                	cmp    %cl,%dl
 252:	74 0c                	je     260 <strchr+0x30>
  for(; *s; s++)
 254:	83 c0 01             	add    $0x1,%eax
 257:	0f b6 10             	movzbl (%eax),%edx
 25a:	84 d2                	test   %dl,%dl
 25c:	75 f2                	jne    250 <strchr+0x20>
      return (char*)s;
  return 0;
 25e:	31 c0                	xor    %eax,%eax
}
 260:	5b                   	pop    %ebx
 261:	5d                   	pop    %ebp
 262:	c3                   	ret    
 263:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000270 <gets>:

char*
gets(char *buf, int max)
{
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	57                   	push   %edi
 274:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 275:	31 f6                	xor    %esi,%esi
{
 277:	53                   	push   %ebx
 278:	83 ec 2c             	sub    $0x2c,%esp
    cc = read(0, &c, 1);
 27b:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 27e:	eb 31                	jmp    2b1 <gets+0x41>
    cc = read(0, &c, 1);
 280:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 287:	00 
 288:	89 7c 24 04          	mov    %edi,0x4(%esp)
 28c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 293:	e8 02 01 00 00       	call   39a <read>
    if(cc < 1)
 298:	85 c0                	test   %eax,%eax
 29a:	7e 1d                	jle    2b9 <gets+0x49>
      break;
    buf[i++] = c;
 29c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  for(i=0; i+1 < max; ){
 2a0:	89 de                	mov    %ebx,%esi
    buf[i++] = c;
 2a2:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 2a5:	3c 0d                	cmp    $0xd,%al
    buf[i++] = c;
 2a7:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 2ab:	74 0c                	je     2b9 <gets+0x49>
 2ad:	3c 0a                	cmp    $0xa,%al
 2af:	74 08                	je     2b9 <gets+0x49>
  for(i=0; i+1 < max; ){
 2b1:	8d 5e 01             	lea    0x1(%esi),%ebx
 2b4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 2b7:	7c c7                	jl     280 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 2b9:	8b 45 08             	mov    0x8(%ebp),%eax
 2bc:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 2c0:	83 c4 2c             	add    $0x2c,%esp
 2c3:	5b                   	pop    %ebx
 2c4:	5e                   	pop    %esi
 2c5:	5f                   	pop    %edi
 2c6:	5d                   	pop    %ebp
 2c7:	c3                   	ret    
 2c8:	90                   	nop
 2c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002d0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	56                   	push   %esi
 2d4:	53                   	push   %ebx
 2d5:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
 2db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2e2:	00 
 2e3:	89 04 24             	mov    %eax,(%esp)
 2e6:	e8 d7 00 00 00       	call   3c2 <open>
  if(fd < 0)
 2eb:	85 c0                	test   %eax,%eax
  fd = open(n, O_RDONLY);
 2ed:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 2ef:	78 27                	js     318 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 2f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f4:	89 1c 24             	mov    %ebx,(%esp)
 2f7:	89 44 24 04          	mov    %eax,0x4(%esp)
 2fb:	e8 da 00 00 00       	call   3da <fstat>
  close(fd);
 300:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 303:	89 c6                	mov    %eax,%esi
  close(fd);
 305:	e8 a0 00 00 00       	call   3aa <close>
  return r;
 30a:	89 f0                	mov    %esi,%eax
}
 30c:	83 c4 10             	add    $0x10,%esp
 30f:	5b                   	pop    %ebx
 310:	5e                   	pop    %esi
 311:	5d                   	pop    %ebp
 312:	c3                   	ret    
 313:	90                   	nop
 314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 318:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 31d:	eb ed                	jmp    30c <stat+0x3c>
 31f:	90                   	nop

00000320 <atoi>:

int
atoi(const char *s)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	8b 4d 08             	mov    0x8(%ebp),%ecx
 326:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 327:	0f be 11             	movsbl (%ecx),%edx
 32a:	8d 42 d0             	lea    -0x30(%edx),%eax
 32d:	3c 09                	cmp    $0x9,%al
  n = 0;
 32f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 334:	77 17                	ja     34d <atoi+0x2d>
 336:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 338:	83 c1 01             	add    $0x1,%ecx
 33b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 33e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 342:	0f be 11             	movsbl (%ecx),%edx
 345:	8d 5a d0             	lea    -0x30(%edx),%ebx
 348:	80 fb 09             	cmp    $0x9,%bl
 34b:	76 eb                	jbe    338 <atoi+0x18>
  return n;
}
 34d:	5b                   	pop    %ebx
 34e:	5d                   	pop    %ebp
 34f:	c3                   	ret    

00000350 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 350:	55                   	push   %ebp
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 351:	31 d2                	xor    %edx,%edx
{
 353:	89 e5                	mov    %esp,%ebp
 355:	56                   	push   %esi
 356:	8b 45 08             	mov    0x8(%ebp),%eax
 359:	53                   	push   %ebx
 35a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 35d:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n-- > 0)
 360:	85 db                	test   %ebx,%ebx
 362:	7e 12                	jle    376 <memmove+0x26>
 364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 368:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 36c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 36f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 372:	39 da                	cmp    %ebx,%edx
 374:	75 f2                	jne    368 <memmove+0x18>
  return vdst;
}
 376:	5b                   	pop    %ebx
 377:	5e                   	pop    %esi
 378:	5d                   	pop    %ebp
 379:	c3                   	ret    

0000037a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 37a:	b8 01 00 00 00       	mov    $0x1,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <exit>:
SYSCALL(exit)
 382:	b8 02 00 00 00       	mov    $0x2,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <wait>:
SYSCALL(wait)
 38a:	b8 03 00 00 00       	mov    $0x3,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <pipe>:
SYSCALL(pipe)
 392:	b8 04 00 00 00       	mov    $0x4,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <read>:
SYSCALL(read)
 39a:	b8 05 00 00 00       	mov    $0x5,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <write>:
SYSCALL(write)
 3a2:	b8 10 00 00 00       	mov    $0x10,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    

000003aa <close>:
SYSCALL(close)
 3aa:	b8 15 00 00 00       	mov    $0x15,%eax
 3af:	cd 40                	int    $0x40
 3b1:	c3                   	ret    

000003b2 <kill>:
SYSCALL(kill)
 3b2:	b8 06 00 00 00       	mov    $0x6,%eax
 3b7:	cd 40                	int    $0x40
 3b9:	c3                   	ret    

000003ba <exec>:
SYSCALL(exec)
 3ba:	b8 07 00 00 00       	mov    $0x7,%eax
 3bf:	cd 40                	int    $0x40
 3c1:	c3                   	ret    

000003c2 <open>:
SYSCALL(open)
 3c2:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c7:	cd 40                	int    $0x40
 3c9:	c3                   	ret    

000003ca <mknod>:
SYSCALL(mknod)
 3ca:	b8 11 00 00 00       	mov    $0x11,%eax
 3cf:	cd 40                	int    $0x40
 3d1:	c3                   	ret    

000003d2 <unlink>:
SYSCALL(unlink)
 3d2:	b8 12 00 00 00       	mov    $0x12,%eax
 3d7:	cd 40                	int    $0x40
 3d9:	c3                   	ret    

000003da <fstat>:
SYSCALL(fstat)
 3da:	b8 08 00 00 00       	mov    $0x8,%eax
 3df:	cd 40                	int    $0x40
 3e1:	c3                   	ret    

000003e2 <link>:
SYSCALL(link)
 3e2:	b8 13 00 00 00       	mov    $0x13,%eax
 3e7:	cd 40                	int    $0x40
 3e9:	c3                   	ret    

000003ea <mkdir>:
SYSCALL(mkdir)
 3ea:	b8 14 00 00 00       	mov    $0x14,%eax
 3ef:	cd 40                	int    $0x40
 3f1:	c3                   	ret    

000003f2 <chdir>:
SYSCALL(chdir)
 3f2:	b8 09 00 00 00       	mov    $0x9,%eax
 3f7:	cd 40                	int    $0x40
 3f9:	c3                   	ret    

000003fa <dup>:
SYSCALL(dup)
 3fa:	b8 0a 00 00 00       	mov    $0xa,%eax
 3ff:	cd 40                	int    $0x40
 401:	c3                   	ret    

00000402 <getpid>:
SYSCALL(getpid)
 402:	b8 0b 00 00 00       	mov    $0xb,%eax
 407:	cd 40                	int    $0x40
 409:	c3                   	ret    

0000040a <sbrk>:
SYSCALL(sbrk)
 40a:	b8 0c 00 00 00       	mov    $0xc,%eax
 40f:	cd 40                	int    $0x40
 411:	c3                   	ret    

00000412 <sleep>:
SYSCALL(sleep)
 412:	b8 0d 00 00 00       	mov    $0xd,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <uptime>:
SYSCALL(uptime)
 41a:	b8 0e 00 00 00       	mov    $0xe,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <exitStatus>:
SYSCALL(exitStatus)   //cs153_lab1
 422:	b8 16 00 00 00       	mov    $0x16,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <waitStatus>:
SYSCALL(waitStatus)   //cs153_lab1
 42a:	b8 17 00 00 00       	mov    $0x17,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <waitpid>:
SYSCALL(waitpid)      //cs153_lab1
 432:	b8 18 00 00 00       	mov    $0x18,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <getPrior>:
SYSCALL(getPrior)     //add lab2
 43a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <setPrior>:
SYSCALL(setPrior)     //add lab2
 442:	b8 1b 00 00 00       	mov    $0x1b,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <getWaitTime>:
SYSCALL(getWaitTime)  //add lab2
 44a:	b8 1c 00 00 00       	mov    $0x1c,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <getTurnTime>:
 452:	b8 1d 00 00 00       	mov    $0x1d,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    
 45a:	66 90                	xchg   %ax,%ax
 45c:	66 90                	xchg   %ax,%ax
 45e:	66 90                	xchg   %ax,%ax

00000460 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	57                   	push   %edi
 464:	56                   	push   %esi
 465:	89 c6                	mov    %eax,%esi
 467:	53                   	push   %ebx
 468:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 46b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 46e:	85 db                	test   %ebx,%ebx
 470:	74 09                	je     47b <printint+0x1b>
 472:	89 d0                	mov    %edx,%eax
 474:	c1 e8 1f             	shr    $0x1f,%eax
 477:	84 c0                	test   %al,%al
 479:	75 75                	jne    4f0 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 47b:	89 d0                	mov    %edx,%eax
  neg = 0;
 47d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 484:	89 75 c0             	mov    %esi,-0x40(%ebp)
  }

  i = 0;
 487:	31 ff                	xor    %edi,%edi
 489:	89 ce                	mov    %ecx,%esi
 48b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 48e:	eb 02                	jmp    492 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 490:	89 cf                	mov    %ecx,%edi
 492:	31 d2                	xor    %edx,%edx
 494:	f7 f6                	div    %esi
 496:	8d 4f 01             	lea    0x1(%edi),%ecx
 499:	0f b6 92 5e 0a 00 00 	movzbl 0xa5e(%edx),%edx
  }while((x /= base) != 0);
 4a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 4a2:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 4a5:	75 e9                	jne    490 <printint+0x30>
  if(neg)
 4a7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    buf[i++] = digits[x % base];
 4aa:	89 c8                	mov    %ecx,%eax
 4ac:	8b 75 c0             	mov    -0x40(%ebp),%esi
  if(neg)
 4af:	85 d2                	test   %edx,%edx
 4b1:	74 08                	je     4bb <printint+0x5b>
    buf[i++] = '-';
 4b3:	8d 4f 02             	lea    0x2(%edi),%ecx
 4b6:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 4bb:	8d 79 ff             	lea    -0x1(%ecx),%edi
 4be:	66 90                	xchg   %ax,%ax
 4c0:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 4c5:	83 ef 01             	sub    $0x1,%edi
  write(fd, &c, 1);
 4c8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4cf:	00 
 4d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 4d4:	89 34 24             	mov    %esi,(%esp)
 4d7:	88 45 d7             	mov    %al,-0x29(%ebp)
 4da:	e8 c3 fe ff ff       	call   3a2 <write>
  while(--i >= 0)
 4df:	83 ff ff             	cmp    $0xffffffff,%edi
 4e2:	75 dc                	jne    4c0 <printint+0x60>
    putc(fd, buf[i]);
}
 4e4:	83 c4 4c             	add    $0x4c,%esp
 4e7:	5b                   	pop    %ebx
 4e8:	5e                   	pop    %esi
 4e9:	5f                   	pop    %edi
 4ea:	5d                   	pop    %ebp
 4eb:	c3                   	ret    
 4ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    x = -xx;
 4f0:	89 d0                	mov    %edx,%eax
 4f2:	f7 d8                	neg    %eax
    neg = 1;
 4f4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 4fb:	eb 87                	jmp    484 <printint+0x24>
 4fd:	8d 76 00             	lea    0x0(%esi),%esi

00000500 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 504:	31 ff                	xor    %edi,%edi
{
 506:	56                   	push   %esi
 507:	53                   	push   %ebx
 508:	83 ec 3c             	sub    $0x3c,%esp
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 50b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  ap = (uint*)(void*)&fmt + 1;
 50e:	8d 45 10             	lea    0x10(%ebp),%eax
{
 511:	8b 75 08             	mov    0x8(%ebp),%esi
  ap = (uint*)(void*)&fmt + 1;
 514:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 517:	0f b6 13             	movzbl (%ebx),%edx
 51a:	83 c3 01             	add    $0x1,%ebx
 51d:	84 d2                	test   %dl,%dl
 51f:	75 39                	jne    55a <printf+0x5a>
 521:	e9 c2 00 00 00       	jmp    5e8 <printf+0xe8>
 526:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 528:	83 fa 25             	cmp    $0x25,%edx
 52b:	0f 84 bf 00 00 00    	je     5f0 <printf+0xf0>
  write(fd, &c, 1);
 531:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 534:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 53b:	00 
 53c:	89 44 24 04          	mov    %eax,0x4(%esp)
 540:	89 34 24             	mov    %esi,(%esp)
        state = '%';
      } else {
        putc(fd, c);
 543:	88 55 e2             	mov    %dl,-0x1e(%ebp)
  write(fd, &c, 1);
 546:	e8 57 fe ff ff       	call   3a2 <write>
 54b:	83 c3 01             	add    $0x1,%ebx
  for(i = 0; fmt[i]; i++){
 54e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 552:	84 d2                	test   %dl,%dl
 554:	0f 84 8e 00 00 00    	je     5e8 <printf+0xe8>
    if(state == 0){
 55a:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 55c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 55f:	74 c7                	je     528 <printf+0x28>
      }
    } else if(state == '%'){
 561:	83 ff 25             	cmp    $0x25,%edi
 564:	75 e5                	jne    54b <printf+0x4b>
      if(c == 'd'){
 566:	83 fa 64             	cmp    $0x64,%edx
 569:	0f 84 31 01 00 00    	je     6a0 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 56f:	25 f7 00 00 00       	and    $0xf7,%eax
 574:	83 f8 70             	cmp    $0x70,%eax
 577:	0f 84 83 00 00 00    	je     600 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 57d:	83 fa 73             	cmp    $0x73,%edx
 580:	0f 84 a2 00 00 00    	je     628 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 586:	83 fa 63             	cmp    $0x63,%edx
 589:	0f 84 35 01 00 00    	je     6c4 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 58f:	83 fa 25             	cmp    $0x25,%edx
 592:	0f 84 e0 00 00 00    	je     678 <printf+0x178>
  write(fd, &c, 1);
 598:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 59b:	83 c3 01             	add    $0x1,%ebx
 59e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5a5:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5a6:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 5a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ac:	89 34 24             	mov    %esi,(%esp)
 5af:	89 55 d0             	mov    %edx,-0x30(%ebp)
 5b2:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 5b6:	e8 e7 fd ff ff       	call   3a2 <write>
        putc(fd, c);
 5bb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  write(fd, &c, 1);
 5be:	8d 45 e7             	lea    -0x19(%ebp),%eax
 5c1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5c8:	00 
 5c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cd:	89 34 24             	mov    %esi,(%esp)
        putc(fd, c);
 5d0:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 5d3:	e8 ca fd ff ff       	call   3a2 <write>
  for(i = 0; fmt[i]; i++){
 5d8:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 5dc:	84 d2                	test   %dl,%dl
 5de:	0f 85 76 ff ff ff    	jne    55a <printf+0x5a>
 5e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }
}
 5e8:	83 c4 3c             	add    $0x3c,%esp
 5eb:	5b                   	pop    %ebx
 5ec:	5e                   	pop    %esi
 5ed:	5f                   	pop    %edi
 5ee:	5d                   	pop    %ebp
 5ef:	c3                   	ret    
        state = '%';
 5f0:	bf 25 00 00 00       	mov    $0x25,%edi
 5f5:	e9 51 ff ff ff       	jmp    54b <printf+0x4b>
 5fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 600:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 603:	b9 10 00 00 00       	mov    $0x10,%ecx
      state = 0;
 608:	31 ff                	xor    %edi,%edi
        printint(fd, *ap, 16, 0);
 60a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 611:	8b 10                	mov    (%eax),%edx
 613:	89 f0                	mov    %esi,%eax
 615:	e8 46 fe ff ff       	call   460 <printint>
        ap++;
 61a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 61e:	e9 28 ff ff ff       	jmp    54b <printf+0x4b>
 623:	90                   	nop
 624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 628:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 62b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        s = (char*)*ap;
 62f:	8b 38                	mov    (%eax),%edi
          s = "(null)";
 631:	b8 57 0a 00 00       	mov    $0xa57,%eax
 636:	85 ff                	test   %edi,%edi
 638:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 63b:	0f b6 07             	movzbl (%edi),%eax
 63e:	84 c0                	test   %al,%al
 640:	74 2a                	je     66c <printf+0x16c>
 642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 648:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 64b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
          s++;
 64e:	83 c7 01             	add    $0x1,%edi
  write(fd, &c, 1);
 651:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 658:	00 
 659:	89 44 24 04          	mov    %eax,0x4(%esp)
 65d:	89 34 24             	mov    %esi,(%esp)
 660:	e8 3d fd ff ff       	call   3a2 <write>
        while(*s != 0){
 665:	0f b6 07             	movzbl (%edi),%eax
 668:	84 c0                	test   %al,%al
 66a:	75 dc                	jne    648 <printf+0x148>
      state = 0;
 66c:	31 ff                	xor    %edi,%edi
 66e:	e9 d8 fe ff ff       	jmp    54b <printf+0x4b>
 673:	90                   	nop
 674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 678:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      state = 0;
 67b:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 67d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 684:	00 
 685:	89 44 24 04          	mov    %eax,0x4(%esp)
 689:	89 34 24             	mov    %esi,(%esp)
 68c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 690:	e8 0d fd ff ff       	call   3a2 <write>
 695:	e9 b1 fe ff ff       	jmp    54b <printf+0x4b>
 69a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 6a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 6a3:	b9 0a 00 00 00       	mov    $0xa,%ecx
      state = 0;
 6a8:	66 31 ff             	xor    %di,%di
        printint(fd, *ap, 10, 1);
 6ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 6b2:	8b 10                	mov    (%eax),%edx
 6b4:	89 f0                	mov    %esi,%eax
 6b6:	e8 a5 fd ff ff       	call   460 <printint>
        ap++;
 6bb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 6bf:	e9 87 fe ff ff       	jmp    54b <printf+0x4b>
        putc(fd, *ap);
 6c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      state = 0;
 6c7:	31 ff                	xor    %edi,%edi
        putc(fd, *ap);
 6c9:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 6cb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6d2:	00 
 6d3:	89 34 24             	mov    %esi,(%esp)
        putc(fd, *ap);
 6d6:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 6d9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 6dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e0:	e8 bd fc ff ff       	call   3a2 <write>
        ap++;
 6e5:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 6e9:	e9 5d fe ff ff       	jmp    54b <printf+0x4b>
 6ee:	66 90                	xchg   %ax,%ax

000006f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f1:	a1 f0 0c 00 00       	mov    0xcf0,%eax
{
 6f6:	89 e5                	mov    %esp,%ebp
 6f8:	57                   	push   %edi
 6f9:	56                   	push   %esi
 6fa:	53                   	push   %ebx
 6fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6fe:	8b 08                	mov    (%eax),%ecx
  bp = (Header*)ap - 1;
 700:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 703:	39 d0                	cmp    %edx,%eax
 705:	72 11                	jb     718 <free+0x28>
 707:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 708:	39 c8                	cmp    %ecx,%eax
 70a:	72 04                	jb     710 <free+0x20>
 70c:	39 ca                	cmp    %ecx,%edx
 70e:	72 10                	jb     720 <free+0x30>
 710:	89 c8                	mov    %ecx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 712:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 714:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 716:	73 f0                	jae    708 <free+0x18>
 718:	39 ca                	cmp    %ecx,%edx
 71a:	72 04                	jb     720 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71c:	39 c8                	cmp    %ecx,%eax
 71e:	72 f0                	jb     710 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 720:	8b 73 fc             	mov    -0x4(%ebx),%esi
 723:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 726:	39 cf                	cmp    %ecx,%edi
 728:	74 1e                	je     748 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 72a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 72d:	8b 48 04             	mov    0x4(%eax),%ecx
 730:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 733:	39 f2                	cmp    %esi,%edx
 735:	74 28                	je     75f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 737:	89 10                	mov    %edx,(%eax)
  freep = p;
 739:	a3 f0 0c 00 00       	mov    %eax,0xcf0
}
 73e:	5b                   	pop    %ebx
 73f:	5e                   	pop    %esi
 740:	5f                   	pop    %edi
 741:	5d                   	pop    %ebp
 742:	c3                   	ret    
 743:	90                   	nop
 744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 748:	03 71 04             	add    0x4(%ecx),%esi
 74b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 74e:	8b 08                	mov    (%eax),%ecx
 750:	8b 09                	mov    (%ecx),%ecx
 752:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 755:	8b 48 04             	mov    0x4(%eax),%ecx
 758:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 75b:	39 f2                	cmp    %esi,%edx
 75d:	75 d8                	jne    737 <free+0x47>
    p->s.size += bp->s.size;
 75f:	03 4b fc             	add    -0x4(%ebx),%ecx
  freep = p;
 762:	a3 f0 0c 00 00       	mov    %eax,0xcf0
    p->s.size += bp->s.size;
 767:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 76a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 76d:	89 10                	mov    %edx,(%eax)
}
 76f:	5b                   	pop    %ebx
 770:	5e                   	pop    %esi
 771:	5f                   	pop    %edi
 772:	5d                   	pop    %ebp
 773:	c3                   	ret    
 774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 77a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000780 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 780:	55                   	push   %ebp
 781:	89 e5                	mov    %esp,%ebp
 783:	57                   	push   %edi
 784:	56                   	push   %esi
 785:	53                   	push   %ebx
 786:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 789:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 78c:	8b 1d f0 0c 00 00    	mov    0xcf0,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 792:	8d 48 07             	lea    0x7(%eax),%ecx
 795:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 798:	85 db                	test   %ebx,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 79a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 79d:	0f 84 9b 00 00 00    	je     83e <malloc+0xbe>
 7a3:	8b 13                	mov    (%ebx),%edx
 7a5:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 7a8:	39 fe                	cmp    %edi,%esi
 7aa:	76 64                	jbe    810 <malloc+0x90>
 7ac:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  if(nu < 4096)
 7b3:	bb 00 80 00 00       	mov    $0x8000,%ebx
 7b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 7bb:	eb 0e                	jmp    7cb <malloc+0x4b>
 7bd:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7c2:	8b 78 04             	mov    0x4(%eax),%edi
 7c5:	39 fe                	cmp    %edi,%esi
 7c7:	76 4f                	jbe    818 <malloc+0x98>
 7c9:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7cb:	3b 15 f0 0c 00 00    	cmp    0xcf0,%edx
 7d1:	75 ed                	jne    7c0 <malloc+0x40>
  if(nu < 4096)
 7d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7d6:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 7dc:	bf 00 10 00 00       	mov    $0x1000,%edi
 7e1:	0f 43 fe             	cmovae %esi,%edi
 7e4:	0f 42 c3             	cmovb  %ebx,%eax
  p = sbrk(nu * sizeof(Header));
 7e7:	89 04 24             	mov    %eax,(%esp)
 7ea:	e8 1b fc ff ff       	call   40a <sbrk>
  if(p == (char*)-1)
 7ef:	83 f8 ff             	cmp    $0xffffffff,%eax
 7f2:	74 18                	je     80c <malloc+0x8c>
  hp->s.size = nu;
 7f4:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 7f7:	83 c0 08             	add    $0x8,%eax
 7fa:	89 04 24             	mov    %eax,(%esp)
 7fd:	e8 ee fe ff ff       	call   6f0 <free>
  return freep;
 802:	8b 15 f0 0c 00 00    	mov    0xcf0,%edx
      if((p = morecore(nunits)) == 0)
 808:	85 d2                	test   %edx,%edx
 80a:	75 b4                	jne    7c0 <malloc+0x40>
        return 0;
 80c:	31 c0                	xor    %eax,%eax
 80e:	eb 20                	jmp    830 <malloc+0xb0>
    if(p->s.size >= nunits){
 810:	89 d0                	mov    %edx,%eax
 812:	89 da                	mov    %ebx,%edx
 814:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 818:	39 fe                	cmp    %edi,%esi
 81a:	74 1c                	je     838 <malloc+0xb8>
        p->s.size -= nunits;
 81c:	29 f7                	sub    %esi,%edi
 81e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 821:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 824:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 827:	89 15 f0 0c 00 00    	mov    %edx,0xcf0
      return (void*)(p + 1);
 82d:	83 c0 08             	add    $0x8,%eax
  }
}
 830:	83 c4 1c             	add    $0x1c,%esp
 833:	5b                   	pop    %ebx
 834:	5e                   	pop    %esi
 835:	5f                   	pop    %edi
 836:	5d                   	pop    %ebp
 837:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 838:	8b 08                	mov    (%eax),%ecx
 83a:	89 0a                	mov    %ecx,(%edx)
 83c:	eb e9                	jmp    827 <malloc+0xa7>
    base.s.ptr = freep = prevp = &base;
 83e:	c7 05 f0 0c 00 00 f4 	movl   $0xcf4,0xcf0
 845:	0c 00 00 
    base.s.size = 0;
 848:	ba f4 0c 00 00       	mov    $0xcf4,%edx
    base.s.ptr = freep = prevp = &base;
 84d:	c7 05 f4 0c 00 00 f4 	movl   $0xcf4,0xcf4
 854:	0c 00 00 
    base.s.size = 0;
 857:	c7 05 f8 0c 00 00 00 	movl   $0x0,0xcf8
 85e:	00 00 00 
 861:	e9 46 ff ff ff       	jmp    7ac <malloc+0x2c>
