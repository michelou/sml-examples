use "src/helper.sml"; (* <- this semicolon is required *)

structure MainModule =
struct

open Helper;

fun norm (x, y) = Math.sqrt (square x + square y)

fun main args = (* main (prog_name, args) = *)
    let
        val c = cube pi  (* Helper.cube Helper.pi *)
        val d = degreeToRadian 90.0
        val _ = print("c=" ^ Real.toString(c) ^ "\n")
        val _ = print("d=" ^ Real.toString(d) ^ "\n")
        val _ = print("norm=" ^ Real.toString(norm (2.0, 3.0)) ^ "\n")
    in
        (* https://smlfamily.github.io/Basis/os-process.html *)
        OS.Process.exit (OS.Process.success)
    end

end (* MainModule *)
