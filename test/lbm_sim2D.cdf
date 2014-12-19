(* Content-type: application/vnd.wolfram.cdf.text *)

(*** Wolfram CDF File ***)
(* http://www.wolfram.com/cdf *)

(* CreatedBy='Mathematica 10.0' *)

(*************************************************************************)
(*                                                                       *)
(*  The Mathematica License under which this file was created prohibits  *)
(*  restricting third parties in receipt of this file from republishing  *)
(*  or redistributing it by any means, including but not limited to      *)
(*  rights management or terms of use, without the express consent of    *)
(*  Wolfram Research, Inc. For additional information concerning CDF     *)
(*  licensing and redistribution see:                                    *)
(*                                                                       *)
(*        www.wolfram.com/cdf/adopting-cdf/licensing-options.html        *)
(*                                                                       *)
(*************************************************************************)

(*CacheID: 234*)
(* Internal cache information:
NotebookFileLineBreakTest
NotebookFileLineBreakTest
NotebookDataPosition[      1064,         20]
NotebookDataLength[    124525,       2934]
NotebookOptionsPosition[    121328,       2803]
NotebookOutlinePosition[    121878,       2826]
CellTagsIndexPosition[    121791,       2821]
WindowFrame->Normal*)

(* Beginning of Notebook Content *)
Notebook[{

Cell[CellGroupData[{
Cell["Lattice Boltzmann Method (LBM)", "Title"],

Cell[TextData[{
 "Implementation of the lattice Boltzmann method (LBM) using the D2Q9 and \
D3Q19 models\n\nCopyright (c) 2014, Christian B. Mendl\nAll rights reserved.\n\
",
 ButtonBox["http://christian.mendl.net",
  BaseStyle->"Hyperlink",
  ButtonData->{
    URL["http://christian.mendl.net"], None},
  ButtonNote->"http://christian.mendl.net"],
 "\n\nThis program is free software; you can redistribute it and/or\nmodify \
it under the terms of the Simplified BSD License\n",
 ButtonBox["http://www.opensource.org/licenses/bsd-license.php",
  BaseStyle->"Hyperlink",
  ButtonData->{
    URL["http://www.opensource.org/licenses/bsd-license.php"], None},
  ButtonNote->"http://www.opensource.org/licenses/bsd-license.php"],
 "\n\nReference:\n\tNils Th\[UDoubleDot]rey, Physically based animation of \
free surface flows with the lattice Boltzmann method,\n\tPhD thesis, \
University of Erlangen-Nuremberg (2007)"
}], "Text"],

Cell[BoxData[
 RowBox[{
  RowBox[{"SetDirectory", "[", 
   RowBox[{"NotebookDirectory", "[", "]"}], "]"}], ";"}]], "Input"],

Cell[BoxData[
 RowBox[{
  RowBox[{"lbmLink", "=", 
   RowBox[{"Install", "[", 
    RowBox[{"\"\<../mlink/\>\"", "<>", "$SystemID", "<>", "\"\</lbmWS\>\""}], 
    "]"}]}], ";"}]], "Input"],

Cell[BoxData[
 RowBox[{"(*", " ", 
  RowBox[{
   RowBox[{
   "to", " ", "use", " ", "the", " ", "traditional", " ", "MathLink", " ", 
    "interface"}], ",", " ", 
   RowBox[{
    RowBox[{
     RowBox[{"call", "\[IndentingNewLine]", "lbmLink"}], "=", 
     RowBox[{"Install", "[", 
      RowBox[{
      "\"\<../mlink/\>\"", "<>", "$SystemID", "<>", "\"\</lbmML\>\""}], 
      "]"}]}], ";"}]}], "*)"}]], "Input"],

Cell[CellGroupData[{

Cell["Common functions", "Section"],

Cell[BoxData[
 RowBox[{
  RowBox[{"vel", "=", 
   RowBox[{"{", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"0", ",", "0"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{
       RowBox[{"-", "1"}], ",", "0"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"1", ",", "0"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"0", ",", 
       RowBox[{"-", "1"}]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"0", ",", "1"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{
       RowBox[{"-", "1"}], ",", 
       RowBox[{"-", "1"}]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{
       RowBox[{"-", "1"}], ",", "1"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"1", ",", 
       RowBox[{"-", "1"}]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"1", ",", "1"}], "}"}]}], "}"}]}], ";"}]], "Input"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Graphics", "[", 
  RowBox[{
   RowBox[{"Arrow", "[", 
    RowBox[{
     RowBox[{
      RowBox[{"{", 
       RowBox[{
        RowBox[{"{", 
         RowBox[{"0", ",", "0"}], "}"}], ",", "#"}], "}"}], "&"}], "/@", 
     "vel"}], "]"}], ",", 
   RowBox[{"ImageSize", "\[Rule]", "Small"}]}], "]"}]], "Input"],

Cell[BoxData[
 GraphicsBox[
  ArrowBox[{{{0, 0}, {0, 0}}, {{0, 0}, {-1, 0}}, {{0, 0}, {1, 0}}, {{0, 0}, {
   0, -1}}, {{0, 0}, {0, 1}}, {{0, 0}, {-1, -1}}, {{0, 0}, {-1, 1}}, {{0, 
   0}, {1, -1}}, {{0, 0}, {1, 1}}}],
  ImageSize->Small]], "Output"]
}, Open  ]],

Cell[BoxData[
 RowBox[{
  RowBox[{"Density", "[", "f_", "]"}], ":=", 
  RowBox[{"Total", "[", "f", "]"}]}]], "Input"],

Cell[BoxData[
 RowBox[{
  RowBox[{"Velocity", "[", "f_", "]"}], ":=", 
  RowBox[{"Module", "[", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{"n", "=", 
      RowBox[{"Density", "[", "f", "]"}]}], "}"}], ",", 
    RowBox[{"If", "[", 
     RowBox[{
      RowBox[{"n", ">", "0"}], ",", 
      RowBox[{
       FractionBox["1", "n"], 
       RowBox[{"Sum", "[", 
        RowBox[{
         RowBox[{
          RowBox[{"f", "\[LeftDoubleBracket]", "i", "\[RightDoubleBracket]"}], 
          RowBox[{
          "vel", "\[LeftDoubleBracket]", "i", "\[RightDoubleBracket]"}]}], 
         ",", 
         RowBox[{"{", 
          RowBox[{"i", ",", 
           RowBox[{"Length", "[", "f", "]"}]}], "}"}]}], "]"}]}], ",", 
      RowBox[{"{", 
       RowBox[{"0", ",", "0"}], "}"}]}], "]"}]}], "]"}]}]], "Input"],

Cell[BoxData[
 RowBox[{
  RowBox[{"InternalEnergy", "[", "f_", "]"}], ":=", 
  RowBox[{"Module", "[", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{
      RowBox[{"n", "=", 
       RowBox[{"Density", "[", "f", "]"}]}], ",", 
      RowBox[{"u", "=", 
       RowBox[{"Velocity", "[", "f", "]"}]}]}], "}"}], ",", 
    RowBox[{"If", "[", 
     RowBox[{
      RowBox[{"n", ">", "0"}], ",", 
      RowBox[{
       FractionBox["1", "n"], 
       RowBox[{"Sum", "[", 
        RowBox[{
         RowBox[{
          FractionBox["1", "2"], 
          SuperscriptBox[
           RowBox[{"Norm", "[", 
            RowBox[{
             RowBox[{
             "vel", "\[LeftDoubleBracket]", "i", "\[RightDoubleBracket]"}], 
             "-", "u"}], "]"}], "2"], 
          RowBox[{
          "f", "\[LeftDoubleBracket]", "i", "\[RightDoubleBracket]"}]}], ",", 
         RowBox[{"{", 
          RowBox[{"i", ",", 
           RowBox[{"Length", "[", "f", "]"}]}], "}"}]}], "]"}]}], ",", "0"}], 
     "]"}]}], "]"}]}]], "Input"],

Cell[BoxData[
 RowBox[{
  RowBox[{"TotalEnergy", "[", "f_", "]"}], ":=", 
  RowBox[{"Module", "[", 
   RowBox[{
    RowBox[{"{", 
     RowBox[{"n", "=", 
      RowBox[{"Density", "[", "f", "]"}]}], "}"}], ",", 
    RowBox[{"If", "[", 
     RowBox[{
      RowBox[{"n", ">", "0"}], ",", 
      RowBox[{
       FractionBox["1", "n"], 
       RowBox[{"Sum", "[", 
        RowBox[{
         RowBox[{
          FractionBox["1", "2"], 
          SuperscriptBox[
           RowBox[{"Norm", "[", 
            RowBox[{
            "vel", "\[LeftDoubleBracket]", "i", "\[RightDoubleBracket]"}], 
            "]"}], "2"], 
          RowBox[{
          "f", "\[LeftDoubleBracket]", "i", "\[RightDoubleBracket]"}]}], ",", 
         RowBox[{"{", 
          RowBox[{"i", ",", 
           RowBox[{"Length", "[", "f", "]"}]}], "}"}]}], "]"}]}], ",", "0"}], 
     "]"}]}], "]"}]}]], "Input"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Define initial flow field", "Section"],

Cell[BoxData[{
 RowBox[{
  RowBox[{
   SubscriptBox["dim", "1"], "=", "16"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   SubscriptBox["dim", "2"], "=", "32"}], ";"}]}], "Input"],

Cell[BoxData[
 RowBox[{
  RowBox[{"ConstructFlowField", "[", "v_", "]"}], ":=", 
  RowBox[{
   RowBox[{
    RowBox[{"Exp", "[", 
     RowBox[{
      RowBox[{"ArcTan", "[", 
       RowBox[{
        RowBox[{"(", 
         RowBox[{"v", ".", "#"}], ")"}], "+", "0.1"}], "]"}], "-", 
      RowBox[{"3", "/", "2"}]}], "]"}], "&"}], "/@", "vel"}]}]], "Input"],

Cell[BoxData[{
 RowBox[{
  RowBox[{
   SubscriptBox["x", "list"], "=", 
   RowBox[{
    RowBox[{"Range", "[", 
     RowBox[{"0", ",", 
      RowBox[{
       SubscriptBox["dim", "1"], "-", "1"}]}], "]"}], "/", 
    SubscriptBox["dim", "1"]}]}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   SubscriptBox["y", "list"], "=", 
   RowBox[{
    RowBox[{"Range", "[", 
     RowBox[{"0", ",", 
      RowBox[{
       SubscriptBox["dim", "2"], "-", "1"}]}], "]"}], "/", 
    SubscriptBox["dim", "2"]}]}], ";"}]}], "Input"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{
   SubscriptBox["f", "0"], "=", 
   RowBox[{"N", "[", 
    RowBox[{"Table", "[", 
     RowBox[{
      RowBox[{"ConstructFlowField", "[", 
       RowBox[{
        RowBox[{"{", 
         RowBox[{
          RowBox[{"1", "/", "3"}], ",", 
          RowBox[{
           RowBox[{"-", "1"}], "/", "2"}]}], "}"}], "+", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{
           RowBox[{"Sin", "[", 
            RowBox[{"2", "\[Pi]", " ", 
             RowBox[{
              SubscriptBox["x", "list"], "\[LeftDoubleBracket]", "i", 
              "\[RightDoubleBracket]"}]}], "]"}], "+", 
           RowBox[{
            RowBox[{"Erf", "[", 
             RowBox[{"Cos", "[", 
              RowBox[{"2", "\[Pi]", " ", 
               RowBox[{
                SubscriptBox["x", "list"], "\[LeftDoubleBracket]", "i", 
                "\[RightDoubleBracket]"}]}], "]"}], "]"}], "/", "2"}]}], ",", 
          RowBox[{"2", 
           RowBox[{"Exp", "[", 
            RowBox[{"-", 
             SuperscriptBox[
              RowBox[{"Cos", "[", 
               RowBox[{"Sin", "[", 
                RowBox[{"\[Pi]", " ", 
                 RowBox[{
                  SubscriptBox["y", "list"], "\[LeftDoubleBracket]", "j", 
                  "\[RightDoubleBracket]"}]}], "]"}], "]"}], "2"]}], 
            "]"}]}]}], "}"}]}], "]"}], ",", 
      RowBox[{"{", 
       RowBox[{"i", ",", 
        SubscriptBox["dim", "1"]}], "}"}], ",", 
      RowBox[{"{", 
       RowBox[{"j", ",", 
        SubscriptBox["dim", "2"]}], "}"}]}], "]"}], "]"}]}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{"Dimensions", "[", 
  SubscriptBox["f", "0"], "]"}]}], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"16", ",", "32", ",", "9"}], "}"}]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", "example", " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{
   SubscriptBox["f", "0"], "\[LeftDoubleBracket]", 
   RowBox[{"3", ",", "4"}], "\[RightDoubleBracket]"}]}]], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{
  "0.24651526818750719`", ",", "0.08997087768788774`", ",", 
   "0.5928236012505507`", ",", "0.1834113738642624`", ",", 
   "0.32604370893037526`", ",", "0.08154252126593588`", ",", 
   "0.10259840388449434`", ",", "0.5321234439842528`", ",", 
   "0.6434097441849724`"}], "}"}]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{"initial", " ", "density"}], " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{"ListDensityPlot", "[", 
   RowBox[{
    RowBox[{"Flatten", "[", 
     RowBox[{
      RowBox[{"Table", "[", 
       RowBox[{
        RowBox[{"{", 
         RowBox[{
          RowBox[{
           SubscriptBox["x", "list"], "\[LeftDoubleBracket]", "i", 
           "\[RightDoubleBracket]"}], ",", 
          RowBox[{
           SubscriptBox["y", "list"], "\[LeftDoubleBracket]", "j", 
           "\[RightDoubleBracket]"}], ",", 
          RowBox[{"Density", "[", 
           RowBox[{
            SubscriptBox["f", "0"], "\[LeftDoubleBracket]", 
            RowBox[{"i", ",", "j"}], "\[RightDoubleBracket]"}], "]"}]}], 
         "}"}], ",", 
        RowBox[{"{", 
         RowBox[{"i", ",", 
          SubscriptBox["dim", "1"]}], "}"}], ",", 
        RowBox[{"{", 
         RowBox[{"j", ",", 
          SubscriptBox["dim", "2"]}], "}"}]}], "]"}], ",", "1"}], "]"}], ",", 
    RowBox[{"FrameLabel", "\[Rule]", 
     RowBox[{"{", 
      RowBox[{"\"\<x\>\"", ",", "\"\<y\>\""}], "}"}]}], ",", 
    RowBox[{"PlotLegends", "\[Rule]", "Automatic"}], ",", 
    RowBox[{"ColorFunction", "\[Rule]", 
     RowBox[{"(", 
      RowBox[{
       RowBox[{
        RowBox[{"ColorData", "[", "\"\<DeepSeaColors\>\"", "]"}], "[", 
        RowBox[{"1", "-", "#"}], "]"}], "&"}], ")"}]}]}], "]"}]}]], "Input"],

