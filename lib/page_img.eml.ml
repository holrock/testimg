  let index request img username : string =
    <!DOCTYPE html>
    <html lang="ja">
      <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <script src="/static/tailwind.js"></script>
        <script src="/static/image.js"></script>
      </head>
      <body class="bg-gray-800 text-white">
        <div class="container mx-auto p-4">
          <h1 class="text-xl font-bold">
            <%s Img.filename img %>
          </h1>
          <div class="flex">
            judgement:
              <%s Img.judgement_to_string img %>
            </p>
          </div>
          <div class="flex flex-row p-2">
            <div class="mr-4">
              <img src="/images/<%s Img.filename img %>" alt="img" width="600" />
            </div>
            <form method="POST" action="/update">
              <input type="hidden" name="user" value="<%s username %>">
              <div class="flex flex-col h-full justify-between">
                <%s! Dream.csrf_tag request %>
                <button
                  id="valid"
                  name="judge"
                  value="valid"
                  class="bg-blue-500 hover:bg-blue-700 text-white text-xl font-bold py-4 px-4 rounded mb-4"
                >
                  Valid (J)  
                </button>
                <button
                  id="invalid"
                  name="judge"
                  name="judge"
                  value="invalid"
                  class="bg-red-500 hover:bg-red-700 text-white text-xl font-bold py-4 px-4 rounded"
                >
                  Invalid (K)
                </button>
                <input type="hidden" name="id" value="<%s Img.id img |> string_of_int %>" />
                <div class="mt-auto">
%                 let id = Img.id img in
%                 if id > 0 then begin
                    <a href="/img/<%i id - 1 %>" class="underline text-blue-300 hover:text-blue-400 visited:text-purple-300">back</a>
%                 end;
                  <a href="/" class="underline text-blue-300 hover:text-blue-400 visited:text-purple-300">index</a>
                </div>
              </div>
            </form>
          </div>
        </div>
      </body>
    </html>