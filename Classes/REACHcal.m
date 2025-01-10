classdef REACHcal

    properties
        useMeasCableC10(1,1) logical = false
        useMeasCableC2(1,1) logical = false
        errorFuncType(1,:) char {mustBeMember(errorFuncType,{'RIA','magDistance','complexDistance'})} = 'RIA' 
        errorFuncNorm(1,:) char {mustBeMember(errorFuncNorm,{'max','mean','norm'})} = 'mean'
        errorFuncScale(1,:) char {mustBeMember(errorFuncScale,{'lin','dB'})} = 'dB'
        customTemp_Flag(1,1) logical = false;
        load_indx(1,1) {mustBeInteger} = 0;
    end

    properties (SetAccess = private)
        dataPath(1,:) char
        dataPathMS3(1,:) char   % Path to the MS-3 2-port measured data
        dataPathLabCable(1,:) char   % Path to the lab cable measurements
        dataPathLabSources(1,:) char   % Path to the lab source measurements

        Nf(1,1) double = 151
        fmin(1,1) double = 50  % in MHz
        fmax(1,1) double = 200 % in MHz

        % Resistors
        r36_vals(1,4) double {mustBeReal,mustBeNonnegative} = [0.9417 9.2008 2.3964 36.7446];
        
        r27_vals(1,4) double {mustBeReal,mustBeNonnegative} = [0.0522 8.4915 2.5690 27.1212];
        
        r69_vals(1,4) double {mustBeReal,mustBeNonnegative} = [2.2834 10.6514 1.0517 70.4520];
        
        r91_vals(1,4) double {mustBeReal,mustBeNonnegative} = [3.0632 11.9608 0.2749 93.9347];
        
        rOpen_vals(1,4) double {mustBeReal,mustBeNonnegative} = [8.3271 53.9266 6.2162 0.5013];
        
        rShort_vals(1,4) double {mustBeReal,mustBeNonnegative} = [18.6866 25.3791 0 0.2628];
        
        r10_vals(1,4) double {mustBeReal,mustBeNonnegative} = [6.6851 20.8037 20.1547 10.4524];
        
        r250_vals(1,4) double {mustBeReal,mustBeNonnegative} = [6.0418 23.9319 5.8821 254.8202];
        
        rCold_vals(1,4) double {mustBeReal,mustBeNonnegative} = [0.3876 2.0638 0.0537 50.2550];
        
        rHot_vals(1,4) double {mustBeReal,mustBeNonnegative} = [3.7886 9.7978 0.9865 50.8162];
        
        r25_vals(1,4) double {mustBeReal,mustBeNonnegative} = [16.1297 9.6251 5.2162 25.1860];
        
        r100_vals(1,4) double {mustBeReal,mustBeNonnegative} = [7.3128e-05 44.9274 2.6004 101.7963];
        
%         r36_vals(1,4) double {mustBeReal,mustBeNonnegative} = [2.95037      15.4809      3.47075      36.2407];
        r36_unitScales(1,4) double {mustBeReal,mustBePositive} = [1e-12,1e-9,1e-12,1];
        r36_max(1,4) double {mustBeReal,mustBeNonnegative} = [20,40,10,38];
        r36_min(1,4) double {mustBeReal,mustBeNonnegative} = [0,0,0,34];
        r36_optFlag(1,4) logical = [1,1,1,1];

%         r27_vals(1,4) double {mustBeReal,mustBeNonnegative} = [2.75893       15.149      4.16369      26.5982];
        r27_unitScales(1,4) double {mustBeReal,mustBePositive} = [1e-12,1e-9,1e-12,1];
        r27_max(1,4) double {mustBeReal,mustBeNonnegative} = [20,40,20,29];
        r27_min(1,4) double {mustBeReal,mustBeNonnegative} = [0,0,0,25];
        r27_optFlag(1,4) logical = [1,1,1,1];

%         r69_vals(1,4) double {mustBeReal,mustBeNonnegative} = [2.79087      13.7421      2.33215      70.2531];
        r69_unitScales(1,4) double {mustBeReal,mustBePositive} = [1e-12,1e-9,1e-12,1];
        r69_max(1,4) double {mustBeReal,mustBeNonnegative} = [20,60,20,72];
        r69_min(1,4) double {mustBeReal,mustBeNonnegative} = [0,0,0,66];
        r69_optFlag(1,4) logical = [1,1,1,1];

%         r91_vals(1,4) double {mustBeReal,mustBeNonnegative} = [3.80203      19.4249      2.07732      94.3578];
        r91_unitScales(1,4) double {mustBeReal,mustBePositive} = [1e-12,1e-9,1e-12,1];
        r91_max(1,4) double {mustBeReal,mustBeNonnegative} = [20,80,20,98];
%         r91_max(1,4) double {mustBeReal,mustBeNonnegative} = [20,80,20,95];
        r91_min(1,4) double {mustBeReal,mustBeNonnegative} = [0,0,0,86];
        r91_optFlag(1,4) logical = [1,1,1,1];

%         rOpen_vals(1,4) double {mustBeReal,mustBeNonnegative} = [0.477354      63.9291      2.43312     0.991508];
        rOpen_unitScales(1,4) double {mustBeReal,mustBePositive} = [1e-12,1e-9,1e-12,1e6];
        rOpen_max(1,4) double {mustBeReal,mustBeNonnegative} = [10,150,20,2];
%         rOpen_max(1,4) double {mustBeReal,mustBeNonnegative} = [20,150,40,2];
        rOpen_min(1,4) double {mustBeReal,mustBeNonnegative} = [0,0,0,0.0];
        rOpen_optFlag(1,4) logical = [1,1,1,1];

%         rShort_vals(1,4) double {mustBeReal,mustBeNonnegative} = [16.0045      8.64989      35.0109     0.313018];
        rShort_unitScales(1,4) double {mustBeReal,mustBePositive} = [1e-12,1e-9,1e-12,1];
        rShort_max(1,4) double {mustBeReal,mustBeNonnegative} = [50,80,200,2];
        rShort_min(1,4) double {mustBeReal,mustBeNonnegative} = [0,0,0,0];
        rShort_optFlag(1,4) logical = [1,1,1,1];

%         r10_vals(1,4) double {mustBeReal,mustBeNonnegative} = [8.57682      13.5742      34.9511      10.4305];
        r10_unitScales(1,4) double {mustBeReal,mustBePositive} = [1e-12,1e-9,1e-12,1];
        r10_max(1,4) double {mustBeReal,mustBeNonnegative} = [30,60,80,15];
        r10_min(1,4) double {mustBeReal,mustBeNonnegative} = [0,0,0,9];
        r10_optFlag(1,4) logical = [1,1,1,1];

%         r250_vals(1,4) double {mustBeReal,mustBeNonnegative} = [3.252569       26.9557     0.7782909      252.4288];
        r250_unitScales(1,4) double {mustBeReal,mustBePositive} = [1e-12,1e-9,1e-12,1];
        r250_max(1,4) double {mustBeReal,mustBeNonnegative} = [30,60,20,280];
%         r250_max(1,4) double {mustBeReal,mustBeNonnegative} = [30,60,80,280];
        r250_min(1,4) double {mustBeReal,mustBeNonnegative} = [0,0,0,240];
        r250_optFlag(1,4) logical = [1,1,1,1];

%         rCold_vals(1,4) double {mustBeReal,mustBeNonnegative} = [1.24964      7.19233      1.25323      49.9668];
        rCold_unitScales(1,4) double {mustBeReal,mustBePositive} = [1e-12,1e-9,1e-12,1];
        rCold_max(1,4) double {mustBeReal,mustBeNonnegative} = [10,10,5,51];
        rCold_min(1,4) double {mustBeReal,mustBeNonnegative} = [0,0,0,49];
        rCold_optFlag(1,4) logical = [1,1,1,1];

%         rHot_vals(1,4) double {mustBeReal,mustBeNonnegative} = [3.81766      13.1934      2.07747      50.5746];
        rHot_unitScales(1,4) double {mustBeReal,mustBePositive} = [1e-12,1e-9,1e-12,1];
        rHot_max(1,4) double {mustBeReal,mustBeNonnegative} = [10,30,10,51];
        rHot_min(1,4) double {mustBeReal,mustBeNonnegative} = [0,0,0,49];
        rHot_optFlag(1,4) logical = [1,1,1,1];

%         r25_vals(1,4) double {mustBeReal,mustBeNonnegative} = [4.14745      6.99092      6.94853      24.0367];
        r25_unitScales(1,4) double {mustBeReal,mustBePositive} = [1e-12,1e-9,1e-12,1];
        r25_max(1,4) double {mustBeReal,mustBeNonnegative} = [20,80,20,27];
        r25_min(1,4) double {mustBeReal,mustBeNonnegative} = [0,0,0,23];
        r25_optFlag(1,4) logical = [1,1,1,1];

%         r100_vals(1,4) double {mustBeReal,mustBeNonnegative} = [1.440879       34.5126      1.403432      104.6585];
        r100_unitScales(1,4) double {mustBeReal,mustBePositive} = [1e-12,1e-9,1e-12,1];
        r100_max(1,4) double {mustBeReal,mustBeNonnegative} = [5,100,5,107];
        r100_min(1,4) double {mustBeReal,mustBeNonnegative} = [0,0,0,97];
        r100_optFlag(1,4) logical = [1,1,1,1];

        % 48

        % Mechanical switches
%         ms1_vals(1,5) double {mustBeReal,mustBeNonnegative} = [54.2236      16.2477      1.65338     0.178804      21.0181];
        ms1_vals(1,5) double {mustBeReal,mustBeNonnegative} = [54.2236      16.2477      1.0     0.0      21.0181];
        ms1_unitScales(1,5) double {mustBeReal,mustBePositive} = [1,1e-3,1,1,1];
        ms1_max(1,5) double {mustBeReal,mustBeNonnegative} = [55,25,2.1,0.20,25];
        ms1_min(1,5) double {mustBeReal,mustBeNonnegative} = [48,8,1.4,0,0];
%         ms1_optFlag(1,5) logical = [1,1,1,1,1];
        ms1_optFlag(1,5) logical = [1,1,0,0,1];

%         ms3_vals(1,5) double {mustBeReal,mustBeNonnegative} = [50.1024      13.2621      1.69958   0.00499467      4.58104];
        ms3_vals(1,5) double {mustBeReal,mustBeNonnegative} = [50.1024      13.2621      1.0   0.0      4.58104];
        ms3_unitScales(1,5) double {mustBeReal,mustBePositive} = [1,1e-3,1,1,1];
        ms3_max(1,5) double {mustBeReal,mustBeNonnegative} = [52,16,1.9,0.01,10];
        ms3_min(1,5) double {mustBeReal,mustBeNonnegative} = [48,10,1.5,0,0];
%         ms3_optFlag(1,5) logical = [1,1,1,1,1];
        ms3_optFlag(1,5) logical = [1,1,0,0,1];

%         ms4_vals(1,5) double {mustBeReal,mustBeNonnegative} = [50.2627      13.8227      1.70015   0.00500967      4.88799];
        ms4_vals(1,5) double {mustBeReal,mustBeNonnegative} = [50.2627      13.8227      1.00   0.0      4.88799];
        ms4_unitScales(1,5) double {mustBeReal,mustBePositive} = [1,1e-3,1,1,1];
        ms4_max(1,5) double {mustBeReal,mustBeNonnegative} = [52,16,1.9,0.01,10];
        ms4_min(1,5) double {mustBeReal,mustBeNonnegative} = [48,10,1.5,0,0];
%         ms4_optFlag(1,5) logical = [1,1,1,1,1];
        ms4_optFlag(1,5) logical = [1,0,0,0,1];

%         mts_vals(1,5) double {mustBeReal,mustBeNonnegative} = [57.1208      41.4039      1.54254     0.142959      50.3559];
        mts_vals(1,5) double {mustBeReal,mustBeNonnegative} = [57.1208      41.4039      1.0     0.0      50.3559];
        mts_unitScales(1,5) double {mustBeReal,mustBePositive} = [1,1e-3,1,1,1];
        mts_max(1,5) double {mustBeReal,mustBeNonnegative} = [60,130,1.9,0.20,55];
%         mts_max(1,5) double {mustBeReal,mustBeNonnegative} = [58,130,1.9,0.20,55];
        mts_min(1,5) double {mustBeReal,mustBeNonnegative} = [48,20,1.4,0,0];
%         mts_optFlag(1,5) logical = [1,1,1,1,1];
        mts_optFlag(1,5) logical = [1,1,0,0,1];

        % 68

        % Semi-ridged links
        
%         Z_sr(1,1) double {mustBeReal, mustBePositive} = [50];
%         Z_sr_max(1,1) double {mustBeReal, mustBePositive} = [52];
%         Z_sr_min(1,1) double {mustBeReal, mustBePositive} = [48];
%         e_sr(1,1) double {mustBeReal, mustBePositive} = [2.1];
%         e_sr_max(1,1) double {mustBeReal, mustBePositive} = [2.2];
%         e_sr_min(1,1) double {mustBeReal, mustBePositive} = [2.0];
%         New_val(1,1) double {mustBeReal, mustBePositive} = [50 52 48 2.1 2.2 2.0];

        sr_mtsj1_vals(1,5) double {mustBeReal,mustBeNonnegative} = [50      149.2564      2.1    0.00024821      3.997286];
        sr_mtsj1_unitScales(1,5) double {mustBeReal,mustBePositive} = [1,1e-3,1,1,1];
        sr_mtsj1_max(1,5) double {mustBeReal,mustBeNonnegative} = [52,155,2.2,0.0005,15];
        sr_mtsj1_min(1,5) double {mustBeReal,mustBeNonnegative} = [48,115,2.0,0,0];
        sr_mtsj1_optFlag(1,5) logical = [1,1,1,1,1];
        
        sr_mtsj2_vals(1,5) double {mustBeReal,mustBeNonnegative} = [50      125.5559      2.1  0.0002402758      0.322411];
        sr_mtsj2_unitScales(1,5) double {mustBeReal,mustBePositive} = [1,1e-3,1,1,1];
        sr_mtsj2_max(1,5) double {mustBeReal,mustBeNonnegative} = [49,130,2.2,0.0005,8];
%         sr_mtsj2_max(1,5) double {mustBeReal,mustBeNonnegative} = [52,130,2.2,0.0005,15];
        sr_mtsj2_min(1,5) double {mustBeReal,mustBeNonnegative} = [45,120,2.0,0,0];
        sr_mtsj2_optFlag(1,5) logical = [1,1,1,1,1];
%         sr_mtsj2_optFlag(1,5) logical = [0,1,0,0,0];

        sr_ms1j2_vals(1,5) double {mustBeReal,mustBeNonnegative} = [50      120.5823      2.1  0.0002500942      1.011841];
        sr_ms1j2_unitScales(1,5) double {mustBeReal,mustBePositive} = [1,1e-3,1,1,1];
        sr_ms1j2_max(1,5) double {mustBeReal,mustBeNonnegative} = [55,130,2.2,0.0005,2];
