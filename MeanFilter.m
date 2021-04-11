function [img_out] = MeanFilter(img,kernal_size)
    [M,N] = size(img);
    expand_img = ImgExpand(img,kernal_size);
    filter = 1/(kernal_size^2)*ones(kernal_size);
    img_out = zeros(size(img));
    for i = 1 : 1 : M
        for j = 1 : 1 : N
            img_out(i,j) = sum(sum(expand_img(i:i+kernal_size-1,j:j+kernal_size-1).*filter));
        end
    end
end

