
open TextIO;

val END = ~1;

fun digit(c) = c >= #"0" andalso c <= #"9";

fun startInt(file) = startInt1(file, input1(file))

and startInt1(file, NONE) = END
|   startInt1(file, SOME c) =
    if digit(c) then ord(c) - ord(#"0")
    else startInt(file);

fun finishInt(i, file) =
    if i = END then END
    else finishInt1(i, file, input1(file))

and finishInt1(i, file, NONE) = i
|   finishInt1(i, file, SOME c) =
    if digit(c) then finishInt(10*i + ord(c) - ord(#"0"), file)
    else i;

fun getInt(file) = finishInt(startInt(file), file)

fun sumInts1(file) =
    let
        val i = getInt(file)
    in
        if i = END then 0
        else i + sumInts1(file)
    end;

fun sumInts(filename) = sumInts1(openIn(filename));

(*--------------------------------------------------------------------------*)

structure MainModule =
struct

fun main args =  (* main prog_name, args) *)
    let
        val _ = print("sumInts=" ^ Int.toString(sumInts("sumInts.txt")) ^ "\n")
    in
        (* https://smlfamily.github.io/Basis/os-process.html *)
        OS.Process.exit (OS.Process.success)
    end

end (* MainModule *)
