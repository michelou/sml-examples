(*
  A Polymorphic QuickSort function for any list.
  Stephen Freund
  cs334
*)

(* 
  partition: (('a * 'a -> bool) * 'a * 'a list) 
              -> ('a list * 'a list)
  In this version, you must supply a lessThan fuction for
  comparing values -- note the intended type is above, though
  inference gives you a slightly more general type...
*)
fun partition (lessThan, pivot, nil) = (nil, nil)
  | partition (lessThan, pivot, x::xs) =
      let val (smaller, bigger) = partition(lessThan, pivot, xs) 
      in
        if lessThan(x,pivot) then (x::smaller, bigger) 
                             else (smaller, x::bigger)
      end;

(* qsort: ('a * 'a -> bool) * 'a list -> 'a list *)
fun qsort (lessThan, nil) = nil
  | qsort (lessThan, p::rest) = 
      let val (smaller, bigger) = partition(lessThan, p,rest)
      in
        qsort (lessThan, smaller) @ [p] @ qsort(lessThan, bigger)
      end;

(*--------------------------------------------------------------------------*)

structure MainModule =
struct

fun listToString lst = List.foldr (
    fn (x, "") => (Int.toString x)
    |  (x, y)  => (Int.toString x) ^ "," ^ y) "" lst

fun listToString2 lst = List.foldr (
    fn (x, "") => x
    |  (x, y)  => x ^ "," ^ y) "" lst

fun main args = (* main (prog_name, args) = *)
    let
        val lst1 = [6, 23, 6, 3, 78, 23, 12, 6, 7, 34, 7]
        val _ = print("list1=" ^ listToString(lst1) ^ "\n")
        val _ = print("qsort1=" ^ listToString(qsort (op<, lst1)) ^ "\n\n")

        val lst2 = [~3, 5, 2, ~1]
        val _ = print("list2=" ^ listToString(lst2) ^ "\n")
        val _ = print("qsort2=" ^ listToString(qsort ((fn (x,y) => (abs x) < (abs y)), lst2)) ^ "\n\n")

        val lst3 = ["moo", "purple", "cow", "wombat"]
        val _ = print("list3=" ^ listToString2(lst3) ^ "\n")
        val _ = print("qsort3=" ^ listToString2(qsort (op<, lst3)) ^ "\n")

    in
        (* https://smlfamily.github.io/Basis/os-process.html *)
        OS.Process.exit (OS.Process.success)
    end

end (* MainModule *)

