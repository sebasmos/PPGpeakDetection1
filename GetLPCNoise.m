function arnoise = GetLPCNoise(activity,sactivity,params,Fs)
% This function allows us to obtain noise, product of an auto linear
% regresion process, first we obtain a model of the signal and then feed
% the linear predictor with it. 
% Inputs: Activity --> vector containing the signal of a determined
%                       activity in a determined realization.
%         params --> parameters needed to obtain peaks of the signal, these
%                       have been calibrated beforehand.
% Output: Noise of that determined activity, in the determined realization. 
addpath('/Users/alejandralandinez/Documents/MATLAB/mcode/tesis/Training_data/NoiseProofs');
 
 %First we obtain peaks from the signal
    [PKS1,LOCS1]=GetPeakPoints(activity,Fs,params(1),params(2),params(3),params(4));
    peaks=length(PKS1);
 %Then we obtain intervals, peaks and more information in samples number
    intPP=diff(LOCS1); % PP interval duration
    medintPP=round(mean(diff(LOCS1)),1); %Average PP interval duration
    fprintf('El intervalo PP promedio es %d segundos',medintPP);
    fprintf('\n es decir que el ciclo PPG comienza aproximadamente %d segundos antes del pico \n',medintPP/2);
    samPP=round(intPP*Fs,0); % We obtain the durations of the peaks in samples number
    newlocs=round(LOCS1*Fs,0); %Positions of the peaks in samples number
    delay=round(round(medintPP/2,1)*Fs); %And delay time before the peak in samples number
    M=length(diff(newlocs));   % Found PP intervals
    offset=max(PKS1);     % To deploy PP peaks above the signal
    meanduration=round(medintPP*Fs,0);
    stack=zeros(M,meanduration); % Sets apart memory for storing the matrix M (cardiac cycles)
    qrs=zeros(M,2); % Sets apart memory for the PP peaks curve in 3D

    % Then we stores a cardiac cycle, since 0.4*Fs seconds before PP peak
    % until the duration, given by the minimum duration of all PP found
    % intervals
            
    for m=1:M
    switch(m)
        case 1
            first=activity(1:newlocs(m)-delay+meanduration);
            L=length(first);
            if(meanduration>=L)
                stack(m,:)=[first zeros(1,meanduration-L)];
                qrs(m,:)=[delay+1 activity(newlocs(m))];
            else
                sobra=L-meanduration;
                stack(m,:)=activity(1:newlocs(m)-delay+meanduration-sobra);
                qrs(m,:)=[delay+1 activity(newlocs(m))];
            end
        case M
            if(length(activity)-newlocs(m))>0
                stack(m,:)=activity(newlocs(m)-delay:newlocs(m)+meanduration-delay-1);
                qrs(m,:)=[delay+1 activity(newlocs(m))];
            else
                stack(m,:)=activity(newlocs(m)-delay:end);
                qrs(m,:)=[delay+1 activity(newlocs(m))];
            end
        otherwise
            stack(m,:)=activity(newlocs(m)-delay:newlocs(m)+meanduration-delay-1);
            
            qrs(m,:)=[delay+1 activity(newlocs(m))]; 
            % Saves P peaks to deploy above 3D P peak
    end     
    end
    
    figure(9)
    [X,Y] = meshgrid(1:meanduration,1:M); % Generates a mesh in x-y for drawing the 3D surface
    surf(Y,X,stack);hold on;grid on; % Draws all cycles in 3D
    shading interp
    % Draws the curve of PP peaks above 3D PPG
    plot3(1:M,qrs(:,1),qrs(:,2)+offset,'go-','MarkerFaceColor','g')
    title('Ondas PPG intervalo promedio en stack')
    view(120, 30);%vision of the signal in 120 degrees

    %Obtención de la onda PPG promedio
    ppg_prom = mean(stack);
    figure(10)
    plot((0:length(stack)-1)/Fs,ppg_prom),grid on, axis tight
    title('Onda PPG promedio'),xlabel('Tiempo(seg)')

    % Modelo de la señal PPG para la actividad

    a = lpc(ppg_prom,2);
    est_PPG1 = filter([0 -a(2:end)],1,activity);
    figure(11)
    %plot([0:length(stack)-1]/Fs,ECG_prom,[0:length(stack)-1]/Fs,est_ECG)
    plot((0:length(activity)-1)/Fs, activity,'LineWidth',2),hold on,
    plot((0:length(activity)-1)/Fs,est_PPG1),grid on, axis tight
    legend('PPG','PPG Estimada'),
    title('Estimación de la onda PPG a partir de los coeficientes de autoregresión')
    xlabel('Tiempo (seg)')
    
    %Obtención del ruido a partir de la señal generada
    
    arnoise=sactivity-est_PPG1;
end