function signal = recover_signal(y, fs )
y = y';
[freqRes, N_frame] = size(y);
win_len = freqRes;
inc = win_len / 2 ;
signal = zeros((N_frame - 1) * inc + win_len, 1);

for i = 1 : N_frame
    start = (i - 1) * inc + 1;
    spec = y(:, i);
    signal(start : start + win_len - 1) = signal(start : start + win_len - 1) + real(ifft(spec, win_len));
end
end