\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{beamer}
[2004/01/10 v1.10-dev Class for Typesetting a Beamer Presentation]

% Copyright 2003 by Till Tantau <tantau@users.sourceforge.net>.
%
% This program can be redistributed and/or modified under the terms
% of the GNU Public License, version 2.


%
% Versioning stuff
%
\newdimen\beamer@version
\beamer@version=1.11pt % It is only fitting, that the version should
                       % be given in points...
\def\beamer@endinputifotherversion#1{%
  \let\beamer@next=\relax%
  \ifdim#1<\beamer@version%
    \let\beamer@next=\endinput%
  \else%
    \ifdim#1>\beamer@version%
      \let\beamer@next=\endinput%
    \fi%
  \fi%
  \beamer@next}


\RequirePackage{beamerbasearticle}
% Setup article mode

\beamer@transferifnecessary


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

% Private
\newdimen\beamer@tempdim
\newdimen\beamer@finalheight
\newdimen\beamer@animht
\newdimen\beamer@animdp
\newdimen\beamer@animwd
\newdimen\beamer@leftmargin
\newdimen\beamer@rightmargin
\newdimen\beamer@leftsidebar
\newdimen\beamer@rightsidebar
\newdimen\beamer@boxsize
\newdimen\beamer@vboxoffset
\newdimen\beamer@descdefault
\newdimen\beamer@descdefaulttemp

\newbox\beamer@areabox
\newbox\beamer@animcurrent
\newbox\beamer@animshowbox
\newbox\beamer@tempbox
\newbox\beamer@sectionbox
\newbox\beamer@logobox
\newbox\beamer@linebox

\newcount\beamer@tempcount
\newcount\beamer@sectioncount
\newcount\beamer@subsectionmax
\newcount\beamer@sectionmax
\newcount\beamer@totalheads
\newcount\beamer@headcounter
\newcount\beamer@partstartpage
\newcount\beamer@sectionstartpage
\newcount\beamer@subsectionstartpage
\newcount\beamer@pausecount
\newcount\beamer@animationtempa
\newcount\beamer@animationtempb
\newcount\beamer@minimum
\newcount\beamer@xpos
\newcount\beamer@ypos
\newcount\beamer@showpartnumber
\newcount\beamer@currentsubsection
\newcount\beamer@slideinframe
\newcount\beamer@coveringdepth
\newcount\beamer@sectionadjust
\newcount\beamer@tocsectionnumber

\newif\ifbeamer@sansmath
\newif\ifbeamer@altmode
\newif\ifbeamer@notes
\newif\ifbeamer@notesnormals
\newif\ifbeamer@compress
\newif\ifbeamer@centered
\newif\ifbeamer@draftmode
\newif\ifbeamer@compressnotes
\newif\ifbeamer@anotherslide
\newif\ifbeamer@localanotherslide
\newif\ifbeamer@onlycurrent
\newif\ifbeamer@pausesections
\newif\ifbeamer@pausesubsections
\newif\ifbeamer@subsectionshide
\newif\ifbeamer@subsectionsshaded




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

\RequirePackage{beamerbasetemplates}
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
  head=0.5cm,% will be changed later
  headsep=0pt,%
  foot=0.5cm% will be changed later
  ]{geometry}


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
%
% Ifs for document options
%
%
\beamer@altmodefalse
\beamer@notesfalse
\beamer@notesnormalstrue
\beamer@compressfalse
\beamer@draftmodefalse
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

\DeclareOption{blackandwhite}
{\definecolor{structure}{rgb}{0.2,0.2,0.2}}

\DeclareOption{brown}
{\definecolor{structure}{rgb}{0.66,0.4,0.166}}

\DeclareOption{leqno}{\input{leqno.clo}}
\DeclareOption{fleqn}{\input{fleqn.clo}}

\def\beamer@currentmode{default}
\DeclareOption{handout}{\gdef\beamer@currentmode{handout}}
\DeclareOption{trans}{\gdef\beamer@currentmode{trans}}

\DeclareOption{notes}{\beamer@notestrue}
\DeclareOption{notesonly}{\beamer@notestrue\beamer@notesnormalsfalse}

\DeclareOption{sans}{%
  \def\familydefault{\sfdefault}
  \def\mathfamilydefault{\sfdefault}
  \beamer@sansmathtrue
}
\DeclareOption{serif}{%
  \def\familydefault{\rmdefault}
  \def\mathfamilydefault{\rmdefault}
  \beamer@sansmathfalse
}

\DeclareOption{mathsans}{\def\mathfamilydefault{\sfdefault}\beamer@sansmathtrue}
\DeclareOption{mathserif}{\def\mathfamilydefault{\rmdefault}\beamer@sansmathfalse}

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

\DeclareOption{8pt}{\def\beamer@size{{size8.clo}}}
\DeclareOption{9pt}{\def\beamer@size{{size9.clo}}}
\DeclareOption{10pt}{\def\beamer@size{{size10.clo}}}
\DeclareOption{11pt}{\def\beamer@size{{size11.clo}}}
\DeclareOption{12pt}{\def\beamer@size{{size12.clo}}}
\DeclareOption{14pt}{\def\beamer@size{{size14.clo}}}
\DeclareOption{17pt}{\def\beamer@size{{size17.clo}}}
\DeclareOption{20pt}{\def\beamer@size{{size20.clo}}}


