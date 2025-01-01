
fun merge(nil, M) = M
|   merge(L, nil) = L
|   merge(L as x::xs, M as y::ys) =
        if x < y then x::merge(xs, M)
        else y::merge(L, ys)

fun split(nil) = (nil, nil)
|   split([a]) = ([a], nil)
|   split(a::b::cs) =
        let
            val (M, N) = split(cs)
        in
            (a::M, b::N)
        end

fun mergeSort(nil) = nil
|   mergeSort([a]) = [a]
|   mergeSort(L) =
        let
            val (M, N) = split(L);
            val M = mergeSort(M);
            val N = mergeSort(N)
        in
            merge(M, N)
        end

(*--------------------------------------------------------------------------*)

structure MainModule =
struct

fun listToString lst = List.foldr (
    fn (x, "") => (Int.toString x)
    |  (x, y)  => (Int.toString x) ^ "," ^ y) "" lst;

fun main args = (* main (prog_name, args) *)
    let
        val lst = [1, 3, 7, 2, 9, 6]
        val _ = print("list=" ^ listToString(lst) ^ "\n")
        val _ = print("sorted=" ^ listToString(mergeSort(lst)) ^ "\n")
    in
        (* https://smlfamily.github.io/Basis/os-process.html *)
        OS.Process.exit (OS.Process.success)
    end

end (* MainModule *)
