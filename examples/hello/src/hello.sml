structure MainModule =
struct

fun hello () =
    print "Hello World\n"

fun main args = (
    hello ();
    OS.Process.exit (OS.Process.success)
) 

end (* MainModule *)
