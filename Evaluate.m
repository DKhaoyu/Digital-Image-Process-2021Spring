function [PSNR] = Evaluate(original,processed)
    [M,N] = size(original);
    diff = original-processed;
    mse = 1/(M*N)*sum(sum(diff.*diff));
    PSNR = 10*log10(255^2/mse);
end

