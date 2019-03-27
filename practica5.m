clear; clc;
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