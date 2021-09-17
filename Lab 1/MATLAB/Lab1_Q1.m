audio = fopen('Recorded_audio_1.wav');
audio_data = fread(audio,'ubit1');

audio_binary = dec2bin(audio_data);

audio_size = size(audio_data);
disp = reshape(audio_binary',1,[])