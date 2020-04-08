subset1([], []).
subset1([E|Tail], [E|NTail]):-
  subset1(Tail, NTail).
subset1([_|Tail], NTail):-
  subset1(Tail, NTail).
possibleSubset([H|T],R) :-
    subset1([H|T], L1),
    permutation(L1,R).
possibleSubset([activity(A)|[]],R):-
  subset1(A,L1),
  permutation(L1,R1),
  R= activity(R1).
possibleSubset([activity(A)|T],R):-
  subset1(A,L1),
  permutation(L1,R1),
  R= [activity(R1)|T].
choosePreferences(Prefs, ChosenPreferences):-
    choosePreferencesH(Prefs,ChosenPreferences).
choosePreferencesH([],[]).
choosePreferencesH([H|T],ChosenPreferences):-
  possibleSubset([H|T],ChosenPreferences).
choosePreferencesH([H|T],ChosenPreferences):-
  possibleSubset(T,X1),
  append(X1, [H], ChosenPreferences).
choosePreferencesH([H|T],ChosenPreferences):-
  possibleSubset(T,X1),
  append([H],X1, ChosenPreferences).
choosePreferencesH([_|T],ChosenPreferences):-
  possibleSubset(T,ChosenPreferences).
recommendOfferForCustomer(Prefs, ChosenPrefs, O):-
  choosePreferences(Prefs,ChosenPrefs),
  getOffer(ChosenPrefs,O).



  
  



    
    
    
    