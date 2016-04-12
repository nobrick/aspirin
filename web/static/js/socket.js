// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket} from "phoenix"
import moment from "moment"

let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "web/templates/layout/app.html.eex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/2" function
// in "web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1209600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, pass the token on connect as below. Or remove it
// from connect if you don't care about authentication.

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("status:all", {})
let monitorState = $('#monitor-state')
channel.join()
  .receive("ok", resp => {
    console.log("Joined", resp)
    if(monitorState.length) {
      monitorState.html('<h2 class="text-success">Monitoring</h2>')
    }
  })
  .receive("error", resp => {
    console.log("Unable to join", resp)
    if(monitorState.length) {
      monitorState.html('<h2 class="text-danger">Connection Failed</h2>')
    }
  })
  .receive("timeout", resp => {
    console.log("Unable to join due to timeout", resp)
    if(monitorState.length) {
      monitorState.html('<h2 class="text-danger">Connection Timeout</h2>')
    }
  })

channel.on("test_port", payload => {
  console.log(payload)
  let row = $('tr#' + payload.identity)
  let eventState = row.find('.event-state')
  let eventStateUpdatedAt = row.find('.state-updated-at')
  if(payload.body == 'success') {
    eventState.html('<span class="label label-success">ACTIVE</span>')
    eventState.removeClass('text-danger')
    eventState.addClass('text-success')
    row.removeClass('danger')
  } else {
    eventState.html('<span class="label label-danger">INACTIVE</span><span class="label label-danger">' + payload.reason + "</span>")
    eventState.removeClass('text-success')
    eventState.addClass('text-danger')
    row.addClass('danger')
  }
  eventStateUpdatedAt.data('time', payload.timestamp)
  eventStateUpdatedAt.text(moment(payload.timestamp).fromNow())
})

socket.onError(() => {
    if(monitorState.length) {
      monitorState.html('<h2 class="text-danger">Connection Error</h2>')
    }
})

$(".monitor-index-page").ready(() => {
  setInterval(() => {
    $('.state-updated-at').each((_index, elem) => {
      $(elem).text(moment($(elem).data('time')).fromNow())
    })
  }, 1000)
})

export default socket
