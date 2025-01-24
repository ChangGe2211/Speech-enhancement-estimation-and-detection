clear
clc
close all
load('Data.mat');

%% transfer into frequency domain
%20ms frame length, 50%overlap, hann window

fs = 16000; 
t_frame = 0.020 ; %20ms window size
L_frame = t_frame *fs;
hann_win = hanning(L_frame);
L_noise = 1*fs; %assume 1st second is noise only
noise_audio = Data(1:L_noise,:);
noisy_audio = Data(L_noise+1:end,1);
audio = Data(L_noise+1:end,:);
clean_audio = Clean(L_noise+1:end,:);
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
%clean_fft: clean audio
%% Calculate noise variance
var_est = var_estimate(noise_fft);
%% Use of estimator
nrmics = 16;
var = zeros(nrmics,1);
[L,K] = size(clean_fft);
S_MVUE = zeros(L,K,nrmics);
for j =1:nrmics
    estimator = mvue(audio_fft,var_est,j);
    S_MVUE(:,:,j) = estimator;
    var(j) = sum(abs(estimator-clean_fft).^2,'all')/(K*L);
end
%% CRLB
crlb_mic = zeros(nrmics,1);
for ii = 1:nrmics
    crlb_fre = crlb(audio_fft,noise_fft,ii);
    crlb_mic(ii) = mean(crlb_fre);
    
end
%% Comparison
mic = 1:16;
figure(1);
plot(mic,crlb_mic,'Color','b')
hold on;
plot(mic,crlb_mic,'+','Color','b','MarkerSize',4,'LineWidth',4);

hold on;
plot(mic,var(:,1),'*','Color','r','MarkerSize',8);
title('Variance comparison CRLB and estimator')
xlabel('Number of microphones')
ylabel('Variance')
legend('CRLB','~','Var_{emp}')
hold off;
figure(2);
bar(mic,100*(var(:,1)-crlb_mic)/crlb_mic)
title('Error percentage between CRLB and estimator')
xlabel('Number of microphones')
ylabel('Error percentage')
hold off;

%% MMSE
s_MMSE = zeros(L,K,nrmics);
var_MMSE = zeros(nrmics,1);
for m = 1:nrmics
    s_MMSE(:,:,m) = MMSE(clean_fft,audio_fft,noise_fft,m);
    var_MMSE(m) = sum(abs(s_MMSE(:,:,m)-clean_fft).^2,'all')/(K*L);
end
%% compare with crlb

mic = 1:16;
figure,
plot(mic,var_MMSE,'-x','LineWidth',1.5,'MarkerSize',12),
hold on
plot(mic,crlb_mic,'-*','LineWidth',1.5,'MarkerSize',12)
title('Variance comparison CRLB and LMSSE')
xlabel('Number of microphones')
ylabel('Variance')
legend('Var_{MMSE}','CRLB')
hold off;

%% plot audio
% noisy_audio = Data(:,1);
enhanced_audio_MVUE1 = recover_signal(S_MVUE(:,:,1));
enhanced_audio_MVUE16 = recover_signal(S_MVUE(:,:,16));
enhanced_audio_MMSE1 = recover_signal(s_MMSE(:,:,1));
enhanced_audio_MMSE16 = recover_signal(s_MMSE(:,:,16));

t =(0:length(clean_audio)-1)/fs;
t_min = 1*fs;
t_max = 3*fs;
 min=-11;
 max = 11;
figure,
subplot(611);
plot(t(t_min:t_max),clean_audio(t_min:t_max));ylim([-max,max]);title('Clean speech');xlabel('t[s]');ylabel('magnitude');
subplot(612);
plot(t(t_min:t_max),noisy_audio(t_min:t_max));ylim([-max,max]);title('Noisy speech');xlabel('t[s]');ylabel('magnitude');
subplot(613);
plot(t(t_min:t_max),real(enhanced_audio_MVUE1(t_min:t_max)));ylim([-max,max]);title(['Enhanced speech: MVUE, 1 microphone']);xlabel('t[s]');ylabel('magnitude');
subplot(614);
plot(t(t_min:t_max),real(enhanced_audio_MVUE16(t_min:t_max)));ylim([-max,max]);title(['Enhanced speech: MVUE, 16 microphones ']);xlabel('t[s]');ylabel('magnitude');
subplot(615);
plot(t(t_min:t_max),real(enhanced_audio_MMSE1(t_min:t_max)));ylim([-max,max]);title(['Enhanced speech: MMSE, 1 microphone']);xlabel('t[s]');ylabel('magnitude');
subplot(616);
plot(t(t_min:t_max),real(enhanced_audio_MMSE16(t_min:t_max)));ylim([-max,max]);title(['Enhanced speech: MMSE, 16 microphones ']);xlabel('t[s]');ylabel('magnitude');