\DeclareOption{draft}{\beamer@draftmodetrue}
\AtBeginDocument{
  \ifbeamer@draftmode
  \gdef\beamer@foottemplate{%
    \color{black!25}%
    \kern-\Gm@lmargin\vrule width\paperwidth
    height\footheight\kern-\Gm@rmargin}
  \gdef\beamer@headtemplate{%
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



\RequirePackage{beamerbasecompatibility}
% Fixes other packages

\RequirePackage{beamerbasefont}
% Font stuff

% Setup normal font (for calculation of head sizes)
\normalfont

\RequirePackage{beamerbasetoc}
% Table of Contents Format


%
% Color stuff
%
\definecolor{alert}{rgb}{1,0,0}

%
%
% Empty test
%
%
\long\def\beamer@ifempty#1{\beamer@xifempty#1@@..\@nil}
\long\def\beamer@xifempty#1#2@#3#4#5\@nil{%
  \ifx#3#4\expandafter\@firstoftwo\else\expandafter\@secondoftwo\fi}

\addtocontents{toc}{\protect\beamer@endinputifotherversion{\the\beamer@version}}
\addtocontents{nav}{\protect\beamer@endinputifotherversion{\the\beamer@version}}

% Calculate maximum number of sections/subsections per part
\beamer@subsectionmax=0\relax
\beamer@sectionmax=0\relax
\beamer@sectioncount=0\relax

\def\headcommand#1{\global\advance\beamer@totalheads by1\relax\expandafter\gdef\csname
  head\the\beamer@totalheads\endcsname{#1}}
\beamer@activecjk
\@input{\jobname.nav}
\def\dohead{\beamer@headcounter=0\loop\ifnum\beamer@headcounter<\beamer@totalheads%
  \advance\beamer@headcounter by1\relax%
  \csname head\the\beamer@headcounter\endcsname\repeat}

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
  \ifnum\beamer@sectionmax<\beamer@sectioncount\beamer@sectionmax=\beamer@sectioncount\fi}
\def\slideentry#1#2#3#4#5#6{\ifnum\beamer@subsectionmax<#2\relax\beamer@subsectionmax=#2\fi}
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
\def\titlepage{{\beamer@titlepagetemplate}}
\long\def\usetitlepagetemplate#1{\def\beamer@titlepagetemplate{#1}}

%
%
% The \partpage and \usepartpagetemplate command
%
%
\def\partpage{{\beamer@partpagetemplate}}
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
\def\logo#1{\def\insertlogo{#1}}
\logo{}


%
% Part Definitions
%
\newcounter{part}
\renewcommand\thepart{\@arabic\c@part}
\beamer@partstartpage=1

\def\part{\@ifnextchar[\@part\@@part}
\long\def\@@part#1{\@part[#1]{#1}}
\long\def\@part[#1]#2{%
  \refstepcounter{part}%
  \def\beamer@partname{#2}%
  \def\beamer@partnameshort{#1}%
  \addtocontents{head}{\protect\headcommand{\protect\partentry{#2}{\thepart}}}%
  \xdef\partlink{{Navigation\thepage}{\noexpand\beamer@partname}}%
  \xdef\partlinkshort{{Navigation\thepage}{\noexpand\beamer@partnameshort}}%
  \beamer@tempcount=\c@page\advance\beamer@tempcount by -1%
  \addtocontents{head}{\protect\headcommand{\protect\beamer@partpages{\the\beamer@partstartpage}{\the\beamer@tempcount}}}%
  \addtocontents{head}{\protect\headcommand{\protect\beamer@sectionpages{\the\beamer@sectionstartpage}{\the\beamer@tempcount}}}%
  \addtocontents{head}{\protect\headcommand{\protect\beamer@subsectionpages{\the\beamer@subsectionstartpage}{\the\beamer@tempcount}}}%
  \beamer@partstartpage=\c@page%
  \beamer@sectionstartpage=\c@page%
  \beamer@subsectionstartpage=\c@page%
  \setcounter{subsection}{0}%
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
\beamer@sectionstartpage=1\relax
\beamer@tocsectionnumber=0\relax

\def\section{\@ifnextchar[\@section\@@section}
\long\def\@@section#1{\@section[#1]{#1}}
\long\def\@section[#1]#2{%
  \refstepcounter{section}%
  \beamer@ifempty{#2}%
  {\long\def\secname{#1}}%
  {\advance\beamer@tocsectionnumber by 1\relax%
   \long\def\secname{#2}\addtocontents{toc}{\protect\beamer@sectionintoc{\thesection}{#2}{\thepage}{\thepart}%
      {\the\beamer@tocsectionnumber}}}%
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

\def\breakhere{\protect\beamer@breakhere}
\def\beamer@breakhere{}



%
% Subsection Definitions
%
\newcounter{subsection}[section]
\renewcommand\thesubsection{\@arabic\c@subsection}

\beamer@subsectionstartpage=1

\def\subsection{\@ifnextchar[\@subsection\@@subsection}
\def\@@subsection#1{\@subsection[#1]{#1}}

\def\@subsection[#1]#2{%
  \refstepcounter{subsection}%
  \beamer@ifempty{#2}{\long\def\subsecname{#1}\long\def\lastsubsection{#1}}
  {%
    \long\def\subsecname{#2}%
    \long\def\lastsubsection{#1}%
    \addtocontents{toc}{\protect\beamer@subsectionintoc{\thesection}{\thesubsection}{#2}{\thepage}{\thepart}{\the\beamer@tocsectionnumber}}%
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

\newenvironment{beamer@frameslide}{%
  {\let\@elt\beamer@restorecounter\beamer@overlaycounterresets}%
  \global\beamer@pausecount=1\relax%
  \expandafter\beamer@ifempty\expandafter{\beamer@framestartpage}{%
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
  \beamer@ifempty{#1}{}{%
  \vskip0pt plus -1fill%
  {\gdef\insertframetitle{#1}\beamer@headrenderer}
  \vskip0.25em%
  \ifbeamer@centered
  \vfill%
  \fi}%
}

\long\def\useframetitletemplate#1{\def\beamer@headrenderer{#1}}



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

\let\beamer@verb@egroup=\verb@egroup

\def\beamer@setb{\setbox0=\copy}
\long\def\defverb#1{%
  \expandafter\newbox\csname @verb\string#1\endcsname%
  \def#1{{\expandafter\beamer@setb\csname
      @verb\string#1\endcsname\unhbox0}}%
  \def\verb@egroup{\global\let\verb@balance@group\@empty\egroup\egroup\let\verb@egroup=\beamer@verb@egroup}
  \expandafter\setbox\csname @verb\string#1\endcsname=\hbox\bgroup
  \verb}


\long\def\defverbatim#1{%
  \expandafter\newbox\csname @verb\string#1\endcsname%
  \def#1{{\expandafter\beamer@setb\csname @verb\string#1\endcsname\unvbox0}}%
  \expandafter\setbox\csname @verb\string#1\endcsname=\vbox\bgroup
  \def\set@color{}\def\reset@color{}\let\@next=}

\def\beamer@parsebr#1{\@ifnextchar<{\beamer@@parsebr#1}{#1}}
\def\beamer@@parsebr#1{\begingroup\catcode`:=12\catcode`|=12\beamer@parseinner{#1}}%
\def\beamer@parseinner#1<#2>{\endgroup\edef\beamer@spec{<#2>}%
  \expandafter#1\beamer@spec}

\def\alt{\beamer@parsebr\@alt}
\long\def\@alt<#1>#2#3{%
  \def\beamer@doifnotinframe{#3}\def\beamer@doifinframe{#2}%
  {\setbox0=\hbox{\beamer@decode#1| stop:| }}\beamer@donow}

\def\temporal{\beamer@parsebr\@temporal}
\long\def\@temporal<#1>#2#3#4{% past, present, future
  \def\beamer@doifnotinframe{\beamer@picked}\def\beamer@doifinframe{#3}%
  {\setbox0=\hbox{\beamer@localanotherslidefalse\beamer@decode#1| stop:|
      \ifbeamer@localanotherslide\gdef\beamer@picked{#2}\else\gdef\beamer@picked{#4}\fi}}\beamer@donow}

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
    \@ifnextchar<{\beamer@parsebegin{#1}{#2}{#3}{#4}{#5}}{%
      \expandafter\def\csname end#1\endcsname{#3}#2}}%
  }
    
\long\def\beamer@parsebegin#1#2#3#4#5<#6>{%
  \alt<#6>{% In slide case
    \expandafter\def\csname end#1\endcsname{#3}%
    #2}{%
    \expandafter\def\csname end#1\endcsname{#5}%
    #4}}

\long\def\renewoverlayenvironment#1#2#3#4#5{%
  \edef\beamer@do{\csname original#1\endcsname=\expandafter\noexpand\csname#1\endcsname}
  \expandafter\let\beamer@do
  \edef\beamer@do{\csname endoriginal#1\endcsname=\expandafter\noexpand\csname end#1\endcsname}
  \expandafter\let\beamer@do
  \renewenvironment{#1}{}{}%
  \expandafter\def\csname #1\endcsname{%
    \@ifnextchar<{\beamer@parsebegin{#1}{#2}{#3}{#4}{#5}}{%
      \expandafter\def\csname end#1\endcsname{#3}#2}%
    }%
  }

\long\def\@@newoverlayenvironment#1[1]#2#3#4#5{% Currently, this works
% only for a single argument
  \newenvironment{#1}{}{}%
  \expandafter\new@command\csname @in#1\endcsname[1]{#2}%
  \expandafter\new@command\csname @out#1\endcsname[1]{#4}%
  \expandafter\long\expandafter\def\csname #1\endcsname##1{%
    \@ifnextchar<{\beamer@parsebegin{#1}{\csname @in#1\endcsname{##1}}{#3}{\csname @out#1\endcsname{##1}}{#5}}{%
      \expandafter\def\csname end#1\endcsname{#3}#2}}%
}


%
% Resetting counters
%  

\def\resetcounteronoverlays#1{%
  \@cons\beamer@overlaycounterresets{{c@#1}}%  
}

\def\resetcountonoverlays#1{%
  \@cons\beamer@overlaycounterresets{{#1}}%  
}

\def\beamer@overlaycounterresets{}
  
\resetcounteronoverlays{equation}
\resetcounteronoverlays{parentequation}
\resetcounteronoverlays{footnote}
\resetcounteronoverlays{mpfootnote}
\resetcounteronoverlays{figure}
\resetcounteronoverlays{table}

\def\beamer@savecounter#1{%
  \@ifundefined{#1}{}%
  {\expandafter\xdef\csname saved@#1\endcsname%
    {\expandafter\the\csname #1\endcsname}}%
}
\def\beamer@restorecounter#1{%
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
  \def\mixinon<##1>##2{\only<##1>{\gdef\beamer@do{\colormixin{##2}}}\ignorespaces}%
  \def\opaqueness<##1>##2{\only<##1>{%
      \gdef\beamer@do{%
        \advance\beamer@coveringdepth by 1\relax%
        \colorlet{beamer@freeze\the\beamer@coveringdepth}{averagebackgroundcolor}
        \edef\beamer@colorhook{!##2!beamer@freeze\the\beamer@coveringdepth\beamer@colorhook}%
        \def\beamer@pgfextension{##2opaque}\color{.}%
        }}%
      \ignorespaces}%
  \def\invisibleon<##1>{\only<##1>{\gdef\beamer@do{\aftergroup\pgfsys@endinvisible\pgfsys@begininvisible}}\ignorespaces}%
  \ifnum\beamer@slideinframe<\beamer@minimum%ok, at beginning
  {%
    \beamer@saveanother%
    \advance\beamer@minimum by-\beamer@slideinframe%
    \beamer@slideinframe=\beamer@minimum%
    \beamer@uncoverbeforeactions%
    \beamer@restoreanother%
  }%
  \else%
  {%
    \beamer@saveanother%
    \advance\beamer@slideinframe by-\beamer@minimum%
    \beamer@uncoverafteractions%
    \beamer@restoreanother%
  }%
  \fi%
  \begingroup\beamer@do}
\def\beamer@endcovered{\endgroup}%

\def\beamersetuncovermixins#1#2{%
  \gdef\beamer@uncoverbeforeactions{\ignorespaces#1}%
  \gdef\beamer@uncoverafteractions{\ignorespaces#2}}

\beamersetuncovermixins{}{}

\def\colorhook{\edef\beamer@args{{@hookcolor}{@hookcolor\colorcurrentmixin\beamer@colorhook}}\expandafter\colorlet\beamer@args}
\def\pgfalternateextension{\colorcurrentmixin\beamer@pgfextension}

\def\beamer@colorhook{}
\def\beamer@pgfextension{}

\beamer@coveringdepth=0

%
% Pausing environment
%

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

\let\beamer@origitem=\item
\def\item{%
  \beamer@closeitem\gdef\beamer@closeitem{}%
  \@ifnextchar<{\beamer@parseitem}{\beamer@origitem}}
\def\beamer@closeitem{}
\def\beamer@parseitem<#1>{%
  \alt<#1>{\beamer@spacingcover%for spacing reasons
    \gdef\beamer@closeitem{\beamer@spacingcover}\beamer@origitem}%
  {\beamer@startcovered\gdef\beamer@closeitem{\beamer@endcovered}\beamer@origitem}%
  }

\let\beamer@origendtrivlist=\endtrivlist
\def\endtrivlist{%
  \beamer@closeitem%
  \global\let\beamer@closeitem=\beamer@sci%
  \global\let\beamer@sci=\beamer@ssci%
  \global\let\beamer@ssci=\beamer@sssci\beamer@origendtrivlist}
\let\beamer@orig@trivlist=\@trivlist
\def\@trivlist{%
  \global\let\beamer@sssci=\beamer@ssci%
  \global\let\beamer@ssci=\beamer@sci\global%
  \let\beamer@sci=\beamer@closeitem%
  \gdef\beamer@closeitem{}%
  \beamer@orig@trivlist}
\def\beamer@closeitem{}



\newcounter{framenumber}
\def\insertframenumber{\@arabic\c@framenumber}

\def\frame{\@ifnextchar[{\beamer@frame}{\beamer@frame[+]}}
\def\beamer@frame{\begingroup\catcode`:=12\catcode`|=12\beamer@@frame}% Hackery for french style
\def\beamer@@frame[#1]{\endgroup%
  \refstepcounter{framenumber}%
  {\let\@elt\beamer@savecounter\beamer@overlaycounterresets}
  \gdef\insertframetitle{}%
  \gdef\beamer@framestartpage{}%
  \gdef\beamer@whichframes{#1}%
  \beamer@slideinframe=0\relax%
  \beamer@anotherslidefalse%
  {\setbox0=\hbox{\expandafter\beamer@decode\beamer@whichframes| stop:| }}%
  \ifbeamer@anotherslide%
  \beamer@slideinframe=2\relax%
  \def\beamer@doifnotinframe{}%
  \def\beamer@doifinframe{\let\howtotreatframe\doseveralframes}%
  \beamer@anotherslidefalse%
  {\setbox0=\hbox{\expandafter\beamer@decode\beamer@whichframes| stop:| }}%
  \ifbeamer@anotherslide%
  \let\howtotreatframe\doseveralframes\else%
  \let\howtotreatframe\dosingleframe%
  \fi%
  \beamer@donow%
  \else%
  \let\howtotreatframe\donoframe%
  \fi%
  \ifbeamer@notesnormals\else\let\howtotreatframe\donoframe\fi%
  \howtotreatframe}
\long\def\donoframe{%
  \beamer@slideinframe=1\relax%
  \beamer@slideinframe=1\relax%
  \setbox\beamer@tempbox\vbox\bgroup\leavevmode\def\pause{}\afterassignment\beamer@checknoslide\let\beamer@next}
\def\beamer@checknoslide{%
  \ifcat\bgroup\noexpand\beamer@next%
  \let\beamer@do\beamer@reseteecodes%
  \else\let\beamer@do\beamer@noframesingletoken\fi%
  \beamer@do}
\def\beamer@noframesingletoken{\beamer@next\egroup\beamer@reseteecodes}

\long\def\doseveralframes#1{%
  \beamer@slideinframe=1\relax%
  \loop%
  \beamer@anotherslidefalse%
  \def\beamer@doifnotinframe{}%
  \def\beamer@doifinframe{\begin{beamer@frameslide}%
    #1%
  \end{beamer@frameslide}}%
  \beamer@slideinframe=\beamer@slideinframe%
  {\setbox0=\hbox{\expandafter\beamer@decode\beamer@whichframes| stop:| }}%
  \beamer@donow%
  \ifbeamer@anotherslide
  \advance\beamer@slideinframe by 1\relax
  \repeat%
  \beamer@writeslidentry%
  \beamer@reseteecodes}

\def\dosingleframe{\begin{beamer@frameslide}\bgroup\aftergroup\beamer@endslide\afterassignment\beamer@checkslide\let\beamer@next}
\def\beamer@checkslide{%
  \ifcat\bgroup\noexpand\beamer@next%
  \let\beamer@do\relax%
  \else\let\beamer@do\beamer@singletoken\fi%
  \beamer@do}
\def\beamer@endslide{\end{beamer@frameslide}\beamer@writeslidentry\beamer@reseteecodes}
\def\beamer@singletoken{\beamer@next\egroup}

\def\beamer@writeslidentry{%
  \expandafter\beamer@ifempty\expandafter{\beamer@framestartpage}{}% nothing to do ...
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

% Sets dowhat to doif, if \beamer@slideinframe is in the specified
% interval. Example: 5-7,-3,9,11,13- would mean pages
% 1,2,3,5,6,7,9,11,13,14,15,16,... 
%
% As a side effect, \@another is called whenever the there is a number
% in the list that is larger than the current serialnumber

\def\beamer@decode{\global\beamer@minimum=10000\relax\gdef\beamer@decodefound{+}\beamer@@decodefind}
\def\beamer@@decodefind{\futurelet\beamer@next\beamer@decodeinsertdefault}
\def\beamer@decodeinsertdefault{\ifcat\beamer@next a%
  \gdef\beamer@next{}%
  \else%
  \gdef\beamer@next{default:}%
  \fi%
  \expandafter\beamer@decodefind\beamer@next}

\def\beamer@modestop{stop}
\def\beamer@modeall{all}
\def\beamer@decodefind#1:#2| {%
  \def\beamer@mode{#1}%
  \ifx\beamer@mode\beamer@modestop%
    \expandafter\beamer@@decode\beamer@decodefound,!%
    \let\beamer@next=\relax%
  \else
    \ifx\beamer@mode\beamer@currentmode%
      \gdef\beamer@decodefound{#2}%
    \else%
      \ifx\beamer@mode\beamer@modeall%
        \gdef\beamer@decodefound{#2}%
      \fi%
    \fi%
    \let\beamer@next=\beamer@@decodefind%
  \fi%
  \beamer@next}

\def\beamer@doifnotinframe{}
\def\beamer@@decode{%
  \@ifnextchar!%
  {\beamer@decodeend}%
  {%
    \@ifnextchar+%
    {\beamer@decodeall}{%
      \@ifnextchar-%
      {\beamer@decodeuntil}%
      {\beamer@decodenumber}}}}
\def\beamer@decodeend!{}
\def\beamer@decodeall+,{%
  \ifnum1<\beamer@minimum\global\beamer@minimum=1\fi%
  \ifnum1>\beamer@slideinframe%
  \global\beamer@anotherslidetrue%
  \beamer@localanotherslidetrue%
  \fi%
  \gdef\beamer@doifnotinframe{\beamer@doifinframe}\beamer@@decode}
\def\beamer@decodeuntil-#1,{%
  \ifnum1<\beamer@minimum\global\beamer@minimum=1\fi%
  \ifnum#1>\beamer@slideinframe\global\beamer@anotherslidetrue\beamer@localanotherslidetrue\fi%
  \ifnum\beamer@slideinframe>#1\else\gdef\beamer@doifnotinframe{\beamer@doifinframe}\fi%
  \beamer@@decode}
\def\beamer@decodenumber#1{%
  \@ifnextchar,%
  {\beamer@decodeone{#1}}%
  {\@ifnextchar-%
    {\beamer@decodenumberto{#1}}%
    {\beamer@decodegobble{#1}}}}
\def\beamer@decodegobble#1#2{%
  \beamer@decodenumber{#1#2}}
\def\beamer@decodenumberto#1-{
  \@ifnextchar,%
  {\beamer@decodeto{#1}}%
  {\beamer@decodebetween{#1}}}
\def\beamer@decodeto#1,{%
  \ifnum#1<\beamer@minimum\global\beamer@minimum=#1\fi%
  \ifnum#1>\beamer@slideinframe\global\beamer@anotherslidetrue\beamer@localanotherslidetrue\fi%
  \ifnum#1>\beamer@slideinframe\else\gdef\beamer@doifnotinframe{\beamer@doifinframe}\fi%
  \beamer@@decode}
\def\beamer@decodebetween#1#2,{%
  \ifnum#1<\beamer@minimum\global\beamer@minimum=#1\fi%
  \ifnum#1>\beamer@slideinframe\global\beamer@anotherslidetrue\beamer@localanotherslidetrue\fi%
  \ifnum#2>\beamer@slideinframe\global\beamer@anotherslidetrue\beamer@localanotherslidetrue\fi%
  \ifnum#1>\beamer@slideinframe\else\ifnum#2<\beamer@slideinframe\else\gdef\beamer@doifnotinframe{\beamer@doifinframe}\fi\fi%
  \beamer@@decode}
\def\beamer@decodeone#1,{%
  \ifnum#1<\beamer@minimum\global\beamer@minimum=#1\fi%
  \ifnum#1>\beamer@slideinframe\global\beamer@anotherslidetrue\beamer@localanotherslidetrue\fi%
  \ifnum#1=\beamer@slideinframe\gdef\beamer@doifnotinframe{\beamer@doifinframe}\fi%
  \beamer@@decode}

\def\beamer@donow{\beamer@doifnotinframe}

\def\beamer@saveanother{\let\beamer@savedif=\ifbeamer@anotherslide}
\def\beamer@restoreanother{\global\let\ifbeamer@anotherslide=\beamer@savedif}

\long\def\beamer@gobbleoptional{\@ifnextchar[{\beamer@@gobbleoptional}{\beamer@@gobbleoptional[]}}
\long\def\beamer@@gobbleoptional[#1]#2{}

\long\def\beamer@ignoreoptional{\@ifnextchar[{\beamer@@ignoreoptional}{}}
\long\def\beamer@@ignoreoptional[#1]{}

\long\def\beamer@insp#1{\ignorespaces#1\ignorespaces}
\long\def\beamer@gobbleis#1{\ignorespaces}

\long\def\makeinvisible#1{\beamer@startcovered#1\beamer@endcovered}
\long\def\fakeinvisible#1{\beamer@spacingcover#1\beamer@spacingcover}
\long\def\beamer@reallymakeinvisible#1{\pgfsys@begininvisible#1\pgfsys@endinvisible}

%
% Overlay commands
%

\newoverlaycommand{\pgfonly}{\beamer@insp}{\beamer@gobbleis}
\newoverlaycommand{\only}{}{\@gobble}
\newoverlaycommand{\uncover}{\fakeinvisible}{\makeinvisible}
\newoverlaycommand{\invisible}{\beamer@reallymakeinvisible}{\fakeinvisible}
\renewoverlaycommand{\textbf}{\original{\textbf}}{}
\renewoverlaycommand{\textit}{\original{\textit}}{}
\renewoverlaycommand{\textsl}{\original{\textsl}}{}
\renewoverlaycommand{\textsf}{\original{\textsf}}{}
\renewoverlaycommand{\textrm}{\original{\textrm}}{}
\renewoverlaycommand{\color}{\original{\color}}{\beamer@gobbleoptional}
\newoverlayenvironment{uncoverenv}{}{}{\beamer@startcovered}{\beamer@endcovered}
\newoverlayenvironment{onlyenv}{}{}{\begingroup\setbox0=\hbox\bgroup}{\egroup\endgroup}
\renewoverlaycommand{\hypertarget}{\original{\hypertarget}}{\@gobble}

\newoverlaycommand{\emph}{\@emph}{}
\def\@emph#1{{\itshape#1}}

\newoverlaycommand{\nameslide}{\beamer@nameslide}{\@gobble}



%
% Names slides
%

\def\beamer@nameslide#1{%
  \addtocontents{snm}{\protect\beamer@slide{#1}{\thepage}}%
  \hypertarget{#1}{}}
\def\beamer@slide#1#2{\expandafter\def\csname beamer@hyperlink#1\endcsname{%
  \hyperlink{Navigation#2}}}


%
% Alerting
%

\newoverlaycommand{\alert}{\@alert}{}
\def\@alert#1{\def\insertalert{#1}\beamer@alerttemplate}

\newoverlaycommand{\structure}{\@structure}{}
\def\@structure#1{\def\insertstructure{#1}\beamer@structuretemplate}

\long\def\usealerttemplate#1{%
  \gdef\beamer@alerttemplate{#1}}
\long\def\usestructuretemplate#1{%
  \gdef\beamer@structuretemplate{#1}}

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
  \def\beamer@endaction{}%
}
\def\endoverprint{%
  \beamer@endaction%
  \ifvoid\beamer@animshowbox\setbox\beamer@animshowbox=\hbox{}\fi%
  \ht\beamer@animshowbox=\beamer@animht%
  \dp\beamer@animshowbox=\beamer@animdp%
  \wd\beamer@animshowbox=\beamer@animwd%
  \box\beamer@animshowbox%
}

\def\onslide<#1>{%
  \beamer@endaction%
  \alt<#1>{%
    \ifvoid\beamer@animshowbox\else\ClassError{beamer}{Overprints may not overlap}{}\fi%
    \def\beamer@endaction{%
    \end{minipage}%
    \egroup%
      \ifdim\beamer@animht<\ht\beamer@animcurrent\beamer@animht=\ht\beamer@animcurrent\fi%
      \ifdim\beamer@animdp<\dp\beamer@animcurrent\beamer@animdp=\dp\beamer@animcurrent\fi%
      \setbox\beamer@animshowbox=\copy\beamer@animcurrent}
  }%
  {\def\beamer@endaction{%
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
  \gdef\beamer@backgroundtemplate{#1}}

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
    \setbox\beamer@tempbox=\hbox{\beamer@backgroundtemplate\hyper@pagetransition\hyper@pageduration}%
    \beamer@tempdim=\ht\beamer@tempbox%
    \setbox\beamer@tempbox=\hbox{\lower\beamer@tempdim\hbox{\box\beamer@tempbox}}%
    \wd\beamer@tempbox=0pt\ht\beamer@tempbox=0pt\dp\beamer@tempbox=0pt%
    \vbox{\hbox{\hskip-\Gm@lmargin\box\beamer@tempbox}%
      \hbox{%
        {%
          \setbox\beamer@tempbox=\hbox{\hskip-\Gm@lmargin%
            {\setbox\beamer@tempbox=\hbox{\beamer@leftsidebarbackground}%
              \wd\beamer@tempbox=0pt\ht\beamer@tempbox=0pt\dp\beamer@tempbox=0pt%
              \box\beamer@tempbox}%
            \beamer@leftsidebartemplate}%
          \beamer@tempdim=\ht\beamer@tempbox%
          \setbox\beamer@tempbox=\hbox{{\lower\beamer@tempdim\hbox{\box\beamer@tempbox}}}%
          \wd\beamer@tempbox=0pt\ht\beamer@tempbox=0pt\dp\beamer@tempbox=0pt%
          \box\beamer@tempbox%
        }%        
        {% print right sidebar first, since it should be overwritten by headline
          \setbox\beamer@tempbox=\hbox{\hskip\textwidth\hskip\beamer@rightmargin%
            {\setbox\beamer@tempbox=\hbox{\beamer@rightsidebarbackground}%
              \wd\beamer@tempbox=0pt\ht\beamer@tempbox=0pt\dp\beamer@tempbox=0pt%
              \box\beamer@tempbox}%
            \beamer@rightsidebartemplate}%
          \beamer@tempdim=\ht\beamer@tempbox%
          \setbox\beamer@tempbox=\hbox{{\lower\beamer@tempdim\hbox{\box\beamer@tempbox}}}%
          \wd\beamer@tempbox=0pt\ht\beamer@tempbox=0pt\dp\beamer@tempbox=0pt%
          \box\beamer@tempbox%
        }%
        \beamer@headtemplate\hfil%
      }%
      \hfil}}
  \def\@oddfoot{\beamer@foottemplate\hypertarget{Navigation\thepage}{}\hfil}
  \let\@evenhead\@oddhead
  \let\@evenfoot\@oddfoot}
\pagestyle{navigation}

%
% Patch empty page style, so that transitions and navigation still works
%
\def\ps@empty{%
  \let\@mkboth\@gobbletwo%
  \def\@oddhead{\setbox\beamer@tempbox=\hbox{\beamer@backgroundtemplate\hyper@pagetransition\hyper@pageduration}%
    \beamer@tempdim=\ht\beamer@tempbox%
    \setbox\beamer@tempbox=\hbox{\lower\beamer@tempdim\hbox{\box\beamer@tempbox}}%
    \wd\beamer@tempbox=0pt\ht\beamer@tempbox=0pt\dp\beamer@tempbox=0pt%
    \vbox{\hbox{\hskip-\Gm@lmargin\raise\headheight\box\beamer@tempbox}\hfil}}
  \def\@oddfoot{\hypertarget{Navigation\thepage}{}\hfil}
  \let\@evenhead\@oddhead\let\@evenfoot\@oddfoot}

\def\recalculatefoot{%
  \beamer@activecjk%
  \setbox\beamer@tempbox=\hbox{\beamer@foottemplate}%
  \footheight=\ht\beamer@tempbox%
  \advance\footheight by \dp\beamer@tempbox%
  \advance\footheight by 4pt%
  \geometry{foot=\the\footheight}%
  \advance\footheight by -4pt%
  \sidebarheight=\paperheight%
  \advance\sidebarheight by-\headheight%
  \advance\sidebarheight by\headdp%
  \advance\sidebarheight by-\footheight}
\def\recalculatehead{%
  \beamer@activecjk%
  \setbox\beamer@tempbox=\hbox{\beamer@headtemplate}%
  \headheight=\ht\beamer@tempbox%
  \headdp=\dp\beamer@tempbox%
  \advance\headheight by\headdp%
  \geometry{head=\the\headheight}%
  \sidebarheight=\paperheight%
  \advance\sidebarheight by-\headheight%
  \advance\sidebarheight by\headdp%
  \advance\sidebarheight by-\footheight}%

\long\def\usefoottemplate#1{%
  \gdef\beamer@foottemplate{\offinterlineskip\reset@font\def\\{,}#1}%
  \recalculatefoot}
\def\insertpagenumber{\thepage}

\long\def\useheadtemplate#1{%
  \gdef\beamer@headtemplate{\offinterlineskip\reset@font#1}%
  \recalculatehead} 

\def\insertvrule#1#2{%
  \hbox{\color{#2}\hskip-\Gm@lmargin\vrule width \paperwidth
    height #1\hskip-\Gm@rmargin}}

%
% Inserting navigation bars
%

\def\insertnavigation#1{%
  \vbox{\tiny%
    \beamer@xpos=0\relax%
    \beamer@ypos=1\relax%
    \hbox to #1{\hskip.3cm\setbox\beamer@sectionbox=\hbox{\kern1sp}%
      \ht\beamer@sectionbox=1.875ex%
      \dp\beamer@sectionbox=0.75ex%
        \hskip-1.875ex plus-1fill\dohead%
      \box\beamer@sectionbox\hfil\hskip.3cm}%
  }}

\def\sectionentry#1#2#3#4#5{% section name, section title, page
  \ifnum#5=\c@part%
  \box\beamer@sectionbox\hskip1.875ex plus 1fill%
  \beamer@xpos=0\relax%
  \beamer@ypos=1\relax%
  \setbox\beamer@sectionbox=
  \hbox{\def\insertsectionhead{#2}%
    \ifnum\thesection=#1%
    \hyperlink{Navigation#3}{\beamer@sectionheadhilight}\else%
    \hyperlink{Navigation#3}{\beamer@sectionheadnohilight}\fi}%
  \ht\beamer@sectionbox=1.875ex%
  \dp\beamer@sectionbox=0.75ex%
  \fi\ignorespaces}

\def\usesectionheadtemplate#1#2{\gdef\beamer@sectionheadhilight{#1}\gdef\beamer@sectionheadnohilight{#2}}
\def\usesectionsidetemplate#1#2{\gdef\beamer@sectionsidehilight{#1}\gdef\beamer@sectionsidenohilight{#2}}


\def\insertverticalnavigation#1{%
  \vbox{%
    \def\sectionentry##1##2##3##4##5{%
      \ifnum##5=\c@part%
      \def\insertsectionhead{##2}%
      \hbox{\hyperlink{Navigation##3}{%
          \ifnum\thesection=##1%
            \ifnum\thesubsection=0\relax%
              \beamer@sectionsidehilight%
            \else%
              \beamer@sectionsidenohilight%
            \fi%
          \else
            \beamer@sectionsidenohilight%
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
              \beamer@subsectionsidehilight%
            \else%
              \beamer@subsectionsidenohilight%
            \fi%
          \else%
            \beamer@subsectionsidenohilight%
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
    \beamer@tempdim=-\beamer@vboxoffset%
    \advance\beamer@tempdim by-\beamer@boxsize%
    \multiply\beamer@tempdim by\beamer@ypos%
    \advance\beamer@tempdim by -.05cm%
    \raise\beamer@tempdim\hbox{%
      \beamer@tempdim=\beamer@boxsize%
      \multiply\beamer@tempdim by\beamer@xpos%
      \advance\beamer@tempdim by -\beamer@boxsize%
      \advance\beamer@tempdim by 1pt%
      \kern\beamer@tempdim\hbox{\beamer@link(#4){%
        \ifnum\thesection=#1\ifnum\thesubsection=#2\ifnum\thesubsectionslide=#3%
        \beamer@minislidehilight\else\beamer@minisliderowhilight\fi\else\beamer@minislide\fi\else\beamer@minislide\fi%
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
  \hbox to 0pt{\beamer@tempdim=-\beamer@vboxoffset%
    \advance\beamer@tempdim by -\beamer@boxsize%
    \multiply\beamer@tempdim by\beamer@ypos%
    \advance\beamer@tempdim by -.05cm%
    \raise\beamer@tempdim\hbox{}}\fi\fi\ignorespaces}
  

\def\beamer@link(#1/#2){%
  \def\beamer@goto{{Navigation#1}}% default: first slide of frame
  \ifnum\thepage<#2%
  \ifnum\thepage<#1\else% go to last slide of frame, on all slides of
                                % the frame, except for the last one
  \def\beamer@goto{{Navigation#2}}% jump to last slide of frame
  \fi\fi%
  \expandafter\hyperlink\beamer@goto}


\def\useminislidetemplate#1#2#3#4#5{%
  \gdef\beamer@minislidehilight{#1}%
  \gdef\beamer@minisliderowhilight{#2}%
  \gdef\beamer@minislide{#3}%
  \beamer@boxsize=#4%
  \beamer@vboxoffset=#5}

\def\insertsectionnavigation#1{%
  \hbox to #1{%
    \vbox{\tiny%
     \vskip0.5625ex%
     \def\slideentry##1##2##3##4##5##6{}%
     \def\sectionentry##1##2##3##4##5{%
       \ifnum##5=\c@part%
       \def\insertsectionhead{##2}%
       \setbox\beamer@tempbox=\hbox{%
         \hyperlink{Navigation##3}{\hbox to #1{%
           \hskip0.3cm\ifnum\thesection=##1%
           \beamer@sectionheadhilight\else\beamer@sectionheadnohilight\fi\hskip0.3cm}}}%
       \ht\beamer@tempbox=1.6875ex\dp\beamer@tempbox=0.75ex%        
       \box\beamer@tempbox\fi}%
     \dohead\vskip0.5625ex}\hfil}}

\def\insertsectionnavigationhorizontal#1#2#3{%
  \hbox to #1{%
     \def\slideentry##1##2##3##4##5##6{}%
     #2\hskip.3cm\tiny\setbox\beamer@sectionbox=\hbox{}%
     \ht\beamer@sectionbox=1.875ex%
     \dp\beamer@sectionbox=0.75ex%
     \hskip-1.875ex plus-1fill\dohead%
     \box\beamer@sectionbox\hfil\hskip.3cm%
     #3}}

\def\insertsubsectionnavigation#1{%
  \hbox to #1{%
    \vbox{\tiny%
      \vskip0.5625ex%
      \beamer@currentsubsection=1%
      \def\sectionentry##1##2##3##4##5{}%
      \def\slideentry##1##2##3##4##5##6{\ifnum##6=\c@part\ifnum##1=\thesection%
        \ifnum##2=\beamer@currentsubsection%
        \advance\beamer@currentsubsection by1%
        \def\insertsubsectionhead{##5}%
        \setbox\beamer@tempbox=\hbox{\beamer@link(##4){%
          \hbox to #1{\hskip0.3cm\ifnum\thesubsection=##2%
          \beamer@subsectionheadhilight\else\beamer@subsectionheadnohilight\fi\hfil\hskip0.3cm}}}%
        \ht\beamer@tempbox=1.6875ex\dp\beamer@tempbox=0.75ex%
        \box\beamer@tempbox\fi\fi\fi}%
      \dohead\vskip0.5625ex}\hfil}}

\def\insertsubsectionnavigationhorizontal#1#2#3{%
  \hbox to #1{\tiny%
    \beamer@currentsubsection=1%
    \def\sectionentry##1##2##3##4##5{}%
    \def\slideentry##1##2##3##4##5##6{\ifnum##6=\c@part\ifnum##1=\thesection%
      \ifnum##2=\beamer@currentsubsection%
      \advance\beamer@currentsubsection by1%
      \box\beamer@sectionbox\hskip1.875ex plus1fill%
      \setbox\beamer@sectionbox=
      \hbox{\def\insertsubsectionhead{##5}%
        \ifnum\thesubsection=##2%
        \beamer@link(##4){\beamer@subsectionheadhilight}\else%
        \beamer@link(##4){\beamer@subsectionheadnohilight}\fi}%
      \ht\beamer@sectionbox=1.875ex%
      \dp\beamer@sectionbox=0.75ex%
      \fi\fi\fi\ignorespaces}%
    #2\hskip.3cm\tiny\setbox\beamer@sectionbox=\hbox{}%
    \hskip-1.875ex plus-1fill\dohead%
    \box\beamer@sectionbox\hfil\hskip.3cm%
    #3}}

\def\usesubsectionheadtemplate#1#2{\gdef\beamer@subsectionheadhilight{#1}\gdef\beamer@subsectionheadnohilight{#2}}
\def\usesubsectionsidetemplate#1#2{\gdef\beamer@subsectionsidehilight{#1}\gdef\beamer@subsectionsidenohilight{#2}}



%
%
% Predefined Blocks
%
%

\long\def\useblocktemplate#1#2{%
  \gdef\beamer@beginblocktemplate{#1}
  \gdef\beamer@endblocktemplate{#2}}

\long\def\usealertblocktemplate#1#2{%
  \gdef\beamer@beginalertblocktemplate{#1}
  \gdef\beamer@endalertblocktemplate{#2}}

\long\def\useexampleblocktemplate#1#2{%
  \gdef\beamer@beginexampleblocktemplate{#1}
  \gdef\beamer@endexampleblocktemplate{#2}}

\newoverlayenvironment{block}[1]{%
  \def\insertblockname{#1}%
  \par%
  \beamer@beginblocktemplate}{\par\beamer@endblocktemplate}%
  {\beamer@startcovered%
  \def\insertblockname{#1}%
  \par%
  \beamer@beginblocktemplate}{\par\beamer@endblocktemplate\beamer@endcovered}

\newoverlayenvironment{alertblock}[1]{%
  \def\insertblockname{#1}%
  \par%
  \beamer@beginalertblocktemplate}{\par\beamer@endalertblocktemplate}%
  {\beamer@startcovered%
  \def\insertblockname{#1}%
  \par%
  \beamer@beginalertblocktemplate}{\par\beamer@endalertblocktemplate\beamer@endcovered}

\newoverlayenvironment{exampleblock}[1]{%
  \def\insertblockname{#1}%
  \par%
  \beamer@beginexampleblocktemplate}{\par\beamer@endexampleblocktemplate}%
  {\beamer@startcovered%
  \def\insertblockname{#1}%
  \par%
  \beamer@beginexampleblocktemplate}{\par\beamer@endexampleblocktemplate\beamer@endcovered}

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

\newcommand{\BeispielInline}[1]{{\color{black!50!green}Beispiel: \ignorespaces#1}}
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
  \ifbeamer@centered%    
  \begin{minipage}[c]{#1}%
  \else%
  \begin{minipage}[t]{#1}%
  \fi%
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


\def\description{\@ifnextchar[{\@description}{\beamer@descdefault\beamer@descdefaulttemp\@@description}}
\def\@description[#1]{\setbox\beamer@tempbox=\hbox{\def\insertdescriptionitem{#1}\descriptionitemtemplate}%
  \beamer@descdefault\wd\beamer@tempbox\advance\beamer@descdefault by \labelsep\@@description}
\def\@@description{\list{}{\labelwidth\beamer@descdefault\leftmargin\beamer@descdefault\let\makelabel\beamer@descriptionitem}%
  \begin{pauses}\raggedright}
\def\enddescription{\end{pauses}\endlist}
\long\def\beamer@descriptionitem#1{\def\insertdescriptionitem{#1}%
  \hfil\hspace\labelsep\normalfont\descriptionitemtemplate}

\def\usedescriptionitemtemplate#1#2{\gdef\descriptionitemtemplate{#1}\global\beamer@descdefaulttemp=#2%
  \global\advance\beamer@descdefaulttemp by \labelsep}
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
      \immediate\openout\tf@head\jobname.nav\relax
      \newwrite\tf@toc
      \immediate\openout\tf@toc\jobname.toc\relax
      \newwrite\tf@snm
      \immediate\openout\tf@snm\jobname.snm\relax
    \fi
}

\raggedright

\def\tinyline#1{%
  {\tiny\setbox\beamer@linebox=\hbox to\textwidth{\hskip-\Gm@lmargin\hskip0.3cm{#1}\hskip-\Gm@rmargin\hskip0.3cm}%
  \ht\beamer@linebox=2.06ex%
  \dp\beamer@linebox=0pt%
  \box\beamer@linebox%
  \vskip1.125ex}}
\def\tinycolouredline#1#2{%
  \hbox{\tiny%
    \setbox\beamer@linebox=\hbox to\textwidth{\hskip-\Gm@lmargin\hskip0.3cm{#2}\hskip-\Gm@rmargin\hskip0.3cm}%
    \ht\beamer@linebox=2.625ex%
    \dp\beamer@linebox=0pt%
    \setbox\beamer@linebox=\vbox{\box\beamer@linebox\vskip1.125ex}%
    {\color{#1}\hskip-\Gm@lmargin\vrule width\paperwidth
      height\ht\beamer@linebox\hskip-\paperwidth\hskip\Gm@lmargin}%
    \box\beamer@linebox}%
  }
\def\colouredline#1#2{%
  \hbox{%
    \setbox\beamer@linebox=\hbox to\textwidth{\hskip-\Gm@lmargin\hskip0.3cm{#2}\hskip-\Gm@rmargin\hskip0.3cm}%
    \setbox\beamer@linebox=\vbox{\vskip2pt\box\beamer@linebox\vskip2pt}%
    {\color{#1}\hskip-\Gm@lmargin\vrule width\paperwidth
      height\ht\beamer@linebox\hskip-\paperwidth\hskip\Gm@lmargin}%
    \box\beamer@linebox}%
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
\newenvironment{thebibliography}[1]
{%\leavevmode\unskip%
  \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\beamer@biblabeltemplate{\@biblabel{#1}}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \itemsep=0pt%
            \partopsep=0pt%
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}
            \let\makelabel\beamer@biblabeltemplate}%
      \begin{pauses}%
      \sloppy\raggedright
      \clubpenalty10000
      \@clubpenalty \clubpenalty
      \widowpenalty10000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \end{pauses}\endlist}

\long\def\beamer@biblabeltemplate#1{\def\insertbiblabel{#1}\biblabeltemplate\hfil}

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
  \setbox\beamer@tempbox=\hbox{\ }\hskip-\wd\beamer@tempbox\setbox\beamer@tempbox=\hbox{}\ht\beamer@tempbox=1.5em\box\beamer@tempbox}

\long\def\usebibitemtemplate#1{%
  \gdef\biblabeltemplate{#1}}

\long\def\usebibliographyblocktemplate#1#2#3#4{%
  \gdef\firstblocktemplate{#1}%
  \gdef\secondblocktemplate{#2}%
  \gdef\thirdblocktemplate{#3}%
  \gdef\otherblocktemplate{#4}}

\beamertemplatearticlebibitems
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

\newoverlaycommand{\transblindshorizontal}{\beamer@dotrans{Blinds /Dm /H}}{\beamer@ignoreoptional}
\newoverlaycommand{\transblindsvertical}{\beamer@dotrans{Blinds /Dm /V}}{\beamer@ignoreoptional}
\newoverlaycommand{\transboxin}{\beamer@dotrans{Box /M /I}}{\beamer@ignoreoptional}
\newoverlaycommand{\transboxout}{\beamer@dotrans{Box /M /O}}{\beamer@ignoreoptional}
\newoverlaycommand{\transcover}{\beamer@dotrans{Cover}}{\beamer@ignoreoptional}
\newoverlaycommand{\transdissolve}{\beamer@dotrans{Dissolve}}{\beamer@ignoreoptional}
\newoverlaycommand{\transfade}{\beamer@dotrans{Fade}}{\beamer@ignoreoptional}
\newoverlaycommand{\transglitter}{\beamer@dotrans{Glitter}}{\beamer@ignoreoptional}
\newoverlaycommand{\transpush}{\beamer@dotrans{Push}}{\beamer@ignoreoptional}
\newoverlaycommand{\transsplitverticalin}{\beamer@dotrans{Split /Dm /V /M /I}}{\beamer@ignoreoptional}
\newoverlaycommand{\transsplitverticalout}{\beamer@dotrans{Split /Dm /V /M /O}}{\beamer@ignoreoptional}
\newoverlaycommand{\transsplithorizontalin}{\beamer@dotrans{Split /Dm /H /M /I}}{\beamer@ignoreoptional}
\newoverlaycommand{\transsplithorizontalout}{\beamer@dotrans{Split /Dm /H /M /O}}{\beamer@ignoreoptional}
\newoverlaycommand{\transuncover}{\beamer@dotrans{Uncover}}{\beamer@ignoreoptional}
\newoverlaycommand{\transwipe}{\beamer@dotrans{Wipe}}{\beamer@ignoreoptional}


\newoverlaycommand{\transduration}{\beamer@transdur}{\@gobble}
\def\beamer@transdur#1{\hypersetup{pdfpageduration=#1}}




%
% Animation macros
%

\def\animate<#1>{\transduration<#1| handout:0| trans:0>{0}}
\def\animatevalue<#1-#2>#3#4#5{%
  \only<#1-#2>{}% enforce these frames
  \ifnum\beamer@slideinframe<#1\relax%
    #3=#4%
  \else%
    \ifnum\beamer@slideinframe<#2\relax%
      #3=#4\relax%
      #3=-#3\relax%
      \advance#3 by#5\relax%
      \beamer@animationtempa=#2\relax%
      \advance\beamer@animationtempa by-#1%
      \ifnum\beamer@animationtempa>0%
        \divide#3 by\beamer@animationtempa%
      \fi%
      \beamer@animationtempa=\beamer@slideinframe%
      \advance\beamer@animationtempa by-#1%
      \multiply#3 by\beamer@animationtempa%
      \advance#3 by#4%
    \else
      #3=#5%
    \fi%
  \fi%  
}
  


\RequirePackage{beamerbasenavigation}
% Navigation buttons


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
    \beamer@makecaption{#1}{\ignorespaces #3}\par
    \endgroup}
\long\def\beamer@makecaption#1#2{%
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
  \ifbeamer@notes
  {
  \def\@oddhead{}
  \def\@oddfoot{}
  \let\@evenhead\@oddhead
  \let\@evenfoot\@oddfoot
  \def\beamer@backgroundtemplate{}
  \vbox{%
    \vskip-\headheight%
    \ifbeamer@compressnotes
    \insertvrule{2.5em}{white!90!black}
    \vskip2.5em
    \nointerlineskip
    \tiny
    \setbox\beamer@tempbox=\hbox{\raise7em\hbox{\insertsection}}%
    \ht\beamer@tempbox=0pt
    \box\beamer@tempbox
    \nointerlineskip
    \setbox\beamer@tempbox=\hbox{\raise6em\hbox{\quad\insertsubsection}}%
    \ht\beamer@tempbox=0pt
    \box\beamer@tempbox
    \nointerlineskip
    \setbox\beamer@tempbox=\hbox{\raise5em\hbox{\quad\quad\insertframetitle}}%
    \ht\beamer@tempbox=0pt
    \box\beamer@tempbox
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
    \setbox\beamer@tempbox=\hbox{\insertsection}%
    \hbox{\ifdim\wd\beamer@tempbox>1pt{\hskip4pt\raise3pt\hbox{\vrule width0.4pt height9pt\vrule width 9pt height0.4pt}}\hskip1pt\hbox{\vbox{\begin{minipage}[t]{8cm}\insertsection\end{minipage}}}\fi}%
    \setbox\beamer@tempbox=\hbox{\insertsubsection}%
    \hbox{\ifdim\wd\beamer@tempbox>1pt{\hskip17.4pt\raise3pt\hbox{\vrule width0.4pt height9pt\vrule width 9pt height0.4pt}}\hskip1pt\hbox{\vbox{\begin{minipage}[t]{8cm}\insertsubsection\end{minipage}}}\fi}%
    \setbox\beamer@tempbox=\hbox{\insertframetitle}%
    \hbox{\ifdim\wd\beamer@tempbox>1pt{\hskip30.8pt\raise3pt\hbox{\vrule width0.4pt height9pt\vrule width 9pt height0.4pt}}\hskip1pt\hbox{\vbox{\begin{minipage}[t]{8cm}\insertframetitle\end{minipage}}}\fi}%
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
\beamertemplateplaintoc

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
%%% TeX-master: "~/texmf/tex/latex/beamer/examples/beamerexample1.tex"
%%% End: 
