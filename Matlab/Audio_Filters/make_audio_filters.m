%pkg load signal

FR=7056000; %Most clocks are this or a fraction of this

% We'll need a list of frequencies for our plots
freqs = 2*logspace(1,5,1001);
leg_labels={};
tf=[];



%Here's a filter
fname='LPF 20khz 3rd BW';
descript='LPF 20khz 3rd Order Butterworth';
fs=7056000; Nyquist=fs/2;
[b,a]=butter(3,20000/Nyquist);
write_filter(b,a,fname,descript,fs);
leg_labels{end+1} = fname;
[h,w]=freqz(b,a,freqs,fs);
tf(end+1,:)=mag2db(abs(h));

%Here's a filter
fname='LPF 20khz 2nd BW';
descript='LPF 20khz 2nd Order Butterworth';
fs=7056000; Nyquist=fs/2;
[b,a]=butter(2,20000/Nyquist);
write_filter(b,a,fname,descript,fs);
leg_labels{end+1} = fname;
[h,w]=freqz(b,a,freqs,fs);
tf(end+1,:)=mag2db(abs(h));

%Here's a filter
fname='LPF 20khz 3rd CH 1db';
descript='LPF 20khz 3rd Order Chebyshev 1db Ripple';
fs=7056000; Nyquist=fs/2;
[b,a]=cheby1(3,1,20000/Nyquist);
write_filter(b,a,fname,descript,fs);
leg_labels{end+1} = fname;
[h,w]=freqz(b,a,freqs,fs);
tf(end+1,:)=mag2db(abs(h));

%Here's a filter
fname='LPF 18khz 3rd CH 1db';
descript='LPF 18khz 3rd Order Chebyshev 1db Ripple';
fs=7056000; Nyquist=fs/2;
[b,a]=cheby1(3,1,18000/Nyquist);
write_filter(b,a,fname,descript,fs);
leg_labels{end+1} = fname;
[h,w]=freqz(b,a,freqs,fs);
tf(end+1,:)=mag2db(abs(h));

%Here's a filter
fname='LPF 16khz 3rd CH 1db';
descript='LPF 16khz 3rd Order Chebyshev 1db Ripple';
fs=7056000; Nyquist=fs/2;
[b,a]=cheby1(3,1,16000/Nyquist);
write_filter(b,a,fname,descript,fs);
leg_labels{end+1} = fname;
[h,w]=freqz(b,a,freqs,fs);
tf(end+1,:)=mag2db(abs(h));

%Here's a filter
fname='LPF 10khz 1st + AA';
descript='LPF 10khz 1st Order + Ch 17khz 2nd Order';
fs=7056000; Nyquist=fs/2;
[b1,a1]=butter(1,10000/Nyquist);
[b2,a2]=cheby1(2,1,17000/Nyquist);
b=1.12*conv(b1,b2);
a=conv(a1,a2);
write_filter(b,a,fname,descript,fs);
leg_labels{end+1} = fname;
[h,w]=freqz(b,a,freqs,fs);
tf(end+1,:)=mag2db(abs(h));
%1/max(abs(h))

%Here's a filter
fname='LPF 12khz 1st + AA';
descript='LPF 12khz 1st Order + Ch 17khz 2nd Order';
fs=7056000; Nyquist=fs/2;
[b1,a1]=butter(1,12000/Nyquist);
[b2,a2]=cheby1(2,1.2,17000/Nyquist);
b=1.148*conv(b1,b2);
a=conv(a1,a2);
write_filter(b,a,fname,descript,fs);
leg_labels{end+1} = fname;
[h,w]=freqz(b,a,freqs,fs);
tf(end+1,:)=mag2db(abs(h));
%1/max(abs(h))


%Here's a filter
fname='LPF 14khz 1st + AA';
descript='LPF 14khz 1st Order + Ch 17khz 2nd Order';
fs=7056000; Nyquist=fs/2;
[b1,a1]=butter(1,14000/Nyquist);
[b2,a2]=cheby1(2,1.5,17000/Nyquist);
b=1.1872*conv(b1,b2);
a=conv(a1,a2);
write_filter(b,a,fname,descript,fs);
leg_labels{end+1} = fname;
[h,w]=freqz(b,a,freqs,fs);
tf(end+1,:)=mag2db(abs(h));
%1/max(abs(h))


%Here's a filter
fname='LPF 14khz 1st + AA';
descript='LPF 14khz 1st Order + Ch 17khz 2nd Order';
fs=7056000; Nyquist=fs/2;
[b1,a1]=butter(1,14000/Nyquist);
[b2,a2]=cheby1(2,1.5,17000/Nyquist);
b=1.1872*conv(b1,b2);
a=conv(a1,a2);
write_filter(b,a,fname,descript,fs);
leg_labels{end+1} = fname;
[h,w]=freqz(b,a,freqs,fs);
tf(end+1,:)=mag2db(abs(h));
%1/max(abs(h))


%Here's a filter
fname='LPF 16khz 1st + AA';
descript='LPF 16khz 1st Order + Ch 16khz 2nd Order';
fs=7056000; Nyquist=fs/2;
[b1,a1]=butter(1,16000/Nyquist);
[b2,a2]=cheby1(2,1.8,19000/Nyquist);
b=1.036*1.1872*conv(b1,b2);
a=conv(a1,a2);
write_filter(b,a,fname,descript,fs);
leg_labels{end+1} = fname;
[h,w]=freqz(b,a,freqs,fs);
tf(end+1,:)=mag2db(abs(h));
%1/max(abs(h))


%This plots the frequency response of each filter
semilogx(freqs,tf)
axis([1 48000 -40 6])
grid
legend(leg_labels, 'location','southwest')
print -dpng LPF_AA_Plots.png
print -bestfit -dpdf LPF_AA_Plots.pdf
