let id_to_link id = "img/" ^ string_of_int id

let index request image_states username =
  <html>
    <head>
      <meta charset="utf-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1" />
      <script src="/static/tailwind.js"></script>
      <title>Image List</title>
    </head>
    <body class="bg-gray-800 text-gray-100">
      <div class="container mx-auto px-4">
        <h1 class="text-2xl font-bold mb-4">Image List</h1>
        <div class="w-full">
%         Dream.flash_messages request |> List.iter (fun (category , text) ->
            <p><%s category %>: <%s text %></p><% ); %>
          <div class="">
            <form method="POST" action="/username">
              <%s! Dream.csrf_tag request %>
              <label>UserName:
              <span class="mx-2 text-black">
                <input type="text" name="username" value=<%s username %>>
              </span>
              </label>
              <button class="button rounded bg-blue-600 text-gray-200 p-1">Set</button>
            </form>
          </div>
          <table class="w-full table-auto border-collapse">
            <thead>
              <tr>
                <th class="p-2 border-b border-gray-500">index</th>
                <th class="p-2 border-b border-gray-500">file name</th>
                <th class="p-2 border-b border-gray-500">judgement</th>
              </tr>
            </thead>
            <tbody>
%             image_states |> List.iteri begin fun idx i ->
                <tr class="hover:bg-gray-600">
                  <td class="p-2 border-b border-gray-400"><%d idx + 1 %></td>
                  <td class="p-2 border-b border-gray-500">
                    <a href="<%s Img.id i |> id_to_link  %>" class="underline text-blue-400 hover:text-blue-200 visited:text-purple-400">
                      <%s Img.filename i %>
                    </a>
                  </td>
                  <td class="p-2 border-b border-gray-500"><%s Img.judgement_to_string i %></td>
                </tr>
%            end;
            </tbody>
          </table>
        </div>
      </div>
    </body>
  </html>


let comment comments =
  <html>
  <body>
%    comments |> List.iter (fun (_id, comment) ->
        <p><%s comment %></p><% ); %>
  </body>
  </html>