(* Exceptions *)

exception EmptyList

fun hd (h::_) = h
  | hd ([]) = raise EmptyList

exception Factorial

fun checked_factorial n =
    if n < 0 then
        raise Factorial
    else if n = 0 then
        1
         else
             n * checked_factorial (n-1)

local
    fun fact 0 = 1
      | fact n = n * fact (n-1)
in
    fun checked_factorial n =
        if n >= 0 then
            fact n
        else
            raise Factorial
end 

fun read_integer() = (
    print "Please enter an integer value: ";
    let
        val str = valOf (TextIO.inputLine TextIO.stdIn)
    in
        valOf (Int.fromString str)
    end
)

fun factorial_driver () =
    let
        val input = read_integer ()
        val result = Int.toString (checked_factorial input)
    in
        print(result ^ "\n")
    end
    handle Factorial => print "Out of range.\n"

exception EndOfFile
exception SyntaxError

fun factorial_driver1 () =
    let
        val input = read_integer ()
        val result = Int.toString (checked_factorial input)
        val _ = print(result ^ "\n")
    in
        factorial_driver1 ()
    end
    handle EndOfFile => print "Done.\n"
         | SyntaxError =>
           let val _ = print "Syntax error.\n" in factorial_driver1 () end
         | Factorial =>
           let val _ = print "Out of range.\n" in factorial_driver1 () end
         | Option => print "Done.\n"
         | Overflow =>
           let val _ = print "Overflow.\n" in factorial_driver1 () end

exception Change

fun change _ 0 = nil
  | change nil _ = raise Change
  | change (coin::coins) amt =
    if coin > amt then
        change coins amt
    else
       (coin :: change (coin::coins) (amt-coin))
       handle Change => change coins amt

(*--------------------------------------------------------------------------*)

structure MainModule =
struct

fun main args = (* main (prog_name, args) = *)
    let
        val _ = print("Exceptions\n\n")
        val _ = factorial_driver ()
        val _ = factorial_driver1 ()
    in

        (* https://smlfamily.github.io/Basis/os-process.html *)
        OS.Process.exit (OS.Process.success)
    end

end (* MainModule *)
