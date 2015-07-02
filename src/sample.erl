-module(sample).
-export([main/1]).

main(_) -> 
    application:load(sample),
    application:start(sample),
    {ok, Path} = application:get_env(sample, conf_file),
    {ok, Lines} = file:consult(Path),
    [{_, Host}, {_, User}, {_, Pwd}, {_, Db}|_] = Lines,
    {ok, C} = epgsql:connect(Host, User, Pwd
                             , [
                                {database, Db},
                                {timeout, 4000}
                               ]),
    {ok, _, Selects} = epgsql:squery(C, "SELECT * FROM USERS"),
    lists:foreach(fun({_, UserName, _, _}) -> io:format("~p~n", [binary_to_list(UserName)]) end, Selects),
    ok = epgsql:close(C).
