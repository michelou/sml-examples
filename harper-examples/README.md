# <span id="top">Code Examples from *Harpers' Book*</span> <span style="font-size:90%;">[⬆](../README.md#top)</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:120px;">
    <a href="https://smlfamily.github.io/"><img src="../docs/images/sml.png" width="120" alt="Standard ML"/></a></td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    Directory <code>harper-examples\</code> contains <a href="https://smlfamily.github.io/">Standard ML</a> code examples from Harper's book <a href="https://www.cs.cmu.edu/~rwh/isml/">"<i>Programming in Standard ML</i>"</a> (September 2011).<br/>
     It also includes several build scripts (<a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting">batch files</a>, <a href="https://makefiletutorial.com/" rel="external">Make scripts</a>) for experimenting with <a href="https://smlfamily.github.io/" rel="external">Standard ML</a> on a Windows machine.
  </td>
  </tr>
</table>

### <span id="excs">`excs` Example</span>

This project has the following directory structure :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/tree" rel="external">tree</a> /a /f .| <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> /v /b [A-Z]</b>
|   <a href="./excs/build.bat">build.bat</a>
|   <a href="./excs/build.cm">build.cm</a>
\---<b>src</b>
        <a href="./excs/src/excs.sml">excs.sml</a>
</pre>

<pre style="font-size:80%;">
<b>&gt; <a href="./excs/build.bat">build</a> -verbose clean run</b>
Delete directory "target"
Execute SML script "target\excs.sml" 1 a
Standard ML of New Jersey [Version 110.99.6.1; 32-bit; October 25, 2024]
[opening K:\harper-examples\excs\target\excs.sml]
[autoloading]
[library $SMLNJ-BASIS/basis.cm is stable]
[library $SMLNJ-BASIS/(basis.cm):basis-common.cm is stable]
[autoloading done]
Exceptions
&nbsp;
Please enter an integer value: -1
Out of range.
Please enter an integer value: 2
2
Please enter an integer value: -1
Out of range.
Please enter an integer value: 2
2
Please enter an integer value: 33333
Overflow.
Please enter an integer value:
Done.
</pre>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/February 2025* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->
