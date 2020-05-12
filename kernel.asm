
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 00 2e 10 80       	mov    $0x80102e00,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 14             	sub    $0x14,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 80 72 10 	movl   $0x80107280,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 20 45 00 00       	call   80104580 <initlock>
  bcache.head.next = &bcache.head;
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 87 72 10 	movl   $0x80107287,0x4(%esp)
8010009b:	80 
8010009c:	e8 af 43 00 00       	call   80104450 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
    bcache.head.next = b;
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&bcache.lock);
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000e6:	e8 05 46 00 00       	call   801046f0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 fa 45 00 00       	call   80104760 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 1f 43 00 00       	call   80104490 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 b2 1f 00 00       	call   80102130 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
  panic("bget: no buffers");
80100188:	c7 04 24 8e 72 10 80 	movl   $0x8010728e,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 7b 43 00 00       	call   80104530 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
  iderw(b);
801001c4:	e9 67 1f 00 00       	jmp    80102130 <iderw>
    panic("bwrite");
801001c9:	c7 04 24 9f 72 10 80 	movl   $0x8010729f,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 3a 43 00 00       	call   80104530 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 ee 42 00 00       	call   801044f0 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 e2 44 00 00       	call   801046f0 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100250:	e9 0b 45 00 00       	jmp    80104760 <release>
    panic("brelse");
80100255:	c7 04 24 a6 72 10 80 	movl   $0x801072a6,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 19 15 00 00       	call   801017a0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 5d 44 00 00       	call   801046f0 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 33 34 00 00       	call   801036e0 <myproc>
801002ad:	8b 40 28             	mov    0x28(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 38 3c 00 00       	call   80103f00 <sleep>
    while(input.r == input.w){
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 4a 44 00 00       	call   80104760 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 a2 13 00 00       	call   801016c0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 2c 44 00 00       	call   80104760 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 84 13 00 00       	call   801016c0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        input.r--;
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 f5 23 00 00       	call   80102770 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 ad 72 10 80 	movl   $0x801072ad,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 77 7c 10 80 	movl   $0x80107c77,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 ec 41 00 00       	call   801045a0 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 c1 72 10 80 	movl   $0x801072c1,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 d2 59 00 00       	call   80105de0 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx
  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 
  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 22 59 00 00       	call   80105de0 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 16 59 00 00       	call   80105de0 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 0a 59 00 00       	call   80105de0 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 4f 43 00 00       	call   80104850 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 92 42 00 00       	call   801047b0 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    panic("pos under/overflow");
8010052a:	c7 04 24 c5 72 10 80 	movl   $0x801072c5,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 f0 72 10 80 	movzbl -0x7fef8d10(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>
  if(sign)
801005a8:	85 ff                	test   %edi,%edi
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 99 11 00 00       	call   801017a0 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 dd 40 00 00       	call   801046f0 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 25 41 00 00       	call   80104760 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 7a 10 00 00       	call   801016c0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 68 40 00 00       	call   80104760 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 d8 72 10 80       	mov    $0x801072d8,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 54 3f 00 00       	call   801046f0 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>
    panic("null fmt");
801007a1:	c7 04 24 df 72 10 80 	movl   $0x801072df,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 26 3f 00 00       	call   801046f0 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
      if(input.e != input.w){
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 34 3f 00 00       	call   80104760 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          wakeup(&input.r);
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
          input.w = input.e;
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008b2:	e8 d9 39 00 00       	call   80104290 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
      while(input.e != input.w &&
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 54 3a 00 00       	jmp    80104380 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 e8 72 10 	movl   $0x801072e8,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 16 3c 00 00       	call   80104580 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100997:	e8 24 19 00 00       	call   801022c0 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 2f 2d 00 00       	call   801036e0 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 64 21 00 00       	call   80102b20 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 49 15 00 00       	call   80101f10 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 c2 01 00 00    	je     80100b93 <exec+0x1f3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 e7 0c 00 00       	call   801016c0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 75 0f 00 00       	call   80101970 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 18 0f 00 00       	call   80101920 <iunlockput>
    end_op();
80100a08:	e8 83 21 00 00       	call   80102b90 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 9f 65 00 00       	call   80106fd0 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 dd 0e 00 00       	call   80101970 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 69 63 00 00       	call   80106e40 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 68 62 00 00       	call   80106d80 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 22 64 00 00       	call   80106f50 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 e5 0d 00 00       	call   80101920 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 4b 20 00 00       	call   80102b90 <end_op>
  sz = PGROUNDUP(sz);
80100b45:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b55:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 cf 62 00 00       	call   80106e40 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100b79:	75 33                	jne    80100bae <exec+0x20e>
    freevm(pgdir);
80100b7b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 c7 63 00 00       	call   80106f50 <freevm>
  return -1;
80100b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8e:	e9 7f fe ff ff       	jmp    80100a12 <exec+0x72>
    end_op();
80100b93:	e8 f8 1f 00 00       	call   80102b90 <end_op>
    cprintf("exec: fail\n");
80100b98:	c7 04 24 01 73 10 80 	movl   $0x80107301,(%esp)
80100b9f:	e8 ac fa ff ff       	call   80100650 <cprintf>
    return -1;
80100ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba9:	e9 64 fe ff ff       	jmp    80100a12 <exec+0x72>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bae:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100bb4:	89 d8                	mov    %ebx,%eax
80100bb6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bc5:	89 04 24             	mov    %eax,(%esp)
80100bc8:	e8 b3 64 00 00       	call   80107080 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bd0:	8b 00                	mov    (%eax),%eax
80100bd2:	85 c0                	test   %eax,%eax
80100bd4:	0f 84 65 01 00 00    	je     80100d3f <exec+0x39f>
80100bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bdd:	31 d2                	xor    %edx,%edx
80100bdf:	8d 71 04             	lea    0x4(%ecx),%esi
80100be2:	89 cf                	mov    %ecx,%edi
80100be4:	89 d1                	mov    %edx,%ecx
80100be6:	89 f2                	mov    %esi,%edx
80100be8:	89 fe                	mov    %edi,%esi
80100bea:	89 cf                	mov    %ecx,%edi
80100bec:	eb 0a                	jmp    80100bf8 <exec+0x258>
80100bee:	66 90                	xchg   %ax,%ax
80100bf0:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bf3:	83 ff 20             	cmp    $0x20,%edi
80100bf6:	74 83                	je     80100b7b <exec+0x1db>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bf8:	89 04 24             	mov    %eax,(%esp)
80100bfb:	89 95 ec fe ff ff    	mov    %edx,-0x114(%ebp)
80100c01:	e8 ca 3d 00 00       	call   801049d0 <strlen>
80100c06:	f7 d0                	not    %eax
80100c08:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0a:	8b 06                	mov    (%esi),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c0c:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0f:	89 04 24             	mov    %eax,(%esp)
80100c12:	e8 b9 3d 00 00       	call   801049d0 <strlen>
80100c17:	83 c0 01             	add    $0x1,%eax
80100c1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c1e:	8b 06                	mov    (%esi),%eax
80100c20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c24:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c28:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c2e:	89 04 24             	mov    %eax,(%esp)
80100c31:	e8 aa 65 00 00       	call   801071e0 <copyout>
80100c36:	85 c0                	test   %eax,%eax
80100c38:	0f 88 3d ff ff ff    	js     80100b7b <exec+0x1db>
  for(argc = 0; argv[argc]; argc++) {
80100c3e:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
    ustack[3+argc] = sp;
80100c44:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100c4a:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c51:	83 c7 01             	add    $0x1,%edi
80100c54:	8b 02                	mov    (%edx),%eax
80100c56:	89 d6                	mov    %edx,%esi
80100c58:	85 c0                	test   %eax,%eax
80100c5a:	75 94                	jne    80100bf0 <exec+0x250>
80100c5c:	89 fa                	mov    %edi,%edx
  ustack[3+argc] = 0;
80100c5e:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100c65:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c69:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
  ustack[1] = argc;
80100c70:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c76:	89 da                	mov    %ebx,%edx
80100c78:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100c7a:	83 c0 0c             	add    $0xc,%eax
80100c7d:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c83:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c8d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  ustack[0] = 0xffffffff;  // fake return PC
80100c91:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c98:	ff ff ff 
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c9b:	89 04 24             	mov    %eax,(%esp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c9e:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ca4:	e8 37 65 00 00       	call   801071e0 <copyout>
80100ca9:	85 c0                	test   %eax,%eax
80100cab:	0f 88 ca fe ff ff    	js     80100b7b <exec+0x1db>
  for(last=s=path; *s; s++)
80100cb1:	8b 45 08             	mov    0x8(%ebp),%eax
80100cb4:	0f b6 10             	movzbl (%eax),%edx
80100cb7:	84 d2                	test   %dl,%dl
80100cb9:	74 19                	je     80100cd4 <exec+0x334>
80100cbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cbe:	83 c0 01             	add    $0x1,%eax
      last = s+1;
80100cc1:	80 fa 2f             	cmp    $0x2f,%dl
  for(last=s=path; *s; s++)
80100cc4:	0f b6 10             	movzbl (%eax),%edx
      last = s+1;
80100cc7:	0f 44 c8             	cmove  %eax,%ecx
80100cca:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100ccd:	84 d2                	test   %dl,%dl
80100ccf:	75 f0                	jne    80100cc1 <exec+0x321>
80100cd1:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cd4:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cda:	8b 45 08             	mov    0x8(%ebp),%eax
80100cdd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100ce4:	00 
80100ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce9:	89 f8                	mov    %edi,%eax
80100ceb:	83 c0 70             	add    $0x70,%eax
80100cee:	89 04 24             	mov    %eax,(%esp)
80100cf1:	e8 9a 3c 00 00       	call   80104990 <safestrcpy>
  curproc->pgdir = pgdir;
80100cf6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100cfc:	8b 77 08             	mov    0x8(%edi),%esi
  curproc->tf->eip = elf.entry;  // main
80100cff:	8b 47 1c             	mov    0x1c(%edi),%eax
  curproc->pgdir = pgdir;
80100d02:	89 4f 08             	mov    %ecx,0x8(%edi)
  curproc->sz = sz;
80100d05:	8b 8d e8 fe ff ff    	mov    -0x118(%ebp),%ecx
80100d0b:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d0e:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d14:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d17:	8b 47 1c             	mov    0x1c(%edi),%eax
80100d1a:	89 58 44             	mov    %ebx,0x44(%eax)
  curproc->turnTime = ticks; //cs153_lab2: set process turn time to # of cpu ticks
80100d1d:	a1 a0 59 11 80       	mov    0x801159a0,%eax
80100d22:	89 87 88 00 00 00    	mov    %eax,0x88(%edi)
  switchuvm(curproc);
80100d28:	89 3c 24             	mov    %edi,(%esp)
80100d2b:	e8 c0 5e 00 00       	call   80106bf0 <switchuvm>
  freevm(oldpgdir);
80100d30:	89 34 24             	mov    %esi,(%esp)
80100d33:	e8 18 62 00 00       	call   80106f50 <freevm>
  return 0;
80100d38:	31 c0                	xor    %eax,%eax
80100d3a:	e9 d3 fc ff ff       	jmp    80100a12 <exec+0x72>
  for(argc = 0; argv[argc]; argc++) {
80100d3f:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100d45:	31 d2                	xor    %edx,%edx
80100d47:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d4d:	e9 0c ff ff ff       	jmp    80100c5e <exec+0x2be>
80100d52:	66 90                	xchg   %ax,%ax
80100d54:	66 90                	xchg   %ax,%ax
80100d56:	66 90                	xchg   %ax,%ax
80100d58:	66 90                	xchg   %ax,%ax
80100d5a:	66 90                	xchg   %ax,%ax
80100d5c:	66 90                	xchg   %ax,%ax
80100d5e:	66 90                	xchg   %ax,%ax

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	c7 44 24 04 0d 73 10 	movl   $0x8010730d,0x4(%esp)
80100d6d:	80 
80100d6e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d75:	e8 06 38 00 00       	call   80104580 <initlock>
}
80100d7a:	c9                   	leave  
80100d7b:	c3                   	ret    
80100d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d89:	83 ec 14             	sub    $0x14,%esp
  acquire(&ftable.lock);
80100d8c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d93:	e8 58 39 00 00       	call   801046f0 <acquire>
80100d98:	eb 11                	jmp    80100dab <filealloc+0x2b>
80100d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100da9:	74 25                	je     80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
      f->ref = 1;
80100db9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dc0:	e8 9b 39 00 00       	call   80104760 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc5:	83 c4 14             	add    $0x14,%esp
      return f;
80100dc8:	89 d8                	mov    %ebx,%eax
}
80100dca:	5b                   	pop    %ebx
80100dcb:	5d                   	pop    %ebp
80100dcc:	c3                   	ret    
80100dcd:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ftable.lock);
80100dd0:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dd7:	e8 84 39 00 00       	call   80104760 <release>
}
80100ddc:	83 c4 14             	add    $0x14,%esp
  return 0;
80100ddf:	31 c0                	xor    %eax,%eax
}
80100de1:	5b                   	pop    %ebx
80100de2:	5d                   	pop    %ebp
80100de3:	c3                   	ret    
80100de4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 14             	sub    $0x14,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e01:	e8 ea 38 00 00       	call   801046f0 <acquire>
  if(f->ref < 1)
80100e06:	8b 43 04             	mov    0x4(%ebx),%eax
80100e09:	85 c0                	test   %eax,%eax
80100e0b:	7e 1a                	jle    80100e27 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100e0d:	83 c0 01             	add    $0x1,%eax
80100e10:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e13:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e1a:	e8 41 39 00 00       	call   80104760 <release>
  return f;
}
80100e1f:	83 c4 14             	add    $0x14,%esp
80100e22:	89 d8                	mov    %ebx,%eax
80100e24:	5b                   	pop    %ebx
80100e25:	5d                   	pop    %ebp
80100e26:	c3                   	ret    
    panic("filedup");
80100e27:	c7 04 24 14 73 10 80 	movl   $0x80107314,(%esp)
80100e2e:	e8 2d f5 ff ff       	call   80100360 <panic>
80100e33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 1c             	sub    $0x1c,%esp
80100e49:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e53:	e8 98 38 00 00       	call   801046f0 <acquire>
  if(f->ref < 1)
80100e58:	8b 57 04             	mov    0x4(%edi),%edx
80100e5b:	85 d2                	test   %edx,%edx
80100e5d:	0f 8e 89 00 00 00    	jle    80100eec <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e63:	83 ea 01             	sub    $0x1,%edx
80100e66:	85 d2                	test   %edx,%edx
80100e68:	89 57 04             	mov    %edx,0x4(%edi)
80100e6b:	74 13                	je     80100e80 <fileclose+0x40>
    release(&ftable.lock);
80100e6d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e74:	83 c4 1c             	add    $0x1c,%esp
80100e77:	5b                   	pop    %ebx
80100e78:	5e                   	pop    %esi
80100e79:	5f                   	pop    %edi
80100e7a:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7b:	e9 e0 38 00 00       	jmp    80104760 <release>
  ff = *f;
80100e80:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e84:	8b 37                	mov    (%edi),%esi
80100e86:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->type = FD_NONE;
80100e89:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  ff = *f;
80100e8f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e92:	8b 47 10             	mov    0x10(%edi),%eax
  release(&ftable.lock);
80100e95:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  ff = *f;
80100e9c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100e9f:	e8 bc 38 00 00       	call   80104760 <release>
  if(ff.type == FD_PIPE)
80100ea4:	83 fe 01             	cmp    $0x1,%esi
80100ea7:	74 0f                	je     80100eb8 <fileclose+0x78>
  else if(ff.type == FD_INODE){
80100ea9:	83 fe 02             	cmp    $0x2,%esi
80100eac:	74 22                	je     80100ed0 <fileclose+0x90>
}
80100eae:	83 c4 1c             	add    $0x1c,%esp
80100eb1:	5b                   	pop    %ebx
80100eb2:	5e                   	pop    %esi
80100eb3:	5f                   	pop    %edi
80100eb4:	5d                   	pop    %ebp
80100eb5:	c3                   	ret    
80100eb6:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100eb8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100ebc:	89 1c 24             	mov    %ebx,(%esp)
80100ebf:	89 74 24 04          	mov    %esi,0x4(%esp)
80100ec3:	e8 a8 23 00 00       	call   80103270 <pipeclose>
80100ec8:	eb e4                	jmp    80100eae <fileclose+0x6e>
80100eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    begin_op();
80100ed0:	e8 4b 1c 00 00       	call   80102b20 <begin_op>
    iput(ff.ip);
80100ed5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ed8:	89 04 24             	mov    %eax,(%esp)
80100edb:	e8 00 09 00 00       	call   801017e0 <iput>
}
80100ee0:	83 c4 1c             	add    $0x1c,%esp
80100ee3:	5b                   	pop    %ebx
80100ee4:	5e                   	pop    %esi
80100ee5:	5f                   	pop    %edi
80100ee6:	5d                   	pop    %ebp
    end_op();
80100ee7:	e9 a4 1c 00 00       	jmp    80102b90 <end_op>
    panic("fileclose");
80100eec:	c7 04 24 1c 73 10 80 	movl   $0x8010731c,(%esp)
80100ef3:	e8 68 f4 ff ff       	call   80100360 <panic>
80100ef8:	90                   	nop
80100ef9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f00 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 14             	sub    $0x14,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f0a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f0d:	75 31                	jne    80100f40 <filestat+0x40>
    ilock(f->ip);
80100f0f:	8b 43 10             	mov    0x10(%ebx),%eax
80100f12:	89 04 24             	mov    %eax,(%esp)
80100f15:	e8 a6 07 00 00       	call   801016c0 <ilock>
    stati(f->ip, st);
80100f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f1d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f21:	8b 43 10             	mov    0x10(%ebx),%eax
80100f24:	89 04 24             	mov    %eax,(%esp)
80100f27:	e8 14 0a 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f2c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f2f:	89 04 24             	mov    %eax,(%esp)
80100f32:	e8 69 08 00 00       	call   801017a0 <iunlock>
    return 0;
  }
  return -1;
}
80100f37:	83 c4 14             	add    $0x14,%esp
    return 0;
80100f3a:	31 c0                	xor    %eax,%eax
}
80100f3c:	5b                   	pop    %ebx
80100f3d:	5d                   	pop    %ebp
80100f3e:	c3                   	ret    
80100f3f:	90                   	nop
80100f40:	83 c4 14             	add    $0x14,%esp
  return -1;
80100f43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f48:	5b                   	pop    %ebx
80100f49:	5d                   	pop    %ebp
80100f4a:	c3                   	ret    
80100f4b:	90                   	nop
80100f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f50 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 1c             	sub    $0x1c,%esp
80100f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f62:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f66:	74 68                	je     80100fd0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f68:	8b 03                	mov    (%ebx),%eax
80100f6a:	83 f8 01             	cmp    $0x1,%eax
80100f6d:	74 49                	je     80100fb8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f6f:	83 f8 02             	cmp    $0x2,%eax
80100f72:	75 63                	jne    80100fd7 <fileread+0x87>
    ilock(f->ip);
80100f74:	8b 43 10             	mov    0x10(%ebx),%eax
80100f77:	89 04 24             	mov    %eax,(%esp)
80100f7a:	e8 41 07 00 00       	call   801016c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f83:	8b 43 14             	mov    0x14(%ebx),%eax
80100f86:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f8a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f8e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f91:	89 04 24             	mov    %eax,(%esp)
80100f94:	e8 d7 09 00 00       	call   80101970 <readi>
80100f99:	85 c0                	test   %eax,%eax
80100f9b:	89 c6                	mov    %eax,%esi
80100f9d:	7e 03                	jle    80100fa2 <fileread+0x52>
      f->off += r;
80100f9f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa2:	8b 43 10             	mov    0x10(%ebx),%eax
80100fa5:	89 04 24             	mov    %eax,(%esp)
80100fa8:	e8 f3 07 00 00       	call   801017a0 <iunlock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fad:	89 f0                	mov    %esi,%eax
    return r;
  }
  panic("fileread");
}
80100faf:	83 c4 1c             	add    $0x1c,%esp
80100fb2:	5b                   	pop    %ebx
80100fb3:	5e                   	pop    %esi
80100fb4:	5f                   	pop    %edi
80100fb5:	5d                   	pop    %ebp
80100fb6:	c3                   	ret    
80100fb7:	90                   	nop
    return piperead(f->pipe, addr, n);
80100fb8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fbb:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fbe:	83 c4 1c             	add    $0x1c,%esp
80100fc1:	5b                   	pop    %ebx
80100fc2:	5e                   	pop    %esi
80100fc3:	5f                   	pop    %edi
80100fc4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fc5:	e9 26 24 00 00       	jmp    801033f0 <piperead>
80100fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fd5:	eb d8                	jmp    80100faf <fileread+0x5f>
  panic("fileread");
80100fd7:	c7 04 24 26 73 10 80 	movl   $0x80107326,(%esp)
80100fde:	e8 7d f3 ff ff       	call   80100360 <panic>
80100fe3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 2c             	sub    $0x2c,%esp
80100ff9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ffc:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fff:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101002:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101005:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
{
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 ae 00 00 00    	je     801010c0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 07                	mov    (%edi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c2 00 00 00    	je     801010df <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d7 00 00 00    	jne    801010fd <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101029:	31 db                	xor    %ebx,%ebx
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 31                	jg     80101060 <filewrite+0x70>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101038:	8b 4f 10             	mov    0x10(%edi),%ecx
        f->off += r;
8010103b:	01 47 14             	add    %eax,0x14(%edi)
8010103e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101041:	89 0c 24             	mov    %ecx,(%esp)
80101044:	e8 57 07 00 00       	call   801017a0 <iunlock>
      end_op();
80101049:	e8 42 1b 00 00       	call   80102b90 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101051:	39 f0                	cmp    %esi,%eax
80101053:	0f 85 98 00 00 00    	jne    801010f1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101059:	01 c3                	add    %eax,%ebx
    while(i < n){
8010105b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010105e:	7e 70                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101060:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101063:	b8 00 06 00 00       	mov    $0x600,%eax
80101068:	29 de                	sub    %ebx,%esi
8010106a:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80101070:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
80101073:	e8 a8 1a 00 00       	call   80102b20 <begin_op>
      ilock(f->ip);
80101078:	8b 47 10             	mov    0x10(%edi),%eax
8010107b:	89 04 24             	mov    %eax,(%esp)
8010107e:	e8 3d 06 00 00       	call   801016c0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101083:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101087:	8b 47 14             	mov    0x14(%edi),%eax
8010108a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010108e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101091:	01 d8                	add    %ebx,%eax
80101093:	89 44 24 04          	mov    %eax,0x4(%esp)
80101097:	8b 47 10             	mov    0x10(%edi),%eax
8010109a:	89 04 24             	mov    %eax,(%esp)
8010109d:	e8 ce 09 00 00       	call   80101a70 <writei>
801010a2:	85 c0                	test   %eax,%eax
801010a4:	7f 92                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
801010a6:	8b 4f 10             	mov    0x10(%edi),%ecx
801010a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010ac:	89 0c 24             	mov    %ecx,(%esp)
801010af:	e8 ec 06 00 00       	call   801017a0 <iunlock>
      end_op();
801010b4:	e8 d7 1a 00 00       	call   80102b90 <end_op>
      if(r < 0)
801010b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010bc:	85 c0                	test   %eax,%eax
801010be:	74 91                	je     80101051 <filewrite+0x61>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010c0:	83 c4 2c             	add    $0x2c,%esp
    return -1;
801010c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010c8:	5b                   	pop    %ebx
801010c9:	5e                   	pop    %esi
801010ca:	5f                   	pop    %edi
801010cb:	5d                   	pop    %ebp
801010cc:	c3                   	ret    
801010cd:	8d 76 00             	lea    0x0(%esi),%esi
    return i == n ? n : -1;
801010d0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010d3:	89 d8                	mov    %ebx,%eax
801010d5:	75 e9                	jne    801010c0 <filewrite+0xd0>
}
801010d7:	83 c4 2c             	add    $0x2c,%esp
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801010df:	8b 47 0c             	mov    0xc(%edi),%eax
801010e2:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e5:	83 c4 2c             	add    $0x2c,%esp
801010e8:	5b                   	pop    %ebx
801010e9:	5e                   	pop    %esi
801010ea:	5f                   	pop    %edi
801010eb:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ec:	e9 0f 22 00 00       	jmp    80103300 <pipewrite>
        panic("short filewrite");
801010f1:	c7 04 24 2f 73 10 80 	movl   $0x8010732f,(%esp)
801010f8:	e8 63 f2 ff ff       	call   80100360 <panic>
  panic("filewrite");
801010fd:	c7 04 24 35 73 10 80 	movl   $0x80107335,(%esp)
80101104:	e8 57 f2 ff ff       	call   80100360 <panic>
80101109:	66 90                	xchg   %ax,%ax
8010110b:	66 90                	xchg   %ax,%ax
8010110d:	66 90                	xchg   %ax,%ax
8010110f:	90                   	nop

80101110 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	89 d7                	mov    %edx,%edi
80101116:	56                   	push   %esi
80101117:	53                   	push   %ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101118:	bb 01 00 00 00       	mov    $0x1,%ebx
{
8010111d:	83 ec 1c             	sub    $0x1c,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101120:	c1 ea 0c             	shr    $0xc,%edx
80101123:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101129:	89 04 24             	mov    %eax,(%esp)
8010112c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101130:	e8 9b ef ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
80101135:	89 f9                	mov    %edi,%ecx
  bi = b % BPB;
80101137:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
8010113d:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
8010113f:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101142:	c1 fa 03             	sar    $0x3,%edx
  m = 1 << (bi % 8);
80101145:	d3 e3                	shl    %cl,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101147:	89 c6                	mov    %eax,%esi
  if((bp->data[bi/8] & m) == 0)
80101149:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
8010114e:	0f b6 c8             	movzbl %al,%ecx
80101151:	85 d9                	test   %ebx,%ecx
80101153:	74 20                	je     80101175 <bfree+0x65>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101155:	f7 d3                	not    %ebx
80101157:	21 c3                	and    %eax,%ebx
80101159:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
8010115d:	89 34 24             	mov    %esi,(%esp)
80101160:	e8 5b 1b 00 00       	call   80102cc0 <log_write>
  brelse(bp);
80101165:	89 34 24             	mov    %esi,(%esp)
80101168:	e8 73 f0 ff ff       	call   801001e0 <brelse>
}
8010116d:	83 c4 1c             	add    $0x1c,%esp
80101170:	5b                   	pop    %ebx
80101171:	5e                   	pop    %esi
80101172:	5f                   	pop    %edi
80101173:	5d                   	pop    %ebp
80101174:	c3                   	ret    
    panic("freeing free block");
80101175:	c7 04 24 3f 73 10 80 	movl   $0x8010733f,(%esp)
8010117c:	e8 df f1 ff ff       	call   80100360 <panic>
80101181:	eb 0d                	jmp    80101190 <balloc>
80101183:	90                   	nop
80101184:	90                   	nop
80101185:	90                   	nop
80101186:	90                   	nop
80101187:	90                   	nop
80101188:	90                   	nop
80101189:	90                   	nop
8010118a:	90                   	nop
8010118b:	90                   	nop
8010118c:	90                   	nop
8010118d:	90                   	nop
8010118e:	90                   	nop
8010118f:	90                   	nop

80101190 <balloc>:
{
80101190:	55                   	push   %ebp
80101191:	89 e5                	mov    %esp,%ebp
80101193:	57                   	push   %edi
80101194:	56                   	push   %esi
80101195:	53                   	push   %ebx
80101196:	83 ec 2c             	sub    $0x2c,%esp
80101199:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
8010119c:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011a1:	85 c0                	test   %eax,%eax
801011a3:	0f 84 8c 00 00 00    	je     80101235 <balloc+0xa5>
801011a9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011b0:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011b3:	89 f0                	mov    %esi,%eax
801011b5:	c1 f8 0c             	sar    $0xc,%eax
801011b8:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011be:	89 44 24 04          	mov    %eax,0x4(%esp)
801011c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011c5:	89 04 24             	mov    %eax,(%esp)
801011c8:	e8 03 ef ff ff       	call   801000d0 <bread>
801011cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011d0:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011d5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011d8:	31 c0                	xor    %eax,%eax
801011da:	eb 33                	jmp    8010120f <balloc+0x7f>
801011dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011e0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011e3:	89 c2                	mov    %eax,%edx
      m = 1 << (bi % 8);
801011e5:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011e7:	c1 fa 03             	sar    $0x3,%edx
      m = 1 << (bi % 8);
801011ea:	83 e1 07             	and    $0x7,%ecx
801011ed:	bf 01 00 00 00       	mov    $0x1,%edi
801011f2:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011f4:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx
      m = 1 << (bi % 8);
801011f9:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011fb:	0f b6 fb             	movzbl %bl,%edi
801011fe:	85 cf                	test   %ecx,%edi
80101200:	74 46                	je     80101248 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101202:	83 c0 01             	add    $0x1,%eax
80101205:	83 c6 01             	add    $0x1,%esi
80101208:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010120d:	74 05                	je     80101214 <balloc+0x84>
8010120f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101212:	72 cc                	jb     801011e0 <balloc+0x50>
    brelse(bp);
80101214:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101217:	89 04 24             	mov    %eax,(%esp)
8010121a:	e8 c1 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010121f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101226:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101229:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
8010122f:	0f 82 7b ff ff ff    	jb     801011b0 <balloc+0x20>
  panic("balloc: out of blocks");
80101235:	c7 04 24 52 73 10 80 	movl   $0x80107352,(%esp)
8010123c:	e8 1f f1 ff ff       	call   80100360 <panic>
80101241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101248:	09 d9                	or     %ebx,%ecx
8010124a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010124d:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
80101251:	89 1c 24             	mov    %ebx,(%esp)
80101254:	e8 67 1a 00 00       	call   80102cc0 <log_write>
        brelse(bp);
80101259:	89 1c 24             	mov    %ebx,(%esp)
8010125c:	e8 7f ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
80101261:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101264:	89 74 24 04          	mov    %esi,0x4(%esp)
80101268:	89 04 24             	mov    %eax,(%esp)
8010126b:	e8 60 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101270:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101277:	00 
80101278:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010127f:	00 
  bp = bread(dev, bno);
80101280:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101282:	8d 40 5c             	lea    0x5c(%eax),%eax
80101285:	89 04 24             	mov    %eax,(%esp)
80101288:	e8 23 35 00 00       	call   801047b0 <memset>
  log_write(bp);
8010128d:	89 1c 24             	mov    %ebx,(%esp)
80101290:	e8 2b 1a 00 00       	call   80102cc0 <log_write>
  brelse(bp);
80101295:	89 1c 24             	mov    %ebx,(%esp)
80101298:	e8 43 ef ff ff       	call   801001e0 <brelse>
}
8010129d:	83 c4 2c             	add    $0x2c,%esp
801012a0:	89 f0                	mov    %esi,%eax
801012a2:	5b                   	pop    %ebx
801012a3:	5e                   	pop    %esi
801012a4:	5f                   	pop    %edi
801012a5:	5d                   	pop    %ebp
801012a6:	c3                   	ret    
801012a7:	89 f6                	mov    %esi,%esi
801012a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801012b0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012b0:	55                   	push   %ebp
801012b1:	89 e5                	mov    %esp,%ebp
801012b3:	57                   	push   %edi
801012b4:	89 c7                	mov    %eax,%edi
801012b6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012b7:	31 f6                	xor    %esi,%esi
{
801012b9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ba:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
801012bf:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&icache.lock);
801012c2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
{
801012c9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012cc:	e8 1f 34 00 00       	call   801046f0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012d4:	eb 14                	jmp    801012ea <iget+0x3a>
801012d6:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012d8:	85 f6                	test   %esi,%esi
801012da:	74 3c                	je     80101318 <iget+0x68>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012dc:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e2:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
801012e8:	74 46                	je     80101330 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ea:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012ed:	85 c9                	test   %ecx,%ecx
801012ef:	7e e7                	jle    801012d8 <iget+0x28>
801012f1:	39 3b                	cmp    %edi,(%ebx)
801012f3:	75 e3                	jne    801012d8 <iget+0x28>
801012f5:	39 53 04             	cmp    %edx,0x4(%ebx)
801012f8:	75 de                	jne    801012d8 <iget+0x28>
      ip->ref++;
801012fa:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012fd:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012ff:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
      ip->ref++;
80101306:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101309:	e8 52 34 00 00       	call   80104760 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010130e:	83 c4 1c             	add    $0x1c,%esp
80101311:	89 f0                	mov    %esi,%eax
80101313:	5b                   	pop    %ebx
80101314:	5e                   	pop    %esi
80101315:	5f                   	pop    %edi
80101316:	5d                   	pop    %ebp
80101317:	c3                   	ret    
80101318:	85 c9                	test   %ecx,%ecx
8010131a:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010131d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101323:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101329:	75 bf                	jne    801012ea <iget+0x3a>
8010132b:	90                   	nop
8010132c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(empty == 0)
80101330:	85 f6                	test   %esi,%esi
80101332:	74 29                	je     8010135d <iget+0xad>
  ip->dev = dev;
80101334:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101336:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101339:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101340:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101347:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010134e:	e8 0d 34 00 00       	call   80104760 <release>
}
80101353:	83 c4 1c             	add    $0x1c,%esp
80101356:	89 f0                	mov    %esi,%eax
80101358:	5b                   	pop    %ebx
80101359:	5e                   	pop    %esi
8010135a:	5f                   	pop    %edi
8010135b:	5d                   	pop    %ebp
8010135c:	c3                   	ret    
    panic("iget: no inodes");
8010135d:	c7 04 24 68 73 10 80 	movl   $0x80107368,(%esp)
80101364:	e8 f7 ef ff ff       	call   80100360 <panic>
80101369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101370 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101370:	55                   	push   %ebp
80101371:	89 e5                	mov    %esp,%ebp
80101373:	57                   	push   %edi
80101374:	56                   	push   %esi
80101375:	53                   	push   %ebx
80101376:	89 c3                	mov    %eax,%ebx
80101378:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010137b:	83 fa 0b             	cmp    $0xb,%edx
8010137e:	77 18                	ja     80101398 <bmap+0x28>
80101380:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
80101383:	8b 46 5c             	mov    0x5c(%esi),%eax
80101386:	85 c0                	test   %eax,%eax
80101388:	74 66                	je     801013f0 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010138a:	83 c4 1c             	add    $0x1c,%esp
8010138d:	5b                   	pop    %ebx
8010138e:	5e                   	pop    %esi
8010138f:	5f                   	pop    %edi
80101390:	5d                   	pop    %ebp
80101391:	c3                   	ret    
80101392:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;
80101398:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
8010139b:	83 fe 7f             	cmp    $0x7f,%esi
8010139e:	77 77                	ja     80101417 <bmap+0xa7>
    if((addr = ip->addrs[NDIRECT]) == 0)
801013a0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801013a6:	85 c0                	test   %eax,%eax
801013a8:	74 5e                	je     80101408 <bmap+0x98>
    bp = bread(ip->dev, addr);
801013aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801013ae:	8b 03                	mov    (%ebx),%eax
801013b0:	89 04 24             	mov    %eax,(%esp)
801013b3:	e8 18 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013b8:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
    bp = bread(ip->dev, addr);
801013bc:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013be:	8b 32                	mov    (%edx),%esi
801013c0:	85 f6                	test   %esi,%esi
801013c2:	75 19                	jne    801013dd <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
801013c4:	8b 03                	mov    (%ebx),%eax
801013c6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013c9:	e8 c2 fd ff ff       	call   80101190 <balloc>
801013ce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013d1:	89 02                	mov    %eax,(%edx)
801013d3:	89 c6                	mov    %eax,%esi
      log_write(bp);
801013d5:	89 3c 24             	mov    %edi,(%esp)
801013d8:	e8 e3 18 00 00       	call   80102cc0 <log_write>
    brelse(bp);
801013dd:	89 3c 24             	mov    %edi,(%esp)
801013e0:	e8 fb ed ff ff       	call   801001e0 <brelse>
}
801013e5:	83 c4 1c             	add    $0x1c,%esp
    brelse(bp);
801013e8:	89 f0                	mov    %esi,%eax
}
801013ea:	5b                   	pop    %ebx
801013eb:	5e                   	pop    %esi
801013ec:	5f                   	pop    %edi
801013ed:	5d                   	pop    %ebp
801013ee:	c3                   	ret    
801013ef:	90                   	nop
      ip->addrs[bn] = addr = balloc(ip->dev);
801013f0:	8b 03                	mov    (%ebx),%eax
801013f2:	e8 99 fd ff ff       	call   80101190 <balloc>
801013f7:	89 46 5c             	mov    %eax,0x5c(%esi)
}
801013fa:	83 c4 1c             	add    $0x1c,%esp
801013fd:	5b                   	pop    %ebx
801013fe:	5e                   	pop    %esi
801013ff:	5f                   	pop    %edi
80101400:	5d                   	pop    %ebp
80101401:	c3                   	ret    
80101402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101408:	8b 03                	mov    (%ebx),%eax
8010140a:	e8 81 fd ff ff       	call   80101190 <balloc>
8010140f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101415:	eb 93                	jmp    801013aa <bmap+0x3a>
  panic("bmap: out of range");
80101417:	c7 04 24 78 73 10 80 	movl   $0x80107378,(%esp)
8010141e:	e8 3d ef ff ff       	call   80100360 <panic>
80101423:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101430 <readsb>:
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	56                   	push   %esi
80101434:	53                   	push   %ebx
80101435:	83 ec 10             	sub    $0x10,%esp
  bp = bread(dev, 1);
80101438:	8b 45 08             	mov    0x8(%ebp),%eax
8010143b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101442:	00 
{
80101443:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101446:	89 04 24             	mov    %eax,(%esp)
80101449:	e8 82 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010144e:	89 34 24             	mov    %esi,(%esp)
80101451:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101458:	00 
  bp = bread(dev, 1);
80101459:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010145b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010145e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101462:	e8 e9 33 00 00       	call   80104850 <memmove>
  brelse(bp);
80101467:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010146a:	83 c4 10             	add    $0x10,%esp
8010146d:	5b                   	pop    %ebx
8010146e:	5e                   	pop    %esi
8010146f:	5d                   	pop    %ebp
  brelse(bp);
80101470:	e9 6b ed ff ff       	jmp    801001e0 <brelse>
80101475:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101489:	83 ec 24             	sub    $0x24,%esp
  initlock(&icache.lock, "icache");
8010148c:	c7 44 24 04 8b 73 10 	movl   $0x8010738b,0x4(%esp)
80101493:	80 
80101494:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010149b:	e8 e0 30 00 00       	call   80104580 <initlock>
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	89 1c 24             	mov    %ebx,(%esp)
801014a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014a9:	c7 44 24 04 92 73 10 	movl   $0x80107392,0x4(%esp)
801014b0:	80 
801014b1:	e8 9a 2f 00 00       	call   80104450 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014b6:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014bc:	75 e2                	jne    801014a0 <iinit+0x20>
  readsb(dev, &sb);
801014be:	8b 45 08             	mov    0x8(%ebp),%eax
801014c1:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801014c8:	80 
801014c9:	89 04 24             	mov    %eax,(%esp)
801014cc:	e8 5f ff ff ff       	call   80101430 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014d1:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801014d6:	c7 04 24 f8 73 10 80 	movl   $0x801073f8,(%esp)
801014dd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014e1:	a1 d4 09 11 80       	mov    0x801109d4,%eax
801014e6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014ea:	a1 d0 09 11 80       	mov    0x801109d0,%eax
801014ef:	89 44 24 14          	mov    %eax,0x14(%esp)
801014f3:	a1 cc 09 11 80       	mov    0x801109cc,%eax
801014f8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014fc:	a1 c8 09 11 80       	mov    0x801109c8,%eax
80101501:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101505:	a1 c4 09 11 80       	mov    0x801109c4,%eax
8010150a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010150e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101513:	89 44 24 04          	mov    %eax,0x4(%esp)
80101517:	e8 34 f1 ff ff       	call   80100650 <cprintf>
}
8010151c:	83 c4 24             	add    $0x24,%esp
8010151f:	5b                   	pop    %ebx
80101520:	5d                   	pop    %ebp
80101521:	c3                   	ret    
80101522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101530 <ialloc>:
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	57                   	push   %edi
80101534:	56                   	push   %esi
80101535:	53                   	push   %ebx
80101536:	83 ec 2c             	sub    $0x2c,%esp
80101539:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010153c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101543:	8b 7d 08             	mov    0x8(%ebp),%edi
80101546:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101549:	0f 86 a2 00 00 00    	jbe    801015f1 <ialloc+0xc1>
8010154f:	be 01 00 00 00       	mov    $0x1,%esi
80101554:	bb 01 00 00 00       	mov    $0x1,%ebx
80101559:	eb 1a                	jmp    80101575 <ialloc+0x45>
8010155b:	90                   	nop
8010155c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    brelse(bp);
80101560:	89 14 24             	mov    %edx,(%esp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101563:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101566:	e8 75 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010156b:	89 de                	mov    %ebx,%esi
8010156d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101573:	73 7c                	jae    801015f1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101575:	89 f0                	mov    %esi,%eax
80101577:	c1 e8 03             	shr    $0x3,%eax
8010157a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101580:	89 3c 24             	mov    %edi,(%esp)
80101583:	89 44 24 04          	mov    %eax,0x4(%esp)
80101587:	e8 44 eb ff ff       	call   801000d0 <bread>
8010158c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010158e:	89 f0                	mov    %esi,%eax
80101590:	83 e0 07             	and    $0x7,%eax
80101593:	c1 e0 06             	shl    $0x6,%eax
80101596:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010159a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010159e:	75 c0                	jne    80101560 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015a0:	89 0c 24             	mov    %ecx,(%esp)
801015a3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801015aa:	00 
801015ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015b2:	00 
801015b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015b9:	e8 f2 31 00 00       	call   801047b0 <memset>
      dip->type = type;
801015be:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
      dip->type = type;
801015c5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015c8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      dip->type = type;
801015cb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ce:	89 14 24             	mov    %edx,(%esp)
801015d1:	e8 ea 16 00 00       	call   80102cc0 <log_write>
      brelse(bp);
801015d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015d9:	89 14 24             	mov    %edx,(%esp)
801015dc:	e8 ff eb ff ff       	call   801001e0 <brelse>
}
801015e1:	83 c4 2c             	add    $0x2c,%esp
      return iget(dev, inum);
801015e4:	89 f2                	mov    %esi,%edx
}
801015e6:	5b                   	pop    %ebx
      return iget(dev, inum);
801015e7:	89 f8                	mov    %edi,%eax
}
801015e9:	5e                   	pop    %esi
801015ea:	5f                   	pop    %edi
801015eb:	5d                   	pop    %ebp
      return iget(dev, inum);
801015ec:	e9 bf fc ff ff       	jmp    801012b0 <iget>
  panic("ialloc: no inodes");
801015f1:	c7 04 24 98 73 10 80 	movl   $0x80107398,(%esp)
801015f8:	e8 63 ed ff ff       	call   80100360 <panic>
801015fd:	8d 76 00             	lea    0x0(%esi),%esi

80101600 <iupdate>:
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	56                   	push   %esi
80101604:	53                   	push   %ebx
80101605:	83 ec 10             	sub    $0x10,%esp
80101608:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010160b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101611:	c1 e8 03             	shr    $0x3,%eax
80101614:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010161a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010161e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101621:	89 04 24             	mov    %eax,(%esp)
80101624:	e8 a7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101629:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010162c:	83 e2 07             	and    $0x7,%edx
8010162f:	c1 e2 06             	shl    $0x6,%edx
80101632:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101636:	89 c6                	mov    %eax,%esi
  dip->type = ip->type;
80101638:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163c:	83 c2 0c             	add    $0xc,%edx
  dip->type = ip->type;
8010163f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101643:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101647:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010164b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010164f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101653:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101657:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010165b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010165e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101661:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101665:	89 14 24             	mov    %edx,(%esp)
80101668:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010166f:	00 
80101670:	e8 db 31 00 00       	call   80104850 <memmove>
  log_write(bp);
80101675:	89 34 24             	mov    %esi,(%esp)
80101678:	e8 43 16 00 00       	call   80102cc0 <log_write>
  brelse(bp);
8010167d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101680:	83 c4 10             	add    $0x10,%esp
80101683:	5b                   	pop    %ebx
80101684:	5e                   	pop    %esi
80101685:	5d                   	pop    %ebp
  brelse(bp);
80101686:	e9 55 eb ff ff       	jmp    801001e0 <brelse>
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <idup>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	53                   	push   %ebx
80101694:	83 ec 14             	sub    $0x14,%esp
80101697:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010169a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016a1:	e8 4a 30 00 00       	call   801046f0 <acquire>
  ip->ref++;
801016a6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016aa:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016b1:	e8 aa 30 00 00       	call   80104760 <release>
}
801016b6:	83 c4 14             	add    $0x14,%esp
801016b9:	89 d8                	mov    %ebx,%eax
801016bb:	5b                   	pop    %ebx
801016bc:	5d                   	pop    %ebp
801016bd:	c3                   	ret    
801016be:	66 90                	xchg   %ax,%ax

801016c0 <ilock>:
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	56                   	push   %esi
801016c4:	53                   	push   %ebx
801016c5:	83 ec 10             	sub    $0x10,%esp
801016c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016cb:	85 db                	test   %ebx,%ebx
801016cd:	0f 84 b3 00 00 00    	je     80101786 <ilock+0xc6>
801016d3:	8b 53 08             	mov    0x8(%ebx),%edx
801016d6:	85 d2                	test   %edx,%edx
801016d8:	0f 8e a8 00 00 00    	jle    80101786 <ilock+0xc6>
  acquiresleep(&ip->lock);
801016de:	8d 43 0c             	lea    0xc(%ebx),%eax
801016e1:	89 04 24             	mov    %eax,(%esp)
801016e4:	e8 a7 2d 00 00       	call   80104490 <acquiresleep>
  if(ip->valid == 0){
801016e9:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ec:	85 c0                	test   %eax,%eax
801016ee:	74 08                	je     801016f8 <ilock+0x38>
}
801016f0:	83 c4 10             	add    $0x10,%esp
801016f3:	5b                   	pop    %ebx
801016f4:	5e                   	pop    %esi
801016f5:	5d                   	pop    %ebp
801016f6:	c3                   	ret    
801016f7:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
801016fb:	c1 e8 03             	shr    $0x3,%eax
801016fe:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101704:	89 44 24 04          	mov    %eax,0x4(%esp)
80101708:	8b 03                	mov    (%ebx),%eax
8010170a:	89 04 24             	mov    %eax,(%esp)
8010170d:	e8 be e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101712:	8b 53 04             	mov    0x4(%ebx),%edx
80101715:	83 e2 07             	and    $0x7,%edx
80101718:	c1 e2 06             	shl    $0x6,%edx
8010171b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171f:	89 c6                	mov    %eax,%esi
    ip->type = dip->type;
80101721:	0f b7 02             	movzwl (%edx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101724:	83 c2 0c             	add    $0xc,%edx
    ip->type = dip->type;
80101727:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010172b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010172f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101733:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101737:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010173b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010173f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101743:	8b 42 fc             	mov    -0x4(%edx),%eax
80101746:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101749:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010174c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101750:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101757:	00 
80101758:	89 04 24             	mov    %eax,(%esp)
8010175b:	e8 f0 30 00 00       	call   80104850 <memmove>
    brelse(bp);
80101760:	89 34 24             	mov    %esi,(%esp)
80101763:	e8 78 ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101768:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010176d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101774:	0f 85 76 ff ff ff    	jne    801016f0 <ilock+0x30>
      panic("ilock: no type");
8010177a:	c7 04 24 b0 73 10 80 	movl   $0x801073b0,(%esp)
80101781:	e8 da eb ff ff       	call   80100360 <panic>
    panic("ilock");
80101786:	c7 04 24 aa 73 10 80 	movl   $0x801073aa,(%esp)
8010178d:	e8 ce eb ff ff       	call   80100360 <panic>
80101792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801017a0 <iunlock>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	83 ec 10             	sub    $0x10,%esp
801017a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017ab:	85 db                	test   %ebx,%ebx
801017ad:	74 24                	je     801017d3 <iunlock+0x33>
801017af:	8d 73 0c             	lea    0xc(%ebx),%esi
801017b2:	89 34 24             	mov    %esi,(%esp)
801017b5:	e8 76 2d 00 00       	call   80104530 <holdingsleep>
801017ba:	85 c0                	test   %eax,%eax
801017bc:	74 15                	je     801017d3 <iunlock+0x33>
801017be:	8b 43 08             	mov    0x8(%ebx),%eax
801017c1:	85 c0                	test   %eax,%eax
801017c3:	7e 0e                	jle    801017d3 <iunlock+0x33>
  releasesleep(&ip->lock);
801017c5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	5b                   	pop    %ebx
801017cc:	5e                   	pop    %esi
801017cd:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017ce:	e9 1d 2d 00 00       	jmp    801044f0 <releasesleep>
    panic("iunlock");
801017d3:	c7 04 24 bf 73 10 80 	movl   $0x801073bf,(%esp)
801017da:	e8 81 eb ff ff       	call   80100360 <panic>
801017df:	90                   	nop

801017e0 <iput>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	57                   	push   %edi
801017e4:	56                   	push   %esi
801017e5:	53                   	push   %ebx
801017e6:	83 ec 1c             	sub    $0x1c,%esp
801017e9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017ec:	8d 7e 0c             	lea    0xc(%esi),%edi
801017ef:	89 3c 24             	mov    %edi,(%esp)
801017f2:	e8 99 2c 00 00       	call   80104490 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017f7:	8b 56 4c             	mov    0x4c(%esi),%edx
801017fa:	85 d2                	test   %edx,%edx
801017fc:	74 07                	je     80101805 <iput+0x25>
801017fe:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101803:	74 2b                	je     80101830 <iput+0x50>
  releasesleep(&ip->lock);
80101805:	89 3c 24             	mov    %edi,(%esp)
80101808:	e8 e3 2c 00 00       	call   801044f0 <releasesleep>
  acquire(&icache.lock);
8010180d:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101814:	e8 d7 2e 00 00       	call   801046f0 <acquire>
  ip->ref--;
80101819:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010181d:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101824:	83 c4 1c             	add    $0x1c,%esp
80101827:	5b                   	pop    %ebx
80101828:	5e                   	pop    %esi
80101829:	5f                   	pop    %edi
8010182a:	5d                   	pop    %ebp
  release(&icache.lock);
8010182b:	e9 30 2f 00 00       	jmp    80104760 <release>
    acquire(&icache.lock);
80101830:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101837:	e8 b4 2e 00 00       	call   801046f0 <acquire>
    int r = ip->ref;
8010183c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010183f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101846:	e8 15 2f 00 00       	call   80104760 <release>
    if(r == 1){
8010184b:	83 fb 01             	cmp    $0x1,%ebx
8010184e:	75 b5                	jne    80101805 <iput+0x25>
80101850:	8d 4e 30             	lea    0x30(%esi),%ecx
80101853:	89 f3                	mov    %esi,%ebx
80101855:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101858:	89 cf                	mov    %ecx,%edi
8010185a:	eb 0b                	jmp    80101867 <iput+0x87>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101860:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101863:	39 fb                	cmp    %edi,%ebx
80101865:	74 19                	je     80101880 <iput+0xa0>
    if(ip->addrs[i]){
80101867:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010186a:	85 d2                	test   %edx,%edx
8010186c:	74 f2                	je     80101860 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010186e:	8b 06                	mov    (%esi),%eax
80101870:	e8 9b f8 ff ff       	call   80101110 <bfree>
      ip->addrs[i] = 0;
80101875:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010187c:	eb e2                	jmp    80101860 <iput+0x80>
8010187e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101880:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101886:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101889:	85 c0                	test   %eax,%eax
8010188b:	75 2b                	jne    801018b8 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010188d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101894:	89 34 24             	mov    %esi,(%esp)
80101897:	e8 64 fd ff ff       	call   80101600 <iupdate>
      ip->type = 0;
8010189c:	31 c0                	xor    %eax,%eax
8010189e:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
801018a2:	89 34 24             	mov    %esi,(%esp)
801018a5:	e8 56 fd ff ff       	call   80101600 <iupdate>
      ip->valid = 0;
801018aa:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018b1:	e9 4f ff ff ff       	jmp    80101805 <iput+0x25>
801018b6:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018bc:	8b 06                	mov    (%esi),%eax
    for(j = 0; j < NINDIRECT; j++){
801018be:	31 db                	xor    %ebx,%ebx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018c0:	89 04 24             	mov    %eax,(%esp)
801018c3:	e8 08 e8 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801018c8:	89 7d e0             	mov    %edi,-0x20(%ebp)
    a = (uint*)bp->data;
801018cb:	8d 48 5c             	lea    0x5c(%eax),%ecx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801018d1:	89 cf                	mov    %ecx,%edi
801018d3:	31 c0                	xor    %eax,%eax
801018d5:	eb 0e                	jmp    801018e5 <iput+0x105>
801018d7:	90                   	nop
801018d8:	83 c3 01             	add    $0x1,%ebx
801018db:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018e1:	89 d8                	mov    %ebx,%eax
801018e3:	74 10                	je     801018f5 <iput+0x115>
      if(a[j])
801018e5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018e8:	85 d2                	test   %edx,%edx
801018ea:	74 ec                	je     801018d8 <iput+0xf8>
        bfree(ip->dev, a[j]);
801018ec:	8b 06                	mov    (%esi),%eax
801018ee:	e8 1d f8 ff ff       	call   80101110 <bfree>
801018f3:	eb e3                	jmp    801018d8 <iput+0xf8>
    brelse(bp);
801018f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018f8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018fb:	89 04 24             	mov    %eax,(%esp)
801018fe:	e8 dd e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101903:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101909:	8b 06                	mov    (%esi),%eax
8010190b:	e8 00 f8 ff ff       	call   80101110 <bfree>
    ip->addrs[NDIRECT] = 0;
80101910:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101917:	00 00 00 
8010191a:	e9 6e ff ff ff       	jmp    8010188d <iput+0xad>
8010191f:	90                   	nop

80101920 <iunlockput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 14             	sub    $0x14,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010192a:	89 1c 24             	mov    %ebx,(%esp)
8010192d:	e8 6e fe ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101932:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101935:	83 c4 14             	add    $0x14,%esp
80101938:	5b                   	pop    %ebx
80101939:	5d                   	pop    %ebp
  iput(ip);
8010193a:	e9 a1 fe ff ff       	jmp    801017e0 <iput>
8010193f:	90                   	nop

80101940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
}
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 2c             	sub    $0x2c,%esp
80101979:	8b 45 0c             	mov    0xc(%ebp),%eax
8010197c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010197f:	8b 75 10             	mov    0x10(%ebp),%esi
80101982:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101985:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101988:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
8010198d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101990:	0f 84 aa 00 00 00    	je     80101a40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101996:	8b 47 58             	mov    0x58(%edi),%eax
80101999:	39 f0                	cmp    %esi,%eax
8010199b:	0f 82 c7 00 00 00    	jb     80101a68 <readi+0xf8>
801019a1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801019a4:	89 da                	mov    %ebx,%edx
801019a6:	01 f2                	add    %esi,%edx
801019a8:	0f 82 ba 00 00 00    	jb     80101a68 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019ae:	89 c1                	mov    %eax,%ecx
801019b0:	29 f1                	sub    %esi,%ecx
801019b2:	39 d0                	cmp    %edx,%eax
801019b4:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b7:	31 c0                	xor    %eax,%eax
801019b9:	85 c9                	test   %ecx,%ecx
    n = ip->size - off;
801019bb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019be:	74 70                	je     80101a30 <readi+0xc0>
801019c0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019c3:	89 c7                	mov    %eax,%edi
801019c5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019cb:	89 f2                	mov    %esi,%edx
801019cd:	c1 ea 09             	shr    $0x9,%edx
801019d0:	89 d8                	mov    %ebx,%eax
801019d2:	e8 99 f9 ff ff       	call   80101370 <bmap>
801019d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019db:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019dd:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019e2:	89 04 24             	mov    %eax,(%esp)
801019e5:	e8 e6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ea:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019ed:	29 f9                	sub    %edi,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ef:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019f1:	89 f0                	mov    %esi,%eax
801019f3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019f8:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fa:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019fe:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a00:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a04:	8b 45 e0             	mov    -0x20(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a07:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a0e:	01 df                	add    %ebx,%edi
80101a10:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a12:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a15:	89 04 24             	mov    %eax,(%esp)
80101a18:	e8 33 2e 00 00       	call   80104850 <memmove>
    brelse(bp);
80101a1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a20:	89 14 24             	mov    %edx,(%esp)
80101a23:	e8 b8 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a28:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a2b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a2e:	77 98                	ja     801019c8 <readi+0x58>
  }
  return n;
80101a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a33:	83 c4 2c             	add    $0x2c,%esp
80101a36:	5b                   	pop    %ebx
80101a37:	5e                   	pop    %esi
80101a38:	5f                   	pop    %edi
80101a39:	5d                   	pop    %ebp
80101a3a:	c3                   	ret    
80101a3b:	90                   	nop
80101a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a40:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a44:	66 83 f8 09          	cmp    $0x9,%ax
80101a48:	77 1e                	ja     80101a68 <readi+0xf8>
80101a4a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a51:	85 c0                	test   %eax,%eax
80101a53:	74 13                	je     80101a68 <readi+0xf8>
    return devsw[ip->major].read(ip, dst, n);
80101a55:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a58:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101a5b:	83 c4 2c             	add    $0x2c,%esp
80101a5e:	5b                   	pop    %ebx
80101a5f:	5e                   	pop    %esi
80101a60:	5f                   	pop    %edi
80101a61:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a62:	ff e0                	jmp    *%eax
80101a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a6d:	eb c4                	jmp    80101a33 <readi+0xc3>
80101a6f:	90                   	nop

80101a70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 2c             	sub    $0x2c,%esp
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a7f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a8a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a90:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a93:	0f 84 b7 00 00 00    	je     80101b50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a9f:	0f 82 e3 00 00 00    	jb     80101b88 <writei+0x118>
80101aa5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101aa8:	89 c8                	mov    %ecx,%eax
80101aaa:	01 f0                	add    %esi,%eax
80101aac:	0f 82 d6 00 00 00    	jb     80101b88 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ab2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ab7:	0f 87 cb 00 00 00    	ja     80101b88 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101abd:	85 c9                	test   %ecx,%ecx
80101abf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ac6:	74 77                	je     80101b3f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101acb:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101acd:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad2:	c1 ea 09             	shr    $0x9,%edx
80101ad5:	89 f8                	mov    %edi,%eax
80101ad7:	e8 94 f8 ff ff       	call   80101370 <bmap>
80101adc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ae0:	8b 07                	mov    (%edi),%eax
80101ae2:	89 04 24             	mov    %eax,(%esp)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101aed:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101af0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101af5:	89 f0                	mov    %esi,%eax
80101af7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101afc:	29 c3                	sub    %eax,%ebx
80101afe:	39 cb                	cmp    %ecx,%ebx
80101b00:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b07:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b09:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b0d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b11:	89 04 24             	mov    %eax,(%esp)
80101b14:	e8 37 2d 00 00       	call   80104850 <memmove>
    log_write(bp);
80101b19:	89 3c 24             	mov    %edi,(%esp)
80101b1c:	e8 9f 11 00 00       	call   80102cc0 <log_write>
    brelse(bp);
80101b21:	89 3c 24             	mov    %edi,(%esp)
80101b24:	e8 b7 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b29:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b2f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b32:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b35:	77 91                	ja     80101ac8 <writei+0x58>
  }

  if(n > 0 && off > ip->size){
80101b37:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b3d:	72 39                	jb     80101b78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b42:	83 c4 2c             	add    $0x2c,%esp
80101b45:	5b                   	pop    %ebx
80101b46:	5e                   	pop    %esi
80101b47:	5f                   	pop    %edi
80101b48:	5d                   	pop    %ebp
80101b49:	c3                   	ret    
80101b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 2e                	ja     80101b88 <writei+0x118>
80101b5a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 23                	je     80101b88 <writei+0x118>
    return devsw[ip->major].write(ip, src, n);
80101b65:	89 4d 10             	mov    %ecx,0x10(%ebp)
}
80101b68:	83 c4 2c             	add    $0x2c,%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b6f:	ff e0                	jmp    *%eax
80101b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b7b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b7e:	89 04 24             	mov    %eax,(%esp)
80101b81:	e8 7a fa ff ff       	call   80101600 <iupdate>
80101b86:	eb b7                	jmp    80101b3f <writei+0xcf>
}
80101b88:	83 c4 2c             	add    $0x2c,%esp
      return -1;
80101b8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101b90:	5b                   	pop    %ebx
80101b91:	5e                   	pop    %esi
80101b92:	5f                   	pop    %edi
80101b93:	5d                   	pop    %ebp
80101b94:	c3                   	ret    
80101b95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ba9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101bb0:	00 
80101bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bb5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb8:	89 04 24             	mov    %eax,(%esp)
80101bbb:	e8 10 2d 00 00       	call   801048d0 <strncmp>
}
80101bc0:	c9                   	leave  
80101bc1:	c3                   	ret    
80101bc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bd0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	57                   	push   %edi
80101bd4:	56                   	push   %esi
80101bd5:	53                   	push   %ebx
80101bd6:	83 ec 2c             	sub    $0x2c,%esp
80101bd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bdc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101be1:	0f 85 97 00 00 00    	jne    80101c7e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101be7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bea:	31 ff                	xor    %edi,%edi
80101bec:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bef:	85 d2                	test   %edx,%edx
80101bf1:	75 0d                	jne    80101c00 <dirlookup+0x30>
80101bf3:	eb 73                	jmp    80101c68 <dirlookup+0x98>
80101bf5:	8d 76 00             	lea    0x0(%esi),%esi
80101bf8:	83 c7 10             	add    $0x10,%edi
80101bfb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bfe:	76 68                	jbe    80101c68 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c00:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c07:	00 
80101c08:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101c0c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c10:	89 1c 24             	mov    %ebx,(%esp)
80101c13:	e8 58 fd ff ff       	call   80101970 <readi>
80101c18:	83 f8 10             	cmp    $0x10,%eax
80101c1b:	75 55                	jne    80101c72 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101c1d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c22:	74 d4                	je     80101bf8 <dirlookup+0x28>
  return strncmp(s, t, DIRSIZ);
80101c24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c27:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c2e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c35:	00 
80101c36:	89 04 24             	mov    %eax,(%esp)
80101c39:	e8 92 2c 00 00       	call   801048d0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c3e:	85 c0                	test   %eax,%eax
80101c40:	75 b6                	jne    80101bf8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c42:	8b 45 10             	mov    0x10(%ebp),%eax
80101c45:	85 c0                	test   %eax,%eax
80101c47:	74 05                	je     80101c4e <dirlookup+0x7e>
        *poff = off;
80101c49:	8b 45 10             	mov    0x10(%ebp),%eax
80101c4c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c4e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c52:	8b 03                	mov    (%ebx),%eax
80101c54:	e8 57 f6 ff ff       	call   801012b0 <iget>
    }
  }

  return 0;
}
80101c59:	83 c4 2c             	add    $0x2c,%esp
80101c5c:	5b                   	pop    %ebx
80101c5d:	5e                   	pop    %esi
80101c5e:	5f                   	pop    %edi
80101c5f:	5d                   	pop    %ebp
80101c60:	c3                   	ret    
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c68:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80101c6b:	31 c0                	xor    %eax,%eax
}
80101c6d:	5b                   	pop    %ebx
80101c6e:	5e                   	pop    %esi
80101c6f:	5f                   	pop    %edi
80101c70:	5d                   	pop    %ebp
80101c71:	c3                   	ret    
      panic("dirlookup read");
80101c72:	c7 04 24 d9 73 10 80 	movl   $0x801073d9,(%esp)
80101c79:	e8 e2 e6 ff ff       	call   80100360 <panic>
    panic("dirlookup not DIR");
80101c7e:	c7 04 24 c7 73 10 80 	movl   $0x801073c7,(%esp)
80101c85:	e8 d6 e6 ff ff       	call   80100360 <panic>
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	57                   	push   %edi
80101c94:	89 cf                	mov    %ecx,%edi
80101c96:	56                   	push   %esi
80101c97:	53                   	push   %ebx
80101c98:	89 c3                	mov    %eax,%ebx
80101c9a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c9d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101ca0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101ca3:	0f 84 51 01 00 00    	je     80101dfa <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ca9:	e8 32 1a 00 00       	call   801036e0 <myproc>
80101cae:	8b 70 6c             	mov    0x6c(%eax),%esi
  acquire(&icache.lock);
80101cb1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cb8:	e8 33 2a 00 00       	call   801046f0 <acquire>
  ip->ref++;
80101cbd:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cc1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cc8:	e8 93 2a 00 00       	call   80104760 <release>
80101ccd:	eb 04                	jmp    80101cd3 <namex+0x43>
80101ccf:	90                   	nop
    path++;
80101cd0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cd3:	0f b6 03             	movzbl (%ebx),%eax
80101cd6:	3c 2f                	cmp    $0x2f,%al
80101cd8:	74 f6                	je     80101cd0 <namex+0x40>
  if(*path == 0)
80101cda:	84 c0                	test   %al,%al
80101cdc:	0f 84 ed 00 00 00    	je     80101dcf <namex+0x13f>
  while(*path != '/' && *path != 0)
80101ce2:	0f b6 03             	movzbl (%ebx),%eax
80101ce5:	89 da                	mov    %ebx,%edx
80101ce7:	84 c0                	test   %al,%al
80101ce9:	0f 84 b1 00 00 00    	je     80101da0 <namex+0x110>
80101cef:	3c 2f                	cmp    $0x2f,%al
80101cf1:	75 0f                	jne    80101d02 <namex+0x72>
80101cf3:	e9 a8 00 00 00       	jmp    80101da0 <namex+0x110>
80101cf8:	3c 2f                	cmp    $0x2f,%al
80101cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d00:	74 0a                	je     80101d0c <namex+0x7c>
    path++;
80101d02:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d05:	0f b6 02             	movzbl (%edx),%eax
80101d08:	84 c0                	test   %al,%al
80101d0a:	75 ec                	jne    80101cf8 <namex+0x68>
80101d0c:	89 d1                	mov    %edx,%ecx
80101d0e:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d10:	83 f9 0d             	cmp    $0xd,%ecx
80101d13:	0f 8e 8f 00 00 00    	jle    80101da8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d19:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d1d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d24:	00 
80101d25:	89 3c 24             	mov    %edi,(%esp)
80101d28:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d2b:	e8 20 2b 00 00       	call   80104850 <memmove>
    path++;
80101d30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d33:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d35:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d38:	75 0e                	jne    80101d48 <namex+0xb8>
80101d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d40:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d43:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d46:	74 f8                	je     80101d40 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d48:	89 34 24             	mov    %esi,(%esp)
80101d4b:	e8 70 f9 ff ff       	call   801016c0 <ilock>
    if(ip->type != T_DIR){
80101d50:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d55:	0f 85 85 00 00 00    	jne    80101de0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d5e:	85 d2                	test   %edx,%edx
80101d60:	74 09                	je     80101d6b <namex+0xdb>
80101d62:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d65:	0f 84 a5 00 00 00    	je     80101e10 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d6b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d72:	00 
80101d73:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d77:	89 34 24             	mov    %esi,(%esp)
80101d7a:	e8 51 fe ff ff       	call   80101bd0 <dirlookup>
80101d7f:	85 c0                	test   %eax,%eax
80101d81:	74 5d                	je     80101de0 <namex+0x150>
  iunlock(ip);
80101d83:	89 34 24             	mov    %esi,(%esp)
80101d86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d89:	e8 12 fa ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101d8e:	89 34 24             	mov    %esi,(%esp)
80101d91:	e8 4a fa ff ff       	call   801017e0 <iput>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d99:	89 c6                	mov    %eax,%esi
80101d9b:	e9 33 ff ff ff       	jmp    80101cd3 <namex+0x43>
  while(*path != '/' && *path != 0)
80101da0:	31 c9                	xor    %ecx,%ecx
80101da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(name, s, len);
80101da8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101dac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101db0:	89 3c 24             	mov    %edi,(%esp)
80101db3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101db9:	e8 92 2a 00 00       	call   80104850 <memmove>
    name[len] = 0;
80101dbe:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dc1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dc4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dc8:	89 d3                	mov    %edx,%ebx
80101dca:	e9 66 ff ff ff       	jmp    80101d35 <namex+0xa5>
  }
  if(nameiparent){
80101dcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dd2:	85 c0                	test   %eax,%eax
80101dd4:	75 4c                	jne    80101e22 <namex+0x192>
80101dd6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101dd8:	83 c4 2c             	add    $0x2c,%esp
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    
  iunlock(ip);
80101de0:	89 34 24             	mov    %esi,(%esp)
80101de3:	e8 b8 f9 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101de8:	89 34 24             	mov    %esi,(%esp)
80101deb:	e8 f0 f9 ff ff       	call   801017e0 <iput>
}
80101df0:	83 c4 2c             	add    $0x2c,%esp
      return 0;
80101df3:	31 c0                	xor    %eax,%eax
}
80101df5:	5b                   	pop    %ebx
80101df6:	5e                   	pop    %esi
80101df7:	5f                   	pop    %edi
80101df8:	5d                   	pop    %ebp
80101df9:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101dfa:	ba 01 00 00 00       	mov    $0x1,%edx
80101dff:	b8 01 00 00 00       	mov    $0x1,%eax
80101e04:	e8 a7 f4 ff ff       	call   801012b0 <iget>
80101e09:	89 c6                	mov    %eax,%esi
80101e0b:	e9 c3 fe ff ff       	jmp    80101cd3 <namex+0x43>
      iunlock(ip);
80101e10:	89 34 24             	mov    %esi,(%esp)
80101e13:	e8 88 f9 ff ff       	call   801017a0 <iunlock>
}
80101e18:	83 c4 2c             	add    $0x2c,%esp
      return ip;
80101e1b:	89 f0                	mov    %esi,%eax
}
80101e1d:	5b                   	pop    %ebx
80101e1e:	5e                   	pop    %esi
80101e1f:	5f                   	pop    %edi
80101e20:	5d                   	pop    %ebp
80101e21:	c3                   	ret    
    iput(ip);
80101e22:	89 34 24             	mov    %esi,(%esp)
80101e25:	e8 b6 f9 ff ff       	call   801017e0 <iput>
    return 0;
80101e2a:	31 c0                	xor    %eax,%eax
80101e2c:	eb aa                	jmp    80101dd8 <namex+0x148>
80101e2e:	66 90                	xchg   %ax,%ax

80101e30 <dirlink>:
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 2c             	sub    $0x2c,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e3f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e46:	00 
80101e47:	89 1c 24             	mov    %ebx,(%esp)
80101e4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e4e:	e8 7d fd ff ff       	call   80101bd0 <dirlookup>
80101e53:	85 c0                	test   %eax,%eax
80101e55:	0f 85 8b 00 00 00    	jne    80101ee6 <dirlink+0xb6>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e5b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e5e:	31 ff                	xor    %edi,%edi
80101e60:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e63:	85 c0                	test   %eax,%eax
80101e65:	75 13                	jne    80101e7a <dirlink+0x4a>
80101e67:	eb 35                	jmp    80101e9e <dirlink+0x6e>
80101e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e70:	8d 57 10             	lea    0x10(%edi),%edx
80101e73:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e76:	89 d7                	mov    %edx,%edi
80101e78:	76 24                	jbe    80101e9e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e7a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e81:	00 
80101e82:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e86:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e8a:	89 1c 24             	mov    %ebx,(%esp)
80101e8d:	e8 de fa ff ff       	call   80101970 <readi>
80101e92:	83 f8 10             	cmp    $0x10,%eax
80101e95:	75 5e                	jne    80101ef5 <dirlink+0xc5>
    if(de.inum == 0)
80101e97:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e9c:	75 d2                	jne    80101e70 <dirlink+0x40>
  strncpy(de.name, name, DIRSIZ);
80101e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ea1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ea8:	00 
80101ea9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ead:	8d 45 da             	lea    -0x26(%ebp),%eax
80101eb0:	89 04 24             	mov    %eax,(%esp)
80101eb3:	e8 88 2a 00 00       	call   80104940 <strncpy>
  de.inum = inum;
80101eb8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ebb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ec2:	00 
80101ec3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ec7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101ecb:	89 1c 24             	mov    %ebx,(%esp)
  de.inum = inum;
80101ece:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ed2:	e8 99 fb ff ff       	call   80101a70 <writei>
80101ed7:	83 f8 10             	cmp    $0x10,%eax
80101eda:	75 25                	jne    80101f01 <dirlink+0xd1>
  return 0;
80101edc:	31 c0                	xor    %eax,%eax
}
80101ede:	83 c4 2c             	add    $0x2c,%esp
80101ee1:	5b                   	pop    %ebx
80101ee2:	5e                   	pop    %esi
80101ee3:	5f                   	pop    %edi
80101ee4:	5d                   	pop    %ebp
80101ee5:	c3                   	ret    
    iput(ip);
80101ee6:	89 04 24             	mov    %eax,(%esp)
80101ee9:	e8 f2 f8 ff ff       	call   801017e0 <iput>
    return -1;
80101eee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ef3:	eb e9                	jmp    80101ede <dirlink+0xae>
      panic("dirlink read");
80101ef5:	c7 04 24 e8 73 10 80 	movl   $0x801073e8,(%esp)
80101efc:	e8 5f e4 ff ff       	call   80100360 <panic>
    panic("dirlink");
80101f01:	c7 04 24 5e 7a 10 80 	movl   $0x80107a5e,(%esp)
80101f08:	e8 53 e4 ff ff       	call   80100360 <panic>
80101f0d:	8d 76 00             	lea    0x0(%esi),%esi

80101f10 <namei>:

struct inode*
namei(char *path)
{
80101f10:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f11:	31 d2                	xor    %edx,%edx
{
80101f13:	89 e5                	mov    %esp,%ebp
80101f15:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f18:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f1e:	e8 6d fd ff ff       	call   80101c90 <namex>
}
80101f23:	c9                   	leave  
80101f24:	c3                   	ret    
80101f25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f30 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f30:	55                   	push   %ebp
  return namex(path, 1, name);
80101f31:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f36:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f3e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f3f:	e9 4c fd ff ff       	jmp    80101c90 <namex>
80101f44:	66 90                	xchg   %ax,%ax
80101f46:	66 90                	xchg   %ax,%ax
80101f48:	66 90                	xchg   %ax,%ax
80101f4a:	66 90                	xchg   %ax,%ax
80101f4c:	66 90                	xchg   %ax,%ax
80101f4e:	66 90                	xchg   %ax,%ax

80101f50 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
80101f53:	56                   	push   %esi
80101f54:	89 c6                	mov    %eax,%esi
80101f56:	53                   	push   %ebx
80101f57:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f5a:	85 c0                	test   %eax,%eax
80101f5c:	0f 84 99 00 00 00    	je     80101ffb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f62:	8b 48 08             	mov    0x8(%eax),%ecx
80101f65:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f6b:	0f 87 7e 00 00 00    	ja     80101fef <idestart+0x9f>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f71:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f76:	66 90                	xchg   %ax,%ax
80101f78:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f79:	83 e0 c0             	and    $0xffffffc0,%eax
80101f7c:	3c 40                	cmp    $0x40,%al
80101f7e:	75 f8                	jne    80101f78 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f80:	31 db                	xor    %ebx,%ebx
80101f82:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f87:	89 d8                	mov    %ebx,%eax
80101f89:	ee                   	out    %al,(%dx)
80101f8a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f8f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f94:	ee                   	out    %al,(%dx)
80101f95:	0f b6 c1             	movzbl %cl,%eax
80101f98:	b2 f3                	mov    $0xf3,%dl
80101f9a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f9b:	89 c8                	mov    %ecx,%eax
80101f9d:	b2 f4                	mov    $0xf4,%dl
80101f9f:	c1 f8 08             	sar    $0x8,%eax
80101fa2:	ee                   	out    %al,(%dx)
80101fa3:	b2 f5                	mov    $0xf5,%dl
80101fa5:	89 d8                	mov    %ebx,%eax
80101fa7:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fa8:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fac:	b2 f6                	mov    $0xf6,%dl
80101fae:	83 e0 01             	and    $0x1,%eax
80101fb1:	c1 e0 04             	shl    $0x4,%eax
80101fb4:	83 c8 e0             	or     $0xffffffe0,%eax
80101fb7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fb8:	f6 06 04             	testb  $0x4,(%esi)
80101fbb:	75 13                	jne    80101fd0 <idestart+0x80>
80101fbd:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fc2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fc7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fc8:	83 c4 10             	add    $0x10,%esp
80101fcb:	5b                   	pop    %ebx
80101fcc:	5e                   	pop    %esi
80101fcd:	5d                   	pop    %ebp
80101fce:	c3                   	ret    
80101fcf:	90                   	nop
80101fd0:	b2 f7                	mov    $0xf7,%dl
80101fd2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fd7:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101fd8:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101fdd:	83 c6 5c             	add    $0x5c,%esi
80101fe0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fe5:	fc                   	cld    
80101fe6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101fe8:	83 c4 10             	add    $0x10,%esp
80101feb:	5b                   	pop    %ebx
80101fec:	5e                   	pop    %esi
80101fed:	5d                   	pop    %ebp
80101fee:	c3                   	ret    
    panic("incorrect blockno");
80101fef:	c7 04 24 54 74 10 80 	movl   $0x80107454,(%esp)
80101ff6:	e8 65 e3 ff ff       	call   80100360 <panic>
    panic("idestart");
80101ffb:	c7 04 24 4b 74 10 80 	movl   $0x8010744b,(%esp)
80102002:	e8 59 e3 ff ff       	call   80100360 <panic>
80102007:	89 f6                	mov    %esi,%esi
80102009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102010 <ideinit>:
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	83 ec 18             	sub    $0x18,%esp
  initlock(&idelock, "ide");
80102016:	c7 44 24 04 66 74 10 	movl   $0x80107466,0x4(%esp)
8010201d:	80 
8010201e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102025:	e8 56 25 00 00       	call   80104580 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010202a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010202f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102036:	83 e8 01             	sub    $0x1,%eax
80102039:	89 44 24 04          	mov    %eax,0x4(%esp)
8010203d:	e8 7e 02 00 00       	call   801022c0 <ioapicenable>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102042:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102047:	90                   	nop
80102048:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102049:	83 e0 c0             	and    $0xffffffc0,%eax
8010204c:	3c 40                	cmp    $0x40,%al
8010204e:	75 f8                	jne    80102048 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102050:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102055:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010205a:	ee                   	out    %al,(%dx)
8010205b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102060:	b2 f7                	mov    $0xf7,%dl
80102062:	eb 09                	jmp    8010206d <ideinit+0x5d>
80102064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<1000; i++){
80102068:	83 e9 01             	sub    $0x1,%ecx
8010206b:	74 0f                	je     8010207c <ideinit+0x6c>
8010206d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010206e:	84 c0                	test   %al,%al
80102070:	74 f6                	je     80102068 <ideinit+0x58>
      havedisk1 = 1;
80102072:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102079:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010207c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102081:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102086:	ee                   	out    %al,(%dx)
}
80102087:	c9                   	leave  
80102088:	c3                   	ret    
80102089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102090 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102099:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020a0:	e8 4b 26 00 00       	call   801046f0 <acquire>

  if((b = idequeue) == 0){
801020a5:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020ab:	85 db                	test   %ebx,%ebx
801020ad:	74 30                	je     801020df <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020af:	8b 43 58             	mov    0x58(%ebx),%eax
801020b2:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020b7:	8b 33                	mov    (%ebx),%esi
801020b9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020bf:	74 37                	je     801020f8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020c1:	83 e6 fb             	and    $0xfffffffb,%esi
801020c4:	83 ce 02             	or     $0x2,%esi
801020c7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020c9:	89 1c 24             	mov    %ebx,(%esp)
801020cc:	e8 bf 21 00 00       	call   80104290 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020d1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020d6:	85 c0                	test   %eax,%eax
801020d8:	74 05                	je     801020df <ideintr+0x4f>
    idestart(idequeue);
801020da:	e8 71 fe ff ff       	call   80101f50 <idestart>
    release(&idelock);
801020df:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020e6:	e8 75 26 00 00       	call   80104760 <release>

  release(&idelock);
}
801020eb:	83 c4 1c             	add    $0x1c,%esp
801020ee:	5b                   	pop    %ebx
801020ef:	5e                   	pop    %esi
801020f0:	5f                   	pop    %edi
801020f1:	5d                   	pop    %ebp
801020f2:	c3                   	ret    
801020f3:	90                   	nop
801020f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020f8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020fd:	8d 76 00             	lea    0x0(%esi),%esi
80102100:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102101:	89 c1                	mov    %eax,%ecx
80102103:	83 e1 c0             	and    $0xffffffc0,%ecx
80102106:	80 f9 40             	cmp    $0x40,%cl
80102109:	75 f5                	jne    80102100 <ideintr+0x70>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010210b:	a8 21                	test   $0x21,%al
8010210d:	75 b2                	jne    801020c1 <ideintr+0x31>
    insl(0x1f0, b->data, BSIZE/4);
8010210f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102112:	b9 80 00 00 00       	mov    $0x80,%ecx
80102117:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010211c:	fc                   	cld    
8010211d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010211f:	8b 33                	mov    (%ebx),%esi
80102121:	eb 9e                	jmp    801020c1 <ideintr+0x31>
80102123:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102130 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	53                   	push   %ebx
80102134:	83 ec 14             	sub    $0x14,%esp
80102137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010213a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010213d:	89 04 24             	mov    %eax,(%esp)
80102140:	e8 eb 23 00 00       	call   80104530 <holdingsleep>
80102145:	85 c0                	test   %eax,%eax
80102147:	0f 84 9e 00 00 00    	je     801021eb <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010214d:	8b 03                	mov    (%ebx),%eax
8010214f:	83 e0 06             	and    $0x6,%eax
80102152:	83 f8 02             	cmp    $0x2,%eax
80102155:	0f 84 a8 00 00 00    	je     80102203 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010215b:	8b 53 04             	mov    0x4(%ebx),%edx
8010215e:	85 d2                	test   %edx,%edx
80102160:	74 0d                	je     8010216f <iderw+0x3f>
80102162:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102167:	85 c0                	test   %eax,%eax
80102169:	0f 84 88 00 00 00    	je     801021f7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010216f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102176:	e8 75 25 00 00       	call   801046f0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
80102180:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102187:	85 c0                	test   %eax,%eax
80102189:	75 07                	jne    80102192 <iderw+0x62>
8010218b:	eb 4e                	jmp    801021db <iderw+0xab>
8010218d:	8d 76 00             	lea    0x0(%esi),%esi
80102190:	89 d0                	mov    %edx,%eax
80102192:	8b 50 58             	mov    0x58(%eax),%edx
80102195:	85 d2                	test   %edx,%edx
80102197:	75 f7                	jne    80102190 <iderw+0x60>
80102199:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010219c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010219e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021a4:	74 3c                	je     801021e2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021a6:	8b 03                	mov    (%ebx),%eax
801021a8:	83 e0 06             	and    $0x6,%eax
801021ab:	83 f8 02             	cmp    $0x2,%eax
801021ae:	74 1a                	je     801021ca <iderw+0x9a>
    sleep(b, &idelock);
801021b0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801021b7:	80 
801021b8:	89 1c 24             	mov    %ebx,(%esp)
801021bb:	e8 40 1d 00 00       	call   80103f00 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021c0:	8b 13                	mov    (%ebx),%edx
801021c2:	83 e2 06             	and    $0x6,%edx
801021c5:	83 fa 02             	cmp    $0x2,%edx
801021c8:	75 e6                	jne    801021b0 <iderw+0x80>
  }


  release(&idelock);
801021ca:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021d1:	83 c4 14             	add    $0x14,%esp
801021d4:	5b                   	pop    %ebx
801021d5:	5d                   	pop    %ebp
  release(&idelock);
801021d6:	e9 85 25 00 00       	jmp    80104760 <release>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021db:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021e0:	eb ba                	jmp    8010219c <iderw+0x6c>
    idestart(b);
801021e2:	89 d8                	mov    %ebx,%eax
801021e4:	e8 67 fd ff ff       	call   80101f50 <idestart>
801021e9:	eb bb                	jmp    801021a6 <iderw+0x76>
    panic("iderw: buf not locked");
801021eb:	c7 04 24 6a 74 10 80 	movl   $0x8010746a,(%esp)
801021f2:	e8 69 e1 ff ff       	call   80100360 <panic>
    panic("iderw: ide disk 1 not present");
801021f7:	c7 04 24 95 74 10 80 	movl   $0x80107495,(%esp)
801021fe:	e8 5d e1 ff ff       	call   80100360 <panic>
    panic("iderw: nothing to do");
80102203:	c7 04 24 80 74 10 80 	movl   $0x80107480,(%esp)
8010220a:	e8 51 e1 ff ff       	call   80100360 <panic>
8010220f:	90                   	nop

80102210 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	56                   	push   %esi
80102214:	53                   	push   %ebx
80102215:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102218:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010221f:	00 c0 fe 
  ioapic->reg = reg;
80102222:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102229:	00 00 00 
  return ioapic->data;
8010222c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102232:	8b 42 10             	mov    0x10(%edx),%eax
  ioapic->reg = reg;
80102235:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010223b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102241:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102248:	c1 e8 10             	shr    $0x10,%eax
8010224b:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010224e:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102251:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102254:	39 c2                	cmp    %eax,%edx
80102256:	74 12                	je     8010226a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102258:	c7 04 24 b4 74 10 80 	movl   $0x801074b4,(%esp)
8010225f:	e8 ec e3 ff ff       	call   80100650 <cprintf>
80102264:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010226a:	ba 10 00 00 00       	mov    $0x10,%edx
8010226f:	31 c0                	xor    %eax,%eax
80102271:	eb 07                	jmp    8010227a <ioapicinit+0x6a>
80102273:	90                   	nop
80102274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102278:	89 cb                	mov    %ecx,%ebx
  ioapic->reg = reg;
8010227a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010227c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102282:	8d 48 20             	lea    0x20(%eax),%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102285:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  for(i = 0; i <= maxintr; i++){
8010228b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010228e:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102291:	8d 4a 01             	lea    0x1(%edx),%ecx
80102294:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
80102297:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102299:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010229f:	39 c6                	cmp    %eax,%esi
  ioapic->data = data;
801022a1:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022a8:	7d ce                	jge    80102278 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022aa:	83 c4 10             	add    $0x10,%esp
801022ad:	5b                   	pop    %ebx
801022ae:	5e                   	pop    %esi
801022af:	5d                   	pop    %ebp
801022b0:	c3                   	ret    
801022b1:	eb 0d                	jmp    801022c0 <ioapicenable>
801022b3:	90                   	nop
801022b4:	90                   	nop
801022b5:	90                   	nop
801022b6:	90                   	nop
801022b7:	90                   	nop
801022b8:	90                   	nop
801022b9:	90                   	nop
801022ba:	90                   	nop
801022bb:	90                   	nop
801022bc:	90                   	nop
801022bd:	90                   	nop
801022be:	90                   	nop
801022bf:	90                   	nop

801022c0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	8b 55 08             	mov    0x8(%ebp),%edx
801022c6:	53                   	push   %ebx
801022c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ca:	8d 5a 20             	lea    0x20(%edx),%ebx
801022cd:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
  ioapic->reg = reg;
801022d1:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022d7:	c1 e0 18             	shl    $0x18,%eax
  ioapic->reg = reg;
801022da:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022dc:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022e2:	83 c1 01             	add    $0x1,%ecx
  ioapic->data = data;
801022e5:	89 5a 10             	mov    %ebx,0x10(%edx)
  ioapic->reg = reg;
801022e8:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022ea:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022f0:	89 42 10             	mov    %eax,0x10(%edx)
}
801022f3:	5b                   	pop    %ebx
801022f4:	5d                   	pop    %ebp
801022f5:	c3                   	ret    
801022f6:	66 90                	xchg   %ax,%ax
801022f8:	66 90                	xchg   %ax,%ax
801022fa:	66 90                	xchg   %ax,%ax
801022fc:	66 90                	xchg   %ax,%ax
801022fe:	66 90                	xchg   %ax,%ax

80102300 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	53                   	push   %ebx
80102304:	83 ec 14             	sub    $0x14,%esp
80102307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010230a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102310:	75 7c                	jne    8010238e <kfree+0x8e>
80102312:	81 fb a8 59 11 80    	cmp    $0x801159a8,%ebx
80102318:	72 74                	jb     8010238e <kfree+0x8e>
8010231a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102320:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102325:	77 67                	ja     8010238e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102327:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010232e:	00 
8010232f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102336:	00 
80102337:	89 1c 24             	mov    %ebx,(%esp)
8010233a:	e8 71 24 00 00       	call   801047b0 <memset>

  if(kmem.use_lock)
8010233f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102345:	85 d2                	test   %edx,%edx
80102347:	75 37                	jne    80102380 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102349:	a1 78 26 11 80       	mov    0x80112678,%eax
8010234e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102350:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102355:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010235b:	85 c0                	test   %eax,%eax
8010235d:	75 09                	jne    80102368 <kfree+0x68>
    release(&kmem.lock);
}
8010235f:	83 c4 14             	add    $0x14,%esp
80102362:	5b                   	pop    %ebx
80102363:	5d                   	pop    %ebp
80102364:	c3                   	ret    
80102365:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102368:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010236f:	83 c4 14             	add    $0x14,%esp
80102372:	5b                   	pop    %ebx
80102373:	5d                   	pop    %ebp
    release(&kmem.lock);
80102374:	e9 e7 23 00 00       	jmp    80104760 <release>
80102379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102380:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102387:	e8 64 23 00 00       	call   801046f0 <acquire>
8010238c:	eb bb                	jmp    80102349 <kfree+0x49>
    panic("kfree");
8010238e:	c7 04 24 e6 74 10 80 	movl   $0x801074e6,(%esp)
80102395:	e8 c6 df ff ff       	call   80100360 <panic>
8010239a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023a0 <freerange>:
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
801023a5:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
801023a8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023ae:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023b4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ba:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023c0:	39 de                	cmp    %ebx,%esi
801023c2:	73 08                	jae    801023cc <freerange+0x2c>
801023c4:	eb 18                	jmp    801023de <freerange+0x3e>
801023c6:	66 90                	xchg   %ax,%ax
801023c8:	89 da                	mov    %ebx,%edx
801023ca:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023cc:	89 14 24             	mov    %edx,(%esp)
801023cf:	e8 2c ff ff ff       	call   80102300 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023da:	39 f0                	cmp    %esi,%eax
801023dc:	76 ea                	jbe    801023c8 <freerange+0x28>
}
801023de:	83 c4 10             	add    $0x10,%esp
801023e1:	5b                   	pop    %ebx
801023e2:	5e                   	pop    %esi
801023e3:	5d                   	pop    %ebp
801023e4:	c3                   	ret    
801023e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023f0 <kinit1>:
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	83 ec 10             	sub    $0x10,%esp
801023f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023fb:	c7 44 24 04 ec 74 10 	movl   $0x801074ec,0x4(%esp)
80102402:	80 
80102403:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010240a:	e8 71 21 00 00       	call   80104580 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010240f:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 0;
80102412:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102419:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010241c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102422:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102428:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010242e:	39 de                	cmp    %ebx,%esi
80102430:	73 0a                	jae    8010243c <kinit1+0x4c>
80102432:	eb 1a                	jmp    8010244e <kinit1+0x5e>
80102434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102438:	89 da                	mov    %ebx,%edx
8010243a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010243c:	89 14 24             	mov    %edx,(%esp)
8010243f:	e8 bc fe ff ff       	call   80102300 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102444:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010244a:	39 c6                	cmp    %eax,%esi
8010244c:	73 ea                	jae    80102438 <kinit1+0x48>
}
8010244e:	83 c4 10             	add    $0x10,%esp
80102451:	5b                   	pop    %ebx
80102452:	5e                   	pop    %esi
80102453:	5d                   	pop    %ebp
80102454:	c3                   	ret    
80102455:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kinit2>:
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
80102465:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102468:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010246b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010246e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102474:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010247a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102480:	39 de                	cmp    %ebx,%esi
80102482:	73 08                	jae    8010248c <kinit2+0x2c>
80102484:	eb 18                	jmp    8010249e <kinit2+0x3e>
80102486:	66 90                	xchg   %ax,%ax
80102488:	89 da                	mov    %ebx,%edx
8010248a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010248c:	89 14 24             	mov    %edx,(%esp)
8010248f:	e8 6c fe ff ff       	call   80102300 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102494:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010249a:	39 c6                	cmp    %eax,%esi
8010249c:	73 ea                	jae    80102488 <kinit2+0x28>
  kmem.use_lock = 1;
8010249e:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024a5:	00 00 00 
}
801024a8:	83 c4 10             	add    $0x10,%esp
801024ab:	5b                   	pop    %ebx
801024ac:	5e                   	pop    %esi
801024ad:	5d                   	pop    %ebp
801024ae:	c3                   	ret    
801024af:	90                   	nop

801024b0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	53                   	push   %ebx
801024b4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024b7:	a1 74 26 11 80       	mov    0x80112674,%eax
801024bc:	85 c0                	test   %eax,%eax
801024be:	75 30                	jne    801024f0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024c0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024c6:	85 db                	test   %ebx,%ebx
801024c8:	74 08                	je     801024d2 <kalloc+0x22>
    kmem.freelist = r->next;
801024ca:	8b 13                	mov    (%ebx),%edx
801024cc:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024d2:	85 c0                	test   %eax,%eax
801024d4:	74 0c                	je     801024e2 <kalloc+0x32>
    release(&kmem.lock);
801024d6:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024dd:	e8 7e 22 00 00       	call   80104760 <release>
  return (char*)r;
}
801024e2:	83 c4 14             	add    $0x14,%esp
801024e5:	89 d8                	mov    %ebx,%eax
801024e7:	5b                   	pop    %ebx
801024e8:	5d                   	pop    %ebp
801024e9:	c3                   	ret    
801024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
801024f0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024f7:	e8 f4 21 00 00       	call   801046f0 <acquire>
801024fc:	a1 74 26 11 80       	mov    0x80112674,%eax
80102501:	eb bd                	jmp    801024c0 <kalloc+0x10>
80102503:	66 90                	xchg   %ax,%ax
80102505:	66 90                	xchg   %ax,%ax
80102507:	66 90                	xchg   %ax,%ax
80102509:	66 90                	xchg   %ax,%ax
8010250b:	66 90                	xchg   %ax,%ax
8010250d:	66 90                	xchg   %ax,%ax
8010250f:	90                   	nop

80102510 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102510:	ba 64 00 00 00       	mov    $0x64,%edx
80102515:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102516:	a8 01                	test   $0x1,%al
80102518:	0f 84 ba 00 00 00    	je     801025d8 <kbdgetc+0xc8>
8010251e:	b2 60                	mov    $0x60,%dl
80102520:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102521:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102524:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010252a:	0f 84 88 00 00 00    	je     801025b8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102530:	84 c0                	test   %al,%al
80102532:	79 2c                	jns    80102560 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102534:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010253a:	f6 c2 40             	test   $0x40,%dl
8010253d:	75 05                	jne    80102544 <kbdgetc+0x34>
8010253f:	89 c1                	mov    %eax,%ecx
80102541:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102544:	0f b6 81 20 76 10 80 	movzbl -0x7fef89e0(%ecx),%eax
8010254b:	83 c8 40             	or     $0x40,%eax
8010254e:	0f b6 c0             	movzbl %al,%eax
80102551:	f7 d0                	not    %eax
80102553:	21 d0                	and    %edx,%eax
80102555:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010255a:	31 c0                	xor    %eax,%eax
8010255c:	c3                   	ret    
8010255d:	8d 76 00             	lea    0x0(%esi),%esi
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	53                   	push   %ebx
80102564:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(shift & E0ESC){
8010256a:	f6 c3 40             	test   $0x40,%bl
8010256d:	74 09                	je     80102578 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010256f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102572:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102575:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102578:	0f b6 91 20 76 10 80 	movzbl -0x7fef89e0(%ecx),%edx
  shift ^= togglecode[data];
8010257f:	0f b6 81 20 75 10 80 	movzbl -0x7fef8ae0(%ecx),%eax
  shift |= shiftcode[data];
80102586:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102588:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010258a:	89 d0                	mov    %edx,%eax
8010258c:	83 e0 03             	and    $0x3,%eax
8010258f:	8b 04 85 00 75 10 80 	mov    -0x7fef8b00(,%eax,4),%eax
  shift ^= togglecode[data];
80102596:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  if(shift & CAPSLOCK){
8010259c:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010259f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801025a3:	74 0b                	je     801025b0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
801025a5:	8d 50 9f             	lea    -0x61(%eax),%edx
801025a8:	83 fa 19             	cmp    $0x19,%edx
801025ab:	77 1b                	ja     801025c8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025ad:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025b0:	5b                   	pop    %ebx
801025b1:	5d                   	pop    %ebp
801025b2:	c3                   	ret    
801025b3:	90                   	nop
801025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025b8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801025bf:	31 c0                	xor    %eax,%eax
801025c1:	c3                   	ret    
801025c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801025c8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025cb:	8d 50 20             	lea    0x20(%eax),%edx
801025ce:	83 f9 19             	cmp    $0x19,%ecx
801025d1:	0f 46 c2             	cmovbe %edx,%eax
  return c;
801025d4:	eb da                	jmp    801025b0 <kbdgetc+0xa0>
801025d6:	66 90                	xchg   %ax,%ax
    return -1;
801025d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025dd:	c3                   	ret    
801025de:	66 90                	xchg   %ax,%ax

801025e0 <kbdintr>:

void
kbdintr(void)
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025e6:	c7 04 24 10 25 10 80 	movl   $0x80102510,(%esp)
801025ed:	e8 be e1 ff ff       	call   801007b0 <consoleintr>
}
801025f2:	c9                   	leave  
801025f3:	c3                   	ret    
801025f4:	66 90                	xchg   %ax,%ax
801025f6:	66 90                	xchg   %ax,%ax
801025f8:	66 90                	xchg   %ax,%ax
801025fa:	66 90                	xchg   %ax,%ax
801025fc:	66 90                	xchg   %ax,%ax
801025fe:	66 90                	xchg   %ax,%ax

80102600 <fill_rtcdate>:
  return inb(CMOS_RETURN);
}

static void
fill_rtcdate(struct rtcdate *r)
{
80102600:	55                   	push   %ebp
80102601:	89 c1                	mov    %eax,%ecx
80102603:	89 e5                	mov    %esp,%ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102605:	ba 70 00 00 00       	mov    $0x70,%edx
8010260a:	53                   	push   %ebx
8010260b:	31 c0                	xor    %eax,%eax
8010260d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010260e:	bb 71 00 00 00       	mov    $0x71,%ebx
80102613:	89 da                	mov    %ebx,%edx
80102615:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
80102616:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102619:	b2 70                	mov    $0x70,%dl
8010261b:	89 01                	mov    %eax,(%ecx)
8010261d:	b8 02 00 00 00       	mov    $0x2,%eax
80102622:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102623:	89 da                	mov    %ebx,%edx
80102625:	ec                   	in     (%dx),%al
80102626:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102629:	b2 70                	mov    $0x70,%dl
8010262b:	89 41 04             	mov    %eax,0x4(%ecx)
8010262e:	b8 04 00 00 00       	mov    $0x4,%eax
80102633:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102634:	89 da                	mov    %ebx,%edx
80102636:	ec                   	in     (%dx),%al
80102637:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010263a:	b2 70                	mov    $0x70,%dl
8010263c:	89 41 08             	mov    %eax,0x8(%ecx)
8010263f:	b8 07 00 00 00       	mov    $0x7,%eax
80102644:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102645:	89 da                	mov    %ebx,%edx
80102647:	ec                   	in     (%dx),%al
80102648:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010264b:	b2 70                	mov    $0x70,%dl
8010264d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102650:	b8 08 00 00 00       	mov    $0x8,%eax
80102655:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102656:	89 da                	mov    %ebx,%edx
80102658:	ec                   	in     (%dx),%al
80102659:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010265c:	b2 70                	mov    $0x70,%dl
8010265e:	89 41 10             	mov    %eax,0x10(%ecx)
80102661:	b8 09 00 00 00       	mov    $0x9,%eax
80102666:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102667:	89 da                	mov    %ebx,%edx
80102669:	ec                   	in     (%dx),%al
8010266a:	0f b6 d8             	movzbl %al,%ebx
8010266d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102670:	5b                   	pop    %ebx
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102680 <lapicinit>:
  if(!lapic)
80102680:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102685:	55                   	push   %ebp
80102686:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102688:	85 c0                	test   %eax,%eax
8010268a:	0f 84 c0 00 00 00    	je     80102750 <lapicinit+0xd0>
  lapic[index] = value;
80102690:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102697:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010269a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010269d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026aa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026b1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026b4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026b7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026be:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026c1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026c4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026cb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ce:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026d8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026db:	8b 50 20             	mov    0x20(%eax),%edx
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026de:	8b 50 30             	mov    0x30(%eax),%edx
801026e1:	c1 ea 10             	shr    $0x10,%edx
801026e4:	80 fa 03             	cmp    $0x3,%dl
801026e7:	77 6f                	ja     80102758 <lapicinit+0xd8>
  lapic[index] = value;
801026e9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026f0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026fd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102700:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102703:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010270a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010270d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102710:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102717:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010271a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010271d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102724:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102727:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010272a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102731:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102734:	8b 50 20             	mov    0x20(%eax),%edx
80102737:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
80102738:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010273e:	80 e6 10             	and    $0x10,%dh
80102741:	75 f5                	jne    80102738 <lapicinit+0xb8>
  lapic[index] = value;
80102743:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010274a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010274d:	8b 40 20             	mov    0x20(%eax),%eax
}
80102750:	5d                   	pop    %ebp
80102751:	c3                   	ret    
80102752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102758:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010275f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102762:	8b 50 20             	mov    0x20(%eax),%edx
80102765:	eb 82                	jmp    801026e9 <lapicinit+0x69>
80102767:	89 f6                	mov    %esi,%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102770 <lapicid>:
  if (!lapic)
80102770:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102775:	55                   	push   %ebp
80102776:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102778:	85 c0                	test   %eax,%eax
8010277a:	74 0c                	je     80102788 <lapicid+0x18>
  return lapic[ID] >> 24;
8010277c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010277f:	5d                   	pop    %ebp
  return lapic[ID] >> 24;
80102780:	c1 e8 18             	shr    $0x18,%eax
}
80102783:	c3                   	ret    
80102784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102788:	31 c0                	xor    %eax,%eax
}
8010278a:	5d                   	pop    %ebp
8010278b:	c3                   	ret    
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <lapiceoi>:
  if(lapic)
80102790:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102795:	55                   	push   %ebp
80102796:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102798:	85 c0                	test   %eax,%eax
8010279a:	74 0d                	je     801027a9 <lapiceoi+0x19>
  lapic[index] = value;
8010279c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027a3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a6:	8b 40 20             	mov    0x20(%eax),%eax
}
801027a9:	5d                   	pop    %ebp
801027aa:	c3                   	ret    
801027ab:	90                   	nop
801027ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027b0 <microdelay>:
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
}
801027b3:	5d                   	pop    %ebp
801027b4:	c3                   	ret    
801027b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027c0 <lapicstartap>:
{
801027c0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027c1:	ba 70 00 00 00       	mov    $0x70,%edx
801027c6:	89 e5                	mov    %esp,%ebp
801027c8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027cd:	53                   	push   %ebx
801027ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027d4:	ee                   	out    %al,(%dx)
801027d5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027da:	b2 71                	mov    $0x71,%dl
801027dc:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
801027dd:	31 c0                	xor    %eax,%eax
801027df:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027e5:	89 d8                	mov    %ebx,%eax
801027e7:	c1 e8 04             	shr    $0x4,%eax
801027ea:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801027f0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(ICRHI, apicid<<24);
801027f5:	c1 e1 18             	shl    $0x18,%ecx
    lapicw(ICRLO, STARTUP | (addr>>12));
801027f8:	c1 eb 0c             	shr    $0xc,%ebx
  lapic[index] = value;
801027fb:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102801:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102804:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010280b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010280e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102811:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102818:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010281b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102827:	89 da                	mov    %ebx,%edx
80102829:	80 ce 06             	or     $0x6,%dh
  lapic[index] = value;
8010282c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102832:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102835:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 48 20             	mov    0x20(%eax),%ecx
  lapic[index] = value;
8010283e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102844:	8b 40 20             	mov    0x20(%eax),%eax
}
80102847:	5b                   	pop    %ebx
80102848:	5d                   	pop    %ebp
80102849:	c3                   	ret    
8010284a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102850 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102850:	55                   	push   %ebp
80102851:	ba 70 00 00 00       	mov    $0x70,%edx
80102856:	89 e5                	mov    %esp,%ebp
80102858:	b8 0b 00 00 00       	mov    $0xb,%eax
8010285d:	57                   	push   %edi
8010285e:	56                   	push   %esi
8010285f:	53                   	push   %ebx
80102860:	83 ec 4c             	sub    $0x4c,%esp
80102863:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102864:	b2 71                	mov    $0x71,%dl
80102866:	ec                   	in     (%dx),%al
80102867:	88 45 b7             	mov    %al,-0x49(%ebp)
8010286a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010286d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102871:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102878:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010287d:	89 d8                	mov    %ebx,%eax
8010287f:	e8 7c fd ff ff       	call   80102600 <fill_rtcdate>
80102884:	b8 0a 00 00 00       	mov    $0xa,%eax
80102889:	89 f2                	mov    %esi,%edx
8010288b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288c:	ba 71 00 00 00       	mov    $0x71,%edx
80102891:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102892:	84 c0                	test   %al,%al
80102894:	78 e7                	js     8010287d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102896:	89 f8                	mov    %edi,%eax
80102898:	e8 63 fd ff ff       	call   80102600 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010289d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801028a4:	00 
801028a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
801028a9:	89 1c 24             	mov    %ebx,(%esp)
801028ac:	e8 4f 1f 00 00       	call   80104800 <memcmp>
801028b1:	85 c0                	test   %eax,%eax
801028b3:	75 c3                	jne    80102878 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801028b5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028b9:	75 78                	jne    80102933 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028bb:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028be:	89 c2                	mov    %eax,%edx
801028c0:	83 e0 0f             	and    $0xf,%eax
801028c3:	c1 ea 04             	shr    $0x4,%edx
801028c6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028c9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028cc:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028cf:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028d2:	89 c2                	mov    %eax,%edx
801028d4:	83 e0 0f             	and    $0xf,%eax
801028d7:	c1 ea 04             	shr    $0x4,%edx
801028da:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028dd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028e0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801028e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028e6:	89 c2                	mov    %eax,%edx
801028e8:	83 e0 0f             	and    $0xf,%eax
801028eb:	c1 ea 04             	shr    $0x4,%edx
801028ee:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028f1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028f4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801028f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801028fa:	89 c2                	mov    %eax,%edx
801028fc:	83 e0 0f             	and    $0xf,%eax
801028ff:	c1 ea 04             	shr    $0x4,%edx
80102902:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102905:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102908:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010290b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010290e:	89 c2                	mov    %eax,%edx
80102910:	83 e0 0f             	and    $0xf,%eax
80102913:	c1 ea 04             	shr    $0x4,%edx
80102916:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102919:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010291c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010291f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102922:	89 c2                	mov    %eax,%edx
80102924:	83 e0 0f             	and    $0xf,%eax
80102927:	c1 ea 04             	shr    $0x4,%edx
8010292a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010292d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102930:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102933:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102936:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102939:	89 01                	mov    %eax,(%ecx)
8010293b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010293e:	89 41 04             	mov    %eax,0x4(%ecx)
80102941:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102944:	89 41 08             	mov    %eax,0x8(%ecx)
80102947:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010294a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010294d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102950:	89 41 10             	mov    %eax,0x10(%ecx)
80102953:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102956:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102959:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102960:	83 c4 4c             	add    $0x4c,%esp
80102963:	5b                   	pop    %ebx
80102964:	5e                   	pop    %esi
80102965:	5f                   	pop    %edi
80102966:	5d                   	pop    %ebp
80102967:	c3                   	ret    
80102968:	66 90                	xchg   %ax,%ax
8010296a:	66 90                	xchg   %ax,%ax
8010296c:	66 90                	xchg   %ax,%ax
8010296e:	66 90                	xchg   %ax,%ax

80102970 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102970:	55                   	push   %ebp
80102971:	89 e5                	mov    %esp,%ebp
80102973:	57                   	push   %edi
80102974:	56                   	push   %esi
80102975:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102976:	31 db                	xor    %ebx,%ebx
{
80102978:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010297b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102980:	85 c0                	test   %eax,%eax
80102982:	7e 78                	jle    801029fc <install_trans+0x8c>
80102984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102988:	a1 b4 26 11 80       	mov    0x801126b4,%eax
8010298d:	01 d8                	add    %ebx,%eax
8010298f:	83 c0 01             	add    $0x1,%eax
80102992:	89 44 24 04          	mov    %eax,0x4(%esp)
80102996:	a1 c4 26 11 80       	mov    0x801126c4,%eax
8010299b:	89 04 24             	mov    %eax,(%esp)
8010299e:	e8 2d d7 ff ff       	call   801000d0 <bread>
801029a3:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029a5:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
801029ac:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029af:	89 44 24 04          	mov    %eax,0x4(%esp)
801029b3:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029b8:	89 04 24             	mov    %eax,(%esp)
801029bb:	e8 10 d7 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029c0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801029c7:	00 
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029c8:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029ca:	8d 47 5c             	lea    0x5c(%edi),%eax
801029cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801029d1:	8d 46 5c             	lea    0x5c(%esi),%eax
801029d4:	89 04 24             	mov    %eax,(%esp)
801029d7:	e8 74 1e 00 00       	call   80104850 <memmove>
    bwrite(dbuf);  // write dst to disk
801029dc:	89 34 24             	mov    %esi,(%esp)
801029df:	e8 bc d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801029e4:	89 3c 24             	mov    %edi,(%esp)
801029e7:	e8 f4 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801029ec:	89 34 24             	mov    %esi,(%esp)
801029ef:	e8 ec d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801029f4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
801029fa:	7f 8c                	jg     80102988 <install_trans+0x18>
  }
}
801029fc:	83 c4 1c             	add    $0x1c,%esp
801029ff:	5b                   	pop    %ebx
80102a00:	5e                   	pop    %esi
80102a01:	5f                   	pop    %edi
80102a02:	5d                   	pop    %ebp
80102a03:	c3                   	ret    
80102a04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a10 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a10:	55                   	push   %ebp
80102a11:	89 e5                	mov    %esp,%ebp
80102a13:	57                   	push   %edi
80102a14:	56                   	push   %esi
80102a15:	53                   	push   %ebx
80102a16:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a19:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a1e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a22:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a27:	89 04 24             	mov    %eax,(%esp)
80102a2a:	e8 a1 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a2f:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a35:	31 d2                	xor    %edx,%edx
80102a37:	85 db                	test   %ebx,%ebx
  struct buf *buf = bread(log.dev, log.start);
80102a39:	89 c7                	mov    %eax,%edi
  hb->n = log.lh.n;
80102a3b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a3e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a41:	7e 17                	jle    80102a5a <write_head+0x4a>
80102a43:	90                   	nop
80102a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a48:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102a4f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102a53:	83 c2 01             	add    $0x1,%edx
80102a56:	39 da                	cmp    %ebx,%edx
80102a58:	75 ee                	jne    80102a48 <write_head+0x38>
  }
  bwrite(buf);
80102a5a:	89 3c 24             	mov    %edi,(%esp)
80102a5d:	e8 3e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a62:	89 3c 24             	mov    %edi,(%esp)
80102a65:	e8 76 d7 ff ff       	call   801001e0 <brelse>
}
80102a6a:	83 c4 1c             	add    $0x1c,%esp
80102a6d:	5b                   	pop    %ebx
80102a6e:	5e                   	pop    %esi
80102a6f:	5f                   	pop    %edi
80102a70:	5d                   	pop    %ebp
80102a71:	c3                   	ret    
80102a72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a80 <initlog>:
{
80102a80:	55                   	push   %ebp
80102a81:	89 e5                	mov    %esp,%ebp
80102a83:	56                   	push   %esi
80102a84:	53                   	push   %ebx
80102a85:	83 ec 30             	sub    $0x30,%esp
80102a88:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102a8b:	c7 44 24 04 20 77 10 	movl   $0x80107720,0x4(%esp)
80102a92:	80 
80102a93:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102a9a:	e8 e1 1a 00 00       	call   80104580 <initlock>
  readsb(dev, &sb);
80102a9f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102aa6:	89 1c 24             	mov    %ebx,(%esp)
80102aa9:	e8 82 e9 ff ff       	call   80101430 <readsb>
  log.start = sb.logstart;
80102aae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102ab1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  struct buf *buf = bread(log.dev, log.start);
80102ab4:	89 1c 24             	mov    %ebx,(%esp)
  log.dev = dev;
80102ab7:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  struct buf *buf = bread(log.dev, log.start);
80102abd:	89 44 24 04          	mov    %eax,0x4(%esp)
  log.size = sb.nlog;
80102ac1:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102ac7:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102acc:	e8 ff d5 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102ad1:	31 d2                	xor    %edx,%edx
  log.lh.n = lh->n;
80102ad3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ad6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102ad9:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102adb:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102ae1:	7e 17                	jle    80102afa <initlog+0x7a>
80102ae3:	90                   	nop
80102ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102ae8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102aec:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102af3:	83 c2 01             	add    $0x1,%edx
80102af6:	39 da                	cmp    %ebx,%edx
80102af8:	75 ee                	jne    80102ae8 <initlog+0x68>
  brelse(buf);
80102afa:	89 04 24             	mov    %eax,(%esp)
80102afd:	e8 de d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b02:	e8 69 fe ff ff       	call   80102970 <install_trans>
  log.lh.n = 0;
80102b07:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b0e:	00 00 00 
  write_head(); // clear the log
80102b11:	e8 fa fe ff ff       	call   80102a10 <write_head>
}
80102b16:	83 c4 30             	add    $0x30,%esp
80102b19:	5b                   	pop    %ebx
80102b1a:	5e                   	pop    %esi
80102b1b:	5d                   	pop    %ebp
80102b1c:	c3                   	ret    
80102b1d:	8d 76 00             	lea    0x0(%esi),%esi

80102b20 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b26:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b2d:	e8 be 1b 00 00       	call   801046f0 <acquire>
80102b32:	eb 18                	jmp    80102b4c <begin_op+0x2c>
80102b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b38:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102b3f:	80 
80102b40:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b47:	e8 b4 13 00 00       	call   80103f00 <sleep>
    if(log.committing){
80102b4c:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b51:	85 c0                	test   %eax,%eax
80102b53:	75 e3                	jne    80102b38 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b55:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b5a:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b60:	83 c0 01             	add    $0x1,%eax
80102b63:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b66:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b69:	83 fa 1e             	cmp    $0x1e,%edx
80102b6c:	7f ca                	jg     80102b38 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b6e:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      log.outstanding += 1;
80102b75:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b7a:	e8 e1 1b 00 00       	call   80104760 <release>
      break;
    }
  }
}
80102b7f:	c9                   	leave  
80102b80:	c3                   	ret    
80102b81:	eb 0d                	jmp    80102b90 <end_op>
80102b83:	90                   	nop
80102b84:	90                   	nop
80102b85:	90                   	nop
80102b86:	90                   	nop
80102b87:	90                   	nop
80102b88:	90                   	nop
80102b89:	90                   	nop
80102b8a:	90                   	nop
80102b8b:	90                   	nop
80102b8c:	90                   	nop
80102b8d:	90                   	nop
80102b8e:	90                   	nop
80102b8f:	90                   	nop

80102b90 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
80102b93:	57                   	push   %edi
80102b94:	56                   	push   %esi
80102b95:	53                   	push   %ebx
80102b96:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102b99:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ba0:	e8 4b 1b 00 00       	call   801046f0 <acquire>
  log.outstanding -= 1;
80102ba5:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102baa:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
  log.outstanding -= 1;
80102bb0:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102bb3:	85 d2                	test   %edx,%edx
  log.outstanding -= 1;
80102bb5:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102bba:	0f 85 f3 00 00 00    	jne    80102cb3 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102bc0:	85 c0                	test   %eax,%eax
80102bc2:	0f 85 cb 00 00 00    	jne    80102c93 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bc8:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bcf:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
80102bd1:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102bd8:	00 00 00 
  release(&log.lock);
80102bdb:	e8 80 1b 00 00       	call   80104760 <release>
  if (log.lh.n > 0) {
80102be0:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102be5:	85 c0                	test   %eax,%eax
80102be7:	0f 8e 90 00 00 00    	jle    80102c7d <end_op+0xed>
80102bed:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102bf0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bf5:	01 d8                	add    %ebx,%eax
80102bf7:	83 c0 01             	add    $0x1,%eax
80102bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bfe:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c03:	89 04 24             	mov    %eax,(%esp)
80102c06:	e8 c5 d4 ff ff       	call   801000d0 <bread>
80102c0b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c0d:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102c14:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c17:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c1b:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c20:	89 04 24             	mov    %eax,(%esp)
80102c23:	e8 a8 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c28:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c2f:	00 
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c30:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c32:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c35:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c39:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c3c:	89 04 24             	mov    %eax,(%esp)
80102c3f:	e8 0c 1c 00 00       	call   80104850 <memmove>
    bwrite(to);  // write the log
80102c44:	89 34 24             	mov    %esi,(%esp)
80102c47:	e8 54 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c4c:	89 3c 24             	mov    %edi,(%esp)
80102c4f:	e8 8c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c54:	89 34 24             	mov    %esi,(%esp)
80102c57:	e8 84 d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c5c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c62:	7c 8c                	jl     80102bf0 <end_op+0x60>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c64:	e8 a7 fd ff ff       	call   80102a10 <write_head>
    install_trans(); // Now install writes to home locations
80102c69:	e8 02 fd ff ff       	call   80102970 <install_trans>
    log.lh.n = 0;
80102c6e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c75:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c78:	e8 93 fd ff ff       	call   80102a10 <write_head>
    acquire(&log.lock);
80102c7d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c84:	e8 67 1a 00 00       	call   801046f0 <acquire>
    log.committing = 0;
80102c89:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102c90:	00 00 00 
    wakeup(&log);
80102c93:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c9a:	e8 f1 15 00 00       	call   80104290 <wakeup>
    release(&log.lock);
80102c9f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ca6:	e8 b5 1a 00 00       	call   80104760 <release>
}
80102cab:	83 c4 1c             	add    $0x1c,%esp
80102cae:	5b                   	pop    %ebx
80102caf:	5e                   	pop    %esi
80102cb0:	5f                   	pop    %edi
80102cb1:	5d                   	pop    %ebp
80102cb2:	c3                   	ret    
    panic("log.committing");
80102cb3:	c7 04 24 24 77 10 80 	movl   $0x80107724,(%esp)
80102cba:	e8 a1 d6 ff ff       	call   80100360 <panic>
80102cbf:	90                   	nop

80102cc0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cc7:	a1 c8 26 11 80       	mov    0x801126c8,%eax
{
80102ccc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ccf:	83 f8 1d             	cmp    $0x1d,%eax
80102cd2:	0f 8f 98 00 00 00    	jg     80102d70 <log_write+0xb0>
80102cd8:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102cde:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102ce1:	39 d0                	cmp    %edx,%eax
80102ce3:	0f 8d 87 00 00 00    	jge    80102d70 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102ce9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102cee:	85 c0                	test   %eax,%eax
80102cf0:	0f 8e 86 00 00 00    	jle    80102d7c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102cf6:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cfd:	e8 ee 19 00 00       	call   801046f0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d02:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d08:	83 fa 00             	cmp    $0x0,%edx
80102d0b:	7e 54                	jle    80102d61 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d0d:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102d10:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d12:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102d18:	75 0f                	jne    80102d29 <log_write+0x69>
80102d1a:	eb 3c                	jmp    80102d58 <log_write+0x98>
80102d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d20:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d27:	74 2f                	je     80102d58 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102d29:	83 c0 01             	add    $0x1,%eax
80102d2c:	39 d0                	cmp    %edx,%eax
80102d2e:	75 f0                	jne    80102d20 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102d30:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d37:	83 c2 01             	add    $0x1,%edx
80102d3a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d40:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d43:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d4a:	83 c4 14             	add    $0x14,%esp
80102d4d:	5b                   	pop    %ebx
80102d4e:	5d                   	pop    %ebp
  release(&log.lock);
80102d4f:	e9 0c 1a 00 00       	jmp    80104760 <release>
80102d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80102d58:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d5f:	eb df                	jmp    80102d40 <log_write+0x80>
80102d61:	8b 43 08             	mov    0x8(%ebx),%eax
80102d64:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102d69:	75 d5                	jne    80102d40 <log_write+0x80>
80102d6b:	eb ca                	jmp    80102d37 <log_write+0x77>
80102d6d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("too big a transaction");
80102d70:	c7 04 24 33 77 10 80 	movl   $0x80107733,(%esp)
80102d77:	e8 e4 d5 ff ff       	call   80100360 <panic>
    panic("log_write outside of trans");
80102d7c:	c7 04 24 49 77 10 80 	movl   $0x80107749,(%esp)
80102d83:	e8 d8 d5 ff ff       	call   80100360 <panic>
80102d88:	66 90                	xchg   %ax,%ax
80102d8a:	66 90                	xchg   %ax,%ax
80102d8c:	66 90                	xchg   %ax,%ax
80102d8e:	66 90                	xchg   %ax,%ax

80102d90 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	53                   	push   %ebx
80102d94:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102d97:	e8 24 09 00 00       	call   801036c0 <cpuid>
80102d9c:	89 c3                	mov    %eax,%ebx
80102d9e:	e8 1d 09 00 00       	call   801036c0 <cpuid>
80102da3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102da7:	c7 04 24 64 77 10 80 	movl   $0x80107764,(%esp)
80102dae:	89 44 24 04          	mov    %eax,0x4(%esp)
80102db2:	e8 99 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102db7:	e8 54 2d 00 00       	call   80105b10 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102dbc:	e8 7f 08 00 00       	call   80103640 <mycpu>
80102dc1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102dc3:	b8 01 00 00 00       	mov    $0x1,%eax
80102dc8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102dcf:	e8 2c 0c 00 00       	call   80103a00 <scheduler>
80102dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102de0 <mpenter>:
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102de6:	e8 e5 3d 00 00       	call   80106bd0 <switchkvm>
  seginit();
80102deb:	e8 20 3d 00 00       	call   80106b10 <seginit>
  lapicinit();
80102df0:	e8 8b f8 ff ff       	call   80102680 <lapicinit>
  mpmain();
80102df5:	e8 96 ff ff ff       	call   80102d90 <mpmain>
80102dfa:	66 90                	xchg   %ax,%ax
80102dfc:	66 90                	xchg   %ax,%ax
80102dfe:	66 90                	xchg   %ax,%ax

80102e00 <main>:
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e04:	bb 80 27 11 80       	mov    $0x80112780,%ebx
{
80102e09:	83 e4 f0             	and    $0xfffffff0,%esp
80102e0c:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e0f:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e16:	80 
80102e17:	c7 04 24 a8 59 11 80 	movl   $0x801159a8,(%esp)
80102e1e:	e8 cd f5 ff ff       	call   801023f0 <kinit1>
  kvmalloc();      // kernel page table
80102e23:	e8 38 42 00 00       	call   80107060 <kvmalloc>
  mpinit();        // detect other processors
80102e28:	e8 73 01 00 00       	call   80102fa0 <mpinit>
80102e2d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e30:	e8 4b f8 ff ff       	call   80102680 <lapicinit>
  seginit();       // segment descriptors
80102e35:	e8 d6 3c 00 00       	call   80106b10 <seginit>
  picinit();       // disable pic
80102e3a:	e8 21 03 00 00       	call   80103160 <picinit>
80102e3f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e40:	e8 cb f3 ff ff       	call   80102210 <ioapicinit>
  consoleinit();   // console hardware
80102e45:	e8 06 db ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e4a:	e8 e1 2f 00 00       	call   80105e30 <uartinit>
80102e4f:	90                   	nop
  pinit();         // process table
80102e50:	e8 cb 07 00 00       	call   80103620 <pinit>
  tvinit();        // trap vectors
80102e55:	e8 16 2c 00 00       	call   80105a70 <tvinit>
  binit();         // buffer cache
80102e5a:	e8 e1 d1 ff ff       	call   80100040 <binit>
80102e5f:	90                   	nop
  fileinit();      // file table
80102e60:	e8 fb de ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
80102e65:	e8 a6 f1 ff ff       	call   80102010 <ideinit>
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e6a:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e71:	00 
80102e72:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102e79:	80 
80102e7a:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102e81:	e8 ca 19 00 00       	call   80104850 <memmove>
  for(c = cpus; c < cpus+ncpu; c++){
80102e86:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102e8d:	00 00 00 
80102e90:	05 80 27 11 80       	add    $0x80112780,%eax
80102e95:	39 d8                	cmp    %ebx,%eax
80102e97:	76 6a                	jbe    80102f03 <main+0x103>
80102e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102ea0:	e8 9b 07 00 00       	call   80103640 <mycpu>
80102ea5:	39 d8                	cmp    %ebx,%eax
80102ea7:	74 41                	je     80102eea <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ea9:	e8 02 f6 ff ff       	call   801024b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
80102eae:	c7 05 f8 6f 00 80 e0 	movl   $0x80102de0,0x80006ff8
80102eb5:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102eb8:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102ebf:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ec2:	05 00 10 00 00       	add    $0x1000,%eax
80102ec7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102ecc:	0f b6 03             	movzbl (%ebx),%eax
80102ecf:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102ed6:	00 
80102ed7:	89 04 24             	mov    %eax,(%esp)
80102eda:	e8 e1 f8 ff ff       	call   801027c0 <lapicstartap>
80102edf:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102ee0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ee6:	85 c0                	test   %eax,%eax
80102ee8:	74 f6                	je     80102ee0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102eea:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ef1:	00 00 00 
80102ef4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102efa:	05 80 27 11 80       	add    $0x80112780,%eax
80102eff:	39 c3                	cmp    %eax,%ebx
80102f01:	72 9d                	jb     80102ea0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f03:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f0a:	8e 
80102f0b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f12:	e8 49 f5 ff ff       	call   80102460 <kinit2>
  userinit();      // first user process
80102f17:	e8 f4 07 00 00       	call   80103710 <userinit>
  mpmain();        // finish this processor's setup
80102f1c:	e8 6f fe ff ff       	call   80102d90 <mpmain>
80102f21:	66 90                	xchg   %ax,%ax
80102f23:	66 90                	xchg   %ax,%ax
80102f25:	66 90                	xchg   %ax,%ax
80102f27:	66 90                	xchg   %ax,%ax
80102f29:	66 90                	xchg   %ax,%ax
80102f2b:	66 90                	xchg   %ax,%ax
80102f2d:	66 90                	xchg   %ax,%ax
80102f2f:	90                   	nop

80102f30 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f30:	55                   	push   %ebp
80102f31:	89 e5                	mov    %esp,%ebp
80102f33:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f34:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102f3a:	53                   	push   %ebx
  e = addr+len;
80102f3b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102f3e:	83 ec 10             	sub    $0x10,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102f41:	39 de                	cmp    %ebx,%esi
80102f43:	73 3c                	jae    80102f81 <mpsearch1+0x51>
80102f45:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f48:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f4f:	00 
80102f50:	c7 44 24 04 78 77 10 	movl   $0x80107778,0x4(%esp)
80102f57:	80 
80102f58:	89 34 24             	mov    %esi,(%esp)
80102f5b:	e8 a0 18 00 00       	call   80104800 <memcmp>
80102f60:	85 c0                	test   %eax,%eax
80102f62:	75 16                	jne    80102f7a <mpsearch1+0x4a>
80102f64:	31 c9                	xor    %ecx,%ecx
80102f66:	31 d2                	xor    %edx,%edx
    sum += addr[i];
80102f68:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
  for(i=0; i<len; i++)
80102f6c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102f6f:	01 c1                	add    %eax,%ecx
  for(i=0; i<len; i++)
80102f71:	83 fa 10             	cmp    $0x10,%edx
80102f74:	75 f2                	jne    80102f68 <mpsearch1+0x38>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f76:	84 c9                	test   %cl,%cl
80102f78:	74 10                	je     80102f8a <mpsearch1+0x5a>
  for(p = addr; p < e; p += sizeof(struct mp))
80102f7a:	83 c6 10             	add    $0x10,%esi
80102f7d:	39 f3                	cmp    %esi,%ebx
80102f7f:	77 c7                	ja     80102f48 <mpsearch1+0x18>
      return (struct mp*)p;
  return 0;
}
80102f81:	83 c4 10             	add    $0x10,%esp
  return 0;
80102f84:	31 c0                	xor    %eax,%eax
}
80102f86:	5b                   	pop    %ebx
80102f87:	5e                   	pop    %esi
80102f88:	5d                   	pop    %ebp
80102f89:	c3                   	ret    
80102f8a:	83 c4 10             	add    $0x10,%esp
80102f8d:	89 f0                	mov    %esi,%eax
80102f8f:	5b                   	pop    %ebx
80102f90:	5e                   	pop    %esi
80102f91:	5d                   	pop    %ebp
80102f92:	c3                   	ret    
80102f93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fa0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	57                   	push   %edi
80102fa4:	56                   	push   %esi
80102fa5:	53                   	push   %ebx
80102fa6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102fa9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102fb0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102fb7:	c1 e0 08             	shl    $0x8,%eax
80102fba:	09 d0                	or     %edx,%eax
80102fbc:	c1 e0 04             	shl    $0x4,%eax
80102fbf:	85 c0                	test   %eax,%eax
80102fc1:	75 1b                	jne    80102fde <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102fc3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102fca:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102fd1:	c1 e0 08             	shl    $0x8,%eax
80102fd4:	09 d0                	or     %edx,%eax
80102fd6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102fd9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80102fde:	ba 00 04 00 00       	mov    $0x400,%edx
80102fe3:	e8 48 ff ff ff       	call   80102f30 <mpsearch1>
80102fe8:	85 c0                	test   %eax,%eax
80102fea:	89 c7                	mov    %eax,%edi
80102fec:	0f 84 22 01 00 00    	je     80103114 <mpinit+0x174>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102ff2:	8b 77 04             	mov    0x4(%edi),%esi
80102ff5:	85 f6                	test   %esi,%esi
80102ff7:	0f 84 30 01 00 00    	je     8010312d <mpinit+0x18d>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102ffd:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103003:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010300a:	00 
8010300b:	c7 44 24 04 7d 77 10 	movl   $0x8010777d,0x4(%esp)
80103012:	80 
80103013:	89 04 24             	mov    %eax,(%esp)
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103016:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103019:	e8 e2 17 00 00       	call   80104800 <memcmp>
8010301e:	85 c0                	test   %eax,%eax
80103020:	0f 85 07 01 00 00    	jne    8010312d <mpinit+0x18d>
  if(conf->version != 1 && conf->version != 4)
80103026:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010302d:	3c 04                	cmp    $0x4,%al
8010302f:	0f 85 0b 01 00 00    	jne    80103140 <mpinit+0x1a0>
  if(sum((uchar*)conf, conf->length) != 0)
80103035:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
  for(i=0; i<len; i++)
8010303c:	85 c0                	test   %eax,%eax
8010303e:	74 21                	je     80103061 <mpinit+0xc1>
  sum = 0;
80103040:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103042:	31 d2                	xor    %edx,%edx
80103044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103048:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010304f:	80 
  for(i=0; i<len; i++)
80103050:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103053:	01 d9                	add    %ebx,%ecx
  for(i=0; i<len; i++)
80103055:	39 d0                	cmp    %edx,%eax
80103057:	7f ef                	jg     80103048 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103059:	84 c9                	test   %cl,%cl
8010305b:	0f 85 cc 00 00 00    	jne    8010312d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103061:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103064:	85 c0                	test   %eax,%eax
80103066:	0f 84 c1 00 00 00    	je     8010312d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010306c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  ismp = 1;
80103072:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103077:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010307c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103083:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103089:	03 55 e4             	add    -0x1c(%ebp),%edx
8010308c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103090:	39 c2                	cmp    %eax,%edx
80103092:	76 1b                	jbe    801030af <mpinit+0x10f>
80103094:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
80103097:	80 f9 04             	cmp    $0x4,%cl
8010309a:	77 74                	ja     80103110 <mpinit+0x170>
8010309c:	ff 24 8d bc 77 10 80 	jmp    *-0x7fef8844(,%ecx,4)
801030a3:	90                   	nop
801030a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801030a8:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030ab:	39 c2                	cmp    %eax,%edx
801030ad:	77 e5                	ja     80103094 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801030af:	85 db                	test   %ebx,%ebx
801030b1:	0f 84 93 00 00 00    	je     8010314a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801030b7:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801030bb:	74 12                	je     801030cf <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030bd:	ba 22 00 00 00       	mov    $0x22,%edx
801030c2:	b8 70 00 00 00       	mov    $0x70,%eax
801030c7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030c8:	b2 23                	mov    $0x23,%dl
801030ca:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801030cb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ce:	ee                   	out    %al,(%dx)
  }
}
801030cf:	83 c4 1c             	add    $0x1c,%esp
801030d2:	5b                   	pop    %ebx
801030d3:	5e                   	pop    %esi
801030d4:	5f                   	pop    %edi
801030d5:	5d                   	pop    %ebp
801030d6:	c3                   	ret    
801030d7:	90                   	nop
      if(ncpu < NCPU) {
801030d8:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801030de:	83 fe 07             	cmp    $0x7,%esi
801030e1:	7f 17                	jg     801030fa <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030e3:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030e7:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
801030ed:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030f4:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
      p += sizeof(struct mpproc);
801030fa:	83 c0 14             	add    $0x14,%eax
      continue;
801030fd:	eb 91                	jmp    80103090 <mpinit+0xf0>
801030ff:	90                   	nop
      ioapicid = ioapic->apicno;
80103100:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103104:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103107:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
8010310d:	eb 81                	jmp    80103090 <mpinit+0xf0>
8010310f:	90                   	nop
      ismp = 0;
80103110:	31 db                	xor    %ebx,%ebx
80103112:	eb 83                	jmp    80103097 <mpinit+0xf7>
  return mpsearch1(0xF0000, 0x10000);
80103114:	ba 00 00 01 00       	mov    $0x10000,%edx
80103119:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010311e:	e8 0d fe ff ff       	call   80102f30 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103123:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103125:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103127:	0f 85 c5 fe ff ff    	jne    80102ff2 <mpinit+0x52>
    panic("Expect to run on an SMP");
8010312d:	c7 04 24 82 77 10 80 	movl   $0x80107782,(%esp)
80103134:	e8 27 d2 ff ff       	call   80100360 <panic>
80103139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(conf->version != 1 && conf->version != 4)
80103140:	3c 01                	cmp    $0x1,%al
80103142:	0f 84 ed fe ff ff    	je     80103035 <mpinit+0x95>
80103148:	eb e3                	jmp    8010312d <mpinit+0x18d>
    panic("Didn't find a suitable machine");
8010314a:	c7 04 24 9c 77 10 80 	movl   $0x8010779c,(%esp)
80103151:	e8 0a d2 ff ff       	call   80100360 <panic>
80103156:	66 90                	xchg   %ax,%ax
80103158:	66 90                	xchg   %ax,%ax
8010315a:	66 90                	xchg   %ax,%ax
8010315c:	66 90                	xchg   %ax,%ax
8010315e:	66 90                	xchg   %ax,%ax

80103160 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103160:	55                   	push   %ebp
80103161:	ba 21 00 00 00       	mov    $0x21,%edx
80103166:	89 e5                	mov    %esp,%ebp
80103168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010316d:	ee                   	out    %al,(%dx)
8010316e:	b2 a1                	mov    $0xa1,%dl
80103170:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103171:	5d                   	pop    %ebp
80103172:	c3                   	ret    
80103173:	66 90                	xchg   %ax,%ax
80103175:	66 90                	xchg   %ax,%ax
80103177:	66 90                	xchg   %ax,%ax
80103179:	66 90                	xchg   %ax,%ax
8010317b:	66 90                	xchg   %ax,%ax
8010317d:	66 90                	xchg   %ax,%ax
8010317f:	90                   	nop

80103180 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	57                   	push   %edi
80103184:	56                   	push   %esi
80103185:	53                   	push   %ebx
80103186:	83 ec 1c             	sub    $0x1c,%esp
80103189:	8b 75 08             	mov    0x8(%ebp),%esi
8010318c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010318f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103195:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010319b:	e8 e0 db ff ff       	call   80100d80 <filealloc>
801031a0:	85 c0                	test   %eax,%eax
801031a2:	89 06                	mov    %eax,(%esi)
801031a4:	0f 84 a4 00 00 00    	je     8010324e <pipealloc+0xce>
801031aa:	e8 d1 db ff ff       	call   80100d80 <filealloc>
801031af:	85 c0                	test   %eax,%eax
801031b1:	89 03                	mov    %eax,(%ebx)
801031b3:	0f 84 87 00 00 00    	je     80103240 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801031b9:	e8 f2 f2 ff ff       	call   801024b0 <kalloc>
801031be:	85 c0                	test   %eax,%eax
801031c0:	89 c7                	mov    %eax,%edi
801031c2:	74 7c                	je     80103240 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801031c4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801031cb:	00 00 00 
  p->writeopen = 1;
801031ce:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801031d5:	00 00 00 
  p->nwrite = 0;
801031d8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801031df:	00 00 00 
  p->nread = 0;
801031e2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801031e9:	00 00 00 
  initlock(&p->lock, "pipe");
801031ec:	89 04 24             	mov    %eax,(%esp)
801031ef:	c7 44 24 04 d0 77 10 	movl   $0x801077d0,0x4(%esp)
801031f6:	80 
801031f7:	e8 84 13 00 00       	call   80104580 <initlock>
  (*f0)->type = FD_PIPE;
801031fc:	8b 06                	mov    (%esi),%eax
801031fe:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103204:	8b 06                	mov    (%esi),%eax
80103206:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010320a:	8b 06                	mov    (%esi),%eax
8010320c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103210:	8b 06                	mov    (%esi),%eax
80103212:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103215:	8b 03                	mov    (%ebx),%eax
80103217:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010321d:	8b 03                	mov    (%ebx),%eax
8010321f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103223:	8b 03                	mov    (%ebx),%eax
80103225:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103229:	8b 03                	mov    (%ebx),%eax
  return 0;
8010322b:	31 db                	xor    %ebx,%ebx
  (*f1)->pipe = p;
8010322d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103230:	83 c4 1c             	add    $0x1c,%esp
80103233:	89 d8                	mov    %ebx,%eax
80103235:	5b                   	pop    %ebx
80103236:	5e                   	pop    %esi
80103237:	5f                   	pop    %edi
80103238:	5d                   	pop    %ebp
80103239:	c3                   	ret    
8010323a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(*f0)
80103240:	8b 06                	mov    (%esi),%eax
80103242:	85 c0                	test   %eax,%eax
80103244:	74 08                	je     8010324e <pipealloc+0xce>
    fileclose(*f0);
80103246:	89 04 24             	mov    %eax,(%esp)
80103249:	e8 f2 db ff ff       	call   80100e40 <fileclose>
  if(*f1)
8010324e:	8b 03                	mov    (%ebx),%eax
  return -1;
80103250:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if(*f1)
80103255:	85 c0                	test   %eax,%eax
80103257:	74 d7                	je     80103230 <pipealloc+0xb0>
    fileclose(*f1);
80103259:	89 04 24             	mov    %eax,(%esp)
8010325c:	e8 df db ff ff       	call   80100e40 <fileclose>
}
80103261:	83 c4 1c             	add    $0x1c,%esp
80103264:	89 d8                	mov    %ebx,%eax
80103266:	5b                   	pop    %ebx
80103267:	5e                   	pop    %esi
80103268:	5f                   	pop    %edi
80103269:	5d                   	pop    %ebp
8010326a:	c3                   	ret    
8010326b:	90                   	nop
8010326c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103270 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	56                   	push   %esi
80103274:	53                   	push   %ebx
80103275:	83 ec 10             	sub    $0x10,%esp
80103278:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010327b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010327e:	89 1c 24             	mov    %ebx,(%esp)
80103281:	e8 6a 14 00 00       	call   801046f0 <acquire>
  if(writable){
80103286:	85 f6                	test   %esi,%esi
80103288:	74 3e                	je     801032c8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010328a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103290:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103297:	00 00 00 
    wakeup(&p->nread);
8010329a:	89 04 24             	mov    %eax,(%esp)
8010329d:	e8 ee 0f 00 00       	call   80104290 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801032a2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801032a8:	85 d2                	test   %edx,%edx
801032aa:	75 0a                	jne    801032b6 <pipeclose+0x46>
801032ac:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 32                	je     801032e8 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032b9:	83 c4 10             	add    $0x10,%esp
801032bc:	5b                   	pop    %ebx
801032bd:	5e                   	pop    %esi
801032be:	5d                   	pop    %ebp
    release(&p->lock);
801032bf:	e9 9c 14 00 00       	jmp    80104760 <release>
801032c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801032c8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801032ce:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032d5:	00 00 00 
    wakeup(&p->nwrite);
801032d8:	89 04 24             	mov    %eax,(%esp)
801032db:	e8 b0 0f 00 00       	call   80104290 <wakeup>
801032e0:	eb c0                	jmp    801032a2 <pipeclose+0x32>
801032e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&p->lock);
801032e8:	89 1c 24             	mov    %ebx,(%esp)
801032eb:	e8 70 14 00 00       	call   80104760 <release>
    kfree((char*)p);
801032f0:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032f3:	83 c4 10             	add    $0x10,%esp
801032f6:	5b                   	pop    %ebx
801032f7:	5e                   	pop    %esi
801032f8:	5d                   	pop    %ebp
    kfree((char*)p);
801032f9:	e9 02 f0 ff ff       	jmp    80102300 <kfree>
801032fe:	66 90                	xchg   %ax,%ax

80103300 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	57                   	push   %edi
80103304:	56                   	push   %esi
80103305:	53                   	push   %ebx
80103306:	83 ec 1c             	sub    $0x1c,%esp
80103309:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010330c:	89 1c 24             	mov    %ebx,(%esp)
8010330f:	e8 dc 13 00 00       	call   801046f0 <acquire>
  for(i = 0; i < n; i++){
80103314:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103317:	85 c9                	test   %ecx,%ecx
80103319:	0f 8e b2 00 00 00    	jle    801033d1 <pipewrite+0xd1>
8010331f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103322:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103328:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010332e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103334:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103337:	03 4d 10             	add    0x10(%ebp),%ecx
8010333a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010333d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103343:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103349:	39 c8                	cmp    %ecx,%eax
8010334b:	74 38                	je     80103385 <pipewrite+0x85>
8010334d:	eb 55                	jmp    801033a4 <pipewrite+0xa4>
8010334f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103350:	e8 8b 03 00 00       	call   801036e0 <myproc>
80103355:	8b 40 28             	mov    0x28(%eax),%eax
80103358:	85 c0                	test   %eax,%eax
8010335a:	75 33                	jne    8010338f <pipewrite+0x8f>
      wakeup(&p->nread);
8010335c:	89 3c 24             	mov    %edi,(%esp)
8010335f:	e8 2c 0f 00 00       	call   80104290 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103364:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103368:	89 34 24             	mov    %esi,(%esp)
8010336b:	e8 90 0b 00 00       	call   80103f00 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103370:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103376:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010337c:	05 00 02 00 00       	add    $0x200,%eax
80103381:	39 c2                	cmp    %eax,%edx
80103383:	75 23                	jne    801033a8 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80103385:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010338b:	85 d2                	test   %edx,%edx
8010338d:	75 c1                	jne    80103350 <pipewrite+0x50>
        release(&p->lock);
8010338f:	89 1c 24             	mov    %ebx,(%esp)
80103392:	e8 c9 13 00 00       	call   80104760 <release>
        return -1;
80103397:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010339c:	83 c4 1c             	add    $0x1c,%esp
8010339f:	5b                   	pop    %ebx
801033a0:	5e                   	pop    %esi
801033a1:	5f                   	pop    %edi
801033a2:	5d                   	pop    %ebp
801033a3:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033a4:	89 c2                	mov    %eax,%edx
801033a6:	66 90                	xchg   %ax,%ax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801033a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033ab:	8d 42 01             	lea    0x1(%edx),%eax
801033ae:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801033b4:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801033ba:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801033be:	0f b6 09             	movzbl (%ecx),%ecx
801033c1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801033c5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033c8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801033cb:	0f 85 6c ff ff ff    	jne    8010333d <pipewrite+0x3d>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801033d1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033d7:	89 04 24             	mov    %eax,(%esp)
801033da:	e8 b1 0e 00 00       	call   80104290 <wakeup>
  release(&p->lock);
801033df:	89 1c 24             	mov    %ebx,(%esp)
801033e2:	e8 79 13 00 00       	call   80104760 <release>
  return n;
801033e7:	8b 45 10             	mov    0x10(%ebp),%eax
801033ea:	eb b0                	jmp    8010339c <pipewrite+0x9c>
801033ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 1c             	sub    $0x1c,%esp
801033f9:	8b 75 08             	mov    0x8(%ebp),%esi
801033fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801033ff:	89 34 24             	mov    %esi,(%esp)
80103402:	e8 e9 12 00 00       	call   801046f0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103407:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010340d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103413:	75 5b                	jne    80103470 <piperead+0x80>
80103415:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010341b:	85 db                	test   %ebx,%ebx
8010341d:	74 51                	je     80103470 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010341f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103425:	eb 25                	jmp    8010344c <piperead+0x5c>
80103427:	90                   	nop
80103428:	89 74 24 04          	mov    %esi,0x4(%esp)
8010342c:	89 1c 24             	mov    %ebx,(%esp)
8010342f:	e8 cc 0a 00 00       	call   80103f00 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103434:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010343a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103440:	75 2e                	jne    80103470 <piperead+0x80>
80103442:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103448:	85 d2                	test   %edx,%edx
8010344a:	74 24                	je     80103470 <piperead+0x80>
    if(myproc()->killed){
8010344c:	e8 8f 02 00 00       	call   801036e0 <myproc>
80103451:	8b 48 28             	mov    0x28(%eax),%ecx
80103454:	85 c9                	test   %ecx,%ecx
80103456:	74 d0                	je     80103428 <piperead+0x38>
      release(&p->lock);
80103458:	89 34 24             	mov    %esi,(%esp)
8010345b:	e8 00 13 00 00       	call   80104760 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103460:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80103463:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103468:	5b                   	pop    %ebx
80103469:	5e                   	pop    %esi
8010346a:	5f                   	pop    %edi
8010346b:	5d                   	pop    %ebp
8010346c:	c3                   	ret    
8010346d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103470:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103473:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103475:	85 d2                	test   %edx,%edx
80103477:	7f 2b                	jg     801034a4 <piperead+0xb4>
80103479:	eb 31                	jmp    801034ac <piperead+0xbc>
8010347b:	90                   	nop
8010347c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103480:	8d 48 01             	lea    0x1(%eax),%ecx
80103483:	25 ff 01 00 00       	and    $0x1ff,%eax
80103488:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010348e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103493:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103496:	83 c3 01             	add    $0x1,%ebx
80103499:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010349c:	74 0e                	je     801034ac <piperead+0xbc>
    if(p->nread == p->nwrite)
8010349e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801034a4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801034aa:	75 d4                	jne    80103480 <piperead+0x90>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801034ac:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801034b2:	89 04 24             	mov    %eax,(%esp)
801034b5:	e8 d6 0d 00 00       	call   80104290 <wakeup>
  release(&p->lock);
801034ba:	89 34 24             	mov    %esi,(%esp)
801034bd:	e8 9e 12 00 00       	call   80104760 <release>
}
801034c2:	83 c4 1c             	add    $0x1c,%esp
  return i;
801034c5:	89 d8                	mov    %ebx,%eax
}
801034c7:	5b                   	pop    %ebx
801034c8:	5e                   	pop    %esi
801034c9:	5f                   	pop    %edi
801034ca:	5d                   	pop    %ebp
801034cb:	c3                   	ret    
801034cc:	66 90                	xchg   %ax,%ax
801034ce:	66 90                	xchg   %ax,%ax

801034d0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034d0:	55                   	push   %ebp
801034d1:	89 e5                	mov    %esp,%ebp
801034d3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034d4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801034d9:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801034dc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034e3:	e8 08 12 00 00       	call   801046f0 <acquire>
801034e8:	eb 18                	jmp    80103502 <allocproc+0x32>
801034ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034f0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801034f6:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
801034fc:	0f 84 a6 00 00 00    	je     801035a8 <allocproc+0xd8>
    if(p->state == UNUSED)
80103502:	8b 43 10             	mov    0x10(%ebx),%eax
80103505:	85 c0                	test   %eax,%eax
80103507:	75 e7                	jne    801034f0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103509:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  p->prior_val = 15; //cs153_lab2: initialize process' priority value to 15 (middle priority)
  p->turnTime = 0; //cs153_lab2: initialize process' turn time to zero
  p->waitTime = 0; //cs153_lab2: initialize process' wait time to zero
  p->burstTime = 0; //cs153_lab2: initialize process' burst time to zero

  release(&ptable.lock);
8010350e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  p->state = EMBRYO;
80103515:	c7 43 10 01 00 00 00 	movl   $0x1,0x10(%ebx)
  p->prior_val = 15; //cs153_lab2: initialize process' priority value to 15 (middle priority)
8010351c:	c7 83 80 00 00 00 0f 	movl   $0xf,0x80(%ebx)
80103523:	00 00 00 
  p->pid = nextpid++;
80103526:	8d 50 01             	lea    0x1(%eax),%edx
80103529:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010352f:	89 43 14             	mov    %eax,0x14(%ebx)
  p->turnTime = 0; //cs153_lab2: initialize process' turn time to zero
80103532:	c7 83 88 00 00 00 00 	movl   $0x0,0x88(%ebx)
80103539:	00 00 00 
  p->waitTime = 0; //cs153_lab2: initialize process' wait time to zero
8010353c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
80103543:	00 00 00 
  p->burstTime = 0; //cs153_lab2: initialize process' burst time to zero
80103546:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
8010354d:	00 00 00 
  release(&ptable.lock);
80103550:	e8 0b 12 00 00       	call   80104760 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103555:	e8 56 ef ff ff       	call   801024b0 <kalloc>
8010355a:	85 c0                	test   %eax,%eax
8010355c:	89 43 0c             	mov    %eax,0xc(%ebx)
8010355f:	74 5b                	je     801035bc <allocproc+0xec>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103561:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103567:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010356c:	89 53 1c             	mov    %edx,0x1c(%ebx)
  *(uint*)sp = (uint)trapret;
8010356f:	c7 40 14 61 5a 10 80 	movl   $0x80105a61,0x14(%eax)
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103576:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010357d:	00 
8010357e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103585:	00 
80103586:	89 04 24             	mov    %eax,(%esp)
  p->context = (struct context*)sp;
80103589:	89 43 20             	mov    %eax,0x20(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010358c:	e8 1f 12 00 00       	call   801047b0 <memset>
  p->context->eip = (uint)forkret;
80103591:	8b 43 20             	mov    0x20(%ebx),%eax
80103594:	c7 40 10 d0 35 10 80 	movl   $0x801035d0,0x10(%eax)

  return p;
8010359b:	89 d8                	mov    %ebx,%eax
}
8010359d:	83 c4 14             	add    $0x14,%esp
801035a0:	5b                   	pop    %ebx
801035a1:	5d                   	pop    %ebp
801035a2:	c3                   	ret    
801035a3:	90                   	nop
801035a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801035a8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035af:	e8 ac 11 00 00       	call   80104760 <release>
}
801035b4:	83 c4 14             	add    $0x14,%esp
  return 0;
801035b7:	31 c0                	xor    %eax,%eax
}
801035b9:	5b                   	pop    %ebx
801035ba:	5d                   	pop    %ebp
801035bb:	c3                   	ret    
    p->state = UNUSED;
801035bc:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
    return 0;
801035c3:	eb d8                	jmp    8010359d <allocproc+0xcd>
801035c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035d0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801035d6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035dd:	e8 7e 11 00 00       	call   80104760 <release>

  if (first) {
801035e2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801035e7:	85 c0                	test   %eax,%eax
801035e9:	75 05                	jne    801035f0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035eb:	c9                   	leave  
801035ec:	c3                   	ret    
801035ed:	8d 76 00             	lea    0x0(%esi),%esi
    iinit(ROOTDEV);
801035f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    first = 0;
801035f7:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801035fe:	00 00 00 
    iinit(ROOTDEV);
80103601:	e8 7a de ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
80103606:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010360d:	e8 6e f4 ff ff       	call   80102a80 <initlog>
}
80103612:	c9                   	leave  
80103613:	c3                   	ret    
80103614:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010361a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103620 <pinit>:
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103626:	c7 44 24 04 d5 77 10 	movl   $0x801077d5,0x4(%esp)
8010362d:	80 
8010362e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103635:	e8 46 0f 00 00       	call   80104580 <initlock>
}
8010363a:	c9                   	leave  
8010363b:	c3                   	ret    
8010363c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103640 <mycpu>:
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	56                   	push   %esi
80103644:	53                   	push   %ebx
80103645:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103648:	9c                   	pushf  
80103649:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010364a:	f6 c4 02             	test   $0x2,%ah
8010364d:	75 57                	jne    801036a6 <mycpu+0x66>
  apicid = lapicid();
8010364f:	e8 1c f1 ff ff       	call   80102770 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103654:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010365a:	85 f6                	test   %esi,%esi
8010365c:	7e 3c                	jle    8010369a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010365e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103665:	39 c2                	cmp    %eax,%edx
80103667:	74 2d                	je     80103696 <mycpu+0x56>
80103669:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010366e:	31 d2                	xor    %edx,%edx
80103670:	83 c2 01             	add    $0x1,%edx
80103673:	39 f2                	cmp    %esi,%edx
80103675:	74 23                	je     8010369a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103677:	0f b6 19             	movzbl (%ecx),%ebx
8010367a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103680:	39 c3                	cmp    %eax,%ebx
80103682:	75 ec                	jne    80103670 <mycpu+0x30>
      return &cpus[i];
80103684:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
}
8010368a:	83 c4 10             	add    $0x10,%esp
8010368d:	5b                   	pop    %ebx
8010368e:	5e                   	pop    %esi
8010368f:	5d                   	pop    %ebp
      return &cpus[i];
80103690:	05 80 27 11 80       	add    $0x80112780,%eax
}
80103695:	c3                   	ret    
  for (i = 0; i < ncpu; ++i) {
80103696:	31 d2                	xor    %edx,%edx
80103698:	eb ea                	jmp    80103684 <mycpu+0x44>
  panic("unknown apicid\n");
8010369a:	c7 04 24 dc 77 10 80 	movl   $0x801077dc,(%esp)
801036a1:	e8 ba cc ff ff       	call   80100360 <panic>
    panic("mycpu called with interrupts enabled\n");
801036a6:	c7 04 24 10 79 10 80 	movl   $0x80107910,(%esp)
801036ad:	e8 ae cc ff ff       	call   80100360 <panic>
801036b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036c0 <cpuid>:
cpuid() {
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801036c6:	e8 75 ff ff ff       	call   80103640 <mycpu>
}
801036cb:	c9                   	leave  
  return mycpu()-cpus;
801036cc:	2d 80 27 11 80       	sub    $0x80112780,%eax
801036d1:	c1 f8 04             	sar    $0x4,%eax
801036d4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801036da:	c3                   	ret    
801036db:	90                   	nop
801036dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036e0 <myproc>:
myproc(void) {
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	53                   	push   %ebx
801036e4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801036e7:	e8 14 0f 00 00       	call   80104600 <pushcli>
  c = mycpu();
801036ec:	e8 4f ff ff ff       	call   80103640 <mycpu>
  p = c->proc;
801036f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036f7:	e8 44 0f 00 00       	call   80104640 <popcli>
}
801036fc:	83 c4 04             	add    $0x4,%esp
801036ff:	89 d8                	mov    %ebx,%eax
80103701:	5b                   	pop    %ebx
80103702:	5d                   	pop    %ebp
80103703:	c3                   	ret    
80103704:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010370a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103710 <userinit>:
{
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	53                   	push   %ebx
80103714:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
80103717:	e8 b4 fd ff ff       	call   801034d0 <allocproc>
8010371c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010371e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103723:	e8 a8 38 00 00       	call   80106fd0 <setupkvm>
80103728:	85 c0                	test   %eax,%eax
8010372a:	89 43 08             	mov    %eax,0x8(%ebx)
8010372d:	0f 84 d5 00 00 00    	je     80103808 <userinit+0xf8>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103733:	89 04 24             	mov    %eax,(%esp)
80103736:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010373d:	00 
8010373e:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103745:	80 
80103746:	e8 b5 35 00 00       	call   80106d00 <inituvm>
  p->sz = PGSIZE;
8010374b:	c7 43 04 00 10 00 00 	movl   $0x1000,0x4(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103752:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103759:	00 
8010375a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103761:	00 
80103762:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103765:	89 04 24             	mov    %eax,(%esp)
80103768:	e8 43 10 00 00       	call   801047b0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010376d:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103770:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103775:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010377a:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010377e:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103781:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103785:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103788:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010378c:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103790:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103793:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103797:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010379b:	8b 43 1c             	mov    0x1c(%ebx),%eax
8010379e:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801037a5:	8b 43 1c             	mov    0x1c(%ebx),%eax
801037a8:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801037af:	8b 43 1c             	mov    0x1c(%ebx),%eax
801037b2:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801037b9:	8d 43 70             	lea    0x70(%ebx),%eax
801037bc:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801037c3:	00 
801037c4:	c7 44 24 04 05 78 10 	movl   $0x80107805,0x4(%esp)
801037cb:	80 
801037cc:	89 04 24             	mov    %eax,(%esp)
801037cf:	e8 bc 11 00 00       	call   80104990 <safestrcpy>
  p->cwd = namei("/");
801037d4:	c7 04 24 0e 78 10 80 	movl   $0x8010780e,(%esp)
801037db:	e8 30 e7 ff ff       	call   80101f10 <namei>
801037e0:	89 43 6c             	mov    %eax,0x6c(%ebx)
  acquire(&ptable.lock);
801037e3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037ea:	e8 01 0f 00 00       	call   801046f0 <acquire>
  p->state = RUNNABLE;
801037ef:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  release(&ptable.lock);
801037f6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037fd:	e8 5e 0f 00 00       	call   80104760 <release>
}
80103802:	83 c4 14             	add    $0x14,%esp
80103805:	5b                   	pop    %ebx
80103806:	5d                   	pop    %ebp
80103807:	c3                   	ret    
    panic("userinit: out of memory?");
80103808:	c7 04 24 ec 77 10 80 	movl   $0x801077ec,(%esp)
8010380f:	e8 4c cb ff ff       	call   80100360 <panic>
80103814:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010381a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103820 <growproc>:
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	56                   	push   %esi
80103824:	53                   	push   %ebx
80103825:	83 ec 10             	sub    $0x10,%esp
80103828:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
8010382b:	e8 b0 fe ff ff       	call   801036e0 <myproc>
  if(n > 0){
80103830:	83 fe 00             	cmp    $0x0,%esi
  struct proc *curproc = myproc();
80103833:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103835:	8b 40 04             	mov    0x4(%eax),%eax
  if(n > 0){
80103838:	7e 2e                	jle    80103868 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010383a:	01 c6                	add    %eax,%esi
8010383c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103840:	89 44 24 04          	mov    %eax,0x4(%esp)
80103844:	8b 43 08             	mov    0x8(%ebx),%eax
80103847:	89 04 24             	mov    %eax,(%esp)
8010384a:	e8 f1 35 00 00       	call   80106e40 <allocuvm>
8010384f:	85 c0                	test   %eax,%eax
80103851:	74 35                	je     80103888 <growproc+0x68>
  curproc->sz = sz;
80103853:	89 43 04             	mov    %eax,0x4(%ebx)
  switchuvm(curproc);
80103856:	89 1c 24             	mov    %ebx,(%esp)
80103859:	e8 92 33 00 00       	call   80106bf0 <switchuvm>
  return 0;
8010385e:	31 c0                	xor    %eax,%eax
}
80103860:	83 c4 10             	add    $0x10,%esp
80103863:	5b                   	pop    %ebx
80103864:	5e                   	pop    %esi
80103865:	5d                   	pop    %ebp
80103866:	c3                   	ret    
80103867:	90                   	nop
  } else if(n < 0){
80103868:	74 e9                	je     80103853 <growproc+0x33>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010386a:	01 c6                	add    %eax,%esi
8010386c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103870:	89 44 24 04          	mov    %eax,0x4(%esp)
80103874:	8b 43 08             	mov    0x8(%ebx),%eax
80103877:	89 04 24             	mov    %eax,(%esp)
8010387a:	e8 b1 36 00 00       	call   80106f30 <deallocuvm>
8010387f:	85 c0                	test   %eax,%eax
80103881:	75 d0                	jne    80103853 <growproc+0x33>
80103883:	90                   	nop
80103884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80103888:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010388d:	eb d1                	jmp    80103860 <growproc+0x40>
8010388f:	90                   	nop

80103890 <fork>:
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	57                   	push   %edi
80103894:	56                   	push   %esi
80103895:	53                   	push   %ebx
80103896:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103899:	e8 42 fe ff ff       	call   801036e0 <myproc>
8010389e:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
801038a0:	e8 2b fc ff ff       	call   801034d0 <allocproc>
801038a5:	85 c0                	test   %eax,%eax
801038a7:	89 c7                	mov    %eax,%edi
801038a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038ac:	0f 84 c4 00 00 00    	je     80103976 <fork+0xe6>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801038b2:	8b 43 04             	mov    0x4(%ebx),%eax
801038b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801038b9:	8b 43 08             	mov    0x8(%ebx),%eax
801038bc:	89 04 24             	mov    %eax,(%esp)
801038bf:	e8 ec 37 00 00       	call   801070b0 <copyuvm>
801038c4:	85 c0                	test   %eax,%eax
801038c6:	89 47 08             	mov    %eax,0x8(%edi)
801038c9:	0f 84 ae 00 00 00    	je     8010397d <fork+0xed>
  np->sz = curproc->sz;
801038cf:	8b 43 04             	mov    0x4(%ebx),%eax
  *np->tf = *curproc->tf;
801038d2:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
801038d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038da:	89 42 04             	mov    %eax,0x4(%edx)
  *np->tf = *curproc->tf;
801038dd:	8b 7a 1c             	mov    0x1c(%edx),%edi
  np->parent = curproc;
801038e0:	89 5a 18             	mov    %ebx,0x18(%edx)
  *np->tf = *curproc->tf;
801038e3:	8b 73 1c             	mov    0x1c(%ebx),%esi
801038e6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801038e8:	31 f6                	xor    %esi,%esi
  np->prior_val = curproc->prior_val; //cs153_lab2: not parent (child) inherits parent's (current process) priority value
801038ea:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
801038f0:	89 82 80 00 00 00    	mov    %eax,0x80(%edx)
  np->tf->eax = 0;
801038f6:	8b 42 1c             	mov    0x1c(%edx),%eax
801038f9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103900:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103904:	85 c0                	test   %eax,%eax
80103906:	74 0f                	je     80103917 <fork+0x87>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103908:	89 04 24             	mov    %eax,(%esp)
8010390b:	e8 e0 d4 ff ff       	call   80100df0 <filedup>
80103910:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103913:	89 44 b2 2c          	mov    %eax,0x2c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103917:	83 c6 01             	add    $0x1,%esi
8010391a:	83 fe 10             	cmp    $0x10,%esi
8010391d:	75 e1                	jne    80103900 <fork+0x70>
  np->cwd = idup(curproc->cwd);
8010391f:	8b 43 6c             	mov    0x6c(%ebx),%eax
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103922:	83 c3 70             	add    $0x70,%ebx
  np->cwd = idup(curproc->cwd);
80103925:	89 04 24             	mov    %eax,(%esp)
80103928:	e8 63 dd ff ff       	call   80101690 <idup>
8010392d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103930:	89 47 6c             	mov    %eax,0x6c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103933:	8d 47 70             	lea    0x70(%edi),%eax
80103936:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010393a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103941:	00 
80103942:	89 04 24             	mov    %eax,(%esp)
80103945:	e8 46 10 00 00       	call   80104990 <safestrcpy>
  pid = np->pid;
8010394a:	8b 5f 14             	mov    0x14(%edi),%ebx
  acquire(&ptable.lock);
8010394d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103954:	e8 97 0d 00 00       	call   801046f0 <acquire>
  np->state = RUNNABLE;
80103959:	c7 47 10 03 00 00 00 	movl   $0x3,0x10(%edi)
  release(&ptable.lock);
80103960:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103967:	e8 f4 0d 00 00       	call   80104760 <release>
  return pid;
8010396c:	89 d8                	mov    %ebx,%eax
}
8010396e:	83 c4 1c             	add    $0x1c,%esp
80103971:	5b                   	pop    %ebx
80103972:	5e                   	pop    %esi
80103973:	5f                   	pop    %edi
80103974:	5d                   	pop    %ebp
80103975:	c3                   	ret    
    return -1;
80103976:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010397b:	eb f1                	jmp    8010396e <fork+0xde>
    kfree(np->kstack);
8010397d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103980:	8b 47 0c             	mov    0xc(%edi),%eax
80103983:	89 04 24             	mov    %eax,(%esp)
80103986:	e8 75 e9 ff ff       	call   80102300 <kfree>
    return -1;
8010398b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    np->kstack = 0;
80103990:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    np->state = UNUSED;
80103997:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
    return -1;
8010399e:	eb ce                	jmp    8010396e <fork+0xde>

801039a0 <getPrior>:
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	83 ec 08             	sub    $0x8,%esp
    return myproc()->prior_val;
801039a6:	e8 35 fd ff ff       	call   801036e0 <myproc>
801039ab:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
801039b1:	c9                   	leave  
801039b2:	c3                   	ret    
801039b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039c0 <getWaitTime>:
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	83 ec 08             	sub    $0x8,%esp
    return myproc()->waitTime;
801039c6:	e8 15 fd ff ff       	call   801036e0 <myproc>
801039cb:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
801039d1:	c9                   	leave  
801039d2:	c3                   	ret    
801039d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039e0 <getTurnTime>:
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	83 ec 08             	sub    $0x8,%esp
    return myproc()->turnTime;
801039e6:	e8 f5 fc ff ff       	call   801036e0 <myproc>
801039eb:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
}
801039f1:	c9                   	leave  
801039f2:	c3                   	ret    
801039f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a00 <scheduler>:
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	57                   	push   %edi
80103a04:	56                   	push   %esi
80103a05:	53                   	push   %ebx
80103a06:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103a09:	e8 32 fc ff ff       	call   80103640 <mycpu>
  c->proc = 0;
80103a0e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103a15:	00 00 00 
  struct cpu *c = mycpu();
80103a18:	89 c3                	mov    %eax,%ebx
80103a1a:	8d 40 04             	lea    0x4(%eax),%eax
80103a1d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  asm volatile("sti");
80103a20:	fb                   	sti    
    acquire(&ptable.lock);
80103a21:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a28:	be 54 2d 11 80       	mov    $0x80112d54,%esi
    acquire(&ptable.lock);
80103a2d:	e8 be 0c 00 00       	call   801046f0 <acquire>
80103a32:	eb 16                	jmp    80103a4a <scheduler+0x4a>
80103a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a38:	81 c6 90 00 00 00    	add    $0x90,%esi
80103a3e:	81 fe 54 51 11 80    	cmp    $0x80115154,%esi
80103a44:	0f 84 a6 00 00 00    	je     80103af0 <scheduler+0xf0>
      if (p->state != RUNNABLE)
80103a4a:	83 7e 10 03          	cmpl   $0x3,0x10(%esi)
80103a4e:	75 e8                	jne    80103a38 <scheduler+0x38>
80103a50:	89 f7                	mov    %esi,%edi
80103a52:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103a57:	eb 15                	jmp    80103a6e <scheduler+0x6e>
80103a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      for (tempProc = ptable.proc; tempProc < &ptable.proc[NPROC]; tempProc++)
80103a60:	81 c2 90 00 00 00    	add    $0x90,%edx
80103a66:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
80103a6c:	74 23                	je     80103a91 <scheduler+0x91>
        if (tempProc->state != RUNNABLE)
80103a6e:	83 7a 10 03          	cmpl   $0x3,0x10(%edx)
80103a72:	75 ec                	jne    80103a60 <scheduler+0x60>
80103a74:	8b 87 80 00 00 00    	mov    0x80(%edi),%eax
80103a7a:	39 82 80 00 00 00    	cmp    %eax,0x80(%edx)
80103a80:	0f 4c fa             	cmovl  %edx,%edi
      for (tempProc = ptable.proc; tempProc < &ptable.proc[NPROC]; tempProc++)
80103a83:	81 c2 90 00 00 00    	add    $0x90,%edx
80103a89:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
80103a8f:	75 dd                	jne    80103a6e <scheduler+0x6e>
      c->proc = highestPriority_proc; //cs153_lab2: set cpu process to the highest priority process
80103a91:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a97:	81 c6 90 00 00 00    	add    $0x90,%esi
      switchuvm(highestPriority_proc); //cs153_lab2: switch to the highest priority process (load said process to the user)
80103a9d:	89 3c 24             	mov    %edi,(%esp)
80103aa0:	e8 4b 31 00 00       	call   80106bf0 <switchuvm>
      swtch(&(c->scheduler), highestPriority_proc->context); //context switch to the highest priority process
80103aa5:	8b 57 20             	mov    0x20(%edi),%edx
80103aa8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      burstTime = ticks; //cs153_lab2: get # of ticks before swtch() to get time before execution
80103aab:	a1 a0 59 11 80       	mov    0x801159a0,%eax
      highestPriority_proc->state = RUNNING; //cs153_lab2: set the highest priority process' state to RUNNING
80103ab0:	c7 47 10 04 00 00 00 	movl   $0x4,0x10(%edi)
      swtch(&(c->scheduler), highestPriority_proc->context); //context switch to the highest priority process
80103ab7:	89 54 24 04          	mov    %edx,0x4(%esp)
80103abb:	89 0c 24             	mov    %ecx,(%esp)
      burstTime = ticks; //cs153_lab2: get # of ticks before swtch() to get time before execution
80103abe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      swtch(&(c->scheduler), highestPriority_proc->context); //context switch to the highest priority process
80103ac1:	e8 25 0f 00 00       	call   801049eb <swtch>
      switchkvm(); //the kernel loads its memory
80103ac6:	e8 05 31 00 00       	call   80106bd0 <switchkvm>
      burstTime = ticks - burstTime; //cs153_lab2: get # of ticks after swtch() to get time after execution for this time quantum
80103acb:	8b 15 a0 59 11 80    	mov    0x801159a0,%edx
80103ad1:	2b 55 e4             	sub    -0x1c(%ebp),%edx
      c->proc = 0;
80103ad4:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103adb:	00 00 00 
      highestPriority_proc->burstTime += burstTime; //cs153_lab2: add the execution time to the total bust time of the process for all time quanta
80103ade:	01 97 8c 00 00 00    	add    %edx,0x8c(%edi)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ae4:	81 fe 54 51 11 80    	cmp    $0x80115154,%esi
80103aea:	0f 85 5a ff ff ff    	jne    80103a4a <scheduler+0x4a>
    release(&ptable.lock);
80103af0:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103af7:	e8 64 0c 00 00       	call   80104760 <release>
  }
80103afc:	e9 1f ff ff ff       	jmp    80103a20 <scheduler+0x20>
80103b01:	eb 0d                	jmp    80103b10 <sched>
80103b03:	90                   	nop
80103b04:	90                   	nop
80103b05:	90                   	nop
80103b06:	90                   	nop
80103b07:	90                   	nop
80103b08:	90                   	nop
80103b09:	90                   	nop
80103b0a:	90                   	nop
80103b0b:	90                   	nop
80103b0c:	90                   	nop
80103b0d:	90                   	nop
80103b0e:	90                   	nop
80103b0f:	90                   	nop

80103b10 <sched>:
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	56                   	push   %esi
80103b14:	53                   	push   %ebx
80103b15:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = myproc();
80103b18:	e8 c3 fb ff ff       	call   801036e0 <myproc>
  if(!holding(&ptable.lock))
80103b1d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *p = myproc();
80103b24:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103b26:	e8 85 0b 00 00       	call   801046b0 <holding>
80103b2b:	85 c0                	test   %eax,%eax
80103b2d:	74 4f                	je     80103b7e <sched+0x6e>
  if(mycpu()->ncli != 1)
80103b2f:	e8 0c fb ff ff       	call   80103640 <mycpu>
80103b34:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103b3b:	75 65                	jne    80103ba2 <sched+0x92>
  if(p->state == RUNNING)
80103b3d:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
80103b41:	74 53                	je     80103b96 <sched+0x86>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b43:	9c                   	pushf  
80103b44:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b45:	f6 c4 02             	test   $0x2,%ah
80103b48:	75 40                	jne    80103b8a <sched+0x7a>
  intena = mycpu()->intena;
80103b4a:	e8 f1 fa ff ff       	call   80103640 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103b4f:	83 c3 20             	add    $0x20,%ebx
  intena = mycpu()->intena;
80103b52:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103b58:	e8 e3 fa ff ff       	call   80103640 <mycpu>
80103b5d:	8b 40 04             	mov    0x4(%eax),%eax
80103b60:	89 1c 24             	mov    %ebx,(%esp)
80103b63:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b67:	e8 7f 0e 00 00       	call   801049eb <swtch>
  mycpu()->intena = intena;
80103b6c:	e8 cf fa ff ff       	call   80103640 <mycpu>
80103b71:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103b77:	83 c4 10             	add    $0x10,%esp
80103b7a:	5b                   	pop    %ebx
80103b7b:	5e                   	pop    %esi
80103b7c:	5d                   	pop    %ebp
80103b7d:	c3                   	ret    
    panic("sched ptable.lock");
80103b7e:	c7 04 24 10 78 10 80 	movl   $0x80107810,(%esp)
80103b85:	e8 d6 c7 ff ff       	call   80100360 <panic>
    panic("sched interruptible");
80103b8a:	c7 04 24 3c 78 10 80 	movl   $0x8010783c,(%esp)
80103b91:	e8 ca c7 ff ff       	call   80100360 <panic>
    panic("sched running");
80103b96:	c7 04 24 2e 78 10 80 	movl   $0x8010782e,(%esp)
80103b9d:	e8 be c7 ff ff       	call   80100360 <panic>
    panic("sched locks");
80103ba2:	c7 04 24 22 78 10 80 	movl   $0x80107822,(%esp)
80103ba9:	e8 b2 c7 ff ff       	call   80100360 <panic>
80103bae:	66 90                	xchg   %ax,%ax

80103bb0 <exit>:
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	56                   	push   %esi
  if(curproc == initproc)
80103bb4:	31 f6                	xor    %esi,%esi
{
80103bb6:	53                   	push   %ebx
80103bb7:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103bba:	e8 21 fb ff ff       	call   801036e0 <myproc>
  if(curproc == initproc)
80103bbf:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
  struct proc *curproc = myproc();
80103bc5:	89 c3                	mov    %eax,%ebx
  if(curproc == initproc)
80103bc7:	0f 84 fd 00 00 00    	je     80103cca <exit+0x11a>
80103bcd:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103bd0:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103bd4:	85 c0                	test   %eax,%eax
80103bd6:	74 10                	je     80103be8 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103bd8:	89 04 24             	mov    %eax,(%esp)
80103bdb:	e8 60 d2 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103be0:	c7 44 b3 2c 00 00 00 	movl   $0x0,0x2c(%ebx,%esi,4)
80103be7:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103be8:	83 c6 01             	add    $0x1,%esi
80103beb:	83 fe 10             	cmp    $0x10,%esi
80103bee:	75 e0                	jne    80103bd0 <exit+0x20>
  begin_op();
80103bf0:	e8 2b ef ff ff       	call   80102b20 <begin_op>
  iput(curproc->cwd);
80103bf5:	8b 43 6c             	mov    0x6c(%ebx),%eax
80103bf8:	89 04 24             	mov    %eax,(%esp)
80103bfb:	e8 e0 db ff ff       	call   801017e0 <iput>
  end_op();
80103c00:	e8 8b ef ff ff       	call   80102b90 <end_op>
  curproc->cwd = 0;
80103c05:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
  acquire(&ptable.lock);
80103c0c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c13:	e8 d8 0a 00 00       	call   801046f0 <acquire>
  wakeup1(curproc->parent);
80103c18:	8b 43 18             	mov    0x18(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c1b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103c20:	eb 14                	jmp    80103c36 <exit+0x86>
80103c22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c28:	81 c2 90 00 00 00    	add    $0x90,%edx
80103c2e:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
80103c34:	74 20                	je     80103c56 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103c36:	83 7a 10 02          	cmpl   $0x2,0x10(%edx)
80103c3a:	75 ec                	jne    80103c28 <exit+0x78>
80103c3c:	3b 42 24             	cmp    0x24(%edx),%eax
80103c3f:	75 e7                	jne    80103c28 <exit+0x78>
      p->state = RUNNABLE;
80103c41:	c7 42 10 03 00 00 00 	movl   $0x3,0x10(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c48:	81 c2 90 00 00 00    	add    $0x90,%edx
80103c4e:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
80103c54:	75 e0                	jne    80103c36 <exit+0x86>
      p->parent = initproc;
80103c56:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103c5b:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103c60:	eb 14                	jmp    80103c76 <exit+0xc6>
80103c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c68:	81 c1 90 00 00 00    	add    $0x90,%ecx
80103c6e:	81 f9 54 51 11 80    	cmp    $0x80115154,%ecx
80103c74:	74 3c                	je     80103cb2 <exit+0x102>
    if(p->parent == curproc){
80103c76:	39 59 18             	cmp    %ebx,0x18(%ecx)
80103c79:	75 ed                	jne    80103c68 <exit+0xb8>
      if(p->state == ZOMBIE)
80103c7b:	83 79 10 05          	cmpl   $0x5,0x10(%ecx)
      p->parent = initproc;
80103c7f:	89 41 18             	mov    %eax,0x18(%ecx)
      if(p->state == ZOMBIE)
80103c82:	75 e4                	jne    80103c68 <exit+0xb8>
80103c84:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103c89:	eb 13                	jmp    80103c9e <exit+0xee>
80103c8b:	90                   	nop
80103c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c90:	81 c2 90 00 00 00    	add    $0x90,%edx
80103c96:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
80103c9c:	74 ca                	je     80103c68 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103c9e:	83 7a 10 02          	cmpl   $0x2,0x10(%edx)
80103ca2:	75 ec                	jne    80103c90 <exit+0xe0>
80103ca4:	3b 42 24             	cmp    0x24(%edx),%eax
80103ca7:	75 e7                	jne    80103c90 <exit+0xe0>
      p->state = RUNNABLE;
80103ca9:	c7 42 10 03 00 00 00 	movl   $0x3,0x10(%edx)
80103cb0:	eb de                	jmp    80103c90 <exit+0xe0>
  curproc->state = ZOMBIE;
80103cb2:	c7 43 10 05 00 00 00 	movl   $0x5,0x10(%ebx)
  sched();
80103cb9:	e8 52 fe ff ff       	call   80103b10 <sched>
  panic("zombie exit");
80103cbe:	c7 04 24 5d 78 10 80 	movl   $0x8010785d,(%esp)
80103cc5:	e8 96 c6 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103cca:	c7 04 24 50 78 10 80 	movl   $0x80107850,(%esp)
80103cd1:	e8 8a c6 ff ff       	call   80100360 <panic>
80103cd6:	8d 76 00             	lea    0x0(%esi),%esi
80103cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ce0 <exitStatus>:
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	56                   	push   %esi
  if (curproc == initproc)
80103ce4:	31 f6                	xor    %esi,%esi
{
80103ce6:	53                   	push   %ebx
80103ce7:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103cea:	e8 f1 f9 ff ff       	call   801036e0 <myproc>
80103cef:	89 c3                	mov    %eax,%ebx
  curproc->exitStatus = status; //cs153_lab1: sets the process' exit status to status
80103cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  if (curproc == initproc)
80103cf4:	3b 1d b8 a5 10 80    	cmp    0x8010a5b8,%ebx
  curproc->exitStatus = status; //cs153_lab1: sets the process' exit status to status
80103cfa:	89 03                	mov    %eax,(%ebx)
  if (curproc == initproc)
80103cfc:	0f 84 88 01 00 00    	je     80103e8a <exitStatus+0x1aa>
80103d02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd])
80103d08:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103d0c:	85 c0                	test   %eax,%eax
80103d0e:	74 10                	je     80103d20 <exitStatus+0x40>
      fileclose(curproc->ofile[fd]);
80103d10:	89 04 24             	mov    %eax,(%esp)
80103d13:	e8 28 d1 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103d18:	c7 44 b3 2c 00 00 00 	movl   $0x0,0x2c(%ebx,%esi,4)
80103d1f:	00 
  for (fd = 0; fd < NOFILE; fd++)
80103d20:	83 c6 01             	add    $0x1,%esi
80103d23:	83 fe 10             	cmp    $0x10,%esi
80103d26:	75 e0                	jne    80103d08 <exitStatus+0x28>
  begin_op();
80103d28:	e8 f3 ed ff ff       	call   80102b20 <begin_op>
  iput(curproc->cwd);
80103d2d:	8b 43 6c             	mov    0x6c(%ebx),%eax
80103d30:	89 04 24             	mov    %eax,(%esp)
80103d33:	e8 a8 da ff ff       	call   801017e0 <iput>
  end_op();
80103d38:	e8 53 ee ff ff       	call   80102b90 <end_op>
  curproc->cwd = 0;
80103d3d:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
  acquire(&ptable.lock);
80103d44:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d4b:	e8 a0 09 00 00       	call   801046f0 <acquire>
  wakeup1(curproc->parent);
80103d50:	8b 43 18             	mov    0x18(%ebx),%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d53:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103d58:	eb 14                	jmp    80103d6e <exitStatus+0x8e>
80103d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d60:	81 c2 90 00 00 00    	add    $0x90,%edx
80103d66:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
80103d6c:	74 20                	je     80103d8e <exitStatus+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103d6e:	83 7a 10 02          	cmpl   $0x2,0x10(%edx)
80103d72:	75 ec                	jne    80103d60 <exitStatus+0x80>
80103d74:	3b 42 24             	cmp    0x24(%edx),%eax
80103d77:	75 e7                	jne    80103d60 <exitStatus+0x80>
      p->state = RUNNABLE;
80103d79:	c7 42 10 03 00 00 00 	movl   $0x3,0x10(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d80:	81 c2 90 00 00 00    	add    $0x90,%edx
80103d86:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
80103d8c:	75 e0                	jne    80103d6e <exitStatus+0x8e>
      p->parent = initproc;
80103d8e:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103d93:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103d98:	eb 14                	jmp    80103dae <exitStatus+0xce>
80103d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103da0:	81 c1 90 00 00 00    	add    $0x90,%ecx
80103da6:	81 f9 54 51 11 80    	cmp    $0x80115154,%ecx
80103dac:	74 3c                	je     80103dea <exitStatus+0x10a>
    if (p->parent == curproc)
80103dae:	39 59 18             	cmp    %ebx,0x18(%ecx)
80103db1:	75 ed                	jne    80103da0 <exitStatus+0xc0>
      if (p->state == ZOMBIE)
80103db3:	83 79 10 05          	cmpl   $0x5,0x10(%ecx)
      p->parent = initproc;
80103db7:	89 41 18             	mov    %eax,0x18(%ecx)
      if (p->state == ZOMBIE)
80103dba:	75 e4                	jne    80103da0 <exitStatus+0xc0>
80103dbc:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103dc1:	eb 13                	jmp    80103dd6 <exitStatus+0xf6>
80103dc3:	90                   	nop
80103dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dc8:	81 c2 90 00 00 00    	add    $0x90,%edx
80103dce:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
80103dd4:	74 ca                	je     80103da0 <exitStatus+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103dd6:	83 7a 10 02          	cmpl   $0x2,0x10(%edx)
80103dda:	75 ec                	jne    80103dc8 <exitStatus+0xe8>
80103ddc:	3b 42 24             	cmp    0x24(%edx),%eax
80103ddf:	75 e7                	jne    80103dc8 <exitStatus+0xe8>
      p->state = RUNNABLE;
80103de1:	c7 42 10 03 00 00 00 	movl   $0x3,0x10(%edx)
80103de8:	eb de                	jmp    80103dc8 <exitStatus+0xe8>
  curproc->turnTime = ticks - curproc->turnTime; //cs153_lab2: compute process' turn time (T_finish - T_start)
80103dea:	a1 a0 59 11 80       	mov    0x801159a0,%eax
80103def:	2b 83 88 00 00 00    	sub    0x88(%ebx),%eax
80103df5:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  curproc->waitTime = curproc->turnTime - curproc->burstTime; //cs153_lab2: compute process' wait time (turn around time - burst time)
80103dfb:	2b 83 8c 00 00 00    	sub    0x8c(%ebx),%eax
80103e01:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  cprintf("PID: %d has exited.\n", curproc->pid); //cs153_lab2: print pid
80103e07:	8b 43 14             	mov    0x14(%ebx),%eax
80103e0a:	c7 04 24 69 78 10 80 	movl   $0x80107869,(%esp)
80103e11:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e15:	e8 36 c8 ff ff       	call   80100650 <cprintf>
  cprintf("Ending priority: %d\n", curproc->prior_val); //cs153_lab2: print ending priority
80103e1a:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
80103e20:	c7 04 24 7e 78 10 80 	movl   $0x8010787e,(%esp)
80103e27:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e2b:	e8 20 c8 ff ff       	call   80100650 <cprintf>
  cprintf("Turn time: %d\n", curproc->turnTime); //cs153_lab2: print turn time
80103e30:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80103e36:	c7 04 24 93 78 10 80 	movl   $0x80107893,(%esp)
80103e3d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e41:	e8 0a c8 ff ff       	call   80100650 <cprintf>
  cprintf("Wait time: %d\n", curproc->waitTime); //cs153_lab2: print wait time
80103e46:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80103e4c:	c7 04 24 a2 78 10 80 	movl   $0x801078a2,(%esp)
80103e53:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e57:	e8 f4 c7 ff ff       	call   80100650 <cprintf>
  cprintf("Burst time: %d\n", curproc->burstTime); //cs153_lab2: print burst time
80103e5c:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80103e62:	c7 04 24 b1 78 10 80 	movl   $0x801078b1,(%esp)
80103e69:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e6d:	e8 de c7 ff ff       	call   80100650 <cprintf>
  curproc->state = ZOMBIE;
80103e72:	c7 43 10 05 00 00 00 	movl   $0x5,0x10(%ebx)
  sched();
80103e79:	e8 92 fc ff ff       	call   80103b10 <sched>
  panic("zombie exit");
80103e7e:	c7 04 24 5d 78 10 80 	movl   $0x8010785d,(%esp)
80103e85:	e8 d6 c4 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103e8a:	c7 04 24 50 78 10 80 	movl   $0x80107850,(%esp)
80103e91:	e8 ca c4 ff ff       	call   80100360 <panic>
80103e96:	8d 76 00             	lea    0x0(%esi),%esi
80103e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ea0 <yield>:
{
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103ea6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ead:	e8 3e 08 00 00       	call   801046f0 <acquire>
  myproc()->state = RUNNABLE;
80103eb2:	e8 29 f8 ff ff       	call   801036e0 <myproc>
80103eb7:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  sched();
80103ebe:	e8 4d fc ff ff       	call   80103b10 <sched>
  release(&ptable.lock);
80103ec3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103eca:	e8 91 08 00 00       	call   80104760 <release>
}
80103ecf:	c9                   	leave  
80103ed0:	c3                   	ret    
80103ed1:	eb 0d                	jmp    80103ee0 <setPrior>
80103ed3:	90                   	nop
80103ed4:	90                   	nop
80103ed5:	90                   	nop
80103ed6:	90                   	nop
80103ed7:	90                   	nop
80103ed8:	90                   	nop
80103ed9:	90                   	nop
80103eda:	90                   	nop
80103edb:	90                   	nop
80103edc:	90                   	nop
80103edd:	90                   	nop
80103ede:	90                   	nop
80103edf:	90                   	nop

80103ee0 <setPrior>:
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	53                   	push   %ebx
80103ee4:	83 ec 04             	sub    $0x4,%esp
80103ee7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    myproc()->prior_val = prior_val;
80103eea:	e8 f1 f7 ff ff       	call   801036e0 <myproc>
80103eef:	89 98 80 00 00 00    	mov    %ebx,0x80(%eax)
}
80103ef5:	83 c4 04             	add    $0x4,%esp
80103ef8:	5b                   	pop    %ebx
80103ef9:	5d                   	pop    %ebp
    yield(); //give up CPU once priority value changes
80103efa:	eb a4                	jmp    80103ea0 <yield>
80103efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103f00 <sleep>:
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	57                   	push   %edi
80103f04:	56                   	push   %esi
80103f05:	53                   	push   %ebx
80103f06:	83 ec 1c             	sub    $0x1c,%esp
80103f09:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103f0f:	e8 cc f7 ff ff       	call   801036e0 <myproc>
  if(p == 0)
80103f14:	85 c0                	test   %eax,%eax
  struct proc *p = myproc();
80103f16:	89 c3                	mov    %eax,%ebx
  if(p == 0)
80103f18:	0f 84 7c 00 00 00    	je     80103f9a <sleep+0x9a>
  if(lk == 0)
80103f1e:	85 f6                	test   %esi,%esi
80103f20:	74 6c                	je     80103f8e <sleep+0x8e>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103f22:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103f28:	74 46                	je     80103f70 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103f2a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f31:	e8 ba 07 00 00       	call   801046f0 <acquire>
    release(lk);
80103f36:	89 34 24             	mov    %esi,(%esp)
80103f39:	e8 22 08 00 00       	call   80104760 <release>
  p->chan = chan;
80103f3e:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
80103f41:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80103f48:	e8 c3 fb ff ff       	call   80103b10 <sched>
  p->chan = 0;
80103f4d:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
80103f54:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f5b:	e8 00 08 00 00       	call   80104760 <release>
    acquire(lk);
80103f60:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103f63:	83 c4 1c             	add    $0x1c,%esp
80103f66:	5b                   	pop    %ebx
80103f67:	5e                   	pop    %esi
80103f68:	5f                   	pop    %edi
80103f69:	5d                   	pop    %ebp
    acquire(lk);
80103f6a:	e9 81 07 00 00       	jmp    801046f0 <acquire>
80103f6f:	90                   	nop
  p->chan = chan;
80103f70:	89 78 24             	mov    %edi,0x24(%eax)
  p->state = SLEEPING;
80103f73:	c7 40 10 02 00 00 00 	movl   $0x2,0x10(%eax)
  sched();
80103f7a:	e8 91 fb ff ff       	call   80103b10 <sched>
  p->chan = 0;
80103f7f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
80103f86:	83 c4 1c             	add    $0x1c,%esp
80103f89:	5b                   	pop    %ebx
80103f8a:	5e                   	pop    %esi
80103f8b:	5f                   	pop    %edi
80103f8c:	5d                   	pop    %ebp
80103f8d:	c3                   	ret    
    panic("sleep without lk");
80103f8e:	c7 04 24 c7 78 10 80 	movl   $0x801078c7,(%esp)
80103f95:	e8 c6 c3 ff ff       	call   80100360 <panic>
    panic("sleep");
80103f9a:	c7 04 24 c1 78 10 80 	movl   $0x801078c1,(%esp)
80103fa1:	e8 ba c3 ff ff       	call   80100360 <panic>
80103fa6:	8d 76 00             	lea    0x0(%esi),%esi
80103fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fb0 <wait>:
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	56                   	push   %esi
80103fb4:	53                   	push   %ebx
80103fb5:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103fb8:	e8 23 f7 ff ff       	call   801036e0 <myproc>
  acquire(&ptable.lock);
80103fbd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *curproc = myproc();
80103fc4:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103fc6:	e8 25 07 00 00       	call   801046f0 <acquire>
    havekids = 0;
80103fcb:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fcd:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103fd2:	eb 12                	jmp    80103fe6 <wait+0x36>
80103fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fd8:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103fde:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
80103fe4:	74 22                	je     80104008 <wait+0x58>
      if(p->parent != curproc)
80103fe6:	39 73 18             	cmp    %esi,0x18(%ebx)
80103fe9:	75 ed                	jne    80103fd8 <wait+0x28>
      if(p->state == ZOMBIE){
80103feb:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
80103fef:	74 34                	je     80104025 <wait+0x75>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ff1:	81 c3 90 00 00 00    	add    $0x90,%ebx
      havekids = 1;
80103ff7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ffc:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
80104002:	75 e2                	jne    80103fe6 <wait+0x36>
80104004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(!havekids || curproc->killed){
80104008:	85 c0                	test   %eax,%eax
8010400a:	74 6e                	je     8010407a <wait+0xca>
8010400c:	8b 46 28             	mov    0x28(%esi),%eax
8010400f:	85 c0                	test   %eax,%eax
80104011:	75 67                	jne    8010407a <wait+0xca>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104013:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
8010401a:	80 
8010401b:	89 34 24             	mov    %esi,(%esp)
8010401e:	e8 dd fe ff ff       	call   80103f00 <sleep>
  }
80104023:	eb a6                	jmp    80103fcb <wait+0x1b>
        kfree(p->kstack);
80104025:	8b 43 0c             	mov    0xc(%ebx),%eax
        pid = p->pid;
80104028:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
8010402b:	89 04 24             	mov    %eax,(%esp)
8010402e:	e8 cd e2 ff ff       	call   80102300 <kfree>
        freevm(p->pgdir);
80104033:	8b 43 08             	mov    0x8(%ebx),%eax
        p->kstack = 0;
80104036:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
8010403d:	89 04 24             	mov    %eax,(%esp)
80104040:	e8 0b 2f 00 00       	call   80106f50 <freevm>
        release(&ptable.lock);
80104045:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
8010404c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
80104053:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
8010405a:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
8010405e:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
80104065:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
8010406c:	e8 ef 06 00 00       	call   80104760 <release>
}
80104071:	83 c4 10             	add    $0x10,%esp
        return pid;
80104074:	89 f0                	mov    %esi,%eax
}
80104076:	5b                   	pop    %ebx
80104077:	5e                   	pop    %esi
80104078:	5d                   	pop    %ebp
80104079:	c3                   	ret    
      release(&ptable.lock);
8010407a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104081:	e8 da 06 00 00       	call   80104760 <release>
}
80104086:	83 c4 10             	add    $0x10,%esp
      return -1;
80104089:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010408e:	5b                   	pop    %ebx
8010408f:	5e                   	pop    %esi
80104090:	5d                   	pop    %ebp
80104091:	c3                   	ret    
80104092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040a0 <waitStatus>:
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	57                   	push   %edi
801040a4:	56                   	push   %esi
801040a5:	53                   	push   %ebx
801040a6:	83 ec 1c             	sub    $0x1c,%esp
801040a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct proc *curproc = myproc();
801040ac:	e8 2f f6 ff ff       	call   801036e0 <myproc>
  acquire(&ptable.lock);
801040b1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *curproc = myproc();
801040b8:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
801040ba:	e8 31 06 00 00       	call   801046f0 <acquire>
    havekids = 0;
801040bf:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040c1:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801040c6:	eb 0e                	jmp    801040d6 <waitStatus+0x36>
801040c8:	81 c3 90 00 00 00    	add    $0x90,%ebx
801040ce:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
801040d4:	74 22                	je     801040f8 <waitStatus+0x58>
      if(p->parent != curproc)
801040d6:	39 73 18             	cmp    %esi,0x18(%ebx)
801040d9:	75 ed                	jne    801040c8 <waitStatus+0x28>
      if(p->state == ZOMBIE) //Found one
801040db:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
801040df:	74 34                	je     80104115 <waitStatus+0x75>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040e1:	81 c3 90 00 00 00    	add    $0x90,%ebx
      havekids = 1;
801040e7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040ec:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
801040f2:	75 e2                	jne    801040d6 <waitStatus+0x36>
801040f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(!havekids || curproc->killed)
801040f8:	85 c0                	test   %eax,%eax
801040fa:	74 77                	je     80104173 <waitStatus+0xd3>
801040fc:	8b 46 28             	mov    0x28(%esi),%eax
801040ff:	85 c0                	test   %eax,%eax
80104101:	75 70                	jne    80104173 <waitStatus+0xd3>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104103:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
8010410a:	80 
8010410b:	89 34 24             	mov    %esi,(%esp)
8010410e:	e8 ed fd ff ff       	call   80103f00 <sleep>
  }
80104113:	eb aa                	jmp    801040bf <waitStatus+0x1f>
        kfree(p->kstack);
80104115:	8b 43 0c             	mov    0xc(%ebx),%eax
        pid = p->pid;
80104118:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
8010411b:	89 04 24             	mov    %eax,(%esp)
8010411e:	e8 dd e1 ff ff       	call   80102300 <kfree>
        freevm(p->pgdir);
80104123:	8b 43 08             	mov    0x8(%ebx),%eax
        p->kstack = 0;
80104126:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
8010412d:	89 04 24             	mov    %eax,(%esp)
80104130:	e8 1b 2e 00 00       	call   80106f50 <freevm>
        if (status != 0)
80104135:	85 ff                	test   %edi,%edi
        p->pid = 0;
80104137:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
8010413e:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
80104145:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
80104149:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
80104150:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        if (status != 0)
80104157:	74 04                	je     8010415d <waitStatus+0xbd>
          *status = p->exitStatus; //cs153_lab1: return the terminated child exit status through the status argument
80104159:	8b 03                	mov    (%ebx),%eax
8010415b:	89 07                	mov    %eax,(%edi)
        release(&ptable.lock);
8010415d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104164:	e8 f7 05 00 00       	call   80104760 <release>
}
80104169:	83 c4 1c             	add    $0x1c,%esp
        return pid;
8010416c:	89 f0                	mov    %esi,%eax
}
8010416e:	5b                   	pop    %ebx
8010416f:	5e                   	pop    %esi
80104170:	5f                   	pop    %edi
80104171:	5d                   	pop    %ebp
80104172:	c3                   	ret    
      release(&ptable.lock);
80104173:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010417a:	e8 e1 05 00 00       	call   80104760 <release>
}
8010417f:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80104182:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104187:	5b                   	pop    %ebx
80104188:	5e                   	pop    %esi
80104189:	5f                   	pop    %edi
8010418a:	5d                   	pop    %ebp
8010418b:	c3                   	ret    
8010418c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104190 <waitpid>:
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	57                   	push   %edi
80104194:	56                   	push   %esi
80104195:	53                   	push   %ebx
80104196:	83 ec 1c             	sub    $0x1c,%esp
80104199:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc* curproc = myproc();
8010419c:	e8 3f f5 ff ff       	call   801036e0 <myproc>
  acquire(&ptable.lock);
801041a1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc* curproc = myproc();
801041a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  acquire(&ptable.lock);
801041ab:	e8 40 05 00 00       	call   801046f0 <acquire>
    processExists = 0;
801041b0:	31 c9                	xor    %ecx,%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041b2:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801041b7:	eb 15                	jmp    801041ce <waitpid+0x3e>
801041b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801041c6:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
801041cc:	74 20                	je     801041ee <waitpid+0x5e>
      if (p->pid != pid)
801041ce:	8b 7b 14             	mov    0x14(%ebx),%edi
801041d1:	39 f7                	cmp    %esi,%edi
801041d3:	75 eb                	jne    801041c0 <waitpid+0x30>
      if (p->state == ZOMBIE) //process exited
801041d5:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
801041d9:	74 3d                	je     80104218 <waitpid+0x88>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041db:	81 c3 90 00 00 00    	add    $0x90,%ebx
      processExists = 1;
801041e1:	b9 01 00 00 00       	mov    $0x1,%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041e6:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
801041ec:	75 e0                	jne    801041ce <waitpid+0x3e>
    if (!processExists || curproc->killed)
801041ee:	85 c9                	test   %ecx,%ecx
801041f0:	0f 84 83 00 00 00    	je     80104279 <waitpid+0xe9>
801041f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801041f9:	8b 40 28             	mov    0x28(%eax),%eax
801041fc:	85 c0                	test   %eax,%eax
801041fe:	75 79                	jne    80104279 <waitpid+0xe9>
    sleep(curproc, &ptable.lock); //DOC: wait-sleep
80104200:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104203:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
8010420a:	80 
8010420b:	89 04 24             	mov    %eax,(%esp)
8010420e:	e8 ed fc ff ff       	call   80103f00 <sleep>
  }
80104213:	eb 9b                	jmp    801041b0 <waitpid+0x20>
80104215:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104218:	8b 53 0c             	mov    0xc(%ebx),%edx
8010421b:	89 14 24             	mov    %edx,(%esp)
8010421e:	e8 dd e0 ff ff       	call   80102300 <kfree>
        freevm(p->pgdir);
80104223:	8b 53 08             	mov    0x8(%ebx),%edx
        p->kstack = 0;
80104226:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
8010422d:	89 14 24             	mov    %edx,(%esp)
80104230:	e8 1b 2d 00 00       	call   80106f50 <freevm>
        if (status != 0)
80104235:	8b 55 0c             	mov    0xc(%ebp),%edx
        p->pid = 0;
80104238:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
8010423f:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
80104246:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        if (status != 0)
8010424a:	85 d2                	test   %edx,%edx
        p->killed = 0;
8010424c:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
80104253:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        if (status != 0)
8010425a:	74 07                	je     80104263 <waitpid+0xd3>
          *status = p->exitStatus;
8010425c:	8b 13                	mov    (%ebx),%edx
8010425e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104261:	89 10                	mov    %edx,(%eax)
        release(&ptable.lock);
80104263:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010426a:	e8 f1 04 00 00       	call   80104760 <release>
}
8010426f:	83 c4 1c             	add    $0x1c,%esp
80104272:	89 f8                	mov    %edi,%eax
80104274:	5b                   	pop    %ebx
80104275:	5e                   	pop    %esi
80104276:	5f                   	pop    %edi
80104277:	5d                   	pop    %ebp
80104278:	c3                   	ret    
      release(&ptable.lock);
80104279:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
      return -1;
80104280:	bf ff ff ff ff       	mov    $0xffffffff,%edi
      release(&ptable.lock);
80104285:	e8 d6 04 00 00       	call   80104760 <release>
      return -1;
8010428a:	eb e3                	jmp    8010426f <waitpid+0xdf>
8010428c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104290 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	53                   	push   %ebx
80104294:	83 ec 14             	sub    $0x14,%esp
80104297:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010429a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801042a1:	e8 4a 04 00 00       	call   801046f0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042a6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801042ab:	eb 0f                	jmp    801042bc <wakeup+0x2c>
801042ad:	8d 76 00             	lea    0x0(%esi),%esi
801042b0:	05 90 00 00 00       	add    $0x90,%eax
801042b5:	3d 54 51 11 80       	cmp    $0x80115154,%eax
801042ba:	74 24                	je     801042e0 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
801042bc:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801042c0:	75 ee                	jne    801042b0 <wakeup+0x20>
801042c2:	3b 58 24             	cmp    0x24(%eax),%ebx
801042c5:	75 e9                	jne    801042b0 <wakeup+0x20>
      p->state = RUNNABLE;
801042c7:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042ce:	05 90 00 00 00       	add    $0x90,%eax
801042d3:	3d 54 51 11 80       	cmp    $0x80115154,%eax
801042d8:	75 e2                	jne    801042bc <wakeup+0x2c>
801042da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  wakeup1(chan);
  release(&ptable.lock);
801042e0:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801042e7:	83 c4 14             	add    $0x14,%esp
801042ea:	5b                   	pop    %ebx
801042eb:	5d                   	pop    %ebp
  release(&ptable.lock);
801042ec:	e9 6f 04 00 00       	jmp    80104760 <release>
801042f1:	eb 0d                	jmp    80104300 <kill>
801042f3:	90                   	nop
801042f4:	90                   	nop
801042f5:	90                   	nop
801042f6:	90                   	nop
801042f7:	90                   	nop
801042f8:	90                   	nop
801042f9:	90                   	nop
801042fa:	90                   	nop
801042fb:	90                   	nop
801042fc:	90                   	nop
801042fd:	90                   	nop
801042fe:	90                   	nop
801042ff:	90                   	nop

80104300 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	53                   	push   %ebx
80104304:	83 ec 14             	sub    $0x14,%esp
80104307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010430a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104311:	e8 da 03 00 00       	call   801046f0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104316:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010431b:	eb 0f                	jmp    8010432c <kill+0x2c>
8010431d:	8d 76 00             	lea    0x0(%esi),%esi
80104320:	05 90 00 00 00       	add    $0x90,%eax
80104325:	3d 54 51 11 80       	cmp    $0x80115154,%eax
8010432a:	74 3c                	je     80104368 <kill+0x68>
    if(p->pid == pid){
8010432c:	39 58 14             	cmp    %ebx,0x14(%eax)
8010432f:	75 ef                	jne    80104320 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104331:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
      p->killed = 1;
80104335:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      if(p->state == SLEEPING)
8010433c:	74 1a                	je     80104358 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010433e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104345:	e8 16 04 00 00       	call   80104760 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010434a:	83 c4 14             	add    $0x14,%esp
      return 0;
8010434d:	31 c0                	xor    %eax,%eax
}
8010434f:	5b                   	pop    %ebx
80104350:	5d                   	pop    %ebp
80104351:	c3                   	ret    
80104352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        p->state = RUNNABLE;
80104358:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
8010435f:	eb dd                	jmp    8010433e <kill+0x3e>
80104361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104368:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010436f:	e8 ec 03 00 00       	call   80104760 <release>
}
80104374:	83 c4 14             	add    $0x14,%esp
  return -1;
80104377:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010437c:	5b                   	pop    %ebx
8010437d:	5d                   	pop    %ebp
8010437e:	c3                   	ret    
8010437f:	90                   	nop

80104380 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	57                   	push   %edi
80104384:	56                   	push   %esi
80104385:	53                   	push   %ebx
80104386:	bb c4 2d 11 80       	mov    $0x80112dc4,%ebx
8010438b:	83 ec 4c             	sub    $0x4c,%esp
8010438e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104391:	eb 23                	jmp    801043b6 <procdump+0x36>
80104393:	90                   	nop
80104394:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104398:	c7 04 24 77 7c 10 80 	movl   $0x80107c77,(%esp)
8010439f:	e8 ac c2 ff ff       	call   80100650 <cprintf>
801043a4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043aa:	81 fb c4 51 11 80    	cmp    $0x801151c4,%ebx
801043b0:	0f 84 8a 00 00 00    	je     80104440 <procdump+0xc0>
    if(p->state == UNUSED)
801043b6:	8b 43 a0             	mov    -0x60(%ebx),%eax
801043b9:	85 c0                	test   %eax,%eax
801043bb:	74 e7                	je     801043a4 <procdump+0x24>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801043bd:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801043c0:	ba d8 78 10 80       	mov    $0x801078d8,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801043c5:	77 11                	ja     801043d8 <procdump+0x58>
801043c7:	8b 14 85 38 79 10 80 	mov    -0x7fef86c8(,%eax,4),%edx
      state = "???";
801043ce:	b8 d8 78 10 80       	mov    $0x801078d8,%eax
801043d3:	85 d2                	test   %edx,%edx
801043d5:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801043d8:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801043db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801043df:	89 54 24 08          	mov    %edx,0x8(%esp)
801043e3:	c7 04 24 dc 78 10 80 	movl   $0x801078dc,(%esp)
801043ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801043ee:	e8 5d c2 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
801043f3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801043f7:	75 9f                	jne    80104398 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801043f9:	8d 45 c0             	lea    -0x40(%ebp),%eax
801043fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104400:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104403:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104406:	8b 40 0c             	mov    0xc(%eax),%eax
80104409:	83 c0 08             	add    $0x8,%eax
8010440c:	89 04 24             	mov    %eax,(%esp)
8010440f:	e8 8c 01 00 00       	call   801045a0 <getcallerpcs>
80104414:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104418:	8b 17                	mov    (%edi),%edx
8010441a:	85 d2                	test   %edx,%edx
8010441c:	0f 84 76 ff ff ff    	je     80104398 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104422:	89 54 24 04          	mov    %edx,0x4(%esp)
80104426:	83 c7 04             	add    $0x4,%edi
80104429:	c7 04 24 c1 72 10 80 	movl   $0x801072c1,(%esp)
80104430:	e8 1b c2 ff ff       	call   80100650 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104435:	39 f7                	cmp    %esi,%edi
80104437:	75 df                	jne    80104418 <procdump+0x98>
80104439:	e9 5a ff ff ff       	jmp    80104398 <procdump+0x18>
8010443e:	66 90                	xchg   %ax,%ax
  }
}
80104440:	83 c4 4c             	add    $0x4c,%esp
80104443:	5b                   	pop    %ebx
80104444:	5e                   	pop    %esi
80104445:	5f                   	pop    %edi
80104446:	5d                   	pop    %ebp
80104447:	c3                   	ret    
80104448:	66 90                	xchg   %ax,%ax
8010444a:	66 90                	xchg   %ax,%ax
8010444c:	66 90                	xchg   %ax,%ax
8010444e:	66 90                	xchg   %ax,%ax

80104450 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	53                   	push   %ebx
80104454:	83 ec 14             	sub    $0x14,%esp
80104457:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010445a:	c7 44 24 04 50 79 10 	movl   $0x80107950,0x4(%esp)
80104461:	80 
80104462:	8d 43 04             	lea    0x4(%ebx),%eax
80104465:	89 04 24             	mov    %eax,(%esp)
80104468:	e8 13 01 00 00       	call   80104580 <initlock>
  lk->name = name;
8010446d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104470:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104476:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010447d:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104480:	83 c4 14             	add    $0x14,%esp
80104483:	5b                   	pop    %ebx
80104484:	5d                   	pop    %ebp
80104485:	c3                   	ret    
80104486:	8d 76 00             	lea    0x0(%esi),%esi
80104489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104490 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	56                   	push   %esi
80104494:	53                   	push   %ebx
80104495:	83 ec 10             	sub    $0x10,%esp
80104498:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010449b:	8d 73 04             	lea    0x4(%ebx),%esi
8010449e:	89 34 24             	mov    %esi,(%esp)
801044a1:	e8 4a 02 00 00       	call   801046f0 <acquire>
  while (lk->locked) {
801044a6:	8b 13                	mov    (%ebx),%edx
801044a8:	85 d2                	test   %edx,%edx
801044aa:	74 16                	je     801044c2 <acquiresleep+0x32>
801044ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801044b0:	89 74 24 04          	mov    %esi,0x4(%esp)
801044b4:	89 1c 24             	mov    %ebx,(%esp)
801044b7:	e8 44 fa ff ff       	call   80103f00 <sleep>
  while (lk->locked) {
801044bc:	8b 03                	mov    (%ebx),%eax
801044be:	85 c0                	test   %eax,%eax
801044c0:	75 ee                	jne    801044b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801044c2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801044c8:	e8 13 f2 ff ff       	call   801036e0 <myproc>
801044cd:	8b 40 14             	mov    0x14(%eax),%eax
801044d0:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801044d3:	89 75 08             	mov    %esi,0x8(%ebp)
}
801044d6:	83 c4 10             	add    $0x10,%esp
801044d9:	5b                   	pop    %ebx
801044da:	5e                   	pop    %esi
801044db:	5d                   	pop    %ebp
  release(&lk->lk);
801044dc:	e9 7f 02 00 00       	jmp    80104760 <release>
801044e1:	eb 0d                	jmp    801044f0 <releasesleep>
801044e3:	90                   	nop
801044e4:	90                   	nop
801044e5:	90                   	nop
801044e6:	90                   	nop
801044e7:	90                   	nop
801044e8:	90                   	nop
801044e9:	90                   	nop
801044ea:	90                   	nop
801044eb:	90                   	nop
801044ec:	90                   	nop
801044ed:	90                   	nop
801044ee:	90                   	nop
801044ef:	90                   	nop

801044f0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
801044f3:	56                   	push   %esi
801044f4:	53                   	push   %ebx
801044f5:	83 ec 10             	sub    $0x10,%esp
801044f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044fb:	8d 73 04             	lea    0x4(%ebx),%esi
801044fe:	89 34 24             	mov    %esi,(%esp)
80104501:	e8 ea 01 00 00       	call   801046f0 <acquire>
  lk->locked = 0;
80104506:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010450c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104513:	89 1c 24             	mov    %ebx,(%esp)
80104516:	e8 75 fd ff ff       	call   80104290 <wakeup>
  release(&lk->lk);
8010451b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010451e:	83 c4 10             	add    $0x10,%esp
80104521:	5b                   	pop    %ebx
80104522:	5e                   	pop    %esi
80104523:	5d                   	pop    %ebp
  release(&lk->lk);
80104524:	e9 37 02 00 00       	jmp    80104760 <release>
80104529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104530 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	57                   	push   %edi
  int r;
  
  acquire(&lk->lk);
  r = lk->locked && (lk->pid == myproc()->pid);
80104534:	31 ff                	xor    %edi,%edi
{
80104536:	56                   	push   %esi
80104537:	53                   	push   %ebx
80104538:	83 ec 1c             	sub    $0x1c,%esp
8010453b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010453e:	8d 73 04             	lea    0x4(%ebx),%esi
80104541:	89 34 24             	mov    %esi,(%esp)
80104544:	e8 a7 01 00 00       	call   801046f0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104549:	8b 03                	mov    (%ebx),%eax
8010454b:	85 c0                	test   %eax,%eax
8010454d:	74 13                	je     80104562 <holdingsleep+0x32>
8010454f:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104552:	e8 89 f1 ff ff       	call   801036e0 <myproc>
80104557:	3b 58 14             	cmp    0x14(%eax),%ebx
8010455a:	0f 94 c0             	sete   %al
8010455d:	0f b6 c0             	movzbl %al,%eax
80104560:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104562:	89 34 24             	mov    %esi,(%esp)
80104565:	e8 f6 01 00 00       	call   80104760 <release>
  return r;
}
8010456a:	83 c4 1c             	add    $0x1c,%esp
8010456d:	89 f8                	mov    %edi,%eax
8010456f:	5b                   	pop    %ebx
80104570:	5e                   	pop    %esi
80104571:	5f                   	pop    %edi
80104572:	5d                   	pop    %ebp
80104573:	c3                   	ret    
80104574:	66 90                	xchg   %ax,%ax
80104576:	66 90                	xchg   %ax,%ax
80104578:	66 90                	xchg   %ax,%ax
8010457a:	66 90                	xchg   %ax,%ax
8010457c:	66 90                	xchg   %ax,%ax
8010457e:	66 90                	xchg   %ax,%ax

80104580 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104586:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104589:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010458f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104592:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104599:	5d                   	pop    %ebp
8010459a:	c3                   	ret    
8010459b:	90                   	nop
8010459c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045a0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801045a3:	8b 45 08             	mov    0x8(%ebp),%eax
{
801045a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801045a9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801045aa:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801045ad:	31 c0                	xor    %eax,%eax
801045af:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045b0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801045b6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801045bc:	77 1a                	ja     801045d8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801045be:	8b 5a 04             	mov    0x4(%edx),%ebx
801045c1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801045c4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801045c7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801045c9:	83 f8 0a             	cmp    $0xa,%eax
801045cc:	75 e2                	jne    801045b0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801045ce:	5b                   	pop    %ebx
801045cf:	5d                   	pop    %ebp
801045d0:	c3                   	ret    
801045d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
801045d8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801045df:	83 c0 01             	add    $0x1,%eax
801045e2:	83 f8 0a             	cmp    $0xa,%eax
801045e5:	74 e7                	je     801045ce <getcallerpcs+0x2e>
    pcs[i] = 0;
801045e7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801045ee:	83 c0 01             	add    $0x1,%eax
801045f1:	83 f8 0a             	cmp    $0xa,%eax
801045f4:	75 e2                	jne    801045d8 <getcallerpcs+0x38>
801045f6:	eb d6                	jmp    801045ce <getcallerpcs+0x2e>
801045f8:	90                   	nop
801045f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104600 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	53                   	push   %ebx
80104604:	83 ec 04             	sub    $0x4,%esp
80104607:	9c                   	pushf  
80104608:	5b                   	pop    %ebx
  asm volatile("cli");
80104609:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010460a:	e8 31 f0 ff ff       	call   80103640 <mycpu>
8010460f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104615:	85 c0                	test   %eax,%eax
80104617:	75 11                	jne    8010462a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104619:	e8 22 f0 ff ff       	call   80103640 <mycpu>
8010461e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104624:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010462a:	e8 11 f0 ff ff       	call   80103640 <mycpu>
8010462f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104636:	83 c4 04             	add    $0x4,%esp
80104639:	5b                   	pop    %ebx
8010463a:	5d                   	pop    %ebp
8010463b:	c3                   	ret    
8010463c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104640 <popcli>:

void
popcli(void)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104646:	9c                   	pushf  
80104647:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104648:	f6 c4 02             	test   $0x2,%ah
8010464b:	75 49                	jne    80104696 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010464d:	e8 ee ef ff ff       	call   80103640 <mycpu>
80104652:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104658:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010465b:	85 d2                	test   %edx,%edx
8010465d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104663:	78 25                	js     8010468a <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104665:	e8 d6 ef ff ff       	call   80103640 <mycpu>
8010466a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104670:	85 d2                	test   %edx,%edx
80104672:	74 04                	je     80104678 <popcli+0x38>
    sti();
}
80104674:	c9                   	leave  
80104675:	c3                   	ret    
80104676:	66 90                	xchg   %ax,%ax
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104678:	e8 c3 ef ff ff       	call   80103640 <mycpu>
8010467d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104683:	85 c0                	test   %eax,%eax
80104685:	74 ed                	je     80104674 <popcli+0x34>
  asm volatile("sti");
80104687:	fb                   	sti    
}
80104688:	c9                   	leave  
80104689:	c3                   	ret    
    panic("popcli");
8010468a:	c7 04 24 72 79 10 80 	movl   $0x80107972,(%esp)
80104691:	e8 ca bc ff ff       	call   80100360 <panic>
    panic("popcli - interruptible");
80104696:	c7 04 24 5b 79 10 80 	movl   $0x8010795b,(%esp)
8010469d:	e8 be bc ff ff       	call   80100360 <panic>
801046a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046b0 <holding>:
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	56                   	push   %esi
  r = lock->locked && lock->cpu == mycpu();
801046b4:	31 f6                	xor    %esi,%esi
{
801046b6:	53                   	push   %ebx
801046b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801046ba:	e8 41 ff ff ff       	call   80104600 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046bf:	8b 03                	mov    (%ebx),%eax
801046c1:	85 c0                	test   %eax,%eax
801046c3:	74 12                	je     801046d7 <holding+0x27>
801046c5:	8b 5b 08             	mov    0x8(%ebx),%ebx
801046c8:	e8 73 ef ff ff       	call   80103640 <mycpu>
801046cd:	39 c3                	cmp    %eax,%ebx
801046cf:	0f 94 c0             	sete   %al
801046d2:	0f b6 c0             	movzbl %al,%eax
801046d5:	89 c6                	mov    %eax,%esi
  popcli();
801046d7:	e8 64 ff ff ff       	call   80104640 <popcli>
}
801046dc:	89 f0                	mov    %esi,%eax
801046de:	5b                   	pop    %ebx
801046df:	5e                   	pop    %esi
801046e0:	5d                   	pop    %ebp
801046e1:	c3                   	ret    
801046e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046f0 <acquire>:
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	53                   	push   %ebx
801046f4:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801046f7:	e8 04 ff ff ff       	call   80104600 <pushcli>
  if(holding(lk))
801046fc:	8b 45 08             	mov    0x8(%ebp),%eax
801046ff:	89 04 24             	mov    %eax,(%esp)
80104702:	e8 a9 ff ff ff       	call   801046b0 <holding>
80104707:	85 c0                	test   %eax,%eax
80104709:	75 3a                	jne    80104745 <acquire+0x55>
  asm volatile("lock; xchgl %0, %1" :
8010470b:	b9 01 00 00 00       	mov    $0x1,%ecx
  while(xchg(&lk->locked, 1) != 0)
80104710:	8b 55 08             	mov    0x8(%ebp),%edx
80104713:	89 c8                	mov    %ecx,%eax
80104715:	f0 87 02             	lock xchg %eax,(%edx)
80104718:	85 c0                	test   %eax,%eax
8010471a:	75 f4                	jne    80104710 <acquire+0x20>
  __sync_synchronize();
8010471c:	0f ae f0             	mfence 
  lk->cpu = mycpu();
8010471f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104722:	e8 19 ef ff ff       	call   80103640 <mycpu>
80104727:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010472a:	8b 45 08             	mov    0x8(%ebp),%eax
8010472d:	83 c0 0c             	add    $0xc,%eax
80104730:	89 44 24 04          	mov    %eax,0x4(%esp)
80104734:	8d 45 08             	lea    0x8(%ebp),%eax
80104737:	89 04 24             	mov    %eax,(%esp)
8010473a:	e8 61 fe ff ff       	call   801045a0 <getcallerpcs>
}
8010473f:	83 c4 14             	add    $0x14,%esp
80104742:	5b                   	pop    %ebx
80104743:	5d                   	pop    %ebp
80104744:	c3                   	ret    
    panic("acquire");
80104745:	c7 04 24 79 79 10 80 	movl   $0x80107979,(%esp)
8010474c:	e8 0f bc ff ff       	call   80100360 <panic>
80104751:	eb 0d                	jmp    80104760 <release>
80104753:	90                   	nop
80104754:	90                   	nop
80104755:	90                   	nop
80104756:	90                   	nop
80104757:	90                   	nop
80104758:	90                   	nop
80104759:	90                   	nop
8010475a:	90                   	nop
8010475b:	90                   	nop
8010475c:	90                   	nop
8010475d:	90                   	nop
8010475e:	90                   	nop
8010475f:	90                   	nop

80104760 <release>:
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	53                   	push   %ebx
80104764:	83 ec 14             	sub    $0x14,%esp
80104767:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010476a:	89 1c 24             	mov    %ebx,(%esp)
8010476d:	e8 3e ff ff ff       	call   801046b0 <holding>
80104772:	85 c0                	test   %eax,%eax
80104774:	74 21                	je     80104797 <release+0x37>
  lk->pcs[0] = 0;
80104776:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010477d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104784:	0f ae f0             	mfence 
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104787:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
8010478d:	83 c4 14             	add    $0x14,%esp
80104790:	5b                   	pop    %ebx
80104791:	5d                   	pop    %ebp
  popcli();
80104792:	e9 a9 fe ff ff       	jmp    80104640 <popcli>
    panic("release");
80104797:	c7 04 24 81 79 10 80 	movl   $0x80107981,(%esp)
8010479e:	e8 bd bb ff ff       	call   80100360 <panic>
801047a3:	66 90                	xchg   %ax,%ax
801047a5:	66 90                	xchg   %ax,%ax
801047a7:	66 90                	xchg   %ax,%ax
801047a9:	66 90                	xchg   %ax,%ax
801047ab:	66 90                	xchg   %ax,%ax
801047ad:	66 90                	xchg   %ax,%ax
801047af:	90                   	nop

801047b0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	8b 55 08             	mov    0x8(%ebp),%edx
801047b6:	57                   	push   %edi
801047b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047ba:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
801047bb:	f6 c2 03             	test   $0x3,%dl
801047be:	75 05                	jne    801047c5 <memset+0x15>
801047c0:	f6 c1 03             	test   $0x3,%cl
801047c3:	74 13                	je     801047d8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801047c5:	89 d7                	mov    %edx,%edi
801047c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801047ca:	fc                   	cld    
801047cb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801047cd:	5b                   	pop    %ebx
801047ce:	89 d0                	mov    %edx,%eax
801047d0:	5f                   	pop    %edi
801047d1:	5d                   	pop    %ebp
801047d2:	c3                   	ret    
801047d3:	90                   	nop
801047d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801047d8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801047dc:	c1 e9 02             	shr    $0x2,%ecx
801047df:	89 f8                	mov    %edi,%eax
801047e1:	89 fb                	mov    %edi,%ebx
801047e3:	c1 e0 18             	shl    $0x18,%eax
801047e6:	c1 e3 10             	shl    $0x10,%ebx
801047e9:	09 d8                	or     %ebx,%eax
801047eb:	09 f8                	or     %edi,%eax
801047ed:	c1 e7 08             	shl    $0x8,%edi
801047f0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801047f2:	89 d7                	mov    %edx,%edi
801047f4:	fc                   	cld    
801047f5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801047f7:	5b                   	pop    %ebx
801047f8:	89 d0                	mov    %edx,%eax
801047fa:	5f                   	pop    %edi
801047fb:	5d                   	pop    %ebp
801047fc:	c3                   	ret    
801047fd:	8d 76 00             	lea    0x0(%esi),%esi

80104800 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	8b 45 10             	mov    0x10(%ebp),%eax
80104806:	57                   	push   %edi
80104807:	56                   	push   %esi
80104808:	8b 75 0c             	mov    0xc(%ebp),%esi
8010480b:	53                   	push   %ebx
8010480c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010480f:	85 c0                	test   %eax,%eax
80104811:	8d 78 ff             	lea    -0x1(%eax),%edi
80104814:	74 26                	je     8010483c <memcmp+0x3c>
    if(*s1 != *s2)
80104816:	0f b6 03             	movzbl (%ebx),%eax
80104819:	31 d2                	xor    %edx,%edx
8010481b:	0f b6 0e             	movzbl (%esi),%ecx
8010481e:	38 c8                	cmp    %cl,%al
80104820:	74 16                	je     80104838 <memcmp+0x38>
80104822:	eb 24                	jmp    80104848 <memcmp+0x48>
80104824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104828:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010482d:	83 c2 01             	add    $0x1,%edx
80104830:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104834:	38 c8                	cmp    %cl,%al
80104836:	75 10                	jne    80104848 <memcmp+0x48>
  while(n-- > 0){
80104838:	39 fa                	cmp    %edi,%edx
8010483a:	75 ec                	jne    80104828 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010483c:	5b                   	pop    %ebx
  return 0;
8010483d:	31 c0                	xor    %eax,%eax
}
8010483f:	5e                   	pop    %esi
80104840:	5f                   	pop    %edi
80104841:	5d                   	pop    %ebp
80104842:	c3                   	ret    
80104843:	90                   	nop
80104844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104848:	5b                   	pop    %ebx
      return *s1 - *s2;
80104849:	29 c8                	sub    %ecx,%eax
}
8010484b:	5e                   	pop    %esi
8010484c:	5f                   	pop    %edi
8010484d:	5d                   	pop    %ebp
8010484e:	c3                   	ret    
8010484f:	90                   	nop

80104850 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	57                   	push   %edi
80104854:	8b 45 08             	mov    0x8(%ebp),%eax
80104857:	56                   	push   %esi
80104858:	8b 75 0c             	mov    0xc(%ebp),%esi
8010485b:	53                   	push   %ebx
8010485c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010485f:	39 c6                	cmp    %eax,%esi
80104861:	73 35                	jae    80104898 <memmove+0x48>
80104863:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104866:	39 c8                	cmp    %ecx,%eax
80104868:	73 2e                	jae    80104898 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010486a:	85 db                	test   %ebx,%ebx
    d += n;
8010486c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010486f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104872:	74 1b                	je     8010488f <memmove+0x3f>
80104874:	f7 db                	neg    %ebx
80104876:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104879:	01 fb                	add    %edi,%ebx
8010487b:	90                   	nop
8010487c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104880:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104884:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    while(n-- > 0)
80104887:	83 ea 01             	sub    $0x1,%edx
8010488a:	83 fa ff             	cmp    $0xffffffff,%edx
8010488d:	75 f1                	jne    80104880 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010488f:	5b                   	pop    %ebx
80104890:	5e                   	pop    %esi
80104891:	5f                   	pop    %edi
80104892:	5d                   	pop    %ebp
80104893:	c3                   	ret    
80104894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104898:	31 d2                	xor    %edx,%edx
8010489a:	85 db                	test   %ebx,%ebx
8010489c:	74 f1                	je     8010488f <memmove+0x3f>
8010489e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801048a0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801048a4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801048a7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801048aa:	39 da                	cmp    %ebx,%edx
801048ac:	75 f2                	jne    801048a0 <memmove+0x50>
}
801048ae:	5b                   	pop    %ebx
801048af:	5e                   	pop    %esi
801048b0:	5f                   	pop    %edi
801048b1:	5d                   	pop    %ebp
801048b2:	c3                   	ret    
801048b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048c0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801048c3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801048c4:	eb 8a                	jmp    80104850 <memmove>
801048c6:	8d 76 00             	lea    0x0(%esi),%esi
801048c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048d0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	56                   	push   %esi
801048d4:	8b 75 10             	mov    0x10(%ebp),%esi
801048d7:	53                   	push   %ebx
801048d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801048db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801048de:	85 f6                	test   %esi,%esi
801048e0:	74 30                	je     80104912 <strncmp+0x42>
801048e2:	0f b6 01             	movzbl (%ecx),%eax
801048e5:	84 c0                	test   %al,%al
801048e7:	74 2f                	je     80104918 <strncmp+0x48>
801048e9:	0f b6 13             	movzbl (%ebx),%edx
801048ec:	38 d0                	cmp    %dl,%al
801048ee:	75 46                	jne    80104936 <strncmp+0x66>
801048f0:	8d 51 01             	lea    0x1(%ecx),%edx
801048f3:	01 ce                	add    %ecx,%esi
801048f5:	eb 14                	jmp    8010490b <strncmp+0x3b>
801048f7:	90                   	nop
801048f8:	0f b6 02             	movzbl (%edx),%eax
801048fb:	84 c0                	test   %al,%al
801048fd:	74 31                	je     80104930 <strncmp+0x60>
801048ff:	0f b6 19             	movzbl (%ecx),%ebx
80104902:	83 c2 01             	add    $0x1,%edx
80104905:	38 d8                	cmp    %bl,%al
80104907:	75 17                	jne    80104920 <strncmp+0x50>
    n--, p++, q++;
80104909:	89 cb                	mov    %ecx,%ebx
  while(n > 0 && *p && *p == *q)
8010490b:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
8010490d:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(n > 0 && *p && *p == *q)
80104910:	75 e6                	jne    801048f8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104912:	5b                   	pop    %ebx
    return 0;
80104913:	31 c0                	xor    %eax,%eax
}
80104915:	5e                   	pop    %esi
80104916:	5d                   	pop    %ebp
80104917:	c3                   	ret    
80104918:	0f b6 1b             	movzbl (%ebx),%ebx
  while(n > 0 && *p && *p == *q)
8010491b:	31 c0                	xor    %eax,%eax
8010491d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
80104920:	0f b6 d3             	movzbl %bl,%edx
80104923:	29 d0                	sub    %edx,%eax
}
80104925:	5b                   	pop    %ebx
80104926:	5e                   	pop    %esi
80104927:	5d                   	pop    %ebp
80104928:	c3                   	ret    
80104929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104930:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104934:	eb ea                	jmp    80104920 <strncmp+0x50>
  while(n > 0 && *p && *p == *q)
80104936:	89 d3                	mov    %edx,%ebx
80104938:	eb e6                	jmp    80104920 <strncmp+0x50>
8010493a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104940 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	8b 45 08             	mov    0x8(%ebp),%eax
80104946:	56                   	push   %esi
80104947:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010494a:	53                   	push   %ebx
8010494b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010494e:	89 c2                	mov    %eax,%edx
80104950:	eb 19                	jmp    8010496b <strncpy+0x2b>
80104952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104958:	83 c3 01             	add    $0x1,%ebx
8010495b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010495f:	83 c2 01             	add    $0x1,%edx
80104962:	84 c9                	test   %cl,%cl
80104964:	88 4a ff             	mov    %cl,-0x1(%edx)
80104967:	74 09                	je     80104972 <strncpy+0x32>
80104969:	89 f1                	mov    %esi,%ecx
8010496b:	85 c9                	test   %ecx,%ecx
8010496d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104970:	7f e6                	jg     80104958 <strncpy+0x18>
    ;
  while(n-- > 0)
80104972:	31 c9                	xor    %ecx,%ecx
80104974:	85 f6                	test   %esi,%esi
80104976:	7e 0f                	jle    80104987 <strncpy+0x47>
    *s++ = 0;
80104978:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010497c:	89 f3                	mov    %esi,%ebx
8010497e:	83 c1 01             	add    $0x1,%ecx
80104981:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104983:	85 db                	test   %ebx,%ebx
80104985:	7f f1                	jg     80104978 <strncpy+0x38>
  return os;
}
80104987:	5b                   	pop    %ebx
80104988:	5e                   	pop    %esi
80104989:	5d                   	pop    %ebp
8010498a:	c3                   	ret    
8010498b:	90                   	nop
8010498c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104990 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104990:	55                   	push   %ebp
80104991:	89 e5                	mov    %esp,%ebp
80104993:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104996:	56                   	push   %esi
80104997:	8b 45 08             	mov    0x8(%ebp),%eax
8010499a:	53                   	push   %ebx
8010499b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010499e:	85 c9                	test   %ecx,%ecx
801049a0:	7e 26                	jle    801049c8 <safestrcpy+0x38>
801049a2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801049a6:	89 c1                	mov    %eax,%ecx
801049a8:	eb 17                	jmp    801049c1 <safestrcpy+0x31>
801049aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801049b0:	83 c2 01             	add    $0x1,%edx
801049b3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801049b7:	83 c1 01             	add    $0x1,%ecx
801049ba:	84 db                	test   %bl,%bl
801049bc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801049bf:	74 04                	je     801049c5 <safestrcpy+0x35>
801049c1:	39 f2                	cmp    %esi,%edx
801049c3:	75 eb                	jne    801049b0 <safestrcpy+0x20>
    ;
  *s = 0;
801049c5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801049c8:	5b                   	pop    %ebx
801049c9:	5e                   	pop    %esi
801049ca:	5d                   	pop    %ebp
801049cb:	c3                   	ret    
801049cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049d0 <strlen>:

int
strlen(const char *s)
{
801049d0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801049d1:	31 c0                	xor    %eax,%eax
{
801049d3:	89 e5                	mov    %esp,%ebp
801049d5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801049d8:	80 3a 00             	cmpb   $0x0,(%edx)
801049db:	74 0c                	je     801049e9 <strlen+0x19>
801049dd:	8d 76 00             	lea    0x0(%esi),%esi
801049e0:	83 c0 01             	add    $0x1,%eax
801049e3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801049e7:	75 f7                	jne    801049e0 <strlen+0x10>
    ;
  return n;
}
801049e9:	5d                   	pop    %ebp
801049ea:	c3                   	ret    

801049eb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801049eb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801049ef:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801049f3:	55                   	push   %ebp
  pushl %ebx
801049f4:	53                   	push   %ebx
  pushl %esi
801049f5:	56                   	push   %esi
  pushl %edi
801049f6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801049f7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801049f9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801049fb:	5f                   	pop    %edi
  popl %esi
801049fc:	5e                   	pop    %esi
  popl %ebx
801049fd:	5b                   	pop    %ebx
  popl %ebp
801049fe:	5d                   	pop    %ebp
  ret
801049ff:	c3                   	ret    

80104a00 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	53                   	push   %ebx
80104a04:	83 ec 04             	sub    $0x4,%esp
80104a07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a0a:	e8 d1 ec ff ff       	call   801036e0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a0f:	8b 40 04             	mov    0x4(%eax),%eax
80104a12:	39 d8                	cmp    %ebx,%eax
80104a14:	76 1a                	jbe    80104a30 <fetchint+0x30>
80104a16:	8d 53 04             	lea    0x4(%ebx),%edx
80104a19:	39 d0                	cmp    %edx,%eax
80104a1b:	72 13                	jb     80104a30 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104a1d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a20:	8b 13                	mov    (%ebx),%edx
80104a22:	89 10                	mov    %edx,(%eax)
  return 0;
80104a24:	31 c0                	xor    %eax,%eax
}
80104a26:	83 c4 04             	add    $0x4,%esp
80104a29:	5b                   	pop    %ebx
80104a2a:	5d                   	pop    %ebp
80104a2b:	c3                   	ret    
80104a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a35:	eb ef                	jmp    80104a26 <fetchint+0x26>
80104a37:	89 f6                	mov    %esi,%esi
80104a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a40 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	53                   	push   %ebx
80104a44:	83 ec 04             	sub    $0x4,%esp
80104a47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a4a:	e8 91 ec ff ff       	call   801036e0 <myproc>

  if(addr >= curproc->sz)
80104a4f:	39 58 04             	cmp    %ebx,0x4(%eax)
80104a52:	76 28                	jbe    80104a7c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104a54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104a57:	89 da                	mov    %ebx,%edx
80104a59:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104a5b:	8b 40 04             	mov    0x4(%eax),%eax
  for(s = *pp; s < ep; s++){
80104a5e:	39 c3                	cmp    %eax,%ebx
80104a60:	73 1a                	jae    80104a7c <fetchstr+0x3c>
    if(*s == 0)
80104a62:	80 3b 00             	cmpb   $0x0,(%ebx)
80104a65:	75 0e                	jne    80104a75 <fetchstr+0x35>
80104a67:	eb 1f                	jmp    80104a88 <fetchstr+0x48>
80104a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a70:	80 3a 00             	cmpb   $0x0,(%edx)
80104a73:	74 13                	je     80104a88 <fetchstr+0x48>
  for(s = *pp; s < ep; s++){
80104a75:	83 c2 01             	add    $0x1,%edx
80104a78:	39 d0                	cmp    %edx,%eax
80104a7a:	77 f4                	ja     80104a70 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104a7c:	83 c4 04             	add    $0x4,%esp
    return -1;
80104a7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a84:	5b                   	pop    %ebx
80104a85:	5d                   	pop    %ebp
80104a86:	c3                   	ret    
80104a87:	90                   	nop
80104a88:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104a8b:	89 d0                	mov    %edx,%eax
80104a8d:	29 d8                	sub    %ebx,%eax
}
80104a8f:	5b                   	pop    %ebx
80104a90:	5d                   	pop    %ebp
80104a91:	c3                   	ret    
80104a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104aa0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	56                   	push   %esi
80104aa4:	8b 75 0c             	mov    0xc(%ebp),%esi
80104aa7:	53                   	push   %ebx
80104aa8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104aab:	e8 30 ec ff ff       	call   801036e0 <myproc>
80104ab0:	89 75 0c             	mov    %esi,0xc(%ebp)
80104ab3:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ab6:	8b 40 44             	mov    0x44(%eax),%eax
80104ab9:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
80104abd:	89 45 08             	mov    %eax,0x8(%ebp)
}
80104ac0:	5b                   	pop    %ebx
80104ac1:	5e                   	pop    %esi
80104ac2:	5d                   	pop    %ebp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ac3:	e9 38 ff ff ff       	jmp    80104a00 <fetchint>
80104ac8:	90                   	nop
80104ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ad0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	56                   	push   %esi
80104ad4:	53                   	push   %ebx
80104ad5:	83 ec 20             	sub    $0x20,%esp
80104ad8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104adb:	e8 00 ec ff ff       	call   801036e0 <myproc>
80104ae0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104ae2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ae5:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ae9:	8b 45 08             	mov    0x8(%ebp),%eax
80104aec:	89 04 24             	mov    %eax,(%esp)
80104aef:	e8 ac ff ff ff       	call   80104aa0 <argint>
80104af4:	85 c0                	test   %eax,%eax
80104af6:	78 28                	js     80104b20 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104af8:	85 db                	test   %ebx,%ebx
80104afa:	78 24                	js     80104b20 <argptr+0x50>
80104afc:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104aff:	8b 46 04             	mov    0x4(%esi),%eax
80104b02:	39 c2                	cmp    %eax,%edx
80104b04:	73 1a                	jae    80104b20 <argptr+0x50>
80104b06:	01 d3                	add    %edx,%ebx
80104b08:	39 d8                	cmp    %ebx,%eax
80104b0a:	72 14                	jb     80104b20 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b0f:	89 10                	mov    %edx,(%eax)
  return 0;
}
80104b11:	83 c4 20             	add    $0x20,%esp
  return 0;
80104b14:	31 c0                	xor    %eax,%eax
}
80104b16:	5b                   	pop    %ebx
80104b17:	5e                   	pop    %esi
80104b18:	5d                   	pop    %ebp
80104b19:	c3                   	ret    
80104b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b20:	83 c4 20             	add    $0x20,%esp
    return -1;
80104b23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b28:	5b                   	pop    %ebx
80104b29:	5e                   	pop    %esi
80104b2a:	5d                   	pop    %ebp
80104b2b:	c3                   	ret    
80104b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b30 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104b36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b39:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b3d:	8b 45 08             	mov    0x8(%ebp),%eax
80104b40:	89 04 24             	mov    %eax,(%esp)
80104b43:	e8 58 ff ff ff       	call   80104aa0 <argint>
80104b48:	85 c0                	test   %eax,%eax
80104b4a:	78 14                	js     80104b60 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b56:	89 04 24             	mov    %eax,(%esp)
80104b59:	e8 e2 fe ff ff       	call   80104a40 <fetchstr>
}
80104b5e:	c9                   	leave  
80104b5f:	c3                   	ret    
    return -1;
80104b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b65:	c9                   	leave  
80104b66:	c3                   	ret    
80104b67:	89 f6                	mov    %esi,%esi
80104b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b70 <syscall>:
[SYS_getTurnTime] sys_getTurnTime,  //lab2
};

void
syscall(void)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	56                   	push   %esi
80104b74:	53                   	push   %ebx
80104b75:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104b78:	e8 63 eb ff ff       	call   801036e0 <myproc>

  num = curproc->tf->eax;
80104b7d:	8b 70 1c             	mov    0x1c(%eax),%esi
  struct proc *curproc = myproc();
80104b80:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
80104b82:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104b85:	8d 50 ff             	lea    -0x1(%eax),%edx
80104b88:	83 fa 1c             	cmp    $0x1c,%edx
80104b8b:	77 1b                	ja     80104ba8 <syscall+0x38>
80104b8d:	8b 14 85 c0 79 10 80 	mov    -0x7fef8640(,%eax,4),%edx
80104b94:	85 d2                	test   %edx,%edx
80104b96:	74 10                	je     80104ba8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104b98:	ff d2                	call   *%edx
80104b9a:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104b9d:	83 c4 10             	add    $0x10,%esp
80104ba0:	5b                   	pop    %ebx
80104ba1:	5e                   	pop    %esi
80104ba2:	5d                   	pop    %ebp
80104ba3:	c3                   	ret    
80104ba4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104ba8:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
80104bac:	8d 43 70             	lea    0x70(%ebx),%eax
80104baf:	89 44 24 08          	mov    %eax,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
80104bb3:	8b 43 14             	mov    0x14(%ebx),%eax
80104bb6:	c7 04 24 89 79 10 80 	movl   $0x80107989,(%esp)
80104bbd:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bc1:	e8 8a ba ff ff       	call   80100650 <cprintf>
    curproc->tf->eax = -1;
80104bc6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104bc9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104bd0:	83 c4 10             	add    $0x10,%esp
80104bd3:	5b                   	pop    %ebx
80104bd4:	5e                   	pop    %esi
80104bd5:	5d                   	pop    %ebp
80104bd6:	c3                   	ret    
80104bd7:	66 90                	xchg   %ax,%ax
80104bd9:	66 90                	xchg   %ax,%ax
80104bdb:	66 90                	xchg   %ax,%ax
80104bdd:	66 90                	xchg   %ax,%ax
80104bdf:	90                   	nop

80104be0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	53                   	push   %ebx
80104be4:	89 c3                	mov    %eax,%ebx
80104be6:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
80104be9:	e8 f2 ea ff ff       	call   801036e0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80104bee:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
80104bf0:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
80104bf4:	85 c9                	test   %ecx,%ecx
80104bf6:	74 18                	je     80104c10 <fdalloc+0x30>
  for(fd = 0; fd < NOFILE; fd++){
80104bf8:	83 c2 01             	add    $0x1,%edx
80104bfb:	83 fa 10             	cmp    $0x10,%edx
80104bfe:	75 f0                	jne    80104bf0 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
80104c00:	83 c4 04             	add    $0x4,%esp
  return -1;
80104c03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c08:	5b                   	pop    %ebx
80104c09:	5d                   	pop    %ebp
80104c0a:	c3                   	ret    
80104c0b:	90                   	nop
80104c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80104c10:	89 5c 90 2c          	mov    %ebx,0x2c(%eax,%edx,4)
}
80104c14:	83 c4 04             	add    $0x4,%esp
      return fd;
80104c17:	89 d0                	mov    %edx,%eax
}
80104c19:	5b                   	pop    %ebx
80104c1a:	5d                   	pop    %ebp
80104c1b:	c3                   	ret    
80104c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c20 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	57                   	push   %edi
80104c24:	56                   	push   %esi
80104c25:	53                   	push   %ebx
80104c26:	83 ec 3c             	sub    $0x3c,%esp
80104c29:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104c2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104c2f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104c32:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c36:	89 04 24             	mov    %eax,(%esp)
{
80104c39:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104c3c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104c3f:	e8 ec d2 ff ff       	call   80101f30 <nameiparent>
80104c44:	85 c0                	test   %eax,%eax
80104c46:	89 c7                	mov    %eax,%edi
80104c48:	0f 84 da 00 00 00    	je     80104d28 <create+0x108>
    return 0;
  ilock(dp);
80104c4e:	89 04 24             	mov    %eax,(%esp)
80104c51:	e8 6a ca ff ff       	call   801016c0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104c56:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80104c5d:	00 
80104c5e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c62:	89 3c 24             	mov    %edi,(%esp)
80104c65:	e8 66 cf ff ff       	call   80101bd0 <dirlookup>
80104c6a:	85 c0                	test   %eax,%eax
80104c6c:	89 c6                	mov    %eax,%esi
80104c6e:	74 40                	je     80104cb0 <create+0x90>
    iunlockput(dp);
80104c70:	89 3c 24             	mov    %edi,(%esp)
80104c73:	e8 a8 cc ff ff       	call   80101920 <iunlockput>
    ilock(ip);
80104c78:	89 34 24             	mov    %esi,(%esp)
80104c7b:	e8 40 ca ff ff       	call   801016c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104c80:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104c85:	75 11                	jne    80104c98 <create+0x78>
80104c87:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104c8c:	89 f0                	mov    %esi,%eax
80104c8e:	75 08                	jne    80104c98 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c90:	83 c4 3c             	add    $0x3c,%esp
80104c93:	5b                   	pop    %ebx
80104c94:	5e                   	pop    %esi
80104c95:	5f                   	pop    %edi
80104c96:	5d                   	pop    %ebp
80104c97:	c3                   	ret    
    iunlockput(ip);
80104c98:	89 34 24             	mov    %esi,(%esp)
80104c9b:	e8 80 cc ff ff       	call   80101920 <iunlockput>
}
80104ca0:	83 c4 3c             	add    $0x3c,%esp
    return 0;
80104ca3:	31 c0                	xor    %eax,%eax
}
80104ca5:	5b                   	pop    %ebx
80104ca6:	5e                   	pop    %esi
80104ca7:	5f                   	pop    %edi
80104ca8:	5d                   	pop    %ebp
80104ca9:	c3                   	ret    
80104caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80104cb0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104cb4:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cb8:	8b 07                	mov    (%edi),%eax
80104cba:	89 04 24             	mov    %eax,(%esp)
80104cbd:	e8 6e c8 ff ff       	call   80101530 <ialloc>
80104cc2:	85 c0                	test   %eax,%eax
80104cc4:	89 c6                	mov    %eax,%esi
80104cc6:	0f 84 bf 00 00 00    	je     80104d8b <create+0x16b>
  ilock(ip);
80104ccc:	89 04 24             	mov    %eax,(%esp)
80104ccf:	e8 ec c9 ff ff       	call   801016c0 <ilock>
  ip->major = major;
80104cd4:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104cd8:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104cdc:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104ce0:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104ce4:	b8 01 00 00 00       	mov    $0x1,%eax
80104ce9:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104ced:	89 34 24             	mov    %esi,(%esp)
80104cf0:	e8 0b c9 ff ff       	call   80101600 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104cf5:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104cfa:	74 34                	je     80104d30 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104cfc:	8b 46 04             	mov    0x4(%esi),%eax
80104cff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d03:	89 3c 24             	mov    %edi,(%esp)
80104d06:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d0a:	e8 21 d1 ff ff       	call   80101e30 <dirlink>
80104d0f:	85 c0                	test   %eax,%eax
80104d11:	78 6c                	js     80104d7f <create+0x15f>
  iunlockput(dp);
80104d13:	89 3c 24             	mov    %edi,(%esp)
80104d16:	e8 05 cc ff ff       	call   80101920 <iunlockput>
}
80104d1b:	83 c4 3c             	add    $0x3c,%esp
  return ip;
80104d1e:	89 f0                	mov    %esi,%eax
}
80104d20:	5b                   	pop    %ebx
80104d21:	5e                   	pop    %esi
80104d22:	5f                   	pop    %edi
80104d23:	5d                   	pop    %ebp
80104d24:	c3                   	ret    
80104d25:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
80104d28:	31 c0                	xor    %eax,%eax
80104d2a:	e9 61 ff ff ff       	jmp    80104c90 <create+0x70>
80104d2f:	90                   	nop
    dp->nlink++;  // for ".."
80104d30:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104d35:	89 3c 24             	mov    %edi,(%esp)
80104d38:	e8 c3 c8 ff ff       	call   80101600 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104d3d:	8b 46 04             	mov    0x4(%esi),%eax
80104d40:	c7 44 24 04 54 7a 10 	movl   $0x80107a54,0x4(%esp)
80104d47:	80 
80104d48:	89 34 24             	mov    %esi,(%esp)
80104d4b:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d4f:	e8 dc d0 ff ff       	call   80101e30 <dirlink>
80104d54:	85 c0                	test   %eax,%eax
80104d56:	78 1b                	js     80104d73 <create+0x153>
80104d58:	8b 47 04             	mov    0x4(%edi),%eax
80104d5b:	c7 44 24 04 53 7a 10 	movl   $0x80107a53,0x4(%esp)
80104d62:	80 
80104d63:	89 34 24             	mov    %esi,(%esp)
80104d66:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d6a:	e8 c1 d0 ff ff       	call   80101e30 <dirlink>
80104d6f:	85 c0                	test   %eax,%eax
80104d71:	79 89                	jns    80104cfc <create+0xdc>
      panic("create dots");
80104d73:	c7 04 24 47 7a 10 80 	movl   $0x80107a47,(%esp)
80104d7a:	e8 e1 b5 ff ff       	call   80100360 <panic>
    panic("create: dirlink");
80104d7f:	c7 04 24 56 7a 10 80 	movl   $0x80107a56,(%esp)
80104d86:	e8 d5 b5 ff ff       	call   80100360 <panic>
    panic("create: ialloc");
80104d8b:	c7 04 24 38 7a 10 80 	movl   $0x80107a38,(%esp)
80104d92:	e8 c9 b5 ff ff       	call   80100360 <panic>
80104d97:	89 f6                	mov    %esi,%esi
80104d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104da0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	56                   	push   %esi
80104da4:	89 c6                	mov    %eax,%esi
80104da6:	53                   	push   %ebx
80104da7:	89 d3                	mov    %edx,%ebx
80104da9:	83 ec 20             	sub    $0x20,%esp
  if(argint(n, &fd) < 0)
80104dac:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104daf:	89 44 24 04          	mov    %eax,0x4(%esp)
80104db3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104dba:	e8 e1 fc ff ff       	call   80104aa0 <argint>
80104dbf:	85 c0                	test   %eax,%eax
80104dc1:	78 2d                	js     80104df0 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dc3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104dc7:	77 27                	ja     80104df0 <argfd.constprop.0+0x50>
80104dc9:	e8 12 e9 ff ff       	call   801036e0 <myproc>
80104dce:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104dd1:	8b 44 90 2c          	mov    0x2c(%eax,%edx,4),%eax
80104dd5:	85 c0                	test   %eax,%eax
80104dd7:	74 17                	je     80104df0 <argfd.constprop.0+0x50>
  if(pfd)
80104dd9:	85 f6                	test   %esi,%esi
80104ddb:	74 02                	je     80104ddf <argfd.constprop.0+0x3f>
    *pfd = fd;
80104ddd:	89 16                	mov    %edx,(%esi)
  if(pf)
80104ddf:	85 db                	test   %ebx,%ebx
80104de1:	74 1d                	je     80104e00 <argfd.constprop.0+0x60>
    *pf = f;
80104de3:	89 03                	mov    %eax,(%ebx)
  return 0;
80104de5:	31 c0                	xor    %eax,%eax
}
80104de7:	83 c4 20             	add    $0x20,%esp
80104dea:	5b                   	pop    %ebx
80104deb:	5e                   	pop    %esi
80104dec:	5d                   	pop    %ebp
80104ded:	c3                   	ret    
80104dee:	66 90                	xchg   %ax,%ax
80104df0:	83 c4 20             	add    $0x20,%esp
    return -1;
80104df3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104df8:	5b                   	pop    %ebx
80104df9:	5e                   	pop    %esi
80104dfa:	5d                   	pop    %ebp
80104dfb:	c3                   	ret    
80104dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 0;
80104e00:	31 c0                	xor    %eax,%eax
80104e02:	eb e3                	jmp    80104de7 <argfd.constprop.0+0x47>
80104e04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104e10 <sys_dup>:
{
80104e10:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104e11:	31 c0                	xor    %eax,%eax
{
80104e13:	89 e5                	mov    %esp,%ebp
80104e15:	53                   	push   %ebx
80104e16:	83 ec 24             	sub    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
80104e19:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104e1c:	e8 7f ff ff ff       	call   80104da0 <argfd.constprop.0>
80104e21:	85 c0                	test   %eax,%eax
80104e23:	78 23                	js     80104e48 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e28:	e8 b3 fd ff ff       	call   80104be0 <fdalloc>
80104e2d:	85 c0                	test   %eax,%eax
80104e2f:	89 c3                	mov    %eax,%ebx
80104e31:	78 15                	js     80104e48 <sys_dup+0x38>
  filedup(f);
80104e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e36:	89 04 24             	mov    %eax,(%esp)
80104e39:	e8 b2 bf ff ff       	call   80100df0 <filedup>
  return fd;
80104e3e:	89 d8                	mov    %ebx,%eax
}
80104e40:	83 c4 24             	add    $0x24,%esp
80104e43:	5b                   	pop    %ebx
80104e44:	5d                   	pop    %ebp
80104e45:	c3                   	ret    
80104e46:	66 90                	xchg   %ax,%ax
    return -1;
80104e48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e4d:	eb f1                	jmp    80104e40 <sys_dup+0x30>
80104e4f:	90                   	nop

80104e50 <sys_read>:
{
80104e50:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e51:	31 c0                	xor    %eax,%eax
{
80104e53:	89 e5                	mov    %esp,%ebp
80104e55:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e58:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e5b:	e8 40 ff ff ff       	call   80104da0 <argfd.constprop.0>
80104e60:	85 c0                	test   %eax,%eax
80104e62:	78 54                	js     80104eb8 <sys_read+0x68>
80104e64:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e67:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e6b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104e72:	e8 29 fc ff ff       	call   80104aa0 <argint>
80104e77:	85 c0                	test   %eax,%eax
80104e79:	78 3d                	js     80104eb8 <sys_read+0x68>
80104e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e85:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e89:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e90:	e8 3b fc ff ff       	call   80104ad0 <argptr>
80104e95:	85 c0                	test   %eax,%eax
80104e97:	78 1f                	js     80104eb8 <sys_read+0x68>
  return fileread(f, p, n);
80104e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e9c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ea3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ea7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104eaa:	89 04 24             	mov    %eax,(%esp)
80104ead:	e8 9e c0 ff ff       	call   80100f50 <fileread>
}
80104eb2:	c9                   	leave  
80104eb3:	c3                   	ret    
80104eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104eb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ebd:	c9                   	leave  
80104ebe:	c3                   	ret    
80104ebf:	90                   	nop

80104ec0 <sys_write>:
{
80104ec0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ec1:	31 c0                	xor    %eax,%eax
{
80104ec3:	89 e5                	mov    %esp,%ebp
80104ec5:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ec8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104ecb:	e8 d0 fe ff ff       	call   80104da0 <argfd.constprop.0>
80104ed0:	85 c0                	test   %eax,%eax
80104ed2:	78 54                	js     80104f28 <sys_write+0x68>
80104ed4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ed7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104edb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104ee2:	e8 b9 fb ff ff       	call   80104aa0 <argint>
80104ee7:	85 c0                	test   %eax,%eax
80104ee9:	78 3d                	js     80104f28 <sys_write+0x68>
80104eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104eee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104ef5:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ef9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104efc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f00:	e8 cb fb ff ff       	call   80104ad0 <argptr>
80104f05:	85 c0                	test   %eax,%eax
80104f07:	78 1f                	js     80104f28 <sys_write+0x68>
  return filewrite(f, p, n);
80104f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f0c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f13:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f17:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f1a:	89 04 24             	mov    %eax,(%esp)
80104f1d:	e8 ce c0 ff ff       	call   80100ff0 <filewrite>
}
80104f22:	c9                   	leave  
80104f23:	c3                   	ret    
80104f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f2d:	c9                   	leave  
80104f2e:	c3                   	ret    
80104f2f:	90                   	nop

80104f30 <sys_close>:
{
80104f30:	55                   	push   %ebp
80104f31:	89 e5                	mov    %esp,%ebp
80104f33:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
80104f36:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104f39:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f3c:	e8 5f fe ff ff       	call   80104da0 <argfd.constprop.0>
80104f41:	85 c0                	test   %eax,%eax
80104f43:	78 23                	js     80104f68 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
80104f45:	e8 96 e7 ff ff       	call   801036e0 <myproc>
80104f4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104f4d:	c7 44 90 2c 00 00 00 	movl   $0x0,0x2c(%eax,%edx,4)
80104f54:	00 
  fileclose(f);
80104f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f58:	89 04 24             	mov    %eax,(%esp)
80104f5b:	e8 e0 be ff ff       	call   80100e40 <fileclose>
  return 0;
80104f60:	31 c0                	xor    %eax,%eax
}
80104f62:	c9                   	leave  
80104f63:	c3                   	ret    
80104f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f6d:	c9                   	leave  
80104f6e:	c3                   	ret    
80104f6f:	90                   	nop

80104f70 <sys_fstat>:
{
80104f70:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f71:	31 c0                	xor    %eax,%eax
{
80104f73:	89 e5                	mov    %esp,%ebp
80104f75:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f78:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104f7b:	e8 20 fe ff ff       	call   80104da0 <argfd.constprop.0>
80104f80:	85 c0                	test   %eax,%eax
80104f82:	78 34                	js     80104fb8 <sys_fstat+0x48>
80104f84:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f87:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104f8e:	00 
80104f8f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f93:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f9a:	e8 31 fb ff ff       	call   80104ad0 <argptr>
80104f9f:	85 c0                	test   %eax,%eax
80104fa1:	78 15                	js     80104fb8 <sys_fstat+0x48>
  return filestat(f, st);
80104fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fa6:	89 44 24 04          	mov    %eax,0x4(%esp)
80104faa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fad:	89 04 24             	mov    %eax,(%esp)
80104fb0:	e8 4b bf ff ff       	call   80100f00 <filestat>
}
80104fb5:	c9                   	leave  
80104fb6:	c3                   	ret    
80104fb7:	90                   	nop
    return -1;
80104fb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fbd:	c9                   	leave  
80104fbe:	c3                   	ret    
80104fbf:	90                   	nop

80104fc0 <sys_link>:
{
80104fc0:	55                   	push   %ebp
80104fc1:	89 e5                	mov    %esp,%ebp
80104fc3:	57                   	push   %edi
80104fc4:	56                   	push   %esi
80104fc5:	53                   	push   %ebx
80104fc6:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104fc9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104fcc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fd0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fd7:	e8 54 fb ff ff       	call   80104b30 <argstr>
80104fdc:	85 c0                	test   %eax,%eax
80104fde:	0f 88 e6 00 00 00    	js     801050ca <sys_link+0x10a>
80104fe4:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104fe7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104feb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104ff2:	e8 39 fb ff ff       	call   80104b30 <argstr>
80104ff7:	85 c0                	test   %eax,%eax
80104ff9:	0f 88 cb 00 00 00    	js     801050ca <sys_link+0x10a>
  begin_op();
80104fff:	e8 1c db ff ff       	call   80102b20 <begin_op>
  if((ip = namei(old)) == 0){
80105004:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105007:	89 04 24             	mov    %eax,(%esp)
8010500a:	e8 01 cf ff ff       	call   80101f10 <namei>
8010500f:	85 c0                	test   %eax,%eax
80105011:	89 c3                	mov    %eax,%ebx
80105013:	0f 84 ac 00 00 00    	je     801050c5 <sys_link+0x105>
  ilock(ip);
80105019:	89 04 24             	mov    %eax,(%esp)
8010501c:	e8 9f c6 ff ff       	call   801016c0 <ilock>
  if(ip->type == T_DIR){
80105021:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105026:	0f 84 91 00 00 00    	je     801050bd <sys_link+0xfd>
  ip->nlink++;
8010502c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105031:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105034:	89 1c 24             	mov    %ebx,(%esp)
80105037:	e8 c4 c5 ff ff       	call   80101600 <iupdate>
  iunlock(ip);
8010503c:	89 1c 24             	mov    %ebx,(%esp)
8010503f:	e8 5c c7 ff ff       	call   801017a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105044:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105047:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010504b:	89 04 24             	mov    %eax,(%esp)
8010504e:	e8 dd ce ff ff       	call   80101f30 <nameiparent>
80105053:	85 c0                	test   %eax,%eax
80105055:	89 c6                	mov    %eax,%esi
80105057:	74 4f                	je     801050a8 <sys_link+0xe8>
  ilock(dp);
80105059:	89 04 24             	mov    %eax,(%esp)
8010505c:	e8 5f c6 ff ff       	call   801016c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105061:	8b 03                	mov    (%ebx),%eax
80105063:	39 06                	cmp    %eax,(%esi)
80105065:	75 39                	jne    801050a0 <sys_link+0xe0>
80105067:	8b 43 04             	mov    0x4(%ebx),%eax
8010506a:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010506e:	89 34 24             	mov    %esi,(%esp)
80105071:	89 44 24 08          	mov    %eax,0x8(%esp)
80105075:	e8 b6 cd ff ff       	call   80101e30 <dirlink>
8010507a:	85 c0                	test   %eax,%eax
8010507c:	78 22                	js     801050a0 <sys_link+0xe0>
  iunlockput(dp);
8010507e:	89 34 24             	mov    %esi,(%esp)
80105081:	e8 9a c8 ff ff       	call   80101920 <iunlockput>
  iput(ip);
80105086:	89 1c 24             	mov    %ebx,(%esp)
80105089:	e8 52 c7 ff ff       	call   801017e0 <iput>
  end_op();
8010508e:	e8 fd da ff ff       	call   80102b90 <end_op>
}
80105093:	83 c4 3c             	add    $0x3c,%esp
  return 0;
80105096:	31 c0                	xor    %eax,%eax
}
80105098:	5b                   	pop    %ebx
80105099:	5e                   	pop    %esi
8010509a:	5f                   	pop    %edi
8010509b:	5d                   	pop    %ebp
8010509c:	c3                   	ret    
8010509d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801050a0:	89 34 24             	mov    %esi,(%esp)
801050a3:	e8 78 c8 ff ff       	call   80101920 <iunlockput>
  ilock(ip);
801050a8:	89 1c 24             	mov    %ebx,(%esp)
801050ab:	e8 10 c6 ff ff       	call   801016c0 <ilock>
  ip->nlink--;
801050b0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801050b5:	89 1c 24             	mov    %ebx,(%esp)
801050b8:	e8 43 c5 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
801050bd:	89 1c 24             	mov    %ebx,(%esp)
801050c0:	e8 5b c8 ff ff       	call   80101920 <iunlockput>
  end_op();
801050c5:	e8 c6 da ff ff       	call   80102b90 <end_op>
}
801050ca:	83 c4 3c             	add    $0x3c,%esp
  return -1;
801050cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050d2:	5b                   	pop    %ebx
801050d3:	5e                   	pop    %esi
801050d4:	5f                   	pop    %edi
801050d5:	5d                   	pop    %ebp
801050d6:	c3                   	ret    
801050d7:	89 f6                	mov    %esi,%esi
801050d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050e0 <sys_unlink>:
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	57                   	push   %edi
801050e4:	56                   	push   %esi
801050e5:	53                   	push   %ebx
801050e6:	83 ec 5c             	sub    $0x5c,%esp
  if(argstr(0, &path) < 0)
801050e9:	8d 45 c0             	lea    -0x40(%ebp),%eax
801050ec:	89 44 24 04          	mov    %eax,0x4(%esp)
801050f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050f7:	e8 34 fa ff ff       	call   80104b30 <argstr>
801050fc:	85 c0                	test   %eax,%eax
801050fe:	0f 88 76 01 00 00    	js     8010527a <sys_unlink+0x19a>
  begin_op();
80105104:	e8 17 da ff ff       	call   80102b20 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105109:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010510c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010510f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105113:	89 04 24             	mov    %eax,(%esp)
80105116:	e8 15 ce ff ff       	call   80101f30 <nameiparent>
8010511b:	85 c0                	test   %eax,%eax
8010511d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105120:	0f 84 4f 01 00 00    	je     80105275 <sys_unlink+0x195>
  ilock(dp);
80105126:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105129:	89 34 24             	mov    %esi,(%esp)
8010512c:	e8 8f c5 ff ff       	call   801016c0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105131:	c7 44 24 04 54 7a 10 	movl   $0x80107a54,0x4(%esp)
80105138:	80 
80105139:	89 1c 24             	mov    %ebx,(%esp)
8010513c:	e8 5f ca ff ff       	call   80101ba0 <namecmp>
80105141:	85 c0                	test   %eax,%eax
80105143:	0f 84 21 01 00 00    	je     8010526a <sys_unlink+0x18a>
80105149:	c7 44 24 04 53 7a 10 	movl   $0x80107a53,0x4(%esp)
80105150:	80 
80105151:	89 1c 24             	mov    %ebx,(%esp)
80105154:	e8 47 ca ff ff       	call   80101ba0 <namecmp>
80105159:	85 c0                	test   %eax,%eax
8010515b:	0f 84 09 01 00 00    	je     8010526a <sys_unlink+0x18a>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105161:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105164:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105168:	89 44 24 08          	mov    %eax,0x8(%esp)
8010516c:	89 34 24             	mov    %esi,(%esp)
8010516f:	e8 5c ca ff ff       	call   80101bd0 <dirlookup>
80105174:	85 c0                	test   %eax,%eax
80105176:	89 c3                	mov    %eax,%ebx
80105178:	0f 84 ec 00 00 00    	je     8010526a <sys_unlink+0x18a>
  ilock(ip);
8010517e:	89 04 24             	mov    %eax,(%esp)
80105181:	e8 3a c5 ff ff       	call   801016c0 <ilock>
  if(ip->nlink < 1)
80105186:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010518b:	0f 8e 24 01 00 00    	jle    801052b5 <sys_unlink+0x1d5>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105191:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105196:	8d 75 d8             	lea    -0x28(%ebp),%esi
80105199:	74 7d                	je     80105218 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
8010519b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801051a2:	00 
801051a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801051aa:	00 
801051ab:	89 34 24             	mov    %esi,(%esp)
801051ae:	e8 fd f5 ff ff       	call   801047b0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051b3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801051b6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801051bd:	00 
801051be:	89 74 24 04          	mov    %esi,0x4(%esp)
801051c2:	89 44 24 08          	mov    %eax,0x8(%esp)
801051c6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801051c9:	89 04 24             	mov    %eax,(%esp)
801051cc:	e8 9f c8 ff ff       	call   80101a70 <writei>
801051d1:	83 f8 10             	cmp    $0x10,%eax
801051d4:	0f 85 cf 00 00 00    	jne    801052a9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801051da:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051df:	0f 84 a3 00 00 00    	je     80105288 <sys_unlink+0x1a8>
  iunlockput(dp);
801051e5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801051e8:	89 04 24             	mov    %eax,(%esp)
801051eb:	e8 30 c7 ff ff       	call   80101920 <iunlockput>
  ip->nlink--;
801051f0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051f5:	89 1c 24             	mov    %ebx,(%esp)
801051f8:	e8 03 c4 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
801051fd:	89 1c 24             	mov    %ebx,(%esp)
80105200:	e8 1b c7 ff ff       	call   80101920 <iunlockput>
  end_op();
80105205:	e8 86 d9 ff ff       	call   80102b90 <end_op>
}
8010520a:	83 c4 5c             	add    $0x5c,%esp
  return 0;
8010520d:	31 c0                	xor    %eax,%eax
}
8010520f:	5b                   	pop    %ebx
80105210:	5e                   	pop    %esi
80105211:	5f                   	pop    %edi
80105212:	5d                   	pop    %ebp
80105213:	c3                   	ret    
80105214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105218:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
8010521c:	0f 86 79 ff ff ff    	jbe    8010519b <sys_unlink+0xbb>
80105222:	bf 20 00 00 00       	mov    $0x20,%edi
80105227:	eb 15                	jmp    8010523e <sys_unlink+0x15e>
80105229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105230:	8d 57 10             	lea    0x10(%edi),%edx
80105233:	3b 53 58             	cmp    0x58(%ebx),%edx
80105236:	0f 83 5f ff ff ff    	jae    8010519b <sys_unlink+0xbb>
8010523c:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010523e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105245:	00 
80105246:	89 7c 24 08          	mov    %edi,0x8(%esp)
8010524a:	89 74 24 04          	mov    %esi,0x4(%esp)
8010524e:	89 1c 24             	mov    %ebx,(%esp)
80105251:	e8 1a c7 ff ff       	call   80101970 <readi>
80105256:	83 f8 10             	cmp    $0x10,%eax
80105259:	75 42                	jne    8010529d <sys_unlink+0x1bd>
    if(de.inum != 0)
8010525b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105260:	74 ce                	je     80105230 <sys_unlink+0x150>
    iunlockput(ip);
80105262:	89 1c 24             	mov    %ebx,(%esp)
80105265:	e8 b6 c6 ff ff       	call   80101920 <iunlockput>
  iunlockput(dp);
8010526a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010526d:	89 04 24             	mov    %eax,(%esp)
80105270:	e8 ab c6 ff ff       	call   80101920 <iunlockput>
  end_op();
80105275:	e8 16 d9 ff ff       	call   80102b90 <end_op>
}
8010527a:	83 c4 5c             	add    $0x5c,%esp
  return -1;
8010527d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105282:	5b                   	pop    %ebx
80105283:	5e                   	pop    %esi
80105284:	5f                   	pop    %edi
80105285:	5d                   	pop    %ebp
80105286:	c3                   	ret    
80105287:	90                   	nop
    dp->nlink--;
80105288:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010528b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80105290:	89 04 24             	mov    %eax,(%esp)
80105293:	e8 68 c3 ff ff       	call   80101600 <iupdate>
80105298:	e9 48 ff ff ff       	jmp    801051e5 <sys_unlink+0x105>
      panic("isdirempty: readi");
8010529d:	c7 04 24 78 7a 10 80 	movl   $0x80107a78,(%esp)
801052a4:	e8 b7 b0 ff ff       	call   80100360 <panic>
    panic("unlink: writei");
801052a9:	c7 04 24 8a 7a 10 80 	movl   $0x80107a8a,(%esp)
801052b0:	e8 ab b0 ff ff       	call   80100360 <panic>
    panic("unlink: nlink < 1");
801052b5:	c7 04 24 66 7a 10 80 	movl   $0x80107a66,(%esp)
801052bc:	e8 9f b0 ff ff       	call   80100360 <panic>
801052c1:	eb 0d                	jmp    801052d0 <sys_open>
801052c3:	90                   	nop
801052c4:	90                   	nop
801052c5:	90                   	nop
801052c6:	90                   	nop
801052c7:	90                   	nop
801052c8:	90                   	nop
801052c9:	90                   	nop
801052ca:	90                   	nop
801052cb:	90                   	nop
801052cc:	90                   	nop
801052cd:	90                   	nop
801052ce:	90                   	nop
801052cf:	90                   	nop

801052d0 <sys_open>:

int
sys_open(void)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	57                   	push   %edi
801052d4:	56                   	push   %esi
801052d5:	53                   	push   %ebx
801052d6:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052d9:	8d 45 e0             	lea    -0x20(%ebp),%eax
801052dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801052e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052e7:	e8 44 f8 ff ff       	call   80104b30 <argstr>
801052ec:	85 c0                	test   %eax,%eax
801052ee:	0f 88 d1 00 00 00    	js     801053c5 <sys_open+0xf5>
801052f4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801052f7:	89 44 24 04          	mov    %eax,0x4(%esp)
801052fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105302:	e8 99 f7 ff ff       	call   80104aa0 <argint>
80105307:	85 c0                	test   %eax,%eax
80105309:	0f 88 b6 00 00 00    	js     801053c5 <sys_open+0xf5>
    return -1;

  begin_op();
8010530f:	e8 0c d8 ff ff       	call   80102b20 <begin_op>

  if(omode & O_CREATE){
80105314:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105318:	0f 85 82 00 00 00    	jne    801053a0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010531e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105321:	89 04 24             	mov    %eax,(%esp)
80105324:	e8 e7 cb ff ff       	call   80101f10 <namei>
80105329:	85 c0                	test   %eax,%eax
8010532b:	89 c6                	mov    %eax,%esi
8010532d:	0f 84 8d 00 00 00    	je     801053c0 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80105333:	89 04 24             	mov    %eax,(%esp)
80105336:	e8 85 c3 ff ff       	call   801016c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
8010533b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105340:	0f 84 92 00 00 00    	je     801053d8 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105346:	e8 35 ba ff ff       	call   80100d80 <filealloc>
8010534b:	85 c0                	test   %eax,%eax
8010534d:	89 c3                	mov    %eax,%ebx
8010534f:	0f 84 93 00 00 00    	je     801053e8 <sys_open+0x118>
80105355:	e8 86 f8 ff ff       	call   80104be0 <fdalloc>
8010535a:	85 c0                	test   %eax,%eax
8010535c:	89 c7                	mov    %eax,%edi
8010535e:	0f 88 94 00 00 00    	js     801053f8 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105364:	89 34 24             	mov    %esi,(%esp)
80105367:	e8 34 c4 ff ff       	call   801017a0 <iunlock>
  end_op();
8010536c:	e8 1f d8 ff ff       	call   80102b90 <end_op>

  f->type = FD_INODE;
80105371:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105377:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f->ip = ip;
8010537a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
8010537d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80105384:	89 c2                	mov    %eax,%edx
80105386:	83 e2 01             	and    $0x1,%edx
80105389:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010538c:	a8 03                	test   $0x3,%al
  f->readable = !(omode & O_WRONLY);
8010538e:	88 53 08             	mov    %dl,0x8(%ebx)
  return fd;
80105391:	89 f8                	mov    %edi,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105393:	0f 95 43 09          	setne  0x9(%ebx)
}
80105397:	83 c4 2c             	add    $0x2c,%esp
8010539a:	5b                   	pop    %ebx
8010539b:	5e                   	pop    %esi
8010539c:	5f                   	pop    %edi
8010539d:	5d                   	pop    %ebp
8010539e:	c3                   	ret    
8010539f:	90                   	nop
    ip = create(path, T_FILE, 0, 0);
801053a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801053a3:	31 c9                	xor    %ecx,%ecx
801053a5:	ba 02 00 00 00       	mov    $0x2,%edx
801053aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053b1:	e8 6a f8 ff ff       	call   80104c20 <create>
    if(ip == 0){
801053b6:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801053b8:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801053ba:	75 8a                	jne    80105346 <sys_open+0x76>
801053bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801053c0:	e8 cb d7 ff ff       	call   80102b90 <end_op>
}
801053c5:	83 c4 2c             	add    $0x2c,%esp
    return -1;
801053c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053cd:	5b                   	pop    %ebx
801053ce:	5e                   	pop    %esi
801053cf:	5f                   	pop    %edi
801053d0:	5d                   	pop    %ebp
801053d1:	c3                   	ret    
801053d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801053d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801053db:	85 c0                	test   %eax,%eax
801053dd:	0f 84 63 ff ff ff    	je     80105346 <sys_open+0x76>
801053e3:	90                   	nop
801053e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
801053e8:	89 34 24             	mov    %esi,(%esp)
801053eb:	e8 30 c5 ff ff       	call   80101920 <iunlockput>
801053f0:	eb ce                	jmp    801053c0 <sys_open+0xf0>
801053f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      fileclose(f);
801053f8:	89 1c 24             	mov    %ebx,(%esp)
801053fb:	e8 40 ba ff ff       	call   80100e40 <fileclose>
80105400:	eb e6                	jmp    801053e8 <sys_open+0x118>
80105402:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105410 <sys_mkdir>:

int
sys_mkdir(void)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105416:	e8 05 d7 ff ff       	call   80102b20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010541b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010541e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105422:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105429:	e8 02 f7 ff ff       	call   80104b30 <argstr>
8010542e:	85 c0                	test   %eax,%eax
80105430:	78 2e                	js     80105460 <sys_mkdir+0x50>
80105432:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105435:	31 c9                	xor    %ecx,%ecx
80105437:	ba 01 00 00 00       	mov    $0x1,%edx
8010543c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105443:	e8 d8 f7 ff ff       	call   80104c20 <create>
80105448:	85 c0                	test   %eax,%eax
8010544a:	74 14                	je     80105460 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010544c:	89 04 24             	mov    %eax,(%esp)
8010544f:	e8 cc c4 ff ff       	call   80101920 <iunlockput>
  end_op();
80105454:	e8 37 d7 ff ff       	call   80102b90 <end_op>
  return 0;
80105459:	31 c0                	xor    %eax,%eax
}
8010545b:	c9                   	leave  
8010545c:	c3                   	ret    
8010545d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80105460:	e8 2b d7 ff ff       	call   80102b90 <end_op>
    return -1;
80105465:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010546a:	c9                   	leave  
8010546b:	c3                   	ret    
8010546c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105470 <sys_mknod>:

int
sys_mknod(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105476:	e8 a5 d6 ff ff       	call   80102b20 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010547b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010547e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105482:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105489:	e8 a2 f6 ff ff       	call   80104b30 <argstr>
8010548e:	85 c0                	test   %eax,%eax
80105490:	78 5e                	js     801054f0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105492:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105495:	89 44 24 04          	mov    %eax,0x4(%esp)
80105499:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801054a0:	e8 fb f5 ff ff       	call   80104aa0 <argint>
  if((argstr(0, &path)) < 0 ||
801054a5:	85 c0                	test   %eax,%eax
801054a7:	78 47                	js     801054f0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801054a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054ac:	89 44 24 04          	mov    %eax,0x4(%esp)
801054b0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801054b7:	e8 e4 f5 ff ff       	call   80104aa0 <argint>
     argint(1, &major) < 0 ||
801054bc:	85 c0                	test   %eax,%eax
801054be:	78 30                	js     801054f0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801054c0:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801054c4:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
801054c9:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801054cd:	89 04 24             	mov    %eax,(%esp)
     argint(2, &minor) < 0 ||
801054d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801054d3:	e8 48 f7 ff ff       	call   80104c20 <create>
801054d8:	85 c0                	test   %eax,%eax
801054da:	74 14                	je     801054f0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801054dc:	89 04 24             	mov    %eax,(%esp)
801054df:	e8 3c c4 ff ff       	call   80101920 <iunlockput>
  end_op();
801054e4:	e8 a7 d6 ff ff       	call   80102b90 <end_op>
  return 0;
801054e9:	31 c0                	xor    %eax,%eax
}
801054eb:	c9                   	leave  
801054ec:	c3                   	ret    
801054ed:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
801054f0:	e8 9b d6 ff ff       	call   80102b90 <end_op>
    return -1;
801054f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054fa:	c9                   	leave  
801054fb:	c3                   	ret    
801054fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105500 <sys_chdir>:

int
sys_chdir(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	56                   	push   %esi
80105504:	53                   	push   %ebx
80105505:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105508:	e8 d3 e1 ff ff       	call   801036e0 <myproc>
8010550d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010550f:	e8 0c d6 ff ff       	call   80102b20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105514:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105517:	89 44 24 04          	mov    %eax,0x4(%esp)
8010551b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105522:	e8 09 f6 ff ff       	call   80104b30 <argstr>
80105527:	85 c0                	test   %eax,%eax
80105529:	78 4a                	js     80105575 <sys_chdir+0x75>
8010552b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010552e:	89 04 24             	mov    %eax,(%esp)
80105531:	e8 da c9 ff ff       	call   80101f10 <namei>
80105536:	85 c0                	test   %eax,%eax
80105538:	89 c3                	mov    %eax,%ebx
8010553a:	74 39                	je     80105575 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
8010553c:	89 04 24             	mov    %eax,(%esp)
8010553f:	e8 7c c1 ff ff       	call   801016c0 <ilock>
  if(ip->type != T_DIR){
80105544:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105549:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
8010554c:	75 22                	jne    80105570 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
8010554e:	e8 4d c2 ff ff       	call   801017a0 <iunlock>
  iput(curproc->cwd);
80105553:	8b 46 6c             	mov    0x6c(%esi),%eax
80105556:	89 04 24             	mov    %eax,(%esp)
80105559:	e8 82 c2 ff ff       	call   801017e0 <iput>
  end_op();
8010555e:	e8 2d d6 ff ff       	call   80102b90 <end_op>
  curproc->cwd = ip;
  return 0;
80105563:	31 c0                	xor    %eax,%eax
  curproc->cwd = ip;
80105565:	89 5e 6c             	mov    %ebx,0x6c(%esi)
}
80105568:	83 c4 20             	add    $0x20,%esp
8010556b:	5b                   	pop    %ebx
8010556c:	5e                   	pop    %esi
8010556d:	5d                   	pop    %ebp
8010556e:	c3                   	ret    
8010556f:	90                   	nop
    iunlockput(ip);
80105570:	e8 ab c3 ff ff       	call   80101920 <iunlockput>
    end_op();
80105575:	e8 16 d6 ff ff       	call   80102b90 <end_op>
}
8010557a:	83 c4 20             	add    $0x20,%esp
    return -1;
8010557d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105582:	5b                   	pop    %ebx
80105583:	5e                   	pop    %esi
80105584:	5d                   	pop    %ebp
80105585:	c3                   	ret    
80105586:	8d 76 00             	lea    0x0(%esi),%esi
80105589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105590 <sys_exec>:

int
sys_exec(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	57                   	push   %edi
80105594:	56                   	push   %esi
80105595:	53                   	push   %ebx
80105596:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010559c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801055a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801055a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055ad:	e8 7e f5 ff ff       	call   80104b30 <argstr>
801055b2:	85 c0                	test   %eax,%eax
801055b4:	0f 88 84 00 00 00    	js     8010563e <sys_exec+0xae>
801055ba:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801055c0:	89 44 24 04          	mov    %eax,0x4(%esp)
801055c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801055cb:	e8 d0 f4 ff ff       	call   80104aa0 <argint>
801055d0:	85 c0                	test   %eax,%eax
801055d2:	78 6a                	js     8010563e <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801055d4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801055da:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801055dc:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801055e3:	00 
801055e4:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801055ea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801055f1:	00 
801055f2:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801055f8:	89 04 24             	mov    %eax,(%esp)
801055fb:	e8 b0 f1 ff ff       	call   801047b0 <memset>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105600:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105606:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010560a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010560d:	89 04 24             	mov    %eax,(%esp)
80105610:	e8 eb f3 ff ff       	call   80104a00 <fetchint>
80105615:	85 c0                	test   %eax,%eax
80105617:	78 25                	js     8010563e <sys_exec+0xae>
      return -1;
    if(uarg == 0){
80105619:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010561f:	85 c0                	test   %eax,%eax
80105621:	74 2d                	je     80105650 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105623:	89 74 24 04          	mov    %esi,0x4(%esp)
80105627:	89 04 24             	mov    %eax,(%esp)
8010562a:	e8 11 f4 ff ff       	call   80104a40 <fetchstr>
8010562f:	85 c0                	test   %eax,%eax
80105631:	78 0b                	js     8010563e <sys_exec+0xae>
  for(i=0;; i++){
80105633:	83 c3 01             	add    $0x1,%ebx
80105636:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105639:	83 fb 20             	cmp    $0x20,%ebx
8010563c:	75 c2                	jne    80105600 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
8010563e:	81 c4 ac 00 00 00    	add    $0xac,%esp
    return -1;
80105644:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105649:	5b                   	pop    %ebx
8010564a:	5e                   	pop    %esi
8010564b:	5f                   	pop    %edi
8010564c:	5d                   	pop    %ebp
8010564d:	c3                   	ret    
8010564e:	66 90                	xchg   %ax,%ax
  return exec(path, argv);
80105650:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105656:	89 44 24 04          	mov    %eax,0x4(%esp)
8010565a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
      argv[i] = 0;
80105660:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105667:	00 00 00 00 
  return exec(path, argv);
8010566b:	89 04 24             	mov    %eax,(%esp)
8010566e:	e8 2d b3 ff ff       	call   801009a0 <exec>
}
80105673:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105679:	5b                   	pop    %ebx
8010567a:	5e                   	pop    %esi
8010567b:	5f                   	pop    %edi
8010567c:	5d                   	pop    %ebp
8010567d:	c3                   	ret    
8010567e:	66 90                	xchg   %ax,%ax

80105680 <sys_pipe>:

int
sys_pipe(void)
{
80105680:	55                   	push   %ebp
80105681:	89 e5                	mov    %esp,%ebp
80105683:	53                   	push   %ebx
80105684:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105687:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010568a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105691:	00 
80105692:	89 44 24 04          	mov    %eax,0x4(%esp)
80105696:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010569d:	e8 2e f4 ff ff       	call   80104ad0 <argptr>
801056a2:	85 c0                	test   %eax,%eax
801056a4:	78 6d                	js     80105713 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801056a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801056ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056b0:	89 04 24             	mov    %eax,(%esp)
801056b3:	e8 c8 da ff ff       	call   80103180 <pipealloc>
801056b8:	85 c0                	test   %eax,%eax
801056ba:	78 57                	js     80105713 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056bf:	e8 1c f5 ff ff       	call   80104be0 <fdalloc>
801056c4:	85 c0                	test   %eax,%eax
801056c6:	89 c3                	mov    %eax,%ebx
801056c8:	78 33                	js     801056fd <sys_pipe+0x7d>
801056ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056cd:	e8 0e f5 ff ff       	call   80104be0 <fdalloc>
801056d2:	85 c0                	test   %eax,%eax
801056d4:	78 1a                	js     801056f0 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801056d6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801056d9:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
801056db:	8b 55 ec             	mov    -0x14(%ebp),%edx
801056de:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
801056e1:	83 c4 24             	add    $0x24,%esp
  return 0;
801056e4:	31 c0                	xor    %eax,%eax
}
801056e6:	5b                   	pop    %ebx
801056e7:	5d                   	pop    %ebp
801056e8:	c3                   	ret    
801056e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801056f0:	e8 eb df ff ff       	call   801036e0 <myproc>
801056f5:	c7 44 98 2c 00 00 00 	movl   $0x0,0x2c(%eax,%ebx,4)
801056fc:	00 
    fileclose(rf);
801056fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105700:	89 04 24             	mov    %eax,(%esp)
80105703:	e8 38 b7 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105708:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010570b:	89 04 24             	mov    %eax,(%esp)
8010570e:	e8 2d b7 ff ff       	call   80100e40 <fileclose>
}
80105713:	83 c4 24             	add    $0x24,%esp
    return -1;
80105716:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010571b:	5b                   	pop    %ebx
8010571c:	5d                   	pop    %ebp
8010571d:	c3                   	ret    
8010571e:	66 90                	xchg   %ax,%ax

80105720 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105723:	5d                   	pop    %ebp
  return fork();
80105724:	e9 67 e1 ff ff       	jmp    80103890 <fork>
80105729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105730 <sys_exit>:

int
sys_exit(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	83 ec 08             	sub    $0x8,%esp
  exit();
80105736:	e8 75 e4 ff ff       	call   80103bb0 <exit>
  return 0;  // not reached
}
8010573b:	31 c0                	xor    %eax,%eax
8010573d:	c9                   	leave  
8010573e:	c3                   	ret    
8010573f:	90                   	nop

80105740 <sys_exitStatus>:

int sys_exitStatus(void) //cs153_lab1: exitStatus
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
80105743:	83 ec 28             	sub    $0x28,%esp
	int arg;

	if (argint(0, &arg) < 0)
80105746:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105749:	89 44 24 04          	mov    %eax,0x4(%esp)
8010574d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105754:	e8 47 f3 ff ff       	call   80104aa0 <argint>
80105759:	85 c0                	test   %eax,%eax
8010575b:	78 13                	js     80105770 <sys_exitStatus+0x30>
		exitStatus(1); //didn't receive an argument, so I'm forcefully sending a one
	else
		exitStatus(arg);
8010575d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105760:	89 04 24             	mov    %eax,(%esp)
80105763:	e8 78 e5 ff ff       	call   80103ce0 <exitStatus>

	return 0; //not reached
}
80105768:	31 c0                	xor    %eax,%eax
8010576a:	c9                   	leave  
8010576b:	c3                   	ret    
8010576c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		exitStatus(1); //didn't receive an argument, so I'm forcefully sending a one
80105770:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105777:	e8 64 e5 ff ff       	call   80103ce0 <exitStatus>
}
8010577c:	31 c0                	xor    %eax,%eax
8010577e:	c9                   	leave  
8010577f:	c3                   	ret    

80105780 <sys_wait>:

int
sys_wait(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105783:	5d                   	pop    %ebp
  return wait();
80105784:	e9 27 e8 ff ff       	jmp    80103fb0 <wait>
80105789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105790 <sys_waitStatus>:

int sys_waitStatus(void) //cs153_lab1: waitStatus
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	83 ec 28             	sub    $0x28,%esp
	int* argPtr;

	if (argptr(0, (void*)&argPtr, sizeof(int)) < 0)
80105796:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105799:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801057a0:	00 
801057a1:	89 44 24 04          	mov    %eax,0x4(%esp)
801057a5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057ac:	e8 1f f3 ff ff       	call   80104ad0 <argptr>
801057b1:	85 c0                	test   %eax,%eax
801057b3:	78 13                	js     801057c8 <sys_waitStatus+0x38>
		return -1;
	else
		return waitStatus(argPtr);
801057b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057b8:	89 04 24             	mov    %eax,(%esp)
801057bb:	e8 e0 e8 ff ff       	call   801040a0 <waitStatus>
}
801057c0:	c9                   	leave  
801057c1:	c3                   	ret    
801057c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		return -1;
801057c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057cd:	c9                   	leave  
801057ce:	c3                   	ret    
801057cf:	90                   	nop

801057d0 <sys_waitpid>:

int sys_waitpid(void) //cs153_lab1: waitpid
{
801057d0:	55                   	push   %ebp
801057d1:	89 e5                	mov    %esp,%ebp
801057d3:	56                   	push   %esi
801057d4:	53                   	push   %ebx
801057d5:	83 ec 20             	sub    $0x20,%esp
	int pid, options, argInt1, argInt2, argPtr;
	int* status;

	argInt1 = argint(0, &pid);
801057d8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801057db:	89 44 24 04          	mov    %eax,0x4(%esp)
801057df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057e6:	e8 b5 f2 ff ff       	call   80104aa0 <argint>
	argPtr = argptr(1, (void*)&status, sizeof(int));
801057eb:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801057f2:	00 
801057f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
	argInt1 = argint(0, &pid);
801057fa:	89 c3                	mov    %eax,%ebx
	argPtr = argptr(1, (void*)&status, sizeof(int));
801057fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057ff:	89 44 24 04          	mov    %eax,0x4(%esp)
	argInt2 = argint(2, &options);

	if (argInt1 < 0 || argPtr < 0 || argInt2 < 0)
80105803:	c1 eb 1f             	shr    $0x1f,%ebx
	argPtr = argptr(1, (void*)&status, sizeof(int));
80105806:	e8 c5 f2 ff ff       	call   80104ad0 <argptr>
	argInt2 = argint(2, &options);
8010580b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
	argPtr = argptr(1, (void*)&status, sizeof(int));
80105812:	89 c6                	mov    %eax,%esi
	argInt2 = argint(2, &options);
80105814:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105817:	89 44 24 04          	mov    %eax,0x4(%esp)
8010581b:	e8 80 f2 ff ff       	call   80104aa0 <argint>
	if (argInt1 < 0 || argPtr < 0 || argInt2 < 0)
80105820:	84 db                	test   %bl,%bl
80105822:	75 34                	jne    80105858 <sys_waitpid+0x88>
80105824:	89 f2                	mov    %esi,%edx
80105826:	c1 ea 1f             	shr    $0x1f,%edx
80105829:	84 d2                	test   %dl,%dl
8010582b:	75 2b                	jne    80105858 <sys_waitpid+0x88>
8010582d:	85 c0                	test   %eax,%eax
8010582f:	78 27                	js     80105858 <sys_waitpid+0x88>
		return -1;
	else
		return waitpid(pid, status, options);
80105831:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105834:	89 44 24 08          	mov    %eax,0x8(%esp)
80105838:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010583b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010583f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105842:	89 04 24             	mov    %eax,(%esp)
80105845:	e8 46 e9 ff ff       	call   80104190 <waitpid>
}
8010584a:	83 c4 20             	add    $0x20,%esp
8010584d:	5b                   	pop    %ebx
8010584e:	5e                   	pop    %esi
8010584f:	5d                   	pop    %ebp
80105850:	c3                   	ret    
80105851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		return -1;
80105858:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585d:	eb eb                	jmp    8010584a <sys_waitpid+0x7a>
8010585f:	90                   	nop

80105860 <sys_kill>:

int
sys_kill(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105866:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105869:	89 44 24 04          	mov    %eax,0x4(%esp)
8010586d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105874:	e8 27 f2 ff ff       	call   80104aa0 <argint>
80105879:	85 c0                	test   %eax,%eax
8010587b:	78 13                	js     80105890 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010587d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105880:	89 04 24             	mov    %eax,(%esp)
80105883:	e8 78 ea ff ff       	call   80104300 <kill>
}
80105888:	c9                   	leave  
80105889:	c3                   	ret    
8010588a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105890:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105895:	c9                   	leave  
80105896:	c3                   	ret    
80105897:	89 f6                	mov    %esi,%esi
80105899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058a0 <sys_getpid>:

int
sys_getpid(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801058a6:	e8 35 de ff ff       	call   801036e0 <myproc>
801058ab:	8b 40 14             	mov    0x14(%eax),%eax
}
801058ae:	c9                   	leave  
801058af:	c3                   	ret    

801058b0 <sys_sbrk>:

int
sys_sbrk(void)
{
801058b0:	55                   	push   %ebp
801058b1:	89 e5                	mov    %esp,%ebp
801058b3:	53                   	push   %ebx
801058b4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801058b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801058be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801058c5:	e8 d6 f1 ff ff       	call   80104aa0 <argint>
801058ca:	85 c0                	test   %eax,%eax
801058cc:	78 22                	js     801058f0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801058ce:	e8 0d de ff ff       	call   801036e0 <myproc>
  if(growproc(n) < 0)
801058d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  addr = myproc()->sz;
801058d6:	8b 58 04             	mov    0x4(%eax),%ebx
  if(growproc(n) < 0)
801058d9:	89 14 24             	mov    %edx,(%esp)
801058dc:	e8 3f df ff ff       	call   80103820 <growproc>
801058e1:	85 c0                	test   %eax,%eax
801058e3:	78 0b                	js     801058f0 <sys_sbrk+0x40>
    return -1;
  return addr;
801058e5:	89 d8                	mov    %ebx,%eax
}
801058e7:	83 c4 24             	add    $0x24,%esp
801058ea:	5b                   	pop    %ebx
801058eb:	5d                   	pop    %ebp
801058ec:	c3                   	ret    
801058ed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801058f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058f5:	eb f0                	jmp    801058e7 <sys_sbrk+0x37>
801058f7:	89 f6                	mov    %esi,%esi
801058f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105900 <sys_sleep>:

int
sys_sleep(void)
{
80105900:	55                   	push   %ebp
80105901:	89 e5                	mov    %esp,%ebp
80105903:	53                   	push   %ebx
80105904:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105907:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010590a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010590e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105915:	e8 86 f1 ff ff       	call   80104aa0 <argint>
8010591a:	85 c0                	test   %eax,%eax
8010591c:	78 7e                	js     8010599c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010591e:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
80105925:	e8 c6 ed ff ff       	call   801046f0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010592a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010592d:	8b 1d a0 59 11 80    	mov    0x801159a0,%ebx
  while(ticks - ticks0 < n){
80105933:	85 d2                	test   %edx,%edx
80105935:	75 29                	jne    80105960 <sys_sleep+0x60>
80105937:	eb 4f                	jmp    80105988 <sys_sleep+0x88>
80105939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105940:	c7 44 24 04 60 51 11 	movl   $0x80115160,0x4(%esp)
80105947:	80 
80105948:	c7 04 24 a0 59 11 80 	movl   $0x801159a0,(%esp)
8010594f:	e8 ac e5 ff ff       	call   80103f00 <sleep>
  while(ticks - ticks0 < n){
80105954:	a1 a0 59 11 80       	mov    0x801159a0,%eax
80105959:	29 d8                	sub    %ebx,%eax
8010595b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010595e:	73 28                	jae    80105988 <sys_sleep+0x88>
    if(myproc()->killed){
80105960:	e8 7b dd ff ff       	call   801036e0 <myproc>
80105965:	8b 40 28             	mov    0x28(%eax),%eax
80105968:	85 c0                	test   %eax,%eax
8010596a:	74 d4                	je     80105940 <sys_sleep+0x40>
      release(&tickslock);
8010596c:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
80105973:	e8 e8 ed ff ff       	call   80104760 <release>
      return -1;
80105978:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
8010597d:	83 c4 24             	add    $0x24,%esp
80105980:	5b                   	pop    %ebx
80105981:	5d                   	pop    %ebp
80105982:	c3                   	ret    
80105983:	90                   	nop
80105984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
80105988:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
8010598f:	e8 cc ed ff ff       	call   80104760 <release>
}
80105994:	83 c4 24             	add    $0x24,%esp
  return 0;
80105997:	31 c0                	xor    %eax,%eax
}
80105999:	5b                   	pop    %ebx
8010599a:	5d                   	pop    %ebp
8010599b:	c3                   	ret    
    return -1;
8010599c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059a1:	eb da                	jmp    8010597d <sys_sleep+0x7d>
801059a3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801059a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059b0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801059b0:	55                   	push   %ebp
801059b1:	89 e5                	mov    %esp,%ebp
801059b3:	53                   	push   %ebx
801059b4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
801059b7:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
801059be:	e8 2d ed ff ff       	call   801046f0 <acquire>
  xticks = ticks;
801059c3:	8b 1d a0 59 11 80    	mov    0x801159a0,%ebx
  release(&tickslock);
801059c9:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
801059d0:	e8 8b ed ff ff       	call   80104760 <release>
  return xticks;
}
801059d5:	83 c4 14             	add    $0x14,%esp
801059d8:	89 d8                	mov    %ebx,%eax
801059da:	5b                   	pop    %ebx
801059db:	5d                   	pop    %ebp
801059dc:	c3                   	ret    
801059dd:	8d 76 00             	lea    0x0(%esi),%esi

801059e0 <sys_getPrior>:

//---------lab2------------
int
sys_getPrior(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
    return getPrior();
}
801059e3:	5d                   	pop    %ebp
    return getPrior();
801059e4:	e9 b7 df ff ff       	jmp    801039a0 <getPrior>
801059e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059f0 <sys_setPrior>:
int
sys_setPrior(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	83 ec 28             	sub    $0x28,%esp
    //when passing in a argument we must use argint
    int prior_val;

    if(argint(0, &prior_val) < 0){
801059f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801059fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a04:	e8 97 f0 ff ff       	call   80104aa0 <argint>
80105a09:	85 c0                	test   %eax,%eax
80105a0b:	78 13                	js     80105a20 <sys_setPrior+0x30>
        exitStatus(1); //error caught!
    }
    else
        setPrior(prior_val);
80105a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a10:	89 04 24             	mov    %eax,(%esp)
80105a13:	e8 c8 e4 ff ff       	call   80103ee0 <setPrior>
    return 0;  // not reached
}
80105a18:	31 c0                	xor    %eax,%eax
80105a1a:	c9                   	leave  
80105a1b:	c3                   	ret    
80105a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        exitStatus(1); //error caught!
80105a20:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105a27:	e8 b4 e2 ff ff       	call   80103ce0 <exitStatus>
}
80105a2c:	31 c0                	xor    %eax,%eax
80105a2e:	c9                   	leave  
80105a2f:	c3                   	ret    

80105a30 <sys_getWaitTime>:
int
sys_getWaitTime(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
    return getWaitTime();
}
80105a33:	5d                   	pop    %ebp
    return getWaitTime();
80105a34:	e9 87 df ff ff       	jmp    801039c0 <getWaitTime>
80105a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a40 <sys_getTurnTime>:
int
sys_getTurnTime(void)
{
80105a40:	55                   	push   %ebp
80105a41:	89 e5                	mov    %esp,%ebp
    return getTurnTime();
}
80105a43:	5d                   	pop    %ebp
    return getTurnTime();
80105a44:	e9 97 df ff ff       	jmp    801039e0 <getTurnTime>

80105a49 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105a49:	1e                   	push   %ds
  pushl %es
80105a4a:	06                   	push   %es
  pushl %fs
80105a4b:	0f a0                	push   %fs
  pushl %gs
80105a4d:	0f a8                	push   %gs
  pushal
80105a4f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105a50:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105a54:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105a56:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105a58:	54                   	push   %esp
  call trap
80105a59:	e8 e2 00 00 00       	call   80105b40 <trap>
  addl $4, %esp
80105a5e:	83 c4 04             	add    $0x4,%esp

80105a61 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105a61:	61                   	popa   
  popl %gs
80105a62:	0f a9                	pop    %gs
  popl %fs
80105a64:	0f a1                	pop    %fs
  popl %es
80105a66:	07                   	pop    %es
  popl %ds
80105a67:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105a68:	83 c4 08             	add    $0x8,%esp
  iret
80105a6b:	cf                   	iret   
80105a6c:	66 90                	xchg   %ax,%ax
80105a6e:	66 90                	xchg   %ax,%ax

80105a70 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105a70:	31 c0                	xor    %eax,%eax
80105a72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105a78:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105a7f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105a84:	66 89 0c c5 a2 51 11 	mov    %cx,-0x7feeae5e(,%eax,8)
80105a8b:	80 
80105a8c:	c6 04 c5 a4 51 11 80 	movb   $0x0,-0x7feeae5c(,%eax,8)
80105a93:	00 
80105a94:	c6 04 c5 a5 51 11 80 	movb   $0x8e,-0x7feeae5b(,%eax,8)
80105a9b:	8e 
80105a9c:	66 89 14 c5 a0 51 11 	mov    %dx,-0x7feeae60(,%eax,8)
80105aa3:	80 
80105aa4:	c1 ea 10             	shr    $0x10,%edx
80105aa7:	66 89 14 c5 a6 51 11 	mov    %dx,-0x7feeae5a(,%eax,8)
80105aae:	80 
  for(i = 0; i < 256; i++)
80105aaf:	83 c0 01             	add    $0x1,%eax
80105ab2:	3d 00 01 00 00       	cmp    $0x100,%eax
80105ab7:	75 bf                	jne    80105a78 <tvinit+0x8>
{
80105ab9:	55                   	push   %ebp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105aba:	ba 08 00 00 00       	mov    $0x8,%edx
{
80105abf:	89 e5                	mov    %esp,%ebp
80105ac1:	83 ec 18             	sub    $0x18,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ac4:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105ac9:	c7 44 24 04 99 7a 10 	movl   $0x80107a99,0x4(%esp)
80105ad0:	80 
80105ad1:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ad8:	66 89 15 a2 53 11 80 	mov    %dx,0x801153a2
80105adf:	66 a3 a0 53 11 80    	mov    %ax,0x801153a0
80105ae5:	c1 e8 10             	shr    $0x10,%eax
80105ae8:	c6 05 a4 53 11 80 00 	movb   $0x0,0x801153a4
80105aef:	c6 05 a5 53 11 80 ef 	movb   $0xef,0x801153a5
80105af6:	66 a3 a6 53 11 80    	mov    %ax,0x801153a6
  initlock(&tickslock, "time");
80105afc:	e8 7f ea ff ff       	call   80104580 <initlock>
}
80105b01:	c9                   	leave  
80105b02:	c3                   	ret    
80105b03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b10 <idtinit>:

void
idtinit(void)
{
80105b10:	55                   	push   %ebp
  pd[0] = size-1;
80105b11:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105b16:	89 e5                	mov    %esp,%ebp
80105b18:	83 ec 10             	sub    $0x10,%esp
80105b1b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105b1f:	b8 a0 51 11 80       	mov    $0x801151a0,%eax
80105b24:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105b28:	c1 e8 10             	shr    $0x10,%eax
80105b2b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105b2f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105b32:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105b35:	c9                   	leave  
80105b36:	c3                   	ret    
80105b37:	89 f6                	mov    %esi,%esi
80105b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b40 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	57                   	push   %edi
80105b44:	56                   	push   %esi
80105b45:	53                   	push   %ebx
80105b46:	83 ec 3c             	sub    $0x3c,%esp
80105b49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105b4c:	8b 43 30             	mov    0x30(%ebx),%eax
80105b4f:	83 f8 40             	cmp    $0x40,%eax
80105b52:	0f 84 a0 01 00 00    	je     80105cf8 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105b58:	83 e8 20             	sub    $0x20,%eax
80105b5b:	83 f8 1f             	cmp    $0x1f,%eax
80105b5e:	77 08                	ja     80105b68 <trap+0x28>
80105b60:	ff 24 85 40 7b 10 80 	jmp    *-0x7fef84c0(,%eax,4)
80105b67:	90                   	nop
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105b68:	e8 73 db ff ff       	call   801036e0 <myproc>
80105b6d:	85 c0                	test   %eax,%eax
80105b6f:	90                   	nop
80105b70:	0f 84 fa 01 00 00    	je     80105d70 <trap+0x230>
80105b76:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105b7a:	0f 84 f0 01 00 00    	je     80105d70 <trap+0x230>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105b80:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105b83:	8b 53 38             	mov    0x38(%ebx),%edx
80105b86:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105b89:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105b8c:	e8 2f db ff ff       	call   801036c0 <cpuid>
80105b91:	8b 73 30             	mov    0x30(%ebx),%esi
80105b94:	89 c7                	mov    %eax,%edi
80105b96:	8b 43 34             	mov    0x34(%ebx),%eax
80105b99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105b9c:	e8 3f db ff ff       	call   801036e0 <myproc>
80105ba1:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ba4:	e8 37 db ff ff       	call   801036e0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ba9:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105bac:	89 74 24 0c          	mov    %esi,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105bb0:	8b 75 e0             	mov    -0x20(%ebp),%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bb3:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105bb6:	89 7c 24 14          	mov    %edi,0x14(%esp)
80105bba:	89 54 24 18          	mov    %edx,0x18(%esp)
80105bbe:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            myproc()->pid, myproc()->name, tf->trapno,
80105bc1:	83 c6 70             	add    $0x70,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bc4:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105bc8:	89 74 24 08          	mov    %esi,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bcc:	89 54 24 10          	mov    %edx,0x10(%esp)
80105bd0:	8b 40 14             	mov    0x14(%eax),%eax
80105bd3:	c7 04 24 fc 7a 10 80 	movl   $0x80107afc,(%esp)
80105bda:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bde:	e8 6d aa ff ff       	call   80100650 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105be3:	e8 f8 da ff ff       	call   801036e0 <myproc>
80105be8:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
80105bef:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bf0:	e8 eb da ff ff       	call   801036e0 <myproc>
80105bf5:	85 c0                	test   %eax,%eax
80105bf7:	74 0c                	je     80105c05 <trap+0xc5>
80105bf9:	e8 e2 da ff ff       	call   801036e0 <myproc>
80105bfe:	8b 50 28             	mov    0x28(%eax),%edx
80105c01:	85 d2                	test   %edx,%edx
80105c03:	75 4b                	jne    80105c50 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105c05:	e8 d6 da ff ff       	call   801036e0 <myproc>
80105c0a:	85 c0                	test   %eax,%eax
80105c0c:	74 0d                	je     80105c1b <trap+0xdb>
80105c0e:	66 90                	xchg   %ax,%ax
80105c10:	e8 cb da ff ff       	call   801036e0 <myproc>
80105c15:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
80105c19:	74 4d                	je     80105c68 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c1b:	e8 c0 da ff ff       	call   801036e0 <myproc>
80105c20:	85 c0                	test   %eax,%eax
80105c22:	74 1d                	je     80105c41 <trap+0x101>
80105c24:	e8 b7 da ff ff       	call   801036e0 <myproc>
80105c29:	8b 40 28             	mov    0x28(%eax),%eax
80105c2c:	85 c0                	test   %eax,%eax
80105c2e:	74 11                	je     80105c41 <trap+0x101>
80105c30:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c34:	83 e0 03             	and    $0x3,%eax
80105c37:	66 83 f8 03          	cmp    $0x3,%ax
80105c3b:	0f 84 e8 00 00 00    	je     80105d29 <trap+0x1e9>
    exit();
}
80105c41:	83 c4 3c             	add    $0x3c,%esp
80105c44:	5b                   	pop    %ebx
80105c45:	5e                   	pop    %esi
80105c46:	5f                   	pop    %edi
80105c47:	5d                   	pop    %ebp
80105c48:	c3                   	ret    
80105c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c50:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c54:	83 e0 03             	and    $0x3,%eax
80105c57:	66 83 f8 03          	cmp    $0x3,%ax
80105c5b:	75 a8                	jne    80105c05 <trap+0xc5>
    exit();
80105c5d:	e8 4e df ff ff       	call   80103bb0 <exit>
80105c62:	eb a1                	jmp    80105c05 <trap+0xc5>
80105c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105c68:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c70:	75 a9                	jne    80105c1b <trap+0xdb>
    yield();
80105c72:	e8 29 e2 ff ff       	call   80103ea0 <yield>
80105c77:	eb a2                	jmp    80105c1b <trap+0xdb>
80105c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105c80:	e8 3b da ff ff       	call   801036c0 <cpuid>
80105c85:	85 c0                	test   %eax,%eax
80105c87:	0f 84 b3 00 00 00    	je     80105d40 <trap+0x200>
80105c8d:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
80105c90:	e8 fb ca ff ff       	call   80102790 <lapiceoi>
    break;
80105c95:	e9 56 ff ff ff       	jmp    80105bf0 <trap+0xb0>
80105c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    kbdintr();
80105ca0:	e8 3b c9 ff ff       	call   801025e0 <kbdintr>
    lapiceoi();
80105ca5:	e8 e6 ca ff ff       	call   80102790 <lapiceoi>
    break;
80105caa:	e9 41 ff ff ff       	jmp    80105bf0 <trap+0xb0>
80105caf:	90                   	nop
    uartintr();
80105cb0:	e8 1b 02 00 00       	call   80105ed0 <uartintr>
    lapiceoi();
80105cb5:	e8 d6 ca ff ff       	call   80102790 <lapiceoi>
    break;
80105cba:	e9 31 ff ff ff       	jmp    80105bf0 <trap+0xb0>
80105cbf:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105cc0:	8b 7b 38             	mov    0x38(%ebx),%edi
80105cc3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105cc7:	e8 f4 d9 ff ff       	call   801036c0 <cpuid>
80105ccc:	c7 04 24 a4 7a 10 80 	movl   $0x80107aa4,(%esp)
80105cd3:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105cd7:	89 74 24 08          	mov    %esi,0x8(%esp)
80105cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cdf:	e8 6c a9 ff ff       	call   80100650 <cprintf>
    lapiceoi();
80105ce4:	e8 a7 ca ff ff       	call   80102790 <lapiceoi>
    break;
80105ce9:	e9 02 ff ff ff       	jmp    80105bf0 <trap+0xb0>
80105cee:	66 90                	xchg   %ax,%ax
    ideintr();
80105cf0:	e8 9b c3 ff ff       	call   80102090 <ideintr>
80105cf5:	eb 96                	jmp    80105c8d <trap+0x14d>
80105cf7:	90                   	nop
80105cf8:	90                   	nop
80105cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105d00:	e8 db d9 ff ff       	call   801036e0 <myproc>
80105d05:	8b 70 28             	mov    0x28(%eax),%esi
80105d08:	85 f6                	test   %esi,%esi
80105d0a:	75 2c                	jne    80105d38 <trap+0x1f8>
    myproc()->tf = tf;
80105d0c:	e8 cf d9 ff ff       	call   801036e0 <myproc>
80105d11:	89 58 1c             	mov    %ebx,0x1c(%eax)
    syscall();
80105d14:	e8 57 ee ff ff       	call   80104b70 <syscall>
    if(myproc()->killed)
80105d19:	e8 c2 d9 ff ff       	call   801036e0 <myproc>
80105d1e:	8b 48 28             	mov    0x28(%eax),%ecx
80105d21:	85 c9                	test   %ecx,%ecx
80105d23:	0f 84 18 ff ff ff    	je     80105c41 <trap+0x101>
}
80105d29:	83 c4 3c             	add    $0x3c,%esp
80105d2c:	5b                   	pop    %ebx
80105d2d:	5e                   	pop    %esi
80105d2e:	5f                   	pop    %edi
80105d2f:	5d                   	pop    %ebp
      exit();
80105d30:	e9 7b de ff ff       	jmp    80103bb0 <exit>
80105d35:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
80105d38:	e8 73 de ff ff       	call   80103bb0 <exit>
80105d3d:	eb cd                	jmp    80105d0c <trap+0x1cc>
80105d3f:	90                   	nop
      acquire(&tickslock);
80105d40:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
80105d47:	e8 a4 e9 ff ff       	call   801046f0 <acquire>
      wakeup(&ticks);
80105d4c:	c7 04 24 a0 59 11 80 	movl   $0x801159a0,(%esp)
      ticks++;
80105d53:	83 05 a0 59 11 80 01 	addl   $0x1,0x801159a0
      wakeup(&ticks);
80105d5a:	e8 31 e5 ff ff       	call   80104290 <wakeup>
      release(&tickslock);
80105d5f:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
80105d66:	e8 f5 e9 ff ff       	call   80104760 <release>
80105d6b:	e9 1d ff ff ff       	jmp    80105c8d <trap+0x14d>
80105d70:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105d73:	8b 73 38             	mov    0x38(%ebx),%esi
80105d76:	e8 45 d9 ff ff       	call   801036c0 <cpuid>
80105d7b:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105d7f:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105d83:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d87:	8b 43 30             	mov    0x30(%ebx),%eax
80105d8a:	c7 04 24 c8 7a 10 80 	movl   $0x80107ac8,(%esp)
80105d91:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d95:	e8 b6 a8 ff ff       	call   80100650 <cprintf>
      panic("trap");
80105d9a:	c7 04 24 9e 7a 10 80 	movl   $0x80107a9e,(%esp)
80105da1:	e8 ba a5 ff ff       	call   80100360 <panic>
80105da6:	66 90                	xchg   %ax,%ax
80105da8:	66 90                	xchg   %ax,%ax
80105daa:	66 90                	xchg   %ax,%ax
80105dac:	66 90                	xchg   %ax,%ax
80105dae:	66 90                	xchg   %ax,%ax

80105db0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105db0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105db5:	55                   	push   %ebp
80105db6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105db8:	85 c0                	test   %eax,%eax
80105dba:	74 14                	je     80105dd0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105dbc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105dc1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105dc2:	a8 01                	test   $0x1,%al
80105dc4:	74 0a                	je     80105dd0 <uartgetc+0x20>
80105dc6:	b2 f8                	mov    $0xf8,%dl
80105dc8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105dc9:	0f b6 c0             	movzbl %al,%eax
}
80105dcc:	5d                   	pop    %ebp
80105dcd:	c3                   	ret    
80105dce:	66 90                	xchg   %ax,%ax
    return -1;
80105dd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dd5:	5d                   	pop    %ebp
80105dd6:	c3                   	ret    
80105dd7:	89 f6                	mov    %esi,%esi
80105dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105de0 <uartputc>:
  if(!uart)
80105de0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105de5:	85 c0                	test   %eax,%eax
80105de7:	74 3f                	je     80105e28 <uartputc+0x48>
{
80105de9:	55                   	push   %ebp
80105dea:	89 e5                	mov    %esp,%ebp
80105dec:	56                   	push   %esi
80105ded:	be fd 03 00 00       	mov    $0x3fd,%esi
80105df2:	53                   	push   %ebx
  if(!uart)
80105df3:	bb 80 00 00 00       	mov    $0x80,%ebx
{
80105df8:	83 ec 10             	sub    $0x10,%esp
80105dfb:	eb 14                	jmp    80105e11 <uartputc+0x31>
80105dfd:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105e00:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105e07:	e8 a4 c9 ff ff       	call   801027b0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e0c:	83 eb 01             	sub    $0x1,%ebx
80105e0f:	74 07                	je     80105e18 <uartputc+0x38>
80105e11:	89 f2                	mov    %esi,%edx
80105e13:	ec                   	in     (%dx),%al
80105e14:	a8 20                	test   $0x20,%al
80105e16:	74 e8                	je     80105e00 <uartputc+0x20>
  outb(COM1+0, c);
80105e18:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e1c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e21:	ee                   	out    %al,(%dx)
}
80105e22:	83 c4 10             	add    $0x10,%esp
80105e25:	5b                   	pop    %ebx
80105e26:	5e                   	pop    %esi
80105e27:	5d                   	pop    %ebp
80105e28:	f3 c3                	repz ret 
80105e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e30 <uartinit>:
{
80105e30:	55                   	push   %ebp
80105e31:	31 c9                	xor    %ecx,%ecx
80105e33:	89 e5                	mov    %esp,%ebp
80105e35:	89 c8                	mov    %ecx,%eax
80105e37:	57                   	push   %edi
80105e38:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105e3d:	56                   	push   %esi
80105e3e:	89 fa                	mov    %edi,%edx
80105e40:	53                   	push   %ebx
80105e41:	83 ec 1c             	sub    $0x1c,%esp
80105e44:	ee                   	out    %al,(%dx)
80105e45:	be fb 03 00 00       	mov    $0x3fb,%esi
80105e4a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105e4f:	89 f2                	mov    %esi,%edx
80105e51:	ee                   	out    %al,(%dx)
80105e52:	b8 0c 00 00 00       	mov    $0xc,%eax
80105e57:	b2 f8                	mov    $0xf8,%dl
80105e59:	ee                   	out    %al,(%dx)
80105e5a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105e5f:	89 c8                	mov    %ecx,%eax
80105e61:	89 da                	mov    %ebx,%edx
80105e63:	ee                   	out    %al,(%dx)
80105e64:	b8 03 00 00 00       	mov    $0x3,%eax
80105e69:	89 f2                	mov    %esi,%edx
80105e6b:	ee                   	out    %al,(%dx)
80105e6c:	b2 fc                	mov    $0xfc,%dl
80105e6e:	89 c8                	mov    %ecx,%eax
80105e70:	ee                   	out    %al,(%dx)
80105e71:	b8 01 00 00 00       	mov    $0x1,%eax
80105e76:	89 da                	mov    %ebx,%edx
80105e78:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e79:	b2 fd                	mov    $0xfd,%dl
80105e7b:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105e7c:	3c ff                	cmp    $0xff,%al
80105e7e:	74 42                	je     80105ec2 <uartinit+0x92>
  uart = 1;
80105e80:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105e87:	00 00 00 
80105e8a:	89 fa                	mov    %edi,%edx
80105e8c:	ec                   	in     (%dx),%al
80105e8d:	b2 f8                	mov    $0xf8,%dl
80105e8f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105e90:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105e97:	00 
  for(p="xv6...\n"; *p; p++)
80105e98:	bb c0 7b 10 80       	mov    $0x80107bc0,%ebx
  ioapicenable(IRQ_COM1, 0);
80105e9d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105ea4:	e8 17 c4 ff ff       	call   801022c0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105ea9:	b8 78 00 00 00       	mov    $0x78,%eax
80105eae:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105eb0:	89 04 24             	mov    %eax,(%esp)
  for(p="xv6...\n"; *p; p++)
80105eb3:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105eb6:	e8 25 ff ff ff       	call   80105de0 <uartputc>
  for(p="xv6...\n"; *p; p++)
80105ebb:	0f be 03             	movsbl (%ebx),%eax
80105ebe:	84 c0                	test   %al,%al
80105ec0:	75 ee                	jne    80105eb0 <uartinit+0x80>
}
80105ec2:	83 c4 1c             	add    $0x1c,%esp
80105ec5:	5b                   	pop    %ebx
80105ec6:	5e                   	pop    %esi
80105ec7:	5f                   	pop    %edi
80105ec8:	5d                   	pop    %ebp
80105ec9:	c3                   	ret    
80105eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ed0 <uartintr>:

void
uartintr(void)
{
80105ed0:	55                   	push   %ebp
80105ed1:	89 e5                	mov    %esp,%ebp
80105ed3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105ed6:	c7 04 24 b0 5d 10 80 	movl   $0x80105db0,(%esp)
80105edd:	e8 ce a8 ff ff       	call   801007b0 <consoleintr>
}
80105ee2:	c9                   	leave  
80105ee3:	c3                   	ret    

80105ee4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105ee4:	6a 00                	push   $0x0
  pushl $0
80105ee6:	6a 00                	push   $0x0
  jmp alltraps
80105ee8:	e9 5c fb ff ff       	jmp    80105a49 <alltraps>

80105eed <vector1>:
.globl vector1
vector1:
  pushl $0
80105eed:	6a 00                	push   $0x0
  pushl $1
80105eef:	6a 01                	push   $0x1
  jmp alltraps
80105ef1:	e9 53 fb ff ff       	jmp    80105a49 <alltraps>

80105ef6 <vector2>:
.globl vector2
vector2:
  pushl $0
80105ef6:	6a 00                	push   $0x0
  pushl $2
80105ef8:	6a 02                	push   $0x2
  jmp alltraps
80105efa:	e9 4a fb ff ff       	jmp    80105a49 <alltraps>

80105eff <vector3>:
.globl vector3
vector3:
  pushl $0
80105eff:	6a 00                	push   $0x0
  pushl $3
80105f01:	6a 03                	push   $0x3
  jmp alltraps
80105f03:	e9 41 fb ff ff       	jmp    80105a49 <alltraps>

80105f08 <vector4>:
.globl vector4
vector4:
  pushl $0
80105f08:	6a 00                	push   $0x0
  pushl $4
80105f0a:	6a 04                	push   $0x4
  jmp alltraps
80105f0c:	e9 38 fb ff ff       	jmp    80105a49 <alltraps>

80105f11 <vector5>:
.globl vector5
vector5:
  pushl $0
80105f11:	6a 00                	push   $0x0
  pushl $5
80105f13:	6a 05                	push   $0x5
  jmp alltraps
80105f15:	e9 2f fb ff ff       	jmp    80105a49 <alltraps>

80105f1a <vector6>:
.globl vector6
vector6:
  pushl $0
80105f1a:	6a 00                	push   $0x0
  pushl $6
80105f1c:	6a 06                	push   $0x6
  jmp alltraps
80105f1e:	e9 26 fb ff ff       	jmp    80105a49 <alltraps>

80105f23 <vector7>:
.globl vector7
vector7:
  pushl $0
80105f23:	6a 00                	push   $0x0
  pushl $7
80105f25:	6a 07                	push   $0x7
  jmp alltraps
80105f27:	e9 1d fb ff ff       	jmp    80105a49 <alltraps>

80105f2c <vector8>:
.globl vector8
vector8:
  pushl $8
80105f2c:	6a 08                	push   $0x8
  jmp alltraps
80105f2e:	e9 16 fb ff ff       	jmp    80105a49 <alltraps>

80105f33 <vector9>:
.globl vector9
vector9:
  pushl $0
80105f33:	6a 00                	push   $0x0
  pushl $9
80105f35:	6a 09                	push   $0x9
  jmp alltraps
80105f37:	e9 0d fb ff ff       	jmp    80105a49 <alltraps>

80105f3c <vector10>:
.globl vector10
vector10:
  pushl $10
80105f3c:	6a 0a                	push   $0xa
  jmp alltraps
80105f3e:	e9 06 fb ff ff       	jmp    80105a49 <alltraps>

80105f43 <vector11>:
.globl vector11
vector11:
  pushl $11
80105f43:	6a 0b                	push   $0xb
  jmp alltraps
80105f45:	e9 ff fa ff ff       	jmp    80105a49 <alltraps>

80105f4a <vector12>:
.globl vector12
vector12:
  pushl $12
80105f4a:	6a 0c                	push   $0xc
  jmp alltraps
80105f4c:	e9 f8 fa ff ff       	jmp    80105a49 <alltraps>

80105f51 <vector13>:
.globl vector13
vector13:
  pushl $13
80105f51:	6a 0d                	push   $0xd
  jmp alltraps
80105f53:	e9 f1 fa ff ff       	jmp    80105a49 <alltraps>

80105f58 <vector14>:
.globl vector14
vector14:
  pushl $14
80105f58:	6a 0e                	push   $0xe
  jmp alltraps
80105f5a:	e9 ea fa ff ff       	jmp    80105a49 <alltraps>

80105f5f <vector15>:
.globl vector15
vector15:
  pushl $0
80105f5f:	6a 00                	push   $0x0
  pushl $15
80105f61:	6a 0f                	push   $0xf
  jmp alltraps
80105f63:	e9 e1 fa ff ff       	jmp    80105a49 <alltraps>

80105f68 <vector16>:
.globl vector16
vector16:
  pushl $0
80105f68:	6a 00                	push   $0x0
  pushl $16
80105f6a:	6a 10                	push   $0x10
  jmp alltraps
80105f6c:	e9 d8 fa ff ff       	jmp    80105a49 <alltraps>

80105f71 <vector17>:
.globl vector17
vector17:
  pushl $17
80105f71:	6a 11                	push   $0x11
  jmp alltraps
80105f73:	e9 d1 fa ff ff       	jmp    80105a49 <alltraps>

80105f78 <vector18>:
.globl vector18
vector18:
  pushl $0
80105f78:	6a 00                	push   $0x0
  pushl $18
80105f7a:	6a 12                	push   $0x12
  jmp alltraps
80105f7c:	e9 c8 fa ff ff       	jmp    80105a49 <alltraps>

80105f81 <vector19>:
.globl vector19
vector19:
  pushl $0
80105f81:	6a 00                	push   $0x0
  pushl $19
80105f83:	6a 13                	push   $0x13
  jmp alltraps
80105f85:	e9 bf fa ff ff       	jmp    80105a49 <alltraps>

80105f8a <vector20>:
.globl vector20
vector20:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $20
80105f8c:	6a 14                	push   $0x14
  jmp alltraps
80105f8e:	e9 b6 fa ff ff       	jmp    80105a49 <alltraps>

80105f93 <vector21>:
.globl vector21
vector21:
  pushl $0
80105f93:	6a 00                	push   $0x0
  pushl $21
80105f95:	6a 15                	push   $0x15
  jmp alltraps
80105f97:	e9 ad fa ff ff       	jmp    80105a49 <alltraps>

80105f9c <vector22>:
.globl vector22
vector22:
  pushl $0
80105f9c:	6a 00                	push   $0x0
  pushl $22
80105f9e:	6a 16                	push   $0x16
  jmp alltraps
80105fa0:	e9 a4 fa ff ff       	jmp    80105a49 <alltraps>

80105fa5 <vector23>:
.globl vector23
vector23:
  pushl $0
80105fa5:	6a 00                	push   $0x0
  pushl $23
80105fa7:	6a 17                	push   $0x17
  jmp alltraps
80105fa9:	e9 9b fa ff ff       	jmp    80105a49 <alltraps>

80105fae <vector24>:
.globl vector24
vector24:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $24
80105fb0:	6a 18                	push   $0x18
  jmp alltraps
80105fb2:	e9 92 fa ff ff       	jmp    80105a49 <alltraps>

80105fb7 <vector25>:
.globl vector25
vector25:
  pushl $0
80105fb7:	6a 00                	push   $0x0
  pushl $25
80105fb9:	6a 19                	push   $0x19
  jmp alltraps
80105fbb:	e9 89 fa ff ff       	jmp    80105a49 <alltraps>

80105fc0 <vector26>:
.globl vector26
vector26:
  pushl $0
80105fc0:	6a 00                	push   $0x0
  pushl $26
80105fc2:	6a 1a                	push   $0x1a
  jmp alltraps
80105fc4:	e9 80 fa ff ff       	jmp    80105a49 <alltraps>

80105fc9 <vector27>:
.globl vector27
vector27:
  pushl $0
80105fc9:	6a 00                	push   $0x0
  pushl $27
80105fcb:	6a 1b                	push   $0x1b
  jmp alltraps
80105fcd:	e9 77 fa ff ff       	jmp    80105a49 <alltraps>

80105fd2 <vector28>:
.globl vector28
vector28:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $28
80105fd4:	6a 1c                	push   $0x1c
  jmp alltraps
80105fd6:	e9 6e fa ff ff       	jmp    80105a49 <alltraps>

80105fdb <vector29>:
.globl vector29
vector29:
  pushl $0
80105fdb:	6a 00                	push   $0x0
  pushl $29
80105fdd:	6a 1d                	push   $0x1d
  jmp alltraps
80105fdf:	e9 65 fa ff ff       	jmp    80105a49 <alltraps>

80105fe4 <vector30>:
.globl vector30
vector30:
  pushl $0
80105fe4:	6a 00                	push   $0x0
  pushl $30
80105fe6:	6a 1e                	push   $0x1e
  jmp alltraps
80105fe8:	e9 5c fa ff ff       	jmp    80105a49 <alltraps>

80105fed <vector31>:
.globl vector31
vector31:
  pushl $0
80105fed:	6a 00                	push   $0x0
  pushl $31
80105fef:	6a 1f                	push   $0x1f
  jmp alltraps
80105ff1:	e9 53 fa ff ff       	jmp    80105a49 <alltraps>

80105ff6 <vector32>:
.globl vector32
vector32:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $32
80105ff8:	6a 20                	push   $0x20
  jmp alltraps
80105ffa:	e9 4a fa ff ff       	jmp    80105a49 <alltraps>

80105fff <vector33>:
.globl vector33
vector33:
  pushl $0
80105fff:	6a 00                	push   $0x0
  pushl $33
80106001:	6a 21                	push   $0x21
  jmp alltraps
80106003:	e9 41 fa ff ff       	jmp    80105a49 <alltraps>

80106008 <vector34>:
.globl vector34
vector34:
  pushl $0
80106008:	6a 00                	push   $0x0
  pushl $34
8010600a:	6a 22                	push   $0x22
  jmp alltraps
8010600c:	e9 38 fa ff ff       	jmp    80105a49 <alltraps>

80106011 <vector35>:
.globl vector35
vector35:
  pushl $0
80106011:	6a 00                	push   $0x0
  pushl $35
80106013:	6a 23                	push   $0x23
  jmp alltraps
80106015:	e9 2f fa ff ff       	jmp    80105a49 <alltraps>

8010601a <vector36>:
.globl vector36
vector36:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $36
8010601c:	6a 24                	push   $0x24
  jmp alltraps
8010601e:	e9 26 fa ff ff       	jmp    80105a49 <alltraps>

80106023 <vector37>:
.globl vector37
vector37:
  pushl $0
80106023:	6a 00                	push   $0x0
  pushl $37
80106025:	6a 25                	push   $0x25
  jmp alltraps
80106027:	e9 1d fa ff ff       	jmp    80105a49 <alltraps>

8010602c <vector38>:
.globl vector38
vector38:
  pushl $0
8010602c:	6a 00                	push   $0x0
  pushl $38
8010602e:	6a 26                	push   $0x26
  jmp alltraps
80106030:	e9 14 fa ff ff       	jmp    80105a49 <alltraps>

80106035 <vector39>:
.globl vector39
vector39:
  pushl $0
80106035:	6a 00                	push   $0x0
  pushl $39
80106037:	6a 27                	push   $0x27
  jmp alltraps
80106039:	e9 0b fa ff ff       	jmp    80105a49 <alltraps>

8010603e <vector40>:
.globl vector40
vector40:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $40
80106040:	6a 28                	push   $0x28
  jmp alltraps
80106042:	e9 02 fa ff ff       	jmp    80105a49 <alltraps>

80106047 <vector41>:
.globl vector41
vector41:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $41
80106049:	6a 29                	push   $0x29
  jmp alltraps
8010604b:	e9 f9 f9 ff ff       	jmp    80105a49 <alltraps>

80106050 <vector42>:
.globl vector42
vector42:
  pushl $0
80106050:	6a 00                	push   $0x0
  pushl $42
80106052:	6a 2a                	push   $0x2a
  jmp alltraps
80106054:	e9 f0 f9 ff ff       	jmp    80105a49 <alltraps>

80106059 <vector43>:
.globl vector43
vector43:
  pushl $0
80106059:	6a 00                	push   $0x0
  pushl $43
8010605b:	6a 2b                	push   $0x2b
  jmp alltraps
8010605d:	e9 e7 f9 ff ff       	jmp    80105a49 <alltraps>

80106062 <vector44>:
.globl vector44
vector44:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $44
80106064:	6a 2c                	push   $0x2c
  jmp alltraps
80106066:	e9 de f9 ff ff       	jmp    80105a49 <alltraps>

8010606b <vector45>:
.globl vector45
vector45:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $45
8010606d:	6a 2d                	push   $0x2d
  jmp alltraps
8010606f:	e9 d5 f9 ff ff       	jmp    80105a49 <alltraps>

80106074 <vector46>:
.globl vector46
vector46:
  pushl $0
80106074:	6a 00                	push   $0x0
  pushl $46
80106076:	6a 2e                	push   $0x2e
  jmp alltraps
80106078:	e9 cc f9 ff ff       	jmp    80105a49 <alltraps>

8010607d <vector47>:
.globl vector47
vector47:
  pushl $0
8010607d:	6a 00                	push   $0x0
  pushl $47
8010607f:	6a 2f                	push   $0x2f
  jmp alltraps
80106081:	e9 c3 f9 ff ff       	jmp    80105a49 <alltraps>

80106086 <vector48>:
.globl vector48
vector48:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $48
80106088:	6a 30                	push   $0x30
  jmp alltraps
8010608a:	e9 ba f9 ff ff       	jmp    80105a49 <alltraps>

8010608f <vector49>:
.globl vector49
vector49:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $49
80106091:	6a 31                	push   $0x31
  jmp alltraps
80106093:	e9 b1 f9 ff ff       	jmp    80105a49 <alltraps>

80106098 <vector50>:
.globl vector50
vector50:
  pushl $0
80106098:	6a 00                	push   $0x0
  pushl $50
8010609a:	6a 32                	push   $0x32
  jmp alltraps
8010609c:	e9 a8 f9 ff ff       	jmp    80105a49 <alltraps>

801060a1 <vector51>:
.globl vector51
vector51:
  pushl $0
801060a1:	6a 00                	push   $0x0
  pushl $51
801060a3:	6a 33                	push   $0x33
  jmp alltraps
801060a5:	e9 9f f9 ff ff       	jmp    80105a49 <alltraps>

801060aa <vector52>:
.globl vector52
vector52:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $52
801060ac:	6a 34                	push   $0x34
  jmp alltraps
801060ae:	e9 96 f9 ff ff       	jmp    80105a49 <alltraps>

801060b3 <vector53>:
.globl vector53
vector53:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $53
801060b5:	6a 35                	push   $0x35
  jmp alltraps
801060b7:	e9 8d f9 ff ff       	jmp    80105a49 <alltraps>

801060bc <vector54>:
.globl vector54
vector54:
  pushl $0
801060bc:	6a 00                	push   $0x0
  pushl $54
801060be:	6a 36                	push   $0x36
  jmp alltraps
801060c0:	e9 84 f9 ff ff       	jmp    80105a49 <alltraps>

801060c5 <vector55>:
.globl vector55
vector55:
  pushl $0
801060c5:	6a 00                	push   $0x0
  pushl $55
801060c7:	6a 37                	push   $0x37
  jmp alltraps
801060c9:	e9 7b f9 ff ff       	jmp    80105a49 <alltraps>

801060ce <vector56>:
.globl vector56
vector56:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $56
801060d0:	6a 38                	push   $0x38
  jmp alltraps
801060d2:	e9 72 f9 ff ff       	jmp    80105a49 <alltraps>

801060d7 <vector57>:
.globl vector57
vector57:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $57
801060d9:	6a 39                	push   $0x39
  jmp alltraps
801060db:	e9 69 f9 ff ff       	jmp    80105a49 <alltraps>

801060e0 <vector58>:
.globl vector58
vector58:
  pushl $0
801060e0:	6a 00                	push   $0x0
  pushl $58
801060e2:	6a 3a                	push   $0x3a
  jmp alltraps
801060e4:	e9 60 f9 ff ff       	jmp    80105a49 <alltraps>

801060e9 <vector59>:
.globl vector59
vector59:
  pushl $0
801060e9:	6a 00                	push   $0x0
  pushl $59
801060eb:	6a 3b                	push   $0x3b
  jmp alltraps
801060ed:	e9 57 f9 ff ff       	jmp    80105a49 <alltraps>

801060f2 <vector60>:
.globl vector60
vector60:
  pushl $0
801060f2:	6a 00                	push   $0x0
  pushl $60
801060f4:	6a 3c                	push   $0x3c
  jmp alltraps
801060f6:	e9 4e f9 ff ff       	jmp    80105a49 <alltraps>

801060fb <vector61>:
.globl vector61
vector61:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $61
801060fd:	6a 3d                	push   $0x3d
  jmp alltraps
801060ff:	e9 45 f9 ff ff       	jmp    80105a49 <alltraps>

80106104 <vector62>:
.globl vector62
vector62:
  pushl $0
80106104:	6a 00                	push   $0x0
  pushl $62
80106106:	6a 3e                	push   $0x3e
  jmp alltraps
80106108:	e9 3c f9 ff ff       	jmp    80105a49 <alltraps>

8010610d <vector63>:
.globl vector63
vector63:
  pushl $0
8010610d:	6a 00                	push   $0x0
  pushl $63
8010610f:	6a 3f                	push   $0x3f
  jmp alltraps
80106111:	e9 33 f9 ff ff       	jmp    80105a49 <alltraps>

80106116 <vector64>:
.globl vector64
vector64:
  pushl $0
80106116:	6a 00                	push   $0x0
  pushl $64
80106118:	6a 40                	push   $0x40
  jmp alltraps
8010611a:	e9 2a f9 ff ff       	jmp    80105a49 <alltraps>

8010611f <vector65>:
.globl vector65
vector65:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $65
80106121:	6a 41                	push   $0x41
  jmp alltraps
80106123:	e9 21 f9 ff ff       	jmp    80105a49 <alltraps>

80106128 <vector66>:
.globl vector66
vector66:
  pushl $0
80106128:	6a 00                	push   $0x0
  pushl $66
8010612a:	6a 42                	push   $0x42
  jmp alltraps
8010612c:	e9 18 f9 ff ff       	jmp    80105a49 <alltraps>

80106131 <vector67>:
.globl vector67
vector67:
  pushl $0
80106131:	6a 00                	push   $0x0
  pushl $67
80106133:	6a 43                	push   $0x43
  jmp alltraps
80106135:	e9 0f f9 ff ff       	jmp    80105a49 <alltraps>

8010613a <vector68>:
.globl vector68
vector68:
  pushl $0
8010613a:	6a 00                	push   $0x0
  pushl $68
8010613c:	6a 44                	push   $0x44
  jmp alltraps
8010613e:	e9 06 f9 ff ff       	jmp    80105a49 <alltraps>

80106143 <vector69>:
.globl vector69
vector69:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $69
80106145:	6a 45                	push   $0x45
  jmp alltraps
80106147:	e9 fd f8 ff ff       	jmp    80105a49 <alltraps>

8010614c <vector70>:
.globl vector70
vector70:
  pushl $0
8010614c:	6a 00                	push   $0x0
  pushl $70
8010614e:	6a 46                	push   $0x46
  jmp alltraps
80106150:	e9 f4 f8 ff ff       	jmp    80105a49 <alltraps>

80106155 <vector71>:
.globl vector71
vector71:
  pushl $0
80106155:	6a 00                	push   $0x0
  pushl $71
80106157:	6a 47                	push   $0x47
  jmp alltraps
80106159:	e9 eb f8 ff ff       	jmp    80105a49 <alltraps>

8010615e <vector72>:
.globl vector72
vector72:
  pushl $0
8010615e:	6a 00                	push   $0x0
  pushl $72
80106160:	6a 48                	push   $0x48
  jmp alltraps
80106162:	e9 e2 f8 ff ff       	jmp    80105a49 <alltraps>

80106167 <vector73>:
.globl vector73
vector73:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $73
80106169:	6a 49                	push   $0x49
  jmp alltraps
8010616b:	e9 d9 f8 ff ff       	jmp    80105a49 <alltraps>

80106170 <vector74>:
.globl vector74
vector74:
  pushl $0
80106170:	6a 00                	push   $0x0
  pushl $74
80106172:	6a 4a                	push   $0x4a
  jmp alltraps
80106174:	e9 d0 f8 ff ff       	jmp    80105a49 <alltraps>

80106179 <vector75>:
.globl vector75
vector75:
  pushl $0
80106179:	6a 00                	push   $0x0
  pushl $75
8010617b:	6a 4b                	push   $0x4b
  jmp alltraps
8010617d:	e9 c7 f8 ff ff       	jmp    80105a49 <alltraps>

80106182 <vector76>:
.globl vector76
vector76:
  pushl $0
80106182:	6a 00                	push   $0x0
  pushl $76
80106184:	6a 4c                	push   $0x4c
  jmp alltraps
80106186:	e9 be f8 ff ff       	jmp    80105a49 <alltraps>

8010618b <vector77>:
.globl vector77
vector77:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $77
8010618d:	6a 4d                	push   $0x4d
  jmp alltraps
8010618f:	e9 b5 f8 ff ff       	jmp    80105a49 <alltraps>

80106194 <vector78>:
.globl vector78
vector78:
  pushl $0
80106194:	6a 00                	push   $0x0
  pushl $78
80106196:	6a 4e                	push   $0x4e
  jmp alltraps
80106198:	e9 ac f8 ff ff       	jmp    80105a49 <alltraps>

8010619d <vector79>:
.globl vector79
vector79:
  pushl $0
8010619d:	6a 00                	push   $0x0
  pushl $79
8010619f:	6a 4f                	push   $0x4f
  jmp alltraps
801061a1:	e9 a3 f8 ff ff       	jmp    80105a49 <alltraps>

801061a6 <vector80>:
.globl vector80
vector80:
  pushl $0
801061a6:	6a 00                	push   $0x0
  pushl $80
801061a8:	6a 50                	push   $0x50
  jmp alltraps
801061aa:	e9 9a f8 ff ff       	jmp    80105a49 <alltraps>

801061af <vector81>:
.globl vector81
vector81:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $81
801061b1:	6a 51                	push   $0x51
  jmp alltraps
801061b3:	e9 91 f8 ff ff       	jmp    80105a49 <alltraps>

801061b8 <vector82>:
.globl vector82
vector82:
  pushl $0
801061b8:	6a 00                	push   $0x0
  pushl $82
801061ba:	6a 52                	push   $0x52
  jmp alltraps
801061bc:	e9 88 f8 ff ff       	jmp    80105a49 <alltraps>

801061c1 <vector83>:
.globl vector83
vector83:
  pushl $0
801061c1:	6a 00                	push   $0x0
  pushl $83
801061c3:	6a 53                	push   $0x53
  jmp alltraps
801061c5:	e9 7f f8 ff ff       	jmp    80105a49 <alltraps>

801061ca <vector84>:
.globl vector84
vector84:
  pushl $0
801061ca:	6a 00                	push   $0x0
  pushl $84
801061cc:	6a 54                	push   $0x54
  jmp alltraps
801061ce:	e9 76 f8 ff ff       	jmp    80105a49 <alltraps>

801061d3 <vector85>:
.globl vector85
vector85:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $85
801061d5:	6a 55                	push   $0x55
  jmp alltraps
801061d7:	e9 6d f8 ff ff       	jmp    80105a49 <alltraps>

801061dc <vector86>:
.globl vector86
vector86:
  pushl $0
801061dc:	6a 00                	push   $0x0
  pushl $86
801061de:	6a 56                	push   $0x56
  jmp alltraps
801061e0:	e9 64 f8 ff ff       	jmp    80105a49 <alltraps>

801061e5 <vector87>:
.globl vector87
vector87:
  pushl $0
801061e5:	6a 00                	push   $0x0
  pushl $87
801061e7:	6a 57                	push   $0x57
  jmp alltraps
801061e9:	e9 5b f8 ff ff       	jmp    80105a49 <alltraps>

801061ee <vector88>:
.globl vector88
vector88:
  pushl $0
801061ee:	6a 00                	push   $0x0
  pushl $88
801061f0:	6a 58                	push   $0x58
  jmp alltraps
801061f2:	e9 52 f8 ff ff       	jmp    80105a49 <alltraps>

801061f7 <vector89>:
.globl vector89
vector89:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $89
801061f9:	6a 59                	push   $0x59
  jmp alltraps
801061fb:	e9 49 f8 ff ff       	jmp    80105a49 <alltraps>

80106200 <vector90>:
.globl vector90
vector90:
  pushl $0
80106200:	6a 00                	push   $0x0
  pushl $90
80106202:	6a 5a                	push   $0x5a
  jmp alltraps
80106204:	e9 40 f8 ff ff       	jmp    80105a49 <alltraps>

80106209 <vector91>:
.globl vector91
vector91:
  pushl $0
80106209:	6a 00                	push   $0x0
  pushl $91
8010620b:	6a 5b                	push   $0x5b
  jmp alltraps
8010620d:	e9 37 f8 ff ff       	jmp    80105a49 <alltraps>

80106212 <vector92>:
.globl vector92
vector92:
  pushl $0
80106212:	6a 00                	push   $0x0
  pushl $92
80106214:	6a 5c                	push   $0x5c
  jmp alltraps
80106216:	e9 2e f8 ff ff       	jmp    80105a49 <alltraps>

8010621b <vector93>:
.globl vector93
vector93:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $93
8010621d:	6a 5d                	push   $0x5d
  jmp alltraps
8010621f:	e9 25 f8 ff ff       	jmp    80105a49 <alltraps>

80106224 <vector94>:
.globl vector94
vector94:
  pushl $0
80106224:	6a 00                	push   $0x0
  pushl $94
80106226:	6a 5e                	push   $0x5e
  jmp alltraps
80106228:	e9 1c f8 ff ff       	jmp    80105a49 <alltraps>

8010622d <vector95>:
.globl vector95
vector95:
  pushl $0
8010622d:	6a 00                	push   $0x0
  pushl $95
8010622f:	6a 5f                	push   $0x5f
  jmp alltraps
80106231:	e9 13 f8 ff ff       	jmp    80105a49 <alltraps>

80106236 <vector96>:
.globl vector96
vector96:
  pushl $0
80106236:	6a 00                	push   $0x0
  pushl $96
80106238:	6a 60                	push   $0x60
  jmp alltraps
8010623a:	e9 0a f8 ff ff       	jmp    80105a49 <alltraps>

8010623f <vector97>:
.globl vector97
vector97:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $97
80106241:	6a 61                	push   $0x61
  jmp alltraps
80106243:	e9 01 f8 ff ff       	jmp    80105a49 <alltraps>

80106248 <vector98>:
.globl vector98
vector98:
  pushl $0
80106248:	6a 00                	push   $0x0
  pushl $98
8010624a:	6a 62                	push   $0x62
  jmp alltraps
8010624c:	e9 f8 f7 ff ff       	jmp    80105a49 <alltraps>

80106251 <vector99>:
.globl vector99
vector99:
  pushl $0
80106251:	6a 00                	push   $0x0
  pushl $99
80106253:	6a 63                	push   $0x63
  jmp alltraps
80106255:	e9 ef f7 ff ff       	jmp    80105a49 <alltraps>

8010625a <vector100>:
.globl vector100
vector100:
  pushl $0
8010625a:	6a 00                	push   $0x0
  pushl $100
8010625c:	6a 64                	push   $0x64
  jmp alltraps
8010625e:	e9 e6 f7 ff ff       	jmp    80105a49 <alltraps>

80106263 <vector101>:
.globl vector101
vector101:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $101
80106265:	6a 65                	push   $0x65
  jmp alltraps
80106267:	e9 dd f7 ff ff       	jmp    80105a49 <alltraps>

8010626c <vector102>:
.globl vector102
vector102:
  pushl $0
8010626c:	6a 00                	push   $0x0
  pushl $102
8010626e:	6a 66                	push   $0x66
  jmp alltraps
80106270:	e9 d4 f7 ff ff       	jmp    80105a49 <alltraps>

80106275 <vector103>:
.globl vector103
vector103:
  pushl $0
80106275:	6a 00                	push   $0x0
  pushl $103
80106277:	6a 67                	push   $0x67
  jmp alltraps
80106279:	e9 cb f7 ff ff       	jmp    80105a49 <alltraps>

8010627e <vector104>:
.globl vector104
vector104:
  pushl $0
8010627e:	6a 00                	push   $0x0
  pushl $104
80106280:	6a 68                	push   $0x68
  jmp alltraps
80106282:	e9 c2 f7 ff ff       	jmp    80105a49 <alltraps>

80106287 <vector105>:
.globl vector105
vector105:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $105
80106289:	6a 69                	push   $0x69
  jmp alltraps
8010628b:	e9 b9 f7 ff ff       	jmp    80105a49 <alltraps>

80106290 <vector106>:
.globl vector106
vector106:
  pushl $0
80106290:	6a 00                	push   $0x0
  pushl $106
80106292:	6a 6a                	push   $0x6a
  jmp alltraps
80106294:	e9 b0 f7 ff ff       	jmp    80105a49 <alltraps>

80106299 <vector107>:
.globl vector107
vector107:
  pushl $0
80106299:	6a 00                	push   $0x0
  pushl $107
8010629b:	6a 6b                	push   $0x6b
  jmp alltraps
8010629d:	e9 a7 f7 ff ff       	jmp    80105a49 <alltraps>

801062a2 <vector108>:
.globl vector108
vector108:
  pushl $0
801062a2:	6a 00                	push   $0x0
  pushl $108
801062a4:	6a 6c                	push   $0x6c
  jmp alltraps
801062a6:	e9 9e f7 ff ff       	jmp    80105a49 <alltraps>

801062ab <vector109>:
.globl vector109
vector109:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $109
801062ad:	6a 6d                	push   $0x6d
  jmp alltraps
801062af:	e9 95 f7 ff ff       	jmp    80105a49 <alltraps>

801062b4 <vector110>:
.globl vector110
vector110:
  pushl $0
801062b4:	6a 00                	push   $0x0
  pushl $110
801062b6:	6a 6e                	push   $0x6e
  jmp alltraps
801062b8:	e9 8c f7 ff ff       	jmp    80105a49 <alltraps>

801062bd <vector111>:
.globl vector111
vector111:
  pushl $0
801062bd:	6a 00                	push   $0x0
  pushl $111
801062bf:	6a 6f                	push   $0x6f
  jmp alltraps
801062c1:	e9 83 f7 ff ff       	jmp    80105a49 <alltraps>

801062c6 <vector112>:
.globl vector112
vector112:
  pushl $0
801062c6:	6a 00                	push   $0x0
  pushl $112
801062c8:	6a 70                	push   $0x70
  jmp alltraps
801062ca:	e9 7a f7 ff ff       	jmp    80105a49 <alltraps>

801062cf <vector113>:
.globl vector113
vector113:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $113
801062d1:	6a 71                	push   $0x71
  jmp alltraps
801062d3:	e9 71 f7 ff ff       	jmp    80105a49 <alltraps>

801062d8 <vector114>:
.globl vector114
vector114:
  pushl $0
801062d8:	6a 00                	push   $0x0
  pushl $114
801062da:	6a 72                	push   $0x72
  jmp alltraps
801062dc:	e9 68 f7 ff ff       	jmp    80105a49 <alltraps>

801062e1 <vector115>:
.globl vector115
vector115:
  pushl $0
801062e1:	6a 00                	push   $0x0
  pushl $115
801062e3:	6a 73                	push   $0x73
  jmp alltraps
801062e5:	e9 5f f7 ff ff       	jmp    80105a49 <alltraps>

801062ea <vector116>:
.globl vector116
vector116:
  pushl $0
801062ea:	6a 00                	push   $0x0
  pushl $116
801062ec:	6a 74                	push   $0x74
  jmp alltraps
801062ee:	e9 56 f7 ff ff       	jmp    80105a49 <alltraps>

801062f3 <vector117>:
.globl vector117
vector117:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $117
801062f5:	6a 75                	push   $0x75
  jmp alltraps
801062f7:	e9 4d f7 ff ff       	jmp    80105a49 <alltraps>

801062fc <vector118>:
.globl vector118
vector118:
  pushl $0
801062fc:	6a 00                	push   $0x0
  pushl $118
801062fe:	6a 76                	push   $0x76
  jmp alltraps
80106300:	e9 44 f7 ff ff       	jmp    80105a49 <alltraps>

80106305 <vector119>:
.globl vector119
vector119:
  pushl $0
80106305:	6a 00                	push   $0x0
  pushl $119
80106307:	6a 77                	push   $0x77
  jmp alltraps
80106309:	e9 3b f7 ff ff       	jmp    80105a49 <alltraps>

8010630e <vector120>:
.globl vector120
vector120:
  pushl $0
8010630e:	6a 00                	push   $0x0
  pushl $120
80106310:	6a 78                	push   $0x78
  jmp alltraps
80106312:	e9 32 f7 ff ff       	jmp    80105a49 <alltraps>

80106317 <vector121>:
.globl vector121
vector121:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $121
80106319:	6a 79                	push   $0x79
  jmp alltraps
8010631b:	e9 29 f7 ff ff       	jmp    80105a49 <alltraps>

80106320 <vector122>:
.globl vector122
vector122:
  pushl $0
80106320:	6a 00                	push   $0x0
  pushl $122
80106322:	6a 7a                	push   $0x7a
  jmp alltraps
80106324:	e9 20 f7 ff ff       	jmp    80105a49 <alltraps>

80106329 <vector123>:
.globl vector123
vector123:
  pushl $0
80106329:	6a 00                	push   $0x0
  pushl $123
8010632b:	6a 7b                	push   $0x7b
  jmp alltraps
8010632d:	e9 17 f7 ff ff       	jmp    80105a49 <alltraps>

80106332 <vector124>:
.globl vector124
vector124:
  pushl $0
80106332:	6a 00                	push   $0x0
  pushl $124
80106334:	6a 7c                	push   $0x7c
  jmp alltraps
80106336:	e9 0e f7 ff ff       	jmp    80105a49 <alltraps>

8010633b <vector125>:
.globl vector125
vector125:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $125
8010633d:	6a 7d                	push   $0x7d
  jmp alltraps
8010633f:	e9 05 f7 ff ff       	jmp    80105a49 <alltraps>

80106344 <vector126>:
.globl vector126
vector126:
  pushl $0
80106344:	6a 00                	push   $0x0
  pushl $126
80106346:	6a 7e                	push   $0x7e
  jmp alltraps
80106348:	e9 fc f6 ff ff       	jmp    80105a49 <alltraps>

8010634d <vector127>:
.globl vector127
vector127:
  pushl $0
8010634d:	6a 00                	push   $0x0
  pushl $127
8010634f:	6a 7f                	push   $0x7f
  jmp alltraps
80106351:	e9 f3 f6 ff ff       	jmp    80105a49 <alltraps>

80106356 <vector128>:
.globl vector128
vector128:
  pushl $0
80106356:	6a 00                	push   $0x0
  pushl $128
80106358:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010635d:	e9 e7 f6 ff ff       	jmp    80105a49 <alltraps>

80106362 <vector129>:
.globl vector129
vector129:
  pushl $0
80106362:	6a 00                	push   $0x0
  pushl $129
80106364:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106369:	e9 db f6 ff ff       	jmp    80105a49 <alltraps>

8010636e <vector130>:
.globl vector130
vector130:
  pushl $0
8010636e:	6a 00                	push   $0x0
  pushl $130
80106370:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106375:	e9 cf f6 ff ff       	jmp    80105a49 <alltraps>

8010637a <vector131>:
.globl vector131
vector131:
  pushl $0
8010637a:	6a 00                	push   $0x0
  pushl $131
8010637c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106381:	e9 c3 f6 ff ff       	jmp    80105a49 <alltraps>

80106386 <vector132>:
.globl vector132
vector132:
  pushl $0
80106386:	6a 00                	push   $0x0
  pushl $132
80106388:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010638d:	e9 b7 f6 ff ff       	jmp    80105a49 <alltraps>

80106392 <vector133>:
.globl vector133
vector133:
  pushl $0
80106392:	6a 00                	push   $0x0
  pushl $133
80106394:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106399:	e9 ab f6 ff ff       	jmp    80105a49 <alltraps>

8010639e <vector134>:
.globl vector134
vector134:
  pushl $0
8010639e:	6a 00                	push   $0x0
  pushl $134
801063a0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801063a5:	e9 9f f6 ff ff       	jmp    80105a49 <alltraps>

801063aa <vector135>:
.globl vector135
vector135:
  pushl $0
801063aa:	6a 00                	push   $0x0
  pushl $135
801063ac:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801063b1:	e9 93 f6 ff ff       	jmp    80105a49 <alltraps>

801063b6 <vector136>:
.globl vector136
vector136:
  pushl $0
801063b6:	6a 00                	push   $0x0
  pushl $136
801063b8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801063bd:	e9 87 f6 ff ff       	jmp    80105a49 <alltraps>

801063c2 <vector137>:
.globl vector137
vector137:
  pushl $0
801063c2:	6a 00                	push   $0x0
  pushl $137
801063c4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801063c9:	e9 7b f6 ff ff       	jmp    80105a49 <alltraps>

801063ce <vector138>:
.globl vector138
vector138:
  pushl $0
801063ce:	6a 00                	push   $0x0
  pushl $138
801063d0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801063d5:	e9 6f f6 ff ff       	jmp    80105a49 <alltraps>

801063da <vector139>:
.globl vector139
vector139:
  pushl $0
801063da:	6a 00                	push   $0x0
  pushl $139
801063dc:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801063e1:	e9 63 f6 ff ff       	jmp    80105a49 <alltraps>

801063e6 <vector140>:
.globl vector140
vector140:
  pushl $0
801063e6:	6a 00                	push   $0x0
  pushl $140
801063e8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801063ed:	e9 57 f6 ff ff       	jmp    80105a49 <alltraps>

801063f2 <vector141>:
.globl vector141
vector141:
  pushl $0
801063f2:	6a 00                	push   $0x0
  pushl $141
801063f4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801063f9:	e9 4b f6 ff ff       	jmp    80105a49 <alltraps>

801063fe <vector142>:
.globl vector142
vector142:
  pushl $0
801063fe:	6a 00                	push   $0x0
  pushl $142
80106400:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106405:	e9 3f f6 ff ff       	jmp    80105a49 <alltraps>

8010640a <vector143>:
.globl vector143
vector143:
  pushl $0
8010640a:	6a 00                	push   $0x0
  pushl $143
8010640c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106411:	e9 33 f6 ff ff       	jmp    80105a49 <alltraps>

80106416 <vector144>:
.globl vector144
vector144:
  pushl $0
80106416:	6a 00                	push   $0x0
  pushl $144
80106418:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010641d:	e9 27 f6 ff ff       	jmp    80105a49 <alltraps>

80106422 <vector145>:
.globl vector145
vector145:
  pushl $0
80106422:	6a 00                	push   $0x0
  pushl $145
80106424:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106429:	e9 1b f6 ff ff       	jmp    80105a49 <alltraps>

8010642e <vector146>:
.globl vector146
vector146:
  pushl $0
8010642e:	6a 00                	push   $0x0
  pushl $146
80106430:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106435:	e9 0f f6 ff ff       	jmp    80105a49 <alltraps>

8010643a <vector147>:
.globl vector147
vector147:
  pushl $0
8010643a:	6a 00                	push   $0x0
  pushl $147
8010643c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106441:	e9 03 f6 ff ff       	jmp    80105a49 <alltraps>

80106446 <vector148>:
.globl vector148
vector148:
  pushl $0
80106446:	6a 00                	push   $0x0
  pushl $148
80106448:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010644d:	e9 f7 f5 ff ff       	jmp    80105a49 <alltraps>

80106452 <vector149>:
.globl vector149
vector149:
  pushl $0
80106452:	6a 00                	push   $0x0
  pushl $149
80106454:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106459:	e9 eb f5 ff ff       	jmp    80105a49 <alltraps>

8010645e <vector150>:
.globl vector150
vector150:
  pushl $0
8010645e:	6a 00                	push   $0x0
  pushl $150
80106460:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106465:	e9 df f5 ff ff       	jmp    80105a49 <alltraps>

8010646a <vector151>:
.globl vector151
vector151:
  pushl $0
8010646a:	6a 00                	push   $0x0
  pushl $151
8010646c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106471:	e9 d3 f5 ff ff       	jmp    80105a49 <alltraps>

80106476 <vector152>:
.globl vector152
vector152:
  pushl $0
80106476:	6a 00                	push   $0x0
  pushl $152
80106478:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010647d:	e9 c7 f5 ff ff       	jmp    80105a49 <alltraps>

80106482 <vector153>:
.globl vector153
vector153:
  pushl $0
80106482:	6a 00                	push   $0x0
  pushl $153
80106484:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106489:	e9 bb f5 ff ff       	jmp    80105a49 <alltraps>

8010648e <vector154>:
.globl vector154
vector154:
  pushl $0
8010648e:	6a 00                	push   $0x0
  pushl $154
80106490:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106495:	e9 af f5 ff ff       	jmp    80105a49 <alltraps>

8010649a <vector155>:
.globl vector155
vector155:
  pushl $0
8010649a:	6a 00                	push   $0x0
  pushl $155
8010649c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801064a1:	e9 a3 f5 ff ff       	jmp    80105a49 <alltraps>

801064a6 <vector156>:
.globl vector156
vector156:
  pushl $0
801064a6:	6a 00                	push   $0x0
  pushl $156
801064a8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801064ad:	e9 97 f5 ff ff       	jmp    80105a49 <alltraps>

801064b2 <vector157>:
.globl vector157
vector157:
  pushl $0
801064b2:	6a 00                	push   $0x0
  pushl $157
801064b4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801064b9:	e9 8b f5 ff ff       	jmp    80105a49 <alltraps>

801064be <vector158>:
.globl vector158
vector158:
  pushl $0
801064be:	6a 00                	push   $0x0
  pushl $158
801064c0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801064c5:	e9 7f f5 ff ff       	jmp    80105a49 <alltraps>

801064ca <vector159>:
.globl vector159
vector159:
  pushl $0
801064ca:	6a 00                	push   $0x0
  pushl $159
801064cc:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801064d1:	e9 73 f5 ff ff       	jmp    80105a49 <alltraps>

801064d6 <vector160>:
.globl vector160
vector160:
  pushl $0
801064d6:	6a 00                	push   $0x0
  pushl $160
801064d8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801064dd:	e9 67 f5 ff ff       	jmp    80105a49 <alltraps>

801064e2 <vector161>:
.globl vector161
vector161:
  pushl $0
801064e2:	6a 00                	push   $0x0
  pushl $161
801064e4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801064e9:	e9 5b f5 ff ff       	jmp    80105a49 <alltraps>

801064ee <vector162>:
.globl vector162
vector162:
  pushl $0
801064ee:	6a 00                	push   $0x0
  pushl $162
801064f0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801064f5:	e9 4f f5 ff ff       	jmp    80105a49 <alltraps>

801064fa <vector163>:
.globl vector163
vector163:
  pushl $0
801064fa:	6a 00                	push   $0x0
  pushl $163
801064fc:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106501:	e9 43 f5 ff ff       	jmp    80105a49 <alltraps>

80106506 <vector164>:
.globl vector164
vector164:
  pushl $0
80106506:	6a 00                	push   $0x0
  pushl $164
80106508:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010650d:	e9 37 f5 ff ff       	jmp    80105a49 <alltraps>

80106512 <vector165>:
.globl vector165
vector165:
  pushl $0
80106512:	6a 00                	push   $0x0
  pushl $165
80106514:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106519:	e9 2b f5 ff ff       	jmp    80105a49 <alltraps>

8010651e <vector166>:
.globl vector166
vector166:
  pushl $0
8010651e:	6a 00                	push   $0x0
  pushl $166
80106520:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106525:	e9 1f f5 ff ff       	jmp    80105a49 <alltraps>

8010652a <vector167>:
.globl vector167
vector167:
  pushl $0
8010652a:	6a 00                	push   $0x0
  pushl $167
8010652c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106531:	e9 13 f5 ff ff       	jmp    80105a49 <alltraps>

80106536 <vector168>:
.globl vector168
vector168:
  pushl $0
80106536:	6a 00                	push   $0x0
  pushl $168
80106538:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010653d:	e9 07 f5 ff ff       	jmp    80105a49 <alltraps>

80106542 <vector169>:
.globl vector169
vector169:
  pushl $0
80106542:	6a 00                	push   $0x0
  pushl $169
80106544:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106549:	e9 fb f4 ff ff       	jmp    80105a49 <alltraps>

8010654e <vector170>:
.globl vector170
vector170:
  pushl $0
8010654e:	6a 00                	push   $0x0
  pushl $170
80106550:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106555:	e9 ef f4 ff ff       	jmp    80105a49 <alltraps>

8010655a <vector171>:
.globl vector171
vector171:
  pushl $0
8010655a:	6a 00                	push   $0x0
  pushl $171
8010655c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106561:	e9 e3 f4 ff ff       	jmp    80105a49 <alltraps>

80106566 <vector172>:
.globl vector172
vector172:
  pushl $0
80106566:	6a 00                	push   $0x0
  pushl $172
80106568:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010656d:	e9 d7 f4 ff ff       	jmp    80105a49 <alltraps>

80106572 <vector173>:
.globl vector173
vector173:
  pushl $0
80106572:	6a 00                	push   $0x0
  pushl $173
80106574:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106579:	e9 cb f4 ff ff       	jmp    80105a49 <alltraps>

8010657e <vector174>:
.globl vector174
vector174:
  pushl $0
8010657e:	6a 00                	push   $0x0
  pushl $174
80106580:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106585:	e9 bf f4 ff ff       	jmp    80105a49 <alltraps>

8010658a <vector175>:
.globl vector175
vector175:
  pushl $0
8010658a:	6a 00                	push   $0x0
  pushl $175
8010658c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106591:	e9 b3 f4 ff ff       	jmp    80105a49 <alltraps>

80106596 <vector176>:
.globl vector176
vector176:
  pushl $0
80106596:	6a 00                	push   $0x0
  pushl $176
80106598:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010659d:	e9 a7 f4 ff ff       	jmp    80105a49 <alltraps>

801065a2 <vector177>:
.globl vector177
vector177:
  pushl $0
801065a2:	6a 00                	push   $0x0
  pushl $177
801065a4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801065a9:	e9 9b f4 ff ff       	jmp    80105a49 <alltraps>

801065ae <vector178>:
.globl vector178
vector178:
  pushl $0
801065ae:	6a 00                	push   $0x0
  pushl $178
801065b0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801065b5:	e9 8f f4 ff ff       	jmp    80105a49 <alltraps>

801065ba <vector179>:
.globl vector179
vector179:
  pushl $0
801065ba:	6a 00                	push   $0x0
  pushl $179
801065bc:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801065c1:	e9 83 f4 ff ff       	jmp    80105a49 <alltraps>

801065c6 <vector180>:
.globl vector180
vector180:
  pushl $0
801065c6:	6a 00                	push   $0x0
  pushl $180
801065c8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801065cd:	e9 77 f4 ff ff       	jmp    80105a49 <alltraps>

801065d2 <vector181>:
.globl vector181
vector181:
  pushl $0
801065d2:	6a 00                	push   $0x0
  pushl $181
801065d4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801065d9:	e9 6b f4 ff ff       	jmp    80105a49 <alltraps>

801065de <vector182>:
.globl vector182
vector182:
  pushl $0
801065de:	6a 00                	push   $0x0
  pushl $182
801065e0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801065e5:	e9 5f f4 ff ff       	jmp    80105a49 <alltraps>

801065ea <vector183>:
.globl vector183
vector183:
  pushl $0
801065ea:	6a 00                	push   $0x0
  pushl $183
801065ec:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801065f1:	e9 53 f4 ff ff       	jmp    80105a49 <alltraps>

801065f6 <vector184>:
.globl vector184
vector184:
  pushl $0
801065f6:	6a 00                	push   $0x0
  pushl $184
801065f8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801065fd:	e9 47 f4 ff ff       	jmp    80105a49 <alltraps>

80106602 <vector185>:
.globl vector185
vector185:
  pushl $0
80106602:	6a 00                	push   $0x0
  pushl $185
80106604:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106609:	e9 3b f4 ff ff       	jmp    80105a49 <alltraps>

8010660e <vector186>:
.globl vector186
vector186:
  pushl $0
8010660e:	6a 00                	push   $0x0
  pushl $186
80106610:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106615:	e9 2f f4 ff ff       	jmp    80105a49 <alltraps>

8010661a <vector187>:
.globl vector187
vector187:
  pushl $0
8010661a:	6a 00                	push   $0x0
  pushl $187
8010661c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106621:	e9 23 f4 ff ff       	jmp    80105a49 <alltraps>

80106626 <vector188>:
.globl vector188
vector188:
  pushl $0
80106626:	6a 00                	push   $0x0
  pushl $188
80106628:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010662d:	e9 17 f4 ff ff       	jmp    80105a49 <alltraps>

80106632 <vector189>:
.globl vector189
vector189:
  pushl $0
80106632:	6a 00                	push   $0x0
  pushl $189
80106634:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106639:	e9 0b f4 ff ff       	jmp    80105a49 <alltraps>

8010663e <vector190>:
.globl vector190
vector190:
  pushl $0
8010663e:	6a 00                	push   $0x0
  pushl $190
80106640:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106645:	e9 ff f3 ff ff       	jmp    80105a49 <alltraps>

8010664a <vector191>:
.globl vector191
vector191:
  pushl $0
8010664a:	6a 00                	push   $0x0
  pushl $191
8010664c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106651:	e9 f3 f3 ff ff       	jmp    80105a49 <alltraps>

80106656 <vector192>:
.globl vector192
vector192:
  pushl $0
80106656:	6a 00                	push   $0x0
  pushl $192
80106658:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010665d:	e9 e7 f3 ff ff       	jmp    80105a49 <alltraps>

80106662 <vector193>:
.globl vector193
vector193:
  pushl $0
80106662:	6a 00                	push   $0x0
  pushl $193
80106664:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106669:	e9 db f3 ff ff       	jmp    80105a49 <alltraps>

8010666e <vector194>:
.globl vector194
vector194:
  pushl $0
8010666e:	6a 00                	push   $0x0
  pushl $194
80106670:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106675:	e9 cf f3 ff ff       	jmp    80105a49 <alltraps>

8010667a <vector195>:
.globl vector195
vector195:
  pushl $0
8010667a:	6a 00                	push   $0x0
  pushl $195
8010667c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106681:	e9 c3 f3 ff ff       	jmp    80105a49 <alltraps>

80106686 <vector196>:
.globl vector196
vector196:
  pushl $0
80106686:	6a 00                	push   $0x0
  pushl $196
80106688:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010668d:	e9 b7 f3 ff ff       	jmp    80105a49 <alltraps>

80106692 <vector197>:
.globl vector197
vector197:
  pushl $0
80106692:	6a 00                	push   $0x0
  pushl $197
80106694:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106699:	e9 ab f3 ff ff       	jmp    80105a49 <alltraps>

8010669e <vector198>:
.globl vector198
vector198:
  pushl $0
8010669e:	6a 00                	push   $0x0
  pushl $198
801066a0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801066a5:	e9 9f f3 ff ff       	jmp    80105a49 <alltraps>

801066aa <vector199>:
.globl vector199
vector199:
  pushl $0
801066aa:	6a 00                	push   $0x0
  pushl $199
801066ac:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801066b1:	e9 93 f3 ff ff       	jmp    80105a49 <alltraps>

801066b6 <vector200>:
.globl vector200
vector200:
  pushl $0
801066b6:	6a 00                	push   $0x0
  pushl $200
801066b8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801066bd:	e9 87 f3 ff ff       	jmp    80105a49 <alltraps>

801066c2 <vector201>:
.globl vector201
vector201:
  pushl $0
801066c2:	6a 00                	push   $0x0
  pushl $201
801066c4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801066c9:	e9 7b f3 ff ff       	jmp    80105a49 <alltraps>

801066ce <vector202>:
.globl vector202
vector202:
  pushl $0
801066ce:	6a 00                	push   $0x0
  pushl $202
801066d0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801066d5:	e9 6f f3 ff ff       	jmp    80105a49 <alltraps>

801066da <vector203>:
.globl vector203
vector203:
  pushl $0
801066da:	6a 00                	push   $0x0
  pushl $203
801066dc:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801066e1:	e9 63 f3 ff ff       	jmp    80105a49 <alltraps>

801066e6 <vector204>:
.globl vector204
vector204:
  pushl $0
801066e6:	6a 00                	push   $0x0
  pushl $204
801066e8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801066ed:	e9 57 f3 ff ff       	jmp    80105a49 <alltraps>

801066f2 <vector205>:
.globl vector205
vector205:
  pushl $0
801066f2:	6a 00                	push   $0x0
  pushl $205
801066f4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801066f9:	e9 4b f3 ff ff       	jmp    80105a49 <alltraps>

801066fe <vector206>:
.globl vector206
vector206:
  pushl $0
801066fe:	6a 00                	push   $0x0
  pushl $206
80106700:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106705:	e9 3f f3 ff ff       	jmp    80105a49 <alltraps>

8010670a <vector207>:
.globl vector207
vector207:
  pushl $0
8010670a:	6a 00                	push   $0x0
  pushl $207
8010670c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106711:	e9 33 f3 ff ff       	jmp    80105a49 <alltraps>

80106716 <vector208>:
.globl vector208
vector208:
  pushl $0
80106716:	6a 00                	push   $0x0
  pushl $208
80106718:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010671d:	e9 27 f3 ff ff       	jmp    80105a49 <alltraps>

80106722 <vector209>:
.globl vector209
vector209:
  pushl $0
80106722:	6a 00                	push   $0x0
  pushl $209
80106724:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106729:	e9 1b f3 ff ff       	jmp    80105a49 <alltraps>

8010672e <vector210>:
.globl vector210
vector210:
  pushl $0
8010672e:	6a 00                	push   $0x0
  pushl $210
80106730:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106735:	e9 0f f3 ff ff       	jmp    80105a49 <alltraps>

8010673a <vector211>:
.globl vector211
vector211:
  pushl $0
8010673a:	6a 00                	push   $0x0
  pushl $211
8010673c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106741:	e9 03 f3 ff ff       	jmp    80105a49 <alltraps>

80106746 <vector212>:
.globl vector212
vector212:
  pushl $0
80106746:	6a 00                	push   $0x0
  pushl $212
80106748:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010674d:	e9 f7 f2 ff ff       	jmp    80105a49 <alltraps>

80106752 <vector213>:
.globl vector213
vector213:
  pushl $0
80106752:	6a 00                	push   $0x0
  pushl $213
80106754:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106759:	e9 eb f2 ff ff       	jmp    80105a49 <alltraps>

8010675e <vector214>:
.globl vector214
vector214:
  pushl $0
8010675e:	6a 00                	push   $0x0
  pushl $214
80106760:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106765:	e9 df f2 ff ff       	jmp    80105a49 <alltraps>

8010676a <vector215>:
.globl vector215
vector215:
  pushl $0
8010676a:	6a 00                	push   $0x0
  pushl $215
8010676c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106771:	e9 d3 f2 ff ff       	jmp    80105a49 <alltraps>

80106776 <vector216>:
.globl vector216
vector216:
  pushl $0
80106776:	6a 00                	push   $0x0
  pushl $216
80106778:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010677d:	e9 c7 f2 ff ff       	jmp    80105a49 <alltraps>

80106782 <vector217>:
.globl vector217
vector217:
  pushl $0
80106782:	6a 00                	push   $0x0
  pushl $217
80106784:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106789:	e9 bb f2 ff ff       	jmp    80105a49 <alltraps>

8010678e <vector218>:
.globl vector218
vector218:
  pushl $0
8010678e:	6a 00                	push   $0x0
  pushl $218
80106790:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106795:	e9 af f2 ff ff       	jmp    80105a49 <alltraps>

8010679a <vector219>:
.globl vector219
vector219:
  pushl $0
8010679a:	6a 00                	push   $0x0
  pushl $219
8010679c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801067a1:	e9 a3 f2 ff ff       	jmp    80105a49 <alltraps>

801067a6 <vector220>:
.globl vector220
vector220:
  pushl $0
801067a6:	6a 00                	push   $0x0
  pushl $220
801067a8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801067ad:	e9 97 f2 ff ff       	jmp    80105a49 <alltraps>

801067b2 <vector221>:
.globl vector221
vector221:
  pushl $0
801067b2:	6a 00                	push   $0x0
  pushl $221
801067b4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801067b9:	e9 8b f2 ff ff       	jmp    80105a49 <alltraps>

801067be <vector222>:
.globl vector222
vector222:
  pushl $0
801067be:	6a 00                	push   $0x0
  pushl $222
801067c0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801067c5:	e9 7f f2 ff ff       	jmp    80105a49 <alltraps>

801067ca <vector223>:
.globl vector223
vector223:
  pushl $0
801067ca:	6a 00                	push   $0x0
  pushl $223
801067cc:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801067d1:	e9 73 f2 ff ff       	jmp    80105a49 <alltraps>

801067d6 <vector224>:
.globl vector224
vector224:
  pushl $0
801067d6:	6a 00                	push   $0x0
  pushl $224
801067d8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801067dd:	e9 67 f2 ff ff       	jmp    80105a49 <alltraps>

801067e2 <vector225>:
.globl vector225
vector225:
  pushl $0
801067e2:	6a 00                	push   $0x0
  pushl $225
801067e4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801067e9:	e9 5b f2 ff ff       	jmp    80105a49 <alltraps>

801067ee <vector226>:
.globl vector226
vector226:
  pushl $0
801067ee:	6a 00                	push   $0x0
  pushl $226
801067f0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801067f5:	e9 4f f2 ff ff       	jmp    80105a49 <alltraps>

801067fa <vector227>:
.globl vector227
vector227:
  pushl $0
801067fa:	6a 00                	push   $0x0
  pushl $227
801067fc:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106801:	e9 43 f2 ff ff       	jmp    80105a49 <alltraps>

80106806 <vector228>:
.globl vector228
vector228:
  pushl $0
80106806:	6a 00                	push   $0x0
  pushl $228
80106808:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010680d:	e9 37 f2 ff ff       	jmp    80105a49 <alltraps>

80106812 <vector229>:
.globl vector229
vector229:
  pushl $0
80106812:	6a 00                	push   $0x0
  pushl $229
80106814:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106819:	e9 2b f2 ff ff       	jmp    80105a49 <alltraps>

8010681e <vector230>:
.globl vector230
vector230:
  pushl $0
8010681e:	6a 00                	push   $0x0
  pushl $230
80106820:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106825:	e9 1f f2 ff ff       	jmp    80105a49 <alltraps>

8010682a <vector231>:
.globl vector231
vector231:
  pushl $0
8010682a:	6a 00                	push   $0x0
  pushl $231
8010682c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106831:	e9 13 f2 ff ff       	jmp    80105a49 <alltraps>

80106836 <vector232>:
.globl vector232
vector232:
  pushl $0
80106836:	6a 00                	push   $0x0
  pushl $232
80106838:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010683d:	e9 07 f2 ff ff       	jmp    80105a49 <alltraps>

80106842 <vector233>:
.globl vector233
vector233:
  pushl $0
80106842:	6a 00                	push   $0x0
  pushl $233
80106844:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106849:	e9 fb f1 ff ff       	jmp    80105a49 <alltraps>

8010684e <vector234>:
.globl vector234
vector234:
  pushl $0
8010684e:	6a 00                	push   $0x0
  pushl $234
80106850:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106855:	e9 ef f1 ff ff       	jmp    80105a49 <alltraps>

8010685a <vector235>:
.globl vector235
vector235:
  pushl $0
8010685a:	6a 00                	push   $0x0
  pushl $235
8010685c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106861:	e9 e3 f1 ff ff       	jmp    80105a49 <alltraps>

80106866 <vector236>:
.globl vector236
vector236:
  pushl $0
80106866:	6a 00                	push   $0x0
  pushl $236
80106868:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010686d:	e9 d7 f1 ff ff       	jmp    80105a49 <alltraps>

80106872 <vector237>:
.globl vector237
vector237:
  pushl $0
80106872:	6a 00                	push   $0x0
  pushl $237
80106874:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106879:	e9 cb f1 ff ff       	jmp    80105a49 <alltraps>

8010687e <vector238>:
.globl vector238
vector238:
  pushl $0
8010687e:	6a 00                	push   $0x0
  pushl $238
80106880:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106885:	e9 bf f1 ff ff       	jmp    80105a49 <alltraps>

8010688a <vector239>:
.globl vector239
vector239:
  pushl $0
8010688a:	6a 00                	push   $0x0
  pushl $239
8010688c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106891:	e9 b3 f1 ff ff       	jmp    80105a49 <alltraps>

80106896 <vector240>:
.globl vector240
vector240:
  pushl $0
80106896:	6a 00                	push   $0x0
  pushl $240
80106898:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010689d:	e9 a7 f1 ff ff       	jmp    80105a49 <alltraps>

801068a2 <vector241>:
.globl vector241
vector241:
  pushl $0
801068a2:	6a 00                	push   $0x0
  pushl $241
801068a4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801068a9:	e9 9b f1 ff ff       	jmp    80105a49 <alltraps>

801068ae <vector242>:
.globl vector242
vector242:
  pushl $0
801068ae:	6a 00                	push   $0x0
  pushl $242
801068b0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801068b5:	e9 8f f1 ff ff       	jmp    80105a49 <alltraps>

801068ba <vector243>:
.globl vector243
vector243:
  pushl $0
801068ba:	6a 00                	push   $0x0
  pushl $243
801068bc:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801068c1:	e9 83 f1 ff ff       	jmp    80105a49 <alltraps>

801068c6 <vector244>:
.globl vector244
vector244:
  pushl $0
801068c6:	6a 00                	push   $0x0
  pushl $244
801068c8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801068cd:	e9 77 f1 ff ff       	jmp    80105a49 <alltraps>

801068d2 <vector245>:
.globl vector245
vector245:
  pushl $0
801068d2:	6a 00                	push   $0x0
  pushl $245
801068d4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801068d9:	e9 6b f1 ff ff       	jmp    80105a49 <alltraps>

801068de <vector246>:
.globl vector246
vector246:
  pushl $0
801068de:	6a 00                	push   $0x0
  pushl $246
801068e0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801068e5:	e9 5f f1 ff ff       	jmp    80105a49 <alltraps>

801068ea <vector247>:
.globl vector247
vector247:
  pushl $0
801068ea:	6a 00                	push   $0x0
  pushl $247
801068ec:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801068f1:	e9 53 f1 ff ff       	jmp    80105a49 <alltraps>

801068f6 <vector248>:
.globl vector248
vector248:
  pushl $0
801068f6:	6a 00                	push   $0x0
  pushl $248
801068f8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801068fd:	e9 47 f1 ff ff       	jmp    80105a49 <alltraps>

80106902 <vector249>:
.globl vector249
vector249:
  pushl $0
80106902:	6a 00                	push   $0x0
  pushl $249
80106904:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106909:	e9 3b f1 ff ff       	jmp    80105a49 <alltraps>

8010690e <vector250>:
.globl vector250
vector250:
  pushl $0
8010690e:	6a 00                	push   $0x0
  pushl $250
80106910:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106915:	e9 2f f1 ff ff       	jmp    80105a49 <alltraps>

8010691a <vector251>:
.globl vector251
vector251:
  pushl $0
8010691a:	6a 00                	push   $0x0
  pushl $251
8010691c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106921:	e9 23 f1 ff ff       	jmp    80105a49 <alltraps>

80106926 <vector252>:
.globl vector252
vector252:
  pushl $0
80106926:	6a 00                	push   $0x0
  pushl $252
80106928:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010692d:	e9 17 f1 ff ff       	jmp    80105a49 <alltraps>

80106932 <vector253>:
.globl vector253
vector253:
  pushl $0
80106932:	6a 00                	push   $0x0
  pushl $253
80106934:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106939:	e9 0b f1 ff ff       	jmp    80105a49 <alltraps>

8010693e <vector254>:
.globl vector254
vector254:
  pushl $0
8010693e:	6a 00                	push   $0x0
  pushl $254
80106940:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106945:	e9 ff f0 ff ff       	jmp    80105a49 <alltraps>

8010694a <vector255>:
.globl vector255
vector255:
  pushl $0
8010694a:	6a 00                	push   $0x0
  pushl $255
8010694c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106951:	e9 f3 f0 ff ff       	jmp    80105a49 <alltraps>
80106956:	66 90                	xchg   %ax,%ax
80106958:	66 90                	xchg   %ax,%ax
8010695a:	66 90                	xchg   %ax,%ax
8010695c:	66 90                	xchg   %ax,%ax
8010695e:	66 90                	xchg   %ax,%ax

80106960 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106960:	55                   	push   %ebp
80106961:	89 e5                	mov    %esp,%ebp
80106963:	57                   	push   %edi
80106964:	56                   	push   %esi
80106965:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106967:	c1 ea 16             	shr    $0x16,%edx
{
8010696a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010696b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010696e:	83 ec 1c             	sub    $0x1c,%esp
  if(*pde & PTE_P){
80106971:	8b 1f                	mov    (%edi),%ebx
80106973:	f6 c3 01             	test   $0x1,%bl
80106976:	74 28                	je     801069a0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106978:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010697e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106984:	c1 ee 0a             	shr    $0xa,%esi
}
80106987:	83 c4 1c             	add    $0x1c,%esp
  return &pgtab[PTX(va)];
8010698a:	89 f2                	mov    %esi,%edx
8010698c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106992:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106995:	5b                   	pop    %ebx
80106996:	5e                   	pop    %esi
80106997:	5f                   	pop    %edi
80106998:	5d                   	pop    %ebp
80106999:	c3                   	ret    
8010699a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801069a0:	85 c9                	test   %ecx,%ecx
801069a2:	74 34                	je     801069d8 <walkpgdir+0x78>
801069a4:	e8 07 bb ff ff       	call   801024b0 <kalloc>
801069a9:	85 c0                	test   %eax,%eax
801069ab:	89 c3                	mov    %eax,%ebx
801069ad:	74 29                	je     801069d8 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
801069af:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801069b6:	00 
801069b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801069be:	00 
801069bf:	89 04 24             	mov    %eax,(%esp)
801069c2:	e8 e9 dd ff ff       	call   801047b0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801069c7:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801069cd:	83 c8 07             	or     $0x7,%eax
801069d0:	89 07                	mov    %eax,(%edi)
801069d2:	eb b0                	jmp    80106984 <walkpgdir+0x24>
801069d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
801069d8:	83 c4 1c             	add    $0x1c,%esp
      return 0;
801069db:	31 c0                	xor    %eax,%eax
}
801069dd:	5b                   	pop    %ebx
801069de:	5e                   	pop    %esi
801069df:	5f                   	pop    %edi
801069e0:	5d                   	pop    %ebp
801069e1:	c3                   	ret    
801069e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069f0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801069f0:	55                   	push   %ebp
801069f1:	89 e5                	mov    %esp,%ebp
801069f3:	57                   	push   %edi
801069f4:	56                   	push   %esi
801069f5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801069f6:	89 d3                	mov    %edx,%ebx
{
801069f8:	83 ec 1c             	sub    $0x1c,%esp
801069fb:	8b 7d 08             	mov    0x8(%ebp),%edi
  a = (char*)PGROUNDDOWN((uint)va);
801069fe:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106a04:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a07:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106a0b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106a0e:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a12:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
80106a19:	29 df                	sub    %ebx,%edi
80106a1b:	eb 18                	jmp    80106a35 <mappages+0x45>
80106a1d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*pte & PTE_P)
80106a20:	f6 00 01             	testb  $0x1,(%eax)
80106a23:	75 3d                	jne    80106a62 <mappages+0x72>
    *pte = pa | perm | PTE_P;
80106a25:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
80106a28:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106a2b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106a2d:	74 29                	je     80106a58 <mappages+0x68>
      break;
    a += PGSIZE;
80106a2f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106a35:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a38:	b9 01 00 00 00       	mov    $0x1,%ecx
80106a3d:	89 da                	mov    %ebx,%edx
80106a3f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106a42:	e8 19 ff ff ff       	call   80106960 <walkpgdir>
80106a47:	85 c0                	test   %eax,%eax
80106a49:	75 d5                	jne    80106a20 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106a4b:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106a4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a53:	5b                   	pop    %ebx
80106a54:	5e                   	pop    %esi
80106a55:	5f                   	pop    %edi
80106a56:	5d                   	pop    %ebp
80106a57:	c3                   	ret    
80106a58:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106a5b:	31 c0                	xor    %eax,%eax
}
80106a5d:	5b                   	pop    %ebx
80106a5e:	5e                   	pop    %esi
80106a5f:	5f                   	pop    %edi
80106a60:	5d                   	pop    %ebp
80106a61:	c3                   	ret    
      panic("remap");
80106a62:	c7 04 24 c8 7b 10 80 	movl   $0x80107bc8,(%esp)
80106a69:	e8 f2 98 ff ff       	call   80100360 <panic>
80106a6e:	66 90                	xchg   %ax,%ax

80106a70 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a70:	55                   	push   %ebp
80106a71:	89 e5                	mov    %esp,%ebp
80106a73:	57                   	push   %edi
80106a74:	89 c7                	mov    %eax,%edi
80106a76:	56                   	push   %esi
80106a77:	89 d6                	mov    %edx,%esi
80106a79:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106a7a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a80:	83 ec 1c             	sub    $0x1c,%esp
  a = PGROUNDUP(newsz);
80106a83:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106a89:	39 d3                	cmp    %edx,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a8b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106a8e:	72 3b                	jb     80106acb <deallocuvm.part.0+0x5b>
80106a90:	eb 5e                	jmp    80106af0 <deallocuvm.part.0+0x80>
80106a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106a98:	8b 10                	mov    (%eax),%edx
80106a9a:	f6 c2 01             	test   $0x1,%dl
80106a9d:	74 22                	je     80106ac1 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106a9f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106aa5:	74 54                	je     80106afb <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106aa7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106aad:	89 14 24             	mov    %edx,(%esp)
80106ab0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ab3:	e8 48 b8 ff ff       	call   80102300 <kfree>
      *pte = 0;
80106ab8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106abb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106ac1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ac7:	39 f3                	cmp    %esi,%ebx
80106ac9:	73 25                	jae    80106af0 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106acb:	31 c9                	xor    %ecx,%ecx
80106acd:	89 da                	mov    %ebx,%edx
80106acf:	89 f8                	mov    %edi,%eax
80106ad1:	e8 8a fe ff ff       	call   80106960 <walkpgdir>
    if(!pte)
80106ad6:	85 c0                	test   %eax,%eax
80106ad8:	75 be                	jne    80106a98 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106ada:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106ae0:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106ae6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106aec:	39 f3                	cmp    %esi,%ebx
80106aee:	72 db                	jb     80106acb <deallocuvm.part.0+0x5b>
    }
  }
  return newsz;
}
80106af0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106af3:	83 c4 1c             	add    $0x1c,%esp
80106af6:	5b                   	pop    %ebx
80106af7:	5e                   	pop    %esi
80106af8:	5f                   	pop    %edi
80106af9:	5d                   	pop    %ebp
80106afa:	c3                   	ret    
        panic("kfree");
80106afb:	c7 04 24 e6 74 10 80 	movl   $0x801074e6,(%esp)
80106b02:	e8 59 98 ff ff       	call   80100360 <panic>
80106b07:	89 f6                	mov    %esi,%esi
80106b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b10 <seginit>:
{
80106b10:	55                   	push   %ebp
80106b11:	89 e5                	mov    %esp,%ebp
80106b13:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106b16:	e8 a5 cb ff ff       	call   801036c0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b1b:	31 c9                	xor    %ecx,%ecx
80106b1d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c = &cpus[cpuid()];
80106b22:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106b28:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b2d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b31:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  lgdt(c->gdt, sizeof(c->gdt));
80106b36:	83 c0 70             	add    $0x70,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b39:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b3d:	31 c9                	xor    %ecx,%ecx
80106b3f:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b43:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b48:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b4c:	31 c9                	xor    %ecx,%ecx
80106b4e:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b52:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b57:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b5b:	31 c9                	xor    %ecx,%ecx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b5d:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106b61:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b65:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106b69:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b6d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106b71:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b75:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106b79:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
80106b7d:	66 89 50 20          	mov    %dx,0x20(%eax)
  pd[0] = size-1;
80106b81:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b86:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
80106b8a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b8e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106b92:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b96:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
80106b9a:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b9e:	66 89 48 22          	mov    %cx,0x22(%eax)
80106ba2:	c6 40 24 00          	movb   $0x0,0x24(%eax)
80106ba6:	c6 40 27 00          	movb   $0x0,0x27(%eax)
80106baa:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106bae:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106bb2:	c1 e8 10             	shr    $0x10,%eax
80106bb5:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106bb9:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106bbc:	0f 01 10             	lgdtl  (%eax)
}
80106bbf:	c9                   	leave  
80106bc0:	c3                   	ret    
80106bc1:	eb 0d                	jmp    80106bd0 <switchkvm>
80106bc3:	90                   	nop
80106bc4:	90                   	nop
80106bc5:	90                   	nop
80106bc6:	90                   	nop
80106bc7:	90                   	nop
80106bc8:	90                   	nop
80106bc9:	90                   	nop
80106bca:	90                   	nop
80106bcb:	90                   	nop
80106bcc:	90                   	nop
80106bcd:	90                   	nop
80106bce:	90                   	nop
80106bcf:	90                   	nop

80106bd0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106bd0:	a1 a4 59 11 80       	mov    0x801159a4,%eax
{
80106bd5:	55                   	push   %ebp
80106bd6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106bd8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106bdd:	0f 22 d8             	mov    %eax,%cr3
}
80106be0:	5d                   	pop    %ebp
80106be1:	c3                   	ret    
80106be2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106bf0 <switchuvm>:
{
80106bf0:	55                   	push   %ebp
80106bf1:	89 e5                	mov    %esp,%ebp
80106bf3:	57                   	push   %edi
80106bf4:	56                   	push   %esi
80106bf5:	53                   	push   %ebx
80106bf6:	83 ec 1c             	sub    $0x1c,%esp
80106bf9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106bfc:	85 f6                	test   %esi,%esi
80106bfe:	0f 84 cd 00 00 00    	je     80106cd1 <switchuvm+0xe1>
  if(p->kstack == 0)
80106c04:	8b 46 0c             	mov    0xc(%esi),%eax
80106c07:	85 c0                	test   %eax,%eax
80106c09:	0f 84 da 00 00 00    	je     80106ce9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106c0f:	8b 7e 08             	mov    0x8(%esi),%edi
80106c12:	85 ff                	test   %edi,%edi
80106c14:	0f 84 c3 00 00 00    	je     80106cdd <switchuvm+0xed>
  pushcli();
80106c1a:	e8 e1 d9 ff ff       	call   80104600 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c1f:	e8 1c ca ff ff       	call   80103640 <mycpu>
80106c24:	89 c3                	mov    %eax,%ebx
80106c26:	e8 15 ca ff ff       	call   80103640 <mycpu>
80106c2b:	89 c7                	mov    %eax,%edi
80106c2d:	e8 0e ca ff ff       	call   80103640 <mycpu>
80106c32:	83 c7 08             	add    $0x8,%edi
80106c35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c38:	e8 03 ca ff ff       	call   80103640 <mycpu>
80106c3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c40:	ba 67 00 00 00       	mov    $0x67,%edx
80106c45:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106c4c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106c53:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106c5a:	83 c1 08             	add    $0x8,%ecx
80106c5d:	c1 e9 10             	shr    $0x10,%ecx
80106c60:	83 c0 08             	add    $0x8,%eax
80106c63:	c1 e8 18             	shr    $0x18,%eax
80106c66:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106c6c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106c73:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106c79:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106c7e:	e8 bd c9 ff ff       	call   80103640 <mycpu>
80106c83:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106c8a:	e8 b1 c9 ff ff       	call   80103640 <mycpu>
80106c8f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106c94:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106c98:	e8 a3 c9 ff ff       	call   80103640 <mycpu>
80106c9d:	8b 56 0c             	mov    0xc(%esi),%edx
80106ca0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106ca6:	89 48 0c             	mov    %ecx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106ca9:	e8 92 c9 ff ff       	call   80103640 <mycpu>
80106cae:	66 89 58 6e          	mov    %bx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106cb2:	b8 28 00 00 00       	mov    $0x28,%eax
80106cb7:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106cba:	8b 46 08             	mov    0x8(%esi),%eax
80106cbd:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106cc2:	0f 22 d8             	mov    %eax,%cr3
}
80106cc5:	83 c4 1c             	add    $0x1c,%esp
80106cc8:	5b                   	pop    %ebx
80106cc9:	5e                   	pop    %esi
80106cca:	5f                   	pop    %edi
80106ccb:	5d                   	pop    %ebp
  popcli();
80106ccc:	e9 6f d9 ff ff       	jmp    80104640 <popcli>
    panic("switchuvm: no process");
80106cd1:	c7 04 24 ce 7b 10 80 	movl   $0x80107bce,(%esp)
80106cd8:	e8 83 96 ff ff       	call   80100360 <panic>
    panic("switchuvm: no pgdir");
80106cdd:	c7 04 24 f9 7b 10 80 	movl   $0x80107bf9,(%esp)
80106ce4:	e8 77 96 ff ff       	call   80100360 <panic>
    panic("switchuvm: no kstack");
80106ce9:	c7 04 24 e4 7b 10 80 	movl   $0x80107be4,(%esp)
80106cf0:	e8 6b 96 ff ff       	call   80100360 <panic>
80106cf5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d00 <inituvm>:
{
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
80106d03:	57                   	push   %edi
80106d04:	56                   	push   %esi
80106d05:	53                   	push   %ebx
80106d06:	83 ec 1c             	sub    $0x1c,%esp
80106d09:	8b 75 10             	mov    0x10(%ebp),%esi
80106d0c:	8b 45 08             	mov    0x8(%ebp),%eax
80106d0f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106d12:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106d18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106d1b:	77 54                	ja     80106d71 <inituvm+0x71>
  mem = kalloc();
80106d1d:	e8 8e b7 ff ff       	call   801024b0 <kalloc>
  memset(mem, 0, PGSIZE);
80106d22:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106d29:	00 
80106d2a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106d31:	00 
  mem = kalloc();
80106d32:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106d34:	89 04 24             	mov    %eax,(%esp)
80106d37:	e8 74 da ff ff       	call   801047b0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106d3c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d42:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d47:	89 04 24             	mov    %eax,(%esp)
80106d4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d4d:	31 d2                	xor    %edx,%edx
80106d4f:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106d56:	00 
80106d57:	e8 94 fc ff ff       	call   801069f0 <mappages>
  memmove(mem, init, sz);
80106d5c:	89 75 10             	mov    %esi,0x10(%ebp)
80106d5f:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106d62:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106d65:	83 c4 1c             	add    $0x1c,%esp
80106d68:	5b                   	pop    %ebx
80106d69:	5e                   	pop    %esi
80106d6a:	5f                   	pop    %edi
80106d6b:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106d6c:	e9 df da ff ff       	jmp    80104850 <memmove>
    panic("inituvm: more than a page");
80106d71:	c7 04 24 0d 7c 10 80 	movl   $0x80107c0d,(%esp)
80106d78:	e8 e3 95 ff ff       	call   80100360 <panic>
80106d7d:	8d 76 00             	lea    0x0(%esi),%esi

80106d80 <loaduvm>:
{
80106d80:	55                   	push   %ebp
80106d81:	89 e5                	mov    %esp,%ebp
80106d83:	57                   	push   %edi
80106d84:	56                   	push   %esi
80106d85:	53                   	push   %ebx
80106d86:	83 ec 1c             	sub    $0x1c,%esp
  if((uint) addr % PGSIZE != 0)
80106d89:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106d90:	0f 85 98 00 00 00    	jne    80106e2e <loaduvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
80106d96:	8b 75 18             	mov    0x18(%ebp),%esi
80106d99:	31 db                	xor    %ebx,%ebx
80106d9b:	85 f6                	test   %esi,%esi
80106d9d:	75 1a                	jne    80106db9 <loaduvm+0x39>
80106d9f:	eb 77                	jmp    80106e18 <loaduvm+0x98>
80106da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106da8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106dae:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106db4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106db7:	76 5f                	jbe    80106e18 <loaduvm+0x98>
80106db9:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106dbc:	31 c9                	xor    %ecx,%ecx
80106dbe:	8b 45 08             	mov    0x8(%ebp),%eax
80106dc1:	01 da                	add    %ebx,%edx
80106dc3:	e8 98 fb ff ff       	call   80106960 <walkpgdir>
80106dc8:	85 c0                	test   %eax,%eax
80106dca:	74 56                	je     80106e22 <loaduvm+0xa2>
    pa = PTE_ADDR(*pte);
80106dcc:	8b 00                	mov    (%eax),%eax
      n = PGSIZE;
80106dce:	bf 00 10 00 00       	mov    $0x1000,%edi
80106dd3:	8b 4d 14             	mov    0x14(%ebp),%ecx
    pa = PTE_ADDR(*pte);
80106dd6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = PGSIZE;
80106ddb:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106de1:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106de4:	05 00 00 00 80       	add    $0x80000000,%eax
80106de9:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ded:	8b 45 10             	mov    0x10(%ebp),%eax
80106df0:	01 d9                	add    %ebx,%ecx
80106df2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106df6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106dfa:	89 04 24             	mov    %eax,(%esp)
80106dfd:	e8 6e ab ff ff       	call   80101970 <readi>
80106e02:	39 f8                	cmp    %edi,%eax
80106e04:	74 a2                	je     80106da8 <loaduvm+0x28>
}
80106e06:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106e09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e0e:	5b                   	pop    %ebx
80106e0f:	5e                   	pop    %esi
80106e10:	5f                   	pop    %edi
80106e11:	5d                   	pop    %ebp
80106e12:	c3                   	ret    
80106e13:	90                   	nop
80106e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e18:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106e1b:	31 c0                	xor    %eax,%eax
}
80106e1d:	5b                   	pop    %ebx
80106e1e:	5e                   	pop    %esi
80106e1f:	5f                   	pop    %edi
80106e20:	5d                   	pop    %ebp
80106e21:	c3                   	ret    
      panic("loaduvm: address should exist");
80106e22:	c7 04 24 27 7c 10 80 	movl   $0x80107c27,(%esp)
80106e29:	e8 32 95 ff ff       	call   80100360 <panic>
    panic("loaduvm: addr must be page aligned");
80106e2e:	c7 04 24 c8 7c 10 80 	movl   $0x80107cc8,(%esp)
80106e35:	e8 26 95 ff ff       	call   80100360 <panic>
80106e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e40 <allocuvm>:
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	57                   	push   %edi
80106e44:	56                   	push   %esi
80106e45:	53                   	push   %ebx
80106e46:	83 ec 1c             	sub    $0x1c,%esp
80106e49:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
80106e4c:	85 ff                	test   %edi,%edi
80106e4e:	0f 88 7e 00 00 00    	js     80106ed2 <allocuvm+0x92>
  if(newsz < oldsz)
80106e54:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106e5a:	72 78                	jb     80106ed4 <allocuvm+0x94>
  a = PGROUNDUP(oldsz);
80106e5c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106e62:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106e68:	39 df                	cmp    %ebx,%edi
80106e6a:	77 4a                	ja     80106eb6 <allocuvm+0x76>
80106e6c:	eb 72                	jmp    80106ee0 <allocuvm+0xa0>
80106e6e:	66 90                	xchg   %ax,%ax
    memset(mem, 0, PGSIZE);
80106e70:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106e77:	00 
80106e78:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106e7f:	00 
80106e80:	89 04 24             	mov    %eax,(%esp)
80106e83:	e8 28 d9 ff ff       	call   801047b0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106e88:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106e8e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e93:	89 04 24             	mov    %eax,(%esp)
80106e96:	8b 45 08             	mov    0x8(%ebp),%eax
80106e99:	89 da                	mov    %ebx,%edx
80106e9b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106ea2:	00 
80106ea3:	e8 48 fb ff ff       	call   801069f0 <mappages>
80106ea8:	85 c0                	test   %eax,%eax
80106eaa:	78 44                	js     80106ef0 <allocuvm+0xb0>
  for(; a < newsz; a += PGSIZE){
80106eac:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106eb2:	39 df                	cmp    %ebx,%edi
80106eb4:	76 2a                	jbe    80106ee0 <allocuvm+0xa0>
    mem = kalloc();
80106eb6:	e8 f5 b5 ff ff       	call   801024b0 <kalloc>
    if(mem == 0){
80106ebb:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106ebd:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106ebf:	75 af                	jne    80106e70 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106ec1:	c7 04 24 45 7c 10 80 	movl   $0x80107c45,(%esp)
80106ec8:	e8 83 97 ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
80106ecd:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106ed0:	77 48                	ja     80106f1a <allocuvm+0xda>
      return 0;
80106ed2:	31 c0                	xor    %eax,%eax
}
80106ed4:	83 c4 1c             	add    $0x1c,%esp
80106ed7:	5b                   	pop    %ebx
80106ed8:	5e                   	pop    %esi
80106ed9:	5f                   	pop    %edi
80106eda:	5d                   	pop    %ebp
80106edb:	c3                   	ret    
80106edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ee0:	83 c4 1c             	add    $0x1c,%esp
80106ee3:	89 f8                	mov    %edi,%eax
80106ee5:	5b                   	pop    %ebx
80106ee6:	5e                   	pop    %esi
80106ee7:	5f                   	pop    %edi
80106ee8:	5d                   	pop    %ebp
80106ee9:	c3                   	ret    
80106eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106ef0:	c7 04 24 5d 7c 10 80 	movl   $0x80107c5d,(%esp)
80106ef7:	e8 54 97 ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
80106efc:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106eff:	76 0d                	jbe    80106f0e <allocuvm+0xce>
80106f01:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f04:	89 fa                	mov    %edi,%edx
80106f06:	8b 45 08             	mov    0x8(%ebp),%eax
80106f09:	e8 62 fb ff ff       	call   80106a70 <deallocuvm.part.0>
      kfree(mem);
80106f0e:	89 34 24             	mov    %esi,(%esp)
80106f11:	e8 ea b3 ff ff       	call   80102300 <kfree>
      return 0;
80106f16:	31 c0                	xor    %eax,%eax
80106f18:	eb ba                	jmp    80106ed4 <allocuvm+0x94>
80106f1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f1d:	89 fa                	mov    %edi,%edx
80106f1f:	8b 45 08             	mov    0x8(%ebp),%eax
80106f22:	e8 49 fb ff ff       	call   80106a70 <deallocuvm.part.0>
      return 0;
80106f27:	31 c0                	xor    %eax,%eax
80106f29:	eb a9                	jmp    80106ed4 <allocuvm+0x94>
80106f2b:	90                   	nop
80106f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f30 <deallocuvm>:
{
80106f30:	55                   	push   %ebp
80106f31:	89 e5                	mov    %esp,%ebp
80106f33:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f36:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106f39:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106f3c:	39 d1                	cmp    %edx,%ecx
80106f3e:	73 08                	jae    80106f48 <deallocuvm+0x18>
}
80106f40:	5d                   	pop    %ebp
80106f41:	e9 2a fb ff ff       	jmp    80106a70 <deallocuvm.part.0>
80106f46:	66 90                	xchg   %ax,%ax
80106f48:	89 d0                	mov    %edx,%eax
80106f4a:	5d                   	pop    %ebp
80106f4b:	c3                   	ret    
80106f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f50 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	56                   	push   %esi
80106f54:	53                   	push   %ebx
80106f55:	83 ec 10             	sub    $0x10,%esp
80106f58:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106f5b:	85 f6                	test   %esi,%esi
80106f5d:	74 59                	je     80106fb8 <freevm+0x68>
80106f5f:	31 c9                	xor    %ecx,%ecx
80106f61:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106f66:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106f68:	31 db                	xor    %ebx,%ebx
80106f6a:	e8 01 fb ff ff       	call   80106a70 <deallocuvm.part.0>
80106f6f:	eb 12                	jmp    80106f83 <freevm+0x33>
80106f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f78:	83 c3 01             	add    $0x1,%ebx
80106f7b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106f81:	74 27                	je     80106faa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106f83:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106f86:	f6 c2 01             	test   $0x1,%dl
80106f89:	74 ed                	je     80106f78 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f8b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(i = 0; i < NPDENTRIES; i++){
80106f91:	83 c3 01             	add    $0x1,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106f94:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106f9a:	89 14 24             	mov    %edx,(%esp)
80106f9d:	e8 5e b3 ff ff       	call   80102300 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80106fa2:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106fa8:	75 d9                	jne    80106f83 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
80106faa:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106fad:	83 c4 10             	add    $0x10,%esp
80106fb0:	5b                   	pop    %ebx
80106fb1:	5e                   	pop    %esi
80106fb2:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106fb3:	e9 48 b3 ff ff       	jmp    80102300 <kfree>
    panic("freevm: no pgdir");
80106fb8:	c7 04 24 79 7c 10 80 	movl   $0x80107c79,(%esp)
80106fbf:	e8 9c 93 ff ff       	call   80100360 <panic>
80106fc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106fd0 <setupkvm>:
{
80106fd0:	55                   	push   %ebp
80106fd1:	89 e5                	mov    %esp,%ebp
80106fd3:	56                   	push   %esi
80106fd4:	53                   	push   %ebx
80106fd5:	83 ec 10             	sub    $0x10,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
80106fd8:	e8 d3 b4 ff ff       	call   801024b0 <kalloc>
80106fdd:	85 c0                	test   %eax,%eax
80106fdf:	89 c6                	mov    %eax,%esi
80106fe1:	74 6d                	je     80107050 <setupkvm+0x80>
  memset(pgdir, 0, PGSIZE);
80106fe3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106fea:	00 
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106feb:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106ff0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106ff7:	00 
80106ff8:	89 04 24             	mov    %eax,(%esp)
80106ffb:	e8 b0 d7 ff ff       	call   801047b0 <memset>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107000:	8b 53 0c             	mov    0xc(%ebx),%edx
80107003:	8b 43 04             	mov    0x4(%ebx),%eax
80107006:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107009:	89 54 24 04          	mov    %edx,0x4(%esp)
8010700d:	8b 13                	mov    (%ebx),%edx
8010700f:	89 04 24             	mov    %eax,(%esp)
80107012:	29 c1                	sub    %eax,%ecx
80107014:	89 f0                	mov    %esi,%eax
80107016:	e8 d5 f9 ff ff       	call   801069f0 <mappages>
8010701b:	85 c0                	test   %eax,%eax
8010701d:	78 19                	js     80107038 <setupkvm+0x68>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010701f:	83 c3 10             	add    $0x10,%ebx
80107022:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107028:	72 d6                	jb     80107000 <setupkvm+0x30>
8010702a:	89 f0                	mov    %esi,%eax
}
8010702c:	83 c4 10             	add    $0x10,%esp
8010702f:	5b                   	pop    %ebx
80107030:	5e                   	pop    %esi
80107031:	5d                   	pop    %ebp
80107032:	c3                   	ret    
80107033:	90                   	nop
80107034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107038:	89 34 24             	mov    %esi,(%esp)
8010703b:	e8 10 ff ff ff       	call   80106f50 <freevm>
}
80107040:	83 c4 10             	add    $0x10,%esp
      return 0;
80107043:	31 c0                	xor    %eax,%eax
}
80107045:	5b                   	pop    %ebx
80107046:	5e                   	pop    %esi
80107047:	5d                   	pop    %ebp
80107048:	c3                   	ret    
80107049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80107050:	31 c0                	xor    %eax,%eax
80107052:	eb d8                	jmp    8010702c <setupkvm+0x5c>
80107054:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010705a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107060 <kvmalloc>:
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107066:	e8 65 ff ff ff       	call   80106fd0 <setupkvm>
8010706b:	a3 a4 59 11 80       	mov    %eax,0x801159a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107070:	05 00 00 00 80       	add    $0x80000000,%eax
80107075:	0f 22 d8             	mov    %eax,%cr3
}
80107078:	c9                   	leave  
80107079:	c3                   	ret    
8010707a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107080 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107080:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107081:	31 c9                	xor    %ecx,%ecx
{
80107083:	89 e5                	mov    %esp,%ebp
80107085:	83 ec 18             	sub    $0x18,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107088:	8b 55 0c             	mov    0xc(%ebp),%edx
8010708b:	8b 45 08             	mov    0x8(%ebp),%eax
8010708e:	e8 cd f8 ff ff       	call   80106960 <walkpgdir>
  if(pte == 0)
80107093:	85 c0                	test   %eax,%eax
80107095:	74 05                	je     8010709c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107097:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010709a:	c9                   	leave  
8010709b:	c3                   	ret    
    panic("clearpteu");
8010709c:	c7 04 24 8a 7c 10 80 	movl   $0x80107c8a,(%esp)
801070a3:	e8 b8 92 ff ff       	call   80100360 <panic>
801070a8:	90                   	nop
801070a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070b0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801070b0:	55                   	push   %ebp
801070b1:	89 e5                	mov    %esp,%ebp
801070b3:	57                   	push   %edi
801070b4:	56                   	push   %esi
801070b5:	53                   	push   %ebx
801070b6:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801070b9:	e8 12 ff ff ff       	call   80106fd0 <setupkvm>
801070be:	85 c0                	test   %eax,%eax
801070c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801070c3:	0f 84 b9 00 00 00    	je     80107182 <copyuvm+0xd2>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801070c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801070cc:	85 c0                	test   %eax,%eax
801070ce:	0f 84 94 00 00 00    	je     80107168 <copyuvm+0xb8>
801070d4:	31 ff                	xor    %edi,%edi
801070d6:	eb 48                	jmp    80107120 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801070d8:	81 c6 00 00 00 80    	add    $0x80000000,%esi
801070de:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801070e5:	00 
801070e6:	89 74 24 04          	mov    %esi,0x4(%esp)
801070ea:	89 04 24             	mov    %eax,(%esp)
801070ed:	e8 5e d7 ff ff       	call   80104850 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801070f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070f5:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070fa:	89 fa                	mov    %edi,%edx
801070fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80107100:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107106:	89 04 24             	mov    %eax,(%esp)
80107109:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010710c:	e8 df f8 ff ff       	call   801069f0 <mappages>
80107111:	85 c0                	test   %eax,%eax
80107113:	78 63                	js     80107178 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107115:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010711b:	39 7d 0c             	cmp    %edi,0xc(%ebp)
8010711e:	76 48                	jbe    80107168 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107120:	8b 45 08             	mov    0x8(%ebp),%eax
80107123:	31 c9                	xor    %ecx,%ecx
80107125:	89 fa                	mov    %edi,%edx
80107127:	e8 34 f8 ff ff       	call   80106960 <walkpgdir>
8010712c:	85 c0                	test   %eax,%eax
8010712e:	74 62                	je     80107192 <copyuvm+0xe2>
    if(!(*pte & PTE_P))
80107130:	8b 00                	mov    (%eax),%eax
80107132:	a8 01                	test   $0x1,%al
80107134:	74 50                	je     80107186 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107136:	89 c6                	mov    %eax,%esi
    flags = PTE_FLAGS(*pte);
80107138:	25 ff 0f 00 00       	and    $0xfff,%eax
8010713d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107140:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    if((mem = kalloc()) == 0)
80107146:	e8 65 b3 ff ff       	call   801024b0 <kalloc>
8010714b:	85 c0                	test   %eax,%eax
8010714d:	89 c3                	mov    %eax,%ebx
8010714f:	75 87                	jne    801070d8 <copyuvm+0x28>
    }
  }
  return d;

bad:
  freevm(d);
80107151:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107154:	89 04 24             	mov    %eax,(%esp)
80107157:	e8 f4 fd ff ff       	call   80106f50 <freevm>
  return 0;
8010715c:	31 c0                	xor    %eax,%eax
}
8010715e:	83 c4 2c             	add    $0x2c,%esp
80107161:	5b                   	pop    %ebx
80107162:	5e                   	pop    %esi
80107163:	5f                   	pop    %edi
80107164:	5d                   	pop    %ebp
80107165:	c3                   	ret    
80107166:	66 90                	xchg   %ax,%ax
80107168:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010716b:	83 c4 2c             	add    $0x2c,%esp
8010716e:	5b                   	pop    %ebx
8010716f:	5e                   	pop    %esi
80107170:	5f                   	pop    %edi
80107171:	5d                   	pop    %ebp
80107172:	c3                   	ret    
80107173:	90                   	nop
80107174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107178:	89 1c 24             	mov    %ebx,(%esp)
8010717b:	e8 80 b1 ff ff       	call   80102300 <kfree>
      goto bad;
80107180:	eb cf                	jmp    80107151 <copyuvm+0xa1>
    return 0;
80107182:	31 c0                	xor    %eax,%eax
80107184:	eb d8                	jmp    8010715e <copyuvm+0xae>
      panic("copyuvm: page not present");
80107186:	c7 04 24 ae 7c 10 80 	movl   $0x80107cae,(%esp)
8010718d:	e8 ce 91 ff ff       	call   80100360 <panic>
      panic("copyuvm: pte should exist");
80107192:	c7 04 24 94 7c 10 80 	movl   $0x80107c94,(%esp)
80107199:	e8 c2 91 ff ff       	call   80100360 <panic>
8010719e:	66 90                	xchg   %ax,%ax

801071a0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801071a0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801071a1:	31 c9                	xor    %ecx,%ecx
{
801071a3:	89 e5                	mov    %esp,%ebp
801071a5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801071a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801071ab:	8b 45 08             	mov    0x8(%ebp),%eax
801071ae:	e8 ad f7 ff ff       	call   80106960 <walkpgdir>
  if((*pte & PTE_P) == 0)
801071b3:	8b 00                	mov    (%eax),%eax
801071b5:	89 c2                	mov    %eax,%edx
801071b7:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
801071ba:	83 fa 05             	cmp    $0x5,%edx
801071bd:	75 11                	jne    801071d0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801071bf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801071c4:	05 00 00 00 80       	add    $0x80000000,%eax
}
801071c9:	c9                   	leave  
801071ca:	c3                   	ret    
801071cb:	90                   	nop
801071cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801071d0:	31 c0                	xor    %eax,%eax
}
801071d2:	c9                   	leave  
801071d3:	c3                   	ret    
801071d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801071e0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801071e0:	55                   	push   %ebp
801071e1:	89 e5                	mov    %esp,%ebp
801071e3:	57                   	push   %edi
801071e4:	56                   	push   %esi
801071e5:	53                   	push   %ebx
801071e6:	83 ec 1c             	sub    $0x1c,%esp
801071e9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801071ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801071ef:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801071f2:	85 db                	test   %ebx,%ebx
801071f4:	75 3a                	jne    80107230 <copyout+0x50>
801071f6:	eb 68                	jmp    80107260 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801071f8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801071fb:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801071fd:	89 7c 24 04          	mov    %edi,0x4(%esp)
    n = PGSIZE - (va - va0);
80107201:	29 ca                	sub    %ecx,%edx
80107203:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107209:	39 da                	cmp    %ebx,%edx
8010720b:	0f 47 d3             	cmova  %ebx,%edx
    memmove(pa0 + (va - va0), buf, n);
8010720e:	29 f1                	sub    %esi,%ecx
80107210:	01 c8                	add    %ecx,%eax
80107212:	89 54 24 08          	mov    %edx,0x8(%esp)
80107216:	89 04 24             	mov    %eax,(%esp)
80107219:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010721c:	e8 2f d6 ff ff       	call   80104850 <memmove>
    len -= n;
    buf += n;
80107221:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80107224:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    buf += n;
8010722a:	01 d7                	add    %edx,%edi
  while(len > 0){
8010722c:	29 d3                	sub    %edx,%ebx
8010722e:	74 30                	je     80107260 <copyout+0x80>
    pa0 = uva2ka(pgdir, (char*)va0);
80107230:	8b 45 08             	mov    0x8(%ebp),%eax
    va0 = (uint)PGROUNDDOWN(va);
80107233:	89 ce                	mov    %ecx,%esi
80107235:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
8010723b:	89 74 24 04          	mov    %esi,0x4(%esp)
    va0 = (uint)PGROUNDDOWN(va);
8010723f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107242:	89 04 24             	mov    %eax,(%esp)
80107245:	e8 56 ff ff ff       	call   801071a0 <uva2ka>
    if(pa0 == 0)
8010724a:	85 c0                	test   %eax,%eax
8010724c:	75 aa                	jne    801071f8 <copyout+0x18>
  }
  return 0;
}
8010724e:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80107251:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107256:	5b                   	pop    %ebx
80107257:	5e                   	pop    %esi
80107258:	5f                   	pop    %edi
80107259:	5d                   	pop    %ebp
8010725a:	c3                   	ret    
8010725b:	90                   	nop
8010725c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107260:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80107263:	31 c0                	xor    %eax,%eax
}
80107265:	5b                   	pop    %ebx
80107266:	5e                   	pop    %esi
80107267:	5f                   	pop    %edi
80107268:	5d                   	pop    %ebp
80107269:	c3                   	ret    
