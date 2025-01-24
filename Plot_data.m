timeStep = 1/fs;
endTime = (length(Data(:,1))-1)*timeStep;
time = 0:timeStep:endTime;
time = transpose(time);
for i = 1:16
    figure(i);
    
    plot(time,Data(:,i));
    title(['Signal at microphone ',num2str(i)]);
    xlabel('Time (s)')
end

figure(17);
plot(time,Clean);
title('Signal without noise');
xlabel('Time (s)')