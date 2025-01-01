signature SIG1 =
sig
    val i: int;
    type t;
    val x: t
    val y: t
    val f: t * t -> bool
    val T_toString: t -> string
end;

structure Struct1 =
struct
    val i = 3;
    type t = int;
    val x = 4;
    val y = 5;
    fun f(a, b) = (a = b)
    fun T_toString(x) = Int.toString(x)
end;

structure Struct2: SIG1 = Struct1;

structure Struct3:> SIG1 = Struct1;

structure MainModule =
struct

fun main args = (* main (prog_name, args) = *)
    let
        open Struct2;

        val b1 = f(x, y);
        val b2 = f(i, y);
        val b3 = f(2*x, i+y);

        val _ = print("i=" ^ Int.toString(i) ^ ", x=" ^ Int.toString(x) ^ ", y=" ^ Int.toString(y) ^ "\n")
        val _ = print("b1=" ^ Bool.toString(b1) ^ "\n")
        val _ = print("b2=" ^ Bool.toString(b2) ^ "\n")
        val _ = print("b3=" ^ Bool.toString(b3) ^ "\n")

        (*----------------------------------------------*)

        open Struct3;

        val b1 = f(x, y);
        (*val b2 = f(i, y);*)  (* found: int, expected: t in 1st argument *)

        val _ = print("\n")
        val _ = print("i=" ^ Int.toString(i) ^ ", x=" ^ T_toString(x) ^ ", y=" ^ T_toString(y) ^ "\n")
        val _ = print("b1=" ^ Bool.toString(b1) ^ "\n")
    in
        (* https://smlfamily.github.io/Basis/os-process.html *)
        OS.Process.exit (OS.Process.success)
    end

end (* MainModule *)
