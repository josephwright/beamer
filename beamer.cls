\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{beamer}
[2003/11/20 v1.03 Class for Typesetting a Beamer Presentation]

% Copyright 2003 by Till Tantau <tantau@users.sourceforge.net>.
%
% This program can be redistributed and/or modified under the terms
% of the LaTeX Project Public License Distributed from CTAN
% archives in directory macros/latex/base/lppl.txt.

%
% Presentation/article stuff
%
% Copyright notice: Part of the following code is taken from the
% package comment.sty by Victor Eijkhout
%


%
% Comment stuff. This will also be needed, if we switch to another
% class, so define it here already.
%
\newif\ifbeamer@inpresentation
\beamer@inpresentationtrue

\def\beamer@makeinnocent#1{\catcode`#1=12 }
\def\beamer@startcomment{%
    \begingroup%
    \let\do\beamer@makeinnocent\dospecials%
    \beamer@makeinnocent\^^L% and whatever other special cases
    \endlinechar`\^^M \catcode`\^^M=12 \beamer@ignore}

{\catcode`\^^M=12\endlinechar=-1%
 \gdef\beamer@ignore#1^^M{%
    \expandafter\beamer@processline}
 \gdef\beamer@processline#1^^M{%
   \def\beamer@test{#1}%
    \ifx\beamer@test\beamer@stoparticle%
      \let\next=\article%
    \else%
      \ifx\beamer@test\beamer@stoppresentation%
        \let\next=\presentation%
      \else%
        \ifx\beamer@test\beamer@stopcommon%
          \let\next=\common%
        \else%
          \ifx\beamer@test\beamer@stopdocument%
            \let\next=\beamer@enddocument%
          \else
            \ifx\beamer@test\beamer@begindocument%
              \let\next=\beamer@startdocument%
            \else
              \let\next=\beamer@processline%
          \fi%  
          \fi%  
        \fi%
      \fi%
    \fi%
    \next}
}
\def\article{\beamer@closer%
  \ifbeamer@inpresentation%
    \let\next=\beamer@startcomment%
    \gdef\beamer@closer{\endgroup}%
  \else%
    \let\next=\relax%
    \gdef\beamer@closer{}%
  \fi%
  \next}  

\def\presentation{\beamer@closer%
  \ifbeamer@inpresentation%
    \let\next=\relax%
    \gdef\beamer@closer{}%
  \else%
    \let\next=\beamer@startcomment%
    \gdef\beamer@closer{\endgroup}%
  \fi%
  \next}
\def\common{\beamer@closer\gdef\beamer@closer{}}
\def\beamer@enddocument{\beamer@closer\end{document}}
\def\beamer@startdocument{\beamer@closer\begin{document}\def\beamer@closer{}}
\def\beamer@closer{}
{\escapechar=-1\relax%
  \xdef\beamer@stoparticle{\string\\article}
  \xdef\beamer@stoppresentation{\string\\presentation}
  \xdef\beamer@stopcommon{\string\\common}
  \xdef\beamer@stopdocument{\string\\end\string\{document\string\}}
  \xdef\beamer@begindocument{\string\\begin\string\{document\string\}}
}
\newbox\beamer@commentbox
\def\beamer@startcommentinframe{%
  \begingroup%
  \edef\beamer@closer{\egroup\beamer@closer}%
  \setbox\beamer@commentbox=\vbox\bgroup\leavevmode}




%
% Stuff needed in both article and presentation version
%
\def\jobnamebeamerversion{}%

\def\includeslide{\@ifnextchar[{\@includeslide}{\@includeslide[]}}
\def\@includeslide[#1]#2{%
  \ifx\jobnamebeamerversion\@empty%
  \ClassError{beamer}{Invoke macro "setjobnamebeamerversion" first}{}%
  \else%
  \pgfimage[#1,page=\csname beamer@slide#2\endcsname]{\jobnamebeamerversion}
  \fi}

\def\setjobnamebeamerversion#1{%
  \def\jobnamebeamerversion{#1}%
  {\makeatletter
  \@input{\jobnamebeamerversion.snm}}
}



%
% Check whether we should initiate transfer to another class
%

% Extract class name, if present
\def\beamer@classname{}
\def\beamer@classoptions{}
\def\beamer@classnamename{class}
\def\beamer@eq{=,}
\def\beamer@findclassname#1=#2,#3!{
  \def\beamer@temp{#1}
  \ifx\beamer@temp\beamer@classnamename
    \def\beamer@classname{#2}
    \beamer@stripsign#3!
  \fi}
\def\beamer@stripsign#1!{%
  \def\beamer@temp{#1}
  \ifx\beamer@temp\beamer@eq
  % nothing to do
  \else
  \beamer@@stripsign#1!
  \fi
}
\def\beamer@@stripsign#1,=,!{
  \def\beamer@classoptions{#1}
  }

\def\beamer@transfer{%
  % Prepare...
  \def\beamer@slide##1##2{\expandafter\gdef\csname
    beamer@slide##1\endcsname{##2}}

  \beamer@inpresentationfalse
  \edef\beamer@classwhat{[\beamer@classoptions]{\beamer@classname}}
  \expandafter\LoadClass\beamer@classwhat
  \endinput
  }

\expandafter\beamer@findclassname\@classoptionslist,=,!
\ifx\beamer@classname\@empty
  \let\next=\relax
\else
  % Need to transfer to another class soon
  \let\next=\beamer@transfer
\fi
\next




%
%
% Basic packages
%
%

\RequirePackage{pgf}
% For all sorts of things...

\RequirePackage{xxcolor}
% For color management.

\RequirePackage{amssymb}
% For \blacktriangleright

\RequirePackage{keyval}
% For \tableofcontents parameters

\RequirePackage{beamertemplates}
% For default templates


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
% Make the effect of pdfpagetransition and duration global, not local
%
\define@key{Hyp}{pdfpagetransition}{\gdef\@pdfpagetransition{#1}}
\define@key{Hyp}{pdfpageduration}{\gdef\@pdfpageduration{#1}}

%
%
% Fix for babel (will have an effect only, if babel is loaded)
%
%
\def\textlatin{}


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

\newif\ifbeamer@compress
\beamer@compressfalse

\newif\ifbeamer@centered

\newif\ifbeamer@draftmode
\beamer@draftmodefalse

\newif\ifbeamer@compressnotes
\beamer@compressnotesfalse

%
%
% Document options
%
%

\DeclareOption{inrow}
{\ClassError{beamer}{``inrow'' no longer supported. Use ``compress'' instead.}{}}

\DeclareOption{compress}
{\beamer@compresstrue}

\DeclareOption{compressnotes}
{\beamer@compressnotestrue}

\DeclareOption{slidescentered}
{\beamer@centeredtrue}

\DeclareOption{slidestop}
{\beamer@centeredfalse}

\DeclareOption{blue}
{\definecolor{structure}{rgb}{0.2,0.2,0.7}}

\DeclareOption{red}
{\definecolor{structure}{rgb}{0.7,0.2,0.2}}

\DeclareOption{gray}
{\definecolor{structure}{rgb}{0.2,0.2,0.2}}

\DeclareOption{brown}
{\definecolor{structure}{rgb}{0.66,0.4,0.166}}

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

\DeclareOption{pdftex}{}% Used by hyperref
\DeclareOption{nativepdf}{}% Used by hyperref
\DeclareOption{pdfmark}{}% Used by hyperref
\DeclareOption{dvips}{}% Used by hyperref
\DeclareOption{dviwindo}{}% Used by hyperref
\DeclareOption{dvipsone}{}% Used by hyperref
\DeclareOption{vtex}{}% Used by hyperref
\DeclareOption{ps2pdf}{}% Used by hyperref

\def\beamer@size{{size11.clo}}
\DeclareOption{bigger}{\def\beamer@size{{size12.clo}}}
\DeclareOption{smaller}{\def\beamer@size{{size10.clo}}}

\DeclareOption{draft}{\beamer@draftmodetrue}
\AtBeginDocument{
  \ifbeamer@draftmode
  \gdef\@foottemplate{%
    \color{black!25}%
    \kern-\Gm@lmargin\vrule width\paperwidth
    height\footheight\kern-\Gm@rmargin}
  \gdef\@headtemplate{%
    \color{black!25}%
    \kern-\Gm@lmargin\vrule width\paperwidth
    height\headheight\kern-\Gm@rmargin}
  \gdef\beamer@leftsidebartemplate{%
    \color{black!20}%
    \vrule width \beamer@leftsidebar height\sidebarheight}
  \gdef\beamer@rightsidebartemplate{%
    \color{black!20}%
    \vrule width \beamer@rightsidebar height\sidebarheight}
  \gdef\beamer@leftsidebarbackground{}
  \gdef\beamer@rightsidebarbackground{}
  \fi
  }
\def\insertpagenumber{\thepage}

\def\beamer@activecjk{}

\DeclareOption{CJK}{\ExecuteOptions{cjk}}
\DeclareOption{cjk}{
  \hypersetup{CJKbookmarks=true}

  \def\beamer@activecjk{
    % Activate all >128 characters. 
    \count@=127
    \@whilenum\count@<255 \do{%
      \advance\count@ by 1
      \lccode`\~=\count@
      \catcode\count@=\active
      \lowercase{\def~{\kern1ex}}
    }
  }  
}
  
%
%
% Process Options
%
%
\ExecuteOptions{blue,sans,slidescentered}

\ProcessOptions
  
\expandafter\input\beamer@size
\geometry{headsep=0pt}

%
%
% Declarations used by beamer
%
%

% Public
\newdimen\headheight    % Total height of the headline (including depth)
\newdimen\headdp        % Depth of the headline
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
\newcount\beamer@tempcount


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
\let\suspendedAcrobatmenu\Acrobatmenu
\def\hyperlink#1#2{#2}
\def\Acrobatmenu#1#2{#2}
\providecommand\hyper@pagetransition{}
\providecommand\hyper@pageduration{}
\providecommand\hyper@pagehidden{}

\AtBeginDocument{%
\if@notesnormals\let\hyperlink\suspendedhyperlink\let\Acrobatmenu\suspendedAcrobatmenu\fi%

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
  \AtBeginDocument{% fix spanish.ldf's meddling with < and > 
    \@ifundefined{deactivatequoting}{}{\deactivatequoting}}
  \begingroup\beamer@origdocument}

