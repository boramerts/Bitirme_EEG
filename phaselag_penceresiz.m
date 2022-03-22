clear; clc;
load('EEG_Data.mat');

t = 0:1/fs:(win_size-1)/fs;
pairs = nchoosek(1:10,2);

phase_sum = zeros(10,91000);
in_data = zeros(10,91000);
% create complex Morlet wavelet
center_freq = 5; % in Hz
time        = -1:1/fs:1; % time for wavelet
wavelet     = exp(2*1i*pi*center_freq.*time) .* exp(-time.^2./(2*(4/(2*pi*center_freq))^2))/center_freq;
half_of_wavelet_size = (length(time)-1)/2;
mean_features = cell(26,45);

channel_names = ["Fp1"  "Fp2"  "F3"  "F4"...
    "C3" "P3" "P4" "O1"...
    "O2" "Cz"];

for subject = 1:25
    for i = 1:10
        in_data(i,:) = bandpass(group_g{subject,1,i},[8 13],fs);
    end
    
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
    
    for channels = 1:height(in_data)
        fft_data = fft(squeeze(in_data(channels,:)),n_convolution);
        convolution_result_fft = ifft(fft_wavelet.*fft_data,n_convolution) * sqrt(4/(2*pi*center_freq));
        convolution_result_fft = convolution_result_fft(half_of_wavelet_size+1:end-half_of_wavelet_size);
        
        phase_data(channels,:) = angle(convolution_result_fft);
        real_data(channels,:)  = real(convolution_result_fft);
    end
    
    phase_mean = phase_data/182;
    
    for i = 1:height(pairs)
        features{i}= phase_mean(pairs(i,1),:)-phase_mean(pairs(i,2),:);
    end
    
    for k = 1:height(pairs)
        mean_features{1,k} = append(channel_names(pairs(k,1)),"-",channel_names(pairs(k,2)));
    end
    
    for i = 1:45
        mean_features{subject+1,i} = abs(mean(features{i}));
    end
    
end
