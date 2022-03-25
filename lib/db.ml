module type DB = Caqti_lwt.CONNECTION

module R = Caqti_request
module T = Caqti_type

let list_comments =
  let query =
    R.collect T.unit T.(tup2 int string) "select id, text from comment"
  in
  fun (module Db : DB) ->
    let%lwt comments_of_error = Db.collect_list query () in
    Caqti_lwt.or_fail comments_of_error

let select_judge =
  let open Caqti_type.Std in
  let open Caqti_request.Infix in
  let query =
    (tup2 string string -->? int)
    @:- "select id from judgement where user = ? and filename = ?"
  in
   fun user filename (module Db: DB) ->
   let%lwt id_or_error = Db.find_opt query (user, filename) in
   Caqti_lwt.or_fail id_or_error

let update_judge =
  let open Caqti_type.Std in
  let open Caqti_request.Infix in
  let query =
    (tup3 bool string string -->. unit)
    @:- "update judgement set judge = ? where user = ? and filename = ?"
  in
   fun user filename judge (module Db: DB) ->
   let%lwt unit_or_error = Db.exec query (judge, user, filename) in
   Caqti_lwt.or_fail unit_or_error

let insert_judge =
  let query =
    R.exec
      T.(tup3 string string bool)
      "insert into judgement (user, filename, judge) values ($1, $2, $3)"
  in
  fun user filename judgement (module Db : DB) ->
    let%lwt unit_or_error = Db.exec query (user, filename, judgement) in
    Caqti_lwt.or_fail unit_or_error
