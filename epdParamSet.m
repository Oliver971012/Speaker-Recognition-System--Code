function epdParam=epdParamSet(fs)
% epdParamSet: Set parameters for endpoint detection
% 	Usage: epd=mfccParamSet(fs)

%	Roger Jang, 20070630, 20080504

if nargin<1; fs=8000; end
 
epdParam.frameSize=fs/(16000/256);	% Frame size (fs=16000 ===> frameSize=256)
epdParam.overlap=0;			% Frame overlap

% The followings are mainly for epdByVol.m
epdParam.volRatio=10;

% The followings are mainly for epdByVolZcr.m
epdParam.volRatio2=5;
epdParam.zcrRatio=0.1;
epdParam.zcrShiftGain=4;

% The followings are mainly for epdByVolHod.m
epdParam.vhRatio=10;
epdParam.diffOrder=4;
epdParam.volWeight=0.5;
epdParam.extendNum=1;			% Extend front and back
epdParam.minSegment=0.05;		% Sound segments (in seonds) shorter than or equal to this value are removed
epdParam.maxSilBetweenWord=0.7;		% 
epdParam.minLastWordDuration=0.2;	%