v = VideoReader("xylophone.mp4");
vidHeight = v.Height;
vidWidth = v.Width;
frames = read(v,1);




rgbImage = im2double(frames);

rChannel = rgbImage(:,:,1);

gChannel = rgbImage(:,:,2);

bChannel = rgbImage(:,:,3);
a = zeros(size(frames, 1 ),size(frames, 2));

Rdct = dct2(rChannel);
Gdct = dct2(gChannel);
Bdct = dct2(bChannel);

% just_red = cat(3,rChannel,a,a);

img_new = idct2(Rdct); idct2(Gdct); idct2(Bdct);

%dct of red plane
% imshow(Rdct);

%idct of full imagea
imshow(img_new);
figure;
imshow(log(abs(img_new)), [], 'colormap', jet(64))

%original image
% imshow(frames);






