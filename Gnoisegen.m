function [y, noise] = Gnoisegen(x, snr)
% Gnoisegen function adds Gaussian white noise to the speech signal x
% [y, noise] = Gnoisegen(x, snr)
% x is the speech signal, snr is the set signal-to-noise ratio in dB
% y is the noise-added speech after adding Gaussian white noise, noise is the added noise
noise = randn(size(x));             % Generate Gaussian white noise using the randn function
Nx = length(x);                     % Calculate the length of signal x
signal_power = 1 / Nx * sum(x .* x);% Calculate the average power of the signal
noise_power = 1 / Nx * sum(noise .* noise);% Calculate the power of the noise
noise_variance = signal_power / (10^(snr / 10)); % Calculate the set variance of the noise
noise = sqrt(noise_variance / noise_power) * noise; % Form the corresponding white noise based on the average power of the noise
y = x + noise;                      % Form the noise-added speech
