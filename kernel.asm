
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
8010004c:	c7 44 24 04 a0 72 10 	movl   $0x801072a0,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 40 45 00 00       	call   801045a0 <initlock>
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
80100094:	c7 44 24 04 a7 72 10 	movl   $0x801072a7,0x4(%esp)
8010009b:	80 
8010009c:	e8 cf 43 00 00       	call   80104470 <initsleeplock>
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
801000e6:	e8 25 46 00 00       	call   80104710 <acquire>
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
80100161:	e8 1a 46 00 00       	call   80104780 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 3f 43 00 00       	call   801044b0 <acquiresleep>
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
80100188:	c7 04 24 ae 72 10 80 	movl   $0x801072ae,(%esp)
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
801001b0:	e8 9b 43 00 00       	call   80104550 <holdingsleep>
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
801001c9:	c7 04 24 bf 72 10 80 	movl   $0x801072bf,(%esp)
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
801001f1:	e8 5a 43 00 00       	call   80104550 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 0e 43 00 00       	call   80104510 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 02 45 00 00       	call   80104710 <acquire>
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
80100250:	e9 2b 45 00 00       	jmp    80104780 <release>
    panic("brelse");
80100255:	c7 04 24 c6 72 10 80 	movl   $0x801072c6,(%esp)
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
8010028e:	e8 7d 44 00 00       	call   80104710 <acquire>
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
801002c3:	e8 58 3c 00 00       	call   80103f20 <sleep>
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
80100311:	e8 6a 44 00 00       	call   80104780 <release>
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
8010032f:	e8 4c 44 00 00       	call   80104780 <release>
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
8010037e:	c7 04 24 cd 72 10 80 	movl   $0x801072cd,(%esp)
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
801003af:	e8 0c 42 00 00       	call   801045c0 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 e1 72 10 80 	movl   $0x801072e1,(%esp)
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
80100409:	e8 f2 59 00 00       	call   80105e00 <uartputc>
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
801004b9:	e8 42 59 00 00       	call   80105e00 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 36 59 00 00       	call   80105e00 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 2a 59 00 00       	call   80105e00 <uartputc>
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
801004fc:	e8 6f 43 00 00       	call   80104870 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 b2 42 00 00       	call   801047d0 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    panic("pos under/overflow");
8010052a:	c7 04 24 e5 72 10 80 	movl   $0x801072e5,(%esp)
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
80100599:	0f b6 92 10 73 10 80 	movzbl -0x7fef8cf0(%edx),%edx
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
8010060e:	e8 fd 40 00 00       	call   80104710 <acquire>
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
80100636:	e8 45 41 00 00       	call   80104780 <release>
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
801006f3:	e8 88 40 00 00       	call   80104780 <release>
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
80100760:	b8 f8 72 10 80       	mov    $0x801072f8,%eax
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
80100797:	e8 74 3f 00 00       	call   80104710 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>
    panic("null fmt");
801007a1:	c7 04 24 ff 72 10 80 	movl   $0x801072ff,(%esp)
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
801007c5:	e8 46 3f 00 00       	call   80104710 <acquire>
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
80100827:	e8 54 3f 00 00       	call   80104780 <release>
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
801008b2:	e8 f9 39 00 00       	call   801042b0 <wakeup>
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
80100927:	e9 74 3a 00 00       	jmp    801043a0 <procdump>
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
80100956:	c7 44 24 04 08 73 10 	movl   $0x80107308,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 36 3c 00 00       	call   801045a0 <initlock>

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
80100a2c:	e8 bf 65 00 00       	call   80106ff0 <setupkvm>
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
80100ad2:	e8 89 63 00 00       	call   80106e60 <allocuvm>
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
80100b13:	e8 88 62 00 00       	call   80106da0 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 42 64 00 00       	call   80106f70 <freevm>
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
80100b6c:	e8 ef 62 00 00       	call   80106e60 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100b79:	75 33                	jne    80100bae <exec+0x20e>
    freevm(pgdir);
80100b7b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 e7 63 00 00       	call   80106f70 <freevm>
  return -1;
80100b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8e:	e9 7f fe ff ff       	jmp    80100a12 <exec+0x72>
    end_op();
80100b93:	e8 f8 1f 00 00       	call   80102b90 <end_op>
    cprintf("exec: fail\n");
80100b98:	c7 04 24 21 73 10 80 	movl   $0x80107321,(%esp)
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
80100bc8:	e8 d3 64 00 00       	call   801070a0 <clearpteu>
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
80100c01:	e8 ea 3d 00 00       	call   801049f0 <strlen>
80100c06:	f7 d0                	not    %eax
80100c08:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0a:	8b 06                	mov    (%esi),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c0c:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0f:	89 04 24             	mov    %eax,(%esp)
80100c12:	e8 d9 3d 00 00       	call   801049f0 <strlen>
80100c17:	83 c0 01             	add    $0x1,%eax
80100c1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c1e:	8b 06                	mov    (%esi),%eax
80100c20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c24:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c28:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c2e:	89 04 24             	mov    %eax,(%esp)
80100c31:	e8 ca 65 00 00       	call   80107200 <copyout>
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
80100ca4:	e8 57 65 00 00       	call   80107200 <copyout>
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
80100cf1:	e8 ba 3c 00 00       	call   801049b0 <safestrcpy>
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
80100d2b:	e8 e0 5e 00 00       	call   80106c10 <switchuvm>
  freevm(oldpgdir);
80100d30:	89 34 24             	mov    %esi,(%esp)
80100d33:	e8 38 62 00 00       	call   80106f70 <freevm>
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
80100d66:	c7 44 24 04 2d 73 10 	movl   $0x8010732d,0x4(%esp)
80100d6d:	80 
80100d6e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d75:	e8 26 38 00 00       	call   801045a0 <initlock>
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
80100d93:	e8 78 39 00 00       	call   80104710 <acquire>
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
80100dc0:	e8 bb 39 00 00       	call   80104780 <release>
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
80100dd7:	e8 a4 39 00 00       	call   80104780 <release>
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
80100e01:	e8 0a 39 00 00       	call   80104710 <acquire>
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
80100e1a:	e8 61 39 00 00       	call   80104780 <release>
  return f;
}
80100e1f:	83 c4 14             	add    $0x14,%esp
80100e22:	89 d8                	mov    %ebx,%eax
80100e24:	5b                   	pop    %ebx
80100e25:	5d                   	pop    %ebp
80100e26:	c3                   	ret    
    panic("filedup");
80100e27:	c7 04 24 34 73 10 80 	movl   $0x80107334,(%esp)
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
80100e53:	e8 b8 38 00 00       	call   80104710 <acquire>
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
80100e7b:	e9 00 39 00 00       	jmp    80104780 <release>
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
80100e9f:	e8 dc 38 00 00       	call   80104780 <release>
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
80100eec:	c7 04 24 3c 73 10 80 	movl   $0x8010733c,(%esp)
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
80100fd7:	c7 04 24 46 73 10 80 	movl   $0x80107346,(%esp)
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
801010f1:	c7 04 24 4f 73 10 80 	movl   $0x8010734f,(%esp)
801010f8:	e8 63 f2 ff ff       	call   80100360 <panic>
  panic("filewrite");
801010fd:	c7 04 24 55 73 10 80 	movl   $0x80107355,(%esp)
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
80101175:	c7 04 24 5f 73 10 80 	movl   $0x8010735f,(%esp)
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
80101235:	c7 04 24 72 73 10 80 	movl   $0x80107372,(%esp)
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
80101288:	e8 43 35 00 00       	call   801047d0 <memset>
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
801012cc:	e8 3f 34 00 00       	call   80104710 <acquire>
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
80101309:	e8 72 34 00 00       	call   80104780 <release>
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
8010134e:	e8 2d 34 00 00       	call   80104780 <release>
}
80101353:	83 c4 1c             	add    $0x1c,%esp
80101356:	89 f0                	mov    %esi,%eax
80101358:	5b                   	pop    %ebx
80101359:	5e                   	pop    %esi
8010135a:	5f                   	pop    %edi
8010135b:	5d                   	pop    %ebp
8010135c:	c3                   	ret    
    panic("iget: no inodes");
8010135d:	c7 04 24 88 73 10 80 	movl   $0x80107388,(%esp)
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
80101417:	c7 04 24 98 73 10 80 	movl   $0x80107398,(%esp)
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
80101462:	e8 09 34 00 00       	call   80104870 <memmove>
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
8010148c:	c7 44 24 04 ab 73 10 	movl   $0x801073ab,0x4(%esp)
80101493:	80 
80101494:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010149b:	e8 00 31 00 00       	call   801045a0 <initlock>
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	89 1c 24             	mov    %ebx,(%esp)
801014a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014a9:	c7 44 24 04 b2 73 10 	movl   $0x801073b2,0x4(%esp)
801014b0:	80 
801014b1:	e8 ba 2f 00 00       	call   80104470 <initsleeplock>
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
801014d6:	c7 04 24 18 74 10 80 	movl   $0x80107418,(%esp)
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
801015b9:	e8 12 32 00 00       	call   801047d0 <memset>
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
801015f1:	c7 04 24 b8 73 10 80 	movl   $0x801073b8,(%esp)
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
80101670:	e8 fb 31 00 00       	call   80104870 <memmove>
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
801016a1:	e8 6a 30 00 00       	call   80104710 <acquire>
  ip->ref++;
801016a6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016aa:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016b1:	e8 ca 30 00 00       	call   80104780 <release>
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
801016e4:	e8 c7 2d 00 00       	call   801044b0 <acquiresleep>
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
8010175b:	e8 10 31 00 00       	call   80104870 <memmove>
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
8010177a:	c7 04 24 d0 73 10 80 	movl   $0x801073d0,(%esp)
80101781:	e8 da eb ff ff       	call   80100360 <panic>
    panic("ilock");
80101786:	c7 04 24 ca 73 10 80 	movl   $0x801073ca,(%esp)
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
801017b5:	e8 96 2d 00 00       	call   80104550 <holdingsleep>
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
801017ce:	e9 3d 2d 00 00       	jmp    80104510 <releasesleep>
    panic("iunlock");
801017d3:	c7 04 24 df 73 10 80 	movl   $0x801073df,(%esp)
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
801017f2:	e8 b9 2c 00 00       	call   801044b0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017f7:	8b 56 4c             	mov    0x4c(%esi),%edx
801017fa:	85 d2                	test   %edx,%edx
801017fc:	74 07                	je     80101805 <iput+0x25>
801017fe:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101803:	74 2b                	je     80101830 <iput+0x50>
  releasesleep(&ip->lock);
80101805:	89 3c 24             	mov    %edi,(%esp)
80101808:	e8 03 2d 00 00       	call   80104510 <releasesleep>
  acquire(&icache.lock);
8010180d:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101814:	e8 f7 2e 00 00       	call   80104710 <acquire>
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
8010182b:	e9 50 2f 00 00       	jmp    80104780 <release>
    acquire(&icache.lock);
80101830:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101837:	e8 d4 2e 00 00       	call   80104710 <acquire>
    int r = ip->ref;
8010183c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010183f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101846:	e8 35 2f 00 00       	call   80104780 <release>
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
80101a18:	e8 53 2e 00 00       	call   80104870 <memmove>
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
80101b14:	e8 57 2d 00 00       	call   80104870 <memmove>
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
80101bbb:	e8 30 2d 00 00       	call   801048f0 <strncmp>
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
80101c39:	e8 b2 2c 00 00       	call   801048f0 <strncmp>
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
80101c72:	c7 04 24 f9 73 10 80 	movl   $0x801073f9,(%esp)
80101c79:	e8 e2 e6 ff ff       	call   80100360 <panic>
    panic("dirlookup not DIR");
80101c7e:	c7 04 24 e7 73 10 80 	movl   $0x801073e7,(%esp)
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
80101cb8:	e8 53 2a 00 00       	call   80104710 <acquire>
  ip->ref++;
80101cbd:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cc1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cc8:	e8 b3 2a 00 00       	call   80104780 <release>
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
80101d2b:	e8 40 2b 00 00       	call   80104870 <memmove>
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
80101db9:	e8 b2 2a 00 00       	call   80104870 <memmove>
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
80101eb3:	e8 a8 2a 00 00       	call   80104960 <strncpy>
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
80101ef5:	c7 04 24 08 74 10 80 	movl   $0x80107408,(%esp)
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
80101fef:	c7 04 24 74 74 10 80 	movl   $0x80107474,(%esp)
80101ff6:	e8 65 e3 ff ff       	call   80100360 <panic>
    panic("idestart");
80101ffb:	c7 04 24 6b 74 10 80 	movl   $0x8010746b,(%esp)
80102002:	e8 59 e3 ff ff       	call   80100360 <panic>
80102007:	89 f6                	mov    %esi,%esi
80102009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102010 <ideinit>:
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	83 ec 18             	sub    $0x18,%esp
  initlock(&idelock, "ide");
80102016:	c7 44 24 04 86 74 10 	movl   $0x80107486,0x4(%esp)
8010201d:	80 
8010201e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102025:	e8 76 25 00 00       	call   801045a0 <initlock>
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
801020a0:	e8 6b 26 00 00       	call   80104710 <acquire>

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
801020cc:	e8 df 21 00 00       	call   801042b0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020d1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020d6:	85 c0                	test   %eax,%eax
801020d8:	74 05                	je     801020df <ideintr+0x4f>
    idestart(idequeue);
801020da:	e8 71 fe ff ff       	call   80101f50 <idestart>
    release(&idelock);
801020df:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020e6:	e8 95 26 00 00       	call   80104780 <release>

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
80102140:	e8 0b 24 00 00       	call   80104550 <holdingsleep>
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
80102176:	e8 95 25 00 00       	call   80104710 <acquire>

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
801021bb:	e8 60 1d 00 00       	call   80103f20 <sleep>
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
801021d6:	e9 a5 25 00 00       	jmp    80104780 <release>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021db:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021e0:	eb ba                	jmp    8010219c <iderw+0x6c>
    idestart(b);
801021e2:	89 d8                	mov    %ebx,%eax
801021e4:	e8 67 fd ff ff       	call   80101f50 <idestart>
801021e9:	eb bb                	jmp    801021a6 <iderw+0x76>
    panic("iderw: buf not locked");
801021eb:	c7 04 24 8a 74 10 80 	movl   $0x8010748a,(%esp)
801021f2:	e8 69 e1 ff ff       	call   80100360 <panic>
    panic("iderw: ide disk 1 not present");
801021f7:	c7 04 24 b5 74 10 80 	movl   $0x801074b5,(%esp)
801021fe:	e8 5d e1 ff ff       	call   80100360 <panic>
    panic("iderw: nothing to do");
80102203:	c7 04 24 a0 74 10 80 	movl   $0x801074a0,(%esp)
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
80102258:	c7 04 24 d4 74 10 80 	movl   $0x801074d4,(%esp)
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
8010233a:	e8 91 24 00 00       	call   801047d0 <memset>

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
80102374:	e9 07 24 00 00       	jmp    80104780 <release>
80102379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
80102380:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102387:	e8 84 23 00 00       	call   80104710 <acquire>
8010238c:	eb bb                	jmp    80102349 <kfree+0x49>
    panic("kfree");
8010238e:	c7 04 24 06 75 10 80 	movl   $0x80107506,(%esp)
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
801023fb:	c7 44 24 04 0c 75 10 	movl   $0x8010750c,0x4(%esp)
80102402:	80 
80102403:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010240a:	e8 91 21 00 00       	call   801045a0 <initlock>
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
801024dd:	e8 9e 22 00 00       	call   80104780 <release>
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
801024f7:	e8 14 22 00 00       	call   80104710 <acquire>
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
80102544:	0f b6 81 40 76 10 80 	movzbl -0x7fef89c0(%ecx),%eax
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
80102578:	0f b6 91 40 76 10 80 	movzbl -0x7fef89c0(%ecx),%edx
  shift ^= togglecode[data];
8010257f:	0f b6 81 40 75 10 80 	movzbl -0x7fef8ac0(%ecx),%eax
  shift |= shiftcode[data];
80102586:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102588:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010258a:	89 d0                	mov    %edx,%eax
8010258c:	83 e0 03             	and    $0x3,%eax
8010258f:	8b 04 85 20 75 10 80 	mov    -0x7fef8ae0(,%eax,4),%eax
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
801028ac:	e8 6f 1f 00 00       	call   80104820 <memcmp>
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
801029d7:	e8 94 1e 00 00       	call   80104870 <memmove>
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
80102a8b:	c7 44 24 04 40 77 10 	movl   $0x80107740,0x4(%esp)
80102a92:	80 
80102a93:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102a9a:	e8 01 1b 00 00       	call   801045a0 <initlock>
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
80102b2d:	e8 de 1b 00 00       	call   80104710 <acquire>
80102b32:	eb 18                	jmp    80102b4c <begin_op+0x2c>
80102b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b38:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102b3f:	80 
80102b40:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b47:	e8 d4 13 00 00       	call   80103f20 <sleep>
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
80102b7a:	e8 01 1c 00 00       	call   80104780 <release>
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
80102ba0:	e8 6b 1b 00 00       	call   80104710 <acquire>
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
80102bdb:	e8 a0 1b 00 00       	call   80104780 <release>
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
80102c3f:	e8 2c 1c 00 00       	call   80104870 <memmove>
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
80102c84:	e8 87 1a 00 00       	call   80104710 <acquire>
    log.committing = 0;
80102c89:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102c90:	00 00 00 
    wakeup(&log);
80102c93:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c9a:	e8 11 16 00 00       	call   801042b0 <wakeup>
    release(&log.lock);
80102c9f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ca6:	e8 d5 1a 00 00       	call   80104780 <release>
}
80102cab:	83 c4 1c             	add    $0x1c,%esp
80102cae:	5b                   	pop    %ebx
80102caf:	5e                   	pop    %esi
80102cb0:	5f                   	pop    %edi
80102cb1:	5d                   	pop    %ebp
80102cb2:	c3                   	ret    
    panic("log.committing");
80102cb3:	c7 04 24 44 77 10 80 	movl   $0x80107744,(%esp)
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
80102cfd:	e8 0e 1a 00 00       	call   80104710 <acquire>
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
80102d4f:	e9 2c 1a 00 00       	jmp    80104780 <release>
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
80102d70:	c7 04 24 53 77 10 80 	movl   $0x80107753,(%esp)
80102d77:	e8 e4 d5 ff ff       	call   80100360 <panic>
    panic("log_write outside of trans");
80102d7c:	c7 04 24 69 77 10 80 	movl   $0x80107769,(%esp)
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
80102da7:	c7 04 24 84 77 10 80 	movl   $0x80107784,(%esp)
80102dae:	89 44 24 04          	mov    %eax,0x4(%esp)
80102db2:	e8 99 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102db7:	e8 74 2d 00 00       	call   80105b30 <idtinit>
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
80102de6:	e8 05 3e 00 00       	call   80106bf0 <switchkvm>
  seginit();
80102deb:	e8 40 3d 00 00       	call   80106b30 <seginit>
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
80102e23:	e8 58 42 00 00       	call   80107080 <kvmalloc>
  mpinit();        // detect other processors
80102e28:	e8 73 01 00 00       	call   80102fa0 <mpinit>
80102e2d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e30:	e8 4b f8 ff ff       	call   80102680 <lapicinit>
  seginit();       // segment descriptors
80102e35:	e8 f6 3c 00 00       	call   80106b30 <seginit>
  picinit();       // disable pic
80102e3a:	e8 21 03 00 00       	call   80103160 <picinit>
80102e3f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e40:	e8 cb f3 ff ff       	call   80102210 <ioapicinit>
  consoleinit();   // console hardware
80102e45:	e8 06 db ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e4a:	e8 01 30 00 00       	call   80105e50 <uartinit>
80102e4f:	90                   	nop
  pinit();         // process table
80102e50:	e8 cb 07 00 00       	call   80103620 <pinit>
  tvinit();        // trap vectors
80102e55:	e8 36 2c 00 00       	call   80105a90 <tvinit>
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
80102e81:	e8 ea 19 00 00       	call   80104870 <memmove>
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
80102f50:	c7 44 24 04 98 77 10 	movl   $0x80107798,0x4(%esp)
80102f57:	80 
80102f58:	89 34 24             	mov    %esi,(%esp)
80102f5b:	e8 c0 18 00 00       	call   80104820 <memcmp>
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
8010300b:	c7 44 24 04 9d 77 10 	movl   $0x8010779d,0x4(%esp)
80103012:	80 
80103013:	89 04 24             	mov    %eax,(%esp)
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103016:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103019:	e8 02 18 00 00       	call   80104820 <memcmp>
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
8010309c:	ff 24 8d dc 77 10 80 	jmp    *-0x7fef8824(,%ecx,4)
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
8010312d:	c7 04 24 a2 77 10 80 	movl   $0x801077a2,(%esp)
80103134:	e8 27 d2 ff ff       	call   80100360 <panic>
80103139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(conf->version != 1 && conf->version != 4)
80103140:	3c 01                	cmp    $0x1,%al
80103142:	0f 84 ed fe ff ff    	je     80103035 <mpinit+0x95>
80103148:	eb e3                	jmp    8010312d <mpinit+0x18d>
    panic("Didn't find a suitable machine");
8010314a:	c7 04 24 bc 77 10 80 	movl   $0x801077bc,(%esp)
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
801031ef:	c7 44 24 04 f0 77 10 	movl   $0x801077f0,0x4(%esp)
801031f6:	80 
801031f7:	e8 a4 13 00 00       	call   801045a0 <initlock>
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
80103281:	e8 8a 14 00 00       	call   80104710 <acquire>
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
8010329d:	e8 0e 10 00 00       	call   801042b0 <wakeup>
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
801032bf:	e9 bc 14 00 00       	jmp    80104780 <release>
801032c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801032c8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801032ce:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032d5:	00 00 00 
    wakeup(&p->nwrite);
801032d8:	89 04 24             	mov    %eax,(%esp)
801032db:	e8 d0 0f 00 00       	call   801042b0 <wakeup>
801032e0:	eb c0                	jmp    801032a2 <pipeclose+0x32>
801032e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&p->lock);
801032e8:	89 1c 24             	mov    %ebx,(%esp)
801032eb:	e8 90 14 00 00       	call   80104780 <release>
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
8010330f:	e8 fc 13 00 00       	call   80104710 <acquire>
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
8010335f:	e8 4c 0f 00 00       	call   801042b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103364:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103368:	89 34 24             	mov    %esi,(%esp)
8010336b:	e8 b0 0b 00 00       	call   80103f20 <sleep>
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
80103392:	e8 e9 13 00 00       	call   80104780 <release>
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
801033da:	e8 d1 0e 00 00       	call   801042b0 <wakeup>
  release(&p->lock);
801033df:	89 1c 24             	mov    %ebx,(%esp)
801033e2:	e8 99 13 00 00       	call   80104780 <release>
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
80103402:	e8 09 13 00 00       	call   80104710 <acquire>
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
8010342f:	e8 ec 0a 00 00       	call   80103f20 <sleep>
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
8010345b:	e8 20 13 00 00       	call   80104780 <release>
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
801034b5:	e8 f6 0d 00 00       	call   801042b0 <wakeup>
  release(&p->lock);
801034ba:	89 34 24             	mov    %esi,(%esp)
801034bd:	e8 be 12 00 00       	call   80104780 <release>
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
801034e3:	e8 28 12 00 00       	call   80104710 <acquire>
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
80103550:	e8 2b 12 00 00       	call   80104780 <release>

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
8010356f:	c7 40 14 81 5a 10 80 	movl   $0x80105a81,0x14(%eax)
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
8010358c:	e8 3f 12 00 00       	call   801047d0 <memset>
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
801035af:	e8 cc 11 00 00       	call   80104780 <release>
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
801035dd:	e8 9e 11 00 00       	call   80104780 <release>

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
80103626:	c7 44 24 04 f5 77 10 	movl   $0x801077f5,0x4(%esp)
8010362d:	80 
8010362e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103635:	e8 66 0f 00 00       	call   801045a0 <initlock>
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
8010369a:	c7 04 24 fc 77 10 80 	movl   $0x801077fc,(%esp)
801036a1:	e8 ba cc ff ff       	call   80100360 <panic>
    panic("mycpu called with interrupts enabled\n");
801036a6:	c7 04 24 0c 79 10 80 	movl   $0x8010790c,(%esp)
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
801036e7:	e8 34 0f 00 00       	call   80104620 <pushcli>
  c = mycpu();
801036ec:	e8 4f ff ff ff       	call   80103640 <mycpu>
  p = c->proc;
801036f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036f7:	e8 64 0f 00 00       	call   80104660 <popcli>
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
80103723:	e8 c8 38 00 00       	call   80106ff0 <setupkvm>
80103728:	85 c0                	test   %eax,%eax
8010372a:	89 43 08             	mov    %eax,0x8(%ebx)
8010372d:	0f 84 d5 00 00 00    	je     80103808 <userinit+0xf8>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103733:	89 04 24             	mov    %eax,(%esp)
80103736:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010373d:	00 
8010373e:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103745:	80 
80103746:	e8 d5 35 00 00       	call   80106d20 <inituvm>
  p->sz = PGSIZE;
8010374b:	c7 43 04 00 10 00 00 	movl   $0x1000,0x4(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103752:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103759:	00 
8010375a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103761:	00 
80103762:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103765:	89 04 24             	mov    %eax,(%esp)
80103768:	e8 63 10 00 00       	call   801047d0 <memset>
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
801037c4:	c7 44 24 04 25 78 10 	movl   $0x80107825,0x4(%esp)
801037cb:	80 
801037cc:	89 04 24             	mov    %eax,(%esp)
801037cf:	e8 dc 11 00 00       	call   801049b0 <safestrcpy>
  p->cwd = namei("/");
801037d4:	c7 04 24 2e 78 10 80 	movl   $0x8010782e,(%esp)
801037db:	e8 30 e7 ff ff       	call   80101f10 <namei>
801037e0:	89 43 6c             	mov    %eax,0x6c(%ebx)
  acquire(&ptable.lock);
801037e3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037ea:	e8 21 0f 00 00       	call   80104710 <acquire>
  p->state = RUNNABLE;
801037ef:	c7 43 10 03 00 00 00 	movl   $0x3,0x10(%ebx)
  release(&ptable.lock);
801037f6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037fd:	e8 7e 0f 00 00       	call   80104780 <release>
}
80103802:	83 c4 14             	add    $0x14,%esp
80103805:	5b                   	pop    %ebx
80103806:	5d                   	pop    %ebp
80103807:	c3                   	ret    
    panic("userinit: out of memory?");
80103808:	c7 04 24 0c 78 10 80 	movl   $0x8010780c,(%esp)
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
8010384a:	e8 11 36 00 00       	call   80106e60 <allocuvm>
8010384f:	85 c0                	test   %eax,%eax
80103851:	74 35                	je     80103888 <growproc+0x68>
  curproc->sz = sz;
80103853:	89 43 04             	mov    %eax,0x4(%ebx)
  switchuvm(curproc);
80103856:	89 1c 24             	mov    %ebx,(%esp)
80103859:	e8 b2 33 00 00       	call   80106c10 <switchuvm>
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
8010387a:	e8 d1 36 00 00       	call   80106f50 <deallocuvm>
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
801038bf:	e8 0c 38 00 00       	call   801070d0 <copyuvm>
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
80103945:	e8 66 10 00 00       	call   801049b0 <safestrcpy>
  pid = np->pid;
8010394a:	8b 5f 14             	mov    0x14(%edi),%ebx
  acquire(&ptable.lock);
8010394d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103954:	e8 b7 0d 00 00       	call   80104710 <acquire>
  np->state = RUNNABLE;
80103959:	c7 47 10 03 00 00 00 	movl   $0x3,0x10(%edi)
  release(&ptable.lock);
80103960:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103967:	e8 14 0e 00 00       	call   80104780 <release>
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
  struct proc* highestPriority_proc = ptable.proc; //cs153_lab2: points the process with the highest priority and is initialized to point to the first process in ptable
80103a04:	bf 54 2d 11 80       	mov    $0x80112d54,%edi
{
80103a09:	56                   	push   %esi
80103a0a:	53                   	push   %ebx
80103a0b:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
80103a0e:	e8 2d fc ff ff       	call   80103640 <mycpu>
  c->proc = 0;
80103a13:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103a1a:	00 00 00 
  struct cpu *c = mycpu();
80103a1d:	89 c3                	mov    %eax,%ebx
80103a1f:	8d 40 04             	lea    0x4(%eax),%eax
80103a22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("sti");
80103a25:	fb                   	sti    
    acquire(&ptable.lock);
80103a26:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a2d:	e8 de 0c 00 00       	call   80104710 <acquire>
    if (highestPriority_proc == &ptable.proc[NPROC-1] && highestPriority_proc->state != RUNNABLE)
80103a32:	81 ff c4 50 11 80    	cmp    $0x801150c4,%edi
80103a38:	0f 84 f4 00 00 00    	je     80103b32 <scheduler+0x132>
    for(p = highestPriority_proc; p < &ptable.proc[NPROC]; p++)
80103a3e:	81 ff 54 51 11 80    	cmp    $0x80115154,%edi
80103a44:	0f 83 d7 00 00 00    	jae    80103b21 <scheduler+0x121>
80103a4a:	8b 57 10             	mov    0x10(%edi),%edx
80103a4d:	89 f8                	mov    %edi,%eax
  struct proc* highestPriority_proc = ptable.proc; //cs153_lab2: points the process with the highest priority and is initialized to point to the first process in ptable
80103a4f:	89 c6                	mov    %eax,%esi
80103a51:	89 c7                	mov    %eax,%edi
80103a53:	eb 18                	jmp    80103a6d <scheduler+0x6d>
80103a55:	8d 76 00             	lea    0x0(%esi),%esi
    for(p = highestPriority_proc; p < &ptable.proc[NPROC]; p++)
80103a58:	81 c6 90 00 00 00    	add    $0x90,%esi
80103a5e:	81 fe 54 51 11 80    	cmp    $0x80115154,%esi
80103a64:	0f 83 b7 00 00 00    	jae    80103b21 <scheduler+0x121>
80103a6a:	8b 56 10             	mov    0x10(%esi),%edx
      if (p->state != RUNNABLE)
80103a6d:	83 fa 03             	cmp    $0x3,%edx
80103a70:	75 e6                	jne    80103a58 <scheduler+0x58>
80103a72:	89 f7                	mov    %esi,%edi
80103a74:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103a79:	eb 13                	jmp    80103a8e <scheduler+0x8e>
80103a7b:	90                   	nop
80103a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for (tempProc = ptable.proc; tempProc < &ptable.proc[NPROC]; tempProc++)
80103a80:	81 c2 90 00 00 00    	add    $0x90,%edx
80103a86:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
80103a8c:	74 23                	je     80103ab1 <scheduler+0xb1>
        if (tempProc->state != RUNNABLE)
80103a8e:	83 7a 10 03          	cmpl   $0x3,0x10(%edx)
80103a92:	75 ec                	jne    80103a80 <scheduler+0x80>
80103a94:	8b 87 80 00 00 00    	mov    0x80(%edi),%eax
80103a9a:	39 82 80 00 00 00    	cmp    %eax,0x80(%edx)
80103aa0:	0f 4c fa             	cmovl  %edx,%edi
      for (tempProc = ptable.proc; tempProc < &ptable.proc[NPROC]; tempProc++)
80103aa3:	81 c2 90 00 00 00    	add    $0x90,%edx
80103aa9:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
80103aaf:	75 dd                	jne    80103a8e <scheduler+0x8e>
      c->proc = highestPriority_proc; //cs153_lab2: set cpu process to the highest priority process
80103ab1:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(highestPriority_proc); //cs153_lab2: switch to the highest priority process (load said process to the user)
80103ab7:	89 3c 24             	mov    %edi,(%esp)
80103aba:	e8 51 31 00 00       	call   80106c10 <switchuvm>
      highestPriority_proc->burstTime = ticks; //cs153_lab2: set the highest priority process' burst time to number of cpu ticks (proc start running time)
80103abf:	8b 15 a0 59 11 80    	mov    0x801159a0,%edx
      swtch(&(c->scheduler), highestPriority_proc->context); //context switch to the highest priority process
80103ac5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      highestPriority_proc->state = RUNNING; //cs153_lab2: set the highest priority process' state to RUNNING
80103ac8:	c7 47 10 04 00 00 00 	movl   $0x4,0x10(%edi)
      highestPriority_proc->burstTime = ticks; //cs153_lab2: set the highest priority process' burst time to number of cpu ticks (proc start running time)
80103acf:	89 97 8c 00 00 00    	mov    %edx,0x8c(%edi)
      swtch(&(c->scheduler), highestPriority_proc->context); //context switch to the highest priority process
80103ad5:	8b 57 20             	mov    0x20(%edi),%edx
80103ad8:	89 04 24             	mov    %eax,(%esp)
80103adb:	89 54 24 04          	mov    %edx,0x4(%esp)
80103adf:	e8 27 0f 00 00       	call   80104a0b <swtch>
      switchkvm(); //the kernel loads its memory
80103ae4:	e8 07 31 00 00       	call   80106bf0 <switchkvm>
      c->proc = 0;
80103ae9:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103af0:	00 00 00 
      if (highestPriority_proc->state == ZOMBIE)
80103af3:	83 7f 10 05          	cmpl   $0x5,0x10(%edi)
80103af7:	0f 85 5b ff ff ff    	jne    80103a58 <scheduler+0x58>
        highestPriority_proc->burstTime = ticks - highestPriority_proc->burstTime; //cs153_lab2: compute the highest priority process' burst time (T_finish - T_start)
80103afd:	8b 15 a0 59 11 80    	mov    0x801159a0,%edx
    for(p = highestPriority_proc; p < &ptable.proc[NPROC]; p++)
80103b03:	81 c6 90 00 00 00    	add    $0x90,%esi
        highestPriority_proc->burstTime = ticks - highestPriority_proc->burstTime; //cs153_lab2: compute the highest priority process' burst time (T_finish - T_start)
80103b09:	2b 97 8c 00 00 00    	sub    0x8c(%edi),%edx
    for(p = highestPriority_proc; p < &ptable.proc[NPROC]; p++)
80103b0f:	81 fe 54 51 11 80    	cmp    $0x80115154,%esi
        highestPriority_proc->burstTime = ticks - highestPriority_proc->burstTime; //cs153_lab2: compute the highest priority process' burst time (T_finish - T_start)
80103b15:	89 97 8c 00 00 00    	mov    %edx,0x8c(%edi)
    for(p = highestPriority_proc; p < &ptable.proc[NPROC]; p++)
80103b1b:	0f 82 49 ff ff ff    	jb     80103a6a <scheduler+0x6a>
    release(&ptable.lock);
80103b21:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b28:	e8 53 0c 00 00       	call   80104780 <release>
  }
80103b2d:	e9 f3 fe ff ff       	jmp    80103a25 <scheduler+0x25>
    if (highestPriority_proc == &ptable.proc[NPROC-1] && highestPriority_proc->state != RUNNABLE)
80103b32:	8b 15 d4 50 11 80    	mov    0x801150d4,%edx
80103b38:	b8 c4 50 11 80       	mov    $0x801150c4,%eax
80103b3d:	83 fa 03             	cmp    $0x3,%edx
80103b40:	0f 84 09 ff ff ff    	je     80103a4f <scheduler+0x4f>
80103b46:	8b 15 64 2d 11 80    	mov    0x80112d64,%edx
      highestPriority_proc = ptable.proc; //cs153_lab2: highestPriority_proc points to the first process in the ptable, to simulate "that the last process points to the first"
80103b4c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103b51:	e9 f9 fe ff ff       	jmp    80103a4f <scheduler+0x4f>
80103b56:	8d 76 00             	lea    0x0(%esi),%esi
80103b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b60 <sched>:
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	56                   	push   %esi
80103b64:	53                   	push   %ebx
80103b65:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = myproc();
80103b68:	e8 73 fb ff ff       	call   801036e0 <myproc>
  if(!holding(&ptable.lock))
