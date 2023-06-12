%%
%%% Arian Velayati, PhD
%%%% This script is used to design and interpret DFIT 
clc;close;clear;

%% input p-1
% Recommended pup rate is 10 bpm in most operations

q_pump = 10; % Pump rate (bpm)
t_pump = 6.6; % Pump time (min)
perm = 0.01; % Reservoir permeability (md) 

%% input p-2
% The following inputs are used to determine the time to reach
% pseudo-radial flow in hrs. This is assuming that linear transient flow
% governs fracture leak off flow up untill closure, then the time required
% for the induced pressure transient to establish a pseudo-radial flow
% regime can be computed from the definition of dimmensionless time (tDxf)

phi = 0.08; % Porosity
mu = 0.02; % Res Fluid viscosity; cp
Ct = 0.00003; % Total reservoir compressibility; 1/psi
kl = 0.01; % Permeability of leak off system; md (The same as res perm)
tDxf = 2; % Dimmensionless time,For pseudo-radial a value of tDxf=1 (at least) must be reached in the falloff period.
% tDxf ranges from 1-5, literature suggests 2 for an infinite conductivity
% fracture and 3 for a uniform flux fracture

%% Fracture half length

% Assuming a 30 ft fracture height and 0.1" frac width, 100% fluid
% efficiency (No leak off), water injection in typical 20 GPa MOE rocks and
% a net pressure of 1000 psi (pinj - s3,

Xl_3 = 31 * q_pump; % Fracture half length (ft) for 5 min injection;ft
Xl_5 = 60 * q_pump; % Fracture half length (ft) for 5 min injection; ft

%% Operational Times

Closure_Time = t_pump/(3*perm); % Time to reach fracture closure; min
T_Trans = 3*Closure_Time; % Time to establish analyzable reservoir transient (empirical apprix.); min
T2_Trans = t_pump/perm; % Time to establish analyzable reservoir transient; min
tpr = (phi*mu*Ct*(Xl_5^2)*tDxf)/(0.000264*kl); % time to reach pseudo radial flow, days

%% G time
P_z = 3000; % Hydrostatic pressure at depth
t = load('time.csv'); % hrs
p = load('pressure.csv'); % psi (BHP data. If entering Wellhead data "starting at p=0" delete P_z
p = p - P_z;

% creating datasets for G funciton plots,
% considering only after pump time duration
x = find(t>(t_pump/60));
t_G = t(x:end); 
p_G = p(x:end);


% G function

DeltD = (t_G) - t_pump/60; % min
G = 2*sqrt(DeltD); 
deriv = abs(diff(G).*(diff(p_G)./diff(t_G)));
deriv = [0;deriv];
%% Plotting

subplot(2,1,1)
semilogx(t,p)
xlabel('time(hrs)')
ylabel('pressure (psi)')
grid on
title('Pressure vs time')

subplot(2,1,2)
plot(G,p_G,'r')
xlabel('G time')
ylabel('pressure (psi)')
grid on
hold on 
scatter(G,deriv)
title('G*dp/dG')
