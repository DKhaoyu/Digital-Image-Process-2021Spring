clear all,close all, clc;
imgA = imread('imgA.jpg');
imgB = imread('imgB.jpg');
imgA = rgb2gray(imgA);
imgB = rgb2gray(imgB);
[M1,N1] = size(imgA);
[M2,N2] = size(imgB);
imgA2B = zeros(M1,N1);
imgB2A = zeros(M2,N2);
imgA = double(imgA);
imgB = double(imgB);
histA = zeros(1,256);
histA2B = zeros(1,256);
cdfA = zeros(1,256);
mapA2B = zeros(1,256);
histB = zeros(1,256);
histB2A = zeros(1,256);
cdfB = zeros(1,256);
mapB2A = zeros(1,256);
[histA,cdfA] = GetHist(imgA);
[histB,cdfB] = GetHist(imgB);
for a = 1 : 1 : 256
    for b = 1 : 1 : 255
        if (b == 1)&&(cdfA(a)<=cdfB(b))
            mapA2B(a) = 1;
            break;
        end
        if (cdfA(a) <= cdfB(b+1))&&(cdfA(a) >= cdfB(b))
           if cdfA(a)<=(cdfB(b+1)+cdfB(b))
               mapA2B(a) = b;
               break;
           else
               mapA2B(a) = b+1;
               break;
           end
        end
    end
end
for b = 1 : 1 : 256
    for a = 1 : 1 : 255
        if (a == 1)&&(cdfB(b)<=cdfA(a))
            mapB2A(b) = 1;
            break;
        end
        if (cdfB(b) <= cdfA(a+1))&&(cdfB(b) >= cdfA(a))
           if cdfB(b)<=(cdfA(a+1)+cdfA(a))
               mapB2A(b) = a;
               break;
           else
               mapB2A(b) = a+1;
               break;
           end
        end
    end
end
for m = 1 : 1 : M1
    for n = 1 : 1 : N1
        imgA2B(m,n) = mapA2B(imgA(m,n)+1);
    end
end
for m = 1 : 1 : M2
    for n = 1 : 1 : N2
        imgB2A(m,n) = mapB2A(imgB(m,n)+1);
    end
end
histA2B = GetHist(imgA2B);
histB2A = GetHist(imgB2A);
figure;
subplot(2,2,1);
stem(histA);
title('original histogram of A');
subplot(2,2,2);
stem(histB);
title('original histogram of B');
subplot(2,2,3);
stem(histA2B);
title('histogram of A in style B');
subplot(2,2,4);
stem(histB2A);
title('histogram of B in style A');
figure;
subplot(2,2,1);
imshow(uint8(imgA));
title('Original Image A');
subplot(2,2,2);
imshow(uint8(imgB));
title('Original Image B');
subplot(2,2,3);
imshow(uint8(imgA2B));
title('Image A in style B');
subplot(2,2,4);
imshow(uint8(imgB2A));
title('Image B in style A');