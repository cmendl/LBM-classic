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
NotebookDataLength[    111402,       2695]
NotebookOptionsPosition[    107572,       2543]
NotebookOutlinePosition[    108121,       2566]
CellTagsIndexPosition[    108034,       2561]
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

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{
   SubscriptBox["vel", "3"], "=", 
   RowBox[{"{", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"0", ",", "0", ",", "0"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{
       RowBox[{"-", "1"}], ",", "0", ",", "0"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"1", ",", "0", ",", "0"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"0", ",", 
       RowBox[{"-", "1"}], ",", "0"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"0", ",", "1", ",", "0"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"0", ",", "0", ",", 
       RowBox[{"-", "1"}]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"0", ",", "0", ",", "1"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{
       RowBox[{"-", "1"}], ",", 
       RowBox[{"-", "1"}], ",", "0"}], "}"}], ",", "\n", 
     RowBox[{"{", 
      RowBox[{
       RowBox[{"-", "1"}], ",", "1", ",", "0"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"1", ",", 
       RowBox[{"-", "1"}], ",", "0"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"1", ",", "1", ",", "0"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"0", ",", 
       RowBox[{"-", "1"}], ",", 
       RowBox[{"-", "1"}]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"0", ",", 
       RowBox[{"-", "1"}], ",", "1"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"0", ",", "1", ",", 
       RowBox[{"-", "1"}]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"0", ",", "1", ",", "1"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{
       RowBox[{"-", "1"}], ",", "0", ",", 
       RowBox[{"-", "1"}]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{
       RowBox[{"-", "1"}], ",", "0", ",", "1"}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"1", ",", "0", ",", 
       RowBox[{"-", "1"}]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"1", ",", "0", ",", "1"}], "}"}]}], "}"}]}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{"Length", "[", "%", "]"}]}], "Input"],

Cell[BoxData["19"], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Graphics3D", "[", 
  RowBox[{
   RowBox[{"Arrow", "[", 
    RowBox[{
     RowBox[{
      RowBox[{"{", 
       RowBox[{
        RowBox[{"{", 
         RowBox[{"0", ",", "0", ",", "0"}], "}"}], ",", "#"}], "}"}], "&"}], "/@", 
     SubscriptBox["vel", "3"]}], "]"}], ",", 
   RowBox[{"ImageSize", "\[Rule]", "Small"}]}], "]"}]], "Input"],

Cell[BoxData[
 Graphics3DBox[Arrow3DBox[CompressedData["
1:eJxTTMoPymNmYGAQBmImIAaxiQH/gQCbOOMA6fkPBdj0YzOfEYfZjHjcQ0s7
YOrQ1cP46OoZ0eTRxUE0ALv6PaE=
   "]],
  ImageSize->Small]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{
   SubscriptBox["weights", "3"], "=", 
   RowBox[{"Join", "[", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"1", "/", "3"}], "}"}], ",", 
     RowBox[{"ConstantArray", "[", 
      RowBox[{
       RowBox[{"1", "/", "18"}], ",", "6"}], "]"}], ",", 
     RowBox[{"ConstantArray", "[", 
      RowBox[{
       RowBox[{"1", "/", "36"}], ",", "12"}], "]"}]}], "]"}]}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{"Length", "[", "%", "]"}]}], "Input"],

Cell[BoxData["19"], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", "check", " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{"Total", "[", 
    SubscriptBox["vel", "3"], "]"}], "\[IndentingNewLine]", 
   RowBox[{"Total", "[", 
    SubscriptBox["weights", "3"], "]"}]}]}]], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"0", ",", "0", ",", "0"}], "}"}]], "Output"],

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
       SubscriptBox["weights", "3"], "\[LeftDoubleBracket]", "i", 
       "\[RightDoubleBracket]"}], 
      RowBox[{"(", 
       RowBox[{"1", "+", 
        RowBox[{"3", 
         RowBox[{
          RowBox[{
           SubscriptBox["vel", "3"], "\[LeftDoubleBracket]", "i", 
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
             SubscriptBox["vel", "3"], "\[LeftDoubleBracket]", "i", 
             "\[RightDoubleBracket]"}], ".", "u"}], ")"}], "2"]}]}], ")"}]}], 
     ",", 
     RowBox[{"{", 
      RowBox[{"i", ",", 
       RowBox[{"Length", "[", 
        SubscriptBox["weights", "3"], "]"}]}], "}"}]}], "]"}]}]}]], "Input"],

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
           SubscriptBox["vel", "3"], "\[LeftDoubleBracket]", "i", 
           "\[RightDoubleBracket]"}]}], ",", 
         RowBox[{"{", 
          RowBox[{"i", ",", 
           RowBox[{"Length", "[", "f", "]"}]}], "}"}]}], "]"}]}], ",", 
      RowBox[{"{", 
       RowBox[{"0", ",", "0", ",", "0"}], "}"}]}], "]"}]}], "]"}]}]], "Input"],

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
              SubscriptBox["vel", "3"], "\[LeftDoubleBracket]", "i", 
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
             SubscriptBox["vel", "3"], "\[LeftDoubleBracket]", "i", 
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
  RowBox[{"(*", " ", 
   RowBox[{"check", ":", " ", "density"}], " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{"FullSimplify", "[", 
   RowBox[{"Density", "[", 
    RowBox[{"LBMeq", "[", 
     RowBox[{"\[Rho]", ",", 
      RowBox[{"{", 
       RowBox[{
        SubscriptBox["u", "1"], ",", 
        SubscriptBox["u", "2"], ",", 
        SubscriptBox["u", "3"]}], "}"}]}], "]"}], "]"}], "]"}]}]], "Input"],

Cell[BoxData["\[Rho]"], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{"check", ":", " ", 
    RowBox[{"average", " ", "velocity"}]}], " ", "*)"}], 
  "\[IndentingNewLine]", 
  RowBox[{"FullSimplify", "[", 
   RowBox[{
    RowBox[{"Velocity", "[", 
     RowBox[{"LBMeq", "[", 
      RowBox[{"\[Rho]", ",", 
       RowBox[{"{", 
        RowBox[{
         SubscriptBox["u", "1"], ",", 
         SubscriptBox["u", "2"], ",", 
         SubscriptBox["u", "3"]}], "}"}]}], "]"}], "]"}], ",", 
    RowBox[{"Assumptions", "\[RuleDelayed]", 
     RowBox[{"{", 
      RowBox[{"\[Rho]", ">", "0"}], "}"}]}]}], "]"}]}]], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{
   SubscriptBox["u", "1"], ",", 
   SubscriptBox["u", "2"], ",", 
   SubscriptBox["u", "3"]}], "}"}]], "Output"]
}, Open  ]],

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{"cell", " ", "types"}], " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{
    RowBox[{
     SubscriptBox["ct", "obstacle"], "=", 
     SuperscriptBox["2", "0"]}], ";"}], "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{
     SubscriptBox["ct", "fluid"], "=", 
     SuperscriptBox["2", "1"]}], ";"}]}]}]], "Input"]
}, Open  ]],

Cell[CellGroupData[{

Cell["Define initial flow field", "Section"],

Cell[BoxData[{
 RowBox[{
  RowBox[{
   SubscriptBox["dim", "1"], "=", "8"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   SubscriptBox["dim", "2"], "=", "16"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   SubscriptBox["dim", "3"], "=", "32"}], ";"}]}], "Input"],

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
    SubscriptBox["dim", "2"]}]}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   SubscriptBox["z", "list"], "=", 
   RowBox[{
    RowBox[{"Range", "[", 
     RowBox[{"0", ",", 
      RowBox[{
       SubscriptBox["dim", "3"], "-", "1"}]}], "]"}], "/", 
    SubscriptBox["dim", "3"]}]}], ";"}]}], "Input"],

Cell["\<\
For too large density changes or velocities, momentum conservation might not \
hold exactly since the implementation restricts velocities to maximum allowed \
velocity.\
\>", "Text"],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{
   SubscriptBox["f", "0"], "=", 
   RowBox[{"Table", "[", 
    RowBox[{
     RowBox[{"N", "[", 
      RowBox[{"LBMeq", "[", 
       RowBox[{
        RowBox[{"Exp", "[", 
         RowBox[{
          RowBox[{"Sin", "[", 
           RowBox[{"2", "\[Pi]", " ", 
            RowBox[{
             SubscriptBox["x", "list"], "\[LeftDoubleBracket]", "i", 
             "\[RightDoubleBracket]"}]}], "]"}], "+", 
          RowBox[{
           RowBox[{"1", "/", "2"}], 
           RowBox[{"Cos", "[", 
            RowBox[{"2", "\[Pi]", " ", 
             RowBox[{
              SubscriptBox["y", "list"], "\[LeftDoubleBracket]", "j", 
              "\[RightDoubleBracket]"}]}], "]"}]}]}], "]"}], ",", 
        RowBox[{"{", 
         RowBox[{
          RowBox[{
           RowBox[{"Erf", "[", 
            RowBox[{"Cos", "[", 
             RowBox[{"2", "\[Pi]", " ", 
              RowBox[{
               SubscriptBox["y", "list"], "\[LeftDoubleBracket]", "j", 
               "\[RightDoubleBracket]"}]}], "]"}], "]"}], "/", "4"}], ",", 
          RowBox[{
           RowBox[{"-", 
            RowBox[{"(", 
             RowBox[{"1", "+", 
              SuperscriptBox[
               RowBox[{"Cos", "[", 
                RowBox[{"Sin", "[", 
                 RowBox[{"\[Pi]", " ", 
                  RowBox[{
                   SubscriptBox["x", "list"], "\[LeftDoubleBracket]", "i", 
                   "\[RightDoubleBracket]"}]}], "]"}], "]"}], "2"]}], ")"}]}],
            "/", "6"}], ",", 
          FractionBox[
           RowBox[{"1", "/", "3"}], 
           RowBox[{"2", "+", 
            RowBox[{"Sin", "[", 
             RowBox[{
              RowBox[{"4", "\[Pi]", " ", 
               RowBox[{
                SubscriptBox["z", "list"], "\[LeftDoubleBracket]", "k", 
                "\[RightDoubleBracket]"}]}], "+", 
              RowBox[{"\[Pi]", "/", "3"}]}], "]"}]}]]}], "}"}]}], "]"}], 
      "]"}], ",", 
     RowBox[{"{", 
      RowBox[{"i", ",", 
       SubscriptBox["dim", "1"]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"j", ",", 
       SubscriptBox["dim", "2"]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"k", ",", 
       SubscriptBox["dim", "3"]}], "}"}]}], "]"}]}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{"Dimensions", "[", 
  SubscriptBox["f", "0"], "]"}]}], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"8", ",", "16", ",", "32", ",", "19"}], "}"}]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{"initial", " ", "density", " ", "\[Rho]"}], " ", "*)"}], 
  "\[IndentingNewLine]", 
  RowBox[{"Image3D", "[", 
   RowBox[{
    RowBox[{"Table", "[", 
     RowBox[{
      RowBox[{
       RowBox[{"Density", "[", 
        RowBox[{
         SubscriptBox["f", "0"], "\[LeftDoubleBracket]", 
         RowBox[{"i", ",", "j", ",", "k"}], "\[RightDoubleBracket]"}], "]"}], 
       "/", "12"}], ",", 
      RowBox[{"{", 
       RowBox[{"i", ",", 
        SubscriptBox["dim", "1"]}], "}"}], ",", 
      RowBox[{"{", 
       RowBox[{"j", ",", 
        SubscriptBox["dim", "2"]}], "}"}], ",", 
      RowBox[{"{", 
       RowBox[{"k", ",", 
        SubscriptBox["dim", "3"]}], "}"}]}], "]"}], ",", 
    RowBox[{"Boxed", "\[Rule]", "True"}], ",", 
    RowBox[{"Axes", "\[Rule]", "True"}], ",", 
    RowBox[{"AxesLabel", "\[Rule]", 
     RowBox[{"{", 
      RowBox[{"\"\<z\>\"", ",", "\"\<y\>\"", ",", "\"\<x\>\""}], "}"}]}], ",", 
    RowBox[{"BoxRatios", "\[Rule]", 
     RowBox[{"{", 
      RowBox[{"1", ",", "1", ",", "1"}], "}"}]}]}], "]"}]}]], "Input"],

