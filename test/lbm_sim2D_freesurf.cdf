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
NotebookDataLength[    494931,       9579]
NotebookOptionsPosition[    491383,       9439]
NotebookOutlinePosition[    491933,       9462]
CellTagsIndexPosition[    491846,       9457]
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
  RowBox[{
   SubscriptBox["vel", "2"], "=", 
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
     SubscriptBox["vel", "2"]}], "]"}], ",", 
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
  RowBox[{
   SubscriptBox["weights", "2"], "=", 
   RowBox[{"{", 
    RowBox[{
     RowBox[{"4", "/", "9"}], ",", 
     RowBox[{"1", "/", "9"}], ",", 
     RowBox[{"1", "/", "9"}], ",", 
     RowBox[{"1", "/", "9"}], ",", 
     RowBox[{"1", "/", "9"}], ",", 
     RowBox[{"1", "/", "36"}], ",", 
     RowBox[{"1", "/", "36"}], ",", 
     RowBox[{"1", "/", "36"}], ",", 
     RowBox[{"1", "/", "36"}]}], "}"}]}], ";"}]], "Input"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", "check", " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{"Total", "[", 
    SubscriptBox["vel", "2"], "]"}], "\[IndentingNewLine]", 
   RowBox[{"Total", "[", 
    SubscriptBox["weights", "2"], "]"}]}]}]], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"0", ",", "0"}], "}"}]], "Output"],

Cell[BoxData["1"], "Output"]
}, Open  ]],

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{"LBM", " ", "equilibrium", " ", "distribution"}], " ", "*)"}], 
  "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{"LBMeq", "[", 
    RowBox[{"\[Rho]_", ",", "u_"}], "]"}], ":=", 
   RowBox[{"Table", "[", 
    RowBox[{
     RowBox[{"\[Rho]", " ", 
      RowBox[{
       SubscriptBox["weights", "2"], "\[LeftDoubleBracket]", "i", 
       "\[RightDoubleBracket]"}], 
      RowBox[{"(", 
       RowBox[{"1", "+", 
        RowBox[{"3", 
         RowBox[{
          RowBox[{
           SubscriptBox["vel", "2"], "\[LeftDoubleBracket]", "i", 
           "\[RightDoubleBracket]"}], ".", "u"}]}], "-", 
        RowBox[{
         FractionBox["3", "2"], 
         RowBox[{"u", ".", "u"}]}], "+", 
        RowBox[{
         FractionBox["9", "2"], 
         SuperscriptBox[
          RowBox[{"(", 
           RowBox[{
            RowBox[{
             SubscriptBox["vel", "2"], "\[LeftDoubleBracket]", "i", 
             "\[RightDoubleBracket]"}], ".", "u"}], ")"}], "2"]}]}], ")"}]}], 
     ",", 
     RowBox[{"{", 
      RowBox[{"i", ",", 
       RowBox[{"Length", "[", 
        SubscriptBox["weights", "2"], "]"}]}], "}"}]}], "]"}]}]}]], "Input"],

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
           SubscriptBox["vel", "2"], "\[LeftDoubleBracket]", "i", 
           "\[RightDoubleBracket]"}]}], ",", 
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
              SubscriptBox["vel", "2"], "\[LeftDoubleBracket]", "i", 
              "\[RightDoubleBracket]"}], "-", "u"}], "]"}], "2"], 
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
             SubscriptBox["vel", "2"], "\[LeftDoubleBracket]", "i", 
             "\[RightDoubleBracket]"}], "]"}], "2"], 
          RowBox[{
          "f", "\[LeftDoubleBracket]", "i", "\[RightDoubleBracket]"}]}], ",", 
         RowBox[{"{", 
          RowBox[{"i", ",", 
           RowBox[{"Length", "[", "f", "]"}]}], "}"}]}], "]"}]}], ",", "0"}], 
     "]"}]}], "]"}]}]], "Input"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", "density", " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{"FullSimplify", "[", 
   RowBox[{"Density", "[", 
    RowBox[{"LBMeq", "[", 
     RowBox[{"\[Rho]", ",", 
      RowBox[{"{", 
       RowBox[{
        SubscriptBox["u", "1"], ",", 
        SubscriptBox["u", "2"]}], "}"}]}], "]"}], "]"}], "]"}]}]], "Input"],

Cell[BoxData["\[Rho]"], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{"average", " ", "velocity"}], " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{"FullSimplify", "[", 
   RowBox[{
    RowBox[{"Velocity", "[", 
     RowBox[{"LBMeq", "[", 
      RowBox[{"\[Rho]", ",", 
       RowBox[{"{", 
        RowBox[{
         SubscriptBox["u", "1"], ",", 
         SubscriptBox["u", "2"]}], "}"}]}], "]"}], "]"}], ",", 
    RowBox[{"Assumptions", "\[RuleDelayed]", 
     RowBox[{"{", 
      RowBox[{"\[Rho]", ">", "0"}], "}"}]}]}], "]"}]}]], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{
   SubscriptBox["u", "1"], ",", 
   SubscriptBox["u", "2"]}], "}"}]], "Output"]
}, Open  ]],

Cell[BoxData[{
 RowBox[{
  RowBox[{
   SubscriptBox["ct", "obstacle"], "=", 
   SuperscriptBox["2", "0"]}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   SubscriptBox["ct", "fluid"], "=", 
   SuperscriptBox["2", "1"]}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   SubscriptBox["ct", "interface"], "=", 
   SuperscriptBox["2", "2"]}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   SubscriptBox["ct", "empty"], "=", 
   SuperscriptBox["2", "3"]}], ";"}]}], "Input"],

Cell[BoxData[
 RowBox[{
  RowBox[{"VisualizeTypeField", "[", 
   RowBox[{"typefield_", ",", 
    RowBox[{"plotlabel_:", "None"}]}], "]"}], ":=", 
  RowBox[{"ArrayPlot", "[", 
   RowBox[{
    RowBox[{"Reverse", "[", 
     RowBox[{"Transpose", "[", "typefield", "]"}], "]"}], ",", 
    RowBox[{"Mesh", "\[Rule]", "True"}], ",", 
    RowBox[{"ColorRules", "\[Rule]", 
     RowBox[{"{", 
      RowBox[{
       RowBox[{
        SubscriptBox["ct", "obstacle"], "\[Rule]", "Red"}], ",", 
       RowBox[{
        SubscriptBox["ct", "fluid"], "\[Rule]", "Blue"}], ",", 
       RowBox[{
        SubscriptBox["ct", "interface"], "\[Rule]", 
        RowBox[{"RGBColor", "[", 
         RowBox[{"{", 
          RowBox[{
           RowBox[{"1", "/", "2"}], ",", 
           RowBox[{"1", "/", "2"}], ",", "1"}], "}"}], "]"}]}], ",", 
       RowBox[{
        SubscriptBox["ct", "empty"], "\[Rule]", "White"}]}], "}"}]}], ",", 
    RowBox[{"Axes", "\[Rule]", "True"}], ",", 
    RowBox[{"AxesLabel", "\[Rule]", 
     RowBox[{"{", 
      RowBox[{"\"\<x\>\"", ",", "\"\<y\>\""}], "}"}]}], ",", 
    RowBox[{"PlotLabel", "\[Rule]", "plotlabel"}]}], "]"}]}]], "Input"]
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

Cell[BoxData[{
 RowBox[{
  RowBox[{
   SubscriptBox["x", "list"], "=", 
   RowBox[{"Range", "[", 
    RowBox[{"0", ",", 
     RowBox[{
      SubscriptBox["dim", "1"], "-", "1"}]}], "]"}]}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   SubscriptBox["y", "list"], "=", 
   RowBox[{"Range", "[", 
    RowBox[{"0", ",", 
     RowBox[{
      SubscriptBox["dim", "2"], "-", "1"}]}], "]"}]}], ";"}]}], "Input"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{
   SubscriptBox["type", "0"], "=", 
   RowBox[{"Block", "[", 
    RowBox[{
     RowBox[{"{", "t0", "}"}], ",", 
     RowBox[{
      RowBox[{"t0", "=", 
       RowBox[{"Table", "[", 
        RowBox[{
         RowBox[{"If", "[", 
          RowBox[{
           RowBox[{
            RowBox[{"i", "\[Equal]", "1"}], "\[Or]", 
            RowBox[{"i", "\[Equal]", 
             SubscriptBox["dim", "1"]}], "\[Or]", 
            RowBox[{"j", "\[Equal]", "1"}], "\[Or]", 
            RowBox[{"j", "\[Equal]", 
             SubscriptBox["dim", "2"]}]}], ",", 
           SubscriptBox["ct", "obstacle"], ",", 
           RowBox[{"If", "[", 
            RowBox[{
             RowBox[{
              RowBox[{"Norm", "[", 
               RowBox[{"{", 
                RowBox[{
                 RowBox[{"i", "-", 
                  RowBox[{
                   SubscriptBox["dim", "1"], "/", "2"}], "-", "1"}], ",", 
                 RowBox[{"j", "-", 
                  RowBox[{"3", 
                   RowBox[{
                    SubscriptBox["dim", "2"], "/", "4"}]}], "-", "1"}]}], 
                "}"}], "]"}], "<", 
              RowBox[{
               SubscriptBox["dim", "1"], "/", "4"}]}], ",", 
             SubscriptBox["ct", "fluid"], ",", 
             SubscriptBox["ct", "interface"]}], "]"}]}], "]"}], ",", 
         RowBox[{"{", 
          RowBox[{"i", ",", 
           SubscriptBox["dim", "1"]}], "}"}], ",", 
         RowBox[{"{", 
          RowBox[{"j", ",", 
           SubscriptBox["dim", "2"]}], "}"}]}], "]"}]}], ";", 
      RowBox[{"Table", "[", 
       RowBox[{
        RowBox[{"If", "[", 
         RowBox[{
          RowBox[{
           RowBox[{"Norm", "[", 
            RowBox[{
             RowBox[{"(", 
              RowBox[{
               RowBox[{"t0", "\[LeftDoubleBracket]", 
                RowBox[{
                 RowBox[{
                  RowBox[{"i", "-", "1"}], ";;", 
                  RowBox[{"i", "+", "1"}]}], ",", 
                 RowBox[{
                  RowBox[{"j", "-", "1"}], ";;", 
                  RowBox[{"j", "+", "1"}]}]}], "\[RightDoubleBracket]"}], "/.", 
               RowBox[{"{", 
                RowBox[{
                 RowBox[{
                  SubscriptBox["ct", "obstacle"], "\[Rule]", 
                  SubscriptBox["ct", "interface"]}], ",", 
                 RowBox[{
                  SubscriptBox["ct", "empty"], "\[Rule]", 
                  SubscriptBox["ct", "interface"]}]}], "}"}]}], ")"}], "-", 
             RowBox[{"ConstantArray", "[", 
              RowBox[{
               SubscriptBox["ct", "interface"], ",", 
               RowBox[{"{", 
                RowBox[{"3", ",", "3"}], "}"}]}], "]"}]}], "]"}], "\[Equal]", 
           "0"}], ",", 
          RowBox[{
           RowBox[{"t0", "\[LeftDoubleBracket]", 
            RowBox[{"i", ",", "j"}], "\[RightDoubleBracket]"}], "=", 
           SubscriptBox["ct", "empty"]}]}], "]"}], ",", 
        RowBox[{"{", 
         RowBox[{"i", ",", "2", ",", 
          RowBox[{
           SubscriptBox["dim", "1"], "-", "1"}]}], "}"}], ",", 
        RowBox[{"{", 
         RowBox[{"j", ",", "2", ",", 
          RowBox[{
           SubscriptBox["dim", "2"], "-", "1"}]}], "}"}]}], "]"}], ";", 
      "t0"}]}], "]"}]}], ";"}], "\[IndentingNewLine]", 
 RowBox[{"Dimensions", "[", 
  SubscriptBox["type", "0"], "]"}]}], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"16", ",", "32"}], "}"}]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", "example", " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{
   SubscriptBox["type", "0"], "//", "MatrixForm"}]}]], "Input"],

Cell[BoxData[
 TagBox[
  RowBox[{"(", "\[NoBreak]", GridBox[{
     {"1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
      "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
      "1", "1", "1", "1"},
     {"1", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", 
      "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", 
      "8", "8", "8", "1"},
     {"1", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", 
      "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", 
      "8", "8", "8", "1"},
     {"1", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", 
      "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", 
      "8", "8", "8", "1"},
     {"1", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", 
      "8", "8", "8", "8", "8", "8", "8", "4", "4", "4", "4", "4", "4", "4", 
      "8", "8", "8", "1"},
     {"1", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", 
      "8", "8", "8", "8", "8", "8", "4", "4", "2", "2", "2", "2", "2", "4", 
      "4", "8", "8", "1"},
     {"1", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", 
      "8", "8", "8", "8", "8", "8", "4", "2", "2", "2", "2", "2", "2", "2", 
      "4", "8", "8", "1"},
     {"1", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", 
      "8", "8", "8", "8", "8", "8", "4", "2", "2", "2", "2", "2", "2", "2", 
      "4", "8", "8", "1"},
     {"1", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", 
      "8", "8", "8", "8", "8", "8", "4", "2", "2", "2", "2", "2", "2", "2", 
      "4", "8", "8", "1"},
     {"1", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", 
      "8", "8", "8", "8", "8", "8", "4", "2", "2", "2", "2", "2", "2", "2", 
      "4", "8", "8", "1"},
     {"1", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", 
      "8", "8", "8", "8", "8", "8", "4", "2", "2", "2", "2", "2", "2", "2", 
      "4", "8", "8", "1"},
     {"1", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", 
      "8", "8", "8", "8", "8", "8", "4", "4", "2", "2", "2", "2", "2", "4", 
      "4", "8", "8", "1"},
     {"1", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", 
      "8", "8", "8", "8", "8", "8", "8", "4", "4", "4", "4", "4", "4", "4", 
      "8", "8", "8", "1"},
     {"1", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", 
      "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", 
      "8", "8", "8", "1"},
     {"1", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", 
      "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", "8", 
      "8", "8", "8", "1"},
     {"1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
      "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", 
      "1", "1", "1", "1"}
    },
    GridBoxAlignment->{
     "Columns" -> {{Center}}, "ColumnsIndexed" -> {}, "Rows" -> {{Baseline}}, 
      "RowsIndexed" -> {}},
    GridBoxSpacings->{"Columns" -> {
        Offset[0.27999999999999997`], {
         Offset[0.7]}, 
        Offset[0.27999999999999997`]}, "ColumnsIndexed" -> {}, "Rows" -> {
        Offset[0.2], {
         Offset[0.4]}, 
        Offset[0.2]}, "RowsIndexed" -> {}}], "\[NoBreak]", ")"}],
  Function[BoxForm`e$, 
   MatrixForm[BoxForm`e$]]]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"VisualizeTypeField", "[", 
  SubscriptBox["type", "0"], "]"}]], "Input"],

