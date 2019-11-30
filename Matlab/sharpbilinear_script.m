for i=1:16
  [ch,cv]=calc_sharp_bilinear(i,i);
  fn=["bilinearsharp_" sprintf("%02d",17-i) ".txt"];
  write_filter_coeffs(fn,ch,cv);
end

for i=1:16
  [ch,cv]=calc_sharp_bilinear(i,floor(i/2));
  fn=["SNES_bilinearsharp_" sprintf("%02d",17-i) ".txt"];
  write_filter_coeffs(fn,ch,cv);
end