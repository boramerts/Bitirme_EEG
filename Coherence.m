clear; clc;
load('EEG_Data.mat');

% data1 = bandpass(new_group_b{1,1,1}(1:5000),[8 13],fs);
% data2 = bandpass(new_group_b{1,1,2}(1:5000),[8 15],fs);
% data3 = bandpass(new_group_b{1,1,3}(1:5000),[8 15],fs);
% data4 = bandpass(new_group_b{1,1,4}(1:5000),[8 15],fs);
% 
% [cxy,fc] = mscohere(data1,data2,hamming(512),256,1024,fs);
% [cxy2,fc2] = mscohere(data1,data3,hamming(512),256,1024,fs);
% [cxy3,fc3] = mscohere(data1,data4,hamming(512),256,1024,fs);
% 
% plot(fc, cxy);

cxy_sum_b = zeros(513,20);
fc_sum_b = zeros(513,20);

for i = 1:20
    data1 = bandpass(new_group_b{i,1,1}(1:85000),[8 13],fs);
    data2 = bandpass(new_group_b{i,1,2}(1:85000),[8 13],fs);
    
    [cxy,fc] = mscohere(data1,data2,hamming(512),500,1024,fs);
    cxy_sum_b(:,i)= cxy;
    fc_sum_b(:,i)= fc;
end

cxy_mean_b = mean(cxy_sum_b,2);
fc_mean_b = mean(fc_sum_b,2);

cxy_sum_g = zeros(513,20);
fc_sum_g = zeros(513,20);

for i = 1:20
    data1 = bandpass(group_g{i,1,1}(1:31000),[8 13],fs);
    data2 = bandpass(group_g{i,1,2}(1:31000),[8 13],fs);
    
    [cxy,fc] = mscohere(data1,data2,hamming(512),500,1024,fs);
    cxy_sum_g(:,i)= cxy;
    fc_sum_g(:,i)= fc;
end
    
cxy_mean_g = mean(cxy_sum_g,2);
fc_mean_g = mean(fc_sum_g,2);

plot(fc_mean_b, cxy_mean_b); hold on;
plot(fc_mean_g, cxy_mean_g); hold off;
xlim([7.95 14.95]);
% axis([0 20 0 0.025]);
