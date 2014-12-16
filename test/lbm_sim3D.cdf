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
NotebookDataLength[    143370,       3170]
NotebookOptionsPosition[    139497,       3019]
NotebookOutlinePosition[    140015,       3041]
CellTagsIndexPosition[    139928,       3036]
WindowFrame->Normal*)

(* Beginning of Notebook Content *)
Notebook[{

Cell[CellGroupData[{
Cell["Lattice Boltzmann Method (LBM)", "Title",
 CellChangeTimes->{{3.5428666003782587`*^9, 3.5428666155161247`*^9}, 
   3.543826699095378*^9, {3.544962365881713*^9, 3.544962366692759*^9}, {
   3.569140793792229*^9, 3.569140801159651*^9}, {3.6161759517999973`*^9, 
   3.616175956507595*^9}}],

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
}], "Text",
 CellChangeTimes->{{3.616173836801427*^9, 3.616173877034536*^9}, {
   3.6161745277836704`*^9, 3.6161745412343783`*^9}, 3.6161812113642683`*^9}],

Cell[BoxData[
 RowBox[{
  RowBox[{"SetDirectory", "[", 
   RowBox[{"NotebookDirectory", "[", "]"}], "]"}], ";"}]], "Input",
 CellChangeTimes->{{3.5484803107953634`*^9, 3.5484803425781813`*^9}, {
  3.56397108329414*^9, 3.5639710834761505`*^9}}],

Cell[BoxData[
 RowBox[{
  RowBox[{"lbmLink", "=", 
   RowBox[{"Install", "[", 
    RowBox[{"\"\<../mlink/\>\"", "<>", "$SystemID", "<>", "\"\</lbmWS\>\""}], 
    "]"}]}], ";"}]], "Input",
 CellChangeTimes->{{3.5609403639740033`*^9, 3.5609403707653913`*^9}, 
   3.5609404328489428`*^9, {3.560947339958007*^9, 3.560947349225537*^9}, {
   3.5621818652377615`*^9, 3.562181881900715*^9}, {3.5637761199589214`*^9, 
   3.563776120422948*^9}, {3.569140921629541*^9, 3.5691409326511717`*^9}, 
   3.627672652932806*^9, {3.627674231168076*^9, 3.627674231254081*^9}}],

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
      "]"}]}], ";"}]}], "*)"}]], "Input",
 CellChangeTimes->{{3.627674233933234*^9, 3.6276742654470367`*^9}, {
  3.6276742983529186`*^9, 3.62767430781546*^9}}],

Cell[CellGroupData[{

Cell["Common functions", "Section",
 CellChangeTimes->{{3.543754978888487*^9, 3.5437549823516855`*^9}, {
  3.543826700074434*^9, 3.543826700074434*^9}, {3.5450353316872845`*^9, 
  3.545035355883669*^9}, {3.545035837391209*^9, 3.5450358389532986`*^9}, {
  3.545666929005372*^9, 3.5456669431221795`*^9}, {3.5457364737658944`*^9, 
  3.545736502080514*^9}, {3.5505145181722627`*^9, 3.5505145238825817`*^9}, {
  3.5505561616298428`*^9, 3.5505561658790855`*^9}, {3.5638906906346006`*^9, 
  3.5638906966339436`*^9}, {3.5691409452918944`*^9, 3.5691409538633847`*^9}, {
  3.61251642337684*^9, 3.6125164295211916`*^9}}],

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
 RowBox[{"Length", "[", "%", "]"}]}], "Input",
 CellChangeTimes->{{3.5691421471286354`*^9, 3.5691421759772854`*^9}, {
  3.5699607214971704`*^9, 3.5699607217841873`*^9}, {3.6137277233171687`*^9, 
  3.6137277237931957`*^9}, {3.613759816939436*^9, 3.6137598196495905`*^9}}],

Cell[BoxData["19"], "Output",
 CellChangeTimes->{3.6137598201076174`*^9, 3.613759891052675*^9, 
  3.6137599538172646`*^9, 3.613762283804532*^9, 3.613762498439809*^9, 
  3.6137630154573803`*^9, 3.613763153361268*^9, 3.6137635935974483`*^9, 
  3.616175975569516*^9, 3.6277143314391794`*^9, 3.627714685440982*^9}]
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
   RowBox[{"ImageSize", "\[Rule]", "Small"}]}], "]"}]], "Input",
 CellChangeTimes->{{3.5691421820406322`*^9, 3.5691422423750834`*^9}, {
  3.5691483948199835`*^9, 3.569148397100114*^9}, {3.5699607254953995`*^9, 
  3.5699607297076406`*^9}, {3.613727733706763*^9, 3.613727735362858*^9}}],

Cell[BoxData[
 Graphics3DBox[Arrow3DBox[CompressedData["
1:eJxTTMoPymNmYGAQBmImIAaxiQH/gQCbOOMA6fkPBdj0YzOfEYfZjHjcQ0s7
YOrQ1cP46OoZ0eTRxUE0ALv6PaE=
   "]],
  ImageSize->Small]], "Output",
 CellChangeTimes->{3.6137638917275004`*^9, 3.616175975893057*^9, 
  3.627714331483182*^9, 3.627714685509986*^9}]
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
 RowBox[{"Length", "[", "%", "]"}]}], "Input",
 CellChangeTimes->{{3.613728171037777*^9, 3.6137282263509407`*^9}, {
  3.6137598015895576`*^9, 3.613759804613731*^9}, {3.613759965933958*^9, 
  3.6137599796857443`*^9}}],

Cell[BoxData["19"], "Output",
 CellChangeTimes->{
  3.613759806186821*^9, 3.6137598926897683`*^9, {3.6137599538902693`*^9, 
   3.613759980217775*^9}, 3.6137622840785484`*^9, 3.6137624984838114`*^9, 
   3.613763015497383*^9, 3.61376315339227*^9, 3.61376359363245*^9, 
   3.616175975910059*^9, 3.6277143330252705`*^9, 3.6277146855329876`*^9}]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", "check", " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{"Total", "[", 
    SubscriptBox["vel", "3"], "]"}], "\[IndentingNewLine]", 
   RowBox[{"Total", "[", 
    SubscriptBox["weights", "3"], "]"}]}]}]], "Input",
 CellChangeTimes->{{3.6128509642527266`*^9, 3.612850982044744*^9}, {
  3.6137277058991723`*^9, 3.6137277078782854`*^9}}],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"0", ",", "0", ",", "0"}], "}"}]], "Output",
 CellChangeTimes->{{3.6128509727122097`*^9, 3.612850982411765*^9}, 
   3.612851750293685*^9, 3.612861896111993*^9, 3.612864342917942*^9, 
   3.6134716061845083`*^9, 3.6134965576732693`*^9, 3.613591191846733*^9, 
   3.613591545718973*^9, 3.613626717539381*^9, 3.6136503787007217`*^9, 
   3.613652083825249*^9, 3.613664150679434*^9, {3.6137277083103104`*^9, 
   3.613727738096014*^9}, 3.6137282452560215`*^9, 3.61372988273068*^9, 
   3.6137325617879133`*^9, 3.6137331997294016`*^9, 3.613759616166952*^9, 
   3.613759809420006*^9, 3.613759893332805*^9, {3.61375995390627*^9, 
   3.6137599812128315`*^9}, 3.6137622840875487`*^9, 3.6137624985018125`*^9, 
   3.6137630155123835`*^9, 3.6137631534032707`*^9, 3.613763593648451*^9, 
   3.616175975923061*^9, 3.6277143340413284`*^9, 3.627714685557989*^9}],

Cell[BoxData["1"], "Output",
 CellChangeTimes->{{3.6128509727122097`*^9, 3.612850982411765*^9}, 
   3.612851750293685*^9, 3.612861896111993*^9, 3.612864342917942*^9, 
   3.6134716061845083`*^9, 3.6134965576732693`*^9, 3.613591191846733*^9, 
   3.613591545718973*^9, 3.613626717539381*^9, 3.6136503787007217`*^9, 
   3.613652083825249*^9, 3.613664150679434*^9, {3.6137277083103104`*^9, 
   3.613727738096014*^9}, 3.6137282452560215`*^9, 3.61372988273068*^9, 
   3.6137325617879133`*^9, 3.6137331997294016`*^9, 3.613759616166952*^9, 
   3.613759809420006*^9, 3.613759893332805*^9, {3.61375995390627*^9, 
   3.6137599812128315`*^9}, 3.6137622840875487`*^9, 3.6137624985018125`*^9, 
   3.6137630155123835`*^9, 3.6137631534032707`*^9, 3.613763593648451*^9, 
   3.616175975923061*^9, 3.6277143340413284`*^9, 3.627714685562989*^9}]
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
        SubscriptBox["weights", "3"], "]"}]}], "}"}]}], "]"}]}]}]], "Input",
 CellChangeTimes->{{3.6127651966342144`*^9, 3.6127653393203754`*^9}, {
  3.612765401486931*^9, 3.612765409382383*^9}, {3.613727637130239*^9, 
  3.6137276444136553`*^9}, {3.613727757889146*^9, 3.613727759195221*^9}, {
  3.6137278006445913`*^9, 3.6137278020816736`*^9}}],

