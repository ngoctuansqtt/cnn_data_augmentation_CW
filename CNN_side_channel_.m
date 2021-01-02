clear
TargetNames = categorical(["HW_3","HW_4", "HW_5"]); %% Phan loai gia tri HW3,4,5    
text = fullfile('dataset','key_4'); % byte1 key dung la 43 
%text = 'dataset2';
loadNewIamge = true;
if loadNewIamge == true
    imds = imageDatastore(strcat(text),'IncludeSubfolders',true,...
        'LabelSource','foldernames','FileExtensions',{'.mat'});
    save KeyStore.mat imds
else
    load KeyStore.mat
end
% Split dataset into 2 sub-sets of training 80% and testing 20%
[imdsTrain,imdsTest,ones] = splitEachLabel(imds,0.8,0.2,'randomized');
% Read data of training 
imdsTrain.Labels = categorical(imdsTrain.Labels);
imdsTrain.ReadFcn = @readFcnMatFile;
% Read data of testing 
imdsTest.Labels = categorical(imdsTest.Labels);
imdsTest.ReadFcn = @readFcnMatFile;

%% Network generation 
spf = 1000;
filterSize = [1 3];
poolSize = [1 2];
lgraph = [
   imageInputLayer([1 spf 1], 'Normalization', 'none', 'Name', 'Input Layer')
   convolution2dLayer(filterSize, 16, 'Padding', 'same', 'Name', 'CNN1')
   batchNormalizationLayer('Name', 'BN1')
   reluLayer('Name', 'eLU1')
   maxPooling2dLayer(poolSize, 'Stride', [1 2], 'Name', 'MaxPool1')
   
   convolution2dLayer(filterSize, 24, 'Padding', 'same', 'Name', 'CNN2')
   batchNormalizationLayer('Name', 'BN2')
   reluLayer('Name', 'eLU2')
   maxPooling2dLayer(poolSize, 'Stride', [1 2], 'Name', 'MaxPool2')
  
   convolution2dLayer(filterSize, 32, 'Padding', 'same', 'Name', 'CNN3')
   batchNormalizationLayer('Name', 'BN3')
   reluLayer('Name', 'eLU3')
   
   convolution2dLayer(filterSize, 25, 'Padding', 'same', 'Name', 'CNN4')
   batchNormalizationLayer('Name', 'BN4')
   reluLayer('Name', 'eLU4')
   
   convolution2dLayer(filterSize, 20, 'Padding', 'same', 'Name', 'CNN5')
   batchNormalizationLayer('Name', 'BN5')
   reluLayer('Name', 'eLU5')
   averagePooling2dLayer([1 2], 'Name', 'AP1')
   
   fullyConnectedLayer(3, 'Name', 'FC1')
   softmaxLayer('Name', 'SoftMax')
   
   classificationLayer('Name', 'Output') ];
% lgraph = [
%    imageInputLayer([1 51 1],"Name","imageinput")
%     fullyConnectedLayer(150,"Name","fc_1")
%     eluLayer(1,"Name","elu_1")
%     fullyConnectedLayer(300,"Name","fc_2")
%     eluLayer(1,"Name","elu_2")
%     fullyConnectedLayer(600,"Name","fc_3")
%     eluLayer(1,"Name","elu_3")
%     fullyConnectedLayer(300,"Name","fc_4")
%     eluLayer(1,"Name","elu_4")
%     fullyConnectedLayer(100,"Name","fc_5")
%     eluLayer(1,"Name","elu_5")
%     fullyConnectedLayer(25,"Name","fc_6")
%     eluLayer(1,"Name","elu_6")
%     fullyConnectedLayer(3,"Name","fc_7")
%     softmaxLayer("Name","softmax")
%     classificationLayer("Name","classoutput")];

 
   
% Set up training option


 options = trainingOptions('sgdm', ... 
     'MaxEpochs',30, ...
     'Shuffle','every-epoch',...
     'InitialLearnRate',0.1, ...
     'LearnRateSchedule','piecewise',...
     'LearnRateDropPeriod',10,...
     'LearnRateDropFactor',0.1,...
     'ValidationData',imdsTest, ...
     'ValidationPatience',Inf, ...
     'Verbose',true ,...
     'Plots','training-progress',...
     'ExecutionEnvironment','cpu');



%% Traing
tic
trainNow = true;
if trainNow == true
  trainedNet = trainNetwork(imdsTrain,lgraph,options);
  fprintf('%s - Training the network\n', datestr(toc/86400,'HH:MM:SS'))
  timeFormat = 'yyyy-mm-dd-HH-MM-SS'; %% Hien thi thoi gian
  now = datetime('now');
  Trained_file = sprintf('KeyTrainedNet_%s.mat', datestr(now,timeFormat));
  save(Trained_file, 'trainedNet');

end

% Measure the accuracy on the test set
YPredic = classify(trainedNet,imdsTest);
YTest = imdsTest.Labels;
% Compared the prediction vs the groudtruth
accuracy = sum(YPredic == YTest)/numel(YTest)*100 %%numel: so phan tu mang
%Plot the result in confusion matric
conf = confusionmat(YTest,YPredic);
confmat = conf(25:end,25:end);

figure;
cm = confusionchart(conf,TargetNames,'Normalization','row-normalized');
cm.FontName = 'Times New Roman';
cm.GridVisible = 'off';
cm.FontColor =[0 0 0];
colorbar = [0 0 0.3];
cm.DiagonalColor = colorbar;
cm.OffDiagonalColor = colorbar;
