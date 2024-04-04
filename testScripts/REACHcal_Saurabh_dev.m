% clc;
close all;
clearvars;

% dpath='C:\Users\spegwal\Downloads\Saurabh\MAT_REPO\Repository\SPegwal\Calibration_code\REACH calibration\REACH-RXcal\data\2023_12_11_14_32\';
dpath='C:\Users\spegwal\Downloads\Saurabh\MAT_REPO\Repository\SPegwal\Calibration_code\REACH calibration\REACH-RXcal\data\calibration\';
d = REACHcal(dpath);

% dpath='C:\Users\spegwal\Downloads\Saurabh\MAT_REPO\Repository\SPegwal\Calibration_code\REACH calibration\REACH-RXcal\data\2024_01_07_19_00\';
% dpath='C:\Users\spegwal\Downloads\Saurabh\MAT_REPO\Repository\SPegwal\Calibration_code\REACH calibration\REACH-RXcal\data\2024_01_09_19_00\';
% d = REACHcal_1(dpath);

% d1 = d.optimConfig('r36');%-41 %% [0.2562 8.1546 0.5558 36.5393]
% d1 = d.optimConfig('r27');%-44 %% [0.7343 13.8666 1.1080 26.9703]
% d1 = d.optimConfig('r69');%-58 %% [1.7602 20.6532 1.6276 70.3299]
% d1 = d.optimConfig('r91');%-53 %% [4.4003 38.0744 1.7313 93.1986]
% d1 = d.optimConfig('ropen','open');% -32 %% [12.7415 51.8423 3.5602 0.5066] %% MS4[49.5665 14.8399 1.7236 0 0] not good anough
% d1 = d.optimConfig('rshort','short');% -33 %% [0.7481 36.5877 0 2.0526] %% MS4[51.4801 19.5286 1.6474 0 0]
% d1 = d.optimConfig('r10');% -36 %% [1.6215 38.7883 10.9348 9.6950] %%MS4[49.0992 24.7951 1.6737 0 0]
% d1 = d.optimConfig('r250');% -35 %% [12.7036 21.0972 1.2503 255.0736] %% MS4[49.5945 15.8778 1.6913 0 0]
% d1 = d.optimConfig('rcold','cold');% -61 %% [1.1250 5.4561 0.7940 50.3582] %% MS4[50.2524 15.6277 1.6720 0 0]
% d1 = d.optimConfig('rhot','hot');% -67 %% [4.0034 10.0568 0.7256 50.8583] %% MS4[50.2524 15.6277 1.6720 0 0]
% d1 = d.optimConfig('r25');% -54 %% [6.7528 7.1022 3.5061 25.2671] %% MS4[50.2524 15.6277 1.6720 0 0]
% d1 = d.optimConfig('r100');% -77 %% [2.9395 31.7225 1.4477 100.3827] %% MS4[50.2524 15.6277 1.6720 0 0]
d.errorFuncType = 'RIA';
% d.errorFuncType = 'complexDistance';
% d.errorFuncType = 'magDistance';
d.errorFuncNorm = 'mean';
% d1 = d.optimConfig('ms3set');
% d1 = d.optimConfig('ms4set');


% d1 = d.optimConfig('custom',{'r36','r27','r69','r91','rOpen','rShort','r10','r250','rCold',...
%                     'rHot','r25','r100','ms1','ms3','ms4','mts','sr_mtsj1','sr_mtsj2'},...
%                     {'c12r36','c12r27','c12r69','c12r91','c25open','c25short',...
%                     'c25r10','c25r250','cold','hot','r25','r100'});
% 
% d1 = d.optimConfig('custom',{'rCold','rHot','r25','r100','ms1','mts','sr_mtsj1','sr_mtsj2'},...
%                     {'cold','hot','r25','r100'});

% d1 = d.optimConfig('custom',{'r25','r100','ms1','mts','sr_mtsj1','sr_mtsj2'},{'r25','r100'});

% d1 = d.optimConfig('custom',{'rCold','rHot','ms1','mts','sr_mtsj1','sr_mtsj2'},{'cold','hot'});

d1 = d.optimConfig('all');


d1 = d1.fitParams;

figure (1)
d1.plotAllS11(3,{'r','k'});