Cell[BoxData[
 GraphicsBox[{RasterBox[CompressedData["
1:eJztlsEJwkAUBRdswBJiJfZgCULOtmwJlmAkt8HLwvr+GmYgTHinzewll/vj
tp5aa8v2nLfn877zuravuM+x67Em9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9
syb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbPmtg/a1LV/wnPuv97/97v
7T3fqD11L73n+lX/3nNU7fav3e1fu9u/drd/7X7U/rPdy1H/f0bdi///eoSJ
/bMm7lX7G4YY090=
    "], {{0, 0}, {16, 32}}, {0, 1}], {
    {GrayLevel[
      NCache[-1 + GoldenRatio, 0.6180339887498949]], 
     StyleBox[
      LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 30}, {16, 
       30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 28}}, {{0, 27}, {16, 27}}, {{
       0, 26}, {16, 26}}, {{0, 25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 
       23}, {16, 23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 20}, {
       16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 18}}, {{0, 17}, {16, 
       17}}, {{0, 16}, {16, 16}}, {{0, 15}, {16, 15}}, {{0, 14}, {16, 14}}, {{
       0, 13}, {16, 13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
       10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0, 7}, {16, 
       7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 4}, {16, 4}}, {{0, 
       3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 1}, {16, 1}}, {{0, 0}, {16, 0}}}],
      Antialiasing->False]}, 
    {GrayLevel[
      NCache[-1 + GoldenRatio, 0.6180339887498949]], 
     StyleBox[
      LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {2, 32}}, {{3, 
       0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {5, 32}}, {{6, 0}, {6, 
       32}}, {{7, 0}, {7, 32}}, {{8, 0}, {8, 32}}, {{9, 0}, {9, 32}}, {{10, 
       0}, {10, 32}}, {{11, 0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13,
        32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 0}, {16, 32}}}],
      Antialiasing->False]}}},
  Axes->True,
  AxesLabel->{
    FormBox["\"x\"", TraditionalForm], 
    FormBox["\"y\"", TraditionalForm]},
  Frame->False,
  FrameLabel->{None, None},
  FrameTicks->{{None, None}, {None, None}},
  GridLinesStyle->Directive[
    GrayLevel[0.5, 0.4]],
  Method->{
   "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> Automatic, 
    "DefaultPlotStyle" -> Automatic, "DomainPadding" -> Scaled[0.02], 
    "RangePadding" -> Scaled[0.05]},
  PlotLabel->None]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{
   SubscriptBox["f", "0"], "=", 
   RowBox[{"N", "[", 
    RowBox[{"Table", "[", 
     RowBox[{
      RowBox[{"If", "[", 
       RowBox[{
        RowBox[{
         RowBox[{
          RowBox[{
           SubscriptBox["type", "0"], "\[LeftDoubleBracket]", 
           RowBox[{"i", ",", "j"}], "\[RightDoubleBracket]"}], "\[Equal]", 
          SubscriptBox["ct", "fluid"]}], "\[Or]", 
         RowBox[{
          RowBox[{
           SubscriptBox["type", "0"], "\[LeftDoubleBracket]", 
           RowBox[{"i", ",", "j"}], "\[RightDoubleBracket]"}], "\[Equal]", 
          SubscriptBox["ct", "interface"]}]}], ",", 
        RowBox[{"LBMeq", "[", 
         RowBox[{
          FractionBox["3", "2"], ",", 
          RowBox[{"{", 
           RowBox[{
            FractionBox["1", "5"], ",", "0"}], "}"}]}], "]"}], ",", 
        RowBox[{"LBMeq", "[", 
         RowBox[{"0", ",", 
          RowBox[{"{", 
           RowBox[{"0", ",", "0"}], "}"}]}], "]"}]}], "]"}], ",", 
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

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{"save", " ", "to", " ", "disk"}], " ", "*)"}], 
  "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{"Export", "[", 
    RowBox[{
     RowBox[{
      RowBox[{"FileBaseName", "[", 
       RowBox[{"NotebookFileName", "[", "]"}], "]"}], "<>", 
      "\"\<_f0.dat\>\""}], ",", 
     RowBox[{"Flatten", "[", 
      SubscriptBox["f", "0"], "]"}], ",", "\"\<Real32\>\""}], "]"}], 
   ";"}]}]], "Input"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{"initial", " ", "density", " ", "\[Rho]"}], " ", "*)"}], 
  "\[IndentingNewLine]", 
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
1:eJyF2TuK3EAQBuDF0YQTTDDBBLIQQgghJLXer90z+AgGx766j2BjtgN/IDwY
is9s9tPdVaWv339++/Hl7c/vy99///n9euc/Pv7lDd/xAz/xCyc4xRnOcYFL
XOEaN7jFHQ64xwMe8YRnvOAVb3jHBz7x+6fNOdr6xt/f8B0/8BO/cIJTnOEc
F7jEFa5xg1vc4YB7POART3jGC17xhnd84BPH/D3X5vzm333WG77jB37iF05w
ijOc4wKXuMI1bnCLOxxwjwc84gnPeMEr3vCOD3zimL/3uOfanG8X9Y4f+Ilf
OMEpznCOC1ziCte4wS3ucMA9HvCIJzzjBa94wzs+8Ilj/r7b3uOea3O+X9QH
fuIXTnCKM5zjApe4wjVucIs7HHCPBzziCc94wSve8I4PfOKYv32a77b3uOfa
nB8X9YlfOMEpznCOC1ziCte4wS3ucMA9HvCIJzzjBa94wzs+8Ilj/vbl9mm+
297jnmtzfl7UF05wijOc4wKXuMI1bnCLOxxwjwc84gnPeMEr3vCOD3zimL9z
mH25fZrvtve459qcXxc1wSnOcI4LXOIK17jBLe5wwD0e8IgnPOMFr3jDOz7w
iWP+zt3OYfbl9mm+297jnmtzTi5qijOc4wKXuMI1bnCLOxxwjwc84gnPeMEr
3vCOD3zimH/6WeMv2jncucw+3b7Nd9x73XNu7tYM57jAJa5wjRvc4g4H3OMB
j3jCM17wije84wOfOObvXs09i3O3c5h9uX2a77b3uOfanLOLmuMCl7jCNW5w
izsccI8HPOIJz3jBK97wjg984pi/e1T3au5ZnLudw+zL7dN8t73HPdfmnF/U
Ape4wjVucIs7HHCPBzziCc94wSve8I4PfOKYv3tz96ju1dyzOHc7h9mX26f5
bnuPe67NubioJa5wjRvc4g4H3OMBj3jCM17wije84wOfOObvdxL35u5R3au5
Z3Hudg6zL7dP8932Hvdcm3N5UStc4wa3uMMB93jAI57wjBe84g3v+MAnjvn7
XczvJO7N3aO6V3PP4tztHGZfbp/mu+097rk25+qi1rjBLe5wwD0e8IgnPOMF
r3jDOz7wiWP+fgf1u5jfSdybu0d1r+aexbnbOcy+3D7Nd9t73HNtzvVFbXCL
Oxxwjwc84gnPeMEr3vCOD3zi94/fXFqmjw==
     "], {{{
        EdgeForm[], 
        GrayLevel[0.8], 
        GraphicsGroupBox[{
          PolygonBox[CompressedData["
1:eJxNmge4j+Ufxp9HiiRbmZW9I8leZZzsETJTSPaxyqY62TtkFArZJHtWtnBE
kswUZbZQZPz7P/f1/bzX71xX9/V+x/0d7/PcLwflahffuEcy59y8B5wL/7nc
Ac8HvICtXC5nuWTEZOcJSE5OcR+QP6BAQAoX6yXeQ+RSYD8YkA87H7m8xJNT
kxdb/VJSWxBbsdQBRQMeDXiYXCFQOCAV8ULYaQPSBDxNPCU14j4Cpwh2YXoX
o38+dstLLA3x1PCLYBehTn3jAl5kXhrqSgc8HvBYQImA9AHpOOvXAtoFPENc
+eI8xanG/Dycay7uqTrxatSWDMgQkJFnSfpXozY9vIij/LMgE7E4zrgm756X
OcqXCsjMMxN1adk1HXxxa4Ca3G8+/PzECmCn5YyKcy7PcU6lsDMTz4yfm/fJ
wzkXYN8XOA+dY/mAbAHluINaznRQJqBsQBbuoQx2QXjiZCVWlrrCxHW3tQPq
YBfGzwq3HH5h6qYE9A3owy7aKTu16lGUZ13sHOQrECtGvDyx7HBkVwQ5ien8
6gXUD6hEvCI7ZWPHnOSegF8sSU0Dzr8M51IaTn3iT1JXGVvPKuApYtJpQ2fa
auBi+tW9SNfVyPcMaESsPfFG1EX18kvCeSfg3YCqzKpCvrGLabck/usBHZ3p
S72r0/8lZ3qKdN6YWEP21L4d4KuuBv7r2NXxaxCryVlW5lyaBDR1ps8mzIpm
NiFejzOvy/k+R432jaOnNPhGQCfsOHzdy8vOdNYMvzT32zygBfky5Ds702It
OGXhdSHemf6d4HQiVote5amrQ03XgG68g/ZvCadFklxdYspJo/Xhd6dPbXrV
oSbq08rFNC27Ne/SnL1bc9aR5ivA607/bpxFU969PrkenH1fcvWJ6a7bBLzC
/UmP0kE8+Xg40p5+LZH+qsBVjbT4ScA8aicF9ApoG/CqM51WgduWfg3pKV4j
F/sG5Ee6fS9gOHM1Qzp8iXxvuL3xK/EOleEmwFePDvgJ2O3p34F8G+pbczY6
oz7M6o3dh7hi0p902JH9RmC35R2HBoyENwK8Aect7rIZ0D28GdAvoD933IyY
uNLhKGdafBlec2KjiXei/0jskeRbwFXfMc60phppbawznbQgP4D4GHLyW5If
50w/3ajvwtyu2KoZCH8A9iBnmuzH3m9xvq3ItYTXinnj6N+Xd9e5jGfuOO5r
OGfYg7jyQ7i/wQETAia6mG7HExvmTIdt4Q5xMS0OJS/N9qR+InY83KHwe9Av
Hv6qgMnUv82MBc40Nd+ZDvWt6NvoBbc3z170GMxOOht9P9sDdmCrRwJ95mHP
p38CNYPoIX2+7+z32MnYkXZ74/8YfiD9X8B/3s5Su34aMJVzn4K/0Jlmh+OP
4P50L9PgTsWfzh1/QGwacelPOlxErh89RhFbzJyR9F+EvRCu+vaHt8SZ7qQT
aW0p+RlwlhIXbwCxGfCXOdPPKHqNhjcGewDcmQGznGlyJrtOY/eB5AaRG0jd
WGZrxi7Ocyf+cuZO4exXExtPXHf2YcBHzjS1ImAlz/FwpStpbw68IdTNJjaU
ms+caXYC/kQ4Q5L0H09vaXYSNZ9hi7+D3aWvuc70PAz7Y3zVHg74nD0G8Q7D
2GcufX4K+NmZZqX97dg76D+LukH0Ws0ZyZ7sYt/V58SH8D5D2XEBffSuiQGH
uKd1AeudaVb3sTtgrTNdrgFTXUznC+BNhTeNuOqkw73OdLkHLCK+llnT4O4h
ru/lPfpqj+nstZjavdh67iO/wZn+FhNbQmw6PWRvdDGNzsDf70x7XxNXbBPz
prHfJs56Jryl9F9G/QHOYjVnswzOfuo2c096bnExvX6If9CZppZTewBb9/GN
M30lwjnIHW5zppVI64nElNsKZjPnI+ZshX+InuJ/QR9pSvqS5qTNVcyeC+dL
/FXUHmCX5XDmJOF9TEx9/gw4Aj4ntplz2UTsCGen2q+ol+59+PU1mTf7vDPN
7iC3k7pvqb3gTIPnwS44a+AcBWuJ7abmF+xd+N/Bibjy18H71ZlGd+PvIX/M
xb6ZdfgXnenzV7AXvt75h4ATAd8706Xq9sG5iH+M/HE4EVe+NHop4LIzPR6n
50Zi+4lvIvYD/S8RvwLnMvGL5E5wN6qTRn7nzg/AV91JOBFXvrR1NeCaM00c
wD9I/pSL6W8L/m/ONHsNJMLfSv402EbsEDW/Yyfin4FzmrlXmC3eH+wvzlln
+tyGH2n1C3LS6WFq/sBW7Y/ONCmutJgrILc3frrw/IvcWbjCOWqkM2lT+pNm
9W1J09LtX0ni6nue2HXiyb3p8QG+gQfgSG83nenjKNzrxJS74Uybqn/Qm30B
/yjcG/RVXD3Fe8ibTn/Bl33Lmbb+caY/zfzbGVeaEScFtmLi33amt5twIx3/
TZ9/6Blp+xb8G+yvHVOGXg970+clZigm+yL+JXjinKDHbc7wCPd5gti/4CSx
q+gkFXNkXyau2CMBd+D/i7akybvOcqm9afZRbxqUf5XcNeruUHOHOtn6Obmq
sz/Dpab2GpqRfv7nTLfqmybgvjOt3iP+G7lU7Kzd78E5zfM+vVSf1puW06FX
+afZ5x6+4n/QPw38++wSaVr2f+AcsScD9yn9xSz69Hwb6fkm0vGd5EG7sp8P
eCEgozd93OC+VBPpMgP5vN40mwckp4+4GeAno+8DaF01+bCT40tvmcPzMWZm
8qbFB+E+xDM/9uPoWPxM1GTEzuxjOv47Sd9bxLT/dd5B2iwQUJBnCmbkx9as
nAGVAp6AnwJuTmI6d+2Txcd0rKf8Qj6m35TMkV0koCgaLQynEHrO5mMaTkU+
G7ms3nAnyfeShdgj9E0NPzt9pJOc7FnMmzaLoklxcuA/Sm1Bdol0ezcJ7z6a
lAbV62lQHB3f4ixuw3maeBr6F+Pc1CcHOxdm7//QsM60NvFa3jTsyFcJz6re
NC2NvhbQjtwTcDOivZLe9F0CPT5DLAO11bxpNjd+HjjpqVFc34q+h+redFoN
5IVfKuA5NPcs+tP8fHCqY+tZw5sOxS8NryR1paiNepTyMd1mpiZ6B+0f502D
NemrZ35m1cAuzvunJV+AeAniypfxdl+lecrPggZeRAfRtxHHPelu6pCvBaec
N81lJVaYuPyy5LPSuyxzyuIXga++5ekjfkVvWsnBvLredCpOBW+aLEKuKHvG
sVc2eJFus1NTz5sG1etp/PpJ3v8x4sXI1cUuSp8K7FWJ3SpS34DzHBgwKKAV
nMo+pssn8BtyBw1ACWqfJF8FPEWsbcCr3nRfgnrpQLp/J+Bdb/qVTvU9NCIf
8eSXhN/em35fwJfdJKCpN409C7cx3OpwGhGL9Cr7JVCKmHTXIeB1epYiX4NY
TWJNmFWD/lFNRzgdiLfnXp5jP92zNNIFbhz80uSbgTLEpIM3Ajphx+G/DCfi
yi8Lr7M3/b6IX4t8cx/TcVn8LuzTGdSGX458C+bFsW8daroGtPSmzxagPHXl
yVWA182bBuvgy65IvhW2nq0DunvTbDd6tILXzce0LG1Lr8WpqeRjGq5HD8Xa
eNNij4B4bzpV7BXibeCph3TW05tG6lMj/rCAt71ptwq1bUFVYj2pj8evDE+a
/iRgnjedStfSuvTUO6AP83p502I7atrzTMDu601vfeA2YmYv+kQ6bpykbxNi
8eymd5E+3wsYzrMDMxKw28PpQL4Js5tyJt05F8Xe9DG9NsUf4U0rHekzHHsk
8RHwxX3Lmyb7edNZJ3ijwGhveuxE7cgkNc2oe5mY7k86GQR/FLXSz0ByY7zp
Vn2l1f4BA/C7wB/Ojh3hNE/Ca0msK73GgnHetNkPbnM4Y4l3pf8YdmlJP/1Z
WH8+1t/tjOds1eu7gLUBRzlr5SYEDPGm18EBE7n/ePw2nIE0OdSbZltzHlFe
9ZF2X4E3gV7qM4meE5nbndnq9Sp1kwPe9zGN9caXVqXrSOvbA3bwvrPYoycz
elGruikBcwM+9vaNTSYv3gJvGpzP7kN97JvSjAS4k9ljHlzFlwUs5zx78J7x
zOvLfD2netOi7v1T7l7aWRSwmHxf6hQfSS76fhbAmeZjmpb9AfabSfx+xDRn
IbOmE1d+JuclbUg7S3kPcWZ409Yo9hrNuQ6kTrElxIez16f0nu5jGu5PL/Uf
w4z5vEsCnBn0XApnCRhD/4Wcwwj6LOOcpdl1vO9g7vxD7mE8nBXYy7mTld70
pp979bOx/rw3izrVf8TdD4b7GfwJ9FmBvYL8YGpVNztgjjfdrPKmKdVLL597
098wONLglwFfedOi/LfJD6PHHOonscMk+qqftP5TwM/YO31Mt7Opn0duPra+
le3sMpleurPdnPFs6vUuU9h3NZxd8HTm0t+agD3etLkQfyp1H3Av6/FXJ8mv
9TF9ToO3m17qs5eee5i7gNnqNZ26/d608jWQvYT8Bm962oC/nvoFnNFi+u/F
X8D5LCa2D3xNT+lyY8Amzm015zKTORup3Qd/A7EZzBnJe6l+FnXLeIcD4KA3
fS7DX84dSFdbqNuMv4172kpsC3FpUZpMJDebHiuJHWLOCvonYh+Eq75z4H3j
TXfSx2HeW/kv4BwmJ95cYspJi+c515X0+gzeKuy5cKV9aVN6/Ildt7D7EWYe
hhd9H/p3yXPevpnNnEt0L0e4myuc7eWAC9z9ebCL3fT7nHS4BqjuW2+/Dx7z
psk1xMSVPn/xpsm18NYR+5X4bvpfwL5Afj1c9b3oTWOqkV4uedPZevLfE79I
Tv4G8kfYZzX1e5m7D1s1x+F/j/2DNy3u4G52cl4byW2At5F5l9nnMmco+wRn
vYm+fwf8E3CSuPJXA65509Jpb1rRPR6gj+5EWvgt4HfiV6g7wPMgPRKx1f+U
j2niFL03k9tCz0T6SidnvWlE+IrYIWZ+w/MPbH1rS9lP+57xpsu/OOs/iW1j
7hn6i6N/F9f/uHmO2Ynsrt6H6f8l3LP0Okx+K7ufIvYn844wW3d8w5vGjvK8
6U0ftwJuc3fKXYd7lLrrcL8jfpP7OsadHecOT9DjNj2PJ8nfIvc9darX76P6
2awbtar7N+C+t/9PQO94J+Au73USX/Ym+p0gdpLav9j3W/yTcE5Td5d7PMuM
M8w7y1P+Pfh3se8RP80dnaPH/wGiUXyS
           "]]}]}, {}, {}, {}, {}}}, VertexColors -> CompressedData["
1:eJzt0yEKAlEUQFHRJQgWLVotVkH4SWwGQbAJglEEs6jdOOAWBINpyizAMNli
tVlkklWcTQijnBf+gxM/9zVny9G8XMonfyr5SvadfhI/wm1wPK8Pz5BOFu/p
Kwucc84555xzzv/DW9m4Xd1cwmp3qncb214tTu/R8Fo4L9q/8d/yovXsLrj+
9c/1r3+uf/1z/euf61//XP/65+5C55xzzjnn3/APjkr+kg==
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
       "M10DefaultDensityGradient"}, PlotRange -> {{0., 15.}, {0., 31.}}, 
     PlotRangeClipping -> True, PlotRangePadding -> {
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
1:eJw1Vwk01d3bRZEhpZQikaI5QxMK21hpMEXelCFTRZOhvDIkSkpJpogyVOak
SVESyhTuhGse7sB173V/EUVv5e9r9Z21zlpnnXXWc56z936Go+J61sZjlpCQ
UP3MFJ6Z/7cujdY0K33JQfvunKLgpBHU/3P6t/MEgUYtgWGwOwerd1yXOec9
gjkkcedNowT66QV6WMSB/0ZvXzfDEZiaPar4wScwFnJSR+TjEKqUDrQcWjyC
8LdYUcchIKa6ZusnvyHILNDYvpfLR4VWV1gii4B8A0sjatUQHGctSNav4ONX
zoUB134CG89lbdhHG0TBxNiUZgIfO5UWGmt2EzCUc1kzL2IQU0MtR1RP8vFv
wpOsX3QCB98tX0XZPIjdnSXlSwz4KJE0n/WZRsDTtUspgcFGYmOyspQsH+Nh
LLdkEoGL4ikK9nFsMN5fvPx7iAet75c+enwmcLPokJyCMRuaz44yR9/xcPb0
MrUttQQybBct7BllIfShgRn7Dg+FzJKrQtUEXv2gSGdkstCUuCKn3ZMH7mGb
wab3BGoybku4WbOgECUi0biTh7XkkV2pZQS6dx0QXS3MwsmLLK8KGR48dl3P
OVFCQMCXFB4uZuL1qZrG52wuHr5TFd/+nIBIfN3PAhcmRJ1z1bPLuBjY/OHE
rCICi3UjJ8/IMGFjfSM25TYXSnlH6sl5BNb2mYxrfWAgw+TU2E13Lo4qf1/3
4DEBvavCX8bPMiDYZmEbpstFSmLcDe9MApYbKnivlRnQW6tZ4jePC7qUOk/n
PgFXSvDQRdIAbigsXHqcOYzF4fX7xFIIXAjYwdS/NID2ueOBDm+GYTPpXkhL
IBC1fLJXSGMAq6dbuw7cGkbsGSHpzFgCadWvOqt7++E/+lrfyHUYzazU02du
Enh60q8tMqYflcyU9K3aw5A6ot28M4pA1XwtqrlBP+a3BQmvnTsMcwpVXeIK
gQLvnlT57j441jm6LRvgIHL3mdttlwhQX/8Tn76zDwVl+DSvhIOP5RJfHgYR
mJzVckMttRdThSprRKI5ENn62MongICSlWV4wY8e7E6fdX3CmQPkGz4z8CNg
mtYQqOXQg4Q7bC5nKwchK7oXzD1LwJtj5vO6tBuMiNr93RIclCUF+HZ4EYjb
WnlCX74bmhfyiki9Q5icK0vL9iTwJkzPpfrfLoSeiJapfjGE7RFFW/xdCTAa
X9ubt3eiyeG0b0nUEPymzBOMnAiIym+xJGl3QuGAZUue4xCenWWPz3MgoOlR
tMvubgdOQmv7/c1DINhhdt12BGyerTPo+taOEi3Z5Ng5Q9h4VLEkz5pA8K9H
244dasds1YmpiO5BeFFfywUcIJBuvmLT0Cs6rOXoRwKeDSJnz8EAU3MC9Ymp
qqcX05EhXlruFTkI9nsBfYEZgS8Dcopf/dsg+HFP2enIIFZtu6HTZ0hATj1O
NrClFXojwZetNQfhUqCWUqhHQP+itNT0llbc6HNimooO4oFK5VSgDgG3miiR
q/EtaKcYmul0stF996jD7q0Ebiyc/UPyKw1qH1fmbHjKhvy8ybJFmgSKnS6N
xtrQ4FcyW0L5Chv2V+KXMTYQoOf/4Mg9p6Iyd9Br4WE2En6oBz9dQ+DXt/P9
aQuomJ9a1yiqzgb1XEN38CoCj1IuKkOECod4uyKT7yycij5yL3EugX16l5wG
xijIjmbcvvyBBbFsvn3RhABjvRH3I5gUjEWc9am4zkLGh5DFtb0CpFyO6lZr
oUA/+KfNLxsWdnTNo/XVCmCoemtZ3UcKovyvb92pyELLRHrsZLEAQzV3HLxe
UdBySk4ukM3EGRktiwX3BIg5mZQyN5sCZY+H30uKmBDfUCW1PkKAbXNT24uS
KPBy1OwYD2Aiy+xgvfEpAXqK0pdYX6PgjV152WYjJvRdWJFH7ASIsH506GsA
BSIWe9POSTLRdvG8qb+BABvGcxMTT1BgsYseUkRjwCdRTOTWGgEoSU9atA9T
kGzg7sxPY0Cy+G7FYxkBAnWfy3aaU8DePmq43pOBxw1rQ95PjUC5u8QmeAcF
GhqhK09oMGDALt1BZ4ygNvTtHaUNFASvkZqdPTmAjum9k8TnEZxW+UD+sIyC
GuVkNrNyAL4K3a/EX41g8ceP893mUiC7VK1WJXoA0ttO+6k8GMFbz3oL0V9k
OMo8z3W2HUC25W/NHddG4CbRfCtnhIx8cdy4v3wARl63BTbnRiBZSG007yVj
XKjRu2uwH51XVhR6Hx7BMwu6FL+ZDKOpfw7IF/fjfPqzk1eMR/DPaNfemAoy
bo6y1e0DZ/JHmfGa+xtGMB3ff12zmIz2YV+ZRON+5LXQWK8WjSB7O7uOmkHG
Ksb0KFWqHyaEe1bzLz4OdAzPOX+HjJ6X8jkq+X3okfjmPDQ4UzeCBLuWhJPh
/3iL1329PgSoXlsuROYjVenr1VJfMqSSDmySJ/ViAZZ2LS3lw7jy+8cjbmRk
RR7/knCsFwWH85K1svgYdvs56/dBMnQCLr+QGe+Bmf+OQ3uj+YgVEzbJMCWD
fDz1ws3IHvTFfJZ18+dDO0803HgbGZ7/vNIVl+9BYN5RSpAjH737JCtZamT8
2kP6GVHQDdmPIzEJu/i4KpgndE2OjATd4Ypp/W486Q3d/0SDj013ZLFuDhnq
62dFBJG7sGdqvmTNUj6yj2v+TCJIqFJYvuu7axcGZDNre4X5mCjUvdhFJuGo
lLaE30QngtU3X/3O5cFkzHhS+TkJX/6zahRc68Ri82pjmRYe7mjvv+AeT8J1
vtdtL4VOFLvZCq0r56Ev2G48158EpZ4rNoOFHTAPZZcbZfOgXuXkO2JHwuum
B4td0QFW8oUgh9s8BM058UVLm4R979+091DaEfJijq7fvzw07Pc5c2EpCewi
auph93YsbU7+Fn2MhyVxF/llU80ITOc7tX6j4xln3ctHe3nwpEd4TXc2QzZW
bKX1dTr2z3rrU76FhxeKtzgm75qRE7aC3biMDvby/RptijyIuCZ5Rt1vhqHP
jtw9RW0I0+nhC0R5sMpJZzWGNoN+zNb7o2EbFA6eyZ9DcPGAn+u6wKUZZ2zO
qBvSWvHy9PTxFe1c8LWe99sZNUPUJGr0rUcrLKJi1XQrudgR8Nbp3spmpG3J
eqk92QJOlgrTOp+LEJ/YJ2VWzaCofoqqzmjBlHNirtcVLj54e/zsnLl3jhzn
qKV5CySXS5yJcOJCxHPHvv8Km6E3R0qra5SGZZ3BW9J0uNjlMv/esq5m+E5u
Ej1+j4aNd79MvlzIRZQDi7NTgoScYauOMWMa9G3d3zfxh/HZtlT76AzOPZ1+
T0J5VFgsaI8YrBnGPMuYyGAPEhY2Jl2WTKDCpXmf+XTGMKzN3VrTZvjdXV5q
l6RHxbnoinlLg4aRYKKjWl5JQkhR97qVbArC92xp0bQbRpu+tF/PjK6ep0//
enKLgnjRnBRzjWFIK472/55HBid2JVV3OwWPqhScXSWGoZ5yRHz+ajKWh5tl
f5qJ+1eXYlSDmBxYydVoKOuTYeN34qL1NTJq9ES48eUc+MRr2mvYkhHlHm3R
o0EGfer808K7HMTJpIbCm4yLBUfNqMUkcEqG/T/5cPDilmi25Uz8cm9ljQwL
k/DDz3FH7z4OWiXPNTmnkGF7jpMofLAZUlqU6W9qHHy71jl+diZvvLdRN5B/
1ARFgemn+UIcLBU1UwyrJWP9Nv9BzYlGbCp4c2Nt5xB0w5+axM74nbCkLGbP
rkYYnNhoZfRyCA7T8t4ZE2QI/Zje7nL3MyzVMhY7xAwhOPhKXPFMnvTqNusL
4DTAhSHb5XtiCPenBKUfVs3UkffR127rNsAn/VpGtPEQKi4cHiDP5GfDTIpG
zo16hB/9z+OR4hD6v1aLD1hTkB+xpP19Vx0S5M9uKP82CGEfdc3Rmbog5+kY
1raxDo/bGF9ayTP1XJBsLxxGQdieh2sFIbUoiT9UIsgfhKn3rEsL7lLAWz9M
FiXVoNaqIWjO1UF4ck5nqxRRcEhaI3D5ihq0SxsYrXAexDWP9iatTxR8IPxV
tvl8wnDDMzFd3UHkMYwnjLop2EAtq99f9RE/rqk1WssOosH5iaLNVwqSXgr5
ust+hJRZyh2vETZ43UtMXSWpEL67SyHYvRqKItL2EbVsSDuEe/uqUHEq8GZV
/KsqbKoIU0zLZEOdzo8L16Gi7QjVq0CsCgbB4wMvg9iwsrUvi7OkwshgqWy1
fSUsdU/kNNmx4UOpHMjypKJwhdPbztwPcPnWdWpQg404i40SL0KoUBfbU8v6
WgGfF5abpyXYePk5SbN6Rvczn4cli5LeI/xc9fclLBZa9wj/Qyugov228wkT
nXLEb9Iu13zPwrdP3peYVVS8tuW98e18i8fc/HDzZBaWmrRlf+2g4qZ8gERW
cBlKcpT2uPqyoPvBsHnWKBWuvSIOFKVS1LnHSQftZ8FBv2BCVpwGnYcx+UKV
r9GhIkaLX81CcNni5arKNEifUPhPw60E3N7A5EIhFu5rh5lu3U4Dc2P2PmfR
V/gvdcTxUycTFS+53qYHaHgzqpUWk/MCcw8fW9X7kol+Lbt4W3caYkrK+eXm
z7FcrpXzLYYJkacVZe5BNLgFmeuP8IqhTttTNP8kE6s2rmf4x9HgG5a/TFfx
KRD7zm+tCROpSVa5ph40cG21zL8EF4ExMs2bWMCErHDAmUU6M3bWvbmQ0/ME
V/aZuFf3M3DD+/5WliQNXb8MHjkZPMGavMju2KcMiLRV/3jRQ4Ut9RNlcXoh
GsQabJ1CGbhoyP0QUUxFY/b+6cbpApxyl27acICBsXyZawcjqDALom284lIA
mSors6llDHgt1j6w6hAV5ZYODjsr8/FcOaG8hjsAxiVH2a9rqdiuOnBtTCUf
diH0bQmlA3DgRnRU/UdB0eTxV3nheZjsVCg6FjUAqm1+elwzBaubBAwXZi7u
6Tit1rAfwN4KsodrJgXpmedllprmQj8p88FPtQFUrfu+YbM/BUsu/NQnPcqZ
iUOWXMN4P3YkLB8T3k1B7N4I70jRHIRbr719t7ofz3+bvKHIUyCuLJmi75kN
tafeczzi+rH+pFdoJp+My19ja8ZrHqNu7tNLm4/1I5MWa+oz089M1S4ZL1jz
GN5eY9+nNfqhYPBa0iiOjPNpD1Tcoh5BKda7/96vPsTl9pBlPMgQnFOzVBh+
CLd9Y+RtqX2QlJ19t197pn8wKwymmD9ErlhgJVmnD+Eh6x2LJcnok9+SH5Wf
BUHl9DPvtl6MkzJ3Cb0lwV5QSodUFraERGaJ+feC9UhATXchgVxlKPrdOxP/
6kjHZy7oRUvgTmeIkbDnbu3mosYMvP8aH6H3tAfVFlG83oJmVHpbuHhsysDs
pwr+9P09eLGqNSDUuvmvrtJh7pXp7svtxsNJldlK35v+6uc+YtTW2klHdSOu
6UxseVrTX52koaW/yCxXrRvhWW8VHY2b/uohFQpp27abVHfBN0A87+dQ41/e
78HZ/t3qXpcuuO6325Z2q/Evv8l4tNBkSeDvTtioZFXu3NL4l8e74DbVz1mU
1gnjb4IDXe2f//KVBI3rVpNFup3Q+ryz82Lo57+8JOK8KZ1jTu+ASkaUp4Lq
Z3D/4B+PsmnHDpZ/Bxacbx0rrW9A1x+c4yD0llV/aWEHhPeuvHT4bAMa/+B5
B2YXvMsUitvxRems1NSiBpT/wS0WN7TG8l8daJ/R19u7yWX1OPIHn1sg8/9N
teLRQa4TV9VxqYf+HxyiIZc7Hc2LouPDfbtiumg9lP+8NwpH3CKDI1fTUeyb
pRdQUAehP++KRIaS9GmVj23I2k3UyVnXYeyP/xHgdMQ7vjvWhjhFPbuSb7Vo
+ePnZagnKljYT7fi8mjUgF1aLbz/+BMCP6tMg7G0VvjUtJ6eMKqF+p97/0Wp
1FqNWztacSx15Y+EoZq/9v3wu6ZIeW17C6zPnY3ceqvmr53TMA3fJlN9vgWG
Zu8Wtmz+//NuuK7/TshJtgWaChLpfu2f/u4fBGnSeHSymIYVhN0G2dBPEPo7
Fr2sH4i3oOF/y3WQWw==
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
               LineBox[{{7.5, -112.5}, {7.5, 112.5}}], 
               Directive[
                AbsoluteThickness[0.2], 
                Opacity[0.3], 
                GrayLevel[0]], StripOnInput -> False], 
              StyleBox[
               StyleBox[{{
                  StyleBox[
                   LineBox[{{{7.5, -112.5}, 
                    Offset[{4., 0}, {7.5, -112.5}]}, {{7.5, -75.}, 
                    Offset[{4., 0}, {7.5, -75.}]}, {{7.5, -37.5}, 
                    Offset[{4., 0}, {7.5, -37.5}]}, {{7.5, 0.}, 
                    Offset[{4., 0}, {7.5, 0.}]}, {{7.5, 37.5}, 
                    Offset[{4., 0}, {7.5, 37.5}]}, {{7.5, 75.}, 
                    Offset[{4., 0}, {7.5, 75.}]}, {{7.5, 112.5}, 
                    Offset[{4., 0}, {7.5, 112.5}]}}], 
                   Directive[
                    AbsoluteThickness[0.2], 
                    GrayLevel[0.4]], StripOnInput -> False], 
                  StyleBox[
                   LineBox[{{{7.5, -105.}, 
                    Offset[{2.5, 0.}, {7.5, -105.}]}, {{7.5, -97.5}, 
                    Offset[{2.5, 0.}, {7.5, -97.5}]}, {{7.5, -90.}, 
                    Offset[{2.5, 0.}, {7.5, -90.}]}, {{7.5, -82.5}, 
                    Offset[{2.5, 0.}, {7.5, -82.5}]}, {{7.5, -67.5}, 
                    Offset[{2.5, 0.}, {7.5, -67.5}]}, {{7.5, -60.}, 
                    Offset[{2.5, 0.}, {7.5, -60.}]}, {{7.5, -52.5}, 
                    Offset[{2.5, 0.}, {7.5, -52.5}]}, {{7.5, -45.}, 
                    Offset[{2.5, 0.}, {7.5, -45.}]}, {{
                    7.5, -29.99999999999999}, 
                    Offset[{2.5, 0.}, {7.5, -29.99999999999999}]}, {{
                    7.5, -22.5}, 
                    Offset[{2.5, 0.}, {7.5, -22.5}]}, {{7.5, -15.}, 
                    Offset[{2.5, 0.}, {7.5, -15.}]}, {{7.5, -7.5}, 
                    Offset[{2.5, 0.}, {7.5, -7.5}]}, {{7.5, 7.5}, 
                    Offset[{2.5, 0.}, {7.5, 7.5}]}, {{7.5, 15.}, 
                    Offset[{2.5, 0.}, {7.5, 15.}]}, {{7.5, 22.5}, 
                    Offset[{2.5, 0.}, {7.5, 22.5}]}, {{7.5, 30.}, 
                    Offset[{2.5, 0.}, {7.5, 30.}]}, {{7.5, 45.}, 
                    Offset[{2.5, 0.}, {7.5, 45.}]}, {{7.5, 
                    52.500000000000014`}, 
                    Offset[{2.5, 0.}, {7.5, 52.500000000000014`}]}, {{7.5, 
                    60.}, 
                    Offset[{2.5, 0.}, {7.5, 60.}]}, {{7.5, 67.5}, 
                    Offset[{2.5, 0.}, {7.5, 67.5}]}, {{7.5, 82.5}, 
                    Offset[{2.5, 0.}, {7.5, 82.5}]}, {{7.5, 90.}, 
                    Offset[{2.5, 0.}, {7.5, 90.}]}, {{7.5, 97.5}, 
                    Offset[{2.5, 0.}, {7.5, 97.5}]}, {{7.5, 105.}, 
                    Offset[{2.5, 0.}, {7.5, 105.}]}}], 
                   Directive[
                    AbsoluteThickness[0.2], 
                    GrayLevel[0.4], 
                    Opacity[0.3]], StripOnInput -> False]}, 
                 StyleBox[
                  StyleBox[{{
                    StyleBox[{
                    InsetBox[
                    FormBox["0", TraditionalForm], 
                    Offset[{7., 0.}, {7.5, -112.5}], {-1, 0.}, Automatic, {1, 
                    0}], 
                    InsetBox[
                    FormBox[
                    TagBox[
                    InterpretationBox["\"0.25\"", 0.25, AutoDelete -> True], 
                    NumberForm[#, {
                    DirectedInfinity[1], 2}]& ], TraditionalForm], 
                    Offset[{7., 0.}, {7.5, -75.}], {-1, 0.}, Automatic, {1, 
                    0}], 
                    InsetBox[
                    FormBox[
                    TagBox[
                    InterpretationBox["\"0.50\"", 0.5, AutoDelete -> True], 
                    NumberForm[#, {
                    DirectedInfinity[1], 2}]& ], TraditionalForm], 
                    Offset[{7., 0.}, {7.5, -37.5}], {-1, 0.}, Automatic, {1, 
                    0}], 
                    InsetBox[
                    FormBox[
                    TagBox[
                    InterpretationBox["\"0.75\"", 0.75, AutoDelete -> True], 
                    NumberForm[#, {
                    DirectedInfinity[1], 2}]& ], TraditionalForm], 
                    Offset[{7., 0.}, {7.5, 0.}], {-1, 0.}, Automatic, {1, 0}], 
                    InsetBox[
                    FormBox[
                    TagBox[
                    InterpretationBox["\"1.00\"", 1., AutoDelete -> True], 
                    NumberForm[#, {
                    DirectedInfinity[1], 2}]& ], TraditionalForm], 
                    Offset[{7., 0.}, {7.5, 37.5}], {-1, 0.}, Automatic, {1, 
                    0}], 
                    InsetBox[
                    FormBox[
                    TagBox[
                    InterpretationBox["\"1.25\"", 1.25, AutoDelete -> True], 
                    NumberForm[#, {
                    DirectedInfinity[1], 2}]& ], TraditionalForm], 
                    Offset[{7., 0.}, {7.5, 75.}], {-1, 0.}, Automatic, {1, 
                    0}], 
                    InsetBox[
                    FormBox[
                    TagBox[
                    InterpretationBox["\"1.50\"", 1.5, AutoDelete -> True], 
                    NumberForm[#, {
                    DirectedInfinity[1], 2}]& ], TraditionalForm], 
                    Offset[{7., 0.}, {7.5, 112.5}], {-1, 0.}, Automatic, {1, 
                    0}]}, 
                    Directive[
                    AbsoluteThickness[0.2], 
                    GrayLevel[0.4]], {
                    Directive[
                    Opacity[1]], 
                    Directive[
                    Opacity[1]]}, StripOnInput -> False], 
                    
                    StyleBox[{{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, \
{}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}}, 
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
                 RowBox[{"0.`", ",", "1.5000000000000002`"}], "}"}]}], "}"}], 
           ",", 
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
   RowBox[{"initial", " ", "velocity", " ", "u"}], " ", "*)"}], 
  "\[IndentingNewLine]", 
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
    {Arrowheads[{{0.00003159061756007269, 1.}}], 
     ArrowBox[{{2.1423055743961097`, 19.928571428571434`}, {
      2.1434087113181763`, 19.928571428571434`}}]}, 
    {Arrowheads[{{0.0014817889672623116`, 1.}}], 
     ArrowBox[{{2.168729003661853, 22.14285714285715}, {2.1169852820524326`, 
      22.14285714285715}}]}, 
    {Arrowheads[{{0.0014817889672623116`, 1.}}], 
     ArrowBox[{{2.168729003661853, 24.357142857142865`}, {2.1169852820524326`,
       24.357142857142865`}}]}, 
    {Arrowheads[{{0.0015768308252208235`, 1.}}], 
     ArrowBox[{{2.1703884233053037`, 26.57142857142858}, {2.115325862408982, 
      26.57142857142858}}]}, 
    {Arrowheads[{{0.00005049098704046263, 1.}}], 
     ArrowBox[{{2.1419755761715598`, 28.785714285714295`}, {
      2.1437387095427263`, 28.785714285714295`}}]}, 
    {Arrowheads[{{0.0023453565521358456`, 1.}}], 
     ArrowBox[{{3.2552353633888393`, 19.928571428571434`}, {
      3.1733360651825895`, 19.928571428571434`}}]}, 
    {Arrowheads[{{0.01259520622172961, 1.}}], 
     ArrowBox[{{2.9943748974456788`, 22.14285714285715}, {3.43419653112575, 
      22.14285714285715}}]}, 
    {Arrowheads[{{0.01259520622172961, 1.}}], 
     ArrowBox[{{2.9943748974456788`, 24.357142857142865`}, {3.43419653112575, 
      24.357142857142865`}}]}, 
    {Arrowheads[{{0.013541912228738268`, 1.}}], 
     ArrowBox[{{2.977845522090993, 26.57142857142858}, {3.450725906480436, 
      26.57142857142858}}]}, 
    {Arrowheads[{{0.0009321109560672256, 1.}}], 
     ArrowBox[{{3.2305602617703477`, 28.785714285714295`}, {
      3.1980111668010807`, 28.785714285714295`}}]}, 
    {Arrowheads[{{0.01509241753932583, 1.}}], 
     ArrowBox[{{4.022202453455596, 19.928571428571434`}, {4.549226117972976, 
      19.928571428571434`}}]}, 
    {Arrowheads[{{0.06723617438952716, 1.}}], 
     ArrowBox[{{3.1117786017005664`, 22.14285714285715}, {5.459649969728005, 
      22.14285714285715}}]}, 
    {Arrowheads[{{0.06723617438952716, 1.}}], 
     ArrowBox[{{3.1117786017005664`, 24.357142857142865`}, {5.459649969728005,
       24.357142857142865`}}]}, 
    {Arrowheads[{{0.07044383709562703, 1.}}], 
     ArrowBox[{{3.0557731887341024`, 26.57142857142858}, {5.515655382694469, 
      26.57142857142858}}]}, 
    {Arrowheads[{{0.0017109559472118932`, 1.}}], 
     ArrowBox[{{4.2558411964369105`, 28.785714285714295`}, {4.315587374991662,
       28.785714285714295`}}]}, 
    {Arrowheads[{{0.0634272964147387, 1.}}], 
     ArrowBox[{{4.249709733860114, 19.928571428571434`}, {6.464575980425599, 
      19.928571428571434`}}]}, 
    {Arrowheads[{{0.06353170197137138, 1.}}], 
     ArrowBox[{{4.247886825140913, 22.14285714285715}, {6.466398889144801, 
      22.14285714285715}}]}, 
    {Arrowheads[{{0.06353170197137138, 1.}}], 
     ArrowBox[{{4.247886825140913, 24.357142857142865`}, {6.466398889144801, 
      24.357142857142865`}}]}, 
    {Arrowheads[{{0.06327553446359255, 1.}}], 
     ArrowBox[{{4.252359479648652, 26.57142857142858}, {6.461926234637062, 
      26.57142857142858}}]}, 
    {Arrowheads[{{0.013523085688825492`, 1.}}], 
     ArrowBox[{{5.121031374117132, 28.785714285714295`}, {5.593254340168581, 
      28.785714285714295`}}]}, 
    {Arrowheads[{{2.289135083645133*^-16, 1.}}], 
     ArrowBox[{{5.357142857142861, 31.00000000000001}, {5.357142857142853, 
      31.00000000000001}}]}, 
    {Arrowheads[{{0.05959570002708118, 1.}}], 
     ArrowBox[{{5.388037526831989, 19.928571428571434`}, {7.469105330310866, 
      19.928571428571434`}}]}, 
    {Arrowheads[{{0.06353170197137138, 1.}}], 
     ArrowBox[{{5.319315396569484, 22.14285714285715}, {7.537827460573372, 
      22.14285714285715}}]}, 
    {Arrowheads[{{0.06353170197137138, 1.}}], 
     ArrowBox[{{5.319315396569484, 24.357142857142865`}, {7.537827460573372, 
      24.357142857142865`}}]}, 
    {Arrowheads[{{0.06353170197137138, 1.}}], 
     ArrowBox[{{5.319315396569484, 26.57142857142858}, {7.537827460573372, 
      26.57142857142858}}]}, 
    {Arrowheads[{{0.012595206221729, 1.}}], 
     ArrowBox[{{6.208660611731403, 28.785714285714295`}, {6.648482245411453, 
      28.785714285714295`}}]}, 
    {Arrowheads[{{2.289135083645133*^-16, 1.}}], 
     ArrowBox[{{6.4285714285714315`, 31.00000000000001}, {6.4285714285714235`,
       31.00000000000001}}]}, 
    {Arrowheads[{{0.05959570002708118, 1.}}], 
     ArrowBox[{{6.4594660982605605`, 19.928571428571434`}, {8.540533901739437,
       19.928571428571434`}}]}, 
    {Arrowheads[{{0.06353170197137135, 1.}}], 
     ArrowBox[{{6.3907439679980556`, 22.14285714285715}, {8.609256032001943, 
      22.14285714285715}}]}, 
    {Arrowheads[{{0.06353170197137135, 1.}}], 
     ArrowBox[{{6.3907439679980556`, 24.357142857142865`}, {8.609256032001943,
       24.357142857142865`}}]}, 
    {Arrowheads[{{0.06353170197137135, 1.}}], 
     ArrowBox[{{6.3907439679980556`, 26.57142857142858}, {8.609256032001943, 
      26.57142857142858}}]}, 
    {Arrowheads[{{0.012595206221729, 1.}}], 
     ArrowBox[{{7.2800891831599746`, 28.785714285714295`}, {7.719910816840025,
       28.785714285714295`}}]}, 
    {Arrowheads[{{2.289135083645133*^-16, 1.}}], 
     ArrowBox[{{7.500000000000003, 31.00000000000001}, {7.499999999999995, 
      31.00000000000001}}]}, 
    {Arrowheads[{{0.05959570002708121, 1.}}], 
     ArrowBox[{{7.530894669689133, 19.928571428571434`}, {9.61196247316801, 
      19.928571428571434`}}]}, 
    {Arrowheads[{{0.06353170197137133, 1.}}], 
     ArrowBox[{{7.462172539426628, 22.14285714285715}, {9.680684603430514, 
      22.14285714285715}}]}, 
    {Arrowheads[{{0.06353170197137133, 1.}}], 
     ArrowBox[{{7.462172539426628, 24.357142857142865`}, {9.680684603430514, 
      24.357142857142865`}}]}, 
    {Arrowheads[{{0.06353170197137133, 1.}}], 
     ArrowBox[{{7.462172539426628, 26.57142857142858}, {9.680684603430514, 
      26.57142857142858}}]}, 
    {Arrowheads[{{0.012595206221728975`, 1.}}], 
     ArrowBox[{{8.351517754588546, 28.785714285714295`}, {8.791339388268595, 
      28.785714285714295`}}]}, 
    {Arrowheads[{{2.034786741017896*^-16, 1.}}], 
     ArrowBox[{{8.571428571428575, 31.00000000000001}, {8.571428571428568, 
      31.00000000000001}}]}, 
    {Arrowheads[{{0.05959570002708121, 1.}}], 
     ArrowBox[{{8.602323241117704, 19.928571428571434`}, {10.683391044596581`,
       19.928571428571434`}}]}, 
    {Arrowheads[{{0.06353170197137135, 1.}}], 
     ArrowBox[{{8.533601110855198, 22.14285714285715}, {10.752113174859085`, 
      22.14285714285715}}]}, 
    {Arrowheads[{{0.06353170197137135, 1.}}], 
     ArrowBox[{{8.533601110855198, 24.357142857142865`}, {10.752113174859085`,
       24.357142857142865`}}]}, 
    {Arrowheads[{{0.06353170197137135, 1.}}], 
     ArrowBox[{{8.533601110855198, 26.57142857142858}, {10.752113174859085`, 
      26.57142857142858}}]}, 
    {Arrowheads[{{0.012595206221728975`, 1.}}], 
     ArrowBox[{{9.422946326017117, 28.785714285714295`}, {9.862767959697166, 
      28.785714285714295`}}]}, 
    {Arrowheads[{{2.034786741017896*^-16, 1.}}], 
     ArrowBox[{{9.642857142857146, 31.00000000000001}, {9.642857142857139, 
      31.00000000000001}}]}, 
    {Arrowheads[{{0.06314964450258963, 1.}}], 
     ArrowBox[{{9.611700360680022, 19.928571428571434`}, {11.816871067891405`,
       19.928571428571434`}}]}, 
    {Arrowheads[{{0.06353170197137135, 1.}}], 
     ArrowBox[{{9.605029682283769, 22.14285714285715}, {11.823541746287656`, 
      22.14285714285715}}]}, 
    {Arrowheads[{{0.06353170197137135, 1.}}], 
     ArrowBox[{{9.605029682283769, 24.357142857142865`}, {11.823541746287656`,
       24.357142857142865`}}]}, 
    {Arrowheads[{{0.06329409732647508, 1.}}], 
     ArrowBox[{{9.609178231392397, 26.57142857142858}, {11.81939319717903, 
      26.57142857142858}}]}, 
    {Arrowheads[{{0.013455848046282253`, 1.}}], 
     ArrowBox[{{10.479348192577794`, 28.785714285714295`}, {
      10.949223235993633`, 28.785714285714295`}}]}, 
    {Arrowheads[{{2.54348342627237*^-16, 1.}}], 
     ArrowBox[{{10.714285714285717`, 31.00000000000001}, {10.714285714285708`,
       31.00000000000001}}]}, 
    {Arrowheads[{{0.010661093021426333`, 1.}}], 
     ArrowBox[{{11.599572857501327`, 19.928571428571434`}, {11.97185571392724,
       19.928571428571434`}}]}, 
    {Arrowheads[{{0.06671523295572403, 1.}}], 
     ArrowBox[{{10.62087417776472, 22.14285714285715}, {12.950554393663849`, 
      22.14285714285715}}]}, 
    {Arrowheads[{{0.06671523295572403, 1.}}], 
     ArrowBox[{{10.62087417776472, 24.357142857142865`}, {12.950554393663849`,
       24.357142857142865`}}]}, 
    {Arrowheads[{{0.07018648831475571, 1.}}], 
     ArrowBox[{{10.560266468130875`, 26.57142857142858}, {13.011162103297696`,
       26.57142857142858}}]}, 
    {Arrowheads[{{0.0006529044041517117, 1.}}], 
     ArrowBox[{{11.774314651733878`, 28.785714285714295`}, {
      11.797113919694691`, 28.785714285714295`}}]}, 
    {Arrowheads[{{0.001595326186783779, 1.}}], 
     ArrowBox[{{12.88499706442504, 19.928571428571434`}, {12.82928864986067, 
      19.928571428571434`}}]}, 
    {Arrowheads[{{0.008149839319942778, 1.}}], 
     ArrowBox[{{12.714847622716949`, 22.14285714285715}, {12.999438091568763`,
       22.14285714285715}}]}, 
    {Arrowheads[{{0.008149839319942778, 1.}}], 
     ArrowBox[{{12.714847622716949`, 24.357142857142865`}, {
      12.999438091568763`, 24.357142857142865`}}]}, 
    {Arrowheads[{{0.008767611396673104, 1.}}], 
     ArrowBox[{{12.704061395034518`, 26.57142857142858}, {13.010224319251192`,
       26.57142857142858}}]}, 
    {Arrowheads[{{0.0006219571585438245, 1.}}], 
     ArrowBox[{{12.868002155860722`, 28.785714285714295`}, {
      12.846283558424991`, 28.785714285714295`}}]}, 
    {Arrowheads[{{0.00001604211047973763, 1.}}], 
     ArrowBox[{{13.92829133521231, 19.928571428571434`}, {13.928851521930547`,
       19.928571428571434`}}]}, 
    {Arrowheads[{{0.0007524709599378876, 1.}}], 
     ArrowBox[{{13.941709482886319`, 22.14285714285715}, {13.915433374256535`,
       22.14285714285715}}]}, 
    {Arrowheads[{{0.0007524709599378876, 1.}}], 
     ArrowBox[{{13.941709482886319`, 24.357142857142865`}, {
      13.915433374256535`, 24.357142857142865`}}]}, 
    {Arrowheads[{{0.0008007344034324612, 1.}}], 
     ArrowBox[{{13.942552156924009`, 26.57142857142858}, {13.914590700218845`,
       26.57142857142858}}]}, 
    {Arrowheads[{{0.000025639954356508076`, 1.}}], 
     ArrowBox[{{13.928123757988905`, 28.785714285714295`}, {
      13.929019099153951`, 28.785714285714295`}}]}}},
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
  PlotRange->{{-1.2299410969801832`, 
   16.229941096980184`}, {-1.2299410969801832`, 32.229941096980184`}},
  PlotRangeClipping->True,
  PlotRangePadding->{{
     Scaled[0.05], 
     Scaled[0.05]}, {
     Scaled[0.05], 
     Scaled[0.05]}},
  Ticks->{Automatic, Automatic}]], "Output"]
}, Open  ]]
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
  RowBox[{"(*", " ", "gravity", " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{
    SubscriptBox["g", "val"], "=", 
    RowBox[{"{", 
     RowBox[{"0", ",", 
      RowBox[{"-", "0.1"}]}], "}"}]}], ";"}]}]], "Input"],

Cell[BoxData[
 RowBox[{
  RowBox[{
   SubscriptBox["t", "max"], "=", "128"}], ";"}]], "Input"],

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

Cell[BoxData["129"], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"?", "LatticeBoltzmann"}]], "Input"],

Cell[BoxData[
 StyleBox["\<\"LatticeBoltzmann[omega_Real, numsteps_Integer, gravity_List, \
f0_List, type0_List] runs a Lattice Boltzmann Method (LBM) simulation\"\>", 
  "MSG"]], "Print", "PrintUsage",
 CellTags->"Info3627999368-3712179"]
}, Open  ]],

Cell[BoxData[
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
      SubscriptBox["type", "0"], "]"}]}], "]"}]}], ";"}]], "Input"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{"Dimensions", "[", 
  SubscriptBox["type", "evolv"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"Dimensions", "[", 
  SubscriptBox["f", "evolv"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"Dimensions", "[", 
  SubscriptBox["mass", "evolv"], "]"}]}], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"129", ",", "16", ",", "32"}], "}"}]], "Output"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"129", ",", "16", ",", "32", ",", "9"}], "}"}]], "Output"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"129", ",", "16", ",", "32"}], "}"}]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", "examples", " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{
    SubscriptBox["type", "evolv"], "\[LeftDoubleBracket]", 
    RowBox[{"1", ",", 
     RowBox[{"{", 
      RowBox[{"1", ",", "2", ",", "3"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"4", ",", "5", ",", "6"}], "}"}]}], "\[RightDoubleBracket]"}], 
   "\[IndentingNewLine]", 
   RowBox[{
    SubscriptBox["type", "evolv"], "\[LeftDoubleBracket]", 
    RowBox[{
     RowBox[{"-", "1"}], ",", 
     RowBox[{"{", 
      RowBox[{"1", ",", "2", ",", "3"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"4", ",", "5", ",", "6"}], "}"}]}], "\[RightDoubleBracket]"}], 
   "\[IndentingNewLine]", 
   RowBox[{
    SubscriptBox["f", "evolv"], "\[LeftDoubleBracket]", 
    RowBox[{
     RowBox[{"-", "1"}], ",", 
     RowBox[{"{", 
      RowBox[{"1", ",", "2"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"4", ",", "5"}], "}"}]}], 
    "\[RightDoubleBracket]"}]}]}]], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{
   RowBox[{"{", 
    RowBox[{"1", ",", "1", ",", "1"}], "}"}], ",", 
   RowBox[{"{", 
    RowBox[{"8", ",", "8", ",", "8"}], "}"}], ",", 
   RowBox[{"{", 
    RowBox[{"8", ",", "8", ",", "8"}], "}"}]}], "}"}]], "Output"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{
   RowBox[{"{", 
    RowBox[{"1", ",", "1", ",", "1"}], "}"}], ",", 
   RowBox[{"{", 
    RowBox[{"2", ",", "2", ",", "4"}], "}"}], ",", 
   RowBox[{"{", 
    RowBox[{"2", ",", "2", ",", "4"}], "}"}]}], "}"}]], "Output"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{
   RowBox[{"{", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{
      "0.`", ",", "0.`", ",", "0.`", ",", "0.`", ",", "0.`", ",", "0.`", ",", 
       "0.`", ",", "0.`", ",", "0.`"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{
      "0.`", ",", "0.`", ",", "0.`", ",", "0.`", ",", "0.`", ",", "0.`", ",", 
       "0.`", ",", "0.`", ",", "0.`"}], "}"}]}], "}"}], ",", 
   RowBox[{"{", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{
      "0.5808064937591553`", ",", "0.14887645840644836`", ",", 
       "0.14816513657569885`", ",", "0.13250070810317993`", ",", 
       "0.15147799253463745`", ",", "0.033938657492399216`", ",", 
       "0.03829183802008629`", ",", "0.03472590073943138`", ",", 
       "0.037817295640707016`"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{
      "0.5225015878677368`", ",", "0.13361001014709473`", ",", 
       "0.13354940712451935`", ",", "0.12008330225944519`", ",", 
       "0.13796313107013702`", ",", "0.030755823478102684`", ",", 
       "0.035178959369659424`", ",", "0.031410276889801025`", ",", 
       "0.03429170697927475`"}], "}"}]}], "}"}]}], "}"}]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{
   "total", " ", "mass", " ", "not", " ", "exactly", " ", "conserved", " ", 
    "due", " ", "to", " ", "excess", " ", "mass", " ", "of", " ", "converted",
     " ", "interface", " ", "cells", " ", "which", " ", "cannot", " ", "be", 
    " ", "distributed", " ", "to", " ", "surrounding", " ", "cells"}], " ", 
   "*)"}], "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{
    RowBox[{"Table", "[", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{"t", ",", 
        RowBox[{"Total", "[", 
         RowBox[{
          RowBox[{
           RowBox[{
            SubscriptBox["mass", "evolv"], "\[LeftDoubleBracket]", 
            RowBox[{"t", "+", "1"}], "\[RightDoubleBracket]"}], "-", 
           RowBox[{
            SubscriptBox["mass", "evolv"], "\[LeftDoubleBracket]", "1", 
            "\[RightDoubleBracket]"}]}], ",", 
          RowBox[{"{", 
           RowBox[{"1", ",", "2"}], "}"}]}], "]"}]}], "}"}], ",", 
      RowBox[{"{", 
       RowBox[{"t", ",", "0", ",", 
        SubscriptBox["t", "max"]}], "}"}]}], "]"}], ";"}], 
   "\[IndentingNewLine]", 
   RowBox[{"ListLogPlot", "[", 
    RowBox[{
     RowBox[{"Abs", "[", "%", "]"}], ",", 
     RowBox[{"AxesLabel", "\[Rule]", 
      RowBox[{"{", 
       RowBox[{
       "\"\<t\>\"", ",", 
        "\"\<\[LeftBracketingBar]\[CapitalDelta]m\[RightBracketingBar]\>\""}],
        "}"}]}], ",", 
     RowBox[{"PlotStyle", "\[Rule]", 
      RowBox[{"{", 
       RowBox[{"Blue", ",", 
        RowBox[{"PointSize", "[", "Small", "]"}]}], "}"}]}]}], 
    "]"}]}]}]], "Input"],