80103b6d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *p = myproc();
80103b74:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103b76:	e8 55 0b 00 00       	call   801046d0 <holding>
80103b7b:	85 c0                	test   %eax,%eax
80103b7d:	74 4f                	je     80103bce <sched+0x6e>
  if(mycpu()->ncli != 1)
80103b7f:	e8 bc fa ff ff       	call   80103640 <mycpu>
80103b84:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103b8b:	75 65                	jne    80103bf2 <sched+0x92>
  if(p->state == RUNNING)
80103b8d:	83 7b 10 04          	cmpl   $0x4,0x10(%ebx)
80103b91:	74 53                	je     80103be6 <sched+0x86>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b93:	9c                   	pushf  
80103b94:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b95:	f6 c4 02             	test   $0x2,%ah
80103b98:	75 40                	jne    80103bda <sched+0x7a>
  intena = mycpu()->intena;
80103b9a:	e8 a1 fa ff ff       	call   80103640 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103b9f:	83 c3 20             	add    $0x20,%ebx
  intena = mycpu()->intena;
80103ba2:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ba8:	e8 93 fa ff ff       	call   80103640 <mycpu>
80103bad:	8b 40 04             	mov    0x4(%eax),%eax
80103bb0:	89 1c 24             	mov    %ebx,(%esp)
80103bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
80103bb7:	e8 4f 0e 00 00       	call   80104a0b <swtch>
  mycpu()->intena = intena;
80103bbc:	e8 7f fa ff ff       	call   80103640 <mycpu>
80103bc1:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103bc7:	83 c4 10             	add    $0x10,%esp
80103bca:	5b                   	pop    %ebx
80103bcb:	5e                   	pop    %esi
80103bcc:	5d                   	pop    %ebp
80103bcd:	c3                   	ret    
    panic("sched ptable.lock");
80103bce:	c7 04 24 30 78 10 80 	movl   $0x80107830,(%esp)
80103bd5:	e8 86 c7 ff ff       	call   80100360 <panic>
    panic("sched interruptible");
80103bda:	c7 04 24 5c 78 10 80 	movl   $0x8010785c,(%esp)
80103be1:	e8 7a c7 ff ff       	call   80100360 <panic>
    panic("sched running");
80103be6:	c7 04 24 4e 78 10 80 	movl   $0x8010784e,(%esp)
80103bed:	e8 6e c7 ff ff       	call   80100360 <panic>
    panic("sched locks");
80103bf2:	c7 04 24 42 78 10 80 	movl   $0x80107842,(%esp)
80103bf9:	e8 62 c7 ff ff       	call   80100360 <panic>
80103bfe:	66 90                	xchg   %ax,%ax

80103c00 <exit>:
{
80103c00:	55                   	push   %ebp
80103c01:	89 e5                	mov    %esp,%ebp
80103c03:	56                   	push   %esi
  if(curproc == initproc)
80103c04:	31 f6                	xor    %esi,%esi
{
80103c06:	53                   	push   %ebx
80103c07:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103c0a:	e8 d1 fa ff ff       	call   801036e0 <myproc>
  if(curproc == initproc)
80103c0f:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
  struct proc *curproc = myproc();
80103c15:	89 c3                	mov    %eax,%ebx
  if(curproc == initproc)
80103c17:	0f 84 fd 00 00 00    	je     80103d1a <exit+0x11a>
80103c1d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103c20:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103c24:	85 c0                	test   %eax,%eax
80103c26:	74 10                	je     80103c38 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103c28:	89 04 24             	mov    %eax,(%esp)
80103c2b:	e8 10 d2 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103c30:	c7 44 b3 2c 00 00 00 	movl   $0x0,0x2c(%ebx,%esi,4)
80103c37:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103c38:	83 c6 01             	add    $0x1,%esi
80103c3b:	83 fe 10             	cmp    $0x10,%esi
80103c3e:	75 e0                	jne    80103c20 <exit+0x20>
  begin_op();
80103c40:	e8 db ee ff ff       	call   80102b20 <begin_op>
  iput(curproc->cwd);
80103c45:	8b 43 6c             	mov    0x6c(%ebx),%eax
80103c48:	89 04 24             	mov    %eax,(%esp)
80103c4b:	e8 90 db ff ff       	call   801017e0 <iput>
  end_op();
80103c50:	e8 3b ef ff ff       	call   80102b90 <end_op>
  curproc->cwd = 0;
80103c55:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
  acquire(&ptable.lock);
80103c5c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c63:	e8 a8 0a 00 00       	call   80104710 <acquire>
  wakeup1(curproc->parent);
80103c68:	8b 43 18             	mov    0x18(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c6b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103c70:	eb 14                	jmp    80103c86 <exit+0x86>
80103c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c78:	81 c2 90 00 00 00    	add    $0x90,%edx
80103c7e:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
80103c84:	74 20                	je     80103ca6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103c86:	83 7a 10 02          	cmpl   $0x2,0x10(%edx)
80103c8a:	75 ec                	jne    80103c78 <exit+0x78>
80103c8c:	3b 42 24             	cmp    0x24(%edx),%eax
80103c8f:	75 e7                	jne    80103c78 <exit+0x78>
      p->state = RUNNABLE;
80103c91:	c7 42 10 03 00 00 00 	movl   $0x3,0x10(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c98:	81 c2 90 00 00 00    	add    $0x90,%edx
80103c9e:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
80103ca4:	75 e0                	jne    80103c86 <exit+0x86>
      p->parent = initproc;
80103ca6:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103cab:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103cb0:	eb 14                	jmp    80103cc6 <exit+0xc6>
80103cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cb8:	81 c1 90 00 00 00    	add    $0x90,%ecx
80103cbe:	81 f9 54 51 11 80    	cmp    $0x80115154,%ecx
80103cc4:	74 3c                	je     80103d02 <exit+0x102>
    if(p->parent == curproc){
80103cc6:	39 59 18             	cmp    %ebx,0x18(%ecx)
80103cc9:	75 ed                	jne    80103cb8 <exit+0xb8>
      if(p->state == ZOMBIE)
80103ccb:	83 79 10 05          	cmpl   $0x5,0x10(%ecx)
      p->parent = initproc;
80103ccf:	89 41 18             	mov    %eax,0x18(%ecx)
      if(p->state == ZOMBIE)
80103cd2:	75 e4                	jne    80103cb8 <exit+0xb8>
80103cd4:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103cd9:	eb 13                	jmp    80103cee <exit+0xee>
80103cdb:	90                   	nop
80103cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ce0:	81 c2 90 00 00 00    	add    $0x90,%edx
80103ce6:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
80103cec:	74 ca                	je     80103cb8 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103cee:	83 7a 10 02          	cmpl   $0x2,0x10(%edx)
80103cf2:	75 ec                	jne    80103ce0 <exit+0xe0>
80103cf4:	3b 42 24             	cmp    0x24(%edx),%eax
80103cf7:	75 e7                	jne    80103ce0 <exit+0xe0>
      p->state = RUNNABLE;
80103cf9:	c7 42 10 03 00 00 00 	movl   $0x3,0x10(%edx)
80103d00:	eb de                	jmp    80103ce0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103d02:	c7 43 10 05 00 00 00 	movl   $0x5,0x10(%ebx)
  sched();
80103d09:	e8 52 fe ff ff       	call   80103b60 <sched>
  panic("zombie exit");
80103d0e:	c7 04 24 7d 78 10 80 	movl   $0x8010787d,(%esp)
80103d15:	e8 46 c6 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103d1a:	c7 04 24 70 78 10 80 	movl   $0x80107870,(%esp)
80103d21:	e8 3a c6 ff ff       	call   80100360 <panic>
80103d26:	8d 76 00             	lea    0x0(%esi),%esi
80103d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d30 <exitStatus>:
{
80103d30:	55                   	push   %ebp
80103d31:	89 e5                	mov    %esp,%ebp
80103d33:	56                   	push   %esi
  if (curproc == initproc)
80103d34:	31 f6                	xor    %esi,%esi
{
80103d36:	53                   	push   %ebx
80103d37:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103d3a:	e8 a1 f9 ff ff       	call   801036e0 <myproc>
80103d3f:	89 c3                	mov    %eax,%ebx
  curproc->exitStatus = status; //cs153_lab1: sets the process' exit status to status
80103d41:	8b 45 08             	mov    0x8(%ebp),%eax
  if (curproc == initproc)
80103d44:	3b 1d b8 a5 10 80    	cmp    0x8010a5b8,%ebx
  curproc->exitStatus = status; //cs153_lab1: sets the process' exit status to status
80103d4a:	89 03                	mov    %eax,(%ebx)
  if (curproc == initproc)
80103d4c:	0f 84 5c 01 00 00    	je     80103eae <exitStatus+0x17e>
80103d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd])
80103d58:	8b 44 b3 2c          	mov    0x2c(%ebx,%esi,4),%eax
80103d5c:	85 c0                	test   %eax,%eax
80103d5e:	74 10                	je     80103d70 <exitStatus+0x40>
      fileclose(curproc->ofile[fd]);
80103d60:	89 04 24             	mov    %eax,(%esp)
80103d63:	e8 d8 d0 ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103d68:	c7 44 b3 2c 00 00 00 	movl   $0x0,0x2c(%ebx,%esi,4)
80103d6f:	00 
  for (fd = 0; fd < NOFILE; fd++)
80103d70:	83 c6 01             	add    $0x1,%esi
80103d73:	83 fe 10             	cmp    $0x10,%esi
80103d76:	75 e0                	jne    80103d58 <exitStatus+0x28>
  begin_op();
80103d78:	e8 a3 ed ff ff       	call   80102b20 <begin_op>
  iput(curproc->cwd);
80103d7d:	8b 43 6c             	mov    0x6c(%ebx),%eax
80103d80:	89 04 24             	mov    %eax,(%esp)
80103d83:	e8 58 da ff ff       	call   801017e0 <iput>
  end_op();
80103d88:	e8 03 ee ff ff       	call   80102b90 <end_op>
  curproc->cwd = 0;
80103d8d:	c7 43 6c 00 00 00 00 	movl   $0x0,0x6c(%ebx)
  acquire(&ptable.lock);
80103d94:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d9b:	e8 70 09 00 00       	call   80104710 <acquire>
  wakeup1(curproc->parent);
80103da0:	8b 43 18             	mov    0x18(%ebx),%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103da3:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103da8:	eb 14                	jmp    80103dbe <exitStatus+0x8e>
80103daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103db0:	81 c2 90 00 00 00    	add    $0x90,%edx
80103db6:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
80103dbc:	74 20                	je     80103dde <exitStatus+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103dbe:	83 7a 10 02          	cmpl   $0x2,0x10(%edx)
80103dc2:	75 ec                	jne    80103db0 <exitStatus+0x80>
80103dc4:	3b 42 24             	cmp    0x24(%edx),%eax
80103dc7:	75 e7                	jne    80103db0 <exitStatus+0x80>
      p->state = RUNNABLE;
80103dc9:	c7 42 10 03 00 00 00 	movl   $0x3,0x10(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dd0:	81 c2 90 00 00 00    	add    $0x90,%edx
80103dd6:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
80103ddc:	75 e0                	jne    80103dbe <exitStatus+0x8e>
      p->parent = initproc;
80103dde:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103de3:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103de8:	eb 14                	jmp    80103dfe <exitStatus+0xce>
80103dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103df0:	81 c1 90 00 00 00    	add    $0x90,%ecx
80103df6:	81 f9 54 51 11 80    	cmp    $0x80115154,%ecx
80103dfc:	74 3c                	je     80103e3a <exitStatus+0x10a>
    if (p->parent == curproc)
80103dfe:	39 59 18             	cmp    %ebx,0x18(%ecx)
80103e01:	75 ed                	jne    80103df0 <exitStatus+0xc0>
      if (p->state == ZOMBIE)
80103e03:	83 79 10 05          	cmpl   $0x5,0x10(%ecx)
      p->parent = initproc;
80103e07:	89 41 18             	mov    %eax,0x18(%ecx)
      if (p->state == ZOMBIE)
80103e0a:	75 e4                	jne    80103df0 <exitStatus+0xc0>
80103e0c:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103e11:	eb 13                	jmp    80103e26 <exitStatus+0xf6>
80103e13:	90                   	nop
80103e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e18:	81 c2 90 00 00 00    	add    $0x90,%edx
80103e1e:	81 fa 54 51 11 80    	cmp    $0x80115154,%edx
80103e24:	74 ca                	je     80103df0 <exitStatus+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103e26:	83 7a 10 02          	cmpl   $0x2,0x10(%edx)
80103e2a:	75 ec                	jne    80103e18 <exitStatus+0xe8>
80103e2c:	3b 42 24             	cmp    0x24(%edx),%eax
80103e2f:	75 e7                	jne    80103e18 <exitStatus+0xe8>
      p->state = RUNNABLE;
80103e31:	c7 42 10 03 00 00 00 	movl   $0x3,0x10(%edx)
80103e38:	eb de                	jmp    80103e18 <exitStatus+0xe8>
  curproc->turnTime = ticks - curproc->turnTime; //cs153_lab2: compute process' turn time (T_finish - T_start)
80103e3a:	a1 a0 59 11 80       	mov    0x801159a0,%eax
80103e3f:	2b 83 88 00 00 00    	sub    0x88(%ebx),%eax
80103e45:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
  curproc->waitTime = curproc->turnTime - curproc->burstTime; //cs153_lab2: compute process' wait time (turn around time - burst time)
80103e4b:	2b 83 8c 00 00 00    	sub    0x8c(%ebx),%eax
80103e51:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  cprintf("PID: %d has exited.\n", curproc->pid);
80103e57:	8b 43 14             	mov    0x14(%ebx),%eax
80103e5a:	c7 04 24 89 78 10 80 	movl   $0x80107889,(%esp)
80103e61:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e65:	e8 e6 c7 ff ff       	call   80100650 <cprintf>
  cprintf("Turn time: %d\n", curproc->turnTime); //cs153_lab2: print turn time
80103e6a:	8b 83 88 00 00 00    	mov    0x88(%ebx),%eax
80103e70:	c7 04 24 9e 78 10 80 	movl   $0x8010789e,(%esp)
80103e77:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e7b:	e8 d0 c7 ff ff       	call   80100650 <cprintf>
  cprintf("Wait time: %d\n", curproc->waitTime); //cs153_lab2: print wait time
80103e80:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80103e86:	c7 04 24 ad 78 10 80 	movl   $0x801078ad,(%esp)
80103e8d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e91:	e8 ba c7 ff ff       	call   80100650 <cprintf>
  curproc->state = ZOMBIE;
80103e96:	c7 43 10 05 00 00 00 	movl   $0x5,0x10(%ebx)
  sched();
80103e9d:	e8 be fc ff ff       	call   80103b60 <sched>
  panic("zombie exit");
80103ea2:	c7 04 24 7d 78 10 80 	movl   $0x8010787d,(%esp)
80103ea9:	e8 b2 c4 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103eae:	c7 04 24 70 78 10 80 	movl   $0x80107870,(%esp)
80103eb5:	e8 a6 c4 ff ff       	call   80100360 <panic>
80103eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ec0 <yield>:
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103ec6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ecd:	e8 3e 08 00 00       	call   80104710 <acquire>
  myproc()->state = RUNNABLE;
80103ed2:	e8 09 f8 ff ff       	call   801036e0 <myproc>
80103ed7:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  sched();
80103ede:	e8 7d fc ff ff       	call   80103b60 <sched>
  release(&ptable.lock);
80103ee3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103eea:	e8 91 08 00 00       	call   80104780 <release>
}
80103eef:	c9                   	leave  
80103ef0:	c3                   	ret    
80103ef1:	eb 0d                	jmp    80103f00 <setPrior>
80103ef3:	90                   	nop
80103ef4:	90                   	nop
80103ef5:	90                   	nop
80103ef6:	90                   	nop
80103ef7:	90                   	nop
80103ef8:	90                   	nop
80103ef9:	90                   	nop
80103efa:	90                   	nop
80103efb:	90                   	nop
80103efc:	90                   	nop
80103efd:	90                   	nop
80103efe:	90                   	nop
80103eff:	90                   	nop

80103f00 <setPrior>:
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	53                   	push   %ebx
80103f04:	83 ec 04             	sub    $0x4,%esp
80103f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
    myproc()->prior_val = prior_val;
80103f0a:	e8 d1 f7 ff ff       	call   801036e0 <myproc>
80103f0f:	89 98 80 00 00 00    	mov    %ebx,0x80(%eax)
}
80103f15:	83 c4 04             	add    $0x4,%esp
80103f18:	5b                   	pop    %ebx
80103f19:	5d                   	pop    %ebp
    yield(); //give up CPU once priority value changes
80103f1a:	eb a4                	jmp    80103ec0 <yield>
80103f1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103f20 <sleep>:
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	57                   	push   %edi
80103f24:	56                   	push   %esi
80103f25:	53                   	push   %ebx
80103f26:	83 ec 1c             	sub    $0x1c,%esp
80103f29:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f2c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103f2f:	e8 ac f7 ff ff       	call   801036e0 <myproc>
  if(p == 0)
80103f34:	85 c0                	test   %eax,%eax
  struct proc *p = myproc();
80103f36:	89 c3                	mov    %eax,%ebx
  if(p == 0)
80103f38:	0f 84 7c 00 00 00    	je     80103fba <sleep+0x9a>
  if(lk == 0)
80103f3e:	85 f6                	test   %esi,%esi
80103f40:	74 6c                	je     80103fae <sleep+0x8e>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103f42:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103f48:	74 46                	je     80103f90 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103f4a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f51:	e8 ba 07 00 00       	call   80104710 <acquire>
    release(lk);
80103f56:	89 34 24             	mov    %esi,(%esp)
80103f59:	e8 22 08 00 00       	call   80104780 <release>
  p->chan = chan;
80103f5e:	89 7b 24             	mov    %edi,0x24(%ebx)
  p->state = SLEEPING;
80103f61:	c7 43 10 02 00 00 00 	movl   $0x2,0x10(%ebx)
  sched();
80103f68:	e8 f3 fb ff ff       	call   80103b60 <sched>
  p->chan = 0;
80103f6d:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
    release(&ptable.lock);
80103f74:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f7b:	e8 00 08 00 00       	call   80104780 <release>
    acquire(lk);
80103f80:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103f83:	83 c4 1c             	add    $0x1c,%esp
80103f86:	5b                   	pop    %ebx
80103f87:	5e                   	pop    %esi
80103f88:	5f                   	pop    %edi
80103f89:	5d                   	pop    %ebp
    acquire(lk);
80103f8a:	e9 81 07 00 00       	jmp    80104710 <acquire>
80103f8f:	90                   	nop
  p->chan = chan;
80103f90:	89 78 24             	mov    %edi,0x24(%eax)
  p->state = SLEEPING;
80103f93:	c7 40 10 02 00 00 00 	movl   $0x2,0x10(%eax)
  sched();
80103f9a:	e8 c1 fb ff ff       	call   80103b60 <sched>
  p->chan = 0;
80103f9f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
}
80103fa6:	83 c4 1c             	add    $0x1c,%esp
80103fa9:	5b                   	pop    %ebx
80103faa:	5e                   	pop    %esi
80103fab:	5f                   	pop    %edi
80103fac:	5d                   	pop    %ebp
80103fad:	c3                   	ret    
    panic("sleep without lk");
80103fae:	c7 04 24 c2 78 10 80 	movl   $0x801078c2,(%esp)
80103fb5:	e8 a6 c3 ff ff       	call   80100360 <panic>
    panic("sleep");
80103fba:	c7 04 24 bc 78 10 80 	movl   $0x801078bc,(%esp)
80103fc1:	e8 9a c3 ff ff       	call   80100360 <panic>
80103fc6:	8d 76 00             	lea    0x0(%esi),%esi
80103fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fd0 <wait>:
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	56                   	push   %esi
80103fd4:	53                   	push   %ebx
80103fd5:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103fd8:	e8 03 f7 ff ff       	call   801036e0 <myproc>
  acquire(&ptable.lock);
80103fdd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *curproc = myproc();
80103fe4:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103fe6:	e8 25 07 00 00       	call   80104710 <acquire>
    havekids = 0;
80103feb:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fed:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103ff2:	eb 12                	jmp    80104006 <wait+0x36>
80103ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ff8:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103ffe:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
80104004:	74 22                	je     80104028 <wait+0x58>
      if(p->parent != curproc)
80104006:	39 73 18             	cmp    %esi,0x18(%ebx)
80104009:	75 ed                	jne    80103ff8 <wait+0x28>
      if(p->state == ZOMBIE){
8010400b:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
8010400f:	74 34                	je     80104045 <wait+0x75>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104011:	81 c3 90 00 00 00    	add    $0x90,%ebx
      havekids = 1;
80104017:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010401c:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
80104022:	75 e2                	jne    80104006 <wait+0x36>
80104024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(!havekids || curproc->killed){
80104028:	85 c0                	test   %eax,%eax
8010402a:	74 6e                	je     8010409a <wait+0xca>
8010402c:	8b 46 28             	mov    0x28(%esi),%eax
8010402f:	85 c0                	test   %eax,%eax
80104031:	75 67                	jne    8010409a <wait+0xca>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104033:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
8010403a:	80 
8010403b:	89 34 24             	mov    %esi,(%esp)
8010403e:	e8 dd fe ff ff       	call   80103f20 <sleep>
  }
80104043:	eb a6                	jmp    80103feb <wait+0x1b>
        kfree(p->kstack);
80104045:	8b 43 0c             	mov    0xc(%ebx),%eax
        pid = p->pid;
80104048:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
8010404b:	89 04 24             	mov    %eax,(%esp)
8010404e:	e8 ad e2 ff ff       	call   80102300 <kfree>
        freevm(p->pgdir);
80104053:	8b 43 08             	mov    0x8(%ebx),%eax
        p->kstack = 0;
80104056:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
8010405d:	89 04 24             	mov    %eax,(%esp)
80104060:	e8 0b 2f 00 00       	call   80106f70 <freevm>
        release(&ptable.lock);
80104065:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
8010406c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
80104073:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
8010407a:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
8010407e:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
80104085:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        release(&ptable.lock);
8010408c:	e8 ef 06 00 00       	call   80104780 <release>
}
80104091:	83 c4 10             	add    $0x10,%esp
        return pid;
80104094:	89 f0                	mov    %esi,%eax
}
80104096:	5b                   	pop    %ebx
80104097:	5e                   	pop    %esi
80104098:	5d                   	pop    %ebp
80104099:	c3                   	ret    
      release(&ptable.lock);
8010409a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801040a1:	e8 da 06 00 00       	call   80104780 <release>
}
801040a6:	83 c4 10             	add    $0x10,%esp
      return -1;
801040a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801040ae:	5b                   	pop    %ebx
801040af:	5e                   	pop    %esi
801040b0:	5d                   	pop    %ebp
801040b1:	c3                   	ret    
801040b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040c0 <waitStatus>:
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	57                   	push   %edi
801040c4:	56                   	push   %esi
801040c5:	53                   	push   %ebx
801040c6:	83 ec 1c             	sub    $0x1c,%esp
801040c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct proc *curproc = myproc();
801040cc:	e8 0f f6 ff ff       	call   801036e0 <myproc>
  acquire(&ptable.lock);
801040d1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *curproc = myproc();
801040d8:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
801040da:	e8 31 06 00 00       	call   80104710 <acquire>
    havekids = 0;
801040df:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040e1:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801040e6:	eb 0e                	jmp    801040f6 <waitStatus+0x36>
801040e8:	81 c3 90 00 00 00    	add    $0x90,%ebx
801040ee:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
801040f4:	74 22                	je     80104118 <waitStatus+0x58>
      if(p->parent != curproc)
801040f6:	39 73 18             	cmp    %esi,0x18(%ebx)
801040f9:	75 ed                	jne    801040e8 <waitStatus+0x28>
      if(p->state == ZOMBIE) //Found one
801040fb:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
801040ff:	74 34                	je     80104135 <waitStatus+0x75>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104101:	81 c3 90 00 00 00    	add    $0x90,%ebx
      havekids = 1;
80104107:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010410c:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
80104112:	75 e2                	jne    801040f6 <waitStatus+0x36>
80104114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(!havekids || curproc->killed)
80104118:	85 c0                	test   %eax,%eax
8010411a:	74 77                	je     80104193 <waitStatus+0xd3>
8010411c:	8b 46 28             	mov    0x28(%esi),%eax
8010411f:	85 c0                	test   %eax,%eax
80104121:	75 70                	jne    80104193 <waitStatus+0xd3>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104123:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
8010412a:	80 
8010412b:	89 34 24             	mov    %esi,(%esp)
8010412e:	e8 ed fd ff ff       	call   80103f20 <sleep>
  }
80104133:	eb aa                	jmp    801040df <waitStatus+0x1f>
        kfree(p->kstack);
80104135:	8b 43 0c             	mov    0xc(%ebx),%eax
        pid = p->pid;
80104138:	8b 73 14             	mov    0x14(%ebx),%esi
        kfree(p->kstack);
8010413b:	89 04 24             	mov    %eax,(%esp)
8010413e:	e8 bd e1 ff ff       	call   80102300 <kfree>
        freevm(p->pgdir);
80104143:	8b 43 08             	mov    0x8(%ebx),%eax
        p->kstack = 0;
80104146:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
8010414d:	89 04 24             	mov    %eax,(%esp)
80104150:	e8 1b 2e 00 00       	call   80106f70 <freevm>
        if (status != 0)
80104155:	85 ff                	test   %edi,%edi
        p->pid = 0;
80104157:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
8010415e:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
80104165:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        p->killed = 0;
80104169:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
80104170:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        if (status != 0)
80104177:	74 04                	je     8010417d <waitStatus+0xbd>
          *status = p->exitStatus; //cs153_lab1: return the terminated child exit status through the status argument
80104179:	8b 03                	mov    (%ebx),%eax
8010417b:	89 07                	mov    %eax,(%edi)
        release(&ptable.lock);
8010417d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104184:	e8 f7 05 00 00       	call   80104780 <release>
}
80104189:	83 c4 1c             	add    $0x1c,%esp
        return pid;
8010418c:	89 f0                	mov    %esi,%eax
}
8010418e:	5b                   	pop    %ebx
8010418f:	5e                   	pop    %esi
80104190:	5f                   	pop    %edi
80104191:	5d                   	pop    %ebp
80104192:	c3                   	ret    
      release(&ptable.lock);
80104193:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010419a:	e8 e1 05 00 00       	call   80104780 <release>
}
8010419f:	83 c4 1c             	add    $0x1c,%esp
      return -1;
801041a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041a7:	5b                   	pop    %ebx
801041a8:	5e                   	pop    %esi
801041a9:	5f                   	pop    %edi
801041aa:	5d                   	pop    %ebp
801041ab:	c3                   	ret    
801041ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801041b0 <waitpid>:
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	57                   	push   %edi
801041b4:	56                   	push   %esi
801041b5:	53                   	push   %ebx
801041b6:	83 ec 1c             	sub    $0x1c,%esp
801041b9:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc* curproc = myproc();
801041bc:	e8 1f f5 ff ff       	call   801036e0 <myproc>
  acquire(&ptable.lock);
801041c1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc* curproc = myproc();
801041c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  acquire(&ptable.lock);
801041cb:	e8 40 05 00 00       	call   80104710 <acquire>
    processExists = 0;
801041d0:	31 c9                	xor    %ecx,%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041d2:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801041d7:	eb 15                	jmp    801041ee <waitpid+0x3e>
801041d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041e0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801041e6:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
801041ec:	74 20                	je     8010420e <waitpid+0x5e>
      if (p->pid != pid)
801041ee:	8b 7b 14             	mov    0x14(%ebx),%edi
801041f1:	39 f7                	cmp    %esi,%edi
801041f3:	75 eb                	jne    801041e0 <waitpid+0x30>
      if (p->state == ZOMBIE) //process exited
801041f5:	83 7b 10 05          	cmpl   $0x5,0x10(%ebx)
801041f9:	74 3d                	je     80104238 <waitpid+0x88>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041fb:	81 c3 90 00 00 00    	add    $0x90,%ebx
      processExists = 1;
80104201:	b9 01 00 00 00       	mov    $0x1,%ecx
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104206:	81 fb 54 51 11 80    	cmp    $0x80115154,%ebx
8010420c:	75 e0                	jne    801041ee <waitpid+0x3e>
    if (!processExists || curproc->killed)
8010420e:	85 c9                	test   %ecx,%ecx
80104210:	0f 84 83 00 00 00    	je     80104299 <waitpid+0xe9>
80104216:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104219:	8b 40 28             	mov    0x28(%eax),%eax
8010421c:	85 c0                	test   %eax,%eax
8010421e:	75 79                	jne    80104299 <waitpid+0xe9>
    sleep(curproc, &ptable.lock); //DOC: wait-sleep
80104220:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104223:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
8010422a:	80 
8010422b:	89 04 24             	mov    %eax,(%esp)
8010422e:	e8 ed fc ff ff       	call   80103f20 <sleep>
  }
80104233:	eb 9b                	jmp    801041d0 <waitpid+0x20>
80104235:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104238:	8b 53 0c             	mov    0xc(%ebx),%edx
8010423b:	89 14 24             	mov    %edx,(%esp)
8010423e:	e8 bd e0 ff ff       	call   80102300 <kfree>
        freevm(p->pgdir);
80104243:	8b 53 08             	mov    0x8(%ebx),%edx
        p->kstack = 0;
80104246:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        freevm(p->pgdir);
8010424d:	89 14 24             	mov    %edx,(%esp)
80104250:	e8 1b 2d 00 00       	call   80106f70 <freevm>
        if (status != 0)
80104255:	8b 55 0c             	mov    0xc(%ebp),%edx
        p->pid = 0;
80104258:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->parent = 0;
8010425f:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->name[0] = 0;
80104266:	c6 43 70 00          	movb   $0x0,0x70(%ebx)
        if (status != 0)
8010426a:	85 d2                	test   %edx,%edx
        p->killed = 0;
8010426c:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
        p->state = UNUSED;
80104273:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        if (status != 0)
8010427a:	74 07                	je     80104283 <waitpid+0xd3>
          *status = p->exitStatus;
8010427c:	8b 13                	mov    (%ebx),%edx
8010427e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104281:	89 10                	mov    %edx,(%eax)
        release(&ptable.lock);
80104283:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010428a:	e8 f1 04 00 00       	call   80104780 <release>
}
8010428f:	83 c4 1c             	add    $0x1c,%esp
80104292:	89 f8                	mov    %edi,%eax
80104294:	5b                   	pop    %ebx
80104295:	5e                   	pop    %esi
80104296:	5f                   	pop    %edi
80104297:	5d                   	pop    %ebp
80104298:	c3                   	ret    
      release(&ptable.lock);
80104299:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
      return -1;
801042a0:	bf ff ff ff ff       	mov    $0xffffffff,%edi
      release(&ptable.lock);
801042a5:	e8 d6 04 00 00       	call   80104780 <release>
      return -1;
801042aa:	eb e3                	jmp    8010428f <waitpid+0xdf>
801042ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	53                   	push   %ebx
801042b4:	83 ec 14             	sub    $0x14,%esp
801042b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801042ba:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801042c1:	e8 4a 04 00 00       	call   80104710 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042c6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801042cb:	eb 0f                	jmp    801042dc <wakeup+0x2c>
801042cd:	8d 76 00             	lea    0x0(%esi),%esi
801042d0:	05 90 00 00 00       	add    $0x90,%eax
801042d5:	3d 54 51 11 80       	cmp    $0x80115154,%eax
801042da:	74 24                	je     80104300 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
801042dc:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801042e0:	75 ee                	jne    801042d0 <wakeup+0x20>
801042e2:	3b 58 24             	cmp    0x24(%eax),%ebx
801042e5:	75 e9                	jne    801042d0 <wakeup+0x20>
      p->state = RUNNABLE;
801042e7:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042ee:	05 90 00 00 00       	add    $0x90,%eax
801042f3:	3d 54 51 11 80       	cmp    $0x80115154,%eax
801042f8:	75 e2                	jne    801042dc <wakeup+0x2c>
801042fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  wakeup1(chan);
  release(&ptable.lock);
80104300:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104307:	83 c4 14             	add    $0x14,%esp
8010430a:	5b                   	pop    %ebx
8010430b:	5d                   	pop    %ebp
  release(&ptable.lock);
8010430c:	e9 6f 04 00 00       	jmp    80104780 <release>
80104311:	eb 0d                	jmp    80104320 <kill>
80104313:	90                   	nop
80104314:	90                   	nop
80104315:	90                   	nop
80104316:	90                   	nop
80104317:	90                   	nop
80104318:	90                   	nop
80104319:	90                   	nop
8010431a:	90                   	nop
8010431b:	90                   	nop
8010431c:	90                   	nop
8010431d:	90                   	nop
8010431e:	90                   	nop
8010431f:	90                   	nop

80104320 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	53                   	push   %ebx
80104324:	83 ec 14             	sub    $0x14,%esp
80104327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010432a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104331:	e8 da 03 00 00       	call   80104710 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104336:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010433b:	eb 0f                	jmp    8010434c <kill+0x2c>
8010433d:	8d 76 00             	lea    0x0(%esi),%esi
80104340:	05 90 00 00 00       	add    $0x90,%eax
80104345:	3d 54 51 11 80       	cmp    $0x80115154,%eax
8010434a:	74 3c                	je     80104388 <kill+0x68>
    if(p->pid == pid){
8010434c:	39 58 14             	cmp    %ebx,0x14(%eax)
8010434f:	75 ef                	jne    80104340 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104351:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
      p->killed = 1;
80104355:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
      if(p->state == SLEEPING)
8010435c:	74 1a                	je     80104378 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010435e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104365:	e8 16 04 00 00       	call   80104780 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
8010436a:	83 c4 14             	add    $0x14,%esp
      return 0;
8010436d:	31 c0                	xor    %eax,%eax
}
8010436f:	5b                   	pop    %ebx
80104370:	5d                   	pop    %ebp
80104371:	c3                   	ret    
80104372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        p->state = RUNNABLE;
80104378:	c7 40 10 03 00 00 00 	movl   $0x3,0x10(%eax)
8010437f:	eb dd                	jmp    8010435e <kill+0x3e>
80104381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104388:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010438f:	e8 ec 03 00 00       	call   80104780 <release>
}
80104394:	83 c4 14             	add    $0x14,%esp
  return -1;
80104397:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010439c:	5b                   	pop    %ebx
8010439d:	5d                   	pop    %ebp
8010439e:	c3                   	ret    
8010439f:	90                   	nop

801043a0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	57                   	push   %edi
801043a4:	56                   	push   %esi
801043a5:	53                   	push   %ebx
801043a6:	bb c4 2d 11 80       	mov    $0x80112dc4,%ebx
801043ab:	83 ec 4c             	sub    $0x4c,%esp
801043ae:	8d 75 e8             	lea    -0x18(%ebp),%esi
801043b1:	eb 23                	jmp    801043d6 <procdump+0x36>
801043b3:	90                   	nop
801043b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801043b8:	c7 04 24 77 7c 10 80 	movl   $0x80107c77,(%esp)
801043bf:	e8 8c c2 ff ff       	call   80100650 <cprintf>
801043c4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043ca:	81 fb c4 51 11 80    	cmp    $0x801151c4,%ebx
801043d0:	0f 84 8a 00 00 00    	je     80104460 <procdump+0xc0>
    if(p->state == UNUSED)
801043d6:	8b 43 a0             	mov    -0x60(%ebx),%eax
801043d9:	85 c0                	test   %eax,%eax
801043db:	74 e7                	je     801043c4 <procdump+0x24>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801043dd:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801043e0:	ba d3 78 10 80       	mov    $0x801078d3,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801043e5:	77 11                	ja     801043f8 <procdump+0x58>
801043e7:	8b 14 85 34 79 10 80 	mov    -0x7fef86cc(,%eax,4),%edx
      state = "???";
