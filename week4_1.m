clear all, close all, clc;
img = imread('work1.png');
img = double(rgb2gray(img));
[M,N] = size(img);
equili_flag = zeros(M,N,5);
equili_img = zeros(M,N,6);
equili_img(:,:,1) = img;
deg = [256,128,64,32,16].';
for s = 1 : 1 : 5
    histogram = zeros(deg(s),1);
    step = 256/deg(s);
    for i = 1 : 1 : M
        for j = 1 : 1 : N
            histogram(floor(img(i,j)/step)+1) = histogram(floor(img(i,j)/step)+1)+1;
        end
    end
    equili_flag(:,:,s) = floor(img/step);
    histogram = histogram/(M*N);
    cdf = zeros(deg(s),1);
    cdf(1) = histogram(1);
    for i = 2 : 1 : deg(s)
        cdf(i) = cdf(i-1) + histogram(i);
    end
    for i = 1 : 1 : M
        for j = 1 : 1 : N
            level = round(cdf(equili_flag(i,j,s)+1)*(deg(s)-1));
            equili_img(i,j,s+1) = level*step;
        end
    end
end
equili_img = uint8(equili_img);
hist = zeros(256,6);
for s = 1 : 1 :6
    for i = 1 : 1 : M
        for j = 1 : 1 : N
            hist(equili_img(i,j,s)+1,s) = hist(equili_img(i,j,s)+1,s)+1;
        end
    end
end
hist = hist/(M*N);
figure;
subplot(2,3,1);
imshow(equili_img(:,:,1));
title('original image');
for k = 2 : 1 : 6
    subplot(2,3,k);
    imshow(equili_img(:,:,k));
    str = ['degree ',num2str(2^(10-k))];
    title(str);
end
n = [0:255];
figure;
subplot(2,3,1);
stem(n,hist(:,1));
title('original image');
for k = 2 : 1 : 6
    subplot(2,3,k);
    stem(n,hist(:,k));
    str = ['degree ',num2str(2^(10-k))];
    title(str);
end