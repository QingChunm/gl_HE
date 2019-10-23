
clear;
close all;
clc;

% [X MAP] = imread('shadow.tif');
% RGB = ind2rgb(X,MAP);
% 
% % RGB = imread('win.png');
% 
% cform2lab = makecform('srgb2lab');
% LAB = applycform(RGB, cform2lab);
% ll = LAB(:,:,1);
% L = LAB(:,:,1)/100;
% LAB(:,:,1) = adapthisteq(L,'NumTiles',...
%                          [8 8],'ClipLimit',0.005)*100;
% 
% cform2srgb = makecform('lab2srgb');
% J = applycform(LAB, cform2srgb);
% 
% figure, imshow(RGB);
% figure, imshow(J);
% 
% 
% level = 100;
% x = 1:level;
% [h w] = size(ll);
% his = zeros(level);
% cdf = zeros(level);
% 
% indmax = h*w;
% il = uint8(ll(:));
% for i=1:indmax
%    his( il(i)) = his( il(i))+1;
% end
% for i=1:level
%    cdf(i) = sum(his(1:i)); 
% end
% 
% figure,bar(x,his);
% figure,bar(x,cdf);



%%
%直方图均衡化

alpha = 0.010;

original = imread('win.png');
original = rgb2ycbcr(original);
original = original(:,:,1);
figure,imshow(original);
title('original');
[h w] = size(original);
%直方图统计
p = zeros(1,256);
for i = 1:256
   p(i) = sum(sum(original(:) == (i-1)));
end


% th = w*h*alpha;
% hh = p;
% index = find(p > th);
% over = sum((p(index)-th));
% hh(index) = th;
% index = find(h ~= 0);
% hh(index) = hh(index) + over/length(index);
% figure,bar(p);
% figure,bar(hh);

th = w*h*alpha;
hh = p;
index = find(p > th);
over = sum((p(index)-th));
hh(index) = th;
hh = hh + over/length(hh);
figure,bar(p);
figure,bar(hh);



p = double(p);
p = p./(h*w);
figure;
bar(p);hold on;%这里直接bar(p)会导致横坐标与灰度值差1
% axis([0 255 0 0.12]);
title('histogram');
% 直方图均衡化,相连梯度的频数相差越大，完成直方图映射后，两者的梯度距离越大
s = zeros(1,256);
for i = 1:256
     s(i) = sum(hh(1:i)/(w*h))*255;
end
figure,bar(s);
s = uint8(s);
for i = 1:h
    for j = 1:w
        original(i,j) = s(original(i,j)+1);
    end
end
figure;
imshow(original);hold on;
title('process');
p = zeros(1,256);
for i = 1:256
   p(i) = sum(sum(original(:) == (i-1)));
end
p = double(p);
p = p./(h*w);
figure,bar(p);