\definecolor{alert}{rgb}{1,0,0}

\AtBeginDocument{\def\es@itemize#1#2#3#4{}}% fix spanish.ldf's with \itemize 

%
%
% Empty test
%
%
\long\def\@ifempty#1{\beamer@xifempty#1@@..\@nil}
\long\def\beamer@xifempty#1#2@#3#4#5\@nil{%
  \ifx#3#4\expandafter\@firstoftwo\else\expandafter\@secondoftwo\fi}




% Calculate maximum number of sections/subsections per part
\newcount\beamer@sectioncount
\newcount\subsection@max
\newcount\section@max
\subsection@max=0\relax
\section@max=0\relax
\beamer@sectioncount=0\relax

\newcount\totalheads
\def\headcommand#1{\global\advance\totalheads by1\relax\expandafter\gdef\csname
  head\the\totalheads\endcsname{#1}}
\beamer@activecjk
\@input{\jobname.head}
\newcount\headcounter
\def\dohead{\headcounter=0\loop\ifnum\headcounter<\totalheads%
  \advance\headcounter by1\relax%
  \csname head\the\headcounter\endcsname\repeat}

\def\beamer@startpageofframe{1}
\def\beamer@endpageofframe{1}
\def\beamer@startpageofsubsection{1}
\def\beamer@endpageofsubsection{1}
\def\beamer@startpageofsection{1}
\def\beamer@endpageofsection{1}
\def\beamer@startpageofpart{1}
\def\beamer@endpageofpart{1}
\def\beamer@endpageofdocument{1}
\def\beamer@startpageofappendix{}
\def\inserttotalframenumber{1}

\def\partentry#1#2{\beamer@sectioncount=0}
\def\sectionentry#1#2#3#4#5{\advance\beamer@sectioncount by1\relax%
  \ifnum\section@max<\beamer@sectioncount\section@max=\beamer@sectioncount\fi}
\def\slideentry#1#2#3#4#5#6{\ifnum\subsection@max<#2\relax\subsection@max=#2\fi}
\def\beamer@framepages#1#2{}
\def\beamer@subsectionpages#1#2{}
\def\beamer@sectionpages#1#2{}
\def\beamer@partpages#1#2{}
\def\beamer@appendixpages#1{\gdef\beamer@startpageofappendix{#1}}
\def\beamer@documentpages#1{\gdef\beamer@endpageofdocument{#1}}
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
% The \partpage and \usepartpagetemplate command
%
%
\newcommand\partpage{{\beamer@partpagetemplate}}
\long\def\usepartpagetemplate#1{\def\beamer@partpagetemplate{#1}}

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
    \hyperlinkpresentationend{#1}%
    \else%
    \hyperlinkpresentationstart{#1}%
    \fi}
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
% Part Definitions
%
\newcounter{part}
\renewcommand\thepart{\@arabic\c@part}
\newcount\beamer@partstartpage
\beamer@partstartpage=1

\def\part{\@ifnextchar[\@part\@@part}
\long\def\@@part#1{\@part[#1]{#1}}
\long\def\@part[#1]#2{%
  \refstepcounter{part}%
  \def\@partname{#2}%
  \def\@partnameshort{#1}%
  \addtocontents{head}{\protect\headcommand{\protect\partentry{#2}{\thepart}}}%
  \xdef\partlink{{Navigation\thepage}{\noexpand\@partname}}%
  \xdef\partlinkshort{{Navigation\thepage}{\noexpand\@partnameshort}}%
  \beamer@tempcount=\c@page\advance\beamer@tempcount by -1%
  \addtocontents{head}{\protect\headcommand{\protect\beamer@partpages{\the\beamer@partstartpage}{\the\beamer@tempcount}}}%
  \addtocontents{head}{\protect\headcommand{\protect\beamer@sectionpages{\the\beamer@sectionstartpage}{\the\beamer@tempcount}}}%
  \addtocontents{head}{\protect\headcommand{\protect\beamer@subsectionpages{\the\beamer@subsectionstartpage}{\the\beamer@tempcount}}}%
  \beamer@partstartpage=\c@page%
  \beamer@sectionstartpage=\c@page%
  \beamer@subsectionstartpage=\c@page%
  \def\insertsection{}%
  \def\insertsubsection{}%
  \def\lastsubsection{}%
  \def\insertpart{\expandafter\hyperlink\partlink}%
  \def\insertshortpart{\expandafter\hyperlink\partlinkshort}}%
\def\insertpart{}
\def\insertshortpart{}

\def\insertromanpartnumber{\@Roman\c@part}
\def\insertpartnumber{\@arabic\c@part}

%
% Section Definitions
%
\def\sectionname{Section}
\newcounter{section}
\renewcommand\thesection{\@arabic\c@section}
\newcount\beamer@sectionstartpage
\beamer@sectionstartpage=1

\def\section{\@ifnextchar[\@section\@@section}
\long\def\@@section#1{\@section[#1]{#1}}
\long\def\@section[#1]#2{%
  \refstepcounter{section}%
  \@ifempty{#2}%
  {\long\def\secname{#1}}%
  {\long\def\secname{#2}\addtocontents{toc}{\protect\sectionintoc{\thesection}{#2}{\thepage}{\thepart}}}%
  \addtocontents{head}{\protect\headcommand{\protect\sectionentry{\thesection}{#1}{\thepage}{\secname}{\thepart}}}%
  {\let\\=\relax\xdef\sectionlink{{Navigation\thepage}{\noexpand\secname}}}%
  \beamer@tempcount=\c@page\advance\beamer@tempcount by -1%
  \addtocontents{head}{\protect\headcommand{\protect\beamer@sectionpages{\the\beamer@sectionstartpage}{\the\beamer@tempcount}}}%
  \addtocontents{head}{\protect\headcommand{\protect\beamer@subsectionpages{\the\beamer@subsectionstartpage}{\the\beamer@tempcount}}}%
  \beamer@sectionstartpage=\c@page%
  \beamer@subsectionstartpage=\c@page%
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

\newcount\beamer@subsectionstartpage
\beamer@subsectionstartpage=1

\def\subsection{\@ifnextchar[\@subsection\@@subsection}
\def\@@subsection#1{\@subsection[#1]{#1}}

\def\@subsection[#1]#2{%
  \refstepcounter{subsection}%
  \@ifempty{#2}{\long\def\subsecname{#1}\long\def\lastsubsection{#1}}
  {%
    \long\def\subsecname{#2}%
    \long\def\lastsubsection{#1}%
    \addtocontents{toc}{\protect\subsectionintoc{\thesection}{\thesubsection}{#2}{\thepage}{\thepart}}%
  }%
  \beamer@tempcount=\c@page\advance\beamer@tempcount by -1%
  \addtocontents{head}{\protect\headcommand{\protect\beamer@subsectionpages{\the\beamer@subsectionstartpage}{\the\beamer@tempcount}}}%
  \beamer@subsectionstartpage=\c@page%
  \edef\subsectionlink{{Navigation\thepage}{\noexpand\subsecname}}%
  \def\insertsubsection{\expandafter\hyperlink\subsectionlink}
  \Hy@writebookmark{\thesubsection}{#1}{Outline\thesection.\thesubsection.\thepage}{2}{toc}%
  \hyper@anchorstart{Outline\thesection.\thesubsection.\thepage}\hyper@anchorend}



\def\untitledsubsection{%
  \refstepcounter{subsection}%
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

\def\beamer@setuplinks{%
  {%
    \def\sectionentry##1##2##3##4##5{}%
    \def\slideentry##1##2##3##4##5##6{}%
    \dohead%
  }%
}

\newenvironment{frameslide}[1][1]{%
  {\let\@elt\@restorecounter\@overlaycounterresets}%
  \global\beamer@pausecount=1\relax%
  \serialnumber=#1\relax%
  \expandafter\@ifempty\expandafter{\beamer@framestartpage}{%
    \refstepcounter{subsectionslide}%
    \xdef\beamer@framestartpage{\thepage}% only first time
  }{\clearpage}% cleanup from previous slide
  \hypersetup{pdfpagetransition=R}%
  \hypersetup{pdfpageduration=}%
  \xdef\beamer@frameendpage{\thepage}% every time
  \beamer@setuplinks%
  \let\beamer@startcomment=\beamer@startcommentinframe%
  \beamer@entrycode\vspace*{-\baselineskip}\begin{pauses}\vfill}%
  {\beamer@exitcode\vskip0pt plus 1.5fill\end{pauses}}

\def\frametitle#1{%
  \vskip0pt plus -1fill%
  {\gdef\insertframetitle{#1}\@headrenderer}
  \vskip0.25em%
  \ifbeamer@centered
  \vfill%
  \fi
}

\long\def\useframetitletemplate#1{\def\@headrenderer{#1}}



%
% Appendix stuff
%
\def\appendix{%
  \part{\appendixname}
  \addtocontents{head}{\protect\headcommand{\protect\beamer@appendixpages{\the\c@page}}}}



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
  \expandafter\long\expandafter\def\csname #1\endcsname##1{%
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
\resetcounteronoverlays{figure}
\resetcounteronoverlays{table}

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
% Uncovering management
%
\def\beamer@spacingcover{\pgfsys@begininvisible\pgfsys@endinvisible}%for spacing reasons
\def\beamer@startcovered{%
  \gdef\beamer@do{\aftergroup\pgfsys@endinvisible\pgfsys@begininvisible}%
  \def\mixinon<##1>##2{\only<##1>{\gdef\beamer@do{\XXC@@beginmixinblock{##2}}}\ignorespaces}%
  \def\invisibleon<##1>{\only<##1>{\gdef\beamer@do{\aftergroup\pgfsys@endinvisible\pgfsys@begininvisible}}\ignorespaces}%
  \ifnum\serialnumber<\beamer@minimum%ok, at beginning
  {%
    \beamer@saveanother%
    \advance\beamer@minimum by-\serialnumber%
    \serialnumber=\beamer@minimum%
    \beamer@uncoverbeforeactions%
    \beamer@restoreanother%
  }%
  \else%
  {%
    \beamer@saveanother%
    \advance\serialnumber by-\beamer@minimum%
    \beamer@uncoverafteractions%
    \beamer@restoreanother%
  }%
  \fi%
  \begingroup\beamer@do}
\def\beamer@endcovered{\endgroup}%
\def\beamer@saveanother{\let\beamer@savedif=\if@anotherslide}
\def\beamer@restoreanother{\global\let\if@anotherslide=\beamer@savedif}

\def\beamersetuncovermixins#1#2{%
  \gdef\beamer@uncoverbeforeactions{\ignorespaces#1}%
  \gdef\beamer@uncoverafteractions{\ignorespaces#2}}

\beamersetuncovermixins{}{}



  
%
% Pausing environment
%

\newcount\beamer@pausecount%
\def\pauses{\@ifnextchar[{\@pauses}{\@@pauses}}
\def\@pauses[#1]{\global\beamer@pausecount=#1\relax%
  \@@pauses}
\def\@@pauses{%
  \alt<\beamer@pausecount->%
  {\beamer@spacingcover\def\beamer@endpause{\beamer@spacingcover}}%
  {\beamer@startcovered\def\beamer@endpause{\beamer@endcovered}}%
}
\def\endpauses{\beamer@endpause}

\def\pause{%
  \beamer@endpause%
  \global\advance\beamer@pausecount by1\relax%
  \alt<\beamer@pausecount->%
  {\beamer@spacingcover\def\beamer@endpause{\beamer@spacingcover}}%
  {\beamer@startcovered\def\beamer@endpause{\beamer@endcovered}}%
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
  \alt<#1>{\beamer@spacingcover%for spacing reasons
    \gdef\@closeitem{\beamer@spacingcover}\@origitem}%
  {\beamer@startcovered\gdef\@closeitem{\beamer@endcovered}\@origitem}%
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

\def\frame{\@ifnextchar[{\beamer@frame}{\beamer@frame[+]}}
\def\beamer@frame{\begingroup\catcode`:=12\catcode`|=12\beamer@@frame}% Hackery for french style
\def\beamer@@frame[#1]{\endgroup%
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
  \setbox\tempbox\vbox\bgroup\leavevmode\def\pause{}\afterassignment\@checknoslide\let\@next}
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
    \addtocontents{head}%
      {\protect\headcommand{%
          \protect\slideentry{\thesection}{\thesubsection}{\thesubsectionslide}%
          {\beamer@framestartpage/\beamer@frameendpage}{\lastsubsection}{\thepart}}}%
    \addtocontents{head}%
      {\protect\headcommand{% 
        \protect\beamer@framepages{\beamer@framestartpage}{\beamer@frameendpage}}}%
    \clearpage%
  }
}


\def\beamer@reseteecodes{\gdef\beamer@entrycode{}\gdef\beamer@exitcode{}}

\def\plainframe{%
  \def\beamer@entrycode{\vspace*{-\headheight}}%
  \def\beamer@exitcode{\vspace*{-\footheight}\thispagestyle{empty}}\frame}

% Sets dowhat to doif, if \serialnumber is in the specified
% interval. Example: 5-7,-3,9,11,13- would mean pages
% 1,2,3,5,6,7,9,11,13,14,15,16,... 
%
% As a side effect, \@another is called whenever the there is a number
% in the list that is larger than the current serialnumber

\def\decode{\global\beamer@minimum=10000\relax\gdef\@decodefound{+}\@@decodefind}
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

\newcount\beamer@minimum

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
\def\@decodeall+,{%
  \ifnum1<\beamer@minimum\global\beamer@minimum=1\fi%
  \ifnum1>\serialnumber%
  \global\@anotherslidetrue%
  \@localanotherslidetrue%
  \fi%
  \gdef\dowhat{\doit}\@decode}
\def\@decodeuntil-#1,{%
  \ifnum1<\beamer@minimum\global\beamer@minimum=1\fi%
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
  \ifnum#1<\beamer@minimum\global\beamer@minimum=#1\fi%
  \ifnum#1>\serialnumber\global\@anotherslidetrue\@localanotherslidetrue\fi%
  \ifnum#1>\serialnumber\else\gdef\dowhat{\doit}\fi%
  \@decode}
\def\@decodebetween#1#2,{%
  \ifnum#1<\beamer@minimum\global\beamer@minimum=#1\fi%
  \ifnum#1>\serialnumber\global\@anotherslidetrue\@localanotherslidetrue\fi%
  \ifnum#2>\serialnumber\global\@anotherslidetrue\@localanotherslidetrue\fi%
  \ifnum#1>\serialnumber\else\ifnum#2<\serialnumber\else\gdef\dowhat{\doit}\fi\fi%
  \@decode}
\def\@decodeone#1,{%
  \ifnum#1<\beamer@minimum\global\beamer@minimum=#1\fi%
  \ifnum#1>\serialnumber\global\@anotherslidetrue\@localanotherslidetrue\fi%
  \ifnum#1=\serialnumber\gdef\dowhat{\doit}\fi%
  \@decode}
                                

\long\def\@gobbleoptional{\@ifnextchar[{\@@gobbleoptional}{\@@gobbleoptional[]}}
\long\def\@@gobbleoptional[#1]#2{}

\long\def\@ignoreoptional{\@ifnextchar[{\@@ignoreoptional}{}}
\long\def\@@ignoreoptional[#1]{}

\long\def\@insp#1{\ignorespaces#1\ignorespaces}
\long\def\@gobbleis#1{\ignorespaces}

\long\def\makeinvisible#1{\beamer@startcovered#1\beamer@endcovered}
\long\def\fakeinvisible#1{\beamer@spacingcover#1\beamer@spacingcover}
\long\def\beamer@reallymakeinvisible#1{\pgfsys@begininvisible#1\pgfsys@endinvisible}

%
% Overlay commands
%

\newoverlaycommand{\pgfonly}{\@insp}{\@gobbleis}
\newoverlaycommand{\only}{}{\@gobble}
\newoverlaycommand{\uncover}{\fakeinvisible}{\makeinvisible}
\newoverlaycommand{\invisible}{\beamer@reallymakeinvisible}{\fakeinvisible}
\renewoverlaycommand{\textbf}{\original{\textbf}}{}
\renewoverlaycommand{\textit}{\original{\textit}}{}
\renewoverlaycommand{\textsl}{\original{\textsl}}{}
\renewoverlaycommand{\textsf}{\original{\textsf}}{}
\renewoverlaycommand{\textrm}{\original{\textrm}}{}
\renewoverlaycommand{\color}{\original{\color}}{\@gobbleoptional}
\newoverlayenvironment{uncoverenv}{}{}{\beamer@startcovered}{\beamer@endcovered}
\newoverlayenvironment{onlyenv}{}{}{\begingroup\setbox0=\hbox\bgroup}{\egroup\endgroup}
\renewoverlaycommand{\hypertarget}{\original{\hypertarget}}{\@gobble}

\newoverlaycommand{\emph}{\@emph}{}
\def\@emph#1{{\itshape#1}}

\newoverlaycommand{\nameslide}{\@nameslide}{\@gobble}



%
% Names slides
%

\def\@nameslide#1{%
  \addtocontents{snm}{\protect\beamer@slide{#1}{\thepage}}%
  \hypertarget{#1}{}}
\def\beamer@slide#1#2{\expandafter\def\csname beamer@hyperlink#1\endcsname{%
  \hyperlink{Navigation#2}}}


%
% Alerting
%

\newoverlaycommand{\alert}{\@alert}{}
\def\@alert#1{\def\insertalert{#1}\@alerttemplate}

\newoverlaycommand{\structure}{\@structure}{}
\def\@structure#1{\def\insertstructure{#1}\@structuretemplate}

\long\def\usealerttemplate#1{%
  \gdef\@alerttemplate{#1}}
\long\def\usestructuretemplate#1{%
  \gdef\@structuretemplate{#1}}

\usealerttemplate{{\begin{colormixin}{15!alert}\insertalert\end{colormixin}}}
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
  \gdef\beamer@leftsidebartemplate{%
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
  \gdef\beamer@rightsidebartemplate{%
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
\def\useleftsidebarcolortemplate#1{
  \useleftsidebarbackgroundtemplate{#1\vrule height\paperheight width\beamer@leftsidebar}}

% Sets the background of the side bar to a vertical shading ranging
% between the parameter colors.
\def\useleftsidebarverticalshadingtemplate#1#2{%
  \pgfdeclareverticalshading{beamer@leftsidebar}{\beamer@leftsidebar}{color(0cm)=(#1); color(\paperheight)=(#2)}%
  \useleftsidebarbackgroundtemplate{\pgfuseshading{beamer@leftsidebar}}}

% Sets the background of the side bar to a horizontal shading ranging
% between the parameter colors.
\def\useleftsidebarhorizontalshadingtemplate#1#2{%
  \pgfdeclarehorizontalshading{beamer@leftsidebar}{\textheight}{color(0cm)=(#1); color(\beamer@leftsidebar)=(#2)}%
  \useleftsidebarbackgroundtemplate{\pgfuseshading{beamer@leftsidebar}}}


\def\userightsidebarbackgroundtemplate#1{
  \gdef\beamer@rightsidebarbackground{%
    \vbox to \sidebarheight{%
      #1\vfil%
    }}}
\userightsidebarbackgroundtemplate{}

% Sets the background of the side bar to a monotone color
% Usage: usesidebarcolortemplate{\color{red}}
\def\userightsidebarcolortemplate#1{
  \userightsidebarbackgroundtemplate{#1\vrule height\paperheight width\beamer@rightsidebar}}

% Sets the background of the side bar to a vertical shading ranging
% between the parameter colors.
\def\userightsidebarverticalshadingtemplate#1#2{%
  \pgfdeclareverticalshading{beamer@rightsidebar}{\beamer@rightsidebar}{color(0cm)=(#1); color(\paperheight)=(#2)}%
  \userightsidebarbackgroundtemplate{\pgfuseshading{beamer@rightsidebar}}}

% Sets the background of the side bar to a horizontal shading ranging
% between the parameter colors.
\def\userightsidebarhorizontalshadingtemplate#1#2{%
  \pgfdeclarehorizontalshading{beamer@rightsidebar}{\textheight}{color(0cm)=(#1); color(\beamer@rightsidebar)=(#2)}%
  \userightsidebarbackgroundtemplate{\pgfuseshading{beamer@rightsidebar}}}




%
%
% Background management
%
%
\long\def\usebackgroundtemplate#1{%
  \gdef\@backgroundtemplate{#1}}

\def\beamersetaveragebackground#1{%
  \colorlet{averagebackgroundcolor}{#1}}

\beamersetaveragebackground{white}




%
%
% Head Navigation Format
%
%

\let\@mkboth\@gobbletwo
\def\ps@navigation{
  \def\@oddhead{%
    \setbox\tempbox=\hbox{\@backgroundtemplate\hyper@pagetransition\hyper@pageduration}%
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
      }%
      \hfil}}
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

\def\recalculatefoot{%
  \beamer@activecjk%
  \setbox\tempbox=\hbox{\@foottemplate}%
  \footheight=\ht\tempbox%
  \advance\footheight by \dp\tempbox%
  \advance\footheight by 4pt%
  \geometry{foot=\the\footheight}%
  \advance\footheight by -4pt%
  \sidebarheight=\paperheight%
  \advance\sidebarheight by-\headheight%
  \advance\sidebarheight by\headdp%
  \advance\sidebarheight by-\footheight}
\def\recalculatehead{%
  \beamer@activecjk%
  \setbox\tempbox=\hbox{\@headtemplate}%
  \headheight=\ht\tempbox%
  \headdp=\dp\tempbox%
  \advance\headheight by\headdp%
  \geometry{head=\the\headheight}%
  \sidebarheight=\paperheight%
  \advance\sidebarheight by-\headheight%
  \advance\sidebarheight by\headdp%
  \advance\sidebarheight by-\footheight}%

\long\def\usefoottemplate#1{%
  \gdef\@foottemplate{\offinterlineskip\reset@font\def\\{,}#1}%
  \recalculatefoot}
\def\insertpagenumber{\thepage}

\long\def\useheadtemplate#1{%
  \gdef\@headtemplate{\offinterlineskip\reset@font#1}%
  \recalculatehead} 

\def\insertvrule#1#2{%
  \hbox{\color{#2}\hskip-\Gm@lmargin\vrule width \paperwidth
    height #1\hskip-\Gm@rmargin}}

%
% Inserting navigation bars
%

\newcount\beamer@xpos
\newcount\beamer@ypos

\def\insertnavigation#1{%
  \vbox{%
    \beamer@xpos=0\relax%
    \beamer@ypos=1\relax%
    \hbox to #1{\hskip.3cm\tiny\setbox\sectionbox=\hbox{\kern1sp}%
      \ht\sectionbox=5pt%
      \dp\sectionbox=2pt%
        \hskip-5pt plus-1fill\dohead%
      \box\sectionbox\hfil\hskip.3cm}%
  }}

\def\sectionentry#1#2#3#4#5{% section name, section title, page
  \ifnum#5=\c@part%
  \box\sectionbox\hskip5pt plus 1fill%
  \beamer@xpos=0\relax%
  \beamer@ypos=1\relax%
  \setbox\sectionbox=
  \hbox{\def\insertsectionhead{#2}%
    \ifnum\thesection=#1%
    \hyperlink{Navigation#3}{\@sectionheadhilight}\else%
    \hyperlink{Navigation#3}{\@sectionheadnohilight}\fi}%
  \ht\sectionbox=5pt%
  \dp\sectionbox=2pt%
  \fi\ignorespaces}

\def\usesectionheadtemplate#1#2{\gdef\@sectionheadhilight{#1}\gdef\@sectionheadnohilight{#2}}
\def\usesectionsidetemplate#1#2{\gdef\@sectionsidehilight{#1}\gdef\@sectionsidenohilight{#2}}


\def\insertverticalnavigation#1{%
  \vbox{%
    \def\sectionentry##1##2##3##4##5{%
      \ifnum##5=\c@part%
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
      \currentsubsection=1\relax\fi}%
    \def\slideentry##1##2##3##4##5##6{%
      \ifnum##6=\c@part%
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
      \fi\fi}%
    \currentsubsection=1\relax%
    \dohead%
  }}

\def\slideentry#1#2#3#4#5#6{%
  %section number, subsection number, slide number, first/last frame, page number, part number
  \ifnum#6=\c@part\ifnum#2>0\ifnum#3>0%
  \ifbeamer@compress%
  \advance\beamer@xpos by1\relax%
  \else
  \beamer@xpos=#3\relax%
  \beamer@ypos=#2\relax%
  \fi
  \hbox to 0pt{%
    \postemp=-\vboxoffset%
    \advance\postemp by-\beamer@boxsize%
    \multiply\postemp by\beamer@ypos%
    \advance\postemp by -.05cm%
    \raise\postemp\hbox{%
      \postemp=\beamer@boxsize%
      \multiply\postemp by\beamer@xpos%
      \advance\postemp by -\beamer@boxsize%
      \advance\postemp by 1pt%
      \kern\postemp\hbox{\beamer@link(#4){%
        \ifnum\thesection=#1\ifnum\thesubsection=#2\ifnum\thesubsectionslide=#3%
        \@minislidehilight\else\@minisliderowhilight\fi\else\@minislide\fi\else\@minislide\fi%
        }}}\hskip-10cm plus 1fil
  }\fi\fi%
  \else%
  \fakeslideentry{#1}{#2}{#3}{#4}{#5}{#6}%
  \fi\ignorespaces}

\def\fakeslideentry#1#2#3#4#5#6{%
  \ifnum#2>0\ifnum#3>0%
  \ifbeamer@compress%
  \advance\beamer@xpos by1\relax%
  \else%
  \beamer@xpos=#3\relax%
  \beamer@ypos=#2\relax%
  \fi%
  \hbox to 0pt{\postemp=-\vboxoffset%
    \advance\postemp by -\beamer@boxsize%
    \multiply\postemp by\beamer@ypos%
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


\def\useminislidetemplate#1#2#3#4#5{\gdef\@minislidehilight{#1}\gdef\@minisliderowhilight{#2}\gdef\@minislide{#3}
\beamer@boxsize=#4\vboxoffset=#5}

\def\insertsectionnavigation#1{%
  \hbox to #1{%
    \vbox{%
     \vskip1.5pt%
     \def\slideentry##1##2##3##4##5##6{}%
     \def\sectionentry##1##2##3##4##5{%
       \ifnum##5=\c@part%
       \def\insertsectionhead{##2}%
       \setbox\tempbox=\hbox{%
         \hyperlink{Navigation##3}{\hbox to #1{%
           \hskip0.3cm\ifnum\thesection=##1%
           \@sectionheadhilight\else\@sectionheadnohilight\fi\hskip0.3cm}}}%
       \ht\tempbox=4.5pt\dp\tempbox=2pt%        
       \box\tempbox\fi}%
     \dohead\vskip1.5pt}\hfil}}

\def\insertsectionnavigationhorizontal#1#2#3{%
  \hbox to #1{%
     \def\slideentry##1##2##3##4##5##6{}%
     #2\hskip.3cm\tiny\setbox\sectionbox=\hbox{}%
     \ht\sectionbox=5pt%
     \dp\sectionbox=2pt%
     \hskip-5pt plus-1fill\dohead%
     \box\sectionbox\hfil\hskip.3cm%
     #3}}

\newcount\currentsubsection
\def\insertsubsectionnavigation#1{%
  \hbox to #1{%
    \vbox{%
      \vskip1.5pt%
      \currentsubsection=1%
      \def\sectionentry##1##2##3##4##5{}%
      \def\slideentry##1##2##3##4##5##6{\ifnum##6=\c@part\ifnum##1=\thesection%
        \ifnum##2=\currentsubsection%
        \advance\currentsubsection by1%
        \def\insertsubsectionhead{##5}%
        \setbox\tempbox=\hbox{\beamer@link(##4){%
          \hbox to #1{\hskip0.3cm\ifnum\thesubsection=##2%
          \@subsectionheadhilight\else\@subsectionheadnohilight\fi\hfil\hskip0.3cm}}}%
        \ht\tempbox=4.5pt\dp\tempbox=2pt%
        \box\tempbox\fi\fi\fi}%
      \dohead\vskip1.5pt}\hfil}}

\def\insertsubsectionnavigationhorizontal#1#2#3{%
  \hbox to #1{%
    \currentsubsection=1%
    \def\sectionentry##1##2##3##4##5{}%
    \def\slideentry##1##2##3##4##5##6{\ifnum##6=\c@part\ifnum##1=\thesection%
      \ifnum##2=\currentsubsection%
      \advance\currentsubsection by1%
      \box\sectionbox\hskip5pt plus1fill%
      \setbox\sectionbox=
      \hbox{\def\insertsubsectionhead{##5}%
        \ifnum\thesubsection=##2%
        \beamer@link(##4){\@subsectionheadhilight}\else%
        \beamer@link(##4){\@subsectionheadnohilight}\fi}%
      \ht\sectionbox=5pt%
      \dp\sectionbox=2pt%
      \fi\fi\fi\ignorespaces}%
    #2\hskip.3cm\tiny\setbox\sectionbox=\hbox{}%
    \hskip-5pt plus-1fill\dohead%
    \box\sectionbox\hfil\hskip.3cm%
    #3}}

\def\usesubsectionheadtemplate#1#2{\gdef\@subsectionheadhilight{#1}\gdef\@subsectionheadnohilight{#2}}
\def\usesubsectionsidetemplate#1#2{\gdef\@subsectionsidehilight{#1}\gdef\@subsectionsidenohilight{#2}}



%
%
% Predefined Blocks
%
%

\long\def\useblocktemplate#1#2{%
  \gdef\@beginblocktemplate{#1}
  \gdef\@endblocktemplate{#2}}

\long\def\usealertblocktemplate#1#2{%
  \gdef\@beginalertblocktemplate{#1}
  \gdef\@endalertblocktemplate{#2}}

\long\def\useexampleblocktemplate#1#2{%
  \gdef\@beginexampleblocktemplate{#1}
  \gdef\@endexampleblocktemplate{#2}}

\newoverlayenvironment{block}[1]{%
  \def\insertblockname{#1}%
  \par%
  \@beginblocktemplate}{\par\@endblocktemplate}%
  {\beamer@startcovered%
  \def\insertblockname{#1}%
  \par%
  \@beginblocktemplate}{\par\@endblocktemplate\beamer@endcovered}

\newoverlayenvironment{alertblock}[1]{%
  \def\insertblockname{#1}%
  \par%
  \@beginalertblocktemplate}{\par\@endalertblocktemplate}%
  {\beamer@startcovered%
  \def\insertblockname{#1}%
  \par%
  \@beginalertblocktemplate}{\par\@endalertblocktemplate\beamer@endcovered}

\newoverlayenvironment{exampleblock}[1]{%
  \def\insertblockname{#1}%
  \par%
  \@beginexampleblocktemplate}{\par\@endexampleblocktemplate}%
  {\beamer@startcovered%
  \def\insertblockname{#1}%
  \par%
  \@beginexampleblocktemplate}{\par\@endexampleblocktemplate\beamer@endcovered}

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

\newcommand{\BeispielInline}[1]{{\color{black50!green}Beispiel: \ignorespaces#1}}
\newcommand{\ExampleInline}[1]{{\color{black!50!green}Example: \ignorespaces#1}}


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
  \gdef\footnotetemplate{#1}}

\usefootnotetemplate{
  \parindent 1em\noindent%
  \hbox to 1.8em{\hfil\insertfootnotemark}\insertfootnotetext}



%
%
% Table of Contents Format
%
%

\newif\if@onlycurrent
\newif\if@pausesections
\newif\if@pausesubsections
\newif\if@subsectionshide
\newif\if@subsectionsshaded
\newcount\beamer@showpartnumber

\define@key{beamertoc}{current}[true]{\@onlycurrenttrue}
\define@key{beamertoc}{pausesections}[true]{\@pausesectionstrue}
\define@key{beamertoc}{pausesubsections}[true]{\@pausesubsectionstrue}
\define@key{beamertoc}{hidesubsections}[true]{\@subsectionshidetrue}
\define@key{beamertoc}{shadesubsections}[true]{\@subsectionsshadedtrue}
\define@key{beamertoc}{part}{\beamer@showpartnumber=#1\relax}

\def\tableofcontents{\@ifnextchar[{\@tableofcontents}{\@tableofcontents[]}}
\def\@tableofcontents[#1]{%
  \beamer@showpartnumber=\c@part%
  \@onlycurrentfalse%
  \@pausesectionsfalse%
  \@pausesubsectionsfalse%
  \@subsectionshidefalse%
  \@subsectionsshadedfalse%
  \setkeys{beamertoc}{#1}%
  \vspace*{-.5em}{\makeatletter%
    \begin{pauses}[0]%
      \@input{\jobname.toc}%
    \end{pauses}\vfill}%
  \normalcolor
  }

\def\tableofcontentscurrent{\tableofcontents[current]}

\def\sectionintoc#1#2#3#4{%
  \ifnum#4=\beamer@showpartnumber%
  \if@pausesections\pause\fi%
    \def\inserttocsection{\hyperlink{Navigation#3}{#2}}%
    \if@subsectionshide
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
    \par\fi}

\def\usetemplatetocsection{\@ifnextchar[\@@usetemplatetocsection\@usetemplatetocsection}
\long\def\@@usetemplatetocsection[#1]#2{
  \@usetemplatetocsection{#2}{\begin{colormixin}{#1}#2\end{colormixin}}}
\long\def\@usetemplatetocsection#1#2{
  \gdef\sectiontemplate{\def\@breakhere{\\}#1}
  \gdef\sectiontemplateshaded{\def\@breakhere{\\}#2}}

\long\def\subsectionintoc#1#2#3#4#5{%
  \ifnum#5=\beamer@showpartnumber%
  \if@pausesubsections\pause\fi%
    \def\inserttocsubsection{\hyperlink{Navigation#4}{#3}}%
    \if@subsectionshide
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
        \if@subsectionsshaded
          {\@subsectiontemplateshaded}
        \else
          {\@subsectiontemplate}
        \fi
      \fi
    \fi%
  \fi%  
}

\def\usetemplatetocsubsection{\@ifnextchar[\@@usetemplatetocsubsection\@usetemplatetocsubsection}
\long\def\@@usetemplatetocsubsection[#1]#2{
  \@usetemplatetocsubsection{#2}{\begin{colormixin}{#1}#2\end{colormixin}}}
\long\def\@usetemplatetocsubsection#1#2{
  \gdef\@subsectiontemplate{\def\@breakhere{\\}#1}
  \gdef\@subsectiontemplateshaded{\def\@breakhere{\\}#2}}

  
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
  \fi%
  \begin{pauses}\raggedright}
\def\endenumerate{\end{pauses}\endlist\csname\@enumctr endtemplate\endcsname}

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
  \fi%
  \begin{pauses}\raggedright}
    
\def\enditemize{\end{pauses}\endlist\csname\@itemctr endtemplate\endcsname}

\def\useenumerateitemtemplate#1{% 
  \gdef\labelenumi{\def\insertenumlabel{\theenumi}#1}}

\def\useenumeratetemplate#1#2{% before and after
  \gdef\enumistarttemplate{#1}%
  \gdef\enumiendtemplate{#2}}

\def\usesubenumerateitemtemplate#1{%
  \gdef\labelenumii{\def\insertenumlabel{\theenumi}\def\insertsubenumlabel{\theenumii}#1}}

\def\usesubenumeratetemplate#1#2{% before and after
  \gdef\enumiistarttemplate{#1}%
  \gdef\enumiiendtemplate{#2}}


\def\useitemizeitemtemplate#1{%
  \gdef\labelitemi{#1}}%itemilabeltemplate{#1}}

\def\useitemizetemplate#1#2{% before and after
  \gdef\itemistarttemplate{#1}%
  \gdef\itemiendtemplate{#2}}

\def\usesubitemizeitemtemplate#1{%
  \gdef\labelitemii{#1}}%itemiilabeltemplate{#1}}

\def\usesubitemizetemplate#1#2{% before and after
  \gdef\itemiistarttemplate{#1}%
  \gdef\itemiiendtemplate{#2}}


\def\description{\@ifnextchar[{\@description}{\@descdefault\@descdefaulttemp\@@description}}
\def\@description[#1]{\setbox\tempbox=\hbox{\def\insertdescriptionitem{#1}\descriptionitemtemplate}%
  \@descdefault\wd\tempbox\advance\@descdefault by \labelsep\@@description}
\def\@@description{\list{}{\labelwidth\@descdefault\leftmargin\@descdefault\let\makelabel\@descriptionitem}%
  \begin{pauses}\raggedright}
\def\enddescription{\end{pauses}\endlist}
\long\def\@descriptionitem#1{\def\insertdescriptionitem{#1}%
  \hfil\hspace\labelsep\normalfont\descriptionitemtemplate}

\def\usedescriptionitemtemplate#1#2{\gdef\descriptionitemtemplate{#1}\global\@descdefaulttemp=#2%
  \global\advance\@descdefaulttemp by \labelsep}
\usedescriptionitemtemplate{\color{structure}\insertdescriptionitem}{2cm}



\parindent0pt

\AtEndDocument{%
  \clearpage
  \beamer@tempcount=\c@page\advance\beamer@tempcount by -1%
  \immediate\write\@auxout{\string\@writefile{head}%
    {\noexpand\headcommand{\noexpand\beamer@partpages{\the\beamer@partstartpage}{\the\beamer@tempcount}}}}%
  \immediate\write\@auxout{\string\@writefile{head}%
    {\noexpand\headcommand{\noexpand\beamer@subsectionpages{\the\beamer@subsectionstartpage}{\the\beamer@tempcount}}}}%
  \immediate\write\@auxout{\string\@writefile{head}%
    {\noexpand\headcommand{\noexpand\beamer@sectionpages{\the\beamer@sectionstartpage}{\the\beamer@tempcount}}}}%
  \immediate\write\@auxout{\string\@writefile{head}%
    {\noexpand\headcommand{\noexpand\beamer@documentpages{\the\beamer@tempcount}}}}
  \immediate\write\@auxout{\string\@writefile{head}%
    {\noexpand\headcommand{\noexpand\def\noexpand\inserttotalframenumber{\the\c@framenumber}}}}
    \if@filesw
      \newwrite\tf@head
      \immediate\openout\tf@head\jobname.head\relax
      \newwrite\tf@toc
      \immediate\openout\tf@toc\jobname.toc\relax
      \newwrite\tf@snm
      \immediate\openout\tf@snm\jobname.snm\relax
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
% Label hackery (for using labels in overlays)
%
\AtBeginDocument{%
  \let\beamer@origlabel\label
  \def\label{\@ifnextchar<{\beamer@label}{\beamer@label<1>}}
  \def\beamer@label<#1>#2{\alt<#1>{\beamer@origlabel{#2}}{}}

  \let\beamer@origlabel@in@display\label@in@display
  \def\label@in@display{\@ifnextchar<{\beamer@label@in@display}{\beamer@label@in@display<1>}}
  \def\beamer@label@in@display<#1>#2{\alt<#1>{\beamer@origlabel@in@display{#2}}{}}  
}


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
      \begin{pauses}%
      \sloppy\raggedright
      \clubpenalty10000
      \@clubpenalty \clubpenalty
      \widowpenalty10000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \end{pauses}\endlist}

\long\def\@biblabeltemplate#1{\def\insertbiblabel{#1}\biblabeltemplate\hfil}

\def\bibitem{\@ifnextchar<{\beamer@bibitem@store}{\gdef\beamer@bibstore{}\beamer@plainbibitem}}
\def\beamer@bibitem@store<#1>{\gdef\beamer@bibstore{<#1>}\beamer@plainbibitem}
\def\beamer@plainbibitem{\@ifnextchar[\@lbibitem\@bibitem}
\def\@lbibitem[#1]#2{\expandafter\item\beamer@bibstore[\@biblabel{#1}\hfill]%
  \@ifundefined{beamerbib@#2@\the\c@framenumber}{\if@filesw
    {\let\protect\noexpand
      \immediate
      \write\@auxout{\string\bibcite{#2}{#1}}}\fi%
    \global\@namedef{beamerbib@#2@\the\c@framenumber}{\relax}}{}%
  \def\newblock{\@newblock}\newblock\hbox{}\ignorespaces}
\def\@bibitem#1{\expandafter\item\beamer@bibstore\@ifundefined{beamerbib@#1@\the\c@framenumber}%
  {\if@filesw \immediate\write\@auxout
    {\string\bibcite{#1}{\the\value{\@listctr}}}\fi\global\@namedef{beamerbib@#1@\the\c@framenumber}{\relax}}%
  {}%
  \def\newblock{\@newblock}\newblock\ignorespaces}

\def\@newblock{\firstblocktemplate%
  \def\newblock{\secondblocktemplate%
    \def\newblock{\thirdblocktemplate%
      \def\newblock{\otherblocktemplate}}}%
  \setbox\tempbox=\hbox{\ }\hskip-\wd\tempbox\setbox\tempbox=\hbox{}\ht\tempbox=1.5em\box\tempbox}

\long\def\usebibitemtemplate#1{%
  \gdef\biblabeltemplate{#1}}

\long\def\usebibliographyblocktemplate#1#2#3#4{%
  \gdef\firstblocktemplate{#1}%
  \gdef\secondblocktemplate{#2}%
  \gdef\thirdblocktemplate{#3}%
  \gdef\otherblocktemplate{#4}}

\pgfdeclareimage[width=11pt,height=14pt]{beamericonarticle}{beamericonarticle}
\pgfdeclareimage[width=11pt,height=14pt]{beamericonarticleshaded}{beamericonarticle.20}
\pgfaliasimage{beamericonarticle!20!averagebackgroundcolor}{beamericonarticleshaded}
\pgfaliasimage{beamericonarticle!15!averagebackgroundcolor}{beamericonarticleshaded}
\pgfaliasimage{beamericonarticle!10!averagebackgroundcolor}{beamericonarticleshaded}
\pgfaliasimage{beamericonarticle!5!averagebackgroundcolor}{beamericonarticleshaded}
\pgfaliasimage{beamericonarticle!2!averagebackgroundcolor}{beamericonarticleshaded}
\usebibitemtemplate{\lower3pt\hbox{\hskip1.5pt\pgfuseimage{beamericonarticle}}}
\usebibliographyblocktemplate
  {\color{structure}}
  {\par\color{black}}
  {\par\color{structure!65}}
  {\par\color{structure!65}}


%
% Transitions - DISTRACTING and to be used with CARE!!!! 
%

\define@key{beamertrans}{direction}{\def\beamer@transdir{ /Di #1 }}
\define@key{beamertrans}{duration}{\def\beamer@dur{ /D #1 }}

\def\beamer@dotrans#1{\@ifnextchar[{\beamer@@dotrans{#1}}{\beamer@@dotrans{#1}[]}}
\def\beamer@@dotrans#1[#2]{%
  \def\beamer@transdir{}%
  \def\beamer@dur{}%
  \setkeys{beamertrans}{#2}%
  \edef\beamer@temp{{pdfpagetransition={#1 \beamer@transdir\space\beamer@dur}}}
  \expandafter\hypersetup\beamer@temp}

\newoverlaycommand{\transblindshorizontal}{\beamer@dotrans{Blinds /Dm /H}}{\@ignoreoptional}
\newoverlaycommand{\transblindsvertical}{\beamer@dotrans{Blinds /Dm /V}}{\@ignoreoptional}
\newoverlaycommand{\transboxin}{\beamer@dotrans{Box /M /I}}{\@ignoreoptional}
\newoverlaycommand{\transboxout}{\beamer@dotrans{Box /M /O}}{\@ignoreoptional}
\newoverlaycommand{\transcover}{\beamer@dotrans{Cover}}{\@ignoreoptional}
\newoverlaycommand{\transdissolve}{\beamer@dotrans{Dissolve}}{\@ignoreoptional}
\newoverlaycommand{\transfade}{\beamer@dotrans{Fade}}{\@ignoreoptional}
\newoverlaycommand{\transglitter}{\beamer@dotrans{Glitter}}{\@ignoreoptional}
\newoverlaycommand{\transpush}{\beamer@dotrans{Push}}{\@ignoreoptional}
\newoverlaycommand{\transsplitverticalin}{\beamer@dotrans{Split /Dm /V /M /I}}{\@ignoreoptional}
\newoverlaycommand{\transsplitverticalout}{\beamer@dotrans{Split /Dm /V /M /O}}{\@ignoreoptional}
\newoverlaycommand{\transsplithorizontalin}{\beamer@dotrans{Split /Dm /H /M /I}}{\@ignoreoptional}
\newoverlaycommand{\transsplithorizontalout}{\beamer@dotrans{Split /Dm /H /M /O}}{\@ignoreoptional}
\newoverlaycommand{\transuncover}{\beamer@dotrans{Uncover}}{\@ignoreoptional}
\newoverlaycommand{\transwipe}{\beamer@dotrans{Wipe}}{\@ignoreoptional}


\newoverlaycommand{\transduration}{\@transdur}{\@gobble}
\def\@transdur#1{\hypersetup{pdfpageduration=#1}}




%
% Animation macros
%

\newcount\beamer@animationtempa
\newcount\beamer@animationtempb
\def\animate<#1>{\transduration<#1| handout:0| trans:0>{0}}
\def\animatevalue<#1-#2>#3#4#5{%
  \only<#1-#2>{}% enforce these frames
  \ifnum\serialnumber<#1\relax%
    #3=#4%
  \else%
    \ifnum\serialnumber<#2\relax%
      #3=#4\relax%
      #3=-#3\relax%
      \advance#3 by#5\relax%
      \beamer@animationtempa=#2\relax%
      \advance\beamer@animationtempa by-#1%
      \ifnum\beamer@animationtempa>0%
        \divide#3 by\beamer@animationtempa%
      \fi%
      \beamer@animationtempa=\serialnumber%
      \advance\beamer@animationtempa by-#1%
      \multiply#3 by\beamer@animationtempa%
      \advance#3 by#4%
    \else
      #3=#5%
    \fi%
  \fi%  
}
  


%
% Navigation buttons
%

% The following commands are called by the .head file.
\def\beamer@framepages#1#2{%
  \ifnum\c@page<#1%
  \else%
    \ifnum\c@page>#2%
    \else%
      \gdef\beamer@startpageofframe{#1}%
      \gdef\beamer@endpageofframe{#2}%
    \fi%
  \fi%
}
\def\beamer@subsectionpages#1#2{%
  \ifnum\c@page<#1%
  \else%
    \ifnum\c@page>#2%
    \else%
      \gdef\beamer@startpageofsubsection{#1}%
      \gdef\beamer@endpageofsubsection{#2}%
    \fi%
  \fi%
}
\def\beamer@sectionpages#1#2{%
  \ifnum\c@page<#1%
  \else%
    \ifnum\c@page>#2%
    \else%
      \gdef\beamer@startpageofsection{#1}%
      \gdef\beamer@endpageofsection{#2}%
    \fi%
  \fi%
}
\def\beamer@partpages#1#2{%
  \ifnum\c@page<#1%
  \else%
    \ifnum\c@page>#2%
    \else%
      \gdef\beamer@startpageofpart{#1}%
      \gdef\beamer@endpageofpart{#2}%
    \fi%
  \fi%
}
\def\beamer@nextpage#1{%
  \beamer@tempcount=#1%
  \advance\beamer@tempcount by1\relax%
  \ifnum\beamer@tempcount>\beamer@endpageofdocument%
  \beamer@tempcount=\beamer@endpageofdocument%
  \fi}
\def\beamer@prevpage#1{%
  \beamer@tempcount=#1\relax%
  \ifnum\beamer@tempcount>1%
  \advance\beamer@tempcount by-1%
  \fi%
}

\def\hyperlinkslideprev{%
  \beamer@prevpage\c@page%
  \hyperlink{Navigation\the\beamer@tempcount}}
\def\hyperlinkslidenext{%
  \beamer@nextpage\c@page%
  \hyperlink{Navigation\the\beamer@tempcount}}
\def\hyperlinkframestart{\hyperlink{Navigation\beamer@startpageofframe}}
\def\hyperlinkframeend{\hyperlink{Navigation\beamer@endpageofframe}}
\def\hyperlinkframestartnext{%
  \beamer@nextpage\beamer@endpageofframe%
  \hyperlink{Navigation\the\beamer@tempcount}}
\def\hyperlinkframeendprev{%
  \beamer@prevpage\beamer@startpageofframe%
  \hyperlink{Navigation\the\beamer@tempcount}}

\def\hyperlinksubsectionstart{\hyperlink{Navigation\beamer@startpageofsubsection}}
\def\hyperlinksubsectionend{\hyperlink{Navigation\beamer@endpageofsubsection}}
\def\hyperlinksubsectionstartnext{%
  \beamer@nextpage\beamer@endpageofsubsection%
  \hyperlink{Navigation\the\beamer@tempcount}}
\def\hyperlinksubsectionendprev{%
  \beamer@prevpage\beamer@startpageofsubsection%
  \hyperlink{Navigation\the\beamer@tempcount}}

\def\hyperlinksectionstart{\hyperlink{Navigation\beamer@startpageofsection}}
\def\hyperlinksectionend{\hyperlink{Navigation\beamer@endpageofsection}}
\def\hyperlinksectionstartnext{%
  \beamer@nextpage\beamer@endpageofsection%
  \hyperlink{Navigation\the\beamer@tempcount}}
\def\hyperlinksectionendprev{%
  \beamer@prevpage\beamer@startpageofsection%
  \hyperlink{Navigation\the\beamer@tempcount}}

\def\hyperlinkpartstart{\hyperlink{Navigation\beamer@startpageofpart}}
\def\hyperlinkpartend{\hyperlink{Navigation\beamer@endpageofpart}}
\def\hyperlinkpartstartnext{%
  \beamer@nextpage\beamer@endpageofpart%
  \hyperlink{Navigation\the\beamer@tempcount}}
\def\hyperlinkpartendprev{%
  \beamer@prevpage\beamer@startpageofpart%
  \hyperlink{Navigation\the\beamer@tempcount}}

\def\hyperlinkpresentationstart{\hyperlink{Navigation1}}
\def\hyperlinkpresentationend{%
  \ifx\beamer@startpageofappendix\@empty%
  \beamer@tempcount=\beamer@endpageofdocument%
  \else%
  \beamer@prevpage\beamer@startpageofappendix%
  \fi%
  \hyperlink{Navigation\the\beamer@tempcount}}
\def\hyperlinkappendixstart{%
  \ifx\beamer@startpageofappendix\@empty%
  \beamer@tempcount=\beamer@endpageofdocument%
  \else%
  \beamer@tempcount=\beamer@startpageofappendix%
  \fi%
  \hyperlink{Navigation\the\beamer@tempcount}}
\def\hyperlinkappendixend{\hyperlink{Navigation\beamer@endpageofdocument}}

\def\hyperlinkdocumentstart{\hyperlink{Navigation1}}
\def\hyperlinkdocumentend{\hyperlink{Navigation\beamer@endpageofdocument}}



%
% Navigation Button Art
%

\def\beamernavigationcolorlight{structure!20!averagebackgroundcolor}
\def\beamernavigationcolorstrong{structure!40!averagebackgroundcolor}

\pgfdefobject{beamerslidenavlight}{\pgfpoint{0pt}{-1pt}}{\pgfpoint{20pt}{5pt}}
 {\pgfqmoveto{4}{0.5}
  \pgfqlineto{2}{2}
  \pgfqlineto{4}{3.5}
  \pgffill  
  \pgfqmoveto{16}{0.5}
  \pgfqlineto{18}{2}
  \pgfqlineto{16}{3.5}
  \pgffill}
\pgfdefobject{beamerslidenavstrong}{\pgfpoint{0pt}{-1pt}}{\pgfpoint{20pt}{5pt}}
{\pgfrect[stroke]{\pgfpoint{8.3pt}{0.8pt}}{\pgfpoint{3.4pt}{2.4pt}}}

\def\insertslidenavigationsymbol{%
  \begin{pgfpicture}{0pt}{-1.5pt}{20pt}{5.5pt}
    \color{\beamernavigationcolorlight}%
    \pgfuseobject{beamerslidenavlight}%
    \color{\beamernavigationcolorstrong}%
    \pgfuseobject{beamerslidenavstrong}%
  \end{pgfpicture}\kern-20pt%
  \hyperlinkslideprev{\kern6pt}%
  \Acrobatmenu{GoToPage}{\kern8pt}%
  \hyperlinkslidenext{\kern6pt}}

\pgfdefobject{beamerframenavlight}{\pgfpoint{0pt}{-1pt}}{\pgfpoint{20pt}{5pt}}
 {\pgfqmoveto{4}{0.5}
  \pgfqlineto{2}{2}
  \pgfqlineto{4}{3.5}
  \pgffill  
  \pgfqmoveto{16}{0.5}
  \pgfqlineto{18}{2}
  \pgfqlineto{16}{3.5}
  \pgffill}
\pgfdefobject{beamerframenavstrong}{\pgfpoint{0pt}{-1pt}}{\pgfpoint{20pt}{5pt}}
{\pgfrect[stroke]{\pgfpoint{7pt}{0pt}}{\pgfpoint{3.4pt}{2.4pt}}
 \pgfqmoveto{7.8}{2.4}
 \pgfqlineto{7.8}{3.2}
 \pgfqlineto{11.2}{3.2}
 \pgfqlineto{11.2}{.8}
 \pgfqlineto{10.4}{.8}
 \pgfstroke
 \pgfqmoveto{8.6}{3.2}
 \pgfqlineto{8.6}{4}
 \pgfqlineto{12}{4}
 \pgfqlineto{12}{1.6}
 \pgfqlineto{11.2}{1.6}
 \pgfstroke}

\def\insertframenavigationsymbol{%
  \begin{pgfpicture}{0pt}{-1.5pt}{20pt}{5.5pt}
    \color{\beamernavigationcolorlight}%
    \pgfuseobject{beamerframenavlight}%
    \color{\beamernavigationcolorstrong}%
    \pgfuseobject{beamerframenavstrong}%
  \end{pgfpicture}\kern-20pt%
  \hyperlinkframeendprev{\kern5pt}%
  \hyperlinkframestart{\kern5pt}%
  \hyperlinkframeend{\kern5pt}%
  \hyperlinkframestartnext{\kern5pt}}

\pgfdefobject{beamersubsectionnavlight}{\pgfpoint{0pt}{-1pt}}{\pgfpoint{20pt}{5pt}}
 {\pgfqmoveto{4}{0.5}
   \pgfqlineto{2}{2}
   \pgfqlineto{4}{3.5}
   \pgffill  
   \pgfqmoveto{16}{0.5}
   \pgfqlineto{18}{2}
   \pgfqlineto{16}{3.5}
   \pgffill 
   \pgfsetlinewidth{0.6pt}
   \pgfqmoveto{8}{4}
   \pgfqlineto{11}{4}
   \pgfstroke
   \pgfqmoveto{9}{2}
   \pgfqlineto{12}{2}
   \pgfstroke
   \pgfqmoveto{8}{1}
   \pgfqlineto{11}{1}
   \pgfstroke
   \pgfqmoveto{9}{0}
   \pgfqlineto{12}{0}
   \pgfstroke}
\pgfdefobject{beamersubsectionnavstrong}{\pgfpoint{0pt}{-1pt}}{\pgfpoint{20pt}{5pt}}
{\pgfsetlinewidth{0.6pt}
  \pgfqmoveto{9}{3}
  \pgfqlineto{12}{3}
  \pgfstroke}

\def\insertsubsectionnavigationsymbol{%
  \begin{pgfpicture}{0pt}{-1.5pt}{20pt}{5.5pt}
    \color{\beamernavigationcolorlight}%
    \pgfuseobject{beamersubsectionnavlight}%
    \color{\beamernavigationcolorstrong}%
    \pgfuseobject{beamersubsectionnavstrong}%
  \end{pgfpicture}\kern-20pt%
  \hyperlinksubsectionendprev{\kern5pt}%
  \hyperlinksubsectionstart{\kern5pt}%
  \hyperlinksubsectionend{\kern5pt}%
  \hyperlinksubsectionstartnext{\kern5pt}}

\pgfdefobject{beamersectionnavlight}{\pgfpoint{0pt}{-1pt}}{\pgfpoint{20pt}{5pt}}
 {\pgfqmoveto{4}{0.5}
   \pgfqlineto{2}{2}
   \pgfqlineto{4}{3.5}
   \pgffill  
   \pgfqmoveto{16}{0.5}
   \pgfqlineto{18}{2}
   \pgfqlineto{16}{3.5}
   \pgffill 
   \pgfsetlinewidth{0.6pt}
   \pgfqmoveto{8}{1}
   \pgfqlineto{11}{1}
   \pgfstroke
   \pgfqmoveto{9}{0}
   \pgfqlineto{12}{0}
   \pgfstroke}
\pgfdefobject{beamersectionnavstrong}{\pgfpoint{0pt}{-1pt}}{\pgfpoint{20pt}{5pt}}
{\pgfsetlinewidth{0.6pt}
  \pgfqmoveto{8}{4}
  \pgfqlineto{11}{4}
  \pgfstroke
  \pgfqmoveto{9}{3}
  \pgfqlineto{12}{3}
  \pgfstroke
  \pgfqmoveto{9}{2}
  \pgfqlineto{12}{2}
  \pgfstroke
}

\def\insertsectionnavigationsymbol{%
  \begin{pgfpicture}{0pt}{-1.5pt}{20pt}{5.5pt}
    \color{\beamernavigationcolorlight}%
    \pgfuseobject{beamersectionnavlight}%
    \color{\beamernavigationcolorstrong}%
    \pgfuseobject{beamersectionnavstrong}%
  \end{pgfpicture}\kern-20pt%
  \hyperlinksectionendprev{\kern5pt}%
  \hyperlinksectionstart{\kern5pt}%
  \hyperlinksectionend{\kern5pt}%
  \hyperlinksectionstartnext{\kern5pt}}

\ifx\beamer@startpageofappendix\@empty
% no appendix
\pgfdefobject{beamerdocnavstrong}{\pgfpoint{0pt}{-1pt}}{\pgfpoint{20pt}{5pt}}
{\pgfsetlinewidth{0.6pt}
  \pgfqmoveto{8}{4}
  \pgfqlineto{11}{4}
  \pgfstroke
  \pgfqmoveto{9}{3}
  \pgfqlineto{12}{3}
  \pgfstroke
  \pgfqmoveto{9}{2}
  \pgfqlineto{12}{2}
  \pgfstroke
  \pgfqmoveto{7}{1}
  \pgfqlineto{11}{1}
  \pgfstroke
  \pgfqmoveto{9}{0}
  \pgfqlineto{12}{0}
  \pgfstroke}

\def\insertdocnavigationsymbol{%
  \begin{pgfpicture}{0pt}{-1.5pt}{20pt}{5.5pt}
    \color{\beamernavigationcolorstrong}%
    \pgfuseobject{beamerdocnavstrong}%
  \end{pgfpicture}\kern-20pt%
  \hyperlinkpresentationstart{\kern9pt}%
  \hyperlinkpresentationend{\kern11pt}}
\else
\pgfdefobject{beamerdocnavlight}{\pgfpoint{0pt}{-1pt}}{\pgfpoint{20pt}{5pt}}
{\pgfqmoveto{10}{-.5}
  \pgfqlineto{10}{4.5}
  \pgfstroke
}  
\pgfdefobject{beamerdocnavstrong}{\pgfpoint{0pt}{-1pt}}{\pgfpoint{20pt}{5pt}}
{
  \pgfsetlinewidth{0.6pt}
  \pgfqmoveto{4}{4}
  \pgfqlineto{7}{4}
  \pgfstroke
  \pgfqmoveto{5}{3}
  \pgfqlineto{8}{3}
  \pgfstroke
  \pgfqmoveto{5}{2}
  \pgfqlineto{8}{2}
  \pgfstroke
  \pgfqmoveto{3}{1}
  \pgfqlineto{7}{1}
  \pgfstroke
  \pgfqmoveto{5}{0}
  \pgfqlineto{8}{0}
  \pgfstroke
  \pgfqmoveto{12}{3}
  \pgfqlineto{15}{3}
  \pgfstroke
  \pgfqmoveto{13}{2}
  \pgfqlineto{16}{2}
  \pgfstroke
  \pgfqmoveto{13}{1}
  \pgfqlineto{16}{1}
  \pgfstroke
}

\def\insertdocnavigationsymbol{%
  \begin{pgfpicture}{0pt}{-1.5pt}{20pt}{5.5pt}
    \color{\beamernavigationcolorlight}%
    \pgfuseobject{beamerdocnavlight}%
    \color{\beamernavigationcolorstrong}%
    \pgfuseobject{beamerdocnavstrong}%
  \end{pgfpicture}\kern-20pt%
  \hyperlinkpresentationstart{\kern5pt}%
  \hyperlinkpresentationend{\kern5pt}%
  \hyperlinkappendixstart{\kern3.5pt}%
  \hyperlinkappendixend{\kern6.5pt}}
\fi

\pgfdefobject{beamerbackfindforwardnav}{\pgfpoint{0pt}{-1pt}}{\pgfpoint{20pt}{5pt}}
{
  % search symbol
  \pgfsetlinewidth{0.6pt}
  \pgfqmoveto{10.4}{1.6}
  \pgfqlineto{12}{0}
  \pgfstroke
  \pgfsetlinewidth{0.4pt}
  \pgfcircle[stroke]{\pgfpoint{9.5pt}{2.5pt}}{1.2pt}
  % left arrow
  \pgfsetroundcap
  \pgfqmoveto{4}{0}
  \pgfqcurveto{5.1}{0}{6}{0.9}{6}{2}
  \pgfqcurveto{6}{3.1}{5.1}{4}{4}{4}
  \pgfqcurveto{2.9}{4}{2}{3.1}{2}{2}
  \pgfstroke
  \pgfqmoveto{3.2}{2.6}
  \pgfqlineto{2}{1.6}
  \pgfqlineto{0.8}{2.6}
  \pgfstroke
  % right arrow
  \pgfqmoveto{16}{0}
  \pgfqcurveto{14.9}{0}{14}{0.9}{14}{2}
  \pgfqcurveto{14}{3.1}{14.9}{4}{16}{4}
  \pgfqcurveto{17.1}{4}{18}{3.1}{18}{2}
  \pgfstroke
  \pgfqmoveto{19.2}{2.6}
  \pgfqlineto{18}{1.6}
  \pgfqlineto{16.8}{2.6}
  \pgfstroke
}  

\def\insertbackfindforwardnavigationsymbol{%
  \begin{pgfpicture}{0pt}{-1.5pt}{20pt}{5.5pt}
    \color{\beamernavigationcolorlight!50!\beamernavigationcolorstrong}%
    \pgfuseobject{beamerbackfindforwardnav}%
  \end{pgfpicture}\kern-20pt%
  \Acrobatmenu{GoBack}{\kern7pt}%
  \Acrobatmenu{Find}{\kern6pt}%
  \Acrobatmenu{GoForward}{\kern7pt}}


\def\usenavigationsymbolstemplate#1{%
  \def\insertnavigationsymbols{#1}}


%
% User Buttons
%

\pgfdefobject{beamergotosymbol}{\pgfpoint{0pt}{-1pt}}{\pgfpoint{5pt}{5pt}}
{
  \pgfqmoveto{1.5}{0.5}
  \pgfqlineto{3.5}{2}
  \pgfqlineto{1.5}{3.5}
  \pgffill
}

\def\insertgotosymbol{%
  \begin{pgfpicture}{1pt}{0pt}{6pt}{5pt}
    \pgfuseobject{beamergotosymbol}%
  \end{pgfpicture}}

\pgfdefobject{beamerskipsymbol}{\pgfpoint{0pt}{-1pt}}{\pgfpoint{7pt}{5pt}}
{
  \pgfqmoveto{1.5}{0.5}
  \pgfqlineto{3.5}{2}
  \pgfqlineto{1.5}{3.5}
  \pgfqmoveto{3.5}{0.5}
  \pgfqlineto{5.5}{2}
  \pgfqlineto{3.5}{3.5}
  \pgffill
}

\def\insertskipsymbol{%
  \begin{pgfpicture}{1pt}{0pt}{8pt}{5pt}
    \pgfuseobject{beamerskipsymbol}%
  \end{pgfpicture}}


\pgfdefobject{beamerreturnsymbol}{\pgfpoint{0pt}{-1pt}}{\pgfpoint{5pt}{5pt}}
{
  \pgfqmoveto{3.5}{0.5}
  \pgfqlineto{1.5}{2}
  \pgfqlineto{3.5}{3.5}
  \pgffill
}

\def\insertreturnsymbol{%
  \begin{pgfpicture}{1pt}{0pt}{6pt}{5pt}
    \pgfuseobject{beamerreturnsymbol}%
  \end{pgfpicture}}


\def\usebuttontemplate#1{%
  \def\beamer@buttontemplate{#1}}

\def\beamerbutton#1{%
  \def\insertbuttontext{#1}%
  \beamer@buttontemplate}
\def\beamergotobutton#1{%
  \def\insertbuttontext{\insertgotosymbol#1}%
  \beamer@buttontemplate}%
\def\beamerskipbutton#1{%
  \def\insertbuttontext{\insertskipsymbol#1}%
  \beamer@buttontemplate}%
\def\beamerreturnbutton#1{%
  \def\insertbuttontext{\insertreturnsymbol#1}%
  \beamer@buttontemplate}%




%
% Floats and tables
%

\def\figure{\@ifnextchar[{\@figure}{\@figure[]}}
\def\@figure[#1]{% ignores placement specification!
  \def\@captype{figure}%
  \begin{center}}
\def\endfigure{\end{center}}
\newcounter{figure}
\renewcommand\thefigure{\@arabic\c@figure}

\def\table{\@ifnextchar[{\@table}{\@table[]}}
\def\@table[#1]{% ignores placement specification!
  \def\@captype{table}%
  \begin{center}}
\def\endtable{\end{center}}
\newcounter{table}
\renewcommand\thetable{\@arabic\c@table}

\newlength\abovecaptionskip
\newlength\belowcaptionskip
\setlength\abovecaptionskip{7pt}
\setlength\belowcaptionskip{7pt}

\def\caption{
  \ifx\@captype\@undefined
    \@latex@error{\noexpand\caption outside figure or table}\@ehd
    \expandafter\@gobble
 \else
   \refstepcounter\@captype
   \expandafter\@firstofone
 \fi
 {\@dblarg{\@caption\@captype}}%
}
\long\def\@caption#1[#2]#3{% second argument ignored
  \par
  \begingroup
    \@parboxrestore
    \if@minipage
      \@setminipage
    \fi
    \normalsize
    \@makecaption{#1}{\ignorespaces #3}\par
    \endgroup}
\long\def\@makecaption#1#2{%
  \def\insertcaptionname{\csname#1name\endcsname}%
  \def\insertcaptionnumber{\csname the#1\endcsname}%
  \def\insertcaption{#2}%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{\beamer@captiontemplate}%
  \ifdim \wd\@tempboxa >\hsize
    \beamer@captiontemplate\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}

\long\def\usecaptiontemplate#1{%
  \gdef\beamer@captiontemplate{#1}}
\usecaptiontemplate{%
  {\small\structure{\insertcaptionname:} \insertcaption}}


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
    \ifbeamer@compressnotes
    \insertvrule{2.5em}{white!90!black}
    \vskip2.5em
    \nointerlineskip
    \tiny
    \setbox\tempbox=\hbox{\raise7em\hbox{\insertsection}}%
    \ht\tempbox=0pt
    \box\tempbox
    \nointerlineskip
    \setbox\tempbox=\hbox{\raise6em\hbox{\quad\insertsubsection}}%
    \ht\tempbox=0pt
    \box\tempbox
    \nointerlineskip
    \setbox\tempbox=\hbox{\raise5em\hbox{\quad\quad\insertframetitle}}%
    \ht\tempbox=0pt
    \box\tempbox
    \nointerlineskip
    \else    
    \insertvrule{8em}{white!90!black}
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
    \fi
    }
  \ifbeamer@compressnotes
  \vskip-2em  
  \else
  \vskip2.5em
  \fi
  \small
  #1%
  \clearpage
  }\fi}

\long\def\noteitems#1{\note{\begin{itemize}#1\end{itemize}}}



%
%
% Default Theme
%
%
 
\beamertemplatelargetitlepage
\beamertemplatelargepartpage
\beamertemplateboldcenterframetitle

                                % Sections in headline
\usesectionheadtemplate
{\color{structure}\tiny\insertsectionhead}
{\color{structure!50!averagebackgroundcolor}\tiny\insertsectionhead}

\usesubsectionheadtemplate
{\color{structure}\tiny\insertsubsectionhead}
{\color{structure!50!averagebackgroundcolor}\tiny\insertsubsectionhead}

                                % Mini slides in headline
\beamertemplatecircleminiframe

                                % Entries in table of contents
\usetemplatetocsection[50!averagebackgroundcolor]
  {\color{structure}\inserttocsection}

                                % Entries in table of contents
\usetemplatetocsubsection[50!averagebackgroundcolor]
  {\leavevmode\leftskip=1.5em\color{black}\inserttocsubsection\par}

                                % Head
\useheadtemplate{%
  \vbox{%
  \vskip3pt%
  \beamerline{\insertnavigation{\paperwidth}}%
  \vskip1.5pt%
  \insertvrule{0.4pt}{structure!50!averagebackgroundcolor}}%
}
\usefoottemplate{}
\usebackgroundtemplate{}

                                % Blocks
\useblocktemplate{\medskip{\color{structure}\textbf{\insertblockname}}\par}{\medskip}
\usealertblocktemplate{\medskip{\alert{\textbf{\insertblockname}}}\par}{\medskip}
\useexampleblocktemplate{\medskip\begingroup{\color{structure!50!green}\textbf{\insertblockname}}\par%
\color{black!50!green}}{\endgroup\medskip}

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

\beamertemplatesolidbuttons
\beamertemplatenavigationsymbolshorizontal

%%% Local Variables: 
%%% mode: latex
%%% TeX-master: doc/beamerexample.tex
%%% End: 
