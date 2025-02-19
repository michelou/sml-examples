# <span id="top">Playing with Standard ML on Windows</span>

<table style="font-family:Helvetica,Arial;line-height:1.6;">
  <tr>
  <td style="border:0;padding:0 10px 0 0;min-width:100px;">
    <a href="https://smlfamily.github.io/" rel="external"><img style="border:0;" src="./docs/images/sml.png" width="100" alt="SML project"/></a>
  </td>
  <td style="border:0;padding:0;vertical-align:text-top;">
    This repository gathers <a href="https://smlfamily.github.io/" rel="external">Standard ML</a> examples coming from various websites and books.<br/>
    It also includes several build scripts (<a href="https://www.gnu.org/software/bash/manual/bash.html" rel="external">Bash scripts</a>, <a href="https://en.wikibooks.org/wiki/Windows_Batch_Scripting" rel="external">batch files</a>, <a href="https://makefiletutorial.com/" rel="external">Make scripts</a>) for experimenting with <a href="https://smlfamily.github.io/" rel="external">Standard ML</a> on a Windows machine.
  </td>
  </tr>
</table>

[Ada][ada_examples], [Akka][akka_examples], [C++][cpp_examples], [COBOL][cobol_examples], [Dafny][dafny_examples], [Dart][dart_examples], [Deno][deno_examples], [Docker][docker_examples], [Erlang][erlang_examples], [Flix][flix_examples], [Go][golang_examples], [GraalVM][graalvm_examples], [Kafka][kafka_examples], [Kotlin][kotlin_examples], [LLVM][llvm_examples], [Modula-2][m2_examples], [Node.js][nodejs_examples], [Rust][rust_examples], [Scala 3][scala3_examples], [Spark][spark_examples], [Spring][spring_examples], [TruffleSqueak][trufflesqueak_examples], [WiX Toolset][wix_examples] and [Zig][zig_examples] are other topics we are continuously monitoring.

## <span id="proj_deps">Project dependencies</span>

This project depends on the following external software for the **Microsoft Windows** platform:

- [Git 2.48][git_downloads] ([*release notes*][git_relnotes])
- [Moscow ML 2.0][mosml_downloads]
- [SML/NJ 110][smlnj_downloads] ([*release notes*][smlnj_relnotes])

Optionally one may also install the following software:

- [MLton 2024][mlton_downloads] ([*release notes*][mlton_relnotes])
- [SML.NET 1.2][smlnet_downloads]
- [Visual Studio Code 1.97][vscode_downloads] ([*release notes*][vscode_relnotes])

