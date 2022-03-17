open Js_of_ocaml
module Html = Dom_html

let keyup ev =
  let valid = Html.getElementById_opt "valid" in
  let invalid = Html.getElementById_opt "invalid" in
  (* Firebug.console##log valid;
  Firebug.console##log invalid; *)
  let anime_class = Js.string "animate-ping" in
  let delay = 1000.0 in

  (match (valid, invalid) with
  | None, _ | _, None -> ()
  | Some v, Some i -> (
      let code = Js.Optdef.get ev##.code (fun () -> Js.string "") in
      let ocode = Js.to_string code in
      match ocode with
      | "KeyJ" ->
        let cl = v##.classList in
        cl##add anime_class;
        ignore (Html.setTimeout (fun () -> (
          cl##remove anime_class;

        )) delay);
        v##click
      | "KeyK" ->
          let cl = i##.classList in
          cl##add anime_class;
          ignore (Html.setTimeout (fun () -> (
            cl##remove anime_class;

          )) delay);
         i##click
      | _ -> ()));
  Js._true

let onloaded _ =
  ignore
    (Html.addEventListener Html.document Html.Event.keyup (Html.handler keyup)
       Js._true);
  Js._true

let () =
  ignore
    (Html.addEventListener Html.document Html.Event.domContentLoaded
       (Html.handler onloaded) Js._true)
