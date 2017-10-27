/*Author : mycroft
  Date   : 21-oct
*/
int N =3
byte ncrit; //processes in critical section
int nprocess;   //total pids active
bool gcolor; //The color of last process that went into crit section

typedef ticket {
    int number;
    bool color; //0 for black, 1 for white
}

proctype p (ticket t){
        bool mycolor = gcolor;
        npid++;
        printf("My pid is: %d\n",_pid);
        (gcolor != mycolor) || ()
        ncrit++;
        assert(ncrit==1);
        gcolor = !mycolor;
        ncrit--;
        nprocess--;
}

init {

    int lastprocess=0;
    repeat:
        if
        :: nprocess < N-1 -> nprocess++;ticket t= {lastprocess+1,gcolor};lastprocess = run p(t);
        ::else
        fi

}
