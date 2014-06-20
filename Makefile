#
# Tiny C Compiler Makefile - tests
#

TOP = tinycc
include $(TOP)/Makefile
SRCDIR = $(top_srcdir)
VPATH = $(SRCDIR) $(top_srcdir)

ifdef DISABLE_STATIC
 export LD_LIBRARY_PATH:=$(CURDIR)/..
endif

ifeq ($(TARGETOS),Darwin)
 CFLAGS+=-Wl,-flat_namespace,-undefined,warning
 export MACOSX_DEPLOYMENT_TARGET:=10.2
 NATIVE_DEFINES+=-D_ANSI_SOURCE
endif

# run local version of tcc with local libraries and includes
TCCFLAGS = -B$(TOP) -I$(TOP) -I$(top_srcdir) -I$(top_srcdir)/include
ifdef CONFIG_WIN32
 TCCFLAGS = -B$(top_srcdir)/win32 -I$(top_srcdir) -I$(top_srcdir)/include -I$(TOP) -L$(TOP)
endif
XTCCFLAGS = -B$(TOP) -B$(top_srcdir)/win32 -I$(TOP) -I$(top_srcdir) -I$(top_srcdir)/include

TCC = $(TOP)/tcc $(TCCFLAGS)
RUN_TCC = $(NATIVE_DEFINES) -DONE_SOURCE -run $(top_srcdir)/tcc.c $(TCCFLAGS)

DISAS = objdump -d

# libtcc test
ifdef LIBTCC1
 LIBTCC1:=$(TOP)/$(LIBTCC1)
endif

libtest: pitu$(EXESUF) $(LIBTCC1)
	@echo ------------ $@ ------------
	./pitu$(EXESUF) lib_path=tinycc

pitu$(EXESUF): pitu.c $(top_builddir)/$(LIBTCC)
	$(CC) -o $@ $^ $(CPPFLAGS) $(CFLAGS) $(NATIVE_DEFINES) $(LIBS) $(LINK_LIBTCC) $(LDFLAGS) -I$(top_srcdir)

w32-prep:
	cp ../libtcc1.a ../lib

test4: tcctest.c test.ref
	@echo ------------ $@ ------------
# object + link output
	$(TCC) -c -o tcctest3.o $<
	$(TCC) -o tcctest3 tcctest3.o
	./tcctest3 > test3.out
	@if diff -u test.ref test3.out ; then echo "Object Auto Test OK"; fi
# dynamic output
	$(TCC) -o tcctest1 $<
	./tcctest1 > test1.out
	@if diff -u test.ref test1.out ; then echo "Dynamic Auto Test OK"; fi
# dynamic output + bound check
	$(TCC) -b -o tcctest4 $<
	./tcctest4 > test4.out
	@if diff -u test.ref test4.out ; then echo "BCheck Auto Test OK"; fi
# static output
	$(TCC) -static -o tcctest2 $<
	./tcctest2 > test2.out
	@if diff -u test.ref test2.out ; then echo "Static Auto Test OK"; fi

ex%: $(top_srcdir)/examples/ex%.c
	$(CC) -o $@ $< $(CPPFLAGS) $(CFLAGS) $(LDFLAGS)

# targets for development
%.bin: %.c tcc
	$(TCC) -g -o $@ $<
	$(DISAS) $@

instr: instr.o
	objdump -d instr.o

instr.o: instr.S
	$(CC) -o $@ -c $< -O2 -Wall -g

cache: tcc_g
	cachegrind ./tcc_g -o /tmp/linpack -lm bench/linpack.c
	vg_annotate tcc.c > /tmp/linpack.cache.log

# clean
clean:
	# $(MAKE) -C tests2 $@
	rm -vf *~ *.o *.a *.bin *.i *.ref *.out *.out? *.out?b *.cc \
		*-cc *-tcc *.exe \
		pitu vla_test tcctest[1234] ex? tcc_g tcclib.h \
		../lib/libtcc1.a