Cell[BoxData[
 GraphicsBox[{{}, {{}, 
    {RGBColor[0, 0, 1], PointSize[Small], AbsoluteThickness[1.6], 
     PointBox[CompressedData["
1:eJxVkw1QFGUYx1dGUjLHS/QoLcdKOT6OEw8k5VD+coLnwcFxXxz3wamMeImk
ZJoKyUL5MeqJonWYiAqHEdgooFRSsuVHZTQ4mgWjgiVnIeo4gZrgONl4++y0
Mzs7v/09//d9dvfZ1xav0C3xYxiGfXr+d3123Itvkm7mSq9GcL4byOlb71L2
hPl4JJh1onx9V6iPRfCWcsaGsbwfh/ryDeJdK3l+CYU3Kmw9RXz9K2Cfl6sq
D/I8GZKUXzRfVfH8OnK6Zrvf1fH5KaicUNbi/YvnYMyPFNfIEqU+DsEiT4h7
YXikj8MwWFswsUPCeykO18y0txaE+1iGof2xD/V+/HqR0OXm3Q3S8DwdTo9f
cLWKZzlynwv1WE08R+F8MzNSa+Y5Gku31N0Rx/E8Aw/bf6pckcFzDEJuTTNd
7ef5TRx1e/v1AzzPxFbX37LexXy/syDfdPbM6jV8v7EITPp2YObZ4T5WIK2u
9o044jhki0dtUhDPRptfRW8M8Rz88PhF5QzieMxuaHx1OjEwFJumkfLMAmFz
DrgjyM9F0nLHO1TPzkV5J+egeiYBBaOLqiXkE+B5/0o3MaNE1rURyTLySny+
cWHpkl1+Pj8Pytwuf2J2HtpvxJQuJZ+I7BnOnU7yiRgwn+5bTj4JF+svVI0+
6e/zSdjT0rNSxDMzH5Kv/Y9MID8f9SUfSsTkVdC25e/1KB63PvMqlPaJHlbx
zCzAd1yn7SD5Begqti4/QF4N54nWfmJWDW6Z6lQl+WTcVcSK95NPxvfN6xP3
kk9Ba3hr6T7yKbh2aM/uCvIaGG7mFFI9q8G99t+kH5FPRcOYzXeI2VQg6pJl
F/k0XN3dpSkjn4Z13WzRDvJaxPZs6yCGFoEB9yJ2U70WZTmWuI955rRonjrV
Scyk4+jb01y0P9Kxed/JF4R+0pHTlrh9D+Wf1s9qDxD610EuOrWG1oMOHXeO
Mm7K6zCs11JFz8/pAE/erXLK66F++fFkYujxaPh7O4hZPSb+8xZL63F6jCh+
Ui30b0BBf6eK+oMB6uKg7cL+Bky+Hyn5hPKG/38PxogNg6stVA8jnDsVx4X3
Z0Sfy9tCz8sZUdF9tpE8Y8KZ0D/Shf1NYCddGkXfnzWhUVSSTPPDmaC43hRD
88JkYErJuWNUjwxc9Dy5TfPHZuCDsKkNxFwG4iyG34X5NuObIfMy8jBjKHX9
FSFvhr5/1SSq58y4Hb/phDDfmYhod/1K849MpGWn1gv5TKyyPxCT5zIhLfLc
Fva3wPtnkH815S2IvmkIqaW8BcpF9vPEnAWFed5uYsaK+wNfyGsob0V+yIM6
4X+2Ypw5uPoQ5a2IVw9G0f/M2CCNGiOmfmDD1rXFSlqPtSF9mKztMOVtSNim
aiZm7PBL2RhIDDsiL0/ME/J2eMa6mj6lvB1ro2OqhHwWEmQ3yz6jfBa2SKxf
NlA+C49m5V8g5rJwekvA+GOUd+DckcsrGynvALPhR7mQd0B0vcQt5B04Ns/4
s5BfCPV4he34U/4XL+SNGA==
      "]]}, {}}, {}},
  AspectRatio->NCache[GoldenRatio^(-1), 0.6180339887498948],
  Axes->{True, True},
  AxesLabel->{
    FormBox["\"t\"", TraditionalForm], 
    FormBox[
    "\"\[LeftBracketingBar]\[CapitalDelta]m\[RightBracketingBar]\"", 
     TraditionalForm]},
  AxesOrigin->{0, -17.343031179575597`},
  CoordinatesToolOptions:>{"DisplayFunction" -> ({
      Part[#, 1], 
      Exp[
       Part[#, 2]]}& ), "CopiedValueFunction" -> ({
      Part[#, 1], 
      Exp[
       Part[#, 2]]}& )},
  DisplayFunction->Identity,
  Frame->{{False, False}, {False, False}},
  FrameLabel->{{None, None}, {None, None}},
  FrameTicks->{{
     Charting`ScaledTicks[{Log, Exp}], 
     Charting`ScaledFrameTicks[{Log, Exp}]}, {Automatic, Automatic}},
  GridLines->{None, None},
  GridLinesStyle->Directive[
    GrayLevel[0.5, 0.4]],
  Method->{},
  PlotRange->{{0, 128.}, {-17.067744970375983`, 0}},
  PlotRangeClipping->True,
  PlotRangePadding->{{
     Scaled[0.02], 
     Scaled[0.02]}, {
     Scaled[0.02], 
     Scaled[0.05]}},
  Ticks->FrontEndValueCache[{Automatic, 
     Charting`ScaledTicks[{Log, Exp}]}, {Automatic, {{-16.11809565095832, 
       FormBox[
        TemplateBox[{"10", 
          RowBox[{"-", "7"}]}, "Superscript", SyntaxForm -> SuperscriptBox], 
        TraditionalForm], {0.01, 0.}, {
        AbsoluteThickness[0.1]}}, {-11.512925464970229`, 
       FormBox[
        TemplateBox[{"10", 
          RowBox[{"-", "5"}]}, "Superscript", SyntaxForm -> SuperscriptBox], 
        TraditionalForm], {0.01, 0.}, {
        AbsoluteThickness[0.1]}}, {-6.907755278982137, 
       FormBox[
        TemplateBox[{"10", 
          RowBox[{"-", "3"}]}, "Superscript", SyntaxForm -> SuperscriptBox], 
        TraditionalForm], {0.01, 0.}, {
        AbsoluteThickness[0.1]}}, {-2.3025850929940455`, 
       FormBox[
        TemplateBox[{"10", 
          RowBox[{"-", "1"}]}, "Superscript", SyntaxForm -> SuperscriptBox], 
        TraditionalForm], {0.01, 0.}, {
        AbsoluteThickness[0.1]}}, {-13.815510557964274`, 
       FormBox[
        InterpretationBox[
         StyleBox[
          
          GraphicsBox[{}, ImageSize -> {0., 0.}, BaselinePosition -> 
           Baseline], "CacheGraphics" -> False], 
         Spacer[{0., 0.}]], TraditionalForm], {0.005, 0.}, {
        AbsoluteThickness[0.1]}}, {-9.210340371976182, 
       FormBox[
        InterpretationBox[
         StyleBox[
          
          GraphicsBox[{}, ImageSize -> {0., 0.}, BaselinePosition -> 
           Baseline], "CacheGraphics" -> False], 
         Spacer[{0., 0.}]], TraditionalForm], {0.005, 0.}, {
        AbsoluteThickness[0.1]}}, {-4.605170185988091, 
       FormBox[
        InterpretationBox[
         StyleBox[
          
          GraphicsBox[{}, ImageSize -> {0., 0.}, BaselinePosition -> 
           Baseline], "CacheGraphics" -> False], 
         Spacer[{0., 0.}]], TraditionalForm], {0.005, 0.}, {
        AbsoluteThickness[0.1]}}, {0., 
       FormBox[
        InterpretationBox[
         StyleBox[
          
          GraphicsBox[{}, ImageSize -> {0., 0.}, BaselinePosition -> 
           Baseline], "CacheGraphics" -> False], 
         Spacer[{0., 0.}]], TraditionalForm], {0.005, 0.}, {
        AbsoluteThickness[0.1]}}, {2.302585092994046, 
       FormBox[
        InterpretationBox[
         StyleBox[
          
          GraphicsBox[{}, ImageSize -> {0., 0.}, BaselinePosition -> 
           Baseline], "CacheGraphics" -> False], 
         Spacer[{0., 0.}]], TraditionalForm], {0.005, 0.}, {
        AbsoluteThickness[0.1]}}}}]]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{"velocity", " ", "field"}], " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{
    RowBox[{
     SubscriptBox["vel", "evolv"], "=", 
     RowBox[{"Map", "[", 
      RowBox[{"Velocity", ",", 
       SubscriptBox["f", "evolv"], ",", 
       RowBox[{"{", "3", "}"}]}], "]"}]}], ";"}], "\[IndentingNewLine]", 
   RowBox[{"Dimensions", "[", "%", "]"}]}]}]], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"129", ",", "16", ",", "32", ",", "2"}], "}"}]], "Output"]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Visualize results", "Section"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"ListAnimate", "[", 
  RowBox[{
   RowBox[{"Table", "[", 
    RowBox[{
     RowBox[{"VisualizeTypeField", "[", 
      RowBox[{
       RowBox[{
        SubscriptBox["type", "evolv"], "\[LeftDoubleBracket]", 
        RowBox[{"t", "+", "1"}], "\[RightDoubleBracket]"}], ",", 
       RowBox[{"\"\<t: \>\"", "<>", 
        RowBox[{"ToString", "[", "t", "]"}]}]}], "]"}], ",", 
     RowBox[{"{", 
      RowBox[{"t", ",", "0", ",", 
       SubscriptBox["t", "max"], ",", "1"}], "}"}]}], "]"}], ",", 
   RowBox[{"AnimationRunning", "\[Rule]", "False"}]}], "]"}]], "Input"],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`i5$$ = 20, Typeset`show$$ = True, 
    Typeset`bookmarkList$$ = {
    "\"min\"" :> {$CellContext`i5$$ = 1}, 
     "\"max\"" :> {$CellContext`i5$$ = 129}}, Typeset`bookmarkMode$$ = "Menu",
     Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{{
       Hold[$CellContext`i5$$], 1, ""}, 1, 129, 1}}, Typeset`size$$ = 
    Automatic, Typeset`update$$ = 0, Typeset`initDone$$, 
    Typeset`skipInitDone$$ = True, $CellContext`i5$73505$$ = 0}, 
    PaneBox[
     PanelBox[
      DynamicWrapperBox[GridBox[{
         {
          ItemBox[
           ItemBox[
            TagBox[
             StyleBox[GridBox[{
                {"\<\"\"\>", 
                 AnimatorBox[Dynamic[$CellContext`i5$$], {1, 129, 1},
                  AnimationRate->Automatic,
                  
                  AppearanceElements->{
                   "ProgressSlider", "PlayPauseButton", "FasterSlowerButtons",
                     "DirectionButton"},
                  AutoAction->False,
                  DisplayAllSteps->True,
                  PausedTime->0.7364341085271318]}
               },
               AutoDelete->False,
               
               GridBoxAlignment->{
                "Columns" -> {Right, {Left}}, "ColumnsIndexed" -> {}, 
                 "Rows" -> {{Baseline}}, "RowsIndexed" -> {}},
               
               GridBoxItemSize->{
                "Columns" -> {{Automatic}}, "Rows" -> {{Automatic}}}], 
              "ListAnimateLabel",
              StripOnInput->False],
             {"ControlArea", Top}],
            Alignment->{Automatic, Inherited},
            StripOnInput->False],
           Background->None,
           StripOnInput->False]},
         {
          ItemBox[
           TagBox[
            StyleBox[
             PaneBox[
              TagBox[
               PaneSelectorBox[{1->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlsEJwkAUBRdswBJiJfZgCULOtmwJlmAkt8HLwvr+GmYgTHinzewll/vj
tp5aa8v2nLfn877zuravuM+x67Em9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9
syb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbPmtg/a1LV/wnPuv97/97v
7T3fqD11L73n+lX/3nNU7fav3e1fu9u/drd/7X7U/rPdy1H/f0bdi///eoSJ
/bMm7lX7G4YY090=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 0\"", TraditionalForm]], 2->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlsEJwkAUBRdswBJiJfZgCULOtmwJlmAkt8HLwvr+GmYgTHinzewll/vj
tp5aa8v2nLfn877zuravuM+x67Em9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9
syb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbPmtg/a1LV/wnPuv97/97v
7T3fqD11L73n+lX/3nNU7fav3e1fu9u/drd/7X7U/rPdy1H/f0bdi///eoSJ
/bMm7lX7G4YY090=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 1\"", TraditionalForm]], 3->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlsEJwkAUBRdswBK0EnuwBMGzLVuCJRjxNphD5Ps2a2ZgmfAuCbOXHC+3
83XXWjtMZz+d1/Obx6l9xH0du641sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03s
nzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/1mRr/e/wt/vo/as6VO3k
V/cy9565Pd156fdV7VX3Mkr/pd+xtt3+fXf7993t33e3f9999P5ru5d//f+p
updR9lH6b9XE/lkT9177E7+ewC0=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 2\"", TraditionalForm]], 4->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztkcEJAjEUBQM2YAlaiT1YguDZli3BElzxNughEF/ycQaWWd5hyU6Ol9v5
umutHbZnvz2v9zePU/uI+xq7Hmti/6yJ/bMm9s+a2D9rYv+sif2zJvbPmtg/
a2L/rIn9syb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+syWr97/Cqe/X+vf/be+5v
e+/3R99L73mrdv71Xr1/7zlW2+0/d7f/3N3+c3f7z92r969+L1X6j7qXKnuV
/v9qYv+sifus/QmOXrR3
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 3\"", TraditionalForm]], 5->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztksEJwkAUBRdswBK0EnuwBMGzLVuCJRjxNnhZiO/n6wyECe+SZTbHy+18
3Y0xDsuzX57X+5vHaXzEfRu7XtfE/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/
1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5Zk6r+d7jb/qv9Z8/37X3t
e5n9fvo/nz1f1d69/+w5trbbv3a3f+1u/9rd/rV79/7d76VL/7Xupcvepf+/
mtg/a+JetT8B/MKv2w==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 32}}, {
                    {14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 0}, {16, 
                    32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 4\"", TraditionalForm]], 6->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlsEJAkEUxQZswBK0EnuwBMGzLVuCJah4C4IMrO/v1wSWyLvskPGw+9Pl
eN6MMXaPZ/t4nr9f3A7jLe7r2PWyJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ
/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9syb2z5pU9b/C3fZf7T97vm/v
S9/X7PvT//PZ861t79J/9hxddvvX7vav3e1fu9u/du/Sv/u9dPn+XOpeuuyf
TKr6/6uJ/bMm7lX7HfTkoWc=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 5\"", TraditionalForm]], 7->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMENgkAUBTehAUuASuzBEkw82zIlWIIYby/uAVze/g8zCRnzYgQHdLo/
b4+hlDIux2U5Pq+/vK7lJ+wxdtzWCv29VujvtUJ/rxX6e63Q32uF/l4r9Pda
ob/XCv29VujvtUJ/rxX6e63Q32uF/l4r9Pdaob/XSvb+s9i1Z++/d5/a92n1
/q33q3ae2u7uv/b6ou3R+rd6brPsWfqvvY4se5b+R70v0fqf7XdB/747/fvu
0frz///f57mf/6Pu0fqf1Qr9vVbYe+1vEbeeiQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 6\"", TraditionalForm]], 8->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztl8EJAjEUBQM2YAlaiT1YguDZli3BElzxNniJystPmIFl5B10mY2HPV5u
5+uutXbYrv12vT6/eZzaR9xr7Pq/JvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ
/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9syaj+t/hVfbZ+/fe36j92+fS
+zv279ur9e89J733V22v1t/z/9v32b9vt//Y3f5j99n7z/5cZum/6v9ilv7V
3ltT78Wk2vlf3cT+WRP3UfsTy/+aDQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 7\"", TraditionalForm]], 9->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztl8sJwkAABRdswBK0EnuwBMGzLVuCJRjxNnjZmLz9MANh5B1imOwl59vj
ej+UUk7LdVyuz+8vr0v5iXsfu97WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWx
f9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/1qRV/yc8yz56/9rna7WvfS+1
/2P/ur23/rXnpPb5ett76+/5/+9+9q/b7d92t3/bffT+o7+XUfpv9V723sks
/dd+P+51/9R3Ment/M9uYv+siXur/Q2bYKXD
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 8\"", TraditionalForm]], 10->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMEJg0AUBRfSQEowldhDSgh4tmVLSAlRvD0Csrj79n+YAZnwDkZnQ16f
9b08SinTfj336/h88p3LX9hj7LitFfp7rdDfa4X+Xiv091qhv9cK/b1W6O+1
Qn+vFfp7rdDfa4X+Xiv091qhv9cK/b1W6O+1kqX/Jo66Z+nf6n1r36f3fa7O
pfZ73P1rny/aTv+xe7T+vf9Pou3R+vP7v3c/+tft9B+703/snr1/9nPJ0r/V
uWTZs/SPdu6t76PQ32uF/l4r7KP2H4OBnok=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 9\"", TraditionalForm]], 11->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMEJwkAUBRdswBK0EnuwBMGzLVuCJRjJbfASCO/vDzOwTHinMBtyfbzu
z9MY47Kc83J+zyuf2/iL+xy73tfE/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/
1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81qer/ho++d+m/9f1m2+1fu9t/zr2q
/9b/5Nb3m233+6/d7V+72792t3/t3r1/93vp0n+ve+myd+l/dBP7Z03snzVx
r9q/yMSTMw==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 10\"", TraditionalForm]], 12->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMEJwkAUBRdswBK0EnuwBMGzLVuCJRjxNggSCO/vDzMQJrzTMhtyvj2u
98MY47Q8x+X5vH95XcZP3OfY9bYm9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9
syb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+sSVX/J7z3vUv/teebbbd/7W7/Ofeq
/mv/k2vPN9vu91+72792796/+7106b/Xe+nef6t7qbrH7v3/nX/2e+zef+8m
9s+a2D9r4l61vwGjiaOl
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 11\"", TraditionalForm]], 13->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwkAUBA/SgCWYSuzBEgS/bdkSUkIi/i0H8eTYe++YgTBhIRLmiOvj
dX8upZTrcV2O63P/ZbuVKuwxdtzXCv29VujvtUJ/rxX6e63Q32uF/l4r9Pda
ob/XCv29VujvtUJ/rxX6e63Q32uF/l4r0fq/xbPs0fq3vn/re4/as/dvfb9o
O/1j7ln6z3ouo/qffY+zfRfZ/3/oX3/OZfrXn6P/b/us/bOcS/b+vc6l1678
+zvZ+2c53zMr9Pdaob/XCv29VthH7TuwH57J
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 13}},
                     {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 10}, {16, 
                    10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0, 7}, {16, 
                    7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 4}, {16, 
                    4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 1}, {16, 
                    1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 12\"", TraditionalForm]], 14->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztl8EJwkAUBRdswBK0EnuwBMGzLVuCJRjJbdDDgry/2cxAmPBOyyREPN8e
1/uhtXZaruNyfe5XXpf2Ffcxdv1fE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE
/lkT+2dN7J81sX/WxP5ZE/tnTeyfNRmt/xOeZR+tf+/5e89dtdu/dt9K/97n
0nvu0fbR+s/6/v/aR+s/6/vv96d2t3/tbv/afdb+W/m93nr/que1t/+/ezWx
f9bE/lkT+2dN3Kv2N8a+qKE=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 13\"", TraditionalForm]], 15->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztmMEJwkAUBRdswBK0EnuwBMGzLVuCJRjJ7aGHBZ2/G2cgjLxTnAVJPF5u
5+uutXZYrv1yvT6vPE7tLe5j7Pq7TuzPOrE/68T+rBP7s07szzqxP+vE/qwT
+7NO7M86sT/rxP6sE/uzTuzPOpml/z1M7f/Wv7dP7/f5tFPn2HtfW+v8632W
/r3n0nvfo+32r93tX7vbn9n9/a/d7V+7b7X/LM+rs/evOq/ec5z9/Ws0U/9X
JPZnndifdWJ/1on9WSfuVfsTS16tfQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 14\"", TraditionalForm]], 16->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztl8EJwkAUBRdswBK0EnuwBMGzLVuCJRjxNkQkEN/ujzMQRt5FmQ2GHC+3
83XXWjtM1366Xp/fPE5tFvcxdr2uif2zJvbPmtg/a2L/rIn9syb2z5rYP2ti
/6yJ/bMm9s+a2D9rYv+sif2zJqP1v8Nb2av3X/q7e+32H3O3f9/d/n13+6+7
+/ztu3/r/MlLv8f+8/u/3f/Vz6VK/yrnstX7/9fnknrPrfr/X8X2r2li/6yJ
/bMm9s+auPfan5DFsjk=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 15\"", TraditionalForm]], 17->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztl8EJwkAABA9swBK0EnuwBMG3LVuCJRjJbzCPhMveec5AGNlPzByIOd8e
1/uhlHKaruN0fT7PvC7lK+597Lquif2zJvbPmtg/a2L/rIn9syb2z5rYP2ti
/6yJ/bMm9s+a2D9rYv+syaj9n/DW/d/61+q2tC895973/fX+a793q93+fe72
b7vbv+1u/8zu73/b3f5t91H793Yuo/7/r3Uue5/j1vfltfcZzan3XPv3aWL/
rIn9syb2z5rYP2vi3mp/AzBmr/s=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 16\"", TraditionalForm]], 18->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztl8EJwkAUBRdswBK0EnuwBMGzLVuCJRjJbTCHwPL+ZpmBMOGdktlDyPXx
uj9PrbXLcp2X63e/8rm1v7iPseu+JvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ
/bMm9s+a2D9rYv+sif2zJqP1f8Oz7Efvv/e5q3b7j7nbv3a3f+1u/9rd/pnd
72/tbv/afdb+e/et9+m1z/r/VXVevf9zt0yO3n+0c7f/2Cb2z5rYP2ti/6yJ
/bMm7lX7FyjcpsM=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 17\"", TraditionalForm],
                 ImageCache->GraphicsData["CompressedBitmap", "\<\
eJzt3Utu21YUxvFrvSw/+kBGSdGBd9C6TbuEpkDRPdRIy9iDokWaecCF0Hvo
RECbcTpLuAQPtQxW90VeitTTonyP/C9gPUjqfuLvXFEmmB7/fPXm+rffr97c
vLy6ePH66s/rm5d/Xfzwx+vZov6RUupOqaO/L5R+XMyeups7VRSFXrn47kdz
N1B5lqgksT/pZPqdWdyf3U7VJM1UPnvWa2yaqsm0+GatTc2oX9jMF+ZupIo8
00vNM/0znaQqy4vn5slpbUCzyWzzJJ2oaf3xpR+tZfPZ6D339tzg5tlT+z5+
8u88eB/fLgjXL6/ea66yxKy7bNn5YcuwT5t7niT10Zfsefjeg3WXy6Caoz8L
38PQ7kU62ytXnyTL3d6f2xEn+boKX5kFZwtf1hZVmwse0Ewo9b0fzuxHUtuX
BZNAfW3WjttfU439ZTjrh7X56aazel6+o3L/Vk/9+U3bh35W++h9Zl9d6C38
R+DDVqvem9tjt6NJWSJdLg90tPjl/5UzwjnlE5W6l9ndMVOieK9fNfb7PJ1t
5Par3xhbP9U/6sTc7m7ZeMfjRZpR1ubUcevplGWZ+ejA3Rn3SfjpzXLzzD/u
rWa/vb3dybJlb/eAMkr2z/dPu6vxIs2AFlp5GdBCKy8DWmjlZUC7X1oj+06v
frImuP1PLzPbbbNsfI/XRpuxg7kscbehhVbebkMLrbzdhhZaebsNLbTydjsi
2oGW/Vev5hxtL+DQQhtRBrTQysuAFlp5GdBCKy8DWmjlZXD6Gyc4tNBGlAEt
tPIyoIVWXga00MrLgBZaeRmc/sYJDi20EWVAC628DGihlZcBLbTyMlbTHpu7
RuerAeJdiY/M3cJuYn3ku5L3vYlCedMkZ6i1/9EvedKsUUtnMmrU8aejvdsb
B6WO2ett7UZwd/ut2950j4MLv0fGlgEttPIyoIVWXga0D01L56M9g0MLbUQZ
0EIrLwNaaOVlQAutvAxooZWXwT8rjhMcWmgjyoAWWnkZ0EIrLwNaaOVlQAut
vAxOf+MEhxbaiDKghVZeBrTQysuAFlp5GdBCKy+D0984waGFNqIMaKGVlwEt
tPIyoIVWXsZq2p6lVbabiG2fY5eFjaZMuwt6unRchdNaFcwmuqlROlHT+mP6
juy9ErqdVNUCLFeZbTVlKtHoSbVskCx3pa3WUc7OyqnOLfQk36iiFKOzYrgD
mfla4UD30Ae6fjj1+eLfexX4zRba2DKghVZeBrTQysvgSm+c4NBCG1EGtNDK
y4AWWnkZ0EIrLwNaaOVlcPobJzi00EaUAS208jKghVZeBrTQysuAFlp5GZz+
xgkOLbQRZUALrbwMaKGVlwEttPIyoIVWXobk09+3bwv9M1umb7dbNr7Ha7fJ
EDKXoYUWWmihhRZaaKGF9r6067W5SnRDmBi6XRx0FUaqrc3VTN4XKWyT1KMa
+/xMDP0yW5GqBGv3uLLdfRo9r2Lo5NNmZ9+KXqZvVy8br7ndNsu2rKM6U4t6
XJnmPmmqUnd4S7JcxXp8O4RKnAQfgbkGV6Yypp2SOQBSgU4qsLir1bD2Pe86
WykOS52VItbfZqGFFlpooYUW2genFXN1NybwtgzmMrTQQgsttNBCCy200EIL
bcy0nP4yl6GFFlpooYUWWmihhRZaaB8BLae/zGVooYUWWmihhRZaaKGFFtpH
QMvpL3MZWmihhRZaaKGFFlpoN6FV/Vpni565HZXde6p1puMF3V+6LITt8pKY
7lW2tcjIdoNJJ2paFOFjOo90VgjfmspM/SwvV+tWVP5jETSIMZVo9Ley9Tmx
JXODhI3JwlZL1HL1Mv/+Nvx/xO3xalzSL6shFeiiAuq89hnQP/qDZT4HHNr2
XYyz8jumbGXlC1A0vuzp9dZdJfiNFlpooYUWWmih5QpvHODQQgsttNBCCy20
0EILLbTQPgQtp7/MZWihhRZaaKGFFlpooYUW2kdAK+b0d91luwZflnsgcxla
aKGFFlpooYUWWmihhfYR0EZ5+rvusnUx7lPAtmWt+yFjLkMLLbTQQgsttNA+
GtrWHkz9Wg+m+WX6p0dFOqzIomZMYQVcW5kYOpYcaCHcHK81Yxq6ZWE1zHZr
dWEyj23bn7CGUXRhiiljh0W0fWSOgwZYucrSVKW+B82sNDH0mokpY5cHs5PF
LZjMQc52+xlRgc4qMFYr+i7573ffeqkoZH2/CyuIpF9moYUWWmihhRZaaA+D
VvTF3agymMvQysuAFlp5GdBCKy8DWmjlZUALrbwMTn/jBIcW2ogyoIVWXga0
0MrLgBZaeRnQQisvg9PfOMGhhTaiDGihlZcBLbTyMqCFVl4GtNDKy1iT1si+
06s5/d0LOLTQRpQBLbTyMqCFVl4GtA9I63r1hN2tdBsS29liECw3XS/oAdNd
Ic5bm1eZ57o3jO9GUj2mH1JnxbDzfFxWoKxE4Xoj2fZUpgKNnlb2s3Nafnb8
C6vmSr6tTzUIZeyijGV3sapki0pJd7HOD21Ve6tKnUPb3ovR/MLXByW+8Pdd
CH6phTa2DGihlZcBLbTyMqB9aNrN/43zDpaNdzxepBkbz+XD2G1oRWdAC628
DGihlZcBLbTyMqCFVl5GK+2y09/yBR/us+puy7tP7JDmWq3/eyv22qH61K0q
phOVuguHH+dWmeuL9lVzq8wl+Mz+K4uPYZa+KOavyFdXJz/MbaIz3UVMfzF/
bpPqz/YU5eb3xLgyd8eq+vs07tKpHt49HoUqblmvheMmHLK++enSIao/QrTh
EO5KroHxl92vtxsivFa87RCBxYZDDMI56SbBKzvEL+Zu7Eb3108bVRoEc8TM
6rw5evgGXy1+gydm2cD9qbQybdgilazazWFtmZ/bQ/fnjqp/sFKoX5fMUnX0
P1+BkZU=\
\>"]], 19->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlsEJwkAUBRdswBJiJfZgCYJnW7YESzDi7eESDLvv/3VnYBl5lyQjYk7X
++V2KKUs6zmu5/35w/NcvsKeY8dtrdDfa4X+Xiv091qhv9cK/b1W6O+1Qn+v
Ffp7rdDfa4X+Xiv091r51/4P8d59tv6tutX22nP2vu7o/X+976id/jl3+sfu
9I/d6R+7Z+vf6r0l2z7K/+/onWv76P17v+f33kfpn+17VPZ2nq1/tt/dlpXZ
+kdbob/XCv29VujvtUJ/rxX6e62wR+0vT6erHw==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 18\"", TraditionalForm]], 20->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztl8EJwzAQBAVuICXYlaSHlBDwOy2nBJdgh/yW5CEQe3diBsyEfYlRHvb2
fD32pbW2Xs/tej6/vxz39hP2HDsea4X+Xiv091qhv9cK/b1W6O+1Qn+vFfp7
rdDfa4X+Xiv091qhv9dKtv5v8Sx79f69547a6Z9zp3/sTv/Ynf6xe7b+ve8P
vefOtlfp33u+bHuV959Z//9V+o+6l6j7mvX7K+q+Rn/n/rNSvX+2e6d/biv0
91qhv9cK/b1W6O+1Qn+vFfao/QRj8KHn
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 19\"", TraditionalForm]], 21->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztmMEJwkAUBRfSgCUkldiDJQiebdkSUkIi3h6GsLB5/+8yA2HkXRInEsXl
+X68plLKvB+3/fi+/rHey1/Yc+y4rRX6e63Q32uF/l4r9Pdaob/XCv29Vujv
tUJ/rxX6e63Q32tl1P4fcet91P5Xdzt6n0d76/tVe/4s/WuvO9tO/9id/rE7
/WP3bP2v/t7MtvfSv/b6ovbef/+M2v/MtefJ8vzJ9rzq/fPf+32kf1u7/pdQ
6O+1Qn+vFfp7rdDfa4X+Xiv091qhv9cKe9S+AUzUrV0=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 20\"", TraditionalForm]], 22->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztl8EJg0AUBRdsICXEStJDSgh4TsspwRI0eHtEwoK8//8yAzLhnZZZD2Z+
vZ/L1Fq7789tf76/D9ZH+wl7jh1fa4X+Xiv091qhv9cK/b1W6O+1Qn+vFfp7
rdDfa4X+Xiv091rJ1v8jHmWv3r/33FE7/XPu9I/d6R+70z92z9a/9/uh99zZ
9ir9e8+Xba/y/TPq+1+l/1X3ku0eq/evco+j/v+t4n+dz6zQ32uF/l4r9Pda
ob/XCv29VujvtUJ/rxX2qH0DhSCh5w==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 21\"", TraditionalForm]], 23->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztmMEJwkAUBRdswBK0EnuwBMGzLVuCJRjxNphDZPN2P8xAGHkXk8nBxPPt
cb0fWmun5Tgux+fzl9el/cR9jl33NbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN
7J81sX/WpHr/Jzx6r96/V4e16+m1/3tftn7PLP23nvdsu/3H7vYfu9t/7D5b
/9l+T/feq/Tfen5Vdvtn9irPn6Pej9aus9depX+V+0vsv49T/0sQ+2dN7J81
sX/WxP5ZE/tnTeyfNbF/1sT+WRP3Ufsbhp6fiQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 22\"", TraditionalForm]], 24->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztl8EJwlAQBT/YgCVoJfZgCYJnW7YESzCS20ORhfh29zsDYeRd8pkgJMfL
7XzdjTEOy7VfrtfvlcdpvIW9xo63tUJ/rxX6e63Q32uF/l4r9Pdaob/XCv29
VujvtUJ/r5Vq/e/iWfbu/aPnztrpX3Onf+5O/9yd/rl7tf7R94fouavtXfpH
z9dl79K/y/9i1vf/Xz+vrZ7jt86fHL3PbOb797+t0N9rhf5eK/T3WqG/1wr9
vVbo77VCf68V+nutsGftT2foqSE=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 23\"", TraditionalForm]], 25->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlsENgkAUBTexAUvQSuzBEkw427IlWIIYbi9y2M36/v9kJiFD3gUYDnB9
PO/LqbV2WY/zenzPN9639hP2HDuea4X+Xiv091qhv9cK/b1W6O+1Qn+vFfp7
rdDfa6V6/5c4eq/ef1aHveeZtY++l97rZOnfe9/ZdvrH7vSP3ekfu2frn+17
+u+9Sv/e+6uy0z92r9I/aldG9+r//0d97/QfM/2PZYX+Xiv091qhv9cK/b1W
6O+1Qn+vFfp7rdDfa4U9av8ACnGkRQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 24\"", TraditionalForm]], 26->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztl8EJwkAUBRfSgCVoJfZgCYJnW7aElGCCt4eLfJD3/25mIIy8i+sckni5
P2+PpbV23q7Tdu2fP6zX9hX2Gjv+rxX6e63Q32uF/l4r9Pdaob/XCv29Vujv
tUJ/r5Vq/V/iWfbR+0fPnbXTv+ZO/9yd/rl7tf7R51f03NX2rP5H69zbq/WP
nmP0vVr/rL33O6P7rO//o9z3fnXuOfo9s9n1P5f+Oeb+U9sK/b1W6O+1Qn+v
Ffp7rdDfa4X+Xiv091qhv9cKe9b+BpUAqOE=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 25\"", TraditionalForm]], 27->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztl8EJwkAUBRdswBK0EnuwBMGzLVuCJRjJ7eEiH9b39yczEEbeKTuRQM63
x/V+aK2dluu4XJ/fK69L+wr7HDsea4X+Xiv091qhv9cK/b1W6O+1Qn+vFfp7
rVTp/xRX26v0j54rep5/71vtH73v2Xb65+70z91n61/9PR/dq/SP3l+VPav/
3v7nvb1K/1F77zxZe5X3T9bzVX7tW/3+ynruo79ze1b21j/bCv29VujvtUJ/
rxX6e63Q32uF/l4r9Pdaob/XCv29VujvtcKetb8Bw/Gmow==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 26\"", TraditionalForm]], 28->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztmMENgkAUBTexAUrQSuyBEkw827IlUAIYby/uYc3y/l+YSciQdxGGRKK3
x2t+Xkop1+2YtuNz/mW5l5+w59hxXyv091qhv9cK/b1W6O+1Qn+vFfp7rYze
/y2O3kfv36tD7X567f8+l9bPydK/9bqz7fSP3ekfu9M/ds/WP9v7dO89qv/Z
Otf2bP1br2P0PVv/qL12n3vv2b7/R3+/HPX3V7bncrb/H45uhf5eK/T3WqG/
1wr9vVbo77VCf68V+nut0N9rhf5eK/T3WmGP2ldO+Zhv
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 27\"", TraditionalForm]], 29->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztmMEJwkAUBRdswBJiJfZgCULOtmwJlmAkt4d7WNh9/2czA2HCu5hMwKC3
5+uxXkopy3Zct+N3vvO5l7+w59hxXyv091qhv9cK/b1W6O+1Qn+vlVn7v8W9
91n7j+5Wu8/a3vt5tX5+lv6t1x210z/nTv/Ynf6xe7b+o9+b2fao/mfrXNuz
9W+9jqPv2fpH7bX7HL1n+/4/+vtl1t9f2Z5L7/8llLP1j7ZCf68V+nut0N9r
hf5eK/T3WqG/1wr9vVbo77VCf68V+nut0N9rhT1q/wKpap9p
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 28\"", TraditionalForm]], 30->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztl8EJwkAUBRdswBJiJfZgCYLntGwJlmDE28McFnbf/9/MQJjwTtkJol7u
6+1xaq0t23Xers/9l9e1/YQ9x47HWqG/1wr9vVbo77VCf68V+nutVOn/FFfb
q/TvPVfveWbv/9q/97mz7fSP3ekfu9M/do/qP+r3Q+9zZ9uz9e99jup7tv6z
973zRO3Z+ke9371zzt6rfP9mey9H+/+b7b2M/vwqR+sfbYX+Xiv091qhv9cK
/b1W6O+1Qn+vFfp7rdDfa4X+Xiv091qhv9cKe9T+BmtPnQs=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 29\"", TraditionalForm],
                 ImageCache->GraphicsData["CompressedBitmap", "\<\
eJzt3U1u20YUwPGxZMmS7aZFVknRRW7Qpk17hKZA0TvUCMoki6JFmn3AgzB3
6EZAm3W6S3iELHUMVvNFDkXqyxapedI/gPUxJOdxfm9ImaHx9MvN6xe//X7z
+uWzm0dPX938+eLls78e/fjHq0XT8Ewp9Umps78fKf26WLx1D59UURR64eqn
n8zTucqzRCWJ/Uln8+9N83DxOFezNFP54t2gsWqqZvPi261WNb1+aWM+NU9j
VeSZbjXv9M98lqosL56YN5e1Ds0qi9WTdKbm9dePfW8tqy96H7jdc52bdw/s
fvzs9zzYj+9WBNebV/uaqywxyx63DH7U0u2D5siTpN77mpGH+x4se7wOqtn7
w3AfRnYU6WJULj9JlrvRX9seZ/m2Cl+bhquVm7WFqs0FD2gmlPrBd2fGkdTG
smISqG/M0kn7NlXfX4WzflSbn246qyflHpXj2zz1l1dt7/ph7dD73G5d6DX8
IfDhVovem8cLN9CkTJFOlwc6W735f+WMcE75TKVuMzscMyWK93qriR/zfLGS
G9ew0bd+q3/U1Dzur22y5/4ijVHm5tJx6+mUZZk5dODujHsaHr1Zbt7514PN
7G/fvt1L27rdPaIYJfsX/dPuq79IY0ALrbwY0EIrLwa00MqLAW2/tEb2nV58
f0tw+0+3mfVu0za5w7bRxtjDXJY4bGihlTdsaKGVN2xooZU3bGihlTfsiGjP
tey/ejHXaL2AQwttRDGghVZeDGihlRcDWmjlxYAWWnkxuPyNExxaaCOKAS20
8mJAC628GNBCKy8GtNDKi8Hlb5zg0EIbUQxooZUXA1po5cWAFlp5MTbTXpin
RuWrc8S7Eh+bp5XVxIbIdyXvaxOF8qZIzkhr/6M3ud/MUUtlMnLU8dHRXu2N
k1LH7PWydmO4u/3UbS+6x8mF3yNjiwEttPJiQAutvBjQHpqWykc9g0MLbUQx
oIVWXgxooZUXA1po5cWAFlp5MY7tz4rfvCn0z6JNP25um2y53l3awhiC5zK0
0EILLbTQQgsttNBCC+0J0EZ5+bvtwO3u6Tb9WG+btLS1rXebNsFzGVpooYUW
WmihhRZaaKGF9kRpxVz+7grUJXhbDMFzGVpooYUWWmihhRZaaHehHVhaZauJ
2PI5ti0sNGXKXcRQ0+Wos3BZy4JZRRc1SmdqXn8dQ92RE8uELidVlQDLVWZL
TZlMNGpSresky11qq2Wks7N0qmsLPct3yijJ6CwZ7kRmPlY40R36RDcMpz4f
/L1ngd9soYUWWmihhRZa7vTGAQ4ttNBCCy200EILLbTQQgvtIWi5/GUuQwst
tNBCCy200EILLbTQngBtr5e/HvI2Nb+OBRxaaKGFFlpooYUWWmihhRbaQ9Ae
/PK3D4yYwKGFFlpooYUWWmihhVY47XZlrhJdEKbLahdkYfE0Vm1lrhbyPklh
maQB2ejzmBj5NpuRKgVb17iy1X0aNa+6rORzl/8k2fU/UyLMo7pSq2pcmeI+
aapSd3pLslz1fX47pUxMg0NgqcCVyYwpp2ROgGSg43PaclWrUe1z3lW2UpyW
jua3WWihhRZaaKGFVgztwe/u7qO/TV9oHBM4tNBCCy200EILLbTQQgsttIeg
jbK01b6Tuu7/JULIXf+fQ+D3UUMLLbTQQgsttNBCCy200J4o7dFd/rbF2BUy
bNt6HMc/l6GFFlpooYUWWmihhRZaaAXTnsTlby8xTnMuQwutwGFDC628YUML
rbxhQ3vktGpYq2wxMI/jsnpPtcxUvOiy+guJsFVeElO9ypYWGdtqMOlMzYsi
fN1l5ZETT4QvTWWmfpaXi3UpKn9YBAViTCYa9a1sfqY2Za6TsDBZWGqJXHaW
S3u+mpT063JIBjo5rV3XjgH9ow8scxxwaus7GVflZ0xZysonoGh82Hda6+3E
M8FvtNDGFgNaaOXFgBZaeTG4wxsnOLTQRhQDWmjlxYAWWnkxoIVWXgxooZUX
g8vfOMGhhTaiGNBCKy8GtNDKiwEttPJiQAutvBhc/sYJDi20EcWAFlp5MaCF
Vl4MaKGVFwNaaOXF4PI3TnBooY0oBrTQyosBLbTyYkB7QNrWGkzDWg2m5Tb9
MyAjHWZkVTGmMAOurAwVSzpLhJvjtWJMI9cWZsOst1UVJvPalv0Jc0gVpu6S
aOvIXAQFsHKVpalKfQ2aRWqoNdPdyWy6ugSTOcnZaj9jMtBZBiZqQ90l//nu
Sy8VBZ/vHSaEX2ahjS0GtNDKiwEttPJiQHtoWm7u9gwOLbQRxYAWWnkxoIVW
XgxooZUXA1po5cXg8jdOcGihjSgGtNDKiwEttPJiQAutvBjQQisvBpe/cYJD
C21EMaCFVl4MaKGVFwNaaOXFgBZaeTG2pDWy7/RiLn97AYcW2ohiQAutvBjQ
QisvBrQHpHW1esLqVroMia1scR60m6oX1IDpLhHXrcWrzHtdG8ZXI6leUw+p
s2TYeT4pM1BmonC1kWx5KpOBRk0re+xclseO37AqruTL+lSdkMYu0lhWF6tS
tiqVVBfr/NRWlbeq1Dm19Z6M5ge+Pinxgd93IvilFtrYYkALrbwY0EIrLwa0
h6bd/W+c99A22XN/kcbYeS4fx7ChFR0DWmjlxYAWWnkxoIVWXgxooZUXo5V2
3eVvucGHuyz6dMunz2yX5l6t/74Ve+9Q3XOLivlMpe7G4celReb+ot1qaZG5
BZ/Zv7L4GMbSN8X8Hfnq7uSHpVV0THcT09/MX1ql+tqeolz9jhg35ulCVd9P
426d6u7rN68dWFJ+VY1+LHcnz8ovqQu/2yYJwwxr3V7U2uzI7B3BcU3ZgyRZ
/nx1b5OW3soIgfqaHZrWVrd/WlF+9Zvr1v7JRe6/NWlNb5em7aqUrf9ZQJXI
cBqu6e7KtF3WZYJpWnUd7tiv5mlSBrXpa6TYZzi8kW7v2U6rSbc62OYs32tk
1K7j37eQ2FBrep6EB07SdsN5eZnd7vmaw0Gd/Q8ZlnWy\
\>"]], 31->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlcEJwkAUBRdswBK0EnuwBMGzLVuCJRjJ7aGHDZv3/3dnIIy8i3GWmPPt
cb0fWmun5Tou1+fzyuvSvsKeY8djrdDfa4X+Xiv091qhv9dK9f5PcfRevf+o
Dr9+z6h967n0fk+W/r33nW2nf+xO/9id/rF7VP8q79O992z9e++j+p6t/2zP
RZX+//o/VuX9G3Xuyuhzn63/3s/RViuz9Y+2Qn+vFfp7rdDfa4X+Xiv091qh
v9cK/b1W6O+1Qn+vFfp7rdDfa4X+XivsUfsbcaGfSQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 30\"", TraditionalForm]], 32->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztmMEJwkAUBRdswBJiJfZgCULOtmwJlmAkt4cRNuy+/d/MQBh5F5MJRvFy
f9zmUyllWo7zcnxer7yu5SvsMXbc1gr9vVbo77VCf6+V7P2f4tF79v6tOmxd
T6t9732pfZ8o/WvPe9RO/5h7tP7Rnie99yz9a88vy56l/7/el1H9s/ye6b1H
6197Htn3aP1H7VvX2XuP9vw/2vfL0fpH+zzS/7f3/p9Ta4X+Xiv091qhv9cK
/b1W6O+1Qn+vFfp7rdDfa4X+Xiv091qhv9cK/b1W6O+1wj5qfwNW0JWx
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 31\"", TraditionalForm]], 33->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztl1EKglAUBR+4gZZQK2kPLUHouy23BJeQ4d9BPy7peffmDMjEASEnS7qN
r8dzaK1d5+MyH9/XC9O9rcKeY8f7WqG/1wr9vVbo77VSpf9bXG2v0j96XdHr
OXr/1/7R951tp3/fPVv/6r8z0T1bf+7/2Hmu+5z+6+dxP/+2Z+t/9L51Pb32
bP3P9hyv8vyt/r2r/v8r2+eyt5Wz9e9thf5eK/T3WqG/1wr9vVbo77VCf68V
+nut0N9rhf5eK/T3WqG/1wr9vVbo77XC3mv/AKqAn0k=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 32\"", TraditionalForm]], 34->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztltEJwjAURQMu4Ag6iTs4guC3KzuCI1jx71KRyHv3JfYcCLdcKE0OTZvj
5Xa+7lprh2Xsl/G6fvM4tVXox+jJ2FTw700F/95UZvF/l5ytn8V/77p615Pd
/6v/3nmP1uO/tsd/bY//2r7Kf9T5oXfeo/XZ/qN84n/9vujvRvZ5+9Nzq/rR
3v9v52T3vsvuZ/n/Vv13lOj9uzX/2fv01/2rbM1/dSr496aCf28q+Pemgn9v
Kvj3poJ/byr496aCf28q+Pemgn9vKvj3poJ/byr496aCf28q9FX9E4q6mi0=

                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 33\"", TraditionalForm]], 35->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztmMEJwkAUBRdswBK0EnuwBCFnW7YESzCS28Mcvmze/8vOQJjwLiYjJOL1
8bwvp9baZT3O6/E933jf2k/Ya+y4rxX6e62M0v8lrrqP3j96v9H76bX/+71E
P6dK/+h1V9vpn7vTP3ev1n+U53yvfZT+0esbZc/q3+t3XfS6q+1H95+tZ3Sv
1j9r37vPo/dqz5/Z3u/V3r9Zzv5fQqG/18ps/bOt0N9rhf5eK/T3WqG/1wr9
vVbo77VCf68V+nut0N9rhf5eK/T3WqG/1wr9vVbo77XCnrV/AGvXkNU=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 34\"", TraditionalForm]], 36->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztl8ENwjAQBC3RACVAJfRACUi8aZkSKIGg/FbcI5Gzd05mpGijfcTJ2JHl
6+N1f55aa5fpOk/X737mc2t/oa/Rk31TGd3/WzK7H91/Lw/R9/Tq187L0nGq
+F/63lk9/mv2+M/t8Z/bV/NfbT/dus/yfzTPUb+1/16e9zovWf6j52adj6L3
2bqvtv7Xnh9H3cer7b+j7O+911U0TtTvLbP/UwX/3lSO5j87Ffx7U8G/NxX8
e1PBvzcV/HtTwb83Ffx7U8G/NxX8e1PBvzcV/HtTwb83Ffx7U8G/NxX6rP4L
dBmQVQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 20},
                     {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 18}}, {{0,
                     17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 15}, {16, 
                    15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 13}}, {{0, 
                    12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 10}, {16, 
                    10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0, 7}, {16, 
                    7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 4}, {16, 
                    4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 1}, {16, 
                    1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 35\"", TraditionalForm]], 37->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztmMEJwkAUBRdswBK0EnuwBMGzLVuCJRjJ7WEOH7Lv78/OQBh5B00GjeL1
8bo/T621y3Kcl+P3eOVza39hH2PH+1qp0v8trrZX6R+9ruj19N6P2j963qPt
9M/d6Z+7j9a/+n0+ulfpHz2/Knvv/nv9ToueX5U9q//W8/b+vb31ull7lff/
Ub9HRrv/z/b9Plv/3p/To/7/kNXfZWW2/tlW6O+1Qn+vFfp7rdDfa4X+Xiv0
91qhv9cK/b1W6O+1Qn+vFfp7rdDfa4X+Xiv091qhv9cKe9b+BRZ3kzM=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 36\"", TraditionalForm]], 38->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlssJAkEQBQdMwBA0EnMwBMGzKRuCIbji7aGHhpnX0ztVsNTyLu6UHzzf
Htf7obV22q7jdn3uv7wu7Sfsc+yz+CmutlfpHz1X9Dyj9732jz73bDv9c3f6
5+6z9a/+Ox/dq/SPPl+VfXT/Xv/Tos9XZc/qH329ve5VPv+j93/nHL1n9c/y
av1n82zfu9X693pfeluhv9fKav2zrdDfa4X+Xiv091qhv9cK/b1W6O+1Qn+v
Ffp7rdDfa4X+Xiv091qhv9cK/b1W6O+1Qn+vFfas/Q3QO4c9
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 37\"", TraditionalForm]], 39->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztl8EJwkAUBRdswBK0EnuwBCFnW7YESzCS28Mowv73/yYzEEYeJIQ5uHq+
3a/TobV2mq/jfL0/Lzwv7SPsNXa3H2LXrvR+/uj9/33vajv9c3f65+70z92r
9e91Po6yZ/XfW+e1Pbo/nb/v1fpX+50fvWf15xzvc99oju6/1f+/0f2j919W
ttq/6veksrf+2Vbo77VCf68V+nut0N9rhf5eK/T3WqG/1wr9vVbo77VCf68V
+nut0N9rhf5eK/T3WqG/1wr9vVbYs/YXECaRFQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 38\"", TraditionalForm]], 40->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztl9EJwkAQBQ9swBK0EnuwBMFvW7YESzCSv4ciJ5e3u+cMhJH9kGTOeMnx
cjtfd621w3Lsl+P1eeVxam9hnmPu9l386/zT9Yya955P9f69551tXr1/9XWp
0n/W+4L+sfOo/qP2U/qv/rduo+Zb9+/93q3vi2zrnu33/+05ebb9ovr+S/9a
jvp/q/7+G9XfZWXW/lmt0N9rhf5eK/T3WqG/1wr9vVbo77VCf68V+nut0N9r
hf5eK/T3WqG/1wr9vVbo77VCf68V+nut0N9rhXnU/AnpuZ8p
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 39\"", TraditionalForm]], 41->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztl9EJwkAUBA9swBJiJfZgCYLftmwJlmAkf0uOcHC3757OQJiwICQTjHi5
P2+PUyllWY/zenzPN97Xsgv7HLvbL/HR3no/o/fadWbv33rds+3Z+2d/LvSP
3aP6t/bM3rm2j+7/bz1b9179e3Xu9b3I8tyj+rfuo997tfscvWf5/aX//uey
Oer9lv3/V1R/l5Vf7T+rFfp7rdDfa4X+Xiv091qhv9cK/b1W6O+1Qn+vFfp7
rdDfa4X+Xiv091qhv9cK/b1W6O+1Qn+vFfp7rdDfa4U9av8AYNSrXw==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 40\"", TraditionalForm]], 42->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztldEJwkAQBQ9swBK0EnuwBMFvW7YESzDi3yNHWM2+vegMhAkLIZfhuBwv
t/N111o7TNd+ul73bx6nNgvzMeZu38VL8+j3ZM9769x6/+i6R5vTv3Ze1T96
ntB//jn283fztfqvtZ+z573vqZpn9+89H+2Wfb711pk9H23//9t/vOr8r3J2
/0/3W/Q9W3XVf2fJyq/2H9UK/b1W6O+1Qn+vFfp7rdDfa4X+Xiv091qhv9cK
/b1W6O+1Qn+vFfp7rdDfa4X+Xiv091qhv9cK/b1W6O+1Qn+vFeZV8ydRmbA7

                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 41\"", TraditionalForm]], 43->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlcEJwkAABA9swBK0EnuwBMG3LVuCJaj4G8zjQm7vcsxAmLAPScZozrfH
9X4opZw+x/FzfM9/vC7lL+5j7K38hNfutffTel+6zr30r72+vex76T/r99K6
/6z/J1vtW/W357q9df/az93q97KX56HX81+7z/p+H+392+v9vnSfrXf7993t
P4bJrP1HNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyf
NbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN3Hvtb3a1sHs=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 42\"", TraditionalForm]], 44->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlt0JwjAcBwMu4Ag6iTs4guCzKzuCI6j4dtSHSPJLWu+gXPlDob2mH8fL
7XzdlVIOr23/2t77Hx6nsojzOea9fId/nddeT+/5t/OcrX/tfak979nmvfu3
Ws/2Xz7uX9dtq3mr/q3Wbe/nZbb1MKp/7Xyr35G1fH/tv3zc2jzq/bb2/89R
/VMmW+0/q4n9syb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/
rIn9syb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+sifNR8ydXa8qF
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 43\"", TraditionalForm]], 45->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztldEJwjAURQMu4Ah1EndwBKHfruwIjmClfwcfoiT3JfEeKEfeR9ucSHO6
3i7roZSybNdxu16/dx7n8hbP+5i38h3OXmetebSurP7R+8zaP5q37l+r86z7
ktU/uu+3+zX6vtTqX6vbp+9kq+dG62w97+38/bfzfdb+/v/nOuvc+fW7Gr1X
NO/drc+d2iaj9x/NxP21Ju6vNXF/rYn7a03cX2vi/loT99eauL/WxP21Ju6v
NXF/rYn7a03cX2vi/loT99eauL/WxP21Ju6vNXF/rYn7a008z5o/AVS1yEc=

                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 44\"", TraditionalForm]], 46->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztklEKgkAABRe6QEeok3SHjhD03ZU7QkfI8G9ogwV97toMyMgDUUfPt8f1
fiilnKbjOB2f85nXpXzFvY99LT/hrd9zqb32Xmv3r923dW99vlH2rfq33m+v
+yj//16/41L9W7v5HZe5rlf31rm2/1v/3nb7/95TJnvt36vJ6P1HM7F/1sT+
WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03s
nzWxf9bE/lkT+2dN7J81cd9qfwNL8s+h
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 45\"", TraditionalForm]], 47->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlcEJwkAUBRdswBK0EnuwBMGzLVuCJRjJbVAwIXnfjTOwTPiXZIddcrzc
ztdda+0wrP2wXs8jj1N7i/PfmH/rOzx3vtR3V80/7auq/9T3bXXey/nf6n2p
6r+U7T+6qnPv92Lt819l+9d6av+q/9S/9Z/bZ22T3vv3ZmL/rIn9syb2z5rY
P2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ
/bMm9s+a2D9rYv+sifOq+ROzsNI/
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 46\"", TraditionalForm]], 48->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztktEJwjAABQMu4Ag6iTs4guC3KzuCI1jx77BCpXlJ6h2UK++jtNccL7fz
dVdKOUzXfrpe928ep/IR9z52+g7/utd+71b73PfW7r/0ff7tf/V2/td6/tLv
abWv1b+2R+88t9c+//b/vo9+/nvbyVb61/5frc7DVvuPZmL/rIn9syb2z5rY
P2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ
/bMm9s+a2D9rYv+sif2zJu6t9ifaCdkZ
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 47\"", TraditionalForm]], 49->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztldEJwjAABQMu4Ag6iTs4guC3KzuCI1jp31ERMXlJ5A7ClQeFcvno8XI7
X3ellMNy9st5Pa88TmUT9zF2+g5/2lt/32j7uw69+tfav/3u0fZa/Vvb/tvv
2f+33f5999n71/pf9LrfWfr3uq/W+7/2n83E/lkT+2dN7J81sX/WxP5ZE/tn
TeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/
1sT+WRP7Z03ce+1PaafQYQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 48\"", TraditionalForm]], 50->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlcEJwkAABA9swBK0EnuwBMG3LVuCJRjxNySPkNzenc5AmLAkcEweOd8e
1/uhlHKaruN0fe6/vC5lFvc+dvoJtz5fb/tSn1b9l57/t+9Yu3/tfe25e9v3
6l/b9p9/z/7b9tH7j/5dRunf239nr330/r9iYv+sif2zJvbPmtg/a2L/rIn9
syb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9syb2z5rY
P2ti/6yJ/bMm7q32N+9+xIs=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 49\"", TraditionalForm]], 51->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwjAABQMu4Ah2EndwBKHfrtwRHMGKf0f7ITYvidxBuPKgUC7Q6f64
zadSymU95/W8nz88r2UT9z52eoFbf19v+14f+7fda/evvX/73b3tR/Wvbftv
v2f/3/bR+4/+fxul/1H30tv9jt7/X0zsnzWxf9bE/lkT+2dN7J81sX/WxP5Z
E/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyf
NbF/1sS91f4CMVbG6Q==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 50\"", TraditionalForm]], 52->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwjAABQNdwBF0EndwhILfruwIHcFK/476IcSXxN5BuPK+wgV6mR+3
+1RKOa/ntJ7398ZyLbu497HTT7j1/XrbP/Wxf9vd/m33X/evtX97v1H2Wv1r
+Wjv0lv/o/3fRu8/+j5K/383sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWx
f9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT
91b7C+U5sds=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 51\"", TraditionalForm]], 53->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwjAABQMu4Ag6iTs4guC3K3cER7Di39EiLelLrHdQTh6Ulov0fHtc
74dSymm8juP1/v3heSmTuPex0wP8bd/6/Xrb5zrU6r/0XJY+b6+7//+2e6v+
nkud+9bac6lzX23/27n01n/r71tv+6/037uJ/bMm9s+a2D9rYv+sif2zJvbP
mtg/a2L/rIn9syb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/
rIn9syb2z5q4t9pfvd2z+Q==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 52\"", TraditionalForm]], 54->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMEJwkAUBRdswBJiJfZgCULOtmwJlmDE26AIsnl/jTMQJjwIhFmSw/ly
mnettWm59sv1uH9yO7aXuI+x01f40772+422v+tg/9p97f693nOre1V/z6vP
c9/+f/xf9Xmut//tXEbrX/V9Ve2/0n/rJvbPmtg/a2L/rIn9syb2z5rYP2ti
/6yJ/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ/bMm
9s+a2D9r4l613wHGP68d
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 53\"", TraditionalForm]], 55->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMEJwkAUBRdswBK0EnuwBMGzLVuCJRjxNhgh8vN21RkIEx4Ywqy6P12O
501rbTdd2+l63D+5HdpL3MfY6Svc+/1G2+f6LH3e3HPs/9le1b/qff5t9/vf
d1/7/9/zer9X9V9qz6Xmc9Ve+3dU9fyqfbT+vc6rt8m39P8VE/tnTeyfNbF/
1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7
Z03snzWxf9bE/lkT+2dN3Hvtd6RYnms=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 54\"", TraditionalForm],
                 ImageCache->GraphicsData["CompressedBitmap", "\<\
eJzt3cuO21Qcx/EzySTjuRRQVy1i0TeAgcIjUCTEOzAqhHaBQKX7yg/ivgOb
SNB12bV+hC7zGCbnZh8nTuKZ8UnOf/qtNLn49rM/f9sZ16N/frp6+ezX369e
Pn969ejJi6s/nz1/+tej7/94sRw0PlJKfVDq6O9HSr+ulm/dwwdVVZUeufnp
B/N0rMpipmYz+5PPF9+awePl40LN80KVy3ejtUlzNV9UX/ea1Cz1c5v5xDxN
VVUWeqh5p38W81wVZfXYvDlrLdBMspx8ls/Vov360i+tY/Ll0kdu9dzCzbsH
dj1+9GserMc3G8L17M26lqqYmXGXHRs/6Vjsg/Utn83aS9+y5eG6B+Mut0Gt
L/1huA4TuxX5cqtcfWZF6bb+wi5xXvZV+NIMON84W1dUa1/wgGaHUt/5xZnt
mLW2ZcNOoL4yY7PueZplfxHu9ZPW/ul2Z/W4XqN6+3bv+quTdi/6YevQ+9TO
Xekp/CHw7kaj3prHE7ehs7pEulwe6Gjz7P/Ve4RzKucqd7PZzTG7RPVWz5X5
bV4sJ3LbNV5btn6rf9SpeRxuWDbw8hLNqGtz5rj17lQUhTl04I7GfRoevUVp
3vnXo93sr1+/HmTYttW9Qxk1+2f7px1qeYlmQAutvAxooZWXAS208jKg3S+t
kX2jR9/vCW7/6WFmOj3s1atK/yyH6Uc7zM6qh+nH9rCsY1jXdLcZFjPDb28W
bO8Q+zK00EILLbTQQgsttNBC+9HTHmvZf/XontdoXbgfG3hXxgD7MrTQQgst
tNBCCy200B48A1po7y7tIJe/qWOkBA4ttOlkQAsttEI2G1pooYUWWmihHYSW
u79p78vQQgsttNBCCy200EKbGu2JeVrrfHWMeCzxqXna2E1sjHwsed+bKJQ3
TXImWvsfPcv99Rp1dCbbVSP3T+36s/Ztw7KetbxjNbLy3d3edp2UYL8le7ut
3RTuuJ+63U33OLkc7PdIaKGFFlpooYX2o6UdpPNR32Fd4Ne9npcODi200EIL
LbTQQgsttNBCC+0haK/9Z8W3AffDso4i9P2/il2F6VvUIYbtoUEatNBCCy20
0EILLbTQQgsttIPQHvzyt++8t8IYYJ13bkd6+zK00EILLbTQQgsttNBCCy20
Na2Yy9/kM+Tuy8lnQAutvAxooZWXAS208jKgPSDtyNIq203Ets+xw8JGU6bd
xU16uiQvlFIVzlpVMJPopkb5XC3ar2/SdyR5pbQrodtJNS3ASlXYVlOmEms9
qbYtpChdaZtxlDNaOdWFhZ6X16ooxYhWDHciMx8rnOgOfaIbh7s+H/x7rwK/
2UKbWga00MrLgBZaeRnc6U0THFpoE8qAFlp5GdBCKy8DWmjlZUALrbwMLn/T
BIcW2oQyoIVWXga00MrLgBZaeRnQQisvg8vfNMGhhTahDGihlZcBLbTyMqCF
Vl4GtNDKy+DyN01waKFNKANaaOVlQAutvAxooZWXMVSbq5luCEO3i8hVmKqu
NldLeV+ksE3SiGrs85iY+GG2Ik0Jeve4st191npe0cknWh3VudrU48o098lz
lbvT26woFee3eJU4DQ6BlQZXpjKmnZI5AVKBKBXY3NVq0vqcd52tFKclfptN
LQNaaOVlQAutvAxoD03L3d09g0MLbUIZ0EIrLwNaaOVlQAutvAxooZWXweVv
muDQQptQBrTQysuAFlp5GdBCKy8DWmjlZXD5myY4tNAmlAEttPIyoIVWXga0
0MrLgBZaeRlc/qYJDi20CWVAC628DGihlZcBLbTyMno0HRm3OluMzOO07t7T
jDMdL+j+ErMQtsvLzHSvsq1FprYbTD5Xi6oKX9N5JFohfGsqs+sXZT1at6Ly
h0XQIMZUYq2/la3PqS2ZW0jYmCxstUQto9XSnq+ymn5bDalAlNPaResY0D/6
wDLHAae2fRfjvP6MqVtZ+QJUax/29HqLVwl+o4U2tQxooZWXAS208jK4w5sm
OLTQJpQBLbTyMqCFVl4GtNDKy4AWWnkZXP6mCQ4ttAllQAutvAxooZWXAS20
8jKghVZeBpe/aYJDC21CGdBCKy8DWmjlZUALrbwMaKGVl8Hlb5rg0EKbUAa0
0MrLgBZaeRnQHpC2swfTuNWDaXWY/hlRkYgV2dSMKayAaytDx5JohXD7eKsZ
08QNC6thpuvVhcm8tm1/whrShSleEW0fmZOgAVapijxXue9BsywNvWbincxO
N7dgMic52+1nSgWiVSBTO/ou+c9333qpqvh8j1gQfpmFNrUMaKGVlwEttPIy
oD00LTd39wwOLbQJZUALrbwMaKGVlwEttPIyoIVWXgaXv2mCQwttQhnQQisv
A1po5WVAC628DGihlZfB5W+a4NBCm1AGtNDKy4AWWnkZ0EIrLwNaaOVl9KQ1
sm/0aC5/9wIOLbQJZUALrbwMaKGVlwHtAWldr56wu5VuQ2I7WxwHw03XC3rA
xCvERWfzKvNe94bx3Uia1/RDilYMu59ndQXqSlSuN5JtT2UqsNbTyh47Z/Wx
42dsmiv5tj7NQihjjDLW3cWakm0qJd3Fop/amvZWjTqntr0XY/0DX5+U+MDf
dyH4pRba1DKghVZeBrTQysuA9tC01/8b5wGGZQMvL9GMa+/Ld2OzoRWdAS20
8jKghVZeBrTQysuAFlp5GZ202y5/6xne3WbUhxs+3bOLNPdq/fet2HuH6hM3
qlrMVe5uHL5fGWXuL9q5VkaZW/CF/SuL92GWvinm78g3dyffrUyiM91NTH8z
f2WS5mt7qnryW2JcmacT1Xw/jbt1qhfvXh+7eAvWuoPnv7dJhV+X9lu46HFr
USc+LrwzW7X+YsHfK++7yAs3zOPotZx0fF3eL7sWkTW+QfmDtdi5XffcsOY7
fMIvWPKFtSt1DS6/04VfD5gFf+wRxqyu7M9u08IldNS4bR5+IdSx0yhUsVMh
WymFfjdtHW07tzhzM7X3tXqdt+wbnbu3OvofaGrtLQ==\
\>"]], 56->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztldEJwlAUxR64gCPoJO7gCILfruwIjmDFv2CVyuXcogmUlAOWkoe6P12O
580YYzdd2+l63D+5HcZL3Nex01e4+/3Wts/1Wfq8uefY/7u9qn/V+/zbbv/e
vev3x3Os+dynnv5fvN+r+i9113lVfU+r9q7+XedV3a3KZG39f93E/lkT+2dN
7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/W
xP5ZE/tnTeyfNbF/1sT+WRP3rv0OiT2SVQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 55\"", TraditionalForm]], 57->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlcEJwkAUBRdswBK0kvRgCYJnW7YESzCSk4NCguv7Cc5AmPBQWCaEHM/X
02XXWjuM1368nvcT96G9xb12vw2vXtv51rp/6mb/2t3+tbv9a/de/XvtS8+/
9f3b/839vsz9/dJzbH3v1X+pt/Je/Pp9r+rf67lU7b1Nqvr/q4n9syb2z5rY
P2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ
/bMm9s+a2D9rYv+sif2zJu5V+wMwl4t7
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 56\"", TraditionalForm]], 58->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztk8EJwkAUBRdswBK0kvRgCYJnW7YESzDiyUEP6vf9iDMQJjxYWCZkuz/u
DqsxxmZ+1vNzfb9xnsZD3Hv303Tvpd1vqfuzbvbv3e3fu9u/d6/qX7W/ev9f
3z89967tX3Ouuv/Svsu3//eu/lXfpWuvNunq/68m9s+a2D9rYv+sif2zJvbP
mtg/a2L/rIn9syb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/
rIn9syb2z5q4d+0XCaKLmw==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 57\"", TraditionalForm]], 59->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlsEJwkAUBRdswBK0kvRgCYJnW7aElJCIJwc9qJ+3G5yBMOFBYJm95Hi+
ni671tphffbrc39/ME/tJe5999v07NHON+r+rpv9++7277vbv+9e1b9q//T8
W99//e5b27/mu+r+o91L1Xmq/n+q+lfdy9b30fr/q4n9syb2z5rYP2ti/6yJ
/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ/bMm9s+a
2D9rYv+sif2zJu699gU9Noa/
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 58\"", TraditionalForm]], 60->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztktEJwjAABQMu4Ag6SXdwBMFvV3YER7Dil4cBo/GlxTsoVx4thGv3x/Ph
tCml7OZrO1/3+wfXqbzEfex+mZ69tPMtda91s//Y3f5j91/3rz3fur97vrXt
vfq37jXbv+29T+3/3+c9+3+3j+rf67usfV9a/381sX/WxP5ZE/tnTeyfNbF/
1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7
Z03snzWxf9bEfdR+A0kejZk=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 59\"", TraditionalForm]], 61->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlVEKgkAABRe6QEeok3iHjhD03ZU7QkfI6KuhJZT1reIMyMgDUUbQ8/V+
uR1KKafxOI7H+/zDcyg/ce+7P4Zvr+351rrXutm/727/vnur/q32qc+/9X3p
/jX7XtpcN9d761zb19Z/6+9l7vdh6n2W8tL/l177P5Ne/fdqYv+sif2zJvbP
mtg/a2L/rIn9syb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/
rIn9syb2z5rYP2ti/6yJe6/9BUhDj/c=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 15},
                     {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 13}}, {{0,
                     12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 10}, {16, 
                    10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0, 7}, {16, 
                    7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 4}, {16, 
                    4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 1}, {16, 
                    1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 60\"", TraditionalForm]], 62->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlVEKgkAABRe6QEeok3iHjhD03ZU7QkfI8KshCWX3rdIMyMgDUUbQ8/V+
uR1KKafxOI7H+3ziOZSvuPfdH8Ont/Z8W93nutm/727/vnut/rX2pc+/9711
/znbv851a23/OtfV7r/397L2+7D0Pq3c+v/Sa/9l0qv/v5rYP2ti/6yJ/bMm
9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ/bMm9s+a2D9r
Yv+sif2zJvbPmtg/a+Lea38Bl/eNuQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 61\"", TraditionalForm]], 63->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwjAABQMu4Ag6SXdwBMFvV3YER7Dil4dBWtKXiHdQrjwoba/Q4/l6
uuxKKYf52M/H8/zFfSofce+736Z3j/Z8o+61bvbvu9u/796qf6t96fP/+r51
/5rt3+a6tbZ/m+ta9++1195z6b72/7D0Plu51f9ttO/+zaRX/381sX/WxP5Z
E/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyf
NbF/1sT+WRP7Z03snzWxf9bEvdf+ACZMlvE=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 62\"", TraditionalForm]], 64->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztldEJwjAABQMu4Ag6SXdwBMFvV3YER7Dil4dFoslLxTsoVx6Uhvto98fz
4bQppezmaztf9/sH16m8xH3sfpmevbbzrXVf6mb/sXur/q322vP/+t67/5Lt
3+Y5+3+3t+pfa79LbZ5r7dr+a/vvfPp9rn1Pun/v/07v/Z3JqP7/amL/rIn9
syb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9syb2z5rY
P2ti/6yJ/bMm9s+a2D9rYv+sifuo/Qa3Xp3r
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 63\"", TraditionalForm]], 65->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMsJwkAABRdswBK0kvRgCYJnW7YESzDiycFPFjcva5iBMPIwuEww++P5
cNqUUnbjtR2v++cH16G8xH3Z/TI8u7fz9bq/62b/Zfe5+/u8Pu+t+rfaa8//
7/uv9019v039fu05/n1v1b/W/i/a3Nfac7/f5n6+tb/bW/+1Pt9vJmvt36uJ
/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ/bMm9s+a
2D9rYv+sif2zJvbPmtg/a2L/rIn9sybuS+0327+b7Q==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 64\"", TraditionalForm]], 66->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztk8EJwkAUBRdswBK0kvRgCYJnW7YESzDiyUEPid+3q8xAmPBgMczi/ng+
nDattd38bOfn/v7gOrWXuPfdL9OzR/u+Ufd33ezfd7d/372q/9J96Xf+6/7p
ubX9vZeac2vtvdScq3bV/6jqfr/9u6P1/5X7rTb51/6jmtg/a2L/rIn9syb2
z5rYP2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9syb2z5rYP2ti
/6yJ/bMm9s+a2D9r4t5rvwGfJpwN
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 65\"", TraditionalForm]], 67->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztkdsJwlAQBS/YgCVoJenBEgS/bdkSLMFIvhx8EIxnr2EGwoQDgTC7P54P
p01rbTc+2/G5v09ch/YU99r9Mjy6t//rdX/Vzf61u/1r96X6z93n/uda92+/
+2Tv8n7/df+l7rLWe1X1r7pXb/u/9K+6Y8pkrf17NbF/1sT+WRP7Z03snzWx
f9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT
+2dN7J81sX/WxL1qvwGsPKDp
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 66\"", TraditionalForm]], 68->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztk8sJAjEABQM2YAlayfZgCYJnW7YES1Dx5OCHaHyJ6wwsIw9WwkTX2/1m
tyilrM7P8vxcPl85TuUu7n33w3Tr0c436v6oW+33tTqP+3vv+ftvu7fqX7vX
nnOu+6fvvbL38nz/dv9W9zLX/12v/q3ua7T7rd1/pf9o99va5N/69zaxf9bE
/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN
7J81sX/WxP5ZE/tnTeyfNbF/1sS9134CpCKjZw==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 67\"", TraditionalForm]], 69->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwjAABQMu4Ag6SXdwBMFvV3YER7Dil4dVqs1LsHdQTh5U4gXcH8+H
06aUshuf7fjcPz+4DuUl7m33y/Ds3s7X6z7Vbe73LXUe9+/eq32ete1L/f/M
3eee81/3X9/7ZO/l/V67/1L3Unuf+p2191b9W7m3e19b/15N7J81sX/WxP5Z
E/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyf
NbF/1sT+WRP7Z03snzWxf9bEvdV+A3MAo8c=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 68\"", TraditionalForm]], 70->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwjAABQMu4Ag6SXdwBMFvV3YER7DSLw9FoulLae+gXHlQCRfweL6e
LrtSymF89uPzfJ+4D+Ut7n332/DqpZ1vqfunbrW/1+o87r99N/d5tra3+v+p
3WvPudb93+++udV9rfUe5+5fey9bu8de/Xt57nus3bfWf6km9s+a2D9rYv+s
if2zJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbP
mtg/a2L/rIn9syb2z5rYP2vi3mt/AG3EqGM=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 69\"", TraditionalForm]], 71->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztk9sJwkAUBRdswBK0kvRgCYLftmwJlmAkXw5GSdycjToDYcKFPJib7I/n
w2lTStn1x7Y/7ucD1648xXnb+aV79Nreb63zsW5T71frfZzPu25sj/4X8+af
Xveuv3t5Pa/Vv9Ze/m2PS/efupdv2WOt57bq38pL73Hu90Z+tf9aTeyfNbF/
1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7
Z03snzWxf9bE/lkT+2dN7J81sX/WxHmr+Q1taLPZ
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 70\"", TraditionalForm]], 72->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztksEJwkAUBRdswBK0kvRgCYJnW7YESzCSk4MiGzdvY5iBMOFDkmV+jufr
6bIrpRzGaz9ez/uJ+1De4rzv/Da8em3nW+v8U7fa97U6j/N5z/n/t5236l87
rz3nVue/PvfNrfa11T0u3b92L/+yx1bf7dW/l5fe41yTrfZfq4n9syb2z5rY
P2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ
/bMm9s+a2D9rYv+sif2zJvbPmjjvNX8AqjSxmw==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 71\"", TraditionalForm]], 73->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwjAABQMu4Ag6SXdwBMFvV3YER7DSLw9FWtPXtN5BOXlQDRfweL6e
LrtSyqF/9v3z/Dxw78pb3Jfdb92rWztfq/unbmO/r9Z53Ke9N/d5/m2v9f8z
dh97zq3uv773zbXua6v3OHf/Wm7tHmv97lr6r+Uep5pstX+rJvbPmtg/a2L/
rIn9syb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9syb2
z5rYP2ti/6yJ/bMm9s+a2D9r4r7U/gA7Sq99
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 72\"", TraditionalForm]], 74->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwjAABQMu4Ag6SXdwBMFvV3YER7Dil4ciqclrrXdQTh60hAu4P54P
p00pZTc+2/G5/35wHcpL3OfdL8Ozl3a+pe7vutV+r9V53Ke91/s8/7a3+v+p
3WvPudb92/c+udV9rfV+e/fv7bnut9X+6/1731ftd6aarLX/Uk3snzWxf9bE
/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN
7J81sX/WxP5ZE/tnTeyfNbF/1sR9rv0GMQ+2dw==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 73\"", TraditionalForm]], 75->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztldEJwjAABQMu4Ag6SXdwBMFvV3YER7Dil4ci0fQl1DsoJw8q4QK6P54P
p00pZTc/2/m5f35wncpL3Pvul+nZo51v1P1dt9rva3Ue9+/eW/o8/7a3+v2p
3WvPudb91/c+udV9rfXel+7fy6Pde6v/395d12pi/6yJ/bMm9s+a2D9rYv+s
if2zJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbP
mtg/a2L/rIn9syb2z5q499pvueq5NQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 74\"", TraditionalForm]], 76->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwjAABQMu4Ag6SXdwBMFvV3YER7DSrx6KRNOXUu+gXHlQCRfweL6e
LrtSymF89uPzfJ+4D+Ul7n332zD32s631v1dt9rfa3Ue9+++W/o8/7a3+v+p
3WvPudX91+8+udW9bPV+l+7f6l62uvfqr+cm9s+a2D9rYv+sif2zJvbPmtg/
a2L/rIn9syb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9
syb2z5rYP2ti/6yJe6/9AcC0tDk=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 75\"", TraditionalForm]], 77->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMsJwkAABRdswBK0kvRgCYJnW7YESzDiKYMfVjdvQ5yBMOFBwjKB7I/n
w2lTStmN13a87vcPrkN5invf/TJMvbTzLXV/1a32fa3O4/7dc3Of59/2Vv+f
2r32nGvdf33uk/0u7/e5+7f6Lmvde/XXUxP7Z03snzWxf9bE/lkT+2dN7J81
sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5Z
E/tnTeyfNbF/1sS9134DAaqvvQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 76\"", TraditionalForm]], 78->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwjAABQMu4Ag6SXdwBMFvV3YER7DiVw8VGpOXgndQrjyoDSf0eL6e
LrtSymG+9vP1vH9xn8pb3Mfut2nprZ1vq/unbmt/r9V53Oue632ef9t7f3/8
Xn3fW/Vvta89/6j3ttp/fa7Wvf/HUe+tPSfp3V8vTeyfNbF/1sT+WRP7Z03s
nzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE
/lkT+2dN7J81sX/WxP5ZE/dR+wMxDrQZ
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 77\"", TraditionalForm]], 79->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlF0KgkAABhe6QEeok3iHjhD03JU7QkfQ8MmhH7TtW6UZkJEPlGUEj+fr
6bIrpRyGaz9cj/uRe1ee4t52v3VTr+18a91fdZv7vlrncV/23K/P8297rf+P
/6Vl+7fPferv93q/1+o/17W+19b3Vv311MT+WRP7Z03snzWxf9bE/lkT+2dN
7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/W
xP5ZE/tnTeyfNXFvtfd/d61f
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 78\"", TraditionalForm]], 80->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlFEKgkAABRe6QEewk3iHjhD43ZU7QkfI8MuhPrT1rdIMyMgDZRnBy+1+
HU6llG68zuP1vp949uUj7m33Rz/33s631/1bt6Xvq3Ue93XPbX2ef9v9/7Td
a/WvtS89/9H3X59b662/41H2Vv313MT+WRP7Z03snzWxf9bE/lkT+2dN7J81
sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5Z
E/tnTeyfNXFvtb8AxHSrAQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 79\"", TraditionalForm]], 81->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMEJwkAUBRdswBK0kvRgCYJnW7YESzDiKYMeVr5vI5mBZcKDhGUOOZ6v
p8uutXaYz34+z+cX96m9xX3sfpuWXtv91rp/6tb7var7uH/33q/vs7W96v9T
tffe/9/3qv69tn/Ne9X9t7aP6q+XJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ
/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ/bMm9s+a
2D9rYv+sifuo/QE+87H7
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 80\"", TraditionalForm]], 82->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMsJwkAABRdswBK0kvRgCYJnW7YESzDiKYMfVjdvQ5yBMOFBwjKB7I/n
w2lTStmN13a87vcPrkN5invf/TJMvbTzLXV/1a32fa3O4/7dc3Of59/2Vv+f
2r32nGvdf33uk/0u7/e5+7f6Lmvde/XXUxP7Z03snzWxf9bE/lkT+2dN7J81
sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5Z
E/tnTeyfNbF/1sS9134DAaqvvQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 81\"", TraditionalForm]], 83->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlFEKgkAABRe6QEewk3iHjhD43ZU7QkfI8MuhPrT1rdIMyMgDZRnBy+1+
HU6llG68zuP1vp949uUj7m33Rz/33s631/1bt6Xvq3Ue93XPbX2ef9v9/7Td
a/WvtS89/9H3X59b662/41H2Vv313MT+WRP7Z03snzWxf9bE/lkT+2dN7J81
sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5Z
E/tnTeyfNXFvtb8AxHSrAQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 82\"", TraditionalForm]], 84->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlFEKgkAABRe6QEewk3iHjhD43ZU7QkfI8MuhPrT1rdIMyMgDZRnBy+1+
HU6llG68zuP1vp949uUj7m33Rz/33s631/1bt6Xvq3Ue93XPbX2ef9v9/7Td
a/WvtS89/9H3X59b662/41H2Vv313MT+WRP7Z03snzWxf9bE/lkT+2dN7J81
sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5Z
E/tnTeyfNXFvtb8AxHSrAQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 83\"", TraditionalForm]], 85->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMsJwkAABRdswBK0kvRgCYJnW7YESzDiKYMfVjdvQ5yBMOFBwjKB7I/n
w2lTStmN13a87vcPrkN5invf/TJMvbTzLXV/1a32fa3O4/7dc3Of59/2Vv+f
2r32nGvdf33uk/0u7/e5+7f6Lmvde/XXUxP7Z03snzWxf9bE/lkT+2dN7J81
sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5Z
E/tnTeyfNbF/1sS9134DAaqvvQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 84\"", TraditionalForm]], 86->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlFEKgkAABRe6QEewk3iHjhD43ZU7QkfI8MuhPrT1rdIMyMgDZRnBy+1+
HU6llG68zuP1vp949uUj7m33Rz/33s631/1bt6Xvq3Ue93XPbX2ef9v9/7Td
a/WvtS89/9H3X59b662/41H2Vv313MT+WRP7Z03snzWxf9bE/lkT+2dN7J81
sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5Z
E/tnTeyfNXFvtb8AxHSrAQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 85\"", TraditionalForm]], 87->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlFEKgkAABRe6QEewk3iHjhD43ZU7QkfI8MuhPrT1rdIMyMgDZRnBy+1+
HU6llG68zuP1vp949uUj7m33Rz/33s631/1bt6Xvq3Ue93XPbX2ef9v9/7Td
a/WvtS89/9H3X59b662/41H2Vv313MT+WRP7Z03snzWxf9bE/lkT+2dN7J81
sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5Z
E/tnTeyfNXFvtb8AxHSrAQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 86\"", TraditionalForm]], 88->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlF0KgkAABhe6QEeok3iHjhD03JU7QkfQ8MmhH7TtW6UZkJEPlGUEj+fr
6bIrpRyGaz9cj/uRe1ee4t52v3VTr+18a91fdZv7vlrncV/23K/P8297rf+P
/6Vl+7fPferv93q/1+o/17W+19b3Vv311MT+WRP7Z03snzWxf9bE/lkT+2dN
7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/W
xP5ZE/tnTeyfNXFvtfd/d61f
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 87\"", TraditionalForm]], 89->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMsJwkAABRdswBK0kvRgCULOtmwJlmAkJ4cIfjZvVzIDYcKDhGUCOZ4v
p3FXSjlM1366Hvczt6Es4t52vw7P7u18ve6vun36vlrncf/uubXPs7Xd/0/b
vVb/tfd3z/dv+6/P1Xar79tq763/Vk3snzWxf9bE/lkT+2dN7J81sX/WxP5Z
E/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyf
NbF/1sT+WRP3VvsdR8utXw==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 88\"", TraditionalForm]], 90->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlFEKgkAABRe6QEewk3iHjhD43ZU7QkfI8MuhPrT1rdIMyMgDZRnBy+1+
HU6llG68zuP1vp949uUj7m33Rz/33s631/1bt6Xvq3Ue93XPbX2ef9v9/7Td
a/WvtS89/9H3X59b662/41H2Vv313MT+WRP7Z03snzWxf9bE/lkT+2dN7J81
sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5Z
E/tnTeyfNXFvtb8AxHSrAQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 89\"", TraditionalForm]], 91->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwjAABQMu4Ag6SXdwBMFvV3YER7Dil4ciqfEl6h2Ukwct8Qrd7o+7
w6qUspmv9Xxdf984T+Uh7n3303Tv0c436v6sW+3zWp3Hfdl9nz7Pv+2tvj9+
l5bt7973qn+vvfb/9Npb9e/l0d577f7t/X/FxP5ZE/tnTeyfNbF/1sT+WRP7
Z03snzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWx
f9bE/lkT+2dN7J81ce+1XwBe7rR5
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 18}}, 
                    {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 15}, {16, 
                    15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 13}}, {{0, 
                    12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 10}, {16, 
                    10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0, 7}, {16, 
                    7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 4}, {16, 
                    4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 1}, {16, 
                    1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 90\"", TraditionalForm]], 92->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlcEJwkAUBRdswBK0kvRgCYJnW7YESzCSk4Me1PX9VWcgTHgQWSYQt/vj
7rBqrW3maz1f1/uF89Tu4l67n6Zbj3a+UfdH3Z79vV7ncX/tuU+f5992vz+1
e6/+37KT6v3d50b1aO+91/9vdddfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN
7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/W
xP5ZE/tnTdyr9gt8w7R5
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 91\"", TraditionalForm]], 93->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwjAABQMu4Ag6SXdwBMFvV3YER7Dil4f9iMaXGu+gXHlQCRdwfzwf
TptSym5+tvNzf39wncpL3Pvul+nZazvfWvelbrW/1+o87u999+3z/Nve6v+n
dq8956h7q/5LbnVfo97vp9/1dq/7bbX/ev9RTOyfNbF/1sT+WRP7Z03snzWx
f9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT
+2dN7J81sX/WxP5ZE/de+w3VB7a3
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 92\"", TraditionalForm]], 94->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlcEJwkAUBRdswBK0kvRgCYJnW7YESzCSk4Me1PX9VWcgTHgQWSYQt/vj
7rBqrW3maz1f1/uF89Tu4l67n6Zbj3a+UfdH3Z79vV7ncX/tuU+f5992vz+1
e6/+37KT6v3d50b1aO+91/9vdddfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN
7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/W
xP5ZE/tnTdyr9gt8w7R5
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 93\"", TraditionalForm]], 95->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwjAABQMu4Ag6SXdwBMFvV3YER7Dil4ciqfEl6h2Ukwct8Qrd7o+7
w6qUspmv9Xxdf984T+Uh7n3303Tv0c436v6sW+3zWp3Hfdl9nz7Pv+2tvj9+
l5bt7973qn+vvfb/9Npb9e/l0d577f7t/X/FxP5ZE/tnTeyfNbF/1sT+WRP7
Z03snzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWx
f9bE/lkT+2dN7J81ce+1XwBe7rR5
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 94\"", TraditionalForm]], 96->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwjAABQNdwBHsJN3BEQS/XbkjOIIVv3woaI2XqHdQrjxoCVfouD/u
DkMpZbtcm+W63F85TeUu7m33ebp1b+frdX/U7dX31TqP+7rnPn2ef9v9/7Td
a/VvtT977l73d5+j3Nt3r7V/S/9fd2J/1on9WSf2Z53Yn3Vif9aJ/Vkn9med
2J91Yn/Wif1ZJ/ZnndifdWJ/1on9WSf2Z53Yn3Vif9aJ/Vkn9med2J91Yn/W
if1ZJ/Znnbi32s+SQ6+9
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 95\"", TraditionalForm]], 97->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlVEKgkAABRe6QEeok3iHjhD03ZU7QkfI6KshkXT3qTUDMvFAWefDjufr
6bIrpRz6a99fz98v7l35iPuy+61799rOt9Z9qNu3z6t1Hvdp97U+z7/ttb4/
fpem7XPvG+u/lX3oPVvvtfq39tj/19znLLVvpf+vm9g/a2L/rIn9syb2z5rY
P2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ
/bMm9s+a2D9rYv+sif2zJu5L7Q8Kw7kV
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 96\"", TraditionalForm]], 98->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlFEKgkAABRe6QEewk3iHjhD43ZU7QkfI8MuhPrT1rdIMyMgDZRnBy+1+
HU6llG68zuP1vp949uUj7m33Rz/33s631/1bt6Xvq3Ue93XPbX2ef9v9/7Td
a/WvtS89/9H3X59b662/41H2Vv313MT+WRP7Z03snzWxf9bE/lkT+2dN7J81
sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5Z
E/tnTeyfNXFvtb8AxHSrAQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 97\"", TraditionalForm]], 99->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlFEKgkAABRe6QEeok3iHjhD03ZU7gkfI8MuhIHV7u9AMyMgDZZ0Pz9f7
5XYopZym6zhdr/uZcShvcW+7P4aleztfr/unbmvfV+s87tue+/V5/m23f9u9
1v+/t/3b72m9731uq9f2rPWe3vZW/fXSxP5ZE/tnTeyfNbF/1sT+WRP7Z03s
nzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE
/lkT+2dN7J81cW+1PwEcHK+d
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 98\"", TraditionalForm]], 100->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztldEJwjAABQMu4Ag6SXdwBMFvV3YER7DSrx5KaUxeC95BOXlQG06o5+v9
cjuUUk7jdRyv9+eJ51A+4r7t/hjm3tv59rp/67b2+1qdx73uvt7n+be91fvH
91Ld/ut9S/17/15bPbfV3qr/WrfqtvS/ln5u7TlJ7/56bmL/rIn9syb2z5rY
P2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ
/bMm9s+a2D9rYv+sif2zJvbPmrhvtb8Acum0OQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 99\"", TraditionalForm]], 101->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwjAABQNdwBHsJN3BEQS/XbkjOIIVv3woaI2XqHdQrjxoCVfouD/u
DkMpZbtcm+W63F85TeUu7m33ebp1b+frdX/U7dX31TqP+7rnPn2ef9vt33av
9f9vtT977l73d5+j3Nt3r7V/S/9fd2J/1on9WSf2Z53Yn3Vif9aJ/Vkn9med
2J91Yn/Wif1ZJ/ZnndifdWJ/1on9WSf2Z53Yn3Vif9aJ/Vkn9med2J91Yn/W
if1ZJ/Znnbi32s+te61/
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 100\"", TraditionalForm]], 102->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMsJwkAABRdswBK0kvRgCULOtmwJlmAkJ4cIfjZvVzIDYcKDhGUCOZ4v
p3FXSjlM1366Hvczt6Es4t52vw7P7u18ve6vun36vlrncf/uubXPs7Xd/m33
Wv//tfd3z/dv+6/P1Xar79tq763/Vk3snzWxf9bE/lkT+2dN7J81sX/WxP5Z
E/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyf
NbF/1sT+WRP3VvsdYwOrIQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 101\"", TraditionalForm]], 103->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwjAABQMu4Ag6SXdwBMFvV3YER7DSLw9Fo+lLqXdQrjxoCVfo/ng+
nDallN14bcfrfj9xHcpT3Pvul+HRSzvfUvdX3Wrf1+o87t89N/d5/m23f9+9
1f+/dq8951r3X59751bfa6373P31Zyb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+s
if2zJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbP
mtg/a2L/rIl7r/0GI5SmZQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 102\"", TraditionalForm]], 104->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwjAABQMu4Ag6SXdwBMFvV3YER7DSLw/FVtOXiHcQrjxoCffR/fF8
OG1KKbvxbMdzf564DuUp7m33y/Do3u7X6/6q29Lv1bqP+2fvrX2ff9vt33av
9f9vtc+9d6/7t++989Ketb7zK/va/fU8E/tnTeyfNbF/1sT+WRP7Z03snzWx
f9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT
+2dN7J81sX/WxL3VfgMEdK0/
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 103\"", TraditionalForm]], 105->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlcEJwkAUBRdswBK0kvRgCYJnW7YESzCSk4NBV9e3C85AGHkQ+cxB98fz
4bQppezmZzs/988L16k8xb3vfpkePdp9o+5r3Wq/r9U97p+99+t7/m23f9+9
1e9/7V5759o+2j21+7fvvXKrPrX7aPe0+v+t7a/fM7F/1sT+WRP7Z03snzWx
f9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT
+2dN7J81sX/WxP5ZE/tnTdx77TcXBq0/
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 104\"", TraditionalForm]], 106->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwjAABQNdwBHsJN3BEQS/XbkjOIIVv3woaI2XqHdQrjxoCVfouD/u
DkMpZbtcm+W63F85TeUu7m33ebp1b+frdX/U7dX31TqP+7rnPn2ef9vt33av
9f9vtT977l73d5+j3Nt3r7V/S/9fd2J/1on9WSf2Z53Yn3Vif9aJ/Vkn9med
2J91Yn/Wif1ZJ/ZnndifdWJ/1on9WSf2Z53Yn3Vif9aJ/Vkn9med2J91Yn/W
if1ZJ/Znnbi32s+te61/
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 105\"", TraditionalForm]], 107->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlFEKgkAABRe6QEeok3iHjhD43ZU7QkfI8KvBCG19bjgDMvJAWUbwfL1d
+kMp5TRcx+F63Y88ujKJ+7b7vXt3a+drdf/Ube77ap3Hfdlza59nb3ut/4//
pWX7r899619rn3u+f9lr9a/ltb9ja3tr/fdqYv+sif2zJvbPmtg/a2L/rIn9
syb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9syb2z5rY
P2ti/6yJ/bMm9s+auG+1PwECzq+9
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 106\"", TraditionalForm]], 108->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlcEJwkAUBRdswBK0kvRgCYJnW7YESzCSk4Me1PX9VWcgTHgQWSYQt/vj
7rBqrW3maz1f1/uF89Tu4l67n6Zbj3a+UfdH3Z79vV7ncX/tuU+f5992+9fu
vb7/37KT6v3d50b1aO+91/9vdddfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN
7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/W
xP5ZE/tnTdyr9guX+7I7
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 23}}, 
                    {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 20}, {16, 
                    20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 18}}, {{0, 
                    17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 15}, {16, 
                    15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 13}}, {{0, 
                    12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 10}, {16, 
                    10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0, 7}, {16, 
                    7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 4}, {16, 
                    4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 1}, {16, 
                    1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 107\"", TraditionalForm]], 109->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMEJwkAABA9swBK0kvRgCYJvW7YESzCSl4M+LiZ7FzIDYWQh8ZhAztf7
5XYopZzG6zhe798Tz6F8xb3t/hg+3dv5et1/dat93lLncZ9339rn2dtu/7b7
Ut//re9k7ve8dv/3vW3Na7/H2v/dW/9eTeyfNbF/1sT+WRP7Z03snzWxf9bE
/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN
7J81sX/WxP5ZE/dW+wv1Cbtz
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 108\"", TraditionalForm]], 110->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMEJwkAUBRdswBK0kvRgCYJnW7YESzCSk4OC0fj+qjMQRh4kbEbIdn/c
HVattc14rcfr+nviPLS7uNfup+HWvZ2v1/1Rt7nPW+o87q/d9+nz/Ntu/9p9
qe9/b/uz71O9v3tftXv73+fu397/V0zsnzWxf9bE/lkT+2dN7J81sX/WxP5Z
E/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyf
NbF/1sT+WRP3qv0CvyOv3Q==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 109\"", TraditionalForm]], 111->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlcEJwkAUBRdswBK0kvRgCYJnW7YESzCSk4Me1PX9VWcgTHgQWSYQt/vj
7rBqrW3maz1f1/uF89Tu4l67n6Zbj3a+UfdH3Z79vV7ncX/tuU+f5992+9fu
vb7/37KT6v3d50b1aO+91/9vdddfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN
7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/W
xP5ZE/tnTdyr9guX+7I7
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 110\"", TraditionalForm]], 112->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMEJwkAUBRdswBK0kvRgCYJnW7YESzCSk4OC0fj+qjMQRh4kbEbIdn/c
HVattc14rcfr+nviPLS7uNfup+HWvZ2v1/1Rt7nPW+o87q/d9+nz/Ntu/9p9
qe9/b/uz71O9v3tftXv73+fu397/V0zsnzWxf9bE/lkT+2dN7J81sX/WxP5Z
E/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyf
NbF/1sT+WRP3qv0CvyOv3Q==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 111\"", TraditionalForm]], 113->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwjAABQNdwBHsJN3BEQS/XbkjOIIVv3woaI2XqHdQrjxoCVfouD/u
DkMpZbtcm+W63F85TeUu7m33ebp1b+frdX/U7dX31TqP+7rnPn2ef9vt33av
9f9vtT977l73d5+j3Nt3r7V/S/9fd2J/1on9WSf2Z53Yn3Vif9aJ/Vkn9med
2J91Yn/Wif1ZJ/ZnndifdWJ/1on9WSf2Z53Yn3Vif9aJ/Vkn9med2J91Yn/W
if1ZJ/Znnbi32s+te61/
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 112\"", TraditionalForm]], 114->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztldEJwjAABQMu4Ag6SXdwBMFvV3YER7Dil4dFo+lLwDsoVx5Ww33U/fF8
OG1KKbv52s7X/f7BdSovce+7X6Znj3a+UfelbrXf1+o87t89t/Z5/m23f9+9
1fu/dl/6vVafb3Wetfdfn3vnVn1q99HO0+r/t7a//szE/lkT+2dN7J81sX/W
xP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tn
TeyfNbF/1sT+WRP7Z03snzVx77XfAMdDr30=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 113\"", TraditionalForm]], 115->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwjAABQMu4Ag6SXdwBMFvV3YER7DSLw9Fo8lLwTsoVx4o6RW6P54P
p00pZTdf2/m63y9cp/IU97H7ZXr02s631v1Vt9r/a3Ue9+9+1/s8/7bbf+ze
6vtfu9eec9Te+3l/fW/v3Or8a9tbPW/v/vozE/tnTeyfNbF/1sT+WRP7Z03s
nzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE
/lkT+2dN7J81sX/WxH3UfgOFGa0/
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 114\"", TraditionalForm]], 116->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMEJwkAABA9swBJiJenBEoS8bdkSLMGILwdFTy97EWcgTFhIcswju8Nx
P21KKcN8befren/jPJaHuPfdT+O913a+te7PutW+r9V53D97bunz/Ntu/757
q///r+yk9/7tc69c26f2Pa2+22tfur9+z8T+WRP7Z03snzWxf9bE/lkT+2dN
7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/W
xP5ZE/tnTeyfNXHvtV8AIemx2w==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 115\"", TraditionalForm]], 117->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwjAABQMu4Ag6SXdwBMFvV3YER7DSLw9Fo+lLqXdQrjxoCVfo/ng+
nDallN14bcfrfj9xHcpT3Pvul+HRSzvfUvdX3Wrf1+o87t89N/d5/m23f9+9
1f+/dq8951r3X59751bfa6373P31Zyb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+s
if2zJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbP
mtg/a2L/rIl7r/0GI5SmZQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 116\"", TraditionalForm]], 118->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlcEJwkAABA9swBJiJenBEoS8bdkSLMGILwfFqOfeSWYgjCxGLvOIu8Nx
P21KKcN8befr+vnGeSwPcW+7n8Z793a+Xvdn3d79vVrncf/svl+fZ227/dvu
td7/ve1Ln6f1/u19tf3qf2rp9/9l763/Wk3snzWxf9bE/lkT+2dN7J81sX/W
xP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tn
TeyfNbF/1sT+WRP3VvsF7xivvQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 117\"", TraditionalForm]], 119->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMEJwkAABA9swBK0kvRgCYJvW7YESzCSVwbz8LzbCzgDYcJCkmMeOV/v
l9uhlHKar+N8ve8XnlP5iPvY/TGtvbfz7XXf6vbt+1qdx73uud7n+bfd/mP3
Vv//VvvWOUZ9t/f+63O17t1z1Hdrz0l699drE/tnTeyfNbF/1sT+WRP7Z03s
nzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE
/lkT+2dN7J81sX/WxH3U/gJNmrHb
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 118\"", TraditionalForm]], 120->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMEJwkAUBRdswBK0kvRgCYJnW7YESzDiycGgq7tvA85AGHlg+Izg/ng+
nDallN38bOfn/vnBdSovcR+7X6Znr+2+te5L3Wrf1+oe9+++1/uef9vtP3Zv
9f9fu9feubSPen+r/dff7Z173z9qb9Whd3/9mYn9syb2z5rYP2ti/6yJ/bMm
9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ/bMm9s+a2D9r
Yv+sif2zJvbPmtg/a+I+ar8BTZ+x2w==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 119\"", TraditionalForm]], 121->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlVEKgkAABRe6QEewk3iHjhD43ZU7QkfI6Kuh0FLfbjQDMvJAWeZDD6fz
cdiVUrrx2o/X/f7BtS8vca+7X/pnt3a+Vvd33T5931rncf/uua3P82+7/evu
a33/a+1zz93qvvS5KU/9d5a+59f3rfvreSb2z5rYP2ti/6yJ/bMm9s+a2D9r
Yv+sif2zJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+sif2z
JvbPmtg/a2L/rIl7rf0G13CtXw==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 120\"", TraditionalForm]], 122->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMEJwkAUBRdswBK0kvRgCULOtmwJlmAkJ4d4UOLbHzIDYcKDhGUCOV9v
l/HQWjtN13G6Xvczj6Et4t53vw/vrna+qvunbt++b63zuP/23L/Ps7fd/n33
tf7/W99J1f58bmuu9t331r+qif2zJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ
/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ/bMm9s+a
2D9r4t5rfwI4A7SZ
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 121\"", TraditionalForm]], 123->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlN0JwjAABgMu4Ag6SXdwBKHPruwIjmClTx4t/hC/RL2DcvJBJZ6Q/fF0
GDellN30bKfn9nnmMpRF3Nvu5+HevZ2v132t26vfV+s87u+99+nz/Ntu/7Z7
rfu/t/3Z35O652vd/3yvtXv73x91XjP5lv6/YmL/rIn9syb2z5rYP2ti/6yJ
/bMm9s+a2D9rYv+sif2zJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ/bMm9s+a
2D9rYv+sif2zJvbPmri32q9BurR5
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 122\"", TraditionalForm]], 124->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMEJwkAUBRdswBK0kvRgCYJnW7YESzCSk4OC0fj+qjMQRh4kbEbIdn/c
HVattc14rcfr+nviPLS7uNfup+HWvZ2v1/1Rt7nPW+o87q/d9+nz/Ntu/9p9
qe9/b/uz71O9v3tftXv73+fu397/V0zsnzWxf9bE/lkT+2dN7J81sX/WxP5Z
E/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyf
NbF/1sT+WRP3qv0CvyOv3Q==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 123\"", TraditionalForm]], 125->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMsJwkAABRdswBK0kvRgCYJnW7YESzCSk4OLJm7eBpyBMOFhfnPweL6e
LrtSymE89uPxPJ+4D+Ut7n332/Dqrb3fVvdat7n3a/U+7suuW/t9/m23f9+9
1f//3L32vFb377XXvqu2/3rdJ7f6rlbPXfv3S7+LtOqvvzOxf9bE/lkT+2dN
7J81sX/WxP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/W
xP5ZE/tnTeyfNbF/1sT+WRP7Z03ce+0P28q41Q==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 124\"", TraditionalForm]], 126->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlNEJwjAABQMu4Ag6SXdwBMFvV3YER7DSLw9Fo+lLqXdQrjxoCVfo/ng+
nDallN14bcfrfj9xHcpT3Pvul+HRSzvfUvdX3Wrf1+o87t89N/d5/m23f9+9
1f+/dq8951r3X59751bfa6373P31Zyb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+s
if2zJvbPmtg/a2L/rIn9syb2z5rYP2ti/6yJ/bMm9s+a2D9rYv+sif2zJvbP
mtg/a2L/rIl7r/0GI5SmZQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 125\"", TraditionalForm]], 127->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztldEJwjAABQMu4Ag6SXdwBMFvV3YER7Dil4elrTYvLd5BOXloCCfo8Xw9
XXallEP/7Pvn+frFvSsfcW+737p3r+1+a92Hus09b6n7uH/3udr3+bfd/m33
pX7/a+9D99v6+b9+b2Me+9+Z+v65+1bOr91fTzOxf9bE/lkT+2dN7J81sX/W
xP5ZE/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tn
TeyfNbF/1sT+WRP7Z03cW+0P4e+4tQ==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 126\"", TraditionalForm]], 128->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztldEJwjAABQMu4Ag6SXdwBMFvV3YER7Dil4dFo+lL1TsoVx5UwhXqdn/c
HVallM14rcfren/jPJSHuPfdT8O9l3a+pe5T3Wp/r9V53N97bu7z/Ntu/757
q+9/7V57zqn92/+PPn3umVu9r1/d5+6vXzOxf9bE/lkT+2dN7J81sX/WxP5Z
E/tnTeyfNbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyf
NbF/1sT+WRP7Z03ce+0XaDGoow==
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 127\"", TraditionalForm]], 129->
                GraphicsBox[{RasterBox[CompressedData["
1:eJztlMEJwkAABA9swBJiJenBEgTftmwJlmDEVwZDYrjsRZyBMLKYcMzjTpfb
+XoopXTDcxye1+83j758xL3tfu/H3tv59rpPdfv2e7XO477uva3P82+7/dvu
te7/VvvSc7e+52vd/3xvrefOs/T/v7LPmWzdX49N7J81sX/WxP5ZE/tnTeyf
NbF/1sT+WRP7Z03snzWxf9bE/lkT+2dN7J81sX/WxP5ZE/tnTeyfNbF/1sT+
WRP7Z03snzWxf9bE/lkT91b7E10Hsfs=
                   "], {{0, 0}, {16, 32}}, {0, 1}], {
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 32}, {16, 32}}, {{0, 31}, {16, 31}}, {{0, 
                    30}, {16, 30}}, {{0, 29}, {16, 29}}, {{0, 28}, {16, 
                    28}}, {{0, 27}, {16, 27}}, {{0, 26}, {16, 26}}, {{0, 
                    25}, {16, 25}}, {{0, 24}, {16, 24}}, {{0, 23}, {16, 
                    23}}, {{0, 22}, {16, 22}}, {{0, 21}, {16, 21}}, {{0, 
                    20}, {16, 20}}, {{0, 19}, {16, 19}}, {{0, 18}, {16, 
                    18}}, {{0, 17}, {16, 17}}, {{0, 16}, {16, 16}}, {{0, 
                    15}, {16, 15}}, {{0, 14}, {16, 14}}, {{0, 13}, {16, 
                    13}}, {{0, 12}, {16, 12}}, {{0, 11}, {16, 11}}, {{0, 
                    10}, {16, 10}}, {{0, 9}, {16, 9}}, {{0, 8}, {16, 8}}, {{0,
                     7}, {16, 7}}, {{0, 6}, {16, 6}}, {{0, 5}, {16, 5}}, {{0, 
                    4}, {16, 4}}, {{0, 3}, {16, 3}}, {{0, 2}, {16, 2}}, {{0, 
                    1}, {16, 1}}, {{0, 0}, {16, 0}}}],
                    Antialiasing->False]}, 
                   {GrayLevel[
                    NCache[-1 + GoldenRatio, 0.6180339887498949]], 
                    
                    StyleBox[
                    LineBox[{{{0, 0}, {0, 32}}, {{1, 0}, {1, 32}}, {{2, 0}, {
                    2, 32}}, {{3, 0}, {3, 32}}, {{4, 0}, {4, 32}}, {{5, 0}, {
                    5, 32}}, {{6, 0}, {6, 32}}, {{7, 0}, {7, 32}}, {{8, 0}, {
                    8, 32}}, {{9, 0}, {9, 32}}, {{10, 0}, {10, 32}}, {{11, 
                    0}, {11, 32}}, {{12, 0}, {12, 32}}, {{13, 0}, {13, 
                    32}}, {{14, 0}, {14, 32}}, {{15, 0}, {15, 32}}, {{16, 
                    0}, {16, 32}}}],
                    Antialiasing->False]}}},
                 Axes->True,
                 AxesLabel->{
                   FormBox["\"x\"", TraditionalForm], 
                   FormBox["\"y\"", TraditionalForm]},
                 Frame->False,
                 FrameLabel->{None, None},
                 FrameTicks->{{None, None}, {None, None}},
                 GridLinesStyle->Directive[
                   GrayLevel[0.5, 0.4]],
                 
                 Method->{
                  "AxisPadding" -> Scaled[0.02], "DefaultBoundaryStyle" -> 
                   Automatic, "DefaultPlotStyle" -> Automatic, 
                   "DomainPadding" -> Scaled[0.02], "RangePadding" -> 
                   Scaled[0.05]},
                 PlotLabel->FormBox["\"t: 128\"", TraditionalForm]]}, 
                Dynamic[$CellContext`i5$$],
                Alignment->Automatic,
                ImageSize->All],
               Identity,
               Editable->True,
               Selectable->True],
              ImageMargins->10],
             Deployed->False,
             StripOnInput->False,
             ScriptLevel->0,
             GraphicsBoxOptions->{PreserveImageOptions->True},
             Graphics3DBoxOptions->{PreserveImageOptions->True}],
            Identity,
            Editable->False,
            Selectable->False],
           Alignment->{Left, Center},
           Background->GrayLevel[1],
           Frame->1,
           FrameStyle->GrayLevel[0, 0.2],
           ItemSize->Automatic,
           StripOnInput->False]}
        },
        AutoDelete->False,
        GridBoxAlignment->{
         "Columns" -> {{Left}}, "ColumnsIndexed" -> {}, "Rows" -> {{Top}}, 
          "RowsIndexed" -> {}},
        GridBoxDividers->{
         "Columns" -> {{False}}, "ColumnsIndexed" -> {}, "Rows" -> {{False}}, 
          "RowsIndexed" -> {}},
        GridBoxItemSize->{"Columns" -> {{Automatic}}, "Rows" -> {{Automatic}}},
        GridBoxSpacings->{"Columns" -> {
            Offset[0.7], {
             Offset[0.5599999999999999]}, 
            Offset[0.7]}, "ColumnsIndexed" -> {}, "Rows" -> {
            Offset[0.4], {
             Offset[0.8]}, 
            Offset[0.4]}, "RowsIndexed" -> {}}], If[
        CurrentValue["SelectionOver"], 
        Manipulate`Dump`ReadControllerState[
         Map[Manipulate`Dump`updateOneVar[#, 
           CurrentValue["PreviousFormatTime"], 
           CurrentValue["CurrentFormatTime"]]& , {
           
           Manipulate`Dump`controllerLink[{$CellContext`i5$$, \
$CellContext`i5$73505$$}, "X1", 
            If["DefaultAbsolute", True, "JB1"], False, {1, 129, 1}, 129, 
            1.]}], 
         CurrentValue[{
          "ControllerData", {
           "Gamepad", "Joystick", "Multi-Axis Controller"}}], {}]],
       ImageSizeCache->{311., {241.75, 248.75}}],
      DefaultBaseStyle->{},
      FrameMargins->{{5, 5}, {5, 5}}],
     BaselinePosition->Automatic,
     ImageMargins->0],
    Deinitialization:>None,
    DynamicModuleValues:>{},
    SynchronousInitialization->True,
    UnsavedVariables:>{Typeset`initDone$$},
    UntrackedVariables:>{Typeset`size$$}], "ListAnimate",
   Deployed->True,
   StripOnInput->False],
  Manipulate`InterpretManipulate[1]]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Dimensions", "[", 
  SubscriptBox["mass", "evolv"], "]"}]], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"129", ",", "16", ",", "32"}], "}"}]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{"cell", " ", "masses"}], " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{"Animate", "[", 
   RowBox[{
    RowBox[{"ListPlot3D", "[", 
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
             SubscriptBox["mass", "evolv"], "\[LeftDoubleBracket]", 
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
      RowBox[{"InterpolationOrder", "\[Rule]", "0"}], ",", 
      RowBox[{"ColorFunction", "\[Rule]", "\"\<TemperatureMap\>\""}], 
      RowBox[{"(*", "\"\<SouthwestColors\>\"", "*)"}], ",", 
      RowBox[{"PlotRange", "\[Rule]", 
       RowBox[{"{", 
        RowBox[{"Automatic", ",", "Automatic", ",", 
         RowBox[{"{", 
          RowBox[{"0", ",", "2.5"}], "}"}]}], "}"}]}], ",", 
      RowBox[{"AxesLabel", "\[Rule]", 
       RowBox[{"{", 
        RowBox[{"\"\<x\>\"", ",", "\"\<y\>\"", ",", "\"\<m\>\""}], "}"}]}], 
      ",", 
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
   DynamicModuleBox[{$CellContext`t$$ = 20, Typeset`show$$ = True, 
    Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{
      Hold[$CellContext`t$$], 0, 128, 1}}, Typeset`size$$ = {
    360., {149., 153.}}, Typeset`update$$ = 0, Typeset`initDone$$, 
    Typeset`skipInitDone$$ = True, $CellContext`t$75255$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, "Variables" :> {$CellContext`t$$ = 0}, 
      "ControllerVariables" :> {
        Hold[$CellContext`t$$, $CellContext`t$75255$$, 0]}, 
      "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> ListPlot3D[
        Flatten[
         Table[{
           Part[
            Subscript[$CellContext`x, $CellContext`list], $CellContext`i], 
           Part[
            Subscript[$CellContext`y, $CellContext`list], $CellContext`j], 
           Part[
            
            Subscript[$CellContext`mass, $CellContext`evolv], \
$CellContext`t$$ + 1, $CellContext`i, $CellContext`j]}, {$CellContext`i, 
           Subscript[$CellContext`dim, 1]}, {$CellContext`j, 
           Subscript[$CellContext`dim, 2]}], 1], InterpolationOrder -> 0, 
        ColorFunction -> "TemperatureMap", 
        PlotRange -> {Automatic, Automatic, {0, 2.5}}, 
        AxesLabel -> {"x", "y", "m"}, PlotLabel -> StringJoin["t: ", 
          ToString[$CellContext`t$$]]], 
      "Specifications" :> {{$CellContext`t$$, 0, 128, 1, AnimationRunning -> 
         False, AppearanceElements -> {
          "ProgressSlider", "PlayPauseButton", "FasterSlowerButtons", 
           "DirectionButton"}}}, 
      "Options" :> {
       ControlType -> Animator, AppearanceElements -> None, DefaultBaseStyle -> 
        "Animate", DefaultLabelStyle -> "AnimateLabel", SynchronousUpdating -> 
        True, ShrinkingDelay -> 10.}, "DefaultOptions" :> {}],
     ImageSizeCache->{411., {186., 193.}},
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
   RowBox[{"velocity", " ", "u"}], " ", "*)"}], "\[IndentingNewLine]", 
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
           SubscriptBox["vel", "evolv"], "\[LeftDoubleBracket]", 
           RowBox[{
            RowBox[{"t", "+", "1"}], ",", "i", ",", "j"}], 
           "\[RightDoubleBracket]"}]}], "}"}], ",", 
        RowBox[{"{", 
         RowBox[{"i", ",", 
          SubscriptBox["dim", "1"]}], "}"}], ",", 
        RowBox[{"{", 
         RowBox[{"j", ",", 
          SubscriptBox["dim", "2"]}], "}"}]}], "]"}], ",", 
      RowBox[{"VectorScale", "\[Rule]", 
       RowBox[{"0.1", 
        RowBox[{"Max", "[", 
         RowBox[{"Flatten", "[", 
          RowBox[{"Map", "[", 
           RowBox[{"Norm", ",", 
            RowBox[{
             SubscriptBox["vel", "evolv"], "\[LeftDoubleBracket]", 
             RowBox[{"t", "+", "1"}], "\[RightDoubleBracket]"}], ",", 
            RowBox[{"{", "2", "}"}]}], "]"}], "]"}], "]"}]}]}], ",", 
      RowBox[{"AxesLabel", "\[Rule]", 
       RowBox[{"{", 
        RowBox[{"\"\<x\>\"", ",", "\"\<y\>\""}], "}"}]}], ",", 
      RowBox[{"PlotRange", "\[Rule]", 
       RowBox[{"{", 
        RowBox[{
         RowBox[{"{", 
          RowBox[{
           RowBox[{"-", "2"}], ",", 
           RowBox[{
            SubscriptBox["dim", "1"], "+", "1"}]}], "}"}], ",", 
         RowBox[{"{", 
          RowBox[{
           RowBox[{"-", "2"}], ",", 
           RowBox[{
            SubscriptBox["dim", "2"], "+", "1"}]}], "}"}]}], "}"}]}], ",", 
      RowBox[{"PlotLabel", "\[Rule]", 
       RowBox[{"\"\<t: \>\"", "<>", 
        RowBox[{"ToString", "[", "t", "]"}]}]}], ",", 
      RowBox[{"VectorStyle", "\[Rule]", "Blue"}]}], "]"}], ",", 
    RowBox[{"{", 
     RowBox[{"t", ",", "0", ",", 
      SubscriptBox["t", "max"], ",", "1"}], "}"}], ",", 
    RowBox[{"AnimationRunning", "\[Rule]", "False"}]}], "]"}]}]], "Input"],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`t$$ = 29, Typeset`show$$ = True, 
    Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{
      Hold[$CellContext`t$$], 0, 128, 1}}, Typeset`size$$ = {
    360., {186., 190.}}, Typeset`update$$ = 0, Typeset`initDone$$, 
    Typeset`skipInitDone$$ = True, $CellContext`t$74518$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, "Variables" :> {$CellContext`t$$ = 0}, 
      "ControllerVariables" :> {
        Hold[$CellContext`t$$, $CellContext`t$74518$$, 0]}, 
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
           Subscript[$CellContext`vel, $CellContext`evolv], $CellContext`t$$ + 
           1, $CellContext`i, $CellContext`j]}, {$CellContext`i, 
          Subscript[$CellContext`dim, 1]}, {$CellContext`j, 
          Subscript[$CellContext`dim, 2]}], VectorScale -> 0.1 Max[
           Flatten[
            Map[Norm, 
             Part[
              
              Subscript[$CellContext`vel, $CellContext`evolv], \
$CellContext`t$$ + 1], {2}]]], AxesLabel -> {"x", "y"}, 
        PlotRange -> {{-2, Subscript[$CellContext`dim, 1] + 1}, {-2, 
           Subscript[$CellContext`dim, 2] + 1}}, PlotLabel -> 
        StringJoin["t: ", 
          ToString[$CellContext`t$$]], VectorStyle -> Blue], 
      "Specifications" :> {{$CellContext`t$$, 0, 128, 1, AnimationRunning -> 
         False, AppearanceElements -> {
          "ProgressSlider", "PlayPauseButton", "FasterSlowerButtons", 
           "DirectionButton"}}}, 
      "Options" :> {
       ControlType -> Animator, AppearanceElements -> None, DefaultBaseStyle -> 
        "Animate", DefaultLabelStyle -> "AnimateLabel", SynchronousUpdating -> 
        True, ShrinkingDelay -> 10.}, "DefaultOptions" :> {}],
     ImageSizeCache->{411., {223., 230.}},
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
   RowBox[{"density", " ", "\[Rho]"}], " ", "*)"}], "\[IndentingNewLine]", 
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
            RowBox[{"Density", "[", 
             RowBox[{
              SubscriptBox["f", "evolv"], "\[LeftDoubleBracket]", 
              RowBox[{
               RowBox[{"t", "+", "1"}], ",", "i", ",", "j"}], 
              "\[RightDoubleBracket]"}], "]"}]}], "}"}], ",", 
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
          RowBox[{"1", "-", "#"}], "]"}], "&"}], ")"}]}], ",", 
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
   DynamicModuleBox[{$CellContext`t$$ = 27, Typeset`show$$ = True, 
    Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{
      Hold[$CellContext`t$$], 0, 128, 1}}, Typeset`size$$ = {
    426., {186., 190.}}, Typeset`update$$ = 0, Typeset`initDone$$, 
    Typeset`skipInitDone$$ = True, $CellContext`t$77571$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, "Variables" :> {$CellContext`t$$ = 0}, 
      "ControllerVariables" :> {
        Hold[$CellContext`t$$, $CellContext`t$77571$$, 0]}, 
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
           $CellContext`Density[
            Part[
             Subscript[$CellContext`f, $CellContext`evolv], $CellContext`t$$ + 
             1, $CellContext`i, $CellContext`j]]}, {$CellContext`i, 
           Subscript[$CellContext`dim, 1]}, {$CellContext`j, 
           Subscript[$CellContext`dim, 2]}], 1], FrameLabel -> {"x", "y"}, 
        PlotLegends -> Automatic, 
        ColorFunction -> (ColorData["DeepSeaColors"][1 - #]& ), PlotLabel -> 
        StringJoin["t: ", 
          ToString[$CellContext`t$$]]], 
      "Specifications" :> {{$CellContext`t$$, 0, 128, 1, AnimationRunning -> 
         False, AppearanceElements -> {
          "ProgressSlider", "PlayPauseButton", "FasterSlowerButtons", 
           "DirectionButton"}}}, 
      "Options" :> {
       ControlType -> Animator, AppearanceElements -> None, DefaultBaseStyle -> 
        "Animate", DefaultLabelStyle -> "AnimateLabel", SynchronousUpdating -> 
        True, ShrinkingDelay -> 10.}, "DefaultOptions" :> {}],
     ImageSizeCache->{477., {223., 230.}},
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
  RowBox[{"(*", " ", "energy", " ", "*)"}], "\[IndentingNewLine]", 
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
            RowBox[{"InternalEnergy", "[", 
             RowBox[{
              SubscriptBox["f", "evolv"], "\[LeftDoubleBracket]", 
              RowBox[{
               RowBox[{"t", "+", "1"}], ",", "i", ",", "j"}], 
              "\[RightDoubleBracket]"}], "]"}]}], "}"}], ",", 
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
          RowBox[{"1", "-", "#"}], "]"}], "&"}], ")"}]}], ",", 
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
   DynamicModuleBox[{$CellContext`t$$ = 43, Typeset`show$$ = True, 
    Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{
      Hold[$CellContext`t$$], 0, 128, 1}}, Typeset`size$$ = {
    420., {186., 190.}}, Typeset`update$$ = 0, Typeset`initDone$$, 
    Typeset`skipInitDone$$ = True, $CellContext`t$79471$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, "Variables" :> {$CellContext`t$$ = 0}, 
      "ControllerVariables" :> {
        Hold[$CellContext`t$$, $CellContext`t$79471$$, 0]}, 
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
           $CellContext`InternalEnergy[
            Part[
             Subscript[$CellContext`f, $CellContext`evolv], $CellContext`t$$ + 
             1, $CellContext`i, $CellContext`j]]}, {$CellContext`i, 
           Subscript[$CellContext`dim, 1]}, {$CellContext`j, 
           Subscript[$CellContext`dim, 2]}], 1], FrameLabel -> {"x", "y"}, 
        PlotLegends -> Automatic, 
        ColorFunction -> (ColorData["DeepSeaColors"][1 - #]& ), PlotLabel -> 
        StringJoin["t: ", 
          ToString[$CellContext`t$$]]], 
      "Specifications" :> {{$CellContext`t$$, 0, 128, 1, AnimationRunning -> 
         False, AppearanceElements -> {
          "ProgressSlider", "PlayPauseButton", "FasterSlowerButtons", 
           "DirectionButton"}}}, 
      "Options" :> {
       ControlType -> Animator, AppearanceElements -> None, DefaultBaseStyle -> 
        "Animate", DefaultLabelStyle -> "AnimateLabel", SynchronousUpdating -> 
        True, ShrinkingDelay -> 10.}, "DefaultOptions" :> {}],
     ImageSizeCache->{471., {223., 230.}},
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
WindowSize->{1433, 827},
WindowMargins->{{Automatic, 264}, {124, Automatic}},
ShowSelection->True,
TrackCellChangeTimes->False,
FrontEndVersion->"10.0 for Microsoft Windows (64-bit) (July 1, 2014)",
StyleDefinitions->"Default.nb"
]
(* End of Notebook Content *)

