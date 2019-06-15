clc;
clear;
close all;
%% input
I = imread('https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Charminar-Pride_of_Hyderabad.jpg/220px-Charminar-Pride_of_Hyderabad.jpg');

Thr = 5;
filter = 45;
% Automatic set clustering number to the # of peaks in image histogram
Iblur = imgaussfilt(I, Thr);
K = numel(findpeaks(imhist(rgb2gray(Iblur)),'MinPeakProminence',filter));

%% Image input processing:
IDouble = im2double(I);
imageSize = [size(IDouble,1), size(IDouble,2)];
Array = reshape(IDouble,imageSize(1)*imageSize(2),3);       % Get the Color Featured Array for RBG

%% K-means
Means = Array(ceil(rand(K,1)*size(Array,1)),:);     % Random Cluster Centers
Label = zeros(size(Array,1),K+2);       % Label Array to record distances and the corresponding cluster
index = 15;     % Run for 15 times
%following variables are for ploting:
iter = 0;
allMeans = [];
previousMeans = [];
firstRound = true;

for n = 1:index
   for i = 1:size(Array,1)
      for j = 1:K
        Label(i,j) = norm(Array(i,:) - Means(j,:));             % Distance between pixels and mean points 
      end
      [Distance, Cluster] = min(Label(i,1:K));      % Find the belonging cluster and distance
      Label(i,K+1) = Cluster;                                % Set the label for current cluster
      Label(i,K+2) = Distance;                          % Record the distance between x and m
   end
   previousMeans = Means;
   for j = 1:K
      A = (Label(:,K+1) == j);                          % All pixels in cluster i
      Means(j,:) = mean(Array(A,:));                      % Recomputer new means
      if sum(isnan(Means(:))) ~= 0                    % Check means exist for now
         No = find(isnan(Means(:,1)) == 1);           % Find those not exist mean
         for k = 1:size(No,1)
         Means(No(k),:) = Array(randi(size(Array,1)),:);    % Assign a random number
         end
      end
   end
   
   %print the segmentated image:----------------------
   X = zeros(size(Array));
    for i = 1:K
        idx = find(Label(:,K+1) == i);
      X(idx,:) = repmat(Means(i,:),size(idx,1),1); 
    end
    result = reshape(X,imageSize(1),imageSize(2),3);
    countMeans = num2str(numel(unique(Means(:,1))));
    subplot(131), imshow(result), title(['Image with ' countMeans ' means']);

   %print the mean changes:----------------------
   iter = iter + 1;
   allMeans(iter) = mean(abs(Means(:)-previousMeans(:)));
   subplot(132), plot(1:iter, allMeans ), xlabel('iteration #'), title('Averaged mean movement');axis square
   drawnow
end
%%
%plot the clusters:
a = Label(:,K+1);
a = reshape(a,imageSize(1),imageSize(2));
b = label2rgb(a, 'jet', 'w', 'shuffle');
subplot(133), imshow(b),title('Clusters of the result');


%A = imnoise(I,'salt & pepper', 0.02);
%imshow(A)

%err = immse(A, I);
%fprintf('\n The mean-squared error is %0.4f\n', err);

%mse
X = imnoise(b,'salt & pepper', 0.02);
imshow(X)
err = immse(X, b);
fprintf('\n The mean-squared error is %0.4f\n', err);


%psnr
[peaksnr, snr] = psnr(X, b);
fprintf('\n The Peak-SNR value is %0.4f', peaksnr);
fprintf('\n The SNR value is %0.4f \n', snr);
