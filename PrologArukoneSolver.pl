%Simple Arukone solver using the Prolog language; Should be easy to extend for heuristics using the searchPath predicate.

%Predicate to build the solution for an arukone
%Grid is a Width, Height combo (Grid(Width, Height))
%Links is a list of links, a link is positions that need to be connected(Link(Position(X,Y),Position(X2,Y2),Link(...))
arukone(Grid,Links,Solution) :-
    listEmptyNodes(Grid, Links, LijstNodes),
    findAllPaths(Links, LijstNodes,[],Solution).

%builds a list with empty nodes we can use
listEmptyNodes(grid(Width, Height), Links, BuiltList):-
	numlist(1,Width,ListXValues),
	numlist(1,Height,ListYValues),
	findall(pos(X,Y), (member(X,ListXValues), member(Y,ListYValues), notInLinks(pos(X,Y),Links)), BuiltList).

%Help predicate to check whether a position isn't in Links
notInLinks(pos(X,Y),Links):-
	\+ member(link(_,pos(X,Y),_),Links),
	\+ member(link(_,_,pos(X,Y)),Links).

%Predicate to find all possible walkable paths
findAllPaths([],[], Paths, Paths).
findAllPaths([link(Id,Start,End)|RestLinks], PossiblePositions,Paths, ConnectsResult):-
	searchPath(Start, End, [End|PossiblePositions],[Start],NewPositionsLeft,Path),
	findAllPaths(RestLinks, NewPositionsLeft,[connects(Id,Path)|Paths], ConnectsResult).

%Predicate to find a single path, good place to implement heuristic searching
searchPath(pos(X,Y),pos(X,Y),PossiblePositions,Path,PossiblePositions,Path).
searchPath(pos(LaatsteX,LaatsteY), pos(EndX,EndY), PossiblePositions,ExistingPathOfConnect,NPossiblePositionsPart2, Path):-
	neighbourOf(X,Y,LaatsteX, LaatsteY),
	select(pos(X,Y), PossiblePositions, NPossiblePositions),
	searchPath(pos(X,Y), pos(EndX,EndY), NPossiblePositions,[pos(X,Y)|ExistingPathOfConnect],NPossiblePositionsPart2, Path).

%Help predicate to verify whether nodes are lying next to eachother
neighbourOf(X, Y, X2, Y2):-
	X is X2,
	Y is Y2-1.	
	
neighbourOf(X, Y, X2, Y2):-
	X is X2 + 1,
	Y is Y2.

neighbourOf(X, Y, X2, Y2):-
	X is X2,
	Y is Y2 + 1.

neighbourOf(X, Y, X2, Y2):-
	X is X2 -1,
	Y is Y2.