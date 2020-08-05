%   Distribution code Version 1.0 -- 08/01/2020 by Wei Liu Copyright 2020
%
%   The code is created based on the method described in the following paper 
%   [1] "Embedding bilateral filter in least squares for efficient edge-preserving image smoothing." 
%        by Wei Liu, Pingping Zhang, Xiaogang Chen, Chunhua Shen, Xiaolin Huang, Jie Yang,
%        IEEE Transactions on Circuits and Systems for Video Technology (2018).
%  
%   The code and the algorithm are for non-comercial use only.


%  ---------------------- Input------------------------
%  Img:            input image, can be gray image or RGB color image
%  Guide:        Guidance image
%  sigma_s:     spatial kernel bandwidth
%  sigma_r:      range kernel bandwidth

%  ---------------------- Output------------------------
%  S:             smoothed image

function S = BLF_LS(Img, Guide, sigma_s, sigma_r)

% The input image and the guidance image need to be normalized into [0, 1]
if max(Img(:)) > 1 || max(Guide(:)) > 1
    error("Input image should be normalized into [0, 1]")
end

if size(Img) ~= size(Guide)
    error("Input image should be of the same size as guidance image\n")
end

% image channel number
[row, col, cha] = size(Img);

% The parameter in Eq. (7)
lambda = 1024;

% Gradients 
h_Img = [diff(Img,1,2), Img(:,1,:) - Img(:,end,:)];
v_Img = [diff(Img,1,1); Img(1,:,:) - Img(end,:,:)];

h_Guide = [diff(Guide,1,2), Guide(:,1,:) - Guide(:,end,:)];
v_Guide = [diff(Guide,1,1); Guide(1,:,:) - Guide(end,:,:)];

%  Normalize the guidance gradients into [0, 1]
h_Guide = h_Guide / 2 + 0.5;
v_Guide = v_Guide / 2 + 0.5;


% Gradients of the output image
h_S = zeros(row, col, cha);
v_S = zeros(row, col, cha);

% smooth the input gradients guided by the guidance gradients
for k = 1: cha  
    g_h = h_Guide(:, :, k);
    h_S(:, :, k) = bilateralFilter(h_Img(:, :, k), g_h, min(g_h(:)), max(g_h(:)), sigma_s, sigma_r);

    g_v = v_Guide(:, :, k);
    v_S(:, :, k) = bilateralFilter(v_Img(:, :, k), g_v, min(g_v(:)), max(g_v(:)), sigma_s, sigma_r);
end
    
S = grad_process(Img, v_S, h_S, lambda);
