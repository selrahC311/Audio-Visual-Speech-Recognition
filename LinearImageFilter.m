z = fspecial('filtertype', hsize, sigma);
% provides a means for constructing filter kernels for many different
% filter types

x = imfilter(A, h, padding, outputSize, filterOperation);
% then apply the kernel to an image, where the desired behaviour at the
% image borders can be specified
