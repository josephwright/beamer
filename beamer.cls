\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{beamer}
[2003/10/01 v0.90-dev Class for Typesetting a Beamer Presentation]

% Copyright 2003 by Till Tantau <tantau@cs.tu-berlin.de>.
%
% This program can be redistributed and/or modified under the terms
% of the LaTeX Project Public License Distributed from CTAN
% archives in directory macros/latex/base/lppl.txt.


%
%
% Basic packages
%
%

\RequirePackage{pgf}
% For all sorts of things...

\RequirePackage{color}
% For color management. Will move to xcolor some day

\RequirePackage{amssymb}
% For \blacktriangleright


%
%
% Setup of the page size and spacing parameters using geometry.
% Head and foot will be recalculated later on.
%
%
\RequirePackage[%
  papersize={12.80cm,9.60cm},
  hmargin=1cm,%
  vmargin=0cm,%
  head=0.5cm,%
  headsep=0pt,%
  foot=0.5cm]{geometry}


%
% Fix for older versions of geometry
%
\ifx\ifGm@compatii\@undefined%
\def\Gm@lmargin{\Geom@lmargin}\def\Gm@rmargin{\Geom@rmargin}
\else
\geometry{includeheadfoot}
\fi


%
%
% Inclusion of hyperref
%
%
\RequirePackage[implicit=false,%
  bookmarks=true,%
  bookmarksopen=true,%
  pdfborder={0 0 0},%
  pdfhighlight={/N}%
  ]{hyperref}

%
% Fix for implict=false for hyperref
%
\def\WriteBookmarks{0}
\expandafter\def\csname Parent-1\endcsname{}
\expandafter\def\csname Parent0\endcsname{}
\def\phantomsection{}

%
% Bugfix for old versions of pdfmark
%
\begingroup
  \catcode`P=12
  \catcode`T=12
  \lowercase{\endgroup
  \gdef\rem@ptetc#1.#2PT#3!{#1\ifnum#2>\z@.#2\fi}%
}
\def\strip@pt@and@otherjunk#1{\expandafter\rem@ptetc\the#1!}



%
%
% Fix for babel (will have an effect only, if babel is loaded)
%
%
\def\textlatin{}


