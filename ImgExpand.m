function [expand_img] = ImgExpand(img,kernal_size)
    [M,N] = size(img);
    addlen = (kernal_size-1)/2;
    expand_img = zeros(M+2*addlen,N+2*addlen);
    expand_img(addlen+1:M+addlen,addlen+1:N+addlen) = img;
    expand_img(addlen+1:M+addlen,1:addlen) = repmat(img(:,1),1,addlen);
    expand_img(addlen+1:M+addlen,N+addlen+1:N+2*addlen) = repmat(img(:,N),1,addlen);
    expand_img(1:addlen,:) = repmat(expand_img(addlen+1,:),addlen,1);
    expand_img(M+addlen+1:M+2*addlen,:) = repmat(expand_img(M+addlen,:),addlen,1);
end

