% function S_LMMSE = LMMSE(clean_fft,noise_fft, Cw,n_mic)
% 
    mu_s = mean(clean_fft,1);
    var_s = var(clean_fft,1);
    C_s = var_s;
    var_w = squeeze(var(noise_fft,0,1));
    C_w = diag(var_w(k,1:n_mic));
    A_m = ones(n_mic,1);
    Y_lk = squeeze(noise_fft(l,k,1:n_mic));
    %lth time frame
%     mu_s = mean(clean_fft,1);
%     var_s = var(clean_fft,1);
%     C_s = var_s;
%     var_w = var(noise_fft,0,1);
%     C_w = diag(var(:,k,1:n_mic));
%     A_m = ones(n_mic,1);
%     Y_l = noise(:,k,1:n_mic);
%     
    s_estimate = zeros(size(clean_fft));
    C = inv(A_m.*C_s(k).*(A_m')+C_w);
    s_estimate(l,k)= mu_s(k)+ C_s(k).*(A_m')*C*(Y_lk-A_m.*mu_s(k));
    

% end