%% AN�LISIS DE ESPECTRO JUEVES 28 FEBRERO 2019

    ppg=load('DATA_01_TYPE02.mat');
    ppgSignal = ppg.sig;
    pfinal = ppgSignal(2,(1:3750)); %Señal en REPOSO
    pfinal2 = ppgSignal(2,(3750:11250));%Señal CAMINANDO A 8km/h
%FRECUENCIA DE MUESTREO
    Fs = 125;
% CONVERSIÓN A VARIABLES F�?SICAS
    sNorm = (pfinal-min(pfinal))/(max(pfinal)-min(pfinal));
    t = (0:length(pfinal)-1);
    Res = 10; % Resolucion en frecuencia = 10 Hz
    Npuntos = 2^nextpow2(Fs/2/Res);
    w = hanning(Npuntos);
    [P,F] = pwelch(sNorm,w,Npuntos/2,Npuntos,Fs);
%% Grafica del espectro de potencia 
% %hold on
% %semilogx(F2*E1,Y2,'vr')
% xlabel(['Frequency in ' 'Hz'])
% ylabel('Power Spectrum ')
% grid on
% axis tight

s2filt=sgolayfilt(sNorm,3,41);
[Pf,Ff]=pwelch(s2filt,w,Npuntos/2,Npuntos,Fs);

figure(1)
pwelch(sNorm,w,Npuntos/2,Npuntos,Fs),
hold on,
pwelch(s2filt,w,Npuntos/2,Npuntos,Fs),
legend('normal','filtrado')
title('comparacion de potencia normal y filtrado up/down ')
%%
figure(2)
plot(t,sNorm),hold on, plot(t,s2filt)
title('señal normal y filtrada con savitsky golay')

nueva=sNorm-s2filt;
figure(3),plot(t,nueva);
title('ruido obtenido con Savitzky Golay')

figure(4)
pwelch(nueva,w,Npuntos/2,Npuntos,Fs),
title('potencia espectral del ruido')

espectroruido=fft(sNorm-s2filt);
L=length(espectroruido);
P2 = abs(espectroruido/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

figure(5)
plot(f,P1)
title('Espectro se�al')
