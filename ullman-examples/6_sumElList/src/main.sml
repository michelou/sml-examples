structure MainModule =
struct

datatype ('a, 'b) element =
    P of 'a * 'b
|   S of 'a;

fun sumElList(nil) = 0
|   sumElList(S(x)::L) = sumElList(L)
|   sumElList(P(x, y)::L) = y + sumElList(L);

fun listToString(nil) = ""
|   listToString(S(x)::L) = "S(" ^ Int.toString(x) ^ ")," ^ listToString(L)
|   listToString(P(x, y)::L) = "P(" ^ Int.toString(x) ^ "," ^ Int.toString(y) ^ ")," ^ listToString(L)

fun main args = (* main (prog_name, args) *)
    let
        val lst = [P(1, 4), S(5), P(2, 5), P(9, 3)]
        val _ = print("lst=" ^ listToString(lst) ^ "\n")
        val _ = print("sumElList=" ^ Int.toString(sumElList(lst)) ^ "\n")
    in
        (* https://smlfamily.github.io/Basis/os-process.html *)
        OS.Process.exit (OS.Process.success)
    end

end (* MainModule *)
