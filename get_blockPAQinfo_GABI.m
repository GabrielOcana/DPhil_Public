function [outputRaw, timeEvents, fs] = get_blockPAQinfo(filepath, filename,save_path, fig,nOptoPulses)
% Gabi mod of Huriye's get_blockPAQinfo() code 
%%output = get_blockPAQinfo(filename);
% INPUT: filename: a string for path + filename +.PAQ
%      e.g: 'C:\Users\Huriye\Documents\code\CLAimpactonPFC\data\logFiles\2021-03-06_21104_paq-001.paq'
% OUTPUT: output: a struct for all channel and timeSeries
%
%%
% close the figures if not specificied
if nargin==3
    fig=0;
end

% get raw data
info = paq2lab(fullfile(filepath,filename),'info');
includedchannels = 1:length(info.ObjInfo.Channel);
alldata = paq2lab(fullfile(filepath,filename),'Channels',includedchannels);
fs      = info.ObjInfo.SampleRate;

%% get eventTimes parameters
abovethresh = 0.2;
mindur = 0;
maxdur = Inf;
mindur = round(mindur * fs / 1000); %What's the point of this?
maxdur = round(maxdur * fs / 1000); %What's the point of this?

%nOptoPulses = 5;

ignoredeviations = 0;
starttime = 0;
stoptime  = Inf;
startpt = starttime * fs;
startpt = max([startpt 1]);%startpt is at least point number 1
stoppt  = stoptime * fs;
stoppt  = min([stoppt size(alldata,1)]);%stoppt not greater than samples acquired

beforems = 10;
afterms  = 50;
trigignoredelayms = 0;

beforepts = round(beforems * fs / 1000); 
afterpts  = round(afterms *fs / 1000);
trigignoredelaypts = round(trigignoredelayms * fs / 1000);

%% create eventTime structure - includes all avaliable channels -
% this might take some time based on the length of the recording.
outputRaw = struct;
timeEvents = struct;

for a=1:length(info.ObjInfo.Channel)%for each channel
    nam=info.ObjInfo.Channel(a).ChannelName;
    outputRaw.(nam) = alldata(:,a);
    
    % get triggers
    temp_trigdata = alldata(:,a);
    trigtimes = pt_continuousabove(temp_trigdata,zeros(size(temp_trigdata)),abovethresh,mindur,maxdur,ignoredeviations);
    if ~isempty(trigtimes)
        trigtimes = trigtimes(:,1);
        % clean very early + very late triggers
        trigtimes(trigtimes > stoppt) = [];
        trigtimes(trigtimes < startpt) = [];
        % check delaytime between triggers
        trigtraces = [];
        newtrigtimes = [];
        lastsavedtrig = -Inf;
        for tidx = 1:length(trigtimes)
            if trigtimes(tidx)>(lastsavedtrig+trigignoredelaypts)
                trigtraces(end+1,:) = temp_trigdata(trigtimes(tidx)-beforepts:trigtimes(tidx)+afterpts);
                lastsavedtrig = trigtimes(tidx);
                newtrigtimes(end+1) = lastsavedtrig;
            end
        end
        trigtimes =newtrigtimes;
    end
    timeEvents.(nam) = trigtimes;
end

%% OptoLoopTriggerPoints: optoStim has N short pulses - take the timeEvent of the first one.
if isfield(timeEvents, 'optoLoopback') && size(timeEvents.optoLoopback,2)>100
    timeEvents.optoLoopbackTrigger = timeEvents.optoLoopback (:,1:nOptoPulses:end);
    % now add nans for control trials
    % check shutter time
    if numel(timeEvents.optoLoopbackTrigger)~=numel(timeEvents.shutterLoopback)
        for i=1:numel(timeEvents.shutterLoopback)
            if i==numel(timeEvents.shutterLoopback) && numel(timeEvents.optoLoopbackTrigger)<numel(timeEvents.shutterLoopback)
                % in the last trial, if the stimulation is nan - it gives
                % error as it cannot see any trial in optoLoopbackTrigger
                % which will be added here
                timeEvents.optoLoopbackTrigger = [
                    timeEvents.optoLoopbackTrigger(1:i-1),nan];
            elseif abs(timeEvents.shutterLoopback(i)-timeEvents.optoLoopbackTrigger(i))>fs % if more than a sec - there is a control trial - put nan.
                timeEvents.optoLoopbackTrigger = [
                    timeEvents.optoLoopbackTrigger(1:i-1),nan,timeEvents.optoLoopbackTrigger(i:end)];
            end
        end
    end
