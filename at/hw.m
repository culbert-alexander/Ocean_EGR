mew = 50 * 10^-6;
%cox = 1;
vt = 1;
cox = 2.3 * 10^-15;
cov = 0.5 * 10^-15;
wl = 50/2;
wtimesl = 50*2;
w = 50;
id = 1 * 10^-6;
vgs = (sqrt(2*mew*wl*id) / (mew*wl)) + vt;
ft = (1/(2*pi)) * (mew*wl*(vgs-vt)) /...
    ((2/3)*wtimesl*cox+2*cov*w)