-module(sample).
-export([main/1]).

main(_) -> 
    {ok, C} = epgsql:connect("host", "user", "password"
                             , [
                                {database, "db name"},
                                {timeout, 4000}
                               ]),
    {ok, _, SelectRes} = epgsql:squery(C, "SELECT * FROM USERS"),
    io:format("~p~n", [SelectRes]),
    ok = epgsql:close(C).
