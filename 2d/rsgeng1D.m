function [f,x] = rsgeng1D(N,rL,h,cl)
%
% [f,x] = rsgeng1D(N,rL,h,cl)
%
% generates a 1-dimensional random rough surface f(x) with N surface points.
% The surface has a Gaussian height distribution function and a Gaussian
% autocovariance function, where rL is the length of the surface, h is the
% RMS height and cl is the correlation length.
     %
% Input:
%   N   - number of surface points
%   rL  - length of surface
%   h   - rms height
%   cl  - correlation length
%
%
%
% Output:   f   - surface heights
%           x   - surface points
%
format long;


x = linspace(-rL/2,rL/2,N);
Z = h.*randn(1,N); % uncorrelated Gaussian random rough surface distribution
                     % with mean 0 and standard deviation h
% Gaussian filter
F = exp(-x.^2/(cl^2/2));
% correlation of surface using convolution (faltung), inverse

f = sqrt(2/sqrt(pi))*sqrt(rL/N/cl)*ifft(fft(Z).*fft(F));

end