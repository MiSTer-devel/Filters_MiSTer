function [] = write_filter_coeffs( fn , ch , cv)

fid = fopen(fn, 'w');

fprintf(fid, '# Filter Coeffients for Hybrid Scanline Test\r\n\r\n');

fprintf(fid, '# The original filename is:\r\n');

fprintf(fid, '# %s\r\n\r\n',fn);

fprintf(fid, '# Horizontal Coefficients\r\n');
for I = 1:length(ch)
 for J = 1:3
 fprintf(fid, '%4.0f,', ch(I,J));
 end
 fprintf(fid, '%4.0f\r\n', ch(I,4));
end
fprintf(fid, '\r\n');

fprintf(fid, '# Vertical Coefficients\r\n');
for I = 1:length(cv)
 for J = 1:3
 fprintf(fid, '%4.0f,', cv(I,J));
 end
 fprintf(fid, '%4.0f\r\n', cv(I,4));
end
fprintf(fid, '\r\n');

fclose(fid)