%         sr_ms1j2_max(1,5) double {mustBeReal,mustBeNonnegative} = [52,130,2.2,0.0005,2];
        sr_ms1j2_min(1,5) double {mustBeReal,mustBeNonnegative} = [48,110,2.0,0,0];
        sr_ms1j2_optFlag(1,5) logical = [1,1,1,1,1];

        % 83


        % Cables
                                           %Zo           length   Eps_r_slope      Eps0    tand_slope    tand_const   r_prime_slope  r_prime_const
%         c2_vals(1,8) double {mustBeReal} = [49.0346      1.95495  -0.00532681      1.46773  9.01329e-06   0.00522473    0.0035304     0.174154];
        c2_vals(1,8) double {mustBeReal} = [49.0346      1.95495  -0.0      1.46773  0   0.00522473    0.0     0.174154];
        c2_unitScales(1,8) double {mustBeReal,mustBePositive} = [1,1,1,1,1,1,1,1];
        c2_max(1,8) double {mustBeReal} = [52,2.1,0.1,1.6,0.001, 0.02,0.1,0.8];
        c2_min(1,8) double {mustBeReal} = [48,1.9,-0.1,1.4,-0.001,0,-0.1,0];
%         c2_optFlag(1,8) logical = [1,1,1,1,1,1,1,1];
        c2_optFlag(1,8) logical = [1,1,0,1,0,1,0,1];

%         c10_vals(1,8) double {mustBeReal} = [49.4099      9.95695   -0.0107275      1.42526  -0.00169569   0.00472862     0.301096     0.286847];
        c10_vals(1,8) double {mustBeReal} = [49.4099      9.95695   -0.0      1.42526  -0.0   0.00472862     0.0     0.286847];
        c10_unitScales(1,8) double {mustBeReal,mustBePositive} = [1,1,1,1,1,1,1,1];
        c10_max(1,8) double {mustBeReal} = [52, 10.1, 0.1, 1.6,  0.003, 0.01, 0.5, 1];
        c10_min(1,8) double {mustBeReal} = [48, 9.9, -0.1, 1.4, -0.003,  0,    0.0, 0];
%         c10_optFlag(1,8) logical = [1,1,1,1,1,1,1,1];
        c10_optFlag(1,8) logical = [1,1,1,1,1,1,0,1];

        % 99
        

        % Lab adapter
        la_vals(1,5) double {mustBeReal,mustBeNonnegative} = [52.383      68.9341         2.05      0.00025      1.03204];
        la_unitScales(1,5) double {mustBeReal,mustBePositive} = [1,1e-3,1,1,1];
        la_max(1,5) double {mustBeReal,mustBeNonnegative} = [55,75,2.1,0.0005,2];
        la_min(1,5) double {mustBeReal,mustBeNonnegative} = [48,5,2.0,0,0];
%         la_optFlag(1,5) logical = [1,1,1,1,1];
        la_optFlag(1,5) logical = [0,0,0,0,0];

        % Lab measurement phase shift (not used at present)
        ps_vals(1,1) double {mustBeReal,mustBeNonnegative} = [0];
        ps_unitScales(1,1) double {mustBeReal,mustBePositive} = [1e-3];
        ps_max(1,1) double {mustBeReal,mustBeNonnegative} = [2];
        ps_min(1,1) double {mustBeReal,mustBeNonnegative} = [0];
        ps_optFlag(1,1) logical = [0];


        % Measured Data
        S11_meas_c12r36
        S11_meas_c12r27
        S11_meas_c12r69
        S11_meas_c12r91
        S11_meas_c25open
        S11_meas_c25short
        S11_meas_c25r10
        S11_meas_c25r250
        S11_meas_cold
        S11_meas_hot
        S11_meas_r25
        S11_meas_r100
        S11_meas_ant

        T_meas_c12r36(1,:) double {mustBeReal,mustBePositive} = 300
        T_meas_c12r27(1,:) double {mustBeReal,mustBePositive} = 300
        T_meas_c12r69(1,:) double {mustBeReal,mustBePositive} = 300
        T_meas_c12r91(1,:) double {mustBeReal,mustBePositive} = 300
        T_meas_c25open(1,:) double {mustBeReal,mustBePositive} = 300
        T_meas_c25short(1,:) double {mustBeReal,mustBePositive} = 300
        T_meas_c25r10(1,:) double {mustBeReal,mustBePositive} = 300
        T_meas_c25r250(1,:) double {mustBeReal,mustBePositive} = 300
        T_meas_cold(1,:) double {mustBeReal,mustBePositive} = 300
        T_meas_hot(1,:) double {mustBeReal,mustBePositive} = 330
        T_meas_r25(1,:) double {mustBeReal,mustBePositive} = 300
        T_meas_r100(1,:) double {mustBeReal,mustBePositive} = 300
        T_meas_ant(1,:) double {mustBeReal,mustBePositive} = 285
        T_meas_c2(1,:) double {mustBeReal,mustBePositive} = 295   % 2-m cable nominal temperature
        T_meas_c10(1,:) double {mustBeReal,mustBePositive} = 295   % 10-m cable nominal temperature
        T_meas_ms1(1,:) double {mustBeReal,mustBePositive} = 295   % ms1 nominal temperature

        PSD_meas_c12r36
        PSD_meas_c12r27
        PSD_meas_c12r69
        PSD_meas_c12r91
        PSD_meas_c25open
        PSD_meas_c25short
        PSD_meas_c25r10
        PSD_meas_c25r250
        PSD_meas_cold
        PSD_meas_hot
        PSD_meas_r25
        PSD_meas_r100
        PSD_meas_ant

        % Lab (fixed) measurements
        S11_lab_c12r36
        S11_lab_c12r27
        S11_lab_c12r69
        S11_lab_c12r91
        S11_lab_c25open
        S11_lab_c25short
        S11_lab_c25r10
        S11_lab_c25r250
        S11_lab_cold
        S11_lab_hot
        S11_lab_r25
        S11_lab_r100
        

        S_meas_MS3_J1
        S_meas_MS3_J2
        S_meas_MS3_J3
        S_meas_MS3_J4

        S_meas_c2
        S_meas_c10



    end

    properties (SetAccess = private, Hidden = true)
        % Optimization book-keeping
        optVect_Nvars(1,:) double {mustBeInteger,mustBeNonnegative}
        optVect_Ne(1,1) double {mustBeInteger,mustBePositive} = 10
        optW_RIA(1,2) double {mustBeNonnegative} = [2 1]   % Weights of the real-imag and dB20 differences in the error functions
        optW(1,:) double {mustBeNonnegative} = [1 1 1 1 1 1 1 1 1 1 1 1]
        optTypeFlag(1,1) double {mustBeInteger,mustBeNonnegative} = 1   % Set to 1 for standard VNA measured targets; 2 for the lab measured sources; 3 to only do the MTS and sr_mtsj1 elements from lab sources 
                                                                            

        folderFormat(1,1) double {mustBeInteger,mustBePositive} = 2         %  1 for the folder tree, 2 for the flat native structure
    end

    properties (Dependent = true)
        optErrElements

        freq(1,:) double
        r36(1,1) struct
        r27(1,1) struct
        r69(1,1) struct
        r91(1,1) struct
        rOpen(1,1) struct
        rShort(1,1) struct
        r10(1,1) struct
        r250(1,1) struct
        rCold(1,1) struct
        rHot(1,1) struct
        r25(1,1) struct
        r100(1,1) struct
        c2(1,1) struct
        c10(1,1) struct
        ms1(1,1) struct
        ms3(1,1) struct
        ms4(1,1) struct
        mts(1,1) struct
        sr_mtsj2(1,1) struct
        sr_mtsj1(1,1) struct
        sr_ms1j2(1,1) struct
        la(1,1) struct
        ps(1,1) struct

        % Full source models - all the way to VNA cal plane
        Sc12r36(1,1) struct
        Sc12r27(1,1) struct
        Sc12r69(1,1) struct
        Sc12r91(1,1) struct
        Sc25open(1,1) struct
        Sc25short(1,1) struct
        Sc25r10(1,1) struct
        Sc25r250(1,1) struct
        Scold(1,1) struct
        Shot(1,1) struct
        Sr25(1,1) struct
        Sr100(1,1) struct

        % De-embedded source models - only to reference plane
        Rc12r36(1,1) struct
        Rc12r27(1,1) struct
        Rc12r69(1,1) struct
        Rc12r91(1,1) struct
        Rc25open(1,1) struct
        Rc25short(1,1) struct
        Rc25r10(1,1) struct
        Rc25r250(1,1) struct
        Rcold(1,1) struct
        Rhot(1,1) struct
        Rr25(1,1) struct
        Rr100(1,1) struct

        % Lab source models - measured S11 to reference plane, with mts and sr_mtsj1 attached
        Lc12r36(1,1) struct
        Lc12r27(1,1) struct
        Lc12r69(1,1) struct
        Lc12r91(1,1) struct
        Lc25open(1,1) struct
        Lc25short(1,1) struct
        Lc25r10(1,1) struct
        Lc25r250(1,1) struct
        Lcold(1,1) struct
        Lhot(1,1) struct
        Lr25(1,1) struct
        Lr100(1,1) struct

        % Gain models
        Gc12r36(1,:) double
        Gc12r27(1,:) double
        Gc12r69(1,:) double
        Gc12r91(1,:) double
        Gc25open(1,:) double
        Gc25short(1,:) double
        Gc25r10(1,:) double
        Gc25r250(1,:) double
        Gcold(1,:) double
        Ghot(1,:) double
        Gr25(1,:) double
        Gr100(1,:) double

        % Temperature models (from radiometer paper)
        Tc12r36(1,:) double
        Tc12r27(1,:) double
        Tc12r69(1,:) double
        Tc12r91(1,:) double
        Tc25open(1,:) double
        Tc25short(1,:) double
        Tc25r10(1,:) double
        Tc25r250(1,:) double
        Tcold(1,:) double
        Thot(1,:) double
        Tr25(1,:) double
        Tr100(1,:) double


    end

    properties (Dependent = true, Hidden = true)
        freqHz

        optStruct

        % Error function handle
        errFuncHandle
        errFuncNormHandle
        errFuncScaleHandle

        % Full source errors
        err_source_c12r36
        err_source_c12r27
        err_source_c12r69
        err_source_c12r91
        err_source_c25open
        err_source_c25short
        err_source_c25r10
        err_source_c25r250
        err_source_cold
        err_source_hot
        err_source_r25
        err_source_r100

        % Reference plane source errors (from lab data)
        err_sourceLab_c12r36
        err_sourceLab_c12r27
        err_sourceLab_c12r69
        err_sourceLab_c12r91
        err_sourceLab_c25open
        err_sourceLab_c25short
        err_sourceLab_c25r10
        err_sourceLab_c25r250
        err_sourceLab_cold
        err_sourceLab_hot
        err_sourceLab_r25
        err_sourceLab_r100

        % Lab measured data as load to MTS errors
        err_sourceMTS_c12r36
        err_sourceMTS_c12r27
        err_sourceMTS_c12r69
        err_sourceMTS_c12r91
        err_sourceMTS_c25open
        err_sourceMTS_c25short
        err_sourceMTS_c25r10
        err_sourceMTS_c25r250
        err_sourceMTS_cold
        err_sourceMTS_hot
        err_sourceMTS_r25
        err_sourceMTS_r100


        % Lower level error functions
        err_ms3
        err_c2
        err_c10
        err_mts

        


    end
    properties (Access = public,Constant = false)
        counter(1,1) double {mustBeReal,mustBeNonnegative} = 0;
    end
    properties (Constant = true)
        sourceNames = {'c12r36','c12r27','c12r69','c12r91','c25open','c25short','c25r10','c25r250','cold','hot','r25','r100','ant'}
        freqUnit = 'MHz'

        rVarNames = {'C1','L1','C2','R'};
        cVarNames = {'Z0','L','eps_r_slope','eps_r_const','tan_d_slope','tan_d_const','r_prime_slope','r_prime_const'};
        cShortVarNames = {'Z0','L','eps_r','tan_d','r_prime'};
        adaptVarNames = {'C1','L1','C2'};

        optVectElements = {'r36','r27','r69','r91','rOpen','rShort','r10','r250','rCold','rHot','r25','r100','ms1','ms3','ms4','mts','sr_mtsj1','sr_mtsj2','sr_ms1j2','c2','c10','la'};
