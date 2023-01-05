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
\LoadClass[fontset=none,twoside,punct=kaiming,12pt,a4paper]{ctexrep}

%% 页面布局定制
\RequirePackage[a4paper,left=2.5cm,right=6cm,marginpar=4.5cm]{geometry}

%% 定制中文字体。serif->宋体、sans->黑体、italic->楷体。
\setCJKmainfont[Scale=0.96,ItalicFont={Kaiti SC}]{Noto Serif CJK SC}
\setCJKsansfont[Scale=0.96,ItalicFont={Kaiti SC}]{Noto Sans CJK SC Light}
\RequirePackage{marginnote}
\RequirePackage{sidenotes}

% 定制英文字体
\setmainfont{TeX Gyre Termes}
\setsansfont{TeX Gyre Heros}
%\setmonofont{Noto Sans Mono CJK SC}
\setmonofont{FiraCode Nerd Font Mono}

% 定制公式

%% 数学
\RequirePackage{amsmath}

%% 重新定义\emph，参考https://tex.stackexchange.com/questions/227639/redefine-emph-to-be-both-bold-and-italic
\let\emph\relax % there's no \RedeclareTextFontCommand
\DeclareTextFontCommand{\emph}{\bfseries}

% CTeX标题定制，参考文档
\ctexset {
  part/pagestyle = empty,
  chapter = {
    format = \huge\bfseries\raggedleft,
    pagestyle = empty,
    aftertitle = \par\bigskip\nointerlineskip\rule{\linewidth}{1bp}\par,
    %afterskip = 10pt,
  },
  section = {
    format = \Large\bfseries\raggedright
  }
}

%% 定制页头
\RequirePackage{fancyhdr}
\fancyhf{}
\lhead{\textnormal{\rightmark}}
%\lhead{\textbf{\rightmark}}
\rhead{-\ \thepage\ -}
\pagestyle{fancy}


%% 定制sidenotes的样式，来自
%% https://tex.stackexchange.com/questions/532245/how-to-modify-fonts-in-sidenotes
% 定制\marginpar
\renewcommand*{\marginfont}{\scriptsize\captionsetup{font=scriptsize}}
\renewcommand*{\marginfont}{\scriptsize}

% 定制\marginnote
\RequirePackage{xparse}
\let\oldmarginpar\marginpar
\RenewDocumentCommand{\marginpar}{om}{%
  \IfNoValueTF{#1}
    {\oldmarginpar{\mymparsetup #2}}
    {\oldmarginpar[\mymparsetup #1]{\mymparsetup #2}}}
\newcommand{\mymparsetup}{\scriptsize}

% 定制sidenotes/figure*的caption
\DeclareCaptionStyle{widefigure}{font=normalsize}

% 每章重置sidenote的计数器
%\let\oldchapter\chapter
%\def\chapter{%
%  \setcounter{sidenote}{1}%
%  \oldchapter
%}

%% 插图
\RequirePackage{graphicx}
%\graphicspath{ {./images/} }

% 保证最后一页的浮动图在顶上，见 https://tex.stackexchange.com/questions/66252/placing-the-figure-exactly-at-the-top-of-the-page-in-latex
%\makeatletter
%\setlength{\@fptop}{0pt}
%\makeatother

%% 参考文献，用BibLaTeX而不是BibTeX。
\RequirePackage[backend=biber,style=alphabetic,url=false]{biblatex}

%% 定制交叉引用
\RequirePackage{cleveref}
\crefname{figure}{图}{图} % 更好的方式是以语言配置的形式提供，见 cleveref 文档第 10 节
\crefname{table}{表}{表} % 更好的方式是以语言配置的形式提供，见 cleveref 文档第 10 节
\crefname{equation}{公式}{公式} % 更好的方式是以语言配置的形式提供，见 cleveref 文档第 10 节

%% 代码列表用minted
\RequirePackage{minted}

%% 引语
\RequirePackage{csquotes}

%% 章节提要
\RequirePackage[skins]{tcolorbox}

\newtcolorbox{myframe}[2][]{%
  enhanced,colback=white,colframe=black,coltitle=black,
  sharp corners,boxrule=0.4pt,
  fonttitle=\bfseries,
  attach boxed title to top left={yshift=-0.5\baselineskip,xshift=2mm},
  boxed title style={tile,size=minimal,left=1mm,right=1mm,
    colback=white,before upper=\strut},
  title=#2,#1
}

\newenvironment{cabstract}{
  \removelastskip
  \vskip 10pt
  \begin{myframe}{本章要点}
      \begin{itemize}
      \vskip 5pt 
      \setlength{\itemsep}{0pt}
      \setlength{\parskip}{0pt}
      \setlength{\parsep}{0pt}
      \itshape
}
{
      \end{itemize}
  \end{myframe}
  \vskip 30pt
}

%% microtype
\RequirePackage{microtype}