801043ee:	b8 d3 78 10 80       	mov    $0x801078d3,%eax
801043f3:	85 d2                	test   %edx,%edx
801043f5:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801043f8:	8b 43 a4             	mov    -0x5c(%ebx),%eax
801043fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801043ff:	89 54 24 08          	mov    %edx,0x8(%esp)
80104403:	c7 04 24 d7 78 10 80 	movl   $0x801078d7,(%esp)
8010440a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010440e:	e8 3d c2 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80104413:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104417:	75 9f                	jne    801043b8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104419:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010441c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104420:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104423:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104426:	8b 40 0c             	mov    0xc(%eax),%eax
80104429:	83 c0 08             	add    $0x8,%eax
8010442c:	89 04 24             	mov    %eax,(%esp)
8010442f:	e8 8c 01 00 00       	call   801045c0 <getcallerpcs>
80104434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104438:	8b 17                	mov    (%edi),%edx
8010443a:	85 d2                	test   %edx,%edx
8010443c:	0f 84 76 ff ff ff    	je     801043b8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104442:	89 54 24 04          	mov    %edx,0x4(%esp)
80104446:	83 c7 04             	add    $0x4,%edi
80104449:	c7 04 24 e1 72 10 80 	movl   $0x801072e1,(%esp)
80104450:	e8 fb c1 ff ff       	call   80100650 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104455:	39 f7                	cmp    %esi,%edi
80104457:	75 df                	jne    80104438 <procdump+0x98>
80104459:	e9 5a ff ff ff       	jmp    801043b8 <procdump+0x18>
8010445e:	66 90                	xchg   %ax,%ax
  }
}
80104460:	83 c4 4c             	add    $0x4c,%esp
80104463:	5b                   	pop    %ebx
80104464:	5e                   	pop    %esi
80104465:	5f                   	pop    %edi
80104466:	5d                   	pop    %ebp
80104467:	c3                   	ret    
80104468:	66 90                	xchg   %ax,%ax
8010446a:	66 90                	xchg   %ax,%ax
8010446c:	66 90                	xchg   %ax,%ax
8010446e:	66 90                	xchg   %ax,%ax

80104470 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	53                   	push   %ebx
80104474:	83 ec 14             	sub    $0x14,%esp
80104477:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010447a:	c7 44 24 04 4c 79 10 	movl   $0x8010794c,0x4(%esp)
80104481:	80 
80104482:	8d 43 04             	lea    0x4(%ebx),%eax
80104485:	89 04 24             	mov    %eax,(%esp)
80104488:	e8 13 01 00 00       	call   801045a0 <initlock>
  lk->name = name;
8010448d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104490:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104496:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010449d:	89 43 38             	mov    %eax,0x38(%ebx)
}
801044a0:	83 c4 14             	add    $0x14,%esp
801044a3:	5b                   	pop    %ebx
801044a4:	5d                   	pop    %ebp
801044a5:	c3                   	ret    
801044a6:	8d 76 00             	lea    0x0(%esi),%esi
801044a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044b0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	56                   	push   %esi
801044b4:	53                   	push   %ebx
801044b5:	83 ec 10             	sub    $0x10,%esp
801044b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044bb:	8d 73 04             	lea    0x4(%ebx),%esi
801044be:	89 34 24             	mov    %esi,(%esp)
801044c1:	e8 4a 02 00 00       	call   80104710 <acquire>
  while (lk->locked) {
801044c6:	8b 13                	mov    (%ebx),%edx
801044c8:	85 d2                	test   %edx,%edx
801044ca:	74 16                	je     801044e2 <acquiresleep+0x32>
801044cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
801044d0:	89 74 24 04          	mov    %esi,0x4(%esp)
801044d4:	89 1c 24             	mov    %ebx,(%esp)
801044d7:	e8 44 fa ff ff       	call   80103f20 <sleep>
  while (lk->locked) {
801044dc:	8b 03                	mov    (%ebx),%eax
801044de:	85 c0                	test   %eax,%eax
801044e0:	75 ee                	jne    801044d0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801044e2:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801044e8:	e8 f3 f1 ff ff       	call   801036e0 <myproc>
801044ed:	8b 40 14             	mov    0x14(%eax),%eax
801044f0:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801044f3:	89 75 08             	mov    %esi,0x8(%ebp)
}
801044f6:	83 c4 10             	add    $0x10,%esp
801044f9:	5b                   	pop    %ebx
801044fa:	5e                   	pop    %esi
801044fb:	5d                   	pop    %ebp
  release(&lk->lk);
801044fc:	e9 7f 02 00 00       	jmp    80104780 <release>
80104501:	eb 0d                	jmp    80104510 <releasesleep>
80104503:	90                   	nop
80104504:	90                   	nop
80104505:	90                   	nop
80104506:	90                   	nop
80104507:	90                   	nop
80104508:	90                   	nop
80104509:	90                   	nop
8010450a:	90                   	nop
8010450b:	90                   	nop
8010450c:	90                   	nop
8010450d:	90                   	nop
8010450e:	90                   	nop
8010450f:	90                   	nop

80104510 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	56                   	push   %esi
80104514:	53                   	push   %ebx
80104515:	83 ec 10             	sub    $0x10,%esp
80104518:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010451b:	8d 73 04             	lea    0x4(%ebx),%esi
8010451e:	89 34 24             	mov    %esi,(%esp)
80104521:	e8 ea 01 00 00       	call   80104710 <acquire>
  lk->locked = 0;
80104526:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010452c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104533:	89 1c 24             	mov    %ebx,(%esp)
80104536:	e8 75 fd ff ff       	call   801042b0 <wakeup>
  release(&lk->lk);
8010453b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010453e:	83 c4 10             	add    $0x10,%esp
80104541:	5b                   	pop    %ebx
80104542:	5e                   	pop    %esi
80104543:	5d                   	pop    %ebp
  release(&lk->lk);
80104544:	e9 37 02 00 00       	jmp    80104780 <release>
80104549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104550 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	57                   	push   %edi
  int r;
  
  acquire(&lk->lk);
  r = lk->locked && (lk->pid == myproc()->pid);
80104554:	31 ff                	xor    %edi,%edi
{
80104556:	56                   	push   %esi
80104557:	53                   	push   %ebx
80104558:	83 ec 1c             	sub    $0x1c,%esp
8010455b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010455e:	8d 73 04             	lea    0x4(%ebx),%esi
80104561:	89 34 24             	mov    %esi,(%esp)
80104564:	e8 a7 01 00 00       	call   80104710 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104569:	8b 03                	mov    (%ebx),%eax
8010456b:	85 c0                	test   %eax,%eax
8010456d:	74 13                	je     80104582 <holdingsleep+0x32>
8010456f:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104572:	e8 69 f1 ff ff       	call   801036e0 <myproc>
80104577:	3b 58 14             	cmp    0x14(%eax),%ebx
8010457a:	0f 94 c0             	sete   %al
8010457d:	0f b6 c0             	movzbl %al,%eax
80104580:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104582:	89 34 24             	mov    %esi,(%esp)
80104585:	e8 f6 01 00 00       	call   80104780 <release>
  return r;
}
8010458a:	83 c4 1c             	add    $0x1c,%esp
8010458d:	89 f8                	mov    %edi,%eax
8010458f:	5b                   	pop    %ebx
80104590:	5e                   	pop    %esi
80104591:	5f                   	pop    %edi
80104592:	5d                   	pop    %ebp
80104593:	c3                   	ret    
80104594:	66 90                	xchg   %ax,%ax
80104596:	66 90                	xchg   %ax,%ax
80104598:	66 90                	xchg   %ax,%ax
8010459a:	66 90                	xchg   %ax,%ax
8010459c:	66 90                	xchg   %ax,%ax
8010459e:	66 90                	xchg   %ax,%ax

801045a0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801045a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801045a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
801045af:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801045b2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801045b9:	5d                   	pop    %ebp
801045ba:	c3                   	ret    
801045bb:	90                   	nop
801045bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045c0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801045c3:	8b 45 08             	mov    0x8(%ebp),%eax
{
801045c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801045c9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
801045ca:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801045cd:	31 c0                	xor    %eax,%eax
801045cf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045d0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801045d6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801045dc:	77 1a                	ja     801045f8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801045de:	8b 5a 04             	mov    0x4(%edx),%ebx
801045e1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801045e4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801045e7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801045e9:	83 f8 0a             	cmp    $0xa,%eax
801045ec:	75 e2                	jne    801045d0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801045ee:	5b                   	pop    %ebx
801045ef:	5d                   	pop    %ebp
801045f0:	c3                   	ret    
801045f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
801045f8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801045ff:	83 c0 01             	add    $0x1,%eax
80104602:	83 f8 0a             	cmp    $0xa,%eax
80104605:	74 e7                	je     801045ee <getcallerpcs+0x2e>
    pcs[i] = 0;
80104607:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
8010460e:	83 c0 01             	add    $0x1,%eax
80104611:	83 f8 0a             	cmp    $0xa,%eax
80104614:	75 e2                	jne    801045f8 <getcallerpcs+0x38>
80104616:	eb d6                	jmp    801045ee <getcallerpcs+0x2e>
80104618:	90                   	nop
80104619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104620 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	53                   	push   %ebx
80104624:	83 ec 04             	sub    $0x4,%esp
80104627:	9c                   	pushf  
80104628:	5b                   	pop    %ebx
  asm volatile("cli");
80104629:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010462a:	e8 11 f0 ff ff       	call   80103640 <mycpu>
8010462f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104635:	85 c0                	test   %eax,%eax
80104637:	75 11                	jne    8010464a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104639:	e8 02 f0 ff ff       	call   80103640 <mycpu>
8010463e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104644:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010464a:	e8 f1 ef ff ff       	call   80103640 <mycpu>
8010464f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104656:	83 c4 04             	add    $0x4,%esp
80104659:	5b                   	pop    %ebx
8010465a:	5d                   	pop    %ebp
8010465b:	c3                   	ret    
8010465c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104660 <popcli>:

void
popcli(void)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104666:	9c                   	pushf  
80104667:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104668:	f6 c4 02             	test   $0x2,%ah
8010466b:	75 49                	jne    801046b6 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010466d:	e8 ce ef ff ff       	call   80103640 <mycpu>
80104672:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104678:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010467b:	85 d2                	test   %edx,%edx
8010467d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104683:	78 25                	js     801046aa <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104685:	e8 b6 ef ff ff       	call   80103640 <mycpu>
8010468a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104690:	85 d2                	test   %edx,%edx
80104692:	74 04                	je     80104698 <popcli+0x38>
    sti();
}
80104694:	c9                   	leave  
80104695:	c3                   	ret    
80104696:	66 90                	xchg   %ax,%ax
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104698:	e8 a3 ef ff ff       	call   80103640 <mycpu>
8010469d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801046a3:	85 c0                	test   %eax,%eax
801046a5:	74 ed                	je     80104694 <popcli+0x34>
  asm volatile("sti");
801046a7:	fb                   	sti    
}
801046a8:	c9                   	leave  
801046a9:	c3                   	ret    
    panic("popcli");
801046aa:	c7 04 24 6e 79 10 80 	movl   $0x8010796e,(%esp)
801046b1:	e8 aa bc ff ff       	call   80100360 <panic>
    panic("popcli - interruptible");
801046b6:	c7 04 24 57 79 10 80 	movl   $0x80107957,(%esp)
801046bd:	e8 9e bc ff ff       	call   80100360 <panic>
801046c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046d0 <holding>:
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	56                   	push   %esi
  r = lock->locked && lock->cpu == mycpu();
801046d4:	31 f6                	xor    %esi,%esi
{
801046d6:	53                   	push   %ebx
801046d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801046da:	e8 41 ff ff ff       	call   80104620 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046df:	8b 03                	mov    (%ebx),%eax
801046e1:	85 c0                	test   %eax,%eax
801046e3:	74 12                	je     801046f7 <holding+0x27>
801046e5:	8b 5b 08             	mov    0x8(%ebx),%ebx
801046e8:	e8 53 ef ff ff       	call   80103640 <mycpu>
801046ed:	39 c3                	cmp    %eax,%ebx
801046ef:	0f 94 c0             	sete   %al
801046f2:	0f b6 c0             	movzbl %al,%eax
801046f5:	89 c6                	mov    %eax,%esi
  popcli();
801046f7:	e8 64 ff ff ff       	call   80104660 <popcli>
}
801046fc:	89 f0                	mov    %esi,%eax
801046fe:	5b                   	pop    %ebx
801046ff:	5e                   	pop    %esi
80104700:	5d                   	pop    %ebp
80104701:	c3                   	ret    
80104702:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104710 <acquire>:
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	53                   	push   %ebx
80104714:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104717:	e8 04 ff ff ff       	call   80104620 <pushcli>
  if(holding(lk))
8010471c:	8b 45 08             	mov    0x8(%ebp),%eax
8010471f:	89 04 24             	mov    %eax,(%esp)
80104722:	e8 a9 ff ff ff       	call   801046d0 <holding>
80104727:	85 c0                	test   %eax,%eax
80104729:	75 3a                	jne    80104765 <acquire+0x55>
  asm volatile("lock; xchgl %0, %1" :
8010472b:	b9 01 00 00 00       	mov    $0x1,%ecx
  while(xchg(&lk->locked, 1) != 0)
80104730:	8b 55 08             	mov    0x8(%ebp),%edx
80104733:	89 c8                	mov    %ecx,%eax
80104735:	f0 87 02             	lock xchg %eax,(%edx)
80104738:	85 c0                	test   %eax,%eax
8010473a:	75 f4                	jne    80104730 <acquire+0x20>
  __sync_synchronize();
8010473c:	0f ae f0             	mfence 
  lk->cpu = mycpu();
8010473f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104742:	e8 f9 ee ff ff       	call   80103640 <mycpu>
80104747:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010474a:	8b 45 08             	mov    0x8(%ebp),%eax
8010474d:	83 c0 0c             	add    $0xc,%eax
80104750:	89 44 24 04          	mov    %eax,0x4(%esp)
80104754:	8d 45 08             	lea    0x8(%ebp),%eax
80104757:	89 04 24             	mov    %eax,(%esp)
8010475a:	e8 61 fe ff ff       	call   801045c0 <getcallerpcs>
}
8010475f:	83 c4 14             	add    $0x14,%esp
80104762:	5b                   	pop    %ebx
80104763:	5d                   	pop    %ebp
80104764:	c3                   	ret    
    panic("acquire");
80104765:	c7 04 24 75 79 10 80 	movl   $0x80107975,(%esp)
8010476c:	e8 ef bb ff ff       	call   80100360 <panic>
80104771:	eb 0d                	jmp    80104780 <release>
80104773:	90                   	nop
80104774:	90                   	nop
80104775:	90                   	nop
80104776:	90                   	nop
80104777:	90                   	nop
80104778:	90                   	nop
80104779:	90                   	nop
8010477a:	90                   	nop
8010477b:	90                   	nop
8010477c:	90                   	nop
8010477d:	90                   	nop
8010477e:	90                   	nop
8010477f:	90                   	nop

80104780 <release>:
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	53                   	push   %ebx
80104784:	83 ec 14             	sub    $0x14,%esp
80104787:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010478a:	89 1c 24             	mov    %ebx,(%esp)
8010478d:	e8 3e ff ff ff       	call   801046d0 <holding>
80104792:	85 c0                	test   %eax,%eax
80104794:	74 21                	je     801047b7 <release+0x37>
  lk->pcs[0] = 0;
80104796:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010479d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801047a4:	0f ae f0             	mfence 
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801047a7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801047ad:	83 c4 14             	add    $0x14,%esp
801047b0:	5b                   	pop    %ebx
801047b1:	5d                   	pop    %ebp
  popcli();
801047b2:	e9 a9 fe ff ff       	jmp    80104660 <popcli>
    panic("release");
801047b7:	c7 04 24 7d 79 10 80 	movl   $0x8010797d,(%esp)
801047be:	e8 9d bb ff ff       	call   80100360 <panic>
801047c3:	66 90                	xchg   %ax,%ax
801047c5:	66 90                	xchg   %ax,%ax
801047c7:	66 90                	xchg   %ax,%ax
801047c9:	66 90                	xchg   %ax,%ax
801047cb:	66 90                	xchg   %ax,%ax
801047cd:	66 90                	xchg   %ax,%ax
801047cf:	90                   	nop

801047d0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	8b 55 08             	mov    0x8(%ebp),%edx
801047d6:	57                   	push   %edi
801047d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801047da:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
801047db:	f6 c2 03             	test   $0x3,%dl
801047de:	75 05                	jne    801047e5 <memset+0x15>
801047e0:	f6 c1 03             	test   $0x3,%cl
801047e3:	74 13                	je     801047f8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801047e5:	89 d7                	mov    %edx,%edi
801047e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801047ea:	fc                   	cld    
801047eb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801047ed:	5b                   	pop    %ebx
801047ee:	89 d0                	mov    %edx,%eax
801047f0:	5f                   	pop    %edi
801047f1:	5d                   	pop    %ebp
801047f2:	c3                   	ret    
801047f3:	90                   	nop
801047f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801047f8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801047fc:	c1 e9 02             	shr    $0x2,%ecx
801047ff:	89 f8                	mov    %edi,%eax
80104801:	89 fb                	mov    %edi,%ebx
80104803:	c1 e0 18             	shl    $0x18,%eax
80104806:	c1 e3 10             	shl    $0x10,%ebx
80104809:	09 d8                	or     %ebx,%eax
8010480b:	09 f8                	or     %edi,%eax
8010480d:	c1 e7 08             	shl    $0x8,%edi
80104810:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104812:	89 d7                	mov    %edx,%edi
80104814:	fc                   	cld    
80104815:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104817:	5b                   	pop    %ebx
80104818:	89 d0                	mov    %edx,%eax
8010481a:	5f                   	pop    %edi
8010481b:	5d                   	pop    %ebp
8010481c:	c3                   	ret    
8010481d:	8d 76 00             	lea    0x0(%esi),%esi

80104820 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	8b 45 10             	mov    0x10(%ebp),%eax
80104826:	57                   	push   %edi
80104827:	56                   	push   %esi
80104828:	8b 75 0c             	mov    0xc(%ebp),%esi
8010482b:	53                   	push   %ebx
8010482c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010482f:	85 c0                	test   %eax,%eax
80104831:	8d 78 ff             	lea    -0x1(%eax),%edi
80104834:	74 26                	je     8010485c <memcmp+0x3c>
    if(*s1 != *s2)
80104836:	0f b6 03             	movzbl (%ebx),%eax
80104839:	31 d2                	xor    %edx,%edx
8010483b:	0f b6 0e             	movzbl (%esi),%ecx
8010483e:	38 c8                	cmp    %cl,%al
80104840:	74 16                	je     80104858 <memcmp+0x38>
80104842:	eb 24                	jmp    80104868 <memcmp+0x48>
80104844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104848:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010484d:	83 c2 01             	add    $0x1,%edx
80104850:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104854:	38 c8                	cmp    %cl,%al
80104856:	75 10                	jne    80104868 <memcmp+0x48>
  while(n-- > 0){
80104858:	39 fa                	cmp    %edi,%edx
8010485a:	75 ec                	jne    80104848 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010485c:	5b                   	pop    %ebx
  return 0;
8010485d:	31 c0                	xor    %eax,%eax
}
8010485f:	5e                   	pop    %esi
80104860:	5f                   	pop    %edi
80104861:	5d                   	pop    %ebp
80104862:	c3                   	ret    
80104863:	90                   	nop
80104864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104868:	5b                   	pop    %ebx
      return *s1 - *s2;
80104869:	29 c8                	sub    %ecx,%eax
}
8010486b:	5e                   	pop    %esi
8010486c:	5f                   	pop    %edi
8010486d:	5d                   	pop    %ebp
8010486e:	c3                   	ret    
8010486f:	90                   	nop

80104870 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	57                   	push   %edi
80104874:	8b 45 08             	mov    0x8(%ebp),%eax
80104877:	56                   	push   %esi
80104878:	8b 75 0c             	mov    0xc(%ebp),%esi
8010487b:	53                   	push   %ebx
8010487c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010487f:	39 c6                	cmp    %eax,%esi
80104881:	73 35                	jae    801048b8 <memmove+0x48>
80104883:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104886:	39 c8                	cmp    %ecx,%eax
80104888:	73 2e                	jae    801048b8 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010488a:	85 db                	test   %ebx,%ebx
    d += n;
8010488c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010488f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104892:	74 1b                	je     801048af <memmove+0x3f>
80104894:	f7 db                	neg    %ebx
80104896:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104899:	01 fb                	add    %edi,%ebx
8010489b:	90                   	nop
8010489c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801048a0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801048a4:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    while(n-- > 0)
801048a7:	83 ea 01             	sub    $0x1,%edx
801048aa:	83 fa ff             	cmp    $0xffffffff,%edx
801048ad:	75 f1                	jne    801048a0 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801048af:	5b                   	pop    %ebx
801048b0:	5e                   	pop    %esi
801048b1:	5f                   	pop    %edi
801048b2:	5d                   	pop    %ebp
801048b3:	c3                   	ret    
801048b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801048b8:	31 d2                	xor    %edx,%edx
801048ba:	85 db                	test   %ebx,%ebx
801048bc:	74 f1                	je     801048af <memmove+0x3f>
801048be:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801048c0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801048c4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801048c7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801048ca:	39 da                	cmp    %ebx,%edx
801048cc:	75 f2                	jne    801048c0 <memmove+0x50>
}
801048ce:	5b                   	pop    %ebx
801048cf:	5e                   	pop    %esi
801048d0:	5f                   	pop    %edi
801048d1:	5d                   	pop    %ebp
801048d2:	c3                   	ret    
801048d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801048d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048e0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801048e3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801048e4:	eb 8a                	jmp    80104870 <memmove>
801048e6:	8d 76 00             	lea    0x0(%esi),%esi
801048e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048f0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801048f0:	55                   	push   %ebp
801048f1:	89 e5                	mov    %esp,%ebp
801048f3:	56                   	push   %esi
801048f4:	8b 75 10             	mov    0x10(%ebp),%esi
801048f7:	53                   	push   %ebx
801048f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801048fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
801048fe:	85 f6                	test   %esi,%esi
80104900:	74 30                	je     80104932 <strncmp+0x42>
80104902:	0f b6 01             	movzbl (%ecx),%eax
80104905:	84 c0                	test   %al,%al
80104907:	74 2f                	je     80104938 <strncmp+0x48>
80104909:	0f b6 13             	movzbl (%ebx),%edx
8010490c:	38 d0                	cmp    %dl,%al
8010490e:	75 46                	jne    80104956 <strncmp+0x66>
80104910:	8d 51 01             	lea    0x1(%ecx),%edx
80104913:	01 ce                	add    %ecx,%esi
80104915:	eb 14                	jmp    8010492b <strncmp+0x3b>
80104917:	90                   	nop
80104918:	0f b6 02             	movzbl (%edx),%eax
8010491b:	84 c0                	test   %al,%al
8010491d:	74 31                	je     80104950 <strncmp+0x60>
8010491f:	0f b6 19             	movzbl (%ecx),%ebx
80104922:	83 c2 01             	add    $0x1,%edx
80104925:	38 d8                	cmp    %bl,%al
80104927:	75 17                	jne    80104940 <strncmp+0x50>
    n--, p++, q++;
80104929:	89 cb                	mov    %ecx,%ebx
  while(n > 0 && *p && *p == *q)
8010492b:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
8010492d:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(n > 0 && *p && *p == *q)
80104930:	75 e6                	jne    80104918 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104932:	5b                   	pop    %ebx
    return 0;
80104933:	31 c0                	xor    %eax,%eax
}
80104935:	5e                   	pop    %esi
80104936:	5d                   	pop    %ebp
80104937:	c3                   	ret    
80104938:	0f b6 1b             	movzbl (%ebx),%ebx
  while(n > 0 && *p && *p == *q)
8010493b:	31 c0                	xor    %eax,%eax
8010493d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
80104940:	0f b6 d3             	movzbl %bl,%edx
80104943:	29 d0                	sub    %edx,%eax
}
80104945:	5b                   	pop    %ebx
80104946:	5e                   	pop    %esi
80104947:	5d                   	pop    %ebp
80104948:	c3                   	ret    
80104949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104950:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104954:	eb ea                	jmp    80104940 <strncmp+0x50>
  while(n > 0 && *p && *p == *q)
80104956:	89 d3                	mov    %edx,%ebx
80104958:	eb e6                	jmp    80104940 <strncmp+0x50>
8010495a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104960 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	8b 45 08             	mov    0x8(%ebp),%eax
80104966:	56                   	push   %esi
80104967:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010496a:	53                   	push   %ebx
8010496b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010496e:	89 c2                	mov    %eax,%edx
80104970:	eb 19                	jmp    8010498b <strncpy+0x2b>
80104972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104978:	83 c3 01             	add    $0x1,%ebx
8010497b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010497f:	83 c2 01             	add    $0x1,%edx
80104982:	84 c9                	test   %cl,%cl
80104984:	88 4a ff             	mov    %cl,-0x1(%edx)
80104987:	74 09                	je     80104992 <strncpy+0x32>
80104989:	89 f1                	mov    %esi,%ecx
8010498b:	85 c9                	test   %ecx,%ecx
8010498d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104990:	7f e6                	jg     80104978 <strncpy+0x18>
    ;
  while(n-- > 0)
80104992:	31 c9                	xor    %ecx,%ecx
80104994:	85 f6                	test   %esi,%esi
80104996:	7e 0f                	jle    801049a7 <strncpy+0x47>
    *s++ = 0;
80104998:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010499c:	89 f3                	mov    %esi,%ebx
8010499e:	83 c1 01             	add    $0x1,%ecx
801049a1:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
801049a3:	85 db                	test   %ebx,%ebx
801049a5:	7f f1                	jg     80104998 <strncpy+0x38>
  return os;
}
801049a7:	5b                   	pop    %ebx
801049a8:	5e                   	pop    %esi
801049a9:	5d                   	pop    %ebp
801049aa:	c3                   	ret    
801049ab:	90                   	nop
801049ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049b0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801049b0:	55                   	push   %ebp
801049b1:	89 e5                	mov    %esp,%ebp
801049b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
801049b6:	56                   	push   %esi
801049b7:	8b 45 08             	mov    0x8(%ebp),%eax
801049ba:	53                   	push   %ebx
801049bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801049be:	85 c9                	test   %ecx,%ecx
801049c0:	7e 26                	jle    801049e8 <safestrcpy+0x38>
801049c2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801049c6:	89 c1                	mov    %eax,%ecx
801049c8:	eb 17                	jmp    801049e1 <safestrcpy+0x31>
801049ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801049d0:	83 c2 01             	add    $0x1,%edx
801049d3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801049d7:	83 c1 01             	add    $0x1,%ecx
801049da:	84 db                	test   %bl,%bl
801049dc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801049df:	74 04                	je     801049e5 <safestrcpy+0x35>
801049e1:	39 f2                	cmp    %esi,%edx
801049e3:	75 eb                	jne    801049d0 <safestrcpy+0x20>
    ;
  *s = 0;
801049e5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801049e8:	5b                   	pop    %ebx
801049e9:	5e                   	pop    %esi
801049ea:	5d                   	pop    %ebp
801049eb:	c3                   	ret    
801049ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049f0 <strlen>:

int
strlen(const char *s)
{
801049f0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801049f1:	31 c0                	xor    %eax,%eax
{
801049f3:	89 e5                	mov    %esp,%ebp
801049f5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801049f8:	80 3a 00             	cmpb   $0x0,(%edx)
801049fb:	74 0c                	je     80104a09 <strlen+0x19>
801049fd:	8d 76 00             	lea    0x0(%esi),%esi
80104a00:	83 c0 01             	add    $0x1,%eax
80104a03:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104a07:	75 f7                	jne    80104a00 <strlen+0x10>
    ;
  return n;
}
80104a09:	5d                   	pop    %ebp
80104a0a:	c3                   	ret    

80104a0b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104a0b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104a0f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104a13:	55                   	push   %ebp
  pushl %ebx
80104a14:	53                   	push   %ebx
  pushl %esi
80104a15:	56                   	push   %esi
  pushl %edi
80104a16:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a17:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104a19:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104a1b:	5f                   	pop    %edi
  popl %esi
80104a1c:	5e                   	pop    %esi
  popl %ebx
80104a1d:	5b                   	pop    %ebx
  popl %ebp
80104a1e:	5d                   	pop    %ebp
  ret
80104a1f:	c3                   	ret    

80104a20 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	53                   	push   %ebx
80104a24:	83 ec 04             	sub    $0x4,%esp
80104a27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104a2a:	e8 b1 ec ff ff       	call   801036e0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a2f:	8b 40 04             	mov    0x4(%eax),%eax
80104a32:	39 d8                	cmp    %ebx,%eax
80104a34:	76 1a                	jbe    80104a50 <fetchint+0x30>
80104a36:	8d 53 04             	lea    0x4(%ebx),%edx
80104a39:	39 d0                	cmp    %edx,%eax
80104a3b:	72 13                	jb     80104a50 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104a3d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a40:	8b 13                	mov    (%ebx),%edx
80104a42:	89 10                	mov    %edx,(%eax)
  return 0;
80104a44:	31 c0                	xor    %eax,%eax
}
80104a46:	83 c4 04             	add    $0x4,%esp
80104a49:	5b                   	pop    %ebx
80104a4a:	5d                   	pop    %ebp
80104a4b:	c3                   	ret    
80104a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a55:	eb ef                	jmp    80104a46 <fetchint+0x26>
80104a57:	89 f6                	mov    %esi,%esi
80104a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a60 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	53                   	push   %ebx
80104a64:	83 ec 04             	sub    $0x4,%esp
80104a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104a6a:	e8 71 ec ff ff       	call   801036e0 <myproc>

  if(addr >= curproc->sz)
80104a6f:	39 58 04             	cmp    %ebx,0x4(%eax)
80104a72:	76 28                	jbe    80104a9c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104a74:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104a77:	89 da                	mov    %ebx,%edx
80104a79:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104a7b:	8b 40 04             	mov    0x4(%eax),%eax
  for(s = *pp; s < ep; s++){
80104a7e:	39 c3                	cmp    %eax,%ebx
80104a80:	73 1a                	jae    80104a9c <fetchstr+0x3c>
    if(*s == 0)
80104a82:	80 3b 00             	cmpb   $0x0,(%ebx)
80104a85:	75 0e                	jne    80104a95 <fetchstr+0x35>
80104a87:	eb 1f                	jmp    80104aa8 <fetchstr+0x48>
80104a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a90:	80 3a 00             	cmpb   $0x0,(%edx)
80104a93:	74 13                	je     80104aa8 <fetchstr+0x48>
  for(s = *pp; s < ep; s++){
80104a95:	83 c2 01             	add    $0x1,%edx
80104a98:	39 d0                	cmp    %edx,%eax
80104a9a:	77 f4                	ja     80104a90 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
80104a9c:	83 c4 04             	add    $0x4,%esp
    return -1;
80104a9f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104aa4:	5b                   	pop    %ebx
80104aa5:	5d                   	pop    %ebp
80104aa6:	c3                   	ret    
80104aa7:	90                   	nop
80104aa8:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
80104aab:	89 d0                	mov    %edx,%eax
80104aad:	29 d8                	sub    %ebx,%eax
}
80104aaf:	5b                   	pop    %ebx
80104ab0:	5d                   	pop    %ebp
80104ab1:	c3                   	ret    
80104ab2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ac0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	56                   	push   %esi
80104ac4:	8b 75 0c             	mov    0xc(%ebp),%esi
80104ac7:	53                   	push   %ebx
80104ac8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104acb:	e8 10 ec ff ff       	call   801036e0 <myproc>
80104ad0:	89 75 0c             	mov    %esi,0xc(%ebp)
80104ad3:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ad6:	8b 40 44             	mov    0x44(%eax),%eax
80104ad9:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
80104add:	89 45 08             	mov    %eax,0x8(%ebp)
}
80104ae0:	5b                   	pop    %ebx
80104ae1:	5e                   	pop    %esi
80104ae2:	5d                   	pop    %ebp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ae3:	e9 38 ff ff ff       	jmp    80104a20 <fetchint>
80104ae8:	90                   	nop
80104ae9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104af0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	56                   	push   %esi
80104af4:	53                   	push   %ebx
80104af5:	83 ec 20             	sub    $0x20,%esp
80104af8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104afb:	e8 e0 eb ff ff       	call   801036e0 <myproc>
80104b00:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104b02:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b05:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b09:	8b 45 08             	mov    0x8(%ebp),%eax
80104b0c:	89 04 24             	mov    %eax,(%esp)
80104b0f:	e8 ac ff ff ff       	call   80104ac0 <argint>
80104b14:	85 c0                	test   %eax,%eax
80104b16:	78 28                	js     80104b40 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104b18:	85 db                	test   %ebx,%ebx
80104b1a:	78 24                	js     80104b40 <argptr+0x50>
80104b1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104b1f:	8b 46 04             	mov    0x4(%esi),%eax
80104b22:	39 c2                	cmp    %eax,%edx
80104b24:	73 1a                	jae    80104b40 <argptr+0x50>
80104b26:	01 d3                	add    %edx,%ebx
80104b28:	39 d8                	cmp    %ebx,%eax
80104b2a:	72 14                	jb     80104b40 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b2f:	89 10                	mov    %edx,(%eax)
  return 0;
}
80104b31:	83 c4 20             	add    $0x20,%esp
  return 0;
80104b34:	31 c0                	xor    %eax,%eax
}
80104b36:	5b                   	pop    %ebx
80104b37:	5e                   	pop    %esi
80104b38:	5d                   	pop    %ebp
80104b39:	c3                   	ret    
80104b3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b40:	83 c4 20             	add    $0x20,%esp
    return -1;
80104b43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b48:	5b                   	pop    %ebx
80104b49:	5e                   	pop    %esi
80104b4a:	5d                   	pop    %ebp
80104b4b:	c3                   	ret    
80104b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b50 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104b56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b59:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b5d:	8b 45 08             	mov    0x8(%ebp),%eax
80104b60:	89 04 24             	mov    %eax,(%esp)
80104b63:	e8 58 ff ff ff       	call   80104ac0 <argint>
80104b68:	85 c0                	test   %eax,%eax
80104b6a:	78 14                	js     80104b80 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b6f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b76:	89 04 24             	mov    %eax,(%esp)
80104b79:	e8 e2 fe ff ff       	call   80104a60 <fetchstr>
}
80104b7e:	c9                   	leave  
80104b7f:	c3                   	ret    
    return -1;
80104b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b85:	c9                   	leave  
80104b86:	c3                   	ret    
80104b87:	89 f6                	mov    %esi,%esi
80104b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b90 <syscall>:
[SYS_getTurnTime] sys_getTurnTime,  //lab2
};

void
syscall(void)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	56                   	push   %esi
80104b94:	53                   	push   %ebx
80104b95:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104b98:	e8 43 eb ff ff       	call   801036e0 <myproc>

  num = curproc->tf->eax;
80104b9d:	8b 70 1c             	mov    0x1c(%eax),%esi
  struct proc *curproc = myproc();
80104ba0:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
80104ba2:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ba5:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ba8:	83 fa 1c             	cmp    $0x1c,%edx
80104bab:	77 1b                	ja     80104bc8 <syscall+0x38>
80104bad:	8b 14 85 c0 79 10 80 	mov    -0x7fef8640(,%eax,4),%edx
80104bb4:	85 d2                	test   %edx,%edx
80104bb6:	74 10                	je     80104bc8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104bb8:	ff d2                	call   *%edx
80104bba:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104bbd:	83 c4 10             	add    $0x10,%esp
80104bc0:	5b                   	pop    %ebx
80104bc1:	5e                   	pop    %esi
80104bc2:	5d                   	pop    %ebp
80104bc3:	c3                   	ret    
80104bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104bc8:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
80104bcc:	8d 43 70             	lea    0x70(%ebx),%eax
80104bcf:	89 44 24 08          	mov    %eax,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
80104bd3:	8b 43 14             	mov    0x14(%ebx),%eax
80104bd6:	c7 04 24 85 79 10 80 	movl   $0x80107985,(%esp)
80104bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
80104be1:	e8 6a ba ff ff       	call   80100650 <cprintf>
    curproc->tf->eax = -1;
