%% ESTE SCRIPT ES PARA UN ÚNICO USO, SIMPLEMENTE VA A GUARDAR LOS DATOS DE
%%LAS SEÑALES EN VARIOS .mat QUE SEAN LEGIBLES DE UNA MEJOR MANERA.

%Se separaron las arritmias en 3: Bradicardia extrema, Taquicardia extrema
%y taquicardia ventricular 
%En las ultimas dos, se considerarán como iguales. Hay registros en los que
%hay eventos y en los que no hay eventos. Los que tienen eventos están
%separados de primeros en todos los registros y los que estan de ultimos
%son los que no tienen ningun evento.

%MANUALMENTE SE VIO QUE: 
%En bradicardia, hay positivos hasta el 46, del 47 al 89 son negativos
%En taquicardia hay positivos hasta el 131, del 131 al 140 son negativos
%En ventricular hay positivos hasta el 88, del 89 al 341 son negativos
%EN TOTAL PARA TAQUICARDIA QUEDARIAN 140+341=481 registros

%En total hay 573 registros.

%Se usa comando rdmat preferiblemente que rdsamp (use rdmat to load the signal in physical units)

addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/dbTachBrad')
%% Extraemos las señales de bradicardia, en total son 90
BradPositives=46;
BradNegatives=89;
TachPositives=131;
TachNegatives=140;
VTachPositives=88;
VTachNegatives=341;
shortBradPositives=1;
longBradPositives=1;
shortTachPositives=1;
longTachPositives=1;
shortVTachPositives=1;
longVTachPositives=1;
%% EXTRACCION Y ORGANIZACION DE LAS SEÑALES DE BRADICARDIA
%Hay señales que son mas largas que otras, por esta razon y para poder
%sumar el ruido de una manera mas facil en un futuro, se decide guardarlas
%en datasets individuales, que se dividen en señales cortas y largas.
%Además se debe tener en cuanta las posiciones de los positivos, que en
%ambos casos se han dejado en primera posicion, para poder diferenciarlos
%en caso de una clasificación. Por esto se debe tener en cuanta las flags
%limitBradPositivesShort y limitBradPositivesLong. Estos son los números en
%donde terminan los positivos y comienzan los negativos.
%Positivos= señales en donde está anotado que ocurre la arritmia escogida
%Negativos= señales en donde está anotado que NO ocurre la arritmia
%escogida.

for k = 1:BradPositives
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'b'},labelstring);
        [tm,signal,Fs,siginfo]=rdmat(word{1});
        TamRealizacion=length(signal);
        if(TamRealizacion==75000)
            BRADPPGShort(shortBradPositives,:)=signal(:,3)';
            BRADECGShort(shortBradPositives,:)=signal(:,1)';
            shortBradPositives=shortBradPositives+1;
        else
            BRADPPGLong(longBradPositives,:)=signal(:,3)';
            BRADECGLong(longBradPositives,:)=signal(:,1)';
            longBradPositives=longBradPositives+1;
        end
    else
        labelstring = int2str(k);
        word = strcat({'b0'},labelstring);
        [tm,signal,Fs,siginfo]=rdmat(word{1});
        TamRealizacion=length(signal);
        if(TamRealizacion==75000)
            BRADPPGShort(shortBradPositives,:)=signal(:,3)';
            BRADECGShort(shortBradPositives,:)=signal(:,1)';
            shortBradPositives=shortBradPositives+1;
        else
            BRADPPGLong(longBradPositives,:)=signal(:,3)';
            BRADECGLong(longBradPositives,:)=signal(:,1)';
            longBradPositives=longBradPositives+1;
        end
    end
end

fprintf('El número de señales cortas en positivos de bradicardia son %d \n',shortBradPositives-1);
fprintf('El número de señales largas en positivos de bradicardia son %d \n',longBradPositives-1);
limitBradPositivesShort=shortBradPositives-1;
limitBradPositivesLong=longBradPositives-1;
%%
for k = BradPositives+1:BradNegatives
    labelstring = int2str(k);
    word = strcat({'b'},labelstring);
    [tm,signal,Fs,siginfo]=rdmat(word{1});
    TamRealizacion=length(signal);
    if(TamRealizacion==75000)
        BRADPPGShort(shortBradPositives,:)=signal(:,3)';
        BRADECGShort(shortBradPositives,:)=signal(:,1)';
        shortBradPositives=shortBradPositives+1;
    else
        BRADPPGLong(longBradPositives,:)=signal(:,3)';
        BRADECGLong(longBradPositives,:)=signal(:,1)';
        longBradPositives=longBradPositives+1;
    end
end

fprintf('El número de señales cortas en negativos de bradicardia son %d \n',shortBradPositives-limitBradPositivesShort-1);
fprintf('El número de señales largas en negativos de bradicardia son %d \n',longBradPositives-limitBradPositivesLong-1);

