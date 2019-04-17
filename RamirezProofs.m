%% Get and save signals in 'Realizaciones'

%% PRUEBA RAPIDA: RESTAR DE SE�AL 1
j = 1; %IMPORTANT!!! change this parameter to obtain errors from 
          %different realizations

%% Parameters for findpeaks Function
% PARAMETERS FOR PPG SIGNAL
% MinPeakWidth
MinPeakWidthRest1 = 0.11;
MinPeakWidthRun_2 = 0.01;
MinPeakWidthRun_3 = 0.07;
MinPeakWidthRun_4 = 0.07;
MinPeakWidthRun_5 = 0.07;
MinPeakWidthRest6 = 0.05;
% MaxWidthPeak in PPG
MaxWidthRest1 = 0.5;
MaxWidthRun2 = 0.6;
MaxWidthRun3 = 0.5;
MaxWidthRun4 = 0.8;
MaxWidthRun5 = 0.8;
MaxWidthRest6 = 1.5;
% Prominence in PPG
ProminenceInRest1 = 0.009;
ProminenceRun2 = 0.049;
ProminenceRun3 = 0.038;
ProminenceRun4 = 0.04;
ProminenceRun5 = 0.04;
ProminenceInRest6 = 0.01;
% Min peak Distance in PPG
MinDistRest1 = 0.3;
MinDistRun2 = 0.1;
MinDistRun3 = 0.1;
MinDistRun4 = 0.15;
MinDistRun5 = 0.1;
MinDistRest6 = 0.2;
%% PARAMETERS IN ECG SIGNAL
% Min Height in ECG
MinHeightECGRest1 = 0.025;
MinHeightECGRun2  = 0.025;
MinHeightECGRun3  = 0.04;
MinHeightECGRun4  = 0.04;
MinHeightECGRun5  = 0.04;
MinHeightECGRest6 = 0.03;
%Min Dist in ECG
minDistRest1  = 0.6;
minDistRun2   = 0.5;
minDistRun3   = 0.2;
minDistRun4   = 0.2;
minDistRun5   = 0.2;
minDistRest6  = 0.2;
%Max Width in ECG
maxWidthRest1  = 0.05;
maxWidthRun2   = 0.05;
maxWidthRun3   = 0.05;
maxWidthRun4   = 0.05;
maxWidthRun5   = 0.05;
maxWidthRest6  = 0.05;


%% EXTRACT THE SIGNALS
for k = 1:12
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'DATA_'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        PPGdatasetSignals(k,:) = a.sig(2,(1:35989));
        ECGdatasetSignals(k,:)=a.sig(1,(1:35989));
    else
        labelstring = int2str(k);
        word = strcat({'DATA_0'},labelstring,{'_TYPE02.mat'});
        a = load(char(word));
        PPGdatasetSignals(k,:) = a.sig(2,(1:35989));
        ECGdatasetSignals(k,:)=a.sig(1,(1:35989));
    end
end
%% EXTRACT THE SIGNAL TO OBTAIN LOWFREQUENCY COMPONENTS
[mediamuestral,TamRealizaciones]=GetAveragedNoise();
%% ECG PEAKS EXTRACTION
% Sample Frequency
    Fs = 125;
%Convert to physical values: According to timesheet of the used wearable
ecgFullSignal = (ECGdatasetSignals-128)./255;
s2 = (PPGdatasetSignals-128)/(255);

% Normalize the entire signal of all realizations.
for k=1:12
    sNorm(k,:) = (s2(k,:)-min(s2(k,:)))/(max(s2(k,:))-min(s2(k,:)));
    ecgNorm(k,:) = (ecgFullSignal(k,:)-min(ecgFullSignal(k,:)))./(max(ecgFullSignal(k,:))-min(ecgFullSignal(k,:)));
end
%% Separate Activities
Activity1=sNorm(:,(1:3750));
Activity2=sNorm(:,(3751:11250));
Activity3=sNorm(:,(11251:18750));
Activity4=sNorm(:,(18751:26250));
Activity5=sNorm(:,(26251:33750));
Activity6=sNorm(:,(33751:end));
ActivityECG1=ecgNorm(:,(1:3750));
ActivityECG2=ecgNorm(:,(3751:11250));
ActivityECG3=ecgNorm(:,(11251:18750));
ActivityECG4=ecgNorm(:,(18751:26250));
ActivityECG5=ecgNorm(:,(26251:33750));
ActivityECG6=ecgNorm(:,(33751:end));

%% Clean each ECG activity

for k=1:12
    CleanedActivityECG1(k,:)=DenoiseECG(ActivityECG1(k,:));
    CleanedActivityECG2(k,:)=DenoiseECG(ActivityECG2(k,:));
    CleanedActivityECG3(k,:)=DenoiseECG(ActivityECG3(k,:));
    CleanedActivityECG4(k,:)=DenoiseECG(ActivityECG4(k,:));
    CleanedActivityECG5(k,:)=DenoiseECG(ActivityECG5(k,:));
    CleanedActivityECG6(k,:)=DenoiseECG(ActivityECG6(k,:));
