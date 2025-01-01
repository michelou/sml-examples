# <span id="top">Code examples from *Ullman's Book*</span> <span style="font-size:90%;">[⬆](../README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;">
    <a href="https://smlfamily.github.io/"><img src="../docs/images/sml.png" width="120" alt="Standard ML"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <code>ullman-examples\</code> contains <a href="https://smlfamily.github.io/">Standard ML</a> code examples from Ullman's book <a href="http://infolab.stanford.edu/~ullman/emlp.html">"<i>Elements of ML Programming</i>"</a> (2<sup>nd</sup>&nbsp;Edition, 1997).<br/>
     It also includes several build scripts (<a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting">batch files</a>) for experimenting with <a href="https://smlfamily.github.io/" rel="external">Standard ML</a> on a Windows machine.
  </td>
  </tr>
</table>

## <span id="3_mergsort">`3_mergsort` Example</span>

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./3_mergesort/build.bat">build.bat</a>
|   <a href="./3_mergesort/build.cm">build.cm</a>
\---<b>src</b>
        <a href="./3_mergesort/src/main.sml">main.sml</a>
</pre>

We execute the *slightly modified* SML script file `target\main.sml` as follows :

<pre style="font-size:80%;">
<b>&gt; <a href="./3_mergeSort/build.bat">build</a> clean run</b>
Standard ML of New Jersey [Version 110.99.6.1; 32-bit; October 25, 2024]
[opening K:\ullman-examples\3_mergeSort\target\main.sml]
<b>val</b> merge = fn : int list * int list -> int list
val split = fn : 'a list -> 'a list * 'a list
val mergeSort = fn : int list -> int list
val listToString = fn : int list -> string
list=1,3,7,2,9,6
sorted=1,2,3,6,7,9
</pre>

  > **Note**: [`build.bat`](./hel3_mergeSort/build.bat) does simply appends a new line to the executed script in order to force the evaluation of the `main` function (together with the appropriate arguments).
  > <pre style="font-size:80%;">
  > <b>&gt; <a href="https://www.man7.org/linux/man-pages/man1/diff.1.html">diff</a> src\main.sml target\mail.sml</b>
  > 12a13,14
  > >
  > > val _ = MergeSort.main []
  > </pre>

We further specify `compile` in order to generate and execute the SML image `target\3_mergeSort-image.x86-win32` :

<pre style="font-size:80%;">
<b>&gt; <a href="">build</a> clean compile run</b>
Standard ML of New Jersey [Version 110.99.6.1; 32-bit; October 25, 2024]
list=1,3,7,2,9,6
sorted=1,2,3,6,7,9
</pre>

<!--=======================================================================-->

## <span id="3_komult">`3_komult` Example</span> [**&#x25B4;**](#top)

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./3_komult/build.bat">build.bat</a>
|   <a href="./3_komult/build.cm">build.cm</a>
\---<b>src</b>
        <a href="./3_komult/src/main.sml">main.sml</a>
</pre>

We execute the *slightly modified* SML script file `target\main.sml` as follows :

<pre style="font-size:80%;">
<b>&gt; <a href="./3_komult/build.bat">build</a> clean run</b>
Standard ML of New Jersey [Version 110.99.6.1; 32-bit; October 25, 2024]
[opening K:\ullman-examples\3_komult\target\main.sml]
val padd = fn : real list * real list -> real list
val smult = fn : real list * real -> real list
val pmult = fn : real list * real list -> real list
val psub = fn : real list * real list -> real list
val length = fn : 'a list -> int
val bestSplit = fn : int * int -> int
val shift = fn : real list * int -> real list
val carve = fn : 'a list * int -> 'a list * 'a list
val komult = fn : real list * real list -> real list
val list_string = fn : real list -> string
p=1,4
q=2,5
komult=2,13,20
</pre>

We further specify `compile` in order to generate and execute the SML image `target\3_komult-image.x86-win32` :

<pre style="font-size:80%;">
<b>&gt; <a href="./3_komult/build.bat">build</a> clean compile run</b>
Standard ML of New Jersey [Version 110.99.6.1; 32-bit; October 25, 2024]
p=1,4
q=2,5
komult=2,13,20
</pre>

<!--=======================================================================-->

## <span id="4_comb">`4_comb` Example</span>

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./4_comb/build.bat">build.bat</a>
|   <a href="./4_comb/build.cm">build.cm</a>
\---<b>src</b>
        <a href="./4_comb/src/main.sml">main.sml</a>
</pre>

We execute the *slightly modified* SML script file `target\main.sml` as follows :

<pre style="font-size:80%;">
<b>&gt; <a href="./4_comb/build.bat">build</a> clean run</b>
Standard ML of New Jersey [Version 110.99.6.1; 32-bit; October 25, 2024]
[opening K:\ullman-examples\4_comb\target\main.sml]
opening TextIO
  type vector = string
  [...]
  structure StreamIO :
    sig
      type vector = string
      [...]
      val outputSubstr : outstream * substring -> unit
    end
  [...]
XXXXX
XXXX
XXX
XX
XX
X
X
XXX
XX
X
X
XX
XXXX
XXX
XX
X
X
XX
XXX
comb(5, 2)=10
</pre>

<!--=======================================================================-->

## <span id="4_sumInts">`4_sumInts` Example</span> [**&#x25B4;**](#top)

This example demonstrates the usage of the <a href="https://smlfamily.github.io/Basis/text-io.html"><code>TextIO</code></a> standard module; it takes as input the text file [`sumInts.txt`](./4_sumInts/sumInts.txt) and prints out the sum.

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./4_sumInts/build.bat">build.bat</a>
|   <a href="./4_sumInts/build.cm">build.cm</a>
|   <a href="./4_sumInts/sumInts.txt">sumInts.txt</a>
\---<b>src</b>
        <a href="./4_sumInts/src/main.sml">main.sml</a>
</pre>

We execute the *slightly modified* SML script file `target\main.sml` as follows :

<pre style="font-size:80%;">
<b>&gt; <a href="./4_sumInts/build.bat">build</a> clean run</b>
Standard ML of New Jersey [Version 110.99.6.1; 32-bit; October 25, 2024]
[opening K:\ullman-examples\4_sumInts\target\main.sml]
opening TextIO
  type vector = string
  [...]
  structure StreamIO :
    sig
      type vector = string
      [...]
      val outputSubstr : outstream * substring -> unit
    end
  [...]
val END = ~1 : int
val digit = fn : char -> bool
val startInt = fn : instream -> int
val startInt1 = fn : instream * elem option -> int
val finishInt = fn : int * instream -> int
val finishInt1 = fn : int * instream * elem option -> int
val getInt = fn : instream -> int
val sumInts1 = fn : instream -> int
val sumInts = fn : string -> int
sumInts=61
</pre>

<!--=======================================================================-->

## <span id="5_parseExpression">`5_parseExpression` Example</span> [**&#x25B4;**](#top)

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./5_parseExpression/00download.txt">00download.txt</a>
|   <a href="./5_parseExpression/build.bat">build.bat</a>
|   <a href="./5_parseExpression/build.cm">build.cm</a>
|   <a href="./5_parseExpression/parseExpression.txt">parseExpression.txt</a>
\---<b>src</b>
        <a href="./5_parseExpression/src/main.sml">main.sml</a>
</pre>

We execute the *slightly modified* SML script file `target\main.sml` as follows :

<pre style="font-size:80%;">
<b>&gt; <a href="./5_parseExpression/build.bat">build</a> clean run</b>
Standard ML of New Jersey [Version 110.99.6.1; 32-bit; October 25, 2024]
[opening K:\ullman-examples\5_parseExpression\target\main.sml]
opening TextIO
  type vector = string
  [...]
  structure StreamIO :
    sig
      type vector = string
      [...]
      val outputSubstr : outstream * substring -> unit
    end
  [...]
val digit = fn : char -> bool
val blank = fn : char -> bool
val lookahead2 = fn : instream -> char option
val integer = fn : instream * int -> int
val atom = fn : instream -> int
val term = fn : instream -> int
val termTail = fn : instream * int -> int
val expression = fn : instream -> int
val expTail = fn : instream * int -> int
val infile = - : instream
expression=9
</pre>

We further specify `compile` in order to generate and execute the SML image `target\5_parseExpression-image.x86-win32` :

<pre style="font-size:80%;">
<b>&gt; <a href="./5_parseExpression/build.bat">build</a> clean compile run</b>
Standard ML of New Jersey [Version 110.99.6.1; 32-bit; October 25, 2024]
expression=9
</pre>

<!--=======================================================================-->

## <span id="6_sumElList">`6_sumElList` Example</span> [**&#x25B4;**](#top)

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./6_sumElList/build.bat">build.bat</a>
|   <a href="./6_sumElList/build.cm">build.cm</a>
\---<b>src</b>
        <a href="./6_sumElList/src/main.sml">main.sml</a>
</pre>

We execute the *slightly modified* SML script file `target\main.sml` as follows :

<pre style="font-size:80%;">
<b>&gt; <a href="./6_sumElList/build.bat">build</a> clean run</b>
Standard ML of New Jersey [Version 110.99.6.1; 32-bit; October 25, 2024]
[opening K:\ullman-examples\6_sumElList\target\main.sml]
datatype ('a,'b) element = P of 'a * 'b | S of 'a
val sumElList = fn : ('a,int) element list -> int
sumElList=12
</pre>

We further specify `compile` in order to generate and execute the SML image `target\6_sumElList-image.x86-win32` :

<pre style="font-size:80%;">
<b>&gt; <a href="./6_sumElList/build.bat">build</a> clean compile run</b>
Standard ML of New Jersey [Version 110.99.6.1; 32-bit; October 25, 2024]
lst=P(1,4),S(5),P(2,5),P(9,3),
sumElList=12
</pre>

<!--=======================================================================-->

## <span id="8_BTree">`8_BTree` Example</span> [**&#x25B4;**](#top)

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./8_BTree/build.bat">build.bat</a>
|   <a href="./8_BTree/build.cm">build.cm</a>
\---<b>src</b>
        <a href="./8_BTree/src/main.sml">main.sml</a>
</pre>

We execute the *slightly modified* SML script file `target\main.sml` as follows :

<pre style="font-size:80%;">
<b>&gt; <a href="./8_BTree/build.bat">build</a> -verbose clean run</b>
Execute SML script "target\main.sml" (args: )
Standard ML of New Jersey [Version 110.99.6.1; 32-bit; October 25, 2024]
[opening K:\ullman-examples\8_BTree\target\main.sml]
[autoloading]
[library $SMLNJ-BASIS/basis.cm is stable]
[library $SMLNJ-BASIS/(basis.cm):basis-common.cm is stable]
[autoloading done]
tree=a,t,x
</pre>

We further specify `compile` in order to generate and execute the SML image `target\8_BTree-image.x86-win32` :

<pre style="font-size:80%;">
<b>&gt; <a href="./8_BTree/build.bat">build</a> -verbose clean compile run</b>
Compile SML source file "main"
Standard ML of New Jersey [Version 110.99.6.1; 32-bit; October 25, 2024]
[scanning ../build.cm]
[parsing ../(build.cm):src/main.sml]
[creating directory ..\src\.cm\SKEL]
[library $SMLNJ-BASIS/basis.cm is stable]
[library $SMLNJ-BASIS/(basis.cm):basis-common.cm is stable]
[compiling ../(build.cm):src/main.sml]
[creating directory ..\src\.cm\GUID]
[creating directory ..\src\.cm\x86-win32]
[code: 6275, data: 171, env: 601 bytes]
[scanning XYZ_XXX_cmfile.cm]
[scanning (XYZ_XXX_cmfile.cm):../build.cm]
[parsing (XYZ_XXX_cmfile.cm):XYZ_XXX_smlfile.sml]
[creating directory .cm\SKEL]
[compiling (XYZ_XXX_cmfile.cm):XYZ_XXX_smlfile.sml]
[creating directory .cm\GUID]
[creating directory .cm\x86-win32]
[code: 529, data: 77, env: 39 bytes]
Execute SML image "target\8_BTree-image.x86-win32" (args: )
tree=a,t,x
</pre>

<!--=======================================================================-->

## <span id="8_Structs">`8_Structs` Example</span> [**&#x25B4;**](#top)

This example has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./8_Structs/build.bat">build.bat</a>
|   <a href="./8_Structs/build.cm">build.cm</a>
\---<b>src</b>
        <a href="./8_Structs/src/main.sml">main.sml</a>
</pre>

We execute the *slightly modified* SML script file `target\main.sml` as follows :

<pre style="font-size:80%;">
<b>&gt; <a href="./8_Structs/build.bat">build</a> -verbose clean run</b>
Execute SML script "target\main.sml" (args: )
Standard ML of New Jersey [Version 110.99.6.1; 32-bit; October 25, 2024]
[opening K:\ullman-examples\8_Structs\target\main.sml]
signature SIG1 =
  sig
  val i : int
  type t
  val x : t
  val y : t
  val f : t * t -> bool
  val T_toString : t -> string
end
[autoloading]
[library $SMLNJ-BASIS/basis.cm is stable]
[library $SMLNJ-BASIS/(basis.cm):basis-common.cm is stable]
[autoloading done]
K:\ullman-examples\8_Structs\target\main.sml:17.22 Warning: calling polyEqual
structure Struct1 : sig
  val i : int
  type t = int
  val x : int
  val y : int
  val f : ''a * ''a -> bool
  val T_toString : int -> string
end
structure Struct2 : SIG1
structure Struct3 : SIG1
[autoloading]
[autoloading done]
i=3, x=4, y=5
b1=false
b2=false
b3=true

i=3, x=4, y=5
b1=false
</pre>

We further specify `compile` in order to generate and execute the SML image `target\8_Structs-image.x86-win32` :

<pre style="font-size:80%;">
<b>&gt; <a href="./8_Structs/build.bat">build</a> -verbose clean compile run</b>
Compile SML source file "main"
Standard ML of New Jersey [Version 110.99.6.1; 32-bit; October 25, 2024]
[scanning ../build.cm]
[parsing ../(build.cm):src/main.sml]
[creating directory ..\src\.cm\SKEL]
[library $SMLNJ-BASIS/basis.cm is stable]
[library $SMLNJ-BASIS/(basis.cm):basis-common.cm is stable]
[compiling ../(build.cm):src/main.sml]
[...]
Execute SML image "target\8_Structs-image.x86-win32" (args: )
i=3, x=4, y=5
b1=false
b2=false
b3=true

i=3, x=4, y=5
b1=false
</pre>

<!--
## <span id="footnotes">Footnotes</span>

<a name="footnote_01">[1]</a> ***Available targets*** [↩](#anchor_01)

<p style="margin:0 0 1em 20px;">
</p>
-->

***

*[mics](https://lampwww.epfl.ch/~michelou/)/January 2025* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>
