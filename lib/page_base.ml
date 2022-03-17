let page page_title page_body =
  let open Tyxml.Html in
  html
    ~a:[ a_lang "ja" ]
    (head
       (title (txt page_title))
       [
         meta ~a:[ a_charset "UTF-8" ] ();
         meta
           ~a:
             [
               a_name "viewport";
               a_content "width=device-width,initial-scale=1.0";
             ]
           ();
         script ~a:[ a_src "/static/tailwind.js" ] (txt " ");
       ])
    page_body