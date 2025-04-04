(* Views and Abstraction *)

signature DICT = sig
  type key
  val lt : key * key -> bool
  val eq : key * key -> bool
  type 'a dict
  val empty : 'a dict
  val insert : 'a dict * key * 'a -> 'a dict
  val lookup : 'a dict * key -> 'a
end

exception NotImplemented

structure IntDict :> DICT = struct
  type key = int
  val lt : key * key -> bool = (op <)
  val eq : key * key -> bool = (op =)
  datatype 'a dict = Empty | Node of 'a dict * 'a * 'a dict
  val empty = Empty
  fun insert (d, k, e) = raise NotImplemented
  fun lookup (d, k) = raise NotImplemented
end

signature INT_DICT = DICT where type key = int


structure IntDict :> INT_DICT = struct
  type key = int
  val lt : key * key -> bool = (op <)
  val eq : key * key -> bool = (op =)
  datatype 'a dict = Empty | Node of 'a dict * 'a * 'a dict
  val empty = Empty
  fun insert (d, k, e) = raise NotImplemented
  fun lookup (d, k) = raise NotImplemented
end

signature STRING_DICT = DICT where type key = string

structure StringDict :> STRING_DICT = struct
  type key = string
  val lt : key * key -> bool = (op <)
  val eq : key * key -> bool = (op =)
  datatype 'a dict = Empty | Node of 'a dict * 'a * 'a dict
  val empty = Empty
  fun insert (d, k, e) = raise NotImplemented
  fun lookup (d, k) = raise NotImplemented
end

(*--------------------------------------------------------------------------*)

structure MainModule =
struct

fun main args = (* main (prog_name, args) = *)
    let
        val _ = print("Views and Abstraction\n\n")
        val d1 = StringDict.dict string
        val _ = StringDict.insert(d1, "bird", "bird_value")
    in

        (* https://smlfamily.github.io/Basis/os-process.html *)
        OS.Process.exit (OS.Process.success)
    end

end (* MainModule *)
