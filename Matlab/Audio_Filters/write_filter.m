function write_filter(B,A,SN,LN,FS)
  

Order = length(B) - 1;
if Order > 3
  error('Filter must be 3rd order or lower');
end
if (Order < 1) || (length(B) ~= length(A))
  error('Bad Filter Input');
end
 
fname = [SN '.txt'];
f=fopen(fname,'wt');

%Prints the original filename (Short Name)
fprintf(f,'#Version\n');
fprintf(f,'v1\n\n',fname);

%Prints the original filename (Short Name)
fprintf(f,'#Original Filename\n');
fprintf(f,'#%s\n\n',fname);

%Prints the description (Long Name)
fprintf(f,'#Filter Description\n');
fprintf(f,'#%s\n\n',strtrim(LN));

%Prints the sample rate (FS)
fprintf(f,'#Sampling Frequency\n');
fprintf(f,'%d\n\n',FS);

%Prints the GAIN
%Note that on this site: https://www-users.cs.york.ac.uk/~fisher/mkfilter/trad.html
%GAIN seems to always be 1/min(b) from my matlab/octave results
fprintf(f,'#Base gain\n');
fprintf(f,'%.20f\n\n',1.39*sum(B));

%Prints X Coefficients. Zeros if filter is Order < 3
for i=1:3
  fprintf(f,'#gain scale for X%d\n',i-1);
  if i <= Order
    fprintf(f,'%d\n\n',round(B(i+1)/min(B)));
  else
    fprintf(f,'0\n\n');
  end
end

%Prints Y Coefficients. Zeros if filter is Order < 3
for i=1:3
  fprintf(f,'#gain scale for Y%d\n',i-1);
  if i <= Order
    fprintf(f,'%.20f\n\n',A(i+1));
  else
    fprintf(f,'0\n\n');
  end
end

fclose(f);