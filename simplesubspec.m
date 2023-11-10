function output = simplesubspec(signal, wlen, inc, NIS, a, b)
wnd = hamming(wlen);                     % Set the window function
N = length(signal);                      % Calculate the length of the signal

y = enframe(signal, wnd, inc)';          % Frame blocking
fn = size(y, 2);                         % Calculate the number of frames

y_fft = fft(y);                          % FFT
y_a = abs(y_fft);                        % Compute magnitude
y_phase = angle(y_fft);                  % Compute phase angle
y_a2 = y_a.^2;                           % Compute energy
Nt = mean(y_a2(:, 1:NIS), 2);            % Calculate average energy of noise segment
nl2 = wlen / 2 + 1;                      % Determine the range for positive frequencies

for i = 1:fn;                            % Perform spectral subtraction
    for k = 1:nl2
        if y_a2(k, i) > a * Nt(k)
            temp(k) = y_a2(k, i) - a * Nt(k);
        else
            temp(k) = b * y_a2(k, i);
        end
        U(k) = sqrt(temp(k));            % Convert energy back to magnitude
    end
    X(:, i) = U;
end;
output = OverlapAdd2(X, y_phase(1:nl2, :), wlen, inc); % Synthesize the speech after spectral subtraction
Nout = length(output);                   % Adjust the length of the output to match the input
if Nout > N
    output = output(1:N);
elseif Nout < N
    output = [output; zeros(N - Nout, 1)];
end
% output = output / max(abs(output));      % Normalize amplitude
