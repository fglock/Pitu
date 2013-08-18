./tinycc/tcc -B./tinycc -I./tinycc -I./tinycc/include -o pitu pitu.c ./tinycc/libtcc.a   -Wall -g -O2 -fno-strict-aliasing -Wno-pointer-sign -Wno-sign-compare -Wno-unused-result -DCONFIG_LDDIR="\"lib/x86_64-linux-gnu\"" -DCONFIG_MULTIARCHDIR="\"x86_64-linux-gnu\"" -DTCC_TARGET_X86_64 -lm -ldl
./pitu
