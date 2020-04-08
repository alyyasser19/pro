append1([],L2,L2).
append1([H|T],L2,L3):-
    append1(T,L2,L),
    L3= [H|L].
length1([],0).
length1([_|T], Int):-
    length1(T,Int1),
    Int is Int1+1.
reverse1([],[]).
reverse1([H|T],L1):-
    reverse1(T,X),
    append1(X,[H],L1).
reverse2([],L1,L1).
reverse2([H|T],L,List):-
    reverse2(T,[H|L],List).
member1([H|_],H).
member1([_|T],X):-
    member1(T,X).
union1(X, [], X).
union1([],X, X).
union1([H|T],[H1|T1],Z):-
    \+ member1([H|T],H1),
    append1([H|T],[H1],Z1),
    union1(Z1,T1,Z).
union1([H|T],[H1|T1],Z):-
    member1([H|T],H1),
    union1([H|T],T1,Z).
union2([X|Y],Z,W) :- member(X,Z), union2(Y,Z,W).
union2([X|Y],Z,[X|W]) :- \+ member(X,Z), union2(Y,Z,W).
union2([],_,[]).
intersect([X|Y],M,[X|Z]) :- member(X,M), intersect(Y,M,Z).
intersect([X|Y],M,Z) :- \+ member(X,M), intersect(Y,M,Z).
intersect([],_,[]).
remove1([],_,[]).
remove1([H|T],X,[H|R]):-
    X\=H,
    remove1(T,X,R).
remove1([H|T],H,R):-
    remove1(T,H,R).
replace([],_,_,[]).
replace([H|T],X,Y,[H|Z]):-
    H\= X,
    replace(T,X,Y,Z).
replace([H|T],H,Y,[Y|Z]):-
    replace(T,H,Y,Z).
sum_of(List,Sum,Res):- sum_helper(List,Sum,[],Res).
sum_helper(_,Sum,Acc,Acc):- sum_list(Acc,Sum).
sum_helper([H|T],Sum,Acc,Res):-
sum_list(Acc,SumSoFar),
SumSoFar\=Sum,
append(Acc,[H],NewAcc),
sum_helper(T,Sum,NewAcc,Res).
sum_helper([_|T],Sum,Acc,Res):-
sum_list(Acc,SumSoFar),
SumSoFar\=Sum,
sum_helper(T,Sum,Acc,Res).
int_bin(0,X,X).
int_bin(X,Y,Acc):-
    X>0,
    X1 is X//2,
    1 is X mod 2,
    Accnew= s1(Acc),
    int_bin(X1,Y,Accnew).
int_bin(X,Y,Acc):-
    X>0,
    X1 is X//2,
    0 is X mod 2,
    Accnew= s0(Acc),
    int_bin(X1,Y,Accnew).







    




    






    
    