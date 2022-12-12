function [fbank] = linearRectangularFilterbank(magSpec, K)

    frameLength = floor(length(magSpec)/K);
%     assume k channel filter bank:
    for channel = 0:K-1
%     compute firstBin for channel
    firstBin = channel * frameLength + 1;
%     compute lastBin for channel
    lastBin = firstBin + frameLength - 1;

%         disp(firstBin);
%         disp(lastBin);

        r = zeros(1, length(magSpec));
        r(firstBin:lastBin) = 1;
        fbank(channel+1) = r*magSpec;
    end

%     figure;
%     subplot(2,1,1), plot(magSpec);
%     subplot(2,1,2), plot(fbank);
end