%         optErrElements = {'c12r36','c12r27','c12r69','c12r91','c25open','c25short','c25r10','c25r250','cold','hot','r25','r100'};

        outputElements = {'r36','r27','r69','r91','rOpen','rShort','r10','r250','rCold','rHot','r25','r100','ms1','ms3','ms4','mts','sr_mtsj1','sr_mtsj2','sr_ms1j2','c2','c10'};

        validFieldsInputStruct = {'vals','unitScales','max','min','optFlag'};
        Temp_el = {'r36','r27','r69','r91','open','short','r10','r250','cold','hot','r25','r100','ant','ms3','ms4','ms1','c2','c10','sr_mtsj2'};
    end

    methods
        function obj = REACHcal(dataPath,varargin)
            % REACHcal constructor function

            % Handle inputs
            parseobj = inputParser;
            parseobj.FunctionName = 'REACHcal';

            p = mfilename("fullpath");
            if nargin < 1 || isempty(dataPath)
                obj.dataPath = [fileparts(p),'\..\data\calibration\'];
            else
                obj.dataPath = dataPath;
            end
            % MS3 dataPath
            obj.dataPathMS3 = [fileparts(p),'\..\data\MS-3\'];
            % Lab measurements datapath
            obj.dataPathLabCable = [fileparts(p),'\..\data\lab_cables\'];
            obj.dataPathLabSources = [fileparts(p),'\..\data\lab_sources\'];

            % Name-value pairs
            typeValidation_elementStruct = @(x) validateattributes(x,{'struct'},{},'REACHcal','inputStruct');

            for ii = 1:length(obj.optVectElements)
                elName = obj.optVectElements{ii};
                parseobj.addOptional(elName,[],typeValidation_elementStruct);
            end

            parseobj.parse(varargin{:})
            parseResult = parseobj.Results;

            for ii = 1:length(obj.optVectElements)
                elName = obj.optVectElements{ii};
                inStructs.(elName) = parseResult.(elName);

                if isfield(inStructs,elName) && ~isempty(inStructs.(elName))
                    fn = fieldnames(inStructs.(elName));
                    ind = ismember(fn,obj.validFieldsInputStruct);
                    if ~all(ind)
                        disp(['Error in ',elName,' input for fields: '])
                        disp(fn(~ind))
                        mustBeMember(fn,obj.validFieldsInputStruct)
                    else
                        % Assign only the valid field names
                        for jj = 1:length(ind)
                            inStruct_ = inStructs.(elName);
                            obj.([elName,'_',fn{jj}]) = inStruct_.([fn{jj}]);
                        end
                    end
                    minVar = obj.([elName,'_min']);
                    maxVar = obj.([elName,'_max']);
                    assert(all(maxVar >= minVar),[elName,'_min must be <= ',elName,'_max'])
                end
            end


            % Read the data
            % Get the folder format - default is 2 so only change if needed
            % First the lab data
            obj = obj.readLabData;


            if isfolder([obj.dataPath,'ant']), obj.folderFormat = 1; end
            obj = obj.readS11data;
            if obj.folderFormat == 1
                obj = obj.readTempData;
                obj = obj.readPSDdata;
            end

            % Read the MS3 data - only for the active through paths
            obj.S_meas_MS3_J1 = TwoPort.readTouchStone([obj.dataPathMS3,'P2_J1\J1_ON.s2p'],2,obj.freqHz);
            obj.S_meas_MS3_J2 = TwoPort.readTouchStone([obj.dataPathMS3,'P2_J2\J2_ON.s2p'],2,obj.freqHz);
            obj.S_meas_MS3_J3 = TwoPort.readTouchStone([obj.dataPathMS3,'P2_J3\J3_ON.s2p'],2,obj.freqHz);
            obj.S_meas_MS3_J4 = TwoPort.readTouchStone([obj.dataPathMS3,'P2_J4\J4_ON.s2p'],2,obj.freqHz);
            obj.S_meas_MS3_J1 = obj.S_meas_MS3_J1.freqChangeUnit(obj.freqUnit);
            obj.S_meas_MS3_J2 = obj.S_meas_MS3_J2.freqChangeUnit(obj.freqUnit);
            obj.S_meas_MS3_J3 = obj.S_meas_MS3_J3.freqChangeUnit(obj.freqUnit);
            obj.S_meas_MS3_J4 = obj.S_meas_MS3_J4.freqChangeUnit(obj.freqUnit);

            % Read the lab cable data 
            obj.S_meas_c2 = TwoPort.readTouchStone([obj.dataPathLabCable,'2m_P1A1-P2A2_installed.s2p'],2,obj.freqHz);
            obj.S_meas_c10 = TwoPort.readTouchStone([obj.dataPathLabCable,'10m_P1A1-P2A2_installed.s2p'],2,obj.freqHz);
            obj.S_meas_c2 = obj.S_meas_c2.freqChangeUnit(obj.freqUnit);
            obj.S_meas_c10 = obj.S_meas_c10.freqChangeUnit(obj.freqUnit);


            % Set up optimization preliminaries
            obj.optVect_Ne = length(obj.optVectElements);
            % First get the number of variables in the full vector
            obj.optVect_Nvars = zeros(1,obj.optVect_Ne);
            for ii = 1:obj.optVect_Ne
                obj.optVect_Nvars(ii) = length(obj.(obj.optVectElements{ii}).vals);
            end

        end

        % Dependent getters
        function optErrElements = get.optErrElements(obj)
            optErrElements = obj.sourceNames(1:end-1);
        end

        function freq = get.freq(obj)
            freq = linspace(obj.fmin,obj.fmax,obj.Nf);
        end

        function freqHz = get.freqHz(obj)
            freqHz = obj.freq.*1e6;
        end

        function r36 = get.r36(obj)
            r36 = obj.buildRstruct(obj.r36_vals,obj.r36_unitScales,obj.r36_max,obj.r36_min,obj.r36_optFlag);
        end

        function r27 = get.r27(obj)
            r27 = obj.buildRstruct(obj.r27_vals,obj.r27_unitScales,obj.r27_max,obj.r27_min,obj.r27_optFlag);
        end

        function r69 = get.r69(obj)
            r69 = obj.buildRstruct(obj.r69_vals,obj.r69_unitScales,obj.r69_max,obj.r69_min,obj.r69_optFlag);
        end

        function r91 = get.r91(obj)
            r91 = obj.buildRstruct(obj.r91_vals,obj.r91_unitScales,obj.r91_max,obj.r91_min,obj.r91_optFlag);
        end

        function rOpen = get.rOpen(obj)
            rOpen = obj.buildRstruct(obj.rOpen_vals,obj.rOpen_unitScales,obj.rOpen_max,obj.rOpen_min,obj.rOpen_optFlag);
        end

        function rShort = get.rShort(obj)
            rShort = obj.buildRstruct(obj.rShort_vals,obj.rShort_unitScales,obj.rShort_max,obj.rShort_min,obj.rShort_optFlag);
        end

        function r10 = get.r10(obj)
            r10 = obj.buildRstruct(obj.r10_vals,obj.r10_unitScales,obj.r10_max,obj.r10_min,obj.r10_optFlag);
        end

        function r250 = get.r250(obj)
            r250 = obj.buildRstruct(obj.r250_vals,obj.r250_unitScales,obj.r250_max,obj.r250_min,obj.r250_optFlag);
        end

        function rCold = get.rCold(obj)
            rCold = obj.buildRstruct(obj.rCold_vals,obj.rCold_unitScales,obj.rCold_max,obj.rCold_min,obj.rCold_optFlag);
        end

        function rHot = get.rHot(obj)
            rHot = obj.buildRstruct(obj.rHot_vals,obj.rHot_unitScales,obj.rHot_max,obj.rHot_min,obj.rHot_optFlag);
        end

        function r25 = get.r25(obj)
            r25 = obj.buildRstruct(obj.r25_vals,obj.r25_unitScales,obj.r25_max,obj.r25_min,obj.r25_optFlag);
        end

        function r100 = get.r100(obj)
            r100 = obj.buildRstruct(obj.r100_vals,obj.r100_unitScales,obj.r100_max,obj.r100_min,obj.r100_optFlag);
        end

        function c2 = get.c2(obj)
            if obj.useMeasCableC2
                c2 = obj.buildCableStruct('c2');
            else
                c2 = obj.buildCableStruct(obj.c2_vals,obj.c2_unitScales,obj.c2_max,obj.c2_min,obj.c2_optFlag);
            end
        end

        function c10 = get.c10(obj)
            if obj.useMeasCableC10
                c10 = obj.buildCableStruct('c10');
            else
                c10 = obj.buildCableStruct(obj.c10_vals,obj.c10_unitScales,obj.c10_max,obj.c10_min,obj.c10_optFlag);
            end
        end

        function ms1 = get.ms1(obj)
            ms1 = obj.buildShortCableStruct(obj.ms1_vals,obj.ms1_unitScales,obj.ms1_max,obj.ms1_min,obj.ms1_optFlag);
        end

        function ms3 = get.ms3(obj)
            ms3 = obj.buildShortCableStruct(obj.ms3_vals,obj.ms3_unitScales,obj.ms3_max,obj.ms3_min,obj.ms3_optFlag);
        end

        function ms4 = get.ms4(obj)
            ms4 = obj.buildShortCableStruct(obj.ms4_vals,obj.ms4_unitScales,obj.ms4_max,obj.ms4_min,obj.ms4_optFlag);
        end

        function mts = get.mts(obj)
            mts = obj.buildShortCableStruct(obj.mts_vals,obj.mts_unitScales,obj.mts_max,obj.mts_min,obj.mts_optFlag);
        end

        function sr_mtsj1 = get.sr_mtsj1(obj)
            sr_mtsj1 = obj.buildShortCableStruct(obj.sr_mtsj1_vals,obj.sr_mtsj1_unitScales,obj.sr_mtsj1_max,obj.sr_mtsj1_min,obj.sr_mtsj1_optFlag);
%             sr_mtsj1 = obj.buildCableStruct(obj.sr_mtsj1_vals,obj.sr_mtsj1_unitScales,obj.sr_mtsj1_max,obj.sr_mtsj1_min,obj.sr_mtsj1_optFlag);
        end

        function sr_mtsj2 = get.sr_mtsj2(obj)
            sr_mtsj2 = obj.buildShortCableStruct(obj.sr_mtsj2_vals,obj.sr_mtsj2_unitScales,obj.sr_mtsj2_max,obj.sr_mtsj2_min,obj.sr_mtsj2_optFlag);
%             sr_mtsj2 = obj.buildCableStruct(obj.sr_mtsj2_vals,obj.sr_mtsj2_unitScales,obj.sr_mtsj2_max,obj.sr_mtsj2_min,obj.sr_mtsj2_optFlag);
        end

        function sr_ms1j2 = get.sr_ms1j2(obj)
            sr_ms1j2 = obj.buildShortCableStruct(obj.sr_ms1j2_vals,obj.sr_ms1j2_unitScales,obj.sr_ms1j2_max,obj.sr_ms1j2_min,obj.sr_ms1j2_optFlag);
        end

        function la = get.la(obj)
            la = obj.buildShortCableStruct(obj.la_vals,obj.la_unitScales,obj.la_max,obj.la_min,obj.la_optFlag);
        end

        function ps = get.ps(obj)
            ps.vals = obj.ps_vals;
            ps.unitScales = obj.ps_unitScales;
            ps.max = obj.ps_max;
            ps.min = obj.ps_min;
            ps.optFlag = obj.ps_optFlag;
            lenScale = ps.vals.*ps.unitScales;
            Z0 = 50;
            ps.network = TwoPort.Tline(Z0,lenScale,obj.freqHz,1,0,0,Z0,Z0);
            ps.network = ps.network.freqChangeUnit(obj.freqUnit);
        end

%         function a_ms3 = get.a_ms3(obj)
%             a_ms3 = obj.buildAdaptStruct(obj.a_ms3_vals,obj.a_ms3_unitScales,obj.a_ms3_max,obj.a_ms3_min,obj.a_ms3_optFlag);
%         end
% 
%         function a_ms1j7 = get.a_ms1j7(obj)
%             a_ms1j7 = obj.buildAdaptStruct(obj.a_ms1j7_vals,obj.a_ms1j7_unitScales,obj.a_ms1j7_max,obj.a_ms1j7_min,obj.a_ms1j7_optFlag);
%         end
% 
%         function a_ms1 = get.a_ms1(obj)
%             a_ms1 = obj.buildAdaptStruct(obj.a_ms1_vals,obj.a_ms1_unitScales,obj.a_ms1_max,obj.a_ms1_min,obj.a_ms1_optFlag);
%         end

        function Sc12r36 = get.Sc12r36(obj)
            Sc12r36 = obj.buildSourceStruct({'sr_mtsj1','mts','sr_mtsj2','ms1','c2','ms3','r36'});
        end

        function Sc12r27 = get.Sc12r27(obj)
            Sc12r27 = obj.buildSourceStruct({'sr_mtsj1','mts','sr_mtsj2','ms1','c2','ms3','r27'});
        end

        function Sc12r69 = get.Sc12r69(obj)
            Sc12r69 = obj.buildSourceStruct({'sr_mtsj1','mts','sr_mtsj2','ms1','c2','ms3','r69'});
        end

        function Sc12r91 = get.Sc12r91(obj)
            Sc12r91 = obj.buildSourceStruct({'sr_mtsj1','mts','sr_mtsj2','ms1','c2','ms3','r91'});
        end

        function Sc25open = get.Sc25open(obj)
            Sc25open = obj.buildSourceStruct({'sr_mtsj1','mts','sr_mtsj2','ms1','c10','ms4','rOpen'});
        end

        function Sc25short = get.Sc25short(obj)
            Sc25short = obj.buildSourceStruct({'sr_mtsj1','mts','sr_mtsj2','ms1','c10','ms4','rShort'});
        end

        function Sc25r10 = get.Sc25r10(obj)
            Sc25r10 = obj.buildSourceStruct({'sr_mtsj1','mts','sr_mtsj2','ms1','c10','ms4','r10'});
        end

        function Sc25r250 = get.Sc25r250(obj)
            Sc25r250 = obj.buildSourceStruct({'sr_mtsj1','mts','sr_mtsj2','ms1','c10','ms4','r250'});
        end

        function Scold = get.Scold(obj)
            Scold = obj.buildSourceStruct({'sr_mtsj1','mts','sr_mtsj2','ms1','rCold'});
        end

        function Shot = get.Shot(obj)
            Shot = obj.buildSourceStruct({'sr_mtsj1','mts','sr_mtsj2','ms1','sr_ms1j2','rHot'});
        end

        function Sr25 = get.Sr25(obj)
            Sr25 = obj.buildSourceStruct({'sr_mtsj1','mts','sr_mtsj2','ms1','r25'});
        end

        function Sr100 = get.Sr100(obj)
            Sr100 = obj.buildSourceStruct({'sr_mtsj1','mts','sr_mtsj2','ms1','r100'});
        end

        function Rc12r36 = get.Rc12r36(obj)
            Rc12r36 = obj.buildSourceStruct({'sr_mtsj2','ms1','c2','ms3','r36'});
        end

        function Rc12r27 = get.Rc12r27(obj)
            Rc12r27 = obj.buildSourceStruct({'sr_mtsj2','ms1','c2','ms3','r27'});
        end

        function Rc12r69 = get.Rc12r69(obj)
            Rc12r69 = obj.buildSourceStruct({'sr_mtsj2','ms1','c2','ms3','r69'});
        end

        function Rc12r91 = get.Rc12r91(obj)
            Rc12r91 = obj.buildSourceStruct({'sr_mtsj2','ms1','c2','ms3','r91'});
        end

        function Rc25open = get.Rc25open(obj)
            Rc25open = obj.buildSourceStruct({'sr_mtsj2','ms1','c10','ms4','rOpen'});
        end

        function Rc25short = get.Rc25short(obj)
            Rc25short = obj.buildSourceStruct({'sr_mtsj2','ms1','c10','ms4','rShort'});
        end

        function Rc25r10 = get.Rc25r10(obj)
            Rc25r10 = obj.buildSourceStruct({'sr_mtsj2','ms1','c10','ms4','r10'});
        end

        function Rc25r250 = get.Rc25r250(obj)
            Rc25r250 = obj.buildSourceStruct({'sr_mtsj2','ms1','c10','ms4','r250'});
        end

        function Rcold = get.Rcold(obj)
            Rcold = obj.buildSourceStruct({'sr_mtsj2','ms1','rCold'});
        end

        function Rhot = get.Rhot(obj)
            Rhot = obj.buildSourceStruct({'sr_mtsj2','ms1','sr_ms1j2','rHot'});
        end

        function Rr25 = get.Rr25(obj)
            Rr25 = obj.buildSourceStruct({'sr_mtsj2','ms1','r25'});
        end

        function Rr100 = get.Rr100(obj)
            Rr100 = obj.buildSourceStruct({'sr_mtsj2','ms1','r100'});
        end

        function Lc12r36 = get.Lc12r36(obj)
            Lc12r36 = obj.buildLabSourceStruct('c12r36');
        end

        function Lc12r27 = get.Lc12r27(obj)
            Lc12r27 = obj.buildLabSourceStruct('c12r27');
        end

        function Lc12r69 = get.Lc12r69(obj)
            Lc12r69 = obj.buildLabSourceStruct('c12r69');
        end

        function Lc12r91 = get.Lc12r91(obj)
            Lc12r91 = obj.buildLabSourceStruct('c12r91');
        end

        function Lc25open = get.Lc25open(obj)
            Lc25open = obj.buildLabSourceStruct('c25open');
        end

        function Lc25short = get.Lc25short(obj)
            Lc25short = obj.buildLabSourceStruct('c25short');
        end

        function Lc25r10 = get.Lc25r10(obj)
            Lc25r10 = obj.buildLabSourceStruct('c25r10');
        end

        function Lc25r250 = get.Lc25r250(obj)
            Lc25r250 = obj.buildLabSourceStruct('c25r250');
        end

        function Lcold = get.Lcold(obj)
            Lcold = obj.buildLabSourceStruct('cold');
        end

        function Lhot = get.Lhot(obj)
            Lhot = obj.buildLabSourceStruct('hot');
        end

        function Lr25 = get.Lr25(obj)
            Lr25 = obj.buildLabSourceStruct('r25');
        end

        function Lr100 = get.Lr100(obj)
            Lr100 = obj.buildLabSourceStruct('r100');
        end

        function Gc12r36 = get.Gc12r36(obj)
            Gc12r36 = obj.calcSourceGain('c12r36');
        end

        function Gc12r27 = get.Gc12r27(obj)
            Gc12r27 = obj.calcSourceGain('c12r27');
        end

        function Gc12r69 = get.Gc12r69(obj)
            Gc12r69 = obj.calcSourceGain('c12r69');
        end

        function Gc12r91 = get.Gc12r91(obj)
            Gc12r91 = obj.calcSourceGain('c12r91');
        end

        function Gc25open = get.Gc25open(obj)
            Gc25open = obj.calcSourceGain('c25open');
        end

        function Gc25short = get.Gc25short(obj)
            Gc25short = obj.calcSourceGain('c25short');
        end

        function Gc25r10 = get.Gc25r10(obj)
            Gc25r10 = obj.calcSourceGain('c25r10');
        end

        function Gc25r250 = get.Gc25r250(obj)
            Gc25r250 = obj.calcSourceGain('c25r250');
        end

        function Gcold = get.Gcold(obj)
            Gcold = obj.calcSourceGain('cold');
        end

        function Ghot = get.Ghot(obj)
            Ghot = obj.calcSourceGain('hot');
        end

        function Gr25 = get.Gr25(obj)
            Gr25 = obj.calcSourceGain('r25');
        end

        function Gr100 = get.Gr100(obj)
            Gr100 = obj.calcSourceGain('r100');
        end

        function Tc12r36 = get.Tc12r36(obj)
            Tc12r36 = obj.calcSourceTemp('c12r36');
        end

        function Tc12r27 = get.Tc12r27(obj)
            Tc12r27 = obj.calcSourceTemp('c12r27');
        end

        function Tc12r69 = get.Tc12r69(obj)
            Tc12r69 = obj.calcSourceTemp('c12r69');
        end

        function Tc12r91 = get.Tc12r91(obj)
            Tc12r91 = obj.calcSourceTemp('c12r91');
        end

        function Tc25open = get.Tc25open(obj)
            Tc25open = obj.calcSourceTemp('c25open');
        end

        function Tc25short = get.Tc25short(obj)
            Tc25short = obj.calcSourceTemp('c25short');
        end

        function Tc25r10 = get.Tc25r10(obj)
            Tc25r10 = obj.calcSourceTemp('c25r10');
        end

        function Tc25r250 = get.Tc25r250(obj)
            Tc25r250 = obj.calcSourceTemp('c25r250');
        end
        
        function Tcold = get.Tcold(obj)
            Tcold = obj.calcSourceTemp('cold');
        end
        
        function Thot = get.Thot(obj)
            Thot = obj.calcSourceTemp('hot');
        end
        
        function Tr25 = get.Tr25(obj)
            Tr25 = obj.calcSourceTemp('r25');
        end
        
        function Tr100 = get.Tr100(obj)
            Tr100 = obj.calcSourceTemp('r100');
        end

        function errFuncHandle = get.errFuncHandle(obj)
            switch obj.errorFuncType
                case {'complexDistance'}
                    errFuncHandle = @err_complexDistance;
                case {'RIA'}
                    errFuncHandle = @err_RIA;
                case {'magDistance'}
                    errFuncHandle = @err_magDistance;
                otherwise
                    error('I should not be here')
            end
        end

        function errFuncNormHandle = get.errFuncNormHandle(obj)
            switch obj.errorFuncNorm
                case {'max'}
                    errFuncNormHandle = @max;
                case {'mean'}
                    errFuncNormHandle = @mean;
                case {'norm'}
                    errFuncNormHandle = @(x) vecnorm(x)./obj.Nf;
                otherwise
                    error('I should not be here')
            end
        end

        function errFuncScaleHandle = get.errFuncScaleHandle(obj)
            switch obj.errorFuncScale
                case 'lin'
                    errFuncScaleHandle = @(x) x;
                case 'dB'
                    errFuncScaleHandle = @dB20;
                otherwise
                    error('I should not be here');
            end
        end
        
        function err_source_c12r36 = get.err_source_c12r36(obj)
            err_source_c12r36 = obj.errFuncHandle(obj,obj.S11_meas_c12r36,obj.Sc12r36.network.getS.d11);
        end

        function err_source_c12r27 = get.err_source_c12r27(obj)
            err_source_c12r27 = obj.errFuncHandle(obj,obj.S11_meas_c12r27,obj.Sc12r27.network.getS.d11);
        end

        function err_source_c12r69 = get.err_source_c12r69(obj)
            err_source_c12r69 = obj.errFuncHandle(obj,obj.S11_meas_c12r69,obj.Sc12r69.network.getS.d11);
        end

        function err_source_c12r91 = get.err_source_c12r91(obj)
            err_source_c12r91 = obj.errFuncHandle(obj,obj.S11_meas_c12r91,obj.Sc12r91.network.getS.d11);
        end

        function err_source_c25open = get.err_source_c25open(obj)
            err_source_c25open = obj.errFuncHandle(obj,obj.S11_meas_c25open,obj.Sc25open.network.getS.d11);
        end

        function err_source_c25short = get.err_source_c25short(obj)
            err_source_c25short = obj.errFuncHandle(obj,obj.S11_meas_c25short,obj.Sc25short.network.getS.d11);
        end

        function err_source_c25r10 = get.err_source_c25r10(obj)
            err_source_c25r10 = obj.errFuncHandle(obj,obj.S11_meas_c25r10,obj.Sc25r10.network.getS.d11);
        end

        function err_source_c25r250 = get.err_source_c25r250(obj)
            err_source_c25r250 = obj.errFuncHandle(obj,obj.S11_meas_c25r250,obj.Sc25r250.network.getS.d11);
        end

        function err_source_cold = get.err_source_cold(obj)
            err_source_cold = obj.errFuncHandle(obj,obj.S11_meas_cold,obj.Scold.network.getS.d11);
        end

        function err_source_hot = get.err_source_hot(obj)
            err_source_hot = obj.errFuncHandle(obj,obj.S11_meas_hot,obj.Shot.network.getS.d11);
        end

        function err_source_r25 = get.err_source_r25(obj)
            err_source_r25 = obj.errFuncHandle(obj,obj.S11_meas_r25,obj.Sr25.network.getS.d11);
        end

        function err_source_r100 = get.err_source_r100(obj)
            err_source_r100 = obj.errFuncHandle(obj,obj.S11_meas_r100,obj.Sr100.network.getS.d11);
        end

        function err_sourceLab_c12r36 = get.err_sourceLab_c12r36(obj)
            err_sourceLab_c12r36 = obj.errFuncHandle(obj,obj.S11_lab_c12r36,obj.Rc12r36.network.getS.d11);
        end

        function err_sourceLab_c12r27 = get.err_sourceLab_c12r27(obj)
            err_sourceLab_c12r27 = obj.errFuncHandle(obj,obj.S11_lab_c12r27,obj.Rc12r27.network.getS.d11);
        end

        function err_sourceLab_c12r69 = get.err_sourceLab_c12r69(obj)
            err_sourceLab_c12r69 = obj.errFuncHandle(obj,obj.S11_lab_c12r69,obj.Rc12r69.network.getS.d11);
        end

        function err_sourceLab_c12r91 = get.err_sourceLab_c12r91(obj)
            err_sourceLab_c12r91 = obj.errFuncHandle(obj,obj.S11_lab_c12r91,obj.Rc12r91.network.getS.d11);
        end

        function err_sourceLab_c25open = get.err_sourceLab_c25open(obj)
            err_sourceLab_c25open = obj.errFuncHandle(obj,obj.S11_lab_c25open,obj.Rc25open.network.getS.d11);
        end

        function err_sourceLab_c25short = get.err_sourceLab_c25short(obj)
            err_sourceLab_c25short = obj.errFuncHandle(obj,obj.S11_lab_c25short,obj.Rc25short.network.getS.d11);
        end

        function err_sourceLab_c25r10 = get.err_sourceLab_c25r10(obj)
            err_sourceLab_c25r10 = obj.errFuncHandle(obj,obj.S11_lab_c25r10,obj.Rc25r10.network.getS.d11);
        end

        function err_sourceLab_c25r250 = get.err_sourceLab_c25r250(obj)
            err_sourceLab_c25r250 = obj.errFuncHandle(obj,obj.S11_lab_c25r250,obj.Rc25r250.network.getS.d11);
        end

        function err_sourceLab_cold = get.err_sourceLab_cold(obj)
            err_sourceLab_cold = obj.errFuncHandle(obj,obj.S11_lab_cold,obj.Rcold.network.getS.d11);
        end

        function err_sourceLab_hot = get.err_sourceLab_hot(obj)
            err_sourceLab_hot = obj.errFuncHandle(obj,obj.S11_lab_hot,obj.Rhot.network.getS.d11);
        end

        function err_sourceLab_r25 = get.err_sourceLab_r25(obj)
            err_sourceLab_r25 = obj.errFuncHandle(obj,obj.S11_lab_r25,obj.Rr25.network.getS.d11);
        end

        function err_sourceLab_r100 = get.err_sourceLab_r100(obj)
            err_sourceLab_r100 = obj.errFuncHandle(obj,obj.S11_lab_r100,obj.Rr100.network.getS.d11);
        end

        function err_sourceMTS_c12r36 = get.err_sourceMTS_c12r36(obj)
            err_sourceMTS_c12r36 = obj.errFuncHandle(obj,obj.S11_meas_c12r36,obj.Lc12r36.network.getS.d11);
        end

        function err_sourceMTS_c12r27 = get.err_sourceMTS_c12r27(obj)
            err_sourceMTS_c12r27 = obj.errFuncHandle(obj,obj.S11_meas_c12r27,obj.Lc12r27.network.getS.d11);
        end

        function err_sourceMTS_c12r69 = get.err_sourceMTS_c12r69(obj)
            err_sourceMTS_c12r69 = obj.errFuncHandle(obj,obj.S11_meas_c12r69,obj.Lc12r69.network.getS.d11);
        end

        function err_sourceMTS_c12r91 = get.err_sourceMTS_c12r91(obj)
            err_sourceMTS_c12r91 = obj.errFuncHandle(obj,obj.S11_meas_c12r91,obj.Lc12r91.network.getS.d11);
        end

        function err_sourceMTS_c25open = get.err_sourceMTS_c25open(obj)
            err_sourceMTS_c25open = obj.errFuncHandle(obj,obj.S11_meas_c25open,obj.Lc25open.network.getS.d11);
        end

        function err_sourceMTS_c25short = get.err_sourceMTS_c25short(obj)
            err_sourceMTS_c25short = obj.errFuncHandle(obj,obj.S11_meas_c25short,obj.Lc25short.network.getS.d11);
        end

        function err_sourceMTS_c25r10 = get.err_sourceMTS_c25r10(obj)
            err_sourceMTS_c25r10 = obj.errFuncHandle(obj,obj.S11_meas_c25r10,obj.Lc25r10.network.getS.d11);
        end

        function err_sourceMTS_c25r250 = get.err_sourceMTS_c25r250(obj)
            err_sourceMTS_c25r250 = obj.errFuncHandle(obj,obj.S11_meas_c25r250,obj.Lc25r250.network.getS.d11);
        end

        function err_sourceMTS_cold = get.err_sourceMTS_cold(obj)
            err_sourceMTS_cold = obj.errFuncHandle(obj,obj.S11_meas_cold,obj.Lcold.network.getS.d11);
        end

        function err_sourceMTS_hot = get.err_sourceMTS_hot(obj)
            err_sourceMTS_hot = obj.errFuncHandle(obj,obj.S11_meas_hot,obj.Lhot.network.getS.d11);
        end

        function err_sourceMTS_r25 = get.err_sourceMTS_r25(obj)
            err_sourceMTS_r25 = obj.errFuncHandle(obj,obj.S11_meas_r25,obj.Lr25.network.getS.d11);
        end

        function err_sourceMTS_r100 = get.err_sourceMTS_r100(obj)
            err_sourceMTS_r100 = obj.errFuncHandle(obj,obj.S11_meas_r100,obj.Lr100.network.getS.d11);
        end

        function err_ms3 = get.err_ms3(obj)
            %             obj.Nf = length(obj.S_meas_MS3_J1.freq);
            %             obj.fmin = min(obj.S_meas_MS3_J1.freqHz)./1e6;
            %             obj.fmax = max(obj.S_meas_MS3_J1.freqHz)./1e6;
            meas21 = obj.S_meas_MS3_J1.d21;
            mod21 = obj.ms3.network.getS.d21;
            err_ms3 = sqrt(sum(abs(meas21 - mod21).^2))./obj.Nf;
        end

        function err_c2 = get.err_c2(obj)
            meas11 = obj.S_meas_c2.getS.d11;
            meas21 = obj.S_meas_c2.getS.d21;
            mod11 = obj.c2.network.getS.d11;
            mod21 = obj.c2.network.getS.d21;
            err_c2_11 = sqrt(sum(abs(meas11 - mod11).^2))./obj.Nf;
            err_c2_21 = sqrt(sum(abs(meas21 - mod21).^2))./obj.Nf;
            err_c2 = err_c2_11 + err_c2_21;
        end

        function err_c10 = get.err_c10(obj)
            meas11 = obj.S_meas_c10.getS.d11;
            meas21 = obj.S_meas_c10.getS.d21;
            mod11 = obj.c10.network.getS.d11;
            mod21 = obj.c10.network.getS.d21;
            err_c10_11 = sqrt(sum(abs(meas11 - mod11).^2))./obj.Nf;
            err_c10_21 = sqrt(sum(abs(meas21 - mod21).^2))./obj.Nf;
            err_c10 = err_c10_11 + err_c10_21;
        end

        function err_mts = get.err_mts(obj)

            meas11 = obj.S11_meas_c12r36;
            mod11 = obj.Lc12r36.network.getS.d11;

%             meas11 = obj.S11_meas_c25open;
%             mod11 = obj.Lc25open.network.getS.d11;

            err_mts = sqrt(sum(abs(meas11(:) - mod11(:)).^2))./obj.Nf;
        end

        function optStruct = get.optStruct(obj)
            valMat = zeros(5,sum(obj.optVect_Nvars));
            [elementNames,parameterNames] = deal(cell.empty(0,sum(obj.optVect_Nvars)));
            for ii = 1:obj.optVect_Ne
                idxStart = sum(obj.optVect_Nvars(1:(ii-1)))+1;
                idxStop = sum(obj.optVect_Nvars(1:ii));
                elName = obj.optVectElements{ii};
                switch lower(elName(1))
                    case 'r'
                        parNames = obj.rVarNames;
                    case {'m','s','l'}
                        parNames = obj.cShortVarNames;
                    case {'c'}
                        parNames = obj.cVarNames;
                    case 'a'
                        parNames = obj.adaptVarNames;
                end
                element_ = obj.(elName);
                elementNames(idxStart:idxStop) = repmat({elName},1,obj.optVect_Nvars(ii));
                parameterNames(idxStart:idxStop) = parNames;
                valMat(:,idxStart:idxStop) = [element_.vals; ...
                    element_.max; ...
                    element_.min; ...
                    element_.optFlag;...
                    1:obj.optVect_Nvars(ii)];
            end
            optStruct.vals = valMat(1,:); 
            optStruct.max = valMat(2,:);
            optStruct.min = valMat(3,:);
            optStruct.optFlag = valMat(4,:);
            optStruct.elementNames = elementNames;
            optStruct.parameterNames = parameterNames;
            optStruct.parameterIndex = valMat(5,:);

        end

        % Measurement data
        function obj = readLabData(obj)
            % READLABDATA read the set of lab data measurements

            for ii = 1:length(obj.sourceNames)-1
                obj.(['S11_lab_',obj.sourceNames{ii}]) = obj.readLabS11(obj.sourceNames{ii});
            end
        end

        function [S11,freq] = readLabS11(obj,sourceName,interpFlag)
            % READLABS11 returns the measured lab S11 in a vector
            % Also interpolates onto the object frequencies

            if nargin < 3 || isempty(interpFlag), interpFlag = true; end

            assert(ismember(sourceName,obj.sourceNames),'Unknown source name - check REACHcal.sourceNames')
            pthRead = obj.dataPathLabSources;
            
            [S11,freq] = touchread([pthRead,sourceName,'.s2p']);
            S11 = squeeze(S11(1,1,:));
            if interpFlag
                S11 = interp1(freq,S11,obj.freqHz,'linear');
                freq = obj.freqHz;
            end
        end

        function obj = readS11data(obj)
            % READS11DATA read the set of S11 measurements

            for ii = 1:length(obj.sourceNames)
                obj.(['S11_meas_',obj.sourceNames{ii}]) = obj.readSourceS11(obj.sourceNames{ii});
            end
        end
        
        function [S11,freq] = readSourceS11(obj,sourceName,interpFlag)
            % READSOURCES11 returns the measured source S11 in a vector
            % Also interpolates onto the object frequencies

            if nargin < 3 || isempty(interpFlag), interpFlag = true; end

            assert(ismember(sourceName,obj.sourceNames),'Unknown source name - check REACHcal.sourceNames')
            pthRead = obj.dataPath;
            if obj.folderFormat == 1, pthRead = [pthRead,sourceName,'\']; end
            
            [S11,freq] = touchread([pthRead,sourceName,'.s1p']);
            S11 = squeeze(S11(1,1,:));
            if interpFlag
                S11 = interp1(freq,S11,obj.freqHz,'linear');
                freq = obj.freqHz;
            end
        end

        function obj = readTempData(obj)
            % READTEMPDATA reads the temperature data

            for ii = 1:length(obj.sourceNames)
                if obj.folderFormat == 1
                    pthRead = [obj.dataPath,obj.sourceNames{ii},'\'];
                    fid = fopen([pthRead,'\temperature.txt'], 'r');
                    T = fscanf(fid, '%f');
                    fclose(fid);
                    obj.(['T_meas_',obj.sourceNames{ii}]) = T;
                else
                    error('not implemented yet')

                end
            end
        end

        function obj = readPSDdata(obj)
            % READPSDDATA read the set of PSD measurements

            for ii = 1:length(obj.sourceNames)
                obj.(['PSD_meas_',obj.sourceNames{ii}]) = obj.readSourcePSD(obj.sourceNames{ii});
            end
        end

        function PSDstruct = readSourcePSD(obj,sourceName)
            % READSOURCEPSD reads the PSD data into the structure format

            assert(ismember(sourceName,obj.sourceNames),'Unknown source name - check REACHcal.sourceNames')

            fileNames = {'load','noise','source'};

            for ii = 1:length(fileNames)
                fid = fopen([obj.dataPath,sourceName,'\psd_',fileNames{ii},'.txt'], 'r');
                S = fscanf(fid, '%c');
                fclose(fid);

                % Get all end-of-line indexes
                in2 = strfind(S,char([10]));

                % Get timestamp
                timeStr = '# Timestamp:';
                in1 = strfind(S,timeStr);
                ind = find(in2>in1); ind = ind(1);
                ln = S(in1+length(timeStr):in2(ind));
                ts = sscanf(ln,'%f');
                % Get frequencies
                freqStr = '# Frequencies:';
                in1 = strfind(S,freqStr);
                ind = find(in2>in1); ind = ind(1);
                ln = S(in1+length(freqStr):in2(ind));
                frequency = double(split(string(ln),',')).';
                frequency = frequency(frequency >= 50);
                % Get PSD values
                ln = S(in2(ind)+1:in2(end));
                PSD = double(split(string(ln),',')).';

                PSDstruct.(['timestamp_',fileNames{ii}]) = ts;
                PSDstruct.(['PSD_',fileNames{ii}]) = PSD;
                PSDstruct.(['freq_',fileNames{ii}]) = frequency;
            end
            assert(all(PSDstruct.freq_noise == PSDstruct.freq_source) && all(PSDstruct.freq_source == PSDstruct.freq_load),'Frequencies not consistant in PSDs')
            PSDstruct.freq = PSDstruct.freq_noise;
            for ii = 1:length(fileNames)
                PSDstruct = rmfield(PSDstruct,['freq_',fileNames{ii}]);
            end
        end

        % Optimization
        function obj = optimConfig(obj,configName,optElements,errElements,optTypeFlag)
            % OPTIMCONFIG configures the optimization routine settings

            if nargin > 4 && ~isempty(optTypeFlag), obj.optTypeFlag = optTypeFlag; end

            mustBeMember(obj.optTypeFlag,[1,2,3]);  % Rough error check here

            obj.optW = obj.optW.*0;
            switch lower(configName)
                case {'r36'}
                    switch obj.optTypeFlag
                        case 1
                            optElements = obj.Sc12r36.elements;
                        case 2
                            optElements = obj.Rc12r36.elements;
                    end
                    errElements = {'c12r36'};
                case {'r27'}
                    switch obj.optTypeFlag
                        case 1
                            optElements = obj.Sc12r27.elements;
                        case 2
                            optElements = obj.Rc12r27.elements;
                    end
                    errElements = {'c12r27'};
                case {'r69'}
                    switch obj.optTypeFlag
                        case 1
                            optElements = obj.Sc12r69.elements;
                        case 2
                            optElements = obj.Rc12r69.elements;
                    end
                    errElements = {'c12r69'};
                case {'r91'}
                    switch obj.optTypeFlag
                        case 1
                            optElements = obj.Sc12r91.elements;
                        case 2
                            optElements = obj.Rc12r91.elements;
                    end
                    errElements = {'c12r91'};
                case {'ropen','open'}
                    switch obj.optTypeFlag
                        case 1
                            optElements = obj.Sc25open.elements;
                        case 2
                            optElements = obj.Rc25open.elements;
                    end
                    errElements = {'c25open'};
                case {'rshort','short'}
                    switch obj.optTypeFlag
                        case 1
                            optElements = obj.Sc25short.elements;
                        case 2
                            optElements = obj.Rc25short.elements;
                    end
                    errElements = {'c25short'};
                case {'r10'}
                    switch obj.optTypeFlag
                        case 1
                            optElements = obj.Sc25r10.elements;
                        case 2
                            optElements = obj.Rc25r10.elements;
                    end
                    errElements = {'c25r10'};
                case {'r250'}
                    switch obj.optTypeFlag
                        case 1
                            optElements = obj.Sc25r250.elements;
                        case 2
                            optElements = obj.Rc25r250.elements;
                    end
                    errElements = {'c25r250'};
                case {'rcold','cold'}
                    switch obj.optTypeFlag
                        case 1
                            optElements = obj.Scold.elements;
                        case 2
                            optElements = obj.Rcold.elements;
                    end
                    errElements = {'cold'};
                case {'rhot','hot'}
                    switch obj.optTypeFlag
                        case 1
                            optElements = obj.Shot.elements;
                        case 2
                            optElements = obj.Rhot.elements;
                    end
                    errElements = {'hot'};
                case {'r25'}
                    switch obj.optTypeFlag
                        case 1
                            optElements = obj.Sr25.elements;
                        case 2
                            optElements = obj.Rr25.elements;
                    end
                    errElements = {'r25'};
                case {'r100'}
                    switch obj.optTypeFlag
                        case 1
                            optElements = obj.Sr100.elements;
                        case 2
                            optElements = obj.Rr100.elements;
                    end
                    errElements = {'r100'};
                case {'ms3set'}
                    switch obj.optTypeFlag
                        case 1
                            optElements = {'r36','r27','r69','r91','ms3','c2','ms1','sr_mtsj2','mts','sr_mtsj1'};
                        case 2
                            optElements = {'r36','r27','r69','r91','ms3','c2','ms1','sr_mtsj2'};
                    end
                    errElements = {'c12r36','c12r27','c12r69','c12r91'};
                case {'ms3set_lim'}
                    optElements = {'r36','r27','r69','r91','ms3','c2'};
                    errElements = {'c12r36','c12r27','c12r69','c12r91'};
                case {'ms4set'}
                    switch obj.optTypeFlag
                        case 1
                            optElements = {'rOpen','rShort','r10','r250','ms4','c10','ms1','sr_mtsj2','mts','sr_mtsj1'};
                        case 2
                            optElements = {'rOpen','rShort','r10','r250','ms4','c10','ms1','sr_mtsj2'};
                    end
                    errElements = {'c25open','c25short','c25r10','c25r250'};
                case {'ms4set_lim'}
                    optElements = {'rOpen','rShort','r10','r250','ms4','c10','ms1'};
                    errElements = {'c25open','c25short','c25r10','c25r250'};
                case {'ms4set_lim_10_250'}
                    optElements = {'r10','r250','ms4','c10'};
                    errElements = {'r10','r250'};
                case {'r25_r36_r10'}
                    switch obj.optTypeFlag
                        case 1
                            optElements = {'r25','r36','r10','ms3','ms4','c2','c10','ms1','sr_mtsj2','mts','sr_mtsj1'};
                        case 2
                            optElements = {'r25','r36','r10','ms3','ms4','c2','c10','ms1','sr_mtsj2'};
                    end
                    errElements = {'r25','c12r36','c25r10'};
                case {'no_open_short'}
                    optElements = obj.optVectElements;
                    optElements(contains(optElements,{'la','rOpen','rShort'})) = [];
                    switch obj.optTypeFlag
                        case 1
                            % Do nothing
                        case 2
                            optElements(contains(optElements,{'mts','sr_mtsj1'})) = [];
                    end
                    errElements = obj.optErrElements;
                    errElements(contains(errElements,{'c25open','c25short'})) = [];
                case {'all'}
                    switch obj.optTypeFlag
                        case 1
%                             optElements = {'r36','r27','r69','r91','rOpen','rShort','r10','r250','rCold','rHot','r25','r100','ms1','ms3','ms4','mts','sr_mtsj2','sr_mtsj1','sr_ms1j2','c2','c10'};
                            optElements = {'r36','r27','r69','r91','rOpen','rShort','r10','r250','rCold','rHot','r25','r100','ms1','ms3','ms4','mts','sr_mtsj2','sr_mtsj1','sr_ms1j2','c2','c10'};
                        case 2
                            optElements = {'r36','r27','r69','r91','rOpen','rShort','r10','r250','rCold','rHot','r25','r100','ms1','ms3','ms4','sr_mtsj2','c2','c10'};
                    end
                    errElements = obj.optErrElements;
                case 'custom'
                    assert(all(contains(optElements,obj.optVectElements)),'Found unknown optElement - please check')
                    assert(all(contains(errElements,obj.optErrElements)),'Found unknown errElement - please check')
                otherwise
                    error(['Unknown configName: ',configName])
            end

            % Overwrite the optElements for the mts case
            if obj.optTypeFlag == 3
                optElements = {'mts','sr_mtsj1','la'};
            end

            for ii = 1:length(obj.optVectElements)
              
                % Remove all the non-optimized elements from the optimization - the rest stay the way they are specified
                if ~ismember(obj.optVectElements{ii},optElements)
                    
                    obj.([obj.optVectElements{ii},'_optFlag']) = zeros(1,obj.optVect_Nvars(ii));
                end
            end

            for jj = 1:length(errElements)
                obj.optW = obj.optW | strcmp(errElements{jj},obj.optErrElements);
            end


        end

        function obj = fitParams(obj,solver,options)
            % FITPARAMS is the main fitting optimization function

            if nargin < 2 || isempty(solver), solver = 'fmincon'; end

            idx = find(obj.optStruct.optFlag == 1);

            X0 = obj.optStruct.vals(idx);
            LB = obj.optStruct.min(idx);
            UB = obj.optStruct.max(idx);

            switch lower(solver)
                case 'fmincon'
                    if nargin < 3 || isempty(options), options = optimoptions('fmincon','display','iter','MaxFunctionEvaluations',20000); end
                    optVals = fmincon(@(x) errFunc(obj,x),X0,[],[],[],[],LB,UB,[],options);
                case 'ga'
                    if nargin < 3 || isempty(options), options = optimoptions('ga','display','iter'); end
                    optVals = ga(@(x) errFunc(obj,x),length(X0),[],[],[],[],LB,UB,[],options);
                otherwise
                    error(['Unknown solver: ',solver]);
            end

            [~,obj] = obj.errFunc(optVals);
        end

        function [err,obj] = errFunc(obj,x)
            % ERRFUNC is the fitting optimization error function

            X = obj.optStruct.vals;
            X(obj.optStruct.optFlag == 1) = x;
            
%             X(99) = X(91); % Rprime for c2 & c10 
%             X(97) = X(89); % tanD for c2 & c10
%             X(95) = X(87); % epsilon for c2 & c10
            X(60) = X(55); % lengths of MS3-4
%             X(76) = X(71); % epsilon for 2 semirigids
%             X(77) = X(72); % tanD for 2 semirigids
%             X(78) = X(73); % Rprime for 2 semirigids
            for ii = 1:obj.optVect_Ne
                obj.([obj.optVectElements{ii},'_vals']) = X((sum(obj.optVect_Nvars(1:(ii-1)))+1):sum(obj.optVect_Nvars(1:ii)));
            end
            w = obj.optW;
            Ne = length(obj.optW);
            eV = ones(Ne,1).*(-inf);
            for ii = 1:Ne
                if w(ii)
                    switch obj.optTypeFlag
                        case 1
                            eV(ii) = obj.(['err_source_',obj.optErrElements{ii}]);
                        case 2
                            eV(ii) = obj.(['err_sourceLab_',obj.optErrElements{ii}]);
                        case 3
                            eV(ii) = obj.(['err_sourceMTS_',obj.optErrElements{ii}]);
                    end
                end
            end
            
%              persistent n
%              if isempty(n)
%                  n = 0;
%              end
%              
%              n = n+1;
%              
%              if (rem(n,1000) <= 5 || n == 1)
%                  eV
% 
%              end

%             w_ = obj.optW_RIA./norm(obj.optW_RIA,1);
%             w_ = [0.50 0.50];
%             eV_=zeros(12,1);
%             for i=1:12
%                 eV_(i,1) = w_*[imag(eV(i));real(eV(i))]; %  err = complex(err_complex,err_mag);
%             end
%             length(eV)
%             eV
            err_ = w(:).*eV;
%             err_ = w(:).*eV_;
            err_(w == 0) = -inf;
            
            switch obj.errorFuncType
                case 'RIA'
                    err = dB20(rms(conv(real(err_),imag(err_))));
%                     err = dB20(rms((real(err_)).*(imag(err_))));
%                     err = dB20(rms(err_));
                otherwise
                    err = (max(err_));    
            end
%             err = max(err_);
                        
        end

        function obj = fitMS3(obj)
            % FITMS3 is a component-level function to fit the MS3 model

            X0 = obj.ms3_vals;
            LB = obj.ms3_min;
            UB = obj.ms3_max;
            options = optimoptions('fmincon','display','iter','MaxIterations',1000);
            optVals = fmincon(@(x) errFuncMS3(obj,x),X0,[],[],[],[],LB,UB,[],options);
            [~,obj] = errFuncMS3(obj,optVals);

            function [err, obj] = errFuncMS3(obj,x)
                obj.ms3_vals = x;
                err = obj.err_ms3;
            end
        end

        function obj = fitCables(obj,cableName)
            % FITCABLES is a component-level function to fit the cable models

            if nargin < 2, cableName = 'c2'; end

            X0 = obj.([cableName,'_vals']);
            LB = obj.([cableName,'_min']);
            UB = obj.([cableName,'_max']);
            F = obj.([cableName,'_optFlag']);
            options = optimoptions('fmincon','display','none','MaxIterations',1000);
            optVals = fmincon(@(x) errFuncCable(obj,x,cableName,F),X0(F),[],[],[],[],LB(F),UB(F),[],options);
            [~,obj] = errFuncCable(obj,optVals,cableName,F);

            function [err, obj] = errFuncCable(obj,x,cableName,F)
                obj.([cableName,'_vals'])(F) = x;
                err = obj.(['err_',cableName]);
            end
        end

        function obj = fitMTS(obj)
            % FITMTS is a component-level function to fit the MTS and sr_mtsj1 models from lab measured data

            X0 = [obj.mts_vals,obj.sr_mtsj1.vals,obj.la_vals,obj.ps_vals];
            LB = [obj.mts_min,obj.sr_mtsj1.min,obj.la_min,obj.ps_min];
            UB = [obj.mts_max,obj.sr_mtsj1.max,obj.la_max,obj.ps_max];

            options = optimoptions('fmincon','display','iter','MaxIterations',1000);
            optVals = fmincon(@(x) errFuncMTS(obj,x),X0,[],[],[],[],LB,UB,[],options);
            
%             options = optimoptions('ga','display','iter','PopulationSize',1000);
%             optVals = ga(@(x) errFuncMTS(obj,x),length(X0),[],[],[],[],LB,UB,[],options);

            [~,obj] = errFuncMTS(obj,optVals);

            function [err, obj] = errFuncMTS(obj,x)
                obj.mts_vals = x(1:5);
                obj.sr_mtsj1_vals  = x(6:10);
                obj.la_vals = x(11:15);
                obj.ps_vals = x(16);
                err = obj.err_mts;
            end
        end

        % Parameter sweeps
        function [] = paramSweep(obj)
            % PARAMSWEEP does a 1D parameters sweep on all the parameters
            persweep_nom = 0.1; % percentage of variation from nominal parameters
            Nsweep = 3;
            Nerr = length(obj.optErrElements);
            Npar = length(obj.optStruct.parameterNames);

            % Set all the optFlags to true for the error calculation
            for ii = 1:length(obj.optVectElements)
                obj.([obj.optVectElements{ii},'_optFlag']) = true(1,obj.optVect_Nvars(ii));
            end
            obj.optTypeFlag = 1;

            % Nominal Parameter space equivalent errrors and temp space
            parNom = obj.optStruct.vals;
            [errNomMag,errNomComplex] = deal(nan(1,Nerr));
            Tnom = nan(obj.Nf,Nerr);
            obj.errorFuncScale = 'lin';
            for ii = 1:Nerr
                errNomMag(1,ii) = obj.err_magDistance(obj.(['S11_meas_',obj.optErrElements{ii}]),obj.(['S',obj.optErrElements{ii}]).network.getS.d11);
                errNomComplex(1,ii) = obj.err_complexDistance(obj.(['S11_meas_',obj.optErrElements{ii}]),obj.(['S',obj.optErrElements{ii}]).network.getS.d11);
                Tnom(:,ii) = obj.(['T',obj.optErrElements{ii}]);
            end


            Mag_TH = dB20((1+persweep_nom).*errNomMag); % Mag_error threshold
            Cmplx_TH = dB20(errNomComplex + 0.1.*errNomComplex); % Cmplx_error threshold
            Indx_Mpar = ones(Npar,Nsweep,Nerr); % index of the parameter only affecting temp
            Indx_Cpar = ones(Npar,Nsweep,Nerr); % index of the parameter only affecting temp

            obj.errorFuncScale = 'dB';

            % h = waitbar(0,'Calculating parameter sweep...');
            count = 0;
            [errMagVals,errComplexVals,Tdelta] = deal(nan(Npar,Nsweep,Nerr));
            errFuncVals = nan(Npar,Nsweep);
            Tvals = nan(Npar,Nsweep,Nerr,obj.Nf);
            par_space = nan(Npar,Nsweep);
            par_Pvar = 0.1;% parameter value percentage variation

            for aa = 1:Npar
                count = count + 1;
                %                 waitbar(aa/Npar,h)
                el = obj.optStruct.elementNames{aa};

        

                parMin = obj.optStruct.vals(aa) - abs(par_Pvar.*(obj.optStruct.vals(aa))); % percent variation of optimal parameter values minima
                parMax = obj.optStruct.vals(aa) + abs(par_Pvar.*(obj.optStruct.vals(aa))); % percent variation of optimal parameter values maxima


                parVals = linspace(parMin,parMax,Nsweep);
                par_space(aa,:) = parVals;

                for bb = 1:Nsweep
                    obj.([el,'_vals'])(obj.optStruct.parameterIndex(aa)) = parVals(bb);
                    for cc = 1:Nerr
                        optEl = obj.optErrElements{cc};
                        errMagVals(aa,bb,cc) = obj.err_magDistance(obj.(['S11_meas_',optEl]),obj.(['S',optEl]).network.getS.d11);
                        errComplexVals(aa,bb,cc) = obj.err_complexDistance(obj.(['S11_meas_',optEl]),obj.(['S',optEl]).network.getS.d11);
                        Tvals(aa,bb,cc,:) = obj.(['T',optEl]);
                        Tdelta(aa,bb,cc) = max(abs(Tnom(:,cc) - squeeze(Tvals(aa,bb,cc,:))));
                        if errMagVals(aa,bb,cc) <= Mag_TH(cc) && Tdelta(aa,bb,cc) > 0.001
                            Indx_Mpar(aa,bb,cc) = NaN;
                        end
                        if errComplexVals(aa,bb,cc) <= Cmplx_TH(cc) && Tdelta(aa,bb,cc) > 0.001
                            Indx_Cpar(aa,bb,cc) = NaN;
                        end
                    end

                    errFuncVals(aa,bb) = obj.errFunc(obj.optStruct.vals);
                end
                % Reset back to the nominal value
                obj.([el,'_vals'])(obj.optStruct.parameterIndex(aa)) = parNom(aa);
            end

% *****************************************************
%             % Plotting the delta_temp vs the error_mag/complx for a %age variation of the parameter space
            for k = 1:Nerr
                for j = 1:Nsweep
                    for i = 1:Npar
                        dt = squeeze(Tvals(i,j,k,:));
                        figure(555)
                        hold on; grid on;
                        subplot(3,4,k);
                        plot(obj.freq,dt,'r');
                        title([obj.optErrElements{k}]);

                        %                         waitbar((k-1)/Nerr,h);
                    end
                    %                     waitbar((k-1)/Nerr,h,['Plotting Source',obj.optErrElements{k},'...',num2str((j*100)/Nsweep),'%']);
                end
                %                 waitbar(k/Nerr,h);
            end
            for i=1:Nerr
                figure(555)
                subplot(3,4,i)
                plot(obj.freq,Tnom(:,i),'b',LineWidth=1.2);
                hold on; grid on;
            end
% *****************************************************
            errMagVals_ = errMagVals.*Indx_Mpar; % Mag_error values excluding parameters only affecting delta temp
            errComplexVals_ = errComplexVals.*Indx_Cpar; % Cmplx_error excluding parameters only affecting delta temp
            Indx_MTemp = isnan(Indx_Mpar); % Mag_err Indexing of parameter only affecting delta temp
            Indx_CTemp = isnan(Indx_Cpar); % Cmplx_err Indexing of parameter only affecting delta temp
            [par_Mspace, par_Cspace] = deal(repmat(par_space,1,1,Nerr));

            par_Mspace = ((par_Mspace./repmat(parNom(:),1,Nsweep,Nerr))-0).*Indx_MTemp;% Normalised Mag_err w.r.t. nominal parameters only affecting delta temp
            par_Cspace = ((par_Cspace./repmat(parNom(:),1,Nsweep,Nerr))-0).*Indx_CTemp;% Normalised Cmplx_err w.r.t. nominal parameters only affecting delta temp



% *****************************************************
            % Plotting all the parameters not affecting the error calculation
            [labels1, labels2] = deal(cell(1,Npar));
            for j = 1:Nsweep
                cntr = 1;
                for k = 1:length(obj.optVectElements)
                    switch lower(obj.optVectElements{k}(1))
                        case 'r'
                            lbl = obj.rVarNames;
                        case {'m','s','l'}
                            lbl = obj.cShortVarNames;
                        case {'c'}
                            lbl = obj.cVarNames;
                        case 'a'
                            lbl = obj.adaptVarNames;
                    end

                    labels1(cntr:(cntr+length(lbl)-1)) = (lbl);
                    labels2(cntr) =  obj.optVectElements(k);
                    cntr = cntr+length(lbl);
                end
            end

            pp_M = reshape(par_Mspace,[Npar,Nsweep*Nerr]);
            pp_C = reshape(par_Cspace,[Npar,Nsweep*Nerr]);
            label_par = cell(1,Nsweep*length(obj.optErrElements));
            c_j = 1;

            for i=1:Nsweep:length(label_par)
                    label_par(i) = obj.optErrElements(c_j);
            end

            figure
            bar3(pp_M);
            ax = gca;
            ax.XTick = 1:1:length(label_par);
            ax.XTickLabel = label_par;
            ax.YTick = 1:1:length(labels1);
            ax.YTickLabel = labels1;
            ax.Title.String = 'Parameter space around nominal values affecting only Temp calculations but not mag error fucntion ';
            

            xx = reshape(repmat(ax.XTick,length(ax.YTick),1),[Nsweep*Nerr*Npar 1]);
            yy = reshape(repmat(ax.YTick,length(ax.XTick),1)',[Nsweep*Nerr*Npar 1]);
            label_n = repmat(obj.optStruct.elementNames',1,Nerr*Nsweep);

            for i = 1:Npar
                for j = 1:Nsweep*Nerr
                    if pp_M(i,j) == 0 || isnan(pp_M(i,j))
                        label_n(i,j) = {''};
                    end

                end

            end

            text(xx, yy, pp_M(:)+0.01, label_n,'Color','r','FontWeight','bold', 'HorizontalAlignment','center', 'VerticalAlignment','bottom')

%             figure
%             bar3(pp_C);
%             ax = gca;
%             ax.XTick = 1:1:length(label_par);
%             ax.XTickLabel = label_par;
%             ax.YTick = 1:1:length(labels1);
%             ax.YTickLabel = labels1;
%             ax.Title.String = 'Parameter space around nominal values affecting only Temp calculations but not cmplx error fucntion ';

% *****************************************************
            % Plotting the parameters not affecting the error calculation Source-wise

%             ax = zeros(Nsweep,1);
            for i = 1:Nerr
                figure(50+i);
                title(obj.optErrElements{i},'position',[Npar/2,1.03,0]);
                for j = 1:Nsweep

                    y1 = par_Mspace(:,j,i); % (npar,nsweep,nerr)
                    y2 = par_Cspace(:,j,i);
                    x1 = (1:1:104)';
                    Mlines = [x1 x1 y1 zeros(size(x1))];

                    Mlines = mat2cell(Mlines, ones(numel(x1),1), [2 2])';
                    Mlines(3,:) = {'b'};
                    subplot(Nsweep,1,j);
                    plot(Mlines{:});
                    hold on;
                    ax = gca;
                    ax.XLim = [0 105];
                    ax.XTick = 1:Npar;
                    ax.XTickLabel = labels1;
                    ax.XAxisLocation = 'bottom';
                    xline(find(~cellfun(@isempty,labels2)),'--k','linewidth',0.4);

                    if isnan(nonzeros(y1))                        
                        txt = ['  Sweep ' num2str(j) '  (Nominal values)'];                         
                    else
                        txt = ['  Sweep ' num2str(j)];                         
                    end
                    text(max(ax.XTick)+1,(max(abs(ax.YTick))-min(abs((ax.YTick))))/2,txt,interpreter='none');
                    text(ax.XTick,ones(length(ax.XTick),1).*(max(ax.YTick)-0.05) ...
                        ,labels2,'color','r',fontsize=10,fontweight='bold',interpreter='none');
                end
            end
% *****************************************************
            % Plotting error distance vs delta temp with and without parameters affecting error fucntion
            for ii = 1:Nerr
                for jj = 1:Nsweep
                    y = squeeze(Tdelta(:,jj,ii));
                    x = squeeze(errMagVals(:,jj,ii));
                    x_ = squeeze(errMagVals_(:,jj,ii));
                    x1 = squeeze(errComplexVals(:,jj,ii));
                    x1_ = squeeze(errComplexVals_(:,jj,ii));
                    figure(333)
                    subplot(3,4,ii)
                    sz = 40;
                    scatter(x,y,sz,"b");
                    hold on; grid on;
                    title([obj.optErrElements{ii}]);
                    sgtitle('Mag err vs delta temp');
                    figure(444)
                    subplot(3,4,ii)
                    scatter(x1,y,sz,"r");
                    hold on; grid on;
                    title([obj.optErrElements{ii}]);
                    sgtitle('Cmplx err vs delta temp');

                    figure(33)
                    subplot(3,4,ii)
                    sz = 40;
                    scatter(x_,y,sz,"b");
                    hold on; grid on;
                    title([obj.optErrElements{ii}]);
                    sgtitle('Mag err vs delta temp w/o parameters affecting the error function');
                    figure(44)
                    subplot(3,4,ii)
                    scatter(x1_,y,sz,"r");
                    hold on; grid on;
                    title([obj.optErrElements{ii}]);
                    sgtitle('Cmplx err vs delta temp w/o parameters affecting the error function');
                end
            end
% *****************************************************
            labels = obj.optStruct.parameterNames;
            for jj = 1:length(obj.optStruct.parameterNames)
                labels{jj} = strrep(labels{jj},'_','\_');
            end

            errRIA_nom = dB20(rms(conv(10.^(errNomMag./20),10.^(errNomComplex./20))));
            errFuncNom = obj.errFunc(obj.optStruct.vals);
% *****************************************************
            % plotting sesitive analysis-- parameter variation for specific source
            % affecting temperature calculation
            for ee = 1:Nerr + 1
                errPlot = ee;
                figure
                grid on, hold on
                if errPlot > Nerr
                    yline(errFuncNom,'b');yline(errRIA_nom,'k');
                    plot(repmat(1:Npar,Nsweep,1),errFuncVals.','b.-');%,repmat(1:Npar,Nsweep,1),errRIAVals.','k.-');
                    title('Error source: obj.errFunc');
                else

                    subplot(2,1,1)
                    grid on, hold on

                    errM = reshape([errMagVals(:,:,errPlot)],Npar,Nsweep);
                    pM = yline(errNomMag(errPlot),'b');
                    plot(repmat(1:Npar,Nsweep,1),errM.','b.-')

                    errC = reshape([errComplexVals(:,:,errPlot)],Npar,Nsweep);
                    pC = yline(errNomComplex(errPlot),'r');
                    plot(repmat(1:Npar,Nsweep,1),errC.','r.-')
                    title(['Error source: ',obj.optErrElements{errPlot}])

                    subplot(2,1,2)
                    grid on, hold on
                    Tscale = 1000;
                    T = reshape([Tdelta(:,:,errPlot)],Npar,Nsweep).*Tscale;
                    plot(repmat(1:Npar,Nsweep,1),T.','b.-')
                    ylabel('T_\Delta (mK)')
                end
                for ss = 1:2
                    if errPlot <= Nerr
                        subplot(2,1,ss)
                    elseif ss == 2
                        break;
                    end
                    xtickangle(90);
                    xticks(1:length(obj.optStruct.parameterNames));
                    xticklabels(labels)
                    xlim([0,length(obj.optStruct.parameterNames)]+0.5)
                    xlineVals = find(obj.optStruct.parameterIndex == 1)-0.5;
                    xline(xlineVals,'k--',strrep(obj.optVectElements,'_','\_'),'LabelOrientation','horizontal')
                    legend([pM,pC],{'Magnitude','Complex Distance'})
                end
            end

%             delete(h);
%             keyboard
% *****************************************************
        end


        % Output
        function writeTouchStone(obj,path)
            % writeTouchStone writes the different element models to touchstone files in the folder: path

            if nargin < 2 || isempty(path), path = [pwd,'\REACHcal_snp_',char(datetime('now','format','yyyyMMdd''T''HHmmss'))]; end

            if ~isequal(path(end),'\'), path = [path,'\']; end

            [SUCCESS,MESSAGE] = mkdir(path);
            if SUCCESS == 0, error(MESSAGE); end

            for oo = 1:numel(obj.outputElements)
                oe = obj.outputElements{oo};
                Nout = 2;
                if oe(1) == 'r', Nout = 1; end
                obj.(oe).network.writeTouchStone([path,oe],Nout);
            end
        end

        % Plotting
        function plotCablePars(obj,cVals,cUnitScales)
            % PLOTCABLEPARS Plots the requested cable parameters over frequency

            [Z0,L,~,eps_r,tan_delta,r_prime] = getCablePars(obj,cVals,cUnitScales);

            figure
            subplot 411
            if length(Z0) == 1, Z0 = ones(1,obj.Nf).*Z0; end
            plot(obj.freq,Z0,'k'), grid on
            ylabel('Z_0 (\Omega)')
            title(['L = ',num2str(L),' m'])

            subplot 412
            if length(eps_r) == 1, eps_r = ones(1,obj.Nf).*eps_r; end
            plot(obj.freq,eps_r,'k'), grid on
            ylabel('\epsilon_r')

            subplot 413
            if length(tan_delta) == 1, tan_delta = ones(1,obj.Nf).*tan_delta; end
            plot(obj.freq,tan_delta,'k'), grid on
            ylabel('tan(\delta)')

            subplot 414
            if length(r_prime) == 1, r_prime = ones(1,obj.Nf).*r_prime; end
            plot(obj.freq,r_prime,'k'), grid on
            ylabel("R' (\Omega/m)")
        end

        %         function plotSourceModels(obj)
        %             % PLOTSOURCEMODELS plots all the current source models with measured data
        %
        %             Svect = [obj.Sr36,obj.Sr27,obj.Sr69,obj.Sr91];
        %             measVect = {obj.S11_meas_c12r36,obj.S11_meas_c12r27,obj.S11_meas_c12r69,obj.S11_meas_c12r91};
        %             nameVect = {'r36','r27','r69','r91'};
        %
        %             for ii = 1:length(Svect)
        %                 figure
        %                 subplot(2,2,1:2)
        %                 Svect(ii).network.getS.plot11dB
        %                 plot(obj.freq,dB20(measVect{ii}),'r--')
        %                 title(nameVect{ii})
        %                 subplot(2,2,3)
        %                 Svect(ii).network.getS.plot11real
        %                 plot(obj.freq,real(measVect{ii}),'r--')
        %                 subplot(2,2,4)
        %                 Svect(ii).network.getS.plot11imag
        %                 plot(obj.freq,imag(measVect{ii}),'r--')
        %             end
        %         end

        function plotSourceModelComparison(obj,sourceName,includeLab)
            % PLOTSOURCEMODELCOMPARISON plots a the measuered value and model of the specified source
    
            if nargin < 3 || isempty(includeLab), includeLab = true; end

            measVals = obj.(['S11_meas_',sourceName]);
            Smod = obj.(['S',sourceName]);

            style = {'r','k','b'};

            if includeLab
                nSubCols = 4;
                labVals = obj.(['S11_lab_',sourceName]);
                Rmod = obj.(['R',sourceName]);
                Lmod = obj.(['L',sourceName]);

                subplot(2,nSubCols,3:4)
                hold on, grid on
                Rmod.network.getS.plot11dB(style{1})
                plot(obj.freq,dB20(labVals),style{2})
                title(['Lab: ',sourceName])
                subplot(2,nSubCols,7)
                hold on, grid on
                Rmod.network.getS.plot11real(style{1})
                plot(obj.freq,real(labVals),style{2})
                subplot(2,nSubCols,8)
                hold on, grid on
                Rmod.network.getS.plot11imag(style{1})
                plot(obj.freq,imag(labVals),style{2})
            else
                nSubCols = 2;
            end
            subplot(2,nSubCols,1:2)
            hold on, grid on
            Smod.network.getS.plot11dB(style{1})
            plot(obj.freq,dB20(measVals),style{2})
            if includeLab
                Lmod.network.getS.plot11dB(style{3})
            end
            title(['VNA-ref: ',sourceName])
            legend('Model','Measure')
            subplot(2,nSubCols,3+nSubCols-2)
            hold on, grid on
            Smod.network.getS.plot11real(style{1})
            plot(obj.freq,real(measVals),style{2})
            if includeLab
                Lmod.network.getS.plot11real(style{3})
            end
            subplot(2,nSubCols,4+nSubCols-2)
            hold on, grid on
            Smod.network.getS.plot11imag(style{1})
            plot(obj.freq,imag(measVals),style{2})
            if includeLab
                Lmod.network.getS.plot11imag(style{3})
            end
        end

        function plotAllPSD(obj)
            % PLOTALLPSD plots all the PSDs

            for ii = 1:length(obj.sourceNames)
                measStruct = obj.(['PSD_meas_',obj.sourceNames{ii}]);
                subplot(4,4,ii)
                grid on, hold on
                plot(measStruct.freq,measStruct.PSD_source)
                plot(measStruct.freq,measStruct.PSD_load)
                plot(measStruct.freq,measStruct.PSD_noise)
                xlabel('Frequency (MHz)')
                ylabel('Power (linear)')
                title([obj.sourceNames{ii},'; T = ',num2str(obj.(['T_meas_',obj.sourceNames{ii}])), ' K'])
                if ii == 1, legend('Source','Load','Noise'); end
            end
        end

        function plotAllS11(obj,plotFlag,style)
            % PLOTALLS11 plots all the S11 responses on the current figure

            % plotFlag: 1 = model; 2 = measure; 3 = both
% leg = 1;
            if nargin < 2 || isempty(plotFlag), plotFlag = 3; end
            if nargin < 3 || isempty(style), style = 'k'; end
            

            if ~iscell(style), style = {style,style}; end
            if plotFlag == 3, style = {'r','k'}; end


            for ii = 1:length(obj.sourceNames)
                measVals = obj.(['S11_meas_',obj.sourceNames{ii}]);
                row1 = floor((ii-1)/4);
                col1 = mod((ii-1),4);

                subplot(8,8,(2*row1*8 + (1:2) + 2*col1))
                grid on, hold on
                if ii < length(obj.sourceNames)
%                     obj.errorFuncType = 'magDistance';% complexDistance
                    eV = obj.(['err_source_',obj.sourceNames{ii}]);
%                     optVectElements
                    title([obj.sourceNames{ii},'; ',obj.errorFuncType,':Mag dist err = ',num2str(dB20(imag(eV))), ' dB']);
%                     title([obj.sourceNames{ii},'; ',obj.errorFuncType,':Mag dist err = ',num2str(dB20((eV))), ' dB']);
                    Smod = obj.(['S',obj.sourceNames{ii}]);
                end
%                 obj.errorFuncType = "complexDistance";
%                 eV1 = obj.(['err_source_',obj.sourceNames{ii}]);

                if mod(plotFlag,2) ~= 0 && ii < length(obj.sourceNames), Smod.network.getS.plot11dB(style{1}); end
                if plotFlag > 1 , plot(obj.freq,dB20(measVals),style{2});end

                
                xlabel('')
                subplot(8,8,((2*row1+1)*8 + 1 + 2*col1))
                grid on, hold on
                title(['Cmplx dist err = ',num2str(dB20(real(eV)))]);
%                 title(['Cmplx dist err = ',num2str(dB20((eV1)))]);
                if mod(plotFlag,2) ~= 0 && ii < length(obj.sourceNames), Smod.network.getS.plot11real(style{1}); end
                if plotFlag > 1, plot(obj.freq,real(measVals),style{2}); end
                xlabel('')
                subplot(8,8,((2*row1+1)*8 + 2 + 2*col1))
                grid on, hold on
                title(['Cmplx dist err = ',num2str(dB20(real(eV)))]);
                if mod(plotFlag,2) ~= 0 && ii < length(obj.sourceNames), Smod.network.getS.plot11imag(style{1}); end
                if plotFlag > 1, plot(obj.freq,imag(measVals),style{2}); end
                xlabel('')
                sgtitle({'REACH 12-calibrators model vs measured s-parameters',' '});
                
            end

        end

        function plotAllS11ComplexDistance(obj,color)
            % plotAllS11ComplexDistance plots the distance on the complex plane between the model 
            % and measured data (only for the full models - lab source not implemented yet)

            if nargin < 2 || isempty(color), color = 'k'; end

            for ii = 1:length(obj.sourceNames)-1
                subplot(3,4,ii)
                grid on, hold on

                meas_ = obj.(['S11_meas_',obj.sourceNames{ii}]);
                sM = obj.(['S',obj.sourceNames{ii}]);
                mod_ = sM.network.getS.d11;
                y = abs(meas_(:) - mod_(:));
                mean_ = dB20(mean(y));
                norm_ = dB20(vecnorm(y)./obj.Nf);
                plot(obj.freq,dB20(y),color), grid on, hold on
                yline(mean_,[color,'--'])
                yline(norm_,[color,'-.'])
                if ii == 1
                    legend('Total distance','Mean','Norm','Location','Best')
                end
                xlabel('Frequency (MHz)')
                ylabel('Error distance (dB)')
                title(obj.sourceNames{ii})
            end
        end

        function plotAllGains(obj,color)
            % plotAllGains plots all the source available gains to the reference plain

            if nargin < 2 || isempty(color), color = 'k'; end

            for ii = 1:length(obj.sourceNames)-1
                subplot(3,4,ii)
                grid on, hold on

                y = obj.(['G',obj.sourceNames{ii}]);
                plot(obj.freq,y,color), grid on, hold on
                xlabel('Frequency (MHz)')
                ylabel('Available Gain (linear)')
                title(obj.sourceNames{ii})
            end
        end

        function plotAllTemperatures(obj,color,legends,custom)
            % plotAllTemperatures plots all the source temperatures at the reference plain
            % custom -> Calibrator chains with less no. of elements or selective elements 
            % can be plotted (always define custom calibrator chains from source side)
            cTemp_indx = 0;
            if nargin < 2 || isempty(color), color = 'k';  end
            if nargin < 3 || isempty(legends), legends = {'T_{source}','T_r','T_{cab}'}; end
            if nargin > 3 && ~isempty(custom)
                obj.customTemp_Flag = true;
                if nnz(ismember(custom,obj.Temp_el)) == length(custom) && nnz(ismember(custom,obj.Temp_el(1:12))) == 1
                    cTemp_indx = find(contains(obj.sourceNames,custom(1)));
                    obj.load_indx = find(contains(obj.Temp_el,custom(1)));
                else
                    error('error...custom temp chain is not correct');
                end

            end


            for ii = 1:length(obj.sourceNames)-1
                subplot(3,4,ii)
                grid on, hold on

                [y,Tr,Tcab] = obj.calcSourceTemp(obj.sourceNames{ii});

                if ii == cTemp_indx
                    G = calcSourceGain(obj,[],custom);
                    Tr = obj.(['T_meas_',obj.sourceNames{ii}]);
                    y1 = G.*Tr + (1 - G).*Tcab; 
                    obj.customTemp_Flag = false;
                    plot(obj.freq,y1,'g'), grid on, hold on
                    text(obj.freq(round(length(obj.freq)/2)),y1(round(length(y1)/2)),'  \leftarrow Custom CAL chain')
                end


                plot(obj.freq,y,color), grid on, hold on
                xlabel('Frequency (MHz)')
                ylabel('Source Temperature (K)')
                title(obj.sourceNames{ii})

%                 yline(Tr,'r')
%                 yline(Tcab,'b')
%                 legends
%                 if ii == 1 , legend(,'Location','Best'); end
                ax = gca;
                if ii == 1, legend(ax,legends,'Location','Best'); end


            end
        end

        function plotAllParameters(obj,style)
            % PLOTALLPARAMETERS plots the full set of normalised model parameters

            if nargin < 2 || isempty(style), style = 'k*'; end

            y = (obj.optStruct.vals - obj.optStruct.min)./(obj.optStruct.max - obj.optStruct.min);
            y = y.*obj.optStruct.optFlag;
            plot(y,style), grid on, hold on
            plot(find( obj.optStruct.optFlag== 0),0,'b o');

            xTicLab = cell(1,sum(obj.optVect_Nvars));
            for ii = 1:obj.optVect_Ne
                if mod(ii,2) == 0, cScale = 0.8; else, cScale = 0.2; end
                x_start = sum(obj.optVect_Nvars(1:ii-1)) + 0.5;
                x_stop = sum(obj.optVect_Nvars(1:ii)) + 0.5;
                p = patch([x_start x_stop x_stop x_start],[0 0 1 1],[1 1 1].*cScale);
                p.FaceAlpha = 0.3;
                p.EdgeColor = 'none';

                switch lower(obj.optVectElements{ii}(1))
                    case 'r'
                        labels = obj.rVarNames;
                    case {'m','s','l'}
                        labels = obj.cShortVarNames;
                    case {'c'}
                        labels = obj.cVarNames;
                    case 'a'
                        labels = obj.adaptVarNames;
                end

                for jj = 1:length(labels)
                    labels{jj} = strrep(labels{jj},'_','\_');
                end

                xTicLab(x_start+0.5:x_stop-0.5) = labels;

                text(x_start+0.5,1.02,strrep(obj.optVectElements{ii},'_','\_'));
            end

            ylabel('Normalised Value')

            xtickangle(90);
            xticks(1:sum(obj.optVect_Nvars));
            xticklabels(xTicLab);
            hold off;
        end

        function printOptElementVals(obj)
            % PRINTOPTELEMENTVALS prints the optElement values to the screen

            for ii = 1:length(obj.optVectElements)
                optEl = obj.(obj.optVectElements{ii});
                disp([obj.optVectElements{ii},'.vals = [',num2str(optEl.vals),'];'])

            end
        end

    end

    methods (Access = private)

        % Fitting error functions
        function err = err_RIA(obj,S11meas,S11model)
            % err_RIA combines complex and magnitude difference error

            obj.errorFuncScale = 'lin';
            err_complex = obj.errFuncNormHandle(obj.err_complexDistance(S11meas,S11model));
            err_mag = obj.errFuncNormHandle(obj.err_magDistance(S11meas,S11model));
            err = complex(err_complex,err_mag);

        end

        function err = err_complexDistance(obj,y_meas,y_model)
            % err_complexDistance provides the complex difference-based error
            
            dist = abs(y_meas(:) - y_model(:));
%             dist = abs(real(y_meas(:)) - real(y_model(:))); % real error distance
            err = obj.errFuncNormHandle(dist);
            err = obj.errFuncScaleHandle(err);
        end

        function err = err_magDistance(obj,y_meas,y_model)
            % err_magDistance provides the magnitude difference error
            
            dist = abs(abs(y_meas(:)) - abs(y_model(:)));
%             dist = abs(imag(y_meas(:)) - imag(y_model(:))); % imaginary error distance
            err = obj.errFuncNormHandle(dist);
            err = obj.errFuncScaleHandle(err);
        end

        % Element construction
        function [Z0,L,freq,eps_r,tan_delta,r_prime] = getCablePars(obj,c_vals,c_unitScales)
            % GETCABLEPARS Calculates the frequency dependent Tline parameters

            cVals = c_vals.*c_unitScales;

            Z0 = cVals(1);
            L = cVals(2);
            freq = obj.freqHz;

            fn = (freq - min(freq))./(max(freq) - min(freq));
            eps_r = cVals(3).*fn + cVals(4);
            tan_delta = cVals(5).*fn + cVals(6);
            r_prime = cVals(7).*fn + cVals(8);
        end

        function cable = buildCableStruct(obj,c_vals,c_unitScales,c_max,c_min,c_optFlag)
            % BUILDCABLESTRUCT builds a general cable structure

            if nargin == 2 % Special case for using the measure cable data
                cable.network = obj.(['S_meas_',c_vals]);
                nPar = length(obj.([c_vals,'_vals']));
                [cable.vals,cable.unitScales,cable.max,cable.min] = deal(nan(1,nPar));
                cable.optFlag = false(1,nPar);
            else
                [Z0,L,f,eps_r,tan_delta,r_prime] = obj.getCablePars(c_vals,c_unitScales);
                cable.network = TwoPort.Tline(Z0,L,f,eps_r,tan_delta,r_prime);
                cable.network = cable.network.freqChangeUnit(obj.freqUnit);
                cable.vals = c_vals;
                cable.unitScales = c_unitScales;
                cable.max = c_max;
                cable.min = c_min;
                cable.optFlag = c_optFlag;
            end
        end

        function r = buildRstruct(obj,r_vals,r_unitScales,r_max,r_min,r_optFlag)
            % BUILDRSTRUCT builds a general resistor structure

            r.vals = r_vals;
            r.unitScales = r_unitScales;
            r.max = r_max;
            r.min = r_min;
            r.optFlag = r_optFlag;
            parVals = r.vals.*r.unitScales;
            r.network = TwoPort.PI_CLC(parVals(1),parVals(2),parVals(3),obj.freqHz,[],parVals(4));
            r.network = r.network.freqChangeUnit(obj.freqUnit);
        end

        function sc = buildShortCableStruct(obj,sc_vals,sc_unitScales,sc_max,sc_min,sc_optFlag)
            % BUILDMSSTRUCT builds a general short cable structure

            sc.vals = sc_vals;
            sc.unitScales = sc_unitScales;
            sc.max = sc_max;
            sc.min = sc_min;
            sc.optFlag = sc_optFlag;
            parVals = sc.vals.*sc.unitScales;
            sc.network = TwoPort.Tline(parVals(1),parVals(2),obj.freqHz,parVals(3),parVals(4),parVals(5));
            sc.network = sc.network.freqChangeUnit(obj.freqUnit);
        end

        function a = buildAdaptStruct(obj,a_vals,a_unitScales,a_max,a_min,a_optFlag)
            % BUILDADAPTSTRUCT builds an adaptor struct

            a.vals = a_vals;
            a.unitScales = a_unitScales;
            a.max = a_max;
            a.min = a_min;
            a.optFlag = a_optFlag;
            parVals = a.vals.*a.unitScales;
            a.network = TwoPort.PI_CLC(parVals(1),parVals(2),parVals(3),obj.freqHz);
            a.network = a.network.freqChangeUnit(obj.freqUnit);
        end

        function S_struct = buildSourceStruct(obj,elementNameVect)
            % BUILDSOURCESTRUCT builds a general source structure

            S_struct.elements = elementNameVect;
            Ne = length(S_struct.elements);
            % First get the number of variables in the cascade
            S_struct.Nvars = zeros(1,Ne);
            networkVect = TwoPort.empty(0,Ne);
            for ii = 1:Ne
                S_struct.Nvars(ii) = length(obj.(S_struct.elements{ii}).vals);
                networkVect(ii) = obj.(S_struct.elements{ii}).network;
            end
            % Run the loop again, and allocate the long vectors
            valMat = zeros(5,sum(S_struct.Nvars));
            for ii = 1:Ne
                element_ = obj.(S_struct.elements{ii});
                valMat(:,(sum(S_struct.Nvars(1:(ii-1)))+1):sum(S_struct.Nvars(1:ii))) = [element_.vals; ...
                    element_.unitScales; ...
                    element_.max; ...
                    element_.min; ...
                    element_.optFlag];
            end
            S_struct.network = cascade(networkVect);
            S_struct.network = S_struct.network.getS([],networkVect(Ne).Zport2);
            S_struct.vals = valMat(1,:);
            S_struct.unitScales = valMat(2,:);
            S_struct.max = valMat(3,:);
            S_struct.min = valMat(4,:);
            S_struct.optFlag = valMat(5,:);

        end

        function L_struct = buildLabSourceStruct(obj,elementName)
            % BUILDLABSOURCESTRUCT builds a general lab source structure
            % The labSource is the measured lab values with mts and sr_mtsj1 added 

            L_struct.elements = {'ps','sr_mtsj1','mts','la',elementName};
            Ne = length(L_struct.elements);
            % First get the number of variables in the cascade
            L_struct.Nvars = zeros(1,Ne);
            networkVect = TwoPort.empty(0,Ne);
            for ii = 1:Ne-1
                L_struct.Nvars(ii) = length(obj.(L_struct.elements{ii}).vals);
                networkVect(ii) = obj.(L_struct.elements{ii}).network;
                if strcmp(L_struct.elements{ii},'la'), networkVect(ii) = inv(networkVect(ii)); end  % De-embed the adaptor by inverting the ABCD matrix
            end
            % Run the loop again, and allocate the long vectors
            valMat = zeros(5,sum(L_struct.Nvars));
            for ii = 1:Ne-1
                element_ = obj.(L_struct.elements{ii});
                valMat(:,(sum(L_struct.Nvars(1:(ii-1)))+1):sum(L_struct.Nvars(1:ii))) = [element_.vals; ...
                    element_.unitScales; ...
                    element_.max; ...
                    element_.min; ...
                    element_.optFlag];
            end
            L_struct.network = cascade(networkVect(1:end));
%             S11load = obj.(['S',elementName]).network.getS.d11;
            S11load = obj.(['S11_lab_',elementName]);
            Zload = 50*(1 + S11load)./(1 - S11load);
            L_struct.network = L_struct.network.getS([],Zload);
            L_struct.vals = valMat(1,:);
            L_struct.unitScales = valMat(2,:);
            L_struct.max = valMat(3,:);
            L_struct.min = valMat(4,:);
            L_struct.optFlag = valMat(5,:);

        end

        % Gain and noise temperature construction
        function G = calcSourceGain(obj,sourceName,custom)
            % CALCSOURCEGAIN calculates the transducer gain of the specified source
            % custom = Gain calculation for custom calibrator chains


            % Select constant reference impedance
            Zport = 50;  % Everything in a 50 Ohm environment
            
            if nargin > 2 && ~isempty(custom)
                for i = 1:length(custom)
                    temp_2 = obj.(custom{i}).network.getS(Zport,Zport);
                    if i > 1
                        C = cascade([temp_1, temp_2]);
                        temp_1 = C;
                    else
                        temp_1 = temp_2;
                        if length(custom) == 1, C = temp_2;end
                    end

                end
                % Just keep real part of the termination resistor
                rReal = obj.(obj.Temp_el{obj.load_indx}).network.Zport2;
                Gam_R = (rReal - Zport)./(rReal + Zport);       % Just the real part is kept
            else
                [cableName,loadName] = REACHcal.splitSourceName(sourceName);

                switch cableName
                    case 'c12'
                        c = obj.c2.network;
                        loadMS = obj.ms3.network;
                    case 'c25'
                        c = obj.c10.network;
                        loadMS = obj.ms4.network;
                    otherwise
                        [c,loadMS] = deal(TwoPort.empty(1,0));
                end


                % Just keep real part of the termination resistor
                rReal = obj.(loadName).network.Zport2;
                Gam_R = (rReal - Zport)./(rReal + Zport);       % Just the real part is kept

                % Cable (between resistive load and reference plane) - include load reactive network, MS3/4, cable, MS1, and MTS semi-rigid
                rReactive = obj.(loadName).network;
                rReactive = rReactive.getS(Zport,Zport);

                if ~isempty(loadMS), loadMS = loadMS.getS(Zport,Zport); end
                if ~isempty(c), c = c.getS(Zport,Zport); end
                MS1 = obj.ms1.network.getS(Zport,Zport);
                SR = obj.sr_mtsj2.network.getS(Zport,Zport);
                C = cascade([rReactive,loadMS,c,MS1,SR]);
            end
            C = C.getS(Zport,Zport);
            S21 = C.d21;
            S11 = C.d11;

            % Source reflection
            Gam_S = C.d22 + (C.d12.*C.d21.*Gam_R)./(1 - C.d11.*Gam_R);

            % String it all up
            G = abs(S21).^2.*(1 - abs(Gam_R).^2)./(abs(1 - S11.*Gam_R).^2.*(1 - abs(Gam_S).^2));
        end

        function [T,Tr,Tcab] = calcSourceTemp(obj,sourceName)
            % CALCSOURCETEMP calculates the effective temperature of a specified source at the reference plane

            
            [cableName] = REACHcal.splitSourceName(sourceName);

            switch cableName
                case 'c12'
                    Tcab = obj.T_meas_c2;
                case 'c25'
                    Tcab = obj.T_meas_c10;
                otherwise
                    Tcab = obj.T_meas_ms1;
            end

            G = obj.(['G',sourceName]);
            Tr = obj.(['T_meas_',sourceName]);
            T = G.*Tr + (1 - G).*Tcab;  
        end

        
    end
               
    methods (Static = true, Access = private)

        function [cableName,loadName] = splitSourceName(sourceName)
            % SPLITSOURCENAME splits the source name into a cableName and loadName

            if strncmp(sourceName,'c12',3)
                cableName = 'c12';
                loadName = sourceName(4:end);
            elseif strncmp(sourceName,'c25',3)
                cableName = 'c25';
                loadName = sourceName(4:end);
                switch loadName
                    case 'open'
                        loadName = 'rOpen';
                    case 'short'
                        loadName = 'rShort';
                    otherwise
                        % Do nothing;
                end
            else
                cableName = 'No cable';
                switch sourceName
                    case 'cold'
                        loadName = 'rCold';
                    case 'hot'
                        loadName = 'rHot';
                    otherwise
                        loadName = sourceName;
                end
            end
        end


    end

end