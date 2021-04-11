clear all,close all,clc;
imgA = imread('imgA.jpg');
imgB = imread('imgB.jpg');
[M1,N1,K1] = size(imgA);
[M2,N2,K2] = size(imgB);
imgA2B = zeros(M1,N1,K1);
imgB2A = zeros(M2,N2,K2);
imgA = double(imgA);
imgB = double(imgB);
histA = zeros(256,3);
histA2B = zeros(256,3);
cdfA = zeros(256,3);
mapA2B = zeros(256,3);
histB = zeros(256,3);
histB2A = zeros(256,3);
cdfB = zeros(256,3);
mapB2A = zeros(256,3);
for k = 1 : 1 : 3
    [histA(:,k),cdfA(:,k)] = GetHist(imgA(:,:,k));
    [histB(:,k),cdfB(:,k)] = GetHist(imgB(:,:,k));
end
for k = 1 : 1 : 3
    for a = 1 : 1 : 256
        for b = 1 : 1 : 255
            if (b == 1)&&(cdfA(a,k)<=cdfB(b,k))
                mapA2B(a,k) = 1;
                break;
            end
            if (cdfA(a,k) <= cdfB(b+1,k))&&(cdfA(a,k) >= cdfB(b,k))
               if cdfA(a,k)<=(cdfB(b+1,k)+cdfB(b,k))
                   mapA2B(a,k) = b;
                   break;
               else
                   mapA2B(a,k) = b+1;
                   break;
               end
            end
        end
    end
end
for k = 1 : 1 : 3
    for b = 1 : 1 : 256
        for a = 1 : 1 : 255
            if (a == 1)&&(cdfB(b,k)<=cdfA(a,k))
                mapB2A(b,k) = 1;
                break;
            end
            if (cdfB(b,k) <= cdfA(a+1,k))&&(cdfB(b,k) >= cdfA(a,k))
               if cdfB(b,k)<=(cdfA(a+1,k)+cdfA(a,k))
                   mapB2A(b,k) = a;
                   break;
               else
                   mapB2A(b,k) = a+1;
                   break;
               end
            end
        end
    end
end
for k = 1 : 1 : 3
    for m = 1 : 1 : M1
        for n = 1 : 1 : N1
            imgA2B(m,n,k) = mapA2B(imgA(m,n,k)+1,k);
        end
    end
    for m = 1 : 1 : M2
        for n = 1 : 1 : N2
            imgB2A(m,n,k) = mapB2A(imgB(m,n,k)+1,k);
        end
    end
end
for k = 1 : 1 : 3
    histA2B(:,k) = GetHist(imgA2B(:,:,k));
    histB2A(:,k) = GetHist(imgB2A(:,:,k));
end
figure;
subplot(2,3,1);
stem(histA(:,1));
title('A original:Channel R');
subplot(2,3,2);
stem(histA(:,2));
title('A original:Channel G');
subplot(2,3,3);
stem(histA(:,3));
title('A original:Channel B');
subplot(2,3,4);
stem(histA2B(:,1));
title('A in style B:Channel R');
subplot(2,3,5);
stem(histA2B(:,2));
title('A in style B:Channel G');
subplot(2,3,6);
stem(histA2B(:,3));
title('A in style B:Channel B');

figure;
subplot(2,3,1);
stem(histB(:,1));
title('B original:Channel R');
subplot(2,3,2);
stem(histB(:,2));
title('B original:Channel G');
subplot(2,3,3);
stem(histB(:,3));
title('B original:Channel B');
subplot(2,3,4);
stem(histB2A(:,1));
title('B in style A:Channel R');
subplot(2,3,5);
stem(histB2A(:,2));
title('B in style A:Channel G');
subplot(2,3,6);
stem(histB2A(:,3));
title('B in style A:Channel B');

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