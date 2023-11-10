function [signal, noise] = add_noisedata(s, data, fs, fs1, snr)
s = s(:);                        % Convert the signal to column data
s = s - mean(s);                 % Remove the DC component
sL = length(s);                  % Get the length of the signal

if fs ~= fs1                     % If the sampling rate of the pure voice signal is not equal to the noise sampling rate
    x = resample(data, fs, fs1); % Resample the noise so that its sampling rate matches the pure voice signal
else
    x = data;
end

x = x(:);                        % Convert the noise data to column data
x = x - mean(x);                 % Remove the DC component
xL = length(x);                  % Get the length of the noise data
if xL >= sL                      % If the length of the noise data is not equal to the signal data, truncate or pad the noise data
    x = x(1:sL);
else
    disp('Warning: Noise data is shorter than signal data, padding with zeros!')
    x = [x; zeros(sL - xL, 1)];
end

Sr = snr;
Es = sum(x .* x);                % Calculate the energy of the signal
Ev = sum(s .* s);                % Calculate the energy of the noise
a = sqrt(Ev / Es / (10 ^ (Sr / 10))); % Calculate the noise scaling factor
noise = a * x;                   % Adjust the amplitude of the noise
signal = s + noise;              % Form the noise-added speech
