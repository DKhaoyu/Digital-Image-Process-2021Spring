function [G,img_out] = Sharpen(img,mode1,mode2)
    [M,N] = size(img);
    img_out = zeros(M,N);
    Gx = zeros(M,N);
    Gy = zeros(M,N);
    G = zeros(M,N);
    if mode1 == 1
        if mode2 == 1
            expand_img = ImgExpand(img,3);
            filter1 = [-1,0,1;-1,0,1;-1,0,1];
            filter2 = [1,1,1;0,0,0;-1,-1,-1];
            for i = 1 : 1 : M
                for j = 1 : 1 : N
                   Gx(i,j) = sum(sum(filter1.*(expand_img(i:i+2,j:j+2))));
                   Gy(i,j) = sum(sum(filter2.*(expand_img(i:i+2,j:j+2))));
                end        
            end
            G = sqrt(Gx.*Gx+Gy.*Gy);
            img_out = G+img;
        else
            expand_img = zeros(M+1,N+1);
            expand_img(1:M,1:N) = img;
            expand_img(M+1,1:N) = expand_img(M,1:N);
            expand_img(:,N+1) = expand_img(:,N);
            for i = 1 : 1 : M
                for j = 1 : 1 : N
                   Gx(i,j) = expand_img(i+1,j+1)-expand_img(i,j);
                   Gy(i,j) = expand_img(i,j+1)-expand_img(i+1,j);
                end        
            end
            G = sqrt(Gx.*Gx+Gy.*Gy);
            img_out = G+img;
        end
    else 
        if mode2 == 1
            expand_img = ImgExpand(img,3);
            filter = [0,-1,0;-1,4,-1;0,-1,0];
            for i = 1 : 1 : M
                for j = 1 : 1 : N
                    G(i,j) = sum(sum(filter.*(expand_img(i:i+2,j:j+2))));
                end
                G = abs(G);
                img_out = img + G;
            end  
        elseif mode2 == 2
            expand_img = ImgExpand(img,3);
            filter = [-1,-1,-1;-1,8,-1;-1,-1,-1];
            for i = 1 : 1 : M
                for j = 1 : 1 : N
                    G(i,j) = sum(sum(filter.*(expand_img(i:i+2,j:j+2))));
                end        
            end
            G = abs(G);
            img_out = img + G;
        end
    end 
end

