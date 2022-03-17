type t = {
  id : int;
  filename : string;
  prediction : bool;
  judgement : bool option;
}
[@@deriving yojson]

let fetch_images path =
  let files = Sys.readdir path in
  Array.to_list files
  |> List.filter (fun x -> Filename.extension x = ".jpg")
  |> List.mapi (fun i x ->
         { id = i; filename = x; prediction = true; judgement = None })

let id t = t.id
let filename t = t.filename
let prediction t = t.prediction
let judgement t = t.judgement

let judgement_to_string t =
  match t.judgement with
  | None -> "Not yet"
  | Some true -> "Valid"
  | Some false -> "Invalid"

let predict_to_string t = if t.prediction then "Valid" else "Invalid"
let from_id i ts = List.find (fun e -> e.id == i) ts

let update i judge ts =
  List.map (fun e ->
    if e.id == i then {e with judgement = Some judge}
    else e) ts