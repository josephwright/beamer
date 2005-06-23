\RequirePackage{beamerbasercs}
\def\beamer@version{3.05}

\ProvidesClassRCS $Header$
[cvs version \beamer@version\space A class for typesetting presentations]

% Copyright 2003 by Till Tantau <tantau@users.sourceforge.net>.
%
% This program can be redistributed and/or modified under the terms
% of the GNU Public License, version 2.



\RequirePackage{beamerbasemodes}
% Setup modes and check for article option

\beamer@transferifnecessary

%
% Ensure that \pdfoutput is defined. Might be removed at some point.
%
\ifx\pdfoutput\@undefined \newcount\pdfoutput \fi
\ifx\pdfoutput\relax \newcount\pdfoutput \fi

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
\newdimen\beamer@descriptionwidth

\newskip\beamer@lastskip

\newbox\beamer@areabox
\newbox\beamer@animcurrent
\newbox\beamer@animshowbox
\newbox\beamer@sectionbox
\newbox\beamer@logobox
\newbox\beamer@linebox

\newcount\beamer@sectioncount
\newcount\beamer@subsubsectionmax
\newcount\beamer@subsectionmax
\newcount\beamer@sectionmax
\newcount\beamer@totalheads
\newcount\beamer@headcounter
\newcount\beamer@partstartpage
\newcount\beamer@sectionstartpage
\newcount\beamer@subsectionstartpage
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
\newif\ifbeamer@suppressreplacements % decides whether fonts should be substituted
\newif\ifbeamer@frameswithnotesonly
\newif\ifbeamer@ignorenonframe
\newif\ifbeamer@autopdfinfo

\RequirePackage{beamerbaseoptions}
% For option management



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
\beamer@frameswithnotesonlyfalse
\beamer@ignorenonframefalse
\beamer@autopdfinfotrue