figure (2)
d1.plotAllParameters('r*');
% 
% case {'all'}
%                     switch obj.optTypeFlag
%                         case 1
%                             optElements = {'r36','r27','r69','r91','rOpen','rShort','r10','r250','rCold','rHot','r25','r100','ms1','ms3','ms4','mts','sr_mtsj1','sr_mtsj2'};
%                         case 2
%                             optElements = {'r36','r27','r69','r91','rOpen','rShort','r10','r250','rCold','rHot','r25','r100','ms1','ms3','ms4','sr_mtsj2'};
%                     end
%                     errElements = obj.optErrElements;

%             err_ri = sqrt(sum(abs(S11meas(:) - S11model(:)).^2));
%             err_a = sqrt(sum(abs(dB20(S11meas(:)) - dB20(S11model(:))).^2));
%             err = w*[err_ri;err_a]./obj.Nf;
%             f='C:\Users\spegwal\Downloads\Saurabh\MAT_REPO\Repository\SPegwal\Calibration_code\REACH calibration\parameters_vals';
%             if (status)
%                 disp('folder already exists');
%             end
            f = 'Param_data';
            status = mkdir('Param_data');
            
            D = datetime('now');
            DD = num2str(D.Day);MM = num2str(D.Month);YY = num2str(D.Year);Tm = num2str(D.Minute);Ts = num2str(D.Second);
            f_name = ['P_list_on_',DD,MM,YY((length(YY)-2):length(YY)),'_',Tm,Ts((length(Ts)-2):length(Ts)),'.txt'];
            filenameD = fullfile(dpath,f,f_name);
            fileID = fopen(filenameD,'w');
            op_S = strings([1,(nonzeros(obj.optE))]);
            op_W = strings([1,(nonzeros(obj.optW))]);
            for i=1:length(obj.optE)
                if obj.optE(i)
                    op_S(i) = obj.optVectElements{i};
                end
            end
            
            for i=1:length(obj.optW)
                if obj.optW(i)
                    op_W(i) = obj.optErrElements{i};
                end
            end
            %  obj.([obj.optVectElements{ii},'_vals'])
            fprintf(fileID, 'Source elelments:\n %s\nError elements:\n%s',op_E,op_W);
            S_name = obj.op_S{i};
            fprintf(fileID, [obj.op_S{i}, ' = '], obj.([op_S{i},'_vals']));
            fprintf(fileID, 'SOURCE FILE:\n %s\nDESTINATION FILE:\n%s',filenameS,filenameD);
            fclose(fileID);
            fclose('all') ;
            r36.vals = [3.1968 14.6230 1.8546 36.6797]
            op_E(4),'.vals = ', ruu_vals
            form = '%10s.vals =  %10.5f';
            fprintf(form,ruu_vals);
%**********************************************************************************
%                                 Individual source
%**********************************************************************************
%***********************************r36********************************************
% r36
%           vals: [4.0065 18.8989 5.7711 35.1956]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 38]
%            min: [0 0 0 34]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% ms3
%           vals: [55.9030 88.3192 1.8663 0.5620 4.4684]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [78 100 2 10 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% c2
%       network: [1×1 TwoPort]
%           vals: [49.4944 1.9005 0 1.4008 0.0099 0.0098 0 1.8382]
%     unitScales: [1 1 1 1 1 1 1 1]
%            max: [52 2.1000 0.1000 1.6000 0.0100 0.0100 0.1000 2]
%            min: [48 1.9000 -0.1000 1.4000 -0.0100 0 -0.1000 0]
%        optFlag: [1 1 0 1 1 1 0 1]
% 
% ms1
%           vals: [48.1249 9.5406 1.6003 0.0056 7.0730]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 18 1.9000 0.0100 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% mts
%           vals: [51.6622 78.2914 1.5586 0.0078 9.1313]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 130 1.9000 0.0100 10]
%            min: [48 20 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% sr_mtsj2
%           vals: [48.7163 120.6626 2.0178 2.5935e-04 1.1785]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 130 2.1000 5.0000e-04 2]
%            min: [48 120 2 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% sr_mtsj1
%           vals: [49.2103 129.7149 2.0563 2.6166e-04 0.9637]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 135 2.1000 5.0000e-04 2]
%            min: [48 115 2 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% err_source_c12r36.max = -70.31
%***********************************r27********************************************
% r27
%           vals: [3.2910 15.9559 6.2957 26.1346]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 29]
%            min: [0 0 0 25]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% ms3
%           vals: [61.3262 72.9728 1.7503 0.4430 4.6988]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [78 100 2 10 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% c2
%        network: [1×1 TwoPort]
%           vals: [49.5595 1.9062 0 1.4091 0.0085 0.0073 0 0.9339]
%     unitScales: [1 1 1 1 1 1 1 1]
%            max: [52 2.1000 0.1000 1.6000 0.0100 0.0100 0.1000 2]
%            min: [48 1.9000 -0.1000 1.4000 -0.0100 0 -0.1000 0]
%        optFlag: [1 1 0 1 1 1 0 1]
% 
% ms1
%           vals: [49.5335 11.5784 1.6846 0.0050 4.9288]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 18 1.9000 0.0100 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% mts
%           vals: [51.6270 79.7152 1.6930 0.0054 7.2886]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 130 1.9000 0.0100 10]
%            min: [48 20 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% sr_mtsj2
%           vals: [48.6489 123.3915 2.0447 2.4973e-04 0.9689]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 130 2.1000 5.0000e-04 2]
%            min: [48 120 2 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% sr_mtsj1
%           vals: [49.1861 130.4065 2.0562 2.5083e-04 0.9799]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 135 2.1000 5.0000e-04 2]
%            min: [48 115 2 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]