end

%% Separate noise for PPG with its correspondent activity.
%ESTA FUNCION ESTA EN SpectrumAnalysIs
ShortedBP=Ramirez_Model();
Noise1 = ShortedBP(1:3750);
Noise2 = ShortedBP(3751:11250);
Noise3 = ShortedBP(11251:18750);
Noise4 = ShortedBP(18751:26250);
Noise5 = ShortedBP(26251:33750);
Noise6 = ShortedBP(33751:end);
%% Detrend noise by activities.
nRest = 10;
nRun = 10;
WandererBaseline1=Detrending(mediamuestral(1:3750),nRest);
WandererBaseline2=Detrending(mediamuestral(3751:11250),nRun);
WandererBaseline3=Detrending(mediamuestral(11251:18750),nRun);
WandererBaseline4=Detrending(mediamuestral(18751:26250),nRun);
WandererBaseline5=Detrending(mediamuestral(26251:33750),nRun);
WandererBaseline6=Detrending(mediamuestral(33751:end),nRest);
%%
% Zero centered noise extraction
TotalGaussianNoise1=Noise1+WandererBaseline1;
TotalGaussianNoise2=Noise2+WandererBaseline2;
TotalGaussianNoise3=Noise3+WandererBaseline3;
TotalGaussianNoise4=Noise4+WandererBaseline4;
TotalGaussianNoise5=Noise5+WandererBaseline5;
TotalGaussianNoise6=Noise6+WandererBaseline6;

% Cleaning signal with model R
    Cleaneds1 = Activity1 - TotalGaussianNoise1;
    Cleaneds2 = Activity2 - TotalGaussianNoise2;
    Cleaneds3 = Activity3 - TotalGaussianNoise3;
    Cleaneds4 = Activity4 - TotalGaussianNoise4;
    Cleaneds5 = Activity5 - TotalGaussianNoise5;
    Cleaneds6 = Activity6 - TotalGaussianNoise6;
        %% ERROR FOR RAMIREZ MODEL
disp('ERRORES CALCULADOS POR MODEL R')
findErrors(Activity1(j,:),Activity2(j,:),Activity3(j,:),Activity4(j,:),Activity5(j,:),Activity6(j,:),...
    Cleaneds1(j,:),Cleaneds2(j,:),Cleaneds3(j,:),Cleaneds4(j,:),Cleaneds5(j,:),Cleaneds6(j,:), ...
    Fs,MinPeakWidthRest1,MinPeakWidthRun_2,MinPeakWidthRun_3,MinPeakWidthRun_4,MinPeakWidthRun_5,MinPeakWidthRest6,...
    MaxWidthRest1,MaxWidthRun2,MaxWidthRun3,MaxWidthRun4,MaxWidthRun5,MaxWidthRest6,...
    ProminenceInRest1,ProminenceRun2,ProminenceRun3,ProminenceRun4,ProminenceRun5,ProminenceInRest6,...
    MinDistRest1,MinDistRun2,MinDistRun3,MinDistRun4,MinDistRun5,MinDistRest6,...
    CleanedActivityECG1(j,:),CleanedActivityECG2(j,:),CleanedActivityECG3(j,:),...
    CleanedActivityECG4(j,:),CleanedActivityECG5(j,:),CleanedActivityECG6(j,:),...
    MinHeightECGRest1,MinHeightECGRun2,MinHeightECGRun3,MinHeightECGRun4,MinHeightECGRun5,MinHeightECGRest6,...
    minDistRest1,minDistRun2,minDistRun3,minDistRun4,minDistRun5,minDistRest6,...
    maxWidthRest1,maxWidthRun2,maxWidthRun3,maxWidthRun4,maxWidthRun5,maxWidthRest6);

%% PRUEBAS PARA SENSIBILIDAD

% 1. PICOS DE LA SEÑAL SIN RUIDO
    [~,LOCS1CleanedR] = GetPeakPoints(Cleaneds1(j,:),Fs,MinPeakWidthRest1,MaxWidthRest1,ProminenceInRest1,MinDistRest1);
    % 2. CORRIENDO 1min se?al original vs sin ruido
    [~,LOCS2CleanedR] = GetPeakPoints(Cleaneds2(j,:),Fs,MinPeakWidthRun_2,MaxWidthRun2,ProminenceRun2,MinDistRun2);
    % 3. CORRIENDO 1min se?al original vs sin ruido
    [~,LOCS3CleanedR] = GetPeakPoints(Cleaneds3(j,:),Fs,MinPeakWidthRun_3,MaxWidthRun3,ProminenceRun3,MinDistRun3);
    % 4. CORRIENDO 1min se?al original vs sin ruido
    [~,LOCS4CleanedR] = GetPeakPoints(Cleaneds4(j,:),Fs,MinPeakWidthRun_4,MaxWidthRun4,ProminenceRun4,MinDistRun4);
    % 5. CORRIENDO 1min se?al original vs sin ruido
    [~,LOCS5CleanedR] = GetPeakPoints(Cleaneds5(j,:),Fs,MinPeakWidthRun_5,MaxWidthRun5,ProminenceRun5,MinDistRun5);
    % 6. REST 30s se?al original vs sin ruido
    [~,LOCS6CleanedR] = GetPeakPoints(Cleaneds6(j,:),Fs,MinPeakWidthRest6,MaxWidthRest6,ProminenceInRest6,MinDistRest6);

