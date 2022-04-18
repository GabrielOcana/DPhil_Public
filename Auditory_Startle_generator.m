
%% Multistim Randomized


clear all
hold off   

        
%% Initialize Variables
% Initialize pre-stim delays for sound light and whisker

blank_stim = zeros(1,30000);
light_stim = zeros(1,30000);
sound_stim = zeros(1,30000);
whisker_stim = zeros(1,30000);


%create light stim trace
light_1rep = zeros(1,15000);
light_1rep(1:15000) = 5;

%create sound stim trace
sound_1rep = generateSAMtoken(2,20,5000,0.5,30000); %Look at the inputs and set 120 dB (or 90, 105, and 120) 40ms duration 
                                                    %Interstim 30-60s 4kHz
%create whisker stim trace
whisker_1rep = 5.1 + (cos(linspace(pi/2,(pi/2)+(pi*2),15000)*10)*2);

%create blank stim trace
blank_1rep = zeros(1,15000);
blank_1rep(1:15000) = -5;

%generate random trial order
trial_randomizer = zeros(1,30); %generates 105 empty trials
for i = 1:5
    trial_randomizer(i) = randi([2,2]);
end

%% Generate Randomized Traces

%Generate 120 trials with 8 randomized trial types
for trial = 1:5
    
    if trial_randomizer(trial) == 1     % Trial type 1 is for light
        post_stim_delay= (randi([8,11])*30000);       % Chooses randomized post stim delay between 8000 and 11000 units (8-11 seconds)
        post_stim_delay = zeros(1,post_stim_delay);     % Generates post stim delay trace
        light_stim = horzcat(light_stim,light_1rep,post_stim_delay); % Adds 1 light stim and post stim delay to light stim trace
        non_stim_pause = zeros(1,(length(post_stim_delay)+15000));
        sound_stim = horzcat(sound_stim,non_stim_pause);
        whisker_stim = horzcat(whisker_stim,non_stim_pause);
        blank_stim = horzcat(blank_stim,non_stim_pause);

    elseif trial_randomizer(trial) == 2     %Trial type 2 is for sound
        post_stim_delay=(randi([8,11])*30000);
        post_stim_delay = zeros(1,post_stim_delay);
        sound_stim = horzcat(sound_stim,sound_1rep,post_stim_delay); %WHY DOES HE CONCAT SOUND STIM!!!??? THEN INITIALIZE AS zeros(1,1), NO? Otherwise all sounds start with a 30000 zeros...
        non_stim_pause = zeros(1,(length(post_stim_delay)+15000));
        whisker_stim = horzcat(whisker_stim,non_stim_pause);
        light_stim = horzcat(light_stim,non_stim_pause);
        blank_stim = horzcat(blank_stim,non_stim_pause);

    elseif trial_randomizer(trial) == 3     %Trial type 3 is for whisker
        post_stim_delay=(randi([8,11])*30000);
        post_stim_delay = zeros(1,post_stim_delay);
        whisker_stim = horzcat(whisker_stim,whisker_1rep,post_stim_delay);
        non_stim_pause = zeros(1,(length(post_stim_delay)+15000));
        sound_stim = horzcat(sound_stim,non_stim_pause);
        light_stim = horzcat(light_stim,non_stim_pause);
        blank_stim = horzcat(blank_stim,non_stim_pause);

    elseif trial_randomizer(trial) == 4     %Trial type 4 is no stimulus
        post_stim_delay=(randi([8,11])*30000);    % Chooses randomized post stim delay between 8000 and 11000 units (8-11 seconds)
        post_stim_delay = zeros(1,post_stim_delay);     % Generates post stim delay trace
        blank_stim = horzcat(blank_stim,blank_1rep,post_stim_delay);
        non_stim_pause = zeros(1,(length(post_stim_delay)+15000));       
        whisker_stim = horzcat(whisker_stim,non_stim_pause);    
        sound_stim = horzcat(sound_stim,non_stim_pause);
        light_stim = horzcat(light_stim,non_stim_pause);
    elseif trial_randomizer(trial) == 5     %Trial type 5 is for whisker + sound
        post_stim_delay=(randi([8,11])*30000);
        post_stim_delay = zeros(1,post_stim_delay);
        whisker_stim = horzcat(whisker_stim,whisker_1rep,post_stim_delay);
        sound_stim = horzcat(sound_stim,sound_1rep,post_stim_delay);
        non_stim_pause = zeros(1,(length(post_stim_delay)+15000));
        light_stim = horzcat(light_stim,non_stim_pause);
        blank_stim = horzcat(blank_stim,non_stim_pause);        
    elseif trial_randomizer(trial) == 6     %Trial type 6 is for whisker + light
        post_stim_delay=(randi([8,11])*30000);
        post_stim_delay = zeros(1,post_stim_delay);
        whisker_stim = horzcat(whisker_stim,whisker_1rep,post_stim_delay);
        light_stim = horzcat(light_stim,light_1rep,post_stim_delay);
        non_stim_pause = zeros(1,(length(post_stim_delay)+15000));
        sound_stim = horzcat(sound_stim,non_stim_pause);
        blank_stim = horzcat(blank_stim,non_stim_pause);   
    elseif trial_randomizer(trial) == 7     %Trial type 7 is for light + sound
        post_stim_delay=(randi([8,11])*30000);
        post_stim_delay = zeros(1,post_stim_delay);
        light_stim = horzcat(light_stim,light_1rep,post_stim_delay);
        sound_stim = horzcat(sound_stim,sound_1rep,post_stim_delay);
        non_stim_pause = zeros(1,(length(post_stim_delay)+15000));
        whisker_stim = horzcat(whisker_stim,non_stim_pause);
        blank_stim = horzcat(blank_stim,non_stim_pause);   
    elseif trial_randomizer(trial) == 8     %Trial type 8 is for light + sound + whisker
        post_stim_delay=(randi([8,11])*30000);
        post_stim_delay = zeros(1,post_stim_delay);
        light_stim = horzcat(light_stim,light_1rep,post_stim_delay);
        whisker_stim = horzcat(whisker_stim,whisker_1rep,post_stim_delay);
        sound_stim = horzcat(sound_stim,sound_1rep,post_stim_delay);
        non_stim_pause = zeros(1,(length(post_stim_delay)+15000));
        blank_stim = horzcat(blank_stim,non_stim_pause);   
    else
        disp ('Unknown Trial Type')      %prints error if randomizer produces non-trial type 
    end
