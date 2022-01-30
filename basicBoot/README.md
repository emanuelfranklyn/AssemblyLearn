# BasicBoot
## Description
This is a basic boot that doesn't do nothing.
But is recognized by the bootloader as a valid boot.

## Usage
### Compile
```cmd
nasm basicBoot.asm -f bin -o boot.bin
```
### Run
```cmd
qemu-system-x86_64 boot.bin
```

## About
    []: # Language: Assembly
    []: # Path: basicBoot\basicBoot.asm