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

%     r36.vals = [3.36682      16.6829      3.17508      36.5441];
%     r27.vals = [3.36572      16.6213      3.40096      26.9477];
%     r69.vals = [2.39182       12.314      2.86407      70.0928];
%     r91.vals = [2.69194        13.23      3.08641      93.6728];
%     rOpen.vals = [6.23999      55.8218      2.33364     0.499767];
%     rShort.vals = [14.0894      15.8454            0     0.310268];
%     r10.vals = [11.1391      20.6975      34.1629      10.5331];
%     r250.vals = [6.180626       10.8606      2.994377      255.5711];
%     rCold.vals = [1.47681      4.59859     0.136854       50.117];
%     rHot.vals = [4.10258      16.1162      2.66455      50.7057];
%     r25.vals = [3.02442      12.7024      5.36143      24.6955];
%     r100.vals = [3.46153      23.97875      1.586841      102.3916];
%     ms1.vals = [50.1199      12.5556      1.76795    0.0431001      6.73987];
%     ms3.vals = [50.1442      13.4723      1.70002   0.00501557      4.85029];
%     ms4.vals = [63.4165      61.2629      2.26147     0.021221      1.94757];
%     mts.vals = [56.6112      38.0539      1.62845    0.0672548      36.9309];
%     sr_mtsj1.vals = [48.79104      122.8004      2.049572  0.0002516188      2.209656];
%     sr_mtsj2.vals = [48.08656      124.1871      2.091847  0.0002454033     0.5108821];
%     sr_ms1j2.vals = [52.33981      119.2792      2.050247  0.0002500653      1.005578];
%     c2.vals = [49.2168      1.97913  -0.00822734      1.48692 -0.000435474   0.00666099   0.00682583     0.419599];
%     c10.vals = [49.7207      9.93446   -0.0115154      1.41183  -0.00168004   0.00559357     0.228266     0.377085];
%     la.vals = [51.4317      34.9882         2.05      0.00025     0.999966];
%     
%     d = REACHcal(dpath,'r36',r36,'r27',r27,'r69',r69,'r91',r91,...
%                     'rOpen',rOpen,'rShort',rShort,'r10',r10,'r250',r250,...
%                     'rCold',rCold,'rHot',rHot,'r25',r25,'r100',r100,...
%                     'c2',c2,'c10',c10,...
%                     'ms1',ms1,'ms3',ms3,'ms4',ms4','mts',mts,...
%                     'sr_mtsj2',sr_mtsj2,'sr_mtsj1',sr_mtsj1,'sr_ms1j2',sr_ms1j2);
%     d.errorFuncType = 'RIA';
%     d.errorFuncNorm = 'mean';
%     figure (1)
%     d.plotAllS11(3,{'r','k'});
%     
%     figure (2)
%     d.plotAllParameters('r*');

