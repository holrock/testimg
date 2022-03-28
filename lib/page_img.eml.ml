  let h1_class judge =
    match judge with
    | None -> "bg-lime-600"
    | Some true -> "bg-blue-600"
    | Some false -> "bg-red-600"

  let index request (id, filename, judge) username next_id last_id : string =
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
          <h1 class="p-1 text-2xl font-bold <%s h1_class judge %>">
            <%s filename %>
          </h1>
          <div class="flex flex-row p-2">
            <div class="mr-4">
              <img src="/images/<%s filename %>" alt="img" width="600" />
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
                <input type="hidden" name="id" value="<%s id |> string_of_int %>" />
                <input type="hidden" name="filename" value="<%s filename %>" />
                <div class="mt-auto mb-4">
                  <a href="/img/<%i last_id %>" class="underline text-blue-300 hover:text-blue-400 visited:text-purple-300">back</a>
                  <a href="/img/<%i next_id %>" class="ml-2 underline text-blue-300 hover:text-blue-400 visited:text-purple-300">next</a>
                </div>
                <div>
                  <a href="/" class="underline text-blue-300 hover:text-blue-400 visited:text-purple-300">index</a>
                </div>
              </div>
            </form>
          </div>
        </div>
      </body>
    </html>