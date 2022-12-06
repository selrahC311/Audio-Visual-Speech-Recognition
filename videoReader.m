v = VideoReader('xylophone.mp4');
vidHeight = v.Height;
vidWidth = v.Width;

% video object, vidObj and structure, s, with fields cdata and colormap to
% hold data. 
s = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'), 'colormap', []);

% movie data structure 
mov = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'), 'colormap', []);

% movie read in as
k = 1; 
while hasFrame(v)
    mov(k).cdata = readFrame(v);
    k = k + 1;
end

% Display movie
hf = figure;
set(hf, 'position', [150 150 vidWidth vidHeight]);
movie(hf, mov, 1, v.FrameRate);

% P = roipoly(M(1).cdata);
% ptr = find(P);
% 
% M1 = double(M(1).cdata);
% R = M1(:,:,1);
% G = M1(:,:,2);
% B = M1(:,:,3);