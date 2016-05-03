#! /bin/bash

current_script_dir=`dirname $0`
dest_file="$current_script_dir/Drives.ini"

white_theme_color="215,215,215,200"
white_theme_bg="Background-white.png"
black_theme_color="55,55,55,200"
black_theme_bg="Background-black.png"

theme_color=$white_theme_color
theme_bg=$white_theme_bg

if [ "$1" == "-b" ]; then
	theme_color=$black_theme_color
	theme_bg=$black_theme_bg
fi

####################################
###            HEADER            ###
####################################
echo "[Rainmeter]
Author=Farigh
Update=500
Background=${theme_bg}
BackgroundMode=3
BackgroundMargins=24,24,14,21

[Metadata]
Name=\"Drives infos\"
Information=
License=
Version=1.0

;=============== VARIABLES
[Variables]
Color=${theme_color}
FontHeight=10
FontFamily=\"Courier New\"
Height=15

;Disks
Disk0=A
Disk1=B
Disk2=C
Disk3=D
Disk4=E
Disk5=F
Disk6=G
Disk7=H
Disk8=I
Disk9=J
Disk10=K
Disk11=L
Disk12=M
Disk13=N
Disk14=O
Disk15=P
Disk16=Q
Disk17=R
Disk18=S
Disk19=T
Disk20=U
Disk21=V
Disk22=W
Disk23=X
Disk24=Y
Disk25=Z

;================================================
;===           General meters Style           ===
;================================================
[MeterImageStyle]
X=10
Y=20r
H=50
W=50
PreserveAspectRatio=1
ImageName=Fixed-disk.png

[MeterImageStyle2]
X=10
Y=20r
H=50
W=50
PreserveAspectRatio=1
ImageName=Removable-disk.png

[MeterNoStyle]
X=0
Y=r
H=0
W=0

[MeterLabelStyle]
X=60r
Y=r
FontSize=#FontHeight#
FontFace=#FontFamily#
FontColor=#Color#
AntiAlias=1
AutoScale=1
StringStyle=Bold

[MeterTextStyle]
X=60r
Y=R
FontSize=#FontHeight#
FontFace=#FontFamily#
FontColor=#Color#
AntiAlias=1
AutoScale=1
StringStyle=Bold
StringAlign=Right

[MeterTotalTextStyle]
X=r
Y=r
FontSize=#FontHeight#
FontFace=#FontFamily#
FontColor=#Color#
AntiAlias=1
AutoScale=1
StringStyle=Bold
StringAlign=Left

[MeterImageBarStyle]
X=70
Y=R
W=204
H=14
BarImage=bar.png
BarOrientation=Horizontal
AntiAlias=1
AutoScale=1

[MeterImageBgBarStyle]
X=r
Y=r
W=204
H=14
BarImage=bar-bg.png
BarOrientation=Horizontal
AntiAlias=1
AutoScale=1
Flip=1

;================================================
;===             Specific settings            ===
;================================================

"  > "$dest_file"

for drive_nb in {0..25}; do
	echo ";=============== Measures HDD ${drive_nb}
[MeasureHDD${drive_nb}Label]
Measure=FreeDiskSpace
Drive=#Disk${drive_nb}#:
Label=1
UpdateDivider=5
IgnoreRemovable=0

[MeasureHDD${drive_nb}Total]
Measure=FreeDiskSpace
Drive=#Disk${drive_nb}#:
Total=1
UpdateDivider=5
IgnoreRemovable=0

[MeasureHDD${drive_nb}Used]
Measure=FreeDiskSpace
Drive=#Disk${drive_nb}#:
UpdateDivider=5
IgnoreRemovable=0

[MeasureHDD${drive_nb}Occupied]
Measure=Calc
Formula=(((MeasureHDD${drive_nb}Used / (0.0000000000000000001 + MeasureHDD${drive_nb}Total))) * 100) + 1
MinValue=0
MaxValue=100

[MeasureHDD${drive_nb}Free]
Measure=FreeDiskSpace
Drive=#Disk${drive_nb}#:
InvertMeasure=1
UpdateDivider=5
IgnoreRemovable=0

[MeasureHDD${drive_nb}Type]
Measure=FreeDiskSpace
Drive=#Disk${drive_nb}#:
Type=1
UpdateDivider=5
IgnoreRemovable=0
; Removable drive
IfCondition=MeasureHDD${drive_nb}Type = 3
IfTrueAction=[!SetOption MeterHDD${drive_nb}Image MeterStyle MeterImageStyle2]
; Fixed drive
IfCondition2=MeasureHDD${drive_nb}Type = 4
IfTrueAction2=[!SetOption MeterHDD${drive_nb}Image MeterStyle MeterImageStyle]

; Manage visibility
[HDD${drive_nb}Label]
Measure=Calc
Formula=[MeasureHDD${drive_nb}Label]

[HDD${drive_nb}Hide]
Measure=Calc
Formula=(MeasureHDD${drive_nb}Total > 0 || HDD${drive_nb}Label > 0 ? 1 : 0)
IfBelowValue=1
IfBelowAction=!execute [!RainmeterHideMeterGroup HDD${drive_nb}][!SetOption MeterHDD${drive_nb}Image MeterStyle MeterNoStyle][!SetOption MeterHDD${drive_nb}Label MeterStyle MeterNoStyle]
IfAboveValue=0
IfAboveAction=!execute [!RainmeterShowMeterGroup HDD${drive_nb}][!SetOption MeterHDD${drive_nb}Label MeterStyle MeterLabelStyle]

; Display settings
[MeterHDD${drive_nb}Image]
Meter=Image
MeterStyle=MeterImageStyle
LeftMouseDownAction=!Execute [\"#Disk${drive_nb}#:\\\"]
Group=HDD${drive_nb}

[MeterHDD${drive_nb}Label]
Meter=String
MeasureName=MeasureHDD${drive_nb}Label
MeterStyle=MeterLabelStyle
Text=#Disk${drive_nb}#: %1
Group=HDD${drive_nb}

[MeterHDD${drive_nb}Text]
Meter=String
MeasureName=MeasureHDD${drive_nb}Free
MeterStyle=MeterTextStyle
Text=%1o
Group=HDD${drive_nb}

[MeterHDD${drive_nb}TotalText]
Meter=String
MeasureName=MeasureHDD${drive_nb}Total
MeterStyle=MeterTotalTextStyle
Text=/ %1o
Group=HDD${drive_nb}

[MeterHDD${drive_nb}Bar]
Meter=Bar
MeasureName=MeasureHDD${drive_nb}Free
MeterStyle=MeterImageBarStyle
Group=HDD${drive_nb}

[MeterHDD${drive_nb}BarBg]
Meter=Bar
MeasureName=MeasureHDD${drive_nb}Occupied
MeterStyle=MeterImageBgBarStyle
Group=HDD${drive_nb}
" >> "$dest_file"
done