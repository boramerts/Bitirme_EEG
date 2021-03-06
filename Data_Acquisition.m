clear; clc;

group_b = cell(8,2,10);
group_g = cell(25,2,10);

group_b = getB(group_b);
group_g = getG(group_g);

fs = 500;
t = 0:1/fs:(91000-1)/fs;
t2 = 0:1/fs:(31000-1)/fs;
tm = 1:91000;
tm2 = 1:31000;
win_size = 500;

save("EEG_Data.mat");

function EEG_data = getData(subj_no, test, ch)
channels = ["EEG Fp1"  "EEG Fp2"  "EEG F3"  "EEG F4"...
    "EEG C3" "EEG P3" "EEG P4" "EEG O1"...
    "EEG O2" "EEG Cz"];
subject_no = append(subj_no , '_' , int2str(test));
disp("Creating: " + subject_no + "  Channel:" + channels(ch));
folderPath = matlab.desktop.editor.getActiveFilename;
fileName = append(subject_no, '.edf');
folderPath = erase(folderPath,'Data_Acquisition.m'); folderPath = fullfile(folderPath, 'eeg-during-mental-arithmetic-tasks-1.0.0', fileName);
EEG_edf = edfread(folderPath, 'SelectedSignals', channels(ch));
EEG_array = table2array(EEG_edf);
EEG_data = vertcat(EEG_array{:});
end

%channels = ["EEG Fp1"  "EEG Fp2"  "EEG F3"  "EEG F4" "EEG F7"  "EEG F8" "EEG T3" "EEG T4" "EEG C3" "EEG C4" "EEG T5" "EEG T6" "EEG P3" "EEG P4" "EEG O1" "EEG O2" "EEG Fz" "EEG Cz"  "EEG Pz"  "EEG A2-A1"  "ECG ECG"];


function group_b = getB(group_b)
group_b_list = table2array(readtable('subject-info.csv', 'Range', 'A2:A11'));
num = 1;  is_correct = 0;
for i = 1:10
    if is_correct == 1
        num = num+1;
        is_correct = 0;
    end
    subject = convertCharsToStrings(group_b_list{i}(:));
    for k = 1:2
        for m = 1:10
            if length(getData(subject,1,m)) == 91000 && length(getData(subject,2,m)) == 31000
                is_correct = 1;
                group_b{num,k,m} = getData(subject,k,m);
                disp(num);
            end
        end
    end
end
end

function group_g = getG(group_g)
group_g_list = table2array(readtable('subject-info.csv', 'Range', 'A12:A37'));
num = 1; is_correct = 0;
for i = 1:26
    if is_correct == 1
        num = num+1;
        is_correct = 0;
    end
    subject = convertCharsToStrings(group_g_list{i}(:));
    for k = 1:2
        for m = 1:10
            if length(getData(subject,1,m)) == 91000 && length(getData(subject,2,m)) == 31000
                is_correct = 1;
                group_g{num,k,m} = getData(subject,k,m);
                disp("Group G ");
            end
        end
    end
end
end


