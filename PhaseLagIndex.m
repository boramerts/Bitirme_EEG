clear; clc;
load('EEG_Data.mat');

t = 0:1/fs:(500-1)/fs;

data = zeros(2,length(t));
data(1,:) = bandpass(new_group_b{1,1,2}(501:1000),[8 13],fs);
data(2,:) = bandpass(new_group_b{1,1,3}(501:1000),[8 15],fs);

% create complex Morlet wavelet
center_freq = 5; % in Hz
time        = -1:1/fs:1; % time for wavelet
wavelet     = exp(2*1i*pi*center_freq.*time) .* exp(-time.^2./(2*(4/(2*pi*center_freq))^2))/center_freq;
half_of_wavelet_size = (length(time)-1)/2;

% FFT parameters
n_wavelet     = length(time);
n_data        = length(data);
n_convolution = n_wavelet+n_data-1;

% FFT of wavelet
fft_wavelet = fft(wavelet,n_convolution);

% initialize output time-frequency data
phase_data = zeros(2,length(data));
real_data  = zeros(2,length(data));

% run convolution and extract filtered signal (real part) and phase
for chani=1:2
    fft_data = fft(squeeze(data(chani,:)),n_convolution);
    convolution_result_fft = ifft(fft_wavelet.*fft_data,n_convolution) * sqrt(4/(2*pi*center_freq));
    convolution_result_fft = convolution_result_fft(half_of_wavelet_size+1:end-half_of_wavelet_size);
 
    % collect real and phase data
    phase_data(chani,:) = angle(convolution_result_fft);
    real_data(chani,:)  = real(convolution_result_fft);
end

% open and name figure
figure, set(gcf,'Name','Phase Lag Index');

% draw the filtered signals
subplot(321)
filterplotH1 = plot(t(1),real_data(1,1),'b');
hold on
filterplotH2 = plot(t(1),real_data(2,1),'m');
set(gca,'xlim',[t(1) t(end)],'ylim',[min(real_data(:)) max(real_data(:))])
xlabel('Time (ms)')
ylabel('Voltage (\muV)')
title([ 'Filtered signal at ' num2str(center_freq) ' Hz' ])

% draw the phase angle time series
subplot(322)
phaseanglesH1 = plot(t(1),phase_data(1,1),'b');
hold on
phaseanglesH2 = plot(t(1),phase_data(2,1),'m');
set(gca,'xlim',[t(1) t(end)],'ylim',[-pi pi]*1.1,'ytick',-pi:pi/2:pi)
xlabel('Time (ms)')
ylabel('Phase angle (radian)')
title('Phase angle time series')

% draw phase angle differences in cartesian space
subplot(323)
filterplotDiffH1 = plot(t(1),real_data(1,1)-real_data(2,1),'b');
set(gca,'xlim',[t(1) t(end)],'ylim',[-10 10])
xlabel('Time (ms)')
ylabel('Voltage (\muV)')
title([ 'Filtered signal at ' num2str(center_freq) ' Hz' ])

% draw the phase angle time series
subplot(324)
phaseanglesDiffH1 = plot(t(1),phase_data(1,1)-phase_data(2,1),'b');
set(gca,'xlim',[t(1) t(end)],'ylim',[-pi pi]*2.2,'ytick',-2*pi:pi/2:pi*2)
xlabel('Time (ms)')
ylabel('Phase angle (radian)')
title('Phase angle time series')

% draw phase angles in polar space
subplot(325)
polar2chanH1 = polarplot([phase_data(1,1) phase_data(1,1)]',repmat([0 1],1,1)','b');
hold on
polar2chanH2 = polarplot([phase_data(1,1) phase_data(2,1)]',repmat([0 1],1,1)','m');
title('Phase angles from two channels');

% draw phase angle differences in polar space
subplot(326)
polarAngleDiffH = polarplot([zeros(1,1) phase_data(2,1)-phase_data(1,1)]',repmat([0 1],1,1)','k');
title('Phase angle differences from two channels');

% now update plots at each timestep
% Note: in/decrease skipping by 10 to speed up/down the movie
for ti=1:10:length(data)
    
    % update filtered signals
    set(filterplotH1,'XData',t(1:ti),'YData',real_data(1,1:ti))
    set(filterplotH2,'XData',t(1:ti),'YData',real_data(2,1:ti))
    
    % update cartesian plot of phase angles
    set(phaseanglesH1,'XData',t(1:ti),'YData',phase_data(1,1:ti))
    set(phaseanglesH2,'XData',t(1:ti),'YData',phase_data(2,1:ti))
    
    % update cartesian plot of phase angles differences
    set(phaseanglesDiffH1,'XData',t(1:ti),'YData',phase_data(1,1:ti)-phase_data(2,1:ti))
    set(filterplotDiffH1,'XData',t(1:ti),'YData',real_data(1,1:ti)-real_data(2,1:ti))
    
    subplot(325)
    cla
    polarplot(repmat(phase_data(1,1:ti),1,2)',repmat([0 1],1,ti)','b');
    hold on
    polarplot(repmat(phase_data(2,1:ti),1,2)',repmat([0 1],1,ti)','m');
    
    subplot(326)
    cla
    polarplot(repmat(phase_data(2,1:ti)-phase_data(1,1:ti),1,2)',repmat([0 1],1,ti)','k');
    
    drawnow
end

