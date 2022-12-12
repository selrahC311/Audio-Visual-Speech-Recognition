function [img_dct] = dctImage(img, trunclevel)
    % imtool(img);
    % gray = im2gray(img);
    % imtool(gray);
    % imshow(log(abs(img_dct)), [], 'colormap', jet(64));
    
    % convert img to double and grayscale
    imgdouble = im2double(img);
    I = im2gray(imgdouble);

    % compute te 2d-dct of 8x8 blocks in image
%     T = dctmtx(8);
    x = @(block_struct) dct2(block_struct.data);
    B = blockproc(I, [8 8], x);

    % truncation
    mask = zeros(8, 8);
    mask(1:trunclevel, 1:trunclevel) = 1;
    img_dct = blockproc(B, [8 8], @(block_struct) mask .* block_struct.data);

    % reconstruct image using 2d inverse dct of each block
%     invdct = @(block_struct) T' * block_struct.data * T;
%     img_dct = blockproc(B2, [8 8], invdct);
end

% T = dctmtx(8);
% dct = @(block_struct) T * block_struct.data * T';
% B = blockproc(I,[8 8],dct);

% B2 = blockproc(B,[8 8],@(block_struct) mask .* block_struct.data);
 
% invdct = @(block_struct) T' * block_struct.data * T;
% I2 = blockproc(B2,[8 8],invdct);

% imshow(I);
% figure
% imshow(I2);
 
