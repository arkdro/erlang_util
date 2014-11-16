-module(trc_util).

-export([
         start/0,
         start/1,
         stop/0
        ]).

start() ->
    start([avl_tree]).

start(Mods) ->
    Match = get_match(),
    Base = get_name(),
    Size = 200000000,
    Fun = dbg:trace_port(file, {Base, wrap, ".trc", Size}),
    dbg:tracer(port, Fun),
    dbg:p(all, [c, timestamp]),
    [dbg:tpl(X, Match) || X <- Mods].

stop() ->
    dbg:ctpl(),
    dbg:flush_trace_port(),
    dbg:stop_clear().

get_match() ->
    %% dbg:fun2ms(fun(_) -> true, return_trace() end).
    [{'_',[],[true,{return_trace}]}].

get_name() ->
    {A, B, _} = now(),
    N = A * 1000000 + B,
    Name = lists:flatten(io_lib:format("~p-~B", [?MODULE, N])),
    filename:join("/tmp", Name).



