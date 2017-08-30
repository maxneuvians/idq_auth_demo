// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

let socket = new Socket("/socket", {params: {token: window.userToken}})

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("broker:" + window.username, {})

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("push_result", resp => {$("#push_result").html(" " + resp.result)})

$("#send_Button").on("click", e => {
  e.preventDefault();
  if($("#push_title").val().trim() != "" && $("#push_msg").val().trim() != ""){
    channel.push("push", {title: $("#push_title").val(), body: $("#push_msg").val()})
    $("#push_result").html(" Awaiting response")
  }
  else{
    alert("Push messages need a title and a body")
  }
})

export default socket
