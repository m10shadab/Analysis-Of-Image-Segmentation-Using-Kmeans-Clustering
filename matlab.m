I = imread('https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Charminar-Pride_of_Hyderabad.jpg/220px-Charminar-Pride_of_Hyderabad.jpg');
imshow(I)
title('Original Image')


Thr=5;
Iblur = imgaussfilt(I, Thr);
%imshow(Iblur)
imhist(I)
filter=45;
K = numel(findpeaks(imhist(rgb2gray(Iblur)),'MinPeakProminence',filter));


[L,Centers] = imsegkmeans(I,K);
B = labeloverlay(I,L);
imshow(B)
title('Labeled Image')


%A = imnoise(I,'salt & pepper', 0.02);
%imshow(A)


%err = immse(A, I);
%fprintf('\n The mean-squared error is %0.4f\n', err);


%mse
%X = imnoise(B,'salt & pepper', 0.02); %salt&pepper
%X = imnoise(B,'poisson'); %poisson noise 
%X = imnoise(B,'gaussian', 0.2,0.01);    %gaussian

imshow(X)
err = immse(X, B);
fprintf('\n The mean-squared error is %0.4f\n', err);


%psnr

[peaksnr, snr] = psnr(X, B);
fprintf('\n The Peak-SNR value is %0.4f', peaksnr);
fprintf('\n The SNR value is %0.4f \n', snr);