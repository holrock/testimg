open Lwt.Infix

let collect_jpgs path =
  let files = Sys.readdir path in
  Array.to_list files
  |> List.filter (fun x -> Filename.extension x = ".jpg")

let main files =
  Lwt_io.printf "%s\n" "initialize database..." >>= fun () ->
  Lib.Migrate.migrate "sqlite3:./db/db.sqlite" files

let () =
  match Array.to_list Sys.argv with
  | [] | [ _ ] -> exit 1
  | _x :: xs ->
    let files = List.map collect_jpgs xs in
    let files = List.fold_left List.rev_append [] files in
    Lwt_main.run (main files)