For instance our development environment looks as follows (*February 2025*) <sup id="anchor_01">[1](#footnote_01)</sup>:

<pre style="font-size:80%;">
C:\opt\ConEmu\                   <i>( 26 MB)</i>
C:\opt\Git\                      <i>(389 MB)</i>
C:\opt\mlton\                    <i>( 46 MB)</i>
C:\opt\mosml\                    <i>(  5 MB)</i>
C:\opt\smlnet\                   <i>(  7 MB)</i>
C:\opt\SMLNJ\<sup id="anchor_02"><a href="#footnote_02">2</a></sup>                   <i>( 36 MB)</i>
C:\opt\VSCode\                   <i>(370 MB)</i>
</pre>

> **&#9755;** ***Installation policy***<br/>
> When possible we install software from a [Zip archive][zip_archive] rather than via a Windows installer. In our case we defined **`C:\opt\`** as the installation directory for optional software tools (*in reference to* the [`/opt/`][linux_opt] directory on Unix).

## <span id="structure">Directory structure</span> [**&#x25B4;**](#top)

This project is organized as follows:

<pre style="font-size:80%;">
docs\
examples\{<a href="examples/README.md">README.md</a>, <a href="examples/hello/">hello</a>, ..}
harper-examples\{<a href="harper-examples/README.md">README.md</a>, <a href="harper-examples/excs/">excs</a>, ..}
ullman-examples\{<a href="ullman-examples/README.md">README.md</a>, <a href="ullman-examples/3_komult/">komult</a>, <a href="ullman-examples/3_mergeSort/">mergeSort</a>, ..}
README.md
<a href="RESOURCES.md">RESOURCES.md</a>
<a href="setenv.bat">setenv.bat</a>
</pre>

where

- directory [**`docs\`**](docs/) contains [Standard ML][sml] related papers/articles.
- directory [**`examples\`**](examples/) contains [Standard ML][sml] examples grabbed from various websites (see file [**`examples\README.md`**](examples/README.md)).
- directory [**`harper-examples\`**](harper-examples/) contains [Standard ML][sml] examples from Harper's book (see file [**`harper-examples\README.md`**](harper-examples/README.md)).
- directory [**`ullman-examples\`**](ullman-examples/) contains [Standard ML][sml] examples from Ullman's book (see file [**`ullman-examples\README.md`**](ullman-examples/README.md)).
- file **`README.md`** is the [Markdown][github_markdown] document for this page.
- file [**`RESOURCES.md`**](RESOURCES.md) gathers [Standard ML][sml] related informations.
- file [**`setenv.bat`**](setenv.bat) is the batch command for setting up our environment.

<!--
> **:mag_right:** We use [VS Code][microsoft_vscode] with the extension [Markdown Preview Github Styling](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-preview-github-styles) to edit our Markdown files (see article ["Mastering Markdown"](https://guides.github.com/features/mastering-markdown/) from [GitHub Guides][github_guides].
-->

We also define a virtual drive &ndash; e.g. drive **`K:`** &ndash; in our working environment in order to reduce/hide the real path of our project directory (see article ["Windows command prompt limitation"][windows_limitation] from Microsoft Support).
> **:mag_right:** We use the Windows external command [**`subst`**][windows_subst] to create virtual drives; for instance:
>
> <pre style="font-size:80%;">
> <b>&gt; <a href="https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst">subst</a> K: <a href="https://learn.microsoft.com/en-us/windows/deployment/usmt/usmt-recognized-environment-variables#variables-that-are-recognized-only-in-the-user-context">%USERPROFILE%</a>\workspace\sml-examples</b>
> </pre>

In the next section we give a brief description of the [batch files][windows_batch_file] present in this project.

## <span id="commands">Batch commands</span>

We distinguish different sets of batch commands:

1. [**`setenv.bat`**](setenv.bat) - This batch command makes external tools such as [**`git.exe`**][git_cli] and [**`sh.exe`**][sh_cli] directly available from the command prompt (see section [**Project dependencies**](#proj_deps)).

   <pre style="font-size:80%;">
   <b>&gt; <a href="./setenv.bat">setenv</a> -verbose</b>
   Tool versions:
      MLton 20241230, mosmlc 2.01, sml 110.99.7.1,
      git 2.48.1, diff 3.10, bash 5.2.37(1)
   Tool paths:
      C:\opt\mlton\bin\mlton.bat
      C:\opt\mosml\bin\mosmlc.exe
      C:\opt\SMLNJ\bin\sml.bat
      C:\opt\Git\bin\git.exe
      C:\opt\Git\usr\bin\diff.exe
      C:\opt\Git\bin\bash.exe
   Environment variables:
      "GIT_HOME=C:\opt\Git"
      "MLTON_HOME=C:\opt\mlton"
      "MOSML_HOME=C:\opt\mosml"
      "MOSMLLIB=C:\opt\mosml\lib"
      "SMLNJ_HOME=C:\opt\smlnj"
   Path associations:
      K:\: => %USERPROFILE%\workspace-perso\sml-examples
   </pre>

<!--=======================================================================-->

## <span id="footnotes">Footnotes</span> [**&#x25B4;**](#top)


<span id="footnote_01">[1]</span> ***Downloads*** [↩](#anchor_01)

<dl><dd>
In our case we downloaded the following installation files (see <a href="#proj_deps">section 1</a>):
</dd>
<dd>
<pre style="font-size:80%;">
<a href="">mlton-20241230-1.amd64-mingw.windows-2022_MINGW64.tgz</a> <i>( 16 MB)</i>
<a href="https://git-scm.com/download/win" rel="external">PortableGit-2.48.1-64-bit.7z.exe</a>                      <i>( 43 MB)</i>
<a href="https://www.cl.cam.ac.uk/research/tsg/SMLNET/download.html">smlnet.tar.gz</a>                                         <i>(  3 MB)</i>
<a href="https://smlnj.org/dist/working/110.99.7.1/windows.html">smlnj-110.99.7.1.msi</a>                                  <i>( 13 MB)</i>
<a href="https://code.visualstudio.com/Download#" rel="external">VSCode-win32-x64-1.97.2.zip</a>                           <i>(131 MB)</i>
<a href="https://www.itu.dk/~sestoft/mosml.html" rel="external">win32-mos201bin.zip</a>                                   <i>(  2 MB)</i>
</pre>
</dd></dl>

<span id="footnote_02">[2]</span> ***SML/NJ Installation*** [↩](#anchor_02)

<dl><dd>
The Microsoft Installer package <a href="https://smlnj.org/dist/working/110.99.7.1/index.html" rel="external"><code>smlnj-110.99.7.1.msi</code></a> is the standard way to install SML/NJ under Windows. In addition to creating the installation directory it will update the  <code>PATH</code> environment variable and add the <code>SMLNJ_HOME</code> variable.

In this project we want to keep control of our environment and we just extract the installation directory <code>SMLNJ</code> from the installer (we define <code>SMLNJ_HOME</code> as a session variable) :

<pre style="font-size:80%;">
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows/win32/msi/command-line-options" rel="external">msiexec</a> /a smlnj-110.99.7.1.msi /qb TARGETDIR=%USERPROFILE%\Downloads\smlnj</b>
<b>&gt; <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/xcopy" rel="external">xcopy</a> /e /i %USERPROFILE%\Downloads\smlnj\pfiles\SMLNJ C:\opt\SMLNJ</b>
<b>&gt; c:\opt\SMLNJ\bin\sml -h | <a href="https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/findstr" rel="external">findstr</a> Version</b>
Standard ML of New Jersey [Version 110.99.7.1; 32-bit; January 17, 2025]
</pre>
</dd></dl>

***

*[mics](https://lampwww.epfl.ch/~michelou/)/February 2025* [**&#9650;**](#top)
<span id="bottom">&nbsp;</span>

<!-- link refs -->

[ada_examples]: https://github.com/michelou/ada-examples#top
[akka_examples]: https://github.com/michelou/akka-examples#top
[cobol_examples]: https://github.com/michelou/cobol-examples#top
[conemu_downloads]: https://github.com/Maximus5/ConEmu/releases
[conemu_relnotes]: https://conemu.github.io/blog/2023/07/24/Build-230724.html
[cpp_examples]: https://github.com/michelou/cpp-examples#top
[dafny_examples]: https://github.com/michelou/dafny-examples#top
[dart_examples]: https://github.com/michelou/dart-examples#top
[deno_examples]: https://github.com/michelou/deno-examples#top
[docker_examples]: https://github.com/michelou/docker-examples#top
[erlang_examples]: https://github.com/michelou/erlang-examples#top
[flix_examples]: https://github.com/michelou/flix-examples#top
[git_cli]: https://git-scm.com/docs/git
[git_downloads]: https://git-scm.com/download/win
[git_relnotes]: https://github.com/git/git/blob/v2.48.1/Documentation/RelNotes/2.48.1.txt
[github_markdown]: https://github.github.com/gfm/
[golang_examples]: https://github.com/michelou/golang-examples#top
[graalvm_examples]: https://github.com/michelou/graalvm-examples#top
[kafka_examples]: https://github.com/michelou/kafka-examples#top
[kotlin_examples]: https://github.com/michelou/kotlin-examples#top
[linux_opt]: https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html
[llvm_examples]: https://github.com/michelou/llvm-examples#top
[m2_examples]: https://github.com/michelou/m2-examples#top
[man1_awk]: https://www.linux.org/docs/man1/awk.html
[man1_diff]: https://www.linux.org/docs/man1/diff.html
[man1_file]: https://www.linux.org/docs/man1/file.html
[man1_grep]: https://www.linux.org/docs/man1/grep.html
[man1_more]: https://www.linux.org/docs/man1/more.html
[man1_mv]: https://www.linux.org/docs/man1/mv.html
[man1_rmdir]: https://www.linux.org/docs/man1/rmdir.html
[man1_sed]: https://www.linux.org/docs/man1/sed.html
[man1_wc]: https://www.linux.org/docs/man1/wc.html
[mlton_downloads]: https://github.com/MLton/mlton/releases/tag/on-20241230-release
[mlton_relnotes]: http://mlton.org/Release20241230
[mosml_downloads]: https://www.itu.dk/~sestoft/mosml.html
[nodejs_examples]: https://github.com/michelou/nodejs-examples#top
[rust_examples]: https://github.com/michelou/rust-examples#top
[scala3_examples]: https://github.com/michelou/dotty-examples#top
[sh_cli]: https://man7.org/linux/man-pages/man1/sh.1p.html
[sml]: https://www.smlnj.org/
[smlnet_downloads]: https://www.cl.cam.ac.uk/research/tsg/SMLNET/download.html
[smlnj_downloads]: https://www.smlnj.org/dist/working/
[smlnj_relnotes]: https://www.smlnj.org/dist/working/110.99.7.1/110.99.7.1-README.html
[spring_examples]: https://github.com/michelou/spring-examples#top
[spark_examples]: https://github.com/michelou/spark-examples#top
[trufflesqueak_examples]: https://github.com/michelou/trufflesqueak-examples#top
[unix_opt]: https://tldp.org/LDP/Linux-Filesystem-Hierarchy/html/opt.html
[vscode_downloads]: https://code.visualstudio.com/#alt-downloads
[vscode_relnotes]: https://code.visualstudio.com/updates/
[windows_batch_file]: https://en.wikibooks.org/wiki/Windows_Batch_Scripting
[windows_limitation]: https://support.microsoft.com/en-gb/help/830473/command-prompt-cmd-exe-command-line-string-limitation
[windows_subst]: https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/subst
[wix_examples]: https://github.com/michelou/wix-examples#top
[zig_examples]: https://github.com/michelou/zig-examples#top
[zip_archive]: https://www.howtogeek.com/178146/htg-explains-everything-you-need-to-know-about-zipped-files/