\DeclareOptionBeamer{usepdftitle}[true]{\csname beamer@autopdfinfo#1\endcsname}
\DeclareOptionBeamer{envcountsect}{\beamer@countsecttrue}
\DeclareOptionBeamer{notheorems}{\beamer@blocksfalse}
\DeclareOptionBeamer{noamsthm}{\beamer@blocksfalse\beamer@amsfalse}

\DeclareOptionBeamer{compress}{\beamer@compresstrue}

\DeclareOptionBeamer{t}{\beamer@centeredfalse}
\DeclareOptionBeamer{c}{\beamer@centeredtrue}


\DeclareOptionBeamer{leqno}{\input{leqno.clo}}
\DeclareOptionBeamer{fleqn}{\input{fleqn.clo}}

\def\beamer@currentmode{beamer}
\DeclareOptionBeamer{handout}{\gdef\beamer@currentmode{handout}}
\DeclareOptionBeamer{trans}{\gdef\beamer@currentmode{trans}}

\DeclareOptionBeamer{pdftex}{}% Used by hyperref
\DeclareOptionBeamer{nativepdf}{}% Used by hyperref
\DeclareOptionBeamer{pdfmark}{}% Used by hyperref
\DeclareOptionBeamer{dvips}{}% Used by hyperref
\DeclareOptionBeamer{dviwindo}{}% Used by hyperref
\DeclareOptionBeamer{dvipsone}{}% Used by hyperref
\DeclareOptionBeamer{vtex}{}% Used by hyperref
\DeclareOptionBeamer{ps2pdf}{}% Used by hyperref

\DeclareOptionBeamer{ignorenonframetext}{\beamer@ignorenonframetrue}

\def\beamer@size{{size11.clo}}
\DeclareOptionBeamer{bigger}{\def\beamer@size{{size12.clo}}}
\DeclareOptionBeamer{smaller}{\def\beamer@size{{size10.clo}}}

\DeclareOptionBeamer{8pt}{\def\beamer@size{{size8.clo}}}
\DeclareOptionBeamer{9pt}{\def\beamer@size{{size9.clo}}}
\DeclareOptionBeamer{10pt}{\def\beamer@size{{size10.clo}}}
\DeclareOptionBeamer{11pt}{\def\beamer@size{{size11.clo}}}
\DeclareOptionBeamer{12pt}{\def\beamer@size{{size12.clo}}}
\DeclareOptionBeamer{14pt}{\def\beamer@size{{size14.clo}}}
\DeclareOptionBeamer{17pt}{\def\beamer@size{{size17.clo}}}
\DeclareOptionBeamer{20pt}{\def\beamer@size{{size20.clo}}}

\DeclareOptionBeamer{draft}{\beamer@draftmodetrue}
\def\insertpagenumber{\thepage}

\def\beamer@activecjk{}
\def\beamer@hypercjk{}

\DeclareOptionBeamer{CJK}{\ExecuteOptionsBeamer{cjk}}
\DeclareOptionBeamer{cjk}{
  \def\beamer@hypercjk{\hypersetup{CJKbookmarks=true}}

  \def\beamer@activecjk{
    % Activate all >128 characters. 
    \count@=128
    \@whilenum\count@<254 \do{%
      \advance\count@ by 1
      \lccode`\~=\count@
      \catcode\count@=\active
      \lowercase{\def~{\kern1ex}}
    }
  }  
}



% obsolete options
\DeclareOptionBeamer{notes}[show]{\csname beamer@notesaction@#1\endcsname}
\def\beamer@notesaction@hide{%
  \ClassWarning{beamer}{This option is obsolete. Use beamer option
    ``hide notes'' instead.}%
  \beamer@notesfalse}
\def\beamer@notesaction@show{%
  \ClassWarning{beamer}{This option is obsolete. Use beamer option
    ``show notes'' instead.}%
  \beamer@notestrue}
\def\beamer@notesaction@only{%
  \ClassWarning{beamer}{This option is obsolete. Use beamer option
    ``show only notes'' instead.}%
  \beamer@notestrue
  \beamer@notesnormalsfalse
  \nofiles
}
\def\beamer@notesaction@onlyslideswithnotes{%
  \beamer@notestrue%
  \beamer@frameswithnotesonlytrue%
  \nofiles
}
\DeclareOptionBeamer{inrow}{
  \ClassError{beamer}{``inrow'' no longer supported. Use ``compress'' instead.}{}}
\DeclareOptionBeamer{compressnotes}{%
  \ClassWarning{beamer}{``compressnotes'' is obsolete. Use
    \noexpand\setbeamertemplate{note page}[compressed] instead}
  \AtBeginDocument{\beamertemplatenotecompress}}
\DeclareOptionBeamer{notesonly}{
  \ClassWarning{beamer}{``notesonly'' is obsolete. Use beamer option
    ``show only notes'' instead.}
  \beamer@notesaction@only}
\DeclareOptionBeamer{blue}{
  \ClassWarning{beamer}{``blue'' is obsolete. Use color theme structure instead}
  \def\beamer@loadlater{\usecolortheme[rgb={0.2,0.2,0.7}]{structure}}}
\DeclareOptionBeamer{red}{
  \ClassWarning{beamer}{``red'' is obsolete. Use color theme structure instead}
  \def\beamer@loadlater{\usecolortheme[rgb={0.7,0.2,0.2}]{structure}}}
\DeclareOptionBeamer{blackandwhite}{
  \ClassWarning{beamer}{``blackandwhite'' is obsolete. Use color theme structure instead}
  \def\beamer@loadlater{\usecolortheme[rgb={0.2,0.2,0.2}]{structure}}}
\DeclareOptionBeamer{brown}{
  \ClassWarning{beamer}{``brown'' is obsolete. Use color theme structure instead}
  \def\beamer@loadlater{\usecolortheme[rgb={0.66,0.4,0.166}]{structure}}}
\DeclareOptionBeamer{slidescentered}{
  \ClassWarning{beamer}{``slidescentered'' is obsolete. Use ``c'' instead}
  \beamer@centeredtrue}
\DeclareOptionBeamer{slidestop}{
  \ClassWarning{beamer}{``slidestop'' is obsolete. Use ``t'' instead}
  \beamer@centeredfalse}
\DeclareOptionBeamer{sans}{%
  \ClassWarning{beamer}{``sans'' is obsolete. Just remove this option}  
  \def\familydefault{\sfdefault}
  \def\mathfamilydefault{\sfdefault}
  \beamer@sansmathtrue
}
\DeclareOptionBeamer{serif}{%
  \ClassWarning{beamer}{``serif'' is obsolete. Use font theme ``serif'' instead}
  \def\familydefault{\rmdefault}
  \def\mathfamilydefault{\rmdefault}
  \beamer@sansmathfalse
}
\DeclareOptionBeamer{mathsans}{
  \ClassWarning{beamer}{``mathsans'' is obsolete. Use font theme ``serif'' with option ``butsansserifmath''}  
  \def\mathfamilydefault{\sfdefault}\beamer@sansmathtrue}
\DeclareOptionBeamer{mathserif}{
  \ClassWarning{beamer}{``mathserif'' is obsolete. Use font theme ``serif'' with option ``onlymath''}  
  \def\mathfamilydefault{\rmdefault}\beamer@sansmathfalse}
\DeclareOptionBeamer{professionalfont}{
  \ClassWarning{beamer}{``professionalfont'' is obsolete. Use font theme ``professionalfonts'' instead}
  \beamer@suppressreplacementstrue}

% has to be done here for compatibility
\def\familydefault{\sfdefault}
\def\mathfamilydefault{\sfdefault}
\beamer@sansmathtrue



\PassOptionsToPackage{bookmarks=true,%
  bookmarksopen=true,%
  pdfborder={0 0 0},%
  pdfhighlight={/N},%
  linkbordercolor={.5 .5 .5}}{hyperref}
  
\DeclareOptionBeamer{pgf}{\PassOptionsToPackage{#1}{pgf}}
\DeclareOptionBeamer{hyperref}{\PassOptionsToPackage{#1}{hyperref}}
\DeclareOptionBeamer{color}{\PassOptionsToPackage{#1}{color}}
\DeclareOptionBeamer{xcolor}{\PassOptionsToPackage{#1}{xcolor}}

\def\beamer@loaducs{}

\DeclareOptionBeamer{ucs}{%
  \ifcase\pdfoutput
    \def\beamer@loaducs{
      \RequirePackage{ucs}%
      \AtBeginDocument{\PreloadUnicodePage{0}}%
      \AtBeginDocument{\PreloadUnicodePage{1}}%
    }
  \or
    \PassOptionsToPackage{pdftex,unicode}{hyperref}
    \def\beamer@loaducs{
      \RequirePackage[hyperref]{ucs}%
      \AtBeginDocument{\PreloadUnicodePage{0}}%
      \AtBeginDocument{\PreloadUnicodePage{1}}%
    }
  \fi
}
\DeclareOptionBeamer{utf8}{\ExecuteOptionsBeamer{ucs}%
  \g@addto@macro\beamer@loaducs{\RequirePackage[utf8]{inputenc}}%
}

%
% Process Options
%

\ExecuteOptionsBeamer{c}
\ProcessOptionsBeamer

% Filter class option list
\beamer@filterclassoptions


\RequirePackage{pgfcore,pgfbaseimage}
% We need only the core and some image stuff for icons.

\RequirePackage{xxcolor}
% For color management.

\RequirePackage{amssymb}
% For \blacktriangleright

\RequirePackage[%
  papersize={12.80cm,9.60cm},
  hmargin=1cm,%
  vmargin=0cm,%
  head=0.5cm,% will be changed later
  headsep=0pt,%
  foot=0.5cm% will be changed later
  ]{geometry}
% For the page layout

\RequirePackage[implicit=false]{hyperref}
% For hyperlinks

\hypersetup{pdfcreator={LaTeX with beamer class version \beamer@version}}

% Coding stuff
\beamer@loaducs
\beamer@hypercjk

\expandafter\input\beamer@size
\geometry{headsep=0pt}


\RequirePackage{beamerbasecompatibility}
% Fixes other packages

\RequirePackage{beamerbasefont}
% Font stuff

% Defaults
\normalfont
\raggedright

\AtBeginDocument
{
  \addtocontents{toc}{\protect\beamer@endinputifotherversion{\beamer@version pt}}
  \addtocontents{nav}{\protect\beamer@endinputifotherversion{\beamer@version pt}}
}

\RequirePackage{beamerbasemisc}
% Miscellaneous commands

\RequirePackage{beamerbasetwoscreens}
% Stuff for using two screens

\RequirePackage{beamerbaseoverlay}
% Overlay stuff

\RequirePackage{beamerbasetitle}
% Commands for constructing the title page

\RequirePackage{beamerbasesection}
% Parts, sections, subsections, appendix

\RequirePackage{beamerbaseframe}
% Commands for constructing frames

\RequirePackage{beamerbaseverbatim}
% Commands for constructing frames

\RequirePackage{beamerbaseframesize}
% Commands for constructing frames

\RequirePackage{beamerbaseframecomponents}
% Headlines, sidebars, columns

\RequirePackage{beamerbasecolor}
% Color management

\RequirePackage{beamerbasenotes}
% Commands for adding notes

\RequirePackage{beamerbasetoc}
% Table of Contents Format

\RequirePackage{beamerbasetemplates}
% For default templates

\RequirePackage{beamerbaselocalstructure}
% Commands for local structure like alert, itemize, etc.

\RequirePackage{beamerbasenavigation}
% Navigation buttons

\RequirePackage{beamerbasetheorems}
% Theorems

\RequirePackage{beamerbasethemes}
% Commands for including and building themes

\usetheme{default}

% Compatibility stuff:
\csname beamer@loadlater\endcsname


%%% Local Variables: 
%%% mode: latex
%%% TeX-master: "~/texmf/tex/latex/beamer/examples/beamerexample1.tex"
%%% End: 
