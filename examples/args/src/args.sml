structure MainModule =
struct

fun printList(nil) = ()
|   printList(x::xs) = ( print(x); print(" "); printList(xs) )

fun main args = (* main (prog_name, args) = *)
    let
        (* SML/NJ: CommandLine.name () returns %SMLNJ_HOME%\bin\.run\run.x86-win32.exe *)
        val _ = print ("Command: " ^ CommandLine.name () ^ "\n")
        val _ = ( print "Arguments: "; printList args; print "\n" )

        val _ = case CommandLine.arguments () of
          [] => print ("Too few arguments!\n")
        | [arg1] => print ("That's right! " ^ arg1 ^ "\n")
        | args   => print ("Too many arguments!\n")
    in
        (* https://smlfamily.github.io/Basis/os-process.html *)
        OS.Process.exit (OS.Process.success)
    end

end (* MainModule *)
