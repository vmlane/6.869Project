addpath('./flow-code-matlab');
titles = {'Dimetrodon', 'Grove2', 'Grove3', 'Hydrangea', 'RubberWhale', 'Urban2', 'Urban3', 'Venus'};
% titles = {'Venus'};
nTitles = length(titles);
results = [];
for i = 1:nTitles
    im1 = double(rgb2gray(imread(['other-data/' titles{i} '/frame10.png'])))/255;
    im2 = double(rgb2gray(imread(['other-data/' titles{i} '/frame11.png'])))/255;
    global groundTruth;
    groundTruth = readFlowFile(['./other-gt-flow/' titles{i} '/flow10.flo']);
    groundTruth(abs(groundTruth) > 1000) = 0;

    options = struct();

    options.numPyramidLevels = 5;
    options.numGncLevels = 2;
    options.ratio = .5;
    options.sigma = sqrt(1/options.ratio)/sqrt(2);
    options.gncRatio = 1/1.25;
    options.gncSigma = sqrt(1/options.gncRatio)/sqrt(2);
    options.alpha = 0.1;
    options.penalty = 4;
    options.limit = false;
    
    m = 5;
%     options.medfiltsize = [];
    options.medfiltsize = [m m];

    options.numGncIters = 1;
    options.numWarpIters = 5;

    [u, v] = computeFlow(im1,im2,options);
    imshow(VisualizeFlow(u, v, 6));
    score = scoreFlow(u, v, groundTruth);
    results = [results score]
end