80104be6:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104be9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104bf0:	83 c4 10             	add    $0x10,%esp
80104bf3:	5b                   	pop    %ebx
80104bf4:	5e                   	pop    %esi
80104bf5:	5d                   	pop    %ebp
80104bf6:	c3                   	ret    
80104bf7:	66 90                	xchg   %ax,%ax
80104bf9:	66 90                	xchg   %ax,%ax
80104bfb:	66 90                	xchg   %ax,%ax
80104bfd:	66 90                	xchg   %ax,%ax
80104bff:	90                   	nop

80104c00 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	53                   	push   %ebx
80104c04:	89 c3                	mov    %eax,%ebx
80104c06:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
80104c09:	e8 d2 ea ff ff       	call   801036e0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80104c0e:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
80104c10:	8b 4c 90 2c          	mov    0x2c(%eax,%edx,4),%ecx
80104c14:	85 c9                	test   %ecx,%ecx
80104c16:	74 18                	je     80104c30 <fdalloc+0x30>
  for(fd = 0; fd < NOFILE; fd++){
80104c18:	83 c2 01             	add    $0x1,%edx
80104c1b:	83 fa 10             	cmp    $0x10,%edx
80104c1e:	75 f0                	jne    80104c10 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
80104c20:	83 c4 04             	add    $0x4,%esp
  return -1;
80104c23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c28:	5b                   	pop    %ebx
80104c29:	5d                   	pop    %ebp
80104c2a:	c3                   	ret    
80104c2b:	90                   	nop
80104c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80104c30:	89 5c 90 2c          	mov    %ebx,0x2c(%eax,%edx,4)
}
80104c34:	83 c4 04             	add    $0x4,%esp
      return fd;
80104c37:	89 d0                	mov    %edx,%eax
}
80104c39:	5b                   	pop    %ebx
80104c3a:	5d                   	pop    %ebp
80104c3b:	c3                   	ret    
80104c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c40 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	57                   	push   %edi
80104c44:	56                   	push   %esi
80104c45:	53                   	push   %ebx
80104c46:	83 ec 3c             	sub    $0x3c,%esp
80104c49:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104c4c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104c4f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104c52:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c56:	89 04 24             	mov    %eax,(%esp)
{
80104c59:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104c5c:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104c5f:	e8 cc d2 ff ff       	call   80101f30 <nameiparent>
80104c64:	85 c0                	test   %eax,%eax
80104c66:	89 c7                	mov    %eax,%edi
80104c68:	0f 84 da 00 00 00    	je     80104d48 <create+0x108>
    return 0;
  ilock(dp);
80104c6e:	89 04 24             	mov    %eax,(%esp)
80104c71:	e8 4a ca ff ff       	call   801016c0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104c76:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80104c7d:	00 
80104c7e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c82:	89 3c 24             	mov    %edi,(%esp)
80104c85:	e8 46 cf ff ff       	call   80101bd0 <dirlookup>
80104c8a:	85 c0                	test   %eax,%eax
80104c8c:	89 c6                	mov    %eax,%esi
80104c8e:	74 40                	je     80104cd0 <create+0x90>
    iunlockput(dp);
80104c90:	89 3c 24             	mov    %edi,(%esp)
80104c93:	e8 88 cc ff ff       	call   80101920 <iunlockput>
    ilock(ip);
80104c98:	89 34 24             	mov    %esi,(%esp)
80104c9b:	e8 20 ca ff ff       	call   801016c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ca0:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104ca5:	75 11                	jne    80104cb8 <create+0x78>
80104ca7:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104cac:	89 f0                	mov    %esi,%eax
80104cae:	75 08                	jne    80104cb8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104cb0:	83 c4 3c             	add    $0x3c,%esp
80104cb3:	5b                   	pop    %ebx
80104cb4:	5e                   	pop    %esi
80104cb5:	5f                   	pop    %edi
80104cb6:	5d                   	pop    %ebp
80104cb7:	c3                   	ret    
    iunlockput(ip);
80104cb8:	89 34 24             	mov    %esi,(%esp)
80104cbb:	e8 60 cc ff ff       	call   80101920 <iunlockput>
}
80104cc0:	83 c4 3c             	add    $0x3c,%esp
    return 0;
80104cc3:	31 c0                	xor    %eax,%eax
}
80104cc5:	5b                   	pop    %ebx
80104cc6:	5e                   	pop    %esi
80104cc7:	5f                   	pop    %edi
80104cc8:	5d                   	pop    %ebp
80104cc9:	c3                   	ret    
80104cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80104cd0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cd8:	8b 07                	mov    (%edi),%eax
80104cda:	89 04 24             	mov    %eax,(%esp)
80104cdd:	e8 4e c8 ff ff       	call   80101530 <ialloc>
80104ce2:	85 c0                	test   %eax,%eax
80104ce4:	89 c6                	mov    %eax,%esi
80104ce6:	0f 84 bf 00 00 00    	je     80104dab <create+0x16b>
  ilock(ip);
80104cec:	89 04 24             	mov    %eax,(%esp)
80104cef:	e8 cc c9 ff ff       	call   801016c0 <ilock>
  ip->major = major;
80104cf4:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104cf8:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104cfc:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104d00:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104d04:	b8 01 00 00 00       	mov    $0x1,%eax
80104d09:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104d0d:	89 34 24             	mov    %esi,(%esp)
80104d10:	e8 eb c8 ff ff       	call   80101600 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104d15:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104d1a:	74 34                	je     80104d50 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104d1c:	8b 46 04             	mov    0x4(%esi),%eax
80104d1f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104d23:	89 3c 24             	mov    %edi,(%esp)
80104d26:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d2a:	e8 01 d1 ff ff       	call   80101e30 <dirlink>
80104d2f:	85 c0                	test   %eax,%eax
80104d31:	78 6c                	js     80104d9f <create+0x15f>
  iunlockput(dp);
80104d33:	89 3c 24             	mov    %edi,(%esp)
80104d36:	e8 e5 cb ff ff       	call   80101920 <iunlockput>
}
80104d3b:	83 c4 3c             	add    $0x3c,%esp
  return ip;
80104d3e:	89 f0                	mov    %esi,%eax
}
80104d40:	5b                   	pop    %ebx
80104d41:	5e                   	pop    %esi
80104d42:	5f                   	pop    %edi
80104d43:	5d                   	pop    %ebp
80104d44:	c3                   	ret    
80104d45:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
80104d48:	31 c0                	xor    %eax,%eax
80104d4a:	e9 61 ff ff ff       	jmp    80104cb0 <create+0x70>
80104d4f:	90                   	nop
    dp->nlink++;  // for ".."
80104d50:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104d55:	89 3c 24             	mov    %edi,(%esp)
80104d58:	e8 a3 c8 ff ff       	call   80101600 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104d5d:	8b 46 04             	mov    0x4(%esi),%eax
80104d60:	c7 44 24 04 54 7a 10 	movl   $0x80107a54,0x4(%esp)
80104d67:	80 
80104d68:	89 34 24             	mov    %esi,(%esp)
80104d6b:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d6f:	e8 bc d0 ff ff       	call   80101e30 <dirlink>
80104d74:	85 c0                	test   %eax,%eax
80104d76:	78 1b                	js     80104d93 <create+0x153>
80104d78:	8b 47 04             	mov    0x4(%edi),%eax
80104d7b:	c7 44 24 04 53 7a 10 	movl   $0x80107a53,0x4(%esp)
80104d82:	80 
80104d83:	89 34 24             	mov    %esi,(%esp)
80104d86:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d8a:	e8 a1 d0 ff ff       	call   80101e30 <dirlink>
80104d8f:	85 c0                	test   %eax,%eax
80104d91:	79 89                	jns    80104d1c <create+0xdc>
      panic("create dots");
80104d93:	c7 04 24 47 7a 10 80 	movl   $0x80107a47,(%esp)
80104d9a:	e8 c1 b5 ff ff       	call   80100360 <panic>
    panic("create: dirlink");
80104d9f:	c7 04 24 56 7a 10 80 	movl   $0x80107a56,(%esp)
80104da6:	e8 b5 b5 ff ff       	call   80100360 <panic>
    panic("create: ialloc");
80104dab:	c7 04 24 38 7a 10 80 	movl   $0x80107a38,(%esp)
80104db2:	e8 a9 b5 ff ff       	call   80100360 <panic>
80104db7:	89 f6                	mov    %esi,%esi
80104db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dc0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	56                   	push   %esi
80104dc4:	89 c6                	mov    %eax,%esi
80104dc6:	53                   	push   %ebx
80104dc7:	89 d3                	mov    %edx,%ebx
80104dc9:	83 ec 20             	sub    $0x20,%esp
  if(argint(n, &fd) < 0)
80104dcc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dcf:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dd3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104dda:	e8 e1 fc ff ff       	call   80104ac0 <argint>
80104ddf:	85 c0                	test   %eax,%eax
80104de1:	78 2d                	js     80104e10 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104de3:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104de7:	77 27                	ja     80104e10 <argfd.constprop.0+0x50>
80104de9:	e8 f2 e8 ff ff       	call   801036e0 <myproc>
80104dee:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104df1:	8b 44 90 2c          	mov    0x2c(%eax,%edx,4),%eax
80104df5:	85 c0                	test   %eax,%eax
80104df7:	74 17                	je     80104e10 <argfd.constprop.0+0x50>
  if(pfd)
80104df9:	85 f6                	test   %esi,%esi
80104dfb:	74 02                	je     80104dff <argfd.constprop.0+0x3f>
    *pfd = fd;
80104dfd:	89 16                	mov    %edx,(%esi)
  if(pf)
80104dff:	85 db                	test   %ebx,%ebx
80104e01:	74 1d                	je     80104e20 <argfd.constprop.0+0x60>
    *pf = f;
80104e03:	89 03                	mov    %eax,(%ebx)
  return 0;
80104e05:	31 c0                	xor    %eax,%eax
}
80104e07:	83 c4 20             	add    $0x20,%esp
80104e0a:	5b                   	pop    %ebx
80104e0b:	5e                   	pop    %esi
80104e0c:	5d                   	pop    %ebp
80104e0d:	c3                   	ret    
80104e0e:	66 90                	xchg   %ax,%ax
80104e10:	83 c4 20             	add    $0x20,%esp
    return -1;
80104e13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e18:	5b                   	pop    %ebx
80104e19:	5e                   	pop    %esi
80104e1a:	5d                   	pop    %ebp
80104e1b:	c3                   	ret    
80104e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 0;
80104e20:	31 c0                	xor    %eax,%eax
80104e22:	eb e3                	jmp    80104e07 <argfd.constprop.0+0x47>
80104e24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104e30 <sys_dup>:
{
80104e30:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104e31:	31 c0                	xor    %eax,%eax
{
80104e33:	89 e5                	mov    %esp,%ebp
80104e35:	53                   	push   %ebx
80104e36:	83 ec 24             	sub    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
80104e39:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104e3c:	e8 7f ff ff ff       	call   80104dc0 <argfd.constprop.0>
80104e41:	85 c0                	test   %eax,%eax
80104e43:	78 23                	js     80104e68 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e48:	e8 b3 fd ff ff       	call   80104c00 <fdalloc>
80104e4d:	85 c0                	test   %eax,%eax
80104e4f:	89 c3                	mov    %eax,%ebx
80104e51:	78 15                	js     80104e68 <sys_dup+0x38>
  filedup(f);
80104e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e56:	89 04 24             	mov    %eax,(%esp)
80104e59:	e8 92 bf ff ff       	call   80100df0 <filedup>
  return fd;
80104e5e:	89 d8                	mov    %ebx,%eax
}
80104e60:	83 c4 24             	add    $0x24,%esp
80104e63:	5b                   	pop    %ebx
80104e64:	5d                   	pop    %ebp
80104e65:	c3                   	ret    
80104e66:	66 90                	xchg   %ax,%ax
    return -1;
80104e68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e6d:	eb f1                	jmp    80104e60 <sys_dup+0x30>
80104e6f:	90                   	nop

80104e70 <sys_read>:
{
80104e70:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e71:	31 c0                	xor    %eax,%eax
{
80104e73:	89 e5                	mov    %esp,%ebp
80104e75:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e78:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e7b:	e8 40 ff ff ff       	call   80104dc0 <argfd.constprop.0>
80104e80:	85 c0                	test   %eax,%eax
80104e82:	78 54                	js     80104ed8 <sys_read+0x68>
80104e84:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e87:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e8b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104e92:	e8 29 fc ff ff       	call   80104ac0 <argint>
80104e97:	85 c0                	test   %eax,%eax
80104e99:	78 3d                	js     80104ed8 <sys_read+0x68>
80104e9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104e9e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104ea5:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ea9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104eac:	89 44 24 04          	mov    %eax,0x4(%esp)
80104eb0:	e8 3b fc ff ff       	call   80104af0 <argptr>
80104eb5:	85 c0                	test   %eax,%eax
80104eb7:	78 1f                	js     80104ed8 <sys_read+0x68>
  return fileread(f, p, n);
80104eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ebc:	89 44 24 08          	mov    %eax,0x8(%esp)
80104ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ec3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ec7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104eca:	89 04 24             	mov    %eax,(%esp)
80104ecd:	e8 7e c0 ff ff       	call   80100f50 <fileread>
}
80104ed2:	c9                   	leave  
80104ed3:	c3                   	ret    
80104ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104ed8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104edd:	c9                   	leave  
80104ede:	c3                   	ret    
80104edf:	90                   	nop

80104ee0 <sys_write>:
{
80104ee0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ee1:	31 c0                	xor    %eax,%eax
{
80104ee3:	89 e5                	mov    %esp,%ebp
80104ee5:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ee8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104eeb:	e8 d0 fe ff ff       	call   80104dc0 <argfd.constprop.0>
80104ef0:	85 c0                	test   %eax,%eax
80104ef2:	78 54                	js     80104f48 <sys_write+0x68>
80104ef4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ef7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104efb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104f02:	e8 b9 fb ff ff       	call   80104ac0 <argint>
80104f07:	85 c0                	test   %eax,%eax
80104f09:	78 3d                	js     80104f48 <sys_write+0x68>
80104f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104f15:	89 44 24 08          	mov    %eax,0x8(%esp)
80104f19:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f1c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f20:	e8 cb fb ff ff       	call   80104af0 <argptr>
80104f25:	85 c0                	test   %eax,%eax
80104f27:	78 1f                	js     80104f48 <sys_write+0x68>
  return filewrite(f, p, n);
80104f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f2c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f33:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f37:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104f3a:	89 04 24             	mov    %eax,(%esp)
80104f3d:	e8 ae c0 ff ff       	call   80100ff0 <filewrite>
}
80104f42:	c9                   	leave  
80104f43:	c3                   	ret    
80104f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f4d:	c9                   	leave  
80104f4e:	c3                   	ret    
80104f4f:	90                   	nop

80104f50 <sys_close>:
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
80104f56:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104f59:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f5c:	e8 5f fe ff ff       	call   80104dc0 <argfd.constprop.0>
80104f61:	85 c0                	test   %eax,%eax
80104f63:	78 23                	js     80104f88 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
80104f65:	e8 76 e7 ff ff       	call   801036e0 <myproc>
80104f6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104f6d:	c7 44 90 2c 00 00 00 	movl   $0x0,0x2c(%eax,%edx,4)
80104f74:	00 
  fileclose(f);
80104f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f78:	89 04 24             	mov    %eax,(%esp)
80104f7b:	e8 c0 be ff ff       	call   80100e40 <fileclose>
  return 0;
80104f80:	31 c0                	xor    %eax,%eax
}
80104f82:	c9                   	leave  
80104f83:	c3                   	ret    
80104f84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104f88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f8d:	c9                   	leave  
80104f8e:	c3                   	ret    
80104f8f:	90                   	nop

80104f90 <sys_fstat>:
{
80104f90:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f91:	31 c0                	xor    %eax,%eax
{
80104f93:	89 e5                	mov    %esp,%ebp
80104f95:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f98:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104f9b:	e8 20 fe ff ff       	call   80104dc0 <argfd.constprop.0>
80104fa0:	85 c0                	test   %eax,%eax
80104fa2:	78 34                	js     80104fd8 <sys_fstat+0x48>
80104fa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fa7:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104fae:	00 
80104faf:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fb3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104fba:	e8 31 fb ff ff       	call   80104af0 <argptr>
80104fbf:	85 c0                	test   %eax,%eax
80104fc1:	78 15                	js     80104fd8 <sys_fstat+0x48>
  return filestat(f, st);
80104fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104fc6:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fca:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fcd:	89 04 24             	mov    %eax,(%esp)
80104fd0:	e8 2b bf ff ff       	call   80100f00 <filestat>
}
80104fd5:	c9                   	leave  
80104fd6:	c3                   	ret    
80104fd7:	90                   	nop
    return -1;
80104fd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fdd:	c9                   	leave  
80104fde:	c3                   	ret    
80104fdf:	90                   	nop

80104fe0 <sys_link>:
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	57                   	push   %edi
80104fe4:	56                   	push   %esi
80104fe5:	53                   	push   %ebx
80104fe6:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104fe9:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104fec:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ff0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ff7:	e8 54 fb ff ff       	call   80104b50 <argstr>
80104ffc:	85 c0                	test   %eax,%eax
80104ffe:	0f 88 e6 00 00 00    	js     801050ea <sys_link+0x10a>
80105004:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105007:	89 44 24 04          	mov    %eax,0x4(%esp)
8010500b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105012:	e8 39 fb ff ff       	call   80104b50 <argstr>
80105017:	85 c0                	test   %eax,%eax
80105019:	0f 88 cb 00 00 00    	js     801050ea <sys_link+0x10a>
  begin_op();
8010501f:	e8 fc da ff ff       	call   80102b20 <begin_op>
  if((ip = namei(old)) == 0){
80105024:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105027:	89 04 24             	mov    %eax,(%esp)
8010502a:	e8 e1 ce ff ff       	call   80101f10 <namei>
8010502f:	85 c0                	test   %eax,%eax
80105031:	89 c3                	mov    %eax,%ebx
80105033:	0f 84 ac 00 00 00    	je     801050e5 <sys_link+0x105>
  ilock(ip);
80105039:	89 04 24             	mov    %eax,(%esp)
8010503c:	e8 7f c6 ff ff       	call   801016c0 <ilock>
  if(ip->type == T_DIR){
80105041:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105046:	0f 84 91 00 00 00    	je     801050dd <sys_link+0xfd>
  ip->nlink++;
8010504c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105051:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105054:	89 1c 24             	mov    %ebx,(%esp)
80105057:	e8 a4 c5 ff ff       	call   80101600 <iupdate>
  iunlock(ip);
8010505c:	89 1c 24             	mov    %ebx,(%esp)
8010505f:	e8 3c c7 ff ff       	call   801017a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105064:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105067:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010506b:	89 04 24             	mov    %eax,(%esp)
8010506e:	e8 bd ce ff ff       	call   80101f30 <nameiparent>
80105073:	85 c0                	test   %eax,%eax
80105075:	89 c6                	mov    %eax,%esi
80105077:	74 4f                	je     801050c8 <sys_link+0xe8>
  ilock(dp);
80105079:	89 04 24             	mov    %eax,(%esp)
8010507c:	e8 3f c6 ff ff       	call   801016c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105081:	8b 03                	mov    (%ebx),%eax
80105083:	39 06                	cmp    %eax,(%esi)
80105085:	75 39                	jne    801050c0 <sys_link+0xe0>
80105087:	8b 43 04             	mov    0x4(%ebx),%eax
8010508a:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010508e:	89 34 24             	mov    %esi,(%esp)
80105091:	89 44 24 08          	mov    %eax,0x8(%esp)
80105095:	e8 96 cd ff ff       	call   80101e30 <dirlink>
8010509a:	85 c0                	test   %eax,%eax
8010509c:	78 22                	js     801050c0 <sys_link+0xe0>
  iunlockput(dp);
8010509e:	89 34 24             	mov    %esi,(%esp)
801050a1:	e8 7a c8 ff ff       	call   80101920 <iunlockput>
  iput(ip);
801050a6:	89 1c 24             	mov    %ebx,(%esp)
801050a9:	e8 32 c7 ff ff       	call   801017e0 <iput>
  end_op();
801050ae:	e8 dd da ff ff       	call   80102b90 <end_op>
}
801050b3:	83 c4 3c             	add    $0x3c,%esp
  return 0;
801050b6:	31 c0                	xor    %eax,%eax
}
801050b8:	5b                   	pop    %ebx
801050b9:	5e                   	pop    %esi
801050ba:	5f                   	pop    %edi
801050bb:	5d                   	pop    %ebp
801050bc:	c3                   	ret    
801050bd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
801050c0:	89 34 24             	mov    %esi,(%esp)
801050c3:	e8 58 c8 ff ff       	call   80101920 <iunlockput>
  ilock(ip);
801050c8:	89 1c 24             	mov    %ebx,(%esp)
801050cb:	e8 f0 c5 ff ff       	call   801016c0 <ilock>
  ip->nlink--;
801050d0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801050d5:	89 1c 24             	mov    %ebx,(%esp)
801050d8:	e8 23 c5 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
801050dd:	89 1c 24             	mov    %ebx,(%esp)
801050e0:	e8 3b c8 ff ff       	call   80101920 <iunlockput>
  end_op();
801050e5:	e8 a6 da ff ff       	call   80102b90 <end_op>
}
801050ea:	83 c4 3c             	add    $0x3c,%esp
  return -1;
801050ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050f2:	5b                   	pop    %ebx
801050f3:	5e                   	pop    %esi
801050f4:	5f                   	pop    %edi
801050f5:	5d                   	pop    %ebp
801050f6:	c3                   	ret    
801050f7:	89 f6                	mov    %esi,%esi
801050f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105100 <sys_unlink>:
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	57                   	push   %edi
80105104:	56                   	push   %esi
80105105:	53                   	push   %ebx
80105106:	83 ec 5c             	sub    $0x5c,%esp
  if(argstr(0, &path) < 0)
80105109:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010510c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105110:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105117:	e8 34 fa ff ff       	call   80104b50 <argstr>
8010511c:	85 c0                	test   %eax,%eax
8010511e:	0f 88 76 01 00 00    	js     8010529a <sys_unlink+0x19a>
  begin_op();
80105124:	e8 f7 d9 ff ff       	call   80102b20 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105129:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010512c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
8010512f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105133:	89 04 24             	mov    %eax,(%esp)
80105136:	e8 f5 cd ff ff       	call   80101f30 <nameiparent>
8010513b:	85 c0                	test   %eax,%eax
8010513d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105140:	0f 84 4f 01 00 00    	je     80105295 <sys_unlink+0x195>
  ilock(dp);
80105146:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80105149:	89 34 24             	mov    %esi,(%esp)
8010514c:	e8 6f c5 ff ff       	call   801016c0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105151:	c7 44 24 04 54 7a 10 	movl   $0x80107a54,0x4(%esp)
80105158:	80 
80105159:	89 1c 24             	mov    %ebx,(%esp)
8010515c:	e8 3f ca ff ff       	call   80101ba0 <namecmp>
80105161:	85 c0                	test   %eax,%eax
80105163:	0f 84 21 01 00 00    	je     8010528a <sys_unlink+0x18a>
80105169:	c7 44 24 04 53 7a 10 	movl   $0x80107a53,0x4(%esp)
80105170:	80 
80105171:	89 1c 24             	mov    %ebx,(%esp)
80105174:	e8 27 ca ff ff       	call   80101ba0 <namecmp>
80105179:	85 c0                	test   %eax,%eax
8010517b:	0f 84 09 01 00 00    	je     8010528a <sys_unlink+0x18a>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105181:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105184:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80105188:	89 44 24 08          	mov    %eax,0x8(%esp)
8010518c:	89 34 24             	mov    %esi,(%esp)
8010518f:	e8 3c ca ff ff       	call   80101bd0 <dirlookup>
80105194:	85 c0                	test   %eax,%eax
80105196:	89 c3                	mov    %eax,%ebx
80105198:	0f 84 ec 00 00 00    	je     8010528a <sys_unlink+0x18a>
  ilock(ip);
8010519e:	89 04 24             	mov    %eax,(%esp)
801051a1:	e8 1a c5 ff ff       	call   801016c0 <ilock>
  if(ip->nlink < 1)
801051a6:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801051ab:	0f 8e 24 01 00 00    	jle    801052d5 <sys_unlink+0x1d5>
  if(ip->type == T_DIR && !isdirempty(ip)){
801051b1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051b6:	8d 75 d8             	lea    -0x28(%ebp),%esi
801051b9:	74 7d                	je     80105238 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
801051bb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801051c2:	00 
801051c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801051ca:	00 
801051cb:	89 34 24             	mov    %esi,(%esp)
801051ce:	e8 fd f5 ff ff       	call   801047d0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051d3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801051d6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801051dd:	00 
801051de:	89 74 24 04          	mov    %esi,0x4(%esp)
801051e2:	89 44 24 08          	mov    %eax,0x8(%esp)
801051e6:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801051e9:	89 04 24             	mov    %eax,(%esp)
801051ec:	e8 7f c8 ff ff       	call   80101a70 <writei>
801051f1:	83 f8 10             	cmp    $0x10,%eax
801051f4:	0f 85 cf 00 00 00    	jne    801052c9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801051fa:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051ff:	0f 84 a3 00 00 00    	je     801052a8 <sys_unlink+0x1a8>
  iunlockput(dp);
80105205:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80105208:	89 04 24             	mov    %eax,(%esp)
8010520b:	e8 10 c7 ff ff       	call   80101920 <iunlockput>
  ip->nlink--;
80105210:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105215:	89 1c 24             	mov    %ebx,(%esp)
80105218:	e8 e3 c3 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
8010521d:	89 1c 24             	mov    %ebx,(%esp)
80105220:	e8 fb c6 ff ff       	call   80101920 <iunlockput>
  end_op();
80105225:	e8 66 d9 ff ff       	call   80102b90 <end_op>
}
8010522a:	83 c4 5c             	add    $0x5c,%esp
  return 0;
8010522d:	31 c0                	xor    %eax,%eax
}
8010522f:	5b                   	pop    %ebx
80105230:	5e                   	pop    %esi
80105231:	5f                   	pop    %edi
80105232:	5d                   	pop    %ebp
80105233:	c3                   	ret    
80105234:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105238:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
8010523c:	0f 86 79 ff ff ff    	jbe    801051bb <sys_unlink+0xbb>
80105242:	bf 20 00 00 00       	mov    $0x20,%edi
80105247:	eb 15                	jmp    8010525e <sys_unlink+0x15e>
80105249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105250:	8d 57 10             	lea    0x10(%edi),%edx
80105253:	3b 53 58             	cmp    0x58(%ebx),%edx
80105256:	0f 83 5f ff ff ff    	jae    801051bb <sys_unlink+0xbb>
8010525c:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010525e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105265:	00 
80105266:	89 7c 24 08          	mov    %edi,0x8(%esp)
8010526a:	89 74 24 04          	mov    %esi,0x4(%esp)
8010526e:	89 1c 24             	mov    %ebx,(%esp)
80105271:	e8 fa c6 ff ff       	call   80101970 <readi>
80105276:	83 f8 10             	cmp    $0x10,%eax
80105279:	75 42                	jne    801052bd <sys_unlink+0x1bd>
    if(de.inum != 0)
8010527b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105280:	74 ce                	je     80105250 <sys_unlink+0x150>
    iunlockput(ip);
80105282:	89 1c 24             	mov    %ebx,(%esp)
80105285:	e8 96 c6 ff ff       	call   80101920 <iunlockput>
  iunlockput(dp);
8010528a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010528d:	89 04 24             	mov    %eax,(%esp)
80105290:	e8 8b c6 ff ff       	call   80101920 <iunlockput>
  end_op();
80105295:	e8 f6 d8 ff ff       	call   80102b90 <end_op>
}
8010529a:	83 c4 5c             	add    $0x5c,%esp
  return -1;
8010529d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801052a2:	5b                   	pop    %ebx
801052a3:	5e                   	pop    %esi
801052a4:	5f                   	pop    %edi
801052a5:	5d                   	pop    %ebp
801052a6:	c3                   	ret    
801052a7:	90                   	nop
    dp->nlink--;
801052a8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801052ab:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
801052b0:	89 04 24             	mov    %eax,(%esp)
801052b3:	e8 48 c3 ff ff       	call   80101600 <iupdate>
801052b8:	e9 48 ff ff ff       	jmp    80105205 <sys_unlink+0x105>
      panic("isdirempty: readi");
801052bd:	c7 04 24 78 7a 10 80 	movl   $0x80107a78,(%esp)
801052c4:	e8 97 b0 ff ff       	call   80100360 <panic>
    panic("unlink: writei");
801052c9:	c7 04 24 8a 7a 10 80 	movl   $0x80107a8a,(%esp)
801052d0:	e8 8b b0 ff ff       	call   80100360 <panic>
    panic("unlink: nlink < 1");
801052d5:	c7 04 24 66 7a 10 80 	movl   $0x80107a66,(%esp)
801052dc:	e8 7f b0 ff ff       	call   80100360 <panic>
801052e1:	eb 0d                	jmp    801052f0 <sys_open>
801052e3:	90                   	nop
801052e4:	90                   	nop
801052e5:	90                   	nop
801052e6:	90                   	nop
801052e7:	90                   	nop
801052e8:	90                   	nop
801052e9:	90                   	nop
801052ea:	90                   	nop
801052eb:	90                   	nop
801052ec:	90                   	nop
801052ed:	90                   	nop
801052ee:	90                   	nop
801052ef:	90                   	nop

801052f0 <sys_open>:

int
sys_open(void)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	57                   	push   %edi
801052f4:	56                   	push   %esi
801052f5:	53                   	push   %ebx
801052f6:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052f9:	8d 45 e0             	lea    -0x20(%ebp),%eax
801052fc:	89 44 24 04          	mov    %eax,0x4(%esp)
80105300:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105307:	e8 44 f8 ff ff       	call   80104b50 <argstr>
8010530c:	85 c0                	test   %eax,%eax
8010530e:	0f 88 d1 00 00 00    	js     801053e5 <sys_open+0xf5>
80105314:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105317:	89 44 24 04          	mov    %eax,0x4(%esp)
8010531b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105322:	e8 99 f7 ff ff       	call   80104ac0 <argint>
80105327:	85 c0                	test   %eax,%eax
80105329:	0f 88 b6 00 00 00    	js     801053e5 <sys_open+0xf5>
    return -1;

  begin_op();
8010532f:	e8 ec d7 ff ff       	call   80102b20 <begin_op>

  if(omode & O_CREATE){
80105334:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105338:	0f 85 82 00 00 00    	jne    801053c0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010533e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105341:	89 04 24             	mov    %eax,(%esp)
80105344:	e8 c7 cb ff ff       	call   80101f10 <namei>
80105349:	85 c0                	test   %eax,%eax
8010534b:	89 c6                	mov    %eax,%esi
8010534d:	0f 84 8d 00 00 00    	je     801053e0 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80105353:	89 04 24             	mov    %eax,(%esp)
80105356:	e8 65 c3 ff ff       	call   801016c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
8010535b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105360:	0f 84 92 00 00 00    	je     801053f8 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105366:	e8 15 ba ff ff       	call   80100d80 <filealloc>
8010536b:	85 c0                	test   %eax,%eax
8010536d:	89 c3                	mov    %eax,%ebx
8010536f:	0f 84 93 00 00 00    	je     80105408 <sys_open+0x118>
80105375:	e8 86 f8 ff ff       	call   80104c00 <fdalloc>
8010537a:	85 c0                	test   %eax,%eax
8010537c:	89 c7                	mov    %eax,%edi
8010537e:	0f 88 94 00 00 00    	js     80105418 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105384:	89 34 24             	mov    %esi,(%esp)
80105387:	e8 14 c4 ff ff       	call   801017a0 <iunlock>
  end_op();
8010538c:	e8 ff d7 ff ff       	call   80102b90 <end_op>

  f->type = FD_INODE;
80105391:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105397:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f->ip = ip;
8010539a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
8010539d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
801053a4:	89 c2                	mov    %eax,%edx
801053a6:	83 e2 01             	and    $0x1,%edx
801053a9:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053ac:	a8 03                	test   $0x3,%al
  f->readable = !(omode & O_WRONLY);
801053ae:	88 53 08             	mov    %dl,0x8(%ebx)
  return fd;
801053b1:	89 f8                	mov    %edi,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053b3:	0f 95 43 09          	setne  0x9(%ebx)
}
801053b7:	83 c4 2c             	add    $0x2c,%esp
801053ba:	5b                   	pop    %ebx
801053bb:	5e                   	pop    %esi
801053bc:	5f                   	pop    %edi
801053bd:	5d                   	pop    %ebp
801053be:	c3                   	ret    
801053bf:	90                   	nop
    ip = create(path, T_FILE, 0, 0);
801053c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801053c3:	31 c9                	xor    %ecx,%ecx
801053c5:	ba 02 00 00 00       	mov    $0x2,%edx
801053ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801053d1:	e8 6a f8 ff ff       	call   80104c40 <create>
    if(ip == 0){
801053d6:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801053d8:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801053da:	75 8a                	jne    80105366 <sys_open+0x76>
801053dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801053e0:	e8 ab d7 ff ff       	call   80102b90 <end_op>
}
801053e5:	83 c4 2c             	add    $0x2c,%esp
    return -1;
801053e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053ed:	5b                   	pop    %ebx
801053ee:	5e                   	pop    %esi
801053ef:	5f                   	pop    %edi
801053f0:	5d                   	pop    %ebp
801053f1:	c3                   	ret    
801053f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801053f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801053fb:	85 c0                	test   %eax,%eax
801053fd:	0f 84 63 ff ff ff    	je     80105366 <sys_open+0x76>
80105403:	90                   	nop
80105404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
80105408:	89 34 24             	mov    %esi,(%esp)
8010540b:	e8 10 c5 ff ff       	call   80101920 <iunlockput>
80105410:	eb ce                	jmp    801053e0 <sys_open+0xf0>
80105412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      fileclose(f);
80105418:	89 1c 24             	mov    %ebx,(%esp)
8010541b:	e8 20 ba ff ff       	call   80100e40 <fileclose>
80105420:	eb e6                	jmp    80105408 <sys_open+0x118>
80105422:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105430 <sys_mkdir>:

int
sys_mkdir(void)
{
80105430:	55                   	push   %ebp
80105431:	89 e5                	mov    %esp,%ebp
80105433:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105436:	e8 e5 d6 ff ff       	call   80102b20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010543b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010543e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105442:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105449:	e8 02 f7 ff ff       	call   80104b50 <argstr>
8010544e:	85 c0                	test   %eax,%eax
80105450:	78 2e                	js     80105480 <sys_mkdir+0x50>
80105452:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105455:	31 c9                	xor    %ecx,%ecx
80105457:	ba 01 00 00 00       	mov    $0x1,%edx
8010545c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105463:	e8 d8 f7 ff ff       	call   80104c40 <create>
80105468:	85 c0                	test   %eax,%eax
8010546a:	74 14                	je     80105480 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010546c:	89 04 24             	mov    %eax,(%esp)
8010546f:	e8 ac c4 ff ff       	call   80101920 <iunlockput>
  end_op();
80105474:	e8 17 d7 ff ff       	call   80102b90 <end_op>
  return 0;
80105479:	31 c0                	xor    %eax,%eax
}
8010547b:	c9                   	leave  
8010547c:	c3                   	ret    
8010547d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80105480:	e8 0b d7 ff ff       	call   80102b90 <end_op>
    return -1;
