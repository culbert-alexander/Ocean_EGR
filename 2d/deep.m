%%
X = input_full;
Y = output;
C = cell(1);
C{1} = num2cell(X);

%%
%layer architectures
layer = lstmLayer(10);
maxEpochs = 300;
miniBatchSize = 10;
inputSize = 240000;
outputSize = 42;
outputMode = 'last';
numClasses = 1;
layers = [ ...
    sequenceInputLayer(inputSize)
    lstmLayer(outputSize,'OutputMode',outputMode)
    fullyConnectedLayer(numClasses)
    softmaxLayer
    classificationLayer]
options = trainingOptions('sgdm', ...
    'MaxEpochs',maxEpochs, ...
    'MiniBatchSize',miniBatchSize);
net = trainNetwork(C,Y,layers,options);