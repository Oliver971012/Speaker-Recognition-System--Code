function filterBankParam = getTriFilterParam(frameSize, fs, filterNum, plotOpt)
% getTriParam: Get parameters of triangular filter bank

%	Roger Jang, 20030610
 
if nargin<1, selfdemo; return; end
if nargin<2, fs=8000; end
if nargin<3, filterNum=20; end
if nargin<4, plotOpt=0; end

maxMelFreq = freq2mel(fs/2);
sideWidth=maxMelFreq/(filterNum+1);
index=0:filterNum-1;
filterBankParam=floor(mel2freq([index; index+1; index+2]*sideWidth)/fs*frameSize)+1;
filterBankParam(end, end)= frameSize/2;	% 修整最後一個

if plotOpt
	subplot(2,1,1);
	plot(filterBankParam');
	xlabel('Filter bank indices');
	ylabel('Point indices');
	legend('Left indices', 'Center indices', 'Right indices');
	subplot(2,1,2); plot(filterBankParam, [0; 1; 0]);
	xlabel('Point indices');
end

% ====== Sub functions
% ====== Self demo
function selfdemo
frameSize=256;
fs=8000;
filterNum=30;
plotOpt=1;
filterBankParam=feval(mfilename, frameSize, fs, filterNum, plotOpt);

% ====== Normal frequency to mel-scaled frequency conversion
function mel = freq2mel(freq)
mel = 2595*log10(1+freq/700);

% ====== Mel-scaled frequency to normal frequency conversion
function freq = mel2freq(mel)
freq = 700*(10.^(mel/2595)-1);