% err_source_c12r27.max = -74.05 
%***********************************r69********************************************
% r69
%           vals: [4.9320 29.9975 3.8569 71.6275]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 72]
%            min: [0 0 0 66]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% ms3
%           vals: [51.2016 42.6525 1.5000 8.4253e-08 9.9999]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [78 100 2 10 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% c2
%        network: [1×1 TwoPort]
%           vals: [49.4116 1.9000 0 1.4000 -9.9955e-04 1.8459e-09 0 2.0000]
%     unitScales: [1 1 1 1 1 1 1 1]
%            max: [52 2.1000 0.1000 1.6000 0.0100 0.0100 0.1000 2]
%            min: [48 1.9000 -0.1000 1.4000 -0.0100 0 -0.1000 0]
%        optFlag: [1 1 0 1 1 1 0 1]
% 
% ms1
%           vals: [53.0000 18.0000 1.9000 0.0100 9.9997]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 18 1.9000 0.0100 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% mts
%           vals: [50.6761 129.9999 1.9000 1.8679e-08 9.9999]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 130 1.9000 0.0100 10]
%            min: [48 20 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% sr_mtsj2
%           vals: [48.2146 130.0000 2.1000 1.6122e-08 1.1194]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 130 2.1000 5.0000e-04 2]
%            min: [48 120 2 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% sr_mtsj1
%           vals: [49.2017 118.8256 2.0006 2.1120e-08 1.9999]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 135 2.1000 5.0000e-04 2]
%            min: [48 115 2 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% err_source_c12r69.max = -67.5
%***********************************r91********************************************
% r91
%           vals: [5.2012 37.2199 2.8573 94.8957]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 95]
%            min: [0 0 0 86]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% ms3
%           vals: [68.7253 38.1193 1.9350 0.0022 8.1265]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [78 100 2 10 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% c2
%      network: [1×1 TwoPort]
%           vals: [49.5310 1.9123 0 1.4111 -0.0094 2.4858e-05 0 1.2339]
%     unitScales: [1 1 1 1 1 1 1 1]
%            max: [52 2.1000 0.1000 1.6000 0.0100 0.0100 0.1000 2]
%            min: [48 1.9000 -0.1000 1.4000 -0.0100 0 -0.1000 0]
%        optFlag: [1 1 0 1 1 1 0 1]
% 
% ms1
%           vals: [52.9723 17.8864 1.8775 0.0030 5.6730]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 18 1.9000 0.0100 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% mts
%           vals: [50.8614 121.8117 1.7351 3.3568e-04 7.2167]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 130 1.9000 0.0100 10]
%            min: [48 20 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% sr_mtsj2
%           vals: [48.2452 129.2949 2.0788 1.5266e-04 0.6706]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 130 2.1000 5.0000e-04 2]
%            min: [48 120 2 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% sr_mtsj1
%           vals: [49.2453 132.0868 2.0625 1.6012e-04 1.1767]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 135 2.1000 5.0000e-04 2]
%            min: [48 115 2 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% err_source_c12r91.max = -73.82
%***********************************rOpen******************************************
% rOpen
%           vals: [3.3572 52.2871 1.5286 0.6293]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1000000]
%            max: [Inf Inf Inf 1]
%            min: [0 0 0 0.0100]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% ms4
%           vals: [77.8860 15.8515 1.5974 7.1079 5.7771]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [78 100 2 10 10]
%            min: [47 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% c10
%        network: [1×1 TwoPort]
%           vals: [51.3905 9.9453 0 1.4175 -0.0034 2.0172e-05 0 0.3414]
%     unitScales: [1 1 1 1 1 1 1 1]
%            max: [52 10.1000 0.1000 1.6000 0.0100 0.0100 0.1000 2]
%            min: [48 9.9000 -0.1000 1.4000 -0.0100 0 -0.1000 0]
%        optFlag: [1 1 0 1 1 1 0 1]
% 
% ms1
%           vals: [52.7298 15.7163 1.7061 0.0046 8.1669]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 18 1.9000 0.0100 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% mts
%           vals: [52.9109 84.2372 1.6008 0.0036 9.5878]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 130 1.9000 0.0100 10]
%            min: [48 20 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% sr_mtsj2
%           vals: [49.0095 123.5057 2.0447 2.0093e-04 0.1353]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 130 2.1000 5.0000e-04 2]
%            min: [48 120 2 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% sr_mtsj1
%           vals: [48.7979 119.6035 2.0446 2.1501e-04 0.2127]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 135 2.1000 5.0000e-04 2]
%            min: [48 115 2 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
%  
% err_source_c25open.max = -51.9806;

%***********************************rShort*****************************************
% rShort
%           vals: [0.3825 13.5334 0 1.9594]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 10]
%            min: [0 0 0 0]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% ms4
%           vals: [72.2650 97.1640 1.7298 0.4427 1.1494]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [78 100 2 10 10]
%            min: [47 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% ms1
%           vals: [52.9940 16.1928 1.5105 0.0097 9.9640]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 18 1.9000 0.0100 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% mts
%           vals: [52.9986 89.0629 1.5020 0.0099 9.9923]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 130 1.9000 0.0100 10]
%            min: [48 20 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% err_source_c25short.max = -56.6979
%***********************************r10********************************************
% r10
%           vals: [2.9820 14.0527 6.4371 11.5114]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 21]
%            min: [0 0 0 9]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% ms4
%           vals: [66.9910 99.9076 1.9962 0.1245 2.4821]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [78 100 2 10 10]
%            min: [47 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% ms1
%           vals: [52.9947 17.9739 1.8940 0.0096 9.8451]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 18 1.9000 0.0100 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% mts
%           vals: [52.9943 73.8979 1.5158 0.0097 9.9467]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 130 1.9000 0.0100 10]
%            min: [48 20 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% sr_mtsj2
%           vals: [48.0903 121.1936 2.0254 9.2032e-05 0.0199]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 130 2.1000 5.0000e-04 2]
%            min: [48 120 2 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% sr_mtsj1
%           vals: [48.7902 115.0626 2.0021 2.1335e-04 0.1085]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 135 2.1000 5.0000e-04 2]
%            min: [48 115 2 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% err_source_c25r10.max = -58.6756
%***********************************r250*******************************************
% r250
%           vals: [3.2736 22.1183 2.2688 240.0814]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 280]
%            min: [0 0 0 240]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% ms4
%           vals: [77.9940 31.0076 1.9581 3.8944 9.3716]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [78 100 2 10 10]
%            min: [47 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% ms1
%           vals: [52.9741 17.8812 1.8736 8.4261e-04 9.4379]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 18 1.9000 0.0100 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% mts
%           vals: [52.9585 72.0266 1.5401 2.1070e-04 9.8173]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 130 1.9000 0.0100 10]
%            min: [48 20 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% sr_mtsj2
%           vals: [48.2791 128.1287 2.0680 6.8685e-05 0.1267]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 130 2.1000 5.0000e-04 2]
%            min: [48 120 2 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% sr_mtsj1
%           vals: [48.7766 115.3577 2.0111 8.0008e-05 0.4646]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 135 2.1000 5.0000e-04 2]
%            min: [48 115 2 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% err_source_c25r250.max = -56.3825
%***********************************rCold*******************************************
% 
% rCold
%           vals: [3.1427 9.0154 0.5277 49.8935]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 51]
%            min: [0 0 0 49]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% ms1
%           vals: [52.0271 14.9025 1.7133 0.0050 4.8675]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 18 1.9000 0.0100 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% mts
%           vals: [50.1344 123.6820 1.7965 0.0053 5.6568]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 130 1.9000 0.0100 10]
%            min: [48 20 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% sr_mtsj2
%           vals: [51.1779 124.5056 2.0483 2.5023e-04 0.9663]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 130 2.1000 5.0000e-04 2]
%            min: [48 120 2 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% sr_mtsj1
%           vals: [49.9181 131.9130 2.0602 2.5016e-04 1.0049]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 135 2.1000 5.0000e-04 2]
%            min: [48 115 2 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% err_source_cold.max = -60.5617
%***********************************rHot******************************************
% rHot
%           vals: [1.0710 6.9047 1.5233 50.7173]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 51]
%            min: [0 0 0 49]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% ms1
%           vals: [50.8778 11.0971 1.6802 0.0051 5.2390]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 18 1.9000 0.0100 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% mts
%           vals: [51.9409 61.8992 1.7411 0.0050 4.6699]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 130 1.9000 0.0100 10]
%            min: [48 20 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% sr_mtsj2
%           vals: [48.8540 124.0191 2.0462 2.4952e-04 0.9661]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 130 2.1000 5.0000e-04 2]
%            min: [48 120 2 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% sr_mtsj1
%           vals: [48.8176 117.4079 2.0375 2.4927e-04 0.9274]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 135 2.1000 5.0000e-04 2]
%            min: [48 115 2 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% err_source_hot.max = -69.1436;
%***********************************r25*******************************************
% 
% r25
%           vals: [10.6515 4.7546 1.2442 24.8079]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 27]
%            min: [0 0 0 23]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% ms1
%           vals: [52.6544 17.8436 1.8620 0.0099 7.8840]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 18 1.9000 0.0100 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% mts
%           vals: [51.4433 118.2208 1.5256 0.0100 9.8307]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 130 1.9000 0.0100 10]
%            min: [48 20 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% sr_mtsj2
%           vals: [48.0087 121.5763 2.0273 4.8432e-04 0.8420]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 130 2.1000 5.0000e-04 2]
%            min: [48 120 2 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% sr_mtsj1
%          vals: [48.8314 115.0650 2.0021 4.8322e-04 1.8159]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 135 2.1000 5.0000e-04 2]
%            min: [48 115 2 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% err_source_r25.max = -77.6565;
%***********************************r100******************************************
% r100
%           vals: [1.3600 18.7154 1.1940 100.2163]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 103]
%            min: [0 0 0 97]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% ms1
%           vals: [48.8335 9.2457 1.8329 0.0053 0.9859]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 18 1.9000 0.0100 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% mts
%           vals: [51.1156 69.9649 1.7422 0.0055 0.7486]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 130 1.9000 0.0100 10]
%            min: [48 20 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% sr_mtsj2
%           vals: [48.9021 120.2717 2.0097 2.5581e-04 0.0981]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 130 2.1000 5.0000e-04 2]
%            min: [48 120 2 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% sr_mtsj1
%           vals: [49.3194 128.5758 2.0625 2.7348e-04 0.1328]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 135 2.1000 5.0000e-04 2]
%            min: [48 115 2 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% 
% err_source_r100.max = -95.3429;
%**********************************************************************************
%                                 MS4set
%**********************************************************************************
% MS4
%           vals: [51.7902 15.1613 1.7209 1.4130 5.0741]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [78 100 2 10 10]
%            min: [47 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% MS1
%           vals: [49.9488 13.0711 1.6974 0 0]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 18 1.9000 0.0100 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 0 0]
%        network: [1×1 TwoPort]
% 
% Short
%           vals: [1.2229 25.7117 0 0.3681]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 10]
%            min: [0 0 0 0]
%        optFlag: [1 1 0 1]
%        network: [1×1 TwoPort]
% 
% Open
%           vals: [8.7708 53.1975 0.9021 0.5032]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1000000]
%            max: [Inf Inf Inf 1]
%            min: [0 0 0 0.0100]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% r10
%           vals: [5.5021 24.1970 7.9966 10.4657]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 21]
%            min: [0 0 0 9]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% r250
%           vals: [5.9294 25.4223 4.1474 255.0427]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 280]
%            min: [0 0 0 240]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% err = -51.5
%**********************************************************************************
%                MS4set With less no. of parameters
%**********************************************************************************
% MS4
%           vals: [52.6148 15.8819 1.7417 2.1496 4.4005]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [78 100 2 10 10]
%            min: [47 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% MS1
%           vals: [49.5873 13.6561 1.7005 0 0]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 18 1.9000 0.0100 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 0 0]
%        network: [1×1 TwoPort]
% 
% Short
%           vals: [0.3825 13.5334 0 0.2134]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 10]
%            min: [0 0 0 0]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% Open
%           vals: [3.3572 52.2871 1.5286 0.4990]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1000000]
%            max: [Inf Inf Inf 1]
%            min: [0 0 0 0.0100]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% r10
%           vals: [2.9820 14.0527 6.4371 10.5135]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 21]
%            min: [0 0 0 9]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% r250
%           vals: [3.2736 22.1183 2.2688 261.4042]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 280]
%            min: [0 0 0 240]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% err = -50.4
%**********************************************************************************
%                                  MS3
%**********************************************************************************
% 
% MS3
%           vals: [50.0507 14.4195 1.7011 0 0]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [52 18 1.9000 0.0100 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 0 0]
%        network: [1×1 TwoPort]
% 
% MS1
%           vals: [52.7866 13.9788 1.7237 0 0]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 18 1.9000 0.0100 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 0 0]
%        network: [1×1 TwoPort]
% 
% r36
%           vals: [3.3572 15.8111 3.2015 36.9003]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 38]
%            min: [0 0 0 34]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% r27
%           vals: [3.3448 14.6141 2.4756 27.4438]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 29]
%            min: [0 0 0 25]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% r69
%           vals: [3.8127 22.2074 3.1633 69.7791]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 72]
%            min: [0 0 0 66]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% r91
%           vals: [5.0755 36.6779 3.1019 92.7025]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 95]
%            min: [0 0 0 86]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% err = -61.1974
% 
%**********************************************************************************
%                   MS3set With less no. of parameters
%**********************************************************************************
% MS3
%           vals: [48.1700 18.5362 1.7429 0.0804 4.6038]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [78 100 2 10 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% MS1
%           vals: [51.2871 13.9770 1.7091 0 0]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 18 1.9000 0.0100 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 0 0]
%        network: [1×1 TwoPort]
% 
% r36
%           vals: [4.0065 18.8989 5.7711 37.0868]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 38]
%            min: [0 0 0 34]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% r27
%           vals: [3.2910 15.9559 6.2957 27.7486]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 29]
%            min: [0 0 0 25]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% r69
%           vals: [4.9320 29.9975 3.8569 69.5860]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 72]
%            min: [0 0 0 66]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% r91
%           vals: [5.2012 37.2199 2.8573 91.3707]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 95]
%            min: [0 0 0 86]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% err = -56.6911
%**********************************************************************************
%                   r25, r100, MS1, MTS
%**********************************************************************************
% 
% r25
%           vals: [8.7834 5.7631 2.1817 25.1315]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 27]
%            min: [0 0 0 23]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% r100
%           vals: [1.7985 39.3886 1.8622 101.1675]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 103]
%            min: [0 0 0 97]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% ms1
%           vals: [52.4932 17.9365 1.7705 0.0099 4.2569]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 18 1.9000 0.0100 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% mts
%           vals: [51.6404 72.0881 1.8898 0.0059 3.9662]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 130 1.9000 0.0100 10]
%            min: [48 20 1.5000 0 0]
%        optFlag: [1 1 1 0 0]
%        network: [1×1 TwoPort]
% 
% err = -77.0381
%**********************************************************************************
%                   Hot, Cold optFlag: [0 0 0 1], MS1, MTS 
%**********************************************************************************
% rHot
%           vals: [3.7886 9.7978 0.9865 50.8162]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 51]
%            min: [0 0 0 49]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% rCold
%           vals: [0.3876 2.0638 0.0537 50.2396]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 51]
%            min: [0 0 0 49]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% ms1
%           vals: [52.4466 13.0426 1.6982 0.0052 4.8756]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 18 1.9000 0.0100 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% mts
%           vals: [52.7531 64.9239 1.8318 0.0059 3.9662]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 130 1.9000 0.0100 10]
%            min: [48 20 1.5000 0 0]
%        optFlag: [1 1 1 0 0]
%        network: [1×1 TwoPort]
% 
% err = -52.9780
%**********************************************************************************
%                   Hot, Cold optFlag: [1 1 1 1], MS1, MTS 
%**********************************************************************************
% rHot
%           vals: [4.0208 11.7524 1.5865 50.7610]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 51]
%            min: [0 0 0 49]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% rCold
%           vals: [0.9210 5.7494 0.9894 50.0852]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 51]
%            min: [0 0 0 49]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% ms1
%           vals: [49.2469 15.5405 1.7266 0.0050 4.7021]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 18 1.9000 0.0100 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% mts
%           vals: [52.3565 71.3129 1.6941 0.0059 3.9662]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 130 1.9000 0.0100 10]
%            min: [48 20 1.5000 0 0]
%        optFlag: [1 1 1 0 0]
%        network: [1×1 TwoPort]
% 
% err = -63.3406
%**********************************************************************************
%                   r25, r100, Hot, Cold optFlag: [1 1 1 1], MS1, MTS 
%**********************************************************************************
% 
% rHot
%           vals: [3.9621 11.5219 1.5467 50.7595]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 51]
%            min: [0 0 0 49]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% rCold
%           vals: [1.1727 7.1577 1.2870 50.0862]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 51]
%            min: [0 0 0 49]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% r25
%           vals: [4.4315 7.8301 6.0109 25.1969]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 27]
%            min: [0 0 0 23]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% r100
%           vals: [2.0879 43.4157 2.3847 101.3417]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 103]
%            min: [0 0 0 97]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% ms1
%           vals: [48.6309 17.1641 1.7662 0.0039 2.8523]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 18 1.9000 0.0100 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% mts
%           vals: [52.2109 71.9046 1.7118 0.0039 4.9351]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 130 1.9000 0.0100 10]
%            min: [48 20 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% err = -63.2814
%**********************************************************************************
%                   all except ms1j2
%**********************************************************************************
% 
% 
% rCold
%           vals: [1.8442 8.2258 1.3464 49.8061]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 51]
%            min: [0 0 0 49]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% rHot
%           vals: [4.4028 12.2819 1.4954 50.6949]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 51]
%            min: [0 0 0 49]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% r25
%           vals: [3.2377 9.3400 6.4493 25.2164]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 27]
%            min: [0 0 0 23]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% r100
%           vals: [6.2080 46.8729 3.2725 100.3248]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 103]
%            min: [0 0 0 97]
%        optFlag: [1 1 1 1]
%        network: [1×1 TwoPort]
% 
% r36
%           vals: [4.0065 18.8989 5.7711 36.3533]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 38]
%            min: [0 0 0 34]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% 
% r27
%           vals: [3.2910 15.9559 6.2957 26.9840]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 29]
%            min: [0 0 0 25]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% r69
%           vals: [4.9320 29.9975 3.8569 69.8318]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 72]
%            min: [0 0 0 66]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% r91
%           vals: [5.2012 37.2199 2.8573 92.4659]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 95]
%            min: [0 0 0 86]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% rOpen
%           vals: [3.3572 52.2871 1.5286 0.5135]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1000000]
%            max: [Inf Inf Inf 1]
%            min: [0 0 0 0.0100]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% rShort
%           vals: [0.3825 13.5334 0 0.2978]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 10]
%            min: [0 0 0 0]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% r10
%           vals: [2.9820 14.0527 6.4371 10.3246]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 21]
%            min: [0 0 0 9]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% r250
%           vals: [3.2736 22.1183 2.2688 257.5401]
%     unitScales: [1.0000e-12 1.0000e-09 1.0000e-12 1]
%            max: [Inf Inf Inf 280]
%            min: [0 0 0 240]
%        optFlag: [0 0 0 1]
%        network: [1×1 TwoPort]
% 
% ms3
%           vals: [48.1308 20.0636 1.7487 0.3489 4.5270]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [78 100 2 10 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% ms4
%           vals: [61.2531 10.7120 1.6941 0.1289 4.2246]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [78 100 2 10 10]
%            min: [47 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% ms1
%           vals: [49.1791 11.7128 1.6701 0.0049 4.7785]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 18 1.9000 0.0100 10]
%            min: [48 9 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% mts
%           vals: [52.9452 56.0474 1.6358 0.0063 9.6005]
%     unitScales: [1 1.0000e-03 1 1 1]
%            max: [53 130 1.9000 0.0100 10]
%            min: [48 20 1.5000 0 0]
%        optFlag: [1 1 1 1 1]
%        network: [1×1 TwoPort]
% 
% err = -48.15
%**********************************************************************************