Cell[BoxData[
 Graphics3DBox[
  TagBox[Raster3DBox[CompressedData["
1:eJzlnG1olVUcwFdKraSVIY2pM7XsQ/hB60tf8qESslCDcjNkOu+cbBiYbX1o
ocJG9qKzMGXkag6LG06muNRQa9Mtl7DNoWDs02Rl3krmKGFLbGYL7m7wl8M5
z8s5v7t24fLjnP855wcPPM95e84zq+j1l9dOyMjIyBz5PzDynznyL5k45ci0
mlavVLBEUMZ1lPV0Hsq/tbkw68bVU5FxW8Tt2fYPHpp3uCbWouSQJj7K64bl
/NK2v662p/CvC8cj456Iy9n2L8v793fUyxNU5au4TEHTepQ/889z5Qv2NHl3
J5kJkfIvnf9IQfvgAW9JkjJtm7T/jcSM537/cf9t3KDI17FM055pu678RblX
4gN9DaFZHFE7rv309af99P1H++nnL+2n+1/aT4+/aD89/qb99PyL9s+M3bdl
7Q/nxy0fav7sXOLx/5gt0q7p2l81t3FSf3e3MSsFR/PfMazn12fbf/qpB/f+
Mb9DyXbBNkVcld8u8mU52p9b+fysaZ+3azndZ37UtOV/K2tidby3NcUKkdbl
q6gr79djy2+rnx7y2X9T/tau8nUHn/3GOwWR9k/N/vTX+xecSHG6IXX1dPkq
uvbT15/20/cf7aefv7Sf7n9pPz3+ov30+Jv20/Mv2r+/6WTvrUSPd0DB0Xij
yG8UcZlvSto//Hb3kxvv7PFuaDgsKOM3NXHZjirt2p9/tn7Na/ELXp5gvoK6
+CiXG5aj/T815H49vP18ipdEWhWX5VT5unZof/WbG44f+7vL25qkTEtWa8qp
2vNb3pW/+dauuqxrZ4zZEjCuq0f5r75SkfdYwenIOKBIq/Jpf//mD3O+W9g2
bmn63pzpe3iq8kHfB7Ttp68/Tfr+o/3085f20/0v7afHX7SfHn/Tfnr+Rftd
77c/DO/3Sz+1zpMuDLr+Fnb9Ll3qy/XRoOu0puu4bZr1Wdd+2+v26U7T/ZSo
9l1s068/6v052Z7uvTzaH3TftEXQbzwso/Lr9uNN99FN9/eD0pafvv60n77/
aD/9/KX9dP9Lkx5/0X56/E3Xp+dfNMOe0w96/t50nd62f6yc07Dl1/XDuv45
bJz2685Hqc5T6eJRneOy7Tc9f6c7V6c7b+e3niv//+UcZ1C/q3O3i32eA3bl
153L9psvz1/LtKxH+6nz+ulC+vrTfvr+o/3085f20/0v7afHX7SfHn/Tfnr+
Rfs37/hk41fLm3xzU8C4rp5rf9uOWNXlpkPjlra/60N938fUnzvw8V0vVTSk
OENBGVfVk/l+6drf+fOqm/X3xL2OJLtEulOwQ0PTcqryrv2xyRNWHivcm2KR
SNviakW+a//lddXxsm11zpmAvNL/auW+9R9U1d7GfE3aNl35H+08eyl7y+4U
Z4u0ikHL6eq59tPXn/bT9x/tp5+/tJ/uf2k/Pf6i/fT4m/bT8y+arr6/G4O/
/6vyDy2syHn3t31aDmrSprwesL4tf9/hnMnrV3zpXUyyDyLlL37vSulHd3zh
rUmyOGKatkv5X9yVuFZWXK/kCyK9yLCcLq4r78q/8vtnyn/p351igUiHpd/2
XPsvnvh29tRJNSn2CqriMl9H2a6ufVf+pZtq3y87szNyLhFUxWl/ydNPLF5x
706vNCDHen36+tN++v6j/fTzl/bT/S/tp8dftJ8ef9N+ev5F+8Puw4910usv
NHXv5fldb4v6vUDb/rDrtbbWgV35TdffVfGg6+5+1/9t+U33ZUyp2r9ZrSDt
p/bf0oVR79O6Zli/at98jqBunz1sPcpPX3/aT99/NOnnL+2n+1/aT4+/aD89
/qb99PyL5j+eOz6Z
    "], {{0, 16, 8}, {32, 0, 0}}, {0., 1.},
    ColorFunction->"GrayLevelDefaultColorFunction",
    Method->{"FastRendering" -> True}],
   BoxForm`ImageTag["Real", ColorSpace -> Automatic, Interleaving -> None],
   Selectable->False],
  Axes->True,
  AxesLabel->{"z", "y", "x"},
  AxesStyle->{},
  Background->None,
  BaseStyle->"Image3DGraphics3D",
  BoxRatios->{1, 1, 1},
  Boxed->True,
  ImageSizeRaw->32,
  PlotRange->{{0, 32}, {0, 16}, {0, 8}}]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{"initial", " ", "velocity"}], " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{"ListVectorPlot3D", "[", 
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
           "\[RightDoubleBracket]"}], ",", 
          RowBox[{
           SubscriptBox["z", "list"], "\[LeftDoubleBracket]", "k", 
           "\[RightDoubleBracket]"}]}], "}"}], ",", 
        RowBox[{"Velocity", "[", 
         RowBox[{
          SubscriptBox["f", "0"], "\[LeftDoubleBracket]", 
          RowBox[{"i", ",", "j", ",", "k"}], "\[RightDoubleBracket]"}], 
         "]"}]}], "}"}], ",", 
      RowBox[{"{", 
       RowBox[{"i", ",", 
        SubscriptBox["dim", "1"]}], "}"}], ",", "\[IndentingNewLine]", 
      RowBox[{"{", 
       RowBox[{"j", ",", 
        SubscriptBox["dim", "2"]}], "}"}], ",", 
      RowBox[{"{", 
       RowBox[{"k", ",", 
        SubscriptBox["dim", "3"]}], "}"}]}], "]"}], ",", 
    RowBox[{"AxesLabel", "\[Rule]", 
     RowBox[{"{", 
      RowBox[{"\"\<x\>\"", ",", "\"\<y\>\"", ",", "\"\<z\>\""}], "}"}]}], ",", 
    RowBox[{"VectorPoints", "\[Rule]", "6"}], ",", 
    RowBox[{"VectorScale", "\[Rule]", "Medium"}], ",", 
    RowBox[{"VectorStyle", "\[Rule]", "Blue"}]}], "]"}]}]], "Input"],

Cell[BoxData[
 Graphics3DBox[{{}, 
   {RGBColor[0, 0, 1], 
    {Arrowheads[{{0.03860946715160541, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{-0.02647425022606539, 
      0.04188794005742303, -0.014615341511667056`}, {
      0.02647425022606539, -0.04188794005742303, 0.014615341511667056`}}]}, 
    {Arrowheads[{{0.04153338366704364, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{-0.026474250226065386`, 0.04188794005742304, 
      0.1685869381785193}, {0.026474250226065386`, -0.04188794005742304, 
      0.2189130618214807}}]}, 
    {Arrowheads[{{0.041662922857162256`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{-0.026474250226065393`, 0.04188794005742304, 
      0.3619563842015282}, {0.026474250226065393`, -0.04188794005742304, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.03859519297057971, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{-0.02647425022606539, 0.041887940057423044`, 
      0.5667023194843511}, {0.02647425022606539, -0.041887940057423044`, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.04804351263674848, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{-0.02647425022606538, 0.04188794005742302, 
      0.7340448165342479}, {0.02647425022606538, -0.04188794005742302, 
      0.815955183465752}}]}, 
    {Arrowheads[{{0.0389278929074126, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{-0.02647425022606539, 0.04188794005742302, 
      0.9526933611706918}, {0.02647425022606539, -0.04188794005742302, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.03453465899344656, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{-0.012931673383231711`, 
      0.22938794005742302`, -0.014615341511667053`}, {0.012931673383231711`, 
      0.14561205994257698`, 0.014615341511667053`}}]}, 
    {Arrowheads[{{0.03777530511983444, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{-0.012931673383231708`, 0.22938794005742302`, 
      0.1685869381785193}, {0.012931673383231708`, 0.14561205994257698`, 
      0.2189130618214807}}]}, 
    {Arrowheads[{{0.037917685307315305`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{-0.01293167338323171, 0.22938794005742302`, 
      0.3619563842015282}, {0.01293167338323171, 0.14561205994257698`, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.03451869983789985, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{-0.01293167338323171, 0.22938794005742302`, 
      0.5667023194843511}, {0.01293167338323171, 0.14561205994257698`, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.044834482539002914`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{-0.01293167338323171, 0.22938794005742305`, 
      0.7340448165342479}, {0.01293167338323171, 0.14561205994257695`, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.03489029326723591, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{-0.012931673383231704`, 0.22938794005742302`, 
      0.9526933611706918}, {0.012931673383231704`, 0.14561205994257698`, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.036825935774203275`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.021447342393353122`, 
      0.416887940057423, -0.014615341511667053`}, {-0.021447342393353122`, 
      0.333112059942577, 0.014615341511667053`}}]}, 
    {Arrowheads[{{0.03988082936385219, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.02144734239335312, 0.416887940057423, 
      0.1685869381785193}, {-0.02144734239335312, 0.333112059942577, 
      0.2189130618214807}}]}, 
    {Arrowheads[{{0.04001571857303952, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.021447342393353122`, 0.416887940057423, 
      0.3619563842015282}, {-0.021447342393353122`, 0.3331120599425769, 
      0.4130436157984718}}]}, 
    {Arrowheads[{{0.03681097000013898, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.021447342393353122`, 0.416887940057423, 
      0.5667023194843511}, {-0.021447342393353122`, 0.333112059942577, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.046622287571420826`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.021447342393353122`, 0.416887940057423, 
      0.7340448165342479}, {-0.021447342393353122`, 0.333112059942577, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.037159647981726544`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.021447342393353126`, 0.416887940057423, 
      0.9526933611706918}, {-0.021447342393353126`, 0.3331120599425769, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.038205837748252376`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.02540416076679133, 
      0.604387940057423, -0.014615341511667055`}, {-0.02540416076679133, 
      0.520612059942577, 0.014615341511667055`}}]}, 
    {Arrowheads[{{0.041158438298224305`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.02540416076679133, 0.604387940057423, 
      0.1685869381785193}, {-0.02540416076679133, 0.520612059942577, 
      0.21891306182148074`}}]}, 
    {Arrowheads[{{0.041289153845976805`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.02540416076679133, 0.604387940057423, 
      0.3619563842015282}, {-0.02540416076679133, 0.520612059942577, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.038191412709549954`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.025404160766791337`, 0.604387940057423, 
      0.5667023194843511}, {-0.025404160766791337`, 0.520612059942577, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.04771974634040193, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.025404160766791337`, 0.604387940057423, 
      0.7340448165342479}, {-0.025404160766791337`, 0.520612059942577, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.03852759959465259, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.02540416076679133, 0.604387940057423, 
      0.9526933611706918}, {-0.02540416076679133, 0.520612059942577, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.03315487295516625, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{4.359839578675261*^-19, 
      0.791887940057423, -0.014615341511667055`}, {-4.359839578675261*^-19, 
      0.708112059942577, 0.014615341511667055`}}]}, 
    {Arrowheads[{{0.03651816816019343, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{8.283695199482978*^-20, 0.791887940057423, 
      0.1685869381785193}, {-8.283695199482978*^-20, 0.708112059942577, 
      0.21891306182148074`}}]}, 
    {Arrowheads[{{0.03666543042082242, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{1.4649060984348873`*^-19, 0.791887940057423, 
      0.3619563842015282}, {-1.4649060984348873`*^-19, 0.708112059942577, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.033138249310707434`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{-2.476388880687549*^-19, 0.791887940057423, 
      0.5667023194843511}, {2.476388880687549*^-19, 0.708112059942577, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.043780517966553696`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{-1.7788145480995134`*^-19, 0.791887940057423, 
      0.7340448165342479}, {1.7788145480995134`*^-19, 0.708112059942577, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.03352514717571427, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{2.1799197893376306`*^-19, 0.791887940057423, 
      0.9526933611706918}, {-2.1799197893376306`*^-19, 0.708112059942577, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.038205837748252376`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{-0.025404160766791334`, 
      0.979387940057423, -0.014615341511667055`}, {0.025404160766791334`, 
      0.895612059942577, 0.014615341511667055`}}]}, 
    {Arrowheads[{{0.041158438298224305`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{-0.02540416076679134, 0.979387940057423, 
      0.1685869381785193}, {0.02540416076679134, 0.895612059942577, 
      0.2189130618214807}}]}, 
    {Arrowheads[{{0.041289153845976805`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{-0.02540416076679133, 0.979387940057423, 
      0.3619563842015282}, {0.02540416076679133, 0.895612059942577, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.03819141270954995, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{-0.02540416076679133, 0.979387940057423, 
      0.5667023194843511}, {0.02540416076679133, 0.895612059942577, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.04771974634040193, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{-0.025404160766791334`, 0.979387940057423, 
      0.7340448165342479}, {0.025404160766791334`, 0.895612059942577, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.03852759959465259, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{-0.025404160766791334`, 0.979387940057423, 
      0.9526933611706918}, {0.025404160766791334`, 0.895612059942577, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.03554565385395735, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.1485257497739346, 
      0.03671240583854216, -0.01461534151166706}, {
      0.20147425022606538`, -0.03671240583854216, 0.01461534151166706}}]}, 
    {Arrowheads[{{0.03870173785514421, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.1485257497739346, 0.03671240583854215, 
      0.1685869381785193}, {0.20147425022606538`, -0.03671240583854215, 
      0.21891306182148068`}}]}, 
    {Arrowheads[{{0.038840722124804876`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.14852574977393462`, 0.03671240583854214, 
      0.3619563842015282}, {0.20147425022606535`, -0.03671240583854214, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.035530148812110814`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.1485257497739346, 0.03671240583854215, 
      0.5667023194843511}, {0.20147425022606535`, -0.03671240583854215, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.045617777901294884`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.14852574977393462`, 0.03671240583854214, 
      0.7340448165342479}, {0.20147425022606535`, -0.03671240583854214, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.03589127192487667, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.1485257497739346, 0.03671240583854215, 
      0.9526933611706918}, {0.20147425022606538`, -0.03671240583854215, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.0310716144731505, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.1620683266167683, 
      0.22421240583854216`, -0.014615341511667058`}, {0.18793167338323172`, 
      0.15078759416145784`, 0.014615341511667058`}}]}, 
    {Arrowheads[{{0.03463778617450956, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.1620683266167683, 0.22421240583854216`, 
      0.1685869381785193}, {0.1879316733832317, 0.15078759416145784`, 
      0.2189130618214807}}]}, 
    {Arrowheads[{{0.03479300810851299, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.1620683266167683, 0.22421240583854216`, 
      0.3619563842015282}, {0.1879316733832317, 0.15078759416145784`, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.031053875646583674`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.1620683266167683, 0.22421240583854216`, 
      0.5667023194843511}, {0.1879316733832317, 0.15078759416145784`, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.04222479578061464, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.1620683266167683, 0.22421240583854216`, 
      0.7340448165342479}, {0.1879316733832317, 0.15078759416145784`, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.031466412544937226`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.1620683266167683, 0.22421240583854216`, 
      0.9526933611706918}, {0.1879316733832317, 0.15078759416145784`, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.03359988243759494, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.1964473423933531, 
      0.4117124058385422, -0.014615341511667056`}, {0.15355265760664688`, 
      0.3382875941614578, 0.014615341511667056`}}]}, 
    {Arrowheads[{{0.03692266383839541, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.1964473423933531, 0.4117124058385422, 
      0.1685869381785193}, {0.15355265760664688`, 0.3382875941614578, 
      0.2189130618214807}}]}, 
    {Arrowheads[{{0.03706831918351782, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.1964473423933531, 0.41171240583854213`, 
      0.3619563842015282}, {0.15355265760664688`, 0.3382875941614578, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.033583479071197915`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.1964473423933531, 0.4117124058385422, 
      0.5667023194843511}, {0.15355265760664688`, 0.3382875941614578, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.04411847971731026, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.1964473423933531, 0.41171240583854213`, 
      0.7340448165342479}, {0.15355265760664685`, 0.3382875941614578, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.033965305714806805`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.1964473423933531, 0.41171240583854213`, 
      0.9526933611706918}, {0.15355265760664688`, 0.3382875941614578, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.035106816891029034`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.20040416076679132`, 
      0.5992124058385422, -0.014615341511667053`}, {0.14959583923320866`, 
      0.5257875941614579, 0.014615341511667053`}}]}, 
    {Arrowheads[{{0.03829908089397439, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.20040416076679132`, 0.5992124058385422, 
      0.1685869381785193}, {0.14959583923320866`, 0.5257875941614578, 
      0.2189130618214807}}]}, 
    {Arrowheads[{{0.03843952106219846, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.20040416076679132`, 0.5992124058385422, 
      0.3619563842015282}, {0.14959583923320866`, 0.5257875941614578, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.03509111794921373, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.20040416076679132`, 0.5992124058385422, 
      0.5667023194843511}, {0.14959583923320866`, 0.5257875941614578, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.045276668881077814`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.20040416076679132`, 0.5992124058385422, 
      0.7340448165342479}, {0.14959583923320866`, 0.5257875941614578, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.03545671282987653, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.20040416076679132`, 0.5992124058385422, 
      0.9526933611706918}, {0.14959583923320866`, 0.5257875941614578, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.02953046147366595, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.175, 0.7867124058385422, -0.014615341511667053`}, {0.175, 
      0.7132875941614579, 0.014615341511667053`}}]}, 
    {Arrowheads[{{0.03326227833373143, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.175, 0.7867124058385422, 0.1685869381785193}, {0.175, 
      0.7132875941614579, 0.21891306182148068`}}]}, 
    {Arrowheads[{{0.033423888794073986`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.175, 0.7867124058385422, 0.3619563842015282}, {0.175, 
      0.7132875941614579, 0.4130436157984719}}]}, 
    {Arrowheads[{{0.029511796311865807`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.175, 0.7867124058385422, 0.5667023194843511}, {0.175, 
      0.7132875941614579, 0.5957976805156491}}]}, 
    {Arrowheads[{{0.041103969487072484`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.175, 0.7867124058385422, 0.7340448165342479}, {0.175, 
      0.7132875941614579, 0.8159551834657521}}]}, 
    {Arrowheads[{{0.02994558477184503, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.175, 0.7867124058385422, 0.9526933611706918}, {0.175, 
      0.7132875941614579, 0.9848066388293082}}]}, 
    {Arrowheads[{{0.035106816891029034`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.14959583923320866`, 
      0.9742124058385422, -0.014615341511667055`}, {0.20040416076679132`, 
      0.9007875941614579, 0.014615341511667055`}}]}, 
    {Arrowheads[{{0.03829908089397436, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.14959583923320866`, 0.9742124058385422, 
      0.1685869381785193}, {0.2004041607667913, 0.9007875941614579, 
      0.2189130618214807}}]}, 
    {Arrowheads[{{0.03843952106219846, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.14959583923320866`, 0.9742124058385422, 
      0.3619563842015282}, {0.20040416076679132`, 0.9007875941614578, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.03509111794921373, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.14959583923320866`, 0.9742124058385422, 
      0.5667023194843511}, {0.20040416076679132`, 0.9007875941614578, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.045276668881077765`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.14959583923320866`, 0.9742124058385422, 
      0.7340448165342479}, {0.20040416076679132`, 0.9007875941614579, 
      0.815955183465752}}]}, 
    {Arrowheads[{{0.035456712829876495`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.14959583923320866`, 0.9742124058385422, 
      0.9526933611706918}, {0.20040416076679132`, 0.9007875941614579, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.031448016146173666`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3235257497739346, 
      0.029262230010899795`, -0.01461534151166706}, {
      0.3764742502260654, -0.029262230010899795`, 0.01461534151166706}}]}, 
    {Arrowheads[{{0.034975830578171406`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3235257497739346, 0.029262230010899788`, 
      0.1685869381785193}, {0.3764742502260654, -0.029262230010899788`, 
      0.2189130618214807}}]}, 
    {Arrowheads[{{0.03512955887569548, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.32352574977393456`, 0.029262230010899795`, 
      0.36195638420152815`}, {0.37647425022606534`, -0.029262230010899795`, 
      0.4130436157984718}}]}, 
    {Arrowheads[{{0.03143048975493997, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3235257497739346, 0.02926223001089979, 
      0.5667023194843511}, {0.3764742502260654, -0.02926223001089979, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.04250253959796417, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3235257497739346, 0.02926223001089978, 
      0.7340448165342479}, {0.37647425022606534`, -0.02926223001089978, 
      0.815955183465752}}]}, 
    {Arrowheads[{{0.031838147119612456`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3235257497739346, 0.029262230010899788`, 
      0.9526933611706918}, {0.3764742502260654, -0.029262230010899788`, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.02628553666168415, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3370683266167683, 
      0.21676223001089978`, -0.014615341511667053`}, {0.3629316733832317, 
      0.15823776998910022`, 0.014615341511667053`}}]}, 
    {Arrowheads[{{0.030418094001690713`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3370683266167683, 0.21676223001089978`, 
      0.1685869381785193}, {0.3629316733832317, 0.15823776998910022`, 
      0.2189130618214807}}]}, 
    {Arrowheads[{{0.030594731978948554`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3370683266167683, 0.21676223001089978`, 
      0.3619563842015282}, {0.3629316733832317, 0.15823776998910022`, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.026264565564618227`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3370683266167683, 0.21676223001089978`, 
      0.5667023194843511}, {0.3629316733832317, 0.1582377699891002, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.03883835205488588, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3370683266167683, 0.21676223001089978`, 
      0.7340448165342479}, {0.3629316733832317, 0.15823776998910022`, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.02675106222326189, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3370683266167683, 0.21676223001089978`, 
      0.9526933611706918}, {0.3629316733832317, 0.15823776998910022`, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.029230742574297485`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3714473423933531, 
      0.4042622300108998, -0.014615341511667053`}, {0.32855265760664687`, 
      0.34573776998910016`, 0.014615341511667053`}}]}, 
    {Arrowheads[{{0.03299647430480716, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3714473423933531, 0.4042622300108998, 
      0.1685869381785193}, {0.32855265760664687`, 0.34573776998910016`, 
      0.21891306182148074`}}]}, 
    {Arrowheads[{{0.03315938025228762, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3714473423933531, 0.4042622300108998, 
      0.3619563842015282}, {0.32855265760664687`, 0.3457377699891002, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.029211885905402163`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3714473423933531, 0.4042622300108998, 
      0.5667023194843511}, {0.32855265760664687`, 0.3457377699891002, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.0408891729457978, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3714473423933531, 0.4042622300108998, 
      0.7340448165342479}, {0.32855265760664687`, 0.3457377699891002, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.029650062460725678`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3714473423933531, 0.4042622300108998, 
      0.9526933611706918}, {0.32855265760664687`, 0.3457377699891002, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.030951135744022203`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3754041607667913, 
      0.5917622300108998, -0.014615341511667055`}, {0.3245958392332086, 
      0.5332377699891002, 0.014615341511667055`}}]}, 
    {Arrowheads[{{0.034529752517906055`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3754041607667913, 0.5917622300108998, 
      0.1685869381785193}, {0.3245958392332086, 0.5332377699891002, 
      0.2189130618214807}}]}, 
    {Arrowheads[{{0.03468545791993878, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3754041607667913, 0.5917622300108998, 
      0.3619563842015282}, {0.3245958392332086, 0.5332377699891002, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.03093332782857796, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3754041607667913, 0.5917622300108998, 
      0.5667023194843511}, {0.3245958392332086, 0.5332377699891002, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.04213621905903999, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3754041607667913, 0.5917622300108998, 
      0.7340448165342479}, {0.3245958392332086, 0.5332377699891002, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.031347451193437986`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.3754041607667913, 0.5917622300108998, 
      0.9526933611706918}, {0.3245958392332086, 0.5332377699891002, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.024444475172773025`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.35, 0.7792622300108998, -0.014615341511667051`}, {0.35, 
      0.7207377699891002, 0.014615341511667051`}}]}, 
    {Arrowheads[{{0.02884204173728461, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.35, 0.7792622300108998, 0.1685869381785193}, {0.35, 
      0.7207377699891002, 0.2189130618214807}}]}, 
    {Arrowheads[{{0.029028271628591194`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.35, 0.7792622300108998, 0.3619563842015282}, {0.35, 
      0.7207377699891002, 0.4130436157984719}}]}, 
    {Arrowheads[{{0.024421923208005226`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.35, 0.7792622300108998, 0.5667023194843511}, {0.35, 
      0.7207377699891002, 0.5957976805156491}}]}, 
    {Arrowheads[{{0.03761675848898773, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.35, 0.7792622300108998, 0.7340448165342479}, {0.35, 
      0.7207377699891002, 0.815955183465752}}]}, 
    {Arrowheads[{{0.024944383314734492`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.35, 0.7792622300108998, 0.9526933611706918}, {0.35, 
      0.7207377699891002, 0.9848066388293082}}]}, 
    {Arrowheads[{{0.030951135744022203`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.32459583923320867`, 
      0.9667622300108998, -0.014615341511667051`}, {0.37540416076679134`, 
      0.9082377699891002, 0.014615341511667051`}}]}, 
    {Arrowheads[{{0.03452975251790604, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.32459583923320867`, 0.9667622300108998, 
      0.1685869381785193}, {0.3754041607667913, 0.9082377699891002, 
      0.2189130618214807}}]}, 
    {Arrowheads[{{0.03468545791993878, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.32459583923320867`, 0.9667622300108998, 
      0.3619563842015282}, {0.37540416076679134`, 0.9082377699891002, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.030933327828577953`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.32459583923320867`, 0.9667622300108998, 
      0.5667023194843511}, {0.3754041607667913, 0.9082377699891002, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.04213621905903996, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.32459583923320867`, 0.9667622300108998, 
      0.7340448165342479}, {0.37540416076679134`, 0.9082377699891002, 
      0.815955183465752}}]}, 
    {Arrowheads[{{0.031347451193437986`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.32459583923320867`, 0.9667622300108998, 
      0.9526933611706918}, {0.37540416076679134`, 0.9082377699891002, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.03035526601815455, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.4985257497739345, 
      0.02711743335358689, -0.014615341511667056`}, {
      0.5514742502260653, -0.02711743335358689, 0.014615341511667056`}}]}, 
    {Arrowheads[{{0.03399666425012719, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.49852574977393455`, 0.027117433353586882`, 
      0.1685869381785193}, {0.5514742502260652, -0.027117433353586882`, 
      0.2189130618214807}}]}, 
    {Arrowheads[{{0.03415479998922381, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.4985257497739345, 0.02711743335358688, 
      0.3619563842015282}, {0.5514742502260653, -0.02711743335358688, 
      0.4130436157984718}}]}, 
    {Arrowheads[{{0.030337108328552225`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.49852574977393455`, 0.02711743335358688, 
      0.5667023194843511}, {0.5514742502260652, -0.02711743335358688, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.04170048354371254, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.49852574977393455`, 0.027117433353586885`, 
      0.7340448165342479}, {0.5514742502260652, -0.027117433353586885`, 
      0.815955183465752}}]}, 
    {Arrowheads[{{0.030759259866144594`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.49852574977393455`, 0.027117433353586885`, 
      0.9526933611706918}, {0.5514742502260652, -0.027117433353586885`, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.02496785719871991, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.5120683266167682, 
      0.21461743335358688`, -0.014615341511667051`}, {0.5379316733832316, 
      0.16038256664641312`, 0.014615341511667051`}}]}, 
    {Arrowheads[{{0.02928694074495696, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.5120683266167682, 0.21461743335358688`, 
      0.1685869381785193}, {0.5379316733832316, 0.16038256664641312`, 
      0.21891306182148068`}}]}, 
    {Arrowheads[{{0.02947035935251935, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.5120683266167682, 0.21461743335358688`, 
      0.3619563842015282}, {0.5379316733832316, 0.16038256664641312`, 
      0.4130436157984718}}]}, 
    {Arrowheads[{{0.02494577839637515, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.5120683266167682, 0.21461743335358688`, 
      0.5667023194843511}, {0.5379316733832316, 0.16038256664641312`, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.03795895211728304, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.5120683266167682, 0.21461743335358688`, 
      0.7340448165342479}, {0.5379316733832316, 0.16038256664641312`, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.02545748977365517, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.5120683266167682, 0.21461743335358688`, 
      0.9526933611706918}, {0.5379316733832316, 0.16038256664641312`, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.028051751584308855`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.546447342393353, 
      0.40211743335358685`, -0.01461534151166705}, {0.5035526576066468, 
      0.3478825666464131, 0.01461534151166705}}]}, 
    {Arrowheads[{{0.03195671716635996, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.546447342393353, 0.4021174333535869, 
      0.1685869381785193}, {0.5035526576066468, 0.34788256664641315`, 
      0.21891306182148074`}}]}, 
    {Arrowheads[{{0.0321248961744428, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.546447342393353, 0.4021174333535869, 
      0.3619563842015282}, {0.5035526576066468, 0.34788256664641315`, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.028032101841516645`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.546447342393353, 0.40211743335358685`, 
      0.5667023194843511}, {0.5035526576066468, 0.34788256664641315`, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.04005482392539369, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.546447342393353, 0.4021174333535869, 
      0.7340448165342479}, {0.5035526576066468, 0.34788256664641315`, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.028488430273145307`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.546447342393353, 0.4021174333535869, 
      0.9526933611706918}, {0.5035526576066468, 0.34788256664641315`, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.02984019536376759, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.5504041607667912, 
      0.5896174333535869, -0.01461534151166706}, {0.4995958392332086, 
      0.535382566646413, 0.01461534151166706}}]}, 
    {Arrowheads[{{0.03353756497497646, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.5504041607667912, 0.5896174333535869, 
      0.1685869381785193}, {0.4995958392332086, 0.535382566646413, 
      0.21891306182148074`}}]}, 
    {Arrowheads[{{0.033697855222829406`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.5504041607667912, 0.5896174333535869, 
      0.3619563842015282}, {0.49959583923320855`, 0.5353825666464131, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.029821724062387846`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.5504041607667912, 0.5896174333535869, 
      0.5667023194843511}, {0.4995958392332086, 0.5353825666464131, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.041327054239255104`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.5504041607667912, 0.5896174333535869, 
      0.7340448165342479}, {0.4995958392332086, 0.535382566646413, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.030251068606379883`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.5504041607667912, 0.5896174333535869, 
      0.9526933611706918}, {0.4995958392332086, 0.5353825666464131, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.02302165984405217, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.5249999999999999, 
      0.7771174333535869, -0.014615341511667056`}, {0.5249999999999999, 
      0.7228825666464131, 0.014615341511667056`}}]}, 
    {Arrowheads[{{0.027646479469874575`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.5249999999999999, 0.7771174333535869, 
      0.1685869381785193}, {0.5249999999999999, 0.722882566646413, 
      0.2189130618214807}}]}, 
    {Arrowheads[{{0.027840707772005386`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.5249999999999999, 0.7771174333535869, 
      0.3619563842015282}, {0.5249999999999999, 0.722882566646413, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.0229977126836699, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.5249999999999999, 0.7771174333535869, 
      0.5667023194843511}, {0.5249999999999999, 0.7228825666464131, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.036708105027660594`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.5249999999999999, 0.7771174333535869, 
      0.7340448165342479}, {0.5249999999999999, 0.7228825666464131, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.02355178792481228, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.5249999999999999, 0.7771174333535869, 
      0.9526933611706918}, {0.5249999999999999, 0.722882566646413, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.02984019536376763, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.49959583923320855`, 
      0.9646174333535869, -0.01461534151166706}, {0.5504041607667913, 
      0.910382566646413, 0.01461534151166706}}]}, 
    {Arrowheads[{{0.033537564974976494`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.49959583923320855`, 0.9646174333535869, 
      0.1685869381785193}, {0.5504041607667913, 0.910382566646413, 
      0.21891306182148074`}}]}, 
    {Arrowheads[{{0.03369785522282939, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.4995958392332086, 0.9646174333535869, 
      0.3619563842015282}, {0.5504041607667912, 0.9103825666464131, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.029821724062387846`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.4995958392332086, 0.9646174333535869, 
      0.5667023194843511}, {0.5504041607667912, 0.9103825666464131, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.04132705423925512, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.49959583923320855`, 0.9646174333535869, 
      0.7340448165342479}, {0.5504041607667913, 0.9103825666464131, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.030251068606379883`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.4995958392332086, 0.9646174333535869, 
      0.9526933611706918}, {0.5504041607667912, 0.9103825666464131, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.0323599023484065, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.6735257497739345, 
      0.030991285875029605`, -0.014615341511667062`}, {
      0.7264742502260654, -0.030991285875029605`, 0.014615341511667062`}}]}, 
    {Arrowheads[{{0.03579796481786853, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.6735257497739345, 0.030991285875029605`, 
      0.1685869381785193}, {0.7264742502260653, -0.030991285875029605`, 
      0.2189130618214807}}]}, 
    {Arrowheads[{{0.03594817752361527, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.6735257497739345, 0.030991285875029598`, 
      0.36195638420152815`}, {0.7264742502260653, -0.030991285875029598`, 
      0.4130436157984718}}]}, 
    {Arrowheads[{{0.0323428701061577, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.6735257497739345, 0.0309912858750296, 
      0.5667023194843511}, {0.7264742502260653, -0.0309912858750296, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.04318160989061106, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.6735257497739345, 0.030991285875029594`, 
      0.7340448165342479}, {0.7264742502260653, -0.030991285875029594`, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.03273916878111737, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.6735257497739345, 0.0309912858750296, 
      0.9526933611706918}, {0.7264742502260653, -0.0309912858750296, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.027369965255022638`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.6870683266167682, 
      0.2184912858750296, -0.014615341511667058`}, {0.7129316733832316, 
      0.1565087141249704, 0.014615341511667058`}}]}, 
    {Arrowheads[{{0.03135994265243634, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.6870683266167682, 0.21849128587502958`, 
      0.1685869381785193}, {0.7129316733832316, 0.1565087141249704, 
      0.21891306182148068`}}]}, 
    {Arrowheads[{{0.03153130484664568, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.6870683266167682, 0.2184912858750296, 
      0.3619563842015282}, {0.7129316733832316, 0.15650871412497042`, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.027349825680733922`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.6870683266167682, 0.21849128587502958`, 
      0.5667023194843511}, {0.7129316733832316, 0.15650871412497042`, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.03958033793195383, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.6870683266167682, 0.2184912858750296, 
      0.7340448165342479}, {0.7129316733832316, 0.1565087141249704, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.027817348733141938`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.6870683266167682, 0.2184912858750296, 
      0.9526933611706918}, {0.7129316733832316, 0.15650871412497042`, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.03020963210489744, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.7214473423933531, 
      0.4059912858750296, -0.014615341511667055`}, {0.6785526576066468, 
      0.3440087141249704, 0.014615341511667055`}}]}, 
    {Arrowheads[{{0.033866692738090065`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.7214473423933531, 0.4059912858750296, 
      0.1685869381785193}, {0.6785526576066468, 0.34400871412497036`, 
      0.21891306182148074`}}]}, 
    {Arrowheads[{{0.03402543253485847, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.7214473423933531, 0.4059912858750296, 
      0.3619563842015282}, {0.6785526576066468, 0.3440087141249704, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.03019138682834292, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.7214473423933531, 0.4059912858750296, 
      0.5667023194843511}, {0.6785526576066468, 0.34400871412497036`, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.0415945912909331, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.7214473423933531, 0.4059912858750296, 
      0.7340448165342479}, {0.6785526576066468, 0.34400871412497036`, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.030615547755892557`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.7214473423933531, 0.4059912858750296, 
      0.9526933611706918}, {0.6785526576066468, 0.3440087141249704, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.031877238969416584`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.7254041607667913, 
      0.5934912858750296, -0.014615341511667053`}, {0.6745958392332086, 
      0.5315087141249705, 0.014615341511667053`}}]}, 
    {Arrowheads[{{0.03536225911075595, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.7254041607667913, 0.5934912858750296, 
      0.1685869381785193}, {0.6745958392332086, 0.5315087141249705, 
      0.2189130618214807}}]}, 
    {Arrowheads[{{0.03551431474186496, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.7254041607667913, 0.5934912858750296, 
      0.3619563842015282}, {0.6745958392332086, 0.5315087141249705, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.031859948697678074`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.7254041607667913, 0.5934912858750296, 
      0.5667023194843511}, {0.6745958392332086, 0.5315087141249705, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.042821098970715454`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.7254041607667913, 0.5934912858750296, 
      0.7340448165342479}, {0.6745958392332086, 0.5315087141249705, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.03226217997583826, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.7254041607667913, 0.5934912858750296, 
      0.9526933611706918}, {0.6745958392332086, 0.5315087141249705, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.025606989806315, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.7, 0.7809912858750296, -0.014615341511667051`}, {0.7, 
      0.7190087141249705, 0.014615341511667051`}}]}, 
    {Arrowheads[{{0.029833687871995838`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.7, 0.7809912858750296, 0.1685869381785193}, {0.7, 
      0.7190087141249705, 0.21891306182148074`}}]}, 
    {Arrowheads[{{0.0300137654120851, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.7, 0.7809912858750296, 0.3619563842015282}, {0.7, 
      0.7190087141249705, 0.4130436157984719}}]}, 
    {Arrowheads[{{0.02558546254508813, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.7, 0.7809912858750296, 0.5667023194843511}, {0.7, 
      0.7190087141249705, 0.5957976805156491}}]}, 
    {Arrowheads[{{0.03838236678068768, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.7, 0.7809912858750296, 0.7340448165342479}, {0.7, 
      0.7190087141249705, 0.8159551834657521}}]}, 
    {Arrowheads[{{0.026084628029182398`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.7, 0.7809912858750296, 0.9526933611706918}, {0.7, 
      0.7190087141249705, 0.9848066388293082}}]}, 
    {Arrowheads[{{0.031877238969416584`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.6745958392332086, 
      0.9684912858750296, -0.014615341511667058`}, {0.7254041607667913, 
      0.9065087141249705, 0.014615341511667058`}}]}, 
    {Arrowheads[{{0.03536225911075595, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.6745958392332086, 0.9684912858750296, 
      0.1685869381785193}, {0.7254041607667913, 0.9065087141249705, 
      0.2189130618214807}}]}, 
    {Arrowheads[{{0.03551431474186496, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.6745958392332086, 0.9684912858750296, 
      0.3619563842015282}, {0.7254041607667913, 0.9065087141249705, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.0318599486976781, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.6745958392332086, 0.9684912858750296, 
      0.5667023194843511}, {0.7254041607667913, 0.9065087141249704, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.042821098970715454`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.6745958392332086, 0.9684912858750296, 
      0.7340448165342479}, {0.7254041607667913, 0.9065087141249705, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.03226217997583826, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.6745958392332086, 0.9684912858750296, 
      0.9526933611706918}, {0.7254041607667913, 0.9065087141249705, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.036862101676784956`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8485257497739346, 
      0.03896759918146159, -0.014615341511667058`}, {
      0.9014742502260653, -0.03896759918146159, 0.014615341511667058`}}]}, 
    {Arrowheads[{{0.03991422735231867, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8485257497739346, 0.038967599181461594`, 
      0.1685869381785193}, {0.9014742502260653, -0.038967599181461594`, 
      0.2189130618214807}}]}, 
    {Arrowheads[{{0.04004900407376678, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8485257497739346, 0.03896759918146159, 
      0.3619563842015282}, {0.9014742502260653, -0.03896759918146159, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.036847150591803164`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8485257497739346, 0.038967599181461594`, 
      0.5667023194843511}, {0.9014742502260653, -0.038967599181461594`, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.04665085950736759, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8485257497739346, 0.03896759918146159, 
      0.7340448165342479}, {0.9014742502260653, -0.03896759918146159, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.03719548941081056, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8485257497739346, 0.03896759918146159, 
      0.9526933611706918}, {0.9014742502260653, -0.03896759918146159, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.0325694067814011, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8620683266167682, 
      0.2264675991814616, -0.014615341511667055`}, {0.8879316733832316, 
      0.1485324008185384, 0.014615341511667055`}}]}, 
    {Arrowheads[{{0.035987459804705954`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8620683266167682, 0.2264675991814616, 
      0.1685869381785193}, {0.8879316733832316, 0.1485324008185384, 
      0.2189130618214807}}]}, 
    {Arrowheads[{{0.03613688483202905, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8620683266167682, 0.2264675991814616, 
      0.3619563842015282}, {0.8879316733832316, 0.1485324008185384, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.03255248415709258, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8620683266167682, 0.2264675991814616, 
      0.5667023194843511}, {0.8879316733832316, 0.1485324008185384, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.043338832596631974`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8620683266167682, 0.2264675991814616, 
      0.7340448165342479}, {0.8879316733832316, 0.1485324008185384, 
      0.815955183465752}}]}, 
    {Arrowheads[{{0.03294626155685138, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8620683266167682, 0.2264675991814616, 
      0.9526933611706918}, {0.8879316733832316, 0.1485324008185384, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.03498961462983667, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8964473423933531, 
      0.4139675991814616, -0.01461534151166705}, {0.8535526576066469, 
      0.3360324008185384, 0.01461534151166705}}]}, 
    {Arrowheads[{{0.03819167627962186, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8964473423933531, 0.4139675991814616, 
      0.1685869381785193}, {0.8535526576066469, 0.3360324008185384, 
      0.21891306182148068`}}]}, 
    {Arrowheads[{{0.03833250995193814, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8964473423933531, 0.4139675991814616, 
      0.3619563842015282}, {0.8535526576066469, 0.3360324008185384, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.03497386307873163, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8964473423933531, 0.4139675991814616, 
      0.5667023194843511}, {0.8535526576066469, 0.3360324008185384, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.04518585270514431, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8964473423933531, 0.4139675991814616, 
      0.7340448165342479}, {0.8535526576066469, 0.3360324008185384, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.03534067096737933, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8964473423933531, 0.4139675991814616, 
      0.9526933611706918}, {0.8535526576066469, 0.3360324008185384, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.0364391221675896, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.9004041607667913, 
      0.6014675991814615, -0.014615341511667056`}, {0.8495958392332087, 
      0.5235324008185385, 0.014615341511667056`}}]}, 
    {Arrowheads[{{0.03952392477281919, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.9004041607667913, 0.6014675991814615, 
      0.1685869381785193}, {0.8495958392332087, 0.5235324008185385, 
      0.2189130618214807}}]}, 
    {Arrowheads[{{0.03966002788218227, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.9004041607667913, 0.6014675991814615, 
      0.3619563842015282}, {0.8495958392332087, 0.5235324008185385, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.03642399746115062, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.9004041607667913, 0.6014675991814615, 
      0.5667023194843511}, {0.8495958392332087, 0.5235324008185385, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.046317359349287573`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.9004041607667913, 0.6014675991814615, 
      0.7340448165342479}, {0.8495958392332087, 0.5235324008185385, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.03677634452776141, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.9004041607667913, 0.6014675991814615, 
      0.9526933611706918}, {0.8495958392332087, 0.5235324008185385, 
      0.9848066388293082}}]}, 
    {Arrowheads[{{0.03110255917078124, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.875, 0.7889675991814615, -0.014615341511667055`}, {0.875, 
      0.7110324008185385, 0.014615341511667055`}}]}, 
    {Arrowheads[{{0.03466554762404452, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.875, 0.7889675991814615, 0.1685869381785193}, {0.875, 
      0.7110324008185385, 0.21891306182148068`}}]}, 
    {Arrowheads[{{0.03482064580450664, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.875, 0.7889675991814616, 0.3619563842015282}, {0.875, 
      0.7110324008185385, 0.4130436157984718}}]}, 
    {Arrowheads[{{0.031084838003073757`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.875, 0.7889675991814615, 0.5667023194843511}, {0.875, 
      0.7110324008185384, 0.5957976805156491}}]}, 
    {Arrowheads[{{0.04224757199790856, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.875, 0.7889675991814615, 0.7340448165342479}, {0.875, 
      0.7110324008185384, 0.8159551834657521}}]}, 
    {Arrowheads[{{0.03149696936932245, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.875, 0.7889675991814615, 0.9526933611706918}, {0.875, 
      0.7110324008185385, 0.9848066388293082}}]}, 
    {Arrowheads[{{0.036439122167589634`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8495958392332087, 
      0.9764675991814616, -0.014615341511667056`}, {0.9004041607667913, 
      0.8985324008185385, 0.014615341511667056`}}]}, 
    {Arrowheads[{{0.03952392477281923, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8495958392332087, 0.9764675991814616, 
      0.1685869381785193}, {0.9004041607667913, 0.8985324008185385, 
      0.2189130618214807}}]}, 
    {Arrowheads[{{0.03966002788218227, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8495958392332087, 0.9764675991814615, 
      0.3619563842015282}, {0.9004041607667913, 0.8985324008185385, 
      0.4130436157984719}}]}, 
    {Arrowheads[{{0.03642399746115066, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8495958392332087, 0.9764675991814616, 
      0.5667023194843511}, {0.9004041607667913, 0.8985324008185385, 
      0.5957976805156491}}]}, 
    {Arrowheads[{{0.046317359349287594`, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8495958392332087, 0.9764675991814616, 
      0.7340448165342479}, {0.9004041607667913, 0.8985324008185385, 
      0.8159551834657521}}]}, 
    {Arrowheads[{{0.03677634452776141, 1.}}, Appearance -> "Projected"], 
     Arrow3DBox[{{0.8495958392332087, 0.9764675991814615, 
      0.9526933611706918}, {0.9004041607667913, 0.8985324008185385, 
      0.9848066388293082}}]}}},
  Axes->True,
  AxesLabel->{
    FormBox["\"x\"", TraditionalForm], 
    FormBox["\"y\"", TraditionalForm], 
    FormBox["\"z\"", TraditionalForm]},
  BoxRatios->{1, 1, 1},
  DisplayFunction->Identity,
  FaceGridsStyle->Automatic,
  Method->{
   "DefaultBoundaryStyle" -> Automatic, "TransparentPolygonMesh" -> True},
  PlotRange->{{-0.06428695435311896, 
   0.9392869543531189}, {-0.06428695435311896, 
   1.001786954353119}, {-0.06428695435311896, 1.033036954353119}},
  PlotRangePadding->{
    Scaled[0.02], 
    Scaled[0.02], 
    Scaled[0.02]},
  Ticks->{Automatic, Automatic, Automatic}]], "Output"]
}, Open  ]],

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
       SubscriptBox["dim", "2"], ",", 
       SubscriptBox["dim", "3"]}], "}"}]}], "]"}]}], ";"}]], "Input"],

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
   ";"}]}]], "Input"]
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
     RowBox[{"0", ",", "0", ",", "0"}], "}"}]}], ";"}]}]], "Input"],

Cell[BoxData[
 RowBox[{
  RowBox[{
   SubscriptBox["t", "max"], "=", "64"}], ";"}]], "Input"],

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

Cell[BoxData["65"], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"?", "LatticeBoltzmann"}]], "Input"],

Cell[BoxData[
 StyleBox["\<\"LatticeBoltzmann[omega_Real, numsteps_Integer, gravity_List, \
f0_List, type0_List] runs a Lattice Boltzmann Method (LBM) simulation\"\>", 
  "MSG"]], "Print", "PrintUsage",
 CellTags->"Info3627999695-9481541"]
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
  RowBox[{"65", ",", "8", ",", "16", ",", "32"}], "}"}]], "Output"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"65", ",", "8", ",", "16", ",", "32", ",", "19"}], "}"}]], "Output"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"65", ",", "8", ",", "16", ",", "32"}], "}"}]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{"fluid", " ", "cells", " ", "only"}], " ", "*)"}], 
  "\[IndentingNewLine]", 
  RowBox[{"Norm", "[", 
   RowBox[{"Flatten", "[", 
    RowBox[{
     SubscriptBox["type", "evolv"], "-", "2"}], "]"}], "]"}]}]], "Input"],

Cell[BoxData["0"], "Output"]
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
     RowBox[{"1", ",", "2"}], "}"}], ",", 
    RowBox[{"{", 
     RowBox[{"6", ",", "7"}], "}"}], ",", 
    RowBox[{"{", 
     RowBox[{"5", ",", "6"}], "}"}], ",", "2"}], 
   "\[RightDoubleBracket]"}]}]], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{
   RowBox[{"{", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"0.0522809699177742`", ",", "0.05227513611316681`"}], "}"}], 
     ",", 
     RowBox[{"{", 
      RowBox[{"0.05176486819982529`", ",", "0.051748234778642654`"}], "}"}]}],
     "}"}], ",", 
   RowBox[{"{", 
    RowBox[{
     RowBox[{"{", 
      RowBox[{"0.0527016818523407`", ",", "0.05269227921962738`"}], "}"}], 
     ",", 
     RowBox[{"{", 
      RowBox[{"0.05217909440398216`", ",", "0.05215897411108017`"}], "}"}]}], 
    "}"}]}], "}"}]], "Output"]
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
        RowBox[{"t", "+", "1"}], ",", "i", ",", "j", ",", "k"}], 
       "\[RightDoubleBracket]"}], "]"}], ",", 
     RowBox[{"{", 
      RowBox[{"t", ",", "0", ",", 
       SubscriptBox["t", "max"]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"i", ",", 
       SubscriptBox["dim", "1"]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"j", ",", 
       SubscriptBox["dim", "2"]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"k", ",", 
       SubscriptBox["dim", "3"]}], "}"}]}], "]"}]}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{"Dimensions", "[", "%", "]"}]}], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"65", ",", "8", ",", "16", ",", "32"}], "}"}]], "Output"]
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
       RowBox[{"2", ",", "4"}], "}"}]}], "]"}], ";"}], "\[IndentingNewLine]", 
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
1:eJxVz01I03Ecx/FfZTCMHpDAlR0ySiSdtTl1Vv43Td1SWxYiGIW1ni4Naz5s
OYt1KII6BAV6i0IPC/Og1LFwEJaXKBE1FIoKJBpIgfRAD36+fj+HfvDjx4v3
4fv95YbajpxZaYypXLp4l8+C1/x/fEu3+mVmk7VMGxzJj51Qb4DNs8Pn1Bvh
7z/XhtV22DHy9IJ6Czz47mhEvRV+vOlBu3obnPQMd6i3w/bC9k51HjzzZleX
Oh/2pKbpnfBCf1lUXQg3u07RRbDz+gi9G3Zbc7QTzqjJjald8H1zki6Gs4Jf
aDc8cdZ/SV0ClzsG6VK4xf2LLoO/DVzrVnvggfdpuhz2P2qNq/fA6UgvvRfu
DazoUe+DrVdeugJuWnObtuC3q+7QXnj000PaB3c6h9QJ8d3oInsl3HC85LJ2
8evT59WmSv5/5Ri7eDLuZd8PB1o2s4tbx9exV8P1zb85X+y+N8X5NfDfuhl2
8VToCXstnJ0xyi6OZn5g98O3ij+yi3ekaBOAX8x+Zhcnbqznfgfgq39Wc3/x
eF8We53sl1fALnb9yGGvh2vDDnZxVbeNvQF2ZKc5XxzrSHG/g7D9+Ri7eL4/
yR6E+wpusot7QhfZD8GzySC7OJywsTfCngqj9okXbV/j1j80/7Qy
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
  PlotRange->{{0., 65.}, {0, 1.0961075624926764`*^-7}},
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
        RowBox[{"t", "+", "1"}], ",", "i", ",", "j", ",", "k"}], 
       "\[RightDoubleBracket]"}], "]"}], ",", 
     RowBox[{"{", 
      RowBox[{"t", ",", "0", ",", 
       SubscriptBox["t", "max"]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"i", ",", 
       SubscriptBox["dim", "1"]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"j", ",", 
       SubscriptBox["dim", "2"]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"k", ",", 
       SubscriptBox["dim", "3"]}], "}"}]}], "]"}]}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{"Dimensions", "[", "%", "]"}]}], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"65", ",", "8", ",", "16", ",", "32", ",", "3"}], "}"}]], "Output"]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{"check", " ", "momentum", " ", "conservation"}], " ", "*)"}], 
  "\[IndentingNewLine]", 
  RowBox[{
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
        RowBox[{"2", ",", "4"}], "}"}]}], "]"}], "/", 
     RowBox[{"Total", "[", 
      RowBox[{
       SubscriptBox["\[Rho]", "evolv"], ",", 
       RowBox[{"{", 
        RowBox[{"2", ",", "4"}], "}"}]}], "]"}]}], ";"}], 
   "\[IndentingNewLine]", 
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
1:eJxVyX0sFAAYx/HD2rw0p4kJy0u383beJZfc/XAc7riLXpa3xBiVt0Q50TlU
UktTmk1emjZudFtuNb3QbpZuJFFeVhSTrVxLa5VeVfP4o9/27NlnX4fU3Nh0
fQaDEfz3/v3VLfEZ/w9hS6XqTwGOvFUaIiTHwKi2zpVshtQH47n+iW7kjbBe
adUG1nPIVrAQNDybHfAi26Lqe5Y5fzSAbI8bM+zMmlge2RGmPb7GetwQMgsL
ncL25M3hZDb8cnI/uMsjyc5ocq9TN4ZGkV1xUWTVkTG/Zg7y5zpeOTDFZA+M
6T15VNMrInth3dvuUf030WRvNE4ONsNIQvbB51r9s9cXpWRftHw0P5I1tZPs
h+5JVvS3F2vein43hX9tzpr9oXZRWipm17wNDr1Dl4YsYskBkN3vULM5cWQu
NN4s1VPxbvJ2aJJEqurDe8iBaGVdu12u2kvegaD0O1cKf+4jB2FxROE3w00k
86BYWFZ+dUwi87HlptEmz9IUMrDsOs4cmjuwajlgLVQaNp1Pox4MCx/pvRbL
dOrB6DceK8l4mEE9BDz/pYjqrkzqIbDRDX9RMw9SD0WytDX+5ftD1EOxf+C0
NlCeTV2AgKzmemlGLnUBLMVO1ru0edTDcGak2UT2OJ96GLSDfQMTpgXUwzGn
qtJVex6lHo67FWHv9NYXUheip4nrHK8ly4XI9NZ4uPwuoh6BuJWG+lDj49Qj
oOPY5evsi6lHIinIqSTeXkY9Em19FbJkfgn1KEjsXldobE5Qj8IZ/dKyYsdS
6iIkSG5lLxiVURdhoujcNN/0JHUxuA1Caw5TTl0M0SkNe6aLzIjG8AZFZzqr
nHo02n/lTD1vIzNiIBg/dtnPVkE9Btwxg6mEq2SGBMp55pzMoYK6BGYF8z9M
VGSGFBdSpmebBZWrhhR5qrQubm8l7w+gsw/J
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
  PlotRange->{{0., 65.}, {0, 1.5454789687536584`*^-7}},
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
        RowBox[{"t", "+", "1"}], ",", "i", ",", "j", ",", "k"}], 
       "\[RightDoubleBracket]"}], "]"}], ",", 
     RowBox[{"{", 
      RowBox[{"t", ",", "0", ",", 
       SubscriptBox["t", "max"]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"i", ",", 
       SubscriptBox["dim", "1"]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"j", ",", 
       SubscriptBox["dim", "2"]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"k", ",", 
       SubscriptBox["dim", "3"]}], "}"}]}], "]"}]}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{"Dimensions", "[", "%", "]"}]}], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"65", ",", "8", ",", "16", ",", "32"}], "}"}]], "Output"]
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
        RowBox[{"t", "+", "1"}], ",", "i", ",", "j", ",", "k"}], 
       "\[RightDoubleBracket]"}], "]"}], ",", 
     RowBox[{"{", 
      RowBox[{"t", ",", "0", ",", 
       SubscriptBox["t", "max"]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"i", ",", 
       SubscriptBox["dim", "1"]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"j", ",", 
       SubscriptBox["dim", "2"]}], "}"}], ",", 
     RowBox[{"{", 
      RowBox[{"k", ",", 
       SubscriptBox["dim", "3"]}], "}"}]}], "]"}]}], 
  ";"}], "\[IndentingNewLine]", 
 RowBox[{"Dimensions", "[", "%", "]"}]}], "Input"],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"65", ",", "8", ",", "16", ",", "32"}], "}"}]], "Output"]
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
        RowBox[{"2", ",", "4"}], "}"}]}], "]"}], "/", 
     RowBox[{"Total", "[", 
      RowBox[{
       SubscriptBox["\[Rho]", "evolv"], ",", 
       RowBox[{"{", 
        RowBox[{"2", ",", "4"}], "}"}]}], "]"}]}], ";"}], 
   "\[IndentingNewLine]", 
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
1:eJxV0H8s1HEcx/GvVGTRL7OLZkiYk1ynyHFe5/dxOEkS+ZEpKq7LUGvMqNjy
I7rzayzaGLWra1j5sUayNUsMs/jD8EdZKTYb5Wc1n/cffbbPvnvs+flun8/b
8rLibNIOjuMkf/e/7/Za9OT+X/C42dcqMTURb1Mf7rLYtqFcJTu3H+XR54y7
Eh4yG+OC/jVXU81jZh4+6uRpZm+XMx/Bi4EFbVhEGbMF1o1/bdSak62QwR8V
RBcVM1sj1nfXDbvUe8w2UPZnSDtSs5ntMLZSYSeQ3WG2R/EX0abQje7nAHfv
2sKVHB1mR0Q4zCmqddOYnTCl2XRKnqf/BagabxGZ++cxn4ThsafWM5MFzELE
nv+pyzOj9zqjWl1qoHQsYj4F0/jnJWY76f6n0Zl0PNFlvoTZBe+SMg6oBY+Y
XSG/mmMz10w+g0MXVcpyV5qHG5T57bsnDtL8RJjb6hl7MEB2h8Osz63SSJq3
B5brVQltK2QxBpHlXTiuYvZEXFXO59VGNTPQrFlUrMsqtp0LWNV2D8snmTkJ
prN6vtbFVLIuQYpY+l78ipnzwsuE677cBHUvHI5uuWK0QN0bekvOfL5RFeve
UHT0jQrtmTkfOBcUJj7xou6DNYk2Yiqeui8C7CvvSoup++KEOHn4WTd1P2TP
fEhb/kbdD/xi5fRRs2rW/SEKnhhpkjPn+iPdpmuvQT71APiN2F6K01APQN3A
Wlz6EHUpfij3vRZ9py7FUsOnFPdN6oHYWNNsWe6pYT0Qw/d5Hh37mLkgqJx/
W9SZUA9CQys/ItWcugzi+bnVt7bUZahMWR0sE1IPhjCt3bDdi3owoqR61q3h
1EOgiYyJ8kuiHgLxTCBvPJN6KNTJvUV2hdRDsRbe229URV2OhDdDmU2NzJCj
sz40TKut8fwDd3gabg==
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
  PlotRange->{{0., 65.}, {0, 0.026064639056045925`}},
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
  RowBox[{"(*", " ", 
   RowBox[{"density", " ", "\[Rho]"}], " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{"Animate", "[", 
   RowBox[{
    RowBox[{"Image3D", "[", 
     RowBox[{
      RowBox[{"Table", "[", 
       RowBox[{
        RowBox[{
         RowBox[{
          SubscriptBox["\[Rho]", "evolv"], "\[LeftDoubleBracket]", 
          RowBox[{
           RowBox[{"t", "+", "1"}], ",", "i", ",", "j", ",", "k"}], 
          "\[RightDoubleBracket]"}], "/", "12"}], ",", 
        RowBox[{"{", 
         RowBox[{"i", ",", 
          SubscriptBox["dim", "1"]}], "}"}], ",", 
        RowBox[{"{", 
         RowBox[{"j", ",", 
          SubscriptBox["dim", "2"]}], "}"}], ",", 
        RowBox[{"{", 
         RowBox[{"k", ",", 
          SubscriptBox["dim", "3"]}], "}"}]}], "]"}], ",", 
      RowBox[{"Boxed", "\[Rule]", "True"}], ",", 
      RowBox[{"Axes", "\[Rule]", "True"}], ",", 
      RowBox[{"AxesLabel", "\[Rule]", 
       RowBox[{"{", 
        RowBox[{"\"\<z\>\"", ",", "\"\<y\>\"", ",", "\"\<x\>\""}], "}"}]}], 
      ",", 
      RowBox[{"BoxRatios", "\[Rule]", 
       RowBox[{"{", 
        RowBox[{"1", ",", "1", ",", "1"}], "}"}]}]}], "]"}], ",", 
    RowBox[{"{", 
     RowBox[{"t", ",", "0", ",", 
      SubscriptBox["t", "max"], ",", "1"}], "}"}], ",", 
    RowBox[{"AnimationRunning", "\[Rule]", "False"}]}], "]"}]}]], "Input"],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`t$$ = 9, Typeset`show$$ = True, 
    Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{
      Hold[$CellContext`t$$], 0, 64, 1}}, Typeset`size$$ = {
    360., {199., 204.}}, Typeset`update$$ = 0, Typeset`initDone$$, 
    Typeset`skipInitDone$$ = True, $CellContext`t$1339300$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, "Variables" :> {$CellContext`t$$ = 0}, 
      "ControllerVariables" :> {
        Hold[$CellContext`t$$, $CellContext`t$1339300$$, 0]}, 
      "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> Image3D[
        Table[Part[
           
           Subscript[$CellContext`\[Rho], $CellContext`evolv], \
$CellContext`t$$ + 1, $CellContext`i, $CellContext`j, $CellContext`k]/
         12, {$CellContext`i, 
          Subscript[$CellContext`dim, 1]}, {$CellContext`j, 
          Subscript[$CellContext`dim, 2]}, {$CellContext`k, 
          Subscript[$CellContext`dim, 3]}], Boxed -> True, Axes -> True, 
        AxesLabel -> {"z", "y", "x"}, BoxRatios -> {1, 1, 1}], 
      "Specifications" :> {{$CellContext`t$$, 0, 64, 1, AnimationRunning -> 
         False, AppearanceElements -> {
          "ProgressSlider", "PlayPauseButton", "FasterSlowerButtons", 
           "DirectionButton"}}}, 
      "Options" :> {
       ControlType -> Animator, AppearanceElements -> None, DefaultBaseStyle -> 
        "Animate", DefaultLabelStyle -> "AnimateLabel", SynchronousUpdating -> 
        True, ShrinkingDelay -> 10.}, "DefaultOptions" :> {}],
     ImageSizeCache->{411., {237., 244.}},
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
    RowBox[{"ListVectorPlot3D", "[", 
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
             "\[RightDoubleBracket]"}], ",", 
            RowBox[{
             SubscriptBox["z", "list"], "\[LeftDoubleBracket]", "k", 
             "\[RightDoubleBracket]"}]}], "}"}], ",", 
          RowBox[{
           SubscriptBox["u", "evolv"], "\[LeftDoubleBracket]", 
           RowBox[{
            RowBox[{"t", "+", "1"}], ",", "i", ",", "j", ",", "k"}], 
           "\[RightDoubleBracket]"}]}], "}"}], ",", 
        RowBox[{"{", 
         RowBox[{"i", ",", 
          SubscriptBox["dim", "1"]}], "}"}], ",", 
        RowBox[{"{", 
         RowBox[{"j", ",", 
          SubscriptBox["dim", "2"]}], "}"}], ",", 
        RowBox[{"{", 
         RowBox[{"k", ",", 
          SubscriptBox["dim", "3"]}], "}"}]}], "]"}], ",", 
      RowBox[{"VectorPoints", "\[Rule]", "5"}], ",", 
      RowBox[{"VectorScale", "\[Rule]", 
       RowBox[{"0.2", 
        RowBox[{"Max", "[", 
         RowBox[{"Flatten", "[", 
          RowBox[{"Map", "[", 
           RowBox[{"Norm", ",", 
            RowBox[{
             SubscriptBox["u", "evolv"], "\[LeftDoubleBracket]", 
             RowBox[{"t", "+", "1"}], "\[RightDoubleBracket]"}], ",", 
            RowBox[{"{", "3", "}"}]}], "]"}], "]"}], "]"}]}]}], ",", 
      RowBox[{"AxesLabel", "\[Rule]", 
       RowBox[{"{", 
        RowBox[{"\"\<x\>\"", ",", "\"\<y\>\"", ",", "\"\<z\>\""}], "}"}]}], 
      ",", 
      RowBox[{"PlotRange", "\[Rule]", 
       RowBox[{"ConstantArray", "[", 
        RowBox[{
         RowBox[{"{", 
          RowBox[{
           RowBox[{"-", "0.1"}], ",", "1.1"}], "}"}], ",", "3"}], "]"}]}], 
      ",", 
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
   DynamicModuleBox[{$CellContext`t$$ = 10, Typeset`show$$ = True, 
    Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{
      Hold[$CellContext`t$$], 0, 64, 1}}, Typeset`size$$ = {
    360., {202., 206.}}, Typeset`update$$ = 0, Typeset`initDone$$, 
    Typeset`skipInitDone$$ = True, $CellContext`t$1338449$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, "Variables" :> {$CellContext`t$$ = 0}, 
      "ControllerVariables" :> {
        Hold[$CellContext`t$$, $CellContext`t$1338449$$, 0]}, 
      "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> ListVectorPlot3D[
        Table[{{
           Part[
            Subscript[$CellContext`x, $CellContext`list], $CellContext`i], 
           Part[
            Subscript[$CellContext`y, $CellContext`list], $CellContext`j], 
           Part[
            Subscript[$CellContext`z, $CellContext`list], $CellContext`k]}, 
          Part[
           Subscript[$CellContext`u, $CellContext`evolv], $CellContext`t$$ + 
           1, $CellContext`i, $CellContext`j, $CellContext`k]}, \
{$CellContext`i, 
          Subscript[$CellContext`dim, 1]}, {$CellContext`j, 
          Subscript[$CellContext`dim, 2]}, {$CellContext`k, 
          Subscript[$CellContext`dim, 3]}], VectorPoints -> 5, VectorScale -> 
        0.2 Max[
           Flatten[
            Map[Norm, 
             Part[
              Subscript[$CellContext`u, $CellContext`evolv], $CellContext`t$$ + 
              1], {3}]]], AxesLabel -> {"x", "y", "z"}, PlotRange -> 
        ConstantArray[{-0.1, 1.1}, 3], VectorStyle -> Blue, PlotLabel -> 
        StringJoin["t: ", 
          ToString[$CellContext`t$$]]], 
      "Specifications" :> {{$CellContext`t$$, 0, 64, 1, AnimationRunning -> 
         False, AppearanceElements -> {
          "ProgressSlider", "PlayPauseButton", "FasterSlowerButtons", 
           "DirectionButton"}}}, 
      "Options" :> {
       ControlType -> Animator, AppearanceElements -> None, DefaultBaseStyle -> 
        "Animate", DefaultLabelStyle -> "AnimateLabel", SynchronousUpdating -> 
        True, ShrinkingDelay -> 10.}, "DefaultOptions" :> {}],
     ImageSizeCache->{411., {239., 246.}},
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
    RowBox[{"Image3D", "[", 
     RowBox[{
      RowBox[{"Table", "[", 
       RowBox[{
        RowBox[{
         SubscriptBox["en", 
          RowBox[{"int", ",", "evolv"}]], "\[LeftDoubleBracket]", 
         RowBox[{
          RowBox[{"t", "+", "1"}], ",", "i", ",", "j", ",", "k"}], 
         "\[RightDoubleBracket]"}], ",", 
        RowBox[{"{", 
         RowBox[{"i", ",", 
          SubscriptBox["dim", "1"]}], "}"}], ",", 
        RowBox[{"{", 
         RowBox[{"j", ",", 
          SubscriptBox["dim", "2"]}], "}"}], ",", 
        RowBox[{"{", 
         RowBox[{"k", ",", 
          SubscriptBox["dim", "3"]}], "}"}]}], "]"}], ",", 
      RowBox[{"Boxed", "\[Rule]", "True"}], ",", 
      RowBox[{"Axes", "\[Rule]", "True"}], ",", 
      RowBox[{"AxesLabel", "\[Rule]", 
       RowBox[{"{", 
        RowBox[{"\"\<z\>\"", ",", "\"\<y\>\"", ",", "\"\<x\>\""}], "}"}]}], 
      ",", 
      RowBox[{"BoxRatios", "\[Rule]", 
       RowBox[{"{", 
        RowBox[{"1", ",", "1", ",", "1"}], "}"}]}]}], "]"}], ",", 
    RowBox[{"{", 
     RowBox[{"t", ",", "0", ",", 
      SubscriptBox["t", "max"], ",", "1"}], "}"}], ",", 
    RowBox[{"AnimationRunning", "\[Rule]", "False"}]}], "]"}]}]], "Input"],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`t$$ = 6, Typeset`show$$ = True, 
    Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{
      Hold[$CellContext`t$$], 0, 64, 1}}, Typeset`size$$ = {
    360., {199., 204.}}, Typeset`update$$ = 0, Typeset`initDone$$, 
    Typeset`skipInitDone$$ = True, $CellContext`t$1339175$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, "Variables" :> {$CellContext`t$$ = 0}, 
      "ControllerVariables" :> {
        Hold[$CellContext`t$$, $CellContext`t$1339175$$, 0]}, 
      "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> Image3D[
        Table[
         Part[
          
          Subscript[$CellContext`en, $CellContext`int, $CellContext`evolv], \
$CellContext`t$$ + 
          1, $CellContext`i, $CellContext`j, $CellContext`k], {$CellContext`i, 
          Subscript[$CellContext`dim, 1]}, {$CellContext`j, 
          Subscript[$CellContext`dim, 2]}, {$CellContext`k, 
          Subscript[$CellContext`dim, 3]}], Boxed -> True, Axes -> True, 
        AxesLabel -> {"z", "y", "x"}, BoxRatios -> {1, 1, 1}], 
      "Specifications" :> {{$CellContext`t$$, 0, 64, 1, AnimationRunning -> 
         False, AppearanceElements -> {
          "ProgressSlider", "PlayPauseButton", "FasterSlowerButtons", 
           "DirectionButton"}}}, 
      "Options" :> {
       ControlType -> Animator, AppearanceElements -> None, DefaultBaseStyle -> 
        "Animate", DefaultLabelStyle -> "AnimateLabel", SynchronousUpdating -> 
        True, ShrinkingDelay -> 10.}, "DefaultOptions" :> {}],
     ImageSizeCache->{411., {237., 244.}},
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
    RowBox[{"Image3D", "[", 
     RowBox[{
      RowBox[{"Table", "[", 
       RowBox[{
        RowBox[{
         SubscriptBox["en", 
          RowBox[{"tot", ",", "evolv"}]], "\[LeftDoubleBracket]", 
         RowBox[{
          RowBox[{"t", "+", "1"}], ",", "i", ",", "j", ",", "k"}], 
         "\[RightDoubleBracket]"}], ",", 
        RowBox[{"{", 
         RowBox[{"i", ",", 
          SubscriptBox["dim", "1"]}], "}"}], ",", 
        RowBox[{"{", 
         RowBox[{"j", ",", 
          SubscriptBox["dim", "2"]}], "}"}], ",", 
        RowBox[{"{", 
         RowBox[{"k", ",", 
          SubscriptBox["dim", "3"]}], "}"}]}], "]"}], ",", 
      RowBox[{"Boxed", "\[Rule]", "True"}], ",", 
      RowBox[{"Axes", "\[Rule]", "True"}], ",", 
      RowBox[{"AxesLabel", "\[Rule]", 
       RowBox[{"{", 
        RowBox[{"\"\<z\>\"", ",", "\"\<y\>\"", ",", "\"\<x\>\""}], "}"}]}], 
      ",", 
      RowBox[{"BoxRatios", "\[Rule]", 
       RowBox[{"{", 
        RowBox[{"1", ",", "1", ",", "1"}], "}"}]}]}], "]"}], ",", 
    RowBox[{"{", 
     RowBox[{"t", ",", "0", ",", 
      SubscriptBox["t", "max"], ",", "1"}], "}"}], ",", 
    RowBox[{"AnimationRunning", "\[Rule]", "False"}]}], "]"}]}]], "Input"],

