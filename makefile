CC=gcc
PROP=lockout.fair mutex.safe progress.fair
IN=bakery_algo.pml

%.s: %.safe bakery_algo.pml
	spin -a -F $^
	${CC} -o $@ pan.c
	rm -rf pan.*

%.f: %.fair bakery_algo.pml
	spin -a -F $^
	${CC} -o $@ pan.c
	rm -rf pan.*

all: progress.f mutex.s lockout.f
	echo "***Compiled***"

clean:
	rm -rf *.s *.f *.trail