80105485:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010548a:	c9                   	leave  
8010548b:	c3                   	ret    
8010548c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105490 <sys_mknod>:

int
sys_mknod(void)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105496:	e8 85 d6 ff ff       	call   80102b20 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010549b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010549e:	89 44 24 04          	mov    %eax,0x4(%esp)
801054a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054a9:	e8 a2 f6 ff ff       	call   80104b50 <argstr>
801054ae:	85 c0                	test   %eax,%eax
801054b0:	78 5e                	js     80105510 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801054b2:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801054b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801054c0:	e8 fb f5 ff ff       	call   80104ac0 <argint>
  if((argstr(0, &path)) < 0 ||
801054c5:	85 c0                	test   %eax,%eax
801054c7:	78 47                	js     80105510 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801054c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801054d0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801054d7:	e8 e4 f5 ff ff       	call   80104ac0 <argint>
     argint(1, &major) < 0 ||
801054dc:	85 c0                	test   %eax,%eax
801054de:	78 30                	js     80105510 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801054e0:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801054e4:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
801054e9:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801054ed:	89 04 24             	mov    %eax,(%esp)
     argint(2, &minor) < 0 ||
801054f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801054f3:	e8 48 f7 ff ff       	call   80104c40 <create>
801054f8:	85 c0                	test   %eax,%eax
801054fa:	74 14                	je     80105510 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801054fc:	89 04 24             	mov    %eax,(%esp)
801054ff:	e8 1c c4 ff ff       	call   80101920 <iunlockput>
  end_op();
80105504:	e8 87 d6 ff ff       	call   80102b90 <end_op>
  return 0;
80105509:	31 c0                	xor    %eax,%eax
}
8010550b:	c9                   	leave  
8010550c:	c3                   	ret    
8010550d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80105510:	e8 7b d6 ff ff       	call   80102b90 <end_op>
    return -1;
80105515:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010551a:	c9                   	leave  
8010551b:	c3                   	ret    
8010551c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105520 <sys_chdir>:

int
sys_chdir(void)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	56                   	push   %esi
80105524:	53                   	push   %ebx
80105525:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105528:	e8 b3 e1 ff ff       	call   801036e0 <myproc>
8010552d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010552f:	e8 ec d5 ff ff       	call   80102b20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105534:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105537:	89 44 24 04          	mov    %eax,0x4(%esp)
8010553b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105542:	e8 09 f6 ff ff       	call   80104b50 <argstr>
80105547:	85 c0                	test   %eax,%eax
80105549:	78 4a                	js     80105595 <sys_chdir+0x75>
8010554b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010554e:	89 04 24             	mov    %eax,(%esp)
80105551:	e8 ba c9 ff ff       	call   80101f10 <namei>
80105556:	85 c0                	test   %eax,%eax
80105558:	89 c3                	mov    %eax,%ebx
8010555a:	74 39                	je     80105595 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
8010555c:	89 04 24             	mov    %eax,(%esp)
8010555f:	e8 5c c1 ff ff       	call   801016c0 <ilock>
  if(ip->type != T_DIR){
80105564:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105569:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
8010556c:	75 22                	jne    80105590 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
8010556e:	e8 2d c2 ff ff       	call   801017a0 <iunlock>
  iput(curproc->cwd);
80105573:	8b 46 6c             	mov    0x6c(%esi),%eax
80105576:	89 04 24             	mov    %eax,(%esp)
80105579:	e8 62 c2 ff ff       	call   801017e0 <iput>
  end_op();
8010557e:	e8 0d d6 ff ff       	call   80102b90 <end_op>
  curproc->cwd = ip;
  return 0;
80105583:	31 c0                	xor    %eax,%eax
  curproc->cwd = ip;
80105585:	89 5e 6c             	mov    %ebx,0x6c(%esi)
}
80105588:	83 c4 20             	add    $0x20,%esp
8010558b:	5b                   	pop    %ebx
8010558c:	5e                   	pop    %esi
8010558d:	5d                   	pop    %ebp
8010558e:	c3                   	ret    
8010558f:	90                   	nop
    iunlockput(ip);
80105590:	e8 8b c3 ff ff       	call   80101920 <iunlockput>
    end_op();
80105595:	e8 f6 d5 ff ff       	call   80102b90 <end_op>
}
8010559a:	83 c4 20             	add    $0x20,%esp
    return -1;
8010559d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055a2:	5b                   	pop    %ebx
801055a3:	5e                   	pop    %esi
801055a4:	5d                   	pop    %ebp
801055a5:	c3                   	ret    
801055a6:	8d 76 00             	lea    0x0(%esi),%esi
801055a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055b0 <sys_exec>:

int
sys_exec(void)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	57                   	push   %edi
801055b4:	56                   	push   %esi
801055b5:	53                   	push   %ebx
801055b6:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801055bc:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801055c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801055c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055cd:	e8 7e f5 ff ff       	call   80104b50 <argstr>
801055d2:	85 c0                	test   %eax,%eax
801055d4:	0f 88 84 00 00 00    	js     8010565e <sys_exec+0xae>
801055da:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801055e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801055e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801055eb:	e8 d0 f4 ff ff       	call   80104ac0 <argint>
801055f0:	85 c0                	test   %eax,%eax
801055f2:	78 6a                	js     8010565e <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801055f4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
801055fa:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801055fc:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105603:	00 
80105604:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010560a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105611:	00 
80105612:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105618:	89 04 24             	mov    %eax,(%esp)
8010561b:	e8 b0 f1 ff ff       	call   801047d0 <memset>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105620:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105626:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010562a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010562d:	89 04 24             	mov    %eax,(%esp)
80105630:	e8 eb f3 ff ff       	call   80104a20 <fetchint>
80105635:	85 c0                	test   %eax,%eax
80105637:	78 25                	js     8010565e <sys_exec+0xae>
      return -1;
    if(uarg == 0){
80105639:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010563f:	85 c0                	test   %eax,%eax
80105641:	74 2d                	je     80105670 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105643:	89 74 24 04          	mov    %esi,0x4(%esp)
80105647:	89 04 24             	mov    %eax,(%esp)
8010564a:	e8 11 f4 ff ff       	call   80104a60 <fetchstr>
8010564f:	85 c0                	test   %eax,%eax
80105651:	78 0b                	js     8010565e <sys_exec+0xae>
  for(i=0;; i++){
80105653:	83 c3 01             	add    $0x1,%ebx
80105656:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105659:	83 fb 20             	cmp    $0x20,%ebx
8010565c:	75 c2                	jne    80105620 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
8010565e:	81 c4 ac 00 00 00    	add    $0xac,%esp
    return -1;
80105664:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105669:	5b                   	pop    %ebx
8010566a:	5e                   	pop    %esi
8010566b:	5f                   	pop    %edi
8010566c:	5d                   	pop    %ebp
8010566d:	c3                   	ret    
8010566e:	66 90                	xchg   %ax,%ax
  return exec(path, argv);
80105670:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105676:	89 44 24 04          	mov    %eax,0x4(%esp)
8010567a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
      argv[i] = 0;
80105680:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105687:	00 00 00 00 
  return exec(path, argv);
8010568b:	89 04 24             	mov    %eax,(%esp)
8010568e:	e8 0d b3 ff ff       	call   801009a0 <exec>
}
80105693:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105699:	5b                   	pop    %ebx
8010569a:	5e                   	pop    %esi
8010569b:	5f                   	pop    %edi
8010569c:	5d                   	pop    %ebp
8010569d:	c3                   	ret    
8010569e:	66 90                	xchg   %ax,%ax

801056a0 <sys_pipe>:

int
sys_pipe(void)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	53                   	push   %ebx
801056a4:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801056a7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801056aa:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801056b1:	00 
801056b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801056b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801056bd:	e8 2e f4 ff ff       	call   80104af0 <argptr>
801056c2:	85 c0                	test   %eax,%eax
801056c4:	78 6d                	js     80105733 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801056c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801056cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056d0:	89 04 24             	mov    %eax,(%esp)
801056d3:	e8 a8 da ff ff       	call   80103180 <pipealloc>
801056d8:	85 c0                	test   %eax,%eax
801056da:	78 57                	js     80105733 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056df:	e8 1c f5 ff ff       	call   80104c00 <fdalloc>
801056e4:	85 c0                	test   %eax,%eax
801056e6:	89 c3                	mov    %eax,%ebx
801056e8:	78 33                	js     8010571d <sys_pipe+0x7d>
801056ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056ed:	e8 0e f5 ff ff       	call   80104c00 <fdalloc>
801056f2:	85 c0                	test   %eax,%eax
801056f4:	78 1a                	js     80105710 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801056f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801056f9:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
801056fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
801056fe:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
80105701:	83 c4 24             	add    $0x24,%esp
  return 0;
80105704:	31 c0                	xor    %eax,%eax
}
80105706:	5b                   	pop    %ebx
80105707:	5d                   	pop    %ebp
80105708:	c3                   	ret    
80105709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105710:	e8 cb df ff ff       	call   801036e0 <myproc>
80105715:	c7 44 98 2c 00 00 00 	movl   $0x0,0x2c(%eax,%ebx,4)
8010571c:	00 
    fileclose(rf);
8010571d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105720:	89 04 24             	mov    %eax,(%esp)
80105723:	e8 18 b7 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105728:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010572b:	89 04 24             	mov    %eax,(%esp)
8010572e:	e8 0d b7 ff ff       	call   80100e40 <fileclose>
}
80105733:	83 c4 24             	add    $0x24,%esp
    return -1;
80105736:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010573b:	5b                   	pop    %ebx
8010573c:	5d                   	pop    %ebp
8010573d:	c3                   	ret    
8010573e:	66 90                	xchg   %ax,%ax

80105740 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105740:	55                   	push   %ebp
80105741:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105743:	5d                   	pop    %ebp
  return fork();
80105744:	e9 47 e1 ff ff       	jmp    80103890 <fork>
80105749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105750 <sys_exit>:

int
sys_exit(void)
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	83 ec 08             	sub    $0x8,%esp
  exit();
80105756:	e8 a5 e4 ff ff       	call   80103c00 <exit>
  return 0;  // not reached
}
8010575b:	31 c0                	xor    %eax,%eax
8010575d:	c9                   	leave  
8010575e:	c3                   	ret    
8010575f:	90                   	nop

80105760 <sys_exitStatus>:

int sys_exitStatus(void) //cs153_lab1: exitStatus
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	83 ec 28             	sub    $0x28,%esp
	int arg;

	if (argint(0, &arg) < 0)
80105766:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105769:	89 44 24 04          	mov    %eax,0x4(%esp)
8010576d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105774:	e8 47 f3 ff ff       	call   80104ac0 <argint>
80105779:	85 c0                	test   %eax,%eax
8010577b:	78 13                	js     80105790 <sys_exitStatus+0x30>
		exitStatus(1); //didn't receive an argument, so I'm forcefully sending a one
	else
		exitStatus(arg);
8010577d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105780:	89 04 24             	mov    %eax,(%esp)
80105783:	e8 a8 e5 ff ff       	call   80103d30 <exitStatus>

	return 0; //not reached
}
80105788:	31 c0                	xor    %eax,%eax
8010578a:	c9                   	leave  
8010578b:	c3                   	ret    
8010578c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		exitStatus(1); //didn't receive an argument, so I'm forcefully sending a one
80105790:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105797:	e8 94 e5 ff ff       	call   80103d30 <exitStatus>
}
8010579c:	31 c0                	xor    %eax,%eax
8010579e:	c9                   	leave  
8010579f:	c3                   	ret    

801057a0 <sys_wait>:

int
sys_wait(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
  return wait();
}
801057a3:	5d                   	pop    %ebp
  return wait();
801057a4:	e9 27 e8 ff ff       	jmp    80103fd0 <wait>
801057a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801057b0 <sys_waitStatus>:

int sys_waitStatus(void) //cs153_lab1: waitStatus
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	83 ec 28             	sub    $0x28,%esp
	int* argPtr;

	if (argptr(0, (void*)&argPtr, sizeof(int)) < 0)
801057b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057b9:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801057c0:	00 
801057c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801057c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057cc:	e8 1f f3 ff ff       	call   80104af0 <argptr>
801057d1:	85 c0                	test   %eax,%eax
801057d3:	78 13                	js     801057e8 <sys_waitStatus+0x38>
		return -1;
	else
		return waitStatus(argPtr);
801057d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057d8:	89 04 24             	mov    %eax,(%esp)
801057db:	e8 e0 e8 ff ff       	call   801040c0 <waitStatus>
}
801057e0:	c9                   	leave  
801057e1:	c3                   	ret    
801057e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		return -1;
801057e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057ed:	c9                   	leave  
801057ee:	c3                   	ret    
801057ef:	90                   	nop

801057f0 <sys_waitpid>:

int sys_waitpid(void) //cs153_lab1: waitpid
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	56                   	push   %esi
801057f4:	53                   	push   %ebx
801057f5:	83 ec 20             	sub    $0x20,%esp
	int pid, options, argInt1, argInt2, argPtr;
	int* status;

	argInt1 = argint(0, &pid);
801057f8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801057fb:	89 44 24 04          	mov    %eax,0x4(%esp)
801057ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105806:	e8 b5 f2 ff ff       	call   80104ac0 <argint>
	argPtr = argptr(1, (void*)&status, sizeof(int));
8010580b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80105812:	00 
80105813:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
	argInt1 = argint(0, &pid);
8010581a:	89 c3                	mov    %eax,%ebx
	argPtr = argptr(1, (void*)&status, sizeof(int));
8010581c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010581f:	89 44 24 04          	mov    %eax,0x4(%esp)
	argInt2 = argint(2, &options);

	if (argInt1 < 0 || argPtr < 0 || argInt2 < 0)
80105823:	c1 eb 1f             	shr    $0x1f,%ebx
	argPtr = argptr(1, (void*)&status, sizeof(int));
80105826:	e8 c5 f2 ff ff       	call   80104af0 <argptr>
	argInt2 = argint(2, &options);
8010582b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
	argPtr = argptr(1, (void*)&status, sizeof(int));
80105832:	89 c6                	mov    %eax,%esi
	argInt2 = argint(2, &options);
80105834:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105837:	89 44 24 04          	mov    %eax,0x4(%esp)
8010583b:	e8 80 f2 ff ff       	call   80104ac0 <argint>
	if (argInt1 < 0 || argPtr < 0 || argInt2 < 0)
80105840:	84 db                	test   %bl,%bl
80105842:	75 34                	jne    80105878 <sys_waitpid+0x88>
80105844:	89 f2                	mov    %esi,%edx
80105846:	c1 ea 1f             	shr    $0x1f,%edx
80105849:	84 d2                	test   %dl,%dl
8010584b:	75 2b                	jne    80105878 <sys_waitpid+0x88>
8010584d:	85 c0                	test   %eax,%eax
8010584f:	78 27                	js     80105878 <sys_waitpid+0x88>
		return -1;
	else
		return waitpid(pid, status, options);
80105851:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105854:	89 44 24 08          	mov    %eax,0x8(%esp)
80105858:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010585b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010585f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105862:	89 04 24             	mov    %eax,(%esp)
80105865:	e8 46 e9 ff ff       	call   801041b0 <waitpid>
}
8010586a:	83 c4 20             	add    $0x20,%esp
8010586d:	5b                   	pop    %ebx
8010586e:	5e                   	pop    %esi
8010586f:	5d                   	pop    %ebp
80105870:	c3                   	ret    
80105871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		return -1;
80105878:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010587d:	eb eb                	jmp    8010586a <sys_waitpid+0x7a>
8010587f:	90                   	nop

80105880 <sys_kill>:

int
sys_kill(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105886:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105889:	89 44 24 04          	mov    %eax,0x4(%esp)
8010588d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105894:	e8 27 f2 ff ff       	call   80104ac0 <argint>
80105899:	85 c0                	test   %eax,%eax
8010589b:	78 13                	js     801058b0 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010589d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058a0:	89 04 24             	mov    %eax,(%esp)
801058a3:	e8 78 ea ff ff       	call   80104320 <kill>
}
801058a8:	c9                   	leave  
801058a9:	c3                   	ret    
801058aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801058b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058b5:	c9                   	leave  
801058b6:	c3                   	ret    
801058b7:	89 f6                	mov    %esi,%esi
801058b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058c0 <sys_getpid>:

int
sys_getpid(void)
{
801058c0:	55                   	push   %ebp
801058c1:	89 e5                	mov    %esp,%ebp
801058c3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801058c6:	e8 15 de ff ff       	call   801036e0 <myproc>
801058cb:	8b 40 14             	mov    0x14(%eax),%eax
}
801058ce:	c9                   	leave  
801058cf:	c3                   	ret    

801058d0 <sys_sbrk>:

int
sys_sbrk(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	53                   	push   %ebx
801058d4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801058d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058da:	89 44 24 04          	mov    %eax,0x4(%esp)
801058de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801058e5:	e8 d6 f1 ff ff       	call   80104ac0 <argint>
801058ea:	85 c0                	test   %eax,%eax
801058ec:	78 22                	js     80105910 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801058ee:	e8 ed dd ff ff       	call   801036e0 <myproc>
  if(growproc(n) < 0)
801058f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  addr = myproc()->sz;
801058f6:	8b 58 04             	mov    0x4(%eax),%ebx
  if(growproc(n) < 0)
801058f9:	89 14 24             	mov    %edx,(%esp)
801058fc:	e8 1f df ff ff       	call   80103820 <growproc>
80105901:	85 c0                	test   %eax,%eax
80105903:	78 0b                	js     80105910 <sys_sbrk+0x40>
    return -1;
  return addr;
80105905:	89 d8                	mov    %ebx,%eax
}
80105907:	83 c4 24             	add    $0x24,%esp
8010590a:	5b                   	pop    %ebx
8010590b:	5d                   	pop    %ebp
8010590c:	c3                   	ret    
8010590d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105910:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105915:	eb f0                	jmp    80105907 <sys_sbrk+0x37>
80105917:	89 f6                	mov    %esi,%esi
80105919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105920 <sys_sleep>:

int
sys_sleep(void)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	53                   	push   %ebx
80105924:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105927:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010592a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010592e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105935:	e8 86 f1 ff ff       	call   80104ac0 <argint>
8010593a:	85 c0                	test   %eax,%eax
8010593c:	78 7e                	js     801059bc <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010593e:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
80105945:	e8 c6 ed ff ff       	call   80104710 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010594a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010594d:	8b 1d a0 59 11 80    	mov    0x801159a0,%ebx
  while(ticks - ticks0 < n){
80105953:	85 d2                	test   %edx,%edx
80105955:	75 29                	jne    80105980 <sys_sleep+0x60>
80105957:	eb 4f                	jmp    801059a8 <sys_sleep+0x88>
80105959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105960:	c7 44 24 04 60 51 11 	movl   $0x80115160,0x4(%esp)
80105967:	80 
80105968:	c7 04 24 a0 59 11 80 	movl   $0x801159a0,(%esp)
8010596f:	e8 ac e5 ff ff       	call   80103f20 <sleep>
  while(ticks - ticks0 < n){
80105974:	a1 a0 59 11 80       	mov    0x801159a0,%eax
80105979:	29 d8                	sub    %ebx,%eax
8010597b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010597e:	73 28                	jae    801059a8 <sys_sleep+0x88>
    if(myproc()->killed){
80105980:	e8 5b dd ff ff       	call   801036e0 <myproc>
80105985:	8b 40 28             	mov    0x28(%eax),%eax
80105988:	85 c0                	test   %eax,%eax
8010598a:	74 d4                	je     80105960 <sys_sleep+0x40>
      release(&tickslock);
8010598c:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
80105993:	e8 e8 ed ff ff       	call   80104780 <release>
      return -1;
80105998:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
8010599d:	83 c4 24             	add    $0x24,%esp
801059a0:	5b                   	pop    %ebx
801059a1:	5d                   	pop    %ebp
801059a2:	c3                   	ret    
801059a3:	90                   	nop
801059a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
801059a8:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
801059af:	e8 cc ed ff ff       	call   80104780 <release>
}
801059b4:	83 c4 24             	add    $0x24,%esp
  return 0;
801059b7:	31 c0                	xor    %eax,%eax
}
801059b9:	5b                   	pop    %ebx
801059ba:	5d                   	pop    %ebp
801059bb:	c3                   	ret    
    return -1;
801059bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c1:	eb da                	jmp    8010599d <sys_sleep+0x7d>
801059c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801059c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059d0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	53                   	push   %ebx
801059d4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
801059d7:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
801059de:	e8 2d ed ff ff       	call   80104710 <acquire>
  xticks = ticks;
801059e3:	8b 1d a0 59 11 80    	mov    0x801159a0,%ebx
  release(&tickslock);
801059e9:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
801059f0:	e8 8b ed ff ff       	call   80104780 <release>
  return xticks;
}
801059f5:	83 c4 14             	add    $0x14,%esp
801059f8:	89 d8                	mov    %ebx,%eax
801059fa:	5b                   	pop    %ebx
801059fb:	5d                   	pop    %ebp
801059fc:	c3                   	ret    
801059fd:	8d 76 00             	lea    0x0(%esi),%esi

80105a00 <sys_getPrior>:

//---------lab2------------
int
sys_getPrior(void)
{
80105a00:	55                   	push   %ebp
80105a01:	89 e5                	mov    %esp,%ebp
    return getPrior();
}
80105a03:	5d                   	pop    %ebp
    return getPrior();
80105a04:	e9 97 df ff ff       	jmp    801039a0 <getPrior>
80105a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a10 <sys_setPrior>:
int
sys_setPrior(void)
{
80105a10:	55                   	push   %ebp
80105a11:	89 e5                	mov    %esp,%ebp
80105a13:	83 ec 28             	sub    $0x28,%esp
    //when passing in a argument we must use argint
    int prior_val;

    if(argint(0, &prior_val) < 0){
80105a16:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a19:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a1d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a24:	e8 97 f0 ff ff       	call   80104ac0 <argint>
80105a29:	85 c0                	test   %eax,%eax
80105a2b:	78 13                	js     80105a40 <sys_setPrior+0x30>
        exitStatus(1); //error caught!
    }
    else
        setPrior(prior_val);
80105a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a30:	89 04 24             	mov    %eax,(%esp)
80105a33:	e8 c8 e4 ff ff       	call   80103f00 <setPrior>
    return 0;  // not reached
}
80105a38:	31 c0                	xor    %eax,%eax
80105a3a:	c9                   	leave  
80105a3b:	c3                   	ret    
80105a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        exitStatus(1); //error caught!
80105a40:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105a47:	e8 e4 e2 ff ff       	call   80103d30 <exitStatus>
}
80105a4c:	31 c0                	xor    %eax,%eax
80105a4e:	c9                   	leave  
80105a4f:	c3                   	ret    

80105a50 <sys_getWaitTime>:
int
sys_getWaitTime(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
    return getWaitTime();
}
80105a53:	5d                   	pop    %ebp
    return getWaitTime();
80105a54:	e9 67 df ff ff       	jmp    801039c0 <getWaitTime>
80105a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a60 <sys_getTurnTime>:
int
sys_getTurnTime(void)
{
80105a60:	55                   	push   %ebp
80105a61:	89 e5                	mov    %esp,%ebp
    return getTurnTime();
}
80105a63:	5d                   	pop    %ebp
    return getTurnTime();
80105a64:	e9 77 df ff ff       	jmp    801039e0 <getTurnTime>

80105a69 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105a69:	1e                   	push   %ds
  pushl %es
80105a6a:	06                   	push   %es
  pushl %fs
80105a6b:	0f a0                	push   %fs
  pushl %gs
80105a6d:	0f a8                	push   %gs
  pushal
80105a6f:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105a70:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105a74:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105a76:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105a78:	54                   	push   %esp
  call trap
80105a79:	e8 e2 00 00 00       	call   80105b60 <trap>
  addl $4, %esp
80105a7e:	83 c4 04             	add    $0x4,%esp

80105a81 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105a81:	61                   	popa   
  popl %gs
80105a82:	0f a9                	pop    %gs
  popl %fs
80105a84:	0f a1                	pop    %fs
  popl %es
80105a86:	07                   	pop    %es
  popl %ds
80105a87:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105a88:	83 c4 08             	add    $0x8,%esp
  iret
80105a8b:	cf                   	iret   
80105a8c:	66 90                	xchg   %ax,%ax
80105a8e:	66 90                	xchg   %ax,%ax

80105a90 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105a90:	31 c0                	xor    %eax,%eax
80105a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105a98:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105a9f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105aa4:	66 89 0c c5 a2 51 11 	mov    %cx,-0x7feeae5e(,%eax,8)
80105aab:	80 
80105aac:	c6 04 c5 a4 51 11 80 	movb   $0x0,-0x7feeae5c(,%eax,8)
80105ab3:	00 
80105ab4:	c6 04 c5 a5 51 11 80 	movb   $0x8e,-0x7feeae5b(,%eax,8)
80105abb:	8e 
80105abc:	66 89 14 c5 a0 51 11 	mov    %dx,-0x7feeae60(,%eax,8)
80105ac3:	80 
80105ac4:	c1 ea 10             	shr    $0x10,%edx
80105ac7:	66 89 14 c5 a6 51 11 	mov    %dx,-0x7feeae5a(,%eax,8)
80105ace:	80 
  for(i = 0; i < 256; i++)
80105acf:	83 c0 01             	add    $0x1,%eax
80105ad2:	3d 00 01 00 00       	cmp    $0x100,%eax
80105ad7:	75 bf                	jne    80105a98 <tvinit+0x8>
{
80105ad9:	55                   	push   %ebp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ada:	ba 08 00 00 00       	mov    $0x8,%edx
{
80105adf:	89 e5                	mov    %esp,%ebp
80105ae1:	83 ec 18             	sub    $0x18,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ae4:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105ae9:	c7 44 24 04 99 7a 10 	movl   $0x80107a99,0x4(%esp)
80105af0:	80 
80105af1:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105af8:	66 89 15 a2 53 11 80 	mov    %dx,0x801153a2
80105aff:	66 a3 a0 53 11 80    	mov    %ax,0x801153a0
80105b05:	c1 e8 10             	shr    $0x10,%eax
80105b08:	c6 05 a4 53 11 80 00 	movb   $0x0,0x801153a4
80105b0f:	c6 05 a5 53 11 80 ef 	movb   $0xef,0x801153a5
80105b16:	66 a3 a6 53 11 80    	mov    %ax,0x801153a6
  initlock(&tickslock, "time");
80105b1c:	e8 7f ea ff ff       	call   801045a0 <initlock>
}
80105b21:	c9                   	leave  
80105b22:	c3                   	ret    
80105b23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b30 <idtinit>:

void
idtinit(void)
{
80105b30:	55                   	push   %ebp
  pd[0] = size-1;
80105b31:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105b36:	89 e5                	mov    %esp,%ebp
80105b38:	83 ec 10             	sub    $0x10,%esp
80105b3b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105b3f:	b8 a0 51 11 80       	mov    $0x801151a0,%eax
80105b44:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105b48:	c1 e8 10             	shr    $0x10,%eax
80105b4b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105b4f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105b52:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105b55:	c9                   	leave  
80105b56:	c3                   	ret    
80105b57:	89 f6                	mov    %esi,%esi
80105b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b60 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	57                   	push   %edi
80105b64:	56                   	push   %esi
80105b65:	53                   	push   %ebx
80105b66:	83 ec 3c             	sub    $0x3c,%esp
80105b69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105b6c:	8b 43 30             	mov    0x30(%ebx),%eax
80105b6f:	83 f8 40             	cmp    $0x40,%eax
80105b72:	0f 84 a0 01 00 00    	je     80105d18 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105b78:	83 e8 20             	sub    $0x20,%eax
80105b7b:	83 f8 1f             	cmp    $0x1f,%eax
80105b7e:	77 08                	ja     80105b88 <trap+0x28>
80105b80:	ff 24 85 40 7b 10 80 	jmp    *-0x7fef84c0(,%eax,4)
80105b87:	90                   	nop
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105b88:	e8 53 db ff ff       	call   801036e0 <myproc>
80105b8d:	85 c0                	test   %eax,%eax
80105b8f:	90                   	nop
80105b90:	0f 84 fa 01 00 00    	je     80105d90 <trap+0x230>
80105b96:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105b9a:	0f 84 f0 01 00 00    	je     80105d90 <trap+0x230>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105ba0:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ba3:	8b 53 38             	mov    0x38(%ebx),%edx
80105ba6:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105ba9:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105bac:	e8 0f db ff ff       	call   801036c0 <cpuid>
80105bb1:	8b 73 30             	mov    0x30(%ebx),%esi
80105bb4:	89 c7                	mov    %eax,%edi
80105bb6:	8b 43 34             	mov    0x34(%ebx),%eax
80105bb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105bbc:	e8 1f db ff ff       	call   801036e0 <myproc>
80105bc1:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105bc4:	e8 17 db ff ff       	call   801036e0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bc9:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105bcc:	89 74 24 0c          	mov    %esi,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105bd0:	8b 75 e0             	mov    -0x20(%ebp),%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bd3:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105bd6:	89 7c 24 14          	mov    %edi,0x14(%esp)
80105bda:	89 54 24 18          	mov    %edx,0x18(%esp)
80105bde:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            myproc()->pid, myproc()->name, tf->trapno,
80105be1:	83 c6 70             	add    $0x70,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105be4:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105be8:	89 74 24 08          	mov    %esi,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bec:	89 54 24 10          	mov    %edx,0x10(%esp)
80105bf0:	8b 40 14             	mov    0x14(%eax),%eax
80105bf3:	c7 04 24 fc 7a 10 80 	movl   $0x80107afc,(%esp)
80105bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bfe:	e8 4d aa ff ff       	call   80100650 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105c03:	e8 d8 da ff ff       	call   801036e0 <myproc>
80105c08:	c7 40 28 01 00 00 00 	movl   $0x1,0x28(%eax)
80105c0f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c10:	e8 cb da ff ff       	call   801036e0 <myproc>
80105c15:	85 c0                	test   %eax,%eax
80105c17:	74 0c                	je     80105c25 <trap+0xc5>
80105c19:	e8 c2 da ff ff       	call   801036e0 <myproc>
80105c1e:	8b 50 28             	mov    0x28(%eax),%edx
80105c21:	85 d2                	test   %edx,%edx
80105c23:	75 4b                	jne    80105c70 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105c25:	e8 b6 da ff ff       	call   801036e0 <myproc>
80105c2a:	85 c0                	test   %eax,%eax
80105c2c:	74 0d                	je     80105c3b <trap+0xdb>
80105c2e:	66 90                	xchg   %ax,%ax
80105c30:	e8 ab da ff ff       	call   801036e0 <myproc>
80105c35:	83 78 10 04          	cmpl   $0x4,0x10(%eax)
80105c39:	74 4d                	je     80105c88 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c3b:	e8 a0 da ff ff       	call   801036e0 <myproc>
80105c40:	85 c0                	test   %eax,%eax
80105c42:	74 1d                	je     80105c61 <trap+0x101>
80105c44:	e8 97 da ff ff       	call   801036e0 <myproc>
80105c49:	8b 40 28             	mov    0x28(%eax),%eax
80105c4c:	85 c0                	test   %eax,%eax
80105c4e:	74 11                	je     80105c61 <trap+0x101>
80105c50:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c54:	83 e0 03             	and    $0x3,%eax
80105c57:	66 83 f8 03          	cmp    $0x3,%ax
80105c5b:	0f 84 e8 00 00 00    	je     80105d49 <trap+0x1e9>
    exit();
}
80105c61:	83 c4 3c             	add    $0x3c,%esp
80105c64:	5b                   	pop    %ebx
80105c65:	5e                   	pop    %esi
80105c66:	5f                   	pop    %edi
80105c67:	5d                   	pop    %ebp
80105c68:	c3                   	ret    
80105c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c70:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105c74:	83 e0 03             	and    $0x3,%eax
80105c77:	66 83 f8 03          	cmp    $0x3,%ax
80105c7b:	75 a8                	jne    80105c25 <trap+0xc5>
    exit();
80105c7d:	e8 7e df ff ff       	call   80103c00 <exit>
80105c82:	eb a1                	jmp    80105c25 <trap+0xc5>
80105c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105c88:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c90:	75 a9                	jne    80105c3b <trap+0xdb>
    yield();
80105c92:	e8 29 e2 ff ff       	call   80103ec0 <yield>
80105c97:	eb a2                	jmp    80105c3b <trap+0xdb>
80105c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105ca0:	e8 1b da ff ff       	call   801036c0 <cpuid>
80105ca5:	85 c0                	test   %eax,%eax
80105ca7:	0f 84 b3 00 00 00    	je     80105d60 <trap+0x200>
80105cad:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
80105cb0:	e8 db ca ff ff       	call   80102790 <lapiceoi>
    break;
80105cb5:	e9 56 ff ff ff       	jmp    80105c10 <trap+0xb0>
80105cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    kbdintr();
80105cc0:	e8 1b c9 ff ff       	call   801025e0 <kbdintr>
    lapiceoi();
80105cc5:	e8 c6 ca ff ff       	call   80102790 <lapiceoi>
    break;
80105cca:	e9 41 ff ff ff       	jmp    80105c10 <trap+0xb0>
80105ccf:	90                   	nop
    uartintr();
80105cd0:	e8 1b 02 00 00       	call   80105ef0 <uartintr>
    lapiceoi();
80105cd5:	e8 b6 ca ff ff       	call   80102790 <lapiceoi>
    break;
80105cda:	e9 31 ff ff ff       	jmp    80105c10 <trap+0xb0>
80105cdf:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105ce0:	8b 7b 38             	mov    0x38(%ebx),%edi
80105ce3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105ce7:	e8 d4 d9 ff ff       	call   801036c0 <cpuid>
80105cec:	c7 04 24 a4 7a 10 80 	movl   $0x80107aa4,(%esp)
80105cf3:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105cf7:	89 74 24 08          	mov    %esi,0x8(%esp)
80105cfb:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cff:	e8 4c a9 ff ff       	call   80100650 <cprintf>
    lapiceoi();
80105d04:	e8 87 ca ff ff       	call   80102790 <lapiceoi>
    break;
80105d09:	e9 02 ff ff ff       	jmp    80105c10 <trap+0xb0>
80105d0e:	66 90                	xchg   %ax,%ax
    ideintr();
80105d10:	e8 7b c3 ff ff       	call   80102090 <ideintr>
80105d15:	eb 96                	jmp    80105cad <trap+0x14d>
80105d17:	90                   	nop
80105d18:	90                   	nop
80105d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105d20:	e8 bb d9 ff ff       	call   801036e0 <myproc>
80105d25:	8b 70 28             	mov    0x28(%eax),%esi
80105d28:	85 f6                	test   %esi,%esi
80105d2a:	75 2c                	jne    80105d58 <trap+0x1f8>
    myproc()->tf = tf;
80105d2c:	e8 af d9 ff ff       	call   801036e0 <myproc>
80105d31:	89 58 1c             	mov    %ebx,0x1c(%eax)
    syscall();
80105d34:	e8 57 ee ff ff       	call   80104b90 <syscall>
    if(myproc()->killed)
80105d39:	e8 a2 d9 ff ff       	call   801036e0 <myproc>
80105d3e:	8b 48 28             	mov    0x28(%eax),%ecx
80105d41:	85 c9                	test   %ecx,%ecx
80105d43:	0f 84 18 ff ff ff    	je     80105c61 <trap+0x101>
}
80105d49:	83 c4 3c             	add    $0x3c,%esp
80105d4c:	5b                   	pop    %ebx
80105d4d:	5e                   	pop    %esi
80105d4e:	5f                   	pop    %edi
80105d4f:	5d                   	pop    %ebp
      exit();
80105d50:	e9 ab de ff ff       	jmp    80103c00 <exit>
80105d55:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
80105d58:	e8 a3 de ff ff       	call   80103c00 <exit>
80105d5d:	eb cd                	jmp    80105d2c <trap+0x1cc>
80105d5f:	90                   	nop
      acquire(&tickslock);
