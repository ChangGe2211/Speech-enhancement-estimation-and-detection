function var_est = var_estimate(noise_only)
    %calculate the variance of the noisy signal part
    [~,K,n_mic] = size(noise_only);
    var_est = zeros(n_mic,K);
    for i=1:n_mic
        for k=1:K
            var_est(i,k) = var(noise_only(:,k,i));
        end
    end
end