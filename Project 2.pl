
offerMean(offer(dahab,[diving, snorkeling, horseRiding],10000,2020-02-12,2020-03-12,period(2020-03-15, 2020-04-15),10,5),bus).
offerMean(offer(taba, [diving], 1000, 2020-02-12, 2020-03-12, period(2020-06-01, 2020-08-31), 10, 4), bus).


offerAccommodation(offer(dahab, [diving, snorkeling, horseRiding], 10000, 2020-02-12, 2020-03-12, period(2020-03-15, 2020-04-15), 10, 5), hotel).
offerAccommodation(offer(taba, [diving], 1000, 2020-02-12, 2020-03-12, period(2020-06-01, 2020-08-31), 10, 4), hotel).

customerPreferredActivity(customer(ahmed, aly, 1993-01-30, single, 0, student), diving, 100).
customerPreferredActivity(customer(ahmed, aly, 1993-01-30, single, 0, student), snorkeling, 100).
customerPreferredActivity(customer(ahmed, aly, 1993-01-30, single, 0, student), horseRiding, 20).
customerPreferredActivity(customer(mohamed, elkasad, 1999-01-30, single, 0, student), snorkeling, 60).
customerPreferredActivity(customer(mohamed, elkasad, 1999-01-30, single, 0, student), diving, 20).
customerPreferredActivity(customer(mohamed, elkasad, 1999-01-30, single, 0, student), horseRiding, 50).

customerPreferredMean(customer(ahmed, aly, 1993-01-30, single, 0, student), bus, 100).
customerPreferredMean(customer(mohamed, elkasad, 1999-01-30, single, 0, student), bus, 10).

customerPreferredAccommodation(customer(ahmed, aly, 1993-01-30, single, 0, student), hotel, 20).
customerPreferredAccommodation(customer(mohamed, elkasad, 1999-01-30, single, 0, student), hotel, 100).


subset1([], []).
subset1([H|T], [H|T2]):-
  subset1(T, T2).
subset1([_|T], T2):-
  subset1(T, T2).

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
  R=[activity(R1)|T].

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
  append( [H],X1, ChosenPreferences).
choosePreferencesH([_|T],ChosenPreferences):-
  possibleSubset(T,ChosenPreferences).

overlapPeriod(P1,P2):-
  P1=period(_-_-_,Y2-M2-D2),
  P2=period(Y3-M3-D3,_-_-_),
  \+((Y2<Y3);(Y2=<Y3,M2<M3);(Y2=<Y3,M2=<M3,D2<D3)).

prefHelper(Prefs,A):-
  Prefs=[H|_],
  H=activity(A).

prefHelper(Prefs,L):-
  Prefs=[H|T],
  H\=activity(_),
  prefHelper(T,L).


preferenceSatisfaction(Offer,Customer,Prefs,S):-
  preferenceSatisfactionMean(Offer,Customer,Prefs,R),
  preferenceSatisfactionAct(Offer,Customer,Prefs,R2),
  preferenceSatisfactionAcc(Offer,Customer,Prefs,R3),
  S is R+R2+R3.

preferenceSatisfactionMean(Offer,Customer,Prefs,S):-
  offerMean(Offer,M),
  customerPreferredMean(Customer,M,R),
  member(means(_),Prefs),
  offerAccommodation(Offer,A),
  customerPreferredAccommodation(Customer,A,_),
  prefHelper(Prefs,X),
  customerPreferredActivity(Customer,X2,_),
  List=[X2],
  possibleSubset(X,List),
  S is R.

preferenceSatisfactionMean(_,_,Prefs,0):-
  \+member(means(_),Prefs).

preferenceSatisfactionAcc(Offer,Customer,Prefs,S):-
  offerMean(Offer,M),
  customerPreferredMean(Customer,M,_),
  offerAccommodation(Offer,A),
  customerPreferredAccommodation(Customer,A,R2),
  member(accommodation(_),Prefs),
  prefHelper(Prefs,X),
  customerPreferredActivity(Customer,X2,_),
  List=[X2],
  possibleSubset(X,List),
  S is R2.


preferenceSatisfactionAcc(_,_,Prefs,0):-
  \+member(accomodation(_),Prefs).

preferenceSatisfactionAct(Offer,Customer,Prefs,S):-
  offerMean(Offer,M),
  customerPreferredMean(Customer,M,_),
  offerAccommodation(Offer,A),
  customerPreferredAccommodation(Customer,A,_),
  prefHelper(Prefs,X),
  customerPreferredActivity(Customer,X2,R3),
  List=[X2],
  possibleSubset(X,List),
  member(activity(_),Prefs),
  S is R3.

preferenceSatisfactionAct(_,_,Prefs,0):-
  \+member(activity(_),Prefs).
getOffer([],_).
getOffer([H|T],Offer):-
  H= dest(A),
  offerMean(Offer,_),
  Offer= offer(A,_,_,_,_,_,_,_),
  getOffer(T,Offer).
getOffer([H|T],Offer):-
  H=activity(A),
  offerMean(Offer,_),
  Offer= offer(_,B,_,_,_,_,_,_),
  possibleSubset(B,A),
  getOffer(T,Offer).
getOffer([H|T],Offer):-
  H=period(A,A1),
  offerMean(Offer,_),
  Offer= offer(_,_,_,_,_,period(B,B1),_,_),
  overlapPeriod(period(A,A1),period(B,B1)),
  getOffer(T,Offer).
getOffer([H|T],Offer):-
  H=budget(A),
  offerMean(Offer,_),
  Offer= offer(_,_,C,_,_,_,_,_),
  A>=C,
  getOffer(T,Offer).
getOffer([H|T],Offer):-
  H=accommodation(A),
  offerAccommodation(Offer,A),
  getOffer(T,Offer).
getOffer([H|T],Offer):-
  H=means(A),
  offerMean(Offer,A),
  getOffer(T,Offer).
recommendOfferForCustomer(Prefs, ChosenPreferences, O):-
  subset1(Prefs,ChosenPreferences),
  getOffer(ChosenPreferences,O).
recommendOffer(Customers, PreferenceList, _, _):-
  Customers=[Hc|Tc],
  PreferenceList=[Hp|Tp],
  customerHelper(Hc,Hp,Offer1),
  customerHelper(Tc,Tp,Offer2),
  countH(Offer1,Offer2,Ac,cus).
recommendOffer(Customers, PreferenceList, Offer, CustomersChosen):-
  Customers=[CustomersChosen|_],
  PreferenceList=[Hp|_],
  customerHelper(CustomersChosen,Hp,Offer).
recommendOffer(Customers, PreferenceList, Offer, CustomersChosen):-
  Customers=[_|Tc],
  PreferenceList=[_|Tp],
  recommendOffer(Tc,Tp,Offer,CustomersChosen).
customerHelper(_,Prefs,Offer):-
  getOffer(Prefs,Offer).
customerHelper(_,Prefs,Offer):-
  \+getOffer(Prefs,Offer),
  recommendOfferForCustomer(Prefs,_,Offer).
countH(Offer,Offer,1).




  












