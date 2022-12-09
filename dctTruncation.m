function [img_dct_trunc] = dctTruncation(img_dct, TruncLevel)
    % DCTTRUNCATION Summary of this function goes here
    % Detailed explanation goes here

    for i = TruncLevel:size(img_dct)
        for j = TruncLevel:size(img_dct)
            img_dct(i, j) = 0;
        end
    end
    img_dct_trunc = img_dct;
end