%% EXTRACCION Y ORGANIZACION DE LAS SEÑALES DE TAQUICARDIA
for k = 1:TachPositives
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'t'},labelstring);
        [tm,signal,Fs,siginfo]=rdmat(word{1});
        TamRealizacion=length(signal);
        if(TamRealizacion==75000)
            TACHPPGShort(shortTachPositives,:)=signal(:,3)';
            TACHECGShort(shortTachPositives,:)=signal(:,1)';
            shortTachPositives=shortTachPositives+1;
        else
            TACHPPGLong(longTachPositives,:)=signal(:,3)';
            TACHECGLong(longTachPositives,:)=signal(:,1)';
            longTachPositives=longTachPositives+1;
        end
    else
        labelstring = int2str(k);
        word = strcat({'t0'},labelstring);
        [tm,signal,Fs,siginfo]=rdmat(word{1});
        TamRealizacion=length(signal);
        if(TamRealizacion==75000)
            TACHPPGShort(shortTachPositives,:)=signal(:,3)';
            TACHECGShort(shortTachPositives,:)=signal(:,1)';
            shortTachPositives=shortTachPositives+1;
        else
            TACHPPGLong(longTachPositives,:)=signal(:,3)';
            TACHECGLong(longTachPositives,:)=signal(:,1)';
            longTachPositives=longTachPositives+1;
        end
    end
end

fprintf('El número de señales cortas en positivos de taquicardia son %d \n',shortTachPositives-1);
fprintf('El número de señales largas en positivos de taquicardia son %d \n',longTachPositives-1);
limitTachPositivesShort=shortTachPositives-1;
limitTachPositivesLong=longTachPositives-1;
%%
for k = TachPositives+1:TachNegatives
    labelstring = int2str(k);
    word = strcat({'t'},labelstring);
    [tm,signal,Fs,siginfo]=rdmat(word{1});
    TamRealizacion=length(signal);
    if(TamRealizacion==75000)
        TACHPPGShort(shortTachPositives,:)=signal(:,3)';
        TACHECGShort(shortTachPositives,:)=signal(:,1)';
        shortTachPositives=shortTachPositives+1;
    else
        TACHPPGLong(longTachPositives,:)=signal(:,3)';
        TACHECGLong(longTachPositives,:)=signal(:,1)';
        longTachPositives=longTachPositives+1;
    end
end

fprintf('El número de señales cortas en negativos de taquicardia son %d \n',shortTachPositives-limitTachPositivesShort-1);
fprintf('El número de señales largas en negativos de taquicardia son %d \n',longTachPositives-limitTachPositivesLong-1);

%% EXTRACCION Y ORGANIZACION DE LAS SEÑALES DE TAQUICARDIA VENTRICULAR
for k = 1:VTachPositives
    if k >= 10
        labelstring = int2str(k);
        word = strcat({'v'},labelstring);
        [tm,signal,Fs,siginfo]=rdmat(word{1});
        TamRealizacion=length(signal);
        if(TamRealizacion==75000)
            VTACHPPGShort(shortVTachPositives,:)=signal(:,3)';
            VTACHECGShort(shortVTachPositives,:)=signal(:,1)';
            shortVTachPositives=shortVTachPositives+1;
        else
            VTACHPPGLong(longVTachPositives,:)=signal(:,3)';
            VTACHECGLong(longVTachPositives,:)=signal(:,1)';
            longVTachPositives=longVTachPositives+1;
        end
    else
        labelstring = int2str(k);
        word = strcat({'v0'},labelstring);
        [tm,signal,Fs,siginfo]=rdmat(word{1});
        TamRealizacion=length(signal);
        if(TamRealizacion==75000)
            VTACHPPGShort(shortVTachPositives,:)=signal(:,3)';
            VTACHECGShort(shortVTachPositives,:)=signal(:,1)';
            shortVTachPositives=shortVTachPositives+1;
        else
            VTACHPPGLong(longVTachPositives,:)=signal(:,3)';
            VTACHECGLong(longVTachPositives,:)=signal(:,1)';
            longVTachPositives=longVTachPositives+1;
        end
    end
end

fprintf('El número de señales cortas en positivos de taquicardia ventricular son %d \n',shortVTachPositives-1);
fprintf('El número de señales largas en positivos de taquicardia ventricular son %d \n',longVTachPositives-1);
limitVTachPositivesShort=shortVTachPositives-1;
limitVTachPositivesLong=longVTachPositives-1;
%%
for k = VTachPositives+1:VTachNegatives
    labelstring = int2str(k);
    word = strcat({'v'},labelstring);
    [tm,signal,Fs,siginfo]=rdmat(word{1});
    TamRealizacion=length(signal);
    if(TamRealizacion==75000)
        VTACHPPGShort(shortVTachPositives,:)=signal(:,3)';
        VTACHECGShort(shortVTachPositives,:)=signal(:,1)';
        shortVTachPositives=shortVTachPositives+1;
    else
        VTACHPPGLong(longVTachPositives,:)=signal(:,3)';
        VTACHECGLong(longVTachPositives,:)=signal(:,1)';
        longVTachPositives=longVTachPositives+1;
    end
end

fprintf('El número de señales cortas en negativos de taquicardia ventricular son %d \n',shortVTachPositives-limitVTachPositivesShort-1);
fprintf('El número de señales largas en negativos de taquicardia ventricular son %d \n',longVTachPositives-limitVTachPositivesLong-1);


