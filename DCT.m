v = VideoReader("xylophone.mp4");
vidHeight = v.Height;
vidWidth = v.Width;



frames = read(v, 1);

rgbImage = im2double(frames);

rChannel = rgbImage(:,:,1);

gChannel = rgbImage(:,:,2);

bChannel = rgbImage(:,:,3);
a = zeros(size(frames, 1 ),size(frames, 2));

Rdct = dct2(rChannel);
Gdct = dct2(gChannel);
Bdct = dct2(bChannel);

img = Rdct; Gdct; Bdct;

% just_red = cat(3,rChannel,a,a);

img_new = idct2(img);
%dct of red plane
imshow(Rdct);
figure;
%idct of full imagea
imshow(img);
figure;
%original image
imshow(frames);



