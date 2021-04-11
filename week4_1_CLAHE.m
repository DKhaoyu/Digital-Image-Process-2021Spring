clear all, close all, clc;
img = imread('work1.png');
img = double(rgb2gray(img));
hists = zeros(256,4);
[M,N,K] = size(img);
hist_num = 64;
figure;
subplot(2,2,1);
imshow(uint8(img));
title('original image');
for k = 1 : 1 : 3
    tile_size = 16*k;
    x_num = floor(N/tile_size); 
    y_num = floor(M/tile_size);
    x_size = tile_size*x_num;
    y_size = tile_size*y_num;
    [tiles] = ImageDiv(img,tile_size,M,N);
    [equili_img,hists(:,k+1)] = Histogram(tiles,tile_size,x_num,y_num,hist_num);
    equili_img = InterPol(equili_img,tile_size,y_size,x_size);
    subplot(2,2,k+1);
    imshow(uint8(equili_img));
    str = ['tile size: ',num2str(tile_size)];
    title(str);
end
for m = 1 : 1 : M
    for n = 1 : 1 : N
        hists(img(m,n)+1,1) = hists(img(m,n)+1,1) + 1;
    end
end
hists(:,1) = hists(:,1)/(M*N);
figure;
subplot(2,2,1);
stem(hists(:,1));
title('original image');
for k = 1 : 1 : 3
    subplot(2,2,k+1);
    stem(hists(:,k+1));
    str = ['tile size: ',num2str(16*k)];
    title(str);
end
function [tiles] = ImageDiv(img,tile_size,M,N)
    x_num = floor(N/tile_size);
    y_num = floor(M/tile_size);
    tiles = zeros(tile_size,tile_size,y_num,x_num);
    for m = 1 : 1 : y_num
        for n = 1 : 1 : x_num
            tiles(:,:,m,n) = img((m-1)*tile_size+1:m*tile_size,(n-1)*tile_size+1:n*tile_size);
        end
    end
end

function [equili_img,final_hists] = Histogram(tiles,tile_size,x_num,y_num,hist_num)
    step = floor(256/hist_num);
    hists = zeros(hist_num,y_num,x_num);
    x_size = tile_size*x_num;
    y_size = tile_size*y_num;
    equili_img = zeros(y_size,x_size);
    for m = 1 : 1 : y_num
        for n = 1 : 1 : x_num
            for i = 1 : 1 : tile_size
                for j = 1 : 1 : tile_size
                    hists(floor(tiles(i,j,m,n)/step)+1,m,n) = hists(floor(tiles(i,j,m,n)/step)+1,m,n) + 1;
                end
            end
            hists(:,m,n) = hists(:,m,n)/(tile_size*tile_size);
        end 
    end
    cdf = zeros(hist_num,y_num,x_num);
    image_degree = floor(tiles/step);
    equili_tiles = zeros(tile_size,tile_size,y_num,x_num);
    for m = 1 : 1 : y_num
        for n = 1 : 1 : x_num
            cdf(1,m,n) = hists(1,m,n);
            for i = 2 : 1 : hist_num
                cdf(i,m,n) = cdf(i-1,m,n)+hists(i,m,n);
            end
        end
    end
    for m = 1 : 1 : y_num
        for n = 1 : 1 : x_num
            level = round(cdf(image_degree(:,:,m,n)+1)*(hist_num-1));
            equili_tiles(:,:,m,n) = level*step;
            equili_img((m-1)*tile_size+1:m*tile_size,(n-1)*tile_size+1:n*tile_size) = equili_tiles(:,:,m,n);
        end
    end
    final_hists = zeros(256,1);
    for m = 1 : 1 : tile_size*y_num
        for n = 1 : 1 : tile_size*x_num
            final_hists(equili_img(m,n)+1) = final_hists(equili_img(m,n)+1)+1;
        end
    end
    final_hists = final_hists/(x_size*y_size);
end
function [img_pol] = InterPol(img,tile_size,M,N)
    img_pol = img;
    for m = tile_size : tile_size : M-tile_size
        for n = 2 : 1 : N-1
            img_pol(m,n) = 1/4*(img_pol(m-1,n-1)+img_pol(m-1,n+1)+img_pol(m+1,n-1)+img_pol(m+1,n+1));
        end
    end
    for m = 2 : 1 : M-1
        for n = tile_size : tile_size : N-tile_size
            img_pol(m,n) = 1/4*(img_pol(m-1,n-1)+img_pol(m-1,n+1)+img_pol(m+1,n-1)+img_pol(m+1,n+1));
        end
    end
end