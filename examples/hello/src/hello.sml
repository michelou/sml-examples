fun hello () =
    print "Hello World\n"

structure MainModule =
struct

fun main args = (
    hello ();
    OS.Process.exit (OS.Process.success)
) 

end (* MainModule *)
