open Tyxml.Html

let link href text =
  a
    ~a:
      [
        a_href href;
        a_class
          [
            "underline";
            "text-blue-600";
            "hover:text-blue-800";
            "visited:text-purple-600";
          ];
      ]
    [ txt text ]

let head1 text = h1 ~a:[ a_class [ "text-xl"; "font-bold" ] ] [ txt text ]
let button text =
  button ~a:[a_class ["text-white"; "bg-blue-600"; "hover:bg-blue-800"; "rounded"; "px-2"; "py-2"]] [txt text]