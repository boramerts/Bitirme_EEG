%data
load('EEG_Data.mat');
fs = 500;
t = 0:1/fs:(91000-1)/fs;
t2 = 0:1/fs:(31000-1)/fs;
tm = 1:91000;
tm2 = 1:31000;
win_size = 500;
figure;
subplot(121)
plot(t2,cell2mat(group_g(1,2,1)));
grid on
xlabel('Time (s)')
ylabel('Voltage (mV)')
title('signal in time domain')
x=cell2mat(group_g(1,2,1));
y=cell2mat(group_g(1,2,2));
yb1 = bandpass(y,[1,4],fs);
xb1 = bandpass(x,[1,4],fs);    % signal filtered in delta band
xb2 = bandpass(x,[4,8],fs);    % signal filtered in theta band
xb3 = bandpass(x,[8,15],fs);   % signal filtered in alfa band
xb4 = bandpass(x,[15,25],fs);  % signal filtered in beta band
xb5 = bandpass(x,[25,45],fs);

% figure;
% subplot(211)
% plot(t2, xb1)
% ylabel('BB')
% title('Voltage band decomposition')
% subplot(212)
% plot(t2, yb1)
% figure;
% mscohere(xb1,yb1,hann(1024),512,1024,fs); % Plot estimate

% %islem sirasi alpha
% subject_2_al = zeros(size(subjects(:,2,:)));
% subject_2_al = cell(21,1,36);
% for su = 1 : 36
%     for ch = 1 : 21
%         subject_2_al(ch,:,su) = bandpass(subjects{ch, 2, su}(1:31000),[8, 15],fs);
%     end
% end
EEG.freqwin(3)=8;
EEG.freqwin(4)=15;

subject = 2;
    [coh, f] = mscohere(cell2mat(group_g(subject,2, 1)), cell2mat(group_g(subject ,2,2)), hanning(512), 500, 1024, fs);

figure
plot(f,coh, '-')
hold
plot(f(f>=EEG.freqwin(3) & f<=EEG.freqwin(4)), coh(f>=EEG.freqwin(3) & f<=EEG.freqwin(4)), 'ro')
plot([EEG.freqwin(3) EEG.freqwin(3)], [min(coh) 1], '--k')
plot([EEG.freqwin(4) EEG.freqwin(4)], [min(coh) 1], '--k')
legend('Coherence', '\alpha Coherence')
xlabel('Frequency (Hz)')
ylabel('Coherence')
text(10,0.98, '\alpha', 'FontSize', 20)
set(gcf, 'units','normalized','outerposition',[0 0 1 1])


sujeto = 1;
cxyler=cell(26,1);
pairs = nchoosek(1:21,2);
for subject=1:26
cxy = zeros(21,21);
    for pr = 1 : length(pairs)
        [coh, f] = mscohere(cell2mat(group_g(subject,2, pairs(pr,1))), cell2mat(group_g(subject,2, pairs(pr,2))), hanning(200), 25, 200, fs);
        cxy(pairs(pr,1), pairs(pr,2)) = mean(coh(f>=EEG.freqwin(3) & f<=EEG.freqwin(4)));
    end
cxy = cxy + cxy';
cxyler{subject,1}=cxy;
end

figure
tiledlayout(2,4);
nexttile;
imagesc(cxyler{1});
axis square;    colorbar;  title('Coherence');
nexttile;
imagesc(cxyler{2});
axis square;    colorbar;  title('Coherence');
nexttile;
imagesc(cxyler{3});
axis square;    colorbar;  title('Coherence');
nexttile;
imagesc(cxyler{4});
axis square;    colorbar;  title('Coherence');
nexttile;
imagesc(cxyler{5});
axis square;    colorbar;  title('Coherence');
nexttile;
imagesc(cxyler{6});
axis square;    colorbar;  title('Coherence');
nexttile;
imagesc(cxyler{7});
axis square;    colorbar;  title('Coherence');
nexttile;
imagesc(cxyler{8});
axis square;    colorbar;  title('Coherence');


% ylabel('V-\delta')
% subplot(613)
% plot(t2, xb2)
% ylabel('V-\theta')
% subplot(614)
% plot(t2, xb3)
% ylabel('V-\alpha')
% subplot(615)
% plot(t2, xb4)
% ylabel('V-\beta')
% subplot(616)
% plot(t2, xb5)
% xlabel('Time (s)')
% ylabel('V-\gamma')
% set(gcf, 'units','normalized','outerposition',[0 0 1 1])