else
    timeEvents.optoLoopbackTrigger = [];
end

%% MatchedTrialStartPoints: find the closesest time point in prairie time points for each events.
for k=1:numel(timeEvents.Whisker_in)
    temp = timeEvents.Frame_clock - timeEvents.Whisker_in(k);
    [val, loc] = min(abs(temp));
    if loc==numel(temp)% stimuli was delivered after PR recording stopped.
        timeEvents.matchedTrialStart(k) = NaN;
    elseif loc~=numel(temp) && temp(loc)<0 % take the next frame if it detects the previous frame as the closest frame
        timeEvents.matchedTrialStart(k) = timeEvents.Frame_clock(loc+1);
    else
        timeEvents.matchedTrialStart(k) = timeEvents.Frame_clock(loc);
    end
end

% warnings when pupil & prairieTrigger does not match
%if numel(timeEvents.prairieFrame)~=numel(timeEvents.pupilLoopback)
%    warning('Error in pupil triggering.')
%end

%% save the outcomes
save (fullfile(save_path,  [filename(1:end-12),'_',filename(22:24), '_paq.mat']), 'outputRaw','timeEvents','fs');

%% Check1: number of points - Pr Frames vs Pupil
%if fig==1
%    fprintf ('###%s \nDuration: %.2f sec \nPR FrameNumber: %.f \nPupil FrameNumber: %.f\n',...
%        filename,size(outputRaw.prairieFrame,1)/fs,...
%        size(timeEvents.prairieFrame,2),size(timeEvents.pupilLoopback,2) );
%    
%    figure;
%    subplot(2,1,1);hold on
%    plot(diff(timeEvents.pupilLoopback)/fs, 'k');
%    plot(diff(timeEvents.prairieFrame)/fs,'r');
%    ylabel('Time (sec)');box off
%    title('Extra pupil frames are black bars')
%    legend('Pupil frames','PR frames')
%    
%    subplot(2,1,2); hold on
%    plot(diff(timeEvents.prairieFrame)/fs,'k');
%    plot(diff(timeEvents.pupilLoopback)/fs, 'r');
%    ylabel('Time (sec)');box off
%    title('Extra PR frams are red ')
%    legend( 'PR frames','Pupil frames')
%    
%    print(gcf,'-dpng',fullfile(save_path,'pupilFramevsPRFrames'));
%    saveas(gcf, fullfile(save_path,'pupilFramevsPRFrames'), 'fig');
    
    %% if there is stimulation
    if  size(timeEvents.maskerLED,2)>1
        figure;
        subplot(2,1,1);hold on
        plot(diff(timeEvents.maskerLED)/fs, 'k');
        plot(diff(timeEvents.shutterLoopback)/fs,':r');
        plot(diff(timeEvents.optoLoopbackTrigger)/fs,'-.g');
        
        ylabel('Trial time (sec)')
        xlabel(' Trial number')
        legend('MaskerLED','shutterLoopback', 'optoLoopback')
        box off
        
        subplot(2,1,2); hold on
        plot(timeEvents.maskerLED/fs, 'k');
        plot(timeEvents.shutterLoopback/fs,':r');
        plot(timeEvents.optoLoopbackTrigger/fs,'-.g');
        
        ylabel('Time (sec)')
        xlabel(' Trial number')
        legend('MaskerLED','shutterLoopback', 'optoLoopback')
        box off
        
        print(gcf,'-dpng',fullfile(save_path,'StimuliSummary'));
        saveas(gcf, fullfile(save_path,'StimuliSummary'), 'fig');
    end
    close all
end