Cell[BoxData[
 RowBox[{
  RowBox[{"Density", "[", "f_", "]"}], ":=", 
  RowBox[{"Total", "[", "f", "]"}]}]], "Input",
 CellChangeTimes->{{3.6125163699857864`*^9, 3.61251637214891*^9}, {
  3.612516406197858*^9, 3.6125164131192536`*^9}}],

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
       RowBox[{"0", ",", "0", ",", "0"}], "}"}]}], "]"}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.6125164159714165`*^9, 3.6125164388227234`*^9}, {
   3.6125164789900208`*^9, 3.6125164954869647`*^9}, {3.612518084622858*^9, 
   3.612518115659633*^9}, 3.6125182142382717`*^9, {3.6137278459491825`*^9, 
   3.613727846468212*^9}, {3.6137333053064404`*^9, 3.6137333055564547`*^9}, {
   3.6137353512564616`*^9, 3.6137353514434724`*^9}, 3.6137599895823107`*^9, {
   3.6137600267214346`*^9, 3.613760038035082*^9}}],

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
     "]"}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.5768627544795885`*^9, 3.5768627656332264`*^9}, {
   3.576863566546036*^9, 3.576863643355429*^9}, {3.5835207766347046`*^9, 
   3.583520792763627*^9}, {3.583521514724921*^9, 3.583521518517138*^9}, {
   3.5835612900600824`*^9, 3.5835613054589634`*^9}, {3.583561429138037*^9, 
   3.583561463397997*^9}, 3.5835680452594495`*^9, {3.5835686816198473`*^9, 
   3.583568683366947*^9}, {3.583579865594932*^9, 3.5835798933195176`*^9}, {
   3.6125181253001842`*^9, 3.6125182231717825`*^9}, {3.61372785272357*^9, 
   3.6137278566997976`*^9}}],

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
     "]"}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.5768627544795885`*^9, 3.5768627656332264`*^9}, {
   3.576863566546036*^9, 3.576863643355429*^9}, {3.5835207766347046`*^9, 
   3.583520792763627*^9}, {3.583521514724921*^9, 3.583521518517138*^9}, {
   3.5835612900600824`*^9, 3.5835613054589634`*^9}, {3.583561429138037*^9, 
   3.583561463397997*^9}, 3.5835680452594495`*^9, {3.5835686816198473`*^9, 
   3.583568683366947*^9}, {3.583579865594932*^9, 3.5835798933195176`*^9}, {
   3.6125181253001842`*^9, 3.6125182231717825`*^9}, {3.6125190069296107`*^9, 
   3.61251902003236*^9}, {3.613727862081105*^9, 3.6137278624501266`*^9}}],

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
        SubscriptBox["u", "3"]}], "}"}]}], "]"}], "]"}], "]"}]}]], "Input",
 CellChangeTimes->{{3.612765351160053*^9, 3.612765369260088*^9}, {
  3.612765415259719*^9, 3.6127654280444503`*^9}, {3.6127655426790075`*^9, 
  3.6127655488663607`*^9}, {3.6127668176445684`*^9, 3.612766820834751*^9}, {
  3.612851662111642*^9, 3.6128516860210094`*^9}, {3.613727787750854*^9, 
  3.6137278082850285`*^9}}],

Cell[BoxData["\[Rho]"], "Output",
 CellChangeTimes->{{3.6127653524351254`*^9, 3.61276536999413*^9}, {
   3.61276541125449*^9, 3.6127654286394844`*^9}, 3.612766591101611*^9, 
   3.6127668214717875`*^9, {3.612766864322238*^9, 3.612766875287865*^9}, 
   3.6127669400405693`*^9, 3.6127691988727665`*^9, {3.612851662576668*^9, 
   3.6128517121565037`*^9}, 3.6128517503346877`*^9, 3.6128618961599956`*^9, 
   3.6128643429609447`*^9, 3.6134716062305107`*^9, 3.613496557722272*^9, 
   3.613591191896736*^9, 3.613591545760976*^9, 3.6136267175873833`*^9, 
   3.6136503787487245`*^9, 3.6136520838792524`*^9, 3.613664150730437*^9, {
   3.61372778942295*^9, 3.6137278086020465`*^9}, 3.6137278647562585`*^9, 
   3.6137298827946835`*^9, 3.613732561832916*^9, 3.6137331997934055`*^9, 
   3.6137596162099547`*^9, 3.613759953946272*^9, 3.613759994890614*^9, {
   3.6137600307756667`*^9, 3.613760040154203*^9}, 3.6137622845825768`*^9, 
   3.6137624985428147`*^9, 3.613763015549386*^9, 3.613763153429272*^9, 
   3.613763593684453*^9, 3.616175975958065*^9, 3.6277143397816563`*^9, 
   3.627714685683996*^9}]
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
      RowBox[{"\[Rho]", ">", "0"}], "}"}]}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.6127654510477657`*^9, 3.612765502976736*^9}, {
  3.6127655517125235`*^9, 3.612765557901878*^9}, {3.612766825241003*^9, 
  3.6127668292732334`*^9}, {3.6128516660098643`*^9, 3.6128516949075174`*^9}, {
  3.612851781201453*^9, 3.6128517951072483`*^9}, {3.613727812170251*^9, 
  3.6137278191896524`*^9}}],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{
   SubscriptBox["u", "1"], ",", 
   SubscriptBox["u", "2"], ",", 
   SubscriptBox["u", "3"]}], "}"}]], "Output",
 CellChangeTimes->{{3.6127654962843533`*^9, 3.6127655035097666`*^9}, 
   3.612766591121612*^9, 3.6127668300902805`*^9, {3.6127668651682863`*^9, 
   3.6127668759949055`*^9}, 3.61276694005857*^9, 3.612769198892768*^9, {
   3.6128516676759596`*^9, 3.6128517128255424`*^9}, 3.6128517504036913`*^9, {
   3.612851784224626*^9, 3.612851798909466*^9}, 3.6128618962199993`*^9, 
   3.612864343021948*^9, 3.6134716062945147`*^9, 3.613496557846279*^9, 
   3.613591191954739*^9, 3.6135915458189793`*^9, 3.6136267177113905`*^9, 
   3.6136503788067274`*^9, 3.613652083899254*^9, 3.61366415078944*^9, 
   3.613727825706025*^9, 3.613727865554304*^9, 3.6137298828766885`*^9, 
   3.6137325618989196`*^9, 3.6137331998174067`*^9, 3.6137596163179607`*^9, 
   3.6137597593141403`*^9, 3.61375989621097*^9, 3.613759954047278*^9, 
   3.613759995708661*^9, {3.613760031430704*^9, 3.61376004079924*^9}, 
   3.613762284654581*^9, 3.613762498611819*^9, 3.6137630156163893`*^9, 
   3.6137631534882755`*^9, 3.613763593752457*^9, 3.616175976019573*^9, 
   3.6277143408357167`*^9, 3.6277146857489996`*^9}]
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
     SuperscriptBox["2", "1"]}], ";"}]}]}]], "Input",
 CellChangeTimes->{{3.570385203756421*^9, 3.5703852125209227`*^9}, {
  3.5703853146747656`*^9, 3.5703853695869064`*^9}, {3.57038561966721*^9, 
  3.5703856297217855`*^9}, {3.6125065940626354`*^9, 3.612506594454658*^9}, {
  3.613728118247757*^9, 3.6137281314565125`*^9}}]
}, Open  ]],

