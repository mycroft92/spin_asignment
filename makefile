CC=gcc
PROP=lockout.prop mutex.prop progress.prop
DOT=$(PROP:%.prop=%.dot)
TRACE=$(PROP:%.prop=%.ps)
IN=bakery_algo.pml


%.p: %.prop bakery_algo.pml
	spin -a -F $^
	${CC} -o $@ pan.c
	rm -rf pan.*

%.dot: %.p
	./$^ -a -DREACH -e -i > $@

%.ps: %.dot
	dot -Tps $^ -o $@

all: $(TRACE)
	echo "***Compiled***"

clean:
	rm -rf *.s *.f *.trail *.dot *.ps *.png *.tmp
