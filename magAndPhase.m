function [shortTimeMag, shortTimePhase] = magAndPhase(speechFrame)
    hamming_win = hamming(length(speechFrame)); % hamming window of the speech frame
    frame = hamming_win .* speechFrame;
    xF = fft(frame);   % fft to obtain the complex specturm(real and imag)
    shortTimeMag_sys = abs(xF);
    shortTimeMag = shortTimeMag_sys(1:length(speechFrame)/2);  % mag of complex spectrum
%     plot(shorTimeMag);    % error check
    shortTimePhase = angle(xF);  % phase of complex spectrum
%     plot(shortTimePhase); % error check
end