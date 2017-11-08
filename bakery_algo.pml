/*Author : mycroft
  Date   : 21-oct
*/
//Defines for program and verification section
#define N 3
#define p (ncrit<=1)
#define ncs1 (P[1]@noncritical)
#define wt1 (P[1]@wait)
#define cs1 (P[1]@critical)
#define wt2 (P[2]@wait)
#define wt3 (P[3]@wait)


typedef t {
    int num;
    bool color;
};
t ticket[N];

bool choosing[N];
bool sharedBit;
int ncrit;
bool lock;

inline dispense( id, i, max){
    i=0;
    max =0;
    do
    :: i<N -> if
              :: ticket[i].num > max -> max =ticket[i].num;
              :: max >= ticket[i].num;
              fi;
    :: else ->break;
    od;
    ticket[id].num = 1+max;
    ticket[id].color = sharedBit;

}
//checks according to condition 1
inline colorcheck (l,k){
    atomic {(ticket[l].color != ticket[k].color) && (ticket[l].color != sharedBit)}
}
//checks according to conditions 2&3 in pdf
inline numbercheck (m,n){
    atomic {(ticket[m].num < ticket[n].num)||((ticket[m].num == ticket[n].num)&&(m<n))}
}

active [N] proctype P() {
    int i,j,max,id;
    id = _pid;
    //t   ticket;
    noncritical:
        choosing[id] = 1;
    wait:
        dispense(id,i,max);
        choosing[id] = 0;
        j=0;
        //allow into critical section if minimum, the process exits this loop only it is it's turn
        do
        :: j<N && choosing[j] == 0 ->
            if
            :: colorcheck(j,id) -> (ticket[j].num ==0); j++;//wait until j finishes execution,color is lower than current process
            :: numbercheck(j,id)-> ticket[j].num ==0; j++;//wait until j finishes execution,num is lower than current process
            :: numbercheck(id,j)-> j++; //Current process has higher priority than j
            fi;
        :: j==N -> ncrit++; break;
        od;
    critical:
        assert(ncrit==1);
        sharedBit  = 1-sharedBit;
        ncrit--;
        //releasing lock

        ticket[id].num = 0;
        goto noncritical

}

/*init {
    atomic {
        byte i=0;
        do
        :: i< N -> run P(i);i++;
        :: else -> break;
        od;

    }
}*/
ltl deadlock {!( <>[](wt1&&wt2&&wt3))}
ltl lockout {[]<> cs1-> []<> ncs1}
ltl progress {[]<> wt1 -> []<> cs1}
ltl mutex {[]p}
