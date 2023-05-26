#!/bin/bash

source /home/script/setVars.sh
TIMESTAMP=$(date +"%d-%m-%Y %H:%M:%S UTC")
SOURCEIMAGE=$1
OUTPATH=$2

LEVEL=$4
ALERT_LEVEL=$5

if [ "$LEVEL" != "" ];then
  LOCATION=$3" *** Lev="$LEVEL" m - Alert Level="$ALERT_LEVEL
else
  LOCATION=$3
fi

EC_LOGO='/home/script/logo_en.gif'
ORG1_LOGO='/home/script/mmaf.png'
ORG2_LOGO='/home/script/yats.png'
ORG3_LOGO='/home/script/logo_big.png'

ORG1=true
ORG2=true
if [ "$ORG1_LOGO" = "" ];then ORG1=false; else ORG1=true; fi
if [ "$ORG2_LOGO" = "" ];then ORG2=false; else ORG2=true; fi
if [ "$ORG3_LOGO" = "" ];then ORG3=false; else ORG3=true; fi

REFERENCEIMAGEW=1280
REFERENCEIMAGEH=960
ImageWidth=$(identify -format '%[fx:w]' $SOURCEIMAGE)
ImageHeight=$(identify -format '%[fx:h]' $SOURCEIMAGE)
#--calculating scale parameters
SCALEW=$(echo "scale=2;$ImageWidth/$REFERENCEIMAGEW" | bc)
SCALEH=$(echo "scale=2;$ImageHeight/$REFERENCEIMAGEH" | bc)

#--SCALING
ROUND=$(echo "scale=0;5*$SCALEW" | bc)
TEXTSIZE=$(echo "scale=0;20*$SCALEW" | bc)
##--date text position
DateTextTop=$(echo "scale=0;10*$SCALEH" | bc)
DateTextLeft=$(echo "scale=0;25*$SCALEW" | bc)
##--date rectangle
TextLenght=$(echo -n "$TIMESTAMP - $LOCATION" | wc -c)
DateRectTop=$(echo "scale=0;0-$ROUND" | bc)
DateRectRight=$(echo "scale=0;1150*$SCALEW" | bc)
DateRectBottom=$(echo "scale=0;35*$SCALEH" | bc)
DateRectLeft=$(echo "scale=0;0-$ROUND" | bc)

##--logo rectangle
LogoRectLeft=$(echo "scale=0;1150*$SCALEW" | bc)
echo $LogoRectLeft
if [ "$ORG2" = true ] ; then
  LogoRectLeft=$(echo "scale=0;1067*$SCALEW" | bc)
  DateRectRight=$(echo "scale=0;1067*$SCALEW" | bc)
  echo 'ORG2:' $LogoRectLeft
fi
if [ "$ORG1" = true ] ; then
  LogoRectLeft=$(echo "scale=0;978*$SCALEW" | bc)
  DateRectRight=$(echo "scale=0;978*$SCALEW" | bc)
  echo 'ORG1:' $LogoRectLeft
fi
if [ "$ORG3" = true ] ; then
  LogoRectLeft=$(echo "scale=0;894*$SCALEW" | bc)
  DateRectRight=$(echo "scale=0;894*$SCALEW" | bc)
  echo 'ORG3:' $LogoRectLeft
fi

LogoRectRight=$(echo "scale=0;$ImageWidth+$ROUND" | bc)
LogoRectTop=$(echo "scale=0;0-$ROUND" | bc)
LogoRectBottom=$(echo "scale=0;100*$SCALEH" | bc)

##--ec logo position
LogoECLeft=$(echo "scale=0;1162*$SCALEW" | bc)
LogoECTop=$(echo "scale=0;10*$SCALEH" | bc)
##--ec logo size
LogoECW=$(echo "scale=0;103*$SCALEW" | bc)
LogoECH=$(echo "scale=0;71*$SCALEW" | bc)


#ORG2
if [ "$ORG2" = true ] ; then
##--ORG2 logo position
	LogoORG2Left=$(echo "scale=0;1075*$SCALEW" | bc)
	LogoORG2Top=$(echo "scale=0;10*$SCALEH" | bc)
##--ORG2 logo size
	LogoORG2W=$(echo "scale=0;71*$SCALEW" | bc)
	LogoORG2H=$(echo "scale=0;71*$SCALEW" | bc)
	drawORG2="image over $LogoORG2Left,$LogoORG2Top $LogoORG2W,$LogoORG2H '$ORG2_LOGO'"
else
	drawORG2=''
#	LogoRectLeft=$(echo "scale=0;1151*$SCALEW" | bc)
#	DateRectRight=$(echo "scale=0;1150*$SCALEW" | bc)
fi

# ORG1
if [ "$ORG1" = true ] ; then
	##--ORG1 logo position
	LogoORG1Left=$(echo "scale=0;991*$SCALEW" | bc)
	LogoORG1Top=$(echo "scale=0;10*$SCALEH" | bc)
	##--ORG1 logo size
	LogoORG1W=$(echo "scale=0;71*$SCALEW" | bc)
	LogoORG1H=$(echo "scale=0;71*$SCALEW" | bc)
	drawORG1="image over $LogoORG1Left,$LogoORG1Top $LogoORG1W,$LogoORG1H '$ORG1_LOGO'"
else
	drawORG1=''
#	LogoRectLeft=$(echo "scale=0;1151*$SCALEW" | bc)
#	DateRectRight=$(echo "scale=0;1150*$SCALEW" | bc)
fi 
# ORG3
if [ "$ORG3" = true ] ; then
	##--ORG3 logo position
	LogoORG3Left=$(echo "scale=0;907*$SCALEW" | bc)
	LogoORG3Top=$(echo "scale=0;10*$SCALEH" | bc)
	##--ORG1 logo size
	LogoORG3W=$(echo "scale=0;71*$SCALEW" | bc)
	LogoORG3H=$(echo "scale=0;71*$SCALEW" | bc)
	drawORG3="image over $LogoORG3Left,$LogoORG3Top $LogoORG3W,$LogoORG3H '$ORG3_LOGO'"
else
	drawORG3=''
#	LogoRectLeft=$(echo "scale=0;1151*$SCALEW" | bc)
#	DateRectRight=$(echo "scale=0;1150*$SCALEW" | bc)
fi 
echo "-draw roundRectangle $LogoRectLeft,$LogoRectTop $LogoRectRight,$LogoRectBottom $ROUND,$ROUND" 
mogrify -path $OUTPATH \
	-format jpg \
	-pointsize $TEXTSIZE \
	-fill "rgba(255,255,255,0.5)" \
	-draw "roundRectangle $LogoRectLeft,$LogoRectTop $LogoRectRight,$LogoRectBottom $ROUND,$ROUND" \
	-draw "rectangle $DateRectLeft,$DateRectTop $DateRectRight,$DateRectBottom" \
	-fill "rgba(20,20,20,1)" \
	-draw "text $DateTextTop,$DateTextLeft '$TIMESTAMP - $LOCATION'" \
	-draw "image over $LogoECLeft,$LogoECTop $LogoECW,$LogoECH '$EC_LOGO'" \
	-draw "$drawORG2" \
	-draw "$drawORG1" \
	-draw "$drawORG3" \
	$SOURCEIMAGE

