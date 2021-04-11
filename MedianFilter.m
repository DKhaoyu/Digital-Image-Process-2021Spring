function [img_out] = MedianFilter(img,kernal_size)
    [M,N] = size(img);
    expand_img = ImgExpand(img,kernal_size);
    img_out = zeros(size(img));
    for i = 1 : 1 : M
        for j = 1 : 1 : N
            img_out(i,j) = median(reshape(expand_img(i:i+kernal_size-1,j:j+kernal_size-1),1,kernal_size^2));
        end
    end
end

