% blurb.cls
% Prepare a photobook/magazine for blurb.com
% 2015 Mauro Faccin mauro.fccn at gmail.com


\ProvidesClass{blurb}[2005/09/01 version 0.1 of Blurb]
\NeedsTeXFormat{LaTeX2e}

%% New lenght provided by the class
\newlength{\blurbwidth}
\newlength{\blurbheight}
\newlength{\blurbbleeds}
\setlength{\blurbbleeds}{0.125in}

\RequirePackage[cmyk]{xcolor}
\RequirePackage{everypage}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Option declaration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\DeclareOption{magazinepro}{%
  %% 8.625 x 11.24 in
  %% 621 x 810 pts
  \setlength{\blurbwidth}{8.625in}
  \setlength{\blurbheight}{11.25in}
  %% PDF/X-3:2002 info
  %% The \pageattr values have to be in pt, compare with the page size settings above.
  \pdfpageattr{%
    /MediaBox [0 0 621.00000 810.00000]
    /BleedBox [0.00000 0.00000 621.00000 810.00000]
    /CropBox [0 0 621.00000 810.00000]
    %/TrimBox [0.00000 0.00000 621.00000 810.00000]
    /TrimBox [0.00000 9.00000 612.00000 801.00000]
  }
}
\DeclareOption{showbleeds}{%
  \AddEverypageHook{\drawbleeds}
}

%%All remaining options for the scrbook
\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{scrbook}
}

%% Execute default options
\ExecuteOptions{magazinepro}
%% Process all other options
\ProcessOptions\relax
\LoadClass{scrbook}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Load packages and latex code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{geometry}
\geometry{%
  paperwidth=\blurbwidth,
  paperheight=\blurbheight,
            % amount we 'lose' (visually) due to the binding
            % left and right pages are offset a bit to the sides
            % (typically looks better for most kinds of bindings)
            bindingoffset=0.25in,
            % set total to the dimensions of the printed part
            %total={8in,7.75in},
            % include header/footer/margin notes in printed area
            twoside, includeall, nomarginpar,
            ignorehead=false, ignorefoot=false, ignoremp=false,
            % center printed area on page
            %vcentering,hcentering,
            top = 1in, bottom=1in,
            inner = 1.0in, outer=1.7in,
}

\RequirePackage{titling}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PDF/X-3:2002 info
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\pdfobjcompresslevel=0%
\pdfminorversion=3%
\pdfcatalog{%
  /PageMode /UseNone
  /OutputIntents [ <<
    /Info (none)
    /Type /OutputIntent
    /S /GTS_PDFX
    /OutputConditionIdentifier (Blurb.com)
    /RegistryName (http://www.color.org/)
  >> ]
}%
\AtBeginDocument{%
  %% wait for title and author to be set by user
  %% Replace the title, author, etc. information accordingly to your book.
  \pdfinfo{%
    /Title (\thetitle)
    /Author (\theauthor)
    /Subject (photography)
    /Keywords (photography)
    /GTS_PDFXVersion (PDF/X-3:2002)
  }%
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Provided commands
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{tikz}
\RequirePackage{tikzpagenodes}
% provide nodes as:
% - current page text area
% - current page marginpar area
% - current page header area
% - current page footer area
\usetikzlibrary{calc, positioning, matrix}
\RequirePackage{xkeyval}

\makeatletter

\define@cmdkeys{putbox}{anchor,pageanchor}[center]
\define@cmdkeys{putbox}{xshift,yshift}[0pt]
\define@cmdkeys{putbox}{xsep,ysep}[.1in]
\define@cmdkeys{putbox}{pagenode}[current page]
\presetkeys{putbox}{anchor,pageanchor,pagenode,
  xshift,yshift,xsep,ysep}{}
\def\putbox{\@ifnextchar[{\@putbox}{\@putbox[]}}
\def\@putbox[#1]#2{%
  \setkeys{putbox}{#1}
  \begin{tikzpicture}[overlay,
                      remember picture,
                      shift=(\cmdKV@putbox@pagenode.\cmdKV@putbox@pageanchor)]
    \node[anchor=\cmdKV@putbox@anchor,inner sep=0pt] 
      at (\cmdKV@putbox@xshift,\cmdKV@putbox@yshift) (lastputbox) {#2};
  \end{tikzpicture}
}

\def\putmatrix{\@ifnextchar[{\@putmatrix}{\@putmatrix[]}}
\def\@putmatrix[#1]#2{%
  \setkeys{putbox}{#1}
  \begin{tikzpicture}[overlay,
                      remember picture,
                         every node/.style={inner sep=0pt},
                      shift=(\cmdKV@putbox@pagenode.\cmdKV@putbox@pageanchor)]
    \matrix [anchor=\cmdKV@putbox@anchor,
             ampersand replacement=\&,
             matrix of nodes,
             column sep=\cmdKV@putbox@xsep,
             row sep=\cmdKV@putbox@ysep,
             ] 
        at (\cmdKV@putbox@xshift,\cmdKV@putbox@yshift)  (lastputbox) {#2};
  \end{tikzpicture}
}

\renewcommand\caption[1]{%
  \putbox[anchor=north,
          pagenode=lastputbox,
          pageanchor=south,
          yshift=-.2in,
          ] {%
            \begin{minipage}{\textwidth}
              #1
            \end{minipage}
          }
}

\newcommand\drawbleeds{
  \begin{tikzpicture}[overlay,
                      remember picture,
                      shift=(current page.south west)]

    \ifodd\c@page
    \draw[black!50] (0,\blurbbleeds) rectangle
    ($(\blurbwidth-\blurbbleeds,\blurbheight-\blurbbleeds)$); 
    \else
      \draw[black!50] (\blurbbleeds,\blurbbleeds) rectangle
                   ($(\blurbwidth,\blurbheight-\blurbbleeds)$); 
    \fi
  \end{tikzpicture}
}

\makeatother
\endinput
