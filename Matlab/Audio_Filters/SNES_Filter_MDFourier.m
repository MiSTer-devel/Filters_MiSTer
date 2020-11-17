%Code to try to match the real SNES response curve

%signal package need for Octave but not matlab
%pkg load signal

%This should be the response of an earlier filter
%measured with MDFourier.  You can generate a CSV from MDFourier
%but you need to open in a spreadsheet and pull out just the rows you
%want. And sort the row by frequency,
M=csvread('SNES_Old_Filter.csv');
xt=M(:,1);
yt=smoothdata(M(:,2),'gaussian',150)+1.35;

% We'll need a list of frequencies for our plots
freqs = 2*logspace(1,5,1001);
leg_labels={};
tf=[];
    
%Here's the old snes filter I made
fname='SNES Old Filter';
descript='SNES Old Filter';
fs=6144000; Nyquist=fs/2;
[b1,a1]=butter(1,6100/Nyquist);
[b2,a2]=cheby1(2,0.3,9800/Nyquist);
b=1.03514*conv(b1,b2);
%b=1.0*conv(b1,b2);
a=conv(a1,a2);
write_filter(b,a,fname,descript,fs);
leg_labels{end+1} = fname;
[h,w]=freqz(b,a,freqs,fs);
tf(end+1,:)=mag2db(abs(h));
fprintf('Max Gain of filter %s is %d\n', fname,max(tf(end,:)));

%Here's the new snes filter I made
fname='SNES Newer Filter';
descript='SNES Newer Filter';
fs=6144000; Nyquist=fs/2;
[b1,a1]=butter(1,5500/Nyquist);
[b2,a2]=cheby1(2,1.4,14650/Nyquist);
b=1.17490*conv(b1,b2);
%b=1.0*conv(b1,b2);
a=conv(a1,a2);
write_filter(b,a,fname,descript,fs);
leg_labels{end+1} = fname;
[h,w]=freqz(b,a,freqs,fs);
tf(end+1,:)=mag2db(abs(h));
fprintf('Max Gain of filter %s is %d\n', fname,max(tf(end,:)));


%I'm subtracting the response of the two filters above to get the
%difference DIFF. That difference is added to the measured MDFourier
%response to predict the response of the new filter.  You have to use
%SPLINE because the MDFourier results and my results were meaured at
%differnt frequency values so you can't just add the vectors.
DIFF=spline(freqs,(tf(end,:)-tf(end-1,:)),xt);


%This plots the frequency response of each filter + predicted MDFourier
semilogx(freqs,tf,xt,yt,xt,yt+DIFF);
axis([1 40000 -12 3]);
grid;
legend([leg_labels 'Predicted MDFourier (Old Filter)' 'Predicted MDFourier (New Filter)'], 'location','southwest');
print -dpng SNES_Filter_Plot.png
print -bestfit -dpdf SNES_Filter_Plot.pdf
