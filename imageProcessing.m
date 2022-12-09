%LOOP THROUGH ALL FILES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
readpath = "videoFiles";
writepath = "Practice/";
list = dir(readpath + "*.wav");

% frameLength = 512;

% channel = 30;

for k = 1:length(list)
    vid = VideoReader(readpath + list(k).name);
    vidHeight = vid.Height;
    vidWidth = vid.Width;
    framerate = vid.FrameRate;

    vidStruct = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'), 'colormap', []);
    
    % Loop for each frame
    k = 1;
    while hasFrame(vid)
        vidStruct(k).cdata = readFrame(vid);
        
        img_dct = dctImage(vidStruct(k).cdata);
        img_dct_trunc = dctTruncation(img_dct);
        

        k = k + 1;
    end

%     imtool(vidStruct(1).cdata);








%% wrtie parameterised file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    filename = split(list(k).name, '.');
    mfcFilename = filename(1) + ".mfc";
    
    numVectors = numFrames;
    vectorPeriod = framelength * 10000000 / fs; % ( 512 / 16000 ) * 10000000 = 320000 32ms each frame (distance between 1st frame and the next expressed in 100ns)
    numDims = channel;
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
        for y = 1: channel
            fwrite(fid, fv(x, y), 'float32');
        end
    end
end

