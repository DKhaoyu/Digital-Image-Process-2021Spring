function [img_out] = AddPepersalt(img)
    img_out = img;
    [M,N] = size(img);
    for k = 1 : 1 : 6000
        randx = randi([1,M]);
        randy = randi([1,N]);
        if randi([0,1]) == 0
            img_out(randx,randy) = 255;
        else
            img_out(randx,randy) = 0;
        end
    end
end

