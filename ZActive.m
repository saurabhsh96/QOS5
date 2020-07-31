%ZActive calulation
function Z = ZActive(k0,mx,my,th,ph,l,w,dx,dy)
    zeta = 377;
    kx = k0.*sin(th).*cos(ph);
    ky = k0.*sin(th).*sin(ph);
    Z = 0;
    for mxVal = mx
        for myVal = my
            kxm = kx - 2.*pi.*mxVal./dx;
            kym = ky - 2.*pi.*myVal./dy;
    
            Jt = sinc(kym.*w/2/pi);
            It = (2.*k0).*(cos(kxm.*l./2) - cos(k0*l/2))...
                ./((k0.^2 - kxm.^2).*sin(k0*l/2));
    
            bSGF = createSGF(k0, kxm, kym, zeta, th);
            Z = Z + bSGF(1, 1).*((abs(Jt)).^2).*((abs(It)).^2);  
        end
    end
    Z = -Z./(dx.*dy);
end