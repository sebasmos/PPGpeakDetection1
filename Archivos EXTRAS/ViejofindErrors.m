
function [ErroresTotales] = findErrors(mediamuestral,Activity1,Activity2,Activity3,Activity4,Activity5,Activity6,...
    CleanedSignal1,CleanedSignal2,CleanedSignal3,CleanedSignal4,CleanedSignal5,CleanedSignal6,...
    Fs,MinPeakWidthRest1,MinPeakWidthRun_2,MinPeakWidthRun_3,MinPeakWidthRun_4,MinPeakWidthRun_5,MinPeakWidthRest6,...
    MaxWidthRest1,MaxWidthRun2,MaxWidthRun3,MaxWidthRun4,MaxWidthRun5,MaxWidthRest6,...
    ProminenceInRest1,ProminenceRun2,ProminenceRun3,ProminenceRun4,ProminenceRun5,ProminenceInRest6,...
    MinDistRest1,MinDistRun2,MinDistRun3,MinDistRun4,MinDistRun5,MinDistRest6,...
    ecgName,MinHeightECGRest1,MinHeightECGRest6,...
    MinHeightECGRun2,MinHeightECGRun3,MinHeightECGRun4,MinHeightECGRun5,minDistRest1,minDistRest6,...
    minDistRun2,minDistRun3,minDistRun4,minDistRun5,minDD)
%% ADD DATABASE
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\Training_data\db')
% ADD FUNCTION compareBPM  
addpath('C:\MATLAB2018\MATLAB\mcode\Tesis\IEEE-Processing-Cup\competition_data\Training_data\NoiseProofs')
%%
% 1. ORIGINAL en reposo vs sin ruido
[PKS1Original,LOCS1Original] = GetPeakPoints(Activity1,...
    Fs,MinPeakWidthRest1,MaxWidthRest1,ProminenceInRest1,MinDistRest1);
[PKS1Cleaned,LOCS1Cleaned] = GetPeakPoints(CleanedSignal1,Fs,MinPeakWidthRest1,...
    MaxWidthRest1,ProminenceInRest1,MinDistRest1);
% 2. CORRIENDO 1min se�al original vs sin ruido
[PKS2Original,LOCS2Original] = GetPeakPoints(Activity2,...
    Fs,MinPeakWidthRun_2,MaxWidthRun2,ProminenceRun2,MinDistRun2);
[PKS2Cleaned,LOCS2Cleaned] = GetPeakPoints(CleanedSignal2,Fs,MinPeakWidthRun_2,...
    MaxWidthRun2,ProminenceRun2,MinDistRun2);
% 3. CORRIENDO 1min se�al original vs sin ruido
[PKS3Original,LOCS3Original] = GetPeakPoints(Activity3,...
    Fs,MinPeakWidthRun_3,MaxWidthRun3,ProminenceRun3,MinDistRun3);
[PKS3Cleaned,LOCS3Cleaned] = GetPeakPoints(CleanedSignal3,Fs,MinPeakWidthRun_3,...
    MaxWidthRun3,ProminenceRun3,MinDistRun3);
% 4. CORRIENDO 1min se�al original vs sin ruido
[PKS4Original,LOCS4Original] = GetPeakPoints(Activity4,...
    Fs,MinPeakWidthRun_4,MaxWidthRun4,ProminenceRun4,MinDistRun4);
[PKS4Cleaned,LOCS4Cleaned] = GetPeakPoints(CleanedSignal4,Fs,MinPeakWidthRun_4,...
    MaxWidthRun4,ProminenceRun4,MinDistRun4);
% 5. CORRIENDO 1min se�al original vs sin ruido
[PKS5Original,LOCS5Original] = GetPeakPoints(Activity5,...
    Fs,MinPeakWidthRun_5,MaxWidthRun5,ProminenceRun5,MinDistRun5);
[PKS5Cleaned,LOCS5Cleaned] = GetPeakPoints(CleanedSignal5,Fs,MinPeakWidthRun_5,...
    MaxWidthRun5,ProminenceRun5,MinDistRun5);
% 6. REST 30s se�al original vs sin ruido
[PKS6Original,LOCS6Original] = GetPeakPoints(Activity6,...
    Fs,MinPeakWidthRest6,MaxWidthRest6,ProminenceInRest6,MinDistRest6);
[PKS6Cleaned,LOCS6Cleaned] = GetPeakPoints(CleanedSignal6,Fs,MinPeakWidthRest6,...
    MaxWidthRest6,ProminenceInRest6,MinDistRest6);

