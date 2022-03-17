(* open Tyxml.Html *)

(* let index id =
  let t = "Image" ^ id in
  Page_base.page t (body [ h1 [ txt t ] ]) *)

  let index img request : string =
    <!DOCTYPE html>
    <html lang="ja">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <script src="/static/tailwind.js"></script>
        <script src="/static/client.js"></script>
      </head>
      <body class="bg-gray-800 text-white">
        <div class="container mx-auto p-4">
          <h1 class="text-xl font-bold">
            <%s Img.filename img %>
          </h1>
          <div class="flex">
            <p>prediction:
              <%s Img.predict_to_string img %>
            <br>
            judgement:
              <%s Img.judgement_to_string img %>
            </p>
          </div>
          <div class="flex flex-row p-2">
            <div class="mr-4">
              <img src="/images/<%s Img.filename img %>" alt="img" width="600" />
            </div>
            <form method="POST" action="/update">
              <div class="flex flex-col h-full justify-between">
                <%s! Dream.csrf_tag request %>
                <button
                  id="valid"
                  name="judge"
                  value="valid"
                  class="bg-blue-500 hover:bg-blue-700 text-white text-xl font-bold py-4 px-4 rounded mb-4"
                >
                  Valid
                </button>
                <button
                  id="invalid"
                  name="judge"
                  name="judge"
                  value="invalid"
                  class="bg-red-500 hover:bg-red-700 text-white text-xl font-bold py-4 px-4 rounded"
                >
                  Invalid
                </button>
                <input type="hidden" name="id" value="<%s Img.id img |> string_of_int %>" />
                <div class="mt-auto">
                  <a href="/" class="underline text-blue-300 hover:text-blue-400 visited:text-purple-300">back</a>
                </div>
              </div>
            </form>
          </div>
        </div>
      </body>
    </html>