Cell[BoxData[
 TemplateBox[{GraphicsBox[
    GraphicsComplexBox[CompressedData["
1:eJyF2TuK3EAQAFCzN/FJ9g4+gsGxr9RHcKjQgYINFAxiEIMYmtH/L13BxrgD
v8TNQvNc7HqXoruraj5//f7l29un3+vtz9d/Vnj/1z9whn/iHH/gAt9wie+4
wg9c4yeO+IUb3OIO93jAI57wjBe84g3v+MAnvv7avCYH4u4Z/olz/IELfMMl
vuMKP3CNnzjiF25wizvc4wGPeMIzXvCKN7zjA5845d9zmxyIm+cMu+f4Axf4
hkt8xxV+4Bo/ccQv3OAWd7jHAx7xhGe84BVveMcHPnHKv/dyciDuOc6wec6x
e4FvuMR3XOEHrvETR/zCDW5xh3s84BFPeMYLXvGGd3zgE6f8++4mB+Le0xn2
HOfYPBfYvcR3XOEHrvETR/zCDW5xh3s84BFPeMYLXvGGd3zgE6f8W1clB+K+
wxn2ns6x57jA5rnE7hV+4Bo/ccQv3OAWd7jHAx7xhGe84BVveMcHPnHKv3Vz
ciBunZVh3+Ece08X2HNcYvNcYfcaP3HEL9zgFne4xwMe8YRnvOAVb3jHBz5x
yr99UXIgbh2dYeusHPsOF9h7usSe4wqb5xq7R/zCDW5xh3s84BFPeMYLXvGG
d3zgE1/83WklB+L2SRm2js6xdVaBfYdL7D1dYc9xjc1zxO4NbnGHezzgEU94
xgte8YZ3fOATX/xdaSUH4vbBGbZPyrF1dIGts0rsO1xh7+kae44jNs8Ndu9w
jwc84gnPeMEr3vCOD3zii987reRA3DlHhu2Dc2yfVGDr6BJbZ1XYd7jG3tMR
e44bbJ477D7gEU94xgte8YZ3fOATX/xeaSUH4s6xMuycI8f2wQW2TyqxdXSF
rbNq7Dscsfd0gz3HHTbPA3af8IwXvOIN7/jAJ774f9NKDsSdU2bYOVaOnXMU
2D64xPZJFbaOrrF1VsS+ww32nu6w53jA5nnC7gte8YZ3fOATX/zctJIDcefQ
GXZOmWPnWAV2zlFi++AK2yfV2Do6YuusBvsOd9h7esCe4wmb5wW7b3jHBz7x
xfellRyI+zlDhp1D59g5ZYGdY5XYOUeF7YNrbJ8UsXV0g62zOuw7PGDv6Ql7
jhdsnjfsfuATX/x7WsmBuJ8jZdjPGXLsHLrAzilL7Byrws45amwfHLF9UoOt
oztsnTVg3+EJe08v2HO8YfN8YPfr/RcBpDAc
     "], {{{
        EdgeForm[], 
        GrayLevel[0.8], 
        GraphicsGroupBox[{
          PolygonBox[CompressedData["
1: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
ead5yv8H/l3sf4ifpPZf7ur/j3N8kg==
           "]]}]}, {}, {}, {}, {}}}, VertexColors -> CompressedData["
1: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
kvwh+Unyn5QXKV8SDyR+SLyR+CTx/D/yTpeH
      "]], {
    DisplayFunction -> Identity, AspectRatio -> 1, DisplayFunction :> 
     Identity, Frame -> True, FrameLabel -> {{
        FormBox["\"y\"", TraditionalForm], None}, {
        FormBox["\"x\"", TraditionalForm], None}}, 
     FrameTicks -> {{Automatic, Automatic}, {Automatic, Automatic}}, 
     GridLinesStyle -> Directive[
       GrayLevel[0.5, 0.4]], 
     Method -> {
      "DefaultBoundaryStyle" -> Automatic, "DefaultColorFunction" -> 
       "M10DefaultDensityGradient"}, 
     PlotRange -> {{0., 0.9375}, {0., 0.96875}}, PlotRangeClipping -> True, 
     PlotRangePadding -> {
       Scaled[0.02], 
       Scaled[0.02]}, Ticks -> {Automatic, Automatic}}],FormBox[
    FormBox[
     TemplateBox[{
       FormBox[
        StyleBox[
         StyleBox[
          PaneBox[
           GraphicsBox[{
             RasterBox[CompressedData["
1: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
8at6epw5Df8DNDSP/A==
              "], {{
                Rational[-15, 2], 
                Rational[-225, 2]}, {
                Rational[15, 2], 
                Rational[225, 2]}}], {Antialiasing -> False, 
              AbsoluteThickness[0.1], 
              Directive[
               Opacity[0.3], 
               GrayLevel[0]], 
              LineBox[
               NCache[{{
                  Rational[15, 2], 
                  Rational[-225, 2]}, {
                  Rational[-15, 2], 
                  Rational[-225, 2]}, {
                  Rational[-15, 2], 
                  Rational[225, 2]}, {
                  Rational[15, 2], 
                  Rational[225, 2]}}, {{7.5, -112.5}, {-7.5, -112.5}, {-7.5, 
                112.5}, {7.5, 112.5}}]]}, {
              CapForm[None], {}}, {Antialiasing -> False, 
              StyleBox[
               
               LineBox[{{7.500000000000002, -112.50000000000003`}, {
                7.500000000000002, 112.50000000000003`}}], 
               Directive[
                AbsoluteThickness[0.2], 
                Opacity[0.3], 
                GrayLevel[0]], StripOnInput -> False], 
              StyleBox[
               StyleBox[{{
                  StyleBox[
                   LineBox[{{{7.500000000000002, -60.57692307692309}, 
                    
                    Offset[{4., 0}, {
                    7.500000000000002, -60.57692307692309}]}, {{
                    7.500000000000002, 8.653846153846155}, 
                    
                    Offset[{4., 0}, {7.500000000000002, 
                    8.653846153846155}]}, {{7.500000000000002, 
                    77.8846153846154}, 
                    Offset[{4., 0}, {7.500000000000002, 77.8846153846154}]}}], 
                   Directive[
                    AbsoluteThickness[0.2], 
                    GrayLevel[0.4]], StripOnInput -> False], 
                  StyleBox[
                   LineBox[{{{7.500000000000002, -112.50000000000003`}, 
                    
                    Offset[{2.5, 0.}, {
                    7.500000000000002, -112.50000000000003`}]}, {{
                    7.500000000000002, -95.19230769230771}, 
                    
                    Offset[{2.5, 0.}, {
                    7.500000000000002, -95.19230769230771}]}, {{
                    7.500000000000002, -77.8846153846154}, 
                    
                    Offset[{2.5, 0.}, {
                    7.500000000000002, -77.8846153846154}]}, {{
                    7.500000000000002, -43.26923076923078}, 
                    
                    Offset[{2.5, 0.}, {
                    7.500000000000002, -43.26923076923078}]}, {{
                    7.500000000000002, -25.961538461538467`}, 
                    
                    Offset[{2.5, 0.}, {
                    7.500000000000002, -25.961538461538467`}]}, {{
                    7.500000000000002, -8.653846153846155}, 
                    
                    Offset[{2.5, 0.}, {
                    7.500000000000002, -8.653846153846155}]}, {{
                    7.500000000000002, 25.961538461538467`}, 
                    
                    Offset[{2.5, 0.}, {7.500000000000002, 
                    25.961538461538467`}]}, {{7.500000000000002, 
                    43.26923076923078}, 
                    
                    Offset[{2.5, 0.}, {7.500000000000002, 
                    43.26923076923078}]}, {{7.500000000000002, 
                    60.57692307692309}, 
                    
                    Offset[{2.5, 0.}, {7.500000000000002, 
                    60.57692307692309}]}, {{7.500000000000002, 
                    95.19230769230771}, 
                    
                    Offset[{2.5, 0.}, {7.500000000000002, 
                    95.19230769230771}]}, {{7.500000000000002, 
                    112.50000000000003`}, 
                    
                    Offset[{2.5, 0.}, {7.500000000000002, 
                    112.50000000000003`}]}}], 
                   Directive[
                    AbsoluteThickness[0.2], 
                    GrayLevel[0.4], 
                    Opacity[0.3]], StripOnInput -> False]}, 
                 StyleBox[
                  StyleBox[{{
                    StyleBox[{
                    InsetBox[
                    FormBox[
                    TagBox[
                    InterpretationBox["\"2.4\"", 2.4, AutoDelete -> True], 
                    NumberForm[#, {
                    DirectedInfinity[1], 1}]& ], TraditionalForm], 
                    
                    Offset[{7., 0.}, {
                    7.500000000000002, -60.57692307692309}], {-1, 0.}, 
                    Automatic, {1, 0}], 
                    InsetBox[
                    FormBox[
                    TagBox[
                    InterpretationBox["\"2.6\"", 2.6, AutoDelete -> True], 
                    NumberForm[#, {
                    DirectedInfinity[1], 1}]& ], TraditionalForm], 
                    
                    Offset[{7., 0.}, {7.500000000000002, 
                    8.653846153846155}], {-1, 0.}, Automatic, {1, 0}], 
                    InsetBox[
                    FormBox[
                    TagBox[
                    InterpretationBox["\"2.8\"", 2.8, AutoDelete -> True], 
                    NumberForm[#, {
                    DirectedInfinity[1], 1}]& ], TraditionalForm], 
                    
                    Offset[{7., 0.}, {7.500000000000002, 
                    77.8846153846154}], {-1, 0.}, Automatic, {1, 0}]}, 
                    Directive[
                    AbsoluteThickness[0.2], 
                    GrayLevel[0.4]], {
                    Directive[
                    Opacity[1]], 
                    Directive[
                    Opacity[1]]}, StripOnInput -> False], 
                    StyleBox[{{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}}, 
                    Directive[
                    AbsoluteThickness[0.2], 
                    GrayLevel[0.4], 
                    Opacity[0.3]], {
                    Directive[
                    Opacity[1]], 
                    Directive[
                    Opacity[1]]}, StripOnInput -> False]}, {}}, {
                    Directive[
                    Opacity[1]], 
                    Directive[
                    Opacity[1]]}, StripOnInput -> False], "GraphicsLabel", 
                  StripOnInput -> False]}, "GraphicsTicks", StripOnInput -> 
                False], 
               Directive[
                AbsoluteThickness[0.2], 
                Opacity[0.3], 
                GrayLevel[0]], StripOnInput -> False]}}, PlotRangePadding -> 
            Scaled[0.02], PlotRange -> All, Frame -> True, 
            FrameTicks -> {{False, False}, {True, False}}, FrameStyle -> 
            Opacity[0], FrameTicksStyle -> Opacity[0], 
            ImageSize -> {Automatic, 225}, BaseStyle -> {}], Alignment -> 
           Left, AppearanceElements -> None, ImageMargins -> {{5, 5}, {5, 5}},
            ImageSizeAction -> "ResizeToFit"], LineIndent -> 0, StripOnInput -> 
          False], {FontFamily -> "Arial"}, Background -> Automatic, 
         StripOnInput -> False], TraditionalForm]}, "BarLegend", 
      DisplayFunction -> (#& ), 
      InterpretationFunction :> (RowBox[{"BarLegend", "[", 
         RowBox[{
           RowBox[{"{", 
             RowBox[{
               RowBox[{
                 RowBox[{
                   RowBox[{"ColorData", "[", "\"DeepSeaColors\"", "]"}], "[", 
                   RowBox[{"1", "-", "#1"}], "]"}], "&"}], ",", 
               RowBox[{"{", 
                 RowBox[{"2.250449992209484`", ",", "2.9003921142794153`"}], 
                 "}"}]}], "}"}], ",", 
           RowBox[{"LabelStyle", "\[Rule]", 
             RowBox[{"{", "}"}]}], ",", 
           RowBox[{"LegendLayout", "\[Rule]", "\"Column\""}], ",", 
           RowBox[{"Charting`TickSide", "\[Rule]", "Right"}], ",", 
           RowBox[{"ColorFunctionScaling", "\[Rule]", "True"}]}], "]"}]& )], 
     TraditionalForm], TraditionalForm]},
  "Legended",
  DisplayFunction->(GridBox[{{
      TagBox[
       ItemBox[
        PaneBox[
         TagBox[#, "SkipImageSizeLevel"], Alignment -> {Center, Baseline}, 
         BaselinePosition -> Baseline], DefaultBaseStyle -> "Labeled"], 
       "SkipImageSizeLevel"], 
      ItemBox[#2, DefaultBaseStyle -> "LabeledLabel"]}}, 
    GridBoxAlignment -> {"Columns" -> {{Center}}, "Rows" -> {{Center}}}, 
    AutoDelete -> False, GridBoxItemSize -> Automatic, 
    BaselinePosition -> {1, 1}]& ),
  Editable->True,
  InterpretationFunction->(RowBox[{"Legended", "[", 
     RowBox[{#, ",", 
       RowBox[{"Placed", "[", 
         RowBox[{#2, ",", "After"}], "]"}]}], "]"}]& )]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{"initial", " ", "velocity"}], " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{"ListVectorPlot", "[", 
   RowBox[{
    RowBox[{"Table", "[", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{
        RowBox[{"{", 
         RowBox[{
          RowBox[{
           SubscriptBox["x", "list"], "\[LeftDoubleBracket]", "i", 
           "\[RightDoubleBracket]"}], ",", 
          RowBox[{
           SubscriptBox["y", "list"], "\[LeftDoubleBracket]", "j", 
           "\[RightDoubleBracket]"}]}], "}"}], ",", 
        RowBox[{"Velocity", "[", 
         RowBox[{
          SubscriptBox["f", "0"], "\[LeftDoubleBracket]", 
          RowBox[{"i", ",", "j"}], "\[RightDoubleBracket]"}], "]"}]}], "}"}], 
      ",", 
      RowBox[{"{", 
       RowBox[{"i", ",", 
        SubscriptBox["dim", "1"]}], "}"}], ",", 
      RowBox[{"{", 
       RowBox[{"j", ",", 
        SubscriptBox["dim", "2"]}], "}"}]}], "]"}], ",", 
    RowBox[{"FrameLabel", "\[Rule]", 
     RowBox[{"{", 
      RowBox[{"\"\<x\>\"", ",", "\"\<y\>\""}], "}"}]}], ",", 
    RowBox[{"VectorStyle", "\[Rule]", "Blue"}]}], "]"}]}]], "Input"],

Cell[BoxData[
 GraphicsBox[{{}, 
   {RGBColor[0, 0, 1], 
    {Arrowheads[{{0.03331469103333221, 1.}}], 
     ArrowBox[{{-0.03310154622613126, -0.00950975934063522}, {
      0.03310154622613126, 0.00950975934063522}}]}, 
    {Arrowheads[{{0.03352090666905823, 1.}}], 
     ArrowBox[{{-0.03290501588393874, 0.058327315939050266`}, {
      0.03290501588393874, 0.08006554120380688}}]}, 
    {Arrowheads[{{0.034246347438657614`, 1.}}], 
     ArrowBox[{{-0.0322028309438809, 0.1236824784049341}, {0.0322028309438809,
       0.1531032358807802}}]}, 
    {Arrowheads[{{0.03564067178948615, 1.}}], 
     ArrowBox[{{-0.0308158186928648, 0.18739163032176293`}, {
      0.0308158186928648, 0.22778694110680853`}}]}, 
    {Arrowheads[{{0.03752911298056755, 1.}}], 
     ArrowBox[{{-0.02887075615361314, 0.2508682900021458}, {
      0.02887075615361314, 0.3027031385692828}}]}, 
    {Arrowheads[{{0.03936502445744516, 1.}}], 
     ArrowBox[{{-0.02691884026477038, 0.3154619409549647}, {
      0.02691884026477038, 0.3765023447593211}}]}, 
    {Arrowheads[{{0.04065495477292928, 1.}}], 
     ArrowBox[{{-0.025518102954786608`, 0.3817832508010399}, {
      0.025518102954786608`, 0.4485738920561031}}]}, 
    {Arrowheads[{{0.041207433202613275`, 1.}}], 
     ArrowBox[{{-0.024911764846025444`, 0.44981837144298276`}, {
      0.024911764846025444`, 0.5189316285570175}}]}, 
    {Arrowheads[{{0.04099869637284257, 1.}}], 
     ArrowBox[{{-0.025141241664026828`, 0.5194490636444501}, {
      0.025141241664026828`, 0.5876937934984073}}]}, 
    {Arrowheads[{{0.04003312209400328, 1.}}], 
     ArrowBox[{{-0.026195995672346224`, 0.5907277581216263}, {
      0.026195995672346224`, 0.6548079561640883}}]}, 
    {Arrowheads[{{0.0384007698961442, 1.}}], 
     ArrowBox[{{-0.027950679329989812`, 0.6637733911569048}, {
      0.027950679329989812`, 0.720155180271667}}]}, 
    {Arrowheads[{{0.03646006866563533, 1.}}], 
     ArrowBox[{{-0.02998036303381232, 0.7383160799231816}, {
      0.02998036303381232, 0.7840053486482476}}]}, 
    {Arrowheads[{{0.034792590450863255`, 1.}}], 
     ArrowBox[{{-0.03166494029943598, 0.8132968663012121}, {
      0.03166494029943598, 0.8474174194130742}}]}, 
    {Arrowheads[{{0.03377209093708931, 1.}}], 
     ArrowBox[{{-0.032663533360503955`, 0.8872232868056987}, {
      0.032663533360503955`, 0.9118838560514447}}]}, 
    {Arrowheads[{{0.033354951340477, 1.}}], 
     ArrowBox[{{-0.03306323224276991, 0.9589602515210215}, {
      0.03306323224276991, 0.9785397484789792}}]}, 
    {Arrowheads[{{0.04125083613403, 1.}}], 
     ArrowBox[{{0.02498812293434348, -0.007522185003244711}, {
      0.10894044849422793`, 0.007522185003244711}}]}, 
    {Arrowheads[{{0.041312387464560826`, 1.}}], 
     ArrowBox[{{0.025131867959107178`, 0.060590530706768786`}, {
      0.10879670346946424`, 0.07780232643608836}}]}, 
    {Arrowheads[{{0.04153308106725771, 1.}}], 
     ArrowBox[{{0.02565019883427775, 0.12670102526433033`}, {
      0.10827837259429368`, 0.15008468902138397`}}]}, 
    {Arrowheads[{{0.04197925338589933, 1.}}], 
     ArrowBox[{{0.026701835636830665`, 0.1913933113322802}, {
      0.10722673579174075`, 0.22378526009629124`}}]}, 
    {Arrowheads[{{0.042640352340206765`, 1.}}], 
     ArrowBox[{{0.028262782923079342`, 0.25568228153258554`}, {
      0.10566578850549208`, 0.2978891470388431}}]}, 
    {Arrowheads[{{0.04336406574568151, 1.}}], 
     ArrowBox[{{0.02996906609593334, 0.32066346822998865`}, {
      0.10395950533263809`, 0.3713008174842972}}]}, 
    {Arrowheads[{{0.04393321174962333, 1.}}], 
     ArrowBox[{{0.03130441597271756, 0.3870510955652792}, {
      0.10262415545585385`, 0.4433060472918638}}]}, 
    {Arrowheads[{{0.044194925464934254`, 1.}}], 
     ArrowBox[{{0.031915756914389526`, 0.45506576340531973`}, {
      0.10201281451418191`, 0.5136842365946804}}]}, 
    {Arrowheads[{{0.04409469179364076, 1.}}], 
     ArrowBox[{{0.03168189027603016, 0.5247075153904581}, {
      0.10224668115254128`, 0.5824353417523992}}]}, 
    {Arrowheads[{{0.043651862153550054`, 1.}}], 
     ArrowBox[{{0.030645340521980424`, 0.5959839104219582}, {
      0.10328323090659101`, 0.6495518038637563}}]}, 
    {Arrowheads[{{0.04297258584621969, 1.}}], 
     ArrowBox[{{0.02904696869211531, 0.6688161406987838}, {
      0.10488160273645611`, 0.715112430729788}}]}, 
    {Arrowheads[{{0.04225713263506826, 1.}}], 
     ArrowBox[{{0.027358061813832338`, 0.7427287365773387}, {
      0.10657050961473907`, 0.7795926919940902}}]}, 
    {Arrowheads[{{0.041704188335820444`, 1.}}], 
     ArrowBox[{{0.02605313808880911, 0.8167537583390954}, {
      0.10787543333976232`, 0.843960527375191}}]}, 
    {Arrowheads[{{0.04138799932361302, 1.}}], 
     ArrowBox[{{0.025309248785194374`, 0.8897784270336389}, {
      0.10861932264337704`, 0.9093287158235046}}]}, 
    {Arrowheads[{{0.04126280072561476, 1.}}], 
     ArrowBox[{{0.025016108106292304`, 0.961004872652837}, {
      0.10891246332227911`, 0.9764951273471637}}]}, 
    {Arrowheads[{{0.04480696316657556, 1.}}], 
     ArrowBox[{{0.08806971829429247, -0.006527834073544316}, {
      0.17978742456285038`, 0.006527834073544316}}]}, 
    {Arrowheads[{{0.04483387301555534, 1.}}], 
     ArrowBox[{{0.08818518298057154, 0.06172866781495446}, {
      0.1796719598765713, 0.0766641893279027}}]}, 
    {Arrowheads[{{0.044931226077831295`, 1.}}], 
     ArrowBox[{{0.08860016748923863, 0.12824887616055766`}, {
      0.17925697536790422`, 0.14853683812515664`}}]}, 
    {Arrowheads[{{0.04513307053438023, 1.}}], 
     ArrowBox[{{0.0894374219402162, 0.1935347292244557}, {
      0.17841972091692662`, 0.22164384220411576`}}]}, 
    {Arrowheads[{{0.045444378670683364`, 1.}}], 
     ArrowBox[{{0.09067756311328323, 0.2584423590841125}, {0.1771795797438596,
       0.29512906948731615`}}]}, 
    {Arrowheads[{{0.04580202407710531, 1.}}], 
     ArrowBox[{{0.09204739921928512, 0.32389204242841596`}, {
      0.1758097436378577, 0.3680722432858699}}]}, 
    {Arrowheads[{{0.04609652960350726, 1.}}], 
     ArrowBox[{{0.09314385114805512, 0.39053031694845297`}, {
      0.17471329170908773`, 0.43982682590869004`}}]}, 
    {Arrowheads[{{0.04623621186695887, 1.}}], 
     ArrowBox[{{0.09365613509679419, 0.4586292356938471}, {
      0.17420100776034866`, 0.5101207643061532}}]}, 
    {Arrowheads[{{0.04618238017312888, 1.}}], 
     ArrowBox[{{0.09345929175090578, 0.5282409344041238}, {
      0.17439785110623704`, 0.5789019227387336}}]}, 
    {Arrowheads[{{0.04594940601119728, 1.}}], 
     ArrowBox[{{0.09259921852267736, 0.5993511624326168}, {0.1752579243344655,
       0.6461845518530979}}]}, 
    {Arrowheads[{{0.04560631355787318, 1.}}], 
     ArrowBox[{{0.0913040036097672, 0.6718140437830873}, {
      0.17655313924737565`, 0.7121145276454846}}]}, 
    {Arrowheads[{{0.04526214048491291, 1.}}], 
     ArrowBox[{{0.08995842032377341, 0.7451579666850188}, {
      0.17789872253336944`, 0.7771634618864103}}]}, 
    {Arrowheads[{{0.045007834702204534`, 1.}}], 
     ArrowBox[{{0.08892154403903921, 0.8185547832764732}, {
      0.17893559881810361`, 0.842159502437813}}]}, 
    {Arrowheads[{{0.04486704303838585, 1.}}], 
     ArrowBox[{{0.08832742511617728, 0.8910718047265769}, {0.1795297177409656,
       0.9080353381305665}}]}, 
    {Arrowheads[{{0.0448121785086221, 1.}}], 
     ArrowBox[{{0.0880922111720696, 0.9620287929233851}, {
      0.17976493168507324`, 0.9754712070766156}}]}, 
    {Arrowheads[{{0.04532475265008718, 1.}}], 
     ArrowBox[{{0.15447281774066673`, -0.006379946526765315}, {
      0.24731289654504757`, 0.006379946526765315}}]}, 
    {Arrowheads[{{0.045347656695278495`, 1.}}], 
     ArrowBox[{{0.15458435096569648`, 0.061898104883536496`}, {
      0.24720136332001783`, 0.07649475225932065}}]}, 
    {Arrowheads[{{0.04543073760580893, 1.}}], 
     ArrowBox[{{0.15498487929758656`, 0.1284801814493898}, {
      0.24680083498812774`, 0.14830553283632447`}}]}, 
    {Arrowheads[{{0.04560421360397509, 1.}}], 
     ArrowBox[{{0.1557916015093837, 0.19385764087627977`}, {
      0.24599411277633065`, 0.2213209305522917}}]}, 
    {Arrowheads[{{0.0458744697472691, 1.}}], 
     ArrowBox[{{0.15698413843952108`, 0.2588656815824144}, {
      0.24480157584619322`, 0.2947057469890142}}]}, 
    {Arrowheads[{{0.0461881425257932, 1.}}], 
     ArrowBox[{{0.1583001973112536, 0.32439903106952384`}, {
      0.2434855169744607, 0.367565254644762}}]}, 
    {Arrowheads[{{0.046448574744834374`, 1.}}], 
     ArrowBox[{{0.15935451807366596`, 0.39108883364081287`}, {
      0.24243119621204834`, 0.43926830921633014`}}]}, 
    {Arrowheads[{{0.04657271404242982, 1.}}], 
     ArrowBox[{{0.15984783105285238`, 0.4592076371000625}, {
      0.24193788323286192`, 0.5095423628999377}}]}, 
    {Arrowheads[{{0.04652482572798248, 1.}}], 
     ArrowBox[{{0.15965820849664258`, 0.5288119984671718}, {
      0.24212750578907172`, 0.5783308586756857}}]}, 
    {Arrowheads[{{0.04631824587051192, 1.}}], 
     ArrowBox[{{0.15883060648052086`, 0.5998856584688173}, {
      0.24295510780519344`, 0.6456500558168974}}]}, 
    {Arrowheads[{{0.04601611371550444, 1.}}], 
     ArrowBox[{{0.1575859848889606, 0.6722785482055553}, {0.2441997293967537, 
      0.7116500232230166}}]}, 
    {Arrowheads[{{0.04571590146743471, 1.}}], 
     ArrowBox[{{0.15629286320321453`, 0.7455267064368851}, {
      0.24549285108249977`, 0.7767947221345438}}]}, 
    {Arrowheads[{{0.045496393399454264`, 1.}}], 
     ArrowBox[{{0.15529473492692467`, 0.8188247965031998}, {
      0.24649097935878964`, 0.8418894892110865}}]}, 
    {Arrowheads[{{0.04537591806265064, 1.}}], 
     ArrowBox[{{0.15472169406091976`, 0.8912645930785749}, {
      0.24706402022479454`, 0.9078425497785686}}]}, 
    {Arrowheads[{{0.04532918774316773, 1.}}], 
     ArrowBox[{{0.1544945478043207, 0.9621811068106597}, {
      0.24729116648139354`, 0.975318893189341}}]}, 
    {Arrowheads[{{0.04304029950357083, 1.}}], 
     ArrowBox[{{0.22392179346347701`, -0.00703343148077718}, {
      0.31179249225080863`, 0.00703343148077718}}]}, 
    {Arrowheads[{{0.04308244794456379, 1.}}], 
     ArrowBox[{{0.2240517845496519, 0.0611494361549142}, {
      0.31166250116463384`, 0.07724342098794296}}]}, 
    {Arrowheads[{{0.04323404380423473, 1.}}], 
     ArrowBox[{{0.2245202321717211, 0.1274584974496257}, {0.3111940535425646, 
      0.14932721683608863`}}]}, 
    {Arrowheads[{{0.0435434334695878, 1.}}], 
     ArrowBox[{{0.2254702830206597, 0.19243357935242975`}, {0.310244002693626,
       0.22274499207614173`}}]}, 
    {Arrowheads[{{0.044009591298396364`, 1.}}], 
     ArrowBox[{{0.22688397223794238`, 0.2570079697535844}, {
      0.3088303134763434, 0.29656345881784413`}}]}, 
    {Arrowheads[{{0.044531702249806966`, 1.}}], 
     ArrowBox[{{0.22844226767452397`, 0.3221948968024067}, {
      0.30727201803976173`, 0.3697693889118791}}]}, 
    {Arrowheads[{{0.044952181773485145`, 1.}}], 
     ArrowBox[{{0.22967735307160214`, 0.3886855302778851}, {
      0.30603693264268356`, 0.4416716125792579}}]}, 
    {Arrowheads[{{0.04514875189892846, 1.}}], 
     ArrowBox[{{0.23024867292273785`, 0.45673247888379276`}, {
      0.3054656127915478, 0.5120175211162075}}]}, 
    {Arrowheads[{{0.04507321577662276, 1.}}], 
     ArrowBox[{{0.23002963687285613`, 0.5263629303738834}, {
      0.30568464884142954`, 0.580779926768974}}]}, 
    {Arrowheads[{{0.04474315988883459, 1.}}], 
     ArrowBox[{{0.22906572480715745`, 0.597573281574485}, {0.3066485609071283,
       0.6479624327112297}}]}, 
    {Arrowheads[{{0.04424763420514163, 1.}}], 
     ArrowBox[{{0.22759790055276885`, 0.6702477893202321}, {
      0.3081163851615169, 0.7136807821083399}}]}, 
    {Arrowheads[{{0.04373819404866433, 1.}}], 
     ArrowBox[{{0.22606373888825185`, 0.7439032510078075}, {
      0.3096505468260339, 0.7784181775636216}}]}, 
    {Arrowheads[{{0.04335222013193293, 1.}}], 
     ArrowBox[{{0.22488422257990492`, 0.8176326830808865}, {
      0.3108300631343808, 0.8430816026333997}}]}, 
    {Arrowheads[{{0.04313428320830532, 1.}}], 
     ArrowBox[{{0.22421213832134024`, 0.8904128219905711}, {
      0.3115021473929454, 0.9086943208665723}}]}, 
    {Arrowheads[{{0.04304848352225847, 1.}}], 
     ArrowBox[{{0.22394710422965758`, 0.9615080688163989}, {
      0.3117671814846281, 0.9759919311836016}}]}, 
    {Arrowheads[{{0.03740063580782206, 1.}}], 
     ArrowBox[{{0.297114557059116, -0.008552010935630001}, {
      0.37252830008374116`, 0.008552010935630001}}]}, 
    {Arrowheads[{{0.03751693749246771, 1.}}], 
     ArrowBox[{{0.2972902649097042, 0.059415392030650646`}, {
      0.37235259223315287`, 0.0789774651122065}}]}, 
    {Arrowheads[{{0.03793185839765088, 1.}}], 
     ArrowBox[{{0.2979216300977394, 0.1251218876279355}, {
      0.37172122704511773`, 0.1516638266577788}}]}, 
    {Arrowheads[{{0.038757467284972806`, 1.}}], 
     ArrowBox[{{0.29918764728947034`, 0.18926950594431635`}, {
      0.37045520985338676`, 0.22590906548425507`}}]}, 
    {Arrowheads[{{0.03994138027203788, 1.}}], 
     ArrowBox[{{0.30101536966065, 0.2530769131805486}, {0.3686274874822071, 
      0.30049451539088}}]}, 
    {Arrowheads[{{0.0411743823656909, 1.}}], 
     ArrowBox[{{0.30292709931397127`, 0.3177935202233887}, {
      0.3667157578288859, 0.37417076549089706`}}]}, 
    {Arrowheads[{{0.04209432241201666, 1.}}], 
     ArrowBox[{{0.30435639581178936`, 0.3841045403026679}, {
      0.3652864613310677, 0.44625260255447513`}}]}, 
    {Arrowheads[{{0.04250264083014841, 1.}}], 
     ArrowBox[{{0.30499148819835237`, 0.45211349306233795`}, {
      0.3646513689445047, 0.5166365069376623}}]}, 
    {Arrowheads[{{0.04234734310503085, 1.}}], 
     ArrowBox[{{0.3047499301277455, 0.5217555125450206}, {0.3648929270151116, 
      0.5853873445978368}}]}, 
    {Arrowheads[{{0.041645087915325896`, 1.}}], 
     ArrowBox[{{0.3036582583585146, 0.5930632049490485}, {0.3659845987843424, 
      0.652472509336666}}]}, 
    {Arrowheads[{{0.04051606316389541, 1.}}], 
     ArrowBox[{{0.3019057532583388, 0.6660619591005132}, {
      0.36773710388451825`, 0.7178666123280586}}]}, 
    {Arrowheads[{{0.03926133779459033, 1.}}], 
     ArrowBox[{{0.2999644118639047, 0.740366910889405}, {0.36967844527895244`,
       0.781954517682024}}]}, 
    {Arrowheads[{{0.03825072674777244, 1.}}], 
     ArrowBox[{{0.2984094093442044, 0.8149350680963526}, {0.3712334477986527, 
      0.8457792176179336}}]}, 
    {Arrowheads[{{0.037659531426335074`, 1.}}], 
     ArrowBox[{{0.29750674809432515`, 0.8884482575227185}, {
      0.3721361090485319, 0.910658885334425}}]}, 
    {Arrowheads[{{0.03742327650095541, 1.}}], 
     ArrowBox[{{0.2971487811739651, 0.9599450477794466}, {0.372494075968892, 
      0.977554952220554}}]}, 
    {Arrowheads[{{0.02688014395254277, 1.}}], 
     ArrowBox[{{0.376205039908163, -0.010854963853567823`}, {
      0.4273663886632655, 0.010854963853567823`}}]}, 
    {Arrowheads[{{0.027313764612594386`, 1.}}], 
     ArrowBox[{{0.37640948482152836`, 0.05681245493690157}, {
      0.42716194374990013`, 0.08158040220595558}}]}, 
    {Arrowheads[{{0.028783017834624888`, 1.}}], 
     ArrowBox[{{0.377126027024437, 0.12174051107498689`}, {
      0.42644540154699156`, 0.1550452032107274}}]}, 
    {Arrowheads[{{0.03138870558518771, 1.}}], 
     ArrowBox[{{0.3784824940763723, 0.18500776099246805`}, {
      0.42508893449505614`, 0.23017081043610343`}}]}, 
    {Arrowheads[{{0.034546050142631055`, 1.}}], 
     ArrowBox[{{0.38027077049063535`, 0.24828029354402822`}, {
      0.4233006580807931, 0.3052911350274004}}]}, 
    {Arrowheads[{{0.03729690790434409, 1.}}], 
     ArrowBox[{{0.38195431741330765`, 0.3129158456986019}, {
      0.4216171111581208, 0.3790484400156839}}]}, 
    {Arrowheads[{{0.03908228709333831, 1.}}], 
     ArrowBox[{{0.38310570164838026`, 0.37935316930727936`}, {
      0.4204657269230482, 0.45100397354986366`}}]}, 
    {Arrowheads[{{0.03981593152571667, 1.}}], 
     ArrowBox[{{0.3835913622451546, 0.44745306463197887`}, {
      0.4199800663262739, 0.5212969353680214}}]}, 
    {Arrowheads[{{0.03954076301432654, 1.}}], 
     ArrowBox[{{0.3834084004083252, 0.5170584055748932}, {0.4201630281631033, 
      0.5900844515679641}}]}, 
    {Arrowheads[{{0.038235027374278203`, 1.}}], 
     ArrowBox[{{0.3825538422756688, 0.5882348681701471}, {
      0.42101758629575975`, 0.6573008461155675}}]}, 
    {Arrowheads[{{0.0358862658891417, 1.}}], 
     ArrowBox[{{0.38107682094153567`, 0.6611831938666441}, {
      0.42249460762989277`, 0.7227453775619276}}]}, 
    {Arrowheads[{{0.03280551184135367, 1.}}], 
     ArrowBox[{{0.37926560232663986`, 0.7358030421231159}, {
      0.4243058262447887, 0.7865183864483131}}]}, 
    {Arrowheads[{{0.029835697752879125`, 1.}}], 
     ArrowBox[{{0.37766093123061906`, 0.811138834277823}, {0.4259104973408094,
       0.8495754514364632}}]}, 
    {Arrowheads[{{0.02783224103978666, 1.}}], 
     ArrowBox[{{0.37665830836527014`, 0.8855362154050644}, {
      0.42691312020615835`, 0.913570927452079}}]}, 
    {Arrowheads[{{0.026965416388093747`, 1.}}], 
     ArrowBox[{{0.3762450271031912, 0.9575794337430638}, {
      0.42732640146823725`, 0.979920566256937}}]}, 
    {Arrowheads[{{0.013472380020700881`, 1.}}], 
     ArrowBox[{{0.4629162584360753, -0.012647015137966726`}, {
      0.47458374156392463`, 0.012647015137966726`}}]}, 
    {Arrowheads[{{0.014993167269885565`, 1.}}], 
     ArrowBox[{{0.4629793252135511, 0.05481087568089548}, {
      0.47452067478644877`, 0.08358198146196166}}]}, 
    {Arrowheads[{{0.019284247835084894`, 1.}}], 
     ArrowBox[{{0.4631965922805635, 0.11924603851959369`}, {
      0.47430340771943635`, 0.15753967576612063`}}]}, 
    {Arrowheads[{{0.02515863893865996, 1.}}], 
     ArrowBox[{{0.46359100121710256`, 0.18209725102897917`}, {
      0.47390899878289733`, 0.23308132039959226`}}]}, 
    {Arrowheads[{{0.030783369670739753`, 1.}}], 
     ArrowBox[{{0.46407662011018136`, 0.2453070980984827}, {
      0.47342337988981853`, 0.30826433047294594`}}]}, 
    {Arrowheads[{{0.03492175741286782, 1.}}], 
     ArrowBox[{{0.4645001859560063, 0.3101312818595518}, {0.4729998140439936, 
      0.38183300385473395`}}]}, 
    {Arrowheads[{{0.03735350321232978, 1.}}], 
     ArrowBox[{{0.46477342541393213`, 0.3767680729368286}, {
      0.47272657458606776`, 0.4535890699203144}}]}, 
    {Arrowheads[{{0.038307822004809616`, 1.}}], 
     ArrowBox[{{0.464885196598675, 0.4449616725762594}, {0.47261480340132483`,
       0.5237883274237409}}]}, 
    {Arrowheads[{{0.037952635758368825`, 1.}}], 
     ArrowBox[{{0.46484331326263545`, 0.5145312364636159}, {
      0.47265668673736444`, 0.5926116206792417}}]}, 
    {Arrowheads[{{0.03622028533101393, 1.}}], 
     ArrowBox[{{0.4646439780159434, 0.5855493836417288}, {
      0.47285602198405646`, 0.6599863306439857}}]}, 
    {Arrowheads[{{0.032868376611474265`, 1.}}], 
     ArrowBox[{{0.46428323418123846`, 0.6582800563698624}, {
      0.47321676581876143`, 0.7256485150587095}}]}, 
    {Arrowheads[{{0.02782957000856199, 1.}}], 
     ArrowBox[{{0.46380840307054544`, 0.7328182633435446}, {
      0.4736915969294544, 0.7895031652278844}}]}, 
    {Arrowheads[{{0.021849612391677292`, 1.}}], 
     ArrowBox[{{0.4633548064126325, 0.8084229535383936}, {
      0.47414519358736734`, 0.8522913321758928}}]}, 
    {Arrowheads[{{0.016632763974292898`, 1.}}], 
     ArrowBox[{{0.46305544368730667`, 0.8833290703364113}, {
      0.4744445563126932, 0.9157780725207323}}]}, 
    {Arrowheads[{{0.01378454604907736, 1.}}], 
     ArrowBox[{{0.4629286279447432, 0.9557429006778814}, {0.4745713720552567, 
      0.9817570993221193}}]}, 
    {Arrowheads[{{0.019044399487695287`, 1.}}], 
     ArrowBox[{{0.5512672145856228, -0.012071558270050521`}, {
      0.5201613568429486, 0.012071558270050521`}}]}, 
    {Arrowheads[{{0.01996592902557879, 1.}}], 
     ArrowBox[{{0.55111316472716, 0.05545195580723977}, {0.5203154067014115, 
      0.08294090133561738}}]}, 
    {Arrowheads[{{0.022848329822350133`, 1.}}], 
     ArrowBox[{{0.5505809112855742, 0.1200377787992703}, {0.5208476601429972, 
      0.156747935486444}}]}, 
    {Arrowheads[{{0.027313720236441772`, 1.}}], 
     ArrowBox[{{0.5496058982401618, 0.18300603256371462`}, {
      0.5218226731884097, 0.23217253886485686`}}]}, 
    {Arrowheads[{{0.032006934728477224`, 1.}}], 
     ArrowBox[{{0.5483836760668354, 0.24621876191894665`}, {
      0.5230448953617359, 0.30735266665248195`}}]}, 
    {Arrowheads[{{0.03566685910596365, 1.}}], 
     ArrowBox[{{0.5472932776395294, 0.31097524919750763`}, {0.524135293789042,
       0.3809890365167782}}]}, 
    {Arrowheads[{{0.03788649967490771, 1.}}], 
     ArrowBox[{{0.5465766556341992, 0.3775481675340072}, {0.5248519157943722, 
      0.45280897532313574`}}]}, 
    {Arrowheads[{{0.038769937037456965`, 1.}}], 
     ArrowBox[{{0.5462804938291576, 0.4457127556823032}, {0.5251480775994137, 
      0.523037244317697}}]}, 
    {Arrowheads[{{0.03844036392058376, 1.}}], 
     ArrowBox[{{0.5463916750321421, 0.5152933418891286}, {0.5250368963964291, 
      0.5918495152537289}}]}, 
    {Arrowheads[{{0.03684628827894998, 1.}}], 
     ArrowBox[{{0.5469174632339897, 0.5863611749341298}, {0.5245111081945818, 
      0.6591745393515849}}]}, 
    {Arrowheads[{{0.0338311489780218, 1.}}], 
     ArrowBox[{{0.5478548228700877, 0.659164642404974}, {0.5235737485584836, 
      0.7247639290235979}}]}, 
    {Arrowheads[{{0.029497983126337484`, 1.}}], 
     ArrowBox[{{0.5490620879868022, 0.7337422952992347}, {0.5223664834417693, 
      0.7885791332721943}}]}, 
    {Arrowheads[{{0.024734868942644563`, 1.}}], 
     ArrowBox[{{0.5501913640903089, 0.8092792685444954}, {0.5212372073382625, 
      0.8514350171697909}}]}, 
    {Arrowheads[{{0.02102185945946157, 1.}}], 
     ArrowBox[{{0.5509269905734671, 0.8840337633302064}, {0.5205015808551042, 
      0.915073379526937}}]}, 
    {Arrowheads[{{0.019228665316895592`, 1.}}], 
     ArrowBox[{{0.5512370121033989, 0.9563323432629608}, {0.5201915593251725, 
      0.9811676567370399}}]}, 
    {Arrowheads[{{0.030119104428836817`, 1.}}], 
     ArrowBox[{{0.632084310267397, -0.010237697871327596`}, {
      0.5732728325897457, 0.010237697871327596`}}]}, 
    {Arrowheads[{{0.03042199299092584, 1.}}], 
     ArrowBox[{{0.6318747505741775, 0.05750504087306461}, {0.5734823922829653,
       0.08088781626979255}}]}, 
    {Arrowheads[{{0.03147211536361094, 1.}}], 
     ArrowBox[{{0.6311339916843378, 0.12261762490485434`}, {0.574223151172805,
       0.15416808938085996`}}]}, 
    {Arrowheads[{{0.03342323576981331, 1.}}], 
     ArrowBox[{{0.6297065974147186, 0.18606312447651563`}, {
      0.5756505454424241, 0.2291154469520558}}]}, 
    {Arrowheads[{{0.03593194705618328, 1.}}], 
     ArrowBox[{{0.6277796658801865, 0.24940369180295247`}, {
      0.5775774769769564, 0.30416773676847614`}}]}, 
    {Arrowheads[{{0.038237841482860684`, 1.}}], 
     ArrowBox[{{0.6259234615698283, 0.31400875854793736`}, {
      0.5794336812873147, 0.37795552716634845`}}]}, 
    {Arrowheads[{{0.03978977655254251, 1.}}], 
     ArrowBox[{{0.6246322008456017, 0.3803924142702675}, {0.580724942011541, 
      0.44996472858687553`}}]}, 
    {Arrowheads[{{0.04043932032626573, 1.}}], 
     ArrowBox[{{0.6240824294169031, 0.44846389681448434`}, {
      0.5812747134402397, 0.5202861031855158}}]}, 
    {Arrowheads[{{0.04019491333028501, 1.}}], 
     ArrowBox[{{0.6242898927949089, 0.5180802857132718}, {0.5810672500622339, 
      0.5890625714295856}}]}, 
    {Arrowheads[{{0.03904810081865252, 1.}}], 
     ArrowBox[{{0.6252532459247896, 0.5893024747049731}, {0.5801038969323532, 
      0.6562332395807416}}]}, 
    {Arrowheads[{{0.03704198596445154, 1.}}], 
     ArrowBox[{{0.626895800051419, 0.6623005521110247}, {0.5784613428057238, 
      0.721628019317547}}]}, 
    {Arrowheads[{{0.03452999162956284, 1.}}], 
     ArrowBox[{{0.628868743713328, 0.736904968615318}, {0.5764883991438147, 
      0.785416459956111}}]}, 
    {Arrowheads[{{0.03224691023754825, 1.}}], 
     ArrowBox[{{0.6305748933239445, 0.8121053937218322}, {0.5747822495331982, 
      0.848608891992454}}]}, 
    {Arrowheads[{{0.030788352714347836`, 1.}}], 
     ArrowBox[{{0.6316186069859082, 0.8863041940854093}, {0.5737385358712346, 
      0.9128029487717342}}]}, 
    {Arrowheads[{{0.030178403958684707`, 1.}}], 
     ArrowBox[{{0.6320433836205526, 0.9582125857721383}, {0.5733137592365901, 
      0.9792874142278625}}]}, 
    {Arrowheads[{{0.034359877045274725`, 1.}}], 
     ArrowBox[{{0.7039290132455424, -0.009284460856502945}, {
      0.6353567010401717, 0.009284460856502945}}]}, 
    {Arrowheads[{{0.03453991675131884, 1.}}], 
     ArrowBox[{{0.7037359396018362, 0.058582254413020875`}, {
      0.6355497746838781, 0.07981060272983628}}]}, 
    {Arrowheads[{{0.03517600424265297, 1.}}], 
     ArrowBox[{{0.7030444204679839, 0.12401482746134208`}, {
      0.6362412938177304, 0.15277088682437223`}}]}, 
    {Arrowheads[{{0.03641124083941646, 1.}}], 
     ArrowBox[{{0.7016704629728486, 0.18781229759770363`}, {
      0.6376152513128654, 0.2273662738308678}}]}, 
    {Arrowheads[{{0.03811172608329822, 1.}}], 
     ArrowBox[{{0.6997252044447756, 0.25134197295843763`}, {
      0.6395605098409385, 0.30222945561299097`}}]}, 
    {Arrowheads[{{0.03979556286846242, 1.}}], 
     ArrowBox[{{0.6977512798746844, 0.3159413821876896}, {0.6415344344110299, 
      0.3760229035265962}}]}, 
    {Arrowheads[{{0.04099622649872803, 1.}}], 
     ArrowBox[{{0.6963217704027179, 0.3822477807894019}, {0.6429639438829963, 
      0.44810936206774105`}}]}, 
    {Arrowheads[{{0.04151470120813954, 1.}}], 
     ArrowBox[{{0.6956997979583392, 0.4502728412843378}, {0.6435859163273749, 
      0.5184771587156625}}]}, 
    {Arrowheads[{{0.04131852178783182, 1.}}], 
     ArrowBox[{{0.6959354092707729, 0.5199075595443489}, {0.6433503050149413, 
      0.5872352975985087}}]}, 
    {Arrowheads[{{0.04041566480481194, 1.}}], 
     ArrowBox[{{0.6970148939774944, 0.5912011033127397}, {0.6422708203082197, 
      0.6543346109729749}}]}, 
    {Arrowheads[{{0.03890743746710579, 1.}}], 
     ArrowBox[{{0.6987974396165847, 0.6642543787154425}, {0.6404882746691294, 
      0.7196741927131293}}]}, 
    {Arrowheads[{{0.03714514464115497, 1.}}], 
     ArrowBox[{{0.7008375891936117, 0.7387669881137701}, {0.6384481250921024, 
      0.7835544404576589}}]}, 
    {Arrowheads[{{0.035657906267604685`, 1.}}], 
     ArrowBox[{{0.7025128735267797, 0.8136707641449855}, {0.6367728407589345, 
      0.8470435215693006}}]}, 
    {Arrowheads[{{0.0347596649060963, 1.}}], 
     ArrowBox[{{0.7034984228794543, 0.8875088749852073}, {0.6357872914062599, 
      0.9115982678719361}}]}, 
    {Arrowheads[{{0.03439499700721235, 1.}}], 
     ArrowBox[{{0.7038913881209616, 0.9591917332188382}, {0.6353943261647526, 
      0.9783082667811624}}]}, 
    {Arrowheads[{{0.03216437722426891, 1.}}], 
     ArrowBox[{{0.7683869759044022, -0.009782224322236256}, {
      0.7048273098098833, 0.009782224322236256}}]}, 
    {Arrowheads[{{0.03240198673348359, 1.}}], 
     ArrowBox[{{0.7681840096107722, 0.058018451642575394`}, {
      0.7050302761035134, 0.08037440550028176}}]}, 
    {Arrowheads[{{0.03323432284015854, 1.}}], 
     ArrowBox[{{0.7674609583721355, 0.12327750263103536`}, {0.70575332734215, 
      0.15350821165467893`}}]}, 
    {Arrowheads[{{0.03481770908367227, 1.}}], 
     ArrowBox[{{0.766043455366002, 0.18687470934762715`}, {0.7071708303482835,
       0.2283038620809443}}]}, 
    {Arrowheads[{{0.036926313641716266`, 1.}}], 
     ArrowBox[{{0.7640818317304366, 0.25028272208418256`}, {
      0.7091324539838488, 0.303288706487246}}]}, 
    {Arrowheads[{{0.038936161764261804`, 1.}}], 
     ArrowBox[{{0.7621448522382117, 0.31486874214731275`}, {
      0.7110694334760739, 0.37709554356697306`}}]}, 
    {Arrowheads[{{0.040325578285907715`, 1.}}], 
     ArrowBox[{{0.7607733490904116, 0.3812093321280382}, {0.7124409366238741, 
      0.44914781072910476`}}]}, 
    {Arrowheads[{{0.04091530247237511, 1.}}], 
     ArrowBox[{{0.7601840896294058, 0.4492574149079841}, {0.7130301960848798, 
      0.5194925850920162}}]}, 
    {Arrowheads[{{0.040692856854471424`, 1.}}], 
     ArrowBox[{{0.7604068044896646, 0.5188829249710061}, {0.7128074812246211, 
      0.5882599321718514}}]}, 
    {Arrowheads[{{0.039658035835822274`, 1.}}], 
     ArrowBox[{{0.7614352593583152, 0.5901424475757087}, {0.7117790263559702, 
      0.655393266710006}}]}, 
    {Arrowheads[{{0.037885431135705555`, 1.}}], 
     ArrowBox[{{0.7631649186016864, 0.6631782405678397}, {0.710049367112599, 
      0.720750330860732}}]}, 
    {Arrowheads[{{0.03573779117973171, 1.}}], 
     ArrowBox[{{0.7651970438464896, 0.737760154484739}, {0.7080172418677959, 
      0.78456127408669}}]}, 
    {Arrowheads[{{0.03385725069517866, 1.}}], 
     ArrowBox[{{0.7669094857837883, 0.812839566881211}, {0.7063047999304973, 
      0.8478747188330753}}]}, 
    {Arrowheads[{{0.03269082689101381, 1.}}], 
     ArrowBox[{{0.7679349697863256, 0.8868765627976272}, {0.7052793159279601, 
      0.9122305800595163}}]}, 
    {Arrowheads[{{0.032210804944475244`, 1.}}], 
     ArrowBox[{{0.768347388885922, 0.9586802090157233}, {0.7048668968283637, 
      0.9788197909842775}}]}, 
    {Arrowheads[{{0.023508596641613203`, 1.}}], 
     ArrowBox[{{0.8250080121813008, -0.011450323501992894`}, {
      0.7821348449615562, 0.011450323501992894`}}]}, 
    {Arrowheads[{{0.02411373540177094, 1.}}], 
     ArrowBox[{{0.8248094269968794, 0.056143337605996546`}, {
      0.7823334301459776, 0.0822495195368606}}]}, 
    {Arrowheads[{{0.026110545747019945`, 1.}}], 
     ArrowBox[{{0.8241201634988616, 0.12088953590851072`}, {
      0.7830226936439952, 0.1558961783772036}}]}, 
    {Arrowheads[{{0.02947894112123158, 1.}}], 
     ArrowBox[{{0.8228449789311525, 0.1839828552672927}, {0.7842978782117045, 
      0.2311957161612788}}]}, 
    {Arrowheads[{{0.033323086875909895`, 1.}}], 
     ArrowBox[{{0.8212231768607877, 0.24720258395845762`}, {
      0.7859196802820692, 0.306368844612971}}]}, 
    {Arrowheads[{{0.036502795789066844`, 1.}}], 
     ArrowBox[{{0.8197536891085833, 0.31189159162006297`}, {
      0.7873891680342736, 0.3800726940942228}}]}, 
    {Arrowheads[{{0.03849786475989577, 1.}}], 
     ArrowBox[{{0.8187762374267764, 0.3783986799466416}, {0.7883666197160806, 
      0.4519584629105014}}]}, 
    {Arrowheads[{{0.03930440684761421, 1.}}], 
     ArrowBox[{{0.8183696404376503, 0.4465329187896075}, {0.7887732167052066, 
      0.5222170812103927}}]}, 
    {Arrowheads[{{0.039002732235007546`, 1.}}], 
     ArrowBox[{{0.8185224558955739, 0.5161250655140143}, {0.7886204012472829, 
      0.591017791628843}}]}, 
    {Arrowheads[{{0.03755710990702487, 1.}}], 
     ArrowBox[{{0.8192422278302315, 0.5872445386652683}, {0.7879006293126254, 
      0.6582911756204464}}]}, 
    {Arrowheads[{{0.03488975604239409, 1.}}], 
     ArrowBox[{{0.8205131526611873, 0.6601219313527099}, {0.7866297044816697, 
      0.7238066400758618}}]}, 
    {Arrowheads[{{0.031232678791739927`, 1.}}], 
     ArrowBox[{{0.8221266261317003, 0.7347367129967348}, {0.7850162310111568, 
      0.7875847155746943}}]}, 
    {Arrowheads[{{0.027495697194276036`, 1.}}], 
     ArrowBox[{{0.8236126366237781, 0.8101996935340664}, {0.7835302205190788, 
      0.8505145921802197}}]}, 
    {Arrowheads[{{0.0248274918822675, 1.}}], 
     ArrowBox[{{0.8245688821918546, 0.8847929602889756}, {0.7825739749510023, 
      0.914314182568168}}]}, 
    {Arrowheads[{{0.02362822390760845, 1.}}], 
     ArrowBox[{{0.8249691089391578, 0.9569685443677053}, {0.7821737482036992, 
      0.9805314556322955}}]}, 
    {Arrowheads[{{0.01275397278244902, 1.}}], 
     ArrowBox[{{0.873669827338149, -0.01280705839782912}, {0.8674016012332794,
       0.01280705839782912}}]}, 
    {Arrowheads[{{0.014399713389906619`, 1.}}], 
     ArrowBox[{{0.8736340204077929, 0.05463610055092706}, {0.8674374081636355,
       0.08375675659193009}}]}, 
    {Arrowheads[{{0.018936106274775044`, 1.}}], 
     ArrowBox[{{0.8735121459526355, 0.11904443968916155`}, {
      0.8675592826187928, 0.15774127459655277`}}]}, 
    {Arrowheads[{{0.025000111472825208`, 1.}}], 
     ArrowBox[{{0.8732955967822922, 0.18189212409976574`}, {
      0.8677758317891363, 0.23328644732880574`}}]}, 
    {Arrowheads[{{0.030718518374667766`, 1.}}], 
     ArrowBox[{{0.873034506947425, 0.2451275843033071}, {0.8680369216240035, 
      0.3084438442681215}}]}, 
    {Arrowheads[{{0.03489415041429633, 1.}}], 
     ArrowBox[{{0.8728093909417194, 0.3099805363199219}, {0.8682620376297089, 
      0.3819837493943639}}]}, 
    {Arrowheads[{{0.037340555778070356`, 1.}}], 
     ArrowBox[{{0.8726646081151679, 0.376634910630784}, {0.8684068204562605, 
      0.45372223222635893`}}]}, 
    {Arrowheads[{{0.03829969428155261, 1.}}], 
     ArrowBox[{{0.8726053801218655, 0.444835170342513}, {0.8684660484495629, 
      0.5239148296574871}}]}, 
    {Arrowheads[{{0.03794276424703507, 1.}}], 
     ArrowBox[{{0.8726275769369268, 0.5144022797662954}, {0.8684438516345014, 
      0.592740577376562}}]}, 
    {Arrowheads[{{0.03620098990754764, 1.}}], 
     ArrowBox[{{0.8727331893214172, 0.585408094698674}, {0.8683382392500113, 
      0.6601276195870405}}]}, 
    {Arrowheads[{{0.032824695982536914`, 1.}}], 
     ArrowBox[{{0.8729245186643934, 0.6581145266928674}, {0.868146909907035, 
      0.7258140447357045}}]}, 
    {Arrowheads[{{0.027723434119440924`, 1.}}], 
     ArrowBox[{{0.8731781419907545, 0.7326224928778271}, {0.8678932865806739, 
      0.7896989356936018}}]}, 
    {Arrowheads[{{0.021599557823061284`, 1.}}], 
     ArrowBox[{{0.8734246456457164, 0.8082153389898643}, {0.867646782925712, 
      0.852498946724422}}]}, 
    {Arrowheads[{{0.016148335191590115`, 1.}}], 
     ArrowBox[{{0.8735910737590286, 0.8831415128445825}, {0.8674803548123998, 
      0.915965630012561}}]}, 
    {Arrowheads[{{0.01309404787908082, 1.}}], 
     ArrowBox[{{0.8736627885277672, 0.955579608079845}, {0.867408640043661, 
      0.9819203919201557}}]}, 
    {Arrowheads[{{0.020928877116596953`, 1.}}], 
     ArrowBox[{{0.9193930663309081, -0.011843184597369496`}, {
      0.9556069336690917, 0.011843184597369496`}}]}, 
    {Arrowheads[{{0.021701586322118407`, 1.}}], 
     ArrowBox[{{0.9195754027761195, 0.055704364025910426`}, {
      0.9554245972238803, 0.08268849311694673}}]}, 
    {Arrowheads[{{0.024182560626935207`, 1.}}], 
     ArrowBox[{{0.9202041141538794, 0.12034180316225569`}, {
      0.9547958858461205, 0.15644391112345862`}}]}, 
    {Arrowheads[{{0.028180109135161786`, 1.}}], 
     ArrowBox[{{0.9213506984709262, 0.18334269976570175`}, {
      0.9536493015290736, 0.23183587166286967`}}]}, 
    {Arrowheads[{{0.032531744925296265`, 1.}}], 
     ArrowBox[{{0.9227795493228053, 0.24654734826622662`}, {
      0.9522204506771944, 0.30702408030520195`}}]}, 
    {Arrowheads[{{0.036004744446714684`, 1.}}], 
     ArrowBox[{{0.9240483417561215, 0.31127638385701095`}, {
      0.9509516582438783, 0.3806879018572748}}]}, 
    {Arrowheads[{{0.03813773455671308, 1.}}], 
     ArrowBox[{{0.9248803394532654, 0.377826259736699}, {0.9501196605467344, 
      0.45253088312044404`}}]}, 
    {Arrowheads[{{0.038991487529691504`, 1.}}], 
     ArrowBox[{{0.925223939856153, 0.4459806726393223}, {0.9497760601438469, 
      0.5227693273606779}}]}, 
    {Arrowheads[{{0.03867268897022454, 1.}}], 
     ArrowBox[{{0.9250949612596403, 0.5155651112563584}, {0.9499050387403594, 
      0.5915777458864991}}]}, 
    {Arrowheads[{{0.037135884589285566`, 1.}}], 
     ArrowBox[{{0.924484788278772, 0.586650556263124}, {0.9505152117212278, 
      0.6588851580225905}}]}, 
    {Arrowheads[{{0.034255301442507304`, 1.}}], 
     ArrowBox[{{0.9233954721597725, 0.6594814382831272}, {0.9516045278402273, 
      0.7244471331454445}}]}, 
    {Arrowheads[{{0.030189117439662513`, 1.}}], 
     ArrowBox[{{0.9219874926494932, 0.7340796765403615}, {0.9530125073505067, 
      0.7882417520310676}}]}, 
    {Arrowheads[{{0.025851353219616274`, 1.}}], 
     ArrowBox[{{0.9206629922283109, 0.8096029106546516}, {0.9543370077716887, 
      0.8511113750596347}}]}, 
    {Arrowheads[{{0.02259981101889742, 1.}}], 
     ArrowBox[{{0.9197955417436678, 0.8843086827175245}, {0.9552044582563319, 
      0.914798460139619}}]}, 
    {Arrowheads[{{0.021082501897901954`, 1.}}], 
     ArrowBox[{{0.9194288267112024, 0.9565658987173058}, {0.9555711732887973, 
      0.9809341012826949}}]}}},
  AspectRatio->1,
  DisplayFunction->Identity,
  Frame->True,
  FrameLabel->{
    FormBox["\"x\"", TraditionalForm], 
    FormBox["\"y\"", TraditionalForm]},
  FrameTicks->{{Automatic, Automatic}, {Automatic, Automatic}},
  GridLinesStyle->Directive[
    GrayLevel[0.5, 0.4]],
  Method->{
   "DefaultBoundaryStyle" -> Automatic, "TransparentPolygonMesh" -> True},
  PlotRange->{{-0.04814655046902454, 
   0.9856465504690245}, {-0.04814655046902454, 1.0168965504690246`}},
  PlotRangeClipping->True,
  PlotRangePadding->{{
     Scaled[0.05], 
     Scaled[0.05]}, {
     Scaled[0.05], 
     Scaled[0.05]}},
  Ticks->{Automatic, Automatic}]], "Output"]
}, Open  ]],

Cell[BoxData[{
 RowBox[{
  RowBox[{
   SubscriptBox["ct", "obstacle"], "=", 
   SuperscriptBox["2", "0"]}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   SubscriptBox["ct", "fluid"], "=", 
   SuperscriptBox["2", "1"]}], ";"}]}], "Input"],

Cell[BoxData[
 RowBox[{
  RowBox[{
   SubscriptBox["type", "0"], "=", 
   RowBox[{"ConstantArray", "[", 
    RowBox[{
     SubscriptBox["ct", "fluid"], ",", 
     RowBox[{"{", 
      RowBox[{
       SubscriptBox["dim", "1"], ",", 
       SubscriptBox["dim", "2"]}], "}"}]}], "]"}]}], ";"}]], "Input"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Run LBM method", "Section"],

Cell[BoxData[
 RowBox[{
  RowBox[{
   SubscriptBox["\[Omega]", "val"], "=", 
   RowBox[{"1", "/", "5"}]}], ";"}]], "Input"],

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{"zero", " ", "gravity"}], " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{
    SubscriptBox["g", "val"], "=", 
    RowBox[{"{", 
     RowBox[{"0", ",", "0"}], "}"}]}], ";"}]}]], "Input"],

Cell[BoxData[
 RowBox[{
  RowBox[{
   SubscriptBox["t", "max"], "=", "100"}], ";"}]], "Input"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{
   SubscriptBox["t", "discr"], "=", 
   RowBox[{"Range", "[", 
    RowBox[{"0", ",", 
     SubscriptBox["t", "max"]}], "]"}]}], ";"}], "\[IndentingNewLine]", 
 RowBox[{"Length", "[", 
  SubscriptBox["t", "discr"], "]"}]}], "Input"],

Cell[BoxData["101"], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"?", "LatticeBoltzmann"}]], "Input"],

Cell[BoxData[
 StyleBox["\<\"LatticeBoltzmann[omega_Real, numsteps_Integer, gravity_List, \
f0_List, type0_List] runs a Lattice Boltzmann Method (LBM) simulation\"\>", 
  "MSG"]], "Print", "PrintUsage",
 CellTags->"Info3627999022-9058970"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{
   RowBox[{"{", 
    RowBox[{
     SubscriptBox["type", "evolv"], ",", 
     SubscriptBox["f", "evolv"], ",", 
     SubscriptBox["mass", "evolv"]}], "}"}], "=", 
   RowBox[{"LatticeBoltzmann", "[", 
    RowBox[{
     RowBox[{"N", "[", 
      SubscriptBox["\[Omega]", "val"], "]"}], ",", 
     RowBox[{"Length", "[", 
      SubscriptBox["t", "discr"], "]"}], ",", 
     RowBox[{"N", "[", 
      SubscriptBox["g", "val"], "]"}], ",", 
     RowBox[{"Flatten", "[", 
      SubscriptBox["f", "0"], "]"}], ",", 
     RowBox[{"Flatten", "[", 
      SubscriptBox["type", "0"], "]"}]}], "]"}]}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{"Dimensions", "[", 
  SubscriptBox["f", "evolv"], "]"}]}], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"101", ",", "16", ",", "32", ",", "9"}], "}"}]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", "example", " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{
   SubscriptBox["f", "evolv"], "\[LeftDoubleBracket]", 
   RowBox[{
    RowBox[{"-", "1"}], ",", 
    RowBox[{"{", 
     RowBox[{"1", ",", "2", ",", "3"}], "}"}], ",", 
    RowBox[{"{", 
     RowBox[{"4", ",", "5", ",", "6"}], "}"}], ",", "2"}], 
   "\[RightDoubleBracket]"}]}]], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{
   RowBox[{"{", 
    RowBox[{
    "0.15643705427646637`", ",", "0.1566658914089203`", ",", 
     "0.1568658947944641`"}], "}"}], ",", 
   RowBox[{"{", 
    RowBox[{
    "0.15647399425506592`", ",", "0.15670359134674072`", ",", 
     "0.1569041907787323`"}], "}"}], ",", 
   RowBox[{"{", 
    RowBox[{
    "0.15658986568450928`", ",", "0.1568203866481781`", ",", 
     "0.15702185034751892`"}], "}"}]}], "}"}]], "Output"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Check conservation laws", "Section"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{
   SubscriptBox["\[Rho]", "evolv"], "=", 
   RowBox[{"Table", "[", 
    RowBox[{
     RowBox[{"Density", "[", 
      RowBox[{
       SubscriptBox["f", "evolv"], "\[LeftDoubleBracket]", 
       RowBox[{
        RowBox[{"t", "+", "1"}], ",", "i", ",", "j"}], 
       "\[RightDoubleBracket]"}], "]"}], ",", 
     RowBox[{"{", 
      RowBox[{"t", ",", "0", ",", 
       SubscriptBox["t", "max"]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"i", ",", 
       SubscriptBox["dim", "1"]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"j", ",", 
       SubscriptBox["dim", "2"]}], "}"}]}], "]"}]}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{"Dimensions", "[", "%", "]"}]}], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"101", ",", "16", ",", "32"}], "}"}]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{"check", " ", "density", " ", "conservation"}], " ", "*)"}], 
  "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{
    RowBox[{"Total", "[", 
     RowBox[{
      SubscriptBox["\[Rho]", "evolv"], ",", 
      RowBox[{"{", 
       RowBox[{"2", ",", "3"}], "}"}]}], "]"}], ";"}], "\[IndentingNewLine]", 
   RowBox[{"ListPlot", "[", 
    RowBox[{
     RowBox[{"Abs", "[", 
      RowBox[{
       RowBox[{"%", "/", 
        RowBox[{"First", "[", "%", "]"}]}], "-", "1"}], "]"}], ",", 
     RowBox[{"AxesLabel", "\[Rule]", 
      RowBox[{"{", 
       RowBox[{
       "\"\<t\>\"", ",", 
        "\"\<\[LeftDoubleBracketingBar]\[CapitalDelta]\[Rho]\
\[RightDoubleBracketingBar]\>\""}], "}"}]}], ",", 
     RowBox[{"PlotStyle", "\[Rule]", 
      RowBox[{"{", 
       RowBox[{"Blue", ",", 
        RowBox[{"PointSize", "[", "Small", "]"}]}], "}"}]}]}], 
    "]"}]}]}]], "Input"],

