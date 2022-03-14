clear; clc;
load('EEG_Data.mat');

win_size = 500;
t = 0:1/fs:(win_size-1)/fs;
a = 1;

k = 1;
for i = 1:16
        in_data(i,:) = bandpass(new_group_b{i,1,1}(1+a*win_size:500+a*win_size),[8 13],fs);
end

pairs = nchoosek(1:6,2);

% create complex Morlet wavelet
center_freq = 5; % in Hz
time        = -1:1/fs:1; % time for wavelet
wavelet     = exp(2*1i*pi*center_freq.*time) .* exp(-time.^2./(2*(4/(2*pi*center_freq))^2))/center_freq;
half_of_wavelet_size = (length(time)-1)/2;
% FFT parameters
n_wavelet     = length(time);
n_data        = length(in_data);
n_convolution = n_wavelet+n_data-1;
% FFT of wavelet
fft_wavelet = fft(wavelet,n_convolution);
% initialize output time-frequency data
phase_data = zeros(2,length(in_data));
real_data  = zeros(2,length(in_data));

for subjects = 1:height(in_data)
    fft_data = fft(squeeze(in_data(subjects,:)),n_convolution);
    convolution_result_fft = ifft(fft_wavelet.*fft_data,n_convolution) * sqrt(4/(2*pi*center_freq));
    convolution_result_fft = convolution_result_fft(half_of_wavelet_size+1:end-half_of_wavelet_size);
    
    phase_data(subjects,:) = angle(convolution_result_fft);
    real_data(subjects,:)  = real(convolution_result_fft);
end

figure('Name','Phase Lag Index');

for plotId = 1:height(pairs)
    subplot(3,5,plotId);
    polarAngleDiffH = polarplot(repmat(phase_data(pairs(plotId,1),:)-phase_data(pairs(plotId,2),:)*1,2)',repmat([0 1],1,length(phase_data))','k');
    title("Subject "+pairs(plotId,1) + "vs. Subject " + pairs(plotId,2));
end
