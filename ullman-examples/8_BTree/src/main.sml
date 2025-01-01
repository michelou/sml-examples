structure MainModule =
struct

datatype 'label btree =
 Empty |
 Node of 'label * 'label btree * 'label btree;

fun lower(nil) = nil
|   lower(c::cs) = (Char.toLower c)::lower(cs);

fun lt(x, y) =
    implode(lower(explode(x))) <
        implode(lower(explode(y)));

fun lookup(x, Empty) = false
|   lookup(x, Node(y, left, right)) =
        if lt(x, y) then lookup(x, left)
        else if lt(y, x) then lookup(x, right)
        else (* x=y *) true;

fun insert(x, Empty) = Node(x, Empty, Empty)
|   insert(x, T as Node(y, left, right)) =
        if lt(x, y) then Node(y, insert(x, left), right)
        else if lt(y, x) then Node(y, left, insert(x, right))
        else (* x=y *) T; (* do nothing; x was
                          already there *)

exception EmptyTree;

(* deletemin(T) returns a pair consisting of the least
element y in tree T and the tree that results if we
delete y from T.  It is an error if T is empty *)

fun deletemin(Empty) = raise EmptyTree
|   deletemin(Node(y, Empty, right)) = (y, right) (* The
         critical case.  If the left subtree is empty,
         then the element at current node is min. *)
|   deletemin(Node(w, left, right)) =
        let
            val (y, L) = deletemin(left)
        in
            (y, Node(w, L, right))
        end

fun delete(x, Empty) = Empty
|   delete(x, Node(y, left, right)) =
        if lt(x, y) then Node(y, delete(x, left), right)
        else if lt(y, x) then Node(y, left, delete(x, right))
        else (* x=y *)
            case (left, right) of
                (Empty, r) => r |
                (l, Empty) => l |
                (l, r) =>
                    let
                        val (z, r1) = deletemin(r)
                    in
                        Node(z, l, r1)
                    end;

fun treeToString(Empty) = ""
|   treeToString(Node(x, Empty, right)) = x ^ treeToString(right)
|   treeToString(Node(x, left, right)) = treeToString(left) ^ "," ^ x ^ "," ^ treeToString(right)

fun main args = (* main (prog_name, args) *)
    let
        val t = insert("a", insert("x", Node("t", Empty, Empty)))
        val _ = print("tree=" ^ treeToString(t) ^ "\n")
    in
        (* https://smlfamily.github.io/Basis/os-process.html *)
        OS.Process.exit (OS.Process.success)
    end

end (* MainModule *)
