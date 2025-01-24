function estimator = blue(signal,noise_only,mic_used)
    [signal_1, signal_2, ~] = size(signal);
    s_hat = zeros(signal_1,signal_2);
    %s_hat_size = size(s_hat);
    A = ones(mic_used,1);
    A_T = transpose(A); 
    for i = 1:mic_used
        for k = 1:signal_2
            var_freq(i,k) = var(noise_only(:,k,i)); % mic_usedx320
            %[var_1,var_2]=size(var_freq); % mic_usedx320
            C = diag(var_freq(:,k));
            Cinv = inv(C);
            if i == mic_used
                for l = 1:signal_1
                    %A_T_s=size(A_T);
                    %A_s=size(A);
                    %Cinv_s=size(Cinv);
                    %Signal_norm = size(signal(l,k,:));
                    Signal_first = signal(l,k,1:mic_used)
                    Signal_moment = transpose(reshape(signal(l,k,1:mic_used),1,[])) %mic_usedx1
                    signal_m_s = size(Signal_moment);
                    %Signal_s=size(signal(l,k));
                    s_hat(l,k)=((A_T*Cinv*A)^(-1))*(A_T*Cinv*Signal_moment);
                    size(signal(l,k));
                end
            end
        end
    end
    
    
    estimator = s_hat; % blue estimator inv(transpose(h)inv(noise_cov)h)transpose(h)inv(noise_cov)signal
end