# <span id="top">Standard ML Examples</span> <span style="font-size:90%;">[⬆](../README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;"><a href="https://smlfamily.github.io/" rel="external"><img src="../docs/images/sml.png"" width="120" alt="SML project"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">This repository gathers <a href="https://smlfamily.github.io/" rel="external">Standard ML</a> code examples from various websites.<br/>
  It also includes several build scripts (<a href="https://www.gnu.org/software/bash/manual/bash.html" rel="external">Bash scripts</a>, <a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting">batch files</a>, <a href="https://makefiletutorial.com/" rel="external">Make scripts</a>) for experimenting with <a href="https://smlfamily.github.io/" rel="external">Standard ML</a> on a Windows machine.
  </td>
  </tr>
</table>

Standard ML code can be executed either as a script or as a module.

| SML      | SML/NJ&nbsp;commands | Moscow&nbsp;ML&nbsp;commands |
|:--------:|:---------------------|:-----------------------------|
| script   | [`sml`][sml_cmd] &lt;script-file&gt; | [`mosml`][mosml_cmd] &lt;script-file&gt; |
| module <sup><b>a)</b></sup><br/>&nbsp;<br/>&nbsp; | [`ml-build`][ml-build_cmd] &lt;cm-file&gt;<sup><b>b)</b></sup><br/>&emsp;&emsp;&emsp;&emsp;&emsp;&lt;module-main&gt;<br/>&emsp;&emsp;&emsp;&emsp;&emsp;&lt;image-name&gt; | [`mosmlc`][mosmlc_cmd] &lt;source-file&gt;<br/>&emsp;<br/> &emsp; |
<div style="margin:0 0 20px 10px;font-size:80%;">
<sup><b>a)</b></sup> An <a href="https://smlhelp.github.io/book/docs/concepts/modules/">SML module</a> consists of a signature and its implementation.</br>
<sup><b>b)</b></sup> <a href="https://www.smlnj.org/doc/CM/">Compilation manager</a> file (similar in the spirit to a Makefile).
</div>

Futhermore there are also two ways to execute each of the following code examples as an SML script :
- either ***interactively*** by running the REPL and writing `use "src/hello.sml"` (below the '`-`' character is the [SML prompt][sml_prompt]) :
  <pre style="font-size:80%;">
  <b>&gt; %SMLNJ_HOME%\bin\<a href="https://manpages.ubuntu.com/manpages/noble/man1/sml.1.html">sml.bat</a></b>
  Standard ML of New Jersey [Version 110.99.7.1; 32-bit; January 17, 2025]
  - use "src/hello.sml";
  [opening src/hello.sml]
  [autoloading]
  [library $SMLNJ-BASIS/basis.cm is stable]
  [library $SMLNJ-BASIS/(basis.cm):basis-common.cm is stable]
  [autoloading done]
  structure Hello : sig
    val hello : unit -> unit
    val main : 'a -> 'b
  end
  val it = () : unit
  - Hello.main();
  stdIn:2.1-2.13 Warning: type vars not generalized because of
    value restriction are instantiated to dummy types (X1,X2,...)
  Hello World
  </pre>
