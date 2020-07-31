%HW Q1
clear;
%% Input definations

%Distances in X and Y direction
dx = 20e-3;
dy = 20e-3;

%Dimensions of single dipole
w = 1e-3;
l = 14e-3;

%Defining the mesh
drad = pi/180;
dth = drad;
dph = drad;
%[th, ph] = meshgrid(eps:dth:pi/2, eps:dph:2*pi);
%th = [0, 30*drad];
th = eps:dth:pi;
ph = [eps, 45*drad, 90*drad];
[th, ph] = meshgrid(th, ph);

%Defining mx and my indexes
%Bounds
upper = 20;
lower = -20;
mx = lower:1:upper;
my = mx;

%For fundamental mode
% mx = 0;
% my = 0;

%For higher order modes
% mx = 1;
% my = 1;

c = 3e8; %Speed of causality :P

%Defining frequency range
freq = 10e9;
lam = c/freq;
k0 = 2*pi/lam;
        
%indZ = 1;
%Defining Z
z = zeros(size(th));

%% Calculating Zin

for indPh = 1:size(ph, 1)
    for indTh = 1:size(th, 2)
        z(indPh, indTh) = ZActive(k0,mx,my,th(indPh, indTh),ph(indPh, indTh),l,w,dx,dy);
    end
end

%Plotting Zin
%Eplane

titleName = ["Zin Active, E Plane (phi = 0 deg)", "Zin Active, D Plane (phi = 45 deg)", ...
    "Zin Active, H Plane (phi = 90 deg)"];
for ind = 1:3
    figure(ind);
    plot([-th(ind,size(th, 2):-1:1)./drad th(ind,:)./drad], [real(z(ind,size(th, 2):-1:1))...
        real(z(ind,:))], 'LineWidth', 1.5); hold on;
    plot([-th(ind,size(th, 2):-1:1)./drad th(ind,:)./drad], [imag(z(ind,size(th, 2):-1:1))...
        imag(z(ind,:))], 'LineWidth', 1.5);
    title(titleName(ind));
    xlabel('\theta (in deg)');
    ylabel('Active Impedence (in Ohm)');
    legend('Zreal', 'Zimag');
    if(max([(imag(z(ind,:))) (real(z(ind,:)))]) > 1000)
        if(min([(imag(z(ind,:))) (real(z(ind,:)))]) < -200)
            ylim([-250 1000]);
        else
            ylim([min([(imag(z(ind,:))) (real(z(ind,:)))]) - 20 1000]);
        end
    else
        if(min([(imag(z(ind,:))) (real(z(ind,:)))]) < -200)
            ylim([-250 max([(imag(z(ind,:))) (real(z(ind,:)))]) + 20]);
        else
            ylim([min([(imag(z(ind,:))) (real(z(ind,:)))])-20 max([(imag(z(ind,:))) (real(z(ind,:)))]) + 20]);
        end
    end
end

%% Grating lobe diagram

radius = k0;
centerX = 2.*pi.*mx./dx;
centerY = 2.*pi.*my./dy;
[x, y] = meshgrid(centerX, centerY);

%Defining number of elements
Mx = size(mx, 2);
My = size(my, 2);

%Defining uniform rectangular array
%ura = phased.URA([Mx My], [dx dy]);

figure(4);
elem = phased.ShortDipoleAntennaElement(...
    'FrequencyRange',[freq-1e9 freq+1e9], 'AxisDirection','X');
array = phased.URA('Element',elem,'Size',[Mx,My],...
    'ElementSpacing',[dx,dy], 'ArrayNormal', 'z');
plotGratingLobeDiagram(array,freq,[0;90],c);
%viewArray(array,'Title','Uniform Rectangular Array (URA)');


figure(5);
%D Plane
u = ones(size(x)).*k0./sqrt(2);
v = ones(size(y)).*k0./sqrt(2);

%Eplane
% u = ones(size(x)).*k0;
% v = zeros(size(y)).*k0./sqrt(2);

%HPlane
% u = zeros(size(x)).*k0./sqrt(2);
% v = ones(size(y)).*k0;

quiver(x, y, u, v, 0, 'LineWidth', 1.5, 'MaxHeadSize', 0.2);

for ind = 1:Mx
    for indj = 1:My
        h = circleA(centerX(ind), centerY(indj), radius);
    end
end

%quiver(centerX, 
grid on;
xlim([-1000 1000]);
ylim([-1000 1000]);
xlabel('Kxm');
ylabel('Kym');
title(['Grating lobe diagram (D-plane, dx = dy =', num2str(dx*10^3), 'mm)']);
