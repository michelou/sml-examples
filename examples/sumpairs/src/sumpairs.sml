fun sumpairs [] = []
  | sumpairs [x] = [x]
  | sumpairs (x::y::xs) = x + y :: sumpairs xs

structure MainModule =
struct

fun listToString lst = List.foldr (
    fn (x, "") => (Int.toString x)
    |  (x, y)  => (Int.toString x) ^ "," ^ y) "" lst;

fun main args = (* main (prog_name, args) = *)
    let
        val lst = [1, 2, 3, 4]
        val _ = print("list=" ^ listToString(lst) ^ "\n")
        val _ = print("sumpairs=" ^ listToString(sumpairs(lst)) ^ "\n")
    in
        (* https://smlfamily.github.io/Basis/os-process.html *)
        OS.Process.exit (OS.Process.success)
    end

end (* MainModule *)
