let id_to_link id = "img/" ^ string_of_int id

let show image_states =
  let open Tyxml.Html in
  let s_to_row i (s : Img.t) =
    tr
      [
        td [ txt (string_of_int i) ];
        td [ Style.link (id_to_link (Img.id s)) (Img.filename s) ];
        (* td [ txt (Img.predict_to_string s ) ]; *)
        td [ txt (Img.judgement_to_string s) ];
      ]
  in
  Page_base.page "List"
    (body
       [
         div
           ~a:[ a_class [ "container"; "mx-auto"; "p-4" ] ]
           [
             div
               ~a:[ a_class [ "my-4" ] ]
               [ 
                 button
                   ~a:
                     [
                       a_id "download";
                       a_class
                         [
                           "text-white";
                           "bg-blue-600";
                           "hover:bg-blue-800";
                           "rounded";
                           "px-2";
                           "py-2";
                         ];
                     ]
                   [ txt "Download" ];
               ];
             table
               ~a:[ a_class [ "table-auto" ] ]
               (List.mapi s_to_row image_states);
           ];
         script ~a:[ a_src "/static/index.js" ] (txt " ");
       ])