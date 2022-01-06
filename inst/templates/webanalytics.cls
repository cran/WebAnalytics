\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{webanalytics}[2021/12/12 WebAnalytics R package report class]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions

\LoadClass{report}

% 
% mess with the dimensions
%
\setlength\headheight{3.5cm}
\setlength\headsep   {45\p@}
\setlength\topskip   {10\p@}
\setlength\footskip{30\p@}

\addtolength{\oddsidemargin}{-2cm}
\addtolength{\evensidemargin}{-2cm}
\addtolength{\textwidth}{4cm}

\addtolength{\topmargin}{-4cm}
\addtolength{\textheight}{2cm}
	
%
% define additional display parameters for the report
%
\newcommand*{\projectname}[1]{\gdef\@projectname{#1}}
\newcommand*{\securityclass}[1]{\gdef\@securityclass{#1}}
%
% Define the title colours
%
\newcommand{\schemelightcolour}{\color[rgb]{0.34,0.47,0.7}}
\newcommand{\schemedarkcolour}{\color[rgb]{0.2,0.29,0.43}}

% title page 

\renewcommand\maketitle{\begin{titlepage}%
\let\footnotesize\small
\let\footnoterule\relax
\let \footnote \thanks
\vspace*{70\p@}%
\begin{flushleft}
{\fontencoding{T1}\fontspec{QTWeise.otf}\selectfont {\fontsize{48pt}{48pt}\selectfont {\schemedarkcolour{}WebAnalytics}\\}
\vspace*{10\p@}%
{\fontsize{48pt}{48pt}\selectfont {\MakeUppercase{\@projectname}\\}}
\vspace*{10\p@}%
{\fontsize{48pt}{48pt}\selectfont {\MakeUppercase{\@title}\\}}
\schemelightcolour{}{\Huge \@date}}
\end{flushleft}
\@thanks
\vfil\null
\thispagestyle{title}
\end{titlepage}%

\setcounter{footnote}{0}%
\global\let\thanks\relax
\global\let\maketitle\relax
\global\let\@thanks\@empty
%\global\let\@author\@empty
\global\let\@date\@empty
\global\let\@title\@empty
\global\let\title\relax
\global\let\author\relax
\global\let\date\relax
\global\let\and\relax
}
%
% Chapter Page style set here
%
\renewcommand\chapter{\if@openright\cleardoublepage\else\clearpage\fi
                    \thispagestyle{headings}%
                    \global\@topnum\z@
                    \@afterindentfalse
                    \secdef\@chapter\@schapter}
%
% Chapter Heading 
%
\def\@makechapterhead#1{%
   \vspace*{10\p@}%
  {\parindent \z@ \raggedright 
  {\fontencoding{T1}\fontspec{QTWeise.otf}\selectfont {
  % replace above with \normalfont for Helvetica chapter heading and remove the trailing } on the next line
    \schemedarkcolour \Huge \bfseries \@chapapp\space\thechapter\newline #1\par\nobreak}}
    \vskip 10\p@
  }}%

\def\@makeschapterhead#1{%
  \vspace*{50\p@}%
  {\parindent \z@ \raggedright
    {\fontencoding{T1}\fontspec{QTWeise.otf}\selectfont {
      % replace above with \normalfont for Helvetica chapter heading and remove the trailing } on the next line

    \interlinepenalty\@M
    \schemedarkcolour \Huge \bfseries  #1\par\nobreak}}
    \vskip 40\p@
  }}

\renewcommand\section{\@startsection {section}{1}{\z@}%
                                   {-3.5ex \@plus -1ex \@minus -.2ex}%
                                   {2.3ex \@plus.2ex}%
                                   {\normalfont\Large\bfseries\schemedarkcolour}}
\renewcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                     {\normalfont\large\bfseries\schemedarkcolour}}
\renewcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                     {-3.25ex\@plus -1ex \@minus -.2ex}%
                                     {1.5ex \@plus .2ex}%
                                     {\normalfont\normalsize\bfseries\schemedarkcolour}}

\usepackage{lastpage}
\usepackage[usenames,dvipsnames]{color}
\usepackage{fontspec}
 
%
% Set the font to the latest Helvetica clone
%
\usepackage{tgheros}
\renewcommand*\familydefault{\sfdefault}
%
% Footer
%
\def\@nofmfooter{Page \thepage\ of \pageref{LastPage}}
\def\@copyrightnotice{\@securityclass\space\textcopyright{}\space\@author\space\number\year}
\def\@myfooterright{\parbox{\textwidth}{\raggedleft\hfill\@nofmfooter{}\newline\@copyrightnotice}}
\def\@myfooterleft{\parbox{\textwidth}{\raggedright\@nofmfooter{}\newline\@copyrightnotice}}
%
% Header
%
\def\@headerlogo{\includegraphics[height=2cm]{logo.eps}}
\def\@headertext{\raisebox{27pt}{\fontencoding{T1}\fontspec{QTWeise.otf}\fontsize{13}{15}\selectfont{\schemedarkcolour{}{ \@projectname{}}}}}
\def\@myheaderright{\@headertext\hfill\@headerlogo}
\def\@myheaderleft{\@headerlogo\hfill\@headertext}

%
% title pagestyle
%
\def\ps@title{%
  \def\@oddfoot{\hfill\@copyrightnotice}
  \let\@evenfoot\@empty
  \def\@oddhead{\hfill\@headerlogo}
  \let\@evenhead\@empty
}
%
% headings pagestyle
%
\if@twoside
  \def\ps@headings{%
      \def\@oddfoot{\@myfooterleft}
      \def\@evenfoot{\@myfooterright}
      \def\@evenhead{\@myheaderright}
      \def\@oddhead{\@myheaderleft}%
      \let\@mkboth\markboth
    \def\chaptermark##1{%
      \markboth {\MakeUppercase{%
        \ifnum \c@secnumdepth >\m@ne
            \@chapapp\ \thechapter. \ %
        \fi
        ##1}}{}}%
    \def\sectionmark##1{%
      \markright {\MakeUppercase{%
        \ifnum \c@secnumdepth >\z@
          \thesection. \ %
        \fi
        ##1}}}}
\else
  \def\ps@headings{%
  \def\@oddfoot{\@myfooterright}
  \def\@oddhead{\@myheaderright}%
    \let\@mkboth\markboth
    \def\chaptermark##1{%
      \markright {\MakeUppercase{%
        \ifnum \c@secnumdepth >\m@ne
            \@chapapp\ \thechapter. \ %
        \fi
        ##1}}}}
\fi

%
% set the page style for the report
%
\pagestyle{headings}

% 
% packages used in the body of the report 
%
\usepackage{parskip}
\usepackage{graphicx}
\usepackage{underscore}
\usepackage{fix-cm}
\usepackage[T1]{fontenc}

\usepackage{longtable}
% left align long tables
\setlength{\LTleft}{0pt}

\usepackage{booktabs}
\usepackage{pdflscape}
\usepackage{epstopdf}
\usepackage{float}
\usepackage{rotating}

\usepackage{multirow}
\usepackage{adjustbox}
\usepackage{array}

\usepackage{lastpage}
\usepackage[usenames,dvipsnames]{color}
\usepackage{fontspec}
 
\RequirePackage{xstring}

\newlength{\urlshort@lz}
\newlength{\urlshort@lzz}
\newcounter{urlshorten@num}

\newcommand\urlshorten[1]{
\setcounter{urlshorten@num}{1}
\urlshorten@three{#1}{#1}%
}

%
% URL abbreviation macros
%
\usepackage{xurl}

\newcommand\urlshorten@two[1]{
% get the string width 
\StrGobbleLeft{#1}{20}[\truncstr]%
% slashes and dots don't work well here, Ms should be more than "/ ... " wide   
\def\wkstr{MMMM\truncstr}%
\settowidth{\urlshort@lz}{\wkstr}%
\ifdim\linewidth > \urlshort@lz%
/ ... \truncstr%
\else%
\urlshorten@two{\truncstr}%
\fi%
}

\newcommand\urlshorten@three[2]{%
% get the strng width 
\settowidth{\urlshort@lz}{#1}%
%
% if the string width greater than the page text
\ifdim\linewidth < \urlshort@lz%
\expandarg%
% count the slashes because we assume 3 below
\StrCount{#1}{/}[\slashcount]%
% if we have enough slashes
\ifnum\slashcount>2%
% get the text after /appname/prefix/
\StrBehind[3]{#1}{/}[\word]%
% get the first path segment in the trailing string 
\StrBefore{\word}{/}[\word]%
% replace it and its following slash with three dots (\ldots does not work on iteration of this string
\StrSubstitute[1]{#1}{\word/}{ ... }[\resultstring]%
% is it short enough?
\settowidth{\urlshort@lzz}{\resultstring}%
\ifdim\linewidth < \urlshort@lzz%
\urlshorten@three{\resultstring}{#2}%
\else%
\resultstring%
\fi%
\else%
% removing path segments from the middle doesn't work 
% just chop characters out of it
\urlshorten@two{#2}%
\fi%
\else%
% its already short enough
\setcounter{urlshorten@num}{0}%
#1%
\fi%
}

\newcommand\urlshortenconditionaltext[1]{
\ifnum\value{urlshorten@num}>0
#1
\else
%counter is zero
\fi
}

% ...

%
% Put hyperref package in as late as possible 
%
\usepackage{hyperref}

\hypersetup{colorlinks,breaklinks,
  urlcolor=[rgb]{0.3,0.35,0.4},
  linkcolor=[rgb]{0.3,0.35,0.4}}

