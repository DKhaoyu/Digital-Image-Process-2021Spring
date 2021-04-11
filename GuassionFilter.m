function [img_out] = GuassionFilter(img,kernal_size)
    [M,N] = size(img);
    guass = zeros(kernal_size);
    center = (kernal_size-1)/2+1;
    for i = 1 : 1 : kernal_size
        for j = 1 : 1 : kernal_size
            guass(i,j) = (i-center)^2+(j-center)^2;
        end
    end
    guass = exp(-guass);
    guass = guass/(sum(sum(guass)));
    expand_img = ImgExpand(img,kernal_size);
    img_out = zeros(size(img));
    for i = 1 : 1 : M
        for j = 1 : 1 : N
            img_out(i,j) = sum(sum(guass.*expand_img(i:i+kernal_size-1,j:j+kernal_size-1)));
        end
    end
end

