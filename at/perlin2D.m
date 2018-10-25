%% Function to generate perlin noise
% Copyright Steven A. Cholewiak
% http://www.semifluid.com/2012/12/05/2d-and-3d-perlin-noise-in-matlab/
% Adapted by Alexander Culbert
% 10/16/2018

function s = perlin2D(m,n)
s = zeros([m,n]);
w = n;
i = 0;
while w > 3
    i = i + 1;
    d = interp2(randn([m,n]), i-1, 'spline');
    s = s + i * d(1:m, 1:n);
    w = w - ceil(w/2 - 1);
end
s = (s - min(min(s(:,:)))) ./ (max(max(s(:,:))) - min(min(s(:,:))));
s = s + 0.5;
end
