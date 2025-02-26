
nasm -f elf64 currency_converter.asm -o currency_converter.o
gcc currency_converter.o -no-pie -o currency_converter -lm
./currency_converter