%
% Theme coloring, this should be changed to use xcolor...
%
\def\themecolor#1#2#3{
  \definecolor{structure}{rgb}{#1,#2,#3}
  \edef\thethemecolor{#1,#2,#3}
  \pgf@ya=1pt
  \advance\pgf@ya by-#1pt%
  \pgf@ya=.4\pgf@ya%
  \pgf@x=1pt%
  \advance\pgf@x by-\pgf@ya%
  \pgf@ya=1pt
  \advance\pgf@ya by-#2pt%
  \pgf@ya=.4\pgf@ya%
  \pgf@y=1pt%
  \advance\pgf@y by-\pgf@ya%
  \pgf@ya=1pt
  \advance\pgf@ya by-#3pt%
  \pgf@ya=.4\pgf@ya%
  \pgf@xa=1pt%
  \advance\pgf@xa by-\pgf@ya%
  \definecolor{structureshaded}{rgb}{\pgfget{x},\pgfget{y},\pgfget{xa}}
  \edef\theshadedthemecolor{\pgfget{x},\pgfget{y},\pgfget{xa}}
  \pgf@ya=1pt
  \advance\pgf@ya by-#1pt%
  \pgf@ya=.7\pgf@ya%
  \pgf@x=1pt%
  \advance\pgf@x by-\pgf@ya%
  \pgf@ya=1pt
  \advance\pgf@ya by-#2pt%
  \pgf@ya=.7\pgf@ya%
  \pgf@y=1pt%
  \advance\pgf@y by-\pgf@ya%
  \pgf@ya=1pt
  \advance\pgf@ya by-#3pt%
  \pgf@ya=.7\pgf@ya%
  \pgf@xa=1pt%
  \advance\pgf@xa by-\pgf@ya%
  \definecolor{structuremedium}{rgb}{\pgfget{x},\pgfget{y},\pgfget{xa}}
  }
\themecolor{0.2}{0.2}{0.7}


%
%
% Ifs for document options
%
%
\newif\if@altmode
\@altmodefalse
\newif\if@notes
\@notesfalse
\newif\if@notesnormals
\@notesnormalstrue

\newif\ifsubsectionrows
\newif\ifsubsectionshide
\newif\ifsubsectionsshaded
\subsectionrowsfalse
\subsectionshidefalse
\subsectionsshadedfalse

\newif\ifbeamer@centered


%
%
% Document options
%
%
\DeclareOption{hidesubsections}
{\subsectionshidetrue}

\DeclareOption{shadesubsections}
{\subsectionsshadedtrue}

\DeclareOption{inrow}
{\subsectionrowstrue}

\DeclareOption{slidescentered}
{\beamer@centeredtrue}

\DeclareOption{slidestop}
{\beamer@centeredfalse}

\DeclareOption{blue}
{\themecolor{0.2}{0.2}{0.7}}

\DeclareOption{red}
{\themecolor{0.7}{0.2}{0.2}}

\DeclareOption{grey}
{\themecolor{0.2}{0.2}{0.2}}

\DeclareOption{brown}
{\themecolor{0.66}{0.4}{0.166}}

\DeclareOption{leqno}{\input{leqno.clo}}
\DeclareOption{fleqn}{\input{fleqn.clo}}

\def\@currentmode{default}
\DeclareOption{handout}{\gdef\@currentmode{handout}}
\DeclareOption{trans}{\gdef\@currentmode{trans}}

\DeclareOption{notes}{\@notestrue}
\DeclareOption{notesonly}{\@notestrue\@notesnormalsfalse}

\newif\if@sansmath

\DeclareOption{sans}{%
  \def\familydefault{\sfdefault}
  \def\mathfamilydefault{\sfdefault}
  \@sansmathtrue
}
\DeclareOption{serif}{%
  \def\familydefault{\rmdefault}
  \def\mathfamilydefault{\rmdefault}
  \@sansmathfalse
}

\DeclareOption{mathsans}{\def\mathfamilydefault{\sfdefault}\@sansmathtrue}
\DeclareOption{mathserif}{\def\mathfamilydefault{\rmdefault}\@sansmathfalse}

\DeclareOption{pdftex}{\PassOptionsToPackage{pdftex}{hyperref}}
\DeclareOption{nativepdf}{\PassOptionsToPackage{nativepdf}{hyperref}}
\DeclareOption{pdfmark}{\PassOptionsToPackage{pdfmark}{hyperref}}
\DeclareOption{dvips}{\PassOptionsToPackage{dvips}{hyperref}}
\DeclareOption{dviwindo}{\PassOptionsToPackage{dviwindo}{hyperref}}
\DeclareOption{dvipsone}{\PassOptionsToPackage{dvipsone}{hyperref}}
\DeclareOption{vtex}{\PassOptionsToPackage{vtex}{hyperref}}
\DeclareOption{ps2pdf}{\PassOptionsToPackage{ps2pdf}{hyperref}}

\def\beamer@size{{size11.clo}}
\DeclareOption{bigger}{\def\beamer@size{{size12.clo}}}
\DeclareOption{smaller}{\def\beamer@size{{size10.clo}}}

%
%
% Process Options
%
%
\ExecuteOptions{sans,slidescentered}

\ProcessOptions

\expandafter\input\beamer@size


%
%
% Declarations used by beamer
%
%

% Public
\newdimen\headheight    % Height of the headline
\newdimen\footheight    % Height of the footline
\newdimen\sidebarheight % Height of the sidebars

% Private (will all have prefix beamer@ in the future)
\newdimen\beamer@tempdim
\newdimen\beamer@finalheight
\newdimen\beamer@animht
\newdimen\beamer@animdp
\newdimen\beamer@animwd
\newdimen\beamer@leftmargin
\newdimen\beamer@rightmargin
\newdimen\beamer@leftsidebar
\newdimen\beamer@rightsidebar
\newdimen\tempheight
\newdimen\beamer@boxsize
\newdimen\vboxoffset
\newdimen\postemp
\newdimen\originalbaselineskip
\newdimen\@descdefault
\newdimen\@descdefaulttemp
\newdimen\bibindent
\newbox\beamer@areabox
\newbox\beamer@animcurrent
\newbox\beamer@animshowbox
\newbox\beamer@tempbox
\newbox\sectionbox
\newbox\tempbox
\newbox\navigationbox
\newbox\logobox
\newbox\linebox


%
%
% Hyperlink fix for problem with empty test in pdfmark.def
%
%
\let\beamer@orighyperlink\hyperlink
\def\hyperlink#1#2{\beamer@orighyperlink{#1}{\relax#2}}


% Hyperlinks must be suspended until document starts - they are used
% inside \usetemplate commands before the beginning of the document,
% but there we do not want them to have an effect.
\let\suspendedhyperlink\hyperlink
\def\hyperlink#1#2{#2}
\providecommand\hyper@pagetransition{}
\providecommand\hyper@pageduration{}
\providecommand\hyper@pagehidden{}

\AtBeginDocument{%
\if@notesnormals\let\hyperlink\suspendedhyperlink\fi%

\if@sansmath
\SetSymbolFont{operators}{normal}{OT1}{cmss}{m}{n}
\ifx\mv@bold\@undefined\else
\SetSymbolFont{operators}{bold}{OT1}{cmss}{bx}{n}
\fi
\fi

\newif\if@suppressreplacements % decides whether fonts should be substituted
\@suppressreplacementsfalse
\def\@cmr{cmr}
\edef\@fmdef{\mathfamilydefault}

% supress for standard cm
\ifx\@fmdef\@cmr\@suppressreplacementstrue\fi

% supress for mathtime serif
\@ifpackageloaded{mathtime}{\if@sansmath\else\@suppressreplacementstrue\fi}{}

\if@suppressreplacements\else
  \DeclareSymbolFont{numbers}{OT1}{\mathfamilydefault}{m}{n}
  \DeclareSymbolFont{pureletters}{OT1}{\mathfamilydefault}{m}{it}
  \ifx\mv@bold\@undefined\else
  \SetSymbolFont{numbers}{bold}{OT1}{\mathfamilydefault}{bx}{n}
  \SetSymbolFont{pureletters}{bold}{OT1}{\mathfamilydefault}{bx}{it}
  \fi

  \def\operator@font{\mathgroup\symnumbers}

  \DeclareMathSymbol{0}\mathalpha{numbers}{"30}
  \DeclareMathSymbol{1}\mathalpha{numbers}{"31}
  \DeclareMathSymbol{2}\mathalpha{numbers}{"32}
  \DeclareMathSymbol{3}\mathalpha{numbers}{"33}
  \DeclareMathSymbol{4}\mathalpha{numbers}{"34}
  \DeclareMathSymbol{5}\mathalpha{numbers}{"35}
  \DeclareMathSymbol{6}\mathalpha{numbers}{"36}
  \DeclareMathSymbol{7}\mathalpha{numbers}{"37}
  \DeclareMathSymbol{8}\mathalpha{numbers}{"38}
  \DeclareMathSymbol{9}\mathalpha{numbers}{"39}

  \DeclareMathSymbol{A}\mathalpha{pureletters}{"41}
  \DeclareMathSymbol{B}\mathalpha{pureletters}{"42}
  \DeclareMathSymbol{C}\mathalpha{pureletters}{"43}
  \DeclareMathSymbol{D}\mathalpha{pureletters}{"44}
  \DeclareMathSymbol{E}\mathalpha{pureletters}{"45}
  \DeclareMathSymbol{F}\mathalpha{pureletters}{"46}
  \DeclareMathSymbol{G}\mathalpha{pureletters}{"47}
  \DeclareMathSymbol{H}\mathalpha{pureletters}{"48}
  \DeclareMathSymbol{I}\mathalpha{pureletters}{"49}
  \DeclareMathSymbol{J}\mathalpha{pureletters}{"4A}
  \DeclareMathSymbol{K}\mathalpha{pureletters}{"4B}
  \DeclareMathSymbol{L}\mathalpha{pureletters}{"4C}
  \DeclareMathSymbol{M}\mathalpha{pureletters}{"4D}
  \DeclareMathSymbol{N}\mathalpha{pureletters}{"4E}
  \DeclareMathSymbol{O}\mathalpha{pureletters}{"4F}
  \DeclareMathSymbol{P}\mathalpha{pureletters}{"50}
  \DeclareMathSymbol{Q}\mathalpha{pureletters}{"51}
  \DeclareMathSymbol{R}\mathalpha{pureletters}{"52}
  \DeclareMathSymbol{S}\mathalpha{pureletters}{"53}
  \DeclareMathSymbol{T}\mathalpha{pureletters}{"54}
  \DeclareMathSymbol{U}\mathalpha{pureletters}{"55}
  \DeclareMathSymbol{V}\mathalpha{pureletters}{"56}
  \DeclareMathSymbol{W}\mathalpha{pureletters}{"57}
  \DeclareMathSymbol{X}\mathalpha{pureletters}{"58}
  \DeclareMathSymbol{Y}\mathalpha{pureletters}{"59}
  \DeclareMathSymbol{Z}\mathalpha{pureletters}{"5A}

  \DeclareMathSymbol{a}\mathalpha{pureletters}{"61}
  \DeclareMathSymbol{b}\mathalpha{pureletters}{"62}
  \DeclareMathSymbol{c}\mathalpha{pureletters}{"63}
  \DeclareMathSymbol{d}\mathalpha{pureletters}{"64}
  \DeclareMathSymbol{e}\mathalpha{pureletters}{"65}
  \DeclareMathSymbol{f}\mathalpha{pureletters}{"66}
  \DeclareMathSymbol{g}\mathalpha{pureletters}{"67}
  \DeclareMathSymbol{h}\mathalpha{pureletters}{"68}
  \DeclareMathSymbol{i}\mathalpha{pureletters}{"69}
  \DeclareMathSymbol{j}\mathalpha{pureletters}{"6A}
  \DeclareMathSymbol{k}\mathalpha{pureletters}{"6B}
  \DeclareMathSymbol{l}\mathalpha{pureletters}{"6C}
  \DeclareMathSymbol{m}\mathalpha{pureletters}{"6D}
  \DeclareMathSymbol{n}\mathalpha{pureletters}{"6E}
  \DeclareMathSymbol{o}\mathalpha{pureletters}{"6F}
  \DeclareMathSymbol{p}\mathalpha{pureletters}{"70}
  \DeclareMathSymbol{q}\mathalpha{pureletters}{"71}
  \DeclareMathSymbol{r}\mathalpha{pureletters}{"72}
  \DeclareMathSymbol{s}\mathalpha{pureletters}{"73}
  \DeclareMathSymbol{t}\mathalpha{pureletters}{"74}
  \DeclareMathSymbol{u}\mathalpha{pureletters}{"75}
  \DeclareMathSymbol{v}\mathalpha{pureletters}{"76}
  \DeclareMathSymbol{w}\mathalpha{pureletters}{"77}
  \DeclareMathSymbol{x}\mathalpha{pureletters}{"78}
  \DeclareMathSymbol{y}\mathalpha{pureletters}{"79}
  \DeclareMathSymbol{z}\mathalpha{pureletters}{"7A}
\fi

  }
\let\beamer@origdocument\document
\def\document{%
  \endgroup%
  \recalculatefoot%
  \recalculatehead%
  \AtBeginDocument{% fix french.ldf's meddling with \itemize and \trivlist
    \ifx\bbl@nonfrenchitemize\@undefined\else\bbl@nonfrenchitemize\fi%
    \ifx\bbl@nonfrenchlistspacing\@undefined\else\bbl@nonfrenchlistspacing\fi}%
  \begingroup\beamer@origdocument}

\definecolor{alert}{rgb}{1,0,0}
\definecolor{darkgreen}{rgb}{0.15,0.6,0.15}
\definecolor{shaded}{gray}{0.6}
\definecolor{blockstructure}{rgb}{0.2,0.2,0.7}
\definecolor{lightgray}{gray}{0.9}

%
% Page where the appendix start.
%
\def\beamer@appendixstart{1}

% Calculate number of sections/subsections
\newcount\subsection@max
\newcount\section@max
\subsection@max=0\relax
\section@max=0\relax

\newcount\totalheads
\def\headcommand#1{\advance\totalheads by1\relax\expandafter\def\csname
  head\the\totalheads\endcsname{#1}}
\@input{\jobname.head}
\newcount\headcounter
\def\dohead{\headcounter=0\loop\ifnum\headcounter<\totalheads%
  \advance\headcounter by1\relax%
  \csname head\the\headcounter\endcsname\repeat}

\def\sectionentry#1#2#3#4{\ifnum\section@max<#1\relax\section@max=#1\fi}
\def\slideentry#1#2#3#4#5{\ifnum\subsection@max<#2\relax\subsection@max=#2\fi}
\def\appendixslideentry#1#2#3#4#5{\ifnum\subsection@max<#2\relax\subsection@max=#2\fi}
\def\appendixsectionentry#1#2#3#4{\gdef\beamer@appendixstart{#3}}
\dohead


\setlength\lineskip{1\p@}
\setlength\normallineskip{1\p@}
\renewcommand\baselinestretch{}

\setlength\parskip{0\p@}% \@plus \p@}
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\setcounter{topnumber}{2}
\renewcommand\topfraction{.7}
\setcounter{bottomnumber}{1}
\renewcommand\bottomfraction{.3}
\setcounter{totalnumber}{3}
\renewcommand\textfraction{.9}%.2}
\renewcommand\floatpagefraction{.1}%5}
\setcounter{dbltopnumber}{2}
\renewcommand\dbltopfraction{.7}
\renewcommand\dblfloatpagefraction{.5}
\setlength\leftmargini  {2em}
\setlength\leftmarginii  {2em}
\setlength  \labelsep  {.5em}
\setlength  \labelwidth{\leftmargini}
\addtolength\labelwidth{-\labelsep}
\@beginparpenalty -\@lowpenalty
\@endparpenalty   -\@lowpenalty
\@itempenalty     -\@lowpenalty

\setcounter{tocdepth}{2}

\renewcommand\theenumi{\@arabic\c@enumi}
\renewcommand\theenumii{\@arabic\c@enumii}

\def\@listi{\leftmargin\leftmargini
            \topsep 4\p@ \@plus2\p@ \@minus\p@
            \parsep 0\p@
            \itemsep4\p@ \@plus2\p@ \@minus2\p@}
\let\@listI\@listi
\def\@listii {\leftmargin\leftmarginii
              \topsep    2\p@ \@plus2\p@ \@minus\p@
              \parsep    0\p@   \@plus\p@  \@minus\p@
              \itemsep   \parsep}

\setlength\arraycolsep{5\p@}
\setlength\tabcolsep{6\p@}
\setlength\arrayrulewidth{.4\p@}
\setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep}
\skip\@mpfootins = \skip\footins
\setlength\fboxsep{3\p@}
\setlength\fboxrule{.4\p@}

%
% Bugfix of latex internals
%
\def\smallskip{\vskip\smallskipamount}
\def\medskip{\vskip\medskipamount}
\def\bigskip{\vskip\bigskipamount}


%
%
% The \titlepage and \usetitlepagetemplate command
%
%
\newcommand\titlepage{{\beamer@titlepagetemplate}}
\long\def\usetitlepagetemplate#1{\def\beamer@titlepagetemplate{#1}}


%
%
% The \title command
%
%
\def\title{\@ifnextchar[{\beamer@title}{\beamer@title@}}
\def\beamer@title@#1{\beamer@title[#1]{#1}}
\def\beamer@title[#1]#2{%
  \def\inserttitle{#2}%
  \def\insertshorttitle{\def\\{}%
    \ifnum\thepage=1%
    \edef\beamer@def{{Navigation\beamer@appendixstart}}%
    \expandafter\hyperlink\beamer@def{#1}%
    \else%
    \hyperlink{Navigation1}{#1}%
    \fi}%
  }
\title{}


%
%
% The \date command
%
%
\def\date{\@ifnextchar[{\beamer@date}{\beamer@date@}}
\def\beamer@date@#1{\beamer@date[#1]{#1}}
\def\beamer@date[#1]#2{%
  \def\insertdate{#2}%
  \def\insertshortdate{#1}%
  }
\date{\today}


%
%
% The \author command
%
%
\def\author{\@ifnextchar[{\beamer@author}{\beamer@author@}}
\def\beamer@author@#1{\beamer@author[#1]{#1}}
\def\beamer@author[#1]#2{%
  \def\insertauthor{\def\inst{\beamer@insttitle}\def\and{\beamer@andtitle}#2}%
  \def\insertshortauthor{\def\inst{\beamer@instother}\def\and{\beamer@andother}#1}}
\author{}

% Aux commands for \author
\def\beamer@insttitle#1{$^{#1}$}
\def\beamer@andtitle{\quad}
\def\beamer@instother#1{}
\def\beamer@andother{\unskip, }


%
%
% The \titlegraphic command
%
%
\def\titlegraphic#1{\def\inserttitlegraphic{#1}}
\titlegraphic{}


%
%
% The \institute command
%
%
\def\institute{\@ifnextchar[{\beamer@institute}{\beamer@institute@}}
\def\beamer@institute@#1{\beamer@institute[#1]{#1}}
\def\beamer@institute[#1]#2{%
  \def\insertinstitute{\def\inst{\beamer@instinst}\def\and{\beamer@andinst}#2}%
  \def\insertshortinstitute{\def\inst{\beamer@instother}\def\and{\beamer@andother}#1}}
\institute{}

\def\beamer@instinst#1{$^{#1}$\ignorespaces}
\def\beamer@andinst{\\[1em]}


%
%
% The \logo command
%
%
\newcommand\logo[1]{\def\insertlogo{#1}}
\logo{}


%
%
% Empty test
%
%
\def\@isempty{}
\long\def\@ifempty#1#2#3{\def\@shouldbeempty{#1}\ifx\@shouldbeempty\@isempty#2\else#3\fi}


%
% Section Definitions
%
\def\sectionname{Section}
\newcounter{section}
\renewcommand\thesection{\@arabic\c@section}

\def\section{\@ifnextchar[\@section\@@section}
\long\def\@@section#1{\@section[#1]{#1}}
\long\def\@section[#1]#2{%
  \refstepcounter{section}%
  \@ifempty{#2}{\long\def\secname{#1}}{\long\def\secname{#2}\addtocontents{toc}{\protect\sectionintoc{\thesection}{#2}{\thepage}}}%
  \addtocontents{head}{\protect\headcommand{\protect\sectionentry{\thesection}{#1}{\thepage}{\secname}}}%
  {\let\\=\relax\xdef\sectionlink{{Navigation\thepage}{\noexpand\secname}}}%
  \def\insertsection{\expandafter\hyperlink\sectionlink}%
  \def\insertsubsection{}%
  \def\lastsubsection{}%
  \Hy@writebookmark{\thesection}{\secname}{Outline\thesection}{1}{toc}%
  \hyper@anchorstart{Outline\thesection}\hyper@anchorend}%
\def\insertsection{}
\def\lastsubsection{}

\def\breakhere{\protect\@breakhere}
\def\@breakhere{}



%
% Subsection Definitions
%
\newcounter{subsection}[section]
\renewcommand\thesubsection{\@arabic\c@subsection}

\def\subsection{\@ifnextchar[\@subsection\@@subsection}
\def\@@subsection#1{\@subsection[#1]{#1}}

\def\@subsection[#1]#2{%
  \ifsubsectionrows\ifnum0=\c@subsection\refstepcounter{subsection}\fi%
  \else\refstepcounter{subsection}\fi%
  \@ifempty{#2}{\long\def\subsecname{#1}\long\def\lastsubsection{#1}}
  {%
    \long\def\subsecname{#2}%
    \long\def\lastsubsection{#1}%
    \ifbeamer@inappendix%
    \addtocontents{toc}{\protect\appendixsubsectionintoc{\thesection}{\thesubsection}{#2}{\thepage}}%
    \else%
    \addtocontents{toc}{\protect\subsectionintoc{\thesection}{\thesubsection}{#2}{\thepage}}%
    \fi%
  }%
  \edef\subsectionlink{{Navigation\thepage}{\noexpand\subsecname}}%
  \def\insertsubsection{\expandafter\hyperlink\subsectionlink}
  \Hy@writebookmark{\thesubsection}{#1}{Outline\thesection.\thesubsection.\thepage}{2}{toc}%
  \hyper@anchorstart{Outline\thesection.\thesubsection.\thepage}\hyper@anchorend}



\def\untitledsubsection{%
  \ifsubsectionrows\ifnum0=\c@subsection\refstepcounter{subsection}\fi%
  \else\refstepcounter{subsection}\fi%
  \def\insertsubsection{}%
  \def\lastsubsection{}}
\def\insertsubsection{}


%
% Slide Definitions
%

\newcounter{subsectionslide}[subsection]
\renewcommand\thesubsectionslide{\@arabic\c@subsectionslide}
\def\beamer@entrycode{}
\def\beamer@exitcode{}

\newenvironment{frameslide}[1][1]{%
  {\let\@elt\@restorecounter\@overlaycounterresets}
  \hypersetup{pdfpagetransition=R}%
  \serialnumber=#1\relax%
  \expandafter\@ifempty\expandafter{\beamer@framestartpage}{%
    \refstepcounter{subsectionslide}%
    \xdef\beamer@framestartpage{\thepage}% only first time
  }{\clearpage% cleanup from previous slide
  }%
  \xdef\beamer@frameendpage{\thepage}% every time
  \beamer@entrycode\vspace*{-\baselineskip}\vfill}%
  {\beamer@exitcode\vskip0pt plus 1.5fill}

\def\frametitle#1{%
  \vskip0pt plus -1fill%
  {\gdef\insertframetitle{#1\par}\@headrenderer}
  \vskip0.25em%
  \ifbeamer@centered
  \vfill%
  \fi
}

\long\def\useframetitletemplate#1{\def\@headrenderer{#1}}



%
% Appendix stuff
%
\newif\ifbeamer@inappendix
\def\appendix{%
  \beamer@inappendixtrue%
  \refstepcounter{section}%
  \long\edef\secname{\appendixname}%
  \addtocontents{toc}{\protect\appendixtoc{\thesubsection}{\appendixname}{\thepage}}
  \addtocontents{head}{\protect\headcommand{\protect\appendixsectionentry{\thesection}{\secname}{\thepage}{\secname}}}%
  \xdef\sectionlink{{Navigation\thepage}{\noexpand\secname}}%
  \def\insertsection{\expandafter\hyperlink\sectionlink}%
  \def\insertsubsection{}%
  \def\lastsubsection{}%
  \Hy@writebookmark{\thesection}{\secname}{Outline\thesection}{1}{toc}%
  \hyper@anchorstart{Outline\thesection}\hyper@anchorend}%



%
%
% Overlaying
%
%

\let\origverb@egroup=\verb@egroup

\def\@setb{\setbox0=\copy}
\long\def\defverb#1{%
  \expandafter\newbox\csname @verb\string#1\endcsname%
  \def#1{{\expandafter\@setb\csname
      @verb\string#1\endcsname\unhbox0}}%
  \def\verb@egroup{\global\let\verb@balance@group\@empty\egroup\egroup\let\verb@egroup=\origverb@egroup}
  \expandafter\setbox\csname @verb\string#1\endcsname=\hbox\bgroup
  \verb}


\long\def\defverbatim#1{%
  \expandafter\newbox\csname @verb\string#1\endcsname%
  \def#1{{\expandafter\@setb\csname @verb\string#1\endcsname\unvbox0}}%
  \expandafter\setbox\csname @verb\string#1\endcsname=\vbox\bgroup
  \def\set@color{}\def\reset@color{}\let\@next=}

\def\beamer@parsebr#1{\@ifnextchar<{\beamer@@parsebr#1}{#1}}
\def\beamer@@parsebr#1{\begingroup\catcode`:=12\catcode`|=12\beamer@parseinner{#1}}%
\def\beamer@parseinner#1<#2>{\endgroup\edef\beamer@spec{<#2>}%
  \expandafter#1\beamer@spec}

\def\alt{\beamer@parsebr\@alt}
\long\def\@alt<#1>#2#3{%
  \def\dowhat{#3}\def\doit{#2}%
  {\setbox0=\hbox{\decode#1| stop:| }}\dowhat}

\def\temporal{\beamer@parsebr\@temporal}
\long\def\@temporal<#1>#2#3#4{% past, present, future
  \def\dowhat{\@picked}\def\doit{#3}%
  {\setbox0=\hbox{\@localanotherslidefalse\decode#1| stop:|
      \if@localanotherslide\gdef\@picked{#2}\else\gdef\@picked{#4}\fi}}\dowhat}

\def\original#1{\csname @orig\string#1\endcsname}

\long\def\newoverlaycommand#1#2#3{% In slides, #1 does #2, otherwise #3
  \def#1{\@ifnextchar<{\@overlayparse{#2}{#3}}{#2}}}

\long\def\renewoverlaycommand#1#2#3{% In slides, #1 does #2, otherwise #3
  \edef\@name{\original#1}
  \expandafter\let\@name=#1\relax%
  \def#1{\@ifnextchar<{\@overlayparse{#2}{#3}}{#2}}}

\long\def\@overlayparse#1#2<#3>{\alt<#3>{#1}{#2}}

\def\newoverlayenvironment#1{%
  \@ifnextchar[{\@@newoverlayenvironment{#1}}{\@newoverlayenvironment{#1}}}

\long\def\@newoverlayenvironment#1#2#3#4#5{% In slides, #1 forms an
% environment with begin #2 and end #3, otherwise an environment with 
% begin #4 and end #5
  \newenvironment{#1}{}{}%
  \expandafter\def\csname #1\endcsname{%
    \@ifnextchar<{\@parsebegin{#1}{#2}{#3}{#4}{#5}}{%
      \expandafter\def\csname end#1\endcsname{#3}#2}}%
  }
    
\long\def\@parsebegin#1#2#3#4#5<#6>{%
  \alt<#6>{% In slide case
    \expandafter\def\csname end#1\endcsname{#3}%
    #2}{%
    \expandafter\def\csname end#1\endcsname{#5}%
    #4}}

\long\def\renewoverlayenvironment#1#2#3#4#5{%
  \edef\@do{\csname original#1\endcsname=\expandafter\noexpand\csname#1\endcsname}
  \expandafter\let\@do
  \edef\@do{\csname endoriginal#1\endcsname=\expandafter\noexpand\csname end#1\endcsname}
  \expandafter\let\@do
  \renewenvironment{#1}{}{}%
  \expandafter\def\csname #1\endcsname{%
    \@ifnextchar<{\@parsebegin{#1}{#2}{#3}{#4}{#5}}{%
      \expandafter\def\csname end#1\endcsname{#3}#2}%
    }%
  }

\long\def\@@newoverlayenvironment#1[1]#2#3#4#5{% Currently, this works
% only for a single argument
  \newenvironment{#1}{}{}%
  \expandafter\new@command\csname @in#1\endcsname[1]{#2}%
  \expandafter\new@command\csname @out#1\endcsname[1]{#4}%
  \expandafter\def\csname #1\endcsname##1{%
    \@ifnextchar<{\@parsebegin{#1}{\csname @in#1\endcsname{##1}}{#3}{\csname @out#1\endcsname{##1}}{#5}}{%
      \expandafter\def\csname end#1\endcsname{#3}#2}}%
}


%
% Resetting counters
%  

\def\resetcounteronoverlays#1{%
  \@cons\@overlaycounterresets{{c@#1}}%  
}

\def\resetcountonoverlays#1{%
  \@cons\@overlaycounterresets{{#1}}%  
}

\def\@overlaycounterresets{}
  
\resetcounteronoverlays{equation}
\resetcounteronoverlays{parentequation}
\resetcounteronoverlays{footnote}
\resetcounteronoverlays{mpfootnote}

\def\@savecounter#1{%
  \@ifundefined{#1}{}%
  {\expandafter\xdef\csname saved@#1\endcsname%
    {\expandafter\the\csname #1\endcsname}}%
}
\def\@restorecounter#1{%
  \@ifundefined{#1}{}%
  {\edef\temp{\csname saved@#1\endcsname}%
  \expandafter\global\csname #1\endcsname=\temp}%
}

  
%
% Make item overlays
%

\let\@origitem=\item
\def\item{%
  \@closeitem\gdef\@closeitem{}%
  \@ifnextchar<{\@parseitem}{\@origitem}}
\def\@closeitem{}
\def\@parseitem<#1>{%
  \alt<#1>{\pgfsys@begininvisible\pgfsys@endinvisible%for spacing reasons
    \gdef\@closeitem{\pgfsys@begininvisible\pgfsys@endinvisible}\@origitem}%
  {\pgfsys@begininvisible\gdef\@closeitem{\pgfsys@endinvisible}\@origitem}%
  }

\let\@origendtrivlist=\endtrivlist
\def\endtrivlist{\@closeitem\global\let\@closeitem=\@sci\global\let\@sci=\@ssci\global\let\@ssci=\@sssci\@origendtrivlist}
\let\@orig@trivlist=\@trivlist
\def\@trivlist{\global\let\@sssci=\@ssci\global\let\@ssci=\@sci\global\let\@sci=\@closeitem\gdef\@closeitem{}\@orig@trivlist}
\def\@closeitem{}

\newcount\serialnumber
\newcount\@serialnumber
\newcount\maxserialnumber

\newif\if@anotherslide
\newif\if@localanotherslide

\newcounter{framenumber}
\def\insertframenumber{\@arabic\c@framenumber}

\def\frame{\@ifnextchar[{\@frame}{\@frame[+]}}
\def\@frame[#1]{%
  \refstepcounter{framenumber}%
  {\let\@elt\@savecounter\@overlaycounterresets}
  \gdef\insertframetitle{}%
  \gdef\beamer@framestartpage{}%
  \gdef\@whichframes{#1}%
  \serialnumber=0\relax%
  \@anotherslidefalse%
  {\setbox0=\hbox{\expandafter\decode\@whichframes| stop:| }}%
  \if@anotherslide%
  \serialnumber=2\relax%
  \def\dowhat{}%
  \def\doit{\let\howtotreatframe\doseveralframes}%
  \@anotherslidefalse%
  {\setbox0=\hbox{\expandafter\decode\@whichframes| stop:| }}%
  \if@anotherslide%
  \let\howtotreatframe\doseveralframes\else%
  \let\howtotreatframe\dosingleframe%
  \fi%
  \dowhat%
  \else%
  \let\howtotreatframe\donoframe%
  \fi%
  \if@notesnormals\else\let\howtotreatframe\donoframe\fi%
  \howtotreatframe}
\long\def\donoframe{%
  \serialnumber=1\relax%
  \@serialnumber=1\relax%
  \setbox\tempbox\vbox\bgroup\leavevmode\afterassignment\@checknoslide\let\@next}
\def\@checknoslide{%
  \ifcat\bgroup\noexpand\@next%
  \let\@do\beamer@reseteecodes%
  \else\let\@do\beamer@noframesingletoken\fi%
  \@do}
\def\beamer@noframesingletoken{\@next\egroup\beamer@reseteecodes}

\long\def\doseveralframes#1{%
  \@serialnumber=1\relax%
  \loop%
  \@anotherslidefalse%
  \def\dowhat{}%
  \def\doit{\begin{frameslide}[\@serialnumber]%
    #1%
  \end{frameslide}}%
  \serialnumber=\@serialnumber%
  {\setbox0=\hbox{\expandafter\decode\@whichframes| stop:| }}%
  \dowhat%
  \if@anotherslide
  \advance\@serialnumber by 1\relax
  \repeat%
  \beamer@writeslidentry%
  \beamer@reseteecodes}

\def\dosingleframe{\begin{frameslide}[1]\bgroup\aftergroup\@endslide\afterassignment\@checkslide\let\@next}
\def\@checkslide{%
  \ifcat\bgroup\noexpand\@next%
  \let\@do\relax%
  \else\let\@do\beamer@singletoken\fi%
  \@do}
\def\@endslide{\end{frameslide}\beamer@writeslidentry\beamer@reseteecodes}
\def\beamer@singletoken{\@next\egroup}

\def\beamer@writeslidentry{%
  \expandafter\@ifempty\expandafter{\beamer@framestartpage}{}% nothing to do ...
  {%else
    \ifbeamer@inappendix%
      \addtocontents{head}%
        {\protect\headcommand{% 
            \protect\appendixslideentry{\thesection}{\thesubsection}{\thesubsectionslide}%
            {\beamer@framestartpage/\beamer@frameendpage}{\lastsubsection}}}%
    \else%
      \addtocontents{head}%
        {\protect\headcommand{%
            \protect\slideentry{\thesection}{\thesubsection}{\thesubsectionslide}%
            {\beamer@framestartpage/\beamer@frameendpage}{\lastsubsection}}}%
    \fi%
    \clearpage%
  }
}


\def\beamer@reseteecodes{\gdef\beamer@entrycode{}\gdef\beamer@exitcode{}\pagestyle{navigation}\thispagestyle{navigation}}

\def\plainframe{%
  \def\beamer@entrycode{\vspace*{-\headheight}}%
  \def\beamer@exitcode{\vspace*{-\footheight}\thispagestyle{empty}}\frame}

% Sets dowhat to doif, if \serialnumber is in the specified
% interval. Example: 5-7,-3,9,11,13- would mean pages
% 1,2,3,5,6,7,9,11,13,14,15,16,... 
%
% As a side effect, \@another is called whenever the there is a number
% in the list that is larger than the current serialnumber

\def\decode{\gdef\@decodefound{+}\@@decodefind}
\def\@@decodefind{\futurelet\@next\@decodeinsertdefault}
\def\@decodeinsertdefault{\ifcat\@next a%
  \gdef\@next{}%
  \else%
  \gdef\@next{default:}%
  \fi%
  \expandafter\@decodefind\@next}

\def\@modestop{stop}
\def\@modeall{all}
\def\@decodefind#1:#2| {%
  \def\@mode{#1}%
  \ifx\@mode\@modestop%
    \expandafter\@decode\@decodefound,!%
    \let\@next=\relax%
  \else
    \ifx\@mode\@currentmode%
      \gdef\@decodefound{#2}%
    \else%
      \ifx\@mode\@modeall%
        \gdef\@decodefound{#2}%
      \fi%
    \fi%
    \let\@next=\@@decodefind%
  \fi%
  \@next}

\def\dowhat{}
\def\@decode{%
  \@ifnextchar!%
  {\@decodeend}%
  {%
    \@ifnextchar+%
    {\@decodeall}{%
      \@ifnextchar-%
      {\@decodeuntil}%
      {\@decodenumber}}}}
\def\@decodeend!{}
\def\@decodeall+,{\ifnum1>\serialnumber%
  \global\@anotherslidetrue%
  \@localanotherslidetrue%
  \fi%
  \gdef\dowhat{\doit}\@decode}
\def\@decodeuntil-#1,{%
  \ifnum#1>\serialnumber\global\@anotherslidetrue\@localanotherslidetrue\fi%
  \ifnum\serialnumber>#1\else\gdef\dowhat{\doit}\fi%
  \@decode}
\def\@decodenumber#1{%
  \@ifnextchar,%
  {\@decodeone{#1}}%
  {\@ifnextchar-%
    {\@decodenumberto{#1}}%
    {\@decodegobble{#1}}}}
\def\@decodegobble#1#2{%
  \@decodenumber{#1#2}}
\def\@decodenumberto#1-{
  \@ifnextchar,%
  {\@decodeto{#1}}%
  {\@decodebetween{#1}}}
\def\@decodeto#1,{%
  \ifnum#1>\serialnumber\global\@anotherslidetrue\@localanotherslidetrue\fi%
  \ifnum#1>\serialnumber\else\gdef\dowhat{\doit}\fi%
  \@decode}
\def\@decodebetween#1#2,{%
  \ifnum#1>\serialnumber\global\@anotherslidetrue\@localanotherslidetrue\fi%
  \ifnum#2>\serialnumber\global\@anotherslidetrue\@localanotherslidetrue\fi%
  \ifnum#1>\serialnumber\else\ifnum#2<\serialnumber\else\gdef\dowhat{\doit}\fi\fi%
  \@decode}
\def\@decodeone#1,{%
  \ifnum#1>\serialnumber\global\@anotherslidetrue\@localanotherslidetrue\fi%
  \ifnum#1=\serialnumber\gdef\dowhat{\doit}\fi%
  \@decode}
                                

\long\def\gobble{\@gobble}
\long\def\gobbleoptional{\@ifnextchar[{\@gobbleoptional}{\@gobbleoptional[]}}
\long\def\@gobbleoptional[#1]#2{}

\long\def\@insp#1{\ignorespaces#1\ignorespaces}
\long\def\@gobbleis#1{\ignorespaces}

\long\def\makeinvisible#1{\pgfsys@begininvisible#1\pgfsys@endinvisible}
\long\def\fakeinvisible#1{\pgfsys@begininvisible\pgfsys@endinvisible#1\pgfsys@begininvisible\pgfsys@endinvisible}



%
% Overlay commands
%

\newoverlaycommand{\pgfonly}{\@insp}{\@gobbleis}
\newoverlaycommand{\only}{}{\gobble}
\newoverlaycommand{\uncover}{\fakeinvisible}{\makeinvisible}
\renewoverlaycommand{\textbf}{\original{\textbf}}{}
\renewoverlaycommand{\textit}{\original{\textit}}{}
\renewoverlaycommand{\textsl}{\original{\textsl}}{}
\renewoverlaycommand{\textsf}{\original{\textsf}}{}
\renewoverlaycommand{\textrm}{\original{\textrm}}{}
\renewoverlaycommand{\color}{\original{\color}}{\gobbleoptional}
\newoverlayenvironment{uncoverenv}{}{}{\pgfsys@begininvisible}{\pgfsys@endinvisible}
\newoverlayenvironment{onlyenv}{}{}{\begingroup\setbox0=\hbox\bgroup}{\egroup\endgroup}
\renewoverlaycommand{\hypertarget}{\original{\hypertarget}}{\gobble}

\newoverlaycommand{\emph}{\@emph}{}
\def\@emph#1{{\itshape#1}}



%
% Alerting
%

\newoverlaycommand{\alert}{\@alert}{}
\def\@alert#1{\def\insertalert{#1}\@alerttemplate}

\newoverlaycommand{\structure}{\@structure}{}
\def\@structure#1{\def\insertstructure{#1}\@structuretemplate}

\long\def\usealerttemplate#1{%
  \def\@alerttemplate{#1}}
\long\def\usestructuretemplate#1{%
  \def\@structuretemplate{#1}}

\usealerttemplate{{\color{red}\insertalert}}
\usestructuretemplate{{\color{structure}\insertstructure}}


% Insert area

\newenvironment{overlayarea}[2]{%
  \beamer@finalheight=#2\relax%
  \advance\beamer@finalheight by-\baselineskip%
  \setbox\beamer@areabox=\hbox\bgroup%
  \begin{minipage}[t]{#1}%
  }
  {
  \end{minipage}%
  \egroup%
  \ht\beamer@areabox=0pt%
  \dp\beamer@areabox=\beamer@finalheight%
  \box\beamer@areabox%
}

\def\overprint{\@ifnextchar[{\@overprint}{\@overprint[\textwidth]}}
\def\@overprint[#1]{%
  \beamer@animht=0pt%
  \beamer@animdp=0pt%
  \beamer@animwd=#1\relax%
  \setbox\beamer@animcurrent=\box\beamer@animshowbox% makes animshowbox empty
  \setbox\beamer@animcurrent=\hbox{}%
  \def\@endaction{}%
}
\def\endoverprint{%
  \@endaction%
  \ifvoid\beamer@animshowbox\setbox\beamer@animshowbox=\hbox{}\fi%
  \ht\beamer@animshowbox=\beamer@animht%
  \dp\beamer@animshowbox=\beamer@animdp%
  \wd\beamer@animshowbox=\beamer@animwd%
  \box\beamer@animshowbox%
}

\def\onslide<#1>{%
  \@endaction%
  \alt<#1>{%
    \ifvoid\beamer@animshowbox\else\ClassError{beamer}{Overprints may not overlap}{}\fi%
    \def\@endaction{%
    \end{minipage}%
    \egroup%
      \ifdim\beamer@animht<\ht\beamer@animcurrent\beamer@animht=\ht\beamer@animcurrent\fi%
      \ifdim\beamer@animdp<\dp\beamer@animcurrent\beamer@animdp=\dp\beamer@animcurrent\fi%
      \setbox\beamer@animshowbox=\copy\beamer@animcurrent}
  }%
  {\def\@endaction{%
    \end{minipage}%
    \egroup%
      \ifdim\beamer@animht<\ht\beamer@animcurrent\beamer@animht=\ht\beamer@animcurrent\fi%
      \ifdim\beamer@animdp<\dp\beamer@animcurrent\beamer@animdp=\dp\beamer@animcurrent\fi}%
  }%
  \setbox\beamer@animcurrent=\vbox\bgroup\begin{minipage}[t]{\beamer@animwd}%
}


%
%
% Setting the left and right margin
%
%
\beamer@leftmargin=1cm
\beamer@rightmargin=1cm

\def\beamersetleftmargin#1{%
  \beamer@leftmargin=#1\relax%
  % Reset left margin now
  \beamer@tempdim=\beamer@leftmargin%
  \advance\beamer@tempdim by\beamer@leftsidebar%
  \geometry{left=\the\beamer@tempdim}%
  }
\def\beamersetrightmargin#1{%
  \beamer@rightmargin=#1\relax%
  % Reset right margin now
  \beamer@tempdim=\beamer@rightmargin%
  \advance\beamer@tempdim by\beamer@rightsidebar%
  \geometry{right=\the\beamer@tempdim}%
  }


%
%
% Sidebars
%
%

\def\useleftsidebartemplate#1#2{% #1 = size, #2 = text
  \beamer@leftsidebar=#1\relax%
  % Reset left margin now
  \beamer@tempdim=\beamer@leftmargin%
  \advance\beamer@tempdim by\beamer@leftsidebar%
  \geometry{left=\the\beamer@tempdim}%
  \def\beamer@leftsidebartemplate{%
    \vbox to \sidebarheight{%
      #2\vfil%
    }%
  }}
\useleftsidebartemplate{0cm}{}
  
\def\userightsidebartemplate#1#2{% #1 = size, #2 = text
  \beamer@rightsidebar=#1\relax%
  % Reset right margin now
  \beamer@tempdim=\beamer@rightmargin%
  \advance\beamer@tempdim by\beamer@rightsidebar%
  \geometry{right=\the\beamer@tempdim}%
  \def\beamer@rightsidebartemplate{%
    \vbox to \sidebarheight{%
      #2\vfil%
    }%
  }}
\userightsidebartemplate{0cm}{}
  
\def\useleftsidebarbackgroundtemplate#1{
  \def\beamer@leftsidebarbackground{%
    \vbox to \sidebarheight{%
      #1\vfil%
    }}}
\useleftsidebarbackgroundtemplate{}

% Sets the background of the side bar to a monotone color
% Usage: usesidebarcolortemplate{\color{red}}
\def\useleftsidebarcolortemplate#1{
  \useleftsidebarbackgroundtemplate{#1\vrule height\paperheight width\beamer@leftsidebar}}

% Sets the background of the side bar to a vertical shading ranging
% between the parameter colors, given as rgb triples.
% Example: usesidebarverticalshadingtemplate{\theshadedthemecolor}{1,1,1}
\def\useleftsidebarverticalshadingtemplate#1#2{%
  \pgfdeclareverticalshading{beamer@leftsidebar}{\beamer@leftsidebar}{rgb(0cm)=(#1); rgb(\paperheight)=(#2)}%
  \useleftsidebarbackgroundtemplate{\pgfuseshading{beamer@leftsidebar}}}

% Sets the background of the side bar to a horizontal shading ranging
% between the parameter colors, given as rgb triples.
% Example: \usesidebarhorizontalshadingtemplate{\theshadedthemecolor}{1,1,1}
\def\useleftsidebarhorizontalshadingtemplate#1#2{%
  \pgfdeclarehorizontalshading{beamer@leftsidebar}{\textheight}{rgb(0cm)=(#1); rgb(\beamer@leftsidebar)=(#2)}%
  \useleftsidebarbackgroundtemplate{\pgfuseshading{beamer@leftsidebar}}}


\def\userightsidebarbackgroundtemplate#1{
  \def\beamer@rightsidebarbackground{%
    \vbox to \sidebarheight{%
      #1\vfil%
    }}}
\userightsidebarbackgroundtemplate{}

% Sets the background of the side bar to a monotone color
% Usage: usesidebarcolortemplate{\color{red}}
\def\userightsidebarcolortemplate#1{
  \userightsidebarbackgroundtemplate{#1\vrule height\paperheight width\beamer@rightsidebar}}

% Sets the background of the side bar to a vertical shading ranging
% between the parameter colors, given as rgb triples.
% Example: usesidebarverticalshadingtemplate{\theshadedthemecolor}{1,1,1}
\def\userightsidebarverticalshadingtemplate#1#2{%
  \pgfdeclareverticalshading{beamer@rightsidebar}{\beamer@rightsidebar}{rgb(0cm)=(#1); rgb(\paperheight)=(#2)}%
  \userightsidebarbackgroundtemplate{\pgfuseshading{beamer@rightsidebar}}}

% Sets the background of the side bar to a horizontal shading ranging
% between the parameter colors, given as rgb triples.
% Example: \usesidebarhorizontalshadingtemplate{\theshadedthemecolor}{1,1,1}
\def\userightsidebarhorizontalshadingtemplate#1#2{%
  \pgfdeclarehorizontalshading{beamer@rightsidebar}{\textheight}{rgb(0cm)=(#1); rgb(\beamer@rightsidebar)=(#2)}%
  \userightsidebarbackgroundtemplate{\pgfuseshading{beamer@rightsidebar}}}


%
%
% Head Navigation Format
%
%

\let\@mkboth\@gobbletwo
\def\ps@navigation{
  \def\@oddhead{\setbox\tempbox=\hbox{\@backgroundtemplate\hyper@pagetransition\hyper@pageduration}%
    \tempheight=\ht\tempbox%
    \setbox\tempbox=\hbox{\lower\tempheight\hbox{\box\tempbox}}\wd\tempbox=0pt\ht\tempbox=0pt\dp\tempbox=0pt%
    \vbox{\hbox{\hskip-\Gm@lmargin\box\tempbox}%
      \hbox{%
        {%
          \setbox\tempbox=\hbox{\hskip-\Gm@lmargin%
            {\setbox\tempbox=\hbox{\beamer@leftsidebarbackground}%
              \wd\tempbox=0pt\ht\tempbox=0pt\dp\tempbox=0pt%
              \box\tempbox}%
            \beamer@leftsidebartemplate}%
          \tempheight=\ht\tempbox%
          \setbox\tempbox=\hbox{{\lower\tempheight\hbox{\box\tempbox}}}%
          \wd\tempbox=0pt\ht\tempbox=0pt\dp\tempbox=0pt%
          \box\tempbox%
        }%        
        {% print right sidebar first, since it should be overwritten by headline
          \setbox\tempbox=\hbox{\hskip\textwidth\hskip\beamer@rightmargin%
            {\setbox\tempbox=\hbox{\beamer@rightsidebarbackground}%
              \wd\tempbox=0pt\ht\tempbox=0pt\dp\tempbox=0pt%
              \box\tempbox}%
            \beamer@rightsidebartemplate}%
          \tempheight=\ht\tempbox%
          \setbox\tempbox=\hbox{{\lower\tempheight\hbox{\box\tempbox}}}%
          \wd\tempbox=0pt\ht\tempbox=0pt\dp\tempbox=0pt%
          \box\tempbox%
        }%
        \@headtemplate\hfil%
        }\hfil}}
  \def\@oddfoot{\@foottemplate\hypertarget{Navigation\thepage}{}\hfil}
  \let\@evenhead\@oddhead
  \let\@evenfoot\@oddfoot}
\pagestyle{navigation}

%
% Patch empty page style, so that transitions and navigation still works
%
\def\ps@empty{%
  \let\@mkboth\@gobbletwo%
  \def\@oddhead{\setbox\tempbox=\hbox{\@backgroundtemplate\hyper@pagetransition\hyper@pageduration}%
    \tempheight=\ht\tempbox%
    \setbox\tempbox=\hbox{\lower\tempheight\hbox{\box\tempbox}}\wd\tempbox=0pt\ht\tempbox=0pt\dp\tempbox=0pt%
    \vbox{\hbox{\hskip-\Gm@lmargin\raise\headheight\box\tempbox}\hfil}}
  \def\@oddfoot{\hypertarget{Navigation\thepage}{}\hfil}
  \let\@evenhead\@oddhead\let\@evenfoot\@oddfoot}

\long\def\usebackgroundtemplate#1{%
  \def\@backgroundtemplate{#1}}

\def\recalculatefoot{%
  \setbox\tempbox=\hbox{\@foottemplate}%
  \footheight=\ht\tempbox%
  \advance\footheight by \dp\tempbox%
  \advance\footheight by 4pt%
  \geometry{foot=\the\footheight}%
  \sidebarheight=\paperheight%
  \advance\sidebarheight by-\headheight%
  \advance\sidebarheight by-\footheight%
  \advance\footheight by -4pt}
\def\recalculatehead{%
  \setbox\tempbox=\hbox{\@headtemplate}%
  \headheight=\ht\tempbox%
  \advance\headheight by\dp\tempbox%
  \geometry{head=\the\headheight}%
  \sidebarheight=\paperheight%
  \advance\sidebarheight by-\headheight%
  \advance\sidebarheight by-\footheight%
  \advance\footheight by -4pt}%

\long\def\usefoottemplate#1{%
  \def\@foottemplate{\offinterlineskip\reset@font\def\\{,}#1}%
  \recalculatefoot}
\def\insertpagenumber{\thepage}

\long\def\useheadtemplate#1{%
  \def\@headtemplate{\offinterlineskip\reset@font#1}%
  \recalculatehead} 

\def\insertvrule#1#2{%
  \hbox{\color{#2}\hskip-\Gm@lmargin\vrule width \paperwidth
    height #1\hskip-\Gm@rmargin}}

\def\insertnavigation#1{%
  \vbox{%
    \ifbeamer@inappendix%
    \def\sectionentry##1##2##3##4{}%
    \def\slideentry{\fakeslideentry}%
    \else%
    \def\appendixsectionentry##1##2##3##4{}%
    \def\appendixslideentry{\fakeslideentry}%
    \fi%
    \hbox to #1{\hskip.3cm\tiny\setbox\sectionbox=\hbox{}%
        \hskip-5pt plus-1fill\dohead%
      \box\sectionbox\hfil\hskip.3cm}%
  }}

\def\sectionentry#1#2#3#4{% section name, section title, page
  \box\sectionbox\hskip5pt plus 1fill%
  \setbox\sectionbox=
  \hbox{\def\insertsectionhead{#2}%
    \ifnum\thesection=#1%
    \hyperlink{Navigation#3}{\@sectionheadhilight}\else%
    \hyperlink{Navigation#3}{\@sectionheadnohilight}\fi}%
  \ignorespaces}

\def\appendixsectionentry#1#2#3#4{% section name, section title, page
  \box\sectionbox\hskip5pt plus 1fill%
  \setbox\sectionbox=
  \hbox{\def\insertsectionhead{#2}%
    \ifnum\thesection=#1%
    \hyperlink{Navigation#3}{\@sectionheadhilight}\else%
    \hyperlink{Navigation#3}{\@sectionheadnohilight}\fi}%
  \ignorespaces}

\long\def\usesectionheadtemplate#1#2{\def\@sectionheadhilight{#1}\def\@sectionheadnohilight{#2}}
\long\def\usesectionsidetemplate#1#2{\def\@sectionsidehilight{#1}\def\@sectionsidenohilight{#2}}

\def\insertverticalnavigation#1{%
  \vbox{%
    \def\sectionentry##1##2##3##4{%
      \def\insertsectionhead{##2}%
      \hbox{\hyperlink{Navigation##3}{%
          \ifnum\thesection=##1%
            \ifnum\thesubsection=0\relax%
              \@sectionsidehilight%
            \else%
              \@sectionsidenohilight%
            \fi%
          \else
            \@sectionsidenohilight%
          \fi}}%
      \currentsubsection=1\relax}%
    \def\slideentry##1##2##3##4##5{%
      \ifnum##2=\currentsubsection%
      \advance\currentsubsection by1%
      \def\insertsubsectionhead{##5}%
      \hbox{\beamer@link(##4){%
          \ifnum\thesection=##1%
            \ifnum\thesubsection=##2%
              \@subsectionsidehilight%
            \else%
              \@subsectionsidenohilight%
            \fi%
          \else%
            \@subsectionsidenohilight%
          \fi}}%
      \fi}%
    \let\appendixsectionentry=\sectionentry%
    \let\appendixslideentry=\slideentry%
    \ifbeamer@inappendix%
    \def\sectionentry##1##2##3##4{}%
    \def\slideentry##1##2##3##4##5{}%
    \else%
    \def\appendixsectionentry##1##2##3##4{}%
    \def\appendixslideentry##1##2##3##4##5{}%
    \fi%
    \currentsubsection=1\relax%
    \dohead%
  }}

\def\slideentry#1#2#3#4#5{%
  %section number, subsection number, slide number, first/last frame page number
  \ifnum#2>0\ifnum#3>0%
  \hbox to 0pt{%
    \postemp=-#2\vboxoffset%
    \advance\postemp by -#2\beamer@boxsize%
    \advance\postemp by -.05cm%
    \raise\postemp\hbox{%
      \postemp=#3\beamer@boxsize%
      \advance\postemp by -\beamer@boxsize%
      \advance\postemp by 1pt%
      \kern\postemp\hbox{\beamer@link(#4){%
        \ifnum\thesection=#1\ifnum\thesubsection=#2\ifnum\thesubsectionslide=#3%
        \@minislidehilight\else\@minisliderowhilight\fi\else\@minislide\fi\else\@minislide\fi%
        }}}\hskip-10cm plus 1fil
  }\fi\fi\ignorespaces}

\def\appendixslideentry#1#2#3#4#5{%
  %section number, subsection number, slide number, first/last frame page number
  \ifnum#2>0\ifnum#3>0%
  \hbox to 0pt{%
    \postemp=-#2\vboxoffset%
    \advance\postemp by -#2\beamer@boxsize%
    \advance\postemp by -.05cm%
    \raise\postemp\hbox{%
      \postemp=#3\beamer@boxsize%
      \advance\postemp by -\beamer@boxsize%
      \advance\postemp by 1pt%
      \kern\postemp\hbox{\beamer@link(#4){%
        \ifnum\thesection=#1\ifnum\thesubsection=#2\ifnum\thesubsectionslide=#3%
        \@minislidehilight\else\@minisliderowhilight\fi\else\@minislide\fi\else\@minislide\fi%
        }}}\hskip-10cm plus 1fil
  }\fi\fi\ignorespaces}

\def\fakeslideentry#1#2#3#4#5{%
  \ifnum#2>0\ifnum#3>0%
  \hbox to 0pt{\postemp=-#2\vboxoffset%
    \advance\postemp by -#2\beamer@boxsize%
    \advance\postemp by -.05cm%
    \raise\postemp\hbox{}}\fi\fi\ignorespaces}
  

\def\beamer@link(#1/#2){%
  \def\beamer@goto{{Navigation#1}}% default: first slide of frame
  \ifnum\thepage<#2%
  \ifnum\thepage<#1\else% go to last slide of frame, on all slides of
                                % the frame, except for the last one
  \def\beamer@goto{{Navigation#2}}% jump to last slide of frame
  \fi\fi%
  \expandafter\hyperlink\beamer@goto}


\long\def\useminislidetemplate#1#2#3#4#5{\def\@minislidehilight{#1}\def\@minisliderowhilight{#2}\def\@minislide{#3}
\beamer@boxsize=#4\vboxoffset=#5}

\def\insertsectionnavigation#1{%
  \hbox to #1{%
    \vbox{%
     \vskip1.5pt%
     \def\slideentry##1##2##3##4##5{}%
     \def\appendixslideentry##1##2##3##4##5{}%
     \def\appendixsectionentry##1##2##3##4##5{%
       \def\insertsectionhead{##2}%
       \setbox\tempbox=\hbox{%
         \hyperlink{Navigation##3}{\hbox to #1{%
           \hskip0.3cm\ifnum\thesection=##1%
           \@sectionheadhilight\else\@sectionheadnohilight\fi\hskip0.3cm}}}%
       \ht\tempbox=4.5pt\dp\tempbox=2pt%        
       \box\tempbox}%
     \def\sectionentry##1##2##3##4{\def\insertsectionhead{##2}%
       \setbox\tempbox=\hbox{%
         \hyperlink{Navigation##3}{\hbox to #1{%
           \hskip0.3cm\ifnum\thesection=##1%
           \@sectionheadhilight\else\@sectionheadnohilight\fi\hskip0.3cm}}}%
       \ht\tempbox=4.5pt\dp\tempbox=2pt%        
       \box\tempbox}%
     \ifbeamer@inappendix%
     \def\sectionentry##1##2##3##4{}%
     \else%
     \def\appendixsectionentry##1##2##3##4{}%
     \fi%
     \dohead\vskip1.5pt}\hfil}}

\def\insertsectionnavigationhorizontal#1#2#3{%
  \hbox to #1{%
     \def\slideentry##1##2##3##4##5{}%
     \def\appendixslideentry##1##2##3##4##5{}%
     \ifbeamer@inappendix%
     \def\sectionentry##1##2##3##4{}%
     \else%
     \def\appendixsectionentry##1##2##3##4{}%
     \fi%
     #2\hskip.3cm\tiny\setbox\sectionbox=\hbox{}%
     \hskip-5pt plus-1fill\dohead%
     \box\sectionbox\hfil\hskip.3cm%
     #3}}

\newcount\currentsubsection
\def\insertsubsectionnavigation#1{%
  \hbox to #1{%
    \vbox{%
      \vskip1.5pt%
      \currentsubsection=1%
      \def\sectionentry##1##2##3##4{}%
      \def\appendixsectionentry##1##2##3##4{}%
      \def\slideentry##1##2##3##4##5{\ifnum##1=\thesection%
        \ifnum##2=\currentsubsection%
        \advance\currentsubsection by1%
        \def\insertsubsectionhead{##5}%
        \setbox\tempbox=\hbox{\beamer@link(##4){%
          \hbox to #1{\hskip0.3cm\ifnum\thesubsection=##2%
          \@subsectionheadhilight\else\@subsectionheadnohilight\fi\hfil\hskip0.3cm}}}%
        \ht\tempbox=4.5pt\dp\tempbox=2pt%
        \box\tempbox\fi\fi}%
      \def\appendixslideentry##1##2##3##4##5{%
        \ifnum##2=\currentsubsection%
        \advance\currentsubsection by1%
        \def\insertsubsectionhead{##5}%
        \setbox\tempbox=\hbox{\beamer@link(##4){%
          \hbox to #1{\hskip0.3cm\ifnum\thesubsection=##2%
          \@subsectionheadhilight\else\@subsectionheadnohilight\fi\hfil\hskip0.3cm}}}%
        \ht\tempbox=4.5pt\dp\tempbox=2pt%
        \box\tempbox\fi}%
      \ifbeamer@inappendix%
      \def\slideentry##1##2##3##4##5{}%
      \else%
      \def\appendixslideentry##1##2##3##4##5{}%
      \fi%
      \dohead\vskip1.5pt}\hfil}}

\def\insertsubsectionnavigationhorizontal#1#2#3{%
  \hbox to #1{%
    \currentsubsection=1%
    \def\sectionentry##1##2##3##4{}%
    \def\appendixsectionentry##1##2##3##4{}%
    \def\slideentry##1##2##3##4##5{\ifnum##1=\thesection%
      \ifnum##2=\currentsubsection%
      \advance\currentsubsection by1%
      \box\sectionbox\hskip5pt plus1fill%
      \setbox\sectionbox=
      \hbox{\def\insertsubsectionhead{##5}%
        \ifnum\thesubsection=##2%
        \beamer@link(##4){\@subsectionheadhilight}\else%
        \beamer@link(##4){\@subsectionheadnohilight}\fi}%
      \fi\fi\ignorespaces}%
    \def\appendixslideentry##1##2##3##4##5{%
      \ifnum##2=\currentsubsection%
      \advance\currentsubsection by1%
      \box\sectionbox\hskip5pt plus1fill%
      \setbox\sectionbox=
      \hbox{\def\insertsubsectionhead{##5}%
        \ifnum\thesubsection=##2%
        \beamer@link(##4){\@subsectionheadhilight}\else%
        \beamer@link(##4){\@subsectionheadnohilight}\fi}%
      \fi\ignorespaces}%
    \ifbeamer@inappendix%
      \def\slideentry##1##2##3##4##5{}%
    \else%
      \def\appendixslideentry##1##2##3##4##5{}%
    \fi%
    #2\hskip.3cm\tiny\setbox\sectionbox=\hbox{}%
    \hskip-5pt plus-1fill\dohead%
    \box\sectionbox\hfil\hskip.3cm%
    #3}}

\long\def\usesubsectionheadtemplate#1#2{\def\@subsectionheadhilight{#1}\def\@subsectionheadnohilight{#2}}
\long\def\usesubsectionsidetemplate#1#2{\def\@subsectionsidehilight{#1}\def\@subsectionsidenohilight{#2}}


%
%
% Predefined Blocks
%
%

\long\def\useblocktemplate#1#2{%
  \def\@beginblocktemplate{#1}
  \def\@endblocktemplate{#2}}

\long\def\usealertblocktemplate#1#2{%
  \def\@beginalertblocktemplate{#1}
  \def\@endalertblocktemplate{#2}}

\long\def\useexampleblocktemplate#1#2{%
  \def\@beginexampleblocktemplate{#1}
  \def\@endexampleblocktemplate{#2}}

\newoverlayenvironment{block}[1]{%
  \def\insertblockname{#1}%
  \par%
  \@beginblocktemplate}{\par\@endblocktemplate}%
  {\pgfsys@begininvisible%
  \def\insertblockname{#1}%
  \par%
  \@beginblocktemplate}{\par\@endblocktemplate\pgfsys@endinvisible}

\newoverlayenvironment{alertblock}[1]{%
  \def\insertblockname{#1}%
  \par%
  \@beginalertblocktemplate}{\par\@endalertblocktemplate}%
  {\pgfsys@begininvisible%
  \def\insertblockname{#1}%
  \par%
  \@beginalertblocktemplate}{\par\@endalertblocktemplate\pgfsys@endinvisible}

\newoverlayenvironment{exampleblock}[1]{%
  \def\insertblockname{#1}%
  \par%
  \@beginexampleblocktemplate}{\par\@endexampleblocktemplate}%
  {\pgfsys@begininvisible%
  \def\insertblockname{#1}%
  \par%
  \@beginexampleblocktemplate}{\par\@endexampleblocktemplate\pgfsys@endinvisible}

\newenvironment{Problem}{\begin{block}{Problem}}{\end{block}}
\newenvironment{Loesung}{\begin{block}{L\"osung}}{\end{block}}
\newenvironment{Definition}{\begin{block}{Definition}}{\end{block}}
\newenvironment{Satz}{\begin{block}{Satz}}{\end{block}}
\newenvironment{Beweis}{\begin{block}{Beweis.}}{\end{block}}
\newenvironment{Folgerung}{\begin{block}{Folgerung}}{\end{block}}
\newenvironment{Lemma}{\begin{block}{Lemma}}{\end{block}}
\newenvironment{Fakt}{\begin{block}{Fakt}}{\end{block}}
\newenvironment{Beispiel}{\begin{exampleblock}{Beispiel}}{\end{exampleblock}}
\newenvironment{Beispiele}{\begin{exampleblock}{Beispiele}}{\end{exampleblock}}

\newenvironment{Theorem}{\begin{block}{Theorem}}{\end{block}}
\newenvironment{Proof}{\begin{block}{Proof.}}{\end{block}}
\newenvironment{Corollary}{\begin{block}{Corollary}}{\end{block}}
\newenvironment{Fact}{\begin{block}{Fact}}{\end{block}}
\newenvironment{Example}{\begin{exampleblock}{Example}}{\end{exampleblock}}
\newenvironment{Examples}{\begin{exampleblock}{Examples}}{\end{exampleblock}}

\newenvironment{definition}{\begin{block}{Definition}}{\end{block}}
\newenvironment{definitions}{\begin{block}{Definitions}}{\end{block}}
\newenvironment{theorem}{\begin{block}{Theorem}}{\end{block}}
\newenvironment{proof}{\begin{block}{Proof.}}{\end{block}}
\newenvironment{corollary}{\begin{block}{Corollary}}{\end{block}}
\newenvironment{fact}{\begin{block}{Fact}}{\end{block}}
\newenvironment{example}{\begin{exampleblock}{Example}}{\end{exampleblock}}
\newenvironment{examples}{\begin{exampleblock}{Examples}}{\end{exampleblock}}

\newcommand{\BeispielInline}[1]{{\color{darkgreen}Beispiel: \ignorespaces#1}}
\newcommand{\ExampleInline}[1]{{\color{darkgreen}Example: \ignorespaces#1}}


%
%
% Columns
%
%

\newenvironment{columns}{%
  \leavevmode%
  \hskip-\beamer@leftmargin%
  \nobreak%
  \beamer@tempdim=\textwidth%
  \advance\beamer@tempdim by\beamer@leftmargin%
  \advance\beamer@tempdim by\beamer@rightmargin%
  \hbox to\beamer@tempdim\bgroup%
  \hbox{}\hfill\ignorespaces}%
  {\egroup%
    \nobreak%
    \hskip-\beamer@rightmargin}
  
\newenvironment{columnsonlytextwidth}%
  {\leavevmode\hbox to\textwidth\bgroup\ignorespaces}
  {\unskip\egroup}

\newenvironment{column}[1]{%
  \begin{minipage}[c]{#1}%
    \raggedright}
  {\end{minipage}\hfill\ignorespaces}


%
%
% Footnotes
%
%

\def\@makefntext#1{%
  \def\insertfootnotetext{#1}%
  \def\insertfootnotemark{\@makefnmark}%
  \footnotetemplate}
\def\usefootnotetemplate#1{%
  \def\footnotetemplate{#1}}

\usefootnotetemplate{
  \parindent 1em\noindent%
  \hbox to 1.8em{\hfil\insertfootnotemark}\insertfootnotetext}



%
%
% Table of Contents Format
%
%

\newif\if@onlycurrent

\newcommand\tableofcontents{%
  \@onlycurrentfalse%
  \vspace*{-.5em}{\makeatletter%
    \ifbeamer@inappendix
    \def\sectionintoc##1##2##3{}%
    \def\subsectionintoc##1##2##3##4{}%
    \else%
    \def\appendixtoc##1##2##3{}%
    \def\appendixsubsectionintoc##1##2##3##4{}%
    \fi%
    \@input{\jobname.toc}\vfill}%
  \color{black}
}

\newcommand\tableofcontentscurrent{%
  \@onlycurrenttrue%
  \vspace*{-.5em}{\makeatletter%
    \ifbeamer@inappendix
    \def\sectionintoc##1##2##3{}%
    \def\subsectionintoc##1##2##3##4{}%
    \else%
    \def\appendixtoc##1##2##3{}%
    \def\appendixsubsectionintoc##1##2##3##4{}%
    \fi%
    \@input{\jobname.toc}\vfill}%
  \color{black}
}

\def\sectionintoc#1#2#3{%
    \def\inserttocsection{\hyperlink{Navigation#3}{#2}}%
    \ifsubsectionshide
    \vskip1.5em
    \else
    \vfill
    \fi
    \if@onlycurrent%
      \ifnum\thesection=#1%
        \hbox{\vbox{\sectiontemplate}}%
      \else%
        \hbox{\vbox{\sectiontemplateshaded}}%
      \fi%
    \else%
      \hbox{\vbox{\sectiontemplate}}%
    \fi
    \par}

\def\appendixtoc#1#2#3{%
  \def\inserttocsection{\hyperlink{Navigation#3}{#2}}%
  \vfill
  \hbox{\vbox{\sectiontemplate}}%
  \par%
}

\long\def\usetemplatetocsection#1#2{
  \def\sectiontemplate{\def\@breakhere{\\}#1}
  \def\sectiontemplateshaded{\def\@breakhere{\\}#2}}

\long\def\subsectionintoc#1#2#3#4{%
    \def\inserttocsubsection{\hyperlink{Navigation#4}{#3}}%
    \ifsubsectionshide
      \ifnum\thesection=#1
        {\@subsectiontemplate}
      \fi
    \else
      \if@onlycurrent
        \ifnum\thesection=#1
          {\@subsectiontemplate}
        \else
          {\@subsectiontemplateshaded}
        \fi
      \else
        \ifsubsectionsshaded
          {\@subsectiontemplateshaded}
        \else
          {\@subsectiontemplate}
        \fi
      \fi
    \fi%
}

\long\def\appendixsubsectionintoc#1#2#3#4{%
  \def\inserttocsubsection{\hyperlink{Navigation#4}{#3}}%
  {\@subsectiontemplate}
}

\long\def\usetemplatetocsubsection#1#2{
  \def\@subsectiontemplate{\def\@breakhere{\\}#1}
  \def\@subsectiontemplateshaded{\def\@breakhere{\\}#2}}

  
\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\DeclareRobustCommand*\cal{\@fontswitch\relax\mathcal}
\DeclareRobustCommand*\mit{\@fontswitch\relax\mathnormal}

\newcommand\contentsname{Contents}
\newcommand\listfigurename{List of Figures}
\newcommand\listtablename{List of Tables}
\newcommand\bibname{Bibliography}
\newcommand\indexname{Index}
\newcommand\figurename{Figure}
\newcommand\algorithmname{Algorithm}
\newcommand\tablename{Table}
\newcommand\partname{Part}
\newcommand\chaptername{Chapter}
\newcommand\appendixname{Appendix}
\newcommand\abstractname{Abstract}
\newcommand\today{}
\edef\today{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space\number\day, \number\year}
\setlength\columnsep{10\p@}
\setlength\columnseprule{0\p@}
\pagenumbering{arabic}
\onecolumn
\clubpenalty=2000
\widowpenalty=900
\originalbaselineskip=\baselineskip

\def\enumerate{%
  \ifnum\@enumdepth>1\relax\@toodeep\else
    \advance\@enumdepth\@ne
    \edef\@enumctr{enum\romannumeral\the\@enumdepth}%
    \csname\@enumctr starttemplate\endcsname%
      \expandafter
      \list
        \csname label\@enumctr\endcsname
        {\usecounter\@enumctr%
          \def\makelabel##1{{\hss\llap{##1}}}}%
  \fi}
\def\endenumerate{\endlist\csname\@enumctr endtemplate\endcsname}

\def\itemize{%
  \ifnum \@itemdepth >1\relax\@toodeep\else
    \advance\@itemdepth\@ne
    \edef\@itemitem{labelitem\romannumeral\the\@itemdepth}%
    \edef\@itemctr{item\romannumeral\the\@itemdepth}%
    \csname\@itemctr starttemplate\endcsname%
    \expandafter
    \list
      \csname\@itemitem\endcsname
      {\def\makelabel##1{{\hss\llap{##1}}}}
      \fi}
\def\enditemize{\endlist\csname\@itemctr endtemplate\endcsname}

\def\useenumerateitemtemplate#1{% 
  \def\labelenumi{\def\insertenumlabel{\theenumi}#1}}

\def\useenumeratetemplate#1#2{% before and after
  \def\enumistarttemplate{#1}%
  \def\enumiendtemplate{#2}}

\def\usesubenumerateitemtemplate#1{%
  \def\labelenumii{\def\insertenumlabel{\theenumi}\def\insertsubenumlabel{\theenumii}#1}}

\def\usesubenumeratetemplate#1#2{% before and after
  \def\enumiistarttemplate{#1}%
  \def\enumiiendtemplate{#2}}


\def\useitemizeitemtemplate#1{%
  \def\labelitemi{#1}}%itemilabeltemplate{#1}}

\def\useitemizetemplate#1#2{% before and after
  \def\itemistarttemplate{#1}%
  \def\itemiendtemplate{#2}}

\def\usesubitemizeitemtemplate#1{%
  \def\labelitemii{#1}}%itemiilabeltemplate{#1}}

\def\usesubitemizetemplate#1#2{% before and after
  \def\itemiistarttemplate{#1}%
  \def\itemiiendtemplate{#2}}


\def\description{\@ifnextchar[{\@description}{\@descdefault\@descdefaulttemp\@@description}}
\def\@description[#1]{\setbox\tempbox=\hbox{\def\insertdescriptionitem{#1}\descriptionitemtemplate}%
  \@descdefault\wd\tempbox\advance\@descdefault by \labelsep\@@description}
\def\@@description{\list{}{\labelwidth\@descdefault\leftmargin\@descdefault\let\makelabel\@descriptionitem}}
\def\enddescription{\endlist}
\long\def\@descriptionitem#1{\def\insertdescriptionitem{#1}%
  \hfil\hspace\labelsep\normalfont\descriptionitemtemplate}

\def\usedescriptionitemtemplate#1#2{\def\descriptionitemtemplate{#1}\@descdefaulttemp=#2%
  \advance\@descdefaulttemp by \labelsep}
\usedescriptionitemtemplate{\color{structure}\insertdescriptionitem}{2cm}



\parindent0pt

\AtEndDocument{%
  \clearpage
    \if@filesw
      \newwrite\tf@head
      \immediate\openout\tf@head\jobname.head\relax
      \newwrite\tf@toc
      \immediate\openout\tf@toc\jobname.toc\relax
    \fi
}


\raggedright

\def\tinyline#1{%
  \setbox\linebox=\hbox to\textwidth{\hskip-\Gm@lmargin\hskip0.3cm\tiny{#1}\hskip-\Gm@rmargin\hskip0.3cm}%
  \ht\linebox=5.5pt%
  \dp\linebox=0pt%
  \box\linebox%
  \vskip3pt}
\def\tinycolouredline#1#2{%
  \hbox{%
    \setbox\linebox=\hbox to\textwidth{\hskip-\Gm@lmargin\hskip0.3cm\tiny{#2}\hskip-\Gm@rmargin\hskip0.3cm}%
    \ht\linebox=7pt%
    \dp\linebox=0pt%
    \setbox\linebox=\vbox{\box\linebox\vskip3pt}%
    {\color{#1}\hskip-\Gm@lmargin\vrule width\paperwidth
      height\ht\linebox\hskip-\paperwidth\hskip\Gm@lmargin}%
    \box\linebox}%
  }
\def\colouredline#1#2{%
  \hbox{%
    \setbox\linebox=\hbox to\textwidth{\hskip-\Gm@lmargin\hskip0.3cm{#2}\hskip-\Gm@rmargin\hskip0.3cm}%
    \setbox\linebox=\vbox{\vskip2pt\box\linebox\vskip2pt}%
    {\color{#1}\hskip-\Gm@lmargin\vrule width\paperwidth
      height\ht\linebox\hskip-\paperwidth\hskip\Gm@lmargin}%
    \box\linebox}%
  }
\def\beamerline#1{%
  \hbox{\hskip-\Gm@lmargin#1\hskip-\Gm@rmargin}}


%
% Bibliography code
%

\setlength\bibindent{1.5em}
\newenvironment{thebibliography}[1]
{%\leavevmode\unskip%
  \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabeltemplate{\@biblabel{#1}}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \itemsep=0pt%
            \partopsep=0pt%
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}
            \let\makelabel\@biblabeltemplate}%
      \sloppy
      \clubpenalty10000
      \@clubpenalty \clubpenalty
      \widowpenalty10000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}

\long\def\@biblabeltemplate#1{\def\insertbiblabel{#1}\biblabeltemplate\hfil}

\let\@oldlbibitem\@lbibitem
\def\@lbibitem[#1]#2{\@oldlbibitem[#1]{#2}\def\newblock{\@newblock}\newblock\hbox{}}
\let\@oldbibitem\@bibitem
\def\@bibitem#1{\@oldbibitem{#1}\def\newblock{\@newblock}\newblock}

\def\@newblock{\firstblocktemplate%
  \def\newblock{\secondblocktemplate%
    \def\newblock{\thirdblocktemplate%
      \def\newblock{\otherblocktemplate}}}%
  \setbox\tempbox=\hbox{\ }\hskip-\wd\tempbox\setbox\tempbox=\hbox{}\ht\tempbox=1.5em\box\tempbox}

\long\def\usebibitemtemplate#1{%
  \def\biblabeltemplate{#1}}

\long\def\usebibliographyblocktemplate#1#2#3#4{%
  \def\firstblocktemplate{#1}%
  \def\secondblocktemplate{#2}%
  \def\thirdblocktemplate{#3}%
  \def\otherblocktemplate{#4}}

\pgfdeclareimage{beamericonarticle}{11pt}{14pt}{beamericonarticle}
\usebibitemtemplate{\lower3pt\hbox{\hskip1.5pt\pgfuseimage{beamericonarticle}}}
\usebibliographyblocktemplate
  {\color{structure}}
  {\par\color{black}}
  {\par\color{structuremedium}}
  {\par\color{structuremedium}}


%
% Transitions - DISTRACTING and to be used with CARE!!!! 
%

\newoverlaycommand{\transblindshorizontal}{\hypersetup{pdfpagetransition={Blinds /Dm /H}}}{}
\newoverlaycommand{\transblindsvertical}{\hypersetup{pdfpagetransition={Blinds /Dm /V}}}{}
\newoverlaycommand{\transboxin}{\hypersetup{pdfpagetransition={Box /M /I}}}{}
\newoverlaycommand{\transboxout}{\hypersetup{pdfpagetransition={Box /M /O}}}{}
\newoverlaycommand{\transdissolve}{\hypersetup{pdfpagetransition={Dissolve}}}{}
\newoverlaycommand{\transglitter}{\@transglitter}{\gobble}
\newoverlaycommand{\transsplitverticalin}{\hypersetup{pdfpagetransition={Split /Dm /V /M /I}}}{}
\newoverlaycommand{\transsplitverticalout}{\hypersetup{pdfpagetransition={Split /Dm /V /M /O}}}{}
\newoverlaycommand{\transsplithorizontalin}{\hypersetup{pdfpagetransition={Split /Dm /H /M /I}}}{}
\newoverlaycommand{\transsplithorizontalout}{\hypersetup{pdfpagetransition={Split /Dm /H /M /O}}}{}
\newoverlaycommand{\transwipe}{\@transwipe}{\gobble}

\def\@transglitter#1{\hypersetup{pdfpagetransition={Glitter /Di #1}}}
\def\@transwipe#1{\hypersetup{pdfpagetransition={Wipe /Di #1}}}

  
  

%
% Notes
%

\long\def\note#1{%
  \if@notes
  {
  \def\@oddhead{}
  \def\@oddfoot{}
  \let\@evenhead\@oddhead
  \let\@evenfoot\@oddfoot
  \def\@backgroundtemplate{}
  \vbox{%
    \vskip-\headheight%
    \insertvrule{8em}{lightgray}
    \vskip-8.5em
    \hbox{\vbox{
    \begin{pgfpicture}{0cm}{0cm}{0cm}{0cm}
      \begin{pgfrotateby}{\pgfdegree{90}}
        \pgfputat{\pgfpoint{-2cm}{0.25cm}}{\pgfbox[base,left]{\footnotesize\the\year-\ifnum\month<10\relax0\fi\the\month-\ifnum\day<10\relax0\fi\the\day}}
      \end{pgfrotateby}
    \end{pgfpicture}}}
    \hbox{\vbox{\begin{minipage}[t]{8cm}\insertshorttitle\end{minipage}}}%
    \setbox\tempbox=\hbox{\insertsection}%
    \hbox{\ifdim\wd\tempbox>1pt{\hskip4pt\raise3pt\hbox{\vrule width0.4pt height9pt\vrule width 9pt height0.4pt}}\hskip1pt\hbox{\vbox{\begin{minipage}[t]{8cm}\insertsection\end{minipage}}}\fi}%
    \setbox\tempbox=\hbox{\insertsubsection}%
    \hbox{\ifdim\wd\tempbox>1pt{\hskip17.4pt\raise3pt\hbox{\vrule width0.4pt height9pt\vrule width 9pt height0.4pt}}\hskip1pt\hbox{\vbox{\begin{minipage}[t]{8cm}\insertsubsection\end{minipage}}}\fi}%
    \setbox\tempbox=\hbox{\insertframetitle}%
    \hbox{\ifdim\wd\tempbox>1pt{\hskip30.8pt\raise3pt\hbox{\vrule width0.4pt height9pt\vrule width 9pt height0.4pt}}\hskip1pt\hbox{\vbox{\begin{minipage}[t]{8cm}\insertframetitle\end{minipage}}}\fi}%
    }
  \vskip2.5em
  #1%
  \clearpage
  }\fi}

\long\def\noteitems#1{\note{\begin{itemize}#1\end{itemize}}}




%
%
% Default Theme
%
%

  
                                % Title page  
\usetitlepagetemplate{
  \vbox{}
  \vfill
  \begin{centering}
    \Large\structure{\inserttitle}
    \vskip1em\par
    \normalsize\insertauthor\vskip1em\par
    {\scriptsize\insertinstitute\par}\par\vskip1em
    \insertdate\par\vskip1.5em
    \inserttitlegraphic
  \end{centering}
  \vfill
  }

                                % Frametitles
\useframetitletemplate{%
  \begin{centering}
    \structure{\textbf{\insertframetitle}}
    \par
  \end{centering}
}

                                % Sections in headline
\usesectionheadtemplate
{\color{structure}\tiny\insertsectionhead}
{\color{structureshaded}\tiny\insertsectionhead}

\usesubsectionheadtemplate
{\color{structure}\tiny\insertsubsectionhead}
{\color{structureshaded}\tiny\insertsubsectionhead}

                                % Mini slides in headline
\def\sphereradius{0.05cm}
\useminislidetemplate
{%
  \begin{pgfpicture}{0pt}{0pt}{0.1cm}{0.1cm}
    \color{structure}
    \pgfcircle[fillstroke]{\pgfpoint{\sphereradius}{\sphereradius}}{\sphereradius}%
  \end{pgfpicture}%
  }  
{%
  \begin{pgfpicture}{0pt}{0pt}{0.1cm}{0.1cm}
    \color{structure}
    \pgfcircle[stroke]{\pgfpoint{\sphereradius}{\sphereradius}}{\sphereradius}%
  \end{pgfpicture}%
  }
{%
  \begin{pgfpicture}{0pt}{0pt}{0.1cm}{0.1cm}
    \color{structureshaded}
    \pgfcircle[stroke]{\pgfpoint{\sphereradius}{\sphereradius}}{\sphereradius}%
  \end{pgfpicture}%
  }
{.14cm}{.03cm}

                                % Entries in table of contents
\usetemplatetocsection
{\color{structure}\inserttocsection}
{\color{structureshaded}\inserttocsection}

                                % Entries in table of contents
\usetemplatetocsubsection
{\leavevmode\leftskip=1.5em\color{black}\inserttocsubsection\par}
{\leavevmode\leftskip=1.5em\color{shaded}\inserttocsubsection\par}

                                % Head
\useheadtemplate{%
  \vbox{%
  \vskip3pt%
  \beamerline{\insertnavigation{\paperwidth}}%
  \vskip1.5pt%
  \insertvrule{0.4pt}{structureshaded}}%
}

                                % Footline
\usefoottemplate{}

                                % Background
\usebackgroundtemplate{}

                                % Blocks
\useblocktemplate{\medskip{\color{blockstructure}\textbf{\insertblockname}}\par}{\medskip}
\usealertblocktemplate{\medskip{\alert{\textbf{\insertblockname}}}\par}{\medskip}
\useexampleblocktemplate{\medskip\begingroup\color{darkgreen}{\textbf{\insertblockname}}\par}{\endgroup\medskip}

                                % Enumerations
\useenumerateitemtemplate{\color{structure}\insertenumlabel.}
\usesubenumerateitemtemplate{\color{structure}\insertenumlabel.\insertsubenumlabel}
\useenumeratetemplate{}{}
\usesubenumeratetemplate{\begin{small}}{\end{small}}

                                % Itemize
\useitemizeitemtemplate{\scriptsize\raise1.25pt\hbox{\color{structure}$\blacktriangleright$}}
\usesubitemizeitemtemplate{\tiny\raise1.5pt\hbox{\color{structure}$\blacktriangleright$}}
\useitemizetemplate{}{}
\usesubitemizetemplate{\begin{small}}{\end{small}}



