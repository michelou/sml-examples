(*
  A QuickSort function for int lists.
  Stephen Freund
  cs334
*)

(* 
   Partition: int * int list -> int list * int list
   Partition list around the pivot, and return the lists
   of smaller and larger elements. 
*)
fun partition (pivot, nil) = (nil, nil)
  | partition (pivot, x::xs) =
      let val (smaller, bigger) = partition (pivot, xs) 
      in
        if x < pivot then (x::smaller, bigger) 
                     else (smaller, x::bigger)
      end

(* 
   qsort: int list -> int list
   Sort a list of integers using quick sort. 
*)
fun qsort (nil) = nil
  | qsort (p::rest) = 
      let val (smaller, bigger) = partition(p,rest)
      in
        qsort(smaller) @ [p] @ qsort(bigger)
      end

(*--------------------------------------------------------------------------*)

structure MainModule =
struct

fun listToString lst = List.foldr (
    fn (x, "") => (Int.toString x)
    |  (x, y)  => (Int.toString x) ^ "," ^ y) "" lst

fun main args = (* main (prog_name, args) = *)
    let
        val lst = [6,23,6,3,78,23,12,6,7,34,7,1,23,7,23,6,3,6]
        val _ = print("list=" ^ listToString(lst) ^ "\n")
        val _ = print("qsort=" ^ listToString(qsort(lst)) ^ "\n")
    in
        (* https://smlfamily.github.io/Basis/os-process.html *)
        OS.Process.exit (OS.Process.success)
    end

end (* MainModule *)
