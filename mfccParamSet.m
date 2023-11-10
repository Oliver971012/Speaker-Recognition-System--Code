function FP=mfccParamSet(fs)
% mfccParamSet: Set parameters for MFCC extraction
% 	Usage: FP=mfccParamSet(fs)

%	Roger Jang, 20070630

if nargin<1; fs=8000; end

FP.preEmCoef=0.95;
FP.frameSize = fs/(8000/256);		% Frame size
FP.overlap = 0;				% Frame overlap
FP.tbfNum = 20;				% Number of triangular band-pass filters
FP.cepsNum = 12;			% Dimension of cepstrum
FP.useDelta = 0;			% 0 (12fea), 1 (24fea), 2 (36fea)
FP.useEnergy = 1;			% 0, 1
FP.useCMS = 0;				% Cepstral Mean Substraction, 0, 1(cms of all), 2(overlap(cms)= 24), 3(original+cms)
FP.testNum = 4;				% test sentence number, others is train sentences.
FP.useVTLN = 0;				% Vocal Track Length Normalization, 1 , 0
FP.alpha = 1;				% For VTLN
FP.upSampling = 2;			% 1, 2
FP.mfccNum=12;				% length of DCT output