Cell[BoxData[
 GraphicsBox[{{}, 
   {RGBColor[0, 0, 1], PointSize[Small], AbsoluteThickness[1.6], 
    PointBox[CompressedData["
1:eJxV1GlIVFEYBuAho5RkkrJwyB03LPd0ytFxMrfGXEZtGjN/GKhRimkzpal5
KxVxMisrAkPDcvshRRIK/WiKCBJs32wxrECTMglswdT8Ps8beOEyPLy85zuc
yxm3PUVpuUtkMlnu/Eu/C89klGzxo5l/T7+3yVAv0Jo8bh7LEbYjqz8G7BW2
Jx83ZBUKO5BdX5UfEHYkr6p6XSzsSlY16w8Ku5OHAm8ZhT3IV2a1h4S9yLc/
GQ8L+5CVYcOlwr7kRnNtmfAG8szJr7A/+enDzCPCgeT0Spty4SCy70Q7HEy+
J7evEA4hK162Id9IPnWpEg4lrx4pgcPIoWfVsJLz8ix4E/lCdwy8mewXLofD
yc2Rc9ivilx1YgKOIEcPdsGRfF5rp2A1OUD5C44iO/fpsL6GnPfbVlhiV19b
hnwLOWQGfYl9p/n/vGhy13oTcnZ+5RjOeyu55mansMTu3X8MeQz5WUsLcvZ4
z27kseTZbk/k7MseKcjjyH+bFMjjFq8niydHGPH9Jba/2QH7TyA73Fdi/2xH
Qz7ybeRCswo5O8JWi1xLrph6jvXZPQ1fMD+RnJhtQc42rHmDfDvZre48crZ1
UA3yJHKOzVHk7IKyWOTJ5M+p9cjZLg1K5Clk7cBS5Oy7qmDkqeTBDwPi/mjY
VnJPYYltKjIKW9gPUrxw33RkXVOjuI8adouiVlhid3glCVvYhmJv3N808pkA
L/TZivYX4r5L7Olvb4Ut7F1tI/g/SCc7tXYKa9j67A702Y/2xaPPfldvhX4G
OTfHB322q5MefXa2+zr02TE3Rk2iv4Ps96NLWMMePdcrLLGvOy9Hn50wPIe+
ns+rrxrz2TNWY5jP7tENoc9OfnIV+99J7vfuR59dKi9Bn10wqUF/wSu+Y76B
vLJVhT47Lt4fffbFn57os0MrXDA/k5w3bYc+u+7PY5P6H9OTJRo=
     "]]}, {}},
  AspectRatio->NCache[GoldenRatio^(-1), 0.6180339887498948],
  Axes->{True, True},
  AxesLabel->{
    FormBox["\"t\"", TraditionalForm], 
    FormBox[
    "\"\[LeftDoubleBracketingBar]\[CapitalDelta]\[Rho]\
\[RightDoubleBracketingBar]\"", TraditionalForm]},
  AxesOrigin->{0, 0},
  DisplayFunction->Identity,
  Frame->{{False, False}, {False, False}},
  FrameLabel->{{None, None}, {None, None}},
  FrameTicks->{{Automatic, Automatic}, {Automatic, Automatic}},
  GridLines->{None, None},
  GridLinesStyle->Directive[
    GrayLevel[0.5, 0.4]],
  Method->{},
  PlotRange->{{0., 101.}, {0, 1.0460000599010755`*^-7}},
  PlotRangeClipping->True,
  PlotRangePadding->{{
     Scaled[0.02], 
     Scaled[0.02]}, {
     Scaled[0.02], 
     Scaled[0.05]}},
  Ticks->{Automatic, Automatic}]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{
   SubscriptBox["u", "evolv"], "=", 
   RowBox[{"Table", "[", 
    RowBox[{
     RowBox[{"Velocity", "[", 
      RowBox[{
       SubscriptBox["f", "evolv"], "\[LeftDoubleBracket]", 
       RowBox[{
        RowBox[{"t", "+", "1"}], ",", "i", ",", "j"}], 
       "\[RightDoubleBracket]"}], "]"}], ",", 
     RowBox[{"{", 
      RowBox[{"t", ",", "0", ",", 
       SubscriptBox["t", "max"]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"i", ",", 
       SubscriptBox["dim", "1"]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"j", ",", 
       SubscriptBox["dim", "2"]}], "}"}]}], "]"}]}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{"Dimensions", "[", "%", "]"}]}], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"101", ",", "16", ",", "32", ",", "2"}], "}"}]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{"check", " ", "momentum", " ", "conservation"}], " ", "*)"}], 
  "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{
    RowBox[{"Total", "[", 
     RowBox[{"(*", 
      RowBox[{"pointwise", " ", "multiplication"}], "*)"}], 
     RowBox[{
      RowBox[{
       SubscriptBox["\[Rho]", "evolv"], 
       SubscriptBox["u", "evolv"]}], ",", 
      RowBox[{"{", 
       RowBox[{"2", ",", "3"}], "}"}]}], "]"}], ";"}], "\[IndentingNewLine]", 
   RowBox[{"ListPlot", "[", 
    RowBox[{
     RowBox[{"Table", "[", 
      RowBox[{
       RowBox[{
        RowBox[{"Norm", "[", 
         RowBox[{
          RowBox[{"%", "\[LeftDoubleBracket]", 
           RowBox[{"t", "+", "1"}], "\[RightDoubleBracket]"}], "-", 
          RowBox[{"First", "[", "%", "]"}]}], "]"}], "/", 
        RowBox[{"Norm", "[", 
         RowBox[{"First", "[", "%", "]"}], "]"}]}], ",", 
       RowBox[{"{", 
        RowBox[{"t", ",", "0", ",", 
         SubscriptBox["t", "max"]}], "}"}]}], "]"}], ",", 
     RowBox[{"AxesLabel", "\[Rule]", 
      RowBox[{"{", 
       RowBox[{
       "\"\<t\>\"", ",", 
        "\"\<\[LeftDoubleBracketingBar]\[CapitalDelta]u\
\[RightDoubleBracketingBar]\>\""}], "}"}]}], ",", 
     RowBox[{"PlotStyle", "\[Rule]", 
      RowBox[{"{", 
       RowBox[{"Blue", ",", 
        RowBox[{"PointSize", "[", "Small", "]"}]}], "}"}]}]}], 
    "]"}]}]}]], "Input"],

Cell[BoxData[
 GraphicsBox[{{}, 
   {RGBColor[0, 0, 1], PointSize[Small], AbsoluteThickness[1.6], 
    PointBox[CompressedData["
1:eJxVzX9M1HUcx/GDECijE5I0xUBIpsgYPz1+Hi854Ph9xx0HnBkjE7I5oFN0
QAl3JHInGDvFWZT8Ck0CQZ1yAjaPXxLRzMZPk3UD08nPuBCMRRbN9+ePvtt3
3z32/Ly+n637siRpphwOJ231/e/74pkP5vz/gbvFn9G10WL+C1ridnZzrkic
Sl6H+fXSv8KepZPX44Dz8GzC9gzyRrzTVhwa0PwR2Q7q/o7s12YVZAeY1Z7y
ObrmMNkRXO5lmzsHsslvo/vSkPabwiNkZyR3aiu7K4+St+PqU/fDWXU5ZBc4
mbh5t9fmkl2R86DRP+U2sxuEBRVl75vmkd0x1GBoDNzxMdkDh0IHPdLf+oTs
ifFpTb225hjZC4PG9rH0J8zeKOv8LLMqNZ/sA6e+PY/Tq5l34aKz0r7NoYDM
w5Y2GEx7mH1RF7/cPCVSkv1g0BVlGuXM/rjv86NGU8UcAOOkW4ZhjDkQGm2O
+qV25iDommvvLBuZ+RibrfnbwlxFDsZ4iOIVoTczwJ9omkywJSuBpcucvV+7
sL4bP58YeGa9m/XdODs8Mx3hy3oITumWwt1CWQ/B+ec2JvsFrAtgbt3asoWd
Vwrg2eTyMFHCeigM6vxRj27WQ3FIzfe62cx6GDrH8i5s6GU9DE11Z77Ts/Oc
cMTs+DBGOsh6OGyMz9c4BBVSF2LueldZVRpZKcS3cttyxwusR2Bopa2n5D7r
Efji7FoDP/pT6pHwtOr7wExJVkbi1tyvj/LGWY/CTKZK/EcN61Eo36bXletY
j4bn8r2Lfa2sR8M17SpXtOk49Ricy722a9mfrIzBwgPLhkgV67EwFoSNdA2y
Hot+6eZjj/pZj0Pwu9VHehdZj0Pa9RHxxrusi9BbIPT8/ArrIqS8rE1W/866
GKWWUTtbT5MhxtTI90/2nGPnxTAf7esf6CDrxag9c9p6hltE+3j4yXPf3Mzu
QzyKViYXcxfYPh68KoHfwX/YPh6ORXuDuibY/RKIRRYK8S9sL4HX7JBWu43+
r5RAVZlV488j6yUY5ekKYr9i90vhmn9eFtJIhhSqyJDJ5TG2lyKnt8308SLb
S8FT3VUoAk/QPgF6CT/iYREZCSi1e6rgqsnKBHSHC0yKfyDrV8972Mv85tle
hops7hs9XWwvg/m9pRv7p9lehspx7fG81GLay3Bt7lbZjUwyJxELVoFmvlNk
JEJYbLvzip2a9olIbWhx4PmR9Ym4+d5P9mszyJwk9BRuzdlUT0YSHL/UrFQP
s30SUiZsTTqsNLRPgjSoXuIkIHOSMREw/3rvABmrzj7427D1SdonI+6SvCE1
iKxPhm3UupbFUjJHjg1xi68q3UpoL0dV376K9IwS/r+Rj8wq
     "]]}, {}},
  AspectRatio->NCache[GoldenRatio^(-1), 0.6180339887498948],
  Axes->{True, True},
  AxesLabel->{
    FormBox["\"t\"", TraditionalForm], 
    FormBox[
    "\"\[LeftDoubleBracketingBar]\[CapitalDelta]u\[RightDoubleBracketingBar]\"\
", TraditionalForm]},
  AxesOrigin->{0, 0},
  DisplayFunction->Identity,
  Frame->{{False, False}, {False, False}},
  FrameLabel->{{None, None}, {None, None}},
  FrameTicks->{{Automatic, Automatic}, {Automatic, Automatic}},
  GridLines->{None, None},
  GridLinesStyle->Directive[
    GrayLevel[0.5, 0.4]],
  Method->{},
  PlotRange->{{0., 101.}, {0, 2.043496582552824*^-7}},
  PlotRangeClipping->True,
  PlotRangePadding->{{
     Scaled[0.02], 
     Scaled[0.02]}, {
     Scaled[0.02], 
     Scaled[0.05]}},
  Ticks->{Automatic, Automatic}]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{
   SubscriptBox["en", 
    RowBox[{"int", ",", "evolv"}]], "=", 
   RowBox[{"Table", "[", 
    RowBox[{
     RowBox[{"InternalEnergy", "[", 
      RowBox[{
       SubscriptBox["f", "evolv"], "\[LeftDoubleBracket]", 
       RowBox[{
        RowBox[{"t", "+", "1"}], ",", "i", ",", "j"}], 
       "\[RightDoubleBracket]"}], "]"}], ",", 
     RowBox[{"{", 
      RowBox[{"t", ",", "0", ",", 
       SubscriptBox["t", "max"]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"i", ",", 
       SubscriptBox["dim", "1"]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"j", ",", 
       SubscriptBox["dim", "2"]}], "}"}]}], "]"}]}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{"Dimensions", "[", "%", "]"}]}], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"101", ",", "16", ",", "32"}], "}"}]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{
   SubscriptBox["en", 
    RowBox[{"tot", ",", "evolv"}]], "=", 
   RowBox[{"Table", "[", 
    RowBox[{
     RowBox[{"TotalEnergy", "[", 
      RowBox[{
       SubscriptBox["f", "evolv"], "\[LeftDoubleBracket]", 
       RowBox[{
        RowBox[{"t", "+", "1"}], ",", "i", ",", "j"}], 
       "\[RightDoubleBracket]"}], "]"}], ",", 
     RowBox[{"{", 
      RowBox[{"t", ",", "0", ",", 
       SubscriptBox["t", "max"]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"i", ",", 
       SubscriptBox["dim", "1"]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"j", ",", 
       SubscriptBox["dim", "2"]}], "}"}]}], "]"}]}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{"Dimensions", "[", "%", "]"}]}], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"101", ",", "16", ",", "32"}], "}"}]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{
   "energy", " ", "conservation", " ", "does", " ", "not", " ", "seem", " ", 
    "to", " ", "hold"}], " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{
    RowBox[{"Total", "[", 
     RowBox[{"(*", 
      RowBox[{"pointwise", " ", "multiplication"}], "*)"}], 
     RowBox[{
      RowBox[{
       SubscriptBox["\[Rho]", "evolv"], 
       SubscriptBox["en", 
        RowBox[{"tot", ",", "evolv"}]]}], ",", 
      RowBox[{"{", 
       RowBox[{"2", ",", "3"}], "}"}]}], "]"}], ";"}], "\[IndentingNewLine]", 
   RowBox[{"ListPlot", "[", 
    RowBox[{
     RowBox[{"Table", "[", 
      RowBox[{
       RowBox[{
        RowBox[{"Norm", "[", 
         RowBox[{
          RowBox[{"%", "\[LeftDoubleBracket]", 
           RowBox[{"t", "+", "1"}], "\[RightDoubleBracket]"}], "-", 
          RowBox[{"First", "[", "%", "]"}]}], "]"}], "/", 
        RowBox[{"Norm", "[", 
         RowBox[{"First", "[", "%", "]"}], "]"}]}], ",", 
       RowBox[{"{", 
        RowBox[{"t", ",", "0", ",", 
         SubscriptBox["t", "max"]}], "}"}]}], "]"}], ",", 
     RowBox[{"AxesLabel", "\[Rule]", 
      RowBox[{"{", 
       RowBox[{
       "\"\<t\>\"", ",", 
        "\"\<\[LeftDoubleBracketingBar]\[CapitalDelta]\[Epsilon]\
\[RightDoubleBracketingBar]\>\""}], "}"}]}], ",", 
     RowBox[{"PlotStyle", "\[Rule]", 
      RowBox[{"{", 
       RowBox[{"Blue", ",", 
        RowBox[{"PointSize", "[", "Small", "]"}]}], "}"}]}]}], 
    "]"}]}]}]], "Input"],

Cell[BoxData[
 GraphicsBox[{{}, 
   {RGBColor[0, 0, 1], PointSize[Small], AbsoluteThickness[1.6], 
    PointBox[CompressedData["
1:eJxVyw1M1HUcx/F/MKaUCgxaZei4Jg9roCBxHMrDB+7geOYeuDuOcHCGBnFm
kHAppEcSKM9ocjx4LoM7LAsCoZEUnhkhBoEaylMWNYLAiKSYMdqy9f/+t37b
f7+9/u/fh7f3oGyfFcMw+x59/97/naUQ5v8HrYfcrmUVdLD/12OTbrhRtGhh
bY80l9emRZ/1s3ZCQKvR9PHYEOunIVwn2PR99U3WznBUWjVnt99m7QLtucP+
IeJR1s/hzPiEqSHjDuttOO3nIn498C5rN8h/DVZLfyF7YEPXDQdB2Rjr5+Gu
vvdqoNc4a0/YKo/Mv3udvB39qd+85Bk/wdobtfnZmg2dZB/42q1bsVoj74SV
7URp8/ZJ1r4oKeVn+ijIL4Cv8mrP1ZH98KyrQOjTQObD8FfTK06fk/0R5FDe
tDxJFqBmQheQsEwOQFVWgegZ6ynWuyBwmR0q2kjejWuraan8J8mBWDhuy7c4
k4Mwssfjj61u5GBopvyPmn3IIQi5Or3nxyAy8NYMb805irUesNXFDpyXUQ/F
1dU38oqTqYfCWpNcxtNQD8PWF2crFvdTD0OWteRunpa6EF90X+h7kE1diJqI
5XwnHXURDMP56Zn51EV4aOya++oo9XDYHJi5HVZIPRx93jlFjx+nHoG5gU/e
TC6iHoG1kLbgw29TF0M523vRUExdjJInHE1dJdQjob5ouvXpCeqROBG5mmE4
ST0KHXOpbtJS6lFoXJrT/kZmorHQ0lV9rIx6NCSVowancuoxiL/JM/eS9TEY
+LbdTl9BPRbH+nNypJXUYzEv7x/xrKIeB1PKcKhdNfU4rIxXylfITDxauhjP
H2qox2P/w0Dj4CnqCSjiDUX3nKaegHr7p0IvvENdAhuv3MvlZ1hDgskduea9
tfReAq3570uuBtYWCd5XS0ZukRkp3B+kqjLqaC/FocCUyp/JeilMVvPeCfW0
l6K18M6WZjIjw5cVV2xnyZChobtnx+YG2ssgbtEqQLbI8KHGOz2FzMixbUEX
kU2GHG0b834v5PZyuF5aDK/h9nIcEQmN57l9IszmP1s6uX0i5ncdPPs1t0/E
d3mjkbPcPhHlBxxs1jfSXgF3+/tXvMhQIGZ36pYksl6BNE1bVTHZokDHdbGk
m9sr8cFgneY+t1cizu+xTt5Z2ivRNy7eqSJblMhpMt4oIzMq/NTzUUEvGSqk
GbozF7m9CoKomenNRtqr4MGvTReSmSRMLdWde5mMJBT7DuaUkPVJGA2OXXyP
2ychxVEbeZnbq1EvGR4b4vZqnPLydLr3yP8A/oHnqQ==
     "]]}, {}},
  AspectRatio->NCache[GoldenRatio^(-1), 0.6180339887498948],
  Axes->{True, True},
  AxesLabel->{
    FormBox["\"t\"", TraditionalForm], 
    FormBox[
    "\"\[LeftDoubleBracketingBar]\[CapitalDelta]\[Epsilon]\
\[RightDoubleBracketingBar]\"", TraditionalForm]},
  AxesOrigin->{0, 0},
  DisplayFunction->Identity,
  Frame->{{False, False}, {False, False}},
  FrameLabel->{{None, None}, {None, None}},
  FrameTicks->{{Automatic, Automatic}, {Automatic, Automatic}},
  GridLines->{None, None},
  GridLinesStyle->Directive[
    GrayLevel[0.5, 0.4]],
  Method->{},
  PlotRange->{{0., 101.}, {0, 0.4471354672429807}},
  PlotRangeClipping->True,
  PlotRangePadding->{{
     Scaled[0.02], 
     Scaled[0.02]}, {
     Scaled[0.02], 
     Scaled[0.05]}},
  Ticks->{Automatic, Automatic}]], "Output"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Visualize results", "Section"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", "components", " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{"Animate", "[", 
   RowBox[{
    RowBox[{"ListVectorPlot", "[", 
     RowBox[{
      RowBox[{"Table", "[", 
       RowBox[{
        RowBox[{"{", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{
            RowBox[{
             SubscriptBox["x", "list"], "\[LeftDoubleBracket]", "i", 
             "\[RightDoubleBracket]"}], ",", 
            RowBox[{
             SubscriptBox["y", "list"], "\[LeftDoubleBracket]", "j", 
             "\[RightDoubleBracket]"}]}], "}"}], ",", 
          RowBox[{
           SubscriptBox["f", "evolv"], "\[LeftDoubleBracket]", 
           RowBox[{
            RowBox[{"t", "+", "1"}], ",", "i", ",", "j", ",", 
            RowBox[{"{", 
             RowBox[{"2", ",", "3"}], "}"}]}], "\[RightDoubleBracket]"}]}], 
         "}"}], ",", 
        RowBox[{"{", 
         RowBox[{"i", ",", 
          SubscriptBox["dim", "1"]}], "}"}], ",", 
        RowBox[{"{", 
         RowBox[{"j", ",", 
          SubscriptBox["dim", "2"]}], "}"}]}], "]"}], ",", 
      RowBox[{"FrameLabel", "\[Rule]", 
       RowBox[{"{", 
        RowBox[{"\"\<x\>\"", ",", "\"\<y\>\""}], "}"}]}], ",", 
      RowBox[{"VectorStyle", "\[Rule]", "Blue"}], ",", 
      RowBox[{"PlotLabel", "\[Rule]", 
       RowBox[{"\"\<t: \>\"", "<>", 
        RowBox[{"ToString", "[", "t", "]"}]}]}]}], "]"}], ",", 
    RowBox[{"{", 
     RowBox[{"t", ",", "0", ",", 
      SubscriptBox["t", "max"], ",", "1"}], "}"}], ",", 
    RowBox[{"AnimationRunning", "\[Rule]", "False"}]}], "]"}]}]], "Input"],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`t$$ = 24, Typeset`show$$ = True, 
    Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{
      Hold[$CellContext`t$$], 0, 100, 1}}, Typeset`size$$ = {
    360., {184., 189.}}, Typeset`update$$ = 0, Typeset`initDone$$, 
    Typeset`skipInitDone$$ = True, $CellContext`t$264308$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, "Variables" :> {$CellContext`t$$ = 0}, 
      "ControllerVariables" :> {
        Hold[$CellContext`t$$, $CellContext`t$264308$$, 0]}, 
      "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> ListVectorPlot[
        Table[{{
           Part[
            Subscript[$CellContext`x, $CellContext`list], $CellContext`i], 
           Part[
            Subscript[$CellContext`y, $CellContext`list], $CellContext`j]}, 
          Part[
           Subscript[$CellContext`f, $CellContext`evolv], $CellContext`t$$ + 
           1, $CellContext`i, $CellContext`j, {2, 3}]}, {$CellContext`i, 
          Subscript[$CellContext`dim, 1]}, {$CellContext`j, 
          Subscript[$CellContext`dim, 2]}], FrameLabel -> {"x", "y"}, 
        VectorStyle -> Blue, PlotLabel -> StringJoin["t: ", 
          ToString[$CellContext`t$$]]], 
      "Specifications" :> {{$CellContext`t$$, 0, 100, 1, AnimationRunning -> 
         False, AppearanceElements -> {
          "ProgressSlider", "PlayPauseButton", "FasterSlowerButtons", 
           "DirectionButton"}}}, 
      "Options" :> {
       ControlType -> Animator, AppearanceElements -> None, DefaultBaseStyle -> 
        "Animate", DefaultLabelStyle -> "AnimateLabel", SynchronousUpdating -> 
        True, ShrinkingDelay -> 10.}, "DefaultOptions" :> {}],
     ImageSizeCache->{411., {222., 229.}},
     SingleEvaluation->True],
    Deinitialization:>None,
    DynamicModuleValues:>{},
    SynchronousInitialization->True,
    UnsavedVariables:>{Typeset`initDone$$},
    UntrackedVariables:>{Typeset`size$$}], "Animate",
   Deployed->True,
   StripOnInput->False],
  Manipulate`InterpretManipulate[1]]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", "density", " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{"Animate", "[", 
   RowBox[{
    RowBox[{"ListDensityPlot", "[", 
     RowBox[{
      RowBox[{"Flatten", "[", 
       RowBox[{
        RowBox[{"Table", "[", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{
            RowBox[{
             SubscriptBox["x", "list"], "\[LeftDoubleBracket]", "i", 
             "\[RightDoubleBracket]"}], ",", 
            RowBox[{
             SubscriptBox["y", "list"], "\[LeftDoubleBracket]", "j", 
             "\[RightDoubleBracket]"}], ",", 
            RowBox[{
             SubscriptBox["\[Rho]", "evolv"], "\[LeftDoubleBracket]", 
             RowBox[{
              RowBox[{"t", "+", "1"}], ",", "i", ",", "j"}], 
             "\[RightDoubleBracket]"}]}], "}"}], ",", 
          RowBox[{"{", 
           RowBox[{"i", ",", 
            SubscriptBox["dim", "1"]}], "}"}], ",", 
          RowBox[{"{", 
           RowBox[{"j", ",", 
            SubscriptBox["dim", "2"]}], "}"}]}], "]"}], ",", "1"}], "]"}], 
      ",", 
      RowBox[{"FrameLabel", "\[Rule]", 
       RowBox[{"{", 
        RowBox[{"\"\<x\>\"", ",", "\"\<y\>\""}], "}"}]}], ",", 
      RowBox[{"PlotLegends", "\[Rule]", "Automatic"}], ",", 
      RowBox[{"ColorFunction", "\[Rule]", 
       RowBox[{"(", 
        RowBox[{
         RowBox[{
          RowBox[{"ColorData", "[", "\"\<DeepSeaColors\>\"", "]"}], "[", 
          RowBox[{"1", "-", 
           RowBox[{"(", 
            RowBox[{"#", "-", "2.2"}], ")"}]}], "]"}], "&"}], ")"}]}], ",", 
      RowBox[{"ColorFunctionScaling", "\[Rule]", "False"}], ",", 
      RowBox[{"PlotLabel", "\[Rule]", 
       RowBox[{"\"\<t: \>\"", "<>", 
        RowBox[{"ToString", "[", "t", "]"}]}]}]}], "]"}], ",", 
    RowBox[{"{", 
     RowBox[{"t", ",", "0", ",", 
      SubscriptBox["t", "max"], ",", "1"}], "}"}], ",", 
    RowBox[{"AnimationRunning", "\[Rule]", "False"}]}], "]"}]}]], "Input"],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`t$$ = 16, Typeset`show$$ = True, 
    Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{
      Hold[$CellContext`t$$], 0, 100, 1}}, Typeset`size$$ = {
    426., {184., 189.}}, Typeset`update$$ = 0, Typeset`initDone$$, 
    Typeset`skipInitDone$$ = True, $CellContext`t$278900$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, "Variables" :> {$CellContext`t$$ = 0}, 
      "ControllerVariables" :> {
        Hold[$CellContext`t$$, $CellContext`t$278900$$, 0]}, 
      "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> ListDensityPlot[
        Flatten[
         Table[{
           Part[
            Subscript[$CellContext`x, $CellContext`list], $CellContext`i], 
           Part[
            Subscript[$CellContext`y, $CellContext`list], $CellContext`j], 
           Part[
            
            Subscript[$CellContext`\[Rho], $CellContext`evolv], \
$CellContext`t$$ + 1, $CellContext`i, $CellContext`j]}, {$CellContext`i, 
           Subscript[$CellContext`dim, 1]}, {$CellContext`j, 
           Subscript[$CellContext`dim, 2]}], 1], FrameLabel -> {"x", "y"}, 
        PlotLegends -> Automatic, 
        ColorFunction -> (ColorData["DeepSeaColors"][1 - (# - 2.2)]& ), 
        ColorFunctionScaling -> False, PlotLabel -> StringJoin["t: ", 
          ToString[$CellContext`t$$]]], 
      "Specifications" :> {{$CellContext`t$$, 0, 100, 1, AnimationRunning -> 
         False, AppearanceElements -> {
          "ProgressSlider", "PlayPauseButton", "FasterSlowerButtons", 
           "DirectionButton"}}}, 
      "Options" :> {
       ControlType -> Animator, AppearanceElements -> None, DefaultBaseStyle -> 
        "Animate", DefaultLabelStyle -> "AnimateLabel", SynchronousUpdating -> 
        True, ShrinkingDelay -> 10.}, "DefaultOptions" :> {}],
     ImageSizeCache->{477., {222., 229.}},
     SingleEvaluation->True],
    Deinitialization:>None,
    DynamicModuleValues:>{},
    SynchronousInitialization->True,
    UnsavedVariables:>{Typeset`initDone$$},
    UntrackedVariables:>{Typeset`size$$}], "Animate",
   Deployed->True,
   StripOnInput->False],
  Manipulate`InterpretManipulate[1]]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", "velocity", " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{"Animate", "[", 
   RowBox[{
    RowBox[{"ListVectorPlot", "[", 
     RowBox[{
      RowBox[{"Table", "[", 
       RowBox[{
        RowBox[{"{", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{
            RowBox[{
             SubscriptBox["x", "list"], "\[LeftDoubleBracket]", "i", 
             "\[RightDoubleBracket]"}], ",", 
            RowBox[{
             SubscriptBox["y", "list"], "\[LeftDoubleBracket]", "j", 
             "\[RightDoubleBracket]"}]}], "}"}], ",", 
          RowBox[{
           SubscriptBox["u", "evolv"], "\[LeftDoubleBracket]", 
           RowBox[{
            RowBox[{"t", "+", "1"}], ",", "i", ",", "j"}], 
           "\[RightDoubleBracket]"}]}], "}"}], ",", 
        RowBox[{"{", 
         RowBox[{"i", ",", 
          SubscriptBox["dim", "1"]}], "}"}], ",", 
        RowBox[{"{", 
         RowBox[{"j", ",", 
          SubscriptBox["dim", "2"]}], "}"}]}], "]"}], ",", 
      RowBox[{"FrameLabel", "\[Rule]", 
       RowBox[{"{", 
        RowBox[{"\"\<x\>\"", ",", "\"\<y\>\""}], "}"}]}], ",", 
      RowBox[{"VectorStyle", "\[Rule]", "Blue"}], ",", 
      RowBox[{"PlotLabel", "\[Rule]", 
       RowBox[{"\"\<t: \>\"", "<>", 
        RowBox[{"ToString", "[", "t", "]"}]}]}]}], "]"}], ",", 
    RowBox[{"{", 
     RowBox[{"t", ",", "0", ",", 
      SubscriptBox["t", "max"], ",", "1"}], "}"}], ",", 
    RowBox[{"AnimationRunning", "\[Rule]", "False"}]}], "]"}]}]], "Input"],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`t$$ = 26, Typeset`show$$ = True, 
    Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{
      Hold[$CellContext`t$$], 0, 100, 1}}, Typeset`size$$ = {
    360., {184., 189.}}, Typeset`update$$ = 0, Typeset`initDone$$, 
    Typeset`skipInitDone$$ = True, $CellContext`t$275642$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, "Variables" :> {$CellContext`t$$ = 0}, 
      "ControllerVariables" :> {
        Hold[$CellContext`t$$, $CellContext`t$275642$$, 0]}, 
      "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> ListVectorPlot[
        Table[{{
           Part[
            Subscript[$CellContext`x, $CellContext`list], $CellContext`i], 
           Part[
            Subscript[$CellContext`y, $CellContext`list], $CellContext`j]}, 
          Part[
           Subscript[$CellContext`u, $CellContext`evolv], $CellContext`t$$ + 
           1, $CellContext`i, $CellContext`j]}, {$CellContext`i, 
          Subscript[$CellContext`dim, 1]}, {$CellContext`j, 
          Subscript[$CellContext`dim, 2]}], FrameLabel -> {"x", "y"}, 
        VectorStyle -> Blue, PlotLabel -> StringJoin["t: ", 
          ToString[$CellContext`t$$]]], 
      "Specifications" :> {{$CellContext`t$$, 0, 100, 1, AnimationRunning -> 
         False, AppearanceElements -> {
          "ProgressSlider", "PlayPauseButton", "FasterSlowerButtons", 
           "DirectionButton"}}}, 
      "Options" :> {
       ControlType -> Animator, AppearanceElements -> None, DefaultBaseStyle -> 
        "Animate", DefaultLabelStyle -> "AnimateLabel", SynchronousUpdating -> 
        True, ShrinkingDelay -> 10.}, "DefaultOptions" :> {}],
     ImageSizeCache->{411., {222., 229.}},
     SingleEvaluation->True],
    Deinitialization:>None,
    DynamicModuleValues:>{},
    SynchronousInitialization->True,
    UnsavedVariables:>{Typeset`initDone$$},
    UntrackedVariables:>{Typeset`size$$}], "Animate",
   Deployed->True,
   StripOnInput->False],
  Manipulate`InterpretManipulate[1]]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{"internal", " ", "energy"}], " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{"Animate", "[", 
   RowBox[{
    RowBox[{"ListDensityPlot", "[", 
     RowBox[{
      RowBox[{"Flatten", "[", 
       RowBox[{
        RowBox[{"Table", "[", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{
            RowBox[{
             SubscriptBox["x", "list"], "\[LeftDoubleBracket]", "i", 
             "\[RightDoubleBracket]"}], ",", 
            RowBox[{
             SubscriptBox["y", "list"], "\[LeftDoubleBracket]", "j", 
             "\[RightDoubleBracket]"}], ",", 
            RowBox[{
             SubscriptBox["en", 
              RowBox[{"int", ",", "evolv"}]], "\[LeftDoubleBracket]", 
             RowBox[{
              RowBox[{"t", "+", "1"}], ",", "i", ",", "j"}], 
             "\[RightDoubleBracket]"}]}], "}"}], ",", 
          RowBox[{"{", 
           RowBox[{"i", ",", 
            SubscriptBox["dim", "1"]}], "}"}], ",", 
          RowBox[{"{", 
           RowBox[{"j", ",", 
            SubscriptBox["dim", "2"]}], "}"}]}], "]"}], ",", "1"}], "]"}], 
      ",", 
      RowBox[{"FrameLabel", "\[Rule]", 
       RowBox[{"{", 
        RowBox[{"\"\<x\>\"", ",", "\"\<y\>\""}], "}"}]}], ",", 
      RowBox[{"PlotLabel", "\[Rule]", 
       RowBox[{"\"\<t: \>\"", "<>", 
        RowBox[{"ToString", "[", "t", "]"}]}]}], ",", 
      RowBox[{"PlotLegends", "\[Rule]", "Automatic"}], ",", 
      RowBox[{"ColorFunction", "\[Rule]", 
       RowBox[{"(", 
        RowBox[{
         RowBox[{
          RowBox[{"ColorData", "[", "\"\<SolarColors\>\"", "]"}], "[", 
          RowBox[{
           RowBox[{"3", "#"}], "-", "1"}], "]"}], "&"}], ")"}]}], ",", 
      RowBox[{"ColorFunctionScaling", "\[Rule]", "False"}]}], "]"}], ",", 
    RowBox[{"{", 
     RowBox[{"t", ",", "0", ",", 
      SubscriptBox["t", "max"], ",", "1"}], "}"}], ",", 
    RowBox[{"AnimationRunning", "\[Rule]", "False"}]}], "]"}]}]], "Input"],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`t$$ = 36, Typeset`show$$ = True, 
    Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{
      Hold[$CellContext`t$$], 0, 100, 1}}, Typeset`size$$ = {
    426., {184., 189.}}, Typeset`update$$ = 0, Typeset`initDone$$, 
    Typeset`skipInitDone$$ = True, $CellContext`t$276353$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, "Variables" :> {$CellContext`t$$ = 0}, 
      "ControllerVariables" :> {
        Hold[$CellContext`t$$, $CellContext`t$276353$$, 0]}, 
      "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> ListDensityPlot[
        Flatten[
         Table[{
           Part[
            Subscript[$CellContext`x, $CellContext`list], $CellContext`i], 
           Part[
            Subscript[$CellContext`y, $CellContext`list], $CellContext`j], 
           Part[
            
            Subscript[$CellContext`en, $CellContext`int, $CellContext`evolv], \
$CellContext`t$$ + 1, $CellContext`i, $CellContext`j]}, {$CellContext`i, 
           Subscript[$CellContext`dim, 1]}, {$CellContext`j, 
           Subscript[$CellContext`dim, 2]}], 1], FrameLabel -> {"x", "y"}, 
        PlotLabel -> StringJoin["t: ", 
          ToString[$CellContext`t$$]], PlotLegends -> Automatic, 
        ColorFunction -> (ColorData["SolarColors"][3 # - 1]& ), 
        ColorFunctionScaling -> False], 
      "Specifications" :> {{$CellContext`t$$, 0, 100, 1, AnimationRunning -> 
         False, AppearanceElements -> {
          "ProgressSlider", "PlayPauseButton", "FasterSlowerButtons", 
           "DirectionButton"}}}, 
      "Options" :> {
       ControlType -> Animator, AppearanceElements -> None, DefaultBaseStyle -> 
        "Animate", DefaultLabelStyle -> "AnimateLabel", SynchronousUpdating -> 
        True, ShrinkingDelay -> 10.}, "DefaultOptions" :> {}],
     ImageSizeCache->{477., {222., 229.}},
     SingleEvaluation->True],
    Deinitialization:>None,
    DynamicModuleValues:>{},
    SynchronousInitialization->True,
    UnsavedVariables:>{Typeset`initDone$$},
    UntrackedVariables:>{Typeset`size$$}], "Animate",
   Deployed->True,
   StripOnInput->False],
  Manipulate`InterpretManipulate[1]]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{"total", " ", "energy"}], " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{"Animate", "[", 
   RowBox[{
    RowBox[{"ListDensityPlot", "[", 
     RowBox[{
      RowBox[{"Flatten", "[", 
       RowBox[{
        RowBox[{"Table", "[", 
         RowBox[{
          RowBox[{"{", 
           RowBox[{
            RowBox[{
             SubscriptBox["x", "list"], "\[LeftDoubleBracket]", "i", 
             "\[RightDoubleBracket]"}], ",", 
            RowBox[{
             SubscriptBox["y", "list"], "\[LeftDoubleBracket]", "j", 
             "\[RightDoubleBracket]"}], ",", 
            RowBox[{
             SubscriptBox["en", 
              RowBox[{"tot", ",", "evolv"}]], "\[LeftDoubleBracket]", 
             RowBox[{
              RowBox[{"t", "+", "1"}], ",", "i", ",", "j"}], 
             "\[RightDoubleBracket]"}]}], "}"}], ",", 
          RowBox[{"{", 
           RowBox[{"i", ",", 
            SubscriptBox["dim", "1"]}], "}"}], ",", 
          RowBox[{"{", 
           RowBox[{"j", ",", 
            SubscriptBox["dim", "2"]}], "}"}]}], "]"}], ",", "1"}], "]"}], 
      ",", 
      RowBox[{"FrameLabel", "\[Rule]", 
       RowBox[{"{", 
        RowBox[{"\"\<x\>\"", ",", "\"\<y\>\""}], "}"}]}], ",", 
      RowBox[{"PlotLabel", "\[Rule]", 
       RowBox[{"\"\<t: \>\"", "<>", 
        RowBox[{"ToString", "[", "t", "]"}]}]}], ",", 
      RowBox[{"PlotLegends", "\[Rule]", "Automatic"}], ",", 
      RowBox[{"ColorFunction", "\[Rule]", 
       RowBox[{"(", 
        RowBox[{
         RowBox[{
          RowBox[{"ColorData", "[", "\"\<SolarColors\>\"", "]"}], "[", 
          RowBox[{
           RowBox[{"3", "#"}], "-", "1"}], "]"}], "&"}], ")"}]}], ",", 
      RowBox[{"ColorFunctionScaling", "\[Rule]", "False"}]}], "]"}], ",", 
    RowBox[{"{", 
     RowBox[{"t", ",", "0", ",", 
      SubscriptBox["t", "max"], ",", "1"}], "}"}], ",", 
    RowBox[{"AnimationRunning", "\[Rule]", "False"}]}], "]"}]}]], "Input"],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`t$$ = 21, Typeset`show$$ = True, 
    Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{
      Hold[$CellContext`t$$], 0, 100, 1}}, Typeset`size$$ = {
    432., {184., 189.}}, Typeset`update$$ = 0, Typeset`initDone$$, 
    Typeset`skipInitDone$$ = True, $CellContext`t$277492$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, "Variables" :> {$CellContext`t$$ = 0}, 
      "ControllerVariables" :> {
        Hold[$CellContext`t$$, $CellContext`t$277492$$, 0]}, 
      "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> ListDensityPlot[
        Flatten[
         Table[{
           Part[
            Subscript[$CellContext`x, $CellContext`list], $CellContext`i], 
           Part[
            Subscript[$CellContext`y, $CellContext`list], $CellContext`j], 
           Part[
            
            Subscript[$CellContext`en, $CellContext`tot, $CellContext`evolv], \
$CellContext`t$$ + 1, $CellContext`i, $CellContext`j]}, {$CellContext`i, 
           Subscript[$CellContext`dim, 1]}, {$CellContext`j, 
           Subscript[$CellContext`dim, 2]}], 1], FrameLabel -> {"x", "y"}, 
        PlotLabel -> StringJoin["t: ", 
          ToString[$CellContext`t$$]], PlotLegends -> Automatic, 
        ColorFunction -> (ColorData["SolarColors"][3 # - 1]& ), 
        ColorFunctionScaling -> False], 
      "Specifications" :> {{$CellContext`t$$, 0, 100, 1, AnimationRunning -> 
         False, AppearanceElements -> {
          "ProgressSlider", "PlayPauseButton", "FasterSlowerButtons", 
           "DirectionButton"}}}, 
      "Options" :> {
       ControlType -> Animator, AppearanceElements -> None, DefaultBaseStyle -> 
        "Animate", DefaultLabelStyle -> "AnimateLabel", SynchronousUpdating -> 
        True, ShrinkingDelay -> 10.}, "DefaultOptions" :> {}],
     ImageSizeCache->{483., {222., 229.}},
     SingleEvaluation->True],
    Deinitialization:>None,
    DynamicModuleValues:>{},
    SynchronousInitialization->True,
    UnsavedVariables:>{Typeset`initDone$$},
    UntrackedVariables:>{Typeset`size$$}], "Animate",
   Deployed->True,
   StripOnInput->False],
  Manipulate`InterpretManipulate[1]]], "Output"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Clean up", "Section"],

Cell[BoxData[
 RowBox[{
  RowBox[{"Uninstall", "[", "lbmLink", "]"}], ";"}]], "Input"]
}, Open  ]]
}, Open  ]]
},
WindowSize->{1049, 828},
WindowMargins->{{Automatic, 430}, {100, Automatic}},
ShowSelection->True,
TrackCellChangeTimes->False,
FrontEndVersion->"10.0 for Microsoft Windows (64-bit) (July 1, 2014)",
StyleDefinitions->"Default.nb"
]
(* End of Notebook Content *)

