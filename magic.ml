open Printf

open Tgles2

let vertex_shader_src =
 "attribute vec4 vPosition; \
  void main() { \
    gl_Position = vPosition; \
  }"

let fragment_shader_src =
 "uniform vec4 vColor; \
  void main() { \
    gl_FragColor = vColor; \
  }"

let glshader typ src =
  let shader = Gl.create_shader typ in
  Gl.shader_source shader src;
  Gl.compile_shader shader;
  shader

let glsetup () =
  Gl.clear_color 0.0 0.0 0.0 1.0;
  let vertex_shader = glshader Gl.vertex_shader vertex_shader_src
  and fragment_shader = glshader Gl.fragment_shader fragment_shader_src in
  let program = Gl.create_program () in
  Gl.attach_shader program vertex_shader;
  Gl.attach_shader program fragment_shader;
  Gl.link_program program;
  program

let glresize width height =
  let size = min width height in
  Gl.viewport (width - size) (height - size) size size

let glfloatbuf a = Bigarray.(Array1.of_array float32 c_layout a)

let triangle = glfloatbuf [|
     0.0;  0.622008459; 0.0;
    -0.5; -0.311004243; 0.0;
     0.5; -0.311004243; 0.0;
  |]

let color = glfloatbuf [| 0.63671875; 0.76953125; 0.22265625; 1.0 |]

let gldraw program =
  Gl.clear Gl.color_buffer_bit;
  Gl.use_program program;
  printf "using program\n%!";
  let position_hnd = Gl.get_attrib_location program "vPosition" in
  Gl.enable_vertex_attrib_array position_hnd;
  Gl.vertex_attrib_pointer position_hnd 3 Gl.float false 0 (`Data triangle);
  let color_hnd = Gl.get_uniform_location program "vColor" in
  Gl.uniform4fv color_hnd 1 color;
  Gl.draw_arrays Gl.triangles 0 3;
  Gl.disable_vertex_attrib_array position_hnd

(*
let rec loop window program =
  let event = Sdl.Event.create () in
  if Sdl.wait_event_timeout (Some event) 100 then
    match Sdl.Event.(enum (get event typ)) with
    | `Quit -> ()
    | `Window_event ->
      begin match Sdl.Event.(window_event_enum (get event window_event_id)) with
      | `Size_changed ->
        let width, height = Sdl.Event.(get event window_data1, get event window_data2) in
        Sdl.log "Resized: %ld,%ld" width height;
        glresize (Int32.to_int width) (Int32.to_int height);
        loop window program
      | _ -> loop window program
      end
    | _ -> loop window program
  else
    (gldraw program; Sdl.gl_swap_window window; loop window program)
 *)

let program = glsetup ()

let redraw () =
  print_endline "Redraw";
  gldraw program;
  ()


let () = Callback.register "camlRedraw" redraw