80105d60:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
80105d67:	e8 a4 e9 ff ff       	call   80104710 <acquire>
      wakeup(&ticks);
80105d6c:	c7 04 24 a0 59 11 80 	movl   $0x801159a0,(%esp)
      ticks++;
80105d73:	83 05 a0 59 11 80 01 	addl   $0x1,0x801159a0
      wakeup(&ticks);
80105d7a:	e8 31 e5 ff ff       	call   801042b0 <wakeup>
      release(&tickslock);
80105d7f:	c7 04 24 60 51 11 80 	movl   $0x80115160,(%esp)
80105d86:	e8 f5 e9 ff ff       	call   80104780 <release>
80105d8b:	e9 1d ff ff ff       	jmp    80105cad <trap+0x14d>
80105d90:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105d93:	8b 73 38             	mov    0x38(%ebx),%esi
80105d96:	e8 25 d9 ff ff       	call   801036c0 <cpuid>
80105d9b:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105d9f:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105da3:	89 44 24 08          	mov    %eax,0x8(%esp)
80105da7:	8b 43 30             	mov    0x30(%ebx),%eax
80105daa:	c7 04 24 c8 7a 10 80 	movl   $0x80107ac8,(%esp)
80105db1:	89 44 24 04          	mov    %eax,0x4(%esp)
80105db5:	e8 96 a8 ff ff       	call   80100650 <cprintf>
      panic("trap");
80105dba:	c7 04 24 9e 7a 10 80 	movl   $0x80107a9e,(%esp)
80105dc1:	e8 9a a5 ff ff       	call   80100360 <panic>
80105dc6:	66 90                	xchg   %ax,%ax
80105dc8:	66 90                	xchg   %ax,%ax
80105dca:	66 90                	xchg   %ax,%ax
80105dcc:	66 90                	xchg   %ax,%ax
80105dce:	66 90                	xchg   %ax,%ax

80105dd0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105dd0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105dd5:	55                   	push   %ebp
80105dd6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105dd8:	85 c0                	test   %eax,%eax
80105dda:	74 14                	je     80105df0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ddc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105de1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105de2:	a8 01                	test   $0x1,%al
80105de4:	74 0a                	je     80105df0 <uartgetc+0x20>
80105de6:	b2 f8                	mov    $0xf8,%dl
80105de8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105de9:	0f b6 c0             	movzbl %al,%eax
}
80105dec:	5d                   	pop    %ebp
80105ded:	c3                   	ret    
80105dee:	66 90                	xchg   %ax,%ax
    return -1;
80105df0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105df5:	5d                   	pop    %ebp
80105df6:	c3                   	ret    
80105df7:	89 f6                	mov    %esi,%esi
80105df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105e00 <uartputc>:
  if(!uart)
