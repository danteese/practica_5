clear; clc;
% Elabora:
% Dante Fernando Bazaldua Huerta
% Leonardo Alberto Lopez Romero
% Practica 5

%% Parte 1
% Separabilidad 
% Some help: 
%   https://www.researchgate.net/post/Can_someone_please_provide_me_some_MATLAB_code_for_image_transforms_2D_DFT
%   https://math.stackexchange.com/questions/906956/is-2d-fft-separable
%   http://eeweb.poly.edu/~yao/EL5123/lecture4_2DFT.pdf
%   Great video with images: https://www.youtube.com/watch?v=v743U7gvLq0&t=384s

clear; clc;
img = imread('patron9.tif');
img = rgb2gray(img);
% FFT en 2D y luego volteado
img_fft2 = fft2(img);
img_fftm = abs(img_fft2); % Magnitud
img_ffts = fftshift(img_fftm); % Shift de la transformada de la imagen

figure
set(gcf, 'Name', 'Separabilidad', 'NumberTitle', 'Off');
subplot(3,2,1); imshow(img, []); title('Original');

% Función propia: FFT2D
fft2x = FFT2D(img);
fft2s = fftshift(fft2x);
subplot(3,1,1); imshow(img, []); title('Original');
subplot(3,2,3); imshow(log(fft2x + 1), []); title('Magnitud (log) -handcrafted');
subplot(3,2,4); imshow(log(fft2s + 1), []); title('DC centrado -handcrafted');

% La transformada por si misma al ejecutar la magnitud puede que se pierda
% espectro en la imagen, con el log se soluciona eso. 
subplot(3,2,5); imshow(log(img_fftm + 1), []); title('Magnitud (log) -fft2'); % Espectro ampliado con log
% Debido a que el DC se va a las esquinas se pone al centro. 
subplot(3,2,6); imshow(log(img_ffts + 1), []); title('DC centrado -fft2');

disp('Las imágenes con los dos métodos son idénticas con lo cual se demuestra la separabilidad.')
pause;

%% Parte 2
% Demostrar rotación
clear; clc;
img = imread('patron1.tif');
img = imresize(img, 0.5, 'bicubic');

% Crop in the center of the image
img_c = centerc(img, 180);

% FFT en 2D
img_fft2 = fft2(img_c);
img_fftm = abs(img_fft2); % Magnitud
img_ffts = fftshift(img_fftm);

% Rotación
img_r = imrotate(img, 45);
img_rc = centerc(img_r, 180);

% FFT en 2D para imagen recortada y rotada
img_fft2c = fft2(img_rc);
img_fftmc = abs(img_fft2c);
img_fftsc = fftshift(img_fftmc);

figure
set(gcf, 'Name', 'Rotacion', 'NumberTitle', 'Off');
subplot(3,1,1); imshow(img, []); title('Original 0.5x');
subplot(3,2,3); imshow(img_c, []); title('Imagen Cortada');
subplot(3,2,4); imshow(log(img_ffts + 1), []); title('Magnitud R');
subplot(3,3,7); imshow(img_rc, []); title('Imagen Rotada Cortada');
subplot(3,3,8); imshow(log(img_fftsc + 1), []); title('Magnitud R C');
subplot(3,3,9); imshow(imrotate(log(img_fftsc + 1), 45), []); title('Magnitud R C Zoom');

disp('La propiedad de rotación demuestra que al efectuar la FFT2 normal tanto rotada deberían de ser iguales los dos espectros de magnitud');
disp('En este caso se puede apreciar que si son casi iguales, las diferencias podrían estar dadas por como se recortaron, pero la forma se mantiene');
pause; 

%% Parte 3
% Inspiration:
% http://eeweb.poly.edu/~yao/EL5123/lecture4_2DFT.pdf
% https://stackoverflow.com/questions/25827916/matlab-shifting-an-image-using-fft
clear; clc;
img = imread('patron8.tif');
[h, w] = size(img);

% FFT y luego concentramos el DC al centro.
img_fft = fft2(img);
img_ffts = fftshift(img_fft); % Mantenemos parte real y compleja para mayor exactitud

% Demostración de traslacion en frecuencia. 

% Valores aleatorios de traslacion
x0 = randi([-h, h]);
y0 = randi([-w, w]);

% Generar un espacio dinámico 
[xF,yF] = meshgrid(-(h/2):(h/2)-1,-(w/2):(w/2)-1);

% Trasladar en frecuencia
fft_shift = img_ffts.*exp(-1i*2*pi.*(xF*x0+yF*y0)/h);

% Original image (trasladada)
img_shift = ifft2(ifftshift(fft_shift));
img_shift = abs(img_shift);

