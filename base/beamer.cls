\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{beamer}
[2004/01/19 v1.21 Class for Typesetting a Beamer Presentation]

% Copyright 2003 by Till Tantau <tantau@users.sourceforge.net>.
%
% This program can be redistributed and/or modified under the terms
% of the GNU Public License, version 2.


%
% Global Declarations used by beamer in all modes
%
\newbox\beamer@tempbox
\newif\ifbeamer@blocks
\beamer@blockstrue



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

\RequirePackage{beamerbasemodes}
% Setup modes and check for article option

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
\newdimen\beamer@lastskip

\newbox\beamer@areabox
\newbox\beamer@animcurrent
\newbox\beamer@animshowbox
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
\newcount\beamer@xpos
\newcount\beamer@ypos
\newcount\beamer@showpartnumber
\newcount\beamer@currentsubsection
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
\newif\ifbeamer@suppressreplacements % decides whether fonts should be substituted



\RequirePackage{pgf}
% For all sorts of things...

\RequirePackage{xxcolor}
% For color management.

\RequirePackage{amssymb}
% For \blacktriangleright

\RequirePackage{keyval}
% For \tableofcontents parameters

\RequirePackage[%
  papersize={12.80cm,9.60cm},
  hmargin=1cm,%
  vmargin=0cm,%
  head=0.5cm,% will be changed later
  headsep=0pt,%
  foot=0.5cm% will be changed later
  ]{geometry}
% For the page layout

\RequirePackage[implicit=false,%
  bookmarks=true,%
  bookmarksopen=true,%
  pdfborder={0 0 0},%
  pdfhighlight={/N}%
  ]{hyperref}
% For hyperlinks


%
%
% Document options
%
%

\beamer@suppressreplacementsfalse
\beamer@altmodefalse
\beamer@notesfalse
\beamer@notesnormalstrue
\beamer@compressfalse
\beamer@draftmodefalse
\beamer@compressnotesfalse

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

\DeclareOption{professionalfont}{\beamer@suppressreplacementstrue}

\DeclareOption{nodefaultblocks}{\beamer@blocksfalse}

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
% Process Options
%
\ExecuteOptions{blue,sans,slidescentered}

\ProcessOptions
  
\expandafter\input\beamer@size
\geometry{headsep=0pt}


\RequirePackage{beamerbasecompatibility}
% Fixes other packages

\RequirePackage{beamerbasefont}
% Font stuff

% Defaults
\normalfont
\raggedright

\addtocontents{toc}{\protect\beamer@endinputifotherversion{\the\beamer@version}}
\addtocontents{nav}{\protect\beamer@endinputifotherversion{\the\beamer@version}}


\RequirePackage{beamerbasemisc}
% Miscellaneous commands

\RequirePackage{beamerbasetitle}
% Commands for constructing the title page

\RequirePackage{beamerbasesection}
% Parts, sections, subsections, appendix

\RequirePackage{beamerbaseframe}
% Commands for constructing frames

\RequirePackage{beamerbaseframecomponents}
% Headlines, sidebars, columns

\RequirePackage{beamerbasecolor}
% Headlines, sidebars, columns

\RequirePackage{beamerbasedecode}
% Overlay stuff

\RequirePackage{beamerbaseoverlay}
% Overlay stuff

\RequirePackage{beamerbasetoc}
% Table of Contents Format

\RequirePackage{beamerbasetemplates}
% For default templates

\RequirePackage{beamerbaselocalstructure}
% Commands for local structure like alert, itemize, etc.

\RequirePackage{beamerbasenavigation}
% Navigation buttons




%
%
% Default Theme
%
%
 
                                % Title page
\beamertemplatelargetitlepage

                                % Part page
\beamertemplatelargepartpage

                                % Frame title
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

                                % Foot
\usefoottemplate{}

                                % Background
\usebackgroundtemplate{}

                                % Blocks
\useblocktemplate{\medskip{\color{structure}\textbf{\insertblockname}}\par}{\medskip}
\usealertblocktemplate{\medskip{\alert{\textbf{\insertblockname}}}\par}{\medskip}
\useexampleblocktemplate{\medskip\begingroup{\color{structure!50!green}\textbf{\insertblockname}}\par%
\color{black!50!green}}{\endgroup\medskip}

                                % Enumerations
\beamertemplateenumeratealpha
\useenumeratetemplate{}{}
\usesubenumeratetemplate{\begin{small}}{\end{small}}

                                % Itemize
\beamertemplatetriangleitem
\useitemizetemplate{}{}
\usesubitemizetemplate{\begin{small}}{\end{small}}

                                % Buttons
\beamertemplatesolidbuttons

                                % Navigation symbols
\beamertemplatenavigationsymbolshorizontal

%%% Local Variables: 
%%% mode: latex
%%% TeX-master: "~/texmf/tex/latex/beamer/examples/beamerexample1.tex"
%%% End: 
