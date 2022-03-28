let update_handler req =
  match%lwt Dream.form req with
  | `Ok [ ("filename", filename); ("id", id); ("judge", judge); ("user", user) ]
    ->
      let id = int_of_string id in
      let judge = if String.equal judge "valid" then true else false in
      let%lwt judgded = Dream.sql req (Lib.Db.select_judge user filename) in
      let%lwt min_id, max_id = Dream.sql req Lib.Db.min_max_file_id in
      let next_id = if id >= max_id then min_id else id + 1 in
      if Option.is_none judgded then
        let%lwt () = Dream.sql req (Lib.Db.insert_judge user filename judge) in
        Dream.redirect req ("/img/" ^ string_of_int next_id)
      else
        let%lwt () = Dream.sql req (Lib.Db.update_judge user filename judge) in
        Dream.redirect req ("/img/" ^ string_of_int next_id)
  | `Ok sl ->
      List.iter (fun (k, v) -> Dream.log "%s,%s" k v) sl;
      Dream.redirect req "/"
  | _ ->
      let () = Dream.add_flash_message req "Error" "post param error" in
      Dream.redirect req "/"

let set_username req =
  match%lwt Dream.form req with
  | `Ok [ ("username", username) ] ->
      let username = String.trim username in
      let resp = Dream.response ~status:`See_Other "" in
      if String.length username = 0 then Dream.drop_cookie resp req "username"
      else Dream.set_cookie resp req "username" username;
      Dream.set_header resp "Location" "/";
      Lwt.return resp
  | _ ->
      Dream.add_flash_message req "Error" "Invalid username";
      Dream.redirect req "/"

let index_handler req =
  match Dream.cookie req "username" with
  | Some username ->
      let username = String.trim username in
      if String.length username = 0 then
        Lib.Page.index_no_name req |> Dream.html
      else
        let%lwt judges = Dream.sql req (Lib.Db.list_judges username) in
        Lib.Page.index req judges username |> Dream.html
  | None -> Lib.Page.index_no_name req |> Dream.html

let img_handler req =
  let id = Dream.param req "id" in
  let username = Option.value (Dream.cookie req "username") ~default:"" in
  let%lwt file = Dream.sql req (Lib.Db.find_file (int_of_string id)) in
  match file with
  | None -> Dream.redirect req "/"
  | Some file -> Dream.html (Lib.Page_img.index req file username)

let () =
  Dream.run ~interface:"0.0.0.0"
  @@ Dream.set_secret (Sys.getenv "DREAM_SECRET")
  @@ Dream.sql_pool "sqlite3:db/db.sqlite"
  @@ Dream.logger @@ Dream.memory_sessions @@ Dream.flash
  @@ Dream.router
       [
         Dream.get "/" @@ index_handler;
         Dream.get "/img/:id" @@ img_handler;
         Dream.post "/update" @@ update_handler;
         Dream.post "/username" @@ set_username;
         Dream.get "/images/**" @@ Dream.static "/data/pentagon/test/gt2/";
         Dream.get "/static/**" @@ Dream.static "static/";
         Dream.get "/favicon.ico" @@ Dream.static "static/";
       ]
