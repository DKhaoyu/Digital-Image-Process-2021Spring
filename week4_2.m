load work2.mat
image = abs(image);
maxval_1 =  max(max(abs(image)));
figure;
subplot(1,2,1);
imshow(image/maxval_1);
title('original spectral');
subplot(1,2,2);
image_2 = log(1+image);
maxval_2 = max(max(image_2));
imshow(image_2/maxval_2);
title('transformed spectral');