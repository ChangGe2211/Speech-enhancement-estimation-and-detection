function s_estimate = MMSE(clean_fft,audio_fft,noise_fft,n_mic)

mu_s = mean(clean_fft,1);
var_s = var(clean_fft,1);
C_s = var_s;
var_w = squeeze(var(noise_fft,0,1));
A_m = ones(n_mic,1);
[L,K]= size(clean_fft);
s_estimate = zeros(L,K);
for k = 1:K
    C_w = diag(var_w(k,1:n_mic));
    C = inv(A_m.*C_s(k).*(A_m')+C_w);
    for l = 1:L
        Y_lk = squeeze(audio_fft(l,k,1:n_mic));
        s_estimate(l,k)= mu_s(k)+ C_s(k).*(A_m')*C*(Y_lk-A_m.*mu_s(k));
    end
end

end