v = VideoReader("xylophone.mp4");
vidHeight = v.Height;
vidWidth = v.Width;

frames = read(v);

rgbImage = im2double(frames);

rChannel = rgbImage(:,:,1);

gChannel = rgbImage(:,:,2);

bChannel = rgbImage(:,:,3);
a = zeros(size(frames, 1 ),size(frames, 2));

Rtrans = dct2(rChannel);
Gtrans = dct2(gChannel);
Btrans = dct2(bChannel);

just_red = cat(3,rChannel,a,a);

img_new = idct2(Rtrans_dct_trunc);
imshow(frames);
figure;
imshow(img_new)


% imshow(frames);


% T = dctmtx(8);
% dct = @(block_struct) T * block_struct.data * T';
% B = blockproc(I,[8 8],dct);
% 
% mask = [1   1   1   1   0   0   0   0
%         1   1   1   0   0   0   0   0
%         1   1   0   0   0   0   0   0
%         1   0   0   0   0   0   0   0
%         0   0   0   0   0   0   0   0
%         0   0   0   0   0   0   0   0
%         0   0   0   0   0   0   0   0
%         0   0   0   0   0   0   0   0];
% 
% B2 = blockproc(B,[8 8],@(block_struct) mask .* block_struct.data);
% 
% invdct = @(block_struct) T' * block_struct.data * T;
% I2 = blockproc(B2,[8 8],invdct);
% 
% imshow(I);
% figure
% imshow(I2);
% 
