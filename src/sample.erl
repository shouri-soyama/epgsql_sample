-module(sample).
-export([main/1]).

main(Args) ->
    [Name | _] = Args,
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
    {ok, _, Res1} = epgsql:squery(C, "SELECT * FROM USERS"),
    lists:foreach(fun({_, UserName, _, _}) -> io:format("~p~n", [binary_to_list(UserName)]) end, Res1),
    {ok, _, Res2} = epgsql:equery(C, "SELECT USER_ID, PASSWORD FROM USERS WHERE USER_ID = $1", [Name]),
    lists:foreach(fun({UserName, Password}) -> io:format("~p: ~p~n", [binary_to_list(UserName), binary_to_list(Password)]) end, Res2),
    ok = epgsql:close(C).
