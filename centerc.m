function [image_cropped] = centerc(matrix, rect_size)
% centerc crop an image with a specific size and returns the new one 
% Only crop square.
[h, w] = size(matrix);
x_cent = h/2;
y_cent = w/2;
size_of_cropped_img = rect_size;

xmin = x_cent-size_of_cropped_img/2;
ymin = y_cent-size_of_cropped_img/2;
image_cropped = imcrop(matrix,[xmin ymin size_of_cropped_img size_of_cropped_img]);
end

