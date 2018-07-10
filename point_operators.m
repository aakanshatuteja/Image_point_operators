clc
clear all
close all
A = imread ('Image.bmp');
B = zeros(948,1268);
C = zeros(255,1);
D = zeros(948,1268);
E = zeros(948,1268);
CDF = zeros(255,1);
G = zeros(948,1268);
a = 200;
b = 400;
figure
imshow(A);
title('ORIGINAL IMAGE');

% For thresholding
for i = 1:948
    for j = 1:1268
    if (A(i,j) >= 37 && A(i,j) <= 113 )
        B(i,j) = 1;
    else
        B(i,j) = 0;
    end
    end
end
figure
imshowpair(A, B, 'montage');
title('THRESHOLDING');

% For contrast stretching
c = min(min(A));
d = max(max(A));
range = d - c;
range = double (range);
limit = double(range/100)*5;
f = (d - c)/(d + c);
for i = 1:948
    for j = 1:1268
        if((((A(i , j) - f)*(b - a)/(d - c)) + a)>= 0 && (A(i,j)>(c +limit) || (A(i,j)<(d - limit))))          
            pixel = (A(i,j) - f);
            constant = (b - a)/(d - c);
            final = pixel*constant + a;
            D(i , j) = round(final);
        else
            D(i,j) = 0;
        end
    end
end
figure
imshowpair(A,D,'montage')
title('CONTRAST STRETCHING')

%For Gamma correction
A1 = im2double(A);
for i = 1:948
    for j = 1:1268
    E(i,j) = (A1(i,j))^0.5;
    end
end
figure
imshowpair(A,E,'montage');
title('GAMMA CORRECTION');

% For Histogram Equalization
% for running this part, comment the rest of the code leaving the histogram
% plotting part because the following code uses the matrix C which is
% initialized in that section of the code.

for i = 0:255
    s = 0;
    for j = 1:948
        for k = 1:1268
            if (A(j,k) == i)
                s = s+1;
                C(i) = s;
            end
        end
    end
end
F = C /(948*1268);
CDF(1) = F(1);
for i = 2:255
    CDF(i) = F(i) + CDF(i-1);
end
C1 = floor((255)*CDF);
for i = 1:255
    for j = 1:948
        for k = 1:1268
            if (A(j,k) == i && A(j,k) ~= C1(i))
                G(j,k) = C1(i);
            end
        end
    end
end
figure
imshowpair(A,G,'montage');
title('HISTOGRAM EQUALIZATION');
