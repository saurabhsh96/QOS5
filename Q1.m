% Antenna array calculations
%% Defining inputs

%Distances in X and Y direction
dx = 15e-3;
dy = 15e-3;

%Dimensions of single dipole
w = 3e-3;
l = 13.5e-3;

%Defining the mesh
drad = pi/180;
dth = drad;
dph = drad;
%[th, ph] = meshgrid(eps:dth:pi/2, eps:dph:2*pi);
th = [0, 30*drad];
ph = 0;

%Defining mx and my indexes
%Bounds
upper = 10;
lower = -10;
mx = lower:1:upper;
my = mx;

%Defining frequency range
freq = 5e9:500e6:15e9;

c = 3e8; %Speed of causality :P
indZ = 1;
%Defining Z
z = zeros(2, size(freq, 2));

%% Looping over Theta cases and Frequency
for ind = 1:size(th, 2)
    for f = freq
        lam = c/f;
        k0 = 2*pi/lam;
        z(ind, indZ) = ZActive(k0,mx,my,th(ind),ph,l,w,dx,dy);
        indZ = indZ + 1;
    end
    indZ = 1;
end

%Plotting
figure(1);
plot(freq, real(z(1,:)), 'LineWidth', 1.5); hold on;
plot(freq, imag(z(1,:)), 'LineWidth', 1.5);
title('Real and Imaginary Parts of Active Impedence \Theta = 0');
xlabel('Frequency in Hz');
ylabel('Real(Z) and Imag(Z) [in Ohm]');
legend('Real', 'Imag');

figure(2);
plot(freq, real(z(2,:)), 'LineWidth', 1.5); hold on;
plot(freq, imag(z(2,:)), 'LineWidth', 1.5);
title('Real and Imaginary Parts of Active Impedence \Theta = 30');
xlabel('Frequency in Hz');
ylabel('Real(Z) and Imag(Z) [in Ohm]');
legend('Real', 'Imag');