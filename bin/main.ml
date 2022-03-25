let image_states = ref (Lib.Img.fetch_images "/data/pentagon/test/gt2")
(* let list_states image_states = Lib.Page_img_state.show image_states *)
(* let html_to_string html = Format.asprintf "%a" (Tyxml.Html.pp ()) html *)

let update_handler req image_state =
  match%lwt Dream.form req with
  | `Ok [ ("id", id); ("judge", judge); ("user", user) ] ->
      let id = int_of_string id in
      let judge = if String.equal judge "valid" then true else false in
      let new_state = Lib.Img.update id judge !image_states in
      let next_id = if id + 1 >= List.length new_state then 0 else id + 1 in
      let img = Lib.Img.from_id id !image_state in
      let filename = Lib.Img.filename img in
      let%lwt judgded = Dream.sql req (Lib.Db.select_judge user filename) in
      if Option.is_none judgded then (
        let%lwt () = Dream.sql req (Lib.Db.insert_judge user filename judge) in
        image_states := new_state;
        Dream.redirect req ("/img/" ^ string_of_int next_id))
      else
        let%lwt () = Dream.sql req (Lib.Db.update_judge user filename judge) in
        image_states := new_state;
        Dream.redirect req ("/img/" ^ string_of_int next_id)
  | _ ->
      let () = Dream.add_flash_message req "Error" "post param error" in
      Dream.redirect req "/"

let set_username req =
  match%lwt Dream.form req with
  | `Ok [ ("username", username) ] ->
      let resp = Dream.response ~status:`See_Other "" in
      Dream.set_cookie resp req "username" username;
      Dream.set_header resp "Location" "/";
      Lwt.return resp
  | _ -> Dream.json "err"

let () =
  Dream.run ~interface:"0.0.0.0"
  @@ Dream.set_secret "hogehoge"
  @@ Dream.sql_pool "sqlite3:db.sqlite"
  @@ Dream.logger @@ Dream.memory_sessions @@ Dream.flash
  @@ Dream.router
       [
         ( Dream.get "/comments" @@ fun req ->
           let%lwt comments = Dream.sql req Lib.Db.list_comments in
           Dream.html (Lib.Page.comment comments) );
         ( Dream.get "/" @@ fun req ->
           let username =
             Option.value (Dream.cookie req "username") ~default:""
           in
           Lib.Page.index req !image_states username |> Dream.html );
         ( Dream.get "/img/:id" @@ fun req ->
           let id = Dream.param req "id" in
           let username =
             Option.value (Dream.cookie req "username") ~default:""
           in
           let img = Lib.Img.from_id (int_of_string id) !image_states in
           Dream.html (Lib.Page_img.index req img username) );
         ( Dream.get "/json" @@ fun _ ->
           Dream.json
             (let j = List.map Lib.Img.yojson_of_t !image_states in
              Yojson.Safe.to_string (`List j)) );
         (Dream.post "/update" @@ fun req -> update_handler req image_states);
         (Dream.post "/username" @@ fun req -> set_username req);
         Dream.get "/images/**" @@ Dream.static "/data/pentagon/test/gt2/";
         Dream.get "/static/**" @@ Dream.static "static/";
         Dream.get "/favicon.ico" @@ Dream.static "static/";
       ]
