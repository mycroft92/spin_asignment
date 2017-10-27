/*Author : mycroft
  Date   : 21-oct
*/
#define N =3

typedef ticket {
    int num;
    bool color;
}
ticket t[N];
bool allow[N];
bool sharedBit;
short tval;
int ncrit;

proctype counter(pid){

    t[pid].num  = tval++;
    t[pid].color= sharedBit;
}

/*proctype lock(ticket t){
    int i;
    int max;
    entering[t.num] = true;
    //assign a number to the process
    atomic{for(i : 0 .. N-1){
        if
        ::number[i]>max -> max=number[i];
        ::else
        fi
    };number[t.num] = max+1;}

}*/

proctype unlock(int i){
    t[i].num = 0;

}

proctype p(){
    repeat:
        printf("Greetings earthling!my pid: %d\n",_pid);
        //request ticket
        counter(_pid%N);
        allow[_pid%N] == 1;
        ncrit++;
        assert(ncrit==1);
        sharedBit = 1-t[_pid%N].color; //set sharedBit color to opposite value
        ncrit--;
        unlock(_pid%N);

}