Cell[CellGroupData[{

Cell["Define initial flow field", "Section",
 CellChangeTimes->{{3.543754978888487*^9, 3.5437549823516855`*^9}, {
  3.543826700074434*^9, 3.543826700074434*^9}, {3.5450353316872845`*^9, 
  3.545035355883669*^9}, {3.545035837391209*^9, 3.5450358389532986`*^9}, {
  3.545666929005372*^9, 3.5456669431221795`*^9}, {3.5457364737658944`*^9, 
  3.545736502080514*^9}, {3.5505145181722627`*^9, 3.5505145238825817`*^9}, {
  3.5505561616298428`*^9, 3.5505561658790855`*^9}, {3.5638906906346006`*^9, 
  3.5638906966339436`*^9}, {3.5691409452918944`*^9, 3.5691409538633847`*^9}}],

Cell[BoxData[{
 RowBox[{
  RowBox[{
   SubscriptBox["dim", "1"], "=", "8"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   SubscriptBox["dim", "2"], "=", "16"}], ";"}], "\[IndentingNewLine]", 
 RowBox[{
  RowBox[{
   SubscriptBox["dim", "3"], "=", "32"}], ";"}]}], "Input",
 CellChangeTimes->{{3.5691413893432927`*^9, 3.5691414017180004`*^9}, {
  3.569141966705316*^9, 3.5691419777309465`*^9}, {3.5691424087776012`*^9, 
  3.5691424111607375`*^9}, {3.569960659166606*^9, 3.5699606679201064`*^9}, {
  3.6137227106854625`*^9, 3.613722715735751*^9}, {3.6137331815093594`*^9, 
  3.61373318414251*^9}}],

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
    SubscriptBox["dim", "3"]}]}], ";"}]}], "Input",
 CellChangeTimes->{{3.5691423687733126`*^9, 3.5691424209772987`*^9}, {
  3.5699607511618676`*^9, 3.5699607567061844`*^9}}],

Cell["\<\
For too large density changes or velocities, momentum conservation might not \
hold exactly since the implementation restricts velocities to maximum allowed \
velocity.\
\>", "Text",
 CellChangeTimes->{{3.613761951729539*^9, 3.613761997352148*^9}, {
  3.6137636613183217`*^9, 3.6137636676676846`*^9}}],

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
  SubscriptBox["f", "0"], "]"}]}], "Input",
 CellChangeTimes->{{3.613729902413806*^9, 3.6137299457532845`*^9}, {
   3.6137300123280926`*^9, 3.6137301768595033`*^9}, {3.613730238363021*^9, 
   3.613730246979514*^9}, {3.6137305602534323`*^9, 3.6137305605004463`*^9}, 
   3.6137307569556828`*^9, 3.6137308686370707`*^9, {3.6137309056901903`*^9, 
   3.613730914587699*^9}, 3.613731132880184*^9, 3.6137313306314955`*^9, {
   3.613731418187503*^9, 3.613731430873229*^9}, 3.6137319001890717`*^9, {
   3.6137319791545887`*^9, 3.6137320003217993`*^9}, {3.613732528793026*^9, 
   3.6137325501472473`*^9}, {3.613736490504623*^9, 3.6137364920097094`*^9}, {
   3.613737159742901*^9, 3.6137371618340206`*^9}, {3.613760101694723*^9, 
   3.613760119058716*^9}, {3.613760162060176*^9, 3.6137601643683076`*^9}, {
   3.6137603767084527`*^9, 3.6137603793486037`*^9}, 3.613761591458933*^9, {
   3.6137617840659494`*^9, 3.61376178880022*^9}, {3.613761888598928*^9, 
   3.613761965159307*^9}}],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"8", ",", "16", ",", "32", ",", "19"}], "}"}]], "Output",
 CellChangeTimes->{{3.613730155719294*^9, 3.6137301958545895`*^9}, 
   3.613730272995002*^9, 3.613730575283292*^9, 3.6137307721145496`*^9, 
   3.6137308840929546`*^9, 3.613730946024497*^9, 3.6137311488490977`*^9, 
   3.613731346653412*^9, 3.6137314465521255`*^9, 3.6137319154449444`*^9, 
   3.6137320063581443`*^9, {3.613732551923349*^9, 3.6137325664061775`*^9}, 
   3.6137332009144692`*^9, 3.613736493319784*^9, 3.613737164180155*^9, 
   3.6137596173970227`*^9, 3.613760048965707*^9, 3.613760120505799*^9, 
   3.61376016615641*^9, 3.6137603808336887`*^9, 3.6137615945331087`*^9, 
   3.6137617216293783`*^9, 3.613761794175527*^9, 3.6137622882237854`*^9, 
   3.613762502206024*^9, 3.613763019207595*^9, 3.6137631570564795`*^9, 
   3.6137635973566637`*^9, 3.616175979794052*^9, 3.6277144388568783`*^9, 
   3.6277146900512457`*^9}]
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
      RowBox[{"1", ",", "1", ",", "1"}], "}"}]}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.5697594073321524`*^9, 3.5697594756120577`*^9}, {
   3.569759518464509*^9, 3.569759552246441*^9}, {3.5697597166578445`*^9, 
   3.569759749286711*^9}, {3.569759780619503*^9, 3.569759787183879*^9}, {
   3.5697602339404316`*^9, 3.5697602464481473`*^9}, {3.569962860330505*^9, 
   3.5699628709341116`*^9}, {3.569962904195014*^9, 3.5699629142035866`*^9}, {
   3.5699631330971065`*^9, 3.569963135656253*^9}, {3.56996319575169*^9, 
   3.569963196841752*^9}, {3.569963653368864*^9, 3.569963658858178*^9}, {
   3.5699637024536715`*^9, 3.569963727387098*^9}, {3.569963773908759*^9, 
   3.5699637803251257`*^9}, {3.569963828412876*^9, 3.569963871002312*^9}, {
   3.5699639104445677`*^9, 3.5699639272915316`*^9}, {3.6137260922158747`*^9, 
   3.6137261528413424`*^9}, {3.6137302936161814`*^9, 
   3.6137302950002604`*^9}, {3.6137303343425107`*^9, 3.613730429732967*^9}, {
   3.6137308339710875`*^9, 3.6137308429206*^9}, 3.6137626893617287`*^9}],

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
  PlotRange->{{0, 32}, {0, 16}, {0, 8}}]], "Output",
 CellChangeTimes->{3.6137627034965377`*^9, 3.6137630192946*^9, 
  3.613763157131484*^9, 3.6137635974316673`*^9, 3.616175979878563*^9, 
  3.6277144398279343`*^9, 3.627714690173253*^9}]
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
    RowBox[{"VectorStyle", "\[Rule]", "Blue"}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.5691425475375376`*^9, 3.5691425510657396`*^9}, {
   3.569142586148746*^9, 3.5691426509804544`*^9}, {3.5691426921798105`*^9, 
   3.569142699437226*^9}, 3.569142758700616*^9, {3.5691428216682167`*^9, 
   3.5691428451785617`*^9}, {3.569961799530831*^9, 3.5699618856717577`*^9}, {
   3.61372347799335*^9, 3.6137235274611793`*^9}, {3.6137235590589867`*^9, 
   3.6137235713026867`*^9}, {3.6137236148491774`*^9, 3.6137236204825*^9}, {
   3.6137305201511383`*^9, 3.6137305301967125`*^9}, {3.6137308761775017`*^9, 
   3.6137308826638727`*^9}}],

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
  Ticks->{Automatic, Automatic, Automatic}]], "Output",
 CellChangeTimes->{3.613762709409876*^9, 3.6137630197616267`*^9, 
  3.6137631576365128`*^9, 3.6137635979166956`*^9, 3.616175980354624*^9, 
  3.627714444213185*^9, 3.6277146908622923`*^9}]
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
       SubscriptBox["dim", "3"]}], "}"}]}], "]"}]}], ";"}]], "Input",
 CellChangeTimes->{{3.6125065614227686`*^9, 3.6125065698942533`*^9}, {
  3.6125066011400404`*^9, 3.6125066087494755`*^9}, {3.6137242154185286`*^9, 
  3.6137242162235746`*^9}}],

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
   ";"}]}]], "Input",
 CellChangeTimes->{{3.5704334153889475`*^9, 3.5704334214582944`*^9}, {
   3.57043362419389*^9, 3.570433625077941*^9}, {3.570433683043256*^9, 
   3.5704336871874933`*^9}, {3.5704338073433657`*^9, 3.5704338214121704`*^9}, 
   3.570433957403949*^9, {3.5704381880746365`*^9, 3.5704381942399893`*^9}, {
   3.612856945131813*^9, 3.6128569464338875`*^9}}]
}, Open  ]],

Cell[CellGroupData[{

Cell["Run LBM method", "Section",
 CellChangeTimes->{{3.5663120301619015`*^9, 3.566312054543296*^9}, {
  3.56914332367293*^9, 3.56914332751015*^9}}],

