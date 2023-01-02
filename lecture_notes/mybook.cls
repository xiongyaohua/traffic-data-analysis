\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mybook}[2023/01/02 LaTeX class for my lecture notes]

%% 参考代码，来自 https://www.overleaf.com/learn/latex/Writing_your_own_class
%\newcommand{\headlinecolor}{\normalcolor}
%\RequirePackage{xcolor}
%\definecolor{slcolor}{HTML}{882B21}
%
%\DeclareOption{onecolumn}{\OptionNotUsed}
%\DeclareOption{green}{\renewcommand{\headlinecolor}{\color{green}}}
%\DeclareOption{red}{\renewcommand{\headlinecolor}{\color{slcolor}}}
%\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
%\ProcessOptions\relax
%\LoadClass[twocolumn]{article}
%
%\renewcommand{\maketitle}{%
%    \twocolumn[%
%        \fontsize{50}{60}\fontfamily{phv}\fontseries{b}%
%        \fontshape{sl}\selectfont\headlinecolor
%        \@title
%        \medskip
%        ]%
%}
%
%\renewcommand{\section}{%
%    \@startsection
%    {section}{1}{0pt}{-1.5ex plus -1ex minus -.2ex}%
%    {1ex plus .2ex}{\large\sffamily\slshape\headlinecolor}%
%}
%
%\renewcommand{\normalsize}{\fontsize{9}{10}\selectfont}
%\setlength{\textwidth}{17.5cm}
%\setlength{\textheight}{22cm}
%%\setcounter{secnumdepth}{0}

%% 最佳实践 https://www.semipol.de/posts/2018/06/latex-best-practices-lessons-learned-from-writing-a-phd-thesis/

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[fontset=none,twoside,punct=kaiming,12pt]{ctexrep}
\pagestyle{headings}

%% 定制字体
\setCJKmainfont[Scale=0.96,ItalicFont={KaiTi},BoldFont={Noto Sans CJK SC}]{Noto Serif CJK SC}
%\setCJKmainfont[Scale=0.96,ItalicFont={Kaiti SC}]{Noto Serif CJK SC}
\setCJKsansfont[Scale=0.96]{Noto Sans CJK SC Light}
\RequirePackage{marginnote}
\RequirePackage{sidenotes}

%% 定制sidenotes的样式，来自
%% https://tex.stackexchange.com/questions/532245/how-to-modify-fonts-in-sidenotes
% 定制\marginpar
%\renewcommand*{\marginfont}{\scriptsize\captionsetup{font=scriptsize}}
%\renewcommand*{\marginfont}{\scriptsize}

% 定制\marginnote
\RequirePackage{xparse}
\let\oldmarginpar\marginpar
\RenewDocumentCommand{\marginpar}{om}{%
  \IfNoValueTF{#1}
    {\oldmarginpar{\mymparsetup #2}}
    {\oldmarginpar[\mymparsetup #1]{\mymparsetup #2}}}
\newcommand{\mymparsetup}{\scriptsize}

% 定制sidenotes中的caption
\DeclareCaptionStyle{widefigure}{font=normalsize}

% 重置sidenote的计数器
\let\oldchapter\chapter
\def\chapter{%
  \setcounter{sidenote}{1}%
  \oldchapter
}

%% 插图
\RequirePackage{graphicx}
%\graphicspath{ {./images/} }

% 保证最后一页的浮动图在顶上，见 https://tex.stackexchange.com/questions/66252/placing-the-figure-exactly-at-the-top-of-the-page-in-latex
\makeatletter
\setlength{\@fptop}{0pt}
\makeatother

%% 参考文献，用BibLaTeX而不是BibTeX。TODO 如何使用？
\RequirePackage[backend=biber,style=alphabetic,url=false]{biblatex}

%% 代码列表用minted
\RequirePackage{minted}