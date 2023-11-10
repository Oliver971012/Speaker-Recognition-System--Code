function [epInSampleIndex, epInFrameIndex, soundSegment, zeroOneVec, volume] = epdByVol(y, fs, nbits, epdParam, plotOpt)
% epdByVol: EPD based on volume only
%	Usage: [epInSampleIndex, epInFrameIndex, soundSegment, zeroOneVec, volume] = epdByVol(y, fs, nbits, epdParam, plotOpt)
%		epInSampleIndex: two-element end-points in sample index
%		epInFrameIndex: two-element end-points in frame index
%		soundSegment: resulting sound segments
%		zeroOneVec: zero-one vector for each frame
%		volume: volume 
%		y: input audio signals
%		fs: sampling rate
%		epdParam: parameters for EPD
%		plotOpt: 0 for silent operation, 1 for plotting
%
%	Example:
%		waveFile='SingaporeIsAFinePlace.wav';
%		[y, fs, nbits]=wavReadInt(waveFile);
%		epdParam=epdParamSet(fs);
%		plotOpt=1;
%		out=epdByVol(y, fs, nbits, epdParam, plotOpt);

%	Roger Jang, 20040413, 20070320

% nargin is to check the number of input arguments
if nargin < 1, selfdemo; return; end 
if nargin < 2, fs = 16000; end
if nargin < 3, nbits = 16; end
if nargin < 4 || isempty(epdParam), epdParam = epdParamSet(fs); end
if nargin < 5, plotOpt = 0; end

if size(y, 2) ~= 1, error('Wave is not mono!'); end

% Set frame size to 256, overlap to 0
frameSize = epdParam.frameSize;
overlap = epdParam.overlap;
minSegment = round(epdParam.minSegment * fs / (frameSize - overlap));
maxSilBetweenWord = round(epdParam.maxSilBetweenWord * fs / (frameSize - overlap));
%minLastWordDuration = round(epdParam.minLastWordDuration * fs / (frameSize - overlap));

y = double(y);                    % convert to double data type
frameMat = buffer2(y, frameSize, overlap); % Call buffer2 function for framing
frameMat = frameZeroMean(frameMat, 2);     % Use polyfit to make frames zero-mean
frameNum = size(frameMat, 2);              % Calculate the number of frames
volume = frame2volume(frameMat, 1);        % Convert the calculated frames to volume
temp = sort(volume);                       % Sort the elements of A in ascending order along the first array dimension.
index = round(frameNum / 32); if index == 0, index = 1; end
volMin = temp(index);
volMax = temp(frameNum - index + 1);       % Avoid unvoiced
volTh = (volMax - volMin) / epdParam.volRatio + volMin; % Calculate volume threshold

% ====== Identify the voiced part greater than volTh
soundSegment = segmentFind(volume > volTh);

% ====== Remove short sound segments
index = [];
for i=1:length(soundSegment),
	if soundSegment(i).duration<=minSegment
		index = [index, i];
	end
end
soundSegment(index) = [];

zeroOneVec=0*volume;
for i=1:length(soundSegment)
	for j=soundSegment(i).begin:soundSegment(i).end
		zeroOneVec(j)=1;
	end
end

if isempty(soundSegment)
	epInSampleIndex=[];
	epInFrameIndex=[];
	fprintf('Warning: No sound segment found in %s.m.\n', mfilename);
else
	epInFrameIndex=[soundSegment(1).begin, soundSegment(end).end];
	epInSampleIndex=frame2sampleIndex(epInFrameIndex, frameSize, overlap);		% conversion from frame index to sample index
	for i=1:length(soundSegment),
		soundSegment(i).beginSample = frame2sampleIndex(soundSegment(i).begin, frameSize, overlap);
		soundSegment(i).endSample   = min(length(y), frame2sampleIndex(soundSegment(i).end, frameSize, overlap));
		soundSegment(i).beginFrame = soundSegment(i).begin;
		soundSegment(i).endFrame = soundSegment(i).end;
	end
	soundSegment=rmfield(soundSegment, 'begin');
	soundSegment=rmfield(soundSegment, 'end');
	soundSegment=rmfield(soundSegment, 'duration');
end

% Plotting...
if plotOpt,
	subplot(2,1,1);
	time=(1:length(y))/fs;
	frameTime=frame2sampleIndex(1:frameNum, frameSize, overlap)/fs;
	plot(time, y);
	for i=1:length(soundSegment)
		line(frameTime(soundSegment(i).beginFrame)*[1 1], 2^nbits/2*[-1, 1], 'color', 'm');
		line(frameTime(soundSegment(i).endFrame)*[1 1], 2^nbits/2*[-1, 1], 'color', 'g');
	end
	axisLimit=[min(time) max(time) -2^nbits/2, 2^nbits/2];
	if -1<=min(y) & max(y)<=1
		axisLimit=[min(time) max(time) -1, 1];
	end
	axis(axisLimit);
	ylabel('Amplitude');
	title('Waveform');

	subplot(2,1,2);
	plot(frameTime, volume, '.-');
	if all(volume)>=0
		axis([-inf inf 0 inf]);
	else
		axis tight;
	end
	line([min(frameTime), max(frameTime)], volTh*[1 1], 'color', 'r');
	line([min(frameTime), max(frameTime)], volMin*[1 1], 'color', 'c');
	line([min(frameTime), max(frameTime)], volMax*[1 1], 'color', 'k');
	for i=1:length(soundSegment)
		line(frameTime(soundSegment(i).beginFrame)*[1 1], [0, max(volume)], 'color', 'm');
		line(frameTime(soundSegment(i).endFrame)*[1 1], [0, max(volume)], 'color', 'g');
	end
	ylabel('Volume');
	title('Volume');
	
	U.y=y; U.fs=fs;
	if max(U.y)>1, U.y=U.y/(2^nbits/2); end
	if ~isempty(epInSampleIndex)
		U.voicedY=U.y(epInSampleIndex(1):epInSampleIndex(end));
	else
		U.voicedY=[];
	end
	set(gcf, 'userData', U);
	uicontrol('string', 'Play all', 'callback', 'U=get(gcf, ''userData''); sound(U.y, U.fs);');
	uicontrol('string', 'Play voiced', 'callback', 'U=get(gcf, ''userData''); sound(U.voicedY, U.fs);', 'position', [100, 20, 60, 20]);
end

% ====== Self demo
function selfdemo
waveFile='SingaporeIsAFinePlace.wav';
[y, fs, nbits]=wavReadInt(waveFile);
epdParam=epdParamSet(fs);
plotOpt=1;
out=feval(mfilename, y, fs, nbits, epdParam, plotOpt);