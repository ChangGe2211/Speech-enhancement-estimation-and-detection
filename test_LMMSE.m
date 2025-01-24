% clear
% clc
% close all
load('Data.mat');

%% transfer into frequency domain
%20ms frame length, 50%overlap, hann window

fs = 16000; 
t_frame = 0.020 ; %20ms window size
L_frame = t_frame *fs;
hann_win = hanning(L_frame);
L_noise = 1*fs; %assume 1st second is noise only
noise_audio = Data(1:L_noise,:);
audio = Data(L_noise+1:end,:);
clean_audio = Clean(L_noise+1:end,:);
noisy_audio = Data(L_noise+1:end,1);
clean_fft = enframe(clean_audio,L_frame);

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
% figure,subplot(211);imagesc(imag(clean_fft(1*fs/20:1.2*fs/20,:)));subplot(212);imagesc(imag(audio_fft(1*fs/20:1.2*fs/20,:,1)));
% mu_s = mean(clean_fft,1);
% var_s = var(clean_fft,1);
% C_s = var_s;
% var_w = squeeze(var(noise_fft,0,1));
%%
figure,histfit(real(clean_fft(:,1))),
title('Histogram of frequency domain clean speech signal (1_{st} frequency band)')
ylabel('Count'),
xlabel('Value ')
[L,K] = size(clean_fft);
%   nrmics = 3;
s_estimate = zeros(L,K,nrmics);
var_LMMSE = zeros(nrmics,1);
for m = 1:nrmics
    s_estimate(:,:,m) = LMMSE(clean_fft,audio_fft,noise_fft,m);
    var_LMMSE(m) = sum(abs(s_estimate(:,:,m)-clean_fft).^2,'all')/(K*L);
end

%%
crlb_mic = zeros(nrmics,1);
for ii = 1:nrmics
    crlb_fre = crlb(audio_fft,noise_fft,ii);
    crlb_mic(ii) = mean(crlb_fre);
    
end
%% compare with crlb

mic = 1:16;
figure,
plot(mic,var_LMMSE,'-x','LineWidth',1.5,'MarkerSize',12),
hold on
plot(mic,crlb_mic,'-*','LineWidth',1.5,'MarkerSize',12)
title('Variance comparison CRLB and LMSSE')
xlabel('Number of microphones')
ylabel('Variance')
legend('Var_{MMSE}','CRLB')
hold off;

%% plot audio
% noisy_audio = Data(:,1);
enhanced_audio_1 = recover_signal(s_estimate(:,:,16));
enhanced_audio_16 = recover_signal(s_estimate(:,:,16));

t =(0:length(clean_audio)-1)/fs;
t_min = 1*fs;
t_max = 3*fs;
 min=-11;
 max = 11;
figure,
subplot(411);
plot(t(t_min:t_max),clean_audio(t_min:t_max));ylim([-max,max]);title('Clean speech');xlabel('t/s');ylabel('magnitude');
subplot(412);
plot(t(t_min:t_max),noisy_audio(t_min:t_max));ylim([-max,max]);title('Noisy speech');xlabel('t/s');ylabel('magnitude');
subplot(413);
plot(t(t_min:t_max),real(enhanced_audio_1(t_min:t_max)));ylim([-max,max]);title(['Enhanced speech: MMSE, 1 microphone']);xlabel('t/s');ylabel('magnitude');
subplot(414);
plot(t(t_min:t_max),real(enhanced_audio_16(t_min:t_max)));ylim([-max,max]);title(['Enhanced speech: MMSE, 16 microphones ']);xlabel('t/s');ylabel('magnitude');

saveas(gcf, [filter_name,'_audio.png']); 
