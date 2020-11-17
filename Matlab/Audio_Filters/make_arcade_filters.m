%pkg load signal

FR=7056000; %Most clocks are this or a fraction of this

% We'll need a list of frequencies for our plots
freqs = 2*logspace(1,5,1001);
leg_labels={};
tf=[];


%Here's a filter
fname='Arcade LPF 2khz 1st';
descript='LPF 2khz 1st Order combined with 2nd order at 20khz';
fs=7056000; Nyquist=fs/2;
[b1,a1]=butter(1,2000/Nyquist);
[b2,a2]=butter(2,20000/Nyquist);
b=conv(b1,b2);
a=conv(a1,a2);
write_filter(b,a,fname,descript,fs);
leg_labels{end+1} = fname;
[h,w]=freqz(b,a,freqs,fs);
tf(end+1,:)=mag2db(abs(h));

%Here's a filter
fname='Arcade LPF 4khz 1st';
descript='LPF 4khz 1st Order combined with 2nd order at 20khz';
fs=7056000; Nyquist=fs/2;
[b1,a1]=butter(1,4000/Nyquist);
[b2,a2]=butter(2,20000/Nyquist);
b=conv(b1,b2);
a=conv(a1,a2);
write_filter(b,a,fname,descript,fs);
leg_labels{end+1} = fname;
[h,w]=freqz(b,a,freqs,fs);
tf(end+1,:)=mag2db(abs(h));

%Here's a filter
fname='Arcade LPF 6khz 1st';
descript='LPF 6khz 1st Order combined with 2nd order at 20khz';
fs=7056000; Nyquist=fs/2;
[b1,a1]=butter(1,6000/Nyquist);
[b2,a2]=butter(2,20000/Nyquist);
b=conv(b1,b2);
a=conv(a1,a2);
write_filter(b,a,fname,descript,fs);
leg_labels{end+1} = fname;
[h,w]=freqz(b,a,freqs,fs);
tf(end+1,:)=mag2db(abs(h));

%Here's a filter
fname='Arcade LPF 8khz 1st';
descript='LPF 8khz 1st Order combined with 2nd order at 20khz';
fs=7056000; Nyquist=fs/2;
[b1,a1]=butter(1,8000/Nyquist);
[b2,a2]=butter(2,20000/Nyquist);
b=conv(b1,b2);
a=conv(a1,a2);
write_filter(b,a,fname,descript,fs);
leg_labels{end+1} = fname;
[h,w]=freqz(b,a,freqs,fs);
tf(end+1,:)=mag2db(abs(h));

%Here's a filter
fname='Arcade LPF 2khz 2nd';
descript='LPF 2khz 2nd Order';
fs=7056000; Nyquist=fs/2;
[b,a]=butter(2,2000/Nyquist);
write_filter(b,a,fname,descript,fs);
leg_labels{end+1} = fname;
[h,w]=freqz(b,a,freqs,fs);
tf(end+1,:)=mag2db(abs(h));

%Here's a filter
fname='Arcade LPF 4khz 2nd';
descript='LPF 4khz 2nd Order';
fs=7056000; Nyquist=fs/2;
[b,a]=butter(2,4000/Nyquist);
write_filter(b,a,fname,descript,fs);
leg_labels{end+1} = fname;
[h,w]=freqz(b,a,freqs,fs);
tf(end+1,:)=mag2db(abs(h));

%Here's a filter
fname='Arcade LPF 6khz 2nd';
descript='LPF 6khz 2nd Order';
fs=7056000; Nyquist=fs/2;
[b,a]=butter(2,6000/Nyquist);
write_filter(b,a,fname,descript,fs);
leg_labels{end+1} = fname;
[h,w]=freqz(b,a,freqs,fs);
tf(end+1,:)=mag2db(abs(h));

%Here's a filter
fname='Arcade LPF 8khz 2nd';
descript='LPF 8khz 2nd Order';
fs=7056000; Nyquist=fs/2;
[b,a]=butter(2,8000/Nyquist);
write_filter(b,a,fname,descript,fs);
leg_labels{end+1} = fname;
[h,w]=freqz(b,a,freqs,fs);
tf(end+1,:)=mag2db(abs(h));



%This plots the frequency response of each filter
semilogx(freqs,tf)
axis([1 48000 -40 6])
grid
legend(leg_labels, 'location','southwest')
print -dpng LPF_Arcade_Plots.png
print -bestfit -dpdf LPF_Arcade_Plots.pdf
