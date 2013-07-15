set terminal gif
set output "/tmp/temp_humidity.gif"
set autoscale
set title "Temperature/Humidity Readings"
set yrange [0:100] noreverse nowriteback
show yrange
set y2range [0:30] noreverse nowriteback
set y2tics
show y2range
set ylabel "Humidity %"
set y2label "Temperature (C)"
plot "/tmp/temp_humidity.dat" using 1:5 axes x1y1 title 'Humidity' with lines, \
     "/tmp/temp_humidity.dat" using 1:6 axes x1y2 title 'Temperature' with lines 
