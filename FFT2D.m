function [fft2d_matrix] = FFT2D(matrix)
% FFT2D - FFT algorithm to probe separability of Fast Fourier Transform in
% 2 dimensions. 
cols = fft(matrix);
rows = fft(imrotate(cols, 90));
fft2d_matrix = abs(rows);
end

