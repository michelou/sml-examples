structure Helper =
struct

(* This file contains helper functions *)
fun intSquare x = x * x
fun square x = Real.* (x, x)
fun cube x : real = x * x * x

val pi = 3.1415926535
fun degreeToRadian x = x * pi / 180.0

end
