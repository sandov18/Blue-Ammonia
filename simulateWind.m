%% introduction
% This script simulates electricity generation using a wind power output.
%
% Jose Sandoval, Purdue University, 2024
%
% Please make sure the following file is on your Matlab path:
%   west-lafayette-2020-wind.csv (WRDB weather data CSV)

%% function setup
function pWind = simulateWind()

%% graphics settings
%configureGraphics; % changes font sizes, line widths, text interpreter

%% input data
% timing
dt = 5/60; % time step, h
tSpan = (datetime(2020,1,1,0,0,0):hours(dt):datetime(2020,12,31,23,0,0))'; % time span as datetime
K = length(tSpan); % number of time steps
t = (0:dt:K*dt)';

% wind data import
windFile = 'west-lafayette-2020-wind.csv'; % wind file name
[windSpeed80m,windSpeed100m,windSpeed120m,offsetGMT] = ...
    importWind(windFile,tSpan); % weather data import

%% wind power generation
% wind turbine parameters
ratedP = 2000; % rated power [kW]
ratedV = 11.5; % rated speed, [m/s]
cutinV = 3; % cut in speed, [m/s]
cutoutV = 21; % cut out speed, [m/s]
V = windSpeed100m; %wind speed at selected hub height (100m)
pWind = NaN; %Wind Power [kW]

% wind energy generated
for k = 1:1:K
    if V(k) < cutinV
        pWind(k) = 0;
    elseif V(k) >= cutinV && V(k) <= ratedV
        CP = 0.00008125*V(k)^6 - 0.00330702*V(k)^5 + 0.05321091*V(k)^4 - ...
        0.43395758*V(k)^3 + 1.91371824*V(k)^2 - 4.28922087*V(k) + 3.81730608;
        if CP > 1
            CP = 1;
        end
        pWind(k) = CP * ratedP;
    elseif V(k) > ratedV && V(k) < cutoutV
        pWind(k) = ratedP;
    elseif V(k) >= cutoutV
        pWind(k) = 0;
    end        
end

%% plot
% figure(1), clf
% plot(tSpan,pWind,'k')
% ylabel({'Wind Power [kW]'})

















