function audio_fft = enframe(audio,L_frame)
    %convert signal into frequency domain
    [L_audio,~] = size(audio);
    step = 0.5 * L_frame;
    n_frame = floor((L_audio - (L_frame - step))/step); 
    indf = step*(0 : n_frame - 1);
    inds = (1 : L_frame )';
    index = repmat(indf, L_frame, 1) + repmat(inds, 1, n_frame);
    audio_frame = audio(index);
    [L_frame, t] = size(audio_frame);
    audio_fft = zeros(size(audio_frame));
    for i = 1 : t
        audio_fft(:, i) = fft(audio_frame(:, i) .* hanning(L_frame), L_frame);
    end
    audio_fft =  audio_fft';
end
    