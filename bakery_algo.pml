/*Author : mycroft
  Date   : 21-oct
*/
//Defines for program and verification section
#define N 3
#define p (ncrit<=1)
#define ncs (P[1]@noncritical)
#define wt (P[1]@wait)
#define cs   (P[1]@critical)


typedef t {
    int num;
    bool color;
};
t ticket[N];

bool choosing[N];
bool sharedBit;
int ncrit;

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

proctype P(byte id) {
    int i,j,max;
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
            :: colorcheck(j,id) -> ticket[j].num ==0; j++;//wait until j finishes execution,color is lower than current process
            :: numbercheck(j,id)-> ticket[j].num ==0; j++;//wait until j finishes execution,num is lower than current process
            :: numbercheck(id,j)-> j++; //Current process has higher priority than j
            fi;
        :: atomic {j==N -> ncrit++} break;
        od;
    critical:
        assert(ncrit==1);
        sharedBit  = 1-sharedBit;
        ncrit--;
        //releasing lock
        ticket[id].num = 0;
        goto noncritical

}

init {
    atomic {
        byte i=0;
        do
        :: i< N -> run P(i);i++;
        :: else -> break;
        od;

    }
}
