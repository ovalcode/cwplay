rm -f floppy.img
rm -f test2.bin
as test.S -o test.o
objcopy -O binary test.o test.bin
dd if=test.bin iflag=skip_bytes of=test2.bin bs=512 count=1 skip=31744
dd if=/dev/zero of=test2.bin bs=1 count=1474048 seek=512
mv test2.bin floppy.img

