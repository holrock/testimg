let index () =
  let open Tyxml.Html in
  Page_base.page "Index"
    (body
       [
         div
           ~a:[ a_class [ "container"; "mx-auto"; "p-4" ] ]
           [
             h1 ~a:[ a_class [ "text-xl"; "font-bold" ] ] [ txt "Image Filter" ];
             Style.link "/states" "status";
           ];
       ])
