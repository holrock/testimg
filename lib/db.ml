module type DB = Caqti_lwt.CONNECTION

module R = Caqti_request
module T = Caqti_type
open Caqti_request.Infix

let list_files =
  let query =
    (T.unit -->* T.(tup2 int string))
    @:- "select id, filename from files order by filename"
  in
  fun (module Db : DB) ->
    let%lwt files_of_error = Db.collect_list query () in
    Caqti_lwt.or_fail files_of_error

let list_judges =
  let query =
    (T.string -->* T.(tup3 int string (option int)))
    @:- {eos|
      select f.id, f.filename, j.judge
      from files f left join
        judgements j on j.filename = f.filename
        where j.user is null or j.user = ?
      order by f.id
    |eos}
  in
  fun user (module Db : DB) ->
    let%lwt files_of_error = Db.collect_list query user in
    Caqti_lwt.or_fail files_of_error

let find_file =
  let query =
    (T.int -->? T.(tup3 int string (option bool)))
    @:- "select f.id, f.filename, j.judge from files f left join judgements j \
         on f.filename = j.filename where f.id = ?"
  in
  fun id (module Db : DB) ->
    let%lwt file_or_error = Db.find_opt query id in
    Caqti_lwt.or_fail file_or_error

let min_max_file_id =
  let query =
    (T.unit --> T.(tup2 int int)) @:- "select min(id), max(id) from files"
  in
  fun (module Db : DB) ->
    let%lwt file_or_error = Db.find query () in
    Caqti_lwt.or_fail file_or_error

let select_judge =
  let query =
    T.(tup2 string string -->? int)
    @:- "select id from judgements where user = ? and filename = ?"
  in
  fun user filename (module Db : DB) ->
    let%lwt id_or_error = Db.find_opt query (user, filename) in
    Caqti_lwt.or_fail id_or_error

let update_judge =
  let query =
    T.(tup3 bool string string -->. unit)
    @:- "update judgements set judge = ? where user = ? and filename = ?"
  in
  fun user filename judge (module Db : DB) ->
    let%lwt unit_or_error = Db.exec query (judge, user, filename) in
    Caqti_lwt.or_fail unit_or_error

let insert_judge =
  let query =
    R.exec
      T.(tup3 string string bool)
      "insert into judgements (user, filename, judge) values ($1, $2, $3)"
  in
  fun user filename judgement (module Db : DB) ->
    let%lwt unit_or_error = Db.exec query (user, filename, judgement) in
    Caqti_lwt.or_fail unit_or_error
