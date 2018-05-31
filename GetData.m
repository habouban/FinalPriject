

function [Covs, labels_matrix, specific_motion_matrix] = GetData(num_of_patients, num_of_measures)

labels_matrix = NaN(num_of_patients, num_of_measures);

specific_motion_matrix = NaN(num_of_patients, num_of_measures);

for kk = 1:num_of_patients
    
    for ss=1:14
        
        file = ['S' num2str(kk,'%03d') 'R' num2str(ss,'%02d') '_edfm'];
        load(file);
        
        pat_num = str2num(file(2:4));
        
        mX = val(1:64,:);
        
        Covs{kk,ss} = cov(mX');
        
        test_num = str2num(file(6:7));
        
        switch test_num
            case 1
                tag = 0;
                motion = 8;
            case 2
                tag = 1;
                motion = 8;
            case {3, 7, 11}
                tag = 2;
                motion = 9;
            case {4, 8, 12}
                tag = 3;
                motion = 9;
            case {5, 9, 13}
                tag = 4;
                motion = 7;
            case {6, 10, 14}
                tag = 5;
                motion = 7;
        
                
                
%             case {3, 4, 7, 8, 11, 12} %left or right fist
%                 motion = 9;
%             case 2
%                 motion = 8;
%             case {5, 6, 9, 10, 13, 14} %both fists or feets
%                 motion = 7;
%             case {0, 1}
%                 motion = 8;
            
        end
        labels_matrix(kk, ss) = tag;
        specific_motion_matrix(kk, ss) = motion;
        
                
    end
end