clear; clc;
%%Calculation for 90 degree rotation
circCM= 2*pi*5.5;
wheelCM = 6*pi;
wheelrotations= circCM / wheelCM;
MotorDeg = 90* wheelrotations;

%%Establishing ev3
Beyonce = legoev3('usb'); %Establishes connection with robot
MotorB = motor(Beyonce,'B'); %Establishes Motor B
MotorC = motor(Beyonce,'C'); %Establishes Motor C
Sensor_Color = colorSensor(Beyonce, 1);%Establishes color sensor
sonic= sonicSensor(Beyonce, 2);%Establishes ultrasonic sensor
mytouchsensor = touchSensor(Beyonce, 4);%Establishes touch sensor
pressed = readTouch(mytouchsensor);
color = Sensor_Color.readColor;
MotorB.resetRotation;
MotorC.resetRotation;
RotationB = MotorB.readRotation;
RotationC = MotorC.readRotation;
initialtouch=0;
turn=0;

%% Maze Code %%
while true
    %continously read color
    clear distance %clears previous data so ultrasonic sensor 
    distance= readDistance(sonic); %continuously read distance
    MotorB.start
    MotorC.start
    if 0.07 < distance && distance < 1.5 % makes the robot go straight when there is nothing blocking the robot at least 5 cm in front of it
        RotationB = MotorB.readRotation;
        RotationC = MotorC.readRotation;
        if RotationC > RotationB %slows down motor C when it has more rotations than B
            MotorC.Speed=25;
            MotorB.Speed = 30;
        elseif RotationB > RotationC  %slows down motor B when it has more rotations than C
            MotorB.Speed=25;
            MotorC.Speed = 30;
        else
            MotorB.Speed = 30;
            MotorC.Speed = 30;
        end
    end
    if distance <= 0.07 %makes the robot read the color of what is in front of it and act accordingly  
        color = Sensor_Color.readColor
        if strcmp (color , 'white') %will make robot turn left when it detects white
            while distance < 0.10  % to go back till it's 10 cm away and then turn
                distance = readDistance(sonic)
                %backing up function
                MotorB.Speed = -30;
                MotorC.Speed = -30;
            end
            %turning funtion
            MotorB.Speed= 0;
            MotorC.Speed = 0;
            
            MotorB.Speed= -30;
            MotorC.Speed = 30;
            MotorB.resetRotation;
            MotorC.resetRotation;
            rotB = MotorB.readRotation;
            rotC = MotorC.readRotation;
            MotorB.start
            MotorC.start
            while rotB < MotorDeg
                rotB= -MotorB.readRotation;
                if rotB >= MotorDeg
                    MotorB.stop
                end
            end
            while rotC < MotorDeg
                rotC= MotorC.readRotation;
                if rotC >= MotorDeg
                    MotorC.stop
                end
            end
            MotorB.resetRotation;
            MotorC.resetRotation;
            turn = turn + 1; %ticks the counter for turns 
        elseif strcmp (color, 'red') %will make robot turn right when it detects red
            while distance < 0.10  % go back 10cm then turn
                distance = readDistance(sonic)
                MotorB.Speed = -30
                MotorC.Speed = -30
            end
            %turning function
            MotorB.Speed= 0;
            MotorC.Speed = 0;
            
            MotorB.Speed= 30;
            MotorC.Speed = -30;
            MotorB.resetRotation;
            MotorC.resetRotation;
            rotB = MotorB.readRotation;
            rotC = MotorC.readRotation;
            MotorB.start
            MotorC.start
            while rotB < MotorDeg
                rotB= MotorB.readRotation;
                if rotB >= MotorDeg
                    MotorB.stop
                end
            end
            while rotC < MotorDeg
                rotC= -MotorC.readRotation;
                if rotC >= MotorDeg
                    MotorC.stop
                end
            end
            MotorB.resetRotation;
            MotorC.resetRotation;
            turn = turn + 1; %ticks the counter for turns
        end
    end
    
    if distance >= 1.5 % robot will stop running color detection and turn function when it does not detect anymore walls
        break;
    end
    
end

while distance > 1.5
    touch = readTouch(mytouchsensor)    
    distance= readDistance(sonic)
    if ((touch == 1) && (initialtouch == 0))
        MotorB.Speed = MotorB.Speed + 5 %speeds up motor B when touched
        MotorC.Speed = MotorC.Speed + 5 %speeds up motor C when touched
        pause(1) %gives the code a break so that it doesn't continuously loop 
    end
end
MotorB.Speed=0;
MotorC.Speed=0;
MotorB.stop
MotorC.stop

disp(turn)
i=1;
while i <= turn % ev3 beeps the amount of times that it turned
    beep(Beyonce,0.3)
    pause(0.5);
    i=i+1; %ticks the counter for the amount of times it's already beeped
end