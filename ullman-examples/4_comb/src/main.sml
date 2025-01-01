
open TextIO;

fun put(0) = output(stdOut, "\n")
|   put(n) = (output(stdOut, "X"); put(n-1))

fun comb(n, m) = (
    put(n);
    if m = 0 orelse m = n then 1
    else comb(n-1, m) + comb(n-1, m-1)
)

structure MainModule =
struct

fun main args =  (* main (prog_name, args) *)
    let
        val _ = print("comb(5, 2)=" ^ Int.toString(comb(5, 2)) ^ "\n")
    in
        (* https://smlfamily.github.io/Basis/os-process.html *)
        OS.Process.exit (OS.Process.success)
    end

end (* MainModule *)
