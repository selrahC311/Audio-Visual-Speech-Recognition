img = imread("cameraman.tif");
img_dct = dct2(img);
% img dct, is a matrix the same size as the image where the top left element is the DC (zerofrequency) component and entries with increasing
% vertical and horizontal index values represent higher vertical
% and horizontal spatial frequencies.
imshow(log(abs(img_dct)), []); % greyscale version of colourmap
% imshow(log(abs(img_dct)), [], 'colormap', jet(64));



% img_new = dct2(img_dct); 
% imshow(img, []);
% figure;
% imshow(img_new, []);
% 
% img_new1 = dct2(img_new);
% imshow(img_new1);