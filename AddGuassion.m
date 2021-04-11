function [img_out] = AddGuassion(img,miu,sigma)
    [M,N] = size(img);
    img_out = img+normrnd(miu,sigma,M,N);
end