figure;
set(gcf, 'Name', 'Traslación', 'NumberTitle', 'Off');
subplot(2,2,1); imshow(img, []); title('Original');
subplot(2,2,2); imshow(log(abs(img_ffts) + 1), []); title('Magnitud');
subplot(2,2,3); imshow(img_shift,[]); title('Imagen trasladada en F (x,y -> random)');
subplot(2,2,4); imshow(log(abs(fft_shift) + 1), []); title('Magnitud trasladada ');

disp('Como podemos observar en las imágenes no importa si se ha trasladado X, Y pixeles el espectro de magnitud seguirá siendo el mismo.');
pause;

%% Parte 4
clear; clc;
img = imread('patron7.tif');
[h,w] = size(img);

img_fft = fft2(img);
img_fft = abs(img_fft);
img_ffts = fftshift(img_fft);

w_ = img_fft(1:(h/2), 1:(w/2)); % Primer cuadrante
flip_left = fliplr(w_); % Segundo cuadrante
flip_up = flipud(w_); % Tercer cuadrante
flip_left2 = fliplr(flip_up); % Cuarto cuadrante

w1 = [w_, flip_left];
w2 = [flip_up, flip_left2];
wo = [w1; w2]; % One up, one down

wo = abs(wo);
wo = fftshift(wo);

figure
set(gcf, 'Name', 'Simetría conjugada', 'NumberTitle', 'Off');
subplot(1,3,1); imshow(img, []); title('Original');
subplot(1,3,2); imshow(log(img_ffts + 1), []); title('FFT original');
subplot(1,3,3); imshow(log(wo + 1), []); title('FFT movida');

disp('Como se puede observar en las imagenes la propiedad quedó demostrada');
disp('No importan los valores de las trasnformadas en el dominio F ya que siempre será la misma');

pause;
%% Parte 5
figure
set(gcf, 'Name', 'Distributividad', 'NumberTitle', 'Off');
% Lectura de imagenes
img3 = imread('patron3.tif');
img4 = imread('patron4.tif');
% Suma de imagenes y aplicacion de la trasformada
fftSuma = fft2(img3+img4);
% Suma de las trasformadas de las imagenes
sumaFft = fft2(img3)+fft2(img4);
subplot(2,2,1),imshow(log10(abs(fftSuma)),[]),title('F(f1(x,y)+f2(x,y))');
subplot(2,2,2),imshow(log10(abs(sumaFft)),[]),title('F(f1(x,y))+F(f2(x,y))');
% Multiplicacion de imagenes y aplicacion de la trasformada
fftMult = fft2(img3 .* img4);
% Multiplicacion de las trasformadas de las imagenes
multFft = fft2(img3).* fft2(img4);
subplot(2,2,3),imshow(log10(abs(fftMult)),[]),title('F(f1(x,y)*f2(x,y))');
subplot(2,2,4),imshow(log10(abs(multFft)),[]),title('F(f1(x,y))*F(f2(x,y))');
pause;
%% Parte 6
figure
set(gcf, 'Name', 'Escalabilidad', 'NumberTitle', 'Off');
% Lectura y reacomodo de tama?o de la imagen
img5=imread('patron5.tif');
img5Red = imresize(img5, [200 200]);
img5Amp = imresize(img5, [1000 1000]);
subplot(2,2,1),imshow(img5Red,[]),title(['Imagen: ',num2str(size(img5Red))]);
% Aplicacion de la trasformada a la imagen 200x200
fft2Img5Red=fft2(img5Red);
subplot(2,2,2),imshow(log10(abs(fft2Img5Red)),[]),title(['Imagen: ',num2str(size(fft2Img5Red))]);
subplot(2,2,3),imshow(img5Amp,[]),title(['Imagen: ',num2str(size(img5Amp))]);
% Aplicacion de la trasformada a la imagen 1000x1000
fft2Img5Amp=fft2(img5Amp);
subplot(2,2,4),imshow(log10(abs(fft2Img5Amp)),[]),title(['Imagen: ',num2str(size(fft2Img5Amp))]);
pause;
%% Parte 7
figure
set(gcf, 'Name', 'Valor promedio', 'NumberTitle', 'Off');
img1 = imread('patron1.tif');
% Sacamos el n?mero de muestras, largo y ancho de la imagen
[x,y]=size(img1);
% Se promedian los valores de la imagen y se saca su trasformada
promedio=sum(sum(img1))/(x*y);
fft2img1=fft2(img1); 
% Se obtiene el valor de dc de la imagen
DC = fft2img1(1,1)/(x*y);
subplot(1,2,1),imshow(img1,[]),title(['Promedio: ',num2str(promedio)]);
subplot(1,2,2),imshow(log10(abs(fft2img1)),[]),title(['DC: ',num2str(DC)]);

pause;
close all;