Cell[BoxData[
 TagBox[
  StyleBox[
   DynamicModuleBox[{$CellContext`t$$ = 13, Typeset`show$$ = True, 
    Typeset`bookmarkList$$ = {}, Typeset`bookmarkMode$$ = "Menu", 
    Typeset`animator$$, Typeset`animvar$$ = 1, Typeset`name$$ = 
    "\"untitled\"", Typeset`specs$$ = {{
      Hold[$CellContext`t$$], 0, 64, 1}}, Typeset`size$$ = {
    360., {199., 204.}}, Typeset`update$$ = 0, Typeset`initDone$$, 
    Typeset`skipInitDone$$ = True, $CellContext`t$1339219$$ = 0}, 
    DynamicBox[Manipulate`ManipulateBoxes[
     1, StandardForm, "Variables" :> {$CellContext`t$$ = 0}, 
      "ControllerVariables" :> {
        Hold[$CellContext`t$$, $CellContext`t$1339219$$, 0]}, 
      "OtherVariables" :> {
       Typeset`show$$, Typeset`bookmarkList$$, Typeset`bookmarkMode$$, 
        Typeset`animator$$, Typeset`animvar$$, Typeset`name$$, 
        Typeset`specs$$, Typeset`size$$, Typeset`update$$, Typeset`initDone$$,
         Typeset`skipInitDone$$}, "Body" :> Image3D[
        Table[
         Part[
          
          Subscript[$CellContext`en, $CellContext`tot, $CellContext`evolv], \
$CellContext`t$$ + 
          1, $CellContext`i, $CellContext`j, $CellContext`k], {$CellContext`i, 
          Subscript[$CellContext`dim, 1]}, {$CellContext`j, 
          Subscript[$CellContext`dim, 2]}, {$CellContext`k, 
          Subscript[$CellContext`dim, 3]}], Boxed -> True, Axes -> True, 
        AxesLabel -> {"z", "y", "x"}, BoxRatios -> {1, 1, 1}], 
      "Specifications" :> {{$CellContext`t$$, 0, 64, 1, AnimationRunning -> 
         False, AppearanceElements -> {
          "ProgressSlider", "PlayPauseButton", "FasterSlowerButtons", 
           "DirectionButton"}}}, 
      "Options" :> {
       ControlType -> Animator, AppearanceElements -> None, DefaultBaseStyle -> 
        "Animate", DefaultLabelStyle -> "AnimateLabel", SynchronousUpdating -> 
        True, ShrinkingDelay -> 10.}, "DefaultOptions" :> {}],
     ImageSizeCache->{411., {237., 244.}},
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
WindowSize->{1240, 1125},
WindowMargins->{{Automatic, 377}, {Automatic, 0}},
ShowSelection->True,
TrackCellChangeTimes->False,
FrontEndVersion->"10.0 for Microsoft Windows (64-bit) (July 1, 2014)",
StyleDefinitions->"Default.nb"
]
(* End of Notebook Content *)

(* Internal cache information *)
(*CellTagsOutline
CellTagsIndex->{
 "Info3627999695-9481541"->{
  Cell[74387, 1605, 239, 4, 40, "Print",
   CellTags->"Info3627999695-9481541"]}
 }
*)
(*CellTagsIndex
CellTagsIndex->{
 {"Info3627999695-9481541", 107929, 2555}
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
Cell[CellGroupData[{
Cell[3277, 90, 1924, 60, 72, "Input"],
Cell[5204, 152, 29, 0, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[5270, 157, 359, 11, 31, "Input"],
Cell[5632, 170, 188, 5, 210, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[5857, 180, 480, 15, 52, "Input"],
Cell[6340, 197, 29, 0, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[6406, 202, 269, 7, 72, "Input"],
Cell[6678, 211, 83, 2, 31, "Output"],
Cell[6764, 215, 28, 0, 31, "Output"]
}, Open  ]],
Cell[6807, 218, 1191, 36, 67, "Input"],
Cell[8001, 256, 117, 3, 31, "Input"],
Cell[8121, 261, 826, 24, 46, "Input"],
Cell[8950, 287, 1027, 31, 46, "Input"],
Cell[9980, 320, 893, 27, 46, "Input"],
Cell[CellGroupData[{
Cell[10898, 351, 429, 12, 52, "Input"],
Cell[11330, 365, 33, 0, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[11400, 370, 603, 18, 52, "Input"],
Cell[12006, 390, 152, 5, 31, "Output"]
}, Open  ]],
Cell[12173, 398, 379, 12, 72, "Input"]
}, Open  ]],
Cell[CellGroupData[{
Cell[12589, 415, 44, 0, 63, "Section"],
Cell[12636, 417, 282, 9, 72, "Input"],
Cell[12921, 428, 781, 27, 72, "Input"],
Cell[13705, 457, 192, 4, 30, "Text"],
Cell[CellGroupData[{
Cell[13922, 465, 2336, 66, 146, "Input"],
Cell[16261, 533, 96, 2, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[16394, 540, 1099, 31, 72, "Input"],
Cell[17496, 573, 2378, 47, 418, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[19911, 625, 1535, 40, 72, "Input"],
Cell[21449, 667, 51152, 860, 402, "Output"]
}, Open  ]],
Cell[72616, 1530, 339, 11, 31, "Input"],
Cell[72958, 1543, 447, 14, 52, "Input"]
}, Open  ]],
Cell[CellGroupData[{
Cell[73442, 1562, 33, 0, 63, "Section"],
Cell[73478, 1564, 123, 4, 31, "Input"],
Cell[73604, 1570, 264, 8, 52, "Input"],
Cell[73871, 1580, 93, 3, 31, "Input"],
Cell[CellGroupData[{
Cell[73989, 1587, 267, 8, 52, "Input"],
Cell[74259, 1597, 29, 0, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[74325, 1602, 59, 1, 31, "Input"],
Cell[74387, 1605, 239, 4, 40, "Print",
 CellTags->"Info3627999695-9481541"]
}, Open  ]],
Cell[74641, 1612, 638, 19, 31, "Input"],
Cell[CellGroupData[{
Cell[75304, 1635, 277, 6, 72, "Input"],
Cell[75584, 1643, 96, 2, 31, "Output"],
Cell[75683, 1647, 107, 2, 31, "Output"],
Cell[75793, 1651, 96, 2, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[75926, 1658, 273, 8, 52, "Input"],
Cell[76202, 1668, 28, 0, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[76267, 1673, 433, 13, 52, "Input"],
Cell[76703, 1688, 556, 18, 31, "Output"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[77308, 1712, 42, 0, 63, "Section"],
Cell[CellGroupData[{
Cell[77375, 1716, 818, 25, 52, "Input"],
Cell[78196, 1743, 96, 2, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[78329, 1750, 919, 28, 72, "Input"],
Cell[79251, 1780, 1599, 39, 238, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[80887, 1824, 814, 25, 52, "Input"],
Cell[81704, 1851, 106, 2, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[81847, 1858, 1595, 48, 72, "Input"],
Cell[83445, 1908, 1883, 44, 235, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[85365, 1957, 848, 26, 52, "Input"],
Cell[86216, 1985, 96, 2, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[86349, 1992, 845, 26, 52, "Input"],
Cell[87197, 2020, 96, 2, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[87330, 2027, 1689, 50, 72, "Input"],
Cell[89022, 2079, 1874, 44, 248, "Output"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[90945, 2129, 36, 0, 63, "Section"],
Cell[CellGroupData[{
Cell[91006, 2133, 1366, 37, 72, "Input"],
Cell[92375, 2172, 2251, 45, 498, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[94663, 2222, 2521, 66, 112, "Input"],
Cell[97187, 2290, 2850, 59, 502, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[100074, 2354, 1361, 37, 72, "Input"],
Cell[101438, 2393, 2271, 46, 498, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[103746, 2444, 1358, 37, 72, "Input"],
Cell[105107, 2483, 2272, 46, 498, "Output"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[107428, 2535, 27, 0, 63, "Section"],
Cell[107458, 2537, 86, 2, 31, "Input"]
}, Open  ]]
}, Open  ]]
}
]
*)

(* End of internal cache information *)

(* NotebookSignature Gv0vRNyyo9DXtAw#XwYH7naU *)
