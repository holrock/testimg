let image_states = ref (Lib.Img.fetch_images "/data/pentagon/test/gt2")
let list_states image_states = Lib.Page_img_state.show image_states
let html_to_string html = Format.asprintf "%a" (Tyxml.Html.pp ()) html

let update_handler req _image_state =
  match%lwt Dream.form req with
  | `Ok [ ("id", id); ("judge", judge) ] ->
      let id = int_of_string id in
      let judge = if String.equal judge "valid" then true else false in
      let new_state = Lib.Img.update id judge !image_states in
      let next_id = if id + 1 >= List.length new_state then 0 else id + 1 in
      image_states := new_state;
      Dream.redirect req ("/img/" ^ string_of_int next_id)
  | _ -> Dream.redirect req "/"

let () =
  Dream.run @@ Dream.logger @@ Dream.memory_sessions
  @@ Dream.router
       [
         ( Dream.get "/" @@ fun _ ->
           Dream.html (html_to_string (list_states !image_states)) );
         ( Dream.get "/img/:id" @@ fun req ->
           let id = Dream.param req "id" in
           let img = Lib.Img.from_id (int_of_string id) !image_states in
           Dream.html (Lib.Page_img.index img req) );
         ( Dream.get "/json" @@ fun _ ->
           Dream.json
             (let j = List.map Lib.Img.yojson_of_t !image_states in
              Yojson.Safe.to_string (`List j)) );
         (Dream.post "/update" @@ fun req -> update_handler req image_states);
         Dream.get "/images/**" @@ Dream.static "/data/pentagon/test/gt2/";
         Dream.get "/static/**" @@ Dream.static "static/";
         Dream.get "/favicon.ico" @@ Dream.static "static/";
       ]
