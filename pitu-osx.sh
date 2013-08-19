gcc -o pitu pitu.c tinycc/libtcc.a  -Wall -g -O2 -fno-strict-aliasing -Wno-pointer-sign -Wno-sign-compare -D_FORTIFY_SOURCE=0 -Wl,-flat_namespace,-undefined,warning -DTCC_TARGET_X86_64 -D_ANSI_SOURCE -lm -ldl   -Itinycc 
./pitu lib_path=tinycc

