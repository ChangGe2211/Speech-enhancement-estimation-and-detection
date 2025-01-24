clear
clc
close all
load('Data.mat');

%% Transfer signals into frequency domain
%20ms frame length, 50% overlap, hann window
fs = 16000; 
t_frame = 0.020 ;       %20ms window size
L_frame = t_frame *fs;
hann_win = hanning(L_frame);
L_noise = 1*fs;         %assume 1st second is noise only
noise_audio = Data(1:L_noise,:);
audio = Data(L_noise+1:end,:);
clean_audio = Clean(L_noise+1:end,:);
clean_fft = enframe(clean_audio,L_frame); 
%concatenate the fft results
for i = 1:nrmics
    audio_fft_1 = enframe(audio(:,i),L_frame);
    noise_fft_1 = enframe(noise_audio(:,i),L_frame);
    if i == 1
        audio_fft = audio_fft_1;
        noise_fft = noise_fft_1;
    else
        audio_fft = cat(3,audio_fft,audio_fft_1);
        noise_fft = cat(3,noise_fft,noise_fft_1);
    end
end
%% Calculate noise variance
var_est = var_estimate(noise_fft);
%% Determine the estimator and calculate variance
nrmics = 16;
var = zeros(nrmics,1);
for j =1:nrmics
    estimator = mvue(audio_fft,var_est,j);
    [L,K] = size(estimator);
    var(j) = sum(abs(estimator-clean_fft).^2,'all')/(K*L);
end
%% CRLB
crlb_mic = zeros(nrmics,1);
for ii = 1:nrmics
    crlb_fre = crlb(audio_fft,noise_fft,ii);
    crlb_mic(ii) = mean(crlb_fre);
    
end
%% Graphs variance
mic = 1:16;
figure(1),
plot(mic,var,'-x','LineWidth',1.5,'MarkerSize',12),
hold on
plot(mic,crlb_mic,'--*','LineWidth',1.5,'MarkerSize',8,'Color',[1, 0, 0, 0.5])
title('Variance comparison CRLB and estimator')
xlabel('Number of microphones')
ylabel('Variance')
legend('Var_{emp}','CRLB')
hold off;
figure(2);
bar(mic,100*(var(:,1)-crlb_mic)/crlb_mic)
title('Error percentage between CRLB and estimator')
xlabel('Number of microphones')
ylabel('Error percentage')
hold off;