Cell[BoxData[
 RowBox[{
  RowBox[{
   SubscriptBox["\[Omega]", "val"], "=", 
   RowBox[{"1", "/", "5"}]}], ";"}]], "Input",
 CellChangeTimes->{{3.569143166721953*^9, 3.5691431729363084`*^9}}],

Cell[BoxData[
 RowBox[{
  RowBox[{"(*", " ", 
   RowBox[{"zero", " ", "gravity"}], " ", "*)"}], "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{
    SubscriptBox["g", "val"], "=", 
    RowBox[{"{", 
     RowBox[{"0", ",", "0", ",", "0"}], "}"}]}], ";"}]}]], "Input",
 CellChangeTimes->{{3.5703847568478594`*^9, 3.5703847740508437`*^9}, 
   3.570388527477527*^9, {3.570388568394868*^9, 3.5703885685598774`*^9}, {
   3.5704414042085896`*^9, 3.570441407727791*^9}, {3.6125062491679087`*^9, 
   3.612506249790944*^9}, {3.61286334142566*^9, 3.6128633421657023`*^9}, {
   3.613723885987686*^9, 3.613723886281703*^9}}],

Cell[BoxData[
 RowBox[{
  RowBox[{
   SubscriptBox["t", "max"], "=", "64"}], ";"}]], "Input",
 CellChangeTimes->{{3.5691433888626585`*^9, 3.569143397782169*^9}, {
  3.5699628113467035`*^9, 3.569962811361704*^9}, {3.613763563260713*^9, 
  3.613763563274714*^9}}],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{
  RowBox[{
   SubscriptBox["t", "discr"], "=", 
   RowBox[{"Range", "[", 
    RowBox[{"0", ",", 
     SubscriptBox["t", "max"]}], "]"}]}], ";"}], "\[IndentingNewLine]", 
 RowBox[{"Length", "[", 
  SubscriptBox["t", "discr"], "]"}]}], "Input",
 CellChangeTimes->{{3.5691434033314867`*^9, 3.5691434279958973`*^9}}],

Cell[BoxData["65"], "Output",
 CellChangeTimes->{{3.5691434238646607`*^9, 3.5691434283009143`*^9}, 
   3.5691480518623667`*^9, 3.569759056725099*^9, 3.569960671028284*^9, 
   3.569962813333817*^9, 3.6137238898749084`*^9, 3.6137242412600064`*^9, 
   3.613724985332565*^9, 3.613730617527708*^9, 3.613732577487811*^9, 
   3.613733215763318*^9, 3.613737174166726*^9, 3.6137596184880853`*^9, 
   3.6137600619964523`*^9, 3.6137622890098305`*^9, 3.6137625030900745`*^9, 
   3.613763020062644*^9, 3.6137631579465303`*^9, 3.6137635982117124`*^9, 
   3.616175980666663*^9, 3.6277144518436213`*^9, 3.627714691403323*^9}]
}, Open  ]],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"?", "LatticeBoltzmann"}]], "Input",
 CellChangeTimes->{{3.627714462957257*^9, 3.62771446318927*^9}}],

Cell[BoxData[
 StyleBox["\<\"LatticeBoltzmann[omega_Real, numsteps_Integer, gravity_List, \
f0_List, type0_List] runs a Lattice Boltzmann Method (LBM) simulation\"\>", 
  "MSG"]], "Print", "PrintUsage",
 CellChangeTimes->{3.6277146915273304`*^9},
 CellTags->"Info3627718291-6212165"]
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
      SubscriptBox["type", "0"], "]"}]}], "]"}]}], ";"}]], "Input",
 CellChangeTimes->{{3.5691431443336725`*^9, 3.569143196184638*^9}, {
  3.569143443135763*^9, 3.569143447208996*^9}, {3.5699619072809935`*^9, 
  3.5699619082750506`*^9}, {3.613723904906768*^9, 3.613723918018518*^9}, {
  3.6137242273082085`*^9, 3.6137242299203577`*^9}, {3.613724996858224*^9, 
  3.613725015828309*^9}, {3.6137342544697294`*^9, 3.6137342551257668`*^9}, {
  3.6277144721497827`*^9, 3.6277144722807903`*^9}}],

Cell[CellGroupData[{

Cell[BoxData[{
 RowBox[{"Dimensions", "[", 
  SubscriptBox["type", "evolv"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"Dimensions", "[", 
  SubscriptBox["f", "evolv"], "]"}], "\[IndentingNewLine]", 
 RowBox[{"Dimensions", "[", 
  SubscriptBox["mass", "evolv"], "]"}]}], "Input",
 CellChangeTimes->{{3.6127768363276043`*^9, 3.6127768459111524`*^9}, {
  3.6134964518402157`*^9, 3.613496452727267*^9}}],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"65", ",", "8", ",", "16", ",", "32"}], "}"}]], "Output",
 CellChangeTimes->{3.613725045174988*^9, 3.613730624667116*^9, 
  3.6137309702378817`*^9, 3.6137311582776375`*^9, 3.6137313575290337`*^9, 
  3.613731450735365*^9, 3.6137319252365046`*^9, 3.6137320250612144`*^9, 
  3.61373258184206*^9, 3.613733219742546*^9, 3.6137339269569964`*^9, 
  3.6137340201283255`*^9, 3.6137342585229607`*^9, 3.6137345049030533`*^9, 
  3.6137345716678715`*^9, 3.613735256803059*^9, 3.6137365191012583`*^9, 
  3.6137371809891167`*^9, 3.6137596249074526`*^9, 3.613760078790413*^9, 
  3.6137601296013193`*^9, 3.613760171891738*^9, 3.61376065517238*^9, 
  3.6137617531921835`*^9, 3.6137618220011187`*^9, 3.6137622897838745`*^9, 
  3.613762503858119*^9, 3.6137630208216877`*^9, 3.6137631586665716`*^9, 
  3.613763599466784*^9, 3.6161759820078335`*^9, 3.627714476012004*^9, 
  3.6277146917563434`*^9}],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"65", ",", "8", ",", "16", ",", "32", ",", "19"}], "}"}]], "Output",
 CellChangeTimes->{3.613725045174988*^9, 3.613730624667116*^9, 
  3.6137309702378817`*^9, 3.6137311582776375`*^9, 3.6137313575290337`*^9, 
  3.613731450735365*^9, 3.6137319252365046`*^9, 3.6137320250612144`*^9, 
  3.61373258184206*^9, 3.613733219742546*^9, 3.6137339269569964`*^9, 
  3.6137340201283255`*^9, 3.6137342585229607`*^9, 3.6137345049030533`*^9, 
  3.6137345716678715`*^9, 3.613735256803059*^9, 3.6137365191012583`*^9, 
  3.6137371809891167`*^9, 3.6137596249074526`*^9, 3.613760078790413*^9, 
  3.6137601296013193`*^9, 3.613760171891738*^9, 3.61376065517238*^9, 
  3.6137617531921835`*^9, 3.6137618220011187`*^9, 3.6137622897838745`*^9, 
  3.613762503858119*^9, 3.6137630208216877`*^9, 3.6137631586665716`*^9, 
  3.613763599466784*^9, 3.6161759820078335`*^9, 3.627714476012004*^9, 
  3.6277146917583437`*^9}],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"65", ",", "8", ",", "16", ",", "32"}], "}"}]], "Output",
 CellChangeTimes->{3.613725045174988*^9, 3.613730624667116*^9, 
  3.6137309702378817`*^9, 3.6137311582776375`*^9, 3.6137313575290337`*^9, 
  3.613731450735365*^9, 3.6137319252365046`*^9, 3.6137320250612144`*^9, 
  3.61373258184206*^9, 3.613733219742546*^9, 3.6137339269569964`*^9, 
  3.6137340201283255`*^9, 3.6137342585229607`*^9, 3.6137345049030533`*^9, 
  3.6137345716678715`*^9, 3.613735256803059*^9, 3.6137365191012583`*^9, 
  3.6137371809891167`*^9, 3.6137596249074526`*^9, 3.613760078790413*^9, 
  3.6137601296013193`*^9, 3.613760171891738*^9, 3.61376065517238*^9, 
  3.6137617531921835`*^9, 3.6137618220011187`*^9, 3.6137622897838745`*^9, 
  3.613762503858119*^9, 3.6137630208216877`*^9, 3.6137631586665716`*^9, 
  3.613763599466784*^9, 3.6161759820078335`*^9, 3.627714476012004*^9, 
  3.627714691766344*^9}]
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
     SubscriptBox["type", "evolv"], "-", "2"}], "]"}], "]"}]}]], "Input",
 CellChangeTimes->{{3.613725084789253*^9, 3.613725122131389*^9}}],

