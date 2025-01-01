
(* padd(P, Q) produces the polynomial sum P+Q *)

fun padd(P, nil) = P
|   padd(nil, Q) = Q
|   padd((p:real)::ps, q::qs) = (p + q)::padd(ps, qs);


(* smult(P, q) multiplies polynomial P by scalar q *)

fun smult(nil, q) = nil
|   smult((p:real)::ps, q) = (p * q)::smult(ps, q);


(* pmult(P, Q) produces PQ *)

fun pmult(P, nil) = nil
|   pmult(P, q::qs) = padd(smult(P, q), 0.0::pmult(P, qs));


(* psub(P, Q) computes the difference of polynomials P-Q *)

fun psub(P, Q) = padd(P, smult(Q, ~1.0));


(* length(P) computes length (degree+1) of polynomial P *)

fun length(nil) = 0
|   length(p::ps) = 1 + length(ps);


(* bestSplit(n, m) computes an appropriate size for the
low-order "half" of polynomials of length n and m.
It is the smaller of n and m should one be less than
half the other.  If they are approximately the
same size, then it is half the larger. *)

fun bestSplit(n, m) =
    if 2*n <= m then n
    else if 2*m <= n then m
    else if n <= m then m div 2
    else (* n/2 < m < n *) n div 2


(* shift(P, n) computes P times x^n, for polynomial P(x) *)

fun shift(P, 0) = P
|   shift(P, n) = 0.0::shift(P, n-1)


(* carve(P, n) returns a pair of polynomials.  The first is
the low-order n terms of P and the second is what remains
of P, divided by x^n *)

fun carve(P, 0) = (nil, P)
(* we (mics) added the following 2 patterns to get rid
of the message "Warning: match nonexhaustive". *)
|   carve(nil, n) = carve(nil, n-1)
|   carve([p], n) = carve([p], n-1)
|   carve(p::ps, n) =
        let
            val (qs, rs) = carve(ps, n-1)
        in
            (p::qs, rs)
        end


(* komult(P, Q) computes the product of polynomials PQ using
the Karatsuba-Ofman method that only calls itself three
times rather than four on half-sized polynomials. *)

fun komult(P, nil) = nil
|   komult(nil, Q) = nil
|   komult(P, [q]) = smult(P, q)
|   komult([p], Q) = smult(Q, p)
|   komult(P, Q) =
        let
            val n = length(P);
            val m = length(Q);
            val s = bestSplit(n, m);
            val (T, U) = carve(P, s);
            val (V, W) = carve(Q, s);
            val TV = komult(T, V);
            val UW = komult(U, W);
            val TUVW = komult(padd(T, U), padd(V, W));
            val middle = psub(psub(TUVW, TV), UW);
        in
            padd(padd(TV, shift(middle, s)), shift(UW, 2*s))
        end

structure MainModule =
struct

fun listToString lst = List.foldr (
    fn (x, "") => (Real.toString x)
    |  (x, y)  => (Real.toString x) ^ "," ^ y) "" lst;

fun main args = (* main (prog_name, args) *)
    let
        val p = [1.0, 4.0]
        val q = [2.0, 5.0]
        val _ = print("p=" ^ listToString(p) ^ "\n")
        val _ = print("q=" ^ listToString(q) ^ "\n")
        val _ = print("komult=" ^ listToString(komult(p, q)) ^ "\n")
    in
        (* https://smlfamily.github.io/Basis/os-process.html *)
        OS.Process.exit (OS.Process.success)
    end

end (* MainModule *)
