% Dynamic Fact Route with three parameter Ex. route('Agra','Pune',1214)
:-dynamic route/3.


%Road Route System :-
welcome:-
    retractall(route(_,_,_)), %remove prior dynmaic facts before creating new facts
    start, %Creating all route facts
    write('Road Route System'),nl,
    write('Which Search Technique you want to use to find the route from one city to another city?'),nl,
    write('1. Depth First Search'),tab(4),write('2. Best First Search'),nl,
    read(S),
    write('Start City: '),
    read(Start),
    write('Goal City: '),
    read(Goal),
    solve(Start,Goal,Route,Distance,S),
    write('Route : '),write(Route),nl,
    write('Total Distance : '),write(Distance).


% Used to create dynamic fact by reading csv file and converting each
% row and column to some fact
start:-
    csv_read_file('roaddistances.csv',[H1|R]),
    rows(H1,H2), %Converting Rows to List
    facts(H2,R).


%This fact used when all there is no Row i.e. Row List becomes empty
facts(_H,[]):-true.


%Processing each row one by one and converting it into facts
facts(H,[R1|R2]):-
    rows(R1,R3),
    lists:nth1(1,R3,CA) ,
    Q1=(lists:nth1(N,R3,DIST)) ,
    Q2=(N > 1) ,
    Q3=(lists:nth1(N,H,CB)) ,

    ROUTE=(Q1,Q2,Q3),
    New_CA = CA,
    New_CB = CB,
    New_DIST = DIST,
    FACT=((assertz(route(CA,CB,DIST))),assertz(route(New_CB,New_CA,New_DIST))) ,

    forall(ROUTE,FACT),
    retractall(route(X,X,-)),

    facts(H,R2).


%Used to convert from Row to List
rows(H,T):-
H=..[_|T].


%Calculate the sum of the given list and store value in Sum Variable
sum([],0).
sum([H|T],Sum):-
    sum(T,Temp), Sum is H+Temp.


%Call dfs or bestfirstsearch as per user input search technique
solve(Start,Goal,Route,Distance,S):-
    (
    S =:= 1 -> (dfs(Start,Goal,[],X,[],Y),sum(Y,Distance),reverse(X,Route));
    S =:= 2 -> (bestfirstsearch(Start,Goal,Distance,Route))
    ).


%When Start City reaches to the Goal City dfs return true.
dfs(Goal,Goal,Path,[Goal|Path],D,D).


% When Start is not the Goal City and searches for further Path using
% DFS Search
dfs(Start,Goal,Path,Route,D,DIST):-
    route(Start,X,DIST1),
    \+ member(X,Path),
    dfs(X,Goal,[Start|Path],Route,[DIST1|D],DIST).


%Creating two List of Path and Distance and reversing them
nextCity(_,_,[],L1,L2,List1,List2):-
    reverse(L1,List1),
    reverse(L2,List2).

%Creating two list of Path and Distance using Start and Goal
nextCity(Start, Goal,[H1|T],L1,L2,List1,List2):-
    route(Start,H1,DIST1),
    route(H1,Goal,DIST2),
    random(20,30,X),
    Sum is DIST1+DIST2-X,
    nextCity(Start,Goal,T,[Sum|L1],[(Start,H1,Goal)|L2],List1,List2).

%Concatenating List1 and List2 to make heuristic
find_list([],[],H,Heuristic):-
    reverse(H,Heuristic).

find_list([H1|T1],[H2|T2],H,[(H1:H2)|Heuristic]):-
    find_list(T1,T2,H,Heuristic).


%To create heuristic by given Start and Goal
find_h(Start,Goal,Heuristic):-
    csv_read_file('roaddistances.csv',[Head|_]),
    rows(Head,H),
    H = [_|T],
    nextCity(Start,Goal,T,[],[],List1,List2),
    find_list(List1,List2,[],Heuristic).

%To calcualte minimum distance path from the heuristic created
%When only one element left in the list with minimum value
min_path([(A:B)],(A:B),A,B).

%When Head of List has minimum value
min_path([(A:B)|T],(A:B),A,B):-
    min_path(T,(X:Y),X,Y), A < X.

%When head of List has grater value than next element
min_path([(A:_)|T],(X:Y),X,Y):-
    min_path(T,(X:Y),X,Y),A >= X.


%When there is a direct route between Start and Goal City
bestfirstsearch(Start,Goal,DIST1,[Start,Goal]):-
    route(Start,Goal,DIST),DIST1 is DIST-20.

%When there is no direct route between Start and Goal
bestfirstsearch(Start,Goal,DIST,Route):-
    find_h(Start,Goal,Heuristic),  %Computing heuristics dynamically
    min_path(Heuristic,(_:_),DIST,Route).  %Among different paths selecting the best minimum distance path




