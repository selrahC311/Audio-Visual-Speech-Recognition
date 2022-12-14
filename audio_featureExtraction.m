%LOOP THROUGH ALL FILES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

readpath = "LipsVideoFiles/test/";
writepath = "AudioFeatures/test/";
list = dir(readpath + "*.mp4");

frameLength = 512;
channel = 30;

for k = 1:length(list)
    [speech_data, fs] = audioread(readpath + list(k).name);
    speech_data = speech_data(:, 1);
%     soundsc(speech_data, fs);
%% Pipline for audio feature vector
    numSamples = length(speech_data);
    numFrames = floor(numSamples/frameLength);
    
    fv = zeros(numFrames-2, channel);   

    for frame = 0:numFrames - 1
        startFrame = frame * frameLength + 1;
        endFrame = startFrame + frameLength - 1;
    
        % frame = x(frameStart:frameEnd);
        shortTimeFrame = speech_data(startFrame:endFrame);
        % hamming
        % getMagSpec
        [magSpec, phaseSpec] = magAndPhase(shortTimeFrame);
        % filterbank vector
        fbankVector = linearRectangularFilterbank(magSpec, channel);
        
        % log of filterbank vector
        logfbankVector = log(fbankVector);
        % dct of log
        z = dct(logfbankVector);   
        disp(z);
    
        % truncation 50%
        z(length(z)*0.5:length(z)) = 0;
        
    
        % push every frame of feature vector in one matrix
        if frame == 0 
            
        elseif frame == 1
            
        else
            rowVector = frame + 1;
            fv(rowVector,:) = z;
            disp(fv(rowVector,:));
        end
    end
    
%% wrtie parameterised file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    filename = split(list(k).name, '.');
    mfcFilename = filename(1) + ".mfc";
    
    [row, column] = size(fv);
    numVectors = row;
    vectorPeriod = frameLength * 10000000 / fs; % ( 512 / 16000 ) * 10000000 = 320000 
    % 32ms each frame (distance between 1st frame and the next expressed in 100ns)
    numDims = column;
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
    for x = 1: row 
        for y = 1: column
            fwrite(fid, fv(x, y), 'float32');
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%