80105e00:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105e05:	85 c0                	test   %eax,%eax
80105e07:	74 3f                	je     80105e48 <uartputc+0x48>
{
80105e09:	55                   	push   %ebp
80105e0a:	89 e5                	mov    %esp,%ebp
80105e0c:	56                   	push   %esi
80105e0d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105e12:	53                   	push   %ebx
  if(!uart)
80105e13:	bb 80 00 00 00       	mov    $0x80,%ebx
{
80105e18:	83 ec 10             	sub    $0x10,%esp
80105e1b:	eb 14                	jmp    80105e31 <uartputc+0x31>
80105e1d:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105e20:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105e27:	e8 84 c9 ff ff       	call   801027b0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e2c:	83 eb 01             	sub    $0x1,%ebx
80105e2f:	74 07                	je     80105e38 <uartputc+0x38>
80105e31:	89 f2                	mov    %esi,%edx
80105e33:	ec                   	in     (%dx),%al
80105e34:	a8 20                	test   $0x20,%al
80105e36:	74 e8                	je     80105e20 <uartputc+0x20>
  outb(COM1+0, c);
80105e38:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e3c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e41:	ee                   	out    %al,(%dx)
}
80105e42:	83 c4 10             	add    $0x10,%esp
80105e45:	5b                   	pop    %ebx
80105e46:	5e                   	pop    %esi
80105e47:	5d                   	pop    %ebp
80105e48:	f3 c3                	repz ret 
80105e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105e50 <uartinit>:
{
80105e50:	55                   	push   %ebp
80105e51:	31 c9                	xor    %ecx,%ecx
80105e53:	89 e5                	mov    %esp,%ebp
80105e55:	89 c8                	mov    %ecx,%eax
80105e57:	57                   	push   %edi
80105e58:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105e5d:	56                   	push   %esi
80105e5e:	89 fa                	mov    %edi,%edx
80105e60:	53                   	push   %ebx
80105e61:	83 ec 1c             	sub    $0x1c,%esp
80105e64:	ee                   	out    %al,(%dx)
80105e65:	be fb 03 00 00       	mov    $0x3fb,%esi
80105e6a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105e6f:	89 f2                	mov    %esi,%edx
80105e71:	ee                   	out    %al,(%dx)
80105e72:	b8 0c 00 00 00       	mov    $0xc,%eax
80105e77:	b2 f8                	mov    $0xf8,%dl
80105e79:	ee                   	out    %al,(%dx)
80105e7a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105e7f:	89 c8                	mov    %ecx,%eax
80105e81:	89 da                	mov    %ebx,%edx
80105e83:	ee                   	out    %al,(%dx)
80105e84:	b8 03 00 00 00       	mov    $0x3,%eax
80105e89:	89 f2                	mov    %esi,%edx
80105e8b:	ee                   	out    %al,(%dx)
80105e8c:	b2 fc                	mov    $0xfc,%dl
80105e8e:	89 c8                	mov    %ecx,%eax
80105e90:	ee                   	out    %al,(%dx)
80105e91:	b8 01 00 00 00       	mov    $0x1,%eax
80105e96:	89 da                	mov    %ebx,%edx
80105e98:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e99:	b2 fd                	mov    $0xfd,%dl
80105e9b:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105e9c:	3c ff                	cmp    $0xff,%al
80105e9e:	74 42                	je     80105ee2 <uartinit+0x92>
  uart = 1;
80105ea0:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105ea7:	00 00 00 
80105eaa:	89 fa                	mov    %edi,%edx
80105eac:	ec                   	in     (%dx),%al
80105ead:	b2 f8                	mov    $0xf8,%dl
80105eaf:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105eb0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105eb7:	00 
  for(p="xv6...\n"; *p; p++)
80105eb8:	bb c0 7b 10 80       	mov    $0x80107bc0,%ebx
  ioapicenable(IRQ_COM1, 0);
80105ebd:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105ec4:	e8 f7 c3 ff ff       	call   801022c0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105ec9:	b8 78 00 00 00       	mov    $0x78,%eax
80105ece:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105ed0:	89 04 24             	mov    %eax,(%esp)
  for(p="xv6...\n"; *p; p++)
80105ed3:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105ed6:	e8 25 ff ff ff       	call   80105e00 <uartputc>
  for(p="xv6...\n"; *p; p++)
80105edb:	0f be 03             	movsbl (%ebx),%eax
80105ede:	84 c0                	test   %al,%al
80105ee0:	75 ee                	jne    80105ed0 <uartinit+0x80>
}
80105ee2:	83 c4 1c             	add    $0x1c,%esp
80105ee5:	5b                   	pop    %ebx
80105ee6:	5e                   	pop    %esi
80105ee7:	5f                   	pop    %edi
80105ee8:	5d                   	pop    %ebp
80105ee9:	c3                   	ret    
80105eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ef0 <uartintr>:

void
uartintr(void)
{
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105ef6:	c7 04 24 d0 5d 10 80 	movl   $0x80105dd0,(%esp)
80105efd:	e8 ae a8 ff ff       	call   801007b0 <consoleintr>
}
80105f02:	c9                   	leave  
80105f03:	c3                   	ret    

80105f04 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105f04:	6a 00                	push   $0x0
  pushl $0
80105f06:	6a 00                	push   $0x0
  jmp alltraps
80105f08:	e9 5c fb ff ff       	jmp    80105a69 <alltraps>

80105f0d <vector1>:
.globl vector1
vector1:
  pushl $0
80105f0d:	6a 00                	push   $0x0
  pushl $1
80105f0f:	6a 01                	push   $0x1
  jmp alltraps
80105f11:	e9 53 fb ff ff       	jmp    80105a69 <alltraps>

80105f16 <vector2>:
.globl vector2
vector2:
  pushl $0
80105f16:	6a 00                	push   $0x0
  pushl $2
80105f18:	6a 02                	push   $0x2
  jmp alltraps
80105f1a:	e9 4a fb ff ff       	jmp    80105a69 <alltraps>

80105f1f <vector3>:
.globl vector3
vector3:
  pushl $0
80105f1f:	6a 00                	push   $0x0
  pushl $3
80105f21:	6a 03                	push   $0x3
  jmp alltraps
80105f23:	e9 41 fb ff ff       	jmp    80105a69 <alltraps>

80105f28 <vector4>:
.globl vector4
vector4:
  pushl $0
80105f28:	6a 00                	push   $0x0
  pushl $4
80105f2a:	6a 04                	push   $0x4
  jmp alltraps
80105f2c:	e9 38 fb ff ff       	jmp    80105a69 <alltraps>

80105f31 <vector5>:
.globl vector5
vector5:
  pushl $0
80105f31:	6a 00                	push   $0x0
  pushl $5
80105f33:	6a 05                	push   $0x5
  jmp alltraps
80105f35:	e9 2f fb ff ff       	jmp    80105a69 <alltraps>

80105f3a <vector6>:
.globl vector6
vector6:
  pushl $0
80105f3a:	6a 00                	push   $0x0
  pushl $6
80105f3c:	6a 06                	push   $0x6
  jmp alltraps
80105f3e:	e9 26 fb ff ff       	jmp    80105a69 <alltraps>

80105f43 <vector7>:
.globl vector7
vector7:
  pushl $0
80105f43:	6a 00                	push   $0x0
  pushl $7
80105f45:	6a 07                	push   $0x7
  jmp alltraps
80105f47:	e9 1d fb ff ff       	jmp    80105a69 <alltraps>

80105f4c <vector8>:
.globl vector8
vector8:
  pushl $8
80105f4c:	6a 08                	push   $0x8
  jmp alltraps
80105f4e:	e9 16 fb ff ff       	jmp    80105a69 <alltraps>

80105f53 <vector9>:
.globl vector9
vector9:
  pushl $0
80105f53:	6a 00                	push   $0x0
  pushl $9
80105f55:	6a 09                	push   $0x9
  jmp alltraps
80105f57:	e9 0d fb ff ff       	jmp    80105a69 <alltraps>

80105f5c <vector10>:
.globl vector10
vector10:
  pushl $10
80105f5c:	6a 0a                	push   $0xa
  jmp alltraps
80105f5e:	e9 06 fb ff ff       	jmp    80105a69 <alltraps>

80105f63 <vector11>:
.globl vector11
vector11:
  pushl $11
80105f63:	6a 0b                	push   $0xb
  jmp alltraps
80105f65:	e9 ff fa ff ff       	jmp    80105a69 <alltraps>

80105f6a <vector12>:
.globl vector12
vector12:
  pushl $12
80105f6a:	6a 0c                	push   $0xc
  jmp alltraps
80105f6c:	e9 f8 fa ff ff       	jmp    80105a69 <alltraps>

80105f71 <vector13>:
.globl vector13
vector13:
  pushl $13
80105f71:	6a 0d                	push   $0xd
  jmp alltraps
80105f73:	e9 f1 fa ff ff       	jmp    80105a69 <alltraps>

80105f78 <vector14>:
.globl vector14
vector14:
  pushl $14
80105f78:	6a 0e                	push   $0xe
  jmp alltraps
80105f7a:	e9 ea fa ff ff       	jmp    80105a69 <alltraps>

80105f7f <vector15>:
.globl vector15
vector15:
  pushl $0
80105f7f:	6a 00                	push   $0x0
  pushl $15
80105f81:	6a 0f                	push   $0xf
  jmp alltraps
80105f83:	e9 e1 fa ff ff       	jmp    80105a69 <alltraps>

80105f88 <vector16>:
.globl vector16
vector16:
  pushl $0
80105f88:	6a 00                	push   $0x0
  pushl $16
80105f8a:	6a 10                	push   $0x10
  jmp alltraps
80105f8c:	e9 d8 fa ff ff       	jmp    80105a69 <alltraps>

80105f91 <vector17>:
.globl vector17
vector17:
  pushl $17
80105f91:	6a 11                	push   $0x11
  jmp alltraps
80105f93:	e9 d1 fa ff ff       	jmp    80105a69 <alltraps>

80105f98 <vector18>:
.globl vector18
vector18:
  pushl $0
80105f98:	6a 00                	push   $0x0
  pushl $18
80105f9a:	6a 12                	push   $0x12
  jmp alltraps
80105f9c:	e9 c8 fa ff ff       	jmp    80105a69 <alltraps>

80105fa1 <vector19>:
.globl vector19
vector19:
  pushl $0
80105fa1:	6a 00                	push   $0x0
  pushl $19
80105fa3:	6a 13                	push   $0x13
  jmp alltraps
80105fa5:	e9 bf fa ff ff       	jmp    80105a69 <alltraps>

80105faa <vector20>:
.globl vector20
vector20:
  pushl $0
80105faa:	6a 00                	push   $0x0
  pushl $20
80105fac:	6a 14                	push   $0x14
  jmp alltraps
80105fae:	e9 b6 fa ff ff       	jmp    80105a69 <alltraps>

80105fb3 <vector21>:
.globl vector21
vector21:
  pushl $0
80105fb3:	6a 00                	push   $0x0
  pushl $21
80105fb5:	6a 15                	push   $0x15
  jmp alltraps
80105fb7:	e9 ad fa ff ff       	jmp    80105a69 <alltraps>

80105fbc <vector22>:
.globl vector22
vector22:
  pushl $0
80105fbc:	6a 00                	push   $0x0
  pushl $22
80105fbe:	6a 16                	push   $0x16
  jmp alltraps
80105fc0:	e9 a4 fa ff ff       	jmp    80105a69 <alltraps>

80105fc5 <vector23>:
.globl vector23
vector23:
  pushl $0
80105fc5:	6a 00                	push   $0x0
  pushl $23
80105fc7:	6a 17                	push   $0x17
  jmp alltraps
80105fc9:	e9 9b fa ff ff       	jmp    80105a69 <alltraps>

80105fce <vector24>:
.globl vector24
vector24:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $24
80105fd0:	6a 18                	push   $0x18
  jmp alltraps
80105fd2:	e9 92 fa ff ff       	jmp    80105a69 <alltraps>

80105fd7 <vector25>:
.globl vector25
vector25:
  pushl $0
80105fd7:	6a 00                	push   $0x0
  pushl $25
80105fd9:	6a 19                	push   $0x19
  jmp alltraps
80105fdb:	e9 89 fa ff ff       	jmp    80105a69 <alltraps>

80105fe0 <vector26>:
.globl vector26
vector26:
  pushl $0
80105fe0:	6a 00                	push   $0x0
  pushl $26
80105fe2:	6a 1a                	push   $0x1a
  jmp alltraps
80105fe4:	e9 80 fa ff ff       	jmp    80105a69 <alltraps>

80105fe9 <vector27>:
.globl vector27
vector27:
  pushl $0
80105fe9:	6a 00                	push   $0x0
  pushl $27
80105feb:	6a 1b                	push   $0x1b
  jmp alltraps
80105fed:	e9 77 fa ff ff       	jmp    80105a69 <alltraps>

80105ff2 <vector28>:
.globl vector28
vector28:
  pushl $0
80105ff2:	6a 00                	push   $0x0
  pushl $28
80105ff4:	6a 1c                	push   $0x1c
  jmp alltraps
80105ff6:	e9 6e fa ff ff       	jmp    80105a69 <alltraps>

80105ffb <vector29>:
.globl vector29
vector29:
  pushl $0
80105ffb:	6a 00                	push   $0x0
  pushl $29
80105ffd:	6a 1d                	push   $0x1d
  jmp alltraps
80105fff:	e9 65 fa ff ff       	jmp    80105a69 <alltraps>

80106004 <vector30>:
.globl vector30
vector30:
  pushl $0
80106004:	6a 00                	push   $0x0
  pushl $30
80106006:	6a 1e                	push   $0x1e
  jmp alltraps
80106008:	e9 5c fa ff ff       	jmp    80105a69 <alltraps>

8010600d <vector31>:
.globl vector31
vector31:
  pushl $0
8010600d:	6a 00                	push   $0x0
  pushl $31
8010600f:	6a 1f                	push   $0x1f
  jmp alltraps
80106011:	e9 53 fa ff ff       	jmp    80105a69 <alltraps>

80106016 <vector32>:
.globl vector32
vector32:
  pushl $0
80106016:	6a 00                	push   $0x0
  pushl $32
80106018:	6a 20                	push   $0x20
  jmp alltraps
8010601a:	e9 4a fa ff ff       	jmp    80105a69 <alltraps>

8010601f <vector33>:
.globl vector33
vector33:
  pushl $0
8010601f:	6a 00                	push   $0x0
  pushl $33
80106021:	6a 21                	push   $0x21
  jmp alltraps
80106023:	e9 41 fa ff ff       	jmp    80105a69 <alltraps>

80106028 <vector34>:
.globl vector34
vector34:
  pushl $0
80106028:	6a 00                	push   $0x0
  pushl $34
8010602a:	6a 22                	push   $0x22
  jmp alltraps
8010602c:	e9 38 fa ff ff       	jmp    80105a69 <alltraps>

80106031 <vector35>:
.globl vector35
vector35:
  pushl $0
80106031:	6a 00                	push   $0x0
  pushl $35
80106033:	6a 23                	push   $0x23
  jmp alltraps
80106035:	e9 2f fa ff ff       	jmp    80105a69 <alltraps>

8010603a <vector36>:
.globl vector36
vector36:
  pushl $0
8010603a:	6a 00                	push   $0x0
  pushl $36
8010603c:	6a 24                	push   $0x24
  jmp alltraps
8010603e:	e9 26 fa ff ff       	jmp    80105a69 <alltraps>

80106043 <vector37>:
.globl vector37
vector37:
  pushl $0
80106043:	6a 00                	push   $0x0
  pushl $37
80106045:	6a 25                	push   $0x25
  jmp alltraps
80106047:	e9 1d fa ff ff       	jmp    80105a69 <alltraps>

8010604c <vector38>:
.globl vector38
vector38:
  pushl $0
8010604c:	6a 00                	push   $0x0
  pushl $38
8010604e:	6a 26                	push   $0x26
  jmp alltraps
80106050:	e9 14 fa ff ff       	jmp    80105a69 <alltraps>

80106055 <vector39>:
.globl vector39
vector39:
  pushl $0
80106055:	6a 00                	push   $0x0
  pushl $39
80106057:	6a 27                	push   $0x27
  jmp alltraps
80106059:	e9 0b fa ff ff       	jmp    80105a69 <alltraps>

8010605e <vector40>:
.globl vector40
vector40:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $40
80106060:	6a 28                	push   $0x28
  jmp alltraps
80106062:	e9 02 fa ff ff       	jmp    80105a69 <alltraps>

80106067 <vector41>:
.globl vector41
vector41:
  pushl $0
80106067:	6a 00                	push   $0x0
  pushl $41
80106069:	6a 29                	push   $0x29
  jmp alltraps
8010606b:	e9 f9 f9 ff ff       	jmp    80105a69 <alltraps>

80106070 <vector42>:
.globl vector42
vector42:
  pushl $0
80106070:	6a 00                	push   $0x0
  pushl $42
80106072:	6a 2a                	push   $0x2a
  jmp alltraps
80106074:	e9 f0 f9 ff ff       	jmp    80105a69 <alltraps>

80106079 <vector43>:
.globl vector43
vector43:
  pushl $0
80106079:	6a 00                	push   $0x0
  pushl $43
8010607b:	6a 2b                	push   $0x2b
  jmp alltraps
8010607d:	e9 e7 f9 ff ff       	jmp    80105a69 <alltraps>

80106082 <vector44>:
.globl vector44
vector44:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $44
80106084:	6a 2c                	push   $0x2c
  jmp alltraps
80106086:	e9 de f9 ff ff       	jmp    80105a69 <alltraps>

8010608b <vector45>:
.globl vector45
vector45:
  pushl $0
8010608b:	6a 00                	push   $0x0
  pushl $45
8010608d:	6a 2d                	push   $0x2d
  jmp alltraps
8010608f:	e9 d5 f9 ff ff       	jmp    80105a69 <alltraps>

80106094 <vector46>:
.globl vector46
vector46:
  pushl $0
80106094:	6a 00                	push   $0x0
  pushl $46
80106096:	6a 2e                	push   $0x2e
  jmp alltraps
80106098:	e9 cc f9 ff ff       	jmp    80105a69 <alltraps>

8010609d <vector47>:
.globl vector47
vector47:
  pushl $0
8010609d:	6a 00                	push   $0x0
  pushl $47
8010609f:	6a 2f                	push   $0x2f
  jmp alltraps
801060a1:	e9 c3 f9 ff ff       	jmp    80105a69 <alltraps>

801060a6 <vector48>:
.globl vector48
vector48:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $48
801060a8:	6a 30                	push   $0x30
  jmp alltraps
801060aa:	e9 ba f9 ff ff       	jmp    80105a69 <alltraps>

801060af <vector49>:
.globl vector49
vector49:
  pushl $0
801060af:	6a 00                	push   $0x0
  pushl $49
801060b1:	6a 31                	push   $0x31
  jmp alltraps
801060b3:	e9 b1 f9 ff ff       	jmp    80105a69 <alltraps>

801060b8 <vector50>:
.globl vector50
vector50:
  pushl $0
801060b8:	6a 00                	push   $0x0
  pushl $50
801060ba:	6a 32                	push   $0x32
  jmp alltraps
801060bc:	e9 a8 f9 ff ff       	jmp    80105a69 <alltraps>

801060c1 <vector51>:
.globl vector51
vector51:
  pushl $0
801060c1:	6a 00                	push   $0x0
  pushl $51
801060c3:	6a 33                	push   $0x33
  jmp alltraps
801060c5:	e9 9f f9 ff ff       	jmp    80105a69 <alltraps>

801060ca <vector52>:
.globl vector52
vector52:
  pushl $0
801060ca:	6a 00                	push   $0x0
  pushl $52
801060cc:	6a 34                	push   $0x34
  jmp alltraps
801060ce:	e9 96 f9 ff ff       	jmp    80105a69 <alltraps>

801060d3 <vector53>:
.globl vector53
vector53:
  pushl $0
801060d3:	6a 00                	push   $0x0
  pushl $53
801060d5:	6a 35                	push   $0x35
  jmp alltraps
801060d7:	e9 8d f9 ff ff       	jmp    80105a69 <alltraps>

801060dc <vector54>:
.globl vector54
vector54:
  pushl $0
801060dc:	6a 00                	push   $0x0
  pushl $54
801060de:	6a 36                	push   $0x36
  jmp alltraps
801060e0:	e9 84 f9 ff ff       	jmp    80105a69 <alltraps>

801060e5 <vector55>:
.globl vector55
vector55:
  pushl $0
801060e5:	6a 00                	push   $0x0
  pushl $55
801060e7:	6a 37                	push   $0x37
  jmp alltraps
801060e9:	e9 7b f9 ff ff       	jmp    80105a69 <alltraps>

801060ee <vector56>:
.globl vector56
vector56:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $56
801060f0:	6a 38                	push   $0x38
  jmp alltraps
801060f2:	e9 72 f9 ff ff       	jmp    80105a69 <alltraps>

801060f7 <vector57>:
.globl vector57
vector57:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $57
801060f9:	6a 39                	push   $0x39
  jmp alltraps
801060fb:	e9 69 f9 ff ff       	jmp    80105a69 <alltraps>

80106100 <vector58>:
.globl vector58
vector58:
  pushl $0
80106100:	6a 00                	push   $0x0
  pushl $58
80106102:	6a 3a                	push   $0x3a
  jmp alltraps
80106104:	e9 60 f9 ff ff       	jmp    80105a69 <alltraps>

80106109 <vector59>:
.globl vector59
vector59:
  pushl $0
80106109:	6a 00                	push   $0x0
  pushl $59
8010610b:	6a 3b                	push   $0x3b
  jmp alltraps
8010610d:	e9 57 f9 ff ff       	jmp    80105a69 <alltraps>

80106112 <vector60>:
.globl vector60
vector60:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $60
80106114:	6a 3c                	push   $0x3c
  jmp alltraps
80106116:	e9 4e f9 ff ff       	jmp    80105a69 <alltraps>

8010611b <vector61>:
.globl vector61
vector61:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $61
8010611d:	6a 3d                	push   $0x3d
  jmp alltraps
8010611f:	e9 45 f9 ff ff       	jmp    80105a69 <alltraps>

80106124 <vector62>:
.globl vector62
vector62:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $62
80106126:	6a 3e                	push   $0x3e
  jmp alltraps
80106128:	e9 3c f9 ff ff       	jmp    80105a69 <alltraps>

8010612d <vector63>:
.globl vector63
vector63:
  pushl $0
8010612d:	6a 00                	push   $0x0
  pushl $63
8010612f:	6a 3f                	push   $0x3f
  jmp alltraps
80106131:	e9 33 f9 ff ff       	jmp    80105a69 <alltraps>

80106136 <vector64>:
.globl vector64
vector64:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $64
80106138:	6a 40                	push   $0x40
  jmp alltraps
8010613a:	e9 2a f9 ff ff       	jmp    80105a69 <alltraps>

8010613f <vector65>:
.globl vector65
vector65:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $65
80106141:	6a 41                	push   $0x41
  jmp alltraps
80106143:	e9 21 f9 ff ff       	jmp    80105a69 <alltraps>

80106148 <vector66>:
.globl vector66
vector66:
  pushl $0
80106148:	6a 00                	push   $0x0
  pushl $66
8010614a:	6a 42                	push   $0x42
  jmp alltraps
8010614c:	e9 18 f9 ff ff       	jmp    80105a69 <alltraps>

80106151 <vector67>:
.globl vector67
vector67:
  pushl $0
80106151:	6a 00                	push   $0x0
  pushl $67
80106153:	6a 43                	push   $0x43
  jmp alltraps
80106155:	e9 0f f9 ff ff       	jmp    80105a69 <alltraps>

8010615a <vector68>:
.globl vector68
vector68:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $68
8010615c:	6a 44                	push   $0x44
  jmp alltraps
8010615e:	e9 06 f9 ff ff       	jmp    80105a69 <alltraps>

80106163 <vector69>:
.globl vector69
vector69:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $69
80106165:	6a 45                	push   $0x45
  jmp alltraps
80106167:	e9 fd f8 ff ff       	jmp    80105a69 <alltraps>

8010616c <vector70>:
.globl vector70
vector70:
  pushl $0
8010616c:	6a 00                	push   $0x0
  pushl $70
8010616e:	6a 46                	push   $0x46
  jmp alltraps
80106170:	e9 f4 f8 ff ff       	jmp    80105a69 <alltraps>

80106175 <vector71>:
.globl vector71
vector71:
  pushl $0
80106175:	6a 00                	push   $0x0
  pushl $71
80106177:	6a 47                	push   $0x47
  jmp alltraps
80106179:	e9 eb f8 ff ff       	jmp    80105a69 <alltraps>

8010617e <vector72>:
.globl vector72
vector72:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $72
80106180:	6a 48                	push   $0x48
  jmp alltraps
80106182:	e9 e2 f8 ff ff       	jmp    80105a69 <alltraps>

80106187 <vector73>:
.globl vector73
vector73:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $73
80106189:	6a 49                	push   $0x49
  jmp alltraps
8010618b:	e9 d9 f8 ff ff       	jmp    80105a69 <alltraps>

80106190 <vector74>:
.globl vector74
vector74:
  pushl $0
80106190:	6a 00                	push   $0x0
  pushl $74
80106192:	6a 4a                	push   $0x4a
  jmp alltraps
80106194:	e9 d0 f8 ff ff       	jmp    80105a69 <alltraps>

80106199 <vector75>:
.globl vector75
vector75:
  pushl $0
80106199:	6a 00                	push   $0x0
  pushl $75
8010619b:	6a 4b                	push   $0x4b
  jmp alltraps
8010619d:	e9 c7 f8 ff ff       	jmp    80105a69 <alltraps>

801061a2 <vector76>:
.globl vector76
vector76:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $76
801061a4:	6a 4c                	push   $0x4c
  jmp alltraps
801061a6:	e9 be f8 ff ff       	jmp    80105a69 <alltraps>

801061ab <vector77>:
.globl vector77
vector77:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $77
801061ad:	6a 4d                	push   $0x4d
  jmp alltraps
801061af:	e9 b5 f8 ff ff       	jmp    80105a69 <alltraps>

801061b4 <vector78>:
.globl vector78
vector78:
  pushl $0
801061b4:	6a 00                	push   $0x0
  pushl $78
801061b6:	6a 4e                	push   $0x4e
  jmp alltraps
801061b8:	e9 ac f8 ff ff       	jmp    80105a69 <alltraps>

801061bd <vector79>:
.globl vector79
vector79:
  pushl $0
801061bd:	6a 00                	push   $0x0
  pushl $79
801061bf:	6a 4f                	push   $0x4f
  jmp alltraps
801061c1:	e9 a3 f8 ff ff       	jmp    80105a69 <alltraps>

801061c6 <vector80>:
.globl vector80
vector80:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $80
801061c8:	6a 50                	push   $0x50
  jmp alltraps
801061ca:	e9 9a f8 ff ff       	jmp    80105a69 <alltraps>

801061cf <vector81>:
.globl vector81
vector81:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $81
801061d1:	6a 51                	push   $0x51
  jmp alltraps
801061d3:	e9 91 f8 ff ff       	jmp    80105a69 <alltraps>

801061d8 <vector82>:
.globl vector82
vector82:
  pushl $0
801061d8:	6a 00                	push   $0x0
  pushl $82
801061da:	6a 52                	push   $0x52
  jmp alltraps
801061dc:	e9 88 f8 ff ff       	jmp    80105a69 <alltraps>

801061e1 <vector83>:
.globl vector83
vector83:
  pushl $0
801061e1:	6a 00                	push   $0x0
  pushl $83
801061e3:	6a 53                	push   $0x53
  jmp alltraps
801061e5:	e9 7f f8 ff ff       	jmp    80105a69 <alltraps>

801061ea <vector84>:
.globl vector84
vector84:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $84
801061ec:	6a 54                	push   $0x54
  jmp alltraps
801061ee:	e9 76 f8 ff ff       	jmp    80105a69 <alltraps>

801061f3 <vector85>:
.globl vector85
vector85:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $85
801061f5:	6a 55                	push   $0x55
  jmp alltraps
801061f7:	e9 6d f8 ff ff       	jmp    80105a69 <alltraps>

801061fc <vector86>:
.globl vector86
vector86:
  pushl $0
801061fc:	6a 00                	push   $0x0
  pushl $86
801061fe:	6a 56                	push   $0x56
  jmp alltraps
80106200:	e9 64 f8 ff ff       	jmp    80105a69 <alltraps>

80106205 <vector87>:
.globl vector87
vector87:
  pushl $0
80106205:	6a 00                	push   $0x0
  pushl $87
80106207:	6a 57                	push   $0x57
  jmp alltraps
80106209:	e9 5b f8 ff ff       	jmp    80105a69 <alltraps>

8010620e <vector88>:
.globl vector88
vector88:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $88
80106210:	6a 58                	push   $0x58
  jmp alltraps
80106212:	e9 52 f8 ff ff       	jmp    80105a69 <alltraps>

80106217 <vector89>:
.globl vector89
vector89:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $89
80106219:	6a 59                	push   $0x59
  jmp alltraps
8010621b:	e9 49 f8 ff ff       	jmp    80105a69 <alltraps>

80106220 <vector90>:
.globl vector90
vector90:
  pushl $0
80106220:	6a 00                	push   $0x0
  pushl $90
80106222:	6a 5a                	push   $0x5a
  jmp alltraps
80106224:	e9 40 f8 ff ff       	jmp    80105a69 <alltraps>

80106229 <vector91>:
.globl vector91
vector91:
  pushl $0
80106229:	6a 00                	push   $0x0
  pushl $91
8010622b:	6a 5b                	push   $0x5b
  jmp alltraps
8010622d:	e9 37 f8 ff ff       	jmp    80105a69 <alltraps>

80106232 <vector92>:
.globl vector92
vector92:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $92
80106234:	6a 5c                	push   $0x5c
  jmp alltraps
80106236:	e9 2e f8 ff ff       	jmp    80105a69 <alltraps>

8010623b <vector93>:
.globl vector93
vector93:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $93
8010623d:	6a 5d                	push   $0x5d
  jmp alltraps
8010623f:	e9 25 f8 ff ff       	jmp    80105a69 <alltraps>

80106244 <vector94>:
.globl vector94
vector94:
  pushl $0
80106244:	6a 00                	push   $0x0
  pushl $94
80106246:	6a 5e                	push   $0x5e
  jmp alltraps
80106248:	e9 1c f8 ff ff       	jmp    80105a69 <alltraps>

8010624d <vector95>:
.globl vector95
vector95:
  pushl $0
8010624d:	6a 00                	push   $0x0
  pushl $95
8010624f:	6a 5f                	push   $0x5f
  jmp alltraps
80106251:	e9 13 f8 ff ff       	jmp    80105a69 <alltraps>

80106256 <vector96>:
.globl vector96
vector96:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $96
80106258:	6a 60                	push   $0x60
  jmp alltraps
8010625a:	e9 0a f8 ff ff       	jmp    80105a69 <alltraps>

8010625f <vector97>:
.globl vector97
vector97:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $97
80106261:	6a 61                	push   $0x61
  jmp alltraps
80106263:	e9 01 f8 ff ff       	jmp    80105a69 <alltraps>

80106268 <vector98>:
.globl vector98
vector98:
  pushl $0
80106268:	6a 00                	push   $0x0
  pushl $98
8010626a:	6a 62                	push   $0x62
  jmp alltraps
8010626c:	e9 f8 f7 ff ff       	jmp    80105a69 <alltraps>

80106271 <vector99>:
.globl vector99
vector99:
  pushl $0
80106271:	6a 00                	push   $0x0
  pushl $99
80106273:	6a 63                	push   $0x63
  jmp alltraps
80106275:	e9 ef f7 ff ff       	jmp    80105a69 <alltraps>

8010627a <vector100>:
.globl vector100
vector100:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $100
8010627c:	6a 64                	push   $0x64
  jmp alltraps
8010627e:	e9 e6 f7 ff ff       	jmp    80105a69 <alltraps>

80106283 <vector101>:
.globl vector101
vector101:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $101
80106285:	6a 65                	push   $0x65
  jmp alltraps
80106287:	e9 dd f7 ff ff       	jmp    80105a69 <alltraps>

8010628c <vector102>:
.globl vector102
vector102:
  pushl $0
8010628c:	6a 00                	push   $0x0
  pushl $102
8010628e:	6a 66                	push   $0x66
  jmp alltraps
80106290:	e9 d4 f7 ff ff       	jmp    80105a69 <alltraps>

80106295 <vector103>:
.globl vector103
vector103:
  pushl $0
80106295:	6a 00                	push   $0x0
  pushl $103
80106297:	6a 67                	push   $0x67
  jmp alltraps
80106299:	e9 cb f7 ff ff       	jmp    80105a69 <alltraps>

8010629e <vector104>:
.globl vector104
vector104:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $104
801062a0:	6a 68                	push   $0x68
  jmp alltraps
801062a2:	e9 c2 f7 ff ff       	jmp    80105a69 <alltraps>

801062a7 <vector105>:
.globl vector105
vector105:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $105
801062a9:	6a 69                	push   $0x69
  jmp alltraps
801062ab:	e9 b9 f7 ff ff       	jmp    80105a69 <alltraps>

801062b0 <vector106>:
.globl vector106
vector106:
  pushl $0
801062b0:	6a 00                	push   $0x0
  pushl $106
801062b2:	6a 6a                	push   $0x6a
  jmp alltraps
801062b4:	e9 b0 f7 ff ff       	jmp    80105a69 <alltraps>

801062b9 <vector107>:
.globl vector107
vector107:
  pushl $0
801062b9:	6a 00                	push   $0x0
  pushl $107
801062bb:	6a 6b                	push   $0x6b
  jmp alltraps
801062bd:	e9 a7 f7 ff ff       	jmp    80105a69 <alltraps>

801062c2 <vector108>:
.globl vector108
vector108:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $108
801062c4:	6a 6c                	push   $0x6c
  jmp alltraps
801062c6:	e9 9e f7 ff ff       	jmp    80105a69 <alltraps>

801062cb <vector109>:
.globl vector109
vector109:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $109
801062cd:	6a 6d                	push   $0x6d
  jmp alltraps
801062cf:	e9 95 f7 ff ff       	jmp    80105a69 <alltraps>

801062d4 <vector110>:
.globl vector110
vector110:
  pushl $0
801062d4:	6a 00                	push   $0x0
  pushl $110
801062d6:	6a 6e                	push   $0x6e
  jmp alltraps
801062d8:	e9 8c f7 ff ff       	jmp    80105a69 <alltraps>

801062dd <vector111>:
.globl vector111
vector111:
  pushl $0
801062dd:	6a 00                	push   $0x0
  pushl $111
801062df:	6a 6f                	push   $0x6f
  jmp alltraps
801062e1:	e9 83 f7 ff ff       	jmp    80105a69 <alltraps>

801062e6 <vector112>:
.globl vector112
vector112:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $112
801062e8:	6a 70                	push   $0x70
  jmp alltraps
801062ea:	e9 7a f7 ff ff       	jmp    80105a69 <alltraps>

801062ef <vector113>:
.globl vector113
vector113:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $113
801062f1:	6a 71                	push   $0x71
  jmp alltraps
801062f3:	e9 71 f7 ff ff       	jmp    80105a69 <alltraps>

801062f8 <vector114>:
.globl vector114
vector114:
  pushl $0
801062f8:	6a 00                	push   $0x0
  pushl $114
801062fa:	6a 72                	push   $0x72
  jmp alltraps
801062fc:	e9 68 f7 ff ff       	jmp    80105a69 <alltraps>

80106301 <vector115>:
.globl vector115
vector115:
  pushl $0
80106301:	6a 00                	push   $0x0
  pushl $115
80106303:	6a 73                	push   $0x73
  jmp alltraps
80106305:	e9 5f f7 ff ff       	jmp    80105a69 <alltraps>

8010630a <vector116>:
.globl vector116
vector116:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $116
8010630c:	6a 74                	push   $0x74
  jmp alltraps
8010630e:	e9 56 f7 ff ff       	jmp    80105a69 <alltraps>

80106313 <vector117>:
.globl vector117
vector117:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $117
80106315:	6a 75                	push   $0x75
  jmp alltraps
80106317:	e9 4d f7 ff ff       	jmp    80105a69 <alltraps>

8010631c <vector118>:
.globl vector118
vector118:
  pushl $0
8010631c:	6a 00                	push   $0x0
  pushl $118
8010631e:	6a 76                	push   $0x76
  jmp alltraps
80106320:	e9 44 f7 ff ff       	jmp    80105a69 <alltraps>

80106325 <vector119>:
.globl vector119
vector119:
  pushl $0
80106325:	6a 00                	push   $0x0
  pushl $119
80106327:	6a 77                	push   $0x77
  jmp alltraps
80106329:	e9 3b f7 ff ff       	jmp    80105a69 <alltraps>

8010632e <vector120>:
.globl vector120
vector120:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $120
80106330:	6a 78                	push   $0x78
  jmp alltraps
80106332:	e9 32 f7 ff ff       	jmp    80105a69 <alltraps>

80106337 <vector121>:
.globl vector121
vector121:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $121
80106339:	6a 79                	push   $0x79
  jmp alltraps
8010633b:	e9 29 f7 ff ff       	jmp    80105a69 <alltraps>

80106340 <vector122>:
.globl vector122
vector122:
  pushl $0
80106340:	6a 00                	push   $0x0
  pushl $122
80106342:	6a 7a                	push   $0x7a
  jmp alltraps
80106344:	e9 20 f7 ff ff       	jmp    80105a69 <alltraps>

80106349 <vector123>:
.globl vector123
vector123:
  pushl $0
80106349:	6a 00                	push   $0x0
  pushl $123
8010634b:	6a 7b                	push   $0x7b
  jmp alltraps
8010634d:	e9 17 f7 ff ff       	jmp    80105a69 <alltraps>

80106352 <vector124>:
.globl vector124
vector124:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $124
80106354:	6a 7c                	push   $0x7c
  jmp alltraps
80106356:	e9 0e f7 ff ff       	jmp    80105a69 <alltraps>

8010635b <vector125>:
.globl vector125
vector125:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $125
8010635d:	6a 7d                	push   $0x7d
  jmp alltraps
8010635f:	e9 05 f7 ff ff       	jmp    80105a69 <alltraps>

80106364 <vector126>:
.globl vector126
vector126:
  pushl $0
80106364:	6a 00                	push   $0x0
  pushl $126
80106366:	6a 7e                	push   $0x7e
  jmp alltraps
80106368:	e9 fc f6 ff ff       	jmp    80105a69 <alltraps>

8010636d <vector127>:
.globl vector127
vector127:
  pushl $0
8010636d:	6a 00                	push   $0x0
  pushl $127
8010636f:	6a 7f                	push   $0x7f
  jmp alltraps
80106371:	e9 f3 f6 ff ff       	jmp    80105a69 <alltraps>

80106376 <vector128>:
.globl vector128
vector128:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $128
80106378:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010637d:	e9 e7 f6 ff ff       	jmp    80105a69 <alltraps>

80106382 <vector129>:
.globl vector129
vector129:
  pushl $0
80106382:	6a 00                	push   $0x0
  pushl $129
80106384:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106389:	e9 db f6 ff ff       	jmp    80105a69 <alltraps>

8010638e <vector130>:
.globl vector130
vector130:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $130
80106390:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106395:	e9 cf f6 ff ff       	jmp    80105a69 <alltraps>

8010639a <vector131>:
.globl vector131
vector131:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $131
8010639c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801063a1:	e9 c3 f6 ff ff       	jmp    80105a69 <alltraps>

801063a6 <vector132>:
.globl vector132
vector132:
  pushl $0
801063a6:	6a 00                	push   $0x0
  pushl $132
801063a8:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801063ad:	e9 b7 f6 ff ff       	jmp    80105a69 <alltraps>

801063b2 <vector133>:
.globl vector133
vector133:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $133
801063b4:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801063b9:	e9 ab f6 ff ff       	jmp    80105a69 <alltraps>

801063be <vector134>:
.globl vector134
vector134:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $134
801063c0:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801063c5:	e9 9f f6 ff ff       	jmp    80105a69 <alltraps>

801063ca <vector135>:
.globl vector135
vector135:
  pushl $0
801063ca:	6a 00                	push   $0x0
  pushl $135
801063cc:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801063d1:	e9 93 f6 ff ff       	jmp    80105a69 <alltraps>

801063d6 <vector136>:
.globl vector136
vector136:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $136
801063d8:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801063dd:	e9 87 f6 ff ff       	jmp    80105a69 <alltraps>

801063e2 <vector137>:
.globl vector137
vector137:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $137
801063e4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801063e9:	e9 7b f6 ff ff       	jmp    80105a69 <alltraps>

801063ee <vector138>:
.globl vector138
vector138:
  pushl $0
801063ee:	6a 00                	push   $0x0
  pushl $138
801063f0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801063f5:	e9 6f f6 ff ff       	jmp    80105a69 <alltraps>

801063fa <vector139>:
.globl vector139
vector139:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $139
801063fc:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106401:	e9 63 f6 ff ff       	jmp    80105a69 <alltraps>

80106406 <vector140>:
.globl vector140
vector140:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $140
80106408:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010640d:	e9 57 f6 ff ff       	jmp    80105a69 <alltraps>

80106412 <vector141>:
.globl vector141
vector141:
  pushl $0
80106412:	6a 00                	push   $0x0
  pushl $141
80106414:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106419:	e9 4b f6 ff ff       	jmp    80105a69 <alltraps>

8010641e <vector142>:
.globl vector142
vector142:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $142
80106420:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106425:	e9 3f f6 ff ff       	jmp    80105a69 <alltraps>

8010642a <vector143>:
.globl vector143
vector143:
  pushl $0
8010642a:	6a 00                	push   $0x0
  pushl $143
8010642c:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106431:	e9 33 f6 ff ff       	jmp    80105a69 <alltraps>

80106436 <vector144>:
.globl vector144
vector144:
  pushl $0
80106436:	6a 00                	push   $0x0
  pushl $144
80106438:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010643d:	e9 27 f6 ff ff       	jmp    80105a69 <alltraps>

80106442 <vector145>:
.globl vector145
vector145:
  pushl $0
80106442:	6a 00                	push   $0x0
  pushl $145
80106444:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106449:	e9 1b f6 ff ff       	jmp    80105a69 <alltraps>

8010644e <vector146>:
.globl vector146
vector146:
  pushl $0
8010644e:	6a 00                	push   $0x0
  pushl $146
80106450:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106455:	e9 0f f6 ff ff       	jmp    80105a69 <alltraps>

8010645a <vector147>:
.globl vector147
vector147:
  pushl $0
8010645a:	6a 00                	push   $0x0
  pushl $147
8010645c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106461:	e9 03 f6 ff ff       	jmp    80105a69 <alltraps>

80106466 <vector148>:
.globl vector148
vector148:
  pushl $0
80106466:	6a 00                	push   $0x0
  pushl $148
80106468:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010646d:	e9 f7 f5 ff ff       	jmp    80105a69 <alltraps>

80106472 <vector149>:
.globl vector149
vector149:
  pushl $0
80106472:	6a 00                	push   $0x0
  pushl $149
80106474:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106479:	e9 eb f5 ff ff       	jmp    80105a69 <alltraps>

8010647e <vector150>:
.globl vector150
vector150:
  pushl $0
8010647e:	6a 00                	push   $0x0
  pushl $150
80106480:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106485:	e9 df f5 ff ff       	jmp    80105a69 <alltraps>

8010648a <vector151>:
.globl vector151
vector151:
  pushl $0
8010648a:	6a 00                	push   $0x0
  pushl $151
8010648c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106491:	e9 d3 f5 ff ff       	jmp    80105a69 <alltraps>

80106496 <vector152>:
.globl vector152
vector152:
  pushl $0
80106496:	6a 00                	push   $0x0
  pushl $152
80106498:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010649d:	e9 c7 f5 ff ff       	jmp    80105a69 <alltraps>

801064a2 <vector153>:
.globl vector153
vector153:
  pushl $0
801064a2:	6a 00                	push   $0x0
  pushl $153
801064a4:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801064a9:	e9 bb f5 ff ff       	jmp    80105a69 <alltraps>

801064ae <vector154>:
.globl vector154
vector154:
  pushl $0
801064ae:	6a 00                	push   $0x0
  pushl $154
801064b0:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801064b5:	e9 af f5 ff ff       	jmp    80105a69 <alltraps>

801064ba <vector155>:
.globl vector155
vector155:
  pushl $0
801064ba:	6a 00                	push   $0x0
  pushl $155
801064bc:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801064c1:	e9 a3 f5 ff ff       	jmp    80105a69 <alltraps>

801064c6 <vector156>:
.globl vector156
vector156:
  pushl $0
801064c6:	6a 00                	push   $0x0
  pushl $156
801064c8:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801064cd:	e9 97 f5 ff ff       	jmp    80105a69 <alltraps>

801064d2 <vector157>:
.globl vector157
vector157:
  pushl $0
801064d2:	6a 00                	push   $0x0
  pushl $157
801064d4:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801064d9:	e9 8b f5 ff ff       	jmp    80105a69 <alltraps>

801064de <vector158>:
.globl vector158
vector158:
  pushl $0
801064de:	6a 00                	push   $0x0
  pushl $158
801064e0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801064e5:	e9 7f f5 ff ff       	jmp    80105a69 <alltraps>

801064ea <vector159>:
.globl vector159
vector159:
  pushl $0
801064ea:	6a 00                	push   $0x0
  pushl $159
801064ec:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801064f1:	e9 73 f5 ff ff       	jmp    80105a69 <alltraps>

801064f6 <vector160>:
.globl vector160
vector160:
  pushl $0
801064f6:	6a 00                	push   $0x0
  pushl $160
801064f8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801064fd:	e9 67 f5 ff ff       	jmp    80105a69 <alltraps>

80106502 <vector161>:
.globl vector161
vector161:
  pushl $0
80106502:	6a 00                	push   $0x0
  pushl $161
80106504:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106509:	e9 5b f5 ff ff       	jmp    80105a69 <alltraps>

8010650e <vector162>:
.globl vector162
vector162:
  pushl $0
8010650e:	6a 00                	push   $0x0
  pushl $162
80106510:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106515:	e9 4f f5 ff ff       	jmp    80105a69 <alltraps>

8010651a <vector163>:
.globl vector163
vector163:
  pushl $0
8010651a:	6a 00                	push   $0x0
  pushl $163
8010651c:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106521:	e9 43 f5 ff ff       	jmp    80105a69 <alltraps>

80106526 <vector164>:
.globl vector164
vector164:
  pushl $0
80106526:	6a 00                	push   $0x0
  pushl $164
80106528:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010652d:	e9 37 f5 ff ff       	jmp    80105a69 <alltraps>

80106532 <vector165>:
.globl vector165
vector165:
  pushl $0
80106532:	6a 00                	push   $0x0
  pushl $165
80106534:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106539:	e9 2b f5 ff ff       	jmp    80105a69 <alltraps>

8010653e <vector166>:
.globl vector166
vector166:
  pushl $0
8010653e:	6a 00                	push   $0x0
  pushl $166
80106540:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106545:	e9 1f f5 ff ff       	jmp    80105a69 <alltraps>

8010654a <vector167>:
.globl vector167
vector167:
  pushl $0
8010654a:	6a 00                	push   $0x0
  pushl $167
8010654c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106551:	e9 13 f5 ff ff       	jmp    80105a69 <alltraps>

80106556 <vector168>:
.globl vector168
vector168:
  pushl $0
80106556:	6a 00                	push   $0x0
  pushl $168
80106558:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010655d:	e9 07 f5 ff ff       	jmp    80105a69 <alltraps>

80106562 <vector169>:
.globl vector169
vector169:
  pushl $0
80106562:	6a 00                	push   $0x0
  pushl $169
80106564:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106569:	e9 fb f4 ff ff       	jmp    80105a69 <alltraps>

8010656e <vector170>:
.globl vector170
vector170:
  pushl $0
8010656e:	6a 00                	push   $0x0
  pushl $170
80106570:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106575:	e9 ef f4 ff ff       	jmp    80105a69 <alltraps>

8010657a <vector171>:
.globl vector171
vector171:
  pushl $0
8010657a:	6a 00                	push   $0x0
  pushl $171
8010657c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106581:	e9 e3 f4 ff ff       	jmp    80105a69 <alltraps>

80106586 <vector172>:
.globl vector172
vector172:
  pushl $0
80106586:	6a 00                	push   $0x0
  pushl $172
80106588:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010658d:	e9 d7 f4 ff ff       	jmp    80105a69 <alltraps>

80106592 <vector173>:
.globl vector173
vector173:
  pushl $0
80106592:	6a 00                	push   $0x0
  pushl $173
80106594:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106599:	e9 cb f4 ff ff       	jmp    80105a69 <alltraps>

8010659e <vector174>:
.globl vector174
vector174:
  pushl $0
8010659e:	6a 00                	push   $0x0
  pushl $174
801065a0:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801065a5:	e9 bf f4 ff ff       	jmp    80105a69 <alltraps>

801065aa <vector175>:
.globl vector175
vector175:
  pushl $0
801065aa:	6a 00                	push   $0x0
  pushl $175
801065ac:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801065b1:	e9 b3 f4 ff ff       	jmp    80105a69 <alltraps>

801065b6 <vector176>:
.globl vector176
vector176:
  pushl $0
801065b6:	6a 00                	push   $0x0
  pushl $176
801065b8:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801065bd:	e9 a7 f4 ff ff       	jmp    80105a69 <alltraps>

801065c2 <vector177>:
.globl vector177
vector177:
  pushl $0
801065c2:	6a 00                	push   $0x0
  pushl $177
801065c4:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801065c9:	e9 9b f4 ff ff       	jmp    80105a69 <alltraps>

801065ce <vector178>:
.globl vector178
vector178:
  pushl $0
801065ce:	6a 00                	push   $0x0
  pushl $178
801065d0:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801065d5:	e9 8f f4 ff ff       	jmp    80105a69 <alltraps>

801065da <vector179>:
.globl vector179
vector179:
  pushl $0
801065da:	6a 00                	push   $0x0
  pushl $179
801065dc:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801065e1:	e9 83 f4 ff ff       	jmp    80105a69 <alltraps>

801065e6 <vector180>:
.globl vector180
vector180:
  pushl $0
801065e6:	6a 00                	push   $0x0
  pushl $180
801065e8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801065ed:	e9 77 f4 ff ff       	jmp    80105a69 <alltraps>

801065f2 <vector181>:
.globl vector181
vector181:
  pushl $0
801065f2:	6a 00                	push   $0x0
  pushl $181
801065f4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801065f9:	e9 6b f4 ff ff       	jmp    80105a69 <alltraps>

801065fe <vector182>:
.globl vector182
vector182:
  pushl $0
801065fe:	6a 00                	push   $0x0
  pushl $182
80106600:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106605:	e9 5f f4 ff ff       	jmp    80105a69 <alltraps>

8010660a <vector183>:
.globl vector183
vector183:
  pushl $0
8010660a:	6a 00                	push   $0x0
  pushl $183
8010660c:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106611:	e9 53 f4 ff ff       	jmp    80105a69 <alltraps>

80106616 <vector184>:
.globl vector184
vector184:
  pushl $0
80106616:	6a 00                	push   $0x0
  pushl $184
80106618:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010661d:	e9 47 f4 ff ff       	jmp    80105a69 <alltraps>

80106622 <vector185>:
.globl vector185
vector185:
  pushl $0
80106622:	6a 00                	push   $0x0
  pushl $185
80106624:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106629:	e9 3b f4 ff ff       	jmp    80105a69 <alltraps>

8010662e <vector186>:
.globl vector186
vector186:
  pushl $0
8010662e:	6a 00                	push   $0x0
  pushl $186
80106630:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106635:	e9 2f f4 ff ff       	jmp    80105a69 <alltraps>

8010663a <vector187>:
.globl vector187
vector187:
  pushl $0
8010663a:	6a 00                	push   $0x0
  pushl $187
8010663c:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106641:	e9 23 f4 ff ff       	jmp    80105a69 <alltraps>

80106646 <vector188>:
.globl vector188
vector188:
  pushl $0
80106646:	6a 00                	push   $0x0
  pushl $188
80106648:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010664d:	e9 17 f4 ff ff       	jmp    80105a69 <alltraps>

80106652 <vector189>:
.globl vector189
vector189:
  pushl $0
80106652:	6a 00                	push   $0x0
  pushl $189
80106654:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106659:	e9 0b f4 ff ff       	jmp    80105a69 <alltraps>

8010665e <vector190>:
.globl vector190
vector190:
  pushl $0
8010665e:	6a 00                	push   $0x0
  pushl $190
80106660:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106665:	e9 ff f3 ff ff       	jmp    80105a69 <alltraps>

8010666a <vector191>:
.globl vector191
vector191:
  pushl $0
8010666a:	6a 00                	push   $0x0
  pushl $191
8010666c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106671:	e9 f3 f3 ff ff       	jmp    80105a69 <alltraps>

80106676 <vector192>:
.globl vector192
vector192:
  pushl $0
80106676:	6a 00                	push   $0x0
  pushl $192
80106678:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010667d:	e9 e7 f3 ff ff       	jmp    80105a69 <alltraps>

80106682 <vector193>:
.globl vector193
vector193:
  pushl $0
80106682:	6a 00                	push   $0x0
  pushl $193
80106684:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106689:	e9 db f3 ff ff       	jmp    80105a69 <alltraps>

8010668e <vector194>:
.globl vector194
vector194:
  pushl $0
8010668e:	6a 00                	push   $0x0
  pushl $194
80106690:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106695:	e9 cf f3 ff ff       	jmp    80105a69 <alltraps>

8010669a <vector195>:
.globl vector195
vector195:
  pushl $0
8010669a:	6a 00                	push   $0x0
  pushl $195
8010669c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801066a1:	e9 c3 f3 ff ff       	jmp    80105a69 <alltraps>

801066a6 <vector196>:
.globl vector196
vector196:
  pushl $0
801066a6:	6a 00                	push   $0x0
  pushl $196
801066a8:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801066ad:	e9 b7 f3 ff ff       	jmp    80105a69 <alltraps>

801066b2 <vector197>:
.globl vector197
vector197:
  pushl $0
801066b2:	6a 00                	push   $0x0
  pushl $197
801066b4:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801066b9:	e9 ab f3 ff ff       	jmp    80105a69 <alltraps>

801066be <vector198>:
.globl vector198
vector198:
  pushl $0
801066be:	6a 00                	push   $0x0
  pushl $198
801066c0:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801066c5:	e9 9f f3 ff ff       	jmp    80105a69 <alltraps>

801066ca <vector199>:
.globl vector199
vector199:
  pushl $0
801066ca:	6a 00                	push   $0x0
  pushl $199
801066cc:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801066d1:	e9 93 f3 ff ff       	jmp    80105a69 <alltraps>

801066d6 <vector200>:
.globl vector200
vector200:
  pushl $0
801066d6:	6a 00                	push   $0x0
  pushl $200
801066d8:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801066dd:	e9 87 f3 ff ff       	jmp    80105a69 <alltraps>

801066e2 <vector201>:
.globl vector201
vector201:
  pushl $0
801066e2:	6a 00                	push   $0x0
  pushl $201
801066e4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801066e9:	e9 7b f3 ff ff       	jmp    80105a69 <alltraps>

801066ee <vector202>:
.globl vector202
vector202:
  pushl $0
801066ee:	6a 00                	push   $0x0
  pushl $202
801066f0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801066f5:	e9 6f f3 ff ff       	jmp    80105a69 <alltraps>

801066fa <vector203>:
.globl vector203
vector203:
  pushl $0
801066fa:	6a 00                	push   $0x0
  pushl $203
801066fc:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106701:	e9 63 f3 ff ff       	jmp    80105a69 <alltraps>

80106706 <vector204>:
.globl vector204
vector204:
  pushl $0
80106706:	6a 00                	push   $0x0
  pushl $204
80106708:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010670d:	e9 57 f3 ff ff       	jmp    80105a69 <alltraps>

80106712 <vector205>:
.globl vector205
vector205:
  pushl $0
80106712:	6a 00                	push   $0x0
  pushl $205
80106714:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106719:	e9 4b f3 ff ff       	jmp    80105a69 <alltraps>

8010671e <vector206>:
.globl vector206
vector206:
  pushl $0
8010671e:	6a 00                	push   $0x0
  pushl $206
80106720:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106725:	e9 3f f3 ff ff       	jmp    80105a69 <alltraps>

8010672a <vector207>:
.globl vector207
vector207:
  pushl $0
8010672a:	6a 00                	push   $0x0
  pushl $207
8010672c:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106731:	e9 33 f3 ff ff       	jmp    80105a69 <alltraps>

80106736 <vector208>:
.globl vector208
vector208:
  pushl $0
80106736:	6a 00                	push   $0x0
  pushl $208
80106738:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010673d:	e9 27 f3 ff ff       	jmp    80105a69 <alltraps>

80106742 <vector209>:
.globl vector209
vector209:
  pushl $0
80106742:	6a 00                	push   $0x0
  pushl $209
80106744:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106749:	e9 1b f3 ff ff       	jmp    80105a69 <alltraps>

8010674e <vector210>:
.globl vector210
vector210:
  pushl $0
8010674e:	6a 00                	push   $0x0
  pushl $210
80106750:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106755:	e9 0f f3 ff ff       	jmp    80105a69 <alltraps>

8010675a <vector211>:
.globl vector211
vector211:
  pushl $0
8010675a:	6a 00                	push   $0x0
  pushl $211
8010675c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106761:	e9 03 f3 ff ff       	jmp    80105a69 <alltraps>

80106766 <vector212>:
.globl vector212
vector212:
  pushl $0
80106766:	6a 00                	push   $0x0
  pushl $212
80106768:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010676d:	e9 f7 f2 ff ff       	jmp    80105a69 <alltraps>

80106772 <vector213>:
.globl vector213
vector213:
  pushl $0
80106772:	6a 00                	push   $0x0
  pushl $213
80106774:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106779:	e9 eb f2 ff ff       	jmp    80105a69 <alltraps>

8010677e <vector214>:
.globl vector214
vector214:
  pushl $0
8010677e:	6a 00                	push   $0x0
  pushl $214
80106780:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106785:	e9 df f2 ff ff       	jmp    80105a69 <alltraps>

8010678a <vector215>:
.globl vector215
vector215:
  pushl $0
8010678a:	6a 00                	push   $0x0
  pushl $215
8010678c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106791:	e9 d3 f2 ff ff       	jmp    80105a69 <alltraps>

80106796 <vector216>:
.globl vector216
vector216:
  pushl $0
80106796:	6a 00                	push   $0x0
  pushl $216
80106798:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010679d:	e9 c7 f2 ff ff       	jmp    80105a69 <alltraps>

801067a2 <vector217>:
.globl vector217
vector217:
  pushl $0
801067a2:	6a 00                	push   $0x0
  pushl $217
801067a4:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801067a9:	e9 bb f2 ff ff       	jmp    80105a69 <alltraps>

801067ae <vector218>:
.globl vector218
vector218:
  pushl $0
801067ae:	6a 00                	push   $0x0
  pushl $218
801067b0:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801067b5:	e9 af f2 ff ff       	jmp    80105a69 <alltraps>

801067ba <vector219>:
.globl vector219
vector219:
  pushl $0
801067ba:	6a 00                	push   $0x0
  pushl $219
801067bc:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801067c1:	e9 a3 f2 ff ff       	jmp    80105a69 <alltraps>

801067c6 <vector220>:
.globl vector220
vector220:
  pushl $0
801067c6:	6a 00                	push   $0x0
  pushl $220
801067c8:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801067cd:	e9 97 f2 ff ff       	jmp    80105a69 <alltraps>

801067d2 <vector221>:
.globl vector221
vector221:
  pushl $0
801067d2:	6a 00                	push   $0x0
  pushl $221
801067d4:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801067d9:	e9 8b f2 ff ff       	jmp    80105a69 <alltraps>

801067de <vector222>:
.globl vector222
vector222:
  pushl $0
801067de:	6a 00                	push   $0x0
  pushl $222
801067e0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801067e5:	e9 7f f2 ff ff       	jmp    80105a69 <alltraps>

801067ea <vector223>:
.globl vector223
vector223:
  pushl $0
801067ea:	6a 00                	push   $0x0
  pushl $223
801067ec:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801067f1:	e9 73 f2 ff ff       	jmp    80105a69 <alltraps>

801067f6 <vector224>:
.globl vector224
vector224:
  pushl $0
801067f6:	6a 00                	push   $0x0
  pushl $224
801067f8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801067fd:	e9 67 f2 ff ff       	jmp    80105a69 <alltraps>

80106802 <vector225>:
.globl vector225
vector225:
  pushl $0
80106802:	6a 00                	push   $0x0
  pushl $225
80106804:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106809:	e9 5b f2 ff ff       	jmp    80105a69 <alltraps>

8010680e <vector226>:
.globl vector226
vector226:
  pushl $0
8010680e:	6a 00                	push   $0x0
  pushl $226
80106810:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106815:	e9 4f f2 ff ff       	jmp    80105a69 <alltraps>

8010681a <vector227>:
.globl vector227
vector227:
  pushl $0
8010681a:	6a 00                	push   $0x0
  pushl $227
8010681c:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106821:	e9 43 f2 ff ff       	jmp    80105a69 <alltraps>

80106826 <vector228>:
.globl vector228
vector228:
  pushl $0
80106826:	6a 00                	push   $0x0
  pushl $228
80106828:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010682d:	e9 37 f2 ff ff       	jmp    80105a69 <alltraps>

80106832 <vector229>:
.globl vector229
vector229:
  pushl $0
80106832:	6a 00                	push   $0x0
  pushl $229
80106834:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106839:	e9 2b f2 ff ff       	jmp    80105a69 <alltraps>

8010683e <vector230>:
.globl vector230
vector230:
  pushl $0
8010683e:	6a 00                	push   $0x0
  pushl $230
80106840:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106845:	e9 1f f2 ff ff       	jmp    80105a69 <alltraps>

8010684a <vector231>:
.globl vector231
vector231:
  pushl $0
8010684a:	6a 00                	push   $0x0
  pushl $231
8010684c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106851:	e9 13 f2 ff ff       	jmp    80105a69 <alltraps>

80106856 <vector232>:
.globl vector232
vector232:
  pushl $0
80106856:	6a 00                	push   $0x0
  pushl $232
80106858:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010685d:	e9 07 f2 ff ff       	jmp    80105a69 <alltraps>

80106862 <vector233>:
.globl vector233
vector233:
  pushl $0
80106862:	6a 00                	push   $0x0
  pushl $233
80106864:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106869:	e9 fb f1 ff ff       	jmp    80105a69 <alltraps>

8010686e <vector234>:
.globl vector234
vector234:
  pushl $0
8010686e:	6a 00                	push   $0x0
  pushl $234
80106870:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106875:	e9 ef f1 ff ff       	jmp    80105a69 <alltraps>

8010687a <vector235>:
.globl vector235
vector235:
  pushl $0
8010687a:	6a 00                	push   $0x0
  pushl $235
8010687c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106881:	e9 e3 f1 ff ff       	jmp    80105a69 <alltraps>

80106886 <vector236>:
.globl vector236
vector236:
  pushl $0
80106886:	6a 00                	push   $0x0
  pushl $236
80106888:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010688d:	e9 d7 f1 ff ff       	jmp    80105a69 <alltraps>

80106892 <vector237>:
.globl vector237
vector237:
  pushl $0
80106892:	6a 00                	push   $0x0
  pushl $237
80106894:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106899:	e9 cb f1 ff ff       	jmp    80105a69 <alltraps>

8010689e <vector238>:
.globl vector238
vector238:
  pushl $0
8010689e:	6a 00                	push   $0x0
  pushl $238
801068a0:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801068a5:	e9 bf f1 ff ff       	jmp    80105a69 <alltraps>

801068aa <vector239>:
.globl vector239
vector239:
  pushl $0
801068aa:	6a 00                	push   $0x0
  pushl $239
801068ac:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801068b1:	e9 b3 f1 ff ff       	jmp    80105a69 <alltraps>

801068b6 <vector240>:
.globl vector240
vector240:
  pushl $0
801068b6:	6a 00                	push   $0x0
  pushl $240
801068b8:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801068bd:	e9 a7 f1 ff ff       	jmp    80105a69 <alltraps>

801068c2 <vector241>:
.globl vector241
vector241:
  pushl $0
801068c2:	6a 00                	push   $0x0
  pushl $241
801068c4:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801068c9:	e9 9b f1 ff ff       	jmp    80105a69 <alltraps>

801068ce <vector242>:
.globl vector242
vector242:
  pushl $0
801068ce:	6a 00                	push   $0x0
  pushl $242
801068d0:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801068d5:	e9 8f f1 ff ff       	jmp    80105a69 <alltraps>

801068da <vector243>:
.globl vector243
vector243:
  pushl $0
801068da:	6a 00                	push   $0x0
  pushl $243
801068dc:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801068e1:	e9 83 f1 ff ff       	jmp    80105a69 <alltraps>

801068e6 <vector244>:
.globl vector244
vector244:
  pushl $0
801068e6:	6a 00                	push   $0x0
  pushl $244
801068e8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801068ed:	e9 77 f1 ff ff       	jmp    80105a69 <alltraps>

801068f2 <vector245>:
.globl vector245
vector245:
  pushl $0
801068f2:	6a 00                	push   $0x0
  pushl $245
801068f4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801068f9:	e9 6b f1 ff ff       	jmp    80105a69 <alltraps>

801068fe <vector246>:
.globl vector246
vector246:
  pushl $0
801068fe:	6a 00                	push   $0x0
  pushl $246
80106900:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106905:	e9 5f f1 ff ff       	jmp    80105a69 <alltraps>

8010690a <vector247>:
.globl vector247
vector247:
  pushl $0
8010690a:	6a 00                	push   $0x0
  pushl $247
8010690c:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106911:	e9 53 f1 ff ff       	jmp    80105a69 <alltraps>

80106916 <vector248>:
.globl vector248
vector248:
  pushl $0
80106916:	6a 00                	push   $0x0
  pushl $248
80106918:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010691d:	e9 47 f1 ff ff       	jmp    80105a69 <alltraps>

80106922 <vector249>:
.globl vector249
vector249:
  pushl $0
80106922:	6a 00                	push   $0x0
  pushl $249
80106924:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106929:	e9 3b f1 ff ff       	jmp    80105a69 <alltraps>

8010692e <vector250>:
.globl vector250
vector250:
  pushl $0
8010692e:	6a 00                	push   $0x0
  pushl $250
80106930:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106935:	e9 2f f1 ff ff       	jmp    80105a69 <alltraps>

8010693a <vector251>:
.globl vector251
vector251:
  pushl $0
8010693a:	6a 00                	push   $0x0
  pushl $251
8010693c:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106941:	e9 23 f1 ff ff       	jmp    80105a69 <alltraps>

80106946 <vector252>:
.globl vector252
vector252:
  pushl $0
80106946:	6a 00                	push   $0x0
  pushl $252
80106948:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010694d:	e9 17 f1 ff ff       	jmp    80105a69 <alltraps>

80106952 <vector253>:
.globl vector253
vector253:
  pushl $0
80106952:	6a 00                	push   $0x0
  pushl $253
80106954:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106959:	e9 0b f1 ff ff       	jmp    80105a69 <alltraps>

8010695e <vector254>:
.globl vector254
vector254:
  pushl $0
8010695e:	6a 00                	push   $0x0
  pushl $254
80106960:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106965:	e9 ff f0 ff ff       	jmp    80105a69 <alltraps>

8010696a <vector255>:
.globl vector255
vector255:
  pushl $0
8010696a:	6a 00                	push   $0x0
  pushl $255
8010696c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106971:	e9 f3 f0 ff ff       	jmp    80105a69 <alltraps>
80106976:	66 90                	xchg   %ax,%ax
80106978:	66 90                	xchg   %ax,%ax
8010697a:	66 90                	xchg   %ax,%ax
8010697c:	66 90                	xchg   %ax,%ax
8010697e:	66 90                	xchg   %ax,%ax

80106980 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106980:	55                   	push   %ebp
80106981:	89 e5                	mov    %esp,%ebp
80106983:	57                   	push   %edi
80106984:	56                   	push   %esi
80106985:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106987:	c1 ea 16             	shr    $0x16,%edx
{
8010698a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010698b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010698e:	83 ec 1c             	sub    $0x1c,%esp
  if(*pde & PTE_P){
80106991:	8b 1f                	mov    (%edi),%ebx
80106993:	f6 c3 01             	test   $0x1,%bl
80106996:	74 28                	je     801069c0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106998:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010699e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801069a4:	c1 ee 0a             	shr    $0xa,%esi
}
801069a7:	83 c4 1c             	add    $0x1c,%esp
  return &pgtab[PTX(va)];
801069aa:	89 f2                	mov    %esi,%edx
801069ac:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801069b2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801069b5:	5b                   	pop    %ebx
801069b6:	5e                   	pop    %esi
801069b7:	5f                   	pop    %edi
801069b8:	5d                   	pop    %ebp
801069b9:	c3                   	ret    
801069ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801069c0:	85 c9                	test   %ecx,%ecx
801069c2:	74 34                	je     801069f8 <walkpgdir+0x78>
801069c4:	e8 e7 ba ff ff       	call   801024b0 <kalloc>
801069c9:	85 c0                	test   %eax,%eax
801069cb:	89 c3                	mov    %eax,%ebx
801069cd:	74 29                	je     801069f8 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
801069cf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801069d6:	00 
801069d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801069de:	00 
801069df:	89 04 24             	mov    %eax,(%esp)
801069e2:	e8 e9 dd ff ff       	call   801047d0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801069e7:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801069ed:	83 c8 07             	or     $0x7,%eax
801069f0:	89 07                	mov    %eax,(%edi)
801069f2:	eb b0                	jmp    801069a4 <walkpgdir+0x24>
801069f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
801069f8:	83 c4 1c             	add    $0x1c,%esp
      return 0;
801069fb:	31 c0                	xor    %eax,%eax
}
801069fd:	5b                   	pop    %ebx
801069fe:	5e                   	pop    %esi
801069ff:	5f                   	pop    %edi
80106a00:	5d                   	pop    %ebp
80106a01:	c3                   	ret    
80106a02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a10 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106a10:	55                   	push   %ebp
80106a11:	89 e5                	mov    %esp,%ebp
80106a13:	57                   	push   %edi
80106a14:	56                   	push   %esi
80106a15:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106a16:	89 d3                	mov    %edx,%ebx
{
80106a18:	83 ec 1c             	sub    $0x1c,%esp
80106a1b:	8b 7d 08             	mov    0x8(%ebp),%edi
  a = (char*)PGROUNDDOWN((uint)va);
80106a1e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106a24:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a27:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106a2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106a2e:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a32:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
80106a39:	29 df                	sub    %ebx,%edi
80106a3b:	eb 18                	jmp    80106a55 <mappages+0x45>
80106a3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*pte & PTE_P)
80106a40:	f6 00 01             	testb  $0x1,(%eax)
80106a43:	75 3d                	jne    80106a82 <mappages+0x72>
    *pte = pa | perm | PTE_P;
80106a45:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
80106a48:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106a4b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106a4d:	74 29                	je     80106a78 <mappages+0x68>
      break;
    a += PGSIZE;
80106a4f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106a55:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a58:	b9 01 00 00 00       	mov    $0x1,%ecx
80106a5d:	89 da                	mov    %ebx,%edx
80106a5f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106a62:	e8 19 ff ff ff       	call   80106980 <walkpgdir>
80106a67:	85 c0                	test   %eax,%eax
80106a69:	75 d5                	jne    80106a40 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106a6b:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106a6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a73:	5b                   	pop    %ebx
80106a74:	5e                   	pop    %esi
80106a75:	5f                   	pop    %edi
80106a76:	5d                   	pop    %ebp
80106a77:	c3                   	ret    
80106a78:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106a7b:	31 c0                	xor    %eax,%eax
}
80106a7d:	5b                   	pop    %ebx
80106a7e:	5e                   	pop    %esi
80106a7f:	5f                   	pop    %edi
80106a80:	5d                   	pop    %ebp
80106a81:	c3                   	ret    
      panic("remap");
