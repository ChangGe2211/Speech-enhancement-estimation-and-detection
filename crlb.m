function min_var = crlb(signal,noise_only,mic_used)
    [~, signal_2, ~] = size(signal);
    %s_hat_size = size(s_hat);
    A = ones(mic_used,1);
    A_T = transpose(A); 

    for k = 1:signal_2
        var_freq(k) = var(noise_only(:,k,mic_used)); % mic_usedx320
        C = diag(var_freq(k));
        Cinv = inv(C);
        min_var(k) = 1/(A_T*Cinv*A);
    end
end