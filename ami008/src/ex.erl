-module(ex).

-include_lib("proper/include/proper.hrl").
-include_lib("eunit/include/eunit.hrl").

-export([find_k/2,
		 make_flatten/1,
		 remove_k/2,
         split/2,
         random/1,
		 rle/1]).

%%remove Kth element of the list
remove_k(List, K) ->
	remove_k(List, K, []).

remove_k([_X | Tail], 1, ResList) -> %don't change resulting list
    lists:reverse(ResList, Tail); 
remove_k([X | Tail], Step, ResList) when Step > 0 ->
    remove_k(Tail, Step - 1, [X | ResList]).


%%find Kth element of the list
find_k([X | _Tail], 1) ->
    X;
find_k([_X | Tail], Step) when Step > 0 ->
    find_k(Tail, Step - 1).

%%make given list flat
make_flatten([]) ->
    [];
make_flatten([X | Y]) ->
    make_flatten(X) ++ make_flatten(Y);
make_flatten(X) ->
    [X].

%% split the list on 2 parts
split(List, K) ->
    split(List, K, []).

split([X | Tail], 1, List1) -> %% return resulting lists
    {lists:reverse([X | List1]), Tail};
split([X | Tail], Step, List1) when Step > 1-> %% add element to 1st list
    split(Tail, Step - 1, [ X | List1]).


%make random list from the given one
random(List) ->
    random(List, []).

random([], ResList) ->
    lists:reverse(ResList);
random(List, ResList) ->
	K = random:uniform(length(List)),
	Element = find_k(List, K),
    random(remove_k(List, K), [Element | ResList]).


rle(List) ->
    rle(List, [], 1, []).

rle([], _, _, ResList) ->
    lists:reverse(ResList);
rle([X | Tail], X, Count, ResList) ->
    rle([X | Tail], X, Count + 1, ResList);
rle([X | Tail], _Y, 1, ResList)->
    rle(Tail, X, 1, [X | ResList]);
rle([X | Tail], Y, Count, ResList) ->
    rle(Tail, X, 1, [{Y, Count} | ResList]).


%%LOCAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%revert list
%revert_list(List) ->
%    revert_list(List, []).

%revert_list([], Acc) ->
%	Acc;
%revert_list([X | Tail], Acc) ->
%	revert_list(Tail, [X | Acc]).

%%%%%%%%%TESTS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
first_test() ->
    ?assertEqual(find_k(lists:seq(1,10), 5), 5),
    ?assertEqual(split([1,2,3,4,5,6], 4), {[1,2,3,4],[5,6]}).

%prop_test1() ->
%    ?FORALL(, pos_integer(),
	
%).

%second_test() ->
%    ?assertEqual(
%        [],
%        proper:module(?MODULE, [{to_file, user},
%                                {numtests, 100}])
%        ).
