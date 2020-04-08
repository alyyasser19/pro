:- use_module(library(clpfd)).
bush(L):-
    L=[M,W,C],
    L ins 0..100,
    6*M + 4*W + C #=200,
    M+W+C #=100,
    W #=5*M,
    labeling([], L).
age(Y):-
    Y=[P,M,T],
    P in 1..20000000,
    M in 1..20000000,
    T in 1..20000000,
    M + P + T #= 840,
    P#= 6*T,
    1680#= ((T+X)+(M+X)+(P+X)),
    (P+X)#= 2*(T+X),
    labeling([],Y).
square(X):-
    X= [A,B,C],
    X ins 1 ..2000000,
    A+1#=B*B,
    A-2#=2*C*C,
    labeling([],X).
