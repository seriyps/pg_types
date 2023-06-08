-module(pg_float4).

-behaviour(pg_types).

-export([init/1,
         encode/2,
         decode/2,
         type_spec/0]).

-include("pg_protocol.hrl").
-include("pg_types.hrl").

-define(POS_INF,  <<0:1, 255:8, 0:23>>).
-define(NEG_INF,  <<1:1, 255:8, 0:23>>).
-define(NAN_PATTERN, <<_:1, 255:8, _:23>>).
-define(NAN, <<0:1, 255:8, 1:1, 0:22>>).

init(_Opts) ->
    {[<<"float4send">>], []}.

encode(Int, _) when is_integer(Int) ->
    <<4:?int32, (Int * 1.0):?float32>>;
encode(Float, _) when is_float(Float) ->
    <<4:?int32, Float:?float32>>;
encode('NaN', _) ->
    [<<4:?int32>>, ?NAN];
encode(infinity, _) ->
    [<<4:?int32>>, ?POS_INF];
encode('-infinity', _) ->
    [<<4:?int32>>, ?NEG_INF].

decode(<<Float:?float32>>, _) ->
    Float;
decode(?POS_INF,  _) ->
    infinity;
decode(?NEG_INF, _) ->
    '-infinity';
decode(?NAN_PATTERN, _) ->
    'NaN'.

type_spec() ->
    "float() | infinity | '-infinity' | 'NaN'".