Cell[BoxData["0"], "Output",
 CellChangeTimes->{{3.6137250876054144`*^9, 3.6137251226954217`*^9}, 
   3.6137306257271767`*^9, 3.613730972149991*^9, 3.6137311605137653`*^9, 
   3.6137313583680816`*^9, 3.6137314510433826`*^9, 3.6137320258402586`*^9, 
   3.613732582674108*^9, 3.6137332227527184`*^9, 3.613733929156122*^9, 
   3.6137342597940335`*^9, 3.613734572318909*^9, 3.613735257990127*^9, 
   3.6137365200893154`*^9, 3.6137371817371593`*^9, 3.6137596249434547`*^9, 
   3.6137600797614684`*^9, 3.613760130398365*^9, 3.6137606560874324`*^9, 
   3.613761753960227*^9, 3.6137618225901527`*^9, 3.6137622898218765`*^9, 
   3.613762503893121*^9, 3.613763020853689*^9, 3.6137631586975737`*^9, 
   3.6137635995237875`*^9, 3.6161759820628405`*^9, 3.6277144774800873`*^9, 
   3.627714691814347*^9}]
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
   "\[RightDoubleBracket]"}]}]], "Input",
 CellChangeTimes->{{3.569143352146559*^9, 3.5691433828963175`*^9}, {
  3.5699624514801197`*^9, 3.5699624871591606`*^9}, {3.6137250679372897`*^9, 
  3.613725072525552*^9}, {3.6137314516724186`*^9, 3.613731452529467*^9}, {
  3.627714486840623*^9, 3.627714492533949*^9}}],

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
    "}"}]}], "}"}]], "Output",
 CellChangeTimes->{{3.5691433562907953`*^9, 3.5691433830883284`*^9}, 
   3.5691434499101505`*^9, 3.569148053992489*^9, {3.56975910867807*^9, 
   3.56975911671353*^9}, {3.569962473558383*^9, 3.5699624877311935`*^9}, 
   3.5699628320778894`*^9, 3.613724578127274*^9, {3.6137250594978065`*^9, 
   3.613725072727564*^9}, 3.6137306276962895`*^9, 3.6137309727800274`*^9, 
   3.6137311612978096`*^9, 3.613731360469202*^9, 3.6137314529354906`*^9, 
   3.61373192759964*^9, 3.6137320276373615`*^9, 3.6137325833471465`*^9, 
   3.6137332250428495`*^9, 3.6137339307892156`*^9, 3.6137342610011024`*^9, 
   3.613734572953945*^9, 3.613735259480212*^9, 3.61373652191942*^9, 
   3.613737182353194*^9, 3.613759624957455*^9, 3.613760080471509*^9, 
   3.613760131134407*^9, 3.6137601747289004`*^9, 3.6137606567394695`*^9, 
   3.613761754588263*^9, 3.6137618231291833`*^9, 3.6137622898378773`*^9, 
   3.613762503905122*^9, 3.61376302086769*^9, 3.613763158710574*^9, 
   3.613763599537788*^9, 3.6161759820793424`*^9, {3.627714482560378*^9, 
   3.627714493009976*^9}, 3.6277146918283477`*^9}]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Check conservation laws", "Section",
 CellChangeTimes->{{3.5663120301619015`*^9, 3.566312054543296*^9}, {
  3.569143331228362*^9, 3.5691433346665587`*^9}, {3.6125197313360443`*^9, 
  3.6125197351432624`*^9}}],

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
 RowBox[{"Dimensions", "[", "%", "]"}]}], "Input",
 CellChangeTimes->{{3.612519736432336*^9, 3.6125198120986643`*^9}, {
  3.613725165658879*^9, 3.6137251866680803`*^9}}],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"65", ",", "8", ",", "16", ",", "32"}], "}"}]], "Output",
 CellChangeTimes->{{3.6125198054992867`*^9, 3.6125198126126933`*^9}, 
   3.6125208058725047`*^9, 3.6128496665525017`*^9, 3.612862373645306*^9, 
   3.6128627720610943`*^9, 3.6128634166949654`*^9, 3.612863469089962*^9, 
   3.6128635282453456`*^9, 3.6136647173638463`*^9, 3.6137251897252555`*^9, 
   3.6137306318215256`*^9, 3.6137309783683467`*^9, 3.6137311661710887`*^9, 
   3.6137313650004606`*^9, 3.613731457670761*^9, 3.6137319320488944`*^9, 
   3.6137320326366477`*^9, 3.6137325883854346`*^9, 3.6137332287560616`*^9, 
   3.61373360689169*^9, 3.6137339359895134`*^9, 3.613734024595581*^9, 
   3.613734264312292*^9, 3.613734509556319*^9, 3.613734576073124*^9, 
   3.613735263130421*^9, 3.613736525351616*^9, 3.613737185474373*^9, 
   3.613759625336477*^9, 3.613760083478681*^9, 3.613760133952568*^9, 
   3.6137601784311123`*^9, 3.613760659994656*^9, 3.6137617574794283`*^9, 
   3.613761826305365*^9, 3.6137622902088985`*^9, 3.6137625042681427`*^9, 
   3.6137630212397113`*^9, 3.613763159077595*^9, 3.613763600246829*^9, 
   3.61617598284544*^9, 3.6277144991943293`*^9, 3.627714692817404*^9}]
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
    "]"}]}]}]], "Input",
 CellChangeTimes->{{3.6125198947543917`*^9, 3.612519940111986*^9}, 
   3.6125199759080334`*^9, {3.6125200142152243`*^9, 3.6125200423968363`*^9}, {
   3.6136647272824135`*^9, 3.613664729771556*^9}, 3.6137252075782766`*^9, {
   3.613734279559164*^9, 3.6137342830603647`*^9}, {3.6277145056686997`*^9, 
   3.627714511307022*^9}}],

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
  Ticks->{Automatic, Automatic}]], "Output",
 CellChangeTimes->{
  3.61372521025743*^9, 3.6137306339136453`*^9, 3.6137309790223846`*^9, 
   3.613731166289095*^9, 3.613731365124468*^9, 3.613731457790768*^9, 
   3.613731932167901*^9, 3.613732032757654*^9, 3.613732588529443*^9, 
   3.613733231318208*^9, 3.6137336079397497`*^9, 3.6137339367965593`*^9, 
   3.6137340256026387`*^9, {3.6137342649853306`*^9, 3.61373428351139*^9}, 
   3.6137345104873724`*^9, 3.613734576517149*^9, 3.613735264471498*^9, 
   3.613736525980652*^9, 3.6137371858813963`*^9, 3.6137596254674845`*^9, 
   3.6137600842357244`*^9, 3.6137601345566025`*^9, 3.6137601791901555`*^9, 
   3.613760660870706*^9, 3.61376175785645*^9, 3.6137618266663857`*^9, 
   3.6137622902779026`*^9, 3.6137625043371463`*^9, 3.6137630213107157`*^9, 
   3.613763159149599*^9, 3.613763600336834*^9, 3.6161759829449525`*^9, {
   3.6277145037675915`*^9, 3.6277145127091026`*^9}, 3.6277146929844136`*^9}]
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
 RowBox[{"Dimensions", "[", "%", "]"}]}], "Input",
 CellChangeTimes->{{3.6125201034323273`*^9, 3.6125201069985313`*^9}, {
  3.6137252304155827`*^9, 3.6137252411071944`*^9}}],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"65", ",", "8", ",", "16", ",", "32", ",", "3"}], "}"}]], "Output",
 CellChangeTimes->{
  3.6125201096436825`*^9, 3.6125208065075407`*^9, 3.612849674395951*^9, 
   3.6128623753664045`*^9, 3.612862777618412*^9, 3.612863418453066*^9, 
   3.6128634708600636`*^9, 3.612863530004446*^9, 3.6136647340568013`*^9, 
   3.6137252725289917`*^9, 3.6137306688986464`*^9, 3.6137310129963274`*^9, 
   3.613731198258924*^9, 3.6137313981593575`*^9, 3.613731490142619*^9, 
   3.613731964354742*^9, 3.6137320647904863`*^9, 3.613732620603277*^9, 
   3.613733244233947*^9, 3.613733332183977*^9, 3.6137336170652714`*^9, 
   3.613733945708069*^9, 3.613734035654214*^9, {3.6137342786491117`*^9, 
   3.6137342929809318`*^9}, 3.6137345204639435`*^9, 3.61373458842183*^9, 
   3.6137352735920196`*^9, 3.6137353697345185`*^9, 3.613736535615203*^9, 
   3.6137371950059185`*^9, 3.613759633470942*^9, 3.6137600932102375`*^9, 
   3.61376014587425*^9, 3.613760188346679*^9, 3.6137606702882442`*^9, 
   3.6137617669429693`*^9, 3.6137618355978966`*^9, 3.613762298306362*^9, 
   3.6137625124156084`*^9, 3.613763029376177*^9, 3.6137631674550743`*^9, 
   3.6137636161007357`*^9, 3.6161759998110943`*^9, 3.627714537948546*^9, 
   3.6277147114074674`*^9}]
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
    "]"}]}]}]], "Input",
 CellChangeTimes->{{3.6125201956536016`*^9, 3.6125203532906184`*^9}, 
   3.613664751925823*^9, 3.613725248049591*^9, {3.613732081260429*^9, 
   3.6137320980453887`*^9}, 3.6137326797836623`*^9, {3.6137381667985015`*^9, 
   3.6137381742269263`*^9}, 3.6137618416062403`*^9, 3.6277145343833423`*^9}],

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
  Ticks->{Automatic, Automatic}]], "Output",
 CellChangeTimes->{
  3.613725273465045*^9, 3.6137306715417976`*^9, 3.613731013952382*^9, 
   3.613731199180977*^9, 3.613731399047408*^9, 3.613731491027669*^9, 
   3.6137319652537937`*^9, {3.613732065830546*^9, 3.613732085371664*^9}, 
   3.6137326214343247`*^9, 3.6137326811357393`*^9, 3.6137332483021793`*^9, 
   3.6137333337410665`*^9, 3.6137336210575*^9, 3.613733945957083*^9, 
   3.613734038460374*^9, 3.6137342947900352`*^9, {3.613734522046034*^9, 
   3.613734525934256*^9}, 3.613734591895029*^9, 3.613735273832033*^9, 
   3.6137353707775784`*^9, {3.613736540572487*^9, 3.613736555720353*^9}, 
   3.613737195247932*^9, 3.6137381752429843`*^9, 3.613759633832963*^9, 
   3.6137600947233243`*^9, 3.61376014989348*^9, 3.6137601904277983`*^9, 
   3.6137606758185606`*^9, 3.6137617679450274`*^9, {3.6137618365989537`*^9, 
   3.6137618458064804`*^9}, 3.61376229862138*^9, 3.613762512707625*^9, 
   3.613763029652192*^9, 3.6137631677350903`*^9, 3.6137636166197653`*^9, 
   3.6161760003661647`*^9, 3.6277145415917544`*^9, 3.6277147119805*^9}]
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
 RowBox[{"Dimensions", "[", "%", "]"}]}], "Input",
 CellChangeTimes->{{3.6125201034323273`*^9, 3.6125201069985313`*^9}, {
  3.612520388082608*^9, 3.612520395487032*^9}, {3.6137252819365296`*^9, 
  3.613725291648085*^9}}],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"65", ",", "8", ",", "16", ",", "32"}], "}"}]], "Output",
 CellChangeTimes->{3.6125203992582474`*^9, 3.612520808627662*^9, 
  3.612849684053503*^9, 3.6128623801556787`*^9, 3.6128627824106865`*^9, 
  3.61286342499444*^9, 3.6128634757843447`*^9, 3.6128635349197273`*^9, 
  3.613664765598605*^9, 3.613725384695407*^9, 3.613762322641754*^9, 
  3.6137625367089977`*^9, 3.613763053647565*^9, 3.6137631920194798`*^9, 
  3.6137636636534553`*^9, 3.616176050839574*^9, 3.6277145984950094`*^9, 
  3.627714766818637*^9}]
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
 RowBox[{"Dimensions", "[", "%", "]"}]}], "Input",
 CellChangeTimes->{{3.6125201034323273`*^9, 3.6125201069985313`*^9}, {
  3.612520388082608*^9, 3.612520395487032*^9}, {3.6125204686152143`*^9, 
  3.6125204724194317`*^9}, {3.613725296900386*^9, 3.6137253038387823`*^9}}],