% 2. ECG PEAKS EXRACTION 
    [~,ECG1Locs] = GetECGPeakPoints(CleanedActivityECG1(j,:),MinHeightECGRest1,minDistRest1,maxWidthRest1);
    [~,ECG2Locs] = GetECGPeakPoints(CleanedActivityECG2(j,:),MinHeightECGRun2,minDistRun2,maxWidthRun2);
    [~,ECG3Locs] = GetECGPeakPoints(CleanedActivityECG3(j,:),MinHeightECGRun3,minDistRun3,maxWidthRun3);
    [~,ECG4Locs] = GetECGPeakPoints(CleanedActivityECG4(j,:),MinHeightECGRun4,minDistRun4,maxWidthRun4);
    [~,ECG5Locs] = GetECGPeakPoints(CleanedActivityECG5(j,:),MinHeightECGRun5,minDistRun5,maxWidthRun5);
    [~,ECG6Locs] = GetECGPeakPoints(CleanedActivityECG6(j,:),MinHeightECGRest6,minDistRest6,maxWidthRest6);

% 3. CALCULAMOS LAS VENTANAS PARA EVALUACION
%Vamos a calcular el intervalo RR para poder partirlo en 2 y mirar cuantas
%unidades tiene cada ventana de corrimiento. Por lo tanto, cada ventana
%será una medición. Cada actividad poseerá floor(L/W) mediciones donde L es la
%longitud del intervalo en tiempo y W es la longitud de la ventana en
%tiempo.
    W1=(mean(diff(ECG1Locs)))/2;
    W2=(mean(diff(ECG2Locs)))/2;
    W3=(mean(diff(ECG3Locs)))/2;
    W4=(mean(diff(ECG4Locs)))/2;
    W5=(mean(diff(ECG5Locs)))/2;
    W6=(mean(diff(ECG6Locs)))/2;

% 4.VEAMOS EL CORRIMIENTO 
    %Actividad1
    RLOCSPPG1Cleaned=GetCorrimiento(ECG1Locs,LOCS1CleanedR,Cleaneds1(j,:),CleanedActivityECG1(j,:),Fs);
    %Actividad2
    RLOCSPPG2Cleaned=GetCorrimiento(ECG2Locs,LOCS2CleanedR,Cleaneds2(j,:),CleanedActivityECG2(j,:),Fs);
    %Actividad3
    RLOCSPPG3Cleaned=GetCorrimiento(ECG3Locs,LOCS3CleanedR,Cleaneds3(j,:),CleanedActivityECG3(j,:),Fs);
    %Actividad4
    RLOCSPPG4Cleaned=GetCorrimiento(ECG4Locs,LOCS4CleanedR,Cleaneds4(j,:),CleanedActivityECG4(j,:),Fs);
    %Actividad5
    RLOCSPPG5Cleaned=GetCorrimiento(ECG5Locs,LOCS5CleanedR,Cleaneds5(j,:),CleanedActivityECG5(j,:),Fs);
    %Actividad6
    RLOCSPPG6Cleaned=GetCorrimiento(ECG6Locs,LOCS6CleanedR,Cleaneds6(j,:),CleanedActivityECG6(j,:),Fs);

% MODELO Ramirez

%Para la señal Cleaned
ParametersMatrixCleanedR=[];
ParametersMatrixCleanedR(1,(1:4))=GetConfussionValues(W1,ECG1Locs,RLOCSPPG1Cleaned,length(Activity1(j,:)),Fs);
ParametersMatrixCleanedR(2,(1:4))=GetConfussionValues(W2,ECG2Locs,RLOCSPPG2Cleaned,length(Activity2(j,:)),Fs);
ParametersMatrixCleanedR(3,(1:4))=GetConfussionValues(W3,ECG3Locs,RLOCSPPG3Cleaned,length(Activity3(j,:)),Fs);
ParametersMatrixCleanedR(4,(1:4))=GetConfussionValues(W4,ECG4Locs,RLOCSPPG4Cleaned,length(Activity4(j,:)),Fs);
ParametersMatrixCleanedR(5,(1:4))=GetConfussionValues(W5,ECG5Locs,RLOCSPPG5Cleaned,length(Activity5(j,:)),Fs);
ParametersMatrixCleanedR(6,(1:4))=GetConfussionValues(W6,ECG6Locs,RLOCSPPG6Cleaned,length(Activity6(j,:)),Fs);

% MOSTRAMOS LOS RESULTADOS
disp('MODELO R')
fprintf('Actividad %d ',j);
disp('Parametros de la matriz de confusión para la señal PPGCleaned vs. ECG')
disp('TP     FP     TN     FN')
disp(ParametersMatrixCleanedR)
