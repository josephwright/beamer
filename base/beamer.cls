% Copyright 2003--2007 by Till Tantau
% Copyright 2010 by Vedran Mileti\'c
% Copyright 2011--2013,2015 by Vedran Mileti\'c, Joseph Wright
% Copyright 2016 by Joseph Wright
% Copyright 2017,2018 by Louis Stuart, Joseph Wright
%
% This file may be distributed and/or modified
%
% 1. under the LaTeX Project Public License and/or
% 2. under the GNU Public License.
%
% See the file doc/licenses/LICENSE for more details.

\ProvidesClass{beamer}
  [2019/09/29 v3.57 A class for typesetting presentations]

% Setup modes and check for article option
% Also loads packages required by both beamer and beamerarticle
\RequirePackage{beamerbasemodes}

% For testing PDF versus DVI mode
\RequirePackage{ifpdf}

%
%
% Declarations used by beamer
%
%

% Public
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
\newcount\beamer@ypos@offset
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

% Option management
\RequirePackage{beamerbaseoptions}

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

\DeclareOptionBeamer{noamssymb}{\beamer@amssymbfalse}

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
\pagenumbering{arabic}
\def\insertpagenumber{\thepage}

\def\beamer@activecjk{}
\def\beamer@hypercjk{}

\DeclareOptionBeamer{CJK}{\ExecuteOptionsBeamer{cjk}}
\DeclareOptionBeamer{cjk}{%
  \def\beamer@hypercjk{\hypersetup{CJKbookmarks=true}}
  \def\beamer@activecjk{%
    % Activate all >=128 characters.
    \count@=127 %
    \@whilenum\count@<254 \do{%
      \advance\count@ by 1 %
      \lccode`\~=\count@
      \catcode\count@=\active
      \lowercase{\def~{\kern1ex}}}}}

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
  \beamer@notestrue
  \beamer@frameswithnotesonlytrue
  \nofiles
}
\DeclareOptionBeamer{inrow}{%
  \ClassError{beamer}{``inrow'' no longer supported. Use ``compress'' instead.}{}}
\DeclareOptionBeamer{compressnotes}{%
  \ClassWarning{beamer}{``compressnotes'' is obsolete. Use
    \noexpand\setbeamertemplate{note page}[compressed] instead}
  \AtBeginDocument{\beamertemplatenotecompress}}
\DeclareOptionBeamer{notesonly}{%
  \ClassWarning{beamer}{``notesonly'' is obsolete. Use beamer option
    ``show only notes'' instead.}
  \beamer@notesaction@only}
\DeclareOptionBeamer{blue}{%
  \ClassWarning{beamer}{``blue'' is obsolete. Use color theme structure instead}
  \def\beamer@loadlater{\usecolortheme[rgb={0.2,0.2,0.7}]{structure}}}
\DeclareOptionBeamer{red}{%
  \ClassWarning{beamer}{``red'' is obsolete. Use color theme structure instead}
  \def\beamer@loadlater{\usecolortheme[rgb={0.7,0.2,0.2}]{structure}}}
\DeclareOptionBeamer{blackandwhite}{%
  \ClassWarning{beamer}{``blackandwhite'' is obsolete. Use color theme structure instead}
  \def\beamer@loadlater{\usecolortheme[rgb={0.2,0.2,0.2}]{structure}}}
\DeclareOptionBeamer{brown}{%
  \ClassWarning{beamer}{``brown'' is obsolete. Use color theme structure instead}
  \def\beamer@loadlater{\usecolortheme[rgb={0.66,0.4,0.166}]{structure}}}
\DeclareOptionBeamer{slidescentered}{%
  \ClassWarning{beamer}{``slidescentered'' is obsolete. Use ``c'' instead}
  \beamer@centeredtrue}
\DeclareOptionBeamer{slidestop}{%
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
\DeclareOptionBeamer{mathsans}{%
  \ClassWarning{beamer}{``mathsans'' is obsolete. Use font theme ``serif'' with option ``stillsansserifmath''}
  \def\mathfamilydefault{\sfdefault}\beamer@sansmathtrue}
\DeclareOptionBeamer{mathserif}{%
  \ClassWarning{beamer}{``mathserif'' is obsolete. Use font theme ``serif'' with option ``onlymath''}
  \def\mathfamilydefault{\rmdefault}\beamer@sansmathfalse}
\DeclareOptionBeamer{professionalfont}{%
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
  \ifpdf
    \PassOptionsToPackage{pdftex,unicode}{hyperref}
    \def\beamer@loaducs{%
      \RequirePackage[hyperref]{ucs}%
      \AtBeginDocument{\PreloadUnicodePage{0}}%
      \AtBeginDocument{\PreloadUnicodePage{1}}%
    }
  \else    
    \def\beamer@loaducs{%
      \RequirePackage{ucs}%
      \AtBeginDocument{\PreloadUnicodePage{0}}%
      \AtBeginDocument{\PreloadUnicodePage{1}}%
    }
  \fi
}
\DeclareOptionBeamer{utf8x}{\ExecuteOptionsBeamer{ucs}%
  \g@addto@macro\beamer@loaducs{\RequirePackage[utf8x]{inputenc}}%
}
\DeclareOptionBeamer{utf8}{%
  \ClassWarning{beamer}{This option works no longer loads ucs.}%
  \RequirePackage[utf8]{inputenc}%
  \PassOptionsToPackage{unicode}{hyperref}%
}

%
% Geometry: allows 16:10, 16:9, 14:9, 5:4 and 4:3 (default 4:3).
% Default value is set right after declaring width and height
% because it doesn't work otherwise.
%
\newlength\beamer@paperwidth
\setlength\beamer@paperwidth{12.80cm}
\newlength\beamer@paperheight
\setlength\beamer@paperheight{9.60cm}

\DeclareOptionBeamer{aspectratio}[43]{%
  \ifnum#1=1610 %
    \setlength\beamer@paperwidth{16.00cm}%
    \setlength\beamer@paperheight{10.00cm}%
  \else\ifnum#1=169 %
    \setlength\beamer@paperwidth{16.00cm}%
    \setlength\beamer@paperheight{9.00cm}%
  \else\ifnum#1=149 %
    \setlength\beamer@paperwidth{14.00cm}%
    \setlength\beamer@paperheight{9.00cm}%
  \else\ifnum#1=54 %
    \setlength\beamer@paperwidth{12.50cm}%
    \setlength\beamer@paperheight{10.00cm}%
  \else\ifnum#1=43 %
    \setlength\beamer@paperwidth{12.80cm}%
    \setlength\beamer@paperheight{9.60cm}%
  \else\ifnum#1=32 %
    \setlength\beamer@paperwidth{13.50cm}%
    \setlength\beamer@paperheight{9.00cm}%
  \else\ifnum#1=141 %
    \setlength\beamer@paperwidth{14.85cm}%
    \setlength\beamer@paperheight{10.50cm}%
  \fi\fi\fi\fi\fi\fi\fi
}

\RequirePackage[%
  papersize={\beamer@paperwidth,\beamer@paperheight},
  hmargin=1cm,%
  vmargin=0cm,%
  head=0.5cm,% might be changed later
  headsep=0pt,%
  foot=0.5cm% might be changed later
  ]{geometry}

%
% Process Options
%

\ExecuteOptionsBeamer{c}
\ProcessOptionsBeamer

% Load corresponding size file
\expandafter\input\beamer@size

% Filter class option list
\beamer@filterclassoptions

% Low-level graphic drawing and advanced color support.
\RequirePackage{pgfcore}
\RequirePackage{xxcolor}

% Normally loaded by hyperref but to be on the safe side ...
\RequirePackage{atbegshi}

\RequirePackage[implicit=false]{hyperref}

\hypersetup{pdfcreator={LaTeX with Beamer class}}

% Encoding stuff
\beamer@loaducs
\beamer@hypercjk

% Beamer packages required both by presentation and article modes
\RequirePackage{beamerbaserequires}

% Defaults
\normalfont
\raggedright

\usetheme{default}

% Compatibility stuff
\csname beamer@loadlater\endcsname
