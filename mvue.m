function estimator = mvue(signal,var_est, mic_used)
    %implementation of the MVUE
    [L, K, ~] = size(signal);
    s_hat = zeros(L,K);
    A = ones(mic_used,1); %vector with all ones with length of microphones used
    A_T = transpose(A);
    var_freq = zeros(mic_used,K);
    for k = 1:K
        %create the noise covariance matrix
        var_freq(:,k) = var_est(1:mic_used,k); 
        C = diag(var_freq(:,k));
        Cinv = inv(C);
        for l = 1:L
            signal_moment = transpose(reshape(signal(l,k,1:mic_used),1,[]));
            s_hat(l,k)=((A_T*Cinv*A)^(-1))*(A_T*Cinv*signal_moment);
        end
    end    
    estimator = s_hat; 
end