end

%% Save traces as .dat files

%Generate file names with date/time
Sound_file = ['D:Data\gsantero\',datestr(now, 'yyyy-mm-dd'),'\',datestr(now, 'yyyy-mm-dd_HH-MM-SS'),'_GOS_sound_stim.dat'];
Light_file = ['D:Data\gsantero\',datestr(now, 'yyyy-mm-dd'),'\',datestr(now, 'yyyy-mm-dd_HH-MM-SS'),'_GOS_light_stim.dat'];
Whisker_file = ['D:Data\gsantero\',datestr(now, 'yyyy-mm-dd'),'\',datestr(now, 'yyyy-mm-dd_HH-MM-SS'),'_GOS_whisker_stim.dat'];
Blank_file = ['D:Data\gsantero\',datestr(now, 'yyyy-mm-dd'),'\',datestr(now, 'yyyy-mm-dd_HH-MM-SS'),'_GOS_blank_stim.dat'];

fid   = fopen(Blank_file,'w','l');
fwrite(fid,blank_stim,'double');
fclose(fid);

fid   = fopen(Whisker_file,'w','l');
fwrite(fid,whisker_stim,'double');
fclose(fid);

fid   = fopen(Light_file,'w','l');
fwrite(fid,light_stim,'double');
fclose(fid);

fid   = fopen(Sound_file,'w','l');
fwrite(fid,sound_stim,'double');
fclose(fid);


%% Plot traces 
% May need to comment out if saving .dats

plot(sound_stim)
hold on
plot(light_stim)
plot(whisker_stim)
plot(blank_stim)

%% No random startle
%
clear all
hold off 
sound_stim = zeros(1,30000);
%create sound stim trace
sound_1rep = generateSAMtoken(2,20,5000,0.5,30000); %Look at the inputs and set 120 dB (or 90, 105, and 120) 40ms duration 
                                                    %Interstim 30-60s 4kHz
post_stim_delay = 60000; 
for ii = 1:5
 sound_stim = horzcat(sound_stim,sound_1rep,post_stim_delay); %WHY DOES HE CONCAT SOUND STIM!!!??? THEN INITIALIZE AS zeros(1,1), NO? Otherwise all sounds start with a 30000 zeros (30s?)...
end