%% Error using HeartBeats from findpeaks
ErrorFindP1 = 100*abs(length(LOCS1Cleaned)-length(LOCS1Original))./length(LOCS1Original);
ErrorFindP2 = 100*abs(length(LOCS2Cleaned)-length(LOCS2Original))./length(LOCS2Original);
ErrorFindP3 = 100*abs(length(LOCS3Cleaned)-length(LOCS3Original))./length(LOCS3Original);
ErrorFindP4 = 100*abs(length(LOCS4Cleaned)-length(LOCS4Original))./length(LOCS4Original);
ErrorFindP5 = 100*abs(length(LOCS5Cleaned)-length(LOCS5Original))./length(LOCS5Original);
ErrorFindP6 = 100*abs(length(LOCS6Cleaned)-length(LOCS6Original))./length(LOCS6Original);
ErrorFromFindPeaks = [ErrorFindP1 ErrorFindP2 ErrorFindP3 ErrorFindP4 ErrorFindP5 ErrorFindP6];
%% Error from BPM 
% bpm stores the bpm in the matrix 6x12, where 1-6 represents the type of
% activity and 1-12 represents the number of realizations. Since the bpm is
% taken from 8 windows size and is overlapping every 6s, there are 2
% effective seconds and therefore, the activity 1 (Rest per 30s)
% corresponds to 15 effective seconds
bpm = CompareBPM();
realizacion = 1;
% PEAKS IN PPG SIGNAL Separate peaks from findpeaks detection 
FindPeaksCleaned1 = length(LOCS1Cleaned);
FindPeaksCleaned2 = length(LOCS2Cleaned);
FindPeaksCleaned3 = length(LOCS3Cleaned);
FindPeaksCleaned4 = length(LOCS4Cleaned);
FindPeaksCleaned5 = length(LOCS5Cleaned);
FindPeaksCleaned6 = length(LOCS6Cleaned);
% For computational reasons, we separate the 30s-activities
bpm1 = bpm(1,realizacion)./2;
bpm6 = bpm(6,realizacion)./2;
%
EBPM1 = 100*abs(FindPeaksCleaned1-bpm1)./bpm1;
EBPM2 = 100*abs(FindPeaksCleaned2-bpm(2,realizacion))./bpm(2,realizacion);
EBPM3 = 100*abs(FindPeaksCleaned3-bpm(3,realizacion))./bpm(3,realizacion);
EBPM4 = 100*abs(FindPeaksCleaned4-bpm(4,realizacion))./bpm(4,realizacion);
EBPM5 = 100*abs(FindPeaksCleaned5-bpm(5,realizacion))./bpm(5,realizacion);
EBPM6 = 100*abs(FindPeaksCleaned6-bpm6)./bpm6;


ErrorFromBPM = [EBPM1 EBPM2 EBPM3 EBPM4 EBPM5 EBPM6];


%% PROOF 2: ECG peaks detection
% Random sample signal: 
ecg = load('DATA_01_TYPE02.mat');
ecgSig = ecg.sig;
ecgFullSignal = ecgSig(1,(1:length(mediamuestral)));% match sizes 
% Normalize with min-max method
ecgFullSignal = (ecgFullSignal-128)./255;
ecgFullSignal = (ecgFullSignal-min(ecgFullSignal))./(max(ecgFullSignal)-min(ecgFullSignal));
% Squared signal to 
ecgF = (abs(ecgFullSignal)).^2;
t = (0:length(ecgFullSignal)-1)/Fs;   

[ECG1Peaks,ECG1Locs] = GetECGPeakPoints(ecgF(1,(1:3750)),MinHeightECGRest1,minDistRest1);
[ECG2Peaks,ECG2Locs] = GetECGPeakPoints(ecgF(1,(3751:11250)),MinHeightECGRun2,minDistRun2);
[ECG3Peaks,ECG3Locs] = GetECGPeakPoints(ecgF(1,(11251:18750)),MinHeightECGRun3,minDistRun3);
[ECG4Peaks,ECG4Locs] = GetECGPeakPoints(ecgF(1,(18751:26250)),MinHeightECGRun4,minDistRun4);
[ECG5Peaks,ECG5Locs] = GetECGPeakPoints(ecgF(1,(26251:33750)),MinHeightECGRun5,minDistRun5);
[ECG6Peaks,ECG6Locs] = GetECGPeakPoints(ecgF(1,(33751:end)),MinHeightECGRest6,minDistRest6);

peaksECG1 = length(ECG1Locs);
peaksECG2 = length(ECG2Locs);
peaksECG3 = length(ECG3Locs);
peaksECG4 = length(ECG4Locs);
peaksECG5 = length(ECG5Locs);
peaksECG6 = length(ECG6Locs);

ECGERROR1 = 100*abs(FindPeaksCleaned1-peaksECG1)./peaksECG1;
ECGERROR2 = 100*abs(FindPeaksCleaned2-peaksECG2)./peaksECG2;
ECGERROR3 = 100*abs(FindPeaksCleaned3-peaksECG3)./peaksECG3;
ECGERROR4 = 100*abs(FindPeaksCleaned4-peaksECG4)./peaksECG4;
ECGERROR5 = 100*abs(FindPeaksCleaned5-peaksECG5)./peaksECG5;
ECGERROR6 = 100*abs(FindPeaksCleaned6-peaksECG6)./peaksECG6;
ErrorFromECG = [ECGERROR1 ECGERROR2 ECGERROR3 ECGERROR4 ECGERROR5 ECGERROR6];

FindPeaksOriginalPeaks = [length(LOCS1Original) length(LOCS2Original) length(LOCS3Original) length(LOCS4Original) length(LOCS5Original) length(LOCS6Original)]

FindPeakDenoisedPeaks = [length(PKS1Cleaned) length(PKS2Cleaned) length(PKS3Cleaned) length(PKS4Cleaned) length(PKS5Cleaned) length(PKS6Cleaned)] 

showBPMPeaks = [bpm1 bpm(2,realizacion) bpm(3,realizacion) bpm(4,realizacion) bpm(5,realizacion) bpm6]

showECGPeaks = [peaksECG1 peaksECG2 peaksECG3 peaksECG4 peaksECG5 peaksECG6  ]
disp('CALCULO % ERRORES: Fila 1 (FindPeaks), Fila 2 (BPM), Fila 3 (ECG)')
ErroresTotales = [ErrorFromFindPeaks;ErrorFromBPM;ErrorFromECG]
end