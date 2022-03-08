cfg            = [];
cfg.dataset    = 'D:\Okul\Bitirme_Projesi\EEG_MATLAB\eeg-during-mental-arithmetic-tasks-1.0.0\Subject00_1.edf';
cfg.continuous = 'yes';
cfg.channel    = 'all';
data           = ft_preprocessing(cfg);
cfg.dataset    = 'D:\Okul\Bitirme_Projesi\EEG_MATLAB\eeg-during-mental-arithmetic-tasks-1.0.0\Subject01_1.edf';
data2          = ft_preprocessing(cfg);
data3          = ft_appenddata([], data, data2);

figure
subplot(2,1,1);
plot(data3.time{1},data3.trial{1}(1,:));
axis tight;
legend(data3.label(1));

subplot(2,1,2);
plot(data3.time{2},data3.trial{2}(1,:));
axis tight;
legend(data3.label(1));

cfg            = [];
cfg.output     = 'fourier';
cfg.method     = 'mtmfft';
cfg.foilim     = [5 100];
cfg.tapsmofrq  = 5;
cfg.pad = 'nextpow2';
freqfourier    = ft_freqanalysis(cfg, data3);


