function [ch, cv] = calc_sharp_bilinear(nh,nv)

z1=ceil((16-nh)/2);
z2=floor((16-nh)/2);
delta=128/nh;

c1=zeros(16,1);
c2=[128*ones(z1,1); (128:-delta:delta)';  128*zeros(z2,1)];
c3=[128*zeros(z1,1); (0:delta:128-delta)';  128*ones(z2,1)];
c4=zeros(16,1);

ch = [c1 c2 c3 c4];

z1=ceil((16-nv)/2);
z2=floor((16-nv)/2);
delta=128/nv;

c1=zeros(16,1);
c2=[128*ones(z1,1); (128:-delta:delta)';  128*zeros(z2,1)];
c3=[128*zeros(z1,1); (0:delta:128-delta)';  128*ones(z2,1)];
c4=zeros(16,1);

cv = [c1 c2 c3 c4];
