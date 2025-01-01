structure MainModule =
struct

open TextIO;

exception Syntax;

fun digit(c) = (#"0" <= c andalso c <= #"9")

fun blank(c) = #" " = c orelse #"\t" = c

fun lookahead2(IN) =
    case lookahead(IN) of
        SOME c =>
            if blank(c) then (
                input1(IN); (* consume blank character *)
                lookahead2(IN)
            )
            else SOME c
        |
        NONE => NONE

fun integer(IN, i) =
    case lookahead2(IN) of
        SOME c =>
            if digit(c) then (
                input1(IN); (* consume character c *)
                integer(IN, 10*i + ord(c) - ord(#"0"))
            )
            else i (* if c is not a digit, return i 
                         without consuming input *)
        |
        NONE => i (* ditto if end of file is reached *)

fun atom(IN) =
    case lookahead2(IN) of
        SOME #"(" => (
            input1(IN); (* consume left paren *)
            let
                val e = expression(IN)
            in
                if lookahead2(IN) = (SOME #")") then (
                    input1(IN); (* consume right parenthesis *)
                    e (* return expression *)
                )
                else raise Syntax
            end
        )
        |
        SOME c =>
            if digit(c) then integer(IN, 0)
            else raise Syntax
        |
        NONE => raise Syntax
and
    term(IN) = termTail(IN, atom(IN))
and
    termTail(IN, i) =
        case lookahead2(IN) of
            SOME #"*" => (
                input1(IN); (* consume * *)
                termTail(IN, i*atom(IN))
            )
            |
            SOME #"/" => (
                input1(IN); (* consume / *)
                termTail(IN, i div atom(IN))
            )
            |
            _ => i
and
    expression(IN) = expTail(IN, term(IN))
and
    expTail(IN, i) =
        case lookahead2(IN) of
            SOME #"+" => (
                input1(IN); (* consume + *)
                expTail(IN, i+term(IN))
            )
            |
            SOME #"-" => (
                input1(IN); (* consume - *)
                expTail(IN, i-term(IN))
            )
            |
            _ => i;

fun main args = (* main (prog_name, args) *)
    let
        val infile = openIn("parseExpression.txt")
        val _ = print("expression=" ^ Int.toString(expression(infile)) ^ "\n")
    in
        (* https://smlfamily.github.io/Basis/os-process.html *)
        OS.Process.success
    end

end (* MainModule *)
