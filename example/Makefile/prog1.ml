(* From the manual https://v2.ocaml.org/manual/intfc.html#ss:c-unboxed  *)
let f a b =
  let len = Array.length a in
  assert (Array.length b = len) ;
  let res = Array.make len 0. in
  for i = 0 to len - 1 do
    res.(i) <- Foo.foo a.(i) b.(i)
  done ;
  res

let () =
  let a = Array.init 10 float_of_int in
  let b = Array.init 10 float_of_int |> Array.map (fun x -> x +. 1.) in
  let ra = f a b in
  ra |> Array.iteri @@ fun i r -> assert (r = a.(i) +. b.(i))