(* Internal cache information *)
(*CellTagsOutline
CellTagsIndex->{
 "Info3627999368-3712179"->{
  Cell[62638, 1512, 239, 4, 40, "Print",
   CellTags->"Info3627999368-3712179"]}
 }
*)
(*CellTagsIndex
CellTagsIndex->{
 {"Info3627999368-3712179", 491741, 9451}
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
Cell[3255, 88, 826, 29, 31, "Input"],
Cell[CellGroupData[{
Cell[4106, 121, 347, 11, 31, "Input"],
Cell[4456, 134, 249, 5, 195, "Output"]
}, Open  ]],
Cell[4720, 142, 453, 14, 31, "Input"],
Cell[CellGroupData[{
Cell[5198, 160, 269, 7, 72, "Input"],
Cell[5470, 169, 73, 2, 31, "Output"],
Cell[5546, 173, 28, 0, 31, "Output"]
}, Open  ]],
Cell[5589, 176, 1191, 36, 67, "Input"],
Cell[6783, 214, 117, 3, 31, "Input"],
Cell[6903, 219, 816, 24, 46, "Input"],
Cell[7722, 245, 1027, 31, 46, "Input"],
Cell[8752, 278, 893, 27, 46, "Input"],
Cell[CellGroupData[{
Cell[9670, 309, 358, 10, 52, "Input"],
Cell[10031, 321, 33, 0, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[10101, 326, 527, 15, 52, "Input"],
Cell[10631, 343, 119, 4, 31, "Output"]
}, Open  ]],
Cell[10765, 350, 492, 16, 92, "Input"],
Cell[11260, 368, 1146, 30, 72, "Input"]
}, Open  ]],
Cell[CellGroupData[{
Cell[12443, 403, 44, 0, 63, "Section"],
Cell[12490, 405, 189, 6, 52, "Input"],
Cell[12682, 413, 416, 15, 52, "Input"],
Cell[CellGroupData[{
Cell[13123, 432, 3381, 90, 92, "Input"],
Cell[16507, 524, 75, 2, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[16619, 531, 167, 4, 52, "Input"],
Cell[16789, 537, 3447, 63, 266, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[20273, 605, 96, 2, 31, "Input"],
Cell[20372, 609, 2210, 44, 447, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[22619, 658, 1306, 38, 68, "Input"],
Cell[23928, 698, 85, 2, 31, "Output"]
}, Open  ]],
Cell[24028, 703, 447, 14, 52, "Input"],
Cell[CellGroupData[{
Cell[24500, 721, 1437, 39, 72, "Input"],
Cell[25940, 762, 23382, 441, 378, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[49359, 1208, 1159, 33, 52, "Input"],
Cell[50521, 1243, 11134, 220, 376, "Output"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[61704, 1469, 33, 0, 63, "Section"],
Cell[61740, 1471, 123, 4, 31, "Input"],
Cell[61866, 1477, 251, 8, 52, "Input"],
Cell[62120, 1487, 94, 3, 31, "Input"],
Cell[CellGroupData[{
Cell[62239, 1494, 267, 8, 52, "Input"],
Cell[62509, 1504, 30, 0, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[62576, 1509, 59, 1, 31, "Input"],
Cell[62638, 1512, 239, 4, 40, "Print",
 CellTags->"Info3627999368-3712179"]
}, Open  ]],
Cell[62892, 1519, 638, 19, 31, "Input"],
Cell[CellGroupData[{
Cell[63555, 1542, 277, 6, 72, "Input"],
Cell[63835, 1550, 87, 2, 31, "Output"],
Cell[63925, 1554, 97, 2, 31, "Output"],
Cell[64025, 1558, 87, 2, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[64149, 1565, 990, 29, 92, "Input"],
Cell[65142, 1596, 260, 8, 31, "Output"],
Cell[65405, 1606, 260, 8, 31, "Output"],
Cell[65668, 1616, 1152, 28, 72, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[66857, 1649, 1579, 43, 72, "Input"],
Cell[68439, 1694, 5228, 124, 253, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[73704, 1823, 427, 12, 72, "Input"],
Cell[74134, 1837, 97, 2, 31, "Output"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[74280, 1845, 36, 0, 63, "Section"],
Cell[CellGroupData[{
Cell[74341, 1849, 587, 15, 31, "Input"],
Cell[74931, 1866, 397439, 7097, 526, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[472407, 8968, 92, 2, 31, "Input"],
Cell[472502, 8972, 87, 2, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[472626, 8979, 1957, 50, 92, "Input"],
Cell[474586, 9031, 2530, 52, 396, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[477153, 9088, 2388, 64, 92, "Input"],
Cell[479544, 9154, 2714, 56, 470, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[482295, 9215, 1896, 49, 72, "Input"],
Cell[484194, 9266, 2538, 52, 470, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[486769, 9323, 1873, 48, 72, "Input"],
Cell[488645, 9373, 2545, 52, 470, "Output"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[491239, 9431, 27, 0, 63, "Section"],
Cell[491269, 9433, 86, 2, 31, "Input"]
}, Open  ]]
}, Open  ]]
}
]
*)

(* End of internal cache information *)

(* NotebookSignature Cw0LBha1eNF2jBgcx7zxtYxy *)
