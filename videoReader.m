v = VideoReader('LipsVideoFiles\2vid1c.mp4');
vidHeight = v.Height;
vidWidth = v.Width;

    framerate = v.FrameRate;
    numFrames = v.NumFrames;

% video object, vidObj and structure, s, with fields cdata and colormap to
% hold data. 
s = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'), 'colormap', []);

% movie data structure 
mov = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'), 'colormap', []);
fv = zeros(numFrames, vidHeight* vidWidth);
% movie read in as
k = 1; 
while hasFrame(v)
    mov(k).cdata = readFrame(v);
    
    
    vidframe = double(mov(k).cdata);
        R = vidframe(:, :, 1);
        G = vidframe(:, :, 2);
        B = vidframe(:, :, 3);
        [E, thresh] = edge(rgb2gray(vidframe/255), "canny");
%         imshow(E);
        img_dct = dctImage(E, 4);

        temp = img_dct';
        dctFinal = temp(:)';
        
        fv(k, :) = dctFinal;
    
    k = k + 1;
end

%     disp("writing");
%     filename = split(list(k).name, '.');
%     mfcFilename = filename(1) + ".mfc";
    
    [rows,columns] = size(fv);
    numVectors = rows;
    fs = 1/framerate;
    vectorPeriod = 1e+7*fs; % ( 512 / 16000 ) * 10000000 = 320000 32ms each frame (distance between 1st frame and the next expressed in 100ns)
    numDims = columns;
    parmKind = 6; % 6 MFCC; 9 USER
    
    % Open file for write: 
    fid = fopen("testmfc.mfc", 'w', 'ieee-be');
    
    % Write the header information %
    fwrite(fid, numVectors, 'int32'); % number of vectors in file (4 byte int)
    %sampling frequency of 10khz would be 0.0001s so in ns is 1s
    fwrite(fid, vectorPeriod, 'int32'); % sample period in 100ns units (4 byte int)
    fwrite(fid, numDims * 4, 'int16'); % number bytes per vector (2 byte int)
    fwrite(fid, parmKind, 'int16'); % code for the sample kind (2 byte int)
    
    % Write the data: one coefficient at a time: 
    for x = 1: rows 
        disp("writing frame" + x);
        for y = 1: columns
                fwrite(fid, fv(x, y), 'float32');
                
        end
    end