%% Ahora que ya tenemos todas las señales divididas en largas y cortas, 
%vamos a unir las que sean de taquicardia y taquicardia ventricular. Tanto
%para cortas como para largas

TACHYECGShort=[TACHECGShort((1:limitTachPositivesShort),:);VTACHECGShort((1:limitVTachPositivesShort),:);TACHECGShort((limitTachPositivesShort+1:end),:);VTACHECGShort((limitVTachPositivesShort+1:end),:)];
TACHYECGLong=[TACHECGLong((1:limitTachPositivesLong),:);VTACHECGLong((1:limitVTachPositivesLong),:);TACHECGLong((limitTachPositivesLong+1:end),:);VTACHECGLong((limitVTachPositivesLong+1:end),:)];
TACHYPPGShort=[TACHPPGShort((1:limitTachPositivesShort),:);VTACHPPGShort((1:limitVTachPositivesShort),:);TACHPPGShort((limitTachPositivesShort+1:end),:);VTACHPPGShort((limitVTachPositivesShort+1:end),:)];
TACHYPPGLong=[TACHPPGLong((1:limitTachPositivesLong),:);VTACHPPGLong((1:limitVTachPositivesLong),:);TACHPPGLong((limitTachPositivesLong+1:end),:);VTACHPPGLong((limitVTachPositivesLong+1:end),:)];


%% VAMOS A PORCIONAR LAS SEÑALES TACHY DE A 60 REGISTROS 
%Debido a que existe un límite estricto de archivos que superan los 100 MB
%de tamaño para subir al repositorio, se porcionan los archivos de las
%bases de datos de taquicardia en 4, de manera que cada uno quede
%uniformemente con al menos 30 MB. En cuanto a su organizacion, solo hace
%falta bajarlos y pegar las filas en el orden en el que vienen identados
%los archivos, por ejemplo, tomando en cuenta cómo se porcionan a
%continuacion, puede verse que simplemente se deben pegar uno debajo del
%otro y no pierden el orden ni la separacion que se ha hecho anteriormente
%entre true y false alarms.

%Primero las Taquicardias en ECG tanto cortas como largas
TACHYECGLong1=TACHYECGLong((1:60),:);
TACHYECGLong2=TACHYECGLong((61:120),:);
TACHYECGLong3=TACHYECGLong((121:180),:);
TACHYECGLong4=TACHYECGLong((181:end),:);

TACHYECGShort1=TACHYECGShort((1:60),:);
TACHYECGShort2=TACHYECGShort((61:120),:);
TACHYECGShort3=TACHYECGShort((121:180),:);
TACHYECGShort4=TACHYECGShort((181:end),:);

 % Luego las taquicardias en PPG tanto cortas como largas 

TACHYPPGLong1=TACHYPPGLong((1:60),:);
TACHYPPGLong2=TACHYPPGLong((61:120),:);
TACHYPPGLong3=TACHYPPGLong((121:180),:);
TACHYPPGLong4=TACHYPPGLong((181:end),:);

TACHYPPGShort1=TACHYPPGShort((1:60),:);
TACHYPPGShort2=TACHYPPGShort((61:120),:);
TACHYPPGShort3=TACHYPPGShort((121:180),:);
TACHYPPGShort4=TACHYPPGShort((181:end),:);
%% Ya que los organizamos, vamos a exportarlos o guardarlos.
%Este proceso debe hacerse SOLO UNA VEZ pues de hacerse varias estarías
%sobreescribiendo los archivos encima y se saldrian del control de
%versiones de git, de manera que cada vez que un archivo se renueve, git
%add . va a continuar subiendo estos archivos, pues han sido 'modificados'.

%Yo tuve que hacer esto, pero si estas viendo esto y ya bajaste las bases
%de datos, es innecesario.

% save('BRADECGLong','BRADECGLong');
% save('BRADECGShort','BRADECGShort');
% save('BRADPPGLong','BRADPPGLong');
% save('BRADPPGShort','BRADPPGShort');
% 
% save('TACHYECGLong1','TACHYECGLong1');
% save('TACHYECGLong2','TACHYECGLong2');
% save('TACHYECGLong3','TACHYECGLong3');
% save('TACHYECGLong4','TACHYECGLong4');
% 
% save('TACHYECGShort1','TACHYECGShort1')
% save('TACHYECGShort2','TACHYECGShort2')
% save('TACHYECGShort3','TACHYECGShort3')
% save('TACHYECGShort4','TACHYECGShort4')
% 
% save('TACHYPPGLong1','TACHYPPGLong1');
% save('TACHYPPGLong2','TACHYPPGLong2');
% save('TACHYPPGLong3','TACHYPPGLong3');
% save('TACHYPPGLong4','TACHYPPGLong4');
% 
% save('TACHYPPGShort1','TACHYPPGShort1')
% save('TACHYPPGShort2','TACHYPPGShort2')
% save('TACHYPPGShort3','TACHYPPGShort3')
% save('TACHYPPGShort4','TACHYPPGShort4')
%%