Cell[BoxData[
 RowBox[{"{", 
  RowBox[{"65", ",", "8", ",", "16", ",", "32"}], "}"}]], "Output",
 CellChangeTimes->{3.6125204745445538`*^9, 3.6125208099267364`*^9, 
  3.6128496882047405`*^9, 3.6128623834308662`*^9, 3.6128627856818733`*^9, 
  3.6128634287256536`*^9, 3.6128634790645323`*^9, 3.612863538168913*^9, 
  3.613664769059803*^9, 3.6137254500481453`*^9, 3.613762553634966*^9, 
  3.613763070715541*^9, 3.613763209060454*^9, 3.6137636972503767`*^9, 
  3.616176084809888*^9, 3.627714803928759*^9}]
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
    "]"}]}]}]], "Input",
 CellChangeTimes->{{3.6125201956536016`*^9, 3.6125203532906184`*^9}, {
   3.612520432996177*^9, 3.6125204470929832`*^9}, {3.612520477887745*^9, 
   3.6125204929226046`*^9}, {3.6136647789893713`*^9, 3.6136647792043834`*^9}, 
   3.6137253102831507`*^9, 3.613763055174652*^9, {3.6277148111031694`*^9, 
   3.6277148180735683`*^9}}],

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
  Ticks->{Automatic, Automatic}]], "Output",
 CellChangeTimes->{
  3.613725450326161*^9, 3.613762553739972*^9, {3.6137630708415484`*^9, 
   3.6137630791100216`*^9}, 3.6137632091904616`*^9, 3.613763697447388*^9, 
   3.616176085018914*^9, 3.627714624963523*^9, {3.6277148041257706`*^9, 
   3.627714819095627*^9}}]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Visualize results", "Section",
 CellChangeTimes->{{3.5663120301619015`*^9, 3.566312054543296*^9}, {
  3.569143331228362*^9, 3.5691433346665587`*^9}}],

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
    RowBox[{"AnimationRunning", "\[Rule]", "False"}]}], "]"}]}]], "Input",
 CellChangeTimes->CompressedData["
1:eJwdxVsoQ3EAB+CTtCXW5LpMDfFA8uDBrayOB9uDcskmITqMXGJGhpfVSDrL
HqzlktzV3B7cEiFphmLK01JqzSWOIbdiZTm//8PXF8+0lWgCKIqS8bB/mrM6
RjnaZ+2YxHk3zjns8ghtOFRk3cP7qYuH+OfKYsdqj+YYB0rkfzi7zOnHBgv7
kjzG0fK7m1dszhV84tO+/C9skM6JU/gF1DfZJeqOxrNv4+S9i+UinN5VUYx7
+51qLK31lmNzxH41bm1ga7AyY6gev4e5m/FDtlOLc0qfdFj3OLA26+VohTdm
Bx9tbxzM8ycEuMniNMEnlqrE5PWN0vIF/mu2kjy8a9Jgt2Wc/BFX1YiLLrVk
G3vfjmUrJj2un/hSbfIfLn2TvfbbDiyvVelxlSnIiP0iPZkJOWFxDxNuxmeD
1C9uyjL6cEGNJHaLv6UuhuxS3IsL3zl6xGwPxZkvTGKx8Jk+j+pOxp0SZRp2
TJWQ/asz1TgpOJLB//atDyM=
  "]],

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
  Manipulate`InterpretManipulate[1]]], "Output",
 CellChangeTimes->{
  3.6137625833356647`*^9, 3.6137626513125525`*^9, 3.61376307087255*^9, 
   3.6137632092154627`*^9, {3.613763530457837*^9, 3.613763540790428*^9}, 
   3.6137636974773903`*^9, 3.613763809664807*^9, 3.6161760850544186`*^9, 
   3.616176264641223*^9, {3.6277148282021475`*^9, 3.627714871453622*^9}, 
   3.627714932470112*^9, 3.627715345953685*^9}]
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
    RowBox[{"AnimationRunning", "\[Rule]", "False"}]}], "]"}]}]], "Input",
 CellChangeTimes->CompressedData["
1:eJwdxU0oQwEAB/BnYVpZWyuT21ao+cjmo2UOXjn4OKhFoUmxlbWYMeUrxNLU
bDOaj7SWnRQnSw6jZO2w3IYZtbSoeQ2LaLU3ef93+PWTDBvVOg5BEGUMLG2m
gns7FGnumwxh3+BR4T7z+aaJi82n68QBM79zhoMjFiUX06q8IuyjTEIcvppl
n6hOSvBXuUaKfzSuKuwtUMmxoqO4Ea81tSmx8e6ZxHqtoAsnE+JsaJciU5cG
Gl9/VJb0UBR5okiIMX3Gs2F3hs/+YPdoe5nTFU86vPzN/cUEz8Uui6d1OWan
KMte7yiNWFIUuREbuMXCt8DQIbNVZBjBuYB8FG+ru/W4fdUxhr33C+M4KPBM
4VbSasb2sHMORxv481gQ/VvELe+5JUxrMltYVqty4/6aYx9eifnZX/PrHv3M
cetNHDunuS84a7v4xP8D2e3V
  "]],

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
  Manipulate`InterpretManipulate[1]]], "Output",
 CellChangeTimes->{
  3.6137259140186825`*^9, 3.613731081697257*^9, 3.6137316896790314`*^9, 
   3.6137625538529787`*^9, 3.6137630709785566`*^9, 3.613763209267466*^9, {
   3.613763288566002*^9, 3.61376331879473*^9}, {3.613763381351309*^9, 
   3.613763454694504*^9}, 3.613763697614398*^9, 3.616176085103425*^9, 
   3.6277149385594597`*^9}]
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
    RowBox[{"AnimationRunning", "\[Rule]", "False"}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.5697603192093086`*^9, 3.5697604050462184`*^9}, {
   3.5699639703899965`*^9, 3.569964025088125*^9}, {3.6137621686509457`*^9, 
   3.613762190278183*^9}, 3.61376226207329*^9, {3.61376275425144*^9, 
   3.613762777407765*^9}, {3.6137634661271577`*^9, 3.613763466183161*^9}, {
   3.613763847047945*^9, 3.6137638538233323`*^9}}],

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
  Manipulate`InterpretManipulate[1]]], "Output",
 CellChangeTimes->{
  3.5697604327188015`*^9, 3.5699640436011844`*^9, 3.61376255440201*^9, 
   3.613762778277815*^9, 3.613763071113564*^9, 3.613763209403474*^9, 
   3.6137634668631997`*^9, 3.613763697777407*^9, {3.6137638477589855`*^9, 
   3.613763854922395*^9}, 3.616176085251444*^9, 3.6277149673181047`*^9}]
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
    RowBox[{"AnimationRunning", "\[Rule]", "False"}]}], "]"}]}]], "Input",
 CellChangeTimes->{{3.5697603192093086`*^9, 3.5697604050462184`*^9}, {
   3.5699639703899965`*^9, 3.569964025088125*^9}, {3.6137621686509457`*^9, 
   3.613762190278183*^9}, 3.61376226207329*^9, {3.61376275425144*^9, 
   3.613762777407765*^9}, {3.6137634661271577`*^9, 3.613763512525811*^9}, {
   3.613763835194267*^9, 3.613763835262271*^9}, {3.6137638654649982`*^9, 
   3.6137638667850738`*^9}}],

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
  Manipulate`InterpretManipulate[1]]], "Output",
 CellChangeTimes->{{3.6137634922636523`*^9, 3.613763512990838*^9}, 
   3.6137636978144093`*^9, 3.613763836221326*^9, 3.6137638674641123`*^9, 
   3.616176085293449*^9, 3.627714978066719*^9}]
}, Open  ]]
}, Open  ]],

