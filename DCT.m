v = VideoReader("xylophone.mp4");
vidHeight = v.Height;
vidWidth = v.Width;
frames = read(v,1);

rgbImage = im2double(frames);
I = im2gray(rgbImage);

% rChannel = I(:,:,1);
% 
% gChannel = I(:,:,2);
% 
% bChannel = I(:,:,3);
a = zeros(size(frames, 1 ),size(frames, 2));

% Rdct = dct2(rChannel);
% Gdct = dct2(gChannel);
% Bdct = dct2(bChannel);
img_new = dct2(I);

img_new1 = idct2(img_new);

% just_red = cat(3,rChannel,a,a);

% img_new = idct2(Rdct); idct2(Gdct); idct2(Bdct);

%dct of red plane
% imshow(Rdct);

%idct of full imagea
imshow(img_new1);
figure;

%original image
% imshow(frames);