- or as a ***slightly modified*** SML script file :
  - SML/NJ (option `-smlnj`, *default*)
    <pre style="font-size:80%;">
    <b>&gt; <a href="./hello/build.bat">build</a> -verbose clean run</b>
    Execute SML script "target\hello-sml"
    Standard ML of New Jersey [Version 110.99.7.1; 32-bit; January 17, 2025]
    [opening K:\examples\hello\target\hello.sml]
    [autoloading]
    [library $SMLNJ-BASIS/basis.cm is stable]
    [library $SMLNJ-BASIS/(basis.cm):basis-common.cm is stable]
    [autoloading done]
    Hello World
    </pre>
  - Moscow ML (option `-mosml`)
    <pre style="font-size:80%;">
    <b>&gt; <a href="./hello/build.bat">build</a> -verbose -mosml clean run</b>
    Execute SML script "target\hello.sml" 1 a
    Moscow ML version 2.01 (January 2004)
    Enter `quit();' to quit.
    [opening file "K:\examples\hello\target\hello.sml"]
    > val it = () : unit
    > val it = () : unit
    > val it = () : unit
    Hello World
    </pre>

  > **Note**: [`build.bat`](./hello/build.bat) does simply appends a new line to the executed script in order to force the evaluation of the `main` function (together with the appropriate arguments).
  > <pre style="font-size:80%;">
  > <b>&gt; <a href="https://www.man7.org/linux/man-pages/man1/diff.1.html">diff</a> src\hello.sml target\hello.sml</b>
  > 12a13,14
  > >
  > > val _ = Hello.main ["1","a"]
  > </pre>

<!--===============================================-->

### <span id="args">`args` Example</span>

This project has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /a /f .| <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
|   <a href="./args/build.bat">build.bat</a>
|   <a href="./args/build.cm">build.cm</a>
\---<b>src</b>
        <a href="./args/src/args.sml">args.sml</a>
</pre>

We execute the *slightly modified* SML script file `target\args.sml` as follows :

<pre style="font-size:80%;">
<b>&gt; <a href="./args/build.bat">build</a> -verbose clean run</b>
Execute SML script "args"
Standard ML of New Jersey [Version 110.99.7.1; 32-bit; January 17, 2025]
[opening K:\examples\args\target\args.sml]
[autoloading]
[library $SMLNJ-BASIS/basis.cm is stable]
[library $SMLNJ-BASIS/(basis.cm):basis-common.cm is stable]
[autoloading done]
Command: C:\opt\smlnj\bin\.run\run.x86-win32.exe
Arguments: 1
That's right! 1
</pre>

We add `compile` to the above command in order to generate and execute the SML image `args-image.x86-win32`:

<pre style="font-size:80%;">
<b>&gt; <a href="./args/build.bat">build</a> -verbose clean compile run</b>
Compile SML source file "args"
Standard ML of New Jersey [Version 110.99.7.1; 32-bit; January 17, 2025]
[scanning ../build.cm]
[parsing ../(build.cm):src/args.sml]
[creating directory ..\src\.cm\SKEL]
[library $SMLNJ-BASIS/basis.cm is stable]
[library $SMLNJ-BASIS/(basis.cm):basis-common.cm is stable]
[compiling ../(build.cm):src/args.sml]
[...]
[code: 334, data: 74, env: 39 bytes]
Execute SML image "target\args-image.x86-win32"
That's right! 1
</pre>

> <b>Note</b>: The output directory contains the generated SML image file with the suffix <code>x86-win32</code>, a combinaison of <code>x86</code> for a particular architecture and <code>win32</code> for the operating system.
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f target | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
> |   args-image.x86-win32  <i>(240 KB)</i>
> \---<b>.cm</b>
>     +---GUID
>     +---SKEL
>     \---x86-win32
> </pre>

<!--=======================================================================-->

### <span id="hello">`hello` Example</span> [**&#x25B4;**](#top)

This project has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /a /f .| <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
|   <a href="./hello/build.bat">build.bat</a>
|   <a href="./hello/build.cm">build.cm</a>
\---<b>src</b>
        <a href="./hello/src/hello.sml">hello.sml</a>
</pre>

<!--
https://manpages.ubuntu.com/manpages/noble/man1/ml-build.1.html
-->

We execute the *slightly modified* SML script file [`tatget\hello.sml`] :

<pre style="font-size:80%;">
<b>&gt; <a href="./hello/build.bat">build</a> -verbose clean run</b>
Execute SML script "hello"
Standard ML of New Jersey [Version 110.99.7.1; 32-bit; January 17, 2025]
[opening K:\examples\hello\target\hello.sml]
[autoloading]
[library $SMLNJ-BASIS/basis.cm is stable]
[library $SMLNJ-BASIS/(basis.cm):basis-common.cm is stable]
[autoloading done]
Hello World
</pre>

We add `compile` to the above command in order to generate and execute the SML image `hello-image.x86-win32` :

<pre style="font-size:80%;">
<b>&gt; <a href="./hello/build.bat">build</a> -verbose clean compile run</b>
Compile SML source file "hello"
Standard ML of New Jersey [Version 110.99.7.1; 32-bit; January 17, 2025]
[scanning ../build.cm]
[parsing ../(build.cm):src/hello.sml]
[creating directory ..\src\.cm\SKEL]
[library $SMLNJ-BASIS/basis.cm is stable]
[library $SMLNJ-BASIS/(basis.cm):basis-common.cm is stable]
[compiling ../(build.cm):src/hello.sml]
[...]
[code: 335, data: 75, env: 39 bytes]
Execute SML image "target\hello-image.x86-win32"
Hello World
</pre>

<!--=======================================================================-->

### <span id="norm">`norm` Example</span> [**&#x25B4;**](#top)

This project has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f . | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./norm/build.bat">build.bat</a>
|   <a href="./norm/build.cm">build.cm</a>
\---<b>src</b>
        <a href="./norm/src/helper.sml">helper.sml</a>
        <a href="./norm/src/main.sml">main.sml</a>
</pre>

We execute the SML script file `target\main.sml` as follows :

<pre style="font-size:80%;">
<b>&gt; <a href="./norm/build.bat">build</a> -verbose clean run</b>
Execute SML script "main"
Standard ML of New Jersey [Version 110.99.7.1; 32-bit; January 17, 2025]
[opening K:\examples\norm\target\main.sml]
[opening src/script/helper.sml]
[autoloading]
[library $SMLNJ-BASIS/basis.cm is stable]
[library $SMLNJ-BASIS/(basis.cm):basis-common.cm is stable]
[autoloading done]
val intSquare = fn : int -> int
val square = fn : real -> real
val cube = fn : real -> real
val pi = 3.1415926535 : real
val degreeToRadian = fn : real -> real
val it = () : unit
[autoloading]
[autoloading done]
31.0062766776
1.57079632675
3.60555127546
</pre>

<!--=======================================================================-->

### <span id="qort">`qsort` Example</span>

This code example is taken from the Williams College course ["CSCI 334 &ndash; Principles of Programming Languages"](https://www.cs.williams.edu/~freund/cs334-exemplar/lectures.html); it has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /a /f .| <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
|   <a href="./qsort/00download.txt">00download.txt</a>
|   <a href="./qsort/build.bat">build.bat</a>
|   <a href="./qsort/build.cm">build.cm</a>
\---<b>src</b>
        <a href="./qsort/src/qsort.sml">qsort.sml</a>
</pre>

We execute the *slightly modified* SML script file `target\qsort.sml` as follows :

- SML/NJ (option `-smlnj`, *default*)

  <pre style="font-size:80%;">
  <b>&gt; <a href="./qsort/build.bat">build</a> -verbose clean run</b>
  Execute SML script "target\qsort.sml"
  Standard ML of New Jersey [Version 110.99.7.1; 32-bit; January 17, 2025]
  [opening K:\examples\qsort\target\qsort.sml]
  [autoloading]
  [library $smlnj/compiler/current.cm is stable]
  [...]
  [autoloading done]
  val it = () : unit
  val it = () : unit
  [autoloading]
  [autoloading done]
  list=6,23,6,3,78,23,12,6,7,34,7,1,23,7,23,6,3,6
  qsort=1,3,3,6,6,6,6,6,7,7,7,12,23,23,23,23,34,78
  </pre>

- Moscow ML (option `-mosml`)

  <pre style="font-size:80%;">
  <b>&gt; <a href="./qsort/build.bat">build</a> -verbose -mosml clean run</b>
  Execute SML script "target\qsort.sml"
  Moscow ML version 2.01 (January 2004)
  Enter `quit();' to quit.
  [opening file "K:\examples\qsort\target\qsort.sml"]
  > val it = () : unit
  > val it = () : unit
  > val it = () : unit
  > val it = () : unit
  list=6,23,6,3,78,23,12,6,7,34,7,1,23,7,23,6,3,6
  qsort=1,3,3,6,6,6,6,6,7,7,7,12,23,23,23,23,34,78
  </pre>