Cell[CellGroupData[{

Cell["Clean up", "Section",
 CellChangeTimes->{{3.5663120301619015`*^9, 3.566312039004407*^9}, {
  3.566312191907153*^9, 3.56631219255719*^9}}],

Cell[BoxData[
 RowBox[{
  RowBox[{"Uninstall", "[", "lbmLink", "]"}], ";"}]], "Input",
 CellChangeTimes->{{3.5662449963646784`*^9, 3.566245000138894*^9}, {
   3.566245116010522*^9, 3.5662451231389294`*^9}, 3.569143280850481*^9, 
   3.6277037535715523`*^9}]
}, Open  ]]
}, Open  ]]
},
WindowSize->{1058, 1125},
WindowMargins->{{Automatic, 0}, {Automatic, 0}},
ShowSelection->True,
FrontEndVersion->"10.0 for Microsoft Windows (64-bit) (July 1, 2014)",
StyleDefinitions->"Default.nb"
]
(* End of Notebook Content *)

(* Internal cache information *)
(*CellTagsOutline
CellTagsIndex->{
 "Info3627718291-6212165"->{
  Cell[90654, 1841, 283, 5, 40, "Print",
   CellTags->"Info3627718291-6212165"]}
 }
*)
(*CellTagsIndex
CellTagsIndex->{
 {"Info3627718291-6212165", 139823, 3030}
 }
*)
(*NotebookFileOutline
Notebook[{
Cell[CellGroupData[{
Cell[1486, 35, 291, 4, 90, "Title"],
Cell[1780, 41, 1070, 21, 258, "Text"],
Cell[2853, 64, 243, 5, 31, "Input"],
Cell[3099, 71, 555, 10, 31, "Input"],
Cell[3657, 83, 529, 14, 52, "Input"],
Cell[CellGroupData[{
Cell[4211, 101, 609, 8, 63, "Section"],
Cell[CellGroupData[{
Cell[4845, 113, 2148, 63, 92, "Input"],
Cell[6996, 178, 310, 4, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[7343, 187, 579, 14, 31, "Input"],
Cell[7925, 203, 301, 7, 210, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[8263, 215, 650, 18, 52, "Input"],
Cell[8916, 235, 340, 5, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[9293, 245, 390, 9, 72, "Input"],
Cell[9686, 256, 879, 13, 31, "Output"],
Cell[10568, 271, 824, 11, 31, "Output"]
}, Open  ]],
Cell[11407, 285, 1460, 40, 67, "Input"],
Cell[12870, 327, 235, 5, 31, "Input"],
Cell[13108, 334, 1256, 30, 46, "Input"],
Cell[14367, 366, 1578, 39, 75, "Input"],
Cell[15948, 407, 1492, 35, 46, "Input"],
Cell[CellGroupData[{
Cell[17465, 446, 749, 17, 52, "Input"],
Cell[18217, 465, 1086, 15, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[19340, 485, 925, 23, 52, "Input"],
Cell[20268, 510, 1224, 20, 31, "Output"]
}, Open  ]],
Cell[21507, 533, 649, 16, 72, "Input"]
}, Open  ]],
Cell[CellGroupData[{
Cell[22193, 554, 568, 7, 63, "Section"],
Cell[22764, 563, 605, 14, 72, "Input"],
Cell[23372, 579, 904, 29, 72, "Input"],
Cell[24279, 610, 311, 6, 49, "Text"],
Cell[CellGroupData[{
Cell[24615, 620, 3263, 79, 146, "Input"],
Cell[27881, 701, 925, 14, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[28843, 720, 2052, 44, 72, "Input"],
Cell[30898, 766, 2562, 50, 418, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[33497, 821, 2092, 48, 72, "Input"],
Cell[35592, 871, 51340, 863, 402, "Output"]
}, Open  ]],
Cell[86947, 1737, 515, 14, 31, "Input"],
Cell[87465, 1753, 796, 19, 52, "Input"]
}, Open  ]],
Cell[CellGroupData[{
Cell[88298, 1777, 148, 2, 63, "Section"],
Cell[88449, 1781, 191, 5, 31, "Input"],
Cell[88643, 1788, 609, 13, 52, "Input"],
Cell[89255, 1803, 261, 6, 31, "Input"],
Cell[CellGroupData[{
Cell[89541, 1813, 337, 9, 52, "Input"],
Cell[89881, 1824, 609, 8, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[90527, 1837, 124, 2, 31, "Input"],
Cell[90654, 1841, 283, 5, 40, "Print",
 CellTags->"Info3627718291-6212165"]
}, Open  ]],
Cell[90952, 1849, 1059, 25, 31, "Input"],
Cell[CellGroupData[{
Cell[92036, 1878, 398, 8, 72, "Input"],
Cell[92437, 1888, 915, 14, 31, "Output"],
Cell[93355, 1904, 926, 14, 31, "Output"],
Cell[94284, 1920, 913, 14, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[95234, 1939, 339, 9, 52, "Input"],
Cell[95576, 1950, 790, 11, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[96403, 1966, 702, 17, 52, "Input"],
Cell[97108, 1985, 1625, 33, 31, "Output"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[98782, 2024, 214, 3, 63, "Section"],
Cell[CellGroupData[{
Cell[99021, 2031, 937, 27, 52, "Input"],
Cell[99961, 2060, 1188, 17, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[101186, 2082, 1245, 33, 72, "Input"],
Cell[102434, 2117, 2499, 52, 238, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[104970, 2174, 937, 27, 52, "Input"],
Cell[105910, 2203, 1253, 19, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[107200, 2227, 1891, 52, 92, "Input"],
Cell[109094, 2281, 2922, 59, 235, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[112053, 2345, 1018, 29, 52, "Input"],
Cell[113074, 2376, 547, 9, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[113658, 2390, 1065, 29, 52, "Input"],
Cell[114726, 2421, 501, 8, 31, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[115264, 2434, 2017, 55, 92, "Input"],
Cell[117284, 2491, 2141, 49, 248, "Output"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[119474, 2546, 155, 2, 63, "Section"],
Cell[CellGroupData[{
Cell[119654, 2552, 1922, 48, 72, "Input"],
Cell[121579, 2602, 2613, 51, 498, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[124229, 2658, 3016, 76, 112, "Input"],
Cell[127248, 2736, 3188, 65, 502, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[130473, 2806, 1705, 42, 72, "Input"],
Cell[132181, 2850, 2581, 51, 498, "Output"]
}, Open  ]],
Cell[CellGroupData[{
Cell[134799, 2906, 1754, 43, 72, "Input"],
Cell[136556, 2951, 2462, 49, 498, "Output"]
}, Open  ]]
}, Open  ]],
Cell[CellGroupData[{
Cell[139067, 3006, 143, 2, 63, "Section"],
Cell[139213, 3010, 256, 5, 31, "Input"]
}, Open  ]]
}, Open  ]]
}
]
*)

(* End of internal cache information *)

(* NotebookSignature cwpv4rJqam#gqCgELV0dmCwb *)
