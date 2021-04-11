clear all, close all,clc;
img = imread('fig1.png');
img = double(rgb2gray(img));
[M,N] = size(img);
img_guass = zeros(M,N,6);
miu = [0,0,0,10,20,40];
sigma = [10,20,40,20,20,20];
for k = 1 : 1 : 6
    img_guass(:,:,k) = AddGuassion(img,miu(k),sigma(k));
end
figure;
for k = 1 : 1 : 6
    subplot(2,3,k);
    imshow(uint8(img_guass(:,:,k)));
    title_str = ['miu = ',num2str(miu(k)),' sigma = ',num2str(sigma(k))];
    title(title_str);
end
guass_rect1 = GuassionFilter(img_guass(:,:,2),3);
median_rect1 = MedianFilter(img_guass(:,:,2),3);
mean_rect1 = MeanFilter(img_guass(:,:,2),3);
PSNR1 = zeros(1,3);
PSNR1(1) = Evaluate(img,guass_rect1);
disp(PSNR1(1));
PSNR1(2) = Evaluate(img,median_rect1);
disp(PSNR1(2));
PSNR1(3) = Evaluate(img,mean_rect1);
disp(PSNR1(3));
figure;
subplot(1,4,1);
imshow(uint8(img_guass(:,:,2)));
title('Guass Noise');
subplot(1,4,2);
imshow(uint8(guass_rect1));
title('Guass Filter');
subplot(1,4,3);
imshow(uint8(median_rect1));
title('Median Filter');
subplot(1,4,4);
imshow(uint8(mean_rect1));
title('Mean Filter');

img_salt = AddPepersalt(img);
figure;
imshow(uint8(img_salt));
title('Peper Salt Noise');
guass_rect2 = GuassionFilter(img_salt,3);
median_rect2 = MedianFilter(img_salt,3);
mean_rect2 = MeanFilter(img_salt,3);
PSNR2 = zeros(1,3);
PSNR2(1) = Evaluate(img,guass_rect2);
disp(PSNR2(1));
PSNR2(2) = Evaluate(img,median_rect2);
disp(PSNR2(2));
PSNR2(3) = Evaluate(img,mean_rect2);
disp(PSNR2(3));
figure;
subplot(1,4,1);
imshow(uint8(img_salt));
title('Peper Salt Noise');
subplot(1,4,2);
imshow(uint8(guass_rect2));
title('Guass Filter');
subplot(1,4,3);
imshow(uint8(median_rect2));
title('Median Filter');
subplot(1,4,4);
imshow(uint8(mean_rect2));
title('Mean Filter');
title_str = ['Gradient template 1';'Gradient template 2';'Laplace template 1 ';'Laplace template 2 '];
for mode1 = 1 : 1 : 2
    figure;
    for mode2 = 1 : 1 : 2
       [G,img_out] = Sharpen(img,mode1,mode2);
       subplot(2,2,2*(mode2-1)+1);
       imshow(uint8(G));
       title(title_str((mode1-1)*2+mode2,:));
       subplot(2,2,2*mode2);
       imshow(uint8(img_out));
       title('Enhanced Image');
    end
end