<!--=======================================================================-->

### <span id="polysort">`polysort` Example</span>

This code example is taken from the Williams College course ["CSCI 334 &ndash; Principles of Programming Languages"](https://www.cs.williams.edu/~freund/cs334-exemplar/lectures.html); it has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /a /f .| <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
|   <a href="./polysort/00download.txt">00download.txt</a>
|   <a href="./polysort/build.bat">build.bat</a>
|   <a href="./polysort/build.cm">build.cm</a>
\---<b>src</b>
        <a href="./polysort/src/polysort.sml">polysort.sml</a>
</pre>

We execute the *slightly modified* SML script file `target\polysort.sml` as follows :

- SML/NJ (option `-smlnj`, *default*)

  <pre style="font-size:80%;">
  <b>&gt; <a href="./polysort/build.bat">build</a> -verbose clean run</b>
  Execute SML script "target\polysort.sml"
  Standard ML of New Jersey [Version 110.99.7.1; 32-bit; January 17, 2025]
  [opening K:\examples\polysort\target\polysort.sml]
  [autoloading]
  [library $smlnj/compiler/current.cm is stable]
  [...]
  [autoloading done]
  val it = () : unit
  val it = () : unit
  val partition = fn : ('a * 'b -> bool) * 'b * 'a list -> 'a list * 'a list
  val qsort = fn : ('a * 'a -> bool) * 'a list -> 'a list
  [autoloading]
  [autoloading done]
  list1=6,23,6,3,78,23,12,6,7,34,7
  qsort1=3,6,6,6,7,7,12,23,23,34,78

  list2=~3,5,2,~1
  qsort2=~1,2,~3,5

  list3=moo,purple,cow,wombat
  qsort3=cow,moo,purple,wombat
  </pre>

- Moscow ML (option `-mosml`)

  <pre style="font-size:80%;">
  <b>&gt; <a href="./polysort/build.bat">build</a> -verbose -mosml clean run</b>
  Execute SML script "target\polysort.sml"
  Moscow ML version 2.01 (January 2004)
  Enter `quit();' to quit.
  [opening file "K:\examples\polysort\target\polysort.sml"]
  > val it = () : unit
  > val it = () : unit
  > val it = () : unit
  > val it = () : unit
  > val ('a, 'b) partition = fn :
    ('a * 'b -> bool) * 'b * 'a list -> 'a list * 'a list
  > val 'a qsort = fn : ('a * 'a -> bool) * 'a list -> 'a list
  list1=6,23,6,3,78,23,12,6,7,34,7
  qsort1=3,6,6,6,7,7,12,23,23,34,78

  list2=~3,5,2,~1
  qsort2=~1,2,~3,5

  list3=moo,purple,cow,wombat
  qsort3=cow,moo,purple,wombat
  </pre>

<!--=======================================================================-->

### <span id="sumpairs">`sumpairs` Example</span>

This project has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree">tree</a> /a /f .| <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr">findstr</a> /v /b [A-Z]</b>
|   <a href="./sumpairs/build.bat">build.bat</a>
|   <a href="./sumpairs/build.cm">build.cm</a>
\---<b>src</b>
        <a href="./sumpairs/src/sumpairs.sml">sumpairs.sml</a>
</pre>

We execute the *slightly modified* SML script file `target\sumpairs.sml` as follows :

- SML/NJ (option `-smlnj`, *default*)

  <pre style="font-size:80%;">
  <b>&gt; <a href="./sumpairs/build.bat">build</a> -verbose clean run</b>
  Execute SML script "sumpairs"
  Standard ML of New Jersey [Version 110.99.7.1; 32-bit; January 17, 2025]
  [opening K:\examples\sumpairs\target\sumpairs.sml]
  [autoloading]
  [library $SMLNJ-BASIS/basis.cm is stable]
  [library $SMLNJ-BASIS/(basis.cm):basis-common.cm is stable]
  [autoloading done]
  val sumpairs = fn : int list -> int list
  val listToString = fn : int list -> string
  list=1,2,3,4
  sumpairs=3,7
  </pre>

- Moscow ML (option `-mosml`)

  <pre style="font-size:80%;">
  <b>&gt; <a href="./sumpairs/build.bat">build</a> -verbose -mosml clean run</b>
  Execute SML script "target\sumpairs.sml"
  Moscow ML version 2.01 (January 2004)
  Enter `quit();' to quit.
  [opening file "K:\examples\sumpairs\target\sumpairs.sml"]
  > val it = () : unit
  > val it = () : unit
  > val it = () : unit
  > val it = () : unit
  list=1,2,3,4
  sumpairs=3,7
  </pre>

We add `compile` to the above command in order to generate and execute the SML image `target\sumpairs-image.x86-win32` :

<pre style="font-size:80%;">
<b>&gt; <a href="./sumpairs/build.bat">build</a> -verbose clean compile run</b>
Compile SML source file "sumpairs"
Standard ML of New Jersey [Version 110.99.7.1; 32-bit; January 17, 2025]
[scanning ../build.cm]
[parsing ../(build.cm):src/sumpairs.sml]
[creating directory ..\src\.cm\SKEL]
[library $SMLNJ-BASIS/basis.cm is stable]
[library $SMLNJ-BASIS/(basis.cm):basis-common.cm is stable]
[compiling ../(build.cm):src/sumpairs.sml]
[...]
[code: 338, data: 78, env: 39 bytes]
Execute SML image "target\sumpairs-image.x86-win32"
list=1,2,3,4
sumpairs=3,7
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/February 2025* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[ml-build_cmd]: https://manpages.ubuntu.com/manpages/noble/en/man1/ml-build.1.html
[mosml_cmd]: https://github.com/kfl/mosml/blob/master/man/mosml.1
[mosmlc_cmd]: https://github.com/kfl/mosml/blob/master/man/mosmlc.1
[sml_cmd]: https://manpages.ubuntu.com/manpages/noble/man1/sml.1.html
[sml_prompt]: https://pages.cs.wisc.edu/~fischer/cs538.s08/sml/sml.html
