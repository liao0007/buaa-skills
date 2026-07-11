%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% buaa.cls — thin loader for modular report profiles
%% See buaa/reports/README.md to add or customize report types.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{buaa}[2026/07/11 v3.2 BUAA modular document class]
\typeout{This is LaTeX template buaa (modular). Profile: see `report' class option.}

\input{buaa/core/input}
\input{buaa/core/options}

\LoadClass[UTF8,zihao=-4,linespread=1.7]{ctexbook}
\setcounter{secnumdepth}{5}

\buaa@input{core/packages}
\buaa@input{core/helpers}
\buaa@input{core/math}
\buaa@input{core/metadata}
\buaa@input{core/layout}
\buaa@input{core/hooks}

\buaa@loadreport

\buaa@input{core/document}

\endinput
