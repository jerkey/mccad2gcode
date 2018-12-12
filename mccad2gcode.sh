[[ -e $1 ]] || exit
cat $1 | tr  \\n > /tmp/mccad2gcode
DRILLS=$(cat /tmp/mccad2gcode | cut -f 4 | sort | uniq)
for i in $DRILLS; do grep "$i\$" /tmp/mccad2gcode > /tmp/mccad2gcode.$i ; done
rm /tmp/mccad2gcode.*.gcode
for i in $DRILLS
 do while read j
  do X=$(echo $j | cut -d" " -f2) # apparently read changed tabs to spaces
  Y=$(echo $j | cut -d" " -f3)
  #echo line is $j x is $X y is $Y
  echo G00 X0$(awk "BEGIN {print ($X)/1000}") Y0$(awk "BEGIN {print ($Y)/1000}") >> /tmp/mccad2gcode.$i.gcode
  echo M98 Psub00 >> /tmp/mccad2gcode.$i.gcode
  done </tmp/mccad2gcode.$i
 done
cp rabheader.fgc /tmp/mccad2gcode.fgc
for i in $DRILLS; do echo -e M00 \(insert drill $i\) >> /tmp/mccad2gcode.fgc; cat /tmp/mccad2gcode.$i.gcode >> /tmp/mccad2gcode.fgc; done
cat rabfooter.fgc >> /tmp/mccad2gcode.fgc
cp /tmp/mccad2gcode.fgc $1.fgc
less $1.fgc
