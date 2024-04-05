% clc;
close all;
clearvars;

% dpath='C:\Users\spegwal\Downloads\Saurabh\MAT_REPO\Repository\SPegwal\Calibration_code\REACH calibration\REACH-RXcal\data\2023_12_11_14_32\';
% dpath='C:\Users\spegwal\Downloads\Saurabh\MAT_REPO\Repository\SPegwal\Calibration_code\REACH calibration\REACH-RXcal\data\calibration\';
% d = REACHcal(dpath);

% dpath='C:\Users\spegwal\Downloads\Saurabh\MAT_REPO\Repository\SPegwal\Calibration_code\REACH calibration\REACH-RXcal\data\2024_01_07_19_00\';
dpath='C:\Users\spegwal\Downloads\Saurabh\MAT_REPO\Repository\SPegwal\Calibration_code\REACH calibration\REACH-RXcal\data\2024_01_09_19_00\';
d = REACHcal_1(dpath);

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
