%LOOP THROUGH ALL FILES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
readpath = "speechFiles/train/";
writepath = "Practice/";
list = dir(readpath + "*.wav");

filename = "";
frameLength = 512;
channel = 30;
dp = 4;
for k = 1:length(list)
    [speech_data, fs] = audioread(readpath + list(k).name);
   
%% Pipline for feature vector
    numSamples = length(speech_data);
    numFrames = floor(numSamples/frameLength);
    
    fv = zeros(numFrames, channel);   

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
%         plot(fv), hold on;
    
        % truncation

    
    
        % push every frame of feature vector in one matrix
        rowVector = frame + 1;
        fv(rowVector, :) = z;
        
    end
    
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%