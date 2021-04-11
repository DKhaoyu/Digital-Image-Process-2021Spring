function [hist,cdf] = GetHist(img)  
    hist = zeros(1,256);
    cdf = zeros(1,256);
    [M,N] = size(img);
    for m = 1 : 1 : M
       for n = 1 : 1 : N
            hist(img(m,n)+1) = hist(img(m,n)+1) + 1;
       end
    end
    hist = hist/(M*N);
    cdf(1) = hist(1);
    for m = 2 : 1 : 256
        cdf(m) = cdf(m-1) + hist(m);
    end
end

