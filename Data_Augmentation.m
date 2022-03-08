load('EEG_Data.mat');

group_b_augmented = cell(10,2,21);

for i = 1:10
    for k = 1:2
        for m = 1:21
            group_b_augmented{i,k,m} = awgn(group_b{i,k,m},1);
        end
    end
end

new_group_b = [group_b;group_b_augmented];

save('EEG_Data.mat');