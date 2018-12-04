%% This script was mostly stolen from:
%% http://www.zipcores.com/datasheets/app_note_zc003.pdf
%%
%% This script is supposed to generate the coefficients needed
%% for the polyphase video filter as sorgelig uses it in the
%% miSTer project as of 10/29/2018.
%%
%% The filter is a 16 phase 4-tap filter with T0,T1,T2,T3 taps
%% A phase of 0 is centered on the T1 tap (according to intel docs)
%% and coefficients are from [-128,128]
%%
%%
%% If I understand correctly, this means that:
%%
%% ROW1 of the coefficient list
%% corresponds to the weights for T0,T1,T2,T3 at exactly the position of T1
%%
%% and ROW2 of the coefficients list
%% is the weights for position of T0 + 1/16 * D
%% where D is the distance from T0 to T1
%%
%% and ROW3 of the coefficients list:
%% is the weights for position of T0 + 2/16 * D
%% where D is the distance from T0 to T1
%%
%% and so on.
%%
%% If the above is not true, then this is probbaly broken!

1.0; %This line just tells Octave/Matlab that this file isn't a function m-file
clear;
MAX_COEFF = 128;   %Output will be scaled so 1.0 maps to MAC_COEFF
NUM_COEFF = 16;    %This is the number of phases for our filter
SCANLINES = 0.0;   %If this is non-zero, the scanlin function is applied
SCANSCALE = 1.0;   %This scales the scanlines for certain scanline styles
COEFF_FIX = 1.0;   %If this is non-zero, row sums will be <= MAX_COEFF


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Filter Coefficient Generator Functions   %%%
%%                                           %%%
%%    are ALL called "filterfunction"        %%%
%%                                           %%%
%%  Uncomment only one of these at a time    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%---------------------------------------------------------------------
% %%LANCZOS N Coefficients
function y = filterfunction(x)
  N = 2.0; %sets the N of LanczosN
  x = abs(x);
  y = 0;
  if (x>0.0 && x<N)
    y = sin(pi*x)/(pi*x)*sin(pi*x/N)/(pi*x/N);
  elseif (x==0);
    y=1;
  end
end


%%Mitchell Netravali Reconstruction Filter
% B = 1,   C = 0   - cubic B-spline
% B = 1/3, C = 1/3 - recommended
% B = 0,   C = 1/2 - Catmull-Rom spline
%
%function y = filterfunction(x)
%  B = 0;
%  C = 0.5;
%  ax = abs(x);
%
%  if (ax < 1)
%    y= ((12 - 9 * B - 6 * C) * ax * ax * ax + (-18 + 12 * B + 6 * C) * ax * ax + (6 - 2 * B)) / 6;
%  elseif ((ax >= 1) && (ax < 2))
%      y =((-B - 6 * C) * ax * ax * ax + ...
%              (6 * B + 30 * C) * ax * ax + (-12 * B - 48 * C) * ...
%              ax + (8 * B + 24 * C)) / 6;
%  else
%      y = 0;
%  end
%end

function C = scanlines(coeff, SCANLINES, SCANSCALE)
  N = length(coeff);
  for i = 1:N
    R = coeff(i,:); %pull out row i
    pos = (i-1)/N; %get the phase as decimal
    %sl = SCANSCALE*(exp(SCANLINES*pos^2)+exp(SCANLINES*(pos-1)^2) ); %% 25% scanlines
    %sl=0.125*cos(2*pi*pos)+0.875;
    
    pos = min( pos ,  1.0 - pos);
    sl = 1-2*(pos^2-5.5*pos^6);
    C(i,:) = sl*R;
    end
end

function coeff = coeff_fixer(coeff, MAX_COEFF)
  N = length(coeff);
  for i = 1:N
    R = coeff(i,:); %pull out row i
    while( sum(R) > 128 ) %while row sum is too big
      [S,index] = max(R); %subtract off of the largest coefficient
      R(index) = R(index) - 1.0;
      disp "Subtracting"
      coeff(i,:) = R;
    end
  end
end
%---------------------------------------------------------------------
%% Gaussian Scaling for y-axis with scanline effect
%function y=filterfunction(x)
% %y = 0.955*exp(-3.8*x^2); % 25% scanlines
%  y = 0.94*exp(-3.5*x^2); % 20% scanlines
%  %y = 0.925*exp(-3.1*x^2); % 15% scanlines
%end



%---------------------------------------------------------------------
 %Exponential Scanline profile 25% Scanlines or so...
%function y=filterfunction(x)
% A = 4.36; % 10% Scanlines
 %A = 4.75; % 15% Scanlines
 %A = 5.2; % 20% Scanlines
 %A = 5.5; % 25% Scanlines
 %A = 5.9; % 30% Scanlines
 %A = 6.9; % 40% Scanlines
 %A = 8.0; % 50% Scanlines
 %A = 9.3; % 60% Scanlines
 %A = 11.5; % 70% Scanlines
 %A = 14.0; % 80% Scanlines
 %A = 18.0; % 90% Scanlines
 %A = 40.0; % 100% Scanlines
 
% y = 0.492*exp(-2*A*x^4) + 0.492*exp(-A*x^2);
%end