80106a82:	c7 04 24 c8 7b 10 80 	movl   $0x80107bc8,(%esp)
80106a89:	e8 d2 98 ff ff       	call   80100360 <panic>
80106a8e:	66 90                	xchg   %ax,%ax

80106a90 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106a90:	55                   	push   %ebp
80106a91:	89 e5                	mov    %esp,%ebp
80106a93:	57                   	push   %edi
80106a94:	89 c7                	mov    %eax,%edi
80106a96:	56                   	push   %esi
80106a97:	89 d6                	mov    %edx,%esi
80106a99:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106a9a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106aa0:	83 ec 1c             	sub    $0x1c,%esp
  a = PGROUNDUP(newsz);
80106aa3:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106aa9:	39 d3                	cmp    %edx,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106aab:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106aae:	72 3b                	jb     80106aeb <deallocuvm.part.0+0x5b>
80106ab0:	eb 5e                	jmp    80106b10 <deallocuvm.part.0+0x80>
80106ab2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106ab8:	8b 10                	mov    (%eax),%edx
80106aba:	f6 c2 01             	test   $0x1,%dl
80106abd:	74 22                	je     80106ae1 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106abf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106ac5:	74 54                	je     80106b1b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106ac7:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106acd:	89 14 24             	mov    %edx,(%esp)
80106ad0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106ad3:	e8 28 b8 ff ff       	call   80102300 <kfree>
      *pte = 0;
80106ad8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106adb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106ae1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ae7:	39 f3                	cmp    %esi,%ebx
80106ae9:	73 25                	jae    80106b10 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106aeb:	31 c9                	xor    %ecx,%ecx
80106aed:	89 da                	mov    %ebx,%edx
80106aef:	89 f8                	mov    %edi,%eax
80106af1:	e8 8a fe ff ff       	call   80106980 <walkpgdir>
    if(!pte)
80106af6:	85 c0                	test   %eax,%eax
80106af8:	75 be                	jne    80106ab8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106afa:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106b00:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106b06:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b0c:	39 f3                	cmp    %esi,%ebx
80106b0e:	72 db                	jb     80106aeb <deallocuvm.part.0+0x5b>
    }
  }
  return newsz;
}
80106b10:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b13:	83 c4 1c             	add    $0x1c,%esp
80106b16:	5b                   	pop    %ebx
80106b17:	5e                   	pop    %esi
80106b18:	5f                   	pop    %edi
80106b19:	5d                   	pop    %ebp
80106b1a:	c3                   	ret    
        panic("kfree");
80106b1b:	c7 04 24 06 75 10 80 	movl   $0x80107506,(%esp)
80106b22:	e8 39 98 ff ff       	call   80100360 <panic>
80106b27:	89 f6                	mov    %esi,%esi
80106b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b30 <seginit>:
{
80106b30:	55                   	push   %ebp
80106b31:	89 e5                	mov    %esp,%ebp
80106b33:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106b36:	e8 85 cb ff ff       	call   801036c0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b3b:	31 c9                	xor    %ecx,%ecx
80106b3d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c = &cpus[cpuid()];
80106b42:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106b48:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b4d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b51:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  lgdt(c->gdt, sizeof(c->gdt));
80106b56:	83 c0 70             	add    $0x70,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b59:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b5d:	31 c9                	xor    %ecx,%ecx
80106b5f:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b63:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b68:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b6c:	31 c9                	xor    %ecx,%ecx
80106b6e:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b72:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b77:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b7b:	31 c9                	xor    %ecx,%ecx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b7d:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106b81:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b85:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106b89:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b8d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106b91:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106b95:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106b99:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
80106b9d:	66 89 50 20          	mov    %dx,0x20(%eax)
  pd[0] = size-1;
80106ba1:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106ba6:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
80106baa:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106bae:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106bb2:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106bb6:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
80106bba:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106bbe:	66 89 48 22          	mov    %cx,0x22(%eax)
80106bc2:	c6 40 24 00          	movb   $0x0,0x24(%eax)
80106bc6:	c6 40 27 00          	movb   $0x0,0x27(%eax)
80106bca:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106bce:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106bd2:	c1 e8 10             	shr    $0x10,%eax
80106bd5:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106bd9:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106bdc:	0f 01 10             	lgdtl  (%eax)
}
80106bdf:	c9                   	leave  
80106be0:	c3                   	ret    
80106be1:	eb 0d                	jmp    80106bf0 <switchkvm>
80106be3:	90                   	nop
80106be4:	90                   	nop
80106be5:	90                   	nop
80106be6:	90                   	nop
80106be7:	90                   	nop
80106be8:	90                   	nop
80106be9:	90                   	nop
80106bea:	90                   	nop
80106beb:	90                   	nop
80106bec:	90                   	nop
80106bed:	90                   	nop
80106bee:	90                   	nop
80106bef:	90                   	nop

80106bf0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106bf0:	a1 a4 59 11 80       	mov    0x801159a4,%eax
{
80106bf5:	55                   	push   %ebp
80106bf6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106bf8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106bfd:	0f 22 d8             	mov    %eax,%cr3
}
80106c00:	5d                   	pop    %ebp
80106c01:	c3                   	ret    
80106c02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c10 <switchuvm>:
{
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	57                   	push   %edi
80106c14:	56                   	push   %esi
80106c15:	53                   	push   %ebx
80106c16:	83 ec 1c             	sub    $0x1c,%esp
80106c19:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106c1c:	85 f6                	test   %esi,%esi
80106c1e:	0f 84 cd 00 00 00    	je     80106cf1 <switchuvm+0xe1>
  if(p->kstack == 0)
80106c24:	8b 46 0c             	mov    0xc(%esi),%eax
80106c27:	85 c0                	test   %eax,%eax
80106c29:	0f 84 da 00 00 00    	je     80106d09 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106c2f:	8b 7e 08             	mov    0x8(%esi),%edi
80106c32:	85 ff                	test   %edi,%edi
80106c34:	0f 84 c3 00 00 00    	je     80106cfd <switchuvm+0xed>
  pushcli();
80106c3a:	e8 e1 d9 ff ff       	call   80104620 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106c3f:	e8 fc c9 ff ff       	call   80103640 <mycpu>
80106c44:	89 c3                	mov    %eax,%ebx
80106c46:	e8 f5 c9 ff ff       	call   80103640 <mycpu>
80106c4b:	89 c7                	mov    %eax,%edi
80106c4d:	e8 ee c9 ff ff       	call   80103640 <mycpu>
80106c52:	83 c7 08             	add    $0x8,%edi
80106c55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106c58:	e8 e3 c9 ff ff       	call   80103640 <mycpu>
80106c5d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106c60:	ba 67 00 00 00       	mov    $0x67,%edx
80106c65:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106c6c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106c73:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106c7a:	83 c1 08             	add    $0x8,%ecx
80106c7d:	c1 e9 10             	shr    $0x10,%ecx
80106c80:	83 c0 08             	add    $0x8,%eax
80106c83:	c1 e8 18             	shr    $0x18,%eax
80106c86:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106c8c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106c93:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106c99:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106c9e:	e8 9d c9 ff ff       	call   80103640 <mycpu>
80106ca3:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106caa:	e8 91 c9 ff ff       	call   80103640 <mycpu>
80106caf:	b9 10 00 00 00       	mov    $0x10,%ecx
80106cb4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106cb8:	e8 83 c9 ff ff       	call   80103640 <mycpu>
80106cbd:	8b 56 0c             	mov    0xc(%esi),%edx
80106cc0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106cc6:	89 48 0c             	mov    %ecx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106cc9:	e8 72 c9 ff ff       	call   80103640 <mycpu>
80106cce:	66 89 58 6e          	mov    %bx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106cd2:	b8 28 00 00 00       	mov    $0x28,%eax
80106cd7:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106cda:	8b 46 08             	mov    0x8(%esi),%eax
80106cdd:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ce2:	0f 22 d8             	mov    %eax,%cr3
}
80106ce5:	83 c4 1c             	add    $0x1c,%esp
80106ce8:	5b                   	pop    %ebx
80106ce9:	5e                   	pop    %esi
80106cea:	5f                   	pop    %edi
80106ceb:	5d                   	pop    %ebp
  popcli();
80106cec:	e9 6f d9 ff ff       	jmp    80104660 <popcli>
    panic("switchuvm: no process");
80106cf1:	c7 04 24 ce 7b 10 80 	movl   $0x80107bce,(%esp)
80106cf8:	e8 63 96 ff ff       	call   80100360 <panic>
    panic("switchuvm: no pgdir");
80106cfd:	c7 04 24 f9 7b 10 80 	movl   $0x80107bf9,(%esp)
80106d04:	e8 57 96 ff ff       	call   80100360 <panic>
    panic("switchuvm: no kstack");
80106d09:	c7 04 24 e4 7b 10 80 	movl   $0x80107be4,(%esp)
80106d10:	e8 4b 96 ff ff       	call   80100360 <panic>
80106d15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d20 <inituvm>:
{
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	57                   	push   %edi
80106d24:	56                   	push   %esi
80106d25:	53                   	push   %ebx
80106d26:	83 ec 1c             	sub    $0x1c,%esp
80106d29:	8b 75 10             	mov    0x10(%ebp),%esi
80106d2c:	8b 45 08             	mov    0x8(%ebp),%eax
80106d2f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106d32:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106d38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106d3b:	77 54                	ja     80106d91 <inituvm+0x71>
  mem = kalloc();
80106d3d:	e8 6e b7 ff ff       	call   801024b0 <kalloc>
  memset(mem, 0, PGSIZE);
80106d42:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106d49:	00 
80106d4a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106d51:	00 
  mem = kalloc();
80106d52:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106d54:	89 04 24             	mov    %eax,(%esp)
80106d57:	e8 74 da ff ff       	call   801047d0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106d5c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d62:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d67:	89 04 24             	mov    %eax,(%esp)
80106d6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d6d:	31 d2                	xor    %edx,%edx
80106d6f:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106d76:	00 
80106d77:	e8 94 fc ff ff       	call   80106a10 <mappages>
  memmove(mem, init, sz);
80106d7c:	89 75 10             	mov    %esi,0x10(%ebp)
80106d7f:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106d82:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106d85:	83 c4 1c             	add    $0x1c,%esp
80106d88:	5b                   	pop    %ebx
80106d89:	5e                   	pop    %esi
80106d8a:	5f                   	pop    %edi
80106d8b:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106d8c:	e9 df da ff ff       	jmp    80104870 <memmove>
    panic("inituvm: more than a page");
80106d91:	c7 04 24 0d 7c 10 80 	movl   $0x80107c0d,(%esp)
80106d98:	e8 c3 95 ff ff       	call   80100360 <panic>
80106d9d:	8d 76 00             	lea    0x0(%esi),%esi

80106da0 <loaduvm>:
{
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	57                   	push   %edi
80106da4:	56                   	push   %esi
80106da5:	53                   	push   %ebx
80106da6:	83 ec 1c             	sub    $0x1c,%esp
  if((uint) addr % PGSIZE != 0)
80106da9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106db0:	0f 85 98 00 00 00    	jne    80106e4e <loaduvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
80106db6:	8b 75 18             	mov    0x18(%ebp),%esi
80106db9:	31 db                	xor    %ebx,%ebx
80106dbb:	85 f6                	test   %esi,%esi
80106dbd:	75 1a                	jne    80106dd9 <loaduvm+0x39>
80106dbf:	eb 77                	jmp    80106e38 <loaduvm+0x98>
80106dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dc8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106dce:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106dd4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106dd7:	76 5f                	jbe    80106e38 <loaduvm+0x98>
80106dd9:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ddc:	31 c9                	xor    %ecx,%ecx
80106dde:	8b 45 08             	mov    0x8(%ebp),%eax
80106de1:	01 da                	add    %ebx,%edx
80106de3:	e8 98 fb ff ff       	call   80106980 <walkpgdir>
80106de8:	85 c0                	test   %eax,%eax
80106dea:	74 56                	je     80106e42 <loaduvm+0xa2>
    pa = PTE_ADDR(*pte);
80106dec:	8b 00                	mov    (%eax),%eax
      n = PGSIZE;
80106dee:	bf 00 10 00 00       	mov    $0x1000,%edi
80106df3:	8b 4d 14             	mov    0x14(%ebp),%ecx
    pa = PTE_ADDR(*pte);
80106df6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = PGSIZE;
80106dfb:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106e01:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e04:	05 00 00 00 80       	add    $0x80000000,%eax
80106e09:	89 44 24 04          	mov    %eax,0x4(%esp)
80106e0d:	8b 45 10             	mov    0x10(%ebp),%eax
80106e10:	01 d9                	add    %ebx,%ecx
80106e12:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106e16:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106e1a:	89 04 24             	mov    %eax,(%esp)
80106e1d:	e8 4e ab ff ff       	call   80101970 <readi>
80106e22:	39 f8                	cmp    %edi,%eax
80106e24:	74 a2                	je     80106dc8 <loaduvm+0x28>
}
80106e26:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106e29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e2e:	5b                   	pop    %ebx
80106e2f:	5e                   	pop    %esi
80106e30:	5f                   	pop    %edi
80106e31:	5d                   	pop    %ebp
80106e32:	c3                   	ret    
80106e33:	90                   	nop
80106e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106e38:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106e3b:	31 c0                	xor    %eax,%eax
}
80106e3d:	5b                   	pop    %ebx
80106e3e:	5e                   	pop    %esi
80106e3f:	5f                   	pop    %edi
80106e40:	5d                   	pop    %ebp
80106e41:	c3                   	ret    
      panic("loaduvm: address should exist");
80106e42:	c7 04 24 27 7c 10 80 	movl   $0x80107c27,(%esp)
80106e49:	e8 12 95 ff ff       	call   80100360 <panic>
    panic("loaduvm: addr must be page aligned");
80106e4e:	c7 04 24 c8 7c 10 80 	movl   $0x80107cc8,(%esp)
80106e55:	e8 06 95 ff ff       	call   80100360 <panic>
80106e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e60 <allocuvm>:
{
80106e60:	55                   	push   %ebp
80106e61:	89 e5                	mov    %esp,%ebp
80106e63:	57                   	push   %edi
80106e64:	56                   	push   %esi
80106e65:	53                   	push   %ebx
80106e66:	83 ec 1c             	sub    $0x1c,%esp
80106e69:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
80106e6c:	85 ff                	test   %edi,%edi
80106e6e:	0f 88 7e 00 00 00    	js     80106ef2 <allocuvm+0x92>
  if(newsz < oldsz)
80106e74:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106e77:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80106e7a:	72 78                	jb     80106ef4 <allocuvm+0x94>
  a = PGROUNDUP(oldsz);
80106e7c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106e82:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106e88:	39 df                	cmp    %ebx,%edi
80106e8a:	77 4a                	ja     80106ed6 <allocuvm+0x76>
80106e8c:	eb 72                	jmp    80106f00 <allocuvm+0xa0>
80106e8e:	66 90                	xchg   %ax,%ax
    memset(mem, 0, PGSIZE);
80106e90:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106e97:	00 
80106e98:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106e9f:	00 
80106ea0:	89 04 24             	mov    %eax,(%esp)
80106ea3:	e8 28 d9 ff ff       	call   801047d0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106ea8:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106eae:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106eb3:	89 04 24             	mov    %eax,(%esp)
80106eb6:	8b 45 08             	mov    0x8(%ebp),%eax
80106eb9:	89 da                	mov    %ebx,%edx
80106ebb:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106ec2:	00 
80106ec3:	e8 48 fb ff ff       	call   80106a10 <mappages>
80106ec8:	85 c0                	test   %eax,%eax
80106eca:	78 44                	js     80106f10 <allocuvm+0xb0>
  for(; a < newsz; a += PGSIZE){
80106ecc:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ed2:	39 df                	cmp    %ebx,%edi
80106ed4:	76 2a                	jbe    80106f00 <allocuvm+0xa0>
    mem = kalloc();
80106ed6:	e8 d5 b5 ff ff       	call   801024b0 <kalloc>
    if(mem == 0){
80106edb:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106edd:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106edf:	75 af                	jne    80106e90 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106ee1:	c7 04 24 45 7c 10 80 	movl   $0x80107c45,(%esp)
80106ee8:	e8 63 97 ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
80106eed:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106ef0:	77 48                	ja     80106f3a <allocuvm+0xda>
      return 0;
80106ef2:	31 c0                	xor    %eax,%eax
}
80106ef4:	83 c4 1c             	add    $0x1c,%esp
80106ef7:	5b                   	pop    %ebx
80106ef8:	5e                   	pop    %esi
80106ef9:	5f                   	pop    %edi
80106efa:	5d                   	pop    %ebp
80106efb:	c3                   	ret    
80106efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106f00:	83 c4 1c             	add    $0x1c,%esp
80106f03:	89 f8                	mov    %edi,%eax
80106f05:	5b                   	pop    %ebx
80106f06:	5e                   	pop    %esi
80106f07:	5f                   	pop    %edi
80106f08:	5d                   	pop    %ebp
80106f09:	c3                   	ret    
80106f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106f10:	c7 04 24 5d 7c 10 80 	movl   $0x80107c5d,(%esp)
80106f17:	e8 34 97 ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
80106f1c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106f1f:	76 0d                	jbe    80106f2e <allocuvm+0xce>
80106f21:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f24:	89 fa                	mov    %edi,%edx
80106f26:	8b 45 08             	mov    0x8(%ebp),%eax
80106f29:	e8 62 fb ff ff       	call   80106a90 <deallocuvm.part.0>
      kfree(mem);
80106f2e:	89 34 24             	mov    %esi,(%esp)
80106f31:	e8 ca b3 ff ff       	call   80102300 <kfree>
      return 0;
80106f36:	31 c0                	xor    %eax,%eax
80106f38:	eb ba                	jmp    80106ef4 <allocuvm+0x94>
80106f3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106f3d:	89 fa                	mov    %edi,%edx
80106f3f:	8b 45 08             	mov    0x8(%ebp),%eax
80106f42:	e8 49 fb ff ff       	call   80106a90 <deallocuvm.part.0>
      return 0;
80106f47:	31 c0                	xor    %eax,%eax
80106f49:	eb a9                	jmp    80106ef4 <allocuvm+0x94>
80106f4b:	90                   	nop
80106f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f50 <deallocuvm>:
{
80106f50:	55                   	push   %ebp
80106f51:	89 e5                	mov    %esp,%ebp
80106f53:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f56:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106f59:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106f5c:	39 d1                	cmp    %edx,%ecx
80106f5e:	73 08                	jae    80106f68 <deallocuvm+0x18>
}
80106f60:	5d                   	pop    %ebp
80106f61:	e9 2a fb ff ff       	jmp    80106a90 <deallocuvm.part.0>
80106f66:	66 90                	xchg   %ax,%ax
80106f68:	89 d0                	mov    %edx,%eax
80106f6a:	5d                   	pop    %ebp
80106f6b:	c3                   	ret    
80106f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f70 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	56                   	push   %esi
80106f74:	53                   	push   %ebx
80106f75:	83 ec 10             	sub    $0x10,%esp
80106f78:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106f7b:	85 f6                	test   %esi,%esi
80106f7d:	74 59                	je     80106fd8 <freevm+0x68>
80106f7f:	31 c9                	xor    %ecx,%ecx
80106f81:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106f86:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106f88:	31 db                	xor    %ebx,%ebx
80106f8a:	e8 01 fb ff ff       	call   80106a90 <deallocuvm.part.0>
80106f8f:	eb 12                	jmp    80106fa3 <freevm+0x33>
80106f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f98:	83 c3 01             	add    $0x1,%ebx
80106f9b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106fa1:	74 27                	je     80106fca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106fa3:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106fa6:	f6 c2 01             	test   $0x1,%dl
80106fa9:	74 ed                	je     80106f98 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106fab:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(i = 0; i < NPDENTRIES; i++){
80106fb1:	83 c3 01             	add    $0x1,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106fb4:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106fba:	89 14 24             	mov    %edx,(%esp)
80106fbd:	e8 3e b3 ff ff       	call   80102300 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80106fc2:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106fc8:	75 d9                	jne    80106fa3 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
80106fca:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106fcd:	83 c4 10             	add    $0x10,%esp
80106fd0:	5b                   	pop    %ebx
80106fd1:	5e                   	pop    %esi
80106fd2:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106fd3:	e9 28 b3 ff ff       	jmp    80102300 <kfree>
    panic("freevm: no pgdir");
80106fd8:	c7 04 24 79 7c 10 80 	movl   $0x80107c79,(%esp)
80106fdf:	e8 7c 93 ff ff       	call   80100360 <panic>
80106fe4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ff0 <setupkvm>:
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	56                   	push   %esi
80106ff4:	53                   	push   %ebx
80106ff5:	83 ec 10             	sub    $0x10,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
80106ff8:	e8 b3 b4 ff ff       	call   801024b0 <kalloc>
80106ffd:	85 c0                	test   %eax,%eax
80106fff:	89 c6                	mov    %eax,%esi
80107001:	74 6d                	je     80107070 <setupkvm+0x80>
  memset(pgdir, 0, PGSIZE);
80107003:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010700a:	00 
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010700b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80107010:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107017:	00 
80107018:	89 04 24             	mov    %eax,(%esp)
8010701b:	e8 b0 d7 ff ff       	call   801047d0 <memset>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107020:	8b 53 0c             	mov    0xc(%ebx),%edx
80107023:	8b 43 04             	mov    0x4(%ebx),%eax
80107026:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107029:	89 54 24 04          	mov    %edx,0x4(%esp)
8010702d:	8b 13                	mov    (%ebx),%edx
8010702f:	89 04 24             	mov    %eax,(%esp)
80107032:	29 c1                	sub    %eax,%ecx
80107034:	89 f0                	mov    %esi,%eax
80107036:	e8 d5 f9 ff ff       	call   80106a10 <mappages>
8010703b:	85 c0                	test   %eax,%eax
8010703d:	78 19                	js     80107058 <setupkvm+0x68>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010703f:	83 c3 10             	add    $0x10,%ebx
80107042:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107048:	72 d6                	jb     80107020 <setupkvm+0x30>
8010704a:	89 f0                	mov    %esi,%eax
}
8010704c:	83 c4 10             	add    $0x10,%esp
8010704f:	5b                   	pop    %ebx
80107050:	5e                   	pop    %esi
80107051:	5d                   	pop    %ebp
80107052:	c3                   	ret    
80107053:	90                   	nop
80107054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107058:	89 34 24             	mov    %esi,(%esp)
8010705b:	e8 10 ff ff ff       	call   80106f70 <freevm>
}
80107060:	83 c4 10             	add    $0x10,%esp
      return 0;
80107063:	31 c0                	xor    %eax,%eax
}
80107065:	5b                   	pop    %ebx
80107066:	5e                   	pop    %esi
80107067:	5d                   	pop    %ebp
80107068:	c3                   	ret    
80107069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80107070:	31 c0                	xor    %eax,%eax
80107072:	eb d8                	jmp    8010704c <setupkvm+0x5c>
80107074:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010707a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107080 <kvmalloc>:
{
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107086:	e8 65 ff ff ff       	call   80106ff0 <setupkvm>
8010708b:	a3 a4 59 11 80       	mov    %eax,0x801159a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107090:	05 00 00 00 80       	add    $0x80000000,%eax
80107095:	0f 22 d8             	mov    %eax,%cr3
}
80107098:	c9                   	leave  
80107099:	c3                   	ret    
8010709a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801070a0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801070a0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801070a1:	31 c9                	xor    %ecx,%ecx
{
801070a3:	89 e5                	mov    %esp,%ebp
801070a5:	83 ec 18             	sub    $0x18,%esp
  pte = walkpgdir(pgdir, uva, 0);
801070a8:	8b 55 0c             	mov    0xc(%ebp),%edx
801070ab:	8b 45 08             	mov    0x8(%ebp),%eax
801070ae:	e8 cd f8 ff ff       	call   80106980 <walkpgdir>
  if(pte == 0)
801070b3:	85 c0                	test   %eax,%eax
801070b5:	74 05                	je     801070bc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801070b7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801070ba:	c9                   	leave  
801070bb:	c3                   	ret    
    panic("clearpteu");
801070bc:	c7 04 24 8a 7c 10 80 	movl   $0x80107c8a,(%esp)
801070c3:	e8 98 92 ff ff       	call   80100360 <panic>
801070c8:	90                   	nop
801070c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801070d0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801070d0:	55                   	push   %ebp
801070d1:	89 e5                	mov    %esp,%ebp
801070d3:	57                   	push   %edi
801070d4:	56                   	push   %esi
801070d5:	53                   	push   %ebx
801070d6:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801070d9:	e8 12 ff ff ff       	call   80106ff0 <setupkvm>
801070de:	85 c0                	test   %eax,%eax
801070e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801070e3:	0f 84 b9 00 00 00    	je     801071a2 <copyuvm+0xd2>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801070e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801070ec:	85 c0                	test   %eax,%eax
801070ee:	0f 84 94 00 00 00    	je     80107188 <copyuvm+0xb8>
801070f4:	31 ff                	xor    %edi,%edi
801070f6:	eb 48                	jmp    80107140 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801070f8:	81 c6 00 00 00 80    	add    $0x80000000,%esi
801070fe:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107105:	00 
80107106:	89 74 24 04          	mov    %esi,0x4(%esp)
8010710a:	89 04 24             	mov    %eax,(%esp)
8010710d:	e8 5e d7 ff ff       	call   80104870 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107112:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107115:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010711a:	89 fa                	mov    %edi,%edx
8010711c:	89 44 24 04          	mov    %eax,0x4(%esp)
80107120:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107126:	89 04 24             	mov    %eax,(%esp)
80107129:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010712c:	e8 df f8 ff ff       	call   80106a10 <mappages>
80107131:	85 c0                	test   %eax,%eax
80107133:	78 63                	js     80107198 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107135:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010713b:	39 7d 0c             	cmp    %edi,0xc(%ebp)
8010713e:	76 48                	jbe    80107188 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107140:	8b 45 08             	mov    0x8(%ebp),%eax
80107143:	31 c9                	xor    %ecx,%ecx
80107145:	89 fa                	mov    %edi,%edx
80107147:	e8 34 f8 ff ff       	call   80106980 <walkpgdir>
8010714c:	85 c0                	test   %eax,%eax
8010714e:	74 62                	je     801071b2 <copyuvm+0xe2>
    if(!(*pte & PTE_P))
80107150:	8b 00                	mov    (%eax),%eax
80107152:	a8 01                	test   $0x1,%al
80107154:	74 50                	je     801071a6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107156:	89 c6                	mov    %eax,%esi
    flags = PTE_FLAGS(*pte);
80107158:	25 ff 0f 00 00       	and    $0xfff,%eax
8010715d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107160:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    if((mem = kalloc()) == 0)
80107166:	e8 45 b3 ff ff       	call   801024b0 <kalloc>
8010716b:	85 c0                	test   %eax,%eax
8010716d:	89 c3                	mov    %eax,%ebx
8010716f:	75 87                	jne    801070f8 <copyuvm+0x28>
    }
  }
  return d;

bad:
  freevm(d);
80107171:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107174:	89 04 24             	mov    %eax,(%esp)
80107177:	e8 f4 fd ff ff       	call   80106f70 <freevm>
  return 0;
8010717c:	31 c0                	xor    %eax,%eax
}
8010717e:	83 c4 2c             	add    $0x2c,%esp
80107181:	5b                   	pop    %ebx
80107182:	5e                   	pop    %esi
80107183:	5f                   	pop    %edi
80107184:	5d                   	pop    %ebp
80107185:	c3                   	ret    
80107186:	66 90                	xchg   %ax,%ax
80107188:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010718b:	83 c4 2c             	add    $0x2c,%esp
8010718e:	5b                   	pop    %ebx
8010718f:	5e                   	pop    %esi
80107190:	5f                   	pop    %edi
80107191:	5d                   	pop    %ebp
80107192:	c3                   	ret    
80107193:	90                   	nop
80107194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107198:	89 1c 24             	mov    %ebx,(%esp)
8010719b:	e8 60 b1 ff ff       	call   80102300 <kfree>
      goto bad;
801071a0:	eb cf                	jmp    80107171 <copyuvm+0xa1>
    return 0;
801071a2:	31 c0                	xor    %eax,%eax
801071a4:	eb d8                	jmp    8010717e <copyuvm+0xae>
      panic("copyuvm: page not present");
801071a6:	c7 04 24 ae 7c 10 80 	movl   $0x80107cae,(%esp)
801071ad:	e8 ae 91 ff ff       	call   80100360 <panic>
      panic("copyuvm: pte should exist");
801071b2:	c7 04 24 94 7c 10 80 	movl   $0x80107c94,(%esp)
801071b9:	e8 a2 91 ff ff       	call   80100360 <panic>
801071be:	66 90                	xchg   %ax,%ax

801071c0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801071c0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801071c1:	31 c9                	xor    %ecx,%ecx
{
801071c3:	89 e5                	mov    %esp,%ebp
801071c5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801071c8:	8b 55 0c             	mov    0xc(%ebp),%edx
801071cb:	8b 45 08             	mov    0x8(%ebp),%eax
801071ce:	e8 ad f7 ff ff       	call   80106980 <walkpgdir>
  if((*pte & PTE_P) == 0)
801071d3:	8b 00                	mov    (%eax),%eax
801071d5:	89 c2                	mov    %eax,%edx
801071d7:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
801071da:	83 fa 05             	cmp    $0x5,%edx
801071dd:	75 11                	jne    801071f0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801071df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801071e4:	05 00 00 00 80       	add    $0x80000000,%eax
}
801071e9:	c9                   	leave  
801071ea:	c3                   	ret    
801071eb:	90                   	nop
801071ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801071f0:	31 c0                	xor    %eax,%eax
}
801071f2:	c9                   	leave  
801071f3:	c3                   	ret    
801071f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107200 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107200:	55                   	push   %ebp
80107201:	89 e5                	mov    %esp,%ebp
80107203:	57                   	push   %edi
80107204:	56                   	push   %esi
80107205:	53                   	push   %ebx
80107206:	83 ec 1c             	sub    $0x1c,%esp
80107209:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010720c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010720f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107212:	85 db                	test   %ebx,%ebx
80107214:	75 3a                	jne    80107250 <copyout+0x50>
80107216:	eb 68                	jmp    80107280 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107218:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010721b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
8010721d:	89 7c 24 04          	mov    %edi,0x4(%esp)
    n = PGSIZE - (va - va0);
80107221:	29 ca                	sub    %ecx,%edx
80107223:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107229:	39 da                	cmp    %ebx,%edx
8010722b:	0f 47 d3             	cmova  %ebx,%edx
    memmove(pa0 + (va - va0), buf, n);
8010722e:	29 f1                	sub    %esi,%ecx
80107230:	01 c8                	add    %ecx,%eax
80107232:	89 54 24 08          	mov    %edx,0x8(%esp)
80107236:	89 04 24             	mov    %eax,(%esp)
80107239:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010723c:	e8 2f d6 ff ff       	call   80104870 <memmove>
    len -= n;
    buf += n;
80107241:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80107244:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    buf += n;
8010724a:	01 d7                	add    %edx,%edi
  while(len > 0){
8010724c:	29 d3                	sub    %edx,%ebx
8010724e:	74 30                	je     80107280 <copyout+0x80>
    pa0 = uva2ka(pgdir, (char*)va0);
80107250:	8b 45 08             	mov    0x8(%ebp),%eax
    va0 = (uint)PGROUNDDOWN(va);
80107253:	89 ce                	mov    %ecx,%esi
80107255:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
8010725b:	89 74 24 04          	mov    %esi,0x4(%esp)
    va0 = (uint)PGROUNDDOWN(va);
8010725f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107262:	89 04 24             	mov    %eax,(%esp)
80107265:	e8 56 ff ff ff       	call   801071c0 <uva2ka>
    if(pa0 == 0)
8010726a:	85 c0                	test   %eax,%eax
8010726c:	75 aa                	jne    80107218 <copyout+0x18>
  }
  return 0;
}
8010726e:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80107271:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107276:	5b                   	pop    %ebx
80107277:	5e                   	pop    %esi
80107278:	5f                   	pop    %edi
80107279:	5d                   	pop    %ebp
8010727a:	c3                   	ret    
8010727b:	90                   	nop
8010727c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107280:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80107283:	31 c0                	xor    %eax,%eax
}
80107285:	5b                   	pop    %ebx
80107286:	5e                   	pop    %esi
80107287:	5f                   	pop    %edi
80107288:	5d                   	pop    %ebp
80107289:	c3                   	ret    
