CC=gcc
CFLAGS= -DMEMLIM=1024 -O2 -DXUSAFE -w
VFLAGS= -e -i -DREACH
PROP=lockout.prop mutex.prop progress.prop deadlock.prop
DOT=$(PROP:%.prop=%.dot)
PROG=$(PROP:%.prop=%.p)
TRACE=$(PROP:%.prop=%.ps)
IN=bakery_algo.pml


%.p: %.prop bakery_algo.pml
	spin -a -F $^
	${CC} -o $@ $(CFLAGS) pan.c
	rm -rf pan.*

%.dot: %.p
	./$^ -a -f -m10000 $(VFLAGS) > $@

%.ps: %.dot
	dot -Tps $^ -o $@

all: $(TRACE) $(PROG)
	echo "***Finished***"

clean:
	rm -rf *.s *.f *.trail *.dot *.ps *.png *.tmp *.p
