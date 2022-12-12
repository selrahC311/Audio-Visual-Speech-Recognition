%LOOP THROUGH ALL FILES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
readpath = "LipsVideoFiles/";
writepath = "VisualFeature/";
list = dir(readpath + "*.mp4");

for k = 1:length(list)

    vid = VideoReader(readpath + list(k).name);
    disp("file read")
    vidHeight = vid.Height;
    vidWidth = vid.Width;
    framerate = vid.FrameRate;
    numFrames = vid.NumFrames;

    fv = zeros(numFrames, vidHeight* vidWidth);
    
    vidStruct = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'), 'colormap', []);
    
    % Loop for each frame
    frameCount = 1;
    while hasFrame(vid)
        vidStruct(frameCount).cdata = readFrame(vid);

%         P = roipoly(vidStruct(frameCount).cdata);
%         ptr = find(P);
        
        % color mask
        vidframe = double(vidStruct(frameCount).cdata);
        R = vidframe(:, :, 1);
        G = vidframe(:, :, 2);
        B = vidframe(:, :, 3);
    
%         rgbMean = [mean(R(ptr)) mean(G(ptr)) mean(B(ptr))];
        % distance between every pixel and mean colour
%         D = sqrt((vidframe(:, :, 1) - rgbMean(1)).^2 + (vidframe(:,:,2) - rgbMean(2)).^2 + (vidframe(:,:,3) - rgbMean(3)).^2);
        % imshow(D < std(D(:)));
    
        [E, thresh] = edge(rgb2gray(vidframe/255), "canny");
        % imshow(E);

        img_dct = dctImage(E, 4);
%       img_dct_trunc = dctTruncation(img_dct);

        % flatten the matrix
        temp = img_dct';
        dctFinal = temp(:)';
        
        fv(frameCount, :) = dctFinal;
            
        frameCount = frameCount + 1;
    end

%     imtool(vidStruct(1).cdata);

%% wrtie parameterised file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp("writing");
    filename = split(list(k).name, '.');
    mfcFilename = filename(1) + ".mfc";
    
    [rows,columns] = size(fv);
    numVectors = rows;
    vectorPeriod = 1e+7 / framerate; % ( 512 / 16000 ) * 10000000 = 320000 32ms each frame (distance between 1st frame and the next expressed in 100ns)
    numDims = columns;
    parmKind = 6; % 6 MFCC; 9 USER
    
    % Open file for write: 
    fid = fopen(writepath + mfcFilename, 'w', 'ieee-be');
    
    % Write the header information %
    fwrite(fid, numVectors, 'int32'); % number of vectors in file (4 byte int)
    %sampling frequency of 10khz would be 0.0001s so in ns is 1s
    fwrite(fid, vectorPeriod, 'int32'); % sample period in 100ns units (4 byte int)
    fwrite(fid, numDims * 4, 'int16'); % number bytes per vector (2 byte int)
    fwrite(fid, parmKind, 'int16'); % code for the sample kind (2 byte int)
    
    % Write the data: one coefficient at a time: 
    for x = 1: numFrames 
        for y = 1: numDims
                fwrite(fid, fv(x, y), 'float32');
        end
    end
end