(* Internal cache information *)
(*CellTagsOutline
CellTagsIndex->{
 "Info3627999022-9058970"->{
  Cell[83424, 1787, 239, 4, 40, "Print",
   CellTags->"Info3627999022-9058970"]}
 }
*)
(*CellTagsIndex
CellTagsIndex->{
 {"Info3627999022-9058970", 121686, 2815}
 }
*)
(*NotebookFileOutline
Notebook[{
Cell[CellGroupData[{
Cell[1486, 35, 47, 0, 90, "Title"],
Cell[1536, 37, 926, 19, 258, "Text"],
Cell[2465, 58, 123, 3, 31, "Input"],
Cell[2591, 63, 187, 5, 31, "Input"],
Cell[2781, 70, 411, 12, 52, "Input"],
Cell[CellGroupData[{
Cell[3217, 86, 35, 0, 63, "Section"],
Cell[3255, 88, 803, 28, 31, "Input"],
Cell[CellGroupData[{
Cell[4083, 120, 328, 11, 31, "Input"],
Cell[4414, 133, 249, 5, 195, "Output"]
}, Open  ]],
Cell[4678, 141, 117, 3, 31, "Input"],
Cell[4798, 146, 794, 24, 46, "Input"],
Cell[5595, 172, 1006, 31, 75, "Input"],
Cell[6604, 205, 872, 27, 46, "Input"]
}, Open  ]],
Cell[CellGroupData[{
Cell[7513, 237, 44, 0, 63, "Section"],
Cell[7560, 239, 189, 6, 52, "Input"],
Cell[7752, 247, 352, 11, 31, "Input"],
Cell[8107, 260, 521, 18, 52, "Input"],
Cell[CellGroupData[{
Cell[8653, 282, 1678, 48, 97, "Input"],
Cell[10334, 332, 85, 2, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[10456, 339, 222, 5, 52, "Input"],
Cell[10681, 346, 329, 7, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[11047, 358, 1419, 38, 72, "Input"],
Cell[12469, 398, 31494, 582, 375, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[44000, 985, 1146, 32, 72, "Input"],
Cell[45149, 1019, 36737, 697, 373, "Output"]
}, Open  ]],
Cell[81901, 1719, 246, 8, 52, "Input"],
Cell[82150, 1729, 300, 10, 31, "Input"]
}, Open  ]],
Cell[CellGroupData[{
Cell[82487, 1744, 33, 0, 63, "Section"],
Cell[82523, 1746, 123, 4, 31, "Input"],
Cell[82649, 1752, 254, 8, 52, "Input"],
Cell[82906, 1762, 94, 3, 31, "Input"],
Cell[CellGroupData[{
Cell[83025, 1769, 267, 8, 52, "Input"],
Cell[83295, 1779, 30, 0, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[83362, 1784, 59, 1, 31, "Input"],
Cell[83424, 1787, 239, 4, 40, "Print",
 CellTags->"Info3627999022-9058970"]
}, Open  ]],
Cell[CellGroupData[{
Cell[83700, 1796, 733, 22, 52, "Input"],
Cell[84436, 1820, 97, 2, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[84570, 1827, 392, 11, 52, "Input"],
Cell[84965, 1840, 460, 14, 31, "Output"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[85474, 1860, 42, 0, 63, "Section"],
Cell[CellGroupData[{
Cell[85541, 1864, 716, 22, 52, "Input"],
Cell[86260, 1888, 87, 2, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[86384, 1895, 919, 28, 72, "Input"],
Cell[87306, 1925, 1905, 44, 238, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[89248, 1974, 712, 22, 52, "Input"],
Cell[89963, 1998, 97, 2, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[90097, 2005, 1402, 41, 92, "Input"],
Cell[91502, 2048, 2321, 51, 235, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[93860, 2104, 746, 23, 52, "Input"],
Cell[94609, 2129, 87, 2, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[94733, 2136, 743, 23, 52, "Input"],
Cell[95479, 2161, 87, 2, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[95603, 2168, 1495, 43, 92, "Input"],
Cell[97101, 2213, 2262, 50, 255, "Output"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[99412, 2269, 36, 0, 63, "Section"],
Cell[CellGroupData[{
Cell[99473, 2273, 1603, 42, 92, "Input"],
Cell[101079, 2317, 2406, 48, 468, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[103522, 2370, 1956, 50, 92, "Input"],
Cell[105481, 2422, 2549, 52, 468, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[108067, 2479, 1526, 40, 92, "Input"],
Cell[109596, 2521, 2398, 48, 468, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[112031, 2574, 1977, 51, 112, "Input"],
Cell[114011, 2627, 2555, 52, 468, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[116603, 2684, 1974, 51, 112, "Input"],
Cell[118580, 2737, 2555, 52, 468, "Output"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[121184, 2795, 27, 0, 63, "Section"],
Cell[121214, 2797, 86, 2, 31, "Input"]
}, Open  ]]
}, Open  ]]
}
]
*)

(* End of internal cache information *)

(* NotebookSignature gw0C1YFEevnN@AK@WoPl9r06 *)
