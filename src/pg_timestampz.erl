-module(pg_timestampz).

-behaviour(pg_types).

-export([init/1,
         encode/2,
         decode/2,
         type_spec/0]).

-include("pg_protocol.hrl").

init(_Opts) ->
    {[<<"timestamptz_send">>], []}.

encode(Timestamp, _TypeInfo) ->
    <<8:?int32, (pg_timestamp:encode_timestamp(Timestamp)):?int64>>.

decode(Bin, _TypeInfo) ->
    pg_timestamp:decode_timestamp(Bin, float_seconds).

type_spec() ->
    pg_timestamp:type_spec().