%---------------------------------------------------------------------
%% Smoothsteped bilinear. Soft but nicer than bilinear
%function y=filterfunction(x)
% y=0;
% ax = 1.0-abs(x);
% pos = ax;
% if ax >=0 && ax <=1
% y = 3*ax^2 - 2*ax^3;
% y = y*(exp(-6.5*pos^2)+exp(-6.5*(pos-1)^2) ); %% 20% scanlines
% end
%end


%---------------------------------------------------------------------
%% Exponential Profile with no overshoot
%function y=filterfunction(x)
%  y = exp(-11.07*x^4);
%end


%---------------------------------------------------------------------
%% Bilinear Coefficients
%function y = filterfunction(x)
%  y = 0;
%  if (x>=0.0 && x<=1.0)
%    y=1.0-x;
%  end
%  if (x>=-1.0 && x< 0);
%    y=1+x;
%  end
%end


%---------------------------------------------------------------------
 %Bicubic Coefficients. Parameter A controls...something
 %Normal values are A = -0.5 , A = -0.75, with A=-0.6 as
 %a compromize
%function y = filterfunction(x)
%  A = -0.5;
%  y = 0;  
%  x = abs(x);
%  if (x <= 1.0)
%    y = (A+2)*x^3-(A+3)*x^2+1;
%  end
%  if (x > 1.0  && x <= 2.0);
%   y = A*x^3-5*A*x^2+8*A*x-4*A;
%  end
%end


%---------------------------------------------------------------------


%---------------------------------------------------------------------
%% Even Sharper bilinear (not actually linear)
%% Combined with a scanline effect for use on y-axis
%% Also, you can do a neat "LCD effect" with vertical and horizontal scanlines 
%function y = filterfunction(x) 
%  y = 0.0;
%  if (x>=0.0 && x<=1.0)
%   y=1.0-x;
%  end
%  if (x>=-1.0 && x< 0);
%    y=1+x;
%  end
%  pos = y;
%  if (y >= 0 && y<=0.5)
%    y=16*y^5;
%  end
%  if (y > 0.5 && y<=1.0)
%    y=1+16*(y-1)^5;
%  end
%
%  %If you uncomment ONE of the these lines below you can add a scanline effect
%  %y = y*0.965*(exp(-3.4*pos^2)+exp(-3.4*(pos-1)^2) ); %% 20% scanlines
%  y = y*0.975*(exp(-3.8*pos^2)+exp(-3.8*(pos-1)^2) ); %% 25% scanlines
%  %y = 0.985*y*(exp(-4.25*pos^2)+exp(-4.25*(pos-1)^2)); %% 30% scanlines
%  %y = 0.995*y*(exp(-5.5*pos^2)+exp(-5.5*(pos-1)^2)); %% 50% scanlines
%  %y =y*(exp(-15*pos^4)+exp(-15*(pos-1)^4)); %% fake LCD Thick Border
%  %y =y*(exp(-60*pos^6)+exp(-60*(pos-1)^6)); %% fake LCD Thin Border
%end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  Below this is the code that actually     %%%
%%                                           %%%
%%  generates the coefficients by calling    %%%
%%                                           %%%
%%  the filterfunction you defined above.    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Generates the x-values for each tap for all 16 phases
%% Then computes the weight in [0,1.0] and stores it
for p_index = 1:NUM_COEFF
 for t_index = 1:4
  p = (p_index - 1)/NUM_COEFF;
  t = (t_index - 1);
  x = t - 1 - p;
 coeff(p_index, t_index) = filterfunction(x);
 end
end

if (SCANLINES != 0)
  disp "Doing Scanlines!"
  coeff = scanlines(coeff, SCANLINES, SCANSCALE);
end

% Quantize to [-128,128].  This is easy to change...
coeff_quant = round(coeff * MAX_COEFF);
% Check they sum to 1
sum_coeff = sum(coeff,2);
if (COEFF_FIX == 1.0)
  disp "Fixing over large coefficients"
  coeff_quant = coeff_fixer(coeff_quant, MAX_COEFF);
endif
sum_coeff_quant = sum(coeff_quant,2);


% Write coefficients to a file I=Phase, J=Tap
fid = fopen('coeffs_4tap.txt', 'w');
fprintf(fid, 'PHASE: TAP0 TAP1 TAP2 TAP3 SUM\n\n');
for I = 1:NUM_COEFF
 fprintf(fid, 'PHASE%2d : ',I-1 );
 for J = 1:4
 fprintf(fid, '%4.0f,', coeff_quant(I,J));
 end

 if sum_coeff_quant(I) == MAX_COEFF
 fprintf(fid, '%5d\n', sum_coeff_quant(I));
 else
 fprintf(fid, '%5d *\n', sum_coeff_quant(I));
 end
end

fclose(fid);

fid2 = fopen('ascal_coefficients_32.txt', 'w');

for col = coeff_quant
  for c = col'
    fprintf(fid2, '%.0f,',c);
  end
    fprintf(fid2, '\n',c);
end
fclose(fid2);

%Throw the coefficients out to the screen as well as the file
coeff_quant