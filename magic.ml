open Printf

let redraw () =
  print_endline "Redraw"


let () = Callback.register "camlRedraw" redraw

