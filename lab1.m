
X = imread('cameraman.tif');

whos

% imtool(X);
C = X;
C(:,:,2) = C;
C(:,:,3) = C(:,:,1);
whos
imshow(C);
imtool(C);
Y = C;
Y(:,:,1) = uint8( 0.5*double( C(:,:,1) ) );
imshow(Y)
