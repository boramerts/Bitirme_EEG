clear; clc;

group_b = cell(10,2,21);
group_g = cell(26,2,21);

group_b = getB(group_b);
group_g = getG(group_g);

fs = 500;
t = 0:1/fs:(91000-1)/fs;
t2 = 0:1/fs:(31000-1)/fs;
tm = 1:91000;
tm2 = 1:31000;
win_size = 500;

save("EEG_Data.mat");

data = getData(subject,1,1);

function EEG_data = getData(subj_no, test, ch)
channels = ["EEG Fp1"  "EEG Fp2"  "EEG F3"  "EEG F4" "EEG F7"  "EEG F8" "EEG T3" "EEG T4" "EEG C3" "EEG C4" "EEG T5" "EEG T6" "EEG P3" "EEG P4" "EEG O1" "EEG O2" "EEG Fz" "EEG Cz"  "EEG Pz"  "EEG A2-A1"  "ECG ECG"];
subject_no = append(subj_no , '_' , int2str(test));
disp("Creating: " + subject_no + "  Channel:" + channels(ch));
folderPath = matlab.desktop.editor.getActiveFilename;
fileName = append(subject_no, '.edf');
folderPath = erase(folderPath,'Data_Acquisition.m'); folderPath = fullfile(folderPath, 'eeg-during-mental-arithmetic-tasks-1.0.0', fileName);
EEG_edf = edfread(folderPath, 'SelectedSignals', channels(ch));
EEG_array = table2array(EEG_edf);
EEG_data = vertcat(EEG_array{:});
end


function group_b = getB(group_b)
group_b_list = table2array(readtable('subject-info.csv', 'Range', 'A2:A11'));

for i = 1:10
    subject = convertCharsToStrings(group_b_list{i}(:));
    for k = 1:2
        for m = 1:21
            group_b{i,k,m} = getData(subject,k,m);
            disp("Group B ");
        end
    end
end
end

function group_g = getG(group_g)
group_g_list = table2array(readtable('subject-info.csv', 'Range', 'A12:A37'));

for i = 1:26
    subject = convertCharsToStrings(group_g_list{i}(:));
    for k = 1:2
        for m = 1:21
            group_g{i,k,m} = getData(subject,k,m);
            disp("Group G ");
        end
    end
end
end


