%LOOP THROUGH ALL FILES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

readpath = "LipsVideoFiles/test/";
writepath = "VisualAudioFeatures/test/";
list = dir(readpath + "*.mp4");

frameLength = 512;
channel = 30;
trunclevel_audio = 0.5;

for k = 1:length(list)
    [speech_data, fs] = audioread(readpath + list(k).name);
    speech_data = speech_data(:, 1);
   
%% Pipline for audio feature vector
    audio_numSamples = length(speech_data);
    audio_numFrames = floor(audio_numSamples/frameLength);
    
    % if truncation: channel * trunclevel
    audio_fv = zeros(audio_numFrames-2, channel*0.5);   

    for frame = 0:audio_numFrames - 1
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
    
        % truncation 50%
        z = z(1:length(z)*trunclevel_audio);
    
        % push every frame of feature vector in one matrix
        if frame == 0 
            
        elseif frame == 1
            
        else
            rowVector = frame + 1;
            audio_fv(rowVector,:) = z;
%             disp(audio_fv(rowVector,:));
        end
    end
 

%% Pipeline for Visual feature vector
    vid = VideoReader(readpath + list(k).name);
    disp("Video File read count: " + k)
    vidHeight = vid.Height;
    vidWidth = vid.Width;
    framerate = vid.FrameRate;
    visual_numFrames = vid.NumFrames;
    visual_trunclevel = 0.5*0.5;

    visual_fv = zeros(visual_numFrames, 375);
    
    vidStruct = struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'), 'colormap', []);
    
    % Loop for each frame
    frameCount = 1;
    while hasFrame(vid)
        vidStruct(frameCount).cdata = readFrame(vid);

%         P = roipoly(vidStruct(frameCount).cdata);
%         ptr = find(P);
        
        % color mask
        vidframe = double(vidStruct(frameCount).cdata);
%         R = vidframe(:, :, 1);
%         G = vidframe(:, :, 2);
%         B = vidframe(:, :, 3);
    
%         rgbMean = [mean(R(ptr)) mean(G(ptr)) mean(B(ptr))];
        % distance between every pixel and mean colour
%         D = sqrt((vidframe(:, :, 1) - rgbMean(1)).^2 + (vidframe(:,:,2) - rgbMean(2)).^2 + (vidframe(:,:,3) - rgbMean(3)).^2);
        % imshow(D < std(D(:)));
    
        [E, thresh] = edge(rgb2gray(vidframe/255), "canny");
        % imshow(E);

        img_dct = dctBlockImage(E, 5);
        img_dct = dctBlockImage(img_dct, 5);
        img_dct = dctBlockImage(img_dct, 5);
        img_dct = dctBlockImage(img_dct, 5);
%       img_dct_trunc = dctTruncation(img_dct);

        % flatten the matrix
        temp = img_dct';
        dctFinal = temp(:)';
        
        visual_fv(frameCount, :) = dctFinal;
        
            
        frameCount = frameCount + 1;
    end

%     imtool(vidStruct(1).cdata);
%% Combination of visual feature and audio feature

    visual_fv_interp = dg_visual_feature_interp(visual_fv, audio_fv);
%     visual_fv_resample = resample(visual_fv, length(audio_fv), length(visual_fv));
    combined_fv = horzcat(audio_fv, visual_fv_interp);
    
%% wrtie parameterised file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp("writing mfc count: " + k);
    filename = split(list(k).name, '.');
    mfcFilename = filename(1) + ".mfc";
    
    [rows,columns] = size(combined_fv);
    numVectors = rows;
    vectorPeriod = frameLength * 10000000 / fs; % ( 512 / 16000 ) * 10000000 = 320000 32ms each frame (distance between 1st frame and the next expressed in 100ns)
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
    for x = 1: rows 
        for y = 1: columns
                fwrite(fid, combined_fv(x, y), 'float32');
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%