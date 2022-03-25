module type DB = Caqti_lwt.CONNECTION

module R = Caqti_request
module T = Caqti_type

module Q = struct
  open Caqti_request.Infix
  open Caqti_type.Std

  let create_files =
    (unit -->. unit)
    @:- {eos|
      create table files (
        id integer primary key autoincrement,
        filename txt not null
      )
    |eos}

  let create_files_index =
    (unit -->. unit) @:- "create unique index idx_files on files (filename)"

  let create_judgements =
    (unit -->. unit)
    @:- {eos|
      create table judgements (
	      id integer primary key autoincrement,
	      user text not null,
	      filename text not null,
	      judge text not null
      )
    |eos}

  let create_judgements_index =
    (unit -->. unit)
    @:- "create unique index idx_judge on judgements (filename, user)"

  let insert_file =
    (string -->. unit) @:- "insert into files (filename) values (?)"
end

let create_files (module Db : DB) = Db.exec Q.create_files ()
let create_files_index (module Db : DB) = Db.exec Q.create_files_index ()
let create_judgements (module Db : DB) = Db.exec Q.create_judgements ()

let create_judgements_index (module Db : DB) =
  Db.exec Q.create_judgements_index ()

let insert_file filename (module Db : DB) =
   Db.exec Q.insert_file filename

open Lwt.Infix

let ( >>=? ) m f =
  m >>= function Ok x -> f x | Error err -> Lwt.return (Error err)

let run files db =
  create_files db >>=? fun () ->
  create_files_index db >>=? fun () ->
  create_judgements db >>=? fun () ->
  create_judgements_index db >>=? fun () ->
    let module Db = (val db: DB) in
    Db.with_transaction (fun () ->
      Lwt_list.fold_left_s
        (fun m f ->
          match m with Ok _ -> insert_file f db | Error _ as e -> Lwt.return e)
        (Ok ()) files
    )

let report_error = function
  | Ok () -> Lwt.return_unit
  | Error err -> Lwt_io.eprintl (Caqti_error.show err) >|= fun () -> exit 1

let migrate conn files =
  Caqti_lwt.with_connection (Uri.of_string conn) (run files) >>= report_error
